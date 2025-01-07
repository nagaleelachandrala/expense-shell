#!/bin/

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m]"


LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$( date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMEATAMP.log"
VALIDATE(){     

  if [ $1 -ne 0 ]
   then
       echo -e "$2 .. $R FAILURE $N"
        exit 1
   else 
     echo -e "$2 ..$G SUCESS $N"    
   fi   
}

CHECK_ROOT(){
if [ $USERID -ne 0 ]
then
    echo "ERROR :: you must hv sudo access to run the script "
    exit 1
fi
}

echo "script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

 dnf install mysql-server -y &>>LOG_FILE_NAME
 VALIDATE $? "Installing MYSQL server"

 syscemctl enable mysqld &>>LOG_FILE_NAME
 VALIDATE $? "Enabling MYSQL server"

 syscemctl start mysqld &>>LOG_FILE_NAME
 VALIDATE $? "starting MYSQL server"

 mysql_secure_installation --set-root-pass ExpenseApp@1
 VALIDATE $? "setting up root password"