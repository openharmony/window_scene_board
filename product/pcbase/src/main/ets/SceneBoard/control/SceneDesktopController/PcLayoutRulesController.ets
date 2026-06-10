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

import { LogHelper, LogDomain, UIContextHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  CalculateAppCenterRst,
  GridLayoutUtil,
  LayoutRulesController,
  PresetStyleConstants,
  SettingsModel,
  StyleConstants
} from '@ohos/launchercommon';
import type {
  BaseConfig,
  CalculateFormRst,
  CalculateDockRst,
  CalculateDesktopRst,
} from '@ohos/launchercommon';
import { LayoutViewModel } from '@ohos/launchercommon';
import type ctx from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';
import { PCUtils } from '../../../common/utils/PCUtils';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import PcPresetStyleConstants from '../../../common/constants/PcPresentConstants';

const TAG = 'PcLayoutRulesControllers';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Layout rules controller of PC
 * PC端布局规则控制器，适用于桌面新布局
 * PC与手机的差异化逻辑请放在此类中
 */
export class PcLayoutRulesController extends LayoutRulesController {
  public static singleName: string = 'PcLayoutRulesController';

  private columnNumOfGrid?: number = 0;

  private rowNumOfGrid?: number = 0;

  public resultMap: Map<number, CalculateAppCenterRst> = new Map<number, CalculateAppCenterRst>();

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  toString(): String {
    return TAG;
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): PcLayoutRulesController {
    let instance = singleManager.get<PcLayoutRulesController>(PcLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    log.showInfo(`${PcLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    log.showInfo('calculateForm start');
    let iconSize = this.mLauncherLayoutStyleConfig.mAppBubbleIconSize;
    let gridRow = SettingsModel.getInstance().getGridConfig().row;
    let gridColumn = SettingsModel.getInstance().getGridConfig().column;
    let minGutter = this.mLauncherLayoutStyleConfig.mGridGutter;
    let gridRealWidth = gridColumn * this.mBaseConfig.getItemSize();
    let userWidth = (gridColumn * this.mBaseConfig.getItemSize() + minGutter -
      (this.mBaseConfig.getItemSize() + minGutter) * gridColumn);

    let gap = (userWidth / (gridColumn - 1)) + minGutter -
      StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mItemPadding;
    let gridRealHeight = (this.mBaseConfig.getItemSize() + gap) * gridRow - gap +
      StyleConstants.DEFAULT_2 * this.mLauncherLayoutStyleConfig.mItemPadding;
    let folderSize = (gridRealHeight + gap) / gridRow + iconSize;
    let widthDimension1: number = folderSize;
    let heightDimension1: number = iconSize;
    let widthDimension2 = folderSize;
    let heightDimension2 = folderSize;
    let widthDimension3 =
      (gridRealWidth + gap) / gridColumn * StyleConstants.DEFAULT_3 + iconSize +
      StyleConstants.DEFAULT_3;
    let heightDimension3 = folderSize;
    let widthDimension4 = widthDimension3;
    let heightDimension4 = (gridRealHeight + gap) / gridRow * StyleConstants.DEFAULT_3 + iconSize;
    let widthDimension5: number = widthDimension3;
    let heightDimension5: number =
      (gridRealHeight + gap) / gridRow * StyleConstants.DEFAULT_5 + iconSize;
    let result: CalculateFormRst = {
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mLauncherLayoutStyleConfig.mIconMarginTOP,
      widthDimension5: widthDimension5,
      heightDimension5: heightDimension5
    };
    return result;
  }

  calculateDock(): CalculateDockRst {
    let result = super.calculateDock();
    let margin = this.mLauncherLayoutStyleConfig.mDockSaveMargin;
    result.mResidentSplitLineHeight = Number(result?.mDockHeight ?? 0) / 2;
    let dockSpaceWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * margin;
    AppStorage.setOrCreate('dockSpaceWidth', dockSpaceWidth);
    return result;
  }

  recalculateMaxNum(result: CalculateDockRst, dockSpaceWidth: number): void {
    let dockGap = this.mLauncherLayoutStyleConfig.mDockGutter;
    let iconSize = this.mLauncherLayoutStyleConfig.mDockIconSize;
    let listItemGap = this.mLauncherLayoutStyleConfig.mDockItemGap;
    let dockPadding = this.mLauncherLayoutStyleConfig.mDockPadding;
    let maxRecentNum = this.mLauncherLayoutStyleConfig.mDockMaxRecentNumber;
    let residentSplitLineWidth = this.mLauncherLayoutStyleConfig.mDockResidentSplitLineWidth;
    let residentSplitLineGap = this.mLauncherLayoutStyleConfig.mDockResidentSplitLineGap;

    //Calculate the resident  and recent area. For PC
    //dockGap means the gap between resident and recent
    //dockPadding the padding of resident and recent
    //residentSplitLineWidth the width of the residentSplitLine
    //residentSplitLineGap  the Left and right sides gap of residentSplitLine
    //listItemGap the gap of ListItem
    result.mMaxNum = ~~((dockSpaceWidth - dockGap - StyleConstants.DEFAULT_2 * dockPadding -
      residentSplitLineWidth - StyleConstants.DEFAULT_2 * residentSplitLineGap - listItemGap) /
      (iconSize + listItemGap));
    result.mMaxDockNum = result.mMaxNum - maxRecentNum;
  }

  /**
   * calculate desktop
   */
  calculateDesktop(): CalculateDesktopRst {
    this.mLauncherLayoutStyleConfig.mMarginTop = PcPresetStyleConstants.WIN_STYLE_HAD_DEFAULT_WORK_SPACE_TOP;
    this.mLauncherLayoutStyleConfig.mWorkSpacePaddingTop =
      GridLayoutUtil.getFloorVp(PcPresetStyleConstants.WIN_STYLE_HAD_DEFAULT_WORK_SPACE_TOP);
    let itemPadding = this.mBaseConfig.getItemPadding();
    let realWidth =
      this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * PcPresetStyleConstants.DEFAULT_MDPI_MIN_MARGIN;
    let realHeight = this.mBaseConfig.getWorkSpaceHeight() - PcPresetStyleConstants.HAD_DEFAULT_MDPI_MARGIN_TOP -
      PcPresetStyleConstants.HAD_DEFAULT_MDPI_MARGIN_BOTTOM;
    const itemSize = this.mBaseConfig.getItemSize();
    const column = Math.floor(realWidth / itemSize);
    const row = Math.floor(realHeight / itemSize);
    realHeight = itemSize * row;
    realWidth = itemSize * column;
    this.mBaseConfig.setGridRealHeight(realHeight);
    let iconMarginVertical = this.mLauncherLayoutStyleConfig.mIconMarginTOP;
    let iconMarginHorizontal =
      (itemSize - this.mLauncherLayoutStyleConfig.mAppBubbleIconSize) / StyleConstants.DEFAULT_2;
    log.showInfo(`calculateDesktop realHeight:${realHeight}, itemSize:${itemSize}, row ${row}, column ${column},
      workspaceHeight:${this.mBaseConfig.getWorkSpaceHeight()},
      indicatorHeight:${this.mBaseConfig.getIndicatorHeight()},
      sysUIHeight:${this.mBaseConfig.getSysUITopHeight()},
      realHeight: ${realHeight},
      mWorkSpacePaddingTop: ${this.mLauncherLayoutStyleConfig.mWorkSpacePaddingTop}`);
    this.updateGrid(row, column);
    this.columnNumOfGrid = column;
    this.rowNumOfGrid = row;
    iconMarginHorizontal = (itemSize - this.mLauncherLayoutStyleConfig.mIconBackgroundSize) / StyleConstants.DEFAULT_2;
    this.mLauncherLayoutStyleConfig.mMargin = (this.mBaseConfig.getScreenWidth() - realWidth) / 2;
    let result: CalculateDesktopRst = {
      mMargin: this.mLauncherLayoutStyleConfig.mMargin,
      mItemPadding: itemPadding,
      mColumnsGap: this.mLauncherLayoutStyleConfig.mGridGutter,
      mRowsGap: this.mLauncherLayoutStyleConfig.mGridGutter,
      mColumns: column,
      mRows: row,
      mDesktopMarginTop: this.mLauncherLayoutStyleConfig.mMarginTop,
      mWorkSpacePaddingTop: this.mLauncherLayoutStyleConfig.mWorkSpacePaddingTop,
      mWorkSpacePaddingBottom: Math.max(StyleConstants.DEFAULT_8, this.mBaseConfig.getWorkSpaceHeight() -
      LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight() - realHeight -
      this.mLauncherLayoutStyleConfig.mWorkSpacePaddingTop),
      mGridWidth: realWidth,
      mGridHeight: realHeight,
      mWorkSpaceWidth: this.mBaseConfig.getScreenWidth(),
      mWorkSpaceHeight: this.mBaseConfig.getWorkSpaceHeight() -
      LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight(),
      mAppItemSize: itemSize,
      mNameSize: this.mLauncherLayoutStyleConfig.mNameSize,
      mNameHeight: this.mBaseConfig.getNameHeight(),
      mNameWidth: this.mLauncherLayoutStyleConfig.mNameWidth,
      mIconNameMargin: this.mLauncherLayoutStyleConfig.mIconNameGap,
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      mIconSize: this.mLauncherLayoutStyleConfig.mAppBubbleIconSize,
      mNameLines: this.mLauncherLayoutStyleConfig.mNameLines,
      mIconMarginHorizontal: iconMarginHorizontal,
      mIconMarginVertical: iconMarginVertical
    };
    this.saveLayoutToPreferences();
    return result;
  }

  protected saveLayoutToPreferences(): void {
    // save cur layout to preferences
    if (this.mBaseConfig.getScreenWidth() !== 0 && this.mBaseConfig.getScreenHeight() !== 0) {
      try {
        preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'DESKTOP_LAYOUT_INFO').then((preference) => {
          preference.putSync('column', this.columnNumOfGrid);
          preference.putSync('row', this.rowNumOfGrid);
          log.showInfo(TAG, `calculateDesktop column: ${this.columnNumOfGrid}, row: ${this.rowNumOfGrid}`);
          preference.flush();
        });
      } catch (error) {
        log.showError(`PcLayoutRulesController getPreferences error, code: ${error?.code}, message: ${error?.message}`);
      }
    }
  }

  /**
   * calculate app center
   *
   * @screenId 屏幕id
   * @isChange 是否是屏幕分辨率等发生变化需要重新计算
   */
  public calculateAppCenter(screenId: number = 0, isRefresh: boolean = false,
    width?: number, height?: number): CalculateAppCenterRst {
    let result = new CalculateAppCenterRst();
    if (!this.resultMap) {
      log.showInfo('undefined result');
      this.resultMap = new Map<number, CalculateAppCenterRst>();
    }
    const hasResult: boolean = this.resultMap.has(screenId)
    if (isRefresh || !hasResult) {
      result.mAppItemSize = this.mLauncherLayoutStyleConfig.mAppCenterSize;
      result.mAppCenterSizeWidth = this.mLauncherLayoutStyleConfig.mAppCenterSizeWidth;
      result.mAppCenterSizeHeight = this.mLauncherLayoutStyleConfig.mAppCenterSizeHeight;
      result.mAppCenterItemWidth = this.mLauncherLayoutStyleConfig.mAppCenterItemWidth;
      result.mAppCenterItemHeight = this.mLauncherLayoutStyleConfig.mAppCenterItemHeight;
      result.mIconSize = this.mLauncherLayoutStyleConfig.mAppCenterIconSize;
      result.mAppCenterBubbleMarginTop = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginTop;
      result.mAppCenterBubbleMarginBottom = this.mLauncherLayoutStyleConfig.mAppCenterBubbleMarginBottom;
      result.mIconRadius = this.mLauncherLayoutStyleConfig.mAppCenterIconRadius;

      let screenWidth = this.mBaseConfig.getScreenWidth();
      let screenHeight = this.mBaseConfig.getScreenHeight();
      if (screenId !== 0) {
        screenWidth = UIContextHelper.px2vp(screenId, width);
        screenHeight = UIContextHelper.px2vp(screenId, height);
      }
      // 判断屏幕高宽比，如果不是3:2，按屏幕宽度：屏幕高度 = 3:2 计算宽度 => 屏幕宽度 = 屏幕高度 * 3 / 2
      let screenAspectRatio = Math.abs(screenWidth / screenHeight - StyleConstants.APP_CENTER_ASPECT_RATIO);
      let orgScreeWidth: number = screenWidth;
      if (screenAspectRatio > StyleConstants.APP_CENTER_ASPECT_RATIO_ERROR_RANGE) {
        screenWidth = screenHeight * StyleConstants.APP_CENTER_ASPECT_RATIO;
        log.showInfo(`calculateAppCenter-non-fold-device-${this.mBaseConfig.getScreenWidth()}-${screenWidth} ${screenHeight}`);
      }
      this.calculateAppCenterGrid(result, screenWidth, screenHeight);
      this.proportionalScaling(result);
      this.calculateAppCenterMargin(result, orgScreeWidth, screenHeight);
      this.calculateAppCenterItem(result);
      log.showInfo(`calculateAppCenter columns=${result.mColumns},rows=${result.mRows}, width:${result.mGridWidth}, mColumnsGap: ${result.mColumnsGap} mRowsGap: ${result.mRowsGap}
    appCenterItemWidth:${result.mAppCenterItemWidth}   appCenterItemHeight:${result.mAppCenterItemHeight} this.mBaseConfig.getScreenWidth()：${this.mBaseConfig.getScreenWidth()}`);
      log.showInfo(`calculateAppCenter appCenterMarginLeft=${result.mAppCenterMarginLeft},getScreenHeight:${this.mBaseConfig.getScreenHeight()}
    getWorkSpaceHeight:${this.mBaseConfig.getWorkSpaceHeight()} vp2px: ${UIContextHelper.vp2px(screenId, 1)}`);
      log.showInfo(`isChange or create result: ${result}, screenId: ${screenId}`);
      this.resultMap.set(screenId, result);
      return result;
    } else {
      result = this.resultMap.get(screenId) as CalculateAppCenterRst;
      log.showInfo(`has result: ${this.resultMap.get(screenId)}, screenId: ${screenId}`);
      return result;
    }
  }

  /**
   * 计算应用中心图标参数
   * @param result
   */
  protected calculateAppCenterItem(result: CalculateAppCenterRst): void {
    let ratio = this.mLauncherLayoutStyleConfig.mAppCenterRatio;
    result.mNameLines = this.mLauncherLayoutStyleConfig.mAppCenterNameLines;
    result.mNameHeight = result.mNameLines * Number(result?.mNameSize ?? 0);
    result.mNameWidth = this.mLauncherLayoutStyleConfig.mAppCenterNameWidth;
    result.mIconMarginVertical = ratio * Number(result?.mIconSize ?? 0);
    result.mIndicatorBottom = PresetStyleConstants.DEFAULT_INDICATOR_MARGIN_TOP;
  }

  /**
   * 计算应用中心间距参数
   * @param result 结果集
   */
  private calculateAppCenterMargin(result: CalculateAppCenterRst, screenWidth: number, screenHeight: number): void {
    // (screenWidth - itemWidth * column - colGap * column) / 2
    result.mAppCenterMarginLeft =
      Math.round(screenWidth - Number(result?.mGridWidth ?? 0) + Number(result?.mColumnsGap ?? 0)) /
      StyleConstants.DEFAULT_2;
    result.mAppCenterMarginRight = result.mAppCenterMarginLeft;

    // 宫格在最大宫格内居中，marginTop/marginBottom = (屏幕高度 - 上下安全距离 - 宫格高度 + dock高度) / 2 + top/Bottom
    result.mAppCenterMarginTop = (screenHeight - this.mLauncherLayoutStyleConfig.mAppCenterMarginBottom -
    this.mLauncherLayoutStyleConfig.mAppCenterMarginTop - Number(result?.mGridHeight ?? 0) -
    this.mBaseConfig.getDockHeight()) / StyleConstants.DEFAULT_2 +
    this.mLauncherLayoutStyleConfig.mAppCenterMarginTop + Number(result?.mRowsGap ?? 0) / StyleConstants.DEFAULT_2;

    result.mAppCenterMarginBottom = (screenHeight - this.mLauncherLayoutStyleConfig.mAppCenterMarginBottom -
    this.mLauncherLayoutStyleConfig.mAppCenterMarginTop - Number(result?.mGridHeight ?? 0) -
    this.mBaseConfig.getDockHeight()) / StyleConstants.DEFAULT_2 +
    this.mLauncherLayoutStyleConfig.mAppCenterMarginBottom + Number(result?.mRowsGap ?? 0) / StyleConstants.DEFAULT_2;

    result.mPadding = Number((result?.mGridHeight ?? 0) -
      Number(result?.mRows ?? 0) * Number((result?.mAppCenterItemHeight ?? 0) + Number(result?.mRowsGap ?? 0)) +
      Number(result?.mRowsGap ?? 0)) / StyleConstants.DEFAULT_2;
  }

  /**
   * 计算应用中心宫格布局
   * @param result 结果集
   * @param screenHeight 屏幕高度
   * @param screenWidth 屏幕宽度
   */
  private calculateAppCenterGrid(result: CalculateAppCenterRst, screenWidth: number, screenHeight: number): void {
    // 计算宫格高度和宽度
    result.mGridWidth = screenWidth * StyleConstants.APP_CENTER_GRID_WIDTH_RATIO;
    result.mGridHeight = result.mGridWidth * StyleConstants.APP_CENTER_GRID_HEIGHT_RATIO;
    result.mColumns = this.mLauncherLayoutStyleConfig.mAppCenterColNum;
    result.mRows = this.mLauncherLayoutStyleConfig.mAppCenterRowNum;

    // 判断宫格高度要留出安全距离
    if (result.mGridHeight > (screenHeight - this.mLauncherLayoutStyleConfig.mAppCenterMarginBottom -
    this.mLauncherLayoutStyleConfig.mAppCenterMarginTop - this.mBaseConfig.getDockHeight())) {
      result.mGridHeight = screenHeight - this.mLauncherLayoutStyleConfig.mAppCenterMarginBottom -
      this.mLauncherLayoutStyleConfig.mAppCenterMarginTop - this.mBaseConfig.getDockHeight();
    }
    result.mColumnsGap = (result.mGridWidth - Number(result?.mAppCenterItemWidth ?? 0) * result.mColumns) /
      result.mColumns;
    result.mRowsGap = (result.mGridHeight - Number(result?.mAppCenterItemHeight ?? 0) * result.mRows) / result.mRows;
  }

  /**
   * 计算应用中心图标等比缩放倍率
   * @param result 结果集
   * @returns 缩放倍率
   */
  private calculateAppCenterItemScale(result: CalculateAppCenterRst): number {
    let scaleRatio = 1;
    let mGridWidth: number = Number(result?.mGridWidth ?? 0);
    let mGridHeight: number = Number(result?.mGridHeight ?? 0);
    let mAppCenterItemWidth: number = Number(result?.mAppCenterItemWidth ?? 0);
    let mAppCenterItemHeight: number = Number(result?.mAppCenterItemHeight ?? 0);
    let mColumns: number = Number(result?.mColumns ?? 0);
    let mRows: number = Number(result?.mRows ?? 0);
    if (mGridWidth < (mAppCenterItemWidth * mColumns + StyleConstants.APP_CENTER_ITEM_MIN_GAP * mColumns)) {
      scaleRatio = (mGridWidth - StyleConstants.APP_CENTER_ITEM_MIN_GAP * mColumns) / mColumns / mAppCenterItemWidth;
    }
    if (mGridHeight < (mAppCenterItemHeight * mRows + StyleConstants.APP_CENTER_ITEM_MIN_GAP * mRows)) {
      let rowScaleRatio = ((mGridHeight - StyleConstants.APP_CENTER_ITEM_MIN_GAP * mRows) / mRows) /
        mAppCenterItemHeight;
      scaleRatio = (rowScaleRatio < scaleRatio) ? rowScaleRatio : scaleRatio;
    }
    return scaleRatio;
  }
  /**
   * 应用中心图标等比缩放
   * @param result 结果集
   */
  protected proportionalScaling(result: CalculateAppCenterRst): void {
    let scaleRatio = this.calculateAppCenterItemScale(result);
    // 等比缩放
    result.mRatio = scaleRatio;
    result.mAppItemSize = Math.round(Number(result?.mAppItemSize ?? 0) * scaleRatio);
    result.mAppCenterItemWidth = Math.round(Number(result?.mAppCenterItemWidth ?? 0) * scaleRatio);
    result.mAppCenterItemHeight = Math.round(Number(result?.mAppCenterItemHeight ?? 0) * scaleRatio);
    result.mIconSize = Math.round(Number(result?.mIconSize ?? 0) * scaleRatio);
    result.mIconRadius = Math.round(Number(result?.mIconRadius ?? 0) * scaleRatio);
    result.mAppCenterBubbleMarginTop = Math.round(Number(result?.mAppCenterBubbleMarginTop ?? 0) * scaleRatio);
    result.mAppCenterBubbleMarginBottom = Math.round(Number(result?.mAppCenterBubbleMarginBottom ?? 0) * scaleRatio);
    result.mColumnsGap = Math.round((Number(result?.mGridWidth ?? 0) -
      result?.mAppCenterItemWidth * Number(result?.mColumns ?? 0)) / Number(result?.mColumns ?? 0));
    result.mRowsGap = Math.round((Number(result?.mGridHeight ?? 0) -
      result?.mAppCenterItemHeight * Number(result?.mRows ?? 0)) / Number(result?.mRows ?? 0));
    result.mNameSize = Math.floor(this.mLauncherLayoutStyleConfig.mAppCenterNameSize * scaleRatio);
  }
}