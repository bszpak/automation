#!/bin/bash

for i in analogout burnin configserver dash2ip digistream2 digivuii epgdata ip2av3 ip2av4 katana passport samurai shogun videorouter vreedge; do
    sudo -u postgres createuser ${i}
    sudo -u postgres createdb -O ${i} -E UTF8 ${i}
    sudo -u postgres psql -c "ALTER USER ${i} WITH CREATEDB"
done

sudo -u postgres createdb -O samurai -E UTF8 samurai_stats
sudo -u postgres createdb -O shogun -E UTF8 shogun_stats
