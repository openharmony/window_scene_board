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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper, RectItem } from '@ohos/basicutils';
import { desktopUtil, ObjectCopyUtil, RTLUtil } from '@ohos/componenthelper';
import { FormViewModel } from '@ohos/form';
import {
  AppListInfo,
  CardItemInfo,
  CommonConstants,
  editModeManager,
  EditModeUtils,
  GridLayoutItemInfo } from '@ohos/launchercommon';
import { PageDesktopViewModel } from '../../../viewmodel/PageDesktopViewModel';
import {
  AreaOffset,
  CheckZoomResult,
  ZoomHotArea,
  ZoomOffset,
  ZoomPosition,
  ZoomType,
  FormZoomTargetArea,
  Directions,
} from './FormZoomCommonType';
import {
  LEFT_AREA,
  RIGHT_AREA,
  TOP_AREA,
  BOTTOM_AREA,
  LEFT_BOTTOM_AREA,
  LEFT_TOP_AREA,
  RIGHT_BOTTOM_AREA,
  RIGHT_TOP_AREA,
  THEME_CARD_ZOOM_IN_MAP,
  THEME_CARD_ZOOM_IN_ALIGN_MAP,
  THEME_CARD_ZOOM_OUT_MAP,
  THEME_CARD_ZOOM_OUT_ALIGN_MAP,
  THEME_CARD_ALIGN_DEFAULT_MAP,
  ALIGN_RTL_MAP,
  NORMAL_CARD_ZOOM_IN_ALIGN_MAP,
  NORMAL_CARD_ZOOM_OUT_ALIGN_MAP,
  NORMAL_CARD_ZOOM_IN_MAP,
  NORMAL_CARD_ZOOM_OUT_MAP,
  NORMAL_CARD_ALIGN_DEFAULT_MAP,
} from './FormZoomConstants';

