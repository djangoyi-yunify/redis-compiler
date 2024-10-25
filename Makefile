OSV ?= 22.04
NAMESPACE ?= djangoyi

# OSV=22.04 make ubuntu-build
ubuntu-build:
	docker buildx build -f Dockerfile-ubuntu --build-arg OSV=${OSV} --platform linux/amd64,linux/arm64 -t ${NAMESPACE}/redis-compiler:ubuntu-${OSV} . --push

# OSV=10sp2 make kylin-build
kylin-build:
	docker buildx build -f Dockerfile-kylin --build-arg OSV=${OSV} --build-arg NAMESPACE=${NAMESPACE} --platform linux/amd64,linux/arm64 -t ${NAMESPACE}/redis-compiler:kylin-${OSV} . --push

# be sure kylin-server-10sp2-amd64.tgz and kylin-server-10sp2-arm64.tgz exist in folder kylin-server
# pepare kylin rootfs by exec: OSV=10sp2 make kylin-base
# then make kylin-server image by exec: OSV=10sp2 make kylin-base
kylin-base:
	cd kylin-server && docker buildx build --platform linux/amd64,linux/arm64 -t ${NAMESPACE}/kylin-server:${OSV} . --push

prepare-kylin-rootfs: clean-kylin-server-tmp
	mkdir -p kylin-server/tmp/arm64/proc kylin-server/tmp/amd64/proc
	mkdir -m 1777 kylin-server/tmp/arm64/tmp kylin-server/tmp/amd64/tmp
	tar -xzf kylin-server/kylin-server-${OSV}-arm64.tgz -C kylin-server/tmp/arm64
	tar -xzf kylin-server/kylin-server-${OSV}-amd64.tgz -C kylin-server/tmp/amd64

clean-kylin-server-tmp:
	rm -rf kylin-server/tmp/*

# OSV=3.20.3 make alpine-build
alpine-build:
	docker buildx build -f Dockerfile-alpine --build-arg OSV=${OSV} --platform linux/amd64,linux/arm64 -t ${NAMESPACE}/redis-compiler:alpine-${OSV} . --push