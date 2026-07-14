#!/bin/bash

USERIDD=$( id -u )

LOGS_FOLDER="/var/log/expense-shell"
LOG_FILES=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILES-$TIMESTAMP.log" 

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -eq 0 ]
        then
            echo "$2 installation success"
        else
            echo "$2 installation Failure"
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

CHECK_ROOT


dnf module disable nodejs -y   &>>$LOG_FILE_NAME
VALIDATE $? "Disablling existing default NodeJS"

dnf module enable nodejs:20 -y      &>>$LOG_FILE_NAME
VALIDATE $? "enabling NodeJS 20"

dnf install nodejs -y       &>>$LOG_FILE_NAME
VALIDATE $? "Installing NodeJS"

useradd expense     &>>$LOG_FILE_NAME
VALIDATE $? "Adding Expense User"

mkdir /app      &>>$LOG_FILE_NAME
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip   &>>$LOG_FILE_NAME
VALIDATE $? "Downloading backend"

cd /app #moving to app directory

unzip /tmp/backend.zip  &>>$LOG_FILE_NAME
VALIDATE $? "Unzip backed"

npm install     &>>$LOG_FILE_NAME
VALIDATE $? "Dependencies installed"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service

# prepare mysql schema

dnf install mysql -y        &>>$LOG_FILE_NAME
VALIDATE $? "mysql installation"

#loading schema

mysql -h 98.84.137.96 -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "setting up transactions schema and tables"

systemctl daemon-reload     &>>$LOG_FILE_NAME
VALIDATE $? "Daemon reload"


systemctl enable backend        &>>$LOG_FILE_NAME
VALIDATE $? "Enabling backend"

systemctl start backend     &>>$LOG_FILE_NAME
VALIDATE $? "starting backend"




