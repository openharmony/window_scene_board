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
import PcStatusBarVM from '../../viewmodel/PcStatusBarVM';
import { BaseGroupCalculate } from './BaseGroupCalculate';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginUtils } from '../../utils/PluginUtils';

const TAG = 'DragGroupCalculate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class DragGroupCalculate extends BaseGroupCalculate {
  protected getPosition(plugin: PluginProperty): [PluginPositionType, PluginGroupType] | undefined {
		let slot: string = (plugin?.isPluginTypeAccess() ? PluginUtils
			.getAccessPluginKey(plugin) : plugin?.getSlot()) ?? '';
		if (this.findPlugin(PcStatusBarVM.getInstance().getDynamicPlugs(), slot) != -1) {
			return [PluginPositionType.BOTTOM_RIGHT, PluginGroupType.DYNAMIC_LEFT];
		}
		if (this.findPlugin(PcStatusBarVM.getInstance().getTrayPlugs(), slot) != -1) {
			return [PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY];
		}
		return undefined;
	}

	private findPlugin(plugins: string[], slot: string): number {
		return plugins.findIndex(item => item === slot);
	}
}