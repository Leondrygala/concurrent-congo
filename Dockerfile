FROM openjdk:16

WORKDIR /work

COPY bazel-bin bazel-bin

#ENTRYPOINT ["/usr/local/bin/ProjectRunner"]
