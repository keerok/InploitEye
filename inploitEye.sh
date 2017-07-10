#!/bin/bash

#Guilherme Assmann
#Heitor Gouvea
#InploiSecurity

function helper(){
	echo -en "[WebApp]\n"
	echo -en "inploitEye --web site:example.com app:wordpress ver:4.7.2 country:brazil\n"
	echo -en "\n"
	echo -en "[Infra]\n"
	echo -en "inploitEye --host ip:0.0.0.0 app:ProFTPD country:brazil\n"

}
function banner_2(){
	echo -en "MMMMMMMMMMMMMMMMMNhs+//////+shNMMMMMMMMMMMMMMMMM\n"
	echo -en "MMMMMMMMMMMMMMMMs//////////////sMMMMMMMMMMMMMMMM\n"
	echo -en "MMMMMMMMMMMMMMMo///++++++++++///oMMMMMMMMMMMMMMM\n"
	echo -en "MMMMMMMMMMMMMMd/hNMMMMMMMMMMMMNh/dMMMMMMMMMMMMMM\n"
	echo -en "MMMMMMmyNMMMMMyyMMMMMMMMMMMMMMMMyyMMMMMNymMMMMMM\n"
	echo -en "MMMMNoohNMMMMMy+NMMMMNyooyNMMMMN+yMMMMMNhooNMMMM\n"
	echo -en "MMMMMMdo+sNMMMd//syyo//////oyys//dMMMNs+odMMMMMM\n"
	echo -en "MMMMMMMMhyhmMMMo////////////////oMMMmhyhMMMMMMMM\n"
	echo -en "MMMMMMMMMdhyNMMMo//////////////oMMMNyhdMMMMMMMMM\n"
	echo -en "MMMMMMMMMMh+osNMMh////////////hMMNso+hMMMMMMMMMM\n"
	echo -en "MMMMMMMMMMMMdhysmMMh////////hMMmsyhdMMMMMMMMMMMM\n"
	echo -en "MMMMMMMMMMMNyo//yMNh////////hNMy//oyNMMMMMMMMMMM\n"
	echo -en "MMMMMMMMMMNmdh+//////////////////+hdmNMMMMMMMMMM\n"
	echo -en "MMMMMMMMh+////////////////////////////+hMMMMMMMM\n"
	echo -en "MMMMMMMo////////////////////////////////oMMMMMMM\n"
	echo -en "MMMMMMy//////////////////////////////////yMMMMMM\n"
	echo -en "MMMMMN////////////////////////////////////NMMMMM\n"
	echo -en "MMMMMy////////////////////////////////////yMMMMM\n"
	echo -en "MMMMM+////////////////////////////////////+MMMMM\n"
	echo -en "MMMMN//////////////////////////////////////NMMMM\n"
	echo -en "MMMMd//////////////////////////////////////dMMMM\n"
	echo -en "MMMMd//////////////////////////////////////dMMMM\n"
	echo -en "MMMMMmhso//////////////////////////////oshmMMMMM\n"
	echo -en "MMMMMMMMMMNmdhysoo++////////++oosyhdmNMMMMMMMMMM\n"
}


function banner(){

	echo -en "\e[01;32m _____            _       _ _   _____     \n"
	echo -en "|_   _|          | |     (_) | |  ___|          \n"
	echo -en "  | | _ __  _ __ | | ___  _| |_| |__ _   _  ___ \n"
	echo -en "  | || '_ \| '_ \| |/ _ \| | __|  __| | | |/ _ \\n"
	echo -en " _| || | | | |_) | | (_) | | |_| |__| |_| |  __/\n"
	echo -en " \___/_| |_| .__/|_|\___/|_|\__\____/\__, |\___|\n"
	echo -en "           | |                        __/ |     \n"
	echo -en "           |_|                       |___/      \n"
	echo -en "		Version: 0.2			  \n"
	echo -en "	  Athor:Guilherme Assmann		  \n"
	echo -en "	        Heitor Gouvea			  \n"
	echo -en "						  \n"
	echo -en "	      Inploit Security			  \n"

}

