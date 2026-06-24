ws ?= default

plan:
	tofu workspace select $(ws)
	tofu plan -var-file=$(ws).tfvars

apply:
	tofu workspace select $(ws)
	tofu apply -var-file=$(ws).tfvars

destroy:
	tofu workspace select $(ws)
	tofu destroy -var-file=$(ws).tfvars
