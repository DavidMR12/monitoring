# Supervision Debian : Installation de Cacti, Smokeping et Nagios

Ce projet contient trois scripts pour installer une solution complète de supervision réseau et système sur une machine Debian.

## 📁 Contenu

- `install_cacti.sh` : installe Cacti pour la supervision CPU, RAM, disque, réseau, etc.
- `install_smokeping.sh` : installe Smokeping pour la mesure de la latence réseau.
- `install_nagios.sh` : installe Nagios Core pour la surveillance des services, ports, hôtes, etc.

---

## ▶️ Pré-requis

- Une VM Debian (Debian 10 ou 11 recommandé)
- Un accès root ou sudo
- Connexion Internet

---

## 🚀 Installation

### 1. Cacti

```bash
chmod +x install_cacti.sh
./install_cacti.sh
```

🖥 Accès : `http://<IP_VM>/cacti`  
🔐 Identifiants : `admin / admin`

---

### 2. Smokeping

```bash
chmod +x install_smokeping.sh
./install_smokeping.sh
```

🖥 Accès : `http://<IP_VM>/smokeping`  
🎯 Cible test incluse : `127.0.0.1`

---

### 3. Nagios Core

```bash
chmod +x install_nagios.sh
./install_nagios.sh
```

🖥 Accès : `http://<IP_VM>/nagios`  
🔐 Identifiants : `nagiosadmin / adminpass`

---

## 📌 Remarques

- Tous les services sont activés pour démarrer automatiquement.
- Les scripts configurent Apache automatiquement pour chaque outil.
- Pour ajouter des cibles dans Smokeping ou des hôtes dans Nagios, modifiez les fichiers dans :
  - `/etc/smokeping/config.d/Targets`
  - `/usr/local/nagios/etc/objects/`

---

## ✍️ Auteur

David MAKOSSO RICHET
