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
            echo "$2 ..... success"
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

CHECK_ROOT

dnf install nginx -y    &>>$LOG_FILE_NAME
VALIDATE $? "nginx installation" 

systemctl enable nginx  &>>$LOG_FILE_NAME
VALIDATE $? "enabling nginx"

systemctl start nginx >>$LOG_FILE_NAME
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* >>$LOG_FILE_NAME
VALIDATE $? "removing existing version of code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOG_FILE_NAME
VALIDATE $? "Downloading latest code"

cd /usr/share/nginx/html >>$LOG_FILE_NAME
VALIDATE $? "moving to html directory"

unzip /tmp/frontend.zip >>$LOG_FILE_NAME
VALIDATE $? "unzipping the frontend code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "copied expense config"

systemctl restart nginx >>$LOG_FILE_NAME
VALIDATE $? "restart nginx"
