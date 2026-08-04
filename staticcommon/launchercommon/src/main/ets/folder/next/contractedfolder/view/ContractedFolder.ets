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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { StateEx } from '@ohos/componenthelper';
import { RTLUtil, SCBVisualEffectMgr, SnapshotType } from '@ohos/componenthelper/src/main/ets/TsIndex';
import {
  launcherStatusUtil,
  SCBAppExitToFolderController,
  SCBTransitionManager
} from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  AppIconCommonView,
  AppMenu,
  CustomBadge,
  DeskTopItemStyle,
  nameAppearAnimate
} from '../../../../../../../Index';
import { CommonConstants, DeviceState, FolderActionFlag } from '../../../../constants/CommonConstants';
import { CheckboxParentEnum, BooleanState } from '../../../../editmode/data/MultiSelectData';
import { editModeManager } from '../../../../editmode/model/EditModeManager';
import { MultiSelectManager } from '../../../../editmode/model/MultiSelectManager';
import EditModeFolderBackground from '../../../../editmode/view/EditModeFolderBackground';
import { MultiSelectCheckboxView } from '../../../../editmode/view/MultiSelectCheckboxView';
import { AppIconData } from '../../../../launchericon/viewmodel/AppIconData';
import { DesktopManager } from '../../../../manager/DesktopManager';
import {
  AppItemInfo,
  FolderAppItemInfo,
  FolderCommonUtil,
  folderLayoutUtil,
  FolderModel,
  FolderOperationFlag,
  FolderStyleManager,
  GridLayoutItemInfo,
  IContractedFolderAppEventViewModel,
  IContractedFolderDownloadViewModel,
  IContractedFolderDragViewModel,
  IContractedFolderEventViewModel,
  IContractedFolderRenameViewModel,
  StyleConstants,
} from '../../../../TsIndex';
import { AppName } from '../../../../uicomponents/AppName';
import { BadgeAnimationType } from '../../../../uicomponents/CustomBadge';
import { layoutLockUtil } from '../../../../utils/LayoutLockUtil';
import { LayoutViewModel } from '../../../../viewmodel/LayoutViewModel';
import { ResizePosition } from '../../../common/FolderResizeConstants';
import { SmallFolderConstants } from '../../../common/SmallFolderConstants';
import { FolderIconConfigUtil } from '../../../model/FolderIconConfigUtil';
import { FolderAccessibilityUtil } from '../../common/FolderAccessibilityUtil';
import {
  FolderClickType,
  FolderCommonConstants,
  MenuDataOption,
  OBSERVER_SWITCH
} from '../../common/FolderCommonConstant';
import { FolderSnapshotManager } from '../../common/manager/FolderSnapshotManager';
import { FolderResourceUtil } from '../../common/util/FolderResourceUtil';
import { ContractedFolderDataObserver } from '../viewmodel/layout/ContractedFolderDataObserver';
import { ContractedFolderLayoutViewModel } from '../viewmodel/layout/ContractedFolderLayoutViewModel';
import { ContractedFolderViewObserver } from '../viewmodel/layout/ContractedFolderViewObserver';
import { ContractedFolderMode } from '../viewmodel/layout/IContractedFolderObserver';
import { FolderResizeUtil } from '../viewmodel/layout/resize/FolderResizeUtil';
import { ContractedFolderLayoutStyle } from '../viewmodel/layout/style/ContractedFolderLayoutStyleFactory';
import {
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType
} from '../viewmodel/manager/ContractedFolderViewModelManager';
import { IContractedFolderLongPressViewModel } from '../viewmodel/manager/IContractedFolderLongPressViewModel';
import { IContractedFolderOpenCloseViewModel } from '../viewmodel/manager/IContractedFolderOpenCloseViewModel';
import { ContractedFolderEmptyItem } from './ContractedFolderEmptyItem';
import { ContractedFolderItem } from './ContractedFolderItem';
import { DeliverUtil } from '../../../../utils/DeliverUtil';
import { DeliveryFolderItem } from './DeliveryFolderItem';
import { AppIconConfig } from '../../../../launchericon/config/AppIconConfig';
import { FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus } from '../../common/viewmodel/lifecycle/FolderActionLifeCycleEventManager';

const TAG = 'ContractedFolder';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠态统一文件夹组件，支持大小文件夹静态、大小文件夹转换、小文件夹截图
 */
@Component
export struct ContractedFolder {
  @StorageLink('dragItemInfo') @Watch('dragItemInfoChange') dragItemInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') mIsPortrait: boolean = true;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('foldStatusForOuterScreen') @Watch('foldStatusChangeForOuterScreen') foldStatusForOuterScreen: number =
    DeviceState.DEFAULT_STATE;
  @StorageProp('isAccessibilityMode') @Watch('onAccessibilityModeChange') isAccessibilityMode: boolean = false;
  @StorageLink('currColorMode') @Watch('notifySmallFolderUpdate') currColorMode: number =
    SmallFolderConstants.LIGHT_COLOR_MODE;
  @StorageProp('desktopIconChange') @Watch('refreshFolderIcon') desktopIconChange: number = 0;
  @StorageProp('accessibility_dock') accessibilityDock: string = '';
  @StorageLink('showDesktopBadges') showDesktopBadges: boolean = true;

  @Consume translateX: number;
  @Consume translateY: number;
  @Consume @Watch('isEqualToDragItemChange') isDragStart: boolean;
  @Consume @Watch('isInDragChange') isInDrag: boolean;

  // 解锁、展开、旋转、拖拽挤位、引力动效, 待这些场景整改后同步去掉状态变量更新方式
  @ObjectLink @Watch('desktopStyleUpdate') desktopStyle: DeskTopItemStyle | undefined;

