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

import BundleManager from '@ohos.bundle.bundleManager';
import {
  EventConstants,
  AppModel,
  PageDesktopModel,
  KeyConstants,
  AppItemInfo,
  DockItemInfo,
  RecentBundleMissionInfo,
  FormCenterViewManager,
  InputMethodManager,
} from '@ohos/launchercommon';
import { SCBCompanionManager } from '@ohos/windowscene/Index';
import screenSessionManager from '@ohos.screenSessionManager';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import {
  RectInfo,
  StartType,
  CheckEmptyUtils,
  Trace,
  LogDomain,
  DomainName,
  LogHelper,
  TraceUtil,
  CommonUtils,
  AnimateToScheduleUtils,
  OptFromRecentType,
  SwipeDirectionUpType,
  singleManager,
  SingleContext,
} from '@ohos/basicutils';
import {
  CallToState,
  PowerStatus,
  WindowConstants,
  SceneConstants,
  SCBConstants,
  DividerStyleConstants,
  RotationConstants
} from '@ohos/commonconstants';
import {
  ViewCallback,
  localEventManager,
  HiSysEventUtil,
  DfxEvent,
  reportIntervalMgr,
  ViewController,
  windowCommonEventManager,
  GlobalContext,
  ViewArea,
  SCBWindowSceneConfig,
  DebugCommand,
  DebugCommandManager,
  WallpaperType,
  viewMgrPolicy,
  ViewType,
  EvtBus,
  ApsUtils,
  WallpaperManager,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import fileUri from '@ohos.file.fileuri';
import {
  SCBTransitionController,
  SCBScreenProperty,
  SCBTransitionManager,
  SCBContainerRotationReason,
  SCBSpecificSceneSessionList,
  SpecificPanelZOrder,
  SystemSessionInfo,
  SCBSystemSceneSession,
  SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneOrientation,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBSessionRect,
  SCBSceneSession,
  ActiveReason,
  SCBEventId,
  SCBPropertyChangeReason,
  SCBGestureActionId,
  SCBGestureAction,
  SCBRecentGestureModel,
  sSCBOobeManager,
  SCBSpecificSession,
  SCBRecentSessionInfo,
  SCBRecentSessionState,
  SCBRecentSessionHelper,
  SCBRecoverManager,
  WindowDragHotAreaType,
  SCBScenePanelDebugCommands,
  SCBUnlockTransitionController,
  FocusChangeReason,
  sSampleManager,
  ScbNumber,
  SplitStyle,
  SCBBackgroundBlurSession,
  SCBSessionEventId,
  SCBWindowRaiseReason,
  SCBSceneMemoryInfo,
  SessionChangeInfo,
  SessionDisplayChangeReason,
  scbGestureManager,
  GestureType,
  GestureNavigationState,
  PreferenceStore,
  SystemBarType,
  ControlType,
  ScenePanelState,
  SCBSpecificSessionSource,
} from '@ohos/windowscene';
import { AttributeUpdater, Position as ArkPosition } from '@kit.ArkUI';
import { CommonConstants, vibratorMgr } from '@ohos/launchercommon';
import { SCBSceneContainer } from './SCBSceneContainer';
import { StyleConstants } from '@ohos/launchercommon';
import { FixedDockResource } from '@ohos/smartdock/src/main/ets/default/common/constants/PcModeDockConstants';
import PcSmartDockViewModel from '@ohos/pcsmartdock/src/main/ets/default/viewmodel/SmartDockViewModel';
import { PcDockIndepentIconMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockIndependentIconMgr';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneContainerRefresh } from './SCBSceneContainerRefresh';
// import apsManager from '@hms.graphic.apsManager';
import curves from '@ohos.curves';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { SplitState } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import {
  ActionType,
  ThreeFingersSwipe,
  FourFingersSwipe,
  ThreeFingersTap,
  TouchGestureAction,
  TouchGestureEvent
} from '@ohos.multimodalInput.gestureEvent'
import HashMap from '@ohos.util.HashMap';
import { MemoryHelper, SCBRecentSessionsViewModel } from '../recentview/SCBRecentSessionsViewModel';
import { SCBRecentMinBackgroundViewModel } from '../recentview/SCBRecentMinBackgroundViewModel';
import { SCBRecentSubSceneViewModel } from '../recentview/SCBRecentSubSceneViewModel';
import { SCBRecentCover } from '../recentview/SCBRecentCover';
import { SCBRecentTitleViewModel } from '../recentview/SCBRecentTitleViewModel';
import { SCBRecentCardViewModel } from '../recentview/SCBRecentCardViewModel';
import { SCBRecentHoverViewModel } from '../recentview/SCBRecentHoverViewModel';
import { SwipeDirection, ThreeFingerSwipeConstants } from '../../common/constants/ThreeFingerSwipeConstants';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { SCBDefaultZIndex } from './SCBScreen';
import commonEventManager from '@ohos.commonEventManager';
import display from '@ohos.display';
import { LayoutViewModel } from '@ohos/launchercommon';
import { SCBRecentEmptyView, SCBSplitRecentEmptyView } from '../recentview/SCBRecentEmptyView';
import { SCBRecentStyleConstants } from '../recentview/SCBRecentStyleConstants';
import { multiInputManager } from '@ohos/multiinput';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import KeyCodeConstants from '@ohos/multiinput/src/main/ets/default/common/constants/KeyCodeConstants';
import image from '@ohos.multimedia.image';
import PowerStatusChangeAnimationController from './PowerStatusChangeAnimationController';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import LockScreenAnimationController from '../screenlock/common/LockScreenAnimationController';
import { CallbackParameter } from '../control/animationcontroller/AnimationController';
import { styleMgr } from '@ohos/systemuicommon';
import { emitter, systemParameterEnhance } from '@kit.BasicServicesKit';
import accountModel, { AuthSubType } from '../screenlock/refactor/AccountsModel';
import { MultiInputViewModel } from '@ohos/multiinput';
import { ShortcutKeyConstants } from '../../common/constants/ShortcutKeyConstants';
import { INVALID_SCREEN_ID } from '@ohos/windowscene';
import type { ExecuteCallbackExtraInfo } from '@ohos/windowscene';
import { systemDateTime } from '@kit.BasicServicesKit';
import { WallpaperModel } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/model/WallpaperModel';
import bundleManager from '@ohos.bundle.bundleManager';
import { PcDockAnimationMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockAnimationMgr';
import { CloseAppManager, StartSubtype } from '@ohos/launchercommon';
import { PcHiSysEventMgr } from '../../common/manager/PcHiSysEventMgr';
import { pointer } from '@kit.InputKit';
import ctrlAltDelPanelModel from '../ctrlaltdelpanel/model/CtrlAltDelPanelModel';
import { SCBMultiRecentManager } from '../recentview/SCBMultiRecentManager';
import { PCUtils } from '../../common/utils/PCUtils';
import PcFileFolderManager from '../../common/controller/PcFileFolderManager';
import { SCBRecentEnter } from '../recentview/SCBRecentEnter';
import { SCBRecentExit } from '../recentview/SCBRecentExit';
import { SCBRecentDelete } from '../recentview/SCBRecentDelete';
import { SCBRecentState, recentStateManager, SCBRecentStateEvents } from '../recentview/SCBRecentState';
import { RecentFocusController } from '../recentview/recentFocus/RecentFocusController';
import { RecentFocusManager } from '../recentview/recentFocus/RecentFocusManager';
import { SCBRecentFeatureBridge } from '../recentview/SCBRecentFeatureBridge';
import { SCBRecentFoldManager } from '../recentview/foldMachine/SCBRecentFoldManager';
import { SCBRecentStyle, SCBRecentStyleManager } from '../recentview/foldMachine/SCBRecentStyle';
import { SCBRecentFoldHalfVM } from '../recentview/foldMachine/SCBRecentFoldHalfVM';
import { AnimationType, CustomAnimateParam,
  SCBRecentFoldMachineVM } from '../recentview/foldMachine/SCBRecentFoldMachineVM';
import { gestureHelperInstance } from '../gesturenavigation/common/GestureHelper';
import { RecentAndAppCenterSwitchManager } from '../../common/manager/RecentAndAppCenterSwitchManager';
import data_preferences from '@ohos.data.preferences';
import { CloneWallpaperMgr } from '../systemscene/ViewModel/CloneWallpaperMgr';
import { SCBRecentNotShowViewModel } from '../recentview/SCBRecentNotShowViewModel';
import { enterpriseRecentEvent, EnterpriseRecentPanel } from '../enterprisespace/EnterpriseRecentPanel'
import { MultiSpace } from '../../common/EnterpriseMultiSpaceController';
import { SessionRectChangeInfo } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { SCBPiPManager } from './pip/SCBPiPManager';
import { PCDockUtils } from '@ohos/pcsmartdock/src/main/ets/default/utils/PCDockUtils';
import { SCBRecentAnimation } from '../recentview/SCBRecentAnimation';
import { SCBRecentPanelManager, SCBRecentPanelViewModel } from '../recentview/SCBRecentPanelViewModel';
import { SCBRecentPrepareManager } from '../recentview/SCBRecentPrepareManager';
import {
  IFreeWindowsViewModel,
  SCBPcScenePanelManager,
  ViewModelType,
  ExitSplitParam,
  PcSCBSceneContainerSessionArray,
  SCBScenePanelProxy,
  SCBSessionListManager,
  SwipeGestureManager,
  SystemAnimatedScene,
  systemAniSceneCtrl,
  DividerStyle,
  SCBFreeWindowsViewModelManager,
  SCBSplitLayoutHelper,
  RealScreenInfo,
  ScreenForm,
  MonitorExitSplitName,
  SCBSceneHelper,
  LayoutPolicyHelper } from '@ohos/pcmode';
import { DesktopSwitchController, VmStateCallBack } from '../virtualmachine/DesktopSwitchController';
import { FourFingerSwipeController } from '../virtualmachine/FourFingerSwipeController';
import { FoldShutdownViewProxyManager } from '@ohos/shutdownview'
import { SCBRecentUiFirst } from '../recentview/SCBRecentUiFirst';

const TAG = 'SCBScenePanel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const RECENT_TAG = 'RecentPanel';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);
const FIRST_START_VIRTUAL: string = 'FIRST_START_VIRTUAL';
const CLINK_NOTIFICATION_SWIPE: string = 'CLINK_NOTIFICATION_SWIPE';
const ROTATE_POLICY: number = Number.parseInt(systemParameterEnhance.getSync('const.window.device.rotate_policy', '0'));
const ROTATE_STRATEGY_WINDOW: number = 0;
const INVALID_PERSISTENT_ID: number = 0;
const START_CURVE: ICurve = curves.cubicBezierCurve(0.1, 0, 0.4, 1);
const START_TIME: number = 250;
const B_C_DISTINGUISH_LINE = 1608;
const INVISIBLEWINDOW_DURATION_TIME: number = 1;
const INVISIBLEWINDOW_DELAY_TIME: number = 16;
const RESETSCALEANIMATION_TIMEOUT: number = 7000;
const ENTERPRISE_RECENT_HEIGHT_RATIO: number = 0.16;

const EVENT_DESKTOP_HIDE_SEARCH_PANEL: string = 'usual.event.pcsettings.searchpanel.hide';
/**
 * window hot area margin
 */
const WINDOW_HOTAREA_MARGIN = 20;
const INVALID_INDEX = -1;
const SCREEN_INDEX = 1000;
const BASE_DENSITY: number = 160;

/**
 * speed params in threeFingerSwipeUp
 */
const MAX_SPEED_IN_CLEAR_SCENE: number = 20;
const MIN_SPEED_IN_CLEAR_SCENE: number = 7;
const SPEED_TIMES: number = 1.5;
const HOT_AREA_IN_CLEAR_SCENE = 4;

export enum RecentChain {
  RECENT_CHAIN_DEFAULT,
  RECENT_CHAIN_FIRST,
  RECENT_CHAIN_SECOND,
  RECENT_CHAIN_THIRD,
  RECENT_CHAIN_FOURTH,
}

export class SCBViewParam {
  public flexWidth: number | string = '100%';
  public flexHeight: number | string = '100%';
  public flexPadding: number = 0;
  public flexOffsetX: number = 0;
  public flexOffsetY: number = 0;

  constructor() {
  }

  /**
   * init properties of scenePanelView
   */
  public initAll(): void {
    this.flexWidth = '100%';
    this.flexHeight = '100%';
    this.flexPadding = 0;
    this.flexOffsetX = 0;
    this.flexOffsetY = 0;
  }
}

@Component
export struct SCBScenePanel {
  @Link @Watch('updateScreenProperty') screenProperty: SCBScreenProperty;
  private panelProxyImpl: SCBScenePanelProxy = {
    getSysSceneSession: (): SCBSystemSceneSession => {
      return this.sysSceneSession;
    },
    getScroller: (): Scroller => {
      return this.scroll;
    },
    getScenePanelState: (): ScenePanelState => {
      return this.scenePanelState;
    },
    updateScenePanelState: (state: ScenePanelState): void => {
      this.updateScenePanelState(state);
    },
    setIsPairSplit: (isPairSplit: boolean): void => {
      this.isPairSplit = isPairSplit;
    },
    getScreenDpiDensity: (): number => {
      return this.getScreenDpiDensity();
    },
    enterSplitView: (container: SCBSceneContainerSession, isSplitRecentPrimary: boolean): void => {
      this.enterSplitView(container, isSplitRecentPrimary);
      this.updateStackHeight();
      this.isSplitRecentPrimary = isSplitRecentPrimary;
    },
    isOpenFromPopup: (): boolean => {
      return this.isOpenFromPopup;
    },
    getCardWidth: (): number => {
      return this.cardWidth;
    },
    getCardPositionX: (): number => {
      return this.cardPositionX;
    },
    getCardPositionY: (): number => {
      return this.cardPositionY;
    },
    isRecycleBin: (sceneInfo?: SCBSceneInfo, extraInfo?: ExecuteCallbackExtraInfo): boolean => {
      return PcFileFolderManager.getInstance().isRecycleBin(sceneInfo?.bundleName,
        sceneInfo?.persistentId, this.isOpenFromPopup, extraInfo?.isClickByPcDockFileManager);
    },
    setRecentDataList: (isNeedHideAppCenter: boolean): void => {
      this.setRecentDataList(isNeedHideAppCenter);
    },
    exitSplitRecentViewIfNotShowRecent: (): void => {
      log.showInfo(`exitSplitRecentViewIfNotShowRecent, showRecent: ${this.showRecent}`);
      if (!this.showRecent) {
        this.exitSplitRecentView(true, true);
      }
    },
    exitRecentWhenStartSceneFromRecent: (container: SCBSceneContainerSession): void => {
      this.exitRecentWhenStartSceneFromRecent(container);
    },
    exitSplitRecentView: (isAnimateImmediately: boolean, isPairSplit: boolean): void => {
      this.exitSplitRecentView(isAnimateImmediately, isPairSplit);
    },
    recentSceneCloseAnimate: (containerSession: SCBSceneContainerSession): void => {
      this.recentSceneCloseAnimate(containerSession);
    },
    updateRecentInfoAfterExitForSplit: (newContainer: SCBSceneContainerSession, curContainer: SCBSceneContainerSession,
      primarySession: SCBSceneSession, secondarySession: SCBSceneSession | null, isEnterPair: boolean): void => {
      this.updateRecentInfoAfterExitForSplit(newContainer, curContainer, primarySession, secondarySession, isEnterPair);
    },
    refreshRecentInfo: (): void => {
      this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessions();
    },
    exitRecentView: (needAnim: boolean): void => {
      this.exitRecentView(needAnim);
    },
    exitAppCenterView: (): void => {
      this.exitAppCenterView();
    },
    recentSceneResizeAnimate: (): void => {
      this.resizeSceneProperty(true);
    },
    handleHideCloseInRecent: (containerSession: SCBSceneContainerSession, sceneSession: SCBSceneSession,
      isFromClient: boolean): void => {
      this.recentSceneHideAnimate(containerSession, sceneSession, isFromClient);
    },
    recentOrSplitClose: (containerSession: SCBSceneContainerSession, isException?: boolean,
      isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void => {
      this.recentOrSplitClose(containerSession, isException, isSaveSnapshot, extraInfo);
    },
    minimizeSceneInRecent: (container: SCBSceneContainerSession): void => {
      SCBRecentCardViewModel.setShowInRecent(container);
      container.requestBackground();
    },
    raiseSceneToTopInRecent: (container: SCBSceneContainerSession): void => {
      log.showInfo('onSceneRaiseToTop in recent');
      container.requestActivation(false);
      SCBRecentCardViewModel.resetShowInRecent(container);
    },
    setPairPersistentId: (persistentId: number): void => {
      this.pairPersistentId = persistentId;
    },
    sessionRectChangeInRecent: (): void => {
      this.onSceneRectChange();
    },
    addGestureDockRecentItem: (bundleName: string, appIndex: number): void => {
      return;
    },
    updateScreenDensity: (targetDensity: number): void => {
      this.screenDpiDensity = targetDensity;
    },
    updateRectToAvoidStatusBar: (session: SCBSceneSession): void => {
      let statusBarHeightPx: number = 0;
      let statusBar = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
          this.screenProperty.screenId);
      if (statusBar && viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
        statusBarHeightPx = statusBar.currRect.height.getPx();
      }
      this.updateRectToAvoidStatusBar(session, statusBarHeightPx);
    }
  };
  private presenter: IFreeWindowsViewModel = SCBFreeWindowsViewModelManager.getInstance().getOrCreatePresenter(
    this.getUIContext(), this.screenProperty, this.panelProxyImpl, ViewModelType.VIEW_MODEL_PC);
  containerSessionListNotShowRecent: SCBSceneContainerSessionArray =
    this.presenter.getContainerSessionListNotShowRecent();
  @State containerSessionList: PcSCBSceneContainerSessionArray = this.presenter.getContainerSessionList();
  @State scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @State isNeedClip: boolean = false;
  @State isPairSplit: boolean = false;
  @State showRecentEmptyView: boolean = false;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProperty.screenId };
  @State scrollDirection: ScrollDirection = ScrollDirection.None;
  @State @Watch('onContainerExitSplit') isExitSplit: boolean = false;

  private mSmartDockViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private mDockAnimationMgr: PcDockAnimationMgr = PcDockAnimationMgr.getInstance(this.screenProperty.screenId);
  private mRecentSessionsViewModel: SCBRecentSessionsViewModel =
    SCBRecentSessionsViewModel.getInstance(this.singleContext);
  private recentMinBackground: SCBRecentMinBackgroundViewModel =
    SCBRecentMinBackgroundViewModel.getInstance(this.screenProperty, { extendScreenId: this.screenProperty.screenId });
  private mRecentFocusManager: RecentFocusManager =
    RecentFocusManager.getInstance();
  private mRecentFocusController: RecentFocusController =
    this.mRecentFocusManager.getFocusControllerByScreenId(this.screenProperty.screenId);
  private multiRecentManger: SCBMultiRecentManager = SCBMultiRecentManager.getInstance();
  private mRecentFeatureBridge: SCBRecentFeatureBridge = SCBRecentFeatureBridge.getInstance();
  private recentPrepareManager: SCBRecentPrepareManager = new SCBRecentPrepareManager(this.screenProperty);

  private needRenderDistanceMap: Map<number, number> = new Map();
  private screenHeight = 0;
  private screenWidth = 0;
  @StorageLink('showRecent') @Watch('changeRecent') showRecent: boolean = false;
  @StorageLink('isOpenFromPopup') isOpenFromPopup: boolean = false;
  @StorageLink('cardWidth') cardWidth: number = 0;
  @StorageLink('cardPositionX') cardPositionX: number = 0;
  @StorageLink('cardPositionY') cardPositionY: number = 0;
  @StorageLink('isDockAutoHide') @Watch('dockAutoHideChanged') isDockAutoHide: boolean = false;
  @State bgBlurSession: SCBBackgroundBlurSession = new SCBBackgroundBlurSession();
  private blurTransitioning: boolean = false;
  private isHide: boolean = false;
  private mLayoutViewModel: LayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
  dockHeight: number = 0;
  windowMaxHeight: number = 0;
  private scrollTranslate: number = 0;
  @State @Watch('updateIndex') selectedIndex: number = -1;
  @State scrollBarHeight: number = 0;
  @State scrollBarTextHeight: number = 0;
  @State scrollBarOffsetX: number = 0;
  @State scrollBarOffsetY: number = 0;
  @State isShowScrollBar: boolean = false;
  @State scrollFlingSpeedLimit: number = 12000;
  @State emptyViewHeight: number = this.mRecentSessionsViewModel.getCurrentShowHeight();
  private scroll: Scroller = new Scroller();
  private isEnterRecentView: boolean = false;
  private recentEnter = new SCBRecentEnter(this.screenProperty);
  private recentExit = new SCBRecentExit(this.screenProperty);
  private recentEnterDelayAnimateTimer: number = -1;
  @State recentState: SCBRecentState = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
  @State scrollStackHeight: number = 0;
  private chainStartRow: number = -1;
  private chainMaxRow: number = -1;
  private isHandleThreeFingerSwiper: boolean = false;
  private currentRecentSessionInfo: SCBRecentSessionInfo[] = [];
  private oldSelectedIndex = -1;
  private focusType = -1;
  private notSupportSplitRecentSessionInfo: Array<SCBRecentSessionInfo> = [];
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @StorageLink('isEnterSplitAnimating') @Watch('onEnterSplitAnimating') isEnterSplitAnimating: boolean = false;
  private recentGestureModel: SCBRecentGestureModel = new SCBRecentGestureModel();
  private appCenterViewCallback: ViewCallback = {
    onHide: (): void => this.onAppCenterViewHide(),
    onShow: (): void => this.onAppCenterViewShow()
  };
  private statusViewCallback: ViewCallback = {
    onHide: (): void => this.onStatusHide()
  };
  private unLockTransitionController: SCBUnlockTransitionController | undefined = undefined;
  @State private isSplitRecentPrimary: boolean = true;
  private gestureChange: Function =
    (action: SCBGestureAction, displayId?: number): void => this.onGestureChange(action, displayId);
  private getScreenDpiDensity: Function = (): number => this.onQueryScreenDensityDpi();
  private sceneRectChange: Function = (): void => this.onSceneRectChange();
  private gestureFirstMove: boolean = true;
  private memoryHelper: MemoryHelper = MemoryHelper.getInstance(this.screenProperty.screenId);
  // Used for shutdown animation
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;
  // alt + tab 进入任务中心不做动效
  @StorageLink('altTabKeyEvent') altTabKeyEvent: boolean = false;
  private scaleAnimationTimerId: number = -1;
  //specificWindowNumberMap: 每个ability对应不同的flag的主窗；内层Map：每个flag对应的记忆次数，到达上限删除次数最小的flag
  private specificWindowNumberMap: Map<string, Map<string, number>> = new Map();
  private isOneFingerUp: boolean = false;
  private apsApsSessionId: string = '';
  private recentStyleManager: SCBRecentStyleManager = SCBRecentStyleManager.getInstance(this.singleContext);
  private recentNotShowViewModel: SCBRecentNotShowViewModel =
    SCBRecentNotShowViewModel.getInstance(this.screenProperty.screenId);
  @State private scenePanelScale: number = 1;
  @State private scenePanelOpacity: number = 1;
  // 手势区分主屏与扩展屏
  private gestureSceneType: string = TAG + this.screenProperty.screenId;
  private recentAnimation: SCBRecentAnimation = new SCBRecentAnimation();
  private recentPanelViewModel: SCBRecentPanelViewModel =
    SCBRecentPanelManager.getInstance().getRecentPanelViewModel(this.screenProperty.screenId);
  private recentPreparePersistentIds: number[] = [];
  private recentSubSceneViewModel: SCBRecentSubSceneViewModel =
    new SCBRecentSubSceneViewModel(this.screenProperty.screenId);
  private handleSceneWhenPreLockCallback = (): void => {
    this.handleSceneWhenPreLock();
  }
  @State enterpriseRecentHeight: number = 0;
  private recentUiFirst = new SCBRecentUiFirst();

  private doScaleAnimation(containerSession: SCBSceneContainerSession): void {
    const animationProp = containerSession?.primarySession?.getAnimationProperty();
    if (!animationProp) {
      log.showError('doScaleAnimation no animation property');
      return;
    }
    log.showInfo(`doScaleAnimation persistentId: ${containerSession.primarySession?.sceneInfo.persistentId} ` +
      `on screenId: ${this.screenProperty.screenId}  scale: ${animationProp.targetScale}`);
    performanceMonitor.begin('WINDOW_DO_SCALE_ANIMATION', performanceMonitor.ActionType.LAST_UP,
      containerSession?.primarySession?.sceneInfo?.bundleName);
    clearTimeout(this.scaleAnimationTimerId);
    const options = this.getAnimationOption(containerSession);
    if (animationProp.targetScale !== 1) {
      this.scaleAnimationTimerId = setTimeout(() => {
        this.doResetScaleAnimation(containerSession);
      }, RESETSCALEANIMATION_TIMEOUT);
    } else {
      containerSession?.primarySession?.resetAnimationProperty();
    }
    this.getUIContext()?.animateTo({
      duration: options[1],
      curve: options[0],
      onFinish: () => {
        performanceMonitor.end('WINDOW_DO_SCALE_ANIMATION');
      }
    }, () => {
      containerSession?.primarySession?.setScale(animationProp.targetScale, animationProp.targetScale);
    });
  }

  private doResetScaleAnimation(containerSession: SCBSceneContainerSession): void {
    const animationProp = containerSession?.primarySession?.getAnimationProperty();
    if (!animationProp) {
      log.showError('doResetScaleAnimation no animation property');
      return;
    }
    log.showInfo(`doResetScaleAnimation persistentId: ${containerSession.primarySession?.sceneInfo.persistentId} ` +
      `on screenId: ${this.screenProperty.screenId}`);
    performanceMonitor.begin('WINDOW_DO_RESET_SCALE_ANIMATION', performanceMonitor.ActionType.LAST_UP,
      containerSession?.primarySession?.sceneInfo?.bundleName);
    const options = this.getAnimationOption(containerSession);
    this.getUIContext()?.animateTo({
      duration: options[1],
      curve: options[0],
      onFinish: () => {
        performanceMonitor.end('WINDOW_DO_RESET_SCALE_ANIMATION');
      }
    }, () => {
      containerSession?.primarySession?.setScale(1, 1);
    });
    containerSession?.primarySession?.resetAnimationProperty();
  }

  private getAnimationOption(containerSession: SCBSceneContainerSession): [Curve | ICurve, number] {
    const animationOption = containerSession?.primarySession?.getAnimationOption();
    let customCurve: Curve | ICurve = Curve.Linear;
    let customDuration: number = 200;
    if (animationOption) {
      if (animationOption.curve === sceneSessionManager.WindowAnimationCurve.LINEAR) {
        customCurve = Curve.Linear;
        if (!!animationOption.duration) {
          customDuration = animationOption.duration;
        }
      } else if (animationOption.curve === sceneSessionManager.WindowAnimationCurve.INTERPOLATION_SPRING &&
        !!animationOption.param && animationOption.param.length == 4) {
        customCurve = curves.interpolatingSpring(animationOption.param[0], animationOption.param[1],
          animationOption.param[2], animationOption.param[3]);
      }
    }
    return [customCurve, customDuration];
  }

  // windowscene
  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: TAG,
    sceneZIndex: SCBDefaultZIndex.SYSTEM_SCENE_PANEL,
    isFocusable: false,
    isTouchable: false,
    isRotatable: false,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.PANEL_SCENE,
  };
  private sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.systemSessionInfo, undefined, false, this.screenProperty.screenId);
  private removeContainerSessionList: number[] = [];
  private pairPersistentId: number = -1;
  private screenDpiDensity: number = -1;
  // init SCBPcScenePanelManager instance
  private pcScenePanelManager = SCBPcScenePanelManager.getInstance();

  @StorageLink('desktopWallpaperChange') @Watch('onDesktopWallpaperChange') wallPaper: image.PixelMap | null = null;
  @State themePath: string = '';

  private deleteSceneCardInRecent = (persistentId: number) => {
    this.closeSceneCardInRecent(persistentId);
  }

  private onDesktopWallpaperChange(): void {
    try {
      let themePath = WallpaperManager.getInstance().themePath;
      this.themePath = fileUri.getUriFromPath(themePath);
    } catch (error) {
      log.showError(`onDesktopWallpaperChange get themePath error ${error.code} ${error.message}`);
    }
    log.showInfo(`onDesktopWallpaperChange themePath ${this.themePath}`);
  }

  updateScreenProperty() {
    log.showInfo('updateProperty');
    this.presenter.updateScreenProperty(this.screenProperty);
    this.screenHeight = this.getUIContext().px2vp(this.screenProperty.height);
    this.screenWidth = this.getUIContext().px2vp(this.screenProperty.width);
    this.scrollStackHeight = this.screenHeight;
    this.initRecentData();
  }

  onPowerStatusChange(): void {
    if (this.powerStatus === PowerStatus.RUNNING) {
      log.showDebug('this.PowerStatus is ' + this.powerStatus + ', no animation return');
      return;
    }

    log.showDebug('this.PowerStatus is ' + this.powerStatus + ', do shut down animation.');
    this.closeSceneArray();
  }

  // listening the app center hide event
  private onAppCenterViewHide(): void {
    this.scenePanelState = this.showRecent ? ScenePanelState.RECENT : ScenePanelState.HOME;
  }

  // listening the app center show event
  private onAppCenterViewShow(): void {
    this.scenePanelState = ScenePanelState.APP_CENTER;
  }

  private onStatusHide(): void {
    if (SCBSceneSessionManager.getInstance().getIsStatusBarShownForHover()) {
      log.showInfo('hide floating title when status bar has been hidden');
      this.hideFloatingTitle();
    }
  }

  private onQueryScreenDensityDpi(): number {
    log.showDebug(`onQueryScreenDensityDpi screenDpiDensity is ${this.screenDpiDensity}`);
    return this.screenDpiDensity;
  }

  private onEnterSplitAnimating(): void {
    if (!this.isEnterSplitAnimating && this.isSplitState()) {
      log.showInfo('shift the focus after entering pre-split');
      this.recentEnter.switchInFocus(this.sysSceneSession);
    }
  }

  private onLock(): void {
    if (this.isLock) {
      if (this.scenePanelState === ScenePanelState.RECENT) {
        this.exitRecentView(false);
      }
      if (this.scenePanelState === ScenePanelState.SPLIT) {
        const currContainerSession = this.containerSessionList.getTopActiveSession();
        if (currContainerSession?.primarySession) {
          const parm = new ExitSplitParam();
          this.exitSplitView(currContainerSession.primarySession.session.persistentId, parm);
        }
      }
      SCBScreenSessionManager.getInstance().unRegisterShutdownCallback();
      SCBScreenSessionManager.getInstance().unRegisterPowerStatusController();
      log.showDebug('onLock isLock = ' + this.isLock + ', unRegisterShutdownCallback, powerStatus is = ' +
      AppStorage.get('powerStatus'));
    } else {
      SCBScreenSessionManager.getInstance().registerShutdownCallback();
      SCBScreenSessionManager.getInstance()
        .registerPowerStatusController(PowerStatusChangeAnimationController.getInstance());

      log.showDebug('onLock isLock = ' + this.isLock + ', registerShutdownCallback, powerStatus is = ' +
      AppStorage.get('powerStatus'));
      this.isHandleThreeFingerSwiper = false;
      this.isOneFingerUp = false;
    }
  }

  private setSceneTitleFocus(element: SCBSceneContainerSession): void {
    const bundleName = element.primarySession?.sceneInfo.bundleName ?? '';
    const persistentId = element.primarySession?.session.persistentId ?? -1;
    const id = SCBRecentTitleViewModel.getRecentTitleAppNameId(persistentId, bundleName);
    try {
      this.getUIContext().getFocusController().requestFocus(id);
      recentLog.showDebug(`setSceneTitleFocus, requestFocus ${id}, success`);
    } catch (err) {
      recentLog.showError(`setSceneTitleFocus, requestFocus ${id}, Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private setSelectItem(): void {
    if (this.currentRecentSessionInfo === undefined ||
      (this.currentRecentSessionInfo !== undefined && this.currentRecentSessionInfo.length === 0)) {
      const recentSessions = this.mRecentSessionsViewModel
        .getRecentSessionsNotInclude([]);
      this.currentRecentSessionInfo = recentSessions;
    }
    if (this.selectedIndex >= 0 && this.selectedIndex <= this.currentRecentSessionInfo.length - 1) {
      const currentSessionId = this.currentRecentSessionInfo[this.selectedIndex].sessionId;
      for (let element of this.containerSessionList) {
        if (element.primarySession?.session.persistentId === currentSessionId) {
          element.tabSelected = true;
          this.setSceneSelect(element);
          this.setSceneTitleFocus(element);
        } else {
          element.tabSelected = false;
          element.resetSessionSelectedStatus();
        }
      }
    }
  }

  /**
   *  焦点index变换的场景
   * @param containerSession
   */
  private setSceneSelect(containerSession: SCBSceneContainerSession): void {
    if (!this.isSplitState()) {
      containerSession.isPrimarySelected = true;
      containerSession.setPrimarySelectedWithMutex(true);
      return;
    }

    let lastSession: SCBSceneContainerSession | null =
      this.mRecentFocusController.getRecentSelectedItemByIndex(this.oldSelectedIndex);
    log.showInfo(`setSceneSelect lastSession ${lastSession?.getName()} ${containerSession.getName()}`);
    let isLeft: boolean = true;
    if (lastSession) {
      if (this.mRecentFocusManager.isSplitRecentUpAndDownContainer(containerSession)) {
        switch (this.focusType) {
          case KeyCodeConstants.KEYCODE_DPAD_UP:
            isLeft = false;
            break;
          case KeyCodeConstants.KEYCODE_DPAD_DOWN:
            isLeft = true;
            break;
          case KeyCodeConstants.KEYCODE_DPAD_RIGHT:
          case KeyCodeConstants.KEYCODE_DPAD_LEFT:
            // 两个上下二分屏窗口，通过左右按键切换场景
            isLeft = (lastSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY &&
            lastSession.isPrimarySelected) || (!lastSession.isPrimarySelected &&
              lastSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) || (!lastSession.isSplit);
            break;
          default:
            break;
        }
      } else {
        switch (this.focusType) {
          case KeyCodeConstants.KEYCODE_DPAD_UP:
          case KeyCodeConstants.KEYCODE_DPAD_DOWN:
            // 两个左右二分屏窗口，通过上下按键切换场景
            isLeft = (lastSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY &&
            lastSession.isPrimarySelected) || (!lastSession.isPrimarySelected &&
              lastSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY);
            break;
          case KeyCodeConstants.KEYCODE_DPAD_RIGHT:
            isLeft = true;
            break;
          case KeyCodeConstants.KEYCODE_DPAD_LEFT:
            isLeft = false;
            break;
          default:
            break;
        }
      }
      this.focusType = -1;
    }
    if ((containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY && isLeft) ||
      (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY && !isLeft) ||
      !containerSession.isSplit) {
      log.showInfo('setSceneSelect primarySelected');
      containerSession.isPrimarySelected = true;
      containerSession.setPrimarySelectedWithMutex(true);
    } else {
      log.showInfo('setSceneSelect secondarySelected');
      containerSession.isPrimarySelected = false;
      containerSession.setPrimarySelectedWithMutex(false);
    }
  }

  private initTabStatus(): void {
    for (let session of this.containerSessionList) {
      session.tabSelected = false;
      session.resetSessionSelectedStatus();
    }
  }

  async updateIndex(): Promise<void> {
    log.showInfo(`updateIndex: screenId: ${this.screenProperty.screenId}, selectedIndex: ${this.selectedIndex}`);
    const recentSessions = this.getRecentSessionIfSplitStateOrNot();
    if (this.selectedIndex === INVALID_INDEX || (this.selectedIndex > recentSessions.length - 1)) {
      if (this.selectedIndex === INVALID_INDEX) {
        this.initTabStatus();
      }
      if (this.oldSelectedIndex >= 0 && this.oldSelectedIndex <= this.containerSessionList.length - 1) {
        let oldIndex = this.containerSessionList.length - 1 - this.oldSelectedIndex;
        this.containerSessionList[oldIndex].tabSelected = false;
        this.containerSessionList[oldIndex].resetSessionSelectedStatus();
      }
      this.oldSelectedIndex = INVALID_INDEX;
      return;
    }
    this.setSelectItem();

    if (this.selectedIndex === 0) {
      this.scroll.scrollTo({ xOffset: 0, yOffset: 0 });
      SCBRecentFoldHalfVM.getInstance().refreshAxisPosition(this.screenProperty.screenId);
      return;
    }
    const currSelectedContainer = recentSessions[this.selectedIndex];
    const container: SCBSceneContainerSession | undefined = this.containerSessionList.find((item) => {
      return item.primarySession?.session.persistentId === currSelectedContainer.sessionId ||
        item.secondarySession?.session.persistentId === currSelectedContainer.sessionId;
    });
    if (!container) {
      return;
    }
    const sceneContainerHeight = container.getSceneContainerHeight();
    const scale = SCBRecentCardViewModel.getSceneContainerRecentScale(container, currSelectedContainer.height);
    const cardHeight: number = this.getRecentCoverHeight(sceneContainerHeight, scale);
    const titleHeight: number = SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
      SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
    const recentViewHeight: number = this.mRecentSessionsViewModel.getCurrentShowHeight() - this.dockHeight;
    let offsetY: number = Number(currSelectedContainer.top) - titleHeight + cardHeight - recentViewHeight +
      this.screenHeight * this.recentStyleManager.getStyle().cardLineSpacePercent;
    const oldOffsetY = this.scroll.currentOffset().yOffset;
    offsetY -= this.getExcessYForUpdateIndex(offsetY - oldOffsetY);
    log.showInfo(`update scroll OffsetY: ${offsetY}`);
    this.scroll.scrollTo({ xOffset: 0, yOffset: Math.max(0, offsetY) });
    SCBRecentFoldHalfVM.getInstance().refreshAxisPosition(this.screenProperty.screenId);
    return;
  }

  private getExcessYForUpdateIndex(updateY: number): number {
    const containerSession = this.containerSessionList.getTopActiveSession();
    if (containerSession && containerSession.isOneStepSplit() && containerSession.primarySession) {
      const excessY = containerSession.primarySession.translateY + updateY +
      this.screenHeight - this.scrollStackHeight;
      return excessY > 0 ? excessY : 0;
    }
    return 0;
  }

  getContainerSessionListNotShowRecentCallback = (): SCBSceneContainerSessionArray => {
    return this.containerSessionListNotShowRecent;
  }

  getContainerSessionListCallback = (): SCBSceneContainerSessionArray => {
    log.showDebug(`getContainerSessionListCallback, screenId: ${this.screenProperty.screenId}, ` +
      `length: ${this.containerSessionList.length}`);
    return this.containerSessionList;
  }

  getAllContainerSessionListCallback = (): SCBSceneContainerSessionArray => {
    return SCBSessionListManager.allContainerSessionList;
  }

  private closeMenuAndPopup(): void {
    ContextMenu.close();
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    AppStorage.setOrCreate('isRecentPopupShow', false);
    AppStorage.setOrCreate('openFolderStatus', 0);
    AppStorage.setOrCreate('showUninstallDialog', false);
    AppStorage.setOrCreate('isPopupMenuShow', false);
  }

  private getSpecificSceneList(scene: SCBSceneContainerSession, dialogSceneList: SCBSpecificSession[]) {
    if (scene.primarySession === null) {
      return;
    }

    dialogSceneList.push(...scene.primarySession?.dialogSessionList);
    if (scene.primarySession?.subSessionList) {
      this.traverseSubList(scene.primarySession.subSessionList, dialogSceneList);
    }
    if (scene.isSplit && scene.secondarySession) {
      dialogSceneList.push(...scene.secondarySession.dialogSessionList);
      if (scene.secondarySession?.subSessionList) {
        this.traverseSubList(scene.secondarySession.subSessionList, dialogSceneList);
      }
    }
  }

  private setSpecificSceneOpacity(scene: SCBSceneContainerSession, opacity: number) {
    const dialogSceneList: SCBSpecificSession[] = [];
    this.getSpecificSceneList(scene, dialogSceneList);
    for (const dialogScene of dialogSceneList) {
      dialogScene.opacity = opacity;
    }
  }

  private resetSpecificSceneTransition(scene: SCBSceneContainerSession): void {
    const dialogSceneList: SCBSpecificSession[] = [];
    this.getSpecificSceneList(scene, dialogSceneList);
    for (const dialogScene of dialogSceneList) {
      dialogScene.scaleX = 1;
      dialogScene.scaleY = 1;
      dialogScene.translateX = 0;
      dialogScene.translateY = 0;
    }
  }

  private setSceneTransitionInRestoreDesktop(scene: SCBSceneContainerSession | SCBSpecificSession | undefined) {
    if (scene === undefined) {
      return;
    }
    if ((scene instanceof SCBSpecificSession && scene.screenId === this.screenProperty.screenId) ||
      (scene instanceof SCBSceneContainerSession && scene.primarySession !== null &&
        scene.primarySession.sceneInfo.screenId === this.screenProperty.screenId)) {
      SCBRecentCardViewModel.setSceneTranslate(scene, 0, 0);
      SCBRecentCardViewModel.setSceneScale(scene, 1);
    }
    SCBPcScenePanelManager.getInstance().setSceneBorderRadiusInClearScene(scene, 0, 1);
  }

  private onFourFingersSwipeEvent = (gesture: FourFingersSwipe): void => {
    log.showInfo(`[DesktopWorld] onFourFingersSwipeEvent screenId: ${this.screenProperty.screenId}`);
    if (!FourFingerSwipeController.getInstance().startFourFingersSwipe(gesture.type === ActionType.BEGIN)) {
      return;
    }
    let timestamp = Date.now();
    if (gesture.type === ActionType.BEGIN && !this.isLock) {
      FourFingerSwipeController.getInstance().swipeBegin();
    } else if (gesture.type === ActionType.UPDATE) {
      FourFingerSwipeController.getInstance().swipeUpdate(gesture.x, gesture.y, timestamp);
    } else if (gesture.type === ActionType.END) {
      FourFingerSwipeController.getInstance().swipeEnd();
    } else {
      log.showWarn('[DesktopWorld] four fingers swipe other');
      FourFingerSwipeController.getInstance().swipeEnd();
    }
  }

  onFourFingerMotionBegin(): boolean {
    this.closeMenuAndPopup();
    this.closeHiSearch();
    viewMgrPolicy.hideView(ViewType.SHORTCUT_KEY_PANEL);
    try {
      commonEventManager.publish(windowCommonEventManager.FOUR_FINGER_SWIPER_BEGIN, () => {
        log.showDebug('publish FOUR_FINGER_SWIPER_BEGIN success');
      });
    } catch (error) {
      log.showError(`catchCommonEventManager error.code: ${error?.code}, error.message: ${error?.message}`);
    }
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || this.scenePanelState === ScenePanelState.SPLIT ||
      this.scenePanelState === ScenePanelState.RECENT || this.blurTransitioning) {
      let split: boolean = this.scenePanelState === ScenePanelState.SPLIT;
      let recent: boolean = this.scenePanelState === ScenePanelState.RECENT;
      log.showWarn(`[DesktopWorld] four finger motion begin app center:
      ${viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)}` + `, split: ${split}` + `, recent: ${recent}
      ` + `, blur transitioning: ${this.blurTransitioning}`);
      return false;
    }
    return true;
  }

  onFourFingerMotionUpdate(): void {
    this.closeFocusedSubWin();
  }

  onFourFingerMotionEnd(): void {
    if (this.scenePanelState === ScenePanelState.SPLIT) {
      let curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      if (curActiveContainerSession?.isSplit) {
        let persistentId = curActiveContainerSession.getPersistentId();
        this.exitSplitView(persistentId);
      }
    } else if (this.scenePanelState === ScenePanelState.RECENT) {
      this.exitRecentView();
    }
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
    }
  }

  private onMultiFingersTouchScreenSwipe = (event: TouchGestureEvent): boolean => {
    if (sSCBOobeManager.isOobeActivated()) {
      log.showWarn('[SCBEvent]oobe enabled, swipe gesture unavaliable');
      return false;
    }
    if (event.action === TouchGestureAction.GESTURE_END) {
      this.hideFloatingTitle();
    }
    return false;
  }

  private vmStateCallback: VmStateCallBack = (isVm: boolean, tarVmScreenId: number) => {
    if (isVm) {
      // 如果单指上滑跟手时被四指横滑打断，还原窗口缩放和位移
      this.containerSessionList.forEach((containerSession) => {
        if (containerSession.isActive && containerSession.needRenderVisibility.visibility) {
          this.setSceneTransitionInRestoreDesktop(containerSession);
          this.resetSpecificSceneTransition(containerSession);
        }
      });
      multiInputManager.unRegisterWinDpadKeyInput();
    } else {
      this.isHandleThreeFingerSwiper = false;
      this.isOneFingerUp = false;
      multiInputManager.registerWinDpadKeyInput();
    }
  }

  private threeFingersTapCallback = (threeFingersTap: ThreeFingersTap) => {
    log.showInfo('threeFingersTap');
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_THREE_FINGERS_TAP, threeFingersTap);
  }

  resetSceneGestureFinishCallBack = (): void=> {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_BACKTOWINDOW, StyleConstants.DEFAULT_0);
    performanceMonitor.end('PC_RESTORE_DESKTOP_GESTURE_OPERATION');
    this.gestureFirstMove = true;
    systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_TFU_WINDOW);
  }

  private setSceneOpacity(scene: SCBSceneContainerSession | SCBSpecificSession | undefined, opacity: number) {
    if (scene === undefined) {
      return;
    }
    if (scene instanceof SCBSpecificSession) {
      scene.opacity = opacity;
      return;
    }
    if (scene.primarySession !== null && scene.primarySession.opacity !== opacity) {
      scene.primarySession.opacity = opacity;
    }
    if (scene.isSplit && scene.secondarySession) {
      if (scene.secondarySession.opacity !== opacity) {
        scene.secondarySession.opacity = opacity;
      }
      if (scene.dividerParam.dividerOpacity !== opacity) {
        scene.dividerParam.dividerOpacity = opacity;
      }
    }
  }

  dockAutoHideChanged() {
    log.showInfo(`dockAutoHideChanged ${this.isDockAutoHide}, screenId ${this.screenProperty.screenId}`);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    let screenId = this.screenProperty.screenId;
    let statusBarHeightPx: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar && !this.isDockAutoHide) {
      statusBarHeightPx = statusBar.currRect.height.getPx();
    }
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    let dockRect = new SCBSessionRect(0, 0, 0, 0);
    if (dock && !this.isDockAutoHide) {
      dockRect.copyFrom(dock.currRect);
      dockHeight = dock.currRect.height.getPx();
    } else {
      log.showError('getRealScreenInfo SmartDock no exit');
    }

    for (let containerSession of [...this.containerSessionList, ...this.containerSessionListNotShowRecent]) {
      if (containerSession?.screenProperty?.screenId !== this.screenProperty.screenId) {
        log.showWarn(`screenId not same. screenId = ${this.screenProperty.screenId}, ` +
          `container = [${containerSession?.primarySession?.sceneInfo?.bundleName}, ` +
          `${containerSession?.screenProperty?.screenId}]`);
        continue;
      }
      if (!containerSession.isSplit && containerSession.primarySession) { // float and fullscreen scene
        let dockHeightNoSplit: number = 0;
        let statusBarHeightNoSplit: number = statusBarHeightPx;
        if (containerSession.primarySession.getRealLayoutFullScreen()) {
          dockHeightNoSplit = 0;
          statusBarHeightNoSplit = 0;
        } else {
          dockHeightNoSplit = this.isDockAutoHide ? -dock.currRect.height.getPx() : dock.currRect.height.getPx();
        }
        this.updateRectStatusBarWithSwitch(containerSession,
          containerSession.primarySession, statusBarHeightNoSplit, dockHeightNoSplit);
        continue;
      }

      if (containerSession.isSplit && containerSession.primarySession && containerSession.secondarySession) {
        if (containerSession.dividerParam.isExpandUpDownSplit()) { // Up down split scene
          let upperSession = containerSession.primarySession;
          let lowerSession = containerSession.secondarySession;
          if (!containerSession.dividerParam.isSplitPrimaryMode) {
            lowerSession = containerSession.primarySession;
            upperSession = containerSession.secondarySession;
          }
          let upperHeight = upperSession.currRect.height.getPx();
          let lowerHeight = lowerSession.currRect.height.getPx();
          if (!this.isDockAutoHide) {
            upperHeight = upperHeight - (statusBarHeightPx + dockHeight) / 2;
            lowerHeight = lowerHeight - (statusBarHeightPx + dockHeight) / 2;
          } else {
            let sumHeight = upperHeight + lowerHeight + vp2px(DividerStyle.DIVIDER_WIDTH);
            upperHeight = upperHeight / (sumHeight) * (this.screenProperty.height);
            lowerHeight = lowerHeight / (sumHeight) * (this.screenProperty.height);
          }
          containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.primarySession?.session.markSystemSceneUIFirst(true, false);
          containerSession.secondarySession?.session.markSystemSceneUIFirst(true, false);
          if (upperSession.lastRect.top.getPx() < statusBarHeightPx) {
            upperSession.lastRect.setPosNum(upperSession.lastRect.left.getPx(), statusBarHeightPx);
          }
          if (lowerSession.lastRect.top.getPx() < statusBarHeightPx) {
            lowerSession.lastRect.setPosNum(lowerSession.lastRect.left.getPx(), statusBarHeightPx);
          }
          this.getUIContext()?.animateTo({
            duration: 150,
            onFinish: () => {
              if (containerSession.dividerParam.isSplitPrimaryMode) {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
              } else {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
              }
              containerSession.primarySession?.session.markSystemSceneUIFirst(false, false);
              containerSession.secondarySession?.session.markSystemSceneUIFirst(false, false);
            }
          }, () => {
            containerSession.dividerParam.primary.height = (upperHeight / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.secondary.height = (lowerHeight / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.positionY = `${px2vp(statusBarHeightPx + upperHeight)}`;

            SCBSplitLayoutHelper.refreshSplitContainer(containerSession, this.screenProperty, this.getUIContext());
          })
        } else { // left right split scene
          let height: number;
          if (!this.isDockAutoHide) {
            height = containerSession.secondarySession.currRect.height.getPx() +
            containerSession.secondarySession.currRect.top.getPx() - statusBarHeightPx - dockHeight
          }
          containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.primarySession?.session.markSystemSceneUIFirst(true, false);
          containerSession.secondarySession?.session.markSystemSceneUIFirst(true, false);
          if (containerSession.primarySession.lastRect.top.getPx() < statusBarHeightPx) {
            containerSession.primarySession.lastRect
              .setPosNum(containerSession.primarySession.lastRect.left.getPx(), statusBarHeightPx);
          }
          if (containerSession.secondarySession.lastRect.top.getPx() < statusBarHeightPx) {
            containerSession.secondarySession.lastRect
              .setPosNum(containerSession.secondarySession.lastRect.left.getPx(), statusBarHeightPx);
          }
          this.getUIContext()?.animateTo({
            duration: 150,
            onFinish: () => {
              if (containerSession.dividerParam.isSplitPrimaryMode) {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
              } else {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
              }
              containerSession.primarySession?.session.markSystemSceneUIFirst(false, false);
              containerSession.secondarySession?.session.markSystemSceneUIFirst(false, false);
            }
          }, () => {
            containerSession.dividerParam.primary.height = (height / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.secondary.height = (height / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.positionY = `${px2vp(statusBarHeightPx)}`;
            containerSession.dividerParam.dividerHeight = px2vp(height);
            SCBSplitLayoutHelper.refreshSplitContainer(containerSession, this.screenProperty, this.getUIContext());
          })
        }
      }
    }

    if (statusBarHeightPx === 0) { //hide status bar no need to update sub window and input method window
      return;
    }

    let systemSceneList: SCBSpecificSceneSessionList =
      SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR);
    if (systemSceneList.length > 0) {
      systemSceneList.forEach((sceneSession) => {
        this.updateSpecificRectToAvoidStatusBar(sceneSession, statusBarHeightPx);
      })
    }
  }

  private handleSwipeUpFail(curSpeed: number, reason?: string): void {
    return;
  }

  /**
   * check if there is a window moving (dragging and moving the title bar with the pointer)
   * a moving window should already be focused
   * @returns
   */
  private windowIsMoving(): boolean {
    const focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId);
    const isTypeValid = focusedSession instanceof SCBSceneSession || focusedSession instanceof SCBSpecificSession;
    if (isTypeValid && focusedSession?.isSessionMoving) {
      log.showInfo(`focus session ${focusedSession?.getName?.()}`)
      return true;
    }
    return false;
  }

  /**
   * check if there is a divider moving (dragging and moving the divider with the pointer)
   * a moving window should already be focused
   * @returns
   */
  private dividerIsDragging(): boolean {
    const topContaninerSession = SCBSceneSessionManager.getInstance().getContainerSessionList().getTopSession();
    if (topContaninerSession?.isSplit) {
      return topContaninerSession.dividerParam.isDividerDragging;
    }
    return false;
  }

  private changeRecent(): void {
    log.showInfo(`changeRecent screenId: ${this.screenProperty.screenId},showRecent: ${this.showRecent}`);
    const isWindowScenesUnlock = AppStorage.get('isWindowScenesUnlock') as boolean;
    if (isWindowScenesUnlock) {
      this.showRecent = false;
      log.showInfo(`screenId: ${this.screenProperty.screenId}, do nothing in isWindowScenesUnlock`);
      return;
    }
    if (this.windowIsMoving() || this.dividerIsDragging()) {
      this.showRecent = false;
      log.showInfo(`screenId: ${this.screenProperty.screenId}, window is moving`);
      return;
    }

    if (!this.multiRecentManger.checkChangeRecentResponsive() &&
      this.screenProperty.screenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
      this.multiRecentManger.enableChangeRecentResponsive();
      log.showInfo(`changeRecent, ${this.screenProperty.screenId} changeRecent is not responsive`);
      return;
    }

    if ((this.scenePanelState === ScenePanelState.RECENT || this.scenePanelState === ScenePanelState.APP_CENTER) &&
      !this.showRecent) {
      this.exitRecentView();
    } else if (this.scenePanelState !== ScenePanelState.RECENT && this.showRecent) {
      this.enterRecentView();
    } else {
      log.showInfo('screenId: %{public}d, do nothing in scenePanelState: %{public}d, showRecent: %{public}s',
        this.screenProperty.screenId, this.scenePanelState, this.showRecent);
    }
  }

  private queryFront() {
    return this.containerSessionList.filter((scene) => {
      return (scene.isActive && !scene.primarySession?.isMinimizing)
    });
  }

  private traverseSubList(subList: SCBSpecificSceneSessionList, dialogSceneList: SCBSpecificSession[]) {
    for (let i = 0; i < subList.length; i++) {
      let subItem = subList[i];
      if (subItem !== null) {
        dialogSceneList.push(subItem);
        let subsubSessionList = subItem.subSessionList;
        if (subsubSessionList !== null) {
          this.traverseSubList(subsubSessionList, dialogSceneList);
        }
      }
    }
  }

  private closeHiSearch(): void {
    commonEventManager.publish(EVENT_DESKTOP_HIDE_SEARCH_PANEL, (err) => {
      if (err) {
        console.error(`publish close hisearch failed, code is ${err.code}, message is ${err.message}`);
      } else {
        console.info('publish close hisearch success');
      }
    });
  }

  private closeFocusedSubWin(): void {
    // hide window title Max hover menu
    const focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId);
    if (focusedSession instanceof SCBSpecificSession &&
      focusedSession.session.type === sceneSessionManager.SessionType.TYPE_SUB_APP) {
      SCBSceneSessionManager.getInstance()
        .requestUnfocus(focusedSession.session.persistentId, FocusChangeReason.SCB_SESSION_REQUEST_UNFOCUS);
    }
  }

  private setRecentWindowEffect(containerSession: SCBSceneContainerSession): void {
    const windowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
    if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      containerSession.primarySession.shadowConfig.radius =
        containerSession.primarySession?.isFocused ?
        windowSceneConfig.focusedShadow.radius : windowSceneConfig.unfocusedShadow.radius;
      containerSession.primarySession.shadowConfig.color =
        containerSession.primarySession?.isFocused ?
        windowSceneConfig.focusedShadow.color : windowSceneConfig.unfocusedShadow.color;
    }
    if (containerSession.primarySession !== null && containerSession.secondarySession !== null) {
      if (containerSession.primarySession.isFocused || containerSession.secondarySession.isFocused) {
        containerSession.primarySession.shadowConfig.radius = windowSceneConfig.focusedShadow.radius;
        containerSession.secondarySession.shadowConfig.radius = windowSceneConfig.focusedShadow.radius;
        containerSession.primarySession.shadowConfig.color = windowSceneConfig.focusedShadow.color;
        containerSession.secondarySession.shadowConfig.color = windowSceneConfig.focusedShadow.color;
      } else {
        containerSession.primarySession.shadowConfig.radius = windowSceneConfig.unfocusedShadow.radius;
        containerSession.secondarySession.shadowConfig.radius = windowSceneConfig.unfocusedShadow.radius;
        containerSession.primarySession.shadowConfig.color = windowSceneConfig.unfocusedShadow.color;
        containerSession.secondarySession.shadowConfig.color = windowSceneConfig.unfocusedShadow.color;
      }
    }
  }

  private recoverRecentWindowEffect() {
    const len = this.containerSessionList.length;
    for (let i = 0; i < len; i++) {
      let containerSession = this.containerSessionList[i];
      if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
        containerSession.primarySession.shadowConfig.radius = 0;
        containerSession.primarySession.shadowConfig.color = '#00000000';
      }
      if (containerSession.primarySession !== null && containerSession.secondarySession !== null) {
        containerSession.primarySession.shadowConfig.radius = 0;
        containerSession.secondarySession.shadowConfig.radius = 0;
        containerSession.primarySession.shadowConfig.color = '#00000000';
        containerSession.secondarySession.shadowConfig.color = '#00000000';
      }
    }
  }

  private enterSplitRecentView(containerSession: SCBSceneContainerSession, isPrimary: boolean) {
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    const recentRect = LayoutPolicyHelper.getInstance()
      .getSplitInitialRect(this.screenProperty, containerSession.dividerParam, !isPrimary);
    this.scrollTranslate = 0;
    this.recentState.setIsInSplit(true);
    this.recentStyleManager.setSplitStyle(true);
    this.scrollFlingSpeedLimit = this.recentStyleManager.getStyle().flingSpeedLimit;
    this.mRecentSessionsViewModel.setScreenProperty(this.screenWidth, this.screenHeight);
    this.mRecentSessionsViewModel.setRecentProperty(PCUtils.px2vp(this.getUIContext(), recentRect.left.getPx()),
      PCUtils.px2vp(this.getUIContext(), recentRect.top.getPx()),
      PCUtils.px2vp(this.getUIContext(), recentRect.width.getPx()),
      PCUtils.px2vp(this.getUIContext(), recentRect.height.getPx()));
    const persistentIds: number[] = [];
    if (containerSession.primarySession && containerSession.primarySession.session) {
      persistentIds.push(containerSession.primarySession.session.persistentId)
    }
    this.notSupportSplitRecentSessionInfo = this.mRecentSessionsViewModel
      .getRecentSessionsListIfNotSupportSplitMode();
    this.notSupportSplitRecentSessionInfo.forEach((sessionInfo) => {
      persistentIds.push(sessionInfo?.sessionId as number);
    });
    this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessionsNotInclude(persistentIds);
    this.enterRecentFromWindowOrHome();
    this.removeContainerSessionList = [];
    this.checkRecentEmptyView();
    this.mRecentFocusManager.setCurrentScreenId(this.screenProperty.screenId);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    this.printContainerSessions();
    this.mRecentSessionsViewModel.print();
  }

  private noAnimateContainerSessionList: SCBSceneContainerSession[] = [];
  private defaultContainerSessionList: SCBSceneContainerSession[] = [];

  private handleEnterRecentFast(): void {
    let recentInvisibleContainerSessionList: SCBSceneContainerSession[] = [];
    let recentVisibleContainerSessionList: SCBSceneContainerSession[] = [];
    let bgToRecentVisibleContainerSessionList: SCBSceneContainerSession[] = [];
    this.containerSessionList.forEach((containerSession) => {
      const recentSession = this.currentRecentSessionInfo.find(
        (element) => element.sessionId == containerSession.primarySession?.session.persistentId);
      if (recentSession === undefined) {
        recentLog.showError('cannot find recent session, screenId: %{public}d bundleName = %{public}s ',
          this.screenProperty.screenId, containerSession.primarySession?.sceneInfo.bundleName);
        return;
      }
      if (recentSession.animType === SCBRecentStyleConstants.RECENT_ANIM_TYPE_CHAIN) {
        bgToRecentVisibleContainerSessionList.push(containerSession);
      } else if (recentSession.animType === SCBRecentStyleConstants.RECENT_ANIM_TYPE_FADE_OUT) {
        recentInvisibleContainerSessionList.push(containerSession);
      } else {
        recentVisibleContainerSessionList.push(containerSession);
      }
    });
    this.recentEnter.groupAnimationRefInit();
    // 屏幕内的不可见窗口将recentInvisibleContainerSessionList传进去，需要等屏幕内可见窗口动效完成后再处理
    const handleWindowToRecentDelayCallback = () => {
      this.handleWindowToRecentDelay(recentInvisibleContainerSessionList);
    }
    // 需要先将前台但是并不在屏幕内的窗口透明度设置为0，否则会导致进了多任务有几帧该窗口会显示多任务背板后面
    this.handleInvisibleWindowsInRecentOpacityToZero(recentInvisibleContainerSessionList);
    this.bgWindowsToRecentVisiableWithAnimation(bgToRecentVisibleContainerSessionList,
      handleWindowToRecentDelayCallback);
    this.handleRecentVisibleWindowsImmediately(recentVisibleContainerSessionList,
      handleWindowToRecentDelayCallback);
    this.scenePanelScale = 1;
    this.scenePanelOpacity = 1;
  }

  private handleRecentVisibleWindowsImmediately(sceneContainerSessionList: SCBSceneContainerSession[],
    onFinishCallback: Function = () => {}): void {
    if (sceneContainerSessionList.length === 0) {
      return;
    }
    this.getUIContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        if (this.isEnterRecentView) {
          this.recentEnter.groupAnimationRefDec();
          if (this.recentEnter.groupAnimationRefZero()) {
            onFinishCallback();
          }
        }
      }
    }, () => {
      this.recentEnter.groupAnimationRefAdd();
      sceneContainerSessionList.forEach((sceneContainerSession) => {
        this.calcContainerLayoutInRecent(sceneContainerSession, 'handleRecentVisibleWindowsImmediately');
        SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
      });
    });
  }

  private doExitAnimationNoAnimate(): void {
    log.showInfo('doExitAnimationNoAnimate');
    const len = this.containerSessionList.length;
    for (let i = 0; i < len; i++) {
      const containerSession = this.containerSessionList[i];
      containerSession.dividerParam.isSplitRecentPair = false;
      const recentSession = this.currentRecentSessionInfo.find(
        (element) => element.sessionId == containerSession.primarySession?.session.persistentId);
      if (recentSession === undefined || recentSession.sessionId === this.pairPersistentId) {
        recentLog.showError('cannot find recent session, screenId: %{public}d, bundleName = %{public}s',
          this.screenProperty.screenId, containerSession.primarySession?.sceneInfo.bundleName);
        continue;
      }
      if (containerSession.isActive) {
        this.defaultContainerSessionList.push(containerSession);
      } else {
        this.noAnimateContainerSessionList.push(containerSession);
      }
    }
    this.recentToWindowDefaultNoAnimate(this.defaultContainerSessionList);
    this.handleRecentToWindowNoAnimate(this.noAnimateContainerSessionList);
    this.recentSubSceneViewModel.buildSubScenesBatch(this.containerSessionList);
    this.resetSessionList();
  }

  private resetSessionList(): void {
    this.noAnimateContainerSessionList.length = 0;
    this.defaultContainerSessionList.length = 0;
  }

  private enterRecentView(): void {
    this.recentState.setIsInSplit(false);
    this.recentState.onEnterRecentStart();
    AppStorage.setOrCreate('isRecentCardAnimating', false);
    this.recentStyleManager.setSplitStyle(false);
    const recentStyle: SCBRecentStyle = this.recentStyleManager.getStyle();
    this.scrollFlingSpeedLimit = recentStyle.flingSpeedLimit;
    const height: number = recentStyle.getRecentShowHeight();
    const screenHeight = height > 0 ? height : this.screenHeight;
    this.mRecentSessionsViewModel.setScreenProperty(this.screenWidth, this.screenHeight);
    this.mRecentSessionsViewModel.setRecentProperty(0, 0, this.screenWidth, screenHeight);
    this.recentEnter.switchInFocus(this.sysSceneSession);
    this.stopRecentEnterDelayAnimateTimer();
    this.mRecentFocusManager.init();
    this.multiRecentManger.init();
    this.initSplitContainerShowInRecent();
    if (this.scenePanelState === ScenePanelState.SPLIT) {
      const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      if (curActiveContainerSession?.isSplit) {
        const persistentId = curActiveContainerSession.getPersistentId();
        let parm = new ExitSplitParam();
        parm.needExitSplitRecent = false;
        this.exitSplitView(persistentId, parm);
      }
      this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessions();
      this.enterRecentFromSplitPair();
      this.updateScenePanelState(ScenePanelState.RECENT);
    } else {
      this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessions();
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_MISSION_CENTER);
      this.updateScenePanelState(ScenePanelState.RECENT);
      this.enterRecentFromWindowOrHome();
    }
    this.checkRecentEmptyView();
    this.recentState.onEnterRecentEnd();
    this.removeContainerSessionList = [];
    this.recordEndEnterRecentLogs();
    RecentAndAppCenterSwitchManager.getInstance().setOneFrameVisible(this.screenProperty.screenId, false);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
  }

  private checkRecentEmptyView(): void {
    this.showRecentEmptyView = this.isCurScreenContainerEmpty() && this.isRecentState() || this.isEmptyInSplitState();
  }

  // 1，从Home进入recent: start IntoRecent:Gesture:Land. from home
  private recordStartEnterRecentLogs(): void {
    recentLog.showInfo('start %{public}s from home. screenId: %{public}d', TraceUtil.CORE_METHOD_ENTER_RECENT,
      this.screenProperty.screenId);
    TraceUtil.startTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT);
  }

  private printContainerSessions(): void {
    let logs: string = '';
    if (this.containerSessionList.length === 0) {
      logs += 'enter empty recent view';
    } else {
      logs += 'enter recent view, sessions show in recent: ';
      this.containerSessionList.forEach((item, index) => {
        logs += `${index}: ${item.getName()}, `
      })
      logs += 'sessions not show in recent: ';
      this.containerSessionListNotShowRecent.forEach((item, index) => {
        logs += `${index}: ${item.getName()}, `
      })
    }
    recentLog.showInfo(logs);
  }

  // 1、进入空白页面：end IntoRecent. enter empty recent view success.
  // 2、进入多任务页面：end IntoRecent. enter recent view, sessions: [${sessionName1}, ${sessionName2},...].
  private recordEndEnterRecentLogs(): void {
    recentLog.showInfo(`end ${TraceUtil.CORE_METHOD_ENTER_RECENT}. `);
    TraceUtil.endTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT);
    this.printContainerSessions();
    this.mRecentSessionsViewModel.print();
  }

  private enterRecentFromSplitPair(): void {
    this.recentState.onEnterRecentAllAnimateStart();
    this.recordEnterRecentStartLogs();
    this.isEnterRecentView = true;
    this.handleChainAnimateData();
    this.resetSessionList();
    for (let containerSession of this.containerSessionList) {
      const recentSession = this.currentRecentSessionInfo.find(
        (element) => element.sessionId == containerSession.primarySession?.session.persistentId);
      if (recentSession === undefined) {
        recentLog.showError(`cannot find recent session, bundleName = ${containerSession.primarySession?.sceneInfo.bundleName}`);
        continue;
      }
      if (recentSession.animType === SCBRecentStyleConstants.RECENT_ANIM_TYPE_FADE_OUT) {
        this.noAnimateContainerSessionList.push(containerSession);
      } else {
        this.defaultContainerSessionList.push(containerSession);
      }
    }
    this.recentEnter.groupAnimationRefInit();
    // 延时加载的卡片，透明度先显示为0
    this.setInvisibleWindowsInRecentOpacityToZero(this.noAnimateContainerSessionList);
    this.fgWindowToRecentVisibleAnimation(this.defaultContainerSessionList);
    this.updateStackHeight();
    this.scroll.scrollTo({ xOffset: 0, yOffset: 0 });
    this.recordEnterRecentEndLogs();
    this.recentState.onEnterRecentAllAnimateStarted();
  }

  private enableApsForRecent(): void {
    if (this.recentStyleManager.getStyle().isSplitStyle) {
      return;
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.ENTER_RECENTVIEW, StyleConstants.DEFAULT_1);
  }

  private disableAps(): void {
    if (this.recentStyleManager.getStyle().isSplitStyle) {
      return;
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.ENTER_RECENTVIEW, StyleConstants.DEFAULT_2);
  }

  private enterRecentFromWindowOrHome(): void {
    this.recentState.onEnterRecentAllAnimateStart();
    this.recordEnterRecentStartLogs();
    this.closeHiSearch();
    this.closeFocusedSubWin();
    this.memoryHelper.refresh();
    this.isEnterRecentView = true;
    this.handleChainAnimateData();
    this.resetSessionList();
    if (!this.isPairSplit) {
      this.updateStackHeight();
    }
    this.containerSessionList.forEach((containerSession) => {
      const recentSession = this.currentRecentSessionInfo.find(
        (element) => element.sessionId == containerSession.primarySession?.session.persistentId);
      if (recentSession === undefined) {
        recentLog.showError('cannot find recent session, screenId: %{public}d bundleName = %{public}s ',
        this.screenProperty.screenId, containerSession.primarySession?.sceneInfo.bundleName);
        return;
      }
      if (containerSession.isBackground()) {
        containerSession.setShowRecent();
      }
      this.setRecentWindowEffect(containerSession);
    });

    this.onBlurTransitionActive();
    this.recentSubSceneViewModel.destroySubScenesBatch(this.containerSessionList);
    this.handleEnterRecentFast();
    this.recentNotShowViewModel.destroyBackgroundNotShowContainer(this.containerSessionList);
    this.recentNotShowViewModel.hideNotShowInRecentScene(this.screenProperty, this.containerSessionList);
    this.registerKeyInRecent();
    this.recordEnterRecentEndLogs();
    this.recentState.onEnterRecentAllAnimateStarted();
  }

  private recordEnterRecentStartLogs(): void {
    TraceUtil.startAnimTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION);
    recentLog.showInfo('start %{public}s, screenId: %{public}d', TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION,
      this.screenProperty.screenId);
  }

  private recordEnterRecentEndLogs(): void {
    TraceUtil.endAnimTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION);
    recentLog.showInfo('end %{public}s, screenId: %{public}d', TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION,
      this.screenProperty.screenId);
  }

  private handleChainAnimateData(): void {
    for (let i = 0; i < this.currentRecentSessionInfo.length; i++) {
      if (this.currentRecentSessionInfo[i].animType === SCBRecentStyleConstants.RECENT_ANIM_TYPE_CHAIN) {
        this.chainStartRow = this.currentRecentSessionInfo[i].rowNum;
        break;
      }
    }
    for (let i = this.currentRecentSessionInfo.length - 1; i >= 0; i--) {
      if (this.currentRecentSessionInfo[i].animType === SCBRecentStyleConstants.RECENT_ANIM_TYPE_CHAIN) {
        this.chainMaxRow = this.currentRecentSessionInfo[i].rowNum;
        break;
      }
    }
    this.chainMaxRow = Math.min(this.chainMaxRow, this.recentStyleManager.getStyle().animationChainMaxRowNum - 1);
  }

  private initSplitContainerShowInRecent(): void {
    const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
    if (curActiveContainerSession && curActiveContainerSession.isSplit &&
      (this.scenePanelState === ScenePanelState.SPLIT || curActiveContainerSession.isPairSplitAnimating)) {
      for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
        this.containerSessionList[i].dividerParam.isSplitRecentPair = false;
      }
    }
  }

  calculateIndexByRatio(curSession: SCBRecentSessionInfo, nextSessionList: Array<SCBRecentSessionInfo>):
    SCBRecentSessionInfo {
    let resSession: SCBRecentSessionInfo = nextSessionList[nextSessionList.length - 1];
    let maxRatio: number = 0;
    const curRight = curSession.left + (curSession.width as number);
    for (let index = nextSessionList.length - 1; index >= 0; index--) {
      const nextSession = nextSessionList[index];
      const nextRight = nextSession.left + (nextSession.width as number);
      if (curRight < nextSession.left) {
        resSession = nextSession;
        continue;
      } else if (curSession.left < nextSession.left && curRight < nextRight) {
        const ratio = (curRight - nextSession.left) / (nextSession.width as number);
        if (ratio > maxRatio) {
          resSession = nextSessionList[index];
          maxRatio = ratio;
        }
      } else if ((curSession.left <= nextSession.left && curRight >= nextRight) ||
        (curSession.left >= nextSession.left && curRight <= nextRight)) {
        return nextSessionList[index];
      } else if (curSession.left > nextSession.left && curSession.left < nextRight && curRight > nextRight) {
        const ratio = (nextRight - curSession.left) / (nextSession.width as number);
        if (ratio > maxRatio) {
          resSession = nextSessionList[index];
          maxRatio = ratio;
        }
      } else {
        break;
      }
    }
    return resSession;
  }

  private getRecentFocusResult(recentSessions: Array<SCBRecentSessionInfo>, focusType: number, index: number): number {
    const len: number = recentSessions.length;
    const sourceSessionList = recentSessions.filter(session => Number(session.rowNum) === recentSessions[index].rowNum);
    let cnt: number = 0;
    let dstSessionList: SCBRecentSessionInfo[] = [];
    for (cnt = 0; cnt < sourceSessionList.length; cnt++) {
      if (sourceSessionList[cnt].sessionId === recentSessions[index].sessionId) {
        break;
      }
    }
    if (focusType === KeyCodeConstants.KEYCODE_DPAD_DOWN) {
      dstSessionList = recentSessions[index].rowNum === recentSessions[len - 1].rowNum ?
      recentSessions.filter(session => Number(session.rowNum) === 0) :
      recentSessions.filter(session => Number(session.rowNum) === recentSessions[index].rowNum + 1);
    } else if (focusType === KeyCodeConstants.KEYCODE_DPAD_UP) {
      dstSessionList = recentSessions[index].rowNum === 0 ?
      recentSessions.filter(session => Number(session.rowNum) === recentSessions[len - 1].rowNum) :
      recentSessions.filter(session => Number(session.rowNum) === recentSessions[index].rowNum - 1);
    }
    let resultIndex: number = this.memoryHelper.getCache(dstSessionList[0].rowNum);
    if (resultIndex !== undefined && resultIndex !== INVALID_INDEX) {
      return resultIndex;
    }
    const destinationSession: SCBRecentSessionInfo = this.calculateIndexByRatio(recentSessions[index], dstSessionList);
    resultIndex = recentSessions.findIndex((item) => {
      return item.sessionId === destinationSession?.sessionId;
    });
    return resultIndex;
  }

  private setRecentFocusIndex(focusType: number, recentSessions: Array<SCBRecentSessionInfo>, index: number): void {
    const len: number = recentSessions.length;
    if (focusType === KeyCodeConstants.KEYCODE_DPAD_RIGHT && index >= len) {
      index = 0;
    }
    if (focusType === KeyCodeConstants.KEYCODE_DPAD_LEFT && index < 0) {
      index = len - 1;
    }
    if (focusType === KeyCodeConstants.KEYCODE_DPAD_DOWN && index >= len) {
      index = index - len;
    }
    if (focusType === KeyCodeConstants.KEYCODE_DPAD_UP && index < 0) {
      index = len + index;
    }
    this.focusType = focusType;
    this.updateSelectedIndex(index);
  }


  private changeFocusInCurrPanel(focusType: number): void {
    if (this.handleSplitSceneFocusInRecent(focusType)) {
      log.showInfo(`changeFocusInCurrPanel splitScene ${focusType}`)
      return;
    }
    const recentSessions = this.getRecentSessionIfSplitStateOrNot();
    const len = recentSessions.length;
    log.showInfo(`changeFocusInCurrPanel focusType: ${focusType}, lent: ${len}`);
    if (recentSessions !== undefined && recentSessions !== null && len > 0) {
      let index: number = this.selectedIndex;
      if (index === undefined || index === -1) {
        index = 0;
      }
      if (this.memoryHelper.getLength() < 1) {
        this.memoryHelper.init(recentSessions[len - 1].rowNum);
      }

      switch (focusType) {
        case KeyCodeConstants.KEYCODE_DPAD_UP:
          this.memoryHelper.setCache(recentSessions[index].rowNum, index);
          index = this.getRecentFocusResult(recentSessions, focusType, index);
          break;
        case KeyCodeConstants.KEYCODE_DPAD_DOWN:
          this.memoryHelper.setCache(recentSessions[index].rowNum, index);
          index = this.getRecentFocusResult(recentSessions, focusType, index);
          break;
        case KeyCodeConstants.KEYCODE_DPAD_RIGHT:
          this.memoryHelper.refresh();
          index++;
          break;
        case KeyCodeConstants.KEYCODE_DPAD_LEFT:
          this.memoryHelper.refresh();
          index--;
          break;
        default:
          break;
      }
      this.setRecentFocusIndex(focusType, recentSessions, index);
    }
  }

  private handleEnterRecentFocus(focusType: number): void {
    if (this.isSplitState()) {
      log.showInfo(`handleEnterRecentFocus in split ${this.screenProperty.screenId}, focusType： ${focusType}`);
      this.changeFocusInCurrPanel(focusType);
      return;
    }
    log.showInfo(`handleEnterRecentFocus ${this.screenProperty.screenId}, focusType： ${focusType}`);
    this.mRecentFocusManager.doChangeFocus(this.selectedIndex, focusType, this.screenProperty.screenId,
      (focusType: number) => { this.changeFocusInCurrPanel(focusType); });
  }

  /**
   * 预分屏下，二分屏内部走焦，焦点index不会变化
   * @param focusType
   * @returns
   */
  private handleSplitSceneFocusInRecent(focusType: number): boolean {
    if (!this.isSplitState()) {
      return false;
    }
    let containerSession: SCBSceneContainerSession | null = this.mRecentFocusController.getRecentSelectedItem();
    if (containerSession === null || !containerSession.isSplit) {
      return false;
    }
    // 上下二分屏
    if (this.mRecentFocusManager.isSplitRecentUpAndDownContainer(containerSession)) {
      if (focusType === KeyCodeConstants.KEYCODE_DPAD_DOWN) {
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY &&
        containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = false;
          containerSession.setPrimarySelectedWithMutex(false);
          return true;
        }
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY &&
          !containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = true;
          containerSession.setPrimarySelectedWithMutex(true);
          return true;
        }
      }
      if (focusType === KeyCodeConstants.KEYCODE_DPAD_UP) {
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY &&
          !containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = true;
          containerSession.setPrimarySelectedWithMutex(true);
          return true;
        }
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY &&
        containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = false;
          containerSession.setPrimarySelectedWithMutex(false);
          return true;
        }
      }
    } else {
      // 左右二分屏
      if (focusType === KeyCodeConstants.KEYCODE_DPAD_RIGHT) {
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY &&
          containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = false;
          containerSession.setPrimarySelectedWithMutex(false);
          return true;
        }
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY &&
          !containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = true;
          containerSession.setPrimarySelectedWithMutex(true);
          return true;
        }
      }
      if (focusType === KeyCodeConstants.KEYCODE_DPAD_LEFT) {
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY &&
          !containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = true;
          containerSession.setPrimarySelectedWithMutex(true);
          return true;
        }
        if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY &&
          containerSession.isPrimarySelected) {
          containerSession.isPrimarySelected = false;
          containerSession.setPrimarySelectedWithMutex(false);
          return true;
        }
      }
    }
    recentLog.showInfo(`handleSplitSceneFocusInRecent false`);
    return false;
  }

  private getRecentSessionIfSplitStateOrNot(): Array<SCBRecentSessionInfo> {
    const persistentIds: number[] = [];
    if (this.isSplitState()) {
      const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      persistentIds.push(curActiveContainerSession?.primarySession?.session.persistentId as number);
      this.notSupportSplitRecentSessionInfo = this.mRecentSessionsViewModel
        .getRecentSessionsListIfNotSupportSplitMode();
      this.notSupportSplitRecentSessionInfo.forEach((sessionInfo) => {
        persistentIds.push(sessionInfo?.sessionId as number);
      });
    }
    return this.mRecentSessionsViewModel.getRecentSessionsNotInclude(persistentIds);
  }

  private exitRecentToFront(): void {
    recentLog.showInfo(`exitRecentToFront`);
    if (!this.containerSessionList.length || !this.isRecentOrSplitState() || this.isEnterSplitAnimating) {
      recentLog.showWarn(`exitRecentToFront error state return`);
      return;
    }
    if (!this.mRecentFocusManager.isScreenFocusResponsive(this.screenProperty.screenId)) {
      log.showInfo(`exitRecentToFront focus not Responsive ${this.screenProperty.screenId}`);
      return;
    }
    let session: SCBSceneContainerSession | null = this.mRecentFocusController.getRecentSelectedItem();
    session = !!session ? session : this.containerSessionList[this.containerSessionList.length - 1];
    let sceneSession: SCBSceneSession | null = session.secondarySession;
    if (session.isPrimarySelected) {
      sceneSession = session.primarySession;
    }
    recentLog.showInfo('isPrimarySelected: isPrimarySelected: %{public}s,bundleName: %{public}s',
      session.isPrimarySelected, sceneSession?.sceneInfo.bundleName);
    SCBSceneSessionManager.getInstance()
      .startSceneFromRecent(this.screenProperty.screenId, sceneSession?.session.persistentId);
    SCBSceneSessionManager.getInstance()
      .requestFocus(sceneSession?.session.persistentId, undefined, FocusChangeReason.MOVE_UP);
  }

  private registerKeyInRecent(): void {
    recentLog.showInfo('registerKeyInRecent');
    multiInputManager.registerTempInput(ShortcutKeyConstants.ESC_UP_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.ESC');
      if (this.isRecentState()) {
        this.exitRecentView();
      }
      if (this.isSplitState()) {
        const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
        if (curActiveContainerSession?.isSplit) {
          const persistentId = curActiveContainerSession.getPersistentId();
          this.exitSplitView(persistentId);
        }
      }
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.UP_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_UP);
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.DOWN_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_DOWN);
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.LEFT_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_LEFT);
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.RIGHT_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_RIGHT);
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ENTER_OPTION, () => {
      this.exitRecentToFront();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.SPACE_OPTION, () => {
      this.exitRecentToFront();
    });
    this.registerShortcutKeyInRecent();
  }

  private registerShortcutKeyInRecent(): void {
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_LEFT_UP_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_UP)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_LEFT_DOWN_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_DOWN)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_LEFT_LEFT_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_LEFT)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_LEFT_RIGHT_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_RIGHT)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_RIGHT_UP_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_UP)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_RIGHT_DOWN_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_DOWN)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_RIGHT_LEFT_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_LEFT)
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ALT_RIGHT_RIGHT_OPTION, () => {
      this.handleEnterRecentFocus(KeyCodeConstants.KEYCODE_DPAD_RIGHT)
    });
  }

  private unregisterKeyInRecent(): void {
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ESC_UP_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.UP_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.DOWN_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.LEFT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.RIGHT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ENTER_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.SPACE_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_LEFT_UP_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_LEFT_DOWN_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_LEFT_LEFT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_LEFT_RIGHT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_RIGHT_UP_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_RIGHT_DOWN_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_RIGHT_LEFT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ALT_RIGHT_RIGHT_OPTION);
  }

  private setRecentTranslateNoAnimate(sceneContainerSession: SCBSceneContainerSession, scale: number): void {
    SCBRecentHoverViewModel.hideRecentHover(sceneContainerSession);
    SCBRecentTitleViewModel.buildRecentTitle(sceneContainerSession);
    SCBRecentTitleViewModel.showRecentTitle(sceneContainerSession);
    let nameForDfx = sceneContainerSession.getName();
    sceneContainerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'setRecentTranslateNoAnimate', nameForDfx);
    sceneContainerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'setRecentTranslateNoAnimate', nameForDfx);
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'setRecentTranslateNoAnimate', nameForDfx);
  }

  private setInvisibleWindowsInRecentOpacityToZero(sceneContainerSessionList: SCBSceneContainerSession[]) {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      SCBRecentCardViewModel.setSceneOpacity(sceneContainerSession, 0);
    });
  }

  private calcContainerLayoutInRecent(sceneContainerSession: SCBSceneContainerSession, reason: string,
    buildSceneContainer: boolean = true): void {
    if (!sceneContainerSession || !sceneContainerSession.primarySession) {
      return;
    }
    const recentSessionInfo = this.currentRecentSessionInfo.find(
      (element) => element.sessionId === sceneContainerSession.primarySession?.session.persistentId);
    if (recentSessionInfo) {
      const sceneContainerWidth = sceneContainerSession.getSceneContainerWidth();
      const sceneContainerHeight = sceneContainerSession.getSceneContainerHeight();
      const sceneContainerPostion = sceneContainerSession.getSceneContainerPosition();
      const scale = SCBRecentCardViewModel.getSceneContainerRecentScale(sceneContainerSession,
        recentSessionInfo.height);
      const newX = sceneContainerWidth * (1 - scale) / 2 + sceneContainerPostion.x;
      const newY = sceneContainerHeight * (1 - scale) / 2 + sceneContainerPostion.y;
      const dx = recentSessionInfo.left - newX + this.calculateRecentLongCardOffSetX(sceneContainerWidth, scale);
      const dy = recentSessionInfo.top - newY + this.calculateRecentLongCardOffSetY(sceneContainerHeight, scale,
        recentSessionInfo.isUpDownSplit && recentSessionInfo.isSplitRecentPair);
      // make background window visible in recent
      if (buildSceneContainer) {
        SCBRecentCardViewModel.setShowInRecent(sceneContainerSession);
      }
      // set no shadow in window for min width
      this.recentMinBackground.enterRecentWithoutAnimate(sceneContainerSession, recentSessionInfo);
      this.setRecentTranslateNoAnimate(sceneContainerSession, scale);
      SCBRecentCardViewModel.setSceneContainerBorderRadius(sceneContainerSession, scale, this.singleContext);
      SCBRecentCardViewModel.setSceneTranslate(sceneContainerSession, dx, dy);
      SCBRecentCardViewModel.setSceneScale(sceneContainerSession, scale);
      SCBRecentCardViewModel.setSceneOpacity(sceneContainerSession, 1);
      SCBRecentCardViewModel.setSceneAttraction(sceneContainerSession, 0);
      SCBRecentTitleViewModel.setRecentTitleWidth(sceneContainerSession, scale);
      SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, recentSessionInfo.left, recentSessionInfo.top);
      SCBRecentCover.layoutRecentCover(sceneContainerSession, recentSessionInfo.left,
        recentSessionInfo.top);
      if (sceneContainerSession.dividerParam.isSplitRecentPair) {
        this.calculateSplitRecentCardOffSetXForPair(sceneContainerSession, scale);
        this.calculateSplitRecentCardInfoForPair(sceneContainerSession, recentSessionInfo);
      }
    }
  }

  // 将动效拆分成多段，相同行的是一组
  private splitSessionListByRowNum(sceneContainerSessionList: SCBSceneContainerSession[]):
    SCBSceneContainerSession[][] {
    let acc = new Map<number, SCBSceneContainerSession[]>();
    sceneContainerSessionList.forEach((sceneContainerSession: SCBSceneContainerSession) => {
      const recentSessionInfo = this.currentRecentSessionInfo.find(
        (element) => element.sessionId === sceneContainerSession.primarySession?.session.persistentId);

      if (recentSessionInfo) {
        // 如果当前 rowNum 还没有对应的子数组，则创建一个新的子数组
        if (!acc.has(recentSessionInfo.rowNum)) {
          acc.set(recentSessionInfo.rowNum, []);
        }
        // 将当前元素添加到对应的子数组中
        acc.get(recentSessionInfo.rowNum)?.push(sceneContainerSession);
      }
    })
    // 将结果转换为二维数组
    const finalResult: SCBSceneContainerSession[][] = Array.from(acc.values());
    return finalResult;
  }

  private bgWindowsToRecentVisiableWithAnimation(sceneContainerSessionList: SCBSceneContainerSession[],
    onFinishCallback: Function = () => {}): void {
    this.getUIContext()?.animateToImmediately({
      duration: 0,
    }, () => {
      sceneContainerSessionList.forEach((sceneContainerSession) => {
        this.calcContainerLayoutInRecent(sceneContainerSession, 'bgWindowsToRecentVisiableWithAnimation');
        sceneContainerSession.needRenderAlpha.setNeedRenderAlpha(0);
        sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
        SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
      });
    });

    this.getUIContext()?.animateToImmediately({
      duration: 100,
      curve: Curve.Sharp,
      onFinish: () => {
        if (this.isEnterRecentView) {
          this.recentEnter.groupAnimationRefDec();
          if (this.recentEnter.groupAnimationRefZero()) {
            onFinishCallback();
          }
        }
      }
    }, () => {
      this.recentEnter.groupAnimationRefAdd();
      this.windowToRecentChainAlpha(sceneContainerSessionList);
    });
  }

  private bgWindowsToRecentInvisiableWithoutAnimation(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      this.calcContainerLayoutInRecent(sceneContainerSession, 'bgWindowsToRecentInvisiableWithoutAnimation');
      SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
    });
  }

  private resetRecentEnterDelayAnimateTimer(): void {
    this.recentEnterDelayAnimateTimer = -1;
  }

  private startRecentEnterDelayAnimateTimer(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    if (this.recentEnterDelayAnimateTimer !== -1) {
      recentLog.showInfo('recentEnterDelayAnimateTimer is running, stop it first now.');
      this.stopRecentEnterDelayAnimateTimer();
    }
    recentLog.showInfo('start recentEnterDelayAnimateTimer right now.');
    this.recentEnterDelayAnimateTimer = setTimeout(() => {
      sceneContainerSessionList.forEach((sceneContainerSession) => {
        this.calcContainerLayoutInRecent(sceneContainerSession, 'handleWindowToRecentDelay');
        SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
      });
      this.resetRecentEnterDelayAnimateTimer();
      // 50ms保证在此期间主线程必然收到一个vsync
    }, 50);
  }

  private stopRecentEnterDelayAnimateTimer(): void {
    if (this.recentEnterDelayAnimateTimer === -1) {
      return;
    }
    recentLog.showInfo('stop recentEnterDelayAnimateTimer right now.');
    clearTimeout(this.recentEnterDelayAnimateTimer);
    this.resetRecentEnterDelayAnimateTimer();
  }

  private handleInvisibleWindowsInRecentOpacityToZero(sceneContainerSessionList: SCBSceneContainerSession[]) {
    // 延时加载的卡片，透明度先显示为0
    this.setInvisibleWindowsInRecentOpacityToZero(sceneContainerSessionList);
  }

  private handleWindowToRecentDelay(sceneContainerSessionList: SCBSceneContainerSession[]) {
    if (sceneContainerSessionList.length === 0) {
      return;
    }
    const result: SCBSceneContainerSession[][] = this.splitSessionListByRowNum(sceneContainerSessionList);
    result.forEach((sceneContainerSessionList: SCBSceneContainerSession[], index: number) => {
      // duration如果为0，则delay不生效。delay是为了保证完全分批加载，否则一帧内有概率同时处理两批
      this.getUIContext()?.animateToImmediately({
        duration: INVISIBLEWINDOW_DURATION_TIME,
        delay: index * INVISIBLEWINDOW_DELAY_TIME,
      }, () => {
        sceneContainerSessionList.forEach((sceneContainerSession: SCBSceneContainerSession) => {
          this.calcContainerLayoutInRecent(sceneContainerSession, 'handleWindowToRecentDelay');
          SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
        });
      });
    });
  }

  private fgWindowToRecentVisibleAnimationEvent(sceneContainerSessionList: SCBSceneContainerSession[]) {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      if (!sceneContainerSession.primarySession) {
        return;
      }
      const recentSessionInfo = this.currentRecentSessionInfo.find(
        (element) => element.sessionId === sceneContainerSession.primarySession?.session.persistentId);
      if (recentSessionInfo) {
        SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_STARTED);
        this.windowToRecentDefaultAnimateInner(sceneContainerSession, recentSessionInfo);
      }
    });
  }

  private windowToRecentDefaultAnimateInner(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo) {
    const reason = sceneContainerSession.getName();
    const sceneContainerPosition = sceneContainerSession.getSceneContainerPosition();
    const sceneContainerWidth = sceneContainerSession.getSceneContainerWidth();
    const sceneContainerHeight = sceneContainerSession.getSceneContainerHeight();
    const scale = SCBRecentCardViewModel.getSceneContainerRecentScale(sceneContainerSession, recentSessionInfo.height);

    const newX = sceneContainerWidth * (1 - scale) / 2 + sceneContainerPosition.x;
    const newY = sceneContainerHeight * (1 - scale) / 2 + sceneContainerPosition.y;
    const dx = recentSessionInfo.left - newX + this.calculateRecentLongCardOffSetX(sceneContainerWidth, scale);
    const dy = recentSessionInfo.top - newY + this.calculateRecentLongCardOffSetY(sceneContainerHeight, scale,
      recentSessionInfo.isUpDownSplit && recentSessionInfo.isSplitRecentPair);
    SCBRecentCardViewModel.setSceneTranslate(sceneContainerSession, dx, dy);
    SCBRecentCardViewModel.setSceneScale(sceneContainerSession, scale);
    SCBRecentCardViewModel.setSceneOpacity(sceneContainerSession, 1.0);
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'windowToRecentDefault', reason);
    SCBRecentCardViewModel.setSceneContainerBorderRadius(sceneContainerSession, scale, this.singleContext);
    SCBRecentHoverViewModel.hideRecentHover(sceneContainerSession);
    SCBRecentTitleViewModel.buildRecentTitle(sceneContainerSession);
    sceneContainerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'windowToRecentDefault', reason);
    sceneContainerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'windowToRecentDefault', reason);
    SCBRecentCover.layoutRecentCover(sceneContainerSession, recentSessionInfo.left,
      recentSessionInfo.top);
    this.recentMinBackground.enterRecentAnimateEvent(sceneContainerSession, recentSessionInfo);
    SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, recentSessionInfo.left, recentSessionInfo.top);

    if (sceneContainerSession.dividerParam.isSplitRecentPair) {
      this.calculateSplitRecentCardOffSetXForPair(sceneContainerSession, scale);
      this.calculateSplitRecentCardInfoForPair(sceneContainerSession, recentSessionInfo);
    }
  }

  private fgWindowToRecentVisibleAnimation(sceneContainerSessionList: SCBSceneContainerSession[]) {
    if (sceneContainerSessionList.length === 0) {
      systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_MISSION_CENTER);
      return;
    }
    this.preFgWindowToRecentVisibleAnimation(sceneContainerSessionList);
    this.fgWindowToRecentVisibleCardAnimation(sceneContainerSessionList);
    this.fgWindowToRecentVisibleTitleAnimation(sceneContainerSessionList);
  }

  private fgWindowToRecentVisibleCardAnimation(sceneContainerSessionList: SCBSceneContainerSession[]) {
    this.getUIContext()?.animateToImmediately({
      curve: curves.interpolatingSpring(0, 1, 440, 38),
      onFinish: () => {
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_MISSION_CENTER);
        if (this.scenePanelState !== ScenePanelState.SPLIT) {
          systemAniSceneCtrl.enqueue(SystemAnimatedScene.APPEAR_MISSION_CENTER)
        }
        // 如果isEnterRecentView是true，等动效计数结束后取消投票，如果为false，动效被打断，直接取消投票
        if (this.isEnterRecentView) {
          sceneContainerSessionList.forEach((sceneContainerSession) => {
            SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
          });
          this.recentEnter.groupAnimationRefDec();
          if (this.recentEnter.groupAnimationRefZero()) {
            this.bgWindowsToRecentInvisiableWithoutAnimation(this.noAnimateContainerSessionList);
            this.recordWindowToRecentFinish();
            this.recentState.onEnterRecentAllAnimateFinish();
            this.resetSessionList();
          }
        } else {
          this.disableAps();
        }
      }
    }, () => {
      this.recentEnter.groupAnimationRefAdd();
      this.fgWindowToRecentVisibleAnimationEvent(sceneContainerSessionList);
    });
  }

  private fgWindowToRecentVisibleTitleAnimation(sceneContainerSessionList: SCBSceneContainerSession[]) {
    this.getUIContext()?.animateToImmediately({
      curve: curves.interpolatingSpring(0, 1, 350, 31)
    }, () => {
      sceneContainerSessionList.forEach((sceneContainerSession) => {
        SCBRecentTitleViewModel.showRecentTitle(sceneContainerSession);
      })
    });
  }

  /**
   * getContainerSessionShowRect 场景：前台应用进多任务时，兼容模式应用需要将实际大小转换为显示大小
   *
   * @param sceneContainerSession
   * @param sceneSession
   */
  private getContainerSessionShowRect(sceneContainerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession): SCBSessionRect {
    const sceneContainerHeight = sceneContainerSession.getSceneContainerHeight();
    const sceneContainerWidth = sceneContainerSession.getSceneContainerWidth();
    let newRect = new SCBSessionRect(sceneSession.currRect.left.getPx(), sceneSession.currRect.top.getPx(),
      vp2px(sceneContainerWidth), vp2px(sceneContainerHeight));
    return newRect;
  }

  private preFgWindowToRecentVisibleAnimation(sceneContainerSessionList: SCBSceneContainerSession[]) {
    this.getUIContext()?.animateToImmediately({
      duration: 0
    }, () => {
      sceneContainerSessionList.forEach((sceneContainerSession) => {
        if (!sceneContainerSession.primarySession) {
          return;
        }
        const recentSessionInfo = this.currentRecentSessionInfo.find(
          (element) => element.sessionId == sceneContainerSession.primarySession?.session.persistentId);
        if (recentSessionInfo) {
          let sceneSession = sceneContainerSession.getMainSceneSession();
          if (!sceneSession) {
            return;
          }
          const newRect = this.getContainerSessionShowRect(sceneContainerSession, sceneSession);
          const offsetX = newRect.width.getVp() * (1 - sceneSession.scaleX) / 2 + sceneSession.translateX;
          const offsetY = newRect.height.getVp() * (1 - sceneSession.scaleY) / 2 + sceneSession.translateY;
          const translateX = newRect.left.getVp() + offsetX;
          const translateY = newRect.top.getVp() + offsetY;
          const scale = SCBRecentCardViewModel.getSceneContainerRecentScale(sceneContainerSession,
            recentSessionInfo.height);
          // make background window visible in recent
          let name = sceneContainerSession.getName();
          if (sceneContainerSession.isBackground()) {
            SCBRecentTitleViewModel.buildRecentTitle(sceneContainerSession);
            sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG,
              'preFgWindowToRecentVisibleAnimation', name);
          }
          SCBRecentCardViewModel.setShowInRecent(sceneContainerSession);
          SCBRecentCover.layoutRecentCover(sceneContainerSession, translateX, translateY);
          // recent title
          SCBRecentTitleViewModel.setRecentTitleWidth(sceneContainerSession, scale);
          SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, translateX, translateY);
          SCBRecentTitleViewModel.hideRecentTitle(sceneContainerSession);

          this.recentMinBackground.enterRecentAnimatePrepare(sceneContainerSession, recentSessionInfo);
          SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_START);
        }
      });
    });
  }

  private recordWindowToRecentFinish(): void {
    performanceMonitor.end(HiSysEventUtil.PC_GESTURE_TO_RECENT);
    performanceMonitor.end(HiSysEventUtil.PC_INTO_RECENT);
    performanceMonitor.end(HiSysEventUtil.PC_SHORTCUT_TO_RECENT);
    performanceMonitor.end(HiSysEventUtil.PC_ALT_TAB_TO_RECENT);
    this.disableAps();
    recentLog.showInfo('PC_INO_RECENT FINISH');
  }

  private windowToRecentChainAlpha(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      sceneContainerSession.needRenderAlpha.setNeedRenderAlpha(1.0);
      SCBRecentTitleViewModel.showRecentTitle(sceneContainerSession);
    });
  }

  private getSplitRecentTitleWidthForPair(sceneSession: SCBSceneSession | null, scale: number): number {
    if (!sceneSession) {
      return 0;
    }
    let recentTitleWidth = sceneSession.currRect.width.getVp() * scale;
    return Math.max(recentTitleWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
  }

  private getRecentCoverWidth(sceneContainerWidth: number, scale: number): number {
    let coverWidth: number = sceneContainerWidth * scale;
    return Math.max(coverWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
  }

  private getRecentCoverHeight(sceneContainerHeight: number, scale: number): number {
    let cardHeight = sceneContainerHeight * scale;
    let cardMinHeight = SCBRecentSessionsViewModel.getInstance(this.singleContext).getRecentCardMinHeight();
    cardHeight = Math.max(cardHeight, cardMinHeight);
    return cardHeight + SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
      SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
  }

  private calculateRecentLongCardOffSetX(sceneContainerWidth: number, newScale: number): number {
    let offsetX: number = 0;
    let scaledWidth = sceneContainerWidth * newScale;
    if (scaledWidth < SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH) {
      offsetX = (SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH - scaledWidth) / 2;
    }
    return offsetX;
  }

  private calculateRecentLongCardOffSetY(sceneContainerHeight: number, newScale: number,
    isUpDownSplit: boolean): number {
    let offsetY: number = 0;
    let scaledHeight = sceneContainerHeight * newScale;
    if (isUpDownSplit) {
      scaledHeight += SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE;
    }
    let minSceneHeight = SCBRecentSessionsViewModel.getInstance(this.singleContext).getRecentCardMinHeight();
    if (scaledHeight < minSceneHeight) {
      offsetY = (minSceneHeight - scaledHeight) / 2;
    }
    return offsetY;
  }

  private calculateSplitRecentCardOffSetXForPair(sceneContainerSession: SCBSceneContainerSession, scale: number): void {
    if (!sceneContainerSession || !sceneContainerSession.primarySession || !sceneContainerSession.secondarySession) {
      return;
    }
    const primaryWidth = sceneContainerSession.primarySession.currRect.width.getVp();
    const secondaryWidth = sceneContainerSession.secondarySession.currRect.width.getVp();
    const primaryOffsetX = this.calculateRecentLongCardOffSetX(primaryWidth, scale);
    const secondaryOffsetX = this.calculateRecentLongCardOffSetX(secondaryWidth, scale);
    if (sceneContainerSession.isSplitPrimaryMode()) {
      sceneContainerSession.primarySession.translateOffsetX = primaryOffsetX;
      sceneContainerSession.secondarySession.translateOffsetX = primaryOffsetX * 2 + secondaryOffsetX;
    } else if (sceneContainerSession.isSplitSecondaryMode()) {
      sceneContainerSession.secondarySession.translateOffsetX = secondaryOffsetX;
      sceneContainerSession.primarySession.translateOffsetX = secondaryOffsetX * 2 + primaryOffsetX;
    }
  }

  private calculateSplitRecentCardInfoForPair(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo) {
    if (sceneContainerSession.primarySession && sceneContainerSession.secondarySession) {
      sceneContainerSession.primarySession.hoverState = false;
      sceneContainerSession.secondarySession.hoverState = false;
      let priSession = sceneContainerSession.isSplitPrimaryMode() ? sceneContainerSession.primarySession :
      sceneContainerSession.secondarySession;
      let secSession = sceneContainerSession.isSplitPrimaryMode() ? sceneContainerSession.secondarySession :
      sceneContainerSession.primarySession;
      if (sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
        let primaryHeight = priSession.currRect.height.getVp() * priSession.scaleY;
        sceneContainerSession.needRenderRecentCoverTranslate.secondaryTranslateX = recentSessionInfo.left;
        sceneContainerSession.needRenderRecentTitleTranslate.secondaryTranslateX = recentSessionInfo.left +
        sceneContainerSession.needRenderRecentTitleWidth.primaryWidth;
        sceneContainerSession.needRenderRecentCoverTranslate.secondaryTranslateY = recentSessionInfo.top +
          primaryHeight + DividerStyle.DIVIDER_WIDTH * sceneContainerSession.needRenderScale.scaleY +
        SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE;
        sceneContainerSession.needRenderRecentTitleTranslate.secondaryTranslateY =
          sceneContainerSession.needRenderRecentTitleTranslate.translateY;
      } else {
        let primaryWidth = priSession.currRect.width.getVp() * priSession.scaleX;
        primaryWidth = Math.max(primaryWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
        sceneContainerSession.needRenderRecentCoverTranslate.secondaryTranslateX = recentSessionInfo.left +
          primaryWidth + SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE + SCBRecentStyleConstants.SESSION_OUTER_SIZE;
        sceneContainerSession.needRenderRecentTitleTranslate.secondaryTranslateX =
          sceneContainerSession.needRenderRecentCoverTranslate.secondaryTranslateX;
        sceneContainerSession.needRenderRecentCoverTranslate.secondaryTranslateY =
          sceneContainerSession.needRenderRecentCoverTranslate.translateY;
      }
      sceneContainerSession.needRenderRecentTitleTranslate.secondaryTranslateY =
        sceneContainerSession.needRenderRecentTitleTranslate.translateY;
    }
  }

  private updateStackHeight(): void {
    const recentSessionLength = this.currentRecentSessionInfo.length;
    if (recentSessionLength <= 0) {
      this.scrollStackHeight = this.screenHeight;
      return;
    }
    const lastCard: SCBRecentSessionInfo = this.currentRecentSessionInfo[recentSessionLength - 1];
    const recentStyle: SCBRecentStyle = this.recentStyleManager.getStyle();
    const marginBottom = this.mRecentSessionsViewModel.getMarginBottom();
    let needHeight: number = lastCard.top + marginBottom + (lastCard.height ?? 0);
    // 加上分屏场景偏移量（悬停态）
    needHeight += this.screenHeight - this.mRecentSessionsViewModel.getCurrentShowHeight() -
      this.mRecentSessionsViewModel.getSplitOffsetY();
    if (this.isRecentState()) {
      needHeight += LayoutViewModel.getInstance(this.singleContext).getDockHeight();
    }
    this.scrollStackHeight = Math.max(this.screenHeight, needHeight);
    this.updateScrollBar();
  }

  private exitSplitRecentView(isAnimateImmediately: boolean = true, isPairSplit: boolean = false): void {
    this.handleExitRecentAnimation(isAnimateImmediately, isPairSplit);
    this.recordExitRecentLog();
  }

  private exitAppCenterView(): void {
    if (RecentAndAppCenterSwitchManager.getInstance().getRecentToAppCenter()) {
      return;
    }
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_MISSION_CENTER);
    this.closeMenuAndPopup();
    const hideAppCenterWithAnimation = (GlobalContext.getInstance()
      .getObject('hideAppCenterWithAnimation')) as Function;
    hideAppCenterWithAnimation();
    log.showInfo(`exitAppCenterView`);
    this.updateScenePanelState(ScenePanelState.HOME);
  }

  private exitRecentView(isAnim: boolean = true, onAnimationFinish?: () => void): void {
    this.recentState.onExitRecentStart();
    this.recordExitRecentLog();
    this.containerSessionList.forEach((sceneContainer: SCBSceneContainerSession) => {
      if (sceneContainer.isActive && !sceneContainer.needRenderVisibility.visibility) {
        sceneContainer.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'recoverVisibilityExitRecent',
          sceneContainer.getName());
      }
    });
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_MISSION_CENTER);
    this.mRecentSessionsViewModel.setScrollYOffset(0);
    SCBSceneSessionManager.getInstance().notifyExitRecentForFloat();
    this.resetSelectedIndex();
    SCBRecentDelete.restoreAllSessionMoveUpAnimate(this.containerSessionList, this.currentRecentSessionInfo);
    this.stopRecentEnterDelayAnimateTimer();
    this.handleExitRecentAnimation(true, false, isAnim, onAnimationFinish);
    this.updateScenePanelState(ScenePanelState.HOME);
    this.recentEnter.switchOutFocus(this.sysSceneSession, this.containerSessionList);
    AppStorage.setOrCreate('altTabKeyEvent', false);
    RecentAndAppCenterSwitchManager.getInstance().setOneFrameVisible(this.screenProperty.screenId, false);
  }

  /**
   * 将预关闭窗口从notShowContainerSessionList移到ContainerSessionList
   */
  private restorePrepareContainer(): void {
    if (!this.recentPreparePersistentIds || this.recentPreparePersistentIds.length === 0) {
      recentLog.showInfo('restorePrepareContainer empty');
      return;
    }
    recentLog.showInfo(`restorePrepareContainer ${this.recentPreparePersistentIds.join(',')}`);
    this.recentPreparePersistentIds.forEach((persistentId) => {
      let index = this.containerSessionListNotShowRecent.findIndex((item) => {
        return item.primarySession?.session.persistentId === persistentId ||
          item.secondarySession?.session.persistentId === persistentId;
      });
      if (index === -1) {
        return;
      }
      const container = this.containerSessionListNotShowRecent[index];
      if (this.recentPrepareManager.isHideContainerSession(container)) {
        return;
      }
      recentLog.showInfo(`restorePrepareContainer notShow to show ${container.getName()}`);
      this.removeSceneContainerSessionNotShowRecent(container);
      this.addSceneContainerSession(container);
    });
    this.setRecentDataList(false);
    this.recentPreparePersistentIds = [];
  }

  private recordExitRecentLog(): void {
    TraceUtil.traceOnce(DomainName.RECENT, TraceUtil.CORE_METHOD_EXIT_RECENT);
    recentLog.showInfo('%{public}s. screenId: %{public}d exit recent to home', TraceUtil.CORE_METHOD_EXIT_RECENT,
      this.screenProperty.screenId);
  }

  private handleExitRecentAnimation(isAnimateImmediately: boolean = true, isPairSplit: boolean = false,
    isAnim: boolean = true, onAnimationFinish?: () => void): void {
    this.recentState.onExitRecentAllAnimateStart();
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    performanceMonitor.begin(HiSysEventUtil.PC_EXIT_RECENT, performanceMonitor.ActionType.LAST_UP);
    this.recordExitRecentAnimationStartLogs();
    this.recoverRecentWindowEffect();
    this.closeMenuAndPopup();
    const len = this.containerSessionList.length;
    if (len !== 0) {
      AppStorage.setOrCreate('isRecentCardAnimating', true);
    }
    this.resetSessionList();

    this.isEnterRecentView = false;
    this.onNoAniBlurTransitionInactive();
    this.doExitAnimationNoAnimate();
    this.recentNotShowViewModel.showNotShowInRecentScene(this.containerSessionList);
    this.recentState.onExitRecentAllAnimateFinish();

    this.containerSessionList.forEach((container) => {
      container.resetShowRecent();
    });
    if (!isPairSplit) {
      this.scroll.scrollTo({
        xOffset: 0,
        yOffset: 0
      });
    }
    this.scrollStackHeight = this.screenHeight;
    this.isEnterRecentView = false;
    this.showRecentEmptyView = false;
    this.isNeedClip = false;
    this.unregisterKeyInRecent();
    this.recordExitRecentAnimationEndLogs();
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    if (isAnim) {
      this.recentState.onExitRecentAllAnimateStarted();
    }
    this.restorePrepareContainer();
    this.recentPrepareManager.clearHideContainerSession();
  }

  private recordExitRecentAnimationStartLogs(): void {
    TraceUtil.startAnimTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_EXIT_RECENT_ANIMATION);
    recentLog.showInfo('start %{public}s, screenId: %{public}d', TraceUtil.CORE_METHOD_EXIT_RECENT_ANIMATION,
      this.screenProperty.screenId);
  }

  private recordExitRecentAnimationEndLogs(): void {
    TraceUtil.endAnimTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_EXIT_RECENT_ANIMATION);
    recentLog.showInfo('end %{public}s, screenId: %{public}d', TraceUtil.CORE_METHOD_EXIT_RECENT_ANIMATION,
      this.screenProperty.screenId);
  }

  private immediatelyDetachFromFrameNode(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      SCBRecentCardViewModel.resetShowInRecent(sceneContainerSession);
    });
    this.getUIContext()?.animateTo({}, () => {});
  }

  /**
   * getSceneContainerPosition 场景：退出多任务到前台时，获取窗口显示位置
   *
   * @param sceneContainerSession
   * @param sceneSession
   */
  private getSceneContainerPosition(containerSession: SCBSceneContainerSession): ArkPosition {
    let positionValue = containerSession.getSceneContainerPosition();
    let sceneSession = containerSession.getMainSceneSession();
    if (!sceneSession) {
      return positionValue;
    }
    return positionValue;
  }

  private recentToWindowDefaultNoAnimate(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    this.recentToWindowDefaultImmediatelyInner(sceneContainerSessionList);
    if (!this.isEnterRecentView) {
      performanceMonitor.end(HiSysEventUtil.PC_EXIT_RECENT);
      this.immediatelyDetachFromFrameNode(sceneContainerSessionList);
      sceneContainerSessionList.forEach((sceneContainerSession) => {
        SCBRecentTitleViewModel.destroyRecentTitle(sceneContainerSession);
        SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.EXIT_RECENT_ANIMATE_FINISH);
      });
    }
    AppStorage.setOrCreate('isRecentCardAnimating', false);
    systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_MISSION_CENTER);
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      SCBRecentTitleViewModel.hideRecentTitle(sceneContainerSession);
    });
  }

  private recentToWindowDefaultImmediatelyInner(sceneContainerSessionList: SCBSceneContainerSession[]) {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      if (!sceneContainerSession.primarySession) {
        return;
      }
      let recentSessionInfo = this.currentRecentSessionInfo.find(
        (element) => element.sessionId == sceneContainerSession.primarySession?.session.persistentId);
      if (!recentSessionInfo) {
        return;
      }
      let sceneSession = sceneContainerSession.getMainSceneSession();
      if (!sceneSession) {
        return;
      }
      this.recoverOrMaximizeIfLastSplit(sceneContainerSession);
      const sceneContainerPosition = this.getSceneContainerPosition(sceneContainerSession);
      SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, sceneContainerPosition.x,
        sceneContainerPosition.y);
      let name = sceneContainerSession.getName();
      sceneContainerSession.needRenderRecentSceneBorderRadius.borderRadius = 0;
      sceneContainerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'recentToWindowDefaultImmediatelyInner', name);
      sceneContainerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'recentToWindowDefaultImmediatelyInner', name);
      this.recentMinBackground.setMinBackgroundSizeWhenExitRecentToFg(sceneContainerSession, recentSessionInfo);
      this.recentMinBackground.setMinBackgroundAlpha(sceneContainerSession, 0);
      SCBRecentCardViewModel.setSceneTranslate(sceneContainerSession, 0, 0);
      SCBRecentCardViewModel.setSceneScale(sceneContainerSession, 1);
      SCBRecentCardViewModel.setSceneOpacity(sceneContainerSession, 1);
      if (this.recentMinBackground.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
        SCBRecentCardViewModel.showSceneShadow(sceneContainerSession);
        SCBRecentCardViewModel.showSceneStroke(sceneContainerSession);
      }
      this.resetSpecificSceneTransition(sceneContainerSession);
      this.setSpecificSceneOpacity(sceneContainerSession, 1);
      SCBRecentHoverViewModel.hideRecentHover(sceneContainerSession);
      SCBRecentCover.layoutRecentCover(sceneContainerSession, sceneContainerPosition.x,
        sceneContainerPosition.y);
      SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.EXIT_RECENT_ANIMATE_STARTED);
    });
  }

  private handleRecentToWindowNoAnimate(sceneContainerSessionList: SCBSceneContainerSession[]) {
    if (sceneContainerSessionList.length === 0) {
      return;
    }
    this.immediatelyDetachFromFrameNode(sceneContainerSessionList);
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      if (!sceneContainerSession.primarySession) {
        return;
      }
      let recentSessionInfo = this.currentRecentSessionInfo.find(
        (element) => element.sessionId == sceneContainerSession.primarySession?.session.persistentId);
      if (!recentSessionInfo) {
        return;
      }
      const sceneContainerPosition = sceneContainerSession.getSceneContainerPosition();
      if (sceneContainerSession.primarySession) {
        sceneContainerSession.primarySession.isHideShadow = false;
      }
      SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, sceneContainerPosition.x,
        sceneContainerPosition.y);
      sceneContainerSession.needRenderRecentSceneBorderRadius.borderRadius = 0;
      let name = sceneContainerSession.getName();
      sceneContainerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'handleRecentToWindowNoAnimate', name);
      sceneContainerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'handleRecentToWindowNoAnimate', name);
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'handleRecentToWindowNoAnimate', name);
      SCBRecentTitleViewModel.hideRecentTitle(sceneContainerSession);
      SCBRecentTitleViewModel.destroyRecentTitle(sceneContainerSession);
      this.recentMinBackground.exitRecentWithoutAnimate(sceneContainerSession, recentSessionInfo);
      SCBRecentCardViewModel.setSceneTranslate(sceneContainerSession, 0, 0);
      SCBRecentCardViewModel.setSceneScale(sceneContainerSession, 1);
      SCBRecentCardViewModel.setSceneOpacity(sceneContainerSession, 1);
      SCBRecentHoverViewModel.hideRecentHover(sceneContainerSession);
      SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.EXIT_RECENT_ANIMATE_FINISH);
    });
  }

  private onBlurTransitionActive(): void {
    CloneWallpaperMgr.getInstance(this.screenProperty.screenId).updateZIndex(SCBDefaultZIndex.SCENE_PANEL - 1);
    CloneWallpaperMgr.getInstance(this.screenProperty.screenId).show();
  }

  private onNoAniBlurTransitionInactive(): void {
    if (RecentAndAppCenterSwitchManager.getInstance().appcenterIsShowing(this.screenProperty.screenId)) {
      log.showWarn('app center is showing, return');
      return;
    }
    CloneWallpaperMgr.getInstance(this.screenProperty.screenId).hide();
    CloneWallpaperMgr.getInstance(this.screenProperty.screenId).hideFinish();
  }

  private onBlurTransitionInactive(onAnimationFinish?: () => void): void {
    this.blurTransitioning = true;
    log.showInfo('onBlurTransitionInactive');
    this.getUIContext()?.animateToImmediately({
      duration: this.recentAnimation.recentExitBackgroundDuration,
      curve: this.recentAnimation.recentExitBackgroundAnimationCurve,
      onFinish: () => {
        this.blurTransitioning = false;
        if (!this.isRecentOrSplitState()) {
          if (!RecentAndAppCenterSwitchManager.getInstance().appcenterIsShowing(this.screenProperty.screenId)) {
            CloneWallpaperMgr.getInstance(this.screenProperty.screenId).hideFinish();
          }
        }
        this.recentExit.groupAnimationRefDec();
        if (this.recentExit.groupAnimationRefZero()) {
          this.resetSessionList();
          this.recentState.onExitRecentAllAnimateFinish();
          this.recentSubSceneViewModel.buildSubScenesBatch(this.containerSessionList);
        }
        onAnimationFinish?.();
      },
    }, () => {
      this.recentExit.groupAnimationRefAdd();
      if (!RecentAndAppCenterSwitchManager.getInstance().appcenterIsShowing(this.screenProperty.screenId)) {
        CloneWallpaperMgr.getInstance(this.screenProperty.screenId).hide();
      }
    });
  }

  private onContainerExitSplit(): void {
    log.showInfo('onContainerExitSplit: ' + this.isExitSplit)
    if (this.isExitSplit) {
      const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      if (curActiveContainerSession?.isSplit) {
        let param = new ExitSplitParam();
        if (curActiveContainerSession.primarySession?.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN) {
          param.exitSplitEvent = SCBSessionEventId.EVENT_MAXIMIZE;
        }
        const persistentId = curActiveContainerSession.getPersistentId();
        this.exitSplitView(persistentId, param);
      }
    }
    this.isExitSplit = false;
  }

  private updateRecentInfoAfterExitForUpDownSplit(newContainerSession: SCBSceneContainerSession,
    currContainerSession: SCBSceneContainerSession, sceneSession: SCBSceneSession,
    exitSession: SCBSceneSession | null, isEnterPair: boolean = false): void {
    let recentSessionInfo = this.currentRecentSessionInfo.find(
      (element) => element.sessionId === sceneSession.sceneInfo.persistentId ||
        element.sessionId === exitSession?.sceneInfo.persistentId);
    if (recentSessionInfo) {
      SCBRecentTitleViewModel.setRecentTitlePos(newContainerSession, recentSessionInfo.left, recentSessionInfo.top);
      newContainerSession.needRenderRecentTitleWidth.width = recentSessionInfo.width;
    }
    SCBRecentSessionHelper.setState(newContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
    newContainerSession.needRenderShowInRecent
      .setShowInRecentWithDfx(true, TAG, 'exitSplit', newContainerSession.getName());
    newContainerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
    newContainerSession.needRenderAlpha.setNeedRenderAlpha(1);
    newContainerSession.dividerParam.setSplitStyle(SplitStyle.UNDEFINED);
    currContainerSession.dividerParam.setSplitStyle(SplitStyle.UNDEFINED);
    newContainerSession.dividerParam.isSplitRecentPair = false;
    SCBRecentTitleViewModel.showRecentTitle(newContainerSession);
    newContainerSession.needRenderRecentMinBackgroundShow.primarySessionShow =
      currContainerSession.needRenderRecentMinBackgroundShow.primarySessionShow;
    newContainerSession.needRenderRecentMinBackgroundShow.secondSessionShow =
      currContainerSession.needRenderRecentMinBackgroundShow.secondSessionShow;
    let priTranslate = (exitSession?.currRect.height.getVp() as number + DividerStyle.DIVIDER_WIDTH) *
      (1 - sceneSession.scaleY) / 2;
    let secTranslate = (sceneSession?.currRect.height.getVp() as number + DividerStyle.DIVIDER_WIDTH) *
      (1 - sceneSession.scaleY) / 2;
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
      priTranslate = - priTranslate;
      secTranslate = - secTranslate;
      sceneSession.translateY += SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE;
    }
    sceneSession.translateY += priTranslate;
    if (exitSession && !isEnterPair) {
      exitSession.translateY -= secTranslate;
    }
  }

  private updaterRecentCoverTranslate(newSceneContainerSession: SCBSceneContainerSession,
                                      currContainerSession: SCBSceneContainerSession, windowMode: number) : void {
    if (!newSceneContainerSession || !currContainerSession) {
      return;
    }
    if (windowMode === SCBSceneMode.PRIMARY) {
      newSceneContainerSession.needRenderRecentTitleWidth.width =
        currContainerSession.needRenderRecentTitleWidth.primaryWidth;
      newSceneContainerSession.needRenderRecentCoverTranslate.translateX =
        currContainerSession.needRenderRecentCoverTranslate.translateX;
      newSceneContainerSession.needRenderRecentCoverTranslate.translateY =
        currContainerSession.needRenderRecentCoverTranslate.translateY;
    }
    if (windowMode === SCBSceneMode.SECONDARY) {
      newSceneContainerSession.needRenderRecentTitleWidth.width =
        currContainerSession.needRenderRecentTitleWidth.secondaryWidth;
      newSceneContainerSession.needRenderRecentCoverTranslate.translateX =
        currContainerSession.needRenderRecentCoverTranslate.secondaryTranslateX;
      newSceneContainerSession.needRenderRecentCoverTranslate.translateY =
        currContainerSession.needRenderRecentCoverTranslate.secondaryTranslateY;
    }
  }

  private updateRecentInfoAfterExitForSplit(newSceneContainerSession: SCBSceneContainerSession,
                                            currContainerSession: SCBSceneContainerSession,
                                            primarySession: SCBSceneSession,
                                            secondarySession: SCBSceneSession | null,
                                            isEnterPair: boolean = false): void {
    if (currContainerSession.dividerParam.isExpandUpDownSplit()) {
      this.updateRecentInfoAfterExitForUpDownSplit(newSceneContainerSession, currContainerSession, primarySession,
        secondarySession, isEnterPair);
      return;
    }
    let recentSessionInfo = this.currentRecentSessionInfo.find(
      (element) => element.sessionId === primarySession.session.persistentId);
    if (recentSessionInfo) {
      if (primarySession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        this.updaterRecentCoverTranslate(newSceneContainerSession,
          currContainerSession, primarySession.sceneInfo.windowMode);
        this.windowToRecentDefaultAnimateInner(newSceneContainerSession, recentSessionInfo);
      }
      if (primarySession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
        this.updaterRecentCoverTranslate(newSceneContainerSession,
          currContainerSession, primarySession.sceneInfo.windowMode);
        let newRecentSessionInfo = new SCBRecentSessionInfo();
        newRecentSessionInfo.height = recentSessionInfo.height;
        newRecentSessionInfo.top = currContainerSession.needRenderRecentTitleTranslate.translateY +
        SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN +
        SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
        newRecentSessionInfo.left = currContainerSession.needRenderRecentTitleTranslate.secondaryTranslateX;
        this.windowToRecentDefaultAnimateInner(newSceneContainerSession, newRecentSessionInfo);
      }
    } else {
      if (secondarySession) {
        recentSessionInfo = this.currentRecentSessionInfo.find(
          (element) => element.sessionId === secondarySession.session.persistentId);
      }
      if (recentSessionInfo && primarySession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        this.updaterRecentCoverTranslate(newSceneContainerSession,
          currContainerSession, primarySession.sceneInfo.windowMode);
        this.windowToRecentDefaultAnimateInner(newSceneContainerSession, recentSessionInfo);
      }
      if (recentSessionInfo && primarySession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
        this.updaterRecentCoverTranslate(newSceneContainerSession,
          currContainerSession, primarySession.sceneInfo.windowMode);
        let newRecentSessionInfo = new SCBRecentSessionInfo();
        newRecentSessionInfo.height = recentSessionInfo.height;
        newRecentSessionInfo.top = currContainerSession.needRenderRecentTitleTranslate.translateY +
        SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN +
        SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
        newRecentSessionInfo.left = currContainerSession.needRenderRecentTitleTranslate.secondaryTranslateX;
        this.windowToRecentDefaultAnimateInner(newSceneContainerSession, newRecentSessionInfo);
      }
    }
    SCBRecentSessionHelper.setState(newSceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
    if (!isEnterPair) {
      this.updateRecentInfoWhenResizeSceneProperty(true, newSceneContainerSession);
    }
  }

  private addSceneContainerSession(sceneContainerSession: SCBSceneContainerSession,
                                   needRefreshZOrder: boolean = true): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.containerSessionList.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1) {
      this.containerSessionList.push(sceneContainerSession);
      log.showInfo(`Add scene container session, id: ${sceneContainerSession.containerId}, ` +
        `containerSessionList.length: ${this.containerSessionList.length}`);
      this.containerSessionList.sortByModalType();
      this.containerSessionList.sortByTopmost();
      if (needRefreshZOrder) {
        SCBSessionListManager.refreshZOrder();
        const primaryZorder = sceneContainerSession.primarySession?.sessionInfo.zOrder;
        const secondaryZorder = sceneContainerSession.secondarySession?.sessionInfo.zOrder;
        log.showDebug(`addSceneContainerSession primaryZorder:${primaryZorder}, secondaryZorder:${secondaryZorder}`);
      }
      if (DesktopSwitchController.getInstance().hasVmAbility() && DesktopSwitchController.getInstance().isVmDesktop()) {
        DesktopSwitchController.getInstance().vmTopmost();
      }
    }
  }

  private removeSceneContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    this.removeSceneContainerSessionNotShowRecent(sceneContainerSession);
    const index = this.containerSessionList.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index != -1) {
      this.containerSessionList.splice(index, 1);
      log.showInfo(`Remove scene container session, id: ${sceneContainerSession.containerId}, ` +
        `containerSessionList.length: ${this.containerSessionList.length}`);
      SCBSessionListManager.refreshZOrder();
    } else {
      log.showInfo(`Not find in containerSessionList, id: ${sceneContainerSession.containerId}`);
    }
  }

  private addSceneContainerSessionNotShowRecent(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.containerSessionListNotShowRecent.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1) {
      recentLog.showInfo('Add scene container session in not show list, id: ' + sceneContainerSession.containerId);
      this.containerSessionListNotShowRecent.push(sceneContainerSession);
    }
  }

  private removeSceneContainerSessionNotShowRecent(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.containerSessionListNotShowRecent.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index !== -1) {
      recentLog.showInfo('Remove scene container session in not show list, id: ' + sceneContainerSession.containerId);
      this.containerSessionListNotShowRecent.splice(index, 1);
    }
  }

  private addExtendNotShowRecentSceneContainerSession = (list: SCBSceneContainerSessionArray,
    extendScreenId: number): void => {
    if (!list || !list.length) {
      log.showInfo('addExtendNotShowRecentSceneContainerSession is empty');
      return;
    }
    log.showInfo(`addExtendNotShowRecentSceneContainerSession list.length: ${list.length} ` +
      `extendScreenId: ${extendScreenId}`);
    this.initContainerSessionFromOtherScreen(list);
    for (let item of list) {
      this.pcScenePanelManager.updateExtendContainerSession(item, this.screenProperty);
      this.addSceneContainerSessionNotShowRecent(item);
    }
  }

  private addExtendSceneContainerSession =
    (list_: SCBSceneContainerSessionArray, extendScreenId: number): void => {
    this.onExitActiveSplit();
    log.showInfo(`addExtendSceneContainerSession list_.length: ${list_.length}, extendScreenId: ${extendScreenId}`);
    let extendTmpContainerSessionList = list_.filter((item) => {
        return item.screenProperty.screenId !== extendScreenId;
      }) as SCBSceneContainerSessionArray;
    for (let item of extendTmpContainerSessionList) {
      SCBPcScenePanelManager.getInstance().updateExtendSubSession(item, this.screenProperty, extendScreenId);
    }
    let extendContainerSessionList = list_.filter((item) => {
        return item.screenProperty.screenId === extendScreenId;
      }) as SCBSceneContainerSessionArray;
    log.showInfo(`addExtendSceneContainerSession extendTmpContainerSessionList.length: ` +
      `${extendTmpContainerSessionList.length},  ` +
      `extendContainerSessionList.length: ${extendContainerSessionList.length}`);
    if (extendContainerSessionList.length > 0) {
      this.initContainerSessionFromOtherScreen(extendContainerSessionList);
      SCBSessionListManager.allContainerSessionList.forEach((item) => {
        if (item.screenProperty.screenId === extendScreenId) {
          SCBPcScenePanelManager.getInstance()
            .updateExtendContainerSession(item, this.screenProperty);
        }
      });
      let newContainerSessionList: PcSCBSceneContainerSessionArray = new PcSCBSceneContainerSessionArray();
      let idxList: number[] = [];
      if (SCBSessionListManager.allContainerSessionList.length > 0) {
        for (let i = 0; i <= SCBSessionListManager.allContainerSessionList.length - 1; i++) {
          if (SCBSessionListManager.allContainerSessionList[i].screenProperty.screenId ===
            this.screenProperty.screenId) {
            if (newContainerSessionList.length > 0 &&
              newContainerSessionList[newContainerSessionList.length - 1].containerId ===
              SCBSessionListManager.allContainerSessionList[i].containerId) {
              log.showInfo(`addExtendSceneContainerSession containerId: ` +
                `${SCBSessionListManager.allContainerSessionList[i].containerId} ignored`);
              idxList.push(i);
              continue;
            }
            log.showInfo(`addExtendSceneContainerSession push: ` +
              `${SCBSessionListManager.allContainerSessionList[i].containerId}`);
            newContainerSessionList.superPush(SCBSessionListManager.allContainerSessionList[i]);
          }
        }
      }
      if (idxList.length > 0) {
        for (let i = idxList.length - 1; i >= 0; i--) {
          SCBSessionListManager.allContainerSessionList.splice(idxList[i], 1);
          log.showInfo(`addExtendSceneContainerSession removeIndex: ${idxList[i]}, allContainerSessionList.lenght: ` +
            `${SCBSessionListManager.allContainerSessionList.length}`);
        }
      }
      this.replaceContainerSessionList(newContainerSessionList);
      this.containerSessionList.sortByTopmost();
      log.showInfo(`addExtendSceneContainerSession containerSessionList.length: ${this.containerSessionList.length}`);
      SCBSessionListManager.setNormalContainerArray(this.screenProperty.screenId, this.containerSessionList);
      SCBSessionListManager.clearContainerSessionListMap(extendScreenId);
      this.containerSessionList.forEach((container) => {
        if (container.primarySession) {
          container.primarySession.isCrossingScreen = true;
        }
        if (container.secondarySession) {
          container.secondarySession.isCrossingScreen = true;
        }
      });
      SCBSessionListManager.refreshZOrder();
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
  }

  private replaceContainerSessionList(newContainerSessionList: PcSCBSceneContainerSessionArray): void {
    this.containerSessionList.superClear();
    newContainerSessionList.forEach((item) => {
      this.containerSessionList.superPush(item);
    });
  }

  private initContainerSessionFromOtherScreen(sceneContainerSessionList: SCBSceneContainerSessionArray): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      if (!sceneContainerSession.primarySession) {
        return;
      }
      if (sceneContainerSession.isActive) {
        sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'recoverVisibilityOtherScreen',
          sceneContainerSession.getName());
      }
      SCBRecentCardViewModel.showSceneShadow(sceneContainerSession);
      SCBRecentCardViewModel.showSceneStroke(sceneContainerSession);
      let sceneSession = sceneContainerSession.getMainSceneSession();
      if (!sceneSession) {
        return;
      }
      sceneSession.setFloatCornerRadiusConfig();
      sceneSession.needRenderSnapShotAnimConfig.animActionId = 0;
      this.recoverOrMaximizeIfLastSplit(sceneContainerSession);
      const sceneContainerPos = sceneContainerSession.getSceneContainerPosition();
      SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, sceneContainerPos.x, sceneContainerPos.y);
      SCBRecentCardViewModel.resetShowInRecent(sceneContainerSession);
      sceneContainerSession.needRenderRecentSceneBorderRadius.borderRadius = 0;
      sceneContainerSession.needRenderScale.setScaleXWithDfx(1, TAG,
        'initContainerSessionFromOtherScreen', sceneContainerSession.getName());
      sceneContainerSession.needRenderScale.setScaleYWithDfx(1, TAG,
        'initContainerSessionFromOtherScreen', sceneContainerSession.getName());
      SCBRecentCardViewModel.setSceneTranslate(sceneContainerSession, 0, 0);
      SCBRecentCardViewModel.setSceneScale(sceneContainerSession, 1);
      this.resetSpecificSceneTransition(sceneContainerSession);
      this.setSpecificSceneOpacity(sceneContainerSession, 1);
      SCBRecentCover.layoutRecentCover(sceneContainerSession, sceneContainerPos.x, sceneContainerPos.y);
      SCBRecentTitleViewModel.destroyRecentTitle(sceneContainerSession);
    });
  }

  private hideAppCenter(): void {
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      log.showInfo('hideAppCenter.');
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
  }

  private setRecentDataList(isNeedHideAppCenter: boolean = true): void {
    if (isNeedHideAppCenter) {
      this.hideAppCenter();
    }
    if (DesktopSwitchController.getInstance().hasVmAbility() &&
    DesktopSwitchController.getInstance().getVmSceneContainerSession()) {
      this.mSmartDockViewModel.initRecentDataList(this.getSessionListExceptVm());
      return;
    }
    let allContainerSessionList = new SCBSceneContainerSessionArray();
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenProperty = new SCBScreenProperty();
      screenProperty.screenId = screenSession.session.screenId;
      let containerSessionList = SCBSessionListManager.getNormalContainerArray(screenProperty);
      log.showInfo(`setRecentDataList screenId: ${screenSession.session.screenId}, ` +
        `containerSessionList.length: ${containerSessionList.length}`);
      let containerSessionArr = containerSessionList.filter((item) =>
      screenSession.session.screenId === item.screenProperty.screenId);
      allContainerSessionList.push(...containerSessionArr);
    }
    log.showInfo(`setRecentDataList screenId: ${this.screenProperty.screenId}, containerSessionList.length: ` +
      `${this.containerSessionList.length}, allContainerSessionList.length: ${allContainerSessionList.length}`);
    this.mSmartDockViewModel.initRecentDataList(allContainerSessionList);
  }

  private getSessionListExceptVm(): SCBSceneContainerSessionArray {
    let arr = new SCBSceneContainerSessionArray();
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenProperty = new SCBScreenProperty();
      screenProperty.screenId = screenSession.session.screenId;
      let containerSessionList = SCBSessionListManager.getNormalContainerArray(screenProperty);
      log.showInfo(`setRecentDataList screenId: ${screenSession.session.screenId}, ` +
        `containerSessionList.length: ${containerSessionList.length}`);
      let containerSessionArr = containerSessionList.filter((item) =>
      screenSession.session.screenId === item.screenProperty.screenId);
      arr.push(...containerSessionArr);
    }
    let session = DesktopSwitchController.getInstance().getVmSceneContainerSession();
    if (!arr || !session) {
      log.showWarn('[DesktopWorld] removeSession input is null');
      return arr as SCBSceneContainerSessionArray;
    }
    const index = arr.findIndex((item) => {
      return item.containerId === session?.containerId;
    });
    if (index === -1) {
      log.showWarn(`[DesktopWorld] scene container session(id: ${session.containerId}) is already in container`);
      return arr as SCBSceneContainerSessionArray;
    }
    log.showInfo(`[DesktopWorld] delete scene container session(id: ${session.containerId}) from container`);
    arr.splice(index, 1);
    return arr as SCBSceneContainerSessionArray;
  }

  private getRealScreenInfo(windowTop: number): RealScreenInfo {
    let screenId = this.screenProperty.screenId;
    let statusBarHeightPx: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar) {
      statusBarHeightPx = statusBar.currRect.height.getPx();
    }
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    let dockRect = new SCBSessionRect(0, 0, 0, 0);
    if (dock) {
      dockRect.copyFrom(dock.currRect);
      dockHeight = dock.currRect.height.getPx();
    } else {
      log.showError('getRealScreenInfo SmartDock no exit');
    }
    let screenWidth = this.screenProperty.width;
    let screenHeight = this.screenProperty.height;
    let screenHeightLimit = screenHeight - statusBarHeightPx - dockHeight;
    let maxTop = statusBarHeightPx;
    let maxBottom = screenHeight - dockHeight;
    let fullScreenTop = 0;
    return new RealScreenInfo(screenWidth, screenHeight, screenHeightLimit, maxTop, maxBottom, fullScreenTop);
  }

  private getSceneContainerSessionWithPersistentId(persistentId: number | undefined): SCBSceneContainerSession | null {
    return this.presenter.getSceneContainerSessionWithPersistentId(persistentId);
  }

  private getSceneContainerSessionWithContainerId(containerId?: number): SCBSceneContainerSession | null {
    return this.presenter.getSceneContainerSessionWithContainerId(containerId);
  }

  private restoreSceneRadius(sceneSession: SCBSceneSession | null): void {
    if (!sceneSession) {
      return;
    }
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      sceneSession.floatBorderRadius = 0;
    } else {
      sceneSession.setFloatCornerRadiusConfig();
    }
    log.showInfo(`sceneRadius restored, windowMode: ${sceneSession.sceneInfo.windowMode}`);
  }

  private getDpi(screenId?: number): number {
    let displayId = screenId !== undefined ? screenId : SCBSceneSessionManager.getInstance().mainScreenId;
    try {
      let defaultDisplay: display.Display = display.getDisplayByIdSync(displayId);
      return defaultDisplay.densityDPI;
    } catch (err) {
      log.showError(`get dpi error: ${err?.message}`);
      return SCBConstants.DEFAULT_DOTS_PER_INCH;
    }
  }

  private resizeSceneProperty(isOpen: boolean, delayTime: number = 0): void {
    this.getUIContext()?.animateTo({
      duration: 250,
      curve: Curve.Friction,
      delay: delayTime,
      onFinish: () => {
        this.containerSessionList.forEach((sceneContainerSession) => {
          if (!sceneContainerSession.primarySession) {
            return;
          }
          let recentSessionInfo = this.currentRecentSessionInfo.find(
            (element) => element.sessionId == sceneContainerSession.primarySession?.session.persistentId);
          if (recentSessionInfo) {
            sceneContainerSession.needRenderRecentClosingAnimating.isClosingAnimating = false;
          }
        });
      }
    }, () => {
      const containerSessionLen = this.containerSessionList.length;
      for (let i = 0; i < containerSessionLen; i++) {
        let containerSession = this.containerSessionList[i];
        let recentSession =
          this.currentRecentSessionInfo.find((element) => element.sessionId ===
          containerSession.primarySession?.session.persistentId);
        if (!recentSession) {
          recentLog.showError(`cannot find recent session, bundleName = ${containerSession.getName()}`);
          continue;
        }
        let sceneSession = containerSession.getMainSceneSession();
        if (!sceneSession) {
          continue;
        }
        containerSession.needRenderRecentClosingAnimating.isClosingAnimating = true;
        this.setScenePropertyAnimateEndState(containerSession, sceneSession, recentSession, isOpen);
      }
      this.updateStackHeight();
      let currContainerSession = this.containerSessionList.getTopActiveSession();
      if (currContainerSession && currContainerSession.isOneStepSplit() && currContainerSession.primarySession) {
        const stackHeightChange = currContainerSession.primarySession.translateY + this.screenHeight -
          this.scrollStackHeight;
        if (stackHeightChange > 0) {
          currContainerSession.primarySession.translateY -= stackHeightChange;
          currContainerSession.dividerParam.dividerTranslateY -= stackHeightChange;
        }
      }
    });
  }

  private setScenePropertyAnimateEndState(containerSession: SCBSceneContainerSession, sceneSession: SCBSceneSession,
                                          recentSession: SCBRecentSessionInfo, isOpen: boolean): void {
    let sceneContainerWidth = containerSession.getSceneContainerWidth();
    let sceneContainerHeight = containerSession.getSceneContainerHeight();
    let posX = sceneSession.currRect.left.getVp();
    let posY = sceneSession.currRect.top.getVp();
    let scale = SCBRecentCardViewModel.getSceneContainerRecentScale(containerSession,
      recentSession.height);
    let newX = sceneContainerWidth * (1 - scale) / 2 + posX;
    let newY = sceneContainerHeight * (1 - scale) / 2 + posY;
    let dx = recentSession.left - newX + this.calculateRecentLongCardOffSetX(sceneContainerWidth, scale);
    let dy = recentSession.top - newY + this.calculateRecentLongCardOffSetY(sceneContainerHeight, scale,
      recentSession.isUpDownSplit && recentSession.isSplitRecentPair);
    SCBRecentCardViewModel.setSceneTranslate(containerSession, dx, dy);
    SCBRecentCardViewModel.setSceneScale(containerSession, scale);
    this.recentMinBackground.setMinBackgroundSizeWhenRecentLayoutChange(containerSession, recentSession);
    if (isOpen) {
      this.updateRecentInfoWhenResizeSceneProperty(isOpen, containerSession);
    }
    containerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'handleCloseInRecent', containerSession.getName());
    containerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'handleCloseInRecent', containerSession.getName());
    SCBRecentTitleViewModel.setRecentTitleWidth(containerSession, scale);
    SCBRecentTitleViewModel.setRecentTitlePos(containerSession, recentSession.left, recentSession.top);
    SCBRecentCover.layoutRecentCover(containerSession, recentSession.left, recentSession.top);
    if (containerSession.dividerParam.isSplitRecentPair) {
      this.updateRecentInfoWhenResizeScenePropertyForPair(containerSession, scale, recentSession);
    }
  }

  private updateRecentInfoWhenResizeSceneProperty(isOpen: boolean, containerSession: SCBSceneContainerSession) {
    if (isOpen || containerSession.primarySession?.sessionData.isNeedUpdateOnSplitRecentView) {
      if (containerSession.primarySession && containerSession.primarySession.opacity !== null) {
        containerSession.primarySession.opacity = 1;
      }
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'openWindowInRecent',
        containerSession.getName());
      SCBRecentHoverViewModel.hideRecentHover(containerSession);
      SCBRecentTitleViewModel.buildRecentTitle(containerSession);
      SCBRecentCardViewModel.setShowInRecent(containerSession);
      SCBRecentTitleViewModel.showRecentTitle(containerSession);
    }
  }

  private updateRecentInfoWhenResizeScenePropertyForPair(containerSession: SCBSceneContainerSession, scale: number,
                                                         recentSession: SCBRecentSessionInfo) {
    this.calculateSplitRecentCardOffSetXForPair(containerSession, scale);
    this.calculateSplitRecentCardInfoForPair(containerSession, recentSession);
  }

  /**
   * 任务中心窗口调用hideAbility时，动效效果
   * @param containerSession
   * @param sceneSession
   * @param isFromClient
   */
  private recentSceneHideAnimate(containerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession, isFromClient: boolean = false): void {
    if (!containerSession) {
      return;
    }
    const onFinish = () => {
      SCBRecentDelete.restoreRecentCloseScene(containerSession);
      this.removeRemoveContainerSessionList(containerSession);
      this.presenter.doSceneHideInSceneHideMode(containerSession, sceneSession, isFromClient);
      this.setRecentDataList(false);
      AppStorage.setOrCreate('isRecentCardAnimating', false);
      containerSession.clearTransitionCount();
      this.recentPrepareManager.addHideContainerSession(containerSession);
      this.checkRecentEmptyView();
    }
    this.recentSceneCloseAnimate(containerSession, onFinish);
    this.handleCloseInRecent(containerSession);
  }

  recentOrSplitClose(containerSession: SCBSceneContainerSession, isException?: boolean,
                    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    let time = systemDateTime.getTime(false);
    performanceMonitor.recordInputEventTime(performanceMonitor.ActionType.LAST_UP,
      performanceMonitor.SourceType.PERF_MOUSE_EVENT, time);
    performanceMonitor.begin('APP_EXIT_FROM_WINDOW_TITLE_BAR_CLOSED', performanceMonitor.ActionType.LAST_UP,
      containerSession.companionIconInfo?.bundleName);
    containerSession.addTransitionCount();
    containerSession.isDisappearing = true;
    const isForceClean = extraInfo?.isForceClean;
    if (isException) {
      const shouldRemoveSession = extraInfo?.errorReason !== 'appRecovery';
      log.showInfo(`errorReason: ${extraInfo?.errorReason}, shouldRemoveSession: ${shouldRemoveSession}, isForceClean: ${isForceClean}`);
      containerSession.setIsClearSession(shouldRemoveSession);
      containerSession.requestDestruction(shouldRemoveSession, false, isSaveSnapshot, isForceClean);
    } else {
      AnimateToScheduleUtils.reportAppOptFromRecentToRss(OptFromRecentType.CLOSE_APP,
        containerSession?.primarySession?.sceneInfo?.bundleName);
      const isClearSession = extraInfo?.terminatedByAbility ? false : true;
      log.showInfo(`isClearSession: ${isClearSession}, isForceClean: ${isForceClean}`);
      containerSession.setIsClearSession(isClearSession);
      containerSession.requestDestruction(true, false, isSaveSnapshot, isForceClean);
    }
    this.recentSceneCloseAnimate(containerSession);
    this.handleCloseInRecent(containerSession);
    this.checkRecentEmptyView();
  }

  private recentSceneCloseAnimate(containerSession: SCBSceneContainerSession, onFinish?: Function): void {
    AppStorage.setOrCreate('isRecentCardAnimating', true);
    const animationCnt = containerSession.getTransitionCount();
    const name = containerSession.getName();
    recentLog.showInfo(`recentSceneCloseAnimate animationCnt: ${animationCnt} ${name}`);
    // 默认删除动效onFinish处理
    if (!onFinish) {
      onFinish = () => {
        this.removeSceneContainerSession(containerSession);
        this.setRecentDataList();
        this.checkRecentEmptyView();
        AppStorage.setOrCreate('isRecentCardAnimating', false);
        containerSession.clearTransitionCount();
        performanceMonitor.end('APP_EXIT_FROM_WINDOW_TITLE_BAR_CLOSED');
      }
    }
    this.getUIContext()?.animateTo({
      duration: 150,
      curve: Curve.Smooth
    }, () => {
      SCBRecentTitleViewModel.hideRecentTitle(containerSession);
    })
    this.getUIContext()?.animateTo({
      duration: 50
    }, () => {
      containerSession.needRenderBackgroundAlpha.backgroundAlpha = 0;
    })
    this.getUIContext()?.animateTo({
      duration: 150,
      curve: Curve.Smooth,
      onFinish: () => {
        recentLog.showInfo(`recentSceneCloseAnimate onFinish animationCnt: ${animationCnt} ${name} ${containerSession.getTransitionCount()}`);
        if (animationCnt === containerSession.getTransitionCount()) {
          onFinish?.();
        }
      }
    }, () => {
      SCBRecentDelete.setScaleCenter(containerSession, this.currentRecentSessionInfo,
        SCBRecentDelete.isGestureDelete(containerSession));
      containerSession.needRenderBlurRadius.blurRadius = SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS;
      const currentScale = SCBRecentDelete.getScaleWhenDelete(SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS);
      containerSession.needRenderRecentDeleteScale.scaleX = currentScale;
      containerSession.needRenderRecentDeleteScale.scaleY = currentScale;
    })
  }

  private setSessionSelected(containerId: number): void {
    let containerSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithContainerId(containerId);
    if (!containerSession) {
      return;
    }
    containerSession.tabSelected = true;
    containerSession.isPrimarySelected = true;
    containerSession.setPrimarySelectedWithMutex(true);
    recentLog.showInfo(`setSessionSelected success, ${containerSession.primarySession?.session.persistentId}`);
  }

  private updateSelectStatusCloseInRecent(containerSession: SCBSceneContainerSession): void {
    log.showInfo(`updateSelectStatusCloseInRecent ${containerSession.primarySession?.session.persistentId}`);
    if (this.containerSessionList === undefined || this.containerSessionList === null) {
      return;
    }
    const containerSessionIndex = this.containerSessionList.findIndexByContainerId(containerSession.containerId);
    if (containerSessionIndex === INVALID_INDEX || (containerSessionIndex > this.containerSessionList.length - 1)) {
      return;
    }
    // filter has been deleted, containerSessionList has 1000ms delay
    const originRecentList: SCBSceneContainerSessionArray =
      this.mRecentSessionsViewModel.getShowInRecentContainerSessionList();
    let recentContainerList = originRecentList.filter((item: SCBSceneContainerSession) =>
      this.removeContainerSessionList.findIndex((id) => id === item.getPersistentId()) === -1);
    if (this.isSplitState()) {
      const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      if (curActiveContainerSession?.isSplit) {
        recentContainerList = recentContainerList.filter((item: SCBSceneContainerSession, index: number) => {
          return item.containerId != curActiveContainerSession.containerId;
        })
        log.showInfo(`updateSelectStatusCloseInRecent in split`);
      }
    }
    const currentIndex: number = recentContainerList.findIndex((item: SCBSceneContainerSession) =>
    item.containerId === containerSession.containerId);
    const recentLength = recentContainerList.length;
    const curCardSelectIndex = recentLength - 1 - currentIndex;
    const preIndex = currentIndex + 1;
    const nextIndex = currentIndex - 1;
    recentLog.showInfo('updateSelectStatusCloseInRecent, [%{public}d, %{public}d, %{public}d, %{public}d] ',
      currentIndex, curCardSelectIndex, this.selectedIndex, recentLength);

    // closed card in front of selected card
    if (curCardSelectIndex < this.selectedIndex) {
      this.updateSelectedIndex(this.selectedIndex - 1, INVALID_INDEX);
    } else if (curCardSelectIndex === this.selectedIndex) {
      // closed card is the last one. The second last one should be selected.
      if (curCardSelectIndex === recentLength - 1) {
        if (preIndex >= recentLength || preIndex < 0) {
          recentLog.showError(`updateSelectStatusCloseInRecent invalid preIndex:${preIndex}`);
          return;
        }
        this.setSessionSelected(recentContainerList[preIndex]?.containerId);
        this.updateSelectedIndex(this.selectedIndex - 1, INVALID_INDEX);
      } else {
        if (nextIndex >= recentLength || nextIndex < 0) {
          recentLog.showError(`updateSelectStatusCloseInRecent invalid nextIndex:${nextIndex}`);
          return;
        }
        // next card should be selected,selected card will close,so selectedIndex no need to change
        this.setSessionSelected(recentContainerList[nextIndex]?.containerId);
      }
    }
  }

  /**
   *  update Recent selected index
   *  selectedIndex: the index of current selected sceneContainer in recentSessions
   *  oldSelectedIndex: previous selectedIndex, -1 while closing scene in Recent or reseting index
   * @param index
   * @param oldSelectedIndex
   */
  private updateSelectedIndex(selectIndex: number, oldSelectedIndex?: number): void {
    recentLog.showInfo(`updateSelectedIndex: ${this.oldSelectedIndex} ${this.selectedIndex} ${selectIndex} ${oldSelectedIndex}`);
    this.oldSelectedIndex = oldSelectedIndex ? oldSelectedIndex : this.selectedIndex;
    this.selectedIndex = selectIndex;
  }

  private resetSelectedIndex(): void {
    recentLog.showInfo(`resetSelectedIndex`);
    this.updateSelectedIndex(INVALID_INDEX, INVALID_INDEX);
  }

  private handleCloseInRecent(containerSession: SCBSceneContainerSession): void {
    const persistentIds: number[] = [];
    if (containerSession.primarySession && containerSession.primarySession.session) {
      persistentIds.push(containerSession.primarySession.session.persistentId);
    }
    if (this.scenePanelState === ScenePanelState.SPLIT) {
      const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      if (curActiveContainerSession?.isOneStepSplit()) {
        persistentIds.push(curActiveContainerSession?.primarySession?.session.persistentId as number);
      }
      this.notSupportSplitRecentSessionInfo = this.mRecentSessionsViewModel
        .getRecentSessionsListIfNotSupportSplitMode();
      this.notSupportSplitRecentSessionInfo.forEach((sessionInfo) => {
        persistentIds.push(sessionInfo?.sessionId as number);
      });
    }
    persistentIds.push(...this.removeContainerSessionList);
    this.currentRecentSessionInfo = this.mRecentSessionsViewModel
      .getRecentSessionsNotInclude(persistentIds);
    this.updateSelectStatusCloseInRecent(containerSession);
    this.removeContainerSessionList.push(containerSession.getPersistentId());
    this.resizeSceneProperty(false, SCBRecentStyleConstants.DELETE_RECENT_DELAY);
  }

  private avoidAnimation: Callback<CustomAnimateParam, void> = (animateParam: CustomAnimateParam) => {
    if (this.isSplitState()) {
      return;
    }
    log.showInfo(`avoidAnimation`);
    const recentStyle: SCBRecentStyle = this.recentStyleManager.getStyle();
    this.scrollFlingSpeedLimit = recentStyle.flingSpeedLimit;
    const height: number = recentStyle.getRecentShowHeight();
    this.mRecentSessionsViewModel.setScreenProperty(this.screenWidth, this.screenHeight);
    this.mRecentSessionsViewModel.setRecentProperty(0, 0, this.screenWidth, height > 0 ? height : this.screenHeight);
    const yOffset = this.mRecentSessionsViewModel.setScrollYOffset(this.scroll.currentOffset()?.yOffset ?? 0);
    this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessions();
    let emptyViewHeight: number = recentStyle.getUsableScreenHeight(recentStyle.bPanel.height);
    if (emptyViewHeight <= 0 || recentStyle.isSplitStyle) {
      emptyViewHeight = this.mRecentSessionsViewModel.getCurrentShowHeight();
    }
    if (animateParam.animationKey) {
      Trace.start(animateParam.animationKey);
    }
    this.getUIContext()?.animateTo(animateParam, () => {
      const containerSessionLen = this.containerSessionList.length;
      for (let i = 0; i < containerSessionLen; i++) {
        let containerSession = this.containerSessionList[i];
        let recentSession =
          this.currentRecentSessionInfo.find((element) => element.sessionId ===
          containerSession.primarySession?.session.persistentId);
        if (!recentSession) {
          recentLog.showError(`cannot find recent session, bundleName = ${containerSession.getName()}`);
          continue;
        }
        let sceneSession = containerSession.getMainSceneSession();
        if (!sceneSession) {
          continue;
        }
        this.setScenePropertyAnimateEndState(containerSession, sceneSession, recentSession, false);
      }
      this.scroll.scrollTo({ xOffset: 0, yOffset: yOffset });
      this.emptyViewHeight = emptyViewHeight;
      if (animateParam?.needUpdateStack) {
        this.updateStackHeight();
      }
    });
  }

  private willScrollHandler: Callback<CustomAnimateParam, void> = (animateParam: CustomAnimateParam) => {
    if (this.isSplitState()) {
      return;
    }
    recentLog.showInfo(`willScrollHandler:${animateParam.yOffset}, ${this.scroll.currentOffset().yOffset}`);
    const currentOffsetY = this.scroll.currentOffset().yOffset + (animateParam.yOffset ?? 0);
    const maxOffsetY = this.scrollStackHeight - this.recentStyleManager.getStyle().getRecentShowHeight();
    if (currentOffsetY < 0 || currentOffsetY > maxOffsetY) {
      return;
    }
    const yOffset: number = this.mRecentSessionsViewModel.getSessionScrollOffsetY(animateParam.yOffset);
    const avoidAreaTop = this.mRecentSessionsViewModel.getBSideLastCardTop();
    this.getUIContext()?.animateToImmediately(animateParam, () => {
      const containerSessionLen = this.containerSessionList.length;
      for (let i = 0; i < containerSessionLen; i++) {
        let containerSession = this.containerSessionList[i];
        let recentSession =
          this.currentRecentSessionInfo.find((element) => element.sessionId ===
          containerSession.primarySession?.session.persistentId);
        if (!recentSession) {
          recentLog.showError(`cannot find recent session, bundleName = ${containerSession.getName()}`);
          continue;
        }
        const top = recentSession.top - this.scroll.currentOffset().yOffset;
        let sceneSession = containerSession.getMainSceneSession();
        if (!sceneSession) {
          continue;
        }
        this.setScenePropertyAnimateEndState(containerSession, sceneSession, recentSession, true);
      }
    });
  }

  private avoidKeyboardAnimation: Callback<CustomAnimateParam, void> = (animateParam: CustomAnimateParam) => {
    if (this.isSplitState()) {
      return;
    }
    log.showInfo(`avoidKeyboardAnimation`);
    const recentStyle: SCBRecentStyle = this.recentStyleManager.getStyle();
    const height: number = recentStyle.getRecentShowHeight();
    this.mRecentSessionsViewModel.setScreenProperty(this.screenWidth, this.screenHeight);
    this.mRecentSessionsViewModel.setRecentProperty(0, 0, this.screenWidth, height > 0 ? height : this.screenHeight);
    this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessions();
    this.scrollFlingSpeedLimit = recentStyle.flingSpeedLimit;
    this.getUIContext()?.animateTo(animateParam, () => {
      this.updateStackHeight();
    })
  }

  updateScenePanelState(state: ScenePanelState) {
    log.showWarn(`updateSceneState from ${this.scenePanelState} to ${state}`);
    if (this.scenePanelState === state) {
      return;
    }
    if (state === ScenePanelState.SPLIT) {
      AppStorage.setOrCreate('split', true);
      MultiInputViewModel.getInstance().setSpiltState(true);
    } else {
      AppStorage.setOrCreate('split', false);
      MultiInputViewModel.getInstance().setSpiltState(false);
    }
    const oldState = this.scenePanelState;
    this.scenePanelState = state;
    // 从任务中心或应用中心退出到非任务中心
    if ((oldState === ScenePanelState.RECENT ||
      (this.screenProperty.screenId === 0 && oldState === ScenePanelState.APP_CENTER)) &&
      state !== ScenePanelState.RECENT) {
      this.handleOtherWhenExitRecent();
      this.sysSceneSession.setSessionTouchable(false);
    } else if (oldState !== ScenePanelState.RECENT && state === ScenePanelState.RECENT) {
      this.handleOtherWhenEnterRecent();
      this.sysSceneSession.setSessionTouchable(true);
    } else if (oldState !== ScenePanelState.SPLIT && state === ScenePanelState.SPLIT) {
      this.sysSceneSession.setSessionTouchable(true);
    }
  }

  private handleOtherWhenEnterRecent(): void {
    AppStorage.setOrCreate('showRecent', true);
    if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
      const showDockViewWithAnimation = (GlobalContext.getInstance()
        .getObject('showDockViewWithAnimation')) as Function;
      showDockViewWithAnimation();
    } else {
      viewMgrPolicy.showView(ViewType.SMART_DOCK);
    }
    if (GlobalContext.getInstance().hasObject('setWholeDockVisibilityWithAnimation')) {
      const setWholeDockVisibilityWithAnimation = (GlobalContext.getInstance()
        .getObject('setWholeDockVisibilityWithAnimation')) as Function;
      setWholeDockVisibilityWithAnimation(this.screenProperty.screenId, true);
    } else {
      viewMgrPolicy.showView(ViewType.SMART_DOCK_EXT_SCREEN);
    }
    viewMgrPolicy.hideView(ViewType.STATUS_BAR);
    if (RecentAndAppCenterSwitchManager.getInstance().getRecentToAppCenter() ||
      RecentAndAppCenterSwitchManager.getInstance().getOneFrameVisible(this.screenProperty.screenId)) {
      return;
    }
    SCBSceneSessionManager.getInstance().resetLastStatusBarProperty(this.screenProperty.screenId);
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    } else {
      viewMgrPolicy.hideView(ViewType.APP_CENTER);
    }
  }

  private handleOtherWhenExitRecent(): void {
    AppStorage.setOrCreate('showRecent', false);
    if (!RecentAndAppCenterSwitchManager.getInstance().getRecentToAppCenter()) {
      // reset lastStatusBarProperty
      SCBSceneSessionManager.getInstance().resetLastStatusBarProperty(this.screenProperty.screenId);
      // sysBar hide or not
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
  }

  enterSplitView(containerSession: SCBSceneContainerSession, isPrimary: boolean) {
    if (!containerSession) {
      log.showError('fail to enterSplitView')
      return;
    }
    // 二分屏状态栏不可获焦
    let statusBarSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if (statusBarSession && statusBarSession.getFocusable()) {
      statusBarSession.setFocusable(false);
    }
    const topArea: ViewArea = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
    if (topArea !== undefined) {
      viewMgrPolicy.showView(ViewType.GESTURE_TOP_BAR + this.screenProperty.screenId * SCREEN_INDEX);
    }
    this.resetSelectedIndex();
    AppStorage.setOrCreate('isRecentCardAnimating', false);
    this.initSplitWidthAndHeight(containerSession);
    this.dividerOpacityAnimate(containerSession);
    log.showInfo(`enterSplitView, primarySession: ${containerSession?.primarySession?.sceneInfo?.bundleName}`);
    if (containerSession.primarySession) {
      this.mRecentSessionsViewModel.setSplittingSessionId(
        containerSession.primarySession.session.persistentId);
    }
    AppStorage.setOrCreate('isEnterSplitAnimating', true);
    AppStorage.setOrCreate('isSplitAnimating', true);
    this.enterSplitRecentView(containerSession, isPrimary);
    this.isExitSplit = false;
  }

  private initSplitWidthAndHeight(containerSession: SCBSceneContainerSession): void {
    const priRect = LayoutPolicyHelper.getInstance()
      .getSplitInitialRect(this.screenProperty, containerSession.dividerParam, true);
    const secRect = LayoutPolicyHelper.getInstance()
      .getSplitInitialRect(this.screenProperty, containerSession.dividerParam, false);
    if (this.screenProperty.height > 0) {
      containerSession.dividerParam.primary.height = priRect.height.getPx() / this.screenProperty.height * 100 + '%';
      containerSession.dividerParam.secondary.height = secRect.height.getPx() / this.screenProperty.height * 100 + '%';
    }
    if (this.screenProperty.width > 0) {
      containerSession.dividerParam.primary.width = priRect.width.getPx() / this.screenProperty.width * 100 + '%';
      containerSession.dividerParam.secondary.width = secRect.width.getPx() / this.screenProperty.width * 100 + '%';
    }
    containerSession.dividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
    containerSession.dividerParam.positionX = `${PCUtils.px2vp(this.getUIContext(), priRect.width.getPx())}`;
    containerSession.dividerParam.positionY = `${PCUtils.px2vp(this.getUIContext(), priRect.top.getPx())}`;
    containerSession.dividerParam.dividerWidth = DividerStyle.DIVIDER_WIDTH;
    containerSession.dividerParam.dividerHeight = PCUtils.px2vp(this.getUIContext(), priRect.height.getPx());
  }

  private dividerOpacityAnimate(containerSession: SCBSceneContainerSession): void {
    containerSession.dividerParam.dividerOpacity = 0;
    this.getUIContext()?.animateTo({
      delay: 400,
      duration: 150,
      curve: Curve.EaseOut,
    }, () => {
      containerSession.dividerParam.dividerOpacity = 1;
    });
  }

  onGestureChange(action: SCBGestureAction, displayId?: number): void {
    switch (action.actionId) {
      case SCBGestureActionId.EXIT_SPLIT:
        let parm = new ExitSplitParam();
        if (displayId !== undefined) {
          parm.displayId = displayId;
        }
        parm.exitSplitCommand = MonitorExitSplitName.DRAG_TITLE;
        this.exitSplitView(action.sessionId, parm);
        break;
      case SCBGestureActionId.RECENT_GESTURE_BEGIN:
        this.onRecentGestureActionBegin(action.containerId, action.gestureEvent);
        break;
      case SCBGestureActionId.RECENT_GESTURE_UPDATE:
        this.onRecentGestureActionMove(action.containerId, action.gestureEvent);
        break;
      case SCBGestureActionId.RECENT_GESTURE_END:
        this.onRecentGestureActionEnd(action.containerId, action.gestureEvent);
        break;
      case SCBGestureActionId.RECENT_GESTURE_CANCEL:
        this.onRecentGestureActionCancel(action.containerId);
        break;
      default:
        break;
    }
  }

  private onRecentGestureActionBegin(containerId: number, event: GestureEvent): void {
    recentLog.showInfo(`onRecentGestureActionBegin ${containerId}`);
    if (this.scenePanelState !== ScenePanelState.RECENT) {
      return;
    }
    if (event.offsetY > 0) {
      return;
    }
    this.onRecentGestureActionUpBegin(containerId, event);
  }

  private onRecentGestureActionUpBegin(containerId: number, event: GestureEvent): void {
    recentLog.showInfo(`onRecentGestureActionUpBegin:${containerId}, ${JSON.stringify(event)}`);
    const containerSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithContainerId(containerId);
    if (containerSession?.primarySession?.isClosing) {
      log.showInfo(`containerSession is closing`);
      return;
    }
    if (CheckEmptyUtils.isEmpty(containerSession)) {
      recentLog.showInfo(`onRecentGestureActionUpBegin find ${containerId} empty`);
      return;
    }
    // when the card is moving, gesture enter begin state, do restore animate immediately;
    SCBRecentDelete.restoreMoveUpAnimateImmediately(containerSession as SCBSceneContainerSession);
    this.recentGestureModel.beginOffset = event.offsetY;
    this.recentGestureModel.beginTime = event.timestamp;
    SCBRecentDelete.setScaleCenter(containerSession!, this.currentRecentSessionInfo, true);
  }

  /**
   * 不做动效刷新任务中心布局
   */
  private onSceneRectChange(): void {
    if (!this.isRecentState()) {
      recentLog.showInfo(`not recent state, ${this.scenePanelState}`);
      return;
    }
    this.currentRecentSessionInfo = this.mRecentSessionsViewModel.getRecentSessions();
    this.containerSessionList.forEach((sceneContainerSession) => {
      this.calcContainerLayoutInRecent(sceneContainerSession, 'onSceneRectChange', false);
    })
  }

  private playMoveUpAnimate(containerSession: SCBSceneContainerSession,
                            offsetY: number, durationTime: number = 200, playTempo: number = 1): void {
    const recentSession = this.currentRecentSessionInfo.find(
      (element) => element.sessionId == containerSession.primarySession?.session.persistentId);
    if (CheckEmptyUtils.isEmpty(recentSession)) {
      log.showError(`cannot find recent session, bundleName = ${containerSession.primarySession?.sceneInfo.bundleName}`);
      return;
    }
    this.getUIContext()?.animateTo({
      duration: durationTime,
      tempo: playTempo,
      curve: Curve.Sharp
    }, () => {
      const oriScale = recentSession?.height as number /
        (containerSession.primarySession?.currRect.height?.getVp() as number);
      const blurRadius = SCBRecentDelete.getBlurRadiusWhenDelete(offsetY, oriScale);
      containerSession.needRenderBlurRadius.blurRadius = blurRadius;
      const currentScale = SCBRecentDelete.getScaleWhenDelete(blurRadius);
      containerSession.needRenderRecentDeleteScale.scaleX = currentScale;
      containerSession.needRenderRecentDeleteScale.scaleY = currentScale;
    });
  }

  private onRecentGestureActionMove(containerId: number, event: GestureEvent): void {
    recentLog.showDebug(`onRecentGestureActionMove ${containerId}`);
    if (this.scenePanelState !== ScenePanelState.RECENT) {
      return;
    }
    this.recentGestureActionUpMove(containerId, event);
  }

  private recentGestureActionUpMove(containerId: number, event: GestureEvent) {
    const containerSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithContainerId(containerId);
    if (containerSession?.primarySession?.isClosing) {
      log.showInfo(`containerSession is closing`);
      return;
    }
    if (CheckEmptyUtils.isEmpty(containerSession)) {
      recentLog.showInfo(`onRecentGestureActionMove find ${containerId} empty`);
      return;
    }
    this.playMoveUpAnimate(containerSession as SCBSceneContainerSession, event.offsetY);
  }

  private recentGestureActionUpEnd(containerId: number, event: GestureEvent): void {
    recentLog.showInfo(`onRecentGestureActionEnd:${containerId}, ${JSON.stringify(event)}`);
    const curSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithContainerId(containerId);
    if (CheckEmptyUtils.isEmpty(curSession)) {
      recentLog.showInfo(`onRecentGestureActionUpMove find ${containerId} empty`);
      return;
    }
    if (this.isMoveUpCloseSceneReady(curSession as SCBSceneContainerSession, event)) {
      this.closeSceneCardInRecent(curSession?.primarySession?.session.persistentId as number);
    } else {
      // restore the card
      SCBRecentDelete.restoreMoveUpAnimateNormally(curSession as SCBSceneContainerSession);
    }
  }

  private closeSceneCardInRecent(persistentId: number): void {
    let containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    let isSplitRecentPair = false;
    //预分屏下二分屏
    if (this.isSplitState() && containerSession?.dividerParam.isSplitRecentPair) {
      this.presenter.closeSceneInSplitState(persistentId);
      containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
      isSplitRecentPair = true;
    }
    if (!containerSession) {
      recentLog.showInfo('closeSceneCardInRecent containerSession is invalid');
      return;
    }
    const onFinish = (containerSession: SCBSceneContainerSession) => {
      performanceMonitor.end(HiSysEventUtil.APP_EXIT_FROM_RECENT);
      containerSession.primarySession?.setIsClosing(false);
      SCBRecentDelete.restoreRecentCloseScene(containerSession);
      this.recentToWindowDefault(containerSession);
      AppStorage.setOrCreate('isRecentCardAnimating', false);
      containerSession.clearTransitionCount();
      this.removeRemoveContainerSessionList(containerSession);

      this.removeSceneContainerSession(containerSession);
      this.addSceneContainerSessionNotShowRecent(containerSession);
      this.setRecentDataList(false);
      if (isSplitRecentPair && containerSession && containerSession.primarySession) {
        containerSession.primarySession.sessionData.isLastSplit = true;
        this.recoverOrMaximizeIfLastSplit(containerSession);
      }
      if (containerSession.isSplitView()) {
        recentLog.showInfo(`closeSceneCardInRecent parscene ${persistentId} ${containerSession.getName()}`);
        this.closePairSceneContainerInRecent(containerSession);
        this.checkRecentEmptyView();
        return;
      }
      recentLog.showInfo(`closeSceneCardInRecent ${persistentId} ${containerSession.getName()}`);
      this.closeSingleAppContainerSessionAsync(containerSession);
      this.checkRecentEmptyView();
    }
    containerSession.primarySession?.setIsClosing(true);
    performanceMonitor.begin(HiSysEventUtil.APP_EXIT_FROM_RECENT, performanceMonitor.ActionType.LAST_UP,
      containerSession.companionIconInfo?.bundleName);
    this.recentSceneCloseAnimate(containerSession, () => { onFinish(containerSession as SCBSceneContainerSession) });
    this.handleCloseInRecent(containerSession);
  }

  private removeRemoveContainerSessionList(containerSession: SCBSceneContainerSession | null): void {
    if (!containerSession) {
      recentLog.showInfo('restoreRemoveContainerSessionList invalid containerSession');
      return;
    }
    const persistentId = containerSession.getPersistentId();
    const index = this.removeContainerSessionList.findIndex(removePersistentId => {
        return removePersistentId === persistentId;
    })

    if (index != -1) {
      this.removeContainerSessionList.splice(index, 1);
      log.showInfo(`Remove RemoveContainerSessionList, persistentId: ${persistentId}, `);
    } else {
      log.showInfo(`Remove RemoveContainerSessionList, persistentId: ${persistentId}`);
    }
  }

  private closeSingleAppContainerSessionAsync(containerSession: SCBSceneContainerSession | null): void {
    if (!containerSession) {
      recentLog.showError('closeSingleAppContainerSessionAsync invalid containerSession');
      return;
    }
    const persistentId = containerSession.primarySession?.session.persistentId as number;

    const prepareCallBack = () => {
      const container = this.getSceneContainerSessionWithPersistentId(persistentId);
      if (!container) {
        return;
      }
      if (this.isRecentOrSplitState()) {
        this.recentPreparePersistentIds.push(persistentId);
        return;
      }
      if (!this.recentPrepareManager.isHideContainerSession(container)) {
        this.removeSceneContainerSessionNotShowRecent(container);
        this.addSceneContainerSession(container);
      }
    };
    const notPrepareCallBack = () => {
      const container = this.getSceneContainerSessionWithPersistentId(persistentId);
      if (!container) {
        return;
      }
      AnimateToScheduleUtils.reportAppOptFromRecentToRss(OptFromRecentType.CLOSE_APP,
        container?.primarySession?.sceneInfo?.bundleName);
      this.removeSceneContainerSession(container);
      this.destroyContainer(container);
    };
    this.recentPrepareManager.closeAsync(persistentId, containerSession, prepareCallBack, notPrepareCallBack);
  }

  /**
   * 关闭任务中心双应用卡片窗口
   * @param containerSession
   */
  private closePairSceneContainerInRecent(containerSession: SCBSceneContainerSession | null): void {
    if (!containerSession) {
      recentLog.showWarn('closePairSceneContainerInRecent invalue container');
      return;
    }
    let primPersistentId = containerSession.primarySession?.session.persistentId as number;
    let secPersistentId = containerSession.secondarySession?.session.persistentId as number;
    this.recentPairToTwoNotShowContainer(containerSession);
    let primContainer = this.getSceneContainerSessionWithPersistentId(primPersistentId);
    this.closeSingleAppContainerSessionAsync(primContainer);
    let secContainer = this.getSceneContainerSessionWithPersistentId(secPersistentId);
    this.closeSingleAppContainerSessionAsync(secContainer);
    this.setRecentDataList(false);
  }

  /**
   * 任务中心场景，把二分屏窗口，拆分成2个container
   */
  private recentPairToTwoNotShowContainer(containerSession: SCBSceneContainerSession): void {
    recentLog.showInfo(`pairToTwoContainerInRecent ${containerSession.getName()}`);
    let primPersistentId = containerSession.primarySession?.session.persistentId as number;
    let secPersistentId = containerSession.secondarySession?.session.persistentId as number;
    let index = this.containerSessionListNotShowRecent.findIndexByContainerId(containerSession.containerId);
    this.presenter.doExitSplitView(index, containerSession, false, false, false);
    let primContainer = this.getSceneContainerSessionWithPersistentId(primPersistentId);
    if (primContainer && primContainer.primarySession) {
      primContainer.primarySession.recover();
      this.recentToWindowDefault(primContainer);
    }
    let secContainer = this.getSceneContainerSessionWithPersistentId(secPersistentId);
    if (secContainer && secContainer.primarySession) {
      secContainer.primarySession.recover();
      this.recentToWindowDefault(secContainer);
    }
  }

  private recentToWindowDefault(sceneContainerSession: SCBSceneContainerSession): void {
    let sceneSession = sceneContainerSession.getMainSceneSession();
    if (!sceneSession) {
      return;
    }
    this.recoverOrMaximizeIfLastSplit(sceneContainerSession);
    const sceneContainerPosition = sceneContainerSession.getSceneContainerPosition();
    SCBRecentTitleViewModel.setRecentTitlePos(sceneContainerSession, sceneContainerPosition.x,
      sceneContainerPosition.y);
    let name = sceneContainerSession.getName();
    sceneContainerSession.needRenderRecentSceneBorderRadius.borderRadius = 0;
    sceneContainerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'recentToWindowDefaultImmediatelyInner', name);
    sceneContainerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'recentToWindowDefaultImmediatelyInner', name);
    this.recentMinBackground.setMinBackgroundAlpha(sceneContainerSession, 0);
    SCBRecentCardViewModel.setSceneTranslate(sceneContainerSession, 0, 0);
    SCBRecentCardViewModel.setSceneScale(sceneContainerSession, 1);
    SCBRecentCardViewModel.setSceneOpacity(sceneContainerSession, 1);
    this.resetSpecificSceneTransition(sceneContainerSession);
    this.setSpecificSceneOpacity(sceneContainerSession, 1);
    SCBRecentHoverViewModel.hideRecentHover(sceneContainerSession);
    SCBRecentCover.layoutRecentCover(sceneContainerSession, sceneContainerPosition.x,
      sceneContainerPosition.y);
    SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.EXIT_RECENT_ANIMATE_STARTED);
    SCBRecentTitleViewModel.destroyRecentTitle(sceneContainerSession);
    SCBRecentCardViewModel.resetShowInRecent(sceneContainerSession);
    this.recentSubSceneViewModel.buildSubScenes(sceneContainerSession);
  }

  private destroyContainer(containerSession: SCBSceneContainerSession): void {
    recentLog.showInfo(`destroyContainer ${containerSession.getName()}`);
    this.presenter.destroyContainer(containerSession)
  }

  private isMoveUpCloseSceneReady(containerSession: SCBSceneContainerSession,
                                  event: GestureEvent): boolean | undefined {
    const recentSession = this.currentRecentSessionInfo.find(
      (element) => element.sessionId === containerSession.primarySession?.session.persistentId);
    if (CheckEmptyUtils.isEmpty(recentSession)) {
      log.showError(`cannot find recent session, bundleName = ${containerSession.primarySession?.sceneInfo.bundleName}`);
      return;
    }

    const recentScale = recentSession?.height as number /
      (containerSession?.primarySession?.currRect.height?.getVp() as number);
    // when rotate degree is -90
    if (SCBRecentDelete.getBlurRadiusWhenDelete(event.offsetY, recentScale) ===
    SCBRecentStyleConstants.RECENT_DELETE_BLUR_RADIUS) {
      return true;
    }
    // when the distance of move up greater 0.6 * cardHeight
    if (Math.abs(event.offsetY) > (recentSession?.height as number) * 0.6) {
      return true;
    }
    // when move up gesture speed is ok
    this.recentGestureModel.endOffset = event.offsetY;
    this.recentGestureModel.endTime = event.timestamp;
    if (this.recentGestureModel.getRecentGestureType() === SCBRecentGestureModel.GESTURE_SPEED_FAST) {
      this.recentGestureModel.reset();
      return true;
    }
    this.recentGestureModel.reset();
    return false;
  }

  private onRecentGestureActionEnd(containerId: number, event: GestureEvent): void {
    recentLog.showInfo(`onRecentGestureActionEnd ${containerId}`);
    if (this.scenePanelState !== ScenePanelState.RECENT) {
      return;
    }
    const curSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithContainerId(containerId);
    if (curSession?.primarySession?.isClosing) {
      log.showInfo(`containerSession is closing`);
      return;
    }
    // when move down, restore animate immediately
    if (event.offsetY > 0) {
      if (CheckEmptyUtils.isEmpty(curSession)) {
        recentLog.showInfo(`onRecentGestureActionEnd find ${containerId} empty`);
        return;
      }
      SCBRecentDelete.restoreMoveUpAnimateNormally(curSession as SCBSceneContainerSession);
      return;
    }
    this.recentGestureActionUpEnd(containerId, event);
  }

  private onRecentGestureActionCancel(containerId: number): void {
    recentLog.showInfo(`onRecentGestureActionCancel ${containerId}`);
    if (this.scenePanelState !== ScenePanelState.RECENT) {
      return;
    }
    const curSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithContainerId(containerId);
    if (curSession?.primarySession?.isClosing) {
      log.showInfo(`containerSession is closing`);
      return;
    }
    SCBRecentDelete.restoreMoveUpAnimateNormally(curSession as SCBSceneContainerSession);
  }

  private onExitActiveSplit(): void {
    if (this.scenePanelState !== ScenePanelState.SPLIT) {
      return;
    }
    const activeSceneContainerSession = this.containerSessionList.getTopActiveSession();
    if (activeSceneContainerSession?.isSplit) {
      let param = new ExitSplitParam();
      if (activeSceneContainerSession.primarySession?.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN) {
        param.exitSplitEvent = SCBSessionEventId.EVENT_MAXIMIZE;
      }
      this.exitSplitView(activeSceneContainerSession.primarySession?.session?.persistentId, param);
    }
  }

  private recoverStatusBar(isShowSystemBar: Boolean): void {
    if (SCBSceneSessionManager.getInstance().getIsStatusBarShownForHover()) {
      const systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithSystemType(
        sceneSessionManager.SessionType.TYPE_STATUS_BAR, this.screenProperty.screenId);
      if (systemSceneSession == null) {
        log.showError('Failed to get systemSceneSession of the statusBar');
        return;
      }
      // 底层最大化窗口，上层全屏窗口，hover出状态栏，点击还原会导致黑底板消失。
      if (!SCBSceneSessionManager.getInstance().getFullScreenLayoutStatusByScreenId(this.screenProperty.screenId)) {
        systemSceneSession.setBackgroundColor('#00000000');
        systemSceneSession.setBackdropBlur(0);
      }
      SCBSceneSessionManager.getInstance().setIsStatusBarShownForHover(false);
      if (!isShowSystemBar && viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
        viewMgrPolicy.hideView(ViewType.STATUS_BAR);
        SCBSceneSessionManager.getInstance().resetLastStatusBarProperty(this.screenProperty.screenId);
        this.hideFloatingTitle();
      }
    }
  }

  private hideFloatingTitle(): void {
    let hideTitleSessionList: Set<SCBSceneContainerSession> = MultiInputViewModel.getInstance()
      .getHideTitleSessionList();
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const item = this.containerSessionList[i];
      if (item !== null && item.isActive && item.primarySession !== null &&
        item.primarySession.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
        if (hideTitleSessionList && hideTitleSessionList.size > 0 && hideTitleSessionList.has(item)) {
          continue;
        }
        sceneSessionManager.updateTitleInTargetPos(item.primarySession.session.persistentId, false, 0);
        if (item.secondarySession != null) {
          sceneSessionManager.updateTitleInTargetPos(
            item.secondarySession.session.persistentId, false, 0);
        }
        break;
      }
    }
  }

  registerCallback(): void {
    const managerInstance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    if (!managerInstance) {
      log.showError('registerCallback managerInstance is null');
      return;
    }
    this.registerUnlockTransitionController(managerInstance);
    this.registerGestureBackEventCallback();
    this.registerGestureNavigationEventCallback();
    this.registerAnimateCallback(managerInstance);
  }

  private unRegisterCallback(): void {
    const managerInstance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    if (!managerInstance) {
      log.showError('unRegisterCallback managerInstance is null');
      return;
    }
    this.unregisterGestureNavigationEventCallback();
    this.unregisterGestureBackEventCallback();
    this.unregisterUnlockTransitionCallback(managerInstance);
    this.unregisterAnimateCallback(managerInstance);
  }

  onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    log.showInfo(`onScreenPropertyChange reason: ${reason}, screenId:${this.screenProperty.screenId}`);
    if (reason === SCBPropertyChangeReason.ROTATION) {
      for (let container of this.containerSessionList) {
        container.updateContainerSessionWithRotation(this.screenProperty, SCBContainerRotationReason.SCREEN_ROTATION);
      }
    } else if (reason === SCBPropertyChangeReason.CHANGE_MODE) {
      const oldScreenProperty = new SCBScreenProperty();
      oldScreenProperty.copy(this.screenProperty);
      log.showInfo('onScreenPropertyChange oldScreenProperty:' + JSON.stringify(oldScreenProperty) +
        ' newScreenProperty:' + JSON.stringify(screenProperty));
      this.screenProperty.copy(screenProperty);
      SCBScreenSessionManager.getInstance().updateSystemActiveModeChange(oldScreenProperty, screenProperty);
      let targetDensity: number = this.getDpi(screenProperty.screenId);
      for (let containerSession of this.containerSessionList) {
        SCBPcScenePanelManager.getInstance().updateContainerSessionWithChangeMode(containerSession, oldScreenProperty,
          screenProperty, targetDensity);
        if (containerSession.isActive) {
          containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'recoverVisibilityChangeMode',
            containerSession.getName());
        }
      }
      log.showInfo(`onScreenPropertyChange: updatecontainerSessionListNotShowRecent with changeMode`);
      for (let container of this.containerSessionListNotShowRecent) {
        SCBPcScenePanelManager.getInstance().updateContainerSessionWithChangeMode(container, oldScreenProperty,
          screenProperty, targetDensity);
      }
      this.addWindowDragHotArea();
      this.screenDpiDensity = targetDensity;
      this.presenter.updateScreenDensity(targetDensity);
    }
  }

  private isEmptyInSplitState(): boolean {
    const splitSession = this.containerSessionList.filter((containerSession: SCBSceneContainerSession) => {
      if (containerSession.isNotSupportSplit) {
        return false;
      }
      if (containerSession.screenProperty.screenId !== this.screenProperty.screenId) {
        return false;
      }
      if (!containerSession.isPreSplitSession() && SCBRecentNotShowViewModel.isNotShowInRecent(containerSession)) {
        return false;
      }
      return true;
    })
    return this.isSplitState() && splitSession.length === 1 && splitSession[0]?.isSplit && this.isPairSplit;
  }

  private isCurScreenContainerEmpty(): boolean {
    return this.mRecentSessionsViewModel.getRecentSessionList().length === 0;
  }

  private addWindowDragHotArea(): void {
    log.showInfo('addWindowDragHotArea start!');
    const iconTopRect: RectInfo = new RectInfo();
    iconTopRect.left = vp2px(WINDOW_HOTAREA_MARGIN);
    iconTopRect.top = vp2px(0);
    iconTopRect.right = this.screenProperty.width - vp2px(WINDOW_HOTAREA_MARGIN);
    iconTopRect.bottom = vp2px(WINDOW_HOTAREA_MARGIN);
    sceneSessionManager.addWindowDragHotArea(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_TOP, iconTopRect);
    this.updateHotAreaWhenUnfoldedHorizontal();
  }

  private updateHotAreaWhenUnfoldedHorizontal(): void {
    const iconLeftRect: RectInfo = new RectInfo();
    iconLeftRect.left = vp2px(0);
    iconLeftRect.top = vp2px(WINDOW_HOTAREA_MARGIN);
    iconLeftRect.right = vp2px(WINDOW_HOTAREA_MARGIN);
    iconLeftRect.bottom = this.screenProperty.height - vp2px(WINDOW_HOTAREA_MARGIN);
    sceneSessionManager.addWindowDragHotArea(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_LEFT, iconLeftRect);

    const iconRightRect: RectInfo = new RectInfo();
    iconRightRect.left = this.screenProperty.width - vp2px(WINDOW_HOTAREA_MARGIN);
    iconRightRect.top = vp2px(WINDOW_HOTAREA_MARGIN);
    iconRightRect.right = this.screenProperty.width;
    iconRightRect.bottom = this.screenProperty.height - vp2px(WINDOW_HOTAREA_MARGIN);
    sceneSessionManager.addWindowDragHotArea(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT, iconRightRect);
  }

  private updateHotAreaWhenUnfoldedVertical(): void {
    const iconLeftTopRect: RectInfo = new RectInfo();
    iconLeftTopRect.left = vp2px(0);
    iconLeftTopRect.top = vp2px(WINDOW_HOTAREA_MARGIN);
    iconLeftTopRect.right = vp2px(WINDOW_HOTAREA_MARGIN);
    iconLeftTopRect.bottom = this.screenProperty.height / 2;
    sceneSessionManager.addWindowDragHotArea(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_LEFT, iconLeftTopRect);

    const iconRightTopRect: RectInfo = new RectInfo();
    iconRightTopRect.left = this.screenProperty.width - vp2px(WINDOW_HOTAREA_MARGIN);
    iconRightTopRect.top = vp2px(WINDOW_HOTAREA_MARGIN);
    iconRightTopRect.right = this.screenProperty.width;
    iconRightTopRect.bottom = this.screenProperty.height / 2;
    sceneSessionManager.addWindowDragHotArea(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT, iconRightTopRect);
  }

  private getWindowMaxHeight(): number {
    const screenHeightInVp = px2vp(this.screenProperty.height);
    const topArea: ViewArea = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
    let statusBarHeight: number = topArea !== undefined ? styleMgr.px2vpStatusBarPCHeight() : 0;
    let maxHeight = screenHeightInVp - statusBarHeight - this.dockHeight;
    return maxHeight;
  }

  private initRecentData(): void {
    const sysUIBottomHeight = this.mLayoutViewModel.getSysUIBottomHeight();
    this.dockHeight = this.mLayoutViewModel.getDockHeight();
    this.windowMaxHeight = this.getWindowMaxHeight();
    let workSpaceHeight = this.screenHeight - sysUIBottomHeight - this.dockHeight;
    let pcUsableScreenHeight = workSpaceHeight - StyleConstants.DEFAULT_PC_BAR_HEIGHT;
    this.scrollBarHeight = pcUsableScreenHeight * SCBRecentStyleConstants.SCROLL_BAR_HEIGHT_PERCENT;
    this.scrollBarOffsetX = this.screenWidth - SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT;
    this.scrollBarOffsetY = workSpaceHeight / 2 - this.scrollBarHeight / 2;
    this.recentStyleManager = SCBRecentStyleManager.getInstance({extendScreenId: this.screenProperty.screenId});
    this.recentSubSceneViewModel.updateScreenID(this.screenProperty.screenId);
    this.recentPanelViewModel.updateRsID(this.screenProperty.rsId);
  }

  private getUsableScreenHeight(): number {
    const sysUIBottomHeight: number = this.mLayoutViewModel.getSysUIBottomHeight();
    return this.screenHeight - sysUIBottomHeight - this.dockHeight - StyleConstants.DEFAULT_PC_BAR_HEIGHT;
  }

  private updateScrollBar(): void {
    this.updateIsShowScrollBar();
    let height = this.mRecentSessionsViewModel.getCurrentShowHeight();
    let width = this.mRecentSessionsViewModel.getCurrentShowWidth();
    let offsetX = this.mRecentSessionsViewModel.getSplitOffsetX();
    let offsetY = this.mRecentSessionsViewModel.getSplitOffsetY();
    const recentStyle: SCBRecentStyle = this.recentStyleManager.getStyle();
    if (!recentStyle.isSplitStyle) {
      height -= recentStyle.getDockAndLogoGap();
    }
    const scrollBarStyles: number[] = recentStyle.getScrollBarStyles(height, width, offsetX, offsetY);
    this.scrollBarHeight = scrollBarStyles[0];
    this.scrollBarOffsetX = scrollBarStyles[2];
    this.scrollBarOffsetY = scrollBarStyles[3];
    this.scrollBarTextHeight = this.getUsableScreenHeight() / this.scrollStackHeight * this.scrollBarHeight;
  }

  private isRecentState(): boolean {
    return this.scenePanelState === ScenePanelState.RECENT;
  }

  private isSplitState(): boolean {
    return this.scenePanelState === ScenePanelState.SPLIT;
  }

  private isRecentOrSplitState(): boolean {
    return this.isRecentState() || this.isSplitState();
  }

  private getScrollbarPosition(): Position {
    return { x: this.scrollBarOffsetX, y: this.scrollBarOffsetY };
  }

  private getEmptyRecentViewSize(): SizeOptions {
    let viewWidth: number = this.mRecentSessionsViewModel.getCurrentShowWidth();
    const recentStyle: SCBRecentStyle = this.recentStyleManager.getStyle();
    let emptyViewHeight: number = recentStyle.getUsableScreenHeight(recentStyle.bPanel.height);
    if (emptyViewHeight <= 0 || recentStyle.isSplitStyle) {
      emptyViewHeight = this.mRecentSessionsViewModel.getCurrentShowHeight();
    }
    this.emptyViewHeight = emptyViewHeight;
    recentLog.showInfo('getEmptyRecentViewSize screenId: %{public}d, viewWidth: %{public}d, viewHeight= %{public}d ',
      this.screenProperty.screenId, viewWidth, emptyViewHeight);
    return { width: viewWidth, height: this.emptyViewHeight };
  }

  private getEmptyRecentViewPosition(): Position {
    let positionX: number = this.mRecentSessionsViewModel.getSplitOffsetX();
    let positionY: number = this.mRecentSessionsViewModel.getSplitOffsetY();
    recentLog.showInfo('getEmptyRecentViewPosition screenId: %{public}d, positionX: %{public}d, positionY: %{public}d, isSplitRecentPrimary: %{public}s',
      this.screenProperty.screenId, positionX, positionY, this.isSplitRecentPrimary);
    return { x: positionX, y: positionY };
  }

  private closeSceneArray(): void {
    let frontScene = this.queryFront();
    let count = frontScene.length;
    let indexGroup1 = 0;
    let indexGroup2 = 1;
    for (let i: number = 0; i < count; i++) {
      let sceneIndex = count - 1 - i;
      let sceneContainer = frontScene[sceneIndex];

      // Make scene unFocusable and unTouchable, avoid responding keyboard input
      if (sceneContainer.primarySession) {
        sceneContainer.primarySession.isFocusable = false;
        sceneContainer.primarySession.isTouchable = false;
      }
      if (sceneContainer.secondarySession) {
        sceneContainer.secondarySession.isFocusable = false;
        sceneContainer.secondarySession.isTouchable = false;
      }
    }
    if (count > indexGroup1) {
      PowerStatusChangeAnimationController.closeSceneArray(() => {
        this.closeSceneCallbackGroup1(frontScene[count - 1 - indexGroup1]);
      }, PowerStatusChangeAnimationController.SCENE_DURATION_GROUP_1,
        PowerStatusChangeAnimationController.SCENE_CURVE_GROUP_1);
    }
    if (count > indexGroup2) {
      PowerStatusChangeAnimationController.closeSceneArray(() => {
        this.closeSceneCallbackGroup2(frontScene[count - 1 - indexGroup2]);
      }, PowerStatusChangeAnimationController.SCENE_DURATION_GROUP_2,
        PowerStatusChangeAnimationController.SCENE_CURVE_GROUP_2);
    }
    PowerStatusChangeAnimationController.closeSceneArray(() => {
      for (let i: number = 0; i < (count - 1 - indexGroup2); i++) {
        this.closeSceneCallbackGroup3(frontScene[i]);
      }
    }, PowerStatusChangeAnimationController.SCENE_DURATION_GROUP_3,
      PowerStatusChangeAnimationController.SCENE_CURVE_GROUP_3);
  }

  private closeSceneCallbackGroup1(sceneContainer: SCBSceneContainerSession): void {
    if (!sceneContainer.primarySession) {
      return;
    }
    sceneContainer.primarySession.blurRadius = PowerStatusChangeAnimationController.BLUR_RADIUS;
    sceneContainer.primarySession.opacity = PowerStatusChangeAnimationController.OPACITY_RATIO;
    sceneContainer.primarySession.scaleX = PowerStatusChangeAnimationController.SCENE_SCALE_RATIO_GROUP_1;
    sceneContainer.primarySession.scaleY = PowerStatusChangeAnimationController.SCENE_SCALE_RATIO_GROUP_1;
  }

  private closeSceneCallbackGroup2(sceneContainer: SCBSceneContainerSession): void {
    if (!sceneContainer.primarySession) {
      return;
    }
    sceneContainer.primarySession.blurRadius = PowerStatusChangeAnimationController.BLUR_RADIUS;
    sceneContainer.primarySession.opacity = PowerStatusChangeAnimationController.OPACITY_RATIO;
    sceneContainer.primarySession.scaleX = PowerStatusChangeAnimationController.SCENE_SCALE_RATIO_GROUP_2;
    sceneContainer.primarySession.scaleY = PowerStatusChangeAnimationController.SCENE_SCALE_RATIO_GROUP_2;
  }

  private closeSceneCallbackGroup3(sceneContainer: SCBSceneContainerSession): void {
    if (!sceneContainer.primarySession) {
      return;
    }
    sceneContainer.primarySession.blurRadius = PowerStatusChangeAnimationController.BLUR_RADIUS;
    sceneContainer.primarySession.opacity = PowerStatusChangeAnimationController.OPACITY_RATIO;
    sceneContainer.primarySession.scaleX = PowerStatusChangeAnimationController.SCENE_SCALE_RATIO_GROUP_3;
    sceneContainer.primarySession.scaleY = PowerStatusChangeAnimationController.SCENE_SCALE_RATIO_GROUP_3;
  }

  private registerPowerStatusChangeAnimation(): void {
    const exitRecentViewWithAnimation = (): boolean => {
      if (this.scenePanelState !== ScenePanelState.RECENT) {
        return false;
      }
      this.exitRecentView();
      return true;
    }
    PowerStatusChangeAnimationController.getInstance().registerExitRecentViewCallback(exitRecentViewWithAnimation);

    let exitSplitView = (): boolean => {
      const topActiveSplitSceneContainerSession = this.getTopActiveSplitSceneContainerSession();
      let isSplit = topActiveSplitSceneContainerSession?.isSplit;
      log.showDebug('isSplit = ' + isSplit);
      if (!isSplit) {
        return false;
      }
      let persistentId = topActiveSplitSceneContainerSession?.getPersistentId();
      this.exitSplitViewWhenShutdown(persistentId);
      return true;
    }
    PowerStatusChangeAnimationController.getInstance().registerExitSplitViewCallback(exitSplitView);

    let exitFullScreen = (): boolean => {
      if (this.containerSessionList.length === 0) {
        log.showError('recalculateSceneShape ' +
          'Failed to find active scene container session with list length 0.');
        return false;
      }

      for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
        let containerSession = this.containerSessionList[i];
        if (containerSession?.isActive && this.doExitFullScreen(containerSession)) {
          return true;
        }
      }
      log.showError('no active full screen session');
      return false;
    }
    PowerStatusChangeAnimationController.getInstance().registerExitFullScreenCallback(exitFullScreen);

    let exitAppDialogAnimation = (): boolean => {
      let hasDialog = false;
      this.getUIContext()?.animateTo({
        duration: PowerStatusChangeAnimationController.DIALOG_DURATION,
      }, () => {
        hasDialog = this.exitDialog();
      })
      return hasDialog;
    }
    PowerStatusChangeAnimationController.getInstance().registerExitAppDialogCallback(exitAppDialogAnimation);
  }

  private getTopActiveSplitSceneContainerSession(): SCBSceneContainerSession | null {
    if (this.containerSessionList.length === 0) {
      log.showError('getTopActiveSplitSceneContainerSession ' +
        'Failed to find active scene container session with list length 0.');
      return null;
    }
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      if (this.containerSessionList[i].isActive && this.containerSessionList[i].isSplit) {
        return this.containerSessionList[i];
      }
    }
    log.showError('no active split session');
    return null;
  }

  private exitSplitViewWhenShutdown(persistentId: number | undefined): void {
    this.presenter.exitSplitViewWhenShutdown(persistentId);
  }

  private doExitFullScreen(containerSession: SCBSceneContainerSession): boolean {
    let primarySession = containerSession?.primarySession;
    let secondarySession = containerSession?.secondarySession;
    return this.handleFullScreenSession(primarySession) || this.handleFullScreenSession(secondarySession);
  }

  private handleFullScreenSession(sceneSession: SCBSceneSession | null): boolean {
    if (sceneSession?.sceneInfo?.windowMode !== SCBSceneMode.FULLSCREEN) {
      return false;
    }
    log.showDebug('do exit app dialog from list.');
    SCBSceneSessionManager.getInstance()
      .requestFocus(sceneSession.session.persistentId, undefined, FocusChangeReason.FULL_SCREEN);
    SCBSceneSessionManager.getInstance()
      .requestToTop(sceneSession.sceneInfo.screenId, sceneSession.session.persistentId);
    sceneSession.recover();
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    return true;
  }

  private exitDialog(): boolean {
    let frontScene = this.queryFront();
    let hasDialog = false;
    frontScene.forEach((container: SCBSceneContainerSession) => {
      let hasExitPriSubList = this.doExitDialog(container.primarySession?.subSessionList);
      let hasExitSecSubList = this.doExitDialog(container.secondarySession?.subSessionList);
      let hasExitPriDialogList = this.doExitDialog(container.primarySession?.dialogSessionList);
      let hasExitSecDialogList = this.doExitDialog(container.secondarySession?.dialogSessionList);
      hasDialog = hasExitPriSubList || hasExitSecSubList || hasExitPriDialogList || hasExitSecDialogList;
    })
    return hasDialog;
  }

  private doExitDialog(dialogList: SCBSpecificSceneSessionList | undefined): boolean {
    if (!dialogList || dialogList.length <= 0) {
      return false;
    }
    log.showDebug('do exit app dialog from list.');
    dialogList.forEach((session: SCBSpecificSession) => {
      session.opacity = PowerStatusChangeAnimationController.OPACITY_RATIO;
    })
    return true;
  }

  private handleSceneWhenUnlockScreen(frontScene: SCBSceneContainerSession[]): void {
    if (!LockScreenAnimationController.getInstance().isPlayDefaultUnlockAnimation()) {
      return;
    }
    let invisibleScene: SCBSceneContainerSession[] = [];
    let visibleScene: SCBSceneContainerSession[] = [];

    // 1. split array
    frontScene.forEach((scene: SCBSceneContainerSession) => {
      if (scene.invisible.value) {
        invisibleScene.push(scene);
        log.showInfo(`invisible winId:${scene.primarySession?.session.persistentId}`);
      } else {
        visibleScene.push(scene);
      }
    })

    // 2. do visible scene animation
    log.showInfo(`frontScene:${frontScene.length} visible:${visibleScene.length}`);
    if (frontScene.length !== 0 && visibleScene.length !== 0) {
      frontScene = visibleScene;
    }
    frontScene.forEach((scene: SCBSceneContainerSession) => {
      this.changeSceneProperty(scene, 0, 1, 0.9);
    });
    let count = frontScene.length;
    if (count > 0) {
      AppStorage.setOrCreate<boolean>('isWindowScenesUnlock', true);
    }
    let unlockScreenCallback = (): void => {
      AppStorage.setOrCreate<boolean>('isWindowScenesUnlock', false);
      invisibleScene.forEach((scene: SCBSceneContainerSession) => {
        this.changeSceneProperty(scene, 0, 1, 1);
      })
      systemAniSceneCtrl.dequeue(SystemAnimatedScene.LOCKSCREEN_TO_LAUNCHER);
    }
    let indexGroup1 = LockScreenAnimationController.SCENE_COUNT_GROUP_1;
    let indexGroup2 = LockScreenAnimationController.SCENE_COUNT_GROUP_2 + indexGroup1;
    if (count >= indexGroup1) {
      LockScreenAnimationController.getInstance().runAnimationDirectly(new CallbackParameter(() => {
        this.handleSceneWhenUnlockScreenInner(frontScene[count - indexGroup1]);
      }, LockScreenAnimationController.SCENE_CURVE_GROUP_1, 0,
        LockScreenAnimationController.SCENE_DELAY_GROUP_1,
        count > indexGroup1 ? LockScreenAnimationController.DEFAULT_FINISH : unlockScreenCallback));
    }
    if (count >= indexGroup2) {
      LockScreenAnimationController.getInstance().runAnimationDirectly(new CallbackParameter(() => {
        this.handleSceneWhenUnlockScreenInner(frontScene[count - indexGroup2]);
      }, LockScreenAnimationController.SCENE_CURVE_GROUP_2, 0,
        LockScreenAnimationController.SCENE_DELAY_GROUP_2,
        count > indexGroup2 ? LockScreenAnimationController.DEFAULT_FINISH : unlockScreenCallback));
    }
    LockScreenAnimationController.getInstance().runAnimationDirectly(new CallbackParameter(() => {
      for (let i: number = 0; i < count - indexGroup2; i++) {
        this.handleSceneWhenUnlockScreenInner(frontScene[i]);
      }
    }, LockScreenAnimationController.SCENE_CURVE_GROUP_3, 0,
      LockScreenAnimationController.SCENE_DELAY_GROUP_3,
      count === 0 || count > indexGroup2 ? unlockScreenCallback : LockScreenAnimationController.DEFAULT_FINISH));
  }

  private async handleSceneWhenPreLock(): Promise<void> {
    if (!LockScreenAnimationController.getInstance().isPlayDefaultUnlockAnimation()) {
      return;
    }
    if (sSCBOobeManager.isOobeActivated()) {
      log.showWarn('oobe activated, not handle scene when preLock.');
      return;
    }
    const frontScene = this.queryFront();
    try {
      let windowInfoList: sceneSessionManager.WindowVisibilityInfo[] =
        await sceneSessionManager.getAllWindowVisibilityInfos();
      windowInfoList.forEach((windowInfo: sceneSessionManager.WindowVisibilityInfo) => {
        frontScene.forEach((scene: SCBSceneContainerSession) => {
          if (scene.primarySession?.session.persistentId === windowInfo.windowId) {
            scene.invisible.value =
              (windowInfo.visibility === sceneSessionManager.WindowVisibility.COMPLETE_OCCLUSION);
            log.showInfo(`id:${windowInfo.windowId} scene.invisible.value:${scene.invisible.value}`);
          }
        })
      })
    } catch (error) {
      log.showError(`getAllWindowVisibilityInfos error: ${error}`);
    }
    frontScene.forEach((scene: SCBSceneContainerSession) => {
      if (scene.invisible.value) {
        this.changeSceneProperty(scene, 0, 0, 1);
      } else {
        this.changeSceneProperty(scene, 0, 1, 0.9);
      }
    })
  }

  private handleSceneWhenUnlockScreenInner(sceneContainer: SCBSceneContainerSession): void {
    if (!LockScreenAnimationController.getInstance().isPlayDefaultUnlockAnimation()) {
      return;
    }
    if (sceneContainer == null) {
      return;
    }
    this.changeSceneProperty(sceneContainer,
      LockScreenAnimationController.DEFAULT_BLUR_RADIUS,
      LockScreenAnimationController.DEFAULT_OPACITY_RATIO,
      LockScreenAnimationController.DEFAULT_SCALE_RATIO);
  }

  private changeSceneProperty(sceneContainer: SCBSceneContainerSession, blurRadius: number, opacity: number,
                              scale: number): void {
    if (sceneContainer.isSplit) {
      if (sceneContainer.needRenderAlpha) {
        sceneContainer.needRenderAlpha.setNeedRenderAlphaWithDfx(opacity, TAG, 'changeSceneProperty',
          sceneContainer.getName());
      }
      sceneContainer.primarySession?.setScale(scale, scale);
      sceneContainer.secondarySession?.setScale(scale, scale);
      sceneContainer.dividerParam.scaleX = scale;
      sceneContainer.dividerParam.scaleY = scale;
      if (sceneContainer.primarySession) {
        sceneContainer.primarySession.blurRadius = blurRadius;
      }
      if (sceneContainer.secondarySession) {
        sceneContainer.secondarySession.blurRadius = blurRadius;
      }
      return;
    }
    if (!sceneContainer.primarySession || (sceneContainer.isShowWhenLocked() && sceneContainer.isActive)) {
      log.showDebug('primarySession is null or show when locked skip.');
      return;
    }
    sceneContainer.primarySession.blurRadius = blurRadius;
    sceneContainer.primarySession.opacity = opacity;
    sceneContainer.primarySession.scaleX = scale;
    sceneContainer.primarySession.scaleY = scale;
    this.changeDialogProperty(sceneContainer.primarySession?.subSessionList, opacity);
    this.changeDialogProperty(sceneContainer.secondarySession?.subSessionList, opacity);
    this.changeDialogProperty(sceneContainer.primarySession?.dialogSessionList, opacity);
    this.changeDialogProperty(sceneContainer.secondarySession?.dialogSessionList, opacity);
  }

  private changeDialogProperty(dialogList: SCBSpecificSceneSessionList | undefined, opacity: number): void {
    if (!dialogList || dialogList.length <= 0) {
      return;
    }
    log.showDebug('change app dialog property from list.');
    dialogList.forEach((session: SCBSpecificSession) => {
      session.opacity = opacity;
    })
  }

  private getTopActiveFullSession(): SCBSceneSession | null {
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const sceneSession = this.containerSessionList[i]?.primarySession;
      if (sceneSession?.isActive && sceneSession?.sceneInfo?.windowMode === SCBSceneMode.FULLSCREEN) {
        return sceneSession;
      }
    }
    return null;
  }

  private registerUnlockTransitionController(managerInstance: SCBSceneSessionManager): void {
    this.unLockTransitionController = {
      name: `${TAG}`,
      onLock: (): void => this.onLockReceived(),
      onUnlock: (): void => this.onUnLockReceived()
    }
    managerInstance.registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  private unregisterUnlockTransitionCallback(managerInstance: SCBSceneSessionManager): void {
    if (!this.unLockTransitionController) {
      return;
    }
    managerInstance.unregisterUnlockTransitionCallback(this.unLockTransitionController);
  }

  private onLockReceived(): void {
    log.showInfo('onLockReceived scenePanelState = ' + this.scenePanelState);
    this.containerSessionList.forEach((containerSession) => {
      if (containerSession.isActive && !containerSession.isShowWhenLocked()) {
        containerSession.isDisappearing = true;
      }
    });
    AppStorage.setOrCreate('isLock', true);
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if (systemSceneSession !== null && systemSceneSession !== undefined) {
      systemSceneSession.setBackgroundColor('#00000000');
    }
  }

  private onUnLockReceived(): void {
    log.showInfo('onUnLockReceived scenePanelState = ' + this.scenePanelState);
    enterpriseRecentEvent.init();
    this.containerSessionList.forEach((containerSession) => {
      containerSession.isDisappearing = false;
      // winD清屏后立刻触发锁屏时，还原可能被加到activeList中清屏窗口的缩放、位移、透明度
      if (!containerSession.needRenderVisibility.visibility && containerSession.isActive) {
        containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'onUnlockReceived',
          containerSession.getName());
        this.setSceneOpacity(containerSession, 1);
        this.setSceneTransitionInRestoreDesktop(containerSession);
        this.resetSpecificSceneTransition(containerSession);
      }
    });
    AppStorage.setOrCreate('isLock', false);
    SCBSessionListManager.refreshZOrder();
  }

  private registerGestureBackEventCallback(): void {
    scbGestureManager.registerGestureEvent(GestureType.BACK, this.gestureSceneType,
      (navigationState?: number, event?: GestureEvent) => {
        this.processGestureBackEvent(GestureType.BACK, event);
      })
  }

  private exitSplitViewInSplit() {
    let curActiveContainerSession = this.containerSessionList.getTopActiveSession();
    if (curActiveContainerSession?.isSplit) {
      let persistentId: number | undefined = curActiveContainerSession.primarySession ?
        curActiveContainerSession.primarySession.session?.persistentId :
        curActiveContainerSession.secondarySession?.session?.persistentId;
      this.exitSplitView(persistentId);
    }
  }

  private processGestureBackEvent(gestureType: GestureType, event?: GestureEvent) {
    log.showInfo(`processGestureBackEvent this.scenePanelState: ${this.scenePanelState}`);
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId);
    if (focusedSession && focusedSession.session?.type === sceneSessionManager.SessionType.TYPE_GLOBAL_SEARCH) {
      log.showInfo('processGestureBackEvent closeHosKey');
      SCBSceneSessionManager.getInstance().requestUnfocus(focusedSession.session.persistentId);
      return;
    }
    switch (this.scenePanelState) {
      case ScenePanelState.RECENT: {
        this.exitRecentView();
        break;
      }
      case ScenePanelState.SPLIT: {
        log.showInfo('send GestureBack to SPLIT');
        if (SCBSceneSessionManager.getInstance().processSystemBackEvent(this.screenProperty.screenId)) {
          return;
        }
        if (this.isSplitState()) {
          this.exitSplitViewInSplit();
        }
        break;
      }
      case ScenePanelState.APP_CENTER: {
        log.showInfo('send GestureBack to APP_CENTER');
        this.exitAppCenterView();
      }
      case ScenePanelState.HOME: {
        if (SCBSceneSessionManager.getInstance().processSystemBackEvent(this.screenProperty.screenId)) {
          log.showInfo('processSystemBackEvent');
          return;
        }
        sceneSessionManager.processBackEvent();
        break;
      }
      default:
        break;
    }
  }

  private registerGestureNavigationEventCallback(): void {
    scbGestureManager.registerGestureEvent(GestureType.NAVIGATION, this.gestureSceneType,
      (type: GestureNavigationState, event: GestureEvent) => {
        log.showInfo(`registerGestureNavigationEventCallback type: ${type.toString()}`)
        switch (type) {
          case GestureNavigationState.START: {
            this.processNavigationStartEvent(event);
            break;
          }
          case GestureNavigationState.UPDATE: {
            this.processNavigationUpdateEvent(event);
            break;
          }
          case GestureNavigationState.END: {
            this.processNavigationEndEvent(event);
            break;
          }
          case GestureNavigationState.CANCEL: {
            this.processNavigationCancelEvent(event);
            break;
          }
          default:
            break;
        }
      })
  }

  private registerAnimateCallback(managerInstance: SCBSceneSessionManager): void {
    managerInstance.registerAnimationCallback((screenId: number, persistentId: number) => {
      if (this.screenProperty.screenId !== screenId) {
        log.showError(`screen id not same width (${this.screenProperty.screenId}, ${screenId})`);
        return;
      }
      let containerSession: SCBSceneContainerSession | null =
        this.getSceneContainerSessionWithPersistentId(persistentId);
      if (!containerSession || !this.canDoScaleAnimation(containerSession)) {
        containerSession?.primarySession?.resetAnimationProperty();
        return;
      }
      this.doScaleAnimation(containerSession);
    }, this.screenProperty.screenId);
  }

  private canDoScaleAnimation(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      log.showWarn('can not do animation with null');
      return false;
    } else if (this.scenePanelState === ScenePanelState.RECENT || this.scenePanelState === ScenePanelState.APP_CENTER) {
      // 多任务 应用中心场景 不做动效
      log.showWarn(`can not do animation with scenePanelState ${this.scenePanelState}`);
      return false;
    } else if (this.isLock) {
      // 锁屏场景不做动效
      log.showWarn('can not do animation with lock screen');
      return false;
    } else if (containerSession.isSplit) {
      // 分屏场景不做动效
      log.showWarn('can not do animation in split');
      return false;
    } else if (!containerSession.isActive || !containerSession.needRenderVisibility?.visibility) {
      // 后台场景不做动效
      log.showWarn('can not do animation in background');
      return false;
    }
    return true;
  }

  private unregisterAnimateCallback(managerInstance: SCBSceneSessionManager): void {
    managerInstance.unregisterAnimationCallback(this.screenProperty.screenId);
  }

  private processNavigationCancelEvent(event: GestureEvent): void {
    log.showInfo('processNavigationCancelEvent event');
    this.isHandleThreeFingerSwiper = false;
    this.isOneFingerUp = false;
  }

  private processNavigationStartEvent(event: GestureEvent): void {
    log.showInfo('processNavigationStartEvent event');
    this.consumeStartEvent(event);
  }

  private consumeStartEvent(event: GestureEvent): void {
    log.showInfo('consumeStartEvent')
    this.isOneFingerUp = true;
    gestureHelperInstance.reset();
    gestureHelperInstance.invoke(event);
  }

  private processNavigationUpdateEvent(event: GestureEvent): void {
    log.showInfo(`processNavigationUpdateEvent Update event`);
    this.consumeUpdateEvent(event);
  }

  private consumeUpdateEvent(event: GestureEvent): void {
    gestureHelperInstance.invoke(event);
  }

  private processNavigationEndEvent(event: GestureEvent): void {
    log.showInfo(`processNavigationENDEvent END event  scenePanelState: ${this.scenePanelState}`);
    this.consumeEndEvent(event);
  }

  private consumeEndEvent(event: GestureEvent): void {
    log.showInfo('consumeEndEvent');
    // 与三指上滑保持一致，被锁屏打断不触发end事件
    if (this.isLock) {
      log.showWarn('not consumeEndEvent, isLocked.');
      this.isOneFingerUp = false;
      return;
    }
    this.isOneFingerUp = false;
  }

  private unregisterGestureNavigationEventCallback(): void {
    scbGestureManager.unRegisterGestureEvent(GestureType.NAVIGATION, this.gestureSceneType);
  }

  private unregisterGestureBackEventCallback(): void {
    scbGestureManager.unRegisterGestureEvent(GestureType.BACK, this.gestureSceneType);
  }

  private propertyChangeScenePanelCallback = (
    screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
    log.showDebug('ScenePanel screen callback is called');
    this.onScreenPropertyChange(screenProperty, reason);
  }

  private initSceneSessionManager(): void {
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListCallback(
      this.getContainerSessionListCallback, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListNotShowRecentCallback(
      this.getContainerSessionListNotShowRecentCallback, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance()
      .registerGetAllContainerSessionListCallback(this.getAllContainerSessionListCallback);
    SCBSceneSessionManager.getInstance().registerAddExtendContainerSessionCallback(
      this.addExtendSceneContainerSession, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerAddExtendNotShowRecentContainerSessionCallback(
      this.addExtendNotShowRecentSceneContainerSession, this.screenProperty.screenId);
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback(
      this.propertyChangeScenePanelCallback, SCBDefaultZIndex.SCENE_PANEL, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerGetScenePanelStateCallback(this.screenProperty.screenId,
      SCBDefaultZIndex.SCENE_PANEL, () => {
        return this.scenePanelState;
      });
    SCBSceneSessionManager.getInstance().registerStatusBarRecoverCallback((isShowSystemBar: boolean) => {
      this.recoverStatusBar(isShowSystemBar);
    }, this.screenProperty.screenId);
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().registerStatusBarTypeChangeCallback(this.statusBarTypeChangeCallback);
    }
    SCBSceneSessionManager.getInstance()
      .registerHandleSceneWhenPreLock(this.screenProperty.screenId, this.handleSceneWhenPreLockCallback);
  }

  private statusBarTypeChangeCallback = (): void => {
    let screenId = this.screenProperty.screenId;
    let statusBarHeightPx: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar) {
      statusBarHeightPx = statusBar.currRect.height.getPx();
    }
    let dialogSceneList: SCBSpecificSession[] = [];
    for (let containerSession of [...this.containerSessionList, ...this.containerSessionListNotShowRecent]) {
      if (!containerSession.isSplit && containerSession.primarySession) { // float and fullscreen scene
        this.updateRectToAvoidStatusBar(containerSession.primarySession, statusBarHeightPx);
        if (containerSession.primarySession.subSessionList !== null) {
          this.traverseSubList(containerSession.primarySession.subSessionList, dialogSceneList);
        }
        continue;
      }

      if (containerSession.isSplit && containerSession.primarySession && containerSession.secondarySession) {
        if (containerSession.dividerParam.isExpandUpDownSplit()) { // Up down split scene
          let upperSession = containerSession.primarySession;
          let lowerSession = containerSession.secondarySession;
          if (!containerSession.dividerParam.isSplitPrimaryMode) {
            lowerSession = containerSession.primarySession;
            upperSession = containerSession.secondarySession;
          }
          let upperHeight = upperSession.currRect.height.getPx();
          let lowerHeight = lowerSession.currRect.height.getPx();
          if (statusBarHeightPx !== 0) {
            upperHeight = upperHeight - statusBarHeightPx / 2;
            lowerHeight = lowerHeight - statusBarHeightPx / 2;
          } else {
            upperHeight = upperHeight + upperSession.currRect.top.getPx() / 2;
            lowerHeight = lowerHeight + upperSession.currRect.top.getPx() / 2;
          }
          containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.primarySession?.session.markSystemSceneUIFirst(true, false);
          containerSession.secondarySession?.session.markSystemSceneUIFirst(true, false);
          if (upperSession.lastRect.top.getPx() < statusBarHeightPx) {
            upperSession.lastRect.setPosNum(upperSession.lastRect.left.getPx(), statusBarHeightPx);
          }
          if (lowerSession.lastRect.top.getPx() < statusBarHeightPx) {
            lowerSession.lastRect.setPosNum(lowerSession.lastRect.left.getPx(), statusBarHeightPx);
          }
          this.getUIContext()?.animateTo({
            duration: 150,
            onFinish: () => {
              if (containerSession.dividerParam.isSplitPrimaryMode) {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
              } else {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
              }
              containerSession.primarySession?.session.markSystemSceneUIFirst(false, false);
              containerSession.secondarySession?.session.markSystemSceneUIFirst(false, false);
            }
          }, () => {
            containerSession.dividerParam.primary.height = (upperHeight / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.secondary.height = (lowerHeight / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.positionY = `${px2vp(statusBarHeightPx + upperHeight)}`;
            SCBSplitLayoutHelper.refreshSplitContainer(containerSession, this.screenProperty, this.getUIContext());
            SCBSceneSessionManager.getInstance().updateSystemBarProperty();
          })
        } else { // left right split scene
          let height = containerSession.secondarySession.currRect.height.getPx() +
          containerSession.secondarySession.currRect.top.getPx() - (this.isDockAutoHide ? 0 : statusBarHeightPx);
          containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.RESIZE);
          containerSession.primarySession?.session.markSystemSceneUIFirst(true, false);
          containerSession.secondarySession?.session.markSystemSceneUIFirst(true, false);
          if (containerSession.primarySession.lastRect.top.getPx() < statusBarHeightPx) {
            containerSession.primarySession.lastRect
              .setPosNum(containerSession.primarySession.lastRect.left.getPx(), statusBarHeightPx);
          }
          if (containerSession.secondarySession.lastRect.top.getPx() < statusBarHeightPx) {
            containerSession.secondarySession.lastRect
              .setPosNum(containerSession.secondarySession.lastRect.left.getPx(), statusBarHeightPx);
          }
          this.getUIContext()?.animateTo({
            duration: 150,
            onFinish: () => {
              if (containerSession.dividerParam.isSplitPrimaryMode) {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
              } else {
                containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
                containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
              }
              containerSession.primarySession?.session.markSystemSceneUIFirst(false, false);
              containerSession.secondarySession?.session.markSystemSceneUIFirst(false, false);
            }
          }, () => {
            containerSession.dividerParam.primary.height = (height / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.secondary.height = (height / this.screenProperty.height * 100) + '%';
            containerSession.dividerParam.positionY = `${this.isDockAutoHide ? 0 : px2vp(statusBarHeightPx)}`;
            containerSession.dividerParam.dividerHeight = px2vp(height);
            SCBSplitLayoutHelper.refreshSplitContainer(containerSession, this.screenProperty, this.getUIContext());
            SCBSceneSessionManager.getInstance().updateSystemBarProperty();
          })
        }
        if (containerSession.primarySession.subSessionList !== null) {
          this.traverseSubList(containerSession.primarySession.subSessionList, dialogSceneList);
        }
        if (containerSession.secondarySession.subSessionList !== null) {
          this.traverseSubList(containerSession.secondarySession.subSessionList, dialogSceneList);
        }
      }
    }

    if (dialogSceneList.length > 0) {
      dialogSceneList.forEach((sceneSession) => {
        this.updateSpecificRectToAvoidStatusBar(sceneSession, statusBarHeightPx);
      })
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();

    if (statusBarHeightPx === 0) { //hide status bar no need to update sub window and input method window
      return;
    }

    let systemSceneList: SCBSpecificSceneSessionList =
      SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR);
    if (systemSceneList.length > 0) {
      systemSceneList.forEach((sceneSession) => {
        this.updateSpecificRectToAvoidStatusBar(sceneSession, statusBarHeightPx);
      })
    }
  }

  private updateRectStatusBarWithSwitch(containerSession: SCBSceneContainerSession,
    session: SCBSceneSession, statusBarHeightPx: number, dockHeight: number): void {
    if (session.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      let height: number = 0;
      let top: number = 0;
      top = statusBarHeightPx;
      height = session.currRect.height.getPx() + session.currRect.top.getPx() - statusBarHeightPx - dockHeight;
      log.showInfo(`updateRectToAvoidStatusBar setRectNum rect: ${session.currRect.printPx()}`);
      this.getUIContext()?.animateTo({
        duration: 150
      }, () => {
        session.currRect.setRectNum(session.currRect.left.getPx(), top, session.currRect.width.getPx(), height);
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      })
      if (session.lastRect.top.getPx() < statusBarHeightPx) {
        session.lastRect.setPosNum(session.lastRect.left.getPx(), statusBarHeightPx);
      }
      return;
    }
    let newRect = session.currRect.copy();
    if (session.sceneInfo.windowMode === SCBSceneMode.FLOATING && newRect.top.getPx() < statusBarHeightPx) {
      newRect.setPosNum(newRect.left.getPx(), statusBarHeightPx);
      this.getUIContext()?.animateTo({
        duration: 150
      }, () => {
        session.currRect.setPosNum(newRect.left.getPx(), newRect.top.getPx());
      })
    }
  }

  private updateRectToAvoidStatusBar(session: SCBSceneSession, statusBarHeightPx: number): void {
    if ((session.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) && !session.layoutFullScreen) {
      let left = session.currRect.left.getPx();
      let top = statusBarHeightPx;
      let width = session.currRect.width.getPx();
      let height = session.currRect.height.getPx() + session.currRect.top.getPx() - statusBarHeightPx;
      log.showInfo(`updateRectToAvoidStatusBar setRectNum rect: [${session.currRect.left.getPx()}, ${session.currRect.top.getPx()}, ` +
        `${session.currRect.width.getPx()}, ${session.currRect.height.getPx()}]`);
      this.getUIContext()?.animateTo({
        duration: 150
      }, () => {
        session.currRect.setRectNum(left, top, width, height);
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      })
      if (session.lastRect.top.getPx() < statusBarHeightPx) {
        session.lastRect.setPosNum(session.lastRect.left.getPx(), statusBarHeightPx);
      }
      return;
    }
    let newRect = session.currRect.copy();
    if (session.sceneInfo.windowMode === SCBSceneMode.FLOATING && newRect.top.getPx() < statusBarHeightPx) {
      newRect.setPosNum(newRect.left.getPx(), statusBarHeightPx);
      this.getUIContext()?.animateTo({
        duration: 150
      }, () => {
        session.currRect.setPosNum(newRect.left.getPx(), newRect.top.getPx());
      })
    }
  }

  private updateSpecificRectToAvoidStatusBar(session: SCBSpecificSession, statusBarHeightPx: number): void {
    if (session.windowMode === SCBSceneMode.FULLSCREEN && session.layoutFullScreen) {
      log.showInfo('layoutFullScreen session need not avoid status bar. statusBarHeightPx: ' + statusBarHeightPx);
      return;
    } else if (session.windowMode === SCBSceneMode.FULLSCREEN && !session.layoutFullScreen) {
      session.onUpdateMaximizeRect();
      return;
    } else if (this.isFullScreenSpecificSession(session)) {
      log.showInfo('full screen specific session do not need to avoid status bar.');
      return;
    }
    let top = session.currRect.top.getPx();
    if (top < statusBarHeightPx) {
      this.getUIContext()?.animateTo({
        duration: 150
      }, () => {
        session.currRect.setPosNum(session.currRect.left.getPx(), statusBarHeightPx);
      })
    }
  }

  private isFullScreenSpecificSession(session: SCBSpecificSession): boolean {
    if (!session) {
      log.showError(`isFullScreenSpecificSession session is null`);
      return false;
    }
    let top = session.currRect.top.getPx();
    let screenRect = new SCBSessionRect(this.screenProperty.left, this.screenProperty.top,
      this.screenProperty.width, this.screenProperty.height);
    return session.currRect.equals(screenRect);
  }

  private isOnDesktop(): boolean {
    const foregroundWindowCount: number = this.queryFront().length;
    log.showInfo(`foregroundWindowCount is ${foregroundWindowCount}`);

    const isDesktop: boolean =
      !viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) && this.scenePanelState !== ScenePanelState.RECENT;
    return foregroundWindowCount <= 0 && isDesktop;
  }

  private getContainerListWhenUnlockScreen(): SCBSceneContainerSession[] {
    let activeContainerList: SCBSceneContainerSession[] = [];
    let activeSessionList = SCBSceneSessionManager.getInstance().getActiveSessionList();
    const len = activeSessionList.length;
    for (let i = 0; i < len; i++) {
      let activeId = activeSessionList[i];
      let containerSession = SCBSceneSessionManager.getInstance()
        .getSceneContainerSessionFromScenePanel(activeId, this.screenProperty.screenId);
      if (!containerSession) {
        log.showWarn('[SCBMain]container of session id:' + activeId + ' is not shown');
        continue;
      }
      activeContainerList.push(containerSession);
    }
    AppStorage.setOrCreate('activeSceneNum', activeContainerList.length);
    return activeContainerList;
  }

  initRecentFocusController(): void {
    this.mRecentFocusController.registerRecentFocusModel({
      setRecentSelectedIndexCallback : ((index: number) => { this.updateSelectedIndex(index); }),
      getRecentSelectedIndexCallback: (() => { return this.selectedIndex; }),
    })
  }

  aboutToAppear() {
    this.init();
    this.presenter.onStart();
    this.sysSceneSession.setVisibility(true);
    this.sysSceneSession.setActive(true);
    this.sysSceneSession.visibility = true;

    this.initSceneSessionManager();
    this.mRecentSessionsViewModel.setScreenProperty(this.screenWidth, this.screenHeight);
    this.mRecentSessionsViewModel.setRecentProperty(0, 0, this.screenWidth,
      this.screenHeight - LayoutViewModel.getInstance().getDockHeight());
    this.mRecentFeatureBridge = SCBRecentFeatureBridge.getInstance();
    this.initRecentFocusController();
    this.showRecent = false;
    WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
    viewMgrPolicy.registerViewCallback(ViewType.APP_CENTER, this.appCenterViewCallback);
    this.registerPowerStatusChangeAnimation();
    this.addWindowDragHotArea();
    LockScreenAnimationController.getInstance()
      .addCallback(LockScreenAnimationController.SCENE_ARRAY_CALLBACK, this.screenProperty.screenId);
    LockScreenAnimationController.getInstance()
      .registerCallback(LockScreenAnimationController.SCENE_ARRAY_CALLBACK + this.screenProperty.screenId,
      () => {
        this.handleSceneWhenUnlockScreen(this.getContainerListWhenUnlockScreen());
      });
    if (!this.sysSceneSession) {
      log.showWarn(`${this.systemSessionInfo.sceneName} system scene session is null! `);
      this.sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(this.systemSessionInfo);
    }
    this.sysSceneSession.setSessionTouchable(false);
    this.registerDebugCommand();
    SCBSceneSessionManager.getInstance().registerOnFocusedScreenChangeCallback(this.onFocusedScreenChangeCallback);
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SwipeGestureManager.getInstance().registerFourFingersSwipeCallback(this.onFourFingersSwipeEvent);
      FourFingerSwipeController.getInstance().setSwipeStateCallback(this);
      DesktopSwitchController.getInstance().registerVmStateCallback(this.vmStateCallback);
    }
    SCBPcScenePanelManager.getInstance().registerGetIsPairSplitCallback(() => {
      return this.isPairSplit;
    }, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerIsPairSplitCallback(() => {
      return this.isPairSplit;
    }, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerIsHandleThreeFingerSwiperCallback(() => {
      return this.isHandleThreeFingerSwiper;
    }, this.screenProperty.screenId);
    SCBPiPManager.getInstance().registerAutoStartPipStatusChange();
  }

  private debugGetContainerSession(args: string[]): string {
    return SCBScenePanelDebugCommands.getContainerSession(this.containerSessionList, args);
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'getContainerSession',
        callback: (args: string[]): string => {
          return this.debugGetContainerSession(args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG + this.screenProperty.screenId, cmds);
  }

  private unregisterDebugCommand(): void {
    DebugCommandManager.getInstance().unregister(TAG + this.screenProperty.screenId);
  }

  onFocusedScreenChangeCallback = (fromScreen: number, toScreen: number, toPersistentId: number): void => {
    log.showInfo(`onFocusedScreenChangeCallback screenId:${this.screenProperty.screenId}, ` +
      `fromScreen:${fromScreen}, toScreen:${toScreen}, toPersistentId: ${toPersistentId}`);
    if (this.screenProperty.screenId !== fromScreen) {
      return;
    }
    const curActiveContainerSession = this.containerSessionList.getTopActiveSession();
    // 焦点切换到其他屏幕上时，退出待分屏状态
    if (curActiveContainerSession && this.scenePanelState === ScenePanelState.SPLIT) {
      const persistentId = curActiveContainerSession.getPersistentId();
      // 切焦的是子窗且子窗的主窗是当前待分屏窗口，则不需要退出
      let toSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null =
        SCBSceneSessionManager.getInstance().getSessionById(toPersistentId);
      if (toSession && toSession instanceof SCBSpecificSession) {
        let toContainerSession = SCBSessionListManager.allContainerSessionList.findByPersistentId(toPersistentId, true);
        log.showInfo(`onFocusedScreenChangeCallback: persistentId: ${persistentId}, ` +
          `mainPersistentId: ${toContainerSession?.primarySession?.sceneInfo.persistentId}`);
        if (toContainerSession && toContainerSession.primarySession?.sceneInfo.persistentId === persistentId) {
          return;
        }
      }
      let param = new ExitSplitParam();
      param.needRaise = false;
      this.exitSplitView(persistentId, param);
    }
  }

  private readonly windowStatisticsEvent: DfxEvent = {
    report: (): void => {
      let count: number = 0;
      let containerSessionList: SCBSceneContainerSessionArray =
        SCBSceneSessionManager.getInstance().getContainerSessionList();
      if (!containerSessionList?.isEmpty()) {
        count = containerSessionList.length;
      }
      PcHiSysEventMgr.reportWindowStatisticsData(count);
      log.showDebug(`windowStatisticsEvent ${count}`);
    }
  }

  private readonly bAndCWindowsNumbersEvent: DfxEvent = {
    report: (): void => {
      let bCount: number = 0;
      let cCount: number = 0;
      HiSysEventUtil.reportBAndCWindowsNumbersEvent(bCount, cCount);
      log.showDebug(`HalfFold Status BWindowCounts: ${bCount} CWindowCounts: ${cCount}`);
    }
  }

  private init(): void {
    this.screenHeight = this.getUIContext().px2vp(this.screenProperty.height);
    this.screenWidth = this.getUIContext().px2vp(this.screenProperty.width);
    this.scrollStackHeight = this.screenHeight;
    this.initRecentData();
    this.registerCallback();
    this.mSmartDockViewModel = PcSmartDockViewModel.getInstance();
    reportIntervalMgr.registerEvent(this.windowStatisticsEvent);
    reportIntervalMgr.registerEvent(this.bAndCWindowsNumbersEvent);
    const screenID: number = this.screenProperty.screenId;
    SCBPcScenePanelManager.getInstance().registerUIContext(this.getUIContext(), this.screenProperty.screenId);
    this.recentPanelViewModel.registerExitRecentViewCallback((needAni: boolean) => this.exitRecentView(needAni));
  }

  private resetCurSessionRecentInfo(): void {
    this.containerSessionList.forEach(containerSession => {
      this.recentMinBackground.destroyRecentMinBackground(containerSession, 'panel destroy');
    })
  }

  aboutToDisappear(): void {
    this.presenter.onDestroy();
    SCBFreeWindowsViewModelManager.getInstance().removePresenter(this.screenProperty.screenId);
    this.onExitActiveSplit();
    this.recentPanelViewModel.unregisterExitRecentViewCallback();
    this.recentPanelViewModel.destroy();
    SCBRecentMinBackgroundViewModel.deleteInstance(this.recentMinBackground);
    SCBSceneSessionManager.getInstance().unRegisterRecoverSessionCallback(this.screenProperty.screenId);
    viewMgrPolicy.unRegisterViewCallback(ViewType.APP_CENTER, this.appCenterViewCallback);
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(
      this.sysSceneSession, this.screenProperty.screenId);
    reportIntervalMgr.unRegisterEvent(this.windowStatisticsEvent);
    reportIntervalMgr.unRegisterEvent(this.bAndCWindowsNumbersEvent);
    this.unRegisterCallback();
    SCBSceneSessionManager.getInstance()
      .unregisterAddExtendContainerSessionCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance()
      .unregisterAddExtendNotShowRecentContainerSessionCallback(this.screenProperty.screenId);
    this.mRecentFocusController.destroy();
    this.mRecentFocusManager.destroyFocusController(this.mRecentFocusController);
    this.mRecentSessionsViewModel.destroy();
    this.resetCurSessionRecentInfo();
    this.showRecent = false;
    this.memoryHelper.destroy();
    this.unregisterDebugCommand();
    SCBSceneSessionManager.getInstance().unRegisterOnFocusedScreenChangeCallback(this.onFocusedScreenChangeCallback);
    LockScreenAnimationController.getInstance()
      .unregisterCallback(LockScreenAnimationController.SCENE_ARRAY_CALLBACK + this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterGetAllContainerSessionListCallback();
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SwipeGestureManager.getInstance().unregisterFourFingersSwipeCallback(this.onFourFingersSwipeEvent);
      FourFingerSwipeController.getInstance().setSwipeStateCallback(null);
      DesktopSwitchController.getInstance().unSubDataShareChange();
      DesktopSwitchController.getInstance().unregisterVmStateCallback(this.vmStateCallback);
      SCBSceneSessionManager.getInstance().unregisterStatusBarTypeChangeCallback();
    }
    SCBSceneSessionManager.getInstance().unregisterClearSceneStatusCallback(this.screenProperty.screenId);
    SCBPcScenePanelManager.getInstance().unRegisterGetIsPairSplitCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unRegisterIsPairSplitCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unRegisterIsHandleThreeFingerSwiperCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterAddContainerSessionCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterRemoveContainerSessionCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterStatusBarRecoverCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterGetScenePanelStateCallback(this.screenProperty.screenId,
      SCBDefaultZIndex.SCENE_PANEL);
    SCBSceneSessionManager.getInstance().unregisterHandleSceneWhenPreLock(this.screenProperty.screenId);
    SCBPcScenePanelManager.getInstance().unregisterUIContext(this.screenProperty.screenId);
    SCBPiPManager.getInstance().unregisterAutoStartPipStatusChange();
    SCBScreenSessionManager.getInstance().unRegisterPropertyChangeScenePanelCallback(
      this.propertyChangeScenePanelCallback, SCBDefaultZIndex.SCENE_PANEL, this.screenProperty.screenId);
  }

  private onScrollClicked(): void {
    log.showInfo('recent onclick');
    this.scroll.scrollTo({ xOffset: 0, yOffset: 0 });
    RecentAndAppCenterSwitchManager.getInstance().setOneFrameVisible(this.screenProperty.screenId, false);
    if (this.scenePanelState === ScenePanelState.RECENT) {
      this.exitRecentView();
    }
    if (this.isSplitState()) {
      let curActiveContainerSession = this.containerSessionList.getTopActiveSession();
      if (curActiveContainerSession?.isSplit) {
        let param = new ExitSplitParam();
        if (curActiveContainerSession.primarySession?.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN) {
          param.exitSplitEvent = SCBSessionEventId.EVENT_MAXIMIZE;
        }
        let persistentId = curActiveContainerSession.getPersistentId();
        this.exitSplitView(persistentId, param);
      }
    }
  }

  private isSpaceEnableAndRecent(): boolean {
    return MultiSpace.get().checkSpaceEnable() && this.isRecentState();
  }

  private updateIsShowScrollBar(): void {
    const recentSessionLength: number = this.currentRecentSessionInfo.length;
    if (recentSessionLength === 0) {
      this.isShowScrollBar = false;
      return;
    }
    const lastSession = this.currentRecentSessionInfo[recentSessionLength - 1];
    const cardsHeight: number = lastSession.top + lastSession.height - this.mRecentSessionsViewModel.getSplitOffsetY();
    let showHeight: number = this.mRecentSessionsViewModel.getCurrentShowHeight();
    if (this.isSpaceEnableAndRecent()) {
      const enterpriseRecentHeight = showHeight * ENTERPRISE_RECENT_HEIGHT_RATIO;
      showHeight = showHeight - enterpriseRecentHeight - this.dockHeight;
    }
    this.isShowScrollBar = cardsHeight > showHeight;
  }

  private getRecentClipRect(): RectAttribute | boolean {
    log.showInfo(`scenePanelState: ${this.scenePanelState} isNeedClip: ${this.isNeedClip}`);
    if (!this.isNeedClip) {
      return false;
    }
    const width = this.screenProperty.width;
    const height = this.mRecentSessionsViewModel.getCurrentShowHeight();
    const offsetX = 0;
    const offsetY = this.mRecentSessionsViewModel.getSplitOffsetY();
    return new Rect({
      width: width + 'vp',
      height: height + 'vp',
    })
      .position({
        x: offsetX,
        y: offsetY,
      })
  }

  private remainStillInScroll(xOffset: number, yOffset: number, scrollState: ScrollState): void {
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const containerSession = this.containerSessionList[i];
      const attributeModifier: AttributeUpdater<CommonModifier> =
        containerSession.sessionData.attributeModifierMap[this.screenProperty.screenId];
      if (!attributeModifier) {
        continue;
      }
      if (this.isSplitState() && containerSession.isSplit && containerSession.isOneStepSplit() ||
        containerSession.sessionData.attributeChanged) {
        this.scrollTranslate += yOffset;
        const translate = Math.round(vp2px(this.scrollTranslate));
        attributeModifier.attribute?.translate({ y: translate + 'px' });
        containerSession.sessionData.attributeChanged = translate !== 0;
        break;
      }
    }
  }

  private exitRecentWhenStartSceneFromRecent(sceneContainerSession: SCBSceneContainerSession): void {
    AnimateToScheduleUtils.reportAppOptFromRecentToRss(OptFromRecentType.START_APP,
      sceneContainerSession?.primarySession?.sceneInfo?.bundleName);
    this.restoreSceneRadius(sceneContainerSession.primarySession);
    SCBRecentCardViewModel.resetShowInRecent(sceneContainerSession);
    sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'recoverVisibilityStartSceneInRecent',
      sceneContainerSession.getName());
    this.recentEnter.changeNeedRecoverSessionFocus(false);
    this.exitRecentView();
  }

  private exitSplitView(persistentId?: number, param: ExitSplitParam = new ExitSplitParam()): void {
    this.presenter.exitSplitView(persistentId, param);
  }

  private recoverOrMaximizeIfLastSplit(containerSession: SCBSceneContainerSession | null): void {
    this.presenter.recoverOrMaximizeIfLastSplit(containerSession);
  }

  @Builder
  recentEmptyViewBuilder() {
    Stack() {
      if (this.isCurScreenContainerEmpty() && this.isRecentState()) {
        SCBRecentEmptyView()
          .size(this.getEmptyRecentViewSize())
          .position(this.getEmptyRecentViewPosition())
      }
      if (this.isEmptyInSplitState()) {
        SCBSplitRecentEmptyView()
          .size(this.getEmptyRecentViewSize())
          .position(this.getEmptyRecentViewPosition())
      }
    }
    .position({ x: 0, y: 0 })
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
    .onClick(() => {
      this.onScrollClicked();
    })
  }

  @Builder
  scrollContainersBuilder() {
    Scroll(this.scroll) {
      Stack() {
        ForEach(this.containerSessionList, (item: SCBSceneContainerSession) => {
          SCBSceneContainerRefresh({
            sceneContainerSession: item,
            screenProperty: this.screenProperty,
            onGestureChange: this.gestureChange,
            onSceneRectChange: this.sceneRectChange,
            isExitSplit: this.isExitSplit,
            isPairSplit: this.isPairSplit,
            getScreenDpiDensity: this.getScreenDpiDensity,
            scenePanelState: $scenePanelState,
            deleteSceneCardInRecent: this.deleteSceneCardInRecent,
            singleContext: this.singleContext,
          })
        }, (item: SCBSceneContainerSession) => item.containerId.toString())
      }
      .hitTestBehavior(HitTestMode.None)
      // 企业数字空间场景，最近任务中心可滚动区域增加20%。使最下窗口可以滚动到屏幕中间。
      .height(this.isSpaceEnableAndRecent() ?
        (this.isShowScrollBar ? 
          this.scrollStackHeight : (this.scrollStackHeight - this.enterpriseRecentHeight - this.dockHeight)) :
        this.scrollStackHeight)
    }
    .hitTestBehavior(this.isRecentOrSplitState() ? HitTestMode.Default : HitTestMode.None)
    .clip(this.getRecentClipRect())
    .size({
      width: StyleConstants.PERCENTAGE_100,
      height: this.isSpaceEnableAndRecent() ?
        `calc(100% - ${this.enterpriseRecentHeight + this.dockHeight}vp)` : StyleConstants.PERCENTAGE_100
    })
    .enableScrollInteraction(true)
    .edgeEffect(EdgeEffect.Spring)
    .flingSpeedLimit(this.scrollFlingSpeedLimit)
    .onWillScroll((x, y, scrollState) => {
      if (!this.isRecentOrSplitState()) {
        return;
      }
      if (scrollState !== ScrollState.Scroll) {
        return;
      }
      SCBRecentFoldHalfVM.getInstance().runScrollAnimate(this.screenProperty.screenId, y);
    })
    .onDidScroll((x, y, scrollState)=>{
      this.remainStillInScroll(x, y, scrollState)
    })
    .onScrollStart(() => {
      TraceUtil.startTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION);
      recentLog.showInfo(`start ${TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION}.`);
      performanceMonitor.begin(HiSysEventUtil.SNAP_RECENT_ANI, performanceMonitor.ActionType.FIRST_MOVE);
      const containerSession = this.containerSessionList.getTopActiveSession();
      if (containerSession?.isSplit) {
        performanceMonitor.begin('PC_SPLIT_SCROLL_RECENT', performanceMonitor.ActionType.FIRST_MOVE);
      }
    })
    .onScrollStop(() => {
      TraceUtil.endTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION);
      recentLog.showInfo(`end ${TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION}.`);
      performanceMonitor.end(HiSysEventUtil.SNAP_RECENT_ANI);
      const containerSession = this.containerSessionList.getTopActiveSession();
      if (containerSession?.isSplit) {
        performanceMonitor.end('PC_SPLIT_SCROLL_RECENT');
      }
      if (this.showRecent) {
        SCBRecentFoldHalfVM.getInstance().runAvoidAnimate(this.screenProperty.screenId);
      }
    })
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Vertical)
    .onClick(() => {
      this.onScrollClicked();
    })
  }

  @Builder
  recentOrSplitComponent() {
    ScrollBar({ scroller: this.scroll, state: this.isShowScrollBar ? BarState.On : BarState.Off }) {
      Text()
        .width(8)
        .height(this.scrollBarTextHeight)
        .borderRadius(4)
        .backgroundColor('#F3ECEC')
        .id(`${TAG}_Text_barState`)
    }
    .height(this.scrollBarHeight)
    .width(8)
    .borderRadius(4)
    .backgroundColor('rgba(216,216,216,0.2)')
    .position(this.getScrollbarPosition())
  }

  @Builder
  enterpriseRecentPanelBuilder() {
    if (this.isSpaceEnableAndRecent()) {
      EnterpriseRecentPanel({
        screenProperty: this.screenProperty,
        onClickCurrent: (onAnimationFinish?: () => void) => this.exitRecentView(true, onAnimationFinish),
        enterpriseRecentHeight: this.enterpriseRecentHeight
      })
    }
  }

  @Builder
  stackMaskComponent() {
    Stack() {
    }
    .size({ width: this.screenProperty.width, height: this.screenProperty.height / 2 })
    .position({ x: 0, y: px2vp(this.screenProperty.height / 2 ) })
    .hitTestBehavior(HitTestMode.Block)
    .onClick((event: ClickEvent) => {
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
        WindowScene(this.sysSceneSession?.session.persistentId) {
          Stack({ alignContent: Alignment.TopStart }) {
            if (this.showRecentEmptyView) {
              this.recentEmptyViewBuilder()
            }
            this.scrollContainersBuilder()
            if (this.isRecentOrSplitState()) {
              this.recentOrSplitComponent()
            }
            this.enterpriseRecentPanelBuilder();
          }
          .height(StyleConstants.PERCENTAGE_100)
        }
      }
      .id('SCBScenePanel_ROOT')
      .focusable(true)
      .size({ width: this.screenProperty.width + 'px', height: this.screenProperty.height + 'px' })
      .hitTestBehavior(HitTestMode.None)
      .scale({ x: this.scenePanelScale, y: this.scenePanelScale })
      .opacity(this.scenePanelOpacity)
      .zIndex(SCBDefaultZIndex.SCENE_PANEL)
    }
    .id('SCBScenePanelBackground')
    .direction(Direction.Ltr)
    .position({ x: 0, y: 0 })
    .size({ width: '100%', height: '100%' })
    .hitTestBehavior(HitTestMode.None)
    .zIndex(SCBDefaultZIndex.SCENE_PANEL)
  }
}