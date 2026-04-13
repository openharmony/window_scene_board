/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsUtil } from '@ohos/frameworkwrapper';
import { settings, usbManager } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';

const GLASS_VID: number = 0x4817;
const GLASS_PID: number = 0x4242;
const PRIVACY_AGREEMENT_VALUE_NAME: string = 'visionglass.data.space_mode_prerequisites';
const PRIVACY_AGREEMENT_VALUE_TRUE: string = '1';
const VISION_GLASS_BUNDLE_NAME: string = 'com.ohos.visionglass';
const TAG = 'CheckGlassPort';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export function checkIsGlassPort(): boolean {
  try {
    let usbDevices: usbManager.USBDevice[] = usbManager.getDevices();
    if (!usbDevices) {
      log.showWarn(`checkIsGlassPort usbDevices is invalid`);
      return false;
    }
    let info: bundleManager.BundleInfo | undefined =
      bundleManager.getBundleInfoSync(VISION_GLASS_BUNDLE_NAME, bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    if (!info) {
      log.showWarn(`checkIsGlassPort visionglass is not exist`);
      return false;
    }
    let privacyValue: string = SettingsUtil.getValueEx(settings.domainName.USER_PROPERTY, PRIVACY_AGREEMENT_VALUE_NAME);
    if (privacyValue !== PRIVACY_AGREEMENT_VALUE_TRUE) {
      log.showWarn(`checkIsGlassPort privacyValue is fasle`);
      return false;
    }
    let glassPort: usbManager.USBDevice | undefined =
      usbDevices.find(device => device.productId === GLASS_PID && device.vendorId === GLASS_VID);
    log.showInfo(`checkIsGlassPort: ${glassPort !== undefined}`);
    return glassPort !== undefined;
  } catch (err) {
    log.showError(`checkIsGlassPort fail,errorCode is ${err.code}`);
    return false;
  }
}