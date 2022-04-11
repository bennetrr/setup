#! /bin/bash

# Set the default values for the arguments
bupdate=true
zsh=true
node=true
dotnet=true
python=true
java=true
docker=true
git=true
graphical=false
teams=true
jetbrains=true
imagers=true
minecraft=true
timeular=true
virtualbox=true
sshd=true

# Get the arguments
for arg in "$@"; do
    case "${arg}" in
    "--no-bupdate") bupdate=false ;;
    "--no-zsh") zsh=false ;;
    "--no-node") node=false ;;
    "--no-dotnet") dotnet=false ;;
    "--no-python") python=false ;;
    "--no-java") java=false ;;
    "--no-docker") docker=false ;;
    "--no-git") git=false ;;
    "--graphical") graphical=true ;;
    "--no-teams") teams=false ;;
    "--no-jetbrains") jetbrains=false ;;
    "--no-imagers") imagers=false ;;
    "--no-minecraft") minecraft=false ;;
    "--no-timeular") timeular=false ;;
    "--no-virtualbox") virtualbox=false ;;
    "--no-sshd") sshd=false ;;
    *) printf "\033[1m\033[31mWrong argument: $arg\033[0m\n" && exit ;;
    esac
done

# Get root permissions
printf "\n\n\033[1m\033[43mYou need to enter your password to allow root actions\033[0m\n"
sudo printf "\033[1m\033[42mGot root permissions! \033[0m\n"

# Get the distributor and version number and codename
os_distributor=$(lsb_release -is)
os_distributor=${os_distributor,,}
os_version=$(lsb_release -rs)
os_codename=$(lsb_release -cs)

# Install git
printf "\n\n\033[1m\033[42mInstalling git\033[0m\n"
sudo apt install -y git

# Install and run bupdate
if $bupdate; then
    printf "\n\n\033[1m\033[42mAdding the bennetrr apt repository\033[0m\n"
    curl -s --compressed "https://bennetrr.github.io/packages/apt/KEY.gpg" | sudo apt-key add -
    echo "deb https://bennetrr.github.io/packages/apt ./" | sudo tee /etc/apt/sources.list.d/bennetrr.list >/dev/null
    
    printf "\n\n\033[1m\033[42mInstalling bupdate\033[0m\n"
    sudo apt install -y bupdate
    
    printf "\n\n\033[1m\033[42mInstalling updates with bupdate\033[0m\n"
    printf "snap refresh\npkill bupdate\n" | sudo tee /etc/bupdate/custom.sh >/dev/null
    bupdate
    echo "snap refresh" | sudo tee /etc/bupdate/custom.sh >/dev/null
else
    printf "\n\n\033[1m\033[42mInstalling updates without bupdate\033[0m\n"
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt autoremove -y
fi

# Install zsh, OhMyZSH and plugins
if $zsh; then
    printf "\n\n\033[1m\033[42mInstalling zsh\033[0m\n"
    sudo apt install -y zsh

    printf "\n\n\033[1m\033[42mInstalling OhMyZSH and config files\033[0m\n"
    curl -fsSL -o- "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | bash
    cp -v .zshrc .p10k.zsh ~

    printf "\n\n\033[1m\033[42mInstalling zsh plugins\033[0m\n"
    git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" ~/.oh-my-zsh/custom/themes/powerlevel10k
    git clone "https://github.com/zsh-users/zsh-autosuggestions" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    printf "\n\n\033[1m\033[43mYou need to enter your password to set the default shell to zsh\033[0m\n"
    chsh -s /bin/zsh
fi

# Install nvm and node.js
if $node; then
    printf "\n\n\033[1m\033[42mInstalling nvm\033[0m\n"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh" | bash
    
    printf "\n\n\033[1m\033[42mWriting loading code into .zshrc\033[0m\n"
    echo '
# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
    
    printf "\n\n\033[1m\033[42mLoading nvm\033[0m\n"
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    printf "\n\n\033[1m\033[42mInstalling the LTS version of node.js\033[0m\n"
    nvm install --lts
fi

