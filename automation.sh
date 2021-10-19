s3bucketname="upgrad-chaitanya"

sudo apt update -y
sudo apt install apache2
sudo /etc/init.d/apache2 start
sudo systemctl enable apache2
TimeCreated=$(date +%d%m%Y-%H%M%S)

sudo tar -zcvf "/tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz" /var/log/apache2/
sudo aws s3 cp /tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz s3://$s3bucketname/chaitanya-httpd-logs-$TimeCreated.tar

Type="tar"
Log_Type="httpd-logs"
fileName="/tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz"
mysize=$(find "$fileName" -printf "%s")


if [ ! -f /var/www/html/inventory.html ]
then
    sudo touch /var/www/html/inventory.html
    sudo echo 'Log Type     Time Created      Type    Size' >> /var/www/html/inventory.html
fi

sudo echo $Log_Type ' ' $TimeCreated ' ' $Type '   ' $mysize >> /var/www/html/inventory.html

sleep 5

if [ ! -f /etc/cron.d/automation ]
then
    sudo touch /etc/cron.d/automation
fi

echo "30 18 * * * sh /root/Automation_Project/automation.sh" > /etc/cron.d/automation

sleep 5

sudo /usr/bin/crontab /etc/cron.d/automation
