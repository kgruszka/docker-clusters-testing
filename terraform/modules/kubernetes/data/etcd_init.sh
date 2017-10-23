#!/bin/bash
NODE_IP="${IP}"
HOSTNAME="${HOSTNAME}"
CLUSTER="${CLUSTER}"
TOKEN="${TOKEN}"
NODE_NAME=$(hostname -s)

ETCD_VER=v3.2.8

DOWNLOAD_URL=https://github.com/coreos/etcd/releases/download

# cleanup

rm -f /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd

# download & unpack etcd binaries

curl -L $DOWNLOAD_URL/$ETCD_VER/etcd-$ETCD_VER-linux-amd64.tar.gz -o /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz
tar xzvf /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1

sudo mv /tmp/etcd/etcd* /usr/local/bin/

# Configure the etcd Server

sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

# Create the etcd.service systemd unit file

cat > etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name=$HOSTNAME \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://$NODE_IP:2380 \\
  --listen-peer-urls https://$NODE_IP:2380 \\
  --listen-client-urls https://$NODE_IP:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls https://$NODE_IP:2379 \\
  --initial-cluster $CLUSTER \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd \\
  --initial-cluster-token $TOKEN
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Start the etcd Server

sudo mv etcd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd





