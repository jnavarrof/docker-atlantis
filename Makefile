REGISTRY=janafe
APP=docker-atlantis
VERSION=0.22.3
REPOS_ALLOW=github.com/jnavarrof/terragrunt-atlantis-example

.PHONY: help
help: ## show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:|/' | \
	fgrep -v fgrep | sed -e 's/\\$$//' | column -t -s '|'

.PHONY: login
login:
	docker login ghcr.io -u jnavarrof

.PHONY: build
build: ## Build step
	@echo "* Building image ..."
	docker build -t $(APP):$(VERSION) .

.PHONY: ngrok
ngrok: ## Start ngrok local reverse-proxy
	ngrok http 4141

.PHONY: run
run: ## Run container
	@echo "* Running container $(APP):$(VERSION)"
	@docker run -it --rm -p 4141:4141 -e ATLANTIS_DEFAULT_TF_VERSION="1.0.0" -v $(PWD)/repos.yaml:/cfg/repos.yaml:ro $(APP):$(VERSION) server --atlantis-url=$(URL) --gh-webhook-secret=$(SECRET) --repo-allowlist $(REPOS_ALLOW) --gh-user $(GH_USER) --gh-token $(GH_PAT) --repo-config=/cfg/repos.yaml

.PHONY: test
test: ## Test image using Trivy 
	@echo "* Testing image ..."
	trivy -q --auto-refresh $(APP):$(VERSION) | tee vuln-report.log
	@# Fail if HIGH vulnerabilities detected >0
	@if [ "$$(grep -c 'HIGH: [0-1]' vuln-report.log)" -gt 0 ]; then \
			echo "ERROR! Critical vulnerabilities detected in $(APP):$(VERSION)"; \
			exit 1; \
    fi 


.PHONY: push
push:
	docker tag $(APP):$(VERSION) $(REGISTRY)/$(APP):$(VERSION)
	docker push $(REGISTRY)/$(APP):$(VERSION)
