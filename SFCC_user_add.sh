#!/bin/bash

#To get the correct file from Google Sheets: File > Download > Tab-separated values (.tsv, current sheet)
OIFS=$IFS
IFS=$'\t'
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

mv ~/Downloads/*.tsv $DIR/user_add.txt

#Read column 1 for AM user creation
awk -F \t 'NR>6{print $1}' $DIR/user_add.txt | while read -r user_add; 
do
	#sfcc-ci user:create --options
	eval $user_add
done

sleep 5

#Read column 2 for AM Role
awk -F \t 'NR>6{print $2}' $DIR/user_add.txt | while read -r AM_role_grant; 
do
	#sfcc-ci role:grant --options
	eval $AM_role_grant
done

#Prepare for adding Instance Role
mv $DIR/user_add.txt $DIR/ready_for_instance_role.txt