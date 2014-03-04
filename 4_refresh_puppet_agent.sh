#!/bin/sh

PUPPETMASTER="os-ci-test4"
LOGDIR="log/$(date +%Y%m%d%H%M)"
SSH_CONFIG_FILE="tools/ssh_config"
SSH_OPTIONS="-F $SSH_CONFIG_FILE"
echo $LOGDIR

if [ ! -d $LOGDIR ]; then
  mkdir -p $LOGDIR
fi

hosts=$(cat config.yaml|awk '/^ +name: / {print $2}')

while ! rsync -e "ssh $SSH_OPTIONS " -av --delete --exclude '*.sw?' --exclude '*~' manifests modules root@${PUPPETMASTER}:/etc/puppet; do
    sleep 1;
done

cat << EOF > $LOGDIR/.htaccess
IndexOptions FancyIndexing NameWidth=* FoldersFirst ScanHTMLTitles DescriptionWidth=*
HeaderName HEADER.html
AllowOverride FileInfo Indexes
Options Indexes SymLinksIfOwnerMatch
EOF

#for host in $hosts; do
#    ssh $SSH_OPTIONS ${host} '
#        cp /bin/false /usr/bin/yum ; \
#        cp /bin/false /usr/bin/apt-get ; \
#        cp /bin/true /sbin/mkfs.xfs ; \
#        cp /bin/true /sbin/mount.xfs ; \
#        cp /bin/true /sbin/parted ; \
#        service puppet stop'
#    ssh $SSH_OPTIONS ${host} 'bash -c "echo nameserver 8.8.4.4 > /etc/resolv.conf"'
#done
agent_pid_list=""
#ssh root@192.168.134.49 ifconfig eth0:1 192.168.134.253
#ssh root@os-ci-test4.lab "killall puppet; puppet master" > $LOGDIR/puppetmaster.log 2>&1 &
echo "begin $(date)<br />" > $LOGDIR/HEADER.html


## TODO(Gonéri)
#ssh os-ci-test7 ifconfig eth0:1 192.168.121.253
#ssh os-ci-test7 ifconfig eth1:1 192.168.134.253
#ssh os-ci-test7 ifconfig eth2:1 192.168.44.253
#
for host in $hosts; do
  ssh $SSH_OPTIONS ${host} 'if [ -f /var/run/puppet/agent.pid ]; then killall -9 $(cat /var/run/puppet/agent.pid); fi'
    ssh $SSH_OPTIONS ${host} '
       augtool -s set "/files/etc/puppet/puppet.conf/agent/server" "os-ci-test4"; \
       augtool -s set "/files/etc/puppet/puppet.conf/agent/pluginsync" "true" '


    ssh $SSH_OPTIONS ${host} puppet agent \
        --ignorecache --waitforcert 60 \
        --no-usecacheonfailure --onetime --no-daemonize \
        --debug \
        --server $PUPPETMASTER >  $LOGDIR/${host}.log 2>&1 &
    agent_pid_list="${agent_pid_list} $!"
done

wait ${agent_pid_list}
echo "end: <strong>$(date)</strong><br />\n" >> $LOGDIR/HEADER.html

for host in $hosts; do
    cat $LOGDIR/${host}.log |grep Error > /tmp/foo.log
    if [ -s "/tmp/foo.log" ]; then
        cat /tmp/foo.log | ansi2html -p | sed -r 's,background: black;,,i' > $LOGDIR/${host}.error.html
    fi
    cat $LOGDIR/${i}.log | ansi2html -p | sed -r 's,background: black;,,i' > $LOGDIR/${host}.html
done
