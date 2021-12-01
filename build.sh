#!/bin/bash

# [ -n STRING ]: True if the length of "STRING" is non-zero.
# [ -z STRING ]: True if the length of "STRING" is zero.

set -e
set -o pipefail

if [[ -z "$BUILD_DIR" ]]; then
    BUILD_DIR="."
fi

if [[ -z "$CONFIG_FILE" ]]; then
    CONFIG_FILE="config.live.toml"
fi

main() {
    version=$(zola --version)

    echo "Using $version"

    echo "Building in $BUILD_DIR directory"
    cd $BUILD_DIR

    echo Building with flags: ${BUILD_FLAGS:+"$BUILD_FLAGS"}
    zola --config ${CONFIG_FILE} build ${BUILD_FLAGS:+$BUILD_FLAGS}
}

main "$@"
