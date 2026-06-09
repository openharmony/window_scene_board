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
  AppListStyleConfig,
  CommonConstants,
  ContractedFolderCommonViewModel,
  FolderCommonUtil,
  GridLayoutItemInfo,
  ResidentLayoutCacheMgr,
  ThemeStyleInfo
} from '../../../../../../TsIndex';
import GridLayoutUtil, { ItemsCount } from '../../../../../../utils/GridLayoutUtil';
import { FolderStyleManager } from '../../../../common/FolderStyleManager';

const TAG = 'ContractedFolderLayoutStyleFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹布局样式生成工厂
 */
export class ContractedFolderLayoutStyleFactory {
  private static instance: ContractedFolderLayoutStyleFactory;
  private mFolderStyle: FolderStyleManager = FolderStyleManager.getInstance();

  private constructor() {
  }

  public static getInstance(): ContractedFolderLayoutStyleFactory {
    if (!ContractedFolderLayoutStyleFactory.instance) {
      ContractedFolderLayoutStyleFactory.instance = new ContractedFolderLayoutStyleFactory();
    }
    return ContractedFolderLayoutStyleFactory.instance;
  }

  /**
   * 根据文件夹area获取文件夹样式
   *
   * @param area 文件夹大小
   * @returns 文件夹样式
   */
  public getStyle(folder: GridLayoutItemInfo): ContractedFolderLayoutStyle {
    let isDockFolder: boolean = ResidentLayoutCacheMgr.getInstance().getAllDockItems().findIndex(dockItem =>
      dockItem.keyName === folder.keyName) !== -1;
    let folderStyle: ContractedFolderLayoutStyle = this.mFolderStyle.getFolderStyleByArea(
      folder.area ?? [1, 1], isDockFolder);
    folderStyle.initGridPos(folder);
    return folderStyle;
  }

  /**
   * 根据area获取文件夹布局样式
   *
   * @param area 文件夹大小
   * @returns 布局样式
   */
  public getStyleByArea(area: number[], isFormDock: boolean = false): ContractedFolderLayoutStyle {
    return this.mFolderStyle.getFolderStyleByArea(area, isFormDock);
  }
}

/**
 * 文件夹布局样式
 */
export class ContractedFolderLayoutStyle extends AppListStyleConfig {
  /* 文件夹大小 */
  area: number[] = [1, 1];
  /* 文件夹的圆角即背板的圆角 */
  backgroundRadius: number = 0;
  /* 文件夹的高度即背板的高度 */
  backgroundHeight: number = 0;
  /* 文件夹的宽度即背板的宽度 */
  backgroundWidth: number = 0;
  /* 文件夹内图标支持的效果 */
  itemIconSupportEffect: number = 0;
  /* 文件夹内图标的圆角 */
  itemIconRadius: number = 0;
  /* 文件夹内图标的大小 */
  itemIconSize: number = 0;
  /* 文件夹内图标的角标大小比例 */
  itemIconBadgeScale: number = 0;
  /* 文件夹的X方向scale */
  folderScaleX: number = 1;
  /* 文件夹的Y方向scale */
  folderScaleY: number = 1;
  /* 文件夹名字的margin */
  iconNameMargin: number = 0;
  /* 主题样式 */
  mThemeStyle: ThemeStyleInfo | undefined;
  /* 文件夹每行显示的图标数量 */
  countInRow: number = 3;
  /* 文件夹每列显示的图标数量 */
  countInColumn: number = 3;
  /* 文件夹网格间隙 */
  mGridGap: number = 1;
  /* 文件夹网格边距 */
  mGridMargin: number = 0;
  /* 文件夹图标大小 */
  mFolderAppSize: number = 0;
  /* 文件夹解散动效偏移参数 */
  mDisbandAnimOffset: number = 0;
  /* 桌面图标的大小 */
  mDesktopIconSize: number = 0;
  /* 文件夹列起始位置 */
  colStart: number = 0;
  /* 文件夹列终点位置 */
  colEnd: number = 0;
  /* 文件夹行终点位置 */
  rowEnd: number = 0;

  public constructor() {
    super();
  }

  /**
   * 获取列间距
   *
   * @returns 列间距
   */
  public getColumnGap(): number {
    let ret: number = this.mGridGap;
    /* 文件夹显示六个图标场景计算Gap值 */
    if (this.countInRow === ItemsCount.SIZE_4.valueOf()) {
      ret = (this.backgroundWidth - this.mGridMargin * CommonConstants.NUMBER_TWO -
        this.countInRow * this.mFolderAppSize) / (this.countInRow - 1);
    }
    return ret;
  }

  /**
   * 获取行间距
   *
   * @returns 行间距
   */
  public getRowGap(): number {
    let gap: number = this.mGridGap;
    return gap;
  }

  /**
   * 获取padding
   *
   * @param isLeftOrRight
   * @returns
   */
  public getPadding(isLeftOrRight: boolean): number {
    let ret: number = 0;
    if (FolderCommonUtil.isLayout1X1(this.area)) {
      return this.mGridMargin;
    }
    if (this.countInRow === 1 && isLeftOrRight) {
      ret = (this.backgroundWidth - this.mFolderAppSize) / CommonConstants.NUMBER_TWO;
    } else if (this.countInColumn === 1 && !isLeftOrRight) {
      ret = (this.backgroundHeight - this.mFolderAppSize) / CommonConstants.NUMBER_TWO;
    } else {
      ret = this.mGridMargin;
    }
    return ret;
  }

  /**
   * 是否4*2文件夹
   *
   * @returns true是4*2文件夹
   */
  public isLayout4X2(): boolean {
    return this.countInRow === ItemsCount.SIZE_4.valueOf();
  }

  /**
   * 是否是1*1文件夹
   *
   * @returns true是1*1文件夹
   */
  public isLayout1X1(): boolean {
    return this.area[0] === 1 && this.area[1] === 1;
  }

  /**
   * 初始化网格位置
   *
   * @param item 文件夹item
   */
  public initGridPos(item: GridLayoutItemInfo): void {
    this.colStart = item.column ?? 0;
    this.colEnd = GridLayoutUtil.calculateItemColEnd(item);
    this.rowEnd = GridLayoutUtil.calculateItemRowEnd(item);
  }
}