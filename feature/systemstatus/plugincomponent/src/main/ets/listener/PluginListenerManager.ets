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

import { PluginBaseListener } from './PluginBaseListener';

/**
 * plugin组件交互管理接口
 *
 * @since 2022-10-28
 */
export interface PluginListenerManager<T extends PluginBaseListener> {
  /**
   * 注册监听器
   *
   * @param key 监听器唯一标示
   * @param listener 监听器
   */
  registerListener(key: string, listener: T): void;

  /**
   * 注销监听器
   *
   * @param key 监听器唯一标示
   */
  unregisterListener(key: string): void;
}