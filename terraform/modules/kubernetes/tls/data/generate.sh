#!/bin/bash
cd "$(dirname "$0")"

WORKER_PUBLIC_IPS_STRING=$1
WORKER_PRIVATE_IPS_STRING=$2
MANAGER_PUBLIC_IPS_STRING=$3
MANAGER_PRIVATE_IPS_STRING=$4
MANAGER_PUBLIC_ADDRESS=$5
MANAGER_SERVICE_IPS_STRING="10.32.0.1"
CLUSTER_NAME=KUBERNETES_CLUSTER
DESTINATION_DIR=generated
IFS=', ' read -r -a WORKER_PUBLIC_IPS <<< "$WORKER_PUBLIC_IPS_STRING"
IFS=', ' read -r -a WORKER_PRIVATE_IPS <<< "$WORKER_PRIVATE_IPS_STRING"
WORKER_COUNT=${#WORKER_PUBLIC_IPS[@]}

# Generate the CA certificate and private key (ca-key.pem, ca.pem)
cfssl gencert -initca ca-csr.json | cfssljson -bare $DESTINATION_DIR/ca

# Generate the admin client certificate and private key (admin-key.pem, admin.pem)
cfssl gencert \
  -ca=$DESTINATION_DIR/ca.pem \
  -ca-key=$DESTINATION_DIR/ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare $DESTINATION_DIR/admin

# Generate a certificate and private key for each Kubernetes worker node (worker-$i-csr.json, worker-$i-key.pem, worker-$i.pem)
for (( i=0; i<$WORKER_COUNT; i++ )) ; do
    sh create_instance_csr.sh worker-$i > $DESTINATION_DIR/worker-$i-csr.json
    hostname=worker-$i,${WORKER_PUBLIC_IPS[$i]},${WORKER_PRIVATE_IPS[$i]}

    cfssl gencert \
      -ca=$DESTINATION_DIR/ca.pem \
      -ca-key=$DESTINATION_DIR/ca-key.pem \
      -config=ca-config.json \
      -hostname=$hostname \
      -profile=kubernetes \
      $DESTINATION_DIR/worker-$i-csr.json | cfssljson -bare $DESTINATION_DIR/worker-$i
done

# Generate the kube-proxy client certificate and private key (kube-proxy-key.pem, kube-proxy.pem)
cfssl gencert \
  -ca=$DESTINATION_DIR/ca.pem \
  -ca-key=$DESTINATION_DIR/ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare $DESTINATION_DIR/kube-proxy

# Generate the Kubernetes API Server certificate and private key (kubernetes-key.pem, kubernetes.pem)
cfssl gencert \
  -ca=$DESTINATION_DIR/ca.pem \
  -ca-key=$DESTINATION_DIR/ca-key.pem \
  -config=ca-config.json \
  -hostname=$MANAGER_SERVICE_IPS_STRING,$MANAGER_PRIVATE_IPS_STRING,$MANAGER_PUBLIC_IPS_STRING,$MANAGER_PUBLIC_ADDRESS,127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare $DESTINATION_DIR/kubernetes

# Generate a kubeconfig file for each worker node
for (( i=0; i<$WORKER_COUNT; i++ )) ; do
  kubectl config set-cluster $CLUSTER_NAME \
    --certificate-authority=$DESTINATION_DIR/ca.pem \
    --embed-certs=true \
    --server=https://$MANAGER_PUBLIC_ADDRESS:6443 \
    --kubeconfig=$DESTINATION_DIR/worker-$i.kubeconfig

  kubectl config set-credentials system:node:worker-$i \
    --client-certificate=$DESTINATION_DIR/worker-$i.pem \
    --client-key=$DESTINATION_DIR/worker-$i-key.pem \
    --embed-certs=true \
    --kubeconfig=$DESTINATION_DIR/worker-$i.kubeconfig

  kubectl config set-context default \
    --cluster=$CLUSTER_NAME \
    --user=system:node:worker-$i \
    --kubeconfig=$DESTINATION_DIR/worker-$i.kubeconfig

  kubectl config use-context default --kubeconfig=$DESTINATION_DIR/worker-$i.kubeconfig
done

# Generate a kubeconfig file for the kube-proxy service

kubectl config set-cluster $CLUSTER_NAME \
  --certificate-authority=$DESTINATION_DIR/ca.pem \
  --embed-certs=true \
  --server=https://$MANAGER_PUBLIC_ADDRESS:6443 \
  --kubeconfig=$DESTINATION_DIR/kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate=$DESTINATION_DIR/kube-proxy.pem \
  --client-key=$DESTINATION_DIR/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=$DESTINATION_DIR/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=$CLUSTER_NAME \
  --user=kube-proxy \
  --kubeconfig=$DESTINATION_DIR/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=$DESTINATION_DIR/kube-proxy.kubeconfig

