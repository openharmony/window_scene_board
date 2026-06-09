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

/**
 * 通知注冊方图标接入刷新
 */
export interface StatusBarPluginEventListener {

  addPlugins(pluginInfos: PluginProperty[]): void;

  removePlugins(pluginInfos: PluginProperty[]): void;

  updatePlugins(pluginInfos: PluginProperty[]): void;

  getPriority(): ListenerPriority;
}

// 值越小，优先级越高
export enum ListenerPriority {
  PLUGIN_VISIBLE = 0,
  PLUGIN_GROUP,
  PLUGIN_WINDOW,
  PLUGIN_DRAG,
  PLUGIN_COMMON // 不关注回调顺序
}