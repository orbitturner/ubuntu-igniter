# 🔥 Ubuntu Igniter 🔥

**Ubuntu Igniter** is a robust and customizable script designed to bootstrap and configure your Ubuntu environment with ease. From installing essential packages to securing your system with firewall rules, this script simplifies your initial setup while adding modern tools and aliases to supercharge your workflow.

---

## 🌟 Features

- 🚀 **Automated Updates**: Runs `sudo apt update && sudo apt upgrade -y` to keep your system up to date.
- 📦 **Essential Package Installation**: Installs tools like `curl`, `git`, `unzip`, `ufw`, `micro`, `figlet`, `bpytop`, `mc`, `fail2ban`, `eza`, `bat`, and more.
- 🔐 **Enhanced Security**: Configures the Uncomplicated Firewall (UFW) with secure rules:
  - Allows SSH (OpenSSH) connections.
  - Denies all incoming connections by default.
  - Allows all outgoing connections.
- ⚙️ **Modern Aliases**:
  - Replaces `ls` with `exa` for a richer file listing experience.
  - Replaces `cat` with `bat` for syntax-highlighted file previews.
- ✨ **Custom Welcome Message**:
  - Displays a stylized message using `figlet` upon opening a terminal.
  - Includes installed package details, firewall rules, and the current UFW status.

---

## 🚀 How to Use

You can run the **Ubuntu Igniter** script in two ways:

### 1. Direct Execution Without Cloning
Run the script directly using `curl` or `wget`:

```bash
sudo bash <(curl -s https://raw.githubusercontent.com/orbitturner/ubuntu-igniter/main/orbit-ubuntu-igniter.sh)
```

or

```bash
wget -qO- https://raw.githubusercontent.com/orbitturner/ubuntu-igniter/main/orbit-ubuntu-igniter.sh | sudo bash
```

### 2. Clone and Execute
If you prefer to clone the repository:

```bash
git clone https://github.com/orbitturner/ubuntu-igniter.git
cd ubuntu-igniter
sudo bash orbit-ubuntu-igniter.sh
```

---

## 🔧 Customization

You can customize the script to fit your needs:

1. **Add or Remove Packages**:
   Modify the `PACKAGE_LIST` variable in the script to include or exclude any packages you prefer:
   ```bash
   PACKAGE_LIST=("curl" "git" "unzip" "ufw" "micro" "figlet" "bpytop" "mc" "fail2ban" "nvm" "exa" "bat")
   ```

2. **Firewall Rules**:
   Adjust the UFW rules directly in the script under the "Firewall Configuration" section.

3. **Welcome Message**:
   Update the custom message displayed upon opening a terminal by modifying the `~/.bashrc` configuration section.

---

## 📜 What Does the Script Do?

### 1. **System Updates**
The script updates and upgrades your Ubuntu system to ensure it’s running the latest packages and security patches.

### 2. **Package Installation**
Installs the following tools:
- `curl`, `git`, `unzip`: Common utilities for downloads and version control.
- `ufw`: Firewall management.
- `micro`: A lightweight text editor.
- `figlet`: For stylized terminal messages.
- `bpytop`: A modern resource monitoring tool.
- `mc`: Midnight Commander for file management.
- `fail2ban`: Protects against brute-force attacks.
- `nvm`: Node Version Manager for managing Node.js installations.
- `exa`: An enhanced `ls` replacement.
- `bat`: An enhanced `cat` replacement with syntax highlighting.

### 3. **Firewall Rules**
Configures UFW with the following rules:
- **Allow OpenSSH** for SSH connections.
- **Default deny all incoming traffic** for security.
- **Default allow all outgoing traffic** for seamless connections.

### 4. **Custom Aliases**
Sets up the following aliases:
- `ls` → `exa -lah -T --git --hyperlink --header`
- `cat` → `bat`

### 5. **Custom Welcome Message**
Adds a terminal startup message using `figlet` with details about:
- Installed default packages.
- Configured firewall rules.
- Current UFW status.

---

## 📋 Example Terminal Welcome Message

After running the script, every new terminal session will display the following:

```
  Welcome to MY-HOSTNAME!
Default packages installed: micro, git, curl, ufw, figlet, bpytop, mc, fail2ban, nvm, net-tools.
Firewall rules:
- Allow SSH (OpenSSH)
- Deny all incoming connections
- Allow all outgoing connections
UFW Current Status:
Status: active
To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
...
```

---

## 🤝 Contributions

Feel free to contribute to **Ubuntu Igniter** by forking the repository and submitting a pull request. Ideas, fixes, and improvements are always welcome!

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

**Ubuntu Igniter** is your one-stop solution for configuring a new Ubuntu environment with security, tools, and modern enhancements—all in one script. 🚀