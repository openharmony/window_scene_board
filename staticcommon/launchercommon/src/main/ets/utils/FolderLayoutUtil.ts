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
import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { DragPosition, GridItemPositionUtil } from '@ohos/componentdrag';
import { NumberConstants } from '@ohos/commonconstants';
import { RectangularCoordinates } from '@ohos/componenthelper';
import {
  AppGridStyleConfig,
  BigFolderStyleConfig,
  CommonConstants,
  DesktopLayoutState,
  DesktopManager,
  DeviceState,
  FolderAppItemInfo,
  FolderConstants,
  FolderStyleManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  layoutConfigManager,
  LayoutViewModel,
  OpenFolderStyleConfig,
  SmallFolderStyleConfig,
  SmartDockZoomFeatureSwitch,
  StyleConstants
} from '../TsIndex';
import { componentUtils, Size } from '@kit.ArkUI';
import { AreaSpan } from '../utils/GridLayoutUtil';

const TAG = 'FolderLayoutUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FOLDER_OPEN_DRAG_BORDER_WIDTH = 2;
const MAX_INDEX_SMALL_FOLDER: number = 8;
const KEY_ITEM: string = 'FolderIconKey';

/**
 * 用于文件夹内元素坐标位置计算的工具类
 */
export class FolderLayoutUtil {
  /**
   * 各种文件夹类型对应网格宽高
   */
  private mFolderAreaMap = new Map<FolderType, number[]>([
    [FolderType.TYPE_SMALL_FOLDER, [1, 1]],
    [FolderType.TYPE_NORMAL_BIG_FOLDER, [2, 2]],
    [FolderType.TYPE_2X1_BIG_FOLDER, [2, 1]],
    [FolderType.TYPE_1X2_BIG_FOLDER, [1, 2]],
    [FolderType.TYPE_4X2_BIG_FOLDER, [4, 2]],
    [FolderType.TYPE_3X4_OPEN_FOLDER, [3, 4]],
    [FolderType.TYPE_4X4_OPEN_FOLDER, [4, 4]]
  ]);

  /**
   * 各种文件夹尺寸对应的长宽vp
   */
  private mFolderWidth: Map<AreaSpan, number> = new Map<AreaSpan, number>();

  private mFolderHeight: Map<AreaSpan, number> = new Map<AreaSpan, number>();

  private mDesktopGridItemWidth: number = 0;
  private mDesktopGridItemHeight: number = 0;
  private mDesktopIconSize: number = 0;
  private mDesktopItemPadding: number = 0;
  private isPadOrExpanded: boolean = false;
  private static _dockZoomScale: number = 1;

  public static set dockZoomScale(value: number) {
    FolderLayoutUtil._dockZoomScale = value;
  }

  /**
   * 各种类型文件夹内每个图标中心点与标志点位的差值，标志点位如(当前父控件的中心点或左上角)
   */
  private mFolderLayoutMap: Map<FolderType, GridItemPositionUtil> = new Map();

  /**
   * 小文件夹中各图标中心点与背板的距离
   */
  private mSmallFolderItemCenterMap: Map<DesktopLayoutState, Map<number, Map<number, FolderItemCenter>>> = new Map();

  /**
   * 镜像语言下，小文件夹中各图标中心点与背板的距离
   */
  private mSmallFolderItemCenterRTLMap: Map<number, FolderItemCenter> = new Map();

