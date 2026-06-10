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
  AppItemInfo,
  CommonConstants,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  COVER_FOLDER_TYPE,
  DockItemInfo,
  DragAppToFolderData,
  editModeManager,
  EditModeUtils,
  EventConstants,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderCommonConstants,
  FolderCommonUtil,
  FolderDataRefreshType,
  FolderDragItem,
  FolderDropType,
  FolderItemInfo,
  FolderLayoutStruct,
  FolderManager,
  FolderModel,
  FolderOperationFlag,
  FolderReporter,
  FolderStyleManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  MultiSelectListenerType,
  multiSelectListenManger,
  MultiSelectManager,
  OBSERVER_SWITCH,
  PageDesktopModel,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { IContractedFolderDragViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ImageModifier } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { DropAnimationListener, dropAnimationObserver } from '@ohos/componentanimator/src/main/ets/TsIndex';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  desktopUtil,
  DragAccessibilityUtils,
  dragSnapshotHelper,
  SCBVisualEffectMgr,
  SnapshotType
} from '@ohos/componenthelper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { localEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  DragDataType,
  DragEventManager,
  DragExtraInfo,
  DragItemPosition
} from '@ohos/componentdrag/src/main/ets/TsIndex';
import {
  DragCoveredItem,
  FoldersData
} from '@ohos/launchercommon/src/main/ets/folder/next/common/model/data/FoldersData';
import Prompt from '@ohos.promptAction';
import { DragHandlerType, DragProxyManager, IDesktopDragHandler } from '@ohos/launchercommon/Index';
import { FolderAccessibilityUtils } from '../../common/FolderAccessibilityUtils';
import OpenFolderDragHandler from '../../common/OpenFolderDragHandler';

const TAG = 'ContractedFolderDragViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹拖拽业务处理
 */
export class DragViewModel implements IContractedFolderDragViewModel {
  private static instance: DragViewModel;

  private mFolderLayoutVM: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();

  private mFolderMgr: FolderManager = FolderManager.getInstance();

  private mDropAniMap: Map<string, DropAnimationListener> = new Map<string, DropAnimationListener>();

  // 文件夹动效生命周期事件管理
  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();

  private mIsDragStart: boolean = false;

  private mFolderPreviewRadius: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius'));

  private mFolderSaturation: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation'));

  private mColor = $r('app.color.back_plane_bg_color');

  private mAddMaxMessage = $r('app.string.add_icon_to_desktop_max');

  // 文件夹拖出元素是否已处理
  private dragLeaveItemHasDeal: boolean = false;

  private multiSelectListener: MultiSelectListenerType = {
    id: CommonConstants.CONTRACTED_FOLDER_MULTI_DRAG,
    onDropping: (): void => this.onMultiSelectDropping(),
    onFinish: (): void => this.onMultiSelectFinish()
  };

  private constructor() {
    log.showInfo(TAG, 'ContractedFolderDragViewModel constructor');
    multiSelectListenManger.register(this.multiSelectListener);
  }

  public static getInstance(): DragViewModel {
    if (!DragViewModel.instance) {
      DragViewModel.instance = new DragViewModel();
      ContractedFolderViewModelManager.getInstance()
        .register(ContractedFolderViewModelType.DRAG, DragViewModel.instance);
    }
    return DragViewModel.instance;
  }

  /**
   * 设置拖出元素处理状态,如果DragEnd时还未处理,需要标记为已处理,避免和DragLeave的时序问题
   *
   * @param dragLeaveItemHasDeal 拖出元素是否已处理
   */
  public setDragLeaveItemHasDeal(dragLeaveItemHasDeal: boolean): void {
    this.dragLeaveItemHasDeal = dragLeaveItemHasDeal;
  }

  /**
   * 获取拖出元素是否已处理完成状态
   *
   * @return boolean 拖出元素是否已处理
   */
  public getDragLeaveItemHasDeal(): boolean {
    return this.dragLeaveItemHasDeal;
  }

