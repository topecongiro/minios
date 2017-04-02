#!/bin/sh

ROOT=`pwd`
PREFIX="$HOME/opt/cross"
DEP_SRC_DIR="${ROOT}/dep"
TARGET=i686-elf

mkdir -p ${PREFIX}
mkdir -p ${DEP_SRC_DIR}

# binutils
BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"
BINUTILS_TAR="${DEP_SRC_DIR}/binutils-2.28.tar.gz"
BINUTILS_SRC="${DEP_SRC_DIR}/binutils-2.28"
if [ ! -f ${PREFIX}/bin/${TARGET}-ld ]; then
    echo "Start preparing binutils..."
    if [ ! -f ${BINUTILS_TAR} ]; then
        echo "Downloading binutils..."
        curl ${BINUTILS_URL} -o ${BINUTILS_TAR}
    fi
    mkdir -p ${BINUTILS_SRC}
    tar -xzf ${BINUTILS_TAR} -C ${DEP_SRC_DIR}

    # Build binutils
    cd ${BINUTILS_SRC}
    mkdir -p build-binutils
    cd build-binutils
    ../configure --target=${TARGET} --prefix=${PREFIX} ${OPTIONS} \
                 --with-sysroot --disable-nls --disable-werror
    make
    make install
else
    echo "binutils ready"
fi

cd ${ROOT}

# gcc
GCC_URL="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.gz"
GCC_TAR="${DEP_SRC_DIR}/gcc-6.3.0.tar.gz"
GCC_SRC="${DEP_SRC_DIR}/gcc-6.3.0"
if [ ! -f ${PREFIX}/bin/${TARGET}-gcc ]; then
    echo "Start preparing gcc..."
    if [ ! -f ${GCC_TAR} ]; then
        echo "Downloading gcc..."
        curl ${GCC_URL} -o ${GCC_TAR}
    fi
    mkdir -p ${GCC_SRC}
    tar -xzf ${GCC_TAR} -C ${DEP_SRC_DIR}

    # Build gcc
    cd ${GCC_SRC}
    mkdir -p build-gcc
    cd build-gcc
    ../configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc
else
    echo "gcc ready"
fi

export PATH="$PREFIX/bin:$PATH"
