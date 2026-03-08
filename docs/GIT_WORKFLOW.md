# 🔄 Git Workflow Guide

## Initial Setup (One-time)

### Person 1: Create Repository

```bash
# Navigate to project
cd ~/Desktop/Projects/RingAI

# Initialize git
git init

# Create .gitignore
touch .gitignore

# Add all files
git add .

# First commit
git commit -m "Initial project setup"

# Create GitHub repo (via website)
# Then push
git remote add origin https://github.com/yourteam/scamshield.git
git branch -M main
git push -u origin main
```

### Everyone Else: Clone Repository

```bash
cd ~/Desktop/Projects
git clone https://github.com/yourteam/scamshield.git
cd scamshield
```

---

## Daily Workflow

### Start of Day

```bash
# Switch to main branch
git checkout main

# Get latest changes
git pull origin main

# Switch to your personal branch (or create if first time)
git checkout -b person1-ui  # person1-ui, person2-api, etc.

# If branch exists already
git checkout person1-ui
git merge main  # Merge any changes from main
```

### While Working

```bash
# Check what you've changed
git status

# See your changes
git diff

# Add files you want to commit
git add lib/screens/lookup_screen.dart
git add lib/widgets/result_card.dart

# Or add all changes
git add .

# Commit with descriptive message
git commit -m "Add lookup screen with phone input validation"

# Push to your branch
git push origin person1-ui
```

### End of Day

```bash
# Commit all your work
git add .
git commit -m "End of day: Completed result screen UI"
git push origin person1-ui
```

---

## Commit Message Guidelines

### Good Commit Messages:
```
✅ "Add lookup screen with phone input validation"
✅ "Implement NumVerify API integration"
✅ "Fix: Correct phone number formatting bug"
✅ "Update: Improve result card styling"
✅ "Refactor: Extract API logic into separate service"
```

### Bad Commit Messages:
```
❌ "Update"
❌ "Fix stuff"
❌ "asdf"
❌ "changes"
❌ "idk what i did"
```

### Format:
```
[Action]: [What you did]

Actions:
- Add: New feature
- Update: Improve existing feature
- Fix: Bug fix
- Refactor: Code cleanup
- Test: Add tests
- Docs: Documentation
```

---

## Merging Your Work to Main

### Option 1: Pull Request (Recommended)

1. **Push your branch:**
   ```bash
   git push origin person1-ui
   ```

2. **Create Pull Request on GitHub:**
   - Go to GitHub repository
   - Click "Pull Requests" → "New Pull Request"
   - Select your branch (person1-ui) → main
   - Add title: "Add lookup and result screens"
   - Add description of what you did
   - Assign someone to review
   - Click "Create Pull Request"

3. **Team Review:**
   - Teammate reviews code
   - Approves or requests changes
   - Once approved, click "Merge"

4. **Update your local:**
   ```bash
   git checkout main
   git pull origin main
   ```

### Option 2: Direct Merge (Faster, for small teams)

```bash
# Make sure your work is committed
git add .
git commit -m "Your message"

# Switch to main
git checkout main

# Pull latest
git pull origin main

# Merge your branch
git merge person1-ui

# Push to GitHub
git push origin main

# Switch back to your branch
git checkout person1-ui
```

---

## Handling Conflicts

### What is a Conflict?

When two people edit the same file, Git doesn't know which version to keep.

### How to Resolve:

1. **Pull latest main:**
   ```bash
   git checkout main
   git pull origin main
   git checkout person1-ui
   git merge main
   ```

2. **If conflict occurs:**
   ```bash
   # Git will show: CONFLICT (content): Merge conflict in lib/main.dart
   
   # Open the file, you'll see:
   <<<<<<< HEAD
   Your code here
   =======
   Their code here
   >>>>>>> main
   ```

3. **Fix the conflict:**
   - Decide which code to keep (or keep both)
   - Remove the `<<<<<<<`, `=======`, `>>>>>>>` markers
   - Save the file

4. **Complete the merge:**
   ```bash
   git add lib/main.dart
   git commit -m "Resolve merge conflict in main.dart"
   git push origin person1-ui
   ```

### Avoiding Conflicts:

- **Communicate**: Tell team what files you're editing
- **Pull often**: `git pull` multiple times per day
- **Small commits**: Commit frequently
- **Divide work**: Different people work on different files

---

