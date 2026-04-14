/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  AppListStyleConfig,
  CalculateDockRst,
  ConfigParseUtil,
  SmartDockZoomFeatureSwitch
} from '@ohos/launchercommon';
import { CommonConstants, DesktopMode, IconCommonUtil } from '@ohos/launchercommon';
import { LayoutViewModel } from '@ohos/launchercommon';
import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import FeatureConstants from './constants/FeatureConstants';
import { ThemeStyleManager } from '@ohos/launchercommon';
import type { ThemeStyleInfo } from '@ohos/launchercommon';
import { RadiusUtil } from '@ohos/launchercommon';
import { ThemeStylePreviewManager } from '@ohos/launchercommon';
import SmartDockConstants from './constants/SmartDockConstants';

const TAG = 'SmartDockStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MAX_RESIDENT_LIST_LENGTH_CONFIG_PATH = 'etc/desktop/grid_layout_config.json';
// 根据UX要求调整物理大小大于8mm，使用dpi460换算，vp值大于40
const MIN_ICON_SIZE: number = 40;
const DEFAULT_ICON_SIZE: number = 58;
const DEFAULT_ICON_SPACE: number = 16;
const SAFE_SCREEN_SPACE: number = 24;
const DIVIDER_WIDTH: number = 20;
const MAX_RECENT_LENGTH: number = 4;

/**
 * smartdock layout style config
 */
export class SmartDockStyleConfig extends AppListStyleConfig {
  private static mInstance: SmartDockStyleConfig;

  /**
   * Max dock list num from CCM
   */
  private maxDockNumFromCCM: number = 0;

  /**
   * dock list hight
   */
  public mDockHeight = 78;

  /**
   * dock list background color
   */
  public mBackgroundColor = '#B8FAFAFA';

  /**
   * dock list border radius
   */
  public mDockRadius = 24;

  /**
   * dock list background blur
   */
  public mBackdropBlur = 0;

  /**
   * dock background saturation
   */
  public mBackSaturation = 0;

  /**
   * dock list padding
   */
  public mDockPadding = 9;

  /**
   * dock list margin
   */
  public mDockMargin = 10;

  /**
   * dock list item width
   */
  public mListItemWidth = 60;

  /**
   * dock list item height
   */
  public mListItemHeight = 60;

  /**
   * dock list item gap
   */
  public mListItemGap = 2;

  /**
   * dock list direction
   */
  public mListDirection: Axis = Axis.Horizontal;

  /**
   * dock list name display side
   */
  public mNameDisplaySide = true;

  /**
   * dock is show with app name
   */
  public mWithAppName = false;

  /**
   * dock list item icon size
   */
  public mIconSize = 54;

  /**
   * dock list item padding
   */
  public mItemPadding = 3;

  /**
   * dock left and right item padding extra width, only use in pad
   */
  public mPaddingExtraWidth = 2;

  /**
   * dock list item background color
   */
  public mItemBackgroundColor = '';

  /**
   * dock list item border radius
   */
  public mItemBorderRadius = 0;

  /**
   *  gap between resident dock and recent dock
   */
  public mDockGap = 12;

  /**
   *  simple mode margin top
   */
  public simpleModeMarginTop = 0;

  /**
   * resident dock max item number
   */
  private _mMaxDockNum = 16;

  public set mMaxDockNum(value) {
    this._mMaxDockNum = value;
  }

