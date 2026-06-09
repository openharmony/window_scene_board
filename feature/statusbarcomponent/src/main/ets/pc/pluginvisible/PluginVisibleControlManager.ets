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
import { PluginSlot, PluginType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

import { appMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PcStatusBarIconManager } from '../manager/PcStatusBarIconManager';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { PluginNotifyBase } from '../pluginData/PluginNotifyBase';
import { ListenerPriority } from '../pluginData/StatusBarPluginEventListener';
import { PluginGroupType } from '../common/PluginConstants';
import { PluginProperty } from '../viewdata/PluginProperty';
import { AccessVisibleControl } from './AccessVisibleControl';
import { DynamicVisibleControl } from './DynamicVisibleControl';
import { ImmediatelyVisibleControl } from './ImmediatelyVisibleControl';
import { LocalVisibleControl } from './LocalVisibleControl';
import { MessageVisibleControl } from './message/MessageVisibleControl';
import { PluginVisibleListener, VisibleControlBase } from './VisibleControlBase';

const TAG = 'PluginVisibleControlManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

enum PluginAccessType {
  PLUGIN_LOCAL,
  PLUGIN_ACCESS,
  PLUGIN_IMMEDIATELY,
  PLUGIN_MESSAGE,
  PLUGIN_DYNAMIC
}

export class PluginVisibleControlManager extends PluginNotifyBase implements PluginVisibleListener {
  private pluginVisibleControlMap: Map<PluginAccessType | null, VisibleControlBase> = new Map()
    .set(PluginAccessType.PLUGIN_LOCAL, new LocalVisibleControl())
    .set(PluginAccessType.PLUGIN_ACCESS, new AccessVisibleControl())
    .set(PluginAccessType.PLUGIN_IMMEDIATELY, new ImmediatelyVisibleControl())
    .set(PluginAccessType.PLUGIN_MESSAGE, new MessageVisibleControl())
    .set(PluginAccessType.PLUGIN_DYNAMIC, new DynamicVisibleControl());

  private static mInstance: PluginVisibleControlManager;

  public static getInstance(): PluginVisibleControlManager {
    if (!PluginVisibleControlManager.mInstance) {
      PluginVisibleControlManager.mInstance = new PluginVisibleControlManager();
    }
    return PluginVisibleControlManager.mInstance;
  }

  protected addPlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(item => {
      this.pluginVisibleControlMap.get(this.getPluginType(item))?.addPlugins([item])
    });

    let dynamicInfos = pluginInfos.filter(plugin => plugin.getSlot() !== PluginSlot.SLOT_STATUS_LOCATION &&
      PluginType.isPluginType(plugin.pluginInfo?.pluginParseInfo.pluginType)).map(plugin => plugin.pluginInfo!);
    appMgr.registerApplicationStateObserver(dynamicInfos.map(info => info?.pluginParseInfo));
  }

  protected removePlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(item => this.pluginVisibleControlMap.get(this.getPluginType(item))?.removePlugins([item]));

    appMgr.unregisterApplicationStateObserver(pluginInfos.map(info => info.pluginInfo?.pluginParseInfo));
  }

  protected updatePlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(item => this.pluginVisibleControlMap.get(this.getPluginType(item))?.updatePlugins([item]));
  }

  protected initDiff(): void {
    log.showInfo('initDiff');
    this.pluginVisibleControlMap.forEach((value) => value.init(this));
  }

  protected deInitDiff(): void {
    log.showInfo('deInitDiff');
    this.pluginVisibleControlMap.forEach((value) => value.deInit());
  }

  updateVisible(plugin: PluginProperty, isVisible: boolean): void {
    plugin?.setVisible(isVisible);
  }

  private getPluginType(pluginInfo: PluginProperty): PluginAccessType | null {
    if (pluginInfo.isPluginTypeAccess()) {
      return PluginAccessType.PLUGIN_ACCESS;
    }
    log.showInfo('getPluginType, slot:' + pluginInfo?.getSlot() + ' type:' +
      pluginInfo?.pluginInfo?.pluginParseInfo?.pluginType + ' isLocal:' + pluginInfo.isLocalPlugin());
    switch (pluginInfo?.pluginInfo?.pluginParseInfo?.pluginType) {
      case PluginType.PLUGIN_TYPE_IMMEDIATELY:
        return PluginAccessType.PLUGIN_IMMEDIATELY;
      case PluginType.PLUGIN_TYPE_DYNAMIC:
        return PluginAccessType.PLUGIN_DYNAMIC;
      case PluginType.PLUGIN_TYPE_MESSAGE:
        return PluginAccessType.PLUGIN_MESSAGE;
      default:
        return pluginInfo.isLocalPlugin() ? PluginAccessType.PLUGIN_LOCAL : PluginAccessType.PLUGIN_IMMEDIATELY;
    }
  }

  getPriority(): ListenerPriority {
    return ListenerPriority.PLUGIN_VISIBLE;
  }
}