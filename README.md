# Dotfiles

A collection of my personal dotfiles with automated installation and management using Makefile.

## Overview

This repository contains configuration files for various tools and applications, including Zsh, Oh My Zsh, Powerlevel10k theme, and essential plugins. The installation process is automated through a comprehensive Makefile that handles dependencies, installation, updates, and maintenance.

## Structure

```
dotfiles/
├── zsh/           # Zsh shell configuration
│   └── .zshrc
├── Makefile       # Automated installation and management
└── README.md
```

## Prerequisites

The Makefile will automatically detect your operating system and install required dependencies. However, you need:

-   **macOS**: [Homebrew](https://brew.sh/) package manager
-   **Linux**: `apt` package manager (Ubuntu/Debian)

### Manual Prerequisites Installation

**macOS (install Homebrew):**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Linux (Ubuntu/Debian):**

```bash
sudo apt update && sudo apt upgrade -y
```

## Quick Installation

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. Install everything with one command:

    ```bash
    make install
    ```

3. Restart your terminal or run:
    ```bash
    exec zsh
    ```

## Makefile Usage

The Makefile provides comprehensive management of your dotfiles environment. Here are all available commands:

### 📋 Available Commands

```bash
make help          # Show all available commands
make install       # Install all components
make status        # Check installation status
make update        # Update all components
make backup        # Backup current configuration
make restore       # Restore from backup
make clean         # Remove all installations
```

### 🔧 Individual Component Installation

```bash
make install-zsh       # Install Zsh shell
make install-ohmyzsh  # Install Oh My Zsh framework
make install-themes    # Install Powerlevel10k theme
make install-plugins   # Install Zsh plugins
make install-nvm       # Install Node Version Manager
make install-mysql     # Install MySQL client
make install-tree       # Install Tree command
```

### 📁 Configuration Management

```bash
make apply-configs         # Apply all configuration files with Stow
make apply-zsh             # Apply Zsh configuration only
make check-stow            # Check and install Stow if needed
make backup-default-configs # Backup default config files
make show-tree-aliases     # Show available Tree command aliases
```

**Smart Configuration Handling:**

-   🔄 Automatically backs up existing config files
-   🗑️ Removes conflicting default files before applying custom configs
-   🔗 Creates symlinks to your custom configurations
-   💾 Preserves original files in backup directory

### 📊 Status and Maintenance

```bash
# Check what's installed
make status

# Update all components to latest versions
make update

# Check system dependencies
make check-deps
```

### 💾 Backup and Restore

```bash
# Create backup with timestamp
make backup

# Restore from specific backup
make restore BACKUP_DIR=/Users/username/.dotfiles-backup/20241201_143022
```

### 🧹 Cleanup

```bash
# Remove all installations (with confirmation)
make clean
```

## What Gets Installed

The Makefile automatically installs and configures:

### 🐚 **Zsh Shell**

-   Latest Zsh shell with enhanced features
-   Automatic installation via Homebrew (macOS) or apt (Linux)

### 🎨 **Oh My Zsh Framework**

-   Popular Zsh configuration framework
-   Provides plugins, themes, and productivity features

### ⚡ **Powerlevel10k Theme**

-   Fast and highly customizable Zsh theme
-   Beautiful prompt with git status, directory info, and more

### 🔌 **Essential Plugins**

-   **zsh-autosuggestions**: Suggests commands as you type
-   **zsh-syntax-highlighting**: Highlights commands and syntax

### 📦 **Development Tools**

-   **NVM**: Node Version Manager for managing Node.js versions
-   **MySQL Client**: Database client tools
-   **Tree Command**: Directory structure visualization tool

### 📁 **Configuration Files**

-   **Zsh Configuration** (`zsh/`): Custom shell configuration with Tree aliases
-   **Stow Integration**: Automatically applies configs using GNU Stow symlinks

## 🌳 **Tree Command & Aliases**

The dotfiles include the Tree command for directory visualization along with convenient aliases for quick access:

### **Tree Aliases**

```bash
t   - tree (basic tree view)
ta  - tree -a (show hidden files)
td  - tree -d (directories only)
tl  - tree -L (limit depth, e.g., tl 2)
tf  - tree -f (full path prefix)
ti  - tree -I (ignore pattern, e.g., ti 'node_modules')
ts  - tree -s (show file sizes)
th  - tree -h (human readable sizes)
```

### **Usage Examples**

```bash
# Basic usage
t                    # Show current directory tree
tl 3                 # Show tree with max depth 3
ta                   # Show tree including hidden files
td                   # Show directories only

# Advanced usage
ti 'node_modules'    # Ignore node_modules directories
ti '*.log'           # Ignore .log files
ts                   # Show file sizes
th                   # Show human-readable file sizes
tf                   # Show full path prefix
```

### **View Available Aliases**

```bash
make show-tree-aliases    # Display all Tree aliases and examples
```

## Advanced Usage

### 🔄 **Updating Components**

Keep your environment up-to-date:

```bash
# Update all components
make update

# Check what's installed
make status
```

### 💾 **Backup Management**

Always backup before making changes:

```bash
# Create timestamped backup
make backup

# List available backups
ls ~/.dotfiles-backup/

# Restore from backup
make restore BACKUP_DIR=/Users/username/.dotfiles-backup/20241201_143022
```

### 🛠️ **Troubleshooting**

If something goes wrong:

```bash
# Check system dependencies
make check-deps

# Check installation status
make status

# Clean and reinstall
make clean
make install
```

### 📝 **Adding Custom Configurations**

1. Add your configuration files to the appropriate directories:

    ```bash
    # Example: adding custom aliases
    echo "alias ll='ls -la'" >> zsh/.zshrc
    ```

2. Update the installation:
    ```bash
    make update
    ```

## 🚀 **Quick Start Examples**

### Fresh Installation

```bash
git clone https://github.com/heelkindy/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install          # Installs all components AND applies configs safely
exec zsh
```

**What happens during installation:**

1. 🔍 Checks system dependencies
2. 💾 Backs up any existing config files
3. 📁 Applies custom configurations with Stow
4. ⚡ Installs Zsh, Oh My Zsh, themes, plugins, and Tree command
5. 🌳 Sets up Tree aliases for quick directory visualization
6. 🎯 Ready to use!

### Apply Configs Only (if already installed)

```bash
cd ~/dotfiles
make apply-configs     # Apply configuration files with Stow
```

### Update Everything

```bash
cd ~/dotfiles
make update
```

### Check Status

```bash
cd ~/dotfiles
make status
```

## 🎯 **Features**

-   ✅ **Cross-platform**: Works on macOS and Linux
-   ✅ **Automated**: One command installs everything
-   ✅ **Safe**: Checks dependencies and existing installations
-   ✅ **Maintainable**: Easy updates and backups
-   ✅ **Modular**: Install components individually
-   ✅ **Colorful**: Beautiful terminal output with colors
-   ✅ **Smart**: Detects OS and package managers automatically
-   ✅ **Tree Integration**: Directory visualization with convenient aliases

## 🛡️ **Safety Features**

-   **Dependency checking**: Verifies required tools before installation
-   **Existing installation detection**: Won't overwrite without confirmation
-   **Backup system**: Automatic timestamped backups
-   **Clean removal**: Safe cleanup with confirmation prompts
-   **Status reporting**: Clear overview of what's installed

## 📋 **Requirements**

-   **macOS**: Homebrew package manager
-   **Linux**: apt package manager (Ubuntu/Debian)
-   **Internet connection**: For downloading components
-   **Git**: For cloning repositories

## 🤝 **Contributing**

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 **Contact**

If you have any questions, suggestions, or need help with this dotfiles setup, feel free to reach out:

-   **GitHub Issues**: [Create an issue](https://github.com/heelkindy/dotfiles/issues) for bug reports or feature requests
-   **GitHub Discussions**: [Start a discussion](https://github.com/heelkindy/dotfiles/discussions) for general questions or ideas
-   **Github**: [@heelkindy](https://github.com/heelkindy)
-   **Email**: [@heelkindy](mailto:vanhieu2241998@gmail.com)
-   **LinkedIn**: [@heelkindy](https://linkedin.com/in/heelkindy)

### **Getting Help**

-   📖 **Documentation**: Check this README for detailed instructions
-   🔍 **Search Issues**: Look through existing issues for similar problems
-   💡 **Feature Requests**: Suggest new features or improvements
-   🐛 **Bug Reports**: Report any issues you encounter

## 📄 **License**

This project is open source and available under the [MIT License](LICENSE).

---

**Made with ❤️ for developers who love clean, automated setups!**
