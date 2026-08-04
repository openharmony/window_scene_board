/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import {
  CheckEmptyUtils,
  CompanionIconInfo,
  LogDomain,
  LogHelper,
  SingletonHelper,
  StartType
} from '@ohos/basicutils';
import { sOutSideWindowMgr, GlobalContext, IntelligentCache, sSettingsUtil, } from '@ohos/frameworkwrapper';
import { NumberConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { ObjectCopyUtil, ItemUtils, RTLUtil, desktopUtil } from '@ohos/componenthelper';
import { AppExitLocationInfo, launcherStatusUtil, SceneInfoAdapterUtil } from '@ohos/windowscene';
import { RectInfo } from '@ohos/basicutils';
import { SCBSceneContainerSession, AppInFolderInfo } from '@ohos/windowscene';
import {
  AppIconModel,
  AppItemInfo,
  AppStatus,
  BigFolderStyleConfig,
  CloseAppManager,
  CommonConstants,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutStyle,
  ContractedFolderLayoutViewModel,
  DesktopModeManager,
  editModeManager,
  FolderManager,
  FolderModel,
  FolderStyleConstants,
  GridLayoutConfig,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  LayoutViewModel,
  PageDesktopModel,
  RadiusUtil,
  SwiperPageType
} from '@ohos/launchercommon';
import FeatureConstants from '@ohos/bigfolder/src/main/ets/default/common/constants/FeatureConstants';
import GridLayoutUtil, { ItemsCount } from '@ohos/launchercommon/src/main/ets/utils/GridLayoutUtil';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { FolderStyleManager, FolderViewData, SwiperPageManager } from '@ohos/launchercommon/Index';
import { BaseIconInfo } from '@ohos/launchercommon/src/main/ets/bean/BaseIconInfo';
import OpenFolderDragHandler from '@ohos/bigfolder/src/main/ets/default/common/OpenFolderDragHandler';

const TAG = 'QuitAppRectViewModel';
const TAG_BASE = 'BaseQuitAppRect';
const BUNDLE = 'com.ohos.browser';
const ICONID = 'Browser_Feed_Default';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class GridParam {
  // 纵向参数
  public gridHeight: number = 0;
  public offsetY: number = 0;
  public gridItemHeight: number = 0;
  public gridRow: number = 0;
  public gridRowGap: number = 0;
  public gridTopPadding: number = 0; // 已取整
  public gridItemTopPadding: number = 0; // 已取整
  // 横向参数
  public gridWidth: number = 0;
  public offsetX: number = 0;
  public gridItemWidth: number = 0;
  public gridColumn: number = 0;
  public gridColumnGap: number = 0;
  public gridLeftPadding: number = 0; // 已取整
  public gridItemLeftPadding: number = 0; // 已取整
  public gridIconSize: number = 0;
  public gridIconRadius: number = 0;

  /**
   * 获取网格宽度与横向间距和
   * @returns
   */
  public itemWidthAddColumnGap(): number {
    return this.gridItemWidth + this.gridColumnGap;
  }

  /**
   * 获取网格高度与纵向间距和
   * @returns
   */
  public itemHeightAddRowGap(): number {
    return this.gridItemHeight + this.gridRowGap;
  }
}

export class QuitAppRectViewModel {
  private baseQuitAppRect = BaseQuitAppRect.getInstance();
  private folderPageAppNum: number = 0;
  private folderColumn: number = 0;
  private folderRow: number = 0;
  // 展开态文件夹及桌面应用图标的X坐标最大最小值
  private openFolderLeftX = 0;
  private openFolderRightX = 0;
  private desktopLeftX = 0;
  private desktopRightX = 0;
  private currentAppExitInfo: AppExitLocationInfo | null = null;

  // 布局元素类型
  private typeIds: number[] = [
    CommonConstants.TYPE_APP,
    CommonConstants.TYPE_CARD,
    CommonConstants.TYPE_FOLDER,
    CommonConstants.TYPE_FORM_STACK,
    CommonConstants.TYPE_SHORTCUT_ICON,
  ]
  private transparentCardAnimationNum: number = 0;

  static getInstance(): QuitAppRectViewModel {
    return SingletonHelper.getInstance(QuitAppRectViewModel, TAG);
  }

  private getCompanionIconInfo(container: SCBSceneContainerSession): CompanionIconInfo {
    let companionIconInfo = container.companionIconInfo;
    let sceneInfo = container.getFocusedSession()?.sceneInfo;
    if (!sceneInfo) {
      return companionIconInfo;
    }

    let iconInfo = container.companionIconInfo ?? {} as CompanionIconInfo;
    iconInfo.bundleName = SceneInfoAdapterUtil.getAdapterBundleName(sceneInfo.bundleName ?? '');
    iconInfo.abilityName = sceneInfo.abilityName ?? '';
    iconInfo.moduleName = sceneInfo.moduleName ?? '';
    iconInfo.appIndex = sceneInfo.appIndex ?? 0;
    iconInfo.shortcutId = companionIconInfo?.shortcutId ?? '';
    container.companionIconInfo = iconInfo;
    log.showWarn(`getCompanionIconInfo bundleName:${iconInfo.bundleName}, abilityName:${iconInfo.abilityName},` +
      ` moduleName:${iconInfo.moduleName}, appIndex:${iconInfo.appIndex}, shortcutId:${iconInfo.shortcutId}`);
    return iconInfo;
  }

  /**
   * 初始化currentAppExitInfo
   */
  public initCurAppExitInfo() {
    this.currentAppExitInfo = null;
  }

  /**
   * 退出过程中滑动桌面获取指定应用、卡片等的位置信息
   * @param sceneContainerSession 需要获取信息的app容器
   * @returns 应用、卡片等的位置信息
   */
  public buildAppExitInfoInExitSlide(container: SCBSceneContainerSession): AppExitLocationInfo {
    log.showInfo(`buildAppExitInfoInExitSlide iconId ${container.companionIconInfo?.iconId}`);
    if (this.currentAppExitInfo) {
      return ObjectCopyUtil.deepClone(this.currentAppExitInfo);
    }
    return { type: null, iconRect: null, pageIndex: null, isInScreen: false, appInFolderInfo: null };
  }

  /**
   * 退出过程中获取指定应用、卡片等的位置信息
   * @param sceneContainerSession 需要获取信息的app容器
   * @returns 应用、卡片等的位置信息
   */
  public buildAppExitInfoInExit(container: SCBSceneContainerSession): AppExitLocationInfo {
    log.showWarn(`buildAppExitInfoInExit iconId ${container?.companionIconInfo?.iconId}`);
    let appExitInfo: AppExitLocationInfo = this.buildAppExitInfo(container);
    if (appExitInfo?.type) {
      SwiperPageManager.getInstance()
        .executeCallbackByType(appExitInfo.type, appExitInfo.pageIndex ?? 0);
      appExitInfo.isInScreen = true;
    }
    if (appExitInfo.isInScreen && appExitInfo.iconRect && container.companionIconInfo) {
      container.companionIconInfo.iconRect = appExitInfo.iconRect;
    }
    this.currentAppExitInfo = ObjectCopyUtil.deepClone(appExitInfo);
    desktopUtil.setTouchItemPage(appExitInfo?.pageIndex);
    return appExitInfo;
  }

  /**
   * 获取指定应用、卡片等的位置信息
   * @param sceneContainerSession 需要获取信息的app容器
   * @returns 应用、卡片等的位置信息
   */
  public buildAppExitInfo(container: SCBSceneContainerSession): AppExitLocationInfo {
    // 退出应用时清除overlay动效信息
    container.overlayCardTransition = null;
    let companionIconInfo = container.companionIconInfo;
    log.showWarn(`startAppType ${companionIconInfo?.startAppType}, iconId ${companionIconInfo?.iconId}`);
    let appExitInfo: AppExitLocationInfo = {
      type: null,
      iconRect: null,
      pageIndex: null,
      isInScreen: false,
      appInFolderInfo: null
    };

    if (this.canDirectExit(companionIconInfo)) { // companionIconInfo为null，全搜及热应急模式直接中心退出
      return appExitInfo;
    }
    // pickerLaunchStatus=true，海报编辑界面直接中心退出
    if (editModeManager.getPickerLaunchStatus()) {
      log.showWarn(`buildAppExitInfo pickerLaunchStatus：true`);
      return appExitInfo;
    }
    if (sOutSideWindowMgr.isShowNegative() && !sOutSideWindowMgr.getDesktopEnabled()) {
      // 处于负一屏状态需要单独处理
      let rect = IntelligentCache.getInstance().calculateNegativeRect(companionIconInfo);
      if (rect) {
        appExitInfo.iconRect = rect;
        appExitInfo.isInScreen = true;
      }
      return appExitInfo;
    }

    let exitInfo = PageDesktopModel.getInstance().buildAppExitInfo(container);
    if (exitInfo && this.checkRectInfoNotEmpty(this.desktopLeftX, this.desktopRightX, exitInfo.iconRect)) {
      return exitInfo;
    }

    const folderMgr: FolderManager = FolderManager.getInstance();
    const openFolderId: string = folderMgr.getOpenFolderId();
    const isOpenFolder: boolean = folderMgr.isFolderOpen();
    // 未能获取到则重置companionIconInfo信息重新获取
    appExitInfo = { type: null, iconRect: null, pageIndex: null, isInScreen: false, appInFolderInfo: null };
    this.getCompanionIconInfo(container);
    // 从桌面或dock区获取应用落位信息
    this.buildAppExitInfoInDesktop(companionIconInfo, appExitInfo, isOpenFolder, openFolderId);
    if (appExitInfo && this.checkRectInfoNotEmpty(this.desktopLeftX, this.desktopRightX, appExitInfo.iconRect)) {
      return appExitInfo;
    }
    log.showWarn(`buildAppExitInfo failed`);
    return { type: null, iconRect: null, pageIndex: null, isInScreen: false, appInFolderInfo: null };
  }

  private checkRectInfoNotEmpty(left: number, right: number, iconRect?: RectInfo | null): boolean {
    if (iconRect && iconRect.left > left && iconRect.top > 0 && iconRect.right < right) {
      return true;
    }
    return false;
  }

  private buildAppExitInfoInDesktop(companionIconInfo: CompanionIconInfo, appExitInfo: AppExitLocationInfo,
                                    isOpenFolder: boolean, openFolderId: string): void {
    // 从桌面或dock区获取应用信息
    let iconInfo: BaseIconInfo = {
      bundleName: companionIconInfo.bundleName,
      abilityName: companionIconInfo.abilityName,
      shortcutId: companionIconInfo.shortcutId,
      moduleName: companionIconInfo.moduleName,
      appIndex: companionIconInfo.appIndex,
    }
    const keyName: string = AppItemInfo.getKeyName(iconInfo);
    let layoutCacheManager = LaunchLayoutCacheManager.getInstance();
    const folderId = isOpenFolder ? openFolderId : undefined;
    let isDesktopApp: boolean = true;
    let layoutItemInfos: GridLayoutItemInfo[];
    layoutItemInfos = layoutCacheManager.getDesktopAppInfo(keyName, this.typeIds, folderId);
    if (CheckEmptyUtils.isEmptyArr(layoutItemInfos) || CheckEmptyUtils.isEmpty(layoutItemInfos[0])) {
      log.showWarn(`app is not in desktop`);
      isDesktopApp = false;
      layoutItemInfos = layoutCacheManager.getDockAppInfo(keyName, this.typeIds, folderId);
      if (CheckEmptyUtils.isEmptyArr(layoutItemInfos) || CheckEmptyUtils.isEmpty(layoutItemInfos[0])) {
        log.showWarn(`app is not in dock`);
        appExitInfo.iconRect = null;
        return;
      }
    }

    if (layoutItemInfos[0].appStatus !== AppStatus.INSTALLED) {
      log.showWarn('appStatus is not INSTALLED');
      appExitInfo.iconRect = null;
      return;
    }

    // 展开态文件夹设置翻页信息及计算区域
    if (isOpenFolder) {
      appExitInfo.pageIndex = (layoutItemInfos[0].page as number) ?? 0;
      this.openFolderSwiper(appExitInfo);
      this.calculateOpenFolderAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
      return;
    }

    if (isDesktopApp) {
      this.buildAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
      return;
    }

    // dock区图标
    if (layoutItemInfos.length === 1 && !isDesktopApp) {
      this.calculateDockAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
      return;
    }

    // dock区小文件夹计算
    if (this.isSmallFolderApp(layoutItemInfos)) {
      this.calculateShrinkSmallFolderAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
      return;
    }
  }

  private isSmallFolderApp(layoutItemInfos: GridLayoutItemInfo[]): boolean {
    if (CheckEmptyUtils.isEmpty(layoutItemInfos[1])) {
      return false;
    }
    let area = layoutItemInfos[1].area;
    return (area?.[0] ?? 1) === 1 && (area?.[1] ?? 1) === 1;
  }

  private buildAppRect(companionIconInfo: CompanionIconInfo, layoutItemInfos: GridLayoutItemInfo[],
                       appExitInfo: AppExitLocationInfo): void {
    appExitInfo.pageIndex = (layoutItemInfos[1]?.page as number) ?? ((layoutItemInfos[0].page as number) ?? 0);
    this.desktopSwiper(appExitInfo);

    // 桌面应用的计算
    if (CheckEmptyUtils.isEmpty(layoutItemInfos[1])) {
      this.calculateDesktopAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
      return;
    }

    // 桌面区域大文件夹计算
    if (!this.isSmallFolderApp(layoutItemInfos)) {
      this.calculateShrinkBigFolderAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
      return;
    }

    // 桌面区域的小文件夹计算
    this.calculateShrinkDesktopSmallFolderAppRect(companionIconInfo, layoutItemInfos, appExitInfo);
  }

  private setIconRect(appExitInfo: AppExitLocationInfo, iconId: string, left: number, right: number): void {
    appExitInfo.iconRect = ItemUtils.getRectById(iconId);
    log.showWarn('AppExitRectInfo VP top: %{public}d, left: %{public}d, width: %{public}d, ',
      appExitInfo?.iconRect?.top, appExitInfo?.iconRect?.left, appExitInfo?.iconRect?.width);
    if (!this.checkRectInfoNotEmpty(left, right, appExitInfo.iconRect)) {
      appExitInfo.iconRect = null;
      return;
    }
    appExitInfo.iconRect.radius = this.baseQuitAppRect.getIconRadius(appExitInfo.iconRect?.width);
  }

  /**
   * 无需计算落位信息的情况
   * @param companionIconInfo 容器的icon信息
   * @returns true可以直接返回无需找位
   */
  private canDirectExit(companionIconInfo: CompanionIconInfo | null): boolean {
    if (!companionIconInfo) {
      log.showWarn('companionIconInfo is null');
      return true;
    }
    if (DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()) {
      log.showWarn('isInEmergencyOrThermalSafeMode');
      return true;
    }
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showWarn('app start or exit in globalSearch');
      return true;
    }
    let createFormId = AppStorage.get<string>('createFormId');
    if (createFormId) {
      log.showWarn('ailife add card');
      return true;
    }
    return false;
  }

  private setStartAppType(companionIconInfo: CompanionIconInfo, itemInfo: GridLayoutItemInfo,
    isFolderApp: boolean): void {
    log.showWarn(`setStartAppType itemType: ${itemInfo.typeId}, isFolderApp: ${isFolderApp}`);
    if (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      companionIconInfo.startAppType = StartType.SHORTCUT_APP;
    } else if (isFolderApp) {
      companionIconInfo.startAppType = StartType.FOLDER;
    } else {
      companionIconInfo.startAppType = StartType.APP;
    }
    // 更新startType后通知CompanionIcon组件刷新
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_UPDATE_START_APP_TYPE,
      companionIconInfo.startAppType);
  }

  /**
   * 计算桌面应用的位置信息
   * @param appExitInfo 用于保存应用、卡片等的位置信息
   * @param gridLayoutItemInfos 应用、卡片等缓存的页，行，列等信息
   * @param pageDesktopModel 用于获取当前桌面页
   * @returns 应用、卡片等的位置信息
   */
  private calculateDesktopAppRect(companionIconInfo: CompanionIconInfo, layoutItemInfos: GridLayoutItemInfo[],
                                  appExitInfo: AppExitLocationInfo): void {
    let iconId: string =
      AppIconModel.getInstance()
        .getIconId(layoutItemInfos[0] as AppItemInfo, undefined, launcherStatusUtil.getShowOutLauncherStatus());
    log.showWarn(`calculateDesktopAppRect iconId:${iconId}`);
    appExitInfo.iconRect = this.baseQuitAppRect.getRectDesktop(layoutItemInfos[0]);
    if (appExitInfo.iconRect) {
      companionIconInfo.iconId = iconId;
      this.setStartAppType(companionIconInfo, layoutItemInfos[0], false);
    }
  }

  private getSmallFolderId(folderId?: string): string {
    return `${CommonConstants.FOLDER_GRID_TAG}${folderId}`;
  }

  private updateCompanionIconInfoWithSmallFolder(companionIconInfo: CompanionIconInfo, folderId?: string): void {
    companionIconInfo.iconId = this.getSmallFolderId(folderId);
    companionIconInfo.smallFolderId = folderId;
  }

  private calculateShrinkDesktopSmallFolderAppRect(companionIconInfo: CompanionIconInfo,
                                                   layoutItemInfos: GridLayoutItemInfo[],
                                                   appExitInfo: AppExitLocationInfo): void {
    if (CheckEmptyUtils.isEmpty(layoutItemInfos[1])) {
      return;
    }
    let iconId = this.getSmallFolderId(layoutItemInfos[1].folderId);
    log.showWarn(`calculateShrinkDesktopSmallFolderAppRect iconId: ${iconId}`);
    appExitInfo.iconRect = this.baseQuitAppRect.getRectDesktop(layoutItemInfos[1]);
    this.updateCompanionIconInfoWithSmallFolder(companionIconInfo, layoutItemInfos[1].folderId);
  }

  private calculateShrinkSmallFolderAppRect(companionIconInfo: CompanionIconInfo, layoutItemInfos: GridLayoutItemInfo[],
                                            appExitInfo: AppExitLocationInfo): void {
    if (CheckEmptyUtils.isEmpty(layoutItemInfos[1])) {
      return;
    }
    let iconId = this.getSmallFolderId(layoutItemInfos[1].folderId);
    log.showWarn(`calculateShrinkSmallFolderAppRect iconId: ${iconId}`);
    this.setIconRect(appExitInfo, iconId, this.desktopLeftX, this.desktopRightX);
    if (appExitInfo.iconRect) {
      this.updateCompanionIconInfoWithSmallFolder(companionIconInfo, layoutItemInfos[1].folderId);
    }
  }

  private calculateDockAppRect(companionIconInfo: CompanionIconInfo, layoutItemInfos: GridLayoutItemInfo[],
    appExitInfo: AppExitLocationInfo): void {
    let iconId: string = AppIconModel.getInstance().getIconId(layoutItemInfos[0] as AppItemInfo, undefined, false);
    log.showWarn(`calculateDockAppRect iconId: ${iconId}`);
    this.setIconRect(appExitInfo, iconId, this.desktopLeftX, this.desktopRightX);
    if (appExitInfo.iconRect) {
      companionIconInfo.iconId = iconId;
      this.setStartAppType(companionIconInfo, layoutItemInfos[0], false);
    }
  }

  private calculateShrinkBigFolderAppRect(companionIconInfo: CompanionIconInfo, layoutItemInfos: GridLayoutItemInfo[],
                                          appExitInfo: AppExitLocationInfo): void {
    let area = layoutItemInfos[1].area;
    let shrinkFolderAppCount = GridLayoutUtil.getCountPerPageInFolder(area ?? [2, 2]);
    let indexInFolder = (layoutItemInfos[0].page ?? 0) * this.folderPageAppNum + (layoutItemInfos[0].row ?? 0) *
    this.folderColumn + (layoutItemInfos[0].column ?? 0) + 1;
    const lowerRightIndex: number = shrinkFolderAppCount + 1;
    log.showWarn(`indexInFolder: ${indexInFolder}, lowerRightIndex: ${lowerRightIndex}`);
    let iconId = '';
    if (indexInFolder > lowerRightIndex) {
      iconId = this.getIconIdByAppInfo(iconId, lowerRightIndex, layoutItemInfos[1].layoutInfo);
      log.showWarn(`calculateShrinkFolderAppRect getIconIdByAppInfo iconId:${iconId}`);
    } else {
      iconId = AppIconModel.getInstance().getIconId(layoutItemInfos[0] as AppItemInfo, undefined, false);
      log.showWarn(`calculateShrinkFolderAppRect getAppIconImageId iconId:${iconId}`);
    }
    appExitInfo.iconRect = this.baseQuitAppRect.getRectShrinkFolder(layoutItemInfos);
    if (appExitInfo.iconRect) {
      companionIconInfo.iconId = iconId;
      if (appExitInfo.iconRect.radius !== undefined) {
        companionIconInfo.iconRadius = appExitInfo.iconRect.radius;
      }
      this.setStartAppType(companionIconInfo, layoutItemInfos[0], true);
      appExitInfo.appInFolderInfo = this.getAppInFolderInfo(layoutItemInfos, true, indexInFolder, shrinkFolderAppCount);
    }
  }

  private getAppInFolderInfo(layoutItemInfos: GridLayoutItemInfo[], isSmallFolderApp: boolean,
                             indexInFolder: number, shrinkFolderAppCount: number): AppInFolderInfo {
    let startType: StartType = StartType.FOLDER;
    if (layoutItemInfos[0].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      startType = StartType.SHORTCUT_APP;
    }
    return {
      folderId: layoutItemInfos[1].folderId ?? '',
      isSmallFolder: isSmallFolderApp,
      index: indexInFolder,
      size: shrinkFolderAppCount,
      bundleName: layoutItemInfos[0].bundleName,
      abilityName: layoutItemInfos[0].abilityName,
      appIndex: layoutItemInfos[0].appIndex ?? 0,
      shortcutId: layoutItemInfos[0].shortcutId ?? '',
      startType: startType,
    };
  }

  private openFolderSwiper(appExitInfo: AppExitLocationInfo): void {
    const curPageIndex: number = FolderManager.getInstance().getPageIndex();
    if (curPageIndex !== appExitInfo.pageIndex) {
      appExitInfo.type = SwiperPageType.FOLDER_SWIPER;
      appExitInfo.isInScreen = false;
    }
  }

  private desktopSwiper(appExitInfo: AppExitLocationInfo): void {
    const curPageIndex: number = PageDesktopModel.getInstance().getPageIndex();
    if (curPageIndex !== appExitInfo.pageIndex) {
      appExitInfo.type = SwiperPageType.DESKTOP_SWIPER;
      appExitInfo.isInScreen = false;
    }
  }

  private calculateOpenFolderAppRect(companionIconInfo: CompanionIconInfo, layoutItemInfos: GridLayoutItemInfo[],
                                     appExitInfo: AppExitLocationInfo): void {
    let iconId: string = AppIconModel.getInstance().getIconId(layoutItemInfos[0] as AppItemInfo, undefined,
      false, true);
    log.showWarn(`calculateOpenFolderAppRect iconId:${iconId}`);
    appExitInfo.iconRect = this.baseQuitAppRect.getRectOpenFolder(layoutItemInfos);
    if (appExitInfo.iconRect) {
      companionIconInfo.iconId = iconId;
      this.setStartAppType(companionIconInfo, layoutItemInfos[0], true);
    }
  }

  private getIconIdByAppInfo(iconId: string, targetIndex: number, layoutInfo?: Array<GridLayoutItemInfo[]>): string {
    if (!layoutInfo) {
      return iconId;
    }
    let folderIndex: number = -1;
    for (let columnEment of layoutInfo) {
      for (let rowEment of columnEment) {
        folderIndex++;
        if (folderIndex === targetIndex) {
          log.showWarn(`oldiconId: ${iconId}`);
          iconId =
            AppIconModel.getInstance().getIconId(rowEment as AppItemInfo, undefined,
              launcherStatusUtil.getShowOutLauncherStatus());
          log.showWarn(`newiconId: ${iconId}`);
        }
      }
    }
    return iconId;
  }

  /**
   * 初始化桌面网格的相关参数
   * @param screenWidth 屏幕宽度
   * @param iconSize 桌面图标尺寸
   */
  public initSwiperParam(screenWidth: number) {
    screenWidth = AppStorage.get<number>('screenWidth') as number ?? screenWidth;
    const openFolderConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
    NumberConstants.OPEN_FOLDER_SWIPER_BORDER_WIDTH;
    let openFolderWidth = vp2px(openFolderConfig.mOpenFolderGridWidth +
      openFolderConfig.folderHorizontalPending * NumberConstants.CONSTANT_NUMBER_TWO);
    let leftPx = this.baseQuitAppRect.round((vp2px(screenWidth) - openFolderWidth) / 2);
    this.openFolderLeftX = px2vp(leftPx);
    this.openFolderRightX = px2vp(leftPx + openFolderWidth);
    this.desktopLeftX = 0;
    this.desktopRightX = screenWidth;
    log.showWarn(`initSwiperParam openFolderLeftX:${this.openFolderLeftX}, openFolderRightX:${this.openFolderRightX},` +
      ` desktopLeftX:${this.desktopLeftX}, desktopRightX:${this.desktopRightX}, screenWidth: ${screenWidth}`);
    const folderOpenLayout = FolderModel.getInstance().getFolderOpenLayout();
    this.folderColumn = folderOpenLayout?.column;
    this.folderRow = folderOpenLayout?.row;
    this.folderPageAppNum = this.folderColumn * this.folderRow;
    LaunchLayoutCacheManager.getInstance().setOpenFolderParam(this.folderPageAppNum, this.folderColumn, this.folderRow);
  }

  public addTransparentCardCount(): void {
    this.transparentCardAnimationNum++;
  }

  public getTransparentCardCount(): number {
    log.showWarn(`getTransparentCardCount:${this.transparentCardAnimationNum}`);
    return this.transparentCardAnimationNum;
  }

  public clearTransparentCardCount(): void {
    this.transparentCardAnimationNum = 0;
  }

  /**
   * 注册文件夹数据变化监听
   */
  public registerFolderStyleListener(): void {
    ContractedFolderCommonViewModel.getInstance().registerQuitAppListener(this.baseQuitAppRect.mQuitAppCallback);
  }
}

