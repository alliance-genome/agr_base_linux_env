REG := 100225593120.dkr.ecr.us-east-1.amazonaws.com

build:
	docker build --no-cache -t ${REG}/agr_base_linux_env .

registry-docker-login:
ifneq ($(shell echo ${REG} | egrep "ecr\..+\.amazonaws\.com"),)
	@$(eval DOCKER_LOGIN_CMD=docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli)
ifneq (${AWS_PROFILE},)
	@$(eval DOCKER_LOGIN_CMD=${DOCKER_LOGIN_CMD} --profile ${AWS_PROFILE})
endif
	@$(eval DOCKER_LOGIN_CMD=${DOCKER_LOGIN_CMD} ecr get-login-password | docker login -u AWS --password-stdin https://${REG})
	${DOCKER_LOGIN_CMD}
endif

push: registry-docker-login build
	docker push ${REG}/agr_base_linux_env

bash:
	docker run -t -i ${REG}/agr_base_linux_env bash
