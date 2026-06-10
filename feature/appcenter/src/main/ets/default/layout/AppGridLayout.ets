/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
  AppItemInfo,
  AppStatus,
  CardItemInfo,
  CloseAppManager,
  FormCenterViewManager,
  FormModel,
  LayoutViewModel,
  ReceiveEventInfo,
  ShortcutViewModel,
  AppCenterModel,
  AppLockUtils
} from '@ohos/launchercommon';
import { LogDomain, LogHelper, CheckEmptyUtils, StartType, SingleContext } from '@ohos/basicutils'
import { windowManager } from '@ohos/componentdrag'
import { SCBConstants, DragConstants } from '@ohos/commonconstants'
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene'
import { GlobalContext, localEventManager, HiSysEventUtil, ApsUtils, ViewType } from '@ohos/frameworkwrapper'
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
import type ctx from '@ohos.app.ability.common';
import { StyleConstants } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { EventConstants } from '@ohos/launchercommon';
import { UninstallDialog } from '@ohos/launchercommon/src/main/ets/uicomponents/UninstallDialog';
import { MenuInfo } from '@ohos/launchercommon';
import { StartSubtype } from '@ohos/launchercommon';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { FormManagerDialog } from '@ohos/form';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { AppCenterAppGrid } from './AppCenterAppGrid';
import { AppCenterGridStyleConfig } from '../common/AppCenterGridStyleConfig';
import { AppGridPresenter } from '../common/presenter/AppGridPresenter';
import { AppLayoutInfo } from '../common/viewmodel/AppLayoutInfo';
import { AppCenterViewModel } from '../common/viewmodel/AppCenterViewModel';
import { AppListPresenter } from '../common/presenter/AppListPresenter';
import { AppCenterDragMgr } from '../controller/AppCenterDragMgr';
import AppGridLayoutUtil from '../common/util/AppGridLayoutUtil';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import { AppCenterDropFrame } from './AppCenterDropFrame';
import { curves } from '@kit.ArkUI';
// import apsManager from '@hms.graphic.apsManager';
import { AppCenterSearchResultTask } from '../common/model/AppCenterSearchResultTask';
import { FoldedDeviceAcViewModel, FoldStatusChangeEvent, SCBFoldedState } from '../folded/FoldedDeviceAcViewModel';
import FeatureConstants from '../common/constants/FeatureConstants';
import { APP_CENTER_SWIPER_KEY } from '../constants/LayoutConstants';
import { LazyDataSource } from '@ohos/launchercommon/src/main/ets/uicomponents/LazyDataSource';

const TAG = 'AppGridLayout';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const COLOR_ARROW = '#19ffffff';
const COLOR_ARROW_PRESS = '#26ffffff';
const SIZE_ARROW = '32vp';
const SIZE_ARROW_BACKGROUND = '40vp';
const INDICATOR_MARGIN_BOTTOM = '54';
const SWAP_PAGE_DELAY: number = 1000;
const SWAP_PAGE_DELAY_HPR: number = 700;
const MOVE_NEXT_DELAY: number = 500;
const HOT_EREA_ADJUSTMENT:number = 50;
const CROSS_SCREEN: string = 'crossScreen';
const UNINSTALLDIALOG_FOLDED_B_APP: Offset = { dx: 0, dy: -465 }; // hopper 折叠屏无磁吸键盘时B屏弹窗，在B屏
const UNINSTALLDIALOG_FOLDED_C_APP: Offset = { dx: 0, dy: 465 };
const UNINSTALLDIALOG_FOLDED_B_KEYBOARD_APP: Offset = { dx: 0, dy: 0 }; // hopper 折叠屏时磁吸键盘B屏弹窗，在B屏
const UNFOLDED_VERTICAL_INDICATOR_HEIGHT: number = 875;
const UNFOLDED_HORIZONAL_INDICATOR_HEIGHT: number = 674;
const DEFAULT_INDICATOR_HEIGHT: number = 435;
const DEFAULT_INDICATOR_RIGHT_HPR: number = 67;
const DEFAULT_INDICATOR_RIGHT_HORIZONTAL_HPR: number = 72;
const INDICATOR_ANIM_DURATION = 400;

@Component
export struct AppGridLayout {
  @State
  columns: number = StyleConstants.DEFAULT_APP_GRID_COLUMN;
  @State
  rows: number = StyleConstants.DEFAULT_APP_GRID_ROW;
  @Link screenProp: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @State pages: number[] = [];
  @StorageLink('appCenterLayoutInfo') @Watch('appLayoutInfoChange')
  appGridList: AppLayoutInfo[] = [];
  @StorageLink('openAppCenterPageIndex')
  pageIndex: number = 0;
  private searchPageIndex: number = 0;
  @StorageLink('isDropAnimationGoing') @Watch('onDropAnimationStatusChanged') isDropAnimationGoing: boolean = false;
  private appGridPresenter: AppGridPresenter | null = null;
  private gridStyleConfig: AppCenterGridStyleConfig | undefined = undefined;
  private mLayoutVM: LayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
  private selectItem: AppItemInfo | null = null;
  private clearForm?: Function;
  private readonly mFormModel: FormModel = FormModel.getInstance();
  @StorageLink('isAppCenterShow')
  @Watch('onAppCenterShow') isAppCenterShow: boolean = false;
  @Link @Watch('onSearchInputChange')
  searchInputText: string;
  @State isShowEmptyStatus: boolean = false;
  @State arrowLeftIsHover: boolean = false;
  @State arrowRightIsHover: boolean = false;
  private swiperController: SwiperController = new SwiperController();
  private sreachSwiperController: SwiperController = new SwiperController();
  @Prop isGainFocus: boolean = false;
  @State showDropFrame: boolean = true;
  private apsApsSessionId: string = '';
  private swapPageDelayTime: number = 0;
  private isCrossScreenTimerId: boolean = false;
  @State indicatorHeightForFoldedDevice: number = this.getIndicatorHeight();

  @State searchAppPageList?: LazyDataSource<AppLayoutInfo> = new LazyDataSource<AppLayoutInfo>();
  @State updateTag: boolean = false;
  @State swiperEnabled: boolean = true;
  @State needTwoArrow: boolean = true;
  @State swiperItemSpace: number = 0;
  @State swiperDsCount: number = 1;
  @State swiperMultiPages: boolean = false;
  @State swiperVertical: boolean = false;
  @State swiperPaddingBottom: number = 0;
  @State columnHeightOfAppCenter: Length = StyleConstants.PERCENTAGE_100;
  private appItemPosX: number[] = [];
  private rtlAppItemPosX: number[] = [];
  private appItemPosY: number[] = [];
  private appItemOpacity: number[] = [];
  private bkOpacity: number = 0;
  swiperPaddingTop = 0;
  private swiperCachedCount: number = 1;
  private movePageTimerId: number | undefined = undefined;
  // 搜索任务map key:index value:cancelFlag
  private searchTask: Map<string, boolean> = new Map();
  private dialogController: CustomDialogController = this.getDialogController();
  private dialogHalfFoldedBController: CustomDialogController = this.getDialogController(UNINSTALLDIALOG_FOLDED_B_APP);
  private dialogHalfFoldedCController: CustomDialogController = this.getDialogController(UNINSTALLDIALOG_FOLDED_C_APP);
  private dialogHalfFoldedBKeyBoardController: CustomDialogController =
    this.getDialogController(UNINSTALLDIALOG_FOLDED_B_KEYBOARD_APP);
  private currentScreenHeight: number = this.screenProp.height;
  private currentScreenWidth: number = this.screenProp.width;
  @Link @Watch('handleEnterKeyEvent') isEnterKeyEvent: boolean;
  @State lazyAppLayPageInfo: LazyDataSource<AppLayoutInfo> = new LazyDataSource<AppLayoutInfo>();

  private handleEnterKeyEvent(): void {
    if (!this.isEnterKeyEvent) {
      log.showInfo('handleEnterKeyEvent-not enter key');
      return;
    }
    this.isEnterKeyEvent = false;
    if (!this.searchInputText || this.searchAppPageList?.totalCount() !== 1) {
      log.showInfo(`handleEnterKeyEvent-two pages-${this.searchInputText}`);
      return;
    }
    if (this.searchAppPageList?.getData(0).pageInfo.length !== 1) {
      log.showInfo(`handleEnterKeyEvent-two apps-${this.searchInputText}`);
      return;
    }
    let appItemInfo: AppItemInfo = this.searchAppPageList.getData(0).pageInfo[0];
    log.showInfo(`handleEnterKeyEvent-${this.searchInputText}`);
    if (AppCenterViewModel.getInstance().isChangedAfterEnter(this.searchInputText)) {
      log.showInfo('handleEnterKeyEvent-enter key but not for open app');
      AppCenterViewModel.getInstance().updateSearchInputTextBeforeEnter(this.searchInputText);
      return;
    }
    this.appGridItemClickCallback(appItemInfo);
    AppCenterViewModel.getInstance().updateSearchInputTextBeforeEnter(this.searchInputText);
  }

