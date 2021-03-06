# Automation_Project

# Updates the apt repository and installs apache2

sudo apt update -y

sudo apt install apache2


# Checks if apache2 is running and if not, it starts the service.

sudo /etc/init.d/apache2 start


# Checks if apache2 is enabled and if not, it enables it.

sudo systemctl enable apache2


# Compresses the log files generated by apache2

TimeCreated=$(date +%d%m%Y-%H%M%S)

sudo tar -zcvf "/tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz" /var/log/apache2/


# Uploads the compressed file to the s3 bucket

sudo aws s3 cp /tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz s3://$s3bucketname/chaitanya-httpd-logs-$TimeCreated.tar


# Storing values to parameters

Type="tar"

Log_Type="httpd-logs"

fileName="/tmp/chaitanya-httpd-logs-$TimeCreated.tar.gz"

mysize=$(find "$fileName" -printf "%s")

# Checking if file available or not; if not available then createing file with headers

if [ ! -f /var/www/html/inventory.html ]
then
    sudo touch /var/www/html/inventory.html
    sudo echo 'Log Type     Time Created      Type    Size' >> /var/www/html/inventory.html
fi

sudo echo $Log_Type ' ' $TimeCreated ' ' $Type '   ' $mysize >> /var/www/html/inventory.html

# Checking if file available or not; if not available then createing file and scheduling cron job

if [ ! -f /etc/cron.d/automation ]
then
    sudo touch /etc/cron.d/automation
fi

echo "30 18 * * * sh /root/Automation_Project/automation.sh" > /etc/cron.d/automation

sudo /usr/bin/crontab /etc/cron.d/automation
