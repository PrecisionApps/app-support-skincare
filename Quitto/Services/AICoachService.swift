//
//  AICoachService.swift
//  Quitto
//

import Foundation

// MARK: - Streaming Event

/// Represents a single chunk from the OpenAI streaming response.
enum AIStreamEvent {
    /// A new token fragment to append to the running message.
    case token(String)
    /// The stream has finished (received `[DONE]`).
    case done
    /// A non-fatal error occurred; the message so far is still usable.
    case error(String)
}

actor AICoachService {
    
    // MARK: - Configuration (hardcoded from AppConstants)
    
    private let apiKey: String = AppConstants.AI.apiKey
    private let baseURL: String = AppConstants.AI.baseURL
    
    /// Whether the service has a usable API key configured.
    var hasAPIKey: Bool {
        !apiKey.isEmpty && !apiKey.contains("REPLACE")
    }
    
    // MARK: - Streaming Response (Primary Path)
    
    /// Returns an `AsyncStream` of `AIStreamEvent` that yields token-by-token
    /// from the OpenAI chat completions endpoint using chunked SSE streaming.
    /// Falls back to local responses if the API key is missing or the request fails.
    func streamResponse(
        for message: String,
        habit: Habit?,
        conversationHistory: [CoachMessage]
    ) -> AsyncStream<AIStreamEvent> {
        
        // If no valid API key, emit a local response as a single token and finish.
        guard hasAPIKey else {
            let local = getLocalResponse(for: message, habit: habit)
            return AsyncStream { continuation in
                continuation.yield(.token(local))
                continuation.yield(.done)
                continuation.finish()
            }
        }
        
        // Capture everything we need before entering the stream closure.
        let systemPrompt = buildSystemPrompt(for: habit)
        let capturedBaseURL = baseURL
        let capturedAPIKey = apiKey
        
        var openAIMessages: [[String: String]] = [
            ["role": "system", "content": systemPrompt]
        ]
        
        for msg in conversationHistory.suffix(10) {
            openAIMessages.append([
                "role": msg.isFromUser ? "user" : "assistant",
                "content": msg.content
            ])
        }
        openAIMessages.append(["role": "user", "content": message])
        
        let requestBody: [String: Any] = [
            "model": AppConstants.AI.model,
            "messages": openAIMessages,
            "stream": true
        ]
        
        let localFallback = self.getLocalResponse(for: message, habit: habit)
        
        return AsyncStream { continuation in
            let task = Task.detached { [requestBody, capturedBaseURL, capturedAPIKey, localFallback] in
                guard let url = URL(string: "\(capturedBaseURL)/chat/completions"),
                      let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                    continuation.yield(.token(localFallback))
                    continuation.yield(.done)
                    continuation.finish()
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(capturedAPIKey)", forHTTPHeaderField: "Authorization")
                request.httpBody = jsonData
                request.timeoutInterval = 60
                
                do {
                    let (bytes, response) = try await URLSession.shared.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.yield(.token(localFallback))
                        continuation.yield(.done)
                        continuation.finish()
                        return
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        // Try to read error body for diagnostics
                        var errorBody = ""
                        for try await line in bytes.lines {
                            errorBody += line
                            if errorBody.count > 500 { break }
                        }
                        continuation.yield(.error("API returned status \(httpResponse.statusCode)"))
                        continuation.yield(.token(localFallback))
                        continuation.yield(.done)
                        continuation.finish()
                        return
                    }
                    
                    // Parse SSE (Server-Sent Events) stream line by line.
                    // Each relevant line looks like: data: {"id":...,"choices":[{"delta":{"content":"token"}}]}
                    // The final line is: data: [DONE]
                    for try await line in bytes.lines {
                        guard !Task.isCancelled else { break }
                        
                        // SSE lines that carry data always start with "data: "
                        guard line.hasPrefix("data: ") else { continue }
                        
                        let payload = String(line.dropFirst(6))
                        
                        if payload.trimmingCharacters(in: .whitespaces) == "[DONE]" {
                            continuation.yield(.done)
                            break
                        }
                        
                        // Parse the JSON chunk
                        guard let chunkData = payload.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: chunkData) as? [String: Any],
                              let choices = json["choices"] as? [[String: Any]],
                              let firstChoice = choices.first,
                              let delta = firstChoice["delta"] as? [String: Any],
                              let content = delta["content"] as? String else {
                            continue
                        }
                        
                        if !content.isEmpty {
                            continuation.yield(.token(content))
                        }
                    }
                    
                    // Ensure we always signal completion
                    continuation.yield(.done)
                    continuation.finish()
                    
                } catch is CancellationError {
                    continuation.yield(.done)
                    continuation.finish()
                } catch {
                    continuation.yield(.error(error.localizedDescription))
                    continuation.yield(.token(localFallback))
                    continuation.yield(.done)
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
    
    // MARK: - Non-Streaming Convenience (for craving auto-messages etc.)
    
    /// Collects the full streamed response into a single string. Useful for
    /// background messages (e.g. craving auto-send) where we don't need live UI updates.
    func getResponse(
        for message: String,
        habit: Habit?,
        conversationHistory: [CoachMessage]
    ) async -> String {
        var result = ""
        for await event in streamResponse(for: message, habit: habit, conversationHistory: conversationHistory) {
            switch event {
            case .token(let token):
                result += token
            case .done:
                break
            case .error:
                break
            }
        }
        return result.isEmpty ? getLocalResponse(for: message, habit: habit) : result
    }
    
    // MARK: - System Prompt Builder
    
    private func buildSystemPrompt(for habit: Habit?) -> String {
        var prompt = """
        You are a compassionate, knowledgeable addiction recovery coach in the Quitto app. Your role is to:
        
        1. Provide empathetic, non-judgmental support
        2. Offer evidence-based strategies for managing cravings
        3. Celebrate progress and milestones
        4. Help users understand their triggers and patterns
        5. Never shame or lecture—always encourage
        
        IMPORTANT CITATION REQUIREMENT:
        When you mention any health fact, medical claim, withdrawal timeline, or recovery benefit, you MUST include a brief source citation in parentheses at the end of that statement. Use short organization names like (AHA), (CDC), (WHO), (NIDA), (NIAAA), (APA), (NHS), (Mayo Clinic), etc.
        Example: "Your heart rate returns to normal within 20 minutes of quitting (AHA)."
        Do NOT fabricate sources. Only cite well-known health organizations.
        
        DISCLAIMER: You are not a medical professional. Always remind users to consult a healthcare provider for personalized medical advice when discussing health topics.
        
        Keep responses concise (2-3 paragraphs max). Use a warm, supportive tone.
        Ask thoughtful follow-up questions when appropriate.
        If someone relapses, be understanding and focus on getting back on track.
        """
        
        if let habit {
            prompt += """
            
            
            Current user context:
            - Quitting: \(habit.habitType.displayName)
            - Days clean: \(habit.daysSinceQuit)
            - Current streak: \(habit.streakDays) days
            - Units avoided: \(habit.unitsAvoided) \(habit.habitType.unitName)s
            - Money saved: $\(String(format: "%.2f", habit.moneySaved))
            - Their motivation: \(habit.motivation.isEmpty ? "Not specified" : habit.motivation)
            - Current phase: \(habit.currentPhase.name)
            """
        }
        
        return prompt
    }
    
    // MARK: - Local AI Responses (Offline Fallback)
    
    private func getLocalResponse(for message: String, habit: Habit?) -> String {
        let lowercased = message.lowercased()
        
        if lowercased.contains("craving") || lowercased.contains("urge") || lowercased.contains("want to") {
            return getCravingResponse(for: habit)
        }
        
        if lowercased.contains("relapse") || lowercased.contains("slipped") || lowercased.contains("gave in") || lowercased.contains("failed") {
            return getRelapseResponse()
        }
        
        if lowercased.contains("motivat") || lowercased.contains("why") || lowercased.contains("worth it") {
            return getMotivationResponse(for: habit)
        }
        
        if lowercased.contains("progress") || lowercased.contains("doing") || lowercased.contains("how am i") {
            return getProgressResponse(for: habit)
        }
        
        if lowercased.contains("stress") || lowercased.contains("hard") || lowercased.contains("difficult") || lowercased.contains("struggling") {
            return getStressResponse()
        }
        
        if lowercased.contains("hi") || lowercased.contains("hello") || lowercased.contains("hey") {
            return getGreetingResponse(for: habit)
        }
        
        return getDefaultResponse(for: habit)
    }
    
    private func getCravingResponse(for habit: Habit?) -> String {
        let strategies = [
            "Try the 4 D's: Delay the urge (it will pass), Deep breathe slowly, Drink water, Do something else to distract yourself. These evidence-based distraction techniques help interrupt the craving cycle (NIDA).",
            "This craving is temporary—most only last 10-15 minutes (NIDA). Your brain is rewiring itself right now, and every craving you overcome makes the next one weaker through neuroplasticity (Harvard Health).",
            "Ground yourself: notice 5 things you can see, 4 you can hear, 3 you can touch. This 5-4-3-2-1 grounding technique activates your parasympathetic nervous system (APA).",
            "Remember why you started this journey. Visualization and motivational interviewing techniques are proven to strengthen commitment to change (APA)."
        ]
        
        var response = strategies.randomElement()!
        
        if let habit {
            response += "\n\nYou've already made it \(habit.daysSinceQuit) days. That's \(habit.unitsAvoided) \(habit.habitType.unitName)s you've said no to. You're stronger than this craving."
        }
        
        return response
    }
    
    private func getRelapseResponse() -> String {
        let responses = [
            """
            I hear you, and I want you to know: a slip doesn't erase your progress. Recovery isn't a straight line—it's a journey with ups and downs.
            
            What matters now is what you do next. Be gentle with yourself, learn from this moment, and take the next small step forward. You haven't lost everything you've learned.
            """,
            """
            Thank you for being honest with me. That takes courage.
            
            One slip doesn't define you or your journey. Think about what led to this moment—was it stress, a trigger, a tough situation? Understanding the 'why' helps prevent future slips.
            
            Ready to start fresh right now?
            """,
            """
            This is a setback, not a failure. Every person who has successfully quit has had moments of struggle.
            
            The difference between those who succeed and those who don't? They get back up. You're here, talking about it—that shows your commitment. Let's focus on moving forward.
            """
        ]
        return responses.randomElement()!
    }
    
    private func getMotivationResponse(for habit: Habit?) -> String {
        var response = """
        Every moment of resistance is building something beautiful in your brain. Neural pathways are reforming through neuroplasticity—the brain's ability to rewire itself (Harvard Health). Your body is healing. Your future self is thanking you.
        """
        
        if let habit {
            response += "\n\n"
            
            if habit.moneySaved > 0 {
                response += "You've saved $\(String(format: "%.2f", habit.moneySaved)) that would have gone up in smoke (literally or figuratively). "
            }
            
            if habit.daysSinceQuit > 0 {
                response += "In \(habit.daysSinceQuit) days, you've proven \(habit.daysSinceQuit) times that you're stronger than the urge."
            }
            
            if !habit.motivation.isEmpty {
                response += "\n\nRemember your own words: \"\(habit.motivation)\""
            }
        }
        
        return response
    }
    
    private func getProgressResponse(for habit: Habit?) -> String {
        guard let habit else {
            return "I don't have your tracking data yet. Once you set up your habit, I can give you detailed progress insights!"
        }
        
        let phase = habit.currentPhase
        
        return """
        You're doing amazing! Here's where you stand:
        
        - **\(habit.daysSinceQuit) days** clean
        - **\(habit.streakDays) day** current streak
        - **$\(String(format: "%.2f", habit.moneySaved))** saved
        - **\(habit.timeSavedMinutes / 60) hours** of your life reclaimed
        
        You're in the "\(phase.name)" phase: \(phase.description)
        
        Keep going—you're \(100 - Int(habit.progressToNextMilestone * 100))% away from your next milestone!
        """
    }
    
    private func getStressResponse() -> String {
        [
            """
            I understand things feel overwhelming right now. Stress is one of the biggest triggers, and it's completely normal to struggle (NIDA).
            
            Try this: Take 5 slow, deep breaths. Inhale for 4 counts, hold for 4, exhale for 4. This box breathing technique activates your parasympathetic nervous system and calms your stress response (APA).
            
            What's causing the stress? Sometimes talking it through helps. *Remember: I'm not a substitute for professional help—please consult a healthcare provider for persistent stress.*
            """,
            """
            When we're stressed, our brain craves quick relief—that's why old habits call to us. The dopamine reward system is designed to seek shortcuts (NIDA). But that relief is temporary and comes with a cost.
            
            Instead, try: a 5-minute walk, splashing cold water on your face, or texting a supportive friend. Physical activity releases endorphins that provide natural relief (APA).
            
            You've handled stress before without the habit. You can do it again.
            """
        ].randomElement()!
    }
    
    private func getGreetingResponse(for habit: Habit?) -> String {
        if let habit {
            let timeOfDay = Calendar.current.component(.hour, from: Date())
            let greeting = timeOfDay < 12 ? "Good morning" : timeOfDay < 17 ? "Good afternoon" : "Good evening"
            
            return """
            \(greeting)!
            
            You're on day \(habit.daysSinceQuit) of your journey—that's something to be proud of. How are you feeling today? Is there anything on your mind?
            """
        } else {
            return "Hello! I'm your personal recovery coach. I'm here to support you through every step of your journey. How can I help you today?"
        }
    }
    
    private func getDefaultResponse(for habit: Habit?) -> String {
        let responses = [
            "I'm here for you. Whether you need support during a tough moment, want to reflect on your progress, or just need someone to talk to—I'm listening. What's on your mind?",
            "Thank you for sharing. Every conversation is part of your recovery journey. What would be most helpful to talk about right now?",
            "I hear you. Remember, you're not alone in this. How can I best support you today?"
        ]
        
        var response = responses.randomElement()!
        
        if let habit, habit.daysSinceQuit > 0 {
            response += "\n\nBy the way, you're doing great at \(habit.daysSinceQuit) days. Never forget that."
        }
        
        return response
    }
}
