#!/bin/bash -ve

# This script adds the eduVPN repository to your system. Run as root.

apt install apt-transport-https
curl -L https://repo.eduvpn.org/debian/eduvpn.key  | apt-key add -
echo "deb https://repo.eduvpn.org/debian/ stretch main" > /etc/apt/sources.list.d/eduvpn.list
apt update
