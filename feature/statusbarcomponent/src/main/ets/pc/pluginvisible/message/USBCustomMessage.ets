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
import { LogDomain, Logger } from '@ohos/basicutils';
import { CapsuleVisibleEvent, EventManager, EvtBus, PluginSlot } from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import pluginSortManager from '../../../viewmodel/PluginSortManager';
import sEventHandler from '../../manager/StatusBarEventPoster';
import { PluginListAdapter } from '../../pluginData/PluginListAdapter';
import { CustomMessageBase } from './CustomMessageBase';
import { USBController } from '@ohos/usbcomponent/src/main/ets/controller/USBController';

const TAG = 'USBCustomMessage';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export class USBCustomMessage extends CustomMessageBase {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private mUSBController: USBController = USBController.getInstance();

  protected initDiff(): boolean {
    this.registerCapsuleVisibleEvent();
    log.showInfo(TAG, 'USBCustomMessage init success!');
    // USBController的启动会早于USB事件管理器，初始化成功后，再次发送事件
    this.mUSBController.handleStatusBarState();
    return true;
  }

  protected deInitDiff(): void {
    this.eventMgr.offAll();
    log.showInfo(TAG, 'USBCustomMessage deInit success!');
  }

  private registerCapsuleVisibleEvent(): void {
    this.eventMgr.on(CapsuleVisibleEvent, this.onCapsuleVisibleEvent);
  }

  private onCapsuleVisibleEvent = (event: CapsuleVisibleEvent) => {
    let pluginSlot: string = event.pluginSlot ?? '';
    let visible: boolean = event.visible ?? false;
    if (event.pluginSlot !== PluginSlot.SLOT_STATUS_USB) {
      return;
    }
    let pluginProperty = PluginListAdapter.getInstance().getPluginPropertyBySlot(pluginSlot);
    if (visible) {
      pluginSortManager.pushDynamicSortPlugin(pluginSlot);
      sEventHandler.getInstance()
        .postCapsuleSortEvent(pluginProperty?.pluginInfo?.pluginParseInfo?.pluginPosition ?? '');
    } else {
      pluginSortManager.deleteDynamicSortPlugin(pluginSlot);
      if (windowMgr.isShowing(pluginSlot)) {
        log.showInfo(TAG, `onVisibleChange close window ${pluginSlot}`);
        windowMgr.hideWindowImmediately(pluginSlot);
      }
    }
    log.showInfo(TAG, `onCapsuleVisibleEvent, slot: ${pluginSlot}, visible: ${visible}`);
    this.updateVisible(visible);
  }
}