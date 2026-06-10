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

import display from '@ohos.display';
import {
  CheckEmptyUtils,
  CommonUtils,
  UIContextHelper,
  LogDomain,
  LogHelper,
  SingleBase,
  SingleContext,
  singleManager,
} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  DeviceHelper,
  GlobalContext,
  localEventManager,
  ScreenState,
  ScreenOrientation,
  ScreenStateModel,
  ScreenStateMonitor
} from '@ohos/frameworkwrapper';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CommonConstants, DesktopLayoutState, DeviceState } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import { layoutConfigManager } from '../layoutconfig/LayoutConfigManager';
import { LauncherLayoutStyleConfig } from '../layoutconfig/LauncherLayoutStyleConfig';
import {
  CalculateAppCenterRst,
  CalculateDesktopRst,
  CalculateDockRst,
  CalculateFolderAddListRst,
  CalculateFolderRst,
  CalculateFormRst,
  CalculateOpenFolderRst
} from './LayoutRulesController';
import { LayoutRulesController } from './LayoutRulesController';
import { StyleConstants } from '../constants/StyleConstants';
import type { DockItemInfo } from '../bean/DockItemInfo';
import { FolderLayoutStruct } from '../folder/FolderLayoutInfo';
import {
  PresetStyleConstants,
  ResidentLayoutCacheMgr,
  SwiperLoadManager,
  PageInfoManager,
  desktopItemDraggableManager,
  AppListInfo
} from '../TsIndex';
import { settings } from '@kit.BasicServicesKit';
import type ctx from '@ohos.app.ability.common';
import { StatusBarUtils } from '../utils/StatusBarUtils';
import { SCBSceneSessionManager } from '@ohos/windowscene';

const TAG = 'LayoutViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const L_DPI_DENSITY = 200;
const EXPANDING_FOLD_SYSTEM_UI_TOP_HEIGHT = 28;
const EXPANDING_FOLD_ITEM_SIZE = 52;
const EXPANDING_FOLD_DESKTOP_GAP = 10;
const EXPANDING_FOLD_GRID_REAL_HEIGHT = 270;
const EXPANDING_FOLD_DOCK_HEIGHT = 0;
const EXPANDING_FOLD_DOCK_BACKGROUND_HEIGHT = 0;
const EXPANDING_FOLD_APP_ITEM_PADDING = 10;
const EXPANDING_FOLD_DESKTOP_NAME_SIZE = 0;
const MAC_SYSUI_HEIGHT = 40;
const WIN_SYSUI_HEIGHT = 0;

/**
 * layout viewmodel
 */
export class LayoutViewModel extends SingleBase {
  public static singleName: string = 'LayoutViewModel';

  private readonly mLauncherLayoutStyleConfig: LauncherLayoutStyleConfig;

  private mBaseConfig: BaseConfig;

  private mLayoutRulesController?: LayoutRulesController;

  private mDesktopModel: number = DesktopLayoutState.HOME_LAUNCHER_MODE;

  private mRefreshLayoutCallbacks: Map<number, Set<Function>> = new Map();

  public constructor(ctx?: SingleContext) {
    log.showInfo('constructor');
    super(ctx);
    this.mLauncherLayoutStyleConfig = layoutConfigManager.getStyleConfig(
      LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
      LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG) as LauncherLayoutStyleConfig;
    this.initDesktopLayoutModel();
    if (CheckEmptyUtils.isEmpty(this.mLauncherLayoutStyleConfig)) {
      log.showInfo(`this.mLauncherLayoutStyleConfig is invalid`);
      return;
    }
    this.mBaseConfig = new BaseConfig(this.mLauncherLayoutStyleConfig,
      this.singleContext?.extendScreenId ?? SCBSceneSessionManager.getInstance().mainScreenId, this.mDesktopModel);
    this.initScreen();
    let rulesController = LayoutRulesController.getInstance(this.mBaseConfig, this.singleContext);
    this.setLayoutRulesController(rulesController);
  }

  /**
   * init screen info
   *
   * @param navigationBarStatus
   */
  initScreen(navigationBarStatus?: string): void {
    this.mBaseConfig.setNavigationBarStatus(navigationBarStatus);
  }

