#!/bin/sh
info () {
  echo "[\033[1;34mINFO\033[0m] "$1
}

ok () {
  echo "[\033[1;32m OK \033[0m] "$1
}

warn () {
  echo "[\033[1;31mWARN\033[0m] "$1
}

if ! test -d /tmp/traccar; then
    mkdir /tmp/traccar
else 
    rm -r /tmp/traccar
    mkdir /tmp/traccar
fi

ok "Tmp folder created"

if test -f /opt/traccar/conf/traccar.xml; then
  cp /opt/traccar/conf/traccar.xml /tmp/traccar/
fi

if test -d /opt/traccar/media; then
  cp -r /opt/traccar/media /tmp/traccar/media
fi

if test -d /opt/traccar/logs; then
  cp -r /opt/traccar/logs /tmp/traccar/logs
fi

ok "Backup created"

sudo service traccar stop

sudo systemctl disable traccar.service

sudo rm /etc/systemd/system/traccar.service

sudo systemctl daemon-reload

sudo rm -r /opt/traccar

ok "Old version removed"

./package.sh 5.9.1 linux-64

ok "New installer created"

sudo unzip -o traccar-linux-64-5.9.1.zip -d /tmp/traccar

ok "New version unzipped"

sudo /tmp/traccar/traccar.run

ok "New version installed"

if test -f /tmp/traccar/traccar.xml; then
  sudo mv /tmp/traccar/traccar.xml /opt/traccar/conf/traccar.xml
fi

if test -d /tmp/traccar/media; then
  sudo mv /tmp/traccar/media /opt/traccar/media
fi

if test -d /tmp/traccar/logs; then
  sudo mv /tmp/traccar/logs /opt/traccar/logs
fi

sudo service traccar start