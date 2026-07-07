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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AppIconConfig } from '../../launchericon/config/AppIconConfig'
import { AppIconExternCb } from '../../launchericon/interface/AppIconExternCb';
import { AppIconTouchEventIface } from '../../launchericon/interface/AppIconTouchEventIface';
import { AppIconBadgeVm } from '../../launchericon/viewmodel/AppIconBadgeVm';
import { AppIconCommonEvent } from '../../launchericon/viewmodel/AppIconCommonEvent';
import { AppDataWrapper, AppItemInfo, CommonConstants, FolderAppItemInfo, GridLayoutItemInfo } from '../../TsIndex';
import { FolderClickType } from '../next/common/FolderCommonConstant';
import {
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType
} from '../next/contractedfolder/viewmodel/manager/ContractedFolderViewModelManager';
import {
  IContractedFolderEventViewModel
} from '../next/contractedfolder/viewmodel/manager/IContractedFolderEventViewModel';
import { BigFolderAppDefaultModifier } from '../viewmdoel/BigFolderAppDefaultModifier';

const TAG = 'FolderIconConfigUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 获取文件夹图标配置
 */
export class FolderIconConfigUtil {
  /**
   * 获取不带角标的静态显示图标配置
   * @returns 不带角标的图标的配置项
   */
  public static getPeruDisplayConfig(): AppIconConfig {
    let appIconConfig: AppIconConfig = new AppIconConfig();
    appIconConfig.setEnableName(false)
      .setEnableNameAnim(false)
      .setEnableBadge(false)
      .setEnableMenu(false)
      .setEnableDrag(false)
      .setEnableCloneBadge(false)
      .setEnableMultiSelect(false)
      .setEnableOverlayIcon(false)
      .setEnableInstallAnimate(false)
    return appIconConfig;
  }

  /**
   * 获取带角标的静态显示图标配置
   * @param isNeedBadgeSmall 是否需要较小规格的角标
   * @returns 带角标的图标的配置项
   */
  public static getDisplayIconWithBadgeConfig(isNeedBadgeSmall: boolean): AppIconConfig {
    let appIconConfig: AppIconConfig = new AppIconConfig();
    appIconConfig.setEnableName(false)
      .setEnableBadge(true)
      .setEnableMenu(false)
      .setEnableDrag(false)
      .setIsBadgeSmaller(isNeedBadgeSmall)
      .setEnableCloneBadge(true)
      .setEnableMultiSelect(false)
      .setEnableOverlayIcon(false)
      .setEnableInstallAnimate(true)
      .setIsAdaptiveLayout(false)
    return appIconConfig;
  }

  /**
   * 获取堆叠处图标的对齐规则
   * @param index 堆叠图标序号
   * @returns 对应序号的图标的对齐规则
   */
  public static getLastThreeAlignRules(index: number): AlignRuleOption {
    if (index === 0) {
      return {
        top: { anchor: `__container__`, align: VerticalAlign.Top },
        left: { anchor: `__container__`, align: HorizontalAlign.Start }
      };
    } else if (index === 1) {
      return {
        center: { anchor: `__container__`, align: VerticalAlign.Center },
        middle: { anchor: `__container__`, align: HorizontalAlign.Center }
      };
    } else {
      return {
        bottom: { anchor: `__container__`, align: VerticalAlign.Bottom },
        right: { anchor: `__container__`, align: HorizontalAlign.End }
      };
    }
  }

  /**
   * 获取大文件夹解散动效节点的应用图标modifier
   * @returns 解散动效节点图标的modifier
   */
  public static getLastShowItemIconModifier(): BigFolderAppDefaultModifier {
    let iconModifier: BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
    iconModifier.callback = (instance: CommonAttribute) => {
      instance
        .width('100%')
        .height('100%')
    }
    return iconModifier;
  }

