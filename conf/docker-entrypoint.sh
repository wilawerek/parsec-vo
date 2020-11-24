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
service ssh restart

#block a tester pour l'accès aux depots privé
#fonctionne avec la clé privé ssh (secrets dans docker compose)
eval "$(ssh-agent -s)"
if [ ! -d "/root/.ssh/" ]; then
    ssh-add -k /run/secrets/id_rsa
    mkdir /root/.ssh
    ssh-keyscan github.com > /root/.ssh/known_hosts
    # now execute command which require authentication via ssh (example, git clone from a private repo)
fi