# Install .NET
if $dotnet; then
    # Installation with apt is not supported on raspbian
    if [[ "${os_distributor}" == "raspian" ]]; then
        printf "\n\n\033[1m\033[42mInstalling .NET with the installation script\033[0m\n"
        curl -o- "https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh" | bash
    else
        printf "\n\n\033[1m\033[42mInstalling .NET with apt\033[0m\n"

        # .NET is not included in the Ubuntu 21.10 sources yet, so we have to use the sources for Ubuntu 21.04
        # https://docs.microsoft.com/de-de/dotnet/core/install/linux-ubuntu#2110-
        if [[ "${os_version}" == "21.10" ]]; then
            echo "Version 21.10 of Ubuntu found, substituting version 21.04"
            dotnet_os_version="21.04"
        else
            dotnet_os_version="$os_version"
        fi

        wget -O dotnet.deb "https://packages.microsoft.com/config/$os_distributor/$dotnet_os_version/packages-microsoft-prod.deb"
        sudo dpkg -i dotnet.deb
        rm -v dotnet.deb

        sudo apt update
        sudo apt install -y apt-transport-https dotnet-sdk-6.0
    fi
fi

# Install PIP
if $python; then
    printf "\n\n\033[1m\033[42mInstalling PIP\033[0m\n"
    sudo apt install -y python3-pip
fi

# Install sdkman and java
if $java; then
    printf "\n\n\033[1m\033[42mInstalling sdkman\033[0m\n"
    sudo apt install -y zip unzip
    curl -s "https://get.sdkman.io" | bash
    source ~/.sdkman/bin/sdkman-init.sh

    printf "\n\n\033[1m\033[42mInstalling java\033[0m\n"
    sdk install java
fi

# Install docker
if $docker; then
    if [[ "${os_distributor}" == "raspian" ]]; then
        # Installation with apt is not supported on raspbian
        printf "\n\n\033[1m\033[42mInstalling docker with the script\033[0m\n"
        curl -fsSL -o- "https://get.docker.com" | sudo bash
    else
        printf "\n\n\033[1m\033[42mInstalling docker with apt\033[0m\n"
        sudo apt install -y ca-certificates gnupg
        curl -fsSL "https://download.docker.com/linux/$os_distributor/gpg" | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$os_distributor $os_codename stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io
    fi

    sudo usermod -aG docker "$USER"
fi

# Configure git
if $git; then
    # Install and configure Github CLI
    printf "\n\n\033[1m\033[42mInstalling Github CLI\033[0m\n"
    curl -fsSL "https://cli.github.com/packages/githubcli-archive-keyring.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

    sudo apt update
    sudo apt install -y gh
fi

# Install SSH Server
if $sshd; then
    printf "\n\n\033[1m\033[42mInstalling SSH Server\033[0m\n"
    sudo apt install -y openssh-server
fi

