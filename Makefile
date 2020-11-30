all: help

help:
	echo "install - install files into \$$DESTDIR"

install:
	install -D qvm-screenshot-tool.sh $(DESTDIR)/usr/bin/qvm-screenshot-tool
	VERSION=$(shell cat version); sed -i "s/@VERSION@/$$VERSION/" $(DESTDIR)/usr/bin/qvm-screenshot-tool
