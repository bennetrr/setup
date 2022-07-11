#! /bin/bash

printf "\n\n\033[1m\033[42mInstalling OhMyZSH and config files\033[0m\n"
curl -fsSL -o- "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | bash
cp -v .zshrc .p10k.zsh ~

printf "\n\n\033[1m\033[42mInstalling zsh plugins\033[0m\n"
git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone "https://github.com/zsh-users/zsh-autosuggestions" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

printf "\n\n\033[1m\033[43mYou need to enter your password to set the default shell to zsh\033[0m\n"
chsh -s /bin/zsh