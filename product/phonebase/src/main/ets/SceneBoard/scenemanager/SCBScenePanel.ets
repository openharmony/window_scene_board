
/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  ViewManager,
  StyleConstants,
  PageDesktopModel,
  CloseAppManager,
  EventConstants,
  GrayAppListManager,
  GridLayoutItemInfo,
  vibratorMgr,
  FormCenterViewManager,
  DesktopModeManager,
  DesktopModeEnum,
  FolderData,
  StartAndExitVisualEffectManager,
  FolderOperationFlag,
  ContractedFolderCommonViewModel,
  FolderManager,
  LauncherAnimUtil,
  DeliverUtil,
  FormConstants
} from '@ohos/launchercommon';
import { EditModeViewEvent } from '@ohos/desktopedit/src/main/ets/default/viewmodel/EditModeViewEvent';
import { DropDownPanelManager, OverlayStartAnimHelper, FloatingDisplayMode } from '@ohos/systemuicommon/Index';
import { BackgroundBlurView } from './BackgroundBlurView';
import { SCBSceneContainer } from './SCBSceneContainer';
import bundleManager from '@ohos.bundle.bundleManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
// import apsManager from '@ohos.graphic.apsManager';
import curves from '@ohos.curves';
import { image } from '@kit.ImageKit';
import { RecentEmptyView } from '../recent/RecentEmptyView';
import RecentClearAllView from '../recent/RecentClearAllView';
import UnLockConstants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { SCBDefaultZIndex } from './SCBScreen';
import InputConsumer from '@ohos.multimodalInput.inputConsumer';
import { ContainerBuilder } from '../recent/common/ContainerBuild';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import common from '@ohos.app.ability.common';
import {
  RectInfo,
  Trace,
  TraceUtil,
  DomainName,
  LogDomain,
  LogHelper,
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  CommonUtils,
  FileUtils,
  StartType,
  CompanionIconInfo,
  OutdoorConfig
} from '@ohos/basicutils';
import {
  ViewType,
  ViewManagerPolicy,
  GlobalSearchStatus,
  sOutSideWindowMgr,
  HiSysEventUtil,
  CEManager,
  ApsUtils,
  localEventManager,
  RecentEventType,
  ReturnDesktopEventType,
  EvtBus,
  EventManager,
  SCBDesktopCacheManager,
  DeviceHelper,
  ResultType,
  HiSysReturnHomeData,
  RotateChangeEvent,
  ExitOneStepSplitReason,
  PairSplitResult,
  SCBWindowSceneConfig,
  IntelligentCache,
  viewMgrPolicy,
  ViewCallback,
  IconResourceManager,
  OperateResult,
  AnimPolicyRegistry,
  AnimPolicyConstant,
  NavBarEventType,
  TrimLevel,
  SCBTriFoldManager,
  SCBTripleFoldState,
  MultiWindowRotateChangeEvent
} from '@ohos/frameworkwrapper';
import {
  SCBRecoverManager,
  SCBTransitionController,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBRotateChangeReason,
  SCBPropertyChangeReason,
  GestureNavigationState,
  SCBSessionEventId,
  SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSessionManager,
  SCBKeyboardSession,
  SCBSceneSession,
  ActiveReason,
  SCBEventId,
  SCBSessionShowInScreenIndex,
  SCBGestureActionId,
  SCBGestureAction,
  SCBTransitionManager,
  SCBUnlockTransitionController,
  scbGestureManager,
  KeyboardState,
  SCBContainerRotationReason,
  SCBScenePanelSession,
  SCBBackgroundBlurSession,
  SCBScenePanelManager,
  SystemSessionInfo,
  SCBSystemSceneSession,
  SCBDividerParam,
  SCBSceneOrientation,
  RecentViewParam,
  RecentsStyleConstants,
  GestureType,
  PcKeyType,
  SCBSceneContainerState,
  SCBKeyboardManager,
  SCBKeyboardPanelSession,
  FocusChangeReason,
  SCBSpecificSession,
  SCBSessionRect,
  SCBScreenSession,
  SCBTogManager,
  StartFrom,
  FSMCallbackArgsType,
  AppExitLocationInfo,
  scbEventExclusiveManager,
  EventType,
  SCBOobeManager,
  SceneParam,
  SCBScenePanelDebugCommands,
  FSMState,
  SCBWindowRaiseReason,
  SceneInfoAdapterUtil,
  SCBWindowRotateController,
  SCBSceneMissionManager,
  ContainerDataCategory,
  gestureNavigationObserver,
  SceneCaller,
  GestureNavigationEvent,
  NavigationType,
  CommonResult,
  SCBRotationConfig,
  SplitStyle,
  OrientationExecutionResult
} from '@ohos/windowscene';
import { MemoryManager } from '@ohos/frameworkcommon';
import {
  CallToState,
  RotationConstants,
  SplitType,
  KeyCodeConstants,
  DividerStyleConstants,
  SCBConstants,
  SceneConstants,
  NumberConstants
} from '@ohos/commonconstants';
import { PerformanceReporter, CurrentMemScene, } from '@ohos/frameworkcommon';
import { themeWallpaperAniMgr, AnimationType } from '@ohos/themeservice';
import { ItemUtils, desktopUtil, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { ExecuteCallbackExtraInfo }
  from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { SCBSystemBarProperty, SCBStatusBarSettingFlag  }
  from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSession';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { SCBScenePanelFSM } from '../recent/scenepanel/SCBScenePanelFSM';
import { RecentScrollFollowing } from '../recent/scenepanel/recentpanel/RecentScrollFollowing';
import {
  defaultRecentDeleteConfig,
  outerRecentDeleteConfig,
  RecentDelete,
  RecentDeleteConfig
} from '../recent/scenepanel/recentpanel/RecentDelete';
import { RecentClearAll} from '../recent/scenepanel/recentpanel/RecentClearAll';
import { recentLockModel } from '../recent/settings/RecentLockModel';
import { recentMediaPlayInstance } from '../recent/scenepanel/recentpanel/RecentMediaPlay';
import { AppFloating } from '../recent/scenepanel/apppanel/AppFloating';
import { ContainerShowState } from '../recent/scenepanel/recentpanel/RecentNotShow';
import { RecentZoomAlarm } from '../recent/scenepanel/recentpanel/RecentZoomAlarm';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { RecentLayoutManager} from '../recent/common/RecentLayoutManager';
import { ScreenLockApi, SlVisualConfigManager, CcmOption } from '@ohos/screenlockcommon';
import systemDateTime from '@ohos.systemDateTime';
import { RecentStateManager, recentStateManagerInstance } from '../recent/innerstate/RecentStates';
import { QuickSwitchRaiseTopAlarm } from '../recent/scenepanel/quickswitchpanel/QuickSwitchRaiseTopAlarm';
import { RecentDockRefreshAlarm } from '../recent/scenepanel/recentpanel/RecentDockRefreshAlarm';
import { QuickSwitchAnimations } from '../recent/scenepanel/quickswitchpanel/QuickSwitchAnimations';
import { SplitLifeCycle } from '@ohos/windowscene/src/main/ets/scene/session/SCBSplitParam';
import {
  AppIdleCallback,
  FarAwayFollowingFromAppCallback,
  RecentFollowingFromAppCallback,
  ZoomFollowingFromAppCallback,
  QuickSwitchFollowingFromAppCallback
} from '../recent/scenepanel/apppanel/AppCallbacks';
import { RecentClickReason } from '../recent/scenepanel/ScenePanelStates';
import { RecentRotationUtil } from '../recent/common/RecentRotationUtil';
import { AnimateExArgsType, animateExBreak } from '@ohos/windowscene/Index';
import {
  RecentDeleteFollowingCallback,
  RecentIdleCallback,
  RecentScrollFollowingCallback,
  RecentScrollFlingCallback,
  RecentClearAllCallback
} from '../recent/scenepanel/recentpanel/RecentCallbacks';
import { RecentStartScene } from '../recent/scenepanel/recentpanel/RecentStartScene';
// import { RecentTitleViewModel } from '../recent/viewmodel/RecentTitleViewModel';
// import { RecentLockIconModel } from '../recent/scenepanel/recentpanel/RecentLockIconModel';
import {
  EmergencyHomeIdleCallback,
  HomeIdleCallback,
  OverViewFollowingFromHomeCallback,
  OutdoorIdleCallback
} from '../recent/scenepanel/homepanel/HomeCallbacks';
import { recentRuntimeInstance } from '../recent/scenepanel/recentpanel/RecentRuntimeModel';
import {
  MultiWindowEventConstants
} from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { recentDisplayManager } from '@ohos/recents/src/main/ets/TsIndex';
import { NaviBarChangeType } from '../naviBar/SCBNaviBarConstants';
import { QuitAppRectViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/QuitAppRectViewModel';
import { RecentAccessibilityUtils } from '../recent/scenepanel/recentpanel/RecentAccessibilityUtils';
import lazy { ThreeFingerSwiperCallback, TouchBoardGestureManager } from '../touchboardgesture/TouchBoardGestureManager';
import lazy { ThreeFingerSwipeController } from '../touchboardgesture/ThreeFingerSwipeController';
import lazy {
  ThreeFingerSwipeType,
  ThreeFingerSwipeConstants
} from '../touchboardgesture/ThreeFingerSwipeConstants';
import { SmallFolderModelManager } from '@ohos/smallfolder/src/main/ets/default/common/SmallFolderModelManager';
import { SCBRotateUtils } from './utils/SCBRotateUtils';
import { SCBWindowRotate } from './SCBWindowRotate';
import { RecentLayoutCalculatorFactory } from '../recent/common/RecentLayoutCalculatorFactory';
import {
  BusinessError, commonEventManager, configPolicy
} from '@kit.BasicServicesKit';
import { SCBKeyboardPanel } from '../keyboard/SCBKeyboardPanel';
import { FlashlightTipsUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FlashlightTipsUtil';

import { RecentForegroundBlurAniMgr } from '../recent/scenepanel/recentpanel/RecentForegroundBlurAniMgr';
import { ReplaceReason } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { bannerMgr } from '@ohos/systemuicommon';
import lazy { SCBOuterScenePanelManager } from './SCBOuterScenePanelManager';
import lazy { SCBPiPManager } from './pip/SCBPiPManager';
import { display } from '@kit.ArkUI';
import { ZoomFollowingAnimations } from '../recent/scenepanel/apppanel/ZoomFollowingAnimations';
import { TouchGestureAction, TouchGestureEvent } from '@ohos.multimodalInput.gestureEvent';
import lazy { MattesRotateStrategy } from '@ohos/foldeffect/src/main/ets/mattesstrategy/MattesRotateStrategy';
import lazy { FolderExpandSnapshotView } from './FolderExpandSnapshotView';
import {
  getScenePanelName,
  SCBScenePanelViewModel,
  ScenePanelDataCollectionHandler,
  ScenePanelStateCollectionHandler
} from './viewmodel/SCBScenePanelViewModel';
import { GestureDockPreferenceMgr } from '../gestureDock/common/preference/GestureDockPreferenceMgr';
import { GestureDockViewModel } from '../gestureDock/dock/viewmodel/GestureDockViewModel';
import {
  launcherVisualEffectMgr,
  FoldExpandAnimUtils,
  TripleFoldExpandAnimUtils,
  FoldAnimationConstants,
} from '@ohos/launchercommon/Index';
import { homeViewModel } from '../recent/scenepanel/homepanel/HomeViewModel';
import { SCBGestureNavBarViewModel } from '../gesturenavigation/SCBGestureNavBarViewModel';
import {
  RotateFuncType,
  WrapRotationEntryParam,
} from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { SCBTripleStateChange } from '@ohos/launchercommon/src/main/ets/utils/TripleFoldExpandAnimUtils';
import { RecentGestureEventManager } from '../recent/common/RecentGestureEventManager';
import { RecentGestureEvent } from '../recent/common/constants/RecentGestureConstants';
import { recentViewModel } from '../recent/scenepanel/recentpanel/RecentViewModel';
import { quickSwitchViewModel } from '../recent/scenepanel/quickswitchpanel/QuickSwitchViewModel';
import { quickSwitchRequestActiveAlarm } from '../recent/scenepanel/quickswitchpanel/QuickSwitchRequestActiveAlarm';
import { SCBPhoneSceneUtils } from './utils/SCBPhoneSceneUtils';
import { SCBMinimizeSceneOpts } from '@ohos/windowscene/src/main/ets/scene/SceneModuleIndex';
import { SCBSceneStartInterceptor, StartInterceptions } from '@ohos/windowscene/src/main/ets/scene/framework/missions/SCBSceneStartInterceptor';
import lazy { SCBRecentPrepareManager } from './pcmode/SCBRecentPrepareManager';
import lazy { singleDisplayPocketUtil } from './utils/SingleDisplayPocketUtil';
import { FloatingNavigationManager } from '../naviBar/proxy/FloatingNavigationManager';
import transactionManager from '@ohos.transactionManager';
import lazy {
  SCBSceneWindowAiSplitSwitchUtils,
  ViewSplitListener
} from '@ohos/windowscene/src/main/ets/scene/utils/SCBSceneWindowAiSplitSwitchUtils';
import { SnapshotNodeType } from '@ohos/windowscene/src/main/ets/common/SnapshotNodeType';
import { WinLog, WinLogDomain } from '@ohos/windowscene/src/main/ets/utils/WinLog';

const TAG = 'SCBScenePanel';
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const RECENT_TAG = 'RecentPanel';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);
const winLog = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

const SCENE_SCALE_FULL = 1;
const INVALID_INDEX = -1;

const FOCUSED_SHADOW_COLOR: Resource = $r('app.color.floating_scene_focused_shadow_color');

const MIN_FINGERS_COUNT: number = 4;
const MAX_FINGERS_COUNT: number = 5;
const INVALID_TIMER: number = -1;
const CANCEL_DELAY_TIMER: number = 1000;
const REQUEST_UPDATE_RECT_DELAY: number = 100;
const WITHOUT_ANIMATION_LIST: string[] = ['com.ohos.onekeylock'];
const SUBWINDOW_SECURITY_PREFIX: string = 'com.ohos.security';
const DEFAULT_BG_BLUR_COLOR: string = 'rgba(0, 0, 0, 1)';
const TRANSPARENT_BG_BLUR: string = 'rgba(0, 0, 0, 0)';

export enum ScenePanelState {
  HOME,
  FULLSCENE,
  SPLIT,
  FLOAT_SCENE,
  RECENT,
  QUICK_SWITCH,
  APP_CENTER
}

interface SceneContainerBuilderParam {
  sessionList: SCBSceneContainerSessionArray;
  floatSessionList: SCBSceneContainerSessionArray;
  screenProperty: SCBScreenProperty;
  isNeedReBuildRecentView: boolean;
}

interface SCBSystemBarPropertyInner {
  type: sceneSessionManager.SessionType;
  enable: boolean;
  backgroundcolor: string;
  contentcolor: string;
  enableAnimation: boolean;
  settingFlag: number;
}

@Component
export struct SCBScenePanel {
  /*
   * Screen
   */
  @Link screenProperty: SCBScreenProperty; // current screen property
  @Prop physicalScreenProperty: SCBScreenProperty = new SCBScreenProperty(); // same with physical screen

  /*
   * Keyboard
   */
  @Link keyboardState: KeyboardState;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;

  /*
   * Scene mission management
   */
  private panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(this.getUIContext(),
    this.screenProperty);
  private panelMgr = this.panelViewModel.getPanelManager();
  @State containerSessionList: SCBSceneContainerSessionArray = this.panelViewModel.getContainerSessionList();
  private containerSessionListNotShowRecent: SCBSceneContainerSessionArray =
    this.panelViewModel.getContainerSessionListNotShowRecent();
  // 普通多任务和悬浮窗多任务的全集
  private totalContainerSessionList: SCBSceneContainerSessionArray = this.panelViewModel.totalContainerSessionList;

  /*
   * List for floating window display
   */
  @State floatingSessionList: SCBSceneContainerSessionArray = this.panelViewModel.getFloatingSessionList();

  /*
   * MidScene
   */
  private panelFsm = SCBScenePanelFSM.getInstance(this.panelMgr);
  private backgroundBlurSession: SCBBackgroundBlurSession = this.panelMgr.getBackgroundBlurSession();
  @State isNeedReBuildEnterRecentView: boolean = false;
  @State panelSession: SCBScenePanelSession = this.panelMgr.getPanelSession();
  @State recentDeleteConfig: RecentDeleteConfig = defaultRecentDeleteConfig;
  @State isScrolling: boolean = false;
  @State viewParam: RecentViewParam = this.panelMgr.getViewParam();
  @State recentInnerState: RecentStateManager = RecentStateManager.getInstance();
  @State unLockScale: number = UnLockConstants.MIN_SCENE_SCALE;
  @State isUseThisScenePanel: boolean = false;
  @StorageLink('scenePanelState') @Watch('updateScrollEnableMode') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @StorageLink('selectedIndex') @Watch('updateIndex') selectedIndex: number = INVALID_INDEX;
  @StorageLink('showRecent') @Watch('updateRecent') showRecent: boolean = false;
  @StorageProp('mattesLock') @Watch('onMattesLockChange') mattesLock: boolean = false;
  @State isNeedShowGuidanceDialog: boolean = false;
  // 模糊灰阶禁用状态
  @State isBgGrayScaleDisable: boolean = false;
  private oldSelectedIndex: number = INVALID_INDEX;
  name: string = '';
  clearAllAnimCnt: number = 0;
  rotationAnimCnt: number = 0;
  foldAnimNum: number = 0;
  isStartClearAll: boolean = false;
  @Consume screenRotationAnimCnt: number; // do not change this variable
  private rotateFinishTimerId: number = -1;
  private timer: number | null = null;
  private isTouchableByNavBar: boolean = false;
  private oneStepSplitContainerID: number = -1;
  private oneStepSplitExitFlag: boolean = false;
  private recentScroll = this.panelViewModel.recentScroll;
  private recentGesture = this.panelViewModel.recentGesture;
  private recentDelete = new RecentDelete(this.panelMgr);
  private recentClearAll = new RecentClearAll(this.panelMgr);
  private recentExit = this.panelViewModel.recentExit;
  private recentStartScene = new RecentStartScene(this.panelMgr);
  private quickSwitchAnimations = this.panelViewModel.quickSwitchAnimations;
  private appFloating = new AppFloating(this.panelMgr);
  private recentNotShow = this.panelViewModel.recentNotShow;
  private debugCommands = new SCBScenePanelDebugCommands(this.panelMgr);
  private mViewManager: ViewManager = ViewManager.getInstance();
  private unLockTransitionController: SCBUnlockTransitionController | undefined = undefined;
  private isSupportMaximizeScene: boolean = true;
  @State isShowCompanionIcon: boolean = false;
  @State isShowBlackBackground: boolean = false;
  @State isIconWithBadge: boolean = false;
  private desktopContext: ServiceExtensionContext = this.panelViewModel.desktopContext;
  private recentEnter = this.panelViewModel.recentEnter;
  private zoomFollowing = new ZoomFollowingAnimations(this.panelMgr);
  private currRotation: number = 0;
  private uiContext: UIContext | undefined = undefined;
  private isAppFront: boolean = false;
  @State isNeedFoldExpandSnapShot: boolean = false;
  private foldExpandSnapShotSessionId: number = -1;
  private foldExpandStateChange: SCBTripleStateChange = SCBTripleStateChange.INVALID;
  @State needScrollClip: boolean = true;

  // 在锁屏前后保持桌面跟壁纸的隐藏状态不变
  private needRestoreHideDesktop: boolean = false;
  private needRestoreHideWallpaper: boolean = false;

  // 控制是否上报多任务滑动打点，每次进入多任务只上报一次
  private doReport: boolean = false;

  // auto test pressHome key
  private homeKeyOption: InputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_HOME,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  @Prop wallpaperBlurImage: PixelMap | undefined = undefined;
  @State splitBlurWallpaperEnable: boolean = false;
  private expandStartContainerSession: SCBSceneContainerSession | null = null;
  private isRecoveredActiveSession: boolean = false;
  private isNeedChangeToMultiRow: boolean = false;
  @State panelVisible: Visibility = Visibility.Visible;
  private sysSceneSession: SCBSystemSceneSession = this.panelViewModel.sysSceneSession;

  private blurSceneSession?: SCBSystemSceneSession = this.initBlurSceneSession();

  private evtMgr: EventManager = EvtBus.createEventManager();

  // 是否在屏幕旋转时隐藏桌面模糊
  private isHideBlurInRotate: boolean = false;

  private editModeViewEvent: EditModeViewEvent = this.panelViewModel.editModeViewEvent;

  private needRemoveBlank: boolean = false;
  private recentStartNotifyRotation: number | undefined = undefined;

  private fromScenePanelState:number = 0;

  private swipeController: ThreeFingerSwipeController | null = null;

  private isHandleThreeFingerSwiper: boolean = false;

  private landscapeExitTimeOutId: number = 0;


  @State needTransparentSession: boolean = false;

  // 实现状态操作接口
  private panelStateCollectionHandler: ScenePanelStateCollectionHandler = {
    getPanelState: (): ScenePanelState => {
      return this.scenePanelState;
    },

    updatePanelState: (state: ScenePanelState) => {
      this.scenePanelState = state;
    },

    getViewParam: (): RecentViewParam => {
      return this.viewParam;
    },

    getKeyboardSession: (): SCBKeyboardSession => {
      return this.keyboardSession;
    },

    getKeyboardPanelSession: (): SCBKeyboardPanelSession => {
      return this.keyboardPanelSession;
    },

    getBlackBackgroundState: (): boolean => {
      return this.isShowBlackBackground;
    },

    updateBlackBackgroundState: (blackBackgroundState: boolean) => {
      this.isShowBlackBackground = blackBackgroundState;
    },

    getRecentInnerState: (): RecentStateManager => {
      return this.recentInnerState;
    },

    getMattesLockState: (): boolean => {
      return this.mattesLock;
    },

    updateMattesLockState: (mattesLock: boolean) => {
      this.mattesLock = mattesLock;
    },

    getBgGrayScaleDisableState: (): boolean => {
      return this.isBgGrayScaleDisable;
    },

    updateBgGrayScaleDisableState: (isBgGrayScaleDisable: boolean) => {
      this.isBgGrayScaleDisable = isBgGrayScaleDisable;
    },

    getPanelVisibleState: (): Visibility => {
      return this.panelVisible;
    },

    updatePanelVisibleState: (panelVisible: Visibility) => {
      this.panelVisible = panelVisible;
    },

    getScrollingState: (): boolean => {
      return this.isScrolling;
    },

    updateScrollingState: (isScrolling: boolean) => {
      this.isScrolling = isScrolling;
    },

    getPhysicalScreenProperty: (): SCBScreenProperty => {
      return this.physicalScreenProperty;
    },

    updateNeedScrollClip: (needScrollClip: boolean) => {
      this.needScrollClip = needScrollClip;
    },

    getNeedScrollClip: () => {
      return this.needScrollClip;
    },

    getCompanionIconShowState: (): boolean => {
      return this.isShowCompanionIcon;
    },

    updateCompanionIconShowState: (state: boolean) => {
      this.isShowCompanionIcon = state;
    },

    getIconWithBadgeState: (): boolean => {
      return this.isIconWithBadge;
    },

    updateIconWithBadgeState: (state: boolean) => {
      this.isIconWithBadge = state;
    },
    updateUnLockScale: (unLockScale: number) => {
      this.unLockScale = unLockScale;
    },

    getPanelSession: () => {
      return this.panelSession;
    },

    getIsEmptyRecentViewCallback:() => {
      return this.isEmptyRecentView;
    },
    getFoldExpandStateChange: (): SCBTripleStateChange => {
      return this.foldExpandStateChange;
    },
    setFoldExpandStateChange: (change: SCBTripleStateChange) => {
      this.foldExpandStateChange = change;
    },
    getNeedFoldExpandSnapShot: (): boolean => {
      return this.isNeedFoldExpandSnapShot;
    },
    setNeedFoldExpandSnapShot: (isNeed: boolean) => {
      this.isNeedFoldExpandSnapShot = isNeed;
    },
    getFoldExpandSnapShotSessionId: (): number => {
      return this.foldExpandSnapShotSessionId;
    },
    setFoldExpandSnapShotSessionId: (sessionId: number) => {
      this.foldExpandSnapShotSessionId = sessionId;
    },
    getFoldAnimNum: (): number => {
      return this.foldAnimNum;
    },
    setFoldAnimNum: (animNum: number) => {
      this.foldAnimNum = animNum;
    }
  }

  // 实现基础数据类型操作接口
  private panelDataCollectionHandler: ScenePanelDataCollectionHandler = {
    getIsTouchableByNavBar: (): boolean => {
      return this.isTouchableByNavBar;
    },

    getFromScenePanelState: (): ScenePanelState => {
      return this.fromScenePanelState;
    },

    setFromScenePanelState: (state: ScenePanelState) => {
      this.fromScenePanelState = state;
    },

    setCurrRotation: (currRotation: number) => {
      this.currRotation = currRotation;
    },

    getCurrRotation: (): number => {
      return this.currRotation;
    },

    getRotationAnimCnt: (): number => {
      return this.rotationAnimCnt;
    },

    setRotationAnimCnt: (rotationAnimCnt: number) => {
      this.rotationAnimCnt = rotationAnimCnt;
    },

    addRotationAnimCnt: () => {
      this.rotationAnimCnt++;
    },

    decRotationAnimCnt: () => {
      this.rotationAnimCnt--;
    },

    getRotateFinishTimerId: (): number => {
      return this.rotateFinishTimerId;
    },

    setRotateFinishTimerId: (rotateFinishTimerId: number) => {
      this.rotateFinishTimerId = rotateFinishTimerId;
    },

    getPanelName: (): string => {
      return this.name;
    },

    getRecentStartNotifyRotation: (): number | undefined => {
      return this.recentStartNotifyRotation;
    },

    setRecentStartNotifyRotation: (recentStartNotifyRotation: number | undefined) => {
      this.recentStartNotifyRotation = recentStartNotifyRotation;
    },

    setExpandStartContainerSession: (expandStartContainerSession: SCBSceneContainerSession | null) => {
      this.expandStartContainerSession = expandStartContainerSession;
    },

    getIsSupportMaximizeScene: (): boolean => {
      return this.isSupportMaximizeScene;
    },

    setIsSupportMaximizeScene: (isSupportMaximizeScene: boolean) => {
      this.isSupportMaximizeScene = isSupportMaximizeScene;
    },

    getIsNeedChangeToMultiRow: (): boolean => {
      return this.isNeedChangeToMultiRow;
    },

    setIsNeedChangeToMultiRow: (isNeedChangeToMultiRow: boolean) => {
      this.isNeedChangeToMultiRow = isNeedChangeToMultiRow;
    },

    getNeedRemoveBlank: (): boolean => {
      return this.needRemoveBlank;
    },

    setNeedRemoveBlank: (needRemoveBlank: boolean) => {
      this.needRemoveBlank = needRemoveBlank;
    },

    getClearAllAnimCnt: (): number => {
      return this.clearAllAnimCnt;
    },

    getRecentDelete: (): RecentDelete => {
      return this.recentDelete;
    },

    getAppFloating: () => {
      return this.appFloating;
    },

    getAnimationFinishedCallback: () => {
      return this.animationFinishedCallback;
    },

    updateLandscapeExitTimeOutId: (timerID: number) => {
      this.landscapeExitTimeOutId = timerID;
    },

    getQuickSwitchAnimations: (): QuickSwitchAnimations => {
      return this.quickSwitchAnimations;
    },

    getOneStepSplitContainerID: (): number => {
      return this.oneStepSplitContainerID;
    },

    setOneStepSplitContainerID: (oneStepSplitContainerID: number) => {
      this.oneStepSplitContainerID = oneStepSplitContainerID;
    },

    getOneStepSplitExitFlag: (): boolean => {
      return this.oneStepSplitExitFlag;
    },

    setOneStepSplitExitFlag: (oneStepSplitExitFlag: boolean) => {
      this.oneStepSplitExitFlag = oneStepSplitExitFlag;
    },

  }

  private beforeScreenPropertyChangeCallback: Callback<display.FoldStatus> = (foldStatus: display.FoldStatus): void => {
    this.transferToBackgroundForSinglePocket(foldStatus);
  };

  private transparentSessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_TRANSPARENT_VIEW,
      sceneName: 'TransparentView',
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
    };
  private transparentSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.transparentSessionInfo);
  private totalFingersCount: number = 0;
  private startCancelTimer: number = INVALID_TIMER;
  private transparentDownCount: number = 0;
  private transparentCancelCount: number = 0;
  private gestureRecognitionSucceeded: boolean = false;

  // 内存回收回调
  private clearMemoryCallback: ViewCallback = {
    onTrimMemory: (level: TrimLevel): void => {
      switch (level) {
        case TrimLevel.CRITICAL:
          // 没有模糊绘制时回收blurSceneSession资源
          if (!this.isEnableBlurView()) {
            this.destroyBlurSceneSession();
            homeLog.showInfo('desktop onStaticMemory');
          }
          break;
      }
    },
  };

  getContainerSessionListCallback = (): SCBSceneContainerSessionArray => {
    return this.containerSessionList;
  }

  getContainerSessionListNotShowRecentCallback = (): SCBSceneContainerSessionArray => {
    return this.containerSessionListNotShowRecent;
  };

  getFloatContainerListCallback = (): SCBSceneContainerSessionArray => {
    return this.floatingSessionList;
  }

  startSceneWithRotationIfNeedCallback = (containerSession?: SCBSceneContainerSession | null,
    needAnimation: boolean = false, isFromRecent: boolean = false, fromUser: boolean = false): void => {
    this.panelViewModel.startSceneWithRotationIfNeed(containerSession, needAnimation, isFromRecent, fromUser);
  }

  recoverFinishedCallback = (): void => {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'Abnormal recover');
    let activeContainerSession = this.containerSessionList.getTopActiveSession();
    if (activeContainerSession !== null && activeContainerSession.primarySession !== null) {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `raise activeContainerSession id=:${activeContainerSession.primarySession.sceneInfo.persistentId} to top`);
      this.panelMgr.raiseSceneToTop(activeContainerSession);
    }
    // 异常恢复时，需要将当前屏幕属性通知到C++侧其他应用(RS、手势等)
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (screenSession && screenSession.isRotateScreenPolicy()) {
      // notify other app rotation listener
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenSession.scbScreenProperty);
    } else {
      SCBScreenSessionManager.getInstance().updateSystemRotation(this.screenProperty);
      // notify other app rotation listener
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(this.screenProperty);
    }
    try {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `recoverFinishedCallback start`);
      sceneSessionManager.reportData(502, 2, { });
    } catch(e) {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `recoverFinishedCallback failed`);
    }
  }

  /**
   * recover one container session due to abnormal recovery
   */
  recoverContainerSessionListCallback = (sceneSession: sceneSessionManager.SceneSession,
                                         sceneInfo: sceneSessionManager.SceneRecoverInfo): void => {
    if (sceneSession === null || sceneInfo === null) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'sceneSession or sceneInfo is null, recovered failed');
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `recover container session list with persistentId=${sceneSession.persistentId}, bundleName=${sceneInfo.bundleName},
      sessionState=${sceneInfo.sessionState}, windowMode=${sceneInfo.windowMode}, currentRotation = ${sceneInfo.currentRotation}`);
    let scbSceneInfo = new SCBSceneInfo(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName,
      sceneInfo.appIndex, sceneSession.persistentId);
    scbSceneInfo.isLockedInRecent = SCBSceneSessionManager.getInstance().getScenePersistent()
      .getCacheLockInRecentStatus(sceneSession.persistentId);
    scbSceneInfo.label = SCBSceneSessionManager.getInstance().getScenePersistent()
      .getCacheSessionLabel(sceneSession.persistentId);
    scbSceneInfo.updateWindowModeAndSync(sceneInfo.windowMode as SCBSceneMode);
    scbSceneInfo.rotationStrategy = sceneInfo.requestOrientation as SCBSceneOrientation;
    scbSceneInfo.supportWindowModes = sceneInfo.supportWindowModes;
    let scbSceneSession = new SCBSceneSession(sceneSession, scbSceneInfo);
    if (scbSceneSession === null) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'scbSceneSession is null, recovered failed');
      return;
    }
    sceneInfo.systemBarProperties?.forEach((property: SCBSystemBarPropertyInner) => {
      let systemBarProperty = new SCBSystemBarProperty(
        property.type, property.enable, property.backgroundcolor, property.contentcolor, property.enableAnimation);
      scbSceneSession.systemBarProperty.set(systemBarProperty.type, systemBarProperty);
      let settingFlag: number = property.settingFlag ?? 0;
      if (systemBarProperty.type === sceneSessionManager.SessionType.TYPE_STATUS_BAR) {
        scbSceneSession.setIsSetStatusBarColor((settingFlag & SCBStatusBarSettingFlag.COLOR_SETTING) ===
          SCBStatusBarSettingFlag.COLOR_SETTING);
        scbSceneSession.setStatusBarEnable((settingFlag & SCBStatusBarSettingFlag.ENABLE_SETTING) ===
          SCBStatusBarSettingFlag.ENABLE_SETTING);
        scbSceneSession.setIsFollowAppColorMode((settingFlag & SCBStatusBarSettingFlag.FOLLOW_SETTING) ===
          SCBStatusBarSettingFlag.FOLLOW_SETTING);
      }
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `recover systembar prop: ${systemBarProperty?.toString()}`);
    });
    scbSceneSession.sessionData.sessionState = sceneInfo.sessionState as sceneSessionManager.SessionState;
    scbSceneSession.sessionData.requestOrientation = scbSceneInfo.rotationStrategy;
    scbSceneSession.lastUsedTimestamp = SCBSceneSessionManager.getInstance()
      .getScenePersistent().getCacheLastUsedTimestamp(sceneSession.persistentId);
    let tempScreenProperty = this.screenProperty.getRotatedScreenProperty(sceneInfo.currentRotation);
    let sceneContainerSession = new SCBSceneContainerSession(scbSceneSession, tempScreenProperty);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!(DeviceHelper.isPad() && screenSession && screenSession.isRotateScreenPolicy())) {
      sceneContainerSession.currentRotation = sceneInfo.currentRotation;
    }
    sceneContainerSession.initAll();
    sceneContainerSession.getData(ContainerDataCategory.BASIC)?.setLastUsedPosition(SCBSceneSessionManager.getInstance()
      .getScenePersistent().getCacheLastUsedPosition(sceneSession.persistentId));

    if (sceneInfo.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE) {
      sceneContainerSession.requestActivation(false, ActiveReason.RECOVER);
    }
    // Only recover one window to the foreground
    if (sceneInfo.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE && !this.isRecoveredActiveSession) {
      this.isRecoveredActiveSession = true;
      this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE);
    } else {
      sceneInfo.sessionState = sceneSessionManager.SessionState.STATE_INACTIVE;
    }
    if (sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `update windowMode to full screen`);
      scbSceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    }
    if (scbSceneSession.isMainWindowTopmost !== sceneInfo.mainWindowTopmost) {
      scbSceneSession.isMainWindowTopmost = sceneInfo.mainWindowTopmost;
      SCBSceneSessionManager.getInstance().requestToTop(sceneSession.screenId, sceneSession.persistentId,
                                                        SCBWindowRaiseReason.SET_TOPMOST);
    }
    sceneContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
    this.panelMgr.addSceneContainerSession(sceneContainerSession);
  }

  private recentIdleCallback: RecentIdleCallback = {
    name: 'RecentIdleCallback',
    toHomeIdle: () => {
      this.panelViewModel.exitRecentAndNotifyFloat();
      RecentZoomAlarm.getInstance().cancel('touch up');
    },
    doTouchDown: (event: TouchEvent) => {
      RecentZoomAlarm.getInstance()
        .start(recentRuntimeInstance.touchContainerSession as SCBSceneContainerSession | null);
    },
    doTouchUp: (event: TouchEvent) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
    },
    toScrollFollowing: (deltaOffset: number, currentOffset: number) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
    },
    toScrollFling: (deltaOffset: number, currentOffset: number) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
    },
    toAppIdle: (sceneContainerSession: SCBSceneContainerSession) => {
      this.recentScroll.isInterruptFling = true;
      this.panelViewModel.startSceneFromRecent(sceneContainerSession);
    },
    clearAllMission: () => {
      this.clearRecentMissionsWithAnimation();
      // ApsUtils.setApsScene(apsManager.SceneAnimation.EXIT_MULTIPLE_TASKBARS, StyleConstants.DEFAULT_1);
    },
    onEnter: () => {
      RecentGestureEventManager.getInstance().initGesturePersistentId();
      return true;
    }
  }
  private recentScrollFollowingCallback: RecentScrollFollowingCallback = {
    name: 'RecentScrollFollowingCallback',
    doScroll: (deltaOffset: number, currentOffset: number) => {
      this.getUIContext().postFrameCallback(
        this.recentScroll.recentFrameCallBack
      );
      this.recentScroll.onScroll(deltaOffset, currentOffset, true);
    },
    doTouchUp: (event: TouchEvent) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
    },
    onLeave: (...args: FSMCallbackArgsType[]) => {
      AnimateToScheduleUtils.raiseRecentBuildSchedulePriority(AnimateToScheduleUtils.VALUE_END);
      return true;
    },
  }
  private recentScrollFlingCallback: RecentScrollFlingCallback = {
    name: 'RecentScrollFlingCallback',
    doScroll: (deltaOffset: number, currentOffset: number) => {
      this.getUIContext().postFrameCallback(
        this.recentScroll.recentFrameCallBack
      );
      this.recentScroll.flingOnScroll(deltaOffset, currentOffset);
    },
    doTouchDown: (event: TouchEvent) => {
      if (this.recentScroll.isInScrollFling()) {
        return;
      }
      RecentZoomAlarm.getInstance()
        .start(recentRuntimeInstance.touchContainerSession as SCBSceneContainerSession | null);
    },
    doTouchUp: (event: TouchEvent) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
    },
    toHomeIdle: () => {
      this.recentIdleCallback.toHomeIdle();
    },
    toAppIdle: (sceneContainerSession: SCBSceneContainerSession) => {
      this.recentIdleCallback.toAppIdle(sceneContainerSession);
    },
    touchDownToRecentIdle: () => {
      this.recentScroll.stopScrollImmediately('onTouchDown');
      this.recentScroll.isInterruptFling = true;
    },
    touchDownToScrollFollowing: () => {
      this.recentScroll.stopScrollImmediately('onTouchDown');
    },
    clearAllMission: () => {
      this.recentIdleCallback.clearAllMission();
    }
  }

  private recentDeleteFollowingCallback: RecentDeleteFollowingCallback = {
    name: 'RecentDeleteFollowingCallback',
    onEnter: (...args: FSMCallbackArgsType[]) => {
      let containerId = args[0] as number;
      let cardInterval: number = recentLayoutConfigInstance.isNeedMultiRowLayout() ? 2 : 1;
      this.recentGesture.setCardsTranslateX(containerId, cardInterval);
      this.recentGesture.onRecentGestureBegin(containerId, this.recentScroll.currentOffsetX,
        this.totalContainerSessionList);
      return true;
    },
    onLeave: (...args: FSMCallbackArgsType[]) => {
      this.recentGesture.resetCardsTranslateX();
      return true;
    },
    update: (containerId: number, event: GestureEvent) => {
      if (this.panelViewModel.isRecentState()) {
        this.recentGesture.onRecentGestureUpdate(containerId, event);
      }
    },
    restore: (containerId: number, event: GestureEvent) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
      this.recentGesture.restoreMoveUpAnimate(containerId);
    },
    cancel: (containerId: number, event: GestureEvent) => {
      RecentZoomAlarm.getInstance().cancel('touch up');
      RecentZoomAlarm.getInstance().cancelCallback();
      this.recentGesture.restoreMoveUpAnimate(containerId);
      this.recentGesture.cancel();
    },
    delete: (containerId: number, event: GestureEvent) => {
      this.onRecentGestureActionEnd(containerId, event);
    }
  }

  private appIdleCallback: AppIdleCallback = {
    name: 'AppIdleCallback',
    enterZoomFollowing: (offsetX: number, offsetY: number) => {
      quickSwitchRequestActiveAlarm.onAlarm();
      this.quickSwitchAnimations.removeNotShowSession(this.recentNotShow);
      this.quickSwitchAnimations.removePendingRemoveSessions();
      this.panelMgr.setSceneContainerSessionListForView(this.containerSessionList.filterClone());
      this.containerSessionList.getTopActiveSession()?.addTransitionCount();
      this.isSupportMaximizeScene = false;
      this.isShowCompanionIcon = false;
      recentViewModel.onEnterZoomFollowing();
      const enableBlurComponent: boolean = !DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()
        && !StartAndExitVisualEffectManager.getInstance().isPowerSaveMode()
        && !StartAndExitVisualEffectManager.getInstance().isStartExitBlurDisable()
        && !launcherVisualEffectMgr.isRecentBlurEffectDisabled();
      if (enableBlurComponent) {
        this.panelMgr.enableBlurComponent('appIdleCallback-enterZoomFollowing');
      }
    },
    enterQuickSwitchFollowing: (offsetX: number, offsetY: number) => {
      let sceneContainerSession = this.containerSessionList.getTopActiveSession();
      this.recentEnter.breakEnterRecentAnimations('enter quickswitch form app');
      // show wallpaper and desktop when starting gesture from full scene
      ViewManagerPolicy.showView(ViewType.DESKTOP);
      ViewManagerPolicy.showView(ViewType.WALLPAPER);
      if (!launcherVisualEffectMgr.isRecentBlurEffectDisabled()) {
        this.panelMgr.enableBlurComponent('appIdleCallback-enterQuickSwitchFollowing');
      }
      this.quickSwitchAnimations.removeNotShowSession(this.recentNotShow);
      this.quickSwitchAnimations.removePendingRemoveSessions();
      this.panelMgr.setSceneContainerSessionListForView(this.containerSessionList.filterClone());
      this.quickSwitchAnimations.updateParmForFollowing(offsetY);
      this.quickSwitchAnimations.init();
      this.quickSwitchAnimations.interruptAllContainerAnimations();
      this.panelViewModel.updateScenePanelState(ScenePanelState.QUICK_SWITCH);
    },
    onEnter: () => {
      this.recentEnter.publishRecentEvent(false);
      RecentGestureEventManager.getInstance().initGesturePersistentId();
      return true;
    },
    onLeave: () => {
      QuickSwitchRaiseTopAlarm.getInstance().cancel('leave app idle');
      RecentDockRefreshAlarm.getInstance().onAlarm();
      this.recentEnter.publishRecentEvent(true);
      let persistentId = this.containerSessionList.getTopActiveSession()?.getPersistentId();
      RecentGestureEventManager.getInstance().setGesturePersistentId(persistentId);
      return true;
    }
  };
  private zoomFollowingFromAppCallback: ZoomFollowingFromAppCallback = {
    name: 'ZoomFollowingFromAppCallback',
    update: (gestureEvent: GestureEvent) => {
      this.zoomFollowing.updateAppZoomView(gestureEvent);
    },
    onEnter: () => {
      this.quickSwitchAnimations.breakQuickSwitchAnimations();
      this.recentEnter.breakEnterRecentAnimations('enter zoomFollowingFromApp');
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.ENTER_ZOOM_FOLLOWING, this.containerSessionList.getTopActiveSession());
      launcherVisualEffectMgr.hideLauncher();
      return true;
    },
    enterRecentFollowing: (gestureEvent: GestureEvent) => {
      this.panelFsm.getRecentController().removePendingSessionIfNeed();
      this.updateRecentParmBeforeAnimate(gestureEvent.offsetX, gestureEvent.offsetY);
      this.recentEnter.followingAnimateToRecentFromAppWithGestureEvent(gestureEvent);
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_RECENT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    },
    enterQuickSwitchFollowing: (offsetX: number, offsetY: number) => {
      this.quickSwitchAnimations.updateParmForFollowing(offsetY);
      this.quickSwitchAnimations.init();
      this.quickSwitchAnimations.interruptOtherContainerAnimations();
      this.panelViewModel.updateScenePanelState(ScenePanelState.QUICK_SWITCH);
    },
    enterFarAwayFollowing: (offsetX: number, offsetY: number) => {
    },
    enterHomeIdle: (offsetX: number, offsetY: number) => {
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      QuickSwitchRaiseTopAlarm.getInstance().startImmediately(this.containerSessionList.getTopActiveSession());
      this.recentEnter.breakEnterRecentAnimations('enterHomeIdle');
      this.panelViewModel.minimizeAllScene();
      this.recentInnerState.onInit();
    },
    enterHomeIdleByOneStep: (offsetX: number, offsetY: number) => {
      this.panelFsm.getRecentController().enterHomeIdleIfNeed(this.zoomFollowingFromAppCallback, offsetX, offsetY);
    },
    enterAppIdle: (offsetX: number, offsetY: number) => {
      let isEnterHomeIdle =
        this.panelFsm.getRecentController().enterHomeIdleIfNeed(this.zoomFollowingFromAppCallback, offsetX, offsetY);
      if (isEnterHomeIdle) {
        return;
      }
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING,
          this.containerSessionList.getTopActiveSession());
      this.onEnterAppFullScreen();
      homeLog.showInfo(`EVENT_NAVI_BAR_STATUS_CHANGE`);
      this.recentInnerState.onInit();
      localEventManager.sendLocalEvent(EventConstants.EVENT_NAVI_BAR_STATUS_CHANGE, NaviBarChangeType.SHOW_BAR);
    }
  };
  private recentFollowFromAppCallback: RecentFollowingFromAppCallback = {
    name: 'RecentFollowingFromAppCallback',
    onEnter: () => {
      this.recentEnter.printFollowStartLog();
      this.quickSwitchAnimations.breakQuickSwitchAnimations();
      return true;
    },
    onLeave: () => {
      this.recentEnter.printFollowEndLog();
      return true;
    },
    prepareToFarAwayUpdate: (gestureEvent: GestureEvent, prepareFarAwayPercent: number) => {
      this.prepareToFarAwayFollowingUpdate(gestureEvent, prepareFarAwayPercent);
    },
    update: (gestureEvent: GestureEvent) => {
      this.updateRecentParmBeforeAnimate(gestureEvent.offsetX, gestureEvent.offsetY);
      this.recentEnter.followingAnimateToRecentFromAppWithGestureEvent(gestureEvent);
    },
    enterQuickSwitchFollowing: (offsetX: number, offsetY: number) => {
      this.quickSwitchAnimations.updateParmForFollowing(offsetY);
      this.panelViewModel.updateScenePanelState(ScenePanelState.QUICK_SWITCH);
      this.recentInnerState.onInit();
    },
    enterFarAwayFollowing: (offsetX: number, offsetY: number) => {
      this.recentEnter.enterAppFarViewAnimations();
    },
    enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean) => {
      let currContainerSession = this.containerSessionList.getTopActiveSession();
      if (!currContainerSession) {
        recentLog.showWarn('current session is null');
        this.recentFollowFromAppCallback.enterHomeIdle(offsetX, offsetY);
        this.panelFsm.setCurrentStateToHome();
        return;
      }
      if (!this.panelViewModel.isRecentState()) {
        this.updateRecentView(offsetX, offsetY);
      }
      recentRuntimeInstance.navigationEndPos = [offsetX, offsetY];
      this.reportParamsFromApp();
      this.panelViewModel.enterRecentView(isFromNavigationCallback, true);
    },
    enterHomeIdle: (offsetX: number, offsetY: number) => {
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.ENTER_APP_IDLE_FROM_RECENT_FOLLOWING,
          this.containerSessionList.getTopActiveSession());
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      this.recentEnter.enterHomeFromRecentFollowingAnimation();
      QuickSwitchRaiseTopAlarm.getInstance().startImmediately(this.containerSessionList.getTopActiveSession());
      this.panelViewModel.minimizeAllScene(true);
      this.recentInnerState.onInit();
    },
    enterHomeIdleByOneStep: (offsetX: number, offsetY: number) => {
      this.panelFsm.getRecentController().enterHomeIdleIfNeed(this.recentFollowFromAppCallback, offsetX, offsetY);
    },
    enterAppIdle: (offsetX: number, offsetY: number) => {
      let isEnterHomeIdle =
        this.panelFsm.getRecentController().enterHomeIdleIfNeed(this.recentFollowFromAppCallback, offsetX, offsetY);
      if (isEnterHomeIdle) {
        return;
      }
      this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE, false);
      this.recentEnter.enterAppFromRecentFollowing();
      this.recentInnerState.onInit();
      this.panelViewModel.showStatusBar(true);
      let topActiveSession = SCBScenePanelManager.getInstance().getSceneContainerSessionList()?.getTopActiveSession();
      SCBSceneSessionManager.getInstance()
        .updateNavigationBarProperty(topActiveSession?.mainSessionActive?.systemBarProperty?.
        get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable, topActiveSession?.mainSessionActive);
    }
  };
  private farAwayFollowingFromAppCallback: FarAwayFollowingFromAppCallback = {
    name: 'FarAwayFollowingFromAppCallback',
    update: (gestureEvent: GestureEvent) => {
      this.zoomFollowing.updateAppZoomView(gestureEvent);
    },
    enterRecentFollowing: (offsetX: number, offsetY: number) => {
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_RECENT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    },
    enterHomeIdle: (offsetX: number, offsetY: number) => {
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      QuickSwitchRaiseTopAlarm.getInstance().startImmediately(this.containerSessionList.getTopActiveSession());
      this.panelViewModel.minimizeAllScene();
      this.recentInnerState.onInit();
    },
    enterHomeIdleByOneStep: (offsetX: number, offsetY: number) => {
      this.panelFsm.getRecentController().enterHomeIdleIfNeed(this.farAwayFollowingFromAppCallback, offsetX, offsetY);
    }
  };
  private quickSwitchFollowingFromAppCallback: QuickSwitchFollowingFromAppCallback = {
    name: 'QuickSwitchFollowingFromAppCallback',
    onEnter: (from: FSMState) => {
      this.quickSwitchAnimations.onEnterFollowing(from);
      return true;
    },
    update: (gestureEvent: GestureEvent) => {
      this.quickSwitchAnimations.updateParmForFollowing(gestureEvent.offsetY + px2vp(20));
      if (!this.panelViewModel.isQuickSwitchState() && !this.panelViewModel.isRecentState()) {
        this.quickSwitchAnimations.init();
        this.quickSwitchAnimations.interruptAllContainerAnimations();
      }
      this.panelViewModel.updateScenePanelState(ScenePanelState.QUICK_SWITCH);
      this.quickSwitchAnimations.updateSwitchViewFromApp(gestureEvent);
    },
    enterRecentFollowing: (offsetX: number, offsetY: number) => {
      quickSwitchRequestActiveAlarm.onAlarm();
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_RECENT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    },
    enterQuickSwitchIdle: (offsetX: number, offsetY: number) => {
      let fromContainerSession = quickSwitchViewModel.getTopSession(this.containerSessionList);
      if (fromContainerSession) {
        quickSwitchViewModel.initQuickSwitchViewModel(this.panelViewModel, this.quickSwitchAnimations);
        quickSwitchViewModel.enterQuickSwitchIdle(true, offsetX, offsetY);
        // recentfollowing打断状态栏显示，转appidle状态需要设置显示
        this.panelViewModel.showStatusBar(true);
      } else {
        quickSwitchRequestActiveAlarm.cancel();
        homeLog.showInfo(`enterQuickSwitchIdle fromContainerSession is null`);
        this.quickSwitchFollowingFromAppCallback.enterHomeIdle(0, 0);
      }
    },
    enterHomeIdle: (offsetX: number, offsetY: number) => {
      quickSwitchRequestActiveAlarm.onAlarm();
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      QuickSwitchRaiseTopAlarm.getInstance().startImmediately(quickSwitchViewModel.getTopSession(this.containerSessionList));
      this.panelViewModel.minimizeAllScene();
    },
    enterHomeIdleByOneStep: (offsetX: number, offsetY: number) => {
      quickSwitchRequestActiveAlarm.onAlarm();
      this.panelFsm.getRecentController().enterHomeIdleIfNeed(this.quickSwitchFollowingFromAppCallback, offsetX,
        offsetY);
    },
    enterAppIdle: (offsetX: number, offsetY: number) => {
      let fromContainerSession = quickSwitchViewModel.getTopSession(this.containerSessionList);
      if (fromContainerSession) {
        quickSwitchRequestActiveAlarm.onAlarm();
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING,
            quickSwitchViewModel.getTopSession(this.containerSessionList));
        this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE, false);
        this.quickSwitchAnimations.enterAppFromQuickSwitchFollowing(offsetX);
        this.panelViewModel.showStatusBar(true);
        let topActiveSession = SCBScenePanelManager.getInstance().getSceneContainerSessionList()?.getTopActiveSession();
        SCBSceneSessionManager.getInstance()
          .updateNavigationBarProperty(topActiveSession?.mainSessionActive?.systemBarProperty?.
          get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable, topActiveSession?.mainSessionActive);
      } else {
        homeLog.showInfo(`enterAppIdle fromContainerSession is null`);
        this.quickSwitchFollowingFromAppCallback.enterHomeIdle(0, 0);
      }
    },
    enterFarAwayFollowing: (offsetX: number, offsetY: number) => {
      quickSwitchRequestActiveAlarm.onAlarm();
      this.recentEnter.updateRecentParmForFollowing(offsetX, offsetY, true);
      this.recentEnter.enterAppFarViewAnimations();
    }
  };

  private getSwipeController(): ThreeFingerSwipeController {
    if (CheckEmptyUtils.isEmpty(this.swipeController)) {
      this.swipeController = new ThreeFingerSwipeController();
    }
    return this.swipeController as ThreeFingerSwipeController;
  }

  private threeFingerSwiperCallback: ThreeFingerSwiperCallback = {
    name: 'phonePanel',
    onThreeFingerSwiperBegin: ()=> {
      homeLog.showInfo('[SCBMain]threeFingerSwiperCallback onThreeFingerSwiperBegin');
      this.getSwipeController().reset();
      this.isHandleThreeFingerSwiper = true;
      DropDownPanelManager.animToDismissEvent();
      let event: GestureEvent = this.getThreeFingerEvent(ThreeFingerSwipeType.BEGIN);
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_SWIPER_FROM_BOTTOM);
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
      this.isTouchableByNavBar = true;
      this.panelViewModel.setScenePanelTouchableByNavigation();
      this.doBreakMaxSplitViewAnimation();
      recentRuntimeInstance.navigationStartPos = [event?.fingerList[0]?.globalX, event?.fingerList[0]?.globalY];
      this.viewParam.recentPadding = 0;
      this.viewParam.recentH = this.screenProperty.height;
      this.initFsmState();
      this.panelFsm.consumeStartEvent(event);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLLOW_HAND, StyleConstants.DEFAULT_1);
    },
    onThreeFingerSwiperUpdate: (x: number, y: number, time: number) => {
      homeLog.showInfo('[SCBMain]threeFingerSwiperCallback onThreeFingerSwiperUpdate');
      if (!this.isHandleThreeFingerSwiper) {
        return;
      }
      if (!this.preProcessSwiper(x, y, time)) {
        return;
      }
      let event: GestureEvent = this.getThreeFingerEvent(ThreeFingerSwipeType.UPDATE);
      this.panelFsm.consumeUpdateEvent(event);
    },
    onThreeFingerSwiperEnd:() => {
      homeLog.showInfo('[SCBMain]threeFingerSwiperCallback onThreeFingerSwiperEnd');
      let event: GestureEvent = this.getThreeFingerEvent(ThreeFingerSwipeType.END);
      this.isTouchableByNavBar = false;
      recentRuntimeInstance.navigationEndPos = [event?.fingerList[0]?.globalX, event?.fingerList[0]?.globalY];
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLLOW_HAND, StyleConstants.DEFAULT_0);
      this.panelFsm.consumeEndEvent(event);
      this.panelViewModel.setScenePanelTouchableByNavigation();
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_SWIPER_FROM_BOTTOM);
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
      this.getSwipeController().reset();
      this.isHandleThreeFingerSwiper = false;
    },
    onThreeFingerSwiperCancel: () => {
      homeLog.showInfo('[SCBMain]threeFingerSwiperCallback onThreeFingerSwiperCancel');
      let event: GestureEvent = this.getThreeFingerEvent(ThreeFingerSwipeType.CANCEL);
      this.isTouchableByNavBar = false;
      this.panelViewModel.setScenePanelTouchableByNavigation();
      recentRuntimeInstance.navigationEndPos = [event?.fingerList[0]?.globalX, event?.fingerList[0]?.globalY];
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLLOW_HAND, StyleConstants.DEFAULT_0);
      this.panelFsm.consumeCancelEvent(event);
      this.getSwipeController().reset();
      this.isHandleThreeFingerSwiper = false;
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    }
  }

  private preProcessSwiper(x: number, y: number, time: number): boolean {
    homeLog.showInfo(`[SCBMain]threeFingerSwiperCallback preProcessSwiper ${x} ${y} ${time}`);
    if (this.getSwipeController().startEvent.x === -1 && this.getSwipeController().startEvent.y === -1) {
      this.getSwipeController().preEvent.set(x, y, time);
      this.getSwipeController().startEvent.set(x, y, time);
      Trace.end(Trace.CORE_METHOD_THREE_FINGERS_SWIPE_START);
      return false;
    }
    if (this.getSwipeController().curEvent.x !== -1 && this.getSwipeController().curEvent.y !== -1) {
      this.getSwipeController().preEvent.clone(this.getSwipeController().curEvent);
    }
    this.getSwipeController().curEvent.set(x, y, time);
    this.getSwipeController().calcSpeedAndAcc();
    this.getSwipeController().calcSwipeAngle();
    return true;
  }

  private getThreeFingerEvent(type: string): GestureEvent {
    const screenWidth = px2vp(this.screenProperty.width);
    const screenHeight = px2vp(this.screenProperty.height);
    const positionX = screenWidth / ThreeFingerSwipeConstants.DEFAULT_2;
    const positionY = screenHeight;
    let event: GestureEvent = this.getSwipeController().createGestureEvent(positionX, positionY);
    event.target.area.height = this.screenProperty.height;
    event.target.area.width = this.screenProperty.width;
    homeLog.showDebug(`[SCBMain]getThreeFingerEvent : ${event.offsetX} ${event.offsetX} type:${type}`);
    return event;
  }

  private onEnterAppFullScreen(): void {
    this.panelViewModel.showStatusBar(true);
    ContainerBuilder.resetAllContainerPreBuildStage(this.containerSessionList);
    this.containerSessionList.forEach((item) => {
      item.isDisappearing = false;
      item.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'onEnterAppFullScreen', item.getName());
    })
    this.recentInnerState.onInit();
    homeLog.showInfo(`EnterAppFullScreen`);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_ORIGIN_APP, StyleConstants.DEFAULT_1);
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    let animationNum = topContainerSession?.getTransitionCount();
    SCBKeyboardManager.getInstance().addUnInterruptableAnimationCallbackFlag();
    animateTo({
      curve: curves.springMotion(),
      onFinish: () => {
        SCBKeyboardManager.getInstance().removeUnInterruptableAnimationCallbackFlag();
        homeLog.showInfo(`raiseAnimateToSchedulePriority:app full screen end`);
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_ORIGIN_APP, StyleConstants.DEFAULT_0);
        if (this.scenePanelState === ScenePanelState.FULLSCENE) {
          if (topContainerSession && topContainerSession.getTransitionCount() === animationNum) {
            topContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
              TAG, 'onEnterAppFullScreen', topContainerSession.getName());
          }
          RecentGestureEventManager.getInstance()
            .deliverGestureEvent (RecentGestureEvent.ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING_END,
              this.containerSessionList.getTopActiveSession());
          if (!this.isTouchableByNavBar) {
            SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange(false);
          }
        }
      }
    }, () => {
      this.panelViewModel.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
    })
    QuickSwitchRaiseTopAlarm.getInstance().start(topContainerSession, 'enter app full scrren');
  }

  // Input method display and collapse callback
  keyboardShowCallback = (keyboardSession: SCBKeyboardSession): void => {
  }

  // Input method rect change callback
  keyboardRectChangeCallback = (): void => {
  }

  // Desktop mode change callback
  modeChangeCallBack = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum): void => {
    if (preDesktopMode === DesktopModeEnum.BASE_MODE &&
      (targetDesktopMode === DesktopModeEnum.EMERGENCY_MODE ||
        targetDesktopMode === DesktopModeEnum.THERMAL_SAFE_MODE)) {
      homeLog.showInfo(`ModeChangeCallBack, desktop mdoe change to ${targetDesktopMode}`);
      // Exit app
      this.panelViewModel.minimizeAllScene();
      this.changeRotation();
      // Exit recent
      if (this.containerSessionList.length > 0) {
        this.recentInnerState.onExitAnimating();
      } else {
        this.recentInnerState.onInit();
      }
    } else if (targetDesktopMode === DesktopModeEnum.BASE_MODE) {
      this.changeRotation();
      this.initFsmState();
    }
    this.panelViewModel.setEmergencyOrThermalSafeModeDuration();
  }

  private changeRotation(): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty?.screenId);
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      homeLog.showInfo('changeRotation default rotation');
      SCBWindowRotateController.getInstance().windowRotateEntry(screenSession.getScreenDefaultRotation(), 'mergency', false, true);
    } else {
       homeLog.showInfo('changeRotation exitSceneWithRotationRecover');
       this.panelViewModel.exitSceneWithRotationRecover();
    }
  }

  private reportParamsFromApp(): void {
    let bundleName = '';
    let curSession = this.containerSessionList.getTopActiveSession();
    if (!curSession) {
      this.reportParams('APP', bundleName);
      return;
    }
    if (curSession.primarySession) {
      bundleName += curSession.primarySession.sceneInfo.bundleName;
    }
    if (curSession.secondarySession) {
      bundleName += ' || ';
      bundleName += curSession?.secondarySession.sceneInfo.bundleName;
    }
    this.reportParams('APP', bundleName, curSession?.isMidScene);
  }

  private reportParams(from: string, bundleName: string = '', isMidScene: boolean = false) {
    // 设备状态 0 非折叠屏 1 折叠屏展开态 2 折叠屏非展开态
    let deviceStatus = DeviceHelper.isFold() ? (DeviceHelper.isFoldExpanded() ? 1 : 2) : 0;
    let orientation = RecentRotationUtil.getRotateStatus(RecentRotationUtil.getScreenRotation(this.screenProperty));
    let sessionNum = this.containerSessionList.length;
    recentRuntimeInstance.reportGoIntoRecent(from, deviceStatus, orientation, bundleName, sessionNum, isMidScene);
  }

  private homeIdleCallback: HomeIdleCallback = {
    name: 'HomeIdleCallback',

    onEnter: () => {
      RecentGestureEventManager.getInstance().initGesturePersistentId();
      return true;
    },

    onLeave: () => {
      return true;
    },

    gestureStart: () => {
      if (FolderManager.getInstance().isFolderClosing()) {
        ContractedFolderCommonViewModel.getInstance()
          .closeFolder('homeIdle gesture start', FolderOperationFlag.IMMEDIATELY);
      }
      recentLog.info(`gestureStart isUiThreadBusy ${LauncherAnimUtil.isUiThreadBusy()}`);
      if (LauncherAnimUtil.isUiThreadBusy()) {
        SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      }
    },

    onEnterOverView: () => {
      themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({ animationType: AnimationType.WALLPAPER_STOP_PAD });
      if (this.keyboardState === KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE && this.keyboardSession?.isActive) {
        localEventManager.sendLocalEvent(EventConstants.EVENT_GESTURE_NAVIGATION_HIDE_TEXT_INPUT);
        this.desktopContext?.eventHub.emit(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT);
      }
      localEventManager.sendLocalEvent(EventConstants.EVENT_FLOAT_ON_FOCUS);
      RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.ENTER_RECENT_FOLLOWING_FROM_HOME);
      // 关闭FA服务卡片
      if (!editModeManager.isInEditMode()) {
        FormCenterViewManager.getInstance().closeFormCenterView();
      }
      this.quickSwitchAnimations.breakQuickSwitchAnimations();
      this.recentEnter.breakEnterRecentAnimations('enter recent from home');
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_RECENT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
      this.isSupportMaximizeScene = false;
      this.panelFsm.getRecentController().removePendingSessionIfNeed();
      let containerSession = this.containerSessionList.getTopSession();
      recentLog.info(`enter recent from desktop before ${this.panelMgr.getSceneContainerSessionListForView().length}
          ${this.panelMgr.getSceneContainerSessionList().length}`);
      if (containerSession) {
        if (this.recentNotShow.getShowStatus(containerSession) !== ContainerShowState.SHOW) {
          this.recentNotShow.notShowSessionDestroy(containerSession, this.totalContainerSessionList);
        } else {
          let controller = this.panelViewModel.getTargetTransitionController(containerSession,
            containerSession.primarySession?.sceneInfo);
          controller?.onInactive(TAG, 'onEnterSwitch');
        }
      }
      this.panelMgr.setSceneContainerSessionListForView(this.containerSessionList.filterClone());
      this.recentEnter.initSessionListLength();
      recentLog.info(`enter recent from desktop after ${this.panelMgr.getSceneContainerSessionListForView().length}
          ${this.panelMgr.getSceneContainerSessionList().length}`);
      if (SCBTransitionManager.getInstance().getStartExitAnimationCount() <= 0) {
        // 当前没有启动退出动画在执行，才隐藏过渡图标
        this.isShowCompanionIcon = false;
      }
      SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    },

    enterHomeIdle: () => {
      homeViewModel.onEnterHome(true);
    },

    update: (offsetX: number, offsetY: number) => {
      homeViewModel.onHomeIdleUpdate(offsetY);
    }
  };

  private overViewFollowingFromHomeCallback: OverViewFollowingFromHomeCallback = {
    name: 'OverViewFollowingFromHomeCallback',
    update: (offsetX: number, offsetY: number): void => {
      if (!this.isShowEmptyRecentView(offsetY)) {
        if (!this.panelViewModel.isRecentState()) {
          this.updateFollowingViewParams(false);
        }
        homeViewModel.onOverViewFollowingUpdate(offsetX, offsetY, this.panelViewModel.isRecentState());
        this.panelViewModel.updateScenePanelState(ScenePanelState.RECENT, false);
        homeViewModel.doFollowingAnimateToRecentFromHome();
      }
    },

    enterHomeIdle: (): void => {
      homeViewModel.onEnterHome(false);
      this.panelViewModel.updateScenePanelState(ScenePanelState.HOME, false);
      this.panelViewModel.showStatusBar(true);
    },

    enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean): void => {
      if (!this.panelViewModel.isRecentState()) {
        // 进入recentView之前必须调用一次update，防止状态不正确
        this.overViewFollowingFromHomeCallback.update(0, 0);
      }
      if(!isFromNavigationCallback){
        this.onRecentInputCLoseKeyboard();
      }
      recentRuntimeInstance.navigationEndPos = [offsetX, offsetY];
      this.reportParams('HOME');
      this.panelViewModel.enterRecentView(isFromNavigationCallback, false);
    },

    enterQuickSwitchIdle: (offsetX: number, offsetY: number): void => {
      if (this.panelMgr.getSceneContainerSessionListForView().length > 0) {
        homeViewModel.enterQuickSwitchIdle(offsetX, offsetY, this.enterSwitchAnimationFinishCallback);
        this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE, false);
      } else {
        this.panelViewModel.updateScenePanelState(ScenePanelState.HOME);
      }
    },

    onExitOverView: () => {
      homeViewModel.onEnterHome(false);
      this.panelViewModel.updateScenePanelState(ScenePanelState.HOME);
      this.panelViewModel.showStatusBar(true);
    }
  };

  private onRecentInputCLoseKeyboard(): void {
    if (this.keyboardState === KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE && this.keyboardSession?.isActive) {
      localEventManager.sendLocalEvent(EventConstants.EVENT_GESTURE_NAVIGATION_HIDE_TEXT_INPUT);
      this.desktopContext?.eventHub.emit(EventConstants.EVENT_FOLDER_CLOSE_RENAME_INPUT);
    }
  }

  private emergencyHomeIdleCallback: EmergencyHomeIdleCallback = {
    name: 'EmergencyHomeIdleCallback',
    enterHomeIdle: (offsetX: number, offsetY: number) => {
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      this.panelViewModel.minimizeAllScene();
    }
  }

  private outdoorIdleCallback: EmergencyHomeIdleCallback = {
    name: 'OutdoorIdleCallback',
    enterHomeIdle: (offsetX: number, offsetY: number) => {
      if (this.scenePanelState === ScenePanelState.HOME) {
        homeLog.showInfo(`outdoorIdleCallback enterHome`);
        homeViewModel.onEnterHome(true);
      }
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      this.panelViewModel.minimizeAllScene();
    }
  }

  private onGestureChange = (action: SCBGestureAction) => {
    homeLog.showInfo(`onGestureChange! action: ${action.actionId} sceneState: ${this.scenePanelState}`);
    switch (action.actionId) {
      case SCBGestureActionId.EXIT_SPLIT:
        this.exitSplitView(action.sessionId);
        break;
      case SCBGestureActionId.ONE_STEP_ENTER_SPLIT:
        this.onEnterOneStepSplitScene();
        break;
      case SCBGestureActionId.ONE_STEP_ENTER_FLOATING:
        this.oneStepEnterFloat();
        break;
      default:
        break;
    }
  }
  /**
   * scene抬升至顶部回调监听
   */
  private onRaiseSceneToTop = (containerSession: SCBSceneContainerSession) => {
    RecentDockRefreshAlarm.getInstance().onAlarm();
    // 刷新最近任务区及侧边dock,延迟刷新，避免直接刷新
    RecentDockRefreshAlarm.getInstance().start(containerSession, this.scenePanelState);
  };

  // 检查当前是不是这个scenePanel，在自由多窗模式会使用自由多窗的ScenePanel
  private checkIsUseThisScenePanel(): boolean {
    return this.isUseThisScenePanel;
  }

  private updateScrollEnableMode(): void {
    FloatingNavigationManager.getInstance()?.setScenePanelState(this.scenePanelState);
    if (!this.checkIsUseThisScenePanel()) {
      homeLog.showInfo('current scene panel is not use, no need response updateScrollEnableMode');
      return;
    }
    let currentState: ScenePanelState = this.scenePanelState;
    if (currentState === ScenePanelState.RECENT) {
      this.isScrolling = true
    } else if (this.isScrolling && !this.timer) {
      TraceUtil.startTrace(DomainName.RECENT, "update scroll");
      animateToImmediately({
        duration: 0,
        onFinish: () => {
          // 监听退出多任务列表
          SCBSceneSessionManager.getInstance().callRecentFuncs(false);
          TraceUtil.endTrace(DomainName.RECENT, "update scroll");
          this.isScrolling = (currentState === ScenePanelState.RECENT);
        }
      }, () => {
      })
    }
    homeLog.showInfo(`is scrolling value is  ${this.isScrolling}  state is  ${currentState} `);
    this.refreshAppFrontMemScene(currentState);
  }

  private refreshAppFrontMemScene(currentState: ScenePanelState) {
    let isCurrentAppFront: boolean = (currentState === ScenePanelState.FULLSCENE);
    if (this.isAppFront !== isCurrentAppFront) {
      this.isAppFront = isCurrentAppFront;
      if (this.isAppFront) {
        PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_APP_FRONT);
      } else {
        PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_APP_FRONT);
      }
    }
  }

  private beforeFoldExpandStatusChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
                                       currScreenProperty?: SCBScreenProperty): void {
    SCBSceneSessionManager.getInstance().setSystemSceneRotatable(screenProperty);
    if (this.scenePanelState === ScenePanelState.RECENT) {
      this.exitRecentWhenFoldChange();
    }

    let floatContainerList = this.floatingSessionList.getActiveSessionList();
    floatContainerList.forEach(floatContainer => {
      this.resetFloatViewWithFold(floatContainer);
    })

    let topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession === null || topContainerSession === undefined) {
      return;
    }
    if (topContainerSession.primarySession?.isPcAppInPad && DeviceHelper.isThreeFoldProduct() &&
      SCBTriFoldManager.getInstance().getCurTriFoldState() === SCBTripleFoldState.G) {
      this.beforeFoldExpandForPCSession(topContainerSession);
    } else {
      this.panelViewModel.showSnapShotOnExpand(topContainerSession);
    }
    this.resetSplitViewWithFold(topContainerSession.primarySession?.session.persistentId,
      topContainerSession.containerId);
  }

  private beforeFoldExpandForPCSession(topContainerSession: SCBSceneContainerSession): void {
    topContainerSession.isShowContainerSnapshot = true;
    topContainerSession.containerSnapshotResource =
      sceneSessionManager.getSessionSnapshotPixelMapSync(topContainerSession.primarySession?.session.persistentId,
        1, SnapshotNodeType.DEFAULT_NODE, true);
  }

  private foldExpandStatusChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    if (this.scenePanelState === ScenePanelState.QUICK_SWITCH || this.scenePanelState === ScenePanelState.FULLSCENE) {
      this.quickSwitchAnimations.setVisibilityWhenFoldStatusChange(this.containerSessionList);
    }
    if (this.panelViewModel.isInAppExit) {
      // 退出动效过程中旋转直接打断动效
      SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    }
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession && topContainerSession.isSplit) {
      this.foldExpandStatusChangeForSplit(topContainerSession, screenProperty, reason);
    }
    if (topContainerSession?.primarySession?.isPcAppInPad) {
      this.panelViewModel.pcAppExitWithFold(screenProperty);
    } else if (!this.shouldSkipFoldExpandWindowsAnimation()) {
      this.foldExpandWindowsAnimation(reason);
    }
    recentLayoutConfigInstance
      .updateMultiRowLayout(desktopUtil.isFoldExpandStatus());
    RecentForegroundBlurAniMgr.getInstance().updateFoldExpandStatus(desktopUtil.isFoldExpandStatus());
    this.initRecentLayoutParam();
  }

  private shouldSkipFoldExpandWindowsAnimation(): boolean {
    if (SCBOobeManager.isOobeActivated()) {
      homeLog.showInfo('Skip Windows FoldExpand Animation by Oobe Activation');
      return true;
    }
    if (FoldExpandAnimUtils.isSupportProduct) {
      // if support fold effect, skip window animation
      return true;
    }
    return false;
  }

  onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[onScreenPropertyChange] reason:' + reason);
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.foldExpandStatusChange(screenProperty, reason);
    }

    if (reason === SCBPropertyChangeReason.ROTATION) {
      if (!this.isNeedProcessRotate(screenProperty)) {
        return;
      }
      this.panelViewModel.notifyRotationWithAnimation(screenProperty, SCBContainerRotationReason.SCREEN_ROTATION);
    } else if (reason === SCBPropertyChangeReason.CHANGE_MODE) {
      this.processChangeMode(screenProperty);
    } else if (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
      reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START ||
      reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      if (this.isNeedProcessRotateExpand(reason)) {
        homeLog.showInfo('no need to rotate in the lock screen interface');
        return;
      }
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[onScreenPropertyChange] screen change: ${screenProperty.getLogString()}`);
      this.processRotateExpand(screenProperty, reason);
      let containerSession = this.containerSessionList.getTopActiveSession();
      if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD && containerSession && containerSession.isSplit) {
        this.panelViewModel.exitSplitViewByExpandToFold(containerSession.primarySession?.session.persistentId,
          containerSession.containerId);
      }
    }
  }

  private isNeedProcessRotateExpand(reason: SCBPropertyChangeReason): boolean {
    return SCBSceneSessionManager.getInstance().isScreenLocked() &&
      reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
  }

  private isNeedProcessRotate(screenProperty: SCBScreenProperty): boolean {
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      homeLog.showInfo('no need to rotate in the lock screen interface');
      return false;
    }
    if (this.screenProperty.rotation === screenProperty.rotation) {
      homeLog.showWarn('onScreenPropertyChange no need to rotation with targetRotation:' + screenProperty.rotation +
        ' currentScreenRotation: ' + this.screenProperty.rotation);
      return false;
    }
    return true;
  }

  private processChangeMode(screenProperty: SCBScreenProperty) {
    let oldScreenProperty = new SCBScreenProperty();
    oldScreenProperty.copy(this.screenProperty);
    homeLog.showInfo('onScreenPropertyChange oldScreenProperty:' + JSON.stringify(oldScreenProperty) +
      ' newScreenProperty:' + JSON.stringify(screenProperty));
    this.screenProperty.copy(screenProperty);
    this.viewParam.recentW = this.viewParam.recentW * screenProperty.width / oldScreenProperty.width;
    this.viewParam.recentH = this.viewParam.recentH * screenProperty.height / oldScreenProperty.height;

    for (let containerSession of this.containerSessionList) {
      homeLog.showInfo('Update containerSession: ' + containerSession?.containerId + ' name:' +
      containerSession?.primarySession?.sceneInfo.bundleName + ' isActive: ' + containerSession?.isActive);
      containerSession?.updateContainerSessionWithActiveMode(oldScreenProperty, screenProperty);
    }
    SCBScreenSessionManager.getInstance().updateSystemActiveModeChange(oldScreenProperty, screenProperty);
  }

  private tryBreakSplitAnimBeforeFold(container: SCBSceneContainerSession, reason: SCBPropertyChangeReason) {
    if (!container) {
      winLog.showWarn('tryBreakSplitAnimBeforeFold container is invalid');
      return;
    }
    if ((reason === SCBPropertyChangeReason.EXPAND_TO_FOLD || reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) &&
      container.splitParam.getLifeCycle() === SplitLifeCycle.EXIT_SPLIT_TO_FULLSCREEN) {
      container.splitParam.decreNeedDelayRotation();
    }
  }

  private processRotateExpand(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[processRotateExpand] process rotate expand, `+
                     `screenProperty: ` + JSON.stringify(screenProperty) + ` reason:` + reason);
    this.screenProperty.copy(screenProperty);
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
      if (!screenSession) {
        WinLog.showError(WinLogDomain.WMS_ROTATION, '[processRotateExpand] screenSession is null');
        return;
      }
      screenSession.rotationController.updateCurrRotation(screenProperty.rotation);
    } else {
      this.panelViewModel.updateCurrRotation(screenProperty.rotation);
    }
    this.viewParam.onScreenChange(this.screenProperty, reason);
    let topActiveSession = this.expandStartContainerSession;
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession) {
      this.tryBreakSplitAnimBeforeFold(topContainerSession, reason);
    }
    if (this.expandStartContainerSession !== null) {
      this.updateContainerSession(this.expandStartContainerSession, reason);
      this.expandStartContainerSession = null;
    } else {
      for (let containerSession of this.panelMgr.getTotalSessionListIncludeNotShowRecent()) {
        if (!containerSession?.isActive && (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
          reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START ||
          reason === SCBPropertyChangeReason.PAGE_ROTATION)) {
          continue;
        }
        this.updateContainerSession(containerSession, reason);
      }
      topActiveSession = this.panelMgr.getTotalSessionListIncludeNotShowRecent().getTopActiveSession();
    }
    if (topActiveSession?.isSplitView()) {
      let isGModeRotationReason = (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION &&
        SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus());
      this.panelViewModel.handleSplitScreen(topContainerSession, screenProperty, isGModeRotationReason);
      this.panelViewModel.updateSplitOnThreeFold(topContainerSession);
    }
    SCBSceneSessionManager.getInstance().requestPIPScenePanelRotation(screenProperty.screenId);
    if (DeviceHelper.isThreeFoldProduct() && this.foldAnimNum === 0) {
      this.panelViewModel.folderSnapshotSize =
        { width: px2vp(this.screenProperty.width), height: px2vp(this.screenProperty.height) };
    }
  }

  private updateContainerSession(containerSession: SCBSceneContainerSession, reason: SCBPropertyChangeReason): void {
    if (!containerSession) {
      return;
    }
    homeLog.showInfo(`updateContainerSession updateContainerSessionWithFold`);
    containerSession.updateContainerSessionWithFold(this.screenProperty, reason);
  }

  private setSnapColorAsBackground(): void {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    let snapShotStartTime: number = Date.now();
    this.backgroundBlurSession.setBgBlurColor('rgba(0, 0, 0, 0)');
  }

  private foldExpandWindowsAnimation(reason: SCBPropertyChangeReason): void {
    // windows fold expand animation
    let containerSession = this.containerSessionList.getTopActiveSession();
    if (!containerSession) {
      return;
    }
    if (!containerSession.isSplitView() && this.scenePanelState === ScenePanelState.FULLSCENE) {
      // window snapshot and get main color for setting background color
      let rotateCancelEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_CANCEL);
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateCancelEvent);
      this.setSnapColorAsBackground();
      this.panelMgr.enableBlurComponent('foldExpandWindowsAnimation');
      this.backgroundBlurSession.setBgBlurScale(1, 'foldExpandWindowsAnimation');
      if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
        performanceMonitor.begin('EXPAND_TO_FOLD_WINDOWS', performanceMonitor.ActionType.LAST_UP);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
        this.foldAnimation();
      } else if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
        performanceMonitor.begin('FOLD_TO_EXPAND_WINDOWS', performanceMonitor.ActionType.LAST_UP);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
        this.expandAnimation();
      }
    }
  }

  private foldAnimation(): void {
    this.viewParam.recentTransX = FoldAnimationConstants.FOLD_FACTOR * px2vp(this.screenProperty.width);
    this.viewParam.recentAlpha = 0;
    this.foldAnimNum++;
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
      onFinish: () => {
        this.foldAnimNum--;
        if (this.foldAnimNum == 0) {
          this.backgroundBlurSession.setBgBlurColor(SCBConstants.START_SCENE_BG_COLOR);
        }
        performanceMonitor.end('EXPAND_TO_FOLD_WINDOWS');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
      }
    }, () => {
      this.viewParam.recentTransX = 0;
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
    }, () => {
      this.viewParam.recentAlpha = 1;
    })
  }

  private expandAnimation(): void {
    this.viewParam.recentTransX = FoldAnimationConstants.EXPAND_FACTOR * px2vp(this.screenProperty.width);
    this.viewParam.recentAlpha = 0;
    this.foldAnimNum++;
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
      onFinish: () => {
        this.foldAnimNum--;
        if (this.foldAnimNum == 0) {
          this.backgroundBlurSession.setBgBlurColor(SCBConstants.START_SCENE_BG_COLOR);
        }
        performanceMonitor.end('FOLD_TO_EXPAND_WINDOWS');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
      }
    }, () => {
      this.viewParam.recentTransX = 0;
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
    }, () => {
      this.viewParam.recentAlpha = 1;
    })
  }

  private foldExpandStatusChangeForSplit(topContainerSession: SCBSceneContainerSession,
          screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    // animation in OneStepSplit mode
    if (topContainerSession.isOneStepSplit()) {
      let oneStepTrans: number = topContainerSession.dividerParam.calOneStepDefaultTrans(this.screenProperty);
      if (FoldExpandAnimUtils.isSupportProduct) {
        oneStepTrans = 0;
      }
      topContainerSession.dividerParam.doOneStepTranslate(oneStepTrans);
      this.initOneStepSplitFoldExpandAnim(topContainerSession, oneStepTrans);
      animateTo({
        curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES
      }, () => {
        topContainerSession?.dividerParam.doOneStepTranslate(-oneStepTrans);
      })
      animateTo({
        curve: FoldAnimationConstants.ALPHA_CURVES
      }, () => {
        topContainerSession?.dividerParam.setPrimaryOpacity(1);
      })
      return;
    }

    // animation in Split mode: default style is left to right translate. different translate orientation in different rotation
    this.initSplitViewFoldExpandAnim(reason);
    performanceMonitor.begin('FOLD_EXPAND_SPLIT_VIEW', performanceMonitor.ActionType.LAST_UP);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
      onFinish: () => {
        performanceMonitor.end('FOLD_EXPAND_SPLIT_VIEW');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
      }
    }, () => {
      this.viewParam.recentTransX = 0;
      this.viewParam.recentTransY = 0;
    })
  }

  private initSplitViewFoldExpandAnim(reason: SCBPropertyChangeReason): void {
    let rotation: number = 0;
    let translateFactor: number = 0;
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      rotation = screenSession?.scbScreenProperty.rotation;
      translateFactor = -1 * FoldAnimationConstants.EXPAND_FACTOR;
    }
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      rotation = this.screenProperty.rotation;
      translateFactor = -1 * FoldAnimationConstants.FOLD_FACTOR;
    }
    if (FoldExpandAnimUtils.isSupportProduct) {
      translateFactor = 0;
    }

    if (DeviceHelper.isThreeFoldProduct()) {
      translateFactor = -1 * TripleFoldExpandAnimUtils.getScenePanelAnimFactor(this.foldExpandStateChange);
    }

    if (rotation === RotationConstants.ROTATION_90) {
      this.viewParam.recentTransX = 0;
      this.viewParam.recentTransY = -px2vp(this.screenProperty.height) * translateFactor;
    } else if (rotation === RotationConstants.ROTATION_180) {
      this.viewParam.recentTransX = px2vp(this.screenProperty.width) * translateFactor;
      this.viewParam.recentTransY = 0;
    } else if (rotation === RotationConstants.ROTATION_270) {
      this.viewParam.recentTransX = 0;
      this.viewParam.recentTransY = px2vp(this.screenProperty.height) * translateFactor;
    } else {
      this.viewParam.recentTransX = -px2vp(this.screenProperty.width) * translateFactor;
      this.viewParam.recentTransY = 0;
    }
  }

  private initOneStepSplitFoldExpandAnim(containerSession: SCBSceneContainerSession, moveOffset: number): void {
    let screenW: number = px2vp(this.screenProperty.width);
    let screenH: number = px2vp(this.screenProperty.height);
    let dividerParam = containerSession.dividerParam;
    let isSupportFoldEffect: boolean = FoldExpandAnimUtils.isSupportProduct;
    dividerParam.setPrimaryOpacity(0);
    if (dividerParam.isUpDownSplit()) {
      // up_down split style of all type phone
      dividerParam.doOneStepTranslate(-moveOffset);
      dividerParam.doOneStepVerticalTranslate(isSupportFoldEffect ? 0 : -screenW);
    } else {
      // left_right split style of unfoldable phone, fold_status of foldable phone
      dividerParam.doOneStepTranslate(-moveOffset);
      dividerParam.doOneStepVerticalTranslate(isSupportFoldEffect ? 0 : -screenH);
    }
  }

  private checkIfNeedRecoverScreenProperty(lastNotifyRotation?: number): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showWarn('checkIfNeedRecoverScreenProperty screenSession is null');
      return;
    }
    if (lastNotifyRotation !== undefined && lastNotifyRotation !== screenSession.scbScreenProperty?.rotation) {
      homeLog.showInfo('checkIfNeedRecoverScreenProperty need recover screen property');
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(
        screenSession.scbScreenProperty,
        SCBRotateChangeReason.ROTATION_UPDATE_PROPERTY_ONLY);
    }
  }

  private sceneLandscapeStartCallback(propertyAfter: SCBScreenProperty) {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[sceneLandscapeStartCallback] screenProperty: ` + JSON.stringify(propertyAfter));
    this.screenProperty.copy(propertyAfter);
    this.currRotation = this.screenProperty.rotation;
    this.viewParam.onScreenChange(propertyAfter, SCBPropertyChangeReason.ROTATION);
  }

  private onMattesLockChange(): void {
    if (!DeviceHelper.isLargeInFoldProduct()) {
      homeLog.showInfo('not fold product, return;');
      return;
    }
    const mattesRotateStrategy = MattesRotateStrategy.getInstance();
    let containerSession = this.containerSessionList.getTopActiveSession();
    let curPersistentId = containerSession?.getPersistentId() || 0;
    let savedOrientation: [number, number] = mattesRotateStrategy.getContainerRequestedOrientation(curPersistentId);
    homeLog.showInfo(`MattesLock: SpecialScenePanel, ${curPersistentId} -> ${savedOrientation[0]}, ${savedOrientation[1]}.`);
    if (!this.mattesLock && mattesRotateStrategy.isNeedContainerOrientation(savedOrientation[0], savedOrientation[1])) {
      homeLog.showInfo('MattesLock: changed, release and start container requested orientation.');
      this.onContainerRequestedOrientationChange(savedOrientation[0], savedOrientation[1]);
    }
    if (!this.mattesLock && containerSession) {
      this.panelViewModel.exitSplitViewInFixedMultiWindowOrientation(containerSession.primarySession?.session.persistentId,
        containerSession.containerId);
    }
  }

  private onContainerRequestedOrientationChange = (persistentId: number, requestedOrientation: number,
    needAnimation: boolean = true, promiseId: number = 0): void => {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'persistentId: ' + persistentId + ' promiseId: ' + promiseId);
    let containerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(persistentId);
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] cannot find container session, ' +
                        ' persistentId: ' + persistentId);
      return;
    }
    let actualRequestedOrientation: SCBSceneOrientation = requestedOrientation;
    let fromUser: boolean = true;
    const isPageRotationRequest: boolean = !needAnimation;
    if (SCBSceneSessionManager.getInstance().isUserPageOrientation(actualRequestedOrientation)) {
      actualRequestedOrientation = SCBSceneSessionManager.getInstance().convertUserPageOrientationToUserOrientation(actualRequestedOrientation);
      fromUser = false;
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] UserPageOrientation: ' +
        requestedOrientation + ' targetUserOrientation: ' + actualRequestedOrientation);
    }
    if (containerSession.primarySession?.session.persistentId === persistentId) {
      containerSession.primarySession.sessionData.requestOrientation = actualRequestedOrientation;
    } else if (containerSession.secondarySession?.session.persistentId === persistentId) {
      containerSession.secondarySession.sessionData.requestOrientation = actualRequestedOrientation;
    } else {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] cannot find scene session, persistentId: ' +
        persistentId);
      return;
    }
    const lastRequestLandscape = containerSession.isRequestLandscape;
    let newRequestedOrientation = containerSession.getContainerRequestOrientation(persistentId, promiseId);
    WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] Convert requested orientation from: ' +
      containerSession.requestOrientation + ' to: ' + newRequestedOrientation);
    containerSession.sessionData.requestOrientation = newRequestedOrientation;
    containerSession.setPendingPageRotation(false, 'onContainerRequestedOrientationChange');
    const pendingPageRotationRequest: boolean = isPageRotationRequest ||
      containerSession.isOrientationUnrelatedToSensor(newRequestedOrientation);

    if (DeviceHelper.isLargeInFoldProduct()) {
      if (this.mattesLock) {
        WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[onContainerRequestedOrientationChange] cannot rotate ` +
          `when is in foldeffect animation.`);
        const mattesRotateStrategy = MattesRotateStrategy.getInstance();
        mattesRotateStrategy.writeContainerOrientation(persistentId, actualRequestedOrientation);
        containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_PENDING);
        return;
      }
    }
    let isScreenLocked = SCBSceneSessionManager.getInstance().isScreenLocked();
    if (containerSession.isOneStepSplit()) {
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[onContainerRequestedOrientationChange] cannot rotate
        when is in one step split state.`);
      containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_IGNORED);
      return;
    }
    if (containerSession.isFloat) {
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[onContainerRequestedOrientationChange] cannot rotate when in float state.`);
      containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_IGNORED);
      return;
    }
    if (this.sysSceneSession.isTouchable) {
      containerSession.setPendingPageRotation(pendingPageRotationRequest, 'onContainerRequestedOrientationChangeRecent');
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[onContainerRequestedOrientationChange] cannot rotate when in recent state.`);
      containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_IGNORED);
      return;
    }
    if (SCBWindowRotateController.getInstance().isLandscapeStartNotSync()) {
      containerSession.setPendingPageRotation(pendingPageRotationRequest, 'onContainerRequestedOrientationChangeLandscapeStart');
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[onContainerRequestedOrientationChange] cannot rotate ` +
        `when is in landscapeStart state.`);
      containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_PENDING);
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (this.isFixedRotation(screenSession)) {
      containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_IGNORED);
      return;
    }
    if (containerSession.isActive && !isScreenLocked) {
      if (!this.recentInnerState.isStartSceneAnimatingState()) {
        // 10 represents the max limit of consecutive setPreferredOrientation
        if (SCBWindowRotate.getInstance().getRotateAnimationCnt() > 10 ||
          this.rotationAnimCnt > 10 || this.screenRotationAnimCnt > 10) {
          WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] animCnt reaches the max limits, ' +
            'rotationAnimCnt: ' + this.rotationAnimCnt + ' screenRotationAnimCnt: ' + this.screenRotationAnimCnt);
          containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_IGNORED);
          return;
        }
        containerSession.orientationExecutionResult = OrientationExecutionResult.ORIENTATION_APPLIED;
        this.panelViewModel.startSceneWithRotationIfNeed(containerSession, needAnimation, false, fromUser,
          isPageRotationRequest);
        containerSession.setOrientationExecutionResultMap(promiseId, true, containerSession.orientationExecutionResult);
      } else {
        containerSession.setPendingPageRotation(pendingPageRotationRequest, 'onContainerRequestedOrientationChangeStartAnimating');
      }
    } else {
      containerSession.setPendingPageRotation(pendingPageRotationRequest, 'onContainerRequestedOrientationChangeInactive');
      // no need to rotation if no active session
      containerSession.setOrientationExecutionResultMap(promiseId, true, OrientationExecutionResult.ORIENTATION_IGNORED);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] no animation name: ' +
      containerSession.primarySession?.sceneInfo.bundleName +
        ' isActive: ' + containerSession.isActive + ' from: ' + containerSession.requestOrientation + ' to: ' +
        newRequestedOrientation);
    }
  }

  private isFixedRotation(screenSession: SCBScreenSession): boolean {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      if (SCBRotationConfig.getInstance().getDeviceFixedRotation(screenSession) !== -1) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[onContainerRequestedOrientationChange] cannot rotate when verde fold state.');
        return true;
      }
    }
    return false;
  }

  private onBindingPortraitAnd0DegreeChange = (persistentId: number, isBindingPortraitAnd0Degree: boolean): void => {
    let containerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(persistentId);
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, ' cannot find container Session with persistentId: ' + persistentId);
      return;
    }
    // 进入强制竖屏绑定0度仅支持竖屏策略，退出不受此限制
    if (containerSession.primarySession?.sessionData.requestOrientation !== SCBSceneOrientation.VERTICAL &&
      isBindingPortraitAnd0Degree) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange only supports VERTICAL orientation!' +
        'requestOrientation is :' + containerSession.primarySession?.sessionData.requestOrientation);
      return;
    }

    let lastContainerRequestOrientation = containerSession.requestOrientation;
    // 设置强制竖屏绑定0度标志位,由调用方主动控制是否要强制进入兼容模式
    if (SCBSceneSessionManager.getInstance().isSupportCompatibilityMode() && containerSession.primarySession) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange Convert requested orientation from  : ' +
        lastContainerRequestOrientation + ' to: ' + containerSession.requestOrientation);

      // 如果强制竖屏绑定0度标志位为true，则强制将兼容模式标志位置为true
      if (isBindingPortraitAnd0Degree) {
        // 模糊控件上树
        this.panelSession.isBgBlurEnable = true;
        this.panelViewModel.isEnableBlur = true;
      }
    }

    if (!this.isNeedEnterCompatibleMode(containerSession)) {
      return;
    }

    let isScreenLocked = SCBSceneSessionManager.getInstance().isScreenLocked();
    // no need to rotation if no active session
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange no animation name: ' +
    containerSession.primarySession?.sceneInfo.bundleName + ' isActive: ' + containerSession.isActive + ' from: ' +
      lastContainerRequestOrientation + ' to: ' + containerSession.requestOrientation);
  }

  private isNeedEnterCompatibleMode(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, ' containerSession is null!');
      return false;
    }
    if (containerSession.isOneStepSplit()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange cannot rotate' +
        'when is in one step split state.');
      return false;
    }
    if (containerSession.isFloat) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange cannot rotate when in float state.');
      return false;
    }
    if (this.sysSceneSession.isTouchable) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange cannot rotate when in recent state.');
      return false;
    }
    if (containerSession?.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onBindingPortraitAnd0DegreeChange cannot rotate when not in full screen.');
      return false;
    }
    return true;
  }

  private initDefaultSplit(containerSession: SCBSceneContainerSession | null): void {
    if (!containerSession) {
      homeLog.showWarn('initDefaultSplit fail with no containerSession');
      return;
    }

    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showWarn('initDefaultSplit fail with no screenSession');
      return;
    }
    let dividerParam = containerSession.dividerParam;
    dividerParam.setIsVertical(SCBRotateUtils.isVertical(screenSession.scbScreenProperty.rotation));
    dividerParam.setSplitStyle(dividerParam.isUpDownSplit() ? SplitStyle.UP_AND_DOWN_POS : SplitStyle.LEFT_AND_RIGHT_POS)
    dividerParam.updateDividerParamWithRatio(containerSession.screenProperty);
  }

  private resetSplitViewWithFold = (persistentId?: number, containerId?: number): void => {
    winLog.showInfo(`resetSplitViewWithFold with persistentId:${persistentId} containerId:${containerId}`);
    let currContainerSession = this.panelViewModel.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (currContainerSession === null || !currContainerSession.isActive ||
      !currContainerSession.isSplit || !currContainerSession.isSplitView()) {
      winLog.showError(`resetSplitViewWithFold cannot reset with containerId:${containerId}`);
      return;
    }
    this.panelViewModel.resetWindowEffect(currContainerSession);
  }

  private resetFloatViewWithFold = (floatContainer: SCBSceneContainerSession): void => {
    winLog.showInfo(`resetFloatViewWithFold with persistentId:${floatContainer.primarySession?.sceneInfo.persistentId}`+
      ` containerId:${floatContainer.containerId}`);
    if (!floatContainer || !floatContainer.isActive || !floatContainer.isFloat) {
      winLog.showError(`resetFloatViewWithFold fail, containerId:${floatContainer?.containerId}`);
      return;
    }
  }

  private enterFloatFromFull(persistentId: number, screenProperty: SCBScreenProperty) {
    winLog.showInfo(`[SCBFloat] enterFloatFromFull`);
    let container = this.containerSessionList.getTopActiveSession();
    if (!container || !container.primarySession) {
      winLog.showWarn(`[SCBFloat] no primary session`);
      return;
    }
  }

  private showDesktopIfNeed(showReason: string) {
    if (!ViewManagerPolicy.isViewShowing(ViewType.DESKTOP)) {
      winLog.showInfo(`call showDesktop,reason:${showReason}`);
      ViewManagerPolicy.showView(ViewType.DESKTOP);
    }
  }

  private showWallpaperIfNeed(showReason: string) {
    if (!ViewManagerPolicy.isViewShowing(ViewType.WALLPAPER)) {
      winLog.showInfo(`call showWallpaper,reason:${showReason}`);
      ViewManagerPolicy.showView(ViewType.WALLPAPER);
    }
  }

  private enterSplitFromFullForPad() {
    winLog.showInfo('enterSplitFromFullForPad');
    this.showDesktopIfNeed('enterSplitByTitleBarMenu');
    this.onEnterOneStepSplitScene(true);
  }

  private enterSwitchAnimationFinishCallback = (...args: AnimateExArgsType[]) => {
    let toContainerSession = args[1] as SCBSceneContainerSession | null;
    if (toContainerSession) {
      if (toContainerSession.isActive) {
        this.panelViewModel.startSceneWithRotationIfNeed(toContainerSession, true, true);
      } else {
        this.panelViewModel.startSceneWithRotationIfNeed(toContainerSession);
      }
    }
    performanceMonitor.end('GESTURE_ENTER_TO_SWITCH');
    TraceUtil.endTrace(DomainName.RECENT, HiSysEventUtil.GESTURE_ENTER_TO_SWITCH, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  private isShowEmptyRecentView(offsetY: number): boolean {
    let listLen = this.recentEnter.getSessionListLength();
    if (listLen === 0) {
      this.panelViewModel.handleEmptyRecentView();
      this.recentEnter.updateScaleDesktop(offsetY);
      return true;
    }
    return false;
  }

  private updateFollowingViewParams(isFromApp: boolean): void {
    if (isFromApp) {
      let nowFinalRecentW = this.recentEnter.getFinalRecentW();
      this.viewParam.recentW = vp2px(nowFinalRecentW);
    } else {
      let screenW = px2vp(this.screenProperty.width);
      let recentScale = RecentLayoutManager.getScale(this.screenProperty);
      this.viewParam.recentPadding = (1 - recentScale) / 2 * screenW;
      let containerListLen = this.panelMgr.getSceneContainerSessionListForView().length;
      let floatingListLen = this.panelMgr.getFloatingSessionListForView().length;
      let recentMargin = RecentLayoutManager.getWidthSpace();
      let recentW = this.viewParam.recentPadding * 2 + containerListLen * recentScale * screenW +
        recentMargin * (containerListLen - 1);
      // 设置scroll长度
      if (floatingListLen !== 0) {
        let floatRecentW = this.viewParam.recentPadding * 2 + floatingListLen * recentScale * screenW +
          recentMargin * (floatingListLen - 1);
        this.viewParam.recentW = vp2px(recentW + floatRecentW);
      } else {
        this.viewParam.recentW = vp2px(recentW);
      }
    }
  }

  private updateRecentView(offsetX: number, offsetY: number): void {
    this.updateRecentParmBeforeAnimate(offsetX, offsetY);
    this.recentEnter.followingAnimateToRecentFromApp(offsetX);
  }

  private prepareToFarAwayFollowingUpdate(gestureEvent: GestureEvent, prepareFarAwayPercent: number): void {
    this.updateRecentParmBeforeAnimate(gestureEvent.offsetX, gestureEvent.offsetY);
    this.recentEnter.prepareToFarAwayFollowingAnimate(gestureEvent, prepareFarAwayPercent);
  }

  private updateRecentParmBeforeAnimate(offsetX: number, offsetY: number) {
    let listLen = this.panelMgr.getSceneContainerSessionListForView().length;
    if (listLen === 0) {
      recentLog.showWarn('Current container session list is 0.');
      return;
    }
    this.recentEnter.updateRecentParmForFollowing(offsetX, offsetY, true);
    if (this.recentEnter.getCurrentIdx() === -1) {
      this.panelViewModel.updateScenePanelState(ScenePanelState.RECENT);
      return;
    }
    if (this.scenePanelState !== ScenePanelState.RECENT) {
      recentLog.showDebug('updateRecentView param change');
      this.updateFollowingViewParams(true);
      this.recentEnter.setShowRecentIfNeed();
      if (this.scenePanelState === ScenePanelState.QUICK_SWITCH) {
        this.recentEnter.initFromQuickSwitch();
      } else {
        ContainerBuilder.resetAllContainerPreBuildStage(this.panelMgr.getSceneContainerSessionListForView());
        this.recentEnter.init();
        this.recentInnerState.onEnterFollowing();
        this.recentEnter.interruptOtherAnimations(true);
        this.recentEnter.startForegroundBlurAnimation(true);
      }
    }
    this.panelViewModel.updateScenePanelState(ScenePanelState.RECENT);
  }

  private initRecentLayoutParam() {
    this.isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
  }

  private exitFullSceneOnFloatToFull(): void {
    let backgroundContainer = this.containerSessionList.getTopActiveSession();
    if (backgroundContainer) {
      backgroundContainer.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
        'exitFullSceneOnFloatToFull');
      backgroundContainer.requestBackgroundWithTransitionOut(false);
      animateTo({
        curve: curves.springMotion(0.45, 1),
        finishCallbackType: FinishCallbackType.LOGICALLY,
        onFinish: () => {
          if (backgroundContainer) {
            backgroundContainer.needRenderBlurRadius.reset();
            backgroundContainer.isDisappearing = false;
          }
        }
      }, () => {
        backgroundContainer?.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'exitFullSceneOnFloatToFull')
        backgroundContainer?.needRenderScale.setScaleXWithDfx(0.25, TAG, 'exitFullSceneOnFloatToFull');
        backgroundContainer?.needRenderScale.setScaleYWithDfx(0.25, TAG, 'exitFullSceneOnFloatToFull');
        if (!SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.FLOAT_MAXIMIZE_BLUR_EFFECT_DISABLE)) {
          backgroundContainer?.needRenderBlurRadius.setBlurRadiusWithDfx(150, TAG, 'exitFullSceneOnFloatToFull');
        }
      })
    }
  }

  private updateCurRectForFloat2Full(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      homeLog.showInfo(`updateCurRectForFloat2Full containerSession is empty`);
      return;
    }
  }

  private floatingSceneToFull = (scbSceneSession: SCBSceneSession, fromDrag: boolean): void => {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.FLOAT_WINDOW_TO_FULL, StyleConstants.DEFAULT_1);
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    this.exitFullSceneOnFloatToFull();
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'floatingSceneToFull');
    scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    homeLog.showInfo(`floatingSceneToFull persistentId: ${scbSceneSession.session.persistentId}`);
    let containerSession = this.floatingSessionList.findByPersistentId(scbSceneSession.sceneInfo.persistentId);
    if (containerSession === null) {
      homeLog.showInfo('floatingSceneToFull with null containerSession');
      return;
    }
    containerSession.isFloat = false;
    this.panelMgr.removeFloatContainerSession(containerSession);
    if (ScreenLockApi.getLock()) {
      SCBSceneSessionManager.getInstance().transferToBackgroundWhenLocked(containerSession);
      this.unLockScale = UnLockConstants.MAX_SCENE_SCALE;
    } else {
      containerSession.requestActivation(false);
    }
    containerSession.floatingParam.isShowTitleBar = false;
    this.panelMgr.addSceneContainerSession(containerSession);
    let displayOrientation = containerSession.sessionData.requestOrientation;
    if (fromDrag) {
      if (this.screenProperty) {
        containerSession.screenProperty.copy(this.screenProperty);
        let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
        containerSession.currentRotation = screenSession?.scbScreenProperty.rotation;
      }
      this.appFloating.resizeSceneContainerOnDrag(containerSession);
      this.updateCurRectForFloat2Full(containerSession);
      let isRotationLock =
        SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.screenProperty.screenId);
      if (isRotationLock) {
        this.appFloating.floatingDragToFullAnimation(containerSession,
          () => this.panelViewModel.startSceneWithRotationIfNeed(containerSession, true));
      } else {
        this.appFloating.floatingDragToFullAnimation(containerSession);
        this.panelViewModel.startSceneWithRotationIfNeed(containerSession);
      }
    } else {
      this.appFloating.resizeSceneContainer(containerSession);
      this.updateCurRectForFloat2Full(containerSession);
      this.appFloating.floatingSceneToFullAnimation(containerSession, this.screenProperty,
        () => this.panelViewModel.startSceneWithRotationIfNeed(containerSession, true));
    }
    if (this.scenePanelState === ScenePanelState.RECENT) {
      this.panelViewModel.initView();
      this.panelViewModel.showStatusBar(true);
      this.recentInnerState.onInit();
    }
    containerSession.sessionData.requestOrientation = displayOrientation;
    containerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
    this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE, false);
  }

  addShowWhenLockedSceneContainerSessionCallback = (list_: SCBSceneContainerSessionArray, isFromUnlock: boolean = false): void => {
    let panelActiveSessionCount = this.containerSessionList.getActiveSceneContainerSessionCount();
    let topActiveSession = this.containerSessionList.getTopActiveSession();
    homeLog.showInfo('addShowWhenLockedSceneContainerSession top active sessions count: ' + panelActiveSessionCount +
      'and top active session id: ' + topActiveSession?.getPersistentId());
    for (let item of list_) {
      item.primarySession?.setShowAboveKeyguard(false);
      if (panelActiveSessionCount !== 0) {
        item.requestBackground();
      }
    }

    this.panelMgr.addSceneContainerSessionByList(list_);
    if (panelActiveSessionCount === 0 && this.containerSessionList.getActiveSceneContainerSessionCount() > 0) {
      this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE);
    }
    // when screen unlocked, decide screen rotation by top active session
    if (isFromUnlock) {
      homeLog.showInfo(`onlock Rotation`);
      let activeSession = this.containerSessionList.getTopActiveSession();
      if (activeSession && activeSession.getContainerWindowMode() === SCBSceneMode.FULLSCREEN) {
        activeSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'resetSceneContainerRadiusWhenUnLock');
      }
      activeSession?.notifyInteractiveStateChange(true);
      this.viewParam.onScreenChange(this.screenProperty, SCBPropertyChangeReason.ROTATION);
    }
    homeLog.showInfo('addShowWhenLockedSceneContainerSession recentParam: ' + JSON.stringify(this.viewParam));
  }

  removeShowWhenLockedSceneContainerSessionCallback = (): SCBSceneContainerSessionArray => {
    homeLog.showInfo('removeShowWhenLockedSceneContainerSession in.');
    let ret = new SCBSceneContainerSessionArray();
    if (this.panelViewModel.isRecentState()) {
      homeLog.showInfo('no need to remove while panel in recent state.');
      return ret;
    }
    let panelActiveSessionCount = this.containerSessionList.getActiveSceneContainerSessionCount();
    let panelFloatingActiveSessionCount = this.floatingSessionList.getActiveSceneContainerSessionCount();
    let sessionList: SCBSceneContainerSession[] = [...this.containerSessionList, ...this.floatingSessionList];
    for (let item of sessionList) {
      if (item.isShowWhenLocked() && !item.isTerminating && !item.pendingRemove) {
        item.init();
        item.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'removeFromScenePanel', item.getName());
        item.notifyForegroundInteractiveStatus(true);
        if (item.isFloat) {
          this.panelMgr.removeFloatContainerSession(item);
          homeLog.showInfo(`will remove FloatContainerSession id: ${item.getPersistentId()}.`);
        } else {
          this.panelMgr.removeSceneContainerSession(item);
          homeLog.showInfo(`will remove ContainerSession id: ${item.getPersistentId()}.`);
        }
        let callerId: number = item.primarySession?.sceneInfo.callerPersistentId ?? 0;
        const callerContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(callerId);
        item.primarySession!.sceneInfo.callerPersistentId = 0;
        if (callerContainerSession != null && callerId != item.primarySession!.session.persistentId) {
          let callerSession = this.panelViewModel.getSceneSessionByPersistentId(callerId);
          if (callerSession) {
            callerSession.sceneInfo.toPersistentId = 0;
          }
        }
        ret.push(item);
        homeLog.showInfo(`remove session of ${item.getPersistentId()} removed.`);
      }
    }
    if (ret.length > 0) {
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
    homeLog.showInfo('after remove SceneContainerSession, activeSessionCount changed from ' + panelActiveSessionCount +
      ' to ' + this.containerSessionList.getActiveSceneContainerSessionCount());
    homeLog.showInfo('after remove SceneFloatingContainerSession, activeSessionCount changed from ' +
      panelFloatingActiveSessionCount + ' to ' + this.floatingSessionList.getActiveSceneContainerSessionCount());
    if ((panelActiveSessionCount > 0 || panelFloatingActiveSessionCount > 0) &&
      this.containerSessionList.getActiveSceneContainerSessionCount() === 0 &&
      this.floatingSessionList.getActiveSceneContainerSessionCount() === 0) {
      this.panelViewModel.updateScenePanelState(ScenePanelState.HOME);
    }
    return ret;
  }

  private sendBadgeEvent(sceneInfo: SCBSceneInfo | CompanionIconInfo | undefined, isAppStart: boolean): void {
    localEventManager.sendLocalEventSticky(
      `${CommonConstants.EVENTHUB_APP_LAUNCH_STATE}${sceneInfo?.bundleName}${sceneInfo?.abilityName}${sceneInfo?.moduleName}` +
        `${sceneInfo?.appIndex ?? 0}`, isAppStart)
  }

  private onFloatTransition = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    homeLog.showInfo('[SCBMain]onFloatTransition with sceneInfo:{persistentId: %{public}d, bundleName:%{public}s, ' +
      'moduleName:%{public}s, abilityName:%{public}s} scenePanelState %{public}d',
      sceneInfo.persistentId, sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName, this.scenePanelState);
  }

  private isPhoneCallSceneCallback = (sceneInfo: SCBSceneInfo): boolean => {
    return SCBPhoneSceneUtils.isPhoneCallScene(sceneInfo);
  }

  private onStartSceneFromNotification = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult => {
    homeLog.showInfo('onStartSceneFromNotification, start window, ' + sceneInfo?.toJsonString());
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(
        sceneInfo, StartInterceptions.FROM_NOTIFICATION, this.panelViewModel.screenId, this.panelViewModel.panelId)) {
      return CommonResult.FAIL;
    }
    let sceneSession = this.panelViewModel.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      homeLog.showError('Failed to request scene session!');
      return CommonResult.FAIL;
    }
    let sceneContainerSession =
      this.panelViewModel.getSceneContainerSessionWithPersistentId(sceneSession.sceneInfo.persistentId);
    SCBPiPManager.getInstance().resetContainerWithPipStartSceneIfNeed(sceneContainerSession);
    let activeSceneContainerSession = this.containerSessionList.getTopActiveSession();

    if (!sceneSession.isActive) {
      homeLog.showInfo(`onStartSceneFromNotification sceneSession not Active, scenePanelState ${this.scenePanelState}` +
        ` windowMode ${sceneInfo.windowMode}`);
      if (this.scenePanelState === ScenePanelState.SPLIT) {
        let activeSceneSession = this.containerSessionList?.getTopActiveSession();
        SCBSceneSessionManager.getInstance().minimize(activeSceneSession?.primarySession?.sceneInfo.screenId,
          activeSceneSession?.primarySession?.sceneInfo.persistentId, activeSceneSession?.containerId);
      }
      if (sceneContainerSession === null) {
        sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
        SCBScenePanelManager.getInstance().addFloatContainerSession(sceneContainerSession);
      } else if (sceneContainerSession.isSplit) {
        sceneContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(sceneSession.sceneInfo.persistentId);
        if (sceneContainerSession === null) {
          homeLog.showWarn('onStartSceneFromNotification, exitSplitView no sceneContainerSession');
          return CommonResult.FAIL;
        }
        SCBScenePanelManager.getInstance().removeSceneContainerSession(sceneContainerSession);
        SCBScenePanelManager.getInstance().addFloatContainerSession(sceneContainerSession);
      }
      else {
        SCBScenePanelManager.getInstance().removeSceneContainerSession(sceneContainerSession);
        SCBScenePanelManager.getInstance().addFloatContainerSession(sceneContainerSession);
      }
      if (sceneContainerSession.primarySession !== sceneSession) {
        homeLog.showWarn('onStartSceneFromNotification, primarySession not sceneSession');
        return CommonResult.FAIL;
      }
      sceneContainerSession.primarySession.sceneInfo.want = sceneInfo.want;
      if (sceneContainerSession.needRenderRotate.angle !== this.screenProperty.rotation) {
        sceneContainerSession?.updateContainerSessionWithRotation(this.screenProperty,
          SCBContainerRotationReason.SCREEN_ROTATION);
      }
      this.panelViewModel.exitRecentIfNeeded(sceneContainerSession);
      this.panelViewModel.containerSession = sceneContainerSession;
      sceneContainerSession.requestActivation(sceneContainerSession.mainSession.isNewWant);
      sceneContainerSession.mainSession.sessionData.isNewWant = true;
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'onStartSceneFromNotification');
      sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'onStartSceneFromNotification');
      let parameters = sceneContainerSession?.primarySession?.sceneInfo.want?.parameters;
      let floatingDisplayMode = parameters?.['floatingDisplayMode'];
      if (floatingDisplayMode === FloatingDisplayMode.CLICK_WITH_ANIMATION) {
        sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'onStartSceneFromNotification');
      } else if (floatingDisplayMode !== FloatingDisplayMode.CLICK_WITHOUT_ANIMATION) {
        sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'onStartSceneFromNotification');
        SCBSceneSessionManager.getInstance().notifyNtfFloatingWindowCallback();
      } else {
      }
      this.panelMgr.raiseSceneToTop(sceneContainerSession);
      QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene from notification');
    }
    return CommonResult.SUCCESS;
  }

  private isSceneContainerSessionRunning(sceneSession: SCBSceneSession): boolean {
    for (let containerSession of this.containerSessionList) {
      if (containerSession.primarySession?.sceneInfo.persistentId === sceneSession.sceneInfo.persistentId ||
        containerSession.secondarySession?.sceneInfo.persistentId === sceneSession.sceneInfo.persistentId) {
        return true;
      }
    }
    for (let floatingSession of this.floatingSessionList) {
      if (floatingSession.primarySession?.sceneInfo.persistentId === sceneSession.sceneInfo.persistentId) {
        return true;
      }
    }
    return false;
  }

  animationFinishedCallback = (visible: boolean): void => {
    if (this.panelViewModel.containerSession) {
      this.panelViewModel.containerSession.needRenderVisibility.setVisibilityWithDfx(visible, TAG, 'animationFinishedCallback');
      this.panelViewModel.containerSession.floatingParam.isShowTitleBar = visible;
      SCBSceneSessionManager.getInstance().notifyNtfFloatingWindowCallback();
    }
  }

  private resetFloatingAnimateParams(container: SCBSceneContainerSession): void {
    container.floatingParam.titleBarOpacity = 1;
    container.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'resetFloatingAnimateParams');
    container.needRenderScale.setScaleXWithDfx(1, TAG, 'resetFloatingAnimateParams');
    container.needRenderScale.setScaleYWithDfx(1, TAG, 'resetFloatingAnimateParams');
    container.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'resetFloatingAnimateParams');
    container.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'resetFloatingAnimateParams');
  }

  private sceneContainerZoomInAA(sceneContainerSession: SCBSceneContainerSession): void {
    homeLog.showInfo('[SCBMain]sceneContainerZoomInAA');
    sceneContainerSession.init();
    this.panelViewModel.startSceneWithRotationIfNeed(sceneContainerSession);
    sceneContainerSession.startOther();
    sceneContainerSession.addTransitionCount();
    this.panelMgr.addSceneContainerSession(sceneContainerSession);
    this.panelMgr.raiseSceneToTop(sceneContainerSession);
    let animationNum = sceneContainerSession.getTransitionCount();
    // animateTo({
    //   duration: 0,
    //   curve: Curve.Linear,
    //   onFinish: () => {
    sceneContainerSession.onTransitionInactive();
    this.panelMgr.onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerZoomInAA');
    if (animationNum == sceneContainerSession.getTransitionCount()) {
      if (CommonUtils.equals(sceneContainerSession?.needRenderScale.scaleX, 1.0)) {
        sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
          TAG, 'sceneContainerZoomInAA', sceneContainerSession.getName());
      }
      sceneContainerSession.clearTransitionCount();
      AnimateToScheduleUtils.raiseAppStartToCPUPriority(1);
    }
    //   },
    // }, () => {
    //   sceneContainerSession.onTransitionInactive();
    //   this.panelMgr.onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerZoomInAA');
    // })
    // 模糊
    this.panelMgr.disableBlurComponent('sceneContainerZoomInAA');
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'sceneContainerZoomInAA',
      sceneContainerSession.getName());
    IntelligentCache.getInstance().doAnimOpen();
    // animateTo({
    //   duration: 350,
    //   curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    // }, () => {
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'sceneContainerZoomInAA',
      sceneContainerSession.getName());
    // })
  }

  private onStartSceneFromVirtual = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    homeLog.showInfo('[SCBMain]onStartSceneFromVirtual by sceneInfo:{persistentId: %{public}d, bundleName:%{public}s, ' +
      'moduleName:%{public}s, abilityName:%{public}s}.',
      sceneInfo.persistentId, sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);

    let sceneSession = this.panelViewModel.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      homeLog.showError('[SCBMain]onStartSceneFromVirtual Failed to request scene session!');
      return;
    }
    let sceneContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(sceneSession.session?.persistentId);

    homeLog.showInfo(`[SCBMain]onStartSceneFromVirtual isNewWant ${sceneSession.isNewWant}. ` +
      `${TraceUtil.CORE_METHOD_START_APP}:${sceneInfo.bundleName}`);
    if (sceneContainerSession !== null) {
      homeLog.showWarn('[SCBMain]onStartSceneFromVirtual sceneContainerSession is not null');
      return;
    }

    sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
    let activeSceneContainerSession = this.containerSessionList.getTopActiveSession();
    if (activeSceneContainerSession) {
      homeLog.showInfo(`[SCBMain]onStartSceneFromVirtual have activeSceneContainerSession`);
      let containerSessionListLength: number = this.containerSessionList.length;
      this.panelMgr.addSceneContainerSessionByIndex(containerSessionListLength - 1, sceneContainerSession);
    } else {
      homeLog.showInfo(`[SCBMain]onStartSceneFromVirtual not have activeSceneContainerSession`);
      this.panelMgr.addSceneContainerSession(sceneContainerSession);
    }
    homeLog.showInfo(`[SCBMain]onStartSceneFromVirtual add new session: ${sceneContainerSession.containerId}`);
  }

  private onSceneHiddenStartFromOther = (sceneInfo: SCBSceneInfo): CommonResult => {
    return this.onSceneHiddenModeVisChange(sceneInfo, false);
  };

  private onSceneHiddenStartTransition = (toInfo: SCBSceneInfo): void => {
    this.onSceneHiddenModeVisChange(toInfo, false);
  };

  private sceneForegroundToHiddenCallback = (sceneInfo: SCBSceneInfo): void => {
    this.sceneForegroundToHidden(sceneInfo);
  };

  private sceneForegroundToHidden = (sceneInfo: SCBSceneInfo): void => {
    let containerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(sceneInfo.persistentId);
    if (containerSession === null) {
      homeLog.showError(`Failed to get containerSession with persistentId:${sceneInfo.persistentId}`);
      return;
    }
    if (containerSession.mainSession?.isPcAppInPad ||
      containerSession.primarySession?.isPcAppInPad ||
      containerSession.secondarySession?.isPcAppInPad){
      SCBSceneSessionManager.getInstance().minimize(sceneInfo.screenId, sceneInfo.persistentId);
    }
  };

  private onSceneHiddenModeVisChange(toInfo: SCBSceneInfo, visible?: boolean): CommonResult {
    let toSceneSession = this.panelViewModel.requestSceneSession(toInfo);
    if (toSceneSession == null) {
      recentLog.showError('[SCBMain]Failed to get toSceneSession');
      return CommonResult.FAIL;
    }
    let toContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);

    let isFirstCall = false;
    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      isFirstCall = true;
    }

    recentLog.showInfo(`onSceneHiddenModeVisChange isFirstCall:${isFirstCall} visible:${visible}`);
    if (isFirstCall && !visible) {
      this.panelMgr.addNotShowRecentSession(toContainerSession);
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
      SCBSceneSessionManager.getInstance().requestStartUIAbilityBySCB(toSceneSession.session);
      return CommonResult.SUCCESS;
    } else {
      recentLog.showError('onSceneHiddenModeVisChange error condition');
      return CommonResult.FAIL;
    }
  }

  private sceneHiddenToForegroundFromOtherCallback = (sceneInfo: SCBSceneInfo): void => {
    this.sceneHiddenToForegroundFromOther(sceneInfo);
  };

  private sceneHiddenToForegroundFromOther(toInfo: SCBSceneInfo): void {
    let toSceneSession = this.panelViewModel.requestSceneSession(toInfo);
    if (toSceneSession == null) {
      homeLog.showError('[SCBMain]sceneHiddenToForegroundFromOther Failed to get toSceneSession');
      return;
    }
    let toContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(toInfo?.persistentId);
    if (toContainerSession === null) {
      homeLog.showError(`Failed to get containerSession with persistentId:${toInfo.persistentId}`);
      return;
    }
    if (this.scenePanelState === ScenePanelState.RECENT) {
      this.panelViewModel.exitRecent(true);
    }
    this.onSceneHiddenModeShowAgain(toContainerSession, toSceneSession);
    SCBSceneSessionManager.getInstance().onRestoreMainWindow(toInfo);
  }

  private onSceneHiddenModeShowAgain(toContainerSession: SCBSceneContainerSession,
    toSceneSession: SCBSceneSession): void {
    this.panelMgr.removeNotShowRecentSession(toContainerSession);
    this.panelMgr.addSceneContainerSession(toContainerSession);
  }

  private onSceneBackTransition = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => { // full to full
    homeLog.showInfo('[SCBMain]onSceneTransition with toSceneInfo:' + toInfo?.toJsonString() + ' fromInfo:' + fromInfo?.toJsonString());
    if (!fromInfo) {
      homeLog.showError('onSceneBackTransition fromInfo is null');
      return;
    }
    let toSceneSession = this.panelViewModel.requestSceneSession(toInfo);
    let fromSceneSession = this.panelViewModel.getSceneSessionByPersistentId(fromInfo.persistentId);
    if (toSceneSession === null || fromSceneSession === null) {
      homeLog.showError('Failed to get toSceneSession: ' + toInfo?.toJsonString() + ' or fromSceneSession: ' +
        fromInfo?.toJsonString());
      return;
    }
    let fromContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId);
    let toContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    if (fromContainerSession === null || toContainerSession === null) {
      homeLog.showError('Failed to get fromContainerSession: ' + toInfo?.toJsonString() + ' or toContainerSession: ' +
        fromInfo?.toJsonString());
      return;
    }
    toContainerSession.requestActivation(false);
    fromContainerSession.requestDestruction(false);
    // need add rotation check
    this.panelMgr.raiseSceneToTop(toContainerSession);
    this.panelViewModel.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE)
  }

  private onMinimizeSceneBackToCaller = (persistentId?: number, containerId?: number): void => {
    let opts: SCBMinimizeSceneOpts = {
        needRemoveSession: false,
        shouldBackToCaller: true
    }
    this.panelViewModel.onMinimizeScene(persistentId, containerId, opts);
  }

  private onMaximizeScene = (persistentId?: number, containerId?: number): void => {
    homeLog.showInfo(`[SCBMain]onMaximizeScene with persistentId:${persistentId} containerId:${containerId} ` +
      `isSupportMaximizeScene:${this.isSupportMaximizeScene}`);
    if (!this.isSupportMaximizeScene) {
      homeLog.showError('cannot maximize scene, not isSupportMaximizeScene');
      return;
    }
    let currContainerSession = this.panelViewModel.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (currContainerSession === null) {
      homeLog.showError(`[SCBMain]onMaximizeScene cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!currContainerSession.isActive) {
      homeLog.showWarn(`[SCBMain]onMaximizeScene container already background: ${currContainerSession.getName()}`);
      return;
    }
    // to avoid App call SetWindowLayoutFullScreen when pair split
    if (currContainerSession.isSplit || currContainerSession.isFloat) {
      homeLog.showWarn(`[SCBMain]onMaximizeScene containerSession is split or float, do not maximizeScene: ` +
        `${currContainerSession.getName()}`);
      return;
    }
    for (let container of this.containerSessionList) {
      if (container.containerId !== currContainerSession.containerId) {
        let windowMode = container.getContainerWindowMode();
        if (windowMode === SCBSceneMode.FULLSCREEN) {
          container.requestBackground();
        }
      }
    }
    currContainerSession.init();

    this.panelViewModel.resetWindowEffect(currContainerSession);
  }

  private onMaximizeSplitScene = (persistentId?: number, containerId?: number): void => {
    winLog.showInfo(`onMaximizeSplitScene persistentId:${persistentId} containerId:${containerId}`);
    let currContainerSession = this.panelViewModel.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (currContainerSession === null) {
      homeLog.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!currContainerSession.isActive) {
      homeLog.showWarn(`containerSession is already background:${persistentId}`);
      return;
    }
    currContainerSession.splitParam.oneStepBreakFlag = false;
    this.panelViewModel.maximizeSplitScene(persistentId, currContainerSession);
    this.panelViewModel.resetWindowEffect(currContainerSession);
  }

  private onSessionException = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void => {
    // recover transparent background when session exception
    this.isShowBlackBackground = false;
    this.panelViewModel.onTerminateScene(persistentId, containerId, needRemoveSession, true,
      this.panelViewModel.needStartCallerFromException(persistentId), extraInfo);
  }

  private doSceneRaiseToTop = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
                               shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onSceneRaiseToTop(persistentId, containerId, extraInfo ? extraInfo.raiseReason : undefined);
  }

  private onSceneRaiseToTop = (persistentId?: number, containerId?: number, reason?: SCBWindowRaiseReason): void => {
    if (!persistentId) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onSceneRaiseToTop return persistentId ${persistentId}`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onRaiseSceneToTop with persistentId:${persistentId}`);
    let containerSession = this.panelViewModel.getContainerSessionByPersistentIdOrContainerId(persistentId);
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, `cannot find session with persistentId:${persistentId}`);
      return;
    }
    if (reason === SCBWindowRaiseReason.ON_CLICK && containerSession.isSplit && containerSession.secondarySession) {
      const isPrimaryRaise = containerSession.primarySession?.sceneInfo.persistentId === persistentId;
      containerSession.dividerParam.isPrimaryRaise = isPrimaryRaise;
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onSceneRaiseToTop isPrimaryRaiseFlag:${isPrimaryRaise}`);
      // 刷新一下 zIndex
      containerSession.dividerParam.setPrimaryZIndex(isPrimaryRaise ? 0 : -1);
      containerSession.dividerParam.setSecondaryZIndex(isPrimaryRaise ? -1 : 0);
    }
    if (containerSession.isFloat && reason === SCBWindowRaiseReason.ON_CLICK) {
      this.panelMgr.raiseSceneToTop(containerSession, false);
    } else {
      this.panelMgr.raiseSceneToTop(containerSession);
    }
  }

  private onBackgroundSceneForDelegator = (persistentId?: number, containerId?: number,
    needRemoveSession?: number, shouldBackToCaller = true): void => {
    let opts: SCBMinimizeSceneOpts = {
      needRemoveSession: false,
      shouldBackToCaller: shouldBackToCaller
    }
    this.panelViewModel.onMinimizeScene(persistentId, containerId, opts);
  }

  private onBackgroundScene = (persistentId?: number, containerId?: number, isDelegator?: boolean): void => {
    homeLog.showInfo(`[SCBMain] onBackgroundScene with persistentId:${persistentId} containerId:${containerId} isDelegator:${isDelegator}`);
    let containerSession = this.panelViewModel.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (containerSession) {
      if (isDelegator) {
        containerSession.requestBackground(isDelegator);
      } else {
        containerSession.requestBackground();
      }
      animateTo({
        curve: Curve.Friction,
        duration: 400
      }, () => {
        homeLog.showInfo('SCBScenePanel, call onBackgroundScene animation callback');
        if (containerSession) {
          let controller = SCBTransitionManager.getInstance().findTransitionController(
            containerSession.primarySession?.sceneInfo.bundleName, () => {
              return PageDesktopModel.getInstance().getCloseAppData(
                containerSession?.primarySession?.sceneInfo.bundleName,
                containerSession?.primarySession?.sceneInfo.abilityName,
                undefined, undefined, undefined,
                containerSession?.primarySession?.sceneInfo.appIndex);
          });
          controller?.onInactive(TAG, 'onBackgroundScene');
          containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'onBackgroundScene', containerSession.getName());
        }
      })
      this.panelViewModel.enterFullSceneOrHomeView(ScenePanelState.HOME);
    }
  }

  @Builder
  inputMethodBuilder() {
    SCBKeyboardPanel({
      screenProperty: $screenProperty,
      keyboardState: $keyboardState,
      keyboardSession: this.keyboardSession,
      keyboardPanelSession: this.keyboardPanelSession,
      panelRect: this.keyboardPanelSession?.currRect,
      keyboardRect: this.keyboardSession?.currRect,
      name: 'AboveFloatContainerScene'
    });
  }

  notifyKeyboardPanelShowInRecent(state: ScenePanelState) : void {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      homeLog.showWarn('[SCBKeyboard] KeyboardSession is null');
      return;
    }
    if (!(this.keyboardSession?.isKeyboardShowing())) {
      homeLog.showInfo('[SCBKeyboard] keyboard is not showing');
      return;
    }
    if (state === ScenePanelState.RECENT) {
      this.keyboardPanelSession?.setVisibility(false);
    } else {
      this.keyboardPanelSession?.setVisibility(true);
    }
  }

  updateScenePanelStateAfterOneStep(state: ScenePanelState): void {
    if (this.scenePanelState === state) {
      homeLog.showInfo(`updateScenePanelStateAfterOneStep scenePanelState already ${state}`);
      return;
    }
    let fromScenePanelState = this.scenePanelState;
    this.panelViewModel.updateScenePanelState(state);
    this.panelViewModel.showWallpaperAfterRotate(!launcherVisualEffectMgr.isRecentBlurEffectDisabled());
    if (this.panelViewModel.isHideBlurInGlobalSearch(fromScenePanelState, state)) {
      this.endBlurAnimation();
    }
    if (state === ScenePanelState.HOME) {
      this.panelViewModel.changeScenePanelStateToHome(fromScenePanelState, state);
    }
    if (state === ScenePanelState.SPLIT) {
      SCBTransitionManager.getInstance().swipeUpFromHome(RecentsStyleConstants.SCALE_DEFAULT);
    }
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_RECENT);
    SCBSceneSessionManager.getInstance().notifyExitRecentForFloat();
    AppStorage.setOrCreate('showRecent', false);
    this.panelViewModel.setScenePanelTouchableByNavigation();
  }

  private endBlurAnimation(): void {
    const blurTransitionCount = this.panelMgr.addBlurTransitionCountAndReturnValue();
    animateTo({
      curve: Curve.Sharp,
      duration: 300,
      onFinish: () => {
        this.panelMgr.onBlurTransitionFinish(blurTransitionCount);
        if (this.isEmptyRecentView()) {
          let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
          SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'startBlurAnimation', true, expandStatus);
          if (StartAndExitVisualEffectManager.getInstance().isStartExitWallpaperBlurDisable()
            && !FolderData.getInstance().isFolderOpen()
            && SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
            this.desktopContext?.eventHub.emit(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT, false);
            homeLog.showInfo('endBlurAnimation ICON_START_EXIT_BLUR_EFFECT false');
          }
        }
      }
    }, () => {
      this.panelMgr.onBlurTransitionInactive();
      if (StartAndExitVisualEffectManager.getInstance().isStartExitWallpaperBlurDisable()
        && !FolderData.getInstance().isFolderOpen()) {
        launcherVisualEffectMgr.setWallpaperBlurInactive('endBlurAnimation');
      }
    })
  }

  updateScenePanelStateCallback = (state: ScenePanelState, needBlurAnimation: boolean = true): void => {
    if (this.scenePanelState === state) {
      recentLog.showInfo(`Repeat updateScenePanelStateCallback state return`);
      return;
    }
    this.panelViewModel.updateScenePanelState(state, needBlurAnimation);
  }

  private exitRecentBeforeEnterOneStepIfNeeded(): void {
    if (this.scenePanelState === ScenePanelState.RECENT) {
      ContainerBuilder.resetAllContainerPreBuildStage(this.containerSessionList);
      this.containerSessionList.forEach((item) => {
        item.isDisappearing = false;
        item.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'exitRecentBeforeEnterOneStepIfNeeded');
      })
      // not call updateScenePanelState for with blur animation
      this.panelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE);
      this.panelViewModel.showStatusBar(true);
      this.recentInnerState.onInit();
    }
  }

  private onEnterOneStepSplitScene(isFromFullScreen: boolean = false): void {
    let sceneContainerSession: SCBSceneContainerSession | null = this.containerSessionList.getTopActiveSession();
    if (!sceneContainerSession) {
      homeLog.showWarn("No scene container session onEnterSplitView");
      return;
    }
    // disable window hook when one setp split
    if (sceneContainerSession?.primarySession?.sceneInfo &&
      sceneContainerSession?.primarySession?.sceneInfo?.additionalCallers?.length !== 0) {
      homeLog.showInfo(`onEnterOneStepSplitScene container.name:${sceneContainerSession?.getName()}`);
      this.panelViewModel.clearAdditionalCallers(sceneContainerSession?.primarySession, true);
    }
    RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.ENTER_APP_SPLIT);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.INTO_SPLIT_VIEW, StyleConstants.DEFAULT_1);
    // if current scenePanelState is recent, we need to exit recent
    this.exitRecentBeforeEnterOneStepIfNeeded();
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'onEnterOneStepSplitScene', true, expandStatus);
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'onEnterOneStepSplitScene');
    if (this.keyboardSession?.isKeyboardShowing()) {
      animateToImmediately({ duration: 0 }, () => {
        this.keyboardSession.translatePosY = this.keyboardSession.getKeyboardPanelTranslateY();
      })
      SCBKeyboardManager.getInstance().requestHideKeyboard(sceneContainerSession.primarySession);
    }
    this.enterSplitView(sceneContainerSession, isFromFullScreen);
    // when start app full screen from icon by call onStartSceneFromIcon,
    // SCBDesktop animateScale will change to 0.88 and not recover,
    // so when we enter one step split scene we need to call runGlobalInactiveCallback
    // to make SCBDesktop animateScale to 1
    SCBTransitionManager.getInstance().runGlobalInactiveCallback();
    this.sceneContainerTransitionOutForOneStepSplit(sceneContainerSession);
    homeLog.showInfo(`onEnterOneStepSplitScene, containerId ${sceneContainerSession?.containerId}` +
      `scenePanelState:${this.scenePanelState}`);
    launcherVisualEffectMgr.exitBlurWithLauncherOpAnim();
  }

  private sceneContainerTransitionOutForOneStepSplit(sceneContainerSession: SCBSceneContainerSession): void {
    let bundleName = sceneContainerSession.primarySession?.sceneInfo.bundleName;
    let controller = SCBTransitionManager.getInstance().findTransitionController(
      bundleName, () => {
        return PageDesktopModel.getInstance().getCloseAppData(
          bundleName,
          sceneContainerSession.primarySession?.sceneInfo.abilityName,
          undefined, undefined, undefined,
          sceneContainerSession.primarySession?.sceneInfo.appIndex);
    });
    homeLog.showInfo(`sceneContainerTransitionOutForOneStepSplit controller:${controller}`);
    controller?.onInactive(TAG, 'sceneContainerTransitionOutForOneStepSplit');
  }

  private oneStepEnterFloat(): void {
    let containerSession = this.containerSessionList.getTopActiveSession();
    if (!containerSession) {
      winLog.showWarn('[SCBFloat] oneStepEnterFloat failed: No active containerSession');
      return;
    }
    winLog.showInfo(`[SCBFloat] oneStepEnterFloat, container: ${containerSession.getName()}`);
    this.recentInnerState.onInit();
    this.viewParam.initAll();
    this.containerSessionList.forEach(container => {
      if (CommonUtils.isInvalid(container) || container === containerSession) {
        return;
      }
      container.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'oneStepEnterFloat', container.getName());
    });
    this.panelViewModel.exitSceneWithRotationRecover(containerSession,
      SCBContainerRotationReason.LANDSCAPE_ONE_STEP_FLOAT_SCENE);
    this.updateScenePanelStateAfterOneStep(ScenePanelState.HOME);
    launcherVisualEffectMgr.exitBlurWithLauncherOpAnim();
  }

  /**
   * move container change to OneStep sate
   * @param containerSession top active container
   */
  private enterSplitView(containerSession?: SCBSceneContainerSession | null, isFromFullScreen: boolean = false): void {
    if (!containerSession) {
      homeLog.showError('fail to enterSplitView');
      return;
    }
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    containerSession.primarySession?.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    let containerRotation = containerSession.currentRotation;
    if (containerSession.primarySession) {
      containerSession.floatingParam.snapshotWidthPx = containerSession.primarySession.currRect.width.getPx();
      containerSession.floatingParam.snapshotHeightPx = containerSession.primarySession.currRect.height.getPx();
    }
    this.showSnapshot(containerSession);
    containerSession.dividerParam.deviceRadius = CommonConstants.getDeviceRadius();
    if (!isFromFullScreen || uiType !== SCBConstants.UITYPE_PHONE) {
      containerSession.dividerParam.updateDividerParamWithRatio(containerSession.screenProperty);
    }
    containerSession.dividerParam.setBorderRadius(true);
    containerSession.isSplit = true;
    containerSession.splitParam.needShowTitleBar = false;
    if (isFromFullScreen && uiType === SCBConstants.UITYPE_PAD) {
      this.enterSplitFromFullScreenAnim(containerSession);
    } else if (isFromFullScreen) {
      this.enterSplitAnim(containerSession, containerRotation, isFromFullScreen);
    } else {
      // this.resizeContainer(containerSession, false);
      this.enterSplitAnim(containerSession, containerRotation, isFromFullScreen);
    }
    containerSession.splitParam.init();
    this.containerSessionList.forEach((recentContainerSession) => {
      if (recentContainerSession && recentContainerSession.containerId !== containerSession.containerId) {
        recentContainerSession.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'enterSplitView',
          recentContainerSession.getName());
      }
    });
    this.updateScenePanelStateAfterOneStep(ScenePanelState.SPLIT);
    this.panelViewModel.resetWindowEffect(containerSession);
    containerSession.changeState(SCBSceneContainerState.ONE_STEP);
    containerSession.primarySession?.setExitSplitOnBackground(true, 'enterSplitView');
    // mask desktop edit mode
    this.editModeViewEvent.editSwitchEnable = false;
    homeLog.showInfo(`mask desktop edit mode, editSwitchEnable: ${this.editModeViewEvent.editSwitchEnable}`);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    homeLog.showInfo(`updateNavigationBarProperty in enterSplitView`);
    SCBSceneSessionManager.getInstance().updateNavigationBarProperty();
    containerSession.splitParam.setLifeCycle(SplitLifeCycle.ONESTEP);
    winLog.showInfo(`[SCBSplit] enterSplitView container: ${containerSession.getName()}`);
  }

  private exitSplitView(persistentId?: number): void {
    this.onMaximizeSplitScene(persistentId);
  }

  private showSnapshot(containerSession: SCBSceneContainerSession): void {
    containerSession.splitSnapshotAlpha = 1;
    containerSession.isShowSplitSnapshot = true;
  }

  private enterSplitFromFullScreenAnim(container: SCBSceneContainerSession): void {
    homeLog.showInfo(`enterSplitFromFullScreenAnim, isUpDownSplit:${container.dividerParam.isUpDownSplit()}`);
    container.dividerParam.needClip = false;
    container.floatingParam.isFullToOneSplitAnimation = true;
    if (!container.isOneStepSplit()) {
      winLog.showInfo(`container is not pre split state return`);
      return;
    }
    this.resizeContainer(container, true);
    this.updateSceneRectForFullToSplit(container);
  }

  private enterSplitAnim(containerSession: SCBSceneContainerSession, rotation: number,
    isFromBar: boolean = false): void {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType;
    if (rotation === containerSession.currentRotation && !isFromBar) {
      this.updateCurRectForOneStepSplit(containerSession, sceneSessionManager.SessionSizeChangeReason.RESIZE);
      // portrait or expand status, two animation curves
      animateTo({ curve: curves.springMotion(0.5, 1), onFinish: () => {
        homeLog.showInfo('raiseAnimateToSchedulePriority:one step split end');
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.INTO_SPLIT_VIEW, StyleConstants.DEFAULT_0);
        RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.ENTER_APP_SPLIT_END);
      } }, () => {
        this.oneStepSceneZoom(containerSession);
      })
      animateToImmediately({
        curve: curves.springMotion(0.55, 0.85),
        delay: 400,
        onFinish: () => {
          homeLog.showInfo('animateToImmediately:one step split end');
          if (uiType === SCBConstants.UITYPE_PAD) {
            this.panelViewModel.exitSceneWithRotationRecover(containerSession, SCBContainerRotationReason.SPLIT_SCENE);
          }
          SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'onEnterOneStepSplitScene');
          let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
          SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'onEnterOneStepSplitScene', true, expandStatus);
        }
      }, () => {
        this.moveToOneStepDefaultPos(containerSession);
        containerSession.dividerParam.setBorderRadius();
      })
    } else if (isFromBar) {
      // from titleBar, one shot animation
      containerSession.dividerParam.isUpDownSplit() ? containerSession.dividerParam.positionY = '100%' :
        containerSession.dividerParam.positionX = '100%';
      transactionManager.openSyncTransaction();
      transactionManager.closeSyncTransaction();
    } else {
      // landscape, one animation curve
      homeLog.showInfo(`enterSplitView rotation ${rotation}`);
      this.updateCurRectForOneStepSplit(containerSession, sceneSessionManager.SessionSizeChangeReason.RESIZE);
    }
  }

  private updateCurRectForOneStepSplit(containerSession: SCBSceneContainerSession,
    reason: sceneSessionManager.SessionSizeChangeReason) {
    let moveOffset: number = containerSession.dividerParam.calOneStepDefaultTrans(this.screenProperty);
    containerSession.primarySession?.updateCurRectForOneStepSplit(this.screenProperty,
      containerSession.dividerParam.isUpDownSplit(), vp2px(moveOffset), reason);
  }

  /**
   * Before entering split mode, resize the container. Make the window in its original size.
   *
   * @param containerSession current container session
   */
  private resizeContainer(containerSession: SCBSceneContainerSession, isNeedChangeWindowSize: boolean = false): void {
    if (containerSession.dividerParam.isUpDownSplit()) {
      containerSession.needRenderTranslate.setTranslateY(containerSession.needRenderTranslate.translateY +
        (1 / containerSession.dividerParam.primSizePct - 1) *
        containerSession.needRenderScale.scaleY * containerSession.height.getVp() / 2);
      containerSession.needRenderScale.setScaleY(containerSession.needRenderScale.scaleY *
        1 / containerSession.dividerParam.primSizePct);
    } else {
      containerSession.needRenderTranslate.setTranslateX(containerSession.needRenderTranslate.translateX +
        (1 / containerSession.dividerParam.primSizePct - 1) *
        containerSession.needRenderScale.scaleX * containerSession.width.getVp() / 2);
      containerSession.needRenderScale.setScaleX(containerSession.needRenderScale.scaleX *
        1 / containerSession.dividerParam.primSizePct);
    }
  }

  // one step split container zoom
  private oneStepSceneZoom(containerSession: SCBSceneContainerSession): void {
    containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'enterSplitView', containerSession.getName());
    containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'enterSplitView', containerSession.getName());
    containerSession.dividerParam.updateDividerParamWithRatio(this.screenProperty);
    if (containerSession.primarySession) {
      containerSession.floatingParam.snapshotWidthPx = containerSession.primarySession.currRect.width.getPx();
      containerSession.floatingParam.snapshotHeightPx = containerSession.primarySession.currRect.height.getPx();
    }
    this.viewParam.initAll();
    containerSession.init();
    containerSession.dividerParam.setBorderRadius(true);
  }

  private updateSceneRectForFullToSplit(container: SCBSceneContainerSession): void {
    const reason = sceneSessionManager.SessionSizeChangeReason.SPLIT_TO_FULL;
    container.primarySession?.updateCurRectForOneStepSplit(this.screenProperty,
      container.dividerParam.isUpDownSplit(), 0, reason);
  }

  /**
   * moveToOneStepDefaultPos in entersplitview anim
   * @param container
   */
  private moveToOneStepDefaultPos(container: SCBSceneContainerSession): void {
    let dividerParam = container.dividerParam;
    container.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0, TAG,
      'moveToOneStepDefaultPos', container.getName());
    let oneStepTrans: number = dividerParam.calOneStepDefaultTrans(this.screenProperty);
    dividerParam.setOneStepDefaultPos(oneStepTrans, this.screenProperty);
    dividerParam.dividerOpacity = 1;
  }

  private isPcAppInPad(sceneContainerSession: SCBSceneContainerSession): boolean {
    return DeviceHelper.isPad() && SCBRecentPrepareManager.getInstance().isPcAppInPadByContainer(sceneContainerSession);
  }

  private onRecentGestureActionEnd(containerId: number, event: GestureEvent): void {
    if (!this.panelViewModel.isRecentState()) {
      recentLog.info(`delete return when not in recent state, ${this.scenePanelState}`);
      return;
    }
    // 删除卡片前移除待销毁的卡片，避免重复删除导致的异常
    recentRuntimeInstance.needRemoveSessionList.deleteByContainerId(containerId);
    // 直接使用传来的containerId 避免termiane造成的removingindex错误
    const index = recentRuntimeInstance.notRemovingSessionList.findIndexByContainerId(containerId);
    if (index === -1) {
      recentLog.showInfo(`invalid containerId:${containerId}`);
      return;
    }
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[index];
    // unclearAble = true 卡片不可被删除
    let unclearAble = false;
    if (sceneContainerSession.primarySession?.sceneInfo) {
      unclearAble = sceneContainerSession.primarySession?.isUnclearable();
      if (unclearAble) {
        HiSysEventUtil.reportClearSingleAppInRecent(sceneContainerSession.primarySession?.sceneInfo.bundleName, true);
      }
    }
    recentLog.showInfo(`onRecentGestureActionEnd ${sceneContainerSession?.containerId}`);
    const isPcAppInPad = this.isPcAppInPad(sceneContainerSession);
    this.deleteRecentCardByGestureActionEnd(sceneContainerSession, index, isPcAppInPad);
    CloseAppManager.getInstance().clearAdaptiveIconCache(sceneContainerSession?.companionIconInfo?.iconNumber);
    CloseAppManager.getInstance().deleteCardCache(sceneContainerSession?.companionIconInfo?.iconId);
  }

  deleteRecentCardByGestureActionEnd(sceneContainerSession: SCBSceneContainerSession, index: number,
    isPcAppInPad: boolean): void {
    recentLog.showInfo(`deleteRecentCardByGestureActionEnd ${sceneContainerSession.getName()}`)
    // 标题消失的动效
    this.recentDelete.titleDisappearAnimationForDelete(sceneContainerSession);
    // animation for other scene
    this.panelViewModel.deleteSceneContainerFromRecentWithAnimation(recentRuntimeInstance.notRemovingSessionList,
      index);
    // set true for clear session flag if the destruction operation is from recent view
    sceneContainerSession.setIsClearSession(true);
    // animation for the deleted scene
    this.deleteSceneContainerTransitionOut(sceneContainerSession, index, isPcAppInPad);

    this.recentGesture.onRecentGestureFinish();
  }

  private deleteContainerInAnimation(sceneContainerSession: SCBSceneContainerSession) {
    this.panelMgr.removeNotShowRecentSession(sceneContainerSession);
    if (sceneContainerSession.isFloat) {
      this.panelMgr.removeFloatContainerSession(sceneContainerSession);
    } else {
      let index = this.containerSessionList.findIndexByContainerId(sceneContainerSession.containerId);
      this.panelMgr.removeContainerSessionByIndex(index);
      this.panelMgr.getSceneContainerSessionListForView().deleteByContainerId(sceneContainerSession.containerId);
    }
    this.totalContainerSessionList.deleteByContainerId(sceneContainerSession.containerId);
    recentRuntimeInstance.update(this.totalContainerSessionList);
    // 删除一个任务后，最大显示数量需要减1
    recentRuntimeInstance.containerCountsShowInRecent--;
  }

  private deleteSceneContainerTransitionOut(sceneContainerSession: SCBSceneContainerSession, index: number,
    isPcAppInPad: boolean) {
    homeLog.showInfo('deleteSceneContainerTransitionOut, container.bundleName: ' +
      sceneContainerSession.companionIconInfo?.bundleName + 'container.abilityName: ' +
      sceneContainerSession.companionIconInfo?.abilityName + 'isPcAppInPad' + isPcAppInPad);
    RecentAccessibilityUtils.textAnnouncedForClearApp(sceneContainerSession);
    // animation no need calc icon pos with rotation, thus can clear session data before animation
    if (!isPcAppInPad) {
      sceneContainerSession.requestDestructionWithTransitionOut(true, false, false, false, true);
    }
    sceneContainerSession.addTransitionCount();
    SCBTransitionManager.getInstance().addStartExitAnimationCount('deleteSceneContainerTransitionOut');
    let animationNum = sceneContainerSession.getTransitionCount();
    let listLen = recentRuntimeInstance.notRemovingSessionList.length - recentRuntimeInstance.leftBoundaryIndex;

    performanceMonitor.begin(HiSysEventUtil.CLEAR_1_RECENT_ANI, performanceMonitor.ActionType.FIRST_MOVE);
    if (listLen === 1) {
      this.panelViewModel.updateScreenRotationPropertyForExit();
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_START, sceneContainerSession);
    }
    let param: AnimateParam = {
      curve: curves.springMotion(0.5, 1, 0),
      onFinish: () => {
        recentLog.info(`deleteSceneContainerTransitionOut finish ${animationNum} ${listLen}`);
        this.recentGesture.resetZindexAndCenterOnfinish(sceneContainerSession, animationNum);
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount('deleteSceneContainerTransitionOut end');
        // if the animationNum indicates that this is the last animation,
        let isLastAnimation = sceneContainerSession.transitionOutFinishIfNeed(animationNum, false, true);
        if (isLastAnimation && sceneContainerSession.pendingRemove) {
          sceneContainerSession.currentRotation = 0;
          if ((!this.panelViewModel.isVerticalExit() || SCBWindowRotateController.getInstance().isDesktopRotatable()) && (listLen === 1)) {
            this.panelViewModel.exitSceneWithRotationRecover();
          }
          sceneContainerSession?.transitionController?.onInactive(TAG, 'deleteSceneContainerTransitionOut');
        }
        this.checkIfNeedRecoverScreenProperty(this.panelViewModel.getExitSceneNotifyRotation());
        this.recentDelete.showStatusBarIfNeedOnfinish(this.scenePanelState, listLen);
        // 上划删除不被打断，最后一张删除的时候不判断打断的条件
        if (listLen === 1) {
          RecentGestureEventManager.getInstance()
            .deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_END, sceneContainerSession);
          this.recentClearAll.clearRecentListIfNeed(animationNum, sceneContainerSession);
        }
        HiSysEventUtil.reportClearSingleAppInRecent(sceneContainerSession.companionIconInfo?.bundleName, false);
        if (isPcAppInPad) {
          SCBRecentPrepareManager.getInstance().prepareTerminateSceneContainer(sceneContainerSession,
            (): boolean => { return this.panelViewModel.isRecentState(); })
        }
        performanceMonitor.end(HiSysEventUtil.CLEAR_1_RECENT_ANI);
      }
    };
    if (!this.panelViewModel.isNewStyle) {
      param.curve = Curve.Linear;
      param.duration = 250;
    }
    animateTo(param, () => {
      sceneContainerSession.needRenderRotate.setAngle(-90);
      RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(sceneContainerSession,
        RecentsStyleConstants.FOREGROUND_BLUR_RADIUS, false);
      if (listLen === 1) {
        sceneContainerSession.resetNeedRenderPosByTranslate();
        this.panelViewModel.updateScenePanelState(ScenePanelState.HOME);
        this.recentInnerState.onInit();
      }
      this.deleteContainerInAnimation(sceneContainerSession);
      if (isPcAppInPad) {
        // PC应用无法直接关闭，containerSession暂存在notShowList，再走预关闭逻辑询问应用是否关闭
        sceneContainerSession.requestBackground();
        this.panelMgr.addNotShowRecentSession(sceneContainerSession);
      }
    })
  }

  private registerSceneSessionManagerEventCallback(): void {
    homeLog.showInfo(`Register event callbacks in ${TAG}`);
    this.panelViewModel.registerSceneMissionManagementCallback();

    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_VIRTUAL, this.screenProperty.screenId,
      this.onStartSceneFromVirtual);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_NOTIFICATION, this.screenProperty.screenId,
      this.onStartSceneFromNotification);
    SCBSceneSessionManager.getInstance().on(SCBEventId.BACK_SCENE_TRANSITION, this.screenProperty.screenId,
      this.onSceneBackTransition);
    SCBSceneSessionManager.getInstance().on(SCBEventId.BACKGROUND_SCENE, this.screenProperty.screenId,
      this.onBackgroundScene);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MAXIMIZE_SCENE, this.screenProperty.screenId,
      this.onMaximizeScene);
    SCBSceneSessionManager.getInstance().on(SCBEventId.EXIT_RECENT, this.screenProperty.screenId,
      this.onExitRecent);
    SCBSceneSessionManager.getInstance().on(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      this.doSceneRaiseToTop);
    SCBSceneSessionManager.getInstance().on(SCBEventId.SESSION_EXCEPTION, this.screenProperty.screenId,
      this.onSessionException);
    SCBSceneSessionManager.getInstance().on(SCBEventId.BACKGROUND_SCENE_FOR_DELEGATOR, this.screenProperty.screenId,
      this.onBackgroundSceneForDelegator);
    SCBSceneSessionManager.getInstance().on(SCBEventId.ORIENTATION_CHANGE, this.screenProperty.screenId,
      this.onContainerRequestedOrientationChange);
    SCBSceneSessionManager.getInstance().on(SCBEventId.SPLIT_TO_FULL_FOR_MAXIMIZE, this.screenProperty.screenId,
      this.onMaximizeSplitScene);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, this.screenProperty.screenId,
      this.onMinimizeAllFloatContainer);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MAXIMIZE_FLOATING_SCENE, this.screenProperty.screenId,
      this.onMaximizeFloat);
    SCBSceneSessionManager.getInstance().on(SCBEventId.CLOSE_FLOATING_SCENE, this.screenProperty.screenId,
      this.onCloseFloatingSceneCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.EXIT_GAME_SPLIT_VIEW, this.screenProperty.screenId,
      this.panelViewModel.exitSplitViewInFixedMultiWindowOrientation);
    SCBSceneSessionManager.getInstance().on(SCBEventId.FLOAT_TRANSITION, this.screenProperty.screenId,
      this.onFloatTransition);
    SCBSceneSessionManager.getInstance().on(SCBEventId.RESET_SPLIT_VIEW_WITH_FOLD, this.screenProperty.screenId,
      this.resetSplitViewWithFold);
    SCBSceneSessionManager.getInstance().on(SCBEventId.FULL_TO_FLOATING, this.screenProperty.screenId,
      this.onFullToFloat);
    SCBSceneSessionManager.getInstance().on(SCBEventId.FULL_TO_SPLIT, this.screenProperty.screenId,
      this.onFullToSplit);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SPLIT_FROM_ICON, this.screenProperty.screenId,
      this.onStartSplitFromIcon);
    SCBSceneSessionManager.getInstance().on(SCBEventId.CLOSE_TARGET_FLOAT_WINDOW, this.screenProperty.screenId,
      this.onCloseTargetFloatingScene);
    this.registerCallbackHiddenStartMode(SCBSceneSessionManager.getInstance(), this.screenProperty.screenId);
  }

  private registerCallbackHiddenStartMode(managerInstance: SCBSceneSessionManager, screenId: number): void {
    managerInstance.on(SCBEventId.HIDDEN_START_SCENE_FROM_OTHER, screenId, this.onSceneHiddenStartFromOther);
    managerInstance.on(SCBEventId.HIDDEN_START_SCENE_TRANSITION, screenId, this.onSceneHiddenStartTransition);
    managerInstance.on(SCBEventId.FOREGROUND_TO_HIDDEN_FROM_OTHER, screenId, this.sceneForegroundToHiddenCallback);
    managerInstance.on(SCBEventId.HIDDEN_TO_FOREGROUND_FROM_OTHER, screenId, this.sceneHiddenToForegroundFromOtherCallback);
  }

  private onCloseTargetFloatingScene = (bundleName: string) : void => {
  }

  private onExitRecent = (): void => {
    this.panelViewModel.exitRecentAndNotifyFloat();
  }

  private onMinimizeAllFloatContainer = (): void => {
  }

  private onMaximizeFloat = (persistentId?: number): void => {
  }

  private onFullToFloat = (persistentId?: number): void => {
    this.enterFloatFromFull(persistentId as number, this.screenProperty)
  }

  private onFullToSplit = (persistentId?: number): void => {
    this.enterSplitFromFullForPad();
  }

  private onStartSplitFromIcon = (persistentId: number): void => {
    homeLog.showInfo(`onStartSplitFromIcon persistentId=${persistentId}`);
    let containerSession: SCBSceneContainerSession | null =
      this.panelViewModel.getSceneContainerSessionWithPersistentId(persistentId);
    if (!containerSession) {
      homeLog.showWarn("No scene container session onStartSplitFromIcon");
      return;
    }
    this.initDefaultSplit(containerSession);
    this.onEnterOneStepSplitScene();
  }

  private onFloatingSceneToFull = (scbSceneSession: SCBSceneSession, fromDrag: boolean): void => {
    this.floatingSceneToFull(scbSceneSession, fromDrag);
  }

  private onCloseFloatingSceneCallback = (persistentId?: number): void => {
  }

  private onRaiseToTop = (persistentId?: number): void => {
  }

  private transferToBackgroundForSinglePocket(foldStatus: display.FoldStatus) {
    if (foldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED) {
      return;
    }
    homeLog.showInfo('beforeScreenPropertyChange transferToBackgroundForSinglePocket');
    // 多任务场景预处理
    if (this.scenePanelState === ScenePanelState.RECENT) {
      this.exitRecentWhenFoldChange();
    }
    // 分屏场景预处理
    this.lockPrepareForSplit();
    // 应用提前退后台
    singleDisplayPocketUtil.transferToBackgroundWhenLocked();
  }

  private exitRecentWhenFoldChange(): void {
    this.panelVisible = Visibility.Hidden;
    homeLog.showInfo(`The screen expand status changed. Exit Rencent immediately.`);
    this.panelViewModel.exitRecentAndNotifyFloat(true, true);
  }

  private onViewSplitListenerCalled: ViewSplitListener = {
    // when need to split screen
    viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
      let topContainerSession: SCBSceneContainerSession | null = this.containerSessionList.getTopActiveSession();
      this.panelViewModel.viewSplitScreen(primaryAppSceneInfo, secondaryAppSceneInfo, topContainerSession, switchType);
    },
    // when need to call intent as frequent switch
    setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      this.panelViewModel.setSplitIntent(primaryAppSceneInfo, secondaryAppSceneInfo);
    },
    // when need to call intent as natural switch
    setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      let containerSession: SCBSceneContainerSession | null = this.containerSessionList.getTopActiveSession();
      let isNeedShareIntent: boolean = SCBSceneWindowAiSplitSwitchUtils.getInstance()
        .isNeedToShareIntentAsNaturalSwitch(fromSceneInfo, toSceneInfo, containerSession);
      if (isNeedShareIntent) {
        this.panelViewModel.setSplitIntent(fromSceneInfo, toSceneInfo);
        SCBSceneWindowAiSplitSwitchUtils.getInstance().saveNaturalSceneInfo(fromSceneInfo, toSceneInfo);
      }
    },
    deleteSplitIntent: () => {
      // SCBSceneWindowAiSplitSwitchUtils.getInstance().deleteSplitIntent();
    }
  }

  private onCameraCompatibleViewChange = (container: SCBSceneContainerSession, isEnterCompatibleView: boolean): void => {
    if (!container || !container.primarySession) {
      winLog.showError(`scene session is null`);
      return;
    }
    // 横屏铺满 -> 横屏居中 / 横屏居中 -> 横屏铺满
    animateTo({
      curve: curves.springMotion(0.55, 1, 0),
    }, () => {
      if (isEnterCompatibleView) {
        this.showDesktopIfNeed('containerEnterCompatibleView');
        this.showWallpaperIfNeed('containerEnterCompatibleView');
      }
    });
  }

  private scenePanelFsmInit(): void {
    this.panelFsm.init();
    this.panelFsm.setCallback(this.homeIdleCallback);
    this.panelFsm.setCallback(this.overViewFollowingFromHomeCallback);
    this.panelFsm.setCallback(this.appIdleCallback);
    this.panelFsm.setCallback(this.zoomFollowingFromAppCallback);
    this.panelFsm.setCallback(this.quickSwitchFollowingFromAppCallback);
    this.panelFsm.setCallback(this.recentFollowFromAppCallback);
    this.panelFsm.setCallback(this.farAwayFollowingFromAppCallback);
    this.panelFsm.setCallback(this.recentIdleCallback);
    this.panelFsm.setCallback(this.recentScrollFollowingCallback);
    this.panelFsm.setCallback(this.recentScrollFlingCallback);
    this.panelFsm.setCallback(this.recentDeleteFollowingCallback);
    this.panelFsm.setCallback(this.emergencyHomeIdleCallback);
    this.panelFsm.setCallback(this.outdoorIdleCallback);
    homeViewModel.recentEnterAnimations = this.recentEnter;
  }

  aboutToAppear(): void {
    this.doReport = false;
    this.panelViewModel.init(this.panelStateCollectionHandler, this.panelDataCollectionHandler);
    // 面板管理器初始化
    this.panelMgr.init({
      onRaiseSceneToTop: this.onRaiseSceneToTop
    });
    this.panelSession.init(SCBDefaultZIndex.SCENE_PANEL);
    this.scenePanelFsmInit();
    AppStorage.setOrCreate('enableScroll', true);
    this.debugCommands.register();

    // pad或折叠屏展开态初始化为多行显示
    if (DeviceHelper.isPad() || desktopUtil.isFoldExpandStatus()) {
      recentLayoutConfigInstance.updateMultiRowLayout(true);
    }
    this.initRecentLayoutParam();
    SCBKeyboardManager.getInstance().registerKeyboardShowCallback(this.keyboardShowCallback);
    SCBKeyboardManager.getInstance().registerkeyboardRectChangeCallbacks(this.keyboardRectChangeCallback);
    SCBSceneSessionManager.getInstance().registerOnAnimationFinishedCallback(this.animationFinishedCallback);
    this.onEnterFullSceneMode();
    this.panelViewModel.setEmergencyOrThermalSafeModeDuration();
    DesktopModeManager.getInstance().registerModeChangeCallback(TAG, this.modeChangeCallBack, NumberConstants.CONSTANT_NUMBER_ONE);
    recentDisplayManager.init();
    scbEventExclusiveManager.registerEventExclusive(EventType.APPEXIT_LANDSCAPE, () => {
      let duration = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false) - this.panelViewModel.timerStartTime;
      if (scbEventExclusiveManager.getEventExclusiveByCaller(EventType.APPEXIT_LANDSCAPE) && (duration > 1500) &&
        (this.landscapeExitTimeOutId !== 0)) {
        this.landscapeExitTimeOutId = 0;
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
      }
    })
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.clearMemoryCallback);
    // 初始化播控中心监听接口
    recentMediaPlayInstance.initAvSessionMap();
    SCBSceneSessionManager.getInstance().registerRecentClearAllAnimCntCallback(
      this.clearAllAnimCntCallback);
    SCBScreenSessionManager.getInstance().registerWrapRotateEntryCallback(this.wrapRotationEntryCallback, this.screenProperty.screenId);
    this.uiContext = this.getUIContext?.();
    // 延时3s注册，避免rss还没起来注册不上的问题
    setTimeout(() => {
      homeLog.showInfo('AnimPolicyRegistry registerRssCallback');
      AnimPolicyRegistry.registerRssCallback();
    }, AnimPolicyConstant.POLICY_REGISTRY_DELAY);
    // 侧边栏需要全局注册监听应用启动数据
    GestureDockPreferenceMgr.getInstance().registerSceneStateChangeCallback();
    RecentGestureEventManager.getInstance().registerSceneStateChangeCallback();
    this.panelViewModel.laterInitOnPanelAppear();
    SCBSceneSessionManager.getInstance().initPiPSwitchStatus();
  }

  private clearAllAnimCntCallback = (): number => {
    return this.clearAllAnimCnt;
  }

  /**
   * 封装startSceneWirhRotation和exitSceneWithRotiatoin，处理旋转入口禁用逻辑
   * @param wrapRotationEntryParam
   */
  private wrapRotationEntryCallback = (wrapRotationEntryParam : WrapRotationEntryParam): void => {
    if (wrapRotationEntryParam === null || wrapRotationEntryParam === undefined) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] param is null.');
      return;
    }
    let rotateFuncType = wrapRotationEntryParam.rotateFuncType;
    let needAnimation = wrapRotationEntryParam.needAnimation;
    let reason = wrapRotationEntryParam.reason;
    let containerSession = wrapRotationEntryParam.containerSession;
    let isFromRecent = wrapRotationEntryParam.isFromRecent;
    let fromUser = wrapRotationEntryParam.fromUser;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[wrapRotationEntryCallback] rotateFuncType:${rotateFuncType}, reason:${reason}, ` +
                     `containerSession:${containerSession?.getName()}, needAnimation:${needAnimation}, ` +
                     `isFromRecent:${isFromRecent}, fromUser:${fromUser}`);
    if (rotateFuncType === null || rotateFuncType === undefined) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] rotateFuncType is null.');
      return;
    }
    if (rotateFuncType == RotateFuncType.START_SCENE && (containerSession === null || containerSession === undefined)) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] containerSession is null.');
      return;
    }
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] screen session is null.');
      return;
    }
    if (!screenSession.isEnableRotatoinExclusive()) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] disableRoation.');
      return;
    }
    if (this.panelViewModel.isRecentState()) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] scenePanelState is ScenePanelState.RECENT.');
      return;
    }
    switch (rotateFuncType) {
      case RotateFuncType.START_SCENE:
        this.panelViewModel.startSceneWithRotationIfNeed(containerSession, needAnimation, isFromRecent, fromUser);
        break;
      case RotateFuncType.EXIT_SCENE:
        this.panelViewModel.exitSceneWithRotationRecover(containerSession, reason);
        break;
      default:
        WinLog.showError(WinLogDomain.WMS_ROTATION, '[wrapRotationEntryCallback] rotateFuncType is not support.');
        break;
    }
    this.uiContext = this.getUIContext?.();
  }

  private rotationScreenCallback: (currentSession?: SCBSceneContainerSession,
    reason?: SCBContainerRotationReason) => void =
    (currentSession?: SCBSceneContainerSession, reason?: SCBContainerRotationReason) => {
      this.panelViewModel.exitSceneWithRotationRecover(currentSession, reason);
    }

  private setSplitBlurWallpaperEnable = (isShow: boolean = false) => {
    this.splitBlurWallpaperEnable = isShow;
  }

  private getSplitBlurWallpaperEnable = () => {
    return this.splitBlurWallpaperEnable;
  }

  private setBlurWallpaperVisible = (isVisible: boolean) => {
  }

  private getBlurWallpaperVisible = () => {
    return false;
  }

  recoverSessionListCallback = (isNeedFilter: boolean): void => {
    if (isNeedFilter) {
      this.recentDeleteConfig = outerRecentDeleteConfig;
    }
    recentLockModel.batchInsertOrUPdateRecentLock();
  }

  private onEnterFullSceneMode(): void {
    homeLog.showInfo(`[FreeformScene]Enter full scene mode`);
    this.initUiState();
    this.registerScreenSessionManagerCallback();
    this.sceneSessionManagerRegisterCallback();
    this.registerGestureNavigationEventCallback();
    this.registerMultiWindowGestureNavigationCallback();
    this.registerGestureBackEventCallback();
    this.registerPcKey();
    this.registerOtherCallback();
    if (TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      TouchBoardGestureManager.getInstance().registerThreeFingerSwipeCallback(this.threeFingerSwiperCallback);
    }
    if (DeviceHelper.isThreeFoldProduct()) {
      recentLayoutConfigInstance.updateMultiRowLayout(desktopUtil.isFoldExpandStatus());
      RecentForegroundBlurAniMgr.getInstance().updateFoldExpandStatus(desktopUtil.isFoldExpandStatus());
      this.initRecentLayoutParam();
      this.viewParam.initAll();
    }
  }

  public recoverPersistentCallback = (): void => {
    if (SCBSceneSessionManager.getInstance().getScenePersistent().hasRecover) {
      homeLog.showWarn("SCBScenePersistent has been recovered");
      return;
    }
    SCBSceneSessionManager.getInstance().getScenePersistent().recoverSessionList(
      this.containerSessionList, this.screenProperty, this.recoverContainerSessionListCallback);
    SCBSceneSessionManager.getInstance().getScenePersistent().hasRecover = true;
  }

  private sceneSessionManagerRegisterCallback(): void {
    this.registerSceneSessionManagerEventCallback();
    SCBSceneSessionManager.getInstance().onShow(this.onShow);
    homeLog.showInfo(`IsAbnormalRecovery = ${SCBRecoverManager.getInstance().isAbnormalRecovery()}`)
    if (SCBRecoverManager.getInstance().isAbnormalRecovery()) {
      SCBSceneSessionManager.getInstance().registerRecoverSessionCallback(this.recoverContainerSessionListCallback);
      SCBRecoverManager.getInstance().setOnRecoverFinishedCallback(this.recoverFinishedCallback);
    } else if (!SCBSceneSessionManager.getInstance().getScenePersistent().hasRecover) {
      SCBSceneSessionManager.getInstance().getScenePersistent().recoverSessionList(
        this.containerSessionList, this.screenProperty, this.recoverSessionListCallback);
      SCBSceneSessionManager.getInstance().getScenePersistent().hasRecover = true;
    }
    SCBSceneSessionManager.getInstance().registerRecoverPersistentCallback(this.recoverPersistentCallback);
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListCallback(this.getContainerSessionListCallback);
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListNotShowRecentCallback(
      this.getContainerSessionListNotShowRecentCallback, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerStartSceneWithRotationIfNeedCallback(
      this.startSceneWithRotationIfNeedCallback);
    SCBSceneSessionManager.getInstance().registerGetFloatingSessionListCallback(this.getFloatContainerListCallback);
    SCBSceneSessionManager.getInstance()
      .registerAddContainerSessionCallback(this.addShowWhenLockedSceneContainerSessionCallback);
    SCBSceneSessionManager.getInstance()
      .registerRemoveContainerSessionCallback(this.removeShowWhenLockedSceneContainerSessionCallback);
    this.registerUnlockTransitionController();
    SCBSceneSessionManager.getInstance().registerGetScenePanelStateCallback(this.screenProperty.screenId,
      SCBDefaultZIndex.SCENE_PANEL, () => {
        return this.scenePanelState;
      });
    SCBSceneSessionManager.getInstance().registerUpdateScenePanelStateCallback(this.screenProperty.screenId,
      SCBDefaultZIndex.SCENE_PANEL, (state: ScenePanelState, needBlurAnimation: boolean = true) => {
        this.panelViewModel.updateScenePanelState(state, needBlurAnimation);
    });
    SCBPiPManager.getInstance().registerAutoStartPipStatusChange();
    SCBSceneSessionManager.getInstance().registerAppExitListener();
  }

  private registerScreenSessionManagerCallback(): void {
    SCBScreenSessionManager.getInstance().registerStartFoldToExpandChangeCallback((
      screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason,
      currScreenProperty?: SCBScreenProperty) => {
      this.beforeFoldExpandStatusChange(screenProperty, reason, currScreenProperty);
    }, SCBDefaultZIndex.SCENE_PANEL, this.screenProperty.screenId);
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback((
      screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason) => {
      try {
        SCBOuterScenePanelManager.getInstance().updateCurrentStatus(display.getFoldDisplayMode());
      } catch (err) {
        homeLog.showError(`registerScreenSessionManagerCallback fail, error is ${err?.message}`);
      }
      this.onScreenPropertyChange(screenProperty, reason);
    }, SCBDefaultZIndex.SCENE_PANEL, this.screenProperty.screenId);
  }

  private registerOtherCallback() {
    InputConsumer.on('key', this.homeKeyOption, () => {
      localEventManager.sendLocalEvent(EventConstants.HOME_KEY_INPUT);
      this.onHomeKeyInput();
      scbGestureManager.publishScenePanelEventMsg(CEManager.CUSTOM_NAVBAR_EVENT, NavBarEventType.EXECUTE_HOME);
    });
    this.evtMgr.on<RotateChangeEvent>(RotateChangeEvent,
      (event: RotateChangeEvent) => this.onFoldRotateStatusChange(event));

    SCBWindowRotate.getInstance().registerPrepareBeforeAnimationCallback((targetRotation: number) => {
      this.panelViewModel.prepareRotationBeforeAnimation(targetRotation);
    });
    SCBWindowRotateController.getInstance().registerLandscapeStartScenePanelCallback(
      (propertyAfter: SCBScreenProperty) => {
        this.sceneLandscapeStartCallback(propertyAfter);
      }
    );
    SCBWindowRotateController.getInstance().registerStartSceneWithRotationIfNeedCallback(
      this.startSceneWithRotationIfNeedCallback);
  }

  private registerPcKey(): void {
    scbGestureManager.registerPcKeyCallback(TAG, (type: PcKeyType) => {
      if (!scbGestureManager.isGestureEnable()) {
        return;
      }
      if (ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD)) {
        return;
      }
      homeLog.showInfo(`get PCKEY callback , type=${type}`)
      switch (type) {
        case PcKeyType.HOME:
          this.onHomeKeyInput();
          break;
        case PcKeyType.RECENT:
          this.onRecentKeyInput();
          break;
        case PcKeyType.ESC:
          this.onEscKeyInput();
          break;
        default:
          break;
      }
    });
  }

  // 屏幕旋转
  private onFoldRotateStatusChange(event: RotateChangeEvent) :void {
    homeLog.showInfo('onFoldRotateStatusChange, foldRotateStatus = %{public}d scenePanelState = %{public}d',
      event.rotateStatus, this.scenePanelState);
    let topContainerSession: SCBSceneContainerSession | null = this.containerSessionList.getTopActiveSession();
    switch (event.rotateStatus) {
      case RotateChangeEvent.ROTATE_STATUS_START:
        if (this.scenePanelState !== ScenePanelState.FULLSCENE) {
          // 桌面或者背景透明的应用在前台时，不能禁用模糊效果
          return;
        }
        homeLog.showInfo('disable Blur in onFoldRotateStatusChange');
        this.isHideBlurInRotate = true;
        this.panelMgr.disableBlurComponent('onFoldRotateStatusChange rotate status start');
        if (topContainerSession && topContainerSession.isSplitView()) {
          topContainerSession.dividerParam.grayscaleOpacity = 0;
        }
        break;
      case RotateChangeEvent.ROTATE_STATUS_END:
        if (!this.isHideBlurInRotate) {
          return;
        }
        homeLog.showInfo('enable Blur in onFoldRotateStatusChange');
        if (topContainerSession && topContainerSession.isSplitView()) {
          topContainerSession.dividerParam.grayscaleOpacity = 1;
          if (!topContainerSession.dividerParam.isUpDownSplit() || !DeviceHelper.isPhone()) {
            return;
          }
        }
        this.isHideBlurInRotate = false;
        this.panelMgr.enableBlurComponent('onFoldRotateStatusChange rotate status end');
        break;
      case RotateChangeEvent.ROTATE_STATUS_CANCEL:
        if (!this.isHideBlurInRotate) {
          return;
        }
        homeLog.showInfo('onFoldRotateStatusChange, cancel rotate');
        this.isHideBlurInRotate = false;
        if (topContainerSession && topContainerSession.isSplitView()) {
          topContainerSession.dividerParam.grayscaleOpacity = 1;
        }
        break;
      default:
        homeLog.showInfo('RotateStatus is invalid status');
        break;
    }
  }

  private onShow = (persistentId: number): void => {
    let sceneContainerSession = this.panelViewModel.getSceneContainerSessionWithPersistentId(persistentId);
    if (sceneContainerSession == null) {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
      homeLog.showError('Failed to get sceneContainerSession');
      return;
    }
    if (this.scenePanelState === ScenePanelState.RECENT) {
      // 历史任务还原场景
      this.panelViewModel.onStartSceneFromRecent(persistentId, sceneContainerSession.containerId);
      return;
    }
    if (sceneContainerSession.primarySession) {
      let toInfo = sceneContainerSession.primarySession.sceneInfo;
      if (this.panelViewModel.isExternalScreenIntercepted(sceneContainerSession)) {
        SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
        return;
      }
      if (sceneContainerSession.secondarySession) {
        toInfo = sceneContainerSession.secondarySession.sceneInfo.persistentId == persistentId ?
        sceneContainerSession.secondarySession.sceneInfo : sceneContainerSession.primarySession.sceneInfo;
      }
      let currentSession = this.containerSessionList.getTopActiveSession();
      if (currentSession == null || this.scenePanelState === ScenePanelState.SPLIT) {
        const parameters = toInfo?.want?.parameters;
        // 由于FORM_ID是给卡片做启动动效，其他启动场景需要删除，避免干扰流程
        if (parameters) {
          parameters[FormConstants.FORM_ID] = '';
        }
        // 由桌面还原场景
        this.panelViewModel.onStartSceneFromOther(toInfo);
        return;
      }
      if (sceneContainerSession == currentSession) {
        homeLog.showInfo('Restore from current app');
        // 本应用还原场景
        SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
        return;
      }
      if (currentSession.primarySession) {
        let fromInfo = currentSession.primarySession.sceneInfo;
        // 其他应用还原场景
        this.panelViewModel.onSceneStartTransition(toInfo, fromInfo);
        return;
      }
    }
    homeLog.showError('session is null');
  }

  private initUiState(): void {
    if (!SCBSceneSessionManager.getInstance().isScreenLocked()) {
      this.unLockScale = UnLockConstants.MIN_SCENE_SCALE;
    }
    this.isUseThisScenePanel = true;
    this.sysSceneSession.setVisibility(true);
    this.sysSceneSession.setActive(true);
    this.sysSceneSession.visibility = true;
    this.sysSceneSession.setSessionTouchable(false);
    // init open desktop edit
    this.editModeViewEvent.editSwitchEnable = true;
    this.panelViewModel.updateScenePanelState(ScenePanelState.HOME);
  }

  private registerGestureBackEventCallback(): void {
    scbGestureManager.registerGestureEvent(GestureType.BACK, TAG, (navigationState?: number, event?: GestureEvent) => {
       this.processGestureBackEvent(GestureType.BACK, event);
      localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    })
    scbGestureManager.registerGestureEvent(GestureType.PC_BACK, TAG, (navigationState?: number, event?: GestureEvent) => {
      this.processGestureBackEvent(GestureType.PC_BACK, event);
      localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    })
    scbGestureManager.registerGestureEvent(GestureType.PC_BACK_FLOAT, TAG, (navigationState?: number, event?: GestureEvent) => {
      this.processGestureBackEvent(GestureType.PC_BACK_FLOAT, event);
      localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    })
  }

  private processGestureBackEvent(gestureType: GestureType, event?: GestureEvent) {
    // 关闭快捷键面板
    AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    this.panelViewModel.publishScenePanelEventMsg(CEManager.CUSTOM_SCENE_PANEL_EVENT, RecentEventType.GESTURE_BACK);
    switch (this.scenePanelState) {
      case ScenePanelState.RECENT: {
        homeLog.showInfo('send GestureBack to recent');
        if (SCBSceneSessionManager.getInstance()?.processSystemBackEvent(this.screenProperty.screenId)) {
          return;
        }
        SCBSceneSessionManager.getInstance()?.exitRecent(this.screenProperty.screenId);
        break;
      }
      case ScenePanelState.FULLSCENE: {
        homeLog.showInfo('send GestureBack to FULLSCENE');
        if (this.shouldSkipBackGesture() ||
            SCBSceneSessionManager.getInstance()?.processSystemBackEvent(this.screenProperty.screenId)) {
          return;
        }
        this.requestFocusForBackGestureInSplit(event as GestureEvent);
        if (gestureType !== GestureType.PC_BACK) {
          QuickSwitchRaiseTopAlarm.getInstance()
            .startImmediately(this.containerSessionList.getTopActiveSession(), 'GestureBack');
          sceneSessionManager.processBackEvent();
        }
        break;
      }
      case ScenePanelState.SPLIT: {
        homeLog.showInfo('send GestureBack to SPLIT');
        if (this.shouldSkipBackGesture() ||
            SCBSceneSessionManager.getInstance()?.processSystemBackEvent(this.screenProperty.screenId)) {
          return;
        }
        this.processBackInSplit(event);
        break;
      }
      case ScenePanelState.HOME: {
        homeLog.showInfo('send GestureBack to HOME');
        if (SCBSceneSessionManager.getInstance()?.processSystemBackEvent(this.screenProperty.screenId)) {
          return;
        }
        if (gestureType !== GestureType.PC_BACK) {
          sceneSessionManager.processBackEvent();
          let isShow = AppStorage.get('showWallpaperPage') as boolean
          if (isShow === true) {
            this.notifyApplyTheme()
          }
        }
        break;
      }
      default:
        break;
    }
  }

  notifyApplyTheme(): void {
    const option: commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE'],
      isOrdered: false,
      isSticky: true,
      parameters: {
        timestamp: Date.now()
      }
    }
    try {
      commonEventManager.publish('ts.event.theme.close', option, (error) => {});
    } catch (error) {
    }
  }

  private registerGestureNavigationEventCallback(): void {
    scbGestureManager.registerGestureEvent(GestureType.NAVIGATION, TAG, (type: GestureNavigationState, event: GestureEvent) => {
      switch (type) {
        case GestureNavigationState.START:
          TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_SWIPER_FROM_BOTTOM);
          AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
          this.isTouchableByNavBar = true;
          SCBGestureNavBarViewModel.getInstance().enableScreenRotate();
          SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange(true);
          this.panelViewModel.setScenePanelTouchableByNavigation();
          this.prepareEnterRecentViewForSplit();
          this.prepareEnterRecentViewForCompatibleMode();
          recentRuntimeInstance.navigationStartPos = [event?.fingerList[0]?.globalX, event?.fingerList[0]?.globalY];
          this.viewParam.recentPadding = 0;
          this.viewParam.recentH = this.screenProperty.height;
          this.initFsmState();
          this.panelFsm.consumeStartEvent(event);
          // ApsUtils.setApsScene(apsManager.SceneAnimation.QUICK_SWITCH, StyleConstants.DEFAULT_2);
          // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLLOW_HAND, StyleConstants.DEFAULT_1);
          RecentGestureEventManager.getInstance()
            .deliverGestureEvent(RecentGestureEvent.GESTURE_ACTION_START, this.containerSessionList.getTopActiveSession());
          break;
        case GestureNavigationState.UPDATE:
          this.panelFsm.consumeUpdateEvent(event);
          SCBGestureNavBarViewModel.getInstance().disableScreenRotate(event, this.screenProperty.height);
          break;
        case GestureNavigationState.END:
          SCBGestureNavBarViewModel.getInstance().enableScreenRotate();
          this.isTouchableByNavBar = false;
          recentRuntimeInstance.navigationEndPos = [event?.fingerList[0]?.globalX, event?.fingerList[0]?.globalY];
          this.panelFsm.consumeEndEvent(event);
          // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLLOW_HAND, StyleConstants.DEFAULT_0);
          this.panelViewModel.setScenePanelTouchableByNavigation();
          RecentGestureEventManager.getInstance()
            .deliverGestureEvent(RecentGestureEvent.GESTURE_ACTION_END, this.containerSessionList.getTopActiveSession());
          TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_SWIPER_FROM_BOTTOM);
          AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
          break;
        case GestureNavigationState.CANCEL:
          SCBGestureNavBarViewModel.getInstance().enableScreenRotate();
          this.isTouchableByNavBar = false;
          this.panelViewModel.setScenePanelTouchableByNavigation();
          recentRuntimeInstance.navigationEndPos = [event?.fingerList[0]?.globalX, event?.fingerList[0]?.globalY];
          this.panelFsm.consumeCancelEvent(event);
          RecentGestureEventManager.getInstance()
            .deliverGestureEvent(RecentGestureEvent.GESTURE_ACTION_END, this.containerSessionList.getTopActiveSession());
          // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLLOW_HAND, StyleConstants.DEFAULT_0);
          AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
          break;
        default:
          break;
      }
      gestureNavigationObserver.sendGestureNavigationEvent(type, NavigationType.GESTURE, event);
    })
  }

  private registerMultiWindowGestureNavigationCallback(): void {
    gestureNavigationObserver.registerGestureNavigationEvent(SceneCaller.MULTIWINDOW,
      (type: GestureNavigationState, event: GestureNavigationEvent) => {
        switch (type) {
          case GestureNavigationState.START:
            break;
          case GestureNavigationState.UPDATE:
            break;
          case GestureNavigationState.END:
            break;
          case GestureNavigationState.CANCEL:
            break;
          default:
            break;
        }
      })
  }

  private initFsmState(): void {
    switch (this.scenePanelState) {
      case ScenePanelState.RECENT: {
        this.panelFsm.setCurrentStateToRecent();
      }
        break;
      case ScenePanelState.FULLSCENE: {
        this.panelFsm.setCurrentStateToApp();
      }
        break;
      case ScenePanelState.HOME: {
        this.panelFsm.setCurrentStateToHome();
      }
        break;
      case ScenePanelState.SPLIT: {
        this.panelFsm.setCurrentStateToSplit();
      }
      break;
      default: {
        homeLog.showError(`${getScenePanelName(this.scenePanelState)} scene state is not implemented`);
      }
        break;
    }
    if (DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()) {
      this.panelFsm.setCurrentStateToEmergencyHome();
    }
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      this.panelFsm.setCurrentStateToOutdoor();
    }
    quickSwitchViewModel.onInit();
  }

  private prepareEnterRecentViewForSplit(): void {
    this.doBreakMaxSplitViewAnimation();
    this.panelViewModel.showWallpaperAfterRotate();
    let container = this.containerSessionList.getTopActiveSession();
    if (container === null || container === undefined || container.isSplit === false) {
      return;
    }
    if (SCBKeyboardManager.getInstance().getKeyboardSession()?.isKeyboardShowing()) {
      SCBKeyboardManager.getInstance().requestHideKeyboard(container.mainSession);
    }
    if (container.isOneStepSplit()) {
      this.virtualOnTerminate();
    }
  }

  /**
   * the function for terminating the virtual scene
   */
  private virtualOnTerminate(): void {
    let isVirtualNeedTerminate = this.panelViewModel.getIsVirtualNeedTerminate();
    let terminateParams = this.panelViewModel.getTerminateParams();
    if (isVirtualNeedTerminate && terminateParams) {
      this.panelViewModel.setIsVirtualInExitAnim(false);
      this.panelViewModel.setIsVirtualNeedTerminate(false);
      this.panelViewModel.onTerminateScene(terminateParams.persistentId, terminateParams.containerId,
        terminateParams.needRemoveSession, terminateParams.needClearData, terminateParams.shouldBackToCaller,
        terminateParams.extraInfo);
      this.panelViewModel.setTerminateParams(undefined);
    }
  }

  private prepareEnterRecentViewForCompatibleMode(): void {
    if (!SCBSceneSessionManager.getInstance().isSupportCompatibilityMode()) {
      return;
    }
    let container = this.containerSessionList.getTopActiveSession();
    if (container === null || container === undefined) {
      return;
    }
  }

  private doBreakMaxSplitViewAnimation(): void {
    // one step split view exit
    if (this.oneStepSplitExitFlag && this.oneStepSplitContainerID !== -1) {
      this.oneStepSplitExitFlag = false;
      let oneStepSplitContainerSession = this.containerSessionList.findByContainerId(this.oneStepSplitContainerID);
      if(oneStepSplitContainerSession){
        oneStepSplitContainerSession.dividerParam.init();
        oneStepSplitContainerSession?.needRenderVisibility.setVisibilityWithDfx(false,
          TAG, 'doBreakMaxSplitViewAnimation', oneStepSplitContainerSession?.getName());
        oneStepSplitContainerSession.requestBackground();
      }
      this.oneStepSplitContainerID = -1;
    }
  }

  private shouldSkipBackGesture() {
    return false;
  }

  /**
   * if focused on one of the split window will handle the back event
   * based on the back position, system will request the focus of the correct sceneSession
   * @param event
   * @param event
   * @param event event
   */
  private requestFocusForBackGestureInSplit(event?: GestureEvent): void {
    let container = this.containerSessionList.getTopActiveSession();
    if (!container) {
      winLog.showError('requestFocusForBackGestureInSplit top active containerSession is null');
      return;
    }
    if (!container.isSplit ||
        container.primarySession === null ||
        container.secondarySession === null) {
      return;
    }
    if (!(container.primarySession.getFocused() || container.secondarySession.getFocused())) {
      winLog.showInfo('requestFocusForBackGestureInSplit not focus in split');
      return;
    }
    if (!event || !event.fingerList[0]) {
      winLog.showError('requestFocusForBackGestureInSplit GestureEvent is null');
      return;
    }

    winLog.showInfo('requestFocusForBackGestureInSplit');
    let fingerInfo = event.fingerList[0];
    let persistentId: number | undefined = undefined;
    if (this.isGestureForFirstScene(fingerInfo, container.dividerParam)) {
      persistentId = container.getFirstSceneSession()?.session.persistentId;
    }

    if (persistentId === undefined) {
      persistentId = container.getSecondSceneSession()?.session.persistentId;
    }

    if (persistentId !== undefined &&
        persistentId !== SCBSceneSessionManager.getInstance().getFocusedSessionId(this.screenProperty.screenId)) {
      SCBSceneSessionManager.getInstance().requestFocus(persistentId, false, FocusChangeReason.SPLIT_SCREEN);
      winLog.showInfo(`[SCBSplit] back gesture switch focus in split session id: ${persistentId}`);
    }
  }

  private processBackInSplit(event?: GestureEvent): void {
    if (this.scenePanelState === ScenePanelState.SPLIT) {
      let containerSession = this.containerSessionList.getTopActiveSession();
      if (!containerSession || !containerSession.primarySession) {
        homeLog.showInfo(`processBackInOneStep containerSession or primarySession is null`);
        return;
      }

      // if desktop is open folder state and back gesture is right or down, close the open folder state.
      if (FolderData.getInstance().isFolderOpen()) {
        let fingerInfo = event?.fingerList[0];
        if (fingerInfo) {
          if (!this.isGestureForFirstScene(fingerInfo, containerSession.dividerParam)) {
            homeLog.showInfo(`Desktop close open folder state`);
            FolderData.getInstance().close('backGestureInOneStepSplit');
            return;
          }
        }
      }
      let id: number = containerSession.primarySession.session.persistentId;
      let sessionEventId: SCBSessionEventId = this.isNeedMaximizeSplitSceneByBackGesture(event);
      if (sessionEventId === SCBSessionEventId.EVENT_MAXIMIZE) {
        winLog.showInfo(`[SCBSplit] back gesture maximize onestep split to full session: ${id}`);
        this.onMaximizeSplitScene(containerSession.primarySession.session?.persistentId, containerSession.containerId);
      } else if (sessionEventId === SCBSessionEventId.EVENT_MINIMIZE) {
        winLog.showInfo(`[SCBSplit] back gesture minimize onestep split session: ${id}`);
        this.panelViewModel.oneStepSplitExit(containerSession, true);
      } else {
        homeLog.showInfo(`processBackInOneStep do nothing with gesture event:${JSON.stringify(event)}`);
      }
    }
  }

  // return true when left in horizontal or up in vertical
  private isGestureForFirstScene(fingerInfo: FingerInfo, dividerParam: SCBDividerParam) {
    if (dividerParam.isUpDownSplit()) {
      let firstPosY = dividerParam.splitOrderIsNotReverse ? dividerParam.getPriPosYPct() : dividerParam.getSecPosYPct();
      let firstSceneEndY = (dividerParam.statusBarPct + firstPosY + dividerParam.getFirstScenePct()) *
        px2vp(this.screenProperty.height);
      return fingerInfo.globalY < firstSceneEndY;
    } else {
      // fingerInfo.localX > 0 means left back, otherwise right back
      return fingerInfo.localX > 0;
    }
  }

  private isNeedMaximizeSplitSceneByBackGesture(event?: GestureEvent): SCBSessionEventId {
    if (!event || !event.fingerList[0]) {
      homeLog.showInfo('GestureEvent is null, maximize split panel by default');
      return SCBSessionEventId.EVENT_MAXIMIZE;
    }
    let sceneContainerSession = this.containerSessionList.getTopActiveSession();
    // only to deal with one step split scene
    if (!sceneContainerSession || !sceneContainerSession.isOneStepSplit()) {
      return SCBSessionEventId.EVENT_UNDEFINED;
    }

    let fingerInfo = event.fingerList[0];
    homeLog.showInfo(`isNeedMaximizeSplitSceneByBackGesture fingerInfo globalX:${fingerInfo.globalX}, globalY:${fingerInfo.globalY}, localX:${fingerInfo.localX}, localY:${fingerInfo.localY}`);
    if (this.isGestureForFirstScene(fingerInfo, sceneContainerSession.dividerParam)) {
      return SCBSessionEventId.EVENT_MINIMIZE;
    } else {
      return SCBSessionEventId.EVENT_MAXIMIZE;
    }
  }

  /**
   * support auto test pressHome key event
   */
  private onHomeKeyInput(): void {
    if (!scbGestureManager.isGestureEnable()) {
      homeLog.showInfo('onHomeKeyInput ignore, gesture navigation not enable.');
      return;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_NAVBAR)) {
      scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_NAVBAR);
      recentLog.showInfo('onHomeKeyInput ignore,GESTURE_NAVBAR is exclusive');
      return;
    }
    // 显示壁纸，避免桌面黑屏
    this.panelViewModel.showWallpaperAfterRotate();
    gestureNavigationObserver.sendGestureNavigationEvent(GestureNavigationState.START, NavigationType.FLOATING);
    gestureNavigationObserver.sendGestureNavigationEvent(GestureNavigationState.END, NavigationType.FLOATING);
    // 关闭快捷键面板
    AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    quickSwitchRequestActiveAlarm.onAlarm();
    switch (this.scenePanelState) {
      case ScenePanelState.RECENT: {
        homeLog.showInfo('onHomeKeyInput to recent');
        if (SCBSceneSessionManager.getInstance()?.processSystemHomeEvent(this.screenProperty.screenId)) {
          return;
        }
        this.recentIdleCallback.toHomeIdle();
        this.panelFsm.setCurrentStateToHome();
        break;
      }
      case ScenePanelState.FULLSCENE: {
        homeLog.showInfo('onHomeKeyInput to FULLSCENE');
        if (SCBSceneSessionManager.getInstance()?.processSystemHomeEvent(this.screenProperty.screenId)) {
          return;
        }
        DeliverUtil.closeSystemWindows();
        this.prepareEnterRecentViewForSplit();
        this.zoomFollowingFromAppCallback.enterHomeIdle(0, 0);
        this.panelFsm.setCurrentStateToHome();
        break;
      }
      case ScenePanelState.HOME: {
        homeLog.showInfo('onHomeKeyInput to HOME');
        this.homeIdleCallback.enterHomeIdle();
        break;
      }
      default:
        break;
    }
  }

  private onRecentKeyInput(): void {
    if (!scbGestureManager.isGestureEnable()) {
      homeLog.showInfo('onRecentKeyInput ignore, gesture navigation not enable.');
      return;
    }
    // 多任务跟手状态和上划删除状态下 屏蔽多任务按键响应
    if (this.panelFsm.isFollowingState()) {
      homeLog.showInfo('onRecentKeyInput ignore, isFollowingState.');
      return;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_NAVBAR)) {
      scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_NAVBAR);
      recentLog.showInfo('onRecentKeyInput ignore,GESTURE_NAVBAR is exclusive');
      return;
    }
    if (DeviceHelper.isPad()) {
      AppStorage.setOrCreate('selectedIndex', -1);
      AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    }
    gestureNavigationObserver.sendGestureNavigationEvent(GestureNavigationState.START, NavigationType.FLOATING);
    gestureNavigationObserver.sendGestureNavigationEvent(GestureNavigationState.END, NavigationType.FLOATING);
    quickSwitchRequestActiveAlarm.onAlarm();
    switch (this.scenePanelState) {
      case ScenePanelState.RECENT: {
        recentLog.showInfo('onRecentKeyInput to recent');
        let focusedSessionId = SCBSceneSessionManager.getInstance().getFocusedSessionId(this.screenProperty.screenId);
        let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(focusedSessionId);
        if (sysSceneSession && sysSceneSession.name.includes('SCBDropdownPanel') &&
          sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_PANEL) {
          // 双中心下拉状态，执行退出双中心
          SCBSceneSessionManager.getInstance().processSystemRecentEvent(this.screenProperty.screenId);
        } else {
          // 多任务状态，执行退出多任务
          this.recentIdleCallback.toHomeIdle();
          this.panelFsm.setCurrentStateToHome();
        }
        break;
      }
      case ScenePanelState.FULLSCENE: {
        recentLog.showInfo('onRecentKeyInput to FULLSCENE');
        DeliverUtil.closeSystemWindows();
        this.panelMgr.setSceneContainerSessionListForView(this.containerSessionList.filterClone());
        ViewManagerPolicy.showView(ViewType.WALLPAPER);
        this.prepareEnterRecentViewForSplit();
        this.recentFollowFromAppCallback.enterRecentIdle(0, 0, false);
        this.panelFsm.setCurrentStateToRecent();
        break;
      }
      case ScenePanelState.HOME: {
        this.inputRecentKeyFromHome();
        break;
      }
      default:
        break;
    }
  }

  private onEscKeyInput(): void {
    if (!scbGestureManager.isGestureEnable()) {
      homeLog.showInfo('onEscKeyInput ignore, gesture navigation not enable.');
      return;
    }
    if (this.panelViewModel.isRecentState()) {
      this.panelViewModel.exitRecentAndNotifyFloat();
    }
  }

  private inputRecentKeyFromHome(): void {
    // 目前仅模拟器场景涉及，后续考虑影响是否涉及三键导航
    localEventManager.sendLocalEvent(EventConstants.EVENT_FLOAT_ON_FOCUS);
    SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    // 进入多任务打断文件夹退出动效
    if (FolderManager.getInstance().isFolderClosing()) {
      ContractedFolderCommonViewModel.getInstance()
        .closeFolder('homeIdle gesture start', FolderOperationFlag.IMMEDIATELY);
    }
    this.isSupportMaximizeScene = false;
    this.isShowCompanionIcon = false;
    this.panelFsm.getRecentController().removePendingSessionIfNeed();
    let session = this.containerSessionList.getTopSession();
    this.recentNotShow.notShowSessionDestroy(session, this.totalContainerSessionList);
    this.recentEnter.initSessionListLength();
    this.panelMgr.setSceneContainerSessionListForView(this.containerSessionList.filterClone());
    this.overViewFollowingFromHomeCallback.enterRecentIdle(0, 0, false);
    this.panelFsm.setCurrentStateToRecent();
  }

  private setSelectItem(): void {
    const recentSessions = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (recentSessions === undefined || (recentSessions !== undefined && recentSessions.length === 0)) {
      return;
    }
    if (this.selectedIndex >= 0 && this.selectedIndex <= recentSessions.length - 1) {
      let selectedIndex: number = recentSessions.length - 1 - this.selectedIndex
      const currentSessionId: number | undefined = recentSessions[selectedIndex].primarySession?.session.persistentId;
      for (let element of this.containerSessionList) {
        if (element.primarySession?.session.persistentId === currentSessionId) {
          element.tabSelected = true;
          AppStorage.setOrCreate('recentSelectedItem', element);
        } else {
          element.tabSelected = false;
        }
      }
      recentLog.showInfo(`setSelectItem oldSelectedIndex=${this.oldSelectedIndex} selectedIndex=${selectedIndex}`);
      this.oldSelectedIndex = selectedIndex;
    }
  }

  private initTabStatus(): void {
    for (let session of this.containerSessionList) {
      session.tabSelected = false;
    }
  }

  private async updateIndex(): Promise<void> {
    if (!this.checkIsUseThisScenePanel()) {
      homeLog.showInfo('current scene panel is not use, no need response updateIndex');
      return;
    }
    recentLog.showInfo(`updateIndex:` + this.selectedIndex);
    const recentSessions = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (recentSessions === undefined || (recentSessions !== undefined && recentSessions.length === 0)) {
      recentLog.showWarn(`recentSessions is empty`);
      return;
    }
    if (this.selectedIndex === INVALID_INDEX || (this.selectedIndex > recentSessions.length - 1)) {
      if (this.selectedIndex === INVALID_INDEX) {
        this.initTabStatus();
      }
      if (this.oldSelectedIndex >= 0 && this.oldSelectedIndex <= this.containerSessionList.length - 1) {
        this.containerSessionList[this.oldSelectedIndex].tabSelected = false;
      }
      this.oldSelectedIndex = INVALID_INDEX;
      return;
    }
    this.setSelectItem();
    const sessionLength = this.containerSessionList?.length;
    const selectedIndex = recentSessions.length - 1 - this.selectedIndex;
    const cardWidth = RecentLayoutManager.getCardWidth(this.screenProperty);
    const recentScale = RecentLayoutManager.getScale(this.screenProperty);
    const recentMargin = RecentLayoutManager.getWidthSpace();
    const screenWidth = px2vp(this.screenProperty.width);
    const ignoreColumn = Math.floor((screenWidth - recentMargin) / (cardWidth + recentMargin));

    let totalColumn = this.isNeedChangeToMultiRow ?
      RecentLayoutManager.getColumnInMultiRow(sessionLength - 1, sessionLength) : sessionLength - 1;
    let columnIndex = this.isNeedChangeToMultiRow ?
      RecentLayoutManager.getColumnInMultiRow(selectedIndex, sessionLength) : sessionLength - 1;

    const commonDiff = cardWidth - (screenWidth - cardWidth) / 2 + 2 * recentMargin;
    const finalOffsetX = totalColumn <= 1 ? commonDiff : commonDiff + (totalColumn - 1) * (cardWidth + recentMargin);

    let offset: number = 0;
    if ((totalColumn - columnIndex) >= ignoreColumn) {
      offset = (totalColumn - columnIndex + 1) * (recentMargin + cardWidth) + recentMargin - screenWidth;
    }
    const offsetX = finalOffsetX - offset;
    recentLog.showInfo(`offsetX=${offsetX} offset=${offset} finalOffsetX=${finalOffsetX} totalColumn=${totalColumn}
     columnIndex=${columnIndex} ignoreColumn=${ignoreColumn}`)
    this.recentScroll.scrollTo({ xOffset: offsetX, yOffset: 0, animation: { curve: Curve.Smooth } });
    return;
  }

  private updateRecent(): void {
    if (!this.checkIsUseThisScenePanel()) {
      homeLog.showInfo('current scene panel is not use, no need response updateRecent');
      return;
    }
    const topSession: SCBSceneSession | null | undefined = this.containerSessionList.getTopSession()?.primarySession;
    if (topSession?.isFocused && topSession?.isSessionMoving) {
      this.showRecent = false;
      return;
    }
    if (this.scenePanelState == ScenePanelState.RECENT && !this.showRecent) {
      this.recentIdleCallback.toHomeIdle();
    } else if (this.scenePanelState !== ScenePanelState.RECENT && this.showRecent) {
      this.onRecentKeyInput();
    } else {
      recentLog.showInfo(`do nothing in scenePanelState:${this.scenePanelState} showRecent:${this.showRecent}`);
    }
  }

  private registerUnlockTransitionController(): void {
    this.unLockTransitionController = {
      name: `${TAG}`,
      onLock: (): void => this.onLockReceived(),
      onUnlock: (): void => this.onUnLockReceived(),
      onUnlockAnimation: (): void => this.onUnlockAnimationReceived()
    }
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  aboutToDisappear(): void {
    this.doReport = false;
    if (TouchBoardGestureManager.isSupportTouchBoardGestureFeature() || DeviceHelper.isThreeFoldProduct()) {
      TouchBoardGestureManager.getInstance().unRegisterThreeFingerSwipeCallback(this.threeFingerSwiperCallback);
      this.swipeController = null;
    }
    SCBSceneMissionManager.getInstance().unregisterProductMissionProcessor();
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    SCBKeyboardManager.getInstance().unRegisterKeyboardShowCallback(this.keyboardShowCallback);
    SCBKeyboardManager.getInstance().unRegisterkeyboardRectChangeCallbacks(this.keyboardRectChangeCallback);
    scbGestureManager.unRegisterGestureEvent(GestureType.NAVIGATION, TAG);
    scbGestureManager.unRegisterGestureEvent(GestureType.BACK, TAG);
    scbGestureManager.unregisterPcKeyCallback(TAG);
    InputConsumer.off('key', this.homeKeyOption);
    this.debugCommands.unregister();
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.sysSceneSession);
    this.destroyBlurSceneSession();
    this.evtMgr.offAll();
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.APPEXIT_LANDSCAPE);
    recentDisplayManager.onDestroy();
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.transparentSceneSession);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, this.clearMemoryCallback);
    SCBSceneSessionManager.getInstance().unRegisterRecentClearAllAnimCntCallback();
    SCBScreenSessionManager.getInstance().unRegisterWrapRotateEntryCallback(this.wrapRotationEntryCallback, this.screenProperty.screenId);
    this.panelViewModel.release();
    AnimPolicyRegistry.unregisterRssCallback();
    // 侧边栏需要全局注册监听应用启动数据
    GestureDockPreferenceMgr.getInstance().unregisterSceneStateChangeCallback();
    RecentGestureEventManager.getInstance().unregisterSceneStateChangeCallback();
    SCBSceneSessionManager.getInstance().unRegisterStartFloatFromUnlockCallback();
    this.panelViewModel.laterReleaseOnPanelDisappear();
  }

  private onUnLockReceived(): void {
    // 蒙层维侧日志
    homeLog.showInfo(`onUnLockReceived, scenePanelState: ${this.scenePanelState} isShowGlobalSearch: ${sOutSideWindowMgr.isShowGlobalSearch()} isShowNagativeScene: ${ViewManagerPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN)}`);
    let currContainerSession = this.containerSessionList.getTopActiveSession();
    if (currContainerSession?.isSplitView() && currContainerSession.hasFixedMultiWindowOrientationSession()) {
      this.panelViewModel.exitSplitViewInFixedMultiWindowOrientation(currContainerSession.primarySession?.sceneInfo.persistentId,
        currContainerSession.containerId);
    }
    if (this.needRestoreHideDesktop) {
      this.needRestoreHideDesktop = false;
      ViewManagerPolicy.hideView(ViewType.DESKTOP);
    }
    if (this.needRestoreHideWallpaper) {
      this.needRestoreHideWallpaper = false;
      ViewManagerPolicy.hideView(ViewType.WALLPAPER);
    }
    if (this.scenePanelState !== ScenePanelState.FULLSCENE && !sOutSideWindowMgr.isShowGlobalSearch()
      && !ViewManagerPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN)) {
      SCBTransitionManager.getInstance().onUnlockTransitionEnterHome();
      this.unLockScale = UnLockConstants.MIN_SCENE_SCALE;
      // 兜底：确保桌面和壁纸显示
      winLog.showInfo(`[UnlockDebug] onUnLockReceived force show desktop and wallpaper`);
      this.showDesktopIfNeed('unlockToHome');
      this.showWallpaperIfNeed('unlockToHome');
      // if horizontal above keyguard, unlock with current this.screenProperty
      homeLog.showDebug('onUnLockReceived screenProperty: ' + JSON.stringify(this.screenProperty));
      return;
    }
    let isHDRSetClose: boolean = SlVisualConfigManager.getInstance().getEnable(CcmOption.HDR);
    homeLog.showInfo(`isHDRSetClose: ${isHDRSetClose}`);
    if (isHDRSetClose) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(true);
    }
    // if horizontal above keyguard, unlock with current this.screenProperty
    // rotation maintenance log
    homeLog.showInfo('onUnLockReceived screenProperty: ' + JSON.stringify(this.screenProperty) +
      ' viewParam: ' + JSON.stringify(this.viewParam));
  }

  private onLockReceived() {
    homeLog.showInfo('onLockReceived scenePanelState = ' + this.scenePanelState);
    if (!ViewManagerPolicy.isViewShowing(ViewType.DESKTOP)) {
      this.needRestoreHideDesktop = true;
      ViewManagerPolicy.showView(ViewType.DESKTOP);
    }
    if (!ViewManagerPolicy.isViewShowing(ViewType.WALLPAPER)) {
      this.needRestoreHideWallpaper = true;
      ViewManagerPolicy.showView(ViewType.WALLPAPER);
    }
    quickSwitchRequestActiveAlarm.onAlarm();
    FloatingNavigationManager.getInstance()?.setIsScreenLock(true);
    let currContainerSession = this.containerSessionList.getTopActiveSession();
    this.lockPrepareForSplit();
    if (this.scenePanelState !== ScenePanelState.FULLSCENE && !sOutSideWindowMgr.isShowGlobalSearch()
      && !ViewManagerPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN)) {
      SCBTransitionManager.getInstance().onLockTransitionEnterHome();
    }
    if (this.panelViewModel.isRecentState() || this.panelViewModel.isQuickSwitchState()) {
      SCBSceneSessionManager.getInstance().callRecentFuncs(false);
      if (!currContainerSession) {
        this.panelViewModel.enterFullSceneOrHomeView(ScenePanelState.HOME)
        this.mViewManager.closeOpenFolderStatus();
      } else {
        this.panelViewModel.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE)
        let persistentId = currContainerSession.mainSession.sceneInfo.persistentId;
      }
      recentViewModel.onLockReceived();
    }
    if (this.panelViewModel.isFullSceneState() && !this.containerSessionList.getTopActiveSession()?.isShowWhenLocked()) {
      this.unLockScale = UnLockConstants.MAX_SCENE_SCALE;
      let currContainerSession = this.containerSessionList.getTopActiveSession();
      let scaleY = currContainerSession?.needRenderScale?.scaleY ?? 1.0;
      if (scaleY < 1.0) {
        homeLog.showInfo('onLockReceived isFullSceneState scaleY: %{public}d', scaleY);
        this.panelViewModel.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE)
      }
    }
    if (this.isTouchableByNavBar) {
      this.isTouchableByNavBar = false;
      this.panelViewModel.setScenePanelTouchableByNavigation();
      this.panelFsm?.setCurrentStateToScreenLock();
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.EXIT_MULTIPLE_TASKBARS, StyleConstants.DEFAULT_1);
    QuickSwitchRaiseTopAlarm.getInstance()
      .startImmediately(this.containerSessionList.getTopActiveSession(), 'screen lock');
  }

  private lockPrepareForSplit(): void {
    winLog.showInfo(`[SCBSplit] lockPrepareForSplit`);
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession === null || topContainerSession === undefined || topContainerSession.isSplit === false) {
      return;
    }
    //one step
    if (this.scenePanelState !== ScenePanelState.SPLIT) {
      return;
    }
    if (topContainerSession && topContainerSession.primarySession) {
      topContainerSession.splitParam.setLifeCycle(SplitLifeCycle.EXIT_ONESTEP_TO_FUSCREEN);
      this.panelViewModel.oneStepSplitToFullScene(topContainerSession.primarySession.session.persistentId, topContainerSession, false);
    }
  }

  private onUnlockAnimationReceived(): void {
    homeLog.showInfo(`onUnlockAnimationReceived, scenePanelState: ${this.scenePanelState}`);
    let isHDRSetClose: boolean = SlVisualConfigManager.getInstance().getEnable(CcmOption.HDR);
    homeLog.showInfo(`isHDRSetClose: ${isHDRSetClose}`);
    animateToImmediately({
      curve: curves.springMotion(UnLockConstants.UNLOCK_TRANSITION_RESPONSE, UnLockConstants.UNLOCK_TRANSITION_FRACTION),
      onFinish: () => {
        if (isHDRSetClose) {
          SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
        }
      }
    }, () => {
      this.unLockScale = UnLockConstants.MIN_SCENE_SCALE;
    })
  }


  private resetParamForClearAllOnFinish(animationCount: number, sceneContainerSession: SCBSceneContainerSession): void {
    if (this.clearAllAnimCnt !== 0) {
      return;
    }
    recentLog.info(`clear all finish.`);
    this.filterUnClearAbleSessions();
    RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.CLEAR_ALL_MISSIONS_END);
    this.panelViewModel.exitSceneWithRotationRecover(sceneContainerSession);
    this.recentClearAll.clearRecentListIfNeed(animationCount, sceneContainerSession);
  }

  // private unclearableContainerDisappearForClearAll(sceneContainerSession: SCBSceneContainerSession, index: number,
  //   isDelayUnClearableAnimate: boolean): void {
  private unclearableContainerDisappearForClearAll(sceneContainerSession: SCBSceneContainerSession,
    index: number): void {
    if (!sceneContainerSession) {
      return;
    }
    let animationCount = sceneContainerSession.getTransitionCount();
    sceneContainerSession.requestBackground();
    // let param: AnimateParam = {
    //   curve: Curve.FastOutLinearIn,
    //   delay: 150,
    //   duration: 350,
    //   onFinish: () => {
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'playUnclearAbleAnimation',
      sceneContainerSession.getName());
    recentLog.info(`doSceneSessionDisappear ${sceneContainerSession.getName()} ${this.clearAllAnimCnt}`);
    if (animationCount === sceneContainerSession.getTransitionCount()) {
      sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG,
        'playUnclearAbleAnimation');
    }
    if (index === SCBSessionShowInScreenIndex.INDEX_RIGHT) {
      this.recentGesture.containerUnsinking(sceneContainerSession);
    }
    this.recentDelete.showClearAllMissionsToast(index);
    //   },
    // }
    // if (isDelayUnClearableAnimate) {
    //   param.delay = 450;
    // }
    // animateToImmediately(param, () => {
    //   sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'playUnclearAbleAnimation',
    //     sceneContainerSession.getName());
    // })
  }

  // private clearableContainerDisappearForClearAll(sceneContainerSession: SCBSceneContainerSession, delay: number,
  //   index: number): void {
  private clearableContainerDisappearForClearAll(sceneContainerSession: SCBSceneContainerSession,
    index: number): void {
    this.recentClearAll.containerDestructionForClearAll(sceneContainerSession);
    sceneContainerSession.addTransitionCount();
    if (sceneContainerSession.isFloat) {
      sceneContainerSession.floatingParam.floatRecentAnimateFinished = true;
      sceneContainerSession.floatingParam.floatInRecentFinished = true;
    }

    // let animationCount = sceneContainerSession.getTransitionCount();
    // animateToImmediately({
    //   curve: Curve.FastOutLinearIn,
    //   delay: delay,
    //   duration: 350,
    //   onFinish: () => {
    // performanceMonitor.end(HiSysEventUtil.CLEAR_All_RECENT_ANI);
    // this.clearAllAnimCnt--;
    recentLog.info(`doSceneSessionDisappear ${sceneContainerSession.getName()} ${this.clearAllAnimCnt}`);
    this.panelMgr.removeSceneContainerSession(sceneContainerSession);
    this.panelMgr.removeFloatSceneContainerSession(sceneContainerSession);
    this.recentDelete.showClearAllMissionsToast(index);
    // this.resetParamForClearAllOnFinish(animationCount, sceneContainerSession);
    //   },
    // }, () => {
    //   sceneContainerSession.needRenderRotate.setAngle(-90);
    // })
    // RecentTitleViewModel.playTitleDisAppearAnimation(sceneContainerSession);
    sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
  }

  // private doSceneSessionDisappearFromRecentAnimation(delay: number, sceneContainerSession: SCBSceneContainerSession,
  //   index: SCBSessionShowInScreenIndex): void {
  private doSceneSessionDisappearFromRecentAnimation(sceneContainerSession: SCBSceneContainerSession,
    index: SCBSessionShowInScreenIndex): void {
    // animation not need calc icon pos with rotation, thus can clear session data before animation
    // set true for clear session flag if the destruction operation is from recent view
    let unclearAble = this.recentDelete.isUnclearAbleWhenClearAll(sceneContainerSession);
    this.clearAllAnimCnt ++;
    this.isStartClearAll = true;
    recentLog.info(`doSceneSessionDisappear ${sceneContainerSession.getName()} ${this.clearAllAnimCnt}`);
    // 可删除卡片动效
    if (!unclearAble) {
      // this.clearableContainerDisappearForClearAll(sceneContainerSession, delay, index);
      this.clearableContainerDisappearForClearAll(sceneContainerSession, index);
      return;
    }

    // let isDelayUnClearableAnimate = RecentLockIconModel.isDelayUnClearableAnimate(this.recentGesture) &&
    //   this.clearAllAnimCnt > 0;
    if (!sceneContainerSession.isFloat) {
      // this.unclearableContainerDisappearForClearAll(sceneContainerSession, index, isDelayUnClearableAnimate);
      this.unclearableContainerDisappearForClearAll(sceneContainerSession, index);
    } else {
      this.floatToFullWhenUnclearAble(sceneContainerSession, index);
    }
    this.recentClearAll.resetIsKillParam(sceneContainerSession);
    // this.recentClearAll.titleDisappearAnimationForUnClearable(sceneContainerSession, this.uiContext,
    //   isDelayUnClearableAnimate);
    this.recentClearAll.titleDisappearAnimationForUnClearable(sceneContainerSession);
    HiSysEventUtil.reportClearSingleAppInRecent(sceneContainerSession.companionIconInfo?.bundleName, false);
  }

  private floatToFullWhenUnclearAble(sceneContainerSession: SCBSceneContainerSession,
    index: SCBSessionShowInScreenIndex): void {
    homeLog.showInfo(`floatToFullWhenUnclearAble, name: ${sceneContainerSession.getName()}`);
    sceneContainerSession.requestBackground();
    sceneContainerSession.isDisappearing = true;
    // let isDelayUnClearableAnimate = RecentLockIconModel.isDelayUnClearableAnimate(this.recentGesture) &&
    //   this.clearAllAnimCnt > 0;
    sceneContainerSession.isFloatView = true;
    let floatingParam = sceneContainerSession.floatingParam;
    floatingParam.isClosingFloat = true;
    floatingParam.minAnimationNum++;
    let animationCount = sceneContainerSession.getTransitionCount();
    // let param: AnimateParam = {
    //   curve: Curve.FastOutLinearIn,
    //   delay: 150,
    //   duration: 350,
    //   onFinish: () => {
    sceneContainerSession.updateScaleForFloat(1);
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'playUnclearAbleAnimation',
      sceneContainerSession.getName());
    recentLog.info(`floatToFullWhenUnclearAble ${sceneContainerSession.getName()} ${this.clearAllAnimCnt}`);
    sceneContainerSession.isDisappearing = false;
    this.recentDelete.showClearAllMissionsToast(index);
    //   },
    // }
    // if (isDelayUnClearableAnimate) {
    //   param.delay = 450;
    // }
    // animateToImmediately(param, () => {
    //   sceneContainerSession.updateScaleForFloat(1);
    //   sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'playUnclearAbleAnimation',
    //     sceneContainerSession.getName());
    // })
  }

  private initFloatingWhenClearAll(container: SCBSceneContainerSession): void {
    if (container && container.isFloat && this.recentDelete.isUnclearAbleWhenClearAll(container)) {
      container.updateScaleForFloat(1);
      container.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'initFloatingWhenClearAll',
        container.getName());
      container.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'initFloatingWhenClearAll');
      container.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'initFloatingWhenClearAll');
      container.floatingParam.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'initFloatingWhenClearAll');
      container.floatingParam.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'initFloatingWhenClearAll');
      container.floatingParam.floatInRecentFinished = false;
      container.floatingParam.floatRecentAnimateFinished = true;
      container.floatingParam.isClosingFloat = false;
      container.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'initFloatingWhenClearAll');
      container.requestBackground();
      container.floatingParam.needFloatScale = true;
    }
  }

  updateScenePanelStateInPadPrepareClearAll(state: ScenePanelState, blurAnimDelayTime?: number): void {
    if (this.scenePanelState === state) {
      return;
    }
    this.panelViewModel.updatePanelStateInner(state);
    launcherVisualEffectMgr.exitBlurWithLauncherOpAnim(blurAnimDelayTime);
    this.panelViewModel.showWallpaperAfterRotate(!launcherVisualEffectMgr.isRecentBlurEffectDisabled());
    this.startBlurAnimInPadPrepareClearAll();
    this.panelViewModel.updateScenePanelByState(state);
  }

  private startBlurAnimInPadPrepareClearAll(): void {
    animateTo({
      curve: curves.springMotion(0.45, 1, 0),
      onFinish: () => {
        this.panelMgr.disableBlurComponent('startBlurAnimInPadPrepareClearAll');
      }
    }, () => {
      homeLog.showDebug('startBlurAnimInPadPrepareClearAll');
      this.panelMgr.onBlurTransitionInactive();
    })
  }

  private backToHomAfterClearAll(blurAnimDelayTime?: number) {
    // let delayTime = RecentLockIconModel.isDelayUnClearableAnimate(this.recentGesture) &&
    //   this.isStartClearAll ? 450 : 0;
    // this.panelViewModel.updateScenePanelState(ScenePanelState.HOME, false, delayTime, blurAnimDelayTime);
    this.panelViewModel.finishClearAllToHome();
    this.recentInnerState.onInit();
    this.isStartClearAll = false;
    HiSysEventUtil.reportClearAllAppInRecent(this.recentDelete.getUnClearAbleBundleNameList(
      this.totalContainerSessionList));
  }


  private clearRecentMissionsWithAnimation(): void {
    // 监听退出多任务列表
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'clearRecentMissionsWithAnimation', true, expandStatus);
    let notRemovingSessionLength = recentRuntimeInstance.notRemovingSessionList.filterClone().length;
    if (notRemovingSessionLength < 1) {
      recentLog.info(`clearRecentMissions back to home`);
      this.backToHomAfterClearAll();
      // this.panelViewModel.startBlurAnimationForContainer(0);
      this.recentDelete.showStatusBarIfNeedOnfinish(this.scenePanelState, 1);
      // 删除不显示多任务的container
      this.recentDelete.destructContaierInNotShow();
      return;
    }
    recentLog.info(`transparentView is show to ignore click`);
    this.needTransparentSession = true;
    this.panelViewModel.publishScenePanelEventMsg(CEManager.CUSTOM_RECENT_EVENT, RecentEventType.RECENT_CLEAR_ALL);
    let screenWidth = px2vp(this.screenProperty.width);
    let screenHeight = px2vp(this.screenProperty.height);
    let curIndex = recentRuntimeInstance.autoCenterColumn;
    // let delay: number = 0;
    let rightIndex: number = recentRuntimeInstance.getSafeIndex(curIndex + 1);
    let leftIndex: number = recentRuntimeInstance.getSafeIndex(curIndex - 1);
    let cloneList = recentRuntimeInstance.notRemovingSessionList.filterClone();
    let inScreenContainer = new SCBSceneContainerSessionArray();
    let offScreenSessions = new SCBSceneContainerSessionArray();
    homeLog.info(`clearRecentMissions index: ${curIndex} ${rightIndex} ${leftIndex} ${notRemovingSessionLength}`);
    performanceMonitor.begin(HiSysEventUtil.CLEAR_All_RECENT_ANI, performanceMonitor.ActionType.LAST_UP);
    MemoryManager.getInstance().updateStaticMemoryScene();
    this.panelViewModel.updateScreenRotationPropertyForExit();
    RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.CLEAR_ALL_MISSIONS_START);
    // 设置notremovingList中container是否被强杀，写入到isKillForClearAll中
    this.recentClearAll.setIsForceCleanForContainer(cloneList);

    if (!this.isNeedChangeToMultiRow) {
      // 屏幕内 的卡片的处理逻辑
      if (rightIndex !== curIndex) {
        let rightSession = cloneList[rightIndex];
        if (rightSession) {
          this.recentGesture.containerSinking(rightIndex);
          let centerX = this.recentGesture.calculateCenterX(rightIndex);
          rightSession.needRenderRotate.setCenterX(centerX);
          // this.doSceneSessionDisappearFromRecentAnimation(delay, rightSession, SCBSessionShowInScreenIndex.INDEX_RIGHT);
          this.doSceneSessionDisappearFromRecentAnimation(rightSession, SCBSessionShowInScreenIndex.INDEX_RIGHT);
          inScreenContainer.push(rightSession);
          // delay += 50;
        }
      }

      let curSession = cloneList[curIndex];
      if (curSession) {
        curSession.needRenderRotate.setCenterX(screenWidth / 2);
        // this.doSceneSessionDisappearFromRecentAnimation(delay, curSession, SCBSessionShowInScreenIndex.INDEX_MIDDLE);
        this.doSceneSessionDisappearFromRecentAnimation(curSession, SCBSessionShowInScreenIndex.INDEX_MIDDLE);
        inScreenContainer.push(curSession);
        // delay += 50;
      }

      if (leftIndex !== curIndex) {
        let leftSession = cloneList[leftIndex];
        if (leftSession) {
          let centerX = this.recentGesture.calculateCenterX(leftIndex);
          leftSession.needRenderRotate.setCenterX(centerX);
          // this.doSceneSessionDisappearFromRecentAnimation(delay, leftSession, SCBSessionShowInScreenIndex.INDEX_LEFT);
          this.doSceneSessionDisappearFromRecentAnimation(leftSession, SCBSessionShowInScreenIndex.INDEX_LEFT);
          inScreenContainer.push(leftSession);
        }
      }
      // 由于scroll的改变，屏幕的卡片需要重新设置新scroll下的pos
      this.recentClearAll.setInScreenConatinerPos(inScreenContainer, this.recentScroll.currentOffsetX);

      // 屏幕外卡片的处理逻辑
      let screenIndex = [leftIndex, curIndex, rightIndex];
      offScreenSessions = this.recentClearAll.getOffScreenSession(screenIndex, cloneList);
      // 内屏条件下 屏幕外卡片的 删除和销毁逻辑，当前悬浮窗和全屏卡片删除销毁已统一
      this.recentClearAll.removeAndDestructOffScreenSessions(offScreenSessions, this.recentClearAllCallback);

      // 单行 一键删除的 不显示多任务卡片 删除和销毁
      this.recentDelete.destructContaierInNotShow();
    } else {
      this.recentGesture.initGestureValue(notRemovingSessionLength, curIndex, this.recentScroll.currentOffsetX);
      let multiCol: number = this.recentGesture.multiColumnNum;
      let midIndex: number = this.recentGesture.middleColumnIndex;
      leftIndex = this.recentGesture.leftColumnIndex;
      rightIndex = this.recentGesture.rightColumnIndex;
      let leftSessions = new SCBSceneContainerSessionArray();
      let midSessions = new SCBSceneContainerSessionArray();
      let rightSessions = new SCBSceneContainerSessionArray();
      let screenSessionIdx: number[] = [];

      // 屏幕内 的卡片的处理逻辑
      for (let i = 0; i < notRemovingSessionLength; i++) {
        let container = recentRuntimeInstance.notRemovingSessionList[i];
        if (!container) {
          continue;
        }
        let colIndex = multiCol - 1 - (Math.floor((notRemovingSessionLength - 1 - i) / 2));
        if (colIndex === leftIndex) {
          leftSessions.push(container);
          inScreenContainer.push(container);
          screenSessionIdx.push(i);
        } else if (colIndex === midIndex) {
          midSessions.push(container);
          inScreenContainer.push(container);
          screenSessionIdx.push(i);
        } else if (colIndex === rightIndex) {
          rightSessions.push(container);
          inScreenContainer.push(container);
          screenSessionIdx.push(i);
        } else {
          offScreenSessions.push(container);
          continue;
        }
        let rowIndex = (notRemovingSessionLength - 1 - i) % 2;
        if (rowIndex === 0) {
          container.needRenderRotate.setCenterY(screenHeight * 3 / 4);
        } else {
          container.needRenderRotate.setCenterY(screenHeight * 1 / 4);
        }
      }

      // 双行 一键删除的 不显示多任务卡片 删除和销毁
      this.recentDelete.destructContaierInNotShow();

      // delay = 100;
      for (let rightSession of rightSessions) {
        rightSession.needRenderRotate.setCenterX('50%');
        // this.doSceneSessionDisappearFromRecentAnimation(delay, rightSession, SCBSessionShowInScreenIndex.INDEX_RIGHT);
        this.doSceneSessionDisappearFromRecentAnimation(rightSession, SCBSessionShowInScreenIndex.INDEX_RIGHT);
      }
      for (let midSession of midSessions) {
        midSession.needRenderRotate.setCenterX('50%');
        // this.doSceneSessionDisappearFromRecentAnimation(delay, midSession, SCBSessionShowInScreenIndex.INDEX_MIDDLE);
        this.doSceneSessionDisappearFromRecentAnimation(midSession, SCBSessionShowInScreenIndex.INDEX_MIDDLE);
      }
      for (let leftSession of leftSessions) {
        leftSession.needRenderRotate.setCenterX('50%');
        // this.doSceneSessionDisappearFromRecentAnimation(delay, leftSession, SCBSessionShowInScreenIndex.INDEX_LEFT);
        this.doSceneSessionDisappearFromRecentAnimation(leftSession, SCBSessionShowInScreenIndex.INDEX_LEFT);
      }
      // 由于scroll的改变，屏幕的卡片需要重新设置新scroll下的pos
      this.recentClearAll.setInScreenConatinerPos(rightSessions, this.recentScroll.currentOffsetX);
      this.recentClearAll.setInScreenConatinerPos(midSessions, this.recentScroll.currentOffsetX);
      this.recentClearAll.setInScreenConatinerPos(leftSessions, this.recentScroll.currentOffsetX);

      // 屏幕外卡片的处理逻辑
      this.recentClearAll.removeAndDestructOffScreenSessions(offScreenSessions, this.recentClearAllCallback);
    }
    // let existLockedSessionInScreen = RecentLockIconModel.isDelayUnClearableAnimate(this.recentGesture);
    // let delayTime =
    //   this.recentClearAll.delayTimeForBlurAnimation(existLockedSessionInScreen, inScreenContainer);
    recentLog.info(`delay blur 0`);
    this.clearAllAnimCnt = 0;
    performanceMonitor.end(HiSysEventUtil.CLEAR_All_RECENT_ANI);
    let finishSession = inScreenContainer.length > 0 ?
      inScreenContainer[inScreenContainer.length - 1] : cloneList[curIndex];
    if (finishSession) {
      this.resetParamForClearAllOnFinish(finishSession.getTransitionCount(), finishSession);
    } else {
      RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.CLEAR_ALL_MISSIONS_END);
      recentRuntimeInstance.exit();
    }
    this.backToHomAfterClearAll();
    // this.panelViewModel.startBlurAnimationForContainer(delayTime);
    CloseAppManager.getInstance().clearAdaptiveIconCache();
    CloseAppManager.getInstance().deleteCardCache();
    this.panelViewModel.restorePrepareContainerSession();
    // setTimeout(() => {
    //   this.needTransparentSession = false;
    //   recentLog.info(`transparentView is hide`);
    // }, delayTime + 1000)
    this.needTransparentSession = false;
    recentLog.info(`transparentView is hide`);
  }

  private filterUnClearAbleSessions(): void {
    this.recentDelete.showStatusBarIfNeedOnfinish(this.scenePanelState, this.clearAllAnimCnt + 1);
    let unClearAbleSessionTotalList = this.totalContainerSessionList.filter(
      item => this.recentDelete.isUnclearAbleWhenClearAll(item));
    this.totalContainerSessionList.clear();
    for (let containerSession of unClearAbleSessionTotalList) {
      this.totalContainerSessionList.push(containerSession);
    }

    let unClearAbleSessionFloatList = this.floatingSessionList.filter(
      item => this.recentDelete.isUnclearAbleWhenClearAll(item));
    this.floatingSessionList.clear();
    for (let containerSession of unClearAbleSessionFloatList) {
      this.floatingSessionList.push(containerSession);
    }
  }

  private recentClearAllCallback: RecentClearAllCallback = {
    initFloatingWhenClearAll: (container: SCBSceneContainerSession) => {
      this.initFloatingWhenClearAll(container);
    },
  }

  private sceneContainerDestructionWithoutAnimation(containerSession: SCBSceneContainerSession,
    needRemoveSession: boolean): void {
    containerSession?.requestDestructionWithTransitionOut(needRemoveSession, false);
    if (containerSession?.pendingRemove && needRemoveSession) {
      this.panelMgr.removeSceneContainerSession(containerSession);
    }
  }

  private hideWallpaper(): void {
    ViewManagerPolicy.hideView(ViewType.WALLPAPER);
    this.panelMgr.disableBlurComponent('hideWallpaper');
  }

  private isEmptyRecentView(): boolean {
    if (this.scenePanelState !== ScenePanelState.RECENT) {
      return false;
    }
    if (this.containerSessionList.length !== 0) {
      return false;
    }
    if (SCBScenePanelManager.getInstance().getSceneContainerSessionListForView().length !== 0) {
      return false;
    }
    if (this.recentInnerState.isInRecentView() &&
      this.panelMgr.getFloatingSessionListForView().length !== 0) {
      return false;
    }
    if (this.panelMgr.getFloatingSessionListForView().length !== 0) {
      return false;
    }
    return true;
  }

  private clearCancelTransparentSceneTimer(): void {
    if (this.startCancelTimer !== INVALID_TIMER) {
      clearTimeout(this.startCancelTimer);
      this.startCancelTimer = INVALID_TIMER;
    }
  }

  private cancelTouchGesture(): void {
    if (!this.needTransparentSession) {
      return;
    }
  }

  private getBlurSceneSession(): SCBSystemSceneSession {
    if (!this.blurSceneSession) {
      this.blurSceneSession = this.initBlurSceneSession();
    }
    return this.blurSceneSession;
  }

  private initBlurSceneSession(): SCBSystemSceneSession {
    homeLog.showInfo('initBlurSceneSession');
    let blurSessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: 'BackgroundBlurView',
      sceneZIndex: 0,
      isFocusable: false,
      isTouchable: false,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
    }
    return SCBSceneSessionManager.getInstance().requestSystemSceneSession(blurSessionInfo);
  }

  private destroyBlurSceneSession(): void {
    if (this.blurSceneSession) {
      homeLog.showInfo('destroyBlurSceneSession');
      SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.blurSceneSession);
      this.blurSceneSession = undefined;
    }
  }

  private isEnableBlurView(): boolean {
    return this.panelSession.isBgBlurEnable && this.panelViewModel.isEnableBlur;
  }

  private onBlurViewDisappear(): void {
    /*if (MemoryUtils.isMemoryScene() && MemoryManager.getInstance().checkIsStaticMemoryScene()) {
      homeLog.showWarn('current is static memory scene');
      this.destroyBlurSceneSession();
    }*/
  }

  @Builder
  containerScrollerBuilder() {
    Scroll(this.recentScroll.scroller) {
      Stack({ alignContent: Alignment.TopStart }) {
        this.containerViewsBuilder({
          sessionList: this.containerSessionList,
          floatSessionList: this.floatingSessionList,
          screenProperty: this.screenProperty,
          isNeedReBuildRecentView: this.isNeedReBuildEnterRecentView
        })
      }
      .direction(Direction.Ltr)
      .accessibilityLevel('no')
      .containerViewStyles()
    }
    .direction(Direction.Ltr)
    .accessibilityLevel('no')
    .clip(this.needScrollClip)
    .scrollerCommonStyles()
    .scrollBar(BarState.Off)
    .scrollable((this.totalContainerSessionList.length !== 0) && (this.scenePanelState === ScenePanelState.RECENT) ?
    ScrollDirection.Horizontal : ScrollDirection.None)
    .edgeEffect(EdgeEffect.Spring)
    .onScrollStart(() => {
      this.recentScroll.onScrollStart();
      this.doReport = true;
    })
    .onDidScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
      if (this.doReport) {
        this.doReport = false;
        let direction: string = xOffset < 0 ? 'right' : 'left';
        HiSysEventUtil.reportRecentSwiper(direction);
      }
      if (scrollState === ScrollState.Idle) {
        // scrollTo without animation when recent enter/delete, do not do onScroll
        return;
      }
      this.panelFsm.onScroll(scrollState, xOffset, this.recentScroll.currentOffsetX);
    })
    .onScrollStop(() => {
      this.doReport = false;
      this.panelFsm.onScrollStop();
      this.recentScroll.onScrollStop();
      let centerIndex = recentRuntimeInstance.getAbsoluteIndexByColumn(recentRuntimeInstance.autoCenterColumn);
      let stopSession = recentRuntimeInstance.notRemovingSessionList[centerIndex];
      recentLog.showInfo(`end ${TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION}. current center session: ${stopSession?.getName()}`);
      // 单行多任务scroll滑动过程中被强杀的卡片，在非打断停止(自动停止)的时候卡片销毁
      if (!this.recentScroll.isInterruptFling) {
        this.panelViewModel.requestDestructionNeedRemoveSessionList(true);
      }
    })
  }

  @Builder
  recentEmptyViewBuilder() {
    RecentEmptyView()
      .id('RecentEmptyView')
      .gesture(PanGesture({ direction: PanDirection.Vertical })
        .onActionStart(() => {
          homeLog.info('PanGesture action invoke,  avoid onClick event in empty view');
        }))
      .onClick(() => {
        this.panelViewModel.exitRecentAndNotifyFloat();
      })
  }

  @Builder
  containerViewsBuilder($$: SceneContainerBuilderParam) {
    ForEach([...$$.sessionList, ...$$.floatSessionList], (item: SCBSceneContainerSession) => {
      SCBSceneContainer({
        sceneContainerSession: item,
        dividerParam: item.dividerParam,
        splitParam: item.splitParam,
        primarySceneParam: item.dividerParam.primary,
        secondarySceneParam: item.dividerParam.secondary,
        dividerParamList: item.dividerParamList,
        screenProperty: $screenProperty,
        scenePanelState: $scenePanelState,
        onGestureChange: this.onGestureChange,
        keyboardState: $keyboardState,
        keyboardSession: this.keyboardSession,
        keyboardPanelSession: this.keyboardPanelSession,
        name: this.name ? this.name : undefined,
        isScrolling: $isScrolling,
        isShowCompanionIcon: this.isShowCompanionIcon,
        isIconWithBadge: this.isIconWithBadge,
        needRenderTranslate: item.needRenderTranslate,
        needRenderSwiperTranslate: item.needRenderSwiperTranslate,
        needRenderTranslateIcon: item.needRenderTranslateIcon,
        needRenderScale: item.needRenderScale,
        needRenderPos: item.needRenderPos,
        needRenderLockIconOpacity: item.needRenderLockIconOpacity,
        needRenderLockIconScale: item.needRenderLockIconScale,
        needRenderLockIconTranslate: item.needRenderLockIconTranslate,
        needRenderTitleViewScale: item.needRenderTitleViewScale,
        needRenderVisibility: item.needRenderVisibility,
        needRenderAlpha: item.needRenderAlpha,
        needRenderBlurRadius: item.needRenderBlurRadius,
        needRenderShowRecentTitle: item.needRenderShowRecentTitle,
        needRenderBorderRadius: item.needRenderBorderRadius,
        needRenderShowInRecent: item.needRenderShowInRecent,
        needRenderRotate: item.needRenderRotate,
        floatingParam: item.floatingParam,
        needPreBuild: item.needPreBuild,
        needRenderZIndex: item.needRenderZIndex,
        needRenderMotionBlur: item.needRenderMotionBlur,
        needRenderClip: item.needRenderClip,
      })
    }, (item: SCBSceneContainerSession) => item.containerId.toString())
  }

  @Builder
  backgroundBlurViewBuilder() {
    if (this.isEnableBlurView()) {
      BackgroundBlurView({
        getBlurSceneSession: () => this.getBlurSceneSession(),
        onDisappear: () => this.onBlurViewDisappear(),
        isBgGrayScaleDisable: this.isBgGrayScaleDisable
      })
    }
  }

  @Builder
  recentClearAllViewBuilder() {
    if (this.isShowClearAllView()) {
      RecentClearAllView({
        recentDeleteConfig: this.recentDeleteConfig,
      })
    }
  }

  @Builder
  transparentViewBuilder() {
    if (this.transparentSceneSession && this.needTransparentSession) {
      WindowScene(this.transparentSceneSession.session.persistentId) {
        Stack()
          .width('100%')
          .height('100%')
      }
      .onClick(() => {
        homeLog.info('onClick invoke transparentView');
      })
    }
  }

  @Builder
  folderExpandSnapshotBuilder() {
    if (this.isNeedFoldExpandSnapShot) {
      FolderExpandSnapshotView({
        foldExpandSnapShotSessionId: this.foldExpandSnapShotSessionId,
        foldExpandStateChange: this.foldExpandStateChange
      })
        .size(this.panelViewModel.folderSnapshotSize)
        .translate({ x: this.viewParam.recentTransX, y: this.viewParam.recentTransY })
        .hitTestBehavior(HitTestMode.None)
    }
  }

  private isShowClearAllView(): boolean {
    if (this.recentInnerState.isInRecentView() && this.scenePanelState == ScenePanelState.RECENT &&
      (this.floatingSessionList.filterClone().length + this.containerSessionList.filterClone().length > 0)) {
      return true;
    }
    return false;
  }

  @Styles
  containerViewStyles() {
    .size({
      width: ItemUtils.num2PxStr(this.viewParam.recentW),
      height: ItemUtils.num2PxStr(this.viewParam.recentH)
    })
    .translate({ x: this.viewParam.recentTransX, y: this.viewParam.recentTransY })
    .opacity(this.viewParam.recentAlpha)
    .hitTestBehavior(HitTestMode.None)
  }

  @Styles
  scrollerCommonStyles() {
    .id('SCBScroll')
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
    .hitTestBehavior((this.scenePanelState === ScenePanelState.RECENT && this.recentInnerState.isInRecentView()) ?
    HitTestMode.Default : HitTestMode.None)
    .accessibilityScrollTriggerable(true)
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Vertical }).onActionStart(() => {
          homeLog.info('PanGesture action invoke,  avoid onClick event now');
        }),
        PanGesture({ direction: PanDirection.Horizontal })
          .onActionStart((event: GestureEvent) => {
            this.recentScroll.offsetX = event.offsetX;
            this.recentScroll.isUseMouse = true;
          })
          .onActionUpdate((event: GestureEvent) => {
            this.recentScroll.scroller.scrollBy(this.recentScroll.offsetX - event.offsetX, 0);
            this.recentScroll.offsetX = event.offsetX;
          })
          .onActionEnd((event: GestureEvent) => {
            this.recentScroll.scroller.fling(event.velocityX);
          })
      )
    )
    .onClick(() => {
      homeLog.info('onClick invoke');
      this.panelFsm.onClick(RecentClickReason.EXIT_RECENT);
    })
    .onTouch((event?: TouchEvent) => {
      let fingersNum = event?.touches?.length;
      let speed = RecentScrollFollowing.speed;
      if (fingersNum !== undefined && fingersNum > 1 &&
        !(event?.type === TouchType.Up && speed === 0)) {
        recentLog.showInfo('ignore touch event, finger = ' + fingersNum);
        return;
      }
      if (event?.type === TouchType.Down) {
        // 优先响应RecentEventView中的onTouch事件
        if (!recentRuntimeInstance.touchEventEqualTo(event)) {
          recentRuntimeInstance.touchContainerIndex =
            recentRuntimeInstance.getAbsoluteIndexByColumn(recentRuntimeInstance.autoCenterColumn);
        }
        this.recentScroll.touchDownEvent();
        this.panelFsm.onTouchDown(event as TouchEvent, TAG);
      } else if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
        recentRuntimeInstance.touchEvent = null;
        recentLog.showInfo(`onTouchUp speed ${speed}`);
        this.panelFsm.onTouchUp(event as TouchEvent, TAG);
        this.recentScroll.autoCentered(speed);
      }
    })
  }

  getScale(): ScaleOptions{
    homeLog.showInfo(`[scenePanelCanvasStyles] set Scale to: ${this.unLockScale}`);
    return {
      x: this.unLockScale,
      y: this.unLockScale
    }
  }

  @Styles
  scenePanelCanvasStyles() {
    .id('SCBScenePanelCanvas')
    .direction(Direction.Ltr)
    .focusable(false)
    .position({ x: 0, y: 0 })
    .size({
      width: this.screenProperty.width + 'px',
      height: this.screenProperty.height + 'px'
    })
    .scale(this.getScale())
    .hitTestBehavior((this.scenePanelState === ScenePanelState.FULLSCENE ||
      this.scenePanelState === ScenePanelState.RECENT) ? HitTestMode.Default : HitTestMode.None)
  }

  @Styles
  transformSceneStyles() {
    .id('SCBScenePanelTransformScene')
    .position({ x: 0, y: 0 })
    .size({
      width: this.screenProperty.width + 'px',
      height: this.screenProperty.height + 'px'
    })
    .translate(SCBRotateUtils.getScenePanelTranslateOptions(this.screenProperty, false))
    .rotate(SCBRotateUtils.getScenePanelRotateOptions(this.screenProperty, false))
    .border(SCBRotateUtils.getScenePanelBorderOptions())
    .zIndex(this.panelSession.panelZIndex)
    .hitTestBehavior(HitTestMode.None)
  }

  @Styles
  backgroundStackStyles() {
    .id('SCBScenePanelBackground')
    .direction(Direction.Ltr)
    .position({ x: 0, y: 0 })
    .size({ width: '100%', height: '100%' })
    .zIndex(this.panelSession.panelZIndex)
    .backgroundColor(this.getBackgroundColor())
    .hitTestBehavior(HitTestMode.None)
    .visibility(this.panelVisible)
  }

  build() {
    if (this.isUseThisScenePanel) {
      // black bkg, when scene above globalsearch rotate, show black, not globalsearch
      Stack({ alignContent: Alignment.TopStart }) {
        WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
          WindowScene(this.sysSceneSession?.session.persistentId) { // for input event in recent
            Stack({ alignContent: Alignment.TopStart }) {
              this.backgroundBlurViewBuilder()
              if (this.isEmptyRecentView()) {
                this.recentEmptyViewBuilder()
              } else {
                this.containerScrollerBuilder()
              }
              this.inputMethodBuilder()
              this.recentClearAllViewBuilder()
              this.transparentViewBuilder()
              this.folderExpandSnapshotBuilder()
            }
            .direction(Direction.Ltr)
            .id('SCBScenePanelStack')
          }
          .scenePanelCanvasStyles();
        }
        .transformSceneStyles();
      }
      .backgroundStackStyles()
    }
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isShowBlackBackground && this.scenePanelState === ScenePanelState.FULLSCENE) {
      return Color.Black;
    }
    return Color.Transparent;
  }
}

export class AppListInfo {
  appGridInfo: [GridLayoutItemInfo[]] = [[]];
  waterfallItemListInfo: GridLayoutItemInfo[] = [];
}
