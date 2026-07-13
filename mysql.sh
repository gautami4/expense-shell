#!/bin/bash

USERIDD=$( id -u )

LOGS_FOLDER="/var/log/expense-shell.log"
LOG_FILES=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOGS_FILES-$TIMESTAMP.log" 

VALIDATE(){
    if [ $1 -eq 0 ]
        then
            echo "$2 installation success"
        else
            echo "$2 installation Failure"
        fi
}

echo "The script started at : $TIMESTAMP"  &>>$LOG_FILE_NAME

if [ $USERIDD -ne 0 ]
then
    echo "you should have root access to run this script" 
fi

if [ $USERIDD -eq 0 ]
then    
    packages()
fi     

for packages in $@
do

    dnf list installed $packages -y  &>>$LOG_FILE_NAME
    if [ $? -eq 0 ]
    then
        echo " $packages already installed"
    else
        dnf install $packages -y
        VALIDATE $? $packages
    fi    

done




