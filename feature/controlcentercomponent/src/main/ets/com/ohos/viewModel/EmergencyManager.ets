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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { FASlotName } from '@ohos/commonconstants';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';
import { DesktopModeManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DesktopModeManagerAdapter';

const TAG = 'Ctrl.EmergencyManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export const EMERGENCY_TOGGLES: string[] =
  [FASlotName.RING_MODE, FASlotName.MOBILE_DATA, FASlotName.LOCATION, FASlotName.AIR_PLANE];

export const EMERGENCY_TOP_TOGGLES: string[] =
  [FASlotName.MEDIA_ITEM_NAME, FASlotName.WIFI_UI_EXTENSION, FASlotName.BLUETOOTH_UI_EXTENSION];

@Observed
export class DesktopMode {
  public desktopMode: DesktopModeEnum = DesktopModeManagerAdapter.getDesktopMode();

  isEmergencyMode(): boolean {
    return this.desktopMode === DesktopModeEnum.EMERGENCY_MODE;
  }
}

export class EmergencyManager {
  private desktopMode: DesktopMode = new DesktopMode();

  public static getInstance(): EmergencyManager {
    return SingletonHelper.getInstance(EmergencyManager, 'EmergencyManager');
  }

  constructor() {
    this.registerDesktopModeChange();
  }

  public getData(): DesktopMode {
    return this.desktopMode;
  }

  private desktopModeChangeFunc = async (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
    log.showInfo(`preDesktopMode:${preDesktopMode},targetDesktopMode:${targetDesktopMode}`);
    this.desktopMode.desktopMode = targetDesktopMode;
  };

  /**
   * 注册紧急模式变化回调
   * @returns
   */
  private registerDesktopModeChange(): void {
    log.showInfo('register desktop mode change event');
    DesktopModeManagerAdapter
      .registerModeChangeCallback({
        registerTag: 'ControlCenter',
        callback: this.desktopModeChangeFunc
      }, `${TAG}_registerModeChangeCallback`);
  }

  public unRegisterDesktopModeChange(): void {
    DesktopModeManagerAdapter
      .unRegisterModeChangeCallback({
        registerTag: 'ControlCenter',
        callback: this.desktopModeChangeFunc
      }, `${TAG}_unRegisterModeChangeCallback`);
  }
}