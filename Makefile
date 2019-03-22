DOCKER_REPO = ngyuki/php-dev
DOCKERFILE_PATH = Dockerfile
versions = 7.0 7.1 7.2 7.3
tags = ${versions} latest

all: latest

build: ${tags}

latest: $(lastword ${versions})
	IMAGE_NAME=${DOCKER_REPO}:$< DOCKER_TAG=$^ LATEST_VERSION=$@ \
	DOCKER_REPO=${DOCKER_REPO} DOCKERFILE_PATH=${DOCKERFILE_PATH} \
	./hooks/post_push

${versions}:
	IMAGE_NAME=${DOCKER_REPO}:$@ DOCKER_TAG=$@ \
	DOCKER_REPO=${DOCKER_REPO} DOCKERFILE_PATH=${DOCKERFILE_PATH} \
	./hooks/build
