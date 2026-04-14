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
import {
  EvtBus,
  obtainLocalEvent,
  PluginInfo,
  PluginPosition,
  PluginSlot,
  sEventManager,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { StatusBarType } from '@ohos/systemuicommon';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { windowMgr } from '@ohos/windowscene';
import { ToggleOperation } from './BluetoothNearLinkFusionController';

const TAG = 'Ctrl.PcFusionToggleOperation';
const log: Logger = Logger.getLogHelper(LogDomain.CC);
const LOCAL_EVENT_TYPE = 'local';

export class PcFusionToggleOperation implements ToggleOperation {
  private mViewData: ToggleViewData = new ToggleViewData();

  constructor(mViewData: ToggleViewData, records: Record<string, object | null>) {
    this.mViewData = mViewData;
  }

  openDetailPage(): void {
    if (ControlCenterPluginMgr.isPcMode) {
      windowMgr.showWindowWithAnim(FASlotName.BLUETOOTH_UI_EXTENSION);
      return;
    }
    log.showDebug(TAG, 'handleLongClick: long click on pc');
    // pc点击文字弹出二级窗口，并关闭控制中心面板
    sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, false));
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    // 设置二级页面窗口位置
    let position = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL);
    if (StatusBarType.isMacStyle(AppStorage.get('statusBarType') as number)) {
      let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      position.left = controlCenterPosition.left + controlCenterPosition.width - position.width;
    }
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL,
      position: PluginPosition.POSITION_RIGHT,
      area: position,
      caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER
    });
    let info = AppStorage.get<PluginInfo>(PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL + '_info');
    windowMgr.setWindowData(PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, info);
    windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, true);
    sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, true));
  }
}