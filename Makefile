# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)

all: clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/jre
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/jdiskreport2
	apprepo --destination=$(PWD)/build appdir boilerplate 

	wget --output-document=$(PWD)/build/Boilerplate.AppDir/jdiskreport2/jdiskreport.jar http://www.jgoodies.com/download/jdiskreport2/jdiskreport-2beta2.jar

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm --continue https://forensics.cert.org/centos/cert/8/x86_64/jdk-12.0.2_linux-x64_bin.rpm
	cd $(PWD)/build && rpm2cpio build.rpm | cpio -idmv

	cp --recursive --force $(PWD)/build/usr/java/jdk-12.0.2/* 	$(PWD)/build/Boilerplate.AppDir/jre

	echo "#! /bin/bash" >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "set -e" >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'exec $${APPDIR}/jre/bin/java -Xmx1024M -jar $${APPDIR}/jdiskreport2/jdiskreport.jar "$${@}"' >> $(PWD)/build/Boilerplate.AppDir/AppRun

	chmod +x $(PWD)/build/Boilerplate.AppDir/AppRun

	rm --force $(PWD)/build/Boilerplate.AppDir/*.svg 		|| true
	rm --force $(PWD)/build/Boilerplate.AppDir/*.desktop    || true
	rm --force $(PWD)/build/Boilerplate.AppDir/*.png 		|| true

	cp --force $(PWD)/AppDir/*.png 		$(PWD)/build/Boilerplate.AppDir/ || true
	cp --force $(PWD)/AppDir/*.desktop 	$(PWD)/build/Boilerplate.AppDir/ || true
	cp --force $(PWD)/AppDir/*.svg 		$(PWD)/build/Boilerplate.AppDir/ || true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/JDiskReport.AppImage
	chmod +x $(PWD)/JDiskReport.AppImage

clean:
	rm -rf $(PWD)/build
