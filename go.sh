#!/bin/bash -ex

ROOT_DIR="chef_quick_start"
CHEF_REPO="chef-repo"

USERNAME=`ls ../config/*.pem | grep -P -v "CHEF_USERNAME|CHEF_ORGANIZATION" | grep -P -v "\-validator" | awk -F"[/.]" '{print $5}'`
ORGANIZATION=`ls ../config/*.pem | grep -P -v "CHEF_USERNAME|CHEF_ORGANIZATION" | grep -P "\-validator" | awk -F"[/.\-]" '{print $5}'`

NODE_ADDRESS="33.33.33.10"
NODE_FQDN="quck-start.chef.tw"

[ -d ${ROOT_DIR} ] || mkdir -p ${ROOT_DIR}
cd ${ROOT_DIR}

# Put all chef files:
#-  USERNAME.pem
#-  ORGANIZATION-validator.pem
#-  knife.rb
#-into chef-repo/.chef
mkdir -p ${CHEF_REPO}/.chef
cp -f ../config/${USERNAME}.pem ${CHEF_REPO}/.chef
cp -f ../config/${ORGANIZATION}-validator.pem ${CHEF_REPO}/.chef
cp -f ../config/knife.rb ${CHEF_REPO}/.chef
ls -l ${CHEF_REPO}/.chef

# Create a seperate ruby environment using RVM for this Quick Start
#-and install all needed gems.
cat <<EOF > .rvmrc
rvm_install_on_use_flag=1
rvm --create use ree@$ROOT_DIR
EOF

echo $PATH
rvm rvmrc trust && rvm rvmrc load
echo $PATH

cat <<EOF > Gemfile
source :rubygems

gem "chef"
gem "vagrant"
EOF

bundle check || bundle install

# Create a chef repository by download the template from opscode on Github
[ -d ${CHEF_REPO} ] || git clone git://github.com/opscode/${CHEF_REPO}.git

# Verify Your Workstation
cd ${CHEF_REPO}
cat <<EOF
#####################################################################
$ knife client list
`knife client list`
######################### -= THE END =- #############################
EOF
cd ..

# Set up a Node as a new Chef Client
#-Here we use Vagrant to create a VM installed Ubuntu 10.04

# Create Ubuntu VM
[ -d scripts ] || mkdir -p scripts
[ -f scripts/set_fqdn.sh ] || cp ../scripts/set_fqdn.sh scripts

[ -s Vagrantfile ] || cat <<EOF > Vagrantfile
Vagrant::Config.run do |config|

  config.vm.define :chef_quick_start do |chef_quick_start|

    chef_quick_start.vm.customize do |vm|
      vm.name = "Chef Quick Start"
    end

    chef_quick_start.vm.box = "base"
    chef_quick_start.vm.box_url = "http://files.vagrantup.com/lucid32.box"

    chef_quick_start.vm.network "${NODE_ADDRESS}"

    chef_quick_start.vm.provision :shell do |shell|
      shell.path = "scripts/set_fqdn.sh"
      shell.args = "${NODE_FQDN}"
    end

    chef_quick_start.vm.provision :shell do |shell|
      shell.inline = "ping -c 4 33.33.33.1"
    end
  end
end

EOF

vagrant status
$(vagrant status | grep -q "running$") || vagrant up
(( $? != 0 )) && exit 1

# Bootstrap the Ubuntu System
cd ${CHEF_REPO}
knife cookbook site install chef-client
knife cookbook upload chef-client
knife bootstrap ${NODE_ADDRESS} -r 'recipe[chef-client]' \
                                -x vagrant \
                                -P vagrant \
                                --sudo

cat <<EOF
#####################################################################
$ knife node list
`knife node list`
######################### -= THE END =- #############################
EOF

cat <<EOF
#####################################################################
$ knife node show ${NODE_FQDN}
`knife node show ${NODE_FQDN}`
######################### -= THE END =- #############################
EOF

cd ..
