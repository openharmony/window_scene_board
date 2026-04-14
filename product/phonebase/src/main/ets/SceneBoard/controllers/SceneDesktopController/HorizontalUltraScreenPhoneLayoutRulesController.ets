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

import {
  CalculateFormRst,
  CalculateOpenFolderRst,
  ConfigParseUtil,
  FolderLayoutStruct,
  FolderStyleConstants,
  OpenFolderStyleParam,
  PageInfoManager,
  StyleConstants
} from '@ohos/launchercommon';
import type { BaseConfig, CalculateDockRst } from '@ohos/launchercommon';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { CheckEmptyUtils, FileUtils, LogDomain, Logger, SingleContext, singleManager } from '@ohos/basicutils';
import { FolderStyleCalculate } from '@ohos/bigfolder/src/main/ets/default/viewmodel/FolderStyleCalculate';
import { ClassCfgJson, DefaultLayout, FoldPhoneLayoutRulesController } from './FoldPhoneLayoutRulesController';
import { DefaultGridProp, SpaceOfRowSize } from './PhoneLayoutRulesController';
import { ScreenOrientation, ScreenStateModel, ScreenStateMonitor } from '@ohos/frameworkwrapper';

const TAG = 'HorizontalUltraScreenPhoneLayoutRulesController';
const GRID_CONFIG_PATH = 'etc/SceneBoard/launcher_layout_rules.json';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 屏幕左右两侧偏移量
 * 满足如下公式：- 该偏移量 + 图标到屏幕的距离 + 2 = 两屏间的距离。依据UI设计稿 -x + 151 + 2 = 64, 计算出 x为89
 *
 * 也满足如下计算规则：
 * 屏幕宽度 1107 vp, 图标宽度 52， 图标列间距 54， 两屏最内侧图标间距 64
 * 1107 - 52 * 8 - 54 * 6 - offset * 2 - 64 - (64 - 2) * 2 = 0 这里计算出 offset 为 89.5
 *
 * 依据实际运行效果，该值取 90
 */
const SCREEN_PADDING_OFFSET = 90;

// 同一屏图标之间的间距
const SPACE_OF_ICON = 32;

// 两屏之间图标的间距
const SPACE_OF_ICON_SCREEN = 60;

// 默认displayCount
const DEFAULT_DISPLAY_COUNT = 2;

// 最大的displayCount
const MAX_DISPLAY_COUNT = 3;

// 三屏显示下dock和recent的gap
const DEFAULT_G_LANDSCAPE_SPLIT_LINE_GAP_THREE = 3;

/**
 * 超大屏展开态横屏模式布局控制器
 *
 * F态， M 态竖屏，G态横屏 高度是一致的。继承自FoldPhoneLayoutRulesController, 更好沿用其纵向的规格，如行间距，图标大小，底部导航点的位置，
 * 网格上下的留白比例。当屏幕状态处于F态, M态竖屏，G态横屏三者间变化时，元素的纵向位置不会有偏差。
 */
export class HorizontalUltraScreenPhoneLayoutRulesController extends FoldPhoneLayoutRulesController {
  public static singleName: string = 'HorizontalUltraScreenPhoneLayoutRulesController';

