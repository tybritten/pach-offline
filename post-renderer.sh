#!/bin/bash

source settings.sh

input=$(cat)

# Find all the container images in the YAML input using yq
DOCKER_IMAGES=$(echo "$input" | yq eval '.spec.template.spec.containers[].image' - | sed '/---/d' )

NEW_HELM_TEMPLATE=$input
for IMAGE in $DOCKER_IMAGES; do
    NEW_TAG="${NEW_REPO}/${IMAGE##*/}"
    NEW_HELM_TEMPLATE=$(sed "s~$IMAGE~$NEW_TAG~g" <<< "$NEW_HELM_TEMPLATE")
done

#output updated template back to helm
echo "$NEW_HELM_TEMPLATE"
