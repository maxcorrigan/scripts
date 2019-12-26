#!/bin/bash
#########################################################
#               Created by: mcorrigan                   #
#               Created on: 09/12/2019                  #
#                                                       #
#       Retrieves a list of all running microservices   #
#               for a given banner in CSV format        #
#########################################################

ENV=$1
SUBTXT="$ENV Microservice List Ready On HD1MUTL08LX"
TXT="Check file in /home/autadmin/InfraOps/microservice_lists/"
DATE=$(date +"%m_%d_%Y")

mv /home/autadmin/InfraOps/microservice_lists/${ENV}_containers_*.csv /home/autadmin/InfraOps/microservice_lists/Old_Lists
find /home/autadmin/InfraOps/microservice_lists/Old_Lists -type f -mtime +30 -exec rm -f {} \
scp go@hd1cmgo09lx.digital.hbc.com:/home/go/microservice_lists/${ENV}_containers_${DATE}.csv /home/autadmin/InfraOps/microservice_lists
curl -X POST -H "Content-Type: application/json" --data "{\"channel\": \"#hbc_ops_training_stl\", \"username\": \"${SUBTXT}\", \"text\": \"${TXT}\", \"icon_emoji\": \":infraops:\"} " https://hooks.slack.com/services/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



#!/bin/bash
#########################################################
#               Created by: mcorrigan                   #
#               Created on: 09/12/2019                  #
#                                                       #
#       Retrieves a list of all running microservices   #
#               for a given banner in CSV format        #
#########################################################



ENV=$1
DATE=$(date +"%m_%d_%Y")

mv /home/go/microservice_lists/${ENV}_containers_*.csv /home/go/microservice_lists/Old_lists
find /home/go/microservice_lists/Old_Lists -type f -mtime +30 -exec rm -f {} \
source /home/go/.sdc/docker/$ENV/env.sh
env | egrep  -i "docker | compose | $ENV.*"
docker --tls ps --format '{{.Image}}' | tr -s ':' ',' | awk '{gsub("hbc-docker.jfrog.io/","");print}' | awk '{gsub("sd1pgo01lx.saksdirect.com/","");print}' >> /home/go/microservice_lists/${ENV}_containers_${DATE}.csv