export class BaseQuitAppRect {
  // 桌面网格的参数
  public gridDesktopTopDistance: number = 0;
  public desktopGridParam: GridParam = new GridParam();
  // 收缩态文件夹的网格的相关参数
  public folderGridParamMap: Map<string, GridParam> = new Map();
  public mapTest: Map<number, number> = new Map().set(1, 1).set(3, 2).set(6, 4);
  // 展开态文件夹的网格的相关参数
  public gridOpenFolderLeftDistance: number = 0;
  public gridOpenFolderTopDistance: number = 0;
  public folderPageAppNum: number = 0;
  public folderColumn: number = 0;
  public folderRow: number = 0;
  public openFolderGridParam: GridParam = new GridParam();
  public mQuitAppCallback: (folderStyle: ContractedFolderLayoutStyle) => void =
    (folderStyle: ContractedFolderLayoutStyle): void => {
      let config: BigFolderStyleConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
      this.initGridParamShrinkFolderNew(folderStyle, config, 1, 1);
    }

  static getInstance(): BaseQuitAppRect {
    return SingletonHelper.getInstance(BaseQuitAppRect, TAG_BASE);
  }

  /**
   * arkUI内像素取整的四舍五入算法
   * @param value 需要四舍五入的值
   * @returns 四舍五入后的值
   */
  public round(value: number): number {
    const floorValue: number = Math.floor(value);
    if (value - floorValue > 0.5) {
      return Math.ceil(value);
    } else {
      return floorValue;
    }
  }

