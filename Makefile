OSV ?= 22.04

NAMESPACE ?= djangoyi

ubuntu-build:
	docker buildx build -f Dockerfile-ubuntu --build-arg OSV=${OSV} --platform linux/amd64,linux/arm64 -t ${NAMESPACE}/redis-compiler:ubuntu-${OSV} . --push