  /**
   * 初始化拖拽相关的Listener
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public registerListener(msg: string, folderId: string): void {
    let dropAniListener: DropAnimationListener = this.getDropAnimationListener(folderId);
    // folderId反注册时, 数据已经没有, 不能采用通用方法计算key
    const key = CommonConstants.TYPE_FOLDER + `${folderId}`;
    log.showInfo(TAG, '%{public}s register for dropAnimationListener key:%{public}s', msg, key);
    dropAnimationObserver.registerDropAnimationListener(dropAniListener, key);
  }

  /**
   * 取消注册拖拽相关的Listener
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public unregisterListener(msg: string, folderId: string): void {
    const dropAniListener: DropAnimationListener | undefined = this.mDropAniMap.get(folderId);
    if (dropAniListener) {
      const key = CommonConstants.TYPE_FOLDER + `${folderId}`;
      log.showInfo(TAG, '%{public}s unregister for dropAnimationListener key:%{public}s', msg, key);
      dropAnimationObserver.unregisterDropAnimationListener(dropAniListener, key);
      this.mDropAniMap.delete(folderId);
    }
  }

  private getDropAnimationListener(folderId: string): DropAnimationListener {
    let dropAniListener: DropAnimationListener | undefined = this.mDropAniMap.get(folderId);
    if (!dropAniListener) {
      dropAniListener = {
        onDropAnimationEnd: () => {
          log.showInfo(TAG, `onEventhubItemDropEndEvent`);
          localEventManager.sendLocalEventAsync(EventConstants.EVENT_FOLDER_DRAG_END, folderId);
        }
      } as DropAnimationListener;
      this.mDropAniMap.set(folderId, dropAniListener);
    }
    return dropAniListener;
  }

  private onMultiSelectDropping(): void {
    let folderId: string = this.mFolderMgr.getMultiDropFolderId();
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    log.showInfo(TAG, `multiSelectListener bigFolderItem onDropping ${folderId}`);
    this.mFolderLayoutVM.getDataOsrMgr(folderId)
      .setSelectItemNames(MultiSelectManager.getInstance().getAllSelectedItemKeyNames());
  }

  private onMultiSelectFinish(): void {
    let folderId: string = this.mFolderMgr.getMultiDropFolderId();
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    log.showInfo(TAG, `multiSelectListener bigFolderItem onFinish ${folderId}`);
    this.mFolderLayoutVM.getDataOsrMgr(folderId).setSelectItemNames([]);
  }

  /**
   * 文件夹开始拖拽
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param event 拖拽事件
   */
  public dragStart(msg: string, folderId: string, event: DragEvent): DragItemInfo {
    let folder: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
    AppStorage.setOrCreate('isDrag', true);
    AppStorage.setOrCreate('selectItem', '');
    AppStorage.setOrCreate('dragItemInfo', folder);
    AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
    const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
      .get('drop to Desktop from folder', DragHandlerType.DESKTOP) as IDesktopDragHandler;
    if (dragProxy) {
      const startPosition: DragItemPosition = dragProxy.getTouchPosition(event.getX(), event.getY());
      dragProxy.onDragStart(event.getX(), event.getY());
      dragProxy.setStartPosition(startPosition);
    } else {
      log.showWarn(TAG, '(%{public}s) dragStart and setStartPosition fail with null proxyDragHandler', msg);
    }
    this.mFolderLayoutVM.getViewOsrMgr(folderId).switchStatus(msg, OBSERVER_SWITCH.MENU_SHOW, false);
    // 大文件夹菜单浮起，由于拖拽线框存在，导致其预览图尺寸比大文件夹拖拽尺寸大，起拖时会向左上角产生跳变，使用extraInfo参数，处理这种跳变
    let dragExtraInfo = new DragExtraInfo(SCBVisualEffectMgr.isFolderSolidColor() ? DragDataType.APP :
      DragDataType.FOLDER);
    let dragItemInfo: DragItemInfo = {
      // 编辑模式使用底座默认截图
      pixelMap: editModeManager.isInEditMode() ? undefined :
      dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, GridLayoutUtil.generateUniqueKey(folder)),
      extraInfo: dragExtraInfo.toString()
    };
    return dragItemInfo;
  }

  /**
   * 文件夹结束拖拽
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public dragEnd(msg: string, folderId: string): void {
    const folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    if (!DragEventManager.getInstance().isDropInDesktop && folder.isInDock()) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH,
        folder.getGridInfo());
    }
    DragEventManager.getInstance().startDrop(GridLayoutUtil.generateUniqueKey(folder.getGridInfo()));
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate('dragItemInfo', {});
    // 拖拽结束后需要清除文件夹缓存
    this.mFolderMgr.deleteFolderCache(msg, folderId);
  }

  /**
   * 文件夹准备拖拽
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param preDragStatus 准备拖拽的状态
   */
  public preDrag(msg: string, folderId: string, preDragStatus: PreDragStatus): void {
    const isOnPreDrag = EditModeUtils.handlePreDrag(preDragStatus);
    if (typeof isOnPreDrag === 'undefined') {
      return;
    }
    let folderItem: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId)?.getGridInfo();
    let isEnableMultiSelectBox: boolean = this.isEnableMultiSelectCheckBox(isOnPreDrag, folderItem);
    this.mFolderLayoutVM.getViewOsrMgr(folderId)
      .switchStatus(msg, OBSERVER_SWITCH.FOLDER_CHECK_BOX, isEnableMultiSelectBox);
  }

  /**
   * 是否显示文件夹多选框
   *
   * @param isOnPreDrag 准备拖拽
   * @returns true显示多选框
   */
  private isEnableMultiSelectCheckBox(isOnPreDrag: boolean, folderItem: GridLayoutItemInfo): boolean {
    return !isOnPreDrag && !this.isFolderZoomComponentShow(folderItem);
  }

  private isFolderZoomComponentShow(folderItem: GridLayoutItemInfo): boolean {
    return !layoutLockUtil.isLockedPage(folderItem.page, 'adjust folder size');
  }

  /**
   * 展开态拖拽应用离开文件夹
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param dragItemInfo 拖拽的元素
   */
  public dragLeave(msg: string, folderId: string, dragItemInfo: GridLayoutItemInfo): void {
    log.showInfo(TAG, 'drag leave folder %{public}s, from: %{public}s', folderId, msg);
    let openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      this.mFolderMgr.setDragLeaveFolderId(folderId);
      this.mIsDragStart = true;
    if (!this.getDragLeaveItemHasDeal()) {
      let tempArr: GridLayoutItemInfo[] =
        openFolderData.layoutInfo?.flat().filter(item => item.keyName !== dragItemInfo.keyName) ?? [];
      this.mFolderMgr.updateOpenFolderLayout(msg, tempArr, false);
      this.setDragLeaveItemHasDeal(true);
    } else {
      let tempArr: GridLayoutItemInfo[] = openFolderData.layoutInfo?.flat() ?? [];
      this.mFolderMgr.updateOpenFolderLayout(msg, tempArr, false);
    }
    OpenFolderDragHandler.getInstance().resetTranslateZero('drag leave');
    ContractedFolderCommonViewModel.getInstance().closeFolder(msg, FolderOperationFlag.NONE);
  }

  /**
   * 获取拖拽预览的option参数
   *
   * @param msg 用于DFX的日志打印
   * @param radius 圆角值
   * @returns 拖拽预览option
   */
  public getDragPreviewOption(msg: string, radius: number, isSolidColor: boolean): DragPreviewOptions {
    return {
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: new ImageModifier()
        .borderRadius(EditModeUtils.convertWithDesktopScale(radius))
        .backgroundEffect(isSolidColor ? undefined : {
          policy: 1,
          radius: this.mFolderPreviewRadius,
          saturation: this.mFolderSaturation,
          brightness: FolderStyleManager.getInstance().getBackgroundBrightness(),
          color: this.mColor,
        })
    };
  }

  /**
   * 获取拖拽的截图
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param type 类型
   * @returns 截图
   */
  public getDragSnapshot(msg: string, folderId: string, type: SnapshotType): image.PixelMap | undefined {
    log.showInfo(TAG, '%{public}s: get snapshot for folder %{public}s, type: %{public}d', msg, folderId, type);
    let folderData = this.mFolderMgr.getFolder(folderId);
    return dragSnapshotHelper.getSnapshot(type, GridLayoutUtil.generateUniqueKey(folderData?.getGridInfo()));
  }

  /**
   * 释放截图
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  releaseDragSnapshot(msg: string, folderId: string): void {
    log.showInfo(TAG, '%{public}s: release snapshot for folder %{public}s', msg, folderId);
    let folderData = this.mFolderMgr.getFolder(folderId);
    const key = GridLayoutUtil.generateUniqueKey(folderData?.getGridInfo());
    return dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, key);
  }

  /**
   * 文件夹拖出应用后落位
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param type 落位类型
   * @param param 落位参数
   */
  public drop(msg: string, folderId: string, type: number, param: FolderDragItem): void {
    switch (type) {
      case FolderDropType.DROP_CREATE_FOLDER:
        this.dropToCreateFolder(msg, param);
        break;
      case FolderDropType.MULTI_DROP_CREATE:
        this.dropMultiAppToCreate(msg, param);
        break;
      case FolderDropType.DROP_IN_FOLDER:
        this.dropAppsToFolder(msg, folderId, param);
        break;
      case FolderDropType.DROP_TO_DESKTOP:
        this.dropToDesktop(msg, folderId, param);
        break;
      case FolderDropType.DROP_REFRESH_FOLDER:
        this.dropRefreshFolder(msg, folderId, param);
        break;
      case FolderDropType.DROP_REFRESH_DOCK:
        this.dropRefreshOnDock(msg, folderId, param);
        break;
      case FolderDropType.DROP_BACK:
        this.dropBackEnd(msg, folderId, param)
      default:
        break;
    }
    this.mIsDragStart = false;
  }

  /**
   * 拖拽应用列表到文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param appItems 拖拽的应用列表
   */
  private dropAppsToFolder(msg: string, folderId: string, param: FolderDragItem, isAnimate: boolean = true): void {
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    let appItems: GridLayoutItemInfo[] = param.getDragItems();
    if (folder.isEmptyGrid() || CheckEmptyUtils.isEmptyArr(appItems)) {
      log.showError(TAG, 'the folder is not found with folderId %{public}s', folderId);
      return;
    }
    // 拖拽到文件夹中, 拖拽已经结束, 清理拖拽对象, 避免业务流程错误(例如下载进度计算等)
    this.mFolderMgr.setDragItemFolder(undefined);
    log.showInfo(TAG, '%{public}s: drag item %{public}s in folder %{public}s', msg, appItems[0].bundleName, folderId);
    let result: boolean = this.mFolderMgr.addItemsToFolder(msg, appItems, folderId, true);
    if (result && isAnimate && (appItems.length === 1)) {
      const folderItem: GridLayoutItemInfo = folder.getGridInfo();
      this.mActionEventMgr.notify(msg, folderItem, FolderActionLifeCycleStatus.DRAG_TO_FOLDER);
    }
  }

  /**
   * 拖拽创建文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param endItem 拖拽被覆盖的元素
   * @param dragItems 拖拽的应用列表
   * @param x 松手落位x轴坐标
   * @param y 松手落位y轴坐标
   */
  private dropToCreateFolder(msg: string, param: FolderDragItem): void {
    let endItem: GridLayoutItemInfo = param.getEndItem();
    let dragItems: GridLayoutItemInfo[] = param.getDragItems();
    if (CheckEmptyUtils.isEmpty(endItem) || dragItems.length === 0) {
      log.showWarn(TAG, 'create folder failure with error param of null item: %{public}s', msg);
      return;
    }
    log.showInfo(TAG, '%{public}s, endItem: %{public}s, dragNum: %{public}d', msg, endItem.keyName, dragItems.length);
    let folderName: string =
      ContractedFolderCommonViewModel.getInstance().generateFolderName('create new folder', endItem, dragItems);
    let folderInfo: GridLayoutItemInfo = this.createFolderInfo(endItem, folderName);
    if (param.refreshType === FolderDataRefreshType.DESKTOP) {
      const dropX: number = param.getDropX() as number;
      const dropY: number = param.getDropY() as number;
      param.dragCoverItem = this.getDragCoveredItem(endItem, dragItems[0], dropX, dropY);
    }
    this.mFolderLayoutVM.pushFolderCreateAnimation(() => {
      this.mFolderMgr.setDragCoveredItem(param.dragCoverItem, folderInfo.folderId);
      this.mActionEventMgr.notify('create Folder Animate', folderInfo, FolderActionLifeCycleStatus.DRAG_TO_FOLDER);
    });
    param.setCreateFolderInfo(folderInfo);
    this.createNewFolderByDrag(msg, endItem, dragItems, param.refreshType, folderInfo);
  }

  /**
   * 设置拖拽覆盖item
   *
   * @param endLayoutInfo 覆盖的元素
   * @param startLayoutInfo 拖动元素
   * @param x 拖拽元素的位置x
   * @param y 拖拽元素的位置y
   */
  private getDragCoveredItem(endLayoutInfo: GridLayoutItemInfo, startLayoutInfo: GridLayoutItemInfo, x: number,
    y: number): DragCoveredItem {
    log.showInfo(TAG, 'coverItem: x: %{public}d, y: %{public}d, row: %{public}d, column: %{public}d',
      endLayoutInfo.row, endLayoutInfo.column, x, y);
    let appPosition: number[] = GridLayoutUtil.getIconCenterPosition(endLayoutInfo.row, endLayoutInfo.column,
      endLayoutInfo.area, endLayoutInfo.page);
    let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
    dragCoveredItem.isCreateSmallFolder = true;
    dragCoveredItem.coveredAppPositionX = appPosition[0];
    dragCoveredItem.coveredAppPositionY = appPosition[1];
    dragCoveredItem.dragItemInfo = startLayoutInfo;
    dragCoveredItem.coveredItemInfo = endLayoutInfo;
    dragCoveredItem.dragItemInfoX = x;
    dragCoveredItem.dragItemInfoY = y;
    dragCoveredItem.coveredItemUpperLeftPosition = appPosition;
    dragCoveredItem.folderType = COVER_FOLDER_TYPE.DESKTOP_FOLDER;
    return dragCoveredItem;
  }

  /**
   * 拖拽创建文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param endItem 拖拽被覆盖的元素
   * @param dragItems 拖拽的应用列表
   * @param x 松手落位x轴坐标
   * @param y 松手落位y轴坐标
   */
  private dropMultiAppToCreate(msg: string, param: FolderDragItem): void {
    let endItem: GridLayoutItemInfo = param.getEndItem();
    let dragItems: GridLayoutItemInfo[] = param.getDragItems();
    log.showInfo(TAG, '%{public}s, endItem: %{public}s, dragItemNum: %{public}d', msg, endItem.keyName,
      dragItems.length);
    let folderName: string =
      ContractedFolderCommonViewModel.getInstance().generateFolderName('create new folder', endItem, dragItems);
    let folderInfo: GridLayoutItemInfo = this.createFolderInfo(endItem, folderName);
    // 多选落位动效
    MultiSelectManager.getInstance().startDropToFolder(param.getDropX(), param.getDropY(), folderInfo);
    this.createNewFolderByDrag(msg, endItem, dragItems, param.refreshType, folderInfo);
  }

  /**
   * 拖拽创建一个新的文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param endItem 拖拽被覆盖的元素
   * @param dragItems 拖拽的合成文件夹的元素
   * @returns GridLayoutItemInfo 创建的文件夹item
   */
  private createNewFolderByDrag(msg: string, endItem: GridLayoutItemInfo, dragItems: GridLayoutItemInfo[],
    refreshType: number, folder?: GridLayoutItemInfo): GridLayoutItemInfo {
    let folderName: string =
      ContractedFolderCommonViewModel.getInstance().generateFolderName('create new folder', endItem, dragItems);
    let folderInfo: GridLayoutItemInfo = folder ?? this.createFolderInfo(endItem, folderName);
    if (refreshType === FolderDataRefreshType.DOCK) {
      folderInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
      folderInfo.isInDock = true;
    }
    let folderApps: GridLayoutItemInfo[] = [endItem, ...dragItems];
    this.mFolderMgr.createFolder(msg, folderInfo, folderApps, refreshType, false);
    FolderAccessibilityUtils.updateAccessibilityFocusable(folderInfo.folderId as string);
    if (!folderInfo.isInDock && PageDesktopModel.getInstance().getPageIndex() !== folderInfo.page) {
      AppStorage.setOrCreate(desktopUtil.getPageIndex(), folderInfo.page);
    }
    // 文件夹打点-生成小文件夹
    FolderReporter.getInstance().reportCreateFolder(folderInfo as Object as FolderItemInfo, false, folderInfo);
    // 无障碍语音播报合成文件夹
    this.textAnnouncedForMerge(folderInfo, endItem, dragItems[0]);
    return folderInfo;
  }

  /**
   * 创建一个新的文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param endItem 合成文件夹首个元素
   * @param items 合成文件夹的非首个元素的其他元素列表
   */
  public createNewFolder(msg: string, endItem: GridLayoutItemInfo, items: GridLayoutItemInfo[]): GridLayoutItemInfo {
    let folderName: string =
      ContractedFolderCommonViewModel.getInstance().generateFolderName('create new folder', endItem, items);
    let folderInfo: GridLayoutItemInfo = this.createFolderInfo(endItem, folderName);
    let folderApps: GridLayoutItemInfo[] = [endItem, ...items];
    this.mFolderMgr.createFolder(msg, folderInfo, folderApps, FolderDataRefreshType.DESKTOP, true);
    // 文件夹打点-生成小文件夹
    FolderReporter.getInstance().reportCreateFolder(folderInfo as Object as FolderItemInfo, false, folderInfo);
    // 无障碍语音播报合成文件夹
    this.textAnnouncedForMerge(folderInfo, endItem, items[0]);
    return folderInfo;
  }

  private textAnnouncedForMerge(folderInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo,
    startLayoutInfo: GridLayoutItemInfo | DockItemInfo | AppItemInfo): void {
    const row: number = folderInfo.row as number;
    const col: number = folderInfo.column as number;
    const page: number = folderInfo.page as number;
    let fallIndex: number[] = [row + 1, col + 1];
    // 合并位置为折叠屏展开态的右屏，column需要更新
    if (desktopUtil.isFoldExpandStatus() && page % StyleConstants.DEFAULT_2 !== 0) {
      fallIndex[1] += LaunchLayoutCacheManager.getInstance().selectLayoutDescription().column;
    }
    let realFolderName: string = FolderCommonUtil.getRealFolderName(folderInfo.folderName);
    DragAccessibilityUtils.textAnnouncedForDropMergeToDesktop(startLayoutInfo.appName, endLayoutInfo.appName,
      realFolderName, fallIndex);
  }

  private createFolderInfo(endItem: GridLayoutItemInfo, folderName: string, folderId?: string): GridLayoutItemInfo {
    const folderConfig: FolderLayoutStruct = FolderModel.getInstance().getSmallFolderLayout();
    let id: string | undefined = folderId;
    if (CheckEmptyUtils.isEmpty(id)) {
      id = FolderCommonUtil.generateFolderId();
    }
    const folderInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    folderInfo.infoId = id;
    folderInfo.folderId = id;
    folderInfo.folderName = folderName;
    folderInfo.keyName = id;
    folderInfo.layoutInfo = [];
    folderInfo.typeId = CommonConstants.TYPE_FOLDER;
    folderInfo.area = folderConfig.area;
    folderInfo.badgeNumber = 0;
    folderInfo.bundleName = id as string;
    folderInfo.container = CommonConstants.CONTAINER_DESKTOP;
    folderInfo.page = endItem.page;
    folderInfo.column = endItem.column;
    folderInfo.row = endItem.row;
    folderInfo.landscapePage = endItem.landscapePage;
    folderInfo.landscapeColumn = endItem.landscapeColumn;
    folderInfo.landscapeRow = endItem.landscapeRow;
    folderInfo.portraitPage = endItem.portraitPage;
    folderInfo.portraitRow = endItem.portraitRow;
    folderInfo.portraitColumn = endItem.portraitColumn;
    return folderInfo;
  }

  /**
   * 拖拽应用出文件夹落位
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param dragItems 拖拽的元素
   */
  private dropRefreshFolder(msg: string, folderId: string, param: FolderDragItem): void {
    log.showInfo(TAG, 'start to %{public}s from folder %{public}s', msg, folderId);
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    let dragItems: GridLayoutItemInfo[] = param.getDragItems();
    if (folder.isEmptyGrid() || CheckEmptyUtils.isEmptyArr(dragItems)) {
      log.showError(TAG, 'the folder in not found with folderId %{public}s', folderId);
      return;
    }
    let folderAppList: GridLayoutItemInfo[] =
      FolderCommonUtil.filterListAfterUninstall(folder.getGridInfo(), dragItems, false);
    this.refreshFolder(msg, folderId, folderAppList, dragItems[0].keyName as string);
    this.mFolderMgr.setDragLeaveFolderId(FolderCommonConstants.INVALID_FOLDER_ID);
  }

  private dropToDesktop(msg: string, folderId: string, param: FolderDragItem): void {
    log.showInfo(TAG, 'start to %{public}s from folder %{public}s', msg, folderId);
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    let dragItems: GridLayoutItemInfo[] = param.getDragItems();
    if (folder.isEmptyGrid() || CheckEmptyUtils.isEmptyArr(dragItems)) {
      log.showError(TAG, 'the folder in not found with folderId %{public}s', folderId);
      return;
    }
    // 仅判断落位于桌面场景，dock区由dock维护的拖拽方案判断能否落位
    let isDock: boolean = folder.getGridInfo().container === CommonConstants.CONTAINER_SMARTDOCK;
    if (!FolderCommonUtil.isEnoughDropSpace() && !isDock) {
      log.showInfo(TAG, 'not enough space to drop item');
      this.showAddMax();
      return;
    }
    let folderAppList: GridLayoutItemInfo[] =
      FolderCommonUtil.filterListAfterUninstall(folder.getGridInfo(), dragItems, false);
    this.refreshFolder(msg, folderId, folderAppList, dragItems[0].keyName as string);
    this.mFolderMgr.setDragLeaveFolderId(FolderCommonConstants.INVALID_FOLDER_ID);
  }

  private dropRefreshOnDock(msg: string, folderId: string, param: FolderDragItem): void {
    let appList: GridLayoutItemInfo[] = param.getAppList();
    let dragItems: GridLayoutItemInfo[] = param.getDragItems();
    this.mFolderMgr.setDragLeaveFolderId(FolderCommonConstants.INVALID_FOLDER_ID);
    if (CheckEmptyUtils.isEmptyArr(dragItems)) {
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      const folder: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
      appList = FolderCommonUtil.filterListAfterUninstall(folder, dragItems, false);
      log.showInfo(TAG, 'the appList size %{public}d after refresh on dock', appList.length);
    }
    this.refreshFolder(msg, folderId, appList, dragItems[0].keyName as string);
  }

  private refreshFolder(msg: string, folderId: string, appList: GridLayoutItemInfo[], hidKeyName: string): void {
    let isRelease: boolean = FolderCommonUtil.isNeedReleased(appList, folderId)
    log.showInfo(TAG, '%{public}s refresh folder %{public}s isRelease: %{public}s', msg, folderId, isRelease);
    if (isRelease) {
      let lastItem: GridLayoutItemInfo | undefined = appList.length === 1 ? appList[0] : undefined;
      this.mFolderMgr.setDisappearLastAppData(FolderCommonUtil.getDisappearFolderData(folderId, lastItem, hidKeyName));
      ContractedFolderCommonViewModel.getInstance().disbandFolder(msg, folderId);
    } else {
      this.mFolderMgr.updateFolderLayoutWithDb(msg, folderId, appList, true);
    }
  }

  /**
   * 落位返回源文件夹
   *
   * @param msg
   * @param folderId
   * @param dragItemInfo
   */
  private dropBackEnd(msg: string, folderId: string, param: FolderDragItem): void {
    if (!this.mIsDragStart) {
      return;
    }
    this.mIsDragStart = false;
    this.mFolderMgr.setDragAppToFolder(new DragAppToFolderData());
    this.mFolderMgr.setDragItemFolder(undefined);
    this.dropAppsToFolder(msg, folderId, param, false);
  }

  /**
   * 弹出添加超出最大数量提示
   */
  private showAddMax(): void {
    try {
      Prompt.showToast({
        message: this.mAddMaxMessage
      });
    } catch (error) {
      log.error(TAG, 'removeAppOutOfFolder: Prompt error', error);
    }
  }

  /**
   * 拖拽覆盖文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isShow 是否显示状态
   */
  public onFolderCovered(msg: string, folderId: string, isShow: boolean): void {
    log.showInfo(TAG, '%{public}s, onFolderCovered folderId: %{public}s, isShow: %{public}s', msg, folderId, isShow);
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    if (folderId === '-1' || folder.isEmptyGrid()) {
      log.showError(TAG, 'the folder in not found with folderId %{public}s', folderId);
      return;
    }
    let folderItem: GridLayoutItemInfo = folder.getGridInfo();
    if (isShow) {
      this.folderZoomIn(msg, folderItem);
    } else {
      this.folderZoomOut(msg, folderItem);
    }
  }

  private folderZoomIn(msg: string, folder: GridLayoutItemInfo): void {
    this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.BACKPLANE_ZOOM_IN);
  }

  private folderZoomOut(msg: string, folder: GridLayoutItemInfo): void {
    this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.BACKPLANE_ZOOM_OUT);
  }
}