#!/bin/bash

# Script d'installation automatique de Cacti + SNMP sur Debian

set -e

echo "[1/8] Mise a jour du système"
sudo apt update && sudo apt upgrade -y

echo "[2/8] Installation des dependances Cacti"
sudo apt install -y apache2 mariadb-server php php-mysql php-xml php-ldap php-mbstring php-gd php-gmp libapache2-mod-php snmp snmpd snmp-mibs-downloader rrdtool

echo "[3/8] Telechargement de Cacti"
wget https://www.cacti.net/downloads/cacti-latest.tar.gz
tar -zxvf cacti-latest.tar.gz
sudo mv cacti-* /var/www/html/cacti

echo "[4/8] Configuration des droits"
sudo chown -R www-data:www-data /var/www/html/cacti/
sudo chmod -R 775 /var/www/html/cacti/rra /var/www/html/cacti/log

echo "[5/8] Configuration de la base de donnees"
sudo mysql -e "CREATE DATABASE cacti DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'cactiuser'@'localhost' IDENTIFIED BY 'cactipass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON cacti.* TO 'cactiuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -u cactiuser -pcactipass cacti < /var/www/html/cacti/cacti.sql

echo "[6/8] Configuration de Cacti"
sudo sed -i "s/\$database_username = 'cactiuser';/\$database_username = 'cactiuser';/" /var/www/html/cacti/include/config.php
sudo sed -i "s/\$database_password = 'cactiuser';/\$database_password = 'cactipass';/" /var/www/html/cacti/include/config.php

echo "[7/8] Configuration SNMP"
sudo bash -c 'cat > /etc/snmp/snmpd.conf <<EOF
agentAddress udp:161
rocommunity public
sysLocation  "Server Room"
sysContact   "admin@example.com"
EOF'

sudo systemctl restart snmpd
sudo systemctl enable snmpd

echo "[8/8] Configuration Apache"
sudo bash -c 'cat > /etc/apache2/sites-available/cacti.conf <<EOF
Alias /cacti /var/www/html/cacti

<Directory /var/www/html/cacti>
    Options +FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
EOF'

sudo a2ensite cacti.conf
sudo systemctl reload apache2

echo ""
echo "✅ Installation terminee !"
echo "Accedez a Cacti via : http://$(hostname -I | awk '{print $1}')/cacti"
echo "Identifiants par defaut : admin / admin (vous serez invite a les changer)"
