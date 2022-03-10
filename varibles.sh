#1/bin/bash

a=100
b=devops

echo ${a}times
echo ${b} Traning n

# {} are needed if variables is combine

DATE=2022-03-10
echo Today date is $DATE


DATE=(date +%F)
echo Today date is DATE J

x=10
y=20
ADD=$(($x+$y))
echo ADD = $ADD
