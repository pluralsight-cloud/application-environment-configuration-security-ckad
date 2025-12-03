# TEST YOURSELF: Understand Service Accounts

## Prepare

1. Create the namespace:

```
kubectl create ns staging-test
```

## Scenario

Set up the PodSecurityAdmission on the `staging-test` namespace so that it is enforcing baseline security while warning about restrictive security options.

Attempt to run the `app-one-pod`. Update the manifest so it does not violate any enforced pod security options.

Update the `app-two-pod` to disable privilege escalation for its container and use the seccomp profile `RuntimeDefault`. Run the pod, noting the warnings. Copy the manifest to a new file `app-two-restricted` and resolve the issues in the deployment for restricted environments.

## Solution

1. Label the `staging-test` namespace with the appropriate PodSecurityAdmission labelings:

```
kubectl label namespace staging-test \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/warn=restricted
```

2. Confirm the labels were added:

```
kubectl get ns staging-test --show-labels
```

3. Attempt to deploy the `app-one-pod`:

```
kubectl apply -f app-one-pod.yaml
```

4. Make note of the issues with the pod:
    - `NET_ADMIN` capability should not be used
    - `hostPID=true` cannot be used
    - `privileged` cannot be set to true

5. Update the manifest to remove these parameters:

```
$EDITOR app-one-pod.yaml
```

6. Save and deploy the pod:

```
kubectl apply -f app-one-pod.yaml
```

Note that the pod was deployed despite now outputting restricted-level warnings.

7. Deploy the `app-two-pod`:

```
kubectl apply -f app-two-pod.yaml
```

8. Note the warnings for the restricted mode:
    - Capabilities must be set to drop ALL
    - `runAsNonRoot` must be true
    - `seccompProfile` must be set to `RuntimeDefault` or `Localhost`

9. Copy the manifest to `app-two-restricted.yaml`:

```
cp app-two-pod.yaml app-two-restricted.yaml
```

10. Update the pod definition to resolve the warnings given. You will also need to change the metadata name:

```
$EDITOR app-two-restricted.yaml
```

```
apiVersion: v1
kind: Pod
metadata:
  name: app-two-restricted
  namespace: staging-test
spec:
  containers:
  - name: app-two
    image: busybox:1.36
    command: ["sh","-c"]
    args:
      - |
        echo "UID: $(id -u) GID: $(id -g)";
        echo "Sleeping...";
        sleep 3600
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
      seccompProfile:
        type: RuntimeDefault
      runAsNonRoot: true
```

11. Save and exit. Apply the manifest:

```
kubectl apply -f app-two-restricted.yaml
```

There should be no warnings.

## Cleanup

```
kubectl delete -f app-one-pod.yaml -f app-two-pod.yaml -f app-two-restricted.yaml
kubectl delete ns staging-test
```
