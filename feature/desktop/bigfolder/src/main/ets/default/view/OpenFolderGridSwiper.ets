/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  CommonConstants,
  StyleConstants,
  FolderModel,
  EditModeUtils,
  DeliverUtil,
  NotHarmonyUtil,
  EditModeState,
  editModeManager,
  desktopFontScaleManager,
  DesktopFontScaleState,
  FolderState,
  OpenFolderStyle,
  OpenFolderStyleConfig,
  EditModeViewData,
  FolderConstants,
  FolderDragData,
  FolderAnimateEventManager,
  layoutLockUtil,
  EditModeViewState,
  lockedAppUninstallModel,
  DesktopManager,
  lockLayoutManager,
  FolderLifeCyclePriority,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderManager,
  FolderDataListener,
  FolderCommonUtil,
  BigFolderStyleConfig,
  FolderOperationFlag,
  SwiperPageType,
  FolderStyleConstants,
} from '@ohos/launchercommon';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  AnimateToScheduleUtils,
  CommonUtils,
  RectInfo,
  TraceUtil,
  DomainName,
  AppStorageUtil,
  ArrayUtils
} from '@ohos/basicutils';
import {
  GlobalContext,
  SCBDesktopCacheManager,
  ResourceManager,
  DeviceHelper,
  AccessibilityManager,
  HiSysEventUtil,
  localEventManager,
} from '@ohos/frameworkwrapper';
import {
  SCBTransitionController,
  SCBTransitionManager,
  SCBDesktopEventId,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import {
  RTLUtil,
  RectangularCoordinates,
  SCBVisualEffectMgr,
} from '@ohos/componenthelper';
import { NumberConstants } from '@ohos/commonconstants';
import { DropAnimationCancelReason, DropAnimationDestination } from '@ohos/componentanimator';
import { BigFolderViewModel, FolderCloseType } from '../viewmodel/BigFolderViewModel';
import OpenFolderDragHandler from '../common/OpenFolderDragHandler';
import FeatureConstants from '../common/constants/FeatureConstants';
import curves from '@ohos.curves';
import { EventConstants } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { GridLayoutUtil } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { DeviceState } from '@ohos/launchercommon';
import {
  AppBubbleParams,
  FocusUtil,
  launcherVisualEffectMgr,
  ContractedFolderCommonViewModel,
  FolderStyleManager,
  SwiperPageManager,
  IDesktopDragHandler,
  DragProxyManager,
  DragHandlerType
} from '@ohos/launchercommon/Index';
import { OpenFolderSwiperPage } from './OpenFolderSwiperPage'
import { FolderDataModelManager } from '@ohos/launchercommon'
import { FolderAccessibilityUtils } from '../common/FolderAccessibilityUtils';
import { PageType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { Prompt } from '@kit.ArkUI';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import FolderAddDialogConstant from '../common/constants/FolderAddDialogConstant';
import { openFolderLayout } from '../viewmodel/OpenFolderLayout';
import { OpenFolderGridSwiperLayout } from '../viewmodel/OpenFolderGridSwiperLayout';
import {
  OpenFolderIconParamsManager
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderIconParamsManager';
import { StateEx } from '@ohos/componenthelper';
import { openCloseAniMgr } from '../viewmodel/openclose/OpenCloseActionManager';
import { openFolderVm } from '../viewmodel/OpenFolderViewModel';
import { OpenCloseAnimationUtil } from '../viewmodel/openclose/OpenCloseAnimationUtil';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import { OpenFolderHiddenIcon } from './OpenFolderHiddenIcon';
import {
  openFolderHiddenIconLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderHiddenIconLayout';
import { ExposureManager } from '@ohos/launchercommon/src/main/ets/manager/ExposureManager';
import { DragViewModel } from '../viewmodel/drag/DragViewModel';
import { OpenFolderAppBubbleNodeManager } from './node/OpenFolderAppBubbleNodeManager';

const TAG = 'OpenFolderGridSwiper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const BLENDMODE_SRC_OVER: number = 1000;
const BLENDMODE_DESTINATION_IN: number = 6;
const DISTANCE_FOLD_OPEN_SWIPER = 5;
const FOLDER_NAME_TEXT_ID: string = `${TAG}_text_folderName`;
//文件夹复用入口屏蔽@Reusable
@Component
export struct OpenFolderGridSwiper {
  @StorageProp('themeStyle') themeStyle: string = '';
  @StorageLink('openFolderStatus') status: number = AppStorage.get<number>('openFolderStatus') as number;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_DESKTOP;
  @StorageLink('isAddIconHidden') @Watch('updateAddIconWhenDrag') isAddIconHidden: boolean = false;
  @StorageLink('isPad') isPad: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State mFolderInfoData: Array<GridLayoutItemInfo[]> = [];
  @State lastHideIcons: GridLayoutItemInfo[] = [];
  @State lastShowIcons: GridLayoutItemInfo[] = [];
  @State lastHideFirstPageIcons: GridLayoutItemInfo[] = [];
  @State backgroundGeometryId: string = '';
  @State mFolderIconRadius: number = 0;
  @State mFolderRadius: number = 0;
  private mIsReusing: boolean = true;
  @Link swiperSelectedColor: string;
  @Link swiperColor: string
  @Link pageIndex: number;
  @Link isRenaming: boolean
  @Link newFolderName: string
  @Link folderNameColor: string;
  @Link cancelAppImage: string;
  @State isShowIndicator: boolean = false;
  private textInputKey?: string;
  private setFocusManual: Function = (): void => {
  };
  @State animateScale: number = 1.0;
  private swiperController: SwiperController | null = new SwiperController();
  private textInputController: TextInputController = new TextInputController();
  private lastSwipeOffset: number = 0;
  private lastSwipeOffsetChanged: number = 0;
  @Link isGeometryTransiting: boolean;
  @Link isDragOutFolderPendingClose: boolean;
  @Link folderNameAppearDuration: number;
  @Link folderNameDisappearDuration: number;
  @StorageLink('isDragLeave') isDragLeave: boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  saveText?: Function;
  @Consume('openSmallFolderBackgroundFlag') openSmallFolderBackgroundFlag: boolean;
  @State appItemWidth: number = FolderStyleConstants.DEFAULT_APP_ITEM_WIDTH;
  @State appNameSize: number = FolderStyleConstants.DEFAULT_APP_NAME_SIZE;
  @State gridHeight: number = 0;
  @State gridPadding: number = 0;
  @State columnsTemplate: string = '';
  @State rowsTemplate: string = '';
  @State gridGap: number = 0;
  @State swiperItemSpace: number = 0;
  @State gridRowGap: number = 0;
  @State tittleMargin: number = 0;
  @State isChangingPage: boolean = false;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @Link isSwiperClipForce: boolean;
  @StorageLink('dragItemInfo') folderDragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageLink('isDrag') isDrag: boolean = false;
  @State forbidFolderOpenSwiper: boolean = false;
  @State isSwitchingPage: boolean = false;
  @State switchToPageIndex: number = 0;
  // 切换页面热区宽度
  private switchPageRegionWidth: number = this.appItemWidth / NumberConstants.CONSTANT_NUMBER_TWO;
  // 切换页面热区保持时长
  private switchPageHoverTime: number = 500;
  private lastInSwitchRegionTime: number = CommonConstants.INVALID_VALUE;
  private folderOpenComponentContainerKey: string = 'folderOpenComponentContainer';
  @State openFolderRect: RectInfo = new RectInfo();
  @State folderGridWith: number = 0;
  @State folderHorizontalPending: number = 0;
  private mFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private mBigFolderStyleConfig: BigFolderStyleConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
  private folderPageLength: number = 0;
  @State hideOpacity: number = 0;
  @State isShowCorner: boolean = false;
  @State editModeViewData: EditModeViewData = editModeManager.getEditModeViewData();
  private mFolderMgr: FolderManager = FolderManager.getInstance();
  private folderId = this.mFolderMgr.getOpenedFolder().folderId ?? '';
  @State folderName: string = this.mFolderMgr.getOpenedFolder().folderName ?? '';
  private folderAppBubbleNodeManager: OpenFolderAppBubbleNodeManager = OpenFolderAppBubbleNodeManager.getInstance();
  @State gridSwiperLayout: OpenFolderGridSwiperLayout = openFolderLayout.getGridSwiperLayout();
  /**
   * 长辈模式字体
   */
  @State fontScaleState: DesktopFontScaleState = desktopFontScaleManager.getSysFontScaleState();
  @State isFolderOpened: boolean = false;
  @State isShowBg: boolean = true;
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @State folderOpacity: StateEx<number> = launcherVisualEffectMgr.getOpenFolderOpacity();
  @State isClosing: boolean = false;
  private folderStatusChangeInFolderOpen: Function = () => {
    this.updateConfig();
  };
  private pageIndexInDesktop: number = 0;
  private isInDock: boolean = false;
  private isSmallFolder = false;
  private targetPageIndex: number = 0;
  private openFolderStyle: OpenFolderStyle = OpenFolderStyleConfig.getInstance().getOpenFolderStyle();
  private lastHideFirstPageLength: number = 0;
  private lastHidePerPage: number = 0;
  private folderSwiperCallBack: Function = (showPageIndex: number): void => {
    this.folderSwiperCallBackEvent(showPageIndex);
  }
  private singleHandChange: () => void = () => this.folderStatusChange();

  private folderStatusChange(): void {
    this.updateConfig();
  }

  private updateStyle(): void {
    this.isPad = CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
    if (!this.mBigFolderStyleConfig) {
      this.mBigFolderStyleConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
    }
    this.appItemWidth = this.mBigFolderStyleConfig.mOpenFolderAppSize;
    this.appNameSize = this.mBigFolderStyleConfig.mOpenFolderAppNameSize;
    this.gridHeight = this.mBigFolderStyleConfig.mOpenFolderGridHeight;
    this.gridPadding = this.mBigFolderStyleConfig.mOpenFolderGridPadding;
    this.gridGap = this.mBigFolderStyleConfig.mOpenFolderGridGap;
    this.swiperItemSpace = this.mBigFolderStyleConfig.mOpenFolderSwiperItemSpace;
    this.gridRowGap = this.mBigFolderStyleConfig.mOpenFolderGridRowGap;
    this.tittleMargin = this.mBigFolderStyleConfig.mOpenFolderTittleMargin;
    this.mFolderIconRadius = this.mBigFolderStyleConfig.mFolderIconRadius;

    this.mFolderRadius = this.mBigFolderStyleConfig.mFolderRadius;

    this.folderHorizontalPending = this.mBigFolderStyleConfig.folderHorizontalPending;
    this.folderGridWith = this.mBigFolderStyleConfig.mOpenFolderGridWidth +
      this.folderHorizontalPending * NumberConstants.CONSTANT_NUMBER_TWO;
  }

  private updateConfig() {
    let column: number = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let row: number = FolderModel.getInstance().getFolderOpenLayout()?.row;
    log.showInfo(`updateConfig column:${column} row:${row}`);
    this.columnsTemplate = '';
    this.rowsTemplate = '';
    for (let i = 0; i < column; i++) {
      this.columnsTemplate += '1fr '
    }
    for (let i = 0; i < row; i++) {
      this.rowsTemplate += '1fr '
    }
  }

  private registerFolderDropAnimateWaitCallBack() {
    const dropAniCall: () => void = (): void => openFolderVm.runFolderDropAnimateWaitCallBack();
    this.desktopContext?.eventHub.on(FolderAnimateEventManager.getInstance()
      .getWaitForDropAnimateRefreshEvent(this.folderId), dropAniCall);
  }

  private unRegisterFolderDropAnimateWaitCallBack() {
    this.desktopContext?.eventHub.off(FolderAnimateEventManager.getInstance()
      .getWaitForDropAnimateRefreshEvent(this.folderId));
  }

  private initHiddenIcons(): void {
    const animateCount: number = OpenCloseAnimationUtil.getOpenFolderAppAnimateCount();
    let pageShowLength: number = GridLayoutUtil.getCountPerPageFolderOpen();
    if (animateCount > pageShowLength) {
      this.lastHideIcons = this.mFolderInfoData.flat().slice(pageShowLength, animateCount);
      log.showInfo('lastHideIcons size: ' + this.lastHideIcons.length);
      this.onCurrentPageAppListChange();
    }
  }

  private updateOpenFolderAppBubbleParams(
    paramsUpdater: (itemParams: AppBubbleParams, itemInfo: GridLayoutItemInfo) => boolean
  ): void {
    this.lastHideIcons.forEach((item: GridLayoutItemInfo) => {
      if (!item) {
        return;
      }
      let params: AppBubbleParams = this.folderAppBubbleNodeManager.getNodeParams(item.keyName || '');
      let needUpdate: boolean = paramsUpdater(params, item);
      if (needUpdate) {
        this.folderAppBubbleNodeManager.updateNodeParams(item.keyName || '', params, 'updateNode in gridSwiper');
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
      itemParams.common = OpenFolderAppBubbleNodeManager.getInstance().getAppBubbleCommonParams();
      itemParams.item = itemInfo;
      itemParams.index = this.mFolderMgr.getIndexInFolder(itemInfo, openFolder);
      itemParams.pageIndex = this.mFolderMgr.getPageIndexInFolder(itemInfo, openFolder);
      const newParamsStr: string = JSON.stringify(itemParams);
      return newParamsStr !== originParamsStr;
    });
  }

  private mOpenFolderChangeListener: FolderDataListener = {
    description: 'openFolderData change to refresh OpenFolderGridSwiper',
    priority: FolderLifeCyclePriority.NORMAL,
    updateOpenFolder: (updateFolder: GridLayoutItemInfo) => {
      if (updateFolder) {
        this.refreshItem(updateFolder);
      }
    },
    updateFolder: (folderId: string, folderItems: GridLayoutItemInfo[]) => {
      this.onUpdateFolder(folderId, folderItems);
    },
    updateFolderName: (folderId: string) => {
      const folderItem: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
      if (folderItem == undefined || CheckEmptyUtils.isEmpty(folderItem.folderName) ||
        folderItem.folderName == this.folderName) {
        return;
      }
      this.folderName = folderItem.folderName as string;
    },
    removeFolder: (folder: GridLayoutItemInfo) => {
      if (this.mFolderMgr.isFolderOpen() && this.mFolderMgr.getOpenFolderId() === folder.folderId) {
        ContractedFolderCommonViewModel.getInstance().closeFolder('remove folder to release',
          FolderOperationFlag.IMMEDIATELY);
      }
    }
  };

  private refreshItem(updateFolder: GridLayoutItemInfo): void {
    // 通知展开态缓存节点更新
    log.showInfo('refreshCallback folderName:%{public}s itemsCount:%{public}d',
      updateFolder.folderName, updateFolder.layoutInfo?.flat().length);
    this.updateOpenFolderLayout(updateFolder);
    this.isShowIndicator = this.hasMoreThanOnePage();
    if (!CheckEmptyUtils.isEmpty(updateFolder.folderName) && updateFolder.folderName !== this.folderName) {
      this.folderName = updateFolder.folderName || '';
    }
  }

  private mOpenFolderCallBack: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      this.isFolderOpened = true;
      this.forbidFolderOpenSwiper = false;
      this.lastHideIcons = [];
      this.isSwiperClipForce = true;
      FolderDataModelManager.getInstance().onFolderPageChange(this.folderId, 0);
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      this.onClosingFolder(folder);
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('closed Folder');
      this.isSwiperClipForce = false;
      this.isFolderOpened = false;
      this.isClosing = false;
      DragViewModel.getInstance().setDragLeaveItemHasDeal(true);
      OpenFolderDragHandler.getInstance().resetTranslateZero('folder closed');

      // 避免关闭文件夹动效被打断时的动效残留，需在closed状态进行布局清空
      this.lastHideIcons = [];
      this.isShowBg = false;
      this.mFolderInfoData = [];
      FolderDataModelManager.getInstance().setSwiperController(undefined);
      OpenFolderIconParamsManager.getInstance().clearPressEffect();
      this.desktopContext?.eventHub.off(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT);
    }
  }

  private onUpdateFolder(folderId: string, folderItems: GridLayoutItemInfo[]): void {
    if (this.mFolderMgr.getOpenFolderId() !== folderId) {
      return;
    }
    if (FolderCommonUtil.isNeedReleased(folderItems, folderId)) {
      ContractedFolderCommonViewModel.getInstance().closeFolder('update folder to release',
        FolderOperationFlag.IMMEDIATELY);
      return;
    }
    this.refreshItem(this.mFolderMgr.getFolder(folderId).getGridInfo());
  }

  private onClosingFolder(folder: GridLayoutItemInfo): void {
    this.isFolderOpened = false;
    this.isShowIndicator = false;
    this.isClosing = true;
    this.isSwiperClipForce = false;
    ContextMenu.close();
    log.showInfo(`closingFolderCallback folderId:${folder.folderId}`);
    FolderDataModelManager.getInstance().setSwiperController(undefined);
    this.togglePageIndexOnCloseFolder();
    if (this.isSmallFolder || this.pageIndex === 0) {
      this.initClosingHiddenIcons();
    } else {
      this.initClosingHiddenIconsEx();
    }
    if (this.pageIndex === 0 && this.mFolderInfoData.length > 1) {
      // 首页关闭, 只保留首页数据, 其他页立即消失
      this.mFolderInfoData = [this.mFolderInfoData[0]];
    }
    OpenFolderIconParamsManager.getInstance().clearPressEffect();
    lockedAppUninstallModel.resetUninstallData();
  }

  private initClosingHiddenIcons(): void {
    // 如果当前关闭的文件夹是4x2文件夹，需要将节点缓存添加入动效控件中，保证关闭动效正常
    const animateCount: number = OpenCloseAnimationUtil.getOpenFolderAppAnimateCount();
    const pageShowLength: number = GridLayoutUtil.getCountPerPageFolderOpen();
    if (animateCount > pageShowLength) {
      this.lastHideIcons = this.mFolderInfoData.flat().slice(pageShowLength, animateCount);
      this.lastHideIcons.forEach(item => {
        if (!CheckEmptyUtils.isEmpty(item)) {
          this.hubBadgeChangeEvent(item);
        }
      });
      this.onCurrentPageAppListChange();
      log.showInfo('closingFolder lastHideIcons size: %{public}d', this.lastHideIcons.length);
    }
  }

  private initClosingHiddenIconsEx(): void {
    if (this.pageIndex !== 0) {
      this.lastShowIcons = this.pageIndex < this.mFolderInfoData.length ? this.mFolderInfoData[this.pageIndex] : [];
      const animateCount: number = OpenCloseAnimationUtil.getOpenFolderAppAnimateCount();
      const area = this.mFolderMgr.getOpenedFolder().area;
      this.lastHidePerPage = GridLayoutUtil.getCountPerPageInFolder(area ?? [2, 2]);
      // 隐藏图标数量取折叠态图标数量和参与动效数量的较小值
      this.lastHideFirstPageLength = Math.min(animateCount, this.lastHidePerPage + 2);
      this.lastHideFirstPageIcons = this.mFolderInfoData.flat().slice(0, animateCount);
      log.showInfo(`initClosingHiddenIconsEx pageIndex:${this.pageIndex},animateCount:${animateCount},` +
        `lastHidePerPage:${this.lastHidePerPage},lastHideFirstPageLength:${this.lastHideFirstPageLength}`);
    }
  }

  // 编辑文件夹名称状态下, 通过控制中心进入文件夹，需要保存名字并关闭键盘
  private handlerEnterSettingOnControlCenter = (isHideEvent: boolean) => {
    if (!isHideEvent) {
      this.closeFolderRenameKeyboard();
      this.desktopContext?.eventHub.off(CommonConstants.HIDE_DESKTOP_EVENT, this.handlerEnterSettingOnControlCenter);
    }
  }

  hasMoreThanOnePage(): boolean {
    if (this.mFolderInfoData.flat().length <= GridLayoutUtil.getCountPerPageFolderOpen()) {
      return false;
    } else {
      return true;
    }
  }

  private folderSwiperCallBackEvent(showPageIndex: number): void {
    this.swiperController?.finishAnimation();
    log.showInfo(`showPageIndexChange is:${showPageIndex}, PageIndex is:${this.pageIndex}`);
    if (showPageIndex !== this.pageIndex) {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      this.swiperController?.changeIndex(showPageIndex, true);
      log.showInfo('folder changeIndex to showPageIndex');
    }
  }

  aboutToAppear() {
    log.showInfo('OpenFolderGridSwiper aboutToAppear');
    AppStorageUtil.setOrCreate<boolean>('ignoreUseGetById', false);
    DesktopManager.getInstance().registerScreenChangeListener(this.singleHandChange);
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    this.pageIndex = this.mFolderMgr.getPageIndex();
    this.folderName = openFolderData.folderName || '';
    this.folderId = this.mFolderMgr.getOpenFolderId();
    if (ArrayUtils.equalsArr(openFolderData.area, [4, 2])) {
      // 打开4x2文件夹时会使用第二页图标参与动效，动效过程中翻至第二页会导致第二页参与动效的图标显示异常，所以打开4x2文件夹时禁止翻页
      this.forbidFolderOpenSwiper = true;
    }
    this.pageIndexInDesktop = openFolderData.page ?? CommonConstants.INVALID_VALUE;
    this.isInDock = openFolderData.isInDock ?? false;
    this.isSmallFolder = GridLayoutUtil.isSmallFolder(openFolderData);
    // 更新当前打开文件夹节点缓存nodeKeys，用于比对哪些节点不在文件夹里了需要删除
    this.folderAppBubbleNodeManager.updateNodeKeysInOpenFolder(openFolderData.folderId as string,
      (openFolderData.layoutInfo || []).flat().map((item: GridLayoutItemInfo) => item?.keyName || ''));
    this.updateConfig();
    this.updateStyle();
    this.mFolderInfoData = openFolderData.layoutInfo ?? [];
    this.initHiddenIcons();
    this.folderPageLength = openFolderData.layoutInfo?.length ?? 1;
    this.mFolderViewModel.registerFolderStatusChangeListener(this.folderStatusChangeInFolderOpen);
    SCBTransitionManager.getInstance().registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME,
      this.doFollowAnimate);
    SCBTransitionManager.getInstance().registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME,
      this.doBackHomeAnimate);
    SCBTransitionManager.getInstance().registerGlobalTransitionController(this.scbTransitionController);
    this.registerFolderDropAnimateWaitCallBack();
    this.registerAddDialogCallback();
    this.isDragLeave = false;
    FolderDataModelManager.getInstance().setSwiperController(this.swiperController);
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenFolderCallBack);
    this.mFolderMgr.registerDataLifeListener(this.mOpenFolderChangeListener);
    this.gridSwiperLayout.isInterceptEvent = true;
    SwiperPageManager.getInstance().registerSwiperPageCallback(SwiperPageType.FOLDER_SWIPER, this.folderSwiperCallBack);
    ExposureManager.getInstance().handleFolderExposureTimeStart(this.pageIndex);
  }

  aboutToDisappear() {
    log.showInfo('OpenFolderGridSwiper aboutToDisappear');
    DesktopManager.getInstance().unregisterScreenChangeListener(this.singleHandChange);
    this.mFolderViewModel.unregisterFolderStatusChangeListener(this.folderStatusChangeInFolderOpen);
    SCBTransitionManager.getInstance().unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME,
      this.doFollowAnimate);
    SCBTransitionManager.getInstance().unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME,
      this.doBackHomeAnimate);
    SCBTransitionManager.getInstance().unRegisterGlobalTransitionController(this.scbTransitionController);
    this.freeResource();
    this.unRegisterFolderDropAnimateWaitCallBack();
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'OpenFolderGridSwiper', false, expandStatus);
    SwiperPageManager.getInstance().unRegisterSwiperPageCallback(SwiperPageType.FOLDER_SWIPER,
      this.folderSwiperCallBack);
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenFolderCallBack);
    this.mFolderMgr.unregisterDataLifeListener(this.mOpenFolderChangeListener);
    this.unregisterAddDialogCallback();
    this.desktopContext?.eventHub.off(CommonConstants.HIDE_DESKTOP_EVENT, this.handlerEnterSettingOnControlCenter);
    ExposureManager.getInstance().handleFolderExposureTimeEnd(this.pageIndex);
    this.lastHideFirstPageIcons = [];
    this.lastShowIcons = [];
    this.lastHidePerPage = 0;
    this.lastHideFirstPageLength = 0;
    this.mFolderInfoData = [];
  }

  private scbTransitionController: SCBTransitionController = {
    appData: {
      bundleName: '',
      abilityName: '',
      appIconId: `${TAG}Global`,
      appIconNumber: 0,
      iconRadius: 0
    },
    onActive: (): void => this.onActive(),
    onInactive: (): void => this.onInactive()
  };
  private doFollowAnimate: Function = (scale: number): void => {
    log.showInfo('doFollowAnimate, animateScale from %{public}d to %{public}d', this.animateScale, scale);
    animateTo({
      curve: curves.springMotion(0.15, 0.86, 0.25)
    }, () => {
      this.animateScale = scale;
    })
  }
  private doBackHomeAnimate: Function = (scale: number): void => {
    setTimeout(() => {
      animateTo({
        curve: curves.springMotion(0.55, 0.99, 0.25)
      }, () => {
        this.animateScale = scale;
      })
    });
  }

  private onActive() {
    if (this.status == FeatureConstants.OPEN_FOLDER_STATUS_OPEN) {
      log.showInfo('onActive');
      try {
        animateTo({
          curve: curves.springMotion(0.3, 1.157, 0)
        }, () => {
          this.animateScale = 0.9;
        })
      } catch (error) {
        log.error('curves error', error);
      }
    }
  }

  private onInactive() {
    if (this.status == FeatureConstants.OPEN_FOLDER_STATUS_OPEN) {
      log.showInfo('onInactive');
      if (CommonUtils.equals(this.animateScale, 1.0)) {
        return;
      }
      try {
        animateTo({
          curve: curves.springMotion(0.55, 1, 0)
        }, () => {
          this.animateScale = 1.0;
        })
      } catch (error) {
        log.error('curves error', error);
      }
    }
  }

  freeResource(): void {
    this.swiperController = null;
  }

  updateOpenFolderLayout(folder: GridLayoutItemInfo): void {
    if (!GridLayoutUtil.isFolderItemValid(folder)) {
      return;
    }
    const appsLen: number = FolderCommonUtil.getFilterAppListInFolder(folder).length;;
    if (!DeliverUtil.checkFolderIsReleased(folder?.folderId, appsLen)) {
      DeliverUtil.addAddIcon(folder, 'OpenFolderGridSwiper update');
    } else {
      DeliverUtil.delAddIcon(folder, 'OpenFolderGridSwiper releaseFolder');
    }
    this.mFolderInfoData = folder.layoutInfo ?? [];
    log.showDebug('updateOpenFolderLayout folderId:%{public}s folderName:%{public}s',
      folder?.folderId, folder?.folderName);
  }

  updateAddIconWhenDrag(): void {
    // 展开态落位事件透传给桌面时，文件夹已关闭，无需添加add图标
    if (!this.mFolderMgr.isCanOpenFolderDragDrop()) {
      log.showInfo('no need to update when send drop to desktop');
      return;
    }
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let msg: string = '';
    if (this.isAddIconHidden) {
      DeliverUtil.delAddIcon(openFolderData, 'updateAddIconWhenDrag');
      msg = 'updateAddIconWhenDrag to delete addIcon';
    } else {
      DeliverUtil.addAddIcon(openFolderData, 'updateAddIconWhenDrag');
      msg = 'updateAddIconWhenDrag to add addIcon';
    }
    this.mFolderInfoData = openFolderData.layoutInfo ?? [];
  }

  private updateFolderCloseAppAnimate(swipeOffset: number): void {
    let controller = SCBTransitionManager.getInstance().getCurrentTransitionController();
    if (controller?.updateAnimSwipe) {
      const offsetChanged = swipeOffset - this.lastSwipeOffset;
      if (offsetChanged === 0) {
        log.showDebug('Folder updateFolderCloseAppAnimate offset not changed');
        return;
      }
      if (this.lastSwipeOffsetChanged !== 0 && offsetChanged < 0 !== this.lastSwipeOffsetChanged < 0) {
        // swipe direction changed
        log.showInfo('Folder direction changed.%{public}d, %{public}d, %{public}s', swipeOffset,
          this.lastSwipeOffset, this.lastSwipeOffsetChanged);
        SCBTransitionManager.getInstance().cancelCloseAppAnimate();
        return;
      }
      this.lastSwipeOffset = swipeOffset;
      this.lastSwipeOffsetChanged = offsetChanged;
      controller.updateAnimSwipe(swipeOffset);
    }
  }

  private registerAddDialogCallback(): void {
    this.desktopContext?.eventHub.on(FolderAddDialogConstant.EVENT_FOLDER_REFRESH_DIALOG,
      (folderInfoData: GridLayoutItemInfo[][]) => {
        this.mFolderInfoData = folderInfoData;
      });
  }

  private unregisterAddDialogCallback(): void {
    this.desktopContext?.eventHub.off(FolderAddDialogConstant.EVENT_FOLDER_REFRESH_DIALOG);
  }

  private switchFolderPage(x: number, y: number, nowTime: number, pageIndex: number): boolean {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (!this.openFolderRect || this.openFolderRect.left < 0 || !openFolderData || !openFolderData.layoutInfo) {
      log.error('switchFolderPage openFolderRect info error')
      return false;
    }
    if (this.isDragLeave || openFolderData.layoutInfo?.length <= NumberConstants.CONSTANT_NUMBER_ONE) {
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
      return false;
    }
    let gridStart: RectangularCoordinates.Point = EditModeUtils.convertOpenFolderCoordinateToEditMode({
      x: this.openFolderRect.left,
      y: this.openFolderRect.top,
    });
    let gridEnd: RectangularCoordinates.Point = EditModeUtils.convertOpenFolderCoordinateToEditMode({
      x: this.openFolderRect.right,
      y: this.openFolderRect.bottom,
    });
    let gap: number = this.switchPageRegionWidth * EditModeUtils.getDesktopScale();
    if (x < gridStart.x || x > gridEnd.x || y < gridStart.y || y > gridEnd.y) {
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
      return false;
    }
    if (x <= gridEnd.x - gap && x >= gridStart.x + gap) {
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
      return false;
    }
    if (x > gridEnd.x - gap) {
      RTLUtil.isRTL() ? this.switchPrevious(nowTime, pageIndex) : this.switchNext(nowTime, pageIndex);
      return true;
    }
    if (x < gridStart.x + gap) {
      RTLUtil.isRTL() ? this.switchNext(nowTime, pageIndex) : this.switchPrevious(nowTime, pageIndex);
    }
    return true;
  }

  private switchNext(nowTime: number, pageIndex: number): void {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (!openFolderData?.layoutInfo) {
      log.showError('folderInfo error');
      return;
    }
    if (pageIndex >= openFolderData.layoutInfo.length - NumberConstants.CONSTANT_NUMBER_ONE) {
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
      return;
    }
    if (this.lastInSwitchRegionTime === CommonConstants.INVALID_VALUE) {
      this.lastInSwitchRegionTime = nowTime;
      return;
    }

    if (nowTime - this.lastInSwitchRegionTime > this.switchPageHoverTime) {
      if (this.swiperController) {
        this.switchToPageIndex = this.updateLayoutBySwitchNextInDrag(pageIndex);
        if (this.switchToPageIndex === CommonConstants.INVALID_VALUE) {
          log.showError('switchNext error');
          return;
        }
        log.showInfo('switchNext');
        this.swiperController.showNext();
      }
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
    }
  }

  private switchPrevious(nowTime: number, pageIndex: number): void {
    if (pageIndex <= 0) {
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
      return;
    }
    if (this.lastInSwitchRegionTime === CommonConstants.INVALID_VALUE) {
      this.lastInSwitchRegionTime = nowTime;
      return;
    }

    if (nowTime - this.lastInSwitchRegionTime > this.switchPageHoverTime) {
      if (this.swiperController) {
        this.switchToPageIndex = this.updateLayoutBySwitchPreviousInDrag(pageIndex);
        if (this.switchToPageIndex === CommonConstants.INVALID_VALUE) {
          log.showError('switchPrevious error');
          return;
        }
        log.showInfo('switchPrevious');
        this.swiperController.showPrevious();
      }
      this.lastInSwitchRegionTime = CommonConstants.INVALID_VALUE;
    }
  }

  private swiperPageInDrag(index: number, targetIndex: number): void {
    log.showInfo('swiper page in drag.index=%{public}d,targetIndex=%{public}d', index, targetIndex);
    if (targetIndex > index) {
      this.updateLayoutBySwitchNextInDrag(index);
    } else if (targetIndex < index) {
      this.updateLayoutBySwitchPreviousInDrag(index);
    }
  }

  private updateLayoutBySwitchNextInDrag(pageIndex: number): number {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    const openFolderPages: number = openFolderData.layoutInfo?.length ?? 0;
    if (!openFolderData?.layoutInfo || pageIndex + 1 >= openFolderPages) {
      log.showError('folderInfo error');
      return CommonConstants.INVALID_VALUE;
    }

    let dragIndex: number = openFolderData.layoutInfo[pageIndex].findIndex(item => item?.keyName as string ===
      this.folderDragItemInfo?.keyName as string);
    if (dragIndex < 0) {
      log.showError('updateLayoutBySwitchNextInDrag dragIndex=%{public}d', dragIndex);
      return CommonConstants.INVALID_VALUE;
    }
    let nextIndex: number = pageIndex + NumberConstants.CONSTANT_NUMBER_ONE;
    let nextItem = openFolderData.layoutInfo[nextIndex][0];
    // 删除本页的dragItem ,把下一页的第一个 拿到本页最后一个
    openFolderData.layoutInfo[pageIndex].splice(dragIndex, 1);
    openFolderData.layoutInfo[pageIndex].push(nextItem);
    // 删除下一页第一个 把dragItem添加到最后
    openFolderData.layoutInfo[nextIndex].splice(0, 1);
    openFolderData.layoutInfo[nextIndex].push(this.folderDragItemInfo);
    this.isSwitchingPage = true;
    OpenFolderDragHandler.getInstance().initStartAndEndIndex(openFolderData.layoutInfo[nextIndex].length - 1);
    OpenFolderDragHandler.getInstance().resetTranslateZero('by updateLayoutBySwitchNextInDrag');

    // TODO 补充一个刷新接口
    return nextIndex;
  }

  private updateLayoutBySwitchPreviousInDrag(pageIndex: number): number {
    let openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (!openFolderData?.layoutInfo) {
      log.showError('folderInfo error');
      return CommonConstants.INVALID_VALUE;
    }

    let dragIndex: number = openFolderData.layoutInfo[pageIndex].findIndex(item => item?.keyName ===
      this.folderDragItemInfo?.keyName);
    if (dragIndex < 0) {
      log.showError('updateLayoutBySwitchPreviousInDrag dragIndex=%{public}d', dragIndex);
      return CommonConstants.INVALID_VALUE;
    }
    let previousIndex: number = pageIndex - NumberConstants.CONSTANT_NUMBER_ONE;
    // 删除上一页最后一个并取出
    let previousPageLastItem = openFolderData.layoutInfo[previousIndex].pop();
    if (!previousPageLastItem) {
      log.showError('previousPageLastItem info error');
      return CommonConstants.INVALID_VALUE;
    }
    // 删除本页的dragItem ,把上一页的最后一个 拿到本页的第一个
    openFolderData.layoutInfo[pageIndex].splice(dragIndex, 1);
    openFolderData.layoutInfo[pageIndex].splice(0, 0, previousPageLastItem);
    // 把dragItem添加到上一页最后
    openFolderData.layoutInfo[previousIndex].push(this.folderDragItemInfo);
    this.isSwitchingPage = true;
    OpenFolderDragHandler.getInstance().initStartAndEndIndex(openFolderData.layoutInfo[previousIndex].length - 1);
    OpenFolderDragHandler.getInstance().resetTranslateZero('by updateLayoutBySwitchPreviousInDrag');
    return previousIndex;
  }

  private dropOnDesktop(event: DragEvent): void {
    const dragFormTypes = [
      CommonConstants.DRAG_FROM_SWIPE_UP,
      CommonConstants.DRAG_FROM_MANAGE,
      CommonConstants.DRAG_FROM_FORM_SERVICE
    ];
    if (dragFormTypes.includes(AppStorage.get<number>('dragItemType') as number)) {
      const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
        .get('drop to Desktop from folder', DragHandlerType.DESKTOP) as IDesktopDragHandler;
      log.showInfo('drop event send to pageDesktopDragHandler');
      let rectangle = event.getPreviewRect();
      let dropX = Number(rectangle.x) + Number(rectangle.width) / 2;
      let dropY = Number(rectangle.y) + Number(rectangle.height) / 2;
      dragProxy?.onDragDrop(dropX, dropY);
    }
    log.showInfo(`dropOnDesktop`)
  }

  /**
   * 关闭输入法
   * */
  private closeFolderRenameKeyboard(): void {
    FocusUtil.requestFocus(this.getUIContext(), this.folderOpenComponentContainerKey);
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let isNameChanged: boolean = false;
    this.folderNameAppearDuration = 0;
    this.folderNameDisappearDuration = 0;
    animateTo({ duration: 0 }, () => {
      this.isRenaming = false;
    })
    if (this.newFolderName && this.newFolderName.trim() !== '' && this.newFolderName != openFolderData.folderName) {
      openFolderData.folderName = this.newFolderName.trim();
      ContractedFolderCommonViewModel.getInstance()
        .updateFolderName('modify name', openFolderData.folderId, openFolderData.folderName);
      isNameChanged = true;
    }
    let entrance: string = openFolderData?.enterEditing ? 'close' : 'open';
    HiSysEventUtil.reportRenameFolder(this.folderId, !this.isSmallFolder,
      isNameChanged, entrance);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT);
  }

  @Builder
  FolderOpenHiddenIconBuilder(index: number, item: GridLayoutItemInfo): void {
    GridItem() {
      NodeContainer(this.folderAppBubbleNodeManager.getOrCreateNode(item.keyName as string, 'FolderOpenHiddenIcon'))
        .id(`${TAG}_FolderAppItem_${item?.bundleName}`)
        .width(this.openFolderStyle.iconSize)
        .height(this.openFolderStyle.iconSize)
        .margin({ top: this.openFolderStyle.iconMarginTop })
        .hitTestBehavior(HitTestMode.Block)
    }
    .align(Alignment.Top)
    .onDisAppear(() => {
      if (this.lastHideIcons.length === 0) {
        // 隐藏组件消失, 恢复组件状态, 方便下次正常使用
        openFolderAppBubbleLayout.revertAppData(item, `FolderOpenHiddenIcon ${item.keyName}`);
        this.hubBadgeChangeEvent(item);
      }
    })
  }

  @Builder
  hiddenRowBuilder() {
    if (this.lastHideIcons.length > 0) {
      Grid() {
        ForEach(this.lastHideIcons, (item: GridLayoutItemInfo, index: number) => {
          this.FolderOpenHiddenIconBuilder(index, item);
        }, (item: GridLayoutItemInfo) => JSON.stringify(item))
      }
      .clip(false)
      .margin({
        // 需要将自身布局的第一排图标距离swiperPage的最后一排图标的间距设置为swiperPage中的行间距，保证宫格位置的计算正常.上边距计算公式为:
        // swiperPage父布局的marginTop + swiperPage父布局高度的一半 + swiperPage高度的一半 - swiperPage的paddingBottom
        // - 自身布局的paddingTop + gridRowGap
        // pad计算gridRowGap会小于0，在initGridParamOpenFolder时，gridRowGap小于零会被忽略，因此在这里进行适配
        top: AppStorage.get<number>('screenHeight') as number - this.openFolderStyle.openFolderIconBottomMargin
      })
      .columnsGap(this.openFolderStyle.columnGap)
      .rowsGap(this.openFolderStyle.rowGap)
      .columnsTemplate(this.columnsTemplate)
      .rowsTemplate('1fr 1fr')
      .width(this.openFolderStyle.openGridWidth)
      .height(
        // 自身高度设置为两个swiperPage中item的高度 + gridRowGap + paddingTop + paddingBottom
        // 保证item的高度与swiperPage内的item高度一致
        // (this.gridHeight - this.gridRowGap) * 0.5 + FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_WIDTH)
        this.openFolderStyle.gridItemHeight * NumberConstants.CONSTANT_NUMBER_TWO + this.openFolderStyle.columnGap)
      .padding({
        left: this.openFolderStyle.gridHorizontalPadding,
        right: this.openFolderStyle.gridHorizontalPadding,
      })
      .id(TAG + '_big_folder_hidden_icons')
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
  }

  private getHiddenRowBuilderExHight(): number {
    const count = FolderModel.getInstance().getFolderOpenLayout()?.row ?? 0;
    return this.openFolderStyle.gridItemHeight * (count + NumberConstants.CONSTANT_NUMBER_TWO) +
      this.openFolderStyle.columnGap * (count + NumberConstants.CONSTANT_NUMBER_ONE);
  }

  private hiddenRowBuilderExAppear(): void {
    if (this.pageIndex === 0) {
      return;
    }
    if (!openFolderHiddenIconLayout.isReadyOrAniTask()) {
      openFolderHiddenIconLayout.setReady(true);
      return;
    }
    const taskAni = openFolderHiddenIconLayout.getAniTask();
    if (!taskAni) {
      openFolderHiddenIconLayout.setReady(true);
    } else {
      taskAni();
    }
  }

  private hiddenRowBuilderExDisAppear(): void {
    if (this.pageIndex === 0) {
      return;
    }
    openFolderHiddenIconLayout.setReady(false);
    openFolderHiddenIconLayout.setAniTask(undefined);
  }

  private hubBadgeChangeEvent(item: GridLayoutItemInfo): void {
    if (AppStorage.get<boolean>('showDesktopBadges')) {
      const key = `${FolderConstants.OPEN_CLOSE_FOLDER_ITEM_BADGE_CHANGE}${item.keyName}`;
      this.desktopContext?.eventHub.emit(key);
    }
  }

  @Builder
  private hiddenRowBuilderEx(): void {
    if (this.lastHideFirstPageIcons.length !== 0) {
      Grid() {
        ForEach(this.lastHideFirstPageIcons, (item: GridLayoutItemInfo, index: number) => {
          GridItem() {
            OpenFolderHiddenIcon({
              item: item,
              showItem: index < this.lastShowIcons.length ? this.lastShowIcons[index] : undefined,
              isHidden: (index >= this.lastHideFirstPageLength) || GridLayoutUtil.isAddIcon(item),
              onShowItemDisAppear: index >= this.lastShowIcons.length ? undefined : (item: GridLayoutItemInfo) => {
                this.hubBadgeChangeEvent(item);
              },
            })
              .margin({ top: this.openFolderStyle.iconMarginTop })
          }
          .zIndex(this.lastHideFirstPageIcons.length - index)
          .align(Alignment.Top)
        }, (item: GridLayoutItemInfo) => item.keyName ?? '')
      }
      .clip(false)
      .margin({
        top: this.openFolderStyle.openFolderIconTopMargin
      })
      .columnsGap(this.openFolderStyle.columnGap)
      .rowsGap(this.openFolderStyle.rowGap)
      .columnsTemplate(this.columnsTemplate)
      .rowsTemplate(this.rowsTemplate + ' 1fr 1fr')
      .width(this.openFolderStyle.openGridWidth)
      .height(this.getHiddenRowBuilderExHight())
      .padding({
        left: this.openFolderStyle.gridHorizontalPadding,
        right: this.openFolderStyle.gridHorizontalPadding,
      })
      .id(TAG + '_big_folder_hiddenex_icons')
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .onAppear(() => { this.hiddenRowBuilderExAppear(); })
      .onDisAppear(() => { this.hiddenRowBuilderExDisAppear(); })
    }
  }

  private isHideEdgeEffect(): boolean {
    return this.isGeometryTransiting || !this.isChangingPage || this.isClosing;
  }

  private getGradientStart(): number {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    if (screenWidth === 0) {
      return 0;
    }
    return (screenWidth - this.openFolderStyle.dragBorderWidth) / screenWidth / NumberConstants.CONSTANT_NUMBER_TWO;
  }

  private getGradientEnd(): number {
    if (this.openFolderStyle.dragBorderWidth === 0) {
      return 0;
    }
    return this.getGradientStart() + FolderStyleConstants.DEFAULT_EDGE_GRADIENT_WIDTH /
    this.openFolderStyle.dragBorderWidth;
  }

  private getPadPaddingBottom(): number {
    let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    return screenHeight - (this.gridHeight + this.tittleMargin) -
      2 * FolderStyleConstants.DEFAULT_OPEN_FOLDER_INDICATOR;
  }

  /**
   * 纯色模式和静态显示保持一致,Dock小文件夹没有模糊, 此属性生效, 在使用模糊时, 此属性不生效
   * @returns 颜色值
   */
  private getBackgroundColor(): Resource | string {
    return SCBVisualEffectMgr.isFolderSolidColor() ? $r('app.color.low_back_plane_bg_color') :
    $r('app.color.back_plane_bg_color')
  }

  private isFolderInDockAndExpandState(): boolean {
    let folderStatus: number | undefined = AppStorage.get<number>('folderStatus');
    const isInDock: boolean = this.mFolderMgr.getOpenedFolder().container === CommonConstants.CONTAINER_SMARTDOCK;
    return isInDock && (DeviceHelper.isPad() ||
        DeviceHelper.isFoldButNotSmallFoldProduct() && folderStatus === DeviceState.EXPAND_STATE);
  }

  private togglePageIndexOnCloseFolder(): void {
    // 重命名状态下不需要跳页
    if (this.isRenaming) {
      return;
    }
    // 滑动时关闭文件夹场景，进行切页，避免swiper动效影响文件夹关闭动效
    if (this.targetPageIndex !== this.pageIndex || (this.targetPageIndex !== this.mFolderMgr.getPageIndex())) {
      log.showWarn(`togglePageIndexOnCloseFolder swiper to target:${this.targetPageIndex},${this.pageIndex}`);
      this.swiperController?.changeIndex(this.targetPageIndex, false);
      this.mFolderMgr.setPageIndex(this.targetPageIndex);
      this.pageIndex = this.targetPageIndex;
    }
    this.swiperController?.finishAnimation();
  }

  // 点击清除文本按钮
  private onClickCancelBtn = (): void => {
    FolderAccessibilityUtils.textAnnouncedForNameCleared();
    this.newFolderName = '';
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let entrance: string = openFolderData?.enterEditing ? 'close' : 'open';
    HiSysEventUtil.clearFolderName(openFolderData.folderId,
      !this.isSmallFolder, true, entrance);
  }

  // 重命名取消按钮图片
  @Builder
  cancelBtnBuilder() {
    SymbolGlyph($r('sys.symbol.xmark'))
      .fontSize('24vp')
      .fontColor([this.folderNameColor])
      .draggable(false)
      .id(`${TAG}_Image_cancelApp`)
      .width(DeviceHelper.isPad() ? FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE * 2 :
      FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE)
      .height(DeviceHelper.isPad() ? FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE * 2 :
      FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE)
      .padding(DeviceHelper.isPad() ? FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE / 2 : 0)
      .onClick(this.onClickCancelBtn)
  }

  private getRenameMargin(): Padding {
    let rate: number = DeviceHelper.isPad() ? NumberConstants.CONSTANT_NUMBER_TWO : NumberConstants.CONSTANT_NUMBER_ONE;
    let margin: number = -(FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE * rate +
      FolderStyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN);
    if (RTLUtil.isRTL()) {
      return {
        left: margin
      }
    }
    return {
      right: margin
    }
  }

  private getRenamePadding(): Padding {
    let extra4Pad: number = FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE / NumberConstants.CONSTANT_NUMBER_TWO;
    let padding: number = FolderStyleConstants.DEFAULT_BUTTON_HEIGHT + (DeviceHelper.isPad() ? extra4Pad : 0);
    if (RTLUtil.isRTL()) {
      return {
        top: 0,
        bottom: 0,
        left: padding,
        right: FolderStyleConstants.DEFAULT_BUTTON_HEIGHT
      }
    }
    return {
      top: 0,
      bottom: 0,
      right: padding,
      left: FolderStyleConstants.DEFAULT_BUTTON_HEIGHT
    };
  }

  // 重命名编辑状态textInput属性
  @Styles
  renamingTextInputStyles() {
    .padding(this.getRenamePadding())
    .margin(this.getRenameMargin())
    .onFocus(() => {
      log.showInfo('%{public}s onFocus', this.textInputKey);
      this.textInputController.setTextSelection(0, this.newFolderName.length)
      this.desktopContext?.eventHub.off(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT);
      this.desktopContext?.eventHub.on(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT,
        (): void => this.closeFolderRenameKeyboard());
      this.desktopContext?.eventHub.on(CommonConstants.HIDE_DESKTOP_EVENT, this.handlerEnterSettingOnControlCenter);
    })
    .onAppear(() => {
      const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      this.newFolderName = FolderCommonUtil.getRealFolderName(openFolderData.folderName ?? '');
      this.setFocusManual();
      if (this.isAccessibilityMode) {
        AccessibilityManager.getInstance().requestFocusAccessibility(FOLDER_NAME_TEXT_ID, false);
      }
    })
  }

  // 文件夹名称编辑状态
  @Builder
  renamingFolderNameBuilder() {
    Row() {
      TextInput({ text: this.newFolderName, controller: this.textInputController })
        .draggable(false)
        .id(`${TAG}_textInput_newFolderName`)
        .key(this.textInputKey as string)
        .maxLength(CommonConstants.FOLDER_NAME_MAX_LENGTH)
        .caretColor($r('sys.color.ohos_id_color_text_primary_activated'))
        .fontColor(this.folderNameColor)
        .fontSize(this.fontScaleState.getScaleSize(FolderStyleConstants.DEFAULT_OPEN_FOLDER_NAME_SIZE))
        .fontWeight(FontWeight.Normal)
        .height(FolderStyleConstants.DEFAULT_OPEN_FOLDER_TEXTAREA_HEIGHT)
        .borderRadius(FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE)
        .layoutWeight(1)
        .enterKeyType(EnterKeyType.Done)
        .textAlign(TextAlign.Center)
        .onSubmit((enterKey: EnterKeyType) => {
          log.showInfo('textinput done: %{public}s', enterKey);
          this.isRenaming = true;
          this.saveText?.();
        })
        .onChange((text: string) => {
          log.showInfo('textinput: %{public}s', text);
          if (text.trim() !== '') {
            this.newFolderName = text;
          }
        })
        .renamingTextInputStyles()

      if (this.isAccessibilityMode) {
        Stack() {
          this.cancelBtnBuilder()
        }
        .onClick(this.onClickCancelBtn)
        .accessibilityGroup(true)
        .accessibilityText(ResourceManager.getInstance().getStringByName('folder_rename_clear'))
      } else {
        this.cancelBtnBuilder()
      }
    }
    .height(FolderStyleConstants.DEFAULT_OPEN_FOLDER_TEXTAREA_HEIGHT)
    .width(FolderStyleConstants.PERCENTAGE_100)
    .borderRadius(FolderStyleConstants.DEFAULT_OPEN_FOLDER_CANCEL_SIZE)
    .padding(RTLUtil.isRTL() ? { left: FolderStyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN } :
      { right: FolderStyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN })
    .backgroundColor($r('app.color.input_box_sub_bg'))
  }

  // 文件夹名称正常显示状态
  @Builder
  normalFolderNameBuilder() {
    Text(FolderCommonUtil.getRealFolderName(this.folderName)) {
    }
    .focusable(true)
    .tabIndex(1)
    .fontSize(this.fontScaleState.getScaleSize(FolderStyleConstants.DEFAULT_OPEN_FOLDER_NAME_SIZE))
    .fontColor(this.folderNameColor)
    .textAlign(TextAlign.Center)
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .draggable(false)
    .onClick(() => {
      log.showDebug('title click');
      const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      // 锁定布局时，不允许修改文件夹名称
      if (lockLayoutManager.isLockLayout()) {
        lockLayoutManager.toastLockedLayout();
        return;
      }
      if (this.isDrag) {
        log.showInfo('isDrag, just ignore title click');
        return;
      }
      if (DeliverUtil.isDisableOperationsOnFolder(openFolderData?.folderId) ||
      NotHarmonyUtil.isNotHarmonyFolderById(openFolderData?.folderId)) {
        log.showInfo('this folder cannot be rename');
        if (DeliverUtil.isShowToast()) {
          Prompt.showToast({
            message: ResourceManager.getInstance().getStringByName('can_not_rename_flod')
          });
          // 文件夹提示不支持重命名打点上报
          let folderType: number = DeliverUtil.getFolderTypeByFolderId(this.folderId);
          HiSysEventUtil.reportRenameNotHarmonyFolder(folderType)
        }
        return;
      }
      this.folderNameAppearDuration = 0;
      this.folderNameDisappearDuration = 0;
      animateTo({ duration: 0 }, () => {
        this.isRenaming = true;
      })
      this.setFocusManual();
      this.newFolderName = FolderCommonUtil.getRealFolderName(openFolderData.folderName ?? '');
    })
    .opacity(this.gridSwiperLayout.titleOpacity)
  }

  // 文件夹名称
  @Builder
  folderNameBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.isRenaming) {
        this.renamingFolderNameBuilder()
      } else {
        this.normalFolderNameBuilder()
      }
    }
    .width(this.openFolderStyle.openGridWidth)
    .height(FolderStyleConstants.DEFAULT_OPEN_FOLDER_TEXTAREA_HEIGHT)
    .id(FOLDER_NAME_TEXT_ID)
    .zIndex(2)
    .margin({
      top: this.openFolderStyle.titleMarginTop
    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.isShowBg) {
        Column() {
          // 编辑模式下, 文件夹背板跟singlePage的背板颜色几乎一样，添加一个背景色突显文件夹背板
          if (this.editModeViewState.isShowEditModeView() && !SCBVisualEffectMgr.isFolderSolidColor()) {
            Column()
              .height(this.gridSwiperLayout.bgHeight)
              .width(this.gridSwiperLayout.bgWidth)
              .backgroundColor(editModeManager.getEditModeFolderViewData().getFolderBackgroundColor())
              .borderRadius(openFolderLayout.getBackgroundLayout().radius)
          }
        }
        .borderRadius(openFolderLayout.getBackgroundLayout().radius)
        .margin({ top: openFolderLayout.getBackgroundLayout().openedMargin })
        .backgroundBlurStyle(BlurStyle.NONE, { policy: 1 }, { disableSystemAdaptation: true })
        .height(this.gridSwiperLayout.bgHeight)
        .width(this.gridSwiperLayout.bgWidth)
        .opacity(this.gridSwiperLayout.bgOpacity)
        .backgroundColor(this.getBackgroundColor())
        .useEffect(!SCBVisualEffectMgr.isFolderSolidColor() && !this.isFolderInDockAndExpandState())
        .translate({ x: this.gridSwiperLayout.bgTranslateX, y: this.gridSwiperLayout.bgTranslateY })
      }

      Stack({ alignContent: Alignment.Top }) {
        // 节点顺序，文件夹名称第一个节点，无障碍屏幕朗读聚焦顺序与此有关
        this.folderNameBuilder();
        if (this.lastHideFirstPageIcons.length === 0 && this.mFolderInfoData.length > 0) {
        Stack({ alignContent: Alignment.Top }) {
          Swiper(this.swiperController) {
            ForEach(this.mFolderInfoData, (item: GridLayoutItemInfo[], index: number) => {
              OpenFolderSwiperPage({
                isGeometryTransiting: this.isGeometryTransiting,
                pageIndex: index,
                isSwitchingPage: this.isSwitchingPage,
                folderPageLength: this.folderPageLength,
                switchToPageIndex: this.switchToPageIndex,
                isChangingPage: this.isChangingPage,
                openFolderRect: this.openFolderRect,
                switchFolderPage: (x: number, y: number, nowTime: number, pageIndex: number): boolean => {
                  return this.switchFolderPage(x, y, nowTime, pageIndex);
                },
                dropOnDesktop: (event: DragEvent): void => {
                  this.dropOnDesktop(event);
                },
                folderId: this.folderId,
                isSmallFolder: this.isSmallFolder,
                appItemWidth: this.appItemWidth,
                appNameSize: this.appNameSize,
                gridHeight: this.gridHeight,
                gridPadding: this.gridPadding,
                columnsTemplate: this.columnsTemplate,
                rowsTemplate: this.rowsTemplate,
                gridGap: this.gridGap,
                isSwiperClipForce: this.isSwiperClipForce,
                gridRowGap: this.gridRowGap,
                mFolderIconRadius: this.mFolderIconRadius,
                folderGridWith: this.folderGridWith,
                folderHorizontalPending: this.folderHorizontalPending,
                isRenaming: this.isRenaming
              })
            }, (item: GridLayoutItemInfo[], index: number) => {
              log.showDebug('FolderSwiperPage index:%{public}i', index);
              return index + (this.folderId) + this.themeStyle;
            })
          }
          .indicatorInteractive(false)
          .disableSwipe(this.forbidFolderOpenSwiper)
          .key(this.folderOpenComponentContainerKey)
          .cachedCount(0)
          .accessibilityLevel('no')
          .clip(this.isSwiperClipForce)
          .width(this.openFolderStyle.openGridWidth)
          .height(FolderStyleConstants.PERCENTAGE_100)
          .itemSpace(this.swiperItemSpace)
          .transition(TransitionEffect.opacity(FolderStyleConstants.DEFAULT_VISIBLE_VALUE))
          .indicator(this.gridSwiperLayout.isShowIndicator && this.hasMoreThanOnePage())
          .indicatorStyle({
            selectedColor: this.swiperSelectedColor,
            color: this.swiperColor,
            bottom: this.openFolderStyle.indicatorBottom
          })
          .gesture(
            GestureGroup(GestureMode.Exclusive,
              GestureGroup(GestureMode.Parallel,
                // 用于在Swiper被屏蔽滑动以后消费滑动事件，避免触发点击关闭小文件夹
                PanGesture({ direction: PanDirection.Horizontal, distance: DISTANCE_FOLD_OPEN_SWIPER })
                  .onActionStart((event) => {
                  }),
              ),
              TapGesture()
                .onAction((event?: GestureEvent) => {
                  log.showInfo('open folder Swiper onClick');
                  if (this.isDrag) {
                    log.showInfo('ignore swiper click, is dragging');
                    return;
                  }
                  let finger = event?.fingerList[0];
                  let isEventEmpty = CheckEmptyUtils.isEmpty(event);
                  let isFingerEvent = CheckEmptyUtils.isEmpty(finger);
                  if (isEventEmpty || isFingerEvent) {
                    log.showInfo('ignore swiper click, event empty: isEventEmpty: %{public}s , isFingerEventEmpty: %{public}s ',
                      isEventEmpty, isFingerEvent);
                    return;
                  }

                  this.togglePageIndexOnCloseFolder();
                  BigFolderViewModel.getInstance().setCloseType(FolderCloseType.HOME_GESTURE);
                  try {
                    log.showInfo('raiseAnimateToSchedulePriority:close folder start');
                    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
                  } catch (error) {
                    log.error('onClick: performanceMonitor error', error);
                  }
                  this.saveText?.();
                })
            )
          )
          // 文件夹内应用拖拽过程中，当文件夹未收起时，屏蔽文件夹内图标点击事件及手势
          .onTouchIntercept(() => {
            if (this.isDrag) {
              log.showWarn('ignore appIcon click, is dragging');
              return HitTestMode.Block
            }
            return HitTestMode.Default
          })
          .index(this.pageIndex)
          .loop(false)
          .onChange((index) => {
            if (this.isClosing) {
              // 文件夹关闭中,不允许切页
              return;
            }
            this.isSwitchingPage = false;
            // 无障碍屏幕朗读模式下，翻页主动播报
            const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
            if (this.isFolderOpened) {
              // 从文件夹第二页关闭文件夹，会切换到第一页，此时isFolderOpened为false状态无需播报
              const pageInfo: PageType = { curPage: index + 1, totalPage: openFolderData.layoutInfo?.length || 1};
              localEventManager.sendLocalEventSticky(EventConstants.EVENT_ANNOUNCED_SWIPER_PAGE, pageInfo);
            }
            log.showInfo('swiper onChange, lastIndex:%{public}d to index:%{public}d', this.pageIndex, index);
            this.targetPageIndex = index;
            ExposureManager.getInstance().handleFolderExposureTimeEnd(this.pageIndex).then(() =>{
              ExposureManager.getInstance().handleFolderExposureTimeStart(index);
            });
            if (this.pageIndex != index) {
              this.pageIndex = index;
              this.mFolderMgr.setPageIndex(index);
            }
            if (openFolderData.layoutInfo) {
              let iconCount: number = 0;
              for (let i = 0; i < openFolderData.layoutInfo.length; i++) {
                iconCount += openFolderData.layoutInfo[i].length;
              }
              let folderType: number = DeliverUtil.getFolderTypeByFolderId(this.folderId);
              HiSysEventUtil.reportSnapToPageInFolder(openFolderData.folderId as string, iconCount,
                openFolderData.layoutInfo.length, !GridLayoutUtil.isSmallFolder(openFolderData), folderType);
            }
            FolderDataModelManager.getInstance().onFolderPageChange(this.folderId, index);
          })
          .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
            // 关闭打开动效过程中，需要打断该操作
            dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
            if (this.isClosing) {
              return;
            }
            openCloseAniMgr.isGetRectById(false);
            if (index === targetIndex) {
              TraceUtil.startTrace(DomainName.SCB, FeatureConstants.OPEN_FOLDER_SPRINGBACK_SCROLL_ANI);
            } else {
              TraceUtil.startTrace(DomainName.SCB,
                FeatureConstants.OPEN_FOLDER_OVER_SCROLL_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
            }
            log.showInfo('swiper change to page, index:%{public}d to targetIndex:%{public}d', index, targetIndex);
            this.lastSwipeOffset = 0;
            this.lastSwipeOffsetChanged = 0;
            this.targetPageIndex = targetIndex;
            let controller = SCBTransitionManager.getInstance().getCurrentTransitionController();
            if (controller?.updateAnimSwipeEnd) {
              log.showDebug('Folder updateAnimSwipeEnd index: %{public}d; targetIndex: %{public}d', index, targetIndex);
              controller?.updateAnimSwipeEnd(index, targetIndex, extraInfo);
            }

            this.isChangingPage = true;
            // 拖拽中滑动翻页需要刷新布局状态
            let isDrag = AppStorage.get<boolean>('isDrag');
            if (!isDrag || this.isSwitchingPage) {
              log.showDebug('swiper not in drag or switching page');
              return;
            }
            this.swiperPageInDrag(index, targetIndex);
          })
          .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
            TraceUtil.endTrace(DomainName.SCB, FeatureConstants.OPEN_FOLDER_SPRINGBACK_SCROLL_ANI);
            TraceUtil.endTrace(DomainName.SCB,
              FeatureConstants.OPEN_FOLDER_OVER_SCROLL_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
            this.isChangingPage = false;
            FolderDataModelManager.getInstance().setFolderStateById(
              FolderDataModelManager.getInstance()
                .getOpenFolderId(), FolderState.FOLDER_OPEN_STATIC);
            this.desktopContext?.eventHub.emit(`globalSearchLocationFolderSwitchToPage`);
            if (Math.abs(extraInfo.currentOffset) < 0.01) {
              openCloseAniMgr.isGetRectById(true);
            }
          })
          .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
            const currentOffset = extraInfo?.currentOffset;
            if (this.isGeometryTransiting) {
              return;
            }
            this.isSwiperClipForce = true;
            this.isChangingPage = true;
            this.updateFolderCloseAppAnimate(currentOffset);
          })
          .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
            // 布局锁定时，预置页内文件夹内拖拽时无法翻页
            const msg: string = 'swipe on folderGridSwiper';
            if (this.isDrag && (layoutLockUtil.isLockedPage(this.pageIndexInDesktop, msg) ||
              (this.isInDock && layoutLockUtil.isLocked(msg)))) {
              return GestureJudgeResult.REJECT;
            }
            if (gestureInfo.type !== GestureControl.GestureType.PAN_GESTURE) {
              dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
            }
            if (gestureInfo.type !== GestureControl.GestureType.TAP_GESTURE) {
              SCBTransitionManager.getInstance().cancelCloseAppAnimate();
            }
            if (gestureInfo.type === GestureControl.GestureType.SWIPE_GESTURE) {
              FolderDataModelManager.getInstance().setFolderStateById(
                FolderDataModelManager.getInstance()
                  .getOpenFolderId(), FolderState.FOLDER_OPEN_SWITCHING);
            }
            return GestureJudgeResult.CONTINUE;
          })
        }
        /*.blendMode(this.isHideEdgeEffect() ? BlendMode.NONE : BLENDMODE_DESTINATION_IN,
          this.isHideEdgeEffect() ? BlendApplyType.FAST : BlendApplyType.OFFSCREEN)*/
        .clip(this.isSwiperClipForce)
        .onMouse((event?: MouseEvent) => {
          if (event?.button === MouseButton.Right) {
            event.stopPropagation?.();
            log.showDebug('Grid onMouse MouseButton Right');
          }
        })
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        }
        this.hiddenRowBuilder()
        this.hiddenRowBuilderEx()
        if (this.isDrag && !this.isDragLeave && this.isFolderOpened) {
          Column() {
          }
          .border({
            width: FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_WIDTH,
            radius: FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_RADIUS,
            color: FolderStyleConstants.FOLDER_OPEN_DRAG_BORDER_COLOR
          })
          .height(this.openFolderStyle.dragBorderHeight)
          .width(this.openFolderStyle.dragBorderWidth)
          .hitTestBehavior(HitTestMode.None)
          .margin({ top: this.openFolderStyle.dragBorderMargin })
        }
      }
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
      .hitTestBehavior(this.gridSwiperLayout.isInterceptEvent ? HitTestMode.Default : HitTestMode.Block)
      .clip(false)
    }
    .linearGradient(this.isHideEdgeEffect() ? {
      colors: []
    } : {
      angle: 90,
      colors: [
        ['rgba(255,255,255,0)', 0], ['rgba(255,255,255,0)', this.getGradientStart()],
        ['rgba(255,255,255,1)', this.getGradientEnd()], ['rgba(255,255,255,1)', 1 - this.getGradientEnd()],
        ['rgba(255,255,255,0)', 1 - this.getGradientStart()], ['rgba(255,255,255,0)', 1]]
    })
    .scale({
      x: this.editModeViewData.getScale() * this.animateScale,
      y: this.editModeViewData.getScale() * this.animateScale
    })
    .translate({
      y: editModeManager.isInEditMode() ? OpenFolderStyleConfig.getInstance().getCompensateTranslateYInEditMode() : 0
    })
    // .blendMode(this.isHideEdgeEffect() ? BlendMode.NORMAL : BLENDMODE_SRC_OVER)
    .id(`${TAG}_stack_folder`)
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      if (!this.isDrag) {
        log.showInfo('not drag SCBDesktop component, onDragEnter return');
        return;
      }
      if (FolderDragData.getInstance().canOpenedFolderDragStart()) {
        dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      }
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      if (!this.isDrag) {
        log.showInfo('not drag SCBDesktop component, onDrop return');
        return;
      }
      performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
      TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      if (event) {
        event.useCustomDropAnimation = true;
        const msg: string = 'drop on folderGridSwiper';
        if (layoutLockUtil.isLockedPage(this.pageIndexInDesktop, msg) ||
          (this.isInDock && layoutLockUtil.isLocked(msg))) {
          OpenFolderDragHandler.getInstance().animationToOriginalPos(event, this.dragItemType);
          return;
        }
        if (!this.mFolderMgr.isCanOpenFolderDragDrop()) {
          log.showInfo('send openFolder onDrop event to desktop 2');
          ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(() => {
            this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_DRAG_LEAVE_FROM_SMALL_FOLDER_ADVANCE,
              event, extraParams);
          })
          return;
        }
        log.showInfo('openFolder wrapper, onDrop event: [%{public}d, %{public}d]', event.getX(), event.getY());
        dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
        this.dropOnDesktop(event);
        ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(() => {
          log.showInfo('openFolder OpenFolderGridSwiper, onDrop waitFolderAnimateFinish');
          event.setResult(DragResult.DRAG_FAILED);
          this.isDragLeave = false;
          AppStorage.setOrCreate('selectAppIndex', null);
          AppStorage.setOrCreate('isDrag', false);
          AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', new GridLayoutItemInfo());
          this.mFolderMgr.setDragItemFolder(undefined);
        })
      }
    })
    .width(FolderStyleConstants.PERCENTAGE_100)
    .height(FolderStyleConstants.PERCENTAGE_100)
    .opacity(this.folderOpacity.value)
    .onAppear(() => {
      // 无障碍屏幕朗读模式下，打开文件夹主动播报
      FolderAccessibilityUtils.textAnnouncedForFolderOpen(this.mFolderMgr.getOpenedFolder());
      if (this.isAccessibilityMode) {
        AccessibilityManager.getInstance().requestFocusAccessibility(FOLDER_NAME_TEXT_ID, false);
      }
    })
    .onDisAppear(() => {
      // 无障碍屏幕朗读模式下，关闭文件夹主动播报
      FolderAccessibilityUtils.textAnnouncedForFolderClose(this.folderName);
      FolderAccessibilityUtils.updateAccessibilityFocusable(this.folderId, false);
    })
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .onClick(() => {
      log.showInfo('open folder blank onClick');
      if (this.isDrag) {
        log.showInfo('isDrag, just ignore blank click');
        return;
      }
      this.togglePageIndexOnCloseFolder();
      this.saveText?.();
    })
    .onMouse((event?: MouseEvent) => {
      if (event?.button === MouseButton.Right) {
        event.stopPropagation?.();
        log.showDebug('onMouse MouseButton Right');
      }
    })
    .clip(false)
    .hitTestBehavior(this.gridSwiperLayout.isInterceptEvent ? HitTestMode.Default : HitTestMode.None)
  }
}
