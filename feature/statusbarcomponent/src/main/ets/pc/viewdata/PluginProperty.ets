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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginGroupType, PluginPositionType } from '../common/PluginConstants';
import {
  PluginAccessInfo,
  PluginClickType,
  PluginInfo,
  PluginPosition,
  PluginType,
  PluginSlot } from '@ohos/frameworkwrapper';
// import statusBar from '@hms.pcService.statusBar';
import { StatusBarTint } from '../../common/StatusBarTint';
import type { Equality } from '@ohos/basicutils';
import { GroupInAreaType } from '../utils/enum';
import { StatusBarType } from '@ohos/systemuicommon';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'PluginProperty';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const INVALID_INDEX: number = -1;

@Observed
export class PluginProperty implements Equality {
  /**
   * 状态栏类型
   */
  public statusBarType: number = StatusBarType.TYPE_MAIN_MAC_STATUS_BAR;

  /**
   * 是否是胶囊图标
   */
  public isDynamicPlugin: boolean = true;
  /**
   * 根组件id
   */
  public rootParentId: string = 'root';
  /**
   * 图标颜色，预留字段，当前仍然是切换状态栏根组件
   */
  public contentColor: string = StatusBarTint.CONTENT_COLOR_WHITE;
  /**
   * 图标绑定进程号，避免UIExtensionAbility进程的退出导致图标隐藏
   */
  public requestPids: number[] = [];

  /**
   * 组合图标类型
   */
  public groupInAreaType: number = GroupInAreaType.TEMPORARY;

  /**
   * 图标所在分组
   */
  private pluginInGroup: PluginGroupType = PluginGroupType.INVALID;

  /**
   * 图标所在位置
   */
  private pluginInPosition: PluginPositionType = PluginPositionType.INVALID;

  /**
   * 图标所在位置
   */
  public index: number = 0;
  /**
   * 是否是最后一个图标
   */
  public isLast: boolean = false;
  /**
   * plugin数据信息
   */
  public pluginInfo: PluginInfo | null = null;
  /**
   * 图标位置
   */
  public area: Area | undefined = undefined;
  /**
   * right menu加载数据集
   */
  public groupMenuInfo: ESObject[] = [];
  /**
   * menu位置
   */
  public menuPlacement: Placement = Placement.BottomLeft;
  public isFromControlCenter = false;

  /**
   * 显隐状态
   */
  public visible: boolean = true;

  private visibleListener: VisibleListener | undefined = undefined;

  constructor(pluginInfo: PluginInfo, statusBarType?: number) {
    this.pluginInfo = pluginInfo;
    if (statusBarType) {
      this.statusBarType = statusBarType;
    }
    this.requestPids = this.pluginInfo?.requestPids;
  }

  isWindowType(): boolean {
    return PluginStyleUtil.isWindowStyle();
  }

  equals(other: object): boolean {
    if (other instanceof PluginProperty) {
      return this.pluginInfo?.equals(other.pluginInfo) ?? false;
    }
    return false;
  }

  public registerVisibleListener(visibleListener: VisibleListener): void {
    this.visibleListener = visibleListener;
    this.visibleListener.listener(this.visible);
  }

  public setFromControlCenter(isFromControlCenter: boolean): void {
    this.isFromControlCenter = isFromControlCenter;
  }

  /**
   * 图标在容器中的相对位置
   */
  setIndex(index: number, isLast: boolean): PluginProperty {
    this.index = index;
    this.isLast = isLast;
    return this;
  }

  setVisible(isVisible: boolean): void {
    let oldVisible = this.visible;
    this.visible = isVisible;
    this.visibleListener?.listener(isVisible, oldVisible);
  }

  getPluginInGroup(): PluginGroupType {
    return this.pluginInGroup;
  }

  setPluginInGroup(type: PluginGroupType): void {
    this.pluginInGroup = type;
  }

  getPluginInPosition(): PluginPositionType {
    return this.pluginInPosition;
  }

  setPluginInPosition(type: PluginPositionType): void {
    this.pluginInPosition = type;
    if (this.pluginInfo && this.pluginInfo.pluginParseInfo) {
      this.pluginInfo.pluginParseInfo.pluginPosition = PluginPositionType[type];
    }
  }

  isVisible(): boolean {
    return this.visible;
  }

