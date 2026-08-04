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

import image from '@ohos.multimedia.image';
// import { hdsDrawable } from '@kit.UIDesignKit';
import {
  bundleManagerFwk,
  DeviceHelper,
  ResourceManager,
  onLineThemeUtil,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import { LogDomain, Logger, CheckEmptyUtils, StartType, OutdoorConfig } from '@ohos/basicutils';
import { OutdoorCcmManager, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { BaseIconInfo } from '../../bean/BaseIconInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AppModel, ResourceChangeListener } from '../../model/AppModel';

const TAG = 'AppIconModel';
const log: Logger = Logger.getLogHelper(LogDomain.ICON);

interface DynamicIconState {
  isInit: Map<string, boolean>;
  isDynamicIcon: Map<string, boolean>;
}

export class AppIconModel {
  static mInstance: AppIconModel;
  readonly dynamicIconList = [CommonConstants.CALENDAR_BUNDLE, CommonConstants.CLOCK_BUNDLE];
  private disableShadow: boolean = false;
  private dynamicIconState: DynamicIconState = {
    isInit: new Map(),
    isDynamicIcon: new Map()
  };
  private resourceChangeListener: ResourceChangeListener = {
    id: TAG,
    clearCache: () => this.clearDynamicIconState(),
  };

  private readonly clockImageNames: string[] = [
    'ic_deskclock_background',
    'ic_deskclock_dial',
    'ic_deskclock_hour',
    'ic_deskclock_minute',
    'ic_deskclock_second'
  ];
  private readonly calendarImageNames: string[] = [
    'ic_calendar_background'
  ];

  private constructor() {
    this.disableShadow = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_CARD_SHADOW_DISABLE);
    AppModel.getInstance().registerResourceChangeListener(this.resourceChangeListener);
  }

  private initDynamicIconState(item: IBaseInfo | AppItemInfo): void {
    let isDynamic: boolean = false;
    if (item.bundleName === CommonConstants.CLOCK_BUNDLE) {
      isDynamic = ResourceManager.getInstance()
        .isExistResByResourceNames(this.clockImageNames, item.bundleName, item.moduleName);
    } else if (item.bundleName === CommonConstants.CALENDAR_BUNDLE) {
      isDynamic = ResourceManager.getInstance()
        .isExistResByResourceNames(this.calendarImageNames, item.bundleName, item.moduleName);
    }
    this.dynamicIconState.isInit.set(item.bundleName, true);
    this.dynamicIconState.isDynamicIcon.set(item.bundleName, isDynamic);
  }

  public static getInstance(): AppIconModel {
    if (!AppIconModel.mInstance) {
      AppIconModel.mInstance = new AppIconModel();
    }
    return AppIconModel.mInstance;
  }

  public getIconId(itemInfo: AppItemInfo, extraId?: string, isOuterDesktop: boolean = false, isOpenFolder: boolean = false): string {
    if (!itemInfo) {
      return '';
    }
    const openFolder: string = isOpenFolder ? '_isOpenFolder' : '';
    let iconId: string =
      `${CommonConstants.APP_ITEM_APP_BUBBLE_ICON_TAG}${AppItemInfo.getKeyName(itemInfo)}_${extraId}${openFolder}_`;
    iconId += `${itemInfo.areaType}`;
    return isOuterDesktop ? iconId + `_OuterDesktop` : iconId;
  }

  /**
   * 获取badge组件id
   * @param bundleName 组件bundleName
   * @param startType 启动类型
   * @param shortcutId 支持快捷方式类型
   * @returns badge组件id
   */
  public getBadgeId(bundleName: string, startType: StartType, item?: AppItemInfo): string {
    let badgeId: string = `${TAG}_Badge_${bundleName}_${startType}`;
    if (!CheckEmptyUtils.isEmpty(item)) {
      return badgeId + (item?.shortcutId ? `_shortcutId_${item?.shortcutId}` : '') +
        (item?.appIndex ? `_appIndex_${item?.appIndex}` : '');
    }
    return badgeId;
  }

  public clearDynamicIconState(): void {
    this.dynamicIconState.isInit.clear();
  }

  /**
   * 判断是否为动态图标
   *
   * @param bundleName
   * @returns
   */
  public isDynamicIconByBundleName(bundleName: string): boolean {
    return this.dynamicIconList.includes(bundleName);
  }

  /**
   * 判断是否需要支持动态图标
   */
  public isDynamicIcon(item?: IBaseInfo | AppItemInfo): boolean {
    if (!item) {
      log.showInfo(TAG, 'item is invalid.');
      return false;
    }

    // 根据bundleName判断是否是动态图标
    if (!this.dynamicIconList.includes(item.bundleName)) {
      log.showInfo(TAG, `bundleName: ${item.bundleName}, not in dynamicIconList.`);
      return false;
    }

    // 快捷图标不涉及动态图标
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      log.showInfo(TAG, `bundleName: ${item.bundleName}, icon type is shortcut`);
      return false;
    }

    // pc不支持动态时钟
    if (item.bundleName === CommonConstants.CLOCK_BUNDLE && DeviceHelper.isPC()) {
      log.showInfo(TAG, 'pc not support dynamic clock');
      return false;
    }

    if (!this.dynamicIconState.isInit.get(item.bundleName)) {
      this.initDynamicIconState(item);
    }
    return this.dynamicIconState.isDynamicIcon.get(item.bundleName) ?? false;
  }

  public isEnableIconShadow(extraLimits: boolean = true): boolean {
    // 图标满足4个条件使能阴影样式: 1.CCM配置使能; 2.直板机; 3.Verde; 4.官方预置主题; 5.无额外限制
    return !this.disableShadow && (DeviceHelper.isBarPhone()) &&
      !onLineThemeUtil.isOnlineTheme() && extraLimits;
  }

  public getIconRadius(isFolderApp: boolean = false, iconRadius: number = 0): number {
    if (isFolderApp || onLineThemeUtil.isOnlineTheme()) {
      return 0;
    }
    return iconRadius;
  }

  /**
   * 获取拖拽的builder scale
   * @param item AppItemInfo
   * @returns ScaleOptions
   */
  public getDragIconBuilderScale(item: AppItemInfo): ScaleOptions {
    return { x: 1, y: 1 };
  }

  /**
   * 是否是有效的分身
   * @param item BaseIconInfo
   * @returns boolean
   */
  public isValidCloneItem(item: BaseIconInfo): boolean {
    // 当前分身最多支持5个
    return item && (item.appIndex ?? 0) > 0 && (item.appIndex ?? 0) <= 5;
  }

  /**
   * 云端模式一和云端模式二不显示ccm中配置应用的角标
   *
   * @param bundleName 包名
   * @returns true 角标不可见，false 角标可见
   */
  public isIconBadgeInvisible(bundleName: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      return false;
    }
    if (!OutdoorConfig.getInstance().isInOutdoorMode() &&
      !LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return false;
    }
    return OutdoorCcmManager.getInstance().isIconBadgeInvisible(bundleName);
  }
}

export interface IBaseInfo {
  bundleName: string,
  moduleName?: string,
  typeId?: number
}