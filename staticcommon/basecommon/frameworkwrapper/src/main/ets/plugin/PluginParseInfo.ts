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

import type { Serializable } from '@ohos/basicutils';
import type { Equality, Duplication } from '@ohos/basicutils';
import { CommonUtils, ArrayUtils } from '@ohos/basicutils';
import {
  PluginConstants,
  PluginPosition,
  PluginSlot,
  PluginIconType,
  PluginWindowPosition,
  PluginType
} from './PluginConstants';
import { SCBConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '../base/DeviceHelper';

/**
 * plugin slot映射集
 * action => position => slot名称集
 */
const SLOT_MAP: Map<string, Map<string, Array<string>>> = new Map([
// 状态栏slot集
  [
  PluginConstants.ACTION_PLUGIN_STATUS_BAR, PluginSlot.getDefaultSlot(PluginConstants.ACTION_PLUGIN_STATUS_BAR)
  ],
  // 控制中心slot集
  [
  PluginConstants.ACTION_PLUGIN_TOGGLE, PluginSlot.getDefaultSlot(PluginConstants.ACTION_PLUGIN_TOGGLE)
  ]
]);

/**
 * PluginComponent的配置数据信息
 *
 * @since 2022-10-06
 */
export class PluginParseInfo implements Serializable, Equality, Duplication {
  /**
   * plugin是否来源本应用
   * 内部使用。不参与序列化
   */
  isLocalPlugin: boolean;

  isAccessPlugin?: boolean;

  /**
   * 应用包名
   */
  bundleName: string;

  /**
   * 远程应用，模块名
   */
  moduleName: string;

  /**
   * 该组件对应的action，区分 PC状态栏、控制中心toggle
   */
  action: string;

  appIndex: number = 0;
  instanceKey: string = '';

  /**
   * 组件对应业务图标slot名，排序
   * 唯一标示，不携带则取模板名(排序靠后)
   */
  pluginSlot: string;
  labelResName?: string;
  /**
   * 组件使用的设备类型
   */
  pluginDeviceType: string;

  /**
   * 组件模板名称
   */
  pluginTemplateName: string;

  /**
   * 副组件模板名称
   */
  pluginBackTemplateName: string;

  /**
   * 组件ability名称
   */
  pluginAbilityName: string;

  /**
   * 图标颜色
   */
  contentColor?: string;

  /**
   * 组件位置
   * 状态栏区分左侧、右侧
   *
   * @see PluginPosition
   */
  pluginPosition: string;

  /**
   * 组件优先级，用于排序
   * 状态栏左侧优先级越小越靠左，
   * 状态栏右侧优先级越小越靠右
   */
  pluginPriority: number;

  /**
   * 组件图标类型
   *
   * @see PluginIconType
   */
  pluginIconType: string;

  /**
   * 图标右上角是否需要红点
   */
  isNeedRedHot: boolean = false;

  /**
   * 单击数据信息
   *
   * @see PluginClickInfo
   */
  clickInfo: PluginClickInfo;

  rightClickInfo: PluginClickInfo;

  doubleClickInfo: PluginClickInfo;

  /**
   * 长按数据信息
   *
   * @see PluginClickInfo
   */
  longClickInfo: PluginClickInfo;

  /**
   * 二级页面点击事件
   *
   * @see PluginClickInfo
   */
  subPageClickInfo: PluginClickInfo;

  /**
   * @see PluginType
   */
  pluginType: PluginType;

  /**
   * 图标宽度
   */
  pluginIconWidth: number;

  /**
   * 比较可更新，equals相等后判断更新
   *
   * @param newPlugin 新plugin数据
   * @return true有更新
   */
  checkUpdate(newPlugin: PluginParseInfo): boolean {
    if (CommonUtils.isInvalid(newPlugin)) {
      return false;
    }
    return (this.pluginTemplateName !== newPlugin.pluginTemplateName ||
    this.pluginBackTemplateName !== newPlugin.pluginBackTemplateName ||
    this.contentColor !== newPlugin.contentColor ||
    this.moduleName !== newPlugin.moduleName ||
    this.pluginAbilityName !== newPlugin.pluginAbilityName ||
    this.pluginPosition !== newPlugin.pluginPosition ||
    this.pluginPriority !== newPlugin.pluginPriority ||
    this.isNeedRedHot !== newPlugin.isNeedRedHot ||
    !CommonUtils.equals(this.clickInfo, newPlugin.clickInfo) ||
    !CommonUtils.equals(this.longClickInfo, newPlugin.longClickInfo)) ||
    !CommonUtils.equals(this.subPageClickInfo, newPlugin.subPageClickInfo);
  }

  /**
   * 反序列化
   *
   * @see Serializable
   * @param obj 原始反序列化对象
   */
  deserialize(obj: object): void {
    if (CommonUtils.isInvalid(obj)) {
      return;
    }
    let oriObj = obj as PluginParseInfo;
    this.pluginTemplateName = oriObj.pluginTemplateName;
    this.pluginBackTemplateName = oriObj.pluginBackTemplateName;
    this.contentColor = oriObj.contentColor;
    this.pluginAbilityName = oriObj.pluginAbilityName;
    this.pluginDeviceType = oriObj.pluginDeviceType;
    this.pluginSlot = oriObj.pluginSlot;
    this.labelResName = oriObj.labelResName;
    this.pluginPriority = oriObj.pluginPriority;
    this.pluginType = oriObj.pluginType;
    this.pluginIconWidth = oriObj.pluginIconWidth;
    // 是否需要红点
    this.isNeedRedHot = oriObj.isNeedRedHot ?? false;
    this.checkDeserialize(oriObj);
  }

  checkDeserialize(oriObj: PluginParseInfo): void {
    if (CommonUtils.isEmpty(this.pluginSlot)) {
      this.pluginSlot = this.pluginTemplateName;
    }
    let clickObj: object = oriObj.clickInfo;
    if (!CommonUtils.isInvalid(clickObj)) {
      this.clickInfo = new PluginClickInfo();
      this.clickInfo.deserialize(clickObj);
    }
    let longClickObj = oriObj.longClickInfo;
    if (!CommonUtils.isInvalid(longClickObj)) {
      this.longClickInfo = new PluginClickInfo();
      this.longClickInfo.deserialize(longClickObj);
    }
    let subPageClickInfo = oriObj.subPageClickInfo;
    if (!CommonUtils.isInvalid(subPageClickInfo)) {
      this.subPageClickInfo = new PluginClickInfo();
      this.subPageClickInfo.deserialize(subPageClickInfo);
    }
    let rightClickObj: object = oriObj.rightClickInfo;
    if (!CommonUtils.isInvalid(rightClickObj)) {
      this.rightClickInfo = new PluginClickInfo();
      this.rightClickInfo.deserialize(rightClickObj);
    }
    let doubleClickObj: object = oriObj.doubleClickInfo;
    if (!CommonUtils.isInvalid(doubleClickObj)) {
      this.doubleClickInfo = new PluginClickInfo();
      this.doubleClickInfo.deserialize(doubleClickObj);
    }
    // 图标类型，默认小图标
    this.pluginIconType = oriObj.pluginIconType;
    this.pluginPosition = oriObj.pluginPosition;
    // 状态栏图标默认均左侧
    if (CommonUtils.isInvalid(this.pluginPosition)) {
      this.pluginPosition = PluginPosition.POSITION_LEFT;
    }
  }

  /**
   * 判断相等
   *
   * @see Equality
   * @param other 待判断对象
   */
  equals(other: object): boolean {
    if (other instanceof PluginParseInfo) {
      return this.action === other.action && this.pluginSlot === other.pluginSlot;
    }
    return false;
  }

  /**
   * 复制属性
   *
   * @see Duplication
   * @param obj 属性提供者
   */
  copy(obj: object): void {
    if (CommonUtils.isInvalid(obj)) {
      return;
    }
    let other = obj as PluginParseInfo;
    this.isLocalPlugin = other.isLocalPlugin;
    this.bundleName = other.bundleName;
    this.appIndex = other.appIndex;
    this.moduleName = other.moduleName;
    this.action = other.action;
    this.pluginSlot = other.pluginSlot;
    this.labelResName = other.labelResName;
    this.pluginDeviceType = other.pluginDeviceType;
    this.pluginTemplateName = other.pluginTemplateName;
    this.pluginBackTemplateName = other.pluginBackTemplateName;
    this.contentColor = other.contentColor;
    this.pluginAbilityName = other.pluginAbilityName;
    this.pluginPosition = other.pluginPosition;
    this.pluginIconType = other.pluginIconType;
    this.pluginPriority = other.pluginPriority;
    this.isNeedRedHot = other.isNeedRedHot;
    this.pluginType = other.pluginType;
    this.pluginIconWidth = other.pluginIconWidth;
    let clickObj: object = other.clickInfo;
    if (!CommonUtils.isInvalid(clickObj)) {
      this.clickInfo = new PluginClickInfo();
      this.clickInfo.copy(clickObj);
    }
    let longClickObj = other.longClickInfo;
    if (!CommonUtils.isInvalid(longClickObj)) {
      this.longClickInfo = new PluginClickInfo();
      this.longClickInfo.copy(longClickObj);
    }
    let subPageClickInfo = other.subPageClickInfo;
    if (!CommonUtils.isInvalid(subPageClickInfo)) {
      this.subPageClickInfo = new PluginClickInfo();
      this.subPageClickInfo.copy(subPageClickInfo);
    }
    let rightClickObj: object = other.rightClickInfo;
    if (!CommonUtils.isInvalid(rightClickObj)) {
      this.rightClickInfo = new PluginClickInfo();
      this.rightClickInfo.copy(rightClickObj);
    }
    let doubleClickObj: object = other.doubleClickInfo;
    if (!CommonUtils.isInvalid(doubleClickObj)) {
      this.doubleClickInfo = new PluginClickInfo();
      this.doubleClickInfo.deserialize(doubleClickObj);
    }
  }

  /**
   * 检测参数合法性，校正默认值
   */
  checkParams(): void {
    // 优先采用默认位置
    let defaultPosition = PluginSlot.getDefaultPosition(this.action, this.pluginSlot);
    if (!CommonUtils.isEmpty(defaultPosition)) {
      this.pluginPosition = defaultPosition;
    }
    // 优先采用默认图标类型
    let defaultIconType = PluginIconType.getDefaultType(this.action, this.pluginSlot);
    if (DeviceHelper.isPC()) {
      this.pluginIconType = this.pluginIconType ?? defaultIconType ?? PluginIconType.TYPE_SMALL_ICON;
    } else {
      this.pluginIconType = defaultIconType ?? PluginIconType.TYPE_SMALL_ICON;
    }
    // 设定图标最终优先级，用于排序
    this.setPriority();
    // 区分local和remote应用
    this.isLocalPlugin = (this.bundleName === SCBConstants.SCENE_BOARD_PKG);
    // 设置弹窗位置
    this.checkWindowPosition(this.clickInfo);
    this.checkWindowPosition(this.longClickInfo);
  }

  /**
   * 检测点击/长按事件弹窗类型的窗口位置
   *
   * @param clickInfo 点击信息
   */
  private checkWindowPosition(clickInfo: PluginClickInfo): void {
    if (CommonUtils.isInvalid(clickInfo)) {
      return;
    }
    clickInfo.windowPosition = PluginWindowPosition.getWindowPosition(this.pluginSlot);
  }

  /**
   * 确定最终优先级
   */
  private setPriority(): void {
    // 获取slot序列集
    let slotArray = SLOT_MAP.get(this.action)?.get(this.pluginPosition);
    if (ArrayUtils.isEmpty(slotArray)) {
      this.pluginPriority = 0;
      return;
    }
    // 存在默认slot，采用默认slot排序
    let slotPriority = slotArray.indexOf(this.pluginSlot);
    if (slotPriority !== -1) {
      this.pluginPriority = slotPriority;
      return;
    }
    // 不存在则优先采用设置值
    if (this.pluginPriority >= slotArray.length) {
      return;
    }
    // 不合规，直接最大值，排在最后面
    this.pluginPriority = Number.MAX_VALUE;
  }
}

/**
 * PluginComponent单击/双击数据信息
 */
export class PluginClickInfo implements Serializable, Equality, Duplication {
  /**
   * 点击类型
   *
   * @see PluginClickType
   */
  clickType: string;

  /**
   * 点击类型为window时使用，窗口类型
   *
   * @see PluginWindowType
   */
  windowType: string;

  /**
   * 点击类型为ability时使用，启动ability类型
   *
   * @see PluginAbilityType
   */
  abilityType: string;

  /**
   * UI extension type
   */
  uiExtensionType: string;

  /**
   * 点击类型为window时使用，窗口位置
   * 内部使用，不参与序列化
   *
   * @see PluginWindowPosition
   */
  windowPosition: number;

  /**
   * 点击类型为window时使用，窗口高度(vp)
   */
  windowHeight: number;

  /**
   * 点击类型为window或ability类型时使用，包名
   */
  bundleName: string;

  /**
   * 点击类型为window或ability类型时使用，ability全名
   * 弹窗类型时需使用AbilityComponent，Ability需继承WindowExtension
   */
  abilityName: string;

  /**
   * 是否响应操作事件
   */
  enableOperate: string;

  /**
   * 请求类型
   */
  requestType: number;

  /**
   * 构造
   *
   * @param clickType 点击类型
   * @param windowType 窗口类型
   * @param abilityName ability名
   * @param enableOperate 是否响应操作事件
   */
  constructor(clickType?: string, windowType?: string,
    abilityName?: string, enableOperate?: string, requestType?: number) {
    this.clickType = clickType;
    this.windowType = windowType;
    this.abilityName = abilityName;
    this.enableOperate = enableOperate;
    this.requestType = requestType;
  }

  /**
   * 反序列化
   *
   * @see Serializable
   * @param obj 原始反序列化对象
   */
  deserialize(obj: object): void {
    if (CommonUtils.isInvalid(obj)) {
      return;
    }
    let oriObj = obj as PluginClickInfo;
    this.clickType = oriObj.clickType;
    this.windowType = oriObj.windowType;
    this.abilityType = oriObj.abilityType;
    this.uiExtensionType = oriObj.uiExtensionType;
    this.windowHeight = oriObj.windowHeight;
    this.bundleName = oriObj.bundleName;
    this.abilityName = oriObj.abilityName;
    this.enableOperate = oriObj.enableOperate;
  }

  /**
   * 相等比较
   *
   * @see Equality
   * @param other 待比较对象
   */
  equals(other: object): boolean {
    if (other instanceof PluginClickInfo) {
      return (
        this.clickType === other.clickType &&
        this.windowType === other.windowType &&
        this.abilityType === other.abilityType &&
        this.uiExtensionType === other.uiExtensionType &&
        this.windowHeight === other.windowHeight &&
        this.bundleName === other.bundleName &&
        this.abilityName === other.abilityName &&
        this.enableOperate === other.enableOperate
      );
    }
    return false;
  }

  /**
   * 复制属性
   *
   * @see Duplication
   * @param obj
   */
  copy(obj: object): void {
    if (CommonUtils.isInvalid(obj)) {
      return;
    }
    let other = obj as PluginClickInfo;
    this.clickType = other.clickType;
    this.windowType = other.windowType;
    this.abilityType = other.abilityType;
    this.uiExtensionType = other.uiExtensionType;
    this.windowPosition = other.windowPosition;
    this.windowHeight = other.windowHeight;
    this.bundleName = other.bundleName;
    this.abilityName = other.abilityName;
    this.enableOperate = other.enableOperate;
  }
}