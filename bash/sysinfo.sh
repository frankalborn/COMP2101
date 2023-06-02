#!/bin/bash

echo "FQDN: "
hostname -f

echo "Host Information"
hostnamectl

echo "IP addresses: " 
hostname -I

echo "Space Available"
df / -h
