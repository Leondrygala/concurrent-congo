DOCKER_REGISTRY	?=
REPO_PATH	?= concurrent-congo
RELEASE_PATH:= $(DOCKER_REGISTRY)$(REPO_PATH)
BUILD_TAG := latest
NAME:= "concurrent-congo"

CI_REPO_URL			?= $(shell git config remote.origin.url)
CI_COMMIT			?= $(shell git rev-parse --short HEAD)

ENV_FILE			:= ".env"

.PHONY: build
build:
	docker build \
		--tag $(RELEASE_PATH):$(shell cat VERSION)-$(CI_COMMIT) \
		--tag $(RELEASE_PATH):$(shell cat VERSION) \
		--tag $(RELEASE_PATH):$(BUILD_TAG) \
		.

.PHONY: release
release:
	docker push $(RELEASE_PATH):$(shell cat VERSION)-$(CI_COMMIT)
	docker push $(RELEASE_PATH):$(shell cat VERSION)
	docker push $(RELEASE_PATH):$(BUILD_TAG)

#.PHONY: test
#test: build 
	#test/test-main.sh
#
#.PHONY: debug
#debug: build
	#docker run -it --rm \
		#--entrypoint bash \
		#-e IMAGE_TAG="6.6.6" \
		#--env-file $(ENV_FILE) \
		#$(RELEASE_PATH):$(BUILD_TAG)

#.PHONY: clean
#clean:
	#-docker images | grep "$(RELEASE_PATH)" | tr -s ' ' \
		#| cut -d ' ' -f 2 | xargs -I {} docker rmi $(RELEASE_PATH):{}
