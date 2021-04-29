versions = $(wildcard [0-9]*.[0-9]*)

all: $(versions:%=%/hooks) $(versions:%=%/Dockerfile)

$(versions:%=%/Dockerfile): version=${@D}
$(versions:%=%/Dockerfile): patches=$(wildcard $(version)/*.patch)
$(versions:%=%/Dockerfile): Dockerfile.in $(patches)
	sed -e '2,$$d' -e 'r Dockerfile.in' -i $@
	for p in $(patches); do patch -p1 < $$p; done

$(versions:%=%/hooks): hooks
	ln -sfn ../hooks/ $@

build: ${versions}

.PHONY: ${versions}
${versions}: %: %/Dockerfile
	cd $* && IMAGE_NAME=ngyuki/php-dev:$* DOCKER_TAG=$* DOCKERFILE_PATH=${<F} hooks/build
	cd $* && IMAGE_NAME=ngyuki/php-dev:$* DOCKER_TAG=$* DOCKERFILE_PATH=${<F} hooks/test
