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

import { PluginVM } from '@ohos/plugincomponent/src/main/ets/vm/PluginVM';
import { PluginProperty } from '../../viewdata/PluginProperty';
import { VisibleControlBase } from '../VisibleControlBase';
import { CustomMessageBase } from './CustomMessageBase';
import { CaptureCustomMessage } from './CaptureCustomMessage';
import { FocusEnableCustomMessage } from './FocusEnableCustomMessage';
import { VirtualKeyBoardCustomMessage } from './VirtualKeyBoardCustomMessage';
import { SuperPrivacySoftCustomMessage } from './SuperPrivacySoftCustomMessage';
import { SuperPrivacyPaddleCustomMessage } from './SuperPrivacyPaddleCustomMessage';
import { EnterpriseSpaceCustomMessage } from './EnterpriseSpaceCustomMessage';
import {
  CapsuleVisibleEvent,
  EventManager, EvtBus, PluginComponentInfo, PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import pluginSortManager from '../../../viewmodel/PluginSortManager';
import { windowMgr } from '@ohos/windowscene';
import sEventHandler from '../../manager/StatusBarEventPoster';
import { LocationCustomMessage } from './LocationCustomMessage';
import { USBCustomMessage } from './USBCustomMessage';

const TAG = 'MessageVisibleControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class MessageVisibleControl extends VisibleControlBase {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private customMessageMap: Map<string, CustomMessageBase> = new Map()
    .set(PluginSlot.SLOT_STATUS_MICROPHONE_PANEL, new CaptureCustomMessage())
    .set(PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, new SuperPrivacyPaddleCustomMessage())
    .set(PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, new SuperPrivacySoftCustomMessage())
    .set(PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE, new FocusEnableCustomMessage())
    .set(PluginSlot.SLOT_STATUS_LOCATION, new LocationCustomMessage())
    .set(PluginSlot.SLOT_STATUS_USB, new USBCustomMessage())
    .set(PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE, new EnterpriseSpaceCustomMessage())
    .set(PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD, new VirtualKeyBoardCustomMessage());

  private noNeedListenCapsuleEvent: Set<string> = new Set([
    PluginSlot.SLOT_STATUS_PRINT,
    PluginSlot.SLOT_STATUS_BAR_COLLABORATION,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
    PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE,
    PluginSlot.SLOT_STATUS_MICROPHONE_PANEL,
    PluginSlot.SLOT_PLUGIN_STATUS_BAR_CAST,
    PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD
  ]);

  private pluginVMMap: Map<string, PluginVM> = new Map();

  protected initDiff(): void {
    this.registerCapsuleVisibleEvent();
  }

  protected notifyPluginAdd(plugin: PluginProperty): void {
    this.notifyVisibleStatusChange(plugin.getSlot(), false);
    this.customMessageHandle(plugin);
    this.registerRemotePushEvent(plugin);
  }

  protected notifyPluginRemove(plugin: PluginProperty): void {
    this.customMessageMap.get(plugin?.getSlot())?.deInit();
    this.unRegisterRemotePushEvent(plugin);
  }

  private customMessageHandle(plugin: PluginProperty): boolean {
    return this.customMessageMap.get(plugin?.getSlot())?.init({
      updateVisible: (visible: boolean) => {
        this.notifyVisibleStatusChange(plugin?.getSlot(), visible);
      },
      addRequestPid: (pid: number) => {
        let pluginInfo = this.getPluginBySlot(plugin?.getSlot());
        pluginInfo?.addRequestPid(pid);
      },
      deleteRequestPid: (pid: number) => {
        let pluginInfo = this.getPluginBySlot(plugin?.getSlot());
        pluginInfo?.deleteRequestPid(pid);
      }
    }) ?? false;
  }

  /**
   * 注册app监听
   */
  private registerCapsuleVisibleEvent(): void {
    this.eventMgr.on(CapsuleVisibleEvent, this.onCapsuleVisibleEvent);
  }

  private registerRemotePushEvent(plugin: PluginProperty): void {
    if (plugin?.pluginInfo == null) {
      return;
    }
    // 注册远程plugin push事件
    let pluginVM: PluginVM = new PluginVM();
    pluginVM.init(plugin?.pluginInfo);
    this.eventMgr.addOff(pluginVM.registerOnRemotePushListener(this.onRemotePushListener));
    this.pluginVMMap.set(plugin.getSlot(), pluginVM);
  }

  private unRegisterRemotePushEvent(plugin: PluginProperty): void {
    this.pluginVMMap.get(plugin.getSlot())?.onDestroy();
    this.pluginVMMap.delete(plugin.getSlot());
  }

  private onCapsuleVisibleEvent = (event: CapsuleVisibleEvent) => {
    if (event.visible) {
      log.warn('message plugin visible no need reply capsuleVisibleEvent, slot:' + event.pluginSlot);
      return;
    }

    if (this.noNeedListenCapsuleEvent.has(event.pluginSlot)) {
      log.warn('no need listen capsule event, slot:' + event.pluginSlot);
      return;
    }

    let pluginInfo = this.getPluginBySlot(event.pluginSlot);
    if (!ArrayUtils.isEmpty(pluginInfo?.requestPids)) {
      const index = pluginInfo!.requestPids.indexOf(event.requestPid as number);
      if (index === -1) {
        log.showError('died process pid: ' + event.requestPid + ' not in requestPids');
        return;
      }
    }
    this.notifyVisibleStatusChange(event.pluginSlot, event.visible);
  }

  private notifyVisibleStatusChange(slot: string, isVisible: boolean): void {
    if (isVisible) {
      pluginSortManager.pushDynamicSortPlugin(slot ?? '');
      sEventHandler.getInstance().postCapsuleSortEvent(this
        .getPluginBySlot(slot)?.pluginInfo?.pluginParseInfo?.pluginPosition ?? '');
    } else {
      pluginSortManager.deleteDynamicSortPlugin(slot ?? '');
      const windowName: string = slot ?? '';
      if (windowMgr.isShowing(windowName)) {
        if (windowName !== PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE) {
          log.showInfo(`onVisibleChange close window ${windowName}`);
          windowMgr.hideWindowImmediately(windowName);
        }
      }
    }
    this.updateVisibleStatus(slot, isVisible);
  }

  /**
   * 远程push事件回调
   *
   * @param info 数据
   */
  private onRemotePushListener = (info: PluginComponentInfo): void => {
    log.showInfo(`onRemotePushListener ${info?.requestVisible}`);

    let pluginInfo = this.getPluginBySlot(info?.getSlot());
    if (pluginInfo == null) {
      log.showError('pluginInfo is null');
      return;
    }
    // 图标可见性控制
    this.notifyVisibleStatusChange(info?.getSlot(), info?.requestVisible);
    if (!CommonUtils.isInvalid(info?.requestPid)) {
      pluginInfo.addRequestPid(info.requestPid as number);
    }
  }

  protected deInitDiff(): void {
    this.eventMgr.offAll();
    this.pluginVMMap.forEach(item => item?.onDestroy());
    this.pluginVMMap.clear();
  }
}