  public getIconRadius(iconSize?: number): number | undefined {
    if (!iconSize) {
      return undefined;
    }
    return RadiusUtil.calculateRadius(iconSize);
  }

  /**
   * 初始化桌面网格的相关参数
   * @param screenWidth 屏幕快读
   * @param pageDesktopStyleConfig 桌面相关参数
   * @param gridLayoutConfig 布局相关参数
   */
  public initGridParamDesktop(pageDesktopStyleConfig: PageDesktopGridStyleConfig, gridLayoutConfig: GridLayoutConfig) {
    this.desktopGridParam.gridIconSize = vp2px(pageDesktopStyleConfig.mIconSize);

    this.desktopGridParam.gridHeight = vp2px(pageDesktopStyleConfig.mGridHeight);
    this.desktopGridParam.gridRow = gridLayoutConfig.row;
    this.desktopGridParam.gridRowGap = vp2px(pageDesktopStyleConfig.mRowsGap);
    const gridTopPadding = vp2px(pageDesktopStyleConfig.mScreenPaddingTop);
    this.desktopGridParam.gridTopPadding = Math.floor(gridTopPadding);
    const gridBottomPadding = vp2px(pageDesktopStyleConfig.mScreenPaddingBottom);
    this.desktopGridParam.gridItemHeight = (this.desktopGridParam.gridHeight - gridTopPadding - gridBottomPadding +
    this.desktopGridParam.gridRowGap) / this.desktopGridParam.gridRow - this.desktopGridParam.gridRowGap;
    this.desktopGridParam.gridItemTopPadding = Math.floor(vp2px(pageDesktopStyleConfig.mItemPadding));

    this.desktopGridParam.gridWidth = vp2px(pageDesktopStyleConfig.mGridWidth);
    this.desktopGridParam.gridColumn = gridLayoutConfig.column;
    this.desktopGridParam.gridColumnGap = vp2px(pageDesktopStyleConfig.mColumnsGap);
    const gridLeftPadding = vp2px(pageDesktopStyleConfig.mScreenPadding);
    this.desktopGridParam.gridLeftPadding = Math.floor(gridLeftPadding);
    const gridRightPadding = gridLeftPadding;
    this.desktopGridParam.gridItemWidth = (this.desktopGridParam.gridWidth - gridLeftPadding - gridRightPadding +
    this.desktopGridParam.gridColumnGap) / this.desktopGridParam.gridColumn - this.desktopGridParam.gridColumnGap;
    this.desktopGridParam.gridItemLeftPadding = this.round((this.desktopGridParam.gridItemWidth -
    this.desktopGridParam.gridIconSize) / 2);

    this.gridDesktopTopDistance = this.getPaddingTop(pageDesktopStyleConfig);
    log.showWarn(`gridDesktopTopDistance left:${this.gridDesktopTopDistance}`);
  }

