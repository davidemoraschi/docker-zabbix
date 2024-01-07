@REM docker run --rm -ti -v %userprofile%\.aws:/root/.aws -v %cd%:/aws amazon/aws-cli glue get-jobs
docker run --rm -ti -v %userprofile%\.aws:/root/.aws -v %cd%:/aws amazon/aws-cli glue get-job-runs --job-name Sample_job_01 --output text --query "JobRuns[0].JobRunState"
docker run --rm -ti -v %userprofile%\.aws:/root/.aws -v %cd%:/aws amazon/aws-cli glue get-job-runs --job-name Sample_job_01 --output json --query "JobRuns[*].[Id,JobRunState,StartedOn]"
