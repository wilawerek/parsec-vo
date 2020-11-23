#!/usr/bin/env bash

# script executé au démarrage du docker

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
