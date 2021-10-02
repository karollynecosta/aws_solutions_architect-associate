# generate root access keys
aws configure --profile root-mfa-delete-demo

# enable mfa delete
aws s3api put-bucket-versioning --bucket mfa-demo --versioning-configuration Status=Enabled,MFADelete=Enabled 
--mfa "ard-of-mfa-device mfa-code" --profile root-mfa-delete-demo

#delete
aws s3api put-bucket-versioning --bucket mfa-demo --versioning-configuration Status=Enabled,MFADelete=Disabled 
--mfa "ard-of-mfa-device mfa-code" --profile root-mfa-delete-demo