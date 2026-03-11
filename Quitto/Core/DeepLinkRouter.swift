//
//  DeepLinkRouter.swift
//  Quitto
//

import Foundation

// MARK: - Deep Link Route

/// All supported `quitto://` URL routes.
///
/// ## Supported URLs
///
/// **Tab Navigation**
/// - `quitto://dashboard`
/// - `quitto://coach`
/// - `quitto://journal`
/// - `quitto://milestones`
///
/// **Sheets & Overlays**
/// - `quitto://craving`                    → Open craving log sheet
/// - `quitto://journal/new`                → Open new journal entry sheet
/// - `quitto://settings`                   → Open settings sheet
/// - `quitto://paywall`                    → Show paywall
///
/// **Coach with Pre-filled Message**
/// - `quitto://coach?message=I+need+help`  → Open coach tab with pending message
///
/// **Generic Event Dispatch**
/// - `quitto://event?name=X`               → Fire a named event (extensible)
/// - `quitto://event?name=X&param1=Y`      → Fire a named event with parameters
///
enum DeepLinkRoute: Equatable {
    // Tab navigation
    case tab(AppTab)
    
    // Sheet presentations
    case craving
    case newJournal
    case settings
    case paywall
    
    // Coach with optional pre-filled message
    case coach(message: String?)
    
    // Generic named event with arbitrary key-value params
    case event(name: String, params: [String: String])
    
    // Unrecognized route
    case unknown(String)
    
    // MARK: - URL Parsing
    
    /// Parse a `quitto://` URL into a typed route.
    ///
    /// Examples:
    /// ```
    /// quitto://dashboard          → .tab(.dashboard)
    /// quitto://coach?message=hi   → .coach(message: "hi")
    /// quitto://craving            → .craving
    /// quitto://journal/new        → .newJournal
    /// quitto://event?name=streak_reminder&days=7 → .event(name: "streak_reminder", params: ["days": "7"])
    /// ```
    static func from(_ url: URL) -> DeepLinkRoute? {
        guard url.scheme?.lowercased() == "quitto" else { return nil }
        
        let host = url.host()?.lowercased() ?? ""
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        let queryParams = Self.parseQueryItems(from: url)
        
        switch host {
            
        // MARK: Tab Routes
        case "dashboard":
            return .tab(.dashboard)
            
        case "coach":
            let message = queryParams["message"]
            if let message, !message.isEmpty {
                return .coach(message: message)
            }
            return .coach(message: nil)
            
        case "journal":
            if pathComponents.first == "new" {
                return .newJournal
            }
            return .tab(.journal)
            
        case "milestones":
            return .tab(.milestones)
            
        // MARK: Sheet Routes
        case "craving":
            return .craving
            
        case "settings":
            return .settings
            
        case "paywall", "premium", "upgrade":
            return .paywall
            
        // MARK: Generic Event
        case "event":
            guard let name = queryParams["name"], !name.isEmpty else {
                return .unknown("event (missing name)")
            }
            var params = queryParams
            params.removeValue(forKey: "name")
            return .event(name: name, params: params)
            
        default:
            return .unknown(host)
        }
    }
    
    // MARK: - Helpers
    
    private static func parseQueryItems(from url: URL) -> [String: String] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let items = components.queryItems else {
            return [:]
        }
        var dict: [String: String] = [:]
        for item in items {
            if let value = item.value {
                dict[item.name.lowercased()] = value
            }
        }
        return dict
    }
}
