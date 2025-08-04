# TEST YOURSELF: Understand API Deprecations

## Prepare

1. Deploy the **FeatureFlag** CRD:

```
kubectl apply -f featureflag-crd.yaml
```

## Tasks

A custom API that manages Feature Flags in applications uses the custom resource definition provided in `featureflag-crd.yaml`. It is currently in `v1alpha1`, but a new version, `v1beta1` needs to be prepared for launch. This should be the new storage version.

Update the CRD for the new version, including addition two additional fields: 

- `owner` (string), which should indicate the team responsible for the feature
- `rolloutStrategy` (enum), which should define a rollout strategy of either `Cenary` or `BlueGreen`.

Apply the CRD and test it by creating a FeatureFlag resource.

## Solutions

1. Review the existing CRD at `featureflag-crd.yaml`. Notice that version `v1alpha1` has a single required field, `enabled`, as well as a `description` field. The `v1alpha1` version is enabled, and is also the storage version.

2. Using `v1alpha1` as a basis, create a second version, `v1beta1`, including the new data fields. Ensure it is the new storage version, and `v1alpha1` has the storage version disabled:

```
    - name: v1alpha1
      served: true
      storage: false
```

`...`

```
    - name: v1beta1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              required:
                - enabled
                - owner
              properties:
                enabled:
                  type: boolean
                description:
                  type: string
                owner:
                  type: string
                rolloutStrategy:
                  type: string
                  enum:
                    - Canary
                    - BlueGreen
```

2. Apply the updated manifest:

```
kubectl apply -f featureflag-crd.yaml
```

3. Create a test resource, `feature-test.yaml`, to set the new version:

```
$EDITOR feature-test.yaml
```

```
apiVersion: platform.example.com/v1beta1
kind: FeatureFlag
metadata:
  name: dark-mode-ui
spec:
  enabled: true
  description: Enables dark mode in the web UI
  owner: frontend-team
  rolloutStrategy: BlueGreen
```

4. Apply the resource:

```
kubectl apply -f feature-test.yaml
```

5. Confirm the addition of the resource:

```
kubectl get ff
```

## Cleanup

Remove the resource and CRD:

```
kubectl delete -f feature-test.yaml
kubectl delete -f featureflag-crd.yaml
```
