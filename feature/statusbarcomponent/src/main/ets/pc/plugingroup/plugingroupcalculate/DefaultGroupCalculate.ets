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
import { PluginProperty } from '../../viewdata/PluginProperty';
import { BaseGroupCalculate } from './BaseGroupCalculate';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'DefaultGroupCalculate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class DefaultGroupCalculate extends BaseGroupCalculate {
  private defaultPos: [PluginPositionType, PluginGroupType] | undefined = undefined;
  constructor(pos: [PluginPositionType, PluginGroupType]) {
    super();
    this.defaultPos = pos;
  }

  protected getPosition(plugin: PluginProperty): [PluginPositionType, PluginGroupType] | undefined {
    return this.defaultPos;
  }
}