  initDesktopLayoutModel(): void {
    let launcherModel: string = settings.getValueSync(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY, '0');
    this.mDesktopModel = (launcherModel === String(DesktopLayoutState.SIMPLE_LAUNCHER_MODEL)) ?
    DesktopLayoutState.SIMPLE_LAUNCHER_MODEL : DesktopLayoutState.HOME_LAUNCHER_MODE;
    launcherStatusUtil.setSimpleModeStatus(this.isSimpleLauncherMode());
  }

  registerRefreshLayoutCallback(screenId: number, callback: Function): void {
    if (!callback) {
      log.showError(`registerRefreshLayoutCallback screenId: ${screenId} refresh callback invalid`);
      return;
    }
    let callbacks = this.mRefreshLayoutCallbacks.get(screenId);
    if (CommonUtils.isInvalid(callbacks)) {
      callbacks = new Set();
      this.mRefreshLayoutCallbacks.set(screenId, callbacks);
    }
    callbacks?.add(callback);
  }

  unregisterRefreshLayoutCallback(screenId: number, callback: Function): void {
    if (!callback) {
      log.showError(`unregisterRefreshLayoutCallback screenId: ${screenId} refresh callback invalid`);
      return;
    }
    let callbacks = this.mRefreshLayoutCallbacks.get(screenId);
    if (CommonUtils.isInvalid(callbacks)) {
      log.showDebug(`unregisterRefreshLayoutCallback screenId: ${screenId} callbacks empty`);
      return;
    }
    callbacks?.delete(callback);
    if (callbacks?.size === 0) {
      this.mRefreshLayoutCallbacks.delete(screenId);
    }
  }
  /**
   * set device type
   *
   * @param deviceType: Device type
   */
  setDevice(deviceType: string): void {
    let isPad = deviceType === CommonConstants.PAD_DEVICE_TYPE;
    this.mBaseConfig.setIsPad(isPad);
  }

  setLayoutRulesController(controller: LayoutRulesController): void {
    log.showInfo(`setLayoutRulesController: ${controller.toString()}`);
    this.mLayoutRulesController = controller;
  }

  /**
   * get base config
   * @returns BaseConfig
   */
  getBaseConfig(): BaseConfig {
    return this.mBaseConfig;
  }

  /**
   * get screen height
   */
  getScreenHeight(): number {
    return this.mBaseConfig.getScreenHeight();
  }

  /**
   * get screen width
   */
  getScreenWidth(): number {
    return this.mBaseConfig.getScreenWidth();
  }

  /**
   * get workSpaceHeight
   */
  getWorkSpaceHeight(): number {
    return this.mBaseConfig.getWorkSpaceHeight();
  }

  /**
   * get dockHeight
   */
  getDockHeight(): number {
    return this.mBaseConfig.getDockHeight();
  }

  /**
   * getSysUIBottomHeight
   */
  getSysUIBottomHeight(): number {
    return this.mBaseConfig.getSysUIBottomHeight();
  }

  /**
   * get dockBackgroundHeight
   */
  getDockBackgroundHeight(): number {
    return this.mBaseConfig.getDockBackgroundHeight();
  }

  /**
   * get dock margin bottom hide bar
   */
  getDockMarginBottomHideBar(): number {
    if (this.mLauncherLayoutStyleConfig) {
      return this.mLauncherLayoutStyleConfig.mDockMarginBottomHideBar;
    }
    return 0;
  }

  /**
   * get dock margin bottom
   */
  getDockMarginBottom(): number {
    if (this.mLauncherLayoutStyleConfig) {
      return this.mLauncherLayoutStyleConfig.mDockMarginBottom;
    }
    return 0;
  }

  /**
   * get statusBar height
   */
  getSysUITopHeight(): number {
    return this.mBaseConfig.getSysUITopHeight();
  }

  /**
   * get indicatorHeight
   */
  getIndicator(): number {
    return this.mBaseConfig.getIndicatorHeight();
  }

