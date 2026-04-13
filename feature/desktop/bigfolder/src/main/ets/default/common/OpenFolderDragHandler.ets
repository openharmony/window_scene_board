/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  LogDomain,
  LogHelper,
  Trace,
  AppStorageUtil,
  DataProperty,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import {
  desktopUtil,
  RTLUtil
} from '@ohos/componenthelper';
import type { DragItemPosition } from '@ohos/componentdrag';
import { DragEventManager } from '@ohos/componentdrag';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DropAnimationParam, DropAnimationDestination } from '@ohos/componentanimator';
import {
  GridLayoutItemInfo,
  GridLayoutUtil,
  EventConstants,
  EditModeUtils,
  CommonConstants,
  ContractedFolderLayoutViewModel,
  FolderManager,
} from '@ohos/launchercommon';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { folderLayoutUtil, FolderStatus } from '@ohos/launchercommon/src/main/ets/utils/FolderLayoutUtil';
import { openFolderAppMoveVMManager } from '../viewmodel/OpenFolderAppMoveVMManager';
import { OpenFolderAppMoveVm } from '../viewmodel/OpenFolderAppMoveVM';
import FeatureConstants from './constants/FeatureConstants';

const TAG = 'OpenFolderDragHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
type ItemPosition = [number, number];
class PositionCache {
  public positionX: number[] = [];
  public positionY: number[] = [];
}

export default class OpenFolderDragHandler {
  private appItemPosition: PositionCache = new PositionCache();

  private appItemCenterPosition: ItemPosition[] = [];

  private dragStartIndex: number = 0;
  private dragEndIndex: number = 0;
  private readyToRunAnimate: OpenFolderAppMoveVm[] = [];
  private mDataMgr: FolderManager = FolderManager.getInstance();

