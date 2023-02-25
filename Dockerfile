FROM ghcr.io/runatlantis/atlantis:latest

ARG TERRAGRUNT=0.44.0

RUN curl -LsS \
    	https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT}/terragrunt_linux_amd64 \
		-o /usr/local/bin/terragrunt \
	&& chmod +x /usr/local/bin/terragrunt

