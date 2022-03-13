#!/bin/bash

StatCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCES\e[0m"
  else
    echo -e '\e[31mFAILURE\e[0m'
    exit 2
  fi
}

Print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo You should run your script as sudo as sudo or root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

Print "Installing Nginx"
yum install nginx -y >>$LOG_FILE
StatCheck $?

Print "Downloading Nginx Content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$LOG_FILE
StatCheck $?

Print "Cleanup Old Nginx Content"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
StatCheck $?

Print "Cleanup Old Nginx Content"
rm -rf /usr/share/nginx/html/*
StatCheck $?

cd /usr/share/nginx/html

Print "Extracting Archive"
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* . >>$$LOG_FILE && mv static/* .
>>$LOG_FILE
StatCheck $?

Print "Update Roboshop Configiration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$$LOG_FILE
StatCheck $?

Print "Starting Nginx"
systemctl restart nginx >>$$LOG_FILE && systemctl enable nginx >>$$LOG_FILE
StatCheck $?
