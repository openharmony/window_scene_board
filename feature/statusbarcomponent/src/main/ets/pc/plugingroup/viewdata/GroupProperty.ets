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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginAccessInfo } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { StyleFactory } from '../../pluginstyle/StyleFactory';
import { PluginProperty } from '../../viewdata/PluginProperty';
import { PluginGroupType, PluginPositionType } from '../../common/PluginConstants';
import { HashSet } from '@kit.ArkTS';
import { PluginStyleUtil } from '../../common/PluginStyleUtil';

const TAG = 'GroupProperty';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Observed
export class GroupProperty {
  private pluginList: Array<PluginProperty> = [];

  private positionType: PluginPositionType = PluginPositionType.INVALID;

  private groupType: PluginGroupType = PluginGroupType.INVALID;

  private openPanel: string = '';

  private visualPluginsNum = 0;

  private lastVisualPluginsNum = 0;

  private visualPluginChangeListenerSet: HashSet<((lastNum: number, currentNum: number) => void)> = new HashSet();

  private groupName = '';

  private updateComponent: boolean = false;

  /**
   * 组合容器位置信息
   */
  private area: Area | undefined = undefined;

  constructor(position: PluginPositionType, type: PluginGroupType) {
    this.positionType = position;
    this.groupType = type;
    this.openPanel = StyleFactory.getInstance().getStyleManager()!.getPluginSlotMapping()!.getGroupOpenChannel(
      this.positionType, this.groupType);
    this.groupName = PluginGroupType[this.groupType] + '_' + PluginPositionType[this.positionType];
    log.info('groupName:' + this.groupName);
  }

  public getGroupType(): PluginGroupType {
    return this.groupType;
  }

  public getPositionType(): PluginPositionType {
    return this.positionType;
  }

  public getOpenPanel(): string {
    return this.openPanel;
  }

  public getGroupName(): string {
    return this.groupName;
  }

  public addPlugin(plugin: PluginProperty, positionType: PluginPositionType): void {
    log.info('addPlugin, slot:' + plugin.getSlot() + ' positionType:' +
      PluginPositionType[positionType] + ' groupType:' + this.groupName);
    const oldPlugin = ArrayUtils.update(this.pluginList, plugin);
    plugin.setPluginInPosition(positionType);
    plugin.setPluginInGroup(this.groupType);
    if (oldPlugin != null) {
      log.warn('exist same plugin:' + JSON.stringify(oldPlugin));
    }
    StyleFactory.getInstance().getStyleManager()?.getSortControl()?.sortPluginGroup(this);

    plugin.registerVisibleListener({
      listener: (newStatus: boolean, oldStatus?: boolean) => {
        this.updateVisualPlugin();
      }
    });
  }

  public removePlugin(plugin: PluginProperty): void {
    ArrayUtils.deleteArr(this.pluginList, plugin);
    this.updateVisualPlugin();
  }

  public removePluginBySlot(slot: string, tokeId?: number): void {
    let removePlugin = this.getSpecificPluginBySlot(slot);
    if (removePlugin) {
      this.removePlugin(removePlugin);
    }
  }

  private updateVisualPlugin() {
    this.lastVisualPluginsNum = this.visualPluginsNum;
    this.visualPluginsNum = this.pluginList.filter(item => item.isVisible()).length;
    if (this.visualPluginsNum !== this.lastVisualPluginsNum) {
      log.showInfo('updateVisualPlugin, lastVisualPluginNum:' + this.lastVisualPluginsNum +
        ' visualPluginsNum:' + this.visualPluginsNum + ' group:' + this.groupName);
      this.onVisualPluginNumChangeCallBack(this.lastVisualPluginsNum, this.visualPluginsNum);
    }
  }

  public getVisualPluginNum(): number {
    log.showInfo('getVisualPluginNum:' + this.visualPluginsNum);
    return this.visualPluginsNum;
  }

  public getPluginList(): Array<PluginProperty> {
    return this.pluginList;
  }

  public setPluginList(pluginProperties: PluginProperty[]): void {
    this.pluginList = pluginProperties;
  }

  public isExistPlugins(): boolean {
    return this.pluginList.length > 0;
  }

  public getVisualPluginList(): Array<PluginProperty> {
    return this.pluginList.filter(item => item.isVisible());
  }

  public updateIndex(): void {
    this.updateComponent = !this.updateComponent;
  }

  public getSpecificPluginBySlot(slot: string, tokenId?: number): PluginProperty | null {
    const index: number = this.getPluginIndex(slot, tokenId);
    if (index == -1) {
      log.error('invalid slot:' + slot + ',ignore');
      return null;
    }
    return this.pluginList[index];
  }

  public hasPlugin(slot: string): boolean {
    return this.getSpecificPluginBySlot(slot) != null;
  }

  public getPluginIndex(slot?: string, tokenId?: number, instanceKey?: string): number {
    return this.getPluginIndexOnPluginList(this.pluginList, slot, tokenId, instanceKey);
  }

  private getPluginIndexOnPluginList(pluginList: Array<PluginProperty>,
    slot?: string, tokenId?: number, instanceKey?: string) {
    return pluginList.findIndex((property) => {
      if (slot && property?.getSlot() === slot) {
        return true;
      }
      if (!(property?.pluginInfo instanceof PluginAccessInfo)) {
        return false;
      }

      let info = property?.pluginInfo as PluginAccessInfo;
      if (info && tokenId && info.accessTokenId === tokenId && info.pluginParseInfo.instanceKey === instanceKey) {
        return true;
      }
      return false;
    });
  }

  public getIndexOnVisualPlugins(slot?: string, tokenId?: number, instanceKey?: string): number {
    return this.getPluginIndexOnPluginList(this.getVisualPluginList(), slot, tokenId, instanceKey);
  }

  /**
   * 更新LocalGroup区域
   *
   * @param newArea 图标新区域
   */
  public updateLocalGroupArea(newArea: Area): void {
    if (!newArea) {
      log.showError('updateLocalGroupArea newArea invalid');
      return;
    }
    if (!this.area) {
      this.area = newArea;
      return;
    }
    if (this.area.width !== newArea.width ||
      this.area.height !== newArea.height ||
      this.area.position.x !== newArea.position?.x ||
      this.area.position.y !== newArea.position?.y ||
      this.area.globalPosition?.x !== newArea.globalPosition?.x ||
      this.area.globalPosition?.y !== newArea.globalPosition?.y
    ) {
      this.area = newArea;
    }
  }

  public getGroupArea(): Area | undefined {
    return this.area;
  }

  public clearAllPlugin(): void {
    log.info('clearAllPlugin');
    this.pluginList = [];
    this.visualPluginsNum = 0;
  }

  registerVisualPluginChangeCallback(callback: (lastNum: number, currentNum: number) => void): void {
    if (!this.visualPluginChangeListenerSet.has(callback)) {
      this.visualPluginChangeListenerSet.add(callback);
      callback(this.lastVisualPluginsNum, this.visualPluginsNum);
    }
  }

  unregisterVisualPluginChangeCallback(callback: (lastNum: number, currentNum: number) => void): void {
    if (this.visualPluginChangeListenerSet.has(callback)) {
      this.visualPluginChangeListenerSet.remove(callback);
    }
  }

  private onVisualPluginNumChangeCallBack(visibleNumLast: number, visibleNumCurrent: number) {
    this.visualPluginChangeListenerSet?.forEach((onDynamicListNumChange:
      ((lastNum: number, currentNum: number) => void))=>{
      onDynamicListNumChange?.(visibleNumLast, visibleNumCurrent);
    })
  }
}