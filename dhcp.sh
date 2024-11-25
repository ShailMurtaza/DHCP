#!/usr/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "\033[31m [-] Require Root Access \033[0m" 1>&2
    exec sudo "$0" "$@"
fi

source ./get_interface.sh
sed -i "s/^interface=.*$/interface=$interface/" "dnsmasq.conf"
# Setup the interface

# Setup the interface
nmcli dev set $interface managed no
ip link set $interface down
ip addr flush dev $interface
ip link set $interface up
ip addr add 10.0.0.1/24 dev $interface


# start hostapd
dnsmasq -C dnsmasq.conf -d
echo 'Stopped ...'
nmcli dev set $interface managed yes

