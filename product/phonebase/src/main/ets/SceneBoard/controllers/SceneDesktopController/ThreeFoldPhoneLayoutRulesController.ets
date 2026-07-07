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

import {
  BaseConfig,
  CalculateFolderRst,
  CalculateOpenFolderRst,
  FolderLayoutStruct,
  FolderStyleConstants,
  OpenFolderStyleParam,
  } from '@ohos/launchercommon';
import { CalculateFormRst, StyleConstants } from '@ohos/launchercommon';
import { IconSize } from './PhoneLayoutRulesController';
import { FoldPhoneLayoutRulesController } from './FoldPhoneLayoutRulesController';
import { FolderStyleCalculate } from '@ohos/bigfolder/src/main/ets/default/viewmodel/FolderStyleCalculate';
import { Log, SingleContext, singleManager } from '@ohos/basicutils';


const TAG = 'ThreeFoldPhoneLayoutRulesController';

//网格上方空白区域 偏移量， 保证网格最下一行图标到屏幕底部的距离满足设计要求
const ABOVE_PADDING_OFFSET = 25;
/**
 * 屏幕左右两侧偏移量， 满足如下公式：
 *  - 该偏移量 + 图标到屏幕的距离 + 2 = 两屏间的距离
 * 12 + 38 + 2 = 54
 */
const SCREEN_PADDING_OFFSET = -12;

//行间距， 固定值
const ROW_SPACE = 66;
//列间距，固定值
const COLUMN_SPACE = 36;

/**
 * 三折屏展开态竖屏模式布局， G态竖屏因屏幕尺寸差异过大，行列间距，网格上下的空白区域比例无法沿用之前的公式，所以采用固定值或加偏移量的方式来保证
 * UI效果。
 */
export class ThreeFoldPhoneLayoutRulesController extends FoldPhoneLayoutRulesController {
  public static singleName: string = 'ThreeFoldPhoneLayoutRulesController';

  /** 双屏之间间距，通过计算得到*/
  protected spaceOfScreenSide: number = 0;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): ThreeFoldPhoneLayoutRulesController {
    let instance = singleManager.get<ThreeFoldPhoneLayoutRulesController>(ThreeFoldPhoneLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    Log.showInfo(TAG, `${ThreeFoldPhoneLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
  }

  protected initGridIconSize(): void {
    this.iconSizeOfGrid = IconSize.MIDDLE;
  }

  protected initRowAndColumnGap(): void {
    this.spaceOfColumn = COLUMN_SPACE;
    this.spaceOfRow = ROW_SPACE;
  }

  protected initSpaceSideOfColumnAndScreen(offset: number): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    let allIconWidth = this.iconSizeOfGrid * this.columnNumOfGrid * StyleConstants.DEFAULT_2; // 54 * 8
    let allColumnSpaceWidth = this.spaceOfColumn * (this.columnNumOfGrid * StyleConstants.DEFAULT_2 -
      StyleConstants.DEFAULT_2); // 36 * 6
    let spaceX = (scrWidth * StyleConstants.DEFAULT_2 - allIconWidth - allColumnSpaceWidth - offset -
      SCREEN_PADDING_OFFSET * StyleConstants.DEFAULT_2) / StyleConstants.DEFAULT_3;
    this.spaceOfScreenSide = (spaceX + offset) - this.spaceOfColumn;
    this.spaceOfColumnSide = spaceX - this.spaceOfColumn / StyleConstants.DEFAULT_2 + SCREEN_PADDING_OFFSET;
  }

  protected getMarginBottomOfIndicator(belowSpace: number): number {
    return super.getMarginBottomOfIndicator(belowSpace) + ABOVE_PADDING_OFFSET;
  }

  protected getAboveSpace(realSpace: number, fixedPaddinOfStatus: number): number {
    let data = super.getAboveSpace(realSpace, fixedPaddinOfStatus) + ABOVE_PADDING_OFFSET;
    return data;
  }

  toString(): String {
    return TAG;
  }

  /**
   * calculate card form
   * @returns 卡片布局参数结果
   */
  calculateForm(): CalculateFormRst {
    return super.calculateFormInNotSquare(StyleConstants.THREE_SCREEN_VERTICALLY_ADDED_SPACING);
  }

  /**
   * calculate desktop folder
   *
   * @param layoutInfo folder layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateFolder(layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateFolderRst {
    let numberOfIconsLine = StyleConstants.DEFAULT_2;
    let bigFolderSize = this.iconSizeOfGrid * numberOfIconsLine + this.spaceOfColumn +
    StyleConstants.THREE_SCREEN_VERTICALLY_ADDED_SPACING;
    return super.calculateFolderByFolderSize(layoutInfo, bigFolderSize, isInPreviewMode);
  }

  /**
   * calculate open folder
   *
   * @param openFolderConfig layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateOpenFolder(openFolderConfig: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateOpenFolderRst {
    let result = super.calculateOpenFolder(openFolderConfig, isInPreviewMode);
    let openFolderStyleParam: OpenFolderStyleParam | undefined = result.mOpenFolderStyleParam;
    let iconSizeTemp: number = this.iconSizeOfGrid;
    let themeStyle = this.getThemeStyleInfo(isInPreviewMode);
    if (themeStyle && themeStyle.iconSizeScale) {
      iconSizeTemp += themeStyle.iconSizeScale;
    }
    if (!isInPreviewMode) {
      iconSizeTemp += this.getDesktopIconSize();
    }
    if (openFolderStyleParam) {
      openFolderStyleParam.iconHorizontalScale = FolderStyleConstants.THREE_SCREEN_FOLDER_ICON_VERTICAL_SCALE;
      openFolderStyleParam.iconSize = iconSizeTemp;
      openFolderStyleParam.defaultIconSize = this.iconSizeOfGrid;
      openFolderStyleParam.sysTopHeight = this.mBaseConfig.getSysUITopHeight();
      openFolderStyleParam.dragBroderIconHorizontalDistance =
        FolderStyleConstants.PAD_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
      openFolderStyleParam.gridHorizontalPadding =
        FolderStyleConstants.PAD_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
      result.mOpenFolderStyle = FolderStyleCalculate.calculateOpenFolderStyle(openFolderStyleParam);
      let openFolderStyle = result.mOpenFolderStyle;
      let iconGridHeight = openFolderStyle.gridItemHeight * (openFolderStyleParam.maxRows - 1) +
        openFolderStyleParam.defaultIconSize;
      let halfDistance = (openFolderStyleParam.screenHeight - iconGridHeight) / StyleConstants.DEFAULT_2;
      result.mOpenFolderStyle.indicatorBottom = halfDistance - FolderStyleConstants.DEFAULT_INDICATOR_BOTTOM_MARGIN -
        openFolderStyleParam.iconSize * FolderStyleConstants.PAD_INDICATOR_BOTTOM_RATIO;
    }
    return result;
  }

}