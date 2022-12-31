# ref https://github.com/hashicorp/consul-k8s/issues/536#issuecomment-1212259161
FROM golang:1.19-alpine as build
ARG TARGETOS
ARG TARGETARCH

COPY . /go

RUN cd /go/control-plane && \
	set -x; go build -o pkg/bin/consul-k8s-control-plane

# final image
# we are simply copying our custom built binary over the standard binary in the image
FROM hashicorp/consul-k8s-control-plane:latest

ARG TARGETOS
ARG TARGETARCH

COPY --from=build /go/control-plane/pkg/bin/ /bin