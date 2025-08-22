# TEST YOURSELF: Define Resource Requirements

## Prepare

Deploy the pod:

```
kubectl apply -f load-pod.yaml
```

## Scenario

The pod, `load-pod`, needs to have sensible resource requests and limits set in its configuration. Monitor the resource usage of the pod, then set these resource requirements.

## Solution

1. Use Metrics Server to monitor the resource usage of the pod. Run the command a few times over a minute or so to deterine any resource usage spikes:

```
kubectl top pod load-pod
```

The pod seems to be using about 90m CPU and 90Mi memory.

2. Using the data from the previous step, set requests and limits. The requests should be slightly over the observed metrics, while the requests should be 1.5 to 2 times the metrics defined for the requests:

```
$EDITOR load-pod.yaml
```

```
      resources:
        requests:
          cpu: "90m"
          memory: "90Mi"
        limits:
          cpu: "135m"
          memory: "135Mi"
```

3. Redeploy the pod:

```
kubectl delete -f load-pod.yaml
kubectl apply -f load-pod.yaml
```

4. Confirm the requests and limit have been added:

```
kubectl describe pod load-pod
```

## Cleanup

```
kubectl delete -f load-pod.yaml
```
