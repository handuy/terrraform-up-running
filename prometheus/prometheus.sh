#!/bin/bash

apt update -y

wget https://github.com/prometheus/prometheus/releases/download/v2.36.2/prometheus-2.36.2.linux-amd64.tar.gz

tar xvf prometheus-2.36.2.linux-amd64.tar.gz

mkdir -p /etc/prometheus

mkdir -p /var/lib/prometheus

mv ./prometheus-2.36.2.linux-amd64/prometheus ./prometheus-2.36.2.linux-amd64/promtool /usr/local/bin/

mv ./prometheus-2.36.2.linux-amd64/consoles/ ./prometheus-2.36.2.linux-amd64/console_libraries/ /etc/prometheus/

mv ./prometheus-2.36.2.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml

# groupadd --system prometheus

# useradd --no-create-home --shell /bin/false --system -g prometheus prometheus

# chown -R prometheus:prometheus /etc/prometheus/  /var/lib/prometheus/

# chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/ --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries --web.listen-address=0.0.0.0:9090

