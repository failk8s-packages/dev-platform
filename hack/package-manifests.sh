#!/usr/bin/env bash

set -eo pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BASE_DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

source ${BASE_DIR}/hack/functions

create-manifests
echo "============"
echo "Now you can test your package"
echo "deploy your package:"
echo "      kubectl apply -f $BASE_DIR/target/k8s"
echo "test your package:"
echo "      kubectl apply -f $BASE_DIR/target/test"
echo "Watch progress"
echo "      watch kubectl get packageinstall $_name-package -n $_name-package"
