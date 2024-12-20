Yes, specifying `Auto-mount` and a mount point can help ensure that the shared folder is correctly mounted. Here are the steps:

1. **Add the Shared Folder in VirtualBox:**
   - Go to the VirtualBox Manager.
   - Select your running VM and go to `Devices` > `Shared Folders` > `Shared Folders Settings`.
   - Click on the `+` icon to add a new shared folder.
   - Choose the folder path on your host machine and give it a name (e.g., `shared_folder`).
   - Check the `Auto-mount` option.
   - Optionally, specify a mount point (e.g., `/mnt/shared_folder`).

2. **Install Guest Additions (if not already installed):**
   - In the VM, open a terminal and run:
     ```bash
     su -c 'apt-get update'
     su -c 'apt-get install build-essential dkms linux-headers-$(uname -r)'
     ```
   - In the VirtualBox menu, go to `Devices` > `Insert Guest Additions CD image`.
   - Mount the CD image and run the installer:
     ```bash
     su -c 'mount /dev/cdrom /mnt'
     su -c '/mnt/VBoxLinuxAdditions.run'
     su -c 'reboot'
     ```

3. **Verify the Shared Folder:**
   - After rebooting, check if the shared folder is automatically mounted:
     ```bash
     ls /mnt/shared_folder
     ```
   - If it is not automatically mounted, you can manually mount it:
     ```bash
     su -c 'mkdir -p /mnt/shared_folder'
     su -c 'mount -t vboxsf shared_folder /mnt/shared_folder'
     ```

Make sure that `shared_folder` in the `mount` command matches the name you specified in the VirtualBox shared folder settings. If you named it something else, use that name instead.