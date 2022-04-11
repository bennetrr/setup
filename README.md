# bennetrr setup script
This script installs the software I need for developing.

## Usage
All you need to do is download / clone this repository, `cd` into the folder and run the script with `./setup.sh`. You may have to enter passwords, so watch out for the yellow text.

You can tell the script wether to install / not install some software with the following flags: 

| Flag | Function |
|------|----------|
| `--no-bupdate` | Don't install bupdate |
| `--no-zsh` | Don't install zsh |
| `--no-node`  | Don't install node.js|
| `--no-dotnet` | Don't install .Net SDK |
| `--no-python` | Don't install python3 pip |
| `--no-java` | Don't install Java |
| `--no-docker` | Don't install docker |
| `--no-git` | Don't install Github CLI and Github Desktop (GHD only if `--graphical` is issued) |
| `--graphical` | Install graphical applications |
| `--no-teams` | Don't install Microsoft Teams |
| `--no-jetbrain` | Don't install the Jetbrains Toolbox |
| `--no-imagers` | Don't install Balena Etcher and the Raspberry Pi Imager |
| `--no-minecraft` | Don't install MultiMC |
| `--no-timeular` | Don't install Timeular |
| `--no-virtualbox` | Don't install VirtualBox |
| `--no-sshd` | Don't install the OpenSSH Server |

## Applications
The installation of applications with an * is required and cannot be disabled.

### CLI
- git*
- [bupdate](https://github.com/bennetrr/bupdate)
- zsh
  - [OhMyZSH!](https://ohmyz.sh/)
  - [PowerLevel10k](https://github.com/romkatv/powerlevel10k)
  - [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [ZSH Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Github CLI](https://cli.github.com/)

### Languages & Environments
- Node.js (LTS Version)
  - [nvm](https://github.com/nvm-sh/nvm)
- Microsoft .NET SDK
- python3 pip
- Eclipse Temurin JDK (Latest version, at this time 17)
  - [SDKMAN!](https://sdkman.io/)
- Docker
- OpenSSH Server

### Graphical
- Visual Studio Code*
  - German and English Hunspell languages for VS Code
- [Déjà Dup](https://wiki.gnome.org/Apps/DejaDup/Details)*
- GIMP*, [Nomacs](https://nomacs.org/)*, [Inkscape](https://inkscape.org)*
- GParted*
- [KeePass 2](https://keepass.info/)*
- LibreOffice*
- Gnome System Monitor*
- Gnome Calc*
- VLC Media Player*
- [Microsoft Teams](https://www.microsoft.com/de-de/microsoft-teams/group-chat-software)
- [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)
- [Balena Etcher](https://www.balena.io/etcher/)
- [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
- [Github Desktop](https://desktop.github.com/)
- [MultiMC](https://multimc.org/)
- [Timeular](https://timeular.com/)
  - Fix the wrong Icons in the system tray
- VirtualBox


# Steps after Setup
- Reboot your system to apply all changes
- Adjust the `~/.zshrc` file for your needs
- Run `gh auth login` to log in to Github CLI
- Set your GitHub Email and Username in git
- Configure the bupdate custom file with `bupdate -e`
- Install additional Java versions using the `sdk` command
- Install additional node.js versions using the `nvm` command
- Open VS Code and log in to Settings Sync, Live Share and Github
- Configure your backups in Deja-Dup
- Open your password database in KeePass
- Log in to Microsoft Teams
- Log in to Jetbrains Toolbox and install your IDEs
- Log in to Github Desktop
- Log in to Timeular, connect your Tracker and add Timeular to the autostart
- Open MultiMC, log in to your account and create / import your instances
