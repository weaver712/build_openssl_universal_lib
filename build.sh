#!/bin/bash

BASEDIR=$(dirname "$0")

cd $BASEDIR

OPENSSL_MAJOR_VERSION="3"
OPENSSL_VERSION="$OPENSSL_MAJOR_VERSION.0.5"

set -x

if [ ! -f openssl-$OPENSSL_VERSION.tar.gz ]
then
  wget http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
  if [ $? -ne 0 ]; then
    exit 1
  fi
fi

rm -rf include lib/macos openssl_arm64 openssl_x86_64

tar -xvzf openssl-$OPENSSL_VERSION.tar.gz
mv openssl-$OPENSSL_VERSION openssl_arm64
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz
mv openssl-$OPENSSL_VERSION openssl_x86_64
cd openssl_arm64
./Configure darwin64-arm64-cc --prefix=`pwd`/install_dir
make -j
make
make install
if [ $? -ne 0 ]; then
  exit 2
fi
cp -r install_dir/include ../include

cd ../openssl_x86_64
./Configure darwin64-x86_64-cc
make -j
make
if [ $? -ne 0 ]; then
  exit 3
fi

cd ../
mkdir -p lib/macos/
lipo -create openssl_arm64/libcrypto.a openssl_x86_64/libcrypto.a -o lib/macos/libcrypto.a
if [ $? -ne 0 ]; then
  exit 4
fi
lipo -create openssl_arm64/libssl.a openssl_x86_64/libssl.a -o lib/macos/libssl.a
if [ $? -ne 0 ]; then
  eixt 5
fi

rm -rf openssl_arm64 openssl_x86_64

set +x

exit 0