  /**
   * 获取主图标的配置
   * @param item 图标信息
   * @param iconRadius 图标圆角信息
   * @param folderIconExternCb 图标绑定事件集合对象
   * @returns 主图标的配置
   */
  public static getAppIconMainConfig(item: FolderAppItemInfo, iconRadius: number,
    folderIconExternCb: AppIconExternCb): AppIconConfig {
    let appIconMainConfig: AppIconConfig = new AppIconConfig();
    appIconMainConfig.setEnableBadge(true)
      .setEnableTouchMask(true)
      .setEnableShadow(false)
      .setIsBadgeSmaller(true)
      .setEnableInstallAnimate(true)
      .setEnableName(false)
      .setEnableMultiSelect(false)
      .setEnableNameAnim(false)
      .setEnableSupportCheckAndFix(true)
      .setAlignRuleOption({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .setEnableOverlayIcon(true)
      .setIsAdaptiveLayout(!DeviceHelper.isThreeFoldProduct())
      .setEnableDrag(false)
      .setAppDataOfTransactionController(AppDataWrapper.getDefaultAppData(item,
        iconRadius).setIsOpenFolder(false).setStartType(FolderIconConfigUtil.getFolderStartType(item.typeId)))
      .setExternCb(folderIconExternCb);
    return appIconMainConfig;
  }

  /**
   * 获取文件夹预览模式截图的配置
   * @returns 预览模式图标的配置
   */
  public static getBigFolderImageConfig(): AppIconConfig {
    let config: AppIconConfig = new AppIconConfig();
    config.setEnableBadge(true)
      .setEnableTouchMask(true)
      .setEnableShadow(false)
      .setIsBadgeSmaller(true)
      .setEnableBadge(false)
      .setEnableInstallAnimate(true)
      .setEnableName(false)
      .setEnableNameAnim(false)
      .setEnableOverlayIcon(true)
      .setEnableDrag(false)
      .setAppDataOfTransactionController(new AppDataWrapper().setExtraId('bigFolderContentImage'))
    return config;
  }

  /**
   * 获取展开态加号图标的配置
   * @param folderIconExternCb 自定义注入事件函数
   * @returns 展开态加号图标的配置
   */
  public static getOpenFolderAddIconConfig(folderIconExternCb: AppIconExternCb): AppIconConfig {
    let openFolderAddIconConfig: AppIconConfig = new AppIconConfig();
    openFolderAddIconConfig.setEnableBadge(false)
      .setEnableMenu(false)
      .setEnableDrag(false)
      .setEnableShadow(false)
      .setEnableBackplane(false)
      .setEnableInstallAnimate(false)
      .setEnableTouchMask(false)
      .setEnableMultiSelect(false)
      .setEnableHoverAnimation(true)
      .setEnableEffectFlag(0)
      .setIsAdaptiveLayout(true)
      .setEnableOverlayIcon(false)
      .setEnableRadiusAll(true)
      .setExternCb(folderIconExternCb);
    return openFolderAddIconConfig;
  }

  /**
   * 获取展开态图标的配置
   * @param item 展开态图标信息
   * @param iconRadius 展开态图标圆角信息
   * @param folderIconExternCb 展开态图标绑定事件集合对象
   * @returns 展开态图标的配置
   */
  public static getOpenFolderAppIconConfig(item: GridLayoutItemInfo, iconRadius: number,
    folderIconExternCb: AppIconExternCb): AppIconConfig {
    let config: AppIconConfig = new AppIconConfig();
    config.setEnableName(true)
      .setIsDesktopItem(false)
      .setEnableBackplane(false)
      .setEnableShadow(false)
      .setEnableNameAnim(true)
      .setEnableDrag(true)
      .setIsAdaptiveLayout(true)
      .setIsOpenFolder(true)
      .setEnableHoverAnimation(true)
      .setEnableSupportCheckAndFix(true)
      .setAppDataOfTransactionController(AppDataWrapper.getDefaultAppData(item as AppItemInfo, iconRadius)
        .setIsOpenFolder(true)
        .setStartType(FolderIconConfigUtil.getFolderStartType(item.typeId)))
      .setExternCb(folderIconExternCb)
    return config;
  }

  /**
   * 获取展开态加号反选界面内图标的配置
   * @param folderIconExternCb 自定义注入事件函数
   * @returns 展开态加号反选界面内的配置
   */
  public static getAddDialogBubbleConfig(folderIconExternCb: AppIconExternCb): AppIconConfig {
    let config = new AppIconConfig();
    config.setEnableBadge(false)
      .setEnableMenu(false)
      .setEnableDrag(false)
      .setEnableBackplane(false)
      .setEnableInstallAnimate(true)
      .setEnableHoverAnimation(true)
      .setEnableTouchMask(false)
      .setEnableWallpaperFontColor(false)
      .setEnableMultiSelect(false)
      .setExternCb(folderIconExternCb);
    let appDataWrapper: AppDataWrapper = new AppDataWrapper();
    appDataWrapper.setExtraId(CommonConstants.FOLDER_ADD_IMAGE_TAG);
    config.setAppDataOfTransactionController(appDataWrapper);
    return config;
  }

  /**
   * 设置小文件夹内config
   * @param smallFolderConfig 配置对象
   */
  public static initSmallFolderAppIconConfig(smallFolderConfig: AppIconConfig): void {
    smallFolderConfig.setEnableMenu(false)
      .setEnableName(false)
      .setEnableBadge(false)
      .setEnableInstallAnimate(false)
      .setEnableMultiSelect(false)
      .setEnableTouchMask(false)
      .setEnableCloneBadge(false)
  }

  /**
   * 获取文件夹图标启动类型
   * @param typeId 图标类型id
   * @returns 文件夹图标启动类型
   */
  public static getFolderStartType(typeId: number | undefined): StartType {
    if (CheckEmptyUtils.isEmpty(typeId)) {
      return StartType.FOLDER;
    }
    return typeId === CommonConstants.TYPE_SHORTCUT_ICON ? StartType.SHORTCUT_APP : StartType.FOLDER;
  }

  /**
   * 获取截图图标组件config
   * @param smallFolderConfig 小文件夹配置config
   * @returns 截图图标组件config
   */
  public static getSmallFolderImageConfig(smallFolderConfig: AppIconConfig): AppIconConfig {
    let appDataWrapper: AppDataWrapper = new AppDataWrapper();
    appDataWrapper.setExtraId(CommonConstants.SMALL_FOLDER_IMAGE_TAG);
    smallFolderConfig.setAppDataOfTransactionController(appDataWrapper);
    return smallFolderConfig;
  }

  /**
   * 获取主图标的配置
   *
   * @param item 图标信息
   * @param iconRadius 图标圆角信息
   * @param folderId 文件夹id
   * @param isAccessibilityMode
   * @returns 主图标的配置
   */
  public static getIconConfig(item: GridLayoutItemInfo, iconRadius: number, folderId: string,
    isAccessibilityMode: boolean, isLayout1x1: boolean): AppIconConfig {
    let appIconMainConfig: AppIconConfig = new AppIconConfig();
    appIconMainConfig
      .setEnableBadge(!isLayout1x1)
      .setEnableCloneBadge(!isLayout1x1)
      .setEnableTouchMask(!isLayout1x1)
      .setEnableShadow(false)
      .setIsBadgeSmaller(true)
      .setEnableInstallAnimate(true)
      .setEnableName(false)
      .setEnableMultiSelect(false)
      .setEnableNameAnim(false)
      .setAlignRuleOption({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .setEnableOverlayIcon(false)
      .setEnableDrag(false)
      .setExternCb(isLayout1x1 ? FolderIconConfigUtil.getSmallFolderIconExternCb(folderId) :
      FolderIconConfigUtil.getFolderIconExternCb(folderId, isAccessibilityMode, item));
    // 配置应用启动退出的transitionController
    let appDataWrapper: AppDataWrapper = new AppDataWrapper();
    if (isLayout1x1) {
      appDataWrapper.setExtraId(CommonConstants.SMALL_FOLDER_IMAGE_TAG);
    } else {
      appDataWrapper = AppDataWrapper.getDefaultAppData(item as AppItemInfo, iconRadius);
      appDataWrapper.setIsOpenFolder(false).setStartType(FolderIconConfigUtil.getFolderStartType(item.typeId))
    }
    appIconMainConfig.setAppDataOfTransactionController(appDataWrapper);
    return appIconMainConfig;
  }

  private static getSmallFolderIconExternCb(folderId: string): AppIconExternCb {
    return {
      onIconClick: (event?: ClickEvent, fingers?: number): void => {
        let eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
          .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
        eventMgr.onClick('click small folder gird icon', folderId, FolderClickType.GRID_CLICK);
      }
    }
  }

  public static getDeliveryFolderIconConfig(folderId: string, iconConfig: AppIconConfig, isAccessibilityMode: boolean,
    isLayout1x1: boolean, onAppClick: (item: AppItemInfo) => void, item: AppItemInfo): AppIconConfig {
    const iconExternCb: AppIconExternCb = isLayout1x1 ? FolderIconConfigUtil.getSmallFolderIconExternCb(folderId) :
      FolderIconConfigUtil.getDeliveryFolderIconExternCb(folderId, isAccessibilityMode, item, onAppClick);
    iconExternCb.enableHandleTouchEvent = iconConfig.externCb?.enableHandleTouchEvent;
    iconConfig.setExternCb(iconExternCb);
    return iconConfig
  }

  /**
   * 获取大文件夹主应用区图标modifier
   *
   * @returns 文件夹图标对应modifier
   */
  public static getBigFolderIconModifier(): BigFolderAppDefaultModifier {
    let bigFolderMainIconModifier: BigFolderAppDefaultModifier = new BigFolderAppDefaultModifier();
    bigFolderMainIconModifier.callback = (instance: CommonAttribute) => {
      instance
        .responseRegion({
          x: '-10%',
          y: '-10%',
          width: '120%',
          height: '120%',
        })
    }
    return bigFolderMainIconModifier;
  }

  /**
   * 获取主图标对应绑定事件集合
   *
   * @param item 图标信息
   * @returns 主图标对应绑定事件集合
   */
  private static getFolderIconExternCb(folderId: string, isAccessibilityMode: boolean,
    item: GridLayoutItemInfo): AppIconExternCb {
    return {
      onIconClick: !isAccessibilityMode ? (event?: ClickEvent, fingers?: number): void => {
        let eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
          .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
        eventMgr.onClick('click icon', folderId, FolderClickType.ICON_CLICK, item);
      } : undefined,
      onIconTouch: (event?: TouchEvent): void => {
        let eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
          .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
        eventMgr.onTouch('touch icon', folderId, event, item);
      }
    }
  }

  /**
   * 获取图标对应绑定事件集合
   *
   * @param item 图标信息
   * @returns 主图标对应绑定事件集合
   */
  private static getDeliveryFolderIconExternCb(folderId: string, isAccessibilityMode: boolean, item: AppItemInfo,
    onAppClick: (item: AppItemInfo) => void): AppIconExternCb {
    return {
      onIconClick: !isAccessibilityMode ? (event?: ClickEvent, fingers?: number): void => onAppClick(item) : undefined,
      onIconTouch: (event?: TouchEvent): void => {
        let eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
          .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
        eventMgr.onTouch('touch icon', folderId, event, item as GridLayoutItemInfo);
      }
    }
  }

  /**
   * 获取截图图标组件config
   * @param smallFolderConfig 小文件夹配置config
   * @returns 截图图标组件config
   */
  public static getFolderImageConfig(): AppIconConfig {
    let config: AppIconConfig = new AppIconConfig();
    FolderIconConfigUtil.initSmallFolderAppIconConfig(config);
    let appDataWrapper: AppDataWrapper = new AppDataWrapper();
    appDataWrapper.setExtraId(CommonConstants.SMALL_FOLDER_IMAGE_TAG);
    config.setAppDataOfTransactionController(appDataWrapper);
    return config;
  }
}