#!/bin/bash

#To get the correct file from excel: File > Save As > name: user_add > File Format: Tab delimited Text (.txt)
OIFS=$IFS
IFS=$'\t'
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "What is the JIRA ticket number?"
read ticket_num

#Read column 3 from user.txt for Instance Role
awk -F \t 'NR>6{print $3}' $DIR/ready_for_instance_role.txt | while read -r i_role_grant; 
do
	#sfcc-ci role:grant --options
	eval $i_role_grant
done

mv $DIR/ready_for_instance_role.txt $DIR/Completed/$ticket_num.txt