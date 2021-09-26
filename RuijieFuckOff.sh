#!/bin/bash
# <RuijieFuckOff.sh> v0.3b
# Encoding: utf-8
# Author: Montsang <auritek@qq.com>
# Good Luck to all CSNUer!

while true
do

logger -t "[*]" " Checking Network Connection..."
### 每1分钟向谷歌请求空白页，并判断返回内容是否为空 ###
if [ -z "$(curl -s google.cn/generate_204)" ];
then

logger -t " |_ [+]" " Connection Seems All OK!"
logger -t " |  [~]" " Waitinfor The Next Check...(60s)"
sleep 1m

else

logger -t " |_ [!]" " Something Wrong Here! (You may got banned or there is a Unknown Network Issue)"
logger -t " |  [*]" " Trying To Refresh The DHCP Service & Establish A Connection Again..."
### 返回结果不为空，开始刷新路由WAN口及DHCP服务 ###
echo $(restart_wan)
sleep 2s
echo $(restart_dhcpd)
echo $(restart_wan)
sleep 2s

logger -t " |   |  [*]" " Establishing Connection..."
### 向校园网服务器发起登陆请求（此处curl部分请参阅README说明自行抓取并替换）###
echo $(
	### 两面包夹之内容，自行替换 ###
	curl 'http://114.5.1.4/eportal/InterFace.do?method=login' \
		-H 'Connection: keep-alive' \
		-H 'User-Agent: Mozilla/6.6 (Windows NT 23.3; Win64; x64) AppleWebKit/555.55 (KHTML, like Gecko) Chrome/114.514.1919.810 Safari/233.33' \
		-H 'DNT: 1' \
		-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
		-H 'Accept: */*' \
		-H 'Origin: http://114.5.1.4' \
		-H 'Referer: http://114.5.1.4/eportal/index.jsp?wlanuserip=secret&wlanacname=secret&ssid=&nasip=secret&snmpagentip=&mac=secret&t=wireless-v2&url=secret&apmac=&nasid=secret&vid=secret&port=secret&nasportid=secret' \
		-H 'Accept-Language: zh-TW,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7,en;q=0.6' \
		-H 'Cookie: EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_DOMAIN=; EPORTAL_COOKIE_OPERATORPWD=; EPORTAL_AUTO_LAND=; EPORTAL_COOKIE_PASSWORD=secret; EPORTAL_COOKIE_USERNAME=114514; EPORTAL_COOKIE_SAVEPASSWORD=true; EPORTAL_USER_GROUP=senpai; EPORTAL_COOKIE_SERVER_NAME=; JSESSIONID=secret' \
		--data-raw '<secret>' \
		--compressed \
		--insecure \
	### 两面包夹之内容，自行替换 ###
)
### 保险起见，休眠10秒再次发起登录请求 ###
sleep 10s
echo $(
	### 两面包夹之内容，自行替换 ###
	curl 'http://114.5.1.4/eportal/InterFace.do?method=login' \
		-H 'Connection: keep-alive' \
		-H 'User-Agent: Mozilla/6.6 (Windows NT 23.3; Win64; x64) AppleWebKit/555.55 (KHTML, like Gecko) Chrome/114.514.1919.810 Safari/233.33' \
		-H 'DNT: 1' \
		-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
		-H 'Accept: */*' \
		-H 'Origin: http://114.5.1.4' \
		-H 'Referer: http://114.5.1.4/eportal/index.jsp?wlanuserip=secret&wlanacname=secret&ssid=&nasip=secret&snmpagentip=&mac=secret&t=wireless-v2&url=secret&apmac=&nasid=secret&vid=secret&port=secret&nasportid=secret' \
		-H 'Accept-Language: zh-TW,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7,en;q=0.6' \
		-H 'Cookie: EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_DOMAIN=; EPORTAL_COOKIE_OPERATORPWD=; EPORTAL_AUTO_LAND=; EPORTAL_COOKIE_PASSWORD=secret; EPORTAL_COOKIE_USERNAME=114514; EPORTAL_COOKIE_SAVEPASSWORD=true; EPORTAL_USER_GROUP=senpai; EPORTAL_COOKIE_SERVER_NAME=; JSESSIONID=secret' \
		--data-raw '<secret>' \
		--compressed \
		--insecure \
	### 两面包夹之内容，自行替换 ###
)

logger -t " |   |  [*]" " Checking Connection..."
### 再次检查网络状态，向谷歌请求空白页 ###
if [ -z "$(curl -s google.cn/generate_204)" ];
then

logger -t " |_ [+]" " Network Restored!"
logger -t " |  [~]" " Waiting For Next Check...(60s)"
### 网络恢复，则休眠1分钟后继续循环检查网络状态 ###
sleep 1m

else

logger -t " |_ [+]" " You Got Banned!"
logger -t " |  [~]" " Waiting For Ban Timeout...(7min)"
### 网络异常，则休眠7分钟后重新检查网络并再次尝试连接 ###
sleep 7m
fi

fi
done
