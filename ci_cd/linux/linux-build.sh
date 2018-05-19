#!/bin/bash
value=`cat buildversion.txt`
BUILD_VERSION="$(echo -e "${value}" | tr -d '[:space:]')"

git clone --depth=50 --branch=development https://github.com/dannagle/PacketSender
cd PacketSender/src
qmake --version
qmake PacketSender.pro
make -j4
ls
mkdir -p appdir/usr/bin ; cd appdir
find ..
cp ../PacketSender usr/bin/
cp ../packetsender.desktop .
cp ../psicons.iconset/icon_256x256.png packetsender.png
cd ..
wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt*.AppImage
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
./linuxdeployqt*.AppImage ./appdir/usr/bin/PacketSender -bundle-non-qt-libs
./linuxdeployqt*.AppImage ./appdir/usr/bin/PacketSender -appimage
rm -rf /home/dan/installers/PacketSender_Linux_x64_v$BUILD_VERSION.AppImage || true
mv PacketSender-x86_64.AppImage /home/dan/installers/PacketSender_Linux_x64_v$BUILD_VERSION.AppImage

#curl --upload-file ./PacketSender-*.AppImage https://transfer.sh/PacketSender-git$(git rev-parse --short HEAD)-x86_64.AppImage
