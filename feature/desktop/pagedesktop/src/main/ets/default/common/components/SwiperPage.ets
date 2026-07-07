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
  AppModel,
  AppStatus,
  CommonConstants,
  DeliverUtil,
  CommonConstants as DeskConstants,
  DesktopDragResult,
  DesktopManager,
  DesktopParam,
  DesktopUtils,
  DeviceState,
  DisappearLastAppData,
  EditModeConstants,
  EditModeState,
  EditModeUtils,
  EventConstants,
  FolderManager,
  FormRelationManager,
  GridLayoutConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
  layoutLockUtil,
  LayoutViewModel,
  ListenerItemType,
  lockLayoutManager,
  MultiSelectItemType,
  MultiSelectListenerType,
  multiSelectListenManger,
  MultiSelectManager,
  PageInfoManager,
  PresetStyleConstants,
  ReceiveEventInfo,
  SmartDockZoomFeatureSwitch,
  StyleConstants,
  SwiperLoadManager,
  textShadowMgr,
  UninstallListener,
  PageDesktopModel
} from '@ohos/launchercommon';
import systemParameter from '@ohos.systemparameter';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import lazy { GridItemReuseComponent } from './GridItemReuseComponent';
import {
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  DomainName,
  OutdoorConfig,
  LanguageUtils,
  LogDomain,
  LogHelper,
  RectInfo,
  SingleContext,
  singleManager,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  GlobalSearchStatus,
  HiDfxEventUtil,
  HiSysEventUtil,
  LightOutdoorConfig,
  localEventManager,
  NegativeScreenConstants,
  SCBDesktopCacheManager,
  ScreenState,
  sOutSideWindowMgr,
  ViewCallback,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { DropAnimationDestination, DropAnimationParam } from '@ohos/componentanimator';
import { desktopUtil, ItemUtils, RTLUtil } from '@ohos/componenthelper';
import {
  launcherStatusUtil,
  SCBExpandController,
  SCBFoldController,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBTransitionManager,
  SCBUnlockTransitionController,
  ScenePanelState,
  sSCBOobeManager
} from '@ohos/windowscene';
import { DragConstants, KeyCodeConstants, RotationConstants } from '@ohos/commonconstants';
import featureConstants from '../constants/FeatureConstants';
import curves from '@ohos.curves';
import { BigFolderViewModel } from '@ohos/bigfolder';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import DesktopItem from './DesktopItem';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { GridLayoutOptionRet } from './GridLayoutOptionRet';
import {
  batchUninstallChain,
  ContractedFolderCommonViewModel,
  DeskTopItemStyle,
  DisplayCountViewModel,
  EditModePageActionEnum,
  FocusUtil,
  FoldAnimationConstants,
  FolderStyleManager,
  FoldExpandAnimUtils,
  ForwardType,
  ItemAnimationParams,
  PageDesktopOneShotManager,
  pageEditManager,
  PageEditViewModel,
  SwiperPageManager
} from '@ohos/launchercommon/Index';
import { SwiperPageWhiteBoxComponent } from '@ohos/desktopedit/src/main/ets/default/view/SwiperPageWhiteBoxComponent';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import pasteboard from '@ohos.pasteboard';
import { SwiperGestureHandler } from '../SwiperGestureHandler';
import { DesktopAccessibilityUtils } from '../DesktopAccessibilityUtils';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import UTD from '@ohos.data.uniformTypeDescriptor';
import { FormConstants, FormStyleConfig, FormViewModel } from '@ohos/form';
import { dropAnimationManager, ForceType, GravityAnimationConfig, GravityAnimationManager } from '@ohos/componentanimator/Index';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import { SwiperPageLoadCallBack } from '@ohos/launchercommon/src/main/ets/cache/layout/SwiperLoadManager';
import { AppListInfo } from '../dao/AppListInfo';
import { EditModeSingePageViewData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeSingePageViewData';
import { EditModeViewState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeViewState';
import { formZoomController } from './formAdjust/viewModel/FormZoomController';
import { FormZoomDragEvtParams, FormZoomDragEvtType } from './formAdjust/common/FormZoomCommonType';
import lazy { BaseQuitAppRect, QuitAppRectViewModel } from '../viewmodel/QuitAppRectViewModel';
import { DesktopStyleConfig } from '@ohos/launchercommon/src/main/ets/manager/TextShadowManager';
import { SpaceAnimationUtils } from '@ohos/launchercommon/src/main/ets/animation/SpaceAnimationUtils';
import { CommonConstants as LockCommonConstants } from '@ohos/screenlockcommon';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { SlMainStateType, SlStaticStateType, SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SwiperPageFocusManager } from '../SwiperPageFocusManager';
import FocusManager from '../../manager/FocusManager';
import { EditModeExtensionData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeExtensionData';
import { GridItemsPool } from '../../manager/GridItemsPool';
import IconEditPageConstants from '@ohos/desktopedit/src/main/ets/default/common/constants/IconEditPageConstants';
import { IconEditWantData } from '@ohos/desktopedit/src/main/ets/default/data/IconEditWantData';
import EditModeStyleConstants from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeStyleConstants';
import { DragDataType, DragType } from '@ohos/componentdrag/src/main/ets/TsIndex';
import type ctx from '@ohos.app.ability.common';
import { SwiperPageVM } from '../viewmodel/SwiperPageVM';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import lazy { SCBTripleController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionController';
import lazy { SCBTripleStateChange, TripleFoldExpandAnimUtils, } from '@ohos/launchercommon/src/main/ets/utils/TripleFoldExpandAnimUtils';
import lazy { TripleFoldAnimationConstants } from '@ohos/launchercommon/src/main/ets/constants/TripleFoldAnimationConstants';
import { FormCenterViewModel } from '@ohos/form/src/main/ets/formcenter/viewmodel/FormCenterViewModel';
import { PageDragViewModel } from '../viewmodel/PageDragViewModel';
import { UIExceptionCaller, UIExceptionDetection } from '@ohos/windowscene/Index';
import { openFolderLayout } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderLayout';
import { OverflowViewModel } from './liveform/viewmodel/OverflowViewModel';

const TAG = 'SwiperPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CLICK_ACTION_TIME_OUT = 300;
const INVALID_IDX = -1;
const LOAD_TEXT_SHADOW_TIMEOUT = 200;
const ACCESSIBILITY_ANNOUNCE_DESKTOP_TIMEOUT = 20;
const MAX_GRIDITEM_COUNT = 30;
const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';
const TRANSITION_UNINSTALL: TransitionEffect = TransitionEffect.asymmetric(
  TransitionEffect.IDENTITY,
  TransitionEffect.opacity(0)
    .animation({
      duration: 500,
      curve: curves.cubicBezierCurve(0.2, 0, 0.3, 0.9),
    })
);
const TRANSITION_CARD_REPLACE: TransitionEffect = TransitionEffect.asymmetric(
  TransitionEffect.IDENTITY,
  TransitionEffect.opacity(0)
    .animation({
      delay: 1000,
      duration: 300,
      curve: Curve.Ease
    })
);
const PORTRAIT_DELAY: number = 200;
const PC_STATUSBAR_DRAG_KEY = 'pc_status_bar_dragging';

class UninstallParam {
  private _mUninstalledBundleName: string = '';
  private _mUninstalledAppIndex: number = 0;
  private _mUninstalledShortcutId: string = '';

  public set mUninstalledBundleName(value: string) {
    this._mUninstalledBundleName = value;
  }

  public get mUninstalledBundleName(): string {
    return this._mUninstalledBundleName;
  }

  public set mUninstalledAppIndex(value: number) {
    this._mUninstalledAppIndex = value;
  }

  public get mUninstalledAppIndex(): number {
    return this._mUninstalledAppIndex;
  }

  public set mUninstalledShortcutId(value: string) {
    this._mUninstalledShortcutId = value;
  }

  public get mUninstalledShortcutId(): string {
    return this._mUninstalledShortcutId;
  }
}

@Component
export default struct SwiperPage {
  @Prop singleContext?: SingleContext;
  @StorageLink('notifyFlush') notifyFlush: number = 0;
  @StorageLink('workSpaceWidth') workSpaceWidth: number = 0;
  @StorageLink('NavigationBarStatusValue') navigationBarStatusValue: boolean = false;
  @StorageLink('overlayMode') overlayMode: number = CommonConstants.OVERLAY_TYPE_HIDE;
  @StorageLink('selectItem') selectItem: string = '';
  @StorageLink('hoverItem') hoverItem: string = '';
  @StorageLink('pageIndex') pageIndex: number = 0;
  @StorageLink('outerPageIndex') outerPageIndex: number = 0;
  @StorageProp('screenWidth') @Watch('onScreenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @Prop @Watch('changeColumnAndRow') gridConfig: string | undefined;
  @StorageLink('formRefresh') formRefresh: string = '';
  @Watch('updateFormRefreshData') @StorageLink('formRefreshBundleName') formRefreshBundleName: string = '';
  @StorageLink('disabledLiveFormCount') disabledLiveFormCount: number = 0;
  @StorageLink('shiftStartItem') shiftStartItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageProp('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageProp('desktopIconChange') @Watch('onThemeChange') desktopIconChange: number = 0;
  @StorageProp('isAccessibilityMode') @Watch('onAccessibilityModeChange') isAccessibilityMode: boolean = false;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChange') foldStatusForOuterScreen: number = DeviceState.DEFAULT_STATE;
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') mIsPortrait: boolean = true;
  @StorageProp('wallpaperSnapshotChangeFlag') @Watch('notifyUpdateTextShadow') wallpaperSnapshotValue: boolean = false;
  @StorageLink('isDrag') isDrag: boolean = false;
  @StorageLink('isGameEngineValid') mIsGameEngineValid: boolean = false;
  @StorageProp('editModeFolderBlurEffect') @Watch('notifyEditModeFolderBlurEffect') editModeFolderBlurEffectValue: boolean = false;
  @StorageProp('transitionInRegionFolders') transitionInRegionFolders: string[] = [];
  @State swiperPageCache: boolean = false;
  @State mFoldPaddingRight: number = 0;
  @State mFoldPaddingLeft: number = 0;
  @Link indexInSwiper: number;
  private swiperKey: number = -1;
  @State columnsTemplate: string = '';
  @State rowsTemplate: string = '';
  @State mMargin: number = 0;
  @State mMarginLeft: number = 0;
  @State mMarginRight: number = 0;
  @State mColumnsGap: number = 0;
  @State mRowsGap: number = 0;
  @State offsetY: number = 0;
  @StorageLink('itemPadding') mItemPadding: number = 0;
  @State mNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @State mMaxNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @State desktopList: DeskTopArray = new DeskTopArray();
  @State visible: Visibility = Visibility.Visible;
  @State mShowWhiteBoxReason: string = '';
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  @StorageLink('appListInfo') appListInfo: AppListInfo = new AppListInfo();
  @StorageLink('outerAppListInfo') outerAppListInfo: AppListInfo = new AppListInfo();
  private isOuterDesktop: boolean = false;
  @StorageLink('isInGlobalSearchAnimate') isInGlobalSearchAnimate: boolean = false;
  @State @Watch('onAppListInfoChange') mAppListInfo: GridLayoutItemInfo[] = [];
  private latestClickedItem: string = '';
  private mSwiperPageVM: SwiperPageVM = SwiperPageVM.getInstance();
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
  private mPageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
  private mPageDragViewModel: PageDragViewModel = PageDragViewModel.getInstance(this.singleContext);
  private mOverflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
  @State mGridWidth : number = 0;
  @State mGridHeight: number = 0;
  @State mWorkSpaceWidth: number = 0;
  @State mWorkSpaceHeight: number = 0;
  @State mBlur: number = 0;
  private isPad: boolean = false;
  private isPhone: boolean = false;
  private isPc: boolean = DeviceHelper.isPC();
  private isSuperFold: boolean = false;
  private mFocusManager = FocusManager.getInstance();
  private isDesktopEditGesture: boolean = false;
  @State mIconSize: number = 0;
  @State mGridSpaceWidth : number = 0;
  @State mGridSpaceHeight: number = 0;
  private foldAnimCount: number = 0;
  private mBigFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private gridItemAnimList: ItemAnimationParams[] = [];
  private mClockWeatherItemAnimList: ItemAnimationParams[] = [];
  private swiperPageCacheFun: Function = (isCache: boolean): void => {
    this.swiperPageCacheCallback(isCache);
  }
  private onDesktopModeChangeEvent: Function = (): void => this.editModeStateChange();
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: '',
    onLock: (): void => {
      throw new Error('Function not implemented.');
    },
    onUnlock: (): void => {
      throw new Error('Function not implemented.');
    }
  };
  private unInstallListener: UninstallListener = {
    uninstallApp: (bundleName: string, appIndex?: number, shortcutId?: string): void => {
      if (launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
        this.uninstallApp(bundleName, appIndex, shortcutId)
      }
    },
    uninstallAppResult: (bundleName: string, resultCode: number, appIndex?: number, shortcutId?: string): void => {
      log.showInfo('Not support uninstallAppResult');
      this.uninstallParam.mUninstalledBundleName = '';
      this.uninstallParam.mUninstalledAppIndex = 0;
      this.uninstallParam.mUninstalledShortcutId = '';
    }
  };
  private isDesktopLayout: boolean = true;
  @State mWorkSpaceMarginTop: number = 0;
  private mWorkSpaceMargin: number = 0;
  @State mWorkSpacePadding: number = 0;
  @State mWorkSpacePaddingRight: number = 0;
  @State mWorkSpacePaddingLeft: number = 0;
  @State mWorkSpacePaddingTop: number = 0;
  @State mWorkSpacePaddingBottom: number = 0;
  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn(),
    onShow: (): void => this.onScreenOff()
  };
  private isStartMultiSelect: boolean = false;
  @State isDragOutFolderPendingClose: boolean = false;
  @State gridOptions: GridLayoutOptions = GridLayoutOptionRet.getGridLayoutOptions(this.mAppListInfo);
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private foldController?: SCBFoldController;
  private expandController?: SCBExpandController;
  private tripleController?: SCBTripleController;
  @StorageProp('themeStylePreview') themeStylePreview: boolean = false;
  private uninstallParam: UninstallParam = new UninstallParam();
  // 文件夹新组件上主干后可去掉
  @StorageLink('disappearLastAppData') disappearLastAppData: DisappearLastAppData = new DisappearLastAppData();
  private updateCurrentPageCallBack: Function = (pageIndex: number, currentPageInfoList: GridLayoutItemInfo[]):
    void => {
    if (launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      this.updateCurrentPageEvent(pageIndex, currentPageInfoList);
    }
  };
  private systemPasteBoard?: pasteboard.SystemPasteboard;
  @Consume isDesktopEnabled: boolean;
  private isDisableSwiperToIntelligent?: Function;
  private panOptionStack: PanGestureOptions = new PanGestureOptions({
    distance: NegativeScreenConstants.PAN_GESTURE_MIN_DISTANCE,
    direction: LanguageUtils.isMirrorLanguage() ? PanDirection.Left : PanDirection.Right
  });
  private isFactoryMode: boolean = systemParameter.getSync('const.runmode', 'default') === 'factory';
  @StorageLink('isDeskSwipe') isDeskSwipe: boolean = false;
  @StorageLink('formStackEditShow') mIsFormStackExpand: boolean = false;
  @State isPreparingDrag: boolean = false;
  private gravityAnimTimeoutId?: number;
  private textShadowTimer: number = -1;
  private portraitTimeId: number = 0;
  private singleHandChange: () => void = () => this.folderStatusChange()
  private getNeighborPage(page: number): number {
    if (page % StyleConstants.DEFAULT_2 === 0) {
      return page + StyleConstants.DEFAULT_1;
    } else {
      return page - StyleConstants.DEFAULT_1;
    }
  }

  private isDesktopForeground(): boolean {
    let scenePanelState: ScenePanelState | undefined = AppStorage.get<ScenePanelState>('scenePanelState');
    return scenePanelState === ScenePanelState.HOME || scenePanelState === ScenePanelState.FLOAT_SCENE;
  }

  // used for multiSelect
  @StorageLink('selectedItemList') selectedItemList: string[] = [];
  @StorageLink('lastFocusItem') lastFocusItem: GridLayoutItemInfo | undefined = undefined;
  @StorageLink('activeForm') activeForm: GridLayoutItemInfo | undefined = undefined;
  @State selectStatus: boolean = false;
  private pageEditViewModel: PageEditViewModel = PageEditViewModel.getInstance();
  @State editModeFolderOpacity: number = 1;
  @State editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
  @State iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
  private onRTLChangeEvent: Function = (): void => this.updateGridWhenRTLChange();
  @State multiSelectMap: Map<string, MultiSelectItemType> = MultiSelectManager.getInstance().multiSelectMap;
  private multiSelectListener?: MultiSelectListenerType = undefined;
  /** 编辑模式多选事件监听 */
  private registerMultiSelectListener(): void {
    this.multiSelectListener = {
      id: multiSelectListenManger.getListenerId(
        ListenerItemType.SWIPER_ITEM, this.indexInSwiper.toString(), this.isOuterDesktop),
      onUpdatingMultiSelectMap: (): void => {
        log.showInfo(`page ${this.indexInSwiper.toString()} is onUpdatingMultiSelectMap`);
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

  onItemSelect = (item: GridLayoutItemInfo, pageIndex: number) => {
    if (item === undefined || item === null) {
      log.showError(`onItemSelect item null`);
      return;
    }
    let itemKey: string = this.mPageDesktopViewModel.getItemKeyByType(item);
    log.showDebug(`onItemSelect key: ${itemKey}`);
    this.lastFocusItem = undefined;
    this.setHoverItem(false, item);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESET_ALL_SELECT_STATUS, null);
    if (this.latestClickedItem === '') {
      this.latestClickedItem = itemKey;
      setTimeout(() => {
        this.latestClickedItem = '';
      }, CLICK_ACTION_TIME_OUT);
      this.setSelectItem(item, pageIndex);
    } else {
      if (itemKey === this.latestClickedItem) {
        // if during double click time out, unselect it
        this.unSelectItem(item);
      }
    }
  }

  private updateGridWhenRTLChange(): void {
    if (!this.isSuperFold) {
      return;
    }
    if (this.mIsPortrait) {
      return;
    }
    this.initSuperFoldUniqueConfig();
  }

  private onScreenWidth() {
    SwiperGestureHandler.getInstance().setWindowWidth(this.screenWidth);
  }

  private paddingSideUpdate() {
    let padding: number[] = this.mSwiperPageVM.getPaddingSide(this.indexInSwiper, this.folderStatus);
    this.mFoldPaddingRight = padding[0];
    this.mFoldPaddingLeft = padding[1];
  }

  /**
   * 编辑模式切换时缓慢更新宫格偏移及落位白板偏移
   */
  private editModeStateChange(): void {
    animateTo({
      curve: EditModeConstants.CHANGE_DESKMODE_CURVE,
      delay: editModeManager.isInEditMode() ? EditModeStyleConstants.DESKTOP_MODE_CHANGE_DELAY : 0
    }, () => {
      this.mWorkSpaceMarginTop = this.getMarginTop();
    });
  }

  private folderStatusChange(): void {
    if (DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    this.changeSwiperState();
  }

  private cancelPortraitTimeout(): void {
    if (this.portraitTimeId !== 0) {
      clearTimeout(this.portraitTimeId);
      this.portraitTimeId = 0;
    }
  }

  private onPortraitStatusChange() {
    log.showInfo(`onPortraitStatusChange: ${this.mIsPortrait}`);
    if (DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    this.changeSwiperState();
  }

  private changeSwiperState(label?: string): void {
    log.showInfo(`changeSwiperState:${label}`);
    this.cancelPortraitTimeout();
    // super fold共两页, 一屏可见, 两页都要立即计算
    if (PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, this.pageIndex) || this.isSuperFold) {
      this.portraitStatusChangeImediately();
    } else if (label === 'screenChangeRotationAnim' && (this.indexInSwiper - desktopUtil.getPageIndexValue()) <= 3) {
      // 三折设备34 转 123场景，第4页需要立马刷新
      this.portraitStatusChangeImediately();
    } else {
      this.portraitTimeId = setTimeout(() => {
        this.portraitStatusChangeImediately();
      }, PORTRAIT_DELAY);
    }
  }

  private portraitStatusChangeImediately() {
    this.initConfig();
    if (DeviceHelper.isPad() || this.isSuperFold) {
      this.changeConfig();
    }
    this.paddingSideUpdate();
  }


  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  private workSpacePostionChange = (gridOffset: number, fixedPage: number) => {
    log.showInfo(`workSpacePostionChange: gridOffset: ${gridOffset}, fixedPage: ${fixedPage}`);
    if (fixedPage === this.indexInSwiper) {
      return;
    }
    animateTo({
      duration: 200,
      curve: Curve.Friction,
    }, ()=>{
      this.offsetY = gridOffset;
    });
    this.offsetY = 0;
    this.initConfig();
  }

  private getAppListInfo() {
    return this.isOuterDesktop ? this.outerAppListInfo : this.appListInfo;
  }

  private getMargin(): number {
    return Math.max(this.mMarginLeft, this.mMarginRight);
  }

  private initConfig() {
    this.mMarginLeft = this.mPageDesktopStyleConfig.mMargin as number;
    this.mMarginRight = this.mPageDesktopStyleConfig.mMargin as number;
    this.mWorkSpaceMargin = this.mPageDesktopStyleConfig.mWorkSpaceMargin as number;
    this.mColumnsGap = this.mPageDesktopStyleConfig.mColumnsGap as number;
    this.mRowsGap = this.mPageDesktopStyleConfig.mRowsGap as number;
    this.mItemPadding = this.mPageDesktopStyleConfig.mItemPadding as number;
    this.mNameLines = this.mPageDesktopStyleConfig.mNameLines as number;
    this.mMaxNameLines = this.mPageDesktopStyleConfig.mMaxNameLines as number;
    this.mWorkSpaceMarginTop = this.getMarginTop();
    this.mGridWidth = this.mPageDesktopStyleConfig.mGridWidth as number;
    this.mGridHeight = this.mPageDesktopStyleConfig.mGridHeight as number;
    this.mWorkSpaceWidth = this.mPageDesktopStyleConfig.mWorkSpaceWidth as number;
    this.mWorkSpaceHeight = this.mPageDesktopStyleConfig.mWorkSpaceHeight as number;
    this.mIconSize = this.mPageDesktopStyleConfig.mIconSize as number;
    this.mWorkSpacePaddingRight = this.mPageDesktopStyleConfig.mWorkSpacePadding;
    this.mWorkSpacePaddingLeft = this.mPageDesktopStyleConfig.mWorkSpacePadding;
    this.mWorkSpacePaddingTop = this.mPageDesktopStyleConfig.mWorkSpacePaddingTop;
    this.mWorkSpacePaddingBottom = this.mPageDesktopStyleConfig.mWorkSpacePaddingBottom;
    this.mGridSpaceWidth = Number(this.mPageDesktopViewModel.getWorkSpaceWidth()) - this.getMargin();
    this.mGridSpaceHeight = Number(this.mPageDesktopViewModel.getWorkSpaceHeight());

    let desktopParam: DesktopParam = DesktopManager.getInstance().getDesktopParam();
    desktopParam.gridMarginTop = this.mWorkSpaceMarginTop + LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
    if (this.isSuperFold) {
      this.initSuperFoldUniqueConfig();
    }
    log.showInfo('build item page: %{public}d, swiperKey: %{public}d, mMargin: %{public}d, mColumnsGap: %{public}d, mRowsGap: %{public}d,' +
      'mItemPadding: %{public}d, mNameLines: %{public}d, mMaxNameLines: %{public}d, mWorkSpaceMarginTop: %{public}d, mGridWidth: %{public}d,' +
      'mGridHeight: %{public}d,mIconSize: %{public}d, mWorkSpacePadding: %{public}d, mWorkSpacePaddingTop: %{public}d,' +
      'mWorkSpacePaddingBottom: %{public}d, mGridSpaceWidth: %{public}d, mGridSpaceHeight: %{public}d, isOuterDesktop:%{public}s',
      this.indexInSwiper, this.swiperKey, this.getMargin(), this.mColumnsGap, this.mRowsGap, this.mItemPadding,
      this.mNameLines, this.mMaxNameLines, this.mWorkSpaceMarginTop, this.mGridWidth, this.mGridHeight, this.mIconSize,
      this.mWorkSpacePadding, this.mWorkSpacePaddingTop, this.mWorkSpacePaddingBottom, this.mGridSpaceWidth,
      this.mGridSpaceHeight, this.isOuterDesktop);

    if (!this.isPc) {
      QuitAppRectViewModel.getInstance().initSwiperParam(this.screenWidth);
      BaseQuitAppRect.getInstance().initGridParamDesktop(this.mPageDesktopStyleConfig,
        this.mPageDesktopViewModel.getGridConfig());
      BaseQuitAppRect.getInstance().initGridParamOpenFolder(this.screenWidth,
        this.screenHeight, FolderStyleManager.getInstance().getFolderStyleConfig());
      PageEditViewModel.getInstance().setGridMargin(this.mPageDesktopStyleConfig.mMargin as number);
      PageEditViewModel.getInstance().setFoldPaddingSide(this.mPageDesktopStyleConfig.mFoldPaddingSide as number);
    }
  }

  private initSuperFoldUniqueConfig(): void {
    if (this.mIsPortrait) {
      // 竖屏状态下，C面有 paddingBottom，无 paddingTop
      if (this.indexInSwiper & 1) {
        this.mWorkSpacePaddingBottom = this.mWorkSpacePaddingTop;
        this.mWorkSpacePaddingTop = 0;
      }
    } else {
      if (RTLUtil.isRTL()) {
        if (this.indexInSwiper & 1) {
          this.mWorkSpacePaddingRight = 0;
          this.mWorkSpacePaddingLeft = this.mPageDesktopStyleConfig.mWorkSpacePadding;
        } else {
          this.mWorkSpacePaddingLeft = 0;
          this.mWorkSpacePaddingRight = this.mPageDesktopStyleConfig.mWorkSpacePadding;
        }
      } else {
        if (this.indexInSwiper & 1) {
          this.mWorkSpacePaddingLeft = 0;
          this.mWorkSpacePaddingRight = this.mPageDesktopStyleConfig.mWorkSpacePadding;
        } else {
          this.mWorkSpacePaddingRight = 0;
          this.mWorkSpacePaddingLeft = this.mPageDesktopStyleConfig.mWorkSpacePadding;
        }
      }
    }
  }

  /**
   * 隐藏超出当前屏幕区域的元素
   */
  private filterItemExceedCurrentScreen(): void {
    if (this.isPc && this.mAppListInfo) {
      this.mAppListInfo = this.mPageDesktopViewModel.filterItemExceedCurrentScreen(this.mAppListInfo);
    }
  }

  private updateFormRefreshData(): void {
    if (this.formRefreshBundleName !== '') {
      /* formRefreshBundleName为非空，需要对卡片进行重建操作 */
      let date: string = String(new Date());
      this.getAppListInfo().appGridInfo.forEach((gridInfo: GridLayoutItemInfo[]) => {
        gridInfo.forEach((item: GridLayoutItemInfo) => {
          if (item.typeId === CommonConstants.TYPE_CARD && item.bundleName === this.formRefreshBundleName) {
            item.formRefreshDate = date;
          }
          // 卡片堆叠中包含更新应用，重建堆叠
          if (item.typeId === CommonConstants.TYPE_FORM_STACK && item.layoutInfo && item.layoutInfo[0].length) {
            let index: number = item.layoutInfo[0].findIndex((gridLayoutItem: GridLayoutItemInfo) => {
              return gridLayoutItem.bundleName === this.formRefreshBundleName;
            });
            if (index >= 0) {
              log.showInfo(`updateFormStack by formRefreshBundleName: ${this.formRefreshBundleName}`);
              item.formRefreshDate = date;
            }
          }
        })
      });
      this.formRefreshBundleName = '';
    }
  }

  onAppListInfoChange(): void {
    this.mSwiperPageVM.setPageItems(this.indexInSwiper, this.mAppListInfo);
  }

  appListInfoChange() {
    if (this.formRefreshBundleName !== '') {
      /* formRefreshBundleName为非空，说明有对应包覆盖安装，需要对卡片进行重建操作 */
      let date: string = String(new Date());
      this.getAppListInfo().appGridInfo.forEach((gridInfo: GridLayoutItemInfo[]) => {
        gridInfo.forEach((item: GridLayoutItemInfo) => {
          if (item.typeId === CommonConstants.TYPE_CARD && item.bundleName === this.formRefreshBundleName) {
            item.formRefreshDate = date;
            log.showInfo(`appListInfoChange form: ${JSON.stringify(item)}`);
          }
        })
      });
      this.formRefreshBundleName = '';
    }
    if (this.getAppListInfo()?.appGridInfo) {
      // new created folder should be selected
      let newCreateFolder = AppStorage.get<string>('newCreateFolder');
      if (!CheckEmptyUtils.checkStrIsEmpty(newCreateFolder)) {
        this.getAppListInfo().appGridInfo.forEach((gridInfo: GridLayoutItemInfo[]) => {
          gridInfo.forEach((item: GridLayoutItemInfo) => {
            if (item.typeId === CommonConstants.TYPE_FILE_FOLDER &&
              item.uri === newCreateFolder) {
              this.setSelectItem(item, this.indexInSwiper);
            } else {
              item.isSelect = false;
            }
          })
        });
      }
      this.refreshAppListComponentId();
      this.filterItemExceedCurrentScreen();
      if (DeviceHelper.isPC()) {
        // update all desktop item for pc
        this.mPageDesktopViewModel.updateDesktopItemInfo();
      }
      this.resetUninstallName();
    }
    this.mSwiperPageVM.printPageInfo(this.indexInSwiper, this.mAppListInfo, this.isOuterDesktop);
    const pastSuccessFiles: string[] = AppStorage.get<string[]>('PastSuccessFiles') as string[];
    if (pastSuccessFiles) {
      AppStorage.delete('PastSuccessFiles');
    }

    // 手动触发Grid刷新布局
    this.gridOptions = GridLayoutOptionRet.getGridLayoutOptions(this.mAppListInfo);

    // 无障碍模式下，调整组件节点顺序，用于聚焦排序
    if (this.isAccessibilityMode) {
      this.updateAppListOrderForAccessibility();
    }
  }

  private refreshAppListComponentId(): void {
    const appListInfo: GridLayoutItemInfo[] = this.getAppListInfo()?.appGridInfo[this.indexInSwiper as number];
    if (this.isPc) {
      appListInfo?.forEach((item: GridLayoutItemInfo) => {
        const oldItem: GridLayoutItemInfo | undefined = this.mAppListInfo?.find((i) => i.keyName === item.keyName);
        if (oldItem?.componentId) {
          item.componentId = oldItem?.componentId;
        }
        if (item.appStatus !== AppStatus.INSTALLED) {
          log.showInfo(`refreshAppListComponentId, bundleName: ${item.bundleName}, appStatus: ${item.appStatus},` +
            `iconResource is invalid: ${CheckEmptyUtils.checkStrIsEmpty(item.iconResource)},` +
            `isOuterDesktop: ${this.isOuterDesktop}`);
        }
      });
    }
    this.mAppListInfo = appListInfo ?? [];
  }

  public uninstallApp(uninstallBundleName: string, appIndex?: number, shortcutId?: string): void {
    log.showInfo(`uninstall: ${uninstallBundleName} ${appIndex} ${shortcutId}`);
    this.uninstallParam.mUninstalledBundleName = uninstallBundleName;
    this.uninstallParam.mUninstalledAppIndex = appIndex ?? 0;
    this.uninstallParam.mUninstalledShortcutId = shortcutId ?? '';
  }

  private isUninstallApp(item: GridLayoutItemInfo): boolean {
    let isUninstall: boolean = false;
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('isUninstallApp is error, item is invalid.');
      return isUninstall;
    }
    isUninstall = !CheckEmptyUtils.checkStrIsEmpty(this.uninstallParam.mUninstalledBundleName) &&
      item.bundleName === this.uninstallParam.mUninstalledBundleName && item.appIndex ===
    this.uninstallParam.mUninstalledAppIndex && (item.shortcutId ?? '') === this.uninstallParam.mUninstalledShortcutId;
    if (isUninstall) {
      TraceUtil.startTrace(DomainName.HOME, TraceUtil.UNINSTALL_APP);
    }
    return isUninstall;
  }

  private resetUninstallName(): void {
    if (this.uninstallParam.mUninstalledBundleName !== '' && !this.mAppListInfo.some(item => item.bundleName === this.uninstallParam.mUninstalledBundleName)) {
      setTimeout(() => this.uninstallParam.mUninstalledBundleName = '', 1000);
    }
  }

  private updateCurrentPageEvent(pageIndex: number, currentPageInfoList: GridLayoutItemInfo[]): void {
    if (!currentPageInfoList) {
      return;
    }
    if (this.indexInSwiper === pageIndex) {
      log.showInfo('updateCurrentPageEvent start indexInSwiper:%{public}d', this.indexInSwiper);
      this.mAppListInfo = currentPageInfoList;
      this.filterItemExceedCurrentScreen();
      this.gridOptions = GridLayoutOptionRet.getGridLayoutOptions(this.mAppListInfo);
      if (this.isAccessibilityMode) {
        this.updateAppListOrderForAccessibility();
      }
    }
  }

  private onAccessibilityModeChange(): void {
    if (this.isAccessibilityMode) {
      this.multiSelectMap = MultiSelectManager.getInstance().multiSelectMap;
    }
    this.updateAppListOrderForAccessibility();
  }

  // 无障碍模式下，根据app的row和column调整组件节点顺序，不影响app在网格实际的位置，仅用于无障碍朗读模式下聚焦排序
  private updateAppListOrderForAccessibility():void {
    this.mAppListInfo = (this.mAppListInfo || []).sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      if (a.row !== b.row) {
        return (a.row || 0) < (b.row || 0) ? -1 : 1;
      }
      return (a.column || 0) - (b.column || 0);
    });
    log.showInfo(`updateAppListOrderForAccessibility`);
  }

  private onUpdatePageEvent(): void {
    log.showDebug('onUpdatePageEvent indexInSwiper:' + this.indexInSwiper);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_UPDATE_CURRENT_PAGE, this.updateCurrentPageCallBack);
  }

  private offUpdatePageEvent(): void {
    log.showInfo('offUpdatePageEvent indexInSwiper:' + this.indexInSwiper);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_UPDATE_CURRENT_PAGE, this.updateCurrentPageCallBack);
  }

  // ScreenOff
  private onScreenOff(): void {
    log.showDebug(' onScreenOff ');
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  // 此次修改和需要this.visible 协同
  private onScreenOn(): void {
    log.showDebug(' onScreenOn');
    if (this.visible != Visibility.Visible) {
      log.showInfo(' Screen On and show SwiperPage and SmartDock');
      this.visible = Visibility.Visible;
    }
  }

  // 开机进入锁屏时，需要隐藏桌面图标，折叠屏展开态是由两个swiperPage组成。
  private isHiddenForFirstEnter(): boolean {
    if (this.isPc) {
      return false;
    }
    if (!SCBSceneSessionManager.getInstance().isScreenLocked()) {
      return false;
    }
    if (sSCBOobeManager.isOobeActivated()) {
      return false;
    }
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    log.showDebug(`start unOnlock from the mainPageIndex ${mainPageIndex}`);
    let neighborPageIndex = this.mPageDesktopViewModel.getNeighborPage(mainPageIndex);
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      try {
        let folderStatus: number = AppStorage.get('folderStatus') as number;
        let isHiddenOnFold: boolean = folderStatus === DeviceState.FOLDED_STATE && this.indexInSwiper === mainPageIndex;
        let isHiddenOnExpand: boolean = (this.indexInSwiper === mainPageIndex ||
          this.indexInSwiper === neighborPageIndex) && folderStatus === DeviceState.EXPAND_STATE;
        return isHiddenOnFold || isHiddenOnExpand;
      } catch (ex) {
        log.showError(`isFoldDeviceExpanded failed ${ex.message}`);
      }
    } else {
      if (this.indexInSwiper === 0) {
        return true;
      }
    }
    return false;
  }

  private swiperPageCacheCallback(isCache: boolean): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    if (this.swiperPageCache !== isCache) {
      if (isCache && this.isDeskSwipe) {
        return;
      }
      this.swiperPageCache = isCache;
      if (isCache) {
        Trace.start('swiperPageCache');
      } else {
        Trace.end('swiperPageCache');
      }
    }
  }

  private registerEventHub(): void {
    this.desktopContext?.eventHub.on('swiperPageCache', this.swiperPageCacheFun);

    if (this.isPc) {
      try {
        // 设置父组件拖拽到子组件时响应onDragLeave
        let uiContext: UIContext = this.getUIContext();
        uiContext?.getDragController().setDragEventStrictReportingEnabled(true);
      } catch (error) {
        log.showError(`setDragEventStrictReportingEnabled failed: ${error?.code} ${error?.message}`);
      }
      // 在拖拽准备过程中设置无法多选，避免拖拽过程中出现框选效果
      this.desktopContext?.eventHub.on(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT, (isPreparing: boolean): void => {
        this.isPreparingDrag = isPreparing;
      })
      this.desktopContext?.eventHub.on(CommonConstants.DESKTOP_SELECT_STATUS_CHANGE, (items: GridLayoutItemInfo[]) => {
        log.showInfo(`selectStatusChange event receive: ${items?.length}`);
        if (items && items.length === 0) {
          this.initSelectStatus();
        }
      });
      this.desktopContext?.eventHub.on(EventConstants.EVENT_WORKSPACE_POSITION_CHANGE, this.workSpacePostionChange);
    }
  }

  deleteDataSource(): void {
    this.mAppListInfo = [];
  }

  private initLoadSwiperPageCall(): void {
    let callBack: SwiperPageLoadCallBack = {
      changeSwiperPageIndex: (index: number) => {
        this.indexInSwiper = index;
      },

      reloadDataSource: (index: number) => {
        if (index === undefined) {
          log.showError(` indexInSwiper error`);
          return;
        }
        this.indexInSwiper = index;
        this.appListInfoChange();
      }
    }
    SwiperLoadManager.getInstance(this.isOuterDesktop).swiperPageMap.set(this.swiperKey, callBack);
  }

  private removeLoadSwiperPageCall(): void {
    SwiperLoadManager.getInstance(this.isOuterDesktop).swiperPageMap.remove(this.swiperKey);
  }

  aboutToAppear(): void {
    this.mPageDragViewModel.initDeviceInfo(this.isOuterDesktop);
    this.folderStatus = (AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number;
    this.isSuperFold = DeviceHelper.isSuperFoldMachine();
    DesktopManager.getInstance().registerScreenChangeListener(this.singleHandChange);
    this.paddingSideUpdate();
    if (this.isHiddenForFirstEnter()) {
      log.showInfo(`hide swiper for first enter desktop, this.indexInSwiper: ${this.indexInSwiper}`);
      this.visible = Visibility.Hidden;
    }
    this.desktopList = new Array(MAX_GRIDITEM_COUNT).fill(new DeskTopItemStyle(0, 0, 1, 1, false));
    this.mPageDesktopStyleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
    this.initConfig();
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
    this.mBigFolderViewModel = BigFolderViewModel.getInstance();
    log.showDebug(`build item: ${JSON.stringify(this.mPageDesktopStyleConfig)}`);
    this.isPad = this.mPageDesktopViewModel.getDevice();
    let device: string = AppStorage.get('device') as string;
    this.isPhone = (device === CommonConstants.DEFAULT_DEVICE_TYPE);
    this.changeConfig();
    this.onUpdatePageEvent();
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE_ANIMATE, this.onDesktopModeChangeEvent);
    this.mPageDesktopViewModel.registerGridListener(this);
    this.mPageDesktopViewModel.registerUninstallListener(this.unInstallListener);
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    if (this.isPhone) {
      this.registerUnlockTransitionController();
    }
    this.initListeners();
    //fold screen animation
    this.foldController = {
      itemId: `${TAG}_desktopItem`,
      onFoldAnimation: () => this.foldedAnimation(),
    };
    this.expandController = {
      itemId: `${TAG}_desktopItem}`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    if (DeviceHelper.isThreeFoldProduct()) {
      this.tripleController = {
        itemId: `${TAG}_desktopItem`,
        onTripleAnimation: (oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean) =>
          this.tripleAnimationCtrl(oldState, newState, isNeedAnimation),
      };
      SCBTransitionManager.getInstance().registerTripleAnimationController(this.tripleController);
      TripleFoldExpandAnimUtils.updateCurrentMainIndex();
      TripleFoldExpandAnimUtils.setScreenProperty(this.mMarginLeft, this.mMarginRight, this.mFoldPaddingLeft,
        this.mFoldPaddingRight, this.mWorkSpaceWidth);
    }
    this.registerEventHub();
    this.appListInfoChange();
    this.initLoadSwiperPageCall();
    this.registerScreenIdChange();
    this.mIsGameEngineValid = HiSysEventUtil.isGameEngineValid();
    if (DeviceHelper.isThreeFoldProduct()) {
      let swiperManager: SwiperPageManager = SwiperPageManager.getInstance();
      swiperManager
        .updateScreenData(!swiperManager.getFirstPowerOnTriple(), this.mWorkSpaceWidth,
          this.mMarginLeft, this.mMarginRight, this.mFoldPaddingLeft,
          this.mFoldPaddingRight);
      swiperManager.setFirstPowerOnTriple(false);
      localEventManager.registerEventListener(this.mUpdateScreenDataListener,
        [EventConstants.EVENT_UPDATE_SCREEN_DATA, EventConstants.EVENT_REFRESH_SWIPER_PAGE]);
    }
    this.registerMultiSelectListener();
    log.showDebug(`swiperPage aboutToAppear end, index: ${this.indexInSwiper}`);
    if (this.isSuperFold) {
      RTLUtil.registerRtlChangeCallback(this.onRTLChangeEvent);
    }
  }

  private initListeners(): void {
    if (this.isPc) {
      this.mPageDesktopViewModel.registerSelectItemChangeListener(this.swiperKey, this);
      this.registerPasteEvent();
    }
  }

  private readonly mUpdateScreenDataListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string) => {
      if (event === EventConstants.EVENT_REFRESH_SWIPER_PAGE) {
        log.showInfo(`receive fresh layout event in three fold phone. pageIndex: ${this.indexInSwiper}`);
        this.changeSwiperState(params);
        return;
      }
      let mainPageIndex: number = desktopUtil.getPageIndexValue();
      if (!PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, mainPageIndex)) {
        return;
      }
      log.showInfo('mUpdateScreenDataListener receive event: %{public}s', event);
      if (event === EventConstants.EVENT_UPDATE_SCREEN_DATA) {
        animateTo({
          duration: 0,
        }, () => {
          SwiperPageManager.getInstance().updateScreenData(false, this.mWorkSpaceWidth,
            this.mMarginLeft, this.mMarginRight, this.mFoldPaddingLeft,
            this.mFoldPaddingRight);
        })
      }
    }
  }

  // fold screen animation
  private initFoldAnimation(translateX: number, isExpand: boolean): void {
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    this.gridItemAnimList = [];
    if (!PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, mainPageIndex)) {
      return;
    }
    let animationItemSize: number = this.mAppListInfo.length;
    let newDesktopList: DeskTopArray = Array(animationItemSize);
    let checkAppSet: Set<string> = new Set();
    let itemRow: number = 0;
    let itemColumn: number = 0;
    let totalColumns: number = isExpand ? 2 * this.getTotalColumns() : this.getTotalColumns();
    this.mAppListInfo.forEach((item: GridLayoutItemInfo) => {
      let itemKey: string = DesktopUtils.getItemKey(item, this.isOuterDesktop);
      if (checkAppSet.has(itemKey)) {
        return;
      }
      checkAppSet.add(itemKey);
      itemRow = FoldExpandAnimUtils.getSwiperPageRows(item);
      itemColumn = FoldExpandAnimUtils.getSwiperPageColumns(item, this.indexInSwiper, this.getTotalColumns());
      let itemAnimation: ItemAnimationParams = new ItemAnimationParams(itemKey, item.appName as string);
      itemAnimation.calculateItemFoldProperty(this.screenWidth, this.screenHeight, itemColumn, itemRow);
      this.gridItemAnimList.push(itemAnimation);
      let transX: number =
        FoldExpandAnimUtils.initItemTransX(itemColumn, totalColumns, translateX, this.screenWidth, isExpand);
      let transY: number = FoldExpandAnimUtils.initItemTransY(itemRow, this.screenHeight, isExpand);
      let scale: number = FoldExpandAnimUtils.getFoldExpandAnimScale();
      newDesktopList[itemAnimation.itemKey] = new DeskTopItemStyle(transX, transY, 0, scale, true);
    });
    animateTo({
      duration: 0,
    }, () => {
      this.desktopList = newDesktopList;
    })
  }

  private registerScreenIdChange(): void {
    this.getContext()?.eventHub.on(EventConstants.EVENT_SCREEN_ID_CHANGE, this.screenIdChangeCallback);
  }

  private unRegisterScreenIdChange(): void {
    this.getContext()?.eventHub.off(EventConstants.EVENT_SCREEN_ID_CHANGE, this.screenIdChangeCallback);
  }

  private expandedAnimation(): void {
    log.showInfo('start expandedAnimation')
    if (this.textShadowTimer >= 0) {
      clearTimeout(this.textShadowTimer);
    }
    this.initFoldAnimation(FoldAnimationConstants.EXPAND_FACTOR * this.workSpaceWidth, true);
    let itemDelay: number = 0;
    let maxDelay: number = 0;
    let totalColumns: number = 2 * this.getTotalColumns();
    this.gridItemAnimList.forEach((itemAnimation) => {
      itemDelay =
        FoldExpandAnimUtils.getFoldExpandDelayTime(itemAnimation.row, itemAnimation.column, totalColumns, true);
      maxDelay = Math.max(maxDelay, itemDelay);
      this.foldAnimCount ++;
      animateTo({
        curve: FoldExpandAnimUtils.getIconExpandAnimCurve(itemAnimation.row, itemAnimation.column),
        delay: itemDelay,
        onFinish: () => {
          this.foldAnimCount --;
          if (this.foldAnimCount === 0 && !CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            this.desktopList[itemAnimation.itemKey].unLockAnimate = false;
          }
        }
      }, () => {
        this.desktopList[itemAnimation.itemKey].translateX = 0;
        this.desktopList[itemAnimation.itemKey].translateY = 0;
        this.desktopList[itemAnimation.itemKey].scale = 1;
      })
      let alphaDelay: number =
        itemDelay + FoldExpandAnimUtils.getMidColOrRowAlphaDelayOffsetTime(itemAnimation.row, itemAnimation.column);
      animateTo(FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(alphaDelay), () => {
        this.desktopList[itemAnimation.itemKey].alpha = 1;
      })
    });
    this.textShadowTimer = setTimeout(() => {
      this.notifyUpdateTextShadow();
    }, maxDelay);
  }

  private foldedAnimation(): void {
    log.showInfo('start foldedAnimation')
    if (this.textShadowTimer >= 0) {
      clearTimeout(this.textShadowTimer);
    }
    this.initFoldAnimation(FoldAnimationConstants.FOLD_FACTOR * this.workSpaceWidth, false);
    let itemDelay: number = 0;
    let maxDelay: number = 0;
    let totalColumns: number = this.getTotalColumns();
    this.gridItemAnimList.forEach((itemAnimation) => {
      itemDelay =
        FoldExpandAnimUtils.getFoldExpandDelayTime(itemAnimation.row, itemAnimation.column, totalColumns, false);
      maxDelay = Math.max(maxDelay, itemDelay);
      this.foldAnimCount ++;
      animateTo({
        curve: FoldExpandAnimUtils.getIconFoldedAnimCurve(),
        delay: itemDelay,
        onFinish: () => {
          this.foldAnimCount --;
          if (this.foldAnimCount === 0 && !CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            this.desktopList[itemAnimation.itemKey].unLockAnimate = false;
          }
        }
      }, () => {
        this.desktopList[itemAnimation.itemKey].translateX = 0;
        this.desktopList[itemAnimation.itemKey].translateY = 0;
        this.desktopList[itemAnimation.itemKey].scale = 1;
      })
      animateTo(FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(itemDelay), () => {
        this.desktopList[itemAnimation.itemKey].alpha = 1;
      })
    });
    this.textShadowTimer = setTimeout(() => {
      this.notifyUpdateTextShadow();
    }, maxDelay);
  }

  private tripleAnimationCtrl(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean): void {
    log.showInfo(`tripleAnimationCtrl: oldState is ${oldState}, newState is ${newState} indexInSwiper: ${this.indexInSwiper}`);
    if (this.textShadowTimer >= 0) {
      clearTimeout(this.textShadowTimer);
    }
    if (!isNeedAnimation) {
      log.showInfo('swipePage noneed tripleAnimation');
      return;
    }
    let stateChange: SCBTripleStateChange = TripleFoldExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    if (stateChange === SCBTripleStateChange.INVALID) {
      log.showError('get stateChange invalid, return;');
      return;
    }
    TripleFoldExpandAnimUtils.updateCurrentMainIndex();
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    if (this.indexInSwiper === mainPageIndex) {
      TripleFoldExpandAnimUtils.setScreenProperty(this.mMarginLeft, this.mMarginRight, this.mFoldPaddingLeft,
        this.mFoldPaddingRight, this.mWorkSpaceWidth);
    }
    let isThreeDisplay: boolean = TripleFoldExpandAnimUtils.getIsThreeScreenDisplay();
    if (isThreeDisplay) {
      this.threeDisplayAnimation(stateChange);
    } else {
      this.tripleAnimation(stateChange, isNeedAnimation);
    }
  }

  // screen change animation on three fold product
  private initTripleAnimation(stateChange: SCBTripleStateChange, isNeedAnimation: boolean): void {
    let workSpaceWidth: number = this.mPageDesktopStyleConfig.mWorkSpaceWidth as number;
    let marginLeft: number = this.mPageDesktopStyleConfig.mMargin as number;
    let marginRight: number = this.mPageDesktopStyleConfig.mMargin as number;
    let foldPaddingLeft: number = 0;
    let foldPaddingRight: number = 0;
    // 除以2 用来区分左侧swiperpage还是右侧的swiperpage
    if (this.indexInSwiper % 2 === 0) {
      foldPaddingLeft = this.mPageDesktopViewModel?.getPageDesktopStyleConfig().mFoldPaddingSide as number;
    } else {
      foldPaddingRight = this.mPageDesktopViewModel?.getPageDesktopStyleConfig().mFoldPaddingSide as number;
    }
    if (Number.isNaN(foldPaddingLeft)) {
      foldPaddingLeft = 0;
    }
    if (Number.isNaN(foldPaddingRight)) {
      foldPaddingRight = 0;
    }
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.F_TO_G ||
      stateChange === SCBTripleStateChange.M_TO_F || stateChange === SCBTripleStateChange.G_TO_F) {
      foldPaddingLeft = this.mFoldPaddingLeft;
      foldPaddingRight = this.mFoldPaddingRight;
    }
    this.gridItemAnimList = [];
    SwiperPageManager.getInstance()
      .updateScreenData(true, workSpaceWidth, marginLeft, marginRight, foldPaddingLeft, foldPaddingRight);
    let newDesktopList: DeskTopArray = [];
    if (isNeedAnimation) {
      let checkAppSet: Set<string> = new Set();
      let itemRow: number = 0;
      let itemColumn: number = 0;
      this.mAppListInfo.forEach((item: GridLayoutItemInfo) => {
        let itemKey: string = DesktopUtils.getItemKey(item, this.isOuterDesktop);
        if (checkAppSet.has(itemKey)) {
          return;
        }
        checkAppSet.add(itemKey);
        itemRow = TripleFoldExpandAnimUtils.getSwiperPageRows(item);
        itemColumn =
          TripleFoldExpandAnimUtils.getSwiperPageColumns(item, this.indexInSwiper, this.getTotalColumns(), stateChange);
        let itemAnimation: ItemAnimationParams = new ItemAnimationParams(itemKey, item.appName as string);
        itemAnimation.calculateItemFoldProperty(this.screenWidth, this.screenHeight, itemColumn, itemRow);
        this.gridItemAnimList.push(itemAnimation);
        let transX: number = TripleFoldExpandAnimUtils.initTripleItemTransX(this.screenWidth, stateChange, itemColumn,
          item, SwiperPageManager.getInstance().getScreenData());
        let alpha: number = TripleFoldExpandAnimUtils.initTripleItemAlpha(stateChange, itemColumn);
        newDesktopList[itemAnimation.itemKey] = new DeskTopItemStyle(transX, 0, alpha, 1, true);
      });
    }
    animateTo({
      duration: 0,
    }, () => {
      this.desktopList = newDesktopList;
    })
  }

  private initThreeDisplayAnimation(stateChange: SCBTripleStateChange,  mainIndex: number): void {
    log.showInfo(`initThreeDisplayAnimation, stateChange is ${stateChange}`);
    this.gridItemAnimList = [];
    let newDesktopList: DeskTopArray = [];
    let checkAppSet: Set<string> = new Set();
    let itemRow: number = 0;
    let itemColumn: number = 0;
    let isReversed: boolean =
      SCBScreenSessionManager.getInstance().getScreenRotation() === RotationConstants.ROTATION_180;
    this.mAppListInfo.forEach((item: GridLayoutItemInfo) => {
      let itemKey: string = DesktopUtils.getItemKey(item, this.isOuterDesktop);
      if (checkAppSet.has(itemKey)) {
        return;
      }
      checkAppSet.add(itemKey);
      itemRow = TripleFoldExpandAnimUtils.getSwiperPageRows(item);
      itemColumn = TripleFoldExpandAnimUtils.getThreeDisplayColumn(item, this.indexInSwiper, mainIndex,
        this.getTotalColumns(), stateChange);
      let itemAnimation: ItemAnimationParams = new ItemAnimationParams(itemKey, item.appName as string);
      itemAnimation.calculateItemFoldProperty(this.screenWidth, this.screenHeight, itemColumn, itemRow);
      this.gridItemAnimList.push(itemAnimation);
      let initAnimationParams: number[] = TripleFoldExpandAnimUtils.initThreeDisplayItemAnimationParam(this.screenWidth,
        stateChange, isReversed, this.indexInSwiper);
      newDesktopList[itemAnimation.itemKey] = new DeskTopItemStyle(initAnimationParams[0], 0, initAnimationParams[1],
        initAnimationParams[2], true);
    });
    animateTo({
      duration: 0,
    }, () => {
      this.desktopList = newDesktopList;
    });
  }

  private tripleAnimation(stateChange: SCBTripleStateChange, isNeedAnimation: boolean): void {
    log.showInfo(`tripleAnimation, stateChange is ${stateChange}, isNeedAnimation is ${isNeedAnimation}`);
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    if (!PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, mainPageIndex)) {
      return;
    }
    this.initTripleAnimation(stateChange, isNeedAnimation);
    let maxDelay: number = 0;
    let alphaDelay: number = 0;
    this.gridItemAnimList.forEach((itemAnimation) => {
      alphaDelay = TripleFoldExpandAnimUtils.getTripleFoldExpandAlphaDelayTime(itemAnimation.column, stateChange);
      maxDelay = Math.max(maxDelay, alphaDelay);
      this.foldAnimCount++;
      animateTo({
        curve: Curve.Linear,
        delay: alphaDelay,
        duration: TripleFoldAnimationConstants.ALPHA_DURATION,
      }, () => {
        this.desktopList[itemAnimation.itemKey].alpha = 1;
      });
      animateTo({
        curve: TripleFoldExpandAnimUtils.getIconTripleFoldExpandAnimCurve(itemAnimation.column, stateChange),
        duration: TripleFoldAnimationConstants.ANIMATION_DURATION,
        onFinish: () => {
          this.foldAnimCount--;
          if (this.foldAnimCount === 0 && !CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            this.desktopList[itemAnimation.itemKey].unLockAnimate = false;
          }
        }
      }, () => {
        this.desktopList[itemAnimation.itemKey].translateX = 0;
      });
    });
    this.textShadowTimer = setTimeout(() => {
      this.notifyUpdateTextShadow();
    }, maxDelay);
  }

  private threeDisplayAnimation(stateChange: SCBTripleStateChange): void {
    log.showInfo(`threeDisplayAnimation, stateChange is ${stateChange}`);
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    // 避免部分场景下页面突然消失的问题以及保证动画的接续性，控制部分非实际显示页面延迟下树并同步执行动效
    if (!TripleFoldExpandAnimUtils.isCurrentPageWithAnimation(this.indexInSwiper, mainPageIndex, stateChange)) {
      return;
    }
    this.initThreeDisplayAnimation(stateChange, mainPageIndex);
    let maxDelay: number = TripleFoldAnimationConstants.ALPHA_DELAY_TWO_HUNDRED;
    let alphaDelay: number = 0;
    this.gridItemAnimList.forEach((itemAnimation) => {
      alphaDelay = TripleFoldExpandAnimUtils.getThreeDisplayAlphaDelayTime(itemAnimation.column, stateChange);
      this.foldAnimCount++;
      animateTo({
        curve: Curve.Linear,
        delay: alphaDelay,
        duration: TripleFoldAnimationConstants.ALPHA_DURATION,
      }, () => {
        this.desktopList[itemAnimation.itemKey].alpha = 1;
        this.desktopList[itemAnimation.itemKey].scale = 1;
      });
      animateTo({
        curve: TripleFoldExpandAnimUtils.getThreeDisplayItemCurves(itemAnimation.column, this.indexInSwiper,
          mainPageIndex, stateChange),
        duration: TripleFoldExpandAnimUtils.getThreeDisplayItemDuration(stateChange),
        onFinish: () => {
          this.foldAnimCount--;
          if (this.foldAnimCount === 0 && this.indexInSwiper === mainPageIndex) {
            // 动画执行完成后，将非实际显示页面下树
            this.resetPreNextMargin();
          }
          if (this.foldAnimCount === 0 && !CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            this.desktopList[itemAnimation.itemKey].unLockAnimate = false;
          }
        }
      }, () => {
        this.desktopList[itemAnimation.itemKey].translateX = 0;
      });
    });
    this.textShadowTimer = setTimeout(() => {
      this.notifyUpdateTextShadow();
    }, maxDelay);
  }

  private resetPreNextMargin(): void {
    let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
    if (displayCountViewModel.getDisplayCountData().getCacheCount() !== 0) {
      displayCountViewModel.getDisplayCountData().setCacheCount(0);
    }
    displayCountViewModel.setNextMargin(0);
    displayCountViewModel.setPreMargin(0);
  }

  private getTotalColumns(): number {
    const result = LayoutViewModel.getInstance(this.singleContext).calculateDesktop();
    return (result.mColumns === undefined) ? 4 : result.mColumns
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear, this.indexInSwiper: ${this.indexInSwiper}`);
    if (this.isPhone) {
      SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    }
    DesktopManager.getInstance().unregisterScreenChangeListener(this.singleHandChange);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isThreeFoldProduct()) {
      SCBTransitionManager.getInstance().unRegisterTripleAnimationController(this.tripleController);
    }
    this.mPageDesktopViewModel.unregisterUninstallListener(this.unInstallListener);
    this.offUpdatePageEvent();
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE_ANIMATE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off('swiperPageCache', this.swiperPageCacheFun);
    this.unRegisterPasteEvent();
    this.removeLoadSwiperPageCall();
    this.mPageDesktopViewModel.unregisterGridListener();
    this.unRegisterScreenIdChange();
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
    if (this.isPc) {
      this.desktopContext?.eventHub.off(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT);
      this.desktopContext?.eventHub.off(CommonConstants.DESKTOP_SELECT_STATUS_CHANGE);
      this.desktopContext?.eventHub.off(EventConstants.EVENT_WORKSPACE_POSITION_CHANGE, this.workSpacePostionChange);
    }
    if (this.isSuperFold) {
      RTLUtil.unregisterRtlChangeCallback(this.onRTLChangeEvent);
    }
    GridItemsPool.getInstance().release();
    if (DeviceHelper.isThreeFoldProduct()) {
      localEventManager.unregisterEventListener(this.mUpdateScreenDataListener);
    }
    this.unRegisterMultiSelectListener();
  }

  private changeColumnAndRow(): void {
    this.changeConfig();
  }

  private screenIdChangeCallback: () => void = () => {
    log.showInfo('screen property change received, start to reInit config');
    this.initConfig();
    this.changeConfig();
  }

  itemMove(moveX: number, moveY: number) {
    if (this.mIsFormStackExpand) {
      log.showInfo(`itemMove return, fsExpandShow: ${this.mIsFormStackExpand}`);
      return;
    }
    let curPageIndex: number = PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex();
    const dragItemInfo = PageDesktopDragHandler.getInstance(this.singleContext).getSingleDragItemInfo();
    if (!dragItemInfo) {
      return;
    }
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER && FolderManager.getInstance().isFolderOpen()) {
      // 编辑模式下，可拖出预置布局页文件夹内图标进入宫格范围，该场景不能触发翻页
      const openFolder: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
      const curPage: number = openFolder.page ?? CommonConstants.INVALID_VALUE;
      if (layoutLockUtil.isLockedPage(curPage, 'itemMove on SwiperPage')) {
        return;
      }
      if (!DeliverUtil.canFolderItemDragOut(openFolder.folderId, dragItemInfo.bundleName)) {
        return;
      }
    }

    let margin = this.getMargin();
    let gridSpaceWidth = this.mGridSpaceWidth;
    let dragItemInfoPage = dragItemInfo.page ?? 0;
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      gridSpaceWidth = gridSpaceWidth - 3;
      margin = margin + 3;
      dragItemInfoPage = 2 * Math.floor(dragItemInfoPage / 2) + 1;
    }

    if (moveY >= this.mGridSpaceHeight) {
      this.mPageDesktopDragHandler.clearSwipeTimeout();
      return;
    }
    const isMovingLeft: boolean = (moveX - this.mIconSize / 4) < margin;
    const isMovingRight: boolean = (moveX + this.mIconSize / 4) > gridSpaceWidth;
    const isMovingNext: boolean = RTLUtil.isRTL() ? isMovingLeft : isMovingRight;
    const isMovingPrevious: boolean = RTLUtil.isRTL() ? isMovingRight : isMovingLeft;
    if (isMovingPrevious && curPageIndex > 0) {
      const callback = () => {
        this.mPageDesktopViewModel.showPrevious();
      };
      this.mPageDesktopDragHandler.setSwipeTimeout(callback);
    } else if (isMovingNext) {
      const callback = () => {
        this.dealMoveNextPage(curPageIndex, dragItemInfoPage, dragItemType);
      };
      this.mPageDesktopDragHandler.setSwipeTimeout(callback);
    } else {
      this.dealDragToIntelligent(dragItemInfo, isMovingPrevious, curPageIndex, moveY);
    }
  }

  private dealDragToIntelligent(dragItemInfo: GridLayoutItemInfo, isMovingPrevious: boolean,
    curPageIndex: number, moveY: number): void {
    if (dragItemInfo.typeId === CommonConstants.TYPE_CARD && isMovingPrevious && curPageIndex === 0) {
      const callback = (): void => {
        this.dealMoveCard(dragItemInfo, curPageIndex, moveY);
      };
      this.mPageDesktopDragHandler.setSwipeTimeout(callback);
    } else {
      this.mPageDesktopDragHandler.clearSwipeTimeout();
    }
  }

  // 后期这个方法会跟GridSwiper合一
  private dealMoveNextPage(curPageIndex: number, dragItemInfoPage: number, dragItemType: number): void {
    let cachePageIndex = this.mPageDesktopViewModel.getGridPageCount();
    if ((curPageIndex >= cachePageIndex - 1 ) && !this.mPageDesktopViewModel.isBlankPage(curPageIndex)) {
      if (dragItemInfoPage === curPageIndex && (dragItemType === CommonConstants.DRAG_FROM_DESKTOP ||
        dragItemType === CommonConstants.DRAG_FROM_APP_ICON) && this.mPageDesktopViewModel.isSingleItemPage(curPageIndex)) {
        log.showInfo('itemMove isSingleItemPage return, curPageIndex: %{public}d, dragItemInfoPage: %{public}d, dragItemType: %{public}d',
          curPageIndex, dragItemInfoPage, dragItemType);
        return;
      }
      if (!this.editModeState.isInEditMode()) {
        this.mPageDesktopViewModel.addBlankPage(true);
        log.showInfo('add blank page, current page: %{public}d pageCount: %{public}d', curPageIndex, cachePageIndex);
      }
    } else if (curPageIndex < cachePageIndex - 1) {
      log.showInfo(`swiperPage showNext`)
      this.mPageDesktopViewModel.showNext();
    } else {
      log.showInfo('itemMove not showNext, curPageIndex: %{public}d, dragItemInfoPage: %{public}d cachePageIndex: %{public}d, isBlankPage: %{public}s',
        curPageIndex, dragItemInfoPage, cachePageIndex, this.mPageDesktopViewModel.isBlankPage(curPageIndex));
    }
  }

  // 后期这个方法会跟GridSwiper合一
  private dealMoveCard(dragItemInfo: GridLayoutItemInfo, curPageIndex: number, moveY: number): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo('itemMove isInEditMode');
      return;
    }
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showInfo('isSimpleLauncherMode');
      return;
    }
    if (!FormCenterViewModel.getInstance().getNegativeAddCardStatus()) {
      // 桌面支持卡片可以往负一屏拖拽卡片
      log.showInfo('intelligent not support add card');
      return;
    }
    log.showInfo('showNegativePage.curPageIndex=%{public}d', curPageIndex);
    if (!sOutSideWindowMgr.getNegativeAnimateEnd()) {
      return;
    }
    let screenWidth = AppStorage.get('screenWidth') as number;
    sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? screenWidth : -screenWidth);
    sOutSideWindowMgr.setNegativeDesktopProgress(0);
    sOutSideWindowMgr.setNegativeScreenVisible(true);
    SwiperGestureHandler.getInstance().intoNegativeAnimation();
    PageDesktopDragHandler.getInstance(this.singleContext).notifyIntelligentDragEnter();
    this.mPageDesktopDragHandler.onDragLeave(0, 0);
  }

  private changeConfig(): void {
    let mGridConfig: GridLayoutConfig = this.mPageDesktopViewModel.getGridConfig();
    let column: number = mGridConfig?.column as number;
    let row: number = mGridConfig?.row as number;
    this.columnsTemplate = '';
    this.rowsTemplate = '';
    for (let i = 0; i < column; i++) {
      this.columnsTemplate += '1fr '
    }
    for (let i = 0; i < row; i++) {
      this.rowsTemplate += '1fr '
    }
    log.showInfo(`changeConfig pad,column:${column}, row:${row}`)
  }



  private getPageIndex(): number {
    if (this.isOuterDesktop) {
      return this.outerPageIndex;
    }
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    return Math.floor(this.pageIndex / displayCount) * displayCount;
  }

  private handleAccessibilityClick(item: GridLayoutItemInfo): void {
    if (!this.isAccessibilityMode) {
      return;
    }

    // app
    if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      log.showInfo(`DesktopAccessibility handleAccessibilityClick appName: ${item.appName} keyName: ${item.keyName}`);
      let appItemAccessibilityClickEventId: string = `appItemAccessibilityClick${item.keyName}`;
      this.desktopContext?.eventHub.emit(appItemAccessibilityClickEventId);
      return;
    }

    // small folder
    if (item.typeId === CommonConstants.TYPE_FOLDER && GridLayoutUtil.isSmallFolder(item)) {
      log.showInfo(`smallfolder handleAccessibilityClick folderName:${item.folderName} folderId:${item.folderId}`);
      AppStorage.setOrCreate(CommonConstants.OPEN_SOURCES, false);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      ContractedFolderCommonViewModel.getInstance().openFolder('AccessibilityClick to open', item.folderId, false);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
      return;
    }

    // big folder
    if (item.typeId === CommonConstants.TYPE_FOLDER && !GridLayoutUtil.isSmallFolder(item)) {
      log.showInfo(`bigfolder handleAccessibilityClick folderName:${item.folderName} folderId:${item.folderId}`);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
      this.mBigFolderViewModel.openFolder(false, item);
      return;
    }

    // form stack
    if (item.typeId === CommonConstants.TYPE_FORM_STACK && item.layoutInfo &&
    item.layoutInfo[0][0] && item.layoutInfo[0].length > 1) {
      log.showInfo(`form stack handleAccessibilityClick formStackId:${item.formStackId}`);
      let formStackItemAccessibilityClickEventId: string = `formStackItemAccessibilityClick${item.formStackId}`;
      this.desktopContext?.eventHub.emit(formStackItemAccessibilityClickEventId);
      return;
    }
  }

  private surfaceCacheFlag():boolean {
    // 拖拽或在响应应用启动页不做节点组标记
    if (this.isDrag || (SCBTransitionManager.getInstance().getStartExitAnimationCount() > 0 &&
      desktopUtil.getTouchItemPage() === this.indexInSwiper)) {
      return false;
    }
    let mainPageIndex = PageDesktopDragHandler.getInstance(this.singleContext).getPageIndex();
    if (PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, mainPageIndex)) {
      if (AppModel.getInstance().mIsChangeTheme) {
        HiDfxEventUtil.reportChanThemSlideOrStart(true, false);
      }
      log.showInfo(`surfaceCacheFlag swiperPageCache:${this.swiperPageCache} index:${this.indexInSwiper} pageIndex:${this.pageIndex} isDrag:${this.isDrag}`);
      return this.swiperPageCache;
    }
    return false;
  }

  private getTransitionEffect(item: GridLayoutItemInfo): TransitionEffect | undefined {
    if (this.isUninstallApp(item)) {
      return TRANSITION_UNINSTALL;
    }
    if (item?.typeId === CommonConstants.TYPE_CARD &&
    FormRelationManager.getInstance().isSceneBoardCard(item.bundleName, item.cardName)) {
      return TRANSITION_CARD_REPLACE;
    }
    if (item?.typeId === CommonConstants.TYPE_FORM_STACK && item.layoutInfo &&
      item.layoutInfo[0]?.findIndex((singleCardItem) => {
        return FormRelationManager.getInstance().isSceneBoardCard(singleCardItem.bundleName, singleCardItem.cardName);
      }) !== CommonConstants.INVALID_VALUE) {
      return TRANSITION_CARD_REPLACE;
    }
    return undefined;
  }

  private getIconPadding(item: GridLayoutItemInfo): Padding | Length | LocalizedPadding {
    let isAppIcon = item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
    // 文件夹的padding自己处理
    if (item.typeId === CommonConstants.TYPE_FOLDER && this.isAccessibilityMode) {
      return 0;
    }
    return this.isPhone ? {
      top: isAppIcon ? 0 : this.mItemPadding,
      bottom: isAppIcon ? 0 : this.mItemPadding
    } : this.mItemPadding - featureConstants.BORDER_WIDTH
  }

  private setShiftArrowSelectItem(item: GridLayoutItemInfo | undefined, pageIndex: number): void {
    if (item === undefined) {
      log.showError('setShiftArrowSelectItem failed');
      return;
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESET_ALL_SELECT_STATUS, null);
    this.lastFocusItem = item;
    this.setLayoutItemsBetween(this.shiftStartItem, this.lastFocusItem, pageIndex);
    this.mPageDesktopViewModel.onSelectItemChange(this.selectedItemList, true);
  }

  private doKeyEvent(event: KeyEvent, pageIndex: number): void {
    if (!this.isPc || !event || event.type === KeyType.Up) {
      return;
    }
    try {
      log.showDebug(`isShiftDown shiftStartItem: ${this.mPageDesktopViewModel.getItemKeyByType(this.shiftStartItem)}`);
      let fromItem = this.lastFocusItem ?? this.shiftStartItem;
      if (!fromItem) {
        log.showError('doKeyEvent fail, from item is null');
        return;
      }
      if (AppStorage.get<boolean>('isShiftKeyDown')) {
        switch (event?.keyCode) {
          case KeyCodeConstants.KEYCODE_DPAD_UP:
            this.setShiftArrowSelectItem(this.mFocusManager.findUpItem(fromItem), pageIndex);
            break;
          case KeyCodeConstants.KEYCODE_DPAD_DOWN:
            this.setShiftArrowSelectItem(this.mFocusManager.findBottomItem(fromItem), pageIndex);
            break;
          case KeyCodeConstants.KEYCODE_DPAD_LEFT:
            this.setShiftArrowSelectItem(this.mFocusManager.findLeftItem(fromItem), pageIndex);
            break;
          case KeyCodeConstants.KEYCODE_DPAD_RIGHT:
            this.setShiftArrowSelectItem(this.mFocusManager.findRightItem(fromItem), pageIndex);
            break;
          default:
            break;
        }
      } else if ((event?.keyCode === KeyCodeConstants.KEYCODE_DPAD_UP ||
        event?.keyCode === KeyCodeConstants.KEYCODE_DPAD_DOWN ||
        event?.keyCode === KeyCodeConstants.KEYCODE_DPAD_LEFT ||
        event?.keyCode === KeyCodeConstants.KEYCODE_DPAD_RIGHT) && event?.type === KeyType.Down) {
        this.mFocusManager.setDirectionsFocus(fromItem, event);
      }
    } catch (error) {
      log.showError(`shift arrow event failed: ${error?.code} ${error?.message}`);
    }
  }

  private isEnableMultiSelect(): boolean {
    if (this.isSuperFold) {
      return false;
    }
    return this.isPc ? !this.isPreparingDrag : this.isPreparingDrag;
  }

  private focusCallBackHandler(item: GridLayoutItemInfo): void {
    if (item?.typeId === CommonConstants.TYPE_CARD) {
      return;
    }
    let curId: string = DesktopUtils.getGridItemId(this.indexInSwiper, item, this.isOuterDesktop);
    let focusInstance: SwiperPageFocusManager = SwiperPageFocusManager.getInstance();
    if (focusInstance.getIsRotation()) {
      // 旋转后的焦点，强制更新
      let focusId: string = focusInstance.getFocusComponentId();
      focusInstance.setFocusComponentId(focusId, false);
      FocusUtil.requestFocus(this.getUIContext(), focusId);
      log.info(`onFocus focusCallBackHandler SwiperPageFocusManager force set focusID:${focusId}`);
    } else {
      log.info(`onFocus focusCallBackHandler SwiperPageFocusManager force curID:${curId}`);
      focusInstance.setFocusComponentId(curId, false);
    }
  }

  private editModeSingePageViewDataGetOpacity(): number {
    // 拉起图标编辑的场景，会对SwiperPage做透明度
    if (this.editModeExtensionData.isShowUIExtension() &&
      this.iconEditWantData.getExtensionWant()?.abilityName == IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME) {
      return this.editModeSingePageViewData.getOpacity();
    }
    return this.editModeFolderOpacity;
  }

  private getGridMarginTop(): number {
    if (this.isOuterDesktop) {
      return this.mWorkSpaceMarginTop - CommonConstants.OUTER_SCREEN_OFFSET;
    }
    return this.mWorkSpaceMarginTop;
  }

  private isLockLayoutInEditMode(): boolean {
    return lockLayoutManager.isLockLayout() && this.editModeState.isInEditMode();
  }

  private getAccessSelectedInEdit(item: GridLayoutItemInfo): boolean {
    const uniqueId: string = MultiSelectManager.getInstance().getUniqueId(item);
    return this.multiSelectMap.has(uniqueId);
  }

  private containsFolder(): boolean {
    log.info(`containsFolder mAppListInfo: ${this.mAppListInfo?.some(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? false}`);
    return this.mAppListInfo?.some(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? false;
  }

  private gridAreaChange(newValue: Area): void {
    if (AppStorage.get('isDeskSwipe') || this.indexInSwiper !== PageDesktopModel.getInstance().getPageIndex()) {
      return;
    }
    // 布局区域数据变化通知桌面布局重新计算
    let config = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
    let submit = false;
    let nWidth = Number(newValue.width);
    let nHeight = Number(newValue.height);
    let mTop = Number(newValue.globalPosition?.y ?? 0);
    let lTop = Number(newValue.globalPosition?.x ?? 0);
    if (config.mGridWidth !== nWidth) {
      log.showInfo(`swiperpage change GridWidth:${config.mGridWidth} 》 ${nWidth}`);
      config.realGridWidth = nWidth;
      submit = true;
    }
    if (config.mGridHeight !== nHeight) {
      log.showInfo(`swiperpage change GridHeight:${config.mGridHeight} 》 ${nHeight}`);
      config.realGridHeight = nHeight;
      submit = true;
    }
    if (config.realPaddingTop !== mTop) {
      log.showInfo(`swiperpage change PaddingTop:${config.realPaddingTop} 》 ${mTop}`);
      config.realPaddingTop = mTop;
      submit = true;
    }
    if (config.realPaddingLeft !== lTop) {
      log.showInfo(`swiperpage change PaddingLeft:${config.realPaddingLeft} 》 ${lTop}`);
      config.realPaddingLeft = lTop;
      submit = true;
    }
    if (submit) {
      // 通知九宫格重新计算
      log.showInfo(`swiperpage change emit ${EventConstants.EVENT_CHANGE_DESKTOP_DISPLAY_COUNT}; ${this.swiperKey} ${JSON.stringify(newValue)}`);
      this.desktopContext?.eventHub.emit(EventConstants.EVENT_CHANGE_DESKTOP_DISPLAY_COUNT);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      SwiperPageWhiteBoxComponent({
        singleContext: this.singleContext,
        mPageDesktopStyleConfig: this.mPageDesktopStyleConfig,
        mGridWidth: this.mGridWidth,
        mGridHeight: this.mGridHeight,
        mShowWhiteBoxReason: this.mShowWhiteBoxReason,
        folderStatus: this.folderStatus,
        mFoldPaddingRight: this.mFoldPaddingRight,
        mFoldPaddingLeft: this.mFoldPaddingLeft,
        mIsPortrait: this.mIsPortrait,
        indexInSwiper: this.indexInSwiper,
        getIndexInSwiper: (): number => this.indexInSwiper,
        isOuterDesktop: this.isOuterDesktop
      })

      Grid(undefined, this.gridOptions) {
        if (this.isPc) {
          ForEach(this.mAppListInfo, (item: GridLayoutItemInfo) => {
            GridItemReuseComponent({
              item: item,
              mPageDesktopViewModel: this.mPageDesktopViewModel,
              mNameLines: this.mNameLines,
              mMaxNameLines: this.mMaxNameLines,
              isPad: this.isPad,
              mPageDesktopStyleConfig: this.mPageDesktopStyleConfig,
              mIconSize: this.mIconSize,
              onItemSelect: this.onItemSelect,
              isDesktopLayout: this.isDesktopLayout,
              indexInSwiper: this.indexInSwiper,
              swiperKey: this.swiperKey,
              selectedItemList: this.selectedItemList,
              isPreparingDrag: this.isPreparingDrag,
              isPhone: this.isPhone,
              isAccessibilityMode: this.isAccessibilityMode,
              handleAccessibilityClick: (item: GridLayoutItemInfo) => {
                this.handleAccessibilityClick(item);
              },
              doKeyEvent: (event: KeyEvent, pageIndex: number) => {
                this.doKeyEvent(event, pageIndex);
              },
              getTransitionEffect: (item: GridLayoutItemInfo) => {
                this.getTransitionEffect(item);
              },
              setHoverItem: (isHover?: boolean, item?: GridLayoutItemInfo) => {
                this.setHoverItem(isHover, item);
              },
              getZIndex: (info?: GridLayoutItemInfo) => {
                return this.getZIndex(info);
              },
              getIconPadding: (item: GridLayoutItemInfo) => {
                return this.getIconPadding(item);
              },
              gridItemZIndex: this.getZIndex(item),
            })
          }, (item: GridLayoutItemInfo, index): string => {
            return this.mPageDesktopViewModel.getForeachKey(item, this.desktopIconChange, this.mIsGameEngineValid,
              0, this.isOuterDesktop);
          })
        } else {
          ForEach(this.mAppListInfo, (item: GridLayoutItemInfo) => {
            GridItem() {
              DesktopItem({
                singleContext: this.singleContext,
                item: item,
                mPageDesktopViewModel: this.mPageDesktopViewModel,
                mNameLines: this.mNameLines,
                mMaxNameLines: this.mMaxNameLines,
                isPad: this.isPad,
                mPageDesktopStyleConfig: this.mPageDesktopStyleConfig,
                mFileFolderOpacity: featureConstants.DEFAULT_ITEM_ALPHA,
                mTag: TAG,
                isDesktopItem: true,
                desktopStyle: this.desktopList[DesktopUtils.getItemKey(item, this.isOuterDesktop)],
                iconSize: this.mIconSize,
                onItemSelect: this.onItemSelect,
                isDesktopLayout: this.isDesktopLayout,
                getIndexInSwiper: (): number => this.indexInSwiper,
                swiperKey: this.swiperKey,
                selectedStatus: this.selectStatus,
                isOuterDesktop: this.isOuterDesktop
              })
            }
            .onFocus(() => {
              this.focusCallBackHandler(item);
            })
            .zIndex(this.getZIndex(item))
            .accessibilityLevel(DesktopAccessibilityUtils
              .getDesktopItemAccessibilityLevel(item, this.isAccessibilityMode))
            .accessibilityGroup(DesktopAccessibilityUtils
              .getDesktopItemAccessibilityGroup(item, this.isAccessibilityMode))
            .accessibilityText(DesktopAccessibilityUtils
              .getDesktopItemAccessibilityText(item, this.isAccessibilityMode, this.isOuterDesktop))
            .accessibilitySelected(this.getAccessSelectedInEdit(item))
            .onClick(this.isAccessibilityMode ? () => {
              this.handleAccessibilityClick(item);
            } : undefined)
            .gesture(
              LongPressGesture({ repeat: false })
                .onAction((event: GestureEvent|undefined) => {
                })
            )
            .onTouch((event?: TouchEvent) => {
              if ((event?.type === TouchType.Up || event?.type === TouchType.Cancel) &&
                item?.typeId === CommonConstants.TYPE_APP) {
                AppStorage.setOrCreate('isIconTouch', false);
              } else if (event?.type === TouchType.Down && item?.typeId === CommonConstants.TYPE_APP) {
                AppStorage.setOrCreate('isIconTouch', true);
              }
              desktopUtil.setTouchItemPage(this.indexInSwiper);
            })
            .id(DesktopUtils.getGridItemId(this.indexInSwiper, item, this.isOuterDesktop))
            .padding(this.getIconPadding(item))
            .onHover((isHover?: boolean) => {
              let isMouseCross: boolean = AppStorage.get('isMouseCross') as boolean;
              const isDrag: boolean = AppStorage.get('isDrag') as boolean;
              isMouseCross = isDrag ? true : isMouseCross;
              if (isMouseCross) {
                return;
              }
              this.setHoverItem(isHover, item);
            })
            .clip(CommonConstants.DEFAULT_CLIP_FALSE)
            .onDisAppear(() => {
              TraceUtil.endTrace(DomainName.HOME, TraceUtil.UNINSTALL_APP);
            })
            .transition(this.getTransitionEffect(item))
          }, (item: GridLayoutItemInfo, index): string => {
            return this.mPageDesktopViewModel.getForeachKey(item, this.desktopIconChange, this.mIsGameEngineValid,
              this.disabledLiveFormCount, this.isOuterDesktop);
          })
        }
      }
      .onAreaChange((oldValue: Area, newValue: Area) => this.gridAreaChange(newValue))
      .visibility(this.visible)
      .multiSelectable(this.isEnableMultiSelect())
      .clip(CommonConstants.DEFAULT_CLIP_FALSE)
      .id(this.pageEditViewModel.getSwiperComponentId(this.isOuterDesktop, this.indexInSwiper))
      .columnsTemplate(this.columnsTemplate)
      .rowsTemplate(this.rowsTemplate)
      .columnsGap(this.mColumnsGap)
      .rowsGap(this.mRowsGap)
      .width(this.mWorkSpaceWidth)
      .height(DeviceHelper.isPC() ? undefined : this.mWorkSpaceHeight)
      .foregroundEffect({ radius: this.mBlur })
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
      .allowDrop(this.getAllowedDropTypes())
      .offset({y: this.offsetY})
      .margin(RTLUtil.isRTL() ?
        { left: this.mMarginLeft + this.mFoldPaddingRight,
          right: this.mMarginRight + this.mFoldPaddingLeft,
          top: DeviceHelper.isPC() ? undefined : this.getGridMarginTop() } :
        { right: this.mMarginRight + this.mFoldPaddingRight,
          left: this.mMarginLeft + this.mFoldPaddingLeft,
          top: DeviceHelper.isPC() ? undefined : this.getGridMarginTop(),
        })
      .padding(DeviceHelper.isPC() ? undefined : {
        right: this.mWorkSpacePaddingRight,
        left: this.mWorkSpacePaddingLeft,
        top: this.mWorkSpacePaddingTop,
        bottom: this.mWorkSpacePaddingBottom
      })
      .onDragEnter((event: DragEvent, extraParams?: string) => {
        if (formZoomController.isMenuPreviewDragging(extraParams)) {
          return;
        }
        if (this.isPc) {
          this.mPageDesktopViewModel.setFileFolderBadge(event, extraParams);
        }
        if (this.isSuperFold) {
          this.mPageDesktopDragHandler.setDragPageIndex(this.indexInSwiper);
        }
        this.mPageDesktopDragHandler.dealSwiperPageOnDragEnter(this.indexInSwiper, event, extraParams);
        dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
        if (layoutLockUtil.isLockedPage(this.indexInSwiper, 'dragEnter on swiperPage')) {
          log.showInfo(`this drag is locked page`);
          return;
        }
        let rectangle = event.getPreviewRect();
        const x = event.getWindowX();
        const y = event.getWindowY();
        let leftHotAreaSize = Number(rectangle.x) + Number(rectangle.width) - x;
        if (RTLUtil.isRTL()) {
          leftHotAreaSize = Number(rectangle.width) - leftHotAreaSize;
        }
        const bottomHotAreaSize = y - Number(rectangle.y);
        log.showInfo(`onDragEnter bottomHotAreaSize: ${bottomHotAreaSize} = ${y} - ${Number(rectangle.y)}`);
         // 编辑模式通知删除按钮改变热区
        if (editModeManager.isInEditMode() && batchUninstallChain.currentType !== ForwardType.INIT) {
          EditModeUtils.notifyHotAreaChanged(leftHotAreaSize, bottomHotAreaSize);
          log.showInfo(`NotifyHotAreaChange: leftHotAreaSize =
            ${leftHotAreaSize}; bottomHotAreaSize = ${bottomHotAreaSize}`);
        }
        if (AppStorage.get('undoDragFormVisible')) {
          this.desktopContext?.eventHub.emit(FormConstants.EVENTHUB_FORM_MANAGER_UNDO_HOT_AREA,
            leftHotAreaSize, bottomHotAreaSize);
        }
      })
      .onDragMove((event: DragEvent, extraParams?: string) => {
        if (formZoomController.isMenuPreviewDragging(extraParams)) {
          const dragStartPos: Position | undefined = formZoomController.getDragStartPos();
          if (!dragStartPos) {
            formZoomController.setDragStartPos({ x: event.getWindowX(), y: event.getWindowY() });
            return;
          }
          const offsetX: number = event.getWindowX() - (dragStartPos.x as number);
          const offsetY: number = event.getWindowY() - (dragStartPos.y as number);
          log.showInfo(`formZoom menuPreviewDragging info: ${this.pageIndex} ${offsetX} ${offsetY}`);
          const params: FormZoomDragEvtParams = {
            type: FormZoomDragEvtType.DRAG_MOVE,
            offsetX,
            offsetY
          };
          formZoomController.handleDragFormZoom(params);
          return;
        }
        const isDrag: boolean = AppStorage.get('isDrag') as boolean;
        if (this.isPc) {
          const isPcStatusBarDrag: boolean = AppStorage.get(PC_STATUSBAR_DRAG_KEY) as boolean;
          if (isPcStatusBarDrag) {
            log.showInfo('pc statusbar is Dragging, no need set Badge!');
            return;
          }
          this.mPageDesktopViewModel.setFileFolderBadge(event, extraParams);
        }
        if (pageEditManager.dragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING) {
          log.showInfo(`return ondragMove due to DRAG_PAGE_MOVING with index ${this.indexInSwiper}`);
          return;
        }
        if (!isDrag) {
          log.showInfo('dealDragMoveEvent isDrag: %{public}s', isDrag);
          return;
        }
        log.showDebug(`${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${this.indexInSwiper} onDragMove (event: [${event.getX()}, ${event.getY()}])`);
        if (this.isPhone) {
          this.itemMove(event.getX(), event.getY());
        }
        if (layoutLockUtil.isLockedPage(this.indexInSwiper)) {
          return;
        }
        this.mPageDesktopDragHandler.dealSwiperPageOnDragMove(event, extraParams);
      })
      .onTouch((event: TouchEvent) => {
        if (this.isPc && event.source === SourceType.Mouse) {
          if (event.type === TouchType.Down) {
            this.isStartMultiSelect = true;
          }
          if (event.type === TouchType.Move) {
            if (this.isStartMultiSelect && !AppStorage.get<boolean>('isCtrlKeyDown')) {
              log.showInfo(`isStartMultiSelect end:${this.isStartMultiSelect}`);
              this.isStartMultiSelect = false;
              localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESET_ALL_SELECT_STATUS, null);
            }
          }
        }
      })
      .onDragLeave((event: DragEvent, extraParams?: string) => {
        let tag = `${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${this.indexInSwiper} onDragLeave`;
        log.showInfo(`${tag} (event: [${event?.getX()}, ${event?.getY()}], pageIndex:
          ${desktopUtil.getPageIndexValue()}, indexInSwiper:${this.indexInSwiper})`);
        if (formZoomController.isMenuPreviewDragging(extraParams)) {
          return;
        }
        this.mShowWhiteBoxReason = 'SwiperPageLeave';
        let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
        if (this.isPc || translateXForScreenSplit !== 0) {
          this.mPageDesktopDragHandler.onDragLeave(event.getWindowX(), event.getWindowY());
          this.mPageDesktopViewModel.setFileFolderBadge(event, extraParams);
        }
        this.mPageDesktopDragHandler.clearSwipeTimeout();
      })
      .onDrop((event: DragEvent, extraParams?: string) => {
        if ((extraParams || '').includes(DragDataType.DOCK_APP)) {
          log.showInfo(`DragEvent form dock app ignore, extraParams ${extraParams}}`);
          event.useCustomDropAnimation = true;
          return;
        }
        if (this.pageEditViewModel.isDragingPage()) {
          // 拖拽页面时由gridSwiper代理drop事件
          this.desktopContext?.eventHub.emit(CommonConstants.GRID_SWIPER_DELEGATE_TO_DROP, event, 'pageDrag');
          return;
        }
        if (formZoomController.isMenuPreviewDragging(extraParams)) {
          return;
        }
        if (openFolderLayout.getGridSwiperLayout().isShowOpenFolder) {
          // 文件夹打开状态, 不能落位, 编辑模式快速拖拽文件夹展开态图标到旁边页会触发这里
          log.showInfo('A folder was opened');
          return;
        }
        dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
        const previewRectWidth: number = Number(event.getPreviewRect().width);
        const previewRectHeight: number = Number(event.getPreviewRect().height);
        this.mPageDesktopDragHandler.dealSwiperPageOnDrop(this.indexInSwiper, event, extraParams,
          (dropX: number, dropY: number, dragResult: DesktopDragResult, endLayoutInfo?: GridLayoutItemInfo): void => {
            let dragItems = PageDesktopDragHandler.getInstance(this.singleContext).getDragItems() ?? [];
            if (dragItems.length > 1 && !DeviceHelper.isPC()) {
              MultiSelectManager.getInstance().startDrop(
                dropX, dropY, PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex()
              );
              performanceMonitor.end(HiSysEventUtil.FORM_MANAGER_CREATE_FORM);
            } else if (dragResult.dropToFolder) {
              this.mPageDragViewModel.triggerGravityAnimationWithFolder(this.indexInSwiper, this.swiperKey,
                endLayoutInfo);
            } else {
              let dropParam = this.dropAnimation(dropX, dropY, dragResult, previewRectWidth, previewRectHeight);
              /* 堆叠卡片场景，自身元素利用落位动效了，因此这里屏蔽掉 */
              // 多选拖拽不触发引力动效 （编辑模式图标单选托选均走多选逻辑， 根据选择数量判断）
              if (dragResult.needDropAnimation && !dragResult.dropToStackForm && !dragResult.dropToDock) {
                this.triggerGravityAnimation(dropParam);
              }
            }
          }
        );
      })
    }
    .hitTestBehavior(this.editModeState.isInEditMode() ? HitTestMode.Transparent : HitTestMode.Default)
    .renderGroup(this.surfaceCacheFlag())
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .padding({ top: 5 }) // 顶部留白，防止角标截断
    .clip(this.isDeskSwipe && !this.isDrag && !this.containsFolder())
    .opacity(this.editModeSingePageViewDataGetOpacity())
    .enabled(this.isDesktopEnabled)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .onGestureJudgeBegin((gestureInfo: GestureInfo) => {
      if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE) {
        if (this.isDrag) {
          log.showInfo('dragging desktop item, enter negative screen need not response');
          return GestureJudgeResult.REJECT;
        }
      }
      return GestureJudgeResult.CONTINUE;
    })
  }

  private getAllowedDropTypes(): Array<UniformDataType> {
    return this.isPc ? [
      UTD.UniformDataType.FILE,
      UTD.UniformDataType.VIDEO,
      UTD.UniformDataType.IMAGE,
      UTD.UniformDataType.AUDIO,
      UTD.UniformDataType.FOLDER,
      UTD.UniformDataType.OPENHARMONY_APP_ITEM,
      UTD.UniformDataType.OPENHARMONY_PIXEL_MAP, // pixelMap
    ] : [];
  }

  private isSkipPanGesture(isStart: boolean, isUpdate: boolean, event?: GestureEvent): boolean {
    if (this.isFactoryMode) {
      log.showInfo(`PanGesture  isFactoryMode: ${this.isFactoryMode}`);
      return true;
    }
    if (isStart) {
      let fingerList = event?.fingerList.filter(item =>!CheckEmptyUtils.isEmpty(item));
      if (fingerList && fingerList.length > 1) {
        log.showInfo(`PanGesture onActionStart fingerList.length > 1`);
        this.isDesktopEditGesture = true;
        return true;
      } else {
        this.isDesktopEditGesture = false;
      }
    }
    if (this.isDesktopEditGesture && !isUpdate) {
      log.showInfo(`PanGesture fingerList.length > 1`);
      if (!isUpdate) {
        this.isDesktopEditGesture = false;
      }
      return true;
    }
    if (this.isDisableSwiperToIntelligent && this.isDisableSwiperToIntelligent()) {
      log.showInfo(`PanGesture isDisableSwiperToIntelligent: ${this.isDisableSwiperToIntelligent},
            isDisableSwiperToIntelligent: ${this.isDisableSwiperToIntelligent()}`);
      return true;
    }
    if (OutdoorConfig.getInstance().isInOutdoorMode() ||
      LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      log.showInfo('isSkipPanGesture due to OutdoorMode');
      return true;
    }
    if (sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.SHOW) {
      log.showInfo('globalSearchStatus is show');
      return true;
    }
    return false;
  }

  private registerPasteEvent(): void {
    log.showInfo('registerPasteEvent');
    this.systemPasteBoard = pasteboard.getSystemPasteboard();
    if (this.systemPasteBoard) {
      this.systemPasteBoard.on('update', () => {
        this.checkDataType();
      })
    }
  }

  private checkDataType() {
    try {
      let hasUri: boolean | undefined = this.systemPasteBoard?.hasDataType(pasteboard.MIMETYPE_TEXT_URI);
      log.showInfo('systemPasteBoard update event come hasUri: ' + hasUri);
      if (!hasUri) {
        this.mPageDesktopViewModel.cutItemClear();
      }
    } catch (err) {
      log.showError(`Failed to check the DataType. Cause:${err.message}`);
    }
  }

  private unRegisterPasteEvent(): void {
    log.showInfo('unRegisterPasteEvent');
    if (this.systemPasteBoard) {
      this.systemPasteBoard.off('update');
    }
  }

  private initSelectStatus(exceptItem?: string): void {
    if (AppStorage.get<boolean>('isCtrlKeyDown') || this.mAppListInfo === undefined) {
      return;
    }
    if (this.selectedItemList.length === 0) {
      log.showInfo('initSelectStatus length = 0');
      return;
    }
    this.mPageDesktopViewModel.onSelectItemChange(this.selectedItemList, false);
    this.selectedItemList = [];
    this.selectItem = '';
  }

  private getZIndex(info?: GridLayoutItemInfo): number {
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    let maxRow: number = layoutDescription.row;
    let maxColumn: number = layoutDescription.column;
    if (info?.typeId === CommonConstants.TYPE_CARD && info?.cardId === this.activeForm?.cardId) {
      log.showInfo(`getZIndex: change running overflowForm z index to top, form id ${info?.cardId}`);
      return maxRow * maxColumn + 1;
    }
    if (this.transitionInRegionFolders.includes(info?.infoId ?? '')) {
      return maxRow * maxColumn + 2;
    }

    let row: number = 0;
    let column: number = 0;
    let index: number = 0;
    if (!info) {
      log.showError('getZIndex: info is null');
    } else {
      row = info.row as number;
      column = info.column as number;
      if (info.area) {
        // 图标纵向index,占位多宫格的元素，以元素右下角的1X1宫格作为元素的index
        index = (maxRow * column + row + 1 + (info.area[0] - 1) * maxRow + row + info.area[1]);
      }
    }
    // zIndex越大，层级越高
    return maxRow * maxColumn - index;
  }

  private onDragDrop(event: DragEvent, extraParams: string) {
    const dragItemType: number = AppStorage.get('dragItemType') as number;

    log.showInfo(`onDrop event: [${event.getWindowX()}, ${event.getWindowY()}], dragItemType:${dragItemType}`);
    if (dragItemType === CommonConstants.DRAG_FROM_MANAGE && this.isPhone) {
      AppStorage.setOrCreate('undoDragFormVisible', false);
      if (!editModeManager.isInEditMode()) {
        ViewManagerPolicy.showView(ViewType.STATUS_BAR);
      }
    }
    const deviceAllowDragTypes = [
      CommonConstants.DRAG_FROM_DOCK,
      CommonConstants.DRAG_FROM_MANAGE,
      CommonConstants.DRAG_FROM_SWIPE_UP,
      CommonConstants.DRAG_FROM_FORM_SERVICE,
      CommonConstants.DRAG_FROM_FORM_INTELLIGENT,
      CommonConstants.DRAG_FROM_FORM_STACK,
    ];

    if (dragItemType === CommonConstants.DRAG_FROM_DESKTOP ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK ||
      dragItemType === CommonConstants.DRAG_FROM_FORM_SERVICE ||
      dragItemType === CommonConstants.DRAG_FROM_SHORTCUT ||
      (deviceAllowDragTypes.includes(dragItemType) && this.isPhone)) {
      let rectangle = event.getPreviewRect();
      let dropX = Number(rectangle.x) + Number(rectangle.width) / 2;
      let dropY = Number(rectangle.y) + Number(rectangle.height) / 2;
      if (this.mPageDesktopViewModel.getIsChangingPage()) {
        this.mPageDesktopViewModel.getSwiperController()?.finishAnimation(() => {
          log.showInfo(`onDragDrop, swiperController finishAnimation`);
          this.dealDrop(dropX, dropY, event);
        });
      } else {
        this.dealDrop(dropX, dropY, event);
      }
    }
  }

  private triggerGravityAnimation(dropParam: DropAnimationParam | null): void {
    const dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    let size = dragItemInfo.area as number[];
    this.gravityAnimTimeoutId = setTimeout(() => {
      this.gravityAnimTimeoutId = undefined;
      if (dropParam && this.indexInSwiper !== undefined) {
        log.showInfo('trigger gravity animation with item drop on swiper page');
        /* pageIndex切换的时候，元素会重建，会在aboutToAppear里添加新的元素，所以不需要更新indexInSwiper */
        if (this.isOuterDesktop) {
          /* VDE的适配工作暂未展开，等适配完毕后这部分逻辑应该合并到else中 */
          GravityAnimationManager.getInstance()
            .run(this.swiperKey, dropParam.endX, dropParam.endY, ForceType.REPULSION, size);
        } else {
          singleManager.get<GravityAnimationManager>(GravityAnimationManager)?.run(
            this.swiperKey, dropParam.endX, dropParam.endY, ForceType.REPULSION, size);
        }
      }
    }, GravityAnimationConfig.getDelayOnDrop());
  }

  private cancelGravityAnimation(): void {
    if (this.gravityAnimTimeoutId != undefined) {
      log.showInfo(`cancel gravity animation. id:${this.gravityAnimTimeoutId}`);
      clearTimeout(this.gravityAnimTimeoutId);
      this.gravityAnimTimeoutId = undefined;
    }
  }

  private dealDrop(dropX: number, dropY: number, event: DragEvent) {
    let dragResult: DesktopDragResult = this.mPageDesktopDragHandler.onDragDrop(dropX, dropY);
    log.showInfo(`onDrop dragResult: ${JSON.stringify(dragResult)}`);
    /* 堆叠卡片场景，自身元素利用落位动效了，因此这里屏蔽掉 */
    if (dragResult.needDropAnimation && !dragResult.dropToStackForm) {
      const previewRectWidth: number = Number(event.getPreviewRect().width);
      const previewRectHeight: number = Number(event.getPreviewRect().height);
      let dropParam = this.dropAnimation(dropX, dropY, dragResult, previewRectWidth, previewRectHeight);
      this.triggerGravityAnimation(dropParam);
    }
    AppStorage.setOrCreate('selectAppIndex', null);
    PageDesktopDragHandler.getInstance(this.singleContext).onStartDrop();
  }

  dropAnimation(dropX: number, dropY: number, dragResult: DesktopDragResult,
    previewRectWidth: number, previewRectHeight: number): DropAnimationParam | null {
    let dragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
    let dragItemInfo = dragHandler.getSingleDragItemInfo();
    if (!dragItemInfo) {
      log.showError('dragItemInfo is undefined');
      return null;
    }
    let fallPosition: number[] | undefined = dragHandler.getFallPosition(dragResult.dropToDock, dragItemInfo.isFormDimension1x4);
    if (!fallPosition || fallPosition.length < 2) {
      log.showError('fall position is null');
      return null;
    }
    if ((dragHandler.getDragItems()?.length ?? 0) > 1) {
      // 多选元素拖拽时不做落位动效
      return null;
    }
    let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
    let param: DropAnimationParam = new DropAnimationParam(GridLayoutUtil.generateUniqueKey(dragItemInfo), dropX, dropY,
      fallPosition[0] + translateXForScreenSplit, fallPosition[1]);
    log.showInfo(`dropAnimation translateXForScreenSplit ${translateXForScreenSplit} , fallPosition ${fallPosition.toString()}`);
    this.adjustDropAnimationParam(param, dragItemInfo, dragResult);
    log.showInfo(`dropAnimation previewRect.width${previewRectWidth} , previewRect.height${previewRectHeight}`);
    param.startWidth = previewRectWidth;
    param.startHeight = previewRectHeight;
    // dock缩放后，图标大小与桌面不一致
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    if (dragItemType === DragType.DRAG_FROM_DOCK && !dragResult.dropToDock && SmartDockZoomFeatureSwitch.isSupportZoom()) {
      param.endWidth = this.mPageDesktopStyleConfig.mIconSize;
      param.endHeight = this.mPageDesktopStyleConfig.mIconSize;
      param.endRadius = this.mPageDesktopStyleConfig.mIconRadius;
    }
    log.showInfo(`dropAnimation startDropAnimation param${JSON.stringify(param)}`);
    dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, param, (isCancel: boolean) => {
      if (isCancel) {
        this.cancelGravityAnimation();
      }
    });
    return param;
  }

  private adjustDropAnimationParam(param: DropAnimationParam, dragItemInfo: GridLayoutItemInfo,
    dragResult: DesktopDragResult): void {
    if (dragItemInfo == null) {
      return;
    }

    // 负一屏卡片与桌面卡片大小不一致，从负一屏拖到桌面的场景需要调整落位动效的终点大小
    let dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
      let formStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
      param.endWidth = formStyleConfig.mFormWidth.get(String(dragItemInfo.cardDimension)) ?? 0;
      param.endHeight = formStyleConfig.mFormHeight.get(String(dragItemInfo.cardDimension)) ?? 0;
      param.endRadius = formStyleConfig.getFormBorderRadius(dragItemInfo.cardDimension);
    }
    // 形成堆叠/落入堆叠 和 落位 formItem 退场曲线保持一致
    if (dragResult.dropToStackForm) {
      param.curve = curves.springMotion(0.45, 1);
      param.parallelAnimation = dragResult.parallelAnimation;
    }
    // PC大文件夹往桌面拖拽场景，图标尺寸不一致，调整落位动效的终点大小
    if (this.isPc && dragItemType === CommonConstants.DRAG_FROM_REGION_FOLDER) {
      param.endWidth = this.mPageDesktopStyleConfig.mIconSize;
      param.endHeight = this.mPageDesktopStyleConfig.mIconSize;
    }
  }

  /**
   * 实现了SelectItemChangeListener，在swiperpage中注册
   * @param selectPaste 粘贴到桌面的文件
   */
  selectAllOrSomeDesktopItem(selectPaste?: string[]): void {
    log.showInfo('select all or some desktopItem');
    if (selectPaste) {
      this.selectedItemList = [];
      selectPaste.forEach(item => {
        this.selectedItemList.push(item);
      })
      return;
    }
    this.mAppListInfo.forEach((item: GridLayoutItemInfo) => {
      let itemKey: string = this.mPageDesktopViewModel.getItemKeyByType(item);
      let index = this.selectedItemList.indexOf(itemKey);
      if (index === INVALID_IDX) {
        this.selectedItemList.push(itemKey);
      }
      item.isSelect = true;
    })
  }

  setSelectItem(item: GridLayoutItemInfo, pageIndex: number) {
    if (item == undefined || item == null) {
      log.showError('setSelectItem: item is null');
      return;
    }

    const key = this.mPageDesktopViewModel.getItemKeyByType(item);
    AppStorage.setOrCreate('selectItem', key);
    // 按下shift按键
    if (AppStorage.get<boolean>('isShiftKeyDown') && !AppStorage.get<boolean>('isCtrlKeyDown')) {
      log.showInfo(`isShiftDown shiftStartItem: ${key}`);
      if (this.shiftStartItem != undefined && this.shiftStartItem != null) {
        if (this.shiftStartItem.uri === undefined && this.shiftStartItem.typeId === undefined) {
          this.shiftStartItem = item;
        }
        this.setLayoutItemsBetween(this.shiftStartItem, item, pageIndex);
        this.mPageDesktopViewModel.onSelectItemChange(this.selectedItemList, true);
        this.lastFocusItem = item;
      }
      return;
    }

    // clear all select status first except current item
    if (!AppStorage.get<boolean>('isCtrlKeyDown') || (AppStorage.get<boolean>('isCtrlKeyDown') &&
    AppStorage.get<boolean>('isShiftKeyDown'))) {
      log.showInfo(`setSelectItem isCtrlDown false or doCtrlShiftEvent`);
      this.selectedItemList = [];
      if (this.selectedItemList.indexOf(key) === -1) {
        this.selectedItemList.push(key);
      }
    } else {
      let index: number = this.selectedItemList.indexOf(key);
      if (item.isSelect && index > INVALID_IDX) {
        //unselect
        this.selectedItemList.splice(index, 1);
      }
      // ctrl select
      if (index === INVALID_IDX) {
        this.selectedItemList.push(key);
      }
    }
    item.isSelect = true;
    this.mPageDesktopViewModel.onSelectItemChange(this.selectedItemList, true);
    this.shiftStartItem = item;
  }

  setLayoutItemsBetween(startItem: GridLayoutItemInfo, endItem: GridLayoutItemInfo, pageIndex: number): void {
    if (startItem.container !== endItem.container) {
      if (startItem.keyName) {
        this.mPageDesktopViewModel.onSelectItemChange([startItem.keyName],false);
      }
      this.selectedItemList = [];
      let key: string = this.mPageDesktopViewModel.getItemKeyByType(endItem);
      this.selectedItemList.push(key);
      this.shiftStartItem = endItem
      return;
    }
    const data: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
    data?.forEach((item) => {
      item.isSelect = false;
      if (this.mPageDesktopViewModel.getItemKeyByType(startItem) ===
      this.mPageDesktopViewModel.getItemKeyByType(item)) {
        startItem = item;
      } else if (this.mPageDesktopViewModel.getItemKeyByType(endItem) ===
      this.mPageDesktopViewModel.getItemKeyByType(item)) {
        endItem = item;
      }
    });
    if (startItem.row === undefined || startItem.column === undefined ||
      endItem.row === undefined || endItem.column === undefined || this.mAppListInfo === undefined) {
      log.showError('setLayoutItemsBetween params error');
      return;
    }
    let selectMode: string = '';
    if (DeviceHelper.isSuperFoldMachine()) {
      if (startItem.page === undefined || endItem.page === undefined) {
        log.showInfo('startItem.page or endItem.page is undefined');
        return;
      }
      const startRow: number =
        this.mIsPortrait ? (startItem.row + startItem.page * this.mPageDesktopStyleConfig.mRows) : startItem.row;
      const endRow: number =
        this.mIsPortrait ? (endItem.row + endItem.page * this.mPageDesktopStyleConfig.mRows) : endItem.row;
      const startColumn: number = this.mIsPortrait ? startItem.column :
        (startItem.column + startItem.page * this.mPageDesktopStyleConfig.mColumns);
      const endColumn: number =
        this.mIsPortrait ? endItem.column : (endItem.column + endItem.page * this.mPageDesktopStyleConfig.mColumns);
      this.doSelect(startRow, startColumn, endRow, endColumn, pageIndex);
    } else {
      if (endItem.container !== CommonConstants.CONTAINER_DESKTOP) {
        return;
      }
      this.doSelect(startItem.row, startItem.column, endItem.row, endItem.column, pageIndex);
    }
  }

  private doSelect(startRow: number, startColumn: number, endRow: number, endColumn: number, pageIndex: number): void {
    this.mSwiperPageVM.doSelect(startRow, startColumn, endRow, endColumn, pageIndex);
  }

  private unSelectItem(item: GridLayoutItemInfo) {
    const key = this.mPageDesktopViewModel.getItemKeyByType(item);
    item.isSelect = false;
    this.mPageDesktopViewModel.onSelectItemChange([key], item.isSelect);
  }

  private setHoverItem(isHover?: boolean, item?: GridLayoutItemInfo) {
    if (!isHover) {
      AppStorage.setOrCreate('hoverItem', '');
      return;
    }
    if (item == undefined || item == null) {
      log.showError('setHoverItem: item is null');
      return;
    }
    log.showInfo(`setHoverItem item, typeId: ${item.typeId}, ino: ${item.ino}, page: ${item.page}, column: ${item.column},
      row: ${item.row}, bundleName: ${item.bundleName}, abilityName: ${item.abilityName}, area: ${item?.area}, infoId: ${item?.infoId}`);
    let itemKey: string = this.mPageDesktopViewModel.getItemKeyByType(item);
    AppStorage.setOrCreate('hoverItem', itemKey);
  }

  private registerUnlockTransitionController(): void {
    this.unLockTransitionController = {
      name: `${TAG}_${this.indexInSwiper}_${Math.floor(Math.random() * 1000)}`,
      onLock: (): void => {},
      onUnlock: (): void => {},
      onUnlockStartScene: (): void => this.onUnLockReceivedPrepare(),
      onUnlockAnimation: (): void => this.onUnLockReceived(),
    }
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SL_LOCK_STATE) {
        let isLocked = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
                        ?.getSlState(SlStaticStateType.SL_LOCK_STATE) as boolean;
        log.showDebug(`Swiperpage received slStaticStateListener isLocked is ${isLocked}`);
        if (isLocked) {
          AppStorage.setOrCreate('showUninstallDialog', false);
          this.onLockReceived();
        }
      }
    }
  };

  //锁屏动效部分
  private onLockReceived(): void {
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    let oneShotManager: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
    if (!PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, mainPageIndex)) {
      return;
    }
    let isBaseDeskPage: boolean = PageDesktopOneShotManager.getInstance().getIsBaseDeskPage();
    log.showInfo(`onLockReceived, ${isBaseDeskPage}`);
    if (!isBaseDeskPage) {
      return;
    }
    log.showInfo(`onLockReceived, mainPageIndex:${mainPageIndex}`);
    this.gridItemAnimList = [];
    this.onLockReceivedWithSpaceAni(oneShotManager);
    this.gridItemAnimList = [];
  }
  
  //图标中心等参数复用解锁数据
  private onLockReceivedWithSpaceAni(oneShotManager: PageDesktopOneShotManager) {
    performanceMonitor.begin('CORE_METHOD_DESKTOP_SHOW', performanceMonitor.ActionType.LAST_DOWN, 'NO_USER');
    let maxItemAnimation: ItemAnimationParams = new ItemAnimationParams();
    let maxRectInfo: RectInfo = ItemUtils.getRectById('SCBDesktop' + `_Column_smartDock`);
    maxItemAnimation.calUnlock(this.screenWidth, this.screenHeight, maxRectInfo);
    this.mPageDesktopViewModel.unlockMax = maxItemAnimation.distance;
    this.mPageDesktopViewModel.unlockMin = maxItemAnimation.distance;
    if (CheckEmptyUtils.isEmptyArr(this.mAppListInfo)) {
      log.showError('this.mAppListInfo is null');
      return;
    }
    let newDesktopList: DeskTopArray = Array(this.mAppListInfo.length);
    //遍历图标
    for (let idx = 0; idx < this.mAppListInfo.length; idx++) {
      let item: GridLayoutItemInfo = this.mAppListInfo[idx];
      let itemKey: string = DesktopUtils.getItemKey(item, this.isOuterDesktop);
      let rectInfo: RectInfo =
        ItemUtils.getRectById(DesktopUtils.getGridItemId(this.indexInSwiper, item, this.isOuterDesktop));
      let itemAnimation: ItemAnimationParams = new ItemAnimationParams(itemKey, item.appName as string, idx);
      if (item.cardName === CLOCK_WEATHER_CARD_NAME) {
        this.mClockWeatherItemAnimList.push(itemAnimation);
      } else {
        this.gridItemAnimList.push(itemAnimation);
      }
      itemAnimation.calUnlock(this.screenWidth, this.screenHeight, rectInfo);
      let unlockMin: number = this.mPageDesktopViewModel.unlockMin;
      this.mPageDesktopViewModel.unlockMin =
        unlockMin != 0 && (unlockMin < itemAnimation.distance) ? unlockMin : itemAnimation.distance;
      let centerAniX: number =
        itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
      let centerAniY: number =
        itemAnimation.screenCenterY - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;
      //动效属性的初始值
      newDesktopList[itemAnimation.itemKey] = new DeskTopItemStyle(0, 0, 1, 1, true, centerAniX, centerAniY);
    }
    //判断是否有天气时钟卡片，有和没有走不同动效
    let hasWeatherCard = false;
    for (let idx = 0; idx < this.mAppListInfo.length; idx++) {
      let item: GridLayoutItemInfo = this.mAppListInfo[idx];
      if (item.cardName === CLOCK_WEATHER_CARD_NAME) {
        hasWeatherCard = true;
      }
    }
    this.desktopList = newDesktopList;
    log.showInfo(`SwiperPage onLock AnimList's Length ${this.desktopList.length} , 
                  And GridItem's Length ${this.gridItemAnimList.length}`);
    if (hasWeatherCard) {
      this.gridItemAnimList.forEach((itemAnimation) => {
        this.hasClockWeatherItemLockAnimation(itemAnimation)
      });
      this.mClockWeatherItemAnimList.forEach((itemAnimation) => {
        this.onClockWeatherItemLockAnimation(itemAnimation)
      });
    } else {
      this.gridItemAnimList.forEach((itemAnimation) => {
        this.onItemLockAnimation(itemAnimation)
      });
    }
    this.onSwiperPageBlurAnimation();
  }

  private onSwiperPageBlurAnimation(): void {
    animateTo({
      delay: 0,
      duration: DeskConstants.DESKTOP_TO_AOD_ICON_DELAY,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, () => {
      this.mBlur = 100;
    })
  }

  //天气时钟卡片的动效，所有动效参数在壁纸延时后几百ms左右恢复 
  private onClockWeatherItemLockAnimation(itemAnimation:ItemAnimationParams):void {
    let delayTimeAnim = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 100;
    let delayTimeItem = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 150;
    animateTo({
      duration: 0,
      onFinish: () => {
        this.mClockWeatherItemAnimList = [];
        setTimeout(() => {
          if (CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            log.showError('this onClockWeatherItem is null');
            return;
          }
          this.desktopList[itemAnimation.itemKey].alpha = 1;
        }, delayTimeAnim);
        setTimeout(() => {
          itemAnimation = undefined;
          SpaceAnimationUtils.resetTimeMap();
        }, delayTimeItem);
      }
    }, () => {
      this.desktopList[itemAnimation.itemKey].alpha = 0;
    })
  }

  //有天气时钟卡片情况下其他图标的动效
  private hasClockWeatherItemLockAnimation(itemAnimation:ItemAnimationParams):void {
    this.visible = Visibility.Visible;
    log.showInfo(`hasClockWeatherItemLockAnimation,visible:${this.visible}`);
    let delayTimeAnim = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 100;
    let delayTimeItem = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 150;
    animateTo({
      delay: 0,
      duration: DeskConstants.DESKTOP_TO_AOD_ICON_DELAY,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        setTimeout(() => {
          if (CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            log.showError('this.desktopList is null');
            return;
          }
          this.desktopList[itemAnimation.itemKey].alpha = 1;
          this.desktopList[itemAnimation.itemKey].scale = 1;
          this.mBlur = 0;
        }, delayTimeAnim);
        setTimeout(() => {
          itemAnimation = undefined;
          SpaceAnimationUtils.resetTimeMap();
        }, delayTimeItem);
      }
    }, () => {
      this.desktopList[itemAnimation.itemKey].alpha = 0;
      this.desktopList[itemAnimation.itemKey].scale = 0.8;
    })
  }

  // 没天气时钟卡片情况下的其他图标的动效
  private onItemLockAnimation(itemAnimation: ItemAnimationParams):void {
    this.visible = Visibility.Visible;
    log.showInfo(`onItemLockAnimation,visible:${this.visible}`);
    let delayTimeAnim = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 100;
    let delayTimeItem = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY + 150;
    animateTo({
      delay: 0,
      duration: DeskConstants.DESKTOP_TO_AOD_ICON_DELAY,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        setTimeout(() => {
          if (CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
            log.showError('this.desktopList is null');
            return;
          }
          this.desktopList[itemAnimation.itemKey].alpha = 1;
          this.desktopList[itemAnimation.itemKey].scale = 1;
          this.mBlur = 0;
        }, delayTimeAnim);
        setTimeout(() => {
          itemAnimation = undefined;
          SpaceAnimationUtils.resetTimeMap();
        }, delayTimeItem);
      }
    }, () => {
      this.desktopList[itemAnimation.itemKey].alpha = 0;
      this.desktopList[itemAnimation.itemKey].scale = 0.8;
    })
  }

  private onUnLockReceivedPrepare(): void {
    this.visible = Visibility.Hidden;
  }

  private onUnLockReceived(): void {
    this.visible = Visibility.Visible;
    this.mBlur = 0;
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    if (!PageInfoManager.getInstance().isCurrentPageShow(this.indexInSwiper, mainPageIndex)) {
      return;
    }
    TraceUtil.startTrace(DomainName.HOME, 'SwiperPage handle unlockReceived');
    let oneShotManager: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
    oneShotManager.notifiyFormHideCard();
    log.showInfo(`onUnLockReceived mainPageIndex:%{public}d indexInSwiper:%{public}d, isOuterDesktop:%{public}s`,
      mainPageIndex, this.indexInSwiper, this.isOuterDesktop);
    HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_GRID_ANIMATION_BEGIN, this.indexInSwiper as number);
    this.gridItemAnimList = [];
    if (!(AppStorage.get<boolean>('shieldAnim') ?? false)) {
      this.onUnlockReceivedWithSpaceAni(oneShotManager);
    }
    log.showInfo('onUnLockReceived activateDefaultActivatedForms');
    this.mOverflowViewModel?.activateDefaultActivatedForms();
    // 手动清理gridItemAnimList
    this.gridItemAnimList = [];
    localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    TraceUtil.endTrace(DomainName.HOME, 'SwiperPage handle unlockReceived');
    setTimeout(() => {
      // 无障碍模式下解锁进入桌面主动播报
      log.showInfo(`onUnLockReceived textAnnouncedForFocusDesktop isDesktopForeground:${this.isDesktopForeground()}}`);
      if (this.isDesktopForeground()) {
        DesktopAccessibilityUtils.textAnnouncedForFocusDesktop();
      }
    }, ACCESSIBILITY_ANNOUNCE_DESKTOP_TIMEOUT);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, true);
  }

  private onUnlockReceivedWithSpaceAni(oneShotManager: PageDesktopOneShotManager) {
    log.showInfo('run onUnlockReceivedWithSpaceAni');
    let maxDistance: number = 0;
    performanceMonitor.begin('CORE_METHOD_DESKTOP_SHOW', performanceMonitor.ActionType.LAST_DOWN, 'NO_USER');
    let maxItemAnimation: ItemAnimationParams = new ItemAnimationParams();
    // 中心点在顶部，最远是dock栏
    let maxRectInfo: RectInfo = ItemUtils.getRectById('SCBDesktop' + `_Column_smartDock`);
    maxItemAnimation.calUnlock(this.screenWidth, this.screenHeight, maxRectInfo);
    if (this.isOuterDesktop) {
      maxItemAnimation.calOuterUnlock();
    }
    this.mSwiperPageVM.setMaxDistance(Math.max(this.mSwiperPageVM.getMaxDistance(), maxItemAnimation.distance));
    let maxNum: number = 0;
    let newDesktopList: DeskTopArray = Array(this.mAppListInfo.length);
    for (let idx = 0; idx < this.mAppListInfo.length; idx++) {
      // 满足一镜到底条件下，解锁进桌面时取消天气时钟卡片入场动效
      if (oneShotManager.isClockWeatherCard(this.mAppListInfo[idx])) {
        continue;
      }
      let item: GridLayoutItemInfo = this.mAppListInfo[idx];
      let itemKey: string = DesktopUtils.getItemKey(item, this.isOuterDesktop);
      let rectInfo: RectInfo =
        ItemUtils.getRectById(DesktopUtils.getGridItemId(this.indexInSwiper, item, this.isOuterDesktop));
      let itemAnimation: ItemAnimationParams = new ItemAnimationParams(itemKey, item.appName as string, idx);
      itemAnimation.calUnlock(this.screenWidth, this.screenHeight, rectInfo);
      this.gridItemAnimList.push(itemAnimation);
      let unlockMin: number = this.mPageDesktopViewModel.unlockMin;
      this.mSwiperPageVM.setMaxDistance(Math.max(this.mSwiperPageVM.getMaxDistance(), itemAnimation.distance));
      this.mSwiperPageVM.setMinDistance(Math.min(this.mSwiperPageVM.getMinDistance(), itemAnimation.distance));
      let centerAniX: number =
        itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
      // 缩放中心在屏幕高度的0.4处
      let centerAniY: number =
        itemAnimation.screenCenterY - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;
      newDesktopList[itemAnimation.itemKey] = new DeskTopItemStyle(0, 0, 0, 0.6, true, centerAniX, centerAniY);
      maxDistance = Math.max(maxDistance, itemAnimation.centerPointDistance);
      maxNum = idx;
    }
    this.desktopList = newDesktopList;
    this.isDeskSwipe = false;
    log.showInfo(`SwiperPage onUnLock AnimList's Length ${this.desktopList.length} ,
                  And GridItem's Length ${this.gridItemAnimList.length}`);
    log.showInfo(`intoHomeAnimate set isDeskSwipe  ${this.isDeskSwipe} `);
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'intoHomeAnimate', false, expandStatus);
    this.gridItemAnimList.forEach((itemAnimation) => {
      this.onItemUnLockAnimation(maxDistance, itemAnimation, maxNum);
    });
  }

  private onItemUnLockAnimation(maxDistance: number, itemAnimation: ItemAnimationParams, maxNum: number): void {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP, StyleConstants.DEFAULT_1);
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_LAUNCHER_ANIMATION);
    let delayValue = itemAnimation.getDelay(this.mSwiperPageVM.getMinDistance(), this.mSwiperPageVM.getMaxDistance());
    animateTo({
      delay: delayValue,
      curve: curves.springMotion(0.35, 0.8, 0),
      onFinish: () => {
        if (itemAnimation.index === maxNum) {
          HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_GRID_ANIMATION_END, this.indexInSwiper);
          this.updateWallPaper();
          if (this.isDesktopForeground()) {
            UIExceptionDetection.getInstance().backgroundBlurExceptionDetection(UIExceptionCaller.UNLOCK_TO_HOME);
            UIExceptionDetection.getInstance().clearAllIconExceptionDetection(UIExceptionCaller.UNLOCK_TO_HOME);
          }
        }
        if (!CheckEmptyUtils.isEmpty(this.desktopList[itemAnimation.itemKey])) {
          this.desktopList[itemAnimation.itemKey].unLockAnimate = false;
        }
        // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP, StyleConstants.DEFAULT_0);
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.UNLOCK_TO_HOME_ANI);
        // 手动清理ItemAnimationParams
        itemAnimation = undefined;
        SpaceAnimationUtils.resetTimeMap();
      }
    }, () => {
      this.desktopList[itemAnimation.itemKey].translateX = 0;
      this.desktopList[itemAnimation.itemKey].translateY = 0;
      this.desktopList[itemAnimation.itemKey].scale = 1;
      this.desktopList[itemAnimation.itemKey].alpha = 1;
    })
  }

  private updateWallPaper(isSnapFromImageFile: boolean = true): void {
    if (!textShadowMgr.getIsCanLoadFromPreference(this.folderStatus)) {
      textShadowMgr.tryUpdateWallpaper(true, false);
    }
  }

  private async notifyUpdateTextShadow(): Promise<void> {
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    if (this.indexInSwiper !== mainPageIndex || this.isPc) {
      return;
    }
    let isLoadFromSpSuccess: boolean = false;
    let isCanLoadFromSp: boolean = await textShadowMgr.isLoadFromPreference();
    if (isCanLoadFromSp) {
      isLoadFromSpSuccess = await textShadowMgr.startToParseShadow(this.folderStatus, mainPageIndex);
    }
    if (isLoadFromSpSuccess) {
      log.showInfo('load textShadow from preference success');
      this.desktopContext?.eventHub.emit(CommonConstants.TEXT_SHADOW_CHANGE);
      return;
    }

    let desktopStyleConfig: DesktopStyleConfig = {
      iconSize: this.mPageDesktopStyleConfig.mIconSize,
      itemPadding: this.mItemPadding,
      iconNameMarginTop: this.mPageDesktopStyleConfig.mIconNameMarginTop,
      row: this.mPageDesktopStyleConfig.mRows,
      col: this.mPageDesktopStyleConfig.mColumns,
      nameWidth: this.mPageDesktopStyleConfig.mNameWidth,
      nameHeight: this.mPageDesktopStyleConfig.mNameHeight,
      gridItemWidth: this.mPageDesktopStyleConfig.mGridWidth / this.mPageDesktopStyleConfig.mColumns,
      gridItemHeight: this.mPageDesktopStyleConfig.mGridHeight / this.mPageDesktopStyleConfig.mRows
    }
    setTimeout(() => {
      textShadowMgr.startToCacheShadow(this.folderStatus, mainPageIndex, desktopStyleConfig).then(() => {
        this.desktopContext?.eventHub.emit(CommonConstants.TEXT_SHADOW_CHANGE);
      })
    }, LOAD_TEXT_SHADOW_TIMEOUT);
  }

  private notifyEditModeFolderBlurEffect(): void {
    const openFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    let pageNum: number | undefined = openFolderData.page;
    log.showInfo(`pageNum: ${pageNum} ,indexInSwiper: ${this.indexInSwiper}, pageIndex: ${this.pageIndex}`);
    if (pageNum === this.indexInSwiper) {
      animateTo({
        duration: 200,
        curve: Curve.Smooth
      }, () => {
        this.editModeFolderOpacity = this.editModeFolderBlurEffectValue ? 0 : 1;
      });
    }
  }

  private onThemeChange(): void {
    if (this.isOuterDesktop) {
      return;
    }
    this.mItemPadding = this.mPageDesktopStyleConfig.mItemPadding;
    this.mWorkSpaceMarginTop = this.getMarginTop();
    if (this.isPc) {
      this.mIconSize = this.mPageDesktopStyleConfig.mIconSize;
    }
  }

  private getMarginTop(): number {
    if (this.isSuperFold && this.mIsPortrait && this.indexInSwiper === 1) {
      return 0;
    }
    if (this.isPc) {
      return this.mPageDesktopStyleConfig.mWorkSpaceMarginTop as number;
    }
    if (editModeManager.isInEditMode() && PageInfoManager.getInstance().isHomePageSetSupport()) {
      // 背景板中心相对stack中心偏移量
      let editModeBgTranslateY = this.editModeSingePageViewData.getEditModeBgTranslateY();
      return this.pageEditViewModel.getGridMarginTopFromSwiper(editModeBgTranslateY, this.offsetY);
    }
    let mt = this.mPageDesktopStyleConfig.mWorkSpaceMarginTop as number - LayoutViewModel.getInstance().getSysUITopHeight();
    log.showInfo(`getMarginTop: ${this.mPageDesktopStyleConfig.mWorkSpaceMarginTop} - ${LayoutViewModel.getInstance().getSysUITopHeight()} = ${mt}`);
    return mt < 0 ? 0 : mt;
  }
}

export class FolderAnimateDataType {
  public folderId: string = '';
  public isOpenFolder: boolean = false;
};

@Observed
export class DeskTopArray extends Array<DeskTopItemStyle> {
}
