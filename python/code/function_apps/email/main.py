import os

from azure.identity import DefaultAzureCredential
from azure.storage.queue import QueueClient, TextBase64DecodePolicy
from dotenv import load_dotenv

load_dotenv()

QUEUE_NAME: str = "mail-queue"
ACCOUNT_NAME = os.getenv("STORAGE_ACCOUNT_NAME", "hmlrstspgdevlogicapp")
ACCOUNT_URL: str = f"https://{ACCOUNT_NAME}.queue.core.windows.net"

default_credential = DefaultAzureCredential(exclude_managed_identity_credential=True)


def mail_messages() -> None: ...


def main() -> None:
    storage_queue = QueueClient(
        account_url=ACCOUNT_URL,
        queue_name=QUEUE_NAME,
        credential=default_credential,
        message_decode_policy=TextBase64DecodePolicy(),
    )

    messages = storage_queue.receive_messages()

    for message in messages:
        print(message.content)


if __name__ == "__main__":
    main()
