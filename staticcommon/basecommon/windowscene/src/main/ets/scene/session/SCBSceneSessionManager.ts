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

import { FocusChangeReason } from '../../common/FocusChangeReason';
import { SCBWindowRaiseReason } from '../../common/SCBWindowRaiseReason';
import { SnapshotNodeType } from '../../common/SnapshotNodeType';
import BundleManager from '@ohos.bundle.bundleManager';
import { image } from '@kit.ImageKit';
import settings from '@ohos.settings';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import taskpool from '@ohos.taskpool';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { AccountEvent, GlobalContext, sSettingsUtil, UserSwitchEvent, viewMgrPolicy } from '@ohos/frameworkwrapper';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, HiTraceChain } from '@ohos/basicutils';
import { EvtBus } from '@ohos/frameworkwrapper';
import { EventConstants } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/EventConstants';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import { sEventManager, EventConstants as FWEventConstants, OobeActivatedEvent } from '@ohos/frameworkwrapper';
import { SCBRootSceneSession } from './SCBRootSceneSession';
import { SCBSceneMode } from './SCBSceneInfo';
import { SCBSceneInfoFromScreenLock } from './SCBSceneInfoFromScreenLock';
import { SCBSceneInfo } from './SCBSceneInfo';
import { SCBScenePersistent } from './SCBScenePersistent';
import { SCBSpecificSession } from './SCBSpecificSession';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';
import { CallToState, RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { AbilityItemInfo, SCBAbilityItemInfo, SCBApplicationInfo } from '../../bean/AbilityItemInfo';
import { SCBSessionCbType, SCBSystemBarProperty } from './SCBSceneSession';
import { SCBSceneSession, ActiveReason } from './SCBSceneSession';
import { SCBSceneContainerSession, SCBSceneSessionArray } from './SCBSceneContainerSession';
import { SCBSceneOrientation } from './SCBSceneOrientation';
import { SCBSceneContainerSessionArray } from './SCBSceneContainerSession';
import { SCBSystemSceneSession, SystemBarType } from './SCBSystemSceneSession';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import SCBRecoverManager from '../manager/SCBRecoverManager';
import type { SystemSessionInfo, SystemSessionChangeCallback } from './SCBSystemSceneSession';
import data_preferences from '@ohos.data.preferences';
import { SCBTransitionManager } from '../../animation/SCBTransitionManager';
import type { SCBUnlockTransitionController } from '../../animation/SCBTransitionManager';
import { SCBScreenProperty, SCBScreenSession } from '../../screen/session/SCBScreenSession';
import type Want from '@ohos.app.ability.Want';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import sSCBOobeManager from '../../oobe/SCBOobeManager';
import { localEventManager } from '@ohos/frameworkwrapper';
import { PackageCommonEvent } from '@ohos/frameworkwrapper';
import { CommonUtils } from '@ohos/basicutils';
import { SCBScreenSessionManager, SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import { SCBWindowRotateController } from '../manager/SCBWindowRotateController';
import type { RectItem } from '@ohos/basicutils';
import { RectInfo } from '@ohos/basicutils';
import { Trace } from '@ohos/basicutils';
import type { RecentFloatingAnimParams } from './SCBFloatingParam';
import commonEvent from '@ohos.commonEventManager';
import { BusinessError, osAccount } from '@kit.BasicServicesKit';
import display from '@ohos.display';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SceneIdentificationManager, SceneState } from '@ohos/frameworkwrapper';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { SCBKeyboardManager, KeyboardState } from './SCBKeyboardManager';
import { SCBKeyboardPanelManager } from './SCBKeyboardPanelManager';
import { SCBKeyboardPanelSession } from './SCBKeyboardPanelSession';
import { SCBKeyboardSession } from './SCBKeyboardSession';
import { SCBTogManager, NotifyState, StartFrom } from './SCBTogManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import systemDateTime from '@ohos.systemDateTime';
import { scbEventExclusiveManager } from '../../gesturenavigation/gestureignore/SCBEventExclusiveManager';
import { scbGestureManager } from '../../gesturenavigation/SCBGestureManager';
import { EventType } from '../../gesturenavigation/gestureignore/configs/EventExclusiveConfig';
import { SplitLifeCycle } from './SCBSplitParam';
import sSampleManager from '../../sampleManager/SampleManager';
import sWindowStyleStoreManager from '../../db/WindowStyleStoreManager';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import {
  SCBScreenSessionArray,
  ControlType,
  SCBAppUseControlManager,
  SCBKioskModeManager,
  ControlAppInfo,
  StartAbilityUtil,
  SCBSceneMissionManager,
  SceneMissionMgmtStage
} from '../../TsIndex';
import lazy { sceneMissionInterceptor } from '../../TsIndex';
import { ExtAppConstants } from '@ohos/commonconstants';
import { ArrayList } from '@kit.ArkTS';
import { ExclusiveChecker } from '../manager/ExclusiveChecker';
import { TraceUtil } from '@ohos/basicutils';
import { inputMonitor } from '@kit.InputKit';
import { TouchGestureEvent } from '@ohos.multimodalInput.gestureEvent';
import { ScbNumber, SCBSessionRect } from './SCBSessionRect';
import { SCBDefaultOrientationPolicy } from './SCBSceneOrientationPolicy';
import { SCBWindowFocusController, DEFAULT_DISPLAY_GROUP_ID } from '../manager/SCBWindowFocusController';
import systemParameter from '@ohos.systemparameter';
import { AsyncCallback } from '@ohos.base';
import { SCBSceneSessionManagerImpl } from '../manager/SCBSceneSessionManagerImpl';
import { MissionManagementTraceUtil } from '../utils/SCBSceneUtils';
import { StartMode, BackgroundReason } from '../common/SCBSceneEnums';
import { SceneParam, isLargeFoldProductInExpand } from './SCBDividerParam';
import { CommonResult } from '../../scene/utils/SCBSceneUtils';
import { DEFAULT_REQUEST_ID } from './SCBSceneInfo'
// @ts-ignore
import { SceneBoardStateManager, CoreEventType } from '@ohos/frameworkwrapper/Index';
import { MidSceneLifeCycle } from './SCBMidSceneParam';
import { SCBSceneStartInterceptor } from '../framework/missions/SCBSceneStartInterceptor';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBSSM';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const INVALID_PERSISTENT_ID: number = 0;
const DEFAULT_USERID = -1;
const UNLOCK_SUCCESS_ZINDEX :number = 1;
const DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID = -1;

export const INVALID_SCREEN_ID: number = -1;
export const INVALID_PANEL_ID: number = -1;
export const INVALID_PID: number = -1;

const GET_BATCH_ABILITY_INFO_TIME_OUT = 3000;
const CORE_ENABLE_KEY: string = 'persist.window.scbcore.enable';
export const SCENE_SESSION_NULL_EXCEPTION = 1300003;
const ohos_APPLICATION = '1';
const LINUX_APPLICATION = '2';
const TRAVERSE_TREE_DURATION_TIME_THRESHOLD = 5 * 1000; // 5ms * 1000 = 5000us
const isLargeInFoldProduct = DeviceHelper.isLargeInFoldProduct();
const INVALID_INDEX = -1;
const SENSOR_ROTATION_CHANGE = 'sensor rotation change';
const APP_MULTI_WINDOW_KEY = 'appMultiWindow';
const DEFAULT_ACCOUNT_ID: number = 100; //main user account id

export const enum TraverseSessionScenarios {
  REFRESH_ZORDER,
  GET_SESSION_BY_ID,
  OTHERS_SCENARIO,
};

export const enum UIEffectZOrderType {
  INVALID_ZORDER,
  ABOVE_SCREEN_LOCK,
  BELOW_SCREEN_LOCK,
  ON_SYSTEM_TOAST,
  IN_APP,
}

export const enum SpecificPanelZOrder {
  ABOVE_SCENE_PANEL,
  TYPE_FLOAT,
  MUTISCREEN_COLLABORATION,
  INPUT_METHOD_STATUS_BAR,
  ABOVE_SYSTEMUI,
  VOICE_INTERACTION,
  FLOAT_NAVIGATION,
  MEDIA_CONTROL_TEMP,
  ABOVE_KEYGUARD,
  VOLUME,
  SYSTEM_TOAST,
  SCREENSHOT,
  PIP_PANEL,
  WALLET_SWIPE_CARD,
  SCREEN_CONTROL,
  DYNAMIC,
  MAGNIFICATION,
  MAGNIFICATION_MENU,
  TYPE_SELECTION,
  FLOATING_BALL,
};
export enum PreferMultiWindowOrientation {
  DEFAULT = 'default',
  LANDSCAPE_AUTO = 'landscape_auto',
  LANDSCAPE = 'landscape',
  PORTRAIT = 'portrait'
}

export enum SessionDisplayChangeReason {
  MOVE_TO_TARGET_DISPLAY,
  MOVE_SUB_WINDOW_TO_TARGET_DISPLAY,
  MOVE_SPECIFIC_WINDOW_TO_TARGET_DISPLAY,
  START_MOVE,
  END_MOVE,
  DRAG_START,
  REFRESH,
  CHANGE_PARENT_SESSION,
  MOVE_TO_TARGET_DISPLAY_NOT_SHOW,
}

enum CurTopWindowMode {
  DEFAULT = 0,
  FULL_SCREEN = 1,
  SPLIT = 2,
  MID_SCENE = 3
}

export class SessionRectChangeInfo {
  public newRect: sceneSessionManager.SessionRect;
  public reason: sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
}

export class SessionChangeInfo {
  public persistentIds: number[] = [];
  public sessionRectChangeMap: Map<number, SessionRectChangeInfo> = new Map();
  public targetScreenId: number = INVALID_SCREEN_ID;
  public curScreenId: number = INVALID_SCREEN_ID;
  public sessionType?: sceneSessionManager.SessionType = sceneSessionManager.SessionType.TYPE_UNDEFINED;
}

export const ROTATION_TO_ORIENTATION: Map<number, number> = new Map<number, number>([
  [RotationConstants.ROTATION_0, 0],
  [RotationConstants.ROTATION_90, 1],
  [RotationConstants.ROTATION_180, 2],
  [RotationConstants.ROTATION_270, 3]
]);

export const THREE_ROTATION_TO_ORIENTATION: Map<number, number> = new Map<number, number>([
  [RotationConstants.ROTATION_0, 3],
  [RotationConstants.ROTATION_90, 0],
  [RotationConstants.ROTATION_180, 1],
  [RotationConstants.ROTATION_270, 2]
]);

enum SCBPanelZOrder {
  BOTTOM = 0,
  SCENE_PANEL = 1,
  FLOATING_SCENE_PANEL = 2,
  SPCFICABOVE_SCENE_PANEL = 3,
  PIP_SCENE_PANEL = 4,
  SPECIFIC_ABOVE_SYSTEMUI = 5,
  SPECIAL_SCENE_PANEL = 6,
  SPECIFIC_VOICE_INTERACTION = 7,
  SPECIFIC_MEDIA_CONTROL_TEMP = 8,
  SPECIFIC_ABOVE_KEYGUARD = 9,
  VOLUME = 10,
  SYSTEMTOAST = 11,
  SCREEN_CONTROL = 12,
  TOP,
};

enum BundleType {
  NORMAL_TYPE,
  ATOMIC_SERVICE_TYPE
}

export interface ExecuteCallbackExtraInfo {
  errorReason?: string;
  terminatedByAbility?: boolean;
  raiseReason?: SCBWindowRaiseReason;
  targetPersistentId?: number;
  isClickByPcDockFileManager?: boolean;
  needClearCallerLink?: boolean;
  isSessionException?: boolean;
  isSplitClose?: boolean;
  enterSideBarFromDragging?: boolean;
  isForceClean?: boolean;
  isMinimizeFromSetParentSession?: boolean;
  isFromTerminateSession?: boolean;
}

export enum SCBEventId {
  START_SCENE_FROM_ICON,
  START_SCENE_FROM_RECENT,
  START_SCENE_FROM_OTHER,
  START_SCENE_FROM_VIRTUAL,
  START_SCENE_TRANSITION,
  START_SCENE_BYCALL,
  HIDDEN_START_SCENE_FROM_OTHER,
  HIDDEN_START_SCENE_TRANSITION,
  HIDDEN_TO_FOREGROUND_FROM_OTHER,
  HIDDEN_TO_FOREGROUND_TRANSITION,
  FOREGROUND_TO_HIDDEN_FROM_OTHER,
  FOREGROUND_TO_HIDDEN_TRANSITION,
  BACK_SCENE_TRANSITION,
  DESTROY_SCENE,
  MINIMIZE_SCENE,
  MAXIMIZE_SCENE,
  MAXIMIZE_FLOATING_SCENE,
  CLOSE_FLOATING_SCENE,
  CLOSE_SCENE,
  ACTIVATE_SCENE,
  BACKGROUND_SCENE,
  MINIMIZE_ALL_SCENE,
  EXIT_RECENT,
  TERMINATE_SCENE,
  SESSION_EXCEPTION,
  SESSION_RAISE_TO_TOP,
  RAISE_MAIN_WINDOW_ABOVE_TARGET,
  BACKGROUND_SCENE_FOR_DELEGATOR,
  BACK_GESTURE_EVENT,
  HOME_GESTURE_EVENT,
  ENTER_RECENT_EVENT,
  ORIENTATION_CHANGE,
  SPLIT_PRIMARY,
  SPLIT_SECONDARY,
  EXIT_ACTIVE_SPLIT,
  SPLIT_TO_FULL_FOR_MAXIMIZE,
  SPLIT_TO_FULL_FOR_MINIMIZE,
  SPLIT_TO_FLOATING,
  FULL_TO_FLOATING,
  SESSION_RECOVER,
  PIP_SCENE_PANEL_ROTATION,
  MINIMIZE_ALL_FLOATING_SCENE,
  CANCEL_FLOATING_ANIM,
  START_SPLIT_FROM_ICON,
  PAIR_SPLIT_FROM_DOCK,
  START_FLOAT_FROM_DOCK,
  START_SCENE_FROM_NOTIFICATION,
  FLOAT_TRANSITION,
  FLOAT_TO_SPLIT,
  FULL_TO_SPLIT,
  EXIT_GAME_SPLIT_VIEW,
  FLOATING_ENTER_SIDE_EDGE_BAR,
  UPDATE_WINDOW_DRAG_HOT_AREA,
  SWITCH_SPLIT_SCENE,
  RESET_SPLIT_VIEW_WITH_FOLD,
  START_SCENE_FROM_SCREEN_LOCK,
  BACKGROUND_MID_SCENE,
  PRE_START_SPECIFIED,
  CLOSE_TARGET_FLOAT_WINDOW,
  START_SCENE_LIST,
  MAXIMIZE_FULLSCREEN_SCENE,
};

export enum OccludeKeygaurdScene {
  NONE = 0,
  SPECIAL = 1 << 0,
  SPECIFIC_TYPE_SCREENSHOT = 1 << 1,
  SYSTEM_TOP_PANEL = 1 << 2,
  SYSTEM_DIALOG = 1 << 3,
  SPECIFIC_TYPE_VOICE_INTERACTION = 1 << 4,
  SPECIFIC_TYPE_WALLET_SWIPE_CARD = 1 << 5,
  SYSTEM_DIALOG_UNOCCLUDE = 1 << 6,
};

export class ScbPanelZIndex {
  bottom: number = 0;
  scenePanel: number = 0;
  floatingScenePanel: number = 0;
  typeFloat: number = 0;
  mutiScreenCollaboration: number = 0;
  specificAboveScenePanel: number = 0;
  pipScenePanel: number = 0;
  floatingBall: number = 0;
  inputMethodStatusBar: number = 0;
  specificAboveSystemUI: number = 0;
  specificMeidaControlTemp: number = 0;
  specialScenePanel: number = 0;
  voiceInteraction: number = 0;
  floatNavigation: number = 0;
  specificAboveKeyguard: number = 0;
  volume: number = 0;
  systemToast: number = 0;
  screenshot = 0;
  screenControl: number = 0;
  top: number = 0;
  walletSwipeCard: number = 0;
  dynamic: number = 0;
  magnification: number = 0;
  magnificationMenu: number = 0;
  typeSelection: number = 0;
}

export enum ScenePanelState {
  HOME,
  FULLSCENE,
  SPLIT,
  FLOAT_SCENE,
  RECENT,
  QUICK_SWITCH,
  APP_CENTER,
}

export enum ClassType {
  SCENE_SESSION = 0,
  SPECIFIC_SESSION,
  SYSTEM_SCENE_SESSION,
}

export type PopSceneSessionFunc = ((sceneInfo: SCBSceneInfo, needBackground?: boolean,
  needRemoveSceneSession?: boolean) => SCBSceneSession | undefined);

export type VirtualScreenStartSceneFunc = ((sceneInfo: SCBSceneInfo) => void);

export type SceneStateChangeCallback = ((sceneInfo: SCBSceneInfo, isForeground: boolean) => void);

export type ScreenCaptureWarnAnimateToCallback = (() => void);

export type NavigationPropertyChangedCallback = (prop: SCBSystemBarProperty, screenId: number) => void;

export const ACTIVE_STATUS_MAP: Map<sceneSessionManager.SessionState, boolean> = new Map([
  [sceneSessionManager.SessionState.STATE_CONNECT, false],
  [sceneSessionManager.SessionState.STATE_FOREGROUND, true],
  [sceneSessionManager.SessionState.STATE_ACTIVE, true],
  [sceneSessionManager.SessionState.STATE_INACTIVE, false],
  [sceneSessionManager.SessionState.STATE_BACKGROUND, false],
  [sceneSessionManager.SessionState.STATE_DISCONNECT, false],
]);

const DISPLAYORIENTATION_TO_SCBSCENEORIENTATION: Map<BundleManager.DisplayOrientation, SCBSceneOrientation> =
  new Map<BundleManager.DisplayOrientation, SCBSceneOrientation>([
    [BundleManager.DisplayOrientation.UNSPECIFIED, SCBSceneOrientation.UNSPECIFIED],
    [BundleManager.DisplayOrientation.LANDSCAPE, SCBSceneOrientation.HORIZONTAL],
    [BundleManager.DisplayOrientation.PORTRAIT, SCBSceneOrientation.VERTICAL],
    [BundleManager.DisplayOrientation.FOLLOW_RECENT, SCBSceneOrientation.LOCKED],
    [BundleManager.DisplayOrientation.LANDSCAPE_INVERTED, SCBSceneOrientation.REVERSE_HORIZONTAL],
    [BundleManager.DisplayOrientation.PORTRAIT_INVERTED, SCBSceneOrientation.REVERSE_VERTICAL],
    [BundleManager.DisplayOrientation.AUTO_ROTATION, SCBSceneOrientation.SENSOR],
    [BundleManager.DisplayOrientation.AUTO_ROTATION_LANDSCAPE, SCBSceneOrientation.SENSOR_HORIZONTAL],
    [BundleManager.DisplayOrientation.AUTO_ROTATION_PORTRAIT, SCBSceneOrientation.SENSOR_VERTICAL],
    [BundleManager.DisplayOrientation.AUTO_ROTATION_RESTRICTED, SCBSceneOrientation.AUTO_ROTATION_RESTRICTED],
    [BundleManager.DisplayOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED, SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED],
    [BundleManager.DisplayOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED, SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED],
    [BundleManager.DisplayOrientation.LOCKED, SCBSceneOrientation.LOCKED],
    [BundleManager.DisplayOrientation.AUTO_ROTATION_UNSPECIFIED, SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED],
    [BundleManager.DisplayOrientation.FOLLOW_DESKTOP, SCBSceneOrientation.FOLLOW_DESKTOP],
  ]);

const MISSION_MANAGEMENT_TRACE_MAP: Map<SCBEventId, string> = new Map([
  [SCBEventId.MINIMIZE_SCENE, MissionManagementTraceUtil.MINIMIZE_SCENE],
  [SCBEventId.TERMINATE_SCENE, MissionManagementTraceUtil.TERMINATE_SCENE],
  [SCBEventId.SESSION_EXCEPTION, MissionManagementTraceUtil.SESSION_EXCEPTION],
]);

const MISSION_MANAGEMENT_TRACE_ON_SPECIAL_MAP: Map<SCBEventId, string> = new Map([
  [SCBEventId.MINIMIZE_SCENE, MissionManagementTraceUtil.MINIMIZE_SCENE_ON_SPECIAL],
  [SCBEventId.TERMINATE_SCENE, MissionManagementTraceUtil.TERMINATE_SCENE_ON_SPECIAL],
  [SCBEventId.SESSION_EXCEPTION, MissionManagementTraceUtil.SESSION_EXCEPTION_ON_SPECIAL],
  [SCBEventId.MINIMIZE_ALL_SCENE, MissionManagementTraceUtil.MINIMIZE_ALL_SCENE_ON_SPECIAL],
]);

const NOT_OCCLUDE_DESKTOP_CLOCK_TYPES = [
  sceneSessionManager.SessionType.TYPE_TOAST,
  sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY,
  sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION,
  sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
  sceneSessionManager.SessionType.TYPE_SCREENSHOT
];

@Observed
export class SCBSpecificSceneSessionList extends Array<SCBSpecificSession> {
}

@Observed
export class SCBDynamicSystemScene {
  zIndex: number;
  systemSceneList: SCBSpecificSceneSessionList;
  constructor(zIndex: number) {
    this.zIndex = zIndex;
    this.systemSceneList = new SCBSpecificSceneSessionList();
  }
}

@Observed
export class SCBDynamicSystemSceneList extends Array<SCBDynamicSystemScene> {
}

@Observed
export class SCBInputMethodList extends Array<SCBKeyboardSession> {
}

export interface SessionLabelListener {
  onUpdate(label: string);
}

export interface SessionIconListener {
  onUpdate(icon: image.PixelMap);
}

export interface AddSpecificSessionCallback {
  (SCBSpecificSceneSessionList):void;
}

/*
 * Multi User
 */
export enum UserSwitchEventType {
  SWITCHING,
  SWITCHED,
}

/**
 * Global Scene Session Management Interface
 * @description global interface of window management.
 */
export class SCBSceneSessionManager {
  private selfImpl: SCBSceneSessionManagerImpl = new SCBSceneSessionManagerImpl();
  public isStartingSceneFromPiP: boolean = false;
  // background restore
  public isRestoreFromBgPiP: boolean = false;
  private rootSceneSession: SCBRootSceneSession;
  // callbacks of create system specific session: Map<screenId, Map<zorder, callbackFunc>>
  private createSpecificSceneCallbackMap: Map<number, Map<number, Function>> = new Map();
  // callbacks of destroy float window: Map<screenId, Map<zorder, Set<CallbackFunc>>
  private destroyFloatWindowCallbackMap: Map<number, Map<number, Set<Function>>> = new Map();
  private getPluginSessionListCallback: Function;
  private requestFocusCallback: Function;
  private clearSceneStatusCallback: Map<number, Function> = new Map();
  private dockVisibleCallback: Map<number, Function> = new Map();
  private statusBarRecoverCallback: Map<number, Function> = new Map();
  private statusBarTypeChangeCallback: Function;
  private gestureBarVisibleCallback: Map<number, Function> = new Map();
  private dockMaskVisibleCallbackMap: Map<number, Function> = new Map();
  private windowModeChangeCallbackMap: Map<number, Function> = new Map();
  private doAnimationCallbackMap: Map<number, Function> = new Map();
  private isExternalScreenInterceptedCallback: Function;
  private navigationBarCallbackMap: Map<number, Function> = new Map();
  private navigationPropertyChangedCallbackMap: Map<number, NavigationPropertyChangedCallback> = new Map();
  private statusBarStyleCallback: Function;
  private systemBarPropertyCallbackMap: Map<number, Array<Function>> = new Map();
  private rawSystemBarPropertyCallbackMap: Map<number, Set<Function>> = new Map();
  private addContainerSessionCallback: Map<number, Function> = new Map(); // callbacks to add/remove container session
  private addExtendContainerSessionCallback: Map<number, Function> = new Map();
  private removeContainerSessionCallback: Map<number, Function> = new Map();
  private updatePipExtendSessionCallback: Map<number, Function> = new Map();
  private globalSearchExitCallback: Function;
  private addSpecialContainerSessionCallback: Function;
  private removeSpecialContainerSessionCallback: Function;
  private specialScenePanelStartSceneWithRotationIfNeedCallback: Function;
  private specialScenePanelExitSceneWithRotationRecoverCallback: Function;
  private callbackMap: Map<number, Map<number, Array<Function>>> = new Map(); // eventId, screenId, function
  private specialCallbackMap: Map<number, Map<number, Array<Function>>> = new Map();
  private callbackFuncForSCBScenePanel: Function;
  private pipRestoreCallbackMap: Map<number, Function> = new Map();
  private navChangeCallback: Function;
  private midSceneStateChangeCallBack: Function;
  private scenePersistent: SCBScenePersistent;
  private abilityInfoMap = new Map<string, AbilityItemInfo>(); // key is bundleName+moduleName+abilityName
  private sdkVersionMap = new Map<string, number>(); // key is bundleName+moduleName+abilityName
  private applicationStartModeMap = new Map<string, SCBApplicationInfo>();
  private abilityHookMap: Map<string, boolean> = new Map(); // key is bundleName+moduleName+abilityName
  private readonly listener;
  private mCurrentUserId: number = DEFAULT_USERID;
  private desktopDefaultSystemBarProperty: SCBSystemBarProperty;
  private lockDefaultSystemBarProperty: SCBSystemBarProperty;
  private zOrder: number = 0;
  public mainScreenId: number = INVALID_SCREEN_ID;
  private _isPrivacySpace: boolean = false;
  private isScreenLock: boolean = false;
  private isScreenEarlyLock: boolean = false;
  private systemSceneList: Map<number, SCBSystemSceneSession[]> = new Map().set(INVALID_SCREEN_ID, []);
  // relative position to panels
  private panelZIndex: ScbPanelZIndex = new ScbPanelZIndex();
  private panelLists: Map<number, Array<[number, Function]>> = new Map();
  private isStartRecoverySet: Set<number> = new Set();
  public belowSystemSessionList: SCBSystemSceneSession[];
  public betweenSystemSessionList: SCBSystemSceneSession[];
  public aboveSystemSessionList: SCBSystemSceneSession[];
  public topSystemSessionList: SCBSystemSceneSession[];
  public systemSessionMap = new Map<string, string>(); // get systemSession from its true name
  public sysSessionNameIdMap = new Map<string, number>();
  public splitFocusSessionList: SCBSceneSessionArray = new SCBSceneSessionArray();
  private specificSessionCacheMap: Map<number, Map<number, sceneSessionManager.SceneSession[]>> = new Map();
  private sessionTypeToPanelZorderMap: Map<sceneSessionManager.SessionType, SpecificPanelZOrder> = new Map();

  private static gSystemId: number = 0;

  private exitSplitViewFuncionCallback: Function;
  private exitMidSceneFunctionCallback: Function;
  private startFloatFromUnlockFunctionCallback: Function;
  private unLockTransitionController: SCBUnlockTransitionController;
  private activeSessionList: number[] = [];
  private getContainerSessionListCallback: Map<number, Function> = new Map();

  // 隐藏启动
  private getContainerSessionListNotShowRecentCallback: Map<number, Function> = new Map();
  private addExtendNotShowRecentContainerSessionCallback: Map<number, Function> = new Map();

  private getSystemBarPropertyAdjusterCallback: Function | undefined;
  private getAllContainerSessionListCallback: Function = null;
  private recoverSessionCallbackMap: Map<number, Function> = new Map(); // key is screenId
  private startSceneWithRotationIfNeedCallback: Function;
  private getSpecialContainerSessionListCallback: Function;
  private getFloatingSessionListCallback: Function;
  private getSideEdgeSessionListCallback: Function;
  private clearAdditionalCallersCallback: Function;
  private getMultiWindowDialogSession: SCBSystemSceneSession | null = null;
  private getSpecificContainerSessionListCallbackMap: Map<number, Map<number, Function>> = new Map();
  private ratioPreference;
  private requestFocusCallbacks: Array<Function> = new Array();
  private ntfFloatingWindowCallbacks: Array<Function> = new Array();
  private getFloatingRectCallbacks: Set<Function> = new Set();
  private uiAbilityCrashCallbacks: Function;
  private startSceneCallback: Function;
  private startSceneSingleHandCallback: Function;
  private ntfAnimationFinishedCallbacks: Function;
  private ntfGrayAppIconCallbacks: Function;
  private ntfGrayAllAppsAppIconCallbacks: Function;
  private onUnfocusedCallbacks: Array<Function> = new Array();
  private focusedScreenChangeCallbacks: Array<Function> = new Array();
  private getScenePanelStateCallback: Map<number, Map<number, Function>> = new Map(); // screenId, panelIdx, callback
  private updateScenePanelStateCallback: Map<number, Map<number, Function>> = new Map();
  private keyguardOccludedState: number = OccludeKeygaurdScene.NONE;
  private keyguardOccludedChangeCallbacks: Array<Function> = new Array();
  private fullSceneEndCallback: Function;
  private recentClearAllAnimCntCallback: Function;
  private fullScreenTitleBarAppearCallbacks: Set<Function> = new Set();
  private fullScreenMenuVisibleCallback: Function;
  private hotRegionStateChangeCallbacks: Set<Function> = new Set();
  private topSceneCallbacks: Map<number, Function> = new Map();
  private menuVisibleCallbacks: Map<number, Function> = new Map();
  private grayAppListManagerFunctionCallback: Function;
  // queue for storing the start ability command. If the callback is not registered, the start ability command is added to this queue.
  private startAbilityQueue = [];
  private recoverSceneSessionList:
    Map<number, [sceneSessionManager.SceneSession, sceneSessionManager.SceneRecoverInfo][]> = new Map();
  // Used for record current window number
  private recordStartTime: number = 0;
  private unlockTransitionCallbacks: Array<SCBUnlockTransitionController> = new Array();

  private defaultSystemBarProperty: SCBSystemBarProperty =
    new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_UNDEFINED, true, '#00FFFFFF', '#FFFFFFFF');

  private lastSystemBarPropertyMap: Map<number, SCBSystemBarProperty> = new Map();

  private appDefaultSystemBarProperty: SCBSystemBarProperty =
    new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, true, '#00FFFFFF', '#FF000000');

  private appOverrideSystemBarProperties: Map<number, SCBSystemBarProperty> = new Map();

  private sceneBoardForceProperty: SCBSystemBarProperty =
    new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_UNDEFINED, true, '#00FFFFFF', '#FFFFFFFF');

  private recentTaskChangeProcess: 'in' | 'out' | undefined = undefined;
  public get isInRecentOutProcess() {
    return this.recentTaskChangeProcess === 'out';
  }

  private mIsStatusBarShownForHover: boolean = false;
  private isMaximizeFloatingMode: boolean = false;
  private specificScenePanelEnterRecentCallback: Function;
  private specificScenePanelExitRecentCallback: Function;

  private popSceneSessionFuncMap: Map<number, PopSceneSessionFunc> = new Map();
  private popSpecialSceneSessionFuncMap: Map<number, PopSceneSessionFunc> = new Map();

  private virtualScreenStartSceneFuncMap: Map<number, VirtualScreenStartSceneFunc> = new Map();
  /**
   * ui effect
   */
  private screenCaptureWarnAnimateToCallbackMap: Map<UIEffectZOrderType, ScreenCaptureWarnAnimateToCallback> = new Map();
  /**
   * Free Window
   */
  public pcModeDockAreaOffsetY: number = 0;
  private supportPcMode: boolean = false;
  private isInPcMode: boolean = false;
  private togglePcModeFunc: Function = null;
  /**
   * 进入多任务模式需要调用的方法集合
   */
  private systemBarPropertyRecentCallbacks: Array<Function> = new Array();
  private compatibleViewChangeCallback: Function;

  private autoStartPiPCallback: Function;

  private pipOcclusiveChangeCallback: Function;

  private startPiPFailedCallbackMap: Map<number, Function> = new Map();

  private minimizeByWindowIdsCallbacks: Array<Function> = new Array;

  private maxForegroundWindowNumChangeCallbacks: Array<Function> = new Array;
  private maxForegroundWindowNum: number = 0;

  private cacheCastSessionInfo: SCBSceneInfo = null;

  private isInAppExit: boolean = false;
  private _isCoreEnable: boolean = true;
  private screenLockWithFoldPersistentId: number = -1;

  // scb appfreeze dfx
  private maxTraverseDuration: number = 0;

  private initCasePosCallbackMap: Map<number, Function> = new Map();

  // projection bundleName for padWithCar
  private currentProjectionBundleName: string = '';

  // projection screenId for padWithCar
  private projectionScreenId: number = 0;

  private statusBarEnableCallbacks: Map<number, (enable: boolean, persistentId: number) => void> = new Map();

  private getVirtualScreenSessionFuncMap:
    Map<number, ((id: number) => SCBSceneSession | SCBSpecificSession | undefined)> = new Map();
  private sceneStateChangeCallback: Map<number, SceneStateChangeCallback[]> = new Map();
  private readonly appExitListener = {
    onReceiveEvent: (event: string, params: boolean): void => {
      log.showInfo(`appExitListener, receive event : ${event},param is ${params}`);
      if (event === EventConstants.EVENT_IN_APP_EXIT) {
        this.isInAppExit = params;
      }
    }
  };

  private onSessionLabelListeners: Map<number, ArrayList<SessionLabelListener>> = new Map();
  private onSessionIconListeners: Map<string, ArrayList<SessionIconListener>> = new Map();

  private homeOccludedPanels: Map<number, sceneSessionManager.SceneSession[]> = new Map();
  private lastfoldStatus: display.FoldStatus = DeviceHelper.getFoldStatus();

  private sessionDisplayChangeCallback: Function;
  private touchScreenGestureCallback: Function;

  private curScreenTopSessionWindowModeMap: Map<number, number> = new Map();

  private fullScreenLayoutCallBack: Map<number, Map<string, Function>> = new Map();

  private fullScreenLayoutMap: Map<number, boolean> = new Map();

  /**
   * Window Focus
   */
  private lastFocusedSessionId: number = -1;
  public windowFocusController: SCBWindowFocusController = new SCBWindowFocusController();

  public getLastFocusedSessionId(displayId: number = DEFAULT_DISPLAY_GROUP_ID): number {
    return this.windowFocusController.getLastFocusedSessionId(displayId);
  }

  private setWindowRectAutoSaveCallback: Function;

  private isPairSplitStateCallbackMap: Map<number, Function> = new Map();
  private isHandleThreeFingerSwiperCallbackMap: Map<number, Function> = new Map();

  private topFullScreenSubSessionMap: Map<number, SCBSpecificSession> = new Map();
  private mainSessionOfFullScreenSubSessionMap: Map<number, SCBSceneSession> = new Map();
  private pipCallback: Function;
  private dockAvoidWindowCallback: Function | undefined;
  private multiWindowForceSupportMap_: Map<string, boolean> = new Map();

  private addGestureDockRecentItemCallback: Function | undefined;

  private handleWindowWhenPreLockCallbackMap: Map<number, Function> = new Map();

  /**
   * registerPipCallback 注册pip小窗恢复到全屏显示回调
   *
   * @param callback callback
   */
  public registerPipCallback(callback: Function): void {
    this.pipCallback = callback;
  }

  /**
   * unregisterPipCallback 反注册pip小窗恢复到全屏显示回调
   */
  public unregisterPipCallback(): void {
    this.pipCallback = null;
  }

  /**
   * starPipRestore 将pip小窗应用恢复到全屏显示
   *
   * @param persistentId persistentId
   */
  public starPipRestore(persistentId: number): void {
    if (this.pipCallback !== undefined && this.pipCallback !== null) {
      log.showInfo(`starPipRestore: persistentId = ${persistentId}`);
      this.pipCallback(persistentId);
    }
  }

  /**
   * register setWindowRectAutoSave Callback
   *
   * @param { Function } callback
   */
  public registerSetWindowRectAutoSaveCallback(callback: Function): void {
    this.setWindowRectAutoSaveCallback = callback;
  }

  public getScreenLockWithFoldPersistentId(): number {
    return this.screenLockWithFoldPersistentId;
  }

  public setScreenLockWithFoldPersistentId(persistentId: number): void {
    this.screenLockWithFoldPersistentId = persistentId;
  }

  public registerInitCasePosCallback(callback: Function, screenId: number): void {
    this.initCasePosCallbackMap.set(screenId, callback);
    log.showInfo(`the callback from screen:${screenId}`);
  }

  public unregisterInitCasePosCallback(screenId: number): void {
    this.initCasePosCallbackMap.delete(screenId);
    log.showInfo(`unregisterInitCasePosCallback, screenId: ${screenId}`);
  }

  public notifyInitCasePosCallback(sceneSession: SCBSceneSession | null | undefined): void {
    let screenId = sceneSession?.sceneInfo.screenId ?? 0;
    let initCasePosCallback: Function | undefined = this.initCasePosCallbackMap.get(screenId);
    if (initCasePosCallback !== undefined) {
      initCasePosCallback(sceneSession);
      log.showInfo(`run the callback in screen:${screenId}`);
    }
  }

  /**
   * Callback for setting whether the window memory state is enabled.
   *
   * @param { SCBSceneInfo } sceneInfo
   * @param { boolean } enable
   */
  public notifySCBSceneSetWindowRectAutoSave(sceneInfo: SCBSceneInfo, enable: boolean,
      isEnableSpecified: boolean): void {
    if (this.setWindowRectAutoSaveCallback) {
      log.showInfo(`notifySCBSceneSetWindowRectAutoSave`);
      this.setWindowRectAutoSaveCallback(sceneInfo, enable, isEnableSpecified);
    }
  }

  /**
   * register Get Container Session List Callback
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public registerGetContainerSessionListCallback(callback: Function, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.getContainerSessionListCallback.set(screenId, callback);
  }

  /**
   * Register all the windows from all the screens callback
   *
   * @param callback
   */
  public registerGetAllContainerSessionListCallback(callback: Function): void {
    this.getAllContainerSessionListCallback = callback;
  }

  /**
   * unregister all the windows from all the screens callback
   */
  public unregisterGetAllContainerSessionListCallback(): void {
    this.getAllContainerSessionListCallback = null;
  }

  /**
   * register system bar property adjuster
   * @param { Function } callback
   */
  public registerSystemBarPropertyAdjusterCallback(callback: Function): void {
    this.getSystemBarPropertyAdjusterCallback = callback;
  }

  /**
   * unregister system bar property adjuster
   * @param { Number } screenId
   */
  public unRegisterSystemBarPropertyAdjusterCallback(): void {
    this.getSystemBarPropertyAdjusterCallback = undefined;
  }

  /**
   * register exit split view Callback
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public registerExitSplitViewCallback(callback: Function): void {
    this.exitSplitViewFuncionCallback = callback;
  }

  /**
   * register exit split view Callback
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public unRegisterExitSplitViewCallback(): void {
    this.exitSplitViewFuncionCallback = null;
  }

  /**
   * register exit midScene Callback
   *
   * @param { Function } callback
   */
  public registerExitMidSceneCallback(callback: Function): void {
    this.exitMidSceneFunctionCallback = callback;
  }

  /**
   * register exit midScene Callback
   *
   * @param { Function } callback
   */
  public unRegisterExitMidSceneCallback(): void {
    this.exitMidSceneFunctionCallback = null;
  }

  /**
   * register start float scene Callback
   *
   * @param { Function } callback
   */
  public registerStartFloatFromUnlockCallback(callback: Function): void {
    this.startFloatFromUnlockFunctionCallback = callback;
  }

  /**
   * unRegister start float scene Callback
   *
   */
  public unRegisterStartFloatFromUnlockCallback(): void {
    this.startFloatFromUnlockFunctionCallback = null;
  }

  /**
   * register GrayAppListManager Callback
   *
   * @param { Function } callback
   */
  public registerGrayAppListManagerCallback(callback: Function): void {
    this.grayAppListManagerFunctionCallback = callback;
  }

  /**
   * unregister GrayAppListManager Callback
   */
  public unRegisterGrayAppListManagerCallback(): void {
    this.grayAppListManagerFunctionCallback = null;
  }

  /**
   * unregister Get Container Session List Callback
   *
   * @param { Number } screenId
   */
  public unregisterGetContainerSessionListCallback(screenId?: number): void {
    log.showInfo('unregisterGetContainerSessionListCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.getContainerSessionListCallback.delete(screenId);
  }

  /**
   * register Pop Scene Session
   *
   * @param { PopSceneSessionFunc } popSceneSession
   * @param { Number } screedId
   */
  public registerPopSceneSession(popSceneSession: PopSceneSessionFunc, screenId: number): void {
    log.showInfo(`[screen:${screenId}] registered popSceenSession callback.`);
    this.popSceneSessionFuncMap.set(screenId, popSceneSession);
  }

  public registerSceneStateChangeCallback(screenId: number, sceneStateChange: SceneStateChangeCallback): void {
    if (this.sceneStateChangeCallback.get(screenId) === undefined) {
      this.sceneStateChangeCallback.set(screenId, []);
    }
    const sceneStateChangeCallbackList = this.sceneStateChangeCallback.get(screenId);
    if (sceneStateChangeCallbackList.includes(sceneStateChange)) {
      return;
    }
    sceneStateChangeCallbackList.push(sceneStateChange);
  }

  /**
   * 隐私空间
   * @returns
   */
  public isPrivacySpace() {
    return this._isPrivacySpace;
  }

  private initAccountSwitchListener(): void {
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let accountId = accountManager.getOsAccountLocalIdForUidSync(GlobalContext.getContext().applicationInfo.uid);
      this._isPrivacySpace = accountId !== DEFAULT_ACCOUNT_ID;
      log.info(`initAccountListener accountId: ${accountId} isPrivacySpace:${this._isPrivacySpace}`);
      accountManager.on('switched', this.onAccountSwitchedCallback);
    } catch (err) {
      log.error(`onSwitchedCallback failed: errCode: ${err?.code}, msg: ${err?.message}`);
    }
  }

  private onAccountSwitchedCallback = (eventData: osAccount.OsAccountSwitchEventData): void => {
    if (!eventData) {
      log.showError(`account switch callback error, eventData is empty`);
      return;
    }
    if (eventData.toAccountId !== DEFAULT_ACCOUNT_ID) {
      this._isPrivacySpace = true;
    } else {
      this._isPrivacySpace = false;
    }
    log.showInfo(`account switch, isPrivacySpace: ${this._isPrivacySpace}`);
  }

  /**
   * is container session need rotate
   *
   * @param { SCBSceneContainerSession } currentContainerSession
   * @param { SCBSceneContainerSession } toContainerSession
   */
  public isContainerSessionNeedRotate(currentContainerSession: SCBSceneContainerSession,
    toContainerSession?: SCBSceneContainerSession): boolean {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(currentContainerSession.screenProperty.screenId);
    if (!screenSession) {
      log.showError('isContainerSessionNeedRotate screenSession is null');
      return false;
    }
    if (screenSession.isRotateScreenPolicy()) {
      return false;
    }
    let currentRotation = currentContainerSession.getTargetRotation(screenSession.sensorScreenProperty.rotation);
    let toRotation = toContainerSession?.getTargetRotation(screenSession.sensorScreenProperty.rotation);
    if (currentRotation !== toRotation) {
      return true;
    }
    return false;
  }

  public getTargetRotationProperty(screenId: number, targetOrientation: number, persistentId: number): void {
    log.showInfo(' targetOrientation: ' + targetOrientation);
    let containerSession = this.getSceneContainerSessionFromScenePanel(persistentId, screenId);
    if (containerSession === null) {
      log.showError(`getTargetRotationProperty fail: reason:containerSession is null`);
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (screenSession === null) {
      log.showError(`getTargetRotationProperty fail: reason:screenSession is null`);
      return;
    }
    let actualTargetOrientation: SCBSceneOrientation = targetOrientation;
    let fromUser: boolean = true;
    if (this.isUserPageOrientation(actualTargetOrientation)) {
      actualTargetOrientation = this.convertUserPageOrientationToUserOrientation(actualTargetOrientation);
      fromUser = false;
      log.showInfo('UserPageOrientation: ' + targetOrientation +
        ' targetUserOrientation: ' + actualTargetOrientation);
    }
    let preRotation = screenSession.scbScreenProperty.rotation;
    let targetRotation = containerSession?.getTargetPageRotation(screenSession.sensorScreenProperty.rotation, actualTargetOrientation, fromUser);
    if (targetRotation === null) {
      log.showError(`getTargetRotationProperty fail: reason:targetRotation is null`);
      return;
    }
    const absRotation = Math.abs(preRotation - targetRotation);
    let sceneSession = containerSession?.findSceneSessionByPersistentId(persistentId);
    if (sceneSession === null) {
      log.showError(`getTargetRotationProperty fail: reason:sceneSession is null`);
      return;
    }
    log.showInfo(`getTargetRotationProperty isRotatable: ${screenSession.isRotatable}, ` +
      `ScreenProperty.width: ${screenSession.scbScreenProperty.width}, ` +
      `ScreenProperty.height: ${screenSession.scbScreenProperty.height}`);
    if (!screenSession.isRotatable) {
      sceneSession.session.notifyRotationProperty(preRotation, screenSession.scbScreenProperty.width, screenSession.scbScreenProperty.height);
      return;
    }
    if (absRotation === RotationConstants.ROTATION_0 || absRotation === RotationConstants.ROTATION_180) {
      sceneSession.session.notifyRotationProperty(targetRotation, screenSession.scbScreenProperty.width, screenSession.scbScreenProperty.height);
    } else {
      sceneSession.session.notifyRotationProperty(targetRotation, screenSession.scbScreenProperty.height, screenSession.scbScreenProperty.width);
    }
  }

  public isUserPageOrientation(targetOrientation: SCBSceneOrientation): boolean {
    if (targetOrientation === SCBSceneOrientation.USER_PAGE_ROTATION_PORTRAIT ||
      targetOrientation === SCBSceneOrientation.USER_PAGE_ROTATION_LANDSCAPE ||
      targetOrientation === SCBSceneOrientation.USER_PAGE_ROTATION_PORTRAIT_INVERTED ||
      targetOrientation === SCBSceneOrientation.USER_PAGE_ROTATION_LANDSCAPE_INVERTED) {
      return true;
    }
    log.showInfo(`targetOrientation does not belong to the userPageOrientation type`);
    return false;
  }

  public convertUserPageOrientationToUserOrientation(targetOrientation: SCBSceneOrientation): SCBSceneOrientation {
    switch (targetOrientation) {
      case SCBSceneOrientation.USER_PAGE_ROTATION_PORTRAIT:
        return SCBSceneOrientation.USER_ROTATION_PORTRAIT;
      case SCBSceneOrientation.USER_PAGE_ROTATION_LANDSCAPE:
        return SCBSceneOrientation.USER_ROTATION_LANDSCAPE;
      case SCBSceneOrientation.USER_PAGE_ROTATION_PORTRAIT_INVERTED:
        return SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED;
      case SCBSceneOrientation.USER_PAGE_ROTATION_LANDSCAPE_INVERTED:
        return SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED;
      default:
        log.showError(`convertUserPageOrientationToUserOrientation fail: reason:targetOrientation does not belong to the userOrientation type`);
        break;
    }
    return SCBSceneOrientation.UNSPECIFIED;
  }
  public unregisterSceneStateChangeCallback(screenId: number, sceneStateChange?: SceneStateChangeCallback): void {
    if (this.sceneStateChangeCallback.get(screenId) === undefined) {
      return;
    }
    if (sceneStateChange === undefined) {
      this.sceneStateChangeCallback.delete(screenId);
      return;
    }
    const sceneStateChangeCallbackList = this.sceneStateChangeCallback.get(screenId);
    const index = sceneStateChangeCallbackList?.indexOf(sceneStateChange);
    if (index < 0) {
      return;
    }
    sceneStateChangeCallbackList.splice(index, 1);
  }

  public onSceneStateChange(sceneInfo: SCBSceneInfo, isForeground: boolean): void {
    this.sceneStateChangeCallback.forEach((events: SceneStateChangeCallback[]) => {
      events.forEach((callback: SceneStateChangeCallback) => {
        callback(sceneInfo, isForeground);
      });
    });
  }

  /**
   * unregister Pop Scene Session
   *
   * @param { Number } screenId
   */
  public unregisterPopSceneSession(screenId: number): void {
    log.showInfo(`[screen:${screenId}] unregisted popSceneSession callback`);
    this.popSceneSessionFuncMap.delete(screenId);
  }

  /**
   * register Pop Special Scene Session
   *
   * @param { PopSceneSessionFunc } popSceneSession
   * @param { Number } screenId
   */
  public registerPopSpecialSceneSession(popSceneSession: PopSceneSessionFunc, screenId: number): void {
    this.popSpecialSceneSessionFuncMap.set(screenId, popSceneSession);
  }

  /**
   * unregister Pop Special Scene Session
   *
   * @param { Number } screenId
   */
  public unregisterPopSpecialSceneSession(screenId: number): void {
    this.popSpecialSceneSessionFuncMap.delete(screenId);
  }

  /**
   * register Virtual Screen Start Scene
   *
   * @param { VirtualScreenStartSceneFunc } startScene
   * @param { Number } screenId
   */
  public registerVirtualScreenStartScene(startScene: VirtualScreenStartSceneFunc, screedId: number): void {
    this.virtualScreenStartSceneFuncMap.set(screedId, startScene);
  }

  /**
   * unregister Virtual Screen Start Scene
   *
   * @param { Number } screedId
   */
  public unregisterVirtualScreenStartScene(screedId: number): void {
    this.virtualScreenStartSceneFuncMap.delete(screedId);
  }

  /**
   * pop Special Scene From Other Screen
   *
   * @param { SCBSceneInfo } sceneInfo
   * @param { boolean } needBackground
   * @returns { SCBSceneInfo | undefined }
   */
  public popSpecialSceneFromOtherScreen(sceneInfo: SCBSceneInfo,
    needBackground: boolean): SCBSceneSession | undefined {
    let screenId: number = sceneInfo.screenId;
    for (let screenIdKey of this.popSpecialSceneSessionFuncMap.keys()) {
      if (screenIdKey === screenId) {
        continue;
      }
      const sceneSession = this.popSpecialSceneSessionFuncMap.get(screenIdKey)?.(sceneInfo, needBackground);
      if (sceneSession) {
        return sceneSession;
      }
    }
    return undefined;
  }

  /**
   * pop Scene From Other Screen
   *
   * @param { SCBSceneInfo } sceneInfo
   * @returns { SCBSceneInfo|undefined }
   */
  public popSceneFromOtherScreen(sceneInfo: SCBSceneInfo, needBackground: boolean = true,
    needUpdateScreenId: boolean = true): SCBSceneSession | undefined {
    log.showInfo(`popSceneFromOtherScreen toScreen: ${sceneInfo?.screenId} needBackground: ${needBackground}, ` +
      `needUpdateScreenId: ${needUpdateScreenId}`);
    let session: SCBSceneSession | null = null;
    if (sceneInfo && sceneInfo.persistentId > INVALID_PERSISTENT_ID) {
      session = SCBSceneMissionManager.getInstance().popSceneFromOtherScreenByPersistentId(
        sceneInfo.persistentId, sceneInfo.screenId, { needBackground: needBackground, needUpdateScreenId: needUpdateScreenId });
    }
    if (!session) {
      session = SCBSceneMissionManager.getInstance().popSceneFromOtherScreenByInfo(sceneInfo,
        { needBackground: needBackground, needUpdateScreenId: needUpdateScreenId });
    }
    if (session) {
      log.showInfo('popSceneFromOtherScreen used new fwk.');
      if (needBackground) {
        this.requestUnfocus(session.session.persistentId, FocusChangeReason.BACKGROUND);
      }
      if (needUpdateScreenId) {
        this.updateSessionDisplayId(session.session.persistentId,
          (sceneInfo.screenId === INVALID_SCREEN_ID ? this.mainScreenId : sceneInfo.screenId));
      }
      return session;
    }
    let screenId: number = sceneInfo.screenId;
    if (this.popSceneSessionFuncMap.get(screenId) === undefined || screenId === INVALID_SCREEN_ID) {
      screenId = this.mainScreenId;
    }
    const needRemoveSceneSession = SCBSceneSessionManager.getInstance().isProjectionBundleName(sceneInfo.bundleName);
    for (let scrId of this.popSceneSessionFuncMap.keys()) {
      if (scrId === screenId) {
        continue;
      }
      const sceneSession = this.popSceneSessionFuncMap.get(scrId)?.(sceneInfo, needBackground, needRemoveSceneSession);
      if (sceneSession !== undefined) {
        if (needBackground) {
          this.requestUnfocus(sceneSession.session.persistentId, FocusChangeReason.BACKGROUND);
        }
        if (needUpdateScreenId) {
          this.updateSessionDisplayId(sceneSession.session.persistentId, screenId);
        }
        return sceneSession;
      }
    }
    const sceneSession = this.popSpecialSceneFromOtherScreen(sceneInfo, needBackground);
    if (sceneSession) {
      if (needBackground) {
        this.requestUnfocus(sceneSession.session.persistentId, FocusChangeReason.BACKGROUND);
      }
      if (needUpdateScreenId) {
        this.updateSessionDisplayId(sceneSession.session.persistentId, screenId);
      }
      return sceneSession;
    }
    return undefined;
  }

  /**
   * register Get Not Show Recent Container Session List Callback
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public registerGetContainerSessionListNotShowRecentCallback(callback: Function, screenId?: number): void {
    log.showDebug(`registerGetContainerSessionListNotShowRecentCallback screenId:${screenId}`);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.getContainerSessionListNotShowRecentCallback.set(screenId, callback);
  }

  /**
   * unregister Get Not Show Recent Container Session List Callback
   *
   * @param screenId
   */
  public unregisterGetContainerSessionListNotShowRecentCallback(screenId?: number): void {
    log.showDebug(`unregisterGetContainerSessionListNotShowRecentCallback screenId:${screenId}`);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.getContainerSessionListNotShowRecentCallback.delete(screenId);
  }

  /**
   * get Container Session List
   *
   * @param { Number } screenId
   * @returns { SCBSceneContainerSessionArray }
   */
  public getContainerSessionListNotShowRecent(screenId?: number): SCBSceneContainerSessionArray {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let callback = this.getContainerSessionListNotShowRecentCallback.get(screenId);
    if (callback && callback instanceof Function) {
      return callback();
    }
    return new SCBSceneContainerSessionArray();
  };

  /**
   * whether is in notShowRecentList
   *
   * @param { number } screenId
   * @param { number } persistentId
   * @returns { number } Returns the index found, or -1 if not found
   */
  public getInNotShowRecentIndex(screenId: number, persistentId: number): number {
    let list = this.getContainerSessionListNotShowRecent(screenId);
    if (list === null) {
      log.showError(`getContainerSessionListNotShowRecent null`);
      return -1;
    }
    return list.findIndexByPersistentId(persistentId);
  }

  /**
   * register Add Extend Not Show Recent Container Session Callback
   *
   * @param callback
   * @param screenId
   */
  public registerAddExtendNotShowRecentContainerSessionCallback(callback: Function, screenId?: number): void {
    log.showDebug(`registerAddExtendNotShowRecentContainerSessionCallback screenId:${screenId}`);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.addExtendNotShowRecentContainerSessionCallback.set(screenId, callback);
  }

  /**
   * unregister Add Extend Not Show Recent Container Session Callback
   *
   * @param screenId
   */
  public unregisterAddExtendNotShowRecentContainerSessionCallback(screenId?: number): void {
    log.showDebug(`unregisterAddExtendNotShowRecentContainerSessionCallback screenId:${screenId}`);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.addExtendNotShowRecentContainerSessionCallback.delete(screenId);
  }

  /**
   * 添加扩展屏的隐藏启动相containerSessionList到对应的屏幕
   *
   * @param list_
   * @param screenId
   * @param extendScreenId
   */
  public onAddExtendNotShowRecentContainerSession(list_: SCBSceneContainerSessionArray,
    extendScreenId: number, screenId?: number): void {
    log.showInfo(`add extend not show recent container session screenId: ${screenId}`);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let callback = this.addExtendNotShowRecentContainerSessionCallback.get(screenId);
    if (callback && callback instanceof Function) {
      callback(list_, extendScreenId);
    }
  }

  /**
   * get Container Session List
   *
   * @param { Number } screenId
   * @returns { SCBSceneContainerSessionArray }
   */
  public getContainerSessionList = (screenId?: number): SCBSceneContainerSessionArray => {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.getContainerSessionListCallback.get(screenId)) {
      return (this.getContainerSessionListCallback.get(screenId))();
    }
    log.showWarn(`get Container Session List with screenId: ${screenId} failed`);
    return new SCBSceneContainerSessionArray();
  };

  public getAllContainerSessionList(): SCBSceneContainerSessionArray {
    if (this.getAllContainerSessionListCallback) {
      return this.getAllContainerSessionListCallback();
    } else {
      log.showInfo('no a-c-s cb');
      return this.getContainerSessionList();
    }
  }

  /**
   * set whether Start Recovery
   *
   * @param { Boolean } isStartRecovery
   * @param { number } screenId
   */
  public setStartRecovery(isStartRecovery: Boolean, screenId: number = this.mainScreenId): void {
    try {
      if (systemParameterEnhance.getSync('window.recovery.disabled', 'false') === 'true') {
        WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'window.recovery.disabled');
        return;
      }
    } catch (error) {
      WinLog.showWarn(WinLogDomain.WMS_RECOVER, `setStartRecovery failed, code: ${error.code}, message: ${error.message}`);
    }
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `setStartRecovery ${isStartRecovery}, sceneSessionList.length: ` +
      `${this.recoverSceneSessionList.get(screenId)?.length}, screenid: ${screenId}`);
    this.isStartRecoverySet.add(screenId);
    while (this.recoverSceneSessionList.get(screenId)?.length > 0 && !this.getScenePersistent().getRecoverFinished() &&
      this.recoverSessionCallbackMap.has(screenId)) {
      const info = this.recoverSceneSessionList.get(screenId).pop();
      const sceneSession = info[0];
      const sceneInfo = info[1];
      this.onRecoverSession(sceneSession, sceneInfo);
    }
    this.recoverSceneSessionList.delete(screenId);
  }

  /**
   * Handle the removal of the extended screen during independent recovery
   */
  public handleExtendScreenSessionRecover(): void {
    if (!DeviceHelper.isPC()) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, `Only PC have extend screen!`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `handleExtendScreenSessionRecover begin`);
    for (let screenId of this.recoverSceneSessionList.keys()) {
      if (screenId === this.mainScreenId) {
        continue;
      }
      while (this.recoverSceneSessionList.get(screenId)?.length > 0 &&
        !this.getScenePersistent().getRecoverFinished() && this.recoverSessionCallbackMap.has(this.mainScreenId)) {
        const info = this.recoverSceneSessionList.get(screenId).pop();
        const sceneSession = info[0];
        const sceneInfo = info[1];
        sceneSession.screenId = this.mainScreenId;
        sceneInfo.screenId = this.mainScreenId;
        this.updateSessionDisplayId(sceneSession.persistentId, this.mainScreenId);
        this.onRecoverSession(sceneSession, sceneInfo);
      }
    }
  }

  /**
   * Set VMA status for Multi-window, Auto-off after 600 frames
   * @param flag
   * @param reason
   */
  public setVmaCacheStatus(flag: boolean, reason: string): void {
    log.showInfo(`setVmaCacheStatus flag: ${flag}, reason: ${reason}`);
    sceneSessionManager.setVmaCacheStatus(flag);
  }

  /**
   * Callback that recovers the containerSessionList
   * @param sceneInfo
   * @param sceneSession
   */
  private onRecoverSession(sceneSession: sceneSessionManager.SceneSession,
                           sceneInfo: sceneSessionManager.SceneRecoverInfo): void {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `onRecoverSession presistentid: ${sceneSession.persistentId}, ` +
      `screenId: ${sceneSession.screenId}`);
    if (!this.recoverSessionCallbackMap.has(sceneSession.screenId)) {
      return;
    }
    SCBRecoverManager.getInstance().addRecoveredSession(sceneSession.persistentId, sceneInfo);
    try {
      const recoverSessionCallback = this.recoverSessionCallbackMap.get(sceneSession.screenId);
      recoverSessionCallback(sceneSession, sceneInfo);
      WinLog.showDebug(WinLogDomain.WMS_RECOVER, `RecoverSessionCallback, id: ${sceneSession.persistentId}`);
    } catch (error) {
      WinLog.showWarn(WinLogDomain.WMS_RECOVER, `RecoverSessionCallback error, code: ${error.code}, message: ${error.message}`);
      return;
    }
    if (sceneInfo.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE) {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `${sceneInfo.bundleName} is active, save it to activeSessionList`);
      this.saveActiveSession(sceneSession);
    }

    if (!!sceneInfo.transitionAnimationMap) {
      let containerSession = this.getSceneContainerSessionFromScenePanel(sceneSession.persistentId);
      if (containerSession?.primarySession !== undefined) {
        for (const key in sceneInfo.transitionAnimationMap) {
          containerSession.primarySession.sessionData.transitionAnimationConfig.set(Number(key),
            sceneInfo.transitionAnimationMap[key]);
          WinLog.showInfo(WinLogDomain.WMS_ANIMATION, `transitionType: ${key}, transitionAnimation: ` +
            JSON.stringify(sceneInfo.transitionAnimationMap[key]));
        }
      }
    }

    /**
     * The logic of the watch is different from that of the mobile phone:
     * On the phone, independent recovery is to enter the lock screen, all foreground windows to the background.
     * The watch returns to the application screen that you want to restore.
     */
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `DeviceHelper.isWatch: ${DeviceHelper.isWatch()}`);
    if (!DeviceHelper.isWatch()) {
      let containerSession = this.getSceneContainerSessionFromScenePanel(sceneSession.persistentId);
      containerSession?.requestBackground();
      this.updateScenePanelState(this.mainScreenId, this.panelZIndex.scenePanel, ScenePanelState.HOME);
    }
  }

  /**
   * register Recover Session Callback
   *
   * @param { Function } callback
   * @param { number } screenId
   */
  public registerRecoverSessionCallback(callback: Function, screenId: number = this.mainScreenId): void {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `registerRecoverSessionCallback screenId: ${screenId}`);
    this.recoverSessionCallbackMap.set(screenId, callback);
  }

  /**
   * unRegister Recover Session Callback
   *
   * @param reason { number } screenId
   */
  public unRegisterRecoverSessionCallback(screenId: number): void {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `unRegisterRecoverSessionCallback screenId: ${screenId}`);
    this.recoverSessionCallbackMap.delete(screenId);
  }

  /**
   * register Start Scene Rotation Callback
   *
   * @param { Function } callback
   */
  public registerStartSceneWithRotationIfNeedCallback(callback: Function): void {
    this.startSceneWithRotationIfNeedCallback = callback;
  }

  /**
   * unRegister start scene with rotation if need callback
   */
  public unRegisterStartSceneWithRotationIfNeedCallback(): void {
    log.showDebug(TAG, 'unRegisterStartSceneWithRotationIfNeedCallback is called');
    this.startSceneWithRotationIfNeedCallback = null;
  }

  /**
   * register SpecialScenePanel StartSceneWithRotationIfNeed Callback
   *
   * @param { Function } callback
   */
  public registerSpecialScenePanelStartSceneWithRotationIfNeedCallback(callback: Function): void {
    this.specialScenePanelStartSceneWithRotationIfNeedCallback = callback;
  }

  /**
   * register SpecialScenePanel ExitSceneWithRotationRecover Callback
   *
   * @param { Function } callback
   */
  public registerSpecialScenePanelExitSceneWithRotationRecoverCallback(callback: Function): void {
    this.specialScenePanelExitSceneWithRotationRecoverCallback = callback;
  }

  /**
   * unregister SpecialScenePanel ExitSceneWithRotationRecover Callback
   */
  public unregisterSpecialScenePanelExitSceneWithRotationRecoverCallback(): void {
    this.specialScenePanelExitSceneWithRotationRecoverCallback = null;
  }

  /**
   * register Get Special Container Session List Callback
   *
   * @param { Function } callback
   */
  public registerGetSpecialContainerSessionListCallback(callback: Function): void {
    this.getSpecialContainerSessionListCallback = callback;
  }

  /**
   * unregister Get Special Container Session List Callback
   */
  public unregisterGetSpecialContainerSessionListCallback(): void {
    this.getSpecialContainerSessionListCallback = null;
  }

  /**
   * register Get Floating Session List Callback
   *
   * @param { Function } callback
   */
  public registerGetFloatingSessionListCallback(callback: Function): void {
    this.getFloatingSessionListCallback = callback;
  }

  /**
   * register Get Side Edge Session List Callback
   *
   * @param { Function } callback
   */
  public registerGetSideEdgeSessionListCallback(callback: Function): void {
    this.getSideEdgeSessionListCallback = callback;
  }

  /**
   * unregister Get Side Edge Session List Callback
   */
  public unregisterGetSideEdgeSessionListCallback(): void {
    this.getSideEdgeSessionListCallback = null;
  }

  /**
   * register Clear Additional Callers Callback
   *
   * @param { Function } callback
   */
  public registerClearAdditionalCallersCallback(callback: Function): void {
    this.clearAdditionalCallersCallback = callback;
  }

  /**
   * unregister Additional Callers Callback
   *
   */
  public unregisterClearAdditionalCallersCallback(): void {
    this.clearAdditionalCallersCallback = null;
  }

  /**
   * register Get multiWindow DialogSession Callback
   *
   * @param { SCBSystemSceneSession } callback
   */
  public registerGetDialogSessionCallback(callback: SCBSystemSceneSession): void {
    this.getMultiWindowDialogSession = callback;
  }

  /**
   * get Special Container Session List
   *
   * @returns { SCBSceneContainerSessionArray }
   */
  public getSpecialContainerSessionList = (): SCBSceneContainerSessionArray => {
    if (this.getSpecialContainerSessionListCallback) {
      return this.getSpecialContainerSessionListCallback();
    }
    return new SCBSceneContainerSessionArray();
  };

  public getFloatingSessionList = (): SCBSceneContainerSessionArray => {
    if (this.getFloatingSessionListCallback) {
      return this.getFloatingSessionListCallback();
    }
    return new SCBSceneContainerSessionArray();
  };

  /**
   *  interrupt windowScene return Link
   *
   */
  public execAdditionalCallersCallback(): void {
    if (this.clearAdditionalCallersCallback === null) {
      log.showError(TAG, `clearAdditionalCallback callback is null`);
      return;
    }
    let sceneContainerSession: SCBSceneContainerSession | null =
      SCBSceneSessionManager.getInstance().getContainerSessionList()?.getTopActiveSession();
    if (sceneContainerSession?.primarySession?.sceneInfo?.additionalCallers &&
      sceneContainerSession?.primarySession?.sceneInfo?.additionalCallers?.length !== 0) {
      this.clearAdditionalCallersCallback(sceneContainerSession.primarySession, true);
    }
  }

  /**
   * get Side Edge Session List
   *
   * @returns { SCBSceneContainerSessionArray }
   */
  public getSideEdgeSessionList = (): SCBSceneContainerSessionArray => {
    if (this.getSideEdgeSessionListCallback) {
      return this.getSideEdgeSessionListCallback();
    }
    return new SCBSceneContainerSessionArray();
  };

  /**
   * register Get Specific Container Session List Callback
   *
   * @param { Function } callback
   * @param { Number } zorder
   */
  public registerGetSpecificContainerSessionListCallback(callback: Function, zorder: number, screenId: number = this.mainScreenId): void {
    if (!this.getSpecificContainerSessionListCallbackMap.has(screenId)) {
      this.getSpecificContainerSessionListCallbackMap.set(screenId, new Map<number, Function>());
    }
    this.getSpecificContainerSessionListCallbackMap.get(screenId).set(zorder, callback);
  }

  /**
   * unregister Get Specific Container Session List Callback
   *
   * @param zorder
   * @param screenId
   */
  public unregisterGetSpecificContainerSessionListCallback(zorder: number, screenId: number = this.mainScreenId): void {
    this.getSpecificContainerSessionListCallbackMap.get(screenId)?.delete(zorder);
  }

  /**
   * register Enter Recent For Float Callback
   *
   * @param { Function } callback
   */
  public registerEnterRecentForFloatCallback(callback: Function): void {
    this.specificScenePanelEnterRecentCallback = callback;
  }

  /**
   * register Exit Recent For Float Callback
   *
   * @param { Function } callback
   */
  public registerExitRecentForFloatCallback(callback: Function): void {
    this.specificScenePanelExitRecentCallback = callback;
  }

  /**
   * notify Enter Recent For Float
   */
  public notifyEnterRecentForFloat(): void {
    if (this.specificScenePanelEnterRecentCallback) {
      this.specificScenePanelEnterRecentCallback();
    }
  }

  /**
   * notify Exit Recent For Float
   */
  public notifyExitRecentForFloat(): void {
    if (this.specificScenePanelExitRecentCallback) {
      this.specificScenePanelExitRecentCallback();
    }
  }

  /**
   * get Specific Container Session List
   *
   * @param { Number } zorder
   * @returns { SCBSpecificSceneSessionList }
   */
  public getSpecificContainerSessionList(zorder: number, screenId: number = this.mainScreenId): SCBSpecificSceneSessionList {
    if (!this.getSpecificContainerSessionListCallbackMap.has(screenId)) {
      log.showError(TAG, `getSpecificContainerSessionListCallbackMap does not have screenId ${screenId}`);
      return [];
    }
    const callbackMap = this.getSpecificContainerSessionListCallbackMap.get(screenId);
    if (callbackMap.has(zorder)) {
      return callbackMap.get(zorder)();
    }
    return [];
  }

  private getSpecificContainerSessionListFunc(zorder: number, screenId: number = this.mainScreenId): Function {
    return () => {
      if (!this.getSpecificContainerSessionListCallbackMap.has(screenId)) {
        log.showError(TAG, `getSpecificContainerSessionListFunc does not have screenId ${screenId}`);
        return [];
      }
      const funcMap = this.getSpecificContainerSessionListCallbackMap.get(screenId);
      if (funcMap.has(zorder)) {
        return funcMap.get(zorder)();
      }
      return [];
    };
  }

  /**
   * set System Session Map
   *
   * @param { String } fakeName
   * @param { String } name
   */
  public setSystemSessionMap(fakeName: string, name: string): void {
    this.systemSessionMap.set(fakeName, name);
  }

  /**
   * delete System Session Map
   *
   * @param { String } name
   */
  public deleteSystemSessionMap(name: string): void {
    this.systemSessionMap.delete(name);
  }

  /**
   * @param fakeName: name with number
   * @param id persistentId
   * set System Session name-id Map
   */
  public setSysSessionNameIdMap(fakeName: string, id: number): void {
    this.sysSessionNameIdMap.set(fakeName, id);
  }

  /**
   * delete id from Map
   * @param { String } fakeName: name with number
   */
  public deleteFromSysSessionNameIdMap(fakeName: string): void {
    this.sysSessionNameIdMap.delete(fakeName);
  }

  public static isLargeInFoldProduct(): boolean {
    return isLargeInFoldProduct;
  }

  /**
   * @param fakeName
   * @param id persistentId
   * set System Session name-id Map
   */
  public getIdFromSysSessionNameIdMap(name: string): number {
    let id: number | null = null;
    const map = this.sysSessionNameIdMap;
    if (map.has(name)) {
      return map.get(name);
    }
    map.forEach((value, fakeName) => {
      if (id !== null) {
        return;
      }
      const key = fakeName.replace(/\d+$/, '');
      if (key === name) {
        id = value;
      }
    });
    return id;
  }

  /**
   * init System Scene List
   *
   * @param screenId
   */
  public initSystemSceneList(screenId: number): void {
    if (!this.systemSceneList.get(screenId)) {
      this.systemSceneList.set(screenId, []);
    }
    sceneSessionManager.on('outsideDownEvent', ({ x, y }) => {
      this.systemSceneList.get(screenId)?.forEach((systemScene) => {
        let sceneRect = systemScene.currRect;
        if ((!CheckEmptyUtils.isEmpty(systemScene.sessionChangeCallback) || systemScene.hasTouchOutsideCallback()) &&
          !sceneRect.contains(x, y)) {
          systemScene.sessionChangeCallback?.onTouchOutside(x, y);
          systemScene.notifyTouchOutside(x, y);
        };
      });
    });
  }

  // keep order
  private addSystemSceneToList(sysSceneSession: SCBSystemSceneSession, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (!this.systemSceneList.get(screenId)) {
      this.systemSceneList.set(screenId, []);
    }
    let idx = this.systemSceneList.get(screenId).findIndex((scbSession) => scbSession.zIndex > sysSceneSession.zIndex);
    if (idx === -1) {
      idx = this.systemSceneList.get(screenId).length;
    }
    this.systemSceneList.get(screenId).splice(idx, 0, sysSceneSession);
    this.refreshZOrder();
  }

  private removeSystemSceneFromList(sysSceneSession: SCBSystemSceneSession, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let idx = this.systemSceneList.get(screenId)?.findIndex(
      (scbSession) => scbSession.session.persistentId === sysSceneSession.session.persistentId
    );
    if (idx !== -1) {
      this.systemSceneList.get(screenId)?.splice(idx, 1);
    }
    return;
  }

  /**
   * sort System Scene
   *
   * @param screenId
   */
  public sortSystemScene(screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.systemSceneList.get(screenId)?.sort((scbSession1, scbSession2) => scbSession1.zIndex - scbSession2.zIndex);
    this.refreshZOrder();
    return;
  }

  /**
   * get Panel ZIndex
   *
   * @returns { ScbPanelZIndex }
   */
  public getPanelZIndex(): ScbPanelZIndex {
    return this.panelZIndex;
  }

  /**
   * get Record Start Time
   *
   * @returns { number }
   */
  public getRecordStartTime(): number {
    return this.recordStartTime;
  }

  /**
   * update Record Start Time
   *
   * @param curTime
   */
  public updateRecordStartTime(curTime: number): void {
    this.recordStartTime = curTime;
  }

  /**
   * set Panel Lists
   *
   * @param screenId
   */
  public setPanelLists = (screenId?: number): void => {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.panelLists.set(screenId, [
      [this.panelZIndex.bottom, (): Array<SCBSceneSession> => { return []; }],
      [this.panelZIndex.scenePanel, this.getContainerSessionListFunc(screenId)],
      [this.panelZIndex.floatingScenePanel, this.getFloatingSessionList],
      [this.panelZIndex.mutiScreenCollaboration, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.MUTISCREEN_COLLABORATION)],
      [this.panelZIndex.specificAboveScenePanel, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.ABOVE_SCENE_PANEL)],
      [this.panelZIndex.pipScenePanel, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.PIP_PANEL)],
      [this.panelZIndex.floatingBall, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.FLOATING_BALL)],
      [this.panelZIndex.typeFloat, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.TYPE_FLOAT)],
      [this.panelZIndex.inputMethodStatusBar, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR)],
      [this.panelZIndex.specificAboveSystemUI, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.ABOVE_SYSTEMUI, screenId)],
      [this.panelZIndex.specialScenePanel, this.getSpecialContainerSessionList],
      [this.panelZIndex.voiceInteraction, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.VOICE_INTERACTION)],
      [this.panelZIndex.floatNavigation, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.FLOAT_NAVIGATION)],
      [this.panelZIndex.specificMeidaControlTemp, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.MEDIA_CONTROL_TEMP)],
      [this.panelZIndex.specificAboveKeyguard, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.ABOVE_KEYGUARD)],
      [this.panelZIndex.volume, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.VOLUME)],
      [this.panelZIndex.systemToast, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.SYSTEM_TOAST)],
      [this.panelZIndex.screenshot, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.SCREENSHOT)],
      [this.panelZIndex.screenControl, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.SCREEN_CONTROL)],
      [this.panelZIndex.walletSwipeCard, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.WALLET_SWIPE_CARD)],
      [this.panelZIndex.dynamic, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.DYNAMIC)],
      [this.panelZIndex.top, (): Array<SCBSceneSession> => { return []; }],
      [this.panelZIndex.magnification, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.MAGNIFICATION)],
      [this.panelZIndex.magnificationMenu, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.MAGNIFICATION_MENU)],
      [this.panelZIndex.typeSelection, this.getSpecificContainerSessionListFunc(SpecificPanelZOrder.TYPE_SELECTION)],
    ]);
  };

  public getContainerSessionListFunc(screenId?: number): Function {
    return () => {
      log.showDebug(`getContainerSessionListFunc screenId: ${screenId}`);
      return this.getContainerSessionList(screenId);
    };
  };

  private constructor() {
    systemParameter.setSync('bootevent.wms.started', 'true');
    sEventManager.subscribe(FWEventConstants.START_SERVICE, StartAbilityUtil.startAbilityFromOther);
    sEventManager.subscribe(FWEventConstants.START_SERVICE_EXT, StartAbilityUtil.startServiceExtensionAbility);
    this.rootSceneSession = new SCBRootSceneSession();
    this.scenePersistent = new SCBScenePersistent();
    this.maxTraverseDuration = 0; // us
    // register native function for create specific session
    sceneSessionManager.on('createSpecificSession', (specificSession) => {
      this.onCreateSpecificSession(specificSession);
    });

    // register native function for create keyboard session
    sceneSessionManager.on('createKeyboardSession', (keyboardSession, panelSession) => {
      SCBKeyboardManager.getInstance().onCreateKeyboardAndPanelSession(keyboardSession, panelSession);
    });

    sceneSessionManager.on('recoverSceneSession', (sceneSession, sessionInfo) => {
      this.onRecoverSceneSession(sceneSession, sessionInfo);
    });

    sceneSessionManager.on('shiftFocus', (nextId: number, displayId: number) => {
      this.onShiftFocus(nextId, displayId);
    });

    // sceneSessionManager.on('callingWindowIdChange', (callingWindowId: number) => {
    //   SCBKeyboardManager.getInstance().onCallingSessionIdChange(callingWindowId);
    //   SCBKeyboardManager.getInstance().notifyVirtualScreenCallingSessionChange(callingWindowId);
    // });

    sceneSessionManager.on('startUIAbilityError', (result: number) => {
      if (result === SCBConstants.START_ABILITY_ENTERPRISE_LIMIT) {
        AppStorage.setOrCreate('isShowEnterpriseAlertDialog', true);
      } else {
        AppStorage.setOrCreate('isShowEnterpriseAlertDialog', false);
      }
    });

    sceneSessionManager.on('closeTargetFloatWindow', (bundleName: string) => {
      log.showInfo(`closeTargetFloatWindow ${bundleName}`);
      this.closeTargetFloatWindow(bundleName);
    });

    sceneSessionManager.on('abilityManagerCollaboratorRegistered', () => {
      log.showInfo('Ability manager collaborator registered');
      this.getAllAbilityList(this.mCurrentUserId);
    });

    sceneSessionManager.on('startPiPFailed', (screenId: number) => {
      this.notifyStartPiPFailed(screenId);
    });

    sceneSessionManager.on('setForegroundWindowNum', (windowNum: number) => {
      this.maxForegroundWindowNum = windowNum;
      this.maxForegroundWindowNumChangeCallbacks.forEach(item => item?.(windowNum));
    });

    sceneSessionManager.on('minimizeByWindowId', (windowIds: number[]) => {
      this.minimizeByWindowIdsCallbacks.forEach(item => item?.(windowIds));
    });

    try {
      sceneSessionManager.on('updateAppUseControl',
        (type: ControlType, userId: number, controlInfos : ControlAppInfo[]) => {
        log.showDebug(`[UseControl]updateControlAppInfo, type:${type} controlInfos:${JSON.stringify(controlInfos)}`);
        SCBAppUseControlManager.getInstance().updateControlAppInfo(type, controlInfos);
      });
    } catch (err) {
      log.showError('[UseControl]Fail to register update app use control callback');
    }

    try {
      display.on('foldStatusChange', (foldStatus: display.FoldStatus) => {
        this.lastfoldStatus = foldStatus;
      });
    } catch (err) {
      log.showError('Fail to register display foldStatusChange callback.');
    }

    // register app install or remove callback
    EvtBus.on(PackageCommonEvent, this.handlePackageEvent.bind(this));

    // register user change event
    EvtBus.on(AccountEvent, (event) => this.setCurrentUserId(event?.accountInfo?.localId));

    this.registerUnlockTransitionController();
    this.setDeviceType();


    this.supportPcMode = false;
  }

  private registerUnlockTransitionController(): void {
    this.unLockTransitionController = {
      name: `${TAG}`,
      onLock: this.onLockReceived.bind(this),
      onUnlock: this.onUnLockReceived.bind(this),
      onUnlockStartScene: this.onUnlockStartSceneReceived.bind(this),
      onUnlockAnimation: this.onUnlockAnimationReceived.bind(this)
    };
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
  }

  // init fold crease region when screen connected
  public onScreenConnect(screenSession: SCBScreenSession): void {
    log.showInfo(`onScreenConnect screenId: ${screenSession.session.screenId}`);
    SCBSceneMissionManager.getInstance().notifyScreenStateChange(screenSession.session.screenId, true);
  }

  public onScreenDisconnect(screenId: number, displayGroupId: number = 0): void {
    log.showInfo(`onScreenDisconnect screenId: ${screenId}`);
    this.windowFocusController.removeFocusGroup(screenId, displayGroupId);
    SCBSceneMissionManager.getInstance().notifyScreenStateChange(screenId, false);
    this.lastSystemBarPropertyMap.delete(screenId);
  }

  private getCurBigScreenStatusFromDisplay(): screenSessionManager.BigScreenStatus {
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (error) {
      log.showError(`getCurBigScreenStatusFromDisplay error.code: ${error?.code}, error.message: ${error?.message}`);
      return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_UNKNOWN;
    }

    // if (!foldStatus || foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN) {
    //   return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_UNKNOWN;
    // }

    switch (foldStatus) {
      // case display.FoldStatus.FOLD_STATUS_EXPANDED:
      //   return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_EXPANDED;
      // case display.FoldStatus.FOLD_STATUS_FOLDED:
      //   return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_FOLDED;
      // case display.FoldStatus.FOLD_STATUS_HALF_FOLDED:
      //   return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_HALF_FOLDED;
      default:
        return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_UNKNOWN;
    }
  }

  public getCurBigScreenStatus(): screenSessionManager.BigScreenStatus {
      return screenSessionManager.BigScreenStatus.BIG_SCREEN_STATUS_UNKNOWN;
  }

  public isInFoldExpanedStatus(): boolean {
    if (!this.isPc()) {
      return false;
    }
    // let foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    // try {
    //   foldStatus = display.getFoldStatus();
    // } catch (error) {
    //   log.showError(`getFoldStatus error: ${error?.code}-${error?.message}`);
    // }
    // if (!foldStatus || foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN) {
    //   return false;
    // }
    // return foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED;
    return false;
  }

  public isInBigScreenStatus(): boolean {
    if (!this.isPc()) {
      return false;
    }
    // let foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    // try {
    //   foldStatus = display.getFoldStatus();
    // } catch (error) {
    //   log.showError(`getFoldStatus error: ${error?.code}-${error?.message}`);
    // }
    // if (!foldStatus || foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN) {
    //   return false;
    // }
    // return foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
    return false;
  }

  /**
   * add Active Session List
   *
   * @param persistentId
   */
  public addActiveSessionList(persistentId: number): void {
    log.showInfo(`add active id: ${persistentId}, len: ${this.activeSessionList.length}`);
    if (this.activeSessionList.includes(persistentId)) {
      log.showDebug('Already in activeSessionList.');
      return;
    }
    this.activeSessionList.push(persistentId);
  }

  /**
   * remove Active Session List
   *
   * @param persistentId
   */
  public removeActiveSessionList(persistentId: number): void {
    log.showInfo(`remove active id: ${persistentId}, len: ${this.activeSessionList.length}`);
    let index = this.activeSessionList.findIndex((activeId) => {
      return activeId === persistentId;
    });
    if (index === -1) {
      log.showDebug('Not in activeSessionList.');
      return;
    }
    this.activeSessionList.splice(index, 1);
  }

  /**
   * clear Active Session List
   *
   */
  public clearActiveSessionList(): void {
    log.showInfo(`clear active ids: ${this.activeSessionList.join(',')}`);
    this.activeSessionList.splice(0, this.activeSessionList.length);
  }

  /**
   * check whether the list is empty.
   *
   * @returns { boolean }
   */
  public checkActiveSessionListIsEmpty(): boolean {
    if (this.activeSessionList.length === 0) {
      return true;
    } else {
      log.showInfo(`activeSessionList length ${this.activeSessionList.length}`);
      return false;
    }
  }

  /**
   * get Active Session List
   *
   * @return active Session List
   */
  public getActiveSessionList(): number[] {
    return this.activeSessionList;
  }

  /**
   * register Unlock Transition Callback
   *
   * @param controller
   */
  public registerUnlockTransitionCallback(controller: SCBUnlockTransitionController | null): void {
    if (!controller) {
      return;
    }
    let index = this.unlockTransitionCallbacks.indexOf(controller);
    if (index === -1) {
      this.unlockTransitionCallbacks.push(controller);
    }
  }

  /**
   * unregister Unlock Transition Callback
   *
   * @param controller
   */
  public unregisterUnlockTransitionCallback(controller: SCBUnlockTransitionController | null): void {
    if (!controller) {
      return;
    }
    let index = this.unlockTransitionCallbacks.indexOf(controller);
    if (index !== -1) {
      this.unlockTransitionCallbacks.splice(index, 1);
    }
  }

  private setDeviceType(): void {
    try {
      settings.setValue(
        GlobalContext.getContext(),
        SettingsKeyConstants.DEVICE_TYPE,
        DeviceHelper.DEVICE_TYPE,
        settings.domainName.DEVICE_SHARED
      )
        .then((result: boolean) => {
          if (result) {
            log.showInfo(`Set device type: ${DeviceHelper.DEVICE_TYPE}, settings set result: ${result}`);
          } else {
            log.showWarn(`Set device type: ${DeviceHelper.DEVICE_TYPE}, settings set result: ${result}`);
          }
        })
        .catch((err: Error) => {
          log.showError(`Set device type failed!, err msg: ${err?.message}`);
        });
    } catch (err) {
      log.showError(`Set device type setValue fail, catch err msg: ${(err as BusinessError)?.message}`);
    }
  }

  /**
   * Handle user switch event from AccountManager
   */
  public handleUserSwitchEvent(eventType: UserSwitchEventType, userId: number): void {
    if (this.mCurrentUserId === DEFAULT_USERID) {
      WinLog.showError(WinLogDomain.WMS_MULTI_USER, `Current userId not initialized yet.`);
      return;
    }
    const isUserActive: boolean = userId === this.mCurrentUserId;
    WinLog.showInfo(WinLogDomain.WMS_MULTI_USER, `Handle user switch event, eventType: ${eventType}, switchToUserId: ${userId} ` +
                 `currentUserId: ${this.mCurrentUserId}, isUserActive: ${isUserActive}`);
    if (eventType === UserSwitchEventType.SWITCHING) {
      this.handleUserSwitching(isUserActive);
    } else if (eventType === UserSwitchEventType.SWITCHED) {
      this.refreshAvailableArea(this.mainScreenId, true);
    }
    sceneSessionManager.handleUserSwitch(eventType, isUserActive);
  }

  private handleUserSwitching(isUserActive: boolean): void {
    EvtBus.post(UserSwitchEvent, { userActive: isUserActive });
    if (!isUserActive) {
      return;
    }
    sceneSessionManager.initScheduleUtils();
  }

  public getCurrentDensityDpi(): number {
    let displayClass: display.Display | null = null;
    let currentDensityDpi: number = -1;
    try {
      displayClass = display.getDefaultDisplaySync();
      currentDensityDpi = displayClass.densityDPI;
    } catch (err) {
      log.showError(`getCurrentDensityDpi failed: ${err.message}`);
    }
    return currentDensityDpi;
  }

  /**
   * set projection bundleName
   * @param bundleName
   */
  public setProjectionBundleName(bundleName: string, screenId: number): void {
    log.showInfo(`setProjectionBundleName bundleName = ${bundleName}, screenId = ${screenId}`);
    this.currentProjectionBundleName = bundleName;
    this.projectionScreenId = screenId;
  }

  /**
   * get projection bundleName
   * @param bundleName
   */
  public isProjectionBundleName(bundleName: string): boolean {
    log.showInfo(`isProjectionBundleName bundleName = ${bundleName}, screenId = ${this.projectionScreenId}`);
    if (this.projectionScreenId === 0 || CheckEmptyUtils.isEmpty(bundleName)) {
      return false;
    }
    try {
      let displayClass = display.getDisplayByIdSync(this.projectionScreenId);
      if (CommonUtils.isInvalid(displayClass) || displayClass.name !== 'PadWithCar') {
        return false;
      }
    } catch (err) {
      log.showError(`isProjectionBundleName get display failed: ${err.message}`);
      return false;
    }
    if (bundleName === this.currentProjectionBundleName) {
      log.showInfo('isProjectionBundleName: current bundle is projection');
      return true;
    }
    return false;
  }

  /**
   * is support pc mode or not
   *
   * @returns {boolean}.
   */
  public isSupportPcMode(): boolean {
    return this.supportPcMode;
  }

  public isPc(): boolean {
    return SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PC ||
      DeviceHelper.is2In1DevicePcType();
  }

  /**
   * 判断是否自由多窗模式
   *
   * @returns {boolean}
   */
  public isPcMode(): boolean {
    return this.supportPcMode && this.isInPcMode;
  }

  public isPcOrPcMode(): boolean {
    return this.isPc() || this.isPcMode();
  }

  public isFullSceneMode(): boolean {
    return !this.supportPcMode || !this.isInPcMode;
  }

  /**
   * setTogglePcModeActionFunc, set function for sceneSessionManager to call toggle pc mode
   *
   * @param toggleFunc, action function to call toggle pc mode.
   */
  public setTogglePcModeActionFunc(toggleFunc: Function): void {
    this.togglePcModeFunc = toggleFunc;
  }

  /**
   * clearTogglePcModeActionFunc
   *
   */
  public clearTogglePcModeActionFunc(): void {
    this.togglePcModeFunc = null;
  }

  public setUserAuthPassed(passed: boolean): void {
    log.showInfo('notify WMS userAuthPassed: ' + passed);
    sceneSessionManager.setUserAuthPassed(passed);
  }

  public notifyWMSIsLockReceived(isLock: boolean): void {
    log.showInfo('notify WMS isEarlyLock: ' + isLock);
    if (this.isScreenEarlyLock === isLock) {
      return;
    }
    this.isScreenEarlyLock = isLock;
    sceneSessionManager.setScreenLocked(isLock);
    if (this.pipOcclusiveChangeCallback !== null && this.pipOcclusiveChangeCallback !== undefined) {
      this.pipOcclusiveChangeCallback(isLock);
    }
    if (!isLock) {
      viewMgrPolicy.showView(ViewType.DESKTOP);
    }
  }

  private onLockReceived(): void {
    log.showInfo('onLockReceived');
    this.notifyWMSIsLockReceived(true);
    if (this.isScreenLock) {
      return;
    }
    for (let controller of this.unlockTransitionCallbacks) {
      if (!controller) {
        continue;
      }
      controller.onLock();
    }
    this.isScreenLock = true;
    this.reOrderShowWhenLocked(false, undefined, 'OnLockReceived');
    // traverse containerSessionList
    let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    if (!this.isAllScreenContainerSessionToBackground()) {
      containerSessionList = this.getContainerSessionList();
    } else {
      for (let screen of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
        let sessionList = this.getContainerSessionList(screen.session.screenId);
        containerSessionList.push(...sessionList);
      }
    }
    let floatingContainerSessionList = this.getFloatingSessionList();
    log.showInfo(`onLockReceived, containerSessionList length: ${containerSessionList.length}, ` +
      `floatingContainerSessionList length: ${floatingContainerSessionList.length}.`);
    if (!DeviceHelper.isWatch()) {
      for (let item of [...containerSessionList, ...floatingContainerSessionList]) {
        this.transferToBackgroundWhenLocked(item);
      }
    }
    this.updateScenePanelState(this.mainScreenId, this.panelZIndex.scenePanel, ScenePanelState.HOME);
  }

  /**
   * is All Screen ContainerSession To Background
   *
   * @returns
   */
  private isAllScreenContainerSessionToBackground(): boolean {
    return this.isPc();
  }

  /**
   * when locked, containerSession need to requestBackground, and add to the ActiveSessionList
   *
   * @param containerSession is Session of a SceneContainer
   */
  public transferToBackgroundWhenLocked(containerSession : SCBSceneContainerSession,
    backgroundReason: BackgroundReason = BackgroundReason.DEFAULT) : void {
    if (containerSession == null) {
      return;
    }
    if (containerSession.isMidScene) {
      let containerIsActive = Array.from(containerSession.midSceneMap.keys())
        .some(item => containerSession.midSceneMap.get(item).isActive);
      log.showInfo('midScene containerSession isActive: %{public}s , containerIsActive: %{public}s, %{public}s',
        containerSession.isActive, containerIsActive, containerSession.getName());
      if (containerIsActive) {
        Array.from(containerSession.midSceneMap.keys()).forEach(item => {
          this.addActiveSessionList(item);
        });
      }
    } else {
      if ((containerSession.primarySession !== null) &&
        containerSession.primarySession?.isActive &&
        (containerSession.primarySession.session !== null)) {
        this.addActiveSessionList(containerSession.primarySession?.session.persistentId);
      }
      if ((containerSession.secondarySession !== null) &&
        containerSession.secondarySession?.isActive &&
        (containerSession.secondarySession.session !== null)) {
        this.addActiveSessionList(containerSession.secondarySession?.session.persistentId);
      }
    }
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC) {
      containerSession.requestBackground(false, false, false);
    } else {
      containerSession.requestBackground(false, false, true, true, backgroundReason);
    }
  }

  private onUnLockReceived(): void {
    log.showInfo('onUnLockReceived');
    for (let controller of this.unlockTransitionCallbacks) {
      if (!controller) {
        continue;
      }
      controller.onUnlock();
    }
    this.updateSystemBarProperty();
    this.reOrderShowWhenLocked(true, false, 'OnUnLockReceived');
  }

  private onUnlockStartSceneReceived(): void {
    log.showInfo('onUnlockStartSceneReceived');
    this.isScreenLock = false;
    this.notifyWMSIsLockReceived(false);
    sceneMissionInterceptor.onInterceptedFromUnlockToForeground(this.activeSessionList);
    this.requestActivationWhenUnLock();
    for (let controller of this.unlockTransitionCallbacks) {
      if (!controller || !controller.onUnlockStartScene) {
        continue;
      }
      controller.onUnlockStartScene();
    }
  }

  private onUnlockAnimationReceived(): void {
    log.showInfo('onUnlockAnimationReceived');
    for (let controller of this.unlockTransitionCallbacks) {
      if (!controller || !controller.onUnlockAnimation) {
        continue;
      }
      controller.onUnlockAnimation();
    }
  }

  public isResetDesktopScale(): boolean {
    let deviceFoldStatus: display.FoldStatus | undefined;
    try {
      deviceFoldStatus = display.getFoldStatus();
    } catch (error) {
      log.showError(`display getFoldStatus failed: ${error?.message}`);
    }

    const topActiveSession: SCBSceneContainerSession | null = this.getContainerSessionList().getTopActiveSession();
    const topSpecialActiveSession: SCBSceneContainerSession | null = this.getSpecialContainerSessionList().getTopActiveSession();
    const isTopActiveSession: boolean = (topActiveSession && topActiveSession.isActive) ||
      (topSpecialActiveSession && topSpecialActiveSession.isActive);
    if (this.restartOobeIfNeed(isTopActiveSession)) {
      log.showInfo('oobe is enabled, start oobe firstly.');
      return false;
    }
    if (!this.isPcOrPcMode() && isTopActiveSession) {
      return true;
    }
  }


  private requestActivationWhenUnLock(): void {
    // For dualDisplayDevice(Bali/LEM) folded: no need request activation
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (err) {
      log.showError('Fail to call display foldStatus.');
    }

    let topActiveSession = this.getContainerSessionList().getTopActiveSession();
    let topSpecialActiveSession = this.getSpecialContainerSessionList().getTopActiveSession();
    let isTopActiveSession = (topActiveSession && topActiveSession.isActive) ||
                             (topSpecialActiveSession && topSpecialActiveSession.isActive);
    if (this.restartOobeIfNeed(isTopActiveSession)) {
      log.showInfo('oobe is enabled, start oobe firstly.');
      return;
    }
    if (!this.isPcOrPcMode() && isTopActiveSession) {
      log.showInfo(`topActiveSession is isActive, no need to requestActivation, WindowMode:` +
        ` [${topActiveSession?.getContainerWindowMode()},${topSpecialActiveSession?.getContainerWindowMode()}]`);
      this.updateScenePanelState(this.mainScreenId, this.panelZIndex.scenePanel, ScenePanelState.FULLSCENE);
      // float window should request active When UnLock
      if (this.startFloatFromUnlockFunctionCallback) {
        this.startFloatFromUnlockFunctionCallback();
      }
      this.activeSessionList.splice(0, this.activeSessionList.length);
      if (this.startSceneWithRotationIfNeedCallback && topActiveSession && topActiveSession.isActive) {
        log.showInfo(`top session is active, go rotation, sessionName: ${topActiveSession.getName()}`);
        this.startSceneWithRotationIfNeedCallback(topActiveSession);
      }
      this.reLinkOobeIfNeed(topActiveSession, topSpecialActiveSession);
      return;
    }
    this.startSceneFromActiveList();
  }

  private startSceneFromActiveList(): void {
    let panelState = ScenePanelState.HOME;
    let activatedContainerIdSet = new Set<number>();
    for (let activeId of this.activeSessionList) {
      let containerSession: SCBSceneContainerSession;
      for (let screen of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
        containerSession = this.getSceneContainerSessionFromScenePanel(activeId, screen.session.screenId);
        if (containerSession) {
          break;
        }
      }
      if (!containerSession || activatedContainerIdSet.has(containerSession.containerId)) {
        log.showWarn('[SCBMain]container of session id:' + activeId + ' is not shown');
        continue;
      }
      let activeSession = this.getSessionById(activeId);
      if ((activeSession !== null) &&
        (activeSession.sessionState !== sceneSessionManager.SessionState.STATE_DISCONNECT) &&
        (activeSession.session !== null) &&
        ('requestSessionActivation' in activeSession)) {
        log.showInfo('midScene containerId: %{public}d , %{public}s', containerSession.containerId,
          activeSession.getName());
        try {
          panelState = this.handleStartSceneWithRotationCallback(containerSession, panelState);
          containerSession.requestActivation(false, ActiveReason.UNLOCK);
          activatedContainerIdSet.add(containerSession.containerId);
          this.requestToTopWhenUnLock(activeSession.sceneInfo.screenId, activeId);
        } catch (err) {
          log.showError(`requestSceneSessionActivation ${activeId} failed: ${err.message}`);
        }
        if (this.getContainerSessionList().findByContainerId(containerSession.containerId)) {
          containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'onUnlock', containerSession.getName());
        }
        // sideEdgeBar session no need interactive
        if (containerSession.mainSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
          containerSession.floatingParam.isMinimized) {
          containerSession.notifyForegroundInteractiveStatus(false);
        }
      }
    }
    if (panelState === ScenePanelState.FULLSCENE) {
      SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.OPEN_APP);
    }
    this.updateScenePanelState(this.mainScreenId, this.panelZIndex.scenePanel, panelState);
    this.activeSessionList.splice(0, this.activeSessionList.length);
  }

  private getOobeContainerSession(): SCBSceneContainerSession | null {
    const containerSessionListInPanel = this.getContainerSessionList();
    let oobeSessionIndex = containerSessionListInPanel.findIndex((item) => {
      if (!item) { return false; }
      return item.primarySession?.sceneInfo.bundleName === ExtAppConstants.PKG_OOBE;
    });
    if (oobeSessionIndex !== -1) {
      return containerSessionListInPanel[oobeSessionIndex];
    } else {
      log.showInfo('can not find oobeSession in containerSessionList');
      return null;
    }
  }

  private restartOobeIfNeed(isTopActiveSession: boolean): boolean {
    // while no top active session but in oobe, restart oobe.
    if (!this.isPcOrPcMode() && !isTopActiveSession && sSCBOobeManager.isOobeActivated()) {
      const oobeContainerSession = this.getOobeContainerSession();
      if (oobeContainerSession == null) {
        return false;
      }
      oobeContainerSession.requestActivation(false);
      this.requestToTopWhenUnLock(oobeContainerSession.primarySession?.sceneInfo.screenId,
        oobeContainerSession.getPersistentId());
      if (this.startSceneWithRotationIfNeedCallback) {
        this.startSceneWithRotationIfNeedCallback(oobeContainerSession);
      }
      this.updateScenePanelState(this.mainScreenId, this.panelZIndex.scenePanel, ScenePanelState.FULLSCENE);
      this.clearActiveSessionList();
      return true;
    }
    return false;
  }

  private reLinkOobeIfNeed(topSession?: SCBSceneContainerSession, topSpecialSession?: SCBSceneContainerSession): void {
    if (!sSCBOobeManager.isOobeActivated()) {
      log.showInfo('[SCBMain]Oobe is not enable');
      return;
    }
    // if no top active scene, link caller
    const oobeContainerSession = this.getOobeContainerSession();
    if (oobeContainerSession == null) {
      log.showInfo('[SCBMain]no need to link oobeSession');
      return;
    }
    const oobeSession = oobeContainerSession.primarySession;
    // firstly, link calller for scene session in scene panel
    if (topSession && topSession.primarySession && oobeSession) {
      this.linkOobeToTheLast(topSession.primarySession, oobeSession);
      return;
    }
    // secondly, link caller for scene session in special scene panel
    if (topSpecialSession && topSpecialSession.primarySession && oobeSession) {
      this.linkOobeToTheLast(topSpecialSession.primarySession, oobeSession);
    }
  }

  private linkOobeToTheLast(topSession: SCBSceneSession, oobeSession: SCBSceneSession): void {
    if (!topSession) {
      log.showWarn('[SCBMain]topSession is empty, no need to link.');
      return;
    }
    const oobePersistentId: number = oobeSession.session.persistentId;
    const callerPersistentId: number = topSession.sceneInfo.callerPersistentId;
    if (oobePersistentId === topSession.session.persistentId || oobePersistentId === callerPersistentId) {
      log.showInfo('[SCBMain]No need to link oobe again.');
      return;
    }
    if (callerPersistentId === 0) {
      this.linkToCurrentSessionAsCaller(topSession, oobeSession);
      return;
    }

    let lastSession: SCBSceneSession = this.findLastSessionWhenOobeNotExist(topSession, callerPersistentId, oobePersistentId);
    if (lastSession) {
      this.linkToCurrentSessionAsCaller(lastSession, oobeSession);
    }
  }

  private findLastSessionWhenOobeNotExist(topSession: SCBSceneSession, callerPersistentId: number,
    oobePersistentId: number): SCBSceneSession | undefined {
    const containerSessionListInPanel: SCBSceneContainerSessionArray = this.getContainerSessionList();
    let currentTopSession: SCBSceneSession = topSession;
    let maxIterCount: number = 10;
    while (callerPersistentId !== 0 && (maxIterCount--) > 0) {
      if (oobePersistentId === callerPersistentId) {
        log.showInfo('[SCBMain]Oobe is on the callerChain, No need to link oobe again.');
        return undefined;
      }
      let preContainerSession = containerSessionListInPanel.findByPersistentId(callerPersistentId);
      if (preContainerSession && preContainerSession.primarySession) {
        log.showInfo(`[SCBMain]find caller session persistentId: ${callerPersistentId}`);
        currentTopSession = preContainerSession.primarySession;
        callerPersistentId = currentTopSession.sceneInfo.callerPersistentId;
      } else {
        break;
      }
    }
    return currentTopSession;
  }

  private linkToCurrentSessionAsCaller(currentTopSession: SCBSceneSession, oobeSession: SCBSceneSession): void {
    log.showInfo('[SCBMain]link oobe to the caller chain.');
    currentTopSession.sceneInfo.callerPersistentId = oobeSession.session.persistentId;
    oobeSession.sceneInfo.toPersistentId = currentTopSession.session.persistentId;
  }

  private handleStartSceneWithRotationCallback(containerSession: SCBSceneContainerSession,
                                               panelState: ScenePanelState): ScenePanelState {
    let containerSessionList = this.getContainerSessionList();
    let index = containerSessionList.indexOf(containerSession);
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if ((uiType !== SCBConstants.UITYPE_PC) && (index !== -1) && (panelState !== ScenePanelState.FULLSCENE)) {
      if (this.startSceneWithRotationIfNeedCallback) {
        this.startSceneWithRotationIfNeedCallback(containerSession);
      }
      panelState = ScenePanelState.FULLSCENE;
    }
    return panelState;
  }

  private requestToTopWhenUnLock(screenId: number, activeId: number): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC) {
      return;
    }
    this.requestToTop(screenId, activeId, SCBWindowRaiseReason.SCREEN_UNLOCK);
  }

  private setCurrentUserId(userId: number): void {
    if (AccountMgr.isInvalidAccount(userId)) {
      log.showInfo('setCurrentUserId user id err');
      return;
    }
    if (this.mCurrentUserId === userId) {
      log.showInfo('setCurrentUserId user id has not change');
      return;
    }
    log.showInfo(`setCurrentUserId userId:${userId}`);
    this.mCurrentUserId = userId;
    this.abilityInfoMap.clear();
    this.initUserInfo(userId);
    // start oobe after the account switchover is complete.
    sSCBOobeManager.startOobeAfterSwitchUser(userId);
    // query all ability info
    this.getAllAbilityList(userId);
  }

  /**
   * get current user id
   *
   * @returns current user id
   */
  public getCurrentUserId(): number {
    return this.mCurrentUserId;
  }

  /**
   * get Ability Info
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns {AbilityItemInfo | null}
   */
  public getAbilityInfo(bundleName: string, moduleName: string, abilityName: string): AbilityItemInfo | null {
    const key = bundleName + moduleName + abilityName;
    if (this.abilityInfoMap.has(key)) {
      return this.abilityInfoMap.get(key);
    }
    try {
      let abilityInfo = sceneSessionManager.getAbilityInfo(bundleName, moduleName, abilityName, this.mCurrentUserId);
      if (abilityInfo) {
        this.abilityInfoMap.set(key, abilityInfo.abilityItemInfo);
        this.sdkVersionMap.set(key, abilityInfo.sdkVersion);
        this.abilityHookMap.set(key, abilityInfo.isAbilityHook);
        return abilityInfo.abilityItemInfo;
      }
    } catch (exception) {
      log.showError(`getAbilityInfo exception: ${exception}`);
    }
    log.showWarn(`ability info not found, ${bundleName}${moduleName}${abilityName}`);
    return null;
  }

  private initUserInfo(userId: number): void {
    this.scenePersistent.initUserPersistentDir(userId);
    log.showInfo('Init user info UserId:' + userId + ', persistentFileDir' + this.scenePersistent.getPersistentFileDir());
    sceneSessionManager.initUserInfo(userId, this.scenePersistent.getPersistentFileDir());
  }

  private removeApplicationInfo(removeBundleName: string, userId: number): void {
    log.showInfo(`removeApplicationInfo: ${removeBundleName}`);
    this.applicationStartModeMap.delete(removeBundleName);
  }

  private handlePackageEvent(event: PackageCommonEvent): void {
    if (CommonUtils.isInvalid(event?.event)) {
      log.showWarn('handlePackageEvent package event unknown');
      return;
    }
    log.showInfo(`handlePackageEvent event = ${event.event} bundleName: ${event.bundleName} ` +
      `userId: ${event.userId} isModuleUpdate: ${event.isModuleUpdate} bundleType: ${event.bundleType} ` +
      `atomicServiceModuleUpgrade: ${event.atomicServiceModuleUpgrade} appIndex: ${event.appIndex}`);
    switch (event.event) {
      case commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED:
        if (event.appIndex === 0) {
          this.addOrModifyAbilityItemInfo(event.bundleName, event.userId);
          sceneSessionManager.refreshAppInfo(event.bundleName);
        }
        break;
      case commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED:
        this.closeScene(event.bundleName, event.appIndex);
        if (event.appIndex === 0) {
          this.removeAbilityItemInfo(event.bundleName, event.userId);
          this.removeApplicationInfo(event.bundleName, event.userId);
          sceneSessionManager.refreshAppInfo(event.bundleName);
        }
        break;
      case commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED:
        if (event.isModuleUpdate === false || (event.bundleType === BundleType.ATOMIC_SERVICE_TYPE && event.atomicServiceModuleUpgrade !== 0)) {
          log.showInfo('appChangeCallBack EVENT_PACKAGE_CHANGED isModuleUpdate is false, not close!');
        } else {
          this.closeScene(event.bundleName, event.appIndex);
        }
        if (event.appIndex === 0) {
          this.addOrModifyAbilityItemInfo(event.bundleName, event.userId);
          sceneSessionManager.refreshAppInfo(event.bundleName);
        }
        break;
      default:
        log.showInfo('handlePackageEvent unknown package event ' + event.event);
        break;
    }
  }

  private closeScene(bundleName: string, appIndex: number): void {
    let containerSessionList = this.getContainerSessionList();
    let tempContainerList = containerSessionList.slice();
    let floatContainerSessionList = this.getFloatingSessionList();
    let tempFloatContainerList = floatContainerSessionList.slice();
    this.closeContainerSession(bundleName, appIndex, [...tempContainerList, ...tempFloatContainerList]);
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let tempSpecialContainerList = specialContainerSessionList.slice();
    this.closeContainerSession(bundleName, appIndex, tempSpecialContainerList);
  }

  private closeContainerSession(bundleName: string, appIndex: number,
    containerSessionList: SCBSceneContainerSession[]): void {
    for (let item of containerSessionList) {
      if (item.primarySession?.sceneInfo.bundleName === bundleName &&
        item.primarySession?.sceneInfo.appIndex === appIndex) {
        this.close(item.primarySession?.sceneInfo.screenId, item.primarySession?.session.persistentId);
      }
      if (item.secondarySession?.sceneInfo.bundleName === bundleName &&
        item.secondarySession?.sceneInfo.appIndex === appIndex) {
        this.close(item.secondarySession?.sceneInfo.screenId, item.secondarySession?.session.persistentId);
      }
    }
  }

  /**
   * Fetch all ability item info list
   *
   * @param userId
   * @returns
   */
  public async getAllAbilityList(userId: number): Promise<void> {
    try {
      let want: Want = {};
      log.showInfo('will async to getAllAbilityList');
      taskpool.execute(fetchAllAbilityInfoSync, userId, want).then(
        (abilityItemInfoList: Array<SCBAbilityItemInfo>) => {
          log.showInfo(`getAllAbilityList abilityListSize size:${abilityItemInfoList.length}`);
          for (let index = 0; index < abilityItemInfoList.length; index++) {
            const scbAbilityItemInfo = abilityItemInfoList[index];
            let key = scbAbilityItemInfo.abilityItemInfo.bundleName + scbAbilityItemInfo.abilityItemInfo.moduleName +
            scbAbilityItemInfo.abilityItemInfo.name;
            this.abilityInfoMap.set(key, scbAbilityItemInfo.abilityItemInfo);
            this.sdkVersionMap.set(key, scbAbilityItemInfo.sdkVersion);
            this.abilityHookMap.set(key, scbAbilityItemInfo.isAbilityHook);
          }
        }).catch((err) => {
          log.showError(`getAllAbilityList failed: ${err.message}`);
        });
    } catch (exception) {
      log.showError(`task to getAllAbilityList exception: ${exception}`);
    }
  }

  public async getBatchAbilityInfos(userId: number, bundleNames: Array<string>): Promise<void> {
    if (bundleNames.length === 0) {
      WinLog.showWarn(WinLogDomain.WMS_RECOVER, 'bundleNames is empty!');
      return;
    }
    try {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `getBatchAbilityInfos userId:${userId} start`);
      let timeout = new Promise<Array<SCBAbilityItemInfo>>((resolve) => {
        setTimeout(() => {
          WinLog.showWarn(WinLogDomain.WMS_RECOVER, 'getBatchAbilityInfos timeout');
          resolve([]);
        }, GET_BATCH_ABILITY_INFO_TIME_OUT);
      });
      let abilityItemInfoList = await Promise.race(
        [sceneSessionManager.getBatchAbilityInfos(userId, bundleNames), timeout]);
      if (abilityItemInfoList.length === 0) {
        WinLog.showError(WinLogDomain.WMS_RECOVER, 'abilityItemInfoList is empty!');
        return;
      }
      for (let index = 0; index < abilityItemInfoList.length; index++) {
        const scbAbilityItemInfo = abilityItemInfoList[index];
        let key = scbAbilityItemInfo.abilityItemInfo.bundleName + scbAbilityItemInfo.abilityItemInfo.moduleName +
          scbAbilityItemInfo.abilityItemInfo.name;
        this.abilityInfoMap.set(key, scbAbilityItemInfo.abilityItemInfo);
        this.sdkVersionMap.set(key, scbAbilityItemInfo.sdkVersion);
        this.abilityHookMap.set(key, scbAbilityItemInfo.isAbilityHook);
      }
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `getBatchAbilityInfos userId:${userId} over`);
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, `getBatchAbilityInfos failed: ${err.message}`);
      return;
    }
  }

  private removeAbilityItemInfo(removeBundleName: string, userId: number): void {
    log.showInfo(`removeAbilityItemInfo: ${removeBundleName}`);
    this.abilityInfoMap.forEach((value, key) => {
      if (value.bundleName === removeBundleName) {
        this.abilityInfoMap.delete(key);
        this.sdkVersionMap.delete(key);
      }
    });
  }

  private async addOrModifyAbilityItemInfo(queryBundleName: string, userId: number): Promise<void> {
    log.showInfo(`addOrModifyAbilityItemInfo : ${queryBundleName}`);
    if (queryBundleName === undefined) {
      log.showInfo('addOrModifyAbilityItemInfo queryBundleName is undefined');
      return;
    }
    try {
      let want: Want = {
        bundleName: queryBundleName,
      };
      let abilityItemInfoList = await sceneSessionManager.getAllAbilityInfo(want, userId);
      log.showInfo('addOrModifyAbilityItemInfo abilityItemInfoList length: ' + abilityItemInfoList.length);
      for (let index = 0; index < abilityItemInfoList.length; index++) {
        const scbAbilityItemInfo = abilityItemInfoList[index];
        let key = scbAbilityItemInfo.abilityItemInfo.bundleName + scbAbilityItemInfo.abilityItemInfo.moduleName +
        scbAbilityItemInfo.abilityItemInfo.name;
        this.abilityInfoMap.set(key, scbAbilityItemInfo.abilityItemInfo);
        this.sdkVersionMap.set(key, scbAbilityItemInfo.sdkVersion);
        this.abilityHookMap.set(key, scbAbilityItemInfo.isAbilityHook);
      }
    } catch (err) {
      log.showError(`addOrModifyAbilityItemInfo failed: ${err.message}`);
      return;
    }
  }

  /**
   * get Ability Launch Type
   *
   * @param queryKey
   * @returns
   */
  public getAbilityLaunchType(queryKey: string): BundleManager.LaunchType {
    if (this.abilityInfoMap.has(queryKey)) {
      return this.abilityInfoMap.get(queryKey).launchType;
    }
    log.showError(`getAbilityLaunchType not find : ${queryKey}`);
    return BundleManager.LaunchType.SINGLETON;
  }

  /**
   * get Ability Start Mode
   *
   * @param queryKey
   * @returns
   */
  public getApplicationInfo(queryKey: string): SCBApplicationInfo {
    if (this.applicationStartModeMap.has(queryKey)) {
      return this.applicationStartModeMap.get(queryKey);
    }
    log.showWarn(`getApplicationInfo not find: ${queryKey}`);
    try {
      let applicationInfo: SCBApplicationInfo = sceneSessionManager.getApplicationInfo(queryKey);
      this.applicationStartModeMap.set(queryKey, applicationInfo);
      return applicationInfo;
    } catch (err) {
      log.showError(`getApplicationInfo failed: ${err.message}`);
      return new SCBApplicationInfo();
    }
  }

  /**
   * get Ability Window Size
   *
   * @param queryKey
   * @returns
   */
  public getAbilityWindowSize(queryKey: string): BundleManager.WindowSize {
    if (this.abilityInfoMap.has(queryKey)) {
      return this.abilityInfoMap.get(queryKey).windowSize;
    }
    log.showError(`getAbilityWindowSize not find : ${queryKey}`);
    return null;
  }

  /**
   * get Ability Window Support Info
   *
   * @param queryKey
   * @returns
   */
  public getAbilityWindowSupportInfo(queryKey: string, bundleName?: string,
    abilityName?: string): Array<BundleManager.SupportWindowMode> {
    let isSupportWindowMode = null;
    if (this.abilityInfoMap.has(queryKey)) {
      const supportWindowModesInFreeMultiWindow =
        this.abilityInfoMap.get(queryKey).supportWindowModesInFreeMultiWindow;
      isSupportWindowMode = (this.isPcOrPcMode() && supportWindowModesInFreeMultiWindow !== undefined) ?
        supportWindowModesInFreeMultiWindow : this.abilityInfoMap.get(queryKey).supportWindowModes;
    }
    if (bundleName && abilityName) {
      for (let value of this.abilityInfoMap.values()) {
        if (value.bundleName === bundleName && value.name === abilityName) {
          const supportWindowModesInFreeMultiWindow = value.supportWindowModesInFreeMultiWindow;
          isSupportWindowMode = (this.isPcOrPcMode() && supportWindowModesInFreeMultiWindow !== undefined) ?
            supportWindowModesInFreeMultiWindow : value.supportWindowModes;
          break;
        }
      }
    }
    return isSupportWindowMode;
  }

  /**
   * get Ability Orientation
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns
   */
  public getAbilityOrientation(bundleName: string, moduleName: string, abilityName: string): SCBSceneOrientation {
    let abilityInfo = this.getAbilityInfo(bundleName, moduleName, abilityName);
    if (abilityInfo) {
      let orientation = abilityInfo.orientation;
      if (!orientation) {
        return SCBSceneOrientation.UNSPECIFIED;
      }
      let sceneOrientation = DISPLAYORIENTATION_TO_SCBSCENEORIENTATION.get(orientation);
      if (sceneOrientation === undefined) {
        return SCBSceneOrientation.UNSPECIFIED;
      }
      return sceneOrientation;
    }
    log.showWarn(`getAbilityOrientation not find : ${bundleName}${moduleName}${abilityName}`);
    return SCBSceneOrientation.UNSPECIFIED;
  }

  /**
   * get Ability SDK Version
   *
   * @param queryKey
   * @returns
   */
  public getTargetSDKVersion(queryKey: string): number {
    if (this.sdkVersionMap.has(queryKey)) {
      return this.sdkVersionMap.get(queryKey);
    }
    log.showWarn(`getTargetSDKVersion not find : ${queryKey}`);
    return 0;
  }

  /**
   * is Remove Session After Terminate
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns
   */
  public isRemoveSessionAfterTerminate(bundleName: string, moduleName: string, abilityName: string,
    sceneInfo?: SCBSceneInfo, extraInfo?: ExecuteCallbackExtraInfo): boolean {
    if (extraInfo?.errorReason === 'appRecovery') {
      log.showInfo(`appRecovery needRemoveSession false`);
      return false;
    }
    let abilityInfo = this.getAbilityInfo(bundleName, moduleName, abilityName);
    if (abilityInfo) {
      let needRemoveSession = abilityInfo.removeSessionAfterTerminate;
      if (needRemoveSession === undefined) {
        needRemoveSession = false;
      }
      return needRemoveSession;
    }
    if (sceneInfo && sceneInfo.isStartupInstallFree && sceneInfo.isAtomicService) {
      log.showInfo(`AtomicService free-install start failed, set needRemoveSession to true, ` +
        `persistentId=${sceneInfo.persistentId}`);
      return true;
    }
    log.showWarn(`getIsRemoveSessionAfterTerminate not find : ${bundleName}${moduleName}${abilityName}`);
    return false;
  }

  /**
   * is Exclude From Session
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns
   */
  public isExcludeFromSession(bundleName: string, moduleName: string, abilityName: string): boolean {
    let abilityInfo = this.getAbilityInfo(bundleName, moduleName, abilityName);
    if (abilityInfo) {
      let excludeFromSession = abilityInfo.excludeFromSession;
      if (excludeFromSession === undefined) {
        excludeFromSession = false;
      }
      return excludeFromSession;
    }
    log.showWarn(`isExcludeFromSession not find : ${bundleName}${moduleName}${abilityName}`);
    return false;
  }

  /**
   * is UnClear From Recent
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns
   */
  public isUnClearFromRecent(bundleName: string, moduleName: string, abilityName: string): boolean {
    let abilityInfo = this.getAbilityInfo(bundleName, moduleName, abilityName);
    if (abilityInfo) {
      let unclearableSession = abilityInfo.unclearableSession;
      if (unclearableSession === undefined) {
        unclearableSession = false;
      }
      log.showDebug(`isUnClearFromRecent : ${bundleName}${moduleName}${abilityName}`);
      return unclearableSession;
    }
    return false;
  }

  /**
   * get Aspect Ratio From Preference
   *
   * @param queryKey
   * @returns
   */
  public getAspectRatioFromPreference(queryKey: string): number {
    if (!this.ratioPreference && typeof (this.ratioPreference) !== 'undefined') {
      log.showError('getAspectRatioFromPreference : preference not initialized');
      return 0;
    }
    if (queryKey.length > data_preferences.MAX_KEY_LENGTH) {
      queryKey = queryKey.substring(queryKey.length - data_preferences.MAX_KEY_LENGTH);
    }
    try {
      let value = this.ratioPreference.getSync(queryKey, 0);
      const ratio = Number(value);
      log.showDebug(`getAspectRatioFromPreference ${queryKey}: ratio ${ratio}`);
      if (ratio !== Number.NaN) {
        return ratio;
      }
    } catch (err) {
      log.showError(`getAspectRatioFromPreference not find : ${err}`);
    }
    return 0;
  }

  /**
   * get TYPE_FLOAT zorder
   *
   * @returns SpecificPanelZOrder
   */
  private getTypeFloatZorder(): SpecificPanelZOrder {
    let zOrder = this.isPc() ? SpecificPanelZOrder.TYPE_FLOAT : SpecificPanelZOrder.ABOVE_SCENE_PANEL;
    return zOrder;
  }

  /**
   * get input method status bar zorder
   *
   * @returns SpecificPanelZOrder
   */
  private getInputMethodStatusBarZorder(): SpecificPanelZOrder {
    let zOrder = this.isPc() ? SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR : SpecificPanelZOrder.ABOVE_KEYGUARD;
    return zOrder;
  }

  private setSessionTypeToPanelZorderMap(): void {
    // zOrderMap用于应用创建的特殊窗口与层级的对应关系，不可随意更改
    const zOrderMap = [
      // ABOVE_SCENE_PANEL
      { key: sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT, value: SpecificPanelZOrder.ABOVE_SCENE_PANEL },
      { key: sceneSessionManager.SessionType.TYPE_FLOAT, value: this.getTypeFloatZorder() },
      { key: sceneSessionManager.SessionType.TYPE_FLOAT_CAMERA, value: SpecificPanelZOrder.ABOVE_SCENE_PANEL },
      // MUTISCREEN_COLLABORATION
      { key: sceneSessionManager.SessionType.TYPE_MUTISCREEN_COLLABORATION,
          value: SpecificPanelZOrder.MUTISCREEN_COLLABORATION },
      // ABOVE_SYSTEMUI
      { key: sceneSessionManager.SessionType.TYPE_SYSTEM_FLOAT, value: SpecificPanelZOrder.ABOVE_SYSTEMUI },
      { key: sceneSessionManager.SessionType.TYPE_TOAST, value: SpecificPanelZOrder.ABOVE_SYSTEMUI },
      { key: sceneSessionManager.SessionType.TYPE_GLOBAL_SEARCH, value: SpecificPanelZOrder.ABOVE_SYSTEMUI },
      // DYNAMIC
      { key: sceneSessionManager.SessionType.TYPE_DYNAMIC, value: SpecificPanelZOrder.DYNAMIC },
      // VOICE_INTERACTION
      { key: sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION, value: SpecificPanelZOrder.VOICE_INTERACTION },
      // FLOAT_NAVIGATION
      { key: sceneSessionManager.SessionType.TYPE_FLOAT_NAVIGATION, value: SpecificPanelZOrder.FLOAT_NAVIGATION },
      // MEDIA_CONTROL_TEMP
      { key: sceneSessionManager.SessionType.TYPE_PANEL, value: SpecificPanelZOrder.MEDIA_CONTROL_TEMP },
      { key: sceneSessionManager.SessionType.TYPE_HANDWRITE, value: SpecificPanelZOrder.MEDIA_CONTROL_TEMP },
      // ABOVE_KEYGUARD
      { key: sceneSessionManager.SessionType.TYPE_POINTER, value: SpecificPanelZOrder.ABOVE_KEYGUARD },
      { key: sceneSessionManager.SessionType.TYPE_DRAGGING_EFFECT, value: SpecificPanelZOrder.ABOVE_KEYGUARD },
      { key: sceneSessionManager.SessionType.TYPE_INPUT_METHOD_STATUS_BAR,                                                              
          value: this.getInputMethodStatusBarZorder() },
      // WALLET_SWIPE_CARD
      { key: sceneSessionManager.SessionType.TYPE_WALLET_SWIPE_CARD, value: SpecificPanelZOrder.WALLET_SWIPE_CARD },
      // VOLUME
      { key: sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, value: SpecificPanelZOrder.VOLUME },
      // SYSTEM_TOAST
      { key: sceneSessionManager.SessionType.TYPE_SYSTEM_TOAST, value: SpecificPanelZOrder.SYSTEM_TOAST },
      { key: sceneSessionManager.SessionType.TYPE_PIP, value: SpecificPanelZOrder.PIP_PANEL },
      { key: sceneSessionManager.SessionType.TYPE_FLOATING_BALL, value: SpecificPanelZOrder.FLOATING_BALL },
      // SCREENSHOT
      { key: sceneSessionManager.SessionType.TYPE_SCREENSHOT, value: SpecificPanelZOrder.SCREENSHOT },
      // SCREEN_CONTROL
      { key: sceneSessionManager.SessionType.TYPE_SCREEN_CONTROL, value: SpecificPanelZOrder.SCREEN_CONTROL },
      { key: sceneSessionManager.SessionType.TYPE_MAGNIFICATION, value: SpecificPanelZOrder.MAGNIFICATION },
      { key: sceneSessionManager.SessionType.TYPE_MAGNIFICATION_MENU, value: SpecificPanelZOrder.MAGNIFICATION_MENU },
      { key: sceneSessionManager.SessionType.TYPE_SELECTION, value: SpecificPanelZOrder.TYPE_SELECTION },
    ];

    zOrderMap.forEach(item => {
      this.sessionTypeToPanelZorderMap.set(item.key, item.value);
    });
  }

  /**
   * get panel Zorder
   *
   * @returns SpecificPanelZOrder
   */
  public getPanelZorderByType(type: sceneSessionManager.SessionType): SpecificPanelZOrder | undefined {
    return this.sessionTypeToPanelZorderMap.get(type);
  }

  private onCreateSpecificSession(specificSession: sceneSessionManager.SceneSession): void {
    log.showInfo(`onCreateSpecificSession: persistentId:${specificSession.persistentId}, ` +
      `parent:${specificSession.parentId}, type:${specificSession.type}, ` +
      `screenId:${specificSession.screenId}, zIndex:${specificSession.zIndex}`);
    specificSession.subWindowAppModalType = specificSession.subWindowModalType;
    if (specificSession.type === sceneSessionManager.SessionType.TYPE_DIALOG) {
      log.showInfo('[SCBDialog] create dialog window');
    } else {
      let panelZOrder: SpecificPanelZOrder | undefined = this.getPanelZorderByType(specificSession.type);
      const isDynamicError = specificSession.type === sceneSessionManager.SessionType.TYPE_DYNAMIC &&
        (specificSession.zIndex === -1 || specificSession.zIndex === 0);
      if (panelZOrder === undefined || isDynamicError) {
        panelZOrder = SpecificPanelZOrder.ABOVE_SCENE_PANEL;
      }

      try {
        let displayClass = display.getDisplayByIdSync(specificSession.screenId);
      } catch (exception) {
        specificSession.screenId = 0;
        this.updateSessionDisplayId(specificSession.persistentId, specificSession.screenId);
        log.showInfo(`[SCBSpecific] Failed to get display. Code: ${exception.code}, message: ${exception.message}`);
      }
      const screenId = specificSession.screenId;
      const createCallback = this.createSpecificSceneCallbackMap?.get(screenId)?.get(panelZOrder);
      if (createCallback) {
        createCallback(specificSession);
      } else {
        log.showInfo(`[SCBSpecific] screen id: ${screenId} createSpecificSceneCallbackMap do not exit, wait to build`);
        if (!this.specificSessionCacheMap.has(screenId)) {
          this.specificSessionCacheMap.set(screenId, new Map());
        }
        let currentSpecificSessionCacheMap = this.specificSessionCacheMap.get(screenId);
        if (currentSpecificSessionCacheMap !== undefined && currentSpecificSessionCacheMap.has(panelZOrder)) {
          currentSpecificSessionCacheMap.get(panelZOrder).push(specificSession);
        } else {
          currentSpecificSessionCacheMap.set(panelZOrder, [specificSession]);
        }
      }
    }
  }

  private saveActiveSession(sceneSession: sceneSessionManager.SceneSession): void {
    if (this.activeSessionList.includes(sceneSession.persistentId)) {
      log.showError(`Already in activeSessionList: ${sceneSession.persistentId}`);
      return;
    }
    this.activeSessionList.push(sceneSession.persistentId);
  }

  private onRecoverSceneSession(sceneSession: sceneSessionManager.SceneSession,
                                sceneInfo: sceneSessionManager.SceneRecoverInfo): void {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `onRecoverSceneSession bundleName:${sceneInfo.bundleName}, moduleName:${sceneInfo.moduleName}, abilityName:${sceneInfo.abilityName}, ` +
    `appIndex:${sceneInfo.appIndex}, sessionType:${sceneInfo.sessionType}, windowMode:${sceneInfo.windowMode}, ` +
    `sessionState:${sceneInfo.sessionState}, requestOrientation:${sceneInfo.requestOrientation} isLayoutFullScreen:${sceneInfo.layoutFullScreen}, ` +
    `mainWindowTopMost:${sceneInfo.mainWindowTopmost}, WaterfallMode:${sceneInfo.isFullScreenWaterfallMode}`);
    if (sceneSession === null || sceneInfo === null) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'sceneSession or sceneInfo is null, failed to recover scene session!');
      return;
    }
    sceneInfo.screenId = sceneSession.screenId;
    if (this.recoverSessionCallbackMap.has(sceneSession.screenId) && !this.getScenePersistent().getRecoverFinished() &&
      this.isStartRecoverySet.has(sceneSession.screenId)) {
      this.onRecoverSession(sceneSession, sceneInfo);
    } else {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'recoverSessionCallback is null, temporarily save it to recoverSceneSessionList');
      if (!this.recoverSceneSessionList.has(sceneSession.screenId)) {
        this.recoverSceneSessionList.set(sceneSession.screenId, []);
      }
      this.recoverSceneSessionList.get(sceneSession.screenId).push([sceneSession, sceneInfo]);
    }
  }

  private loadWindowSceneConfig(): void {
    SCBWindowSceneConfig.getInstance().loadWindowSceneConfig();
  }

  public isSplitMode(persistentId: number): boolean {
    let containerSession = this.getSceneContainerSessionFromScenePanel(persistentId);
    return !!containerSession && containerSession.isSplit;
  }

  /**
   * Get the singleton of the scene session manager.
   */
  public static getInstance(): SCBSceneSessionManager {
    if (!globalThis.SCBSceneSessionManagerInstance) {
      globalThis.SCBSceneSessionManagerInstance = new SCBSceneSessionManager();
    }

    return globalThis.SCBSceneSessionManagerInstance;
  }

  /**
   * init
   */
  public init(): void {
    TraceUtil.startTrace(DomainName.SCB, 'SCBSceneSessionManager');
    // init SCBSceneSessionManager, and make sure register early enough
    log.showInfo('init SCBSceneSessionManager');
    this.selfImpl.init();
    SCBSceneMissionManager.getInstance().init(SceneMissionMgmtStage.ON_SCB_INIT);
    // Init window scene config.
    this.loadWindowSceneConfig();
    this.setSessionTypeToPanelZorderMap();
    sceneSessionManager.initScheduleUtils();
    this.registerEventExclusive();
    this.initAccountSwitchListener();
    SCBKioskModeManager.getInstance().init();
    TraceUtil.endTrace(DomainName.SCB, 'SCBSceneSessionManager');
  }

  /**
   * Get the session of the root scene.
   *
   * @return Session of the root scene
   */
  public getRootSceneSession(): SCBRootSceneSession {
    return this.rootSceneSession;
  }

  /**
   * Load the ui content of the root scene.
   *
   * @param path Path of the page which the root scene will be loaded
   * @param context Context of the service extension
   */
  public loadContent(path: string, context: ServiceExtensionContext, storage?: LocalStorage): void {
    this.rootSceneSession.loadContent(path, context, storage);
    try {
      data_preferences.getPreferences(context, 'session_window_aspect_ratio').then((obj) => {
        this.ratioPreference = obj;
      });
    } catch (err) {
      log.showError('Failed to get preferences. code =' + err.code + ', message =' + err.message);
    }
  }

  /**
   * on
   *
   * @param eventId
   * @param screenId
   * @param callback
   */
  public on(eventId: number, screenId: number, callback: Function): void {
    if (!this.callbackMap.has(eventId)) {
      log.showDebug(`callbackType: ${eventId} not exists!`);
      this.callbackMap.set(eventId, new Map());
    }
    let eventFuncMap = this.callbackMap.get(eventId);
    if (!eventFuncMap.get(screenId)) {
      log.showDebug(`screenId: ${screenId} with callbackType: ${eventId} not exists.`);
      eventFuncMap.set(screenId, new Array<Function>());
    }
    let functionArray = eventFuncMap.get(screenId);
    const index = functionArray.indexOf(callback);
    if (index === -1) {
      log.showInfo(`Register func type: ${eventId} with screenId: ${screenId} success.`);
      functionArray.push(callback);
    } else {
      log.showWarn(`Func type: ${eventId} with screenId: ${screenId} is exists.`);
    }
  }

  /**
   * off
   *
   * @param eventId
   * @param screenId
   * @param callback
   */
  public off(eventId: number, screenId: number, callback: Function): void {
    if (!this.callbackMap.has(eventId)) {
      return;
    }
    let eventFuncMap = this.callbackMap.get(eventId);
    if (!eventFuncMap) {
      return;
    }
    let functionArray = eventFuncMap.get(screenId);
    if (!functionArray) {
      return;
    }
    let idx = functionArray.indexOf(callback);
    if (idx !== -1) {
      functionArray.splice(idx, 1);
    }
  }

  /**
   * off special
   */
  public offSpecial(eventId: number, screenId: number, callback: Function): void {
    if (!this.specialCallbackMap.has(eventId)) {
      return;
    }
    let eventFuncMap = this.specialCallbackMap.get(eventId);
    if (!eventFuncMap) {
      return;
    }
    let functionArray = eventFuncMap.get(screenId);
    if (!functionArray) {
      return;
    }
    let idx = functionArray.indexOf(callback);
    if (idx !== -1) {
      functionArray.splice(idx, 1);
    }
  }

  /**
   * on Show
   *
   * @param callBack
   */
  public onShow(callBack: Function): void {
    this.callbackFuncForSCBScenePanel = callBack;
  }

  /**
   * on Special
   *
   * @param eventId
   * @param screenId
   * @param callback
   */
  public onSpecial(eventId: number, screenId: number, callback: Function): void {
    if (!this.specialCallbackMap.has(eventId)) {
      log.showDebug(`callbackType: ${eventId} not exists!`);
      this.specialCallbackMap.set(eventId, new Map());
    }
    let eventFuncMap = this.specialCallbackMap.get(eventId);
    if (!eventFuncMap.get(screenId)) {
      log.showDebug(`screenId: ${screenId} with callbackType: ${eventId} not exists.`);
      eventFuncMap.set(screenId, new Array<Function>());
    }
    let functionArray = eventFuncMap.get(screenId);
    log.showInfo(`Register func type:${eventId} with screenId: ${screenId} success.`);
    functionArray.push(callback);
  }

  /**
   * register Create Specific Scene Callback
   *
   * @param callback
   * @param zorder
   */
  public registerCreateSpecificSceneCallback(callback: Function, zorder: number, screenId: number = this.mainScreenId): void {
    log.showInfo(`registerCreateSpecificSceneCallback with screen id ${screenId}, ${zorder}`);
    if (!this.createSpecificSceneCallbackMap.has(screenId)) {
      this.createSpecificSceneCallbackMap.set(screenId, new Map());
      log.showInfo(`new screen callback , displayId ${screenId}`);
    }
    let currentCreateSpecificSceneCallbackMap = this.createSpecificSceneCallbackMap.get(screenId);
    currentCreateSpecificSceneCallbackMap.set(zorder, callback);

    if (!this.specificSessionCacheMap.has(screenId)) {
      this.specificSessionCacheMap.set(screenId, new Map());
      log.showInfo(`new screen callback , displayId ${screenId}`);
    }

    let keysToRemove: number[] = [];
    this.specificSessionCacheMap.forEach((curZorderSessionListMap, extendScreenId) => {
      if (extendScreenId !== 0) {
        try {
          // 可以通过WindowProperties的displayId属性获取到准确的displayId作为入参
          let displayClass = display.getDisplayByIdSync(extendScreenId);
          log.showInfo(`[SCBSpecific] extendScreenId: ${extendScreenId}`);
        } catch (exception) {
          log.showInfo(`[SCBSpecific] Failed to get display. Code: ${exception.code}, message: ${exception.message}`);
          this.updateSpecificSessionScreen(curZorderSessionListMap, screenId);
          keysToRemove.push(extendScreenId);
          log.showInfo(`[SCBSpecific] extendScreen does not exist, change ${extendScreenId} to mainScreen`);
        }
      }
    });
    keysToRemove.forEach(key => this.specificSessionCacheMap.delete(key));

    let currentSpecificSessionCacheMap = this.specificSessionCacheMap.get(screenId);
    if (currentSpecificSessionCacheMap !== undefined && currentSpecificSessionCacheMap.has(zorder)) {
      currentSpecificSessionCacheMap.get(zorder).forEach((item) => {
        try {
          WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'RecoverSpecificSession persistentId = ' + item.persistentId);
          callback(item);
        } catch (error) {
          // Because specificSession is cached, the specificSession object
          // at the C++ layer has been destroyed in some cases.
          // Therefore, exceptions may be thrown in JsSceneSession.
          WinLog.showWarn(WinLogDomain.WMS_RECOVER, `RecoverSpecificSession error, code: ${error.code}, message: ${error.message}`);
        }
      });
      currentSpecificSessionCacheMap.delete(zorder);
    }
  }

  /**
   * unregister Create Specific Scene Callback
   *
   * @param zorder
   * @param screenId
   */
  public unregisterCreateSpecificSceneCallback(zorder: number, screenId: number = this.mainScreenId): void {
    this.createSpecificSceneCallbackMap.get(screenId)?.delete(zorder);
  }

  /**
   * register Destroy Float Window Callback
   *
   * @param callback
   * @param zorder
   */
  public registerDestroyFloatWindowCallback(callback: Function, zorder: number, screenId: number = this.mainScreenId): void {
    log.showDebug('registerDestroyFloatWindowCallback');
    if (!this.destroyFloatWindowCallbackMap.has(screenId)) {
      this.destroyFloatWindowCallbackMap.set(screenId, new Map());
    }
    let localDestroyFloatWindowCallbackMap = this.destroyFloatWindowCallbackMap.get(screenId);
    let callbacks = localDestroyFloatWindowCallbackMap.get(zorder);
    if (callbacks !== undefined) {
      callbacks.add(callback);
    } else {
      callbacks = new Set();
      callbacks.add(callback);
      localDestroyFloatWindowCallbackMap.set(zorder, callbacks);
    }
  }

  public unregisterDestroyFloatWindowCallback(callback: Function, zorder: number, screenId: number = this.mainScreenId): void {
    this.destroyFloatWindowCallbackMap.get(screenId)?.get(zorder)?.delete(callback);
  }

  /**
   * register Request Focus Callback
   *
   * @param callback
   */
  public registerRequestFocusCallback(callback: Function): void {
    log.showDebug('registerRequestFocusCallback');
    this.requestFocusCallback = callback;
  }

  /**
   * Register callback to observer whether keyguard is occluded by other app or system window
   *
   * @param callback the callback to observer keyguard occluded state
   */
  public registerKeyguardOccludedChangeCallbacks(callback: Function): void {
    let index = this.keyguardOccludedChangeCallbacks.indexOf(callback);
    if (index === -1) {
      this.keyguardOccludedChangeCallbacks.push(callback);
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'register KeyguardOccludedChangeCallback success');
    }
  }

  /**
   * unRegister callback to observer whether keyguard is occluded by other app or system window
   *
   * @param callback the callback to observer keyguard occluded state
   */
  public unRegisterKeyguardOccludedChangeCallbacks(callback: Function): void {
    let index = this.keyguardOccludedChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.keyguardOccludedChangeCallbacks.splice(index, 1);
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'unregister KeyguardOccludedChangeCallback success');
    }
  }

  public registerFullSceneEndCallback(callback: Function): void {
    this.fullSceneEndCallback = callback;
  }

  public unRegisterFullSceneEndCallback(): void {
    this.fullSceneEndCallback = undefined;
  }

  /**
   * register Get Plugin Session List Callback
   *
   * @param callback
   */
  public registerGetPluginSessionListCallback(callback: Function): void {
    log.showDebug('registerGetPluginSessionListCallback');
    this.getPluginSessionListCallback = callback;
  }

  public getFloatContainerSessionFromScenePanel(persistentId: number): SCBSceneContainerSession | null {
    let floatContainerList = this.getFloatingSessionList();
    return this.getSceneContainerFromList(persistentId, floatContainerList);
  }

  /**
   * get Scene Container Session From Scene Panel
   *
   * @param persistentId
   * @returns
   */
  public getSceneContainerSessionFromScenePanel(persistentId: number,
    screenId?: number): SCBSceneContainerSession | null {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let containerList = this.getContainerSessionList(screenId);
    let floatingContainerList = this.getFloatingSessionList();
    return this.getSceneContainerFromList(persistentId, containerList) ||
      this.getSceneContainerFromList(persistentId, floatingContainerList);
  }

  public removeSceneContainerSession(session: SCBSceneContainerSession): boolean {
    if (CommonUtils.isInvalid(session)) {
      log.showWarn('remove sceneContainerSession failed, session is invalid');
      return false;
    }
    let containerList = this.getContainerSessionList();
    if (this.removeSceneContainerSessionBySession(session, containerList)) {
      log.showInfo('remove sceneContainerSession from ContainerSessionList success');
      return true;
    }
    let floatingContainerList = this.getFloatingSessionList();
    if (this.removeSceneContainerSessionBySession(session, floatingContainerList)) {
      log.showInfo('remove sceneContainerSession from FloatingSessionList success');
      return true;
    }
    return false;
  }

  public exitSplitView(persistentId: number): void {
    this.exitSplitViewFuncionCallback(persistentId);
  }

  /**
   * Scene with target persistentId exit midScene
   *
   * @param persistentId persistent id of SceneSession
   */
  public exitMidScene(persistentId: number): void {
    this.exitMidSceneFunctionCallback(persistentId);
  }

  public isGrayAppIcon(itemInfo: { bundleName: string, appIndex?: number }): boolean {
    if (this.grayAppListManagerFunctionCallback) {
      return this.grayAppListManagerFunctionCallback(itemInfo);
    }
    log.showInfo(`grayAppListManagerFunctionCallback is null`);
    return false;
  }

  private removeSceneContainerSessionBySession(session: SCBSceneContainerSession,
    containerList: SCBSceneContainerSessionArray): boolean {

    const index = containerList.findIndex((item) => {
      return item.containerId === session.containerId;
    });
    if (index === -1) {
      log.showInfo(`Remove scene container session faild, not exist, id=${session.containerId}`);
      return false;
    }
    log.showInfo(`Remove scene container session, id=${session.containerId}`);
    containerList[index]?.transitionController?.onInactive(TAG, 'remove Container by Index when sreenLock');
    containerList.splice(index, 1);
    this.refreshZOrder();
    return true;
  }

  /**
   * get Scene Container Session From Special Scene Panel
   *
   * @param persistentId
   * @returns
   */
  public getSceneContainerSessionFromSpecialScenePanel(persistentId: number): SCBSceneContainerSession | null {
    let containerList = this.getSpecialContainerSessionList();
    return this.getSceneContainerFromList(persistentId, containerList);
  }

  private getSceneContainerFromList(persistentId: number,
                                    containerList: SCBSceneContainerSessionArray): SCBSceneContainerSession | null {
    let index = containerList.findIndex((item) => {
      if (item.midSceneMap.has(persistentId)) {
        return true;
      }
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    if (index !== -1) {
      return containerList[index];
    }
    return null;
  }

  /**
   * register On Focused Callback
   *
   * @param callback
   */
  public registerOnFocusedCallback(callback: Function, displayId: number = DEFAULT_DISPLAY_GROUP_ID): void {
    log.showDebug('registerOnFocusedCallback');
    this.requestFocusCallbacks.push(callback);
    if (callback) {
      callback(this.getFocusedSessionId(displayId));
    }
  }

  /**
   * unregister On Focused Callback
   *
   * @param callback
   */
  public unregisterOnFocusedCallback(callback: Function): void {
    let index = this.requestFocusCallbacks.indexOf(callback);
    if (index !== -1) {
      this.requestFocusCallbacks.splice(index, 1);
    }
  }

  /**
   * register On Ntf Floating Window Callback
   *
   * @param callback
   */
  public registerOnNtfFloatingWindowCallback(callback: Function): void {
    log.showDebug('registerOnNtfFloatingWindowCallback');
    this.ntfFloatingWindowCallbacks.push(callback);
  }

  /**
   * unregister On Ntf Floating Window Callback
   *
   * @param callback
   */
  public unregisterOnNtfFloatingWindowCallback(callback: Function): void {
    let index = this.ntfFloatingWindowCallbacks.indexOf(callback);
    if (index !== -1) {
      this.ntfFloatingWindowCallbacks.splice(index, 1);
    }
  }

  /**
   * notify Ntf Floating Window Callback
   */
  public notifyNtfFloatingWindowCallback(): void {
    this.ntfFloatingWindowCallbacks.forEach((value) => {
      value();
    });
  }

  /**
   * register On Get Floating Rect Callback
   *
   * @param callback
   */
  public registerOnGetFloatingRectCallback(callback: Function): void {
    this.getFloatingRectCallbacks.add(callback);
  }

  /**
   * unregister On Get Floating Rect Callback
   *
   * @param callback
   */
  public unregisterOnGetFloatingRectCallback(callback: Function): void {
    this.getFloatingRectCallbacks.delete(callback);
  }

  /**
   * notify Ntf Floating Rect
   *
   * @param rect
   */
  public notifyNtfFloatingRect(rect: RectItem): void {
    this.getFloatingRectCallbacks.forEach((callback) => {
      callback(rect);
    });
  }

  /**
   * register Session Exception Listener
   *
   * @param callback
   */
  public registerSessionExceptionListener(callback: Function): void {
    log.showInfo(TAG, 'registerSessionExceptionListener is called');
    this.uiAbilityCrashCallbacks = callback;
  }

  /**
   * unRegister Session Exception Listener
   */
  public unRegisterSessionExceptionListener(): void {
    log.showInfo(TAG, 'unRegisterSessionExceptionListener is called');
    this.uiAbilityCrashCallbacks = null;
  }

  private notifySessionException(bundleName: string, moduleName: string, abilityName: string): void {
    log.showInfo(TAG, 'notifyUIAbilityCrashCallback is called');
    if (sSCBOobeManager.isOobeActivated() && this.uiAbilityCrashCallbacks) {
      this.uiAbilityCrashCallbacks(bundleName, moduleName, abilityName);
    }
  }

  /**
   * register Start Scene Listener
   *
   * @param callback
   */
  public registerStartSceneListener(callback: Function): void {
    log.showInfo(TAG, 'registerStartSceneListener is called');
    this.startSceneCallback = callback;
  }

  /**
   * unregister Start Scene Listener
   */
  public unregisterStartSceneListener(): void {
    log.showInfo(TAG, 'unregisterStartSceneListener is called');
    this.startSceneCallback = null;
  }

  /**
   * register Start Scene Listener
   *
   * @param callback
   */
  public registerStartSceneSingleHandListener(callback: Function): void {
    log.showInfo(TAG, 'registerStartSceneSingleHandListener is called');
    this.startSceneSingleHandCallback = callback;
  }

  /**
   * unregister Start Scene Listener
   */
  public unregisterStartSceneSingleHandListener(): void {
    log.showInfo(TAG, 'unregisterStartSceneSingleHandListener is called');
    this.startSceneSingleHandCallback = null;
  }

  private updateSpecificSessionScreen(curZorderSessionListMap: Map<number, sceneSessionManager.SceneSession[]>,
    screenId: number): void {
    curZorderSessionListMap.forEach((sessionList, zOrder) => {
      sessionList.forEach((session) => {
        if(session) {
          session.screenId = 0;
          this.updateSessionDisplayId(session.persistentId, session.screenId);
        }
      });
      if (this.specificSessionCacheMap.get(screenId).has(zOrder)) {
        this.specificSessionCacheMap.get(screenId).get(zOrder).push(...sessionList);
      } else {
        this.specificSessionCacheMap.get(screenId).set(zOrder, sessionList);
      }
    });
  }

  private notifyStartScene(bundleName: string, moduleName: string, abilityName: string,
    callState: number = CallToState.UNKNOWN): void {
    log.showInfo(TAG, 'notifyStartScene is called');
    if (this.startSceneCallback) {
      this.startSceneCallback(bundleName, moduleName, abilityName, callState);
    }
  }

  private notifySingleHandStartScene(bundleName: string): void {
    log.showInfo(TAG, 'notifySingleHandStartScene is called');
    if (this.startSceneSingleHandCallback) {
      this.startSceneSingleHandCallback(bundleName);
    }
  }

  /**
   * register On Animation Finished Callback
   *
   * @param callback
   */
  public registerOnAnimationFinishedCallback(callback: Function): void {
    this.ntfAnimationFinishedCallbacks = callback;
  }

  /**
   * notify Animation Finished Callback
   *
   * @param visible
   */
  public notifyAnimationFinishedCallback(visible: boolean): void {
    if (this.ntfAnimationFinishedCallbacks) {
      this.ntfAnimationFinishedCallbacks(visible);
    }
  }

  /**
   * register On GrayAppIcon Callback
   *
   * @param callback
   */
  public registerGrayAppIconCallback(callback: Function): void {
    this.ntfGrayAppIconCallbacks = callback;
  }

  /**
   * notify GrayAppIcon Callback
   *
   * @param sceneContainerSession
   *
   * @param isGrayAppIcon
   */
  public notifyGrayAppIconCallback(sceneContainerSession: SCBSceneContainerSession, isGrayAppIcon: boolean): void {
    if (this.ntfGrayAppIconCallbacks) {
      this.ntfGrayAppIconCallbacks(sceneContainerSession, isGrayAppIcon);
    }
  }

  /**
   * unregister On GrayAppIcon Callback
   */
  public unregisterGrayAppIconCallback(): void {
    this.ntfGrayAppIconCallbacks = null;
  }

  /**
   * register On GrayAppIcon Callback
   *
   * @param callback
   */
  public registerGrayAllAppsAppIconCallback(callback: Function): void {
    this.ntfGrayAllAppsAppIconCallbacks = callback;
  }

  /**
   * notify GrayAppIcon Callback
   *
   * @param sceneContainerSession
   *
   * @param isGrayAppIcon
   */
  public notifyGrayAllAppsAppIconCallback(sceneContainerSession: SCBSceneContainerSession, isGrayAppIcon: boolean): void {
    if (this.ntfGrayAllAppsAppIconCallbacks) {
      this.ntfGrayAllAppsAppIconCallbacks(sceneContainerSession, isGrayAppIcon);
    }
  }

  /**
   * unregister On GrayAppIcon Callback
   */
  public unregisterGrayAllAppsAppIconCallback(): void {
    this.ntfGrayAllAppsAppIconCallbacks = null;
  }

  /**
   * register On Unfocused Callback
   *
   * @param callback
   */
  public registerOnUnfocusedCallback(callback: Function, displayId: number = DEFAULT_DISPLAY_GROUP_ID): void {
    log.showDebug('registerOnUnfocusedCallback');
    this.onUnfocusedCallbacks.push(callback);
    if (callback) {
      callback(this.getFocusedSessionId(displayId));
    }
  }

  /**
   * unregister On Unfocused Callback
   *
   * @param callback
   */
  public unregisterOnUnfocusedCallback(callback: Function): void {
    let index = this.onUnfocusedCallbacks.indexOf(callback);
    if (index !== -1) {
      this.onUnfocusedCallbacks.splice(index, 1);
    }
  }

  /**
   * register callback for focused screen change
   * @param callback
   */
  public registerOnFocusedScreenChangeCallback(callback: Function): void {
    log.showDebug('registerOnFocusedScreenChangeCallback');
    this.focusedScreenChangeCallbacks.push(callback);
  }

  /**
   * unregister focused screen change callback
   * @param callback
   */
  public unRegisterOnFocusedScreenChangeCallback(callback: Function): void {
    let index = this.focusedScreenChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.focusedScreenChangeCallbacks.splice(index, 1);
    }
  }

  /**
   * start Scene In Virtual
   *
   * @param sceneInfo
   */
  public startSceneInVirtual(sceneInfo: SCBSceneInfo): CommonResult {
    if (CheckEmptyUtils.isEmpty(sceneInfo)) {
      log.showWarn('[SCBMain]startSceneInVirtual param sceneInfo is empty');
      return CommonResult.FAIL;
    }
    log.showInfo(`[SCBMain]startSceneInVirtual, bundleName: ${sceneInfo.bundleName}.`);
    if (SCBSceneStartInterceptor.getInstance().isOobeIntercepted(sceneInfo)) { return CommonResult.FAIL; }
    this.notifyStartScene(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    if (sceneInfo.isCastScene && this.virtualScreenStartSceneFuncMap.get(sceneInfo.screenId) === undefined) {
      SCBSceneSessionManager.getInstance().storeCastTask(sceneInfo);
    }
    this.virtualScreenStartSceneFuncMap.get(sceneInfo.screenId)?.(sceneInfo);
    return SCBSceneMissionManager.getInstance().startSceneFromOther(sceneInfo);
  }

  public hasVirtualScreenStartSceneFunc(screenId: number): boolean {
    return this.virtualScreenStartSceneFuncMap.get(screenId) !== undefined;
  }

  /**
   * Request sceneSession
   *
   * @param sceneInfo
   * @returns sceneSessionManager.SceneSession
   */
  public requestSceneSession(sceneInfo: SCBSceneInfo, isPersistentRecover: boolean = false): sceneSessionManager.SceneSession {
    let screenId = this.mainScreenId;
    if (sceneInfo.screenId !== INVALID_SCREEN_ID) {
      screenId = sceneInfo.screenId;
    }
    const key = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    if (this.abilityHookMap.has(key)) {
      sceneInfo.isAbilityHook = this.abilityHookMap.get(key);
      log.showInfo(`[SCBMain] set isAbilityHook ${sceneInfo.isAbilityHook}`);
    }
    let sceneSession = SCBSceneMissionManager.getInstance().requestSceneSession(sceneInfo,
      screenId, isPersistentRecover);
    if (sceneSession && CheckEmptyUtils.isEmpty(sceneInfo.label) && this.abilityInfoMap.has(key)) {
      ResourceManager.getInstance().getAppName(
        this.abilityInfoMap.get(key).appLabelId, sceneInfo.bundleName, sceneInfo.bundleName).then((name) => {
        log.showInfo(`[SCBMain] get app name: ${name}`);
        this.setLabel(sceneSession, name);
      });
    }
    return sceneSession;
  }

  /**
   * set the scene session label.
   *
   * @param state isPendingToBackgroundState
   */
  private setLabel(session: sceneSessionManager.SceneSession, label: string): void {
    log.showInfo(`[SCBMain]setLabel, label:${label}`);
    try {
      session.setLabel(label);
    } catch (err) {
      log.showError(`[SCBMain]setLabel failed, with reason ${err.code}`);
    }
  }

  private hasApplicationModalSession(info: SCBSceneInfo): boolean {
    if (!this.isPcOrPcMode() || CommonUtils.isInvalid(info)) {
      return false;
    }
    const sceneList : SCBSceneContainerSessionArray = this.getSceneList(info.persistentId, info);
    const sceneListLength = sceneList.length;
    const appModalSessionIndex: number = this.getApplicationModalSessionIndex(sceneList, sceneListLength);
    if (appModalSessionIndex === -1) {
      return false;
    }
    for (let i = 0; i < sceneListLength; i++) {
      if (i === appModalSessionIndex) {
        continue;
      }
      const sceneInfo = sceneList[i]?.primarySession?.sceneInfo;
      this.moveSceneToFrontFromRecent(sceneInfo?.screenId, sceneInfo?.persistentId,
        sceneList[i]?.containerId);
    }
    const sceneInfo = sceneList[appModalSessionIndex]?.primarySession?.sceneInfo;
    this.moveSceneToFrontFromRecent(sceneInfo?.screenId, sceneInfo?.persistentId,
      sceneList[appModalSessionIndex]?.containerId);
    log.showInfo(`[SCBMain]hasApplicationModalSession, persistentId:${sceneInfo?.persistentId} ` +
      `containerId:${sceneList[appModalSessionIndex]?.containerId}`);
    return true;
  }

  private startAbilityByLaunchType(sceneInfo: SCBSceneInfo): void {
    if (sceneInfo.launchType === BundleManager.LaunchType.SPECIFIED) {
      this.startAbilityBySpecified(sceneInfo);
    } else if (sceneInfo.launchType === BundleManager.LaunchType.MULTITON && sceneInfo.isStartByLaunchTypeConfig) {
      sceneInfo.persistentId = 0;
      sceneInfo.isNewInstance = true;
      this.executeStartSceneCallback(SCBEventId.START_SCENE_FROM_ICON, sceneInfo.screenId, sceneInfo);
    } else {
      this.executeStartSceneCallback(SCBEventId.START_SCENE_FROM_ICON, sceneInfo.screenId, sceneInfo);
    }
  }

  /**
   * StartSceneFromIcon.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startSceneFromIcon(sceneInfo: SCBSceneInfo): void {
    sceneInfo.isNewAppInstance = false;
    sceneInfo.appInstanceKey = '';
    log.showInfo('[SCBMain]startSceneFromIcon:' + sceneInfo?.toJsonString());
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo, true, true)) {
      log.showWarn(`[SCBMain]startSceneFromIcon id:${sceneInfo.persistentId} intercepted.`);
      return;
    }
    this.notifyStartScene(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    this.notifySingleHandStartScene(sceneInfo.bundleName);
    if (SCBScreenSessionManager.getInstance().getScreenSession(sceneInfo.screenId)?.session?.name === 'CastEngine') {
      log.showInfo('[SCBMain]startSceneFromIcon, startSceneInVirtual');
      this.startSceneInVirtual(sceneInfo);
      return;
    }
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_FROM_ICON +
      ` bundleName:${sceneInfo.bundleName}`);
    if (this.isSupportMultiInstance() && this.startMultiInstance(sceneInfo)) {
      log.showInfo(`[SCBMain]startSceneFromIcon: start multi instance moduleName:${sceneInfo.moduleName}`);
      TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_FROM_ICON);
      return;
    } else if (this.hasApplicationModalSession(sceneInfo)) {
      log.showInfo(`[SCBMain]startSceneFromIcon: has applicationmodal window`);
      TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_FROM_ICON +
        ` bundleName:${sceneInfo.bundleName}`);
      return;
    }

    this.startAbilityByLaunchType(sceneInfo);
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_FROM_ICON);
  }

  /**
   * startFloatFromDock.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startFloatFromDock(sceneInfo: SCBSceneInfo): void {
    log.showInfo('[SCBMain]startFloatFromDock:' + sceneInfo?.toJsonString());
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo)) { return; }
    this.executeStartSceneCallback(SCBEventId.START_FLOAT_FROM_DOCK, sceneInfo.screenId, sceneInfo);
  }

  /**
   * transitionFloat.
   * @param sceneInfo The info of the scene which to be activated
   */
  public transitionFloat(sceneInfo: SCBSceneInfo, persistentId: number): void {
    if (sceneInfo === null || sceneInfo === undefined) {
      log.showError(`[SCBMain]transitionFloat fail: reason:sceneInfo is null`);
      return;
    }
    this.executeStartSceneCallback(SCBEventId.FLOAT_TRANSITION, sceneInfo.screenId, sceneInfo);
    return;
  }

  private sessionTraversal(specificSession: SCBSpecificSession, needIsActive: boolean = false): boolean {
    if (!specificSession.session) {
      return false;
    }
    if (specificSession.sessionData.sessionState === sceneSessionManager.SessionState.STATE_BACKGROUND) {
      return false;
    }
    if (needIsActive && !specificSession.isActive) {
      return false;
    }
    if (specificSession.session.subWindowAppModalType === sceneSessionManager.SubWindowModalType.TYPE_APPLICATION_MODALITY) {
      return true;
    }
    let isApplicationModal: boolean = false;
    const subSessionList: SCBSpecificSceneSessionList = specificSession?.subSessionList;
    const length: number = subSessionList?.length;
    for (let i = 0; i < length; i++) {
      if (this.sessionTraversal(subSessionList[i], needIsActive)) {
        isApplicationModal = true;
        break;
      }
    }
    return isApplicationModal;
  }

  private getApplicationModalSessionIndex(containerSessionList: SCBSceneContainerSessionArray,
    length: number, needMainModal: boolean = true, needIsActive: boolean = false): number {
    let containerSessionListIndex: number = -1;
    let isApplicationModal: boolean = false;
    log.showInfo(`ContainerSessionListLength: ${length}`);
    for (let i = length - 1; i >= 0 && !isApplicationModal; i--) {
      const session: SCBSceneSession = containerSessionList[i].primarySession;
      if (CommonUtils.isInvalid(session)) {
        continue;
      }
      if (needIsActive && !session.isActive) {
        continue;
      }
      if (needMainModal && session.isModal) {
        isApplicationModal = true;
        containerSessionListIndex = i;
        log.showInfo(`containerAppModalSessionListIndex: ${containerSessionListIndex}`);
        break;
      }
      const subSessionList: SCBSpecificSceneSessionList = session.subSessionList;
      const subSessionListLength: number = subSessionList.length;
      for (let j = 0; j < subSessionListLength; j++) {
        if (this.sessionTraversal(subSessionList[j], needIsActive)) {
          isApplicationModal = true;
          containerSessionListIndex = i;
          log.showInfo(`containerAppModalSessionListIndex: ${containerSessionListIndex}`);
          break;
        }
      }
    }
    return containerSessionListIndex;
  }

  private moveSceneToFrontFromRecent(screenId: number, persistentId?: number, containerId?: number,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    Trace.start(Trace.CORE_METHOD_START_SCENE_FROM_RECENT);
    log.showInfo(`[SCBMain]moveSceneToFrontFromRecent, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.START_SCENE_FROM_RECENT,
      screenId, persistentId, containerId, undefined, shouldBackToCaller, extraInfo);
    Trace.end(Trace.CORE_METHOD_START_SCENE_FROM_RECENT);
  }

  private getSceneList(persistentId: number, info?: SCBSceneInfo, screenId: number = INVALID_SCREEN_ID): SCBSceneContainerSessionArray {
    const containerSessionList: SCBSceneContainerSessionArray = (screenId !== INVALID_SCREEN_ID ?
      this.getContainerSessionList(screenId) : this.getAllContainerSessionList());
    const sceneInfo: SCBSceneInfo = persistentId !== 0 ?
      containerSessionList.findByPersistentId(persistentId)?.primarySession?.sceneInfo : info;
    const containerSessionListLength: number = containerSessionList.length;
    let sceneList : SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    if (CommonUtils.isInvalid(sceneInfo)) {
      return sceneList;
    }
    for (let i = 0; i < containerSessionListLength; i++) {
      if (containerSessionList[i].primarySession?.sceneInfo?.isSameBundleWithMultiApp(sceneInfo)) {
        sceneList.push(containerSessionList[i]);
      }
    }
    return sceneList;
  }

  /**
   * StartSceneFromRecent
   *
   * @param sceneContainerSession The session of the scene container which to be destroyed.
   */
  public startSceneFromRecent(screenId: number, persistentId?: number, containerId?: number,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    if (persistentId === INVALID_PERSISTENT_ID) {
      return;
    }
    if (!this.isPcOrPcMode()) {
      this.moveSceneToFrontFromRecent(screenId, persistentId, containerId);
      let recentBundleName: string = this.getContainerSessionList()?.findByContainerId(containerId)?.getBundleName();
      this.notifySingleHandStartScene(recentBundleName);
      return;
    }
    const sceneList : SCBSceneContainerSessionArray = this.getSceneList(persistentId);
    const sceneListLength = sceneList.length;
    const appModalSessionIndex: number = this.getApplicationModalSessionIndex(sceneList, sceneListLength);
    log.showInfo(`appModalSessionIndex: ${appModalSessionIndex}`);
    if (appModalSessionIndex === -1) {
      this.moveSceneToFrontFromRecent(screenId, persistentId, containerId, shouldBackToCaller, extraInfo);
      log.showInfo(`[SCBMain]startSceneFromRecent, persistentId:${persistentId} containerId:${containerId}`);
      return;
    }
    for (let i = 0; i < sceneListLength; i++) {
      if (i === appModalSessionIndex) {
        continue;
      }
      const sceneInfo = sceneList[i].primarySession.sceneInfo;
      this.moveSceneToFrontFromRecent(sceneInfo.screenId, sceneInfo.persistentId,
        sceneList[i].containerId);
    }
    const sceneInfo = sceneList[appModalSessionIndex]?.primarySession?.sceneInfo;
    this.moveSceneToFrontFromRecent(sceneInfo?.screenId, sceneInfo?.persistentId,
      sceneList[appModalSessionIndex].containerId);
    log.showInfo(`[SCBMain]startSceneFromRecent, ApplicationModal persistentId:${sceneInfo?.persistentId} ` +
      `containerId:${sceneList[appModalSessionIndex]?.containerId}`);
  }

  /**
   * StartSceneFromRecent
   *
   * @param sceneContainerSession The session of the scene container which to be destroyed.
   */
  public enterSideEdgeBar(screenId: number, persistentId?: number, containerId?: number,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    log.showInfo(`enterSideEdgeBar, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.FLOATING_ENTER_SIDE_EDGE_BAR, screenId, persistentId, containerId,
      undefined, undefined, extraInfo);
  }

  /**
   * StartSceneFromOther.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startSceneFromOther(sceneInfo: SCBSceneInfo): CommonResult {
    if (this.hasApplicationModalSession(sceneInfo)) {
      log.showInfo(`[SCBMain]startSceneFromOther, applicationModal windowId:${sceneInfo?.persistentId}`);
      return CommonResult.SUCCESS;
    }
    Trace.start(Trace.CORE_METHOD_START_SCENE_FROM_OTHER);
    log.showWarn('[SCBMain]startSceneFromOther:' + sceneInfo?.toJsonString());
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo) || this.isSampleManagerIntercepted(sceneInfo)) {
      return CommonResult.FAIL;
    }
    this.notifyStartScene(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    this.notifySingleHandStartScene(sceneInfo.bundleName);
    let callbackResult: CommonResult = this.executeStartSceneCallback(SCBEventId.START_SCENE_FROM_OTHER,
      sceneInfo.screenId, sceneInfo);
    let startResult: CommonResult = SCBSceneMissionManager.getInstance().startSceneFromOther(sceneInfo);
    Trace.end(Trace.CORE_METHOD_START_SCENE_FROM_OTHER);
    return (callbackResult.isSuccess() || startResult.isSuccess()) ? CommonResult.SUCCESS :
        CommonResult.FAIL;
  }

  /**
   * StartSceneFromVirtual
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startSceneFromVirtual(sceneInfo: SCBSceneInfo): void {
    Trace.start(Trace.CORE_METHOD_START_SCENE_FROM_VIRTUAL);
    log.showInfo(`[SCBMain]startSceneFromVirtual: persistentId = ${sceneInfo?.persistentId},` +
      `bundleName = ${sceneInfo?.bundleName}`);
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo) || this.isSampleManagerIntercepted(sceneInfo)) {
      return;
    }
    this.notifyStartScene(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    this.executeStartSceneCallback(SCBEventId.START_SCENE_FROM_VIRTUAL, sceneInfo.screenId, sceneInfo);
    Trace.end(Trace.CORE_METHOD_START_SCENE_FROM_VIRTUAL);
  }

  private isSampleManagerIntercepted(sceneInfo: SCBSceneInfo): boolean {
    // 判断是否在白名单列表
    if (sSampleManager.isSampleManagerChecked() &&
      !sSampleManager.isTrustlistForWms(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName)) {
      log.showInfo(TAG, 'sampleManager is enabled and uiAbility is not in white list');
      return true;
    }
    return false;
  }

  /**
   * startSceneFromScreenLock.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startSceneFromScreenLock(sceneInfo: SCBSceneInfoFromScreenLock): void {
    WinLog.showInfo(WinLogDomain.WMS_MAIN, `onStartSceneFromScreenLock:${sceneInfo?.persistentId} ${sceneInfo?.bundleName}`);
    if (this.isExternalScreenIntercepted(sceneInfo)) {
      return;
    }
    Trace.start(Trace.CORE_METHOD_START_SCENE_FROM_SCREEN_LOCK);
    this.executeSpecialStartSceneCallback(SCBEventId.START_SCENE_FROM_SCREEN_LOCK, sceneInfo.screenId, sceneInfo);
    Trace.end(Trace.CORE_METHOD_START_SCENE_FROM_SCREEN_LOCK);
  }

  /**
   * StartSceneFromNotification.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startSceneFromNotification(sceneInfo: SCBSceneInfo): CommonResult {
    log.showInfo('[SCBMain]startSceneFromNotification:' + sceneInfo?.toJsonString());
    if (SCBSceneStartInterceptor.getInstance().isOobeIntercepted(sceneInfo, false) || this.isExternalScreenIntercepted(sceneInfo)) {
      return CommonResult.FAIL;
    }
    this.notifyStartScene(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    this.notifySingleHandStartScene(sceneInfo.bundleName);
    return this.executeStartSceneCallback(SCBEventId.START_SCENE_FROM_NOTIFICATION, sceneInfo.screenId, sceneInfo);
  }

  /**
   * StartSceneTransition.
   *
   * @param toInfo The info of the scene which to be activated
   * @param fromInfo The info of the scene which to be background.
   * @param isBackTransition  whether start ability or back to caller
   */
  public startSceneTransition(toInfo: SCBSceneInfo | SCBSceneInfo[], fromInfo?: SCBSceneInfo,
    isBackTransition?: boolean): CommonResult {
    if (Array.isArray(toInfo)) {
      if (toInfo.length < 2) {
        log.showWarn(`[SCBMain]startSceneTransition toInfo is array but length is ${toInfo.length}`);
        return CommonResult.FAIL;
      }
      toInfo.forEach((v, i) => {
        if (this.isStartSceneInterceptedUnderConditions(v)) {
          return CommonResult.FAIL;
        }
        this.notifyStartScene(v.bundleName, v.moduleName, v.abilityName);
        this.notifySingleHandStartScene(v.bundleName);
      });
      return this.executeStartSceneCallback(SCBEventId.START_SCENE_LIST, toInfo[0].screenId, toInfo, fromInfo,
        isBackTransition);
    }
    let session = this.getSceneContainerSessionFromScenePanel(fromInfo.persistentId);
    log.showInfo('[SCBMain]startSceneTransition:' + toInfo?.toJsonString());
    if (this.isStartSceneInterceptedUnderConditions(toInfo)) {
      return CommonResult.FAIL;
    }

    // determine whether should be intercepted for multi-window in-app mode
    if (this.isShouldBeIntercepted(session, toInfo)) {
      return CommonResult.FAIL;
    }

    if (toInfo && fromInfo && (toInfo.persistentId === fromInfo.persistentId || toInfo.isPhoneCall())) {
      return this.startSceneFromOther(toInfo);
    } else if (session?.isMidScene && session?.midSceneMap.has(toInfo.persistentId) === false) {
      log.showInfo('[SCBMain]startSceneTransition in midScene');
      return this.startSceneFromOther(toInfo);
    } else if (toInfo.screenId !== fromInfo.screenId) {
      return this.startSceneFromOther(toInfo);
    } else {
      this.notifyStartScene(toInfo.bundleName, toInfo.moduleName, toInfo.abilityName);
      this.notifySingleHandStartScene(toInfo.bundleName);
      TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_TRANSITION);
      // executeStartSceneCallback和startSceneTransition 任意成功即为成功
      let callbackResult: CommonResult = this.executeStartSceneCallback(SCBEventId.START_SCENE_TRANSITION,
        toInfo.screenId, toInfo, fromInfo, isBackTransition);
      let startResult: CommonResult = SCBSceneMissionManager.getInstance().startSceneTransition(toInfo, fromInfo,
        { isBackTransition: isBackTransition });
      TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_TRANSITION);
      return (callbackResult.isSuccess() || startResult.isSuccess()) ? CommonResult.SUCCESS :
        CommonResult.FAIL;
    }
  }

  private isShouldBeIntercepted(session: SCBSceneContainerSession | null,
    toInfo: SCBSceneInfo | sceneSessionManager.SceneInfo): boolean {
    let midSceneLifeCycleShouldBeIntercepted = [
      MidSceneLifeCycle.EXIT_MIDSCENE_TO_FULL,
      MidSceneLifeCycle.EXIT_MIDSCENE_TO_SPLIT
    ]
    let splitLifeCycleShouldBeIntercepted = [
      SplitLifeCycle.EXIT_SPLIT_TO_FULLSCREEN,
      SplitLifeCycle.EXIT_MIDSCENE_TO_SPLIT
    ]

    let isAppMultiWindow = this.isAppMultiWindowMode(toInfo);
    if (isAppMultiWindow && session && session.midSceneParam && session.splitParam &&
      (midSceneLifeCycleShouldBeIntercepted.includes(session.midSceneParam.getLifeCycle()) ||
      splitLifeCycleShouldBeIntercepted.includes(session.splitParam.getLifeCycle()))) {
      log.showWarn(`[SCBMain] startSceneTransition intercepted by midSceneParam:
       ${session.midSceneParam.getLifeCycle()} or splitParam: ${session.splitParam.getLifeCycle()}`);
      return true;
    }
    return false;
  }

  /**
   * start Scene From Other Above Keyguard
   *
   * @param sceneInfo
   */
  public startSceneFromOtherAboveKeyguard(sceneInfo: SCBSceneInfo): CommonResult {
    Trace.start(Trace.CORE_METHOD_START_SCENE_FROM_OTHER);
    log.showInfo('[SCBMain]startSceneFromOtherAboveKeyguard:' + sceneInfo?.toJsonString());
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo)) { return CommonResult.FAIL; }
    this.notifyStartScene(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    let callbackResult: CommonResult = this.executeSpecialStartSceneCallback(SCBEventId.START_SCENE_FROM_OTHER,
      sceneInfo.screenId, sceneInfo);
    Trace.end(Trace.CORE_METHOD_START_SCENE_FROM_OTHER);
    return callbackResult;
  }

  /**
   * startSceneBackGround.
   *
   * @param sceneInfo The info of the scene which to be start background
   */
  public startSceneByCall(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo): CommonResult {
    log.showInfo('[SCBMain]startSceneByCall, toInfo:' + toInfo?.toJsonString());
    if (this.isStartSceneInterceptedUnderConditions(toInfo)) { return CommonResult.FAIL; }
    this.notifyStartScene(toInfo.bundleName, toInfo.moduleName, toInfo.abilityName, toInfo.callState);
    this.notifySingleHandStartScene(toInfo.bundleName);
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_BY_CALL);
    let callbackResult: CommonResult = this.executeStartSceneCallback(SCBEventId.START_SCENE_BYCALL, toInfo.screenId,
      toInfo, fromInfo);
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.START_SCENE_BY_CALL);
    return callbackResult;
  }

  private isStartSceneInterceptedUnderConditions(sceneInfo: SCBSceneInfo,
    isCheckExclusive: boolean = true, isNotifyOobe: boolean = false): boolean {
    return SCBSceneStartInterceptor.getInstance().isOobeIntercepted(sceneInfo, isCheckExclusive, isNotifyOobe)
      || this.isExternalScreenIntercepted(sceneInfo);
  }

  public hiddenStartSceneFromOther(sceneInfo: SCBSceneInfo): CommonResult {
    log.showInfo('[SCBMain]hiddenStartSceneFromOther');
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo)) {
      return CommonResult.FAIL;
    }
    return this.executeStartSceneCallback(SCBEventId.HIDDEN_START_SCENE_FROM_OTHER, sceneInfo.screenId, sceneInfo);
  }

  public changeSessionVisWithStatusBarFromOther(sceneInfo: SCBSceneInfo, visible: boolean): void {
    log.showInfo('[SCBMain]changeSessionVisWithStatusBarFromOther');
    if (this.isStartSceneInterceptedUnderConditions(sceneInfo)) {
      return;
    }
    const eventId: SCBEventId = visible ? SCBEventId.HIDDEN_TO_FOREGROUND_FROM_OTHER :
    SCBEventId.FOREGROUND_TO_HIDDEN_FROM_OTHER;
    this.executeStartSceneCallback(eventId, sceneInfo.screenId, sceneInfo);
  }

  public hiddenStartSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo): CommonResult {
    log.showInfo('[SCBMain]hiddenStartSceneTransition');
    if (toInfo.persistentId === fromInfo.persistentId) {
      return this.hiddenStartSceneFromOther(toInfo);
    } else {
      return this.executeStartSceneCallback(SCBEventId.HIDDEN_START_SCENE_TRANSITION, toInfo.screenId, toInfo,
        fromInfo);
    }
  }

  public changeSessionVisWithStatusBarTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo,
      visible: boolean, isFromClient?: boolean): void {
    log.showInfo('[SCBMain]changeSessionVisWithStatusBarTransition');
    if (toInfo.persistentId === fromInfo.persistentId) {
      this.changeSessionVisWithStatusBarFromOther(toInfo, visible);
    } else {
      const eventId: SCBEventId = visible ? SCBEventId.HIDDEN_TO_FOREGROUND_TRANSITION :
      SCBEventId.FOREGROUND_TO_HIDDEN_TRANSITION;
      this.executeStartSceneCallback(eventId, toInfo.screenId, toInfo, fromInfo, false, isFromClient);
    }
  }

  /**
   * startScene when pip restore
   * @param persistentId The persistentId of mainWindow which pip attached
   */
  public startSceneFromPiP(persistentId: number, isFromBg: boolean = false): void {
    log.showInfo('startSceneFromPiP:' + persistentId);
    if (this.callbackFuncForSCBScenePanel != null) {
      this.isStartingSceneFromPiP = true;
      this.isRestoreFromBgPiP = isFromBg;
      this.callbackFuncForSCBScenePanel(persistentId);
    }
  }

  /**
   * startScene when pip restore
   * @param persistentId The persistentId of mainWindow which pip attached
   */
  public resetStartingSceneFromPiP(): void {
    log.showInfo('resetStartingSceneFromPiP');
    this.isStartingSceneFromPiP = false;
  }

  /**
   * BackSceneTransition.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public backSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo): void {
    log.showInfo('[SCBMain]backSceneTransition, toInfo: ' + toInfo?.toJsonString());
    this.executeStartSceneCallback(SCBEventId.BACK_SCENE_TRANSITION, toInfo.screenId, toInfo, fromInfo);
  }

  /**
   * Request the scene container session activation.
   *
   * @param sceneContainerSession The session of the scene container which to be activated.
   */
  public requestSceneContainerActivation(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`[SCBMain]requestSceneContainerActivation, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.ACTIVATE_SCENE, screenId, persistentId, containerId);
  }

  /**
   * Request the scene container session background for delegator.
   *
   * @param sceneContainerSession The session of the scene container which to be background.
   */
  public requestSceneContainerBackgroundForDelegator(screenId: number, persistentId?: number,
    containerId?: number, shouldBackToCaller?: boolean): void {
    log.showInfo(`[SCBMain]requestSceneContainerBackgroundForDelegator, persistentId:${persistentId}` +
      `, containerId:${containerId}, shouldBackToCaller:${shouldBackToCaller}`);
    this.executeCallback(SCBEventId.BACKGROUND_SCENE_FOR_DELEGATOR,
      screenId, persistentId, containerId, undefined, shouldBackToCaller);

    SCBSceneMissionManager.getInstance().minimizeScene(screenId, persistentId, containerId,
      { shouldBackToCaller: shouldBackToCaller });
  }

  /**
   * Request the scene container session destruction.
   *
   * @param sceneContainerSession The session of the scene container which to be destroyed.
   */
  public requestSceneContainerDestruction(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`[SCBMain]requestSceneContainerDestruction, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.DESTROY_SCENE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.DESTROY_SCENE, screenId, persistentId, containerId);
  }

  /**
   * request Scene Session Activation
   *
   * @param session
   * @param isNewActive
   */
  public requestSceneSessionActivation(session: sceneSessionManager.SceneSession, isNewActive: boolean,
    isShowAbility: boolean = false, requestId: number = DEFAULT_REQUEST_ID): number {
    if (session == null) {
      log.showError('[SCBMain]requestSceneSessionActivation null session');
      return SCENE_SESSION_NULL_EXCEPTION;
    }
    log.showInfo(`[SCBMain][id:${session.persistentId}]requestSceneSessionActivation.`);
    let activateResult = 0;
    let hiTraceChain = new HiTraceChain('RequestSceneSessionActivation');
    try {
      hiTraceChain.begin();
      this.setIsPendingToBackgroundState(session, false);
      this.setIsActivatedAfterScreenLocked(session, this.isScreenLocked());
      sceneSessionManager.requestSceneSessionActivation(session, isNewActive, isShowAbility, requestId);
    } catch (err) {
      log.showError('[SCBMain]requestSceneSessionActivation failed, with reason ' + JSON.stringify(err));
      activateResult = err.code;
    } finally {
      hiTraceChain.end();
    }
    return activateResult;
  }

  /**
   * set the scene session isActivatedAfterScreenLocked true or not
   *
   * @param session session
   * @param isScreenLocked isScreenLocked
   */
  private setIsActivatedAfterScreenLocked(session: sceneSessionManager.SceneSession, isScreenLocked: boolean): void {
    log.showInfo(`[SCBMain]setIsActivatedAfterScreenLocked, isScreenLocked: ${isScreenLocked}`);
    try {
      session.setIsActivatedAfterScreenLocked(isScreenLocked);
    } catch (err) {
      log.showError(`[SCBMain]setIsActivatedAfterScreenLocked failed, with reason ${err.code}`);
    }
  }

  /**
   * set the scene session isPendingToBackgroundState true or not
   *
   * @param state isPendingToBackgroundState
   */
  public setIsPendingToBackgroundState(session: sceneSessionManager.SceneSession,
      isPendingToBackgroundState: boolean): void {
    log.showInfo(`[SCBMain]setIsPendingToBackgroundState, state:${isPendingToBackgroundState}`);
    try {
      session.setIsPendingToBackgroundState(isPendingToBackgroundState);
    } catch (err) {
      log.showError(`[SCBMain]setIsPendingToBackgroundState failed, with reason ${err.code}`);
    }
  }

  /**
   * Check scene session is valid.
   * @param sceneSession The session of the scene which check is valid
   * @returns scene session is valid
   */
  public isSceneSessionValid(session: sceneSessionManager.SceneSession): boolean {
    if (CommonUtils.isInvalid(session)) {
      log.showError('[SCBMain]isSceneSessionValid null session');
      return false;
    }
    try {
      return sceneSessionManager.isSceneSessionValid(session);
    } catch (err) {
      log.showError(`[SCBMain]isSceneSessionValid failed, with err code:${err?.code} msg:${err?.message}`);
      return false;
    }
  }

  /**
   * request Scene Session Background
   *
   * @param session The session of the scene which to be background
   * @param isDelegator Is delegator
   * @param isToDesktop Is toDesktop
   * @param isSaveSnapshot Is do save snapshot
   */
  public requestSceneSessionBackground(session: sceneSessionManager.SceneSession, isDelegator?: boolean,
    isToDeskTop?: boolean, isSaveSnapshot?: boolean,
    backgroundReason: BackgroundReason = BackgroundReason.DEFAULT): void {
    log.showInfo(`[SCBMain][id:${session.persistentId}]requestSceneSessionBackground, ` +
      `isDelegator:${isDelegator} isToDeskTop:${isToDeskTop} isSaveSnapshot:${isSaveSnapshot}` +
      `lockReason:${backgroundReason}`);
    try {
      this.setIsPendingToBackgroundState(session, true);
      sceneSessionManager.requestSceneSessionBackground(session, isDelegator, isToDeskTop, isSaveSnapshot,
        backgroundReason);
    } catch (err) {
      log.showError('[SCBMain]requestSceneSessionBackground failed, with reason ' + JSON.stringify(err));
    }
  }

  /**
   * notify Foreground Interactive Status
   *
   * @param session
   * @param interactive
   */
  public notifyForegroundInteractiveStatus(session: sceneSessionManager.SceneSession, interactive: boolean): void {
    if (session == null) {
      log.showError('[SCBMain]notifyForegroundInteractiveStatus null session');
      return;
    }
    log.showInfo(`[SCBMain]notifyForegroundInteractiveStatus, persistentId:${session.persistentId}` +
      ` interactive:${interactive}`);
    try {
      sceneSessionManager.notifyForegroundInteractiveStatus(session, interactive);
    } catch (err) {
      log.showError('[SCBMain]notifyForegroundInteractiveStatus failed, with reason ' + JSON.stringify(err));
    }
  }

  /**
   * request Scene Session Destruction
   *
   * @param { sceneSessionManager.SceneSession } session
   * @param { Boolean } isDeletePersistentMap
   * @param { Boolean } isSaveSnapshot
   * @param { Boolean } isForceClean
   * @param { Boolean } isUserRequestedExit
   * @returns { number } destructionResult
   */
  public requestSceneSessionDestruction(session: sceneSessionManager.SceneSession, isDeletePersistentMap: boolean,
                                        isSaveSnapshot?: boolean, isForceClean?: boolean,
                                        isUserRequestedExit?: boolean): number {
    log.showWarn(`[SCBMain][id:${session.persistentId}]requestSceneSessionDestruction,` +
      `isDeletePersistentMap:${isDeletePersistentMap}, isSaveSnapshot:${isSaveSnapshot}, ` +
      `isForceClean:${isForceClean}`);
    this.setIsPendingToBackgroundState(session, true);
    const destructionResult = SCBSceneMissionManager.getInstance().requestSceneSessionDestruction(session, {
      isDeletePersistentMap: isDeletePersistentMap, isSaveSnapshot: isSaveSnapshot,
      isForceClean: isForceClean, isUserRequestedExit: isUserRequestedExit
    });
    let panelZOrder: SpecificPanelZOrder | undefined = this.getPanelZorderByType(session.type);
    if (panelZOrder === undefined) {
      panelZOrder = SpecificPanelZOrder.ABOVE_SCENE_PANEL;
    }
    if (this.destroyFloatWindowCallbackMap.has(session.screenId)) {
      let callbackMap = this.destroyFloatWindowCallbackMap.get(session.screenId);
      if (callbackMap.has(panelZOrder)) {
        callbackMap.get(panelZOrder)?.forEach(callback => callback?.(session));
      }
    } else {
      log.showError(`can't find DestroyFloatWindowCallback id ${session.screenId}, destroy fail`);
    }
    return destructionResult;
  }

  /**
   * request Scene Session By Call
   *
   * @param session
   */
  public requestSceneSessionByCall(session: sceneSessionManager.SceneSession, requestId: number = DEFAULT_REQUEST_ID): number {
    log.showInfo(`[SCBMain][id:${session.persistentId}]requestSceneSessionByCall.`);
    let activateResult = 0;
    try {
      this.setIsPendingToBackgroundState(session, false);
      sceneSessionManager.requestSceneSessionByCall(session, requestId);
    } catch (err) {
      log.showError('[SCBMain]requestSceneSessionByCall failed, with reason ' + JSON.stringify(err));
      activateResult = err.code;
    }
    return activateResult;
  }

  /**
   * init With Render Service Added
   */
  public initWithRenderServiceAdded(): void {
    TraceUtil.startTrace(DomainName.SCB, 'SCBSceneSessionManager.initWithRenderServiceAdded');
    sceneSessionManager.InitWithRenderServiceAdded();
    TraceUtil.endTrace(DomainName.SCB, 'SCBSceneSessionManager.initWithRenderServiceAdded');
  }

  private startAbilityBySpecified(sceneInfo: SCBSceneInfo): void {
    log.showInfo(`[SCBMain]startAbilityBySpecified, sceneInfo:{persistentId: ${sceneInfo.persistentId} bundleName:` +
      ` ${sceneInfo.bundleName} moduleName:${sceneInfo.moduleName} abilityName: ${sceneInfo.abilityName}}`);
    this.executeStartSceneCallback(SCBEventId.PRE_START_SPECIFIED, sceneInfo.screenId, sceneInfo);
    sceneSessionManager.startAbilityBySpecified({
      bundleName: sceneInfo.bundleName,
      moduleName: sceneInfo.moduleName,
      abilityName: sceneInfo.abilityName,
      appIndex: sceneInfo.appIndex,
      screenId: sceneInfo.screenId,
      isNewAppInstance: sceneInfo.isNewAppInstance,
      appInstanceKey: sceneInfo.appInstanceKey,
    }, sceneInfo.want);
  }

  /**
   * minimize
   *
   * @param screenId
   * @param persistentId
   * @param containerId
   * @param shouldBackToCaller
   */
  public minimize(screenId: number, persistentId?: number, containerId?: number, shouldBackToCaller?: boolean,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    log.showInfo(`[SCBMain]minimize, screenId:${screenId} persistentId:${persistentId} containerId:${containerId} shouldBackToCaller:${shouldBackToCaller}`);
    this.executeCallback(SCBEventId.MINIMIZE_SCENE, screenId, persistentId, containerId, undefined, shouldBackToCaller, extraInfo);
    this.executeSpecialCallback(SCBEventId.MINIMIZE_SCENE, screenId, persistentId, containerId);
    SCBSceneMissionManager.getInstance().minimizeScene(screenId, persistentId, containerId,
      { shouldBackToCaller: shouldBackToCaller, extraInfo: extraInfo });
  }

  /**
   * requestMidSceneBackground
   *
   * @param screenId
   * @param persistentId
   * @param containerId
   * @param shouldBackToCaller
   */
  public requestMidSceneBackground(screenId: number, persistentId?: number, containerId?: number,
    shouldBackToCaller?: boolean): void {
    log.showInfo(`[SCBMain]requestMidSceneBackground, screenId:${screenId} persistentId:${persistentId}
    containerId:${containerId} shouldBackToCaller:${shouldBackToCaller}`);
    this.executeCallback(SCBEventId.BACKGROUND_MID_SCENE, screenId, persistentId, containerId, undefined, shouldBackToCaller);
    this.executeSpecialCallback(SCBEventId.BACKGROUND_MID_SCENE, screenId, persistentId, containerId);
  }

  /**
   * minimize All Floating Scene
   *
   * @param screenId
   */
  public minimizeAllFloatingScene(screenId: number): void {
    log.showInfo(`[SCBMain]minimizeAllFloatingScene, screenId:${screenId}}`);
    this.executeMinimizeAllSceneCallback(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, screenId);
    this.executeSpecialMinimizeAllSceneCallback(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, screenId);
  }

  /**
   * Notify the hookInfo to window manager and screen manager
   * @param uid
   * @param hookInfo hookInfo
   * @param enable  add hookInfo or delete hookInfo
   */
  public updateAppHookDisplayInfo(uid: number, hookInfo: sceneSessionManager.AppHookInfo, enable: boolean): void {
    try {
      sceneSessionManager.updateAppHookDisplayInfo(uid, hookInfo, enable);
    } catch (error) {
      log.showError('updateAppHookDisplayInfo error:', error.message);
    }
  }

  /**
   * Notify the hook orientation change
   * @param persistentId
   */
  public notifyHookOrientationChange(persistentId: number): void {
    try {
      sceneSessionManager.notifyHookOrientationChange(persistentId);
    } catch (error) {
      log.showError('notifyHookOrientationChange error:', error.message);
    }
  }

  /**
   * Maximize sceneSession
   *
   * @param sceneContainerSession The session of the scene container which to be destroyed.
   */
  public maximize(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`[SCBMain]maximize, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.MAXIMIZE_SCENE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.MAXIMIZE_SCENE, screenId, persistentId, containerId);
  }

  /**
   * Maximize fullscreen sceneSession
   */
  public maximizeFullScreen(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`[SCBMain]maximize fullscreen, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.MAXIMIZE_FULLSCREEN_SCENE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.MAXIMIZE_FULLSCREEN_SCENE, screenId, persistentId, containerId);
  }

  /**
   * Maximize split scene
   *
   * @param screenId screen id
   * @param persistentId persistent id of the scene
   * @param containerId container id of the scene container
   */
  public maximizeSplit(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`maximizeSplit, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.SPLIT_TO_FULL_FOR_MAXIMIZE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.SPLIT_TO_FULL_FOR_MAXIMIZE, screenId, persistentId, containerId);
  }

  /**
   * exit game split scene
   *
   * @param screenId screen id
   * @param persistentId persistent id of the scene
   * @param containerId container id of the scene container
   */
  public exitGameSplitView(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`exitGameSplitView, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.EXIT_GAME_SPLIT_VIEW, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.EXIT_GAME_SPLIT_VIEW, screenId, persistentId, containerId);
  }

  /**
   * reset split view divider param
   *
   * @param screenId screen id
   * @param persistentId persistent id of the scene
   * @param containerId container id of the scene container
   */
  public resetSplitViewWithFold(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`resetSplitViewWithFold, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.RESET_SPLIT_VIEW_WITH_FOLD, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.RESET_SPLIT_VIEW_WITH_FOLD, screenId, persistentId, containerId);
  }

  /**
   * maximize Floating
   *
   * @param screenId
   * @param persistentId
   * @param containerId
   */
  public maximizeFloating(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`[SCBMain]maximizeFloating, persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.MAXIMIZE_FLOATING_SCENE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.MAXIMIZE_FLOATING_SCENE, screenId, persistentId, containerId);
  }

  /**
   * close Floating Scene
   *
   * @param screenId
   * @param persistentId
   * @param containerId
   */
  public closeFloatingScene(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`[SCBMain]closeFloatingScene, persistentId:${persistentId}`);
    this.executeCallback(SCBEventId.CLOSE_FLOATING_SCENE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.CLOSE_FLOATING_SCENE, screenId, persistentId, containerId);
  }

  /**
   * Close sceneSession
   *
   * @param screenId  screenId
   * @param persistentId  the session id of the scene container which to be destroyed.
   * @param containerId  the containerId of the scene container which to be destroyed.
   * @param needRemoveSession  remove session from sessionList or not
   */
  public close(screenId: number, persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    log.showInfo('[SCBMain]Request scene container session close, persistentId: ' + persistentId);
    this.executeCloseCallback(SCBEventId.CLOSE_SCENE, screenId, persistentId, containerId, needRemoveSession,
      isSaveSnapshot, extraInfo);
    this.executeCloseSpecialCallback(SCBEventId.CLOSE_SCENE, screenId, persistentId, containerId, needRemoveSession,
      isSaveSnapshot, extraInfo);
  }

  /**
   * Minimize all sceneSession
   */
  public minimizeAllScene(screenId: number): void {
    log.showInfo('[SCBMain]Request minimize all scene...');
    this.executeMinimizeAllSceneCallback(SCBEventId.MINIMIZE_ALL_SCENE, screenId);
    this.executeSpecialMinimizeAllSceneCallback(SCBEventId.MINIMIZE_ALL_SCENE, screenId);
  }

  /**
   * Split sceneSession to primary window mode
   */
  public splitPrimary(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`split primary, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.SPLIT_PRIMARY, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.SPLIT_PRIMARY, screenId, persistentId, containerId);
  }

  /**
   * Split sceneSession to secondary window mode
   */
  public splitSecondary(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`split secondary, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.SPLIT_SECONDARY, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.SPLIT_SECONDARY, screenId, persistentId, containerId);
  }

  /**
   * Split sceneSession to secondary window mode
   */
  public splitToFloat(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`split to float, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.SPLIT_TO_FLOATING, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.SPLIT_TO_FLOATING, screenId, persistentId, containerId);
  }

  public floatToSplit(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`float to split, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.FLOAT_TO_SPLIT, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.FLOAT_TO_SPLIT, screenId, persistentId, containerId);
  }

  public fullToFloat(screenId: number, persistentId?: number, containerId?: number, screenProperty?: SCBScreenProperty): void {
    log.showInfo(`full to float, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.FULL_TO_FLOATING, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.FULL_TO_FLOATING, screenId, persistentId, containerId);
  }

  public fullToSplit(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`full to split, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.FULL_TO_SPLIT, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.FULL_TO_SPLIT, screenId, persistentId, containerId);
  }

  public startSplitFromIcon(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo(`start split from icon, screenId:${screenId} persistentId:${persistentId} containerId:${containerId}`);
    this.executeCallback(SCBEventId.START_SPLIT_FROM_ICON, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.START_SPLIT_FROM_ICON, screenId, persistentId, containerId);
  }

  /**
   * Exit active split
   *
   * @param screenId: if screenId equals -1 exit all screen split; else exit split at the screen
   */
  public exitActiveSplit(screenId: number): void {
    log.showInfo(`exit active split, screenId:${screenId}`);
    if (screenId === INVALID_SCREEN_ID) {
      let screenSessionList = SCBScreenSessionManager.getInstance().getScreenSessionList();
      for (let screenSession of screenSessionList) {
        this.executeCallback(SCBEventId.EXIT_ACTIVE_SPLIT, screenSession.scbScreenProperty.screenId);
        this.executeSpecialCallback(SCBEventId.EXIT_ACTIVE_SPLIT, screenSession.scbScreenProperty.screenId);
      }
    } else {
      this.executeCallback(SCBEventId.EXIT_ACTIVE_SPLIT, screenId);
      this.executeSpecialCallback(SCBEventId.EXIT_ACTIVE_SPLIT, screenId);
    }
  }

  /**
   * Exit recent scene
   */
  public exitRecent(screenId: number): void {
    log.showInfo('Request exit recent scene...');
    this.executeMinimizeAllSceneCallback(SCBEventId.EXIT_RECENT, screenId);
  }

  /**
   * terminate
   *
   * @param screenId
   * @param persistentId
   * @param containerId
   */
  public terminate(screenId: number, persistentId?: number, containerId?: number,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    log.showInfo('[SCBMain]Request scene container session terminate, persistentId: ' + persistentId);
    const needRemoveSession = undefined;
    const shouldBackToCaller = undefined;
    this.executeCallback(SCBEventId.TERMINATE_SCENE, screenId, persistentId, containerId,
      needRemoveSession, shouldBackToCaller, extraInfo);
    this.executeSpecialCallback(SCBEventId.TERMINATE_SCENE, screenId, persistentId, containerId);
    SCBSceneMissionManager.getInstance().terminateScene(screenId, persistentId, containerId,
      { needRemoveSession: needRemoveSession, shouldBackToCaller: shouldBackToCaller, extraInfo: extraInfo });
  }

  /**
   * handle Session Exception
   *
   * @param needRemoveSession
   * @param sceneInfo
   * @param persistentId
   * @param containerId
   */
  public handleSessionException(needRemoveSession: boolean, sceneInfo: SCBSceneInfo, persistentId?: number,
    containerId?: number, extraInfo?: ExecuteCallbackExtraInfo): void {
    log.showInfo('[SCBMain]Request to handle session exception, persistentId: ' + persistentId);
    const shouldBackToCaller = undefined;
    this.executeCallback(SCBEventId.SESSION_EXCEPTION, sceneInfo.screenId, persistentId, containerId,
      needRemoveSession, shouldBackToCaller, extraInfo);
    this.executeSpecialCallback(SCBEventId.SESSION_EXCEPTION, sceneInfo.screenId, persistentId, containerId);
    this.notifySessionException(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    SCBSceneMissionManager.getInstance().terminateScene(sceneInfo.screenId, persistentId, containerId,
      {  needRemoveSession: needRemoveSession, shouldBackToCaller: shouldBackToCaller, extraInfo: extraInfo });
  }

  public updateWindowDragHotArea(screenId: number, persistentId: number): void {
    log.showInfo('Request to update window drag hot area, persistentId: ' + persistentId);
    this.executeCallback(SCBEventId.UPDATE_WINDOW_DRAG_HOT_AREA, screenId, persistentId);
    this.executeSpecialCallback(SCBEventId.UPDATE_WINDOW_DRAG_HOT_AREA, screenId, persistentId);
  }

  public switchSplitScene(screenId: number, persistentId?: number, containerId?: number): void {
    log.showInfo('Request scene container switch split scene, persistentId: ' + persistentId);
    this.executeCallback(SCBEventId.SWITCH_SPLIT_SCENE, screenId, persistentId, containerId);
    this.executeSpecialCallback(SCBEventId.SWITCH_SPLIT_SCENE, screenId, persistentId, containerId);
  }

  private executeCallback(eventId: SCBEventId, screenId: number, persistentId?: number, containerId?: number,
    needRemoveSession?: boolean, shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    if (MISSION_MANAGEMENT_TRACE_MAP.has(eventId)) {
      TraceUtil.startTrace(DomainName.WINDOW, MISSION_MANAGEMENT_TRACE_MAP.get(eventId) +
        ` persistentId:${persistentId}`);
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value(persistentId, containerId, needRemoveSession, shouldBackToCaller, extraInfo);
    });
    if (MISSION_MANAGEMENT_TRACE_MAP.has(eventId)) {
      TraceUtil.endTrace(DomainName.WINDOW, MISSION_MANAGEMENT_TRACE_MAP.get(eventId) +
        ` persistentId:${persistentId}`);
    }
  }

  private executeCloseCallback(
    eventId: SCBEventId, screenId: number, persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value(persistentId, containerId, needRemoveSession, isSaveSnapshot, extraInfo);
    });
  }

  private executeSpecialCallback(eventId: SCBEventId, screenId: number, persistentId?: number, containerId?: number): void {
    if (!this.specialCallbackMap.has(eventId)) {
      log.showDebug(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.specialCallbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showDebug(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    if (MISSION_MANAGEMENT_TRACE_ON_SPECIAL_MAP.has(eventId)) {
      TraceUtil.startTrace(DomainName.WINDOW, MISSION_MANAGEMENT_TRACE_ON_SPECIAL_MAP.get(eventId) +
        ` persistentId:${persistentId}`);
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value(persistentId, containerId);
    });
    if (MISSION_MANAGEMENT_TRACE_ON_SPECIAL_MAP.has(eventId)) {
      TraceUtil.endTrace(DomainName.WINDOW, MISSION_MANAGEMENT_TRACE_ON_SPECIAL_MAP.get(eventId) +
        ` persistentId:${persistentId}`);
    }
  }

  private executeCloseSpecialCallback(eventId: SCBEventId, screenId: number, persistentId?: number, containerId?: number,
    needRemoveSession?: boolean, isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    if (!this.specialCallbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.specialCallbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value(persistentId, containerId, needRemoveSession, isSaveSnapshot, extraInfo);
    });
  }

  private executeSpecialStartSceneCallback(eventId: SCBEventId, screenId: number,
    toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo) : CommonResult {
    if (!this.specialCallbackMap.has(eventId)) {
      log.showError(`No start scene func eventId:${eventId} has registered!`);
      // Add the start command to the queue when the callback is not registered
      this.startAbilityQueue.push({ eventId: eventId, screenId: screenId, toInfo: toInfo, fromInfo: fromInfo });
      return CommonResult.FAIL;
    }
    let startSceneFuncMap = this.specialCallbackMap.get(eventId);
    screenId = (toInfo.screenId === -1) ? this.mainScreenId : toInfo.screenId;
    if (!startSceneFuncMap.has(screenId)) {
      log.showError(`No start scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      // Add the start command to the queue when the callback is not registered
      this.startAbilityQueue.push({ eventId: eventId, screenId: screenId, toInfo: toInfo, fromInfo: fromInfo });
      return CommonResult.FAIL;
    }
    log.showInfo(`Start scene on screen with screenId: ${screenId}!`);
    let functions = startSceneFuncMap.get(screenId);
    let callbackResult: CommonResult = CommonResult.SUCCESS;
    functions.forEach((value: Function) => {
      if (value(toInfo, fromInfo) === CommonResult.FAIL) {
        callbackResult = CommonResult.FAIL;
      }
    });
    return callbackResult;
  }


  /**
   * Get scene persistent instance
   */
  public getScenePersistent(): SCBScenePersistent {
    return this.scenePersistent;
  }

  private executeStartSceneCallback(eventId: SCBEventId, screenId: number,
    toInfo: SCBSceneInfo | SCBSceneInfo[], fromInfo?: SCBSceneInfo, isBackTransition?: boolean,
    isFromClient?: boolean): CommonResult {
    toInfo = Array.isArray(toInfo) ? toInfo : [toInfo];
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No start scene func eventId:${eventId} has registered!`);
      // Add the start command to the queue when the callback is not registered
      toInfo.forEach((v, i) => {
        this.startAbilityQueue.push({ eventId: eventId, screenId: screenId, toInfo: v, fromInfo: fromInfo });
      });
      return CommonResult.SUCCESS;
    }
    let startSceneFuncMap = this.callbackMap.get(eventId);
    let needReturn = false;
    toInfo.forEach((v, i) => {
      screenId = (v.screenId === INVALID_SCREEN_ID) ? this.mainScreenId : v.screenId;
      if (!startSceneFuncMap.has(screenId)) {
        needReturn = true;
        log.showError(`No start scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
        // Add the start command to the queue when the callback is not registered
        this.startAbilityQueue.push({ eventId: eventId, screenId: screenId, toInfo: v, fromInfo: fromInfo });
      }
    });
    if (needReturn) {
      return CommonResult.FAIL;
    }
    log.showInfo(`Start scene on screen with screenId: ${screenId}!`);
    let functions = startSceneFuncMap.get(screenId);
    toInfo = (toInfo.length === 1) ? toInfo[0] : toInfo;
    let callbackResult: CommonResult = CommonResult.SUCCESS;
    functions.forEach((value: Function) => {
      if (value(toInfo, fromInfo, isBackTransition, isFromClient) === CommonResult.FAIL) {
        callbackResult = CommonResult.FAIL;
      }
    });
    return callbackResult;
  }

  private executeMinimizeAllSceneCallback(eventId: SCBEventId, screenId: number): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.MINIMIZE_ALL_SCENE);
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value();
    });
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.MINIMIZE_ALL_SCENE);
  }

  private executeSpecialMinimizeAllSceneCallback(eventId: SCBEventId, screenId: number): void {
    if (!this.specialCallbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.specialCallbackMap.get(eventId);
    screenId = (screenId === -1) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.MINIMIZE_ALL_SCENE_ON_SPECIAL);
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value();
    });
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.MINIMIZE_ALL_SCENE_ON_SPECIAL);
  }

  private executeSwitchUserCompleteCallback(eventId: SCBEventId, screenId: number): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value();
    });
  }

  /**
   * get Focused Session
   *
   * @returns
   */
  public getFocusedSession(
    displayId: number = DEFAULT_DISPLAY_GROUP_ID
    ): SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null {
    return this.windowFocusController.getFocusedSession(displayId);
  }

  /**
   * get Focused Session Id
   *
   * @returns
   */
  public getFocusedSessionId(displayId: number = DEFAULT_DISPLAY_GROUP_ID): number {
    return this.windowFocusController.getFocusedSessionId(displayId);
  }

  /**
   * get Focus SceneSession
   * @returns
   */
  public getFocusedSceneSession(displayId: number = DEFAULT_DISPLAY_GROUP_ID): SCBSceneSession | null {
    return this.windowFocusController.getFocusedSceneSession(displayId);
  }

  /**
   * refresh ZOrder
   *
   * @returns
   */
  public async refreshZOrder(): Promise<void> {
    // bypass refreshZorder traverse
    if (this.isCoreEnable) {
      WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, `refreshZorder bypass, isCoreEnable: ` + this.isCoreEnable);
      return;
    }
    WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, `refreshzorder start`);
    this.zOrder = 1;
    let func = (scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean => {
      WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, 'refresh session id: ' + scbSession?.session?.persistentId);
      if (scbSession && (scbSession.getVisibility() || scbSession.isActive || ACTIVE_STATUS_MAP.get(scbSession.sessionState))) {
        scbSession.setZOrder(this.zOrder++);
      }
      return false; // do not end traverse
    };
    this.traverseSessionTree(func, false, TraverseSessionScenarios.REFRESH_ZORDER);
    WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, `refreshzorder end`);
    sceneSessionManager.checkSceneZOrder();
  }

  /**
   * get Session By Id
   *
   * @param persistentId
   * @returns
   */
  public getSessionById(persistentId: number): SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession {
    log.showDebug(`get session by persistentId: ${persistentId}`);
    let sessionFound: boolean = false;
    let ret: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession = null;
    let func = (scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean => {
      if (sessionFound) {
        return true;
      }
      if (!scbSession) {
        return false;
      }
      if (scbSession.session.persistentId === persistentId) {
        ret = scbSession;
        sessionFound = true;
        return true;
      }
      return false;
    };
    this.traverseSessionTree(func, false, TraverseSessionScenarios.GET_SESSION_BY_ID);
    return ret;
  }

  /**
   * traverse methods
   * @param func: false means continuing traverse
   * @param isFromTopToBottom: direction of traverse
   */
  private traverseSessionTree(func: Function, isFromTopToBottom: boolean, traverseScenario: number): void {
    TraceUtil.startTrace(DomainName.SCB, 'traverseSessionTree');
    let tempTimestamp = (systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true) ?? 0) / 1000; // us
    for (let screen of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenId = screen.session.screenId;
      if (isFromTopToBottom) {
        // 若有自顶向下的遍历逻辑，则需要根据traverseScenario差异化处理
        this.traverseSessionTreeFromTopToBottom(func, traverseScenario, screenId);
      } else {
        this.traverseSessionTreeFromBottomToTop(func, traverseScenario, screenId);
      }
    }
    TraceUtil.endTrace(DomainName.SCB, 'traverseSessionTree');
    let duration = (systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true) ?? 0) / 1000 - tempTimestamp;
    this.maxTraverseDuration = Math.max(duration, this.maxTraverseDuration);
    // 单次超过5ms，打印具体信息
    if (duration >= TRAVERSE_TREE_DURATION_TIME_THRESHOLD) {
      log.showInfo(`getSessionById duration time: ${duration} us, max: ${this.maxTraverseDuration} us`);
    }
  }

  private traverseSessionTreeFromTopToBottom(func: Function, traverseScenario: number, screenId?: number): void {
    log.showInfo('traverse from top to bottom');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (!this.panelLists.has(screenId)) {
      log.showInfo('list traversing is null');
      return;
    }
    let zTop = this.panelLists.get(screenId).length - 1;
    let zPanel = zTop - 1;
    if (zPanel < 0) {
      return;
    }
    let keyboardPanel : SCBSystemSceneSession = SCBKeyboardManager.getInstance().getPanelSession();
    // pc input method
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC) {
      if (SCBKeyboardManager.getInstance().getKeyboardList) {
        let inputMethodList = SCBKeyboardManager.getInstance().getKeyboardList();
        if (inputMethodList !== null) {
          log.showDebug('inputMethodList.length = %{public}d', inputMethodList.length);
          for (let i = 0; i < inputMethodList.length; i++) {
            func(keyboardPanel);
            if (this.traverseFromBottomToTop(inputMethodList[i], func)) {
              return;
            }
          }
        } else {
          log.showWarn('null inputMethodList');
        }
      }
    }

    const singleScreenSystemSceneListLen = this.systemSceneList.get(screenId)?.length || 0;
    if (singleScreenSystemSceneListLen === 0) {
      log.showDebug(`systemSceneList has no entries for screenId: ${screenId}`);
    }
    for (let i = singleScreenSystemSceneListLen - 1; i >= 0; --i) {
      let scbSession = this.systemSceneList.get(screenId)[i];
      if (!(scbSession && scbSession.session)) {
        continue;
      }
      if (scbSession.isOverlayScene){
        continue;
      }
      let keyboardSession : SCBKeyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
      let keyboardState : KeyboardState = SCBKeyboardManager.getInstance().getKeyboardState();
      let keyboardDialog : SCBSystemSceneSession = SCBKeyboardPanelManager.getInstance().getPanelDialogSession();
      if (scbSession.zIndex > this.panelLists.get(screenId)[zPanel][0]) {
        // SHOW_IN_BELOW_SPECIFIC_SCENE
        if (zPanel + 1 === SCBPanelZOrder.SPECIFIC_ABOVE_SYSTEMUI && keyboardSession && keyboardSession.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE && scbSession.zIndex > keyboardSession.getZIndex()) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        if (zPanel + 1 === SCBPanelZOrder.SPECIFIC_ABOVE_KEYGUARD && keyboardSession && keyboardSession.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE &&
          scbSession.zIndex > keyboardSession.getZIndex()) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
      }
      // traverse panelList
      while (scbSession.zIndex < this.panelLists.get(screenId)[zPanel][0]) {
        let panelList = this.panelLists.get(screenId)[zPanel][1]();
        if (!panelList) {
          zPanel--;
          if (zPanel < 0) {
            return;
          }
          break;
        }
        if (zPanel === SCBPanelZOrder.SCENE_PANEL && this.getMultiWindowDialogSession) {
          func(this.getMultiWindowDialogSession);
        }
        if (zPanel === SCBPanelZOrder.FLOATING_SCENE_PANEL && this.getMultiWindowDialogSession) {
          func(this.getMultiWindowDialogSession);
        }
        // input method
        if (zPanel === SCBPanelZOrder.SCENE_PANEL && keyboardSession && keyboardSession.isKeyboardShowing() &&
          (keyboardState === KeyboardState.SHOW_IN_BELOW_SCENE_PANEL || keyboardState === KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE)) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        if (zPanel === SCBPanelZOrder.SPECIAL_SCENE_PANEL && keyboardSession && keyboardSession.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_ABOVE_SCENE_PANEL) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        if (this.traversePanelFromTopToBottom(panelList, func)) {
          return;
        }
        zPanel--;
        if (zPanel < 0) {
          return;
        }
      }
      // input method above float container
      if (keyboardSession && keyboardSession.isKeyboardShowing() &&
        keyboardState === KeyboardState.SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE) {
        func(keyboardPanel);
        func(keyboardSession);
        if (func(keyboardDialog)) {
          return;
        }
      }
      // traverse systemScene
      if (this.traverseFromTopToBottom(scbSession, func)) {
        return;
      }
    }
    while (zPanel >= 0) {
      if (this.traversePanelListFromTopToBottom(zPanel, func, screenId)) {
        return;
      }
      zPanel--;
    }
  }

  private traversePanelListFromBottomToTop(zPanel: number, func: Function, screenId?: number): boolean {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let panelList = this.panelLists.get(screenId)[zPanel][1]();
    if (!panelList) {
      return false;
    }
    if (this.traversePanelFromBottomToTop(panelList, func)) {
      return true;
    }
    return false;
  }

  private traversePanelListFromTopToBottom(zPanel: number, func: Function, screenId?: number): boolean {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let panelList = this.panelLists.get(screenId)[zPanel][1]();
    if (!panelList) {
      return false;
    }
    if (this.traversePanelFromTopToBottom(panelList, func)) {
      return true;
    }
    return false;
  }

  private traversePanelFromTopToBottom(panelList, func: Function): boolean {
    if (panelList == null) {
      return false;
    }
    for (let i = panelList.length - 1; i >= 0; --i) {
      // same
      let panelSession = panelList[i];
      if (panelSession instanceof SCBSceneContainerSession) {
        // divider & split menu
        if (this.traverseOverlaySessionTopToBottom(panelSession.getOverlaySessionList(), func)) {
          return true;
        }
        if (panelSession.isSplit) {
          if (func(panelSession.dividerSession)) {
            return true;
          }
        }
        if (panelSession.isMidScene) {
          if (this.traverseMidSceneFromTopToBottom(panelSession, func)) {
            return true;
          }
        } else {
          if (this.traverseOverlaySessionTopToBottom(panelSession.secondarySession?.getOverlaySessionList(), func)) {
            return true;
          }
          if (this.traverseFromTopToBottom(panelSession.secondarySession, func)) {
            return true;
          }
          if (this.traverseOverlaySessionTopToBottom(panelSession.primarySession?.getOverlaySessionList(), func)) {
            return true;
          }
          if (this.traverseFromTopToBottom(panelSession.primarySession, func)) {
            return true;
          }
        }
        continue;
      }
      if (panelSession instanceof SCBSpecificSession || panelSession instanceof SCBSceneSession) {
        if (this.traverseFromTopToBottom(panelList[i], func)) {
          return true;
        }
        if (panelSession instanceof SCBSceneSession && this.traverseOverlaySessionTopToBottom(panelSession.getOverlaySessionList(), func)) {
          return true;
        }
      }
    }
    return false;
  }


  private traverseMidSceneFromBottomToTop(panelSession, func): boolean {
    let midScene = Array.from(panelSession.getMidScenes());
    midScene.sort((a: [number, SCBSceneSession], b: [number, SCBSceneSession]) => {
      return a[1].sceneParam.zIndex - b[1].sceneParam.zIndex;
    });
    for (let ele of midScene) {
      if (this.traverseFromBottomToTop(ele[1], func)) {
        return true;
      }
      if (this.traverseOverlaySession(ele[1].getOverlaySessionList(), func)) {
        return true;
      }
    }
    return false;
  }

  private traverseMidSceneFromTopToBottom(panelSession, func): boolean {
    let midScene = Array.from(panelSession.getMidScenes());
    midScene.sort((a: [number, SCBSceneSession], b: [number, SCBSceneSession]) => {
      return b[1].sceneParam.zIndex - a[1].sceneParam.zIndex;
    });
    for (let ele of midScene) {
      if (this.traverseOverlaySessionTopToBottom(ele[1].getOverlaySessionList(), func)) {
        return true;
      }
      if (this.traverseFromTopToBottom(ele[1], func)) {
        return true;
      }
    }
    return false;
  }

  private traverseOverlaySessionTopToBottom(overlaySessionList: SCBSystemSceneSession[], func): boolean {
    if (CommonUtils.isInvalid(overlaySessionList)) {
      return false;
    }
    if (overlaySessionList.length <= 0) {
      return false;
    }
    for (let i = overlaySessionList.length - 1; i >= 0; --i) {
      if (func(overlaySessionList[i])) {
        return true;
      }
    }
    return false;
  }

  private traverseFromTopToBottom(scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession, func): boolean {
    // traverse subSessionList
    if (scbSession === null) {
      return false;
    }
    if (scbSession instanceof SCBSceneSession) {
      let dialogList = scbSession.dialogSessionList;
      for (let i = dialogList.length - 1; i >= 0; --i) {
        if (dialogList[i] !== null && func(dialogList[i])) {
          return true;
        }
      }
      for (let i = scbSession.subSessionList.length - 1; i >= 0; --i) {
        if (scbSession.subSessionList[i] !== null && func(scbSession.subSessionList[i])) {
          return true;
        }
      }
    }
    if (func(scbSession)) {
      return true;
    }
    return false;
  }

  private traverseSessionTreeFromBottomToTop(func: Function, traverseScenario: number, screenId?: number): void {
    log.showDebug('traverse from bottom to top by Scenario: ' + traverseScenario);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    log.showDebug(`screenId: ${screenId}`);
    if (!this.panelLists.has(screenId)) {
      log.showDebug('list traversing is null');
      return;
    }
    let zPanel = 1;
    if (zPanel >= this.panelLists.get(screenId).length) {
      return;
    }
    let keyboardSession : SCBKeyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    let keyboardPanel : SCBSystemSceneSession = SCBKeyboardManager.getInstance().getPanelSession();
    let keyboardState : KeyboardState = SCBKeyboardManager.getInstance().getKeyboardState();
    let keyboardDialog : SCBSystemSceneSession = SCBKeyboardPanelManager.getInstance().getPanelDialogSession();

    if (traverseScenario === TraverseSessionScenarios.GET_SESSION_BY_ID) {
      if (func(keyboardPanel)) {
        return;
      }
      if (func(keyboardSession)) {
        return;
      }
      if (func(keyboardDialog)) {
        return;
      }
    }

    let voiceInteraction = false;
    let keyboardZindex = 0;
    if (traverseScenario === TraverseSessionScenarios.REFRESH_ZORDER) {
      keyboardZindex = keyboardSession?.getZIndex();
      voiceInteraction = (keyboardZindex > this.panelZIndex.voiceInteraction &&
        keyboardZindex < this.panelZIndex.specificAboveKeyguard);
    }

    const singleScreenSystemSceneListLen = this.systemSceneList.get(screenId)?.length || 0;
    if (singleScreenSystemSceneListLen === 0) {
      log.showDebug(`systemSceneList has no entries for screenId: ${screenId}`);
    }
    for (let i = 0; i < singleScreenSystemSceneListLen; ++i) {
      let scbSession = this.systemSceneList.get(screenId)[i];
      if (!(scbSession && scbSession.session)) {
        continue;
      }
      if (scbSession.isOverlayScene){
        continue;
      }
      if (scbSession.zIndex > this.panelLists.get(screenId)[zPanel][0] && traverseScenario === TraverseSessionScenarios.REFRESH_ZORDER) {
        // SHOW_IN_BELOW_SPECIFIC_SCENE
        if (zPanel - 1 === SCBPanelZOrder.SPECIFIC_ABOVE_SYSTEMUI && keyboardSession?.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE && scbSession.zIndex > keyboardZindex) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        if (!voiceInteraction && zPanel - 1 === SCBPanelZOrder.SPECIFIC_ABOVE_KEYGUARD &&
          keyboardSession && keyboardSession.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE &&
          scbSession.zIndex > keyboardZindex) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
      }
      // traverse panelList
      while (scbSession.zIndex > this.panelLists.get(screenId)[zPanel][0]) {
        let panelList = this.panelLists.get(screenId)[zPanel][1]();
        if (panelList == null) {
          zPanel++;
          if (zPanel >= this.panelLists.get(screenId).length) {
            return;
          }
          break;
        }
        log.showDebug(`zPanel: ${zPanel} panelList size: ${panelList.length}`);
        TraceUtil.startTrace(DomainName.SCB, `traversePanelFromBottomToTop_${screenId}_${zPanel}`);
        if (this.traversePanelFromBottomToTop(panelList, func)) {
          TraceUtil.endTrace(DomainName.SCB, `traversePanelFromBottomToTop_${screenId}_${zPanel}`);
          return;
        }
        TraceUtil.endTrace(DomainName.SCB, `traversePanelFromBottomToTop_${screenId}_${zPanel}`);
        if (voiceInteraction && zPanel === SCBPanelZOrder.SPECIFIC_VOICE_INTERACTION && keyboardSession && keyboardSession.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE && scbSession.zIndex > keyboardZindex) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        // input method
        if (zPanel === SCBPanelZOrder.SCENE_PANEL && keyboardSession && keyboardSession.isKeyboardShowing() &&
          (keyboardState === KeyboardState.SHOW_IN_BELOW_SCENE_PANEL || keyboardState === KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE)) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        if (zPanel === SCBPanelZOrder.SPECIAL_SCENE_PANEL && keyboardSession && keyboardSession.isKeyboardShowing() &&
          keyboardState === KeyboardState.SHOW_IN_ABOVE_SCENE_PANEL) {
          func(keyboardPanel);
          func(keyboardSession);
          if (func(keyboardDialog)) {
            return;
          }
        }
        if (zPanel === SCBPanelZOrder.SCENE_PANEL && this.getMultiWindowDialogSession) {
          func(this.getMultiWindowDialogSession);
        }
        if (zPanel === SCBPanelZOrder.FLOATING_SCENE_PANEL && this.getMultiWindowDialogSession) {
          func(this.getMultiWindowDialogSession);
        }
        zPanel++;
        if (zPanel >= this.panelLists.get(screenId).length) {
          return;
        }
      }
      // traverse systemScene
      if (this.traverseFromBottomToTop(scbSession, func)) {
        return;
      }
      // pc input method
      const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
      if (uiType === SCBConstants.UITYPE_PC) {
        if (SCBKeyboardManager.getInstance().getKeyboardList) {
          let inputMethodList = SCBKeyboardManager.getInstance().getKeyboardList();
          if (inputMethodList !== null) {
            log.showDebug('inputMethodList.length = %{public}d', inputMethodList.length);
            for (let i = 0; i < inputMethodList.length; i++) {
              func(keyboardPanel);
              if (this.traverseFromBottomToTop(inputMethodList[i], func)) {
                return;
              }
            }
          } else {
            log.showWarn('null inputMethodList');
          }
        }
      }
    }

    while (zPanel < this.panelLists.get(screenId).length) {
      TraceUtil.startTrace(DomainName.SCB, `traversePanelListFromBottomToTop_${screenId}_${zPanel}`);
      if (this.traversePanelListFromBottomToTop(zPanel, func, screenId)) {
        TraceUtil.endTrace(DomainName.SCB, `traversePanelListFromBottomToTop_${screenId}_${zPanel}`);
        return;
      }
      TraceUtil.endTrace(DomainName.SCB, `traversePanelListFromBottomToTop_${screenId}_${zPanel}`);
      zPanel++;
    }
  }

  private traverseDividerPanelSession(panelSession: SCBSceneContainerSession, func: Function): boolean {
    if (this.isPcOrPcMode() && panelSession.isSplit &&
      panelSession.dividerParam.isFocusPrimary === true) {
      if (this.traverseFromBottomToTop(panelSession.secondarySession, func)) {
        return true;
      }
      if (this.traverseOverlaySession(panelSession.secondarySession?.getOverlaySessionList(), func)) {
        return true;
      }
      if (this.traverseFromBottomToTop(panelSession.primarySession, func)) {
        return true;
      }
      if (this.traverseOverlaySession(panelSession.primarySession?.getOverlaySessionList(), func)) {
        return true;
      }
    } else if (panelSession.isMidScene) {
      if (this.traverseMidSceneFromBottomToTop(panelSession, func)) {
        return true;
      }
    } else {
      if (this.traverseFromBottomToTop(panelSession.primarySession, func)) {
        return true;
      }
      if (this.traverseOverlaySession(panelSession.primarySession?.getOverlaySessionList(), func)) {
        return true;
      }
      if (this.traverseFromBottomToTop(panelSession.secondarySession, func)) {
        return true;
      }
      if (this.traverseOverlaySession(panelSession.secondarySession?.getOverlaySessionList(), func)) {
        return true;
      }
    }
    return false;
  }

  private traversePanelFromBottomToTop(panelList, func: Function): boolean {
    if (panelList == null) {
      return false;
    }
    for (let i = 0; i < panelList.length; ++i) {
      // same
      let panelSession = panelList[i];
      if (panelSession instanceof SCBSceneContainerSession) {
        if (this.traverseDividerPanelSession(panelSession, func)) {
          return true;
        }
        // divider & split menu
        if (this.traverseOverlaySession(panelSession.getOverlaySessionList(), func)) {
          return true;
        }
        if (panelSession.isSplit) {
          if (func(panelSession.dividerSession)) {
            return true;
          }
        }
        continue;
      }
      if (panelSession instanceof SCBSpecificSession || panelSession instanceof SCBSceneSession) {
        if (this.traverseFromBottomToTop(panelList[i], func)) {
          return true;
        }
        if (panelSession instanceof SCBSceneSession && this.traverseOverlaySession(panelSession.getOverlaySessionList(), func)) {
          return true;
        }
      }
    }
    return false;
  }

  private traverseOverlaySession(overlaySessionList: SCBSystemSceneSession[], func): boolean {
    if (CommonUtils.isInvalid(overlaySessionList) || overlaySessionList.length === 0) {
      return false;
    }
    for (let i = 0; i < overlaySessionList.length; i++) {
      if (func(overlaySessionList[i])) {
        return true;
      }
    }
    return false;
  }

  private traverseSubList(subList: SCBSpecificSceneSessionList, func): boolean {
    for (let i = 0; i < subList.length; i++) {
      let subItem = subList[i];
      if (subItem !== null) {
        if (func(subItem)) {
          return true;
        }
        let subsubSession = subItem.subSessionList;
        if (subsubSession !== null && this.traverseSubList(subsubSession, func)) {
          return true;
        }
      }
    }
    return false;
  }

  private traverseFromBottomToTop(
    scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | SCBKeyboardSession, func): boolean {
    if (scbSession === null) {
      return false;
    }
    if (func(scbSession)) {
      return true;
    }
    if (scbSession instanceof SCBSceneSession) {
      let subList = scbSession.subSessionList;
      if (subList !== null && this.traverseSubList(subList, func)) {
        return true;
      }

      let dialogList = scbSession.dialogSessionList;
      if (dialogList !== null) {
        for (let i = 0; i < dialogList.length; i++) {
          if (dialogList[i] !== null && func(dialogList[i])) {
            log.showWarn('end traverse dialog session');
            return true;
          }
        }
      } else {
        log.showInfo('null dialog list');
      }
    } else if (scbSession instanceof SCBSpecificSession) {
      // traverse subWindows of system window
      let subsubSession = scbSession.subSessionList;
      if (subsubSession !== null && this.traverseSubList(subsubSession, func)) {
        return true;
      }
    }
    return false;
  }

  public insertToTopByModalType(specificSession: SCBSpecificSession, specificSessionList: SCBSpecificSceneSessionList): number {
    if (!(specificSession && specificSessionList)) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'specific session insert failed');
      return 0;
    }
    const startIndex: number = this.getSpecificWindowTopIndex(specificSession, specificSessionList) + 1;
    specificSessionList.splice(startIndex, 0, specificSession);
    return startIndex;
  }

  private getSpecificWindowTopIndex(specificSession: SCBSpecificSession, subSessionList: SCBSpecificSceneSessionList): number {
    let index: number = subSessionList.length - 1;
    if (specificSession.isSpecialTopmostUECSubWindow()) {
      return index;
    }
    for (; index >= 0; index--) {
      const item = subSessionList[index];
      if (specificSession.session.zLevel >= item.session.zLevel && !item.isSpecialTopmostUECSubWindow()) {
        WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `new zlevel: ${specificSession.session.zLevel}, old zlevel: ${item.session.zLevel}`);
        break;
      }
    }
    return index;
  }

  public modalTypeToLevelHeight(modalType: sceneSessionManager.SubWindowModalType, isTopmost: boolean): number {
    let num: number = 0;
    switch (modalType) {
      case sceneSessionManager.SubWindowModalType.TYPE_APPLICATION_MODALITY:
        num += 100;
      case sceneSessionManager.SubWindowModalType.TYPE_TOAST:
        num += 1;
      case sceneSessionManager.SubWindowModalType.TYPE_TEXT_MENU:
        num += 1;
      case sceneSessionManager.SubWindowModalType.TYPE_DIALOG:
      case sceneSessionManager.SubWindowModalType.TYPE_WINDOW_MODALITY:
        num += 10;
      case sceneSessionManager.SubWindowModalType.TYPE_NORMAL:
        num += 1;
      default:
        break;
    }
    if (isTopmost) {
      num += 3;
    }
    return num;
  }

  /**
   * shift focus callback executed by C++
   * @param nextId: shift to nextId
   * @param displayGroupId: displayId of next window
   */
  private onShiftFocus(nextId: number, displayGroupId: number = 0): void {
    const focusGroup = this.windowFocusController.getFocusGroupByGroupId(displayGroupId);
    const focusedSession = focusGroup?.focusedSession;
    const focusedSessionId = focusGroup?.focusedSessionId || INVALID_PERSISTENT_ID;
    if (focusGroup && focusGroup.displayGroupId !== displayGroupId) {
      displayGroupId = focusGroup.displayGroupId;
    }
    log.showInfo(`onShiftFocus id: ${focusedSessionId} -> ${nextId}, displayGroupId: ${displayGroupId}`);
    // unfocus
    if (focusedSession) {
      focusedSession.setFocused(false);
      if (focusedSession instanceof SCBSystemSceneSession && focusedSession.session) {
        ViewManagerPolicy.notifyViewLoseFocus(focusedSessionId);
      }
    }
    let nextSession = this.getSessionById(nextId);
    if (!nextSession) {
      log.showWarn(`onShiftFocus get nextSession failed. nextId:${nextId}, ` +
        `focusedSession persistentId:${focusedSession?.session.screenId}`);
    }
    // notify focused screen change
    if (nextSession?.session && focusedSession?.session &&
      (nextSession?.session.screenId !== focusedSession?.session.screenId)) {
      this.notifyFocusedScreenChange(focusedSession.session.screenId, nextSession.session.screenId,
        nextSession.session.persistentId);
    }
    const lastFocusedSessionId = focusedSessionId;
    this.windowFocusController.setFocusedSession(displayGroupId, nextId, focusedSessionId, nextSession);
    // notify unfocus
    this.onUnfocusedCallbacks.forEach(callback => {
      if (callback) {
        callback(lastFocusedSessionId);
      }
    });
    // notify focus
    if (nextSession) {
      nextSession.setFocused(true);
      this.notifyFocused(nextId, nextSession);
    }
    this.dealNextSessionFocus(nextSession, nextId);
  }

  private notifyFocused(nextId: number,
    nextSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): void {
    if (!(nextSession instanceof SCBSceneSession) && this.requestFocusCallback) {
      this.requestFocusCallback(nextSession);
    }
    if (nextSession instanceof SCBSystemSceneSession) {
      ViewManagerPolicy.notifyViewGainFocus(nextId);
    }
    this.requestFocusCallbacks.forEach(requestFocusCallback => {
      if (requestFocusCallback) {
        requestFocusCallback(nextId);
      }
    });
  }

  /**
   * 重置FocusedSession 废弃
   */
  public resetFocusedSession(): void {}

  private notifyFocusedScreenChange(fromScreen: number, toScreen: number, toPersistentId: number): void {
    log.showInfo(`notifyFocusedScreenChange fromScreen:${fromScreen}, toScreen:${toScreen}, ` +
      `toPersistentId: ${toPersistentId}`);
    for (let callback of this.focusedScreenChangeCallbacks) {
      if (callback) {
        callback(fromScreen, toScreen, toPersistentId);
      }
    }
  }

  private dealNextSessionFocus(nextSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession,
                               nextId: number): void {
    if (this.isPcOrPcMode() && nextSession) {
      if (nextSession instanceof SCBSceneSession && (nextSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY ||
        nextSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY)) {
        let containerSessionList = this.getAllContainerSessionList();
        for (let list of containerSessionList) {
          if (list.isSplit && list.secondarySession && list.primarySession.sceneInfo.persistentId === nextId) {
            list.dividerParam.isFocusPrimary = true;
            list.dividerParam.isPrimaryRaise = true;
            break;
          }
          if (list.isSplit && list.secondarySession && list.secondarySession.sceneInfo.persistentId === nextId) {
            list.dividerParam.isFocusPrimary = false;
            list.dividerParam.isPrimaryRaise = false;
            break;
          }
        }
      }
    }
  }

  private executeBack(screenId?: number, persistentId?: number, reason?: SCBWindowRaiseReason): void {
    this.executeCallback(SCBEventId.SESSION_RAISE_TO_TOP, screenId, persistentId, undefined, undefined, undefined, {
      raiseReason: reason
    });
    this.executeSpecialCallback(SCBEventId.SESSION_RAISE_TO_TOP, screenId, persistentId);
  }

  /**
   * Request sceneSession to top
   *
   * @param screenId
   * @param persistentId
   * @param reason
   */
  public requestToTop(screenId?: number, persistentId?: number,
                      reason: SCBWindowRaiseReason = SCBWindowRaiseReason.DEFAULT,
                      isIgnoreModalApplication: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `request top id: ${persistentId}, ${reason}`);
    if (this.isPc()) {
      let screenSessionArray: SCBScreenSessionArray = SCBScreenSessionManager.getInstance().getScreenSessionList();
      screenSessionArray.forEach((screenSession) => {
        this.requestSingleScreenToTop(screenSession.session.screenId, persistentId, reason, isIgnoreModalApplication);
      });
      return;
    }
    this.requestSingleScreenToTop(screenId, persistentId, reason, isIgnoreModalApplication);
  }

  private requestSingleScreenToTop(screenId?: number, persistentId?: number,
                                   reason: SCBWindowRaiseReason = SCBWindowRaiseReason.DEFAULT,
                                   isIgnoreModalApplication: boolean = false): void {
    if (persistentId === INVALID_PERSISTENT_ID) {
      return;
    }
    if (!this.isPcOrPcMode() || isIgnoreModalApplication) {
      this.executeBack(screenId, persistentId, reason);
      return;
    }
    const sceneList : SCBSceneContainerSessionArray = this.getSceneList(persistentId, undefined, screenId);
    const sceneListLength: number = sceneList.length;
    let appModalSessionIndex: number = this.getApplicationModalSessionIndex(sceneList, sceneListLength, false, true);
    if (appModalSessionIndex === -1) {
      this.executeBack(screenId, persistentId, reason);
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `request top screenId ${screenId} persistentId ${persistentId}`);
      return;
    }
    for (let i = 0; i < sceneListLength; i++) {
      if (i !== appModalSessionIndex) {
        const sceneInfo = sceneList[i].primarySession.sceneInfo;
        this.executeBack(screenId, sceneInfo.persistentId);
      }
    }
    const sceneInfo = sceneList[appModalSessionIndex].primarySession.sceneInfo;
    this.executeBack(screenId, sceneInfo.persistentId, reason);
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `request top appmodalwindow screenId ${sceneInfo.screenId} persistentId ${sceneInfo.persistentId}`);
    return;
  }

  /**
   * Raise main window above another
   *
   * @param persistentId
   * @param targetPersistentId
   */
  public raiseMainWindowAboveTarget(persistentId: number, targetPersistentId: number): void {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `raiseMainWindowAboveTarget, sourceId: ${persistentId}, targetId:${targetPersistentId}`);
    const allContainerSessionList: SCBSceneContainerSessionArray | null = this.getAllContainerSessionList();
    if (persistentId === INVALID_PERSISTENT_ID || targetPersistentId === INVALID_PERSISTENT_ID) {
      return;
    }
    if (!allContainerSessionList) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget failed, allContainerSessionList is null');
      return;
    }
    let sourceContainer = allContainerSessionList.findByPersistentId(persistentId);
    if (!sourceContainer) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget failed, container session not exit in allContainerSessionList');
      return;
    }
    let screenId: number | undefined = sourceContainer.primarySession ? sourceContainer.primarySession.session?.screenId :
                                                                        sourceContainer.secondarySession?.session?.screenId;
    if ((screenId === undefined || screenId === INVALID_SCREEN_ID)) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget failed, screen id not exit');
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `raiseMainWindowAboveTarget, screenId: ${screenId}`);
    this.executeCallback(SCBEventId.RAISE_MAIN_WINDOW_ABOVE_TARGET, screenId, persistentId, undefined, undefined, undefined, {
      targetPersistentId: targetPersistentId
    });
    return;
  }

  /**
   * process Recover
   *
   * @param screenId
   * @param persistentId
   */
  public processRecover(screenId?: number, persistentId?: number): void {
    log.showInfo(`processRecover! persistentId: ${persistentId}`);
    if (persistentId === INVALID_PERSISTENT_ID) {
      return;
    }
    this.executeCallback(SCBEventId.SESSION_RECOVER, screenId, persistentId);
    return;
  }

  /**
   * pairSplitFromDock
   * @locationX: Distance from the x-axis of the screen
   * @locationY: Distance from the y-axis of the screen
   * @param sceneInfo: The info of the scene which to be activated
   */
  public pairSplitFromDock(locationX: number, locationY: number, sceneInfo: SCBSceneInfo): void {
    log.showInfo('[SCBMain]pairSplitFromDock:' + sceneInfo?.toJsonString());
    if (sceneInfo.launchType === BundleManager.LaunchType.SPECIFIED) {
      this.startAbilityBySpecified(sceneInfo);
      return;
    }
    if (sceneInfo.launchType === BundleManager.LaunchType.MULTITON) {
      sceneInfo.persistentId = 0;
      sceneInfo.isNewInstance = true;
    }
    this.executePairSplitFromDockCallback(locationX, locationY, SCBEventId.PAIR_SPLIT_FROM_DOCK, sceneInfo.screenId,
      sceneInfo);
    this.execAdditionalCallersCallback();
  }

  private executePairSplitFromDockCallback(locationX: number, locationY: number, eventId: SCBEventId, screenId: number, sceneInfo: SCBSceneInfo): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func eventId:${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    screenId = (sceneInfo.screenId === -1) ? this.mainScreenId : sceneInfo.screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value(locationX, locationY, sceneInfo);
    });
  }

  private isAppSession(scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    if (!scbSession) {
      log.showError('session is nullptr');
      return false;
    }
    if (scbSession instanceof SCBSystemSceneSession) {
      log.showDebug('session is system');
      return false;
    }
    if (scbSession instanceof SCBSceneSession) {
      log.showDebug('session is app main window');
      return true;
    }
    if (scbSession.session && scbSession.session.parentId !== INVALID_PERSISTENT_ID) {
      let parentSession = this.getSessionById(scbSession.session.parentId);
      if (parentSession && parentSession instanceof SCBSceneSession) {
        log.showDebug('session is sub or dialog');
        return true;
      }
    }
    return false;
  }

  public findMainSessionById(persistentId: number): SCBSceneSession {
    if (persistentId === INVALID_PERSISTENT_ID) {
      return null;
    }
    let scbSession = this.getSessionById(persistentId);
    if (scbSession == null) {
      return null;
    }
    if (scbSession instanceof SCBSceneSession) {
      return scbSession;
    }
    return this.findMainSessionById(scbSession.session.parentId);
  }

  /**
   * session request focus api
   *
   * @param persistentId
   * @param byForeground: false will force to get focus, even if zOrder is lower than focused session
   */
  public requestFocus(persistentId: number, byForeground: boolean = true, reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    WinLog.showInfo(WinLogDomain.WMS_FOCUS, `requestFocus id: ${persistentId}, ${byForeground}, ${reason}`);
    if (persistentId === undefined) {
      WinLog.showWarn(WinLogDomain.WMS_FOCUS, 'id undefined');
      return;
    }
    sceneSessionManager.requestFocusStatus(persistentId, true, byForeground, reason);
    this.saveSplitOrMidFocusSession(persistentId);
  }

  /**
   * session request unfocus api
   *
   * @param persistentId
   */
  public requestUnfocus(persistentId: number, reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    WinLog.showInfo(WinLogDomain.WMS_FOCUS, `requestUnfocus id : ${persistentId}, reason: ${reason}`);
    if (persistentId === undefined) {
      WinLog.showWarn(WinLogDomain.WMS_FOCUS, 'id undefined');
      return;
    }
    sceneSessionManager.requestFocusStatus(persistentId, false, false, reason);
  }

  /**
   * 通知画中画面板旋转
   *
   * @param screenId
   * @param persistentId
   * @param containerId
   */
  public requestPIPScenePanelRotation(screenId: number, persistentId?: number, containerId?: number): void {
    this.executeCallback(SCBEventId.PIP_SCENE_PANEL_ROTATION, screenId, persistentId, containerId);
  }

  /**
   * save focus session when isSplit or isMidScene
   * @param persistentId: new focused session
   */
  private saveSplitOrMidFocusSession(persistentId: number): void {
    let focusSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession = this.getSessionById(persistentId);
    if (!(focusSession instanceof SCBSceneSession)) {
      log.showDebug(`Focused session with id ${persistentId} is not of type SCBSceneSession`);
      return;
    }
    let containerSession = this.getTopActiveContainerSession();
    if (containerSession?.isSplit) {
      this.updateSplitFocusSessionList(focusSession, containerSession);
    } else if (containerSession && containerSession.isMidScene && containerSession.midSceneMap.has(persistentId)) {
      this.updateMidFocusSessionList(focusSession, containerSession);
    }
  }

  // update split focus session
  private updateSplitFocusSessionList(focusSession: SCBSceneSession, containerSession: SCBSceneContainerSession): void {
    let newSession: SCBSceneSession | null = null;
    if (containerSession.primarySession === focusSession || containerSession.secondarySession === focusSession) {
      log.showInfo(`the containerSession is split and focused session is primarySession or secondarySession`);
      newSession = containerSession.primarySession === focusSession ? containerSession.secondarySession :
        containerSession.primarySession;
    }
    if (!CommonUtils.isInvalid(newSession)) {
      log.showInfo(`split session focus change and save new focus sequence`);
      this.splitFocusSessionList = [newSession, focusSession];
    }
  }

  // update midScene focus session
  private updateMidFocusSessionList(focusSession: SCBSceneSession, containerSession: SCBSceneContainerSession): void {
    let midSceneMapList: SCBSceneSessionArray = Array.from(containerSession.midSceneMap.values());
    // If the list doesn't contain session in midSceneMap, the corresponding session is placed at the fist of the list.
    for (let session of midSceneMapList) {
      if (!containerSession.midFocusSessionList.includes(session)) {
        containerSession.midFocusSessionList.unshift(session);
      }
    }
    // remove session not in midSceneMap and focusSession
    let filterList: SCBSceneSessionArray =
      containerSession.midFocusSessionList.filter((sceneSession: SCBSceneSession) =>
      midSceneMapList.indexOf(sceneSession) > -1 &&
        sceneSession.session.persistentId !== focusSession.session.persistentId);
    containerSession.midFocusSessionList.splice(0, containerSession.midFocusSessionList.length);
    containerSession.midFocusSessionList.push(...filterList);
    containerSession.midFocusSessionList.push(focusSession);
    log.showInfo(`update session id: ${focusSession.sceneInfo.persistentId}, ` +
      `len: ${containerSession.midFocusSessionList.length}`);
  }

  /**
   * Get single-Hand compatible mode config.
   *
   * @returns Returns the config value of the single-Hand compatible mode.
   */
  public getSingleHandCompatibleModeConfig(): sceneSessionManager.SingleHandCompatibleModeConfig {
    log.showInfo('[SCBMain]getSingleHandCompatibleModeConfig');
    let config: sceneSessionManager.SingleHandCompatibleModeConfig = {
      enabled: false,
      singleHandScale: 1.0,
      heightChangeRatio: 1.0,
      widthChangeRatio: 1.0
    };
    try {
      config = sceneSessionManager.getSingleHandCompatibleModeConfig();
    } catch (err) {
      log.showError('[SCBMain]getSingleHandCompatibleModeConfig failed, with reason ' + JSON.stringify(err));
    }
    return config;
  }

  /**
   * set Desktop Default System Bar Property
   *
   * @param systemBarProperty
   */
  public setDesktopDefaultSystemBarProperty(systemBarProperty: SCBSystemBarProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `set desktop prop:${systemBarProperty?.toString()}`);
    this.desktopDefaultSystemBarProperty = systemBarProperty?.clone();
  }

  /**
   * get Desktop Default System Bar Property
   *
   * @returns
   */
  public getDesktopDefaultSystemBarProperty(): SCBSystemBarProperty {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `get desktop prop:${this.desktopDefaultSystemBarProperty?.toString()}`);
    return this.desktopDefaultSystemBarProperty;
  }

  /**
   * set Lock Default System Bar Property
   *
   * @param systemBarProperty
   */
  public setLockDefaultSystemBarProperty(systemBarProperty: SCBSystemBarProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `set lock prop:${systemBarProperty?.toString()}`);
    this.lockDefaultSystemBarProperty = systemBarProperty?.clone();
  }

  /**
   * get Lock Default System Bar Property
   *
   * @returns
   */
  public getLockDefaultSystemBarProperty(): SCBSystemBarProperty {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `get lock prop:${this.lockDefaultSystemBarProperty?.toString()}`);
    return this.lockDefaultSystemBarProperty;
  }

  /**
   * set App Default System Bar Property
   *
   * @param systemBarProperty
   */
  public setAppDefaultSystemBarProperty(systemBarProperty: SCBSystemBarProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `set app default prop:${systemBarProperty?.toString()}`);
    this.appDefaultSystemBarProperty = systemBarProperty?.clone();
  }

  /**
   * get App Default System Bar Property
   *
   * @returns
   */
  public getAppDefaultSystemBarProperty(): SCBSystemBarProperty {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `get app default prop:${this.appDefaultSystemBarProperty?.toString()}`);
    return this.appDefaultSystemBarProperty;
  }

  /**
   * set a property that can override the application's status bar settings. When this property is not undefined,
   * it will be given priority and used to apply the style to the status bar.
   *
   * @param prop new status bar properties
   * @param screenId screen id
   * @param callModule the module who call this function
   */
  public setAppOverrideSystemBarProperty(prop: SCBSystemBarProperty, screenId: number, callModule: string): void {
    if (prop?.type !== sceneSessionManager.SessionType.TYPE_STATUS_BAR) {
      WinLog.showError(WinLogDomain.WMS_IMMS, `set app override prop: ` +
        `expected type ${sceneSessionManager.SessionType.TYPE_STATUS_BAR}, but get ${prop?.type}`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `set app override prop:${prop?.toString()}, screen:${screenId},` +
      `call from:${callModule}`);
    this.appOverrideSystemBarProperties.set(screenId, prop?.clone());
    try {
      sceneSessionManager.setStatusBarDefaultVisibilityPerDisplay(screenId, prop.enable);
    } catch (error) {
      WinLog.showError(WinLogDomain.WMS_IMMS, `set status bar enabled failed, screen:${screenId}, error:${error}`);
    }
  }

  /**
   * clear the property set by setAppOverrideSystemBarProperty
   *
   * @param screenId screen id
   * @param callModule the module who call this function
   */
  public clearAppOverrideSystemBarProperty(screenId: number, callModule: string): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `clear app override prop:` +
      `${this.appOverrideSystemBarProperties.get(screenId)?.toString()}, screen:${screenId}, call from:${callModule}`);
    this.appOverrideSystemBarProperties.delete(screenId);
    try {
      sceneSessionManager.setStatusBarDefaultVisibilityPerDisplay(screenId, true);
    } catch (error) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `set status bar enabled failed, screen:${screenId}, error:${error}`);
    }
  }

  /**
   * prepare Terminate
   *
   * @param persistentId
   * @returns
   */
  public prepareTerminate(persistentId: number): boolean {
    return sceneSessionManager.prepareTerminate(persistentId);
  }

  /**
   * async Prepare Terminate
   *
   * @param persistentId
   * @param callback
   */
  public asyncPrepareTerminate(persistentId: number, callback: AsyncCallback<boolean>): void {
    sceneSessionManager.asyncPrepareTerminate(persistentId, callback);
  }

  public isExpectedState(screenId: number, expectedState: ScenePanelState): boolean {
    if (!this.getScenePanelStateCallback.has(screenId)) {
      log.showError('isExpectedState failed to getScenePanelStateCallback with screenId: ' + screenId);
      return false;
    }
    let getStateCallback: Function = null;
    if (this.isScreenLocked()) {
      getStateCallback = this.getScenePanelStateCallback.get(screenId).get(this.panelZIndex.specialScenePanel);
    } else {
      getStateCallback = this.getScenePanelStateCallback.get(screenId).get(this.panelZIndex.scenePanel);
    }
    if (!getStateCallback) {
      log.showError('isExpectedState failed to getScenePanelStateCallback with zIndex failed scenePanelZIndex:' +
        this.panelZIndex.scenePanel + ' specialScenePanelZ: ' + this.panelZIndex.specialScenePanel);
      return false;
    }
    if (getStateCallback() === expectedState) {
      return true;
    }
    return false;
  }

  public triggerScenePanelStateChange(state: ScenePanelState, needBlurAnimation: boolean = true): void {
    this.updateScenePanelState(this.mainScreenId, this.panelZIndex.scenePanel, state, needBlurAnimation);
  }

  private updateScenePanelState(screenId: number, targetPanelZIndex: number, state: ScenePanelState, needBlurAnimation: boolean = true): void {
    if (!this.updateScenePanelStateCallback.has(screenId)) {
      log.showError('updateScenePanelState failed to updateScenePanelStateCallback with screenId: ' + screenId);
      return;
    }
    let updateStateCallback: Function | undefined =
      this.updateScenePanelStateCallback.get(screenId).get(targetPanelZIndex);
    if (!updateStateCallback) {
      log.showError('updateScenePanelState failed to updateScenePanelStateCallback with zIndex failed scenePanelZIndex:' +
        targetPanelZIndex);
      return;
    }
    updateStateCallback(state, needBlurAnimation);
  }

  private updateSystemBarPropertyToCallbacks(systemBarProperty: SCBSystemBarProperty, persistentId: number,
    screenId: number): void {
    // update raw property to callbacks
    this.updateRawSystemBarPropertyToCallbacks(systemBarProperty.clone(), screenId);
    let displayId = screenId === undefined || screenId === this.mainScreenId ?
      DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID : screenId;
    if (!this.lastSystemBarPropertyMap.get(displayId)) {
      this.lastSystemBarPropertyMap.set(displayId, this.defaultSystemBarProperty.clone());
    }
    if (this.lastSystemBarPropertyMap.get(displayId).equals(systemBarProperty)) {
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `update prop to callbacks, same as last. ` +
        `win:${persistentId}, prop:${systemBarProperty?.toString()}`);
      return;
    }
    let systemBarPropertyCallbacks = this.systemBarPropertyCallbackMap.get(displayId);
    if (!systemBarPropertyCallbacks) {
      WinLog.showWarn(WinLogDomain.WMS_IMMS, `update prop to callbacks failed, screenId:${screenId}, ` +
        `mainScreenId:${this.mainScreenId}`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `update prop to callbacks. screenId:${screenId} ` +
      `mainscreenId:${this.mainScreenId} window:${persistentId}, prop:${systemBarProperty?.toString()}, ` +
      `size:${systemBarPropertyCallbacks.length}`);
    systemBarPropertyCallbacks.forEach((systemBarPropertyCallback) => {
      systemBarPropertyCallback?.(systemBarProperty?.clone(), screenId ?? this.mainScreenId);
    });
    this.lastSystemBarPropertyMap.set(displayId, systemBarProperty?.clone());
    sceneSessionManager.notifyStatusBarConstantlyShowStatus(
      (screenId !== undefined && screenId !== INVALID_SCREEN_ID) ? screenId : this.mainScreenId,
      systemBarProperty.enable);
    return;
  }

  private updateRawSystemBarPropertyToCallbacks(systemBarProperty: SCBSystemBarProperty, screenId: number) {
    let displayId = screenId === undefined || screenId === this.mainScreenId ?
      DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID : screenId;
    const callbacks = this.rawSystemBarPropertyCallbackMap.get(displayId);
    if (callbacks) {
      // freeze object for no-modifying current property
      Object.freeze(systemBarProperty);
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `update prop to raw callbacks. screenId:${screenId},` +
        `mainscreenId:${this.mainScreenId},prop:${systemBarProperty?.toString()},size:${callbacks.size}`);
      for (const callback of callbacks) {
        callback?.(systemBarProperty, screenId ?? this.mainScreenId);
      }
    }
  }

  /**
   * force Update System Bar Property
   *
   * @param systemBarProperty
   * @param callModule
   */
  public updateSceneBoardForceProperty(systemBarProperty: SCBSystemBarProperty, callModule: string): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `update force prop:${systemBarProperty?.toString()},callfrom:${callModule}`);
    this.sceneBoardForceProperty = systemBarProperty?.clone();
  }

  /**
   * update System Bar Property
   */
  public updateSystemBarProperty(): void {
    let screenList: SCBScreenSessionArray = SCBScreenSessionManager.getInstance().getScreenSessionList();
    for (let screen of screenList) {
      if (this.sceneBoardForceProperty.type !== sceneSessionManager.SessionType.TYPE_UNDEFINED) {
        this.updateSystemBarPropertyToCallbacks(
          this.sceneBoardForceProperty, INVALID_PERSISTENT_ID, screen.session.screenId);
        continue;
      }
      let topContainerSession: SCBSceneContainerSession = this.getTopContainerSession(screen.session.screenId);
      const inClearSceneStatusCallback = this.clearSceneStatusCallback.get(screen.session.screenId);
      const inClearSceneStatus: boolean = inClearSceneStatusCallback ? inClearSceneStatusCallback() : false;
      const sceneInfo = topContainerSession?.primarySession?.sceneInfo;
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `update prop, topContainerSession: [${sceneInfo?.persistentId}, ` +
        `${sceneInfo?.bundleName}], inClearSceneStatus: ${inClearSceneStatus}, locked:${this.isScreenLocked()}`);
      if (topContainerSession === null || inClearSceneStatus) {
        this.updateSystemBarPropertyInDesktop(screen.session.screenId);
        continue;
      }
      let curScreenTopSessionWindowMode = this.curScreenTopSessionWindowModeMap.get(screen.session.screenId);
      if (curScreenTopSessionWindowMode === CurTopWindowMode.FULL_SCREEN) {
        this.updateSystemBarPropertyInApp(topContainerSession);
      } else if (curScreenTopSessionWindowMode === CurTopWindowMode.MID_SCENE) {
        this.updateSystemBarPropertyInMidScene(topContainerSession);
      } else if (curScreenTopSessionWindowMode === CurTopWindowMode.SPLIT) {
        this.updateSystemBarPropertyInSplit(topContainerSession);
      } else if (curScreenTopSessionWindowMode === CurTopWindowMode.DEFAULT &&
        this.topFullScreenSubSessionMap.get(screen.session.screenId)) {
        this.updateSystemBarPropertyInSubSession(screen.session.screenId, topContainerSession);
      } else {
        this.updateSystemBarPropertyInDesktop(screen.session.screenId);
      }
    }
  }

  /**
   * Get top container session for update system bar.
   *
   * @param screenId
   * @returns Returns top fullscreen container session.
   */
  public getTopContainerSession(screenId: number): SCBSceneContainerSession | null {
    let containerSessionList = this.getContainerSessionList(screenId);
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let sessionLists = [...containerSessionList, ...specialContainerSessionList];
    if (this.isScreenLocked()) {
      sessionLists = [...specialContainerSessionList];
    }
    if (screenId !== this.mainScreenId) {
      sessionLists = [...containerSessionList];
    }
    this.curScreenTopSessionWindowModeMap.set(screenId, CurTopWindowMode.DEFAULT);
    if (sessionLists.length <= 0) {
      return null;
    }
    for (let i = sessionLists.length - 1; i >= 0; i--) {
      let session = sessionLists[i];
      if (session === undefined) {
        continue;
      }
      let topFullScreenSubSession = this.getTopFullScreenSubSession(screenId, session);
      this.topFullScreenSubSessionMap.set(screenId, topFullScreenSubSession);
      if (this.isPcOrPcMode() && topFullScreenSubSession && this.mainSessionOfFullScreenSubSessionMap.has(screenId)) {
        return session;
      }
      if (this.setCurScreenTopSessionWindowModeMap(session, screenId) !== null) {
        return session;
      }
    }
    return null;
  }

  /**
   * set curScreenTopSessionWindowModeMap
   *
   * @param session
   */
  private setCurScreenTopSessionWindowModeMap(session: SCBSceneContainerSession,
    screenId: number): SCBSceneContainerSession | null {
    if (session.haveActiveSession() && session.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN &&
      session.primarySession?.sceneInfo.screenId === screenId && !session.primarySession?.isClosing) {
      this.curScreenTopSessionWindowModeMap.set(screenId, CurTopWindowMode.FULL_SCREEN);
      return session;
    } else if (session.haveActiveSession() && session.isMidScene &&
      session.primarySession?.sceneInfo.screenId === screenId && !DeviceHelper.isCAR()) {
      this.curScreenTopSessionWindowModeMap.set(screenId, CurTopWindowMode.MID_SCENE);
      return session;
    } else if (session.haveActiveSession() && session.isSplit &&
      session.primarySession?.sceneInfo.screenId === screenId) {
      this.curScreenTopSessionWindowModeMap.set(screenId, CurTopWindowMode.SPLIT);
      return session;
    } else {
      return null;
    }
  }

  /**
   * update NavigationBar Bar Property
   *
   * @param navigationBarEnable navigationBarEnable
   */
  public updateNavigationBarProperty(navigationBarEnable = true, session?: SCBSceneSession): void {
    log.showInfo(`updateNavigationBarProperty ${session?.sceneInfo?.screenId}`);
    if (session && session.isInFloat()) {
      log.showInfo('float session');
      return;
    }
    if (session && session.sceneInfo.windowMode != SCBSceneMode.FULLSCREEN && !navigationBarEnable) {
      log.showInfo('not FULLSCREEN');
      return;
    }
    if (this.navigationBarCallbackMap.size === 0) {
      log.showWarn('navigationBarCallbackMap is empty');
    }
    let screenId = INVALID_SCREEN_ID;
    if (session) {
      screenId = session?.sceneInfo?.screenId;
    }
    let floatingTopActiveSession = this.getFloatingSessionList()?.getTopActiveSession();
    if (!this.navigationBarCallbackMap.has(screenId)) {
      log.showWarn('no have match navigationBarCallback');
      for (let navigationBarCallback of this.navigationBarCallbackMap.values()) {
        this.sendBarProperty(navigationBarEnable, screenId, navigationBarCallback, floatingTopActiveSession);
      }
    } else {
      log.showInfo(`updateNavigationBarProperty ${screenId}`);
      let navigationBarCallback = this.navigationBarCallbackMap.get(screenId);
      this.sendBarProperty(navigationBarEnable, screenId, navigationBarCallback, floatingTopActiveSession);
    }
  }

  private sendBarProperty(navigationBarEnable: boolean, screenId: number, navigationBarCallback: Function,
    floatingTopActiveSession: SCBSceneContainerSession | null): void {
    if (this.isExpectedState(this.mainScreenId, ScenePanelState.HOME) &&
      !(floatingTopActiveSession && floatingTopActiveSession.floatingParam.needRecoverStatusBar)) {
      navigationBarCallback(true, screenId);
      log.showInfo('update navi bar, home');
      return;
    }
    if (this.isExpectedState(this.mainScreenId, ScenePanelState.SPLIT)) {
      navigationBarCallback(true, screenId);
      log.showInfo('update navi bar, split');
      return;
    }
    let topActiveSession = this.getContainerSessionList().getTopActiveFullSession();
    if (topActiveSession && topActiveSession.isMidScene) {
      navigationBarCallback(true, screenId);
      log.showInfo('update navi bar, midScene');
      return;
    }
    navigationBarCallback(navigationBarEnable, screenId);
  }

  /**
   * update navigation property
   *
   * @param property systemBarProperty
   * @param screenId screenId
   */
  public notifyNavigationPropertyChanged(property: SCBSystemBarProperty, screenId: number): void {
    if (!property || screenId === undefined) {
      WinLog.showError(WinLogDomain.WMS_IMMS, `update navigation prop failed,screenId:${screenId}`);
      return;
    }
    WinLog.showDebug(WinLogDomain.WMS_IMMS, `update navigation prop:${JSON.stringify(Object.values(property))},` +
      `screenId:${screenId}`);
    let navigationPropertyChangedCallback = this.navigationPropertyChangedCallbackMap.get(screenId);
    if (!navigationPropertyChangedCallback) {
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `update navigation prop Callback is null,screenId:${screenId}`);
      return;
    }
    navigationPropertyChangedCallback(property, screenId);
  }

  // judge layoutfullscreen for main session or sub session of b side top container session
  private isLayoutFullScreen(bSideTopContainerSession: SCBSceneContainerSession, screenId: number): boolean {
    let isLayoutFullScreen: boolean = false;
    let topSubSession = this.getTopFullScreenSubSession(screenId, bSideTopContainerSession);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (!screenSession) {
      log.showError('screenSession is null');
      return;
    }
    if (topSubSession && topSubSession.currRect.top.getPx() <
      screenSession.scbScreenProperty.height / 2) {
      isLayoutFullScreen = topSubSession.layoutFullScreen && topSubSession.windowMode === SCBSceneMode.FULLSCREEN;
    } else {
      let windowMode = bSideTopContainerSession.primarySession?.sceneInfo.windowMode;
      // 当设置中开关打开时，最大化窗口和分屏窗口也进入类似沉浸式的状态
      isLayoutFullScreen = (bSideTopContainerSession.primarySession?.layoutFullScreen &&
        windowMode === SCBSceneMode.FULLSCREEN) ||
        (AppStorage.get<boolean>('isDockAutoHide') && (windowMode === SCBSceneMode.FULLSCREEN ||
          windowMode === SCBSceneMode.PRIMARY || windowMode === SCBSceneMode.SECONDARY));
    }
    return isLayoutFullScreen;
  }

  private handleDockVisibleInFreeMultiWindow(screenId: number): void {
    if (this.existSessionMoving(screenId)) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `exist session moving, need not notify dock.`);
      return;
    }
    if (this.existWindowOverlappedByDock(-1)) {
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `notify dock hide`);
      this.dockVisibleCallback?.get(screenId)?.(false);
    } else {
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `notify dock show`);
      this.dockVisibleCallback?.get(screenId)?.(true);
    }
  }

  private existSessionMoving(screenId: number): boolean {
    let containerList = this.getContainerSessionList(screenId);
    if (containerList && containerList.length > 0) {
      return containerList[containerList.length - 1]?.primarySession?.isSessionMoving as boolean;
    }
    return false;
  }

  private updateSystemBarPropertyInDesktop(screenId: number): void {
    SCBSceneSessionManager.getInstance().fullScreenLayoutChange(false, screenId, 'SCBStatusBar');
    SCBSceneSessionManager.getInstance().fullScreenLayoutChange(false, screenId, 'FixedLayout');
    this.onGestureBarVisibleChange(false, screenId);
    this.executeDockMaskVisibleCallback(screenId, false);
    if (this.dockVisibleCallback) {
      this.dockVisibleCallback.get(screenId)?.(true);
    }
    if (this.statusBarRecoverCallback) {
      this.statusBarRecoverCallback.get(screenId)?.(true);
    }
    if (!this.isScreenLock && this.desktopDefaultSystemBarProperty !== undefined) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use desktop');
      this.updateSystemBarPropertyToCallbacks(this.desktopDefaultSystemBarProperty, INVALID_PERSISTENT_ID, screenId);
    } else if (this.isScreenLock && this.lockDefaultSystemBarProperty !== undefined) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use lock');
      this.updateSystemBarPropertyToCallbacks(this.lockDefaultSystemBarProperty, INVALID_PERSISTENT_ID, screenId);
    } else {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use desktop default');
      const defaultProperty = {showHide: true, backgroundColor: '#00FFFFFF', contentColor: '#FFFFFFFF'};
      const desktopStatusBarConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig.desktopStatusBarConfig;
      const {showHide, contentColor, backgroundColor} = desktopStatusBarConfig ? desktopStatusBarConfig : defaultProperty;
      this.updateSystemBarPropertyToCallbacks(new SCBSystemBarProperty(
        sceneSessionManager.SessionType.TYPE_STATUS_BAR, showHide, backgroundColor, contentColor, true, true),
        INVALID_PERSISTENT_ID, screenId);
    }
  }

  private updateSystemBarPropertyInAppForPc(containerSession: SCBSceneContainerSession, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.dockVisibleCallback) {
      this.dockVisibleCallback.get(screenId)?.(false);
    }

    if (containerSession?.primarySession?.isSystemBarPropertyApplied) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use pc split');
      this.updateSystemBarPropertyToCallbacks(new SCBSystemBarProperty(
        sceneSessionManager.SessionType.TYPE_STATUS_BAR, false, '#00FFFFFF', '#FF000000'), INVALID_PERSISTENT_ID,
        screenId);
    }

    if (this.statusBarRecoverCallback) {
      this.statusBarRecoverCallback.get(screenId)?.(false);
    }
  }

  private onGestureBarVisibleChange(isVisible: boolean, screenId: number,
    session?: SCBSceneContainerSession | SCBSpecificSession): void {
    log.showInfo(`onGestureBarVisibleChange isVisible:${isVisible}, screenId:${screenId}`);
    let callback = this.gestureBarVisibleCallback.get(screenId);
    if (callback) {
      callback(this.judgeGestureBarShow(isVisible, screenId, session));
    }
  }

  private judgeGestureBarShow(isVisible: boolean, screenId: number,
    session?: SCBSceneContainerSession | SCBSpecificSession): boolean {
    if (!session || !AppStorage.get<boolean>('isDockAutoHide')) {
      return isVisible;
    }
    let isCanUpdateGestureBarShow = false;
    if (session instanceof SCBSceneContainerSession && session.primarySession) {
      if (session.primarySession.layoutFullScreen && !session.primarySession.getRealLayoutFullScreen()) {
        isCanUpdateGestureBarShow = true;
      } else if (session.isSplit) {
        isCanUpdateGestureBarShow = true;
      }
    } else if (session instanceof SCBSpecificSession && session.layoutFullScreen &&
      !session.getRealLayoutFullScreen()) {
      isCanUpdateGestureBarShow = true;
    }
    if (isCanUpdateGestureBarShow) {
      const statusBar = this.getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
      if (isVisible && !statusBar) {
        log.showInfo(`judgeGestureBarShow not show gestureBar`);
        return false;
      }
    }
    return isVisible;
  }

  private traverseSubSession(subSessionList: SCBSpecificSceneSessionList, result: SCBSpecificSceneSessionList): void {
    if (!subSessionList) {
      return;
    }
    for (let i = 0; i < subSessionList.length; i++) {
      let item = subSessionList[i];
      if (item && item.windowMode === SCBSceneMode.FULLSCREEN) {
        result.push(item);
      }
      this.traverseSubSession(item.subSessionList, result);
    }
  }

  public getTopFullScreenSubSession(screenId: number, container: SCBSceneContainerSession): SCBSpecificSession {
    if (!container) {
      log.showInfo('container is null');
      return null;
    }
    let primaryResultList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    this.traverseSubSession(container?.primarySession?.subSessionList, primaryResultList);
    let secondaryResultList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    this.traverseSubSession(container?.secondarySession?.subSessionList, secondaryResultList);
    let primarySpecificSession = primaryResultList.pop();
    let secondarySpecificSession = secondaryResultList.pop();
    if (primarySpecificSession && ACTIVE_STATUS_MAP.get(primarySpecificSession.sessionData?.sessionState) &&
      screenId === primarySpecificSession.screenId && primarySpecificSession.windowMode === SCBSceneMode.FULLSCREEN &&
      container.needRenderVisibility.visibility) {
      this.mainSessionOfFullScreenSubSessionMap.set(screenId, container?.primarySession);
      return primarySpecificSession;
    } else if (secondarySpecificSession && ACTIVE_STATUS_MAP.get(secondarySpecificSession.sessionData?.sessionState) &&
      screenId === secondarySpecificSession.screenId && container.needRenderVisibility.visibility &&
      secondarySpecificSession.windowMode === SCBSceneMode.FULLSCREEN) {
      this.mainSessionOfFullScreenSubSessionMap.set(screenId, container?.secondarySession);
      return secondarySpecificSession;
    }
    return null;
  }

  public getTopFullScreenSubSessionForBSide(screenId: number, container: SCBSceneContainerSession): SCBSpecificSession {
    if (!container) {
      log.showInfo('container is null');
      return null;
    }
    let primaryResultList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    this.traverseSubSession(container?.primarySession?.subSessionList, primaryResultList);
    let secondaryResultList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    this.traverseSubSession(container?.secondarySession?.subSessionList, secondaryResultList);
    let subSessionList = [...primaryResultList, ...secondaryResultList];
    for (let item of subSessionList) {
      if (item && ACTIVE_STATUS_MAP.get(item.sessionData?.sessionState) &&
        screenId === item.screenId && item.windowMode === SCBSceneMode.FULLSCREEN &&
        container.isActive && item.currRect.top.getPx() < container.screenProperty.height / 2) {
        this.mainSessionOfFullScreenSubSessionMap.set(screenId, container?.primarySession);
        return item;
      }
    }
    return null;
  }

  private updateSystemBarPropertyInSubSession(screenId: number, topContainerSession: SCBSceneContainerSession): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use subsession.');
    let specificSession = this.topFullScreenSubSessionMap.get(screenId);
    let parentSession = this.mainSessionOfFullScreenSubSessionMap.get(screenId);
    if (!specificSession || !parentSession) {
      return;
    }
    let isLayoutFullScreen: boolean = specificSession?.layoutFullScreen;
    if (!this.isPc()) {
      this.dockVisibleCallback?.get(screenId)?.(false);
    } else {
      this.notifySystemBarVisibleCallback(parentSession, specificSession, screenId, topContainerSession);
    }
    const systemBarProperty = this.getSystemBarPropertyInAPP(parentSession);
    systemBarProperty.enable = !isLayoutFullScreen;
    if (parentSession.session.screenId === screenId) {
      this.getSystemBarPropertyAdjusterCallback?.(parentSession, systemBarProperty);
    }
    this.updateSystemBarPropertyToCallbacks(systemBarProperty, specificSession.session.persistentId, screenId);
    sceneSessionManager.notifyStatusBarShowStatus(specificSession.session.persistentId, systemBarProperty.enable);
    this.statusBarRecoverCallback?.get(screenId)?.(!isLayoutFullScreen);
  }

  private notifySystemBarVisibleCallback(parentSession: SCBSceneSession, specificSession: SCBSpecificSession,
    screenId: number, container: SCBSceneContainerSession): void {
    if (!parentSession || !specificSession || !container) {
      return;
    }
    let isTitleHoverShowEnabled: boolean = specificSession?.titleHoverShowEnabled ?? true;
    let isDockHoverShowEnabled: boolean = specificSession?.dockHoverShowEnabled ?? true;
    let isLayoutFullScreen: boolean = specificSession?.layoutFullScreen;
    if (isLayoutFullScreen) {
      let statusbar =
        this.getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
      statusbar?.setFocusable(false);
      this.dockVisibleCallback.get(screenId)?.(false);
      this.executeDockMaskVisibleCallback(screenId, isDockHoverShowEnabled);
      this.onGestureBarVisibleChange(isTitleHoverShowEnabled, screenId, specificSession);
    } else {
      this.fullScreenLayoutChange(true, screenId);
      this.onGestureBarVisibleChange(false, screenId);
      this.dockVisibleCallback.get(screenId)?.(true);
      this.executeDockMaskVisibleCallback(screenId, false);
    }
  }

  private updateSystemBarPropertyInApp(containerSession: SCBSceneContainerSession): void {
    let isLayoutFullScreen: boolean = containerSession.primarySession?.layoutFullScreen;
    let isTitleHoverShowEnabled: boolean = containerSession.primarySession?.titleHoverShowEnabled ?? true;
    let isDockHoverShowEnabled: boolean = containerSession.primarySession?.dockHoverShowEnabled ?? true;
    let screenId: number = containerSession.screenProperty.screenId;
    if (this.dockVisibleCallback) {
      if (this.isPc() && !isLayoutFullScreen) {
        SCBSceneSessionManager.getInstance().fullScreenLayoutChange(true, containerSession.screenProperty.screenId,
          'SCBStatusBar');
        SCBSceneSessionManager.getInstance().fullScreenLayoutChange(true, containerSession.screenProperty.screenId,
          'FixedLayout');
        this.dockVisibleCallback.get(screenId)?.(true);
        this.onGestureBarVisibleChange(false, screenId);
        this.executeDockMaskVisibleCallback(screenId, false);
      } else if (this.isPc() && isLayoutFullScreen) {
        let statusbar = SCBSceneSessionManager.getInstance()
          .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
        statusbar?.setFocusable(false);
        this.dockVisibleCallback.get(screenId)?.(false);
        this.executeDockMaskVisibleCallback(screenId, isDockHoverShowEnabled);
        this.onGestureBarVisibleChange(isTitleHoverShowEnabled, screenId, containerSession);
      } else {
        this.dockVisibleCallback.get(screenId)?.(false);
      }
    }
    let primarySession: SCBSceneSession = containerSession?.primarySession;
    if (primarySession === undefined || primarySession === null) {
      WinLog.showDebug(WinLogDomain.WMS_IMMS, 'containerSession or primarySession is null');
      return;
    }
    if (primarySession.isSystemBarPropertyApplied) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `prop is applied, isLayoutFullScreen: ${isLayoutFullScreen}`);
      const systemBarProperty = this.getSystemBarPropertyInAPP(primarySession);
      if (this.appOverrideSystemBarProperties.has(screenId)) {
        systemBarProperty.enable = this.appOverrideSystemBarProperties.get(screenId)!.enable;
        WinLog.showInfo(WinLogDomain.WMS_IMMS, `get app prop, use override enable: ${systemBarProperty.enable}`);
      }
      if (this.isPcOrPcMode()) {
        WinLog.showInfo(WinLogDomain.WMS_IMMS, `isPcOrPcMode`);
        systemBarProperty.enable = !(isLayoutFullScreen || primarySession.sessionData.isMaximizeFullScreen);
        this.getSystemBarPropertyAdjusterCallback?.(primarySession, systemBarProperty);
      }
      this.updateSystemBarPropertyToCallbacks(systemBarProperty, primarySession.session.persistentId, screenId);
      sceneSessionManager.notifyStatusBarShowStatus(primarySession.session.persistentId, systemBarProperty.enable);
    }

    if (this.statusBarRecoverCallback) {
      this.statusBarRecoverCallback.get(screenId)?.(!isLayoutFullScreen);
    }
  }

  private getSystemBarPropertyInAPP(primarySession: SCBSceneSession): SCBSystemBarProperty {
    let systemBarProperty = primarySession.systemBarProperty.get(sceneSessionManager.SessionType.TYPE_STATUS_BAR) ??
      this.appDefaultSystemBarProperty;
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `get app prop:${systemBarProperty?.toString()}` +
      ` isSetEnable:${primarySession.isSetStatusBarEnable} uiType:${uiType}` +
      ` isSetColor:${primarySession.isSetStatusBarColor} isLand:${primarySession.isDisplayLand}`);

    // 不能直接修改appDefault或者session里的原property
    let newProperty = new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, systemBarProperty.enable,
      systemBarProperty.backgroundcolor, systemBarProperty.contentcolor, systemBarProperty.enableAnimation);

    // 未设置过enable，则进行横竖屏判断
    if (!primarySession.isSetStatusBarEnable && primarySession.isDisplayLand) {
      let showInLandscapeMode = SCBWindowSceneConfig.getInstance().windowSceneConfig?.systemUIStatusBar?.showInLandscapeMode;
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `showInLandscapeMode:${showInLandscapeMode}`);
      newProperty.enable = showInLandscapeMode ?? false; // 横屏默认隐藏
    }
    // 支持pc模式的设备只有在pad模式才使用pad逻辑
    let isPadStyle = (uiType === SCBConstants.UITYPE_PAD && DeviceHelper.is2In1DevicePadType());
    // 非PC设备，未设置过颜色，则根据显隐设置不同的默认颜色
    let isNotPc: boolean = uiType === SCBConstants.UITYPE_PHONE || isPadStyle;
    if (isNotPc && !primarySession.isSetStatusBarColor) {
      if (newProperty.enable) {
        newProperty.backgroundcolor = this.appDefaultSystemBarProperty.backgroundcolor;
        if (!primarySession.isFollowAppColorMode) {
          newProperty.contentcolor = this.appDefaultSystemBarProperty.contentcolor;
        }
      } else {
        let immersiveStatusBarBgColor = SCBWindowSceneConfig.getInstance().windowSceneConfig?.systemUIStatusBar?.
          immersiveStatusBarBgColor;
        let immersiveStatusBarContentColor = SCBWindowSceneConfig.getInstance().windowSceneConfig?.systemUIStatusBar?.
          immersiveStatusBarContentColor;
          WinLog.showInfo(WinLogDomain.WMS_IMMS, `immersiveColors:${immersiveStatusBarBgColor} ${immersiveStatusBarContentColor}`);
        newProperty.backgroundcolor = immersiveStatusBarBgColor ?? '#4D000000';
        newProperty.contentcolor = immersiveStatusBarContentColor ?? '#FFFFFFFF';
      }
    } else if (this.isPc()) {
      this.getSystemBarPropertyAdjusterCallback?.(primarySession, systemBarProperty);
    }
    return newProperty;
  }

  /**
   * update systemBar property in split
   *
   * @param containerSession
   */
  public updateSystemBarPropertyInSplit(containerSession: SCBSceneContainerSession): void {
    let screenId: number = containerSession.screenProperty.screenId;
    let isDockAutoHide = AppStorage.get<boolean>('isDockAutoHide');
    if (this.dockVisibleCallback) {
      if (this.isPc() && !isDockAutoHide) {
        this.executeDockMaskVisibleCallback(screenId, false);
        this.dockVisibleCallback.get(screenId)?.(true);
      } else {
        this.executeDockMaskVisibleCallback(screenId, true);
        this.dockVisibleCallback.get(screenId)?.(false);
      }
    }

    if (this.statusBarRecoverCallback) {
      this.statusBarRecoverCallback.get(screenId)?.(false);
    }
    if (containerSession?.mainSession?.isSystemBarPropertyApplied) {
      // const {showHide, contentColor, backgroundColor} = SCBWindowSceneConfig.getInstance().windowSceneConfig?.leftRightStatusBarConfig;
      // let systemBarProperty: SCBSystemBarProperty = new SCBSystemBarProperty(
      //   sceneSessionManager.SessionType.TYPE_STATUS_BAR, showHide, backgroundColor, contentColor);
      // if (containerSession.isSplitView() && containerSession.dividerParam.isUpDownSplit()) {
        // const upDownStatusBarConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig?.upDownStatusBarConfig;
        // systemBarProperty.enable = systemBarProperty.showHide;
        // systemBarProperty.backgroundcolor = systemBarProperty.backgroundColor;
      // }
      // todo leftRightStatusBarConfig、upDownStatusBarConfig、desktopStatusBarConfig undefined
      let systemBarProperty = this.sceneBoardForceProperty.clone();
      systemBarProperty.enable = true;
      if (this.isPc()) {
        if (isDockAutoHide) {
          this.onGestureBarVisibleChange(true, screenId, containerSession);
        } else {
          systemBarProperty = this.getSystemBarPropertyInAPP(containerSession?.mainSession);
          systemBarProperty.enable = true;
          this.fullScreenLayoutChange(true, screenId);
          this.onGestureBarVisibleChange(false, screenId);
        }
      }
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use phone&pad split');
      this.updateSystemBarPropertyToCallbacks(systemBarProperty, INVALID_PERSISTENT_ID, screenId);
    }
  }

  /**
   * update systemBar property in midScene
   *
   * @param containerSession
   */
  public updateSystemBarPropertyInMidScene(containerSession: SCBSceneContainerSession): void {
    let screenId: number = containerSession.screenProperty.screenId;
    if (containerSession?.mainSession?.isSystemBarPropertyApplied) {
      const defaultProperty = { showHide: true, backgroundColor: '#00FFFFFF', contentColor: '#FFFFFFFF' };
      const desktopStatusBarConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig?.desktopStatusBarConfig;
      const { showHide, contentColor, backgroundColor } =
        desktopStatusBarConfig ? desktopStatusBarConfig : defaultProperty;
      let systemBarProperty: SCBSystemBarProperty = new SCBSystemBarProperty(
        sceneSessionManager.SessionType.TYPE_STATUS_BAR, showHide, backgroundColor, contentColor);
      if (containerSession.isMidScene) {
        systemBarProperty.enable = true;
      }
      if (this.isExpectedState(this.mainScreenId, ScenePanelState.SPLIT)) {
        systemBarProperty.enable = false;
      }
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'update prop, use phone&pad midScene');
      this.updateSystemBarPropertyToCallbacks(systemBarProperty, INVALID_PERSISTENT_ID, screenId);
    }
  }

  /**
   * set Is Status Bar Shown For Hover
   *
   * @param isStatusBarShownForHover
   */
  public setIsStatusBarShownForHover(isStatusBarShownForHover: boolean): void {
    this.mIsStatusBarShownForHover = isStatusBarShownForHover;
  }

  /**
   * get Is Status Bar Shown For Hover
   *
   * @returns
   */
  public getIsStatusBarShownForHover(): boolean {
    return this.mIsStatusBarShownForHover;
  }

  /**
   * register Status Bar Recover Callback
   *
   * @param callback
   */
  public registerStatusBarRecoverCallback(callback: Function, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.statusBarRecoverCallback.set(screenId, callback);
  }

  /**
   * unregister Status Bar Recover Callback
   *
   * @param screenId
   */
  public unregisterStatusBarRecoverCallback(screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.statusBarRecoverCallback.delete(screenId);
  }

  /**
   * register Status Bar Type Change Callback
   *
   * @param callback
   */
  public registerStatusBarTypeChangeCallback(callback: Function): void {
    log.showInfo('registerStatusBarTypeChangeCallback');
    this.statusBarTypeChangeCallback = callback;
  }

  /**
   * unregister Status Bar Type Change Callback
   *
   */
  public unregisterStatusBarTypeChangeCallback(): void {
    log.showInfo('unregisterStatusBarTypeChangeCallback');
    this.statusBarTypeChangeCallback = null;
  }

  /**
   * execute Status Bar Type Change Callback
   *
   */
  public executeStatusBarTypeChangeCallback(): void {
    log.showInfo('executeStatusBarTypeChangeCallback');
    if (this.statusBarTypeChangeCallback) {
      this.statusBarTypeChangeCallback();
    } else {
      log.showInfo('executeStatusBarTypeChangeCallback is null');
    }
  }

  /**
   * Registers the style callback function of the full-screen and split-screen status bars.
   *
   * @param callback
   */
  public registerStatusBarStyleCallback(callback: Function): void {
    this.statusBarStyleCallback = callback;
  }

  /**
   * register clear scene status callBack
   *
   * @param callback
   * @param screenId
   */
  public registerClearSceneStatusCallback(callback: Function, screenId: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.clearSceneStatusCallback.set(screenId, callback);
  }

  /**
   * unregister clear scene status callBack
   *
   * @param screenId
   */
  public unregisterClearSceneStatusCallback(screenId: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.clearSceneStatusCallback.delete(screenId);
  }

  /**
   * register Dock Visible Callback
   *
   * @param callback
   */
  public registerDockVisibleCallback(callback: Function, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.dockVisibleCallback.set(screenId, callback);
  }

  /**
   * unregister Dock Visible Callback
   *
   * @param callback
   */
  public unregisterDockVisibleCallback(screenId?: number): void {
    this.dockVisibleCallback.delete(screenId ?? this.mainScreenId);
  }

  /**
   * register Gesture Bar Visible Callback
   *
   * @param callback
   */
  public registerGestureBarVisibleCallback(callback: Function, screenId: number): void {
    this.gestureBarVisibleCallback.set(screenId, callback);
  }

  /**
   * unregister Gesture Bar Visible Callback
   *
   */
  public unregisterGestureBarVisibleCallback(screenId: number): void {
    this.gestureBarVisibleCallback.delete(screenId);
  }

  /**
   * Register the dock mask callback
   *
   * @param callback
   * @param screenId
   */
  public registerDockMaskVisibleCallback(callback: Function, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.dockMaskVisibleCallbackMap.set(screenId, callback);
  }

  private executeDockMaskVisibleCallback(screenId: number, vis: boolean): void {
    if (this.dockMaskVisibleCallbackMap) {
      this.dockMaskVisibleCallbackMap.get(screenId)?.(vis);
    }
  }

  /**
   * Do the unregister work
   *
   * @param screenId
   */
  public unregisterDockMaskVisibleCallback(screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.dockMaskVisibleCallbackMap.has(screenId)) {
      this.dockMaskVisibleCallbackMap.delete(screenId);
    }
  }

  /**
   * Register window mode change callback
   *
   * @param callback
   * @param screenId
   */
  public registerWindowModeChangeCallback(callback: Function, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.windowModeChangeCallbackMap.set(screenId, callback);
  }

  /**
   * Do the unregister work
   *
   * @param screenId
   */
  public unregisterWindowModeChangeCallback(screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.windowModeChangeCallbackMap.has(screenId)) {
      this.windowModeChangeCallbackMap.delete(screenId);
    }
  }

  // reset statusBar enable, avoid other method like ViewManagerPolicy update statusBar visible!
  public resetLastStatusBarProperty(screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (!this.lastSystemBarPropertyMap.get(screenId)) {
      this.lastSystemBarPropertyMap.set(screenId, this.defaultSystemBarProperty.clone());
    }
    if (this.lastSystemBarPropertyMap.get(screenId)?.type === sceneSessionManager.SessionType.TYPE_STATUS_BAR) {
      let statusBar = this.getSystemSceneSessionWithSystemBarType(SystemBarType.STATUS_BAR, screenId);
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'reset statusBar.getVisibility()' + statusBar?.getVisibility());
      this.lastSystemBarPropertyMap.get(screenId).enable = statusBar?.getVisibility();
    }
  }

  /**
   * register System Bar Property Callbacks
   *
   * @param callback
   */
  public registerSystemBarPropertyCallbacks(callback: Function, screenId?: number): void {
    let displayId = screenId === undefined || screenId === this.mainScreenId ?
      DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID : screenId;
    if (!this.lastSystemBarPropertyMap.get(displayId)) {
      this.lastSystemBarPropertyMap.set(displayId, this.defaultSystemBarProperty.clone());
    }
    let systemBarPropertyCallbacks = this.systemBarPropertyCallbackMap.get(displayId);
    if (!systemBarPropertyCallbacks) {
      systemBarPropertyCallbacks = new Array();
      this.systemBarPropertyCallbackMap.set(displayId, systemBarPropertyCallbacks);
    }
    let index = systemBarPropertyCallbacks.indexOf(callback);
    if (index === -1) {
      systemBarPropertyCallbacks.push(callback);
      if (callback &&
        (this.lastSystemBarPropertyMap.get(displayId).type !== sceneSessionManager.SessionType.TYPE_UNDEFINED)) {
        callback(this.lastSystemBarPropertyMap.get(displayId)?.clone());
      }
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `registerSystemBarPropertyCallbacks success, screenId:${screenId}`);
    }
  }

  /**
   * unRegister NavigationBar Callback
   * @param screenId 屏幕ID
   */
  public unRegisterNavigationBarCallback(screenId: number): void {
    this.navigationBarCallbackMap.delete(screenId);
  }

  /**
   * register NavigationBar Callback
   * @param screenId 屏幕ID
   * @param callback
   */
  public registerNavigationBarCallback(screenId: number, callback: Function): void {
    this.navigationBarCallbackMap.set(screenId, callback);
  }

  /**
   * register navigation property callback
   *
   * @param callback NavigationBarPropertyCallback
   * @param screenId screenId
   */
  public registerNavigationPropertyChangedCallback(callback: NavigationPropertyChangedCallback,
    screenId: number): void {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `registerNavigationPropertyChangedCallback screenId:${screenId}`);
    this.navigationPropertyChangedCallbackMap.set(screenId, callback);
  }

  /**
   * unregister navigation property callback
   * @param screenId screenId
   */
  public unregisterNavigationPropertyChangedCallback(screenId: number): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `unregisterNavigationPropertyChangedCallback screenId:${screenId}`);
    if (this.navigationPropertyChangedCallbackMap?.has(screenId)) {
      this.navigationPropertyChangedCallbackMap.delete(screenId)
    }
  }

  /**
   * unRegister System Bar Property Callbacks
   *
   * @param callback
   */
  public unRegisterSystemBarPropertyCallbacks(callback: Function, screenId?: number): void {
    let displayId = screenId === undefined || screenId === this.mainScreenId ?
      DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID : screenId;
    let systemBarPropertyCallbacks = this.systemBarPropertyCallbackMap.get(displayId);
    if (systemBarPropertyCallbacks) {
      let index = systemBarPropertyCallbacks.indexOf(callback);
      if (index !== -1) {
        systemBarPropertyCallbacks.splice(index, 1);
        WinLog.showDebug(WinLogDomain.WMS_IMMS, 'unRegister SystemBarPropertyCallbacks success');
      }
    }
  }

  /**
   * register raw system bar property change callback
   * 
   * @param callback
   * @param screenId
   * @param callModule
   */
  public registerRawSystemBarPropertyCallback(callback: Function, screenId?: number, callModule?: string): void {
    let displayId = screenId === undefined || screenId === this.mainScreenId ?
      DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID : screenId;
    const callbacks = this.rawSystemBarPropertyCallbackMap.get(displayId) ?? new Set();
    if (!this.lastSystemBarPropertyMap.get(displayId)) {
      this.lastSystemBarPropertyMap.set(displayId, this.defaultSystemBarProperty.clone());
    }
    if (!callbacks.has(callback) &&
      this.lastSystemBarPropertyMap.get(displayId).type !== sceneSessionManager.SessionType.TYPE_UNDEFINED) {
      callback?.(this.lastSystemBarPropertyMap.get(displayId)?.clone());
    }
    callbacks.add(callback);
    this.rawSystemBarPropertyCallbackMap.set(displayId, callbacks);
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `register RawSystemBarPropertyCallback success` +
      `call by: ${callModule ?? 'unknown'}`);
  }

  /**
   * unregister raw system bar property change callback
   * 
   * @param callback
   * @param screenId
   * @param callModule
   */
  public unRegisterRawSystemBarPropertyCallback(callback: Function, screenId?: number, callModule?: string): void {
    let displayId = screenId === undefined || screenId === this.mainScreenId ?
      DEFAULT_SYSTEM_BAR_CB_DISPLAY_ID : screenId;
    const callbacks = this.rawSystemBarPropertyCallbackMap.get(displayId);
    if (callbacks) {
      callbacks.delete(callback);
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `unregister RawSystemBarPropertyCallback success 
        call by: ${callModule ?? 'unknown'}`);
    }
  }

  /**
   * register System Bar Property Recent Callbacks
   *
   * @param callback
   */
  public registerSystemBarPropertyRecentCallbacks(callback: Function): void {
    let index = this.systemBarPropertyRecentCallbacks.indexOf(callback);
    if (index === -1) {
      this.systemBarPropertyRecentCallbacks.push(callback);
    }
  }

  /**
   * unRegister System Bar Property Recent Callbacks
   *
   * @param callback
   */
  public unRegisterSystemBarPropertyRecentCallbacks(callback: Function): void {
    let index = this.systemBarPropertyRecentCallbacks.indexOf(callback);
    if (index !== -1) {
      this.systemBarPropertyRecentCallbacks.splice(index, 1);
    }
  }

  /**
   * register auto Start PiP Callbacks
   *
   * @param callback
   */
  public registerAutoStartPiPCallback(callback: Function): void {
    log.showInfo('registerAutoStartPiPCallback success');
    this.autoStartPiPCallback = callback;
  }

  /**
   * unregister auto Start PiP Callbacks
   *
   * @param callback
   */
  public unregisterAutoStartPiPCallback(): void {
    log.showInfo('unregisterAutoStartPiPCallback success');
    this.autoStartPiPCallback = null;
  }

  /**
   * register pip occlude change callback
   *
   * @param callback
   */
  public registerPiPOcclusiveChangeCallback(callback: Function): void {
    log.showInfo('registerPiPOcclusiveChangeCallback');
    this.pipOcclusiveChangeCallback = callback;
  }

  /**
   * unregister pip occlude change callback
   */
  public unRegisterPiPOcclusiveChangeCallback(): void {
    log.showInfo('unRegisterPiPOcclusiveChangeCallback');
    this.pipOcclusiveChangeCallback = null;
  }

  /**
   * register session start pip failed callback
   *
   * @param callback
   * @param screenId
   */
  public registerStartPiPFailedCallback(callback: Function, screenId: number = this.mainScreenId): void {
    log.showInfo(`registerStartPiPFailedCallback, screenId: ${screenId}`);
    this.startPiPFailedCallbackMap.set(screenId, callback);
  }

  /**
   * unregister session start pip failed callback
   *
   * @param screenId
   */
  public unregisterStartPiPFailedCallback(screenId: number = this.mainScreenId): void {
    log.showInfo(`unregisterStartPiPFailedCallback, screenId: ${screenId}`);
    if (this.startPiPFailedCallbackMap.has(screenId)) {
      this.startPiPFailedCallbackMap.delete(screenId);
    }
  }

  private notifyStartPiPFailed(screenId: number): void {
    log.showInfo(`notify start PiP failed, screenId: ${screenId}`);
    if (this.startPiPFailedCallbackMap.get(screenId)) {
      this.startPiPFailedCallbackMap.get(screenId)();
    }
  }

  private async executeStartAbilityIfNeed(): Promise<void> {
    if (this.startAbilityQueue.length === 0) {
      return;
    }
    this.startAbilityQueue.forEach((startAbilityData) => {
      this.executeStartSceneCallback(startAbilityData.eventId, startAbilityData.screenId, startAbilityData.toInfo, startAbilityData.fromInfo);
    });
    this.startAbilityQueue = [];
  }

  /**
   * register update max foreground window numbers callback
   *
   * @param callback
   */
  public registerMaxForegroundWindowNumChangeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn('callback is invalid');
      return;
    }
    if (this.maxForegroundWindowNumChangeCallbacks.indexOf(callback) === -1) {
      log.showInfo('registerSetForegroundWindowNumCallback success');
      this.maxForegroundWindowNumChangeCallbacks.push(callback);
      return;
    }
    log.showDebug('callback is already exist');
  }

  /**
   * unregister update max foreground window numbers callback
   *
   * @param callback callback to be unregister
   */
  public unregisterSetMaxForegroundWindowNumCallback(callback: Function): void {
    log.showInfo('unregisterSetMaxForegroundWindowNumCallback');
    if (!callback) {
      log.showWarn('callback is invalid');
      return;
    }
    let index = this.maxForegroundWindowNumChangeCallbacks.indexOf(callback);
    if (index === -1) {
      log.showDebug('callback is not exit');
      return;
    }
    this.maxForegroundWindowNumChangeCallbacks.splice(index, 1);
  }

  /**
   * get max foreground window num for pc mode
   */
  public getMaxForegroundWindowNum(): number {
    return this.maxForegroundWindowNum;
  }

  /**
   * register minimize by window ids callback
   *
   * @param callback
   */
  public registerMinimizeByWindowIdsCallback(callback: Function): void {
    if (!callback) {
      log.showWarn('callback is invalid');
      return;
    }
    if (this.minimizeByWindowIdsCallbacks.indexOf(callback) === -1) {
      log.showInfo('registerMinimizeByWindowIdsCallback success');
      this.minimizeByWindowIdsCallbacks.push(callback);
      return;
    }
    log.showDebug('callback is already exist');
  }

  /**
   * unregister minimize by window ids callback
   *
   * @param callback callback to be unregister
   */
  public unregisterMinimizeByWindowIdsCallback(callback: Function): void {
    log.showInfo('unregisterMinimizeByWindowIdCallback');
    if (!callback) {
      log.showWarn('callback is invalid');
      return;
    }
    let index = this.minimizeByWindowIdsCallbacks.indexOf(callback);
    if (index === -1) {
      log.showDebug('callback is not exist');
      return;
    }
    this.minimizeByWindowIdsCallbacks.splice(index, 1);
  }

  /**
   * register Get Scene Panel State Callback
   *
   * @param screenId
   * @param type
   * @param callback
   */
  public registerGetScenePanelStateCallback(screenId: number, type: number, callback: Function): void {
    if (!this.getScenePanelStateCallback.has(screenId)) {
      this.getScenePanelStateCallback.set(screenId, new Map());
    }
    this.getScenePanelStateCallback.get(screenId).set(type, callback);
    log.showInfo('registerGetScenePanelStateCallback with type: ' + type);
    // Start operation from queue after callback registration.
    this.executeStartAbilityIfNeed();
  }

  public unregisterGetScenePanelStateCallback(screenId: number, type: number): void {
    if (this.getScenePanelStateCallback.has(screenId)) {
      let callbackMap = this.getScenePanelStateCallback.get(screenId);
      if (callbackMap?.has(type)) {
        callbackMap.delete(type);
      }
      if (callbackMap?.size === 0) {
        this.getScenePanelStateCallback.delete(screenId);
      }
    }
  }

  /**
   * register Update Scene Panel State Callback
   *
   * @param screenId
   * @param type
   * @param callback
   */
  public registerUpdateScenePanelStateCallback(screenId: number, type: number, callback: Function): void {
    if (!this.updateScenePanelStateCallback.has(screenId)) {
      this.updateScenePanelStateCallback.set(screenId, new Map());
    }
    this.updateScenePanelStateCallback.get(screenId).set(type, callback);
    log.showInfo('registerUpdateScenePanelStateCallback with type: ' + type);
  }

  public unregisterUpdateScenePanelStateCallback(screenId: number, type: number): void {
    if (this.updateScenePanelStateCallback.has(screenId)) {
      if (this.updateScenePanelStateCallback.get(screenId).has(type)) {
        this.updateScenePanelStateCallback.get(screenId).delete(type);
      }
    }
  }

    /**
   * request KeyboardPanel Session
   *
   * @param systemSessionInfo
   * @param sessionChangeCallback
   * @param screenId
   * @returns
   */
  public requestKeyboardPanelSession(panelSession: sceneSessionManager.SceneSession,
                                     systemSessionInfo: SystemSessionInfo,
                                     sessionChangeCallback?: SystemSessionChangeCallback,
                                     screenId?: number): SCBKeyboardPanelSession {
    screenId = (screenId === undefined) ? this.mainScreenId : screenId;
    let sysSceneSession = new SCBKeyboardPanelSession(panelSession, systemSessionInfo, sessionChangeCallback);
    this.setSystemSessionMap(systemSessionInfo.sceneName, systemSessionInfo.sceneName);
    this.addSystemSceneToList(sysSceneSession, screenId);
    log.showInfo(`[SCBSystem]requestSystemSceneSession: ${systemSessionInfo.sceneName}, screenId: ${screenId},
      persistentId: ${sysSceneSession.session.persistentId}`);
    return sysSceneSession;
  }

  /**
   * request System Scene Session
   *
   * @param systemSessionInfo
   * @param sessionChangeCallback
   * @param screenId
   * @returns
   */
  public requestSystemSceneSession(systemSessionInfo: SystemSessionInfo,
                                   sessionChangeCallback?: SystemSessionChangeCallback, isKeyboardPanel?: boolean,
                                   screenId?: number): SCBSystemSceneSession | SCBKeyboardPanelSession {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let oriSceneName = systemSessionInfo.sceneName;
    let sceneName = oriSceneName + (++SCBSceneSessionManager.gSystemId).toString();
    let windowInputType = 0;
    if (typeof (systemSessionInfo.windowInputType) === 'number') {
      windowInputType = systemSessionInfo.windowInputType;
    }
    let session = sceneSessionManager.requestSceneSession({
      bundleName: sceneName,
      moduleName: sceneName,
      abilityName: sceneName,
      appIndex: 0,
      isSystem: true,
      sessionType: systemSessionInfo.systemType,
      screenId: screenId,
      sceneType: systemSessionInfo.sceneType ?? sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
      isSetPointerAreas: systemSessionInfo.isSetPointerAreas,
      isRotatable:systemSessionInfo.isRotatable,
      windowInputType: windowInputType,
      isAppUseControl: systemSessionInfo.isAppUseControl,
    });
    systemSessionInfo.sceneName = sceneName;
    let sysSceneSession;
    if (isKeyboardPanel) {
      sysSceneSession = new SCBKeyboardPanelSession(session, systemSessionInfo, sessionChangeCallback);
    } else {
      sysSceneSession = new SCBSystemSceneSession(session, systemSessionInfo, sessionChangeCallback);
    }
    this.setSystemSessionMap(sceneName, oriSceneName);
    this.addSystemSceneToList(sysSceneSession, screenId);
    this.setSysSessionNameIdMap(sceneName, sysSceneSession.session.persistentId);
    log.showInfo(`[SCBSystem]requestSystemSceneSession: ${sceneName}, screenId: ${screenId} ` +
    `persistentId: ${sysSceneSession.session.persistentId} sceneType:${systemSessionInfo.sceneType}`);
    return sysSceneSession;
  }

  /**
   * get System Scene Session With Id
   *
   * @param persistentId
   * @param screenId
   * @returns
   */
  public getSystemSceneSessionWithId(persistentId: number, screenId?: number): SCBSystemSceneSession {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    log.showDebug(`getSystemSceneSessionWithId persistentId:${persistentId}` +
      `, mainScreenId:${this.mainScreenId}, screenId:${screenId}`);
    const index = this.systemSceneList.get(screenId)?.findIndex((item) => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1 || index === undefined) {
      log.showWarn('Failed to get system Session with session id: ' + persistentId);
      return null;
    }
    log.showDebug('Find system scene session : ' + persistentId);
    return this.systemSceneList.get(screenId)[index];
  }

  /**
   * get System Scene Session With System Type
   *
   * @param systemType
   * @param screenId
   * @returns
   */
  public getSystemSceneSessionWithSystemType(systemType: sceneSessionManager.SessionType, screenId?: number): SCBSystemSceneSession {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    const index = this.systemSceneList.get(screenId)?.findIndex((item) => {
      return item.systemType === systemType;
    });
    if (index === -1 || index === undefined) {
      log.showWarn('Failed to get system Session with systemType: ' + systemType);
      return null;
    }
    log.showDebug('Find system scene session : ' + systemType);
    return this.systemSceneList.get(screenId)[index];
  }

  /**
   * get System Scene Session With System Bar Type
   *
   * @param systemBarType
   * @param screenId
   * @returns
   */
  public getSystemSceneSessionWithSystemBarType(systemBarType: SystemBarType, screenId?: number): SCBSystemSceneSession {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    const index = this.systemSceneList.get(screenId)?.findIndex((item) => {
      return item?.systemBarType === systemBarType;
    });
    if (index === -1 || index === undefined) {
      log.showWarn(`Failed to get system Session with systemType: ${systemBarType}}`);
      return null;
    }
      return this.systemSceneList.get(screenId)[index];
  }

  /**
   * refresh Available Area
   *
   * @param screenId
   * @param { boolean } isForceUpdate
   */
  public refreshAvailableArea(screenId?: number, isForceUpdate: boolean = false): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let statusBarHeight = 0;
    let statusBar = this.getSystemSceneSessionWithSystemBarType(SystemBarType.STATUS_BAR, screenId);
    if (statusBar !== null && statusBar.visibility && this.isPcOrPcMode()) {
      statusBarHeight = statusBar.currRect.height.getPx();
    }
    let dockHeight = 0;
    let smartDock = this.getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    if (smartDock !== null && smartDock.visibility) {
      if (smartDock.avoidRect !== undefined) {
        dockHeight = smartDock.avoidRect.height.getPx();
      } else {
        dockHeight = smartDock.currRect.height.getPx();
      }
    }
    log.showInfo('refreshAvailableArea: statusBarHeight:' + statusBarHeight + ' dockHeight:' + dockHeight);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (!screenSession) {
      log.showError('refreshAvailableArea screenSession is null');
      return;
    }
    screenSession.refreshAvailableArea(statusBarHeight, dockHeight, isForceUpdate);
  }

  /**
   * update Unavailable Area Of Status Bar And Smart Dock
   *
   * @param screenId
   */
  public updateUnavailableArea(screenId: number): void {
    let statusBarSession = this.getSystemSceneSessionWithSystemBarType(SystemBarType.STATUS_BAR, screenId);
    let statusBarRect = statusBarSession !== null ? statusBarSession.currRect.copy() : new SCBSessionRect(0, 0, 0, 0);
    if (statusBarSession && !statusBarSession.visibility) {
      statusBarRect.height = new ScbNumber(0);
    }
    let smartDock = this.getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    let dockRect = smartDock !== null ? smartDock.currRect.copy() : new SCBSessionRect(0, 0, 0, 0);
    if (smartDock && !smartDock.visibility) {
      dockRect.top = new ScbNumber(dockRect.top.getPx() + dockRect.height.getPx());
      dockRect.height = new ScbNumber(0);
    }
    log.showInfo(`updateUnavailableArea screenId: ${screenId}`);
  }

  private transformRectToDMRect(description: string, rect: SCBSessionRect): screenSessionManager.DMRect {
    const unavailableArea: screenSessionManager.DMRect = {
      posX: Math.round(rect.left.getPx()),
      posY: Math.round(rect.top.getPx()),
      width: Math.round(rect.width.getPx()),
      height: Math.round(rect.height.getPx())
    };
    log.showInfo(`${description}: ${JSON.stringify(unavailableArea)}`);
    return unavailableArea;
  }

  /**
   * request System Scene Session Destruction
   *
   * @param systemSceneSession
   * @param screenId
   */
  public requestSystemSceneSessionDestruction(systemSceneSession: SCBSystemSceneSession, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let index = this.systemSceneList.get(screenId)?.indexOf(systemSceneSession);
    if (index < 0 || !systemSceneSession) {
      log.showError('Failed to find session: ' + typeof (systemSceneSession)) +
        ' name:' + systemSceneSession?.name;
      return;
    }
    log.showWarn(`[SCBMain]requestSystemSceneSessionDestruction, name:${systemSceneSession.name}, screenId:${screenId}`);
    systemSceneSession.isActive = false;
    this.deleteSystemSessionMap(systemSceneSession.name);
    this.removeSystemSceneFromList(systemSceneSession, screenId);
    this.deleteFromSysSessionNameIdMap(systemSceneSession.name);
    sceneSessionManager.requestSceneSessionDestruction(systemSceneSession.session, true);
    log.showInfo('[SCBSystem]Destroy system scene session : ' + systemSceneSession.name);
    this.systemSceneList.get(screenId)?.slice(index, 1);
  }

  /**
   * is Screen Locked
   *
   * @returns
   */
  public isScreenLocked(): boolean {
    return this.isScreenLock;
  }

  /**
   * reOrder Show When Locked
   *
   * @param isFromUnlock
   * @param needActivation
   * @param reason, identity why re-order
   */
  public reOrderShowWhenLocked(isFromUnlock: boolean = false, needActivation?: boolean, reason?: string): void {
    log.showInfo(`reOrder showWhenLocked sessions, status: ${this.isScreenLock}, needActivation: ${needActivation}` +
      `, reason: ${reason}.`);
    if (this.isScreenLock) {
      this.moveSpecialContainerSessionUp(isFromUnlock, needActivation);
    } else {
      this.moveSpecialContainerSessionDown(isFromUnlock);
    }
  }

  public reOrderShowRemoveWhenLocked(): void {
    log.showInfo(`reOrder reOrderShowRemoveWhenLocked sessions, status: ${this.isScreenLock}`);
    if (this.isScreenLock) {
      this.moveSpecialContainerSessionDown(false);
    }
  }

  private moveSpecialContainerSessionUp(isFromUnlock: boolean = false, needActivation?: boolean): void {
    let containerList = this.onRemoveContainerSession();
    this.onAddSpecialContainerSession(containerList);
    let requestFullScene: boolean = false;
    const aboveLockScreenWindowList: number[] = [];
    for (let item of containerList) {
      let activeSession = item?.primarySession?.session;
      if (activeSession) {
        aboveLockScreenWindowList.push(activeSession.persistentId);
      }
      if (needActivation && this.requestActivationInReorderShowWhenLocked(item)) {
        requestFullScene = true;
      }
    }
    if (!!aboveLockScreenWindowList.length) {
      log.showDebug(`above keyguard window list ${JSON.stringify(aboveLockScreenWindowList)}`);
      sceneSessionManager.notifyAboveLockScreen(aboveLockScreenWindowList);
    }
    if (requestFullScene) {
      this.updateScenePanelState(this.mainScreenId, this.panelZIndex.specialScenePanel, ScenePanelState.FULLSCENE);
    }
  }

  private requestActivationInReorderShowWhenLocked(item: SCBSceneContainerSession): boolean {
    let activeSession = item?.primarySession?.session;
    if (!(activeSession && this.activeSessionList.includes(activeSession.persistentId))) {
      log.showDebug('no session to request activation');
      return false;
    }
    try {
      let containerSession = this.getSceneContainerSessionFromSpecialScenePanel(activeSession.persistentId);
      this.removeActiveSessionList(activeSession.persistentId);
      if (containerSession) {
        containerSession.requestActivation(false);
      } else {
        log.showWarn('[SCBMain]container of session id:' + activeSession.persistentId + ' is not shown');
        return false;
      }
    } catch (err) {
      log.showError(`requestSceneSessionActivation ${activeSession.persistentId} failed: ${err.message}`);
      return false;
    }
    return true;
  }

  private moveSpecialContainerSessionDown(isFromUnlock: boolean = false): void {
    let containerList = this.onRemoveSpecialContainerSession();
    this.onAddContainerSession(containerList, isFromUnlock);
  }

  /**
   * register pip restore callback
   *
   * @param callback
   * @param screenId
   */
  public registerPipRestoreCallback(callback: Function, screenId?: number): void {
    log.showDebug('registerPipRestoreCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.pipRestoreCallbackMap.set(screenId, callback);
  }

  /**
   * unregister pip restore callback
   *
   * @param screenId
   */
  public unregisterPipRestoreCallback(screenId?: number): void {
    log.showDebug('unregisterPipRestoreCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.pipRestoreCallbackMap.delete(screenId);
  }

  /**
   * startScene when pip restore
   *
   * @param persistentId The persistentId of mainWindow which pip attached
   * @param isFromBg is parent session background
   * @param screenId screen id
   */
  public startSceneByPipRestore(persistentId: number, isFromBg: boolean, screenId: number): void {
    log.showInfo(`startSceneByPipRestore persistentId: ${persistentId}, isFromBg: ${isFromBg}, screenId: ${screenId}`);
    if (this.pipRestoreCallbackMap.get(screenId)) {
      this.isStartingSceneFromPiP = true;
      this.isRestoreFromBgPiP = isFromBg;
      this.pipRestoreCallbackMap.get(screenId)(persistentId);
    }
  }

  /**
   * register Add Container Session Callback
   *
   * @param callback
   * @param screenId
   */
  public registerAddContainerSessionCallback(callback: Function, screenId?: number): void {
    log.showDebug('registerAddContainerSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.addContainerSessionCallback.set(screenId, callback);
  }

  /**
   *  register Add Extend Container Session Callback
   *
   * @param callback
   * @param screenId
   */
  public registerAddExtendContainerSessionCallback(callback: Function, screenId?: number): void {
    log.showDebug('registerAddExtendContainerSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.addExtendContainerSessionCallback.set(screenId, callback);
  }

  /**
   * unregister Add Container Session Callback
   *
   * @param screenId
   */
  public unregisterAddContainerSessionCallback(screenId?: number): void {
    log.showDebug('unregisterAddContainerSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.addContainerSessionCallback.delete(screenId);
  }

  /**
   * unregister Add Extend Container Session Callback
   *
   * @param screenId
   */
  public unregisterAddExtendContainerSessionCallback(screenId?: number): void {
    log.showDebug('unregisterAddExtendContainerSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.addExtendContainerSessionCallback.delete(screenId);
  }

  /**
   * register update pip window from extend screen callback
   *
   * @param callback
   * @param screenId
   */
  public registerUpdatePipExtendSessionCallback(callback: Function, screenId?: number): void {
    log.showDebug('registerUpdatePipExtendSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.updatePipExtendSessionCallback.set(screenId, callback);
  }

  /**
   * unregister update pip window from extend screen callback
   *
   * @param screenId
   */
  public unregisterUpdatePipExtendSessionCallback(screenId?: number): void {
    log.showDebug('unregisterUpdatePipExtendSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.updatePipExtendSessionCallback.delete(screenId);
  }

  /**
   * notify update pip window when extend screen disconnect
   *
   * @param extendScreenId
   * @param screenId
   */
  public updatePipWhenExtendScreenDisconnect(extendScreenId: number, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    log.showInfo(`updatePipWhenExtendScreenDisconnect, extendScreenId: ${extendScreenId}`);
    if (this.updatePipExtendSessionCallback.get(screenId)) {
      this.updatePipExtendSessionCallback.get(screenId)(extendScreenId);
    }
  }

  /**
   * register Remove Container Session Callback
   *
   * @param callback
   * @param screenId
   */
  public registerRemoveContainerSessionCallback(callback: Function, screenId?: number): void {
    log.showDebug('registerRemoveContainerSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.removeContainerSessionCallback.set(screenId, callback);
  }

  public unregisterRemoveContainerSessionCallback(screenId?: number): void {
    log.showDebug('unregisterRemoveContainerSessionCallback');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.removeContainerSessionCallback.delete(screenId);
  }

  /**
   * register callback to notify global search exit
   *
   * @param callback
   */
  public registerGlobalSearchExitCallback(callback: Function): void {
    log.showInfo('registerGlobalSearchExitCallback');
    this.globalSearchExitCallback = callback;
  }

  /**
   * unregister global search exit callback
   *
   */
  public unregisterGlobalSearchExitCallback(): void {
    log.showInfo('unregisterGlobalSearchExitCallback');
    this.globalSearchExitCallback = null;
  }

  /**
   * notify global search exit
   *
   * @param withAnimation, whether use animation when exit
   */
  public notifyGlobalSearchExit(withAnimation: boolean = true): void {
    if (this.globalSearchExitCallback) {
      this.globalSearchExitCallback(withAnimation);
    }
  }

  /**
   * register Add Special Container Session Callback
   *
   * @param callback
   */
  public registerAddSpecialContainerSessionCallback(callback: Function): void {
    log.showDebug('registerAddSpecialContainerSessionCallback');
    this.addSpecialContainerSessionCallback = callback;
  }

  /**
   * unregister Add Special Container Session Callback
   */
  public unregisterAddSpecialContainerSessionCallback(): void {
    this.addSpecialContainerSessionCallback = null;
  }

  /**
   * register Remove Special Container Session Callback
   *
   * @param callback
   */
  public registerRemoveSpecialContainerSessionCallback(callback: Function): void {
    log.showDebug('registerRemoveSpecialContainerSessionCallback');
    this.removeSpecialContainerSessionCallback = callback;
  }

  /**
   * unregister Remove Special Container Session Callback
   */
  public unregisterRemoveSpecialContainerSessionCallback(): void {
    this.removeSpecialContainerSessionCallback = null;
  }

  /**
   * register app exit listener
   *
   */
  public registerAppExitListener(): void {
    log.showInfo('registerAppExitListener');
    localEventManager.registerEventListener(this.appExitListener, [EventConstants.EVENT_IN_APP_EXIT]);
  }

  /**
   * unRegister app exit listener
   *
   * @param callback
   */
  public unRegisterAppExitListener(): void {
    log.showInfo('unRegisterAppExitListener');
    localEventManager.unregisterEventListener(this.appExitListener);
  }

  /**
   * on Add Container Session
   *
   * @param list_
   * @param isFromUnlock
   * @param screenId
   */
  public onAddContainerSession(list_: SCBSceneContainerSessionArray, isFromUnlock: boolean, screenId?: number): void {
    log.showInfo('add scene panel container session');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.addContainerSessionCallback.get(screenId)) {
      this.addContainerSessionCallback.get(screenId)(list_, isFromUnlock);
    }
  }

  /**
   * 添加扩展屏的containerSessionList到对应的屏幕
   *
   * @param list_
   * @param screenId
   * @param extendScreenId
   */
  public onAddExtendContainerSession(list_: SCBSceneContainerSessionArray,
    extendScreenId: number, screenId?: number): void {
    log.showInfo('add extend container session');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.addExtendContainerSessionCallback.get(screenId)) {
      this.addExtendContainerSessionCallback.get(screenId)(list_, extendScreenId);
    }
  }

  /**
   * on Remove Container Session
   *
   * @param screenId
   * @returns
   */
  public onRemoveContainerSession(screenId?: number): SCBSceneContainerSessionArray {
    log.showInfo('remove scene panel container session');
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    if (this.removeContainerSessionCallback.get(screenId)) {
      return this.removeContainerSessionCallback.get(screenId)();
    }
    return new SCBSceneContainerSessionArray();
  }

  /**
   * on Add Special Container Session
   *
   * @param list_
   */
  public onAddSpecialContainerSession(list_: SCBSceneContainerSessionArray): void {
    log.showInfo('add special scene panel container session');
    if (this.addSpecialContainerSessionCallback) {
      this.addSpecialContainerSessionCallback(list_);
      this.updateSystemBarProperty();
    }
  }

  /**
   * on Remove Special Container Session
   *
   * @returns
   */
  public onRemoveSpecialContainerSession(): SCBSceneContainerSessionArray {
    log.showInfo('remove special scene panel container session');
    if (this.removeSpecialContainerSessionCallback) {
      return this.removeSpecialContainerSessionCallback();
    }
    return new SCBSceneContainerSessionArray();
  }

  private transferSession(eventId: SCBEventId, screenId: number, session: SCBSceneSession | SCBSceneContainerSession): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${eventId} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    functions.forEach((value: Function) => {
      value(session, eventId);
    });
  }

  /**
   * perf Request Ex
   *
   * @param cmdId
   * @param onOffTag
   * @param msg
   */
  public perfRequestEx(cmdId: number, onOffTag: boolean, msg?: string): void {
    if (!msg) {
      msg = '';
    }
    sceneSessionManager.perfRequestEx(cmdId, onOffTag, msg);
  }

  /**
   * clone window
   * @param from the src window
   * @param to the dest window
   */
  public cloneWindow(from: number, to: number): void {
    log.showInfo(`cloneWindow from:${from} to:${to}`);
    sceneSessionManager.cloneWindow(from, to);
  }

  private notifySpecialPanelChangeReqOrientation(
    screenId: number, requestedOrientation: number, persistentId: number): void {
    if (!this.specialCallbackMap.has(SCBEventId.ORIENTATION_CHANGE)) {
      log.showError(`No scene func: ${SCBEventId.ORIENTATION_CHANGE} has registered!`);
      return;
    }
    let sceneFuncMap = this.specialCallbackMap.get(SCBEventId.ORIENTATION_CHANGE);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${SCBEventId.ORIENTATION_CHANGE} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    if (functions.length === 0) {
      log.showError(`${SCBEventId.ORIENTATION_CHANGE} functions is 0!`);
      return;
    }
    functions.forEach((value: Function) => {
      value(persistentId, requestedOrientation);
    });
  }

  /**
   * notify Container Session Change Req Orientation
   *
   * @param screenId
   * @param requestedOrientation
   * @param persistentId
   */
  public notifyContainerSessionChangeReqOrientation(
    screenId: number, requestedOrientation: number, persistentId: number, needAnimation: boolean = true): void {
    log.showInfo(`RequestedOrientationChange persistentId:${persistentId} reqOrientation:${requestedOrientation}`);
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let index = specialContainerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    if (this.isScreenLocked() && index !== -1) {
      this.notifySpecialPanelChangeReqOrientation(screenId, requestedOrientation, persistentId);
      return;
    }
    if (!this.callbackMap.has(SCBEventId.ORIENTATION_CHANGE)) {
      log.showError(`No scene func: ${SCBEventId.ORIENTATION_CHANGE} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(SCBEventId.ORIENTATION_CHANGE);
    screenId = (screenId === INVALID_SCREEN_ID) ? this.mainScreenId : screenId;
    if (!sceneFuncMap.has(screenId)) {
      log.showError(`No scene func: ${SCBEventId.ORIENTATION_CHANGE} has registered mainScreenId: ${this.mainScreenId} and screenId: ${screenId}!`);
      return;
    }
    let functions = sceneFuncMap.get(screenId);
    if (functions.length === 0) {
      log.showError(`${SCBEventId.ORIENTATION_CHANGE} functions is 0!`);
      return;
    }
    functions.forEach((value: Function) => {
      value(persistentId, requestedOrientation, needAnimation);
    });
  }

  /**
   * notify System Scene To Set Rotation
   *
   * @param screenProperty
   */
  public notifySystemSceneToSetRotation(screenProperty: SCBScreenProperty): void {
    this.systemSceneList.get(screenProperty.screenId).forEach((systemSceneSession: SCBSystemSceneSession) => {
      const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
      if (systemSceneSession?.isRotatable || uiType !== SCBConstants.UITYPE_PHONE) {
        systemSceneSession.setRotation(screenProperty);
      }
    });
  }

  /**
   * notify setRotation By SystemWantAnimation
   *
   * @param screenProperty
   * @param systemWantAnimation
   */
  public notifySetSystemSceneRotaion(screenProperty: SCBScreenProperty, systemWantAnimation: boolean): void {
    this.systemSceneList.get(screenProperty.screenId).forEach((systemSceneSession: SCBSystemSceneSession) => {
      const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
      let needSetRotation = systemSceneSession?.isRotatable || uiType !== SCBConstants.UITYPE_PHONE;
      // systemSceene update rotation need animation
      let caseSystemWantAnimationSetRotate = systemWantAnimation && systemSceneSession?.
        isAlwaysNeedAnimateWhenRotation && needSetRotation;
      // systemSceene update rotation not need animation
      let caseSystemNotWantAnimationSetRotate = !systemWantAnimation && !systemSceneSession?.
        isAlwaysNeedAnimateWhenRotation && needSetRotation;

      if (caseSystemWantAnimationSetRotate) {
        systemSceneSession.setRotation(screenProperty);
      } else if (caseSystemNotWantAnimationSetRotate) {
        systemSceneSession.setRotation(screenProperty);
      }
    });
  }

  /**
   * notify System Scene To Update Size Change Reason
   *
   * @param screenProperty
   * @param reason
   */
  public notifySystemSceneToUpdateSizeChangeReason(screenProperty: SCBScreenProperty, reason: sceneSessionManager.SessionSizeChangeReason): void {
    this.systemSceneList.get(screenProperty.screenId).forEach((systemSceneSession: SCBSystemSceneSession) => {
      systemSceneSession.session.updateSizeChangeReason(reason);
    });
  }

  /**
   * update Rotate Animation Config
   *
   * @param duration
   */
  public updateRotateAnimationConfig(duration: number): void {
    sceneSessionManager.updateRotateAnimationConfig({
      duration: duration,
    });
  }

  /**
   * notify System Scene To Active Mode Change
   *
   * @param oldScreenProperty
   * @param newScreenProperty
   */
  public notifySystemSceneToActiveModeChange(oldScreenProperty: SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    this.systemSceneList.get(newScreenProperty.screenId).forEach((systemSceneSession: SCBSystemSceneSession) => {
      if (systemSceneSession.isEnableActiveModeChange) {
        systemSceneSession.changeActiveMode(oldScreenProperty, newScreenProperty);
      }
    });
  }

  /**
   * register full screen title bar appear callback
   *
   * @param callback
   */
  public registerFullScreenTitleBarAppearCallback(callback: Function): void {
    this.fullScreenTitleBarAppearCallbacks.add(callback)
  }

  /**
   * notify full screen title bar appear
   */
  public notifyFullScreenTitleBarAppear(): void {
    this.fullScreenTitleBarAppearCallbacks.forEach((callback) => {
      callback();
    });
  }

  /**
   * register hot region state change callback
   *
   * @param callback
   */
  public registerHotRegionStateChangeCallback(callback: Function): void {
    this.hotRegionStateChangeCallbacks.add(callback);
  }

  /**
   * notify hot region state change
   */
  public notifyHotRegionStateChange(): void {
    this.hotRegionStateChangeCallbacks.forEach((callback) => {
      callback();
    });
  }

  /**
   * register immersive scene fullscreen title bar state change callback
   *
   * @param persistentId
   * @param callback
   */
  public registerImmersiveSceneTitleBarStateChangeCallback(persistentId: number, callback: Function): void {
    this.topSceneCallbacks.set(persistentId, callback);
  }

  /**
   * notify immersive scene fullscreen title bar state change
   *
   * @param persistentId
   */
  public notifyImmersiveSceneTitleBarStateChange(persistentId: number): void {
    if (persistentId && this.topSceneCallbacks.has(persistentId)) {
      let callback = this.topSceneCallbacks.get(persistentId);
      if (callback) {
        callback(persistentId);
      }
    }
  }

  /**
   * unregister immersive scene fullscreen title bar state change callback
   *
   * @param persistentId
   */
  public unregisterImmersiveSceneTitleBarStateChangeCallback(persistentId: number): void {
    if (this.topSceneCallbacks.has(persistentId)) {
      this.topSceneCallbacks.delete(persistentId);
    }
  }

  /**
   * notify menu visible callback
   *
   * @param persistentId
   * @param isVisible
   */
  public notifyMenuVisibleCallback(persistentId: number, isVisible: boolean): void {
    if (persistentId && this.menuVisibleCallbacks.has(persistentId)) {
      let callback = this.menuVisibleCallbacks.get(persistentId);
      if (callback) {
        callback(isVisible);
      }
    }
  }

  /**
   * register menu visible callback
   *
   * @param persistentId
   * @param callback
   */
  public registerMenuVisibleCallback(persistentId: number, callback: Function): void {
    this.menuVisibleCallbacks.set(persistentId, callback);
  }

  /**
   * unregister menu visible callback
   *
   * @param persistentId
   */
  public unregisterMenuVisibleCallback(persistentId: number): void {
    this.menuVisibleCallbacks.delete(persistentId);
  }

  /**
   * register full screen menu visible callback, for foldable phone
   *
   * @param callback
   */
  public registerFullScreenMenuVisibleCallback(callback: Function): void {
    this.fullScreenMenuVisibleCallback = callback;
  }

  /**
   * unregister full screen menu visible callback, for foldable phone
   *
   * @param callback
   */
  public unregisterFullScreenMenuVisibleCallback(callback: Function): void {
    this.fullScreenMenuVisibleCallback = null;
  }

  /**
   * notify full screen menu visible callback, for foldable phone
   *
   * @param isMenuVisible, true: show menu, false: show bar
   */
  public notifyFullScreenMenuVisible(isMenuVisible: boolean): void {
    if (this.fullScreenMenuVisibleCallback) {
      this.fullScreenMenuVisibleCallback(isMenuVisible);
    }
  }

  /**
   * notify System Scene To Update Fold Mode
   *
   * @param screenProperty
   * @param reason
   */
  public notifySystemSceneToUpdateFoldMode(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    this.systemSceneList.get(screenProperty.screenId)?.forEach((systemSceneSession: SCBSystemSceneSession) => {
      systemSceneSession.changeFoldScreen(screenProperty, reason);
    });
  }

  /**
   * prepare System Scene Rotation Before Animation
   *
   * @param rotation
   * @param screenId
   */
  public prepareSystemSceneRotationBeforeAnimation(rotation: number, screenId?: number): void {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.systemSceneList.get(screenId)?.forEach((systemSceneSession: SCBSystemSceneSession) => {
      if (systemSceneSession?.isRotatable) {
        systemSceneSession.prepareSystemSceneRotationBeforeAnimation(rotation);
      }
    });
  }

  public isDesktopNeedProcessFloatWindow(displayId: number = DEFAULT_DISPLAY_GROUP_ID): Boolean {
    const focusedSessionId = this.getFocusedSessionId(displayId);
    if (this.getSessionById(focusedSessionId)?.session.type ===
        sceneSessionManager.SessionType.TYPE_SYSTEM_FLOAT &&
      this.isExpectedState(this.mainScreenId, ScenePanelState.HOME)) {
      return true;
    }
    return false;
  }

  /**
   * set behind window filter enabled
   *
   * @param enable
   * @returns
   */
  public setBehindWindowFilterEnabled(enable: boolean): void {
    try {
      log.showInfo(`setBehindWindowFilterEnabled: ${enable}`);
      sceneSessionManager.setBehindWindowFilterEnabled(enable);
    } catch (err) {
      log.showError(`setBehindWindowFilterEnabled failed , err: ${err.code}, errMessage: ${err.message}`);
    }
  }

  /**
   * process System Back Event
   *
   * @returns
   */
  public processSystemBackEvent(displayId: number = DEFAULT_DISPLAY_GROUP_ID): Boolean {
    const focusedSessionId = this.getFocusedSessionId(displayId);
    if (this.isDesktopNeedProcessFloatWindow(displayId)) {
      log.showInfo('FLOAT_WINDOW processSystemBackEvent');
      localEventManager.sendLocalEvent(EventConstants.EVENT_FLOAT_ON_FOCUS); // Notify the desktop when the FloatWindow is in focus
      return true;
    }
    let sysSceneSession = this.getSystemSceneSessionWithId(focusedSessionId);
    if (sysSceneSession) {
      if ((this.isExpectedState(this.mainScreenId, ScenePanelState.RECENT) ||
        (this.isExpectedState(this.mainScreenId, ScenePanelState.SPLIT) &&
          sysSceneSession.systemType !== sceneSessionManager.SessionType.TYPE_GLOBAL_SEARCH)) &&
        (sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_DESKTOP ||
          sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_GLOBAL_SEARCH ||
          sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_NEGATIVE_SCREEN
        )) {
        return false;
      }
      sysSceneSession.systemSceneProcessBackEvent();
      return true;
    }
    return false;
  }

  /**
   * process System Home Event
   *
   * @returns
   */
  public processSystemHomeEvent(displayId: number = DEFAULT_DISPLAY_GROUP_ID): Boolean {
    scbGestureManager.gestureEventCallback(SCBEventId.HOME_GESTURE_EVENT);
    const focusedSessionId = this.getFocusedSessionId(displayId);
    if (this.isDesktopNeedProcessFloatWindow(displayId)) {
      log.showInfo('FLOAT_WINDOW processSystemHomeEvent');
      localEventManager.sendLocalEvent(EventConstants.EVENT_FLOAT_ON_FOCUS); // Notify the desktop when the FloatWindow is in focus
      return true;
    }
    let sysSceneSession = this.getSystemSceneSessionWithId(focusedSessionId);
    if (sysSceneSession) {
      if (this.isExpectedState(this.mainScreenId, ScenePanelState.RECENT) &&
        (sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_DESKTOP ||
          sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_GLOBAL_SEARCH ||
          sysSceneSession.systemType === sceneSessionManager.SessionType.TYPE_NEGATIVE_SCREEN
        )) {
        return false;
      }
      sysSceneSession.systemSceneProcessHomeEvent();
    }
    return false;
  }

  /**
   * process System Recent Event
   */
  public processSystemRecentEvent(displayId: number = DEFAULT_DISPLAY_GROUP_ID): void {
    // 进入多任务模式
    this.callRecentFuncs(true);
    const focusedSessionId = this.getFocusedSessionId(displayId);
    let sysSceneSession = this.getSystemSceneSessionWithId(focusedSessionId);
    if (sysSceneSession) {
      sysSceneSession.systemSceneProcessRecentEvent();
    }
  }

  /**
   * is Split Top Active Session
   *
   * @returns
   */
  public isSplitTopActiveSession(): boolean {
    let containerSessionList = this.getContainerSessionList();
    if (containerSessionList.length < 1) {
      return false;
    }
    let containerSession = containerSessionList[containerSessionList.length - 1];
    return !!containerSession && containerSession.isActive &&
      !!containerSession.primarySession && !!containerSession.secondarySession;
  }

  // get top active scene container for rotate check
  private getTopActiveSessionForRotateCheck(): SCBSceneContainerSession | null {
    // Find top active session. When screen is locked, only need to care about special scene panel.
    let containerSessionList = new SCBSceneContainerSessionArray();
    if (!this.isScreenLocked()) {
      this.getContainerSessionList().forEach((containerSession: SCBSceneContainerSession) => {
        containerSessionList.add(containerSession);
      });
    }
    this.getSpecialContainerSessionList().forEach((containerSession: SCBSceneContainerSession) => {
      containerSessionList.add(containerSession);
    });
    let activeSession = containerSessionList.getTopActiveSession();
    return activeSession;
  }

  // 是否正在拖拽悬浮窗
  private isDraggingFloatScene(): boolean {
    let activeFloatSession = this.getFloatingSessionList().getTopActiveSession();
    if (!activeFloatSession) {
      return false;
    }
    return scbEventExclusiveManager.getEventExclusiveByCaller(EventType.FLOATING_DRAG);
  }

  // 是否正在拖拽分屏条
  private isDraggingDivider(): boolean {
    let topActiveSession = this.getTopActiveSessionForRotateCheck();
    if (!topActiveSession) {
      return false;
    }
    return topActiveSession.dividerParam.isDividerDragging;
  }

  // is dragging on dock
  private isDraggingDock(): boolean {
    return !!AppStorage.get<boolean>('isDraggingDock');
  }

  private isDraggingPip(): boolean {
    return !!AppStorage.get<boolean>('isDraggingPip');
  }

  // 是否应该延迟旋转
  private shouldDelayRotation(): boolean {
    if (this.isInAppExit) {
      log.showInfo('in App Exit');
      return true;
    }
    if (this.isDraggingDivider()) {
      log.showInfo('Dragging split divider, not handleSensorRotation');
      return true;
    }
    return false;
  }

  /**
   * is ScenePanel In State
   *
   * @param screenId
   * @param stateArray
   * @returns
   */
  public isScenePanelInState(screenId: number, ...stateArray: ScenePanelState[]): boolean {
    if (!this.getScenePanelStateCallback.has(screenId)) {
      log.showError('isExpectedState failed to getScenePanelStateCallback with screenId: ' + screenId);
      return false;
    }
    let getStateCallback: Function = null;
    if (this.isScreenLocked()) {
      getStateCallback = this.getScenePanelStateCallback.get(screenId).get(this.panelZIndex.specialScenePanel);
    } else {
      getStateCallback = this.getScenePanelStateCallback.get(screenId).get(this.panelZIndex.scenePanel);
    }
    if (!getStateCallback) {
      log.showError('isExpectedState failed to getScenePanelStateCallback with zIndex failed scenePanelZIndex:' +
      this.panelZIndex.scenePanel + ' specialScenePanelZ: ' + this.panelZIndex.specialScenePanel);
      return false;
    }
    return stateArray.indexOf(getStateCallback()) > -1;
  }

  public skipSensorRotationChange(rotateReasonDescription: string): boolean {
    if (!SCBScreenSessionManager.getInstance().getScreenOrientationLocked()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[skipSensorRotationChange] screen is not locked.');
      return false;
    }
    let containerSessionList = this.getContainerSessionList();
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let sessionLists = [specialContainerSessionList, containerSessionList];
    let activeSession: SCBSceneContainerSession = this.getFirstActiveSession(sessionLists);
    if (!activeSession) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[skipSensorRotationChange] no active session.');
      return false;
    }
    let targetOrientationMatch = (activeSession.requestOrientation === SCBSceneOrientation.AUTO_ROTATION_RESTRICTED ||
      activeSession.requestOrientation === SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED);
    if (!targetOrientationMatch) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[skipSensorRotationChange] not match skip sensor rotation condition.');
      return false;
    }
    if (rotateReasonDescription !== SENSOR_ROTATION_CHANGE) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[skipSensorRotationChange] reason is not sensor rotation change.');
      return false;
    }
    return true;

  }

  /**
   * get Phone Screen Rotate Rotation
   *
   * @param sensorRotation
   * @param currScreenRotation
   * @param screenId
   * @returns [boolean, number] [是否可旋转，需要旋转到的角度]
   */
  public getPhoneTargetRotation(sensorRotation: number, currScreenRotation: number, screenId: number, isFromFoldToExpand: boolean = false): [boolean, number] {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[getPhoneTargetRotation] sensorRotation:${sensorRotation}, ` + 
                 `currScreenRotation:${currScreenRotation}, screenId:${screenId}, ` + 
                 `isFromFoldToExpand:${isFromFoldToExpand}`);
    if (!isFromFoldToExpand && ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD_BOUNCER)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] In bouncer interface, not handle sensor rotation');
      return [false, currScreenRotation];
    }
    let containerSessionList = this.getContainerSessionList();
    let floatContainerSessionList = this.getFloatingSessionList();
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let sessionLists = [specialContainerSessionList, containerSessionList];
    let isRotateScreen = SCBWindowRotateController.getInstance().isDesktopRotatable();
    if (this.isScreenLockNeedRotate(isRotateScreen, specialContainerSessionList, screenId)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] need rotate when screen locked');
      return [true, sensorRotation];
    }
    let activeSession: SCBSceneContainerSession = this.getFirstActiveSession(sessionLists);
    let activeFloatSession: SCBSceneContainerSession = this.getFirstActiveFloatSession(floatContainerSessionList);
    if (activeFloatSession) {
      let isFloatingDragging: boolean = scbEventExclusiveManager.getEventExclusiveByCaller(EventType.FLOATING_DRAG);
      if (isFloatingDragging) {
        activeFloatSession.setSkipRotation(true);
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] floatScene is dragging, not handleSensorRotation');
        return [false, currScreenRotation];
      }
    }
    if (this.isDraggingDock()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] isDraggingDock, not handleSensorRotation');
      return [false, currScreenRotation];
    }

    if (this.isDraggingPip()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] pip dragging, not handleSensorRotation');
      return [false, currScreenRotation];
    }

    if (!activeSession) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] no active session, check if need rotate.');
      return this.checkNeedRotate(isRotateScreen, screenId, sensorRotation, currScreenRotation, isFromFoldToExpand);
    }
    if ((activeSession.isSplit || activeSession.splitParam.getLifeCycle() ===
            SplitLifeCycle.EXIT_SPLIT_TO_FULLSCREEN) && activeSession.splitParam.getNeedDelayRotation() > 0) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getPhoneTargetRotation] delay rotation when dragging the title Bar or dock.');
      activeSession.setSkipRotation(true);
      return [false, currScreenRotation];
    }
    let targetRotation = currScreenRotation;
    if (activeSession && (this.isExpectedState(screenId, ScenePanelState.FULLSCENE) ||
      this.isExpectedState(screenId, ScenePanelState.SPLIT))) {
      let targetRotation = activeSession.getTargetRotation(sensorRotation);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[getPhoneTargetRotation] active session rotation, targetRotation:${targetRotation}, ` +
                   `currScreenRotation:${currScreenRotation}.`);
      if (currScreenRotation !== targetRotation) {
        return [true, targetRotation];
      }
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[getPhoneTargetRotation] default currentRotation: ${targetRotation}`);
    return [false, targetRotation];
  }

  public getTopActiveContainerSession(): SCBSceneContainerSession {
    let containerSessionList = this.getContainerSessionList();
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let sessionLists = [specialContainerSessionList, containerSessionList];
    return this.getFirstActiveSession(sessionLists);
  }

  private checkNeedRotate(isRotateScreen: boolean, screenId: number, sensorRotation: number,
    currScreenRotation: number, isFromFoldToExpand: boolean = false): [boolean, number] {
    let res: [boolean, number] = [false, currScreenRotation];
    if (!isRotateScreen) {
      if (isFromFoldToExpand) {
        if (currScreenRotation !== RotationConstants.ROTATION_0) {
          WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[checkNeedRotate] no active session rotate to 0`);
          res = [true, RotationConstants.ROTATION_0];
        } else {
          WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[checkNeedRotate] rotate to 0, currScreenRotation:${currScreenRotation}`);
          res = [false, currScreenRotation];
        }
      } else {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[checkNeedRotate] not from fold to expand currScreenRotation:${currScreenRotation}`);
        return res;
      }
    } else {
      let isScreenRotationLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked(screenId);
      if (!isScreenRotationLocked && sensorRotation !== currScreenRotation &&
        !this.isExpectedState(screenId, ScenePanelState.RECENT) &&
        !this.isExpectedState(screenId, ScenePanelState.QUICK_SWITCH)) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[checkNeedRotate]screen rotate, sensorRotation:${sensorRotation}`);
        res = [true, sensorRotation];
      }
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[checkNeedRotate] default rotate keep currScreenRotation:${currScreenRotation}`);
    return res;
  }

  private getFirstActiveFloatSession(floatContainerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSession {
    let activeFloatSession: SCBSceneContainerSession = null;
    for (let i = floatContainerSessionList?.length - 1; i >= 0; --i) {
      if (floatContainerSessionList[i].isActive) {
        activeFloatSession = floatContainerSessionList[i];
        break;
      }
    }
    return activeFloatSession;
  }

  private getFirstActiveSession(sessionLists: SCBSceneContainerSessionArray[]): SCBSceneContainerSession {
    let activeSession: SCBSceneContainerSession = null;
    for (let list of sessionLists) {
      if (list === undefined) {
        continue;
      }
      if (activeSession != null) {
        break;
      }
      for (let i = list?.length - 1; i >= 0; --i) {
        if (list[i].isActive && !list[i].isFloat) {
          activeSession = list[i];
          break;
        }
      }
    }
    return activeSession;
  }

  private isScreenLockNeedRotate(isRotateScreen: boolean, specialContainerSessionList: SCBSceneContainerSessionArray,
    screenId: number): boolean {
    return isRotateScreen && this.isScreenLocked() && specialContainerSessionList.length === 0 &&
      !SCBScreenSessionManager.getInstance().getScreenOrientationLocked(screenId);
  }

  /**
   * is Screen Need Rotate
   *
   * @param sensorRotation
   * @param screenId
   * @returns
   */
  public isScreenNeedRotate(sensorRotation: number, curScreenRotation: number, screenId: number): boolean {
    let isAutoRotationLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked(screenId);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (SCBScreenSessionManager.getInstance().isSingleFoldablePhoneFoldStatus()) {
      log.showInfo(`isScreenNeedRotate, isSingleDisplayPocketFoldDevice: no need rotate`);
      return false;
    }
    let topActiveSession = this.getTopActiveSessionForRotateCheck();
    let targetRotation = topActiveSession?.getTargetRotation(sensorRotation);
    log.showInfo(`isScreenNeedRotate,sensorRotation:${sensorRotation},curScreenRotation:${curScreenRotation},` +
      `targetRotation:${targetRotation}`);
    if (this.shouldDelayRotation()) {
      if (topActiveSession) {
        topActiveSession.setSkipRotation(true);
      }
      log.showInfo('delay rotation');
      return false;
    }

    if (this.isDraggingFloatScene()) {
      let activeFloatSession = this.getFloatingSessionList().getTopActiveSession();
      activeFloatSession?.setSkipRotation(true);
      log.showInfo('Dragging float scene, not handleSensorRotation');
      return false;
    }

    if (this.isDraggingDock()) {
      log.showInfo('dock dragging, not handleSensorRotation');
      return false;
    }

    if (this.isDraggingPip()) {
      log.showInfo('pip dragging, not handleSensorRotation');
      return false;
    }

    if (!topActiveSession) {
      if (!isAutoRotationLocked && sensorRotation !== curScreenRotation &&
        !this.isScenePanelInState(screenId, ScenePanelState.RECENT, ScenePanelState.QUICK_SWITCH)) {
        log.showInfo('no active session rotate');
        return true;
      }
      return false;
    }
    if (this.isScenePanelInState(screenId, ScenePanelState.FULLSCENE, ScenePanelState.SPLIT) &&
      curScreenRotation !== targetRotation) {
      log.showInfo('full or split container session rotate');
      return true;
    }
    return false;
  }

  /**
   * is UserRotationPolicy Session Active
   *
   * @param screenId
   * @returns
   */
  public isRotateLockedUnrelatedSessionActive(screenId: number): boolean {
    let containerSessionList = this.getContainerSessionList();
    let specialContainerSessionList = this.getSpecialContainerSessionList();
    let sessionLists = [specialContainerSessionList, containerSessionList];
    let activeSession: SCBSceneContainerSession = null;
    for (let list of sessionLists) {
      if (list === undefined) {
        continue;
      }
      if (activeSession != null) {
        break;
      }
      for (let i = list?.length - 1; i >= 0; --i) {
        if (list[i].isActive) {
          activeSession = list[i];
          break;
        }
      }
    }
    if (activeSession && this.isExpectedState(screenId, ScenePanelState.FULLSCENE)) {
      let requestedOrientation = activeSession.getContainerRequestOrientation();
      if (requestedOrientation === SCBSceneOrientation.UNSPECIFIED) {
        return SCBDefaultOrientationPolicy.getInstance().isRotateLockedUnrelated();
      }
      if ((requestedOrientation > SCBSceneOrientation.UNSPECIFIED &&
        requestedOrientation <= SCBSceneOrientation.SENSOR_HORIZONTAL) ||
        requestedOrientation === SCBSceneOrientation.LOCKED ||
        requestedOrientation === SCBSceneOrientation.FOLLOW_RECENT ||
        (requestedOrientation >= SCBSceneOrientation.USER_ROTATION_PORTRAIT &&
          requestedOrientation <= SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED)) {
        return true;
      }
    }
    return false;
  }

  /**
   * Update keyguard occlude state
   *
   * @param scene the target scene who occlude above keyguard
   * @param occluded whether occlude the keyguard
   */
  public updateKeyguardOccludedState(sceneFlag: OccludeKeygaurdScene, occluded: boolean): void {
    log.showInfo(`updateKeyguardOccludedState sceneFlag: ${sceneFlag}, occluded: ${occluded}`);
    const oldKeyguardOccludedState = this.keyguardOccludedState;
    if (occluded) {
      this.keyguardOccludedState |= sceneFlag;
    } else {
      this.keyguardOccludedState &= ~sceneFlag;
    }
    log.showInfo(`updateKeyguardOccludedState oldKeyguardOccludedState: ${oldKeyguardOccludedState}, keyguardOccludedState: ${this.keyguardOccludedState}`);
    if (oldKeyguardOccludedState !== this.keyguardOccludedState) {
      this.notifyKeyguardOccludedChanged(this.keyguardOccludedState);
    }
  }

  private notifyKeyguardOccludedChanged(occluded: number): void {
    this.keyguardOccludedChangeCallbacks.forEach((keyguardOccludedChangeCallback) => {
      if (keyguardOccludedChangeCallback) {
        keyguardOccludedChangeCallback(occluded);
      }
    });
  }

  public updateFullSceneEnd(bundleName: string, abilityName: string): void {
    if (this.fullSceneEndCallback) {
      this.fullSceneEndCallback(bundleName, abilityName);
    }
  }

  /**
   * 更新当前桌面是否有遮挡的scenePanel
   * @param sceneList scenePanel中包含的scene
   * @param zorder scenePanle的zorder
   */
  public updateHomeOccludedState(sceneList: SCBSpecificSceneSessionList, zorder: number): void {
    let sessions = [];
    sceneList.forEach((item: SCBSpecificSession) => {
      if (!item.isActive) {
        return;
      }
      if (NOT_OCCLUDE_DESKTOP_CLOCK_TYPES.includes(item.session?.type)) {
        return;
      }
      sessions.push(item.session);
      log.showInfo(`scene type is ${item.session?.type} pushed`);
    });

    if (sessions.length > 0) {
      this.homeOccludedPanels.set(zorder, sessions);
    } else {
      this.homeOccludedPanels.delete(zorder);
    }

    log.showInfo(`zorder: ${zorder} sessions.length: ${sessions.length} size: ${this.homeOccludedPanels.size}`);
  }

  /**
   * 获取当前桌面存在的panel中的session
   * @returns 当前桌面存在的panel中的session
   */
  public getHomeOccludedPanels(): Map<number, sceneSessionManager.SceneSession[]> {
    return this.homeOccludedPanels;
  }

  public getKeyguardOccludedByScenePanel(): boolean {
    let belowOccluded: boolean = this.getContainerSessionList().getTopActiveSession()?.isShowWhenLocked() ?? false;
    let aboveOccluded: boolean = this.getSpecialScenePanelState() === ScenePanelState.FULLSCENE;
    return belowOccluded || aboveOccluded;
  }

  private getSpecialScenePanelState(screenId?: number): ScenePanelState {
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    let stateCallback = this.getScenePanelStateCallback.get(screenId)?.get(this.panelZIndex.specialScenePanel);
    return stateCallback ? stateCallback() : ScenePanelState.HOME;
  }

  public sendTouchEvent(event: TouchEvent, zIndex: number): void {
    if (!event) {
      log.showError('event is null');
      return;
    }
    log.showInfo(`sendTouchEvent zIndex：${zIndex}`);
    sceneSessionManager.sendTouchEvent(event, zIndex);
  }

  /**
   * set Maximize Floating Mode
   *
   * @param isMaximizeFloatingMode
   */
  public setMaximizeFloatingMode(isMaximizeFloatingMode: boolean): void {
    log.showInfo('setMaximizeFloatingMode start, isMaximizeFloatingMode is:' + isMaximizeFloatingMode);
    this.isMaximizeFloatingMode = isMaximizeFloatingMode;
  }

  /**
   * is Need Maximize Floating
   *
   * @returns
   */
  public isNeedMaximizeFloating(): boolean {
    log.showInfo('isNeedMaximizeFloating start, isMaximizeFloatingMode is:' + this.isMaximizeFloatingMode);
    return this.isMaximizeFloatingMode;
  }

  /**
   * preload App
   *
   * @param bundleName
   * @returns
   */
  public async preloadApp(bundleName: string): Promise<void> {
    log.showInfo('preloadInLakeApp:' + bundleName);
    sceneSessionManager.preloadInLakeApp(bundleName);
  }

  /**
   * call Recent Funcs
   *
   * @param enterRecent
   */
  public callRecentFuncs(enterRecent: boolean): void {
    log.showInfo('callRecentFuncs ' + enterRecent);
    if (enterRecent === false && this.isExpectedState(this.mainScreenId, ScenePanelState.HOME)) {
      SceneIdentificationManager.notify(SceneState.RECENT_EXIT);
    }
    this.systemBarPropertyRecentCallbacks.forEach((systemBarPropertyCallback) => {
      if (systemBarPropertyCallback) {
        systemBarPropertyCallback(enterRecent);
      }
    });
  }

  /**
   * notify AI Navigation Bar Show Status
   *
   * @param isVisible
   * @param barArea
   * @param screenId
   */
  public notifyAINavigationBarShowStatus(isVisible: boolean, barArea: RectInfo, screenId: number): void {
    if (barArea === null || barArea === undefined) {
      log.showError('notifyAINavigationBarShowStatus barArea is null');
      return;
    }
    if (screenId === INVALID_SCREEN_ID) {
      log.showError('notifyAINavigationBarShowStatus screenId is invalid');
      screenId = this.mainScreenId;
    }
    log.showInfo(`notifyAINavigationBarShowStatus: isVisible ${isVisible} barArea ${JSON.stringify(barArea)}` +
      ` screenId ${screenId}`);
    try {
      sceneSessionManager.notifyAINavigationBarShowStatus(isVisible, barArea, screenId);
    } catch (err) {
      log.showError('!!! notifyAINavigationBarShowStatus failed, with reason ' + JSON.stringify(err));
    }
    if (this.navChangeCallback) {
      this.navChangeCallback(isVisible, barArea);
    }
  }

  /**
   * 通知沉浸式导航条热区大小
   * @param isVisible
   * @param screenId
   * @param portraitRect
   * @param horizontalRect
   */
  public notifyNextAINavigationBarRectInfo(screenId: number, portraitRect: RectInfo, horizontalRect: RectInfo): void {
    if (portraitRect === null || portraitRect === undefined ||
      horizontalRect === null || horizontalRect === undefined) {
      log.showError('notifyNextAINavigationBarRectInfo barArea is null');
      return;
    }
    if (screenId === INVALID_SCREEN_ID) {
      log.showError('notifyNextAINavigationBarRectInfo screenId is invalid');
      screenId = this.mainScreenId;
    }
    log.showInfo(`notifyAINavigationBarShowStatus: screenId ${screenId}`);
    try {
      sceneSessionManager.notifyNextAvoidRectInfo(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR, screenId,
        portraitRect, horizontalRect);
    } catch (err) {
      log.showError('notifyNextAINavigationBarRectInfo failed');
    }
  }


  /**
   * has Full Scene Session
   *
   * @param screenId
   * @returns
   */
  public hasFullSceneSession(screenId: number): boolean {
    let containerSessionList = this.getContainerSessionList();
    let activeSession: SCBSceneContainerSession = null;
    for (let item of containerSessionList) {
      if (!item) {
        continue;
      }
      if (item.isActive) {
        activeSession = item;
        break;
      }
    }
    if (activeSession && !activeSession.isOneStepSplit() &&
      this.isExpectedState(screenId, ScenePanelState.FULLSCENE)) {
      return true;
    }
    return false;
  }

  private isFloatingSceneNeedDelayRotation():boolean {
    let isFloatingDragging = AppStorage.get<boolean>('floatingDragging') ?? false;
    return isFloatingDragging;
  }

  /**
   * register Animation Callback
   *
   * @param callback
   * @param screenId
   */
  public registerAnimationCallback(callback: (screenId: number, persistentId: number) => void, screenId: number): void {
    log.showInfo(`registerAnimationCallback ${screenId}`);
    this.doAnimationCallbackMap.set(screenId, callback);
  }

  /**
   * unregister Animation Callback
   *
   * @param screenId
   */
  public unregisterAnimationCallback(screenId: number): void {
    log.showInfo(`unregisterAnimationCallback ${screenId}`);
    if (this.doAnimationCallbackMap.has(screenId)) {
      this.doAnimationCallbackMap.delete(screenId);
    }
  }

  /**
   * do Animation
   *
   * @param screenId
   * @param persistentId
   */
  public doAnimation(screenId: number, persistentId: number): void {
    if (this.doAnimationCallbackMap.has(screenId)) {
      let callBack = this.doAnimationCallbackMap.get(screenId);
      if (callBack) {
        callBack(screenId, persistentId);
      }
    }
  }

  /**
   * unregister ExternalScreenInterceptor Callback
   */
  public unregisterExternalScreenInterceptorCallback(): void {
    log.showInfo('unregisterExternalScreenInterceptorCallback');
    this.isExternalScreenInterceptedCallback = null;
  }

  /**
   * register ExternalScreenInterceptor Callback
   *
   * @param callback
   */
  public registerExternalScreenInterceptorCallback(isExternalScreenInterceptedCallback: (sceneInfo: SCBSceneInfo,
    isNeedShowToast: boolean) => boolean): void {
    log.showInfo('registerExternalScreenInterceptorCallback');
    this.isExternalScreenInterceptedCallback = isExternalScreenInterceptedCallback;
  }

  /**
   * 判断是否需要在外屏拦截启动
   *
   * @param sceneInfo sceneInfo实例
   * @returns 是否需要在外屏拦截启动
   */
  public isExternalScreenIntercepted(sceneInfo: SCBSceneInfo, isNeedShowToast?: boolean): boolean {
    if (this.isExternalScreenInterceptedCallback === null || this.isExternalScreenInterceptedCallback === undefined) {
      return false;
    }
    let isExternalScreenInterceptedFlag: boolean = this.isExternalScreenInterceptedCallback(sceneInfo, isNeedShowToast);
    log.showInfo(`[SCBMain] Scene is intercepted on external screen, flag: ${isExternalScreenInterceptedFlag}`);
    return isExternalScreenInterceptedFlag;
  }


  // 互斥业务
  public isExclusion(bundleName: string, sceneMode: SCBSceneMode, isToast: boolean = true): boolean {
    log.showWarn('isExclusion, app startup detect');
    return false;
  }

  public requestStartUIAbilityBySCB(sceneSession: sceneSessionManager.SceneSession): void {
    try {
      sceneSessionManager.startUIAbilityBySCB(sceneSession);
    } catch (err) {
      log.showError(`requestStartUIAbilityBySCB, errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  public requestChangeUIAbilityVisibilityBySCB(sceneSession: sceneSessionManager.SceneSession,
                                               visibility: boolean,
                                               isFromClient: boolean = true,
                                               isNewWant: boolean = false): void {
    try {
      sceneSessionManager.changeUIAbilityVisibilityBySCB(sceneSession, visibility, isFromClient, isNewWant);
    } catch (err) {
      log.showError(`requestChangeUIAbilityVisibilityBySCB, errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  public storeCastTask(sceneInfo: SCBSceneInfo): void {
    log.showInfo('storeCastTask, sceneInfo: bundleName = ' + sceneInfo.bundleName);
    sceneInfo.isCastScene = true;
    this.cacheCastSessionInfo = sceneInfo;
  }

  public runCastTaskIfNeed(): void {
    log.showInfo('runCastTaskIfNeed');
    if (this.cacheCastSessionInfo !== null) {
      log.showInfo('runCastTaskIfNeed');
      SCBSceneSessionManager.getInstance().startSceneFromIcon(this.cacheCastSessionInfo);
      this.cacheCastSessionInfo = null;
    }
  }

  public onPendingCastScene(sceneInfo: sceneSessionManager.SceneInfo, toSceneInfo: SCBSceneInfo): boolean {
    let name = SCBScreenSessionManager.getInstance().getScreenSession(toSceneInfo.screenId)?.session?.name;
    if (name === 'CastEngine') {
      toSceneInfo.isCastScene = true;
      SCBSceneSessionManager.getInstance().startSceneFromIcon(toSceneInfo);
      return true;
    } else if (name === undefined && sceneInfo.isCastSession) {
      SCBSceneSessionManager.getInstance().storeCastTask(toSceneInfo);
      return true;
    }
    return false;
  }

  /**
   * get getPreferMultiWindowOrientation From abilityInfo
   *
   * @param queryKey
   * @returns
   */
  public getPreferMultiWindowOrientation(queryKey: string): string {
    if (this.abilityInfoMap.has(queryKey)) {
      return this.abilityInfoMap.get(queryKey).preferMultiWindowOrientation;
    }
    log.showWarn(`getPreferMultiWindowOrientation not find: ${queryKey}`);
    return PreferMultiWindowOrientation.DEFAULT;
  }

  /**
   * register MidScene StateChange Callback
   * @param callBack
   */
  public registerMidSceneStateChangeCallBack(callBack: Function): void {
    log.showInfo('registerMidSceneStateChangeCallBack');
    this.midSceneStateChangeCallBack = callBack;
  }

  /**
   * unRegister MidScene StateChange Callback
   */
  public unRegisterMidSceneStateChangeCallBack(): void {
    log.showInfo('unRegisterMidSceneStateChangeCallBack');
    this.midSceneStateChangeCallBack = null;
  }

  /**
   * register Navigation Indicator Callback
   *
   * @param callback
   */
  public registerNavChangeCallback(callBack: Function): void {
    log.showInfo('registerNavChangeCallback');
    this.navChangeCallback = callBack;
  }

  /**
   * unRegister Navigation Indicator Change Listener
   */
  public unRegisterNavChangeCallback(): void {
    log.showInfo('unRegisterNavChangeCallback');
    this.navChangeCallback = null;
  }

  /**
   * notify exit game split.
   * @param { SCBSceneContainerSession } activeSceneContainerSession - the current container session.
   */
  public notifyExitGameSplit(activeSceneContainerSession: SCBSceneContainerSession): void {
    if (activeSceneContainerSession && activeSceneContainerSession.hasFixedMultiWindowOrientationSession() &&
      activeSceneContainerSession.isSplit) {
      this.exitGameSplitView(activeSceneContainerSession.screenProperty.screenId,
        activeSceneContainerSession.primarySession?.session.persistentId,
        activeSceneContainerSession.containerId);
    }
  }

  public notifyExitGameSplitWithFold(): void {
    const topActiveSession = this.getContainerSessionList().getTopActiveSession();
    this.notifyExitGameSplit(topActiveSession);
  }

  /**
   * notify enter recent task status to native
   * @param enterRecent
   */
  public notifyEnterRecentTask(enterRecent: boolean) : void {
    try {
      sceneSessionManager.notifyEnterRecentTask(enterRecent);
    } catch (err) {
      log.showError(`notifyEnterRecentTask failed, with reason ${JSON.stringify(err)}`);
    }
  }

  /**
   * receive status from recent task to control status bar properties.
   *
   * @param enterRecent
   */
  public enterRecentTask(enterRecent: boolean, enableAnimation: boolean = true): void {
    WinLog.showInfo(WinLogDomain.WMS_IMMS, `enterRecent:${enterRecent}`);
    this.recentTaskChangeProcess = enterRecent ? 'in' : 'out';
    if (enterRecent) {
      this.notifyEnterRecentTask(enterRecent);
      // 在进入多任务的情况下隐藏状态栏并更新状态栏属性
      this.updateSceneBoardForceProperty(new SCBSystemBarProperty(
        sceneSessionManager.SessionType.TYPE_STATUS_BAR, false, '#00FFFFFF', '#FFFFFFFF', enableAnimation, true),
        'RecentTask in');
      this.updateSystemBarProperty();
    } else {
      // 离开多任务的情况下显示状态栏
      this.updateSceneBoardForceProperty(new SCBSystemBarProperty(
        sceneSessionManager.SessionType.TYPE_UNDEFINED, false, '#00FFFFFF', '#FFFFFFFF', enableAnimation, true),
        'RecentTask out');
      this.updateSystemBarProperty();
      this.notifyEnterRecentTask(enterRecent);
    }
    this.recentTaskChangeProcess = undefined;
  }

  /**
   * whether to show status bar  temporariy
   * @param isShowStatusBarTemporary
   */
  public setIsShowStatusBarTemporary(isShowStatusBarTemporary: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    let session: SCBSceneContainerSession;
    for (let i = containerSessionList?.length - 1; i >= 0; --i) {
      session = containerSessionList[i];
      if (session?.isActive) {
        log.showInfo(`setIsShowStatusBarTemporary ${session.primarySession?.session?.persistentId} ${isShowStatusBarTemporary}`);
        session?.primarySession?.notifyDisplayStatusBarTemporarily(isShowStatusBarTemporary);
        session?.secondarySession?.notifyDisplayStatusBarTemporarily(isShowStatusBarTemporary);
        break;
      }
    }
  }

  /**
   * notify reset split view divider param.
   * @param { SCBSceneContainerSession } activeSceneContainerSession - the current container session.
   */
  public notifyResetSplitViewWithFold(activeSceneContainerSession: SCBSceneContainerSession): void {
    if (activeSceneContainerSession === null || activeSceneContainerSession === undefined ||
      !activeSceneContainerSession.isSplitView()) {
      log.showWarn('notifyResetDividerParam: notifyResetDividerParam sceneSession is not avaliable');
      return;
    }
    this.resetSplitViewWithFold(activeSceneContainerSession.screenProperty.screenId,
      activeSceneContainerSession.primarySession?.session.persistentId,
      activeSceneContainerSession.containerId);
  }

  /**
   * register get virtual screen sceneSession function
   *
   * @param sceneSession
   * @param screedId
   */
  public registerGetVirtualScreenSceneSessionFunc(
    getSessionById: ((id: number) => SCBSceneSession | SCBSpecificSession | undefined), screedId: number): void {
    this.getVirtualScreenSessionFuncMap.set(screedId, getSessionById);
  }

  /**
   * unregister get virtual screen sceneSession function
   *
   * @param screenId
   */
  public unregisterGetVirtualScreenSceneSessionFunc(screenId: number): void {
    this.getVirtualScreenSessionFuncMap.delete(screenId);
  }

  /**
   * get screen id by window id
   *
   * @param windowId
   */
  public getScreenIdByWindowId(windowId: number): number {
    for (let srcId of this.getVirtualScreenSessionFuncMap.keys()) {
      const session = this.getVirtualScreenSessionFuncMap.get(srcId)?.(windowId);
      if (session !== undefined) {
        return srcId;
      }
    }
    log.showInfo('not find in virtual screen, window id is : ' + windowId);
    return this.mainScreenId;
  }

  /**
   * register compatible view change callback
   *
   * @param callback
   */
  public registerCompatibleViewChangeCallback(callback): void {
    this.compatibleViewChangeCallback = callback;
  }

  /**
   * unregister compatible view change callback
   *
   */
  public unregisterCompatibleViewChangeCallback(): void {
    this.compatibleViewChangeCallback = null;
  }

  /**
   * notify compatible view change callback
   *
   * @param container - container session
   * @param isEnterCompatibleView - true means enter compatible view, and false means quit
   */
  public notifyCompatibleViewChange(container: SCBSceneContainerSession, isEnterCompatibleView: boolean): void {
    this.compatibleViewChangeCallback?.(container, isEnterCompatibleView);
  }

  /**
   * update session display id
   *
   * @param persistentId
   * @param screenId
   */
  public updateSessionDisplayId(persistentId: number, screenId: number): void {
    log.showInfo(`[SCBMain]updateSessionDisplayId, persistentId:${persistentId}`);
    try {
      if (persistentId === INVALID_PERSISTENT_ID || screenId === INVALID_SCREEN_ID) {
        log.showError('[SCBMain]updateSessionDisplayId persistentId or screenId is invaild');
        return;
      }
      sceneSessionManager.updateSessionDisplayId(persistentId, screenId);
    } catch (err) {
      log.showError('[SCBMain]updateSessionDisplayId failed, with reason ' + JSON.stringify(err));
    }
  }

  /**
   * 判断兼容模式在哪些设备上适用
   *
   * @returns
   */
  public isSupportCompatibilityMode(): boolean {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    return uiType === SCBConstants.UITYPE_PAD || uiType === SCBConstants.UITYPE_PC ||
      DeviceHelper.isUltraScreenProduct() || DeviceHelper.isLargeInFoldProduct();
  }

  /*
  * whether scb core enhance is enable
  */
  public get isCoreEnable(): boolean {
    try {
      this._isCoreEnable = sceneSessionManager.isScbCoreEnabled();
    } catch (err) {
      log.showError('[SCBMain]isScbCoreEnabled failed, with reason ' + JSON.stringify(err));
    }
    return this._isCoreEnable;
  }

  /**
   * trigger the listeners by persistentId
   * @param persistentId  the persistentId of window
   * @param label  the newest name
   * @returns
   */
  async updateSessionLabelByPersistentId(persistentId: number, label: string): Promise<void> {
    log.showInfo(`updateSessionLabelByPersistentId, persistentId:${persistentId}`);
    if (CheckEmptyUtils.isEmpty(label)) {
      return;
    }
    this.onSessionLabelListeners.get(persistentId)?.forEach((listener) => listener.onUpdate(label));
  }

  /**
   * register sessionLabel change event listener with persistentId
   *
   * @param persistentId the persistentId of window
   * @param listener label listener
   */
  registerSessionLabelListener(persistentId: number, listener: SessionLabelListener): void {
    log.showDebug(`registerBadgeListener persistentId:${persistentId}`);
    let listeners = this.onSessionLabelListeners.get(persistentId) ?? new ArrayList<SessionLabelListener>();
    listeners.add(listener);
    this.onSessionLabelListeners.set(persistentId, listeners);
  }

  /**
   * unregister sessionLabel change event listener with persistentId
   *
   * @param persistentId the persistentId of window
   * @param listener label listener
   */
  unRegisterSessionLabelListener(persistentId: number, listener: SessionLabelListener): void {
    log.showDebug(`unRegisterBadgeListener persistentId:${persistentId}`);
    let listeners = this.onSessionLabelListeners.get(persistentId);
    listeners?.remove(listener);
    if (listeners?.isEmpty()) {
      this.onSessionLabelListeners.delete(persistentId);
    }
  }

  /**
   * clear sessionLabel change event listeners by persistentId
   *
   * @param persistentId the persistentId of window
   * @param listener label listener
   */
  clearSessionLabelListenerByPersistentId(persistentId: number): void {
    log.showDebug(`clearSessionLabelListenerByPersistentId persistentId:${persistentId}`);
    this.onSessionLabelListeners.delete(persistentId);
  }

  /**
   * trigger the iocn listeners by persistentId
   * @param persistentId  the persistentId of window
   * @param icon the newest icon
   * @returns
   */
  updateSessionIconByPersistentId(persistentId: string, icon: image.PixelMap): void {
    log.showInfo(`updateSessionLabelByPersistentId, persistentId:${persistentId}`);
    if (CheckEmptyUtils.isEmpty(icon)) {
      return;
    }
    this.onSessionIconListeners.get(persistentId)?.forEach((listener) => listener.onUpdate(icon));
  }

  /**
   * register session icon change event listener with persistentId
   *
   * @param persistentId the persistentId of window
   * @param listener icon listener
   */
  registerSessionIconListener(persistentId: string, listener: SessionIconListener): void {
    log.showDebug(`registerSessionIconListener persistentId:${persistentId}`);
    let listeners = this.onSessionIconListeners.get(persistentId) ?? new ArrayList<SessionIconListener>();
    listeners.add(listener);
    this.onSessionIconListeners.set(persistentId, listeners);
  }

  /**
   * unregister session icon change event listener with persistentId
   *
   * @param persistentId the persistentId of window
   * @param listener icon listener
   */
  unRegisterSessionIconListener(persistentId: string, listener: SessionIconListener): void {
    log.showDebug(`unRegisterSessionIconListener persistentId:${persistentId}`);
    let listeners = this.onSessionIconListeners.get(persistentId);
    listeners?.remove(listener);
    if (listeners?.isEmpty()) {
      this.onSessionIconListeners.delete(persistentId);
    }
  }

  /**
   * clear session icon change event listeners by persistentId
   *
   * @param persistentId the persistentId of window
   * @param listener icon listener
   */
  clearSessionIconListenerByPersistentId(persistentId: string): void {
    log.showDebug(`clearSessionIconListenerByPersistentId persistentId:${persistentId}`);
    this.onSessionIconListeners.delete(persistentId);
  }

  private registerEventExclusive(): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PAD) {
      scbEventExclusiveManager.registerEventExclusive(EventType.TOUCH_FLOATINGDRAG_HOTAREA,
        () => {
          let isTouchFloatingDragHotArea: boolean =
            scbEventExclusiveManager.getEventExclusiveByCaller(EventType.TOUCH_FLOATINGDRAG_HOTAREA);
          log.showInfo(`gestureBackExclusiveCallback isTouchFloatingDragHotArea:${isTouchFloatingDragHotArea}`);
          if (isTouchFloatingDragHotArea) {
            scbEventExclusiveManager.setEventExclusive(EventType.TOUCH_FLOATINGDRAG_HOTAREA, false);
          }
        });
    }
  }

  /**
   * closet target float window
   *
   * @param bundleName the bundle need be control
   */
  public closeTargetFloatWindow(bundleName: string): void {
    this.executeCloseFloatCallback(SCBEventId.CLOSE_TARGET_FLOAT_WINDOW, bundleName);
    this.executeSpecialCloseFloatCallback(SCBEventId.CLOSE_TARGET_FLOAT_WINDOW, bundleName);
  }

  private executeCloseFloatCallback(eventId: SCBEventId, bundleName: string): void {
    if (!this.callbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.callbackMap.get(eventId);
    sceneFuncMap?.forEach(functions => {
      functions.forEach((value: Function) => {
        value(bundleName);
      });
    });
  }

  private executeSpecialCloseFloatCallback(eventId: SCBEventId, bundleName: string): void {
    if (!this.specialCallbackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let sceneFuncMap = this.specialCallbackMap.get(eventId);
    sceneFuncMap?.forEach(functions => {
      functions.forEach((value: Function) => {
        value(bundleName);
      });
    });
  }

  public executeAutoStartPiPCallback(persistentId: number): void {
    log.showInfo('executeAutoStartPiPCallback, sessionId:' + persistentId);
    if (this.autoStartPiPCallback) {
      this.autoStartPiPCallback(persistentId);
    }
  }

  public closePiP(sceneSession: SCBSceneSession): void {
    log.showInfo('close pip window');
    if (!sceneSession || !sceneSession.sceneInfo) {
      return;
    }
    let hasPipWindow =
      SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.PIP_PANEL).length;
    if (hasPipWindow) {
      log.showInfo('pip window existed');
      let specificSession =
        SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.PIP_PANEL)[0];
      let parentSession = SCBSceneSessionManager.getInstance().getSessionById(specificSession?.session?.parentId);
      if (!parentSession) {
        parentSession = this.getSideEdgeSessionList().getSessionByPersistentId(specificSession?.session?.parentId);
      }
      if (parentSession instanceof SCBSceneSession &&
        parentSession.sceneInfo?.bundleName === sceneSession.sceneInfo.bundleName) {
        log.showInfo(`${parentSession.sceneInfo?.bundleName} close pip`);
        specificSession.notifyClosePiP();
      }
    }
  }

  /**
   * refresh pc panel z order
   *
   * @param startZOrder start z Order
   * @param persistentIds refresh persistent id list
   */
  public refreshPcZOrder(startZOrder: number, persistentIds: number[]): void {
    log.showInfo(`refreshPcZOrder,start: ${startZOrder}, size: ${persistentIds.length}, list: ${JSON.stringify(persistentIds)}`);
    sceneSessionManager.refreshPcZOrder(startZOrder, persistentIds);
  }

  public setIsWindowRectAutoSave(key: string, enabled: boolean,
    abilityKey: string, isSaveBySpecifiedFlag: boolean): void {
    log.showInfo(`setIsWindowRectAutoSave key: ${key} ,enabled : ${enabled}`);
    sceneSessionManager.setIsWindowRectAutoSave(key, enabled, abilityKey, isSaveBySpecifiedFlag);
  }

  public getFullScreenSubSessionList(): SCBSpecificSceneSessionList {
    let result: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    let containerList = this.getContainerSessionList();
    for (let i = 0; i < containerList.length; i++ ) {
      let container = containerList[i];
      if (!container) {
        continue;
      }
      let primaryResultList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      this.traverseSubSession(container.primarySession?.subSessionList, primaryResultList);
      let secondaryResultList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      this.traverseSubSession(container.secondarySession?.subSessionList, secondaryResultList);
      primaryResultList.forEach((item)=>{
        if (item && item.windowMode === SCBSceneMode.FULLSCREEN) {
          result.push(item);
        }
      });
      secondaryResultList.forEach((item)=>{
        if (item && item.windowMode === SCBSceneMode.FULLSCREEN) {
          result.push(item);
        }
      });
    }
    return result;
  }

  public registerSessionDisplayChangeCallback(callback: Function): void {
    log.showInfo('registerSessionDisplayChangeCallback');
    this.sessionDisplayChangeCallback = callback;
  }

  public unRegisterSessionDisplayChangeCallback(): void {
    this.sessionDisplayChangeCallback = null;
  }

  /**
   * exec product callback When session change to another screen,
   * @param reason change reason
   * @param sessionChangeInfo session change infomation. Including sessions' persistentId, target screen id etc.
   */
  public sessionDisplayChange(reason: SessionDisplayChangeReason, sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`sessionDisplayChange reason: ${reason}, persistentIds len:${sessionChangeInfo.persistentIds.length}` +
      `, curScreenId:${sessionChangeInfo.curScreenId}, target screenId: ${sessionChangeInfo.targetScreenId}`);
    if (this.sessionDisplayChangeCallback) {
      this.sessionDisplayChangeCallback(reason, sessionChangeInfo);
    } else {
      log.showWarn('sessionDisplayChange sessionDisplayChangeCallback is undefined');
    }
  }

  /**
   * 注册沉浸式全屏的事件回调
   *
   * @param type
   * @param screenId
   * @param callback
   */
  public registerFullScreenLayoutCallBack(type: string, screenId: number, callback: Function): void {
    log.showInfo(`registerFullScreenLayoutCallBack type:${type}, screenId:${screenId}`);
    if (!this.fullScreenLayoutCallBack.has(screenId)) {
      let callbackMap: Map<string, Function> = new Map();
      callbackMap.set(type, callback);
      this.fullScreenLayoutCallBack.set(screenId, callbackMap);
      return;
    }
    let callbackMap: Map<string, Function> = this.fullScreenLayoutCallBack.get(screenId);
    if (callbackMap?.has(type)) {
      log.showWarn(`registerFullScreenLayoutCallBack failed. type:${type}, screenId:${screenId}`);
      return;
    }
    callbackMap.set(type, callback);
    if (!this.fullScreenLayoutMap.has(screenId)) {
      this.fullScreenLayoutMap.set(screenId, false);
    }
  }

  /**
   * 取消注册沉浸式全屏的事件回调
   *
   * @param type
   * @param screenId
   */
  public unRegisterFullScreenLayoutCallBack(type: string, screenId: number): void {
    if (!this.fullScreenLayoutCallBack.has(screenId)) {
      log.showWarn(`unRegisterFullScreenLayoutCallBack failed. type:${type}, screenId:${screenId}`);
      return;
    }
    let callbackMap: Map<string, Function> = this.fullScreenLayoutCallBack.get(screenId);
    if (callbackMap.has(type)) {
      callbackMap.delete(type);
    }
    if (callbackMap.size === 0) {
      this.fullScreenLayoutCallBack.delete(screenId);
      this.fullScreenLayoutMap.delete(screenId);
    }
    return;
  }

  /**
   * 回调沉浸式全屏事件
   *
   * @param isFullScreenLayout
   * @param screenId
   */
  public fullScreenLayoutChange(isFullScreenLayout: boolean, screenId?: number, notifyType?: string): void {
    let screen = screenId ? screenId : this.mainScreenId;
    log.showInfo(`fullScreenLayoutChange screenId:${screenId} isFullScreenLayout:${isFullScreenLayout} ` +
      `notifyType:${notifyType}`);
    for (let [key, callbackMap] of this.fullScreenLayoutCallBack.entries()) {
      if (key !== screen) {
        continue;
      }
      if (notifyType === undefined && this.fullScreenLayoutMap.get(screenId) === isFullScreenLayout) {
        return;
      }
      this.fullScreenLayoutMap.set(screenId, isFullScreenLayout);
      for (let [type, callback] of callbackMap.entries()) {
        if (notifyType !== undefined && type !== notifyType) {
          continue;
        }
        callback(isFullScreenLayout, screen);
      }
    }
    return;
  }

  /**
   * 获取沉浸式全屏状态值
   *
   * @param screenId
   * @returns
   */
  public getFullScreenLayoutStatusByScreenId(screenId: number): boolean | undefined {
    return this.fullScreenLayoutMap.get(screenId);
  }

  private isSupportMultiInstance(): boolean {
    return SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PC;
  }

  private startMultiInstance(sceneInfo: SCBSceneInfo): boolean {
    let maxInstanceCount = sceneSessionManager.getMaxInstanceCount(sceneInfo.bundleName);
    if (maxInstanceCount <= 0) {
      return false;
    }
    let instanceCount = sceneSessionManager.getInstanceCount(sceneInfo.bundleName);
    if (sceneInfo.want.parameters[SCBConstants.CREATE_NEW_APP_INSTANCE_KEY] as boolean) {
      if (instanceCount < maxInstanceCount) {
        sceneInfo.isNewAppInstance = true;
        sceneInfo.persistentId = 0;
      } else {
        sceneInfo.appInstanceKey = sceneSessionManager.getLastInstanceKey(sceneInfo.bundleName);
        if (this.hasApplicationModalSession(sceneInfo)) {
          log.showInfo(`[SCBMain]startMultiInstance, has applicationModal window`);
          return true;
        }
      }
    } else {
      if (instanceCount === 0) {
        sceneInfo.isNewAppInstance = true;
        sceneInfo.persistentId = 0;
      } else {
        sceneInfo.appInstanceKey = sceneSessionManager.getLastInstanceKey(sceneInfo.bundleName);
        if (this.hasApplicationModalSession(sceneInfo)) {
          log.showInfo(`[SCBMain]startMultiInstance, has applicationModal window`);
          return true;
        }
      }
    }
    log.showInfo(`[SCBMain]create new instance, isNewAppInstance:${sceneInfo.isNewAppInstance} appInstanceKey:${sceneInfo.appInstanceKey}`);
    this.startAbilityByLaunchType(sceneInfo);
    return true;
  }

  /**
   * register touch screen gesture callback
   */
  public registerTouchscreenGestureCallback(callback: Function): void {
    this.touchScreenGestureCallback = callback;
  }

  /**
   * unregister touch screen gesture callback
   */
  public unregisterTouchScreenGestureCallback(): void {
    this.touchScreenGestureCallback = null;
  }

  public registerTouchscreenGesture(): void {
    try {
      inputMonitor.on('touchscreenPinch', 0, (event: TouchGestureEvent) => {
        if (this.touchScreenGestureCallback) {
          this.touchScreenGestureCallback(event);
        }
        return false;
      });
    } catch (err) {
      log.showError(`touch screen pinch on, errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  public unregisterTouchScreenGesture(): void {
    try {
      inputMonitor.off('touchscreenPinch', 0);
    } catch (err) {
      log.showError(`touch screen pinch off, errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  /**
   * get session snapshot pixel map with sync
   *
   * @param persistentId window persistent id
   * @param scaleValue pixel scale
   * @param snapshotNode node for snapshot
   * @param useNewSnapshot default true
   * @returns window snapshot
   */
  public getSessionSnapshotPixelMapSync(persistentId: number, scaleValue: number,
    snapshotNode: SnapshotNodeType = SnapshotNodeType.DEFAULT_NODE,
    useNewSnapshot: boolean = true): image.PixelMap | undefined {
    log.showInfo(`[SCBMain]getSessionSnapshotPixelMapSync, persistentId:${persistentId}, scaleValue:${scaleValue},
      snapshotNode:${snapshotNode}, useNewSnapshot:${useNewSnapshot}`);
    try {
      return sceneSessionManager.getSessionSnapshotPixelMapSync(persistentId, scaleValue, snapshotNode, useNewSnapshot);
    } catch (err) {
      log.showError('[SCBMain]getSessionSnapshotPixelMapSync failed, with reason ' + JSON.stringify(err));
    }
    return undefined;
  }

  /**
   * set SystemScene isRotatable
   * @param screenProperty
   */
  public setSystemSceneRotatable(screenProperty: SCBScreenProperty): void {
    this.systemSceneList.get(screenProperty.screenId)?.forEach((systemSceneSession: SCBSystemSceneSession) => {
      if (systemSceneSession === undefined || systemSceneSession === null) {
        log.showError(`${systemSceneSession.name} setSystemSceneRotatable is null`);
        return;
      }
      systemSceneSession.setRotatable();
      if (!systemSceneSession.sessionData.isRotatable) {
        log.showInfo(`${systemSceneSession.name} rotatableChangeCallback, isRotatable ${systemSceneSession.sessionData.isRotatable}`);
      }
    });
  }

  /**
   * receive screen lock bouncer show
   */
  public receiveScreenLockBouncerShow(): void {
    let topSpecialActiveSession = this.getSpecialContainerSessionList().getTopActiveSession();
    if (this.specialScenePanelExitSceneWithRotationRecoverCallback) {
      this.specialScenePanelExitSceneWithRotationRecoverCallback(topSpecialActiveSession);
    }
  }

  /**
   * receive screen lock bouncer hide
   */
  public receiveScreenLockBouncerHide(): void {
    let topSpecialActiveSession = this.getSpecialContainerSessionList().getTopActiveSession();
    let topActiveSession = this.getContainerSessionList().getTopActiveSession();
    if (topSpecialActiveSession && this.specialScenePanelStartSceneWithRotationIfNeedCallback) {
      this.specialScenePanelStartSceneWithRotationIfNeedCallback(topSpecialActiveSession, true);
    }
    if (topActiveSession && this.startSceneWithRotationIfNeedCallback) {
      this.startSceneWithRotationIfNeedCallback(topActiveSession, true);
    }
  }

  /**
   * get bundleInfo.targetApiVersion
   *
   * @param persistentId
   * @returns { number }
   */
  public getTargetVersion(persistentId: number): number {
    if (persistentId === INVALID_PERSISTENT_ID) {
      return 0;
    }
    const bundleFlags = BundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
      BundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
    const mainSession: SCBSceneSession | null = this.findMainSessionById(persistentId);
    if (CommonUtils.isInvalid(mainSession)) {
      SCBSceneSessionManager.getInstance().refreshZOrder();
      return 0;
    }
    try {
      const bundleInfo: BundleManager.BundleInfo = BundleManager.getBundleInfoSync(
        mainSession.sceneInfo.bundleName, bundleFlags);
      if (CommonUtils.isInvalid(bundleInfo)) {
        return 0;
      }
      return bundleInfo.targetVersion;
    } catch (err) {
      log.showError(`getBundleInfoSync error, code: ${err.code}, message: ${err.message}`);
      return 0;
    }
  }

  /**
   * notify mid scene state change
   */
  public notifyMidSceneStateChange(): void {
    if (this.midSceneStateChangeCallBack) {
      this.midSceneStateChangeCallBack();
    }
  }

  /**
   * get top container in mid scene (Note: The waiting add state will also return true)
   *
   * @returns boolean
   */
  public IsTopContainerInMidScene(): boolean {
    let containerSessionList = this.getContainerSessionList();
    let topContainer = containerSessionList.getTopActiveSession();
    if (CommonUtils.isInvalid(topContainer)) {
      return false;
    }
    return topContainer.isMidScene;
  }

  /**
   * register IsPairSplit callBack
   *
   * @param callback
   * @param screenId
   */
  public registerIsPairSplitCallback(callback: Function, screenId: number): void {
    if (callback) {
      log.showInfo(`registerIsPairSplitCallback`);
      this.isPairSplitStateCallbackMap.set(screenId, callback);
    }
  }

  /**
   * unRegister IsPairSplit callBack
   *
   * @param screenId
   */
  public unRegisterIsPairSplitCallback(screenId: number): void {
    log.showInfo(`unRegisterIsPairSplitCallback`);
    screenId = screenId === undefined ? this.mainScreenId : screenId;
    this.isPairSplitStateCallbackMap.delete(screenId);
  }

  /**
   * find if exist pairSplit status scenePanel of all scenePanel
   */
  public getIsAnyScenePanelIsPairSplit(): boolean {
    let existSplitScenePanel: boolean = false;
    this.isPairSplitStateCallbackMap.forEach((callback, screenId) => {
      if (callback && callback()) {
        existSplitScenePanel = true;
      }
    });
    log.showInfo('isAnyScenePanelIsPairSplit: ' + existSplitScenePanel);
    return existSplitScenePanel;
  }

  /**
   * The callbacks clear all animCnt !== 0
   * @param { Number } screenId
   */
  public doClearAllAnimCntCallback(): boolean {
    if (this.recentClearAllAnimCntCallback === null || this.recentClearAllAnimCntCallback === undefined) {
      log.showInfo(`doClearAllAnimCntCallback, recentClearAllAnimCntCallback is null`);
      return false;
    }
    let ret: number = this.recentClearAllAnimCntCallback();
    log.showInfo(`doClearAllAnimCntCallback, ret: ${ret}`);
    return ret !== 0;
  }

  public registerRecentClearAllAnimCntCallback(callback: Function): void {
    this.recentClearAllAnimCntCallback = callback;
  }

  public unRegisterRecentClearAllAnimCntCallback(): void {
    this.recentClearAllAnimCntCallback = undefined;
  }

  /**
   * register isHandleThreeFingerSwiper callBack
   *
   * @param callback
   * @param screenId
   */
  public registerIsHandleThreeFingerSwiperCallback(callback: Function, screenId: number): void {
    if (callback) {
      log.showInfo(`registerIsHandleThreeFingerSwiperCallback`);
      screenId = screenId < 0 ? this.mainScreenId : screenId;
      this.isHandleThreeFingerSwiperCallbackMap.set(screenId, callback);
    }
  }

  /**
   * unRegister isHandleThreeFingerSwiper callBack
   *
   * @param screenId
   */
  public unRegisterIsHandleThreeFingerSwiperCallback(screenId: number): void {
    log.showInfo(`unRegisterIsHandleThreeFingerSwiperCallback`);
    screenId = screenId < 0 ? this.mainScreenId : screenId;
    this.isHandleThreeFingerSwiperCallbackMap.delete(screenId);
  }

  /**
   * get isHandleThreeFingerSwiper status
   */
  public getIsHandleThreeFingerSwiper(): boolean {
    let isHandleThreeFingerSwiper: boolean = false;
    this.isHandleThreeFingerSwiperCallbackMap.forEach((callback, screenId) => {
      if (callback && callback()) {
        isHandleThreeFingerSwiper = true;
      }
    });
    log.showInfo('isHandleThreeFingerSwiper: ' + isHandleThreeFingerSwiper);
    return isHandleThreeFingerSwiper;
  }

  public supportFollowParentWindowLayout(): void {
    sceneSessionManager.supportFollowParentWindowLayout();
  }

  public supportFollowRelativePositionToParent(): void {
    sceneSessionManager.supportFollowRelativePositionToParent();
  }

  public supportZLevel(): void {
    sceneSessionManager.supportZLevel();
  }

  public supportSnapshotAllSessionStatus(): void {
    sceneSessionManager.supportSnapshotAllSessionStatus();
  }

  public supportPreloadStartingWindow(): void {
    sceneSessionManager.supportPreloadStartingWindow();
  }

  public supportCreateFloatWindow(): void {
    try {
      sceneSessionManager.supportCreateFloatWindow();
    } catch (err) {
      log.showError(`[SCBMain]supportCreateFloatWindow failed, err: ${err.code}, errMessage: ${err.message}.`);
    }
  }

  /**
   * @param rotationChangeInfo rotation change info to notify caller
   * @param isRestrictNotify whether to restrict this notification
   * @returns window rect result from caller
   */
  public notifyRotationChange(rotationChangeInfo: sceneSessionManager.RotationChangeInfo,
    isRestrictNotify: boolean = false): Array<sceneSessionManager.RotationChangeResult> | void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[notifyRotationChange] type: ${rotationChangeInfo.type}, ` +
      `orientation: ${rotationChangeInfo.orientation}, displayId: ${rotationChangeInfo.displayId}, ` +
      `rect:[${rotationChangeInfo.displayRect.posX_}, ${rotationChangeInfo.displayRect.posY_}, ` +
      `${rotationChangeInfo.displayRect.width_}, ${rotationChangeInfo.displayRect.height_}], ` +
      `isRestrictNotify: ${isRestrictNotify}`);
    return sceneSessionManager.notifyRotationChange(rotationChangeInfo, isRestrictNotify);
  }

  public getSessionOfTopFullScreenSubSession(screenId: number): SCBSceneContainerSession | null {
    let containerSessionList = this.getContainerSessionList(screenId);
    if (containerSessionList && !containerSessionList.isEmpty()) {
      let topSession: SCBSceneContainerSession | null = containerSessionList.getTopSession();
      let length: number = topSession?.primarySession?.subSessionList.length as number;
      for (let i = length - 1; i >= 0; i--) {
        if (topSession?.primarySession?.subSessionList[i].windowMode === SCBSceneMode.FULLSCREEN) {
          return topSession;
        }
      }
    }
    return null;
  }

  public onRestoreMainWindow(sceneInfo: SCBSceneInfo): void {
    let containerSession = this.getContainerSessionList(sceneInfo.screenId).findByPersistentId(sceneInfo.persistentId);
    log.showInfo(`RestorebundleName: ${sceneInfo.bundleName}, RestorepersistentId: ${sceneInfo.persistentId},
      RestorecontainerSession: ${containerSession?.containerId}, screenId: ${sceneInfo.screenId}`);
    this.startSceneFromRecent(sceneInfo.screenId,
      containerSession?.primarySession?.sceneInfo?.persistentId, containerSession?.containerId);
    this.requestFocus(sceneInfo.persistentId, undefined, FocusChangeReason.MOVE_UP);
  }

  public notifyDockAvoidWindow(persistentId: number, needAvoid?: boolean) {
    if (needAvoid !== undefined && this.existWindowOverlappedByDock(persistentId)) {
      log.showInfo(`exist other window overlaped by dock.`);
      return;
    }
    if (needAvoid === undefined) {
      needAvoid = this.existWindowOverlappedByDock(persistentId);
    }
    if (this.dockAvoidWindowCallback) {
      this.dockAvoidWindowCallback(needAvoid);
    }
  }

  public registerDockAvoidWindowCallback(dockAvoidWindowCallback: Function) {
    this.dockAvoidWindowCallback = dockAvoidWindowCallback;
  }

  public unregisterDockAvoidWindowCallback() {
    this.dockAvoidWindowCallback = undefined;
  }

  /**
   * @param persistentId 传当前窗口id,表示除当前窗口外，是否还有其他窗口，传-1表示不需要过滤当前窗口
   * @returns 是否有窗口与dock重叠
   */
  public existWindowOverlappedByDock(persistentId: number): boolean {
    let containerList = this.getContainerSessionList(this.mainScreenId);
    for (let i = containerList.length - 1; i >= 0 ; i--) {
      let container = containerList[i];
      if (!container || !container.isActive || !container.primarySession) {
        continue;
      }
      if (container.primarySession.sceneInfo.persistentId === persistentId) {
        continue;
      }
      // 全屏或分屏场景，dock栏不显示，不需要处理，返回true
      if (container.isSplit || container.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN ||
        this.getFullScreenSubSessionList().length > 0) {
        return true;
      }
      const dockHeight: number = Math.max(0, ((AppStorage.get('dockHeight') as number) - this.pcModeDockAreaOffsetY));
      let needAvoid: boolean = container.screenProperty.height - vp2px(dockHeight) <
        container.primarySession.currRect.top.getPx() + container.primarySession.currRect.height.getPx();
      if (needAvoid) {
        return true;
      }
      //处理应用子窗
      if (this.existSubAppWindowOverlappedByDock(container, dockHeight, persistentId)) {
        return true;
      }
    }
    return false;
  }

  /**
   * @param persistentId 传当前窗口id,表示除当前窗口外，是否还有其他窗口，传-1表示不需要过滤当前窗口
   * @returns 是否有窗口与dock重叠
   */
  public existSubAppWindowOverlappedByDock(container: SCBSceneContainerSession, dockHeight: number,
    persistentId: number): boolean {
    let subSessionList = container.primarySession.subSessionList;
    for (let i = subSessionList.length - 1; i >= 0 ; i--) {
      let subSession = subSessionList[i];
      if (!subSession || !subSession.isActive || !subSession.visibility ||
        (subSession.session?.type !== sceneSessionManager.SessionType.TYPE_SUB_APP)) {
        continue;
      }
      if (subSession.persistentId === persistentId) {
        continue;
      }
      // 全屏dock栏不显示，不需要处理，返回true
      if (subSession.windowMode === SCBSceneMode.FULLSCREEN) {
        return true;
      }
      let needAvoid: boolean = container.screenProperty.height - vp2px(dockHeight) <
        subSession.currRect.top.getPx() + subSession.currRect.height.getPx();
      if (needAvoid) {
        return true;
      }
    }
    return false;
  }

  public registerAddGestureDockRecentItemCallback(callback: Function): void {
    this.addGestureDockRecentItemCallback = callback;
  }

  public unregisterAddGestureDockRecentItemCallback(): void {
    this.addGestureDockRecentItemCallback = undefined;
  }

  public addGestureDockRecentItem(bundleName?: string, appIndex?: number): void {
    if (this.addGestureDockRecentItemCallback && bundleName && appIndex !== undefined && appIndex > -1) {
      this.addGestureDockRecentItemCallback(bundleName, appIndex);
    }
  }
  
  public setSupportFunctionType(funcType: sceneSessionManager.SupportFunctionType): void {
    sceneSessionManager.setSupportFunctionType(funcType);
  }

  /**
   * notify session manager that window mode has updated
   * @param windowMode the windowMode of corresponding SceneSession
   * @param persistentId the persistentId of the session which will be destructed
   */
  public notifyUpdateWindowMode(windowMode: SCBSceneMode, persistentId: number): void {
    SCBSceneMissionManager.getInstance().notifyUpdateWindowMode(windowMode, persistentId);
  }

  public registerScreenCaptureWarnAnimateToCallbackMap(type: UIEffectZOrderType,
    callback: ScreenCaptureWarnAnimateToCallback): void {
    this.screenCaptureWarnAnimateToCallbackMap.set(type, callback);
  }

  public unregisterScreenCaptureWarnAnimateToCallbackMap(type: UIEffectZOrderType): void {
    this.screenCaptureWarnAnimateToCallbackMap.delete(type);
  }

  public triggerScreenCaptureWarnAnimate(type: UIEffectZOrderType = UIEffectZOrderType.ON_SYSTEM_TOAST): void {
    if (this.screenCaptureWarnAnimateToCallbackMap.has(type)) {
      this.screenCaptureWarnAnimateToCallbackMap.get(type)();
    } else {
      log.showError(`[SCBAnimation] type ${type} ScreenCaptureWarn callback not exist`);
    }
  }

  /**
   * Is in multi window force support list
   *
   * @param bundleName bundle name of app
   * @returns  true: in force support list, otherwise not
   */
  public isInMultiWindowForceSupportList(bundleName: string): boolean {
    if (this.isPcOrPcMode()) {
      return false;
    }
    return this.multiWindowForceSupportMap.has(bundleName);
  }

  /**
   * Is open in multi window force support list
   *
   * @param bundleName bundle name of app
   * @returns true: is open, otherwise not
   */
  public isOpenInMultiWindowForceSupportList(bundleName: string): boolean {
    if (this.isPcOrPcMode()) {
      return false;
    }
    return this.multiWindowForceSupportMap.get(bundleName) ?? false;
  }

  /**
   * Multi window force support map
   *
   * @returns multi window force support map, key is app bundle name, value is open or not
   */
  public get multiWindowForceSupportMap(): Map<string, boolean> {
    return this.multiWindowForceSupportMap_;
  }

  /**
   * init pip autostart switch status
   */
  public initPiPSwitchStatus(): void {
    let autoStartPipStateStr: string = sSettingsUtil.getSystemValue('auto_start_pip_status', 'true', GlobalContext.getContext());
    log.showInfo(`initPiPSwitchStatus: ${autoStartPipStateStr}`);
    let switchStatus: boolean = (autoStartPipStateStr === 'true');
    this.setPiPSwitchStatus(switchStatus);
  }

  /**
   * set pip autostart switch status
   *
   * @param switchStatus the pip autostart switch status
   */
  public setPiPSwitchStatus(switchStatus: boolean): void {
    try {
      sceneSessionManager.setPiPSettingSwitchStatus(switchStatus);
    } catch (err) {
      log.showError('setPiPSwitchStatus failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * register callback for handle scene when pre lock
   *
   * @param screenId screen id
   * @param callback callback
   */
  public registerHandleSceneWhenPreLock(screenId: number, callback: Function): void {
    this.handleWindowWhenPreLockCallbackMap.set(screenId, callback);
  }

  /**
   * unregister callback for handle scene when pre lock
   *
   * @param screenId screen id
   */
  public unregisterHandleSceneWhenPreLock(screenId: number): void {
    this.handleWindowWhenPreLockCallbackMap.delete(screenId);
  }

  /**
   * handle scene when pre lock
   *
   * @returns void
   */
  public handleSceneWhenPreLock(): void {
    for (const callback of this.handleWindowWhenPreLockCallbackMap.values()) {
      callback();
    }
  }

  /**
   * determine whether it is an multi-window in-app mode
   * @param sceneInfo: the infomation of scene
   * @returns true: is multi-window in-app mode, otherwise not
   */
  public isAppMultiWindowMode(sceneInfo: SCBSceneInfo | sceneSessionManager.SceneInfo): boolean {
    let isAppMultiWindow = false;
    if (sceneInfo.want && sceneInfo.want.parameters && sceneInfo.want.parameters[APP_MULTI_WINDOW_KEY]) {
      isAppMultiWindow = Boolean(sceneInfo.want.parameters[APP_MULTI_WINDOW_KEY]);
    }
    return isAppMultiWindow;
  }

  public onStatusBarEnableChange(statusBarEnable: boolean, session: SCBSceneSession){
    log.showInfo(`onStatusBarEnableChange screenId: ${session.sceneInfo.screenId} statusBarEnable: ${statusBarEnable}`);
    this.statusBarEnableCallbacks.get(session.sceneInfo.screenId)?.(statusBarEnable, session.sceneInfo.persistentId);
  }

  public registerStatusBarEnableChange(screenId: number, callback: (enable: boolean, persistentId:number) => void) {
    this.statusBarEnableCallbacks.set(screenId, callback);
  }

  public unregisterStatusBarEnableChange(screenId: number): void {
    this.statusBarEnableCallbacks.delete(screenId);
  }

}

async function fetchAllAbilityInfoSync(userId: number, want: Want): Promise<Array<SCBAbilityItemInfo>> {
  'use concurrent';
  let abilityItemInfoList = await sceneSessionManager.getAllAbilityInfo(want, userId);
  return abilityItemInfoList;
};