  private getPaddingTop(config: PageDesktopGridStyleConfig): number {
    let paddingTop = config.mDesktopMarginTop + config.mScreenPaddingTop;
    let sysUITop: number = LayoutViewModel.getInstance().getSysUITopHeight();
    // 桌面布局中Swiper组件的上间距为sysUITop，Grid组件的上间距为paddingTop - sysUITop，需要分开进行像素向下取整
    return Math.floor(vp2px(sysUITop)) + Math.floor(vp2px(paddingTop - sysUITop));
  }

  /**
   * 初始化收缩态文件夹网格的相关参数
   * @param mViewData 文件夹相关参数
   * @param bigFolderStyleConfig 大文件夹相关参数
   * @param paddingScale 内边距转换率
   * @param gridGapScale 网格间距转换率
   */
  public initGridParamShrinkFolder(mViewData: FolderViewData, bigFolderStyleConfig: BigFolderStyleConfig,
                                   paddingScale: number, gridGapScale: number): void {
    let gridParam: GridParam = new GridParam();
    let mFolderAppSize = bigFolderStyleConfig.mFolderAppSize;
    let mGridMargin = bigFolderStyleConfig.mGridMargin;
    let mFolderGridGap = bigFolderStyleConfig.mFolderGridGap;
    let mExtraRowsGap: number | undefined = AppStorage.get('ExtraRowsGap');

    gridParam.gridIconSize = vp2px(mFolderAppSize);
    gridParam.gridIconRadius = vp2px(bigFolderStyleConfig.mFolderSuperposeIconRadius);

    gridParam.gridHeight = vp2px(mViewData.folderHeight);
    gridParam.offsetY = vp2px(mViewData.offsetY);
    gridParam.gridRow = mViewData.countInColumn;
    gridParam.gridRowGap = vp2px((mExtraRowsGap ?? 0) + mFolderGridGap * gridGapScale);
    gridParam.gridTopPadding = this.getGridPadding(mViewData, mFolderAppSize, paddingScale, mGridMargin);
    gridParam.gridItemHeight = (gridParam.gridHeight - gridParam.gridTopPadding * 2 +
    gridParam.gridRowGap) / gridParam.gridRow - gridParam.gridRowGap;

    gridParam.gridWidth = vp2px(mViewData.folderWidth);
    gridParam.offsetX = vp2px(mViewData.offsetX);
    gridParam.gridColumn = mViewData.countInRow;
    gridParam.gridColumnGap = this.getGridColumnGap(mViewData, mGridMargin,
      mFolderAppSize, gridGapScale, mFolderGridGap);
    gridParam.gridLeftPadding = gridParam.gridTopPadding;
    gridParam.gridItemWidth = (gridParam.gridWidth - gridParam.gridLeftPadding * 2 +
    gridParam.gridColumnGap) / gridParam.gridColumn - gridParam.gridColumnGap;

    const key: string = this.mapTest.get(gridParam.gridColumn) + '*' + this.mapTest.get(gridParam.gridRow);
    this.folderGridParamMap.set(key, gridParam);
  }

