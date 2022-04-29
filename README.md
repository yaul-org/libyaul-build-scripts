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
| MacOS X          | `sh2eb-elf/host-x86_64-apple-darwin.config`   | Canadian | No         |
| Windows (MinGW)  | `sh2eb-elf/host-x86_64-w64-mingw32.config`    | Canadian | Yes        |
| Windows (Cygwin) | `sh2eb-elf/host-x86_64-unknown-cygwin.config` | Canadian | No         |
| Windows (WSL2)   | `sh2eb-elf/host-x86_64-w64-mingw32.config`    | Canadian | Yes        |

### M68k

_Currently unavailable._

## Build requirements

<details>
  <summary>Debian based and WSL2 Ubuntu</summary>

```
apt install \
  texinfo \
  help2man \
  curl \
  lzip \
  meson \
  ninja-build \
  mawk/gawk \
  libtool-bin \
  ncurses-dev \
  flex \
  bison
```

</details>

<details>
  <summary>FreeBSD</summary>

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

</details>

## Build `crosstool-ng`

<details>
  <summary>Linux</summary>

```
git submodule init
git submodule update

cd crosstool-ng
./bootstrap
./configure --enable-local
make
```

</details>

<details>
  <summary>Windows (WSL2)</summary>

```
git submodule init
git submodule update

cd crosstool-ng
./bootstrap
./configure --enable-local
make
sudo bash -c "echo 0 > /proc/sys/fs/binfmt_misc/status"
```

</details>

<details>
  <summary>FreeBSD</summary>

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

</details>

## Build tool-chain

```
cd ..
cp sh2eb-elf/<file>.config .config
crosstool/ct-ng build
```
