# 05. CI/CD GitHub Actions Specification

## Overview

This specification details the architecture and implementation of Continuous Integration and Continuous Deployment (CI/CD) pipelines for the Horta project using **GitHub Actions**.

To achieve maximum security, these pipelines use **Workload Identity Federation (WIF)** instead of long-lived Service Account JSON keys. This allows GitHub Actions to securely impersonate a Google Cloud Service Account using short-lived OIDC tokens.

**Target GCP Project:** `horta-495401`

---

## 1. Security Architecture (Workload Identity Federation)

### 1.1 Why WIF?
Storing long-lived Service Account JSON keys as GitHub Secrets poses a significant security risk. Workload Identity Federation replaces this by trusting the GitHub Actions OIDC provider.

### 1.2 Required GCP Infrastructure Setup
Run the following commands in your local terminal (authenticated as a GCP administrator) to set up the secure foundation:

#### A. Create the Service Account
This service account will be impersonated by GitHub Actions.
```bash
gcloud iam service-accounts create github-actions-sa \
  --display-name="GitHub Actions Deployer" \
  --project="horta-495401"
```

#### B. Grant Necessary Roles
```bash
# For deploying to Cloud Run
gcloud projects add-iam-policy-binding "horta-495401" \
  --member="serviceAccount:github-actions-sa@horta-495401.iam.gserviceaccount.com" \
  --role="roles/run.developer"

gcloud projects add-iam-policy-binding "horta-495401" \
  --member="serviceAccount:github-actions-sa@horta-495401.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# For pushing Docker images to Artifact Registry
gcloud projects add-iam-policy-binding "horta-495401" \
  --member="serviceAccount:github-actions-sa@horta-495401.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

# For deploying to Firebase Hosting
gcloud projects add-iam-policy-binding "horta-495401" \
  --member="serviceAccount:github-actions-sa@horta-495401.iam.gserviceaccount.com" \
  --role="roles/firebasehosting.admin"
```

#### C. Create Workload Identity Pool and Provider
```bash
# Enable API
gcloud services enable iamcredentials.googleapis.com --project="horta-495401"

# Create Pool
gcloud iam workload-identity-pools create "github-actions-pool" \
  --project="horta-495401" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# Create Provider
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project="horta-495401" \
  --location="global" \
  --workload-identity-pool="github-actions-pool" \
  --display-name="GitHub Actions Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

#### D. Bind the GitHub Repo to the Service Account
*(Replace `lucasbatista/horta.dev` with your actual GitHub username/repo)*
```bash
gcloud iam service-accounts add-iam-policy-binding "github-actions-sa@horta-495401.iam.gserviceaccount.com" \
  --project="horta-495401" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-actions-pool/attribute.repository/lucasbatista/horta.dev"
```
*(You can find your Project Number by running `gcloud projects describe horta-495401`)*

#### E. Create the Artifact Registry (for Golang API)
```bash
gcloud artifacts repositories create horta-repo \
  --repository-format=docker \
  --location=us-central1 \
  --description="Docker repository for Horta API" \
  --project=horta-495401
```

---

## 2. GitHub Secrets Configuration

In your GitHub repository, navigate to **Settings > Secrets and variables > Actions**, and add the following **Secrets**:

| Secret Name | Example Value / Source | Description |
| :--- | :--- | :--- |
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | `projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-actions-pool/providers/github-provider` | The full identifier of the WIF Provider. |
| `GCP_SERVICE_ACCOUNT` | `github-actions-sa@horta-495401.iam.gserviceaccount.com` | The email of the service account created above. |

---

## 3. Workflow Definitions (`.github/workflows`)

### 3.1 Golang API Pipeline (Cloud Run)
**Path:** `.github/workflows/deploy-api.yml`

```yaml
name: Deploy API to Cloud Run

on:
  push:
    branches:
      - main
    paths:
      - 'horta-api/**'
      - '.github/workflows/deploy-api.yml'

env:
  PROJECT_ID: horta-495401
  REGION: us-central1
  REPOSITORY: horta-repo
  SERVICE: horta-api

# Required permissions for Workload Identity Federation
permissions:
  contents: read
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./horta-api

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Authenticate to Google Cloud
        id: auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v2

      - name: Configure Docker for Artifact Registry
        run: gcloud auth configure-docker ${{ env.REGION }}-docker.pkg.dev

      - name: Build and Push Docker Image
        run: |
          IMAGE="${{ env.REGION }}-docker.pkg.dev/${{ env.PROJECT_ID }}/${{ env.REPOSITORY }}/${{ env.SERVICE }}:${{ github.sha }}"
          docker build -t $IMAGE .
          docker push $IMAGE

      - name: Deploy to Cloud Run
        run: |
          IMAGE="${{ env.REGION }}-docker.pkg.dev/${{ env.PROJECT_ID }}/${{ env.REPOSITORY }}/${{ env.SERVICE }}:${{ github.sha }}"
          gcloud run deploy ${{ env.SERVICE }} \
            --image $IMAGE \
            --region ${{ env.REGION }} \
            --project ${{ env.PROJECT_ID }} \
            --allow-unauthenticated \
            --max-instances 2 \
            --min-instances 0 \
            --concurrency 80
```

### 3.2 Flutter Platform Pipeline (Firebase Hosting)
**Path:** `.github/workflows/deploy-web.yml`

```yaml
name: Deploy Web to Firebase Hosting

on:
  push:
    branches:
      - main
    paths:
      - 'horta-platform/**'
      - '.github/workflows/deploy-web.yml'

env:
  PROJECT_ID: horta-495401

# Required permissions for Workload Identity Federation
permissions:
  contents: read
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./horta-platform

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Build Web App
        run: flutter build web --release

      - name: Authenticate to Google Cloud
        id: auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Firebase CLI
        run: npm install -g firebase-tools

      - name: Deploy to Firebase Hosting
        run: firebase deploy --only hosting --project ${{ env.PROJECT_ID }}
```
