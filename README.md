# Git101

Practice repo for the Git/GitHub crash course. Fork it, break it, ship it.

## Rules of the repo

1. Every commit message must follow [Conventional Commits](https://www.conventionalcommits.org) — `git commit` will **refuse** anything else (husky + commitlint).
2. The safest way to write a valid message: `npm run commit` (interactive prompts via commitizen).
3. Merging to `main` triggers `semantic-release`: `fix:` → patch, `feat:` → minor, `feat!:` / `BREAKING CHANGE` → major. Watch **Actions** and **Releases**.

## Trainee roster

Add a line below with your name and one sentence on why you're here. Keep it to one line.

- Iman — teaching Git so AI can write the code in peace.
