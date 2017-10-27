#!/bin/sh

set -o pipefail &&
time xcodebuild clean test \
    -workspace TableViewKit.xcworkspace \
    -scheme TableViewKit \
    -sdk iphonesimulator11.0 \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=11.0' \
| xcpretty
