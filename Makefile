HELM_REPOSITORY=https://artifactory.toolchain.lead.prod.liatr.io/artifactory/helm
VERSION=$(shell git describe --tags --dirty)
IS_SNAPSHOT = $(if $(findstring -, $(VERSION)),true,false)
MAJOR_VERSION := $(word 1, $(subst ., ,$(VERSION)))
MINOR_VERSION := $(word 2, $(subst ., ,$(VERSION)))
PATCH_VERSION := $(word 3, $(subst ., ,$(word 1,$(subst -, , $(VERSION)))))
NEW_VERSION ?= $(MAJOR_VERSION).$(MINOR_VERSION).$(shell echo $$(( $(PATCH_VERSION) + 1)) )
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

promote: version
ifeq (false,$(IS_SNAPSHOT))
	@echo "Unable to promote a non-snapshot"
	@exit 1
endif
ifneq ($(shell git status -s),)
	@echo "Unable to promote a dirty workspace" 
	@exit 1
endif
	@git fetch --tags
	@git tag -a -m "releasing v$(NEW_VERSION)" v$(NEW_VERSION)
	@git push origin v$(NEW_VERSION)


.PHONY: charts
