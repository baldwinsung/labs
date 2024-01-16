
# Create default vpc
```
export AWS_ACCESS_KEY_ID="X"
export AWS_SECRET_ACCESS_KEY="X"
aws ec2 create-default-vpc
aws ec2 --output text --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value|[0],CidrBlock:CidrBlock}' describe-vpcs
```

# Update EC2 security group
Update securitygroup.tf with your IP address or use 0.0.0.0/0 to allow all.

Get your current IP address

```
curl ifconfig.co
```

# Update EC2 resource
Update main.tf with your access key and secret key. ( Not using environment variable AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY at this time )

Update public_key in key.tf with your ssh public key.



# Create the ec2 instance via terraform
Create the ec2 resource.

```
terraform init
terraform plan
terraform apply
```

# ssh to the EC2 resource
Using the public_dns from outputs. ssh to the ec2 resource as the ec2-user

```
ssh ec2-user@public_dns
```

# Apply updates to the EC2 resource
After connecting to the ec2 resource via ssh. Run yum update to apply the latest updates


```
sudo yum update -y
```


# Destroy the ec2 instance via terraform
Destroy the ec2 resource when finished testing

```
terraform destroy
```



