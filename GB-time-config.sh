#!/bin/bash
echo "
ZONE="GB"
UTC=true
" > /etc/sysconfig/clock

sudo ln -sf /usr/share/zoneinfo/GB /etc/localtime

echo "Please reboot to apply changes"