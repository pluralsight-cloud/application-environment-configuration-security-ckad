# TEST YOURSELF: Understand Service Accounts

## Prepare

1. Create the ConfigMap and two secrets:

```
kubectl create configmap app-config-test \
  --from-literal=APP_MODE=production \
  --from-literal=LOG_LEVEL=info

kubectl create secret generic db-creds \
  --from-literal=username=admin \
  --from-literal=password=Pa55w0rd!
```

## Scenario

The `cm-checker` pod needs to be able to read ConfigMaps and view the `db-creds` secret, but not any other secrets. Create a service account and role that will enable these actions.

## Solution

1. Create the service account:

```
kubectl create sa config-consumer
```

2. Create a role, ensuring it leverages the rule of least privilege:

```
$EDITOR config-reader-role.yaml
```

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: config-reader-role
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["db-creds"]
  verbs: ["get"]
```

3. Create the role binding:

```
$EDITOR config-reader-binding.yaml
```

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: config-reader-binding
subjects:
- kind: ServiceAccount
  name: config-consumer
  namespace: default
roleRef:
  kind: Role
  name: config-reader-role
  apiGroup: rbac.authorization.k8s.io
```

4. Apply the role and binding:

```
kubectl apply -f config-reader-role.yaml -f config-reader-binding.yaml
```

5. Update the `cm-checker.yaml` manifest to use the newly-created service account:

```
$EDITOR cm-checker.yaml
```

```
spec:
  serviceAccountName: config-consumer
```

6. Deploy the pod:

```
kubectl apply -f cm-checker.yaml
```

7. Verify the service account provided the correct access by viewing the container logs for the pod. Each should return `yes`:

```
kubectl logs cm-checker -c cm-can-i
kubectl logs cm-checker -c secret-can-i
```

## Cleanup

```
kubectl delete -f cm-checker.yaml -f config-reader-binding.yaml -f config-reader-role.yaml
kubectl delete sa config-consumer
kubectl delete secret db-creds
kubectl delete cm app-config-test
```
