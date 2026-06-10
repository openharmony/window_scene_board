/**
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

import performanceMonitor from '@ohos.arkui.performanceMonitor';
import Prompt from '@ohos.promptAction';
import { CheckEmptyUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { DragConstants } from '@ohos/commonconstants';
import { DropAnimationDestination } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DragEventManager } from '@ohos/componentdrag';
import { DragAccessibilityUtils, ItemUtils, ObjectCopyUtil, RectangularCoordinates } from '@ohos/componenthelper';
import {
  AccessibilityManager,
  GlobalContext,
  HiSysEventUtil,
  ResourceManager
} from '@ohos/frameworkwrapper';
import {
  AppStatus,
  CommonConstants,
  EditModeUtils,
  FolderConstants,
  FolderLayoutInOpen,
  FolderModel,
  FolderReporter,
  GridLayoutItemInfo,
  GridLayoutUtil,
  layoutLockUtil,
  FolderAccessibilityUtil,
  NotHarmonyUtil,
  OpenFolderStyle,
  OpenFolderStyleConfig,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  ContractedFolderLayoutViewModel,
  FolderCommonUtil,
  FolderManager,
  FolderLifeCyclePriority,
  FolderDataListener,
  FolderStyleConstants,
  MultiSelectItemType,
  MultiSelectListenerType,
  multiSelectListenManger,
  ListenerItemType,
  MultiSelectManager,
} from '@ohos/launchercommon';
import {
  AppBubbleParams,
  batchUninstallChain,
  ForwardType,
  ContractedFolderCommonViewModel,
} from '@ohos/launchercommon/Index';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import FeatureConstants from '../common/constants/FeatureConstants';
import { DragItemFromFolderStartInfo } from '../common/DragItemFromFolderStartInfo';
import { FolderAccessibilityUtils } from '../common/FolderAccessibilityUtils';
import OpenFolderDragHandler from '../common/OpenFolderDragHandler';
import { BigFolderViewModel } from '../viewmodel/BigFolderViewModel';
import { openFolderVm } from '../viewmodel/OpenFolderViewModel';
import { openCloseAniMgr } from '../viewmodel/openclose/OpenCloseActionManager';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import { DragViewModel } from '../viewmodel/drag/DragViewModel';
import { OpenFolderAppBubbleNodeManager } from './node/OpenFolderAppBubbleNodeManager';
import { FolderEventConstants } from '@ohos/launchercommon/src/main/ets/constants/FolderEventConstants';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'OpenFolderSwiperPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct OpenFolderSwiperPage {
  @StorageLink('isDrag') isDrag: boolean = false;
  @StorageLink('selectItemInFolder') selectItem: string = '';
  @StorageLink('hoverItemInFolder') hoverItem: string = '';
  @StorageProp('isAccessibilityMode') @Watch('onAccessibilityModeChange') isAccessibilityMode: boolean = false;
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_FOLDER;
  @StorageLink('dragItemFromFolder') dragItemFromFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageLink('unInstallItemInfo') @Watch('moveAfterUninstall') folderUnInstallItemInfo: GridLayoutItemInfo =
    new GridLayoutItemInfo();
  @StorageLink('isPad') isPad: boolean = false;
  @StorageLink('isAddIconHidden') @Watch('updateAddIconWhenDrag') isAddIconHidden: boolean = false;
  @StorageLink('isDragLeave') isDragLeave: boolean = false;
  @StorageLink('openSmallFolderFlag') openSmallFolderFlag: boolean = false;

  @Consume('isSmallFolderImage') isSmallFolderImage: boolean;
  @Consume('openFolderFlag') openFolderFlag: boolean;

  @Link @Watch('updateSwiperWhenSwitch') isSwitchingPage: boolean;
  @Link switchToPageIndex: number;
  @Link isSwiperClipForce: boolean;
  @Link openFolderRect: RectInfo;

  @Prop gridGap: number = 0;
  @Prop gridRowGap: number = 0;
  @Prop isChangingPage: boolean = false;
  @Prop isGeometryTransiting: boolean = false;
  @Prop appItemWidth: number = FolderStyleConstants.DEFAULT_APP_ITEM_WIDTH;
  @Prop appNameSize: number = FolderStyleConstants.DEFAULT_APP_NAME_SIZE;
  @Prop addIconSize: number = FolderStyleConstants.DEFAULT_ADD_APP_SIZE;
  @Prop gridHeight: number = 0;
  @Prop gridPadding: number = 0;
  @Prop columnsTemplate: string = '';
  @Prop rowsTemplate: string = '';
  @Prop mFolderIconRadius: number = 0;
  @Prop isRenaming: boolean;
  @Prop folderGridWith: number = 0;

  @State @Watch('onCurrentPageAppListChange') mAppInfo: GridLayoutItemInfo[] = [];
  @State placeHolders: GridLayoutItemInfo[] = [];
  @State isSqueezeAnimationStart: boolean = false;
  @State dragKeyName: string = '';
  @State isShowCorner: boolean = false;
  @State folderHorizontalPending: number = 0;
  @State multiSelectMap: Map<string, MultiSelectItemType> = MultiSelectManager.getInstance().multiSelectMap;

  switchFolderPage?: Function;
  private pageIndex: number = 0;
  private uninstalledList: string[] = [];
  private lastDragX: number = 0;
  private lastDragY: number = 0;
  private lastDragTime: number = 0;
  private folderId: string = '';
  private isSmallFolder: boolean = true;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private openFolderGridId: string = 'openFolderGrid_' + this.pageIndex;
  private mTempGridInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mStatusOnDrop: string = FeatureConstants.STATUS_NO_WAIT_ITEM_MOVE_ANIMATION
  private dropOnDesktop?: Function;
  private uninstallAppPageIndex: number = 0;
  private folderPageLength: number = 0;
  private mFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private dragLeaveFolderSetTimeoutId: number = 0;
  private mFolderModel: FolderModel = FolderModel.getInstance();
  private folderAppBubbleNodeManager: OpenFolderAppBubbleNodeManager = OpenFolderAppBubbleNodeManager.getInstance();
  private openFolderStyle: OpenFolderStyle = OpenFolderStyleConfig.getInstance().getOpenFolderStyle();
  private mFolderMgr: FolderManager = FolderManager.getInstance();
  // todo 展开态MVVM解耦后迁移到viewModel
  private mOpenFolderChangeListener: FolderDataListener = {
    description: 'OpenFolderData change to refresh OpenFolderSwiperPage',
    priority: FolderLifeCyclePriority.NORMAL,
    updateOpenFolder: (updateFolder: GridLayoutItemInfo) => {
      this.refreshItem(updateFolder);
    },
    updateFolder: (folderId: string, folderItems: GridLayoutItemInfo[]) => {
      if (this.mFolderMgr.getOpenFolderId() !== folderId) {
        return;
      }
      if (FolderCommonUtil.isNeedReleased(folderItems, folderId)) {
        return;
      }
      this.refreshItem(this.mFolderMgr.getFolder(folderId).getGridInfo());
    }
  };
  private isNeedRevert: boolean = false;

  private refreshItem(updateFolder: GridLayoutItemInfo): void {
    if (this.needInterruptRefresh(updateFolder)) {
      log.showError(`interrupt refresh page${this.pageIndex} when drag in callback.`);
      return;
    }
    if (GridLayoutUtil.isValidLayoutItem(updateFolder) && updateFolder.layoutInfo?.[this.pageIndex]) {
      this.mAppInfo = updateFolder.layoutInfo[this.pageIndex];
    } else {
      this.mAppInfo = [];
    }
  }

  private mOpenFolderCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      this.selectItem = '';
      this.hoverItem = '';
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      // 由于swiper的动效打断接口无效，关闭时需将其他页隐藏，避免进行关闭动效时有其他页残留
      if (this.pageIndex !== this.mFolderMgr.getPageIndex()) {
        log.showInfo('closing folder, clear swiper pageIndex: %{public}d', this.pageIndex);
        this.mAppInfo = [];
      } else {
        log.showInfo('closing folder, icons need revert pageIndex: %{public}d', this.pageIndex);
        this.isNeedRevert = true;
      }
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      // 避免关闭文件夹动效被打断时的动效残留，需在closed状态进行布局清空
      this.mAppInfo = [];
    }
  }
  // 落位导航条时清除dragLeave状态
  private resetDragLeaveEvent: Function = (): void => {
    this.isDragLeave = false
  };
  private pageIndexInDesktop: number = 0;
  private isInDock: boolean = false;
  // swiperPage对象创建时生命周期并未执行，导致当@StorageLink变量变更时会触发@Watch方法进行一些冗余耗时处理
  // 添加此变量用于区分@watch方法是否需要执行
  private isAboutToAppear: boolean = false;

  private multiSelectListener?: MultiSelectListenerType = undefined;

  /** 编辑模式多选事件监听 */
  private registerMultiSelectListener(): void {
    this.multiSelectListener = {
      id: multiSelectListenManger.getListenerId(
        ListenerItemType.OPEN_FOLDER_SWIPER_ITEM, this.pageIndex.toString(), false),
      onUpdatingMultiSelectMap: (): void => {
        log.showInfo(`open folder page ${this.pageIndex} is onUpdatingMultiSelectMap`);
        if (this.isAccessibilityMode) {
          this.multiSelectMap = MultiSelectManager.getInstance().multiSelectMap;
        }
      },
    }
    multiSelectListenManger.register(this.multiSelectListener);
  }

  private unRegisterMultiSelectListener() {
    multiSelectListenManger.unregister(this.multiSelectListener);
  }

  private onAccessibilityModeChange(): void {
    if (this.isAccessibilityMode) {
      this.multiSelectMap = MultiSelectManager.getInstance().multiSelectMap;
    }
  }

  private revertItem(item: GridLayoutItemInfo): void {
    // 退出场景, 恢复组件状态, 方便下次正常使用
    openFolderAppBubbleLayout.revertAppData(item, `swiperPage ${item.keyName}`);
    if (AppStorage.get<boolean>('showDesktopBadges')) {
      // 退出场景, 恢复角标
      const key = `${FolderConstants.OPEN_CLOSE_FOLDER_ITEM_BADGE_CHANGE}${item.keyName}`;
      GlobalContext.getContext()?.eventHub.emit(key);
    }
  }

  // 起拖时隐藏加号会触发数据刷新，除包含加号的最后一页，其他页不需要
  private needInterruptRefresh(folder: GridLayoutItemInfo): boolean {
    if (!AppStorage.get<boolean>('dragFolderApp')) {
      return false;
    }
    return this.pageIndex !== (folder?.layoutInfo?.length ?? 0) - 1;
  }

  private updateOpenFolderAppBubbleParams(
    paramsUpdater: (itemParams: AppBubbleParams, itemInfo: GridLayoutItemInfo) => boolean
  ): void {
    this.mAppInfo.forEach((item: GridLayoutItemInfo) => {
      if (!item) {
        return;
      }
      let params: AppBubbleParams = this.folderAppBubbleNodeManager.getNodeParams(item.keyName || '');
      let hasController: boolean = this.folderAppBubbleNodeManager.hasNodeController(item.keyName || '');
      params.forceShowBadge = !hasController;
      log.showInfo(`params status: ${params.status} item status: ${item.appStatus} item bundleName:` +
        `${item.bundleName} hasController: ${hasController}`);
      if ((params.status === AppStatus.INSTALLED && item.appStatus === AppStatus.UPDATING) ||
        (params.status === AppStatus.UPDATING && item.appStatus === AppStatus.INSTALLED) ||
        (params.status === AppStatus.PENDING && item.appStatus !== params.status)) {
        log.showInfo(`delete folderAppBubble nodeKey ${item.keyName || ''} when app update`);
        this.folderAppBubbleNodeManager.deleteNodeController(item.keyName || '');
      }
      let needUpdate: boolean = paramsUpdater(params, item);
      if (needUpdate) {
        this.folderAppBubbleNodeManager.updateNodeParams(item.keyName || '', params, 'updateNode in swiperPage');
      }
    });
  }

  private onCurrentPageAppListChange(): void {
    this.updateOpenFolderAppBubbleParams((
      itemParams: AppBubbleParams,
      itemInfo: GridLayoutItemInfo
    ): boolean => {
      const originParamsStr: string = JSON.stringify(itemParams);
      const openFolder: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      itemParams.common = this.folderAppBubbleNodeManager.getAppBubbleCommonParams();
      itemParams.item = itemInfo;
      itemParams.index = this.mFolderMgr.getIndexInFolder(itemInfo, openFolder);
      itemParams.pageIndex = this.mFolderMgr.getPageIndexInFolder(itemInfo, openFolder);
      itemParams.status = itemInfo.appStatus;
      const newParamsStr: string = JSON.stringify(itemParams);
      return newParamsStr !== originParamsStr;
    });
  }

  updateOpenFolderSwiper(): void {
    if (!this.isAboutToAppear) {
      return;
    }
    ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(() => {
      const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      this.mAppInfo = openFolderData.layoutInfo?.[this.pageIndex] ?? [];
    });
  }

  updateAddIconWhenDrag(): void {
    if (!this.isAboutToAppear) {
      return;
    }
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (this.needInterruptRefresh(openFolderData)) {
      log.showError(`interrupt refresh page${this.pageIndex} when drag.`);
      return;
    }
    this.mAppInfo = openFolderData.layoutInfo?.[this.pageIndex] ?? [];
  }

  updateSwiperWhenSwitch(): void {
    if (this.isSwitchingPage) {
      this.updateOpenFolderSwiper();
      return;
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear pageIndex: %{public}d', this.pageIndex);
    this.uninstalledList = [];
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    this.pageIndexInDesktop = openFolderData.page ?? CommonConstants.INVALID_VALUE;
    this.isInDock = openFolderData.isInDock ?? false;
    this.isAboutToAppear = true;
    const isFolderOpen: boolean = this.mFolderMgr.isFolderOpen();
    if (isFolderOpen) {
      this.mAppInfo = openFolderData.layoutInfo?.[this.pageIndex] || [];
    } else {
      log.showInfo('aboutToAppear folder not open');
    }
    this.fillPlaceHolders();
    this.desktopContext?.eventHub.on(DragConstants.SMART_DOCK_DROP_EVENT, this.resetDragLeaveEvent);
    this.mFolderMgr.registerDataLifeListener(this.mOpenFolderChangeListener);
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenFolderCallback);
    this.registerMultiSelectListener();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear pageIndex: %{public}d', this.pageIndex);
    this.uninstalledList = [];
    this.desktopContext?.eventHub.off(DragConstants.SMART_DOCK_DROP_EVENT, this.resetDragLeaveEvent);
    this.mFolderMgr.unregisterDataLifeListener(this.mOpenFolderChangeListener);
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenFolderCallback);
    // 内存清理
    this.dropOnDesktop = undefined;
    this.switchFolderPage = undefined;
    this.unRegisterMultiSelectListener();
  }

  private fillPlaceHolders(): void {
    if (this.mFolderModel.getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4 && this.isSmallFolder) {
      let maxPerPage = this.mFolderModel.getFolderOpenLayout().column * this.mFolderModel.getFolderOpenLayout().row;
      if (this.mAppInfo.length < maxPerPage) {
        let placeHolderCnt = maxPerPage - this.mAppInfo.length;
        for (let i = 0; i < placeHolderCnt; i++) {
          let placeHolder = new GridLayoutItemInfo();
          placeHolder.bundleName = FeatureConstants.PLACEHOLDER_IN_OPEN_FOLDER_GRID +
            `${this.pageIndex}_${i + this.mAppInfo.length}`;
          this.placeHolders.push(placeHolder);
        }
      }
    }
  }

  private setSelectItem(isSelect: boolean, item: GridLayoutItemInfo) {
    if (!isSelect) {
      AppStorage.setOrCreate('selectItemInFolder', '');
      return;
    }
    if (item == null) {
      return;
    }
    if (item.typeId != CommonConstants.TYPE_ADD) {
      AppStorage.setOrCreate('selectItemInFolder', item.bundleName);
    } else {
      AppStorage.setOrCreate('selectItemInFolder', FeatureConstants.OPEN_FOLDER_ADD_APP_ICON);
    }
  }

  private setHoverItem(isHover: boolean, item: GridLayoutItemInfo) {
    if (!isHover) {
      AppStorage.setOrCreate('hoverItemInFolder', '');
      return;
    }
    if (item == null) {
      return;
    }
    if (item.typeId != CommonConstants.TYPE_ADD) {
      AppStorage.setOrCreate<string>('hoverItemInFolder', item.bundleName);
    } else {
      AppStorage.setOrCreate<string>('hoverItemInFolder', FeatureConstants.OPEN_FOLDER_ADD_APP_ICON);
    }
  }

  isSelected(item: GridLayoutItemInfo) {
    if (item == null) {
      return false;
    }
    if (item.typeId != CommonConstants.TYPE_ADD) {
      return this.selectItem == item.bundleName;
    } else {
      return this.selectItem == FeatureConstants.OPEN_FOLDER_ADD_APP_ICON;
    }
  }

  isHovered(item: GridLayoutItemInfo) {
    if (item == null) {
      return false;
    }
    if (item.typeId != CommonConstants.TYPE_ADD) {
      return this.hoverItem == item.bundleName;
    } else {
      return this.hoverItem == FeatureConstants.OPEN_FOLDER_ADD_APP_ICON;
    }
  }

  isNeedBorder(item: GridLayoutItemInfo) {
    if (this.isSelected(item) || this.isHovered(item)) {
      return true;
    } else {
      return false;
    }
  }

  onDragDrop(event: DragEvent): boolean {
    const dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    if (dragItemInfo?.keyName === undefined) {
      return false;
    }
    // 文件夹挤位场景下，虚拟切割已完成但真实切割未完成时，落位时不刷新布局，待落位完成后根据mTempGridInfo进行刷新
    // 故此处需要拷贝，不能直接修改OpenedFolder
    this.mTempGridInfo = ObjectCopyUtil.deepClone(this.mFolderMgr.getOpenedFolder());
    if (!this.mTempGridInfo || !this.mTempGridInfo.layoutInfo || this.mTempGridInfo.folderId !== this.folderId) {
      log.showError('updateTempGridInfo: tempGridInfo undefined');
      return false;
    }

    let dropIndex = OpenFolderDragHandler.getInstance().getDragEndIndex();
    OpenFolderDragHandler.getInstance()
      .updateLayoutCacheAfterFillPosition(this.mTempGridInfo.layoutInfo[this.pageIndex]);
    this.mFolderMgr.setDragItemFolder(undefined);
    this.mFolderMgr.updateOpenFolderLayout(this.mStatusOnDrop, this.mTempGridInfo.layoutInfo?.flat(), true);
    OpenFolderDragHandler.getInstance().resetTranslateZero('onDragDrop');
    this.sendDropStartEvent();
    OpenFolderDragHandler.getInstance().dragDrop(event, dropIndex, GridLayoutUtil.generateUniqueKey(dragItemInfo),
      (key: string) => this.onDropAnimationFinish(key));
    if (!this.isSmallFolder) {
      openFolderVm.setDropAnimationStart();
    }

    const appPosition: number[] = openFolderVm.calculateArea(this.mTempGridInfo?.layoutInfo, dragItemInfo);
    const dragFromFolderStartInfo: DragItemFromFolderStartInfo | null =
      BigFolderViewModel.getInstance().getDragFromFolderStartInfo();
    // 文件夹打点 - 文件夹_打开_长按应用/快捷方式图标_拖动调位
    const openFolderId: string = this.mFolderMgr.getOpenFolderId();
    FolderReporter.getInstance().reportMoveIconInFolder(this.mTempGridInfo, this.pageIndex, dragItemInfo,
      dragFromFolderStartInfo?.dragItemFolderPosition, appPosition, openFolderId);
    // 无障碍播报文件夹里图标落位位置
    let folderOpenColumn: number = this.mFolderModel.getFolderOpenLayout().column;
    let fallIndex: number[] = [Math.floor(dropIndex / folderOpenColumn) + 1, dropIndex % folderOpenColumn + 1];
    let dragAppName: string = this.getAppName(dragItemInfo);
    DragAccessibilityUtils.textAnnouncedForDrop(fallIndex, dragAppName);
    return true;
  }

  private sendDropStartEvent(): void {
    let dragItemInfo: GridLayoutItemInfo = OpenFolderDragHandler.getInstance().getDragItemInfo();
    DragEventManager.getInstance().startDrop(GridLayoutUtil.generateUniqueKey(dragItemInfo));
    this.desktopContext?.eventHub.emit(CommonConstants.DRAG_FOLDER_OPEN_APP_NAME_ANIMATE + dragItemInfo?.keyName);
  }

  private sendDropAnimationEndEvent(key: string): void {
    DragEventManager.getInstance().dropEnd(key);
  }

  private onDropAnimationFinish(key: string): void {
    log.showInfo('onDropAnimationFinish key: %{public}s', key);
    this.sendDropAnimationEndEvent(key);
    log.showInfo('updateTempGridInfo: change openFolderData end');
  }

  /**
   * 获取应用名
   * @param itemInfo
   * @returns
   */
  private getAppName(itemInfo: GridLayoutItemInfo): string {
    let dragAppname: string = '';
    ResourceManager.getInstance().getAppNameWithCache(itemInfo.appLabelId, itemInfo.bundleName,
      itemInfo.moduleName, itemInfo.appName, (name: string) => {
        dragAppname = name;
      }, itemInfo.appIndex);
    return dragAppname;
  }

  onMove(x: number, y: number): void {
    let nowTime = Date.now();
    const openFolderPageIndex: number = this.mFolderMgr.getPageIndex();
    if (this.pageIndex !== openFolderPageIndex) {
      log.showDebug('onDragMove return, openFolderPageIndex=%{public}d,pageIndex=%{public}d', openFolderPageIndex,
        this.pageIndex);
      return;
    }
    // 如果换页直接走换页逻辑  不挤位
    if (this.isSwitchingPage || (this.switchFolderPage && this.switchFolderPage(x, y, nowTime, this.pageIndex))) {
      log.showDebug('onDragMove return, isSwitchingPage: %{public}s', this.isSwitchingPage);
      return;
    }
    let speed = (Math.sqrt(Math.pow(x - this.lastDragX, 2) + Math.pow(y - this.lastDragY, 2))) /
      (nowTime - this.lastDragTime);
    if (speed < 0.1) {
      let endIndex: number = this.getValidEndIndex(OpenFolderDragHandler.getInstance().getCurrentIndex(x, y));
      // 文件夹拖动应用播报当前落位位置，如果当前位置超出最后一个位置，则始终播报最后落位的位置
      if (DragAccessibilityUtils.isAccessibilityMode()) {
        let folderOpenColumn: number = this.mFolderModel.getFolderOpenLayout().column;
        let currentPosition: number = OpenFolderDragHandler.getInstance().getCurrentIndex(x, y);
        let currentIndex: number[] = [Math.floor(currentPosition / folderOpenColumn) + 1,
          currentPosition % folderOpenColumn + 1];
        let fallIndex: number[] = [Math.floor(endIndex / folderOpenColumn) + 1, endIndex % folderOpenColumn + 1];
        DragAccessibilityUtils.textAnnouncedForDragMoveInFolder(fallIndex, currentIndex);
      }
      // 考虑性能, 同一个endIndex不要连续调用
      if (endIndex !== OpenFolderDragHandler.getInstance().getDragEndIndex()) {
        OpenFolderDragHandler.getInstance().startToFillPostion(endIndex, this.pageIndex, 'by drag move');
      }
    }
    this.lastDragX = x;
    this.lastDragY = y;
    this.lastDragTime = nowTime
  }

  getValidEndIndex(endIndex: number): number {
    let lastAppIndex = this.mAppInfo.length - 1;
    if (GridLayoutUtil.isAddIcon(this.mAppInfo[lastAppIndex])) {
      lastAppIndex--;
    }
    return Math.min(endIndex, lastAppIndex);
  }

  private dealAssociatedUninstallApp(): void {
    let isUnInstallItemInfoEmpty = CheckEmptyUtils.isEmpty(this.folderUnInstallItemInfo);
    let isKeyNameEmpty = CheckEmptyUtils.isEmpty(this.folderUnInstallItemInfo.keyName);
    let isBundleNameEmpty = CheckEmptyUtils.isEmpty(this.folderUnInstallItemInfo.bundleName);
    let isAppIndexEmpty = CheckEmptyUtils.isEmpty(this.folderUnInstallItemInfo.appIndex);
    if (isUnInstallItemInfoEmpty || isKeyNameEmpty || isBundleNameEmpty || isAppIndexEmpty) {
      log.showInfo(`param empty ${isUnInstallItemInfoEmpty} ${isKeyNameEmpty} ${isBundleNameEmpty} ${isAppIndexEmpty}`);
      return;
    }
    if (this.folderUnInstallItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return;
    }
    this.mAppInfo.forEach(item => {
      if (this.folderUnInstallItemInfo.appIndex === 0 &&
        item.bundleName === this.folderUnInstallItemInfo.bundleName &&
        item.keyName !== this.folderUnInstallItemInfo?.keyName) {
        this.uninstalledList.push(item.keyName as string)
      }
    })
  }

  isUninstallNotInLastPage(): boolean {
    if (this.folderUnInstallItemInfo?.keyName && this.pageIndex === this.uninstallAppPageIndex &&
      this.pageIndex < this.folderPageLength - 1) {
      log.showInfo('isUninstallInNotLastPage UnInstall pageIndex not in LastPage');
      return true;
    }
    return false;
  }

  // Todo 待优化卸载逻辑从视图解耦
  moveAfterUninstall() {
    if (!this.folderUnInstallItemInfo?.keyName) {
      return;
    }
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (openFolderData?.layoutInfo === undefined) {
      log.showWarn('moveAfterUninstall layoutInfo is undefined');
      return;
    }
    this.uninstallAppPageIndex = this.mFolderMgr.getPageIndexInFolder(this.folderUnInstallItemInfo, openFolderData);
    if (!NotHarmonyUtil.isNotHarmonyFolderById(openFolderData?.folderId)) {
      this.uninstalledList.push(this.folderUnInstallItemInfo?.keyName);
      this.dealAssociatedUninstallApp();
    }
    if (this.pageIndex !== this.uninstallAppPageIndex) {
      return;
    }
    let startUninstallIndex: number = this.mAppInfo.findIndex(item => item?.keyName ===
      this.folderUnInstallItemInfo?.keyName);
    OpenFolderDragHandler.getInstance().initStartAndEndIndex(startUninstallIndex);
    if (startUninstallIndex === -1) {
      log.showInfo('moveAfterUninstall not found folderUnInstallItemInfo');
      return;
    }
    log.showInfo('moveAfterUninstall startIndex:%{public}d endIndex:%{public}d', startUninstallIndex,
      this.mAppInfo.length);
    let dragEndItemIndex = this.mAppInfo.length - 1;
    OpenFolderDragHandler.getInstance().startToFillPostion(dragEndItemIndex, this.pageIndex, 'by Uninstall');
  }

  private itemKeyGenerator(item: GridLayoutItemInfo): string {
    if (!item) {
      return '';
    }
    return (item.appName ? item.appName : '') + item.appIconId + item.bundleName + item.abilityName +
    item.applicationName + item.keyName + item.badgeNumber + item.checked + item.installTime +
    item.iconResource + item.appStatus;
  }

  private sendDragItemLeaveEvent(bundleName: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showError(`On send dragItem leave event, bundleName is empty.`);
      return;
    }
    let appDragItemLeaveEventId: string = `appDragItemLeave${bundleName}folder`;
    this.desktopContext?.eventHub.emit(appDragItemLeaveEventId);
  }

  private buildLog(): boolean {
    log.showInfo('buildLog mAppInfo');
    this.mFolderViewModel.printFolderAppList(this.mAppInfo);
    return true;
  }

  private getTransitionEffect(index: number): TransitionEffect {
    if (FolderModel.getInstance().getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4) {
      return TransitionEffect.opacity(this.isSmallFolder ?
      FolderStyleConstants.DEFAULT_HIDDEN_VALUE : FolderStyleConstants.DEFAULT_VISIBLE_VALUE);
    }
    const appMaxShow: number = GridLayoutUtil.getCountPerPageInFolder(this.mFolderMgr.getOpenedFolder().area ?? [2, 2]);
    if (this.isDrag && !this.isSmallFolder && index >= appMaxShow - 1) {
      // 拖出文件夹展开态且存在需要折叠的图标（3x3文件夹）时，后续新增其他类型文件夹折叠态如果不一致需要在此适配
      return TransitionEffect.opacity(FolderStyleConstants.DEFAULT_HIDDEN_VALUE);
    }
    return TransitionEffect.IDENTITY;
  }

  private dragLeaveFolder(): void {
    if (this.mFolderMgr.isCanOpenFolderDragDrop()) {
      DragViewModel.getInstance().setDragLeaveItemHasDeal(false);
    }
    this.dragLeaveFolderSetTimeoutId = setTimeout(() => {
      if (!this.isDrag && batchUninstallChain.currentType === ForwardType.INIT) {
        OpenFolderDragHandler.getInstance().resetTranslateZero('dragLeaveFolder cancel for isDrag false.');
        clearTimeout(this.dragLeaveFolderSetTimeoutId);
        return;
      }
      // 拖出文件夹概率会多次走入dragLeave逻辑，识别到文件夹已关闭时则无需再次走入
      const isFolderOpen: boolean = this.mFolderMgr.isFolderOpen();
      if (!isFolderOpen) {
        log.showWarn('already closed when drag leave');
        OpenFolderDragHandler.getInstance().resetTranslateZero('dragLeaveFolder cancel for already closed.');
        clearTimeout(this.dragLeaveFolderSetTimeoutId);
        return;
      }
      log.showWarn('onDragLeave DRAG_FROM_FOLDER start');
      AppStorage.setOrCreate('dragFolderApp', false);
      const dragFormTypes = [
        CommonConstants.DRAG_FROM_SWIPE_UP,
        CommonConstants.DRAG_FROM_MANAGE,
        CommonConstants.DRAG_FROM_FORM_SERVICE
      ];
      if (dragFormTypes.includes(AppStorage.get<number>('dragItemType') as number)) {
        ContractedFolderLayoutViewModel.getInstance()
          .updateOpenFolderStatus(FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
        OpenFolderDragHandler.getInstance().resetTranslateZero('dragLeaveFolder cancel for other drag items.');
        clearTimeout(this.dragLeaveFolderSetTimeoutId);
        return;
      }
      const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      AppStorage.setOrCreate<GridLayoutItemInfo>('lastOpenFolderData', openFolderData);
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let dragItemInfo: GridLayoutItemInfo = OpenFolderDragHandler.getInstance().getDragItemInfo();
      dragItem.folderId = openFolderData.folderId;
      dragItem.bundleName = dragItemInfo?.bundleName;
      dragItem.keyName = dragItemInfo?.keyName;
      this.dragKeyName = dragItemInfo?.keyName as string;
      this.mFolderMgr.setDragItemFolder(dragItem);
      this.sendDragItemLeaveEvent(dragItem.bundleName);
      OpenFolderDragHandler.getInstance().startToFillPostion(this.mAppInfo.length - 1, this.pageIndex, 'by dragLeave');
      this.startFolderMoveAnimation(openFolderData, dragItemInfo);
      log.showInfo('onDragLeave DRAG_FROM_FOLDER end');
    }, FeatureConstants.FOLDER_DRAG_LEAVE_DELAY_TIME);
  }

  private startFolderMoveAnimation(openFolderData: GridLayoutItemInfo, dragItemInfo: GridLayoutItemInfo): void {
    ContractedFolderLayoutViewModel.getInstance().waitFolderMoveAnimation(() => {
      if (this.isDragLeave) {
        ContractedFolderCommonViewModel.getInstance()
          .dragLeave('drag leave open Folder', openFolderData.folderId, dragItemInfo);
      } else {
        OpenFolderDragHandler.getInstance().resetTranslateForBreak(this.pageIndex);
        this.dragKeyName = '';
        this.mFolderMgr.setDragItemFolder(undefined);
        log.showWarn('onDragLeave DRAG_FROM_FOLDER return because isDragLeave is false');
      }
    });
  }

  /**
   * 触发拖出前判断拖出事件是否是满足在网格外的拖出条件,避免内部快速挤位的假拖出
   * @param event 拖拽事件event
   */
  private verifyBeforeDragLeave(event: DragEvent | undefined) {
    if (event) {
      let rect = this.openFolderRect;
      let inputX: number = event?.getX() ?? 0;
      let inputY: number = event?.getY() ?? 0;
      log.showInfo(`onDragLeave grid rect ${JSON.stringify(rect)}  event ${inputX}_${inputY}_${this.appItemWidth}`);
      // 拖拽离开展开态网格需要进行补位动效 rect：当前网格的显示区域 appItemWidth:上下快拖时leave报点误差范围
      let leftTopPoint: RectangularCoordinates.Point =
        EditModeUtils.convertOpenFolderCoordinateToEditMode({ x: rect.left, y: rect.top + this.appItemWidth });
      let rightBottomPoint: RectangularCoordinates.Point =
        EditModeUtils.convertOpenFolderCoordinateToEditMode({ x: rect.right, y: rect.bottom });
      if ((inputX < leftTopPoint.x || inputX > rightBottomPoint.x || inputY < leftTopPoint.y ||
        inputY > rightBottomPoint.y)) {
        log.showInfo('onDragLeave, isDragLeave is true');
        this.isDragLeave = true;
        this.dragLeaveFolder();
      } else {
        log.showInfo('onDragLeave, isDragLeave is false');
        this.isDragLeave = false;
      }
    }
  }

  @Builder
  FolderOpenPlaceHolderBuilder(index: number, item: GridLayoutItemInfo): void {
    Column() {
      Stack() {
      }
      .transition(this.isGeometryTransiting ? TransitionEffect.opacity(FolderStyleConstants.DEFAULT_HIDDEN_VALUE) :
      TransitionEffect.IDENTITY)
      .width(this.appItemWidth)
      .height(this.appItemWidth)
      .borderRadius((this.isShowCorner ? this.mFolderIconRadius : AppStorage.get('smallFolderIconRadius') as number))
      .onAppear(() => {
        animateTo({ duration: 450 }, () => {
          this.isShowCorner = true;
        })
      })
      .onDisAppear(() => {
        this.isShowCorner = false;
      })
    }
    .id(`${TAG}_AppBubble_${item?.bundleName}`)
    .transition(this.isGeometryTransiting ? TransitionEffect.opacity(FolderStyleConstants.DEFAULT_HIDDEN_VALUE) :
    TransitionEffect.IDENTITY)
    .width(this.appItemWidth)
    .height(this.appItemWidth)
  }

  // 无障碍屏幕朗读模式下，禁止应用移出文件夹主动播报
  private textAnnouncedForRemoveAppFromFolder(accessibilityReadText: string): void {
    const isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    if (isAccessibilityMode) {
      AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(accessibilityReadText,
        'textAnnouncedForRemoveAppFromFolder');
    }
  }

  private revertAddIcon(): void {
    const addInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    addInfo.typeId = CommonConstants.TYPE_ADD;
    addInfo.bundleName = CommonConstants.SCENEBOARD_BUNDLE;
    addInfo.keyName = FolderEventConstants.KEY_FOLDER_ADD + this.folderId;
    openFolderAppBubbleLayout.revertAppData(addInfo, `swiperPage ${addInfo.keyName}`);
  }

  private getAccessSelectedInEdit(item: GridLayoutItemInfo): boolean {
    const uniqueId: string = MultiSelectManager.getInstance().getUniqueId(item);
    return this.multiSelectMap.has(uniqueId);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Grid() {
        ForEach(this.mAppInfo, (item: GridLayoutItemInfo, index: number) => {
          GridItem() {
            if (item !== undefined && item !== null && item?.keyName !== this.dragKeyName &&
              this.folderUnInstallItemInfo?.keyName !== item?.keyName &&
              this.uninstalledList.indexOf(item?.keyName as string) < 0) {
              NodeContainer(this.folderAppBubbleNodeManager.getOrCreateNode(item.keyName as string, 'swiperPage'))
                .id(`${TAG}_FolderAppItem_${item?.bundleName}`)
                .width(this.openFolderStyle.iconSize)
                .height(this.openFolderStyle.iconSize)
                .transition(this.getTransitionEffect(index))
                .margin({ top: this.openFolderStyle.iconMarginTop })
            }
          }
          .focusable(true)
          .align(Alignment.Top)
          .tabIndex(2)
          .onHover((isHover?: boolean) => {
            if (isHover !== undefined) {
              this.setHoverItem(isHover, this.mAppInfo[index]);
            }
          })
          .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
          // 添加图标只需要单击的播报，有onClick会自动播报，app图标需要单击和长按菜单的播报，用accessibilityDescription处理
          .accessibilityDescription(FolderAccessibilityUtil.getOpenFolderItemAccessibilityText(item,
            this.isAccessibilityMode))
          .accessibilitySelected(this.getAccessSelectedInEdit(item))
          .onClick(this.isAccessibilityMode ? () => {
            this.desktopContext?.eventHub.emit(
              FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(item)
            );
            // 非重命名场景需要用空函数消费掉click事件, 避免点击关闭, 重命名场景需要undefined, 让上层组件的click消费事件
          } : this.isRenaming ? undefined : () => {
          })
          .zIndex(11 - this.mFolderMgr.getIndexInFolder(item, this.mFolderMgr.getOpenedFolder()))
          .onDisAppear(() => {
            if (this.isNeedRevert && this.mAppInfo.length === 0) {
              this.revertItem(item);
            }
          })
        }, (item: GridLayoutItemInfo) => this.itemKeyGenerator(item))

        if (this.isSmallFolder && this.mFolderModel.getFolderLayoutInOpen() ===
        FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4) {
          ForEach(this.placeHolders, (item: GridLayoutItemInfo, index: number) => {
            GridItem() {
              this.FolderOpenPlaceHolderBuilder(index + this.mAppInfo.length, item);
            }
          }, (item: GridLayoutItemInfo) => JSON.stringify(item))
        }
      }
      .id(this.openFolderGridId)
      .clip(false)
      .onAppear(() => {
        // 打开文件夹时仅第一页图标展示动效
        if (this.pageIndex == 0) {
          log.showInfo('swiperPage onAppear');
          let rect = ItemUtils.getRectById('openFolderGrid_0');
          if (rect.left > 0) {
            this.openFolderRect = rect;
          }
          openCloseAniMgr.onOpenFolderGridShow(GridLayoutUtil.isSmallFolder(this.mFolderMgr.getOpenedFolder()));
        }
      })
      .onDisAppear(() => {
        if (this.isNeedRevert && this.mAppInfo.length === 0) {
          this.revertAddIcon();
        }
      })
      .margin({
        top: this.openFolderStyle.openFolderIconTopMargin,
        bottom: this.openFolderStyle.openFolderIconBottomMargin
      })
      .width(this.openFolderStyle.openGridWidth)
      .padding({
        top: this.openFolderStyle.gridVerticalPadding,
        bottom: this.openFolderStyle.gridVerticalPadding,
        left: this.openFolderStyle.gridHorizontalPadding,
        right: this.openFolderStyle.gridHorizontalPadding
      })
      .columnsGap(this.openFolderStyle.columnGap)
      .rowsGap(this.openFolderStyle.rowGap)
      .columnsTemplate(this.columnsTemplate)
      .rowsTemplate(this.rowsTemplate)
      .onDragMove((event: DragEvent) => {
        if (!this.isDrag) {
          log.showInfo('not drag SCBDesktop component, onDragMove move return');
          return;
        }
        if (layoutLockUtil.isLockedPage(this.pageIndexInDesktop) ||
          (this.isInDock && layoutLockUtil.isLocked())) {
          return;
        }
        if (this.isDragLeave) {
          log.showInfo('onDragMove return because isDragLeave is true');
          return;
        }
        let dragItemType: number = AppStorage.get<number>('dragItemType') as number
        if (dragItemType === CommonConstants.DRAG_FROM_FOLDER || dragItemType ===
        CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
          const rectangle: Rectangle = event.getPreviewRect();
          const dropX: number = Number(rectangle.x) + Number(rectangle.width) / 2;
          const dropY: number = Number(rectangle.y) + Number(rectangle.height) / 2;
          log.showDebug('onDragMove DRAG_FROM_FOLDER: [%{public}d, %{public}d] pageIndex: %{public}d',
            dropX, dropY, this.pageIndex);
          this.onMove(dropX, dropY);
        }
      })
      .onDragEnter((event?: DragEvent, extraParams?: string) => {
        if (!this.isDrag) {
          log.showInfo('not drag SCBDesktop component, onDragEnter return');
          return;
        }
        // 拖出文件夹再拖回，识别到文件夹已关闭时则无需再次走入
        const isFolderOpen: boolean = this.mFolderMgr.isFolderOpen();
        if (!isFolderOpen) {
          log.showWarn('already closed when drag leave, need not to drag Enter');
          return;
        }
        log.showInfo('OpenFolderSwiperPage onDragEnter extraParams: %{public}s, event: [%{public}d, %{public}d]',
          extraParams, event?.getX(), event?.getY());
        if (isFolderOpen) {
          dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
          this.isDragLeave = false;
          clearTimeout(this.dragLeaveFolderSetTimeoutId);
          this.dragKeyName = '';
        }
      })
      .onDragLeave((event?: DragEvent, extraParams?: string) => {
        if (!this.isDrag) {
          log.showInfo('not drag SCBDesktop component, onDragLeave return');
          return;
        }
        const msg: string = 'dragLeave on folderGridSwiper';
        if (layoutLockUtil.isLockedPage(this.pageIndexInDesktop, msg) ||
          (this.isInDock && layoutLockUtil.isLocked(msg))) {
          return;
        }
        // onDragLeave适配多选拖拽场景，当文件夹内多选应用聚合关闭文件夹慢时，拖拽多选应用会触发leave方法
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let dragObj = AppStorage.get<Object>('dragItemInfo');
        let dragItems: GridLayoutItemInfo[] = [];
        if (Array.isArray(dragObj)) {
          if (dragObj.length === 0) {
            log.showError('drop with empty drag array');
          }
          dragItems = dragObj as GridLayoutItemInfo[];
        } else {
          dragItemInfo = dragObj as GridLayoutItemInfo;
        }

        // 多选模式下，可拖拽的定制应用才可以勾选，拖拽多选应用离开文件夹时不再做拦截
        let isDragLeaveDisabled: boolean = false;
        let waitForHarmony: boolean =
          dragItemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY && dragItemInfo.typeId === CommonConstants.TYPE_APP;
        if (isDragLeaveDisabled || (NotHarmonyUtil.isNotHarmonyFolderById(this.folderId) && waitForHarmony)) {
          // 图标拖出非OpenHarmony化文件夹打点
          const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
          FolderReporter.getInstance().reportDragIconFromNotHarmonyFolder(dragItemInfo.bundleName, openFolderData);
          OpenFolderDragHandler.getInstance().resetTranslateZero('onDragLeave cancel for NotHarmony');
          return;
        }
        if (this.isChangingPage) {
          log.showInfo('onDragLeave return for isChangingPage');
          OpenFolderDragHandler.getInstance().resetTranslateZero('onDragLeave return for isChangingPage');
          return;
        }
        if (this.isSwitchingPage) {
          log.showInfo('onDragLeave return for isSwitchingPage');
          OpenFolderDragHandler.getInstance().resetTranslateZero('onDragLeave return for isSwitchingPage');
          return;
        }
        this.verifyBeforeDragLeave(event);
      })
      .onDrop((event?: DragEvent, extraParams?: string) => {
        if (!event) {
          return;
        }
        if (!this.isDrag) {
          log.showInfo('not drag SCBDesktop component, onDrop return');
          return;
        }
        AppStorage.setOrCreate('dragFolderApp', false);
        performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
        TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        log.showInfo('onDrop event: [%{public}d, %{public}d]', event.getX(), event.getY());
        event.useCustomDropAnimation = true;
        if (!AppStorage.get<boolean>('isDrag')) {
          log.showInfo('not dragging desktop component');
          event.setResult(DragResult.DRAG_FAILED);
          return;
        }
        const msg: string = 'drop on folderGridSwiper';
        if (layoutLockUtil.isLockedPage(this.pageIndexInDesktop, msg) ||
          (this.isInDock && layoutLockUtil.isLocked(msg))) {
          OpenFolderDragHandler.getInstance().animationToOriginalPos(event, this.dragItemType);
          return;
        }
        if (!this.mFolderMgr.isCanOpenFolderDragDrop() && FolderCommonUtil.isInGridSwiperArea(event?.getY())) {
          log.showInfo('send openFolder onDrop event to desktop 3');
          this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_DRAG_LEAVE_FROM_SMALL_FOLDER_ADVANCE,
            event, extraParams);
          return;
        }
        let dragResult: boolean = false;
        dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
        this.mFolderViewModel.dropInFolderOpenComponent();
        if (this.dragItemType === CommonConstants.DRAG_FROM_FOLDER || this.dragItemType ===
        CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
          log.showInfo('onDrop OpenFolderSwiperPage isGeometryTransiting:%{public}s', this.isGeometryTransiting);
          if (!this.isGeometryTransiting) {
            dragResult = this.onDragDrop(event);
          }
          if (!dragResult) {
            this.dragFolderResult()
          }
        }
        if (this.dropOnDesktop) {
          this.dropOnDesktop(event);
        }
      })
    }
    .width(FolderStyleConstants.PERCENTAGE_100)
    .height(FolderStyleConstants.PERCENTAGE_100)
  }

  private dragFolderResult(): void {
    ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(() => {
      log.showInfo('onDrop OpenFolderSwiperPage waitFolderAnimateFinish');
      this.sendDropStartEvent();
      const dragItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
      this.sendDropAnimationEndEvent(GridLayoutUtil.generateUniqueKey(dragItemInfo));
      AppStorage.setOrCreate('selectAppIndex', null);
      AppStorage.setOrCreate('isDrag', false);
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', new GridLayoutItemInfo());
    });
  }
}
