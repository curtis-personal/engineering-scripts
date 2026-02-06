import requests
import json
from azure.identity import DefaultAzureCredential

subscriptionId = "1426b95f-c7ff-4b89-8b32-be75a58b34b2"
model_name = "gpt-4o"
model_version = "2024-11-200"

token_credential = DefaultAzureCredential()
token = token_credential.get_token("https://management.azure.com/.default")
headers = {"Authorization": "Bearer " + token.token}

url = f"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/modelCapacities"
params = {
    "api-version": "2024-06-01-preview",
    "modelFormat": "OpenAI",
    "modelName": model_name,
    "modelVersion": model_version,
}

response = requests.get(url, params=params, headers=headers)
model_capacity = response.json()

print(json.dumps(model_capacity, indent=2))