  /**
   * get UninstallDialogWidth
   */
  getUninstallDialogWidth(): string {
    return this.mBaseConfig.getUninstallDialogWidth();
  }

  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    return this.mLayoutRulesController?.calculateDock() ?? new CalculateDockRst();
  }

  /**
   * calculate desktop
   */
  calculateDesktop(): CalculateDesktopRst {
    return this.mLayoutRulesController?.calculateDesktop() ?? new CalculateDesktopRst();
  }

  /**
   * calculate desktop folder
   *
   * @param layoutInfo folder layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateFolder(layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateFolderRst {
    return this.mLayoutRulesController?.calculateFolder(layoutInfo, isInPreviewMode) ?? new CalculateFolderRst();
  }

  /**
   * calculate open folder
   *
   * @param openFolderConfig layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateOpenFolder(openFolderConfig: GridLayoutItemInfo | FolderLayoutStruct, isInPreviewMode?: boolean): CalculateOpenFolderRst {
    return this.mLayoutRulesController?.calculateOpenFolder(openFolderConfig,
      isInPreviewMode) ?? new CalculateOpenFolderRst();
  }

  /**
   * calculate add app
   *
   * @param addFolderConfig
   */
  calculateFolderAddList(addFolderConfig: FolderLayoutStruct): CalculateFolderAddListRst {
    return this.mLayoutRulesController?.calculateFolderAddList(addFolderConfig) ?? new CalculateFolderAddListRst();
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    return this.mLayoutRulesController?.calculateForm() ?? new CalculateFormRst();
  }

  /**
   * calculate app center
   * @param screenId 屏幕ID
   * @param isRefresh 是否是分辨率发生变化
   * @param width 屏幕宽度
   * @param height 屏幕高度
   */
  calculateAppCenter(screenId: number = 0, isRefresh: boolean = false, width?: number, height?: number): CalculateAppCenterRst {
    return this.mLayoutRulesController?.calculateAppCenter(screenId, isRefresh, width,
      height) ?? new CalculateAppCenterRst();
  }

  calculateSpaceOfRow(): number {
    return this.mLayoutRulesController?.getSpaceOfRow() ?? 0;
  }

  calculateSpaceOfColumn(): number {
    return this.mLayoutRulesController?.getSpaceOfColumn() ?? 0;
  }

  refreshConfig(screenWidth: number, screenHeight: number, foldStatus: number, isPortrait: boolean, desktopModel: number, screenId?: number): void {
    this.mDesktopModel = desktopModel;
    launcherStatusUtil.setSimpleModeStatus(this.isSimpleLauncherMode());
    this.mBaseConfig.reInit(screenWidth, screenHeight, foldStatus, isPortrait, desktopModel, screenId);
    this.mLayoutRulesController?.calculateProductConfig();
    if (screenId !== undefined) {
      // 拓展屏属性变化，重新计算布局
      let functionSet: Set<Function> | undefined = this.mRefreshLayoutCallbacks.get(screenId);
      if (functionSet) {
        functionSet.forEach(callback => {
          callback();
        });
      } else {
        log.showWarn('refreshConfig refresh nothing! screenId: %{public}d', screenId);
      }
    }
  }

  refreshConfigOnIconChange(): void {
    this.mBaseConfig.initParams();
  }

  /**
   * Update desktop layout data.
   * *
   * @params appList
   */
  updateDesktopLayoutData(appList: IDesktopDataInfo | AppListInfo, reason: string, isOuter?: boolean): void {
    log.showWarn(`updateDesktopLayoutData, reason: ${reason}, app length: ${appList?.appGridInfo?.length}`);
    AppStorage.setOrCreate(desktopUtil.getAppListInfo(isOuter), appList);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_LAYOUT_CHANGE_EVENT, null);
    SwiperLoadManager.getInstance(isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter)
      .hardCodeRefreshPageDesktop();
  }

  /**
   * 只更新resident区缓存，不入库.
   * @param from 更新来源
   * @params residentList
   */
  updateResidentDockLayout(from: string, residentList: DockItemInfo[]): void {
    this.updateDockAppSum(residentList);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems(from, residentList, false);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_LAYOUT_CHANGE_EVENT, null);
  }

  public updateDockAppSum(residentList: DockItemInfo[]): void {
    let dockAppSum = 0;
    if (!CheckEmptyUtils.isEmpty(residentList)) {
      for (let i = 0; i < residentList.length; i++) {
        const item = residentList[i];
        if (item.itemType === CommonConstants.TYPE_FOLDER) {
          const layoutInfo = item.layoutInfo;
          if (!layoutInfo) {
            continue;
          }
          for (let j = 0; j < layoutInfo.length; j++) {
            const folderAppList = layoutInfo[j];
            dockAppSum += folderAppList?.length;
          }
        } else {
          dockAppSum++;
        }
      }
    }
    log.showInfo(`updateDockAppSum: ${dockAppSum}`);
    AppStorage.setOrCreate('dockAppSum', dockAppSum);
  }

  getDesktopModel(): number {
    if (DeviceHelper.is2In1DevicePcType()) {
      return DesktopLayoutState.PC_MODE_MODEL;
    }
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return DesktopLayoutState.HOME_LAUNCHER_MODE;
    }
    return this.mDesktopModel;
  }

  /**
   * 是否简易模式
   */
  isSimpleLauncherMode(): boolean {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return false;
    }
    return this.mDesktopModel === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL;
  }

  /**
   * get the LayoutViewModel instance
   *
   * @return LayoutViewModel
   */
  static getInstance(ctx?: SingleContext): LayoutViewModel {
    return singleManager.get<LayoutViewModel>(LayoutViewModel, ctx);
  }
}

