#!/bin/bash

USERIDD=$( id -u )

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILES=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILES-$TIMESTAMP.log" 

VALIDATE(){
    if [ $1 -eq 0 ]
        then
            echo "$2 ..... SUCCESS"
        else
            echo "$2 ..... FAILURE"
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

dnf install mysql-server -y
VALIDATE $? "Mysql server installation"

systemctl enable mysqld
VALIDATE $? "Enabling mysql server"

systemctl start mysqld
VALIDATE $? "Starting mysql server"

mysql -h 98.84.137.96 -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME

if [ $? -eq 0 ]
then
    echo "Root Password already set"
else
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "setting root password"
fi    








