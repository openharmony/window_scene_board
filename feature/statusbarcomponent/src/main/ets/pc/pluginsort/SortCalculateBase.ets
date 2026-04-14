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
import { GroupProperty } from '../plugingroup/viewdata/GroupProperty'
import { PluginProperty } from '../viewdata/PluginProperty';

export abstract class SortCalculateBase {
  /**
   * 对当前分组内的图标进行排序
   *
   * @param pluginGroup 指定分组
   */
  public abstract sortPluginGroup(pluginGroup: GroupProperty): void;

  /**
   * plugin集排序
   *
   * @param pluginArray plugin集
   */
  protected sortPluginArray(pluginArray: PluginProperty[]): void {
    // 优先级排序
    pluginArray.sort((pluginA, pluginB): number => {
      const pluginAPriority = pluginA.pluginInfo?.pluginParseInfo.pluginPriority ?? Number.MAX_VALUE;
      const pluginBPriority = pluginB.pluginInfo?.pluginParseInfo.pluginPriority ?? Number.MAX_VALUE;
      return pluginAPriority - pluginBPriority;
    });
  }
}