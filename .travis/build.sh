#!/bin/bash -e

change_file_value() {
    local _config="${1}"
    local _variable="${2}"
    local _value="${3}"

    if [ -f "${_config}" ]; then
        cat "${_config}" | sed -E 's#^'"${_variable}"'=\"[^\"]*\"$#'"${_variable}"'=\"'"${_value}"'\"#g;
                                   s#^'"${_variable}"'=[^\"]*$#'"${_variable}"'='"${_value}"'#g' \
                           2>&1 > "${_config}.tmp"
        mv "${_config}.tmp" "${_config}"
    fi
}

for var in "TRAVIS_BRANCH" "TRAVIS_COMMIT" "BUILD_TYPE"; do
    if ! set 2>&1 | grep -q -E "^${var}=.+$"; then
        printf -- "Environment variable \`${var}' was not set\n"
        exit 1
    fi
done

pwd

set -x

export TMP_DIR="/tmp/build-`date '+%s-%d-%m-%Y'`"

mkdir -p "${TMP_DIR}"

git clone --branch="${TRAVIS_BRANCH}" https://github.com/ijacquez/libyaul-build-scripts.git libyaul-build-scripts
cd libyaul-build-scripts
git checkout -q -f ${TRAVIS_COMMIT}

set +x

cp config.in config

change_file_value "config" "BUILD_HOST" ""
change_file_value "config" "BUILD_TARGETS" "sh-elf m68k-elf"
change_file_value "config" "BUILD_INSTALL_DIR" "/tool-chains"
change_file_value "config" "BUILD_SRC_DIR" "${TMP_DIR}"
change_file_value "config" "OPTION_DOWNLOAD_TARBALLS" "yes"
change_file_value "config" "OPTION_BUILD_GDB" "no"
change_file_value "config" "OPTION_BUILD_MAKE" "no"

printf -- ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
cat config
printf -- "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"

# For debugging purposes
bash -x build-compiler || {
    find /tmp -type f -iname "*-elf.log" 2>/dev/null | while IFS= read -r path; do
        printf -- ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        cat "${path}" 2>/dev/null 2>&1 | while IFS= read -r line; do
            printf -- "${path##/tmp/}: ${line}\n"
        done
    done

    printf -- ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"

    for log in "${TMP_DIR}"/*.log; do
        cat "${log}" | while IFS= read -r line; do
            printf -- "%s\n" "${log}: ${line}"
        done
    done

    exit 1
}
