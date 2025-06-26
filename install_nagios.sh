#!/bin/bash

# Script d'installation de Nagios Core sur Debian

set -e

echo "[1/6] Installation des dependances"
sudo apt update && sudo apt install -y autoconf gcc make apache2 php libapache2-mod-php \
    libgd-dev libmcrypt-dev libssl-dev snmp unzip wget

echo "[2/6] Telechargement de Nagios Core"
cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.5.1.tar.gz
tar xzf nagios-4.5.1.tar.gz
cd nagios-4.5.1

echo "[3/6] Compilation et installation de Nagios"
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
sudo make install-groups-users
sudo usermod -a -G nagios www-data
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config
sudo make install-webconf

echo "[4/6] Creation de l'utilisateur nagiosadmin"
echo "nagiosadmin:adminpass"
sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin adminpass

echo "[5/6] Activation des services"
sudo systemctl enable apache2
sudo systemctl enable nagios
sudo systemctl restart apache2
sudo systemctl start nagios

echo ""
echo "✅ Nagios Core est installe. Accedez-y via : http://$(hostname -I | awk '{print $1}')/nagios"
echo "Login : nagiosadmin / Mot de passe : adminpass"
