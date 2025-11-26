# SkinCare – App Support Site

Support website for SkinCare, an AI-powered cosmetic suggestions app.

## ⚠️ Cosmetic Use Only

**SkinCare provides cosmetic and aesthetic suggestions ONLY.** This app does NOT detect illnesses, analyze skin conditions, or provide medical advice of any kind. All output is for entertainment and cosmetic purposes only.

## Privacy Highlights

- **No data collected or stored** – we only process images, no data is retained
- **2D image only** – only the image file you upload is processed
- **Secure processing** – images are sent to our secure backend to be processed by an LLM
- **Not permanently stored** – images are not saved in databases or used for training

## Pages

- `index.html` – Main support page with FAQs
- `privacy.html` – Privacy Policy (emphasizes photo handling)
- `terms.html` – Terms of Service (medical disclaimers throughout)
- `404.html` – Error page

## Quick Deploy (GitHub Pages)

1. Create a new repo (public)
2. Add these files
3. GitHub → Settings → Pages → Deploy from branch: `main` / `/ (root)`
4. Site goes live at `https://<username>.github.io/<repo>/`

## Local Preview

```bash
python3 -m http.server 8080
```

No build step required – static HTML + CSS for maximum speed.

## Contact

Developer: Kaan YILDIZ
Email: kaanyildiz.iosdev@gmail.com
