versions = 7.0 7.1 7.2 7.3 7.4

all: $(versions:%=%/Dockerfile)

$(versions:%=%/Dockerfile): Dockerfile.in
	mkdir -pv ${@D}
	sed -e '2,$$d' -e 'r Dockerfile.in' -i $@

build: ${versions}

.PHONY: ${versions}
${versions}: %: %/Dockerfile
	cd $* && IMAGE_NAME=ngyuki/php-dev:$* DOCKER_TAG=$* DOCKERFILE_PATH=${<F} hooks/build
	cd $* && IMAGE_NAME=ngyuki/php-dev:$* DOCKER_TAG=$* DOCKERFILE_PATH=${<F} hooks/test
