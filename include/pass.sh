#!/bin/bash

USERNAME=$1

id -u $USERNAME > /dev/null
if [ $? -ne 0 ]
then
        #echo "User $USERNAME is not valid"
        exit 1
else
        #echo "Enter the Password:"
        PASSWD=$2
        export PASSWD
        ORIGPASS=`grep -w "$USERNAME" /etc/shadow | cut -d: -f2`
        export ALGO=`echo $ORIGPASS | cut -d'$' -f2`
        export SALT=`echo $ORIGPASS | cut -d'$' -f3`
        GENPASS=$(perl -le 'print crypt("$ENV{PASSWD}","\$$ENV{ALGO}\$$ENV{SALT}\$")')
        if [ "$GENPASS" == "$ORIGPASS" ]
        then
                echo "0"
                exit 0
        else
                echo "1"
                exit 1
        fi
fi
