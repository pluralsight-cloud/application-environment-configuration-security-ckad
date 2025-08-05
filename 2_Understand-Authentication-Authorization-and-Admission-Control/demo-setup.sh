# Create private key
openssl genrsa -out bbelcher.key 2048

# Create certificate signing request with CN and O
openssl req -new -key bbelcher.key -out bbelcher.csr \
  -subj "/CN=bbelcher/O=backend-engineers"

# Sign the certificate using the cluster’s CA
openssl x509 -req -in bbelcher.csr \
  -CA /etc/kubernetes/pki/ca.crt \
  -CAkey /etc/kubernetes/pki/ca.key \
  -CAcreateserial \
  -out bbelcher.crt -days 365

# Add the user to kubeconfig
kubectl config set-credentials bbelcher \
  --client-certificate=bbelcher.crt \
  --client-key=bbelcher.key \
  --embed-certs=true

# Add a context using that user
kubectl config set-context bbelcher-context \
  --cluster=$(kubectl config current-context) \
  --user=bbelcher \
  --namespace=default
