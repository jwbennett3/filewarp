#!/bin/bash -ex

#if [[ -e /.dockerenv ]];then
  ## shellcheck disable=SC2029
  #ssh root@"$(hostname -I | awk '{print $1}')" ". /etc/environment && cd \$code/installation && ./build_layer.sh $1 $2 $3"
  #exit 0
#fi

#if [[ -z "$(which debootstrap)" ]];then
  #apk add debootstrap
#fi



chroot_image_dir=${chroot_image_dir:-/slowdata/cloud/chroots}
if [[ ! -e "$chroot_image_dir" ]];then
  echo "$chroot_image_dir does not exist"
  exit 1
fi

build_dir="/tmp/filewarp_build"

#[[ -e /tmp/filewarp_build/file-warp/proc  ]] && mount | grep -q /tmp/filewarp_build/file-warp/proc && sudo umount -l /tmp/filewarp_build/file-warp/proc && sudo rmdir "$build_dir/file-warp/proc"
#[[ -e /tmp/filewarp_build/file-warp/sys ]] && mount | grep -q /tmp/filewarp_build/file-warp/sys && sudo umount -l /tmp/filewarp_build/file-warp/sys && sudo rmdir "$build_dir/file-warp/sys"
#[[ -e /tmp/filewarp_build/file-warp/dev ]] && mount | grep -q /tmp/filewarp_build/file-warp/dev && sudo umount -l /tmp/filewarp_build/file-warp/dev && sudo rmdir "$build_dir/file-warp/dev"
[[ -e /tmp/filewarp_build/file-warp/host ]] && mount | grep -q /tmp/filewarp_build/file-warp/host && sudo umount -l /tmp/filewarp_build/file-warp/host && sudo rmdir "$build_dir/file-warp/host"

sudo rm -rf "$build_dir"
mkdir -p "$build_dir/resources"
cp -r ./* "$build_dir/resources"
cd "$build_dir"

full_layer_name="file-warp"

#mkdir -p "$chroot_image_dir/$full_layer_name"
if [[ ! -e "$chroot_image_dir/ubuntu-jammy.tar.gz" ]];then
  if [[ -z "$(which debootstrap)" ]];then
    sudo apt install -y debootstrap
  fi
  sudo debootstrap --variant=buildd jammy ubuntu-jammy
  cd ubuntu-jammy
  sudo tar -zcf ubuntu-jammy.tar.gz ./*
  cd ..
  sudo mv ubuntu-jammy.tar.gz "$chroot_image_dir"
  sudo rm -rf ubuntu-jammy
fi
mkdir "$full_layer_name"
sudo tar -xf "$chroot_image_dir/ubuntu-jammy.tar.gz" -C "$full_layer_name"


cd resources
#nvim="$(ls nvim-*.tar.gz)"
tar -xf nvim-0.6.1.tar.gz
rm nvim-*.tar.gz
cd ..
#mv "resources/$nvim_tar" .


sudo cp -r resources/* "$full_layer_name/usr/bin"
sudo mv  $full_layer_name/usr/bin/ipc/* "$full_layer_name/usr/bin"
sudo mkdir -p "$full_layer_name/share/nvim/syntax"
sudo mv "$full_layer_name/usr/bin/syntax.vim" "$full_layer_name/share/nvim/syntax/syntax.vim"

git clone https://github.com/junegunn/fzf.git
cd fzf
git checkout 3f90fb42d8871920138ace9878502f22a4d91e85
cd ..
#mv fzf/bin/fzf "$full_layer_name/usr/bin"
mv fzf "$full_layer_name"

#sudo mount -t proc /proc /tmp/filewarp_build/file-warp/proc
#sudo mount --rbind /sys /tmp/filewarp_build/file-warp/sys
#sudo mount --rbind /dev /tmp/filewarp_build/file-warp/dev

mkdir "$full_layer_name/host"



sudo chroot "$full_layer_name" chroot_install.sh

sudo rm -rf $full_layer_name/dev
sudo ln -s /host/dev $full_layer_name/dev

tar -zcf "$full_layer_name.tar.gz" "$full_layer_name"
mv "$full_layer_name.tar.gz" "$chroot_image_dir/"



