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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import {
  DragAppToFolderData,
  DragCoveredItem,
  FoldersData
} from '@ohos/launchercommon/src/main/ets/folder/next/common/model/data/FoldersData';
import {
  CommonConstants,
  ContractedFolderLayoutStyle,
  ContractedFolderLayoutStyleFactory,
  ContractedFolderLayoutViewModel,
  EditModeUtils,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderCommonConstants,
  FolderCommonUtil,
  folderLayoutUtil,
  FolderLifeCyclePriority,
  FolderManager,
  FolderStatus,
  GridLayoutItemInfo,
  GridLayoutUtil,
  OBSERVER_TYPE,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex'
import { DragActionViewModel } from './DragActionViewModel';
import { DragHandlerType, DragProxyManager, IDockDragHandler } from '@ohos/launchercommon/Index';
import { RectangularCoordinates } from '@ohos/componenthelper';

const SHOW_FOLDER_ITEM_COMPENSATION_VALUE: number = 2;
const TAG: string = 'DragActionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹拖拽动效的管理类
 */
class DragActionManager {
  private mDragAniVm: DragActionViewModel = new DragActionViewModel();

  private mDragCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.LOW,
    onDragToFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('start animate for dragging to folder');
      let folderLen: number = folder.layoutInfo?.flat().length ?? 0;
      let maxShowCount: number = FolderCommonUtil.getContractedFolderMaxShowIconNum(folder.area) -
        SHOW_FOLDER_ITEM_COMPENSATION_VALUE;
      let isCreate: boolean = FolderManager.getInstance().getDragCoverItem().isCreateSmallFolder;
      let aniParams: DragAnimatorParams = this.calculateAniParam(folder, isCreate);
      if (folderLen < maxShowCount || FolderCommonUtil.isLayout1X1(folder.area)) {
        this.mDragAniVm.startDropAnimation(folder, aniParams, isCreate);
      }
      this.mDragAniVm.showFolderBackplaneAnimate(folder, false);
    },
    onBackplaneZoomIn: (folder: GridLayoutItemInfo) => {
      log.showInfo('start backplane zoom in');
      this.mDragAniVm.showFolderBackplaneAnimate(folder, true);
    },
    onBackplaneZoomOut: (folder: GridLayoutItemInfo) => {
      log.showInfo('start backplane zoom out');
      this.mDragAniVm.showFolderBackplaneAnimate(folder, false);
    }
  }

  private isDragInSupposeGridItem(folderItem: GridLayoutItemInfo): boolean {
    const folderLen = folderItem.layoutInfo?.flat().length ?? 0;
    const maxShowCount: number = FolderCommonUtil.getContractedFolderMaxShowIconNum(folderItem.area ?? []) -
      SHOW_FOLDER_ITEM_COMPENSATION_VALUE;
    return folderLen >= maxShowCount && !FolderCommonUtil.isLayout1X1(folderItem.area)
  }

  private calculateAniParam(folderItem: GridLayoutItemInfo, isCreate: boolean): DragAnimatorParams {
    let aniParams: DragAnimatorParams = new DragAnimatorParams();
    let style: ContractedFolderLayoutStyle = ContractedFolderLayoutStyleFactory.getInstance().getStyle(folderItem);
    let realDropIndex = this.getDropIndex(folderItem.folderId ?? '', style);
    let finalGridItem: number[] = this.getGridItemPosition(realDropIndex, folderItem);

    let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
    let dragToFolderApp: DragAppToFolderData = FolderManager.getInstance().getDragAppToFolder();
    // 计算松手时图标起始位置，相对于图标在文件夹落位位置的偏移量x，y
    aniParams.transX = dragToFolderApp.appPositionX - finalGridItem[0] - translateXForScreenSplit;
    aniParams.transY = dragToFolderApp.appPositionY - finalGridItem[1];
    aniParams.scale = this.getDropStartScale(style, this.isDragInSupposeGridItem(folderItem));
    if (isCreate) {
      let dragCoveredItem: DragCoveredItem = FolderManager.getInstance().getDragCoverItem();
      let coveredFinalGridItem = this.getGridItemPosition(0, folderItem);
      aniParams.coveredTransX = dragCoveredItem?.coveredAppPositionX - coveredFinalGridItem[0];
      aniParams.coveredTransY = dragCoveredItem?.coveredAppPositionY - coveredFinalGridItem[1];
      aniParams.coveredScale = this.getDropStartScale(style, false);
    }
    return aniParams;
  }

  /**
   * 获取落位的index
   *
   * @param folderId 文件夹id
   * @returns 落位的index
   */
  private getDropIndex(folderId: string, style: ContractedFolderLayoutStyle): number {
    let folder: FoldersData = FolderManager.getInstance().getFolder(folderId);
    let folderLen: number = folder.getItems().length;
    let index: number = folderLen - 1;
    if (folder.isSmall()) {
      index = index % GridLayoutUtil.getCountPerPageFolderOpen();
      index = (index >= FolderCommonConstants.DEFAULT_FOLDER_SHOW_LENGTH) ?
      FolderCommonConstants.DEFAULT_FOLDER_MIDDLE_INDEX : index;
    }
    let maxShowNum: number = style.countInRow * style.countInColumn + SHOW_FOLDER_ITEM_COMPENSATION_VALUE;
    return Math.min(index, maxShowNum - 1);
  }

  private getDropStartScale(style: ContractedFolderLayoutStyle, isDragInSupposeGridItem: boolean): number {
    const targetIconSize = style.mFolderAppSize;
    return (targetIconSize !== 0) ? CommonConstants.ICON_DEFAULT_SCALE *
    style.mDesktopIconSize / targetIconSize : NumberConstants.CONSTANT_NUMBER_ONE;
  }

  /**
   * 获取此文件夹内图标距离屏幕左上角位置，兼容正常桌面和编辑模式，兼容dock栏和grid
   *
   * @param folderItem 文件夹item
   * @param index 此文件夹内图标index顺序，从0开始
   * returns 文件夹内图标据屏幕左上角横纵坐标
   */
  private getGridItemPosition(index: number, folderItem: GridLayoutItemInfo): number[] {
    let folderFirstIconPos = folderLayoutUtil.getItemPostion(FolderStatus.CLOSE_FOLDER, folderItem, index);
    let finalGridItemX = 0;
    let finalGridItemY = 0;
    if (folderItem.isInDock) {
      const dragProxy: IDockDragHandler = DragProxyManager.getInstance()
        .get('get item postion from dragManager', DragHandlerType.DOCK) as IDockDragHandler;
      const defaultPos: RectangularCoordinates.Point = { x: 0, y: 0 } as RectangularCoordinates.Point;
      const folderPos: RectangularCoordinates.Point = dragProxy?.getDockItemLeftTopPosition(folderItem) ?? defaultPos;
      const translateX = dragProxy?.getDockItemTranslate(folderItem.keyName ?? '') ?? 0;
      finalGridItemX = folderPos.x + folderFirstIconPos.x + translateX;
      finalGridItemY = folderPos.y + folderFirstIconPos.y;
    } else {
      let folderCenterPos = folderLayoutUtil.getCurrentFolderCenterPosition(folderItem);
      let firstPointInEdit = EditModeUtils.convertFolderCenterCoordinateToEditMode(folderFirstIconPos, folderItem);
      finalGridItemX = folderCenterPos[0] + firstPointInEdit.x;
      finalGridItemY = folderCenterPos[1] + firstPointInEdit.y;
    }
    return [finalGridItemX, finalGridItemY];
  }

  /**
   * 注册文件夹拖拽的动效生命周期回调
   */
  public registerDragActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mDragCallback);
  }

  /**
   * 取消注册文件夹拖拽的动效生命周期回调
   */
  public unregisterDragActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mDragCallback);
  }
}

/**
 * 拖拽动效参数类
 */
export class DragAnimatorParams {
  /**
   * 拖拽图标的位移X
   */
  public transX: number = 0;
  /**
   * 拖拽图标的位移Y
   */
  public transY: number = 0;
  /**
   * 拖拽图标的缩放scale
   */
  public scale: number = 1;

  /**
   * 拖拽覆盖图标位移X
   */
  public coveredTransX: number = 0;

  /**
   * 拖拽覆盖图标位移Y
   */
  public coveredTransY: number = 0;

  /**
   * 拖拽覆盖图标scale
   */
  public coveredScale: number = 0;
}

export let dragAniMgr: DragActionManager = SingletonHelper.getInstance(DragActionManager, TAG);