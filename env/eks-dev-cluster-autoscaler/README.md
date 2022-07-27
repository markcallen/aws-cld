# EKS Dev Cluster Autoscaler
Contains the detail to setup autscaler for dev cluster

Before running terraform make sure that current workspace is `dev`. Switch to workspace by following commands
```
terraform init
terraform workspace select dev
```
Plan and apply changes 
```
terraform init
terraform plan
terraform apply
```
## Cluster Autoscaler Menifest files changes and implementation 

Make follwing Changes in dev-autoscaler/cluster-autoscaler-autodiscover.yaml
#### Change1. 
Add Role arn created in above stage
```
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-addon: cluster-autoscaler.addons.k8s.io
    k8s-app: cluster-autoscaler
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::xxxxx:role/Amazon_CA_role
  name: cluster-autoscaler
  namespace: kube-system
```
#### Change2. 
Set the EKS cluster name (awsExampleClusterName) and environment variable (us-east-1) based on the following example.
```
spec:
      serviceAccountName: cluster-autoscaler
      containers:
        - image: gcr.io/google-containers/cluster-autoscaler:v1.14.6     #cluster-autoscaler image
          name: cluster-autoscaler
          resources:
            limits:
              cpu: 100m
              memory: 300Mi
            requests:
              cpu: 100m
              memory: 300Mi
          command:
            - ./cluster-autoscaler
            - --v=4
            - --stderrthreshold=info
            - --cloud-provider=aws
            - --skip-nodes-with-local-storage=false
            - --expander=least-waste
            - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<<awsExampleClusterName>>
          env:
            - name: AWS_REGION
              value: <<us-east-1>>
```

## Autoscaler Testing
To verify that autoscaler working, can scale up one of the application.e.g
```
kubectl scale deployment nval-webapp --replicas=50 -n nval-app
```
Above command will create 50 pods of nval-webapp, as the number of pods increases the cluster should scale up by adding more nodes in cluster and can be verified by checking number of nodes
```
kubectl get nodes
```
Verify all 50 pods are up

```
kubectl get pods -n nval-app | grep 'nval-webapp'
```
