### Prerequisites
## Infrastructure: Amazon EKS cluster (host cluster)
## Applications: Argocd deployed to host cluster
## CLI tools: AWS CLI, kubectl, vcluster CLI

VCLUSTER_A="orders-vcluster"
VCLUSTER_B="products-vcluster"
EKS_CLUSTER_NAME="alpha"
EKS_REGION="eu-west-1"

echo "Starting script execution for vcluster and apps creation with ArgoCD..."

# Connect to host EKS cluster (with argocd)
echo "Connecting to host EKS cluster..."
aws eks --region $EKS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME

# Create namespace on host cluster where vclusters will live
echo "Creating namespace for virtual clusters..."
kubectl create ns vcluster

# Create Application Set for vclusters
kubectl apply -f vcluster-appset.yaml

# Wait for vclusters to start up
echo "Waiting for vclusters to start up..."
sleep 2m

echo "Vclusters are up and running. Continuing with script execution..."

# Add vclusters to ArgoCD
# Connect to virtual clusters, fetch argocd admin sa tokens, populate manifest template for Argocd cluster secret and deploy
helm template $VCLUSTER_A ./argocd-add-cluster --set vcluster_name=$VCLUSTER_A \
--set argocd_admin_sa_token=$(vcluster connect -s $VCLUSTER_A -- kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='argocd-admin')].data.token}" -n vcluster-system | base64 --decode) > $VCLUSTER_A.yaml

helm template $VCLUSTER_B ./argocd-add-cluster --set vcluster_name=$VCLUSTER_B \
--set argocd_admin_sa_token=$(vcluster connect -s $VCLUSTER_B -- kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='argocd-admin')].data.token}" -n vcluster-system | base64 --decode) > $VCLUSTER_B.yaml

echo "Vcluster secret manifests for ArgoCD have been created. Deploying to Argocd now..."

kubectl apply -f $VCLUSTER_A.yaml,$VCLUSTER_B.yaml

# Create Application Set for apps to be deployed to vclusters
kubectl apply -f application-appset.yaml

echo "The virtual development clusters ($VCLUSTER_A, $VCLUSTER_B) are ready, and the respective applications have been deployed by ArgoCD :)"