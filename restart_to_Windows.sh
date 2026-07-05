#Script for Linux :
#---------------------------------------------------------------------------------------------------------
#!/bin/bash
echo go to win
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Windows Direct" -l '\EFI\Microsoft\Boot\bootmgfw.efi'
sudo reboot
#---------------------------------------------------------------------------------------------------------




# or use this 2_nd script : 
#Script for Linux_2 : ==> this is safest and better
#--------------------------------------------
#!/bin/bash
sudo efibootmgr #  ==> detect windows number from here 
sleep 4
sudo efibootmgr -o 0005
reboot
#---------------
