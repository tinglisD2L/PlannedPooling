DIR=$(shell pwd)

create:
	aws cloudformation create-stack --stack-name $(STACK) --template-body file:///$(DIR)/cloudformation.yaml --parameters ParameterKey=GithubOAuthToken,ParameterValue=${GITHUB_TOKEN} --capabilities CAPABILITY_IAM

update:
	aws cloudformation update-stack --stack-name $(STACK) --template-body file:///$(DIR)/cloudformation.yaml --parameters ParameterKey=GithubOAuthToken,ParameterValue=${GITHUB_TOKEN} --capabilities CAPABILITY_IAM

.build:
	npm run build

changeset:
	aws cloudformation create-change-set --stack-name $(STACK) --template-body file:///$(DIR)/cloudformation.yaml --parameters ParameterKey=GithubOAuthToken,ParameterValue=${GITHUB_TOKEN} --capabilities CAPABILITY_IAM --change-set-name hihihi6

upload: .build
	$(eval BUCKET := $(shell aws cloudformation describe-stacks --stack-name $(STACK) --query "Stacks[].Outputs[?OutputKey=='BucketName'][].OutputValue" --output text))
	aws s3 sync build/ s3://$(BUCKET)

info:
	aws cloudformation describe-stacks --stack-name $(STACK) --query "Stacks[].Outputs" --output text

hi:
	echo ${A}