  /**
   * 初始化各个类型的文件夹折叠态内图标差值数组
   */
  public initFolderLayoutConfig(): void {
    this.isPadOrExpanded = DeviceHelper.isPad() ||
      ((AppStorage.get('folderStatus') as number) === DeviceState.EXPAND_STATE && !DeviceHelper.isSmallFoldProduct());
    // 加载配置
    let pageDesktopCfg: AppGridStyleConfig = layoutConfigManager.getStyleConfig(
      AppGridStyleConfig.APP_GRID_STYLE_CONFIG, 'pageDesktop') as AppGridStyleConfig;
    let bigFolderCfg = FolderStyleManager.getInstance().getFolderStyleConfig();
    let smallFolderCfg = FolderStyleManager.getInstance().getSmallFolderStyleConfig();
    this.mDesktopGridItemWidth =
      (pageDesktopCfg.mGridWidth - pageDesktopCfg.mColumnsGap * (pageDesktopCfg.mColumns - 1)) /
      pageDesktopCfg.mColumns;
    this.mDesktopGridItemHeight =
      (pageDesktopCfg.mGridHeight - pageDesktopCfg.mRowsGap * (pageDesktopCfg.mRows - 1)) / pageDesktopCfg.mRows;
    log.showInfo(`initFolderLayoutConfig desktopGridItemWidth=${this.mDesktopGridItemWidth}, desktopGridItemHeight=${this.mDesktopGridItemHeight}`);

    // 适配桌面元素调整大小
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;
    const result = LayoutViewModel.getInstance().calculateForm();
    this.mFolderHeight.set(AreaSpan.SPAN_1, result.heightDimension1 ?? 0 + desktopIconChangeSize);
    this.mFolderHeight.set(AreaSpan.SPAN_2, result.heightDimension2 ?? 0 + desktopIconChangeSize);
    this.mFolderWidth.set(AreaSpan.SPAN_2, result.heightDimension2 ?? 0 + desktopIconChangeSize);
    this.mFolderWidth.set(AreaSpan.SPAN_4, result.widthDimension3 ?? 0 + desktopIconChangeSize);
    // TODO: 如下计算已适配大小调整，但实际1*2文件夹并未根据图标大小调整对应的宽度，确认哪边才是正确规格
    this.mFolderWidth.set(AreaSpan.SPAN_1,
      (this.mFolderWidth.get(AreaSpan.SPAN_2) ?? 0) -
        (((this.mFolderWidth.get(AreaSpan.SPAN_4) ?? 0) - (this.mFolderWidth.get(AreaSpan.SPAN_2) ?? 0)) /
        NumberConstants.CONSTANT_NUMBER_TWO)
    );
    this.mDesktopIconSize = this.mFolderHeight.get(AreaSpan.SPAN_1) ?? 0;
    this.mDesktopItemPadding = pageDesktopCfg.mItemPadding;
    if (desktopUtil.isThreeScreenGState()) {
      this.mFolderWidth.set(AreaSpan.SPAN_2, result.widthDimension2 ?? 0 + desktopIconChangeSize);
    }

    // 初始化文件夹类型布局
    this.dealFolderAreaMap(smallFolderCfg, bigFolderCfg);
  }

  // 初始化文件夹类型布局
  private dealFolderAreaMap(smallFolderCfg: SmallFolderStyleConfig, bigFolderCfg: BigFolderStyleConfig): void {
    this.mFolderAreaMap.forEach((area, key) => {
      log.showInfo(`initFolderLayoutMap ${key}: ${area}`);
      let folderGridPositions: GridItemPositionUtil = new GridItemPositionUtil();
      if (key === FolderType.TYPE_SMALL_FOLDER) {
        let gridSize: number = this.mDesktopIconSize;
        let margin: number = smallFolderCfg.mGridMargin;
        folderGridPositions.initPositionPx({
          paddingLeft: margin,
          paddingTop: margin,
          row: 3,
          column: 3,
          rowGap: smallFolderCfg.mFolderGridGap ?? 0,
          columnGap: smallFolderCfg.mFolderGridGap ?? 0,
          gridWidth: gridSize - margin * NumberConstants.CONSTANT_NUMBER_TWO,
          gridHeight: gridSize - margin * NumberConstants.CONSTANT_NUMBER_TWO,
        }, smallFolderCfg.mFolderAppSize, smallFolderCfg.mFolderAppSize);
      } else if (key === FolderType.TYPE_3X4_OPEN_FOLDER || key === FolderType.TYPE_4X4_OPEN_FOLDER) {
        let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
        let openFolderStyle = OpenFolderStyleConfig.getInstance().getOpenFolderStyle();
        if (!openFolderStyle) {
          return;
        }
        let openGridWidth: number = openFolderStyle.openGridWidth - openFolderStyle.gridHorizontalPadding * 2;
        let rowGap: number = openFolderStyle.rowGap;
        let columnGap: number = openFolderStyle.columnGap;
        if (rowGap < 0) {
          rowGap = 0;
        }
        if (columnGap < 0) {
          columnGap = 0;
        }
        // 文件夹展开态由于padding原因造成图标没有相对于grid item 纵轴居中
        let centerY = openFolderStyle.iconMarginTop + openFolderStyle.iconSize / 2;

        folderGridPositions.initPositionRound({
          paddingLeft: px2vp(Math.round(vp2px((screenWidth - openGridWidth) / NumberConstants.CONSTANT_NUMBER_TWO))),
          paddingTop: px2vp(Math.round(vp2px(openFolderStyle.openFolderIconTopMargin) + vp2px(openFolderStyle.gridVerticalPadding))),
          row: area[1],
          column: area[0],
          rowGap: rowGap,
          columnGap: columnGap,
          gridWidth: openFolderStyle.openGridWidth,
          gridHeight: openFolderStyle.openGridHeight,
        }, {
          paddingTop: openFolderStyle.gridVerticalPadding,
          paddingBottom: openFolderStyle.gridVerticalPadding,
          paddingLeft: openFolderStyle.gridHorizontalPadding,
          paddingRight: openFolderStyle.gridHorizontalPadding,
        }, undefined, px2vp(Math.round(vp2px(centerY))));
      } else {
        let folderWidth = this.getWidthByArea(area);
        let folderHeight = this.getHeightByArea(area);
        let folderRow = GridLayoutUtil.getCountPerColumnInFolder(area);
        let folderColumn = GridLayoutUtil.getCountPerRowInFolder(area);
        let folderPaddingLeft = bigFolderCfg.mGridMargin;
        let folderPaddingTop = bigFolderCfg.mGridMargin;
        let folderRowGap = bigFolderCfg.mFolderGridGap ?? 0;
        let folderColumnGap = bigFolderCfg.mFolderGridGap ?? 0;
        // 1*2,2*1文件夹边距单独计算
        if (area[0] === AreaSpan.SPAN_1) {
          folderPaddingLeft = (folderWidth - bigFolderCfg.mFolderAppSize) / NumberConstants.CONSTANT_NUMBER_TWO;
        } else if (area[1] === AreaSpan.SPAN_1) {
          folderPaddingTop = (folderHeight - bigFolderCfg.mFolderAppSize) / NumberConstants.CONSTANT_NUMBER_TWO;
        }
        // 4*2文件夹行列间距单独计算
        if (area[0] === AreaSpan.SPAN_4) {
          folderColumnGap = (folderWidth - folderPaddingLeft * NumberConstants.CONSTANT_NUMBER_TWO -
            folderColumn * bigFolderCfg.mFolderAppSize) / (folderColumn - 1);
        }
        folderGridPositions.initPositionPx({
          paddingLeft: folderPaddingLeft,
          paddingTop: folderPaddingTop,
          row: folderRow,
          column: folderColumn,
          rowGap: folderRowGap,
          columnGap: folderColumnGap,
          gridWidth: folderWidth - folderPaddingLeft * 2,
          gridHeight: folderHeight - folderPaddingTop * 2,
        }, bigFolderCfg.mFolderAppSize, bigFolderCfg.mFolderAppSize);
      }
      log.showInfo(`gridItemWidth=${folderGridPositions.getItemWidth()}, gridItemHeight=${folderGridPositions.getItemHeight()}`);
      this.mFolderLayoutMap.set(key, folderGridPositions);
    });
  }

