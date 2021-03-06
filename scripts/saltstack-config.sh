#!/bin/bash

# SaltStack Configuration
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the saltstack minion

# Some informations
# http://docs.saltstack.com/en/latest/ref/configuration/minion.html

# Needs:
# sudo aptitude install salt-minion -y

key="$1"

install_cmd()
{
	echo "  - Configuring salt minion"

	# BACKUP
	if [ ! -f /etc/salt/minion.bkp ]; then
		if [ -f /etc/salt/minion ]; then
			cp /etc/salt/minion /etc/salt/minion.bkp
		fi
	else
		cp /etc/salt/minion.bkp /etc/salt/minion
	fi

	if [ ! -f /etc/salt/minion_id.bkp ]; then
		if [ -f /etc/salt/minion_id ]; then
			cp /etc/salt/minion_id /etc/salt/minion_id.bkp
		fi
	else
		cp /etc/salt/minion_id.bkp /etc/salt/minion_id
	fi

	service salt-master stop 2> /dev/null

	# Update the master address
	if [ -f /etc/salt/minion ]; then
		sed -i "s/^[#]*master:.*/master: rodos/g" /etc/salt/minion
	fi

	service salt-master start 2> /dev/null
}

remove_cmd()
{
	echo "  - Reverting salt minion configs"

	service salt-master stop 2> /dev/null

	if [ -f /etc/salt/minion.bkp ]; then
		mv /etc/salt/minion.bkp /etc/salt/minion
	fi

	if [ -f /etc/salt/minion_id.bkp ]; then
		mv /etc/salt/minion_id.bkp /etc/salt/minion_id
	fi

	service salt-master start 2> /dev/null
}

case $key in

	-i|--install)
	install_cmd
	exit 0
	;;

	-r|--remove)
	remove_cmd
	exit 0
	;;

	*)
	echo "Unknonw option"
	exit 1

esac
