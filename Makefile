.PHONY: fmt validate app-test docker-build

fmt:
	terraform fmt -recursive terraform

validate:
	cd terraform/environments/platform && terraform init -backend=false && terraform validate

app-test:
	python -m unittest discover -s app -p 'test_*.py' -v

docker-build:
	docker build -t gitops-platform-demo:local app
