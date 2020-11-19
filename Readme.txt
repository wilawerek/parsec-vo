# les choses à configurer pour son instance gavo.rc car il y a l'ip du serveur ou son nom dns
# le nom du dépot correspnd au nom du projet/nom du serveur, ici /vespa/voparis-tap-planeto/
# test

#Configuration du docker mydachs une fois lancé
apt-get update
apt-get upgrade
apt-get install apache2
apt-get install awstats
apt-get install geoip-database
apt-get install libgeo-ipfree-perl
apt-get install git
apt-get install wget

cd /home/dachsroot/
git clone https://gitlab.obspm.fr/vespa/dachs/servers/padc/voparis-tap-planeto.git
$chemin=/home/dachsroot/nom_du_serveur/

# sous root configuration du serveur
cp chemin/conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf
service apache2 restart
# restart d'apache pour éviter le conflit de port, apache sera sur le port 8080

cp chemin/conf/awstats.dachs.conf /etc/awstats/awstats.dachs.conf
a2enmod cgi
service apache2 restart

cp chemin/conf/gavo.rc /etc/gavo.rc
cp chemin/conf/defaultmeta.txt 
chown dachsroot:gavo /var/gavo/etc/defaultmeta.txt
cp chemin/conf/logo* /var/gavo/web/nv_static/img/
chown dachsroot:gavo /var/gavo/web/nv_static/img/logo*



# sous root configuration des services
cp -r chemin/services/ /var/gavo/inputs/
chown -R dachsroot:gavo /var/gavo/inputs/*

#ingestion des données et création des services
#depuis chacun des sous répertoires de services
$sous_rep = nom_sous_repertoire (ici planets seulement)

# pour chaque service
su -u dachsroot 'gavo imp /var/gavo/inputs/sous_rep/q.rd
su -u dachsroot 'gavo pub //services'
su -u dachsroot 'gavo pub //tap'
su -u dachsroot 'gavo pub /var/gavo/inputs/sous_rep/q.rd'
gavo serve restart


## mettre en cron.daily un fichier en 777 avec
  #!/bin/bash
  /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -config=dachs -update



## truc à penser
FROM debian:latest
RUN apt-get -y update 
RUN apt-get -y install awstats
RUN apt-get -y install apache2
EXPOSE 80

