VCLUSTER_A="orders-vcluster"
VCLUSTER_B="products-vcluster"

echo "Cleaning up (destroying) vclusters and deployed apps..."

# Delete Application Set controlling apps
echo "Deleting Application Set controlling apps..."
kubectl delete -f app-git-generator-files.yaml 

# Delete Application Set controlling vclusters
echo "Deleting Application Set controlling vclusters..."
kubectl delete -f cluster-git-generator-files.yaml 

# Delete secrets for vclusters, and then remove local files
echo "Deleting secret manifests for vclusters..."

kubectl delete -f $VCLUSTER_A.yaml,$VCLUSTER_B.yaml
rm -rf $VCLUSTER_A.yaml
rm -rf $VCLUSTER_B.yaml

# Delete vcluster namespace
echo "Deleting vcluster namespace..."
kubectl delete ns vcluster

# Unset environment variables
unset VCLUSTER_A
unset VCLUSTER_B
unset EKS_CLUSTER_NAME
unset EKS_REGION

echo "All cleaned up :)"