  /**
   * 获取文件夹参与动效元素相对父组件网格左上角的位置
   * @param folderStatus 文件夹打开关闭状态
   * @param folderItem 文件夹信息
   * @param appIndex 图标位置
   *
   * @returns RectangularCoordinates.Point 返回相对屏幕左上角的绝对位置
   */
  public getItemPostion(folderStatus: FolderStatus, folder: GridLayoutItemInfo,
    appIndex: number): RectangularCoordinates.Point {
    let appPos: RectangularCoordinates.Point = { x: 0, y: 0 };
    if (folderStatus === FolderStatus.CLOSE_FOLDER) {
      if (GridLayoutUtil.isBigFolder(folder)) {
        appPos = this.getBigFolderItemPosition(folder, appIndex) ?? appPos;
      } else {
        appPos = this.getSmallFolderItemPosition(folder, appIndex) ?? appPos;
      }
    } else if (folderStatus === FolderStatus.OPEN_FOLDER) {
      appPos = this.getOpenFolderItemPosition(appIndex) ?? appPos;
    }

    return appPos;
  }

  /**
   * 获取文件夹内某个图标的宽高
   * @param folder 目标文件夹
   * @param appIndex 图标在文件夹内排序
   * @returns 图标宽高
   */
  public getGridItemRect(folderStatus: FolderStatus, folder: GridLayoutItemInfo, appIndex: number): Size {
    let rect: Size = { width: 0, height: 0 };
    if (folderStatus === FolderStatus.CLOSE_FOLDER) {
      const folderType: FolderType = this.getFolderTypeByArea(folder.area ?? []);
      const folderPositionUtil: GridItemPositionUtil | undefined = this.mFolderLayoutMap.get(folderType);
      rect.width = folderPositionUtil?.getItemWidth() ?? 0;
      rect.height = folderPositionUtil?.getItemHeight() ?? 0;
      if (this.isStackApp(folder, appIndex)) {
        rect.width *= StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80;
        rect.height *= StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80;
      }
    } else {
      const desktopIconSize: number = DesktopManager.getInstance().getDesktopParam().iconSize;
      rect.width = desktopIconSize;
      rect.height = desktopIconSize;
    }
    return rect;
  }

  /**
   * 判断该图标是不是大文件夹堆叠图标
   * @param folder 目标文件夹
   * @param appIndex 图标在文件夹内排序
   * @returns 该图标是不是大文件夹堆叠图标
   */
  private isStackApp(folder: GridLayoutItemInfo, appIndex: number): boolean {
    if (!GridLayoutUtil.isBigFolder(folder)) {
      return false;
    }
    let firstPageMaxShowLength = this.getFirstPageMaxShowLength(folder);
    return appIndex >= firstPageMaxShowLength;
  }


