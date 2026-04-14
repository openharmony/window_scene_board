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

import HashMap from '@ohos.util.HashMap';
import { LogDomain, LogHelper, RectItem } from '@ohos/basicutils/src/main/ets/TsIndex';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import GridLayoutItemInfo from '../../../../../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../../../../../constants/CommonConstants';
import { StyleConstants } from '../../../../../../constants/StyleConstants';
import { AppListInfo } from '../../../../../FolderModel';
import { FolderAreaType } from '../../../../../common/FolderConstans';
import { ResizeConfig, ResizeHotArea, ResizePosition, } from '../../../../../common/FolderResizeConstants';
import { FolderCommonUtil } from '../../../../common/FolderCommonUtil';
import { FolderStyleManager } from '../../../../common/FolderStyleManager';
import { ContractedFolderLayoutStyleFactory } from '../style/ContractedFolderLayoutStyleFactory';

/**
 * 拖拽热区点的显示状态
 */
@ObservedV2
export class ResizeBarVisible {
  @Trace public left: boolean;
  @Trace public top: boolean;
  @Trace public right: boolean;
  @Trace public bottom: boolean;

  constructor(left: boolean, top: boolean, right: boolean, bottom: boolean) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }
}

const TAG = 'FolderResizeUtil';
const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const STACK_RATIO: number = StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80;

const leftArea: ResizeHotArea = {
  offsetX: '-50%',
  offsetY: '0%',
  width: 32,
  height: '80%',
  position: ResizePosition.LEFT,
  dragDirection: PanDirection.Horizontal,
  alignContent: Alignment.TopEnd,
};

const leftTopArea: ResizeHotArea = {
  offsetX: '-50%',
  offsetY: '-50%',
  width: 32,
  height: 32,
  position: ResizePosition.LEFT_TOP,
  dragDirection: PanDirection.All,
  alignContent: Alignment.BottomEnd,
};

const topArea: ResizeHotArea = {
  offsetX: '0%',
  offsetY: '-50%',
  width: '80%',
  height: 32,
  position: ResizePosition.TOP,
  dragDirection: PanDirection.Vertical,
  alignContent: Alignment.BottomStart,
};

const rightTopArea: ResizeHotArea = {
  offsetX: '50%',
  offsetY: '-50%',
  width: 32,
  height: 32,
  position: ResizePosition.RIGHT_TOP,
  dragDirection: PanDirection.All,
  alignContent: Alignment.BottomStart,
};

const rightArea: ResizeHotArea = {
  offsetX: '50%',
  offsetY: '0%',
  width: 32,
  height: '80%',
  position: ResizePosition.RIGHT,
  dragDirection: PanDirection.Horizontal,
  alignContent: Alignment.TopStart,
};

const rightBottomArea: ResizeHotArea = {
  offsetX: '50%',
  offsetY: '50%',
  width: 32,
  height: 32,
  position: ResizePosition.RIGHT_BOTTOM,
  dragDirection: PanDirection.All,
  alignContent: Alignment.TopStart,
};

const bottomArea: ResizeHotArea = {
  offsetX: '0%',
  offsetY: '50%',
  width: '80%',
  height: 32,
  position: ResizePosition.BOTTOM,
  dragDirection: PanDirection.Vertical,
  alignContent: Alignment.TopStart,
};

const leftBottomArea: ResizeHotArea = {
  offsetX: '-50%',
  offsetY: '50%',
  width: 32,
  height: 32,
  position: ResizePosition.LEFT_BOTTOM,
  dragDirection: PanDirection.All,
  alignContent: Alignment.TopEnd,
};

const centerRules: AlignRuleOption = {
  center: { anchor: '__container__', align: VerticalAlign.Center },
  middle: { anchor: '__container__', align: HorizontalAlign.Center }
};

const topStartRules: AlignRuleOption = {
  top: { anchor: '__container__', align: VerticalAlign.Top },
  left: { anchor: '__container__', align: HorizontalAlign.Start }
};

