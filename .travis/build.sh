#!/bin/bash -e

change_file_value() {
    local _config="${1}"
    local _variable="${2}"
    local _value="${3}"

    awk -F '=' '/^export '"${_variable}"'=.+/ { print $1 "='"${_value}"'"; getline; } { print; }' "${_config}" > "${_config}.tmp"
    mv "${_config}.tmp" "${_config}"
}

for var in "TRAVIS_BRANCH" "TRAVIS_COMMIT" "BUILD_TYPE"; do
    if ! set 2>&1 | grep -q -E "^${var}=.+$"; then
        printf -- "Environment variable \`${var}' was not set\n"
        exit 1
    fi
done

pwd

set -x

git clone --depth=100 --branch=${TRAVIS_BRANCH} https://github.com/ijacquez/libyaul-build-scripts.git libyaul-build-scripts
cd libyaul-build-scripts
git checkout -q -f ${TRAVIS_COMMIT}

cp config.in config.env

change_file_value "config" "BUILD_HOST" ""
change_file_value "config" "BUILD_TARGETS" "sh-elf m68k-elf"
change_file_value "config" "BUILD_INSTALL_DIR" "/tool-chains"
change_file_value "config" "BUILD_SRC_DIR" "/tmp"
change_file_value "config" "OPTION_DOWNLOAD_TARBALLS" "yes"
change_file_value "config" "OPTION_BUILD_GDB" "no"
change_file_value "config" "OPTION_BUILD_MAKE" "no"

cat config

./build-compiler
