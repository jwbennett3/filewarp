#!/bin/bash -ex

#if [[ -e /.dockerenv ]];then
  ## shellcheck disable=SC2029
  #ssh root@"$(hostname -I | awk '{print $1}')" ". /etc/environment && cd \$code/installation && ./build_layer.sh $1 $2 $3"
  #exit 0
#fi

#if [[ -z "$(which debootstrap)" ]];then
  #apk add debootstrap
#fi

if [[ -z "$(which debootstrap)" ]];then
  sudo apt install -y debootstrap
fi

chroot_image_dir=${chroot_image_dir:-/slowdata/cloud/chroots}
if [[ ! -e "$chroot_image_dir" ]];then
  echo "$chroot_image_dir does not exist"
  exit 1
fi

build_dir="/tmp/filewarp_build"

sudo rm -rf "$build_dir"
mkdir -p "$build_dir/resources"
cp -r ./* "$build_dir/resources"
cd "$build_dir"

full_layer_name="file-warp"

#mkdir -p "$chroot_image_dir/$full_layer_name"
if [[ -e "$chroot_image_dir/ubuntu-jammy.tar.gz" ]];then
  mkdir "$full_layer_name"
  sudo tar -xf "$chroot_image_dir/ubuntu-jammy.tar.gz" -C "$full_layer_name"
else
  sudo debootstrap --variant=buildd jammy "$full_layer_name"
fi

cd resources
#nvim="$(ls nvim-*.tar.gz)"
tar -xf nvim-0.6.1.tar.gz
rm nvim-*.tar.gz
cd ..
#mv "resources/$nvim_tar" .


sudo cp -r resources/* "$full_layer_name/usr/bin"

#sudo chroot "$full_layer_name"





