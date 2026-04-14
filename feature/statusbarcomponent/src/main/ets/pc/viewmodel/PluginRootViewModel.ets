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
import {
  CapsuleVisibleEvent,
  EvtBus,
  PluginChangeEvent,
  PluginComponentInfo,
  PluginContentEvent,
  PluginRequestEvent,
  IconRedHotEvent
} from '@ohos/frameworkwrapper';
import { StatusBarEventManager } from '../manager/StatusBarEventManager';
import { PluginVM } from '@ohos/plugincomponent/src/main/ets/vm/PluginVM';
import { PluginProperty } from '../viewdata/PluginProperty';

const TAG = 'PluginRootViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


export class PluginRootViewModel {
  /**
   * 图标数据处理
   */
  private pluginVM: PluginVM | null = null;
  private property: PluginProperty | null = null;
  private rootParentId: string = '';

  constructor(property: PluginProperty, rootParentId: string) {
    this.property = property;
    this.rootParentId = rootParentId;
    this.pluginVM = new PluginVM();
  }

  onDestroy(): void {
    StatusBarEventManager.getInstance().offAll(this.property?.getSlot()!);
    this.pluginVM?.onDestroy();
  }

  init(): void {
    // 注册远程plugin push事件
    if (this.property && this.property.pluginInfo) {
      this.pluginVM?.init(this.property.pluginInfo);
    }

    StatusBarEventManager.getInstance()
      .on(this.property?.getSlot()!, PluginRequestEvent,
        this.onPluginRequestEvent, this.property?.getSlot())// 注册远程plugin push事件
      .on(this.property?.getSlot()!, IconRedHotEvent, this.onIconRedHotEvent)
      .on(this.property?.getSlot()!, PluginChangeEvent, this.onPluginChangeEvent)// 右键菜单更新事件
      .on(this.property?.getSlot()!, PluginContentEvent, this.onPluginContentEvent)
      .addOff(this.property?.getSlot()!, this.pluginVM?.registerOnRemotePushListener(this.onRemotePushListener)!);
  }

  /**
   * 图标红点事件
   *
   * @param event 事件
   */
  private onIconRedHotEvent = (event: IconRedHotEvent): void => {
    AppStorage.setOrCreate('hasUnReadNotification', event.isShowRedHot);
  }

  /**
   * 图标颜色变更事件
   *
   * @param 事件
   */
  private onPluginContentEvent = async (event: PluginContentEvent) => {
    // 对象匹配，slot标示匹配
    if (!event.pluginSlotMap) {
      log.showDebug('onPluginContentEvent pluginSlotMap is null');
      return;
    }

    let slot = this.property?.getSlot() ?? '';
    // 各图标颜色统一
    if (!event.pluginSlotMap?.has(slot)) {
      log.showError('event invalid has no slot: ' + slot);
      return;
    }
    let newContentColor: string | undefined = event.pluginSlotMap.get(slot);
    if (!newContentColor) {
      log.showInfo('onPluginContentEvent newContentColor: ' + slot);
      return;
    }
    if (this.rootParentId !== event.rootParentId) {
      log.showInfo('onPluginContentEvent this root:' + this.rootParentId + ' not equal to ' + event.rootParentId);
      return;
    }
    if (this.property) {
      this.property.contentColor = newContentColor;
    }
  }

  /**
   * 远程push事件回调
   *
   * @param info 数据
   */
  private onRemotePushListener = async (info: PluginComponentInfo) => {
    log.showDebug(`onRemotePushListener ${info}`);
    // 图标可见性控制
    this.pushVisibleEvent(info?.requestVisible);
    // CapsuleComponent方案要整改
  }

  /**
   * 是否有双击事件
   */
  private pushVisibleEvent(visible: boolean): void {
    EvtBus.post(CapsuleVisibleEvent, { visible: visible, pluginSlot: this.property?.getSlot() } as CapsuleVisibleEvent);
  }

  /**
   * 右键菜单更新时间
   *
   * @param event 事件
   */
  private onPluginChangeEvent = async (event: PluginChangeEvent) => {
    this.property?.getGroupMenuInfo();
  }

  /**
   * plugin图标请求事件回调
   *
   * @param event 事件
   */
  private onPluginRequestEvent = async (event: PluginRequestEvent) => {
    log.showInfo(`OPRE=>${event.pluginSlot}-${event.isVisible()}-${this.property?.getSlot()}-${event.requestType}`);
    if (!event) {
      log.showError('onPluginRequestEvent event or property invalid');
      return;
    }
    if (event.pluginSlot != this.property?.getSlot()) {
      return;
    }
    // 图标可见性事件
    if (event.requestType === PluginRequestEvent.REQUEST_TYPE_VISIBILITY) {
      // 更新可见性
      log.showInfo('onPluginRequestEvent slot: ' + event.pluginSlot + ', visible: ' + event.isVisible());
      // CapsuleComponent方案要整改
      this.pushVisibleEvent(event.isVisible());
    }
  }
}