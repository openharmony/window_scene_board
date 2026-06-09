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

import { Log, SingleContext, singleManager } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  BaseConfig,
  CalculateDockRst,
  FolderLayoutStruct,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { IconSize, PhoneLayoutRulesController, ScreenWidth } from './PhoneLayoutRulesController';
import type { CalculateDesktopRst, CalculateFolderRst, CalculateFormRst } from '@ohos/launchercommon';

const TAG = 'SimplePhoneLayoutRulesController';
const SIMPLE_MODEL_RATIO: number = 1.3;
const SIMPLE_GRID_ROW_MAX: number = 4;
const SIMPLE_GRID_COLUMN_MAX: number = 3;

export class SimplePhoneLayoutRulesController extends PhoneLayoutRulesController {
  public static singleName: string = 'SimplePhoneLayoutRulesController';

  // 图标顶部到上一个图标文字距离
  private mIconTopToTextSpace: number = 0;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): SimplePhoneLayoutRulesController {
    let instance = singleManager.get<SimplePhoneLayoutRulesController>(SimplePhoneLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    Log.showInfo(TAG, `${SimplePhoneLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
    this.calculateProductConfig();
  }

  calculateProductConfig(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    let scrHeight = this.mBaseConfig.getScreenHeight();
    // 初始化iconSizeOfGrid
    this.initGridIconSize();
    this.rowNumOfGrid = SIMPLE_GRID_ROW_MAX;
    this.columnNumOfGrid = SIMPLE_GRID_COLUMN_MAX;
    // 初始化导航点偏移量
    this.navigationOffset = DefaultGridProp.NAVIGATION_OFFSET;
    //初始化两侧列间距补偿值
    this.columnSpaceGapOfSide = DefaultGridProp.COLUMN_SPACE_GAP_OF_SIDE;
    Log.showInfo(TAG, `initProductConfig iconSize : ${this.iconSizeOfGrid}  rowNumOfGrid ${this.rowNumOfGrid}
      scrHeight: ${scrHeight} scrWidth :${scrWidth}`);

    this.spaceOfColumn = (scrWidth + this.columnSpaceGapOfSide * StyleConstants.DEFAULT_2 -
      this.iconSizeOfGrid * this.columnNumOfGrid) / (this.columnNumOfGrid + 1);
    // 图标顶部到上一个图标文字距离
    this.mIconTopToTextSpace = (scrHeight - this.rowNumOfGrid * (this.iconSizeOfGrid +
      DefaultGridProp.SIMPLE_LAYOUT_FONT_SIZE + DefaultGridProp.SIMPLE_ICON_NAME_MARGIN_TOP) - this.iconSizeOfGrid -
      this.mBaseConfig.getSysUITopHeight() - this.mBaseConfig.getDockBottomHeight()) / (this.rowNumOfGrid + 2);
    this.spaceOfRow = this.mIconTopToTextSpace + DefaultGridProp.SIMPLE_LAYOUT_FONT_SIZE +
      DefaultGridProp.SIMPLE_ICON_NAME_MARGIN_TOP;
    this.spaceOfColumnSide = this.spaceOfColumn / StyleConstants.DEFAULT_2 - this.columnSpaceGapOfSide;
    Log.showInfo(TAG, `scrHeight ${scrHeight} getNameHeight ${this.mBaseConfig.getNameHeight()} getSysUITopHeight ${this.mBaseConfig.getSysUITopHeight()} mIconTopToTextSpace ${this.mIconTopToTextSpace}`);
    Log.showInfo(TAG, `spaceOfColumn: ${this.spaceOfColumn}, spaceOfRow: ${this.spaceOfRow}, spaceOfColumnSide: ${this.spaceOfColumnSide},
     offsetOfRowAndColumn :${this.offsetOfRowAndColumn}`);
  }

  protected initGridIconSize(): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    // 初始化iconSizeOfGrid
    if (scrWidth >= ScreenWidth.LARGE) {
      this.iconSizeOfGrid = IconSize.LARGE;
    } else if (scrWidth < ScreenWidth.MIDDLE) {
      this.iconSizeOfGrid = IconSize.SMALL;
    } else {
      this.iconSizeOfGrid = IconSize.MIDDLE;
    }
    this.iconSizeOfGrid = Math.floor(this.iconSizeOfGrid * SIMPLE_MODEL_RATIO);
  }

  calculateDesktop(): CalculateDesktopRst {
    let itemPadding = this.mBaseConfig.getItemPadding();
    let realGridWidth = this.mBaseConfig.getScreenWidth() - StyleConstants.DEFAULT_2 * this.spaceOfColumnSide;
    // 更新网格宽度
    this.mBaseConfig.setGridRealWidth(realGridWidth);
    let lines = this.mLauncherLayoutStyleConfig.mNameLines;
    let nameHeight = this.mBaseConfig.getNameHeight();
    let itemSize = this.mBaseConfig.getItemSize() + (lines - 1) * nameHeight;
    let realGridHeight = (this.iconSizeOfGrid + this.spaceOfRow) * this.rowNumOfGrid;
    // 更新网格高度
    this.mBaseConfig.setGridRealHeight(realGridHeight);
    //上下留白的计算公式 aboveSpace + belowSpace = realSpace; aboveSpace  : belowSpace = 1 : 2;
    let aboveSpace = this.mIconTopToTextSpace;
    let belowSpace = StyleConstants.DEFAULT_2 * this.mIconTopToTextSpace;
    // 上方状态栏高度
    let marginTop = this.mBaseConfig.getSysUITopHeight() + aboveSpace - itemPadding;
    // grid底部距离dock图标顶部的距离 的一半，再减去dock图标顶部距离dock组件顶部的距离，再减去导航条高度的一半，再整体上移1vp，即为导航条距离swiper组件底部的距离
    let indicatorHeight = this.mBaseConfig.getIndicatorHeight();
    let marginBottomOfIndicator = belowSpace / StyleConstants.DEFAULT_2 - this.mLauncherLayoutStyleConfig.mDockPadding -
      indicatorHeight / StyleConstants.DEFAULT_2 + this.navigationOffset / StyleConstants.DEFAULT_2;
    // set desktop icon
    let appTextSize = DefaultGridProp.SIMPLE_LAYOUT_FONT_SIZE;
    let nameWidth = this.mLauncherLayoutStyleConfig.mNameWidth;
    let iconNameMargin = this.mLauncherLayoutStyleConfig.mIconNameGap;
    let iconNameMarginTop = DefaultGridProp.SIMPLE_ICON_NAME_MARGIN_TOP;
    let iconHeight = itemSize - nameHeight * lines - iconNameMarginTop;
    let iconMarginHorizontal = (itemSize - iconHeight) / StyleConstants.DEFAULT_2;
    this.updateGrid(this.rowNumOfGrid, this.columnNumOfGrid);

    let result: CalculateDesktopRst = {
      mMargin: this.spaceOfColumnSide, mItemPadding: itemPadding, mColumnsGap: 0, mRowsGap: 0,
      mColumns: this.columnNumOfGrid, mRows: this.rowNumOfGrid, mDesktopMarginTop: marginTop, mGridWidth: realGridWidth,
      mGridHeight: realGridHeight, mAppItemSize: itemSize, mNameSize: appTextSize, mNameHeight: nameHeight,
      mNameWidth: nameWidth, mIconNameMargin: iconNameMargin, mIconNameMarginTop: iconNameMarginTop,
      mIconSize: this.iconSizeOfGrid, mNameLines: lines, mIconMarginHorizontal: iconMarginHorizontal,
      mIconMarginVertical: 0, marginBottomOfIndicator: marginBottomOfIndicator, mHeightOfIndicator: indicatorHeight
    };

    Log.showInfo(TAG, `desktop result: columns is ${result.mColumns}, rows is ${result.mRows}, iconSize is ${result.mIconSize}, gridWidth is ${result.mGridWidth}, gridHeight is ${result.mGridHeight}`);
    // save cur layout to preferences
    super.saveLayoutToPreferences();
    return result;
  }

  /**
   * calculate card form
   */
  calculateForm(): CalculateFormRst {
    Log.showInfo(TAG, 'calculateForm phone start');
    // 1 x 1  width * height
    let widthDimension0: number = this.iconSizeOfGrid;
    let heightDimension0: number = this.iconSizeOfGrid;
    // 2 x 1  width * height
    let widthDimension1: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfRow;
    let heightDimension1: number = this.iconSizeOfGrid;
    // 2 x 2
    let widthDimension2: number = widthDimension1;
    let heightDimension2: number = widthDimension1;
    // 3 x 2
    let widthDimension3: number = (this.iconSizeOfGrid + this.spaceOfColumn) * StyleConstants.DEFAULT_1 +
      widthDimension1;
    let heightDimension3: number = heightDimension2;
    // 3 x 3
    let widthDimension4: number = widthDimension3;
    let heightDimension4: number = (this.iconSizeOfGrid + this.spaceOfRow) * StyleConstants.DEFAULT_1 + widthDimension1;
    // 3 x 3
    let widthDimension5: number = widthDimension3;
    let heightDimension5: number = (this.iconSizeOfGrid + this.spaceOfRow) * StyleConstants.DEFAULT_1 + widthDimension1;
    // 3 x 2
    let widthDimension6: number = (this.iconSizeOfGrid + this.spaceOfColumn) * StyleConstants.DEFAULT_2 +
      this.iconSizeOfGrid;
    let heightDimension6: number = this.iconSizeOfGrid * StyleConstants.DEFAULT_2 + this.spaceOfRow;
    let result: CalculateFormRst = {
      mIconNameMargin: this.mBaseConfig.getDesktopIconNameMargin(),
      mIconNameMarginTop: this.mBaseConfig.getIconNameMarginTop(),
      widthDimension0: widthDimension0,
      heightDimension0: heightDimension0,
      widthDimension1: widthDimension1,
      heightDimension1: heightDimension1,
      widthDimension2: widthDimension2,
      heightDimension2: heightDimension2,
      widthDimension4: widthDimension4,
      heightDimension4: heightDimension4,
      widthDimension3: widthDimension3,
      heightDimension3: heightDimension3,
      widthDimension5: widthDimension5,
      heightDimension5: heightDimension5,
      widthDimension6: widthDimension6,
      heightDimension6: heightDimension6
    };
    return result;
  }

  /**
   * calculate desktop folder
   *
   * @param layoutInfo folder layoutInfo
   * @param isInPreviewMode boolean
   */
  calculateFolder(layoutInfo: FolderLayoutStruct, isInPreviewMode?: boolean): CalculateFolderRst {
    let result: CalculateFolderRst = super.calculateFolder(layoutInfo, isInPreviewMode);
    result.mIconNameMarginTop = DefaultGridProp.SIMPLE_ICON_NAME_MARGIN_TOP;
    return result;
  }

  calculateDock(): CalculateDockRst {
    let result: CalculateDockRst = super.calculateDock();
    result.mMaxDockNum = DefaultGridProp.SIMPLE_DOCK_MAX_NUM;
    return result;
  }
}

/**
 * 布局配置值
 */
enum DefaultGridProp {
  COLUMN_NUM_OF_GRID = 4,
  NAVIGATION_OFFSET = 2,
  COLUMN_SPACE_GAP_OF_SIDE = 8,
  BIG_OFFSET_OF_ROA_AND_COLUMN = 8,
  SMALL_OFFSET_OF_ROW_AND_COLUMN = 4,
  LONG_SCREEN_ROW_NUM_OF_GRID = 7,
  ORDINARY_SCREEN_ROW_NUM_OF_GRID = 6,
  SIMPLE_LAYOUT_FONT_SIZE = 18,
  SIMPLE_ICON_NAME_MARGIN_TOP = 10,
  SIMPLE_DOCK_MAX_NUM = 3
}