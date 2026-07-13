#!/bin/bash

USERIDD=$( id -u )

VALIDATE(){
    if [ $1 -eq 0 ]
        then
            echo "$2 installation success"
        else
            echo "$2 installation Failure"
        fi
}

if [ $USERIDD -ne 0 ]
then
    echo "you should have root access to run this script"
fi

if [ $USERIDD -eq 0 ]
then
    dnf list installed nginx
    if [ $? -eq 0 ]
    then
        echo "nginx already installed"
    else
        dnf install nginx -y
        VALIDATE $? "nginx"
        
    fi

fi                          

