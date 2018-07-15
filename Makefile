versions = $(shell cat build-opts.txt|cut -d: -f1)
build_opts = $(shell fgrep $@: build-opts.txt|cut -d: -f2)
tags = ${versions} latest

all: build

build: ${tags}

latest: $(firstword ${versions})
	docker tag ngyuki/php-dev:$< ngyuki/php-dev:$@

${versions}:
	docker pull php:$@-alpine
	docker build . --build-arg BASE=php:$@-alpine ${build_opts} -t ngyuki/php-dev:$@

test: $(addprefix test-,${versions})
$(addprefix test-,${versions}):
	docker run --rm -v "$$PWD":/app ngyuki/php-dev:$(subst test-,,$@) -d zend_extension=xdebug.so -d opcache.enable_cli=1 /app/check.php

push: $(addprefix push-,${tags})
$(addprefix push-,${tags}):
	docker push ngyuki/php-dev:$(subst push-,,$@)
