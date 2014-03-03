#!/bin/sh

# In order to avoid SSH complaining about dangling host ssh keys, you
# can add this in your ~/.ssh/config
#
# host os-ci-test*
#     stricthostkeychecking no
#     userknownhostsfile=/dev/null

set -v
set -e

DEBIAN=
PUPPETMASTER="192.168.134.48"
CONFIG="config.yaml"


for i in `cat config.yaml|awk '/^ +address: / {print $2}'`; do
    ssh root@$i '
       echo 192.168.134.253 os-ci-vip.lab.enovance.com os-ci-vip >> /etc/hosts ; \
       echo 192.168.134.48 os-ci-test4.lab.enovance.com os-ci-test4 >> /etc/hosts ; \
       service puppet stop'
done


set +e
if [ -z $DEBIAN ]; then
    scp data/configure-puppet.sh root@${PUPPETMASTER}:
    ssh root@${PUPPETMASTER} bash /root/configure-puppet.sh
else
    ssh root@${PUPPETMASTER} service mysqld restart

    echo "create database puppet;" | ssh root@${PUPPETMASTER} mysql -uroot
    echo "grant all privileges on puppet.* to puppet@localhost identified by 'password';" | ssh root@${PUPPETMASTER} mysql -uroot

    ssh root@${PUPPETMASTER} " \
        echo * > /etc/puppet/autosign.conf ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/storeconfigs' 'true' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbadapter' 'mysql' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbuser' 'puppet' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbpassword' 'password' ; \
        augtool -s set '/files/etc/puppet/puppet.conf/master/dbserver' 'localhost' : \
        augtool -s set '/files/etc/puppet/puppet.conf/master/storeconfigs' 'true'" \
        || true # augtool returns != 0 on Debian even in case of success
    ssh root@${PUPPETMASTER} puppet master --ignorecache --no-usecacheonfailure --no-splay
fi

#./refresh.sh
