HELM_REPOSITORY=https://artifactory.toolchain.lead.prod.liatr.io/artifactory/helm
VERSION=$(shell git describe --tags --dirty | cut -c 2-)

export SKAFFOLD_DEFAULT_REPO?=artifactory.toolchain.lead.prod.liatr.io/docker-registry/liatrio-dev
                                                                                              
build:
	skaffold build

charts:
	@helm init --client-only
	@helm lint charts/grafeas-server
	@helm package --version $(VERSION) --app-version v$(VERSION) charts/grafeas-server
	@curl -f -X PUT -u $(ARTIFACTORY_CREDS) -T grafeas-server-$(VERSION).tgz $(HELM_REPOSITORY)/grafeas-server-$(VERSION).tgz

.PHONY: charts
