#!/bin/bash
#

nid=$1

hostnamePrefix='hdc-'
net='172.17.128.'

echo "$hostnamePrefix$nid" > /etc/hostname
perl -i -pE "s/(?<g1>IPADDR=).+/$+{g1}$net$nid/" /etc/sysconfig/network-scripts/ifcfg-ens160
