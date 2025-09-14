# Dotfiles Makefile
# Manage dotfiles installation and configuration

.PHONY: help install update clean backup restore check-deps install-zsh install-ohmyzsh install-themes install-plugins install-nvm install-mysql apply-configs apply-git apply-zsh check-stow backup-default-configs

# Default target
.DEFAULT_GOAL := help

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
RESET := \033[0m

# Detect OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OS := macOS
    PACKAGE_MANAGER := brew
else ifeq ($(UNAME_S),Linux)
    OS := Linux
    PACKAGE_MANAGER := apt
else
    OS := UNKNOWN
endif

help: ## Show available commands
	@echo "$(CYAN)🔧 Dotfiles Management$(RESET)"
	@echo "$(YELLOW)Available commands:$(RESET)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-deps: ## Check required dependencies
	@echo "$(BLUE)📦 Checking dependencies for $(OS)...$(RESET)"
	@if [ "$(OS)" = "macOS" ]; then \
		if ! command -v brew >/dev/null 2>&1; then \
			echo "$(RED)❌ Homebrew not found. Please install Homebrew first.$(RESET)"; \
			exit 1; \
		fi; \
	elif [ "$(OS)" = "Linux" ]; then \
		if ! command -v apt >/dev/null 2>&1; then \
			echo "$(RED)❌ apt not found. Please install apt first.$(RESET)"; \
			exit 1; \
		fi; \
	fi
	@echo "$(GREEN)✅ Dependencies check passed$(RESET)"

install: check-deps backup-default-configs apply-configs install-zsh install-ohmyzsh install-themes install-plugins install-nvm install-mysql ## Install all components
	@echo "$(GREEN)✅ Installation complete! Restart your terminal or run: exec zsh$(RESET)"

install-zsh: ## Install Zsh
	@echo "$(BLUE)⚡ Installing Zsh...$(RESET)"
	@if ! command -v zsh >/dev/null 2>&1; then \
		if [ "$(OS)" = "macOS" ]; then \
			brew install zsh; \
		elif [ "$(OS)" = "Linux" ]; then \
			sudo apt update && sudo apt install -y zsh; \
		fi; \
	else \
		echo "$(GREEN)✅ Zsh already installed$(RESET)"; \
	fi

install-ohmyzsh: ## Install Oh My Zsh
	@echo "$(BLUE)⚡ Installing Oh My Zsh...$(RESET)"
	@if [ ! -d "$(HOME)/.oh-my-zsh" ]; then \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	else \
		echo "$(GREEN)✅ Oh My Zsh already installed$(RESET)"; \
	fi

install-themes: ## Install Powerlevel10k theme
	@echo "$(BLUE)⚡ Installing Powerlevel10k theme...$(RESET)"
	@if [ ! -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
			$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/themes/powerlevel10k; \
	else \
		echo "$(GREEN)✅ Powerlevel10k already installed$(RESET)"; \
	fi

install-plugins: ## Install Zsh plugins
	@echo "$(BLUE)⚡ Installing Zsh plugins...$(RESET)"
	@# Install zsh-autosuggestions
	@if [ ! -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions \
			$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; \
	else \
		echo "$(GREEN)✅ zsh-autosuggestions already installed$(RESET)"; \
	fi
	@# Install zsh-syntax-highlighting
	@if [ ! -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
			$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; \
	else \
		echo "$(GREEN)✅ zsh-syntax-highlighting already installed$(RESET)"; \
	fi

install-nvm: ## Install NVM (Node Version Manager)
	@echo "$(BLUE)⚡ Installing NVM...$(RESET)"
	@if [ ! -d "$(HOME)/.nvm" ]; then \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; \
	else \
		echo "$(GREEN)✅ NVM already installed$(RESET)"; \
	fi

install-mysql: ## Install MySQL client
	@echo "$(BLUE)⚡ Installing MySQL client...$(RESET)"
	@if [ "$(OS)" = "macOS" ]; then \
		brew install mysql-client; \
	elif [ "$(OS)" = "Linux" ]; then \
		sudo apt install -y default-mysql-client; \
	fi

update: ## Update all components
	@echo "$(BLUE)🔄 Updating dotfiles components...$(RESET)"
	@# Update Oh My Zsh
	@if [ -d "$(HOME)/.oh-my-zsh" ]; then \
		cd $(HOME)/.oh-my-zsh && git pull; \
	fi
	@# Update Powerlevel10k
	@if [ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then \
		cd $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && git pull; \
	fi
	@# Update plugins
	@if [ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then \
		cd $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && git pull; \
	fi
	@if [ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then \
		cd $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && git pull; \
	fi
	@# Update NVM
	@if [ -d "$(HOME)/.nvm" ]; then \
		cd $(HOME)/.nvm && git pull; \
	fi
	@echo "$(GREEN)✅ Update complete$(RESET)"

backup: ## Backup current configuration files
	@echo "$(BLUE)💾 Creating backup...$(RESET)"
	@mkdir -p $(HOME)/.dotfiles-backup/$$(date +%Y%m%d_%H%M%S)
	@BACKUP_DIR=$(HOME)/.dotfiles-backup/$$(date +%Y%m%d_%H%M%S); \
	if [ -f $(HOME)/.zshrc ]; then cp $(HOME)/.zshrc $$BACKUP_DIR/; fi; \
	if [ -f $(HOME)/.p10k.zsh ]; then cp $(HOME)/.p10k.zsh $$BACKUP_DIR/; fi; \
	echo "$(GREEN)✅ Backup created in $$BACKUP_DIR$(RESET)"

restore: ## Restore from backup (requires BACKUP_DIR)
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "$(RED)❌ Please specify BACKUP_DIR. Usage: make restore BACKUP_DIR=/path/to/backup$(RESET)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🔄 Restoring from $(BACKUP_DIR)...$(RESET)"
	@if [ -f "$(BACKUP_DIR)/.zshrc" ]; then cp "$(BACKUP_DIR)/.zshrc" $(HOME)/; fi
	@if [ -f "$(BACKUP_DIR)/.p10k.zsh" ]; then cp "$(BACKUP_DIR)/.p10k.zsh" $(HOME)/; fi
	@echo "$(GREEN)✅ Restore complete$(RESET)"

clean: ## Remove old configuration files
	@echo "$(YELLOW)⚠️  This will remove Oh My Zsh and related configurations$(RESET)"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	@rm -rf $(HOME)/.oh-my-zsh
	@rm -rf $(HOME)/.nvm
	@rm -f $(HOME)/.zshrc
	@rm -f $(HOME)/.p10k.zsh
	@echo "$(GREEN)✅ Cleanup complete$(RESET)"

status: ## Check status of components
	@echo "$(CYAN)📊 Dotfiles Status Report$(RESET)"
	@echo "$(YELLOW)OS: $(OS)$(RESET)"
	@echo "$(YELLOW)Package Manager: $(PACKAGE_MANAGER)$(RESET)"
	@echo ""
	@echo "$(BLUE)Components:$(RESET)"
	@if command -v zsh >/dev/null 2>&1; then \
		echo "  $(GREEN)✅ Zsh$(RESET) - $$(zsh --version)"; \
	else \
		echo "  $(RED)❌ Zsh$(RESET) - Not installed"; \
	fi
	@if [ -d "$(HOME)/.oh-my-zsh" ]; then \
		echo "  $(GREEN)✅ Oh My Zsh$(RESET) - Installed"; \
	else \
		echo "  $(RED)❌ Oh My Zsh$(RESET) - Not installed"; \
	fi
	@if [ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then \
		echo "  $(GREEN)✅ Powerlevel10k$(RESET) - Installed"; \
	else \
		echo "  $(RED)❌ Powerlevel10k$(RESET) - Not installed"; \
	fi
	@if [ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then \
		echo "  $(GREEN)✅ zsh-autosuggestions$(RESET) - Installed"; \
	else \
		echo "  $(RED)❌ zsh-autosuggestions$(RESET) - Not installed"; \
	fi
	@if [ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then \
		echo "  $(GREEN)✅ zsh-syntax-highlighting$(RESET) - Installed"; \
	else \
		echo "  $(RED)❌ zsh-syntax-highlighting$(RESET) - Not installed"; \
	fi
	@if [ -d "$(HOME)/.nvm" ]; then \
		echo "  $(GREEN)✅ NVM$(RESET) - Installed"; \
	else \
		echo "  $(RED)❌ NVM$(RESET) - Not installed"; \
	fi

check-stow: ## Check if Stow is installed
	@echo "$(BLUE)📦 Checking for Stow...$(RESET)"
	@if ! command -v stow >/dev/null 2>&1; then \
		echo "$(RED)❌ Stow not found. Installing Stow...$(RESET)"; \
		if [ "$(OS)" = "macOS" ]; then \
			brew install stow; \
		elif [ "$(OS)" = "Linux" ]; then \
			sudo apt update && sudo apt install -y stow; \
		fi; \
	else \
		echo "$(GREEN)✅ Stow already installed$(RESET)"; \
	fi

apply-configs: check-stow apply-git apply-zsh ## Apply all configuration files with Stow
	@echo "$(GREEN)✅ All configurations applied successfully$(RESET)"

apply-git: ## Apply Git configuration
	@echo "$(BLUE)📁 Applying Git configuration...$(RESET)"
	@if [ -d "git" ]; then \
		if [ -f "$(HOME)/.gitconfig" ] && [ ! -L "$(HOME)/.gitconfig" ]; then \
			echo "$(YELLOW)⚠️  Removing existing .gitconfig to apply custom config$(RESET)"; \
			rm "$(HOME)/.gitconfig"; \
		fi; \
		stow git; \
		echo "$(GREEN)✅ Git configuration applied$(RESET)"; \
	else \
		echo "$(YELLOW)⚠️  Git directory not found$(RESET)"; \
	fi

apply-zsh: ## Apply Zsh configuration
	@echo "$(BLUE)📁 Applying Zsh configuration...$(RESET)"
	@if [ -d "zsh" ]; then \
		if [ -f "$(HOME)/.zshrc" ] && [ ! -L "$(HOME)/.zshrc" ]; then \
			echo "$(YELLOW)⚠️  Removing existing .zshrc to apply custom config$(RESET)"; \
			rm "$(HOME)/.zshrc"; \
		fi; \
		stow zsh; \
		echo "$(GREEN)✅ Zsh configuration applied$(RESET)"; \
	else \
		echo "$(YELLOW)⚠️  Zsh directory not found$(RESET)"; \
	fi

backup-default-configs: ## Backup default configuration files before applying custom configs
	@echo "$(BLUE)💾 Backing up default configuration files...$(RESET)"
	@mkdir -p $(HOME)/.dotfiles-backup/default-configs
	@# Backup default .zshrc if it exists and is not already a symlink
	@if [ -f "$(HOME)/.zshrc" ] && [ ! -L "$(HOME)/.zshrc" ]; then \
		cp "$(HOME)/.zshrc" "$(HOME)/.dotfiles-backup/default-configs/.zshrc.default"; \
		echo "$(GREEN)✅ Backed up default .zshrc$(RESET)"; \
	fi
	@# Backup default .gitconfig if it exists and is not already a symlink
	@if [ -f "$(HOME)/.gitconfig" ] && [ ! -L "$(HOME)/.gitconfig" ]; then \
		cp "$(HOME)/.gitconfig" "$(HOME)/.dotfiles-backup/default-configs/.gitconfig.default"; \
		echo "$(GREEN)✅ Backed up default .gitconfig$(RESET)"; \
	fi
	@# Backup default .p10k.zsh if it exists and is not already a symlink
	@if [ -f "$(HOME)/.p10k.zsh" ] && [ ! -L "$(HOME)/.p10k.zsh" ]; then \
		cp "$(HOME)/.p10k.zsh" "$(HOME)/.dotfiles-backup/default-configs/.p10k.zsh.default"; \
		echo "$(GREEN)✅ Backed up default .p10k.zsh$(RESET)"; \
	fi
	@echo "$(GREEN)✅ Default config backup complete$(RESET)"