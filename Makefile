
all:
	docker pull php:7.1-alpine
	docker build . --build-arg BASE=php:7.1-alpine -t ngyuki/php-dev:7.1-alpine -t ngyuki/php-dev:latest

	docker pull php:7.0-alpine
	docker build . --build-arg BASE=php:7.0-alpine -t ngyuki/php-dev:7.0-alpine

	docker push ngyuki/php-dev:latest
	docker push ngyuki/php-dev:7.1-alpine
	docker push ngyuki/php-dev:7.0-alpine

	echo ok
