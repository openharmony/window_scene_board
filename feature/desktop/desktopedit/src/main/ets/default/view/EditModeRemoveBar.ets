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
  AppInstallUtils,
  AppItemInfo,
  AppModel,
  AppStatus,
  CommonConstants,
  DeleteIconAreaParam,
  DeleteItemType,
  DesktopMode,
  EditModeConstants,
  editModeManager,
  EditModeRemoveParams,
  EditModeUninstallDialogParams,
  EditModeUninstallParams,
  EditModeViewState,
  EventConstants,
  FolderData,
  FolderImageRegister,
  GridLayoutItemInfo,
  HiEditModeDataExitType,
  HiEditModeDataUninstallObjType,
  HiEditModeDataUninstallType,
  HiEditModeEventUtils,
  layoutLockUtil,
  LayoutViewModel,
  ListenerItemType,
  MultiSelectListenerType,
  multiSelectListenManger,
  MultiSelectManager,
  ReceiveEventInfo,
  StyleConstants,
  UninstallDialogStatus,
  ViewManager,
  ContractedFolderCommonViewModel,
  FolderManager,
  DragViewModelUtil,
  LaunchLayoutCacheManager
} from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import {
  batchUninstallChain,
  ForwardType,
  launcherVisualEffectMgr,
  ReConfirmationUninstallDialog,
  UninstallDialogUtil,
  RemoveDialogConfig,
  DragProxyManager,
  DragHandlerType,
  IDesktopDragHandler,
  PageDesktopViewModelProxy,
  OuterPageDesktopViewModelProxy,
  UninstallMode
} from '@ohos/launchercommon/Index';
import {
  AccessibilityManager,
  DeviceHelper,
  GlobalContext,
  HiSysEventUtil,
  localEventManager,
  viewMgrPolicy,
  ViewType,
  WallpaperColorManager
} from '@ohos/frameworkwrapper';
import { desktopUtil, RTLUtil, StateEx } from '@ohos/componenthelper';
import {
  launcherStatusUtil,
  ResUtils,
  SCBDesktopEventId,
  SCBScreenSessionManager,
  SCBTransitionController,
  SCBTransitionManager
} from '@ohos/windowscene';
import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { BatchRemoveDialog } from './dialog/BatchRemoveDialog';
import EditModeStyleConstants, { DragStatus } from '../common/constants/EditModeStyleConstants';
import type abilityCommon from '@ohos.app.ability.common';
import curves from '@ohos.curves';
import BusinessError from '@ohos.base';
import lottie, { AnimationConfigWithData, AnimationItem } from '@ohos/lottie';
import util from '@ohos.util';
import ArrayList from '@ohos.util.ArrayList';
import display from '@ohos.display';
import { editModeViewManager } from '../manager/EditModeViewManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { BatchUnInstallAppComponent } from './BatchUnInstallAppComponent';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { FolderDropType } from '@ohos/launchercommon/src/main/ets/folder/next/common/FolderCommonConstant';
import { baseStateMgr, DarkModeState, StateType } from '@ohos/systemuicommon';
import GridLayoutUtil from '@ohos/launchercommon/src/main/ets/utils/GridLayoutUtil';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'EditModeRemoveBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ANIMATE_NAME_LEAVE = 'ANIMATE_NAME_LEAVE_CLOSE';
const NORMAL_COLOR: string = '#40ffffff';
const LIGHT_COLOR: string = '#33000000';

/**
 * 编辑模式上方按钮组件
 */
@Component
export struct EditModeRemoveBar {
  @Prop singleContext?: SingleContext;
  @StorageLink('dragItemInfo') @Watch('onAppItemDragged') pageDesktopDragItemInfo:
  GridLayoutItemInfo | GridLayoutItemInfo[] = new GridLayoutItemInfo();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('outerShowEditModeTopBar') outerShowEditModeTopBar: boolean = true;
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @Consume isShowingUninstallDialog: number;
  @Consume dragToUninstallItemInfo: GridLayoutItemInfo;
  @State buttonBgColor: ResourceColor = NORMAL_COLOR;
  @State dragItemList: GridLayoutItemInfo[] = [];
  @State marginTop: number = this.editModeStyleConfig.pageEditRemoveBarMarginTop;
  @State paddingLeft: number = this.editModeStyleConfig.pageEditRemoveBarPaddingLeft;
  @State paddingRight: number = this.editModeStyleConfig.pageEditRemoveBarPaddingRight;
  @State shouldShowDeleteIcon: boolean = false;
  @State isDragCardItem: boolean = false;
  @State hasEnterHotArea: boolean = false;
  @State leftHotAreaSize: number = 0;
  @State bottomHotAreaSize: number = 0;
  @State bgColor: ResourceColor = this.buttonBgColor;
  @State deleteOKButtonScale: number = 1.0;
  @State addButtonScale: number = 1.0;
  @State isLottiePlayIng: boolean = false;
  @State dragStatus: number = DragStatus.NO_DRAG;
  @State deleteIconLeft: number = 0;
  private deleteIconRight: number = 0;
  private deleteIconBottom: number = 0;
  @State isShowRemoveDialog: boolean = false;
  @State topBarOpacity: StateEx<number> = launcherVisualEffectMgr.getEditModeTopBarOpacity();
  @StorageLink('isDrag') @Watch('onDragChange') isDrag: boolean = false;
  @State isShowEditModeTopBar: boolean = false;
  private desktopContext: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
  private deleteIconCenterX: number = 0;
  @State removeDialogConfig: RemoveDialogConfig = new RemoveDialogConfig();
  private isFoldablePhoneExpandStatus: boolean = false;
  private isUninstallApp: boolean = false;
  // 手指拖拽点相对于拖拽图标左边距
  private dragAppItemX: number = 0;
  // 手指拖拽点相对于拖拽图标上边距
  private dragAppItemY: number = 0;
  // 拖拽松手后，图标左上角x坐标
  private dropX: number = 0;
  // 拖拽松手后，图标左上角y坐标
  private dropY: number = 0;
  private autoAlignArr: GridLayoutItemInfo[] = [];
  private lastDragStatus: number = DragStatus.NO_DRAG;
  private animateItem: AnimationItem | undefined = undefined;
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  private context2D: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private isCanvasReady = false;
  private lottieData: object | null = null;
  private lottieFilePool: Map<string, AnimationConfigWithData> = new Map();
  private lastLottieName: string = '';
  private screenHeight: number = LayoutViewModel.getInstance(this.singleContext).getScreenHeight();
  private isOuter: boolean = false;
  private isRemoveOuterApp: boolean = false;
  private onDesktopModeChangeEvent: Function = (): void => this.onDesktopModeChange();
  private onFolderItemsRecoverEvent: Function =
    (folderItems: GridLayoutItemInfo[]): void => this.recoverFolderItems(folderItems);
  private onLongPressChangeEvent: Function = (isShow: boolean, isDragCardItem: boolean): void =>
  this.onLongPressIconStatusChange(isShow, isDragCardItem);
  private onItemUninstallEvent: Function = (toUninstallItems: GridLayoutItemInfo[]): void =>
  this.doUninstall(toUninstallItems);
  private onItemRemoveEvent: Function = (toRemoveItems: GridLayoutItemInfo[]): void =>
  this.doRemove(toRemoveItems);
  private folderStatusChangeCallback: (newState: display.FoldStatus) => void = (newState: display.FoldStatus) => {
    let isFoldToHalfFoldState: boolean = !this.isFoldablePhoneExpandStatus &&
      newState === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
    let isFoldOrExpandState: boolean = newState === display.FoldStatus.FOLD_STATUS_FOLDED ||
      newState === display.FoldStatus.FOLD_STATUS_EXPANDED;
    if (this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE &&
      (isFoldToHalfFoldState || isFoldOrExpandState)) {
      this.uninstallDialogController.close();
    }
    this.isFoldablePhoneExpandStatus = newState === display.FoldStatus.FOLD_STATUS_EXPANDED;
  };
  uninstallDialogController: CustomDialogController = new CustomDialogController({
    builder: BatchRemoveDialog({
      cancel: () => {
        if (this.editModeStyleConfig.uninstallDialogNeedActiveCloseDialog) {
          this.uninstallDialogController.close();
        }
        this.cancelRemove()
      },
      confirm: () => {
        if (this.editModeStyleConfig.uninstallDialogNeedActiveCloseDialog) {
          this.uninstallDialogController.close();
        }
        this.uninstallDialogConfirm();
      },
      jump2Uninstall: () => {
        this.jump2Uninstall()
      },
      dialogConfig: this.removeDialogConfig,
      isUninstallApp: this.isUninstallApp,
      upArrowCenterX: this.deleteIconCenterX,
      offsetY: this.marginTop + StyleConstants.DEFAULT_32 + StyleConstants.DEFAULT_8,
      isShowRemoveDialog: this.isShowRemoveDialog,
      singleContext: this.singleContext
    }),
    cancel: () => {
      if (this.editModeStyleConfig.uninstallDialogNeedActiveCloseDialog) {
        this.uninstallDialogController.close();
      }
      this.hasEnterHotArea = false;
      this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
      this.reportUninstallEvent(false, false);
      this.doCancelAnimate();
    },
    autoCancel: false,
    customStyle: this.editModeStyleConfig.uninstallDialogCustomStyle,
    alignment: this.editModeStyleConfig.uninstallDialogAlignment,
    maskColor: this.editModeStyleConfig.uninstallDialogMaskColor,
    gridCount: this.editModeStyleConfig.uninstallDialogGridCount,
    showInSubWindow: false,
    openAnimation: {
      duration: 0,
    },
    closeAnimation: {
      duration: 0,
    }
  });

