#!/bin/sh
# TODO - Need to check that gclient exists.
# TODO - Make sure wget is present
mkdir -p third_party/webrtc
cd third_party/webrtc

echo Getting webrtc from its repo into third_party/webrtc
gclient config http://webrtc.googlecode.com/svn/trunk
gclient sync --force

echo Replacing standard files with our modified versions from third_party_mods
cp -R ../../third_party_mods/webrtc ../../third_party
# patch up the libsrtp by config'ing it in preparation for later build steps.
cd third_party/libsrtp
./configure
make
cd ../..

echo Resetting/Rebuilding project files...
gclient runhooks --force

echo third_party/webrtc/trunk contains webrtc.xcodeproj for XCode.
echo NOTE: Be sure to MODERNIZE all projects.
echo This can be done by selecting target 'All (webrtc project)' and
echo clicking on the warnings (command-4) then clicking on each warning
echo and modernizing these projects.