.ONESHELL:
SHELL = /usr/bin/bash

all : deps clean install

install : deps
	# run nginx for pay.aceitchecripto.com that will serve BPS
	docker build nginx/Dockerfile -t pay.aceitchecripto.com/nginx:latest
	docker run pay.aceitchecripto.com/nginx:latest -n pay.aceitchecripto.com/nginx -d -p 80:80 -p 443:443
	# set parameters to run btcpay-setup.sh
	export BTCPAY_HOST="pay.aceitchecripto.com"
	export REVERSEPROXY_DEFAULT_HOST="pay.aceitchecripto.com"
	export REVERSEPROXY_HTTP_PORT=10080
	export NBITCOIN_NETWORK="mainnet"
	export BTCPAYGEN_CRYPTO1="btc"
	export BTCPAYGEN_CRYPTO2="xmr"
	export BTCPAYGEN_CRYPTO3="ltc"
	export BTCPAYGEN_CRYPTO4="dash"
	export BTCPAYGEN_CRYPTO5="doge"
	export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-save-storage-s"
	export BTCPAYGEN_REVERSEPROXY="nginx"
	export BTCPAYGEN_LIGHTNING="clightning"
	export BTCPAY_ENABLE_SSH=true
	export BTCPAYGEN_EXCLUDE_FRAGMENTS="nginx-https"
	# clone the BPS repo and run setup
	rm -rf btcpayserver-docker || true
	git clone https://github.com/btcpayserver/btcpayserver-docker
	cd btcpayserver-docker
	git pull
	. ./btcpay-setup.sh -i
	cd ..

deps :
	apt install -y git nginx openssl docker docker-compose

clean :
	test -d btcpayserver-docker || git clone https://github.com/btcpayserver/btcpayserver-docker
	cd btcpayserver-docker
	git pull
	. ./btcpay-down.sh || true
	. ./btcpay-clean.sh || true
	cd ..
	rm -rf btcpayserver-docker
	rm /etc/systemd/system/btcpayserver.service && rm /etc/profile.d/btcpay-env.sh
	cd /usr/local/bin
	rm bitcoin-cli.sh bitcoinlncli.sh btcpay-* changedomain.sh
	# AVOID (loses blockchains): Delete all volumes in /var/lib/docker/volumes/ with docker-compose -f $BTCPAY_DOCKER_COMPOSE down --v