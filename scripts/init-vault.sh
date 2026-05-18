#!/bin/bash
kubectl exec -n vault vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > vault-keys.json
VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" vault-keys.json)
VAULT_ROOT_TOKEN=$(jq -r ".root_token" vault-keys.json)
kubectl exec -n vault vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=$VAULT_ROOT_TOKEN
vault auth enable kubernetes
vault write auth/kubernetes/role/myapp bound_service_account_names=myapp bound_service_account_namespaces=default policies=myapp-policy ttl=24h
vault secrets enable -path=secret kv-v2
vault kv put secret/myapp/config database_password="VaultManagedPassword123!" api_key="vault-managed-api-key-xyz789" database_url="postgresql://user:password@db:5432/myapp"
