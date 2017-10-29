# InploitEye

Tool based API tool www.zoomeye.org.

### DOWNLOAD
```
git clone https://github.com/m4k4br0/InploitEye
apt install jq
```
### CONFIG

The config file must have its data replaced by its credentials of www.zoomeye.org.

Example:
```
username:"user@email.com"
password:"password123"
```
### Usage

The tool uses zoomeye.org 'dorks' as arguments, followed by specifying the usage mode, if it is'web', you will pass the 'dorks' referring to the web, if it is' --host' you will pass the dorks referring to infra.
```
./inploitEye.sh --site site:www.example.com app:wordpress ver:4.7.3 country:brazil
./inploitEye.sh --host port:21 app:vsftd country:brazil
```
You can check the search filters in the following url: https://www.zoomeye.org/api/doc#search-filters

The current version is still unstable

### Reports
Email: keerok@protonmail.com
