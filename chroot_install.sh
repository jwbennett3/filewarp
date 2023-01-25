#!/bin/bash -e

apt-get install -y wget sudo
cd /fzf
yes | ./install
mv bin/fzf /usr/bin
rm -rf /fzf
