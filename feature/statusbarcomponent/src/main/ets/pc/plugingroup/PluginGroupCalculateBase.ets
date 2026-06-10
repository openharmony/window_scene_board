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
import { PluginGroupType, PluginPositionType } from '../common/PluginConstants';
import { PluginProperty } from '../viewdata/PluginProperty';
import { BaseGroupCalculate } from './plugingroupcalculate/BaseGroupCalculate';
import { DeviceHelper, PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'PluginGroupCalculateBase';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export abstract class PluginGroupCalculateBase {
	protected basePluginGroup: BaseGroupCalculate | undefined = undefined;

	protected openPanels: Map<PluginPositionType, Map<PluginGroupType, string>> | undefined = undefined;

	protected slotInWhereMap: Map<PluginPositionType, Map<string, PluginGroupType>> | undefined = undefined;

  public getPluginPosition(plugin: PluginProperty): [PluginPositionType, PluginGroupType] | undefined {
		if (DeviceHelper.isEmulator() && plugin.getSlot() === PluginSlot.SLOT_STATUS_SEARCH) {
			return undefined;
		}
		return this.basePluginGroup?.getPluginPosition(plugin);
	}

	public getGroupOpenChannel(position: PluginPositionType, group: PluginGroupType): string {
		return this.openPanels?.get(position)?.get(group) ?? '';
	}

	public getSlotInWhereMap(): Map<PluginPositionType, Map<string, PluginGroupType>> | undefined {
		return this.slotInWhereMap;
	}
}