  public get mMaxDockNum(): number {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      return this._mMaxDockNum + 1;
    }
    return this._mMaxDockNum;
  }

  /**
   * recent dock max item number
   */
  public mMaxRecentNum = 3;

  /**
   * sum dock max number
   */
  public mMaxNum = 19;

  /**
   * min resident num
   */
  public mMinResidentNum = 2;

  /**
   * dock bottom margin
   */
  public mMarginBottom = 24;

  /**
   * resident split line width of dock, only use in pc and pad
   */
  public mResidentSplitLineWidth = 0;

  /**
   * resident split line height of dock, only use in pc and pad
   */
  public mResidentSplitLineHeight = 0;

  /**
   * resident split line color of dock, only use in pc and pad
   */
  public mResidentSplitLineColor = '#33FFFFFF';

  /**
   * resident split line gap of dock, only use in pc and pad
   */
  public mResidentSplitLineGap = 0;

  /**
   * recent arrow width of dock, only use in pc and pad
   */
  public mRecentArrowWidth = 0;

  /**
   * recent arrow height of dock, only use in pc and pad
   */
  public mRecentArrowHeight = 0;

  /**
   * recent arrow padding of dock, only use in pc and pad
   */
  public mRecentArrowPadding = 0;

  /**
   * recent arrow gap of dock, only use in pc and pad
   */
  public mRecentArrowGap = 0;

  /**
   * recent dock max number for phone and pad
   */
  public mRecentDockMaxNumber = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;

  /**
   * Icon radius
   */
  public mIconRadius = CommonConstants.DEFAULT_ICON_RADIUS;

  /**
   * Preview icon radius
   */
  public mIconRadiusPreview = CommonConstants.DEFAULT_ICON_RADIUS;

  /**
   * dock backplane padding
   */
  public mBackPlanePadding = 12;

  /**
   * fixed dock max total num
   */
  public mFixedMaxNum = 26;

  /**
   * screen width
   */
  public mScreenWidth = 0;

  /**
   * screen height
   */
  public mScreenHeight = 0;

  /**
   * toggle home width
   */
  public mToggleHomeWidth = 8;

  /**
   * toggle home divider width
   */
  public mToggleHomeDividerWidth = 1;

  /**
   * divider width
   */
  public mDividerWidth = 20;

  /**
   * Connector icon and background size
   */
  public mDeviceTypeIconSize = SmartDockConstants.DEVICE_TYPE_ICON_SIZE_DEFAULT;

  public mDeviceTypeIconBackgroundSize = SmartDockConstants.DEVICE_TYPE_BG_SIZE_DEFAULT;

  /**
   * smartDock margin top
   */
  public mSmartDockMarginTop = DeviceHelper.isPhone() ? 0 : 7;

  private static isInPreviewMode: boolean = false;

  protected constructor() {
    super();
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      this.initConfig();
      this.loadDockListLengthConfig();
    }
  }

  /**
   * get SmartDockStyleConfig getInstance
   */
  static getInstance(): SmartDockStyleConfig {
    if (SmartDockStyleConfig.mInstance == null) {
      SmartDockStyleConfig.mInstance = new SmartDockStyleConfig();
      log.showInfo('getInstance!');
    }
    SmartDockStyleConfig.mInstance.initConfig();
    return SmartDockStyleConfig.mInstance;
  }

  /**
   * set SmartDockStyleConfig preview mode
   */
  static setInPreviewMode(isInPreviewMode: boolean): void {
    SmartDockStyleConfig.isInPreviewMode = isInPreviewMode;
    SmartDockStyleConfig.getInstance().initConfig();
  }

  /**
   * only for debug mode,do not use it
   */
  public static updateDockListLengthConfig(): void {
    SmartDockStyleConfig.getInstance().loadDockListLengthConfig();
  }

  initConfig(): void {
    const result = LayoutViewModel.getInstance().calculateDock();
    this.initByDockResult(result);
    this.mScreenWidth = LayoutViewModel.getInstance().getScreenWidth();
    this.mScreenHeight = LayoutViewModel.getInstance().getScreenHeight();
    // 常驻区+最近区同时显示图标的最大数量
    this.mFixedMaxNum = Math.floor((this.mScreenWidth - 4 * this.mRecentArrowWidth - this.mResidentSplitLineWidth -
      4 * this.mRecentArrowGap - 48) / (this.mListItemWidth + this.mListItemGap));

    this.updateDockStyle();
    this.updateDockStylefromSecure();
    log.showInfo('dock init config mIconSize:%{public}d, mDockHeight:%{public}d, mMarginBottom:%{public}d',
      this.mIconSize, this.mDockHeight, this.mMarginBottom);
  }

  private initByDockResult(result: CalculateDockRst): void {
    this.mDockGap = result.mDockGap ?? 0;
    this.mDockRadius = result.mDockRadius ?? 0;
    this.mIconSize = result.mIconSize ?? 0;
    this.mBackgroundColor = result.mBackgroundColor ?? '';
    this.mBackdropBlur = result.mBackdropBlur ?? 0;
    this.mBackSaturation = result.mBackSaturation ?? 0;
    this.mListItemWidth = result.mListItemWidth ?? 0;
    this.mListItemHeight = result.mListItemHeight ?? 0;
    this.mListItemGap = result.mListItemGap ?? 0;
    this.mDockPadding = result.mDockPadding ?? 0;
    this.mMaxRecentNum = result.mMaxRecentNum ?? 0;
    if (this.maxDockNumFromCCM <= 0) {
      this.mMaxDockNum = result.mMaxDockNum ?? 0;
    } else {
      this.mMaxDockNum = this.maxDockNumFromCCM;
    }
    this.mDockHeight = result.mDockHeight ?? 0;
    this.mMarginBottom = result.mMarginBottom ?? 0;
    this.mMaxNum = result.mMaxNum ?? 0;
    this.mMinResidentNum = result.mMinResidentNum ?? 0;
    this.initSplitAndArrow(result);
  }

  private initSplitAndArrow(result: CalculateDockRst): void {
    this.mResidentSplitLineWidth = result.mResidentSplitLineWidth ?? 0;
    this.mResidentSplitLineHeight = result.mResidentSplitLineHeight ?? 0;
    this.mResidentSplitLineColor = result.mResidentSplitLineColor ?? '';
    this.mResidentSplitLineGap = result.mResidentSplitLineGap ?? 0;
    this.mRecentArrowWidth = result.mRecentArrowWidth ?? 0;
    this.mRecentArrowHeight = result.mRecentArrowHeight ?? 0;
    this.mRecentArrowPadding = result.mRecentArrowPadding ?? 0;
    this.mRecentArrowGap = result.mRecentArrowGap ?? 0;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  getFeatureName(): string {
    return FeatureConstants.FEATURE_NAME;
  }

  private updateDockStylefromSecure(): void {
    // PC的dock栏不变
    if (DeviceHelper.isPC()) {
      return;
    }
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;
    if (IconCommonUtil.isValidIconSizeChange(desktopIconChangeSize)) {
      this.mIconSize += desktopIconChangeSize;
      this.mListItemWidth += desktopIconChangeSize;
      this.mListItemHeight += desktopIconChangeSize;
      this.mListItemGap -= desktopIconChangeSize;
      this.mDockHeight += desktopIconChangeSize;
      this.simpleModeMarginTop = desktopIconChangeSize / 2;
      AppStorage.setOrCreate('dockIconSize', this.mIconSize);
    }
    this.mIconRadius = RadiusUtil.calculateRadius(this.mIconSize);
    this.mDockRadius = this.mIconRadius > 0 ? this.mIconRadius + this.mBackPlanePadding : this.mIconRadius;
  }

  private updateDockStyle(): void {
    // PC的dock栏不变
    if (DeviceHelper.isPC()) {
      return;
    }

    let themeInfo: ThemeStyleInfo;
    if (SmartDockStyleConfig.isInPreviewMode) {
      themeInfo = ThemeStylePreviewManager.getInstance().getThemeStyle();
    } else {
      themeInfo = ThemeStyleManager.getInstance().getThemeStyle();
    }

    if (themeInfo.iconSizeScale !== undefined) {
      this.mIconSize += themeInfo.iconSizeScale;
      this.mListItemWidth += themeInfo.iconSizeScale;
      this.mListItemHeight += themeInfo.iconSizeScale;
      this.mListItemGap -= themeInfo.iconSizeScale;
      this.mDockHeight += themeInfo.iconSizeScale;
    }
    this.mIconRadius = RadiusUtil.calculateRadius(this.mIconSize,
      SmartDockStyleConfig.isInPreviewMode ? DesktopMode.PREVIEW_MODE : DesktopMode.NORMAL_MODE);
    this.mDockRadius = this.mIconRadius > 0 ? this.mIconRadius + this.mBackPlanePadding : this.mIconRadius;

    log.showInfo('updateDockStyle, isInPreviewMode:%{public}s, iconSizeScale:%{public}d, mIconSize:%{public}d, ' +
      'mIconRadius:%{public}d, mDockRadius:%{public}d', SmartDockStyleConfig.isInPreviewMode, themeInfo.iconSizeScale,
      this.mIconSize, this.mIconRadius, this.mDockRadius);
  }

  private loadDockListLengthConfig(): void {
    try {
      let cfgFile: string = ConfigParseUtil.getConfigSync(MAX_RESIDENT_LIST_LENGTH_CONFIG_PATH);
      if (CheckEmptyUtils.checkStrIsEmpty(cfgFile)) {
        this.mMaxDockNum = this.listLengthFilter('');
        this.maxDockNumFromCCM = this.listLengthFilter('');
        log.showWarn('cfgFile is empty');
        return;
      }
      const cfgJson: CfgJson = FileUtils.readJsonFile(cfgFile);
      const config = cfgJson.dockConfig;
      this.maxDockNumFromCCM = this.listLengthFilter(config?.maxResidentListLength ?? '');
    } catch (e) {
      log.showError('read dock list length config JSON fail ' + e);
    }
  }

  private listLengthFilter(length: string): number {
    const lengthNumber: number = Number(length);
    const minScreenWidth: number = Math.min(this.mScreenWidth, this.mScreenHeight);
    const minZoomScale: number = MIN_ICON_SIZE / DEFAULT_ICON_SIZE;
    const maxRecentWidth: number = minZoomScale *
      (MAX_RECENT_LENGTH * (DEFAULT_ICON_SIZE + DEFAULT_ICON_SPACE) + 2 * this.mDockPadding - DEFAULT_ICON_SPACE);
    const collaborationPaddingWithdth: number = minZoomScale * ( 2 * this.mDockPadding);
    const maxResidentLength: number =
      Math.floor((minScreenWidth - 2 * SAFE_SCREEN_SPACE - 2 * DIVIDER_WIDTH * minZoomScale - maxRecentWidth -
      collaborationPaddingWithdth) / (minZoomScale * (DEFAULT_ICON_SIZE + DEFAULT_ICON_SPACE)));

    const isIllegalLength: boolean =
      Number.isNaN(lengthNumber) || lengthNumber <= 0 || lengthNumber > maxResidentLength;
    if (isIllegalLength) {
      log.showWarn('resident list length config is illegal, return default number: %{public}d', maxResidentLength);
      return maxResidentLength;
    }
    log.showInfo('read dock list length config JSON success.mMaxDockNum =  %{public}d', lengthNumber);
    return lengthNumber;
  }
}

export interface CfgJson {
  row: number,
  column: number,
  space: number,
  iconSize: number,
  dockConfig?: DockConfig
}

export interface DockConfig {
  maxResidentListLength: string
}