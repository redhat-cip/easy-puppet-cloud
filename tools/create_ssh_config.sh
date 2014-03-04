#!/bin/bash

SSH_CONFIG_FILE="tools/ssh_config"
if [ -f $SSH_CONFIG_FILE ]; then
  rm $SSH_CONFIG_FILE
fi

for num in $(seq 1 12); do
  name="os-ci-test${num}"
  grep -q -E "$name$" config.yaml
  if [ $? -eq 0 ]; then
    data=$(grep -B 1 -E "${name}$" config.yaml)
    address=$(echo $data | grep address | awk '{print $2}')
    cat >> $SSH_CONFIG_FILE << EOF
Host $name
  Hostname $address

EOF
  fi
done
cat >> $SSH_CONFIG_FILE << EOF
host *
   StrictHostKeyChecking no
   UserKnownHostsFile /dev/null
   User root
   IdentityFile ~/.vagrant.d/insecure_private_key
EOF
