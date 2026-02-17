# =============================================================================
# Script Name: data_plane_test.sh
# Purpose: Compare secret creation via Data Plane (API) vs Control Plane (ARM)
# Usage: ./data_plane_test.sh
# =============================================================================
# Date       | Version | Author        | Change
# ---------- | ------- | ------------  | -------------------------------
# 2025-10-27 | 1.0     | Curtis Turner | Converted to Data Plane test
# =============================================================================

# Set Variables
JOBNAME=data_plane_test.sh
VERSION=1.0
JV="${JOBNAME}:${VERSION}"
KV_RAND_STRING=`date +%s`

# Loop Variables
MAX=200
COUNT=1
SLEEP=30

# Global
USER_OBJECT_ID="855ed2f6-08c0-4852-b1f5-7b18bf4c3e4b"
SUB_ID="01511132-1cf9-4ee9-b887-e9c285bc093c"
RG_NAME="rg-kv-policy-test"
LOCATION="uksouth"
KV_RETENTION_DAYS=7
SECRET_VALUE="verysecuresecret"
TERRAFORM_DIR="./terraform"

# Main Body
echo "${JV}: Starting at `date`"
echo

# Remove file function
remove_if_exists() {
  local file="$1"

  if [[ -f "$file" ]]; then
    rm -f "$file"
    echo "Removed file: $file"
  else
    echo "File not found: $file"
  fi
}

# Check AZ CLI is Authenticated
az.cmd account show > /dev/null 2>&1
AZ_EXIT=$?

if [[ $AZ_EXIT != 0 ]]; then
  echo "Not logged in, please login with /'az login/'"
  exit $AZ_EXIT
fi

# Create KeyVault
echo "Creating Key Vault..."
az.cmd keyvault create -g "$RG_NAME" -n "kv${KV_RAND_STRING}" -l "$LOCATION" --retention-days "$KV_RETENTION_DAYS" > create_kv_data.tmp 2>&1

KV_EXIT=$?
if [[ $KV_EXIT != 0 ]]; then
  echo "Error Creating KeyVault"
  echo "Error Message:"
  cat create_kv_data.tmp
  remove_if_exists create_kv_data.tmp
  exit $AZ_EXIT
else
  echo "Key Vault created sucessfully"
  KV_CREATED=$(date +%s)

  echo
  echo "Finding KV ID..."
  KV_ID=`cat create_kv_data.tmp | grep id | awk '{print $2}' | sed 's/"//g' | sed 's/,//g'`
  echo "Keyvault ID: $KV_ID"
  KV_ID_CLEAN="${KV_ID#/}" # Bug - needed to remove the leading forward slash??? 
fi

echo 
echo "Creating role assignment..."
az.cmd role assignment create --assignee $USER_OBJECT_ID --role "Key Vault Administrator" --scope "$KV_ID_CLEAN" > create_role_data.tmp 2>&1

sleep 30

KV_EXIT=$?
if [[ $KV_EXIT != 0 ]]; then
  echo "Error Adding Role"
  echo "Error Message:"
  cat create_role_data.tmp
  remove_if_exists create_kv_data.tmp
  remove_if_exists create_role_data.tmp
else
  echo "Key Vault Administrator Role Added Successfully"
fi

# Create KV Secret
# Function
create_secret() {
  local secret_name=$1
  local kv_name="kv${KV_RAND_STRING}"
  
  echo 
  echo "Generating Access Token..."
  JWT_ACCESS_TOKEN=`az.cmd account get-access-token --resource https://vault.azure.net | grep accessToken | awk '{print $2}' | sed 's/"//g' | sed 's/,//g'`

  echo
  echo "Creating secret $secret_name via data plane..."

  curl --fail-with-body -X PUT \
  -H "Authorization: Bearer $JWT_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{ \"value\": \"verysecuresecret\"}" \
  https://$kv_name.vault.azure.net/secrets/$secret_name?api-version=7.3 > kv_create_secret_data.tmp 2>&1

  local dp_exit=$?

  if [[ $dp_exit = 0 ]]; then
    echo "Secret Added without Error"
    return 0
  else
    echo "Secret did not create"
    echo "See error:"
    cat kv_create_secret_data.tmp
    return 1
  fi
}

# Try create secret
while [[ $COUNT -le $MAX ]]; do
  echo "Iteration $COUNT"
  NOW=$(date +%s)
  ELAPSED=$((NOW - KV_CREATED))

  if ! create_secret "secret${COUNT}"; then
    echo "Secret creation failed on iteration $COUNT"
    echo "Time since KV creation: ${ELAPSED} seconds"
    break
  else
    echo "Secret creation succeeded on iteration $COUNT"
    echo "Time since KV creation: ${ELAPSED} seconds"
  fi

  COUNT=$((COUNT + 1))
  
  echo
  echo "Sleeping for $SLEEP" 
  sleep $SLEEP
done

# Delete Keyvault
echo
echo "Deleting Key Vault..."
az.cmd keyvault delete -g "$RG_NAME" -n "kv${KV_RAND_STRING}" > delete_kv_data.tmp 2>&1

KV_EXIT=$?
if [[ $KV_EXIT != 0 ]]; then
  echo "Error Deleting KeyVault"
  echo "Error Message:"
  cat delete_kv_data.tmp
  remove_if_exists create_kv_data.tmp
  remove_if_exists create_role_data.tmp
  remove_if_exists kv_create_secret_data.tmp
  remove_if_exists delete_kv_data.tmp
  exit $AZ_EXIT
else
  echo "Key Vault deleted sucessfully"
fi

# Remove all TMP Files
echo 
echo "Removing TMP Files..."
remove_if_exists create_kv_data.tmp
remove_if_exists create_role_data.tmp
remove_if_exists kv_create_secret_data.tmp
remove_if_exists delete_kv_data.tmp

echo
echo "${JV}: Ending at `date`"
