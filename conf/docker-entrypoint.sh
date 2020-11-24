#!/usr/bin/env bash

# script executé au démarrage du docker
service ssh restart
service postgresql restart

for rep in $(find /var/gavo/inputs/[0-9a-zA-Z]* -maxdepth 0 -type d | cut -f5 -d'/')
do
  su - dachsroot bash -c "dachs imp ${rep}/q.rd"
  su - dachsroot bash -c "dachs pub //services"
  su - dachsroot bash -c "dachs pub //tap"
  su - dachsroot bash -c "dachs pub ${rep}/q.rd"
done
dachs serve restart

service apache2 restart

#block a tester pour l'accès aux depots privé
#fonctionne avec la clé privé ssh (secrets dans docker compose)
eval "$(ssh-agent -s)"
if ([ ! -f "/home/dachsroot/.ssh/know_hosts" ] && [ -f "/run/secrets/id_rsa" ]); then
    ssh-add -k /run/secrets/id_rsa
    ssh-keyscan github.com >> /home/dachsroot/.ssh/known_hosts
    ssh-keyscan gitlab.obpsm.fr >> /home/dachsroot/.ssh/known_hosts
    chown dachsroot:gavo /home/dachsroot/.ssh/known_hosts
    chmod 600 /home/dachsroot/.ssh/known_hosts
fi
