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
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import { PluginProperty } from '../viewdata/PluginProperty';
import { ConfigAccess } from './ConfigAccess';
import { PluginAccessBase } from './PluginAccessBase';
import { MessageAccess } from './MessageAccess';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { ListenerPriority, StatusBarPluginEventListener } from '../pluginData/StatusBarPluginEventListener';

export class StatusBarPluginAccessManager implements StatusBarPluginEventListener {
  private static mInstance: StatusBarPluginAccessManager;

  private pluginAccessMap: Array<PluginAccessBase> = [new ConfigAccess(), new MessageAccess()];

  public static getInstance(): StatusBarPluginAccessManager {
    if (!StatusBarPluginAccessManager.mInstance) {
      StatusBarPluginAccessManager.mInstance = new StatusBarPluginAccessManager();
    }
    return StatusBarPluginAccessManager.mInstance;
  }

  public init(): void {
    this.pluginAccessMap.forEach(item => item.init(this));
  }

  public deInit(): void {
    this.pluginAccessMap.forEach(item => item.deInit());
  }

  addPlugins(pluginInfos: PluginProperty[]): void {
    pluginInfos.filter(property => property.getSlot() == PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL ||
      property.getSlot() == PluginSlot.SLOT_STATUS_WIFI_PANEL)
        .forEach(item => AppStorage.setOrCreate(item.getSlot() + '_info', item.pluginInfo));
    PluginListAdapter.getInstance().addData(pluginInfos);
  }

  removePlugins(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(item => {
      PcStatusBarDragMgr.getInstance().removeDragPlugin(item);
      item.onDestroy();
    });
    PluginListAdapter.getInstance().removeData(pluginInfos);
  }

  updatePlugins(pluginInfos: PluginProperty[]): void {
    PluginListAdapter.getInstance().updateData(pluginInfos);
  }

  getPriority(): ListenerPriority {
    return ListenerPriority.PLUGIN_COMMON;
  }
}