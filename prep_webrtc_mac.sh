#!/bin/sh
# TODO - Need to check that gclient exists.
# TODO - Make sure wget is present
mkdir -p third_party/webrtc
cd third_party/webrtc

echo Getting webrtc from its repo into third_party/webrtc
gclient config http://webrtc.googlecode.com/svn/trunk
gclient sync -r 731 --force

echo Replacing standard files with our modified versions from third_party_mods
cp -R ../../third_party_mods/webrtc ../../third_party
# patch up the libsrtp by config'ing it in preparation for later build steps.
cd trunk/third_party/libsrtp
./configure CFLAGS="-m32 -arch i386" LDFLAGS="-m32 -arch i386"
make
cd ../../..

echo Resetting/Rebuilding project files...
python trunk/build/gyp_chromium --depth=trunk ../../src/examples/cmdline_audio_peer/cmdline_audio_peer.gyp

echo third_party/webrtc/trunk contains webrtc.xcodeproj for XCode.
echo NOTE: Be sure to MODERNIZE all projects.
echo This can be done by selecting target 'All (webrtc project)' and
echo "clicking on the warnings (command-4) then clicking on each warning"
echo and modernizing these projects.
