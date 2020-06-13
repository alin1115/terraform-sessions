#!/bin/bash
yum install httpd -y
echo "${greeting} from ${name} to ${db_address}" >> /var/www/html/index.html
systemctl start httpd