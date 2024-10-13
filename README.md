# 🔥 Ubuntu-Igniter 🔥

**Ubuntu-Igniter** is your ultimate bash script for lighting up new Ubuntu installations with enhanced security, seamless automation, and a touch of flair. Designed to be robust, scalable, and idempotent, it simplifies your system's setup process while ensuring that everything is locked down tight. Let Ubuntu-Igniter do the heavy lifting for you—just hit play and ignite your Ubuntu experience.

## 🌟 Features

- 🚀 **Automated Package Installation**: Speed up your setup with automatic installation of essential tools like `ufw`, `fail2ban`, `mc`, `python3`, `nvm`, and more.
- 🔐 **Enhanced Security**: Fortify your system with UFW firewall and Fail2Ban to block brute-force attacks, with all security settings configured for you.
- 🛠️ **Error-Resilient**: Keeps going, even if some packages fail. Logs all errors and continues the process without missing a beat.
- 📊 **Logging with Style**: Every action is logged with a sprinkle of emojis to keep things fun, and stored in `/var/log/ubuntu_igniter.log` for review.
- 📜 **Package History Tracking**: Generates a complete list of installed packages, stored in `/var/log/package_history.log`, so you can easily replicate the setup later.
- 🏁 **Installation Summary**: At the end, you’ll get a neat summary of what was installed and any hiccups along the way.

---

## ⚙️ System Requirements

- **Ubuntu OS**
- **Root or sudo privileges** to execute the script.

---

## 🚀 Quick Start

1. **Download the Script**:
   Clone the repo or download the script directly:
   ```bash
   git clone https://github.com/your-repo/ubuntu-igniter.git
   ```

2. **Make It Executable**:
   Give the script permission to run:
   ```bash
   chmod +x ubuntu-igniter.sh
   ```

3. **Ignite Your Ubuntu**:
   Launch the script with superuser privileges:
   ```bash
   sudo ./ubuntu-igniter.sh
   ```

   🔥 The script will:
   - Update & upgrade your system.
   - Install essential packages.
   - Configure firewall and Fail2Ban security.
   - Log everything and generate a summary at the end.

---

## 🔧 Customization

Want to tweak the packages? No problem! Simply modify the `PACKAGE_LIST` in the script to fit your needs:

```bash
PACKAGE_LIST=("ufw" "fail2ban" "mc" "tufw" "python3" "nvm" "curl" "git" "net-tools")
```

Add any package you love, remove what you don't need, and Ubuntu-Igniter will take care of the rest!

---

## 📋 Logging and Reports

- **Detailed Logs**: Every action the script takes is logged and stored in `/var/log/ubuntu_igniter.log`.
- **Package History**: A full list of installed packages is saved in `/var/log/package_history.log` for easy reference or to replicate on another machine.
- **Installation Summary**: Get a recap of success and failure at the end of the process—no need to scroll through long logs to find out what worked and what didn’t.

---

## 🛡️ Resilience

Even if an installation fails, Ubuntu-Igniter keeps going. Errors are logged without stopping the script, ensuring your system setup completes as smoothly as possible. And if you hit `CTRL+C` during the install, Ubuntu-Igniter will gracefully exit, making sure nothing breaks mid-installation.

---

## 🤝 Contributions

Feel like adding your own magic to **Ubuntu-Igniter**? Fork the repository, make your changes, and submit a pull request. Contributions are always welcome to make this script even more awesome!

---

## 📄 License

This project is licensed under the MIT License. Check out the `LICENSE` file for more details.

---

Ignite your Ubuntu installations with style and security. With **Ubuntu-Igniter**, it's more than just a setup—it's a launchpad for productivity. 🚀
