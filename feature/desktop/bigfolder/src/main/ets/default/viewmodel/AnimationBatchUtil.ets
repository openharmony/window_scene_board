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

import { ArrayUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import {
  FolderLayoutInOpen,
  FolderModel,
  GridLayoutItemInfo,
  RecentBundleMissionInfo,
  ResidentLayoutCacheMgr,
  SettingsModel,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FolderType } from '../model/AnimationParameterModel';

const TAG: string = 'AnimationBatchUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 3 * 4 段落式展开矩阵, 不同的数字对应不同的层次
 * 0: 左上, 1: 右上, 2: 左下, 3: 右下
 */
const SMALL_FOLDER_EXPANSION_MATRIX_3X4: number[][] = [
  [5, 4, 3, 4, 3, 2, 3, 2, 1, 2, 1, 1],
  [3, 4, 5, 2, 3, 4, 1, 2, 3, 1, 1, 2],
  [3, 2, 1, 4, 3, 2, 5, 4, 3, 6, 5, 4],
  [1, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5, 6],
];
const BIG_FOLDER_EXPANSION_MATRIX_3X4: number[][] = [
  [5, 4, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1],
  [3, 4, 5, 2, 3, 4, 1, 2, 3, 1, 2, 2],
  [3, 2, 1, 4, 3, 2, 5, 4, 3, 6, 5, 4],
  [1, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5, 6],
];

/**
 * 4 * 2 大文件夹直板机场景无论在哪个方位都只按一种秩序进行动效
 */
const BIG_4x2_FOLDER_EXPANSION_MATRIX_3X4: number[] = [1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2, 2, 2];

const BIG_4X2_FOLDER_ICON_NAME_EXPANSION_MATRIX_3X4: number[] =
  [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4];

/**
 * 4 * 4 段落式展开矩阵, 不同的数字对应不同的层次
 */
const FOLDER_EXPANSION_MATRIX_4x4: number[][] = [
  [6, 6, 5, 4, 6, 5, 4, 3, 5, 4, 3, 2, 4, 3, 2, 1],
  [4, 5, 6, 6, 2, 4, 5, 6, 2, 3, 4, 5, 1, 2, 3, 4],
  [4, 3, 2, 1, 5, 4, 3, 2, 6, 5, 4, 3, 6, 6, 4, 3],
  [1, 2, 3, 4, 2, 3, 4, 5, 3, 4, 5, 6, 4, 5, 6, 6],
];

/**
 * 4 * 4 无秩序感
 */
const FOLDER_EXPANSION_MATRIX_4X4_NO_SEQUENCE: number[][] = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
];

/**
 * 文件夹打开关闭动效秩序感批次计算类
 */
export class AnimationBatchUtil {
  private mOptIconIndexMap = new Map<FolderType, number>([
    [FolderType.TYPE_SMALL_FOLDER, 9],
    [FolderType.TYPE_NORMAL_BIG_FOLDER, 11],
    [FolderType.TYPE_2X1_BIG_FOLDER, 5],
    [FolderType.TYPE_1X2_BIG_FOLDER, 5],
    [FolderType.TYPE_4X2_BIG_FOLDER, 12],
  ]);

  public getFolderType(area: number[]): FolderType {
    if (ArrayUtils.equalsArr(area, [1, 1])) {
      return FolderType.TYPE_SMALL_FOLDER;
    }
    if (ArrayUtils.equalsArr(area, [2, 2])) {
      return FolderType.TYPE_NORMAL_BIG_FOLDER;
    }
    if (ArrayUtils.equalsArr(area, [2, 1])) {
      return FolderType.TYPE_2X1_BIG_FOLDER;
    }
    if (ArrayUtils.equalsArr(area, [1, 2])) {
      return FolderType.TYPE_1X2_BIG_FOLDER;
    }
    if (ArrayUtils.equalsArr(area, [4, 2])) {
      return FolderType.TYPE_4X2_BIG_FOLDER;
    }
    return FolderType.TYPE_SMALL_FOLDER;
  }

  /**
   * 获取各个类型文件夹需要做透明度的位置值
   *
   * @param type 文件夹类型
   * @returns 需要做透明度的位置值
   */
  public getShouldOptIndex(type: FolderType): number {
    return this.mOptIconIndexMap.get(type) ?? 9;
  }

