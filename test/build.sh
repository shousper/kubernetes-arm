#!/usr/bin/env bash
set -e

ns=default

# Remove old pod, if it exists, create new one and wait for it to become ready.
kubectl -n $ns delete pod dind || true
kubectl -n $ns create -f dind.yaml
while ! kubectl -n $ns get pod dind | grep Running; do
    kubectl -n $ns get pod dind | tail -1
    sleep 1
done

# Copy current path into build folder
kubectl -n $ns cp . dind:/mnt/build

# Build image and push it to the registry
name=$(basename $(pwd))
image_name="registry.k8s.mini/${name}"
image_tag="${image_name}:latest"
kubectl -n $ns exec dind -- sh -c "cd /mnt/build && docker build -t ${image_tag} . && docker push ${image_tag}"
