import os

import requests
from azure.identity import ManagedIdentityCredential
from dotenv import load_dotenv

load_dotenv()

# Config
QUEUE_NAME: str = "mail-queue"
ACCOUNT_NAME: str | None = os.getenv("STORAGE_ACCOUNT_NAME").lower()
ACCOUNT_URL: str = f"https://{ACCOUNT_NAME}.queue.core.windows.net"
AZURE_CLIENT_ID: str | None = os.getenv("AZURE_CLIENT_ID")
SEND_FROM: str | None = os.getenv("SEND_FROM")
SEND_TO: str = "curtis.turner@landregistry.gov.uk"

# Bearer token helper
def get_bearer_token(client_id: str | None, resource: str) -> str:
    credential = ManagedIdentityCredential(client_id=client_id)

    access_token = credential.get_token(resource)

    return access_token.token

# Mail sender helper
def mail_sender(send_from: str | None, send_to: str, content: str, token: str) -> None:
    mail_endpoint = f"https://graph.microsoft.com/v1.0/users/{send_from}/sendMail"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    body = {
        "message": {
            "subject": "Test",
            "body": {"contentType": "Text", "content": content},
            "toRecipients": [{"emailAddress": {"address": send_to}}],
        }
    }

    requests.post(mail_endpoint, headers=headers, json=body, timeout=100)


def main() -> None:
    access_token = get_bearer_token(
        AZURE_CLIENT_ID, "https://graph.microsoft.com/.default"
    )

    content = "testing email content"
    mail_sender(SEND_FROM, SEND_TO, content, access_token)


if __name__ == "__main__":
    main()
