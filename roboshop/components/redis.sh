#!/bin/bash

source components/common.sh

Print "Setup YUM repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
StatCheck $?

Print "Redis Installation"
yum install redis -y &>>${LOG_FILE}
StatCheck $?

Print "replacing localhost with 0.0.0.0 in redis conf"
if [ -f /etc/redis.conf ]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
fi
if [ -f /etc/redis/redis.conf ]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>${LOG_FILE}
fi
StatCheck $?

Print "Restarting Redis Service"
systemctl enable redis &>>${LOG_FILE} && systemctl restart redis &>>${LOG_FILE}
StatCheck $?