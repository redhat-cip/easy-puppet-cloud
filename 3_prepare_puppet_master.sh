#!/bin/sh

set -v
set -e

DEBIAN=
PUPPETMASTER="os-ci-test4"
CONFIG="config.yaml"
SSH_CONFIG_FILE="tools/ssh_config"
SSH_OPTIONS="-F $SSH_CONFIG_FILE"

if [ ! -f $SSH_CONFIG_FILE ]; then
  bash tools/create_ssh_config.sh
fi

hosts=$(cat config.yaml | egrep -v '^[[:space:]]*#.*' | awk '/^ +name: / {print $2}')

for host in $hosts; do
    ssh $SSH_OPTIONS $host '
       echo 192.168.134.253 os-ci-vip.lab.enovance.com os-ci-vip >> /etc/hosts ; \
       echo 192.168.134.48 os-ci-test4.lab.enovance.com os-ci-test4 >> /etc/hosts ; \
       service puppet stop'
done


set +e
if [ -z $DEBIAN ]; then
    scp $SSH_OPTIONS data/configure-puppet.sh root@${PUPPETMASTER}:
    ssh $SSH_OPTIONS ${PUPPETMASTER} bash /root/configure-puppet.sh
else
    ssh $SSH_OPTIONS ${PUPPETMASTER} service mysqld restart

    echo "create database puppet;" | ssh $SSH_OPTIONS ${PUPPETMASTER} mysql -uroot
    echo "grant all privileges on puppet.* to puppet@localhost identified by 'password';" | ssh root@${PUPPETMASTER} mysql -uroot

    ssh $SSH_OPTIONS ${PUPPETMASTER} " \
        echo * > /etc/puppet/autosign.conf ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/storeconfigs' 'true' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbadapter' 'mysql' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbuser' 'puppet' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbpassword' 'password' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbserver' 'localhost' : \
        augtool -s set '/files/etc/puppet/puppet.conf/master/storeconfigs' 'true'" \
        || true # augtool returns != 0 on Debian even in case of success
    ssh $SSH_OPTIONS ${PUPPETMASTER} puppet master --ignorecache --no-usecacheonfailure --no-splay
fi

#./refresh.sh
