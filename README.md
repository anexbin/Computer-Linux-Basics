# Phase 0 — Computer & Linux Basics

This phase sets up your entire learning environment. Everything in this curriculum happens on Linux, so getting comfortable with a Linux VM and the terminal is the foundation for everything that follows.

---

## Project 0.1 — First Lab: Install Your Linux Machine

**Goal:** Have a working Ubuntu Linux VM with a snapshot you can always return to.

### Checklist

- [ ] Download VirtualBox
- [ ] Download Ubuntu 24.04 LTS ISO
- [ ] Create VM (4 GB RAM, 2 CPUs, 40 GB disk)
- [ ] Enable bidirectional clipboard and drag-and-drop
- [ ] Install Ubuntu (Minimal installation)
- [ ] Run `sudo apt update && sudo apt upgrade -y`
- [ ] Install Guest Additions
- [ ] Create `~/projects` folder
- [ ] Set up shared folder with host OS
- [ ] Take snapshot named `clean-install`

### Key Commands

```bash
lsb_release -a          # Check Ubuntu version
whoami                  # Check current user
pwd                     # Print working directory
ls /                    # List root directory
ping -c 3 google.com    # Check internet
```

### Deliverables

- Working Ubuntu VM
- `~/projects` folder created
- Snapshot `clean-install` saved
- Shared folder working

### Validation

- Reboot VM, open terminal, run `whoami`, `pwd`, `ls /`
- Confirm internet with `ping -c 3 google.com`
- Confirm shared folder appears at `/media/sf_*`

### Notes

_Write your notes here as you go._

---

## Project 0.2 — Shell Toolkit: Master the Command Line

**Goal:** Build 6 shell scripts and learn the ~40 commands that appear in every Linux tutorial for the rest of this curriculum.

### Checklist

- [ ] Practice navigation commands daily (`cd`, `ls`, `pwd`, `mkdir`, `cp`, `mv`, `rm`, `cat`, `less`)
- [ ] Learn pipes and redirection (`>`, `|`, `grep`, `wc`)
- [ ] Write `backup.sh` — copies `~/projects` to `~/backups/$(date +%F)` using `tar`
- [ ] Write `sysinfo.sh` — prints hostname, uptime, disk usage, memory
- [ ] Write `renamer.sh` — renames `.txt` files to `note_001.txt`, `note_002.txt`, etc.
- [ ] Write `log_analyzer.sh` — counts patterns in a log file
- [ ] Write `grep_notes.sh` — searches your notes for a keyword
- [ ] Write `disk_report.sh` — reports disk usage with human-readable sizes
- [ ] Make all scripts executable with `chmod +x`
- [ ] Schedule backup with `crontab -e` (daily at 9pm)
- [ ] Learn vim basics
- [ ] Write `CHEATSHEET.md`

### Key Commands

```bash
cd /path/to/dir          # Change directory
ls -la                   # List all files with details
pwd                      # Print working directory
mkdir folder             # Create folder
cp file1 file2           # Copy file
mv file1 file2           # Move/rename file
rm file                  # Remove file
cat file                 # Print file contents
less file                # View file page by page
grep pattern file        # Search for pattern
chmod +x script.sh       # Make executable
./script.sh              # Run script
crontab -e               # Edit cron jobs
crontab -l               # List cron jobs
```

### Deliverables

```
~/projects/shell-toolkit/
├── backup.sh
├── sysinfo.sh
├── renamer.sh
├── log_analyzer.sh
├── grep_notes.sh
├── disk_report.sh
├── CHEATSHEET.md
└── notes.txt
```

- Crontab entry for daily backup

### Validation

- Run each script and confirm correct output
- Test backup: delete a file, restore from tarball
- Run `shellcheck` on each script and fix all warnings
- Check `crontab -l` shows your entry

### Notes

_Write your notes here as you go._

---

## Phase 0 Complete When:

- [ ] Ubuntu VM is running and snapshot is saved
- [ ] You can navigate the filesystem without looking up commands
- [ ] All 6 scripts work and pass `shellcheck`
- [ ] Backup runs automatically via cron
- [ ] You have a `CHEATSHEET.md` you actually use

---

## Resources

- VirtualBox official wiki
- Ubuntu installation guide (ubuntu.com/tutorials)
- David Bombal's VirtualBox videos
- linuxjourney.com (free)
- `man` pages
- crontab.guru (for cron syntax)

---

## Common Pitfalls

| Problem | Fix |
|---|---|
| VM is extremely slow | Enable VT-x/AMD-V in BIOS |
| No copy/paste in VM | Install Guest Additions |
| Script won't run | `chmod +x script.sh` then `./script.sh` |
| Spaces in filenames break loops | Quote variables: `"$f"` |
| Cron job not running | Check syntax with crontab.guru |
| `rm -rf` disaster | Never run with unquoted variables |

---

## Progress

| Project | Status | Date Completed |
|---|---|---|
| 0.1 First Lab | ⬜ Not started | |
| 0.2 Shell Toolkit | ⬜ Not started | |

---

**Next:** Phase 1 — Programming Foundations (Python)

---

### How to use this

1. Save it as `README.md` inside `~/projects/`.
2. Check off items as you complete them.
3. Add your own notes in the Notes sections.
4. Update the Progress table when you finish each project.
5. Push it to GitHub when you're ready to start building your portfolio.

This README will keep you organized and give you a clear record of what you've done. You've got this.
