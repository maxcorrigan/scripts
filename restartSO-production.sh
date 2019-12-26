#!/bin/sh
. $HOME/.profile > /dev/null 2>&1
#S5A_HOST=${S5A_HOSTS:-'sd1putl01lx'}
#O5A_HOST=${O5A_HOSTS:-'sd1pxx21lx'}
S5A_HOST=sd1putl01lx
O5A_HOST=sd1pxx21lx
echo "Restarting SO and SOEmail for Saks and Off5th"
echo " "
echo " "
    echo "Restarting Send Order services for hosts: $S5A_HOST"
            ssh -o StrictHostKeyChecking=no $S5A_HOST "/home/bmadmin/bmsPRD2012/saks/scripts/stopsendorder.sh"
            ssh -o StrictHostKeyChecking=no $S5A_HOST "/home/bmadmin/bmsPRD2012/saks/scripts/stopsendorderemail.sh"
            sleep 10
            ssh -o StrictHostKeyChecking=no $S5A_HOST "/home/bmadmin/bmsPRD2012/saks/scripts/startsendorder.sh"
            ssh -o StrictHostKeyChecking=no $S5A_HOST "/home/bmadmin/bmsPRD2012/saks/scripts/startsendorderemail.sh"

echo " "
echo " "
    echo "Restarting Send Order Services for hosts: $O5A_HOST"
            ssh -o StrictHostKeyChecking=no offadm@$O5A_HOST ". /home/offadm/.profile; /home/offadm/so5Prod2012/saks/scripts/stopsendorder.sh"
            ssh -o StrictHostKeyChecking=no offadm@$O5A_HOST ". /home/offadm/.profile; /home/offadm/so5Prod2012/saks/scripts/stopsendorderemail.sh"
            sleep 10
            ssh -o StrictHostKeyChecking=no offadm@$O5A_HOST ". /home/offadm/.profile; /home/offadm/so5Prod2012/saks/scripts/startsendorder.sh"
            ssh -o StrictHostKeyChecking=no offadm@$O5A_HOST ". /home/offadm/.profile; /home/offadm/so5Prod2012/saks/scripts/startsendorderemail.sh"

echo " "
echo " "
echo "Restart of Sendorder & SendorderEmail finished for Saks and Off5th"