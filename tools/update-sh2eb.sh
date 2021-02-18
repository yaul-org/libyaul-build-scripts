#!/bin/bash
{
FROM="sh2eb-elf/native-linux.config"

# Replace matching KEY or append KEY=NEW-VALUE line.
function replace_or_append_v() {
    [ -n "${CONFIG}" ] || { printf "\${CONFIG} is not set\\n" >&2; exit 1; }

    sed -E -i '
/^'"${1}"'=/{
h
s/=.*/='"${2}"'/
}
${
x
/^$/{
s//'"${1}"'='"${2}"'/
H
}
x
}' "${CONFIG}"
}

# Replace matching KEY or append NEW-KEY=NEW-VALUE line.
function replace_or_append_kv() {
    [ -n "${CONFIG}" ] || { printf "\${CONFIG} is not set\\n" >&2; exit 1; }

    sed -E -i '
/^'"${1}"'=.*/{
h
s/.*=.*/'"${2}"'='"${3}"'/
}
${
x
/^$/{
s//'"${2}"'='"${3}"'/
H
}
x
}' "${CONFIG}"
}

# Replace matching KEY or append quoted KEY="NEW-VALUE" line.
function replace_or_append_qv() {
    replace_or_append_v "${1}" "\"${2}\""
}

# Replace matching KEY or append NEW-KEY="NEW-VALUE" line.
function replace_or_append_kqv() {
    replace_or_append_kv "${1}" "${2}" "\"${3}\""
}

# Delete matching KEY line.
function delete() {
    [ -n "${CONFIG}" ] || { printf "\${CONFIG} is not set\\n" >&2; exit 1; }

    sed -E -i '/^'"${1}"'/d' "${CONFIG}"
}

# Replace config.
function replace_config() {
    [ -n "${FROM}" ] || { printf "\${FROM} is not set\\n" >&2; exit 1; }
    [ -n "${CONFIG}" ] || { printf "\${CONFIG} is not set\\n" >&2; exit 1; }
    [ -e "${FROM}" ] || { printf "Cannot find source file: \"%s\"\\n" "${FROM}" >&2; exit 1; }
    cp "${FROM}" "${CONFIG}" 2>/dev/null || { printf "Unable to replace file: \"%s\"\\n" "${TO}" >&2; exit 1; }
}

set -e

CONFIG="sh2eb-elf/native-macosx.config"
replace_config
replace_or_append_v  "CT_GDB_CROSS"             "n"
replace_or_append_v  "CT_GDB_CROSS_STATIC"      "n"

CONFIG="sh2eb-elf/host-x86_64-w64-mingw32.config"
replace_config
replace_or_append_kv "CT_CROSS"                 "CT_CANADIAN" "y"
replace_or_append_qv "CT_TOOLCHAIN_TYPE"        "canadian"
replace_or_append_qv "CT_HOST"                  "x86_64-w64-mingw32"
replace_or_append_qv "CT_HOST_PREFIX"           ""
replace_or_append_qv "CT_HOST_SUFFIX"           ""

CONFIG="sh2eb-elf/host-i686-pc-linux-gnu.config"
replace_config
replace_or_append_kv "CT_CROSS"                 "CT_CANADIAN" "y"
replace_or_append_qv "CT_TOOLCHAIN_TYPE"        "canadian"
replace_or_append_qv "CT_HOST"                  "i686-pc-linux-gnu"
replace_or_append_qv "CT_HOST_PREFIX"           ""
replace_or_append_qv "CT_HOST_SUFFIX"           ""
}
