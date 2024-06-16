install:
	@pre-commit install

tfinit:
	@terraform init -backend-config="backend.backend"

tfplan:
	@terraform plan

tfapply:
	@terraform apply -auto-approve -input=false

tfdestroy:
	@terraform destroy -auto-approve -input=false

tffmt:
	@terraform fmt -recursive

tfvalidate:
	@terraform validate