#!/bin/sh

set -o pipefail &&
time xcodebuild clean test \
    -workspace TableViewKit.xcworkspace \
    -scheme TableViewKit \
    -sdk iphonesimulator10.0 \
    -destination 'platform=iOS Simulator,name=iPhone 6s,OS=10.0' \
| xcpretty
