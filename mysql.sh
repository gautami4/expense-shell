#!/bin/bash

USERID=$(id -u)

if ( $USERID -ne 0 )
then
    echo "you should have root access to run this script"
fi

if ( $? -eq 0 )
then
    dnf list installed mysql
    if ( $? -eq 0 )
    then
        echo "mysql already installed"
    else
        dnf install mysql -y
        if ( $? -eq 0 )
        then
            echo "Mysql installation success"
        else
            echo "Mysql installation Failure"
        fi
    fi

fi                          

