#!/bin/bash -ex

new_fqdn="${1:?ERROR: FQDN not given.}"
new_hostname="${new_fqdn%%\.*}"
new_domain="${new_fqdn#$new_hostname\.}"

init_hostname="lucid32"
init_domainname=""
init_fqdn="${init_hostname}${init_domainname:+.${init_domainname}}"

sudo sed -i "s/${init_hostname}/${new_hostname}/" /etc/hostname
sudo sed -i "s/${init_fqdn}/${new_fqdn}\t${new_hostname}/" /etc/hosts

sudo domainname $new_domain
sudo hostname $new_hostname

echo "hostname=`hostname`"
echo "domainname=`domainname`"
echo "FQDN=`hostname -f`"

