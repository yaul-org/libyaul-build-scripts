Yaul build scripts
===

Build scripts for Yaul.

## List of configurations

### SH-2

| Platform         | Configuration file                            | Type     | Available? |
|------------------|-----------------------------------------------|----------|------------|
| Linux            | `sh2eb-elf/native-linux.config`               | Native   | Yes        |
| MacOS X          | `sh2eb-elf/native-macosx.config`              | Native   | Yes        |
| Linux            | `sh2eb-elf/host-i686-pc-linux-gnu.confg`      | Canadian | Yes        |
| MacOS X          | `sh2eb-elf/host-x86_64-apple-darwin*.config`  | Canadian | No         |
| Windows (MinGW)  | `sh2eb-elf/host-x86_64-w64-mingw32.config`    | Canadian | Yes        |
| Windows (Cygwin) | `sh2eb-elf/host-x86_64-unknown-cygwin.config` | Canadian | No         |

### M68k

_Currently unavailable._

## Build requirements

### Debian based

```
apt install \
  binutils-mingw-w64-x86-64 \
  gcc-mingw-w64-x86-64 \
  g++-mingw-w64-x86-64
```

### FreeBSD

```
pkg install \
  autotools \
  gsed \
  texinfo \
  help2man \
  gawk \
  lzma \
  wget \
  bison \
  coreutils \
  gmake \
  unix2dos
```

## Build `crosstool-ng`

### Linux

```
git submodule init
git submodule update

cd crosstool-ng
./bootstrap
./configure --enable-local
make
```

### FreeBSD

```
git submodule init
git submodule update

cd crosstool-ng
./bootstrap

MAKE=/usr/local/bin/gmake \
INSTALL=/usr/local/bin/ginstall \
SED=/usr/local/bin/gsed \
PATCH=/usr/local/bin/gpatch \
./configure --enable-local

gmake
```

### Build tool-chain

```
cd ..
cp sh2eb-elf/native.config .config
crosstool/ct-ng build
find ~/x-tools/x -type d -exec chmod u+w '{}' \;
```
