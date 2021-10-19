sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y build-essential gcc g++ make libavahi-compat-libdnssd-dev bluetooth bluez libbluetooth-dev libudev-dev


curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

mkdir /home/pi/tilt
cp -r . /home/pi/tilt
cd /home/pi/tilt

npm install

sudo cp tilt.service /etc/systemd/system/tilt.service
sudo systemctl enable tilt.service
sudo systemctl start tilt.service

crontab -l > crondata
echo "*/5 * * * * /usr/bin/sudo -H /home/pi/tilt/checkwifi.sh >> /dev/null 2>&1" >> mycron
crontab crondata
rm crondata
