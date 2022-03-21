#!/bin/bash

if [ -z "$1" ]; then
  echo -e "\e[31m input machine name is needed\e[0m"
  exit 1
fi

COMPONENT=$1
ZONE_ID="Z05705092FH54GCN798S"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=launch-wizard-1 | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

echo $AMI_ID
PRIVATE_IP=$(aws ec2 run-instances \
    --image-id ${AMI_ID} \
    --instance-type t2.micro \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=${COMPONENT}}]" \
    --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
    --security-group-ids ${SGID} \
    | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json |jq