  constructor() {
    this.initXYPositionArea();
    GlobalContext?.getContext()?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, () => {
      this.onEditModeChange();
    });
  }

  static getInstance(): OpenFolderDragHandler {
    if (globalThis.mOpenFolderDragHandler == null) {
      globalThis.mOpenFolderDragHandler = new OpenFolderDragHandler();
    }
    return globalThis.mOpenFolderDragHandler;
  }

  private onEditModeChange(): void {
    log.showInfo('reInit onEditModeChange')
    this.initXYPositionArea();
  }

  /**
   * 折叠屏折叠展开状态改变后需要重新计算
   */
  public onFolderStatusChange(): void {
    log.showInfo('reInit onFolderStatusChange');
    this.initXYPositionArea();
  }

  /**
   * 初始化文件夹item热区 x表示icon的最右边 y表示icon最下边
   */
  private initXYPositionArea(): void {
    let folderItem = new GridLayoutItemInfo();
    let itemList = folderLayoutUtil.getAllGridItemPosition(FolderStatus.OPEN_FOLDER, folderItem);
    if (itemList?.length > 0) {
      const rowAndColCount = folderLayoutUtil.getRowAndColCount(FolderStatus.OPEN_FOLDER, folderItem);
      this.appItemPosition.positionX = [];
      this.appItemPosition.positionY = [];
      itemList.forEach((item, index) => {
        const col = index % rowAndColCount[1];
        if (col === 0) {
          let point = EditModeUtils.convertOpenFolderCoordinateToEditMode({x: 0, y: item.y});
          this.appItemPosition.positionY.push(point.y);
        }
        if (!this.appItemPosition.positionX[col]) {
          let point = EditModeUtils.convertOpenFolderCoordinateToEditMode({x: item.x, y: 0});
          this.appItemPosition.positionX.push(point.x);
        }
      });

      this.appItemCenterPosition = [];
      for (let i = 0; i < (itemList.length); i++) {
        let position = folderLayoutUtil.getOpenFolderItemPosition(i);
        if (!position) {
          continue;
        }
        this.appItemCenterPosition.push([position.x, position.y]);
      }
    }
  }

  /**
   * 获取当前item的热区的index
   *
   * @param x
   * @param y
   */
  public getCurrentIndex(x: number, y: number): number {
    let row: number = 0;
    let column: number = 0;
    this.appItemPosition.positionX.forEach((posX, index) => {
      if (x >= posX) {
        column = index;
      }
    });
    this.appItemPosition.positionY.forEach((posY, index) => {
      if (y >= posY) {
        row = index;
      }
    });
    if (RTLUtil.isRTL()) {
      const columnCnt = folderLayoutUtil.getRowAndColCount(FolderStatus.OPEN_FOLDER, new GridLayoutItemInfo());
      column = columnCnt[1] - 1 - column;
    }
    return row * this.appItemPosition.positionX.length + column;
  }

  public getCenterPositionList(): ItemPosition[] {
    return this.appItemCenterPosition;
  }

  /**
   * 拖拽开始起拖
   *
   * @param dragItem 拖拽的元素
   * @param event 拖拽事件
   * @param dragItemType 拖拽元素类型
   */
  public dragStart(dragItem: GridLayoutItemInfo, event: DragEvent, dragItemType: number): void {
    if (!dragItem) {
      log.showError('dragItem is null on dragStart');
      return;
    }
    Trace.start(Trace.CORE_METHOD_DRAG_START);
    // 临时方案,每次起拖的时候init一遍, 后续需要改成全量监听引起网格变化的事件进行最小化刷新
    this.initXYPositionArea();
    AppStorageUtil.setOrCreate('isDrag', true, new DataProperty(true, false));
    AppStorageUtil.setOrCreate('dragItemType', dragItemType, new DataProperty(true, false));
    if (dragItem.itemType === undefined || dragItem.itemType === null) {
      dragItem.itemType = dragItem.typeId;
    }
    AppStorageUtil.setOrCreate('dragItemInfo', dragItem, new DataProperty(true, false, 'GridLayoutItemInfo'));
    DragEventManager.getInstance().dragStartInDesktop(dragItem.keyName);
    const openFolder: GridLayoutItemInfo = this.mDataMgr.getOpenedFolder();
    this.dragStartIndex = this.mDataMgr.getIndexInFolder(dragItem, openFolder);
    this.dragEndIndex = this.dragStartIndex;
    log.showInfo('drag start, dragItemType: %{public}d, dragStartIndex: %{public}d', dragItemType, this.dragStartIndex);
    let convertPoint = EditModeUtils.convertOpenFolderCoordinateToEditMode({
      x: this.appItemCenterPosition[this.dragStartIndex][0],
      y: this.appItemCenterPosition[this.dragStartIndex][1]
    });
    if (event) {
      const startPosition: DragItemPosition = {
        page: desktopUtil.getPageIndexValue(),
        row: dragItem.row!,
        column: dragItem.column!,
        x: convertPoint.x,
        y: convertPoint.y,
      };
      AppStorageUtil.setOrCreate<Object>('startPosition', startPosition,
        new DataProperty(false, false, 'StartPosition'));
    }
    Trace.end(Trace.CORE_METHOD_DRAG_START);
  }

  /**
   * 落位事件处理
   *
   * @param event 拖拽事件
   * @param dropIndex 元素落位位置
   * @param key 拖拽元素的标识符
   * @param onDropAnimationEnd 落位动效完成的回调
   */
  public dragDrop(event: DragEvent, dropIndex: number, key: string, onDropAnimationEnd?: (key: string) => void): void {
    if (!event || dropIndex < 0 || dropIndex >= this.appItemCenterPosition.length) {
      return;
    }
    Trace.start(Trace.CORE_METHOD_DRAG_DROP);
    log.showInfo('drag drop, dropIndex: %{public}d', dropIndex);
    let rectangle: Rectangle = event.getPreviewRect();
    let dropX: number = Number(rectangle.x) + Number(rectangle.width) / 2;
    let dropY: number = Number(rectangle.y) + Number(rectangle.height) / 2;
    let convertPoint = EditModeUtils.convertOpenFolderCoordinateToEditMode({
      x: this.appItemCenterPosition[dropIndex][0],
      y: this.appItemCenterPosition[dropIndex][1]
    });
    let fallX: number = convertPoint.x;
    let fallY: number = convertPoint.y;
    event.executeDropAnimation(() => {
      dropAnimationManager.startDropAnimation(DropAnimationDestination.OPEN_FOLDER,
        new DropAnimationParam(key, dropX, dropY, fallX, fallY),
        (isCancel: boolean, param: DropAnimationParam) => onDropAnimationEnd?.(param.key));
      AppStorageUtil.setOrCreate('isDrag', false, new DataProperty(true, false));
      AppStorageUtil.setOrCreate<GridLayoutItemInfo>('dragItemInfo', new GridLayoutItemInfo(),
        new DataProperty(true, false, 'GridLayoutItemInfo'));
      this.mDataMgr.setDragItemFolder(undefined);
    });
    Trace.end(Trace.CORE_METHOD_DRAG_DROP);
  }

  /**
   * 返回原位动效
   *
   * @param event 落位事件
   * @returns 是否执行落位动效
   */
  public animationToOriginalPos(event: DragEvent, dragType: number): boolean {
    const dragItem: GridLayoutItemInfo = this.getDragItemInfo();
    if (!GridLayoutUtil.isValidLayoutItem(dragItem)) {
      return false;
    }
    // 拖拽快捷方式时，需要将落位事件透传给桌面
    if (dragType === CommonConstants.DRAG_FROM_SHORTCUT) {
      GlobalContext.getContext().eventHub.emit(CommonConstants.EVENTHUB_DRAG_LEAVE_FROM_SMALL_FOLDER_ADVANCE, event);
      return true;
    }
    const startIndex: number = this.dragStartIndex;
    const itemKey: string = GridLayoutUtil.generateUniqueKey(dragItem);
    this.dragDrop(event, startIndex, itemKey);
    return true;
  }

  public getDragItemInfo(): GridLayoutItemInfo {
    return GridLayoutUtil.getSingleDragItemInfo() ?? {} as GridLayoutItemInfo;
  }

  /**
   * 设置初始化dragStartIndex和dragEndIndex
   *
   * @param index 需要设置的index的值
   */
  initStartAndEndIndex(index: number): void {
    log.showInfo('initStartAndEndIndex: %{public}d ', index);
    this.dragStartIndex = index;
    this.dragEndIndex = index;
  }

  /**
   * 获取当前dragEndIndex
   *
   * @returns number 当前dragEndIndex
   */
  getDragEndIndex(): number {
    return this.dragEndIndex;
  }

  /**
   * 执行挤位/补位动效
   *
   * @param endIndex 输入endIndex
   * @param pageIndex 执行的展开态页数
   * @param msg 调用信息
   *
   */
  startToFillPostion(endIndex: number, pageIndex: number, msg: string): void {
    // 关闭过程中不要补位
    const isFolderOpen: boolean = this.mDataMgr.isFolderOpen();
    if (!isFolderOpen) {
      log.showWarn('already closing, need not to drag Enter');
      return;
    }
    log.showInfo('startToMove by %{public}s dragStartIndex to dragEndIndex: %{public}d to %{public}d, pageIndex: %{public}d',
      msg, this.dragStartIndex, this.dragEndIndex, pageIndex);
    this.dragEndIndex = endIndex;
    this.mDataMgr.setIsSqueezing(true);

    const openFolderData: GridLayoutItemInfo = this.mDataMgr.getOpenedFolder();
    let needDragMoveLayoutInfo: GridLayoutItemInfo[] = [];
    if (openFolderData?.layoutInfo && pageIndex < openFolderData?.layoutInfo.length) {
      needDragMoveLayoutInfo = openFolderData?.layoutInfo[pageIndex]
    }
    this.readyToRunAnimate = [];
    needDragMoveLayoutInfo.forEach((gridItem, index) => {
      let findKeyName = gridItem.keyName ?? gridItem.bundleName;
      let nextIndex = this.getNextIndex(index);
      let itemVm: OpenFolderAppMoveVm = openFolderAppMoveVMManager.getMoveVmByItem(gridItem);
      let isEmptyVm: boolean = CheckEmptyUtils.checkStrIsEmpty(itemVm.id);
      log.showInfo('find key name %{public}s changeItem %{public}d to %{public}d isEmptyVm is %{public}s', findKeyName,
        index, nextIndex, isEmptyVm)
      let centerPositionList: ItemPosition[] = OpenFolderDragHandler.getInstance().getCenterPositionList();
      if (centerPositionList.length > index && centerPositionList.length > nextIndex) {
        let targetTranslateX: number = centerPositionList[nextIndex][0] - centerPositionList[index][0];
        let targetTranslateY: number = centerPositionList[nextIndex][1] - centerPositionList[index][1];
        if (itemVm.translateX !== targetTranslateX || itemVm.translateY !== targetTranslateY) {
          itemVm.targetTranslateX = targetTranslateX;
          itemVm.targetTranslateY = targetTranslateY;
          this.readyToRunAnimate.push(itemVm);
        }
      }
    })
    this.executeFillPositionAnimate(FeatureConstants.FOLDER_OPEN_FILL_POSITION_DURATION);
  }

  private executeFillPositionAnimate(duration: number) {
    animateTo({
      duration: duration,
      onFinish: () => {
        ContractedFolderLayoutViewModel.getInstance().executeAfterMoveAnimation();
      }
    }, () => {
      this.readyToRunAnimate.forEach(itemVm => {
        itemVm.translateX = itemVm.targetTranslateX;
        itemVm.translateY = itemVm.targetTranslateY;
      })
    })
  }

  /**
   * 重置当前页itemVm偏移量
   * @param msg 日志信息
   */
  public resetTranslateZero(msg: string): void {
    log.showInfo(`resetTranslateZero by ${msg}`);
    openFolderAppMoveVMManager.resetTransLate();
  }

  /**
   * 拖出打断场景重置动效
   * @param pageIndex 被拖拽页数
   *
   */
  public resetTranslateForBreak(pageIndex: number): void {
    this.dragEndIndex = this.dragStartIndex;
    this.startToFillPostion(this.dragEndIndex, pageIndex, 'dragLeave break')
  }

  /**
   * 根据当前的index, dragStartIndex和dragEndIndex计算出目标位置的index
   *
   */
  public getNextIndex(nowIndex: number): number {
    if (this.dragStartIndex < this.dragEndIndex && nowIndex > this.dragStartIndex && nowIndex <= this.dragEndIndex) {
      return nowIndex - 1;
    } else if (this.dragStartIndex > this.dragEndIndex && nowIndex >= this.dragEndIndex &&
      nowIndex < this.dragStartIndex) {
      return nowIndex + 1;
    } else {
      return nowIndex;
    }
  }

  /**
   * 挤位后刷新缓存
   * @param originLayoutInfo 原始的缓存数据
   *
   */
  public updateLayoutCacheAfterFillPosition(originLayoutInfo: GridLayoutItemInfo[]): void {
    if (this.dragStartIndex > originLayoutInfo.length) {
      log.showError('out-of-bounds array, dragStartIndex is %{public}d', this.dragStartIndex);
      return;
    }
    let item: GridLayoutItemInfo = originLayoutInfo[this.dragStartIndex];
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('item is undefined, dragStartIndex is %{public}d', this.dragStartIndex);
      return;
    }
    originLayoutInfo.splice(this.dragStartIndex, 1);
    originLayoutInfo.splice(this.dragEndIndex, 0, item);
  }

  /**
   * 创建节点前如果在展开态挤位过程中(应用更新场景), 需要将Vm偏移量初始化为终点值
   * @param itemVm 待判断itemVm
   *
   */
  public judgeTranslateBeforeInit(itemVm: OpenFolderAppMoveVm): void {
    let isAddIconHidden: boolean = AppStorage.get<boolean>('isAddIconHidden') ?? false;
    const isFolderOpen: boolean = this.mDataMgr.isFolderOpen();
    // 文件夹展开态的拖拽场景才需要判断
    if (!isFolderOpen || !isAddIconHidden) {
      return;
    }
    const openFolderData: GridLayoutItemInfo = this.mDataMgr.getOpenedFolder();
    const pageIndex: number = this.mDataMgr.getPageIndex();
    let needDragMoveLayoutInfo: GridLayoutItemInfo[] = [];
    if (openFolderData?.layoutInfo && pageIndex < openFolderData?.layoutInfo.length) {
      needDragMoveLayoutInfo = openFolderData?.layoutInfo[pageIndex]
    }
    needDragMoveLayoutInfo.forEach((gridItem, index) => {
      let gridItemId: string = openFolderAppMoveVMManager.generatedItemId(gridItem);
      if (gridItemId === itemVm.id) {
        let nextIndex = this.getNextIndex(index);
        let centerPositionList: ItemPosition[] = OpenFolderDragHandler.getInstance().getCenterPositionList();
        if (centerPositionList.length > index && centerPositionList.length > nextIndex && nextIndex !== index) {
          let targetTranslateX: number = centerPositionList[nextIndex][0] - centerPositionList[index][0];
          let targetTranslateY: number = centerPositionList[nextIndex][1] - centerPositionList[index][1];
          itemVm.translateX = targetTranslateX;
          itemVm.translateY = targetTranslateY;
          log.showInfo('need to change translate item keyName = %{public}s , translate: %{public}d, %{public}d',
            itemVm.id, targetTranslateX, targetTranslateY);
        }
      }
    });
  }
}
