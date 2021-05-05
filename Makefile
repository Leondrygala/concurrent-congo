DOCKER_REGISTRY	?=
REPO_PATH	?= concurrent-congo
RELEASE_PATH:= $(DOCKER_REGISTRY)$(REPO_PATH)
BUILD_TAG := latest
NAME:= "concurrent-congo"

CI_REPO_URL			?= $(shell git config remote.origin.url)
CI_COMMIT			?= $(shell git rev-parse --short HEAD)

ENV_FILE			:= ".env"

.PHONY: build
build: build-java

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
