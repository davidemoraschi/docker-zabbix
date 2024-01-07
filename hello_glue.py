import boto3

client = boto3.client('glue')

response = client.get_jobs()

#print (response["Jobs"])

response = client.get_job_runs(
    JobName='Sample_job_01'
)

print (response["JobRuns"])
