#!/bin/bash

echo "Removing bbelcher from kubeconfig..."
kubectl config delete-user bbelcher
kubectl config delete-context bbelcher-context

echo "Removing generated certificates..."
rm -f bbelcher.key bbelcher.csr bbelcher.crt

echo "Cleanup complete for user: bbelcher"
