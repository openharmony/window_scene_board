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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CapsuleVisibleEvent, EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { appMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PluginProperty } from '../viewdata/PluginProperty';
import { VisibleControlBase } from './VisibleControlBase';

const TAG = 'DynamicVisibleControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class DynamicVisibleControl extends VisibleControlBase {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  protected initDiff(): void {
    this.registerCapsuleVisibleEvent();
  }

  /**
   * 注册app监听
   */
  private registerCapsuleVisibleEvent(): void {
    this.eventMgr.on(CapsuleVisibleEvent, this.onCapsuleVisibleEvent);
  }

  private onCapsuleVisibleEvent = (event: CapsuleVisibleEvent) => {
    this.updateVisibleStatus(event.pluginSlot, event.visible);
  }

  protected async notifyPluginAdd(plugin: PluginProperty): Promise<void> {
    let isProcessing = await appMgr.isProcessing(plugin?.pluginInfo?.pluginParseInfo);
    this.updateVisibleStatus(plugin?.getSlot(), isProcessing);
  }

  protected deInitDiff(): void {
    this.eventMgr.offAll();
  }
}