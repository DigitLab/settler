#!/usr/bin/env bash

# install required vagrant plugin to handle reloads during provisioning
vagrant plugin install vagrant-reload

# start with no machines
vagrant destroy -f
rm -rf .vagrant

time vagrant up --provider parallels 2>&1 | tee parallels-build-output.log
vagrant halt
# shrink disk (assumes running on osx)
prl_disk_tool compact --hdd ~/Documents/Parallels/settler_*/harddisk1.hdd
## 'vagrant package' does not work with parallels boxes (http://parallels.github.io/vagrant-parallels/docs/boxes/base.html)
rm -f ~/Documents/Parallels/settler_*/*.log
cp -r ~/Documents/Parallels/settler_* box.pvm
tar cvzf parallels.box ./box.pvm ./metadata.json
rm -Rf ./box.pvm

ls -lh parallels.box
vagrant destroy -f
rm -rf .vagrant