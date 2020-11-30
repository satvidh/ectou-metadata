PREFIX=satvidh
VERSION=1.0.0

# Export variables for use by sub-make files.
export PREFIX
export VERSION

build-update-iptables:
	cd update-iptables; $(MAKE) build

build-example-app:
	cd examples/example-app; $(MAKE) build

build: build-update-iptables build-example-app

clean:
	cd examples/example-app; $(MAKE) clean
	cd update-iptables; $(MAKE) clean
	
deploy-example-app:
	cd examples/example-app; $(MAKE) deploy CHARTS_PATH=../../charts

.PHONY: build build-update-iptables build-example-app