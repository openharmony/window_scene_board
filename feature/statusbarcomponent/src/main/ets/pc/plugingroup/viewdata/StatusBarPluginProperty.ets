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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginProperty } from '../../viewdata/PluginProperty';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { PositionProperty } from './PositionProperty'
import { PluginPosUtils } from '../../common/PluginPosUtil';
import { GroupProperty } from './GroupProperty';

const TAG = 'StatusBarPluginProperty';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class StatusBarPluginProperty {
  private pluginPositionMap: Map<PluginPositionType, PositionProperty> =
    new Map<PluginPositionType, PositionProperty>([
      [PluginPositionType.INVALID, new PositionProperty(PluginPositionType.INVALID)],
      [PluginPositionType.TOP_LEFT, new PositionProperty(PluginPositionType.TOP_LEFT)],
      [PluginPositionType.TOP_RIGHT, new PositionProperty(PluginPositionType.TOP_RIGHT)],
      [PluginPositionType.BOTTOM_LEFT, new PositionProperty(PluginPositionType.BOTTOM_LEFT)],
      [PluginPositionType.BOTTOM_RIGHT, new PositionProperty(PluginPositionType.BOTTOM_RIGHT)]
    ]);

  // 风格切换期间不需要清理的分区或分组图标:OpenHarmony键、搜索
  private noNeedClearPlugins: Map<PluginPositionType, PluginGroupType[]> =
    new Map<PluginPositionType, PluginGroupType[]>([
      [PluginPositionType.BOTTOM_LEFT, []]
    ])

  public movePluginTo(plugin: PluginProperty, positionType: PluginPositionType, groupType: PluginGroupType): void {
    this.pluginPositionMap.get(positionType)?.movePluginTo(plugin, groupType);
  }

  /**
   * 将图标从旧的分组移动到新的分组
   *
   * @param plugin 图标信息
   * @param positionType 指定分区
   * @param groupType 指定分组
   */
  public updatePluginTo(plugin: PluginProperty, positionType: PluginPositionType, groupType: PluginGroupType): void {
    const pluginInOldPosition = plugin.getPluginInPosition();
    const pluginInOldGroup = plugin.getPluginInGroup();
    if (pluginInOldPosition === positionType && pluginInOldGroup === groupType) {
      log.warn('plugin position and group no change, no need process');
      return;
    }
    this.removePlugin(plugin);
    this.movePluginTo(plugin, positionType, groupType);
  }

  /**
   * 将指定图标从所在分组中移除
   *
   * @param plugin 图标信息
   */
  public removePlugin(plugin: PluginProperty): void {
    const pluginInOldPosition: PluginPositionType = plugin.getPluginInPosition();
    const pluginInOldGroup: PluginGroupType = plugin.getPluginInGroup();

    if (pluginInOldPosition != PluginPositionType.INVALID && pluginInOldGroup != PluginGroupType.INVALID) {
      this.pluginPositionMap.get(pluginInOldPosition)?.removePluginSpecificGroup(plugin, pluginInOldGroup);
      return;
    }

    this.pluginPositionMap.forEach(item => item.removePlugin(plugin));
  }

  public getPluginPositionMap(): Map<PluginPositionType, PositionProperty> {
    return this.pluginPositionMap;
  }

  public getSpecificPluginPosition(positionType: PluginPositionType): PositionProperty {
    return this.pluginPositionMap.get(positionType)!;
  }

  public getGroupPropertyByOpenPanel(openPanel: string): GroupProperty | null {
    let groupProperty: GroupProperty | null = null;
    this.pluginPositionMap.forEach(position => {
      let group: GroupProperty | null = position.getGroupPropertyByOpenPanel(openPanel);
      if (group) {
        groupProperty = group;
        return;
      }
    });
    return groupProperty;
  }

  /**
   * 获取位于顶部状态栏的分区图标
   *
   * @returns
   */
  public getTopPluginPosition(): PositionProperty[] {
    return PluginPosUtils.getTopPositionOrder().map(item => this.getSpecificPluginPosition(item));
  }

  public clearAllPlugin(): void {
    this.pluginPositionMap.forEach(value => {
      if (!this.noNeedClearPlugins.has(value.getPositionType()) ||
        this.noNeedClearPlugins.get(value.getPositionType())!.length > 0) {
        value.clearAllPlugin(this.noNeedClearPlugins.get(value.getPositionType()));
      }
    });
  }
}