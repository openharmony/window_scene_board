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
import { PluginProperty } from '../../viewdata/PluginProperty';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';

export abstract class BaseGroupCalculate {
  private nextElement: BaseGroupCalculate | undefined = undefined;

  public addElement(element: BaseGroupCalculate | undefined): BaseGroupCalculate | undefined {
    this.nextElement = element;
    return this.nextElement;

  }

  public getPluginPosition(plugin: PluginProperty): [PluginPositionType, PluginGroupType] | undefined {
    return this.getPosition(plugin) ?? this.nextElement?.getPluginPosition(plugin);
  }

  protected abstract getPosition(plugin: PluginProperty): [PluginPositionType, PluginGroupType] | undefined;
}