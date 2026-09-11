# How to Install an Ubuntu VM on Arch Linux (Hyprland)

A step-by-step guide. Each command is explained. Follow in order.

---

## Phase A — Host Setup (on Arch)

### A1. Install packages

    sudo pacman -S qemu-full libvirt virt-manager edk2-ovmf dnsmasq swtpm

| Package | Purpose |
|---|---|
| qemu-full | The emulator that runs the VM |
| libvirt | Background daemon that manages VMs |
| virt-manager | GUI to create/run VMs |
| edk2-ovmf | UEFI firmware for the VM |
| dnsmasq | DHCP/DNS so the VM gets internet |
| swtpm | Emulated TPM (optional but harmless) |

### A2. Enable and start the libvirt daemon

    sudo systemctl enable --now libvirtd.service

- enable  -> start automatically at every boot
- --now   -> also start right now

### A3. Add your user to the libvirt group

    sudo usermod -aG libvirt $USER

- -aG      -> append to group (never omit -a)
- libvirt  -> the group created by the libvirt package
- $USER    -> your Arch username

### A4. Log out and back in once

Group changes only apply to new sessions.

    loginctl terminate-user $USER

Then log back in normally. One time only.

### A5. Verify

    systemctl status libvirtd
    virsh list --all

Expected:
- systemctl status  -> active (running)
- virsh list --all  -> empty table with "Id Name State" headers

If virsh says permission denied, redo A4.

---

## Phase B — Get Ubuntu

### B1. Download the Ubuntu 24.04 ISO

    cd ~/Downloads
    curl -LO https://releases.ubuntu.com/24.04/ubuntu-24.04.1-desktop-amd64.iso

~5 GB. Save the path — you'll need it in C3.

### B2. (Optional) Verify checksum

    sha256sum ubuntu-24.04.1-desktop-amd64.iso

Compare against the value on releases.ubuntu.com.

---

## Phase C — Create the VM

### C1. Launch virt-manager

    virt-manager

### C2. New VM wizard

1. File -> New Virtual Machine
2. Select "Local install media (ISO image or CDROM)" -> Forward

### C3. Point at the ISO

- Browse -> Browse Local -> select the ISO from B1
- If auto-detect fails, uncheck it and type "Ubuntu 24.04"
- Forward

### C4. Resources

- Memory: 4096 MB
- CPUs: 2
- Forward

### C5. Disk

- Size: 40 GB
- Forward

### C6. Name

- Name: ubuntu-lab

### C7. Customize before install

- Tick "Customize configuration before install"
- Click Finish

### C8. Display settings

In the customization window:
- Left panel -> Display Spice
  - Listen type: None
  - Check OpenGL

### C9. Firmware

- Left panel -> Overview
  - Firmware: UEFI x86_64: .../OVMF_CODE.fd

### C10. Begin installation

Click "Begin Installation" (top-left).

---

## Phase D — Install Ubuntu inside the VM

### D1. Installer boots

The Ubuntu installer appears inside the virt-manager window.

### D2. Language / keyboard

Pick your preferences -> Continue.

### D3. Installation type

- Select "Minimal installation" (no office/games)

### D4. Disk

- Select "Erase disk and install Ubuntu"
  - This only erases the *virtual* 40 GB disk. Your Arch disk is untouched.

### D5. Create the Ubuntu user

- Pick any name, username, and password
- This is your fresh, isolated user *inside* the VM
- It has nothing to do with your Arch account

### D6. Wait

Installation takes 10-20 minutes.

### D7. Reboot

- Click "Restart Now"
- If it hangs on "remove installation medium," press Enter or reset the VM from virt-manager

### D8. First commands inside Ubuntu

    sudo apt update && sudo apt upgrade -y

---

## Phase E — Post-install Setup

### E1. Install spice-vdagent (for clipboard)

Inside Ubuntu:

    sudo apt install -y spice-vdagent
    sudo systemctl enable --now spice-vdagentd

### E2. Reboot the VM

    sudo reboot

### E3. Test clipboard

- Copy text on Arch (host)
- Paste inside Ubuntu
- If it works -> done

### E4. Shared folder (virtio-9p)

1. Shut down the VM.
2. On Arch, create a folder to share:

    mkdir -p ~/vmshare

3. In virt-manager -> VM details -> Add Hardware -> Filesystem
   - Driver: virtio-9p
   - Source path: /home/YOURUSER/vmshare
   - Target path: vmshare

### E5. Mount the shared folder inside Ubuntu

Inside the VM:

    sudo mkdir -p /mnt/vmshare
    sudo mount -t 9p -o trans=virtio,version=9p2000.L vmshare /mnt/vmshare

Test:

    ls /mnt/vmshare

### E6. Make the mount permanent

Inside Ubuntu, edit /etc/fstab:

    sudo nano /etc/fstab

Add this line:

    vmshare /mnt/vmshare 9p trans=virtio,version=9p2000.L 0 0

Save (Ctrl+O, Enter, Ctrl+X), then test:

    sudo mount -a

---

## Phase F — Lock It In

### F1. Shut down the VM cleanly

Inside Ubuntu:

    sudo shutdown now

### F2. Take a snapshot

1. In virt-manager, open the VM's details
2. Go to Snapshots tab
3. Click + -> name it exactly: clean-install
4. Save

### F3. Boot back up

- Start the VM
- Log in as your Ubuntu user
- Confirm everything works

### F4. Update your progress file

Mark Project 0.1 as complete in your README.md.

---

## Verification Commands (run inside Ubuntu)

    whoami                 # your Ubuntu username
    pwd                    # /home/<your-ubuntu-user>
    ls /                   # bin etc home usr var
    ping -c 3 google.com   # 3 replies
    ls /mnt/vmshare        # contents of shared folder

If all of those work, the VM is complete.

---

## Common Problems

| Problem | Fix |
|---|---|
| virsh says permission denied | Log out and back in (A4) |
| VM has no internet | Check NIC exists in VM details; restart libvirtd |
| Clipboard doesn't work | Install/reinstall spice-vdagent (E1) |
| Shared folder empty | Check source path, re-add hardware, restart VM |
| VM extremely slow | Enable VT-x/AMD-V in BIOS; check KVM is loaded |
| Installer hangs | Reset the VM from virt-manager and retry |
| rm -rf fear | Never run it with unquoted variables; snapshots save you |

---

## Key Concepts Recap

| Term | Meaning |
|---|---|
| VM | Virtual Machine - a fake computer running inside your real one |
| QEMU | The emulator that acts as the fake PC |
| KVM | Kernel module that makes QEMU fast |
| libvirt | Daemon that manages VMs |
| virt-manager | GUI that talks to libvirt |
| ISO | A single file containing a full installer disc |
| Snapshot | A save point you can rewind to |
| 9p / virtiofs | Protocols for sharing folders with the VM |

---

## Users in This Setup

| User | Where it lives | Purpose |
|---|---|---|
| Your Arch user | On Arch (host) | Runs virt-manager, manages VMs |
| Ubuntu user | Inside the VM (guest) | The fresh, isolated account for experiments |
