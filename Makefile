BINDER_VERSION := 0.2.6-dev1

.PHONY: build-binder
build-binder:
	docker build -t gcr.io/jovian/binder:$(BINDER_VERSION) . --platform linux/amd64

.PHONY: push-binder
push-binder:
	docker push gcr.io/jovian/binder:$(BINDER_VERSION)
