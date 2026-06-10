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

import { PluginNotifyBase } from '../pluginData/PluginNotifyBase';
import { ListenerPriority } from '../pluginData/StatusBarPluginEventListener';
import { PluginGroupCalculateBase } from './PluginGroupCalculateBase';
import { StyleFactory } from '../pluginstyle/StyleFactory';
import { PluginProperty } from '../viewdata/PluginProperty';
import { GroupProperty } from './viewdata/GroupProperty';
import { PluginDisplayStyle, PluginGroupType, PluginPositionType } from '../common/PluginConstants';
import { StatusBarPluginProperty } from './viewdata/StatusBarPluginProperty';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { PositionProperty } from './viewdata/PositionProperty';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginStyleChangeListener, StyleSwitchManager } from '../pluginstyleswitch/StyleSwitchManager';

const TAG = 'PluginGroupingManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class PluginGroupingManager extends PluginNotifyBase implements PluginStyleChangeListener {
  private static mInstance: PluginGroupingManager;

  private statusBarProperty: StatusBarPluginProperty = new StatusBarPluginProperty();

  private pluginSlotMapping: PluginGroupCalculateBase | undefined = undefined;

  public static getInstance(): PluginGroupingManager {
    if (!PluginGroupingManager.mInstance) {
      PluginGroupingManager.mInstance = new PluginGroupingManager();
    }
    return PluginGroupingManager.mInstance;
  }

  protected addPlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(plugin => {
      const position: [PluginPositionType, PluginGroupType] | undefined =
        this.pluginSlotMapping?.getPluginPosition(plugin);
      if (CheckEmptyUtils.isEmpty(position)) {
        log.showWarn(`position is empty, slot:${plugin.getSlot()}`);
        return;
      }
      this.statusBarProperty.movePluginTo(plugin, position![0], position![1]);
      log.showInfo('addPlugin slot:' + plugin.getSlot() + ' position:' + position![0] + ' group:' + position![1]);
    })
  }

  protected removePlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(plugin => {
      this.statusBarProperty.removePlugin(plugin);
    })
  }

  protected updatePlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.forEach(plugin => {
      let pluginInPosition: PluginPositionType = plugin.getPluginInPosition();
      let pluginInGroup: PluginGroupType = plugin.getPluginInGroup();
      if (pluginInPosition == PluginPositionType.INVALID || pluginInGroup == PluginGroupType.INVALID) {
        const position: [PluginPositionType, PluginGroupType] | undefined =
          this.pluginSlotMapping?.getPluginPosition(plugin);
        if (CheckEmptyUtils.isEmpty(position)) {
          return;
        }
        pluginInPosition = position![0];
        pluginInGroup = position![1];
      }
      this.statusBarProperty.movePluginTo(plugin, pluginInPosition, pluginInGroup);
    })
  }

  public updatePluginTo(plugin: PluginProperty, positionType: PluginPositionType, groupType: PluginGroupType): void {
    this.statusBarProperty.updatePluginTo(plugin, positionType, groupType);
  }

  public getPluginGroup(positionType: PluginPositionType, groupType: PluginGroupType): GroupProperty {
    return this.statusBarProperty.getSpecificPluginPosition(positionType).getSpecificPluginGroup(groupType);
  }

  public getPluginPosition(positionType: PluginPositionType): PositionProperty {
    return this.statusBarProperty.getSpecificPluginPosition(positionType);
  }

  /**
   * 通过groupName获取GroupProperty属性
   *
   * @param localGroupName local group唯一标识
   * @returns local group属性
   */
  public getGroupPropertyByOpenPanel(openPanel: string): GroupProperty | null {
    return this.statusBarProperty.getGroupPropertyByOpenPanel(openPanel);
  }

  public getStatusBarPluginProperty(): StatusBarPluginProperty {
    return this.statusBarProperty;
  }

  public resortPlugins(): void {
    this.statusBarProperty.clearAllPlugin();
    let allPlugins = PluginListAdapter.getInstance().getAllData();
    this.addPlugins(allPlugins);
  }

  protected initDiff(): void {
    log.showInfo('initDiff');
    this.pluginSlotMapping = StyleFactory.getInstance().getStyleManager()?.getPluginSlotMapping();
    StyleSwitchManager.getInstance().registerDataChangeListener(this);
  }

  protected deInitDiff(): void {
    log.showInfo('deInitDiff');
    this.pluginSlotMapping = undefined;
    StyleSwitchManager.getInstance().unregisterDataChangeListener(this);
  }

  notifyPluginStyleChange(newStyle: PluginDisplayStyle, oldStyle: PluginDisplayStyle): void {
    this.pluginSlotMapping = StyleFactory.getInstance().getStyleManager()?.getPluginSlotMapping();
  }

  getPriority(): ListenerPriority {
    return ListenerPriority.PLUGIN_GROUP;
  }
}