  /**
   * 文件夹首页可展示图标数
   * @param folder 文件夹信息
   * @returns 文件夹首页可展示图标数
   */
  public getFirstPageMaxShowLength(folder: GridLayoutItemInfo): number {
    if (GridLayoutUtil.isBigFolder(folder)) {
      if (!folder.area) {
        return FolderConstants.MAX_ICON_LENGTH_IN_SMALL_FOLDER;
      }
      let column = GridLayoutUtil.getCountPerRowInFolder(folder.area);
      let row = GridLayoutUtil.getCountPerColumnInFolder(folder.area);
      return row * column;
    } else {
      return FolderConstants.MAX_ICON_LENGTH_IN_SMALL_FOLDER;
    }
  }

  /**
   * 获取所有网格位置信息
   * @param folderStatus
   * @param folder
   * @param center
   * @returns
   */
  public getAllGridItemPosition(
    folderStatus: FolderStatus, folder: GridLayoutItemInfo, needCenterPosition: boolean = false
  ): DragPosition[] {
    let folderPositionUtil: GridItemPositionUtil | undefined;
    if (folderStatus === FolderStatus.CLOSE_FOLDER) {
      const folderType: FolderType = this.getFolderTypeByArea(folder.area ?? []);
      folderPositionUtil = this.mFolderLayoutMap.get(folderType);
    } else {
      const folderType = this.isPadOrExpanded ? FolderType.TYPE_4X4_OPEN_FOLDER : FolderType.TYPE_3X4_OPEN_FOLDER;
      folderPositionUtil = this.mFolderLayoutMap.get(folderType);
    }
    return folderPositionUtil?.getAllGridItemPosition(needCenterPosition) ?? [];
  }

  /**
   * 获取文件夹内现有图标数
   * @param folder 文件夹信息
   * @returns 文件夹内现有图标数
   */
  public getFolderAppCount(folder: GridLayoutItemInfo): number {
    const folderType = this.isPadOrExpanded ? FolderType.TYPE_4X4_OPEN_FOLDER : FolderType.TYPE_3X4_OPEN_FOLDER;
    const folderCount: number[] | undefined = this.mFolderAreaMap.get(folderType);
    if (!folderCount) {
      return FolderConstants.DEFAULT_APP_LENGTH_WHEN_CREATE_FOLDER;
    }
    const colCount = folderCount[0];
    const rowCount = folderCount[1];
    let folderAppCount = 0;
    if (folder.layoutInfo && folder.layoutInfo.length > 0) {
      let filledPageCount = folder.layoutInfo.length - 1;
      folderAppCount = filledPageCount * colCount * rowCount +
      folder.layoutInfo[filledPageCount].length;
    }
    if (folderAppCount === 0) {
      return FolderConstants.DEFAULT_APP_LENGTH_WHEN_CREATE_FOLDER;
    } else {
      return folderAppCount;
    }
  }

  /**
   * 获取小文件夹内图标中心点到父网格左上角的偏移坐标(Dock区没有Grid网格，直接返回图标中心点到小文件夹组件左上角偏移坐标)
   * @param folderItem 文件夹信息
   * @param appIndex 图标位置
   *
   * @returns RectangularCoordinates.Point 返回相对屏幕左上角的绝对位置
   */
  public getSmallFolderItemPosition(folder: GridLayoutItemInfo, appIndex: number):
    RectangularCoordinates.Point | undefined {
    let smallFolderColumn = 3;
    let smallFolderRow = 3;
    let appRow = Math.floor(appIndex / smallFolderColumn);
    let appColumn = appIndex - Math.floor(appIndex / smallFolderColumn) * smallFolderColumn;
    appColumn = RTLUtil.getColumnByRTL(appColumn, smallFolderColumn, 1);
    let targetRow = appRow;
    if (appRow >= smallFolderRow) {
      // 超出9个的图标，先拿到最后一行的坐标再计算纵向偏移
      appRow = smallFolderRow - 1;
    }
    let folderGridPositions: GridItemPositionUtil | undefined = this.mFolderLayoutMap.get(FolderType.TYPE_SMALL_FOLDER);
    let position: DragPosition = { x: 0, y: 0 };
    if (!folderGridPositions) {
      return undefined;
    }
    if (!folder.isInDock) {
      // 桌面网格，需要加上组件到桌面网格的偏移量
      position = folderGridPositions.getCenterPosition(
        {
          row: appRow,
          column: appColumn
        },
        folderGridPositions.getPaddingLeft() +
          (this.mDesktopGridItemWidth - this.mDesktopIconSize) / NumberConstants.CONSTANT_NUMBER_TWO,
        folderGridPositions.getPaddingTop() + this.mDesktopItemPadding
      );
    } else {
      // Dock区小文件夹没有网格，直接返回到组件左上角坐标
      position = folderGridPositions.getCenterPosition(
        {
          row: appRow,
          column: appColumn
        }
      );
      if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
        position.x -= (1 - FolderLayoutUtil._dockZoomScale) * (position.x);
        position.y -= (1 - FolderLayoutUtil._dockZoomScale) * (position.y);
      }
    }

