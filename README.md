# Git101

Practice repo for the Git/GitHub crash course (ITPSS). Fork it, break it, ship it.

## 👉 BEFORE THE WORKSHOP: install the tools

**Lazy way (recommended) — one command, does everything below automatically:**

| OS | Run this |
|----|----------|
| **macOS** (Terminal) | `curl -s https://raw.githubusercontent.com/iman-izzat/Git101/main/setup.sh \| bash` |
| **Windows** (PowerShell) | `iwr https://raw.githubusercontent.com/iman-izzat/Git101/main/setup.ps1 -UseBasicParsing \| iex` |

The script installs Git, Node.js LTS and VS Code, then asks for your name + email once (that's what will appear on your commits).

**Manual way (if you prefer clicking):**

| Tool | Why | Link |
|------|-----|------|
| Homebrew (Mac only) | the installer the script uses | https://brew.sh |
| Git | commits, branches, the whole workshop | https://git-scm.com/downloads |
| Node.js (LTS) | runs `npm run commit` (the polite committer) | https://nodejs.org/en |
| VS Code | editor + conflict resolution | https://code.visualstudio.com/download |

Verify in a terminal: `git --version`, `node --version`, `npm --version`.

## 👉 STILL YOU (browser — no script can do these):

1. **GitHub account** → https://github.com/join
2. **Fork this repo** → https://github.com/iman-izzat/Git101 → *Fork* button → *Create fork*
3. **Wake the robot** — on **your fork**: Settings → Actions → General →
   - *Allow all actions*
   - *Workflow permissions: Read and write*
   (forks ship with Actions off — skip this and your releases silently never happen)
4. **Clone + prep once** (Terminal / PowerShell):
   ```
   git clone https://github.com/YOUR-USERNAME/Git101.git
   cd Git101
   npm ci
   ```
5. **In-house AI tool** → ask IT for the installer.

## Rules of the repo

1. Every commit message must follow [Conventional Commits](https://www.conventionalcommits.org) — `git commit` will **refuse** anything else (husky + commitlint).
2. The safest way to write a valid message: `npm run commit` (interactive prompts via commitizen).
3. Merging to `main` triggers `semantic-release`: `fix:` → patch, `feat:` → minor, `feat!:` / `BREAKING CHANGE:` → major. Watch **Actions** and **Releases**.

## Trainee roster

Add a line below with your name and one sentence on why you're here. Keep it to one line.

- Iman — teaching Git so AI can write the code in peace.
