#!/bin/bash

USERIDD=$( id -u )

SOURCE_DIR="/home/ec2-user/app-logs"

LOGS_FOLDER="/var/log/shellscript-logs"
LOG_FILES=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILES-$TIMESTAMP.log" 

mkdir -p $LOGS_FOLDER
mkdir -p $SOURCE_DIR

VALIDATE(){
    if [ $1 -eq 0 ]
        then
            echo "$2 ..... success"
            exit 1
        else
            echo "$2 .....Failure"
            exit 1
        fi
}



CHECK_ROOT(){

    if [ $USERIDD -ne 0 ]
    then
        echo "you should have root access to run this script" 
        exit 1
    fi


}

echo "The script started at : $TIMESTAMP"  &>>$LOG_FILE_NAME


LOGS_TO_BE_DELETED=$(find $SOURCE_DIR -name "*.log" -mtime +14)

echo "files to be deleted $LOGS_TO_BE_DELETED"

while read -r file
do

    echo "deleted files : $file"
    rm -rf $file

done <<< $LOGS_TO_BE_DELETED