  /**
   * 初始化收缩态文件夹网格的相关参数
   *
   * @param mViewData 文件夹相关参数
   * @param bigFolderStyleConfig 大文件夹相关参数
   * @param paddingScale 内边距转换率
   * @param gridGapScale 网格间距转换率
   */
  public initGridParamShrinkFolderNew(style: ContractedFolderLayoutStyle, bigFolderStyleConfig: BigFolderStyleConfig,
    paddingScale: number, gridGapScale: number): void {
    let gridParam: GridParam = new GridParam();
    let mFolderAppSize = bigFolderStyleConfig.mFolderAppSize;
    let mGridMargin = bigFolderStyleConfig.mGridMargin;
    let mFolderGridGap = bigFolderStyleConfig.mFolderGridGap;
    let mExtraRowsGap: number | undefined = AppStorage.get('ExtraRowsGap');

    gridParam.gridIconSize = vp2px(mFolderAppSize);
    gridParam.gridIconRadius = vp2px(bigFolderStyleConfig.mFolderSuperposeIconRadius);

    gridParam.gridHeight = vp2px(style.backgroundHeight);
    gridParam.gridRow = style.countInColumn;
    gridParam.gridRowGap = vp2px((mExtraRowsGap ?? 0) + mFolderGridGap * gridGapScale);
    gridParam.gridTopPadding = this.getGridPaddingNew(style, mFolderAppSize, paddingScale, mGridMargin);
    gridParam.gridItemHeight = (gridParam.gridHeight - gridParam.gridTopPadding * 2 +
    gridParam.gridRowGap) / gridParam.gridRow - gridParam.gridRowGap;

    gridParam.gridWidth = vp2px(style.backgroundWidth);
    gridParam.gridColumn = style.countInRow;
    gridParam.gridColumnGap = this.getGridColumnGapNew(style, mGridMargin,
      mFolderAppSize, gridGapScale, mFolderGridGap);
    gridParam.gridLeftPadding = gridParam.gridTopPadding;
    gridParam.gridItemWidth = (gridParam.gridWidth - gridParam.gridLeftPadding * 2 +
    gridParam.gridColumnGap) / gridParam.gridColumn - gridParam.gridColumnGap;

    const key: string = this.mapTest.get(gridParam.gridColumn) + '*' + this.mapTest.get(gridParam.gridRow);
    this.folderGridParamMap.set(key, gridParam);
  }

