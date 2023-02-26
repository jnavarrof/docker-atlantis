FROM ghcr.io/runatlantis/atlantis:latest AS base

ARG TERRAGRUNT=0.44.0
ARG ATLANTIS_DEFAULT_TF_VERSION=1.0.0

RUN curl -LsS \
    	https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT}/terragrunt_linux_amd64 \
		-o /usr/local/bin/terragrunt \
	&& chmod +x /usr/local/bin/terragrunt

FROM base AS build
WORKDIR /root
RUN curl -LsS https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v1.16.0/terragrunt-atlantis-config_1.16.0_linux_amd64.tar.gz \
		-o terragrunt-atlantis-config.tar.gz \
	&& tar -xzvf terragrunt-atlantis-config.tar.gz --strip-components=1 \
	&& mv terragrunt-atlantis-config_1.16.0_linux_amd64 /root/terragrunt-atlantis-config

FROM base
COPY --from=build /root/terragrunt-atlantis-config /usr/local/bin/terragrunt-atlantis-config
RUN chmod +x /usr/local/bin/terragrunt-atlantis-config

 
