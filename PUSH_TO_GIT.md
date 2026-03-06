# Push this project to GitHub / GitLab / Bitbucket

Git is initialized and the first commit is done. Follow the steps below for your chosen host.

---

## GitHub

1. **Create a new repository**
   - Go to [github.com](https://github.com) and sign in (e.g. with gugabaratashvili@gmail.com).
   - Click **+** → **New repository**.
   - Name it (e.g. `cv` or `student-cv-app`).
   - Leave it **empty** (no README, .gitignore, or license).
   - Click **Create repository**.

2. **Push from your machine** (in the project folder):

   ```bash
   cd C:\Users\gugab\flutter_projects\cv
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git branch -M main
   git push -u origin main
   ```

   Replace `YOUR_USERNAME` and `YOUR_REPO_NAME` with your GitHub username and repo name (e.g. `gugabaratashvili` and `cv`).

   If GitHub asks for credentials, use a **Personal Access Token** (Settings → Developer settings → Personal access tokens) instead of your password.

---

## GitLab

1. **Create a new project**
   - Go to [gitlab.com](https://gitlab.com) and sign in.
   - Click **New project** → **Create blank project**.
   - Set **Project name** (e.g. `cv`), leave **Initialize with README** unchecked.
   - Click **Create project**.

2. **Push from your machine**:

   ```bash
   cd C:\Users\gugab\flutter_projects\cv
   git remote add origin https://gitlab.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git branch -M main
   git push -u origin main
   ```

   Replace `YOUR_USERNAME` and `YOUR_REPO_NAME` with your GitLab username and project path.

---

## Bitbucket

1. **Create a new repository**
   - Go to [bitbucket.org](https://bitbucket.org) and sign in.
   - Click **Create** → **Repository**.
   - Set **Repository name** (e.g. `cv`), leave **Include a README** unchecked.
   - Click **Create repository**.

2. **Push from your machine**:

   ```bash
   cd C:\Users\gugab\flutter_projects\cv
   git remote add origin https://bitbucket.org/YOUR_WORKSPACE/YOUR_REPO_NAME.git
   git branch -M main
   git push -u origin main
   ```

   Replace `YOUR_WORKSPACE` and `YOUR_REPO_NAME` with your Bitbucket workspace and repo name.

---

## After pushing

- **Netlify:** In Netlify, add a new site and **Import from Git**. Choose this repo; Netlify will use the `netlify.toml` in the project. See `DEPLOY_NETLIFY.md` for details.
- **Security:** If the repo is public, consider moving SMTP credentials from `lib/widgets/cv_form.dart` to environment variables or a private config so they are not in the repo.
