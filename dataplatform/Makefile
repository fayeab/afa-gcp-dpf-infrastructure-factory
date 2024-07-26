install:
	@pre-commit install

tfinit:
	@TF_DATA_DIR=.terraform-${ENV} terraform init -backend-config="envs/${ENV}.backend"

tfplan:
	@TF_DATA_DIR=.terraform-${ENV} terraform plan -var-file="envs/${ENV}.tfvars"

tfapply:
	@TF_DATA_DIR=.terraform-${ENV} terraform apply -var-file="envs/${ENV}.tfvars" -auto-approve -input=false

tfdestroy:
	@TF_DATA_DIR=.terraform-${ENV} terraform destroy -var-file="envs/${ENV}.tfvars" -auto-approve -input=false

tffmt:
	@terraform fmt -recursive

tfvalidate:
	@terraform validate

# export ENV=dev  <dev|uat|prd>