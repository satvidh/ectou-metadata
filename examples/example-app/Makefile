PREFIX?=satvidh
ARTIFACT=$(shell basename $(PWD))
VERSION?=1.0.0
CHARTS_PATH=../../charts
KUBERNETES_NAMESPACE?=default
HELM_NAME=$(ARTIFACT)

guard-%:
	@ if [ "${${*}}" = "" ]; then \
        echo "Environment variable $* not set"; \
        exit 1; \
	fi

build:
	docker build --no-cache \
		-t "$(PREFIX)/$(ARTIFACT):latest" \
		-t "$(PREFIX)/$(ARTIFACT):$(VERSION)" \
		.

clean:
	-helm delete $(HELM_NAME) -n $(KUBERNETES_NAMESPACE)
	-docker rmi \
		"$(PREFIX)/$(ARTIFACT):$(VERSION)" \
		"$(PREFIX)/$(ARTIFACT):latest"


deploy: guard-POD_ROLE_NAME guard-CHARTS_PATH
	CHARTS_PATH=$(CHARTS_PATH) \
	IMAGE_NAME=$(PREFIX)/$(ARTIFACT) \
	IMAGE_TAG=$(VERSION) \
	KUBERNETES_NAMESPACE=$(KUBERNETES_NAMESPACE) \
	HELM_NAME=$(HELM_NAME) \
		./deploy.sh
