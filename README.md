# DIMM HOME DEV - Remote Dual Boot Switch (UEFI)

**Date:** 05/07/2026

---

# Description

The objective is to configure a dual-boot system where each operating system remains the default after rebooting into itself, while still allowing remote switching between Windows and Ubuntu.

## Expected behavior

* Windows → Reboot → Windows
* Ubuntu → Reboot → Ubuntu
* Windows → Ubuntu (remote switch)
* Ubuntu → Windows (remote switch)

The goal is to switch operating systems remotely (RDP/VNC/SSH) without requiring physical access to the UEFI boot menu.

---

# Installation

1. Install Windows 11 (use the bypass script if needed).
2. Install Ubuntu.
3. After Ubuntu installation, the system boots into Ubuntu.

At this stage it is already possible to boot Windows manually from the UEFI boot menu, but this is **not** the objective.

The objective is to switch operating systems remotely.

---

# Ubuntu → Windows

## Status

* ✅ Working on new installation
* ✅ Working on existing installation

## Question

**How can we boot Windows automatically from Ubuntu?**

## Solution

Linux script:

```bash
#!/bin/bash
echo "Go to Windows"

sudo efibootmgr -c \
    -d /dev/nvme0n1 \
    -p 1 \
    -L "Windows Direct" \
    -l '\EFI\Microsoft\Boot\bootmgfw.efi'

sudo reboot
```

## Result

The script creates a UEFI firmware entry pointing directly to Windows Boot Manager and immediately reboots.

After reboot:

* Ubuntu → Windows ✅
* Windows remains the default operating system for future reboots.

---

# Windows → Ubuntu

## Initial Questions

Now our system always boots into Windows.

This is great, but:

* How do we boot back into Ubuntu from Windows?
* We need to find the firmware GUID of the installed Ubuntu boot entry.
* How can we automatically identify the correct Ubuntu GUID?
* Once we have the GUID, how do we configure Windows to boot Ubuntu?

---

## Step 1 - Find the Ubuntu GUID

Run:

```cmd
bcdedit /enum firmware
```

Locate the firmware entry:

```text
description             ubuntu
```

Example:

```text
Firmware Application (101fffff)
-------------------------------
identifier              {27ed8440-a923-11f0-9bb3-000c296a303d}
device                  partition=\Device\HarddiskVolume1
path                    \EFI\ubuntu\shimx64.efi
description             ubuntu
```

Copy the **identifier (GUID)**.

---

## Step 2 - Configure Windows to Boot Ubuntu

Insert the Ubuntu GUID into the following batch script.

```bat
@echo off

:: Ubuntu firmware GUID
set UBUNTU_GUID={27ed8440-a923-11f0-9bb3-000c296a303d}

:: Windows Boot Manager
set WIN_GUID={bootmgr}

:: Set Ubuntu as default firmware boot entry
bcdedit /set {fwbootmgr} default %UBUNTU_GUID%

:: Put Ubuntu first in the firmware boot order
bcdedit /set {fwbootmgr} displayorder %UBUNTU_GUID% %WIN_GUID%

:: Optional boot menu timeout
bcdedit /timeout 2

:: Restart
%SystemRoot%\System32\shutdown.exe /r /t 0
```

## Result

Success!

After reboot:

* Windows → Ubuntu ✅
* Ubuntu remains the default operating system until another script changes the firmware boot configuration.

---

# Final Result

| Current OS | Action            | Result  |
| ---------- | ----------------- | ------- |
| Windows    | Normal reboot     | Windows |
| Ubuntu     | Normal reboot     | Ubuntu  |
| Windows    | Run switch script | Ubuntu  |
| Ubuntu     | Run switch script | Windows |

The system can now switch operating systems in both directions without requiring access to the UEFI boot menu, making it suitable for remote administration.



https://github.com/user-attachments/assets/4bf931ef-541d-4a53-9749-9e2307504717