  /**
   * 两屏之间图标的间距
   */
  private spaceOfIconScreen: number = SPACE_OF_ICON_SCREEN;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig,
    ctx?: SingleContext): HorizontalUltraScreenPhoneLayoutRulesController {
    let instance =
      singleManager.get<HorizontalUltraScreenPhoneLayoutRulesController>(HorizontalUltraScreenPhoneLayoutRulesController,
        ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    super.initBaseConfig(baseConfig);
  }

  protected loadLauncherNewStyleConfig(): void {
    try {
      let cfgFile: string = ConfigParseUtil.getConfigSync(GRID_CONFIG_PATH);
      if (CheckEmptyUtils.checkStrIsEmpty(cfgFile)) {
        throw new Error('config json is empty!');
      }
      let cfgJson: ClassCfgJson = FileUtils.readJsonFile(cfgFile);
      let portraitLayout = cfgJson.portraitLayout;
      this.iconSizeOfGrid = portraitLayout?.iconSizeOfGrid ?? this.iconSizeOfGrid;
      this.columnNumOfGrid = portraitLayout?.columnNumOfGrid ?? this.columnNumOfGrid;
      this.rowNumOfGrid = portraitLayout?.rowNumOfGrid ?? this.rowNumOfGrid;
      this.mScreenWidth = portraitLayout?.screenWidth ? px2vp(portraitLayout?.screenWidth) : this.mScreenWidth;
      // 优先从配置文件读取行间距与图标大小，解决X5 7行布局横屏状态下滑动桌面时顶部截断问题
      this.configSpaceOfRow = cfgJson.defaultLayout?.spaceOfRow;
      this.landIconSizeOfGrid = cfgJson.defaultLayout?.landIconSizeOfGrid;
      // 本方法以上可以用super,但因为类型不明确暂时无法使用
      let defaultLayout: DefaultLayout = cfgJson.defaultLayout;
      if (defaultLayout && defaultLayout.spaceOfIconScreen) {
        this.spaceOfIconScreen = defaultLayout.spaceOfIconScreen;
      }
      let maxDisplayCount = this.dealDisplayCount(defaultLayout);
      this.mBaseConfig.init();
      log.showWarn(TAG, 'load config[%{public}s] success.loadLauncherNewStyleConfig maxDisplayCount:%{public}d',
        cfgFile, maxDisplayCount);
    } catch (e) {
      log.showError(TAG, 'load GridStyle config JSON fail code:%{public}d, message:%{public}s', e.code, e.message);
    }
  }

  /**
   * 处理maxDisplayCount
   * @param defaultLayout
   * @returns maxDisplayCount
   */
  private dealDisplayCount(defaultLayout: DefaultLayout): number {
    let maxDisplayCount = DEFAULT_DISPLAY_COUNT;
    if (!defaultLayout || defaultLayout.maxDisplayCount === undefined) {
      PageInfoManager.getInstance().setMaxDisplayCount(maxDisplayCount);
      return maxDisplayCount;
    }
    maxDisplayCount = Number(defaultLayout.maxDisplayCount);

    if (isNaN(maxDisplayCount)) {
      PageInfoManager.getInstance().setMaxDisplayCount(DEFAULT_DISPLAY_COUNT);
      return DEFAULT_DISPLAY_COUNT;
    }
    if (maxDisplayCount > MAX_DISPLAY_COUNT) {
      maxDisplayCount = MAX_DISPLAY_COUNT;
    }
    PageInfoManager.getInstance().setMaxDisplayCount(maxDisplayCount);
    return maxDisplayCount;
  }

  initGridIconSize(): void {
    // 图标大小
    this.iconSizeOfGrid = StyleConstants.DEFAULT_52;
  }

  public initRowAndColumnGap(): void {
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      this.initRowAndColumnGapThree();
      return;
    }
    // 列间距X 54.
    this.spaceOfColumn = (this.mScreenWidth - SCREEN_PADDING_OFFSET + this.columnSpaceGapOfSide *
      StyleConstants.DEFAULT_2 - this.iconSizeOfGrid * this.columnNumOfGrid) / (this.columnNumOfGrid + 1);
    this.offsetOfRowAndColumn = super.calculateOffsetOfRowAndColumn();
    // 行间距Y
    this.spaceOfRow = this.adjustSpaceOfRowByScreenHeight(this.spaceOfColumn, this.offsetOfRowAndColumn);
  }

  public adjustSpaceOfRowByScreenHeight(columSpace: number, offset:number): number {
    if (desktopUtil.isFold() && this.rowNumOfGrid === DefaultGridProp.LONG_SCREEN_ROW_NUM_OF_GRID) {
      return SpaceOfRowSize.SMALL_SIZE;
    }
    let extendColumSpace = columSpace + offset;
    let adjustSpaceOfRow: number = extendColumSpace;
    if (extendColumSpace < SpaceOfRowSize.SMALL_SIZE) {
      adjustSpaceOfRow = extendColumSpace;
    } else if (extendColumSpace >= SpaceOfRowSize.SMALL_SIZE && extendColumSpace < SpaceOfRowSize.MEDIUM_SIZE) {
      adjustSpaceOfRow = SpaceOfRowSize.SMALL_SIZE;
    } else if (extendColumSpace >= SpaceOfRowSize.MEDIUM_SIZE && extendColumSpace < SpaceOfRowSize.LARGE_SIZE) {
      adjustSpaceOfRow = SpaceOfRowSize.MEDIUM_SIZE;
    } else if (extendColumSpace >= SpaceOfRowSize.LARGE_SIZE && extendColumSpace < SpaceOfRowSize.MAX_SIZE) {
      adjustSpaceOfRow = SpaceOfRowSize.LARGE_SIZE;
    } else {
      adjustSpaceOfRow = SpaceOfRowSize.MAX_SIZE;
    }
    return adjustSpaceOfRow;
  }
  
  public initSpaceSideOfColumnAndScreen(offset: number): void {
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      this.initSpaceSideOfColumnAndScreenThree();
      return;
    }
    let scrWidth = this.mBaseConfig.getScreenWidth();
    let allIconWidth = this.iconSizeOfGrid * this.columnNumOfGrid * StyleConstants.DEFAULT_2;
    let allColumnSpaceWidth = this.spaceOfColumn * (this.columnNumOfGrid * StyleConstants.DEFAULT_2 -
      StyleConstants.DEFAULT_2);
    // spaceX: 图标到屏幕侧边的空白距离
    let spaceX = (scrWidth * StyleConstants.DEFAULT_2 - allIconWidth - allColumnSpaceWidth - offset -
      SCREEN_PADDING_OFFSET * 2) / StyleConstants.DEFAULT_3;
    this.spaceOfScreenSide = (spaceX + offset) - this.spaceOfColumn;
    this.spaceOfColumnSide = spaceX - this.spaceOfColumn / StyleConstants.DEFAULT_2 + SCREEN_PADDING_OFFSET;
  }



  /**
   * calculate dock
   */
  calculateDock(): CalculateDockRst {
    let result = super.calculateDock();
    // G态横屏状态，列间距暂时使用固定的值
    result.mListItemGap = this.mLauncherLayoutStyleConfig.mGLandscapeItemGap;
    // G态横屏状态，竖条距离两边的距离暂时使用固定的值
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      result.mResidentSplitLineGap = DEFAULT_G_LANDSCAPE_SPLIT_LINE_GAP_THREE;
    } else {
      result.mResidentSplitLineGap = this.mLauncherLayoutStyleConfig.mGSplitLineGap;
    }
    return result;
  }

  toString(): String {
    return TAG;
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
    if (openFolderStyleParam) {
      openFolderStyleParam.iconHorizontalScale = FolderStyleConstants.ULTRA_SCREEN_FOLDER_ICON_VERTICAL_SCALE;
      openFolderStyleParam.dragBroderIconHorizontalDistance =
        FolderStyleConstants.PAD_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
      openFolderStyleParam.gridHorizontalPadding =
        FolderStyleConstants.PAD_OPEN_FOLDER_DRAG_BORDER_ICON_HORIZONTAL_DISTANCE;
      result.mOpenFolderStyle = FolderStyleCalculate.calculateOpenFolderStyle(openFolderStyleParam);
    }
    return result;
  }

  /**
   * calculate card form
   * @returns 卡片布局参数结果
   */
  calculateForm(): CalculateFormRst {
    return PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3 ? super.calculateForm() :
    super.calculateFormInNotSquare(StyleConstants.THREE_SCREEN_HORIZONTAL_ADDED_SPACING);
  }

  private initRowAndColumnGapThree(): void {
    //如果配置文件没配置，就计算得到列间距
    this.spaceOfColumn = SPACE_OF_ICON;
    this.spaceOfColumnSide = 0;
    // 列间距
    this.offsetOfRowAndColumn = this.calculateOffsetOfRowAndColumn();
    this.spaceOfRow = super.adjustSpaceOfRowByScreenHeight(this.spaceOfColumn, this.offsetOfRowAndColumn);
  }

  private initSpaceSideOfColumnAndScreenThree(): void {
    this.spaceOfScreenSide = this.getSpaceOfScreenSide();
    this.spaceOfColumnSide = 0;
  }

  /**
   * 计算Grid宽度
   * @returns
   */
  protected getRealGridWidth(): number {
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      return (this.iconSizeOfGrid + this.spaceOfColumn) * this.columnNumOfGrid;
    }
    return super.getRealGridWidth();
  }

  /**
   * 计算两屏之间图标间距跟每屏图标居中实际间距的差值
   * @returns
   */
  protected getPaddingSideFold(): number {
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      return this.spaceOfColumn + this.getSpaceOfScreenSide() - this.spaceOfIconScreen;
    }
    return super.getPaddingSideFold();
  }

  /**
   * 获取grid跟单屏之间的margin
   * @returns
   */
  protected getMarginGrid(): number {
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      return this.getSpaceOfScreenSide() / StyleConstants.DEFAULT_2;
    }
    return super.getMarginGrid();
  }

  /**
   * 获取grid跟单屏之间的间距
   * @returns
   */
  private getSpaceOfScreenSide(): number {
    let screenWidth: number = this.mBaseConfig.getScreenWidth();
    let state: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
    // 横屏才会进入到这个类，如果在开机的时候由于传的数据不对导致竖屏进入该类，对数据进行修护
    if (state.orientation === ScreenOrientation.PORTRAIT) {
      let foldScreenWidth: number = this.mBaseConfig.getFoldScreenWidth();
      if (foldScreenWidth > 0) {
        screenWidth = foldScreenWidth / MAX_DISPLAY_COUNT;
      }
      log.showWarn(TAG, `getSpaceOfScreenSide screenWidth: ${screenWidth} state: ${JSON.stringify(state)}`);
    }
    return screenWidth - this.getRealGridWidth();
  }
}