#!/bin/bash
echo "
ZONE="GB"
UTC=true
" > /etc/sysconfig/clock

sudo ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

echo "Please reboot to apply changes"