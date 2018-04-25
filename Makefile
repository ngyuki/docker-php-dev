versions = 7.1 7.0

docker = docker

push_tags = latest ${versions}

all: build

build: latest ${versions}

latest: $(firstword ${versions})
	${docker} tag ngyuki/php-dev:$< ngyuki/php-dev:$@

${versions}:
	${docker} pull php:$@-alpine
	${docker} build . --build-arg BASE=php:$@-alpine -t ngyuki/php-dev:$@

test: $(addprefix test-,${versions})
$(addprefix test-,${versions}):
	${docker} run --rm -v "$$PWD":/app ngyuki/php-dev:$(subst test-,,$@) -d zend_extension=xdebug.so -d opcache.enable_cli=1 /app/check.php

push: $(addprefix push-,${push_tags})
push-%: %
	${docker} push ngyuki/php-dev:$<
