#! /bin/bash

# just a helper script to login to the correct project

# already logged in
if gcloud auth application-default print-access-token >/dev/null 2>&1; then
  echo "Already logged in to Google Cloud"
  exit 0
fi

# login to Vertex
if ! gcloud auth application-default login --project vertex-ai-206179; then
  echo "Google Cloud login failed, run gcloud-login.sh later"
fi