  /**
   * 初始化展开态文件夹网格的相关参数
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   * @param mFolderStyleConfig 展开态文件夹相关参数
   */
  public initGridParamOpenFolder(screenWidth: number, screenHeight: number, mFolderStyleConfig: BigFolderStyleConfig) {
    this.openFolderGridParam.gridIconSize = vp2px(mFolderStyleConfig.mOpenFolderIconSize);

    this.openFolderGridParam.gridHeight = vp2px(mFolderStyleConfig.mOpenFolderGridHeight +
    FolderStyleConstants.FOLDER_BORDER_PADDING_BOTTOM);
    this.openFolderGridParam.gridRow = FolderModel.getInstance().getFolderOpenLayout()?.row;
    this.folderRow = this.openFolderGridParam.gridRow;
    this.openFolderGridParam.gridRowGap = Math.max(vp2px(mFolderStyleConfig.mOpenFolderGridRowGap), 0);
    const gridTopPadding = vp2px(FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_WIDTH);
    this.openFolderGridParam.gridTopPadding = Math.floor(gridTopPadding);
    const gridBottomPadding = vp2px(FolderStyleConstants.FOLDER_BORDER_PADDING_BOTTOM +
    FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_WIDTH);
    this.openFolderGridParam.gridItemHeight = (this.openFolderGridParam.gridHeight - gridTopPadding -
      gridBottomPadding + this.openFolderGridParam.gridRowGap) / this.openFolderGridParam.gridRow -
    this.openFolderGridParam.gridRowGap;
    this.openFolderGridParam.gridItemTopPadding = this.round(vp2px(FeatureConstants.BORDER_PADDING_TOP) +
      (this.openFolderGridParam.gridItemHeight - this.openFolderGridParam.gridIconSize -
      vp2px(FeatureConstants.BORDER_PADDING_TOP) - vp2px(FeatureConstants.BORDER_PADDING_BOTTOM)) / 2);

    this.openFolderGridParam.gridWidth = vp2px(mFolderStyleConfig.mOpenFolderGridWidth +
      mFolderStyleConfig.folderHorizontalPending * NumberConstants.CONSTANT_NUMBER_TWO);
    this.openFolderGridParam.gridColumn = FolderModel.getInstance().getFolderOpenLayout()?.column;
    this.folderColumn = this.openFolderGridParam.gridColumn;
    this.openFolderGridParam.gridColumnGap = Math.max(vp2px(mFolderStyleConfig.mOpenFolderGridGap), 0);
    const gridLeftPadding = vp2px(mFolderStyleConfig.folderHorizontalPending +
    FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_WIDTH);
    this.openFolderGridParam.gridLeftPadding = Math.floor(gridLeftPadding);
    const gridRightPadding = gridLeftPadding;
    this.openFolderGridParam.gridItemWidth = (this.openFolderGridParam.gridWidth - gridLeftPadding -
      gridRightPadding + this.openFolderGridParam.gridColumnGap) / this.openFolderGridParam.gridColumn -
    this.openFolderGridParam.gridColumnGap;
    this.openFolderGridParam.gridItemLeftPadding = this.round((this.openFolderGridParam.gridItemWidth -
    this.openFolderGridParam.gridIconSize) / 2);

    this.gridOpenFolderLeftDistance = this.round((vp2px(screenWidth) -
    this.openFolderGridParam.gridWidth) / 2);
    let stackTopPx = vp2px(FolderStyleConstants.FOLDER_BORDER_PADDING_BOTTOM);
    this.gridOpenFolderTopDistance = this.round((vp2px(screenHeight) - stackTopPx -
    this.openFolderGridParam.gridHeight) / 2 + stackTopPx);
    this.folderPageAppNum = this.folderColumn * this.folderRow;
    LaunchLayoutCacheManager.getInstance().setOpenFolderParam(this.folderPageAppNum, this.folderColumn, this.folderRow);
  }

