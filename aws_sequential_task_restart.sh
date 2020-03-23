################################################################
#
# Developed By: Max Corrigan              Date: 06-25-2019
#       Restarts AWS ECS Service one by one
#
#
################################################################

ENV=$1
SERVICE=$2
DESCRIBE_SERVICES="aws ecs describe-services --cluster $ENV --services $SERVICE --output json"
TASKS="aws ecs list-tasks --cluster $ENV --service-name $SERVICE --output json"

#Exit on error
set -e

#Sleep until desired count equals running count
while [[ "$($DESCRIBE_SERVICES | jq '.services[].desiredCount')" != "$($DESCRIBE_SERVICES | jq '.services[].runningCount')" ]]
do
        sleep 180
done

#Create array of current tasks
$TASKS | jq -r '.taskArns[] | split("/")[1]' | sort > ${SERVICE}_${ENV}_tasks.txt
mapfile -t taskArray < ${SERVICE}_${ENV}_tasks.txt
#Total number of tasks
TASK_COUNT="${#taskArray[@]}"

#Loop restarts on taskArray
for (( i=0; i<=(( $TASK_COUNT - 1 )); i++ ))
do
        #If Desired number of tasks equals number of running tasks
        if [ "$($DESCRIBE_SERVICES | jq '.services[].desiredCount')" == "$($DESCRIBE_SERVICES | jq '.services[].runningCount')" ]
        #Kill tasks in array one at a time
        then aws ecs stop-task --cluster $ENV --task "${taskArray[$i]}"
                sleep 180
        #Wait until desired equals running (Could occur during a deployment, for example)
        else echo "wait"; sleep 180
        fi
done

echo "Tasks restarted, checking for old tasks"

#Create array of new tasks
$TASKS | jq -r '.taskArns[] | split("/")[1]' | sort > ${SERVICE}_${ENV}_newtasks.txt
mapfile -t newtaskArray < ${SERVICE}_${ENV}_newtasks.txt
#Total number of new tasks
NEW_TASK_COUNT="${#newtaskArray[@]}"

#Check for old tasks still running
if [ $NEW_TASK_COUNT = "$($DESCRIBE_SERVICES | jq '.services[].desiredCount')" ]
        then
        for (( i=0; i<=(( $TASK_COUNT - 1 )); i++ ))
        do
        NEW_ARRAY="${newtaskArray[$i]}"
                if [[ " ${taskArray[@]} " =~ $NEW_ARRAY ]]; then
                        echo "Old task found, at least one restart failed"; exit 1
                        fi
                if [[ ! " ${taskArray[@]} " =~ $NEW_ARRAY ]]; then
                        echo "Restart successful"; exit 0
                fi
        done
        else
                echo "Task counts do not match, check AWS tasks"; exit 1
fi
