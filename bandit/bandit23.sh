#!/bin/bash

myname="bandit24"
mytarget="reg1reg1"

echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"

cat /etc/bandit_pass/$myname > /tmp/$mytarget