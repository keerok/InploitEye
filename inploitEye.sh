#!/bin/bash

#Guilherme Assmann
#Heitor Gouvea
#InploitEye
#ZOOM EYE API
#version 0.2

#Inploit Security

function helper(){
	echo -en "[WebApp]\n"
	echo -en "inploitEye --site <site>\n"
	echo -en "inploitEye --site <site> --app <webapp>\n"
	echo -en "inploitEye --site www.example.com --app wordpress-4.7.2\n"
	echo -en "\n"
	echo -en "[Infra]\n"
	echo -en "inploitEye --ip <ip>\n"
	echo -en "inploitEye --ip <ip> --port <port>\n"
	echo -en "inploitEye --ip 10.10.10.10 --port 21\n"

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

}

function cms_app2(){
	echo -ne "Country: "
	read country
	country_query=$(perl -MURI::Escape -e 'print uri_escape("country:'$country' ");' "$2")
	echo -ne "App Used: "
	read app
	app_query=$(perl -MURI::Escape -e 'print uri_escape("app:'$app' ");' "$2")
	echo -ne "Version: "
	read vers
	ver_query=$(perl -MURI::Escape -e 'print uri_escape("ver:'$vers'");' "$2")
	final_query=$country_query$app_query$ver_query
	echo $final_query

	i="0";
	ip=[]
	site=[]
	languages=[]
	serverName=[]
	header=[]
	dbName=[]
	wafInfo=[]
	Web=[]
	Domain=[]
	ServerVersion=[]
	
        accessToken_1=$(curl -XPOST https://api.zoomeye.org/user/login -d '{"username":"", "password":""}')
        accessToken=$(echo $accessToken_1 | cut -d ":" -f2 | cut -d '"' -f2)
        echo $accessToken
        Auth_preparer=$(curl -X GET 'https://api.zoomeye.org/web/search?query='$final_query'&page=1&facets=app,os' -H "Authorization: JWT $accessToken")
        echo $Auth_preparer > data.json
	quant=$(cat data.json | grep -o '"site"' | wc -l)
	while [ $i -ne $quant ]; do
		#echo "t${ip[$i]}t"
		ip[$i]=$(jq '.matches[$i].ip[0]' data.json)
		i=$[$i+1]
	done
	
	i="0"
	while [ $i -ne $quant ]; do
		webappVersion[$i]=$(jq '.matches['$i'].webapp[0].version' data.json)
		i=$[$i+1]
	done

	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		 Web[$i]=$(jq '.matches['$i'].webapp[0].name' data.json)
		 i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		site[$i]=$(jq '.matches['$i'].site' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		language[$i]=$(jq '.matches['$i'].language[0]' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		wafInfo[$i]=$(jq '.matches['$i'].waf['']' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		Domain[$i]=$(jq '.matches['$i'].domains[0]' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		dbName[$i]=$(jq '.matches['$i'].db[0].name' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		ServerVersion[$i]=$(jq '.matches['$i'].server[0].version' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		header[$i]=$(jq '.matches['$i'].headers' data.json)
		i=$[$i+1]
	done
	while [ $i -ne "${#ip[@]}" ]; do
		serverName[$i]=$(jq '.matches['$i'].server[0].name' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ip[@]}" ]; do
		echo "Site: ${site[$i]}"
		echo "Ip: ${ip[$i]}"
		echo "Header: ${header[$i]}"
		echo "Language: ${Domain[$i]}"
		echo "WAF: ${wafInfo[$i]}"
		echo "Webapp Used: ${Web[$i]} Version: ${webappVersion[$i]}"
		echo "Domain: ${Domain[$i]}"
		echo "db name: ${dbName[$i]}"
		echo "Sever version: ${SeverVersion[$i]}"
		echo "ServerName: ${serverName[$i]}"
		echo "+=================================+"
		i=$[$i+1]
	done
	rm -rf data.json
}

function portable(){
	ipInfo=[]
	portInfo=[]
	portBanner=[]
	versionInfo=[]
	serviceInfo=[]
	echo -ne "Port: "
	read port
	port_query=$(perl -MURI::Escape -e 'print uri_escape("port:'$port' ");' "$2")
	echo -ne "App: "
	read app
	app_query=$(perl -MURI::Escape -e 'print uri_escape("app:'$app' ");' "$2")
	
	echo -ne "Country: "
	read country
	country_query=$(perl -MURI::Escape -e 'print uri_escape("country:'$country'");' "$2")

	final_query=$port_query$app_query$country_query
	echo $final_query
	accessToken_1=$(curl -XPOST https://api.zoomeye.org/user/login -d '{"username":"", "password":""}')
        accessToken=$(echo $accessToken_1 | cut -d ":" -f2 | cut -d '"' -f2)
	echo $accessToken
        Auth_preparer=$(curl -X GET 'https://api.zoomeye.org/host/search?query='$final_query'&page=1&facet=app,os' -H "Authorization: JWT $accessToken")
       	echo $Auth_preparer > data.json
	quant=$(cat data.json | grep -o '"ip"' | wc -l)
	i="0"
	while [ $i -ne $quant ];do
		ipInfo[$i]=$(jq '.matches['$i'].ip' data.json)
		i=$[$i+1]
	done
	
	echo "TAMANHO: ${#ipInfo[@]}"

	i="0"
	while [ $i -ne "${#ipInfo[@]}" ]; do
		portInfo[$i]=$(jq '.matches['$i'].portinfo.app' data.json)
		i=$[$i+1]
	done

	i="0"
	while [$i -ne "${#ipInfo[@]}" ]; do
		versionInfo[$i]=$(jq '.matches['$i'].portinfo.version' data.json)
		i=$[$i+1]
	done
	
	i="0"
	while [$i -ne "${#ipInfo[@]}" ]; do
		serviceInfo[$i]=$(jq '.matches['$i'].portinfo.service' data.json)
		i=$[$i+1]
	done

	i="0"
	while [ $i -ne "${#ipInfo[@]}" ]; do
		portBanner[$i]=$(jq '.matches['$i'].portinfo.banner' data.json)
		i=$[$i+1]
	done
	i="0"
	while [ $i -ne "${#ipInfo[@]}" ]; do
		echo "+===================================+"
		echo "Ip: ${ipInfo[$i]}" 
		echo "PortInfo: ${portInfo[$i]}"
		echo "PortInfo Version: ${versionInfo[$i]}"
		echo "Service Info: ${serviceInfo[$i]}"
		echo "Port Banner: ${portBanner[$i]}"
		echo "+===================================+"
		i=$[$i+1]
	done
	rm -rf data.json
}

banner
case $1 in
"--ip") portable
;;
"--site") cms_app2
;;
"-h") helper
;;
"--help") helper
;;
"--banner") banner
;;
