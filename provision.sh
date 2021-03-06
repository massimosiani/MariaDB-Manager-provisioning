#!/bin/bash
#
# This file is distributed as part of the MariaDB Enterprise.  It is free
# software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation,
# version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Copyright 2012-2014 SkySQL Ab
#
# Author: Massimo Siani
# Date: January 2014
#
# Parameters:
# --rep-user:			Replication username
# --rep-password:		Replication password
# --db-user:			Database username (root is removed)
# --db-password:		Database password
# --password, -p:		ssh password
# --key-file:			ssh key file, with path


# small usage help
if [[ $# -lt 1 ]] ; then
    echo "Usage: $(basename $0) [OPTIONS] <[user@]node IP> <MariaDB Galera cluster IP>"
    echo "The MariaDB Galera cluster Ip may be:"
    echo "    <empty>:	creates a new cluster"
    echo "    <IP>:	attach the node to the existing cluster"
fi

repUser=repuser
repPassword=reppassword
dbUser=dbuser
dbPassword=dbpassword

# get parameters
while [[ $# -gt 0 ]] ; do
    case $1 in
	"--rep-user")
	    shift
	    repUser=$1
	    ;;
        "--rep-password")
            shift
            repPassword=$1
            ;;
        "--db-user")
            shift
            dbUser=$1
            ;;
        "--db-password")
            shift
            dbPassword=$1
            ;;
        "--password"|"-p")
            shift
            sshPassword=$1
            ;;
        "--key-file")
            shift
            sshKey=$1
            ;;
        *)
            [[ -z "$nodeIP" ]] && nodeIP=$1 || clusterIP=$1
            ;;
    esac
    shift
done
[[ -z "$nodeIP" ]] && echo "ERROR: Target node IP not provided" && exit 1

# set ssh command
if [[ ! -z "$sshPassword" ]] ; then
    ssh_cmd="sshpass -p $sshPassword ssh -t $nodeIP"
    scp_cmd="sshpass -p $sshPassword scp -r"
elif [[ ! -z "$sshKey" ]] ;  then
    ssh_cmd="ssh -i $sshKey -t $nodeIP"
    scp_cmd="scp -i $sshKey -r"
else
    echo "No ssh password nor ssh key provided - the script may hang and ask for a password"
    ssh_cmd="ssh -t $nodeIP"
    scp_cmd="scp -r"
fi
ssh-keyscan ${nodeIP##*@} >> $HOME/.ssh/known_hosts

# set galera options
if [[ -z "$clusterIP" ]] ; then
    wsrep_opt="--wsrep-new-cluster"
else
    wsrep_opt="--wsrep_cluster_address=gcomm://${clusterIP}"
fi

# get remote os family
status=$($ssh_cmd "ls /etc/debian-version")
if [ "x$?" == "x0" ]; then
    osfamily=debian
fi
status=$($ssh_cmd "ls /etc/redhat-release")
if [ "x$?" == "x0" ]; then
    osfamily=redhat
fi
if [ -z "$osfamily" ] ; then
    echo Unsupported distribution
    exit 1
fi

if [[ "$osfamily" == "debian" ]] ; then
    install_cmd="sudo aptitude -y install"
elif [[ "$osfamily" == "redhat" ]] ; then
    install_cmd="sudo yum -y install"
fi

# execute commands
$scp_cmd MariaDB-Manager-provisioning ${nodeIP}:~/
$ssh_cmd "sudo MariaDB-Manager-provisioning/install-puppet.sh;
          sudo MariaDB-Manager-provisioning/configure.sh $repUser $repPassword $dbUser $dbPassword;
          sudo /etc/init.d/mysql start $wsrep_opt "
