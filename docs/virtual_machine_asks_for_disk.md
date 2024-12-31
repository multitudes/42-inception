# virtual box

If your virtual machine is asking for the original Debian installation media when you try to install packages, it may be because the package sources are not correctly configured to use online repositories. 
For example I am running this command
```bash
sudo apt-get update
sudo apt-get install build-essential dkms linux-headers-$(uname -r)
```
and my virtual box asks the orig debian image to be inserted? 

Open the sources list file with a text editor:  
```bash
sudo vim /etc/apt/sources.list
```
Ensure that the file contains only entries for the online repositories. It should look something like this:
```bash
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free
```
Save the file and exit the text editor.
This should allow you to install the necessary packages without needing the original Debian installation media.
