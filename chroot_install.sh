#!/bin/bash -e

apt-get install -y wget sudo uuid-runtime
cd /fzf
yes | ./install
mv bin/fzf /usr/bin
rm -rf /fzf