  public getDialogController(offset?: Offset): CustomDialogController {
    let dialogController: CustomDialogController = new CustomDialogController({
      builder: UninstallDialog({
        singleContext: this.singleContext,
        cancel: () => {
          this.doCloseUninstallDialog();
        },
        confirm: () => {
          this.onAccept()
        },
        dialogName: this.getUninstallDialog(),
        isFromAppCenter: true,
        isBusinessStyle: true,
        bundleName: this.selectItem?.bundleName
      }),
      cancel: () => {
      },
      autoCancel: true,
      customStyle: true,
      showInSubWindow: true,
      offset: offset ?? { dx: 0, dy: 0 }
    });
    return dialogController;
  }

  private openUninstallDialog(item: AppItemInfo): void {
    if (item === undefined || item === null) {
      log.showInfo(`item is null.`);
      return;
    }
    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      this.dialogController.open();
      return;
    }

    // HOPPER折叠屏，磁吸键盘，在B屏显示子窗
    if (FoldedDeviceAcViewModel.getInstance().isKeyboardOnCSide()) {
      this.dialogHalfFoldedBKeyBoardController.open();
      return;
    }

    // HOPPER折叠屏，无磁吸键盘，在B屏显示子窗
    if (FoldedDeviceAcViewModel.getInstance().isHalfFolded()) {
      if (item.page !== undefined && item.page % 2 === 0) {
        this.dialogHalfFoldedBController.open();
        return;
      }
      this.dialogHalfFoldedCController.open();
      return;
    }
    if (FoldedDeviceAcViewModel.getInstance().isHalfFoldedVirtualKeyboard()) {
      this.dialogHalfFoldedBController.open();
      return;
    }
    this.dialogController.open();
  }

  private doCloseUninstallDialog(): void {
    this.dialogController.close();
    this.dialogHalfFoldedBController.close();
    this.dialogHalfFoldedCController.close();
    this.dialogHalfFoldedBKeyBoardController.close();
  }
  private readonly foldStateChangeListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: FoldStatusChangeEvent): void => {
      log.showInfo(`hopper state change event received: ${event}, params: ${JSON.stringify(params)}`);
      let cs: number = params.curState;
      let ts: number = params.tarState;
      this.doIndicatorAnimationForFoldedDevice();
      AppGridLayoutUtil.setExtraPaddingTopOffset(
        FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getSwiperItemSpace(), this.screenProp.screenId);
      this.resetSwiperDsCount(ts);
      this.resetColumnHeightOfAppCenter();
      if (cs === SCBFoldedState.UNFOLDED_VERTICAL && ts === SCBFoldedState.UNFOLDED_HORIZONTAL ||
        cs === SCBFoldedState.UNFOLDED_HORIZONTAL && ts === SCBFoldedState.UNFOLDED_VERTICAL) {
        this.refreshAppGridLayout();
        AppGridLayoutCacheManager.getInstance().sortAllData();
        this.updateLazyAppPageInfo(AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemList());
        AppCenterDragMgr.getInstance().updateAppCenterLayoutInfo(FeatureConstants.AC_SCENE_LANDSCAPE_PORTRAIT_SWITCH);
        log.showInfo(`hopper state change-${this.lazyAppLayPageInfo.totalCount()}`);
      }
      if (ts === SCBFoldedState.HALF_FOLDED) {
        if (this.gridStyleConfig) {
          FoldedDeviceAcViewModel.getInstance(
            this.screenProp.screenId).recalculateAcDraggableAreaBottom(this.gridStyleConfig);
        }
        AppCenterDragMgr.getInstance().updateAppCenterDragData(this.screenProp.screenId, true,
          this.screenProp.width, this.screenProp.height);
        log.showInfo(`hopper state changed to half-folded`);
      }
      this.doCloseUninstallDialog();
      log.showInfo(`hopper state change - ${cs}-${ts}`);
    }
  };
  formManagerDialogController: CustomDialogController = new CustomDialogController({
    builder: FormManagerDialog({
      singleContext: this.singleContext,
      cancel: (callback?: Function) => {
        // delete all form
        if (callback !== undefined) {
          this.clearForm = callback;
        } else {
          log.showError('FormManagerDialog callback error'); // 维测日志
        }
      },
      confirm: (formCardItem: CardItemInfo) => {
        // add form to desktop
        log.showInfo(`createCardToDeskTop formCardItem: ${JSON.stringify(formCardItem)}`);
        PageDesktopViewModel.getInstance(this.singleContext).createCardToDeskTop(formCardItem);
        // delete other form
      },
      bundleName: AppStorage.get<AppItemInfo>('formAppInfo')?.bundleName,
      appName: AppStorage.get<AppItemInfo>('formAppInfo')?.appName,
      appLabelId: AppStorage.get<AppItemInfo>('formAppInfo')?.applicationLabelId,
      isPcEditCard: AppStorage.get<string>('device') !== CommonConstants.DEFAULT_DEVICE_TYPE
    }),
    cancel: this.cancelFormDialog,
    autoCancel: true,
    customStyle: true,
    showInSubWindow: true
  });
  private openAppEnable: boolean = true;

  public aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.initSwapPageDelayTime();
    this.appGridPresenter = AppGridPresenter.getInstance();
    if (this.screenProp.screenId === 0) {
      this.appGridPresenter.loadAppCenterData();
    }
    // 生命周期开始时appGridList，转成LazyDataSource类型，避免扩展屏应用中心图标为空
    this.updateLazyAppPageInfo(this.appGridList);
    this.gridStyleConfig = AppCenterViewModel.getInstance().getAppGridStyleConfig(this.screenProp.screenId);
    AppCenterViewModel.getInstance().setSwiperController(this.swiperController, this.screenProp.screenId);
    LayoutViewModel.getInstance(this.singleContext)
      .registerRefreshLayoutCallback(this.screenProp.screenId, this.refreshAppGridLayout);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    this.registerEventHub();
    this.refreshAppGridLayout();
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      this.initFoldDevice();
      localEventManager.registerEventListener(this.foldStateChangeListener,
        [FoldedDeviceAcViewModel.FOLD_STATE_CHANGE_EVT_NAME]);
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.unRegisterEventHub();
    LayoutViewModel.getInstance(this.singleContext)
      .unregisterRefreshLayoutCallback(this.screenProp.screenId, this.refreshAppGridLayout);
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      localEventManager.unregisterEventListener(this.foldStateChangeListener);
    }
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    // 在生命周期结束之后进行数据清理，避免OOM
    this.lazyAppLayPageInfo?.clear();
    this.searchAppPageList?.clear();
    this.doCloseUninstallDialog();
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.screenProp.screenId !== screenProperty.screenId) {
      log.showInfo(`screen id not equal: ${this.screenProp.screenId} ${screenProperty.screenId}`);
      return;
    }
    if (this.currentScreenHeight === screenProperty.height &&
      this.currentScreenWidth === screenProperty.width) {
      log.showInfo('screen width or height not change');
      return;
    }
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      log.showInfo('fold device');
      return;
    }
    if (!this.mLayoutVM) {
      this.mLayoutVM = LayoutViewModel.getInstance(this.singleContext);
    }
    this.currentScreenHeight = screenProperty.height;
    this.currentScreenWidth = screenProperty.width;
    this.gridStyleConfig?.initConfig(screenProperty.screenId, true, screenProperty.width, screenProperty.height);
    this.initGridPosition(screenProperty.screenId);
    // 更新应用中心拖拽数据
    AppCenterDragMgr.getInstance().updateAppCenterDragData(
      screenProperty.screenId, true, screenProperty.width, screenProperty.height);
    log.showInfo(`onScreenPropertyChange ${screenProperty.width} ${screenProperty.height}`);
  }

  onAppCenterShow(): void {
    log.showInfo(`onAppCenterShow ${this.isAppCenterShow}`);
    if (!this.isAppCenterShow) {
      this.swiperEnabled = false;
      return;
    } else {
      this.swiperEnabled = true;
    }
    this.openAppEnable = true;
  }

  private getViewType(): ViewType {
    return this.isMainScreen(this.screenProp.screenId) ? ViewType.APP_CENTER : ViewType.APP_CENTER_EXT;
  }

  private isMainScreen(screenId: number): boolean {
    return SCBSceneSessionManager.getInstance().mainScreenId === screenId;
  }

  private initFoldDevice(): void {
    this.needTwoArrow = false;
    this.swiperItemSpace = 20;
    this.swiperDsCount = 2;
    this.swiperMultiPages = true;
    this.swiperVertical = true;
    this.swiperCachedCount = 1;
    this.resetSwiperDsCount(FoldedDeviceAcViewModel.getInstance().getCurrentFoldState());

    // 只有主屏才会走的场景，折叠态重启开机
    if (FoldedDeviceAcViewModel.getInstance().isHalfFolded()) {
      AppGridLayoutUtil.setExtraPaddingTopOffset(
        FoldedDeviceAcViewModel.getInstance().getSwiperItemSpace(), this.screenProp.screenId);
    }
  }

  private resetSwiperDsCount(cs: number): void {
    if (cs === SCBFoldedState.UNFOLDED_VERTICAL) {
      log.showInfo(`hopper state change - to unfolded_vertical`);
      this.swiperDsCount = 2;
      this.swiperMultiPages = true;
    } else if (cs === SCBFoldedState.UNFOLDED_HORIZONTAL) {
      log.showInfo(`hopper state change - to unfolded_horizontal`);
      this.swiperDsCount = 2;
      this.swiperMultiPages = true;
    } else if (cs === SCBFoldedState.HALF_FOLDED) {
      log.showInfo(`hopper state change - to half_folded`);
      this.swiperDsCount = 2;
      this.swiperMultiPages = true;
    } else {
      log.showInfo(`hopper state change - to other state`);
      this.swiperDsCount = 1;
      this.swiperMultiPages = false;
    }
    log.showInfo(`hopper curstate - ${cs}, setSwiperDsCount to ${this.swiperDsCount}`);
  }

  private refreshAppGridLayout = () => {
    this.gridStyleConfig?.initConfig(this.screenProp.screenId, true, this.screenProp.width, this.screenProp.height);
    this.initGridPosition(this.screenProp.screenId);
    // 更新应用中心拖拽数据
    AppCenterDragMgr.getInstance().updateAppCenterDragData(
      this.screenProp.screenId, true, this.screenProp.width, this.screenProp.height);
  }

  private getUninstallDialog(): string | Resource {
    if (this.selectItem?.appIndex !== undefined && this.selectItem?.appIndex > 0) {
      return $r('app.string.is_delete', this.selectItem?.appName)
    } else {
      return $r('app.string.isUninstall', this.selectItem?.appName)
    }
  }

  private getPaddingTop(): number {
    if (!this.gridStyleConfig) {
      log.showInfo('getPaddingTop-cfg null');
      return 0;
    }

    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return this.gridStyleConfig.mAppCenterMarginTop + FoldedDeviceAcViewModel.getInstance(
        this.screenProp.screenId).getAcGridPaddingTop();
    } else {
      return this.gridStyleConfig.mAppCenterMarginTop;
    }
  }

  private getItemSpace(): number {
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return FoldedDeviceAcViewModel.getInstance(this.screenProp.screenId).getSwiperItemSpace();
    } else {
      return 0;
    }
  }

  private initGridPosition(screenId: number = 0): void {
    if (this.gridStyleConfig) {
      log.showInfo(`initGridPosition-${JSON.stringify(this.gridStyleConfig)} ${screenId}`);
      AppGridLayoutUtil.initGridPositionRound({
        // 配置整数
        paddingLeft: this.gridStyleConfig.mAppCenterMarginLeft,
        // 配置整数
        paddingTop: this.getPaddingTop(),
        // 计算整数
        row: this.gridStyleConfig.mRows,
        // 计算整数
        column: this.gridStyleConfig.mColumns,
        // 配置整数
        rowGap: this.gridStyleConfig.mRowsGap,
        // 配置整数
        columnGap: this.gridStyleConfig.mColumnsGap,
        // 计算值，不确保整数
        gridWidth: this.gridStyleConfig.mGridWidth,
        // 计算值，不确保整数
        gridHeight: this.gridStyleConfig.mGridHeight
      }, {
        paddingTop: this.gridStyleConfig.mRowsGap / StyleConstants.DEFAULT_2,
        paddingBottom: this.gridStyleConfig.mRowsGap / StyleConstants.DEFAULT_2,
        paddingLeft: this.gridStyleConfig.mColumnsGap / StyleConstants.DEFAULT_2,
        paddingRight: this.gridStyleConfig.mColumnsGap / StyleConstants.DEFAULT_2
      }, this.getItemSpace(), screenId);
    }
  }

  registerEventHub(): void {
    this.getContext()?.eventHub.on(DragConstants.WHITE_BOX_CHANGE_EVENT, (state: boolean) => {
      AppCenterDragMgr.getInstance().setWhiteBoxState(state);
      AppCenterDragMgr.getInstance().initCurrentMouse();
    });
  }

  unRegisterEventHub(): void {
    this.getContext()?.eventHub.off(DragConstants.WHITE_BOX_CHANGE_EVENT);
  }

  private onDropAnimationStatusChanged(): void {
    log.showInfo(`onDropAnimationStatusChanged isDropAnimationGoing ${this.isDropAnimationGoing} isAnimating ${AppCenterDragMgr.getInstance().isAnimating()}`);
    if (!this.isDropAnimationGoing && AppCenterDragMgr.getInstance().isAnimating()) {
      AppCenterDragMgr.getInstance().onDropAnimationEnd(false);
    }
  }

  private cancelFormDialog() {
    log.showInfo('cancel form dialog');
    this.clearForm?.();
  }

  private appLayoutInfoChange(): void {
    log.showInfo('appLayoutInfoChange start');
    this.pages = AppGridLayoutCacheManager.getInstance().getPages();
    this.appGridList?.forEach((pageInfo: AppLayoutInfo) => {
      pageInfo?.pageInfo?.forEach((itemInfo: AppItemInfo) => {
        log.showInfo(`appLayoutInfoChange: bundleName: ${itemInfo?.bundleName}, column: ${itemInfo?.column}, row: ${itemInfo?.row}, page: ${itemInfo?.page}`);
      });
    });
    log.showInfo(`appLayoutInfoChange end. appGridList.length: ${this.appGridList?.length}, ${this.pages}`);
    // 原appGridList转成datalazysource类型
    this.updateLazyAppPageInfo(this.appGridList);
  }

  /**
   * 延迟翻页
   * @param callback
   */
  private movePageTimer(callback: () => void, reason?: string) {
    if (reason === CROSS_SCREEN) {
      if ((this.movePageTimerId) && !this.isCrossScreenTimerId) {
        this.clearMovePageTimer();
        this.isCrossScreenTimerId = true;
      }
      if (!this.movePageTimerId) {
        this.movePageTimerId = setTimeout(() => {
          if (!AppCenterDragMgr.getInstance().isAnimating()) {
            callback();
          }
          this.movePageTimerId = undefined;
          this.isCrossScreenTimerId = false;
        }, MOVE_NEXT_DELAY);
      }
    } else {
      if (!this.movePageTimerId) {
        this.movePageTimerId = setTimeout(() => {
          if (!AppCenterDragMgr.getInstance().isAnimating()) {
            callback();
          }
          this.movePageTimerId = undefined;
        }, MOVE_NEXT_DELAY);
      }
    }
  }

  /**
   * 清除定时器
   */
  private clearMovePageTimer(): void {
    if (this.movePageTimerId) {
      clearTimeout(this.movePageTimerId);
      this.movePageTimerId = undefined;
    }
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  private onAccept(): void {
    if (this.selectItem == null) {
      return;
    }
    let bundleName: string = this.selectItem.bundleName === undefined ? '' : this.selectItem.bundleName;
    let isUninstallAble: boolean = this.selectItem.isUninstallAble === undefined ? false :
    this.selectItem.isUninstallAble;
    let appIndex: number = this.selectItem?.appIndex ?? 0;
    this.appGridPresenter?.uninstallApp(bundleName, isUninstallAble, appIndex);
    this.doCloseUninstallDialog();
    this.searchInputText = '';
  }

  private buildMenuInfoList(appInfo: AppItemInfo): MenuInfo[] {
    let menuInfoList = new Array<MenuInfo>();
    if (appInfo === undefined) {
      return menuInfoList;
    }
    let bundleName: string = appInfo.bundleName === undefined ? '' : appInfo.bundleName;

      let open = new MenuInfo();
      open.menuType = CommonConstants.MENU_TYPE_FIXED;
      open.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
      open.menuText = $r('app.string.app_menu_open');
      open.onMenuClick = (params: Map<string, Object>) => {
        CloseAppManager.getInstance().setStartAppType(StartType.APP_CENTER_APP, undefined,
          CommonConstants.APPCENTER_ICON_EXTRA_ID);
        CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.ICON_FROM_APP_CENTER);
        let abilityName: string = appInfo.abilityName === undefined ? '' : appInfo.abilityName;
        let moduleName: string = appInfo.moduleName === undefined ? '' : appInfo.moduleName;
        params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
        if (appInfo?.enableNewAppInstance) {
          log.showInfo('is multiInstance:' + bundleName);
          params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
        }
        params.set(SCBConstants.OPEN_IN_NEW_WINDOW, true);
        if (appInfo?.appIndex !== undefined && appInfo?.appIndex > 0) {
          params.set(SCBConstants.START_APP_CLONE_INDEX, appInfo?.appIndex);
        }
        this.appGridPresenter?.jumpTo(abilityName, bundleName, moduleName, params, this.screenProp.screenId);
        if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
          let hideAppCenterWithAnimation = (GlobalContext.getInstance()
            .getObject('hideAppCenterWithAnimation')) as Function;
          hideAppCenterWithAnimation(this.screenProp.screenId);
        }
        windowManager.hideWindow(windowManager.RECENT_WINDOW_NAME);
        log.showInfo('click menu item add to open entry, bundleName = ' + appInfo.bundleName);
      };
      menuInfoList.push(open);

      const formInfoList = this.mFormModel.getAppItemFormInfo(appInfo.bundleName as string,
        item => this.mFormModel.isFormCenterSupportCard(item));
      // 后续和副屏桌面工作区需求同步上
      if (this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
        if (!CheckEmptyUtils.isEmptyArr(formInfoList)) {
          let addFormToDeskTopMenu = new MenuInfo();
          addFormToDeskTopMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
          addFormToDeskTopMenu.menuImgSrc = '/common/pics/ic_form_center.svg';
          addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop');
          addFormToDeskTopMenu.onMenuClick = (appParams?: Map<string, Object>): void => {
            log.showInfo(`add_form AppCenter`);
            let param: FormCenterViewParam = new FormCenterViewParam();
            param.bundleName = appInfo.bundleName;
            param.entrancePosition = FormCenterViewManager.getInstance().getEntrancePos(appInfo);
            FormCenterViewManager.getInstance().openFormCenterView(param);
            let hideAppCenterWithAnimation = (GlobalContext.getInstance()
              .getObject('hideAppCenterWithAnimation')) as Function;
            hideAppCenterWithAnimation(this.screenProp.screenId);
          };
          menuInfoList.push(addFormToDeskTopMenu);
        }
      }


    let addToDockMenu = new MenuInfo();
    addToDockMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    addToDockMenu.menuImgSrc = '/common/pics/ic_public_copy.svg';
    addToDockMenu.menuText = $r('app.string.app_center_menu_add_dock');
    addToDockMenu.onMenuClick = () => {
      HiSysEventUtil.reportEventById(bundleName, 'appCenter add to dock');
      if (typeof (appInfo.typeId) === 'undefined') {
        // 应用中心typeId的默认为app
        appInfo.typeId = CommonConstants.TYPE_APP;
      }
      log.showInfo(`click menu item add to Dock entry, bundleName = ${appInfo.bundleName} appindex:${appInfo.appIndex}` );
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD, appInfo);
    };
    menuInfoList.push(addToDockMenu);

      // 后续和副屏桌面工作区需求同步上
      if (this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
        let addToDeskMenu = new MenuInfo();
        addToDeskMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
        addToDeskMenu.menuImgSrc = '/common/pics/ic_public_copy.svg';
        addToDeskMenu.menuText = $r('app.string.app_center_menu_add_desktop');
        addToDeskMenu.onMenuClick = () => {
          log.showInfo(`click menu item add to Desktop entry, bundleName = ${appInfo.bundleName} appindex:${appInfo.appIndex}` );
          HiSysEventUtil.reportEventById(bundleName, 'appCenter add to desktop');
          appInfo.keyName =
            appInfo.bundleName + appInfo.abilityName + appInfo.moduleName + appInfo.appIndex;
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD, appInfo);
        };
        menuInfoList.push(addToDeskMenu);
      }

    if (appInfo.isUninstallAble) {
      let uninstallMenu = new MenuInfo();
      uninstallMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      uninstallMenu.menuImgSrc = '/common/pics/ic_public_delete.svg';
      if (appInfo.appIndex !== undefined && appInfo.appIndex > 0) {
        uninstallMenu.menuText = $r('app.string.delete');
      } else {
        uninstallMenu.menuText = $r('app.string.uninstall');
      }
      uninstallMenu.onMenuClick = (): void => {
        log.showInfo(`click menu item uninstall: ${appInfo.bundleName}`);
        let appName = this.appGridPresenter?.getAppName(appInfo);
        if (appName != null) {
          appInfo.appName = appName;
        }
        this.selectItem = appInfo;
        this.openUninstallDialog(appInfo);
        AppStorage.setOrCreate('uninstallAppInfo', appInfo);
      };
      uninstallMenu.menuEnabled = appInfo.isUninstallAble;
      menuInfoList.push(uninstallMenu);
    }

    ShortcutViewModel.getInstance().checkShortCutInfo(appInfo, menuInfoList, this.screenProp.screenId);

    let appLockMenu: MenuInfo | undefined = AppLockUtils.getInstance().buildAppLockMenu(appInfo);
    if(appLockMenu !== undefined) {
      menuInfoList.push(appLockMenu);
    }

    return menuInfoList;
  }

  private appGridItemClickCallback(item: AppItemInfo): void {
    if (!this.openAppEnable || !AppCenterModel.getInstance().isShow(this.screenProp.screenId)) {
      log.showWarn(`appGridItemClickCallback return. ${this.openAppEnable}`);
      return;
    }
    this.openAppEnable = false;
    CloseAppManager.getInstance().setStartAppType(StartType.APP_CENTER_APP, undefined,
      CommonConstants.APPCENTER_ICON_EXTRA_ID);
    CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.ICON_FROM_APP_CENTER);
    let abilityName: string = item.abilityName === undefined ? '' : item.abilityName;
    let bundleName: string = item.bundleName === undefined ? '' : item.bundleName;
    let moduleName: string = item.moduleName === undefined ? '' : item.moduleName;
    log.showInfo(`open app abilityName: ${JSON.stringify(item)}`);
    log.showInfo(`open app abilityName: ${item?.appIndex}`);
    let params = new Map<string, Object>();
    if (item?.appIndex !== undefined && item?.appIndex > 0) {
      params.set(SCBConstants.START_APP_CLONE_INDEX, item?.appIndex);
    }
    this.appGridPresenter?.openApplication(abilityName, bundleName, moduleName, params, this.screenProp.screenId);
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      log.showInfo(`appGridItemClickCallback hideAppCenterWithAnimation： ${TAG}`);
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation(this.screenProp.screenId);
    }
    windowManager.hideWindow(windowManager.RECENT_WINDOW_NAME);
  }

  // 便利搜索任务map 如果存在则将其置为false.然后添加新任务
  private insertSearchTask(searchValue: string) {
    this.searchTask.forEach((value: boolean, key: string) => {
      if (value) {
        this.searchTask.set(key, false);
      }
    });
    this.searchTask.set(searchValue, true);
  }

  /**
   * 响应App搜索
   */
  private onSearchInputChange() {
    this.searchPageIndex = 0;
    if (!this.searchInputText) {
      log.showInfo(`onSearchInputChange searchInputText empty, not need to search`);
      this.searchAppPageList?.clear();
      this.isShowEmptyStatus = this.needShowSearchEmptyResult();
      this.resetColumnHeightOfAppCenter();
      HiSysEventUtil.reportOperateTypeAppCenter(HiSysEventUtil.APPCENTER_TYPE_OPERATE_SEARCH);
      return;
    }
    this.isShowEmptyStatus = false;
    log.showInfo('startSearch:');
    let fusionSearchStartTime: number = Date.now();
    this.insertSearchTask(this.searchInputText);
    AppCenterViewModel.getInstance().inputChangeEvent(this.searchInputText)
      .then((appCenterSearchResultTask: AppCenterSearchResultTask) => {
        log.showInfo(`getResult time:  ${Date.now() -
          fusionSearchStartTime}=searchText:${this.searchInputText} resultListSize:${appCenterSearchResultTask?.resultList?.length}`);
        let validTask = this.searchTask.get(appCenterSearchResultTask.searchKey) as boolean;
        if (!validTask) {
          return;
        }
        let appItems = AppCenterViewModel.getInstance().convertToAllList(this.appGridList);
        let searchResultItems: Set<AppItemInfo> = new Set();
        // 去重处理
        for (let resultModel of appCenterSearchResultTask.resultList) {
          log.showInfo(`search app: ${resultModel.bundleName} ${resultModel.appName}`);
          for (let appItem of appItems) {
            let appItemName = appItem?.appIndex ?? 0 > 0 ? `${appItem.bundleName}${appItem.appIndex}` : appItem.bundleName;
            if (resultModel.bundleName === appItem.bundleName) {
              log.showInfo(`appcenter resultModel：${appItemName}`);
              searchResultItems.add(appItem);
            }
          }
        }
        this.updateLazySearchAppPageInfo(AppCenterViewModel.getInstance().doAppCenterDataPaging(
          Array.from(searchResultItems), new Date().getTime()));
        this.isShowEmptyStatus = this.needShowSearchEmptyResult();
        this.resetColumnHeightOfAppCenter();
        AppCenterViewModel.getInstance().setCurSearchPageIndex(0);
        log.showInfo(`display result time: ${Date.now() - fusionSearchStartTime} searchText:${this.searchInputText} result:${searchResultItems.size}`);
        HiSysEventUtil.reportOperateTypeAppCenter(HiSysEventUtil.APPCENTER_TYPE_OPERATE_SEARCH);
      });
  }

  private updateLazyAppPageInfo(appLayPageInfo: AppLayoutInfo[]): void {
    for (let index = 0; index < appLayPageInfo.length; index++) {
      // 新增空白页，进行数据插入
      if (index >= this.lazyAppLayPageInfo.totalCount()) {
        this.lazyAppLayPageInfo.insertItem(appLayPageInfo[index], index);
      }
      // 存在相同页签，进行数据替换
      if (index < this.lazyAppLayPageInfo.totalCount()){
        this.lazyAppLayPageInfo.indexOf(appLayPageInfo[index]);
      }
    }
    // 删除多与的空白页
    if (appLayPageInfo.length < this.lazyAppLayPageInfo.totalCount()) {
      this.lazyAppLayPageInfo.deleteItemByIndex(appLayPageInfo.length);
    }
    log.showInfo(`updateLazyAppPageInfo lazyAppLayPageInfo:${this.lazyAppLayPageInfo.totalCount()}`)
  }

  private updateLazySearchAppPageInfo(appLayPageInfo: AppLayoutInfo[]): void {
    // 应用搜索每次都是更新搜索内容
    this.searchAppPageList?.clear()
    appLayPageInfo.forEach((item) => {
      this.searchAppPageList?.pushItem(item as AppLayoutInfo);
    })
    log.showInfo(`updateLazySearchAppPageInfo searchAppPageList:${this.searchAppPageList?.totalCount()}`)
  }

  private getForeachKey(item: AppLayoutInfo): string {
    if (this.searchInputText) {
      if (this.searchAppPageList === undefined || this.searchAppPageList.totalCount() === 0) {
        log.showInfo(`page_search`+ this.searchInputText);
        return 'page_search' + this.searchInputText;
      } else {
        log.showInfo('page_search' + item.index + this.searchInputText + this.searchAppPageList.getData(item.index)?.pageInfo.length);
        return 'page_search' + item.index + this.searchInputText + this.searchAppPageList.getData(item.index)?.pageInfo.length;
      }
    } else {
      log.showInfo('page' + item.index);
      return 'page' + item.index;
    }
  }

  /**
   * 是否需要翻页标记显示
   * @returns
   */
  private needShowIndicator(): boolean {
    let preHeatingAppCenter: boolean | undefined = AppStorage.get('preHeatingAppCenter');
    if (!this.isAppCenterShow || preHeatingAppCenter) {
      return false;
    }

    if (!this.searchInputText) {
      return AppGridLayoutCacheManager.getInstance().beyondOneScreen(this.lazyAppLayPageInfo.totalCount());
    } else {
      if (this.searchAppPageList) {
        return AppGridLayoutCacheManager.getInstance().beyondOneScreen(this.searchAppPageList.totalCount());
      } else {
        return false;
      }
    }
  }

  /**
   * 是否显示搜索结果空页
   * @returns
   */
  private needShowSearchEmptyResult(): boolean {
    log.showInfo('needShowSearchEmptyResult searchInputText:' + this.searchInputText);
    if (!this.isAppCenterShow) {
      return false;
    }

    if (!this.searchInputText) {
      return false;
    }
    return this.searchAppPageList?.totalCount() === 0;
  }

  private resetColumnHeightOfAppCenter(): void {
    if (this.isShowEmptyStatus && FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      switch (FoldedDeviceAcViewModel.getInstance().getCurrentFoldState()) {
        case SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD:
        case SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD:
          this.columnHeightOfAppCenter = StyleConstants.PERCENTAGE_50;
          break;
        default :
          this.columnHeightOfAppCenter = StyleConstants.PERCENTAGE_100;
          break;
      }
    } else {
      this.columnHeightOfAppCenter = StyleConstants.PERCENTAGE_100;
    }
  }

  private onDragMoveEvent(
    event: DragEvent, extraParams?: string, screenId?: number): void {
    log.showInfo('onDragMove');
    this.itemMove(event);
    AppCenterDragMgr.getInstance().onDragMove(event, undefined, this.getUIContext(), screenId);
  }

  private itemMove(event: DragEvent): void {
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      if (FoldedDeviceAcViewModel.getInstance().isKeyboardOnCSide()) {
        this.doItemMoveForOthers(event);
      } else {
        this.doItemMoveForFolded(event);
      }
    } else {
      this.doItemMoveForOthers(event);
    }
  }

  private doItemMoveForOthers(event: DragEvent): void {
    if (!event) {
      log.showWarn('itemMove invalid event!');
      return;
    }
    if (AppCenterDragMgr.getInstance().getIsSwaggingPage()) {
      log.showWarn('skip swagging time!');
      return;
    }
    if (!this.gridStyleConfig) {
      return;
    }
    const moveX: number = event.getWindowX();
    const moveY: number = event.getWindowY();
    const iconSize: number = this.gridStyleConfig.mIconSize;
    const horizontalMargin: number = this.gridStyleConfig.mAppCenterMarginLeft;
    const mGridWidth: number = this.gridStyleConfig.mGridWidth;
    const gridHeight: number = this.mLayoutVM.getScreenHeight() - this.mLayoutVM.getDockHeight();
    log.showInfo(`itemMove gridHeight ${gridHeight}`);
    // 条件：1.当前图标拖出左侧1/4; 2.当前页码大于0，不合适；3.拖拽y值在工作区内
    const isDragInLeftMarginArea: boolean =
      ((moveX - iconSize / 4) < horizontalMargin) && (this.pageIndex > 0) && (moveY < gridHeight);
    const isLeftRtl: boolean = ((moveX - iconSize / 4) < horizontalMargin) && (moveY < gridHeight);
    const isRightRtl: boolean =
      ((moveX + iconSize / 4) > (horizontalMargin + mGridWidth)) && (this.pageIndex > 0) && (moveY < gridHeight);
    const isDragInRightMarginArea: boolean =
      ((moveX + iconSize / 4) > (horizontalMargin + mGridWidth)) && (moveY < gridHeight);
    log.showInfo(`itemMove left-RTL: ${isLeftRtl}, right: ${isRightRtl}`);
    log.showInfo(`itemMove left: ${isDragInLeftMarginArea}, right: ${isDragInRightMarginArea}`);
    let needShowPrevious = RTLUtil.isRTL() ? isRightRtl : isDragInLeftMarginArea;
    let needShowNext = RTLUtil.isRTL() ? isLeftRtl : isDragInRightMarginArea;
    if (needShowPrevious) {
      const callback = () => {
        log.showInfo(`itemMove isDragInLeftMarginArea`);
        AppCenterViewModel.getInstance().showPrevious(this.screenProp.screenId);
        this.movingIconSwapPageDelay();
      }
      this.movePageTimer(callback);
    } else if (needShowNext) {
      const callback = () => {
        log.showInfo(`itemMove isDragInRightMarginArea`);
        this.moveItemToNext();
      }
      this.movePageTimer(callback);
    } else {
      this.clearMovePageTimer();
    }
  }

  private doItemMoveForFolded(event: DragEvent): void {
    if (!event) {
      log.showWarn('itemMove invalid event!');
      return;
    }
    if (AppCenterDragMgr.getInstance().getIsSwaggingPage()) {
      log.showWarn('skip swagging time!');
      return;
    }
    const moveX: number = event.getWindowX();
    const moveY: number = event.getWindowY();

    if (!this.gridStyleConfig) {
      return;
    }

    const iconSize: number = this.gridStyleConfig.mIconSize;
    const horizontalMargin: number = this.gridStyleConfig.mAppCenterMarginLeft;
    const gridWidth: number = this.gridStyleConfig.mGridWidth;
    const gridHeight: number = this.gridStyleConfig.mGridHeight;
    const rowGap = this.gridStyleConfig.mRowsGap;
    let paddingTop = this.getPaddingTop();
    let firstPageBottom: number = gridHeight + paddingTop;
    let space = this.getItemSpace();
    let secondPageTop: number = gridHeight + paddingTop + space;
    let dragStartPage = AppCenterDragMgr.getInstance().getStartDragPage();

    log.showInfo(`doItemMoveForFolded-${dragStartPage}-${firstPageBottom}-${secondPageTop}-${moveX}-${moveY}` +
      `-${paddingTop}-${space}-${iconSize}-${horizontalMargin}-${gridWidth}-${rowGap}`);

    if (dragStartPage === undefined) {
      log.showInfo('Ignore drag when drag start page invalid');
      return;
    }

    let isInLeftMarginArea: boolean = (moveX - iconSize / 4) < horizontalMargin + HOT_EREA_ADJUSTMENT;
    let isInRightMarginArea: boolean = (moveX + iconSize / 4) > (horizontalMargin + gridWidth - HOT_EREA_ADJUSTMENT);
    const pageCount: number = AppGridLayoutCacheManager.getInstance().getPageCount();
    const appLayoutInfo: AppLayoutInfo[] = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemList();
    let needShowPrevious: boolean = (moveY < paddingTop - iconSize) && this.pageIndex !== 0;
    let needShowNext: boolean = (isInLeftMarginArea || isInRightMarginArea) &&
      (moveY > secondPageTop + gridHeight + iconSize / 4) &&
      (this.pageIndex + 2 <= pageCount) &&
      appLayoutInfo[this.pageIndex].pageInfo.length !== 0 &&
      appLayoutInfo[this.pageIndex + 1].pageInfo.length !== 0;

    if (needShowPrevious || needShowNext) {
      this.doItemMoveForFoldedCrossScreen(needShowPrevious, needShowNext);
      return;
    }
    const middleAreaHeight: number = FoldedDeviceAcViewModel.getInstance().getMiddleAreaHeight();
    const middleLine: number = firstPageBottom + middleAreaHeight / 2;
    let curDragPage: number = AppCenterDragMgr.getInstance().getDraggingPageIndex();
    let isStartFromBSide = curDragPage % 2 === 0;
    let workingPage: number = isStartFromBSide ? (moveY > middleLine ?
      curDragPage + 1 : curDragPage) :
      (moveY < middleLine ? curDragPage - 1 : curDragPage);

    if (curDragPage === workingPage) {
      log.showInfo(`doItemMoveForFolded directly return. repeatly Cross page drag - ${workingPage}, moveY: ${moveY}, middleLine: ${middleLine}, currentScreenHeight: ${px2vp(this.currentScreenHeight)}`);
      return;
    }
    log.showInfo(`doItemMoveForFolded end. curDragPage: ${curDragPage}, isStartFromBSide: ${isStartFromBSide}, workingPage: ${workingPage}, moveY: ${moveY}, middleLine: ${middleLine}, currentScreenHeight: ${px2vp(this.currentScreenHeight)}`);
    if (workingPage > curDragPage) {
      this.moveItemToNextForFolded(curDragPage);
    } else {
      AppCenterDragMgr.getInstance().updateDragPageIndex(false);
      this.movingIconSwapPageDelay();
    }
  }

  private doItemMoveForFoldedCrossScreen(needShowPrevious: boolean, needShowNext: boolean): void {
    if (needShowPrevious) {
      AppCenterDragMgr.getInstance().setDragCrossScreen(true);
      const callback = () => {
        log.showInfo(`itemMove needShowPrevious crossScreen`);
        AppCenterDragMgr.getInstance().setDraggingCrossScreen(true);
        AppCenterViewModel.getInstance().showPrevious(this.screenProp.screenId);
        AppCenterDragMgr.getInstance().setDraggingCrossScreen(false);
        this.movingIconSwapPageDelay();
      }
      this.movePageTimer(callback, CROSS_SCREEN);
    } else if (needShowNext) {
      AppCenterDragMgr.getInstance().setDragCrossScreen(true);
      const callback = () => {
        log.showInfo(`itemMove needShowNext crossScreen`);
        AppCenterDragMgr.getInstance().setDraggingCrossScreen(true);
        this.moveItemToNextForFoldedCrossScreen();
        AppCenterDragMgr.getInstance().setDraggingCrossScreen(false);
      }
      this.movePageTimer(callback, CROSS_SCREEN);
    } else {
      this.clearMovePageTimer();
    }
  }

  private moveItemToNextForFoldedCrossScreen(): void {
    log.showInfo('move folded item cross screen');
    const pageCount: number = AppGridLayoutCacheManager.getInstance().getPageCount();
    const appLayoutInfo: AppLayoutInfo[] = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemList();
    const isBlankPage: boolean = (this.pageIndex < pageCount) && appLayoutInfo[this.pageIndex].pageInfo.length === 0;
    log.showInfo(`move to next page from current: ${this.pageIndex}, blank=${isBlankPage}, totalPage=${pageCount}`);

    // 需要增页，刚切过来会有这种情况
    const foldedDreateNewPageStatus = (this.pageIndex >= pageCount - 2 && this.pageIndex <= pageCount) && !isBlankPage;

    if (this.pageIndex < pageCount - 1) {
      AppCenterViewModel.getInstance().showNext(this.screenProp.screenId);
    }
    this.movingIconSwapPageDelay(foldedDreateNewPageStatus);
  }

  private moveItemToNextForFolded(curDragPage: number): void {
    let pageCount: number = AppGridLayoutCacheManager.getInstance().getPageCount();
    const appLayoutInfo: AppLayoutInfo[] = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemList();
    const isBlankPage: boolean = (curDragPage < pageCount) && appLayoutInfo[curDragPage].pageInfo.length === 0;
    log.showInfo(`move to next moveItemToNext page from current: ${curDragPage}, totalPage: ${pageCount},isBlankPage:${isBlankPage}`);
    
    // 需要增页，刚切过来会有这种情况
    const foldedDreateNewPageStatus = (curDragPage === pageCount - 1 || curDragPage === pageCount) && !isBlankPage;

    if (curDragPage <= pageCount - 1) {
      AppCenterDragMgr.getInstance().updateDragPageIndex(true);
    }

    this.movingIconSwapPageDelay(foldedDreateNewPageStatus);
  }

  private createNewPageForFolded(): void {
    let pageCount: number = AppGridLayoutCacheManager.getInstance().getPageCount();
    pageCount = AppGridLayoutCacheManager.getInstance().addBlankPage() ? (pageCount + 1) : pageCount;
    // s刷新新的页签
    AppListPresenter.getInstance().refreshAppGridLayout(this.screenProp?.screenId,
      FeatureConstants.AC_UPDATE_PAGE_REASON_NEW_BLANK_PAGE);
    // 更新锁定状态
    AppCenterDragMgr.getInstance().updateDragPageIndex(true);
    // 进行翻页
    this.moveItemToNext();
  }


  private moveItemToNext(): void {
    const pageCount: number = AppGridLayoutCacheManager.getInstance().getPageCount();
    const appLayoutInfo: AppLayoutInfo[] = AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemList();
    const isBlankPage: boolean = (this.pageIndex < pageCount) && appLayoutInfo[this.pageIndex].pageInfo.length === 0;
    log.showInfo(`move to next page from current: ${this.pageIndex}`);
    // 需要增页，刚切过来会有这种情况
    if ((this.pageIndex === pageCount - 1 || this.pageIndex === pageCount) && !isBlankPage) {
      AppGridLayoutCacheManager.getInstance().addBlankPage();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APP_GRID_REFRESH_FINISHED, null);
    }
    if (this.pageIndex < pageCount - 1) {
      AppCenterViewModel.getInstance().showNext(this.screenProp.screenId);
    }
    this.movingIconSwapPageDelay();
  }

  private movingIconSwapPageDelay(foldedDreateNewPageStatus?: boolean): void {
    log.showInfo(`movingIconSwapPageDelay movingIconSwapPageDelay:${foldedDreateNewPageStatus}`);
    AppCenterDragMgr.getInstance().setIsSwaggingPage(true);
    setTimeout(() => {
      // folded设备，在热区等待之后创建新的空白页，然后进行换页
      if (foldedDreateNewPageStatus) {
        this.createNewPageForFolded();
      }

      AppCenterDragMgr.getInstance().setIsSwaggingPage(false);
    }, this.swapPageDelayTime);
  }

  private initSwapPageDelayTime(): void {
    this.swapPageDelayTime =
      !FoldedDeviceAcViewModel.getInstance().isFoldedDevice() ? SWAP_PAGE_DELAY : SWAP_PAGE_DELAY_HPR;
  }

  public buildNotInstalledAppMenu(item: AppItemInfo): Map<AppStatus, MenuInfo[]> {
    let menuInfoList = new Map<AppStatus, MenuInfo[]>();
    if (item === undefined) {
      return menuInfoList;
    }
    let bundleName: string = item.bundleName === undefined ? '' : item.bundleName as string;
    menuInfoList = AppListPresenter.getInstance().buildNotInstalledAppMenu(bundleName);
    return menuInfoList;
  }

  private itemDragStart(): void {
    log.showInfo('itemDragStart');
  }

  private itemDragEnd(): void {
    log.showInfo('itemDragEnd');
  }

  private getPageIdx(): number {
    log.showInfo(`getIdx-${this.searchInputText}-${this.pageIndex}`);
   return this.searchInputText ? this.searchPageIndex : this.pageIndex;
  }

  private onSwiperChange(index: number): void {
    log.showInfo(`onChange index: ${index}-${this.pageIndex}, searchInputText : ${this.searchInputText}`);
    if (this.searchInputText) {
      if (this.isAppCenterShow) {
        this.searchPageIndex = index;
        AppCenterViewModel.getInstance().setCurSearchPageIndex(index);
      }
      return;
    }
    if (!this.isAppCenterShow && this.pageIndex === 0 && index > 0) {
      // avoid arkui swiper bug
      log.showWarn('onChange no need to change pageIndex');
      return;
    }
    this.pageIndex = index;
    AppCenterDragMgr.getInstance().setDragPageIndex(this.pageIndex);
    AppCenterDragMgr.getInstance().removeDropAnim();
  }

  private onSwiperAnimationStart(index: number): void {
    AppStorage.setOrCreate<boolean>('isAppCenterSwiping', FoldedDeviceAcViewModel.getInstance().isFoldedDevice());
    ContextMenu.close();
    log.showInfo('onAnimationStart');
    AppCenterDragMgr.getInstance().removeDropAnim();
    focusControl.requestFocus(CommonConstants.APP_CENTER_REQUEST_FOCUS_KEY + index);
    this.showDropFrame = false;
    // ApsUtils.stopApsSession(this.apsApsSessionId);
    this.apsApsSessionId = '';
    // ApsUtils.setApsScene(apsManager.SceneAnimation.APPCENTER_SWIPE, StyleConstants.DEFAULT_1);
  }

  private onSwiperAnimationEnd(index: number, extraInfo: SwiperAnimationEvent): void {
    if (extraInfo.currentOffset === 0) {
      AppStorage.setOrCreate<boolean>('isAppCenterSwiping', false);
    }
    log.showInfo(`onAnimationEnd ${extraInfo.currentOffset}`);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.APPCENTER_SWIPE, StyleConstants.DEFAULT_0);
    animateTo({
      duration: 200,
      curve: curves.interpolatingSpring(0.5, 1, 228, 30)
    }, () => {
      this.showDropFrame = true;
    });
  }

  private onSwiperGestureSwipe(index: number, extraInfo: SwiperAnimationEvent): void {
    AppCenterDragMgr.getInstance().removeDropAnim();
    ContextMenu.close();
    AppStorage.setOrCreate<boolean>('isAppCenterSwiping', FoldedDeviceAcViewModel.getInstance().isFoldedDevice());
    if (this.apsApsSessionId === '') {
      // this.apsApsSessionId = ApsUtils.startApsPersistentSession(apsManager.SceneAnimation.APPCENTER_SWIPE_MOVING);
    } else {
      if (!ApsUtils.pulseApsSession(this.apsApsSessionId)) {
        // this.apsApsSessionId = ApsUtils.startApsPersistentSession(apsManager.SceneAnimation.APPCENTER_SWIPE_MOVING);
      }
    }
  }

  @Builder
  buildSearchAppSwiper() {
    Swiper(this.sreachSwiperController) {
      LazyForEach(this.searchAppPageList, (item: AppLayoutInfo) => {
        AppCenterAppGrid({
          singleContext: this.singleContext,
          appGridList: item.pageInfo,
          pageIndex: item.index,
          isScroll: false,
          appGridStyleConfig: this.gridStyleConfig,
          onItemClick: (event: ClickEvent, item: AppItemInfo) => {
            this.appGridItemClickCallback(item);
          },
          getIndexInSwiper: (): number => this.pageIndex,
          buildMenu: (item: AppItemInfo) => this.buildMenuInfoList(item),
          buildNotInstalledAppMenu: (item: AppItemInfo) => this.buildNotInstalledAppMenu(item),
          // appcenter  show badge
          enableBadge: true,
          dragAllowed: true,
          inSearch: this.searchInputText ? true : false,
          isGainFocus: this.isGainFocus,
          dragStart: () => this.itemDragStart(),
          dragEnd: ()=> this.itemDragEnd(),
          swiperPaddingBottom: this.swiperPaddingBottom,
          screenProp: this.screenProp,
          appItemPosX: this.appItemPosX,
          appItemPosY: this.appItemPosY,
          appItemOpacity: this.appItemOpacity,
          bkOpacity: this.bkOpacity,
          rtlAppItemPosX: this.rtlAppItemPosX
        })
      }, (item: AppLayoutInfo) => this.getForeachKey(item))
    }
    .id(APP_CENTER_SWIPER_KEY)
    .visibility(this.searchInputText ? Visibility.Visible : Visibility.None)
    .pageFlipMode(PageFlipMode.SINGLE)
    .displayCount(this.swiperDsCount, this.swiperMultiPages)
    .vertical(this.swiperVertical)
    .indicator(this.needShowIndicator())
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .disableSwipe(!this.swiperEnabled)
    .dragStyle()
    .indicatorStyle(this.getIndicatorStyle())
    .effectMode(EdgeEffect.None)
    .index(this.getPageIdx())
    .padding({
      top: this.swiperPaddingTop,
      bottom: this.swiperPaddingBottom
    })
    .onChange((index: number) => {
      this.onSwiperChange(index);
    })
    .onAnimationStart((index: number) => {
      this.onSwiperAnimationStart(index);
    })
    .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
      this.onSwiperAnimationEnd(index, extraInfo);
    })
    .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
      this.onSwiperGestureSwipe(index, extraInfo);
    })
    .loop(false)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Up) {
        log.showInfo('onTouch Up');
        AppStorage.setOrCreate<boolean>('isAppCenterSwiping', false);
      }
    })
  }

  @Builder
  buildAppSwiper() {
    Swiper(this.swiperController) {
      LazyForEach(this.lazyAppLayPageInfo, (item: AppLayoutInfo) => {
        AppCenterAppGrid({
          singleContext: this.singleContext,
          appGridList: item.pageInfo,
          pageIndex: item.index,
          isScroll: false,
          appGridStyleConfig: this.gridStyleConfig,
          onItemClick: (event: ClickEvent, item: AppItemInfo) => {
            this.appGridItemClickCallback(item);
          },
          getIndexInSwiper: (): number => this.pageIndex,
          buildMenu: (item: AppItemInfo) => this.buildMenuInfoList(item),
          buildNotInstalledAppMenu: (item: AppItemInfo) => this.buildNotInstalledAppMenu(item),
          enableBadge: true,
          dragAllowed: true,
          inSearch: this.searchInputText ? true : false,
          isGainFocus: this.isGainFocus,
          dragStart: () => this.itemDragStart(),
          dragEnd: () => this.itemDragEnd(),
          swiperPaddingBottom: this.swiperPaddingBottom,
          screenProp: this.screenProp,
          appItemPosX: this.appItemPosX,
          appItemPosY: this.appItemPosY,
          appItemOpacity: this.appItemOpacity,
          bkOpacity: this.bkOpacity,
          rtlAppItemPosX: this.rtlAppItemPosX
        })
      }, (item: AppLayoutInfo) => this.getForeachKey(item))
    }
    .id(APP_CENTER_SWIPER_KEY)
    .visibility(this.searchInputText ? Visibility.None : Visibility.Visible)
    .pageFlipMode(PageFlipMode.SINGLE)
    .displayCount(this.swiperDsCount, this.swiperMultiPages)
    .vertical(this.swiperVertical)
    .indicator(this.needShowIndicator())
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .disableSwipe(!this.swiperEnabled)
    .dragStyle()
    .indicatorStyle(this.getIndicatorStyle())
    .effectMode(EdgeEffect.None)
    .index(this.getPageIdx())
    .padding({
      top: this.swiperPaddingTop,
      bottom: this.swiperPaddingBottom
    })
    .onChange((index: number) => {
      this.onSwiperChange(index);
    })
    .onAnimationStart((index: number) => {
      this.onSwiperAnimationStart(index);
    })
    .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
      this.onSwiperAnimationEnd(index, extraInfo);
    })
    .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
      this.onSwiperGestureSwipe(index, extraInfo);
    })
    .loop(false)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Up) {
        log.showInfo('onTouch Up');
        AppStorage.setOrCreate<boolean>('isAppCenterSwiping', false);
      }
    })
  }

  private getArrowBackground(isLeft: boolean): Resource | string {
    if (isLeft) {
      return this.arrowLeftIsHover ? COLOR_ARROW : StyleConstants.DEFAULT_TRANSPARENT_COLOR
    }
    return this.arrowRightIsHover ? COLOR_ARROW : StyleConstants.DEFAULT_TRANSPARENT_COLOR
  }

  private getArrowDisabled(isLeft: boolean): boolean {
    log.showInfo(`pages: ${this.pages}`);
    if (isLeft) {
      return this.pages?.slice(0)[0] === this.pageIndex ? false : true
    }
    return this.pages?.slice(-1)[0] === this.pageIndex ? false : true
  }

  private getOpacity(isLeft: boolean): Resource | number {
    if (isLeft) {
      return this.pages?.slice(0)[0] === this.pageIndex ? $r('sys.float.ohos_id_alpha_disabled') : 1
    }
    return this.pages?.slice(-1)[0] === this.pageIndex ? $r('sys.float.ohos_id_alpha_disabled') : 1
  }

  private checkIfLeftRTL(isUp: boolean) {
    return RTLUtil.isRTL() ? !isUp : isUp;
  }
  private getIndicatorStyle(): IndicatorStyle {
    return FoldedDeviceAcViewModel.getInstance().isFoldedDevice() ?
      {
        color: '#33ffffff',
        selectedColor: '#ffffff',
        top: this.indicatorHeightForFoldedDevice,
        right: this.getIndicatorRight()
      } :
      {
        color: '#33ffffff',
        selectedColor: '#ffffff',
        bottom: INDICATOR_MARGIN_BOTTOM
      };
  }

    @Builder
  AppIconBackgroundBuilder(isLeft: boolean) {
    Stack() {
      Stack() {
      }
      .width(SIZE_ARROW)
      .height(SIZE_ARROW)
      .backgroundColor(COLOR_ARROW)
      .borderRadius(SIZE_ARROW)
      .align(Alignment.Center)

      WithTheme({ colorMode: ThemeColorMode.DARK }) {
        Stack() {
          SymbolGlyph(this.checkIfLeftRTL(isLeft) ? $r('sys.symbol.chevron_left') : $r('sys.symbol.chevron_right'))
            .align(Alignment.Center)
            .fontColor([$r('sys.color.icon_on_primary')])
            .alignSelf(ItemAlign.Center)
            .fontWeight(FontWeight.Normal)
            .fontSize('24vp')
            .align(Alignment.Center)
            .opacity(this.getOpacity(this.checkIfLeftRTL(isLeft)))
        }
        .width(SIZE_ARROW)
        .height(SIZE_ARROW)
        .borderRadius(SIZE_ARROW)
        .enabled(this.getArrowDisabled(this.checkIfLeftRTL(isLeft)))
        .stateStyles({
          pressed: {
            .backgroundColor(COLOR_ARROW_PRESS)
          },
          normal: {
            .backgroundColor(this.getArrowBackground(this.checkIfLeftRTL(isLeft)))
          },
          disabled: {
            .opacity(this.getOpacity(this.checkIfLeftRTL(isLeft)))
          }
        })
        .align(Alignment.Center)
      }
    }
    .onHover((isHover: boolean) => {
      log.showInfo(`appGridItemClickCallback hideAppCenterWithAnimation： ${this.arrowLeftIsHover}`);
      if (this.checkIfLeftRTL(isLeft)) {
        this.arrowLeftIsHover = isHover
      } else {
        this.arrowRightIsHover = isHover
      }
    })

    .onClick(() => {
      if (this.checkIfLeftRTL(isLeft) && !this.searchInputText) {
        this.swiperController.showPrevious();
      } else if (this.checkIfLeftRTL(isLeft) && this.searchInputText) {
        this.sreachSwiperController.showPrevious();
      } else if (this.searchInputText) {
        this.sreachSwiperController.showNext()
      } else {
        this.swiperController.showNext();
      }
      AppCenterDragMgr.getInstance().removeDropAnim();
    })
    .width(SIZE_ARROW_BACKGROUND)
    .height(SIZE_ARROW_BACKGROUND)
    .backgroundColor(Color.Transparent)
    .borderRadius(SIZE_ARROW)
    .align(Alignment.Center)
  }

  private doIndicatorAnimationForFoldedDevice(): void {
    if (!this.isAppCenterShow) {
      this.indicatorHeightForFoldedDevice = this.getIndicatorHeight();
      return;
    }
    animateTo({
      duration: INDICATOR_ANIM_DURATION,
      curve: Curve.Friction,
    }, () => {
      this.indicatorHeightForFoldedDevice = this.getIndicatorHeight();
    })
  }

  private getIndicatorRight(): number {
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      return DEFAULT_INDICATOR_RIGHT_HORIZONTAL_HPR;
    }
    return DEFAULT_INDICATOR_RIGHT_HPR;
  }

  private getIndicatorHeight(): number {
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      if (this.screenProp.screenId === 0) {
        return UNFOLDED_HORIZONAL_INDICATOR_HEIGHT;
      } else {
        return px2vp(this.screenProp.height / 2);
      }
    }
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedVertical()) {
      return UNFOLDED_VERTICAL_INDICATOR_HEIGHT;
    }
    return DEFAULT_INDICATOR_HEIGHT;
  }

  @Styles
  dragStyle() {
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDragEnter');
      AppCenterDragMgr.getInstance().onDragEnter(this.screenProp);
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      this.onDragMoveEvent(event, extraParams, this.screenProp.screenId);
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      log.showInfo('onDrop');
      if (event) {
        event.useCustomDropAnimation = true;
        event.setResult(DragResult.DRAG_FAILED);
      }
      this.clearMovePageTimer();
      AppCenterDragMgr.getInstance().onDrop(this.getUIContext(), this.screenProp);
    })
    .onDragLeave((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDragLeave');
      this.clearMovePageTimer();
      AppCenterDragMgr.getInstance().onDragLeave();
    })
  }

  build() {
    Column() {
      // 搜索结果为空
      if (this.isShowEmptyStatus) {
        Text($r('app.string.search_no_result'))
          .fontColor($r('sys.color.font_on_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .lineHeight('27px')
          .fontWeight(FontWeight.Regular)
          .clip(false)
          .align(Alignment.Center)
          .visibility(this.isAppCenterShow ? Visibility.Visible : Visibility.None)
      } else {
        Stack() {
          AppCenterDropFrame({
            appGridStyleConfig: this.gridStyleConfig,
            singleContext: this.singleContext,
            pageIndex: this.pageIndex,
            showDropFrame: this.showDropFrame,
            screenProp: this.screenProp
          })

          this.buildSearchAppSwiper();
          this.buildAppSwiper();

          if (this.needTwoArrow) {
            Stack({ alignContent: Alignment.Start }) {
              this.AppIconBackgroundBuilder(true)
            }
            .visibility(this.needShowIndicator() ? Visibility.Visible : Visibility.None)
            .translate({ x: -(this.getUIContext()?.px2vp(this.screenProp.width) as number) / 2 + 56 })
            Stack({ alignContent: Alignment.End }) {
              this.AppIconBackgroundBuilder(false)
            }
            .visibility(this.needShowIndicator() ? Visibility.Visible : Visibility.None)
            .translate({ x: (this.getUIContext()?.px2vp(this.screenProp.width) as number) / 2 - 56 })
          }
        }
      }
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundImageSize(ImageSize.Cover)
    .width(StyleConstants.PERCENTAGE_100)
    .height(this.columnHeightOfAppCenter)
  }
}
