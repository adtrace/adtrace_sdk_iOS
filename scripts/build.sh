#!/usr/bin/env bash

set -e

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# ======================================== #

# Directories and paths of interest for the script.
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
cd ${ROOT_DIR}

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Removing framework targets folders ... ${NC}"
rm -rf frameworks
rm -rf Carthage
rm -rf build
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Creating framework targets folders ... ${NC}"
mkdir -p frameworks/static
mkdir -p frameworks/dynamic/ios
mkdir -p frameworks/dynamic/tvos
mkdir -p frameworks/dynamic/imessage
mkdir -p frameworks/dynamic/webbridge
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding static SDK framework and copying it to destination folder ... ${NC}"
xcodebuild -target AdtraceStatic -configuration Release clean build
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding universal tvOS SDK framework (device + simulator) and copying it to destination folder ... ${NC}"
xcodebuild -configuration Release -target AdtraceSdkTv -arch x86_64 -sdk appletvsimulator clean build
xcodebuild -configuration Release -target AdtraceSdkTv -arch arm64 -sdk appletvos build
cp -Rv build/Release-appletvos/AdtraceSdkTv.framework frameworks/static
lipo -create -output frameworks/static/AdtraceSdkTv.framework/AdtraceSdkTv build/Release-appletvos/AdtraceSdkTv.framework/AdtraceSdkTv build/Release-appletvsimulator/AdtraceSdkTv.framework/AdtraceSdkTv
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Moving shared schemas to generate dynamic iOS and tvOS SDK framework using Carthage ... ${NC}"
mv Adtrace.xcodeproj/xcshareddata/xcschemes/AdtraceSdkIm.xcscheme \
   Adtrace.xcodeproj/xcshareddata/xcschemes/AdtraceSdkWebBridge.xcscheme .
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding dynamic iOS and tvOS targets with Carthage ... ${NC}"
#carthage build --no-skip-current
./scripts/carthage_xcode12.sh build --no-skip-current
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Move Carthage generated dynamic iOS SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/ios
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Move Carthage generated dynamic tvOs SDK framework to destination folder ... ${NC}"
mv Carthage/Build/tvOS/* frameworks/dynamic/tvos/
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Moving shared schemas to generate dynamic iMessage SDK framework using Carthage ... ${NC}"
mv Adtrace.xcodeproj/xcshareddata/xcschemes/AdtraceSdk.xcscheme \
   Adtrace.xcodeproj/xcshareddata/xcschemes/AdtraceSdkTv.xcscheme .
mv AdtraceSdkIm.xcscheme Adtrace.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding dynamic iMessage target with Carthage ... ${NC}"
#carthage build --no-skip-current
./scripts/carthage_xcode12.sh build --no-skip-current
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Move Carthage generated dynamic iMessage SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/imessage/
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Moving shared schemas to generate dynamic WebBridge SDK framework using Carthage ... ${NC}"
mv Adtrace.xcodeproj/xcshareddata/xcschemes/AdtraceSdkIm.xcscheme .
mv AdtraceSdkWebBridge.xcscheme Adtrace.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding dynamic WebBridge target with Carthage ... ${NC}"
#carthage build --no-skip-current
./scripts/carthage_xcode12.sh build --no-skip-current
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Move Carthage generated dynamic WebBridge SDK framework to destination folder ... ${NC}"
mv Carthage/Build/iOS/* frameworks/dynamic/webbridge/
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Moving shared schemas back ... ${NC}"
mv *.xcscheme Adtrace.xcodeproj/xcshareddata/xcschemes
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding static test library framework and copying it to destination folder ... ${NC}"
cd ${ROOT_DIR}/AdtraceTests/AdtraceTestLibrary
xcodebuild -target AdtraceTestLibraryStatic -configuration Debug clean build
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Script completed! ${NC}"
