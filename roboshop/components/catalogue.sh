#!/bin/bash

source components/common.sh

#1. So let's switch to the `roboshop` user and run the following commands.
#
#```bash
#$ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
#$ cd /home/roboshop
#$ unzip /tmp/catalogue.zip
#$ mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install
#
#```
#
#1. Update SystemD file with correct IP addresses
#
#   Update `MONGO_DNSNAME` with MongoDB Server IP
#
#2. Now, lets set up the service with systemctl.

Print "Configure Yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
StatCheck $?

Print "Add Application User"
useradd ${APP_USER} &>>${LOG_FILE}
StatCheck $?

Print "Download App Component"
curl -s -L -o /tmp/catalogue.zip "https://github
 .com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
StatCheck $?

Print "Cleanup Old Contnent"
rm -rf /home/${APP_USER}/catalogue &&>>${LOG_FILE}
StatCheck $?

Print "Extract App Content"
cd /home/${APP_USER} && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
StatCheck $?

Print "Install App Dependencies"
cd /home/${APP_USER}/catalogue &&>>${LOG_FILE} && npm install &>>${LOG_FILE}
StatCheck $?

.

