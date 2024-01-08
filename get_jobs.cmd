@REM docker run --rm -ti -v %userprofile%\.aws:/root/.aws -v %cd%:/aws amazon/aws-cli glue get-jobs
docker run --rm -ti -v %userprofile%\.aws:/root/.aws -v %cd%:/aws amazon/aws-cli glue get-job-runs --job-name Sample_job_01 --output text --query "JobRuns[0].JobRunState"
docker run --rm -ti -v %userprofile%\.aws:/root/.aws -v %cd%:/aws amazon/aws-cli glue get-job-runs --job-name Sample_job_01 --output json --query "JobRuns[*].[Id,JobRunState,StartedOn]"

docker exec -it -u 0 zabbix-agent aws glue get-job-runs --job-name Sample_job_01

aws glue get-job-runs --job-name Sample_job_01 --max-items 1 --output json --query 'JobRuns[0].JobRunState'
out=$(aws glue get-job-runs --job-name Sample_job_01 --max-items 1 --output json --query "JobRuns[0].JobRunState")
zabbix_sender -z zabbix-server -p 10051 -s "zabbix-server" -k Sample_job_01 -o "$out"


