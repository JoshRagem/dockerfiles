BUILD_TAG ?= 20180512

.PHONE: clean push push_base push_proxy push_logger push_irc

build: base_$(BUILD_TAG).tar proxy_$(BUILD_TAG).tar logger_$(BUILD_TAG).tar irc_$(BUILD_TAG).tar

clean:
	rm *.tar; rm keys/*

base_$(BUILD_TAG).tar: Dockerfile.base prestart.sh
	docker build -t joshragem/base:$(BUILD_TAG) -f Dockerfile.base . && \
        docker image save joshragem/base:$(BUILD_TAG) > base_$(BUILD_TAG).tar

proxy_$(BUILD_TAG).tar: Dockerfile.proxy base_$(BUILD_TAG).tar proxy/
	docker build -t joshragem/proxy:$(BUILD_TAG) -f Dockerfile.proxy . && \
        docker image save joshragem/proxy:$(BUILD_TAG) > proxy_$(BUILD_TAG).tar

logger_$(BUILD_TAG).tar: Dockerfile.logger base_$(BUILD_TAG).tar logger/ keys/fluentbit.pub
	docker build -t joshragem/logger:$(BUILD_TAG) -f Dockerfile.logger . && \
        docker image save joshragem/logger:$(BUILD_TAG) > logger_$(BUILD_TAG).tar

irc_$(BUILD_TAG).tar: Dockerfile.irc base_$(BUILD_TAG).tar irc/
	docker build -t joshragem/irc:$(BUILD_TAG) -f Dockerfile.irc . && \
        docker image save joshragem/irc:$(BUILD_TAG) > irc_$(BUILD_TAG).tar

keys/fluentbit.pub:
	wget -qO - http://packages.fluentbit.io/fluentbit.key > keys/fluentbit.pub

push: push_base push_proxy push_logger

push_base: base_$(BUILD_TAG).tar
	docker push joshragem/base:$(BUILD_TAG)

push_proxy: proxy_$(BUILD_TAG).tar
	docker push joshragem/proxy:$(BUILD_TAG)

push_logger: logger_$(BUILD_TAG).tar
	docker push joshragem/logger:$(BUILD_TAG)

push_irc: irc_$(BUILD_TAG).tar
	docker push joshragem/irc:$(BUILD_TAG)