## Graphical tools
if $graphical; then
    # Install VS Code
    printf "\n\n\033[1m\033[42mInstalling VS Code\033[0m\n"
    wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install -y ./code.deb
    rm -v code.deb

    printf "\n\n\033[1m\033[42mInstalling languages for VS Code\033[0m\n"
    sudo apt install -y hunspell hunspell-de-de hunspell-en-us
    mkdir --parents ~/.config/Code/Dictionaries
    ln -s /usr/share/hunspell/* ~/.config/Code/Dictionaries

    printf "\n\n\033[1m\033[42mInstalling important tools\033[0m\n"
    # Install important tools like backup software, media players, etc.
    sudo apt install -y deja-dup gimp gparted inkscape keepass2 libreoffice nomacs gnome-system-monitor gnome-calculator vlc

    # Install Microsoft Teams
    if $teams; then
        printf "\n\n\033[1m\033[42mInstalling Microsoft Teams\033[0m\n"
        wget -O teams.deb "https://go.microsoft.com/fwlink/p/?LinkID=2112886&clcid=0x407&culture=de-de&country=DE"
        sudo apt -y install ./teams.deb
        rm -v teams.deb
    fi

    # Install Jetbrains Toolbox
    # https://gist.github.com/jessenich/70dc81bddfc00bb3a354139bc7fec6b2
    if $jetbrains; then
        printf "\n\n\033[1m\033[42mInstalling Jetbrains Toolbox\033[0m\n"
        wget -O toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
        toolbox_temp_dir=$(mktemp -d)

        tar -C "$toolbox_temp_dir" -xf toolbox.tar.gz
        rm -v ./toolbox.tar.gz

        "$toolbox_temp_dir"/*/jetbrains-toolbox
        rm -vdr "$toolbox_temp_dir"
    fi

    # Install Etcher and RPi Imager
    if $imagers; then
        printf "\n\n\033[1m\033[42mInstalling Balena Etcher\033[0m\n"
        curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' | sudo -E bash

        if [[ "${os_distributor}" != "raspbian" ]]; then
            printf "\n\n\033[1m\033[42mInstalling RPi Imager\033[0m\n"
            wget -O imager.deb "https://downloads.raspberrypi.org/imager/imager_latest_amd64.deb"
            sudo apt install -y ./imager.deb
            rm -v imager.deb
        fi
    fi

    # Install GitHub Desktop
    if $git; then
        printf "\n\n\033[1m\033[42mInstalling Github Desktop\033[0m\n"
        wget -qO - "https://mirror.mwt.me/ghd/gpgkey" | sudo tee /etc/apt/trusted.gpg.d/shiftkey-desktop.asc >/dev/null
        echo "deb [arch=amd64] https://mirror.mwt.me/ghd/deb any main" | sudo tee /etc/apt/sources.list.d/packagecloud-shiftkey-desktop.list >/dev/null
        sudo apt update
        sudo apt install -y github-desktop
    fi

    # Install MultiMC
    if $minecraft; then
        printf "\n\n\033[1m\033[42mInstalling MultiMC\033[0m\n"
        sudo apt install -y libqt5core5a libqt5network5 libqt5gui5
        wget -O multimc.deb "https://files.multimc.org/downloads/multimc_1.6-1.deb"
        sudo apt install -y ./multimc.deb
        rm -v multimc.deb
    fi

    # Install Timeular and apply a fix for the icons
    if $timeular; then
        printf "\n\n\033[1m\033[42mDownloading broken Timeular AppImage\033[0m\n"
        wget -O Timeular.broken.AppImage "https://s3.amazonaws.com/timeular-desktop-packages/linux/production/Timeular.AppImage"

        printf "\n\n\033[1m\033[42mFixing the Timeular AppImage\033[0m\n"
        chmod a+x Timeular.broken.AppImage
        ./Timeular.broken.AppImage --appimage-extract
        cp -v linux_connected.png linux_not_connected.png squashfs-root/resources/app.asar.unpacked/app/images

        wget -O appimagetool.AppImage "https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage"
        chmod a+x appimagetool.AppImage
        ./appimagetool.AppImage squashfs-root Timeular.AppImage
        rm -v appimagetool.AppImage

        printf "\n\n\033[1m\033[42mInstalling the fixed Timeular AppImage\033[0m\n"
        sudo mv -v Timeular.AppImage /opt/
        mkdir --parents ~/.local/share/applications
        cp -v timeular.png timeular.desktop ~/.local/applications
    fi

    printf "\n\n"
    # Install VirtualBox
    if $virtualbox; then
        printf "\n\n\033[1m\033[42mInstalling VirtualBox\033[0m\n"
        sudo apt install -y virtualbox virtualbox-ext-pack
    fi
fi

printf "\n\n\033[1m\033[44mThe setup is finished!\033[0m\n"
echo "Things to to next:"
echo "- Reboot your system to apply all changes"
if $zsh; then echo "- Adjust the '~/.zshrc' file for your needs"; fi
if $git; then echo "- Run 'gh auth login' to log in to Github CLI"; fi
if $git; then echo "- Set your GitHub Email and Username in git"; fi
if $bupdate; then echo "- Configure the bupdate custom file with 'bupdate -e'"; fi
if $java; then echo "- Install additional Java versions using the 'sdk' command"; fi
if $node; then echo "- Install additional node.js versions using the 'nvm' command"; fi
if $graphical; then
    echo "- Open VS Code and log in to Settings Sync, Live Share and Github"
    echo "- Configure your backups in Deja-Dup"
    echo "- Open your password database in KeePass"
    if $teams; then echo "- Log in to Microsoft Teams"; fi
    if $jetbrains; then echo "- Log in to Jetbrains Toolbox and install your IDEs"; fi
    if $git; then echo "- Log in to Github Desktop"; fi
    if $git; then echo "- Log in to Timeular, connect your Tracker and add Timeular to the autostart"; fi
    if $minecraft; then echo "- Open MultiMC, log in to your account and create / import your instances"; fi
fi
