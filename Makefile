DOCKER_REPO = ngyuki/php-dev
DOCKERFILE_PATH = Dockerfile
versions = 7.1 7.2 7.3 7.4

all: ${versions} latest

build: ${versions}

latest: $(lastword ${versions})
	IMAGE_NAME=${DOCKER_REPO}:$< DOCKER_TAG=$^ DOCKER_REPO=${DOCKER_REPO} DOCKERFILE_PATH=${DOCKERFILE_PATH} \
		LATEST_VERSION=$(lastword ${versions}) LATEST_NO_PUSH=1 \
		./hooks/post_push

${versions}:
	IMAGE_NAME=${DOCKER_REPO}:$@ DOCKER_TAG=$@ DOCKER_REPO=${DOCKER_REPO} DOCKERFILE_PATH=${DOCKERFILE_PATH} \
		./hooks/build
