login:
	docker login registry
build:
  docker build -t salt-master .
setup:
	git clone REPOSITORY
	docker-compose up -d
drop: 
	docker-compose kill
	docker-compose rm
up: 
	docker-compose up -d
