# Dotfiles

A collection of my personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Overview

This repository contains configuration files for various tools and applications. The files are organized into packages that can be symlinked to your home directory using Stow, making it easy to manage and version control your dotfiles.

## Structure

```
dotfiles/
├── git/           # Git configuration
│   └── .gitconfig
├── zsh/           # Zsh shell configuration
│   └── .zshrc
└── README.md
```

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) - A symlink farm manager

### Installing Stow

**macOS (using Homebrew):**
```bash
brew install stow
```

**Ubuntu/Debian:**
```bash
sudo apt-get install stow
```

**Arch Linux:**
```bash
sudo pacman -S stow
```

**Fedora:**
```bash
sudo dnf install stow
```

## Installation

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Install all dotfiles at once:
   ```bash
   stow .
   ```

   Or install specific packages:
   ```bash
   stow git
   stow zsh
   ```

## What Gets Installed

### Git Configuration (`git/`)
- `.gitconfig` - Global Git configuration with user settings, aliases, and preferences

### Zsh Configuration (`zsh/`)
- `.zshrc` - Zsh shell configuration with custom aliases, functions, and environment setup

## Usage

### Adding New Dotfiles

1. Create a new directory for your package:
   ```bash
   mkdir newpackage
   ```

2. Add your configuration files to the package directory:
   ```bash
   # Example: adding a vim configuration
   mkdir vim
   cp ~/.vimrc vim/
   ```

3. Install the new package:
   ```bash
   stow vim
   ```

### Updating Existing Dotfiles

1. Edit the files in the package directories
2. Restow the package to update the symlinks:
   ```bash
   stow -R package_name
   ```

### Removing Packages

To remove a package and its symlinks:
```bash
stow -D package_name
```

## Stow Commands Reference

- `stow package` - Install a package
- `stow -R package` - Restow (reinstall) a package
- `stow -D package` - Delete (uninstall) a package
- `stow .` - Install all packages in the current directory
- `stow -n package` - Dry run (see what would be done without actually doing it)

## Backup Existing Files

Before installing, make sure to backup any existing configuration files:

```bash
# Backup existing files
cp ~/.gitconfig ~/.gitconfig.backup
cp ~/.zshrc ~/.zshrc.backup
```

## Customization

Feel free to fork this repository and customize the configurations to match your preferences. Each package is self-contained, so you can pick and choose which configurations to use.

## Contributing

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## License

This project is open source and available under the [MIT License](LICENSE).
