#!/bin/bash

source components/common.sh

Print "Configure Yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
StatCheck $?

Print "Add Application User"
id ${APP_USER} &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd ${APP_USER} &>>${LOG_FILE}
fi
StatCheck $?

Print "Download App Component"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
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

Print "Fix App User Permissions"
chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
StatCheck $?

Print "Setup SystemD File"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/'
/home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv
/home/roboshop/catalogue/systemd.service/etc/systemd/system/catalogue
.service &>>${LOG_FILE}
StatCheck $?

Print "Restart Catalogue Service"
systemctl daemon-reload &>>${LOG_FILE} && systemctl restart catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}