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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  layoutConfigManager,
  SmartDockZoomFeatureSwitch,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { launcherStatusUtil } from '@ohos/windowscene';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { SCBSceneSessionManager } from '@ohos/windowscene';

const TAG = 'SmartDock_M_DockRegionLayoutModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_APP_ICON_WIDTH: number = 12.6;
const SAFE_SCREEN_SPACE: number = 24;

/**
 * DockRegionLayoutModel
 */
export class DockRegionLayoutModel {
  public static getInstance(): DockRegionLayoutModel {
    if (DeviceHelper.isPhone()) {
      return PhoneDockRegionLayoutModel.getInstance();
    } else if (DeviceHelper.isPad()) {
      return PadDockRegionLayoutModel.getInstance();
    } else {
      log.showWarn('device type is without dock,please check');
      return PhoneDockRegionLayoutModel.getInstance();
    }
  }

  protected constructor() {
    this.mSmartDockStyleConfig =
      layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
    this.regionLayoutWidths = new Map<DockRegionType, number>();
  }

  protected readonly mSmartDockStyleConfig: SmartDockStyleConfig;
  protected iconScale: number = 1;
  private regionLayoutWidths: Map<DockRegionType, number>;

  protected residentItemsVisibleCount: number = 0;
  protected recentItemsVisibleCount: number = 0;
  protected collaborationItemsVisibleCount: number = 0;

  public getListCount(): number {
    log.showInfo('residentItemsVisibleCount:%{public}d, recentItemsVisibleCount:%{public}d,collaborationItemsVisibleCount:%{public}d',
      this.residentItemsVisibleCount, this.recentItemsVisibleCount, this.collaborationItemsVisibleCount);
    if (SCBSceneSessionManager.getInstance().isPcMode() && this.recentItemsVisibleCount >=
      this.mSmartDockStyleConfig.mRecentDockMaxNumber) {
      return this.residentItemsVisibleCount + this.mSmartDockStyleConfig.mRecentDockMaxNumber +
        this.collaborationItemsVisibleCount;
    }
    return this.residentItemsVisibleCount + this.recentItemsVisibleCount + this.collaborationItemsVisibleCount;
  }

  public updateRegionLayoutLength(region: DockRegionType, num: number): void {
    switch (region) {
      case DockRegionType.RESIDENT:
        this.residentItemsVisibleCount = num;
        break;
      case DockRegionType.RECENT:
        this.recentItemsVisibleCount = num;
        break;
      case DockRegionType.COLLABORATION:
        this.collaborationItemsVisibleCount = num;
        break;
      default:
        log.showWarn('dock region type is illegal');
    }
  }

  public getRegionLayoutLength(region: DockRegionType): number {
    switch (region) {
      case DockRegionType.RESIDENT:
        return this.residentItemsVisibleCount;
      case DockRegionType.RECENT:
        return this.recentItemsVisibleCount;
      case DockRegionType.COLLABORATION:
        return this.collaborationItemsVisibleCount;
      default:
        log.showWarn('dock region type is illegal');
    }
    return 0;
  }

  public updateRegionLayoutWidth(region: DockRegionType, layoutWidth: number): void {
    this.regionLayoutWidths.set(region, layoutWidth);
  }

  public getRegionLayoutWidth(region: DockRegionType): number {
    return this.regionLayoutWidths.get(region) ?? 0;
  }

  public getSpace(num: number): number {
    if (num === 0) {
      return 0;
    }
    return this.mSmartDockStyleConfig.mListItemGap;
  }

  public getListPadding(num?: number): number {
    return this.mSmartDockStyleConfig.mDockPadding;
  }

  public getSmallFolderIconSize(): number {
    return DEFAULT_APP_ICON_WIDTH;
  }

  public getListItemWidth(): number {
    return this.mSmartDockStyleConfig.mListItemWidth;
  }

  public getListItemHeight(): number {
    return this.mSmartDockStyleConfig.mListItemHeight;
  }

  public getDividerWidth(): number {
    return StyleConstants.DEFAULT_20;
  }

  public getIconSize(): number {
    return this.mSmartDockStyleConfig.mIconSize;
  }

  public getIconRadius(): number {
    return this.mSmartDockStyleConfig.mIconRadius;
  }

  public getDockHeight(): number {
    return this.mSmartDockStyleConfig.mDockHeight;
  }

  public getDockRadius(): number {
    return this.mSmartDockStyleConfig.mDockRadius;
  }

  /**
   * calculate region width by region items count
   *
   * @param num  region items count
   * @param regionType  region type
   * @returns  region width
   */
  public calculateRegionWidth(num: number, regionType?: DockRegionType): number {
    if (num <= 0) {
      return 0;
    }
    return this.getListPadding(num) * 2 + num * this.getListItemWidth() + (num - 1) * this.getSpace(num);
  }

  public calculateScale(): number {
    return this.iconScale;
  }

