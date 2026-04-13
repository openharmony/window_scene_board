/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  EntryViewBlurStatus,
  EntryViewBlurStatusStruct,
  EventConstants,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderCommonConstants,
  FolderDataModelManager,
  folderGesData,
  FolderLifeCyclePriority,
  FolderManager,
  FolderOperationFlag,
  FolderReporter,
  FolderState,
  FolderStyleConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  InputMethodManager,
  ReceiveEventInfo,
  CloseAppManager,
} from '@ohos/launchercommon';
import { AnimateToScheduleUtils, DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { WallpaperConstants } from '@ohos/commonconstants';
import { SCBTransitionManager, SCBSceneSessionManager } from '@ohos/windowscene';
import { DropAnimationCancelReason } from '@ohos/componentanimator';
import { desktopUtil } from '@ohos/componenthelper';
import {
  GlobalContext,
  viewMgrPolicy,
  ViewType,
  HiSysEventUtil,
  localEventManager,
  TextColor,
  WallpaperColorManager
} from '@ohos/frameworkwrapper';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { BigFolderViewModel, FolderCloseType } from '../viewmodel/BigFolderViewModel';
import FeatureConstants from '../common/constants/FeatureConstants';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { OpenFolderGridSwiper } from './OpenFolderGridSwiper';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { OpenFolderGridSwiperLayout } from '../viewmodel/OpenFolderGridSwiperLayout';
import { openFolderLayout } from '../viewmodel/OpenFolderLayout';
import { openCloseAniMgr } from '../viewmodel/openclose/OpenCloseActionManager';
import { OpenCloseViewModel } from '../viewmodel/openclose/OpenCloseViewModel';
import { openFolderVm } from '../viewmodel/OpenFolderViewModel';
import OpenFolderAddDialog from './OpenFolderAddDialog';
import { FolderAddEventParams } from '../common/constants/FolderAddDialogConstant';
import { OpenFolderAddViewModel } from '../viewmodel/OpenFolderAddViewModel';
import { FolderSnapshotManager, FoldAnimationConstants } from '@ohos/launchercommon/Index';

const TAG = 'OpenFolderComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct OpenFolderComponent {
  @StorageLink('openFolderPageIndex') pageIndex: number = 0;
  @StorageLink('openFolderStatus') @Watch('updateFolderData') openFolderStatus: number =
    FeatureConstants.OPEN_FOLDER_STATUS_CLOSE;
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_DESKTOP;
  @StorageLink('openFolderId') @Watch('isShowAnimateOpenFolder') openFolderId: string = '-1';
  @StorageLink('openSmallFolderFlag') openSmallFolderFlag: boolean = false;
  @StorageLink('isExpandFolderAnimClosing') isExpandFolderAnimClosing: boolean = false;
  @StorageLink('isPad') isPad: boolean = false;
  @StorageProp('wallpaperChangeFlag') @Watch('updateSwiperColor') wallpaperValue: boolean = true;
  @State isRenaming: boolean = false;
  @State newFolderName: string = '';
  @State swiperColor: string | undefined = WallpaperConstants.SWIPER_WHITE_COLOR;
  @State swiperSelectedColor: string | undefined = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
  @State folderNameColor: string | undefined = WallpaperConstants.COLOR_WHITE_STRING;
  @State cancelAppImage: string = FolderStyleConstants.DEFAULT_CANCEL_APP_IMAGE;
  @State isGeometryTransiting: boolean = false;
  @State folderNameAppearDuration: number = 0;
  @State folderNameDisappearDuration: number = 0;
  @State isDragOutFolderPendingClose: boolean = false;
  @State @Watch('viewIsSwiperClipForce') isSwiperClipForce: boolean = false;
  @State gridSwiperLayout: OpenFolderGridSwiperLayout = openFolderLayout.getGridSwiperLayout();
  @State isShowOpenFolderAddSheet: boolean = false;
  @Consume('openFolderFlag') openFolderFlag: boolean;
  @Consume('isSmallFolderImage') isSmallFolderImage: boolean;
  @Consume('openSmallFolderBackgroundFlag') openSmallFolderBackgroundFlag: boolean;
  private textInputKey: string = 'textInputKey';
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private swiperController: SwiperController | null = new SwiperController();
  private isNewStyle: boolean = true;
  private mFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private mFolderIdAddSheet: string = '';
  private openFolderAddSheetBy: string = FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE;

  private updateIsShowOpenFolderAddSheet = (newIsShow: boolean) => {
    this.isShowOpenFolderAddSheet = newIsShow;

    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      if (this.isShowOpenFolderAddSheet) {
        this.hideDock()
      } else {
        this.showDock()
      }
    }
  }

  private showDock() {
    if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
      let showDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('showDockViewWithAnimation') as Function);
      showDockViewWithAnimation();
    } else {
      viewMgrPolicy.showView(ViewType.SMART_DOCK);
    }
  }

  private hideDock() {
    if (GlobalContext.getInstance().hasObject('hideDockViewWithAnimation')) {
      let hideDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('hideDockViewWithAnimation') as Function);
      hideDockViewWithAnimation();
    } else {
      viewMgrPolicy.hideView(ViewType.SMART_DOCK);
    }
  }

  private readonly openFolderEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: FolderAddEventParams) => {
      log.showInfo('receive openFolderEvent %{public}s, params %{public}s', event, params);
      if (event === EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN) {
        this.openFolderAddSheetBy = params.openedBy;
        this.mFolderIdAddSheet = params.folderId;
        if (this.openFolderAddSheetBy === FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE ||
          OpenFolderAddViewModel.getInstance()
            .isFolderContainAnyCategory(this.mFolderMgr.getFolder(this.mFolderIdAddSheet).getGridInfo())) {
            this.updateIsShowOpenFolderAddSheet(true);
        }
      } else if (event === EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_CLOSE) {
        this.mFolderIdAddSheet = FolderCommonConstants.INVALID_FOLDER_ID
        this.updateIsShowOpenFolderAddSheet(false);
      }
    }
  }

  private mFolderMgr = FolderManager.getInstance();

  private animationEndNewCallback: () => void = () => {
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_CLOSE_FOLDER_ANI);
    if (GridLayoutUtil.isSmallFolder(this.mFolderMgr.getOpenedFolder())) {
      log.info('is show smallFolder openFolder animate end');
      FolderDataModelManager.getInstance().setFolderStateById(
        FolderDataModelManager.getInstance().getOpenFolderId(),
        FolderState.SMALL_FOLDER_CLOSE);
      this.openSmallFolderFlag = false;
    } else {
      log.info('is show bigFolder openFolder animate end');
      if (desktopUtil.isFoldExpandStatus()) {
        this.isExpandFolderAnimClosing = false;
      }
      this.openFolderFlag = false;
    }
  };

  private mOpenFolderCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      this.openFolderId = folder.folderId ?? FolderCommonConstants.INVALID_FOLDER_ID;
    },
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      if (!this.isRenaming) {
        this.isRenaming = ContractedFolderLayoutViewModel.getInstance().getAutoEnterEditing();
      }
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('onClosingFolder');
      this.openFolderId = FolderCommonConstants.INVALID_FOLDER_ID;
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      this.openFolderId = FolderCommonConstants.INVALID_FOLDER_ID;
      ContractedFolderLayoutViewModel.getInstance().setAutoEnterEditing(false);
      this.isRenaming = false;
      if (desktopUtil.isFoldExpandStatus()) {
        this.isExpandFolderAnimClosing = false;
      }
    },
  }

  viewIsSwiperClipForce(): void {
    log.showInfo(`isSwiperClipForce ${this.isSwiperClipForce}`)
  }

  private isShowAnimateOpenFolder() {
    log.showInfo('isShowAnimateOpenFolder:%{public}s', this.openFolderId);
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    const isSmallFolder: boolean = GridLayoutUtil.isSmallFolder(openFolderData);
    if (!this.isNeedShowFolderAnimation()) {
      if (AppStorage.get<string>('device') as string === CommonConstants.DEFAULT_DEVICE_TYPE) {
        AppStorage.setOrCreate('entryViewBlurStatus',
          new EntryViewBlurStatusStruct(EntryViewBlurStatus.FOLDER_CLOSE, 0));
      }
      if (isSmallFolder) {
        this.openSmallFolderFlag = false;
        this.isSmallFolderImage = true;
        this.openSmallFolderBackgroundFlag = false;
      } else {
        this.openFolderFlag = false;
      }
      log.showInfo('close folder no animate');
      this.gridSwiperLayout.isShowOpenFolder = false;
      return;
    }
    if (this.openFolderId === FolderCommonConstants.INVALID_FOLDER_ID && !isSmallFolder &&
      desktopUtil.isFoldExpandStatus()) { // 展开态关闭动效
      this.isExpandFolderAnimClosing = true;
    }
  }

  private isFolderInCurrentPageOfDesktop(): boolean {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (!openFolderData) {
      return true;
    }
    let currentPage: number = desktopUtil.getPageIndexValue()
    let folderPage = openFolderData.page ?? 0;
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    return displayCount > 1 ? Math.floor(currentPage / displayCount) === Math.floor(folderPage / displayCount) :
      currentPage === folderPage;
  }

  private isNeedShowFolderAnimation(): boolean {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (this.openFolderId !== '-1' || this.isFolderInCurrentPageOfDesktop() || openFolderData.isInDock) {
      return true;
    }
    return false;
  }

  private registerOpenFolderEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [
      EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN,
      EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_CLOSE
    ]);
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start');
    this.isNewStyle = AppStorage.get<boolean>('desktopNewStyle') ?? true;
    this.mFolderViewModel = BigFolderViewModel.getInstance();
    this.updateFolderData();
    this.registerOpenFolderEvent(this.openFolderEventListener);
    openFolderVm.registerOpenCloseCallback();
    openCloseAniMgr.registerFolderStatus();
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenFolderCallback);
    openFolderVm.registerCloseFolderEndCallback(this.animationEndNewCallback);
    // 文件夹唯一属性, 由本唯一组件提供.
    FolderSnapshotManager.getInstance().setUiContext(this.getUIContext());
    log.showInfo('aboutToAppear end');
  }

  private isOpenFolder(): boolean {
    return this.openFolderFlag || this.openSmallFolderFlag;
  }

  aboutToDisappear(): void {
    log.showInfo('OpenFolderComponent aboutToDisappear');
    this.freeResource();
    localEventManager.unregisterEventListener(this.openFolderEventListener);
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenFolderCallback);
    openCloseAniMgr.unregisterFolderStatus();
    openFolderVm.unregisterOpenCloseCallback();
    openFolderVm.unregisterCloseFolderEndCallback();
  }

  freeResource(): void {
    this.swiperController = null;
  }

  private updateFolderData() {
    // 待重构整体合入主干后，删去本文件内的所有openFolderStatus
    log.showInfo('updateFolderData start openFolderStatus = %{public}d', this.openFolderStatus);
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    if (this.openFolderStatus === FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_START) {
      return;
    }
    if (this.openFolderStatus === FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END) {
      if (this.isDragOutFolderPendingClose) {
        this.isDragOutFolderPendingClose = false;
      }
      return;
    }
    if (this.openFolderStatus === FeatureConstants.FOLDER_STATUS_PENDING_CLOSE) {
      log.showInfo('updateFolderData pending close');
      this.isDragOutFolderPendingClose = true;
      return;
    }

    if (this.openFolderStatus === FeatureConstants.FOLDER_STATUS_REQUEST_CLOSE) {
      log.showInfo('updateFolderData request close');
      localEventManager.sendLocalEvent(EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_CLOSE);
      if (this.isRenaming) {
        this.saveText();
        ContractedFolderLayoutViewModel.getInstance()
          .updateOpenFolderStatus(FeatureConstants.OPEN_FOLDER_STATUS_STATIC);
        return;
      }
      this.swiperController?.finishAnimation();
      this.gestureCloseFolder();
      return;
    }
    if (!this.isRenaming) {
      this.newFolderName = openFolderData.folderName as string;
    }
    if (this.openFolderStatus == FeatureConstants.OPEN_FOLDER_STATUS_STATIC) {
      // 文件夹打开的时候应该进行图标显示范围的截取
      // 关闭的时候进行动效不应该进行图标显示范围的截取
      return;
    }
    if (this.openFolderStatus == FeatureConstants.OPEN_FOLDER_STATUS_CLOSE) {
      this.hideOpenFolder();

      // 关闭文件夹时结束当前正在进行的落位动效
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      if (!CloseAppManager.getInstance().getIsMinimizeAllSceneClosingFolder()) {
        SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      } else {
        CloseAppManager.getInstance().resetIsMinimizeAllSceneClosingFolder();
      }
      const deviceType: string = AppStorage.get<string>('device') as string;
      if (deviceType !== CommonConstants.DEFAULT_DEVICE_TYPE) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE, null);
      }
      this.newFolderName = '';
      this.folderNameAppearDuration = FoldAnimationConstants.ANIMATION_DURATION_100;
      this.folderNameDisappearDuration = 100;

      AppStorage.setOrCreate('folderAppListDialogStatus', false);
      AppStorage.setOrCreate('openFolderId', '-1');
      return;
    }
    ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(FeatureConstants.OPEN_FOLDER_STATUS_STATIC);
    log.showInfo('updateFolderData end');
  }

  private gestureCloseFolder() {
    // back手势，文件夹+dialog显示时不关闭文件夹，并置回状态防止再次back无法关闭文件夹。
    // 后续需要整改，去掉AppStorage设置文件夹状态的使用。
    if (this.mFolderViewModel.getCloseType() === FolderCloseType.BACK_GESTURE && folderGesData.isAddDialogOpening()) {
      log.showInfo('gestureCloseFolder return for dialog opened.');
      ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(FeatureConstants.OPEN_FOLDER_STATUS_STATIC);
      return;
    }
    OpenCloseViewModel.getInstance().close('gesture to close', FolderOperationFlag.NONE);
  }

  saveText(): void {
    log.showInfo('saveText isRenaming:%{public}s', this.isRenaming);
    let isNameChanged: boolean = false;
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let isSmallFolder: boolean = GridLayoutUtil.isSmallFolder(openFolderData);
    if (this.isRenaming) {
      this.folderNameAppearDuration = 0;
      this.folderNameDisappearDuration = 0;
      animateTo({ duration: 0 }, () => {
        this.isRenaming = false;
      })
      if (this.newFolderName && this.newFolderName.trim() !== '' && this.newFolderName !==
        this.mFolderViewModel.getRealFolderName(openFolderData.folderName)) {
        openFolderData.folderName = this.newFolderName.trim();
        // 此处是解决用户输入特殊串导致替换的问题
        if (openFolderData.folderName.startsWith('${')) {
          openFolderData.folderName = ' ' + openFolderData.folderName;
        }
        ContractedFolderCommonViewModel.getInstance()
          .updateFolderName('modify name', openFolderData.folderId, openFolderData.folderName);
        isNameChanged = true;
      }
      let entrance: string = openFolderData?.enterEditing ? 'close' : 'open';
      HiSysEventUtil.reportRenameFolder(openFolderData.folderId, !isSmallFolder,
        isNameChanged, entrance);
    } else {
      OpenCloseViewModel.getInstance().close('modify name to close', FolderOperationFlag.NONE);
    }
    InputMethodManager.getInstance().stopInput();
  }

  private onCloseFolder(): void {
    log.showDebug('onCloseFolder');
    this.updateIsShowOpenFolderAddSheet(false);
  }

  private hideOpenFolder() {
    log.showInfo('hideOpenFolder start');
    this.isRenaming = false;
    this.openFolderStatus = FeatureConstants.OPEN_FOLDER_STATUS_CLOSE;
    this.updateIsShowOpenFolderAddSheet(false);
    log.showInfo('hideOpenFolder end');
  }

  private async setFocusManual() {
    setTimeout(() => {
      focusControl.requestFocus(this.textInputKey)
    }, 30);
  }

  public updateSwiperColor(): void {
    let wallpaperColorManager: WallpaperColorManager = WallpaperColorManager.getInstance()
    let textColor: TextColor | undefined = wallpaperColorManager.mTextColor;
    this.swiperColor = wallpaperColorManager.mSwiperColor;
    this.swiperSelectedColor = wallpaperColorManager.mSwiperSelectedColor;
    this.folderNameColor = wallpaperColorManager.mTextColor?.mTextColor;
    this.cancelAppImage = this.folderNameColor === FolderStyleConstants.DEFAULT_FONT_COLOR ?
    FolderStyleConstants.DEFAULT_CANCEL_APP_IMAGE : FolderStyleConstants.DEFAULT_CANCEL_APP_BLACK_IMAGE;
  }

  @Builder
  OpenFolderAddSheet(folder: GridLayoutItemInfo) {
    Column() {
      OpenFolderAddDialog({
        isShow: this.isShowOpenFolderAddSheet,
        onIsShowChange: this.updateIsShowOpenFolderAddSheet,
        openedBy: this.openFolderAddSheetBy,
        folderItem: folder
      })
    }
  }

  build() {
    Column() {
      if (this.gridSwiperLayout.isShowOpenFolder) {
        OpenFolderGridSwiper({
          swiperController: this.swiperController,
          swiperSelectedColor: this.swiperSelectedColor,
          swiperColor: this.swiperColor,
          pageIndex: this.pageIndex,
          isRenaming: this.isRenaming,
          newFolderName: this.newFolderName,
          folderNameColor: this.folderNameColor,
          cancelAppImage: this.cancelAppImage,
          textInputKey: this.textInputKey,
          setFocusManual: this.setFocusManual,
          isGeometryTransiting: this.isGeometryTransiting,
          isDragOutFolderPendingClose: $isDragOutFolderPendingClose,
          folderNameAppearDuration: this.folderNameAppearDuration,
          folderNameDisappearDuration: this.folderNameDisappearDuration,
          saveText: (): void => this.saveText(),
          isSwiperClipForce: this.isSwiperClipForce
        })
        // 文件夹复用入口屏蔽.reuseId(`${TAG}_${this.mFolderInfo.folderId}`)
      }
    }
    .bindSheet($$this.isShowOpenFolderAddSheet,
      this.OpenFolderAddSheet(this.mFolderMgr.getFolder(this.mFolderIdAddSheet).getGridInfo()), {
        height: SheetSize.MEDIUM,
        uiContext: this.getUIContext(),
        mode: SheetMode.OVERLAY,
        scrollSizeMode: ScrollSizeMode.CONTINUOUS,
        title: {
          title: (this.openFolderAddSheetBy === FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE) ?
            $r('app.string.folder_add') : $r('app.string.sheet_title_similar')
        },
        backgroundColor: Color.Grey,
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        preferType: SheetType.CENTER,
        onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
          dismissSheetAction.dismiss();
          this.updateIsShowOpenFolderAddSheet(false);
        }),
      })
  }
}
