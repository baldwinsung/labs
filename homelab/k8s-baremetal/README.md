# Kubernetes Bare Metal Home Lab
Created a k8s bare metal home lab on older Apple Macbook Air, Apple Macbook Pro and Lenovo Thinkpad X1 hardware running Ubuntu 20.04 using Kubernetes v1.20.2.

Leverages MetalLB for load balancing.

Referenced guides from Digital Ocean and Computing for Geeks.

## Cluster Components
- 1 x Master Node
- 2 x Worker Nodes
- 1 x Machine outside of cluster

## Setup
Run the following from a machine outside of the cluster.

```
ansible-playbook -i hosts kube-dependencies.yml --become --ask-become-pass
ansible-playbook -i hosts master.yml --become --ask-become-pass

# make sure /root/node_joined.txt is not present if k8s worker nodes were reset using kubeadm reset
ansible -i hosts workers -m shell -a "rm /root/node_joined.txt" --become --ask-become-pass
ansible-playbook -i hosts workers.yml --become --ask-become-pass

# manage remote cluster
kubectl config view
mkdir ~/.kube
ansible -i hosts masters -m fetch -a "src=/root/.kube/config dest=$HOME/.kube/config flat=yes" --become --ask-become-pass
kubectl config view
kubectl get nodes

### add in bare-metal ingress
# https://metallb.universe.tf/installation/ 
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

cat > metallb_layer2.yml << EOF_METAL
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.1.240-192.168.1.250
EOF_METAL

kubectl apply -f metallb_layer2.yml

# deploy baremetal ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml
kubectl get all -n ingress-nginx

# deploy nginx pod
kubectl create deployment nginx --image=nginx
kubectl expose deploy nginx --port 80 --target-port 80 --type LoadBalancer
kubectl get services -o wide
kubectl get pods -o wide
```

## Scaling, Testing & Verification
...

```
# scale up down nginx replicas
kubectl get replicasets -o wide
kubectl scale --replicas=30 deployment nginx
kubectl scale --replicas=15 deployment nginx
kubectl scale --replicas=0 deployment nginx
kubectl get replicasets -o wide
kubectl get pods -o wide
kubectl get services -o wide

# reboot one node to see results
ansible -i hosts workers -l worker1  -m shell -a "reboot" --become --ask-become-pass
ansible -i hosts workers -l worker2  -m shell -a "reboot" --become --ask-become-pass

# drain node to test
kubectl drain worker1 --ignore-daemonsets --delete-local-data
kubectl get nodes

# troubleshoot nodes
# STATUS = NotReady
# not pingable
ansible -i hosts workers -l worker1 -m shell -a "journalctl -u kubelet" --become --ask-become-pass

# add node back
# STATUS = Ready,SchedulingDisabled
kubectl uncordon worker2

# use ab to test load balancing
watch ab -n 10 -c 10 http://192.168.1.240/

# check logs with running ab
kubectl logs --prefix -l app=nginx --max-log-requests=15 -f
```

## Destroying
...

```
# destroy deployments to reproduce setup
kubectl get deployments -o wide
kubectl delete service nginx
kubectl get services -o wide
kubectl delete deployment nginx
kubectl get deployments -o wide

# destroy everything
# kubeadm reset needs to be run on all nodes - master and workers
kubeadm reset
rm -rf /etc/cni/net.d
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

mkdir /root-backup
cp -fRp /root /root-backup/.
```

# References from:
- [https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-18-04]()

- [https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/]()
