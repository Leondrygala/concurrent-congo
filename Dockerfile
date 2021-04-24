FROM openjdk:16

WORKDIR /work

COPY /src/ /usr/local/bin

ENTRYPOINT ["/bin/bash"]