    // 小文件夹超出9个的元素，从最后一行的位置向下继续计算纵向偏移
    if (targetRow >= smallFolderRow) {
      position.y += (folderGridPositions.getItemHeight() + folderGridPositions.getColumnGap()) *
        (targetRow - smallFolderRow + 1);
    }

    log.showInfo(`smallFolderItemPosition index=${appIndex}, x=${position.x}, y=${position.y}`);
    return { x: position.x, y: position.y };
  }

  /**
   * 获取大文件夹内图标中心点到父网格左上角的偏移坐标
   * @param folderItem 文件夹信息
   * @param appIndex 图标位置
   *
   * @returns RectangularCoordinates.Point 返回相对屏幕左上角的绝对位置
   */
  public getBigFolderItemPosition(folder: GridLayoutItemInfo, appIndex: number):
    RectangularCoordinates.Point | undefined {
    if (!folder.area) {
      return undefined;
    }
    let folderType = this.getFolderTypeByArea(folder.area);
    let bigFolderColumn = GridLayoutUtil.getCountPerRowInFolder(folder.area);
    let bigFolderRow = GridLayoutUtil.getCountPerColumnInFolder(folder.area);
    let appRow = Math.floor(appIndex / bigFolderColumn);
    let appColumn = appIndex - Math.floor(appIndex / bigFolderColumn) * bigFolderColumn;
    appColumn = RTLUtil.getColumnByRTL(appColumn, bigFolderColumn, 1);
    if (appRow >= bigFolderRow) {
      appRow = bigFolderRow - 1;
      appColumn = RTLUtil.isRTL() ? 0 : bigFolderColumn - 1;
    }
    let folderWidth = this.getWidthByArea(folder.area);
    let folderGridPositions: GridItemPositionUtil | undefined = this.mFolderLayoutMap.get(folderType);
    if (!folderGridPositions) {
      return undefined;
    }
    // 桌面网格，需要加上组件到桌面网格的偏移量
    let position = folderGridPositions.getCenterPosition(
      {
        row: appRow,
        column: appColumn
      },
      folderGridPositions.getPaddingLeft() +
        (this.mDesktopGridItemWidth * folder.area[0] - folderWidth) / NumberConstants.CONSTANT_NUMBER_TWO,
      folderGridPositions.getPaddingTop() + this.mDesktopItemPadding
    );

    // 大文件夹右下角3个堆叠图标单独计算偏移，剩余图标按最后一个堆叠图标位置返回
    let gridItemCnt = bigFolderColumn * bigFolderRow;
    if (appIndex === gridItemCnt - 1) {
      // 第8个图标相对于父组件右下角对齐，堆叠图标有一个缩放，中心点的相对偏移量
      let offset = (1 - StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80) / 2;
      position.x += folderGridPositions.getItemWidth() * offset * RTLUtil.getRTLRate();
      position.y += folderGridPositions.getItemHeight() * offset;
    } else if (appIndex >= gridItemCnt + 1) {
      // 第8个图标相对于父组件左上角对齐，堆叠图标有一个缩放，中心点的相对偏移量
      let offset = (1 - StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80) / 2;
      position.x -= folderGridPositions.getItemWidth() * offset * RTLUtil.getRTLRate();
      position.y -= folderGridPositions.getItemHeight() * offset;
    }

    // 1x2或者2x1大小的大文件夹会因为item的宽高和icon的宽高不一致导致宫格位置计算有偏差，需要在最后计算时补齐
    if ((folderType === FolderType.TYPE_1X2_BIG_FOLDER || folderType === FolderType.TYPE_2X1_BIG_FOLDER) &&
      appIndex <= 2) {
      this.updatePositionFor2x1(position, folderGridPositions, folderType);
    }

    log.showInfo(`bigFolderItemPosition index=${appIndex}, x=${position.x}, y=${position.y}`);
    return { x: position.x, y: position.y };
  }

  private updatePositionFor2x1(position: DragPosition, folderGridPositions: GridItemPositionUtil,
    folderType: number): void {
    let tmpSize:  number[] | undefined = this.mFolderAreaMap.get(folderType);
    if (!tmpSize) {
      return;
    }
    let bigFolderSize: number = FolderStyleManager.getInstance().getFolderAppSize(tmpSize);
    let iconSize: number = Math.round(vp2px(bigFolderSize));
    let itemWidth: number = Math.round(vp2px(folderGridPositions.getItemWidth()));
    let itemHeight: number = Math.round(vp2px(folderGridPositions.getItemHeight()));
    if ((itemWidth - iconSize) > 0 && (itemWidth - iconSize) % 2 !== 0) {
      if (RTLUtil.isRTL()) {
        position.x -= px2vp(0.5);
      } else {
        position.x += px2vp(0.5);
      }
    }
    position.y += px2vp((iconSize - itemHeight) / 2);
  }

  /**
   * 获取文件夹打开态内图标中心点到屏幕左上角的偏移坐标
   * @param appIndex 图标位置
   *
   * @returns RectangularCoordinates.Point 返回相对屏幕左上角的绝对位置
   */
  public getOpenFolderItemPosition(appIndex: number): RectangularCoordinates.Point | undefined {
    let openFolderType = this.isPadOrExpanded ? FolderType.TYPE_4X4_OPEN_FOLDER : FolderType.TYPE_3X4_OPEN_FOLDER;
    let tmpSize: number[] | undefined =  this.mFolderAreaMap.get(openFolderType);
    if (!tmpSize) {
      return undefined;
    }
    let openFolderColumn = tmpSize[0];
    let openFolderRow = tmpSize[1];
    let appRow = Math.floor(appIndex / openFolderColumn);
    let appColumn = appIndex - Math.floor(appIndex / openFolderColumn) * openFolderColumn;
    let gridItemCnt = openFolderRow * openFolderColumn;
    let folderGridPositions: GridItemPositionUtil | undefined = this.mFolderLayoutMap.get(openFolderType);
    if (!folderGridPositions) {
      return undefined;
    }
    let position: DragPosition = { x: 0, y: 0 };
    appColumn = RTLUtil.getColumnByRTL(appColumn, openFolderColumn, 1);
    if (appIndex < gridItemCnt) {
      position = folderGridPositions.getCenterPosition(
        {
          row: appRow,
          column: appColumn
        }
      );
    } else {
      // 4*2和小文件夹超出文件夹打开态网格数量，需要向下继续排列计算
      position = folderGridPositions.getCenterPosition(
        {
          row: openFolderRow - 1,
          column: appColumn
        }
      );
      let position1 = folderGridPositions.getCenterPosition(
        {
          row: openFolderRow - 2,
          column: appColumn
        }
      );
      position.y += (position.y - position1.y) * (appRow - openFolderRow + 1);
    }

    log.showInfo(`openFolderItemPosition: index=${appIndex}, x=${position.x}, y=${position.y}`);
    return { x: position.x, y: position.y };
  }

  /**
   * 获取文件夹元素左上角相对屏幕左上角的位置, 只有编辑模式在用
   * @param folder 文件夹类型GridLayoutItemInfo
   *
   * @returns RectangularCoordinates.Point 返回文件夹相对屏幕的位置
   */
  public getFolderComponentLeftTopPosition(folder: GridLayoutItemInfo): RectangularCoordinates.Point {
    let pos: number[] = GridLayoutUtil.getRealGridItemPosition(folder);
    return { x: pos[0], y: pos[1] };
  }

  /**
   * 获取文件夹元素中心点相对屏幕左上角的位置 正常桌面
   * @param folder 文件夹类型GridLayoutItemInfo
   *
   * @returns RectangularCoordinates.Point 返回文件夹相对屏幕的位置
   */
  public getFolderComponentCenterPosition(folder: GridLayoutItemInfo): number[] {
    return GridLayoutUtil.getRealIconCenterPosition(folder.row ?? 0, folder.column ?? 0, folder.area ?? [],
      folder.page ?? -1);
  }

  /**
   * 获取文件夹当前位置中心点相对屏幕左上角的位置 正常 + 编辑模式
   * @param folder 文件夹类型GridLayoutItemInfo
   *
   * @returns RectangularCoordinates.Point 返回文件夹相对屏幕的位置
   */
  public getCurrentFolderCenterPosition(folder: GridLayoutItemInfo): number[] {
    return GridLayoutUtil.getIconCenterPosition(folder.row ?? 0, folder.column ?? 0, folder.area ?? [],
      folder.page ?? -1);
  }

  /**
   * 根据文件夹宽高判断文件夹类型，只用于大小文件夹折叠态(不用于文件夹打开态)
   * @param area 文件夹宽高
   *
   * @returns FolderType 返回文件夹相对屏幕的位置
   */
  public getFolderTypeByArea(area: number[]): FolderType {
    if (!area || area.length < 1) {
      return FolderType.TYPE_SMALL_FOLDER;
    }
    for (let mEntryp of this.mFolderAreaMap) {
      let key = mEntryp[0];
      let value = mEntryp[1];
      if (ArrayUtils.equalsArr(value, area)) {
        return key;
      }
    }
    return FolderType.TYPE_SMALL_FOLDER;
  }

  /**
   * 根据Area获取宽度
   *
   * @param area 依据的Area
   * @returns 最终的宽度
   */
  public getWidthByArea(area: number[]): number {
    if (area[0] === AreaSpan.SPAN_1.valueOf()) {
      return this.mFolderWidth.get(AreaSpan.SPAN_1) as number;
    } else if (area[0] === AreaSpan.SPAN_2.valueOf()) {
      return this.mFolderWidth.get(AreaSpan.SPAN_2) as number;
    } else {
      return this.mFolderWidth.get(AreaSpan.SPAN_4) as number;
    }
  }

  /**
   * 根据Area获取高度
   *
   * @param area 依据的Area
   * @returns 最终的高度
   */
  public getHeightByArea(area: number[]): number {
    if (area[1] === AreaSpan.SPAN_1.valueOf()) {
      return this.mFolderHeight.get(AreaSpan.SPAN_1) as number;
    } else {
      return this.mFolderHeight.get(AreaSpan.SPAN_2) as number;
    }
  }

  /**
   * 根据行列页获取文件夹内应用的appIndex 待文件夹重构后迁移到common的util里
   * @param appInFolder
   * @returns
   */
  public getItemIndex(appInFolder: GridLayoutItemInfo): number {
    const openFolderType = this.isPadOrExpanded ? FolderType.TYPE_4X4_OPEN_FOLDER : FolderType.TYPE_3X4_OPEN_FOLDER;
    const tmpSize: number[] = this.mFolderAreaMap.get(openFolderType) as number[];
    const colCount = tmpSize[0];
    const rowCount = tmpSize[1];
    return colCount * rowCount * (appInFolder.page ?? 0) + (appInFolder.row ?? 0) * colCount +
      (appInFolder.column ?? 0);
  }

  /**
   * 应用是不是在文件夹内 待文件夹重构后迁移到common的util里
   * @param itemInfo
   * @returns
   */
  public isAppInFolder(app: GridLayoutItemInfo): boolean {
    return app.container !== undefined && app.container !== CommonConstants.CONTAINER_DESKTOP;
  }

  /**
   * 获取文件夹网格行列数
   * @param folderStatus
   * @param folder
   * @returns [rowCount, columnCount]
   */
  public getRowAndColCount(folderStatus: FolderStatus, folder: GridLayoutItemInfo): number[] {
    let folderType: FolderType;
    if (folderStatus === FolderStatus.CLOSE_FOLDER) {
      folderType = this.getFolderTypeByArea(folder.area ?? []);
    } else {
      folderType = this.isPadOrExpanded ? FolderType.TYPE_4X4_OPEN_FOLDER : FolderType.TYPE_3X4_OPEN_FOLDER;
    }
    const tmpSize = this.mFolderAreaMap.get(folderType) as number[];
    const colCount = tmpSize[0];
    const rowCount = tmpSize[1];
    return [rowCount, colCount];
  }

  /**
   * 获取大文件夹中图标到屏幕的距离
   * @param uiContext 用于获取ComponentUtils
   * @param folder 文件夹信息
   * @param openItems 文件夹展开态显示的应用列表
   * @param appIndex 对应图标的索引
   * @returns 对应图标到屏幕的距离
   */
  public getBigFolderItemPoint(uiContext: UIContext, folder: GridLayoutItemInfo, openItems: GridLayoutItemInfo[],
    appIndex: number): RectangularCoordinates.Point | undefined {
    if (!folder.area) {
      return undefined;
    }
    let maxCount: number = GridLayoutUtil.getCountPerPageInFolder(folder.area) + 2;
    let index: number = Math.min(maxCount - 1, appIndex);
    let item: GridLayoutItemInfo = openItems[index];
    let info: componentUtils.ComponentInfo =
      uiContext.getComponentUtils().getRectangleById(this.getFolderItemKey(item, index));
    if (this.isComponentInfoValid(info)) {
      log.showInfo(`getBigFolderItemPoint, index:${appIndex}, x:${info.windowOffset.x}, y:${info.windowOffset.y}`);
      return {
        x: px2vp(info.windowOffset.x + (info.size.width / 2)),
        y: px2vp(info.windowOffset.y + (info.size.height / 2))
      };
    } else {
      log.showError('getBigFolderItemPositionByUi ComponentInfo is null.');
    }
    return undefined;
  }

  /**
   * 获取小文件夹中图标到屏幕的距离
   * @param imagePoint 小文件夹截图与屏幕的距离
   * @param appIndex 对应图标的索引
   * @returns 对应图标到屏幕的距离
   */
  public getSmallFolderItemPoint(imagePoint: RectangularCoordinates.Point,
    appIndex: number): RectangularCoordinates.Point | undefined {
    let index: number = Math.min(MAX_INDEX_SMALL_FOLDER, appIndex);
    let itemCenter: FolderItemCenter | undefined = this.getSmallFolderItemCenter(index);
    if (imagePoint && imagePoint.x > 0 && imagePoint.y > 0 && itemCenter) {
      log.showInfo(`getSmallFolderItemPoint, index:${appIndex}, x:${imagePoint.x + itemCenter.x},` +
        ` y:${imagePoint.y + itemCenter.y}`);
      return {
        x: imagePoint.x + itemCenter.x,
        y: imagePoint.y + itemCenter.y
      };
    } else {
      log.showError('getSmallFolderItemPositionByUi itemCenter is null.');
    }
    return undefined;
  }

  /**
   * 获取文件夹展开态中图标到屏幕的距离
   * @param uiContext 用于获取ComponentUtils
   * @param iconId 对应图标的IconId
   * @returns 展开态中图标到屏幕的距离
   */
  public getOpenFolderItemPoint(uiContext: UIContext, iconId: string): RectangularCoordinates.Point | undefined {
    let info: componentUtils.ComponentInfo = uiContext.getComponentUtils().getRectangleById(`${iconId}`);
    if (this.isComponentInfoValid(info)) {
      log.showInfo(`getOpenFolderItemPoint, id:${iconId}, x:${info.windowOffset.x}, y:${info.windowOffset.y}`);
      return {
        x: px2vp(info.windowOffset.x + (info.size.width / 2)),
        y: px2vp(info.windowOffset.y + (info.size.height / 2))
      };
    } else {
      log.showError('getOpenFolderItemPositionByUi ComponentInfo is null.');
    }
    return undefined;
  }

  /**
   * 设置小文件夹图标到背板的距离
   * @param index 对应图标的索引
   * @param center 图标到背板的距离
   */
  public setSmallFolderItemCenter(index: number, center: FolderItemCenter): void {
    let deskState: DesktopLayoutState =
      AppStorage.get<number>('launcherModel') ?? DesktopLayoutState.HOME_LAUNCHER_MODE;
    let stateMap: Map<number, Map<number, FolderItemCenter>> | undefined =
      this.mSmallFolderItemCenterMap.get(deskState);
    if (!stateMap) {
      stateMap = new Map();
      this.mSmallFolderItemCenterMap.set(deskState, stateMap);
    }
    let rtlState: number = RTLUtil.isRTL() ? 0 : 1;
    let centerMap: Map<number, FolderItemCenter> | undefined = stateMap.get(rtlState);
    if (!centerMap) {
      centerMap = new Map();
      stateMap.set(rtlState, centerMap);
    }
    centerMap.set(index, center);
  }

  private getSmallFolderItemCenter(index: number): FolderItemCenter | undefined {
    let deskState: DesktopLayoutState =
      AppStorage.get<number>('launcherModel') ?? DesktopLayoutState.HOME_LAUNCHER_MODE;
    let rtlState: number = RTLUtil.isRTL() ? 0 : 1;
    return this.mSmallFolderItemCenterMap.get(deskState)?.get(rtlState)?.get(index);
  }

  private isComponentInfoValid(info: componentUtils.ComponentInfo): boolean {
    return info && info.windowOffset.x > 0 && info.windowOffset.y > 0;
  }

  /**
   * 获取文件夹菜单位置判定阈值
   * @param isSmallFolder 是否是小文件夹
   * @returns 文件夹菜单位置判定阈值
   */
  public getMenuPositionThreshold(isSmallFolder: boolean): number {
    return FolderConstants.FOLDER_MENU_POSITION_THRESHOLD;
  }

  /**
   * 获取文件夹网格foreach组件子元素的key
   *
   * @param keyname 应用keyname
   * @param index 图标在列表的index
   * @returns
   */
  public getFolderItemKey(item: GridLayoutItemInfo| FolderAppItemInfo, index: number): string {
    let key: string = CommonConstants.FOLDER_GRID_TAG;
    if (item && !CheckEmptyUtils.isEmpty(item.keyName)) {
      key += `${this.getIconKey(item)}_${index}`;
    } else {
      key += `${KEY_ITEM}_${index}`;
    }
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.appStatus === 0) {
      key = key + '_0';
    }
    return key;
  }

  private getIconKey(item: GridLayoutItemInfo | FolderAppItemInfo): string {
    return `${item.bundleName}${item.moduleName}${item.abilityName}${item.typeId}${item.appIndex}${item.shortcutId}` +
      `${item.installTime}${item.appIconId}${item.appLabelId}`;
  }
}

/**
 * 文件夹类型，如1*1，1*2折叠态和3*4，4*4展开态等
 */
export enum FolderType {
  TYPE_SMALL_FOLDER = 0,
  TYPE_NORMAL_BIG_FOLDER = 1,
  TYPE_1X2_BIG_FOLDER = 2,
  TYPE_2X1_BIG_FOLDER = 3,
  TYPE_4X2_BIG_FOLDER = 4,
  TYPE_3X4_OPEN_FOLDER = 5,
  TYPE_4X4_OPEN_FOLDER = 6,
}

/**
 * 文件夹状态：打开态，关闭态
 */
export enum FolderStatus {
  OPEN_FOLDER = 1,
  CLOSE_FOLDER = 2,
}

class FolderItemCenter {
  public x: number = 0;
  public y: number = 0;
}

export const folderLayoutUtil: FolderLayoutUtil = SingletonHelper.getInstance(FolderLayoutUtil, TAG);