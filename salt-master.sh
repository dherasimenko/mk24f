#!/bin/bash

echo "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp tcp-salt" > /etc/apt/sources.list
wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

apt-get clean
apt-get update

echo "Configuring salt master ..."
apt-get install -y salt-master reclass
apt-get install -y salt-formula-apache salt-formula-backupninja salt-formula-billometer salt-formula-ceilometer salt-formula-cinder salt-formula-collectd salt-formula-elasticsearch salt-formula-galera salt-formula-git salt-formula-glance salt-formula-glusterfs salt-formula-grafana salt-formula-graphite salt-formula-haproxy salt-formula-heat salt-formula-heka salt-formula-horizon salt-formula-iptables salt-formula-java salt-formula-kedb salt-formula-keepalived salt-formula-keystone salt-formula-kibana salt-formula-libvirt salt-formula-linux salt-formula-memcached salt-formula-mongodb salt-formula-mysql salt-formula-neutron salt-formula-nginx salt-formula-nodejs salt-formula-nova salt-formula-ntp salt-formula-opencontrail salt-formula-openssh salt-formula-openvstorage salt-formula-postgresql salt-formula-python salt-formula-rabbitmq salt-formula-reclass salt-formula-redis salt-formula-salt salt-formula-sensu salt-formula-statsd salt-formula-supervisor

cat << 'EOF' >> /etc/salt/master.d/master.conf
file_roots:
  base:
  - /usr/share/salt-formulas/env
pillar_opts: False
open_mode: True
reclass: &reclass
  storage_type: yaml_fs
  inventory_base_uri: /srv/salt/reclass
ext_pillar:
  - reclass: *reclass
master_tops:
  reclass: *reclass
EOF

[ ! -d /etc/reclass ] && mkdir /etc/reclass
cat << 'EOF' >> /etc/reclass/reclass-config.yml
storage_type: yaml_fs
pretty_print: True
output: yaml
inventory_base_uri: /srv/salt/reclass
EOF

apt-get install -y salt-minion
cat << 'EOF' >> /etc/salt/minion.d/minion.conf
master: 127.0.0.1
id: cfg01.mk24f.cluster
EOF

mkdir -p /srv/salt/reclass/classes/service

for i in /usr/share/salt-formulas/reclass/service/*; do
  ln -f -s $i /srv/salt/reclass/classes/service/

done
