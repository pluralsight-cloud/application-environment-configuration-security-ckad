# TEST YOURSELF: Understand Authentication, Authorization, and Admission Control

## Prepare

1. Create a backend namespace:

```
kubectl create namespace backend
```

2. Apply the `backend-quotas.yaml` and `backend-limits.yaml` files:

```
kubectl apply -f backend-quotas.yaml -f backend-limits.yaml
```

## Tasks

A pod, `app-pod.yaml`, keep failing with the error `OOMKilled`. Resolve the issue by applying resource requests and limits.

## Solution

1. Deploy the pod and verify the issue:

```
kubectl apply -f app-pod.yaml
kubectl get pods -n backend
```

2. Review the pod's manifest. Note that no requests or limits are defined for the pod:

```
cat app-pod.yaml
```

2. Review the limit range and quotas for the backend namespace. Notice that the default memory limit is 64Mi, which must not be enough for our application pod to succeed:

```
kubectl get quota -n backend
kubectl describe quota backend-quota -n backend

kubectl get limits -n backend
kubectl describe limits backend-limits -n backend
```

3. Working within the parameters defined within the quotas and limit ranges, edit the pod's manifest, adding resource requests and limits:

```
$EDITOR app-pod.yaml
```

```
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
  namespace: backend
spec:
  containers:
    - name: stress
      image: polinux/stress
      command: ["stress"]
      args: ["--vm", "1", "--vm-bytes", "100M", "--vm-hang", "1"]
      resources:
        requests:
          cpu: "100m"
          memory: "64Mi"
        limits:
          cpu: "200m"
          memory: "128Mi"
  restartPolicy: Never
```

4. Save and exit the file. Redeploy the pod:

```
kubectl delete -f app-pod.yaml
kubectl apply -f app-pod.yaml
```

5. Verify the pod is working:

```
kubectl get pods -n backend
```

## Cleanup

Remove the pod, limits, quotas, and namespace:

```
kubectl delete -f app-pod.yaml -f backend-quotas.yaml -f backend-limits.yaml
kubectl delete namespace backend
```

