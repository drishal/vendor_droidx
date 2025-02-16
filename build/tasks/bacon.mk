# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------
# Lineage OTA update package
ifeq ($(DROIDX_ZIP_TYPE), Gapps)
DROIDX_TARGET_PACKAGE := $(PRODUCT_OUT)/droidx-$(DROIDX_VERSION)-Gapps.zip
else
DROIDX_TARGET_PACKAGE := $(PRODUCT_OUT)/droidx-$(DROIDX_VERSION)-Vanilla.zip
endif

DROIDX_OTA_PACKAGE := droidx-$(DROIDX_VERSION)-$(DROIDX_ZIP_TYPE).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

.PHONY: bacon
bacon: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(DROIDX_TARGET_PACKAGE)
	$(hide) $(SHA256) $(DROIDX_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(DROIDX_TARGET_PACKAGE).sha256sum
	$(hide) ./vendor/droidx/build/tools/generate_json.sh $(TARGET_DEVICE) $(PRODUCT_OUT) $(DROIDX_OTA_PACKAGE)
	echo -e ${CL_BLD}${CL_RED}"===============================-Package complete-==============================="${CL_RED}
	echo -e ${CL_BLD}${CL_GRN}"Zip: "${CL_RED} $(DROIDX_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"SHA256: "${CL_RED}" `cat $(DROIDX_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Size:"${CL_RED}" `du -sh $(DROIDX_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"TimeStamp:"${CL_RED}" `cat $(PRODUCT_OUT)/system/build.prop | grep ro.system.build.date.utc | cut -d'=' -f2 | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Integer Value:"${CL_RED}" `wc -c $(DROIDX_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_RED}"================================================================================"${CL_RED}
