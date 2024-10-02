#!/bin/sh -l

# Prepare the JSON payload
json_payload=$(cat << EOF
{
    "type": "message",
    "attachments": [
        {
            "contentType": "application/vnd.microsoft.card.adaptive",
            "contentUrl": null,
            "content": {
                "\$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "type": "AdaptiveCard",
                "version": "1.2",
                "body": [
                    {
                        "type": "TextBlock",
                        "text": "${MESSAGE}"
                    },
                    {
                        "type": "FactSet",
                        "facts": [
                            {
                                "title": "Initiated By:",
                                "value": "${INITIATOR}"
                            },
                            {
                                "title": "Branch:",
                                "value": "${BRANCH_NAME}"
                            },
                            {
                                "title": "Deployment URL:",
                                "value": $([ -n "${DEPLOYMENT_URL}" ] && echo '"'${DEPLOYMENT_URL}'"' || echo '"Not set. Set the repository secret [BRANCH_NAME]_DEPLOYMENT_URL to enable."')
                            }
                        ]
                    }
                ],
                "actions": [
                    {
                        "type": "Action.OpenUrl",
                        "title": "View Progress",
                        "url": "${PROGRESS_URL}"
                    }
                    $([ -n "${DEPLOYMENT_URL}" ] && echo ',
                    {
                        "type": "Action.OpenUrl",
                        "title": "View Site",
                        "url": "'${DEPLOYMENT_URL}'"
                    }' || echo ',
                    {
                        "type": "Action.OpenUrl",
                        "title": "Setup Deployment URL",
                        "url": "'${VARIABLE_SETUP_URL}'"
                    }')
                ]
            }
        }
    ]
}
EOF
)

# Send the curl request
response=$(curl --location "${TEAMS_WEBHOOK_URL}" \
                --header 'Content-Type: application/json' \
                --data "$json_payload")

# Set the output
echo "::set-output name=http_response::$response"