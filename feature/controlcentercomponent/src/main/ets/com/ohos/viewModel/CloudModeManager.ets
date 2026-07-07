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
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import commonEventManager from '@ohos.commonEventManager';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { OutdoorConfig } from '@ohos/basicutils/src/main/ets/utils/OutdoorConfig';
import power from '@ohos.power';
import { BusinessError } from '@ohos.base';
import { FASlotName } from '@ohos/commonconstants';

const TAG = 'Ctrl.CloudModeManager';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const OUT_DOOR_POWER_MODE_CODE: number = 650;
const SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
  ]
};

@Observed
export class CloudMode {
  public isOutDoorCloudMode: boolean = CloudModeManager.isOutDoorCloudMode();
  public isOutdoorCloudMode: boolean = OutdoorConfig.getInstance().isInOutdoorMode();
}

export class CloudModeManager {
  public static CLOUD_TOGGLES: string[] = [
    FASlotName.FLASHLIGHT, FASlotName.RING_MODE, FASlotName.AIR_PLANE, FASlotName.LOCATION,
    FASlotName.SCREENSHOT, FASlotName.AUTO_ROTATE, FASlotName.NFC];
  public static CLOUD_TOP_TOGGLES_ARRAY: string[][] = [
    [FASlotName.MEDIA_ITEM_NAME, FASlotName.WIFI_UI_EXTENSION, FASlotName.BLUETOOTH_UI_EXTENSION],
    [FASlotName.SUPER_DEVICE, FASlotName.BRIGHTNESS],
    [FASlotName.FOCUS_MODE, FASlotName.SOUND]];
  public static CLOUD_CONTENT_INDEX_ARR: string[] =
    ['topToggleRow_0', 'topToggleRow_1', 'topToggleRow_2', 'addMoreTopButton', 'quickToggleRow_0', 'quickToggleRow_1'];
  private cloudMode: CloudMode = new CloudMode();
  private mSubscriber?: commonEventManager.CommonEventSubscriber;
  public static getInstance(): CloudModeManager {
    return SingletonHelper.getInstance(CloudModeManager, 'CloudModeManager');
  }

  constructor() {
    this.registerCloudChange();
  }

  public getData(): CloudMode {
    return this.cloudMode;
  }

  private registerCloudChange(): void {
    this.mSubscriber = commonEventManager.createSubscriberSync(SUBSCRIBE_INFO);
    if (!this.mSubscriber) {
      log.showError(`create subscriber error!`);
      return;
    }
    commonEventManager.subscribe(this.mSubscriber,
      (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
          return;
        }
        if (data?.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
          log.showWarn(`power mode changed, current mode: ${data.code}`);
          if (data.code === OUT_DOOR_POWER_MODE_CODE) {
            this.cloudMode.isOutDoorCloudMode = true;
          } else {
            this.cloudMode.isOutDoorCloudMode = false;
          }
        }
      });
  }

  public unRegisterDesktopModeChange(): void {
    if (this.mSubscriber) {
      commonEventManager.unsubscribe(this.mSubscriber);
      this.mSubscriber = undefined;
    }
  }

  public static isOutDoorCloudMode(): boolean {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
      log.showInfo(`isOutDoorCloudMode,currentMode is ${curPowerMode}`);
    } catch (err) {
      log.showError(`Get device power mode failed , err: ${err.code}, errMessage: ${err.message}`);
    }
    return curPowerMode as number === OUT_DOOR_POWER_MODE_CODE;
  }
}