  private uninstallDialogConfirm(): void {
    // 编辑模式下非多选拖拽指定应用才触发二级弹窗
    if (this.dragItemList.length === 1 &&
      UninstallDialogUtil.getIsNeedReConfirmationApp(this.dragItemList[0].bundleName) &&
      batchUninstallChain.currentMode === UninstallMode.NORMAL) {
      this.reConfirmationDialogController?.open();
    } else {
      this.confirmRemove();
    }
  }

  /**
   * 二次卸载菜单弹框
   */
  private reConfirmationDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ReConfirmationUninstallDialog({
      confirm: () => {
          this.confirmRemove();
        },
      cancel: () => {
        this.cancelRemove();
      },
      appIndex: this.dragItemList[0].appIndex,
      bundleName: this.dragItemList[0].bundleName,
      moduleName: this.dragItemList[0].moduleName,
      abilityName: this.dragItemList[0].abilityName
    }),
    cancel: () => { log.showInfo('cancel app uninstall dialog'); },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  private cancelRemove(): void {
    log.info(TAG, 'RemoveDialog cancel');
    this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON, 'cancelDelete');
    this.hasEnterHotArea = false;
    this.shouldShowDeleteIcon = false;
    this.isShowingUninstallDialog = UninstallDialogStatus.CANCEL_STATE;
    editModeManager.setIsShowingUninstallDialog(false);
    batchUninstallChain.forward(ForwardType.CANCEL_REMOVE);
    this.reportUninstallEvent(false, false);
    this.notifyDeskTopRefresh();
    this.doCancelAnimate();
    editModeViewManager.notifyWhiteBoxShowOrHide(true);
    FolderImageRegister.getInstance().notifyImageRefresh();
  }

  private editModeAutoAlign(): void {
    if (CheckEmptyUtils.isEmptyArr(this.autoAlignArr)) {
      log.showInfo('editMode autoAlign arr is null');
      return;
    }
    let needAutoAlign: GridLayoutItemInfo[] = [];
    this.autoAlignArr.forEach( item => {
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.container === CommonConstants.CONTAINER_DESKTOP) {
        needAutoAlign.push(item);
      }
    });
    if (needAutoAlign.length > 0) {
      log.showInfo('editMode shortcut autoAlign');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DELETE_APP_AUTO_ALIGN, needAutoAlign);
    }
    this.autoAlignArr = [];
  }

  private confirmRemove(): void {
    log.showInfo('RemoveDialog confirm');
    this.hasEnterHotArea = false;
    this.shouldShowDeleteIcon = false;
    this.isShowingUninstallDialog = UninstallDialogStatus.UNINSTALLING_STATE;
    editModeManager.setIsShowingUninstallDialog(false);
    if (batchUninstallChain.currentMode === UninstallMode.DRAWER) {
      this.reportRemoveEvent();
    } else {
      this.reportUninstallEvent(false, true);
    }
    batchUninstallChain.forward(ForwardType.CONFIRM_REMOVE);
    this.doConfirmAnimate();
    editModeViewManager.notifyWhiteBoxShowOrHide(true);
    this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON, 'delete');
    FolderImageRegister.getInstance().notifyImageRefresh();
    this.editModeAutoAlign();
  }

  private jump2Uninstall(): void {
    log.showInfo('RemoveDialog jump2Uninstall');
    // 关闭原对话框
    this.uninstallDialogController.close();
    // 闭环原抽屉模式责任链，变更为普通模式卸载
    batchUninstallChain.forward(ForwardType.JUMP_TO_UNINSTALL);
    // 刷新对话框配置
    if (batchUninstallChain.dialogConfig) {
      this.removeDialogConfig = batchUninstallChain.dialogConfig;
    }
    // 移除图标变为垃圾桶动效
    editModeViewManager.refreshDragItemColor(true, true);
    this.onDragEnterButtonHotArea();
    // 打开卸载对话框
    const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
      .get(TAG, DragHandlerType.DESKTOP) as IDesktopDragHandler;
    dragProxy.onDragLeave(0, 0);
    this.shouldShowDeleteIcon = false;
    this.updateDragStatus(DragStatus.DRAG_DROP);
    if (batchUninstallChain.currentMode === UninstallMode.NORMAL) {
      this.reportDialogEvent();
    }
    this.reportUninstallEvent(true);
    this.notifyDeskTopRefresh();
    this.isShowingUninstallDialog = UninstallDialogStatus.CONFIRM_STATE;
    editModeManager.setIsShowingUninstallDialog(true);
    this.uninstallDialogController.open();
    this.doDragDropAnimate();
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: DeleteIconAreaParam) => {
      log.info(TAG, `receive event:${event}, leftHotAreaSize:${params.leftHotAreaSize},
        bottomHotAreaSize:${params.bottomHotAreaSize}`);
      if (params && event === EventConstants.EVENT_EDIT_MODE_START_DRAG_ITEM) {
        this.leftHotAreaSize = Math.max(0, params.leftHotAreaSize);
        this.bottomHotAreaSize = Math.max(0, params.bottomHotAreaSize);
      }
    }
  };
  private swiperUpFromHomeCallback: (scale: number) => void = (scale: number) => {
    this.doFollowAnimate(scale);
  };
  private swiperBackHomeFromHomeCallback: (scale: number) => void = (scale: number) => {
    this.doBackHomeAnimate(scale);
  };
  private globalTransitionController: SCBTransitionController = {
    appData: {
      bundleName: '',
      abilityName: '',
      appIconId: `${TAG}Global`,
      appIconNumber: 0,
      iconRadius: 0
    },
    onActive: (): void => this.onActive(),
    onInactive: (): void => this.onInactive()
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.isOuter = launcherStatusUtil.getShowOutLauncherStatus();
    this.updateLayoutInfo();
    this.registerDragItemStartEvent(this.mLocalEventListener);
    this.registerFoldChangeListener();
    this.initLottie();
    this.registerScreenPropertyChange();
    this.desktopContext.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext.eventHub.on(EditModeConstants.EVENT_EDIT_MODE_FOLDER_ITEM_RECOVER,
      this.onFolderItemsRecoverEvent);
    this.desktopContext.eventHub.on(CommonConstants.LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON,
      this.onLongPressChangeEvent);
    this.desktopContext.eventHub.on(CommonConstants.EDIT_MODE_ITEM_UNINSTALL_EVENT, this.onItemUninstallEvent);
    this.desktopContext.eventHub.on(CommonConstants.EDIT_MODE_ITEM_REMOVE_EVENT, this.onItemRemoveEvent);
    SCBTransitionManager.getInstance().registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME,
      this.swiperUpFromHomeCallback);
    SCBTransitionManager.getInstance().registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME,
      this.swiperBackHomeFromHomeCallback);
    SCBTransitionManager.getInstance().registerGlobalTransitionController(this.globalTransitionController);
    this.updateButtonBgColor();
    this.registerMultiSelectListener();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.unRegisterDragItemStartEvent(this.mLocalEventListener);
    this.unRegisterFoldChangeListener();
    this.unRegisterScreenPropertyChange();
    this.lottieFilePool.clear();
    this.isLottiePlayIng = false;
    this.lastDragStatus = DragStatus.NO_DRAG;
    this.dragStatus = DragStatus.NO_DRAG;
    this.desktopContext.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext.eventHub.off(EditModeConstants.EVENT_EDIT_MODE_FOLDER_ITEM_RECOVER,
      this.onFolderItemsRecoverEvent);
    this.desktopContext.eventHub.off(CommonConstants.LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON,
      this.onLongPressChangeEvent);
    this.desktopContext.eventHub.off(CommonConstants.EDIT_MODE_ITEM_UNINSTALL_EVENT, this.onItemUninstallEvent);
    this.desktopContext.eventHub.off(CommonConstants.EDIT_MODE_ITEM_REMOVE_EVENT, this.onItemRemoveEvent);
    SCBTransitionManager.getInstance().unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME,
      this.swiperUpFromHomeCallback);
    SCBTransitionManager.getInstance().unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME,
      this.swiperBackHomeFromHomeCallback);
    SCBTransitionManager.getInstance().unRegisterGlobalTransitionController(this.globalTransitionController);
    this.unRegisterMultiSelectListener();
    this.autoAlignArr = [];
  }

  private isInHotArea(x: number, y: number): boolean {
    return x >= this.deleteIconLeft && x <= this.deleteIconRight && y >= this.marginTop && y <= this.deleteIconBottom;
  }

  private updatingGatheringPos(x: number, y: number) {
    if (!this.isUninstallAbleScene()) {
      log.showWarn('is not uninstallAbleScene');
      return;
    }
    if (!this.isInHotArea(x, y) && this.hasEnterHotArea) {
      log.info(TAG, 'updatingGatheringPos onDragLeave occurs');
      this.onDragLeaveButtonHotArea();
      this.desktopContext?.eventHub.emit(CommonConstants.GRID_SWIPER_DELEGATE_TO_MOVE, undefined, undefined);
      return;
    }
    if (this.isInHotArea(x, y) && !this.hasEnterHotArea) {
      log.info(TAG, 'updatingGatheringPos onDragEnter occurs');
      this.onDragEnterButtonHotArea();
      return;
    }
  }

  private dropWhenGathering() {
    if (!this.hasEnterHotArea) {
      multiSelectListenManger.executeCustomDrop(undefined, MultiSelectManager.getInstance().getFinalIconPosition());
      // 不在热区，结束卸载责任链，清空拖拽对象
      batchUninstallChain.forward(ForwardType.DRAG_END);
      return;
    }
    dropAnimationManager.clear();
    performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
    TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    log.showInfo('dropWhenGathering event occurs.');
    this.onDropInButtonHotArea();
    const lastActionTouchPosition: Position = MultiSelectManager.getInstance().lastActionTouchPosition;
    this.dealSqueezingLogic(lastActionTouchPosition.x as number, lastActionTouchPosition.y as number);
    this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON, 'drop');
    // 落位动效结束后 触发事件finish
    MultiSelectManager.getInstance().finishDrag();
    log.showInfo('dropWhenGathering event finished.');
  }

  private multiSelectListener: MultiSelectListenerType = {
    id: multiSelectListenManger.getListenerId(ListenerItemType.EDIT_MODE_TOP_BAR, '', this.isOuter),
    onGather: () => {
      // 多选长按汇聚必走onGather，在这里刷新卸载责任链状态为DRAG_START，后面触发LongPress的onActionEnd也不会endChain
      // 松手后要么走onDropWhenGathering，要么走onDragChange，后面判断是否落位热区进行endChain
      batchUninstallChain.forward(ForwardType.DRAG_START);
    },
    onMoveWhenGathering: (touchPos: Position) => {
      this.updatingGatheringPos(Number(touchPos.x), Number(touchPos.y));
    },
    onDropWhenGathering: () => {
      this.dropWhenGathering();
    }
  }

  private registerMultiSelectListener(): void {
    multiSelectListenManger.register(this.multiSelectListener);
  }

  private unRegisterMultiSelectListener(): void {
    multiSelectListenManger.unregister(this.multiSelectListener);
  }

  private onDragEnterButtonHotArea() {
    const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
      .get(TAG, DragHandlerType.DESKTOP) as IDesktopDragHandler;
    dragProxy.clearLastCoveredItemAnimation();
    this.hasEnterHotArea = true;
    this.updateDragStatus(DragStatus.DRAG_ENTER);
    this.doDragEnterAnimate();
    // 触发leave 事件
    dragProxy.onDragLeave(0, 0);
    this.announceForDelete();
    dragProxy.clearSwipeTimeout();
  }

  private onDragLeaveButtonHotArea() {
    this.hasEnterHotArea = false;
    this.updateDragStatus(DragStatus.DRAG_LEAVE);
    this.doDragLeaveAnimate();
  }

  private onDropInButtonHotArea() {
    log.showInfo(`openFolderStatus ${FolderData.getInstance().isFolderOpen()}`);
    this.dragItemList.forEach((item) => {
      const itemKey: string = (item.typeId === CommonConstants.TYPE_CARD ? item.cardId : item.keyName) ?? '';
      this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + itemKey, true);
    });
  }

  private onLongPressIconStatusChange(isShow: boolean, isDragCardItem: boolean): void {
    this.shouldShowDeleteIcon = (this.isOuter &&
    layoutLockUtil.isLockedPage(desktopUtil.getPageIndexValue(this.isOuter), 'show deleteIcon by long press', true)) ?
      false : isShow;
    this.shouldShowDeleteIcon = isShow;
    this.isDragCardItem = isDragCardItem;
  }

  private doUninstall(toUninstallItems: GridLayoutItemInfo[]) {
    log.showInfo(`batchUninstall>>> doUninstall ${toUninstallItems.length}`);
    if (this.isOuter) {
      this.doRemoveOuter(toUninstallItems);
      return;
    }
    if (this.isRemoveOuterApp) {
      let deleteAppNames: ArrayList<string> = new ArrayList<string>();
      toUninstallItems.forEach((item) => {
        OuterPageDesktopViewModelProxy.getInstance().deleteOuterAppInfo(item.bundleName, item.appIndex);
        deleteAppNames.add(item.bundleName);
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          HiSysEventUtil.reportDeleteShortcutMenu(item.bundleName, item.appName);
        }
      });
      this.reportDeleteAppListEvent(deleteAppNames);
      return;
    }
    let lastAppIndex: number = -1;
    toUninstallItems.forEach((item: GridLayoutItemInfo, index: number) => {
      if (item.typeId === CommonConstants.TYPE_CARD) {
        this.desktopContext.eventHub.emit('formItemDraggedRemoved', item.cardId);
      }
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        HiSysEventUtil.reportDeleteShortcutMenu(item.bundleName, item.appName);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_SHORTCUT_ITEM_DELETE, item);
        if (item.container != null && item.container !== CommonConstants.CONTAINER_DESKTOP) {
          ContractedFolderCommonViewModel.getInstance().drop('remove on edit', FolderManager.getInstance()
            .getOpenFolderId(), FolderDropType.DROP_REFRESH_FOLDER, DragViewModelUtil.getDragParams([item]));
        }
      }
      if (item.typeId === CommonConstants.TYPE_APP) {
        if (item.appStatus === AppStatus.INSTALLED) {
          let showToast: boolean = (index === lastAppIndex);
          let gridLayoutItemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
            .selectItemListByPageAndArea(item.page, item.area);
          gridLayoutItemList.forEach(cacheItem => {
            if (cacheItem.bundleName === item.bundleName && cacheItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
              this.autoAlignArr.push(cacheItem);
            }
          });
          PageDesktopViewModelProxy.getInstance().uninstallApp(item.bundleName,
            item.isUninstallAble as boolean, item.appIndex, true, showToast);
        } else if (item.appIndex && item.appIndex > 0) {
          AppModel.getInstance().appItemRemove(item.bundleName, item.appIndex);
        } else {
          AppInstallUtils.getInstance().cancelTask(item.bundleName);
        }
      }
    });
  }

  private doRemoveOuter(toRemoveItems: GridLayoutItemInfo[]) {
    let deleteAppNames: ArrayList<string> = new ArrayList<string>();
    toRemoveItems.forEach((item: GridLayoutItemInfo, index: number) => {
      if (item.typeId === CommonConstants.TYPE_CARD) {
        this.desktopContext.eventHub.emit('formItemDraggedRemoved', item.cardId);
      }
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_OUTER_DELETE_SHORTCUT, item as AppItemInfo);
        HiSysEventUtil.reportDeleteShortcutMenu(item.bundleName, item.appName);
      }
      if (item.typeId === CommonConstants.TYPE_APP) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_OUTER_DELETE_APP_INFO, item);
        deleteAppNames.add(item.bundleName);
      }
      this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + item.keyName, false);
    });
    this.reportDeleteAppListEvent(deleteAppNames);
  }

  private doRemove(toRemoveItems: GridLayoutItemInfo[]) {
    log.showInfo(`batchUninstall>>> doRemove ${toRemoveItems.length}`);
    if (toRemoveItems.length === 1 && toRemoveItems[0].typeId === CommonConstants.TYPE_CARD) {
      GlobalContext.getContext()?.eventHub.emit('formItemDraggedRemoved', toRemoveItems[0].cardId);
      return;
    }
    toRemoveItems = toRemoveItems.filter(item => {
      if (item.typeId === CommonConstants.TYPE_APP && item.appStatus !== AppStatus.INSTALLED) {
        AppInstallUtils.getInstance().cancelTask(item.bundleName);
        return false;
      }
      return true;
    });
    localEventManager.sendLocalEventSticky(
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_REMOVE_BATCH,
      toRemoveItems as DeleteItemType[]
    );
  }

  private reportDeleteAppListEvent(deleteAppNames: ArrayList<string>): void {
    let params: EditModeUninstallParams = {
      TYPE: HiEditModeDataUninstallType.UNINSTALL_OPERATION_MULTI,
      APP_TYPE: HiEditModeDataUninstallObjType.UNINSTALL_OBJECT_APP,
      APP_INFO: deleteAppNames.convertToArray()?.toString()
    };
    HiEditModeEventUtils.reportEditModeConfirmUninstall(params);
  }

  private onDragChange(): void {
    log.showInfo(`this.isDrag = ${this.isDrag}}`);
    if (this.isDrag) {
      viewMgrPolicy.hideView(ViewType.GESTURE_TOP_BAR);
    } else {
      // 恢复热区
      this.leftHotAreaSize = 0;
      this.bottomHotAreaSize = 0;
      viewMgrPolicy.showView(ViewType.GESTURE_TOP_BAR);
      // 不在热区落位，结束卸载责任链
      if (batchUninstallChain.currentType < ForwardType.DRAG_DROP) {
        if (this.hasEnterHotArea) {
          editModeViewManager.refreshDragItemColor(false);
          this.onDragLeaveButtonHotArea();
        }
        batchUninstallChain.forward(ForwardType.DRAG_END);
        this.hideEditModeTopBar();
      }
    }
  }

  private isOuterLock(): boolean {
    if (!layoutLockUtil.isLocked() || !this.isOuter) {
      return false;
    }
    let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    if (Array.isArray(this.pageDesktopDragItemInfo)) {
      dragItem = this.pageDesktopDragItemInfo[0];
    } else {
      dragItem = this.pageDesktopDragItemInfo;
    }
    let curPage: number | undefined = dragItem?.page;
    return layoutLockUtil.isLockedPage(curPage, 'show deleteIcon by drag', true);
  }

  onAppItemDragged() {
    // 拖拽对象列表赋值
    let tmpDragItemList: GridLayoutItemInfo[] = [];
    if (Array.isArray(this.pageDesktopDragItemInfo) && this.pageDesktopDragItemInfo.length > 0) {
      tmpDragItemList = this.pageDesktopDragItemInfo as GridLayoutItemInfo[];
      if (!CheckEmptyUtils.isEmptyArr(this.pageDesktopDragItemInfo)) {
        this.autoAlignArr = tmpDragItemList;
      }
    } else {
      let typeArr: number[] = [CommonConstants.TYPE_APP, CommonConstants.TYPE_CARD, CommonConstants.TYPE_SHORTCUT_ICON];
      let tmpItem: GridLayoutItemInfo = this.pageDesktopDragItemInfo as GridLayoutItemInfo;
      if (GridLayoutUtil.isOneMultiplyOneItem(tmpItem)) {
        this.autoAlignArr = [tmpItem];
      }
      if (tmpItem.bundleName && tmpItem.typeId != null && typeArr.indexOf(tmpItem.typeId) >= 0) {
        tmpDragItemList.push(this.pageDesktopDragItemInfo as GridLayoutItemInfo);
      }
    }
    if (tmpDragItemList.length === 0) {
      return;
    }
    if (tmpDragItemList.length > 0) {
      this.dragItemList = tmpDragItemList;
      // 恢复dragToUninstallItemInfo属性，修改文件夹内图标展示问题
      if (tmpDragItemList.length === 1) {
        this.dragToUninstallItemInfo = tmpDragItemList[0];
      } else if (tmpDragItemList.length > 1) {
        this.dragToUninstallItemInfo = new GridLayoutItemInfo();
      }
    }
    let exists = batchUninstallChain.existsUninstallable || batchUninstallChain.existsRemovable;
    if (!exists) {
      this.hideEditModeTopBar();
      return;
    }
    this.isDragCardItem = batchUninstallChain.canAllDirectlyRemove;
    log.showInfo(`delete scene, isDragCardItem: ${this.isDragCardItem}`);
    this.shouldShowDeleteIcon = true;
    this.updateDragStatus(DragStatus.DRAGING);
  }

  private hideEditModeTopBar(): void {
    this.shouldShowDeleteIcon = false;
    log.showInfo(`dragItem is null, lastStatus: ${this.lastDragStatus}, dragStatus: ${this.dragStatus},' +
    'hasEnterHotArea: ${this.hasEnterHotArea}`);
    if (!this.hasEnterHotArea) {
      this.updateDragStatus(DragStatus.NO_DRAG);
    }
  }

  private initLottie(): void {
    this.getLottiData(EditModeStyleConstants.LOTTIE_UNINSTALL_OPEN);
    this.getLottiData(EditModeStyleConstants.LOTTIE_UNINSTALL_CLOSE);
    this.getLottiData(EditModeStyleConstants.LOTTIE_UNINSTALL_CLOSE_TO_OK);
    this.getLottiData(EditModeStyleConstants.LOTTIE_REMOVE_TO_OK);
  }

  private async getLottiData(fileName: string): Promise<void> {
    await this.loadLottieResource(fileName).then((value: Object) => {
      this.lottieFilePool[fileName] = value;
    });
  }

  private async loadLottieResource(name: string): Promise<Object> {
    return new Promise<Object>((resolve, reject) => {
      try {
        this.desktopContext.resourceManager?.getRawFileContent(name).then((value: Uint8Array) => {
          log.showInfo(`get lottie raw file success: ${name}`);
          const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
          const retStr = textDecoder.decodeWithStream(value, { stream: false });
          resolve(JSON.parse(retStr));
        }).catch((error: BusinessError.BusinessError) => {
          log.showError(`get lottie raw file content fail: ${name}`);
          reject(null);
        });
      } catch (err) {
        log.showError(`get lottie fail: ${name}`);
        reject(null);
      }
    })
  }

  private reLoadAnimation(lottiePath: string, lottieName: string): void {
    if (!this.isCanvasReady) {
      log.showWarn(`canvas is not ready for ${lottieName}`);
      return;
    }

    this.lottieData = this.lottieFilePool[lottiePath];
    if (CheckEmptyUtils.isEmpty(this.lottieData)) {
      log.showWarn(`lottieData is illegal for ${lottieName}`);
      return;
    }
    if (this.isLottiePlayIng && !CheckEmptyUtils.checkStrIsEmpty(this.lastLottieName)) {
      lottie.destroy(this.lastLottieName);
    }
    lottie.destroy(lottieName);
    this.isLottiePlayIng = true;
    this.lastLottieName = lottieName;
    this.refreshAnimation(lottieName);
  }

  private refreshAnimation(lottieName: string) {
    log.showInfo(`refresh animation: ${lottieName}`);
    this.animateItem = lottie.loadAnimation({
      container: this.context2D,
      renderer: 'canvas',
      loop: false,
      autoplay: true,
      name: lottieName,
      animationData: this.lottieData,
    })

    this.animateItem.addEventListener('complete', (args: Object): void => {
      this.isLottiePlayIng = false;
      log.showInfo(`animation complete for ${lottieName}, shouldShowDeleteIcon: ${this.shouldShowDeleteIcon}`);
      this.resetDragStatus(lottieName, false);
    });
    this.animateItem.addEventListener('destroy', (args: Object): void => {
      log.showInfo(`animation destroy for ${lottieName}, isLottiePlayIng: ${this.isLottiePlayIng}`);
      this.resetDragStatus(lottieName, true);
      this.isLottiePlayIng = false;
    });
  }

  private resetDragStatus(name: string, isDestroy: boolean): void {
    if (isDestroy && !this.isLottiePlayIng) {
      return;
    }
    if (name === ANIMATE_NAME_LEAVE) {
      this.updateDragStatus(this.shouldShowDeleteIcon ? DragStatus.DRAGING : DragStatus.NO_DRAG);
      return;
    }

    if (name === EditModeStyleConstants.LOTTIE_UNINSTALL_CLOSE_TO_OK ||
      name === EditModeStyleConstants.LOTTIE_REMOVE_TO_OK) {
      if (!this.isDrag) {
        this.updateDragStatus(DragStatus.NO_DRAG);
      }
      if (this.isShowingUninstallDialog === UninstallDialogStatus.UNINSTALLING_STATE) {
        this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
      }
    }
  }

  private doDragEnterAnimate(): void {
    let isRemoveBtn: boolean =
      this.isDragCardItem || this.isOuter || batchUninstallChain.currentMode === UninstallMode.DRAWER;
    log.showError(`doDragEnterAnimate isRemoveBtn:${isRemoveBtn}`);
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      this.deleteOKButtonScale = 1.15;
    })

    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      this.bgColor = isRemoveBtn ? EditModeStyleConstants.EDIT_MODE_BUTTON_REMOVE_BG_COLOR :
      EditModeStyleConstants.EDIT_MODE_BUTTON_DELETE_BG_COLOR;
    })

    if (isRemoveBtn) {
      return;
    }
    this.reLoadAnimation(EditModeStyleConstants.LOTTIE_UNINSTALL_OPEN, EditModeStyleConstants.LOTTIE_UNINSTALL_OPEN);
  }

  private doDragLeaveAnimate(): void {
    let isRemoveBtn: boolean =
      this.isDragCardItem || this.isOuter || batchUninstallChain.currentMode === UninstallMode.DRAWER;
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      this.deleteOKButtonScale = 1;
      this.bgColor = this.buttonBgColor;
    })

    if (isRemoveBtn) {
      this.updateDragStatus(DragStatus.DRAGING);
      return;
    }
    this.reLoadAnimation(EditModeStyleConstants.LOTTIE_UNINSTALL_CLOSE, ANIMATE_NAME_LEAVE);
  }

  private doDragDropAnimate(callBack?: () => void): void {
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => {
        if (callBack) {
          callBack();
        }
      }
    }, () => {
      this.deleteOKButtonScale = 1;
    })
  }

  private doCancelAnimate(): void {
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      this.bgColor = this.buttonBgColor;
    })
    this.updateDragStatus(DragStatus.NO_DRAG);
  }

  private doConfirmAnimate(): void {
    let isRemoveBtn: boolean =
      this.isDragCardItem || this.isOuter || batchUninstallChain.currentMode === UninstallMode.DRAWER;
    if (isRemoveBtn) {
      this.removeDoneAnimate();
    } else {
      this.uninstallDoneAnimate();
    }
  }

  private uninstallDoneAnimate(): void {
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      this.bgColor = this.buttonBgColor;
    })

    this.reLoadAnimation(EditModeStyleConstants.LOTTIE_UNINSTALL_CLOSE_TO_OK,
      EditModeStyleConstants.LOTTIE_UNINSTALL_CLOSE_TO_OK);
  }

  private removeDoneAnimate(): void {
    animateTo({
      duration: 300,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      delay: 200,
    }, () => {
      this.bgColor = this.buttonBgColor;
    })

    this.reLoadAnimation(EditModeStyleConstants.LOTTIE_REMOVE_TO_OK, EditModeStyleConstants.LOTTIE_REMOVE_TO_OK);
  }

  private registerFoldChangeListener(): void {
    try {
      if (!DeviceHelper.isFoldButNotSmallFoldProduct()) {
        return;
      }
      this.isFoldablePhoneExpandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      display.on('foldStatusChange', this.folderStatusChangeCallback);
    } catch (error) {
      log.showError(`register fold change listener failed: ${error?.code}`);
    }
  }

  private unRegisterFoldChangeListener(): void {
    try {
      if (!DeviceHelper.isFoldButNotSmallFoldProduct()) {
        return;
      }
      display.off('foldStatusChange', this.folderStatusChangeCallback);
    } catch (error) {
      log.showError(`unRegister fold change listener failed: ${error?.code}`);
    }
  }

  private onScreenPropertyChange: () => void = () => {
    this.updateLayoutInfo();
  }

  private registerScreenPropertyChange(): void {
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.onScreenPropertyChange, undefined, false);
  }

  private unRegisterScreenPropertyChange(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.onScreenPropertyChange, undefined, false);
  }

  private registerDragItemStartEvent(listener: Object): void {
    localEventManager.registerEventListener(
      listener,
      [
        EventConstants.EVENT_EDIT_MODE_START_DRAG_ITEM,
        EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE
      ]
    );
  }

  private unRegisterDragItemStartEvent(listener: Object): void {
    localEventManager.unregisterEventListener(listener);
  }

  private notifyDeskTopRefresh(): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FALL_BOX_HIDE, TAG + ' notifyDeskTopRefresh');
  }

  private recoverFolderItems(folderItems: GridLayoutItemInfo[]) {
    log.showInfo('batchUninstall>>> recoverFolderItems size: %{public}d', folderItems.length);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_BATCH_UPDATE_ITEM_POSITION, folderItems);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  private onDesktopModeChange(): void {
    log.showInfo(`onDesktopModeChange ${editModeManager.isInEditMode()}`);
    if (!editModeManager.isInEditMode()) {
      this.uninstallDialogController.close();
      this.hasEnterHotArea = false;
      // 在弹出卸载提示框或者在拖拽过程中时锁屏退出编辑模式时，需要恢复应用，逻辑同取消卸载
      if (this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE || this.isDrag) {
        log.showInfo('dialog is showing, notify white box show');
        this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON, 'cancelDelete');
        editModeViewManager.notifyWhiteBoxShowOrHide(true);
        editModeManager.setIsShowingUninstallDialog(false);
        batchUninstallChain.forward(ForwardType.CANCEL_REMOVE);
      }
      this.isShowingUninstallDialog = UninstallDialogStatus.INITIAL_STATE;
      this.notifyDeskTopRefresh();
      FolderImageRegister.getInstance().notifyImageRefresh();
      this.isLottiePlayIng = false;
      this.lastDragStatus = DragStatus.NO_DRAG;
      this.dragStatus = DragStatus.NO_DRAG;
      this.bgColor = this.buttonBgColor;
    }
  }

  private updateButtonBgColor(): void {
    this.buttonBgColor = NORMAL_COLOR;
    const isLightWallpaper =
      WallpaperColorManager.getInstance().isLightWallpaper(launcherStatusUtil.getShowOutLauncherStatus());
    let darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
    log.showInfo(`isLightWallpaper = ${isLightWallpaper}, isDarkMode = ${darkModeState.isDarkMode}`);
    if (isLightWallpaper) {
      this.buttonBgColor = LIGHT_COLOR;
    } else if (darkModeState.isDarkMode) {
      this.buttonBgColor = $r('sys.color.ohos_id_color_background_dark');
    }
    this.bgColor = this.buttonBgColor;
  }

  private updateLayoutInfo(): void {
    try {
      let defaultDisplay: display.Display = display.getDefaultDisplaySync();
      defaultDisplay.getCutoutInfo((err, data) => {
        const errCode: number = err?.code;
        if (errCode) {
          log.showError(`Failed to get cutoutInfo. Code: ${errCode}`);
          return;
        }

        log.showInfo('rect length=' + data?.boundingRects.length);
        this.updateMargin(data?.boundingRects, defaultDisplay);
      });
    } catch (exception) {
      log.showError('Failed to obtain the default display object.');
    }
  }

  private updateMargin(boundRects: Array<display.Rect>, display: display.Display): void {
    if (ArrayUtils.isEmpty(boundRects)) {
      // 获取不到挖孔信息，使用默认值
      log.showWarn('The boundRects is empty.');
      this.resetMargin();
      return;
    }

    let rect: display.Rect = boundRects[0];
    log.showInfo('updateMargin left:%{public}d, top:%{public}d, width:%{public}d, height:%{public}d',
      rect.left, rect.top, rect.width, rect.height);
    if (this.isTrackScreen(rect, display)) {
      // 跑道屏，如P40Pro, P30, Mate40Pro
      this.marginTop = Math.max(px2vp(rect.top), StyleConstants.DEFAULT_32);
      this.paddingLeft = px2vp(rect.left + rect.width) + StyleConstants.DEFAULT_16;
      this.updateDeleteIconBottom();
    } else if (this.isCameraInUpperLeftCorner(rect, display)) {
      // 挖孔在左上角
      this.paddingLeft = (px2vp(rect.left + rect.width) + StyleConstants.DEFAULT_16);
      this.paddingRight = StyleConstants.DEFAULT_24;
    } else if (this.isCameraInUpperRightCorner(rect, display)) {
      // 挖孔在右上角
      this.paddingLeft = StyleConstants.DEFAULT_24;
      this.paddingRight = px2vp(display.width - rect.left) + StyleConstants.DEFAULT_16;
    } else {
      // 其他场景（挖孔在中间、刘海屏等）使用默认值
      this.resetMargin();
    }
  }

  private isTrackScreen(rect: display.Rect, display: display.Display): boolean {
    return rect.top !== 0 && rect.height !== 0 &&
      rect.left < display.width / 4 && rect.width / rect.height >= 2;
  }

  private isCameraInUpperLeftCorner(rect: display.Rect, display: display.Display): boolean {
    return rect.left < display.width / 4 && rect.top < display.height / 4;
  }

  private isCameraInUpperRightCorner(rect: display.Rect, display: display.Display): boolean {
    return rect.top !== 0 && rect.left > display.width * 3 / 4 &&
      rect.top < display.height / 4;
  }

  private resetMargin(): void {
    this.paddingRight =
      this.isOuter ? StyleConstants.DEFAULT_32 : this.editModeStyleConfig.pageEditRemoveBarPaddingRight;
    this.paddingLeft = this.editModeStyleConfig.pageEditRemoveBarPaddingLeft;
    this.marginTop =
      this.isOuter ? StyleConstants.DEFAULT_32 : (this.editModeStyleConfig.pageEditRemoveBarMarginTop + StyleConstants.DEFAULT_16);
    this.updateDeleteIconBottom();
  }

  private updateDeleteIconBottom(): void {
    this.deleteIconBottom = this.marginTop +
      (this.isOuter ? StyleConstants.DEFAULT_24 : StyleConstants.DEFAULT_32) +
      (this.dragStatus === DragStatus.NO_DRAG ? 0 : this.bottomHotAreaSize);
  }

  private sendEvent(event?: DragEvent, extraParams?: string, ifSkipAnimationInEditMode?: boolean): void {
    this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_COMPONENT_DROP,
      event, extraParams, ifSkipAnimationInEditMode);
  }

  private reportUninstallEvent(isToUninstallEvent: boolean, isConfirm?: boolean): void {
    if (!this.dragItemList || this.dragItemList.length == 0) {
      log.showInfo('Empty uninstall list, no need to report.');
      return;
    }
    let bundleNameList: string[] = [];
    this.dragItemList.forEach(item => {
      bundleNameList.push(item.bundleName);
    });
    let params: EditModeUninstallParams = {
      TYPE: this.dragItemList.length > 1 ? HiEditModeDataUninstallType.UNINSTALL_OPERATION_MULTI :
      HiEditModeDataUninstallType.UNINSTALL_OPERATION_SINGLE,
      APP_TYPE: this.isUninstallApp ?
      HiEditModeDataUninstallObjType.UNINSTALL_OBJECT_APP : HiEditModeDataUninstallObjType.UNINSTALL_OBJECT_CARD,
      APP_INFO: bundleNameList.toString()
    };
    if (isToUninstallEvent) {
      HiEditModeEventUtils.reportEditModeToUninstall(params);
    } else if (!CheckEmptyUtils.isEmpty(isConfirm) && isConfirm) {
      HiEditModeEventUtils.reportEditModeConfirmUninstall(params);
    } else if (!CheckEmptyUtils.isEmpty(isConfirm) && !isConfirm) {
      HiEditModeEventUtils.reportEditModeCancelUninstall(params);
    } else {
      log.showWarn(`Report uninstall event failed, params is invalid: isToUninstallEvent ${isToUninstallEvent}, isConfirm: ${isConfirm}`);
    }
  }

  private reportRemoveEvent(): void {
    if (!this.dragItemList || this.dragItemList.length == 0) {
      log.showInfo('Empty remove list, no need to report.');
      return;
    }
    let bundleNameList: string[] = [];
    this.dragItemList.forEach(item => {
      bundleNameList.push(item.bundleName);
    });
    let params: EditModeRemoveParams = {
      TYPE: this.dragItemList.length > 1 ? HiEditModeDataUninstallType.UNINSTALL_OPERATION_MULTI :
      HiEditModeDataUninstallType.UNINSTALL_OPERATION_SINGLE,
      APP_INFO: bundleNameList.toString()
    };
  }

  private reportDialogEvent(): void {
    if (!this.dragItemList || this.dragItemList.length == 0) {
      log.showInfo('Empty remove list, no need to report.');
      return;
    }
    let bundleNameList: string[] = [];
    let notUninstallableNameList: string[] = [];
    this.dragItemList.forEach(item => {
      bundleNameList.push(item.bundleName);
      if (!batchUninstallChain.isUninstallable(item)) {
        notUninstallableNameList.push(item.bundleName);
      }
    });
    let params: EditModeUninstallDialogParams = {
      TYPE: this.dragItemList.length > 1 ? HiEditModeDataUninstallType.UNINSTALL_OPERATION_MULTI :
      HiEditModeDataUninstallType.UNINSTALL_OPERATION_SINGLE,
      APP_INFO: bundleNameList.toString(),
      NOT_UNINSTALLABLE_INFO: notUninstallableNameList.toString()
    };
    HiEditModeEventUtils.reportEditModeUninstallDialog(params);
  }

  private updateDragStatus(newStatus: number): void {
    this.lastDragStatus = this.dragStatus;
    this.dragStatus = newStatus;
  }

  private isUninstallAbleScene(): boolean {
    return this.isDragCardItem || this.shouldShowDeleteIcon || this.isOuter;
  }

  private isDeleteIconShown(): boolean {
    if (this.shouldShowDeleteIcon) {
      return true;
    }
    let isRemoveBtn: boolean =
      this.isDragCardItem || this.isOuter || batchUninstallChain.currentMode === UninstallMode.DRAWER;
    if (isRemoveBtn) {
      return this.outerShowEditModeTopBar &&
        (this.dragStatus >= DragStatus.DRAGING && this.dragStatus < DragStatus.DRAG_DROP) ||
        (this.dragStatus === DragStatus.DRAG_DROP && !this.isLottiePlayIng);
    }

    return this.dragStatus === DragStatus.DRAGING;
  }

  private isCanvasShown(): boolean {
    if (this.isDragCardItem) {
      return this.dragStatus === DragStatus.DRAG_DROP && this.isLottiePlayIng;
    }

    return this.dragStatus > DragStatus.DRAGING;
  }

  private getOpacityTransitionEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: 250, curve: Curve.Sharp, delay: 100 }),
      TransitionEffect.OPACITY.animation({ duration: 250, curve: Curve.Sharp })
    );
  }

  private refreshStateOnDrop(): void {
    this.updateDragStatus(DragStatus.DRAG_DROP);
    this.reportUninstallEvent(true);
    this.notifyDeskTopRefresh();
    batchUninstallChain.forward(ForwardType.DRAG_DROP);
    if (this.isOuter || batchUninstallChain.canAllDirectlyRemove) {
      this.doDragDropAnimate(() => {
        this.confirmRemove()
      });
    } else if (batchUninstallChain.dialogConfig) {
      log.showInfo(`showBatchUninstallDialog true`);
      if (batchUninstallChain.currentMode === UninstallMode.NORMAL) {
        this.reportDialogEvent();
      }
      this.removeDialogConfig = batchUninstallChain.dialogConfig;
      this.isShowingUninstallDialog = UninstallDialogStatus.CONFIRM_STATE;
      editModeManager.setIsShowingUninstallDialog(true);
      this.uninstallDialogController.open();
      this.doDragDropAnimate();
    }
  }

  private onActive(): void {
    if (editModeManager.isInEditMode()) {
      animateTo({
        curve: curves.springMotion(0.3, 1.157, 0)
      }, () => {
        this.deleteOKButtonScale = 0.88;
        this.addButtonScale = 0.88;
      })
    }
  }

  private onInactive(): void {
    if (editModeManager.isInEditMode()) {
      animateTo({
        curve: curves.springMotion(0.55, 0.825, 0)
      }, () => {
        this.deleteOKButtonScale = 1.0;
        this.addButtonScale = 1.0;
      })
    }
  }

  private doFollowAnimate(scale: number): void {
    if (!editModeManager.isInEditMode()) {
      return;
    }
    animateTo({
      curve: curves.springMotion(0.15, 0.86, 0.25)
    }, () => {
      this.deleteOKButtonScale = scale;
      this.addButtonScale = scale;
    })
  }

  private doBackHomeAnimate(scale: number): void {
    if (!editModeManager.isInEditMode()) {
      return;
    }
    animateTo({
      curve: curves.springMotion(0.55, 0.99, 0.25)
    }, () => {
      this.deleteOKButtonScale = scale;
      this.addButtonScale = scale;
    })
  }

  /**
   * 屏幕朗读主动播报
   */
  private announceForDelete(): void {
    if (this.isAccessibilityMode) {
      const accessibilityManager = AccessibilityManager.getInstance();
      if (this.isDragCardItem) {
        accessibilityManager.sendTextAnnouncedForAccessibility(ResUtils.getInnerString($r('app.string.delete_app')),
          'announceForRemoveForm');
      } else {
        accessibilityManager.sendTextAnnouncedForAccessibility(ResUtils.getInnerString($r('app.string.uninstall')),
          'announceForUninstallApp');
      }
    }
  }

  /**
   * 获取热区padding
   */
  private getHotAreaPadding(): Padding {
    let padding: Padding = {
      // 防止拖拽热区遮挡桌面布局
      left: this.dragStatus === DragStatus.NO_DRAG ? 0 : Math.min(this.deleteIconLeft, this.leftHotAreaSize),
      bottom: this.dragStatus === DragStatus.NO_DRAG ? 0 : this.bottomHotAreaSize,
      right: this.paddingRight,
      top: this.marginTop
    };
    if (RTLUtil.isRTL()) {
      padding.left = this.paddingLeft;
      padding.right = this.dragStatus === DragStatus.NO_DRAG ? 0 : this.leftHotAreaSize;
    }
    return padding;
  }

  @Styles
  dragStyles() {
    .onDrop((event?: DragEvent, extraParams?: string) => {
      this.onDropMethod(event, extraParams);
    })
    .onDragEnter((event?: DragEvent, extraParams?: string) => {
      if (this.isUninstallAbleScene()) {
        log.info(TAG, 'onDragEnter occurs');
        let isRemoveBtn = this.isDragCardItem || batchUninstallChain.currentMode === UninstallMode.DRAWER;
        editModeViewManager.refreshDragItemColor(true, isRemoveBtn);
        this.onDragEnterButtonHotArea();
      }
    })
    .onDragLeave((event?: DragEvent, extraParams?: string) => {
      if (!this.isUninstallAbleScene()) {
        return;
      }
      log.info(TAG, 'onDragLeave occurs');
      editModeViewManager.refreshDragItemColor(false);
      this.onDragLeaveButtonHotArea();
      this.desktopContext?.eventHub.emit(CommonConstants.GRID_SWIPER_DELEGATE_TO_MOVE, event, extraParams);
    })
  }

  @Builder
  deleteOKLayoutBuilder() {
    Column() {
      Stack() {
        this.deleteOKButtonBuilder();
      }
      .padding(this.getHotAreaPadding())
      .dragStyles()
    }
    .width(StyleConstants.PERCENTAGE_100)
    .alignItems(HorizontalAlign.End)
  }

  private onDropMethod(event?: DragEvent, extraParams?: string) {
    performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
    TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    log.showInfo('onDrop event occurs.');
    if (!this.isUninstallAbleScene()) {
      log.showInfo('isUninstallAbleScene.');
      this.sendEvent(event, extraParams, false);
      return;
    }
    this.onDropInButtonHotArea();
    this.dealSqueezingLogic(event?.getWindowX(), event?.getWindowY());
    this.desktopContext.eventHub.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE_BUTTON, 'drop');
    log.showInfo('onDrop event finished.');
  }

  @Builder
  uninstallAppComponentBuilder() {
    if (this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE && this.removeDialogConfig) {
      BatchUnInstallAppComponent({
        dialogConfig: this.removeDialogConfig,
        isUninstallApp: this.isUninstallApp,
        upArrowCenterX: this.deleteIconCenterX,
        offsetY: StyleConstants.DEFAULT_40 + this.marginTop,
        dropX: this.dropX,
        dropY: this.dropY,
        isUsedForAnimation: true,
        isShowRemoveDialog: this.isShowRemoveDialog,
        singleContext: this.singleContext
      })
    }
  }

  @Builder
  deleteOKButtonBuilder() {
    Button({ type: ButtonType.Normal, stateEffect: true }) {
      Stack() {
        Stack() {
          Image(this.isOuter || this.isDragCardItem || batchUninstallChain.currentMode === UninstallMode.DRAWER ?
          $rawfile('pics/ic_public_remove.svg') : $rawfile('pics/ic_public_delete.svg'))
            .draggable(false)
            .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
            .id(`${TAG}_Image_editModeDelete`)
            .size({
              width: this.isOuter ? StyleConstants.DEFAULT_16 :
              this.editModeStyleConfig.pageEditRemoveBarButtonIconSize,
              height: this.isOuter ? StyleConstants.DEFAULT_16 :
              this.editModeStyleConfig.pageEditRemoveBarButtonIconSize
            })
            .visibility(this.isDeleteIconShown() && !this.isCanvasShown() ? Visibility.Visible : Visibility.Hidden)
          this.lottieEditModeDelete()
        }
        .transition(this.getOpacityTransitionEffect())
      }
    }
    .id(`${TAG}_Button_editMode`)
    .backgroundColor(this.bgColor)
    .hoverEffect(HoverEffect.None)
    .height(this.isOuter ? StyleConstants.DEFAULT_24 : this.editModeStyleConfig.pageEditRemoveBarButtonHeight)
    .width(this.isOuter ? StyleConstants.DEFAULT_48 : this.editModeStyleConfig.pageEditRemoveBarButtonWidth)
    .visibility((this.isCanvasShown() || this.isDeleteIconShown()) ? Visibility.Visible : Visibility.Hidden)
    .borderRadius(this.editModeStyleConfig.pageEditRemoveBarBorderRadius)
    .scale({
      x: this.deleteOKButtonScale,
      y: this.deleteOKButtonScale
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.deleteIconLeft = Number(newValue.globalPosition.x);
      this.deleteIconCenterX = vp2px(Number(newValue.globalPosition.x) + Number(newValue.width) / 2);
      this.deleteIconRight = Number(newValue.width) + this.deleteIconLeft;
    })
  }

  @Builder
  lottieEditModeDelete() {
    Canvas(this.context2D)
      .draggable(false)
      .size({
        width: StyleConstants.DEFAULT_32,
        height: StyleConstants.DEFAULT_32
      })
      .onAppear(() => {
        log.showInfo('lottie, Canvas onAppear');
        this.isCanvasReady = true;
      })
      .onDisAppear(() => {
        log.showInfo('lottie, Canvas onDisAppear');
        this.isCanvasReady = false;
        if (!CheckEmptyUtils.checkStrIsEmpty(this.lastLottieName)) {
          lottie.destroy(this.lastLottieName);
        }
      })
      .visibility(this.isCanvasShown() ? Visibility.Visible : Visibility.Hidden)
      .id(`${TAG}_Image_editModeDeleteCanvas`)
  }

  private async dealSqueezingLogic(x?: number, y?: number): Promise<void> {
    const dragProxy: IDesktopDragHandler = DragProxyManager.getInstance()
      .get(TAG, DragHandlerType.DESKTOP) as IDesktopDragHandler;
    dragProxy.onDragLeave(x ?? 0, y ?? 0);
    let isCard: boolean = batchUninstallChain.canAllDirectlyRemove ?? false;
    if (this.isOuter) {
      this.isRemoveOuterApp = !isCard;
    } else {
      this.isUninstallApp = !isCard;
    }
    this.refreshStateOnDrop();
  }

  build() {
    if (this.editModeViewState.isShowEditModeView() && (this.isCanvasShown() || this.isDeleteIconShown() ||
      this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE)) {
      Stack() {
        this.deleteOKLayoutBuilder();
      }
      .id('EditModeTopBar_stack')
      .zIndex(1)
      .position({ x: 0, y: 0 })
      .width(StyleConstants.PERCENTAGE_100)
      .opacity(this.topBarOpacity.value)
      .alignContent(Alignment.TopStart)
      .transition(this.getOpacityTransitionEffect())
      .scale({
        x: this.addButtonScale,
        y: this.addButtonScale,
        centerX: StyleConstants.PERCENTAGE_50,
        centerY: this.screenHeight / 2
      })
    }
  }
}