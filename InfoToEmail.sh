#!/bin/bash
#Скрипт в качестве параметра принимает email в формате "recipient@example.com" для отправки сообщения 
access_log='/var/log/httpd/access_log'
error_log='/var/log/httpd/error_log'
#Временной интервал
start_er=$(cat /tmp/time_er.tmp)
start_t=$(cat /tmp/time.tmp)
if [ ! $start_t ]
then
  start_t=$(awk '{print $4}' $access_log | sed "s/\[//" | head -1 )
fi
end_t=$(date -d "now" +'%d/%b/%Y:%H:%M:%S')
#кол-во строк в файле $access_log
file_lenth_ac=$(awk 'END{ print NR}' $access_log)
file_lenth_er=$(awk 'END{ print NR}' $error_log)
#адрес получателя
TO='root@localhost'

function f_subject (){
  echo "Report for period from $start_t to $end_t " 
}

function f_ip_stat (){
# получаем информацию об уникальных запросах в момент времени, затем подсчитываем кол-во запросов с 3-х наиболее активных ip адресов
  #Вывод файла с момента последнего выполнения скрипта
    result_ip_stat=$(grep -iA $file_lenth_ac $start_t $access_log | awk '{print $1,$4}' | sort | uniq | awk '{print $1}' | uniq -c | sort | tail -3)
}

function f_url_stat (){
# получаем информацию об уникальных запросах в момент времени, затем подсчитываем кол-во ip адресов
  #Вывод файла с момента последнего выполнения скрипта
    result_url_stat=$(grep -iA $file_lenth_ac "$start_t" $access_log | awk '{print $11}' | grep 'http' | sort | uniq -c | sort | tail -3)
  # фиксируем последнюю запись лога
  awk '{print $4}' $access_log | sed "s/\[//" | tail -1 > /tmp/time.tmp
}

function f_error_stat (){
# получаем информацию об уникальных запросах в момент времени, затем подсчитываем кол-во ip адресов
  #Вывод файла с момента последнего выполнения скрипта
  if [ "$start_er" ]
  then
    result_error_stat=$(grep -iA $file_lenth_er "$start_er" $error_log)
  else
    result_error_stat=$(cat $error_log)
  fi
  # фиксируем последнюю запись лога
  awk '{print $2,$3,$4,$5}' $error_log | sed "s/\]//" | tail -1 >  /tmp/time_er.tmp
}

function f_http_code_stat (){
# получаем информацию об уникальных запросах в момент времени, затем подсчитываем кол-во ip адресов
  #Вывод файла с момента последнего выполнения скрипта
    result_http_code_stat=$(grep -iA $file_lenth_ac "$start_t" $access_log | awk '{print $9}' | sort | uniq -c | sort )
}

f_ip_stat
f_url_stat
f_error_stat
f_http_code_stat

SUBJECT=$(f_subject)
MESSAGE="List of IP's:
$result_ip_stat
List of URL's:
$result_url_stat
List of errors:
$result_error_stat
List of status codes:
$result_http_code_stat"
echo "$MESSAGE" | mailx -s "$SUBJECT" "$TO"
