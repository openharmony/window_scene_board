/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import StatusBarIconItemBluetoothComponent
  from '@ohos/bluetoothcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemBluetoothComponent';
import { access } from '@kit.ConnectivityKit';
import { GlassStatusBarStyle } from './GlassStatusBarStyle'
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'BaseBluetooth');

/**
 * 蓝牙
 */
@Component
export default struct BluetoothIcon {
  @State isBluetoothOpen: access.BluetoothState = access.getState();
  @Provide iconsOpacityInfo: Array<PluginSlot> = [];
  private onStateChange = (data: access.BluetoothState): void => {
    this.isBluetoothOpen = data;
  }

  aboutToAppear(): void {
    try {
      access.on('stateChange', this.onStateChange);
    } catch (err) {
      log.showError(`stateChange on fail,error is ${err.message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      access.off('stateChange', this.onStateChange);
    } catch (err) {
      log.showError(`stateChange off fail,error is ${err.message}`);
    }
  }

  build() {
    if (this.isBluetoothOpen === access.BluetoothState.STATE_ON) {
      StatusBarIconItemBluetoothComponent({
        style: {
          staticBarBluetoothWidth: GlassStatusBarStyle.ICON_SIZE,
          staticBarBluetoothBatteryWidth: GlassStatusBarStyle.ICON_SIZE,
          staticBarBluetoothHeight: GlassStatusBarStyle.ICON_SIZE,
        }
      });
    }
  }
}