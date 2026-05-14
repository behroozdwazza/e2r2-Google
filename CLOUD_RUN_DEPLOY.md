# Deploying the E2R2 Streamlit App to Google Cloud Run

This guide assumes the app is already in a GitHub repository.

## What Cloud Run Does

Google Cloud Run runs this Streamlit app inside a container. Compared with Streamlit Cloud, it lets you choose more memory, CPU, timeout length, and how many users can run heavy analyses at the same time.

Recommended starting settings for this app:

- Region: `us-central1`
- Memory: `4 GiB`
- CPU: `2`
- Request timeout: `1800 seconds` (30 minutes)
- Concurrency: `1`
- Minimum instances: `0`
- Maximum instances: `1` for cost control, or `2` if two colleagues may use it at the same time

## Files Added for Cloud Run

- `Dockerfile`: tells Google how to build and start the Streamlit app.
- `.dockerignore`: keeps local outputs, Excel files, logs, and secrets out of the deployed container.

## One-Time Google Cloud Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/).
2. Create or select a Google Cloud project.
3. Make sure billing is enabled for the project.
4. Open **APIs & Services > Enabled APIs & services**.
5. Enable these APIs if Google asks for them during deployment:
   - Cloud Run API
   - Cloud Build API
   - Artifact Registry API

## Easiest Deployment Path: Cloud Run from GitHub

1. Open [Cloud Run](https://console.cloud.google.com/run).
2. Click **Deploy container**.
3. Choose **Continuously deploy from a repository**.
4. Connect your GitHub account if prompted.
5. Select the E2R2 repository.
6. Select the branch you want to deploy, usually `main`.
7. For build type, choose **Dockerfile**.
8. Confirm that the Dockerfile path is:

   ```text
   Dockerfile
   ```

9. Service name:

   ```text
   e2r2-app
   ```

10. Region:

   ```text
   us-central1
   ```

11. Authentication:

   Choose **Allow unauthenticated invocations** if you want colleagues to open the app with a link.

12. Expand **Container(s), Volumes, Networking, Security**.
13. Under the container settings, set:

   ```text
   Container port: 8080
   Memory: 4 GiB
   CPU: 2
   Request timeout: 1800 seconds
   ```

14. Under scaling, set:

   ```text
   Minimum number of instances: 0
   Maximum number of instances: 1
   Concurrency: 1
   ```

15. Click **Create** or **Deploy**.

After deployment finishes, Google Cloud Run will show a service URL. Share that URL with your colleagues.

## Optional: Store the OpenAI API Key as a Secret

The app currently allows users to paste their own OpenAI API key. That is the simplest option for shared research testing.

If you want the deployed app to use one shared key instead:

1. Open your Cloud Run service.
2. Click **Edit & deploy new revision**.
3. Go to **Variables & Secrets**.
4. Add an environment variable:

   ```text
   Name: OPENAI_API_KEY
   Value: your OpenAI API key
   ```

5. Deploy the new revision.

Only do this if you are comfortable paying for colleagues' API usage from that key.

## Command-Line Deployment Alternative

If you install the Google Cloud CLI, you can deploy from the repository folder with:

```powershell
gcloud run deploy e2r2-app `
  --source . `
  --region us-central1 `
  --allow-unauthenticated `
  --memory 4Gi `
  --cpu 2 `
  --timeout 1800 `
  --concurrency 1 `
  --max-instances 1
```

## If the App Still Crashes

Try these in order:

1. Increase memory from `4 GiB` to `8 GiB`.
2. Keep concurrency at `1`.
3. Keep max instances at `1` until you understand cost.
4. Reduce SHAP sample size or the number of cases in the uploaded dataset.
5. Move generated outputs to cloud storage instead of keeping large results in memory.

## Cost Control Tips

- Keep **minimum instances** at `0` so the app can scale to zero when nobody is using it.
- Keep **maximum instances** at `1` while testing.
- Add a billing alert in Google Cloud Billing.
- Ask colleagues to use their own OpenAI API keys unless you want one shared project key.