  private getGridPadding(mViewData: FolderViewData, mFolderAppSize: number,
                         paddingScale: number, mGridMargin: number): number {
    if (mViewData.countInRow === 1) {
      return Math.floor(vp2px((mViewData.gridWidth - mFolderAppSize) * paddingScale / CommonConstants.NUMBER_TWO));
    } else if (mViewData.countInColumn === 1) {
      return Math.floor(vp2px((mViewData.gridHeight - mFolderAppSize) * paddingScale / CommonConstants.NUMBER_TWO));
    } else {
      return Math.floor(vp2px(mGridMargin * paddingScale));
    }
  }

  private getGridPaddingNew(style: ContractedFolderLayoutStyle, mFolderAppSize: number,
    paddingScale: number, mGridMargin: number): number {
    if (style.countInRow === 1) {
      return Math.floor(vp2px((style.backgroundWidth - mFolderAppSize) * paddingScale / CommonConstants.NUMBER_TWO));
    } else if (style.countInColumn === 1) {
      return Math.floor(vp2px((style.backgroundHeight - mFolderAppSize) * paddingScale / CommonConstants.NUMBER_TWO));
    } else {
      return Math.floor(vp2px(mGridMargin * paddingScale));
    }
  }

  private getGridColumnGap(mViewData: FolderViewData, mGridMargin: number, mFolderAppSize: number,
                           gridGapScale: number, mFolderGridGap: number): number {
    if (mViewData.countInRow === ItemsCount.SIZE_4.valueOf()) {
      return vp2px(((mViewData.gridWidth - mGridMargin * CommonConstants.NUMBER_TWO -
        mViewData.countInRow * mFolderAppSize) / (mViewData.countInRow - 1)) * gridGapScale);
    } else {
      return vp2px(mFolderGridGap * gridGapScale);
    }
  }

  private getGridColumnGapNew(style: ContractedFolderLayoutStyle, mGridMargin: number, mFolderAppSize: number,
    gridGapScale: number, mFolderGridGap: number): number {
    if (style.countInRow === ItemsCount.SIZE_4.valueOf()) {
      return vp2px(((style.backgroundWidth - mGridMargin * CommonConstants.NUMBER_TWO -
        style.countInRow * mFolderAppSize) / (style.countInRow - 1)) * gridGapScale);
    } else {
      return vp2px(mFolderGridGap * gridGapScale);
    }
  }

