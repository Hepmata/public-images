#!/bin/zsh

set +e

usage () {
  echo "This script helps to retrieve MSK username and password from SecretsManager and connects to MSK."
  echo "WARNING: Prerequisites: [aws, kafkacat, jq] required. (Please install via brew)"
  echo "Usage: ./msk.sh -s [SecretName|SecretARN] -t [MSKTopicName] -c [ClusterName] -m [Consumer|Producer|List]";
  echo "Example: ./msk.sh -s DefaultMSK_V1 -t SanityTopic -m Consumer";
  }

function validate_inputs() {
    if [[ -z $secret_name ]]
    then
      echo "Please provide argument for secret name(eg. -s SOMESECRET or -s SOMESECRETARN)"
      exit 1
    fi
    if [[ -z $topic ]]
    then
      echo "No topic given. Script will run in List mode"
      exit 1
    fi
    if [[ -z $cluster_name ]]
    then
      echo "Please provide a cluster query name! (eg. -c cds)"
      exit 1
    fi
}

while getopts s:t:c:m:h option
do
  case "$option" in
    s) secret_name=$OPTARG;;
    t) topic=$OPTARG;;
    m) mode=$OPTARG;;
    c) cluster_name=$OPTARG;;
    h) usage; exit;;
    \?) usage; exit 1;;
    :) usage; exit 1;;
  esac
done

function set_secret() {
  echo "$(tput setaf 5)Getting secret from SecretManager..."
  secret=$(aws secretsmanager get-secret-value --secret-id "${secret_name}" | jq -r '.SecretString')
  msk_username=$(echo "$secret" | jq -r '.username')
  msk_password=$(echo "$secret" | jq -r '.password')
  echo "$(tput setaf 2)Secret set!"
}

function set_brokers() {
  echo "$(tput setaf 5)Getting brokers for cluster ${cluster_name} from MSK..."
  cluster_arn=$(aws kafka list-clusters --cluster-name-filter "${cluster_name}" | jq -r '.ClusterInfoList[0].ClusterArn')
  brokers=$(aws kafka get-bootstrap-brokers --cluster-arn "${cluster_arn}" | jq -r '.BootstrapBrokerStringSaslScram')
  echo "$(tput setaf 2)Brokers set!"
}

function execute_modes() {
    if [[ ${mode} == "Consumer" ]]
    then
      echo "$(tput setaf 5)Connected as Consumer"
      kafkacat -b $brokers -X security.protocol=SASL_SSL \
      -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=${msk_username} -X sasl.password=${msk_password} \
      -C -t "${topic}"
    elif [[ ${mode} == "Producer" ]]
    then
      echo "$(tput setaf 5)Connected as Producer"
      kafkacat -b $brokers -X security.protocol=SASL_SSL \
      -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=${msk_username} -X sasl.password=${msk_password} \
      -P -t "${topic}"
    else
     echo "$(tput setaf 5)Available topics ---"
     tput setaf 2
     kafkacat -b $brokers -X security.protocol=SASL_SSL \
      -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=${msk_username} -X sasl.password=${msk_password} \
      -L -J -J | jq -r '.topics[].topic'
    fi
}

validate_inputs
set_secret
set_brokers
execute_modes

