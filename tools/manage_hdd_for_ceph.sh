#!/bin/bash
ceph_names="os-ci-test9 os-ci-test10 os-ci-test11"
ceph_osd_devices="vdb vdc vdd"
image_path="/var/lib/libvirt/images"

create_device() {
  local ceph_name=$1
  shift
  local ceph_osd_devices="$@"
  echo "Create $ceph_osd_devices for $ceph_name"
  echo
  for ceph_osd_device in $ceph_osd_devices; do
    image="${image_path}/${ceph_name}-${ceph_osd_device}.img"
    if [ ! -f $image ]; then
      sudo qemu-img create -f qcow2 $image 1G &> /dev/null
    fi
  done
}

destroy_device() {
  local ceph_name=$1
  shift
  local ceph_osd_devices="$@"
  echo "Destroy $ceph_osd_devices for $ceph_name"
  echo
  for ceph_osd_device in $ceph_osd_devices; do
    image="${image_path}/${ceph_name}-${ceph_osd_device}.img"
    if [ -f $image ]; then
      sudo rm -f $image &> /dev/null
    fi
  done
}

attach_device() {
  local ceph_name=$1
  shift
  local ceph_osd_devices="$@"
  vm=$(sudo virsh -q list | awk '{print $2}' | grep -E "${ceph_name}$")
  attach_options="--subdriver=qcow2 --mode=shareable --live --config"
  if [ -n $vm ]; then
    for ceph_osd_device in $ceph_osd_devices; do
      image="${image_path}/${ceph_name}-${ceph_osd_device}.img"
      if [ -f $image ]; then
        echo "Attach $ceph_osd_device for $ceph_name"
        sudo virsh --quiet attach-disk $vm $image $ceph_osd_device $attach_options
        echo
      fi
    done
  fi
}

detach_device() {
  local ceph_name=$1
  shift
  local ceph_osd_devices="$@"
  vm=$(sudo virsh -q list | awk '{print $2}' | grep -E "${ceph_name}$")
  detach_options="--live --config"
  if [ -n $vm ]; then
    for ceph_osd_device in $ceph_osd_devices; do
      image="${image_path}/${ceph_name}-${ceph_osd_device}.img"
      if [ -f $image ]; then
        echo "Detach $ceph_osd_device for $ceph_name"
        sudo virsh --quiet detach-disk $vm $image $detach_options
        echo
      fi
    done
  fi
}

usage() {
    cat << EOF
    usage: $0 [-c] [-d]
    This script will create/destroy $ceph_osd_devices on $ceph_names
EOF
    exit 0
}

while getopts :cdh opt
do
  case ${opt} in
    c) create=0;;
    d) destroy=0;;
    h) usage;;
    '?')  echo "${0} : option ${OPTARG} is not valid" >&2
          usage
    ;;
  esac
done
create="${create:-"1"}"
destroy="${destroy:-"1"}"
if [ $create -eq 0 ] && [ $destroy -eq 0 ]; then
  usage
fi

for ceph_name in $ceph_names; do
  if [ $create -eq 0 ]; then
    create_device $ceph_name $ceph_osd_devices
    attach_device $ceph_name $ceph_osd_devices
  elif [ $destroy -eq 0 ]; then
    detach_device $ceph_name $ceph_osd_devices
    destroy_device $ceph_name $ceph_osd_devices
  else
    usage
  fi
done
sudo /etc/init.d/libvirt-bin restart