  public getDividerHeight(): number {
    return StyleConstants.DEFAULT_24;
  }

  public setScale(scale: number): void {
    this.iconScale = scale;
  }

  public getScale(): number {
    return this.iconScale;
  }

  public getSimpleModeMarginTop(): number {
    if (launcherStatusUtil.getSimpleModeStatus()) {
      return this.mSmartDockStyleConfig.simpleModeMarginTop;
    }
    return 0;
  }

  /**
   * calculate region width by resident items count
   * for dock drag scene,resident visible items count is not equal to resident items count
   */
  public calculateScaleWithRegionNum(num: number, region: DockRegionType = DockRegionType.RESIDENT): number {
    return this.iconScale;
  }

  /**
   * calculate region width with divider width
   * use no-zoomed width
   */
  public calculateLayoutWidth(region: DockRegionType, num?: number): number {
    if (this.getRegionLayoutLength(region) === 0 && !num) {
      return 0;
    }
    let layoutWidth = 2 * this.getListPadding() +
      this.getRegionLayoutLength(region) * (this.getIconSize() + this.getSpace(1)) - this.getSpace(1);
    if (!!num) {
      layoutWidth = 2 * this.getListPadding() +
        num * (this.getIconSize() + this.getSpace(num)) - this.getSpace(num);
    }
    if (region !== DockRegionType.RESIDENT) {
      layoutWidth += this.getDividerWidth();
    }
    return layoutWidth;
  }

  /**
   * calculate region width by resident items count and scale
   *
   * @param num  region items count
   * @returns  region width
   */
  public calculateRegionWidthWithScale(num: number): number {
    if (num <= 0) {
      return 0;
    }
    return this.calculateRegionWidth(num) * this.iconScale;
  }
}

export class PhoneDockRegionLayoutModel extends DockRegionLayoutModel {
  private static instance: DockRegionLayoutModel;

  constructor() {
    super();
  }

  public static getInstance(): DockRegionLayoutModel {
    if (!PhoneDockRegionLayoutModel.instance) {
      log.showInfo('init PhoneDockRegionLayoutModel!');
      PhoneDockRegionLayoutModel.instance = new PhoneDockRegionLayoutModel();
    }
    return PhoneDockRegionLayoutModel.instance;
  }

  public getDividerWidth(): number {
    let dividerWidth = this.mSmartDockStyleConfig.mResidentSplitLineWidth +
      this.mSmartDockStyleConfig.mResidentSplitLineGap * 2;
    let desktopIconChangeSize: number | undefined = AppStorage.get<number>('settingIconChange');
    if (desktopIconChangeSize !== undefined && desktopIconChangeSize <= 0) {
      dividerWidth -= desktopIconChangeSize;
    }
    if (Number.isNaN(dividerWidth)) {
      return StyleConstants.DEFAULT_20;
    }
    return dividerWidth;
  }

  public getSpace(num: number): number {
    if (num <= this.mSmartDockStyleConfig.mMaxDockNum) {
      return this.mSmartDockStyleConfig.mListItemGap;
    }
    const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    const maxDockNum: number = this.mSmartDockStyleConfig.mMaxDockNum;
    const padding: number = (screenWidth - (maxDockNum * this.mSmartDockStyleConfig.mListItemWidth +
      (maxDockNum - 1) * this.mSmartDockStyleConfig.mListItemGap));
    return (screenWidth - padding - (maxDockNum + 1) * this.mSmartDockStyleConfig.mListItemWidth) / maxDockNum;
  }

  public getListPadding(num: number): number {
    if (desktopUtil.isFoldExpandStatus()) {
      return super.getListPadding();
    }
    const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let maxNum = num > this.mSmartDockStyleConfig.mMaxDockNum ? this.mSmartDockStyleConfig.mMaxDockNum : num;
    return (screenWidth -
      (maxNum * this.mSmartDockStyleConfig.mListItemWidth + (maxNum - 1) * this.mSmartDockStyleConfig.mListItemGap)) /
      2;
  }
}

export class PadDockRegionLayoutModel extends DockRegionLayoutModel {
  private static instance: DockRegionLayoutModel;

  constructor() {
    super();
  }

  public static getInstance(): DockRegionLayoutModel {
    if (PadDockRegionLayoutModel.instance == null) {
      log.showInfo('init PadDockRegionLayoutModel!');
      PadDockRegionLayoutModel.instance = new PadDockRegionLayoutModel();
    }
    return PadDockRegionLayoutModel.instance;
  }

  public getSpace(size: number): number {
    if (!SmartDockZoomFeatureSwitch.isSupportZoom()) {
      return Math.max(this.mSmartDockStyleConfig.mListItemGap, this.mSmartDockStyleConfig.mDockPadding + 1);
    }
    return this.iconScale * this.mSmartDockStyleConfig.mListItemGap;
  }

  public getDividerHeight(): number {
    return this.iconScale * StyleConstants.DEFAULT_24;
  }