const topEndRules: AlignRuleOption = {
  top: { anchor: '__container__', align: VerticalAlign.Top },
  right: { anchor: '__container__', align: HorizontalAlign.End }
};

const bottomStartRules: AlignRuleOption = {
  bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
  left: { anchor: '__container__', align: HorizontalAlign.Start }
};

const bottomEndRules: AlignRuleOption = {
  bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
  right: { anchor: '__container__', align: HorizontalAlign.End }
};

const barVisibleMap: HashMap<ResizePosition, ResizeBarVisible> = new HashMap();
const folderItemParamMap: HashMap<FolderAreaType, FolderIconParam[]> = new HashMap();
const folderAreaMap: HashMap<FolderAreaType, number[]> = new HashMap();
const alignRulesMap: HashMap<ResizePosition, AlignRuleOption> = new HashMap();

export class FolderResizeUtil {
  public static readonly DEFAULT_FOLDER_BORDER_WIDTH: number = 1.5;
  public static readonly HALF: number = 0.5;
  // 拖动变大跟手比例
  public static readonly RATIO_DRAG_OUT: number = 1;
  // 拖动变小跟手比例
  public static readonly RATIO_DRAG_IN: number = 0.5;
  // 变大手指移动临界值比例
  public static readonly RATIO_ADJUST_OUT: number = 0.6;
  // 变小手指移动临界值比例
  public static readonly RATIO_ADJUST_IN: number = 0.5;
  // 回弹比例
  public static readonly RATIO_REBOUND: number = 0.5;
  // Grid放大时gap比例
  public static readonly RATIO_GAP_OUT: number = 0.1;
  // Grid缩小时gap比例
  public static readonly RATIO_GAP_IN: number = 0.25;
  public static readonly RATIO_GAP_IN_4x2: number = 0.1;
  public static readonly AREA_NONE: ResizeHotArea = {
    offsetX: '0%',
    offsetY: '0%',
    width: '0%',
    height: '0%',
    position: ResizePosition.NONE,
    dragDirection: PanDirection.All,
    alignContent: Alignment.TopStart,
  };
  public static readonly HOT_AREA_LIST: ResizeHotArea[] = [
    leftArea,
    topArea,
    rightArea,
    bottomArea,
    leftTopArea,
    rightTopArea,
    rightBottomArea,
    leftBottomArea
  ];
  public static readonly HOT_AREA_SIDE_WIDTH: number = leftArea.width as number;
  public static readonly HOT_AREA_SIDE_HEIGHT: number = topArea.height as number;
  static {
    barVisibleMap.set(ResizePosition.NONE, new ResizeBarVisible(true, true, true, true));
    barVisibleMap.set(ResizePosition.LEFT, new ResizeBarVisible(true, false, false, false));
    barVisibleMap.set(ResizePosition.LEFT_TOP, new ResizeBarVisible(true, true, false, false));
    barVisibleMap.set(ResizePosition.TOP, new ResizeBarVisible(false, true, false, false));
    barVisibleMap.set(ResizePosition.RIGHT_TOP, new ResizeBarVisible(false, true, true, false));
    barVisibleMap.set(ResizePosition.RIGHT, new ResizeBarVisible(false, false, true, false));
    barVisibleMap.set(ResizePosition.RIGHT_BOTTOM, new ResizeBarVisible(false, false, true, true));
    barVisibleMap.set(ResizePosition.BOTTOM, new ResizeBarVisible(false, false, false, true));
    barVisibleMap.set(ResizePosition.LEFT_BOTTOM, new ResizeBarVisible(true, false, false, true));
    folderAreaMap.set(FolderAreaType.AREA_1x1, [1, 1]);
    folderAreaMap.set(FolderAreaType.AREA_1x2, [1, 2]);
    folderAreaMap.set(FolderAreaType.AREA_2x1, [2, 1]);
    folderAreaMap.set(FolderAreaType.AREA_2x2, [2, 2]);
    folderAreaMap.set(FolderAreaType.AREA_4x2, [4, 2]);
    alignRulesMap.set(ResizePosition.LEFT, topEndRules);
    alignRulesMap.set(ResizePosition.RIGHT, topStartRules);
    alignRulesMap.set(ResizePosition.TOP, bottomStartRules);
    alignRulesMap.set(ResizePosition.BOTTOM, topStartRules);
    alignRulesMap.set(ResizePosition.LEFT_TOP, bottomEndRules);
    alignRulesMap.set(ResizePosition.LEFT_BOTTOM, topEndRules);
    alignRulesMap.set(ResizePosition.RIGHT_TOP, bottomStartRules);
    alignRulesMap.set(ResizePosition.RIGHT_BOTTOM, topStartRules);
  }

