#!/bin/sh

vagrant plugin install vagrant-libvirt
vagrant up --provider=libvirt
