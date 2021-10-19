s3bucketname="upgrad-chaitanya"

sudo apt update -y
sudo apt install apache2
sudo /etc/init.d/apache2 start
sudo systemctl enable apache2
TimeCreated=$(date +%d%m%Y-%H%M%S)

sudo tar -zcvf "/tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz" /var/log/apache2/
sudo aws s3 cp /tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz s3://$s3bucketname/chaitanya-httpd-logs-$TimeCreated.tar

