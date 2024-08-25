chmod +x getTitle.sh
title=$(./getTitle.sh)
API=$(aws apigateway get-rest-apis --query "items[?name=='$title' $$ endpointConfiguration.types[0]=='$2']" --output json --region "$1")
API_ID=$(echo "$API" | jq -r '.[].id')
if [ -z "$API_ID" ]; then
    exit 1
else
    echo "$API_ID"
fi