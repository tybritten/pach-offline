#!/bin/bash

source settings.sh

VALUES_FILE=$1
if [ -z "$VALUES_FILE" ]; then
    echo "Usage: $0 <values>"
    exit 1
fi
TEMPLATE=$(helm template pachyderm pachyderm/ $VALUES_FILE)

# Find all the container images in the YAML input using yq
DOCKER_IMAGES=$(echo "$TEMPLATE" | yq eval '.spec.template.spec.containers[].image' - | sed '/---/d')

pull_images() {
    # Pull each docker image and retag it with the new repo name
    for IMAGE in $DOCKER_IMAGES; do
        echo "pulling $IMAGE"
        docker pull "$IMAGE"
        NEW_TAG="${NEW_REPO}/${IMAGE##*/}"
        echo "tagging $NEW_TAG"
        docker tag "$IMAGE" "$NEW_TAG"
    done
}
push_images() {
    for IMAGE in $DOCKER_IMAGES; do
        NEW_TAG="${NEW_REPO}/${IMAGE##*/}"
        docker push "$NEW_TAG"
    done
}

pull_images
push_images
