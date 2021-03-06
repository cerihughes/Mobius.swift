#!/bin/bash

root=`dirname $0`
source "$root/../../helpers.sh"

project=$root/MobiusCarthageTest.xcodeproj
platforms=(iOS)

heading "Preparing Carthage build"

pushd $root > /dev/null
joined_platforms=$(IFS=,; echo "${platforms[*]}")
carthage update --cache-builds --platform $joined_platforms
success=$?
popd
if [ ! $success ]; then
    fail "Carthage update failed"
fi

for platform in ${platforms[@]}; do
    heading "Building for $platform using Carthage"
    scheme=MobiusCarthageTest_$platform

    xcb -project $project -scheme $scheme || \
        fail "Carthage build for $platform failed"
done
