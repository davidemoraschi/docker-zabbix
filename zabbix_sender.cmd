"C:\zabbix_agent2-6.4.10-windows-amd64-static\bin\zabbix_sender" -z localhost -p 10051 -s "zabbix-server" -k trap -o "SUCCESS"


zabbix_sender -z zabbix-server -p 10051 -s "zabbix-server" -k Sample_job_01 -o "RUNNING" -vv
