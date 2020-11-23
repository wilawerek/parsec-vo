#!/usr/bin/env bash

# script executé au démarrage du docker

service postgresql restart

for rep in $(find /var/gavo/inputs/[0-9a-zA-Z]* -maxdepth 0 -type d)
do
  su - dachsroot dachs imp /var/gavo/inputs/${rep}/q.rd
  su - dachsroot dachs pub //services
  su - dachsroot dachs pub //tap
  su - dachsroot dachs pub /var/gavo/inputs/${rep}/q.rd
done
gavo serve restart

service apache2 restart
