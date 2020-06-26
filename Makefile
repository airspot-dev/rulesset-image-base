VERSION=`cat VERSION`
DEV_VERSION = ${VERSION}-`date +%Y%m%d%H%M%S`

PROJECT=`gcloud config get-value project`

ifndef DOCKER_REGISTRY
	DEV_DOCKER_REGISTRY=eu.gcr.io/$(PROJECT)
else
	DEV_DOCKER_REGISTRY = ${DOCKER_REGISTRY}
endif

public: Dockerfile app/*.py public/Dockerfile
	bumpversion --current-version ${VERSION} patch VERSION --allow-dirty
	docker build -t rulesset-image-base-setup:$VERSION -t ${DOCKER_REGISTRY}/rulesset-image-base-setup:${VERSION} .
	docker build -t rulesset-image-base:${VERSION} -t ${DOCKER_REGISTRY}/rulesset-image-base:${VERSION} public
	docker push ${DOCKER_REGISTRY}/rulesset-image-base:${VERSION}

develop: Dockerfile app/*.py develop/Dockerfile
	docker build -t rulesset-image-base-setup:${VERSION} -t ${DEV_DOCKER_REGISTRY}/rulesset-image-base-setup:${VERSION} .
	docker build -t rulesset-image-base:${DEV_VERSION} -t ${DEV_DOCKER_REGISTRY}/rulesset-image-base:${DEV_VERSION} develop
	docker push ${DEV_DOCKER_REGISTRY}/rulesset-image-base:${DEV_VERSION}
