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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { GroupProperty } from '../../plugingroup/viewdata/GroupProperty'
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { StyleFactory } from '../../pluginstyle/StyleFactory';
import { PluginProperty } from '../../viewdata/PluginProperty';
import PcStatusBarVM from '../../viewmodel/PcStatusBarVM';
import { SortCalculateBase } from '../SortCalculateBase'
import { PluginUtils } from '../../utils/PluginUtils';

const TAG = 'WindowsSortCalculate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class WindowsSortCalculate extends SortCalculateBase {

  public sortPluginGroup(pluginGroup: GroupProperty): void {
    if (pluginGroup.getGroupType() == PluginGroupType.DYNAMIC_LEFT) {
      this.sortDynamicPlugs(pluginGroup.getPluginList());
      return;
    }

    if (pluginGroup.getGroupType() == PluginGroupType.TRAY) {
      this.sortTrayPlugs(pluginGroup.getPluginList());
      return;
    }
    return this.sortPluginArray(pluginGroup.getPluginList());
  }

  private sortDynamicPlugs(pluginList: Array<PluginProperty>): void {
    let dynamicPlugs: string[] = PcStatusBarVM.getInstance().getDynamicPlugs();
    if (dynamicPlugs.length === 0) {
      this.sortDefaultDynamicPlugs(pluginList);
      return;
    }
    pluginList?.sort((plugA, plugB): number => {
      let indexA = this.getIndexInSettingsData(plugA, PcStatusBarVM.getInstance().getDynamicPlugs());
      let indexB = this.getIndexInSettingsData(plugB, PcStatusBarVM.getInstance().getDynamicPlugs());
      if (indexA === -1 || indexB === -1) {
        return 0;
      }
      return indexA - indexB;
    });
    this.sortDefaultDynamicPlugs(pluginList);
  }

  private sortDefaultDynamicPlugs(pluginList: Array<PluginProperty>): void {
    // 将超级隐私排在动态分区固定位置最左边
    pluginList?.sort((plugA, plugB): number => {
      let rightMap = StyleFactory.getInstance()
        .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
      if (rightMap?.has(plugA?.getSlot()) && rightMap?.has(plugB?.getSlot())) {
        if (plugA?.getSlot() === PluginSlot.SLOT_CAPSULE_KEY_MOUSE ||
          plugB?.getSlot() === PluginSlot.SLOT_CAPSULE_KEY_MOUSE) {
          return plugA?.getSlot() === PluginSlot.SLOT_CAPSULE_KEY_MOUSE ? -1 : 1;
        }
        if (plugA?.getSlot() === PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD ||
          plugB?.getSlot() === PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD) {
          return plugA?.getSlot() === PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD ? 1 : -1;
        }
      }
      return 0;
    });
  }

  private getIndexInSettingsData(property: PluginProperty, plugs: string[]): number {
    if (plugs.length === 0) {
      return -1;
    }
    let index = -1;
    if (!property.isPluginTypeAccess()) {
      index = plugs.findIndex(item => item === property.getSlot());
    } else {
      index = plugs.findIndex(item => item === PluginUtils.getAccessPluginKey(property));
    }
    return index;
  }

  private sortTrayPlugs(pluginList: Array<PluginProperty>): void {
    let trayPlugs: string[] = PcStatusBarVM.getInstance().getTrayPlugs();
    if (trayPlugs.length === 0) {
      return;
    }
    pluginList.sort((plugA, plugB): number => {
      let indexA = this.getIndexInSettingsData(plugA, PcStatusBarVM.getInstance().getTrayPlugs());
      let indexB = this.getIndexInSettingsData(plugB, PcStatusBarVM.getInstance().getTrayPlugs());
      return indexA - indexB;
    });
  }
}