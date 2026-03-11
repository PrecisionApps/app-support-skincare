# Quitto – App Support Site

Support website for Quitto, an addiction recovery and habit-tracking app.

## ⚠️ Not Medical Advice

**Quitto provides general wellness and educational information ONLY.** This app does NOT provide medical advice, diagnosis, or treatment. All health information includes citations from recognized medical organizations. Always consult a qualified healthcare provider for medical decisions.

## Key Features

- **Cited Sources** – All health claims reference AHA, CDC, NIDA, NIAAA, WHO, APA, ALA, FDA, Johns Hopkins, Mayo Clinic
- **Local Data Storage** – All personal data stored on device via SwiftData
- **AI Coach with Citations** – AI responses include source citations for health claims
- **Medical Disclaimer** – Displayed throughout the app and on all health-related content

## Pages

- `index.html` – Main support page with FAQs, sources list, and crisis resources
- `privacy.html` – Privacy Policy (local data storage, AI Coach data handling)
- `terms.html` – Terms of Service (medical disclaimers, assumption of risk)
- `404.html` – Error page
- `sitemap.xml` – Sitemap for precisionapps.github.io/Quitto
- `robots.txt` – Search engine crawling rules

## Deploy

Host at `https://precisionapps.github.io/Quitto/`

### GitHub Pages

1. Create a new repo (public)
2. Add these files
3. GitHub → Settings → Pages → Deploy from branch: `main` / `/ (root)`
4. Site goes live at `https://precisionapps.github.io/Quitto/`

### Local Preview

```bash
python3 -m http.server 8080
```

No build step required – static HTML + CSS.

## Contact

Developer: Kaan YILDIZ  
Email: kaanyildiz.iosdev@gmail.com  
Website: https://precisionapps.github.io/Quitto
