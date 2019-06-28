mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# ----------------------------------------------------------------------
# Tag releases

EMPTY_VERSION = 0.0.0

# Get release flag from commit message.
# A commit is flagged for release if the message contains the following:
# release: patch/minor/major
COMMIT_RELEASE := $(mkfile_dir)/scripts/commit_release.sh
RELEASE_TYPE = $(shell $(COMMIT_RELEASE))

# Existing git tags
GIT_TAG_CURRENT = $(shell git describe --exact-match --abbrev=0 2>/dev/null)
GIT_TAG_PREVIOUS = $(shell git describe --abbrev=0 HEAD^ 2>/dev/null)

# Generate new version tag from release type and previous tag
SEMVER := $(mkfile_dir)/scripts/semver.sh
FLAG.patch := p
FLAG.minor := m
FLAG.major := M
SEMVER_FLAG = $(FLAG.$(RELEASE_TYPE))
PREVIOUS_VERSION = $(or $(GIT_TAG_PREVIOUS),$(EMPTY_VERSION))
GIT_TAG_NEW = $(shell $(SEMVER) -$(SEMVER_FLAG) $(PREVIOUS_VERSION))

# Determine version. One of the following:
# Current: if the current commit is already tagged.
# New: if the current commit is flagged for release and but untagged
# None: of the current commit is neither flagged for release nor tagged.
VERSION = $(if $(RELEASE_TYPE),$(or $(GIT_TAG_CURRENT), $(GIT_TAG_NEW)),)

tag:
ifneq ($(VERSION),)
  ifneq ($(GIT_TAG_CURRENT),)
	@echo Current commit tagged already tagged $(GIT_TAG_CURRENT), skipping
  else
	@echo Current commit flagged  with release: $(RELEASE_TYPE)
	@echo Previous version: $(PREVIOUS_VERSION)
	@echo Tagging with new version: $(VERSION)
	git tag -a $(VERSION) -m "Official release $(VERSION)"
  endif
else
	@echo Current commit not flagged for release
endif

# ----------------------------------------------------------------------
# Docker

COMMIT_HASH = $(shell git rev-parse --short=10 HEAD)
DOCKER_BASE_TAG = $(DOCKER_REPO):$(COMMIT_HASH)

docker-build: DOCKER_TAG = $(DOCKER_ACCOUNT)/$(DOCKER_BASE_TAG)$(if $(VERSION),-$(VERSION),)
docker-build:
ifeq ($(shell docker images -q $(DOCKER_TAG) 2>/dev/null),"")
	@echo $(shell docker images -q $(DOCKER_TAG) 2>/dev/null)
	@echo Docker image tagged $(DOCKER_TAG) already exists
else
	-docker rm $(DOCKER_TAG) -f
	docker build -t $(DOCKER_TAG) .
endif
	docker push $(DOCKER_TAG)

# ----------------------------------------------------------------------
# Deploy

export DOCKER_TAG = $(DOCKER_ACCOUNT)/$(DOCKER_BASE_TAG)$(if $(VERSION),-$(VERSION),)

PRELUDE := $(dir $(mkfile_dir))/k8s/dhall-lang/Prelude/package.dhall
MKDOCS := dhall-to-yaml --omitEmpty --documents <<< './service.dhall'
APPLY := kubectl apply -f -

deploy: export DHALL_PRELUDE := $(PRELUDE)
deploy:
	@$(MKDOCS) | $(APPLY)

print-deploy: export DHALL_PRELUDE := $(PRELUDE)
print-deploy:
	@$(MKDOCS)
