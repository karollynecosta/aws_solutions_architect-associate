# make sure that you tipyng the right region
aws s3 presign s3://mycket/object --region us-east-1

# add a custom expiration time
aws s3 presign s3://mybucket/object --expires-in 300 --region us-east-1

