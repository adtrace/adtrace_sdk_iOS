# created by Adtrace (Nasser Amini github.com/namini40) Apr 2022
# create archives and frameworks
rm -rf frameworks
mkdir frameworks 


xcodebuild archive \
-scheme Adtrace \
-destination "generic/platform=iOS" \
-archivePath ./frameworks/Adtrace-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme Adtrace \
-destination "generic/platform=iOS Simulator" \
-archivePath ./frameworks/Adtrace-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES



xcodebuild archive \
-scheme AdtraceSdk \
-destination "generic/platform=iOS" \
-archivePath ./frameworks/AdtraceSdk-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceSdk \
-destination "generic/platform=iOS Simulator" \
-archivePath ./frameworks/AdtraceSdk-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES



xcodebuild archive \
-scheme AdtraceStatic \
-destination "generic/platform=iOS" \
-archivePath ./frameworks/AdtraceStatic-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceStatic \
-destination "generic/platform=iOS Simulator" \
-archivePath ./frameworks/AdtraceStatic-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS" \
-archivePath ./frameworks/AdtraceBridge-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS Simulator" \
-archivePath ./frameworks/AdtraceBridge-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS" \
-archivePath ./frameworks/AdtraceBridge-iOS \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme AdtraceBridge \
-destination "generic/platform=iOS Simulator" \
-archivePath ./frameworks/AdtraceBridge-iOS-Simulator \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES



xcodebuild -create-xcframework \
-framework ./frameworks/AdtraceSdk-iOS-Simulator.xcarchive/Products/Library/Frameworks/AdtraceSdk.framework \
-output ./frameworks/AdtraceSdk-iOS-Simulator.xcframework

xcodebuild -create-xcframework \
-framework ./frameworks/AdtraceSdk-iOS.xcarchive/Products/Library/Frameworks/AdtraceSdk.framework \
-output ./frameworks/AdtraceSdk-iOS.xcframework




