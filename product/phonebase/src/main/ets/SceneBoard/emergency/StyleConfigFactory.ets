/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { CommonStyle } from '@ohos/emergencymode/src/main/ets/common/CommonStyle';
import { ThermalPhoneStyleConfig } from './styleConfig/ThermalPhoneStyleConfig';
import { ThermalFoldStyleConfig } from './styleConfig/ThermalFoldStyleConfig';
import { ThermalPadStyleConfig } from './styleConfig/ThermalPadStyleConfig';
import { ThermalThreeFoldStyleConfig } from './styleConfig/ThermalThreeFoldStyleConfig';

const TAG = 'StyleConfigFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * StyleFactory
 */
export class StyleConfigFactory {

  /**
   * Factory method, which initializes the thermal style class based on the device type.
   * @returns
   */
  public static createThermalStyle(): CommonStyle {
    let commonStyle: CommonStyle = ThermalPhoneStyleConfig.getInstance();
    if (DeviceHelper.isBarPhone() || desktopUtil.needIgnoreFoldDeviceForLauncher()) {
      commonStyle = ThermalPhoneStyleConfig.getInstance();
    } else if (DeviceHelper.isThreeFoldProduct()) {
      commonStyle = ThermalThreeFoldStyleConfig.getInstance();
    } else if (DeviceHelper.isFold()) {
      commonStyle = ThermalFoldStyleConfig.getInstance();
    } else if (DeviceHelper.isPad()) {
      commonStyle = ThermalPadStyleConfig.getInstance();
    }
    return commonStyle;
  }
}