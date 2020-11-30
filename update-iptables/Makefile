PREFIX?=satvidh
ARTIFACT=$(shell basename $(PWD))
VERSION?=1.0.0

build:
	docker build --no-cache \
		-t "$(PREFIX)/$(ARTIFACT):latest" \
		-t "$(PREFIX)/$(ARTIFACT):$(VERSION)" \
		.

clean:
	-docker rmi \
		"$(PREFIX)/$(ARTIFACT):$(VERSION)" \
		"$(PREFIX)/$(ARTIFACT):latest"
