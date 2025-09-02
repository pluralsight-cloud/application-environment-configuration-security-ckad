# TEST YOURSELF: Define Resource Requirements

## Scenario

The pod, `secret-pod`, needs to consume secure credentials found in the `secure-pod.env` file. Additionally, it needs to be set up to use the Docker registry using the following values:

- Docker Username: testuser
- Docker Password: testpassword
- Docker Email: testemail@example.pluralsight.com
- Docker Server: testregistry.example.pluralsight.com

Create the needed objects and update the pod to leverage this secure data.

## Solution

1. Create the secrets object for the username and password values found in the `secure-pod.env` file:

```
kubectl create secret generic db-credentials --from-literal=username=admin --from-literal=password=Pa55w0rd!
```

2. Create the Docker registry-based secret using the `docker-registry` secrets object type:

```
kubectl create secret docker-registry example-ps-registry \ 
--docker-username=testuser \
--docker-password=testpassword \
--docker-email=testemail@example.pluralsight.com \
--docker-server=testregistry.example.pluralsight.com
```

3. Confirm the secrets were added:

```
kubectl get secrets
kubectl describe secret example-ps-registry
kubectl descrube secret db-credentials
```

4. Update the `secure-pod` manifest to use the `db-credential` secrets object:

```
$EDITOR secure-pod.yaml
```

```
    envFrom:
      - secretRef:
          name: db-credentials
```

5. Likeway, update it to use the provided Docker registry with the `imagePullSecrets` parameter:

```
  imagePullSecrets:
    - name: example-ps-registry
```

6. Save and exit. Deploy the pod:

```
kubectl apply -f secure-pod.yaml
```

6. Confirm the secrets were added:

```
kubectl logs secure-pod
```

## Cleanup

```
kubectl delete -f secure-pod.yaml
kubectl delete secret example-ps-registry
kubectl delete secret db-credentials
```
