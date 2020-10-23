## Deploy CloudFormation stack to run jmeter tests

1. Install python.

2. Install boto3 python package by running below command:

```
pip3 install boto3
```

3. Set AWS authentication.

Get the AWS access key credentails and update in ~/.aws/credentials file for a particular profile. Below is an example of how it should look.

```
[glasswall]
aws_access_key_id = <required value>
aws_secret_access_key = <required value>
aws_session_token = <optional value>
```

Update the ~/.aws/config with the same profile by setting the region you want to use. Below is an example

```
[profile glasswall]
region = eu-west-2
```

4. Run below command to get help on the script

```
python create_stack.py -h
```

Pass input parameters as required to the script.

`total_users` is the total number of users for the test. Default value of this parameter is 4000

`users_per_instance` is the number of users per ec2 instance. Default value of this parameter is 4000

`ramp_up` is the ramp up time. Default value is 300 seconds

`duration` is the duration of the test. Default value 900 seconds

`endpoint_url`is the ICAP server URL. Default value is gw-icap02.westeurope.azurecontainer.io

`inlfux_host` is the IP address or hostname of the Influx DB

Based on the values passed for total_users and users_per_instance, number of instances required will be calculated. The total users will be equally divided among all the instances.

Based on the calculated value of number of users per instance, the size of the EC2 is choosed based on the below table:

| Users per instance | EC2 size   |
|--------------------|------------|
| 0 < n < 1000       | m4.large   |
| 1000 <= n < 2500   | m4.xlarge  |
| 2500 <= n <= 4000  | m4.2xlarge |


5. Create config file.

Create config.env file by copying config.env.sample file. Update the file with below details:

- aws_profile_name - The AWS profile created in step 3.
- bucket=gov - Bucket name where a file with number of instances will be created.
- file_name -  File name with number of instances will be created in the s3 bucket.

6. Create the cloudformation stack by running below command:

Linux or Mac:
```bash
export AWS_DEFAULT_PROFILE=your_profile_name
python create_stack.py --total_users 4000 --users_per_instance 4000
```

Windows powershell or command prompt:
```powershell
python create_stack.py --total_users 4000 --users_per_instance 4000 --ramp_up=300 --duration=900 --inlfux_host=10.112.0.112 --endpoint_url=gw-icap01.westeurope.azurecontainer.io
```

7. Once the tests are completed, delete the stack from AWS cloudformation using console and run the script again when required.