  updatePluginProperty(oldPlugin: PluginProperty): void {
    if (!oldPlugin) {
      return;
    }
    this.isDynamicPlugin = oldPlugin.isDynamicPlugin;
    this.rootParentId = oldPlugin.rootParentId;
    this.contentColor = oldPlugin.contentColor;
    this.requestPids = oldPlugin.requestPids;
    this.pluginInGroup = oldPlugin.pluginInGroup;
    this.pluginInPosition = oldPlugin.pluginInPosition;
    this.index = oldPlugin.index;
    this.isLast = oldPlugin.isLast;
    this.area = oldPlugin.area;
    this.groupMenuInfo = oldPlugin.groupMenuInfo;
    this.menuPlacement = oldPlugin.menuPlacement;
    this.isFromControlCenter = oldPlugin.isFromControlCenter;
    this.visibleListener = oldPlugin.visibleListener;
    this.visible = oldPlugin.visible;
  }

  /**
   * 添加pid
   * @param requestPid 申请的pid号
   */
  addRequestPid(requestPid: number): void {
    const index = this.requestPids.indexOf(requestPid);
    if (index !== INVALID_INDEX) {
      log.showError('request pid: ' + requestPid + ' already observed');
      return;
    }
    this.requestPids.push(requestPid);
    this.pluginInfo?.requestPids.push(requestPid);
  }

  /**
   * 移除pid
   * @param requestPid 申请的pid号
   */
  deleteRequestPid(requestPid: number): void {
    const index = this.requestPids.indexOf(requestPid);
    if (index === INVALID_INDEX) {
      log.showError('request pid: ' + requestPid + ' already deleted');
      return;
    }
    this.requestPids.splice(index, 1);
    this.pluginInfo?.requestPids.splice(index, 1);
  }


  onContentColorChange(color: string): void {
    if (this.contentColor !== color) {
      this.contentColor = color;
    }
  }

  getRequestPids(): number[] {
    return this.requestPids;
  }

  /**
   * 获取图标唯一标识
   *
   * @returns 图标唯一标识
   */
  getSlot(): string {
    return this.pluginInfo?.getSlot() ?? '';
  }

  isPluginTypeMessage(): boolean {
    return this.pluginInfo?.pluginParseInfo?.pluginType === PluginType.PLUGIN_TYPE_MESSAGE;
  }

  isPluginTypeImmediately(): boolean {
    return this.pluginInfo?.pluginParseInfo?.pluginType === PluginType.PLUGIN_TYPE_IMMEDIATELY;
  }

  isPluginTypeAccess(): boolean {
    return this.pluginInfo?.pluginParseInfo?.isAccessPlugin ?? false;
  }

  /**
   * 图标事件是否透传
   *
   * @returns 事件是否透传
   */
  isEnabled(): boolean {
    if (!this.pluginInfo) {
      log.showError('checkEnabled pluginInfo is invalid');
      return false;
    }
    const parseInfo = this.pluginInfo?.pluginParseInfo;
    return PluginType.isPluginType(parseInfo?.pluginType) &&
      (parseInfo?.clickInfo?.clickType === PluginClickType.TYPE_CUSTOM ||
        parseInfo?.rightClickInfo?.clickType === PluginClickType.TYPE_CUSTOM) ||
      parseInfo?.clickInfo?.enableOperate === 'true';
  }

  /**
   * 更新图标区域
   *
   * @param newArea 图标新区域
   */
  updatePluginArea(newArea: Area): void {
    if (!newArea) {
      log.showError('updatePluginArea newArea invalid');
      return;
    }
    if (!this.area) {
      this.area = newArea;
      return;
    }
    if (this.area.width !== newArea.width ||
      this.area.height !== newArea.height ||
      this.area.position.x !== newArea.position.x ||
      this.area.position.y !== newArea.position.y ||
      this.area.globalPosition.x !== newArea.globalPosition.x ||
      this.area.globalPosition.y !== newArea.globalPosition.y
    ) {
      this.area = newArea;
    }
  }

  /**
   * 获取右键菜单数据
   */
  getGroupMenuInfo(): void {
    if (this.pluginInfo?.pluginParseInfo.isAccessPlugin) {
      // this.groupMenuInfo = (this.pluginInfo as PluginAccessInfo)?.menuInfo ?? [];
    }
  }

  getPluginPostion(): string {
    return this.pluginInfo?.pluginParseInfo?.pluginPosition ?? PluginPosition.POSITION_LEFT;
  }

  updateMenuPlaceMent(placement: Placement): void {
    this.menuPlacement = placement;
  }

  isLocalPlugin(): boolean {
    return this.pluginInfo?.pluginParseInfo?.isLocalPlugin ?? false;
  }

  isNeedSetMenuOffset(): boolean {
    return (this.isWindowType() && this.isPluginTypeAccess());
  }

  isConfigOrLocalPlugin(): boolean {
    return this.pluginInfo?.isConfigOrLocalPlugin() ?? false;
  }

  onDestroy(): void {
    this.pluginInfo?.onDestroy();
  }
}

export interface VisibleListener {
  listener: (newStatus: boolean, oldStatus?: boolean) => void;
}