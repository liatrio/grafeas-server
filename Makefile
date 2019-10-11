HELM_REPOSITORY=https://artifactory.toolchain.lead.prod.liatr.io/artifactory/helm
VERSION=$(shell git describe --tags --dirty | cut -c 2-)
ARTIFACTORY_CREDS ?= $(shell cat /root/.docker/config.json | sed -n 's/.*auth.*"\(.*\)".*/\1/p'|base64 -d)


version:
	@echo "$(VERSION)"

build:
	@skaffold build

charts:
	@helm init --client-only
	@helm lint charts/grafeas-server
	@helm package --version $(VERSION) --app-version v$(VERSION) charts/grafeas-server
	@curl -f -X PUT -u $(ARTIFACTORY_CREDS) -T grafeas-server-$(VERSION).tgz $(HELM_REPOSITORY)/grafeas-server-$(VERSION).tgz

.PHONY: charts