  /**
   * 获取文件夹在屏幕上的方位，大文件夹方位点计算取文件夹的右下角行列值
   *
   * @param folderItem 文件夹缓存数据
   * @returns 左上: 0, 右上: 1, 左下: 2, 右下: 3
   */
  public getFolderRegion(folderItem: GridLayoutItemInfo): number {
    if (!folderItem) {
      return 0;
    }
    let gridRow: number = SettingsModel.getInstance().getGridConfig().row;
    let gridColumn: number = SettingsModel.getInstance().getGridConfig().column;
    let area: number[] = folderItem.area ?? [1, 1];
    let folderRow: number = (folderItem.row ?? 0) + area[1] - 1;
    let folderColumn: number = (folderItem.column ?? 0) + area[0] - 1;
    let folderPage: number = folderItem.page ?? 0;
    let halfOfRow: number = (gridRow % StyleConstants.DEFAULT_2 === 0) ?
      (gridRow / StyleConstants.DEFAULT_2) : ((gridRow + 1) / StyleConstants.DEFAULT_2);
    let halfOfColumn: number = (gridColumn % StyleConstants.DEFAULT_2 === 0) ?
      (gridColumn / StyleConstants.DEFAULT_2) : ((gridColumn + 1) / StyleConstants.DEFAULT_2);
    if (desktopUtil.isFoldExpandStatus()) {
      if (folderItem.isInDock) {
        let residentListLength: number = (ResidentLayoutCacheMgr.getInstance().getAllDockItems()).length;
        let recentListLength: number = (AppStorage.get('recentList') as Array<RecentBundleMissionInfo> ?? []).length;
        let dockColumn: number = residentListLength + recentListLength;
        halfOfColumn = (dockColumn % StyleConstants.DEFAULT_2 === 0) ?
          (dockColumn / StyleConstants.DEFAULT_2) : ((dockColumn + 1) / StyleConstants.DEFAULT_2);
        return this.calculateRegion(folderColumn < halfOfColumn, false);
      }
      return this.calculateRegion(folderPage % StyleConstants.DEFAULT_2 === 0, folderRow < halfOfRow);
    }
    return folderItem.isInDock ? folderItem.dockRegion ?? 0 :
      this.calculateRegion(folderColumn < halfOfColumn, folderRow < halfOfRow);
  }

  private calculateRegion(isLeft: boolean, isUp: boolean): number {
    if (isLeft && isUp) {
      return 0;
    } else if (isLeft && !isUp) {
      return 2;
    } else if (!isLeft && !isUp) {
      return 3;
    } else {
      return 1;
    }
  }

  /**
   * 获取对应位置上图标所处的动效批次
   *
   * @param folderRegion 文件夹所处的屏幕方位
   * @param itemIdx 图标的位置
   * @param isSmall 是否是小文件夹
   * @returns 图标对应的动效批次
   */
  public getFolderItemOrder(folderRegion: number, itemIdx: number, isSmall: boolean): number {
    if (FolderModel.getInstance().getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4) {
      if (isSmall) {
        return FOLDER_EXPANSION_MATRIX_4x4?.[folderRegion]?.[itemIdx];
      }
      return FOLDER_EXPANSION_MATRIX_4X4_NO_SEQUENCE?.[folderRegion]?.[itemIdx];
    }
    if (isSmall) {
      return SMALL_FOLDER_EXPANSION_MATRIX_3X4?.[folderRegion]?.[itemIdx];
    }
    return BIG_FOLDER_EXPANSION_MATRIX_3X4?.[folderRegion]?.[itemIdx];
  }

  /**
   * 获取4x2大文件夹对应位置上图标所处的动效批次
   *
   * @param itemIdx 图标的位置
   * @returns 图标对应的动效批次
   */
  public get4x2FolderItemOrder(itemIdx: number): number {
    return BIG_4x2_FOLDER_EXPANSION_MATRIX_3X4?.[itemIdx];
  }

  /**
   * 获取4x2大文件夹对应位置上图标名称所处的动效批次
   *
   * @param itemIdx 图标的位置
   * @returns 图标名称对应的动效批次
   */
  public get4x2FolderIconNameOrder(itemIdx: number): number {
    return BIG_4X2_FOLDER_ICON_NAME_EXPANSION_MATRIX_3X4?.[itemIdx];
  }
}

export let aniBatchUtil: AnimationBatchUtil = SingletonHelper.getInstance(AnimationBatchUtil, TAG);