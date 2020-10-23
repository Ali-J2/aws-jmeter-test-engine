# Copy Script files
sudo aws s3 cp s3://aws-testengine-s3/script/ICAP-POC_s3.jmx /home/ec2-user/apache-jmeter-5.3/bin/
sudo aws s3 cp s3://aws-testengine-s3/script/files.txt /home/ec2-user/apache-jmeter-5.3/bin/
sudo aws s3 cp s3://aws-testengine-s3/script/lib/ /home/ec2-user/apache-jmeter-5.3/lib/ --recursive

# Get AWS Credentials
OUTPUT=$(aws secretsmanager get-secret-value --secret-id AWS-test-engine-access2 --region eu-west-1 | grep SecretString)

ACCESS_KEY=$(echo ${OUTPUT:42:20})
SECRET_KEY=$(echo ${OUTPUT:89:40})

# Start Test Execution
sudo JVM_ARGS="-Xms9216m -Xmx9216m" sh jmeter.sh -n -t ICAP-POC_s3.jmx -Jp_vuserCount=4000 -Jp_rampup=300 -Jp_duration=900 -Jp_aws_access_key=$ACCESS_KEY -Jp_aws_secret_key=$SECRET_KEY -Jp_bucket=aws-testengine-s3 -Jp_influxHost=10.112.0.112 -Jp_aws_region=eu-west-1 -Jp_url=gw-icap-k8s-a0c293ac.hcp.uksouth.azmk8s.io -l icaptest-s33.log