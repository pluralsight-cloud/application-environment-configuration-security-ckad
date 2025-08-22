# TEST YOURSELF: Understand ConfigMaps

## Prepare

Deploy the pod:

```
kubectl apply -f runner-pod.yaml
```

## Tasks

A pod, `runner-pod` is failing upon deployment due to a missing startup script and environmental variables. Using ConfigMaps, mount the script and pull in the variables.

## Solution

1. Create a ConfigMap based on the variables provided in `env.yaml`:

```
kubectl create configmap runner-config --from-env-file=env.yaml
```

2. Create a ConfigMap based on the `start.sh` script:

```
kubectl create configmap runner-startup-script --from-file=start.sh 
```

3. Confirm the ConfigMaps were created:

```
kubectl get cm
kubectl describe cm runner-config
kubectl describe cm runner-startup-script
```

4. Update the pod manifest to leverage these ConfigMaps. Note that you will also have to add a volume mount for the volume-based mapping to work properly:

```
$EDITOR runner-pod.yaml
```

```
      envFrom:
        - configMapRef:
            name: runner-config
      volumeMounts:
        - name: startup
          mountPath: /scripts
          readOnly: true
  volumes:
    - name: startup
      configMap:
        name: runner-startup-script
        defaultMode: 0755
```

5. Redeploy the pod:

```
kubectl delete -f runner-pod.yaml
kubectl apply -f runner-pod.yaml
```

6. Confirm that everything is working:

```
kubectl get pods
kubectl logs runner-pod
```

## Cleanup

```
kubectl delete -f runner-pod.yaml
kubectl delete cm runner-config
kubectl delete cm runner-startup-script
```
