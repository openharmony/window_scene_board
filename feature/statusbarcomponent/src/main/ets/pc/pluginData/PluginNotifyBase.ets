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
import { PluginProperty } from '../viewdata/PluginProperty';
import { PluginListAdapter } from './PluginListAdapter'
import { ListenerPriority, StatusBarPluginEventListener } from './StatusBarPluginEventListener'

export abstract class PluginNotifyBase implements StatusBarPluginEventListener {
  addPlugins(pluginInfos: PluginProperty[]): void {
    this.addPlugin(pluginInfos);
  }

  removePlugins(pluginInfos: PluginProperty[]): void {
    this.removePlugin(pluginInfos);
  }

  updatePlugins(pluginInfos: PluginProperty[]): void {
    this.updatePlugin(pluginInfos);
  }

  protected abstract addPlugin(pluginInfos: PluginProperty[]): void;

  protected abstract removePlugin(pluginInfos: PluginProperty[]): void;

  protected abstract updatePlugin(pluginInfos: PluginProperty[]): void;

  public init(): void {
    this.initDiff();
    this.registerStatusBarPluginEventListener();
  }

  protected abstract initDiff(): void;

  public deInit(): void {
    this.unRegisterStatusBarPluginEventListener();
    this.deInitDiff();
  }

  protected abstract deInitDiff(): void;

  private registerStatusBarPluginEventListener(): void {
    PluginListAdapter.getInstance().registerDataChangeListener(this);
  }

  private unRegisterStatusBarPluginEventListener(): void {
    PluginListAdapter.getInstance().unregisterDataChangeListener(this);
  }

  getPriority(): ListenerPriority {
    return ListenerPriority.PLUGIN_COMMON;
  }
}