export class BaseConfig {
  private screenId: number = 0;

  private static instance: BaseConfig;

  private mLauncherLayoutStyleConfig: LauncherLayoutStyleConfig;

  private mIsPad = true;

  private mDefaultDisplay?: display.Display;

  private mScreenWidth: number | undefined;

  /**
   * 折叠屏屏幕总宽度
   */
  private foldScreenWidth: number = 0;

  private mScreenHeight: number | undefined;

  private mNavigationBarStatus: boolean = false;

  private mSysUITopHeight: number | undefined;

  private mSysUIBottomHeight: number | undefined = 0;

  private mIndicatorHeight: number | undefined;

  private mIndicatorWidth: number | undefined;

  private mDockHeight: number | undefined;

  private mDockBackgroundHeight: number | undefined;

  private mWorkSpaceHeight: number | undefined;

  private mUninstallDialogWidth: string | undefined;

  private mItemSize: number | undefined;

  private mNameHeight: number | undefined;

  private mItemPadding: number | undefined;

  private mIconNameMarginTop: number | undefined;

  private mDesktopNameLines: number | undefined;

  private mDesktopIconNameMargin: number | undefined;

  private mDesktopNameSize: number | undefined;

  private mDesktopItemSize: number | undefined;

  private mDesktopIconSize: number | undefined;

  private mDesktopIconMarginTop: number | undefined;

  private mDesktopGap: number | undefined;

  private mGridRealHeight: number | undefined;

  private mGridRealWidth: number | undefined;

  private mFoldStatus: number | undefined;

  private mIsPortraitStatus: boolean | undefined = true;

  private mDesktopModel: number | undefined = 0;

  private mDockMarginBottomHideBar: number | undefined;

  public constructor(launcherLayoutStyleConfig: LauncherLayoutStyleConfig, screenId: number, desktopModel?: number) {
    log.showInfo('constructor');
    this.screenId = screenId;
    this.mLauncherLayoutStyleConfig = launcherLayoutStyleConfig;
    if (CheckEmptyUtils.isEmpty(launcherLayoutStyleConfig)) {
      log.showInfo(`launcherLayoutStyleConfig is invalid`);
      return;
    }
    this.mDesktopModel = desktopModel;
    this.init();
  }

  private getDisplay(): display.Display | undefined {
    let screenDisplay: display.Display | undefined;
    try {
      screenDisplay = display.getDisplayByIdSync(this.screenId);
    } catch (error) {
      log.error(`Failed to obtain the display by screenId object :${error.code}: ${error.message}`);
    }
    if (screenDisplay === undefined) {
      try {
        screenDisplay = display.getDefaultDisplaySync();
      } catch (error) {
        log.error(`Failed to obtain the default display by object :${error.code}: ${error.message}`);
      }
    }
    return screenDisplay;
  }