  /**
   * 根据当前拖拽热区获取所有拖拽热区点的显示状态
   *
   * @param position 当前拖拽热区
   * @returns 所有拖拽热区点的显示状态
   */
  public static getBarVisible(position: ResizePosition): ResizeBarVisible {
    return barVisibleMap.get(position);
  }

  /**
   * 根据当前拖拽热区获取布局的对齐方式
   *
   * @param position 当前拖拽热区
   * @returns
   */
  public static getAlignRules(position: ResizePosition): AlignRuleOption {
    return alignRulesMap.get(position) ?? centerRules;
  }

  /**
   * 根据文件夹大小获取文件夹大小类型
   *
   * @param area 文件夹大小
   * @param isRtl 是否镜像
   * @returns 文件夹大小类型
   */
  public static getFolderAreaType(area: number[], isRtl: boolean = false): FolderAreaType {
    let spanX: number = FolderCommonUtil.getModifyAreaWidth(area[0]);
    let spanY: number = FolderCommonUtil.getModifyAreaHeight(area[1]);
    return FolderAreaType[`AREA_${spanX}x${spanY}${isRtl ? '_Rtl' : ''}`];
  }

  /**
   * 根据文件夹大小类型获取文件夹大小
   *
   * @param areaType 文件夹大小类型
   * @returns 文件夹大小
   */
  public static getFolderArea(areaType: FolderAreaType): number[] {
    return folderAreaMap.get(areaType);
  }

  /**
   * 获取左热区信息
   * @returns
   */
  public static getLeftHotArea(): ResizeHotArea {
    return leftArea;
  }

  /**
   * 获取上热区信息
   * @returns
   */
  public static getTopHotArea(): ResizeHotArea {
    return topArea;
  }

  /**
   * 获取右热区信息
   * @returns
   */
  public static getRightHotArea(): ResizeHotArea {
    return rightArea;
  }

  /**
   * 获取下热区信息
   * @returns
   */
  public static getBottomHotArea(): ResizeHotArea {
    return bottomArea;
  }

  /**
   * 判断区域内有没有重叠的其他元素
   * @param toConfig 最终缩放信息
   * @param fromConfig 当前文件夹对象
   * @returns 结果
   */
  public static canResizeTo(toConfig: ResizeConfig, fromConfig: ResizeConfig, folderId: string): boolean {
    let newRect: RectItem = new RectItem(toConfig.column, toConfig.row,
      toConfig.column + toConfig.area[0], toConfig.row + toConfig.area[1]);
    let rowCount: number = FolderStyleManager.getInstance().getDesktopRowCount();
    if (newRect.top < 0 || newRect.bottom > rowCount) {
      LOG.showInfo('canResizeTo false: out size of y.');
      return false;
    }
    let columnCount: number = FolderStyleManager.getInstance().getDesktopColumnCount();
    if (newRect.left < 0 || newRect.right > columnCount) {
      LOG.showInfo('canResizeTo false: out size of x.');
      return false;
    }

    let pageIndex: number = fromConfig.page as number;
    let appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
    let pageDeskItems: GridLayoutItemInfo[] = appListInfo.appGridInfo[pageIndex] ?? [];
    for (let deskItem of pageDeskItems) {
      if (deskItem.typeId === CommonConstants.TYPE_FOLDER && deskItem.folderId === folderId) {
        continue;
      }
      if (deskItem.area?.[0] === fromConfig.area?.[0] && deskItem.area?.[1] === fromConfig.area?.[1] &&
        deskItem.row === fromConfig.row && deskItem.column === fromConfig.column) {
        continue;
      }
      let itemColumn = deskItem.column as number;
      let itemRow = deskItem.row as number;
      let itemEndColumn = itemColumn + (deskItem.area as number[])[0];
      let itemEndRow = itemRow + (deskItem.area as number[])[1];
      let itemRect: RectItem = new RectItem(itemColumn, itemRow, itemEndColumn, itemEndRow);
      if (RectItem.intersects(newRect, itemRect) || newRect.containsRect(itemRect)) {
        LOG.showInfo(`canResizeTo false: page${pageIndex} ${deskItem.keyName} ${itemRect.toString()}`);
        return false;
      }
    }
    return true;
  }

