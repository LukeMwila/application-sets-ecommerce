### Prerequisites
## Infrastructure: Amazon EKS cluster (host cluster)
## Applications: Argocd deployed to host cluster
## CLI tools: AWS CLI, kubectl, vcluster CLI

VCLUSTER_A="orders-vcluster"
VCLUSTER_B="products-vcluster"
EKS_CLUSTER_NAME="alpha"
EKS_REGION="eu-west-1"

# Connect to host EKS cluster (with argocd)
aws eks --region $EKS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME

# Create Application Set for vclusters
kubectl apply -f cluster-git-generator-files.yaml

# Wait for vclusters to start up
sleep 3m

# Connect to virtual clusters, fetch argocd admin sa tokens, populate manifest template for Argocd cluster secret and deploy
helm template $VCLUSTER_A ./argocd-add-cluster --set vcluster_name=$VCLUSTER_A \
--set argocd_admin_sa_token=$(vcluster connect -s $VCLUSTER_A -- kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='argocd-admin')].data.token}" -n vcluster-system | base64 --decode) \ 
| kubectl apply -f -

helm template $VCLUSTER_B ./argocd-add-cluster --set vcluster_name=$VCLUSTER_B \
--set argocd_admin_sa_token=$(vcluster connect -s $VCLUSTER_B -- kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='argocd-admin')].data.token}" -n vcluster-system | base64 --decode) \ 
| kubectl apply -f -

# Create Application Set for apps to be deployed to vclusters
kubectl apply -f app-git-generator-files.yaml