  /**
   * 初始化本类
   */
  public init(): void {
    // 初始化屏幕信息
    this.mDefaultDisplay = this.getDisplay();
    this.mIsPortraitStatus = AppStorage.get<boolean>('isPortrait') as boolean;
    this.resetScreenSize(this.mDefaultDisplay?.width ?? 0, this.mDefaultDisplay?.height ?? 0, this.getFolderStatus());
    log.showInfo(`initScreen screenWidth: ${this.mScreenWidth}, screenHeight: ${this.mScreenHeight}`);
    this.initParams();
  }

  public resetScreenSize(width: number, height: number, foldStatus: number, screenId: number = 0): void {
    this.mScreenWidth = UIContextHelper.px2vp(screenId, width);
    this.mScreenHeight = UIContextHelper.px2vp(screenId, height);
    this.mFoldStatus = foldStatus;
    this.setFoldScreenWidth(this.mScreenWidth);
    log.showInfo(`initScreen screenWidth: ${this.mScreenWidth}, screenHeight: ${this.mScreenHeight}, foldStatus: ${foldStatus}`);
    this.initParams();
    this.getContext()?.eventHub.on('WindowStyleChange',
      this.flushsysUITopHeight);
  }

  private setFoldScreenWidth(screenWidth: number): void {
    log.showWarn(`initScreen this.mFoldStatus: ${this.mFoldStatus}`);
    this.foldScreenWidth = this.mScreenWidth;
    if (this.mFoldStatus !== DeviceState.EXPAND_STATE) {
      return;
    }
    this.mScreenWidth = screenWidth / StyleConstants.DEFAULT_2;
    let maxDisplayCount = PageInfoManager.getInstance().getMaxDisplayCount();
    log.showWarn(`initScreen maxDisplayCount: ${maxDisplayCount}`);
    if (maxDisplayCount === StyleConstants.DEFAULT_3) {
      let screenState: ScreenStateMonitor = ScreenStateMonitor.getInstance();
      let state: ScreenStateModel = screenState.getCurrentScreenStateModel();
      log.showWarn(`initScreen screenState: ${screenState.getScreenProp(state)} `);
      if (state.screenState === ScreenState.G && state.orientation === ScreenOrientation.LANDSCAPE) {
        this.mScreenWidth = screenWidth / maxDisplayCount;
      }
    }
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  private flushsysUITopHeight = (statusBarType: number) : void => {
    if (StatusBarUtils.isMacStyle(statusBarType)) {
      this.mSysUITopHeight = MAC_SYSUI_HEIGHT;
    } else {
      this.mSysUITopHeight = WIN_SYSUI_HEIGHT;
    }
    this.mLauncherLayoutStyleConfig.mSysTopHeight = this.mSysUITopHeight;
  };


  /**
   * 该方法针对超大屏 G态返回有问题， M态返回正常
   * @returns
   */
  private getFolderStatus(): number {
    if (desktopUtil.needIgnoreFoldDeviceForLauncher()) {
      return DeviceState.DEFAULT_STATE;
    }
    let displayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN;
    try {
      displayMode = display.getFoldDisplayMode();
    } catch (error) {
      log.showError(TAG, 'constructor failed', error);
    }
    return displayMode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL ||
      displayMode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB ?
    DeviceState.EXPAND_STATE : DeviceState.FOLDED_STATE;
  }

  public initParams(): void {
    // 初始化状态栏、导航条布局信息
    this.mSysUITopHeight = this.mLauncherLayoutStyleConfig.mSysTopHeight;
    this.mIndicatorHeight = this.mLauncherLayoutStyleConfig.mIndicatorHeight;
    this.mIndicatorWidth = this.mLauncherLayoutStyleConfig.mIndicatorWidth;
    let mDockIconSize = this.mLauncherLayoutStyleConfig.mDockIconSize;
    this.mDockMarginBottomHideBar = this.mLauncherLayoutStyleConfig.mDockMarginBottomHideBar;
    let dockMarginBottomHideBar: number = this.mLauncherLayoutStyleConfig.mDockMarginBottomHideBar;
    if (DeviceHelper.isPhone() && !this.getNavigationBarStatus()) {
      dockMarginBottomHideBar = this.mLauncherLayoutStyleConfig.mDockMarginBottom;
    }
    // 超大屏，G态，竖屏，调整距离
    let isUltraScreenGPortrait: boolean = DeviceHelper.isUltraScreenGPortrait();
    if (isUltraScreenGPortrait) {
      dockMarginBottomHideBar += this.mLauncherLayoutStyleConfig.mGPortraitMargin;
    }
    if (!DeviceHelper.isPC()) {
      let desktopIconChangeSize: number | undefined = AppStorage.get<number>('settingIconChange');
      if (desktopIconChangeSize !== undefined) {
        mDockIconSize += desktopIconChangeSize;
        if (DeviceHelper.isPhone() && !isUltraScreenGPortrait) {
          let addMargin: number = 0;
          addMargin = (PresetStyleConstants.DEFAULT_DOCK_HEIGHT -
            (mDockIconSize + StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockPadding)) / 2;
          dockMarginBottomHideBar += addMargin;
        } else {
          dockMarginBottomHideBar -= desktopIconChangeSize / 2;
        }
      }
    }

    if (this.mDesktopModel === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      mDockIconSize = Math.floor(this.mLauncherLayoutStyleConfig.mDockIconSize * 1.3);
      this.mDockMarginBottomHideBar = StyleConstants.DEFAULT_48 - this.mLauncherLayoutStyleConfig.mDockPadding;
      // 简易模式高度不随着图标大小变化
      dockMarginBottomHideBar = this.mDockMarginBottomHideBar;
    }
    this.mDockHeight = mDockIconSize + StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockPadding +
      dockMarginBottomHideBar;
    this.mDockBackgroundHeight = mDockIconSize + StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mDockPadding;
    this.mWorkSpaceHeight = (this.mScreenHeight ?? 0) - (this.mSysUIBottomHeight ?? 0) - this.mDockHeight;
    this.mUninstallDialogWidth = this.mLauncherLayoutStyleConfig.mUninstallDialogWidth;
    // 初始化图标布局信息
    this.mItemSize = this.mLauncherLayoutStyleConfig.mAppItemSize;
    this.mNameHeight = this.mLauncherLayoutStyleConfig.mNameHeight;
    this.mItemPadding = this.mLauncherLayoutStyleConfig.mItemPadding;
    this.mIconNameMarginTop = this.mLauncherLayoutStyleConfig.mIconNameMarginTop;
    // 初始化desktop布局信息
    this.mDesktopNameLines = this.mLauncherLayoutStyleConfig.mNameLines;
    this.mDesktopIconNameMargin = this.mLauncherLayoutStyleConfig.mIconNameGap;
    this.mDesktopNameSize = this.mLauncherLayoutStyleConfig.mNameSize;
    this.mDesktopItemSize = this.mItemSize + this.mNameHeight * (this.mLauncherLayoutStyleConfig.mNameLines - 1);
    this.mDesktopIconSize = this.mDesktopItemSize - this.mNameHeight - this.mIconNameMarginTop;
    this.mDesktopIconMarginTop = this.mLauncherLayoutStyleConfig.mIconRatio * this.mDesktopItemSize;
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.initParamsForOuterScreen();
      this.initDesktopGapForOuterScreen();
      this.initGridHeightForOuterScreen();
    } else {
      this.initDesktopGap();
      // 初始化workspace网格信息
      this.initGridHeight();
      this.initGridWidth();
    }
  }

