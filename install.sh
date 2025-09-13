
#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

echo "Creating symlinks for dotfiles..."

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

echo "✅ Done! Dotfiles linked."

