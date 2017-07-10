# InploitEye

Ferramenta baseada na API da ferramenta www.zoomeye.org.

### DOWNLOAD
```
git clone https://github.com/m4k4br0/InploitEye
apt install jq
```
### CONFIG
O arquivo config, deve ter seus dados substituidos pelas suas credenciais do www.zoomeye.org.

exemplo:
```
username:"user@email.com"
password:"password123"
```
### Usage
A ferramenta usa as 'dorks' da zoomeye.org como argumentos, seguido da especifição do modo de uso, caso seja '--web', você irá passar as 'dorks' referentes a web, caso seja '--host' você passara as dorks referentes a infra.
```
./inploitEye.sh --site site:www.example.com app:wordpress ver:4.7.3 country:brazil
./inploitEye.sh --host port:21 app:vsftd country:brazil
```
Você pode verificar os filtros de busca na seguinte url: https://www.zoomeye.org/api/doc#search-filters

A versão atual ainda é instável

### Reports
Email:keerok@protonmail.com
