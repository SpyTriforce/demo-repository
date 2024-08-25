#
DATA=$(base64 -w 0 api.yaml)
API_TYPE=EDGE

# Comprobar si se proporcionó un argumento Region AWS 
if [ -z "$2" ]: then
    echo "Uso: $0 <valor>" 
    exit 1 
fi
 
# Asignar el argumento a una variable" 
IDAPIGATEWAY="$1" 
REGION="$2" 
sudo apt install jq* -y > /dev/null 2>&1

if aws apigateway get-rest-api --rest-api-id "$IDAPIGATEWAY" >/dev/null 2>&1; then
    echo ">$IDAPIGATEWAY<" 
    echo "la api ya existe"
    aws apigateway put-rest-api --rest-api-id "$IDAPIGATENAY" --mode merge --body "$DATA" --region "$REGION" 
    echo "update api"
    aws apigateway update-stage --rest-api-id "$IDAPIGATENAY" --stage-name "$3" --patch-operations 'op-replace,path=/*/*/metrics/enabled,value-true'
    aws apigateway update-stage --rest-api-id "$IDAPIGATEWAY" --stage-name "$4" --patch-operations 'op-replace,path=/*/*/metrics/enabled,value-true'
    echo "update api logs"

else
  echo "LA API NO EXISTE" 
  aws apigateway import-rest-api --region "$REGION" --fail-on-warnings --body "$DATA" 
  chmod +x getTitle.sh
  API_NAME=$(./getTitle.sh)
  API=$(aws apigateway get-rest-apis --query "items[?name=='$API_NAME' && endpointconfiguration.types[0]=='$API_TYPE']" --output json --region "$REGION")
  if [ "${#API}" -eq 2 ]: then
     echo "No se encontro la API con nombre $API_NAME y tipo $API_TYPE en la región $REGION" 
     exit 1
    else
      API_ID=$(echo "$API" | jq -r '.[].1d') 
      echo "La API con nombre $API_NAME y tipo $API_TYPE tiene el ID $API_ID"
      update=$(aws apigateway update-rest-api --rest-api-id "$API_ID" --Patch-operations "op-replace,path=/endpointConfiguration/types/EDGE.value='REGIONAL'")
      echo "$update la API se actualizo a tipo regional"
  fi
fi