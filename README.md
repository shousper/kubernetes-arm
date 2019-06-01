# kubernetes-arm

> Kubernetes Cluster on ARM64 SBCs

Derived from:

- https://github.com/carlosedp/kubernetes-arm
- https://medium.com/@carlosedp/building-a-hybrid-x86-64-and-arm-kubernetes-cluster-e7f94ff6e51d

## Notes

Designed for static IP cluster with a gateway on `192.168.2.1`. Master node on `192.168.2.10` and worker nodes on `192.168.2.11`, etc.

External DNS names use domain `k8s.mini`.

- 01 - MetalLB load balancer, binds to 192.168.2.16/28
- 02 - Traefik, hard-coded on 192.168.2.20
- 03 - NFS and local storage classes, requires NFS server on master node.
- 04 - Dashboard, standard with no auth.
- 05 - Helm, standard except for arm64 image of tiller.
- 06 - Registry, for local images. Depends a bit on external DNS and/or hosts file entries.
- 07 - MariaDB 3x cluster, fairly custom & questionably hacky?
- 08 - Redis, single instance.
- 09 - NATS, single instance.
- 10 - Consul server, single instance.

The `test` folder has a simple `Dockerfile` to test the `build.sh` that will deploy a docker-in-docker pod to the cluster and remotely copy and execute a docker build and push to the cluster's registry. Finally it has a `pod.yaml` to verify the pushed image can be deployed.

The `deploy.sh` in the root probably shouldn't be trusted.

Some deployments depend on a CA certificate in the root that is already deployed to all your cluster nodes. You can pull the kubernetes CA private key and certificate from a node at `/etc/kubernetes/pki/ca.{key,crt}`, or generate one and install & trust it everywhere yourself (Google it).
