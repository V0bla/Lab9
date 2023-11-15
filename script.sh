#!/bin/bash
# Подготовка ОС
sudo -i
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
yum -y install mailx sendmail nano chrony httpd net-tools
# запускаем синхронизацию времени chrony, почтовый сервис sendmail и перезапускаем rsyslog (для корректного отображения времени в логах)
systemctl enable httpd.service
systemctl start httpd.service
systemctl start chrony-wait.service
systemctl start sendmail.service
systemctl restart rsyslog.service

#тестовые запросы к web серверу
curl http://localhost/test.html
curl http://localhost

# настройка задания Cron
#email="root@localhost" 
echo "@hourly flock -xn /tmp/InfoToEmail.lock /tmp/InfoToEmail.sh" > /var/spool/cron/root
chmod +x /tmp/InfoToEmail.sh

