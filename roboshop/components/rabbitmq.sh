#!/bin/bash

source components/common.sh

Print "configure yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG_FILE}
StatCheck $?

Print "start Erlang rabbitmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
StatCheck $?

Print "Install RabbitMQ-Server"
yum install rabbitmq-server -y &>>${LOG_FILE}
StatCheck $?

Print "start rabbitmq service"
systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl start rabbitmq-server &>>${LOG_FILE}
StatCheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  Print "create application user"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  StatCheck $?
fi

Print "configure application user"
rabbitmqctl set_user_tags roboshop administrator && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
  StatCheck $?


