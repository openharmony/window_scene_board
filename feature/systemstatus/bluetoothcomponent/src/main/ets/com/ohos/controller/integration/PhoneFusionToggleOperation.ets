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

import { LogDomain, Logger } from '@ohos/basicutils';
import { FASlotName } from '@ohos/commonconstants';
import { HiDfxEventUtil, PluginClickInfo } from '@ohos/frameworkwrapper';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { BluetoothNearLinkFusionController, ToggleOperation } from './BluetoothNearLinkFusionController';
import { performanceMonitor } from '@kit.ArkUI';

const TAG: string = 'Ctrl.PhoneFusionToggleOperation';
const log: Logger = Logger.getLogHelper(LogDomain.CC);

export class PhoneFusionToggleOperation implements ToggleOperation {
  private mViewData: ToggleViewData = new ToggleViewData();

  constructor(mViewData: ToggleViewData, records: Record<string, object | null>) {
    this.mViewData = mViewData;
  }

  openDetailPage(): void {
    BluetoothNearLinkFusionController.getInstance().handleOnControlCenterWithScreenLockForUIE(
      (): void => this.showFusionToggleWindow(FASlotName.BLUETOOTH_UI_EXTENSION), true);
  }

  private showFusionToggleWindow(slot: string): void {
    log.showInfo(TAG, `showFusionWindow, slot${slot}`);
    HiDfxEventUtil.reportQuickToggleSubMenuClick(slot);
    performanceMonitor.begin('INTO_CC_SUB_BLUETOOTH_ANI', performanceMonitor.ActionType.LAST_UP);
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.BLUETOOTH_UI_EXTENSION, {
      clickType: 'window',
      bundleName: 'com.ohos.settings',
      abilityName: 'BluetoothUIExtensionSettingsAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: 398
    } as PluginClickInfo);
  }
}