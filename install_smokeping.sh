#!/bin/bash

# Script d'installation de Smokeping sur Debian

set -e

echo "[1/4] Mise a jour du systeme"
sudo apt update && sudo apt upgrade -y

echo "[2/4] Installation de Smokeping et Apache2"
sudo apt install -y smokeping apache2

echo "[3/4] Configuration d'Apache pour Smokeping"
sudo ln -sf /etc/smokeping/apache2.conf /etc/apache2/conf-enabled/smokeping.conf
sudo systemctl reload apache2

echo "[4/4] Exemple de cible ajoutee a Smokeping"
sudo bash -c 'cat >> /etc/smokeping/config.d/Targets <<EOF

+ Localhost

menu = Localhost
title = Localhost
host = 127.0.0.1
EOF'

sudo systemctl restart smokeping

echo ""
echo "✅ Smokeping est installe. Accedez-y via : http://$(hostname -I | awk '{print $1}')/smokeping"