  getIconSize(): number {
    return this.iconScale * super.getIconSize();
  }

  getDividerWidth(): number {
    return this.iconScale * super.getDividerWidth();
  }

  getIconRadius(): number {
    return this.iconScale * super.getIconRadius();
  }

  getListItemWidth(): number {
    return this.iconScale * super.getListItemWidth();
  }

  getListItemHeight(): number {
    return this.iconScale * super.getListItemHeight();
  }

  getDockHeight(): number {
    return this.iconScale * super.getDockHeight();
  }

  public getSmallFolderIconSize(): number {
    return this.iconScale * super.getSmallFolderIconSize();
  }

  getDockRadius(): number {
    return this.iconScale * super.getDockRadius();
  }

  public getListPadding(num?: number | undefined): number {
    return this.iconScale * super.getListPadding();
  }

  public calculateScale(): number {
    if (!SmartDockZoomFeatureSwitch.isSupportZoom()) {
      return 1;
    } else {
      const safeScreenWidth: number = AppStorage.get<number>('screenWidth') as number - SAFE_SCREEN_SPACE * 2;
      const residentWidth: number = this.calculateRegionWidth(this.residentItemsVisibleCount);
      let recentWidth: number = 0;
      let cooperationWidth: number = 0;

      let dockWidth = residentWidth;
      if (this.recentItemsVisibleCount > 0) {
        recentWidth = this.calculateRegionWidth(this.recentItemsVisibleCount, DockRegionType.RECENT);
        dockWidth += recentWidth + super.getDividerWidth();
      }
      if (this.collaborationItemsVisibleCount > 0) {
        cooperationWidth = this.calculateRegionWidth(this.collaborationItemsVisibleCount);
        dockWidth += cooperationWidth + super.getDividerWidth();
      }

      let rawScale = safeScreenWidth / dockWidth;
      const iconSize = super.getIconSize();
      let floorIconSize = this.downToEven(iconSize * rawScale);
      let fixedScale = this.scaleFilter(floorIconSize / iconSize);
      return fixedScale;
    }
  }

  private scaleFilter(scale: number): number {
    if (scale > 1) {
      log.showWarn('scale is bigger than 1,please check');
      return 1;
    }
    if (scale < 0.1) {
      log.showWarn('scale is too small, scale: %{public}d', scale);
      return 1;
    }
    return scale;
  }

  /**
   * calculate region width by region items count
   *
   * @param num  region items count
   * @param regionType  region type
   * @returns  region width
   */
  public calculateRegionWidth(num: number, regionType?: DockRegionType): number {
    if (num <= 0) {
      return 0;
    }
    if (!SmartDockZoomFeatureSwitch.isSupportZoom()) {
      return super.getListPadding() * 2 + num * super.getListItemWidth() + (num - 1) * this.getSpace(num);
    }
    if (SCBSceneSessionManager.getInstance().isPcMode() && regionType === DockRegionType.RECENT) {
      let width = 0;
      if (num > this.mSmartDockStyleConfig.mRecentDockMaxNumber) {
        width = this.mSmartDockStyleConfig.mRecentDockMaxNumber * this.mSmartDockStyleConfig.mListItemWidth +
          (this.mSmartDockStyleConfig.mRecentDockMaxNumber - 1) * this.mSmartDockStyleConfig.mListItemGap + 2 *
        StyleConstants.DEFAULT_32 + 4 * StyleConstants.DEFAULT_12;
      } else {
        width = num * this.mSmartDockStyleConfig.mListItemWidth + (num - 1) * this.mSmartDockStyleConfig.mListItemGap +
          2 * StyleConstants.DEFAULT_12;
      }
      return width;
    }
    return super.getListPadding() * 2 + num * super.getListItemWidth() + (num - 1) * super.getSpace(num);
  }

  public calculateScaleWithRegionNum(num: number, region: DockRegionType = DockRegionType.RESIDENT): number {
    const numCopy = this.getRegionLayoutLength(region);
    this.updateRegionLayoutLength(region, num);
    const scale = this.calculateScale();
    this.updateRegionLayoutLength(region, numCopy);
    return scale;
  }

  // rounding down even
  private downToEven(num: number): number {
    let res = Math.floor(num / 2);
    return res << 1;
  }

  public calculateLayoutWidth(region: DockRegionType, num?: number): number {
    if (this.getRegionLayoutLength(region) === 0 && !num) {
      return 0;
    }
    let layoutWidth = 2 * super.getListPadding() +
      super.getRegionLayoutLength(region) * (super.getIconSize() + super.getSpace(1)) - super.getSpace(1);
    if (!!num) {
      layoutWidth = 2 * super.getListPadding() +
        num * (super.getIconSize() + super.getSpace(num)) - super.getSpace(num);
    }
    if (region !== DockRegionType.RESIDENT) {
      layoutWidth += super.getDividerWidth();
    }
    return layoutWidth;
  }
}