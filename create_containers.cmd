docker network rm zabbix-net --force
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net

docker stop postgres-server
docker remove postgres-server
docker run -h postgres-server --name postgres-server -t ^
      -v ./postgres-data:/var/lib/postgresql/data ^
      -e POSTGRES_USER="zabbix" ^
      -e POSTGRES_PASSWORD="zabbix_pwd" ^
      -e POSTGRES_DB="zabbix" ^
      --network=zabbix-net ^
      -p 5432:5432 ^
      --restart unless-stopped ^
      -d postgres:latest

docker stop zabbix-snmptraps
docker remove zabbix-snmptraps
docker run -h zabbix-snmptraps --name zabbix-snmptraps -t ^
      -v ./snmptraps:/var/lib/zabbix/snmptraps:rw ^
      -v ./mibs:/usr/share/snmp/mibs:ro ^
      --network=zabbix-net ^
      -p 162:1162/udp ^
      --restart unless-stopped ^
      -d zabbix/zabbix-snmptraps:alpine-6.4-latest

docker stop zabbix-server-pgsql
docker remove zabbix-server-pgsql
docker run -h zabbix-server-pgsql --name zabbix-server-pgsql -t ^
      --link zabbix-agent:zabbix-agent --privileged ^
      -e ZBX_HOSTNAME="zabbix-server-pgsql" ^
      -e DB_SERVER_HOST="postgres-server" ^
      -e POSTGRES_USER="zabbix" ^
      -e POSTGRES_PASSWORD="zabbix_pwd" ^
      -e POSTGRES_DB="zabbix" ^
      -e ZBX_ENABLE_SNMP_TRAPS="true" ^
      --network=zabbix-net ^
      -p 10051:10051 ^
      -v ./zabbix:/usr/lib/zabbix:rw ^
      -v ./snmptraps:/var/lib/zabbix/snmptraps:rw ^
      -v ./mibs:/usr/share/snmp/mibs:ro ^
      -v %userprofile%\.aws:/var/lib/zabbix/.aws ^
      -v %cd%:/aws ^
      --restart unless-stopped ^
      -d zabbix/zabbix-server-pgsql:alpine-6.4-latest

docker stop zabbix-agent
docker remove zabbix-agent
docker run -h zabbix-agent --name zabbix-agent ^
    --link zabbix-server-pgsql:zabbix-server --privileged ^
    -e ZBX_HOSTNAME="zabbix-agent" ^
    -e ZBX_SERVER_HOST="zabbix-server-pgsql"  ^
    --restart=always ^
    --network=zabbix-net ^
    -p 10050:10050 ^
    -d zabbix/zabbix-agent:alpine-6.4-latest

docker stop zabbix-web-nginx-pgsql
docker remove zabbix-web-nginx-pgsql
docker run -h zabbix-web-nginx-pgsq --name zabbix-web-nginx-pgsql -t ^
      -e ZBX_SERVER_HOST="zabbix-server-pgsql" ^
      -e DB_SERVER_HOST="postgres-server" ^
      -e POSTGRES_USER="zabbix" ^
      -e POSTGRES_PASSWORD="zabbix_pwd" ^
      -e POSTGRES_DB="zabbix" ^
      -e PHP_TZ="Europe/Madrid" ^
      -e ZBX_SERVER_NAME="Zabbix test" ^
      --network=zabbix-net ^
      -p 443:8443 ^
      -p 80:8080 ^
      -v ./nginx:/etc/ssl/nginx:ro ^
      --restart unless-stopped ^
      -d zabbix/zabbix-web-nginx-pgsql:alpine-6.4-latest