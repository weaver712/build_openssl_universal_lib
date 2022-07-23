#!/bin/bash

OPENSSL_MAJOR_VERSION="3"
OPENSSL_VERSION="$OPENSSL_MAJOR_VERSION.0.5"

set -x
wget http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz
mv openssl-$OPENSSL_VERSION openssl_arm64
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz
mv openssl-$OPENSSL_VERSION openssl_x86_64
cd openssl_arm64
./Configure darwin64-arm64-cc
make -j
make
cd ../
cd openssl_x86_64
./Configure darwin64-x86_64-cc
make -j
make
cd ../
libtool -static openssl_arm64/libcrypto.a openssl_x86_64/libcrypto.a -o libcrypto.$OPENSSL_VERSION.a
libtool -static openssl_x86_64/libssl.a openssl_x86_64/libssl.a -o libssl.$OPENSSL_VERSION.a
rm openssl-$OPENSSL_VERSION.tar.gz

set +x
