Yaul build scripts
===
Build scripts for Yaul.
## List of configurations
### SH-2
| Platform         | Configuration file                            | Currently available? |
|------------------|-----------------------------------------------|----------------------|
| Native           | `sh2eb-elf/native.config`                     | Yes                  |
| Native (MacOS X) | `sh2eb-elf/native-macosx.config`              | Yes                  |
| Linux            | `sh2eb-elf/host-i686-pc-linux-gnu.confg`      | Yes                  |
| Windows (MinGW)  | `sh2eb-elf/host-i686-w64-mingw32.config`      | Yes                  |
| Windows (MinGW)  | `sh2eb-elf/host-x86_64-w64-mingw32.config`    | Yes                  |
| Windows (Cygwin) | `sh2eb-elf/host-x86-unknown-cygwin.config`    | No                   |
| Windows (Cygwin) | `sh2eb-elf/host-x86_64-unknown-cygwin.config` | No                   |
| MacOS X          | `sh2eb-elf/host-x86_64-apple-darwin*.config`  | No                   |
### M68k
_Currently unavailable._
## Build requirements
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