  private initParamsForOuterScreen(): void {
    // 初始化状态栏、导航条布局信息
    this.mSysUITopHeight = EXPANDING_FOLD_SYSTEM_UI_TOP_HEIGHT;
    this.mIndicatorHeight = this.mLauncherLayoutStyleConfig.mIndicatorHeight;
    this.mIndicatorWidth = this.mLauncherLayoutStyleConfig.mIndicatorWidth;
    this.mDockHeight = EXPANDING_FOLD_DOCK_HEIGHT;
    this.mDockBackgroundHeight = EXPANDING_FOLD_DOCK_BACKGROUND_HEIGHT;
    this.mWorkSpaceHeight = (this.mScreenHeight ?? 0) - (this.mSysUIBottomHeight ?? 0) - this.mDockHeight;
    this.mUninstallDialogWidth = this.mLauncherLayoutStyleConfig.mUninstallDialogWidth;

    // 初始化图标布局信息
    this.mItemSize = EXPANDING_FOLD_ITEM_SIZE;
    this.mItemPadding = EXPANDING_FOLD_APP_ITEM_PADDING;

    // 初始化desktop布局信息
    this.mDesktopNameSize = EXPANDING_FOLD_DESKTOP_NAME_SIZE;
    this.mDesktopItemSize = this.mItemSize;
    this.mDesktopIconSize = this.mDesktopItemSize;
    this.mDesktopIconMarginTop = this.mLauncherLayoutStyleConfig.mIconRatio * this.mDesktopItemSize;

  }

