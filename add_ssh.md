# I need to add ssh to the virtual machine

To SSH into your Debian virtual machine created in VirtualBox, follow these steps:

1. **Start the Virtual Machine**: Ensure your Debian VM is running.

2. **Install OpenSSH Server**: If not already installed, install the OpenSSH server on your Debian VM.
   ```sh
   sudo apt update
   sudo apt install openssh-server
   ```

3. **Find the IP Address**: Determine the IP address of your Debian VM.
   ```sh
   ip addr show
   ```
   Look for the IP address under the network interface (usually `eth0` or `enp0s3`).

4. **Configure Port Forwarding**: In VirtualBox, set up port forwarding to allow SSH connections.
   - Go to the settings of your Debian VM.
   - Navigate to `Network` > `Advanced` > `Port Forwarding`.
   - Add a new rule with the following settings:
     - **Name**: SSH
     - **Protocol**: TCP
     - **Host IP**: 127.0.0.1
     - **Host Port**: 2222
     - **Guest IP**: (leave blank)
     - **Guest Port**: 22

5. **SSH into the VM**: Use an SSH client from your host machine to connect to the VM.
   ```sh
   ssh -p 2222 your_username@127.0.0.1
   ```
   Replace `your_username` with your Debian username.

You should now be able to SSH into your Debian virtual machine.