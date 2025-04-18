# gke-cluster
1) Enable required services
```
gcloud services enable iamcredentials.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```
2) Create IAM identity Pool
gcloud iam workload-identity-pools create github-pool \
  --project=YOUR_PROJECT_ID \
  --location=global \
  --display-name="GitHub Pool"
3) Create Identity Provider
gcloud iam workload-identity-pools providers create-oidc github-provider \
  --project=sandbox-dev-dbg \
  --location=global \
  --workload-identity-pool=github-pool \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.ref=assertion.ref" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-condition="attribute.repository_owner=='your-github-org' && attribute.repository=='your-repo-name'"
4) Create service account
gcloud iam service-accounts create terraform-deployer \
  --project=YOUR_PROJECT_ID \
  --display-name="Terraform Deployer"
5) Add permission to the service account
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:terraform-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/owner"
6) Allow github to impersonate the service account
gcloud iam service-accounts add-iam-policy-binding terraform-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com \
  --project=YOUR_PROJECT_ID \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/YOUR_GITHUB_ORG/YOUR_REPO"