  /**
   * 获取文件夹边框间距
   * @param area 文件夹大小
   * @param isLeftOrRight 是否左右间距
   * @returns
   */
  public static getFolderPadding(area: number[], isLeftOrRight: boolean): number {
    return ContractedFolderLayoutStyleFactory.getInstance().getStyleByArea(area).getPadding(isLeftOrRight);
  }

  /**
   * 获取文件夹列间距
   * @param area 文件夹大小
   * @returns 文件夹列间距
   */
  public static getColumnGap(area: number[]): number {
    return ContractedFolderLayoutStyleFactory.getInstance().getStyleByArea(area).getColumnGap();
  }

  /**
   * 获取文件夹行间距
   * @param area 文件夹大小
   * @returns 文件夹列间距
   */
  public static getRowGap(area: number[]): number {
    return ContractedFolderLayoutStyleFactory.getInstance().getStyleByArea(area).getRowGap();
  }

  /**
   * 根据文件夹大小获取其各图标的相对位置、大小等信息
   *
   * @param area 文件夹大小
   * @param isRtl 是否镜像
   * @returns 图标信息列表
   */
  public static getGridItemParamByArea(area: number[], isRtl: boolean = false): FolderIconParam[] {
    let areaType: FolderAreaType = FolderResizeUtil.getFolderAreaType(area, isRtl);
    if (!folderItemParamMap.hasKey(areaType)) {
      folderItemParamMap.set(areaType, FolderResizeUtil.initGridItemsParam(area, isRtl));
    }
    return folderItemParamMap.get(areaType);
  }

  /**
   * 获取对应文件夹中item的动画属性
   *
   * @param area 文件夹大小
   * @param isRtl 是否镜像
   * @returns 文件夹中item的动画属性
   */
  private static initGridItemsParam(area: number[], isRtl: boolean = false): FolderIconParam[] {
    let showCount: number = FolderCommonUtil.getShowIconNumWithoutSuperpose(area);
    let itemsParam: FolderIconParam[] = FolderResizeUtil.getShowItemsParam(area, showCount, isRtl);
    return itemsParam;
  }

  /**
   * 获取对应文件夹中完整显示的item的动画属性
   *
   * @param area 文件夹大小
   * @param count item个数
   * @param isRtl 是否镜像
   * @returns 完整显示的item的动画属性
   */
  private static getShowItemsParam(area: number[], count: number, isRtl: boolean = false): FolderIconParam[] {
    let columnCount: number = FolderStyleManager.getInstance().getCountPerRowInFolder(area);
    let columnGap: number = FolderResizeUtil.getColumnGap(area);
    let rowGap: number = FolderResizeUtil.getRowGap(area);
    let paddingLeft: number = FolderResizeUtil.getFolderPadding(area, true);
    let paddingTop: number = FolderResizeUtil.getFolderPadding(area, false);
    let folderAppSize: number = FolderStyleManager.getInstance().getFolderAppSize(area);
    let itemParamArray: FolderIconParam[] = [];
    for (let i = 0; i < count; i++) {
      let columnIndex: number = i % columnCount;
      if (isRtl) {
        columnIndex = RTLUtil.getColumnByRTL(columnIndex, columnCount, 1);
      }
      let rowIndex: number = Math.floor(i / columnCount);
      let param: FolderIconParam = new FolderIconParam();
      param.x = columnIndex * folderAppSize + columnIndex * columnGap + paddingLeft +
        folderAppSize * FolderResizeUtil.HALF;
      param.y = rowIndex * folderAppSize + rowIndex * rowGap + paddingTop + folderAppSize * FolderResizeUtil.HALF;
      param.size = folderAppSize;
      param.isShowMask = false;
      param.maskOpacity = 0;
      param.opacity = 1;
      itemParamArray.push(param);
    }
    return itemParamArray;
  }

