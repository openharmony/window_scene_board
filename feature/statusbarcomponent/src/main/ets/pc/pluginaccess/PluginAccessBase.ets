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
import { PluginInfo, PluginType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PluginProperty } from '../viewdata/PluginProperty';
import { StatusBarPluginEventListener } from '../pluginData/StatusBarPluginEventListener';
import pluginSortManager from '../../viewmodel/PluginSortManager';

export abstract class PluginAccessBase {
  private pluginEventListener: StatusBarPluginEventListener | null = null;

  public init(listener: StatusBarPluginEventListener): void {
    this.pluginEventListener = listener;
    this.initDiff();
  }

  protected abstract initDiff(): void;

  public deInit(): void {
    this.pluginEventListener = null;
    this.deInitDiff();
  }

  protected abstract deInitDiff(): void;

  protected notifyAddData(data: PluginInfo[]) {
    data.forEach(plugin => {
      const capsulePriorityArray: string[] = pluginSortManager.getDynamicSortPlugins();
      if (plugin?.pluginParseInfo?.pluginType === PluginType.PLUGIN_TYPE_IMMEDIATELY) {
        let slotPriority = capsulePriorityArray.indexOf(plugin.getSlot());
        if (slotPriority != -1) {
          plugin.pluginParseInfo.pluginPriority = slotPriority;
        }
      }
    });
    this.pluginEventListener?.addPlugins(this.getPluginProperty(data));
  }

  protected notifyRemoveData(data: PluginInfo[]) {
    this.pluginEventListener?.removePlugins(this.getPluginProperty(data));
  }

  protected notifyUpdateData(data: PluginInfo[]) {
    this.pluginEventListener?.updatePlugins(this.getPluginProperty(data));
  }

  private getPluginProperty(data: PluginInfo[]): PluginProperty[] {
    return data.map((item) => new PluginProperty(item));
  }
}