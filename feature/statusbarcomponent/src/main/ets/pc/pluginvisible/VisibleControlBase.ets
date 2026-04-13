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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginProperty } from '../viewdata/PluginProperty';

const TAG = 'VisibleControlBase';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export abstract class VisibleControlBase {
  protected watchPluginInfos: Array<PluginProperty> = [];

  private pluginVisibleListener: PluginVisibleListener | null = null;

  public init(listener: PluginVisibleListener): void {
    this.pluginVisibleListener = listener;
    this.initDiff();
  }

  protected initDiff(): void {
  }

  public deInit(): void {
    this.pluginVisibleListener = null;
    this.deInitDiff();
  }

  protected deInitDiff(): void {
  }

  public addPlugins(plugins: PluginProperty[]): void {
    plugins.forEach(item => {
      ArrayUtils.addArr(this.watchPluginInfos, this.watchPluginInfos.length, item);
      this.notifyPluginAdd(item);
    });
  }

  public updatePlugins(plugins: PluginProperty[]): void {
    plugins.forEach(item => {
      const oldPlugin = ArrayUtils.update(this.watchPluginInfos, item);
      if (oldPlugin != null) {
        this.updateNewPlugin(oldPlugin, item);
      } else {
        this.notifyPluginAdd(item);
      }
    });
  }

  protected updateNewPlugin(oldPlugin: PluginProperty, newPlugin: PluginProperty): void {
    this.notifyVisibleStatus(newPlugin, newPlugin.isVisible());
  }

  protected abstract notifyPluginAdd(plugin: PluginProperty): void;

  public removePlugins(plugins: PluginProperty[]): void {
    plugins.forEach(item => {
      this.notifyPluginRemove(item);
      ArrayUtils.deleteArr(this.watchPluginInfos, item);
    });
  }

  protected notifyPluginRemove(plugin: PluginProperty): void {
  }

  protected updateVisibleStatus(slot: string, isVisible: boolean): void {
    const index = this.watchPluginInfos.findIndex(item => item.getSlot() === slot);
    if (index < 0) {
      log.showWarn(`updateVisibleStatus fail, slot:` + slot + ' isVisible:' + isVisible);
      this.watchPluginInfos.forEach(item => log.showInfo('watchPluginInfo:' + item.getSlot()));
      return;
    }
    this.notifyVisibleStatus(this.watchPluginInfos[index], isVisible);
  }

  protected notifyVisibleStatus(plugin: PluginProperty, isVisible: boolean): void {
    if (this.pluginVisibleListener == null) {
      log.error('pluginVisibleListener is null')
      return;
    }
    log.showInfo(`notifyVisibleStatus slot:${plugin.getSlot()} isVisible:${isVisible}`)
    this.pluginVisibleListener.updateVisible(plugin, isVisible);
  }

  protected getPluginBySlot(slot: string): PluginProperty | null {
    const index: number = this.watchPluginInfos.findIndex(item => item.getSlot() == slot);
    if (index == -1) {
      log.error('invalid slot:' + slot + ',ignore');
      return null;
    }
    return this.watchPluginInfos[index];
  }
}

export interface PluginVisibleListener {
  updateVisible(plugin: PluginProperty, isVisible: boolean): void;
}