const TAG = 'FormZoomUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FormZoomUtil {
  public static readonly AREA_NONE: ZoomHotArea = {
    offsetX: '0%',
    offsetY: '0%',
    width: '0%',
    height: '0%',
    position: ZoomPosition.NONE,
  };

  public static readonly HOT_AREA_LIST: ZoomHotArea[] = [
    LEFT_AREA,
    LEFT_TOP_AREA,
    TOP_AREA,
    RIGHT_TOP_AREA,
    RIGHT_AREA,
    RIGHT_BOTTOM_AREA,
    BOTTOM_AREA,
    LEFT_BOTTOM_AREA,
  ];

  /**
   * 根据拖拽热区位置和坐标偏移判断放缩类型
   *
   * @param zoomPosition 拖拽热区位置
   * @param offsetX 横向坐标偏移
   * @param offsetX 纵向坐标偏移
   * @returns ZoomType 放缩类型
   */
  public static getZoomType(zoomPosition: ZoomPosition, offsetX: number, offsetY: number): ZoomType {
    let zoomType: ZoomType = ZoomType.ZOOM_IN;
    switch (zoomPosition) {
      case ZoomPosition.LEFT:
      case ZoomPosition.LEFT_TOP:
      case ZoomPosition.LEFT_BOTTOM:
        zoomType = offsetX > 0 ? ZoomType.ZOOM_IN : ZoomType.ZOOM_OUT;
        break;
      case ZoomPosition.RIGHT:
      case ZoomPosition.RIGHT_TOP:
      case ZoomPosition.RIGHT_BOTTOM:
        zoomType = offsetX < 0 ? ZoomType.ZOOM_IN : ZoomType.ZOOM_OUT;
        break;
      case ZoomPosition.TOP:
        zoomType = offsetY > 0 ? ZoomType.ZOOM_IN : ZoomType.ZOOM_OUT;
        break;
      case ZoomPosition.BOTTOM:
        zoomType = offsetY < 0 ? ZoomType.ZOOM_IN : ZoomType.ZOOM_OUT;
        break;
      default:
        break;
    }
    return zoomType;
  }

  /**
   * 根据拖拽热区位置和坐标偏移获取卡片放缩偏移量
   *
   * @param zoomPosition 拖拽热区位置
   * @param offsetX 横向坐标偏移
   * @param offsetX 纵向坐标偏移
   * @returns ZoomOffset 卡片放缩偏移量
   */
  public static getOffset(zoomPosition: ZoomPosition, offsetX: number, offsetY: number): ZoomOffset {
    let zoomOffset: ZoomOffset = {
      offsetX: 0,
      offsetY: 0,
    }
    switch (zoomPosition) {
      case ZoomPosition.LEFT:
        zoomOffset.offsetX = -offsetX;
        break;
      case ZoomPosition.RIGHT:
        zoomOffset.offsetX = offsetX;
        break;
      case ZoomPosition.TOP:
        zoomOffset.offsetY = -offsetY;
        break;
      case ZoomPosition.BOTTOM:
        zoomOffset.offsetY = offsetY;
        break;
      case ZoomPosition.LEFT_TOP:
        zoomOffset.offsetX = -offsetX;
        zoomOffset.offsetY = -offsetY;
        break;
      case ZoomPosition.RIGHT_TOP:
        zoomOffset.offsetX = offsetX;
        zoomOffset.offsetY = -offsetY;
        break;
      case ZoomPosition.RIGHT_BOTTOM:
        zoomOffset.offsetX = offsetX;
        zoomOffset.offsetY = offsetY;
        break;
      case ZoomPosition.LEFT_BOTTOM:
        zoomOffset.offsetX = -offsetX;
        zoomOffset.offsetY = offsetY;
        break;
      default:
        break;
    }
    return zoomOffset;
  }

  /**
   * 根据拖拽热区位置和放缩类型以及卡片位置信息判断是否能放缩
   *
   * @param zoomPosition 拖拽热区位置
   * @param zoomType 放缩类型
   * @param cardItem 卡片信息
   * @returns ZoomOffset 卡片放缩偏移量
   */
  public static checkZoom(zoomPosition: ZoomPosition, zoomType: ZoomType, cardItem: CardItemInfo): CheckZoomResult {
    let targetAreaList: FormZoomTargetArea[] = FormZoomUtil.getZoomTargetArea(zoomPosition, zoomType, cardItem);
    return {
      zoomType,
      targetAreaList
    };
  }

  public static getTargetCardDimension(curWidth: number, curHeight: number, dimensions: number[]): number {
    let distance: number = Infinity;
    let targetDimension: number = dimensions[0];
    for (const dimension of dimensions) {
      let width: number = FormViewModel.getInstance().getFormStyleConfig()
        .mFormWidth.get(String(dimension)) as number;
      let height: number = FormViewModel.getInstance().getFormStyleConfig()
        .mFormHeight.get(String(dimension)) as number;
      if (editModeManager.isInEditMode()) {
        width = EditModeUtils.convertWithDesktopScale(width);
        height = EditModeUtils.convertWithDesktopScale(height);
      }
      let curDistance: number = (curWidth - width) * (curWidth - width) + (curHeight - height) * (curHeight - height);
      if (curDistance < distance) {
        distance = curDistance;
        targetDimension = dimension;
      }
    }
    return targetDimension;
  }

  /**
   * 根据拖拽热区位置和放缩类型以及卡片位置信息获取最终目标区域
   *
   * @param zoomPosition 拖拽热区位置
   * @param zoomType 放缩类型
   * @param cardItem 卡片信息
   * @returns FormZoomTargetArea 最终目标区域
   */
  public static getZoomTargetArea(zoomPosition: ZoomPosition, zoomType: ZoomType,
    cardItem: CardItemInfo): FormZoomTargetArea[] {
    let alignContents: Alignment[];
    log.showInfo(`getZoomTargetArea----cardItem.bundleName:${cardItem.bundleName},---zoomPosition:${zoomPosition},cardItem.cardDimension: ${cardItem.cardDimension}`)
    if (cardItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      if (zoomType === ZoomType.ZOOM_IN) {
        alignContents = THEME_CARD_ZOOM_IN_ALIGN_MAP.get(zoomPosition)?.get(cardItem.cardDimension) ||
          [THEME_CARD_ALIGN_DEFAULT_MAP.get(zoomPosition) as Alignment];
      } else {
        alignContents = THEME_CARD_ZOOM_OUT_ALIGN_MAP.get(zoomPosition)?.get(cardItem.cardDimension) ||
          [THEME_CARD_ALIGN_DEFAULT_MAP.get(zoomPosition) as Alignment];
      }
    } else {
      if (zoomType === ZoomType.ZOOM_IN) {
        alignContents = NORMAL_CARD_ZOOM_IN_ALIGN_MAP.get(zoomPosition)?.get(cardItem.cardDimension) ||
          [NORMAL_CARD_ALIGN_DEFAULT_MAP.get(zoomPosition) as Alignment];
      } else {
        alignContents = NORMAL_CARD_ZOOM_OUT_ALIGN_MAP.get(zoomPosition)?.get(cardItem.cardDimension) ||
          [NORMAL_CARD_ALIGN_DEFAULT_MAP.get(zoomPosition) as Alignment];
        alignContents = FormZoomUtil.getTempAligContents(alignContents, cardItem)
      }
    }

    // 如果是左右镜像模式, 左右热区的卡片对齐方式需要校正
    if (RTLUtil.isRTL() && zoomPosition !== ZoomPosition.TOP && zoomPosition !== ZoomPosition.BOTTOM) {
      alignContents = alignContents.map(alignContent => {
        return ALIGN_RTL_MAP.get(alignContent) as Alignment;
      })
    }
    return FormZoomUtil.calcTargetArea(alignContents, zoomType, cardItem);
  }

  /**
   * 暂时通过特殊判断来改变
   * */
  private static getTempAligContents(alignContents: Alignment[], cardItem: CardItemInfo): Alignment[] {
    // const itemRow = cardItem.row ?? 0
    const itemColum = cardItem.column ?? 0
    let area: number[] | undefined = cardItem.area ?? [0, 0]
    let right = itemColum + area[0]
    // let botton = itemRow + area[1]
    let columnCount: number = PageDesktopViewModel.getInstance().getPageDesktopStyleConfig().mColumns;
    // let rowCount: number = PageDesktopViewModel.getInstance().getPageDesktopStyleConfig().mRows;
    log.showInfo(`getTempAligContents----itemColum:${itemColum}, right:${right}, area:${JSON.stringify(area)}`)
    let tempAlignContents: Alignment[] = []
    for (const alignContent of alignContents) {
      if (itemColum > 0 && right < columnCount && (alignContent === Alignment.BottomStart || alignContent === Alignment.BottomEnd)) {
        tempAlignContents.push(Alignment.Bottom)
      } else if (itemColum > 0 && right < columnCount && (alignContent === Alignment.TopStart || alignContent === Alignment.TopEnd)) {
        tempAlignContents.push(Alignment.Top)
      } else {
        tempAlignContents.push(alignContent)
      }
    }
    return tempAlignContents
  }

  /**
   * 根据卡片对齐方式和放缩类型以及卡片位置信息计算最终目标区域
   *
   * @param alignContents 卡片对齐方式
   * @param zoomType 放缩类型
   * @param cardItem 卡片信息
   * @returns FormZoomTargetArea 最终目标区域
   */
  public static calcTargetArea(alignContents: Alignment[], zoomType: ZoomType,
    cardItem: CardItemInfo): FormZoomTargetArea[] {
    let tempAreaList: FormZoomTargetArea[] = [];
    let isTheme: boolean = cardItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE;
    let zoomInMap: Map<string, AreaOffset[]> = isTheme ? THEME_CARD_ZOOM_IN_MAP : NORMAL_CARD_ZOOM_IN_MAP;
    let zoomOutMap: Map<string, AreaOffset[]> = isTheme ? THEME_CARD_ZOOM_OUT_MAP : NORMAL_CARD_ZOOM_OUT_MAP;

    if (zoomType === ZoomType.ZOOM_IN) {
      for (let alignContent of alignContents) {
        let key = alignContent + '_' + cardItem.cardDimension;
        let areaOffsetList: AreaOffset[] | undefined = zoomInMap.get(key);
        if (!areaOffsetList) {
          continue;
        }
        for (const areaOffset of areaOffsetList) {
          tempAreaList.push({
            canZoom: true,
            row: (cardItem.row ?? 0) + areaOffset.rowOffset,
            column: (cardItem.column ?? 0) + areaOffset.columnOffset,
            area: areaOffset.area,
            alignContent: alignContent,
            cardDimension: areaOffset.cardDimension,
          })
        }
      }
    } else {
      for (const alignContent of alignContents) {
        let key = alignContent + '_' + cardItem.cardDimension;
        let areaOffsetList: AreaOffset[] | undefined = zoomOutMap.get(key);
        if (!areaOffsetList) {
          continue;
        }
        for (const areaOffset of areaOffsetList) {
          let tempArea: FormZoomTargetArea = {
            canZoom: false,
            row: (cardItem.row ?? 0) + areaOffset.rowOffset,
            column: (cardItem.column ?? 0) + areaOffset.columnOffset,
            area: areaOffset.area,
            alignContent: alignContent,
            cardDimension: areaOffset.cardDimension,
          };
          if (FormZoomUtil.canZoomTo(tempArea, cardItem)) {
            tempArea.canZoom = true;
            tempArea.alignContent = alignContent;
            tempArea.cardDimension = areaOffset.cardDimension;
            tempAreaList.push(tempArea);
          }
        }
      }
    }
    return tempAreaList;
  }

  /**
   * 判断区域内有无重叠元素, 能否进行扩展
   *
   * @param targetArea 目标区域
   * @param item 当前卡片对象
   * @returns boolean
   */
  public static canZoomTo(targetArea: FormZoomTargetArea, cardItem: CardItemInfo): boolean {
    let newRect: RectItem = new RectItem(targetArea.column, targetArea.row,
      targetArea.column + targetArea.area[0], targetArea.row + targetArea.area[1]);
    let rowCount: number = PageDesktopViewModel.getInstance().getPageDesktopStyleConfig().mRows;
    if (newRect.top < 0 || newRect.bottom > rowCount) {
      log.showInfo('canZoomTo false: out size of y.');
      return false;
    }
    let columnCount: number = PageDesktopViewModel.getInstance().getPageDesktopStyleConfig().mColumns;
    if (newRect.left < 0 || newRect.right > columnCount) {
      log.showInfo('canZoomTo false: out size of x.');
      return false;
    }
    log.showInfo(`row count: ${rowCount}, column count: ${columnCount}`);
    let pageIndex: number = cardItem.page as number;
    let appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
    let pageDeskItems: GridLayoutItemInfo[] = appListInfo.appGridInfo[pageIndex] ?? [];
    for (let deskItem of pageDeskItems) {
      if (deskItem.typeId === CommonConstants.TYPE_CARD && deskItem.cardId === cardItem.cardId) {
        continue;
      }
      if (deskItem.area?.[0] === cardItem.area?.[0] && deskItem.area?.[1] === cardItem.area?.[1] &&
        deskItem.row === cardItem.row && deskItem.column === cardItem.column) {
        continue;
      }
      let itemColumn = deskItem.column as number;
      let itemRow = deskItem.row as number;
      let itemEndColumn = itemColumn + (deskItem.area as number[])[0];
      let itemEndRow = itemRow + (deskItem.area as number[])[1];
      let itemRect: RectItem = new RectItem(itemColumn, itemRow, itemEndColumn, itemEndRow);
      if (RectItem.intersects(newRect, itemRect) || newRect.containsRect(itemRect)) {
        log.showInfo(`canZoomTo false: page${pageIndex} ${itemRect.toString()} in ${newRect.toString()}`);
        return false;
      }
    }
    return true;
  }

  public static getValidRegion(image: image.PixelMap, formSize: Size | undefined): image.Region | undefined {
    if (!formSize) {
      log.showWarn('no form size');
      return undefined;
    }
    try {
      const size: Size = image.getImageInfoSync().size;
      const width: number = size.width;
      const height: number = size.height;
      if (formSize.width <= 0 || formSize.height <= 0 || width <= 0 || height <= 0) {
        log.showWarn(`wrong size, formSize width: ${formSize.width}, formSize height: ${formSize.height}, snapshot width: ${width}, snapshot height: ${height}`);
        return undefined;
      }
      let finalWidth: number;
      let finalHeight: number;
      if (width / height > formSize.width / formSize.height) {
        finalWidth = formSize.width * height / formSize.height;
        finalHeight = height;
        log.showInfo(`getValidRegion, width: ${width}, height: ${height}, finalWidth: ${finalWidth}, finalHeight: ${finalHeight}`);
        return {
          size: {
            width: finalWidth,
            height: finalHeight
          },
          x: (width - finalWidth) / 2,
          y: 0
        }
      } else {
        finalHeight = formSize.height * width / formSize.width;
        finalWidth = width;
        log.showInfo(`getValidRegion, width: ${width}, height: ${height}, finalWidth: ${finalWidth}, finalHeight: ${finalHeight}`);
        return {
          size: {
            width: finalWidth,
            height: finalHeight
          },
          x: 0,
          y: (height - finalHeight) / 2
        }
      }
    } catch (err) {
      log.showError(`getValidRegion failed, ${err?.code}, ${err?.message}`);
      return undefined;
    }
  }

  public static getBoundary(pixels: Uint32Array, width: number, height: number, direction: Directions): number {
    const isHorizontal: boolean = direction === Directions.LEFT || direction === Directions.RIGHT;
    const start: number = direction === Directions.LEFT || direction === Directions.TOP ? 0 : width - 1;
    const end: number = direction === Directions.RIGHT || direction === Directions.BOTTOM ? -1 : width;
    const step: number = direction === Directions.LEFT || direction === Directions.TOP ? 1 : -1;
    const midValue: number = isHorizontal ? Math.floor(height / 2) : Math.floor(width / 2);

    for (let i = start; i !== end; i += step) {
      for (let j = midValue; j >= 0; j--) {
        const index = isHorizontal ? j * width + i : i * width + j;
        const mirrorIndex = isHorizontal ? (height - 1 - j) * width + i : i * width + (width - 1 - j);
        if (FormZoomUtil.checkTransparency(pixels[index]) || FormZoomUtil.checkTransparency(pixels[mirrorIndex])) {
          return i;
        }
      }
    }
    if (direction === Directions.LEFT) {
      return width;
    }
    if (direction === Directions.TOP) {
      return height;
    }
    return 0;
  }

  public static checkTransparency(argb: number): boolean {
    return (argb >>> 24) >= 40;
  }
}