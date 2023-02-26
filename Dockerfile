FROM ghcr.io/runatlantis/atlantis:latest

ARG TERRAGRUNT=0.44.0
ARG ATLANTIS_DEFAULT_TF_VERSION=1.0.0

RUN curl -LsS \
    	https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT}/terragrunt_linux_amd64 \
		-o /usr/local/bin/terragrunt \
	&& chmod +x /usr/local/bin/terragrunt

COPY --from=ghcr.io/transcend-io/terragrunt-atlantis-config/slim:v0.7.0 \
	/app/terragrunt-atlantis-config /usr/local/bin/terragrunt-atlantis-config
