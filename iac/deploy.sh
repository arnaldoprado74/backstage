#!/bin/bash
APPLY_WKP=$1
APPLY_ENV=${APPLY_WKP##*-}
APPLY_SQD=${APPLY_WKP%-*}
ACTION=$2

# validate current directory
if ! [[ "${PWD##*/}" == "iac" ]]; then
 	echo -e "This script must be executed from the iac project root directory."
	exit 1
elif [ -z "${APPLY_ENV}" ] || [ -z "${APPLY_SQD}" ] || [ -z "${ACTION}" ]; then
	echo -e "Please follow the syntax:"
	echo -e "   ./deploy <squad-environment> <(P)lan or (A)pply) )>"
	echo -e "sample: # to deploy the security team projects in the dev environment\n"
	echo -e "   ./deploy secur-dev A"
	exit 1
elif [ -z "${SECRETS_FILE}" ] && [ -z "${P_SECRETS}" ]; then
 	echo -e "There is no definition of secrets as file or as environment variable. Please check that before running."
	exit 1
fi

if ! [[ -d ./environments/${APPLY_ENV}/.terraform ]]; then
	echo "[deploy] Terraform environment first initialization.."
	terraform -chdir=environments/${APPLY_ENV} init 
fi

echo "[deploy] Terraform Initiating/Upgrading..."
# init the terraform for the environment
terraform -chdir=environments/${APPLY_ENV} init -upgrade

echo "[deploy] Setting workspace to $APPLY_WKP in dir environments/${APPLY_ENV}..."
# select the workspace
terraform -chdir=environments/${APPLY_ENV} workspace select $APPLY_WKP

echo "[deploy] Executing plan or apply..."
# validate secrets 
SECRETS_CONTENT="none"
if [[ -f "$SECRETS_FILE" ]]; then
   SECRETS_CONTENT="`cat ${SECRETS_FILE}`" # get from CI tool protected content
else
   SECRETS_CONTENT="${P_SECRETS}"
fi
# do the plan / apply
terraform -chdir=environments/${APPLY_ENV} refresh -var "p_secrets=${SECRETS_CONTENT}"
if [ "$ACTION" == "P" ] || [ "$ACTION" == "p" ]; then
   terraform -chdir=environments/${APPLY_ENV} plan -var "p_secrets=${SECRETS_CONTENT}"
elif [ "$ACTION" == "A" ] || [ "$ACTION" == "a" ]; then
   terraform -chdir=environments/${APPLY_ENV} apply -var "p_secrets=${SECRETS_CONTENT}" --auto-approve
else
   echo -e "\n==> an incorrect parameter was passed, please check the syntax again executing this script without parameters.\n"
fi

