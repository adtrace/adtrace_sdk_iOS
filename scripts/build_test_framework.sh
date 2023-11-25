#!/usr/bin/env bash

# ======================================== #

echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Bulding static test library framework and copying it to destination folder ... ${NC}"
cd "AdtraceTests/AdtraceTestLibrary"
xcodebuild -target AdtraceTestLibraryStatic -configuration Debug clean build
cd -
echo -e "${CYAN}[ADTRACE][BUILD]:${GREEN} Done! ${NC}"

# ======================================== #

