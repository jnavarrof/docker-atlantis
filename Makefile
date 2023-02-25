REGISTRY=janafe
APP=atlantis
VERSION=0.22.3
VERSION=latest

.PHONY: help
help: ## show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:|/' | \
	fgrep -v fgrep | sed -e 's/\\$$//' | column -t -s '|'

.PHONY: build
build: ## Build step
	@echo "* Building image ..."
	docker build -t $(APP):$(VERSION) .

.PHONY: run
run: ## Run container
	@ echo "* Running container $(APP):$(VERSION)"
	docker run -it --rm $(APP):$(VERSION)

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
