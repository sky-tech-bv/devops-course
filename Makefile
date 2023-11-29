APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=sky-tech-bv
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format: 
	gofmt -s -w ./

lint:
	golint

get:
	go get

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/sky-tech-bv/devops-course/cmd.appVersion=${VERSION}
	
image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean: image
	rm -rf kbot
	docker rm -vf $(docker ps -aq)
	docker rmi -f $(docker images -aq)