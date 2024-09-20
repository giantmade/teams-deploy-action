# MS Teams Deployment Notification Action

This GitHub Action sends a notification to a Microsoft Teams channel when a deployment is initiated.

It provides information about the repository, branch, initiator, and optionally, a deployment URL. The notification message is customizable.

## Inputs

### Required
- `repository_name`: The name of the repository.
- `branch_name`: The name of the branch being deployed.
- `initiator`: The user who initiated the deployment.
- `teams_webhook_url`: The URL of the Teams Webhook.
- `message`: Message to display in the notification.

### Optional
- `deployment_url`: The URL of the deployment (if available).

## Outputs

- `http_response`: The HTTP response from the Teams Webhook.

## Example usage

```yaml
name: Deploy and Notify

on:
  push:
    branches:
      - main

jobs:
  deploy-and-notify:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      # Whatever deployment steps go here.

      - name: Send Teams Notification
        uses: your-github-username/teams-deploy-action@v1
        with:
          repository_name: ${{ github.repository }}
          branch_name: ${{ github.ref_name }}
          initiator: ${{ github.actor }}
          teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
          message: "Deploying new app!"
          deployment_url: https://your-deployment-url.com  # Optional
```

## How it works

1. The action takes in the required inputs: repository name, branch name, initiator, Teams webhook URL, and the custom message.
2. It creates an Adaptive Card message with the deployment information, using the provided message.
3. If a deployment URL is provided, it adds a "View Site" button to the card.
4. The message is sent to the specified Teams channel using the webhook URL.
5. The HTTP response from the Teams API is set as an output, which can be used in subsequent steps if needed.

## Note

Make sure to set up a webhook URL for your Microsoft Teams channel and store it as a secret in your GitHub repository settings. In the example above, it's referenced as `${{ secrets.TEAMS_WEBHOOK_URL }}`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
