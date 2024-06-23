# created by Adtrace (Nasser Amini github.com/namini40) Apr 2022
# create archives and frameworks
rm -rf frameworks
mkdir frameworks 

cd ..


xcodebuild archive \
-scheme Adtrace \
-destination "generic/platform=iOS" \
-archivePath ./script/frameworks/Adtrace-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme Adtrace \
-destination "generic/platform=iOS Simulator" \
-archivePath ./script/frameworks/Adtrace-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES



xcodebuild archive \
-scheme AdtraceSdk \
-destination "generic/platform=iOS" \
-archivePath ./script/frameworks/AdtraceSdk-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceSdk \
-destination "generic/platform=iOS Simulator" \
-archivePath ./script/frameworks/AdtraceSdk-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES



xcodebuild archive \
-scheme AdtraceStatic \
-destination "generic/platform=iOS" \
-archivePath ./script/frameworks/AdtraceStatic-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceStatic \
-destination "generic/platform=iOS Simulator" \
-archivePath ./script/frameworks/AdtraceStatic-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS" \
-archivePath ./script/frameworks/AdtraceBridge-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS Simulator" \
-archivePath ./script/frameworks/AdtraceBridge-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS" \
-archivePath ./script/frameworks/AdtraceBridge-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS Simulator" \
-archivePath ./script/frameworks/AdtraceBridge-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES



xcodebuild -create-xcframework \
-framework ./script/frameworks/AdtraceSdk-iOS-Simulator.xcarchive/Products/Library/Frameworks/AdtraceSdk.framework \
-output ./script/frameworks/AdtraceSdk-iOS-Simulator.xcframework

xcodebuild -create-xcframework \
-framework ./script/frameworks/AdtraceSdk-iOS.xcarchive/Products/Library/Frameworks/AdtraceSdk.framework \
-output ./script/frameworks/AdtraceSdk-iOS.xcframework


cd script

