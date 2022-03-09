#!/bin/bash

yum update -y

cd /opt

wget --no-check-certificate https://www.factorio.com/get-download/1.1.53/headless/linux64
mv ./linux64 factorio_headless_x64.tar.xz
xz -dv factorio_headless_x64.tar.xz
tar xvf factorio_headless_x64.tar

cd /opt/factorio
./bin/x64/factorio --create
