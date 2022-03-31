DOCKER_REPO := ngyuki/php-dev
LATEST_VERSION := 8.1

versions := $(wildcard [0-9]*.[0-9]*)
tags := ${versions} latest

.PHONY: all
all: $(versions:%=%/Dockerfile)

$(versions:%=%/Dockerfile): version=${@D}
$(versions:%=%/Dockerfile): patches=$(wildcard $(version)/*.patch)
$(versions:%=%/Dockerfile): Dockerfile.in $(patches)
	sed -e '2,$$d' -e 'r Dockerfile.in' -i $@
	for p in $(patches); do patch -p1 < $$p; done

.PHONY: build
build: ${tags}

.PHONY: ${versions}
${versions}: DOCKER_TAG=$@
${versions}: %: %/Dockerfile
	docker build . --pull -t ${DOCKER_REPO}:${DOCKER_TAG} -f ${DOCKER_TAG}/Dockerfile

.PHONY: latest
latest: ${LATEST_VERSION}
	docker tag ${DOCKER_REPO}:$< ${DOCKER_REPO}:$@

.PHONY: test
test: $(tags:%=%/test)

.PHONY: $(tags:%=%/test)
$(tags:%=%/test): DOCKER_TAG=${@D}
$(tags:%=%/test):
	docker run --rm -i ${DOCKER_REPO}:${DOCKER_TAG} -d zend_extension=xdebug.so -d opcache.enable_cli=1 < ./check.php

.PHONY: push
push: $(tags:%=%/push)

.PHONY: $(tags:%=%/push)
$(tags:%=%/push): DOCKER_TAG=${@D}
$(tags:%=%/push):
	docker push ${DOCKER_REPO}:${DOCKER_TAG}
