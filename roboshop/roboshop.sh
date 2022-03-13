#!/bin/bash

if [ -e components/$1.sh ]; then
  echo "Components does not exit"
fi

bash components/$1.sh