  /* 文件夹布局的observer */
  @State private layoutOsr: ContractedFolderViewObserver = new ContractedFolderViewObserver();
  /* 文件夹数据的observer */
  @State private dataOsr: ContractedFolderDataObserver = new ContractedFolderDataObserver();
  /* 文件夹动效节点的状态变量 */
  @State private fstIconData: AppIconData = new AppIconData();
  /* 文件夹动效节点的状态变量，用于同一个文件夹，两个动效节点同时执行动效场景 */
  @State private sndIconData: AppIconData = new AppIconData();
  @State private mProgress: ProgressMask | null = null;
  @State private firstPageIconEffect: TransitionEffect = TransitionEffect.IDENTITY;
  @State private endPageIconEffect: TransitionEffect = TransitionEffect.IDENTITY;
  @State isFolderExtraBackGroundShow: StateEx<boolean> =
    editModeManager.getEditModeFolderViewData().isFolderExtraBackGroundShow;
  @State iconSize: number = 0;
  @State iconRadius: number = 0;
  @State multiSelectState: BooleanState = MultiSelectManager.getInstance().getStatus().getEnteredState();
  @Prop @Watch('scaleChange') zoomScale: number = 1;

  /* 布局样式 */
  private style: ContractedFolderLayoutStyle = new ContractedFolderLayoutStyle();
  /* 使用id替代item，view层的组件也不应该直接持有model数据，下移到view model */
  private folderId: string = '';
  /* 起透传作用的变量 */
  private getIndexInSwiper: Function = (): number => 0;
  private isSelect: boolean = false;
  private isEnableName: boolean = true;
  private dragStart?: (event: DragEvent) => DragItemInfo;
  private isSolidColor: boolean = SCBVisualEffectMgr.isFolderSolidColor();
  /* viewModel */
  private folderSnapshotManager: FolderSnapshotManager = FolderSnapshotManager.getInstance();
  private layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
  private openCloser: IContractedFolderOpenCloseViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.OPEN_CLOSE) as IContractedFolderOpenCloseViewModel;
  private renameVm: IContractedFolderRenameViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.RENAME) as IContractedFolderRenameViewModel;
  private longPresser: IContractedFolderLongPressViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.LONG_PRESS) as IContractedFolderLongPressViewModel;
  private dragVm: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
  private eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
  private downloadVm: IContractedFolderDownloadViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.DOWNLOAD) as IContractedFolderDownloadViewModel;
  private appEvtVm: IContractedFolderAppEventViewModel = ContractedFolderViewModelManager.getInstance()
    .get(ContractedFolderViewModelType.APP_EVENT) as IContractedFolderAppEventViewModel;
  private isFirstShow: boolean = true;
  private registerRtlChangeCallback = () => this.rtlChange();
  private mController?: SCBAppExitToFolderController;
  private singleHandChange: () => void = () => this.folderStatusChange();
  private isInDock: boolean = false;
  private isFirstTransition: boolean = true;
  private processTotalSize: number = 0;

  aboutToAppear(): void {
    log.showInfo(`create contracted folder(${this.folderId}) isEnableName:${this.isEnableName}`);
    this.layoutVm.checkAndModifyFolder(this.folderId); // area异常时修复
    this.initConfig();
    // 注册与文件夹id绑定的监听，拖拽触发组件重新创建的等场景不需要再重复注册监听
    if (this.layoutVm.isFolderUnregister(this.folderId)) {
      this.registerByFolderId();
    }
    this.layoutVm.startRegisterByFolderId(this.folderId);
    // 1*1 文件夹触发截图刷新
    if (this.style.isLayout1X1()) {
      FolderSnapshotManager.getInstance().initSnapCache(this.folderId, () => this.folderImageBuilder(false, false),
        () => this.folderImageBuilder(false, true), () => this.folderImageBuilder(true, false));
      // 更新文件夹下载状态
      this.downloadVm.initDownloadState('ContractedFolder aboutToAppear', this.folderId, this.updateProgress);
      this.layoutVm?.execFolderCreateAnimation();
    } else {
      this.mController = this.appEvtVm?.getAppExitController(this.folderId);
    }
    SCBTransitionManager.getInstance().registerAppExitToFolderController(this.mController);
    DesktopManager.getInstance().registerScreenChangeListener(this.singleHandChange);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear contracted folder(${this.folderId}) isEnableName:${this.isEnableName}`);
    // 根据id注册的回调，在取消注册时需要校验是否需要需要取消注册.
    // 针对组件销毁后再创建场景（拖拽文件夹翻页落位）,aboutToAppear与aboutToDisappear时序异常导致新组件的注册被取消
    if (this.layoutVm.isNeedUnRegisterByFolderId(this.folderId)) {
      this.unRegisterByFolderId();
    }
    SCBTransitionManager.getInstance().unRegisterAppExitToFolderController(this.mController);
    DesktopManager.getInstance().unregisterScreenChangeListener(this.singleHandChange);
    this.downloadVm.unregisterEvents(this.folderId, this.updateProgress);
  }

  private initConfig(): void {
    this.dataOsr.register(this.folderId);
    this.initLayoutConfig();
    this.dataOsr.initObserver(this.layoutVm.getFolderDataById(this.folderId), this.style.isLayout1X1());
    this.layoutOsr.editFolderMode = this.layoutVm.isResizeFolder(this.folderId);
    if (this.layoutOsr.editFolderMode) {
      this.dataOsr.setMode('ContractedFolder aboutToAppear', ContractedFolderMode.MODE_COMPONENT);
    }
  }

  private initLayoutConfig(): void {
    this.layoutOsr.register(this.folderId);
    this.style = this.layoutVm.getLayoutStyle(this.folderId);
    this.iconSize = this.style.mFolderAppSize;
    this.iconRadius = this.style.itemIconRadius;
    this.layoutVm.clearViewUpdator(this.folderId);
    this.layoutOsr.initObserver(this.style, this.fstIconData, this.sndIconData, this.isEnableName);
  }

  private notifySmallFolderUpdate(): void {
    // 深、浅模式切换，刷新拖拽截图
    this.folderSnapshotManager.notifySmallFolderUpdate('currColorMode change', this.folderId);
  }

  private refreshFolderIcon(): void {
    this.initLayoutConfig();
    this.folderSnapshotManager.refreshSmallFolderIcon('themeStyle or desktopIconChange change', this.folderId, true);
  }

  private onAccessibilityModeChange(): void {
    if (this.layoutOsr.editFolderMode && this.isAccessibilityMode) {
    }
  }

  private registerByFolderId(): void {
    this.layoutVm.registerFolderCommonListener(this.folderId, this.openCloser);
    this.dragVm?.registerListener('folder drag listener', this.folderId);
  }

  private unRegisterByFolderId(): void {
    this.layoutOsr.release('layout observer about to disappear');
    this.dataOsr.release('data observer about to disappear');
    // 取消监听注册
    this.dragVm?.unregisterListener('folder drag listener', this.folderId);
    this.layoutVm.unregisterFolderCommonListener(this.folderId, this.openCloser);
    FolderSnapshotManager.getInstance().deleteSnapshotBuilder(this.folderId);
    this.dataOsr.folderDataOsr.setFirstPageIcon(null);
    this.dataOsr.folderDataOsr.setCurrentPageIcon(null);
    this.dataOsr.folderDataOsr.setEndPageIcon(null);
  }

  private dragItemInfoChange(): void {
    if (!this.style.isLayout1X1()) {
      return;
    }
    log.showInfo('dragItemInfoChange dragItemInfo: %{public}s', this.dragItemInfo.appName);
    let folderLen: number = this.layoutVm.getFolderDataById(this.folderId).getItems().length;
    let maxPerPage: number = FolderModel.getInstance().getOpenFolderMaxPerPage();
    let hasMorePage: boolean = folderLen >= maxPerPage;
    if (this.layoutOsr.mIsIconAnimating && this.layoutOsr.isShowEndPage && hasMorePage) {
      return;
    }
    let dragLeaveNum = FolderCommonUtil.isKeyNameInFolder(this.folderId, this.dragItemInfo.keyName ?? '') ? 1 : 0;
    hasMorePage = (folderLen - dragLeaveNum) >= maxPerPage;
    let isDragItemInfoEmpty = this.dragItemInfo.keyName === undefined || this.dragItemInfo.keyName === '';
    this.layoutOsr.isShowEndPage = !isDragItemInfoEmpty && (this.dragItemInfo.typeId === CommonConstants.TYPE_APP ||
      this.dragItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) && hasMorePage;
  }

  private updateProgress: (curSize: number, totalSize: number, isNewProgress?: boolean, isReset?: boolean) => void =
    (curSize: number, totalSize: number, isNewProgress?: boolean, isReset?: boolean) => {
    if (totalSize === 0) {
      log.showInfo('updateProgress done');
      this.processTotalSize = 0;
      this.mProgress = null;
      return;
    }
 
    if (this.style.isLayout1X1() && this.layoutOsr.downloadingOpacity > 0 && curSize !== totalSize) {
      // 如果正在下载中, 如果有前面的安装动效需要取消
      FolderActionLifeCycleEventManager.getInstance().notify('updateProgress stop downloading animate',
        this.layoutVm.getFolderDataById(this.folderId).getGridInfo(), FolderActionLifeCycleStatus.INSTALLED_FOLDER);
    }

    if (!this.mProgress || this.processTotalSize !== totalSize) {
      log.showInfo(`updateProgress ${this.folderId},curSize:${curSize},totalSize:${totalSize},` +
        `processTotalSize:${this.processTotalSize}`);
      this.processTotalSize = totalSize;
      this.mProgress = new ProgressMask(curSize, totalSize, '#4d000000');
    } else {
      this.mProgress.updateProgress(curSize);
    }
  }

  private desktopStyleUpdate(): void {
    if (!this.desktopStyle) {
      log.showWarn('desktopStyle is empty');
      return;
    }
    this.layoutOsr.folderOsr.scale = this.desktopStyle.scale ?? 1;
  }

  private isEqualToDragItemChange(): void {
    log.showInfo('isEqualToDragItemChange %{public}s', this.isDragStart);
    if (!this.isDragStart) {
      this.layoutOsr.folderAppNameModify.attribute?.opacity(0);
      nameAppearAnimate(() => this.layoutOsr.folderAppNameModify.attribute?.opacity(1));
    }
  }

  private isInDragChange(): void {
    if (this.style.isLayout1X1()) {
      if (this.isInDrag) {
        this.dataOsr.updateBadgeAniType(BadgeAnimationType.DEFAULT);
      } else {
        this.dataOsr.updateBadgeAniType(BadgeAnimationType.DRAG_DROP);
      }
    }
  }

  private folderStatusChange(): void {
    log.showInfo('folderStatus change %{public}d to refresh folder', this.folderStatus);
    if (this.layoutOsr.isMenuShow) {
      this.layoutOsr.setStatus('folder status change', OBSERVER_SWITCH.MENU_EFFECT_HIDE, true);
    }
    this.initLayoutConfig();
    this.layoutVm.updateFolderLayout('folder status change', this.folderId);
  }

  private foldStatusChangeForOuterScreen(): void {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return;
    }
    log.showInfo('foldStatusForOuterScreen change %{public}d to refresh folder', this.foldStatusForOuterScreen);
    const iconSizeOld: number = this.iconSize;
    const gridWidthOld: number = this.layoutOsr.folderOsr.folderWidth;
    this.initLayoutConfig();
    FolderSnapshotManager.getInstance().checkRefreshSnapshot(this.folderId, iconSizeOld, gridWidthOld,
      'foldStatusForOuterScreen');
  }

  private onPortraitStatusChange(): void {
    log.showInfo('portrait status change %{public}s to refresh folder', this.mIsPortrait);
    this.initConfig();
  }

  private getStackItemRealIndex(index: number): number {
    return this.dataOsr.folderDataOsr.firstPageItems.length + (2 - index);
  }

  private getHideItemRealIndex(index: number): number {
    return this.dataOsr.folderDataOsr.firstPageItems.length + index;
  }

  private isShow1x1HideItems(index: number): boolean {
    if (!this.layoutOsr.editFolderMode) {
      return false;
    }
    if (!this.style.isLayout1X1()) {
      return false;
    }
    return index === 8 && this.dataOsr.editFolderAnimationFolderItems.length > 0;
  }

  private onSnapBuilderAreaChange(index: number, newValue: Area): void {
    let left: number = Number(newValue.globalPosition.x);
    let top: number = Number(newValue.globalPosition.y);
    if (left > 0 && top > 0) {
      folderLayoutUtil.setSmallFolderItemCenter(index, {
        x: left + Number(newValue.width) / 2,
        y: top + Number(newValue.height) / 2
      });
    }
  }

  private getIconConfig(item: GridLayoutItemInfo): AppIconConfig {
    const config: AppIconConfig = FolderIconConfigUtil.getIconConfig(item, this.iconRadius, this.folderId,
      this.isAccessibilityMode, this.style.isLayout1X1());
    if (config.externCb) {
      config.externCb.enableHandleTouchEvent = (): boolean =>
        this.layoutOsr.resizeOsr.resizePosition === ResizePosition.NONE;
    }
    return config;
  }

  @Styles
  EventStyles() {
    .hitTestBehavior(this.layoutOsr.isAnimating ? HitTestMode.None : HitTestMode.Default)
    .onTouch((event?: TouchEvent) => this.eventMgr?.onTouch('touch grid', this.folderId, event))
    .onClick((event?: ClickEvent) => this.eventMgr?.onClick('click grid', this.folderId, FolderClickType.GRID_CLICK))
    .onMouse((event?: MouseEvent) => this.eventMgr?.onMouse('mouse click', this.folderId, event))
    .bindContextMenu(this.layoutOsr.isMenuShow, this.layoutVm.isScreenSplit(TAG) ? this.emptyBuilder :
    this.MenuBuilder(true), this.getContextMenu())
    .bindContextMenu(this.layoutVm.isEnableAction(FolderActionFlag.ACTION_MENU) ? this.MenuBuilder(false) :
      this.emptyBuilder, ResponseType.RightClick, this.getContextMenu())
  }

  @Styles
  DragStyles() {
    .draggable(true)
    .onDragStart((event: DragEvent) => this.eventMgr?.onDragStart('onDragStart', event, this.folderId, this.dragStart))
    .onDragEnd((event: DragEvent, extraParams?: string) => this.eventMgr?.onDragEnd('onDragEnd', this.folderId))
    .dragPreviewOptions(this.dragVm?.getDragPreviewOption('drag preview option', this.layoutOsr.folderOsr.folderRadius,
      this.isSolidColor), { isDragPreviewEnabled: false })
    .onPreDrag((status: PreDragStatus) => this.dragVm?.preDrag('preDrag folder', this.folderId, status))
    .onGestureJudgeBegin((gestureInfo: GestureInfo) => this.eventMgr?.onDragGestureJudgeBegin('drag gesture judge',
      this.folderId, gestureInfo));
  }

  @Styles
  GestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: CommonConstants.LONG_PRESS_TIME_FOR_BIG_FOLDER_CANCEL })
          .onAction((event: GestureEvent) => this.eventMgr?.onIconPressCancel()),
        LongPressGesture({ repeat: false, duration: CommonConstants.LONG_PRESS_TIME_FOR_SNAPSHOT })
          .onAction((event: GestureEvent) => this.longPresser?.onActionSnapshot('snapshot', this.folderId))
          .onActionEnd((event: GestureEvent) => this.releaseDragSnapshot('onActionEnd')),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction(() => this.longPresser?.onActionVibrator('vibrator', this.folderId)),
        LongPressGesture({ repeat: false, duration: FolderCommonConstants.LONG_PRESS_TRIGGER_ANIMATION })
          .onAction(() => this.longPresser?.onActionPressAnimation('press animation', this.folderId)),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_HIDE_BADGE_FOLDER })
          .onAction(() => this.longPresser?.onActionHideBadge(this.folderId)),
      )
    )
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture({ count: 2 })
          .onAction((event?: GestureEvent) => this.openCloser?.open('TapGesture double click', this.folderId, false,
            FolderOperationFlag.NONE))
      )
    )
  }

  @Styles
  onAppearStyles() {
    .onAppear(() => {
      log.showInfo(`onAppearStyles isFirstShow:${this.isFirstShow}`)
      if (this.isFirstShow) {
        this.isFirstShow = false;
        this.initPageIconEffect();
      }
      RTLUtil.registerRtlChangeCallback(this.registerRtlChangeCallback);
    })
  }

  @Styles
  onDisAppearStyles() {
    .onDisAppear(() => {
      log.showInfo(`onDisAppearStyles`)
      RTLUtil.unregisterRtlChangeCallback(this.registerRtlChangeCallback);
    })
  }

  @Builder
  private folderNameBuilder() {
    AppName({
      appName: this.style.mThemeStyle?.isShowName ? FolderCommonUtil.getRealFolderName(this.dataOsr.folderName, this.folderId) : '',
      nameWidth: this.style.mNameWidth,
      nameHeight: this.style.mNameHeight,
      nameSize: this.style.mNameSize,
      parentItem: this.layoutVm.getFolderDataById(this.folderId)?.getGridInfo(),
      nameLines: this.style.mNameLines,
      marginTop: this.style.iconNameMargin,
      getIndexInSwiper: this.getIndexInSwiper,
      colStart: this.style.colStart,
      colEnd: this.style.colEnd,
      rowEnd: this.style.rowEnd,
      shadowOption: this.renameVm?.getShadowOption(this.folderId, this.getIndexInSwiper()),
      zValue: -1,
      modifier: this.layoutOsr.folderAppNameModify,
      alignOption: {
        top: { anchor: CommonConstants.FOLDER_GROUP_TAG + this.folderId, align: VerticalAlign.Bottom },
        middle: { anchor: CommonConstants.FOLDER_GROUP_TAG + this.folderId, align: HorizontalAlign.Center }
      },
      mTranslate: { x: this.layoutOsr.resizeOsr.nameTransX, y: this.layoutOsr.resizeOsr.nameTransY }
    })
  }

  @Builder
  emptyBuilder() {
  }

  @Builder
  MenuBuilder(isLongPressShow: boolean) {
    AppMenu({
      menuInfoList: this.eventMgr?.buildMenuInfoList(
        () => this.renameVm?.clickRename('click menu to rename', this.folderId), !this.style.isLayout1X1(),
        FolderCommonUtil.isFolderSupportRename(this.folderId))
    })
      .id(`${TAG}_AppMenu_longPressMenu`)
      .width(StyleConstants.APP_MENU_WIDTH_COLUMNS_PHONE)
      .onAppear(() => this.eventMgr?.onAppMenuAppear('longPress menu appear', this.folderId, isLongPressShow))
      .onDisAppear(() => this.eventMgr?.onAppMenuDisappear('longPress menu disappear', this.folderId, isLongPressShow))
  }

  private getContextMenu(): ContextMenuOptions {
    const pageIndex: number = this.getIndexInSwiper?.() || 0;
    let menuOption: MenuDataOption = this.eventMgr?.getMenuOption('pop up menu', this.folderId, pageIndex);
    return {
      preview: () => {
        this.menuPreviewBuilder();
      },
      layoutRegionMargin: menuOption.layoutRegionMargin,
      offset: menuOption.offset as Position,
      previewBorderRadius: this.layoutOsr.folderOsr.folderRadius,
      onDisappear: menuOption.onDisappearCallback,
      placement: menuOption.placement,
      previewAnimationOptions: {
        scale: [menuOption.preAnimationStartScale as number, menuOption.preAnimationEndScale as number],
        transition: this.layoutOsr.isHiddenEffect ? TransitionEffect.asymmetric(
          TransitionEffect.opacity(0),
          TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
      },
      transition: this.layoutOsr.isHiddenEffect ? TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
      onWillAppear: menuOption.onWillAppear,
      onWillDisappear: menuOption.onWillDisappear,
    };
  }

  private releaseDragSnapshot(msg: string): void {
    if (!this.isInDrag && !this.layoutOsr.isMenuShow) {
      this.dragVm?.releaseDragSnapshot(msg, this.folderId);
    }
  }

  // 文件夹设置builder为菜单预览，在builder内设置模糊参数优化菜单弹出的衔接效果
  @Builder
  menuPreviewBuilder() {
    Stack() {
      Image(this.dragVm?.getDragSnapshot('menu preview', this.folderId, SnapshotType.DROP))
        .draggable(false)
        .width(this.layoutOsr.folderOsr.folderWidth)
        .height(this.layoutOsr.folderOsr.folderHeight)
        .borderRadius(this.layoutOsr.folderOsr.folderRadius)
        .syncLoad(true)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .backgroundEffect(this.isSolidColor ? undefined : {
          policy: 1,
          radius: FolderResourceUtil.getFolderBgRadius(),
          saturation: FolderResourceUtil.getFolderBgSaturation(),
          brightness: FolderStyleManager.getInstance().getBackgroundBrightness(),
          color: FolderResourceUtil.getBgColor(false)
        })

    }
    .width(this.layoutOsr.folderOsr.folderWidth +
    FolderResizeUtil.getHotAreaSideWidth(FolderCommonUtil.isDockFolder(this.folderId)))
    .height(this.layoutOsr.folderOsr.folderHeight +
    FolderResizeUtil.getHotAreaSideHeight(FolderCommonUtil.isDockFolder(this.folderId)))
    .onDisAppear(() => this.releaseDragSnapshot('menu preview disAppear'));
  }

  @Builder
  bigFolderIconMask(index: number) {
    Column() {
    }
    .backgroundColor(index === 0 ? StyleConstants.FOLDER_LAST_THREE_APP_FIRST_MASK :
    StyleConstants.FOLDER_LAST_THREE_APP_SECOND_MASK)
    .height(this.style.mFolderAppSize * StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80)
    .width(this.style.mFolderAppSize * StyleConstants.DEFAULT_FOLDER_EMPTY_APP_ICON_PERCENTAGE_80)
  }

  @Builder
  private gridAppIconBuilder(item: GridLayoutItemInfo, index: number) {
    if (this.isAccessibilityMode && !this.style.isLayout1X1()) {
      Stack({ alignContent: Alignment.Center }) {
        if (this.isShow1x1HideItems(index)) {
          this.editFolderAnimationCompensateItemsBuilder()
        }
        this.appIconBuilder(item, index)
      }
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
    } else if (this.isShow1x1HideItems(index)) {
      Stack({ alignContent: Alignment.Center }) {
        this.editFolderAnimationCompensateItemsBuilder()
        this.appIconBuilder(item, index)
      }
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
    } else {
      this.appIconBuilder(item, index)
    }
  }

  @Builder
  private appIconBuilder(item: GridLayoutItemInfo, index: number) {
    if (item.isEmpty) {
      ContractedFolderEmptyItem({
        index: index,
        iconSize: this.iconSize,
        iconRadius: this.iconRadius,
        editFolderMode: this.layoutOsr.editFolderMode,
        maskBgColor: index === this.dataOsr.folderDataOsr.firstPageItems.length - 1 ?
          StyleConstants.FOLDER_LAST_THREE_APP_FIRST_MASK : StyleConstants.FOLDER_LAST_THREE_APP_SECOND_MASK,
      })
    } else {
      if (DeliverUtil.isContainerItem(item.intent ?? '')) {
        DeliveryFolderItem({
          item: item as AppItemInfo,
          iconSize: this.iconSize,
          iconRadius: this.iconRadius,
          folderId: this.folderId ?? '',
          isSmall: this.style.isLayout1X1(),
          appIconConfig: this.getIconConfig(item),
          bigFolderIconModifier: FolderIconConfigUtil.getBigFolderIconModifier(),
          editFolderMode: this.layoutOsr.editFolderMode,
          index: index,
        })
      } else {
        ContractedFolderItem({
          item: item as AppItemInfo,
          iconSize: this.iconSize,
          iconRadius: this.iconRadius,
          folderId: this.folderId ?? '',
          appIconConfig: this.getIconConfig(item),
          bigFolderIconModifier: FolderIconConfigUtil.getBigFolderIconModifier(),
          editFolderMode: this.layoutOsr.editFolderMode,
          index: index,
          isSmall: this.style.isLayout1X1(),
          onAppClick: (msg: string, folderId: string, item: GridLayoutItemInfo) => this.eventMgr?.onClick(msg,
            folderId, FolderClickType.ICON_CLICK, item)
        })
      }
    }
  }

  @Builder
  private commonAnimateIcon(item: GridLayoutItemInfo, isFistIconData: boolean, isNeedSmallBadge: boolean) {
    AppIconCommonView({
      item: item as AppItemInfo,
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      iconData: isFistIconData ? this.fstIconData : this.sndIconData,
      appIconConfig: FolderIconConfigUtil.getPeruDisplayConfig(),
    })
  }

  @Builder
  lastAppInfoBuilder(item: GridLayoutItemInfo | null) {
    AppIconCommonView({
      item: item as AppItemInfo,
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      iconData: this.fstIconData,
      appIconConfig: FolderIconConfigUtil.getPeruDisplayConfig(),
    })
      .width(this.iconSize)
      .height(this.iconSize)
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
  }

  @Builder
  folderImageBuilder(isCurrent: boolean, isEndPage: boolean): void {
    Grid() {
      ForEach(isCurrent ? this.dataOsr.folderDataOsr.currentPageItems :
        (isEndPage ? this.dataOsr.folderDataOsr.endPageItems : this.dataOsr.folderDataOsr.firstPageItems),
        (item: GridLayoutItemInfo, index: number) => {
          GridItem() {
            if (!item.isEmpty && item.typeId !== CommonConstants.TYPE_ADD) {
              AppIconCommonView({
                iconSize: this.iconSize,
                appIconConfig: FolderIconConfigUtil.getFolderImageConfig(),
                item: item as AppItemInfo,
                iconRadius: this.iconRadius,
              }).onAreaChange((oldValue: Area, newValue: Area) => {
                this.onSnapBuilderAreaChange(index, newValue);
              })
            }
          }
        })
    }
    .clip(false)
    .padding({
      left: this.style.getPadding(true),
      right: this.style.getPadding(true),
      bottom: this.style.getPadding(false),
      top: this.style.getPadding(false),
    })
    .columnsTemplate(this.layoutOsr.folderOsr.columnTemplate)
    .rowsTemplate(this.layoutOsr.folderOsr.rowTemplate)
    .columnsGap(this.style.getColumnGap())
    .rowsGap(this.style.getRowGap())
    .height(this.layoutOsr.folderOsr.folderHeight)
    .width(this.layoutOsr.folderOsr.folderWidth)
  }

  @Builder
  private folderGridItem(item: GridLayoutItemInfo, index: number) {
    GridItem() {
      if (this.layoutOsr.mIsIconAnimating && this.layoutVm.isEqualDragToFolderApp(this.folderId, item.keyName)) {
        this.commonAnimateIcon(item, true, true)
      } else if (this.layoutOsr.mIsIconAnimating && this.layoutVm.isEqualCoverFolderApp(item.keyName ?? '')) {
        this.commonAnimateIcon(item, false, true)
      } else if (this.layoutOsr.mIsIconAnimating && this.layoutVm.isEqualDisappearData(item.keyName ?? '')) {
        // 文件夹仅剩app退场动效
        this.commonAnimateIcon(item, true, false)
      } else if (this.layoutVm.isAppHidden(item, this.folderId)) {
        Column()
          .height(this.style.mFolderAppSize * StyleConstants.FOLDER_ICON_HEIGHT_FACTOR)
          .width(this.style.mFolderAppSize)
      } else {
        if (!this.layoutVm.isShowCancelDialog(item) &&
          !this.layoutVm.isInMultiSelectDrop(item.keyName ?? '', this.folderId)) {
          this.gridAppIconBuilder(item, index)
        }
      }
    }
    .id(folderLayoutUtil.getFolderItemKey(item, index))
    .focusable(false)
    .zIndex(this.layoutOsr.resizeOsr.zIndexArray[index])
  }

  @Builder
  private contentAnimationBuilder() {
    if (this.style.isLayout1X1() && this.layoutOsr.mIsIconAnimating &&
    this.layoutVm.isEqualDragToFolderApp(this.folderId)) {
      this.lastAppInfoBuilder(this.layoutVm.getLastAnimateInfo());
    }
  }

  @Builder
  private contentGridBuilder() {
    Grid() {
      ForEach(
        (!this.layoutOsr.mIsIconAnimating || !this.style.isLayout1X1()) ?
        this.dataOsr.folderDataOsr.firstPageItems :
        this.dataOsr.folderDataOsr.currentPageItems, (item: GridLayoutItemInfo, index: number) => {
        this.folderGridItem(item, index);
      },
        (item: GridLayoutItemInfo, index: number) => folderLayoutUtil.getFolderItemKey(item, index)
      );
    }
    .id(CommonConstants.FOLDER_GRID_TAG + this.folderId)
    .clip(false)
    .width(this.layoutOsr.folderOsr.folderWidth)
    .height(this.layoutOsr.folderOsr.folderHeight)
    .responseRegion({
      x: '-3%',
      y: '-3%',
      width: '106%',
      height: '106%',
    })
    .columnsGap(this.style.getColumnGap())
    .rowsGap(this.style.getRowGap())
    .columnsTemplate(this.layoutOsr.folderOsr.columnTemplate)
    .rowsTemplate(this.layoutOsr.folderOsr.rowTemplate)
    .padding({
      left: this.style.getPadding(true),
      right: this.style.getPadding(true),
      bottom: this.style.getPadding(false),
      top: this.style.getPadding(false),
    })
    .visibility(this.dataOsr.folderDataOsr.contractedMode === ContractedFolderMode.MODE_COMPONENT ? Visibility.Visible :
    Visibility.Hidden)
  }

  @Builder
  contentBackgroundBuilder() {
    if (this.layoutVm.isEnableAction(FolderActionFlag.ACTION_BACKGROUND)) {
      Column() {
      }
      .borderRadius(this.layoutOsr.resizeOsr.backgroundRadius)
      .width(this.layoutOsr.folderOsr.folderWidth * this.layoutOsr.resizeOsr.scaleX)
      .height(this.layoutOsr.folderOsr.folderHeight * this.layoutOsr.resizeOsr.scaleY)
      .useEffect(FolderCommonUtil.isUseEffect(this.isSolidColor, this.isInDock))
      .scale({ x: this.layoutOsr.folderBgOsr.scaleX, y: this.layoutOsr.folderBgOsr.scaleY })
      .translate({ x: this.layoutOsr.folderBgOsr.transX, y: this.layoutOsr.folderBgOsr.transY })
      .opacity(this.layoutOsr.folderBgOsr.opacity)
      .backgroundColor(this.layoutOsr.folderBgOsr.backgroundColor)
      .mask(this.layoutOsr.isShowProgress && !this.layoutOsr.mIsHideMask &&
        !this.layoutOsr.editFolderMode ? this.mProgress : null)
      .renderFit(RenderFit.RESIZE_FILL)
      .id(TAG + '_background_' + this.folderId)
      .alignRules(this.layoutOsr.resizeOsr.alignRules)
    }
    if (this.isFolderExtraBackGroundShow.value && !this.isSolidColor) {
      EditModeFolderBackground({
        folderId: this.folderId,
        layoutOsr: this.layoutOsr
      })
    }
  }

  @Builder
  private contentDownloadBackground() {
    if (this.style.isLayout1X1() && this.layoutOsr.downloadingOpacity > 0) {
      Image($r('app.media.installing'))
        .draggable(false)
        .width(this.layoutOsr.folderOsr.folderWidth)
        .height(this.layoutOsr.folderOsr.folderHeight)
        .opacity(this.layoutOsr.downloadingOpacity)
        .hitTestBehavior(HitTestMode.None)
        .visibility(this.layoutOsr.mIsHideMask || this.layoutOsr.editFolderMode
          ? Visibility.Hidden : Visibility.Visible)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
  }

  private rtlChange(): void {
    if (this.isFirstShow) {
      return;
    }
    this.initPageIconEffect();
  }

  private initPageIconEffect(): void {
    const translate = TransitionEffect.translate({ x: this.style.backgroundWidth })
      .animation({ duration: 450 });
    const translate2 = TransitionEffect.translate({ x: -this.style.backgroundWidth })
      .animation({ duration: 450 });
    if (RTLUtil.isRTL()) {
      this.firstPageIconEffect = translate;
      this.endPageIconEffect = translate2;
    } else {
      this.firstPageIconEffect = translate2;
      this.endPageIconEffect = translate;
    }
  }

  private getFirstPageImageTransition(): TransitionEffect {
    return FolderCommonUtil.isFolderInCurrentPage(this.layoutVm.getFolderDataById(this.folderId).getGridInfo()) &&
      !this.isFirstTransition ?
    this.firstPageIconEffect : TransitionEffect.OPACITY;
  }

  @Builder
  contentBadgeBuilder() {
    if (this.showDesktopBadges && this.dataOsr.folderDataOsr.badgeNum > 0) {
      CustomBadge({
        bundleName: this.folderId + '_badge',
        badgeNumber: this.dataOsr.folderDataOsr.badgeNum,
        badgeAnimate: this.dataOsr.folderDataOsr.badgeAniType,
        badgeVisible: !this.layoutOsr.editFolderMode,
        keyName: this.folderId,
        iconSize: this.iconSize,
        ratio:this.zoomScale,
        isBadgeSmaller: false,
        bindFolderId: this.folderId,
        isIgnoreDesktopModeChange: this.layoutVm.isOpenedFolder(this.folderId)
      })
        .accessibilityLevel(this.isAccessibilityMode ? 'no-hide-descendants' : 'auto')
        .alignRules({
          top: { anchor: TAG + '_background_' + this.folderId, align: VerticalAlign.Top },
          right: { anchor: TAG + '_background_' + this.folderId, align: HorizontalAlign.End }
        })
    }
  }

  @Builder
  private contentImageBuilder() {
    Stack() {
      if (!this.layoutOsr.isShowEndPage) {
        if (this.dataOsr.folderDataOsr.firstPageItems.length !== 0) {
          Image(this.dataOsr.folderDataOsr.getFirstPageIcon())
            .draggable(false)
            .width(this.layoutOsr.folderOsr.folderWidth)
            .height(this.layoutOsr.folderOsr.folderHeight)
            .borderRadius(this.layoutOsr.folderOsr.folderRadius)
            .syncLoad(true)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .transition(this.getFirstPageImageTransition(), () => {
              this.isFirstTransition = false;
            })
            .onAppearStyles()
            .onDisAppearStyles()
        }
      } else {
        Image(this.layoutOsr.isShowCurrentPage ? this.dataOsr.folderDataOsr.getCurrentPageIcon() :
        this.dataOsr.folderDataOsr.getEndPageShowIcon())
          .draggable(false)
          .width(this.layoutOsr.folderOsr.folderWidth)
          .height(this.layoutOsr.folderOsr.folderHeight)
          .borderRadius(this.layoutOsr.folderOsr.folderRadius)
          .syncLoad(true)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .transition(this.endPageIconEffect)
          .onAppearStyles()
          .onDisAppear(() => {
            log.showInfo(`onDisAppear ${this.layoutOsr.isShowCurrentPage}`)
            RTLUtil.unregisterRtlChangeCallback(this.registerRtlChangeCallback);
            this.layoutOsr.isShowCurrentPage = false;
            this.dataOsr.folderDataOsr.currentPageItems = [];
            this.dataOsr.folderDataOsr.setCurrentPageIcon(null);
          })
      }
    }
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
    .visibility(this.dataOsr.folderDataOsr.contractedMode === ContractedFolderMode.MODE_IMAGE ? Visibility.Visible :
    Visibility.Hidden)
    .clip(true)
    .borderRadius(this.layoutOsr.folderOsr.folderRadius)
  }

  @Builder
  private editFolderAnimationCompensateItemBuilder(item: FolderAppItemInfo, index: number) {
    Column() {
      ContractedFolderItem({
        item: item as AppItemInfo,
        iconSize: this.iconSize,
        iconRadius: this.iconRadius,
        editFolderMode: this.layoutOsr.editFolderMode,
        index: this.getHideItemRealIndex(index)
      })
    }
    .width(this.iconSize)
    .height(this.iconSize)
    .alignRules(FolderIconConfigUtil.getLastThreeAlignRules(0))
    .zIndex(this.layoutOsr.resizeOsr.zIndexArray[this.getHideItemRealIndex(index)])
  }

  @Builder
  private editFolderAnimationCompensateItemsBuilder() {
    ForEach(this.dataOsr.editFolderAnimationFolderItems, (item: FolderAppItemInfo, index: number) => {
      this.editFolderAnimationCompensateItemBuilder(item, index);
    }, (item: FolderAppItemInfo, index: number) =>
      folderLayoutUtil.getFolderItemKey(item, this.getHideItemRealIndex(index)))
  }

  @Builder
  folderIconContentBuilder() {
    RelativeContainer() {
      this.contentBackgroundBuilder();
      this.contentImageBuilder();
      this.contentGridBuilder();
      this.contentDownloadBackground();
      this.contentAnimationBuilder();
      this.contentBadgeBuilder();
    }
    .id(CommonConstants.FOLDER_GROUP_TAG + this.folderId)
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
    .onHover((isHover: boolean): void => this.eventMgr?.onHover('hover on folder', this.folderId, isHover))
    .accessibilityLevel('no')
    .width(this.isSelect ? this.style.backgroundWidth + StyleConstants.DEFAULT_40 :
    this.style.backgroundWidth)
    .height(this.isSelect ? this.style.backgroundHeight + StyleConstants.DEFAULT_40 :
    this.style.backgroundHeight)
    .backgroundColor(this.isSelect ? StyleConstants.DEFAULT_BROAD_COLOR :
    StyleConstants.DEFAULT_TRANSPARENT_COLOR)
    .borderRadius(this.isSelect ? StyleConstants.DEFAULT_15 : StyleConstants.DEFAULT_0)
    .scale({ x: this.layoutOsr.folderIconOsr.scale, y: this.layoutOsr.folderIconOsr.scale })
    .opacity(this.layoutOsr.folderIconOsr.opacity)
    .DragStyles()
    .GestureStyles()
    .EventStyles()
    .hitTestBehavior(this.layoutOsr.resizeOsr.resizePosition !== ResizePosition.NONE ?
      HitTestMode.Block : HitTestMode.Default)
  }

  @Builder
  folderCheckboxBuilder(item: GridLayoutItemInfo) {
    if (this.multiSelectState.value && !(this.isDragStart || this.isInDrag)) {
      MultiSelectCheckboxView({
        parentType: CheckboxParentEnum.Folder,
        parentItemInfo: item as Object as AppItemInfo,
        parentId: MultiSelectManager.getInstance().getUniqueId(item),
        rectId: CommonConstants.FOLDER_GROUP_TAG + this.folderId,
        iconSize: this.layoutOsr.folderOsr.folderWidth
      })
    }
  }

  private getFolderVisible(): Visibility {
    log.showInfo(`drag folder ${this.folderId} isDragStart ${this.isDragStart} isInDrag ${this.isInDrag}`);
    if (this.isDragStart || this.isInDrag) {
      return Visibility.Hidden;
    }
    return this.layoutOsr.isFolderVisible ? Visibility.Visible : Visibility.Hidden;
  }

  private getPadding(): Padding | Length | LocalizedPadding  {
    let padding: number = AppStorage.get<number>('itemPadding') as number;
    if (FolderCommonUtil.isDockFolder(this.folderId) || !this.isAccessibilityMode) {
      padding = 0;
    }
    return {
      top: padding,
      bottom: padding
    };
  }

  build() {
    RelativeContainer() {
      this.folderIconContentBuilder();
      if (this.layoutOsr.enableFolderName) {
        this.folderNameBuilder();
      }
      this.folderCheckboxBuilder(this.layoutVm.getFolderDataById(this.folderId).getGridInfo());
    }
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .visibility(this.getFolderVisible())
    .translate({
      x: this.desktopStyle ? this.desktopStyle.translateX + this.translateX : this.translateX,
      y: this.desktopStyle ? this.desktopStyle.translateY + this.translateY : this.translateY
    })
    .opacity(this.desktopStyle ? this.desktopStyle.alpha : 1)
    .scale({
      x: this.layoutOsr.folderOsr.scale,
      y: this.layoutOsr.folderOsr.scale,
      centerX: this.layoutVm.isCreateFolder(this.folderId) ? '0' :
        (this.desktopStyle && this.desktopStyle.unLockAnimate ? this.desktopStyle.centerX :
        StyleConstants.PERCENTAGE_50),
      centerY: this.layoutVm.isCreateFolder(this.folderId) ? '0' :
        (this.desktopStyle && this.desktopStyle.unLockAnimate ? this.desktopStyle.centerY :
        StyleConstants.PERCENTAGE_50)
    })
    .onAppear(() => {
      if (this.layoutVm.isCreateFolder(this.folderId)) {
        this.layoutOsr.folderOsr.scale = 0.2;
        animateTo(
          {
            duration: 500,
            onFinish: () => {
              this.layoutVm.setIsCreateFolder(false);
            }
          }, () => {
          this.layoutOsr.folderOsr.scale = 1.0;
        })
      }
    })
    .offset({
      x: this.layoutOsr.resizeOsr.offsetX + this.layoutOsr.resizeOsr.gapWidth,
      y: this.layoutOsr.resizeOsr.offsetY
    })
    .padding(this.getPadding())
    .accessibilityLevel('yes')
    .accessibilityText((FolderCommonUtil.isDockFolder(this.folderId) ? this.accessibilityDock : '') + this.dataOsr.accessibilityText)
    .accessibilityDescription(FolderAccessibilityUtil.getFolderDescription())
    .onClick(this.isAccessibilityMode ?
      (event?: ClickEvent) => this.eventMgr?.onClick('click grid in accessibility mode', this.folderId, FolderClickType.GRID_CLICK) :
      (event?: ClickEvent) => log.showInfo('click on folder container'))
    .focusable(true)
    .id(CommonConstants.FOLDER_ACCESSIBILITY_TAG + this.folderId)
  }

  scaleChange() {
    this.initLayoutConfig();
  }
}