function webapp(){
	for i in $argumentos ; do
		if [ $i != "--web" ];then
			pontos=$(echo $i | cut -d ":" -f1)
			depois=$(echo $i | cut -d ":" -f2)
			final_query+=$pontos":"$(perl -MURI::Escape -e 'print uri_escape("'$depois' ");' "$2")
		fi
	done
	i="0";
	passwd=$(cat config | grep "password" | cut -d ":" -f2)
	user=$(cat config | grep "username" | cut -d ":" -f2)
        accessToken_1=$(curl --silent -XPOST https://api.zoomeye.org/user/login -d '{"username":'$user', "password":'$passwd'}')
        accessToken=$(echo $accessToken_1 | cut -d ":" -f2 | cut -d '"' -f2)
	banner_2
        Auth_preparer=$(curl --silent -X GET 'https://api.zoomeye.org/web/search?query='$final_query'&page=1&facets=app,os' -H "Authorization: JWT $accessToken")
        echo $Auth_preparer > data.json
	quant=$(cat data.json | grep -o '"site"' | wc -l)
	while [ $i -ne $quant ]; do
		#echo "t${ip[$i]}t"
		ip[$i]=$(jq '.matches['$i'].ip' data.json)
		webappVersion[$i]=$(jq '.matches['$i'].webapp[0].version' data.json)
		Web[$i]=$(jq '.matches['$i'].webapp[0].name' data.json)
		site[$i]=$(jq '.matches['$i'].site' data.json)
		language[$i]=$(jq '.matches['$i'].language[0]' data.json)
		wafInfo[$i]=$(jq '.matches['$i'].waf['']' data.json)
		Domain[$i]=$(jq '.matches['$i'].domains[0]' data.json)
		dbName[$i]=$(jq '.matches['$i'].db[0].name' data.json)
		ServerVersion[$i]=$(jq '.matches['$i'].server[0].version' data.json)
		header[$i]=$(jq '.matches['$i'].headers' data.json)
		serverName[$i]=$(jq '.matches['$i'].server[0].name' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		echo "+=================================+"
		echo "Site: ${site[$i]}"
		echo "Ip: ${ip[$i]}"
		echo "Header: ${header[$i]}"
		echo "Language: ${language[$i]}"
		echo "WAF: ${wafInfo[$i]}"
		echo "Webapp Used: ${Web[$i]} Version: ${webappVersion[$i]}"
		echo "Domain: ${Domain[$i]}"
		echo "db name: ${dbName[$i]}"
		echo "Sever version: ${SeverVersion[$i]}"
		echo "ServerName: ${serverName[$i]}"
		i=$[$i+1]
	done
	rm -rf data.json
}


function portable(){
	for i in $argumentos; do
		if [ $i != "--host" ];then
			pontos=$(echo $i | cut -d ":" -f1)
			depois=$(echo $i | cut -d ":" -f2)
			final_query+=$pontos":"$(perl -MURI::Escape -e 'print uri_escape("'$depois' ");' "$2")
		fi
	done
	passwd=$(cat config | grep "password" | cut -d ":" -f2)
        user=$(cat config | grep "username" | cut -d ":" -f2)

	accessToken_1=$(curl --silent -XPOST https://api.zoomeye.org/user/login -d '{"username":'$user', "password":'$passwd'}')
        accessToken=$(echo $accessToken_1 | cut -d ":" -f2 | cut -d '"' -f2)
	banner_2
        Auth_preparer=$(curl --silent -X GET 'https://api.zoomeye.org/host/search?query='$final_query'&page=1&facet=app,os' -H "Authorization: JWT $accessToken")
       	echo $Auth_preparer > data.json
	quant=$(cat data.json | grep -o '"ip"' | wc -l)
	i="0"
	while [ $i -ne $quant ];do
		ipInfo[$i]=$(jq '.matches['$i'].ip' data.json)
		portInfo[$i]=$(jq '.matches['$i'].portinfo.app' data.json)
		versionInfo[$i]=$(jq '.matches['$i'].portinfo.version' data.json)
		serviceInfo[$i]=$(jq '.matches['$i'].portinfo.service' data.json)
		portBanner[$i]=$(jq '.matches['$i'].portinfo.banner' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne $quant ]; do
		echo "+===================================+"
		echo "Ip: ${ipInfo[$i]}" 
		echo "PortInfo: ${portInfo[$i]}"
		echo "PortInfo Version: ${versionInfo[$i]}"
		echo "Service Info: ${serviceInfo[$i]}"
		echo "Port Banner: ${portBanner[$i]}"
		echo "+===================================+"
		i=$[$i+1]
	done
	#rm -rf data.json
}

banner
case $1 in
"--host") argumentos=$* ; portable
;;
"--web") argumentos=$* ; webapp
;;
"-h") helper
;;
"--help") helper
;;
"--banner") banner
;;
esac
