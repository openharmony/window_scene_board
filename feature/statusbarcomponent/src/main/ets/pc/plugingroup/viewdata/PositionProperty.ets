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
import { GroupProperty } from './GroupProperty';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';

const TAG = 'PositionProperty';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Observed
export class PositionProperty {
  private pluginGroupMap: Map<PluginGroupType, GroupProperty> = new Map();

  private localGroupList: PluginGroupType[] = [PluginGroupType.FIRST_GROUP, PluginGroupType.SECOND_GROUP,
    PluginGroupType.THIRD_GROUP, PluginGroupType.FOURTH_GROUP, PluginGroupType.FIFTH_GROUP];

  private dockStatusBarList: PluginGroupType[] = [PluginGroupType.DYNAMIC_LEFT, PluginGroupType.FIRST_GROUP,
    PluginGroupType.SECOND_GROUP, PluginGroupType.THIRD_GROUP,
      PluginGroupType.FOURTH_GROUP, PluginGroupType.FIFTH_GROUP];

  private positionType: PluginPositionType = PluginPositionType.INVALID;

  private pluginGroupListExcludeDynamic: GroupProperty[] = [];

  private positionName: string = '';

  constructor(type: PluginPositionType) {
    this.positionType = type;
    this.positionName = PluginPositionType[this.positionType];
    log.info('positionName:' + this.positionName);
  }

  public getPositionType(): PluginPositionType {
    return this.positionType;
  }

  public getPositionName(): string {
    return this.positionName;
  }

  /**
   * 检查指定图标分组是否存在，若不存在，则新建
   *
   * @param groupType 指定图标分组
   */
  private checkGroupPluginsEmpty(groupType: PluginGroupType): void {
    if (!this.pluginGroupMap.has(groupType)) {
      this.pluginGroupMap.set(groupType, new GroupProperty(this.positionType, groupType));
      this.pluginGroupListExcludeDynamic = this.localGroupList
        .filter(item => this.pluginGroupMap.has(item)).map(key => this.pluginGroupMap.get(key)!);
    }
  }

  public movePluginTo(plugin: PluginProperty, groupType: PluginGroupType): void {
    this.checkGroupPluginsEmpty(groupType);
    this.pluginGroupMap.get(groupType)?.addPlugin(plugin, this.positionType);
  }

  public removePluginSpecificGroup(plugin: PluginProperty, groupType: PluginGroupType): void {
    this.pluginGroupMap.get(groupType)?.removePlugin(plugin);
  }

  public removePlugin(plugin: PluginProperty): void {
    this.pluginGroupMap.forEach(item => item.removePlugin(plugin));
  }

  /**
   * 获取除动态分组外的其他分组数据
   *
   * @returns 除动态分组外的其他分组数据
   */
  public getPluginGroupListExcludeDynamic(): GroupProperty[] {
    return this.pluginGroupListExcludeDynamic;
  }

  public getSpecificPluginGroup(groupType: PluginGroupType): GroupProperty {
    this.checkGroupPluginsEmpty(groupType);
    return this.pluginGroupMap.get(groupType)!;
  }

  public getGroupPropertyByOpenPanel(openPanel: string): GroupProperty | null {
    let groupProperty: GroupProperty | null = null;
    this.pluginGroupMap.forEach(group => {
      if (group.getOpenPanel() == openPanel) {
        groupProperty = group;
        return;
      }
    });
    return groupProperty;
  }

  public getVisualPluginNumOnDock(): number {
    let visualNum = 0;
    this.dockStatusBarList.forEach(item => visualNum += this.pluginGroupMap.get(item)?.getVisualPluginNum() ?? 0);
    return visualNum;
  }

  public clearAllPlugin(noNeedClear: PluginGroupType[] | undefined): void {
    this.pluginGroupMap.forEach((value, key) => {
      if (noNeedClear === undefined || noNeedClear.indexOf(key) === -1) {
        value.clearAllPlugin();
        this.pluginGroupMap.delete(key);
      }
    });
  }
}