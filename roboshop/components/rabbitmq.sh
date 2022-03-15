#!/bin/bash

source components/common.sh

Print "start Erlang rabbitmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>{LOG_FILE}
StatCheck $?

Print "configure yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>{LOG_FILE}
StatCheck $?

Print "Install RabbitMQ-Server"
yum install rabbitmq-server -y
StatCheck $?

Print "start rabbitmq service"
systemctl enable rabbitmq-server &>>{LOG_FILE} && systemctl start rabbitmq-server &>>{LOG_FILE}
StatCheck $?

Print "create application user"
rabbitmqctl add_user roboshop roboshop123 &>>{LOG_FILE}
StatCheck $?
