build:
	docker build --no-cache -t agrdocker/agr_base_linux_env:develop .

push: build
	docker push agrdocker/agr_base_linux_env:develop

bash:
	docker run -t -i agrdocker/agr_base_linux_env:develop bash
