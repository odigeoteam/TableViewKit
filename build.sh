#!/bin/sh

set -o pipefail &&
time xcodebuild clean test \
    -workspace TableViewKit.xcworkspace \
    -scheme TableViewKit \
    -sdk iphonesimulator9.3 \
    -destination 'platform=iOS Simulator,name=iPhone 6s,OS=9.3' \
| xcpretty
