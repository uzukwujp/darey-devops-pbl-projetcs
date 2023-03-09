
export AWS_PROFILE=darey-nonprod-account-access

cd project1
s3 sync images/ s3://dareyio-nonprod-pbl-projects/project1/
cd ..

cd project2
s3 sync images/ s3://dareyio-nonprod-pbl-projects/project2/