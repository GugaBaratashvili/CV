# Push this project to GitHub (fix 404)

The 404 happens because **the repository does not exist yet** on GitHub. Create it first, then push.

---

## Step 1: Create the repository on GitHub

1. Open this link (it will create a new repo with name **cv**):
   - **https://github.com/new?name=cv**
2. Sign in to GitHub if asked (use **gugabaratashvili@gmail.com** or your GitHub account).
3. Check:
   - **Repository name:** `cv` (or leave as is).
   - **Public**.
   - **Do not** check “Add a README file”.
   - **Do not** add .gitignore or license.
4. Click **Create repository**.

---

## Step 2: Push your code

In a terminal (PowerShell or Command Prompt), run:

```bash
cd C:\Users\gugab\flutter_projects\cv
git push -u origin main
```

If GitHub asks for credentials:
- **Username:** your GitHub username (e.g. `gugabaratashvili`).
- **Password:** use a **Personal Access Token**, not your GitHub password.
  - To create one: GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)** → **Generate new token**. Give it `repo` scope, then paste the token when Git asks for password.

---

## If your GitHub username is not `gugabaratashvili`

Update the remote URL, then push:

```bash
cd C:\Users\gugab\flutter_projects\cv
git remote set-url origin https://github.com/YOUR_GITHUB_USERNAME/cv.git
git push -u origin main
```

Replace `YOUR_GITHUB_USERNAME` with your real GitHub username.
