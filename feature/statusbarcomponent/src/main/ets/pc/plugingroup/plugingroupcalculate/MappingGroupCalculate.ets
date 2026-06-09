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
import { BaseGroupCalculate } from './BaseGroupCalculate';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'MappingGroupCalculate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class MappingGroupCalculate extends BaseGroupCalculate {
  private slotInWhereMap: Map<PluginPositionType, Map<string, PluginGroupType>> | undefined = undefined;

  constructor(map: Map<PluginPositionType, Map<string, PluginGroupType>>) {
    super();
    this.slotInWhereMap = map;
  }

  protected getPosition(plugin: PluginProperty): [PluginPositionType, PluginGroupType] | undefined {
    if (CheckEmptyUtils.isEmpty(this.slotInWhereMap)) {
      log.showError('getPosition fail, slotInWhereMap is empty');
      return undefined;
    }
    let pluginPosition: PluginPositionType | undefined = undefined;
    let pluginGroup: PluginGroupType | undefined = undefined;
    this.slotInWhereMap?.forEach((positionMap, pos) => {
      if (positionMap.has(plugin?.getSlot())) {
        pluginPosition = pos;
        pluginGroup = positionMap.get(plugin?.getSlot());
        return;
      }
    });
    return pluginPosition == undefined || pluginGroup == undefined ? undefined : [pluginPosition, pluginGroup];
  }
}