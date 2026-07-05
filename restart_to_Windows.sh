#Script for Linux :
#---------------------------------------------------------------------------------------------------------
#!/bin/bash
echo go to win
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Windows Direct" -l '\EFI\Microsoft\Boot\bootmgfw.efi'
sudo reboot
#---------------------------------------------------------------------------------------------------------
