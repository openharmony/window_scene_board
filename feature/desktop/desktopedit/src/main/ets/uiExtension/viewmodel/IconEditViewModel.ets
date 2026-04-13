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

import common from '@ohos.app.ability.common';
import Display from '@ohos.display';
import {
  CheckEmptyUtils,
  FileUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import {
  WallpaperManager,
  AccessibilityManager,
  DeviceHelper,
  WallpaperType,
  sSettingsUtil
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { WallpaperConstants } from '@ohos/commonconstants';
import {
  ColorUtil,
  CommonConstants,
  ComponentPosShadowCache,
  DesktopParam,
  EditModeUtils,
  HiEditModeEventUtils,
  ShowNameState,
  StyleConstants,
  textShadowMgr,
  vibratorMgr
} from '@ohos/launchercommon';
import { AppInfo, EditModeConstants, WantParams } from '../../default/common/constants/EditModeConstants';
import IconEditPageConstants from '../../default/common/constants/IconEditPageConstants';
import { NavigationUtil } from '../../default/utils/NavigationUtil';
import { IconEditPageData } from '../../default/data/IconEditPageData';
import { PreviewPathData } from '../../default/data/PreviewPathData';
import { THEME_ACTIVE_MANAGER } from '../../default/utils/ThemeActiveManager';
import { TSManager } from '@ohos/themeservicekit/Index';
import { IconChangeSizeData } from '../../default/data/IconChangeSizeData';
import GridRowManager from '../../default/utils/GridRowManager';
import { image } from '@kit.ImageKit';
import { AppItemTextShadowInfo } from '@ohos/launchercommon/src/main/ets/manager/TextShadowManager';
import { AttributeUpdater, curves } from '@kit.ArkUI';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG: string = 'IconEditViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const X_LARGE_GRID: GridRowManager = new GridRowManager(12, 20, 40, 6);
const LARGE_GRID: GridRowManager = new GridRowManager(12, 16, 32, 6);
const LARGE_GRID_NOT_LAND: GridRowManager = new GridRowManager(12, 16, 32, 10);
const MEDIUM_GRID: GridRowManager = new GridRowManager(8, 12, 24, 6);
const SMALL_GRID: GridRowManager = new GridRowManager(4, 8, 16, 4);
const ORIENTATION_LANDSCAPE_LIST = [
  Display.Orientation.LANDSCAPE,
  Display.Orientation.LANDSCAPE_INVERTED
];
const ICON_SIZE_DESCRIPTION_RESOURCE_LIST: Resource[] = [
  $r('app.string.icon_size_small'), $r('app.string.icon_size_normal'), $r('app.string.icon_size_large')
];
/**
 * 编辑模式按钮Model
 */
export class IconEditViewModel {
  private isLoading: boolean = false;
  private isPhone: boolean = false;
  private isPad: boolean = false;
  private isLandscape: boolean = false;
  private isFoldExpanded: boolean = false;
  private isTriFoldAllExpanded: boolean = false;
  private oriIconScale: number = 1;
  private iconEditPageData: IconEditPageData = new IconEditPageData();
  private iconChangeSizeData: IconChangeSizeData = new IconChangeSizeData();
  private previewPathData: PreviewPathData = new PreviewPathData();
  private showNameState: ShowNameState = new ShowNameState();
  private gridRowManager: GridRowManager = SMALL_GRID;
  private pixmap: image.PixelMap | undefined;
  public iconEditShowManager: IconEditShowManager = new IconEditShowManager();
  private mDesktopParam: DesktopParam = new DesktopParam();
  private mIconEditProperty: IconEditProperty = new IconEditProperty(
    ICON_SIZE_DESCRIPTION_RESOURCE_LIST[0], 1
  );
  // 刚进入图标编辑页时的图标大小 iconSize + iconChangeSize
  private defaultIconSize: number = 0;
  private iconScaleModifierArr: IconScaleModifier[] = [];

  /**
   * 添加预览图标的modifier
   * @param modifier
   */
  public addIconScaleModifierArr(modifier: IconScaleModifier): void {
    this.iconScaleModifierArr.push(modifier);
  }

  public initDeviceInfo(isPhone: boolean, isPad: boolean, isLandscape: boolean, isFoldExpanded: boolean,
    isTriFoldAllExpanded: boolean = false): void {
    this.isPhone = isPhone;
    this.isPad = isPad;
    this.isLandscape = isLandscape;
    this.isFoldExpanded = isFoldExpanded;
    this.isTriFoldAllExpanded = isTriFoldAllExpanded;
  }

  /**
   * 获取进入图标编辑页时的初始缩放值
   * @returns oriIconScale
   */
  public getOriIconScale(): number {
    return this.oriIconScale;
  }

  public setApplyLoading(isLoading: boolean): void {
    this.isLoading = isLoading;
  }

  public isApplyLoading(): boolean {
    return this.isLoading;
  }

  public getPreviewPathData(): PreviewPathData {
    return this.previewPathData;
  }

  public getShowNameState(): ShowNameState {
    return this.showNameState;
  }

  public getIconChangeSizeData(): IconChangeSizeData {
    return this.iconChangeSizeData;
  }

  public getIconEditPageData(): IconEditPageData {
    return this.iconEditPageData;
  }

  public getDesktopParam(): DesktopParam {
    return this.mDesktopParam;
  }

  public getWallPaper(): image.PixelMap | undefined {
    return this.pixmap;
  }

  public registerDisplayChangeCallback(): void {
    if (!desktopUtil.isFold()) {
      return;
    }
    try {
      Display.on('foldStatusChange', this.onFoldStatusChange);
    } catch (error) {
      log.showError(`register fold display status callback failed: ${error?.code}!`);
    }
  };

  public unregisterDisplayChangeCallback(): void {
    if (!desktopUtil.isFold()) {
      return;
    }
    try {
      Display.off('foldStatusChange', this.onFoldStatusChange);
    } catch (error) {
      log.showError(`unregister fold display status callback failed: ${error?.code}!`);
    }
  };

  private onFoldStatusChange = (newStatus: Display.FoldStatus) => {
    NavigationUtil.doPageBack();
  }

  /**
   * 初始化 ThemeResource
   * @returns iconPath
   */
  public async initThemeResource(checkedPath: string): Promise<string[]> {
    let iconPath: string[] = await THEME_ACTIVE_MANAGER.readAllIconResource();
    let iconPaths = iconPath.sort();
    let previewPath = THEME_ACTIVE_MANAGER.getCurrentIconId(iconPaths);
    this.previewPathData.setPreviewPath(checkedPath || previewPath);
    this.iconEditPageData.setOriPreviewPath(previewPath);
    return iconPath;
  }

  /**
   * 处理mDesktopParam参数
   *
   * @param uiContext 上下文
   * @param pageInfos NavPathStack
   * @returns mDesktopParam
   */
  public dealDesktopParam(pageInfos: NavPathStack): DesktopParam {
    this.mDesktopParam = AppStorage.get<DesktopParam>('desktopParam') as DesktopParam;
    if (this.mDesktopParam.rows === 0) {
      this.mDesktopParam.rows = 1;
    }
    if (this.mDesktopParam.columns === 0) {
      this.mDesktopParam.columns = 1;
    }
    // 简易布局字体固定放大1.45倍
    if (this.mDesktopParam.isSimpleMode) {
      this.mDesktopParam.fontSizeScale = 1.45;
    }
    // 是否是折叠屏展开状态
    const isFoldExpanded = desktopUtil.isFoldExpandStatus();
    const orientation = Display.getDefaultDisplaySync().orientation;
    // 是否是横屏状态
    const isLand = ORIENTATION_LANDSCAPE_LIST.includes(orientation);
    const isFoldExpandedInLandscape = isFoldExpanded && isLand;
    this.mDesktopParam.isFoldExpandedInLandscape = isFoldExpandedInLandscape;
    let iconChangeSize: number = this.mDesktopParam.iconChangeSize;
    let iconSize: number = this.mDesktopParam.iconSize;
    this.defaultIconSize = iconSize;
    // 防止图标大小计算2次
    if (iconChangeSize !== 0) {
      iconSize = iconSize - iconChangeSize;
    }
    // 折叠屏横屏展开状态下图标大小为48，而非52
    iconSize = this.mDesktopParam.isFoldExpandedInLandscape ? StyleConstants.DEFAULT_48 : iconSize;
    this.mDesktopParam.iconSize = iconSize;

    // 计算刚进入图标编辑页时图标的缩放比例，基于默认图标大小进行缩放
    const iconScale = Number((this.defaultIconSize / iconSize).toFixed(2));
    this.oriIconScale = iconScale;
    this.dealWantParams(pageInfos);
    this.iconChangeSizeData.setIconChangeSize(this.mDesktopParam.iconChangeSize);
    this.showNameState.setIsShowName(this.mDesktopParam.isShowName);
    this.setApplyLoading(false);
    this.gridRowManager = this.getBottomSheetViewManager(this.mDesktopParam.screenWidth);
    log.showWarn(`dealParms isTriFoldAllExpanded:${this.isTriFoldAllExpanded} isLandscape:${this.isLandscape} gridWidth:${this.mDesktopParam.gridWidth} ` +
      `vp2pxScale:${this.mDesktopParam.vp2pxScale} vp2px: ${vp2px(1)}` +
      `iconSize:${this.mDesktopParam.iconSize} defaultIconSize:${this.defaultIconSize}` +
      `nameFontColor: ${this.mDesktopParam.nameFontColor} oriIconScale: ${this.oriIconScale}`);
    return this.mDesktopParam;
  }

  private getBottomSheetViewManager(screenWidth: number): GridRowManager {
    if (screenWidth > IconEditPageConstants.GRID_LARGE_SIZE) {
      return X_LARGE_GRID;
    }
    if (screenWidth > IconEditPageConstants.GRID_MEDIUM_SIZE) {
      if (!DeviceHelper.isLandscape()) {
        return LARGE_GRID_NOT_LAND;
      }
      return LARGE_GRID;
    }
    if (screenWidth > IconEditPageConstants.GRID_SMALL_SIZE) {
      return MEDIUM_GRID;
    }
    return SMALL_GRID;
  }

  /**
   * 应用回调函数
   *
   * @param mDesktopParam DesktopParam
   * @param uiContext 上下文
   * @param loadingController CustomDialogController
   */
  public apply(mDesktopParam: DesktopParam, uiContext: common.UIAbilityContext,
    loadingController: CustomDialogController, callback: () => void): void {
    try {
      let isNameShow = this.showNameState.isShowName();
      let previewPath = this.previewPathData.getPreviewPath();
      let iconChangeSize = this.iconChangeSizeData.getIconChangeSize();
      HiEditModeEventUtils.reportApplyIconEdit(iconChangeSize, isNameShow);
      log.showWarn('desktopIconChangeSize: [%{public}d -> %{public}d],' +
        'isNameShow: [%{public}s -> %{public}s]',
        mDesktopParam.iconChangeSize, iconChangeSize, mDesktopParam.isShowName, isNameShow);
      let isShowNameChange = this.updateShowAppName(mDesktopParam.isShowName, isNameShow, uiContext);
      this.updateIconChangeSize(mDesktopParam.iconChangeSize, iconChangeSize, uiContext);
      if (mDesktopParam.iconChangeSize === iconChangeSize && !isShowNameChange) {
        // 没做任何修改 return
        callback();
        NavigationUtil.doPageBack();
        return;
      }
      this.publishApplyEvent();
      this.loadingAction(true, loadingController);
      setTimeout(() => {
        this.loadingAction(false, loadingController);
        callback();
        NavigationUtil.doApplyTheme();
      }, 2000);
    } catch (err) {
      log.showError(`apply error: ${err}`);
    }
  }

  private publishApplyEvent(): void {
    const publishData: commonEventManager.CommonEventPublishData = {
    }
    try {
      commonEventManager.publish('custom.event.APPLY_ICONS_SETTINGS', publishData, () => {
        log.showInfo(`successful to publish apply event message`);
      });
    } catch (err) {
      log.showError(TAG, `Publish message error about desktop edit, code = ${err?.code}`);
    }
  }

  private loadingAction(isOpen: boolean, loadingController: CustomDialogController): void {
    if (isOpen) {
      loadingController.open();
      // 屏幕朗读主动播报应用图标提醒
      if (this.mDesktopParam.isAccessibilityMode) {
        const accessibilityManager = AccessibilityManager.getInstance();
        accessibilityManager.sendTextAnnouncedForAccessibility(ResUtils.getInnerString($r('app.string.applyIcon')),
          'textAnnouncedForIconEditPageApplyIcon');
      }
      this.setApplyLoading(true);
    } else {
      loadingController.close();
      this.setApplyLoading(false);
    }
  }

  /**
   * 获取图标列表
   *
   * @param rows 最大行数
   * @param columns 最大列数
   * @returns 图标二维数组
   */
  public getIconArray(rows: number, columns: number): string[][] {
    if (this.mDesktopParam.isSimpleMode) {
      return EditModeConstants.PHONE_ICONS_SIMPLE;
    }
    if (this.isFoldExpanded) {
      return EditModeConstants.FOLDER_EXPAND_ICONS;
    } else if (this.isPad) {
      return this.getPadIconArray(rows, columns);
    } else if (this.isTriFoldAllExpanded) {
      if (this.isLandscape) {
        if (this.mDesktopParam.displayCount === StyleConstants.DEFAULT_3) {
          return EditModeConstants.TRIFOLDER_MODEL_G_TRI_SCREEN_ICONS;
        }
        return EditModeConstants.FOLDER_EXPAND_ICONS;
      } else {
        return EditModeConstants.TRIFOLDER_MODEL_G_PORTRAIT_ICONS;
      }
    }
    return EditModeConstants.PHONE_ICONS;
  }

  /**
   * 获取PAD图标列表
   *
   * @param rows 最大行数
   * @param columns 最大列数
   * @returns 图标二维数组
   */
  private getPadIconArray(rows: number, columns: number): string[][] {
    if (this.isLandscape) {
      let count = EditModeConstants.PAD_LANDSCAPE_ICONS[0].length;
      let maxColumnCount = Math.min(count, columns);
      return this.splitArrayColumn(EditModeConstants.PAD_LANDSCAPE_ICONS, maxColumnCount);
    }
    let count = EditModeConstants.PAD_ICONS[0].length;
    let maxColumnCount = Math.min(count, columns);
    return this.splitArrayColumn(EditModeConstants.PAD_ICONS, maxColumnCount);
  }

  /**
   * 对二维数组截取前几列
   *
   * @param oriArray 二维数组
   * @param maxCount 截取前几列
   * @returns 截取后的二维数组
   */
  private splitArrayColumn(oriArray: string[][], maxCount: number): string[][] {
    let retArr: string[][] = [];
    for (let i = 0; i < oriArray.length; i++) {
      let row: string[] = [];
      for (let j = 0; j < maxCount; j++) {
        row.push(oriArray[i][j]);
      }
      retArr.push(row);
    }
    return retArr;
  }

  /**
   * 获取半模态的宽度
   *
   * @param mDesktopParam DesktopParam
   * @returns
   */
  public getBottomSheetWidth(mDesktopParam: DesktopParam): number | string {
    if (this.isPad || this.isFoldExpanded || this.isTriFoldAllExpanded) {
      let bindSheetWidth = this.getBottomSheetViewManager(mDesktopParam.screenWidth)
        .getSpanWidth(mDesktopParam.screenWidth);
      log.showInfo('gridRowManager: %{public}s, bindSheetWidth: %{public}d',
        this.gridRowManager.toString(), bindSheetWidth);
      return this.vpToPx(bindSheetWidth);
    }
    return '100%';
  }

  /**
   * 获取应用按钮的宽度
   *
   * @param mDesktopParam DesktopParam
   * @returns 按钮的宽度
   */
  public getApplyButtonWidth(mDesktopParam: DesktopParam): number | string {
    if (this.isPad || this.isFoldExpanded || this.isTriFoldAllExpanded) {
      let padding = IconEditPageConstants.BOTTOMSHEET_LABEL_PADDING * 2;
      let buttonWidth: number = this.gridRowManager.getSpanWidth(mDesktopParam.screenWidth) - padding;
      let maxWidth: number = this.isPad || this.isTriFoldAllExpanded ? IconEditPageConstants.APPLY_BUTTON_WIDTH :
        Math.min(IconEditPageConstants.APPLY_BUTTON_WIDTH, mDesktopParam.screenWidth / 2 - padding);
      log.showInfo('getApplyButtonWidth buttonWidth: %{public}d, maxWidth: %{public}d', buttonWidth, maxWidth);
      return buttonWidth < maxWidth ? '100%' : this.vpToPx(maxWidth);
    }
    if (this.isPhone) {
      return '100%';
    }
    log.showInfo('getApplyButtonWidth2222.');
    return IconEditPageConstants.APPLY_BUTTON_WIDTH;
  }

  /**
   * 获取AppInfo
   *
   * @param type 类型
   * @returns AppInfo
   */
  public getAppInfo(type: string): AppInfo {
    if (EditModeConstants.APP_INFOS[type]) {
      return EditModeConstants.APP_INFOS[type];
    }
    return EditModeConstants.APP_INFOS.settings;
  }

  /**
   * 计算【小、标准、大】索引
   * @param value
   * @param defaultValue
   * @returns
   */
  public calculateIndex(value: number, defaultValue: number): number {
    if (value < defaultValue) {
      return IconEditPageConstants.APP_IMAGE_SIZE_SMALL_INDEX;
    } else if (value > defaultValue) {
      return IconEditPageConstants.APP_IMAGE_SIZE_LARGE_INDEX;
    } else {
      return IconEditPageConstants.APP_IMAGE_SIZE_NORMAL_INDEX;
    }
  }

  /**
   * 设置是否显示app名称
   *
   * @throws { Error } update icon size failed!
   * @param oriIsShowName 修改前的名称
   * @param isNameShow 是否显示app名称
   * @param uiContext Context
   * @returns 是否有修改
   */
  public updateShowAppName(oriIsShowName: boolean, isNameShow: boolean, uiContext: common.UIAbilityContext): boolean {
    if (oriIsShowName === isNameShow) {
      return false;
    }
    let res: boolean = sSettingsUtil.setSecureValue('isDesktopIconShowName', isNameShow.toString(), uiContext);
    if (!res) {
      throw new Error('update icon size failed!');
    }
    return true;
  }

  /**
   * 设置iconChangeSize
   *
   * @throws { Error } update icon size failed!
   * @param oriSize 修改之前的大小
   * @param size 要修改的值
   * @param uiContext Context
   * @returns 是否有修改
   */
  public updateIconChangeSize(oriSize: number, size: number, uiContext: common.UIAbilityContext): boolean {
    if (oriSize === size) {
      return false;
    }
    let res: boolean = sSettingsUtil.setSecureValue('desktopIconChangeSize', size.toString(), uiContext);
    if (!res) {
      throw new Error('update icon size failed!');
    }
    return true;
  }

  /**
   * 获取图标预览的宽度
   *
   * @param mDesktopParam
   * @returns
   */
  public getPreviewContentWidth(mDesktopParam: DesktopParam): number {
    if (this.isFoldExpanded) {
      return mDesktopParam.gridWidth * 2;
    } else if (this.isPhone) {
      return mDesktopParam.gridWidth;
    } else if (this.isPad || this.isTriFoldAllExpanded) {
      return this.isLandscape ? mDesktopParam.gridWidth : mDesktopParam.gridHeight;
    }
    return mDesktopParam.gridWidth;
  }

  /**
   * 处理want参数
   *
   * @param pageInfos NavPathStack参数
   * @returns
   */
  public dealWantParams(pageInfos: NavPathStack): void {
    const want: WantParams[] = pageInfos.getParamByName(EditModeConstants.PATH_ICON) as WantParams[];
    let wantParams: WantParams = new WantParams();
    if (want.length > 0) {
      wantParams = want[0];
      if (wantParams.session) {
        NavigationUtil.session = wantParams.session;
        NavigationUtil.session.setReceiveDataCallback((data: Record<string, Object>) => this.dataReceiveCallback(data));
      }
    }
  }

  /**
   * 退出图标编辑动画
   *
   */
  public backAnimation(): void {
    this.iconEditShowManager.isShowBindSheet = false;
    animateTo({
      duration: 500,
      onFinish: () => {
        NavigationUtil.backAnimationDone();
      }
    }, () => {
      this.iconEditShowManager.isShow = false;
    })
  }

  /**
   * 进入图标编辑展示动画
   *
   */
  public appearToShow(): void {
    animateTo({
      delay: 0,
    }, () => {
      this.iconEditShowManager.isShowBindSheet = true;
      this.iconEditShowManager.isShow = true;
    })
  }

  public getSpaceOfScreenSize(desktopParam: DesktopParam): number {
    let scrWidth = desktopParam.singlePageFoldScreenWidth;
    let allIconWidth = desktopParam.iconSize * desktopParam.columns * StyleConstants.DEFAULT_2;
    // 折叠屏展开态横屏图标到屏幕侧边的空白距离，与HorizontalFoldPhoneLayoutRulesController保持一致
    let spaceX: number = (scrWidth * 2 - allIconWidth - 6 * IconEditPageConstants.SPACE_OF_COLUMN - 32 * 2) / 3;
    // 折叠屏展开态横屏分页中间间距，与HorizontalFoldPhoneLayoutRulesController保持一致
    return spaceX - IconEditPageConstants.SPACE_OF_COLUMN
  }

  public dataReceiveCallback(data: Record<string, Object>): void {
    if (this.isLoading) {
      log.showInfo('dataReceiveCallback isLoading return.');
      return;
    }
    log.showInfo('dataReceiveCallback');
    Object.keys(data).forEach(key => {
      if (key === EditModeConstants.BACK_EVENT) {
        log.showInfo('doBack');
        if (this.isLoading) {
          return;
        }
        NavigationUtil.doPageBack();
        this.backAnimation();
      } else if (key === EditModeConstants.SHOW_EVENT) {
        log.showInfo('doShow');
        this.appearToShow();
      }
    });
  };


  /**
   * 获取图标预览区域高度
   * @returns
   */
  public getPreviewContentHeight(): number {
    return this.mDesktopParam.gridHeight *
      iconEditViewModel.getIconArray(this.mDesktopParam.rows,
        this.mDesktopParam.columns).length / this.mDesktopParam.rows;
  }

  /**
   * 计算滚动条高度
   *
   * @param mDesktopParam want参数
   * @param applyButtonHeight 应用按钮高度
   * @returns 滚动条高度
   */
  public calculateScrollHeight(mDesktopParam: DesktopParam, applyButtonHeight: number): number {
    let pageHeight: number = mDesktopParam.screenHeight - mDesktopParam.statusBarHeight;
    let scrollHeight: number =
      pageHeight * this.mDesktopParam.vp2pxScale - vp2px(IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT) -
        this.getPreviewContentHeight() * this.mDesktopParam.vp2pxScale - vp2px(applyButtonHeight);
    log.showInfo('scrollHeight: %{public}d', scrollHeight);
    return Math.min(scrollHeight, vp2px(IconEditPageConstants.BOTTOM_SHEET_SCROLL_HEIGHT));
  }

  /**
   * 获取前置、后置图标路径
   *
   * @param path 路径
   * @param bundleName bundleName
   * @returns 前置、后置图标路径数组
   */
  public createRelativePath(path: string, bundleName: string): string[] {
    let parent: string =
      path + EditModeConstants.FILE_SEPARATOR + EditModeConstants.PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
        bundleName;
    let backPath = parent + EditModeConstants.FAKE_ICON_BACK_PATH + EditModeConstants.FORMAT_PNG;
    let backUri: string = '';
    let foreUri: string = '';
    if (FileUtils.isExist(backPath)) {
      backUri = FileUtils.getUriFromPath(backPath);
    } else {
      backPath = parent + EditModeConstants.FAKE_ICON_BACK_PATH + EditModeConstants.FORMAT_WEBP;
      backUri = FileUtils.getUriFromPath(backPath);
    }
    let forePath = parent + EditModeConstants.FAKE_ICON_FORE_PATH + EditModeConstants.FORMAT_PNG;
    if (FileUtils.isExist(forePath)) {
      foreUri = FileUtils.getUriFromPath(forePath);
    } else {
      forePath = parent + EditModeConstants.FAKE_ICON_FORE_PATH + EditModeConstants.FORMAT_WEBP;
      foreUri = FileUtils.getUriFromPath(forePath);
    }
    log.showDebug('backURI: %{public}s, foreUri: %{public}s.', backUri, foreUri);
    return [backUri, foreUri];
  }

  /**
   * 针对图标预览区域将vp转成px
   * @param size
   * @returns
   */
  public vpToPx(size: number): string {
    return size * this.mDesktopParam.vp2pxScale + 'px';
  }

  /**
   * 极深极浅背景下叠加半模态框背景颜色
   * @param isDarkMode 是否为深色模式
   * @param wallpaperType 背景颜色
   * @returns 叠加颜色
   */
  public getMixColor(wallpaperType: number, isDarkMode: boolean): ResourceStr {
    log.showInfo(`getMixColor wallpaperType ${wallpaperType} isDarkMode ${isDarkMode}`);
    // 普通模式下的极浅背景
    if (!isDarkMode && wallpaperType === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      return $r('app.color.bottomsheet_additive_white_color');
    }
    // 深色模式下的极深、普通花、极花背景
    if (isDarkMode && (wallpaperType === WallpaperConstants.WALLPAPER_TYPE_FOUR ||
      wallpaperType === WallpaperConstants.WALLPAPER_TYPE_FIVE ||
      wallpaperType === WallpaperConstants.WALLPAPER_TYPE_SIX)) {
      return $r('app.color.bottomsheet_additive_black_color');
    }
    return '';
  }

  /**
   * 屏幕朗读主动播报和主动聚焦
   * @param customId 待聚焦组件id
   */
  public sendAccessibilityEvent(customId: string): void {
    if (this.mDesktopParam.isAccessibilityMode) {
      const accessibilityManager = AccessibilityManager.getInstance();
      accessibilityManager.sendTextAnnouncedForAccessibility(ResUtils.getInnerString($r('app.string.icon')),
        'announceForIconEditPageIcon');
      accessibilityManager.requestFocusForAccessibility(customId, 'requestFocusForIconEditPage');
    }
  }

  /**
   * 获取编辑模式下图标编辑预览区域中图标名称的id
   * @param bundleName 图标名称
   */
  public getEditIconNameId(bundleName: string): string {
    return 'icon_text_' + bundleName;
  }

  /**
   * 生成编辑页面文字阴影
   *
   * @param info AppItemTextShadowInfo
   * @param shadowKey the key to cache the textShadow
   * @returns color of text shadow;
   */
  public async generateEditShadow(info: AppItemTextShadowInfo, shadowKey: string, pixmap: image.PixelMap):
    Promise<string> {
    if (info.screenWidth <= info.startOffsetX || info.screenHeight <= info.startOffsetY) {
      log.showError(`the screen width is error screenWidth ${info.screenWidth} screenHeight ${info.screenHeight}`);
      return ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0);
    }
    let resColorShadow: string = ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0);
    let colorPickerRegion: number[] = [
      info.startOffsetX / info.screenWidth,
      info.startOffsetY / info.screenHeight,
      (info.startOffsetX + info.nameWidth) / info.screenWidth,
      (info.startOffsetY + info.nameHeight) / info.screenHeight
    ];
    log.showInfo('generateShadow, x:%{public}d y:%{public}d region:%{public}s', info.startOffsetX, info.startOffsetY, colorPickerRegion.toString());
    try {
      let colorShadow = await textShadowMgr.getShadowColor(pixmap, colorPickerRegion);
      if (colorShadow !== undefined) {
        log.showInfo(`caching the TextShadow color ${colorShadow}, key ${shadowKey}`);
        ComponentPosShadowCache.getInstance().setCache(shadowKey, colorShadow);
      }
      resColorShadow = colorShadow ?? '';
    } catch (error) {
      log.showInfo(`generateShadow error with msg ${error?.msg}`);
    }
    return resColorShadow;
  }

  /**
   * 创建背景图片资源
   */
  public async createPixmap(): Promise<void> {
    try {
      const pixmap = await WallpaperManager.getInstance().getWallpaper(WallpaperType.DESKTOP, TAG);
      if (this.pixmap !== undefined) {
        this.pixmap?.release();
        log.showInfo(`release previous pixmap`);
      }
      this.pixmap = pixmap;
      AppStorage.setOrCreate<boolean>('wallpaperPixmapExitFlag', true);
      this.mIconEditProperty.isWallpaperReady = true;
      log.showInfo(`createPixmap success`);
    } catch (e) {
      log.showError('createPixmap error');
      AppStorage.setOrCreate<boolean>('wallpaperPixmapExitFlag', false);
    }
  }

  /**
   * 极深极浅背景下更新编辑模式文本阴影颜色
   * @param bundleName 图标名
   * @param key 行列拼接的唯一key
   * @returns 阴影颜色
   */
  public async updateIconNameShadow(bundleName: string, key: string): Promise<Color | string> {
    if (!(this.mDesktopParam.isNeedAppNameShadow)) {
      return ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0);
    }
    // 定位图标所在的背景横纵坐标，用于取背景的颜色来生成文本阴影的颜色
    let strJson: string = getInspectorByKey(this.getEditIconNameId(bundleName));
    let rect: string = '';
    try {
      rect = JSON.parse(strJson).$rect as string;
    } catch (e) {
      log.showError('strJson parse error');
      return ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0);
    }
    let boundArray: number[] = rect?.split(/[,\[\]]/).filter(str => str.length > 0).map(str => {
      return px2vp(parseFloat(str));
    });
    let offsetX = boundArray[0];
    let offsetY = boundArray[1];
    let screenWidth: number = this.mDesktopParam.screenWidth;
    let screenHeight: number = this.mDesktopParam.screenHeight;
    let info: AppItemTextShadowInfo = {
      startOffsetX: offsetX,
      startOffsetY: offsetY,
      maxRow: 0,
      maxCol: 0,
      nameWidth: (boundArray[2] - boundArray[0]),
      nameHeight: (boundArray[3] - boundArray[1]),
      screenWidth: screenWidth,
      screenHeight: screenHeight
    };
    // 获取背景，用于取背景的颜色
    let refreshColor: Color | string = ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0);
    if (CheckEmptyUtils.isEmpty(this.pixmap)) {
      log.showInfo('no pixmap');
    } else {
      try {
        refreshColor = await this.generateEditShadow(info, key, this.pixmap!!);
      } catch (e) {
        log.showInfo('generateEditShadow error');
      }
    }
    return refreshColor;
  }


  // 图标大小编辑 默认大小
  private defaultIconSizeOffset: number = 0;

  /**
   * 图标编辑 图标大小滑动条初始化逻辑
   * @param defaultIconSizeOffset 默认大小偏移值
   */
  public initIconSize(defaultIconSizeOffset: number): void {
    this.defaultIconSizeOffset = defaultIconSizeOffset;
    this.onIconSizeTextChange(defaultIconSizeOffset, this.iconChangeSizeData.getIconChangeSize());
  }

  /**
   * 图标编辑 图标大小变化后更新对应文字描述
   * @param defaultSize 默认大小偏移值
   * @param newSize 变化后大小偏移值
   */
  public onIconSizeTextChange(defaultSize: number, newSize: number): void {
    log.showInfo('iconSizeTextChane newIconSizeOffset: %{public}d.', newSize);
    this.iconEditProperty.iconSizeOffsetDescription =
      ICON_SIZE_DESCRIPTION_RESOURCE_LIST[this.calculateIndex(newSize, defaultSize)];
  }

  /**
   * 图标编辑 图标大小滑动条change事件
   * @param value 变化后大小偏移值
   * @param mode 滑动事件
   */
  public onIconSizeSliderChange(value: number, mode: SliderChangeMode): void {
    log.showInfo('slider value: %{public}d', value);
    try {
      let dynamicValue: number = Math.round(value);
      if (dynamicValue !== this.iconChangeSizeData.getIconChangeSize()) {
        this.onIconSizeTextChange(this.defaultIconSizeOffset, dynamicValue);
        // 缩放动效
        animateTo({
          curve: curves.springMotion(0.468, 1)
        }, () => {
          this.calcIconScale(dynamicValue);
          this.iconChangeSizeData.setIconChangeSize(dynamicValue);
        });
        log.showInfo('slider dynamicValue: %{public}d, defaultValue: %{public}d.', dynamicValue, this.defaultIconSizeOffset);
        if (dynamicValue === this.defaultIconSizeOffset) {
          vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LONG_PRESS,
            CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
        }
      }
    } catch (err) {
      log.showError(`onIconSizeSliderChange error: ${err}`);
    }
  }

  /**
   * 图标编辑 滑动条组件大小变化
   * @param oldValue
   * @param newValue
   * @param min
   * @param max
   * @returns
   */
  public onIconSizeSliderSizeChange(oldValue: SizeOptions, newValue: SizeOptions, min: number, max: number): number {
    let slideWidth: number = Number(newValue.width);
    if (this.mDesktopParam.isRTL) {
      return slideWidth * (1 - (this.defaultIconSizeOffset - min) / (max - min));
    }
    return slideWidth * (this.defaultIconSizeOffset - min) / (max - min);
  }

  /**
   * 图标编辑 根据当前壁纸类型判断是否需要显示应用名阴影
   * @param desktopParam
   * @returns
   */
  public isNeedShadowInSpecialBg(desktopParam: DesktopParam): boolean {
    return !WallpaperConstants.WALLPAPER_TYPE_NO_NEED_TXT_SHADOW.includes(desktopParam.wallpaperType);
  }

  /**
   * 获取图标编辑响应式数据
   * @returns
   */
  public get iconEditProperty(): IconEditProperty {
    return this.mIconEditProperty;
  }

  /**
   * 获取不受设置显示大小影响的数据
   * @param size
   * @returns
   */
  public getIgnoreShowZoomSize(size: number): number {
    return size * this.mDesktopParam.vp2pxScale / vp2px(1);
  }

  /**
   * 根据刚进入图标编辑页时的图标大小计算图标圆角，同时适配显示大小缩放，缩放过程中圆角不会改变
   * @returns
   */
  public getIconRadius(): number {
    const radius = this.mDesktopParam.iconSize * (this.mDesktopParam.iconRadius / this.defaultIconSize);
    return this.getIgnoreShowZoomSize(radius);
  }

  /**
   * 获取图标名称字体大小
   * 同桌面不响应设置显示大小改变
   * @returns
   */
  public getAppNameFontSize(): number | string {
    if (this.mDesktopParam.isSimpleMode) {
      // UX规格：简易布局图标名称字体大小固定为18vp，不跟随系统设置字体大小
      return this.getIgnoreShowZoomSize(IconEditPageConstants.ICON_NAME_TEXT_SIZE_SIMPLE) + 'vp';
    } else {
      return this.getIgnoreShowZoomSize(IconEditPageConstants.ICON_NAME_TEXT_SIZE);
    }
  }

  /**
   * 折叠屏展开态，左右半屏有间距
   * @returns
   */
  public getScreenMargin(index: number, totalLength: number): Margin {
    let screenMargin: Margin = {
      left: 0,
      right: 0,
    };
    const marginTranslate: number =
      this.mDesktopParam.displayCount === StyleConstants.DEFAULT_3 ? this.mDesktopParam.foldPaddingSide : 0;
    if (index % (totalLength / this.mDesktopParam.displayCount) === 0 && index !== 0) {
      if (this.mDesktopParam.isRTL) {
        screenMargin.right = this.vpToPx(this.mDesktopParam.mMargin * 2 - marginTranslate);
      } else {
        screenMargin.left = this.vpToPx(this.mDesktopParam.mMargin * 2 - marginTranslate);
      }
    }
    return screenMargin;
  }

  /**
   * 计算图标缩放值
   * 缩放值 = （图标默认大小 + 改变值） / 图标默认大小
   */
  public calcIconScale(iconChangeSize: number): void {
    const iconScale = Number(((this.mDesktopParam.iconSize + iconChangeSize) / this.mDesktopParam.iconSize)
      .toFixed(2));
    this.iconScaleModifierArr.forEach(modifier => {
      modifier.attribute?.scale({
        x: iconScale,
        y: iconScale,
        centerY: '100%'
      });
    })
    log.showInfo(`sizeChange:${iconChangeSize} iconScale: ${iconScale} baseIconSize: ${this.mDesktopParam.iconSize}`);
  }

  /**
   * 图标编辑页设置项定制字体、行高大小（vp）
   * UX规格：镜像语言最高放大1.3倍，防止文字超长截断，其他语言1.45倍
   *
   * @param font 字体、行高
   * @returns
   */
  public getScaleSize(font: Resource | number, fontSizeScale: number): string {
    let scale = Math.min(fontSizeScale, RTLUtil.isRTL() ?
      EditModeConstants.MAX_FONT_SIZE_SCALE_RT : EditModeConstants.MAX_FONT_SIZE_SCALE);
    log.showInfo(`getScaleSize scale: ${scale}`);
    if (typeof font === 'number') {
      return font * scale + 'vp';
    }
    return ResUtils.getNumber(font) * scale + 'vp';
  }
}

@Observed
export class IconEditShowManager {
  public isShow: boolean = true;
  public isShowBindSheet: boolean = true;
}

/**
 * 图标编辑响应式数据
 */
@Observed
export class IconEditProperty {
  /**
   * 图标大小的文字描述
   */
  @Track
  public iconSizeOffsetDescription: Resource;

  /**
   * 图标编辑页壁纸是否加载完成
   */
  @Track
  public isWallpaperReady: boolean;

  constructor(iconSizeOffsetDescription: Resource, iconScale: number) {
    this.iconSizeOffsetDescription = iconSizeOffsetDescription;
    this.isWallpaperReady = false;
  }
}

/**
 * 图标编辑页预览图标modifier
 */
export class IconScaleModifier extends AttributeUpdater<CommonAttribute> {
  private oriIconScale: number = 1;

  constructor(oriIconScale: number) {
    super();
    this.oriIconScale = oriIconScale;
  }

  initializeModifier(instance: CommonAttribute): void {
    instance.scale({ x: this.oriIconScale, y: this.oriIconScale, centerY: '100%' });
  }
}

export const iconEditViewModel: IconEditViewModel = SingletonHelper.getInstance(IconEditViewModel, TAG);