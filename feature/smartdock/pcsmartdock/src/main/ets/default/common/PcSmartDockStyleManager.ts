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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HashMap } from '@kit.ArkTS';
import { LayoutViewModel } from '@ohos/launchercommon';
import { SCBScreenProperty } from '@ohos/windowscene';
import { UIContext } from '@ohos.arkui.UIContext';

const TAG: string = 'PcSmartDockStyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);
const COMMON_DOCK_HEIGHT: number = 49;
const SPECIAL_DOCK_HEIGHT: number = 39;
const DEFAULT_DOCK_HEIGHT: number = 66;

export class PcSmartDockStyleManager {
  private static mConfigMap: HashMap<string, PcDockStyleConfig> = new HashMap<string, PcDockStyleConfig>();

  public static getStyle(screenProp: SCBScreenProperty): PcDockStyleConfig {
    let tag: string = screenProp.rsId + 'screenW:' + screenProp.width + 'screenH:' + screenProp.height;
    let config: PcDockStyleConfig = PcSmartDockStyleManager.mConfigMap.get(tag);
    if (CheckEmptyUtils.isEmpty(config)) {
      config = new PcDockStyleConfig();
      config.updateConfig(screenProp);
      PcSmartDockStyleManager.mConfigMap.set(tag, config);
      log.showInfo(`PcSmartDockStyleManager screenId:${screenProp.screenId} rsID:${screenProp.rsId}`);
      log.showInfo(`PcSmartDockStyleManager getStyle:${config.toLogString()}`);
    }
    return config;
  }

}

 export class PcDockStyleConfig {

  public mRatio: number = 1;
  /**
   * dock list hight
   */
  public mDockHeight: number = 66;

  /**
   * dock list background color
   */
   public mBackgroundColor: string = '#B8FAFAFA';

  /**
   * dock list border radius
   */
   public mDockRadius: number = 24;

  /**
   * dock list background blur
   */
   public mBackdropBlur: number = 0;

  /**
   * dock background saturation
   */
   public mBackSaturation: number = 0;

  /**
   * dock list padding
   */
   public mDockPadding: number = 9;

  /**
   * dock list margin
   */
   public mDockMargin: number = 10;

  /**
   * dock list item width
   */
   public mListItemWidth: number = 60;

  /**
   * dock list item height
   */
   public mListItemHeight: number = 60;

  /**
   * dock list item gap
   */
   public mListItemGap: number = 2;

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
   public mIconSize: number = 40;

  /**
   * dock list item padding
   */
   public mItemPadding: number = 3;

  /**
   * dock left and right item padding extra width, only use in pad
   */
   public mPaddingExtraWidth: number = 2;

  /**
   * dock list item background color
   */
   public mItemBackgroundColor: string = '';

  /**
   * dock list item border radius
   */
   public mItemBorderRadius: number = 0;

  /**
   *  gap between resident dock and recent dock
   */
   public mDockGap: number = 12;

  /**
   * resident dock max item number
   */
   public mMaxDockNum: number = 16;

  /**
   * recent dock max item number
   */
   public mMaxRecentNum: number = 3;

  /**
   * sum dock max number
   */
   public mMaxNum: number = 19;

  /**
   * min resident num
   */
   public mMinResidentNum: number = 2;

  /**
   * dock bottom margin
   */
   public mMarginBottom: number = 24;

  /**
   * resident split line width of dock, only use in pc and pad
   */
   public mResidentSplitLineWidth: number = 0;

  /**
   * resident split line height of dock, only use in pc and pad
   */
   public mResidentSplitLineHeight: number = 0;

  /**
   * resident split line color of dock, only use in pc and pad
   */
   public mResidentSplitLineColor: string = '#33FFFFFF';

  /**
   * resident split line gap of dock, only use in pc and pad
   */
   public mResidentSplitLineGap: number = 0;

  /**
   * recent arrow width of dock, only use in pc and pad
   */
   public mRecentArrowWidth: number = 0;

  /**
   * recent arrow height of dock, only use in pc and pad
   */
   public mRecentArrowHeight: number = 0;

  /**
   * recent arrow padding of dock, only use in pc and pad
   */
   public mRecentArrowPadding: number = 0;

  /**
   * recent arrow gap of dock, only use in pc and pad
   */
   public mRecentArrowGap: number = 0;

  /**
   * recent dock max number for phone and pad
   */
   public mRecentDockMaxNumber: number = 4;

  /**
   * Icon radius
   */
   public mIconRadius: number = 14;

  /**
   * Preview icon radius
   */
   public mIconRadiusPreview: number = 14;

  /**
   * dock backplane padding
   */
   public mBackPlanePadding: number = 12;

  /**
   * fixed dock max total num
   */
   public mFixedMaxNum: number = 26;

  /**
   * screen width
   */
   public mScreenWidth = 3120;

  /**
   * screen height
   */
   public mScreenHeight = 2080;

  /**
   * toggle home width
   */
   public mToggleHomeWidth: number = 8;

  /**
   * toggle home divider width
   */
   public mToggleHomeDividerWidth: number = 1;


  public updateConfig(screenProp: SCBScreenProperty): number {
    if (screenProp.rsId === 0 || screenProp.rsId === undefined) {
      return this.mainPhysicalScreenUpdate(screenProp);
    } else {
      return this.externalPhysicalScreenUpdate(screenProp);
    }
  }
  
  public updateConfigUiContext(ctx: UIContext, screenProp: SCBScreenProperty): void {
    if (!CheckEmptyUtils.isEmpty(ctx)) {
      this.mScreenWidth = ctx.px2vp(screenProp.width);
      this.mScreenHeight = ctx.px2vp(screenProp.height);
    }
  }

  public toLogString(): string {
    return 'mDockHeight:' + this.mDockHeight + ' mIconSize:' + this.mIconSize +
      ' mListItemWidth:' + this.mListItemWidth;
  }

  /**
   * 主显示器上布局信息更新
   */
  private mainPhysicalScreenUpdate(screenProp: SCBScreenProperty): number {
    const result = LayoutViewModel.getInstance().calculateDock();
    this.mDockGap = result.mDockGap as number;
    this.mDockRadius = result.mDockRadius as number;
    this.mIconSize = result.mIconSize as number;
    this.mBackgroundColor = result.mBackgroundColor as string;
    this.mBackdropBlur = result.mBackdropBlur as number;
    this.mBackSaturation = result.mBackSaturation as number;
    this.mListItemWidth = result.mListItemWidth as number;
    this.mListItemHeight = result.mListItemHeight as number;
    this.mListItemGap = result.mListItemGap as number;
    this.mDockPadding = result.mDockPadding as number;
    this.mMaxRecentNum = result.mMaxRecentNum as number;
    this.mMaxDockNum = result.mMaxDockNum as number + 1;
    this.mDockHeight = result.mDockHeight as number;
    this.mMarginBottom = result.mMarginBottom as number;
    this.mMaxNum = result.mMaxNum as number;
    this.mMinResidentNum = result.mMinResidentNum as number;
    this.mResidentSplitLineWidth = result.mResidentSplitLineWidth as number;
    this.mResidentSplitLineHeight = result.mResidentSplitLineHeight as number;
    this.mResidentSplitLineColor = result.mResidentSplitLineColor as string;
    this.mResidentSplitLineGap = result.mResidentSplitLineGap as number;
    this.mRecentArrowWidth = result.mRecentArrowWidth as number;
    this.mRecentArrowHeight = result.mRecentArrowHeight as number;
    this.mRecentArrowPadding = result.mRecentArrowPadding as number;
    this.mRecentArrowGap = result.mRecentArrowGap as number;

    this.mScreenWidth = LayoutViewModel.getInstance().getScreenWidth();
    this.mScreenHeight = LayoutViewModel.getInstance().getScreenHeight();
    this.mRatio = 1;
    return 1;
  }

  /**
   * 外接显示器上的布局信息更新
   */
  private externalPhysicalScreenUpdate(screenProp: SCBScreenProperty): number {
    const result = LayoutViewModel.getInstance().calculateDock();
    const baseDockHeight = (result.mDockHeight !== undefined && result.mDockHeight !== 0) ?
        result.mDockHeight : DEFAULT_DOCK_HEIGHT;
    if (screenProp.height <= 0) {
      return 1;
    }
    let dockHeight = screenProp.width / screenProp.height >= 2 ? SPECIAL_DOCK_HEIGHT : COMMON_DOCK_HEIGHT;
    let ratio = dockHeight / baseDockHeight;
    this.mDockGap = result.mDockGap as number * ratio;
    this.mDockRadius = result.mDockRadius as number * ratio;
    this.mIconSize = result.mIconSize as number * ratio;
    this.mBackgroundColor = result.mBackgroundColor as string;
    this.mBackdropBlur = result.mBackdropBlur as number;
    this.mBackSaturation = result.mBackSaturation as number;
    this.mListItemWidth = result.mListItemWidth as number * ratio;
    this.mListItemHeight = result.mListItemHeight as number * ratio;
    this.mListItemGap = result.mListItemGap as number * ratio;
    this.mDockPadding = result.mDockPadding as number * ratio;
    this.mMaxRecentNum = result.mMaxRecentNum as number;
    this.mMaxDockNum = result.mMaxDockNum as number + 1;
    this.mDockHeight = dockHeight;
    this.mMarginBottom = result.mMarginBottom as number;
    this.mMaxNum = result.mMaxNum as number;
    this.mMinResidentNum = result.mMinResidentNum as number;
    this.mResidentSplitLineWidth = result.mResidentSplitLineWidth as number;
    this.mResidentSplitLineHeight = result.mResidentSplitLineHeight as number;
    this.mResidentSplitLineColor = result.mResidentSplitLineColor as string;
    this.mResidentSplitLineGap = result.mResidentSplitLineGap as number;
    this.mRecentArrowWidth = result.mRecentArrowWidth as number * ratio;
    this.mRecentArrowHeight = result.mRecentArrowHeight as number * ratio;
    this.mRecentArrowPadding = result.mRecentArrowPadding as number;
    this.mRecentArrowGap = result.mRecentArrowGap as number * ratio;

    this.mScreenWidth = LayoutViewModel.getInstance().getScreenWidth();
    this.mScreenHeight = LayoutViewModel.getInstance().getScreenHeight();
    this.mRatio = ratio;
    return ratio;
  }
}