  /**
   * 获取桌面应用的位置信息
   * @param itemInfos 应用、卡片等的布局信息
   * @returns 待查询的应用或文件夹的位置信息
   */
  public getRectDesktop(itemInfo: GridLayoutItemInfo): RectInfo {
    const position: number[] = GridLayoutUtil.getRealGridItemPosition(itemInfo);
    log.showWarn(`getDesktopRect position:${position}`);
    const rectInfo: RectInfo = new RectInfo();
    rectInfo.left = px2vp(vp2px(position[0]) + this.desktopGridParam.gridItemLeftPadding);
    rectInfo.width = px2vp(Math.ceil(this.desktopGridParam.gridIconSize));
    rectInfo.right = rectInfo.left + rectInfo.width;
    rectInfo.top = px2vp(vp2px(position[1]) + this.desktopGridParam.gridItemTopPadding);
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      rectInfo.top = rectInfo.top - CommonConstants.OUTER_SCREEN_OFFSET;
    }
    rectInfo.height = rectInfo.width;
    rectInfo.bottom = rectInfo.top + rectInfo.height;
    rectInfo.radius = this.getIconRadius(rectInfo.width);
    log.showWarn(`getDesktopRect left:${rectInfo.left}, top:${rectInfo.top}`);
    return rectInfo;
  }

  /**
   * 通过布局信息生成唯一id
   * @param item 布局信息
   * @returns 返回id
   */
  private generatedItemId(item: GridLayoutItemInfo): string {
    const itemKeyName: string = item.keyName ?? item.bundleName;
    return itemKeyName;
  }

  /**
   * 获取展开态文件夹内应用的位置信息
   * @param itemInfos 应用、卡片等的布局信息
   * @returns 待查询的应用或文件夹的位置信息
   */
  public getRectOpenFolder(itemInfos: GridLayoutItemInfo[]): RectInfo {
    let rectInfo: RectInfo = new RectInfo();
    if (CheckEmptyUtils.isEmpty(itemInfos[0])) {
      return rectInfo;
    }
    const openFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    const pageIndex: number = itemInfos[0]?.page ?? 0;
    let needDragMoveLayoutInfo: GridLayoutItemInfo[] = [];
    if (openFolderData?.layoutInfo && pageIndex < openFolderData?.layoutInfo.length) {
      needDragMoveLayoutInfo = openFolderData?.layoutInfo[pageIndex];
    }
    const itemId: string = this.generatedItemId(itemInfos[0]);
    needDragMoveLayoutInfo.forEach((gridItem, index) => {
      const gridItemId: string = this.generatedItemId(gridItem);
      if (gridItemId === itemId) {
        const centerPositionList = OpenFolderDragHandler.getInstance().getCenterPositionList();
        rectInfo.width = px2vp(Math.ceil(this.openFolderGridParam.gridIconSize)) ?? 0;
        rectInfo.height = rectInfo.width;
        rectInfo.left = centerPositionList[index][0] - (rectInfo.width / 2);
        rectInfo.right = centerPositionList[index][0] + (rectInfo.width / 2);
        rectInfo.top = centerPositionList[index][1] - (rectInfo.height / 2);
        rectInfo.bottom = centerPositionList[index][1] + (rectInfo.height / 2);
        rectInfo.radius = this.getIconRadius(rectInfo.width);
      }
    });
    log.showInfo(`getOpenFolderRect left:${rectInfo.left}, top:${rectInfo.top}`);
    return rectInfo;
  }

  /**
   * 获取收缩态文件夹内应用的位置信息
   * @param itemInfos 应用、卡片等的布局信息
   * @returns 待查询的应用或文件夹的位置信息
   */
  public getRectShrinkFolder(itemInfos: GridLayoutItemInfo[]): RectInfo {
    if (CheckEmptyUtils.isEmpty(itemInfos[0]) || CheckEmptyUtils.isEmpty(itemInfos[1])) {
      return new RectInfo();
    }
    const key: string = itemInfos[1].area?.[0] + '*' + itemInfos[1].area?.[1];
    let gridParam: GridParam | undefined = this.folderGridParamMap.get(key);
    if (!gridParam) {
      return new RectInfo();
    }
    // 所处桌面网格左侧坐标
    const folderUseGridNum: number = itemInfos[1].area?.[0] ?? 1; // 文件夹横向占用的桌面网格数量
    const folderRowIndex: number = itemInfos[1].column ?? 0; // 文件夹内纵向网格数量
    const folderColumnIndex: number = itemInfos[1].row ?? 0; // 文件夹内横向网格数量
    const difference: number = this.gridDesktopTopDistance - vp2px(GridLayoutUtil.getGridItemPosition(0, 0, 0)[1]);
    log.showWarn(`difference left:${difference}`);
    const position: number[] = GridLayoutUtil.getRealGridItemPosition(itemInfos[1]);

    // 文件夹网格左侧坐标
    let left: number = vp2px(position[0]) + this.round((folderUseGridNum *
      this.desktopGridParam.itemWidthAddColumnGap() - gridParam.gridWidth) / 2);
    // 文件夹左上角单元格左侧坐标
    let gridLeft: number = left + gridParam.gridLeftPadding;
    // 文件夹网格上侧坐标
    let top: number = vp2px(position[1]) + difference + this.desktopGridParam.gridItemTopPadding;
    // 文件夹左上角单元格上侧坐标
    let gridTop: number = top + gridParam.gridTopPadding;
    log.showWarn('getRealGridItemPosition folderRowIndex: %{public}d, folderColumnIndex: %{public}d, page: %{public}d, ' +
      'x: %{public}d, y: %{public}d', folderRowIndex, folderColumnIndex, itemInfos[1].page, gridLeft, gridTop)
    // 获取图标在文件夹的排序
    const index: number = (itemInfos[0].page ?? 0) * this.folderPageAppNum +
      (itemInfos[0].row ?? 0) * this.folderColumn + (itemInfos[0].column ?? 0);
    // 用于判断是否是右下角图标并选择坐标计算方式
    let overlappingIndex: number = index - gridParam.gridColumn * gridParam.gridRow + 1;
    if (overlappingIndex < 0) {
      // 落位不在右下角的计算
      return this.shrinkFolderRect(index, gridParam, gridLeft, gridTop, itemInfos[1].folderId);
    } else {
      // 收缩态文件夹看不到的图标与收缩态最后一个图标落位到相同位置
      overlappingIndex = overlappingIndex >= 2 ? 0 : 2 - overlappingIndex;
      // 落位在右下角的计算
      return this.shrinkFolderLowerRightRect(overlappingIndex, gridParam, gridLeft, gridTop);
    }
  }

  private shrinkFolderLowerRightRect(overlappingIndex: number, gridParam: GridParam,
                                     gridLeft: number, gridTop: number): RectInfo {
    let rectInfo: RectInfo = new RectInfo();
    // 计算图标在收缩态文件夹的行列
    let columnIndex: number = RTLUtil.getColumnByRTL(gridParam.gridColumn - 1, gridParam.gridColumn, 1);
    let rowIndex: number = gridParam.gridRow - 1;

    // 待计算图标左侧坐标
    rectInfo.left = px2vp(gridLeft + this.round(columnIndex * gridParam.itemWidthAddColumnGap()) +
      this.round(gridParam.gridIconSize * 0.1 * overlappingIndex));
    rectInfo.width = px2vp(Math.ceil(gridParam.gridIconSize * 0.8));
    if (RTLUtil.isRTL()) {
      // 镜像模式下需要根据堆叠图标所在的宫格中心对left做翻转
      rectInfo.left = px2vp(2 * gridLeft + gridParam.gridIconSize) - rectInfo.width - rectInfo.left;
    }
    rectInfo.right = rectInfo.left + rectInfo.width;

    // 待计算图标上侧坐标
    rectInfo.top = px2vp(gridTop + this.round(rowIndex * gridParam.itemHeightAddRowGap()) +
      this.round(gridParam.gridIconSize * 0.1 * overlappingIndex));
    rectInfo.height = px2vp(Math.ceil(gridParam.gridIconSize * 0.8));
    rectInfo.bottom = rectInfo.top + rectInfo.height;
    rectInfo.radius = this.getIconRadius(rectInfo.width);
    log.showWarn(`shrinkFolderLowerRightRect left:${rectInfo.left}, top:${rectInfo.top}`);
    return rectInfo;
  }

  private shrinkFolderRect(index: number, gridParam: GridParam,
                           gridLeft: number, gridTop: number, folderId?: string): RectInfo {
    let rectInfo: RectInfo = new RectInfo();
    // 计算图标在收缩态文件夹的行列
    let columnIndex: number = RTLUtil.getColumnByRTL(index % gridParam.gridColumn, gridParam.gridColumn, 1);
    let rowIndex: number = Math.floor(index / gridParam.gridColumn);
    let iconStyle = ContractedFolderLayoutViewModel.getInstance().getLayoutStyle(folderId ?? '')
    // 待计算图标左侧坐标
    rectInfo.left = px2vp(gridLeft + this.round(columnIndex * gridParam.itemWidthAddColumnGap()));
    rectInfo.width = iconStyle.mFolderAppSize || px2vp(Math.floor(gridParam.gridItemWidth));
    rectInfo.right = rectInfo.left + rectInfo.width;
    // 待计算图标上侧坐标
    rectInfo.top = px2vp(gridTop + this.round(rowIndex * gridParam.itemHeightAddRowGap()));
    rectInfo.height = rectInfo.width;
    rectInfo.bottom = rectInfo.top + rectInfo.height;
    rectInfo.radius = this.getIconRadius(rectInfo.width);
    log.showWarn(`shrinkFolderRect left:${rectInfo.left}, top:${rectInfo.top}, iconWidth: ${rectInfo.width}, folderId:${folderId}`);
    return rectInfo;
  }
}
