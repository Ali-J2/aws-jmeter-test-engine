sudo aws s3 cp s3://faridpcre/script/ICAP-POC_s3.jmx /home/ec2-user/apache-jmeter-5.3/bin/
sudo aws s3 cp s3://faridpcre/script/files.txt /home/ec2-user/apache-jmeter-5.3/bin/
sudo aws s3 cp s3://faridpcre/script/lib/ /home/ec2-user/apache-jmeter-5.3/lib/ --recursive
# Get AWS Credentials
OUTPUT=$(aws secretsmanager get-secret-value --secret-id AWS-test-engine-access2 --region eu-west-1 | grep SecretString)
ACCESS_KEY=$(echo ${OUTPUT:42:20})
SECRET_KEY=$(echo ${OUTPUT:89:40})
# Start Test Execution
sudo JVM_ARGS="-Xms1024m -Xmx1024m" sh jmeter.sh -n -t ICAP-POC_s3.jmx -Jp_vuserCount=20 -Jp_rampup=20 -Jp_duration=900 -Jp_aws_access_key=$ACCESS_KEY -Jp_aws_secret_key=$SECRET_KEY -Jp_bucket=faridpcre -Jp_influxHost=172.31.45.19 -Jp_aws_region=eu-west-1 -Jp_url=gw-icap01.westeurope.azurecontainer.io -l icaptest-s33.log