  private initDesktopGapForOuterScreen(): void {
    this.mDesktopGap = EXPANDING_FOLD_DESKTOP_GAP;
  }

  private initGridHeightForOuterScreen(): void {
    this.mGridRealHeight = EXPANDING_FOLD_GRID_REAL_HEIGHT;
  }

  private initDesktopGap(): void {
    let realWidth = (this.mScreenWidth ?? 0) - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mMargin;
    let minGutter = this.mLauncherLayoutStyleConfig.mGridGutter;
    let column = ~~((realWidth + minGutter) / ((this.mItemSize ?? 0) + minGutter));
    let userWidth = (realWidth + minGutter - ((this.mItemSize ?? 0) + minGutter) * column);
    this.mDesktopGap = (userWidth / (column - 1)) + minGutter - StyleConstants.DEFAULT_2 * (this.mItemPadding ?? 0);
    log.showInfo('initDesktopGap',
      `scrWidth:${realWidth}, spaceOfColumn: ${minGutter}, column: ${column}, userWidth: ${userWidth},
    mDesktopGap :${this.mDesktopGap}`);
  }

  private initGridHeight(): void {
    let itemSize = (this.mItemSize ?? 0) + (this.mNameHeight ?? 0) * (this.mLauncherLayoutStyleConfig.mNameLines - 1);
    if (this.mIsPad) {
      itemSize = (this.mItemSize ?? 0);
    }
    let realWidth = (this.mScreenWidth ?? 0) - StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mMargin;
    let minGutter = this.mLauncherLayoutStyleConfig.mGridGutter;
    let baseColumn = (realWidth + minGutter) / (itemSize + minGutter);
    let column = ((this.mDefaultDisplay?.densityDPI ?? 0) > L_DPI_DENSITY) ? ~~baseColumn : Math.ceil(baseColumn);
    let userWidth = (realWidth + minGutter - (itemSize + minGutter) * column);
    let gutter = (userWidth / (column - 1)) + minGutter;
    let realHeight = (this.mWorkSpaceHeight ?? 0) - (this.mIndicatorHeight ?? 0) - (this.mSysUITopHeight ?? 0);
    let baseRow = (realHeight + gutter) / (itemSize + gutter);
    let row = ((this.mDefaultDisplay?.densityDPI ?? 0) > L_DPI_DENSITY) ? ~~baseRow : Math.ceil(baseRow);
    this.mGridRealHeight = (itemSize + gutter) * row - gutter + StyleConstants.DEFAULT_2 * (this.mItemPadding ?? 0);
  }

  private initGridWidth(): void {
    let margin = this.mLauncherLayoutStyleConfig.mDockSaveMargin;
    let realWidth = (this.mScreenWidth ?? 0) - StyleConstants.DEFAULT_2 * margin;
    this.mGridRealWidth = realWidth + StyleConstants.DEFAULT_2 * (this.mItemPadding ?? 0);
  }

  getIsPad(): boolean {
    return this.mIsPad;
  }

  setIsPad(isPad: boolean): void {
    this.mIsPad = isPad;
    AppStorage.setOrCreate('isPad', isPad);
  }

  getDefaultDisplay(): display.Display | undefined {
    return this.mDefaultDisplay;
  }

  getScreenHeight(): number {
    return this.mScreenHeight ?? 0;
  }

  getScreenWidth(): number {
    return this.mScreenWidth ?? 0;
  }

  getFoldScreenWidth(): number {
    return this.foldScreenWidth;
  }

  getLauncherLayoutStyleConfig(): LauncherLayoutStyleConfig {
    return this.mLauncherLayoutStyleConfig;
  }

