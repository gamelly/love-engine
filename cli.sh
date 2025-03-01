#!/bin/sh

set -e

if [ ! -d "vendor" ]; then
    mkdir -p vendor
fi

if [ ! -f "build.json" ]; then
    echo '{
    "meta": {
        "title": "MyAwesomeGame",
        "author": "AwesomeAuthor",
        "version": "1.0.0"
    },
    "args": {
        "fengari": true,
        "gamepadzilla": false
    }
}' > build.json
fi

if [ ! -f "vendor/cli.lua" ]; then
    wget -P vendor https://get.gamely.com.br/cli.lua
fi

if [ ! -f "vendor/bundler_cli.lua" ]; then
    wget -P vendor https://get.gamely.com.br/bundler_cli.lua
fi

if [ ! -f "vendor/index.mustache" ]; then
    wget -P vendor https://raw.githubusercontent.com/gamelly/gly-engine/refs/heads/main/src/engine/core/html5/index.mustache
fi

if [ "$1" = "build" ]; then
    rm -Rf dist
    mkdir -p dist
    lua vendor/bundler_cli.lua src/love.lua dist/main.lua
    sed -E -i 's/-- part ([^ ]+) - /\1()/' dist/main.lua

    if echo "$@" | grep -q -- "--npm"; then
        mkdir -p dist/dist
        mv dist/main.lua dist/dist
        cp package.json dist
        cp README.md dist
    elif echo "$@" | grep -q -- "--html"; then
        lua vendor/cli.lua fs-mustache build.json vendor/index.mustache dist/index.html
        sed -E  -i 's|driver-fengari.js|https://cdn.jsdelivr.net/gh/gamelly/gly-engine@0.0.19/ee/engine/core/html5/driver-fengari.js|g' dist/index.html
        sed -E  -i 's|driver-wasmoon.js|https://cdn.jsdelivr.net/gh/gamelly/gly-engine@0.0.19/src/engine/core/html5/driver-wasmoon.js|g' dist/index.html
        sed -E  -i 's|core-media-html5.js|https://cdn.jsdelivr.net/gh/gamelly/gly-engine@0.0.19/src/engine/core/html5/core-media-html5.js|g' dist/index.html
        sed -E  -i 's|core-native-html5.js|https://cdn.jsdelivr.net/npm/@gamely/core-native-html5@0.0.19/dist/index.js|g' dist/index.html
    fi
    if [ -n "$2" ] && [ "${2%--*}" = "$2" ]; then
        cp "$2" dist/game.lua
    fi
else
    echo "usage: ./cli.sh build [game.lua] --html"
fi
