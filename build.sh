#!/bin/bash

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

    zola --config ${CONFIG_FILE} build
    chmod -R 777 dist
}

main "$@"