  setNavigationBarStatus(navigationBarStatus?: string): void {
    this.mNavigationBarStatus = navigationBarStatus === '0' ? true : false;
    if (!this.mNavigationBarStatus) {
      this.mSysUIBottomHeight = this.mLauncherLayoutStyleConfig.mSysBottomHeight;
    } else {
      this.mSysUIBottomHeight = 0;
    }
    AppStorage.setOrCreate('sysUIBottomHeight', this.mSysUIBottomHeight);
    this.mWorkSpaceHeight = (this.mScreenHeight ?? 0) - this.mSysUIBottomHeight - (this.mDockHeight ?? 0);
  }

  getNavigationBarStatus(): boolean {
    return this.mNavigationBarStatus;
  }

  getSysUIBottomHeight(): number {
    return this.mSysUIBottomHeight ?? 0;
  }

  getSysUITopHeight(): number {
    return this.mSysUITopHeight ?? 0;
  }

  getIndicatorWidth(): number {
    return this.mIndicatorWidth ?? 0;
  }

  getIndicatorHeight(): number {
    return this.mIndicatorHeight ?? 0;
  }

  getDockHeight(): number {
    return this.mDockHeight ?? 0;
  }

  setDockHeight(dockHeight: number): void {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.mDockHeight = 0;
    } else {
      this.mDockHeight = dockHeight;
    }
  }

  getDockBottomHeight(): number {
    return (this.mDockMarginBottomHideBar ?? 0) + this.mLauncherLayoutStyleConfig.mDockPadding;
  }

  getDockBackgroundHeight(): number {
    return this.mDockBackgroundHeight ?? 0;
  }

  getWorkSpaceHeight(): number {
    return this.mWorkSpaceHeight ?? 0;
  }

  getUninstallDialogWidth(): string {
    return this.mUninstallDialogWidth ?? '';
  }

  getItemSize(): number {
    return this.mItemSize ?? 0;
  }

  getNameHeight(): number {
    return this.mNameHeight ?? 0;
  }

  getItemPadding(): number {
    return this.mItemPadding ?? 0;
  }

  getIconNameMarginTop(): number {
    return this.mIconNameMarginTop ?? 0;
  }

  getDesktopIconMarginTop(): number {
    return this.mDesktopIconMarginTop ?? 0;
  }

  getDesktopNameLines(): number {
    return this.mDesktopNameLines ?? 0;
  }

  getDesktopIconNameMargin(): number {
    return this.mDesktopIconNameMargin ?? 0;
  }

  getDesktopIconSize(): number {
    return this.mDesktopIconSize ?? 0;
  }

  getDesktopItemSize(): number {
    return this.mDesktopItemSize ?? 0;
  }

  getDesktopNameSize(): number {
    return this.mDesktopNameSize ?? 0;
  }

  getDesktopGap(): number {
    return this.mDesktopGap ?? 0;
  }

  setGridRealHeight(height: number): void {
    this.mGridRealHeight = height;
  }

  getGridRealHeight(): number {
    return this.mGridRealHeight ?? 0;
  }

  setGridRealWidth(width: number): void {
    this.mGridRealWidth = width;
  }

  getGridRealWidth(): number {
    return this.mGridRealWidth ?? 0;
  }

  getFoldStatus(): number | undefined {
    return this.mFoldStatus;
  }

  getPortraitStatus(): boolean {
    return this.mIsPortraitStatus ?? false;
  }

  reInit(screenWidth: number, screenHeight: number, foldStatus: number,
    isPortrait: boolean, desktopModel: number, screenId: number = 0): void {
    this.resetScreenSize(screenWidth, screenHeight, foldStatus);
    this.mIsPortraitStatus = isPortrait;
    this.mDesktopModel = desktopModel;
    log.showInfo(`refresh screenWidth: ${this.mScreenWidth}, screenHeight: ${this.mScreenHeight},
     flodStatus: ${this.mFoldStatus}`);
    this.initParams();
  }

  static getInstance(launcherLayoutStyleConfig: LauncherLayoutStyleConfig, desktopModel?: number): BaseConfig {
    if (!BaseConfig.instance) {
      BaseConfig.instance = new BaseConfig(launcherLayoutStyleConfig, 0, desktopModel);
    }
    return BaseConfig.instance;
  }
}

export interface IDesktopDataInfo {
  appGridInfo: GridLayoutItemInfo[][];
  waterfallItemListInfo: GridLayoutItemInfo[];
}