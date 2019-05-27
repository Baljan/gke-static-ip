# gke-static-ip
Utility container that assigns a static IP to a single-machine Kubernetes cluster on Google Kubernetes Engine.

The container will attempt to assign the correct static IP upon start and contains a script `check.sh` that can be used to determine if the IP is valid or not. The Kubernetes deployment for this container should be configured so that the container is restarted as soon as `check.sh` returns a non-zero exit code. This can be accomplished with the following deployment YAML (replace values on the form <VALUE> with an actual value):
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: gke-static-ip
  name: gke-static-ip
spec:
  replicas: 1
  selector:
    matchLabels:
      run: gke-static-ip
  template:
    metadata:
      labels:
        run: gke-static-ip
    spec:
      containers:
      - env:
        - name: INSTANCE_PREFIX
          value: <VM INSTANCE PREFIX (usually gke-cluster-)>
        - name: INSTANCE_ZONE
          value: <INSTANCE ZONE>
        - name: STATIC_IP
          value: <YOUR STATIC IP>
        image: <URL TO IMAGE REGISTRY>
        imagePullPolicy: Always
        name: gke-static-ip
        livenessProbe:
          exec:
            command:
            - /app/check.sh
            initialDelaySeconds: 60
            periodSeconds: 20
```
