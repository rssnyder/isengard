ws ?= default

# use the local localdhcp provider build, drop once published
export TF_CLI_CONFIG_FILE := $(CURDIR)/dev.tfrc

plan:
	tofu workspace select $(ws)
	tofu plan -var-file=$(ws).tfvars

apply:
	tofu workspace select $(ws)
	tofu apply -var-file=$(ws).tfvars

destroy:
	tofu workspace select $(ws)
	tofu destroy -var-file=$(ws).tfvars
