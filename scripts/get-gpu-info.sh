#!/bin/bash

echo "---------------------------------"
echo "lspci -nn | grep -E 'VGA|Display'"
echo "---------------------------------"
lspci -nn | grep -E 'VGA|Display'
echo "---------------------------------"
echo "sudo lshw -C display"
echo "---------------------------------"
sudo lshw -C display
echo "---------------------------------"
echo "glxinfo -B"
echo "---------------------------------"
glxinfo -B
