#!/bin/bash
hosts=$(cat config.yaml| egrep -v '^[[:space:]]*#.*' | awk '/ +name: / {print $2}')


get_hosts() {
  for host in $hosts; do
    vm=$(sudo virsh --quiet list | awk '{print $2}' | grep -E "${host}$")
    if [ $vm ]; then
      local vms="$vms $vm"
    fi
  done
  echo $vms
}

check_if_snapshot_exist() {
  local snapshot=$1
  local host=$2
  sudo virsh --quiet snapshot-list $host $snapshot &> /dev/null
  local ret=$?
  echo $ret
}

create_snapshot() {
  local snapshot=$1
  shift
  local all_hosts="$@"
  local ret=""
  for host in $all_hosts; do
    ret=$(check_if_snapshot_exist $snapshot $host)
    if [ $ret -ne 0 ]; then
      echo "Creating snapshot $snapshot for $host"
      sudo virsh --quiet snapshot-create-as $host $snapshot
      echo
    fi
  done
}

destroy_snapshot() {
  local snapshot=$1
  shift
  local all_hosts="$@"
  for host in $all_hosts; do
    ret=$(check_if_snapshot_exist $snapshot $host)
    if [ $ret -eq 0 ]; then
      echo "Destroying snapshot $snapshot for $host"
      sudo virsh --quiet snapshot-delete $host $snapshot
      echo
    fi
  done
}

list_snapshot() {
  local all_hosts="$@"
  for host in $all_hosts; do
      echo
      echo "####### $host #######"
      sudo virsh snapshot-list $host
      echo
  done
}

revert_snapshot() {
  local snapshot=$1
  shift
  local all_hosts="$@"
  for host in $all_hosts; do
    ret=$(check_if_snapshot_exist $snapshot $host)
    if [ $ret -eq 0 ]; then
      echo "Reverting on snapshot $snapshot for $host"
      sudo virsh --quiet snapshot-revert $host $snapshot
      echo
    fi
  done
}

usage() {
    cat << EOF
    usage: $0 [-c] [-d] [-l] [-r] snapshot_name
    This script will create/reverse/destroy snapshots
      -c: create snapshot
      -d: delete snapshot
      -r: remove snapshot
      -l: list snapshots for all hosts (does not need snapshot_name)
EOF
    exit 0
}

while getopts :cdlhr opt
do
  case ${opt} in
    c) create=0;;
    d) destroy=0;;
    l) list=0;;
    h) usage;;
    r) revert=0;;
    '?')  echo "${0} : option ${OPTARG} is not valid" >&2
          usage
    ;;
  esac
done

# remove all getopts var
shift $(( OPTIND - 1 ))

create="${create:-"1"}"
destroy="${destroy:-"1"}"
list="${list:-"1"}"
revert="${revert:-"1"}"

snapshot="$1"
all_hosts=$(get_hosts)

if [ $create -eq 0 ] && [ $destroy -eq 0 ] && [ $reverse -eq 0 ]; then
  usage
fi

if [ $create -eq 0 ] && [ $snapshot ]; then
  create_snapshot $snapshot $all_hosts
elif [ $revert -eq 0 ] && [ $snapshot ]; then
  revert_snapshot $snapshot $all_hosts
elif [ $destroy -eq 0 ] && [ $snapshot ]; then
  destroy_snapshot $snapshot $all_hosts
elif [ $list -eq 0 ]; then
  list_snapshot $all_hosts
else
  usage
fi
