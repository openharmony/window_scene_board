/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import {
  PageDesktopModel,
  CardItemInfo,
  CommonConstants,
  DesktopModeManager,
  DockItemInfo,
  EventConstants,
  FolderData,
  FormListInfoCacheManager,
  StyleConstants,
  StartAndExitVisualEffectManager,
  CustomBadgeManager,
  CloseAppManager,
  StartAndExitUtil,
  StartAndExitResponse,
  GrayAppListManager,
  PhoneCallAnimationConstants,
  FormConstants,
  FolderOperationFlag,
} from '@ohos/launchercommon';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  AnimateToScheduleUtils,
  CommonUtils,
  StartType,
  CompanionIconInfo,
  TraceUtil,
  DomainName,
  FileUtils,
  Trace,
  RectInfo
} from '@ohos/basicutils';
import { AppIconModel } from '@ohos/launchercommon/src/main/ets/launchericon/common/AppIconModel';
import { OverlayAnimScene, OverlayCardInfo } from '@ohos/systemuicommon/src/main/ets/overlay/OverlayCardInfo';
import { CallerInfo } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneInfo';
import {
  AppExitLocationInfo,
  EventType,
  ExecuteCallbackExtraInfo,
  FocusChangeReason,
  PreferMultiWindowOrientation,
  RecentsStyleConstants,
  RecentViewParam,
  SCBContainerRotationReason,
  SCBDeviceScreenConfig,
  SCBEventId,
  scbEventExclusiveManager,
  SCBKeyboardManager,
  SCBKeyboardPanelSession,
  SCBKeyboardSession,
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneContainerState,
  SCBSceneInfo,
  SCBSceneMode,
  SCBScenePanelManager,
  SCBSceneMissionManager,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBSessionRect,
  SCBSessionShowInScreenIndex,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SCBTogManager,
  SCBTransitionController,
  SCBTransitionManager,
  SCBWindowRotateController,
  ContainerDataCategory,
  SceneParam,
  StartFrom,
  SCBRotationConfig,
  RotationPropertyHolder,
  SystemSessionInfo,
  SceneInfoAdapterUtil,
  SCBScenePanelSession,
  SCBBaseScenePanelViewModel,
  SCBSceneSessionArray,
  StartMode,
  SCBKioskModeManager,
  SCBTransferSceneOpts,
  FloatingType,
  FloatSceneStartAnimation,
  CommonResult,
  SCBSceneUtils,
  MINIMIZE_ABILITY_BEFORE_POP,
  SCBSceneOrientation
} from '@ohos/windowscene';
import lazy BundleManager from '@ohos.bundle.bundleManager';
import lazy { SCBSplitUtils } from '@ohos/windowscene/src/main/ets/scene/utils/SCBSplitUtils';
import {
  MultiWindowEventConstants,
  SplitType,
  VassistantConstants
} from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { quickSwitchRequestActiveAlarm } from '../../recent/scenepanel/quickswitchpanel/QuickSwitchRequestActiveAlarm';
import { ViewManager } from '@ohos/launchercommon/src/main/ets/manager/ViewManager';
import systemParameter from '@ohos.systemParameterEnhance';
import {
  ReplaceReason,
  AiSplitReason,
  AiSplitBehavior,
  BatchEnterSplitOrMidSceneReason
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import UnLockConstants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import {
  BusinessError,
  commonEventManager,
  configPolicy,
  systemDateTime
} from '@kit.BasicServicesKit';
import { ScenePanelState } from '../SCBScenePanel';
import { SCBDefaultZIndex } from '../SCBScreen';
import {
  CallToState,
  DividerStyleConstants,
  RotationConstants,
  SCBConstants,
  VisualEffectConstants,
  BlurEffectType,
} from '@ohos/commonconstants/src/main/ets/TsIndex';
import { recentRuntimeInstance } from '../../recent/scenepanel/recentpanel/RecentRuntimeModel';
import transactionManager from '@ohos.transactionManager';
import {
  ApsUtils,
  EvtBus,
  HiSysEventUtil,
  HiDfxEventUtil,
  RotateChangeEvent,
  SCBWindowSceneConfig,
  ViewManagerPolicy,
  ViewType,
  OperateResult,
  SceneIdentificationManager,
  SceneState,
  localEventManager,
  SCBDesktopCacheManager,
  GlobalContext,
  DeviceHelper,
  sOutSideWindowMgr,
  CEManager,
  RecentEventType,
  StartSceneFromOtherEvent,
  PairSplitResult,
  IntelligentCache,
  HiSysReturnHomeData,
  ReturnDesktopEventType,
  GlobalSearchStatus,
  IconResourceManager,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import lazy { SCBTriFoldManager, SCBTripleFoldState } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import { EditModeViewEvent } from '@ohos/desktopedit/src/main/ets/default/viewmodel/EditModeViewEvent';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import { launcherVisualEffectMgr, TripleFoldExpandAnimUtils, } from '@ohos/launchercommon/Index';
import { curves, performanceMonitor } from '@kit.ArkUI';
// import apsManager from '@ohos.graphic.apsManager';
import { bundleManager } from '@kit.AbilityKit';
import { GestureDockViewModel } from '../../gestureDock/dock/viewmodel/GestureDockViewModel';
import { ContainerShowState, RecentNotShow } from '../../recent/scenepanel/recentpanel/RecentNotShow';
import { MultiRecentPositionArray, RecentLayoutManager } from '../../recent/common/RecentLayoutManager';
import { RecentLayoutCalculatorFactory } from '../../recent/common/RecentLayoutCalculatorFactory';
import { RecentEnterAnimations } from '../../recent/scenepanel/recentpanel/RecentEnterAnimations';
import { RecentGesture } from '../../recent/scenepanel/recentpanel/RecentGesture';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import {
  RecentEnterCallback,
  RecentExitCallback,
  RecentStartSceneCallback
} from '../../recent/scenepanel/recentpanel/RecentCallbacks';
import { SCBScenePanelFSM } from '../../recent/scenepanel/SCBScenePanelFSM';
import lazy {
  SplitLifeCycle,
  SplitRatioCacheKey,
  SplitRatioEnum
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSplitParam';
import { SCBRotateUtils } from '../utils/SCBRotateUtils';
import { QuitAppRectViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/QuitAppRectViewModel';
import { AIBarViewModel } from '../../aiBar/AIBarModel/AIBarViewModel';
import { RecentStartScene } from '../../recent/scenepanel/recentpanel/RecentStartScene';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon/src/main/ets/TsIndex';
import { OneStepState } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { RecentRotationUtil } from '../../recent/common/RecentRotationUtil';
import { RotateFuncType } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { quickSwitchViewModel } from '../../recent/scenepanel/quickswitchpanel/QuickSwitchViewModel';
import { RecentGestureEventManager } from '../../recent/common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../recent/common/constants/RecentGestureConstants';
import { QuickSwitchAnimations } from '../../recent/scenepanel/quickswitchpanel/QuickSwitchAnimations';
import { BigFolderViewModel } from '@ohos/bigfolder';
import { bannerMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SmallFolderModelManager } from '@ohos/smallfolder/src/main/ets/default/common/SmallFolderModelManager';
import { image } from '@kit.ImageKit';
import { ItemUtils, SCBVisualEffectMgr } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { OverlayStartAnimHelper } from '@ohos/systemuicommon/Index';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { RecentDelete } from '../../recent/scenepanel/recentpanel/RecentDelete';
import { recentLockModel } from '../../recent/settings/RecentLockModel';
import { SingleStartFrom } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { SCBPhoneSceneUtils } from '../utils/SCBPhoneSceneUtils';
import { SCBScenePanelAnimator, WindowAnimationReason } from '../viewanimator/SCBScenePanelAnimator';
import { GestureDockConstants } from '../../gestureDock/common/GestureDockConstants';
import { RecentStateManager } from '../../recent/innerstate/RecentStates';
import { RecentExit } from '../../recent/scenepanel/recentpanel/RecentExit';
import { RecentScroll } from '../../recent/scenepanel/recentpanel/RecentScroll';
import { ContainerBuilder } from '../../recent/common/ContainerBuild';
import { QuickSwitchRaiseTopAlarm } from '../../recent/scenepanel/quickswitchpanel/QuickSwitchRaiseTopAlarm';
import { AppFloating } from '../../recent/scenepanel/apppanel/AppFloating';
import {
  WrapRotationEntryParam
} from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { SCBPiPManager } from '../pip/SCBPiPManager';
import { recentViewModel } from '../../recent/scenepanel/recentpanel/RecentViewModel';
import { SCBMinimizeSceneOpts } from '@ohos/windowscene/src/main/ets/scene/SceneModuleIndex';
import { PipOneShotAnimHelper } from '../pip/utils/PipOneShotAnimHelper';
import { SCBTripleStateChange } from '@ohos/launchercommon/src/main/ets/utils/TripleFoldExpandAnimUtils';
import { ScenePanelStates } from '../../recent/scenepanel/ScenePanelStates';
import { SCBMainPanelMissionHandler } from './missionmanagement/SCBMainPanelMissionHandler';
import { WindowStateChangeMode } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { SceneBoardStateManager, CoreEventType } from '@ohos/frameworkwrapper/Index';
import { RecentTitleViewModel } from '../../recent/viewmodel/RecentTitleViewModel';
// import lazy { insightIntent } from '@kit.IntentsKit';
import lazy {
  SCBSceneWindowAiSplitSwitchUtils,
  SwitchType
} from '@ohos/windowscene/src/main/ets/scene/utils/SCBSceneWindowAiSplitSwitchUtils';
import common from '@ohos.app.ability.common';
import lazy { SCBRecentPrepareManager } from '../pcmode/SCBRecentPrepareManager';
import { ENABLE_FORCE_CLOSE_HDR } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { SCBPhoneSceneMissionProcessor } from './missionmanagement/SCBPhoneSceneMissionProcessor';
import { SCBSceneStartInterceptor, StartInterceptions } from '@ohos/windowscene/src/main/ets/scene/framework/missions/SCBSceneStartInterceptor';
import { INVALID_PERSISTENT_ID } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSession';
import { SCBVassistantMissionHandler } from './missionmanagement/SCBVassistantMissionHandler';
import { RecentZoomAlarm } from '../../recent/scenepanel/recentpanel/RecentZoomAlarm';
import { WinLog, WinLogDomain } from '@ohos/windowscene/src/main/ets/utils/WinLog';
import { SwipeAppToCapsuleAnimation } from '@ohos/systemuicommon/src/main/ets/animation/SwipeAppToCapsuleAnimation';
import { SCBFloatManager } from '../multiwindow/SCBFloatManager';
import { SCBSplitManager } from '../multiwindow/SCBSplitManager';

const PANEL_NAME = 'SCBScenePanel';
const TAG = 'SCBScenePanelViewModel';
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const winLog = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const RECENT_TAG = 'RecentPanelViewModel';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);

// const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const uiType: ESObject = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

const REQUEST_UPDATE_RECT_DELAY: number = 100;
const WITHOUT_ANIMATION_LIST: string[] = ['com.ohos.onekeylock'];

export function getScenePanelName(state: ScenePanelState): string {
  return ScenePanelState[state] ? ScenePanelState[state] : 'invalid: ' + state;
}
const SCREEN_BUNDLE_NAME = 'com.ohos.sceneboard';
const DEFAULT_PANEL_NAME = '';
const INVALID_INDEX = -1;

/**
 * Handler for view model operates view state collection.
 */
export interface ScenePanelStateCollectionHandler {
  getPanelState: () => ScenePanelState;
  updatePanelState: (state: ScenePanelState) => void;
  getViewParam: () => RecentViewParam;
  getKeyboardSession: () => SCBKeyboardSession;
  getKeyboardPanelSession: () => SCBKeyboardPanelSession;
  getBlackBackgroundState: () => boolean;
  updateBlackBackgroundState: (blackBackgroundState: boolean) => void;
  getRecentInnerState: () => RecentStateManager;
  getMattesLockState: () => boolean;
  updateMattesLockState: (mattesLock: boolean) => void;
  getBgGrayScaleDisableState: () => boolean;
  updateBgGrayScaleDisableState: (isBgGrayScaleDisable: boolean) => void;
  getPanelVisibleState: () => Visibility;
  updatePanelVisibleState: (panelVisible: Visibility) => void;
  getScrollingState: () => boolean;
  updateScrollingState: (isScrolling: boolean) => void;
  getPhysicalScreenProperty: () => SCBScreenProperty;
  updateNeedScrollClip: (needScrollClip: boolean) => void;
  getNeedScrollClip: () => boolean;
  getCompanionIconShowState: () => boolean;
  updateCompanionIconShowState: (state: boolean) => void;
  getIconWithBadgeState: () => boolean;
  updateIconWithBadgeState: (state: boolean) => void;
  updateUnLockScale: (unLockScale: number) => void;
  getPanelSession: () => SCBScenePanelSession;
  getIsEmptyRecentViewCallback:() => Function;
  getFoldExpandStateChange: () => SCBTripleStateChange;
  setFoldExpandStateChange: (change : SCBTripleStateChange) => void;
  getNeedFoldExpandSnapShot: () => boolean;
  setNeedFoldExpandSnapShot: (isNeed: boolean) => void;
  getFoldExpandSnapShotSessionId: () => number;
  setFoldExpandSnapShotSessionId: (sessionId: number) => void;
  getFoldAnimNum: () => number;
  setFoldAnimNum: (animNum: number) => void;
}

/**
 * Handler for view model operates base data collection.
 */
export interface ScenePanelDataCollectionHandler {
  getIsTouchableByNavBar: () => boolean;
  getFromScenePanelState: () => ScenePanelState;
  setFromScenePanelState: (state: ScenePanelState) => void;
  setCurrRotation: (currRotation: number) => void;
  getCurrRotation: () => number;
  getRotationAnimCnt: () => number;
  setRotationAnimCnt: (rotationAnimCnt: number) => void;
  addRotationAnimCnt: () => void;
  decRotationAnimCnt: () => void;
  getRotateFinishTimerId: () => number;
  setRotateFinishTimerId: (rotateFinishTimerId: number) => void;
  getPanelName: () => string;
  getRecentStartNotifyRotation: () => number | undefined;
  setRecentStartNotifyRotation: (recentStartNotifyRotation: number | undefined) => void;
  setExpandStartContainerSession: (expandStartContainerSession: SCBSceneContainerSession | null) => void;
  getIsSupportMaximizeScene: () => boolean;
  setIsSupportMaximizeScene: (isSupportMaximizeScene: boolean) => void;
  getIsNeedChangeToMultiRow: () => boolean;
  setIsNeedChangeToMultiRow: (isNeedChangeToMultiRow: boolean) => void;
  getNeedRemoveBlank: () => boolean;
  setNeedRemoveBlank: (needRemoveBlank: boolean) => void;
  getClearAllAnimCnt: () => number;
  getRecentDelete: () => RecentDelete;
  getAppFloating: () => AppFloating;
  getAnimationFinishedCallback: () => (visible: boolean) => void;
  updateLandscapeExitTimeOutId: (timerID: number) => void;
  getQuickSwitchAnimations: () => QuickSwitchAnimations;
  getOneStepSplitExitFlag: () => boolean;
  setOneStepSplitExitFlag: (oneStepSplitExitFlag: boolean) => void;
  getOneStepSplitContainerID: () => number;
  setOneStepSplitContainerID: (oneStepSplitContainerID: number) => void;
}

interface TerminateParams {
  persistentId?: number;
  containerId?: number;
  needRemoveSession: boolean;
  needClearData: boolean;
  shouldBackToCaller: boolean;
  extraInfo?: ExecuteCallbackExtraInfo;
}

/**
 * ViewModel of SCBScenePanel View.
 */
export class SCBScenePanelViewModel extends SCBBaseScenePanelViewModel<SCBMainPanelMissionHandler> {
  private readonly MAX_SESSION_LIMIT_ONE_APP = 'const.window.max_session_limit_one_ability';
  private readonly MAX_SESSION_LIMIT_ALL_APP = 512;

  private uiContext: UIContext;
  private missionProcessor: SCBPhoneSceneMissionProcessor = new SCBPhoneSceneMissionProcessor();
  private panelMgr: SCBScenePanelManager;
  private stateCollectionHandler: ScenePanelStateCollectionHandler | null = null;
  private dataCollectionHandler: ScenePanelDataCollectionHandler | null = null;
  private isVirtualInExitAnim: boolean = false;
  private isVirtualNeedTerminate: boolean = false;
  private terminateParams?: TerminateParams;
  /*
   * Scene mission management
   */
  private containerSessionList: SCBSceneContainerSessionArray;
  private containerSessionListNotShowRecent: SCBSceneContainerSessionArray;
  private floatingSessionList: SCBSceneContainerSessionArray;
  public containerSession: SCBSceneContainerSession | undefined = undefined;
  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: PANEL_NAME,
    sceneZIndex: SCBDefaultZIndex.SYSTEM_SCENE_PANEL,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.PANEL_SCENE,
    isRotatable: true,
  };
  public sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.systemSessionInfo);
  public editModeViewEvent: EditModeViewEvent = editModeViewManager.getEditModeViewEvent();

  // mission callbacks, will delete after new fwk.
  private startSceneTransitionCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo,
    isBackTransition?: boolean): CommonResult => {
      return this.onSceneStartTransition(toInfo, fromInfo, isBackTransition)
    };
  private startSceneFromRecentCallback = (persistentId?: number, containerId?: number) => {
    this.onStartSceneFromRecent(persistentId, containerId);
  }
  private startSceneFromIconCallback = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo) => {
    this.onStartSceneFromIcon(sceneInfo, fromInfo);
  }
  private activateSceneCallback = (persistentId?: number, containerId?: number) => {
    this.onActivateScene(persistentId, containerId);
  }
  private pairSplitFromDockCallback = (locationX: number, locationY: number, sceneInfo: SCBSceneInfo) => {
    this.onPairSplitFromDock(locationX, locationY, sceneInfo);
  }
  private startSceneFromOtherCallback = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult => {
    return this.onStartSceneFromOther(sceneInfo, fromInfo);
  }
  private startSceneByCallCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult => {
    return this.onSceneStartByCall(toInfo, fromInfo);
  }
  private minimizeAllSceneCallback = (isFromRecent?: boolean) => {
    this.minimizeAllScene(isFromRecent);
  }
  private minimizeSceneCallback =
    (persistentId?: number, containerId?: number, needRemoveSession?: boolean, shouldBackToCaller?: boolean,
      extraInfo?: ExecuteCallbackExtraInfo) => {
      let opts: SCBMinimizeSceneOpts = {
        needRemoveSession: needRemoveSession,
        shouldBackToCaller: shouldBackToCaller,
        extraInfo: extraInfo
      }
      this.onMinimizeScene(persistentId, containerId, opts);
    }
  private destroySceneCallback = (persistentId?: number, containerId?: number) => {
    this.onDestroyScene(persistentId, containerId);
  }

  /**
   * pop out scene session from main panel.
   * @deprecated will use OOP by SCBMainPanelMissionHandler.
   */
  public popSceneSession = (persistentId: number, sceneInfo: SCBSceneInfo,
    opts: SCBTransferSceneOpts): SCBSceneSession | undefined => {
    if ((persistentId === undefined || persistentId <= INVALID_PERSISTENT_ID) && !sceneInfo) {
      homeLog.showWarn('popSceneSession, invalid params');
      return undefined;
    }
    const sceneSession = this.popContainerSession(persistentId, sceneInfo, opts) ??
      this.popFloatingSession(persistentId, sceneInfo, opts?.needBackground);
    const notShowSession = this.panelMgr.popNotShowRecentSession(persistentId, sceneInfo);
    return sceneSession ?? notShowSession;
  }

  /**
   * RotationPropertyHolder viewModel inner implement
   */
  private viewModelRotationPropertyHolder: RotationPropertyHolder = {
    getScreenProperty: (): SCBScreenProperty => {
      return this.screenProperty;
    },
    getContainerSessionList: (): SCBSceneContainerSessionArray => {
      return this.getContainerSessionList();
    },
    getFloatingSessionList: (): SCBSceneContainerSessionArray => {
      return this.getFloatingSessionList();
    }
  }

  /*
   * SCBRotationController callback
   */
  private handleSplitScreenCallback = (containerSession: SCBSceneContainerSession | null,
    screenProperty: SCBScreenProperty, needHideKeyboard: boolean) => {
    this.handleSplitScreen(containerSession, screenProperty, needHideKeyboard);
  };

  private prepareRotationBeforeAnimationCallback = (rotation: number) => {
    this.prepareRotationBeforeAnimation(rotation);
  };

  private setExpandStartContainerSessionCallback = (containerSession: SCBSceneContainerSession | null) => {
    this.setExpandStartContainerSession(containerSession);
  };

  private showDividerAfterRotationCallback = (containerSession: SCBSceneContainerSession | null,
    rotateDuration: number) => {
    this.showDividerAfterRotation(containerSession, rotateDuration);
  };

  private showWallpaperAfterRotateCallback = (isEnableBlur: boolean) => {
    this.showWallpaperAfterRotate(isEnableBlur);
  };

  private setFloatAnimateStatusCallback = (animateStatus: boolean) => {
    this.setFloatAnimateStatus(animateStatus);
  };

  private setKeyboardRotationFlagCallback = (isRotating: boolean) => {
    this.setKeyboardRotationFlag(isRotating);
  };

  private updateBlackBackgroundStateCallback = (blackBackgroundState: boolean) => {
    this.updateBlackBackgroundState(blackBackgroundState);
  };

  private getPanelNameCallback = () : string => {
    return this.getPanelName();
  };

  private updateNeedScrollClipRotateFinishCallback = () => {
    this.updateNeedScrollClipRotateFinish();
  };

  private coverSensorRotationCallback = (screenSession: SCBScreenSession) => {
    this.coverSensorRotation(screenSession);
  };

  private handleFloatWhenExitSceneCallback = (reason?: SCBContainerRotationReason) => {
    this.handleFloatWhenExitScene(reason);
  };

  private getMattesLockStateCallback = (): boolean => {
    return this.getMattesLockState();
  };

  private executeAnimateToCallback =
    (rotateDuration: number, isAssignCurve: boolean, event: () => void, onFinish: () => void) => {
      let curve: Curve | undefined = isAssignCurve ? Curve.Friction : undefined;
      WindowAnimationUtils.getInstance().executeRotationAnimate(rotateDuration, event, onFinish, curve);
    };

  private clearExitSceneNotifyRotationCallback = () => {
    this.clearExitSceneNotifyRotation();
  };

  private interruptPipAnimWithFloatRotationCallback = () => {
    this.interruptPipAnimWithFloatRotation();
  };

  private updateFloatContainerWithScreenChangeCallback = (screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason) => {
    this.updateFloatContainerWithScreenChange(screenProperty, reason);
  };

  private notifyUpdateScenePanelWhenRotateCallback = (screenProperty: SCBScreenProperty) => {
    this.notifyUpdateScenePanelWhenRotate(screenProperty);
  };

  private updateFloatAfterRotationAnimateCallback = () => {
    this.updateFloatAfterRotationAnimate();
  };

  private clearRecentStartNotifyRotationCallback = () => {
    this.clearRecentStartNotifyRotation();
  };

  /*
   * Scene Animation
   */
  private panelAnimator: SCBScenePanelAnimator;
  private sceneContainerSessionIconAlphaDuration: number = 90;
  private renderAlphaDuration: number = 60;
  private blurTransitionInactiveDuration: number = 300;
  private iconAlphaDuration: number = 110;
  public isInAppExit: boolean = false;
  private swipeEndSceneContainerSession: SCBSceneContainerSession | undefined = undefined;
  private phoneCallAnimCount: number = 0;
  public folderSnapshotSize: SizeOptions = {};

  /*
   * Window Property
   */
  private shouldHideStatusBar: boolean = false;
  private index: number = 0;
  private targetIndex: number = 0;

  /*
   * Rotation
   */
  private exitSceneNotifyRotation: number | undefined = undefined;
  public timerStartTime: number = 0;
  private terminateSceneCallback = (persistentId?: number, containerId?: number, needRemoveSession: boolean = false,
    shouldBackToCaller: boolean = true, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onTerminateScene(persistentId, containerId, needRemoveSession, false, shouldBackToCaller, extraInfo);
  }

  private closeSceneCallback = (persistentId?: number, containerId?: number, needRemoveSession: boolean = true,
    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onCloseScene(persistentId, containerId, needRemoveSession, isSaveSnapshot, extraInfo);
  }

  /*
   * Recent
   */
  public recentNotShow: RecentNotShow;
  public recentScroll: RecentScroll;
  public recentEnter: RecentEnterAnimations;
  public recentGesture: RecentGesture;
  private recentStartScene: RecentStartScene;
  public recentExit: RecentExit;
  public desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  // 普通多任务和悬浮窗多任务的全集
  public totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  public quickSwitchAnimations: QuickSwitchAnimations;

  public panelFsm: SCBScenePanelFSM;
  private startAndExitEffectMgr: StartAndExitVisualEffectManager = StartAndExitVisualEffectManager.getInstance();
  private folderData: FolderData = FolderData.getInstance();

  // isNewStyle为false时，整体动效效果按照匹配设备来隔离
  public isNewStyle: boolean = true;
  public isEnableBlur: boolean = true;

  // 智X键默认属性值
  private needInitQuickAccessMenuConfig: boolean = true;

  private quickAccessMenuHeight: number = SCBConstants.DEFAULT_QUICK_ACCESS_MENU_HEIGHT;

  private quickAccessMenuWidth: number = SCBConstants.DEFAULT_QUICK_ACCESS_MENU_WIDTH;

  private quickAccessMenuTopOffset: number = SCBConstants.QUICK_ACCESS_MENU_TOP_OFFSET;

  private quickAccessMenuFuncType =
    systemParameter.getSync(SCBConstants.QUICK_ACCESS_FUNCTION_TYPE, SCBConstants.QUICK_ACCESS_FUNCTION_NOT_SUPPORT);

  public getIsVirtualInExitAnim(): boolean {
    return this.isVirtualInExitAnim;
  }

  public setIsVirtualInExitAnim(isVirtualInExitAnim: boolean): void {
    this.isVirtualInExitAnim = isVirtualInExitAnim;
  }

  public getIsVirtualNeedTerminate(): boolean {
    return this.isVirtualNeedTerminate;
  }

  public setIsVirtualNeedTerminate(isVirtualNeedTerminate: boolean): void {
    this.isVirtualNeedTerminate = isVirtualNeedTerminate;
  }

  public getTerminateParams(): TerminateParams | undefined {
    return this.terminateParams;
  }

  public setTerminateParams(terminateParams: TerminateParams | undefined): void {
    this.terminateParams = terminateParams;
  }

  public getContainerSessionList(): SCBSceneContainerSessionArray {
    return this.containerSessionList;
  }

  public getContainerSessionListNotShowRecent(): SCBSceneContainerSessionArray {
    return this.containerSessionListNotShowRecent;
  }

  public getFloatingSessionList(): SCBSceneContainerSessionArray {
    return this.floatingSessionList;
  }

  public getPanelManager(): SCBScenePanelManager {
    return this.panelMgr;
  }

  public getStateCollectionHandler(): ScenePanelStateCollectionHandler | null {
    return this.stateCollectionHandler;
  }

  public getDataCollectionHandler(): ScenePanelDataCollectionHandler | null {
    return this.dataCollectionHandler;
  }

  public getScreenProperty(): SCBScreenProperty {
    return this.screenProperty;
  }

  public getUiContext(): UIContext {
    return this.uiContext;
  }

  public getShouldHideStatusBar(): boolean {
    return this.shouldHideStatusBar;
  }

  public setShouldHideStatusBar(value: boolean) {
    this.shouldHideStatusBar = value;
  }

  public getSceneContainerSessionIconAlphaDuration(): number {
    return this.sceneContainerSessionIconAlphaDuration;
  }

  public getRenderAlphaDuration(): number {
    return this.renderAlphaDuration;
  }

  public getIconAlphaDuration(): number {
    return this.iconAlphaDuration;
  }

  public getExitSceneNotifyRotation(): number | undefined {
    return this.exitSceneNotifyRotation;
  }

  public constructor(context: UIContext, screenProperty: SCBScreenProperty) {
    super(new SCBMainPanelMissionHandler(screenProperty), screenProperty);
    this.uiContext = context;
    this.panelMgr = SCBScenePanelManager.getInstance(screenProperty);
    this.floatingSessionList = this.panelMgr.getFloatingSessionList();
    this.containerSessionListNotShowRecent = this.panelMgr.getNotShowRecentList();
    this.containerSessionList = this.panelMgr.getSceneContainerSessionList();

    this.totalContainerSessionList = this.panelMgr.getSceneContainerSessionList()

    this.recentNotShow = new RecentNotShow(this.panelMgr);
    this.recentScroll = new RecentScroll(this.panelMgr);
    this.recentEnter = new RecentEnterAnimations(this.panelMgr);
    this.recentGesture = new RecentGesture(this.panelMgr);
    this.recentStartScene = new RecentStartScene(this.panelMgr);
    this.recentExit = new RecentExit(this.panelMgr);
    this.folderSnapshotSize = { width: px2vp(screenProperty.width), height: px2vp(screenProperty.height) };
    this.quickSwitchAnimations = new QuickSwitchAnimations(this.panelMgr);
    this.panelFsm = SCBScenePanelFSM.getInstance(this.panelMgr);
    this.panelAnimator = new SCBScenePanelAnimator(this);
  }

  public init(stateCollectionHandler: ScenePanelStateCollectionHandler,
    dataCollectionHandler: ScenePanelDataCollectionHandler): void {
    winLog.showInfo('init.');
    this.stateCollectionHandler = stateCollectionHandler;
    this.dataCollectionHandler = dataCollectionHandler;
    this.initConfigs();
    SCBSceneSessionManager.getInstance().registerClearAdditionalCallersCallback(this.clearAdditionalCallersCallback);
    SCBPiPManager.getInstance().registerRestoreWithRotation(this.getPanelViewModelRotation);
    this.missionHandler.setViewModel(this);
    this.bindRotationController();
    SCBSceneMissionManager.getInstance().registerProductMissionProcessor(this.missionProcessor);
    this.registerSceneStartingInterceptorRules();
  }

  /**
   * bind with rotation controller
   */
  private bindRotationController(): void {
    if (!SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showError('bindRotationController screenSession is null');
      return;
    }
    this.registerRotationControllerCallback(screenSession);
    this.injectRotationControllerDependency(screenSession);
  }

  private registerRotationControllerCallback(screenSession: SCBScreenSession): void {
    screenSession.rotationController.registerHandleSplitScreenFunc(this.handleSplitScreenCallback);
    screenSession.rotationController.registerShowDividerAfterRotationFunc(this.showDividerAfterRotationCallback);
    screenSession.rotationController.registerShowWallpaperAfterRotateFunc(this.showWallpaperAfterRotateCallback);
    screenSession.rotationController.registerSetFloatAnimateStatusFunc(this.setFloatAnimateStatusCallback);
    screenSession.rotationController.registerGetPanelNameFunc(this.getPanelNameCallback);
    screenSession.rotationController.registerSetKeyboardRotationFlagFunc(this.setKeyboardRotationFlagCallback);
    screenSession.rotationController.registerUpdateBlackBackgroundStateFunc(this.updateBlackBackgroundStateCallback);
    screenSession.rotationController.registerCoverSensorRotationFunc(this.coverSensorRotationCallback);
    screenSession.rotationController.registerHandleFloatWhenExitSceneFunc(this.handleFloatWhenExitSceneCallback);
    screenSession.rotationController.registerClearExitSceneNotifyRotationFunc(this.clearExitSceneNotifyRotationCallback);
    screenSession.rotationController.registerGetMattesLockStateFunc(this.getMattesLockStateCallback);
    screenSession.rotationController.registerExecuteAnimateToFunc(this.executeAnimateToCallback);
    screenSession.rotationController
      .registerInterruptPipAnimWithFloatRotationFunc(this.interruptPipAnimWithFloatRotationCallback);
    screenSession.rotationController
      .registerClearRecentStartNotifyRotationFunc(this.clearRecentStartNotifyRotationCallback);
    screenSession.rotationController
      .registerPrepareRotationBeforeAnimationFunc(this.prepareRotationBeforeAnimationCallback);
    screenSession.rotationController
      .registerSetExpandStartContainerSessionFunc(this.setExpandStartContainerSessionCallback);
    screenSession.rotationController
      .registerUpdateNeedScrollClipRotateFinishFunc(this.updateNeedScrollClipRotateFinishCallback);
    screenSession.rotationController
      .registerUpdateFloatContainerWithScreenChangeFunc(this.updateFloatContainerWithScreenChangeCallback);
    screenSession.rotationController
      .registerNotifyUpdateScenePanelWhenRotateFunc(this.notifyUpdateScenePanelWhenRotateCallback);
    screenSession.rotationController
      .registerUpdateFloatAfterRotationAnimateFunc(this.updateFloatAfterRotationAnimateCallback);
  }

  private injectRotationControllerDependency(screenSession: SCBScreenSession): void {
    screenSession.rotationController.setRotationPropertyHolder(this.viewModelRotationPropertyHolder);
  }

  private unbindRotationController(): void {
    if (!SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showError('unbindRotationController screenSession is null');
      return;
    }
    this.unregisterRotationControllerCallback(screenSession);
    screenSession.rotationController.clearRotationPropertyHolder();
  }

  private unregisterRotationControllerCallback(screenSession: SCBScreenSession): void {
    screenSession.rotationController.unregisterHandleSplitScreenFunc();
    screenSession.rotationController.unregisterPrepareRotationBeforeAnimationFunc();
    screenSession.rotationController.unregisterSetExpandStartContainerSessionFunc();
    screenSession.rotationController.unregisterShowDividerAfterRotationFunc();
    screenSession.rotationController.unregisterUpdateNeedScrollClipRotateFinishFunc();
    screenSession.rotationController.unregisterSetFloatAnimateStatusFunc();
    screenSession.rotationController.unregisterShowWallpaperAfterRotateFunc();
    screenSession.rotationController.unregisterUpdateFloatContainerWithScreenChangeFunc();
    screenSession.rotationController.unregisterNotifyUpdateScenePanelWhenRotateFunc();
    screenSession.rotationController.unregisterGetPanelNameFunc();
    screenSession.rotationController.unregisterUpdateFloatAfterRotationAnimateFunc();
    screenSession.rotationController.unregisterUpdateBlackBackgroundStateFunc();
    screenSession.rotationController.unregisterSetKeyboardRotationFlagFunc();
    screenSession.rotationController.unregisterClearRecentStartNotifyRotationFunc();
    screenSession.rotationController.unregisterCoverSensorRotationFunc();
    screenSession.rotationController.unregisterHandleFloatWhenExitSceneFunc();
    screenSession.rotationController.unregisterInterruptPipAnimWithFloatRotationFunc();
    screenSession.rotationController.unregisterClearExitSceneNotifyRotationFunc();
    screenSession.rotationController.unregisterGetMattesLockStateFunc();
    screenSession.rotationController.unregisterExecuteAnimateToFunc();
  }

  public release(): void {
    winLog.showInfo('release.');
    SCBSceneSessionManager.getInstance().unregisterGetSideEdgeSessionListCallback();
    SCBSceneSessionManager.getInstance().unregisterClearAdditionalCallersCallback();
    SCBPiPManager.getInstance().unregisterRestoreWithRotation();
    this.unregisterSceneStartingInterceptorRules();
    this.missionHandler.setViewModel(null);
    this.unbindRotationController();
  }

  private initConfigs(): void {
    this.isNewStyle = (systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    this.isEnableBlur = (systemParameter.getSync('sceneboard.isEnableBlur', 'true') === 'true');
  }

  private getPanelViewModelRotation = (container: SCBSceneContainerSession, screenSession: SCBScreenSession,
    fromUser: boolean): number => {
    return this.getContainerSessionRotation(container, screenSession, fromUser);
  }

  public registerSceneMissionManagementCallback(): void {
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_TRANSITION, this.screenProperty.screenId,
      this.startSceneTransitionCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_RECENT, this.screenProperty.screenId,
      this.startSceneFromRecentCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_ICON, this.screenProperty.screenId,
      this.startSceneFromIconCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.ACTIVATE_SCENE, this.screenProperty.screenId,
      this.activateSceneCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.PAIR_SPLIT_FROM_DOCK, this.screenProperty.screenId,
      this.pairSplitFromDockCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      this.startSceneFromOtherCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_BYCALL, this.screenProperty.screenId,
      this.startSceneByCallCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MINIMIZE_ALL_SCENE, this.screenProperty.screenId,
      this.minimizeAllSceneCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
      this.minimizeSceneCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.DESTROY_SCENE, this.screenProperty.screenId,
      this.destroySceneCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      this.terminateSceneCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId,
      this.closeSceneCallback);
  }

  public unregisterSceneMissionManagementCallback(): void {
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_TRANSITION, this.screenProperty.screenId,
      this.startSceneTransitionCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_FROM_RECENT, this.screenProperty.screenId,
      this.startSceneFromRecentCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_FROM_ICON, this.screenProperty.screenId,
      this.startSceneFromIconCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.ACTIVATE_SCENE, this.screenProperty.screenId,
      this.activateSceneCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.PAIR_SPLIT_FROM_DOCK, this.screenProperty.screenId,
      this.pairSplitFromDockCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      this.startSceneFromOtherCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_BYCALL, this.screenProperty.screenId,
      this.startSceneByCallCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.MINIMIZE_ALL_SCENE, this.screenProperty.screenId,
      this.minimizeAllSceneCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
      this.minimizeSceneCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.DESTROY_SCENE, this.screenProperty.screenId,
      this.destroySceneCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      this.terminateSceneCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId,
      this.closeSceneCallback);
  }

  private registerSceneStartingInterceptorRules(): void {
    SCBSceneStartInterceptor.getInstance().registerInterceptorRule(this.interceptRuleForProjection, this.screenId, this.panelId);
    SCBSceneStartInterceptor.getInstance().registerInterceptorRule(this.interceptRuleForMultiWindow, this.screenId, this.panelId);
    SCBSceneStartInterceptor.getInstance().registerInterceptorRule(this.interceptRuleForVassistant, this.screenId, this.panelId);
    SCBSceneStartInterceptor.getInstance().registerInterceptorRule(this.interceptRuleForPCAppInPhone, this.screenId, this.panelId);
  }

  private unregisterSceneStartingInterceptorRules(): void {
    SCBSceneStartInterceptor.getInstance().unregisterInterceptorRule(this.interceptRuleForProjection, this.screenId, this.panelId);
    SCBSceneStartInterceptor.getInstance().unregisterInterceptorRule(this.interceptRuleForMultiWindow, this.screenId, this.panelId);
    SCBSceneStartInterceptor.getInstance().unregisterInterceptorRule(this.interceptRuleForVassistant, this.screenId, this.panelId);
    SCBSceneStartInterceptor.getInstance().unregisterInterceptorRule(this.interceptRuleForPCAppInPhone, this.screenId, this.panelId);
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Start Interceptor rules
  // ----------------------------------------------------------------------------------------------------

  // 检查是否需要PC应用拦截
  private interceptRuleForPCAppInPhone = (sceneInfo: SCBSceneInfo, startFrom: StartInterceptions) => {
    return false;
  }

  // 检查是否需要投屏拦截
  private interceptRuleForProjection = (sceneInfo: SCBSceneInfo, startFrom: StartInterceptions) => {
    if (startFrom === StartInterceptions.FROM_ICON || startFrom === StartInterceptions.FROM_OTHER) {
      if (DeviceHelper.isPad() && SCBSceneSessionManager.getInstance().isProjectionBundleName(sceneInfo.bundleName)) {
        winLog.showWarn(`start ${startFrom} intercepted by Projection`);
        return true;
      }
    }
    return false;
  }

  // 检查是否需要多窗拦截
  private interceptRuleForMultiWindow = (sceneInfo: SCBSceneInfo, startFrom: StartInterceptions) => {
    return false;
  }

  // 检查是否需要语音助手拦截
  private interceptRuleForVassistant = (sceneInfo: SCBSceneInfo, startFrom: StartInterceptions) => {
    const result = SCBVassistantMissionHandler.getInstance().startInterceptor(sceneInfo, startFrom);
    if (result) {
      winLog.showWarn(`start ${startFrom} intercepted by Vassistant`);
    }
    return result;
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Mission Management
  // ----------------------------------------------------------------------------------------------------

  /**
   * Obtaining SCBSceneSession based on a persistent ID
   *
   * @param { Number } persistentId
   * @param { boolean } forActivation whether use cached SCBSceneSession for activation, avoid to use invalid instance.
   * @return { SCBSceneSession | null } Matched scenario session, or null if no matching scenario session is found.
   */
  public getSceneSessionByPersistentId(persistentId: number, forActivation: boolean = false): SCBSceneSession | null {
    let sceneSession = this.containerSessionList.getSceneSessionByPersistentId(persistentId, forActivation);
    if (sceneSession) {
      winLog.showInfo(`[SCBMain] getSceneSessionByPersistentId from containerSessionList id: ${persistentId}`);
      return sceneSession;
    }
    sceneSession = this.containerSessionListNotShowRecent.getSceneSessionByPersistentId(persistentId, forActivation);
    if (sceneSession) {
      winLog.showInfo(`[SCBMain] getSceneSessionByPersistentId from containerSessionListNotShowRecent id: ` +
        `${persistentId}`);
      return sceneSession;
    }
    let floatingSceneSessionList = this.floatingSessionList;
    let floatingListLen = floatingSceneSessionList.length;
    for (let i = 0; i < floatingListLen; ++i) {
      let floatingSceneSession = floatingSceneSessionList[i].primarySession;
      if (persistentId === floatingSceneSession?.session?.persistentId) {
        winLog.showInfo(`[SCBMain] getSceneSessionByPersistentId from floatingSceneSession id: ${persistentId}`);
        if (forActivation && !floatingSceneSession.isAvailable) {
          winLog.showError(`[SCBMain]getSceneSessionByPersistentId from floating list, but sceneSession unavailable.`);
          return null;
        }
        return floatingSceneSession;
      }
    }
    let container = this.getFloatSessionWithPersistentIdWhenInRecent(persistentId);
    if (container && container.primarySession) {
      return container.primarySession;
    }
    sceneSession = SCBSceneSessionManager.getInstance()
      .getSpecialContainerSessionList().getSceneSessionByPersistentId(persistentId, forActivation);
    if (sceneSession) {
      winLog.showInfo(`[SCBMain] getSceneSessionByPersistentId from SpecialContainerSessionList id: ${persistentId}`);
      return sceneSession;
    }

    winLog.showWarn('getSceneSessionByPersistentId find nothing, id ' + persistentId);
    return null;
  }

  /**
   * Obtaining SCBSceneContainerSession based on a persistent ID
   *
   * @param { Number } persistentId
   * @return { SCBSceneContainerSession | null } Matched SCBSceneContainerSession,
   * or null if no matching scenario session is found.
   */
  public getFloatSessionWithPersistentIdWhenInRecent(persistentId: number): SCBSceneContainerSession | null {
    return null;
  }

  /**
   * link to the callerSession and toSession of input session.
   *
   * @param { SCBSceneSession } session
   * @return { void }
   */
  public linkCallerAndToPersistentForSession(session: SCBSceneSession): void {
    if (!session || !session.sceneInfo) {
      winLog.showWarn('linkCallerAndToPersistentForSession, session is null or scene info is null.');
      return;
    }
    winLog.showInfo(`linkCallerAndToPersistentForSession, callerId=${session.sceneInfo.callerPersistentId}` +
      `, toId=${session.sceneInfo.toPersistentId}`);
    if (session.sceneInfo.callerPersistentId && session.sceneInfo.callerPersistentId > 0) {
      let callerSession = this.getSceneSessionByPersistentId(session.sceneInfo.callerPersistentId);
      if (callerSession && callerSession.sceneInfo) {
        callerSession.sceneInfo.toPersistentId = session.sceneInfo.toPersistentId;
      }
    }
    if (session.sceneInfo.toPersistentId && session.sceneInfo.toPersistentId > 0) {
      let toSession = this.getSceneSessionByPersistentId(session.sceneInfo.toPersistentId);
      if (toSession && toSession.sceneInfo) {
        toSession.sceneInfo.callerPersistentId = session.sceneInfo.callerPersistentId;
      }
    }
    session.sceneInfo.callerPersistentId = 0;
    session.sceneInfo.toPersistentId = 0;
  }

  /**
   * Update newCallerPersistentId to the caller of the session.
   *
   * @param { SCBSceneSession } session
   * @param { Number } newCallerPersistentId
   * @return { void }
   */
  public updateCallerSessionIdAndToSessionId(session: SCBSceneSession | null, newCallerPersistentId: number): void {
    if (!session || !session.sceneInfo) {
      winLog.showWarn('set caller persistentId, but null session or scene info.');
      return;
    }
    if (session.isActive && newCallerPersistentId === session.sceneInfo.persistentId) {
      winLog.showWarn(`updateCallerSessionIdAndToSessionId:session is already active and ` +
        `newCallerpersistentId:${newCallerPersistentId} equal` +
        ` session persistentId:${session.sceneInfo.persistentId}. No need updateCallerPersistentId.`);
      return;
    }
    winLog.showInfo(`updateCallerInfo, persistentId:${session.sceneInfo.persistentId}, ` +
      `oldCallerId:${session.sceneInfo.callerPersistentId}, newCallerId:${newCallerPersistentId}, ` +
      `toId:${session.sceneInfo.toPersistentId}.`);
    if (newCallerPersistentId !== session.sceneInfo.callerPersistentId ||
      (newCallerPersistentId === session.sceneInfo.callerPersistentId && session.sceneInfo.toPersistentId !== 0)) {
      // from get session, reused
      this.linkCallerAndToPersistentForSession(session);
    }

    let newCallerId = newCallerPersistentId;
    let newCallerSession: SCBSceneSession | null = this.getSceneSessionByPersistentId(newCallerId);
    let oldCallerSession: SCBSceneSession | null = null;
    let newCallerContainer : SCBSceneContainerSession | null = this.getSceneContainerSessionWithPersistentId(newCallerId);
    let size = 0;
    let totalListSize = this.containerSessionList.length + this.containerSessionListNotShowRecent.length;
    while (newCallerId > 0 && newCallerId !== session.sceneInfo.persistentId && size <= totalListSize) {
      winLog.showDebug('getSceneSessionByPersistentId = ' + newCallerId);
      if (newCallerSession && newCallerSession.sceneInfo && this.isNeedUpdateCallerInfo(newCallerContainer)) {
        newCallerId = newCallerSession.sceneInfo.toPersistentId;
      } else {
        break;
      }
      oldCallerSession = newCallerSession;
      newCallerContainer = this.getSceneContainerSessionWithPersistentId(newCallerId);
      if (!this.isNeedUpdateCallerInfo(newCallerContainer) ||
        !(newCallerId > 0 && newCallerId !== session.sceneInfo.persistentId && size <= totalListSize)) {
        break;
      }
      newCallerSession = this.getSceneSessionByPersistentId(newCallerId);
      size++;
    }
    // refresh new caller session
    if (newCallerSession && newCallerSession.sceneInfo) {
      newCallerSession.sceneInfo.toPersistentId = session.sceneInfo.persistentId;
      session.sceneInfo.callerPersistentId = newCallerSession.sceneInfo.persistentId;
    } else {
      session.sceneInfo.callerPersistentId = oldCallerSession?.sceneInfo.persistentId ?? 0;
      if (oldCallerSession) {
        oldCallerSession.sceneInfo.toPersistentId = session.sceneInfo.persistentId;
      }
    }
    winLog.showInfo(`updateCallerInfo, newCallerId:${session.sceneInfo.callerPersistentId}.`);
    // refresh self
    session.sceneInfo.toPersistentId = 0;
  }

  private isNeedUpdateCallerInfo(newCallerContainer: SCBSceneContainerSession | null): boolean {
    let isNeedUpdateCallerInfo: boolean = true;
    if (newCallerContainer) {
      isNeedUpdateCallerInfo = !newCallerContainer.isSplit && !newCallerContainer.isFloat;
    }
    winLog.showInfo(`newCallerContainer bundlename = ${newCallerContainer?.getBundleName()}, isNeedUpdateCallerInfo = ${isNeedUpdateCallerInfo}`);
    return isNeedUpdateCallerInfo;
  }

  /**
   * Get floatingSceneSession by persistentId.
   *
   * @param { Number } newCallerPersistentId
   * @return { SCBSceneSession | nul } Matched session, or null if no matching session is found.
   */
  public getFloatSessionWithPersistentId(persistentId: number): SCBSceneSession | null {
    let floatingSessionList = this.floatingSessionList;
    if (floatingSessionList && floatingSessionList?.length > 0) {
      for (let i = 0; i < floatingSessionList?.length; i++) {
        if (floatingSessionList[i].primarySession?.sceneInfo.persistentId === persistentId) {
          return floatingSessionList[i].primarySession;
        }
      }
    }
    return null;
  }

  /**
   * 应用迁移时，根据scbSceneSession与sceneInfo关闭手机侧画中画窗口
   *
   * @param scbSceneSession 迁移应用
   * @param sceneInfo 迁移信息
   * @returns void
   */
  public closePiP(scbSceneSession: SCBSceneSession, sceneInfo: SCBSceneInfo) {
    if(!scbSceneSession || !sceneInfo) {
      winLog.showError('invalid sceneSession or sceneInfo')
      return;
    }
    SCBSceneSessionManager.getInstance().closePiP(scbSceneSession);
    if (SCBPiPManager.getInstance().isPiPForbidden(sceneInfo)) {
      winLog.showInfo('close autostart');
      scbSceneSession.restorePiPStatus = scbSceneSession.isAutoStartPiP;
      scbSceneSession.isAutoStartPiP = false;
    }
  }

  /**
   * 根据persistentId获取sceneSession，设置其toPersistentId为0
   *
   * @param persistentId 窗口id
   * @returns void
   */
  public clearToPersistentIdForSession(persistentId: number): void {
    winLog.showInfo('clear session to persistentId for ' + persistentId);
    if (persistentId > 0) {
      let session = this.getSceneSessionByPersistentId(persistentId);
      if (session && session.sceneInfo) {
        session.sceneInfo.toPersistentId = 0;
        winLog.showInfo('clear session toPersistentId = 0 for ' + persistentId);
      }
    }
  }

  /**
   * 根据persistentId获取sceneSession，设置其callerPersistentId为0
   *
   * @param persistentId 窗口id
   * @returns void
   */
  public clearCallerPersistentIdForSession(persistentId: number): void {
    winLog.showInfo('clear session caller persistentId for ' + persistentId);
    if (persistentId > 0) {
      let session = this.getSceneSessionByPersistentId(persistentId);
      if (session && session.sceneInfo) {
        session.sceneInfo.callerPersistentId = 0;
        winLog.showInfo('clear session callerPersistentId = 0 for ' + persistentId);
      }
    }
  }

  /**
   * 获取单个应用所有SCBSceneSession对象
   *
   * @param sceneInfo 窗口信息
   * @returns SCBSceneSessionArray
   */
  public getAllSceneSessionInOneApp(sceneInfo: SCBSceneInfo): SCBSceneSessionArray {
    let sceneSessionArray: SCBSceneSessionArray = new SCBSceneSessionArray();
    sceneSessionArray = sceneSessionArray.concat(this.containerSessionList.getSceneSessionWithoutAbilityName(sceneInfo));
    sceneSessionArray = sceneSessionArray.concat(this.floatingSessionList.getSceneSessionWithoutAbilityName(sceneInfo));
    sceneSessionArray = sceneSessionArray.concat(this.containerSessionListNotShowRecent.getSceneSessionWithoutAbilityName(sceneInfo));
    sceneSessionArray = sceneSessionArray.concat(SCBSceneSessionManager.getInstance().getSpecialContainerSessionList()
      .getSceneSessionWithoutAbilityName(sceneInfo));
    winLog.showInfo(`getAllSceneSessionInOneApp:bundleName:${sceneInfo.bundleName}, ` +
      `moduleName:${sceneInfo.moduleName}, appIndex:${sceneInfo.appIndex}. ` +
      `Get sceneSession count:${sceneSessionArray.length}`);
    return sceneSessionArray;
  }

  /**
   * 获取最近使用的SCBSceneSession
   *
   * @param sceneInfo 窗口信息
   * @returns SCBSceneSession | null
   */
  public findRecentUsedSceneSession(sceneArray: SCBSceneSessionArray | null,
    launchAbilityName: string): SCBSceneSession | null {
    if (sceneArray === null || sceneArray.length === 0) {
      return null;
    }
    const sortedArray = sceneArray.slice().sort((preScene: SCBSceneSession,
      nextScene: SCBSceneSession) => nextScene.lastUsedTimestamp - preScene.lastUsedTimestamp);
    return this.findStartLauncherAbilitySession(sortedArray.filter(session => session.lastUsedTimestamp === 0),
      launchAbilityName) ?? sortedArray[0];
  }

  /**
   * 如果有多个最大值且为0, 为该应用进程被查杀场景，本次图标启动需要启动LauncherAbility
   *
   * @param zeroArray lastUsedTimestamp为0的sceneSession数组
   * @param launchAbilityName 点击图标默认启动的abilityName
   * @returns SCBSceneSession | null
   */
  public findStartLauncherAbilitySession(zeroArray: SCBSceneSessionArray,
    launchAbilityName: string): SCBSceneSession | null {
      if (zeroArray.length === 0 || zeroArray[0].lastUsedTimestamp > 0 || launchAbilityName === "") {
        winLog.showInfo(`Not need findStartLauncherAbilitySession.`);
        return null;
      }
      for (let session of zeroArray) {
        if (session.sceneInfo.abilityName === launchAbilityName) {
          winLog.showInfo(`findStartLauncherAbilitySession, all ability has been terminate, ` +
            `return launcherAbility name: ${launchAbilityName}, id:${session.sceneInfo.persistentId}`);
          return session;
        }
      }
      return null;
  }

  /**
   * 获取SCBSceneSession
   *
   * @param sceneInfo 窗口信息
   * @returns SCBSceneSession | null
   */
  public getSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    let sceneSessionTuple = this.containerSessionList.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (sceneSessionTuple && sceneSessionTuple[0]) {
      winLog.showInfo(`getSceneSession name: ${sceneSessionTuple[0].getName()} from fullscene list`);
      return sceneSessionTuple[0];
    }

    sceneSessionTuple = this.floatingSessionList.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (sceneSessionTuple && sceneSessionTuple[0]) {
      winLog.showInfo(`getSceneSession name: ${sceneSessionTuple[0].getName()} from floatscene list`);
      return sceneSessionTuple[0];
    }

    sceneSessionTuple = this.containerSessionListNotShowRecent.getSceneSessionTupleBySceneInfo(sceneInfo, false);
    if (sceneSessionTuple && sceneSessionTuple[0]) {
      winLog.showInfo(`getSceneSession name: ${sceneSessionTuple[0].getName()} from notShowRecent list`);
      if (SCBSceneSessionManager.getInstance().isSceneSessionValid(sceneSessionTuple[0].session)) {
        return sceneSessionTuple[0];
      }
      winLog.showWarn(`SceneSession is invalid, name: ${sceneSessionTuple[0].getName()}`);
      this.panelMgr.removeNotShowRecentSession(sceneSessionTuple[1]);
      return null;
    }

    const specialContainerSessionList = SCBSceneSessionManager.getInstance().getSpecialContainerSessionList();
    sceneSessionTuple = specialContainerSessionList.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (sceneSessionTuple && sceneSessionTuple[0]) {
      winLog.showInfo(`getSceneSession name: ${sceneSessionTuple[0].getName()} from specialscene list`);
      return sceneSessionTuple[0];
    }
    winLog.showWarn('getSceneSession find nothing, ' + sceneInfo?.toJsonString());
    return null;
  }

  public succeedBackToCaller(containerSession: SCBSceneContainerSession, persistentId: number): boolean {
    const sceneSession: SCBSceneSession | null = containerSession.findSceneSessionByPersistentId(persistentId);
    let callerPersistentId: number | undefined = sceneSession?.sceneInfo?.callerPersistentId;
    homeLog.showInfo(`[SCBMain][id:${persistentId}]try to backToCaller, callerPersistentId:${callerPersistentId}`);
    if (SCBKioskModeManager.getInstance().isKioskMode() &&
      (callerPersistentId === undefined || callerPersistentId === 0)) {
      callerPersistentId = SCBKioskModeManager.getInstance().getDefaultCallerPersistentId();
      homeLog.showInfo(`no caller in kiosk mode, use default caller:${callerPersistentId}`);
    }
    if (callerPersistentId !== undefined && callerPersistentId !== 0) {
      let callerContainerSession: SCBSceneContainerSession | null =
        this.getSceneContainerSessionWithPersistentId(callerPersistentId);
      if (callerContainerSession?.primarySession?.isPcAppInPad &&
      callerContainerSession?.primarySession?.sceneInfo.isHide) {
        callerContainerSession = this.getCallerContainerSession(callerContainerSession.primarySession.sceneInfo);
      }
      if (callerContainerSession !== null && callerPersistentId !== persistentId &&
        !callerContainerSession.isTerminating) {
        if (callerContainerSession.isActive) {
          return false;
        }
        if (this.isExternalScreenInterceptedCheckAllSession(callerContainerSession, false)) {
          return false;
        }
        if (sceneSession?.sceneInfo?.isPhoneCall()) {
          this.panelMgr.raiseSceneToTop(callerContainerSession);
          callerContainerSession.requestActivation(false);
          this.startSceneWithRotationIfNeed(callerContainerSession);
          this.sceneContainerTransitionForPhoneCall(containerSession, callerContainerSession, true, false, false);
        } else if (containerSession.isFloat && sceneSession && callerContainerSession.primarySession?.sceneInfo) {
          this.panelMgr.raiseSceneToTop(callerContainerSession);
          callerContainerSession.requestActivation(false);
        } else if (containerSession.isSplit && sceneSession && callerContainerSession.primarySession?.sceneInfo) {
          this.panelMgr.raiseSceneToTop(callerContainerSession);
          callerContainerSession.requestActivation(false);
        } else {
          homeLog.showInfo(`[SCBMain][id:${persistentId}]succeedBackToCaller ` +
            `callerContainerSession ${callerContainerSession.getName()}`);
          this.panelMgr.raiseSceneToTop(callerContainerSession);
          this.startSceneWithRotationIfNeed(callerContainerSession);
          callerContainerSession.requestActivation(false);
          this.panelAnimator.sceneContainerAppTransitionChange(containerSession, callerContainerSession, true, false, false);
        }

        this.clearCallerPersistentIdForSession(persistentId);
        this.clearToPersistentIdForSession(callerPersistentId);
        return true;
      }
    }
    return false;
  }

  public onRootSceneStartByCall(toInfo: SCBSceneInfo): CommonResult {
    let toSceneSession = this.requestSceneSession(toInfo);
    if (toSceneSession === null) {
      homeLog.showError('Failed to get toSceneSession: ' + toInfo?.toJsonString());
      return CommonResult.FAIL;
    }
    let isFirstCall = false;
    let toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      isFirstCall = true;
    }
    homeLog.showInfo(`onRootSceneStartByCall isFirstCall:${isFirstCall} toInfo.callState:${toInfo.callState} ` +
      `scenePanelState ${this.stateCollectionHandler?.getPanelState()}`);
    if (isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.panelMgr.addSceneContainerSession(toContainerSession);
      this.startSceneWithRotationIfNeed(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.panelMgr.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE)
      toSceneSession.sessionData.isNewWant = true;
    } else if (isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      this.panelMgr.addNotShowRecentSession(toContainerSession);
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
    } else if (!isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.panelMgr.removeNotShowRecentSession(toContainerSession);
      this.panelMgr.addSceneContainerSession(toContainerSession);
      this.startSceneWithRotationIfNeed(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.panelMgr.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
      toSceneSession.sessionData.isNewWant = true;
    } else if (!isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      let activeContainerSession = this.containerSessionList.getTopActiveSession();
      // 默认为false，若toContainerSession已在前台，即使要求后台拉起，也不能让toContainerSession下树
      toContainerSession.requestActivationByCall(
        toContainerSession.getPersistentId() === activeContainerSession?.getPersistentId());
      toSceneSession.sessionData.isNewWant = true;

      // if a full scene before screen locked, was requested to run background during screen locked,
      // enter home here or blur appears when unlocked.
      if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE &&
        SCBSceneSessionManager.getInstance().isScreenLocked() &&
        toSceneSession.session.persistentId === activeContainerSession?.primarySession?.session.persistentId &&
        !this.containerSessionList.getTopActiveSession()) {
        homeLog.showInfo('onRootSceneStartByCall: call state background same scene during screen locked');
        this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      }
    } else {
      homeLog.showInfo('onRootSceneStartByCall error callState');
    }
    return CommonResult.SUCCESS;
  }

  private onBackgroundSceneLoadCaller(isActive: boolean, persistentId?: number): void {
    homeLog.showInfo(`onBackgroundSceneLoadCaller active:${isActive} persistentId:${persistentId}`);
    if (!persistentId) {
      homeLog.showWarn('onBackgroundSceneLoadCaller persistentId is null');
      return;
    }
    let containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (containerSession == null) {
      homeLog.showWarn(`onBackgroundSceneLoadCaller containerSession is null, persistentId=${persistentId}`);
      return;
    }
    homeLog.showInfo(`onBackgroundSceneLoadCaller containerSession active:${containerSession.isActive} persistentId:${persistentId}`);
    if (!isActive) {
      homeLog.showWarn(`onBackgroundSceneLoadCaller is not active persistentId:${persistentId}`);
      return;
    }
    if (containerSession.primarySession?.session.persistentId === persistentId) {
      let callerPersistentId = containerSession.primarySession.sceneInfo.callerPersistentId;
      this.onStartSceneFromRecent(callerPersistentId);
    } else if (containerSession?.secondarySession?.session.persistentId === persistentId) {
      let callerPersistentId = containerSession.secondarySession.sceneInfo.callerPersistentId;
      this.onStartSceneFromRecent(callerPersistentId);
    }
  }

  public sceneContainerDestructionWithoutAnimation(containerSession: SCBSceneContainerSession,
    needRemoveSession: boolean, isForceClean: boolean = false): void {
    containerSession?.requestDestructionWithTransitionOut(needRemoveSession, false, false, isForceClean);
    if (containerSession?.pendingRemove && needRemoveSession) {
      this.panelMgr.removeSceneContainerSession(containerSession);
    }
  }

  private onDestroyScene = (persistentId?: number, containerId?: number): void => {
    homeLog.showWarn(`[SCBMain]onDestroyScene with persistentId:${persistentId} containerId:${containerId}`);
    let containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (containerSession) {
      containerSession.requestDestruction(true);
    }

    this.panelMgr.removeSceneContainerSession(containerSession);
    if (this.containerSessionList.length === 0) {
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
    }
  }

  public onMinimizeScene = (persistentId?: number, containerId?: number, opts?: SCBMinimizeSceneOpts): void => {
    homeLog.showInfo(`[SCBMain][id:${persistentId}]onMinimizeScene, containerId:${containerId}` +
      ` shouldBackToCaller:${opts?.shouldBackToCaller}`);
    let containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!persistentId || !containerSession) {
      homeLog.showError(`[SCBMain][id:${persistentId}]onMinimizeScene cannot find containerSession.`);
      return;
    }
    if (!containerSession.isActive) {
      homeLog.showWarn(`[SCBMain][id:${persistentId}]onMinimizeScene containerSession already background: ${containerSession.getName()}`);
      return;
    }
    if (recentViewModel.onMinimizeScene(containerSession)) {
      homeLog.showInfo(`[SCBMain][id:${persistentId}]onMinimizeScene in recentState`);
      containerSession.requestBackground();
      return;
    }
    // one step split view exit
    if (this.dataCollectionHandler?.getOneStepSplitExitFlag() &&
      containerSession.containerId === this.dataCollectionHandler?.getOneStepSplitContainerID()) {
      homeLog.showInfo(`[SCBMain][id:${persistentId}]onMinimizeScene oneStepSplitExitFlag in`);
      this.dataCollectionHandler?.setOneStepSplitExitFlag(false);
      containerSession.dividerParam.init();
      containerSession.needRenderVisibility.setVisibilityWithDfx(false,
        TAG, 'doBreakMaxSplitViewAnimation', containerSession.getName());
      containerSession.requestBackground();
      this.dataCollectionHandler?.setOneStepSplitContainerID(-1);
      return;
    }

    homeLog.showInfo(`[SCBMain][id:${persistentId}]onMinimizeScene container:${containerSession.getName()} ` +
      `isSplit:${containerSession.isSplit}, isFloat:${containerSession.isFloat}, isMidScene:${containerSession.isMidScene}`);
    this.quickSwitchAnimations.interruptQuickSwitchAnimationWhenExitApp(containerSession.containerId);
    if (containerSession.isSplit) {
      this.minimizeSplitScene(containerSession, persistentId);
    } else if (containerSession.isFloat && containerSession.primarySession) {
      const callerPersistentId = containerSession.mainSession.sceneInfo.callerPersistentId;
      if (callerPersistentId && callerPersistentId !== 0) {
        let fromContainerSession = this.getSceneContainerSessionWithPersistentId(callerPersistentId);
        let fromSceneInfo = containerSession.mainSession?.sceneInfo;
        let toSceneInfo = fromContainerSession?.mainSession.sceneInfo;
        if (fromContainerSession && fromSceneInfo && toSceneInfo) {
          this.succeedBackToCaller(containerSession, persistentId);
        }
      }
    } else {
      if (opts?.shouldBackToCaller && this.succeedBackToCaller(containerSession, persistentId)) {
        homeLog.showInfo(`[SCBMain][id:${persistentId}]onMinimizeScene succeed back to caller`);
        let sceneSession = containerSession.findSceneSessionByPersistentId(persistentId);
        if (sceneSession !== null && sceneSession.sceneInfo.additionalCallers.length !== 0) {
          this.startAdditionalCallers(sceneSession.sceneInfo.additionalCallers);
          this.clearAdditionalCallers(sceneSession);
        }
        return;
      }
      if (uiType === SCBConstants.UITYPE_PAD && this.isRecentState()) {
        containerSession.showInRecent = true;
        containerSession.requestBackground();
        return;
      }
      performanceMonitor.begin("LAUNCHER_APP_BACK_TO_HOME", performanceMonitor.ActionType.LAST_UP,
        containerSession.companionIconInfo?.bundleName);
      this.publishScenePanelEventMsg(CEManager.CUSTOM_BACK_HOME_EVENT, ReturnDesktopEventType.BACK_TO_HOME);
      containerSession.setAnimatingReason(WindowAnimationReason.MINIMIZE);
      // 显示壁纸，避免桌面黑屏
      this.showWallpaperAfterRotate();
      this.requestSceneContainerBackgroundWithTransition(containerSession);
      let sceneSession = containerSession.findSceneSessionByPersistentId(persistentId);
      if (sceneSession !== null && sceneSession.sceneInfo.additionalCallers.length !== 0) {
        this.startAdditionalCallers(sceneSession.sceneInfo.additionalCallers);
        this.clearAdditionalCallers(sceneSession);
      }
      this.updateScenePanelState(ScenePanelState.HOME);
      this.stateCollectionHandler?.getRecentInnerState().onInit();
    }
  }

  /**
   * 判断sessionException场景下是否需要返回调用方
   *
   * @param persistentId sessionException的窗口id
   * @returns boolean 需要返回调用方返回true，否则反之
   */
  public needStartCallerFromException(persistentId?: number): boolean {
    let sceneSession: SCBSceneSession | null = this.getSceneSessionByPersistentId(persistentId ?? 0, true);
    if (!sceneSession) {
      winLog.showError(`needStartCallerFromException cannot find sceneSession with persistentId=${persistentId}`);
      return true;
    }
    let sceneInfo = sceneSession.sceneInfo;
    let callerContainerSession: SCBSceneContainerSession | null = sceneInfo.callerPersistentId ?
    this.getSceneContainerSessionWithPersistentId(sceneInfo.callerPersistentId) : null;
    if (callerContainerSession != null) {
      if (callerContainerSession.primarySession?.sceneInfo.bundleName === sceneInfo.bundleName &&
        callerContainerSession.primarySession?.sceneInfo.appIndex === sceneInfo.appIndex) {
        return false;
      }
      if (callerContainerSession.secondarySession?.sceneInfo.bundleName === sceneInfo.bundleName &&
        callerContainerSession.secondarySession?.sceneInfo.appIndex === sceneInfo.appIndex) {
        return false;
      }
    }
    return true;
  }

  /**
   * 根据scbSceneSession的persistentId获取scbContainerSession
   *
   * @param persistentId session的id
   * @returns SCBSceneContainerSession | null
   */
  public getSceneContainerSessionWithPersistentId(persistentId: number): SCBSceneContainerSession | null {
    winLog.showDebug('getSceneContainerSessionWithPersistentId with session id: ' + persistentId);
    let sceneContainerSession = this.containerSessionList.findByPersistentId(persistentId);
    if (sceneContainerSession) {
      winLog.showInfo('getSceneContainerSessionWithPersistentId from containerSessionList id: ' + persistentId);
      return sceneContainerSession;
    }
    sceneContainerSession = this.floatingSessionList.findByPersistentId(persistentId);
    if (sceneContainerSession) {
      winLog.showInfo('getSceneContainerSessionWithPersistentId from floatingSessionList id: ' + persistentId);
      return sceneContainerSession;
    }
    sceneContainerSession = this.containerSessionListNotShowRecent.findByPersistentId(persistentId);
    if (sceneContainerSession) {
      winLog.showInfo('getSceneContainerSessionWithPersistentId from SessionListNotShowRecent id: ' + persistentId);
      return sceneContainerSession;
    }

    winLog.showWarn('Failed to get scene containerSession with session id: ' + persistentId);
    return null;
  }

  /**
   * 清理primarySession和secondarySession的调用链上游
   *
   * @param SCBSceneContainerSession 要清理的窗口ContainerSession
   * @returns void
   */
  public deleteCallerChainForContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    this.deleteCallerChainForSceneSession(sceneContainerSession.primarySession?.sceneInfo);
    this.deleteCallerChainForSceneSession(sceneContainerSession.secondarySession?.sceneInfo);
  }

  /**
   * 清理调用链上游，设置上游的toPersistentId为0，设置自己的callerPersistentId为0
   *
   * @param SCBSceneContainerSession 要清理的窗口ContainerSession
   * @returns void
   */
  public deleteCallerChainForSceneSession(sceneInfo: SCBSceneInfo | undefined): void {
    if (!sceneInfo) {
      return;
    }
    if (sceneInfo.callerPersistentId) {
      this.clearToPersistentIdForSession(sceneInfo.callerPersistentId);
    }
    this.clearCallerPersistentIdForSession(sceneInfo.persistentId);
  }

  /**
   * 清理primarySession和secondarySession的调用链下游
   *
   * @param SCBSceneContainerSession 要清理的窗口ContainerSession
   * @returns void
   */
  public deleteToChainForContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    this.deleteToChainForSceneSession(sceneContainerSession.primarySession?.sceneInfo);
    this.deleteToChainForSceneSession(sceneContainerSession.secondarySession?.sceneInfo);
  }

  /**
   * 清理调用链下游，设置下游的callerPersistentId为0，设置自己的toPersistentId为0
   *
   * @param SCBSceneContainerSession 要清理的窗口ContainerSession
   * @returns void
   */
  public deleteToChainForSceneSession(sceneInfo: SCBSceneInfo | undefined): void {
    if (!sceneInfo) {
      return;
    }
    if (sceneInfo.toPersistentId) {
      this.clearCallerPersistentIdForSession(sceneInfo.toPersistentId);
    }
    this.clearToPersistentIdForSession(sceneInfo.persistentId);
  }

  /**
   * 从FloatSessionList根据persistentId查找sceneSession
   *
   * @param persistentId 窗口id
   * @returns SCBSceneSession | null
   */
  public getFloatSceneSessionByPersistentId(persistentId: number): SCBSceneSession | null {
    let floatContainerSession = this.getFloatSessionWithPersistentIdWhenInRecent(persistentId);
    let floatingSession = this.getFloatSessionWithPersistentId(persistentId);
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.RECENT && floatContainerSession !== null) {
      return floatContainerSession?.primarySession;
    }
    return floatingSession;
  }

  /**
   * 从锁屏之上根据persistentId查找containerSession
   *
   * @param persistentId 窗口id
   * @returns SCBSceneContainerSession | null
   */
  public getSpecialContainerSessionById(persistentId: number): SCBSceneContainerSession | null {
    winLog.showInfo(`Get containerSession with id:${persistentId} from special scene list`);
    return SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().findByPersistentId(persistentId);
  }

  /**
   * 向锁屏之上list添加containerSession
   *
   * @param SCBSceneContainerSession
   * @returns void
   */
  public addSpecialContainerSession(containerSession: SCBSceneContainerSession): void {
    let addSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    addSessionList.add(containerSession);
    SCBSceneSessionManager.getInstance().onAddSpecialContainerSession(addSessionList);
  }

  /**
   * 根据persistentId查找containerSession
   *
   * @param persistentId 窗口id
   * @returns SCBSceneContainerSession | null
   */
  public getContainerSessionById(persistentId: number): SCBSceneContainerSession | null {
    return this.getSceneContainerSessionWithPersistentId(persistentId) ??
    this.getSessionFromFloatingScene(persistentId) ??
    this.getSpecialContainerSessionById(persistentId);
  }

  /**
   * 从FloatSessionList根据persistentId查找containerSession
   *
   * @param persistentId 窗口id
   * @returns SCBSceneContainerSession | null
   */
  public getSessionFromFloatingScene(persistentId: number): SCBSceneContainerSession | null {
    let floatingSceneSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    let index = floatingSceneSessionList.findIndex((item) => {
      return item.primarySession?.session?.persistentId === persistentId;
    });
    if (index !== -1) {
      return floatingSceneSessionList[index];
    }
    winLog.showWarn('Failed to getSessionFromFloatingScene with session id: ' + persistentId);
    return null;
  }

  /**
   * 最大打开应用数量限制
   * 系统设置了max_session_limit_one_ability,需先销毁旧应用
   * 打开MAX_SESSION_LIMIT_ALL_APP个应用后再打开应用，需先销毁旧应用
   *
   * @param sceneInfo 窗口信息
   * @returns void
   */
  public isReachMaxSessionNum(sceneInfo: SCBSceneInfo): void {
    const maxSessionLimitOneApp = Number.parseInt(
      systemParameter.getSync(this.MAX_SESSION_LIMIT_ONE_APP, '0'));
    if (maxSessionLimitOneApp > 0) {
      const sameBundleFunc = (item: SCBSceneSession) => sceneInfo.isSameBundleWithMultiApp(item?.sceneInfo);
      const targetSessionCountAndOldestSession = this.getTargetContainerSessionCountAndOldestTarget(sameBundleFunc);
      if (targetSessionCountAndOldestSession[0] >= maxSessionLimitOneApp) {
        homeLog.showWarn('isReachMaxSessionNum: app(%{public}s) session num is over %{public}d', sceneInfo.bundleName,
          maxSessionLimitOneApp);
        const oldestContainerSession: SCBSceneContainerSession | null = targetSessionCountAndOldestSession[1];
        this.closeOldestSceneSession(oldestContainerSession as SCBSceneContainerSession, sameBundleFunc);
      }
    }

    const totalLen = this.containerSessionList.length + this.containerSessionListNotShowRecent.length +
    this.floatingSessionList.length;
    if (totalLen >= this.MAX_SESSION_LIMIT_ALL_APP) {
      homeLog.showWarn('isReachMaxSessionNum: all session num is over %{public}d', this.MAX_SESSION_LIMIT_ALL_APP);
      let oldestContainerSession = this.getOldestContainerSession(this.containerSessionList[0],
        this.containerSessionListNotShowRecent[0]);
      oldestContainerSession = this.getOldestContainerSession(oldestContainerSession, this.floatingSessionList[0]);

      this.closeOldestContainerSession(oldestContainerSession as SCBSceneContainerSession);
    }
  }

  /**
   * 获取打开应用数量
   *
   * @param filterFunction 过滤条件函数
   * @returns [number, SCBSceneContainerSession | null]
   */
  private getTargetContainerSessionCountAndOldestTarget(filterFunction: Function):
    [number, SCBSceneContainerSession | null] {
    let oldestContainerSession: SCBSceneContainerSession | null = null;
    let containerSessionCount = 0;
    let targetCountAndFirstTarget = this.containerSessionList.getTargetSessionCountAndFirstContainer(filterFunction);

    containerSessionCount += targetCountAndFirstTarget[0];
    oldestContainerSession = this.getOldestContainerSession(oldestContainerSession, targetCountAndFirstTarget[1]);

    targetCountAndFirstTarget = this.containerSessionListNotShowRecent.getTargetSessionCountAndFirstContainer(
      filterFunction);
    containerSessionCount += targetCountAndFirstTarget[0];
    oldestContainerSession = this.getOldestContainerSession(oldestContainerSession, targetCountAndFirstTarget[1]);

    targetCountAndFirstTarget = this.floatingSessionList.getTargetSessionCountAndFirstContainer(filterFunction);
    containerSessionCount += targetCountAndFirstTarget[0];
    oldestContainerSession = this.getOldestContainerSession(oldestContainerSession, targetCountAndFirstTarget[1]);

    return [containerSessionCount, oldestContainerSession];
  }

  /**
   * 获取最老的一个应用ContainerSession
   *
   * @param prev 旧containerSession
   * @param cur 新containerSession
   * @returns SCBSceneContainerSession | null
   */
  private getOldestContainerSession(prev: SCBSceneContainerSession | null,
    cur: SCBSceneContainerSession | null): SCBSceneContainerSession | null {
    if (prev && cur) {
      return prev.getLastUsedTimestamp() < cur.getLastUsedTimestamp() ? prev : cur;
    }
    return prev ?? cur;
  }

  /**
   * 销毁最老的一个应用SceneSession
   *
   * @param oldestContainerSession 旧containerSession
   * @param filterFunction 过滤条件函数
   * @returns void
   */
  private closeOldestSceneSession(oldestContainerSession: SCBSceneContainerSession, filterFunction: Function): void {
    let oldestSession: SCBSceneSession;
    if (filterFunction(oldestContainerSession?.primarySession)) {
      oldestSession = oldestContainerSession?.primarySession as SCBSceneSession;
    } else {
      oldestSession = oldestContainerSession?.secondarySession as SCBSceneSession;
    }
    if (oldestSession.isInSplit()) {
      oldestSession.needDestructedInSplit = true;
    }
    homeLog.showWarn('Close oldest scene session, persistentId:%{public}d', oldestSession.sceneInfo.persistentId);
    SCBSceneSessionManager.getInstance().close(oldestSession.sceneInfo.screenId, oldestSession.sceneInfo.persistentId);
  }

  /**
   * 销毁最老的一个应用containerSession
   *
   * @param containerSession
   * @returns void
   */
  private closeOldestContainerSession(containerSession: SCBSceneContainerSession): void {
    if (containerSession.primarySession) {
      if (containerSession.primarySession.isInSplit()) {
        containerSession.primarySession.needDestructedInSplit = true;
      }
      homeLog.showWarn('Close oldest container session, primarySession persistentId:%{public}d',
        containerSession.primarySession.sceneInfo.persistentId);
      SCBSceneSessionManager.getInstance().close(containerSession.primarySession.sceneInfo.screenId,
        containerSession.primarySession.sceneInfo.persistentId);
    }
    if (containerSession.secondarySession) {
      if (containerSession.secondarySession.isInSplit()) {
        containerSession.secondarySession.needDestructedInSplit = true;
      }
      homeLog.showWarn('Close oldest container session, secondarySession persistentId:%{public}d',
        containerSession.secondarySession.sceneInfo.persistentId);
      SCBSceneSessionManager.getInstance().close(containerSession.secondarySession.sceneInfo.screenId,
        containerSession.secondarySession.sceneInfo.persistentId);
    }
  }

  /**
   * 创建新的SCBSceneSession
   *
   * @param sceneInfo 要新建SCBSceneSession所需的SCBSceneInfo
   * @returns SCBSceneSession | null
   */
  public requestNewSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    winLog.showWarn('[SCBMain][id:%{public}d][sceneInfo:%{public}s/%{public}s/%{public}s/%{public}d]' +
      '[screenId:%{public}d]request New SceneSession.', sceneInfo.persistentId, sceneInfo.bundleName,
      sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.appIndex, sceneInfo.screenId);
    this.isReachMaxSessionNum(sceneInfo);
    try {
      let sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
      if (sceneSession === null) {
        winLog.showWarn('requestNewSession return null');
        return null;
      }
      let scbSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
      if (scbSceneSession.isPcAppInPad && sceneInfo.bundleName === 'cn.wps.office.hap' &&
        sceneInfo.abilityName === 'WpsCloudSvrAbility') {
        scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
        sceneSessionManager.updateMaximizeMode(sceneInfo.persistentId, false);
        scbSceneSession.currRect.setSizeNum(sceneInfo.windowWidth, sceneInfo.windowHeight);
        scbSceneSession.currRect.setPosNum(sceneInfo.windowLeft, sceneInfo.windowTop);
      }
      scbSceneSession.sessionData.isNewWant = false;
      return scbSceneSession;
    } catch (error) {
      winLog.showError(`requestNewSession failed ${error}`);
    }
    return null;
  }

  /**
   * 根据persistentId或者ContainerId查找对应的SCBSceneContainerSession
   *
   * @param persistentId 可选， containerId， 可选
   * @returns SCBSceneContainerSession | null
   */
  public getContainerSessionByPersistentIdOrContainerId(persistentId?: number,
    containerId?: number): SCBSceneContainerSession | null {
    winLog.showDebug('getContainerSessionByPersistentIdOrContainerId persistentId ' + persistentId + ' containerId ' +
      containerId);
    if (persistentId) {
      return this.getSceneContainerSessionWithPersistentId(persistentId);
    }
    if (containerId) {
      return this.getSceneContainerSessionWithContainerId(containerId);
    }
    return null;
  }

  /**
   * 从其他屏幕查找SCBSceneSession，如果找到并且是available状态，在本屏幕新建一个相同的SCBSceneSession
   *
   * @param sceneInfo 要查找的SCBSceneSession的相关信息
   * @returns SCBSceneSession | undefined
   */
  public getSceneSessionFromOtherScreen(sceneInfo: SCBSceneInfo): SCBSceneSession | undefined {
    winLog.showInfo('[SCBMain] find sceneSession from other screen');
    const sceneSession: SCBSceneSession | undefined =
      SCBSceneSessionManager.getInstance().popSceneFromOtherScreen(sceneInfo);
    if (sceneSession !== undefined) {
      winLog.showInfo(`[SCBMain] find sceneSession in screen with id: ${sceneSession.sceneInfo.screenId}`);
      if (!sceneSession.isAvailable) {
        winLog.showError(`[SCBMain] sceneSession is unavailable.`);
        return undefined;
      }
      sceneInfo.persistentId = sceneSession.session.persistentId;
      sceneInfo.screenId = this.screenProperty.screenId;
      const scbSceneSession = new SCBSceneSession(sceneSession.session, sceneInfo);
      scbSceneSession.isAutoStartPiP = sceneSession.isAutoStartPiP;
      scbSceneSession.restorePiPStatus = sceneSession.restorePiPStatus;
      sceneSession.subSessionList.forEach((item: SCBSpecificSession) => {
        if (CheckEmptyUtils.isEmpty(item)) {
          winLog.showWarn('[SCBMain] item of subSessionList is empty');
          return;
        }
        SCBSceneSessionManager.getInstance().updateSessionDisplayId(item.session.persistentId,
          this.screenProperty.screenId);
        scbSceneSession.subSessionList.push(item);
      });
      return scbSceneSession;
    }
    return undefined;
  }

  /**
   * 根据containerId查找SCBSceneContainerSession
   *
   * @param containerId
   * @returns SCBSceneContainerSession | null
   */
  public getSceneContainerSessionWithContainerId(containerId: number): SCBSceneContainerSession | null {
    let index = this.containerSessionList.findIndexByContainerId(containerId);
    if (index !== -1) {
      return this.containerSessionList[index];
    }
    index = this.floatingSessionList.findIndexByContainerId(containerId);
    if (index !== -1) {
      return this.floatingSessionList[index];
    }
    index = this.containerSessionListNotShowRecent.findIndexByContainerId(containerId);
    if (index !== -1) {
      return this.containerSessionListNotShowRecent[index];
    }
    winLog.showWarn(`Failed to find containerSession with containerId:${containerId}`)
    return null;
  }

  /**
   * 根据sceneInfo获取scbContainerSession
   *
   * @param sceneInfo
   * @returns SCBSceneContainerSession | null
   */
  public checkIsInContainerSessionList(sceneInfo: SCBSceneInfo): SCBSceneContainerSession | null {
    if (this.containerSessionList && this.containerSessionList?.length > 0) {
      for (let i = 0; i < this.containerSessionList?.length; i++) {
        if (!this.containerSessionList[i].isSplit &&
          this.containerSessionList[i].primarySession?.sceneInfo.persistentId === sceneInfo.persistentId) {
          return this.containerSessionList[i];
        }
      }
    }
    return null;
  }

  /**
   * 根据sceneInfo获取callerContainerSession
   *
   * @param sceneInfo
   * @returns SCBSceneContainerSession | null
   */
  public getCallerContainerSession(sceneInfo: SCBSceneInfo): SCBSceneContainerSession | null {
    if (sceneInfo.callerPersistentId === undefined || sceneInfo.callerPersistentId === 0) {
      return null;
    }
    let callerContainerSession: SCBSceneContainerSession | null = null;
    callerContainerSession = this.containerSessionListNotShowRecent.findByPersistentId(sceneInfo.callerPersistentId);
    if (callerContainerSession === null) {
      callerContainerSession = this.getSceneContainerSessionWithPersistentId(sceneInfo.callerPersistentId);
    }
    if (callerContainerSession?.primarySession?.sceneInfo?.isHide) {
      callerContainerSession = this.getCallerContainerSession(callerContainerSession?.primarySession?.sceneInfo);
    }
    return callerContainerSession;
  }

  /**
   * 从FloatSessionList根据persistentId查找containerSession
   *
   * @param persistentId 窗口id
   * @returns SCBSceneContainerSession | null
   */
  public needMinimizeActiveContainer(currContainerSession: SCBSceneContainerSession,
    activeContainerSession: SCBSceneContainerSession): boolean {
    if (!activeContainerSession || !currContainerSession) {
      winLog.showInfo('needMinimizeActiveContainer, null container, active:' + (activeContainerSession != null) +
        ' curr:' + (currContainerSession != null));
      return false;
    }
    if (currContainerSession.containerId === activeContainerSession.containerId) {
      winLog.showInfo('needMinimizeActiveContainer same id ' + currContainerSession.containerId);
      return false;
    }
    // need to consider split
    let windowMode = currContainerSession.getContainerWindowMode();
    let activeContainerMode = activeContainerSession.getContainerWindowMode();
    winLog.showInfo(`needMinimizeActiveContainer currMode ${windowMode} activeMode ${activeContainerMode}`);
    if (windowMode === SCBSceneMode.FULLSCREEN && activeContainerMode === SCBSceneMode.FULLSCREEN) {
      return true;
    }
    return false;
  }

  /**
   * 是否需要在销毁窗口后从多任务移除session
   *
   * @param sceneSession 销毁的sceneSession
   * @param sceneInfo 可选，sceneSession的SceneInfo
   * @returns boolean true则需要移除，false不需要移除
   */
  public needRemoveSessionAfterSceneTerminate(sceneSession: SCBSceneSession,
    sceneInfo?: SCBSceneInfo, extraInfo?: ExecuteCallbackExtraInfo): boolean {
    return SCBSceneSessionManager.getInstance().isRemoveSessionAfterTerminate(sceneSession.sceneInfo.bundleName,
      sceneSession.sceneInfo.moduleName, sceneSession.sceneInfo.abilityName, sceneInfo, extraInfo);
  }

  /**
   * 移除notShow ContainerSession
   *
   * @param containerSession 需要移除的containerSession
   * @param needRemoveSession 是否需要移除
   * @returns void
   */
  public removeNotShowContainerSession(containerSession: SCBSceneContainerSession, needRemoveSession: boolean): void {
    if (!needRemoveSession) {
      winLog.showInfo('removeNotShowContainerSession needRemoveSession is false.');
      return;
    }
    this.panelMgr.removeNotShowRecentSession(containerSession);
  }

  /**
   * 根据sceneInfo 获取对应sceneSession，并更新调用链、更新want
   *
   * @param sceneInfo: SCBSceneInfo, needLinkCaller: boolean = true
   * @returns SCBSceneSession | null
   */
  public requestSceneSession(sceneInfo: SCBSceneInfo, needLinkCaller: boolean = true): SCBSceneSession | null {
    winLog.showInfo(`[SCBMain][id:${sceneInfo.persistentId}][screenId:${sceneInfo.screenId}]requestSceneSession, ` +
      `callerPersistentId:${sceneInfo.callerPersistentId}, needLinkCaller:${needLinkCaller}`);
    const sceneSession = this.getSceneSessionFromOtherScreen(sceneInfo);
    if (sceneSession !== undefined) {
      winLog.showInfo('[SCBMain]getSceneSessionFromOtherScreen success.');
      sceneSession.sceneInfo.requestId = sceneInfo.requestId;
      return sceneSession;
    }

    if (sceneInfo && sceneInfo.persistentId != 0) {
      // start from other app
      winLog.showInfo('[SCBMain]requestSceneSession using exist persistentId: ' + sceneInfo.persistentId);
      let scbSceneSession = this.getSceneSessionByPersistentId(sceneInfo.persistentId, true);
      if (scbSceneSession === null) {
        scbSceneSession = this.requestNewSceneSession(sceneInfo);
      } else {
        scbSceneSession.sceneInfo.requestId = sceneInfo.requestId;
      }
      if (scbSceneSession != null && sceneInfo.callerPersistentId && needLinkCaller) {
        this.updateCallerSessionIdAndToSessionId(scbSceneSession, sceneInfo.callerPersistentId);
      }
      return scbSceneSession;
    }

    if (sceneInfo && sceneInfo.callerPersistentId != 0) {
      winLog.showInfo('[SCBMain]requestSceneSession new scene session, persistentId: ' + sceneInfo.persistentId +
        ' callerPersistentId ' + sceneInfo.callerPersistentId);
      let scbSceneSession = this.requestNewSceneSession(sceneInfo);
      if (scbSceneSession != null && needLinkCaller) {
        this.updateCallerSessionIdAndToSessionId(scbSceneSession, sceneInfo.callerPersistentId as number);
      }
      return scbSceneSession;
    }

    // start from launcher
    let scbSceneSession = this.getSceneSession(sceneInfo);
    if (scbSceneSession) {
      scbSceneSession.sceneInfo.requestId = sceneInfo.requestId;
    }
    if (scbSceneSession === null || sceneInfo.isNewInstance) {
      winLog.showInfo('requestSceneSession sceneInfo.isNewInstance ' + sceneInfo.isNewInstance);
      let scbSceneSession = this.requestNewSceneSession(sceneInfo);
      if (scbSceneSession !== null) {
        this.updateCallerSessionIdAndToSessionId(scbSceneSession, 0);
      }
      return scbSceneSession;
    }

    if (sceneInfo.want !== null) {
      winLog.showInfo('requestSceneSession update want persistentId: ' + scbSceneSession.sceneInfo.persistentId);
      sceneSessionManager.updateSceneSessionWant({
        bundleName: scbSceneSession.sceneInfo.bundleName,
        moduleName: scbSceneSession.sceneInfo.moduleName,
        abilityName: scbSceneSession.sceneInfo.abilityName,
        appIndex: scbSceneSession.sceneInfo.appIndex,
        persistentId: scbSceneSession.sceneInfo.persistentId
      }, sceneInfo.want, sceneInfo.requestId);
    } else {
      winLog.showInfo('requestSceneSession sceneInfo.want is null');
    }
    this.updateCallerSessionIdAndToSessionId(scbSceneSession, 0);
    return scbSceneSession;
  }

  /**
   * 清理floatingSessionList 和 containerSessionList
   *
   * @param void
   * @returns void
   */
  public clearAllContainerSession(): void {
    this.floatingSessionList.clear();
    this.panelMgr.clearSceneContainerSessionList();
    this.containerSessionListNotShowRecent.clear();
  }

  public startSceneFromRecent(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      recentLog.showWarn(`sceneContainerSession is null, can't start scene!`);
      return;
    }
    SCBSceneSessionManager.getInstance().startSceneFromRecent(this.screenProperty?.screenId, undefined,
      sceneContainerSession.containerId);
    HiSysEventUtil.reportGoIntoAppInRecent(
      sceneContainerSession.companionIconInfo?.bundleName as string);
  }

  public updateScenePanelState = (state: ScenePanelState, needBlurAnimation: boolean = true,
    delayTime: number = 0, blurAnimDelayTime?: number): void => {
    if (this.stateCollectionHandler?.getPanelState() === state) {
      return;
    }
    this.requestDestructionWhenExitRecent();
    this.updatePanelStateInner(state);
    if (launcherVisualEffectMgr.isRecentBlurEffectDisabled()) {
      this.updateWallpaperBlurState(state, needBlurAnimation, blurAnimDelayTime);
      return;
    }
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE ||
      this.stateCollectionHandler?.getPanelState() === ScenePanelState.RECENT ||
      this.stateCollectionHandler?.getPanelState() === ScenePanelState.QUICK_SWITCH) {
      this.panelMgr.enableBlurComponent('updateScenePanelState');
      if (needBlurAnimation) {
        this.startBlurAnimation(true);
      }
    } else {
      const enableBlurComponent: boolean = !DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode() &&
        !StartAndExitVisualEffectManager.getInstance().isPowerSaveMode() &&
        !StartAndExitVisualEffectManager.getInstance().isStartExitBlurDisable();
      if (enableBlurComponent) {
        this.showWallpaperAfterRotate();
      }
      if (needBlurAnimation) {
        this.startBlurAnimation(false);
      }
    }
    this.updateScenePanelByState(state, delayTime);
  }

  /**
   * update scene panel state on starting scene
   * @param toSceneSession scene goto started
   */
  public updateScenePanelStateWhenStartFloat(toSceneSession: SCBSceneSession): void {
    if (toSceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      if (toSceneSession.isPcAppInPad) {
        return;
      }
      let index = this.containerSessionList.findIndex((item) => {
        return item.isActive === true && !(item?.mainSession?.sessionData.isPopoutDisappearing);
      });
      homeLog.showInfo(`updateScenePanelStateWhenStartFloat find active session: ${index}`);
      if (index !== -1) {
        this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
      } else {
        this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      }
    } else {
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
    }
  }

  public isHideBlurInGlobalSearch(fromeState: number, state: number): boolean {
    return !(sOutSideWindowMgr.isShowGlobalSearch() &&
      fromeState === ScenePanelState.FULLSCENE && state === ScenePanelState.HOME);
  }

  private startBlurAnimation(enable: boolean) {
    if (!this.stateCollectionHandler || !this.dataCollectionHandler) {
      return;
    }
    if (enable) {
      let backgroundBlurSession = this.panelMgr.getBackgroundBlurSession();
      if (CommonUtils.equals(backgroundBlurSession.bgBlurScale, SCBConstants.START_SCENE_BG_BLUR_SCALE) &&
        backgroundBlurSession.bgBlurColor === SCBConstants.START_SCENE_BG_COLOR) {
        homeLog.showInfo('no need startBlurAnimation');
        return;
      }
      animateTo({
        curve: curves.springMotion(0.2733, 1.157, 0)
      }, () => {
        homeLog.showDebug('startBlurAnimation, leg 1 > onBlurTransitionInactive');
        this.panelMgr.onBlurTransitionActive(SCBConstants.START_SCENE_BG_BLUR_SCALE, 'SCBScenePanel > startBlurAnimation leg 1');
      })
    } else if (!this.isHideBlurInGlobalSearch(this.dataCollectionHandler.getFromScenePanelState(),
      this.stateCollectionHandler.getPanelState())) {
      animateTo({
        duration: this.blurTransitionInactiveDuration,
        curve: Curve.Linear,
        onFinish: () => {
          console.info('play end')
        }
      }, () => {
        homeLog.showDebug('startBlurAnimation, leg 2 isHideBlurInGlobalSearch > onBlurTransitionInactive');
        this.panelMgr.onBlurTransitionInactive();
      })
    } else {
      this.startBlurAnimationForContainer(0);
    }
  }

  // updatescenepanelstate中的模糊动效3
  public startBlurAnimationForContainer(delayAnimation: number): void {
    const blurTransitionCount = this.panelMgr.addBlurTransitionCountAndReturnValue();
    let param: AnimateParam = {
      curve: curves.springMotion(0.45, 1, 0),
      onFinish: () => {
        this.panelMgr.onBlurTransitionFinish(blurTransitionCount);
        CloseAppManager.getInstance().setIsMinimizeAllScene(false);
        if (this.startAndExitEffectMgr.isStartExitWallpaperBlurDisable()
          && !FolderData.getInstance().isFolderOpen()
          && launcherVisualEffectMgr.isBlurEffectEnabledByType(BlurEffectType.FOLDER)) {
          launcherVisualEffectMgr.updateBlurEffect(false, BlurEffectType.FOLDER);
          homeLog.showInfo('endBlurAnimation ICON_START_EXIT_BLUR_EFFECT false');
        }
        if (this.isTopActiveContainerInSplit()) {
          homeLog.showInfo('startBlurAnimationForContainer add blur for split')
          this.panelMgr.getPanelSession()?.setBgBlurEnable(true, 'startBlurAnimationForContainer');
        }
        if (this.stateCollectionHandler?.getIsEmptyRecentViewCallback()) {
          let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
          SCBDesktopCacheManager.getInstance()
            .setDesktopCacheWithDfx(false, 'startBlurAnimation', true, expandStatus);
        }
      }
    };
    if (delayAnimation > 0) {
      param.delay = delayAnimation;
    }
    animateTo(param, () => {
      homeLog.showDebug('startBlurAnimation,  leg 3 > onBlurTransitionInactive');
      const isFolderClosed: boolean = !this.folderData.isFolderOpen();
      const isMinimizedAll: boolean = CloseAppManager.getInstance().getIsMinimizeAllScene();
      const shouldApplyBlur: boolean = this.startAndExitEffectMgr.isStartExitWallpaperBlurDisable()
        && (isFolderClosed || isMinimizedAll);
      if (shouldApplyBlur) {
        launcherVisualEffectMgr.setWallpaperBlurInactive('startBlurAnimationForContainer');
      }
      this.panelMgr.onBlurTransitionInactive();
    })
  }

  /**
   * 一键删除回桌面：跳过模糊/桌面 scale 动效，仅保留功能副作用
   */
  public finishClearAllToHome(): void {
    if (!this.stateCollectionHandler || !this.dataCollectionHandler) {
      return;
    }
    if (this.stateCollectionHandler.getPanelState() === ScenePanelState.HOME) {
      return;
    }
    this.requestDestructionWhenExitRecent();
    this.updatePanelStateInner(ScenePanelState.HOME);
    this.finishClearAllBlurWithoutAnim();
    this.updateScenePanelByState(ScenePanelState.HOME, 0, true);
  }

  private finishClearAllBlurWithoutAnim(): void {
    const isFolderClosed: boolean = !this.folderData.isFolderOpen();
    const isMinimizedAll: boolean = CloseAppManager.getInstance().getIsMinimizeAllScene();
    const shouldApplyBlur: boolean = this.startAndExitEffectMgr.isStartExitWallpaperBlurDisable()
      && (isFolderClosed || isMinimizedAll);
    if (shouldApplyBlur) {
      launcherVisualEffectMgr.setWallpaperBlurInactive('finishClearAllToHome');
    }
    this.panelMgr.onBlurTransitionInactive();
    launcherVisualEffectMgr.exitBlurWithoutAnim();
    CloseAppManager.getInstance().setIsMinimizeAllScene(false);
    if (this.startAndExitEffectMgr.isStartExitWallpaperBlurDisable()
      && !FolderData.getInstance().isFolderOpen()
      && launcherVisualEffectMgr.isBlurEffectEnabledByType(BlurEffectType.FOLDER)) {
      launcherVisualEffectMgr.updateBlurEffect(false, BlurEffectType.FOLDER);
      homeLog.showInfo('finishClearAllToHome ICON_START_EXIT_BLUR_EFFECT false');
    }
    if (this.isTopActiveContainerInSplit()) {
      homeLog.showInfo('finishClearAllToHome add blur for split');
      this.panelMgr.getPanelSession()?.setBgBlurEnable(true, 'finishClearAllToHome');
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'finishClearAllToHome', true, expandStatus);
    this.panelMgr.disableBlurComponent('finishClearAllToHome');
  }

  private isTopActiveContainerInSplit(): boolean {
    let containerSessionList =
      SCBSceneSessionManager.getInstance().getContainerSessionList(this.screenProperty.screenId);
    let curSession = containerSessionList.getTopActiveSession();
    if (curSession && curSession.getState() === SCBSceneContainerState.SPLIT) {
      homeLog.showInfo('isTopActiceContainerInSplit is split');
      return true;
    }
    return false;
  }

  private updateWallpaperBlurState(state: ScenePanelState, needBlurAnimation: boolean,
    blurAnimDelayTime?: number): void {
    if (!this.dataCollectionHandler) {
      return;
    }
    let fromState: ScenePanelState = this.dataCollectionHandler.getFromScenePanelState();
    if (launcherVisualEffectMgr.triggerDesktopBlurByPanelState(fromState, state, blurAnimDelayTime)) {
      this.panelMgr.disableBlurComponent('updateScenePanelState isLauncherBlurDisabled');
    } else if (needBlurAnimation) {
      if (this.isTopActiveContainerInSplit()) {
        this.panelMgr.getPanelSession()?.setBgBlurEnable(true, 'updateWallpaperBlurState');
        this.startBlurAnimation(true);
      } else if (fromState !== ScenePanelState.RECENT) {
        this.startBlurAnimation(false);
      } else {
        this.panelMgr.onBlurTransitionInactive();
      }
    }
    this.updateScenePanelByState(state, blurAnimDelayTime);
  }

  public updateScenePanelByState(state: ScenePanelState, delayTime: number = 0,
    withoutScaleAnim: boolean = false): void {
    if (!this.stateCollectionHandler || !this.dataCollectionHandler) {
      return;
    }
    if (state === ScenePanelState.HOME) {
      this.changeScenePanelStateToHome(this.dataCollectionHandler.getFromScenePanelState(),
        this.stateCollectionHandler.getPanelState(), delayTime, withoutScaleAnim);
    }
    if (state === ScenePanelState.SPLIT) {
      SCBTransitionManager.getInstance().swipeUpFromHome(RecentsStyleConstants.SCALE_DEFAULT);
    }
    if (state === ScenePanelState.RECENT) {
      PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_RECENT);
      SCBSceneSessionManager.getInstance().notifyEnterRecentForFloat();
      AppStorage.setOrCreate('showRecent', true);
    } else {
      PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_RECENT);
      SCBSceneSessionManager.getInstance().notifyExitRecentForFloat();
      AppStorage.setOrCreate('showRecent', false);
    }
    this.setScenePanelTouchableByNavigation();
  }

  public updatePanelStateInner(state: ScenePanelState): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    let parameters: Record<string, Object> = {
      'srcState': this.stateCollectionHandler.getPanelState(),
      'destState': state,
    };
    this.publishScenePanelEventMsg(CEManager.CUSTOM_SCENE_PANEL_EVENT,
      RecentEventType.SCENE_PANEL_STATE_CHANGE, parameters);
    homeLog.showInfo(`updateScenePanelState from ${this.stateCollectionHandler.getPanelState()} to ${state}`);
    this.dataCollectionHandler?.setFromScenePanelState(this.stateCollectionHandler.getPanelState());
    this.stateCollectionHandler.updatePanelState(state);
    this.dataCollectionHandler?.setIsSupportMaximizeScene(this.stateCollectionHandler.getPanelState() !==
      ScenePanelState.RECENT);
  }

  public removeBackgroundSession(sceneSession: SCBSceneSession) {
    // if new start app is from split/float, need exit split firstly
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    homeLog.showInfo(`removeBackgroundSession remove sceneSession start`);

    if (sceneContainerSession && sceneContainerSession.isSplit && sceneContainerSession.primarySession &&
    sceneContainerSession.secondarySession) {
      homeLog.showInfo(`removeBackgroundSession sceneSession is in Split`);
      sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      this.panelMgr.removeSceneContainerSession(sceneContainerSession);
      return;
    } else if (sceneContainerSession && sceneContainerSession?.isFloat) {
      homeLog.showInfo(`removeBackgroundSession sceneSession is in float`);
      return;
    } else {
      this.panelMgr.removeSceneContainerSession(sceneContainerSession);
    }
  }

  public onStartSceneFromRecent(persistentId?: number, containerId?: number): void {
    recentLog.showInfo(`[SCBMain][id:${persistentId}]onStartSceneFromRecent, containerId:${containerId} ` +
      `scenePanelState ${this.stateCollectionHandler?.getPanelState()}`);
    Trace.start(Trace.CORE_METHOD_START_FROM_RECENT)
    // 删除needRemoveSessionList中的该container，避免启动异常
    recentRuntimeInstance.needRemoveSessionList.deleteByContainerId(containerId);
    let sceneContainerSession =
      this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (sceneContainerSession === null) { // recent must has container
      recentLog.showError(`onStartSceneFromRecent Failed to get sceneContainerSession with persistentId:${persistentId}!`);
      Trace.end(Trace.CORE_METHOD_START_FROM_RECENT);
      return;
    }
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(
          sceneContainerSession.primarySession?.sceneInfo, StartInterceptions.FROM_RECENT, this.screenId, this.panelId) ||
        SCBSceneStartInterceptor.getInstance().shouldIntercept(
          sceneContainerSession.secondarySession?.sceneInfo, StartInterceptions.FROM_RECENT, this.screenId, this.panelId)) {
      return;
    }

    if (this.isExternalScreenIntercepted(sceneContainerSession)) {
      Trace.end(Trace.CORE_METHOD_START_FROM_RECENT);
      return;
    }
    if (sceneContainerSession.isSplitView() && sceneContainerSession.hasFixedMultiWindowOrientationSession()) {
      this.exitSplitViewInFixedMultiWindowOrientation(sceneContainerSession.primarySession?.sceneInfo.persistentId,
        sceneContainerSession.containerId);
    }
    RecentGestureEventManager.getInstance()
      .deliverGestureEvent(RecentGestureEvent.START_SCENE_FROM_RECENT,
        sceneContainerSession);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showError('onStartSceneFromRecent screenSession is null');
      return;
    }
    let targetRotation = this.getContainerSessionRotation(sceneContainerSession, screenSession, false);
    let isStartingSceneFromPiP = SCBSceneSessionManager.getInstance().isStartingSceneFromPiP;
    if (this.isNeedBlankInRecent(sceneContainerSession, screenSession, targetRotation, isStartingSceneFromPiP)) {
      if (SCBScreenSessionManager.getInstance().isSingleFoldablePhoneExpandStatus() && sceneContainerSession.primarySession) {
        sceneContainerSession.lastRecentStartBeforeRect = sceneContainerSession.primarySession.currRect;
        sceneContainerSession.lastRecentStartBeforeRotation = sceneContainerSession.currentRotation;
      }
      recentLog.showInfo(`onStartSceneFromRecent start scene with blank, sessionName: ${sceneContainerSession.getName()}` +
        `targetRotation:${targetRotation} currentRotation:${sceneContainerSession.currentRotation}`);
      if (SCBRotateUtils.isVertical(targetRotation) ===
      SCBRotateUtils.isVertical(sceneContainerSession.currentRotation)) {
        this.dataCollectionHandler?.setNeedRemoveBlank(true);
      }
      if (sceneContainerSession.isSplit) {
        sceneContainerSession.primarySession?.setBlank(true);
        sceneContainerSession.primarySession?.setBufferAvailableCallbackEnable(true);
        sceneContainerSession.secondarySession?.setBlank(true);
        sceneContainerSession.secondarySession?.setBufferAvailableCallbackEnable(true);
      } else {
        sceneContainerSession.primarySession?.setBlank(true);
        sceneContainerSession.primarySession?.setBufferAvailableCallbackEnable(true);
      }
    }
    this.stateCollectionHandler?.getRecentInnerState().onStartSceneAnimating();
    let sceneSession = sceneContainerSession.primarySession
    let sceneInfo = sceneSession?.sceneInfo;
    let isPCAppFlag: boolean = SCBTogManager.getInstance().onStartScene(sceneInfo as SCBSceneInfo, StartFrom.RECENT);
    if (!this.floatingSessionList.isEmpty()) {
      let floatContainerSession = this.floatingSessionList.find(item => {
        return item?.containerId === containerId || item?.primarySession?.sceneInfo.persistentId === persistentId;
      });
      ContainerBuilder.resetAllContainerPreBuildStage(this.floatingSessionList);
      if (CommonUtils.isInvalid(floatContainerSession)) {
        // 点击全屏应用
        let persistentId = sceneContainerSession.primarySession?.sceneInfo.persistentId ?? -1;
      } else {
        recentLog.showInfo(`[SCBMain]onStartSceneFromRecent floatContainerSession is vaild`);
        // 点击悬浮窗
        let persistentId = floatContainerSession?.mainSession.sceneInfo.persistentId ?? -1;
        this.exitRecent();
        homeLog.showInfo(`[SCBMain]onStartSceneFromRecent startFloatSceneFromRecentIfNeed return`);
        return;
      }
    }
    let primarySession = sceneContainerSession.primarySession;
    if (primarySession && primarySession.sceneInfo) {
      homeLog.showInfo(`onStartSceneFromRecent primarySession.isActive: ${primarySession.isActive}`);
      let appExitInfo = QuitAppRectViewModel.getInstance().buildAppExitInfo(sceneContainerSession);
      if (appExitInfo && appExitInfo.appInFolderInfo !== null && sceneContainerSession.companionIconInfo &&
        sceneContainerSession.companionIconInfo.startAppType !== StartType.SHORTCUT_APP) {
        sceneContainerSession.companionIconInfo.startAppType = StartType.FOLDER;
      }
      this.clearCallerPersistentIdForSession(primarySession.sceneInfo.toPersistentId);
      this.clearToPersistentIdForSession(primarySession.sceneInfo.persistentId);
      if (!primarySession.isActive && primarySession.sceneInfo.callerPersistentId) {
        homeLog.showInfo(`[SCBMain]onStartSceneFromRecent clear session return chain from ` +
          `${primarySession.sceneInfo.callerPersistentId} to ${primarySession.sceneInfo.persistentId}`);
        this.clearCallerPersistentIdForSession(primarySession.sceneInfo.persistentId);
        this.clearToPersistentIdForSession(primarySession.sceneInfo.callerPersistentId);
      }
    }

    // notify current foreground session resumed
    sceneContainerSession.notifyForegroundInteractiveStatus(true);
    sceneContainerSession.updateSessionIsNewWant(true, 'onStartSceneFromRecent');

    // 快捷键松手的时候恢复scale到1，避免touch up的设置缩放
    RecentZoomAlarm.getInstance().restoreScale();

    let clickIndex: number = this.recentStartScene.prepareEnterAppFromRecent(sceneContainerSession,
      this.recentScroll.currentOffsetX);
    let autoCenterColumn = recentRuntimeInstance.autoCenterColumn;
    this.recentScroll.scrollToImmediately(0, 'onStartSceneFromRecent');
    sceneContainerSession.addTransitionCount();
    SCBTransitionManager.getInstance().addStartExitAnimationCount('onStartSceneFromRecent');
    performanceMonitor.begin('LAUNCHER_APP_LAUNCH_FROM_RECENT', performanceMonitor.ActionType.LAST_UP,
      sceneContainerSession.companionIconInfo?.bundleName);
    this.setFrameRateForStartFromRecent(sceneContainerSession, StyleConstants.DEFAULT_1);
    recentLog.showInfo(`[SCBMain]onStartSceneFromRecent raise priority: start ` +
      `${sceneContainerSession.getName()} isActive ${sceneContainerSession.isActive} ` +
      `isSplit ${sceneContainerSession.isSplit} ` +
      `isNeedChangeToMultiRow: ${this.dataCollectionHandler?.getIsNeedChangeToMultiRow()}`);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    ContainerBuilder.resetAllContainerPreBuildStage(this.containerSessionList);
    ContainerBuilder.resetAllContainerPreBuildStage(this.floatingSessionList);
    if (sceneContainerSession.isSplit) {
      sceneContainerSession.changeState(SCBSceneContainerState.SPLIT);
    } else {
      sceneContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
    }
    this.showStatusBar(true, false);
    screenSession.isInStartSceneFromRecent = true;
    this.recentStartScene.playStartSceneAnimation(clickIndex, autoCenterColumn, sceneContainerSession,
      this.recentStartSceneFinishCallback);

    let activeSceneContainerSession = this.containerSessionList.getTopActiveSession();
    if (sceneContainerSession.companionIconInfo) {
      let transitionController = SCBTransitionManager.getInstance()
        .findTransitionController(sceneContainerSession.companionIconInfo.bundleName, () => {
          return PageDesktopModel.getInstance().getCloseAppData(sceneContainerSession?.companionIconInfo.bundleName,
            sceneContainerSession?.companionIconInfo.abilityName,
            sceneContainerSession?.companionIconInfo.startAppType,
            sceneContainerSession?.companionIconInfo.cardId,
            sceneContainerSession?.companionIconInfo.extraId,
            sceneContainerSession?.companionIconInfo.appIndex);
        });
      sceneContainerSession.updateCompanionIconInfo(transitionController);
      SCBTransitionManager.getInstance().notifySceneTransitionIn(transitionController, true);
    }
    this.updateScreenRotationPropertyForRecent(targetRotation, sceneContainerSession);
    AIBarViewModel.getInstance(this.screenProperty)
      .updateAiBarHotAreaRectForRecent(this.screenProperty, targetRotation);
    this.panelMgr.raiseSceneToTop(sceneContainerSession);
    // activation/background after adding to window tree
    sceneContainerSession.requestActivation(false);
    if (activeSceneContainerSession &&
      this.needMinimizeActiveContainer(sceneContainerSession, activeSceneContainerSession)) {
      activeSceneContainerSession?.requestBackground();
    }
    this.updateScenePanelState(ScenePanelState.FULLSCENE, true);
    SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.OPEN_APP);
    this.sendBadgeEvent(sceneContainerSession.companionIconInfo, true);
    QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene from recent');
    Trace.end(Trace.CORE_METHOD_START_FROM_RECENT);
  }

  /**
   * set frame rate when start from recent
   * @param sceneContainerSession sceneContainerSession
   * @param state 1 open, 0 close
   */
  private setFrameRateForStartFromRecent(sceneContainerSession: SCBSceneContainerSession, state: number): void {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_FROM_MULTIPLE_TASKBARS, state);
  }

  public onTerminateSceneFromActiveQuickSwitch(containerSession: SCBSceneContainerSession, needRemoveSession: boolean,
    needClearData: boolean = false) {
    if (!containerSession) {
      homeLog.showError('[SCBMain]onTerminateSceneFromActiveQuickSwitch containerSession is null.');
      return;
    }
    homeLog.showWarn('[SCBMain]onTerminateSceneFromActiveQuickSwitch name:' + containerSession.getName() +
      ' needRemoveSession:' + needRemoveSession);
    containerSession.requestDestruction(needRemoveSession, needClearData);
    this.removeContainerSession(containerSession, needRemoveSession);
  }

  private isNeedBlankInRecent(sceneContainerSession: SCBSceneContainerSession, screenSession: SCBScreenSession, targetRotation: number,
    isStartingSceneFromPiP: boolean): boolean {
    return sceneContainerSession.currentRotation !== targetRotation &&
      !sceneContainerSession.isFloat && !isStartingSceneFromPiP;
  }

  public removeContainerSession(containerSession: SCBSceneContainerSession, needRemoveSession: boolean): void {
    if (!needRemoveSession) {
      homeLog.showInfo('removeContainerSession needRemoveSession is false.');
      return;
    }
    this.panelMgr.removeSceneContainerSession(containerSession);
    if (containerSession.isFloat) {
      this.panelMgr.removeFloatSceneContainerSession(containerSession);
    }
    // 若removeSession后，多任务列表清空，需要退出多任务界面
    if (this.isRecentState() && this.containerSessionList.length === 0 && this.floatingSessionList.length === 0) {
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      this.exitSceneWithRotationRecover(containerSession);
      SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.EXIT_RECENT);
    }
  }

  public startSceneContainerTransition(toInfo: SCBSceneInfo, fromSession: SCBSceneContainerSession,
    toSession: SCBSceneContainerSession, isBackTransition: boolean, isFromShowAboveKeyguard: boolean,
    topActiveSession: SCBSceneContainerSession | null): void {
    if (fromSession.isFloat) {
      homeLog.showInfo(`fromSession is float no need to close, fromSession name is :${fromSession.getName()}`);
      return;
    }
    if (SCBPhoneSceneUtils.isPhoneCallScene(toInfo)) {
      // for phone call, show the former scene during transition
      fromSession.isDisappearing = true;
      fromSession.requestBackground();
      this.sceneContainerTransitionForPhoneCall(fromSession, toSession, false, false);
    } else {
      if (isFromShowAboveKeyguard && !toInfo.isCalledRightlyByCallerId) {
        homeLog.showInfo('check caller token failed when from show above keyguard, no need to play animation');
        return;
      }
      if (topActiveSession === toSession) {
        homeLog.showInfo('topActiveSession is same as toSession, skip animation.');
        return;
      }
      this.panelAnimator.sceneContainerAppTransitionChange(fromSession, toSession, isBackTransition, false, false, true);
    }
  }

  private startFadeInAnimationForCallUI(containerSession: SCBSceneContainerSession | null): void {
    if (containerSession === null) {
      homeLog.showError('[SCBMain] containerSession is null');
      return;
    }

    let fadeInAnimationFinishedCallback = () => {
      if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
        containerSession?.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
          TAG, 'fadeInAnimationForCallUIFinished', containerSession.getName());
      }
    };
    let animationCallbackFunc = () => {
      if (containerSession?.isFloat) {
        let activeContainerSession = this.containerSessionList.getTopActiveFullSession();
        this.updateScenePanelState(activeContainerSession ? ScenePanelState.FULLSCENE : ScenePanelState.HOME);
        return;
      }
      this.executeFadeInAnimation(containerSession, PhoneCallAnimationConstants.PHONE_CALL_TRANSITION_DURATION,
                                  Curve.FastOutSlowIn, fadeInAnimationFinishedCallback);
    };
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'startFadeInAnimationForCallUI',
      containerSession.getName());
    containerSession.primarySession?.setBufferAvailableCallback(animationCallbackFunc);
  }

  private executeFadeInAnimation(containerSession: SCBSceneContainerSession | null, duration: number,
                                 curve: Curve | ICurve, fadeInAnimationFinishedCallback: () => void): void {
    if (containerSession === null) {
      homeLog.showError('[SCBMain] containerSession is null');
      return;
    }
    if (fadeInAnimationFinishedCallback === null) {
      homeLog.showError('[SCBMain] fadeIn animation finished callback is null');
      return;
    }
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    // init containerSession and reset containerSession's alpha to 0
    containerSession.init(false);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'executeFadeInAnimation',
                                                               containerSession.getName());
    let customTimeOutId: number = 0;
    animateTo({
      duration: duration,
      curve: curve,
      onFinish: () => {
        fadeInAnimationFinishedCallback();
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        clearTimeout(customTimeOutId);
        TraceUtil.endTrace(DomainName.WINDOW, TraceUtil.EXECUTE_FADE_IN_ANIMATION);
        homeLog.showInfo(`[SCBMain]fadeIn animation finished, id: ${containerSession?.getPersistentId()}, ` +
          `is container float: ${containerSession?.isFloat}`);
      }
    }, () => {
      homeLog.showInfo(`[SCBMain]fadeIn animation start, id: ${containerSession.getPersistentId()}`);
      TraceUtil.startTrace(DomainName.WINDOW, TraceUtil.EXECUTE_FADE_IN_ANIMATION);
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'executeFadeInAnimation',
                                                                 containerSession.getName());
    });
    customTimeOutId = setTimeout(() => {
      fadeInAnimationFinishedCallback();
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
      TraceUtil.endTrace(DomainName.WINDOW, TraceUtil.EXECUTE_FADE_IN_ANIMATION);
      homeLog.showError(`[SCBMain]fadeIn animation timeout, id: ${containerSession?.getPersistentId()}, ` +
                        `is container float: ${containerSession?.isFloat}`);
    }, 3000);
  }

  public sceneContainerTransitionForPhoneCall(fromContainerSession: SCBSceneContainerSession,
    toContainerSession: SCBSceneContainerSession | null,
    isBackTransition: boolean, needRemoveSession: boolean,
    needTerminate: boolean = true, isForceClean: boolean = false): void {
    homeLog.showInfo('[SCBMain]sceneContainerTransitionForPhoneCall isBackTransition:%{public}s, ' +
      'needRemoveSession:%{public}s, needTerminate:%{public}s', isBackTransition, needRemoveSession, needTerminate);
    if (!fromContainerSession) {
      homeLog.showWarn('[SCBMain]fromContainerSession is null');
      return;
    }
    // 跳回到不显示多任务，需要把session放回到containerlist中
    if (!toContainerSession?.isFloat) {
      this.panelMgr.restoreNotshowToContainerList(toContainerSession);
    }
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.SCENE_CONTAINER_TRANSITION_FOR_PHONE_CALL);
    let duration = PhoneCallAnimationConstants.PHONE_CALL_TRANSITION_DURATION;
    if (isBackTransition) {
      if (needTerminate) {
        // animation not need calc icon pos with rotation, thus can clear session data before animation
        fromContainerSession?.requestDestructionWithTransitionOut(needRemoveSession, false, false, isForceClean);
      } else {
        fromContainerSession?.requestBackgroundWithTransitionOut();
      }

      // 通话页面回胶囊，采用回胶囊动效
      if (OverlayStartAnimHelper.checkStartOverlayTransitionOut({
        scenePanelManager: this.panelMgr,
        containerSession: fromContainerSession,
        toContainerSession: toContainerSession,
        needRemoveSession: needRemoveSession,
        triggerType: OverlayStartAnimHelper.TRIGGER_TYPE_APP_BACK_TO_CAPSULE
      })) {
        homeLog.showInfo('[SCBMain]checkStartOverlayTransitionOut return true.');
        return;
      }
    }
    if (toContainerSession) {
      toContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'init', toContainerSession.getName());
    }
    let animationCallbackFunc = () => {
      homeLog.showInfo('[SCBMain]animationCallbackFunc, ' +
        `from ${fromContainerSession?.primarySession?.session?.persistentId} ` +
        `to ${toContainerSession?.primarySession?.session?.persistentId}, ` +
        `is toContainer float: ${toContainerSession?.isFloat}, ` +
        `phoneCallAnimCount: ${this.phoneCallAnimCount}`);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(0);
      this.startPhoneCallFromAnim(fromContainerSession, duration, isBackTransition, needRemoveSession);
      if (toContainerSession?.isFloat || fromContainerSession?.isFloat) {

        let activeContainerSession = this.containerSessionList.getTopActiveSession();
        this.updateScenePanelState(activeContainerSession ? ScenePanelState.FULLSCENE : ScenePanelState.HOME);
        return;
      }
      this.startPhoneCallToAnim(toContainerSession, duration);
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.SCENE_CONTAINER_TRANSITION_FOR_PHONE_CALL);
      if (this.phoneCallAnimCount != 0) {
        homeLog.showInfo(`[SCBMain]animationCallbackFunc, phoneCallAnimCount: ${this.phoneCallAnimCount}`);
      }
    };
    if (isBackTransition) {
      animationCallbackFunc();
      this.exitSceneWithRotationRecover(fromContainerSession);
    } else {
      toContainerSession?.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'sceneContainerTransitionForPhoneCall',
        toContainerSession.getName());
      toContainerSession?.primarySession?.setBufferAvailableCallback(animationCallbackFunc);
    }
  }

  public onTerminateSceneFromBackgroundOrRecent(terminateSceneEntryParam: TerminateSceneEntryParam): void {
    let containerSession = terminateSceneEntryParam.containerSession;
    let needRemoveSession = terminateSceneEntryParam.needRemoveSession;
    let needClearData = terminateSceneEntryParam.needClearData;
    let isForceClean = terminateSceneEntryParam.isForceClean;
    let isSessionException = terminateSceneEntryParam.isSessionException;
    if (!containerSession) {
      homeLog.showError('[SCBMain]onTerminateSceneFromBackgroundOrRecent containerSession is null.');
      return;
    }
    // 非多任务状态、RecentIdle状态、单行或者notShowInRecent的卡片直接删除补位
    if (this.needRemoveContainerSessionImmediately(containerSession, isSessionException)) {
      homeLog.showWarn('[SCBMain]onTerminateSceneFromBackgroundOrRecent immediately name:' + containerSession.getName() +
        ' needRemoveSession:' + needRemoveSession);
      containerSession.requestDestruction(needRemoveSession, needClearData, undefined, isForceClean);
      this.containerFillingWhenTerminate(containerSession, needRemoveSession);
      this.removeNotShowContainerSession(containerSession, needRemoveSession);
      this.removeContainerSession(containerSession, needRemoveSession);
      return;
    }
    // needRemoveSessionList记录下来，在滑动自动停止、退出多任务等场景做移除
    if (needRemoveSession) {
      recentRuntimeInstance.needRemoveSessionList.add(containerSession);
    }
    homeLog.showWarn('[SCBMain]onTerminateSceneFromRecent name:' + containerSession.getName() +
      ' needRemoveSession:' + needRemoveSession);
    containerSession.requestDestruction(false, needClearData, undefined, isForceClean);
  }

  private needRemoveContainerSessionImmediately(containerSession: SCBSceneContainerSession,
    isSessionException: boolean = false): boolean {
    if (this.dataCollectionHandler?.getIsNeedChangeToMultiRow()) {
      return true;
    }
    if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
      recentLog.showInfo('remove containerSession immediately not in recent');
      return true;
    }
    if (this.panelFsm.currentState.equalTo(ScenePanelStates.STATE_RECENT_IDLE)) {
      recentLog.showInfo('remove containerSession immediately in recent idle');
      return true;
    }
    if (this.panelMgr.getNotShowRecentList().findIndexByContainerId(containerSession.containerId) !== -1) {
      recentLog.showInfo('remove containerSession immediately not show');
      return true;
    }
    if (recentRuntimeInstance.notRemovingSessionList.findIndexByContainerId(containerSession.containerId) <
    recentRuntimeInstance.leftBoundaryIndex) {
      recentLog.showInfo('remove containerSession immediately out of boundary');
      return true;
    }
    if (!isSessionException) {
      recentLog.showInfo('remove containerSession immediately not is sessionException');
      return true;
    }
    return false;
  }

  public requestFromContainerBackgroundOrDestruction(fromContainerSession: SCBSceneContainerSession,
    isBackTransition: boolean, needRemoveSession: boolean,
    needTerminate: boolean): void {
    if (isBackTransition && needTerminate) {
      fromContainerSession.requestDestructionWithTransitionOut(needRemoveSession, isBackTransition);
    } else {
      fromContainerSession.requestBackgroundWithTransitionOut();
    }
  }

  /**
   * 通话页面来源session动画开启
   *
   * @param fromContainerSession 来源session
   * @param duration 动画时长
   * @param isBackTransition 是否页面返回
   * @param needRemoveSession 动效结束是否移除session
   */
  private startPhoneCallFromAnim(fromContainerSession: SCBSceneContainerSession, duration: number,
    isBackTransition: boolean, needRemoveSession: boolean): void {
    this.uiContext?.animateTo({
      duration: duration,
      curve: Curve.FastOutLinearIn,
      onFinish: () => {
        this.phoneCallAnimCount -= 1;
        homeLog.showInfo(`[SCBMain]startPhoneCallFromAnim finish, id: ${fromContainerSession.getPersistentId()} ` +
          `phoneCallAnimCount: ${this.phoneCallAnimCount}`);
        if (isBackTransition && fromContainerSession.pendingRemove && needRemoveSession) {
          if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
            fromContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
              TAG, 'startPhoneCallFromAnim', fromContainerSession.getName());
          }
          this.panelMgr.removeSceneContainerSession(fromContainerSession);
          if (fromContainerSession?.isFloat) {
            this.panelMgr.removeFloatContainerSession(fromContainerSession);
          }
        }
        fromContainerSession.transitionOutFinish();
        // 来电时如果在做启动或退出动效，需要恢复图标显示
        fromContainerSession.transitionController?.onInactive('startPhoneCallFromAnim end', 'startPhoneCallFromAnim');
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.START_PHONE_CALL_FROM_ANIM);
      }
    }, () => {
      this.phoneCallAnimCount += 1;
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.START_PHONE_CALL_FROM_ANIM);
      if (isBackTransition) {
        fromContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'startPhoneCallFromAnim',
          fromContainerSession.getName());
      }
    })
  }

  /**
   * 通话页面目标session动画开启
   *
   * @param toContainerSession 目标session
   * @param duration 动画时长
   * @param isBackTransition 是否页面返回
   */
  private startPhoneCallToAnim(toContainerSession: SCBSceneContainerSession | null, duration: number): void {
    if (toContainerSession) {
      // 目标界面初始化，然后从透明度0开始播放淡入动画
      toContainerSession.init(false);
      toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'startPhoneCallToAnim',
        toContainerSession.getName());
      animateTo({
        duration: duration,
        curve: Curve.FastOutSlowIn,
        onFinish: () => {
          homeLog.showInfo(`[SCBMain]startPhoneCallToAnim finish, id: ${toContainerSession.getPersistentId()}`);
          if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
            toContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
              TAG, 'startPhoneCallToAnim', toContainerSession.getName());
          }
          TraceUtil.endTrace(DomainName.SCB, TraceUtil.START_PHONE_CALL_TO_ANIM);
          AnimateToScheduleUtils.raiseAnimateToSchedulePriority(1);
        }
      }, () => {
        TraceUtil.startTrace(DomainName.SCB, TraceUtil.START_PHONE_CALL_TO_ANIM);
        toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'startPhoneCallToAnim',
          toContainerSession.getName());
      });
    }
  }

  public onSceneStartTransition(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo,
    isBackTransition: boolean = false): CommonResult { // full to full
    homeLog.showInfo('[SCBMain][id:%{public}d][sceneInfo:%{public}s/%{public}s/%{public}s/%{public}d]' +
      '[screenId:%{public}d]onSceneStartTransition with toSceneInfo:%{public}s, fromInfo:%{public}s, isBackTransition:%{public}s',
      toInfo?.persistentId, toInfo?.bundleName, toInfo?.moduleName, toInfo?.abilityName, toInfo?.appIndex, toInfo?.screenId,
      toInfo?.toJsonString(), fromInfo?.toJsonString(), isBackTransition);
    if (!fromInfo) {
      homeLog.showError('onSceneStartTransition fromInfo is null');
      return CommonResult.FAIL;
    }
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(toInfo, StartInterceptions.FROM_TRANSITION, this.screenId, this.panelId)) {
      return CommonResult.FAIL;
    }
    let isPCApp: boolean = SCBTogManager.getInstance().onStartScene(toInfo, StartFrom.TRANSITION);
    let topActiveSceneSession = this.containerSessionList.getTopActiveSession();
    let toSceneSession = this.requestSceneSession(toInfo, !isBackTransition);
    let fromSceneSession = this.getSceneSessionByPersistentId(fromInfo.persistentId);
    if (toSceneSession === null || fromSceneSession === null) {
      homeLog.showError('onSceneStartTransition Failed to get toSceneSession: ' + toInfo?.toJsonString() + ' or fromSceneSession: ' +
        fromInfo?.toJsonString());
      return CommonResult.FAIL;
    }
    if (isBackTransition) {
      homeLog.showError(`onSceneStartTransition need backTransition, clear callerLink of ` +
        `toSession:${toInfo.persistentId} and fromSession:${fromInfo.persistentId}`);
      this.clearToPersistentIdForSession(toInfo.persistentId);
      this.clearToPersistentIdForSession(fromInfo.persistentId);
      this.clearCallerPersistentIdForSession(fromInfo.persistentId);
    }
    if (this.dataCollectionHandler?.getClearAllAnimCnt() != 0 && toSceneSession?.isPcAppInPad) {
      homeLog.showError('[SCBMain]onSceneStartTransition, recent clear all animate not finish!');
      return CommonResult.FAIL;
    }
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP) {
      // force set caller to the fromSceneSession
      this.updateCallerSessionIdAndToSessionId(toSceneSession, fromInfo.persistentId);
      // skip onNewWant if start scene from pip
      toSceneSession.sessionData.isNewWant = false;
    }
    let fromContainerSession = this.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId);
    if (topActiveSceneSession && this.processStartFromVirtualIfNeed(topActiveSceneSession, toSceneSession, toInfo)) {
      winLog.showInfo('[SCBSplit]onSceneStartTransition process start from virtual screen in multi-window');
      this.startSceneWithRotationIfNeed(topActiveSceneSession);
      return CommonResult.SUCCESS;
    }
    if (fromContainerSession?.isSplit && this.stateCollectionHandler?.getPanelState() === ScenePanelState.SPLIT &&
      fromContainerSession.primarySession != null && fromContainerSession.secondarySession != null) {
      return CommonResult.FAIL;
    }
    let toContainerSession = this.getContainerSessionByPersistentIdOrContainerId(toSceneSession.sceneInfo.persistentId);
    homeLog.showInfo(`[SCBMain]onSceneTransition windowMode from: ${fromSceneSession.sceneInfo.windowMode}, ` +
      `to: ${toSceneSession.sceneInfo.windowMode}, appWant: ${toInfo.windowMode}`);
    // Floating scene should minimize
    if (fromContainerSession?.isFloat || fromContainerSession?.isSplit) {
      let toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
      // FULLSCREEN is foreground only refresh
      if (toContainerSession && toContainerSession.isActive) {
        SCBSceneSessionManager.getInstance().requestSceneSessionActivation(toSceneSession?.session,
          toSceneSession?.isNewWant, undefined, toSceneSession?.sceneInfo?.requestId);
        if (toContainerSession.isFloat) {
          QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene transition： floating');
        }
        homeLog.showInfo('onSceneTransition FLOATING or SPLIT same id return');
        return CommonResult.FAIL;
      }
    }
    // Start scene is floating
    if (toSceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      // foreground only refresh
      if (toSceneSession.isActive) {
        toSceneSession.requestSessionActivation(true);
        QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene transition： floating active');
        toContainerSession?.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'onSceneStartTransition');
        homeLog.showInfo('onSceneTransition Floating isActive, only refresh');
        return CommonResult.SUCCESS;
      }
    }
    this.sceneStartTransitionIfNeed(fromSceneSession, toSceneSession, toInfo, topActiveSceneSession, isBackTransition,
      isPCApp);
    QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene transition');
    return CommonResult.SUCCESS;
  }

  private sceneTransitionToSpecialIfNeed(toSession: SCBSceneSession, fromSession: SCBSceneSession,
    containerSession: SCBSceneContainerSession | null, isCalledRightlyByCallerId: boolean): boolean {
    if (!SCBSceneSessionManager.getInstance().isScreenLocked() || !toSession.isShowAboveKeyguard) {
      homeLog.showInfo('[WMSMain]sceneTransitionToSpecialIfNeed no need to transit scene to special.');
      return false;
    }
    if (toSession.isShowAboveKeyguard && !fromSession.isShowAboveKeyguard) {
      homeLog.showInfo('[WMSMain]sceneTransitionToSpecialIfNeed toSession in special but fromSession not.');
      SCBSceneSessionManager.getInstance().startSceneFromOtherAboveKeyguard(toSession.sceneInfo);
      return true;
    }
    // find Container in ScenePanel, to raise up to specialPanel.
    if (containerSession && this.getSceneContainerSessionWithPersistentId(toSession.session.persistentId)) {
      homeLog.showInfo('[WMSMain]sceneTransitionToSpecialIfNeed need to move toContainerSession to special panel.');
      if (!isCalledRightlyByCallerId) {
        homeLog.showWarn(`[WMSMain]check token failed when moveContainerSession, with id: ${containerSession.containerId}`);
        return false;
      }
      this.removeContainerSession(containerSession, true);
      containerSession.primarySession?.setTemporarilyShowWhenLocked(true);
      this.addSpecialContainerSession(containerSession);
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, 'SCBScenePanel',
        'moveContainerSessionToSpecialIfNeed', containerSession.getName());
      return false;
    }
    if (containerSession == null) { // not find container session in scene panel
      const specialContainerSessionList = SCBSceneSessionManager.getInstance().getSpecialContainerSessionList();
      const specialContainerSession = specialContainerSessionList.findByPersistentId(toSession.session.persistentId);
      const fromContainerSession = specialContainerSessionList.findByPersistentId(fromSession.session.persistentId);
      if (specialContainerSession && fromContainerSession) { // find container session both in special panel
        homeLog.showInfo('[WMSMain]sceneTransitionToSpecialIfNeed find both container session in special panel: ' +
        fromContainerSession.getName() + ', ' + specialContainerSession.getName());
        toSession.setTemporarilyShowWhenLocked(true);
        SCBSceneSessionManager.getInstance().startSceneFromOtherAboveKeyguard(toSession.sceneInfo);
        return true; // break to transition on special scene panel.
      }
    }
    return false;
  }

  public onSceneStartByCall(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult {
    homeLog.showInfo('[SCBMain][id:%{public}d][sceneInfo:%{public}s/%{public}s/%{public}s/%{public}d]' +
      '[screenId:%{public}d]onSceneStartByCall with toSceneInfo:%{public}s, fromInfo:%{public}s',
      toInfo?.persistentId, toInfo?.bundleName, toInfo?.moduleName, toInfo?.abilityName, toInfo?.appIndex, toInfo?.screenId,
      toInfo?.toJsonString(), fromInfo?.toJsonString());
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(toInfo, StartInterceptions.BY_CALL, this.screenId, this.panelId)) {
      return CommonResult.FAIL;
    }
    if (!fromInfo) {
      homeLog.showError('[SCBMain]onSceneStartByCall fromInfo is null');
      return this.onRootSceneStartByCall(toInfo);
    }
    let topActiveSceneSession = this.containerSessionList.getTopActiveSession();
    let toSceneSession = this.requestSceneSession(toInfo);
    let fromSceneSession = this.getSceneSessionByPersistentId(fromInfo.persistentId);
    if (toSceneSession === null || fromSceneSession === null) {
      homeLog.showError('[SCBMain]Failed to get toSceneSession: ' + toInfo?.toJsonString() + ' or fromSceneSession: ' +
        fromInfo?.toJsonString());
      return CommonResult.FAIL;
    }
    let fromContainerSession = this.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId);
    let toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    if (fromContainerSession === null) {
      homeLog.showError('[SCBMain]Failed to get fromContainerSceneSession: ' + fromInfo?.toJsonString());
      return CommonResult.FAIL;
    }
    let isFirstCall = false;
    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      isFirstCall = true;
    }
    homeLog.showInfo(`[SCBMain]onSceneStartByCall isFirstCall:${isFirstCall} toInfo.callState:${toInfo.callState} ` +
      `scenePanelState ${this.stateCollectionHandler?.getPanelState()}`);
    if (isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.panelMgr.addSceneContainerSession(toContainerSession);
      this.startSceneWithRotationIfNeed(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.panelMgr.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
      if (topActiveSceneSession && this.needMinimizeActiveContainer(toContainerSession, topActiveSceneSession)) {
        homeLog.showInfo('[SCBMain]onSceneStartByCall topActiveSceneSession requestBackground');
        topActiveSceneSession.requestBackground();
      }
      toSceneSession.sessionData.isNewWant = true;
    } else if (isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      this.panelMgr.addNotShowRecentSession(toContainerSession);
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
      // scene should not exist in task stack when it's not show in recent, reset caller's to toPersistentId to 0
      this.linkCallerAndToPersistentForSession(toSceneSession);
    } else if (!isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.panelMgr.addSceneContainerSessionAndRemoveNotShow(toContainerSession);
      this.startSceneWithRotationIfNeed(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.panelMgr.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
      if (topActiveSceneSession && this.needMinimizeActiveContainer(toContainerSession, topActiveSceneSession)) {
        homeLog.showInfo('[SCBMain]onSceneStartByCall topActiveSceneSession requestBackground');
        topActiveSceneSession.requestBackground();
      }
      toSceneSession.sessionData.isNewWant = true;
    } else if (!isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      // 默认为false，若toContainerSession已在前台，即使要求后台拉起，也不能让toContainerSession下树
      toContainerSession.requestActivationByCall(
        toContainerSession.getPersistentId() === topActiveSceneSession?.getPersistentId());
      toSceneSession.sessionData.isNewWant = true;
      // scene should not exist in task stack when it's not show in recent, reset caller's toPersistentId to 0
      if (this.isSceneContainerSessionNotShowRecent(toContainerSession)) {
        this.linkCallerAndToPersistentForSession(toSceneSession);
      }
    } else {
      homeLog.showInfo('[SCBMain]onSceneStartByCall error callState');
    }
    let curActiveContainerSession = this.containerSessionList.getTopActiveSession();
    if (!curActiveContainerSession) {
      this.panelMgr.getPanelSession()?.setBgBlurEnable(false, 'onSceneStartByCall');
    }
    return CommonResult.SUCCESS;
  }

  public exitToBackgroundBeforeAnimation(exitScene: SCBSceneSession, needRemove: boolean) {
    if (!exitScene) {
      homeLog.showInfo(`exitToBackgroundBeforeAnimation invalid sceneSession, skip`);
      return;
    }
    if (exitScene.needDestructedInSplit) {
      exitScene.sessionData.isNewWant = false;
      this.linkCallerAndToPersistentForSession(exitScene);
      exitScene.requestSessionDestruction(needRemove);
    } else {
      if (exitScene.isActive) {
        exitScene.requestSessionBackground();
      }
    }
  }

  public onTerminateScene = (persistentId?: number, containerId?: number, needRemoveSession: boolean = false,
    needClearData: boolean = false, shouldBackToCaller: boolean = true, extraInfo?: ExecuteCallbackExtraInfo): void => {
    homeLog.showWarn(`[SCBMain][id:${persistentId}]onTerminateScene, containerId=${containerId} ` +
      `scenePanelState=${this.stateCollectionHandler?.getPanelState()} needRemoveSession=${needRemoveSession} ` +
      `needClearData=${needClearData} shouldBackToCaller=${shouldBackToCaller} ` +
      `needClearCallerLink=${extraInfo?.needClearCallerLink} isSessionException=${extraInfo?.isSessionException}`);

    let containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      homeLog.showError(`cannot find containerSession with persistentId=${persistentId}`);
      return;
    }

    let sceneSession: SCBSceneSession | null = persistentId ? this.getSceneSessionByPersistentId(persistentId) : null;
    if (!sceneSession) {
      homeLog.showError(`[SCBMain]onTerminateScene cannot find sceneSession with persistentId=${persistentId}`);
      return;
    }
    if (quickSwitchRequestActiveAlarm.isSameContainerSession(containerSession)) {
      quickSwitchRequestActiveAlarm.onAlarm();
    }
    const isActive = containerSession.isActive;
    // show the wallpaper in case of after rotation
    if (isActive && !this.isRecentState()) {
      this.showWallpaperAfterRotate();
    }
    let callerPersistentId = sceneSession.sceneInfo.callerPersistentId;
    // 若外部传参需要清理多任务，或应用配置removeMissionAfterTerminate为true，应用退出后需要清理多任务
    if (!needRemoveSession && this.needRemoveSessionAfterSceneTerminate(sceneSession, sceneSession.sceneInfo,
      extraInfo) || sceneSession.isPcAppInPad) {
      needRemoveSession = true;
    }
    const isForceClean = DeviceHelper.isPad() && sceneSession.isPcAppInPad && extraInfo?.isForceClean;
    homeLog.showWarn(`[SCBMain]onTerminateScene ${containerSession.getName()} isActive=${isActive} ` +
      `isFloat=${containerSession.isFloat} isSplit=${containerSession.isSplit} ` +
      `isMidScene=${containerSession.isMidScene} needRemoveSession=${needRemoveSession} ` +
      `isForceClean=${isForceClean}`);

    let terminateSceneEntryParam: TerminateSceneEntryParam = {
      containerSession: containerSession,
      needRemoveSession: needRemoveSession,
      needClearData: needClearData,
      isForceClean: isForceClean === undefined ? false : isForceClean,
      isSessionException: extraInfo?.isSessionException === undefined ? false : extraInfo?.isSessionException
    };
    if (containerSession?.isFloat && persistentId) {
      if (callerPersistentId && callerPersistentId !== 0) {
        let fromContainerSession = this.getSceneContainerSessionWithPersistentId(callerPersistentId);
        if (fromContainerSession) {
          this.succeedBackToCaller(containerSession, persistentId);
        }
      } else {
        SCBFloatManager.getInstance().exitFloatWithAnimator(containerSession);
      }
      terminateSceneEntryParam.isForceClean = false;
      return;
    }

    if ((containerSession.isSplit || containerSession.getState() === SCBSceneContainerState.SPLIT) && persistentId) {
      if (callerPersistentId && callerPersistentId !== 0) {
        let isVirtualTerminate = extraInfo?.isFromTerminateSession === true;
        let callerContainerSession = this.getSceneContainerSessionWithPersistentId(callerPersistentId);
      }
      let needTerminate = this.exitSplitForTerminate(persistentId, containerSession, needRemoveSession, extraInfo);
      homeLog.showWarn(`exitSplitForTerminate with persistentId: ${persistentId}, needTerminate: ${needTerminate}`);
      if (!needTerminate) {
        return;
      }
    }

    if (sceneSession.isPcAppInPad && !sceneSession.sceneInfo?.isHide) {
      homeLog.showWarn('[SCBMain]onTerminateScene, the scene is isPcAppInPad and isHide return.');
      let sceneInfo: SCBSceneInfo = sceneSession.sceneInfo;
      let callerContainerSession: SCBSceneContainerSession | null = this.getCallerContainerSession(sceneInfo);
      if (callerContainerSession != null &&
        sceneInfo.callerPersistentId != persistentId &&
        callerContainerSession.containerId !== containerSession.containerId &&
        callerContainerSession.primarySession?.isPcAppInPad &&
        callerContainerSession.primarySession?.sceneInfo?.bundleName === sceneInfo.bundleName &&
        !this.isRecentState()&&
        this.dataCollectionHandler?.getClearAllAnimCnt() === 0) {
        homeLog.showInfo('[SCBMain]onTerminateScene callerContainerSession');
        this.panelMgr.raiseSceneToTop(callerContainerSession);
        callerContainerSession.requestActivation(false);
        // as start rotation
        terminateSceneEntryParam.needClearData = false;
        this.onTerminateSceneFromBackgroundOrRecent(terminateSceneEntryParam);
        this.startSceneWithRotationIfNeed(callerContainerSession);
        this.panelAnimator.sceneContainerAppTransitionChange(containerSession, callerContainerSession, true, needRemoveSession);
        this.updateScenePanelState(ScenePanelState.FULLSCENE);
        sceneSession.sessionData.isNewWant = false;
        this.linkCallerAndToPersistentForSession(sceneSession);
        return;
      }
    }

    if (!isActive || this.isRecentState()) {
      homeLog.showWarn('[SCBMain]onTerminateScene, the scene is inActive or the scenePanelState is Recent return.');
      sceneSession.sessionData.isNewWant = false;
      if (!extraInfo?.isSessionException || needRemoveSession || extraInfo?.needClearCallerLink) {
        this.linkCallerAndToPersistentForSession(sceneSession);
      }
      terminateSceneEntryParam.needClearData = true;
      this.onTerminateSceneFromBackgroundOrRecent(terminateSceneEntryParam);
      if(extraInfo?.isSessionException) {
        containerSession.resetTransitionController();
      }
      return;
    }

    if (isActive && this.isQuickSwitchState()) {
      homeLog.showWarn('[SCBMain]onTerminateScene, the scene is active and the scenePanelState is quickSwitch return.');
      sceneSession.sessionData.isNewWant = false;
      this.linkCallerAndToPersistentForSession(sceneSession);
      this.onTerminateSceneFromActiveQuickSwitch(containerSession, needRemoveSession, needClearData);
      return;
    }

    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.HOME) {
      homeLog.showWarn('[SCBMain]onTerminateScene scenePanelState is HOME return.');
      sceneSession.sessionData.isNewWant = false;
      this.linkCallerAndToPersistentForSession(sceneSession);
      terminateSceneEntryParam.needClearData = false;
      this.onTerminateSceneFromBackgroundOrRecent(terminateSceneEntryParam);
      return;
    }

    sceneSession.sessionData.isNewWant = false;
    let sceneInfo: SCBSceneInfo = sceneSession.sceneInfo;
    homeLog.showWarn(`[SCBMain]onTerminateScene sceneInfo.callerPersistentId=${sceneInfo?.callerPersistentId}`);
    this.panelMgr.removeNotShowRecentSession(containerSession);
    const isPhoneCallRelatedScene = SCBPhoneSceneUtils.isPhoneCallScene(sceneInfo);
    // if sceneInfo.callerPersistentId is 0, the app is not started by other app, need return to desktop
    if (!shouldBackToCaller || sceneInfo === null || sceneInfo.callerPersistentId === 0) {
      homeLog.showWarn('[SCBMain]onTerminateScene, back to desktop.');
      this.quickSwitchAnimations.interruptQuickSwitchAnimationWhenExitApp(containerSession.containerId);
      performanceMonitor.begin("LAUNCHER_APP_BACK_TO_HOME", performanceMonitor.ActionType.LAST_UP,
        sceneInfo.bundleName);
      if (SCBPhoneSceneUtils.isSceneWithoutAnimation(sceneInfo)) {
        homeLog.showWarn('[SCBMain]onTerminateScene terminate without animation');
        this.sceneContainerDestructionWithoutAnimation(containerSession, needRemoveSession, isForceClean);
        performanceMonitor.end("LAUNCHER_APP_BACK_TO_HOME");
      } else if (isPhoneCallRelatedScene) {
        homeLog.showWarn('[SCBMain]onTerminateScene terminate without isPhoneCallRelatedScene');
        this.sceneContainerTransitionForPhoneCall(containerSession, null, true, needRemoveSession, true, isForceClean);
        performanceMonitor.end("LAUNCHER_APP_BACK_TO_HOME");
      } else {
        this.publishScenePanelEventMsg(CEManager.CUSTOM_BACK_HOME_EVENT, ReturnDesktopEventType.BACK_TO_HOME);
        this.panelAnimator.requestSceneContainerDestructionWithTransition(containerSession, needRemoveSession, false, isForceClean);
      }
      ViewManagerPolicy.showView(ViewType.DESKTOP);
      this.updateScenePanelState(ScenePanelState.HOME);
      if (sceneSession.sceneInfo.additionalCallers.length !== 0) {
        this.startAdditionalCallers(sceneSession.sceneInfo.additionalCallers);
        this.clearAdditionalCallers(sceneSession);
      }
      this.deleteCallerChainForSceneSession(sceneInfo);
      return;
    }
    let currScreenProperty = new SCBScreenProperty();
    currScreenProperty.copy(this.screenProperty);
    let callerContainerSession: SCBSceneContainerSession | null = sceneInfo.callerPersistentId ?
    this.getSceneContainerSessionWithPersistentId(sceneInfo.callerPersistentId) : null;
    if (callerContainerSession != null && sceneInfo.callerPersistentId != persistentId &&
      callerContainerSession.containerId !== containerSession.containerId) {
      homeLog.showInfo('[SCBMain]onTerminateScene callerContainerSession ' + callerContainerSession.getName());
      this.panelMgr.restoreNotshowToContainerList(callerContainerSession);
      if (SCBPhoneSceneUtils.isSceneWithoutAnimation(sceneInfo)) {
        homeLog.showWarn('[SCBMain]onTerminateScene terminate to caller without animation');
        this.panelMgr.raiseSceneToTop(callerContainerSession);
        callerContainerSession.requestActivation(false);
        this.startSceneWithRotationIfNeed(callerContainerSession);
        this.sceneContainerDestructionWithoutAnimation(containerSession, needRemoveSession, isForceClean);
      } else if (isPhoneCallRelatedScene) {
        homeLog.showWarn('[SCBMain]onTerminateScene terminate to caller without isPhoneCallRelatedScene');
        callerContainerSession.requestActivation(false);
        this.startSceneWithRotationIfNeed(callerContainerSession);
        this.sceneContainerTransitionForPhoneCall(containerSession, callerContainerSession, true,
          needRemoveSession, true, isForceClean);
      } else {
        if (callerContainerSession.isFloat && callerContainerSession.isActive) {
          this.requestFromContainerBackgroundOrDestruction(containerSession, true, needRemoveSession, true);
          containerSession.addTransitionCount();
          if (needRemoveSession) {
            this.getPanelManager().removeSceneContainerSession(containerSession);
            containerSession.updateTerminateStatus(true);
          }
          this.recentNotShow.notShowSessionDestroy(containerSession, this.totalContainerSessionList);
          containerSession.clearContainerSessionData();
          containerSession.isDisappearing = false;
          this.updateScenePanelState(ScenePanelState.HOME);
          return;
        }
        this.panelMgr.raiseSceneToTop(callerContainerSession);
        callerContainerSession.requestActivation(false);
        // as start rotation
        this.startSceneWithRotationIfNeed(callerContainerSession);
        this.panelAnimator.sceneContainerAppTransitionChange(containerSession, callerContainerSession, true, needRemoveSession);
      }
    } else {
      homeLog.showInfo(`[SCBMain]onTerminateScene persistentId=${persistentId} callerPersistentId=${sceneInfo.callerPersistentId}`);
      ViewManagerPolicy.showView(ViewType.DESKTOP);
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      if (SCBPhoneSceneUtils.isSceneWithoutAnimation(sceneInfo)) {
        this.sceneContainerDestructionWithoutAnimation(containerSession, needRemoveSession, isForceClean);
      } else if (isPhoneCallRelatedScene) {
        this.sceneContainerTransitionForPhoneCall(containerSession, callerContainerSession, true,
          needRemoveSession, true, isForceClean);
      } else {
        this.publishScenePanelEventMsg(CEManager.CUSTOM_BACK_HOME_EVENT, ReturnDesktopEventType.BACK_TO_HOME);
        this.panelAnimator.requestSceneContainerDestructionWithTransition(containerSession, needRemoveSession, false, isForceClean);
      }
    }
    if (sceneSession.sceneInfo.additionalCallers.length !== 0) {
      this.startAdditionalCallers(sceneSession.sceneInfo.additionalCallers);
      this.clearAdditionalCallers(sceneSession);
    }
    this.linkCallerAndToPersistentForSession(sceneSession);
  }

  public onCloseScene = (persistentId?: number, containerId?: number, needRemoveSession: boolean = true,
    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void => {
    this.onTerminateScene(persistentId, containerId, needRemoveSession, true, false, extraInfo);
  }

  public addAdditionalCallers(sceneSession: SCBSceneSession, caller: CallerInfo): void {
    if (!sceneSession || !caller) {
      homeLog.showWarn('[SCBMain]addAdditionalCallers invalid params');
      return;
    }
    homeLog.showInfo(`[SCBMain]addAdditionalCallers persistentId: ${sceneSession.sceneInfo.persistentId}, `+
      `callerPersistentId: ${caller.persistentId} mode: ${caller.windowMode}`);
    const index = sceneSession.sceneInfo.additionalCallers.findIndex(
      item => item.persistentId === caller.persistentId && item.windowMode === caller.windowMode);
    if (index !== -1) {
      homeLog.showWarn('addAdditionalCallers already exist')
      return;
    }
    sceneSession.sceneInfo.additionalCallers.push(caller);
  }

  private clearAdditionalCallersCallback = (sceneSession: SCBSceneSession | null, needRecursive: boolean = false) => {
    this.clearAdditionalCallers(sceneSession, needRecursive);
  };

  public clearAdditionalCallers(sceneSession: SCBSceneSession | null, needRecursive: boolean = false): void {
    if (!sceneSession) {
      homeLog.showWarn('[SCBMain]clearAdditionalCallers sceneSession is invalid');
      return;
    }
    homeLog.showInfo(`[SCBMain]clearAdditionalCallers persistentId: ${sceneSession.sceneInfo.persistentId}, `+
      `needRecursive: ${needRecursive}`);
    sceneSession.sceneInfo.additionalCallers.length = 0;
    if (needRecursive && sceneSession.sceneInfo.callerPersistentId) {
      let callerSession = this.getSceneSessionByPersistentId(sceneSession.sceneInfo.callerPersistentId);
      let count = 0;
      let totalListSize = this.containerSessionList.length + this.containerSessionListNotShowRecent.length;
      while (callerSession && count <= totalListSize) {
        callerSession.sceneInfo.additionalCallers.length = 0;
        callerSession = callerSession.sceneInfo.callerPersistentId ? this.getSceneSessionByPersistentId(callerSession.sceneInfo.callerPersistentId) : null;
        count++;
      }
    }
  }

  public clearAdditionalCallersForContainerSession(
    sceneContainerSession: SCBSceneContainerSession, needRecursive: boolean = false): void {
    this.clearAdditionalCallers(sceneContainerSession.primarySession, needRecursive);
    this.clearAdditionalCallers(sceneContainerSession.secondarySession, needRecursive);
  }

  public deleteAdditionalCallers(sceneSession: SCBSceneSession, caller: CallerInfo): void {
    if (!sceneSession || !caller) {
      homeLog.showWarn('[SCBMain]deleteAdditionalCallers invalid params');
      return;
    }
    homeLog.showInfo(`[SCBMain]deleteAdditionalCallers persistentId: ${sceneSession.sceneInfo.persistentId}, `+
      `callerPersistentId: ${caller.persistentId} mode: ${caller.windowMode}`);
    const index = sceneSession.sceneInfo.additionalCallers.findIndex(
      item => item.persistentId === caller.persistentId && item.windowMode === caller.windowMode);
    if (index !== -1) {
      sceneSession.sceneInfo.additionalCallers.splice(index, 1);
    }
  }

  private startAdditionalCallers(additionalCallers: Array<CallerInfo>){
    homeLog.showInfo('[SCBMain]startAdditionalCallers run');
    for (const caller of additionalCallers) {
      switch (caller.windowMode) {
        case SCBSceneMode.FLOATING:
          break;
        default:
          break;
      }
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Split
  // ----------------------------------------------------------------------------------------------------

  public minimizeAllScene(isFromRecent: boolean = false): void {
    homeLog.showInfo('[SCBMain]minimizeAllScene: gesture into home start, scenePanelState ' +
      this.stateCollectionHandler?.getPanelState() + ' isFromRecent ' + isFromRecent);
    this.showStatusBar(true);
    this.stateCollectionHandler?.getViewParam().initAll();
    let isFromAPP: boolean = false;
    ContainerBuilder.resetAllContainerPreBuildStage(this.containerSessionList);
    let bundleContainerMap: Map<string, number> = new Map<string, number>();
    let containerSession: SCBSceneContainerSession | undefined = undefined;
    let listLen = this.containerSessionList.length;
    this.containerSessionList.forEach((sceneContainerSession, idx) => {
      let nameDfx = sceneContainerSession.getName();
      if (!sceneContainerSession.isActive) {
        // 从多任务返回桌面时，非当前应用需要播放远离动效，不能直接消失
        if (!isFromRecent) {
          sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'minimizeAllScene', nameDfx);
          sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
          sceneContainerSession.needRenderPos.setPosXWithDfx(0, TAG, 'minimizeAllScene', nameDfx);
          sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'minimizeAllScene', nameDfx);
        }
        homeLog.showInfo('minimizeAllScene: ContainerSession not active, name ' + nameDfx);
        if (idx == listLen - 1) {
          this.exitSceneWithRotationRecover();
        }
        return;
      }
      sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'minimizeAllScene', nameDfx);
      sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      sceneContainerSession.needRenderPos.setPosXWithDfx(0, TAG, 'minimizeAllScene', nameDfx);
      sceneContainerSession.changeState(SCBSceneContainerState.HIDDEN);
      performanceMonitor.begin("LAUNCHER_APP_SWIPE_TO_HOME", performanceMonitor.ActionType.LAST_UP,
        sceneContainerSession.companionIconInfo?.bundleName);
      homeLog.showInfo('[SCBMain]minimizeAllScene gesture into home start, name ' + nameDfx);
      // remove caller when minimize
      this.deleteCallerChainForContainerSession(sceneContainerSession);
      this.clearAdditionalCallersForContainerSession(sceneContainerSession);
      recentRuntimeInstance.reportReturnToHome(HiSysReturnHomeData.FROM_APP,
        sceneContainerSession.companionIconInfo?.bundleName, sceneContainerSession.isMidScene);
      isFromAPP = true;
      AnimateToScheduleUtils.reportSwipeUpExitApp(sceneContainerSession.companionIconInfo?.bundleName);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      if (this.folderData.isFolderOpen()) {
        CloseAppManager.getInstance().setIsMinimizeAllSceneClosingFolder();
        this.folderData.close('sceneContainerTransitionOut', FolderOperationFlag.IMMEDIATELY);
      }
      CloseAppManager.getInstance().setIsMinimizeAllScene(true);
      sceneContainerSession.setAnimatingReason(WindowAnimationReason.MINIMIZE_ALL);
      this.requestSceneContainerBackgroundWithTransition(sceneContainerSession, true);
    })
    this.updateScenePanelState(ScenePanelState.HOME);
    this.stateCollectionHandler?.getRecentInnerState()?.onInit();
    if (!isFromAPP) {
      recentRuntimeInstance.reportReturnToHome(HiSysReturnHomeData.FROM_DESKTOP);
    }
    this.publishScenePanelEventMsg(CEManager.CUSTOM_RETURN_DESKTOP_EVENT, ReturnDesktopEventType.SLIP_UP);
  }

  private isSceneContainerSessionNotShowRecent(sceneContainerSession: SCBSceneContainerSession): boolean {
    if (!sceneContainerSession) {
      return false;
    }
    const index = this.containerSessionListNotShowRecent.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    return false;
  }

  public requestSceneContainerBackgroundWithTransition(sceneContainerSession: SCBSceneContainerSession, isToDeskTop?: boolean) {
    sceneContainerSession.requestBackgroundWithTransitionOut(true, isToDeskTop);

    // 动效打断设置
    let session = sceneContainerSession.getFocusedSession();
    let adapterSceneInfo: SCBSceneInfo | undefined = session?.sceneInfo;
    if (adapterSceneInfo?.bundleName === VassistantConstants.VASSISTANT_BUNDLE_NAME) {
      adapterSceneInfo = SceneInfoAdapterUtil.getAdapterSceneInfo(adapterSceneInfo.bundleName,
        adapterSceneInfo.moduleName, adapterSceneInfo.abilityName, adapterSceneInfo.appIndex);
    }
    const companionIconInfoBundleName: string | undefined = sceneContainerSession.companionIconInfo?.bundleName;
    const primarySessionBundleName: string | undefined = sceneContainerSession.primarySession?.sceneInfo.bundleName;
    homeLog.showInfo(`exitApp bundleName is: ${companionIconInfoBundleName}, primarySessionBundleName is: ${primarySessionBundleName}`);
    if (companionIconInfoBundleName && primarySessionBundleName && companionIconInfoBundleName !== primarySessionBundleName) {
      if (sceneContainerSession.companionIconInfo.startAppType !== StartType.AI_SUGGESTION_APP) {
        sceneContainerSession.companionIconInfo.startAppType = StartType.APP;
      }
    }
    let controller = this.getTargetTransitionController(sceneContainerSession, adapterSceneInfo, true);
    this.setTransitionAnimCancel(controller, sceneContainerSession, 'requestSceneContainerBackgroundWithTransition');

    // 画中画一镜到底
    if(PipOneShotAnimHelper.checkStartPipTransitionOut({
      transitionController: controller,
      containerSession: sceneContainerSession,
      needRemoveSession: false,
      panelViewModel: this,
      needRotate: (!this.isRotateScreenPolicy() && !this.screenProperty.isScreenVertical()) ||
      SCBWindowRotateController.getInstance().isLandscapeStartInterrupt()
    })) {
      return;
    }

    // 应用回胶囊
    if (OverlayStartAnimHelper.checkStartOverlayTransitionOut({
      transitionController: controller,
      scenePanelManager: this.panelMgr,
      containerSession: sceneContainerSession,
      needRemoveSession: false,
      triggerType: OverlayStartAnimHelper.TRIGGER_TYPE_APP_SWIPE_UP_TO_CAPSULE
    })) {
      return;
    }

    this.panelAnimator.sceneContainerTransitionOut(sceneContainerSession, controller, session);
  }
  // ----------------------------------------------------------------------------------------------------
  // Scene Split
  // ----------------------------------------------------------------------------------------------------

  public handleSplitScreen(containerSession: SCBSceneContainerSession | null, screenProperty: SCBScreenProperty,
    needHideKeyboard: boolean = false) {
    if (containerSession && containerSession.isSplit && !containerSession.isOneStepSplit()) {
      let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
      if (keyboardSession && keyboardSession.isActive && needHideKeyboard) {
        animateToImmediately({
          curve: curves.springMotion(0.5, 1, 0),
        }, () => {
          keyboardSession.translatePosY = 1.5 * keyboardSession.getKeyboardPanelTranslateY();
        });
        SCBKeyboardManager.getInstance().requestHideKeyboard(containerSession.mainSession);
        return;
      }
    }
  }

  /**
   * split animation on three-fold
   *
   * @param containerSession
   */
  public updateSplitOnThreeFold(containerSession: SCBSceneContainerSession | null): void {
    if (containerSession && SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      if (DeviceHelper.isThreeFoldProduct()) {
        if (SCBSplitUtils.hasFixedSplitRatioScene(containerSession)) {
          winLog.showInfo('[SCBSplit] fixed split ratio, orientation unchanged, skip rotation anim');
          return;
        }
      }
      animateTo({ duration: 0 }, () => {
        containerSession.dividerParam.dividerAlpha = 0;
      })
    }
  }

  private removeExistSession(persistentId: number){
    // if new start app is from split, need exit split firstly
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (sceneContainerSession && sceneContainerSession.isSplit && sceneContainerSession.primarySession &&
    sceneContainerSession.secondarySession) {
      winLog.showInfo(`removeExistsSession session is already in split will exit, exitId: ${persistentId}`);
      // here need update sceneContainerSession, because when exit split in recent, it has changed
      sceneContainerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
      if (sceneContainerSession) {
        this.minimizeSplitScene(sceneContainerSession, persistentId, true, false);
      }
    } else if (sceneContainerSession)  {
      winLog.showInfo(`removeExistsSession session is already in full will exit, exitId: ${persistentId}`);
      sceneContainerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
      if (sceneContainerSession) {
        this.panelMgr.removeSceneContainerSession(sceneContainerSession);
      }
    }
  }

  public startSplitFromIcon(sceneSession: SCBSceneSession, sceneInfo: SCBSceneInfo){
    homeLog.showInfo(`onStartSceneFromIcon container new one, isNewWant=${sceneSession.isNewWant}`);
    let activeSceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
    let persistentId: ESObject = sceneSession.session.persistentId;
    this.removeExistSession(persistentId);
    activeSceneContainerSession.addSceneSession(sceneSession); // need to change
    sceneSession.requestSessionActivation();
    this.panelMgr.addSceneContainerSession(activeSceneContainerSession);
    this.panelMgr.raiseSceneToTop(activeSceneContainerSession);
    activeSceneContainerSession.requestActivation(sceneSession.isNewWant);
    sceneSession.sessionData.isNewWant = true;
    SCBSceneSessionManager.getInstance().startSplitFromIcon(sceneInfo.screenId, sceneSession.session.persistentId,
      activeSceneContainerSession.containerId);
  }

  public pairSplit(sceneSession: SCBSceneSession | null, sceneInfo: SCBSceneInfo): void {
    if (!sceneSession) {
      homeLog.showWarn('pairSplit with illegal sceneSession');
      return;
    }
    if (!sceneInfo) {
      homeLog.showWarn('pairSplit with illegal sceneInfo');
      return;
    }
    let activeSceneContainerSession = this.containerSessionList.getTopActiveSession();
    if (!activeSceneContainerSession) {
      homeLog.showWarn('pairSplit with no active scene container session');
      return;
    }
    let bundleName: string = sceneInfo.bundleName;
    if (bundleName === VassistantConstants.VASSISTANT_BUNDLE_NAME) {
      bundleName = VassistantConstants.VASSISTANT_LAUNCHER_BUNDLE_NAME;
    }
    let transitionController = SCBTransitionManager.getInstance()
      .findTransitionController(bundleName, () => {
        return PageDesktopModel.getInstance().getCloseAppData(bundleName, sceneInfo.abilityName,
          undefined, undefined, undefined, sceneInfo.appIndex);
      });
    activeSceneContainerSession.initCompanionIconInfo(sceneInfo, transitionController);
    activeSceneContainerSession.splitParam.setLifeCycle(SplitLifeCycle.EXIT_ONESTEP_TO_SPLIT);

    let persistentId: ESObject = sceneSession.session.persistentId;
    this.removeExistSession(persistentId);
    sceneSession.requestSessionActivation();
    activeSceneContainerSession.addSceneSession(sceneSession); // need to change
    this.panelMgr.raiseSceneToTop(activeSceneContainerSession);
    sceneSession.sessionData.isNewWant = true;
    winLog.showInfo(`[SCBSplit] startscene to pairSplit:%{public}s, new session persistentId:%{public}d, windowMode:%{public}d`,
      activeSceneContainerSession.getName(), persistentId, sceneInfo.windowMode);
    let lastRotation = activeSceneContainerSession.currentRotation;
    this.startSceneWithRotationIfNeed(activeSceneContainerSession);
    this.updateScenePanelState(ScenePanelState.FULLSCENE, false);
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
    activeSceneContainerSession.dividerParam.initSplitWidthLimits(activeSceneContainerSession);
    this.initBeforePairSplitAnim(activeSceneContainerSession, lastRotation);
    activeSceneContainerSession.splitParam.clearSplitRatioCacheForPad();
    activeSceneContainerSession.changeState(SCBSceneContainerState.SPLIT);
    activeSceneContainerSession.primarySession?.setExitSplitOnBackground(false, 'pairSplit');
    activeSceneContainerSession.secondarySession?.setExitSplitOnBackground(false, 'pairSplit');
    activeSceneContainerSession.sessionData.preferSplitBackToFull = false;
    this.secondarySceneTransitionIn(activeSceneContainerSession, transitionController);
    SCBSplitManager.getInstance().refreshSplitContainer(activeSceneContainerSession, activeSceneContainerSession.screenProperty);
  }

  private initBeforePairSplitAnim(container: SCBSceneContainerSession, lastRotation: number) {
    animateTo({ duration: 0 }, () => {
      if (!container) {
        return;
      }
      container.splitParam.oneStepBreakFlag = false;
      let oneStepTrans: number = container.dividerParam.calOneStepDefaultTrans(
        this.screenProperty);
      container.dividerParam.doOneStepTranslate(oneStepTrans);
      let splitRatio: number = DividerStyleConstants.SPLIT_RATIO_HALF;
      container.dividerParam.updateDividerParamWithRatio(this.screenProperty, splitRatio);
    });
  }

  private secondarySceneTransitionIn(activeSceneContainerSession: SCBSceneContainerSession,
    transitionController: SCBTransitionController): void {
    this.stateCollectionHandler?.updateCompanionIconShowState(true);
    activeSceneContainerSession.addTransitionCount();
    let animationNum: number = activeSceneContainerSession.getTransitionCount();
    activeSceneContainerSession.dividerParam.secondary.sessionOpacity = 0.0;

    activeSceneContainerSession.iconAlpha = 1.0;
    activeSceneContainerSession.badgeAlpha = 1.0;
    PageDesktopModel.getInstance().onTransitionActiveForSplit(activeSceneContainerSession);
    this.stateCollectionHandler?.updateIconWithBadgeState(false);

    SCBTransitionManager.getInstance().addStartExitAnimationCount('secondarySceneTransitionIn');
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'secondarySceneTransitionIn', true, expandStatus);
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    homeLog.showInfo(`${TraceUtil.CORE_METHOD_START_APP_ANI}:start`);
    transitionController?.onActive(TAG, 'secondarySceneTransitionIn');
    this.stateCollectionHandler?.updateBgGrayScaleDisableState(true);
    animateToImmediately({
      curve: curves.springMotion((this.isNewStyle ?
      StartAndExitUtil.getResponse(StartAndExitResponse.OTHER_START) : 0.285), 1.157, 0),
      onFinish: () => {
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        homeLog.showInfo(`${TraceUtil.CORE_METHOD_START_APP_ANI}:end`);
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount('secondarySceneTransitionIn end');
        activeSceneContainerSession.transitionInFinishIfNeed(animationNum);
        activeSceneContainerSession.splitParam.setLifeCycle(SplitLifeCycle.SPLIT);
      }
    }, () => {
      activeSceneContainerSession.onTransitionInactiveForSplit();
      activeSceneContainerSession.dividerParam.setBorderRadius();
    })
    SCBTransitionManager.getInstance().notifySceneTransitionIn(transitionController, true, false);
    this.panelMgr.onBlurTransitionActive(0.8, 'SCBScenePanel > secondarySceneTransitionIn');
    animateTo({
      curve: curves.springMotion(0.33, 1.157)
    }, () => {
      activeSceneContainerSession?.dividerParam.clearPrimaryDynamicVariable();
    })
    // let reason = DeviceHelper.isThreeFoldProduct() &&
    let reason: ESObject = DeviceHelper.isThreeFoldProduct() &&
      (activeSceneContainerSession.splitParam.getSplitRatioCache(SplitRatioCacheKey.G_MODE_DIVIDER_RATIO) >
      SplitRatioEnum.UNDEFINED) ? sceneSessionManager.SessionSizeChangeReason.FULL_TO_SPLIT : undefined;
    activeSceneContainerSession.updateSessionRectForSplit(activeSceneContainerSession.screenProperty, true, reason);
    activeSceneContainerSession.dividerParam.blackBackgroundOpacity = 0.1;
    animateTo({
      curve: Curve.Sharp,
      delay: 400,
      duration: 150
    }, () => {
      if (activeSceneContainerSession) {
        activeSceneContainerSession.dividerParam.blackBackgroundOpacity = 1;
        activeSceneContainerSession.dividerParam.grayscaleOpacity = 1;
      }
    })

    animateTo({
      delay: 15,
      duration: 50,
      curve: Curve.Linear,
      onFinish: () => {
        this.stateCollectionHandler?.updateIconWithBadgeState(false);
      }
    }, () => {
      activeSceneContainerSession.dividerParam.secondary.sessionOpacity = 1.0;
      if (this.isNewStyle && this.stateCollectionHandler?.getIconWithBadgeState()) {
        activeSceneContainerSession.badgeAlpha = 0.0;
      }
    })

    animateToImmediately({
      delay: 55,
      duration: 60,
      curve: Curve.Linear
    }, () => {
      activeSceneContainerSession.iconAlpha = 0.0;
    })
  }

  /**
   * pair split in one same app
   */
  public pairSplitIfInOneApp(fromContainerSession: SCBSceneContainerSession | null,
    callerSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null, toSceneSession: SCBSceneSession,
    sceneInfo: SCBSceneInfo): boolean {
    if (fromContainerSession === null) {
      return false;
    }
    // check if virtual scene need to be split
    let topContainer: SCBSceneContainerSession | null = this.containerSessionList.getTopActiveSession();

    if (fromContainerSession?.findSceneSessionByPersistentId(toSceneSession.session.persistentId)) {
      winLog.showInfo(`[SCBSplit] pairSplitIfInOneApp requestSessionActivation`);
      toSceneSession.requestSessionActivation(toSceneSession.isNewWant);
      toSceneSession.sessionData.isNewWant = true;
      return true;
    }
    winLog.showInfo(`[SCBSplit] pairSplitIfInOneApp, fromContainer: ${fromContainerSession.getName()}, sceneInfo.windowMode:${sceneInfo.windowMode}`);
    // if new start app is from float, need remove it from float firstly
    // this.removeBackgroundSession(toSceneSession);
    if (!SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      fromContainerSession.splitParam.clearGModeSplitRatioCache();
    }
    if (uiType === SCBConstants.UITYPE_PAD) {
      fromContainerSession.splitParam.clearSplitRatioCacheForPad();
    }
    // return true;
    return false;
  }

  private removeSceneSessionInSplitContainer(sceneSession: SCBSceneSession) {
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    // pair split, the later process will add new start sceneSession to current active containerSession, so here need
    // remove it's original sceneContainerSession
    this.panelMgr.removeSceneContainerSession(sceneContainerSession);
  }

  public removeFloatContainerSessionIfNeed(persistentId?: number, containerId?: number): boolean {
    let floatSessionIndex = this.floatingSessionList.findIndex(item => {
      return item.primarySession?.session.persistentId === persistentId || item.containerId === containerId
    });
    homeLog.showInfo(`removeFloatContainerSessionIfNeed persistentId: ${persistentId}`);
    if (floatSessionIndex !== -1) {
      let floatingSession = this.floatingSessionList[floatSessionIndex];
      if (floatingSession.floatingParam.needRecoverStatusBar) {
        floatingSession.floatingParam.needRecoverStatusBar = false;
        SCBSceneSessionManager.getInstance().updateNavigationBarProperty(true);
      }
      floatingSession.requestDestruction(true);
      this.panelMgr.removeFloatContainerSessionByIndex(floatSessionIndex);
      let totalContainerSessionList = this.totalContainerSessionList;
      if (this.isRecentState() && totalContainerSessionList) {
        this.exitRecent();
      }
      SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange();
      return true;
    }
    return false;
  }

  public checkAndAddRetainedContainer(needRemove: boolean, sceneSession: SCBSceneSession,
    screenProperty: SCBScreenProperty, index: number) {
    if (!needRemove) {
      let container = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      sceneSession.updateCurRectForMultiWindowToFull(screenProperty);
      container.initAll();
      container.isSplit = false;
      this.panelMgr.addSceneContainerSessionByIndex(index, container);
      container.getData(ContainerDataCategory.BASIC)?.setLastUsedPosition(DeviceHelper.getCurrentDeviceScene());
    }
  }

  public exitToBackground(sceneSession: SCBSceneSession | null, index: number,
    screenProperty: SCBScreenProperty): void {
    if (!sceneSession) {
      homeLog.showError('exitToBackground, invalid sceneSession, skip');
      return;
    }
    let container = new SCBSceneContainerSession(sceneSession, screenProperty);
    let deviceScene = DeviceHelper.getCurrentDeviceScene();
    winLog.showInfo(`exitToBackground container: ${container.getName()} deviceScene: ${deviceScene}`);
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    container.primarySession?.updateCurRectForMultiWindowToFull(screenProperty);
    container.initAll();
    container.isSplit = false;
    this.panelMgr.addSceneContainerSessionByIndex(index, container);
    container.changeState(SCBSceneContainerState.HIDDEN);
    container.getData(ContainerDataCategory.BASIC)?.setLastUsedPosition(deviceScene);
    if (sceneSession.isActive) {
      sceneSession.requestSessionBackground();
    }
    this.resetVirtualNeedTerminate();
  }

  /**
   * reset flag and execute onTerminateScene which intercepted before
   */
  public resetVirtualNeedTerminate() {
    this.isVirtualInExitAnim = false;
    if (this.isVirtualNeedTerminate) {
      try {
        this.onTerminateScene(this.terminateParams?.persistentId, this.terminateParams?.containerId,
          this.terminateParams?.needRemoveSession, this.terminateParams?.needClearData,
          this.terminateParams?.shouldBackToCaller, this.terminateParams?.extraInfo);
      } catch (err) {
        homeLog.showError(`resetVirtualNeedTerminate fail. ${err?.message}`);
      }
    }
    this.isVirtualNeedTerminate = false;
    this.terminateParams = undefined;
  }

  private terminateSplitScene(sceneSession: SCBSceneSession, index: number, needRemove: boolean,
    screenProperty: SCBScreenProperty) {
    winLog.showInfo(`terminateSplitScene, session: ${sceneSession.getName()}, needRemove ${needRemove}`);
    this.checkAndAddRetainedContainer(needRemove, sceneSession, screenProperty, index);
    sceneSession.sessionData.isNewWant = false;
    sceneSession.needDestructedInSplit = false;
    this.linkCallerAndToPersistentForSession(sceneSession);
    sceneSession.requestSessionDestruction(needRemove);
  }

  public exitSplitToBackground(sceneSession: SCBSceneSession | null, index: number, needRemove: boolean = false,
    screenProperty?: SCBScreenProperty) {
    if (!sceneSession || !screenProperty) {
      winLog.showError('exitSplitToBackground invalid sceneSession, skip');
      return;
    }
    winLog.showInfo(`exitSplitToBackground needDestructedInSplit:${sceneSession.needDestructedInSplit}`);
    sceneSession.setExitSplitOnBackground(true, 'exitSplitToBackground');
    if (sceneSession.needDestructedInSplit) {
      this.terminateSplitScene(sceneSession, index, needRemove, screenProperty);
    } else {
      this.exitToBackground(sceneSession, index, screenProperty);
    }
  }

  private checkIfSplitScene(reason?: SCBContainerRotationReason): boolean {
    return reason === SCBContainerRotationReason.SPLIT_SCENE ||
      reason === SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE;
  }

  public exitSplitViewForRecent(index: number, curContainerSession: SCBSceneContainerSession,
    isPrimaryExit: boolean, needRemove: boolean) {
    let exitSession = isPrimaryExit ? curContainerSession.primarySession : curContainerSession.secondarySession;
    let anotherSession = isPrimaryExit ? curContainerSession.secondarySession : curContainerSession.primarySession;
    curContainerSession.removeSceneSession(exitSession);
    curContainerSession.updateRecentTitleView();
    curContainerSession.dividerParam.init();
    curContainerSession.primarySession?.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    curContainerSession.primarySession?.updateCurRectForMultiWindowToFull(curContainerSession.screenProperty);
    curContainerSession.isSplit = false;
    curContainerSession.changeState(SCBSceneContainerState.HIDDEN);
    anotherSession?.setExitSplitOnBackground(true, 'exitSplitViewForRecent');
    this.exitSplitToBackground(exitSession, index, needRemove, this.screenProperty);
    this.exitSceneWithRotationRecover(curContainerSession);
  }

  private enterToOneStepWithTranslate(container: SCBSceneContainerSession | null,
    foregroundSession: SCBSceneSession | null, isPrimaryExit: boolean) {
    if (!container) {
      winLog.showError('enterToOneStepWithTranslate, containerSession is invalid');
      return;
    }
    if (!foregroundSession) {
      winLog.showError('enterToOneStepWithTranslate, foregroundSession is invalid');
      return;
    }
    winLog.showInfo(`enterToOneStepWithTranslate, persistentId:${foregroundSession.sceneInfo.persistentId}`);
    this.exitSceneWithRotationRecover(container, SCBContainerRotationReason.SPLIT_SCENE);
    if (container.splitParam.getLifeCycle() === SplitLifeCycle.UNDEFINED) {
      winLog.showInfo(`enterToOneStepWithTranslate return, life cycle UNDEFINED, ${container?.getName()}`);
      return;
    }
    animateToImmediately({
      curve: curves.springMotion(0.55, 0.85),
      delay: 400,
      onFinish: () => {
        winLog.showInfo('animateToImmediately:one step split end');
      }
    }, () => {
      let dividerParam = container.dividerParam;
      dividerParam.updateDividerParamWithRatio(container.screenProperty);
      let oneStepTrans: number = dividerParam.calOneStepDefaultTrans(container.screenProperty);
      dividerParam.setOneStepDefaultPos(oneStepTrans, container.screenProperty);
      dividerParam.notifyPositionChange();
      dividerParam.resetSceneRotate();
      dividerParam.primary.setBorderRadius({
        topLeft: DividerStyleConstants.SPLIT_BORDER_RADIUS,
        topRight: DividerStyleConstants.SPLIT_BORDER_RADIUS,
        bottomLeft: DividerStyleConstants.SPLIT_BORDER_RADIUS,
        bottomRight: DividerStyleConstants.SPLIT_BORDER_RADIUS
      }, 'enterToOneStepWithTranslate');
      SCBSplitManager.getInstance().refreshSplitContainer(container, container.screenProperty);
    })
    foregroundSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    SCBSceneSessionManager.getInstance()
      .requestFocus(foregroundSession.session.persistentId, false, FocusChangeReason.SPLIT_SCREEN);
  }

  public exitSplitViewForBackToOneStep(isPrimaryExit: boolean, index: number, container: SCBSceneContainerSession,
    needRemove: boolean) {
    let foregroundSession = isPrimaryExit ? container.secondarySession : container.primarySession;
    let backgroundSession = isPrimaryExit ? container.primarySession : container.secondarySession;
    if (backgroundSession?.isAutoStartPiP) {
      winLog.showInfo('back gesture: exit split no start pip window');
      backgroundSession.isNeedStartPiP = false;
    }
    container.removeSceneSession(backgroundSession);
    container.changeState(SCBSceneContainerState.ONE_STEP);
    this.enterToOneStepWithTranslate(container, foregroundSession, isPrimaryExit);
    foregroundSession?.setExitSplitOnBackground(true, 'exitSplitViewForBackToOneStep');
    if (!backgroundSession) {
      winLog.showError('exitSplitViewForBackToOneStep invalid sceneSession, skip');
      return;
    }
    backgroundSession.setExitSplitOnBackground(true, 'exitSplitToBackground');
    if (backgroundSession.needDestructedInSplit) {
      this.checkAndAddRetainedContainer(needRemove, backgroundSession, container.screenProperty, index);
      backgroundSession.needDestructedInSplit = false;
    } else {
      this.exitToBackground(backgroundSession, index, container.screenProperty);
    }
  }

  private keepFullScreenForegroundForSplit(foregroundSession: SCBSceneSession | null,
    curContainerSession: SCBSceneContainerSession, needAnimation: boolean = true): void {
    if (!foregroundSession) {
      winLog.showError('keepFullScreenForgroundForSplit, no forgroundSession');
      return;
    }
    curContainerSession.initAll();
    curContainerSession.isSplit = false;
    foregroundSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    foregroundSession.updateCurRectForMultiWindowToFull(curContainerSession.screenProperty);
    curContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN)
    if (!foregroundSession.isSubSessionFocused() && !foregroundSession.isDialogSessionFocused()) {
      SCBSceneSessionManager.getInstance()
        .requestFocus(foregroundSession.session.persistentId, false, FocusChangeReason.SPLIT_SCREEN);
    }
    winLog.showInfo(`keepFullScreenForgroundForSplit, curContainerSession: ${curContainerSession.containerId}, ` +
      `bundleName: ${foregroundSession.sceneInfo.bundleName}, persistentId: ${foregroundSession.session.persistentId}`);
  }

  private exitSplitViewForFullScreen(persistentId: number, isPrimaryExit: boolean, index: number,
    curContainerSession: SCBSceneContainerSession, needAnimation: boolean = true,
    needRemove: boolean = false, needBackground: boolean = true) {
    homeLog.showInfo(`exitSplitViewForFullScreen persistentId=${persistentId},isPrimaryExit=${isPrimaryExit},
    index=${index},needAnimation=${needAnimation},needRemove=${needRemove},needBackground=${needBackground},`);
    let foregroundSession = isPrimaryExit ? curContainerSession.secondarySession : curContainerSession.primarySession;
    let backgroundSession = isPrimaryExit ? curContainerSession.primarySession : curContainerSession.secondarySession;

    curContainerSession.removeSceneSession(backgroundSession);
    this.keepFullScreenForegroundForSplit(foregroundSession, curContainerSession, needAnimation);
    if (needBackground && backgroundSession) {
      this.exitSplitToBackground(backgroundSession, index, needRemove, curContainerSession.screenProperty);
    }
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.HOME) {
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
    } else if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE, false);
    } else {
      this.initView();
      this.enterRecentView(false);
      this.panelFsm.setCurrentStateToRecent();
      curContainerSession.dividerParam.blackBackgroundOpacity = 0;
    }
    curContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'exitSplitViewForFullScreen',
      curContainerSession.getName());
    curContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
  }

  private transformSplitViewForFullScreen(persistentId: number, isPrimaryExit: boolean, index: number,
    curContainerSession: SCBSceneContainerSession, needAnimation: boolean = true, needRemove: boolean = false,
    needBackground: boolean = true) {
    homeLog.showInfo('transformSplitViewForFullScreen enter');
    this.exitSplitViewForFullScreen(persistentId, isPrimaryExit, index,
      curContainerSession, needAnimation, needRemove, needBackground);

    curContainerSession.splitParam.setLifeCycle(SplitLifeCycle.UNDEFINED);
    curContainerSession.sessionData.preferSplitBackToFull = true;
  }

  /**
   * determine exitId by isStartFromVirtual or getNeedExitSceneSession
   * @param containerSession
   * @param isVirtualOnVoice
   * @returns
   */
  private getPersistentIdToExitSplit(containerSession: SCBSceneContainerSession, isVirtualOnVoice: boolean): number {
    if (isVirtualOnVoice) {
      if (containerSession.primarySession) {
        winLog.showInfo(`[SCBSplit] getPersistentIdToExitSplit return primarySession`);
        return containerSession.primarySession.session.persistentId;
      } else if (containerSession.secondarySession) {
        winLog.showInfo(`[SCBSplit] getPersistentIdToExitSplit return secondarySession`);
        return containerSession.secondarySession.session.persistentId;
      }
    }
    return containerSession.getNeedExitSceneSession().session.persistentId;
  }

  /**
   * exit oneStepSplit or splitView to fullScene
   * @param currContainerSession
   * @param isVirtualOnVoice
   */
  private exitSplitViewToFullScene(currContainerSession: SCBSceneContainerSession, isVirtualOnVoice: boolean = false): void {
    let sceneInfo: SCBSceneInfo | undefined = undefined;
    if (currContainerSession.isOneStepSplit() && currContainerSession.primarySession) {
      this.maximizeSplitScene(currContainerSession.primarySession.session.persistentId, currContainerSession);
    } else if (currContainerSession.isSplitView()) {
      if (currContainerSession.isActive) {
        this.minimizeSplitScene(currContainerSession,
          this.getPersistentIdToExitSplit(currContainerSession, isVirtualOnVoice));
      }
      if (!isVirtualOnVoice) {
        sceneInfo = currContainerSession.primarySession?.isFixedMultiWindowOrientation ?
          currContainerSession.primarySession?.sceneInfo : currContainerSession.secondarySession?.sceneInfo;
      }
    }
    this.resetWindowEffect(currContainerSession);
  }

  /**
   * exit splitView by expand to fold
   */
  public exitSplitViewByExpandToFold = (persistentId?: number, containerId?: number): void => {
    let currContainerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (currContainerSession === null || !currContainerSession.isSplit) {
      winLog.showInfo(`exitSplitViewByExpandToFold cannot exit split with containerId:${containerId}`);
      return;
    }
    let isVirtualOnVoice: boolean = false;
    let exitId: number | undefined = currContainerSession?.secondarySession?.session.persistentId;
    if (isVirtualOnVoice && exitId) {
      this.exitSplitViewToFullScene(currContainerSession, isVirtualOnVoice);
    } else {
      if (DeviceHelper.isThreeFoldProduct()) {
        this.exitSplitViewInFixedMultiWindowOrientation(currContainerSession.primarySession?.sceneInfo.persistentId,
          currContainerSession.containerId);
      }
    }
  }

  public exitSplitViewInFixedMultiWindowOrientation = (persistentId?: number, containerId?: number): void => {
    winLog.showInfo(`[SCBSplit] exitSplitViewInFixedMultiWindowOrientation with persistentId:${persistentId} containerId:${containerId}`);
    let currContainerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (currContainerSession === null ||
      !currContainerSession.isSplit || !currContainerSession.hasFixedMultiWindowOrientationSession()) {
      winLog.showError(`exitSplitViewInFixedMultiWindowOrientation cannot exit split with containerId:${containerId}`);
      return;
    }
    this.exitSplitViewToFullScene(currContainerSession);
  }

  public maximizeSplitScene(persistentId?: number, currContainerSession?: SCBSceneContainerSession): void {
    if (!persistentId || !currContainerSession) {
      homeLog.showWarn(`maximizeSplitScene with illegal persistentId:${persistentId} ` +
        `currContainerSession:${currContainerSession}`);
      return;
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.RECOVER_SPLIT_VIEW, StyleConstants.DEFAULT_1);
    winLog.showInfo(`[SCBSplit] maximizeSplitScene with persistentId:${persistentId}` +
      ` isSplit ${currContainerSession.isSplit}`);
    if (currContainerSession.isSplit) {
      // maximize current split container
      if (currContainerSession.primarySession && currContainerSession.secondarySession &&
        currContainerSession.splitParam.getLifeCycle() !== SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP) {
        currContainerSession.isSplit = false;
        let screenW = px2vp(this.screenProperty.width);
        let screenH = px2vp(this.screenProperty.height);
        // determine which session to be maximized and which to be exit
        let isMaximizePrimary: boolean = currContainerSession.primarySession.session.persistentId === persistentId;
        let exitPersistentId: number = isMaximizePrimary ? currContainerSession.secondarySession.session.persistentId :
        currContainerSession.primarySession.session.persistentId;
        this.transformSplitViewForFullScreen(persistentId, !isMaximizePrimary, 0, currContainerSession);
      } else if (currContainerSession.dividerParam.isDividerDragging) {
        // drag exit one step split to full
        winLog.showInfo(`[SCBSplit] drag exit one step split to full`);
        this.oneStepSplitToFullScene(persistentId, currContainerSession);
      } else {
        this.transformSplitViewForFullScreen(persistentId, false, 0, currContainerSession);
      }
    }
  }

  private backExitOneStepToFull(currContainerSession: SCBSceneContainerSession, persistentId: number) {
    let currentRotation = currContainerSession.currentRotation;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    let screenH = px2vp(this.screenProperty.height);
    let screenW = px2vp(this.screenProperty.width);
    this.transformSplitViewForFullScreen(persistentId, false, 0, currContainerSession);
    currContainerSession.primarySession?.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    currContainerSession.dividerParam.doHideAnimation = true;
    currContainerSession.isSplit = false;
    let trans = currContainerSession.dividerParam.calOneStepDefaultTrans(currContainerSession.screenProperty);
    currContainerSession.dividerParam.setOneStepDefaultTranslate(trans);
    SCBSceneSessionManager.getInstance().requestFocus(persistentId, false, FocusChangeReason.SPLIT_SCREEN);
    currContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
    let targetRotation = this.getContainerSessionRotation(currContainerSession, screenSession, false);
    if (targetRotation !== currentRotation) {
      animateToImmediately({ curve: Curve.Ease }, () => {
        currContainerSession.dividerParam.primary.blurScale = 1;
        currContainerSession.dividerParam.dividerOpacity = 0;
      })
    }
    currContainerSession.primarySession?.updateCurRectForMultiWindowToFull(this.screenProperty);
    this.startSceneWithRotationIfNeed(currContainerSession);
    this.stateCollectionHandler?.getViewParam().initAll();
    this.showStatusBar(true);
    // back exit one step split to full open desktop edit
    this.editModeViewEvent.editSwitchEnable = true;
    this.updateScenePanelState(ScenePanelState.FULLSCENE);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    this.updateNaviBarPropForMaxSplit(currContainerSession);
    homeLog.showInfo(`oneSplitToFull, currentRotation ${currentRotation} targetRotation ${targetRotation}`);
    if (SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ONE_STEP_EXIT_APP_BLUR_EFFECT_DISABLE)) {
      currContainerSession.dividerParam.primary.useBlurStandIn = true;
    }
  }

  public backExitOneStepToFullCallback(currContainerSession: SCBSceneContainerSession, persistentId: number): void {
    this.backExitOneStepToFull(currContainerSession, persistentId);
  }

  public oneStepSplitToFullScene(persistentId: number, curContainerSession: SCBSceneContainerSession,
    needRotation: boolean = true): void {
    curContainerSession.primarySession?.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    curContainerSession.primarySession?.updateCurRectForMultiWindowToFull(this.screenProperty);
    curContainerSession.initAll();
    curContainerSession.dividerParam.setBorderRadius(true);
    curContainerSession.isSplit = false;
    curContainerSession.splitParam.setLifeCycle(SplitLifeCycle.UNDEFINED);
    curContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
    SCBSceneSessionManager.getInstance().requestFocus(persistentId, false, FocusChangeReason.SPLIT_SCREEN);
    if (needRotation) {
      this.startSceneWithRotationIfNeed(curContainerSession);
    }
    // drag exit one step split to full open desktop edit
    this.editModeViewEvent.editSwitchEnable = true;
    this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE);
    curContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG,
      'oneStepSplitToFullScene', curContainerSession.getName());
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    homeLog.showInfo(`updateNavigationBarProperty in oneStepSplitToFullScene`);
    SCBSceneSessionManager.getInstance()
      .updateNavigationBarProperty(curContainerSession.mainSession.systemBarProperty
        .get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable);
    ViewManagerPolicy.showView(ViewType.WALLPAPER);
  }

  private updateNaviBarPropForMaxSplit(currContainerSession: SCBSceneContainerSession) {
    homeLog.showInfo(`updateNavigationBarProperty in maximizeSplitScene`);
    SCBSceneSessionManager.getInstance()
      .updateNavigationBarProperty(currContainerSession.mainSession.systemBarProperty
        .get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable);
  }

  public resetWindowEffect(containerSession: SCBSceneContainerSession): void {
    if (containerSession.primarySession) {
      containerSession.primarySession.floatBorderRadius = 0;
      containerSession.primarySession.shadowConfig.radius = 0;
    }

    if (containerSession.secondarySession) {
      containerSession.secondarySession.floatBorderRadius = 0;
      containerSession.secondarySession.shadowConfig.radius = 0;
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Rotation
  // ----------------------------------------------------------------------------------------------------

  /**
   * 检查当前应用是否处于活动状态。
   * @param sceneInfo - 场景信息对象，包含了应用的详细信息。
   * @param isInRecent - 布尔值，指示应用是否在最近任务列表中。
   * @param isInSideBar - 布尔值，指示应用是否在侧边栏中。
   * @returns 如果应用处于活动状态，返回true；否则返回false。
   */
  public checkIfThisAppIsActive(sceneInfo: SCBSceneInfo, isInRecent: boolean, isInSideBar: boolean): boolean {
    if (isInRecent || isInSideBar) {
      return false;
    }
    let frontContainerSession = this.containerSessionList.getTopActiveSession();
    let floatingSession = this.getFloatSceneSessionByPersistentId(sceneInfo.persistentId);
    return false;
  }

  public onStartSceneFromIcon = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    sceneInfo.startMode = SCBSceneSessionManager.getInstance().getApplicationInfo(sceneInfo.bundleName)?.startMode;
    homeLog.showWarn('[SCBMain][id:%{public}d][sceneInfo:%{public}s/%{public}s/%{public}s/%{public}d]' +
      '[screenId:%{public}d]onStartSceneFromIcon, scenePanelState %{public}d, startMode %{public}d', sceneInfo.persistentId,
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.appIndex, sceneInfo.screenId,
      this.stateCollectionHandler?.getPanelState(), sceneInfo.startMode);
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(sceneInfo, StartInterceptions.FROM_ICON, this.screenId, this.panelId)) {
      return;
    }
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      homeLog.showWarn('[SCBMain]onStartSceneFromIcon return! isScreenLocked.');
      return;
    }
    let sceneSession: SCBSceneSession | null = null;
    if (sceneInfo.launchType === bundleManager.LaunchType.SINGLETON && sceneInfo.startMode === StartMode.RECENT_TASK) {
      homeLog.showWarn('[SCBMain]onStartSceneFromIcon in startMode recentTask.');
      sceneSession = this.findRecentUsedSceneSession(this.getAllSceneSessionInOneApp(sceneInfo),
        sceneInfo.abilityName);
      homeLog.showWarn(`[SCBMain]onStartSceneFromIcon find recentTask in ${sceneInfo.bundleName}: ` +
        `${sceneSession?.getName()}.`);
      if (sceneSession === null) {
        homeLog.showWarn(`[SCBMain]onStartSceneFromIcon not find recentTask, bundleName:${sceneInfo.bundleName}.`);
        sceneSession = this.requestSceneSession(sceneInfo);
      } else{
        sceneSession.sceneInfo.requestId = sceneInfo.requestId;
      }
      //TODO 0416胡毕杰提供的求助解决方案
    }else if (sceneInfo.launchType === bundleManager.LaunchType.MULTITON) {
      sceneSession = this.requestNewSceneSession(sceneInfo);
    } else {
      sceneSession = this.requestSceneSession(sceneInfo);
    }
    if (sceneSession == null) {
      homeLog.showError('[SCBMain]onStartSceneFromIcon Failed to request scene session!');
      return;
    }

    // 悬浮窗单独处理
    // 如果已经存在同样的悬浮窗，不允许再次开启新的
    let floatingSession = this.floatingSessionList.findByPersistentId(sceneSession.session.persistentId);
    if (floatingSession !== null) {
      return;
    }
    // 处理启动悬浮窗
    if (sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      floatingSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      sceneSession.sceneInfo.isUnclearableInRecent = true;
      if(floatingSession === null){
        floatingSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
        floatingSession.initAll();
      } else {
        SCBScenePanelManager.getInstance(this.screenProperty).removeSceneContainerSession(floatingSession);
      }
      floatingSession.isFloat = true;
      SCBScenePanelManager.getInstance(this.screenProperty).addFloatContainerSession(floatingSession);
      SCBFloatManager.getInstance().startFloatWithAnimator(floatingSession);
      return;
    }

    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    SCBPiPManager.getInstance().resetContainerWithPipStartSceneIfNeed(sceneContainerSession);
    if ((sceneContainerSession?.floatingParam.isFloatingSceneClosed() &&
      (this.stateCollectionHandler?.getPanelState() === ScenePanelState.HOME ||
        this.stateCollectionHandler?.getPanelState() === ScenePanelState.SPLIT))) {
      homeLog.showInfo('[SCBMain] onStartSceneFromIcon start closed floating scene');
    }
    // temporary forbiding start mid scene app from dock
    let panelState = this.stateCollectionHandler?.getPanelState() ?? ScenePanelState.HOME;
    if (!this.startAndExitEffectMgr.isStartExitBlurDisable()) {
      // blurcomponent is disabled in HOME state, enable it when starting from icon
      this.panelMgr.enableBlurComponent('onStartSceneFromIcon');
    }
    this.stateCollectionHandler?.getViewParam().initAll();
    let startFullScreenFromAppDock =
      (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE);
    if (startFullScreenFromAppDock && sceneSession.isActive) {
      homeLog.showWarn('[SCBMain]start full screen from app dock return because active!');
      return;
    }

    sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession && topContainerSession.isSplitPrimaryMode() && topContainerSession?.containerId !== sceneContainerSession?.containerId) {
      homeLog.showInfo('onStartSceneFromIcon with windowMode secondary');
      this.pairSplit(sceneSession, sceneInfo);
      return;
    }

    if (sceneInfo.windowMode == SCBSceneMode.PRIMARY) {
      homeLog.showInfo('onStartSceneFromIcon with windowMode primary');
      this.startSplitFromIcon(sceneSession, sceneInfo);
      return;
    }

    SCBSceneWindowAiSplitSwitchUtils.getInstance().aiSplitSwitchBySceneSession(sceneSession?.sceneInfo.windowMode,
      sceneSession?.sceneInfo, sceneSession?.isSupportSplitMode());

    // if (sceneContainerSession && !this.isSceneContainerSessionNotShowRecent(sceneContainerSession)) {
    //   homeLog.showWarn('[SCBMain]onStartSceneFromIcon interrupt to enterFloat');
    //   return;
    // }

    homeLog.showWarn(`onStartSceneFromIcon isNewWant ${sceneSession.isNewWant} scenePanelState ` +
      `${this.stateCollectionHandler?.getPanelState()}` +
      ` startFullScreenFromAppDock ${startFullScreenFromAppDock}`);
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.HOME || startFullScreenFromAppDock) {
      HiSysEventUtil.reportStartApp(sceneInfo.bundleName);
      AnimateToScheduleUtils.reportStartAppToRss(sceneInfo.bundleName);
      if (startFullScreenFromAppDock) {
        this.containerSessionList.getTopActiveSession()?.requestBackground();
      }
      TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP);
      homeLog.showInfo(`${TraceUtil.CORE_METHOD_START_APP}:${sceneInfo.bundleName}`);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
      let adapterSceneInfo: SCBSceneInfo = SceneInfoAdapterUtil.getAdapterSceneInfo(sceneInfo.bundleName,
        sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.appIndex);
      let transitionController = SCBTransitionManager.getInstance()
        .findTransitionController(adapterSceneInfo.bundleName, () => {
          return PageDesktopModel.getInstance()
            .getCloseAppData(adapterSceneInfo.bundleName, adapterSceneInfo.abilityName,
              undefined, undefined, undefined, adapterSceneInfo.appIndex);
        })
      if (sceneContainerSession == null) {
        homeLog.showInfo('onStartSceneFromIcon failed to get container from list and new one');
        sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
      }
      if (SCBPhoneSceneUtils.isSceneWithoutAnimation(sceneInfo)) {
        homeLog.showWarn('onStartSceneFromIcon start without animation');
        SCBSceneSessionManager.getInstance().requestSceneSessionActivation(
          sceneSession.session, true, undefined, sceneSession.sceneInfo?.requestId);
        this.panelMgr.addSceneContainerSession(sceneContainerSession);
        return;
      }
      if (GrayAppListManager.getInstance().isGrayAppIcon(sceneInfo)) {
        SCBSceneSessionManager.getInstance().requestSceneSessionActivation(
          sceneSession.session, true, undefined, sceneSession.sceneInfo?.requestId);
        this.panelMgr.addSceneContainerSession(sceneContainerSession);
        homeLog.showWarn('[SCBMain]onStartSceneFromIcon isGrayAppIcon return');
        return;
      }

      if (this.dataCollectionHandler?.getOneStepSplitExitFlag() &&
        sceneContainerSession.containerId === this.dataCollectionHandler?.getOneStepSplitContainerID()) {
        this.dataCollectionHandler?.setOneStepSplitExitFlag(false);
        this.dataCollectionHandler.setOneStepSplitContainerID(-1);
        sceneContainerSession.dividerParam.init();
      }
      sceneContainerSession.initCompanionIconInfo(adapterSceneInfo, transitionController);
      this.startSceneWithRotationIfNeed(sceneContainerSession);
      this.stateCollectionHandler?.updatePanelState(ScenePanelState.FULLSCENE);
      this.dataCollectionHandler?.setIsSupportMaximizeScene(false);
      this.stateCollectionHandler?.updateCompanionIconShowState(true);
      performanceMonitor.begin(PageDesktopModel.getInstance().getSceneLaunchType(
        sceneContainerSession.companionIconInfo), performanceMonitor.ActionType.LAST_UP, sceneInfo.bundleName);
      homeLog.showWarn('[SCBMain]onStartSceneFromIcon raise priority: start app start');
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
      this.panelAnimator.sceneContainerTransitionIn(sceneContainerSession, transitionController, sceneSession);
    } else {
      let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      if (sceneContainerSession === null) {
        sceneSession.requestSessionDestruction(true);
      }
      homeLog.showWarn(`[SCBMain]onStartSceneFromIcon do nothing as scenePanelState: ${this.stateCollectionHandler?.getPanelState()}`);
      let topActiveSession = this.containerSessionList.getTopActiveSession();
      if (topActiveSession?.primarySession && !topActiveSession.primarySession.isAvailable) {
        homeLog.showWarn(`[SCBMain]onStartSceneFromIcon exception due to session, ` +
          `persistentId:${topActiveSession.primarySession.sceneInfo.persistentId}} active error.`);
      }
    }
    this.sendBadgeEvent(sceneInfo, true);
    QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene from icon');
    homeLog.showWarn('onStartSceneFromIcon create session finish');
  }

  public onActivateScene = (persistentId?: number, containerId?: number): void => {
    homeLog.showInfo(`[SCBMain] onActivateScene with persistentId:${persistentId} containerId:${containerId} ` +
      `scenePanelState:${this.stateCollectionHandler?.getPanelState()}`);
    let containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      homeLog.showInfo(`[SCBMain] onActivateScene failed as not find containerSession, persistentId:${persistentId} ` +
        `containerId:${containerId}`);
      return;
    }
    let curActiveContainerSession = this.containerSessionList.getTopActiveSession(); // just for full session
    if (curActiveContainerSession &&
    this.needMinimizeActiveContainer(containerSession, curActiveContainerSession)) {
      curActiveContainerSession.requestBackground();
    }
    containerSession.requestActivation();
    this.panelMgr.raiseSceneToTop(containerSession);
    curActiveContainerSession?.addTransitionCount();
    let animationCount = curActiveContainerSession?.getTransitionCount();
    animateTo({
      curve: curves.springMotion(),
      onFinish: () => {
        homeLog.showInfo(`[SCBMain] onActivateScene animateTo onFinish animationCount: ${animationCount} ` +
          `curActiveContainerSession.transitionAnimationCount: ${curActiveContainerSession?.getTransitionCount()}`);
        if (curActiveContainerSession && animationCount === curActiveContainerSession.getTransitionCount()) {
          if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
            curActiveContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(
              CommonConstants.DEFAULT_WINDOWS_RADIUS_0, TAG, 'onActivateScene', curActiveContainerSession.getName());
          }
          curActiveContainerSession.clearTransitionCount();
        }
      }
    }, () => {
      curActiveContainerSession?.init();
    })
    this.updateScenePanelState(ScenePanelState.FULLSCENE);
    this.showStatusBar(true);
  }

  public startAsQuickAccessMenuIfNeeded(sceneInfo: SCBSceneInfo, sceneContainerSession: SCBSceneContainerSession,
    transitionController: SCBTransitionController): boolean {
    if (sceneInfo.callerBundleName !== SCBConstants.QUICK_ACCESS_MENU_BUNDLE ||
      this.quickAccessMenuFuncType === SCBConstants.QUICK_ACCESS_FUNCTION_NOT_SUPPORT) {
      homeLog.showInfo('Not quickAccessMenu');
      return false;
    }
    let isXKey: boolean = this.quickAccessMenuFuncType === SCBConstants.QUICK_ACCESS_FUNCTION_X_KEY;
    let startType = sceneInfo.want.parameters?.startType as string;
    if (isXKey && startType === SCBConstants.START_BY_PANEL) {
      homeLog.showInfo('Xkey start app by panel');
      return false;
    }
    if (isXKey) {
      this.quickAccessMenuTopOffset = SCBConstants.QUICK_ACCESS_MENU_XKEY_TOP_OFFSET;
      this.quickAccessMenuHeight = SCBConstants.DEFAULT_QUICK_ACCESS_MENU_SIZE;
      this.quickAccessMenuWidth = SCBConstants.DEFAULT_QUICK_ACCESS_MENU_SIZE;
    }
    homeLog.showInfo('onStartSceneFromOther !isActive call startAsQuickAccessMenuIfNeeded');
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
    this.sceneContainerZoomInFromQuickAccessMenu(sceneContainerSession, transitionController, isXKey);
    return true;
  }

  public isFullSceneState(): boolean {
    return this.stateCollectionHandler?.getPanelState() == ScenePanelState.FULLSCENE;
  }

  public postStartSceneFromOtherEvent(bundleName: string, abilityName: string) {
    let event = StartSceneFromOtherEvent.getInstance(bundleName, abilityName);
    homeLog.showInfo(`postStartSceneFromOtherEvent: ${bundleName} + ${abilityName}`);
    EvtBus.post(StartSceneFromOtherEvent, event);
  }

  private processStartFromVirtualIfNeed(activeContainer: SCBSceneContainerSession, sceneSession: SCBSceneSession,
    sceneInfo: SCBSceneInfo, opts?: SCBTransferSceneOpts): boolean {
    let isStartFromVirtual: boolean = false;
    if (!isStartFromVirtual && !opts) {
      winLog.showInfo('[SCBSplit] start from non-onAPP');
      return false;
    }
    if (isStartFromVirtual) {
      // request background if in one-step split
      if (activeContainer.isOneStepSplit()) {
        activeContainer.requestBackground();
        return false;
        // replace split scene when start in on-app
      } else if (activeContainer.dividerParam.isUpDownSplit()) {
        return false;
      }
    }
    return false;
  }

  // From console, full to free, free to full
  public onStartSceneFromOther = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo, opts?: SCBTransferSceneOpts): CommonResult => {
    homeLog.showWarn('[SCBMain][id:%{public}d][sceneInfo:%{public}s/%{public}s/%{public}s/%{public}d]' +
      '[screenId:%{public}d]onStartSceneFromOther.', sceneInfo.persistentId, sceneInfo.bundleName,
      sceneInfo.moduleName, sceneInfo.abilityName,sceneInfo.appIndex, sceneInfo.screenId);
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(sceneInfo, StartInterceptions.FROM_OTHER, this.screenId, this.panelId)) {
      return CommonResult.FAIL;
    }
    recentViewModel.onStartSceneFromOther();
    const enableBlurComponent: boolean = !DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()
      && !this.startAndExitEffectMgr.isPowerSaveMode()
      && !this.startAndExitEffectMgr.isStartExitBlurDisable();
    // show the wallpaper in case of after rotation
    if (enableBlurComponent) {
      this.showWallpaperAfterRotate();
    }
    // 点击启动卡片、点击启动快捷图标和快捷菜单，也会调用onStartSceneFromOther
    let isStartShortcut: boolean = CloseAppManager.getInstance().getAndResetIsStartShortcut();
    if (isStartShortcut || sceneInfo.isFromIcon) {
      homeLog.showInfo(`Start from icon isStartShortcut: ${isStartShortcut} isFromIcon: ${sceneInfo.isFromIcon}`);
      sceneInfo.isFromIcon = false;
      this.onStartSceneFromIcon(sceneInfo, fromInfo);
      return CommonResult.SUCCESS;
    }

    let isStartCard = this.checkIsStartFromCard(sceneInfo);
    // 卡片被健康使用管控，点击卡片会启动parentcontrol，避免原地一镜到底
    if (GrayAppListManager.getInstance().isStartParentControl(sceneInfo.bundleName)) {
      isStartCard = false;
    }

    const callerPersistentId = sceneInfo.callerPersistentId;
    let sceneSession = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      homeLog.showError('[SCBMain]onStartSceneFromOther Failed to request scene session!');
      return CommonResult.FAIL;
    }
    if (sceneSession?.isPcAppInPad && this.isRecentState() && sceneSession.isNewWant) {
      homeLog.showError('[SCBMain]onStartSceneFromOther,recent clear all  animate not finish!');
      return CommonResult.FAIL;
    }

    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.RECENT) {
      // 跟手状态下取消跟手
      homeLog.showInfo(`startOther ${this.panelFsm.isFollowingState()}`);
      if (this.panelFsm.isFollowingState()) {
        localEventManager.sendLocalEvent(EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL);
      } else {
        SCBSceneSessionManager.getInstance()?.exitRecent(this.screenProperty.screenId);
      }
    }

    let callerSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null =
      SCBSceneSessionManager.getInstance().getSessionById(callerPersistentId);
    if (callerSession instanceof SCBSpecificSession) {
      let fromSession = callerSession.getParentSession();
      let fromFloatContainer =
        this.floatingSessionList.findByPersistentId(fromSession?.session.persistentId);
      if (fromSession && fromFloatContainer) {
        let startResult: CommonResult = this.onSceneStartTransition(sceneInfo, fromSession.sceneInfo, false);
        this.updateCallerSessionIdAndToSessionId(sceneSession, fromSession.session.persistentId);
        return startResult;
      }
    }

    // skip onNewWant if start scene from pip
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP) {
      sceneSession.sessionData.isNewWant = false;
    }
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session?.persistentId);
    SCBPiPManager.getInstance().resetContainerWithPipStartSceneIfNeed(sceneContainerSession);
    this.postStartSceneFromOtherEvent(sceneInfo.bundleName, sceneInfo.abilityName);
    let notShowSession = this.containerSessionList.getTopSession();

    let activeSceneContainerSession = this.containerSessionList.getTopActiveSession();
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    winLog.showInfo(`GuidanceLog set unNeedKnowMore`);
    // process in split when start from virtual screen
    if (activeSceneContainerSession && this.processStartFromVirtualIfNeed(activeSceneContainerSession, sceneSession, sceneInfo, opts)) {
      winLog.showInfo('[SCBSplit]onStartSceneFromOther process start from virtual screen in multi-window');
      this.startSceneWithRotationIfNeed(activeSceneContainerSession);
      return CommonResult.SUCCESS;
    }
    if (activeSceneContainerSession && this.isFullSceneState()) {
      let callerId: number = sceneInfo.callerPersistentId ?? 0;
      let callerSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null =
        activeSceneContainerSession.findSceneSessionByPersistentId(callerId) ??
        SCBSceneSessionManager.getInstance().getSessionById(sceneInfo.callerPersistentId);
      if (opts) {
        winLog.showInfo('[SCBSplit] interrupt pairSplit');
        sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      }
      if (this.pairSplitIfInOneApp(activeSceneContainerSession, callerSession, sceneSession,
        sceneInfo)) {
        winLog.showInfo('[SCBSplit] interruptStartSceneForSplitWindowMode pairSplitIfInOneApp return');
        if (SCBSceneUtils.isStartFromVirtual(activeSceneContainerSession.primarySession,
          activeSceneContainerSession.secondarySession)) {
          this.startSceneWithRotationIfNeed(activeSceneContainerSession);
        }
        return CommonResult.SUCCESS;
      }
    }
    if (sceneContainerSession?.floatingParam.isFloatingSceneClosed()) {
      homeLog.showInfo('[SCBMain]onStartSceneFromOther called onRemoveFloatingScene');
      this.panelMgr.addSceneContainerSession(sceneContainerSession);
    }
    let animationFinishedCallback = this.dataCollectionHandler?.getAnimationFinishedCallback();
    // 应用已经在悬浮窗打开. 但是用户还是分屏打开该应用的指令.
    let callFromVoiceAndHasOpenFloat = sceneInfo.callerBundleName === VassistantConstants.VASSISTANT_BUNDLE_NAME && (
      sceneInfo.callerAbilityName === 'SplitScreenServiceExtAbility' || sceneInfo.callerAbilityName ===
      VassistantConstants.VASSISTANT_ABILITY_FOR_LABEL) && sceneContainerSession &&
    sceneContainerSession.isFloat && sceneContainerSession.isActive;
    // if (!sceneContainerSession?.isMidScene && animationFinishedCallback) {
    //   homeLog.showInfo('[SCBMain]onStartSceneFromOther called startSceneFromOtherToFloatIfNeed');
    //   return CommonResult.SUCCESS;
    // }
    let transitionController = SCBTransitionManager.getInstance()
      .findTransitionController(sceneInfo.bundleName, () => {
        return PageDesktopModel.getInstance().getCloseAppData(sceneInfo.bundleName, sceneInfo.abilityName,
          isStartCard ? StartType.CARD : StartType.APP, undefined, undefined, sceneInfo.appIndex);
      });

    if (sceneSession.isShowAboveKeyguard) {
      if (sceneSession.isActive) {
        homeLog.showInfo('[SCBMain]onStartSceneFromOther, above keyguard sceneSession is active!');
        sceneSession.requestSessionActivation(sceneSession.isNewWant);
        return CommonResult.SUCCESS;
      }
      homeLog.showInfo('[SCBMain]onStartSceneFromOther, should start above keyguard session');
      return SCBSceneSessionManager.getInstance().startSceneFromOtherAboveKeyguard(sceneInfo);
    }

    HiSysEventUtil.reportStartApp(sceneInfo.bundleName);
    AnimateToScheduleUtils.reportStartAppToRss(sceneInfo.bundleName);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP);
    homeLog.showWarn(`[SCBMain]onStartSceneFromOther isNewWant ${sceneSession.isNewWant}. ` +
      `${TraceUtil.CORE_METHOD_START_APP}:${sceneInfo.bundleName}`);
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
    // if containerSession is in split, we should exit split and start with full screen
    if (sceneContainerSession && sceneContainerSession.containerId !== activeSceneContainerSession?.containerId &&
    sceneContainerSession.isSplit &&
    sceneContainerSession.primarySession && sceneContainerSession.secondarySession) {
      homeLog.showInfo('onStartSceneFromOther sceneContainerSession is in split exit split');
      // here need update sceneContainerSession, because when exit split in recent, it has changed
      sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      ViewManagerPolicy.hideView(ViewType.DESKTOP);
      ViewManagerPolicy.hideView(ViewType.WALLPAPER);
    }

    if (sceneContainerSession === null) {
      sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
      this.panelMgr.addSceneContainerSession(sceneContainerSession);
      homeLog.showInfo(`[SCBMain]onStartSceneFromOther add new session: ${sceneContainerSession.containerId}`);
    }
    if (this.dataCollectionHandler?.getOneStepSplitExitFlag() &&
      sceneContainerSession.containerId === this.dataCollectionHandler?.getOneStepSplitContainerID()) {
      this.dataCollectionHandler?.setOneStepSplitExitFlag(false);
      this.dataCollectionHandler?.setOneStepSplitContainerID(-1);
      sceneContainerSession.dividerParam.init();
    }
    this.startSceneWithRotationIfNeed(sceneContainerSession);
    let isActive = sceneContainerSession.isActive;
    let needBlurAnimation: boolean = true;
    if (isStartCard) {
      needBlurAnimation = false;
      this.stateCollectionHandler?.updateCompanionIconShowState(true);
    }
    let intelligentSearchFlag: boolean = false;
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP) {
      needBlurAnimation = false;
    }
    homeLog.showWarn(`[SCBMain]onStartSceneFromOther ${sceneContainerSession.getName()} isActive:${isActive} ` +
      `isStartCard:${isStartCard} needBlurAnimation:${needBlurAnimation} ` +
      `scenePanelState:${this.stateCollectionHandler?.getPanelState()}`);

    if (notShowSession?.containerId !== sceneContainerSession.containerId) {
      recentLog.info(`[SCBMain]onStartSceneFromOther ${notShowSession?.getName()} notShowSessionDestroy`);
      this.recentNotShow.notShowSessionDestroy(notShowSession,
        this.totalContainerSessionList);
    }
    const isPhoneCallRelatedScene = SCBPhoneSceneUtils.isPhoneCallScene(sceneInfo);
    if (SCBPhoneSceneUtils.isSceneWithoutAnimation(sceneInfo)) {
      homeLog.showWarn('[SCBMain] onStartSceneFromOther start without animation');
      sceneContainerSession.requestActivation(sceneSession.isNewWant);
      sceneSession.sessionData.isNewWant = true;
      return CommonResult.SUCCESS;
    }

    const isCallUIRelatedScene = SCBPhoneSceneUtils.isCallUIScene(sceneInfo);
    // whether minimize/show former scene && update scenePanelState
    if (activeSceneContainerSession &&
    this.needMinimizeActiveContainer(sceneContainerSession, activeSceneContainerSession)) {
      homeLog.showInfo(`onStartSceneFromOther need minimize active container`);
      let activeSession = activeSceneContainerSession.primarySession;
      if (activeSession !== null && activeSession.session !== null) {
        // set caller persistentId to top active id, when press back key will jump to this top id not desktop.
        this.updateCallerSessionIdAndToSessionId(sceneSession, activeSession.session.persistentId);
      }
      if (isPhoneCallRelatedScene && activeSceneContainerSession !== null) {
        homeLog.showInfo(`onStartSceneFromOther sceneInfo is phone call scene`);
        // for phone call, show the former scene during transition
        activeSceneContainerSession.isDisappearing = true;
        this.panelMgr.raiseSceneToTop(sceneContainerSession);
        if (!isStartCard || (isStartCard && !this.searchInScreen() || isPhoneCallRelatedScene)) {
          sceneContainerSession.requestActivation(sceneSession.isNewWant);
          sceneSession.sessionData.isNewWant = true;
        }
        activeSceneContainerSession.requestBackground();
        this.sceneContainerTransitionForPhoneCall(activeSceneContainerSession, sceneContainerSession, false, false);
        return CommonResult.SUCCESS;
      } else {
        this.panelMgr.raiseSceneToTop(sceneContainerSession);
        if (!isStartCard || (isStartCard && !this.searchInScreen()) || isPhoneCallRelatedScene) {
          sceneContainerSession.requestActivation(sceneSession.isNewWant);
          sceneSession.sessionData.isNewWant = true;
        }
        activeSceneContainerSession?.requestBackground();
        this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE, needBlurAnimation);
      }
    } else {
      // don't need minimize former scene
      homeLog.showWarn(`[SCBMain]onStartSceneFromOther do not need minimize former scene, activeContainer is null? ` +
        `${activeSceneContainerSession === null}`);
      this.panelMgr.raiseSceneToTop(sceneContainerSession);
      if (!isStartCard || (isStartCard && !this.searchInScreen()) || isPhoneCallRelatedScene) {
        sceneContainerSession.requestActivation(sceneSession.isNewWant);
        sceneSession.sessionData.isNewWant = true;
      }
      // CallUI related scene without former scene should run fade-in animation and does not need blur animation
      needBlurAnimation = isCallUIRelatedScene ? false : needBlurAnimation;
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE, needBlurAnimation);
      if (!sceneSession.isAvailable) {
        homeLog.showError(`onStartSceneFromOther requestSessionActivation exception.`);
      }
    }

    if (sceneSession.isInSplit() && sceneSession.isActive) {
      homeLog.showWarn('[SCBMain]onStartSceneFromOther, sceneSession isInSplit & isActive');
      return CommonResult.SUCCESS;
    }
    // 存在overlay卡片，则优先overlay动效
    if (OverlayStartAnimHelper.checkStartOverlayTransitionIn({
      containerSession: sceneContainerSession,
      transitionController: transitionController,
      scenePanelManager: this.panelMgr,
      scenePanelSession: this.stateCollectionHandler?.getPanelSession(),
      sceneSession: sceneSession,
      triggerType: OverlayStartAnimHelper.TRIGGER_TYPE_TRANSITION_IN,
      isActive: isActive
    })) {
      homeLog.showInfo(`[SCBMain]onStartSceneFromOther overlay: ` +
        `${transitionController?.overlayCardInfo?.startBundleName}`);
      //overlay卡片动效，调整动画效果；当前还原应用窗口缩放动效nsition(transitionController);
      return CommonResult.SUCCESS;
    }
    // CallUI related scene without former scene needs to run fadeIn animation
    if (isCallUIRelatedScene) {
      homeLog.showInfo(`[SCBMain] onStartSceneFromOther without callerSession, sceneInfo is call ui scene`);
      this.startFadeInAnimationForCallUI(sceneContainerSession);
      return CommonResult.SUCCESS;
    }

    // skip anim when restore from pip
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP &&
      SCBPiPManager.getInstance().hasPipSpecificSession()) {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
      homeLog.showInfo(`[SCBMain]onStartSceneFromOther skip anim when start from pip`);
      if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE) {
        sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
          TAG, 'onStartSceneFromOther', sceneContainerSession.getName());
      }
      if (SCBSceneSessionManager.getInstance().isRestoreFromBgPiP) {
        homeLog.showInfo(`[SCBMain]onStartSceneFromOther isRestoreFromBgPiP`);
        PipOneShotAnimHelper.startOneShotTransitionIn(sceneContainerSession, this.panelMgr);
      }
      return CommonResult.SUCCESS;
    } else {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    }

    // 语音助手半屏到全屏启动 屏蔽动效
    if (this.isVassistantScene(sceneInfo) || this.isScreenShotScene(sceneInfo)) {
      sceneContainerSession?.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'startVassistantScene');
      QuickSwitchRaiseTopAlarm.getInstance().cancel('startVassistantScene');
      return CommonResult.SUCCESS;
    }

    // 桌面卡片动效
    if (isStartCard && this.searchInScreen()) {
      if (isActive) {
        if (sceneSession) {
          sceneContainerSession.requestActivation(sceneSession.isNewWant);
          sceneSession.sessionData.isNewWant = true;
        }
      } else {
        performanceMonitor.begin('START_APP_ANI_FORM', performanceMonitor.ActionType.LAST_UP, sceneInfo.bundleName);
        homeLog.showWarn('[SCBMain]onStartSceneFromOther raiseAnimateToSchedulePriority: start app from card start');
        AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
        sceneContainerSession.initCompanionIconInfo(sceneInfo, transitionController);
        this.panelAnimator.sceneContainerTransitionIn(sceneContainerSession, transitionController, sceneSession);
      }
    } else {
      if (!isActive) {
        if (!this.startAsQuickAccessMenuIfNeeded(sceneInfo, sceneContainerSession,
          transitionController)) {
          homeLog.showWarn('[SCBMain]onStartSceneFromOther !isActive call sceneContainerZoomIn');
          sceneContainerSession?.primarySession?.updateSystemStartAnimationBySceneInfo(sceneInfo);
          this.panelAnimator.sceneContainerStartOther(sceneContainerSession, transitionController);
        }
      } else {
        if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE) {
          sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
            TAG, 'onStartSceneFromOther', sceneContainerSession.getName());
        }
      }
    }
    this.sendBadgeEvent(sceneInfo, true)
    QuickSwitchRaiseTopAlarm.getInstance().cancel('start scene from other');
    return CommonResult.SUCCESS;
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Animation
  // ----------------------------------------------------------------------------------------------------

  public isSceneWithoutAnimation(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }
    return WITHOUT_ANIMATION_LIST.includes(sceneInfo.bundleName);
  }

  private checkIsStartFromCard(sceneInfo: SCBSceneInfo) : boolean {
    let cardId = sceneInfo?.want?.parameters?.[FormConstants.ID_PARAM] as string;
    if (cardId) {
      homeLog.showWarn(`onStartSceneFromOther from idParam cardId = ${cardId}`);

      // 语音助手建议里面展示的部分卡片使用message的方式跳转，接收不到卡片框架的onRouter方法回调，因此无法设置跳转启动的参数，页面退出的时，
      // 无法落位到卡片，为解决这个问题，在点击卡片的时候，将卡片ID传给AMS，AMS传给WMS，WMS传给桌面，最后桌面设置跳转启动的参数
      // 从而解决卡片落位动效不正确的问题。
      CloseAppManager.getInstance().setStartAppType(StartType.CARD, cardId, undefined, undefined, sceneInfo.bundleName);
    }

    let isStartCard : boolean = CloseAppManager.getInstance().getAndResetIsStartCard();
    if (isStartCard) {
      homeLog.showInfo(`onStartSceneFromOther from CloseAppManager isStartCard = true`);
      return true;
    }
    cardId = String(sceneInfo?.want?.parameters?.[FormConstants.FORM_ID] ?? '');
    if (!CheckEmptyUtils.checkStrIsEmpty(cardId)) {
      CloseAppManager.getInstance().setStartAppType(StartType.CARD, cardId, undefined, undefined, sceneInfo.bundleName);
    }
    isStartCard = CloseAppManager.getInstance().getAndResetIsStartCard();
    homeLog.showWarn(`onStartSceneFromOther get CardId from formID cardId = ${cardId} isStartCard=${isStartCard}`);
    return isStartCard;
  }


  public sceneContainerZoomInFromQuickAccessMenu(sceneContainerSession: SCBSceneContainerSession,
    transitionController: SCBTransitionController, isXKey: boolean): void {
    sceneContainerSession.init();
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.6, TAG, 'sceneContainerZoomInFromQuickAccessMenu',
      sceneContainerSession.getName());
    this.startSceneWithRotationIfNeed(sceneContainerSession);
    if (this.needInitQuickAccessMenuConfig) {
      try {
        let path: string = configPolicy.getOneCfgFileSync(SCBConstants.QUICK_ACCESS_MENU_CONFIG_FILE_PATH);
        if (FileUtils.isExist(path) && !CheckEmptyUtils.checkStrIsEmpty(FileUtils.readTextSync(path))) {
          homeLog.showInfo(`read config file`);
          let content: string = FileUtils.readTextSync(path);
          let contentJson: Record<string, Object> = JSON.parse(content);
          let fingerKeyHeight: number = contentJson.fingerKeyHeight as number;
          let displayHeight: number = contentJson.displayHeight as number;
          let fingerKeyCenterToDisplayTopHeight: number = contentJson.fingerKeyCenterToDisplayTopHeight as number;
          let height: number = Math.max(this.screenProperty.height, this.screenProperty.width);
          if (displayHeight !== 0) {
            this.quickAccessMenuHeight = px2vp(fingerKeyHeight * height / displayHeight);
            this.quickAccessMenuTopOffset = px2vp(fingerKeyCenterToDisplayTopHeight * height / displayHeight);
            this.needInitQuickAccessMenuConfig = false;
          }
        }
      } catch (err) {
        homeLog.showInfo(`get config from CCM config fail. ${err?.message}`);
      }
    }

    sceneContainerSession.startOtherForQuickAccessMenu(this.quickAccessMenuHeight, this.quickAccessMenuWidth,
      this.quickAccessMenuTopOffset, isXKey);
    SCBTransitionManager.getInstance().notifySceneTransitionIn(transitionController, true);
    sceneContainerSession.addTransitionCount();
    this.panelMgr.addSceneContainerSession(sceneContainerSession);
    this.panelMgr.raiseSceneToTop(sceneContainerSession);
    let animationNum = sceneContainerSession.getTransitionCount();
    // animateTo({
    //   duration: 500,
    //   curve: Curve.Friction,
    //   onFinish: () => {
    sceneContainerSession.onTransitionInactive();
    this.panelMgr.onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerZoomInFromQuickAccessMenu');
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG,
      'sceneContainerZoomInFromQuickAccessMenu', sceneContainerSession.getName());
    sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0, TAG,
      'sceneContainerZoomInFromQuickAccessMenu', sceneContainerSession.getName());
    if (animationNum == sceneContainerSession.getTransitionCount()) {
      homeLog.showInfo('animationNum: ' + sceneContainerSession.getTransitionCount() + 'needRenderScale:' +
        sceneContainerSession?.needRenderScale.scaleX);
      if (CommonUtils.equals(sceneContainerSession?.needRenderScale.scaleX, 1.0)) {
        sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(
          CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
          TAG, 'sceneContainerZoomInFromQuickAccessMenu', sceneContainerSession.getName());
      }
      sceneContainerSession.clearTransitionCount();
      AnimateToScheduleUtils.raiseAppStartToCPUPriority(1);
    }
    //   },
    // }, () => {
    //   sceneContainerSession.onTransitionInactive();
    //   this.panelMgr.onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerZoomInFromQuickAccessMenu');
    //   sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG,
    //     'sceneContainerZoomInFromQuickAccessMenu', sceneContainerSession.getName());
    //   sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0, TAG,
    //     'sceneContainerZoomInFromQuickAccessMenu', sceneContainerSession.getName());
    // })
  }

  public isVassistantScene(sceneInfo: SCBSceneInfo): boolean {
    const vassistantBundleName = 'com.ohos.vassistant';
    const vassistantAbilityName = 'WakeupServiceExtAbility';
    const targetAbilityName = 'VoiceAbility';
    return sceneInfo.bundleName === vassistantBundleName && sceneInfo.callerAbilityName === vassistantAbilityName &&
      sceneInfo.abilityName === targetAbilityName;
  }

  public isScreenShotScene(sceneInfo: SCBSceneInfo): boolean {
    const screenshotBundleName = 'com.ohos.screenshot';
    const screenshotAbilityName = 'com.ohos.screenshot.ServiceExtAbility';
    const targetAbilityName = 'ScreenUIAbility';
    return sceneInfo?.bundleName === screenshotBundleName && sceneInfo?.callerAbilityName === screenshotAbilityName &&
      sceneInfo?.abilityName === targetAbilityName;
  }

  public checkStartOverlayTransition(controller: SCBTransitionController): void {
    if (controller?.overlayCardInfo) {
      let cardInfo = controller.overlayCardInfo as OverlayCardInfo;
      if (cardInfo?.animScene === OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN) {
        this.stateCollectionHandler?.updateUnLockScale(UnLockConstants.MIN_SCENE_SCALE);
      }
    }
  }

  public searchInScreen(): boolean {
    // 桌面场景都是true，负一屏特殊场景为false
    let isInScreen = true;
    // 负一屏已打开的场景
    if (sOutSideWindowMgr.isShowNegative() && !sOutSideWindowMgr.getDesktopEnabled()) {
      let isUserAnimation = AppStorage.get<boolean>('isIntelligentCardUseAnimation') || false;
      homeLog.showInfo(`searchInScreen isIntelligentCardUseAnimation isUserAnimation = ${isUserAnimation}`);
      isInScreen = isUserAnimation;
    }
    return isInScreen;
  }

  public minimizeSplitScene(container: SCBSceneContainerSession, persistentId: number, needRemove: boolean = false,
    needBackground: boolean = true) {
    winLog.showInfo(`[SCBSplit] minimizeSplitScene, containerId: ${container.containerId},
    persistentId: ${persistentId}, needRemove: ${needRemove}, needBackground: ${needBackground}`);
    if (container.primarySession && container.secondarySession) {
      container.isSplit = false;
      let screenW = px2vp(this.screenProperty.width);
      let screenH = px2vp(this.screenProperty.height);
      // need show desktop and add blur when doing exitSplitView animation
      ViewManagerPolicy.showView(ViewType.DESKTOP);
      this.showWallpaperAfterRotate();
      // determine which session to be maximized and which to be exit
      let isMaximizePrimary: boolean = !(container.primarySession.session.persistentId === persistentId);
      let exitPersistentId: number = isMaximizePrimary ? container.secondarySession.session.persistentId :
        container.primarySession.session.persistentId;
      this.transformSplitViewForFullScreen(persistentId, !isMaximizePrimary, 0, container, false, needRemove, needBackground);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.RECOVER_SPLIT_VIEW, StyleConstants.DEFAULT_1);
    } else if (container.isOneStepSplit()) {
      this.oneStepSplitExit(container, container.splitParam.oneStepExitNeedAnimation);
    }
  }

  /**
   * One Step Split Top Exit
   */
  public oneStepSplitExit(containerSession: SCBSceneContainerSession | null, needAnim?: boolean): void {
    if (!containerSession) {
      winLog.showError(`OneStepSplitExit fail: containerSession is null`);
      return;
    }
    containerSession.splitParam.oneStepBreakFlag = false;
    containerSession.splitParam.setLifeCycle(SplitLifeCycle.EXIT_ONESTEP_TO_FUSCREEN);
    winLog.showInfo(`[SCBSplit] OneStepSplitExit to home id: ${containerSession.primarySession?.session.persistentId}`);
    if (needAnim) {
      this.dataCollectionHandler?.setOneStepSplitExitFlag(true);
      this.dataCollectionHandler?.setOneStepSplitContainerID(containerSession.containerId);
      animateTo({
        curve: curves.springMotion(0.4, 1),
        onFinish: () => {
          this.isVirtualInExitAnim = false;
          if (this.isVirtualNeedTerminate && this.terminateParams) {
            this.onTerminateScene(this.terminateParams.persistentId, this.terminateParams.containerId,
              this.terminateParams.needRemoveSession, this.terminateParams.needClearData,
              this.terminateParams.shouldBackToCaller, this.terminateParams.extraInfo);
            this.isVirtualNeedTerminate = false;
            this.terminateParams = undefined;
          }
          if (this.dataCollectionHandler?.getOneStepSplitExitFlag()) {
            containerSession.dividerParam.init();
            this.dataCollectionHandler?.setOneStepSplitExitFlag(false);
            this.dataCollectionHandler?.setOneStepSplitContainerID(-1);
            containerSession.splitParam.setLifeCycle(SplitLifeCycle.UNDEFINED);
          }
          containerSession.isDisappearing = false;
          recentLog.info(`oneStepSplitExit session ${containerSession.getName()} destory`);
          this.recentNotShow.notShowSessionDestroy(containerSession, this.totalContainerSessionList);
        }
      }, () => {
        containerSession.notifyForegroundInteractiveStatus(false);
        ViewManagerPolicy.showView(ViewType.WALLPAPER);
        this.oneStepSplitExitInner(containerSession);
        containerSession.requestBackground();
        containerSession.isDisappearing = true;
      })
    } else {
      this.oneStepSplitExitInner(containerSession);
      containerSession.initAll();
      containerSession.requestBackground();
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  private oneStepSplitExitInner(containerSession: SCBSceneContainerSession) {
    let dividerParam = containerSession.dividerParam;
    let totalLength = dividerParam.isUpDownSplit() ?
    px2vp(this.screenProperty.height) : px2vp(this.screenProperty.width);
    let moveOffset = dividerParam.primSizePct * totalLength + DividerStyleConstants.DIVIDER_HEIGHT
    dividerParam.setOneStepDefaultTranslate(-moveOffset);
    containerSession.isSplit = false;
    this.enterFullSceneOrHomeView(ScenePanelState.HOME, false);
    containerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
  }

  /**
   * exit split to one step, such as back gesture, scene terminate
   */
  public exitSplitViewToOneStep(persistentId: number, container: SCBSceneContainerSession, needRemove: boolean): void {
    if (!container.isSplitView()) {
      winLog.showInfo(`exitSplitViewToOneStep container[${container.getName()}] not split, skip`);
      return;
    }
    this.setSensorRotationUnable();
    let isPrimaryOneStep = !(persistentId === container.primarySession!.session.persistentId);
    winLog.showInfo(`[SCBSplit] exitSplitViewToOneStep isPrimaryOneStep: ${isPrimaryOneStep} exitId: ${persistentId}`);
    if (uiType === SCBConstants.UITYPE_PHONE) {
      const screenRotation: number = SCBScreenSessionManager.getInstance().getScreenRotation();
    }
    let exitScene: SCBSceneSession = isPrimaryOneStep ? container.secondarySession! : container.primarySession!;
    this.panelMgr.getBackgroundBlurSession().setBgBlurScale(0, 'exitSplitViewToOneStep');
    container.changeState(SCBSceneContainerState.ONE_STEP);
    let containerRotation = container.currentRotation;
    this.exitSceneWithRotationRecover(container, SCBContainerRotationReason.SPLIT_SCENE);
    container.splitParam.setLifeCycle(SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP);
    // In fold
    if (containerRotation !== container.currentRotation) {
      container.updateSessionRectForSplitOnBack(this.screenProperty, containerRotation, isPrimaryOneStep);
    }
    // remove scene form container and move container to OneStep. create new container by removed scene or destruct it
    let exitCb = (id: number, need: boolean) => {};
    container.isDisappearing = true;
    this.exitToBackgroundBeforeAnimation(exitScene, needRemove);
    let controller = this.getTargetTransitionController(container, container.primarySession?.sceneInfo);
    SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, false);
    ViewManagerPolicy.showView(ViewType.DESKTOP);
    ViewManagerPolicy.showView(ViewType.WALLPAPER);
    ViewManagerPolicy.hideView(ViewType.STATUS_BAR);
    // mask desktop edit mode
    this.editModeViewEvent.editSwitchEnable = false;
    homeLog.showInfo(`mask desktop edit mode, editSwitchEnable: ${this.editModeViewEvent.editSwitchEnable}`);
    this.updateScenePanelState(ScenePanelState.SPLIT);
    container.notifyForegroundInteractiveStatus(false);
    container.sessionData.preferSplitBackToFull = true;
    this.exitSplitViewForBackToOneStep(!isPrimaryOneStep, 0, container, needRemove);
  }

  public exitSplitForFullScene(containerSession: SCBSceneContainerSession, persistentId: number, needRemove: boolean,
    extraInfo?: ExecuteCallbackExtraInfo) {
    if (containerSession.isActive) {
      let sceneSession = containerSession.getSceneSessionById(persistentId);
      let needMinimize: boolean = containerSession.sessionData.preferSplitBackToFull;
      if (needMinimize) {
        winLog.showInfo(`[SCBSplit] preferSplitBackToFull, minimizeSplitOnTerminate persistentId: ${persistentId}`);
      }
      if (needMinimize) {
        this.minimizeSplitScene(containerSession, persistentId, needRemove);
        containerSession.splitParam.setLifeCycle(SplitLifeCycle.UNDEFINED);
      } else {
        this.exitSplitViewToOneStep(persistentId, containerSession, needRemove);
      }
    }
  }

  /**
   *
   * @param persistentId
   * @param containerSession
   * @returns true for need terminate the session
   */
  public exitSplitForTerminate(persistentId: number, containerSession: SCBSceneContainerSession,
    needRemove: boolean, extraInfo?: ExecuteCallbackExtraInfo): boolean {
    let needTerminate = true;
    let panelState = this.stateCollectionHandler?.getPanelState();
    winLog.showInfo(`[SCBSplit] exitSplitForTerminate scenePanelState: ${panelState}, ` +
      `persistentId: ${persistentId} needRemove: ${needRemove}`);
    switch (panelState) {
      case ScenePanelState.FULLSCENE:
        winLog.showInfo(`exitSplitForTerminate exitSplitForFullScene FULLSCENE`);
        this.exitSplitForFullScene(containerSession, persistentId, needRemove, extraInfo);
        needTerminate = false;
        break;
      case ScenePanelState.HOME:
      case ScenePanelState.RECENT:
        winLog.showInfo(`exitSplitForTerminate exitSplitView HOME or RECENT`);
        needTerminate = false;
        break;
      case ScenePanelState.SPLIT:
        if (containerSession.primarySession) {
          containerSession.primarySession.needDestructedInSplit = false;
        }
        if (containerSession.primarySession && !containerSession.secondarySession &&
          containerSession.primarySession.session?.persistentId === persistentId) {
          winLog.showInfo(`exitSplitForTerminate oneStepSplitExit SPLIT`);
          this.oneStepSplitExit(containerSession);
        } else if (containerSession.primarySession  && containerSession.secondarySession) {
          this.oneStepSplitExit(containerSession, true);
        } else {
          winLog.showInfo(`exitSplitForTerminate needTerminate false SPLIT`);
          needTerminate = false;
        }
        break;
      default:
        winLog.showInfo(`exitSplitForTerminate unprocessed scenePanelState: ${panelState}`);
    }
    return needTerminate;
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Rotation
  // ----------------------------------------------------------------------------------------------------

  public updateScreenSessionWhenRotate(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason) {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showError('updateScreenSessionWhenRotate screenSession is null');
      return;
    }
    // screen rotation no need to change bounds in screen session
    // rotation with start/exit scene need change bounds since screen session cannot know
    if (reason !== SCBContainerRotationReason.SCREEN_ROTATION) {
      screenSession.updateVirtualProperty(screenProperty, SCBPropertyChangeReason.ROTATION, false);
    }
  }

  /**
   * notifyUpdateScenePanelWhenRotate
   */
  public notifyUpdateScenePanelWhenRotate(screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyUpdateScenePanelWhenRotate] notify ScenePanel.');
    this.stateCollectionHandler?.getViewParam().onScreenChange(screenProperty, SCBPropertyChangeReason.ROTATION);
  }

  /**
   * updateFloatContainerWithScreenChange
   */
  public updateFloatContainerWithScreenChange(screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateFloatContainerWithScreenChange] update float container.');
    this.floatingSessionList.forEach((floatingSession) => {
      floatingSession.rotateFloating(screenProperty, reason);
    });
  }

  /**
   * updateSystemBarProperty
   */
  public updateSystemBarProperty(): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateSystemBarProperty] update system bar property.');
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  /**
   * update current rotation
   */
  public updateCurrRotation(rotation: number): void {
    this.dataCollectionHandler?.setCurrRotation(rotation);
  }

  public updateScenePanelWhenRotate(screenProperty: SCBScreenProperty, currScreenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession, isPageRotation: boolean = false): void {
    this.screenProperty.copy(screenProperty);
    this.dataCollectionHandler?.setCurrRotation(this.screenProperty.rotation);
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
      if (!screenSession) {
        homeLog.showError('[ROTATION][updateScenePanelWhenRotate] screenSession is null');
        return;
      }
      screenSession.rotationController.updateCurrRotation(screenProperty.rotation);
    }
    this.notifyUpdateScenePanelWhenRotate(screenProperty);
    if (currentContainer && !currentContainer.isFloat) {
      // start scene with exact container rotation
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[updateScenePanelWhenRotate] Update currentContainer, ` +
                       `containerId=${currentContainer?.containerId}, ` +
                       `name=${currentContainer?.primarySession?.sceneInfo.bundleName}, ` +
                       `isActive=${currentContainer.isActive}`);
      currentContainer?.updateContainerSessionWithRotation(this.screenProperty, reason, isPageRotation);
    } else {
      // rotation with whole screen
      for (let containerSession of this.containerSessionList) {
        if (!containerSession.isActive) {
          // need to set inactive container not rotate
          continue;
        }
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[updateScenePanelWhenRotate] Update containerSession, ` +
                         `containerId=${containerSession.containerId}, `+
                         `name=${containerSession.primarySession?.sceneInfo.bundleName}, ` +
                         `isActive=${containerSession.isActive}`);
        containerSession.updateContainerSessionWithRotation(screenProperty, reason, isPageRotation);
      }
    }
    this.updateFloatContainerWithScreenChange(screenProperty, reason)
    this.updateSystemBarProperty();
  }

  public showWallpaperAfterRotate(isEnableBlur: boolean = true): void {
    ViewManagerPolicy.showView(ViewType.WALLPAPER);
    if (isEnableBlur) {
      this.panelMgr.enableBlurComponent('showWallpaperAfterRotate');
    }
  }

  /**
   * updateNeedScrollClipRotateFinish
   */
  public updateNeedScrollClipRotateFinish(): void {
    if (!this.stateCollectionHandler?.getNeedScrollClip()) {
      this.stateCollectionHandler?.updateNeedScrollClip(true);
    }
  }

  private rotationAnimationFinished(rotationStartTime: number, screenProperty: SCBScreenProperty,
    rotateEvent: RotateChangeEvent, containerSession: SCBSceneContainerSession | null,
    isTimeoutCheck: boolean = false): void {
    homeLog.showInfo(`endRotationAnimate rotationAnimCnt:${this.dataCollectionHandler?.getRotationAnimCnt()}` +
      `isTimeoutCheck:${isTimeoutCheck}`);
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    this.updateNeedScrollClipRotateFinish();
    if (!this.dataCollectionHandler) {
      return;
    }
    if (isTimeoutCheck) {
      if (this.dataCollectionHandler.getRotationAnimCnt() > 0) {
        this.dataCollectionHandler.setRotationAnimCnt(1);
      } else {
        return;
      }
    }
    this.dataCollectionHandler.decRotationAnimCnt();
    if (this.dataCollectionHandler.getRotationAnimCnt() < 0) {
      this.dataCollectionHandler.setRotationAnimCnt(0);
      return;
    }
    let rotationDuration = Date.now() - rotationStartTime;
    HiDfxEventUtil.reportScenePanelRotationEnd(rotationStartTime.toFixed(), this.screenProperty.screenId,
      this.getPanelName(), rotationDuration);
    if (this.dataCollectionHandler.getRotationAnimCnt() === 0) {
      this.notifyScreenRotateToCallbacks(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      this.updateScreenRotationProperty(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      // not show desktop, since focus error
      AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(1);
      this.notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      this.updateBlackBackgroundState(false);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_0);
      // this.showWallpaperAfterRotate();
      rotateEvent.rotateStatus = RotateChangeEvent.ROTATE_STATUS_END;
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      performanceMonitor.end('SCREEN_ROTATION_ANI');
    }
    this.setKeyboardRotationFlag(false);
    this.updateFloatAfterRotationAnimate();
  }

  public updateFloatAfterRotationAnimate(): void {
    let floatActiveSession = this.floatingSessionList.getTopActiveSession();
    if (floatActiveSession && floatActiveSession.floatingParam.needRecoverStatusBar) {
      floatActiveSession.floatingParam.needRecoverStatusBar = false;
      SCBSceneSessionManager.getInstance().updateNavigationBarProperty(true);
      homeLog.showInfo(`show statusBar when onFinish session is: ${floatActiveSession.getName()}`);
    }
  }

  /**
   * getPanelName
   */
  public getPanelName(): string {
    return this.dataCollectionHandler?.getPanelName() ?? DEFAULT_PANEL_NAME;
  }

  private rotationAnimationFinishedWhenNotifyRotation(rotationStartTime: number, screenProperty: SCBScreenProperty,
    rotateEvent: RotateChangeEvent, isTimeoutCheck: boolean = false): void {
    homeLog.showInfo(`endRotationAnimate rotationAnimCnt:${this.dataCollectionHandler?.getRotationAnimCnt()}` +
      `isTimeoutCheck:${isTimeoutCheck}`);
    if (!this.dataCollectionHandler) {
      return;
    }
    if (isTimeoutCheck) {
      if (this.dataCollectionHandler.getRotationAnimCnt() > 0) {
        this.dataCollectionHandler.setRotationAnimCnt(1);
      } else {
        return;
      }
    }
    this.dataCollectionHandler.decRotationAnimCnt();
    if (this.dataCollectionHandler.getRotationAnimCnt() < 0) {
      this.dataCollectionHandler.setRotationAnimCnt(0);
      return;
    }
    let rotationDuration = Date.now() - rotationStartTime;
    HiDfxEventUtil.reportScenePanelRotationEnd(rotationStartTime.toFixed(), this.screenProperty.screenId,
      this.getPanelName(), rotationDuration);
    if (this.dataCollectionHandler.getRotationAnimCnt() === 0) {
      AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(1);
      SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_0);
      rotateEvent.rotateStatus = RotateChangeEvent.ROTATE_STATUS_END;
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      performanceMonitor.end('SCREEN_ROTATION_ANI');
    }
    this.stateCollectionHandler?.getKeyboardSession()?.setKeyboardRotationFlag(false);
  }

  /**
   * updateScreenRotationProperty
   */
  public updateScreenRotationProperty(screenProperty: SCBScreenProperty, notifyType: SCBRotateChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateScreenRotationProperty]')
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty, notifyType);
  }

  /**
   * notifySetSystemSceneRotaion
   */
  public notifySetSystemSceneRotaion(screenProperty: SCBScreenProperty, systemWantAnimation: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifySetSystemSceneRotaion]');
    SCBSceneSessionManager.getInstance().notifySetSystemSceneRotaion(screenProperty, systemWantAnimation);
  }

  /**
   * notifyUpdateSystemScenePropertyWithoutAnimation
   */
  public notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty: SCBScreenProperty) {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyUpdateSystemScenePropertyWithoutAnimation]');
    SCBScreenSessionManager.getInstance().notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty);
  }

  public notifyRotation(screenProperty: SCBScreenProperty, needUpdateSystem: boolean,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotation] reason: %{public}i, screenProperty: ' +
      'left=%{public}i, top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason,
      screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    let currScreenProperty = new SCBScreenProperty();
    currScreenProperty.copy(this.screenProperty);
    // notify other app rotation listener
    this.updateScreenRotationProperty(screenProperty, SCBRotateChangeReason.UNSPECIFIED);
    let rotationWindow = SCBWindowRotateController.getInstance()
      .notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN, true);
    this.updateScreenSessionWhenRotate(screenProperty, reason);
    SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    this.updateScenePanelWhenRotate(screenProperty, currScreenProperty, reason, currentContainer);
    let needAnimation = SCBScreenSessionManager.getInstance().hasRotationCallbacks(screenProperty);
    if (needUpdateSystem) {
      // start scene need inform after start animation
      this.notifySetSystemSceneRotaion(screenProperty, false);
      this.notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty);
      if (needAnimation) {
        this.notifySystemSceneRotationWithAnimation(screenProperty, currentContainer);
      }
    }
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotation] Update screenProperty, left=%{public}i, top=%{public}i' +
      ', width=%{public}i, height=%{public}i, rotation=%{public}i', this.screenProperty.left, this.screenProperty.top,
      this.screenProperty.width, this.screenProperty.height, this.screenProperty.rotation);
  }

  public getRotateDuration(screenPropertyRotation: number): number {
    let rotationAngle = Math.abs(screenPropertyRotation - this.screenProperty.rotation);
    return rotationAngle > 90 ? 550 : 400;
  }

  /**
   * notifyUpdateSystemScenePropertyWithAnimation
   */
  public notifyUpdateSystemScenePropertyWithAnimation(screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyUpdateSystemScenePropertyWithAnimation] notify systemscene.');
    SCBScreenSessionManager.getInstance().notifyUpdateSystemScenePropertyWithAnimation(screenProperty);
  }

  public notifySystemSceneRotationWithAnimation(screenProperty: SCBScreenProperty,
    currentContainer?: SCBSceneContainerSession): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[notifySystemSceneRotationWithAnimation] notify systemscene with animation, ` +
                     `bundleName:${currentContainer?.primarySession?.session.bundleName} `);
    let containerSession = this.rotationAnimationBeginWhenNotifyRotation(screenProperty);
    let rotateDuration = this.getRotateDuration(screenProperty.rotation);
    let rotationStartTime = Date.now();
    this.updateRotateAnimationConfig(rotateDuration);
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_START);
    this.notifySystemSceneToUpdateSizeChangeReason(screenProperty, sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.setRotateFinishTimer(rotationStartTime, screenProperty,
      rotateEvent, containerSession);
    animateTo({
      duration: rotateDuration,
      curve: Curve.Friction,
      onFinish: () => {
        this.rotationAnimationFinishedWhenNotifyRotation(rotationStartTime, screenProperty, rotateEvent);
      }
    }, () => {
      this.notifySetSystemSceneRotaion(screenProperty, true);
      this.notifyUpdateSystemScenePropertyWithAnimation(screenProperty);
    });
  }

  public notifyPageRotation(screenProperty: SCBScreenProperty, needUpdateSystem: boolean,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyPageRotation] reason: %{public}i, screenProperty: ' +
      'left=%{public}i, top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason,
      screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    let currScreenProperty = new SCBScreenProperty();
    currScreenProperty.copy(this.screenProperty);
    // notify other app rotation listener
    transactionManager.openSyncTransaction(screenProperty.screenId);
    let inVisibleSystemSceneCallbacks: [Function, boolean, number | null][] = [];
    animateTo({duration: 0}, () => {
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
        SCBRotateChangeReason.UNSPECIFIED);
      this.updateScreenSessionWhenRotate(screenProperty, reason);
      SCBScreenSessionManager.getInstance().updateVisibleSystemRotationBeforeScenePanel(screenProperty);
      this.updateScenePanelWhenRotate(screenProperty, currScreenProperty, reason, currentContainer, isPageRotation);
      inVisibleSystemSceneCallbacks = this.updateVisibleSystemRotation(screenProperty);
    });
    if (currentContainer?.isVertical(currentContainer.currentRotation) !== currentContainer?.isVertical(screenProperty.rotation)) {
      transactionManager.closeSyncTransaction(screenProperty.screenId);
    } else {
      transactionManager.closeSyncTransactionWithVsync(screenProperty.screenId);
      // 0->180, 90->270 need close with vsync since size not change
    }
    this.updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyPageRotation] Update screenProperty, left=%{public}i, top=%{public}i' +
      ', width=%{public}i, height=%{public}i, rotation=%{public}i', this.screenProperty.left, this.screenProperty.top,
      this.screenProperty.width, this.screenProperty.height, this.screenProperty.rotation);
  }

  private setRotateFinishTimer(rotationStartTime: number, screenProperty: SCBScreenProperty,
    rotateEvent: RotateChangeEvent, containerSession: SCBSceneContainerSession | null): void {
    if (!this.dataCollectionHandler) {
      return;
    }
    if (this.dataCollectionHandler.getRotateFinishTimerId() !== -1) {
      clearTimeout(this.dataCollectionHandler.getRotateFinishTimerId());
    }
    this.dataCollectionHandler.setRotateFinishTimerId(setTimeout(() => {
      this.rotationAnimationFinished(rotationStartTime, screenProperty,
        rotateEvent, containerSession, true);
      this.dataCollectionHandler?.setRotateFinishTimerId(-1);
    }, 3000))
  }

  /**
   * updateRotateAnimationConfig
   */
  public updateRotateAnimationConfig(rotateDuration: number): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateRotateAnimationConfig] update rotation anim config');
    SCBSceneSessionManager.getInstance().updateRotateAnimationConfig(rotateDuration);
  }

  /**
   * notifySystemSceneToUpdateSizeChangeReason
   */
  public notifySystemSceneToUpdateSizeChangeReason(screenProperty: SCBScreenProperty,
    reason: sceneSessionManager.SessionSizeChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifySystemSceneToUpdateSizeChangeReason] notify systemscene update reason');
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty, reason);
  }

  /**
   * updateVisibleSystemRotation
   */
  public updateVisibleSystemRotation(screenProperty: SCBScreenProperty): [Function, boolean, number | null][] {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateVisibleSystemRotation] update visible system rotation.');
    return SCBScreenSessionManager.getInstance().updateVisibleSystemRotation(screenProperty);
  }

  /**
   * updateInVisibleSystemRotation
   */
  public updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks: [Function, boolean, number | null][],
    screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateInVisibleSystemRotation] update invisible system rotation.');
    SCBScreenSessionManager.getInstance().updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
  }

  /**
   * showDividerAfterRotation
   */
  public showDividerAfterRotation(containerSession: SCBSceneContainerSession | null, rotateDuration: number): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[showDividerAfterRotation] show divider after rotation.');
  }

  /**
   * setFloatAnimateStatus
   */
  public setFloatAnimateStatus(animateStatus: boolean): void {
  }

  public notifyRotationWithAnimation(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] reason: %{public}i, screenProperty, ' +
      'left=%{public}i, top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason,
      screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    let containerSession = this.rotationAnimationBegin(screenProperty);
    let rotationWindow = SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    let rotateDuration = this.getRotateDuration(screenProperty.rotation);
    this.updateRotateAnimationConfig(rotateDuration);
    transactionManager.openSyncTransaction(screenProperty.screenId);
    let rotationStartTime = Date.now();
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_START);
    EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
    this.notifySystemSceneToUpdateSizeChangeReason(screenProperty, sceneSessionManager.SessionSizeChangeReason.ROTATION);
    let inVisibleSystemSceneCallbacks: [Function, boolean, number | null][] = [];
    this.setRotateFinishTimer(rotationStartTime, screenProperty,
      rotateEvent, containerSession);
    this.setFloatAnimateStatus(true);
    animateTo({
      duration: rotateDuration,
      curve: Curve.Friction,
      onFinish: () => {
        this.rotationAnimationFinished(rotationStartTime, screenProperty,
          rotateEvent, containerSession);
        this.setFloatAnimateStatus(false);
      }
    }, () => {
      let currScreenProperty = new SCBScreenProperty();
      currScreenProperty.copy(this.screenProperty);
      this.updateScreenSessionWhenRotate(screenProperty, reason);
      SCBScreenSessionManager.getInstance().updateVisibleSystemRotationBeforeScenePanel(screenProperty);
      this.updateScenePanelWhenRotate(screenProperty, currScreenProperty, reason, undefined);
      inVisibleSystemSceneCallbacks = this.updateVisibleSystemRotation(screenProperty);
      SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    });
    this.showDividerAfterRotation(containerSession, rotateDuration);
    this.updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
    this.handleSplitScreen(containerSession, screenProperty, true);
    transactionManager.closeSyncTransaction(screenProperty.screenId);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] Update Rotation screenProperty, left=%{public}i,' +
      ' top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', this.screenProperty.left,
      this.screenProperty.top, this.screenProperty.width, this.screenProperty.height, this.screenProperty.rotation);
  }

  /**
   * notifyScreenRotateToCallbacks
   */
  public notifyScreenRotateToCallbacks(screenProperty: SCBScreenProperty, notifyType: SCBRotateChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[notifyScreenRotateToCallbacks] notifyType: ${notifyType}`);
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty, notifyType);
  }

  /**
   * addRotationAnimCnt
   */
  public addRotationAnimCnt(): void {
    this.dataCollectionHandler?.addRotationAnimCnt();
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[addRotationAnimCnt] curAnimCnt:' + this.dataCollectionHandler?.getRotationAnimCnt());
  }

  /**
   * prepareSystemSceneRotationBeforeAnimation
   */
  public prepareSystemSceneRotationBeforeAnimation(rotation: number): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[prepareSystemSceneRotationBeforeAnimation] rotation: ${rotation}`);
    SCBSceneSessionManager.getInstance().prepareSystemSceneRotationBeforeAnimation(rotation);
  }

  /**
   * updateBlackBackgroundState
   */
  public updateBlackBackgroundState(blackBackgroundState: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[updateBlackBackgroundState] blackBackgroundState: ${blackBackgroundState}`);
    this.stateCollectionHandler?.updateBlackBackgroundState(blackBackgroundState);
  }

  /**
   * setKeyboardRotationFlag
   */
  public setKeyboardRotationFlag(isRotating: boolean): void {
    this.stateCollectionHandler?.getKeyboardSession()?.setKeyboardRotationFlag(isRotating);
  }

  public rotationAnimationBegin(screenProperty: SCBScreenProperty): SCBSceneContainerSession | null {
    // notify other app rotation listener
    this.updateScreenRotationProperty(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    this.notifyScreenRotateToCallbacks(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN)
    AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(0);
    this.addRotationAnimCnt();

    // don't show wallpaper and desktop during rotation both normal and split scenario
    let containerSession = this.containerSessionList.getTopActiveSession();
    if (SCBSceneSessionManager.getInstance().hasFullSceneSession(screenProperty.screenId)) {
      ViewManagerPolicy.hideView(ViewType.DESKTOP);
    }
    let isScreenLocked = SCBSceneSessionManager.getInstance().isScreenLocked();
    if (isScreenLocked || SCBSceneSessionManager.getInstance().hasFullSceneSession(screenProperty.screenId)) {
      ViewManagerPolicy.hideView(ViewType.WALLPAPER);
    }
    if (containerSession && containerSession.primarySession && containerSession.secondarySession) {
      containerSession.dividerParam.dividerAlpha = 0;
    }

    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_1);
    performanceMonitor.begin('SCREEN_ROTATION_ANI', performanceMonitor.ActionType.LAST_UP,
      containerSession?.primarySession?.sceneInfo.bundleName);

    this.prepareRotationBeforeAnimation(screenProperty.rotation);
    this.prepareSystemSceneRotationBeforeAnimation(screenProperty.rotation);

    //  black background is added only when a full-screen Session exists.
    if (this.containerSessionList.getTopActiveSession() !== null) {
      this.updateBlackBackgroundState(true);
    }
    this.setKeyboardRotationFlag(true);
    return containerSession;
  }

  public rotationAnimationBeginWhenNotifyRotation(screenProperty: SCBScreenProperty): SCBSceneContainerSession | null {
    AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(0);
    this.addRotationAnimCnt();
    SCBScreenSessionManager.getInstance().notifyExcuteBeforeRotationAnimationCallbacks(screenProperty);
    let containerSession = this.containerSessionList.getTopActiveSession();
    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_1);
    performanceMonitor.begin('NOTIFY_ROTATION_ANI', performanceMonitor.ActionType.LAST_UP,
      containerSession?.primarySession?.sceneInfo.bundleName);
    // 大角度的旋转
    this.prepareRotationBeforeAnimation(screenProperty.rotation);
    this.prepareSystemSceneRotationBeforeAnimation(screenProperty.rotation);
    this.setKeyboardRotationFlag(true);
    return containerSession;
  }

  public prepareRotationBeforeAnimation(targetRotation: number): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[prepareRotationBeforeAnimation] prepare rotation before animation, ' +
                     'scbScreenProperty rotation: ' + this.screenProperty.rotation +
                     ' targetRotation: ' + targetRotation);
    if (targetRotation === 0 && this.screenProperty.rotation === RotationConstants.ROTATION_270) {
      // avoid animation 270, 240, 210 ... 30, 0, should play from 90->0
      // change current Rotation
      this.screenProperty.rotation = -RotationConstants.ROTATION_90;
    } else if (targetRotation === RotationConstants.ROTATION_270 &&
      this.screenProperty.rotation === RotationConstants.ROTATION_0) {
      // avoid animation 0, 30, 60 ... 270, should play from 360->270
      this.screenProperty.rotation = RotationConstants.ROTATION_360;
    }
  }

  public prepareAnimationBeforeStart(containerSession: SCBSceneContainerSession, screenRotation: number): void {
    let lastAngle = (screenRotation - containerSession.currentRotation + RotationConstants.ROTATION_360) %
    RotationConstants.ROTATION_360;
    if (lastAngle === RotationConstants.ROTATION_270) {
      lastAngle = -RotationConstants.ROTATION_90;
    }
    let tmp = screenRotation - lastAngle + RotationConstants.ROTATION_360;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[prepareAnimationBeforeStart] change sceneContainerSession currentRotation ` +
                     `from ${containerSession.currentRotation} to ${tmp}, ` +
                     `screenRotation: ${screenRotation} start from recent, ` +
                     `containerSession name:${containerSession.getName()}, lastAngle:${lastAngle}`);
    containerSession.currentRotation = tmp;
  }

  public rotateWindowPolicy(containerSession: SCBSceneContainerSession, fromUser: boolean, targetRotation: number,
    screenSession: SCBScreenSession, isFromRecent: boolean, needAnimation: boolean, isPageRotation: boolean = false) {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] rotate with window policy.');
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] no need to rotate in the lock screen interface.');
      return;
    }
    if (this.screenProperty.rotation === targetRotation && containerSession.currentRotation === targetRotation &&
      this.dataCollectionHandler?.getCurrRotation() === targetRotation) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] no need to rotate with same targetRotation.');
      return;
    }
    SCBWindowRotateController.getInstance().notifyBeforeWindowRotateChange();
    this.clearRecentStartNotifyRotation();
    HiSysEventUtil.reportRotationChange(containerSession.primarySession?.sceneInfo.bundleName,
      SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId), targetRotation,
      fromUser ? HiSysEventUtil.ROTATION_TYPE_SET_REQUESTED_ORIENTATION : HiSysEventUtil.ROTATION_TYPE_APP_START);

    let screenProperty: SCBScreenProperty = this.screenProperty.getRotatedScreenProperty(targetRotation);
    if (isFromRecent && needAnimation && containerSession.currentRotation === targetRotation) {
      needAnimation = false;
    }
    if (needAnimation) {
      // only animation need rotate reason
      if (isFromRecent) {
        this.prepareAnimationBeforeStart(containerSession, this.screenProperty.rotation);
      }
      this.notifyRotationWithAnimation(screenProperty, SCBContainerRotationReason.PANEL_ROTATION);
    } else if (isPageRotation) {
      this.notifyPageRotation(screenProperty, true, SCBContainerRotationReason.PANEL_ROTATION, containerSession, isPageRotation);
    } else {
      // change this.screenProperty with screenProperty
      this.notifyRotation(screenProperty, true, SCBContainerRotationReason.START_SCENE, containerSession);
    }
    this.requestPIPScenePanelRotation(screenProperty);
  }

  /**
   * requestPIPScenePanelRotation
   */
  public requestPIPScenePanelRotation(screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[requestPIPScenePanelRotation]');
    SCBSceneSessionManager.getInstance().requestPIPScenePanelRotation(screenProperty.screenId);
  }

  /**
   * setExpandStartContainerSession
   */
  public setExpandStartContainerSession(containerSession: SCBSceneContainerSession | null): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[setExpandStartContainerSession]');
    this.dataCollectionHandler?.setExpandStartContainerSession(containerSession);
  }

  public rotateScreenPolicy(screenSession: SCBScreenSession, containerSession: SCBSceneContainerSession,
    isFromRecent: boolean, needAnimation: boolean, targetRotation: number, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenPolicy] rotate with screen policy' +
                     `isPageRotation:${isPageRotation}`);
    const screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId);
    this.setExpandStartContainerSession(containerSession);
    if (isFromRecent && needAnimation && containerSession.currentRotation === targetRotation) {
      needAnimation = false;
    }
    // 应用当前角度不等于目标角度，或者当前屏幕角度不等于目标角度时，需要强制旋转
    let isForce: boolean = (containerSession.currentRotation !== targetRotation || targetRotation !== screenRotation);
    if (isForce && isFromRecent) {
      this.clearRecentStartNotifyRotation();
    }
    if (needAnimation) {
      if (isFromRecent) {
        this.prepareAnimationBeforeStart(containerSession, screenRotation);
      } else {
        if (screenSession.isRotateScreenPolicy()) {
          containerSession.currentRotation = targetRotation;
        }
      }
    }

    if (!needAnimation && targetRotation !== screenSession.scbScreenProperty.rotation &&
      !SCBSceneSessionManager.getInstance().isScreenLocked() && !isFromRecent && !isPageRotation) {
      SCBWindowRotateController.getInstance().notifyBeforeWindowRotateChange();
      let screenProperty = this.getScreenProperty();
      SCBWindowRotateController.getInstance().sceneLandscapeStart(screenSession, containerSession,
        targetRotation, screenProperty);
      let systemSceneNeedAnimation = SCBScreenSessionManager.getInstance().hasRotationCallbacks(screenProperty);
      if (systemSceneNeedAnimation) {
        this.notifySystemSceneRotationWithAnimation(screenProperty, containerSession);
      }
      // sync when 600ms timeout
      setTimeout(() => {
        SCBWindowRotateController.getInstance().landscapeStartSync(containerSession, this.screenProperty);
      }, 600);
    } else {
      SCBWindowRotateController.getInstance().windowRotateEntry(targetRotation, 'scenePanelStartScene',
        needAnimation, isForce, true, false, isPageRotation);
    }
    this.setExpandStartContainerSession(null);
  }

  public getContainerSessionRotation(containerSession: SCBSceneContainerSession, screenSession: SCBScreenSession,
    fromUser: boolean) {
    let targetRotation = containerSession.getTargetRotation(screenSession.sensorScreenProperty.rotation, fromUser);
    if (containerSession.currentRotation === null || containerSession.currentRotation === undefined) {
      homeLog.showError('getContainerSessionRotation currentContainerRotation=%{public}i container name=%{public}s',
        containerSession.currentRotation, containerSession.getName());
      containerSession.currentRotation = this.screenProperty.rotation ?? 0;
      if (screenSession.isRotateScreenPolicy()) {
        containerSession.currentRotation = screenSession.scbScreenProperty?.rotation;
      }
    }
    if (!fromUser && containerSession.isRelatedToUserRotationPolicy() &&
      targetRotation !== containerSession.currentRotation) {
      targetRotation = containerSession.currentRotation;
      let rotationPolicyMap = SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
      if (!rotationPolicyMap.get(targetRotation)) {
        targetRotation = RotationConstants.ROTATION_0;
      }
      homeLog.showInfo('getContainerSessionRotation change targetRotation=%{public}i', targetRotation);
    }
    return targetRotation;
  }

  public coverSensorRotation(screenSession: SCBScreenSession): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[coverSensorRotation] cover sensor rotation.');
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      return;
    }
    if (this.containerSessionList.getTopActiveSession() === null &&
      this.screenProperty.rotation === RotationConstants.ROTATION_0 &&
      screenSession.currentSensorRotation === -1) {
      screenSession.coverPhoneSensorRotation(RotationConstants.ROTATION_0);
    }
  }

  public startSceneWithRotationIfNeed(containerSession?: SCBSceneContainerSession | null,
    needAnimation: boolean = false, isFromRecent: boolean = false, fromUser: boolean = false, isPageRotation: boolean = false): void {
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] containerSession is null.');
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] screenSession is null');
      return;
    }
    if (containerSession.consumePendingPageRotation('startSceneWithRotationIfNeed')) {
      isPageRotation = true;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[startSceneWithRotationIfNeed] containerSession ${containerSession.getName()}, ` +
                     `needAnimation ${needAnimation} isFromRecent ${isFromRecent} fromUser ${fromUser} ` +
                     `isPageRotation ${isPageRotation}`);
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      screenSession.rotationController.startSceneWithRotationIfNeed(containerSession, needAnimation,
        isFromRecent, fromUser, isPageRotation);
      return;
    }
    this.coverSensorRotation(screenSession);
    let targetRotation = this.getContainerSessionRotation(containerSession, screenSession, fromUser);
    WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] before rotate with targetRotation=%{public}i, ' +
      'sensorRotation=%{public}i, currentScreenRotation=%{public}i, currentContainerRotation=%{public}i, ' +
      'name=%{public}s', targetRotation, screenSession.sensorScreenProperty.rotation, this.screenProperty.rotation,
      containerSession.currentRotation, containerSession.primarySession?.sceneInfo.bundleName);
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      HiSysEventUtil.reportRotationChange(containerSession.primarySession?.sceneInfo.bundleName,
        SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId), targetRotation,
        fromUser ? HiSysEventUtil.ROTATION_TYPE_SET_REQUESTED_ORIENTATION : HiSysEventUtil.ROTATION_TYPE_APP_START);
      this.rotateScreenPolicy(screenSession, containerSession, isFromRecent, needAnimation, targetRotation, isPageRotation);
    } else {
      this.rotateWindowPolicy(containerSession, fromUser, targetRotation, screenSession, isFromRecent, needAnimation, isPageRotation);
    }
    this.checkIfNeedChangeScreenProperty(screenSession);
  }

  public checkIfNeedChangeScreenProperty(screenSession: SCBScreenSession): void {
    if (this.exitSceneNotifyRotation !== undefined && this.exitSceneNotifyRotation !== screenSession.scbScreenProperty?.rotation) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' checkIfNeedChangeScreenProperty need recover screen property');
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(
        screenSession.scbScreenProperty,
        SCBRotateChangeReason.ROTATION_UPDATE_PROPERTY_ONLY_NOT_NOTIFY);
      this.clearExitSceneNotifyRotation();
    }
  }

  /**
   * interruptPipAnimWithFloatRotation
   */
  public interruptPipAnimWithFloatRotation(): void {
    PipOneShotAnimHelper.interruptPipAnimWithFloatRotation();
  }

  public exitSceneWithRotationRecover(currentSession?: SCBSceneContainerSession,
    reason?: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[exitSceneWithRotationRecover] rotateScreenWhenExitScene reason:${reason}`);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] notifyRotation screenSession is null');
      return;
    }
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      screenSession.rotationController.exitSceneWithRotationRecover(currentSession, reason);
      return;
    }
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      this.rotateScreenWhenExitScene(reason);
      this.checkIfNeedChangeScreenProperty(screenSession);
      return;
    }
    let isVerticalExit = this.isVerticalExit();
    if (isVerticalExit && reason !== SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE) {
      WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] no need to recover with vertical Exit!');
      this.checkIfNeedChangeScreenProperty(screenSession);
      return;
    }
    // interrupt autoStartPip Animation with float rotation
    this.interruptPipAnimWithFloatRotation();
    // split scene need to do with rotation
    if (this.containerSessionList.getTopActiveFullSession() && !this.checkIfSplitScene(reason)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] no need to recover if exist top active scene!');
      this.checkIfNeedChangeScreenProperty(screenSession);
      return;
    }
    let targetScreenProperty = this.screenProperty.getRotatedScreenProperty(0);
    if (targetScreenProperty.rotation === this.screenProperty.rotation &&
      reason !== SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] name=%{public}s, ' +
                       'no need notify rotation targetRotation=%{public}i, sensorRotation=%{public}i, ' +
                       'currentScreenRotation=%{public}i, currentRotation=%{public}i',
                       currentSession?.primarySession?.sceneInfo.bundleName, targetScreenProperty.rotation,
                       screenSession.sensorScreenProperty.rotation,
                       this.screenProperty.rotation, currentSession?.currentRotation);
      return;
    }
    // change this.screenProperty with screenProperty
    HiSysEventUtil.reportRotationChange(currentSession?.primarySession?.sceneInfo.bundleName,
      SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId),
      targetScreenProperty.rotation, HiSysEventUtil.ROTATION_TYPE_APP_OUT)
    if (reason && this.checkIfSplitScene(reason)) {
      this.notifyRotation(targetScreenProperty, true, reason, currentSession);
    } else if (this.floatingSessionList.getTopActiveSession()) {
      this.handleFloatWhenExitScene(reason);
      this.notifyRotationWithAnimation(targetScreenProperty, SCBContainerRotationReason.EXIT_SCENE);
    } else {
      this.notifyRotation(targetScreenProperty, true, SCBContainerRotationReason.EXIT_SCENE,
        currentSession);
    }
    this.clearExitSceneNotifyRotation();
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[exitSceneWithRotationRecover] targetRotation = 0, ` +
                     `sensorRotation=${screenSession.sensorScreenProperty.rotation}, ` +
                     `currentRotation=${this.screenProperty.rotation}`);
    SCBSceneSessionManager.getInstance().requestPIPScenePanelRotation(this.screenProperty.screenId);
  }

  private handleFloatWhenExitScene(reason?: SCBContainerRotationReason): void {
    this.panelMgr.onBlurTransitionInactive();
    let floatActiveSession = this.floatingSessionList.getTopActiveSession();
    if (floatActiveSession && !this.containerSessionList.getTopActiveSession() &&
      uiType === SCBConstants.UITYPE_PHONE) {
      floatActiveSession.floatingParam.needRecoverStatusBar = true;
      SCBSceneSessionManager.getInstance().updateNavigationBarProperty(false);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[handleFloatWhenExitScene] hide statusBar when exit scene, ` +
                       `session name:${floatActiveSession.getName()}`);
    }
    if (reason === SCBContainerRotationReason.LANDSCAPE_ONE_STEP_FLOAT_SCENE) {
      this.stateCollectionHandler?.updateNeedScrollClip(false);
    }
  }

  private clearExitSceneNotifyRotation(): void {
    this.exitSceneNotifyRotation = undefined;
  }

  public isVerticalExit(): boolean {
    return this.screenProperty.rotation === RotationConstants.ROTATION_0 ||
      this.screenProperty.rotation === RotationConstants.ROTATION_360;
  }

  private updateScreenRotationPropertyForRecent(targetRotation: number,
    sceneContainerSession: SCBSceneContainerSession): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateScreenRotationPropertyForRecent] update screen property for recent.');
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[updateScreenRotationPropertyForRecent] screenSession is null.');
      return;
    }
    let screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId);
    if (targetRotation !== screenRotation) {
      sceneContainerSession.setNeedSyncSessionRect(false);
      this.dataCollectionHandler?.setRecentStartNotifyRotation(targetRotation);
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(
        screenSession.scbScreenProperty.getRotatedScreenProperty(targetRotation),
        SCBRotateChangeReason.ROTATION_UPDATE_PROPERTY_ONLY);
    }
  }

  /**
   * getMattesLockState
   */
  private getMattesLockState(): boolean {
    return this.stateCollectionHandler?.getMattesLockState() ?? false;
  }

  // 屏幕旋转的应用退出旋转
  private rotateScreenWhenExitScene(reason?: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] rotate screen when exit scene.');
    if (this.containerSessionList.getTopActiveSession() &&
      (reason !== SCBContainerRotationReason.SPLIT_SCENE && reason !== SCBContainerRotationReason.MID_SCENE)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] no need to rotate if exist top active scene!');
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] screenSession is null.');
      return;
    }
    // 锁定旋转时转到锁定前的角度；未锁定旋转时，转到sensor所在角度
    let targetRotation = screenSession.getTargetScreenRotationWhenAppExit();
    let isForce = (targetRotation !== screenSession.scbScreenProperty.rotation);
    let needAnimation: boolean = true;
    // when screen rotate landscape start not sync not need animation but need force
    if (SCBWindowRotateController.getInstance().isLandscapeStartInterrupt() &&
      targetRotation === SCBWindowRotateController.getInstance().getLandscapeStartDesktopRotation()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] screen rotate landscape start not sync when exit scene.');
      needAnimation = false;
      isForce = true;
    }
    HiSysEventUtil.reportRotationChange(this.containerSession?.primarySession?.sceneInfo.bundleName,
      SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId),
      targetRotation, HiSysEventUtil.ROTATION_TYPE_APP_OUT)

    SCBWindowRotateController.getInstance().windowRotateEntry(targetRotation, 'scenePanelExitScene',
      needAnimation, isForce);
    SCBWindowRotateController.getInstance().setLandScapeStartNotSync(false);
  }

  public sceneStartTransitionIfNeed(fromSceneSession: SCBSceneSession, toSceneSession: SCBSceneSession,
    toInfo: SCBSceneInfo, topActiveSceneSession: SCBSceneContainerSession | null,
    isBackTransition: boolean, isPCApp: boolean) {
    let fromContainerSession = this.getContainerSessionById(fromSceneSession.session.persistentId);
    if (fromContainerSession === null) {
      homeLog.showError(`[SCBMain]onSceneTransition Failed to get fromContainerSession: ` +
        `${fromSceneSession.getName()}`);
      return;
    }

    let isAppMultiWindow: boolean = SCBSceneSessionManager.getInstance().isAppMultiWindowMode(toSceneSession.sceneInfo);

    if (this.pairSplitIfInOneApp(fromContainerSession, fromSceneSession, toSceneSession, toInfo)) {
      homeLog.showInfo('[SCBMain]onSceneTransition pairSplitIfInOneApp return');
      if (SCBSceneUtils.isStartFromVirtual(fromContainerSession.primarySession,
        fromContainerSession.secondarySession)) {
        this.startSceneWithRotationIfNeed(fromContainerSession);
      }
      return;
    }
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    let toContainerSession =
      sceneContainerSession ?? this.getSessionFromFloatingScene(toSceneSession.session.persistentId);
    if (toContainerSession && toContainerSession.isSplit && !toContainerSession.isActive &&
      (fromContainerSession.containerId !== toContainerSession.containerId)) {
      // toContainerSession exist and is split in background, we need to exit
      toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    }
    let isFromShowAboveKeyguard = fromSceneSession.isShowAboveKeyguard;
    if (this.sceneTransitionToSpecialIfNeed(toSceneSession, fromSceneSession, toContainerSession,
      toInfo.isCalledRightlyByCallerId)) {
      homeLog.showInfo('[SCBMain]onSceneTransition will continue on special panel.')
      return;
    }
    if (toContainerSession === null) {
      toContainerSession = this.getToContainerSessionOfTransition(toSceneSession, toInfo, isFromShowAboveKeyguard);
    } else {
      this.panelMgr.addSceneContainerSessionAndRemoveNotShow(toContainerSession);
    }
    if (!isPCApp && !toContainerSession.isFloat) {
      this.startSceneWithRotationIfNeed(toContainerSession);
    }
    toContainerSession.requestActivation(toSceneSession.isNewWant);
    this.panelMgr.raiseSceneToTop(toContainerSession);
    toSceneSession.sessionData.isNewWant = true;
    if (SCBPhoneSceneUtils.isSceneWithoutAnimation(toInfo)) {
      homeLog.showWarn('[SCBMain]onSceneTransition without animation');
      return;
    }
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE &&
      fromContainerSession.containerId === toContainerSession.containerId) {
      homeLog.showInfo(`[SCBMain]sceneStartTransitionIfNeed skip, scenePanelState is FULLSCENE same container: ${fromContainerSession.getName()}`);
      return;
    }
    this.updateScenePanelStateWhenStartFloat(toSceneSession);
    if (toInfo.windowMode === SCBSceneMode.FLOATING && !fromContainerSession.isFloat) {
      if (toSceneSession.isPcAppInPad) {
        let sessionRect = new SCBSessionRect(toInfo.windowLeft, toInfo.windowTop,
          toInfo.windowWidth, toInfo.windowHeight);
        toSceneSession.updateRect(sessionRect.left, sessionRect.top,
          sessionRect.width, sessionRect.height);
        toContainerSession.changeState(SCBSceneContainerState.FLOAT);
        SCBScenePanelManager.getInstance().removeSceneContainerSession(sceneContainerSession);
        SCBScenePanelManager.getInstance().addFloatContainerSession(sceneContainerSession);
      }
      homeLog.showInfo('[SCBMain]onSceneTransition Do not requestBackground for floating window');
      return;
    }
    if (topActiveSceneSession && this.needMinimizeActiveContainer(toContainerSession, topActiveSceneSession) &&
      topActiveSceneSession !== fromContainerSession) {
      homeLog.showInfo('[SCBMain]onSceneTransition topActiveSceneSession requestBackground');
      topActiveSceneSession.requestBackground();
    }
    fromContainerSession.resetTransitionController();

    // 同应用内不同ability跳转标识赋值
    homeLog.showInfo(`[SCBAnimation]startAnimationOptions:${JSON.stringify(toInfo.startAnimationOptions)}`)
    if (!!fromContainerSession.primarySession) {
      fromContainerSession.primarySession.sessionData.startAnimationOptions = toInfo.startAnimationOptions;
    }
    if (!!toContainerSession.primarySession) {
      toContainerSession.primarySession.sessionData.startAnimationOptions = toInfo.startAnimationOptions;
    }

    this.startSceneContainerTransition(toInfo, fromContainerSession, toContainerSession,
      isBackTransition, isFromShowAboveKeyguard, topActiveSceneSession);
  }

  public isRotateScreenPolicy(): boolean {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showError('screenSession is null');
      return false;
    }
    return screenSession.isRotateScreenPolicy();
  }

  public rotationAfterExitApp(sceneContainerSession: SCBSceneContainerSession): void {
    // 只有在所有的退出动效结束之后在旋转屏幕
    if (SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
      // 旋转需要在图标显示之后再响应,
      animateTo({}, () => {});
      let param = RecentRotationUtil.createRotationParam(RotateFuncType.EXIT_SCENE,
        SCBContainerRotationReason.EXIT_SCENE, sceneContainerSession);
      SCBScreenSessionManager.getInstance().notifyWrapRotateEntry(this.screenProperty.screenId, param);
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Common
  // ----------------------------------------------------------------------------------------------------

  public isNeedTransitionOutFinish(containerSession: SCBSceneContainerSession) {
    if (containerSession.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      containerSession.transitionOutFinish();
    }
  }

  public setEmergencyOrThermalSafeModeDuration() {
    this.blurTransitionInactiveDuration = this.isInEmergencyOrThermalSafeMode() ? 0 : 300;
    this.iconAlphaDuration = this.isInEmergencyOrThermalSafeMode() ? 0 : 110;
    this.renderAlphaDuration = this.isInEmergencyOrThermalSafeMode() ? 0 : 60;
    this.sceneContainerSessionIconAlphaDuration = this.isInEmergencyOrThermalSafeMode() ? 0 : 90;
  }

  // ----------------------------------------------------------------------------------------------------
  // Multi Window
  // ----------------------------------------------------------------------------------------------------

  public updateViewType(toContainerSession: SCBSceneContainerSession): void {
    if (toContainerSession.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      ViewManagerPolicy.hideView(ViewType.DESKTOP);
      this.showWallpaperAfterRotate();
    }
  }

  // ----------------------------------------------------------------------------------------------------
  //  Floating Window
  // ----------------------------------------------------------------------------------------------------

  public isFloatingWindowMode(sceneInfo: SCBSceneInfo, sceneSession: SCBSceneSession,
    sceneContainerSession: SCBSceneContainerSession | null, isInSideEdgeBar: boolean): boolean {
    if (sceneSession.sceneInfo) {
      sceneInfo.persistentId = sceneSession.sceneInfo.persistentId;
    }
    let isInRecent = this.isRecentState();
    homeLog.showInfo(`[SCBFloat] isFloatingWindowMode, scenePanelState: ` +
      `${this.stateCollectionHandler?.getPanelState()}, persistentId: ${sceneInfo.persistentId}`);
    let bundleName: string = sceneInfo.bundleName === VassistantConstants.VASSISTANT_BUNDLE_NAME ?
    VassistantConstants.VASSISTANT_LAUNCHER_BUNDLE_NAME : sceneInfo.bundleName;
    if (this.checkIfThisAppIsActive(sceneInfo, isInRecent, isInSideEdgeBar)) {
      return false;
    }
    homeLog.showInfo(`[SCBFloat] isFloatingWindowMode, windowmode: ${sceneInfo?.windowMode}`);
    if (sceneInfo?.windowMode !== SCBSceneMode.FLOATING ||
      GrayAppListManager.getInstance().isGrayAppIcon({ bundleName: bundleName, appIndex: sceneInfo?.appIndex })) {
      homeLog.showInfo(`[SCBFloat] windowMode is not FLOATING`);
      this.onStartSceneFromOther(sceneInfo);
      return false;
    }
    if (this.isRecentState()) {
      if (this.checkIsInContainerSessionList(sceneInfo) !== null) {
        sceneContainerSession?.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'isFloatingWindowMode');
        this.exitRecent(true);
        this.exitSceneWithRotationRecover(undefined, SCBContainerRotationReason.EXIT_RECENT);
      } else {
        this.exitRecent();
      }
      this.stateCollectionHandler?.getViewParam().initAll();
    }
    let containerSession = this.getSceneContainerSessionWithPersistentId(sceneInfo.persistentId);
    return true;
  }

  // ----------------------------------------------------------------------------------------------------
  // Split Scene
  // ----------------------------------------------------------------------------------------------------

  public initUnclearContainerForPad(sceneContainerSession: SCBSceneContainerSession): void {
    if (DeviceHelper.isPad()) {
      let unclearAble = this.dataCollectionHandler?.getRecentDelete().isUnclearAbleWhenClearAll(sceneContainerSession);
      if (unclearAble && sceneContainerSession.floatingParam.isClosed) {
        sceneContainerSession.updateScaleForFloat(1);
        sceneContainerSession.isFloat = false;
        this.panelMgr.addSceneContainerSession(sceneContainerSession);
        this.dataCollectionHandler?.getAppFloating().resizeSceneContainer(sceneContainerSession);
        sceneContainerSession.initAll();
        sceneContainerSession.primarySession?.updateCurRectForMultiWindowToFull(this.screenProperty);
        sceneContainerSession.primarySession?.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
        sceneContainerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
      }
    }
  }

  public pairSplitFromDockForFullScreen(locationX: number, locationY: number, sceneSession: SCBSceneSession,
    container: SCBSceneContainerSession): void {
    return;
  }

  public pairSplitFromDockForSplit(locationX: number, locationY: number, sceneSession: SCBSceneSession,
    activeSceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneSession || !activeSceneContainerSession) {
      winLog.showError('pairSplitFromDockForSplit params is null');
      return;
    }
    let oldFirstSceneSessionName = activeSceneContainerSession.getFirstSceneSession()?.sceneInfo.bundleName;
    let oldSeconSceneSessionName = activeSceneContainerSession.getSecondSceneSession()?.sceneInfo.bundleName;
    winLog.showInfo(`pairSplitFromDockForSplit, primary: ${activeSceneContainerSession.primarySession?.getName()}, `
      + `secondary: ${activeSceneContainerSession.secondarySession?.getName()}`);
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  public pairSplitFromDock(sceneSession: SCBSceneSession, activeSceneContainerSession: SCBSceneContainerSession,
    locationX: number, locationY: number) {
    winLog.showInfo('pairSplitFromDock, enableBlurComponent');

    // case 1: if new start app is from split, need exit split firstly and then remove sceneContainerSession
    // case 2: if new start app is from full scene container, remove sceneContainerSession
    // if mulition, session persistentId is different.
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    if (sceneContainerSession && sceneContainerSession.primarySession &&
    sceneContainerSession.secondarySession) {
      winLog.showInfo('onPairSplitFromDock, sceneContainerSession is in split, exit split');
      sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    }
    this.panelMgr.removeSceneContainerSession(sceneContainerSession);

    if (activeSceneContainerSession.isSplit) {
      this.pairSplitFromDockForSplit(locationX, locationY, sceneSession, activeSceneContainerSession);
      return;
    }
    this.pairSplitFromDockForFullScreen(locationX, locationY, sceneSession, activeSceneContainerSession);
  }

  public onPairSplitFromDock = (locationX: number, locationY: number, sceneInfo: SCBSceneInfo): void => {
    if (!sceneInfo) {
      homeLog.showInfo('onPairSplitFromDock start scene sceneInfo is null');
      return;
    }
    homeLog.showInfo(`onPairSplitFromDock, bundleName:${sceneInfo.bundleName}, persistentId:${sceneInfo.persistentId}`);
    let sceneSession: SCBSceneSession | null;
    if (sceneInfo.launchType === bundleManager.LaunchType.MULTITON) {
      sceneSession = this.requestNewSceneSession(sceneInfo);
    } else {
      sceneSession = this.requestSceneSession(sceneInfo);
    }
    if (sceneSession === null) {
      homeLog.showError('onPairSplitFromDock failed to request scene session!');
      return;
    }
    SCBSceneSessionManager.getInstance().execAdditionalCallersCallback();
    this.showWallpaperAfterRotate();
    // blurcomponent is disabled in HOME state, enable it when starting from icon
    this.panelMgr.enableBlurComponent('onPairSplitFromDock');
    this.stateCollectionHandler?.getViewParam().initAll();
    let exitRecentCallback = () => {
      if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
        return;
      }
      this.exitRecent(true);
      SCBScenePanelManager.getInstance().getBackgroundBlurSession().setBgBlurScale(1, 'exitRecentCallback');
    }
    let panelState = this.stateCollectionHandler?.getPanelState();
    if (panelState === ScenePanelState.HOME || panelState === ScenePanelState.RECENT) {
      let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      if (sceneContainerSession?.isSplit && sceneContainerSession.primarySession &&
      sceneContainerSession.secondarySession) {
        homeLog.showInfo('onPairSplitFromDock sceneContainerSession is in split exit split');
        // here need update sceneContainerSession, because when exit split in recent, it has changed
        sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      }
      let isNewContainer: boolean = false;
      if (sceneContainerSession === null) {
        homeLog.showInfo('onPairSplitFromDock failed to get container from list and new one');
        sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
        isNewContainer = true;
      }
      exitRecentCallback();
      this.updateScenePanelState(ScenePanelState.FULLSCENE, true);
      return;
    }
    if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.FULLSCENE) {
      homeLog.showInfo(`onPairSplitFromDock return, scenePanelState:` +
        `${ScenePanelState[this.stateCollectionHandler?.getPanelState() ?? 0]}`);
      return;
    }
    let activeSceneContainerSession = this.containerSessionList.getTopActiveSession();
    if (!activeSceneContainerSession) {
      homeLog.showError('onPairSplitFromDock with no active scene container session');
      return;
    }
    if (activeSceneContainerSession.primarySession?.sceneInfo.persistentId === sceneSession.sceneInfo.persistentId ||
      activeSceneContainerSession.secondarySession?.sceneInfo.persistentId === sceneSession.sceneInfo.persistentId) {
      homeLog.showInfo('onPairSplitFromDock not support multi-Windows');
      return;
    }

    if (sceneSession.isFixedMultiWindowOrientation) {
      homeLog.showInfo('onPairSplitFromDock not support multi-Windows for game');
      return;
    }

    // if new start app is from float, need remove it from float firstly
    this.pairSplitFromDock(sceneSession, activeSceneContainerSession, locationX, locationY);
    sceneSession.sessionData.isNewWant = true;
  }

  public setSensorRotationUnable(): void {
    if (uiType === SCBConstants.UITYPE_PHONE) {
      // block sensor rotation when exit split to one step
      SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId)
        .setEnableSensorRotate(false, 'exitSplitToOneStep');
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Recent
  // ----------------------------------------------------------------------------------------------------

  public isRecentState(): boolean {
    return this.stateCollectionHandler?.getPanelState() == ScenePanelState.RECENT;
  }

  public isSplitState(): boolean {
    return this.stateCollectionHandler?.getPanelState() == ScenePanelState.SPLIT;
  }

  public isQuickSwitchState(): boolean {
    return this.stateCollectionHandler?.getPanelState() === ScenePanelState.QUICK_SWITCH;
  }

  public isHomeState(): boolean {
    return this.stateCollectionHandler?.getPanelState() === ScenePanelState.HOME;
  }

  public isFloatSceneState(): boolean {
    return this.stateCollectionHandler?.getPanelState() === ScenePanelState.FLOAT_SCENE;
  }

  /**
   * 底部导航&多任务&快切业务场景设置ScenePanelTouchable状态
   *
   * @param isTouchable 是否可触摸状态
   */
  public setScenePanelTouchableByNavigation(isTouchable?: boolean): void {
    let touchable: boolean = false;
    if (isTouchable === null || isTouchable === undefined) {
      if (this.isRecentState() || this.isQuickSwitchState() || this.dataCollectionHandler?.getIsTouchableByNavBar()) {
        touchable = true;
      }
    } else {
      // once swipe up not reach recent, also need set interactive status
      touchable = isTouchable;
    }
    homeLog.showInfo(`setScenePanelTouchableByNavigation is %{public}s, scenePanelState is %{public}d` +
      ` isTouchableByNavBar:%{public}s isTouchable:%{public}s`, touchable, this.stateCollectionHandler?.getPanelState(),
      this.dataCollectionHandler?.getIsTouchableByNavBar(), isTouchable);
    this.setScenePanelTouchable(touchable);
  }

  /**
   * 窗口侧处理ScenePanelTouchable状态
   *
   * @param isTouchable 是否可触摸状态
   */
  public setScenePanelTouchable(isTouchable: boolean) {
    this.sysSceneSession.setSessionTouchable(isTouchable);
    SCBKeyboardManager.getInstance().setKeyboardSessionTouchable(!isTouchable);
    if (isTouchable) {
      // notify current foreground session paused
      for (let containerSession of this.containerSessionList) {
        if (containerSession?.isActive) {
          containerSession.notifyForegroundInteractiveStatus(false);
        }
      }
    } else {
      let topContainerSession = this.containerSessionList.getTopActiveSession();
      if (topContainerSession?.isActive) {
        topContainerSession.notifyForegroundInteractiveStatus(true);
      }
      this.floatingSessionList.filter(containerSession => containerSession.isActive)
        .forEach((floatContainerSession) => {
          floatContainerSession.notifyForegroundInteractiveStatus(true);
        })
    }
  }

  public changeScenePanelStateToHome(fromState: ScenePanelState, toState: ScenePanelState,
    scaleDelayTime: number = 0, withoutScaleAnim: boolean = false): void {
    // Cover scenarios return to home : app crash, multi-task deletion tasks or return to home without gestures
    if (!(fromState === ScenePanelState.FULLSCENE &&
      toState === ScenePanelState.HOME && SCBSceneSessionManager.getInstance().isScreenLocked())) {
      if (withoutScaleAnim) {
        SCBTransitionManager.getInstance().runGlobalInactiveCallback(false);
      } else {
        SCBTransitionManager.getInstance().runGlobalInactiveCallback(true, scaleDelayTime);
      }
      SCBTransitionManager.getInstance().swipeUpFromHome(RecentsStyleConstants.SCALE_DEFAULT);
    }
    if (uiType === SCBConstants.UITYPE_PAD) {
      SCBSceneSessionManager.getInstance().notifyHotRegionStateChange();
    }
    recentRuntimeInstance.initContainerCountsShowInRecent();
    ViewManagerPolicy.showView(ViewType.DESKTOP);
    // From Split to Home open desktop edit
    this.editModeViewEvent.editSwitchEnable = true;
    homeLog.showInfo('From Split to Home open desktop edit, ' +
      `editSwitchEnable: ${this.editModeViewEvent.editSwitchEnable}`)
  }

  public clearRecentStartNotifyRotation(): void {
    this.dataCollectionHandler?.setRecentStartNotifyRotation(undefined);
  }

  public showStatusBar(isShowStatusBar: boolean, enableAnimation: boolean = true): void {
    if (isShowStatusBar && GestureDockViewModel.getInstance().getViewData()?.isGestureDockShow()) {
      homeLog.showInfo('showStatusBar return');
      return;
    }
    SCBSceneSessionManager.getInstance().enterRecentTask(!isShowStatusBar, enableAnimation);
  }

  public handleEmptyRecentView() {
    if (!this.stateCollectionHandler) {
      return;
    }
    if (!this.isRecentState()) {
      if (this.floatingSessionList.length === 0) {
        this.stateCollectionHandler.getViewParam().recentW = this.screenProperty.width;
      }
      this.updateScenePanelState(ScenePanelState.RECENT);
    }
  }

  public publishScenePanelEventMsg(eventNAME: string, eventType: string, parameters?: Record<string, Object>): void {
    let options: commonEventManager.CommonEventPublishData = {
      data: eventType
    };
    if (parameters !== undefined) {
      options.parameters = parameters;
    }
    try {
    commonEventManager.publish(eventNAME, options, () => {
      recentLog.showDebug(`publish ${eventNAME} ${eventType} success`);
    });
    } catch (err) {
      recentLog.showError(`publish ${eventNAME} ${eventType} fail, ${err.code} - ${err.message}`);
    }
  }

  public enterRecentView(isFromNavigationCallback: boolean, isFromApp: boolean = true) {
    recentLog.showInfo(`enterRecentView isFromApp=${isFromApp}`);
    // 进入多任务，背景模糊加上灰阶
    if (this.stateCollectionHandler?.getBgGrayScaleDisableState()) {
      this.stateCollectionHandler.updateBgGrayScaleDisableState(false);
    }
    if (this.startAndExitEffectMgr.isStartExitWallpaperBlurDisable() && !this.folderData.isFolderOpen()) {
      recentLog.showInfo('enterRecentView ICON_START_EXIT_BLUR_EFFECT false');
      this.desktopContext?.eventHub.emit(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT, false);
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_MULTIPLE_TASKBARS, StyleConstants.DEFAULT_1);
    if (isFromNavigationCallback) {
      performanceMonitor.begin('GESTURE_TO_RECENTS', performanceMonitor.ActionType.FIRST_MOVE);
      this.publishScenePanelEventMsg(CEManager.CUSTOM_RECENT_EVENT, RecentEventType.ENTER_RECENT);
    } else {
      this.recentEnter.breakEnterRecentAnimations('enterRecentView');
      this.quickSwitchAnimations.breakQuickSwitchAnimations('recent key to recent');
    }
    RecentGestureEventManager.getInstance()
      .deliverGestureEvent(RecentGestureEvent.ENTER_RECENT_IDLE_FROM_APP,
        this.containerSessionList.getTopActiveSession());
    this.setScenePanelTouchableByNavigation();
    this.panelMgr.setSceneContainerSessionListForView(this.containerSessionList.filterClone());
    for (let floatingSession of this.panelMgr.getFloatingSessionListForView()) {
      if (floatingSession?.isActive) {
        floatingSession.notifyForegroundInteractiveStatus(false);
      }
    }
    this.recentScroll.initForEnterRecent();
    SCBDesktopCacheManager.getInstance().setWallPaperFreezeState(true, 'sceneContainerTransitionIn',
      this.screenProperty.rotation);
    let containerSessionListForView: SCBSceneContainerSessionArray =
      this.panelMgr.getSceneContainerSessionListForView();
    let lastSession = containerSessionListForView.getTopSession();
    let sessionShowStatus = this.recentNotShow.getShowStatus(lastSession);
    let lastSessionNotShow = sessionShowStatus === ContainerShowState.NOT_SHOW;
    recentRuntimeInstance.init(this.totalContainerSessionList.filterClone());
    if (lastSessionNotShow) {
      recentRuntimeInstance.notRemovingSessionList.deleteByContainerId(lastSession?.containerId);
      recentRuntimeInstance.initContainerCountsShowInRecent();
    }
    SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.ENTER_RECENT);
    recentLockModel.setRecentLockForEnter(recentRuntimeInstance.notRemovingSessionList);
    if (uiType === SCBConstants.UITYPE_PAD) {
      SCBSceneSessionManager.getInstance().notifyHotRegionStateChange();
    }
    if (!this.stateCollectionHandler) {
      return;
    }
    // hide side edge bar
    SCBSceneSessionManager.getInstance().processSystemRecentEvent();
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
    this.recentEnter.recordStartEnterRecentLogs(isFromApp);
    this.stateCollectionHandler.getRecentInnerState().onEnterAnimating();
    let screenW = px2vp(this.screenProperty.width);
    let recentScale = RecentLayoutManager.getScale(this.screenProperty);
    this.stateCollectionHandler.getViewParam().recentPadding = (1 - recentScale) / 2 * screenW;
    if (!isFromApp) {
      SCBTransitionManager.getInstance().swipeUpFromHome(RecentsStyleConstants.DESKTOP_SCALE_FROM_HOME_TO_RECENT);
    }

    let totalContainerSessionListLen = this.totalContainerSessionList.length;
    if (totalContainerSessionListLen === 0) {
      this.handleEmptyRecentView();
      SceneIdentificationManager.notify(SceneState.RECENT_ENTER);
      this.recentEnter.recordEndEnterRecentLogs();
      this.showStatusBar(false);
      return;
    }
    let lastSessionSplit = sessionShowStatus === ContainerShowState.PRIMARY_SHOW || sessionShowStatus ===
      ContainerShowState.SECONDARY_SHOW;
    this.recentEnter.updateEnterIdx(isFromApp, lastSessionNotShow);
    let companionIconInfo = this.totalContainerSessionList[totalContainerSessionListLen - 1]?.companionIconInfo;
    if (!CheckEmptyUtils.isEmpty(companionIconInfo)) {
      localEventManager.sendLocalEvent(`${CommonConstants.EVENTHUB_SHOW_BADGE}${companionIconInfo.bundleName}${companionIconInfo.abilityName}${companionIconInfo.moduleName}`);
    }
    let recentLayoutCalculator = RecentLayoutCalculatorFactory.getRecentLayoutCalculatorInstance(this.panelMgr);
    // 过滤掉pendingRemove为true的应用之后的长度，用于计算进入多任务后落位的位置
    let notRemovingLength = recentRuntimeInstance.notRemovingSessionList.length;
    let recentWLen = Math.max(1, notRemovingLength);
    // 设置多任务整个列表scroll的宽度
    this.stateCollectionHandler.getViewParam().recentW = recentLayoutCalculator.getRecentLayoutWidth(
      recentWLen - recentRuntimeInstance.leftBoundaryIndex, this.stateCollectionHandler.getViewParam().recentPadding);
    // scroll需要设置的偏移量，scroll需要直接滑到当前跟手应用的位置
    let finalOffsetX = this.recentEnter.getFinalOffsetXForScroll(lastSessionNotShow, isFromApp, recentLayoutCalculator);
    this.stateCollectionHandler.getViewParam().recentTransX = 0;
    let floatSessionListLen = this.panelMgr.getFloatingSessionListForView().length;
    let listLen = containerSessionListForView.length;
    if (this.dataCollectionHandler?.getIsNeedChangeToMultiRow() && listLen > 2) {
      this.recentEnter.initOtherContainerSessionsForMultiRow();
    }
    // Keep the current position consistent with the end of the follower phase
    let multiPositions: MultiRecentPositionArray = RecentLayoutManager.getMultiPositions(notRemovingLength);
    let containerCount = lastSessionNotShow ? listLen - 1 : listLen;
    animateTo({
      duration: 0
    }, () => {
      this.recentScroll.scrollToImmediately(finalOffsetX, 'enter recent view');
    })
    // if (floatSessionListLen > 0) {
    //   this.floatingIntoRecentAnimation(containerCount, floatSessionListLen, recentScale, finalOffsetX,
    //     notRemovingLength, multiPositions);
    // }
    this.recentEnter.inheritFollowingBeforeEnter(lastSessionNotShow, finalOffsetX);
    this.recentEnter.playTitleAppearAnimations(lastSessionSplit);
    // 最后一张卡片不显示 做消失的动效
    if (isFromApp) {
      this.recentNotShow.notShowContainerAnimationOut(this.totalContainerSessionList, this);
    }
    this.recentEnter.startEnterRecentAnimation(isFromApp, isFromNavigationCallback, lastSessionNotShow,
      this.enterRecentFinishCallback);
    this.updateScenePanelState(ScenePanelState.RECENT, isFromApp);
    this.showStatusBar(false);
    SceneIdentificationManager.notify(SceneState.RECENT_ENTER);
    this.registerPrepareWindowCallBack();
    this.recentEnter.recordEndEnterRecentLogs();
  }

  // 悬浮窗进多任务动效
  private floatingIntoRecentAnimation(containerCount: number, floatSessionListLen: number, recentScale: number,
    finalOffsetX: number, notRemovingLength: number, multiPositions: MultiRecentPositionArray) {
    for (let i = 0; i < floatSessionListLen; i++) {
      let floatContainer = this.floatingSessionList[i];
      if (!floatContainer || !floatContainer.primarySession) {
        continue;
      }
      floatContainer.floatingParam.isShowTitleBar = false;
      floatContainer.floatingParam.floatRecentAnimateFinished = false;
      floatContainer.floatingParam.intoRecentAnimationNum++;
      this.recentGesture.playTitleAppearAnimation(floatContainer);
      if (!floatContainer.isActive) {
        // 非active悬浮窗目标位置动效
        let posXInRecent = this.recentEnter.getPositionX(i + containerCount, notRemovingLength);
        this.backgroundFloatingSceneAnimation(floatContainer, notRemovingLength, recentScale, posXInRecent,
          i + containerCount, multiPositions)
      }
    }
    this.activatedFloatingSceneAnimation(containerCount, floatSessionListLen, recentScale, notRemovingLength,
      multiPositions);
  }

  // 后台悬浮窗位置计算
  private backgroundFloatingSceneAnimation(floatContainer: SCBSceneContainerSession, notRemovingLength: number,
    recentScale: number, posXInRecent: number, containerCountAddI: number, multiPositions: MultiRecentPositionArray) {
    floatContainer.needRenderScale.centerX = '50%';
    floatContainer.needRenderScale.centerY = '50%';
    let floatName = floatContainer.getName();
    floatContainer.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'backgroundFloatIntoRecent',
      floatContainer.getName());
    floatContainer.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'backgroundFloatIntoRecent', floatName);
    floatContainer.addTransitionCount();
    floatContainer.needRenderPos.setPosXWithDfx(posXInRecent, TAG, 'backgroundFloatIntoRecent', floatName);
    floatContainer.needRenderPos.setPosYWithDfx(0, TAG, 'backgroundFloatIntoRecent', floatName);
    floatContainer.needRenderScale.setScaleXWithDfx(recentScale, TAG, 'backgroundFloatIntoRecent', floatName);
    floatContainer.needRenderScale.setScaleYWithDfx(recentScale, TAG, 'backgroundFloatIntoRecent', floatName);
    floatContainer.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'backgroundFloatIntoRecent', floatName);
    // 调整悬浮窗Y轴的位置
    let translateY = this.dataCollectionHandler?.getIsNeedChangeToMultiRow() ?
    RecentLayoutManager.getMultiRowTranslateY(notRemovingLength, containerCountAddI, multiPositions,
      this.screenProperty) : RecentLayoutManager.getSingleRowInitTranslateY(this.screenProperty);
    floatContainer.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, 'backgroundFloatIntoRecent', floatName);
    floatContainer.transitionController?.onInactive(TAG, 'enterRecentView', 'floatSession');
    floatContainer.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'activatedFloatingSceneAnimation');
  }

  // 悬浮窗动效位置计算
  private activatedFloatingSceneAnimation(containerCount: number, floatSessionListLen: number, recentScale: number,
    notRemovingLength: number, multiPositions: MultiRecentPositionArray) {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 158, 21),
      onFinish: () => {
        for (let i = 0; i < floatSessionListLen; i++) {
          let floatContainer = this.floatingSessionList[i];
          if (!floatContainer || !floatContainer.primarySession) {
            continue;
          }
          let floatingParam = floatContainer.floatingParam;
          floatingParam.intoRecentAnimationNum--;
          if (!floatingParam.floatRecentAnimateFinished && floatingParam.intoRecentAnimationNum === 0) {
            floatContainer.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'activatedFloatingSceneAnimation');
            floatingParam.floatRecentAnimateFinished = true;
            floatingParam.floatInRecentFinished = true;
          }
        }
      }
    }, () => {
      for (let i = 0; i < floatSessionListLen; i++) {
        let floatContainer = this.floatingSessionList[i];
        if (!floatContainer || !floatContainer.primarySession) {
          continue;
        }
        let posXInRecent = this.recentEnter.getPositionX(i + containerCount, notRemovingLength);
        if (floatContainer.isActive) {
          let targetPositionX = posXInRecent;
          floatContainer.needRenderPos.setPosXWithDfx(targetPositionX, TAG, 'activeFloatEnterRecentView');
          floatContainer.needRenderPos.setPosYWithDfx(0, TAG, 'activeFloatEnterRecentView');
          let changePositionX = (1 - recentScale) * floatContainer.width.getVp() / 2;
          floatContainer.floatingParam.needRenderTranslate.setTranslateXWithDfx(changePositionX, TAG,
            'activeFloatEnterRecentView');
          let changePositionY = (1 - recentScale) * floatContainer.height.getVp() / 2;
          floatContainer.floatingParam.needRenderTranslate.setTranslateYWithDfx(changePositionY, TAG,
            'activeFloatEnterRecentView');
          floatContainer.needRenderScale.setScaleXWithDfx(recentScale, TAG, 'activeFloatEnterRecentView');
          floatContainer.needRenderScale.setScaleYWithDfx(recentScale, TAG, 'activeFloatEnterRecentView');
          floatContainer.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'activeFloatEnterRecentView');
          let translateY = this.dataCollectionHandler?.getIsNeedChangeToMultiRow() ?
          RecentLayoutManager.getMultiRowTranslateY(notRemovingLength, i + containerCount, multiPositions,
            this.screenProperty) : RecentLayoutManager.getSingleRowInitTranslateY(this.screenProperty);
          floatContainer.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, 'activeFloatEnterRecentView');
          floatContainer.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'activeFloatEnterRecentView');
        } else {
          // 非active悬浮窗做渐显动效
          floatContainer.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'noActivatedFloatingSceneAnimation');
        }
      }
    })

    // 进多任务蒙版透明度过渡动效
    animateTo({
      curve: curves.springMotion(0.5, 0.85),
      delay: 100
    }, () => {
      this.floatingSessionList.forEach(floatContainer => {
        if (floatContainer.isActive) {
          floatContainer.dividerParam.blackBackgroundOpacity =
            floatContainer.floatingParam.recentParams.RECENT_FILL_OPACITY;
        }
      })
    });
  }

  private enterRecentFinishCallback: RecentEnterCallback = {
    onFinish: (animationNum: number, isFromNavigationCallback: boolean) => {
      if (animationNum == 0) {
        if (this.stateCollectionHandler?.getRecentInnerState().isEnterAnimatingState()) {
          this.stateCollectionHandler?.getRecentInnerState().onStable();
        }
        if (isFromNavigationCallback) {
          performanceMonitor.end('GESTURE_TO_RECENTS');
        }
        // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_MULTIPLE_TASKBARS, StyleConstants.DEFAULT_0);
      }
    }
  }

  private recentStartSceneFinishCallback: RecentStartSceneCallback = {
    onFinish: (containerSession: SCBSceneContainerSession, animationNum: number) => {
      recentLog.showInfo(`playStartSceneAnimationFinish scenePanelState: ` +
        `${this.stateCollectionHandler?.getPanelState()}`);
      this.setFrameRateForStartFromRecent(containerSession, StyleConstants.DEFAULT_0);
      let isShowStatusBar = false;
      if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT &&
        !quickSwitchViewModel.isAnimatingState()) {
        this.finishAnimationCallback(containerSession, animationNum);
        isShowStatusBar = true;
      } else if (quickSwitchViewModel.isAnimatingState()) {
        isShowStatusBar = true;
      }
      AIBarViewModel.getInstance(this.screenProperty).updateAiBarHotAreaRectForRecent(this.screenProperty);
      this.checkIfNeedRecoverScreenProperty(RotateFuncType.START_SCENE);
      this.dataCollectionHandler?.setNeedRemoveBlank(false);
      containerSession.setNeedSyncSessionRect(true);
      let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      screenSession?.handleCacheSensorRotationChange();
      if (isShowStatusBar) {
        this.showStatusBar(true);
      }
    }
  }

  private finishAnimationCallback(sceneContainerSession: SCBSceneContainerSession, animationNum: number): void {
    recentLog.showInfo('raiseAnimateToSchedulePriority:gesture into recent end');
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    let isLastAnimation = sceneContainerSession?.transitionInFinishIfNeed(animationNum);
    if (isLastAnimation) {
      sceneContainerSession.isDisappearing = false;
    }
    this.panelMgr.getTotalSessionList().forEach((containerSession) => {
      if (!containerSession) {
        return;
      }
      if (containerSession.containerId === sceneContainerSession?.containerId || containerSession.isFloat) {
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'finishAnimationCallback');
      } else {
        containerSession.init();
      }
      containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      containerSession.needRenderZIndex.resetZIndex();
    })
    // only active session start from recent need start with rotation animation
    if (sceneContainerSession.isActive) {
      if (sceneContainerSession.isSplit) {
        sceneContainerSession.primarySession?.setBufferAvailableCallbackEnable(false);
        sceneContainerSession.secondarySession?.setBufferAvailableCallbackEnable(false);
      } else {
        sceneContainerSession.primarySession?.setBufferAvailableCallbackEnable(false);
      }
      let param = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE,
        SCBContainerRotationReason.START_SCENE, sceneContainerSession, false, true);
      SCBScreenSessionManager.getInstance().notifyWrapRotateEntry(this.screenProperty.screenId, param);
      if (SCBScreenSessionManager.getInstance().isSingleFoldablePhoneExpandStatus() && sceneContainerSession.isWindowEquals()) {
        recentLog.showInfo(`removeBlank with the same sceneContainerSession.currentRotation, sessionName: ${sceneContainerSession.getName()}`);
        this.dataCollectionHandler?.setNeedRemoveBlank(true);
      }
      if (this.dataCollectionHandler?.getNeedRemoveBlank()) {
        recentLog.showInfo(`remove blank with the same rect, sessionName: ${sceneContainerSession.getName()}`);
        this.dataCollectionHandler?.setNeedRemoveBlank(false);
        if (sceneContainerSession.isSplit) {
          sceneContainerSession.primarySession?.removeBlank();
          sceneContainerSession.secondarySession?.removeBlank();
        } else {
          sceneContainerSession.primarySession?.removeBlank();
        }
      }
    } else {
      // 多任务启动过程中，上划反回到实况窗应用，竖屏启动横屏应用 不需要旋转，因为phone侧不支持横屏的实况，上划不需要回到横屏；竖屏的情况下不需要旋转；
      // 实况窗在横屏启动的时候，实况窗会走回到桌面的逻辑，回到桌面有自己的旋转
      // pad上屏幕是可以跟着旋转的，不会有问题
      recentLog.showWarn(`SwipeApp: ${SwipeAppToCapsuleAnimation.instance.isExecuting}`);
      if (!SwipeAppToCapsuleAnimation.instance.isExecuting) {
        let param: WrapRotationEntryParam = {
          rotateFuncType: RotateFuncType.START_SCENE,
          reason: SCBContainerRotationReason.START_SCENE,
          containerSession: sceneContainerSession,
          needAnimation: false,
          isFromRecent: false,
          fromUser: false
        };
        SCBScreenSessionManager.getInstance().notifyWrapRotateEntry(this.screenProperty.screenId, param);
      }
    }
    if (SCBScreenSessionManager.getInstance().isSingleFoldablePhoneExpandStatus()) {
      sceneContainerSession.lastRecentStartBeforeRect = new SCBSessionRect();
      sceneContainerSession.lastRecentStartBeforeRotation = -1;
    }
    SCBSceneSessionManager.getInstance()
      .updateNavigationBarProperty(sceneContainerSession?.mainSession.systemBarProperty
        .get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable, sceneContainerSession?.mainSession);
    this.stateCollectionHandler?.getRecentInnerState().onInit();
    this.publishScenePanelEventMsg(CEManager.CUSTOM_RECENT_EVENT, RecentEventType.START_SCENE_FROM_RECENT);
  }

  public checkIfNeedRecoverScreenProperty(type: RotateFuncType): void {
    let lastNotifyRotation = type === RotateFuncType.EXIT_SCENE ? this.exitSceneNotifyRotation :
      this.dataCollectionHandler?.getRecentStartNotifyRotation();
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

  public exitRecent(isExitRecentNow: boolean = false): void {
    recentLog.showInfo(`exitRecent isExitRecentNow: ${isExitRecentNow} autoCenterColumn:` +
      `${recentRuntimeInstance.autoCenterColumn}`);
    this.recentScroll.stopScrollImmediately('exit recent');
    this.recentExit.recordExitRecentLog();
    performanceMonitor.begin(HiSysEventUtil.EXIT_RECENT_2_HOME_ANI, performanceMonitor.ActionType.LAST_UP);
    ContainerBuilder.resetAllContainerPreBuildStage(this.containerSessionList);
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'exitRecent', true, expandStatus);
    this.desktopContext?.eventHub.emit(SCBConstants.EXIT_RECENT);
    let isFollowing = this.stateCollectionHandler?.getRecentInnerState().isEnterFollowingState();
    this.stateCollectionHandler?.getRecentInnerState().onExitAnimating();
    this.showStatusBar(false, false);
    if (isExitRecentNow) {
      this.recentExit.exitRecentWithoutAnimation(this.exitRecentFinishCallback, isFollowing);
      this.stateCollectionHandler?.updateScrollingState(false);
      this.updateScenePanelState(ScenePanelState.HOME, false);
      this.stateCollectionHandler?.updatePanelVisibleState(Visibility.Visible);
      recentLog.info(`exitRecentWithoutAnimationFinish ${this.stateCollectionHandler?.getPanelVisibleState()}`);
    } else {
      this.recentExit.exitRecentWithAnimation(this, this.recentScroll.currentOffsetX,
        this.stateCollectionHandler?.getScrollingState());
      this.updateScenePanelState(ScenePanelState.HOME, true);
    }
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_RECOVER_STATE);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.EXIT_MULTIPLE_TASKBARS, StyleConstants.DEFAULT_1);
    SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.EXIT_RECENT);
    this.restorePrepareContainerSession();
  }

  public exitRecentAndNotifyFloat(isExitRecentNow: boolean = false, isRefresh: boolean = false): void {
    this.exitRecent(isExitRecentNow);
  }

  /**
   * 退出任务中心恢复预关闭窗口
   */
  public restorePrepareContainerSession(): void {
    if (!DeviceHelper.isPad()) {
      return;
    }
    SCBRecentPrepareManager.getInstance().restorePrepareContainer();
    this.unRegisterPrepareWindowCallBack();
  }

  /**
   * 单行多任务scroll滑动过程中被强杀的卡片，在非打断停止(自动停止)或者退出多任务的时候卡片销毁
   * @param needContainerFilling 是否需要卡片删除补位
   */
  public requestDestructionNeedRemoveSessionList(needContainerFilling: boolean): void {
    if (recentRuntimeInstance.needRemoveSessionList.isEmpty() ||
    this.dataCollectionHandler?.getIsNeedChangeToMultiRow()) {
      return;
    }
    recentLog.showInfo(`requestDestructionNeedRemoveSessionList length ${recentRuntimeInstance.needRemoveSessionList.length}`);
    while (recentRuntimeInstance.needRemoveSessionList.length > 0) {
      let containerSession = recentRuntimeInstance.needRemoveSessionList[0];
      recentRuntimeInstance.needRemoveSessionList.splice(0, 1);
      containerSession.requestDestruction(true, false);
      if (needContainerFilling) {
        this.containerFillingWhenTerminate(containerSession, true);
      }
      this.removeContainerSession(containerSession, true);
    }
  }

  private requestDestructionWhenExitRecent(): void {
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.RECENT) {
      this.requestDestructionNeedRemoveSessionList(false);
      recentRuntimeInstance.exit();
      RecentTitleViewModel.exit();
    }
  }

  public updateScreenRotationPropertyForExit(): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      homeLog.showWarn('updateScreenRotationPropertyForExit screenSession is null');
      return;
    }
    let targetRotation = 0;
    if (screenSession.isRotateScreenPolicy()) {
      targetRotation = this.stateCollectionHandler?.getPhysicalScreenProperty() ?
        this.stateCollectionHandler?.getPhysicalScreenProperty().rotation : 0;
    }
    if (SCBWindowRotateController.getInstance().isDesktopRotatable() || this.screenProperty.isScreenVertical()) {
      homeLog.showInfo('no need to updateScreenRotationPropertyForExit when rotate screen or vertical');
      return;
    }
    if (this.containerSessionList.getTopActiveFullSession()) {
      homeLog.showInfo('no need to updateScreenRotationPropertyForExit if exist top active scene!');
      return;
    }
    if (targetRotation === screenSession.scbScreenProperty?.rotation) {
      homeLog.showInfo('no need to updateScreenRotationPropertyForExit targetRotation equal screenProperty rotation');
      return;
    }
    this.exitSceneNotifyRotation = targetRotation;
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(
      screenSession.scbScreenProperty.getRotatedScreenProperty(targetRotation),
      SCBRotateChangeReason.ROTATION_UPDATE_PROPERTY_ONLY_NOT_NOTIFY);
  }

  private exitRecentFinishCallback: RecentExitCallback = {
    exitRecentWithoutAnimationFinish: () => {
      this.resetDesktopAfterExitRecent();
    },

    exitRecentWithAnimationFinish: (sceneContainerSession: SCBSceneContainerSession,
      animationNum: number, exitRecentAnimCnt: number) => {}
  }

  public resetDesktopAfterExitRecent(): void {
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance()
      .setDesktopCacheWithDfx(false, 'resetDesktopAfterExitRecent', true, expandStatus);
    this.showStatusBar(true);
    this.stateCollectionHandler?.getRecentInnerState().onInit();
    this.desktopContext?.eventHub.emit(SCBConstants.RESET_DESKTOP_AFTER_EXIT_RECENT);
    performanceMonitor.end(HiSysEventUtil.EXIT_RECENT_2_HOME_ANI);
  }

  public sceneContainerTransitionReset(sceneContainerSession: SCBSceneContainerSession): void {
    homeLog.showInfo('sceneContainerTransitionReset');
    if (sceneContainerSession != null) {
      const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      mainScreenSession.setRotatoinExclusive(true, 'sceneContainerTransitionReset');
      sceneContainerSession.resetSessionRotation();
      sceneContainerSession.overlayCardTransition = null;
      sceneContainerSession.transitionController?.onInactive(TAG, 'sceneContainerTransitionReset');
      sceneContainerSession.iconAlpha = 1.0;
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'sceneContainerTransitionReset',
        sceneContainerSession.getName());
      sceneContainerSession.transitionOutFinish(true);
      if (ENABLE_FORCE_CLOSE_HDR) {
        SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
      }
      if (SCBTransitionManager.getInstance().getIsExclusiveSwiperElementsCancelAnimate()) {
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, false);
        SCBTransitionManager.getInstance().setIsExclusiveSwiperElementsCancelAnimate(false);
        this.exitSceneWithRotationRecover(sceneContainerSession);
      }
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Multi Screen
  // ----------------------------------------------------------------------------------------------------

  // Check whether intercepte scene on external screen
   public isExternalScreenIntercepted(sceneContainerSession: SCBSceneContainerSession): boolean {
    let sceneInfo = sceneContainerSession.primarySession?.sceneInfo;
    if (sceneInfo === null || sceneInfo === undefined) {
      return false;
    }
    return SCBSceneSessionManager.getInstance().isExternalScreenIntercepted(sceneInfo);
  }

  private doExternalScreenInterceptedCheck(sceneInfo?: SCBSceneInfo, isNeedShowToast: boolean = true): boolean {
    if (!sceneInfo) {
      return false;
    }
    return SCBSceneSessionManager.getInstance().isExternalScreenIntercepted(sceneInfo, isNeedShowToast);
  }

  // Check whether intercepte scene on external screen, check all session
  public isExternalScreenInterceptedCheckAllSession(sceneContainerSession: SCBSceneContainerSession, isNeedShowToast: boolean = true): boolean {
    return this.doExternalScreenInterceptedCheck(sceneContainerSession.primarySession?.sceneInfo, isNeedShowToast) ||
      this.doExternalScreenInterceptedCheck(sceneContainerSession.secondarySession?.sceneInfo, isNeedShowToast);
  }

  public sendBadgeEvent(sceneInfo: SCBSceneInfo | CompanionIconInfo | undefined, isAppStart: boolean): void {
    localEventManager.sendLocalEventSticky(
      `${CommonConstants.EVENTHUB_APP_LAUNCH_STATE}${sceneInfo?.bundleName}${sceneInfo?.abilityName}${sceneInfo?.moduleName}` +
        `${sceneInfo?.appIndex ?? 0}`, isAppStart)
  }

  public enterFullSceneOrHomeView(state: ScenePanelState, needBlurAnimation: boolean = true) {
    homeLog.showInfo(`enter ${getScenePanelName(state)}`);
    this.initView();
    this.updateScenePanelState(state, needBlurAnimation);
    this.showStatusBar(true);
    this.stateCollectionHandler?.getRecentInnerState().onInit();
    if (state === ScenePanelState.FULLSCENE) {
      homeLog.showInfo('close formservice and managerview when fullscene');
      ViewManager.getInstance().closeFormServiceAndManagerView();
    }
  }

  public initView(): void {
    this.stateCollectionHandler?.getViewParam().initAll();
    this.containerSessionList.forEach((containerSession) => {
      containerSession.init();
    });
  }

  /**
   * 根据sceneSession的persistentId,获取containerSession
   *
   * @param toSceneSession
   * @param toInfo
   * @param isFromShowAboveKeyguard 是否在锁屏之上显示
   * @returns SCBSceneContainerSession
   */
  public getToContainerSessionOfTransition(toSceneSession: SCBSceneSession, toInfo: SCBSceneInfo,
    isFromShowAboveKeyguard: boolean): SCBSceneContainerSession {
    let specialContainerSession = SCBSceneSessionManager.getInstance()
      .getSpecialContainerSessionList()
      .findByPersistentId(toSceneSession.session.persistentId);
    if (specialContainerSession) {
      homeLog.showInfo('[WMSMain] find toContainer session in special list, containerId: ' +
        specialContainerSession.containerId + ', persistentId:' + toSceneSession.session.persistentId);
      toSceneSession.setTemporarilyShowWhenLocked(true);
      specialContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, 'SCBScenePanel',
        'getToContainerSessionOfTransition', specialContainerSession.getName());
      return specialContainerSession;
    }
    if (isFromShowAboveKeyguard) {
      specialContainerSession =
        this.createContainerSessionAboveKeyguard(toInfo.isCalledRightlyByCallerId, toSceneSession);
      specialContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, 'SCBScenePanel',
        'getToContainerSessionOfTransition', specialContainerSession.getName());
      homeLog.showInfo('[WMSMain] create toContainer session in special list, containerId: ' +
        specialContainerSession.containerId + ', persistentId:' + toSceneSession.session.persistentId);
      return specialContainerSession;
    }
    return this.createContainerSessionBelowKeyguard(toSceneSession);
  }

  /**
   * 创建锁屏之上session数据
   *
   * @param isCalledRightlyByCallerId
   * @param toSceneSession
   * @returns SCBSceneContainerSession
   */
  private createContainerSessionAboveKeyguard(isCalledRightlyByCallerId: boolean,
    toSceneSession: SCBSceneSession): SCBSceneContainerSession {
    if (isCalledRightlyByCallerId) {
      let toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      toSceneSession.setTemporarilyShowWhenLocked(true);
      this.addSpecialContainerSession(toContainerSession);
      homeLog.showInfo('[WMSMain]add new containerSession of transition when from above keyguard, id: ' +
        toContainerSession.containerId);
      return toContainerSession;
    } else {
      homeLog.showInfo('[WMSMain]check token failed');
      return this.createContainerSessionBelowKeyguard(toSceneSession);
    }
  }

  /**
   * 创建锁屏之下session数据
   *
   * @param toSceneSession
   * @returns SCBSceneContainerSession
   */
  private createContainerSessionBelowKeyguard(toSceneSession: SCBSceneSession): SCBSceneContainerSession {
    let containerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
    this.panelMgr.addSceneContainerSession(containerSession);
    homeLog.showInfo('[WMSMain]onSceneTransition start scene add new containerSession: ' + containerSession.containerId);
    return containerSession;
  }

  // ----------------------------------------------------------------------------------------------------
  // Multi Screen
  // ----------------------------------------------------------------------------------------------------

  public containerFillingWhenTerminate(containerSession: SCBSceneContainerSession, needRemoveSession: boolean) {
    if (!this.stateCollectionHandler?.getRecentInnerState()?.isInRecentView()) {
      recentLog.info('containerFillingWhenTerminate recentInnerState not isInRecentView return');
      return;
    }
    containerSession?.transitionController?.onInactive(TAG, 'containerFillingWhenTerminate');
    //补位的动效
    if (!needRemoveSession || recentRuntimeInstance.notRemovingSessionList.isEmpty()) {
      return;
    }
    const index = recentRuntimeInstance.notRemovingSessionList.findIndexByContainerId(containerSession.containerId);
    recentLog.info(`terminate index is ${index} ${needRemoveSession}`);
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.recentGesture.initParamForMultiRow(index, this.recentScroll.currentOffsetX, this.totalContainerSessionList);
    }
    if (index !== -1) {
      this.deleteSceneContainerFromRecentWithAnimation(recentRuntimeInstance.notRemovingSessionList, index);
      this.dataCollectionHandler?.getRecentDelete().setParamAfterTerminate(
        this.totalContainerSessionList, containerSession.containerId, index);
      this.recentScroll.updateAutoCenterColumn(this.recentScroll.currentOffsetX);
    }
  }

  public deleteSceneContainerFromRecentWithAnimation(isNotRemovingSessionList: SCBSceneContainerSession[],
    index: number): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    recentLog.showInfo(`deleteSceneContainerFromRecentWithAnimation index:${index}`);
    let screenW = px2vp(this.screenProperty.width);
    let recentScale = RecentLayoutManager.getScale(this.screenProperty);
    this.stateCollectionHandler.getViewParam().recentPadding = (1 - recentScale) / 2 * screenW;
    let fillingContainers: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let listLen = isNotRemovingSessionList.length;
    if (listLen === 0 || index >= listLen || index < recentRuntimeInstance.leftBoundaryIndex) {
      recentLog.showError(`deleteSceneContainerFromRecentWithAnimation error listLen=${listLen} index:${index}`);
      return;
    }

    if (listLen === 1 || recentRuntimeInstance.containerCountsShowInRecent === 1) {
      this.stateCollectionHandler.getRecentInnerState().onInit();
      // ApsUtils.setApsScene(apsManager.SceneAnimation.EXIT_MULTIPLE_TASKBARS, StyleConstants.DEFAULT_1);
      return;
    }
    let showInScreenIndex = this.recentGesture.getSceneSessionScreenIndex(isNotRemovingSessionList[index].containerId);
    let recentLayoutCalculator = RecentLayoutCalculatorFactory.getRecentLayoutCalculatorInstance(this.panelMgr);
    this.stateCollectionHandler.getViewParam().recentW = recentLayoutCalculator.getRecentLayoutWidth(
      recentRuntimeInstance.containerCountsShowInRecent - 1, this.stateCollectionHandler.getViewParam().recentPadding);
    this.stateCollectionHandler.getViewParam().recentTransX = 0;
    let curOffsetX: number = this.recentScroll.currentOffsetX;
    let newOffsetX: number = 0;
    if (!this.dataCollectionHandler?.getIsNeedChangeToMultiRow()) {
      newOffsetX = this.recentGesture.deleteSingleRowContainerFromRecent(isNotRemovingSessionList, index,
        showInScreenIndex, curOffsetX, fillingContainers)
    } else {
      if (this.recentGesture.isRightContainerFill) {
        newOffsetX = this.recentGesture.deleteMultiRowContainerFromRecentIsRightFill(isNotRemovingSessionList, index,
          curOffsetX, Math.max(Math.min(
            px2vp(this.stateCollectionHandler.getViewParam().recentW - this.screenProperty.width),
            this.recentGesture.correctScreenOffsetX), 0), fillingContainers)
      } else {
        newOffsetX = this.recentGesture.deleteMultiRowContainerFromRecentNotRightFill(
          isNotRemovingSessionList, index, curOffsetX, fillingContainers)
      }
    }
    this.recentScroll.scrollToImmediately(newOffsetX, 'recent delete one');
    let isNeedPlayAnimation = true;
    // 单行且进行了scrollTo接续的场景isNeedPlayAnimation为false，其余场景为true
    if (!this.dataCollectionHandler?.getIsNeedChangeToMultiRow() &&
    this.recentScroll.scrollToForTerminateIfNeed(newOffsetX, index)) {
      isNeedPlayAnimation = false;
    }
    if (isNeedPlayAnimation) {
      this.recentGesture.buildFillingContainers(fillingContainers);
      this.recentGesture.playAnimationForFillingContainers();
    }
  }

  /**
   * BlurComponent pre-process
   * @param callerFunctionName call stack info
   */
  public preProcessBlurComponent(callerFunctionName: string): void {
    // 启动退出动效根据CCM配置或省电模式禁用模糊
    if (this.startAndExitEffectMgr.isStartExitBlurDisable()) {
      this.panelMgr.disableBlurComponent(callerFunctionName);
      if (this.startAndExitEffectMgr.isPowerSaveMode()) {
        if (!FolderData.getInstance().isFolderOpen() || CloseAppManager.getInstance().getIsMinimizeAllScene()) {
          launcherVisualEffectMgr.setWallpaperBlurInactive();
        }
        launcherVisualEffectMgr.updateBlurEffect(false, BlurEffectType.ICON_START_EXIT);
      }
    }
  }

  /*
   * 判断是否是从dock或者最近任务区启动应用
   * */
  private startAppFromDockOrRecent(sceneContainerSession: SCBSceneContainerSession): boolean {
    let startAppType: StartType | undefined = sceneContainerSession.companionIconInfo?.startAppType;
    homeLog.showInfo(`startAppType is ${startAppType}`);
    let dockItemInfo: DockItemInfo = {
      bundleName: sceneContainerSession.primarySession?.sceneInfo.bundleName as string,
      abilityName: sceneContainerSession.primarySession?.sceneInfo.abilityName as string,
      appIndex: sceneContainerSession.primarySession?.sceneInfo.appIndex ?? 0,
      appInstanceKey: sceneContainerSession.primarySession?.sceneInfo.appInstanceKey ?? '',
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      appName: ''
    }
    let appItemInfo =
      PageDesktopModel.getInstance().getAppInfoFromDock(dockItemInfo);
    if (startAppType === null || startAppType === undefined) {
      homeLog.showInfo('startAppType is null or undefined');
      return true;
    }
    if (appItemInfo || startAppType === StartType.RECENT_DOCK_APP) {
      homeLog.showInfo('is startAppFromDockOrRecent');
      return true;
    }
    return false;
  }

  // ----------------------------------------------------------------------------------------------------
  // Window Animation
  // ----------------------------------------------------------------------------------------------------

  public getTargetTransitionController(sceneContainerSession: SCBSceneContainerSession,
    sceneInfo: SCBSceneInfo | undefined, isExitApp: boolean = false): SCBTransitionController {
    let bundleName = sceneInfo?.bundleName;
    let abilityName = sceneInfo?.abilityName;
    let appIndex = sceneInfo?.appIndex;
    let isPhoneCall = SCBPhoneSceneUtils.isPhoneCallScene(sceneInfo);
    // companionIconInfo未初始化时默认退出到主应用
    let startType = StartType.APP;
    if (!isPhoneCall && !CheckEmptyUtils.isEmpty(sceneContainerSession?.companionIconInfo?.startAppType)) {
      startType = sceneContainerSession?.companionIconInfo?.startAppType;
    }
    let controller = SCBTransitionManager.getInstance().findTransitionController(bundleName,
      () => {
        return PageDesktopModel.getInstance().getExitAppData(bundleName, abilityName, appIndex, startType,
          sceneContainerSession?.companionIconInfo?.cardId, sceneContainerSession?.companionIconInfo?.extraId,
          sceneContainerSession?.companionIconInfo?.shortcutId);
      });

    // 通话页面无controller时，直接注册
    if (isPhoneCall && CommonUtils.isInvalid(controller)) {
      controller = OverlayStartAnimHelper.registerPhoneCallController(bundleName, abilityName);
    }
    return controller;
  }

  public setTransitionAnimCancel(controller: SCBTransitionController,
    sceneContainerSession: SCBSceneContainerSession, reason?: string): void {
    SCBTransitionManager.getInstance()
      .setCancelCloseAppAnimateFun(this.cancelSceneContainerTransition, sceneContainerSession);
    homeLog.showWarn(`setTransitionAnimCancel reason: ${reason}`);
    if (controller) {
      controller.updateAnimSwipe = (offsetX: number, isAniToEnd: boolean = false): void =>
      this.updateTransitionOutAnimSwipe(sceneContainerSession, offsetX, isAniToEnd);
      controller.updateAnimSwipeEnd = (index: number, targetIndex: number, extraInfo?: SwiperAnimationEvent): void =>
      this.updateTransitionOutAnimSwipeEnd(sceneContainerSession, index, targetIndex, extraInfo);
    }
  }

  public sceneContainerTransitionOutInRecentDock(companionIconInfo: CompanionIconInfo, isInScreen: boolean, isAnimateStart: boolean): void {
    if (!companionIconInfo || companionIconInfo.startAppType !== StartType.RECENT_DOCK_APP || !isInScreen) {
      return;
    }
    // 如果是最近任务区启动的应用，返回桌面时需要控制桌面上同应用图标的显隐来配合动画
    let key = `${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}${companionIconInfo.bundleName}` +
      `${companionIconInfo.abilityName}${companionIconInfo.moduleName}`
    this.desktopContext.eventHub.emit(key, isAnimateStart);
  }

  private cancelSceneContainerTransition = (sceneContainerSession: SCBSceneContainerSession) => {
    homeLog.showDebug('cancelSceneContainerTransition=%{public}s',
      JSON.stringify(sceneContainerSession?.primarySession?.sceneInfo));
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.FULLSCENE &&
      CloseAppManager.getInstance().getStartAppType() === StartType.CARD) {
      return;
    }
    if (this.stateCollectionHandler?.getPanelState() === ScenePanelState.RECENT || sceneContainerSession.isFloat) {
      return;
    }
    let iconInfo = sceneContainerSession?.companionIconInfo;
    if (iconInfo?.isSameLocation) {
      SmallFolderModelManager.getInstance()
        .getSmallFolderShowModel(iconInfo?.smallFolderId ?? '').setIsFolderShow(true);
    }
    this.sceneContainerTransitionReset(sceneContainerSession);
    this.sceneContainerTransitionOutInRecentDock(sceneContainerSession.companionIconInfo, true, false);
  }

  public updateTransitionOutAnimSwipe(sceneContainerSession: SCBSceneContainerSession, offsetX: number,
    isAniToEnd: boolean): void {
    if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.HOME) {
      homeLog.showDebug('updateTransitionOutAnimSwipe not in home');
      return;
    }
    const sceneInfo: SCBSceneInfo | undefined = sceneContainerSession?.primarySession?.sceneInfo;
    let controller: SCBTransitionController = sceneContainerSession.transitionController;
    const floatActiveSession = this.floatingSessionList.getTopActiveSession();
    const floatAppBundleName: string = floatActiveSession?.getBundleName() ?? '';
    if (floatAppBundleName === sceneInfo?.bundleName) {
      homeLog.showInfo(`updateTransitionOutAnimSwipe floatAppBundleName: ${floatAppBundleName}, ` +
        `bundleName: ${sceneInfo?.bundleName}`);
      return;
    }
    if (controller?.appData.startAppType !== StartType.CARD &&
      PageDesktopModel.getInstance().isInDock(sceneInfo?.bundleName, sceneInfo?.abilityName, sceneInfo?.appIndex,
        controller?.appData.shortcutId)) {
      homeLog.showDebug('updateTransitionOutAnimSwipe is in dock');
      return;
    }
    if (controller?.appData.startAppType == StartType.RECENT_DOCK_APP) {
      homeLog.showDebug('updateTransitionOutAnimSwipe is in recent dock');
      return;
    }
    let appExitInfo = QuitAppRectViewModel.getInstance().buildAppExitInfoInExitSlide(sceneContainerSession);
    let iconRect = appExitInfo?.iconRect;
    if (!iconRect) {
      homeLog.showInfo('updateTransitionOutAnimSwipe icon not found, bundleName=%{public}s', sceneInfo?.bundleName);
      SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      return;
    }
    homeLog.showDebug('updateTransitionOutAnimSwipe, bundleName=%{public}s', sceneInfo?.bundleName);
    sceneContainerSession.addTransitionCount();
    SCBTransitionManager.getInstance().addStartExitAnimationCount('updateTransitionOutAnimSwipe');
    let animationNum = sceneContainerSession.getTransitionCount();
    const blurTransitionCount = this.panelMgr.addBlurTransitionCountAndReturnValue();
    this.uiContext?.animateTo({
      curve: isAniToEnd ? curves.interpolatingSpring(-1, 1, 632, 50) : curves.cubicBezierCurve(0.19, 0.96, 0.46, 1),
      duration: isAniToEnd ? 300 : 50,
      onFinish: () => {
        if (isAniToEnd) {
          sceneContainerSession.onTransitionSwiper(0, 'updateTransitionOutAnimSwipeFinish');
        }
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount('updateTransitionOutAnimSwipe end');
        homeLog.showDebug('updateTransitionOutAnimSwipe finish, animationNum=%{public}i', animationNum);
        if (sceneContainerSession.transitionOutFinishIfNeed(animationNum) ||
          sceneContainerSession.getTransitionCount() === 0) {
          homeLog.showInfo('updateTransitionOutAnimSwipe animation finish, animationNum when start=%{public}i, current Num=%{public}i',
            animationNum, sceneContainerSession.getTransitionCount());
          this.exitSceneWithRotationRecover(sceneContainerSession);
          this.inactiveController(controller);
          this.sceneContainerTransitionOutInRecentDock(sceneContainerSession.companionIconInfo,
            appExitInfo.isInScreen, false);
          SCBTransitionManager.getInstance().isExitSwipeIng = false;
        }
        this.panelMgr.onBlurTransitionFinish(blurTransitionCount);
      }
    }, () => {
      if (FolderData.getInstance().isFolderOpen()) {
        sceneContainerSession.onTransitionActiveToRect(iconRect);
        if (iconRect) {
          this.panelMgr.onBlurTransitionInactive();
        }
      } else {
        sceneContainerSession.onTransitionSwiper(offsetX, 'updateTransitionOutAnimSwipe');
      }
    })
    if (!iconRect && sOutSideWindowMgr.isShowGlobalSearch()) {
      animateTo({
        duration: 300,
        curve: Curve.Linear,
        onFinish: () => {
          console.info('play end')
        }
      }, () => {
        this.panelMgr.onBlurTransitionInactive();
      })
    }
  }

  public updateTransitionOutAnimSwipeEnd(sceneContainerSession: SCBSceneContainerSession, index: number,
    targetIndex: number, extraInfo?: SwiperAnimationEvent): void {
    if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.HOME) {
      homeLog.showDebug('updateTransitionOutAnimSwipeEnd not in home');
      return;
    }
    homeLog.showDebug('updateTransitionOutAnimSwipeEnd');
    this.index = index;
    this.targetIndex = targetIndex;
    if (index !== targetIndex) {
      this.cancelSceneContainerTransition(sceneContainerSession);
      homeLog.showInfo(`updateTransitionOutAnimSwipeEnd index=${index}, targetIndex=${targetIndex}`);
      return;
    }
    this.swipeEndSceneContainerSession = sceneContainerSession;
    if (this.startAppFromDockOrRecent(sceneContainerSession)) {
      homeLog.showInfo('startAppFromDockOrRecent');
      return;
    }
    this.startReboundAnimate(extraInfo);
  }

  public inactiveController(controller: SCBTransitionController) {
    if (controller) {
      controller.onInactive(TAG, 'inactiveController');
    } else {
      this.inactiveCurrentController()
    }
  }

  private inactiveCurrentController() {
    homeLog.showInfo('onInactive CurrentController');
    SCBTransitionManager.getInstance().getCurrentTransitionController()?.onInactive(TAG, 'inactiveCurrentController');
  }

  private startReboundAnimate(extraInfo?: SwiperAnimationEvent): void {
    if (this.swipeEndSceneContainerSession === undefined) {
      return;
    }
    let iconRectInfo: RectInfo | undefined =
      this.getIconFinalRectInfo(this.swipeEndSceneContainerSession, this.index, this.targetIndex, extraInfo);
    if (!iconRectInfo) {
      return;
    }
    homeLog.showDebug(`updateTransitionOutAnimSwipeEnd startReboundAnimate ${iconRectInfo}`);
    let controller = this.swipeEndSceneContainerSession.transitionController;
    this.swipeEndSceneContainerSession.addTransitionCount();
    SCBTransitionManager.getInstance().addStartExitAnimationCount('startReboundAnimate');
    let animationNum = this.swipeEndSceneContainerSession.getTransitionCount();
    const blurTransitionCount = this.panelMgr.addBlurTransitionCountAndReturnValue();
    animateTo({
      curve: curves.interpolatingSpring(-1, 1, 328, 34),
      onFinish: () => {
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount('startReboundAnimate end');
        homeLog.showDebug('updateTransitionOutAnimSwipeEnd finish, %{public}i', animationNum);
        if (this.swipeEndSceneContainerSession?.transitionOutFinishIfNeed(animationNum) ||
          this.swipeEndSceneContainerSession?.getTransitionCount() === 0) {
          homeLog.showInfo('transitionOutFinish in SwipeEnd finish, animationNum when start=%{public}i, current Num=%{public}i',
            animationNum, this.swipeEndSceneContainerSession?.getTransitionCount());
          this.exitSceneWithRotationRecover(this.swipeEndSceneContainerSession);
          this.inactiveController(controller);
          this.sceneContainerTransitionOutInRecentDock(this.swipeEndSceneContainerSession?.companionIconInfo, true, false);
        }
        this.panelMgr.onBlurTransitionFinish(blurTransitionCount);
      }
    }, () => {
      this.swipeEndSceneContainerSession?.onTransitionActiveToRect(iconRectInfo);
      this.panelMgr.onBlurTransitionInactive();
    })
  }

  private getIconFinalRectInfo(sceneContainerSession: SCBSceneContainerSession, index: number, targetIndex: number,
    extraInfo?: SwiperAnimationEvent): RectInfo | undefined {
    homeLog.showInfo(`getIconFinalRectInfo index=${index}, targetIndex=${targetIndex}`);
    if (CloseAppManager.getInstance().isAppIconInOpenFolder(sceneContainerSession?.companionIconInfo?.iconId)) {
      let iconRectInfo: RectInfo | undefined = undefined;
      const appIconPosition = CloseAppManager.getInstance().getOpenFolderAppIconInfo();
      const pageOffset = (index - targetIndex) * px2vp(this.screenProperty.width);
      if (appIconPosition == null) {
        homeLog.showWarn('getIconFinalRectInfo OpenFolder return null');
        return undefined;
      }
      iconRectInfo = new RectInfo();
      iconRectInfo.left = appIconPosition.appIconPositionX + pageOffset;
      iconRectInfo.top = appIconPosition.appIconPositionY;
      iconRectInfo.right = appIconPosition.appIconPositionX + appIconPosition.appIconSize + pageOffset;
      iconRectInfo.bottom = appIconPosition.appIconPositionY + appIconPosition.appIconHeight;
      return iconRectInfo;
    } else {
      return this.getRectInfoInDesktop(sceneContainerSession, index - targetIndex, extraInfo);
    }
  }

  private getRectInfoInDesktop(sceneContainerSession: SCBSceneContainerSession,
    pageGap: number, extraInfo?: SwiperAnimationEvent): RectInfo | undefined {
    let iconRectInfo = ItemUtils.getRectById(sceneContainerSession.transitionController?.appData?.appIconId);
    if (iconRectInfo && iconRectInfo.left !== 0 && iconRectInfo.top !== 0) {
      const pageOffset = pageGap * px2vp(this.screenProperty.width);
      iconRectInfo.left = iconRectInfo.left + pageOffset - (extraInfo?.currentOffset ?? 0);
      iconRectInfo.right = iconRectInfo.right + pageOffset - (extraInfo?.currentOffset ?? 0);
      return iconRectInfo;
    } else {
      homeLog.showWarn('getIconFinalRectInfo return null');
      return undefined;
    }
  }

  // 翻页找位后companionIconInfo发生变化，需要更新controller
  public updateControllerByCompanionIconInfo(oldController: SCBTransitionController,
    companionIconInfo: CompanionIconInfo, sceneContainerSession: SCBSceneContainerSession): SCBTransitionController {
    let controller: SCBTransitionController = oldController;
    if (oldController?.appData?.startAppType !== companionIconInfo.startAppType &&
      oldController?.appData?.appIconId !== companionIconInfo.iconId) {
      controller = SCBTransitionManager.getInstance().findTransitionControllerWithIconId(companionIconInfo.iconId,
        FolderData.getInstance().isFolderOpen());
      sceneContainerSession.updateTransitionController(controller);
      this.setTransitionAnimCancel(controller, sceneContainerSession, 'updateControllerByCompanionIconInfo');
      sceneContainerSession.updateCompanionIconInfo(controller);
    }
    return controller;
  }

  public printAppExitRectInfo(appExitInfo?: AppExitLocationInfo) {
    if (appExitInfo && appExitInfo?.iconRect) {
      const rect = appExitInfo.iconRect;
      homeLog.showInfo('AppExitRectInfo VP top: %{public}d, left: %{public}d, width: %{public}d, ' +
        'type: %{public}s, pageIndex: %{public}d, isInScreen: %{public}s',
        rect.top, rect.left, rect.width, appExitInfo.type, appExitInfo.pageIndex, appExitInfo.isInScreen);
    }
  }

  public isExitToSmallFolder(companionIconInfo: CompanionIconInfo): boolean {
    return !CheckEmptyUtils.isEmpty(companionIconInfo?.smallFolderId);
  }

  /**
   * 无法获取到图标资源，退出到中心
   */
  public checkIsTransitionOutCenter(iconRect: RectInfo | null, companionIconInfo: CompanionIconInfo,
    controller: SCBTransitionController): RectInfo | null {
    if (iconRect && companionIconInfo && companionIconInfo.startAppType !== StartType.CARD) {
      let isDynamicIcon = AppIconModel.getInstance().isDynamicIconByBundleName(companionIconInfo.bundleName);
      if (isDynamicIcon) {
        return iconRect;
      }
      let combIcon: image.PixelMap = IconResourceManager.getInstance().getCachedCombIconSync(
        companionIconInfo.bundleName,
        companionIconInfo.moduleName,
        companionIconInfo.abilityName
      );
      if (!combIcon) {
        homeLog.showWarn('sceneContainerTransitionOut comIcon is null, transition out center');
        iconRect = null;
        this.inactiveController(controller);
      }
    }
    return iconRect;
  }

  public getTransitionOutCurve(limit: boolean | null): Curve | ICurve {
    // isNewStyle为false时，弹簧自然振动周期按照匹配设备来隔离
    let response: number = 0.42;
    // 设备场景退出动画弹簧曲线response参数区分不同设备形态
    if (this.isNewStyle) {
      response = StartAndExitUtil.getResponse(StartAndExitResponse.EXIT);
    }
    // 弹簧曲线阻尼系数
    let dampingFraction: number = 1;
    if (limit) {
      dampingFraction = 0.825;
    }
    return curves.springMotion(response, dampingFraction, 0);
  }

  public isInEmergencyOrThermalSafeMode(): boolean {
    return DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode();
  }

  public showSnapShotOnExpand(containerSession: SCBSceneContainerSession): void {
    if (!DeviceHelper.isThreeFoldProduct() || CheckEmptyUtils.isEmpty(containerSession)) {
      return;
    }
    // showSnapShotOnExpand is before onScreenPropertyChange, need to use current fold state as last state
    // and recalculate a new triple fold state
    let lastTripleFoldStatus: SCBTripleFoldState = SCBTriFoldManager.getInstance().getCurTriFoldState();
    let curTripleFoldState: SCBTripleFoldState = SCBTriFoldManager.getInstance().recalculateTriFoldState();
    homeLog.showInfo(`foldexpand windows animation, lastTripleFoldStatus =  ${lastTripleFoldStatus},` +
      `curTripleFoldState = ${curTripleFoldState}`);
    let foldExpandStateChange : SCBTripleStateChange = TripleFoldExpandAnimUtils.getTripleStateChange(curTripleFoldState, lastTripleFoldStatus);
    this.stateCollectionHandler?.setFoldExpandStateChange(foldExpandStateChange);
    if (this.stateCollectionHandler?.getPanelState() !== ScenePanelState.FULLSCENE || containerSession.isSplit) {
      return;
    }
    if (foldExpandStateChange === SCBTripleStateChange.INVALID ||
      foldExpandStateChange === SCBTripleStateChange.F_TO_M ||
      foldExpandStateChange === SCBTripleStateChange.M_TO_F ||
      foldExpandStateChange === SCBTripleStateChange.G_TO_F ||
      foldExpandStateChange === SCBTripleStateChange.F_TO_G) {
      homeLog.showInfo(`showSnapShotOnExpand not need snapshot`);
      this.stateCollectionHandler?.setNeedFoldExpandSnapShot(false)
      return;
    }
    if (containerSession.primarySession && containerSession.isActive) {
      this.stateCollectionHandler?.setFoldExpandSnapShotSessionId(containerSession.primarySession.session.persistentId);
      let isNeedFoldExpandSnapShot: boolean = this.stateCollectionHandler?.getNeedFoldExpandSnapShot();
      homeLog.showInfo(`showSnapShotOnExpand isNeedFoldExpandSnapShot: ${isNeedFoldExpandSnapShot}`);
      if (isNeedFoldExpandSnapShot) {
        return;
      }
      this.stateCollectionHandler?.setNeedFoldExpandSnapShot(true);
    }
  }

  private tripleAnimStart(animType: string): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    performanceMonitor.begin(animType, performanceMonitor.ActionType.LAST_UP);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
    let foldAnimNum: number = this.stateCollectionHandler.getFoldAnimNum();
    foldAnimNum++;
    this.stateCollectionHandler.setFoldAnimNum(foldAnimNum);
  }

  public pcAppExitWithFold(screenProperty: SCBScreenProperty): void {
    let topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession?.primarySession && topContainerSession.isPcAppExit()) {
      if (DeviceHelper.isThreeFoldProduct() &&
        SCBTriFoldManager.getInstance().getCurTriFoldState() === SCBTripleFoldState.M) {
        // M态保持G态时位置大小需做偏移计算
        topContainerSession.needRenderTranslate.setTranslateXWithDfx(px2vp(screenProperty.width -
        topContainerSession.screenProperty.width), TAG, 'pcAppExitWithFold', topContainerSession.getName());
      }
      topContainerSession.screenProperty.copy(screenProperty);
      setTimeout(() => {
        this.minimizeAllScene();
      }, 300)
    }
  }

  private tripleAnimFinish(animType: string): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    let foldAnimNum: number = this.stateCollectionHandler.getFoldAnimNum();
    foldAnimNum--;
    this.stateCollectionHandler.setFoldAnimNum(foldAnimNum);
    homeLog.showInfo(`tripleAnimFinish foldAnimNum: ${foldAnimNum}`);
    if (foldAnimNum === 0) {
      if (SCBTransitionManager.getInstance()
        .getStartExitAnimationCount() === 0) {
        this.panelMgr.getBackgroundBlurSession().setBgBlurColor(SCBConstants.START_SCENE_BG_COLOR);
      }
      this.stateCollectionHandler.setNeedFoldExpandSnapShot(false);
      this.stateCollectionHandler.setFoldExpandSnapShotSessionId(-1);
    }
    performanceMonitor.end(animType);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
  }

  private tripleAnimTransStart(screenRotation: number, transFactor: number): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    switch (screenRotation) {
      case RotationConstants.ROTATION_0:
        this.stateCollectionHandler.getViewParam().recentTransX = transFactor * px2vp(this.screenProperty.width);
        break;
      case RotationConstants.ROTATION_90:
        this.stateCollectionHandler.getViewParam().recentTransY = transFactor * px2vp(this.screenProperty.height);
        break;
      case RotationConstants.ROTATION_180:
        this.stateCollectionHandler.getViewParam().recentTransX = -1 * transFactor * px2vp(this.screenProperty.width);
        break;
      case RotationConstants.ROTATION_270:
        this.stateCollectionHandler.getViewParam().recentTransY = -1 * transFactor * px2vp(this.screenProperty.height);
        break;
      default:
        break;
    }
  }

  private tripleAnimTransEnd(screenRotation: number): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    if (screenRotation === RotationConstants.ROTATION_0 || screenRotation === RotationConstants.ROTATION_180) {
      this.stateCollectionHandler.getViewParam().recentTransX = 0;
    }
    if (screenRotation === RotationConstants.ROTATION_90 || screenRotation === RotationConstants.ROTATION_270) {
      this.stateCollectionHandler.getViewParam().recentTransY = 0;
    }
    this.folderSnapshotSize = { width: px2vp(this.screenProperty.width), height: px2vp(this.screenProperty.height) };
  }

  /**
   * XT手机，窗口开合时，触发窗口开合动效
   * @param screenRotation
   * @param stateChange
   */
  public tripleFoldProductAnimation(screenRotation: number, stateChange: SCBTripleStateChange): void {
    if (!this.stateCollectionHandler) {
      return;
    }
    homeLog.showInfo(`start animation by state change, stateChange = ${stateChange}, rotation = ${screenRotation}`);
    let animType: string = TripleFoldExpandAnimUtils.getScenePanelAnimType(stateChange);
    let animFactor: number = TripleFoldExpandAnimUtils.getScenePanelAnimFactor(stateChange);
    this.tripleAnimStart(animType);
    this.tripleAnimTransStart(screenRotation, animFactor);
    animateTo({
      curve: TripleFoldExpandAnimUtils.getScenePanelTransCurve(stateChange),
      onFinish: () => {
        this.tripleAnimFinish(animType);
      }
    }, () => {
      this.tripleAnimTransEnd(screenRotation);
    })
    animateTo({
      curve: TripleFoldExpandAnimUtils.getScenePanelAlphaCurve(stateChange),
    }, () => {
      if (this.stateCollectionHandler) {
        this.stateCollectionHandler.getViewParam().recentAlpha = 1;
      }
    })
  }

  private popContainerSession(persistentId: number, sceneInfo: SCBSceneInfo,
    opts: SCBTransferSceneOpts): SCBSceneSession | undefined {
    let index: number = INVALID_INDEX;
    if (persistentId && persistentId > INVALID_PERSISTENT_ID) {
      index = this.containerSessionList.findIndexByPersistentId(persistentId);
    } else if (sceneInfo) {
      index = this.containerSessionList.findIndexBySceneInfo(sceneInfo);
    }

    if (index < 0) {
      homeLog.showWarn('popContainerSession, not found!');
      return undefined;
    }
    const containerSession: SCBSceneContainerSession = this.containerSessionList[index];
    const scbSceneSession = containerSession.findSceneSessionByPersistentId(persistentId) ??
      containerSession.findSceneSessionBySceneInfo(sceneInfo);
    if (scbSceneSession == null) {
      homeLog.showWarn('popContainerSession, found scbSceneSession is empty');
      return undefined;
    }
    this.closePiP(scbSceneSession, scbSceneSession.sceneInfo);
    // 含两个应用的分屏，则退出分屏，剩余应用全屏展示
    if (containerSession.isSplitView()) {
      this.handleFullSplitExitByPop(containerSession, scbSceneSession as SCBSceneSession,
        opts?.needBackground ?? true);
      this.exitSceneWithRotationRecover();
    } else {
      this.handleContainerSessionExitByPop(containerSession, scbSceneSession, index,
        opts?.needBackground ?? true, opts);
      if (!(opts?.params?.[MINIMIZE_ABILITY_BEFORE_POP])) { // pop out without animation
        this.exitSceneWithRotationRecover();
      }
    }
    return scbSceneSession ?? undefined;
  }

  private popFloatingSession(persistentId: number | undefined, sceneInfo: SCBSceneInfo | undefined,
      needBackground: boolean = true): SCBSceneSession | undefined {
    let floatingContainer: SCBSceneContainerSession | null = this.getContainerSessionByPersistentIdOrContainerId(persistentId);
    let index: number = INVALID_INDEX;
    if (persistentId && persistentId > INVALID_PERSISTENT_ID) {
      index = this.floatingSessionList.findIndex((floatSession: SCBSceneContainerSession) => {
        return floatSession.primarySession?.session?.persistentId === persistentId;
      });
    } else if (sceneInfo) {
      index = this.floatingSessionList.findIndex((floatSession: SCBSceneContainerSession) => {
        return floatSession.primarySession?.sceneInfo?.equalTo(sceneInfo);
      });
    }

    if (index < 0) {
      let sideEdgeSession: SCBSceneContainerSession | undefined;
      if (sideEdgeSession?.primarySession) {
        this.closePiP(sideEdgeSession.primarySession, sideEdgeSession.primarySession.sceneInfo);
        sideEdgeSession.primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
        return sideEdgeSession.primarySession;
      }
      homeLog.showWarn('popFloatingSession, not found!');
      return undefined;
    }
    const containerSession: SCBSceneContainerSession = this.floatingSessionList[index];
    if (CheckEmptyUtils.isEmpty(containerSession.primarySession)) {
      homeLog.showWarn('popFloatingSession, found scbSceneSession is empty');
      return undefined;
    }
    const scbSceneSession: SCBSceneSession = containerSession.primarySession as SCBSceneSession;
    // 先退出浮窗，再移屏
    scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    this.dataCollectionHandler?.getAppFloating()?.freezeBlur(containerSession);
    this.dataCollectionHandler?.getAppFloating()?.resizeSceneContainer(containerSession);
    scbSceneSession.updateCurRectForMultiWindowToFull(containerSession.screenProperty);
    this.dataCollectionHandler?.getAppFloating()?.floatingSceneToFullAnimation(containerSession, this.screenProperty);
    this.closePiP(scbSceneSession, scbSceneSession.sceneInfo);

    if (scbSceneSession.isActive) {
      this.panelMgr.disableBlurComponent('popFloatingSession');
      if (needBackground) {
        containerSession.requestBackground(true);
      }
    }
    this.panelMgr.removeFloatContainerSessionByIndex(index);
    this.exitSceneWithRotationRecover();
    return scbSceneSession;
  }

  private handleFullSplitExitByPop(containerSession: SCBSceneContainerSession,
    scbSceneSession: SCBSceneSession, needBackground: boolean): void {
    containerSession.isSplit = false;
    if (scbSceneSession.isActive) {
      this.panelMgr.disableBlurComponent('handleFullSplitExitByPop');
      if (needBackground) {
        scbSceneSession?.requestSessionBackground(true);
      }
    }
    const exitContainerIndex: number =
      this.containerSessionList.findIndexByPersistentId(scbSceneSession.session.persistentId as number);
    // 应用迁移需要将应用在主屏的容器会话清除
    if (exitContainerIndex >= 0) {
      this.panelMgr.removeContainerSessionByIndex(exitContainerIndex);
    }
  }

  private handleContainerSessionExitByPop(containerSession: SCBSceneContainerSession,
    scbSceneSession: SCBSceneSession, index: number, needBackground: boolean, opts: SCBTransferSceneOpts): void {
    if (containerSession.isOneStepSplit()) {
      this.oneStepSplitExit(containerSession, false);
    }
    if (scbSceneSession.isActive) {
      ViewManagerPolicy.showView(ViewType.DESKTOP);
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      this.panelMgr.disableBlurComponent('handleContainerSessionExitByPop');
      if (needBackground) {
        containerSession.requestBackground(true);
      }
    }
    if (opts?.params?.[MINIMIZE_ABILITY_BEFORE_POP]) { // pop out with animation
      const sceneInfo = scbSceneSession.sceneInfo;
      let adapterSceneInfo: SCBSceneInfo = SceneInfoAdapterUtil.getAdapterSceneInfo(sceneInfo.bundleName,
        sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.appIndex);
      let controller = this.getTargetTransitionController(containerSession, adapterSceneInfo, true);
      this.panelAnimator.sceneContainerPopOut(scbSceneSession, containerSession, controller, () => {
        winLog.showInfo(`handleContainerSessionExitByPop delete container id: ${containerSession?.containerId}`);
        this.panelMgr.removeSceneContainerSession(containerSession);
        this.containerFillingWhenTerminate(containerSession, true);
        this.exitSceneWithRotationRecover();
        if (opts?.transferFinishedCallback) {
          opts?.transferFinishedCallback(scbSceneSession);
        }
      });
      return;
    }
    this.panelMgr.removeContainerSessionByIndex(index);
    recentLog.info(`handleContainerSessionExitByPop delete container index: ${index}`);
    this.containerFillingWhenTerminate(containerSession, true);
    if (opts?.transferFinishedCallback) {
      opts?.transferFinishedCallback(scbSceneSession);
    }
  }

  /**
   * Proceed AI split switch
   *
   * @param reason is screen property change's reason
   * @param containerSession is current SCBSceneContainerSession
   * @param foldExpandStateChange is type of state change
   * @return
   */
  public AiSplitSwitch(reason: SCBPropertyChangeReason, containerSession: SCBSceneContainerSession | null,
    foldExpandStateChange: SCBTripleStateChange): void {
    homeLog.showInfo(`[ScenePanel-AiSplitSwitch] screen state change reason: ${reason}` +
      `, foldExpandStateChange: ${foldExpandStateChange}`);
    if ((DeviceHelper.isThreeFoldProduct() &&
      (foldExpandStateChange === SCBTripleStateChange.M_TO_F || foldExpandStateChange ===
      SCBTripleStateChange.G_TO_F)) ||
      (DeviceHelper.isLargeInFoldProduct() && reason === SCBPropertyChangeReason.EXPAND_TO_FOLD)) {
      // SCBSceneWindowAiSplitSwitchUtils.getInstance().deleteSplitIntent();
      SCBSceneWindowAiSplitSwitchUtils.getInstance().endAiSplitSwitchHandler();
      return;
    }
    if (containerSession === null) {
      homeLog.showWarn('[ScenePanel-AiSplitSwitch] cannot find top active container session');
      return;
    }
    let sceneSession: SCBSceneSession | null = containerSession.primarySession;
    if (sceneSession === null) {
      homeLog.showWarn('[ScenePanel-AiSplitSwitch] cannot find primary scene session');
      return;
    }
    let currentWindowMode: SCBSceneMode = sceneSession.sceneInfo.windowMode;
    homeLog.showInfo(`[ScenePanel-AiSplitSwitch] get current windowMode ${currentWindowMode}`);
    if (currentWindowMode === SCBSceneMode.FULLSCREEN && ((DeviceHelper.isThreeFoldProduct() &&
      (foldExpandStateChange === SCBTripleStateChange.F_TO_M || foldExpandStateChange ===
      SCBTripleStateChange.F_TO_G)) ||
      (DeviceHelper.isLargeInFoldProduct() && reason === SCBPropertyChangeReason.FOLD_TO_EXPAND))) {
      SCBSceneWindowAiSplitSwitchUtils.getInstance()
        .startAiSplitSwitchHandler(sceneSession.sceneInfo, sceneSession.isSupportSplitMode());
    }
  }

  /**
   * Split screen from AI bar
   *
   * @param primary App's sceneInfo
   * @param secondary App's sceneInfo
   * @param fromContainerSession is last SCBSceneContainerSession
   * @return
   */
  public viewSplitScreen(primaryAppSceneInfo: SCBSceneInfo, secondaryAppSceneInfo: SCBSceneInfo,
    topContainerSession: SCBSceneContainerSession | null, switchType: SwitchType): void {
    let primaryBundleName: string = primaryAppSceneInfo.bundleName;
    let secondaryBundleName: string = secondaryAppSceneInfo.bundleName;
    homeLog.showInfo(`[SCBSplit] bundleName: ${primaryBundleName}, ${secondaryBundleName}; ` +
      `switchType: ${switchType}`);
    let aiSplitReason: AiSplitReason = SCBSceneWindowAiSplitSwitchUtils.getInstance().getAiSplitReason();
    const currentPanelState = this.stateCollectionHandler?.getPanelState();
    if (topContainerSession === null || currentPanelState !== ScenePanelState.FULLSCENE) {
      homeLog.showWarn('[SCBSplit] non-full-screen application scenarios do not support split-screen.');
      return;
    }
    let topSceneSession: SCBSceneSession | null = topContainerSession.primarySession;
    if (topSceneSession === null) {
      homeLog.showWarn('[SCBSplit] top scene session is null');
      return;
    }
    let topBundleName: string = topSceneSession.sceneInfo.bundleName;
    let topWindowMode: SCBSceneMode = topSceneSession.sceneInfo.windowMode;
    SCBKeyboardManager.getInstance().requestHideKeyboard(topSceneSession);
    if (switchType === SwitchType.FREQUENT_SWITCH) {
      // 频繁快切场景，新拉起分屏窗口布局右侧
      homeLog.showInfo('[SCBSplit] split screen as frequent type');
      SCBSceneWindowAiSplitSwitchUtils.getInstance().setSwitchType(SwitchType.INVALID);
      if (topBundleName !== primaryBundleName || topWindowMode !== SCBSceneMode.FULLSCREEN) {
        return;
      }
      secondaryAppSceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
      let secondarySceneSession: SCBSceneSession | null = this.requestSceneSession(secondaryAppSceneInfo);
      if (secondarySceneSession === null) {
        homeLog.showWarn('[SCBSplit] toSceneSession is null');
        return;
      }
      this.pairSplitIfInOneApp(topContainerSession, null, secondarySceneSession, secondaryAppSceneInfo);
    } else if (switchType === SwitchType.NATURAL_SWITCH) {
      // 应用跳转自然拉起场景，新拉起分屏窗口布局左侧
      homeLog.showInfo('[SCBSplit] split screen as natural type');
      SCBSceneWindowAiSplitSwitchUtils.getInstance().setSwitchType(SwitchType.INVALID);
      if (topBundleName !== secondaryBundleName || topWindowMode !== SCBSceneMode.FULLSCREEN) {
        return;
      }
      primaryAppSceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
      let primarySceneSession: SCBSceneSession | null = this.requestSceneSession(primaryAppSceneInfo);
      if (primarySceneSession === null) {
        homeLog.showWarn('[SCBSplit] toSceneSession is null');
        return;
      }
      this.pairSplitIfInOneApp(topContainerSession, null, primarySceneSession, primaryAppSceneInfo);
    } else {
      homeLog.showWarn('[SCBSplit] invalid switch type');
    }
    SCBSceneWindowAiSplitSwitchUtils.getInstance().setSwitchType(SwitchType.INVALID);
  }

  /**
   * Set intent of spliting window
   *
   * @param primary App's sceneInfo
   * @param secondary App's sceneInfo
   * @return
   */
  public setSplitIntent(primaryAppSceneInfo: SCBSceneInfo, secondaryAppSceneInfo: SCBSceneInfo): void {
    if (DeviceHelper.isEmulator()) {
      return;
    }
    if (!SCBSceneWindowAiSplitSwitchUtils.getInstance().isTargetScene()) {
      return;
    }
    // let viewSplitScreen: insightIntent.InsightIntent = this.getIntent(primaryAppSceneInfo, secondaryAppSceneInfo);
    let viewSplitScreen: ESObject = this.getIntent(primaryAppSceneInfo, secondaryAppSceneInfo);
    // SCBSceneWindowAiSplitSwitchUtils.getInstance().processShareIntent(viewSplitScreen);
    let context: common.ServiceExtensionContext = GlobalContext.getContext() as common.ServiceExtensionContext;
    let primaryAppBundleName: string = primaryAppSceneInfo.bundleName;
    let secondaryAppBundleName: string = secondaryAppSceneInfo.bundleName;
    let aiSplitReason: AiSplitReason = SCBSceneWindowAiSplitSwitchUtils.getInstance().getAiSplitReason();
    SCBSceneWindowAiSplitSwitchUtils.getInstance().setIsSharingIntent(true);
    SCBSceneWindowAiSplitSwitchUtils.getInstance().setRateLimitLock(false);
  }

  private getIntent(primaryAppSceneInfo: SCBSceneInfo, secondaryAppSceneInfo: SCBSceneInfo):
    // insightIntent.InsightIntent {
    ESObject {
    let primaryAppBundleName: string = primaryAppSceneInfo.bundleName;
    let primaryAppModuleName: string = primaryAppSceneInfo.moduleName;
    let primaryAppAbilityName: string = primaryAppSceneInfo.abilityName;
    let secondaryAppBundleName: string = secondaryAppSceneInfo.bundleName;
    let secondaryAppModuleName: string = secondaryAppSceneInfo.moduleName;
    let secondaryAppAbilityName: string = secondaryAppSceneInfo.abilityName;
    let aiSplitReason: AiSplitReason = SCBSceneWindowAiSplitSwitchUtils.getInstance().getAiSplitReason();
    let reportData: string = `reason: ${aiSplitReason}; AppList: ${primaryAppBundleName}, ${secondaryAppBundleName}`;
    let title = GlobalContext.getContext().resourceManager.getStringSync($r('app.string.Ai_Split_Title').id);
    homeLog.showInfo(`[getIntent] start set split intent: ${primaryAppBundleName} and ${secondaryAppBundleName}`);
    let executeIntent: Object = Object({
      intentName: 'ViewSplitScreen',
      bundleName: 'com.ohos.sceneboard',
      moduleName: '',
      abilityName: '',
      executeMode: 'background',
      intentParam: Object({
        appList: [
          Object({
            'bundleName': `${primaryAppBundleName}`,
            'moduleName': `${primaryAppModuleName}`,
            'abilityName': `${primaryAppAbilityName}`
          }),
          Object({
            'bundleName': `${secondaryAppBundleName}`,
            'moduleName': `${secondaryAppModuleName}`,
            'abilityName': `${secondaryAppAbilityName}`
          })
        ]
      })
    });
    let executeIntentStr: string = JSON.stringify(executeIntent);
    // let viewSplitScreen: insightIntent.InsightIntent = {
    let viewSplitScreen: ESObject = {
      intentName: 'AiBarEventTrigger',
      intentVersion: '1.0.1',
      identifier: '52dac3b0-6520-4974-81e5-25f0879449b5',
      intentActionInfo: {
        actionMode: 'EXPECTED',
      // },
      } as ESObject,
      intentEntityInfo: {
        entityName: 'AiBarEvent',
        entityId: primaryAppBundleName + '_' + secondaryAppBundleName,
        eventType: 'EnterScene',
        sceneId: '000202508010003',
        displayText: title,
        iconList:
        [
          {
            iconType: 'AppIcon',
            bundleName: primaryAppBundleName
          },
          {
            iconType: 'AppIcon',
            bundleName: secondaryAppBundleName
          }
        // ],
        ] as ESObject,
        updateTime: Date.now(),
        cpReportData: reportData,
        link: {
          linkType: 'ExecuteIntent',
          executeIntent: executeIntentStr
        // }
        } as ESObject
      // }
      } as ESObject
    }
    return viewSplitScreen;
  }

  private naturalAiSplit(fromSession: SCBSceneContainerSession, toSession: SCBSceneContainerSession): void {
    if (SCBSceneWindowAiSplitSwitchUtils.getInstance().isTargetScene()) {
      homeLog.showInfo('[SCBSplit] start split-naturally scene');
      let fromSceneSession: SCBSceneSession | null = fromSession.primarySession;
      let toSceneSession: SCBSceneSession | null = toSession.primarySession;
      if (fromSceneSession === null || toSceneSession === null) {
        homeLog.showWarn('[SCBSplit] scene session is null');
        return;
      }
      if (!(fromSceneSession.isSupportSplitMode() && toSceneSession.isSupportSplitMode())) {
        homeLog.showWarn('[SCBSplit] scene session cannot split');
        return;
      }
      let fromSceneInfo: SCBSceneInfo = fromSceneSession.sceneInfo;
      let toSceneInfo: SCBSceneInfo = toSceneSession.sceneInfo;
      if (fromSceneInfo.bundleName === toSceneInfo.bundleName) {
        homeLog.showWarn('[SCBSplit] same app, cannot set natural split intent');
        return;
      }
      if (SCBSceneWindowAiSplitSwitchUtils.getInstance().isNaturalScene(fromSceneInfo, toSceneInfo)) {
        SCBSceneWindowAiSplitSwitchUtils.getInstance().setSwitchType(SwitchType.NATURAL_SWITCH);
        SCBSceneWindowAiSplitSwitchUtils.getInstance().startNaturalSwitchScene(fromSceneInfo, toSceneInfo);
        SCBSceneWindowAiSplitSwitchUtils.getInstance().setRateLimitLock(true);
      }
    }
  }

  /**
   * start scene from other to floating
   * @param sceneInfo target scene info
   */
  public onStartSceneFromOtherToFloating(sceneInfo: SCBSceneInfo): void {
    homeLog.showInfo('onStartSceneFromOtherToFloating: ' + sceneInfo?.toJsonString());
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(sceneInfo, StartInterceptions.FROM_NOTIFICATION, this.screenId, this.panelId)) {
      return;
    }
    // get or create session and container session
    let sceneSession = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      homeLog.showError('Failed to request scene session!');
      return;
    }
    sceneSession.sceneInfo.want = sceneInfo.want;
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.sceneInfo.persistentId);
    if (sceneContainerSession === null) {
      sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
    }
    if (sceneContainerSession.isActive) {
      homeLog.showInfo('onStartSceneFromOtherToFloating target session already foreground, ignored');
      return;
    }

    // before scene appear
    this.exitRecentIfNeeded(sceneContainerSession);
    if (sceneContainerSession.needRenderRotate.angle !== this.screenProperty.rotation) {
      sceneContainerSession?.updateContainerSessionWithRotation(this.screenProperty,
        SCBContainerRotationReason.SCREEN_ROTATION);
    }

    // temporary forbiding start mid scene app from dock
    let panelState = this.stateCollectionHandler?.getPanelState() ?? ScenePanelState.HOME;

    if (sceneContainerSession && !this.isSceneContainerSessionNotShowRecent(sceneContainerSession)) {
      homeLog.showWarn('[SCBMain]onStartSceneFromOtherToFloating interrupt to enterFloat');
      return;
    }

    // request activation to start and attach on tree
    sceneContainerSession.requestActivation(sceneSession.isNewWant);
  }

  /**
   * check whether need to exit recent state
   * @param sceneContainerSession following session
   */
  public exitRecentIfNeeded(sceneContainerSession: SCBSceneContainerSession): void {
    const currenPanelState = this.stateCollectionHandler?.getPanelState();
    if (currenPanelState !==  ScenePanelState.RECENT) {
      homeLog.showInfo('exitRecentIfNeed ignore, current not in recent');
      return;
    }
    this.exitRecent();
    ContainerBuilder.resetAllContainerPreBuildStage(this.containerSessionList);
    this.containerSessionList.forEach((item) => {
      item.isDisappearing = false;
      item.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'exitRecentIfNeeded');
    })
    // not call updateScenePanelState for with blur animation
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    this.updateScenePanelState(ScenePanelState.HOME);
    this.showStatusBar(true);
    this.stateCollectionHandler?.getRecentInnerState()?.onInit();
  }

  /**
   * 任务中心直接切换成自由多窗，注册恢复预关闭的接口回调
   */
  public registerPrepareWindowCallBack(): void {
    if (!DeviceHelper.isPad()) {
      return;
    }
  }

  /**
   * 反注册恢复预关闭的接口回调
   */
  public unRegisterPrepareWindowCallBack(): void {
    if (!DeviceHelper.isPad()) {
      return;
    }
  }

}

export class TerminateSceneEntryParam {
  containerSession: SCBSceneContainerSession | null = null;
  needRemoveSession: boolean = false;
  needClearData: boolean = false;
  isForceClean: boolean = false;
  isSessionException: boolean = false;
}