# Deploy this app to Netlify (free)

## 1. Build and deploy from Git (recommended)

1. **Push this project to a Git host** (GitHub, GitLab, or Bitbucket) and sign in at [netlify.com](https://www.netlify.com) with **gugabaratashvili@gmail.com** (or your Google account).

2. **New site from Git**
   - In Netlify: **Add new site** → **Import an existing project**.
   - Connect your repository and pick the repo that contains this Flutter app.

3. **Build settings** (Netlify will use these from `netlify.toml` in the repo):
   - **Build command:** `bash scripts/netlify-build.sh`
   - **Publish directory:** `build/web`
   - No need to set **Base directory** unless the app lives in a subfolder.

4. **Deploy**
   - Click **Deploy site**. The first build may take several minutes (Flutter is installed and then `flutter build web` runs).
   - Your app will be available at a free URL like `https://<random>.netlify.app`. You can set a custom domain later.

## 2. Manual deploy (no Git)

1. **Build locally:**
   ```bash
   flutter build web --release
   ```

2. **Install Netlify CLI and log in:**
   ```bash
   npm i -g netlify-cli
   netlify login
   ```
   Use **gugabaratashvili@gmail.com** when logging in.

3. **Deploy the built folder:**
   ```bash
   netlify deploy --dir=build/web --prod
   ```
   Follow the prompts to create or link a site. You’ll get a live URL when you use `--prod`.

---

## Netlify Forms (free tier)

- A **Netlify form** is included in `web/index.html` with `name="cv-form"`.
- When a user submits a **Student CV** or **Spouse CV** on the web app, a submission is sent to this form (type: `student` or `spouse` + timestamp). Submissions appear under **Netlify dashboard → Forms → cv-form**.

## Honeypot (free)

- A **honeypot** field `bot-field` is on the form (`data-netlify-honeypot="bot-field"`).
- Bots that fill it are filtered out by Netlify; real users don’t see it. No extra setup.

## CAPTCHA (free options)

- **reCAPTCHA 2** or **Turnstile** can be enabled in the Netlify dashboard:
  - **Site → Forms → Form notifications / Spam settings** (or **Form options** for the form).
  - Enable **reCAPTCHA 2** or **Turnstile** there.
- Submissions are sent from the Flutter web app via JavaScript; if you enable CAPTCHA, you may need to show a CAPTCHA step in the app and pass the token. The current setup works without CAPTCHA; honeypot is the main spam filter.

---

## Summary

| Feature            | Free on Netlify | Implemented / How                          |
|--------------------|-----------------|--------------------------------------------|
| Hosting            | Yes             | `netlify.toml` + `scripts/netlify-build.sh` |
| Netlify Forms      | Yes (100/mo)    | Form in `web/index.html`, submit from app  |
| Honeypot           | Yes             | `data-netlify-honeypot="bot-field"`        |
| CAPTCHA            | Yes (reCAPTCHA/Turnstile) | Enable in Netlify dashboard; optional in app |
