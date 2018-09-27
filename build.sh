#!/bin/sh

set -o pipefail &&
time xcodebuild clean test \
    -workspace TableViewKit.xcworkspace \
    -scheme TableViewKit \
    -sdk iphonesimulator12.0 \
    -destination 'platform=iOS Simulator,name=iPhone XS,OS=12.0' \
| xcpretty
