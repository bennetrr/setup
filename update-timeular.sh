#! /bin/bash

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