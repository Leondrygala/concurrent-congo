DOCKER_REGISTRY	?=
REPO_PATH	?= concurrent-congo
RELEASE_PATH:= $(DOCKER_REGISTRY)$(REPO_PATH)
BUILD_TAG := latest
NAME:= "concurrent-congo"

CI_REPO_URL			?= $(shell git config remote.origin.url)
CI_COMMIT			?= $(shell git rev-parse --short HEAD)

ENV_FILE			:= ".env"

.PHONY: build
build: build-java build-docker

.PHONY: build-docker
build-docker: build-java
	docker build \
		--tag $(RELEASE_PATH):$(shell cat VERSION)-$(CI_COMMIT) \
		--tag $(RELEASE_PATH):$(shell cat VERSION) \
		--tag $(RELEASE_PATH):$(BUILD_TAG) \
		.

.PHONY: bazel-build-java
bazel-build-java:
	bazel build //:ProjectRunner

.PHONY: build-java
build-java:
	docker run \
		--rm \
		-v "$(PWD)":/home/gradle/project \
		-v "${HOME}/.ivy2":/root/.ivy2 \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/wrapper/ \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/caches/ \
		-w /home/gradle/project \
		gradle:jdk16 ./gradlew build

.PHONY: run
run: build-java
	docker run \
		--rm \
		-v "$(PWD)":/home/gradle/project \
		-v "${HOME}/.ivy2":/root/.ivy2 \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/wrapper/ \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/caches/ \
		-w /home/gradle/project \
		gradle:jdk16 ./gradlew run

.PHONY: bash
bash:
	docker run \
		-it \
		--rm \
		-v "$(PWD)":/home/gradle/project \
		-v "${HOME}/.ivy2":/root/.ivy2 \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/wrapper/ \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/caches/ \
		-w /home/gradle/project \
		gradle:jdk16 bash

.PHONY: gradle
gradle:
	docker run \
		--rm \
		-v "$(HOME)/.gradle":/home/gradle/.gradle/ \
		-v "${HOME}/.ivy2":/root/.ivy2 \
		-v "$(PWD)":/home/gradle/project \
		-w /home/gradle/project \
		gradle:jdk16 ./gradlew $(ARGS)

.PHONY: release
release:
	docker push $(RELEASE_PATH):$(shell cat VERSION)-$(CI_COMMIT)
	docker push $(RELEASE_PATH):$(shell cat VERSION)
	docker push $(RELEASE_PATH):$(BUILD_TAG)


.PHONY: graph
graph: bazel-build-java
	bazel query  --notool_deps --noimplicit_deps "deps(//:ProjectRunner)" --output graph

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
