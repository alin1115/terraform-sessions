#!/bin/bash
yum install httpd -y
echo "${greeting} from ${name}" >> /var/www/html/index.html
systemctl start httpd