#!/bin/bash
vault kv put secret/myapp/config database_password="NewRotatedPassword456!" api_key="new-rotated-api-key" database_url="postgresql://user:newpassword@db:5432/myapp"
kubectl rollout restart deployment/python-myapp
