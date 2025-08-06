# TEST YOURSELF: Understand Authentication, Authorization, and Admission Control

## Prepare

1. Create a development namespace:

```
kubectl create namespace development
```

2. Assume the following subjects exist:
    - A user named `cchen`
    - A group named `qa-team`

> You don’t need to create these users, but you'll assign permissions to them via RBAC.

## Tasks

The development namespace will be used by two separate roles:
    - The QA team (qa-team group) needs read-only access to the following resources:
        - Pods
        - Jobs
        - ConfigMaps
    - A developer named `cchen` needs full access (read/write) to the following resources:
            - ConfigMaps
            - Secrets
            - Services

Create and apply roles and rolebindings to grant these access levels only within the development namespace.

## Solution

1. Create the read-only role for QA:

```
kubectl create role qa-readonly \
  --verb=get,list,watch \
  --resource=pods,jobs,configmaps \
  --namespace=development \
  --dry-run=client -o yaml > qa-readonly-role.yaml
```

2. Create a full-access role for `cchen`:

```
kubectl create role dev-fullaccess \
  --verb=get,list,watch,create,update,patch,delete \
  --resource=configmaps,secrets,services \
  --namespace=development \
  --dry-run=client -o yaml > dev-fullaccess-role.yaml
```

3. Create the RoleBinding for the `qa-team` group:

```
kubectl create rolebinding qa-readonly-binding \
  --role=qa-readonly \
  --group=qa-team \
  --namespace=development \
  --dry-run=client -o yaml > qa-readonly-binding.yaml
```

4. Create the RoleBinding for the `cchen` user:

```
kubectl create rolebinding dev-fullaccess-binding \
  --role=dev-fullaccess \
  --user=cchen \
  --namespace=development \
  --dry-run=client -o yaml > dev-fullaccess-binding.yaml
```

5. Apply the manifests:

```
kubectl apply -f qa-readonly-role.yaml -f dev-fullaccess-role.yaml -f qa-readonly-binding.yaml -f dev-fullaccess-binding.yaml
```

## Cleanup

Remove the roles, bindings, and namespace:

```
kubectl delete -f qa-readonly-role.yaml -f dev-fullaccess-role.yaml -f qa-readonly-binding.yaml -f dev-fullaccess-binding.yaml
kubectl delete namespace development
```