## Branch Strategy

```
main (always working code)
  │
  ├── person1-ui (Person 1's work)
  ├── person2-api (Person 2's work)
  ├── person3-database (Person 3's work)
  └── person4-docs (Person 4's work)
```

### Rules:

1. **main branch**: Only working, tested code
2. **Personal branches**: Your work in progress
3. **Never commit directly to main** (without review)
4. **Merge to main frequently** (at least every 2 days)

---

## Common Commands Cheat Sheet

### Check Status
```bash
git status              # What changed?
git log --oneline       # Recent commits
git diff                # What did I change?
git branch              # List branches
```

### Moving Around
```bash
git checkout main       # Go to main branch
git checkout -b new-branch  # Create new branch
```

### Saving Work
```bash
git add .               # Stage all changes
git commit -m "message" # Save changes
git push origin branch  # Upload to GitHub
```

### Getting Updates
```bash
git pull origin main    # Download latest
git merge main          # Merge main into current branch
```

### Undo Mistakes
```bash
git checkout -- file.dart    # Undo changes to file
git reset HEAD file.dart     # Unstage file
git revert HEAD              # Undo last commit (safe)
```

### Emergency Commands
```bash
git stash               # Temporarily save changes
git stash pop           # Restore saved changes
git reset --hard HEAD   # ⚠️ DELETE all changes (careful!)
```

---

## Working on Shared Mac(s)

### If Sharing 1-2 Macs:

**Option 1: Time slots**
```
Person 1: 9am-12pm
Person 2: 12pm-3pm
Person 3: 3pm-6pm
Person 4: 6pm-9pm
```

**Option 2: Pair programming**
```
Mon-Tue: Person 1 + Person 2
Wed-Thu: Person 3 + Person 4
Fri: Everyone
```

**Before leaving Mac:**
```bash
# Commit all work
git add .
git commit -m "Work in progress"
git push origin your-branch

# Next person pulls
git checkout their-branch
git pull origin their-branch
```

---

## GitHub Desktop (Alternative to Command Line)

If command line is intimidating:

1. Download GitHub Desktop: https://desktop.github.com/
2. Clone repository
3. Make changes in your code editor
4. Go to GitHub Desktop
5. See all changes
6. Write commit message
7. Click "Commit to branch"
8. Click "Push origin"

Much easier for beginners!

---

## Troubleshooting

### "Permission denied"
```bash
# Setup SSH key or use HTTPS with password
git remote set-url origin https://github.com/yourteam/scamshield.git
```

### "Your branch is behind"
```bash
git pull origin main
```

### "Merge conflict"
See "Handling Conflicts" section above

### "Detached HEAD state"
```bash
git checkout main
```

### "I messed up everything"
```bash
# Backup your changes somewhere
# Then:
git checkout main
git pull origin main
# Start fresh
```

---

## Best Practices

### ✅ DO:
- Commit frequently (multiple times per day)
- Write clear commit messages
- Pull before you start working
- Push at end of day
- Communicate with team
- Ask for help if stuck

### ❌ DON'T:
- Commit broken code to main
- Use vague commit messages
- Wait days before committing
- Work on main branch directly
- Delete others' code without asking
- Force push (`git push -f`) unless you know what you're doing

---

## Weekly Git Routine

### Monday:
```bash
git checkout main
git pull origin main
git checkout your-branch
git merge main
# Start week's work
```

### Daily:
```bash
# Morning
git pull origin main

# Evening
git add .
git commit -m "Your progress"
git push origin your-branch
```

### Friday:
```bash
# Merge your week's work
git checkout main
git pull origin main
git merge your-branch
git push origin main

# Or create Pull Request
```

---

## Git Aliases (Time Savers)

Add to `~/.gitconfig`:

```ini
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --oneline --graph --all
```

Usage:
```bash
git st    # instead of git status
git co main    # instead of git checkout main
git ci -m "message"    # instead of git commit -m "message"
```

---

## Team Git Agreement

As a team, agree on:

1. **Merge frequency**: Every 2 days
2. **Review required**: Yes/No
3. **Commit message format**: [Action]: [Description]
4. **Who resolves conflicts**: Person who created them
5. **Main branch protection**: Only working code
6. **Communication**: Tell team before big changes

---

**Remember**: Git is your safety net. Commit often. It's better to have too many commits than lose work! 💾
