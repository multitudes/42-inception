# Change my user and root password on debian

I have a virtual machine running Debian and I forgot my password. How can I reset it?

1. **Boot into GRUB menu:**
   - Start your virtual machine.
   - When the GRUB menu appears, select the Debian entry and press `e` to edit.

2. **Edit GRUB entry:**
   - Find the line that starts with `linux` and ends with `quiet`.
   - Replace `quiet` with `init=/bin/bash`.

3. **Boot into single-user mode:**
   - Press `Ctrl + X` or `F10` to boot.

4. **Remount the filesystem:**
   - Once you get a root shell, remount the filesystem with write permissions:
     ```bash
     mount -o remount,rw /
     ```

5. **Reset the password:**
   - Use the `passwd` command to reset the password for your user:
     ```bash
     passwd your_username
     ```
   - If you need to reset the root password, use:
     ```bash
     passwd root
     ```

6. **Reboot:**
   - Remount the filesystem as read-only and reboot:
     ```bash
     mount -o remount,ro /
     exec /sbin/init
     ```

After rebooting, you should be able to log in with the new password.

So far I chose "Cinelli!" as my new password. I will use it to log in to my Debian virtual machine.