  /**
   * 获取对应文件夹中堆叠显示的item的位置
   *
   * @param area 文件夹大小
   * @param count item个数
   * @param startIndex 堆叠图标在文件夹中的索引
   * @param isRtl 是否镜像
   * @returns
   */
  private static getStackItemsParam(area: number[], count: number, startIndex: number, isRtl: boolean = false):
    FolderIconParam[] {
    let columnCount: number = FolderStyleManager.getInstance().getCountPerRowInFolder(area);
    let columnIndex: number = startIndex % columnCount;
    let rowIndex: number = Math.floor(startIndex / columnCount);
    let columnGap: number = FolderResizeUtil.getColumnGap(area);
    let rowGap: number = FolderResizeUtil.getRowGap(area);
    let paddingLeft: number = FolderResizeUtil.getFolderPadding(area, true);
    let paddingTop: number = FolderResizeUtil.getFolderPadding(area, false);
    let folderAppSize: number = FolderStyleManager.getInstance().getFolderAppSize(area);
    let tempParam: FolderIconParam = new FolderIconParam();
    tempParam.x = (isRtl ? 0 : (columnIndex * folderAppSize + columnIndex * columnGap)) + paddingLeft +
      folderAppSize * FolderResizeUtil.HALF;
    tempParam.y = rowIndex * folderAppSize + rowIndex * rowGap + paddingTop + folderAppSize * FolderResizeUtil.HALF;
    let offset: number = folderAppSize * (1 - STACK_RATIO) * FolderResizeUtil.HALF;
    let itemParamArray: FolderIconParam[] = [];
    for (let i = count - 1; i >= 0; i--) {
      let param: FolderIconParam = new FolderIconParam();
      param.x = tempParam.x + (i - 1) * offset * (isRtl ? -1 : 1);
      param.y = tempParam.y + (i - 1) * offset;
      param.size = folderAppSize * STACK_RATIO;
      param.opacity = 1;
      if (i === 2) {
        param.isShowMask = false;
        param.maskOpacity = 0;
      } else if (i === 0) {
        param.isShowMask = true;
        param.maskOpacity = 1;
        param.maskBgColor = StyleConstants.FOLDER_LAST_THREE_APP_FIRST_MASK;
      } else {
        param.isShowMask = true;
        param.maskOpacity = 1;
        param.maskBgColor = StyleConstants.FOLDER_LAST_THREE_APP_SECOND_MASK;
      }
      itemParamArray.push(param);
    }
    return itemParamArray;
  }

  public static release(): void {
    folderItemParamMap.clear();
  }

  /**
   * 获取热区宽度,Dock区小文件夹不存在热区
   *
   * @param isDock 是否是Dock区
   * @returns 热区宽度
   */
  public static getHotAreaSideWidth(isInDock: boolean): number {
    return isInDock ? 0 : FolderResizeUtil.HOT_AREA_SIDE_WIDTH;
  }

  /**
   * 获取热区高度,Dock区小文件夹不存在热区
   *
   * @param isDock 是否是Dock区
   * @returns 热区高度
   */
  public static getHotAreaSideHeight(isInDock: boolean): number {
    return isInDock ? 0 : FolderResizeUtil.HOT_AREA_SIDE_HEIGHT;
  }
}

export class FolderIconParam {
  public x: number = 0;
  public y: number = 0;
  public size: number = 0;
  public opacity: number = 1;
  public isShowMask: boolean = false;
  public maskOpacity: number = 0;
  public maskBgColor: string = '#00000000';
}