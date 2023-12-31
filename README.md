# PrintCam

Check for camera
—————————
libcamera-hello


/boot/config.txt
————————
gpu_mem=256


Packages
—————-
sudo apt update
sudo apt install git
sudo apt-get install imagemagick


Install Streamer
https://github.com/ayufan/camera-streamer
————————
git clone https://github.com/ayufan-research/camera-streamer.git --recursive
sudo apt-get -y install libavformat-dev libavutil-dev libavcodec-dev libcamera-dev liblivemedia-dev v4l-utils pkg-config xxd build-essential cmake libssl-dev

cd camera-streamer/


Add html/camera.html
Replace cmd/camera-streamer/http.c

make
sudo make install

Add service/camera-streamer-printercam.service


Start Service
————————
sudo systemctl enable $PWD/service/camera-streamer-printercam.service
sudo systemctl start camera-streamer-printercam
sudo systemctl stop camera-streamer-printercam

Status
———
journalctl -xef -u camera-streamer-printercam



tmp as ramdisk
--------------
sudo nano /etc/fstab
Add:
tmpfs /tmp tmpfs rw,nosuid,noatime,nodev,size=256M,mode=1777 0 0



Prusa Connect
----------------

Add uploadsnapshots.sh to home directory


Permissions
------------------
Make file executable

chmod +x filename.ext 


startlight.sh
——————
#!/bin/bash

echo 10 >/sys/class/gpio/export
echo out >/sys/class/gpio/gpio10/direction
echo 1 >/sys/class/gpio/gpio10/value



crontab -e
-------------
@reboot /home/randy/uploadsnapshots.sh >> /home/randy/snapshots.log 2>&1

Create log files:
echo > snapshots.log
