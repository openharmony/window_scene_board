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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import BundleManager from '@ohos.bundle.bundleManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { image } from '@kit.ImageKit';
import sSCBOobeManager from '../../oobe/SCBOobeManager';
import { SCBSceneContainerSession, SCBSceneContainerState } from './SCBSceneContainerSession';
import { AnimateToScheduleUtils, DomainName, HiTraceChain, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { Log } from '@ohos/basicutils';
import { SCBSceneInfo, SCBSceneMode } from './SCBSceneInfo';
import { SCBSceneOrientation } from './SCBSceneOrientation';
import { ScbNumber, SCBSessionRect } from './SCBSessionRect';
import { SCBSessionInfo } from './SCBSessionInfo';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBSpecificSceneSessionList,
  PreferMultiWindowOrientation,
  SCENE_SESSION_NULL_EXCEPTION,
  SessionDisplayChangeReason,
  SessionChangeInfo,
  SessionRectChangeInfo,
  ClassType,
  INVALID_PID
} from './SCBSceneSessionManager';
import type { ExecuteCallbackExtraInfo } from './SCBSceneSessionManager';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { CallToState } from '@ohos/commonconstants';
import { NumberConstants } from '@ohos/commonconstants';
import type { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBFloatingParam } from './SCBFloatingParam';
import { scbGestureManager } from '../../gesturenavigation/SCBGestureManager';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { SCBPropertyChangeReason, SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { SCBSystemSceneSession, SystemBarType, SystemSessionInfo } from './SCBSystemSceneSession';
import { CommonUtils } from '@ohos/basicutils';
import { ObjUtil } from '@ohos/basicutils';
import { SCBScenePanelManager } from '../../scene/manager/SCBScenePanelManager';
import { SceneParam, isLargeFoldProductInExpand } from './SCBDividerParam';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { FocusChangeReason } from '../../common/FocusChangeReason';
import { SCBWindowRaiseReason } from '../../common/SCBWindowRaiseReason';
import { FORM_ID_PARAM } from '../common/SCBSceneConstants';
import { PC_APP_WHITE_LIST, PC_IN_PHONE_LIST } from './SCBTogManager';
import { SCBWindowRotateController } from '../manager/SCBWindowRotateController';
import { ControlType, SCBAppUseControlManager, SCBScreenSession } from '../../TsIndex';
import { FloatingScenePadLayoutStyle } from './SCBFloatingParam';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { SCBSceneMissionManager } from '../manager/SCBSceneMissionManager';
import { effectKit } from '@kit.ArkGraphics2D';
import { MissionManagementTraceUtil, SCBSceneUtils } from '../utils/SCBSceneUtils';
import lazy { SCBSplitUtils } from '../utils/SCBSplitUtils';
import { display } from '@kit.ArkUI';
import { SceneStateCategory } from '../common/SCBSceneEnums';
import { SceneDataCategory, BackgroundReason } from '../common/SCBSceneEnums';
import { ISceneState } from '../framework/sessionstate/ISceneState';
import { ISceneData } from '../framework/sessiondata/ISceneData';
import { SceneStateOfMissionManagement } from '../framework/sessionstate/SceneStateOfMissionManagement';
import { SceneStateOfBasic } from '../framework/sessionstate/SceneStateOfBasic';
import { SceneDataOfBasic } from '../framework/sessiondata/SceneDataOfBasic';
import { SceneDataOfMissionManagement } from '../framework/sessiondata/SceneDataOfMissionManagement';
import { SceneSessionInitializer } from '../framework/strategy/scenestrategy/initstrategy/SceneSessionInitializer';
import { SCBKioskModeManager } from '../kiosk/SCBKioskModeManager';
import { SCBSceneResourceManager } from '../../scene/manager/SCBSceneResourceManager';
import { CommonResult } from '../../scene/utils/SCBSceneUtils';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBSceneSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
// delay to update property
const DELAY_UPDATE_PROPERTY_DURATION = 100;
const BIT_MASK = 0xffff;
const HALF = 2;
const KEYBOARD_ANIMATION_DURATION = 150;
const REPORT_INTERVAL: number = 3600000;
const INVALID_SCREEN_ID: number = -1;
const INVALID_DPI: number = -1;
const DIVIDER_HEIGHT:number = 8;
const LOW_MEMORY_KILL_DELAY_TIMER: number = 5000;
const TOPMOST_SUB_WINDOW_Z_LEVEL: number = 2000;
const MULTI_WINDOW_DEBUG_PARAM_KEY = 'persist.debug.multi_window';
const PIP_AUTO_START_KEY: string = 'auto_start_pip_status';
const METADATA_BLOCK_POWER_KEY = 'block_power_key';
const MAX_LANDSCAPE_MULTI_WINDOW_ANIM = 10;
const BLOCK_POWER_KEY_NO_CACHE = 2;
const BLOCK_POWER_KEY_TRUE = 1;
const BLOCK_POWER_KEY_FAIL = 0;
const DEFAULT_TASK_ID: number = -1;
const ERROR_REASON_LOW_MEMORY_KILL = 'LowMemoryKill';
export const INVALID_PERSISTENT_ID: number = 0;

export enum SCBSessionEventId {
  EVENT_UNDEFINED,
  EVENT_MAXIMIZE = 100,
  EVENT_RECOVER,
  EVENT_MINIMIZE,
  EVENT_CLOSE,
  EVENT_START_MOVE,
  EVENT_END_MOVE,
  EVENT_MAXIMIZE_FLOATING,
  EVENT_TERMINATE,
  EVENT_EXCEPTION,
  EVENT_SPLIT_PRIMARY,
  EVENT_SPLIT_SECONDARY,
  EVENT_DRAG_START,
  EVENT_DRAG,
  EVENT_MAXIMIZE_WITHOUT_ANIMATION,
  EVENT_MAXIMIZE_WATERFALL,
  EVENT_WATERFALL_TO_MAXIMIZE,
  EVENT_MAXIMIZE_FULLSCREEN,
  EVENT_SPLIT_START_MOVE,
  EVENT_SPLIT_SWITCH,
  EVENT_SPLIT_POSITION_RECOVER,
  EVENT_SPLIT_STATE_RESTORATION,
  EVENT_SPLIT_MOVING
};

export enum ActiveReason {
  DEFAULT = 0,
  EXIT_SPLIT = 1,
  RECOVER = 2,
  EXIT_MIDSCENE = 3,
  UNLOCK = 4, // Please do not change its order.
  SWITCH_FREE_WINDOWS_MODE = 5,
}

export enum SessionOperatorType {
  TYPE_DEFAULT = 0,
  TYPE_CLEAR,
}

export enum SCBSessionCbType {
  RECOVER,
  OUTSIDE_DOWN_EVENT,
};

export enum SCBSessionShowInScreenIndex {
  INDEX_NONE = -1,
  INDEX_LEFT = 0,
  INDEX_MIDDLE = 1,
  INDEX_RIGHT = 2
};

export enum WindowDragHotAreaType {
  HOT_AREA_TYPE_INVALID = 0,
  HOT_AREA_TYPT_TOP = 1,
  HOT_AREA_TYPT_LEFT = 1 << 1,
  HOT_AREA_TYPT_RIGHT = 1 << 2,
  HOT_AREA_TYPT_EXIT_SPLIT = 1 << 3,
  HOT_AREA_TYPT_SWITCH_SPLIT = 1 << 4,
  HOT_AREA_TYPT_REDUCE_SPLIT = 1 << 5,
  HOT_AREA_TYPT_LEFT_BOTTOM = 1 << 6,
  HOT_AREA_TYPT_RIGHT_BOTTOM = 1 << 7,
  HOT_AREA_TYPT_C_SIDE_TOP = 1 << 8,
};

export enum SCBStatusBarSettingFlag {
  DEFAULT_SETTING = 0,
  COLOR_SETTING = 1,
  ENABLE_SETTING = 2,
  ALL_SETTING = 3,
  FOLLOW_SETTING = 4
}

export enum SupportModeResultReason {
  DEFAULT,
  KIOSK_MODE,
  PC_MODE,
  PC_IN_PAD,
  PC_IN_PHONE,
  FIXED_SPLIT_RATIO,
  FIXED_MULTI_WIN_ORIENTATION,
  FORCE_SUPPORT,
  DEBUG_MULTI_WINDOW,
  ATOMICSERVICE_SUPPORT
}

export interface SupportModeResult {
  isSupport: boolean,
  reason: SupportModeResultReason
}

@Observed
export class SCBWindowShadowConfig {
  radius: number = 0;
  offsetX: number = 0;
  offsetY: number = 0;
  color: string = '#000000';
}

@Observed
export class SCBWindowStrokeConfig {
  outlineColor: string = '#00000000';
  outlineWidth: number = 0;
}

@Observed
export class SCBInputWindowConfig {
  animationIn: SCBInputAnimationConfig = new SCBInputAnimationConfig();
  animationOut: SCBInputAnimationConfig = new SCBInputAnimationConfig();
}

@Observed
export class SCBInputAnimationConfig {
  curveType: string = 'default';
  ctrlX1: number = 0;
  ctrlY1: number = 0;
  ctrlX2: number = 0;
  ctrlY2: number = 0;
  duration: number = KEYBOARD_ANIMATION_DURATION;
}

@Observed
export class SubWindowAnimationConfig {
  duration: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  curveType: string = SCBConstants.EASE_OUT;
  ctrlX1: number = NumberConstants.CONSTANT_NUMBER_ZERO_POINT_TWO;
  ctrlX2: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  ctrlY1: number = NumberConstants.CONSTANT_NUMBER_ZERO_POINT_TWO;
  ctrlY2: number = NumberConstants.CONSTANT_NUMBER_ONE;
  scaleX: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  scaleY: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  rotationX: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  rotationY: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  rotationZ: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  angle: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  translateX: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  translateY: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  opacity: number = NumberConstants.CONSTANT_NUMBER_ZERO;
}

@Observed
export class SCBSystemBarProperty {
  constructor(
    /** System bar type */
    public type: sceneSessionManager.SessionType = sceneSessionManager.SessionType.TYPE_STATUS_BAR,
    /** System bar enable(visible) */
    public enable: boolean = true,
    /** System bar background color */
    public backgroundcolor: string = '#00FFFFFF',
    /** System bar foreground color */
    public contentcolor: string = '#FF000000',
    /** Whether enable system bar show/hide animation */
    public enableAnimation: boolean = false,
    /** Whether enable system bar show/hide linear gradient */
    public enableLinearGradient: boolean = false,
    /** notify system bar property for the system bar type only */
    public notifyType?: SystemBarType,
  ) {
  }

  /**
   * equals
   *
   * @param other Other system bar properties
   * @returns Boolean value indicates that this property equals the other one
   */
  public equals(other: SCBSystemBarProperty): boolean {
    return Object.keys(this).every((key) => this[key] === other[key]);
  }

  /**
   * clone
   *
   * @returns Cloned SCBSystemBarProperty object
   */
  public clone(): SCBSystemBarProperty {
    return Object.assign(new SCBSystemBarProperty(), this);
  }

  /**
   * toString
   *
   * @returns Readable string of current property
   */
  public toString(): string {
    return JSON.stringify(Object.values(this));
  }
}

/**
 * Stores Scene memory information.
 */
export class SCBSceneMemoryInfo {
  public currRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  public lastRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  public windowMode: SCBSceneMode = SCBSceneMode.UNDEFINED;
  public layoutFullScreen: boolean = false;
  public displayId: number = INVALID_SCREEN_ID;
  public isDragged: boolean = false;
  public lastDpi: number = INVALID_DPI;

  constructor(windowMode: SCBSceneMode, layoutFullScreen: boolean,
    displayId: number, lastDpi: number) {
    this.windowMode = windowMode;
    this.layoutFullScreen = layoutFullScreen;
    this.displayId = displayId;
    this.lastDpi = lastDpi;
  }

  public setSceneMemoryRect(currRect: SCBSessionRect, lastRect: SCBSessionRect): void {
    this.currRect.copyFrom(currRect);
    this.lastRect.copyFrom(lastRect);
  }

  public clearSceneMemoryInfo(): void {
    this.currRect.setRectNum(0, 0, 0, 0);
    this.lastRect.setRectNum(0, 0, 0, 0);
    this.windowMode = SCBSceneMode.UNDEFINED;
    this.layoutFullScreen = false;
    this.displayId = INVALID_SCREEN_ID;
    this.lastDpi = INVALID_DPI;
  }
}

export class SCBSceneSessionData {
  sessionInfo: SCBSessionInfo = new SCBSessionInfo();

  isFocused: boolean = false;
  isMaximizeFloating: boolean = false;
  requestOrientation: SCBSceneOrientation = SCBSceneOrientation.UNSPECIFIED;
  isLastSplit: boolean = false;
  needBackToOneStep: boolean = false;
  currentRotation: number = 0;
  // used for multi minimize
  isClosing: boolean = false;
  systemBarProperty: Map<sceneSessionManager.SessionType, SCBSystemBarProperty> = new Map();
  // used for recover from maximize
  lastRect: SCBSessionRect = new SCBSessionRect();
  lastDpi: number = -1;
  isLastMaximizeInImmersive: boolean = false;
  isNeedUpdateOnSplitRecentView: boolean = false;
  lastWindowMode: number = SCBSceneMode.FLOATING;
  // used for recover when unlock enter in pc mode
  needRecoverWhenUnlock: boolean = false;
  rectBelowScreenLock: SCBSessionRect = new SCBSessionRect();
  windowModeBelowScreenLock: number = SCBSceneMode.FLOATING;
  // Used for AvoidArea judgement bar property update
  _isSystemBarPropertyApplied: boolean = false;
  isSetStatusBarColor: boolean = false;
  isSetStatusBarEnable: boolean = false;
  isFollowAppColorMode: boolean = false;
  isDisplayLand: boolean = false;
  sdkVersion: number = 0;
  isInRecent: boolean = false;
  dragDividerToMaximize: boolean = false;
  // Used for judge is privacy window, including session and its extension session
  isPrivacyWindow: boolean = false;
  isResizeableInCompatibleMode: boolean = true;
  /* 产品创建窗口时，附带的参数 */
  public productExtend?: object;
  // maximize directly, used for throw-slip
  needMaxWithoutAnim: boolean = false;
  // For app lock
  activeReason: ActiveReason = ActiveReason.DEFAULT;
  // the number of running landscape multi window animations
  landscapeMultiWindowAnimCnt: number = 0;
  // whether to prohibit the next call of landscapeMultiWindow
  prohibitLandscapeMultiWindowAnim: boolean = false;
  // whether session is dragging
  isDragging: boolean = false;
  // used for extended screen
  isNotFirstSceneHiddenModeShow: boolean = false;
  // increase when pip window starts
  pipStartCount: number = 0;
  // whether force clean when clear all in recent
  isForceCleanWhenClearAll: boolean = true;
  // used for maximize split recover animation counter
  animCount: number = 0;
  animationProperty: sceneSessionManager.WindowAnimationProperty | undefined = undefined;
  animationOption: sceneSessionManager.WindowAnimationOptions | undefined = undefined;
  // whether use implicit animation in pc
  useImplicitAnimation: boolean = false;
  // 是否连续调用showability
  isAbilityShown: boolean = false;
  // 窗口是否显示过
  sceneSessionEverShown: boolean = false;
  // 应用拉应用动画配置
  startAnimationOptions?: sceneSessionManager.StartAnimationOptions;
  // 应用自定义转场动画配置
  public transitionAnimationConfig =
    new Map<sceneSessionManager.WindowTransitionType, sceneSessionManager.TransitionAnimation>();
  // 窗口拖拽热区类型
  windowDragHotAreaTypeMap: Map<number, number> = new Map();
  isShowAbility: boolean = false;

  // 自由多窗模式下，通过点击最大化按钮/拖拽到最大化热区/快捷键最大化，默认隐藏状态栏和标题栏，全屏显示
  isMaximizeFullScreen: boolean = false;

  onUpdateSessionLabelCallback: Function;
  onUpdateSessionIconCallback: Function;
  createSubSessionCallback: Function; // will deprecated
  createSubSessionCallbacks: Map<number, Function> = new Map(); // callbacks for cross panel or screen
  createDialogCallback: Function;
  createDialogCallbacks: Map<number, Function> = new Map(); // callbacks for cross panel or screen
  sessionTouchableChangeCallback: Function;

  needAvoidCallback: Function;
  keyboardOffsetCallback: Function;
  systemBarPropertyCallback: Function;
  sessionStateChangeCallback: Function;
  updatePiPTemplateInfoCallback: Function;
  sessionShowWhenLockedChangeCallback: Function;
  onUpdateSessionLabelAndIconCallback: Function;
  clickModalWindowOutsideCallback: Function;

  subSessionRaiseToTopCallback: Function | null;
  subSessionRaiseAboveTargetCallback: Function | null;
  subSessionStateChangeCallback: Function | null;
  subSessionZLevelChangeCallback: Function | null;
  onWindowShadowEnableChangeCallback: Function | null;

  public needOpenMenuLater: boolean = false;

  private missionManagementData: SceneDataOfMissionManagement;

  // Used for check preferMultiWindowOrientation is fixed with LANDSCAPE or PORTRAIT
  private isFixedMultiWindowOrientation_: boolean = false;

  get isNewWant() : boolean {
    return this.missionManagementData.isNewWant;
  }

  set isNewWant(isNewWant: boolean) {
    this.missionManagementData.isNewWant = isNewWant;
  }

  get sessionState() : sceneSessionManager.SessionState {
    return this.missionManagementData.sessionState;
  }

  set sessionState(sessionState: sceneSessionManager.SessionState) {
    this.missionManagementData.sessionState = sessionState;
  }

  get isShowWhenLocked() : boolean {
    return this.missionManagementData.isShowWhenLocked;
  }

  set isShowWhenLocked(isShowWhenLocked: boolean) {
    this.missionManagementData.isShowWhenLocked = isShowWhenLocked;
  }

  get isShowAboveKeyguard() : boolean {
    return this.missionManagementData.isShowAboveKeyguard;
  }

  set isShowAboveKeyguard(isShowAboveKeyguard: boolean) {
    this.missionManagementData.isShowAboveKeyguard = isShowAboveKeyguard;
  }

  get isTemporarilyShowWhenLocked() : boolean {
    return this.missionManagementData.isTemporarilyShowWhenLocked;
  }

  set isTemporarilyShowWhenLocked(isTemporarilyShowWhenLocked: boolean) {
    this.missionManagementData.isTemporarilyShowWhenLocked = isTemporarilyShowWhenLocked;
  }

  get isForegrounding() : boolean {
    return this.missionManagementData.isForegrounding;
  }

  set isForegrounding(isForegrounding: boolean) {
    this.missionManagementData.isForegrounding = isForegrounding;
  }

  get foregroundingTimeoutTaskId() : number {
    return this.missionManagementData.foregroundingTimeoutTaskId;
  }

  set foregroundingTimeoutTaskId(foregroundingTimeoutTaskId: number) {
    this.missionManagementData.foregroundingTimeoutTaskId = foregroundingTimeoutTaskId;
  }

  get pendingRemove() : boolean {
    return this.missionManagementData.pendingRemove;
  }

  set pendingRemove(pendingRemove: boolean) {
    this.missionManagementData.pendingRemove = pendingRemove;
  }

  get isPopoutDisappearing(): boolean {
    return this.missionManagementData.isPopoutDisappearing;
  }

  set isPopoutDisappearing(disappearing: boolean) {
    this.missionManagementData.isPopoutDisappearing = disappearing;
  }

  /**
   * get _isActive
   *
   * @returns { Boolean } _isActive
   */
  public get isActive(): boolean {
    return this.missionManagementData.isActive;
  }

  /**
   * setIsActive, only for SCBSceneSession to use
   *
   * @param { Boolean } isActive
   */
  public setIsActive(isActive: boolean): void {
    this.missionManagementData.isActive = isActive;
  }

  /**
   * 初始化sceneSessionData数据
   * @param dataMap
   */
  public initSceneData(dataMap: Map<SceneDataCategory, ISceneData>): void {
    this.missionManagementData =
      dataMap.get(SceneDataCategory.MISSION_MANAGEMENT) as SceneDataOfMissionManagement;
  }

  /**
   * Get isFixedMultiWindowOrientation
   * @returns true: isFixedMultiWindowOrientation, otherwise not
   */
  public get isFixedMultiWindowOrientation(): boolean {
    return this.isFixedMultiWindowOrientation_;
  }

  /**
   * Set isFixedMultiWindowOrientation
   * @param isFixed: boolean
   */
  public set isFixedMultiWindowOrientation(isFixedMultiWindowOrientation: boolean) {
    this.isFixedMultiWindowOrientation_ = isFixedMultiWindowOrientation;
  }
}

class SCBSceneSessionDataInner {
  supportWindowModes: BundleManager.SupportWindowMode[] = [];
  /**
   * Indicates whether the multi-window is being debugged. If true, force app support multi-window mode.
   */
  debugMultiWindow: boolean = false;
  /**
   * Offset X of the WindowScene associated with the session
   */
  windowOffsetX: number = 0;

  /**
   * Offset Y of the WindowScene associated with the session
   */
  windowOffsetY: number = 0;
  lastEventId: SCBSessionEventId = SCBSessionEventId.EVENT_UNDEFINED;

  nativeCacheRefAvailable: boolean = true; // after request destruction and clear cache will be unavailable.

  // process id
  pid: number = INVALID_PID;

  refCount: number = 0;
}

export class SCBWindowMovePointerPosition {
  pointerPosX: number = -1;
  pointerPosY: number = -1;

  public isEmpty(): boolean {
    return this.pointerPosX === -1 || this.pointerPosY === -1;
  }

  public setPointerPos(posX: number, posY: number): void {
    this.pointerPosX = posX;
    this.pointerPosY = posY;
  }
}

@Observed
export class NeedRenderSnapShotAnimConfig {
  animActionId: number = 0;
  animSnapshot: image.PixelMap | undefined = undefined;
  animVisible: boolean = false;
  animSceneAlpha: number = 1;
}

/**
 * Session of a scene.
 */
@Observed
export class SCBSceneSession {
  readonly classType: ClassType = ClassType.SCENE_SESSION;

  private uid: number = 0;
  /**
   * public data of a session,which should not trigger ui flush
   */
  sessionData: SCBSceneSessionData = new SCBSceneSessionData();
  /**
   * private data of a session,which should not exposed to widgets
   */
  private sessionDataInner: SCBSceneSessionDataInner = new SCBSceneSessionDataInner();
  private sessionDisplayChangeCallbacks: Array<Function> = [];

  get getUid(): number {
    return this.uid;
  }

  public setUid(uid: number): void {
    this.uid = uid;
  }

  /*
   only get function only provide to sessionData
   */
  get isActive(): boolean {
    return this.sessionData.isActive;
  }
  get isFocused(): boolean {
    return this.sessionData.isFocused;
  }
  get isNewWant(): boolean {
    return this.sessionData.isNewWant;
  }
  get isShowWhenLocked(): boolean {
    return this.sessionData.isShowWhenLocked;
  }
  get isMaximizeFloating(): boolean {
    return this.sessionData.isMaximizeFloating;
  }
  get isShowAboveKeyguard(): boolean {
    return this.sessionData.isShowAboveKeyguard;
  }
  get requestOrientation(): SCBSceneOrientation {
    return this.sessionData.requestOrientation;
  }
  get pendingRemove(): boolean {
    return this.sessionData.pendingRemove;
  }
  get isLastSplit(): boolean {
    return this.sessionData.isLastSplit;
  }
  get sessionState(): sceneSessionManager.SessionState {
    return this.sessionData.sessionState;
  }
  get needBackToOneStep(): boolean {
    return this.sessionData.needBackToOneStep;
  }
  get systemBarProperty(): Map<sceneSessionManager.SessionType, SCBSystemBarProperty> {
    return this.sessionData.systemBarProperty;
  }
  get currentRotation(): number {
    return this.sessionData.currentRotation;
  }
  get isClosing(): boolean {
    return this.sessionData.isClosing;
  }
  get lastRect(): SCBSessionRect {
    return this.sessionData.lastRect;
  }
  get sessionInfo(): SCBSessionInfo {
    return this.sessionData.sessionInfo;
  }
  get isSetStatusBarColor(): boolean {
    return this.sessionData.isSetStatusBarColor;
  }
  get isSetStatusBarEnable(): boolean {
    return this.sessionData.isSetStatusBarEnable;
  }
  get isFollowAppColorMode(): boolean {
    return this.sessionData.isFollowAppColorMode;
  }
  get isDisplayLand(): boolean {
    return this.sessionData.isDisplayLand;
  }
  get sdkVersion(): number {
    return this.sessionData.sdkVersion;
  }
  get isSystemBarPropertyApplied(): boolean {
    return this.sessionData._isSystemBarPropertyApplied;
  }

  get isTemporarilyShowWhenLocked(): boolean {
    return this.sessionData.isTemporarilyShowWhenLocked;
  }

  get isAvailable(): boolean {
    return this.session != null && this.sessionDataInner.nativeCacheRefAvailable;
  }

  get isResizeableInCompatibleMode(): boolean {
    return this.sessionData.isResizeableInCompatibleMode;
  }

  get needMaxWithoutAnim(): boolean {
    return this.sessionData.needMaxWithoutAnim;
  }

  get pid(): number {
    if (this.sessionDataInner.pid !== INVALID_PID) {
      return this.sessionDataInner.pid;
    }
    try {
      this.sessionDataInner.pid = sceneSessionManager.getWindowPid(this.session.persistentId);
      return this.sessionDataInner.pid;
    } catch (e) {
      log.showError('get window pid failed');
      return INVALID_PID;
    }
  }

  public get width(): ScbNumber {
    return this.getState(SceneStateCategory.BASIC).width;
  }

  public get height(): ScbNumber {
    return this.getState(SceneStateCategory.BASIC).height;
  }

  public get visibility(): boolean {
    return this.getState(SceneStateCategory.BASIC).visibility;
  }

  public set width(w: ScbNumber) {
    this.getState(SceneStateCategory.BASIC).width = w;
  }

  public set height(h: ScbNumber) {
    this.getState(SceneStateCategory.BASIC).height = h;
  }

  public set visibility(v: boolean) {
    this.getState(SceneStateCategory.BASIC).visibility = v;
  }

  get lastUsedTimestamp() : number {
    return this.getData(SceneDataCategory.MISSION_MANAGEMENT).lastUsedTimestamp;
  }

  set lastUsedTimestamp(lastUsedTimestamp: number) {
    this.getData(SceneDataCategory.MISSION_MANAGEMENT).lastUsedTimestamp = lastUsedTimestamp;
  }

  public get supportWindowModes(): BundleManager.SupportWindowMode[] {
    return this.sessionDataInner.supportWindowModes;
  }

  public updateSceneInfo(sceneInfo: SCBSceneInfo): void {
    this.sceneInfo = sceneInfo;
  }

  /**
   * get persistent id of session.
   * @returns id.
   */
  public get persistentId(): number {
    return this.session.persistentId;
  }

  /**
   * get screen id
   * @returns screen id
   */
  public get screenId(): number {
    return this.sceneInfo.screenId;
  }

  isSelected: boolean = false;
  sceneInfo: SCBSceneInfo;
  session: sceneSessionManager.SceneSession;
  isFocusable: boolean = true;
  isTouchable: boolean = true;
  isTopmost: boolean = false;
  isMainWindowTopmost: boolean = false;
  isHideShadow: boolean = false;
  needAvoid: boolean = false;
  statusVisible: boolean = true;
  translateX: number = 0;
  translateY: number = 0;
  positionX: ScbNumber = new ScbNumber();
  positionY: ScbNumber = new ScbNumber();
  // <--------------------------   for compatible mode sclae start   -------------------------->
  private isFirstSetCompatibleScale: boolean = true; // 判断是否为第一次设置缩放比
  private canSavePreCompatibleScale: boolean = true;
  // <--------------------------   for compatible mode sclae end   -------------------------->
  scaleX: number = 1;
  scaleY: number = 1;
  opacity: number = 1.0;
  startWindowMode: number = SCBSceneMode.UNDEFINED;
  attractionVal: number = 0;
  attractionTransX: number = 0;
  attractionTransY: number = 0;
  moveFarthestPointY: number = 0;
  isAttracting: boolean = false;
  // used for multi minimize
  isMinimizing: boolean = false;
  isSessionMoving: boolean = false;
  isSessionDraging: boolean = false;
  isSessionResizeWhenDragEnd: boolean = false;
  isShowSplitResizeMask: boolean = false;
  isBufferAvailable: boolean = false;
  isForegroundInteractive: boolean = true;
  isRightAngle: boolean = false;
  hoverState: boolean = false;
  private layoutFullScreen_: boolean = false;
  defaultDensityEnabled: boolean = false;
  titleHoverShowEnabled: boolean = true;
  dockHoverShowEnabled: boolean = true;
  sceneParam: SceneParam = new SceneParam();
  floatBorderRadius: number = 0;
  shadowConfig: SCBWindowShadowConfig = new SCBWindowShadowConfig();
  strokeConfig: SCBWindowStrokeConfig = new SCBWindowStrokeConfig();
  currRect: SCBSessionRect = new SCBSessionRect();
  defaultRequestOrientation: SCBSceneOrientation = SCBSceneOrientation.UNSPECIFIED;
  isPairSplitScene: boolean = false;
  startMovePointerPos: SCBWindowMovePointerPosition = new SCBWindowMovePointerPosition();
  currMovePointerPos: SCBWindowMovePointerPosition = new SCBWindowMovePointerPosition();
  bufferAvailableCallbackList: Function[] = [];
  frameLayoutFinishCallback: Function | null;
  sessionRectChangeCallbackMap: Map<number, Function> = new Map();

  sessionTitleActionCallbackMap: Map<number, Array<Function>> = new Map();
  sessionIsNeedChangeCallbackMap: Map<number, Function> = new Map();
  windowDragHotAreaCallbackMap: Map<number, Function> = new Map();
  windowMovingCallbackMap: Map<number, Array<Function>> = new Map(); // <displayId, array<callback>>
  splitPartnerMovingCallbackMap: Map<number, Array<Function>> = new Map(); // <displayId, array<callback>>
  private getMaxRectCallbacks: Map<number, Function> = new Map(); // <displayId, callback>
  private isShowUseControlCallbackList: Function[] = [];
  private isActiveCallbackList: Function[] = [];
  private onPrivacyWindowChangedCallback: Function;
  subSessionCacheList: sceneSessionManager.SceneSession[] = [];
  subSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  dialogSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  dialogSessionCacheList: sceneSessionManager.SceneSession[] = [];
  callbackMap: Map<SCBSessionCbType, Function> = new Map();
  // Used for PC start in background
  sessionLabel: string = '';
  updateDragHotAreaAnimConfigCallbackMap: Map<number, Function> = new Map();

  // Used for shutdown animation
  blurRadius: number = 0;
  needDestructedInSplit: boolean = false;

  // Used only for pair on split recent view
  translateOffsetX: number = 0;

  preferMultiWindowOrientation: string = 'default';

  isLandscapeMultiWindow: boolean = false;
  // Used for replacing scene animation
  sceneTranslateX: number = 0;
  maskOpacity: number = 0;
  splitOpacity: number = 0;
  needClip: boolean = false;

  //used for pc app in pad
  isPcAppInPad: boolean = false;
  hasBlockPowerKeyPermission: number = BLOCK_POWER_KEY_NO_CACHE;

  //change support window mode by interface
  isChangedSupportWindowMode: boolean = false;

  //used for scene memory recover
  isRecoveredFullScreen: boolean = false;
  isRecoveredScene: boolean = false;

  // auto start pip window status
  isAutoStartPiP: boolean = false;
  // restore auto start pip status
  restorePiPStatus: boolean = false;
  // whether pip needs to be started when auto start pip is set
  isNeedStartPiP?: boolean = true;
  // start pip window priority
  pipTypePriority: number = 0;
  // auto start pip width
  pipWidth: number = 0;
  // auto start pip height
  pipHeight: number = 0;
  // Indicates whether the back panel should be displayed when in Recent.
  needBackPanelInRecent: boolean = false;

  // used for pc maximize split recover animation
  needRenderSnapShotAnimConfig: NeedRenderSnapShotAnimConfig = new NeedRenderSnapShotAnimConfig();
  animResizeMaskIcon: image.PixelMap | undefined = undefined;
  animResizeMaskOpacity: number = 1;

  // used for modal window
  isModal: boolean = false;

  // used for shadow
  isWindowShadowEnable: boolean = true;

  // app lock
  useControlList: ControlType[] = [];
  controlTypeToControlRecentMap: Map<ControlType, boolean> = new Map();

  useControlSession: SCBSystemSceneSession | null = null;

  isCrossingScreen: boolean = false;

  pcWidth : number = 0;
  pcHeight : number = 0;
  pcTop : number = 0;
  pcLeft : number = 0;

  private stateMap: Map<SceneStateCategory, ISceneState> = new Map();
  private dataMap: Map<SceneDataCategory, ISceneData> = new Map();

  public getState(category: SceneStateCategory.BASIC): SceneStateOfBasic | null;
  public getState(category: SceneStateCategory.MISSION_MANAGEMENT): SceneStateOfMissionManagement | null;
  public getState(category: SceneStateCategory): ISceneState | null {
    const sceneState = this.stateMap.get(category);

    // 运行时类型检查
    switch (category) {
      case SceneStateCategory.BASIC:
        return sceneState as SceneStateOfBasic;
      case SceneStateCategory.MISSION_MANAGEMENT:
        return sceneState as SceneStateOfMissionManagement;
      default:
        return null;
    }
  }

  public getData(category: SceneDataCategory.BASIC): SceneDataOfBasic | null;
  public getData(category: SceneDataCategory.MISSION_MANAGEMENT): SceneDataOfMissionManagement | null;
  public getData(category: SceneDataCategory): ISceneData | null {
    const sceneData = this.dataMap.get(category);
    // 运行时类型检查
    switch (category) {
      case SceneDataCategory.BASIC:
        return sceneData as SceneDataOfBasic;
      case SceneDataCategory.MISSION_MANAGEMENT:
        return sceneData as SceneDataOfMissionManagement;
      default:
        return null;
    }
  }

  /**
   * 获取当前窗口的沉浸式状态或全屏时开关状态，开关打开时，全屏场景切换为类似沉浸式状态
   * @returns 当前窗口的沉浸式状态
   */
  public get layoutFullScreen(): boolean {
    return this.layoutFullScreen_ ||
      ((AppStorage.get<boolean>('isDockAutoHide') || this.sessionData.isMaximizeFullScreen)
        && this.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN);
  }

  public set layoutFullScreen(layoutFullScreen: boolean) {
    this.layoutFullScreen_ = layoutFullScreen;
  }

  /**
   * 获取当前窗口的真实沉浸式状态
   * @returns 当前窗口的真实沉浸式状态
   */
  public getRealLayoutFullScreen(): boolean {
    return this.layoutFullScreen_;
  }

  /**
   * register not UI data of SCBScene
   * @param sceneData
   */
  public registerData(sceneData: ISceneData): void {
    log.showInfo(`SCBSceneSession registerData category:${sceneData.category}.`);
    this.dataMap.set(sceneData.category, sceneData);
  }

  /**
   * register UI state of SCBScene
   * @param sceneState
   */
  public registerState(sceneState: ISceneState): void {
    log.showInfo(`SCBSceneSession registerState category:${sceneState.category}.`);
    this.stateMap.set(sceneState.category, sceneState);
  }

  /**
   * notification when the interaction status changes. true indicates can interact with containers.
   */
  private interactiveStateChangeCallback: (state: boolean) => void;

  public getOverlaySessionCallback: Array<() => SCBSystemSceneSession[]> = [];

  private foregroundCallback?: () => void;

  private sessionFocusedChangeCallback?: (isFocused:boolean) => void;

  private registerSessionLife(): void {
    this.session.on('pendingSceneSessionActivation', (info) => { // need add mode
      let hiTraceChain = new HiTraceChain('PendingSceneSessionActivation');
      hiTraceChain.begin();
      SCBSceneMissionManager.getInstance().setRequestId(info, info.requestId);
      let pendingActivationRet: CommonResult = this.onPendingSceneSessionActivation(info);
      SCBSceneMissionManager.getInstance().resetRequestId(info);
      hiTraceChain.end();
      return pendingActivationRet;
    });

    this.session.on('createSpecificSession', (specificSession) => {
      this.onCreateSpecificSession(specificSession);
    });

    this.session.on('clearSubSession', (subSessionId) => {
      this.onClearSubSession(subSessionId);
    });

    this.session.on('terminateSession', (info) => {
      log.showInfo('on terminateSession');
      const container =
        SCBScenePanelManager.getInstance().getTotalSessionList()?.findByPersistentId(this.session.persistentId);
      if (this.isInSplit() || container?.getState() === SCBSceneContainerState.SPLIT) {
        this.needDestructedInSplit = true;
      }
      const extraInfo: ExecuteCallbackExtraInfo = {
        terminatedByAbility: true,
        isFromTerminateSession: true
      };
      const containerId = undefined;
      SCBSceneSessionManager.getInstance().terminate(this.sceneInfo.screenId, this.session.persistentId,
        containerId, extraInfo);
    });

    this.session.on('terminateSessionNew', (needRestartCaller, needRemoveSession: boolean, isForceClean: boolean) => {
      log.showInfo(`on terminateSessionNew, needRestartCaller: ${needRestartCaller}, ` +
        `needRemoveSession: ${needRemoveSession}, isForceClean: ${isForceClean}`);
      if (this.isInSplit()) {
        this.needDestructedInSplit = true;
      }
      const extraInfo: ExecuteCallbackExtraInfo = {
        terminatedByAbility: true,
        isForceClean: isForceClean
      };
      let containerId = undefined;
      if (needRestartCaller) {
        SCBSceneSessionManager.getInstance().terminate(this.sceneInfo.screenId, this.session.persistentId,
          containerId, extraInfo);
      } else {
        SCBSceneSessionManager.getInstance().close(this.sceneInfo.screenId, this.session.persistentId,
          containerId, needRemoveSession, true, extraInfo);
      }
    });

    this.session.on('sessionException', (info: sceneSessionManager.SceneInfo, exceInfo: sceneSessionManager.ExceptionInfo, startFail: boolean) => {
      log.showInfo(`on sessionException errorReason: ${info?.errorReason}, ` +
        `shouldSkipKillInStartup: ${info?.shouldSkipKillInStartup}, ` +
        `needRemoveSession: ${exceInfo?.needRemoveSession} needClearCallerLink: ${exceInfo?.needClearCallerLink}`);
      let containerId = undefined;
      const extraInfo: ExecuteCallbackExtraInfo = {
        errorReason: info?.errorReason,
        needClearCallerLink: exceInfo?.needClearCallerLink,
        isSessionException: true
      };
      if (this.isStartFailWhenGrayAppIcon(startFail, info)) {
        return;
      }
      if (this.isInSplit()) {
        this.needDestructedInSplit = true;
      }
      this.isAutoStartPiP = false;
      TraceUtil.traceOnce(DomainName.WINDOW, `sessionException errorReason:${info?.errorReason}, ` +
        `shouldSkipKillInStartup: ${info?.shouldSkipKillInStartup}, ` +
        `sessionState:${this.sessionData.sessionState} isActive:${this.isActive}` +
        `isForegrounding: ${this.sessionData.isForegrounding}`);
      if (this.sessionData.isForegrounding &&
        (info?.errorReason === ERROR_REASON_LOW_MEMORY_KILL || info?.shouldSkipKillInStartup)) {
        // 增加超时机制，如果一定时间没有foreground，直接查杀
        log.showWarn(`ignore sessionException, errorReason: ${info?.errorReason}, ` +
          `shouldSkipKillInStartup: ${info?.shouldSkipKillInStartup}, ` +
          `isForegrounding: ${this.sessionData.isForegrounding}`);
        this.triggerForegroundingTimeout(exceInfo?.needRemoveSession, this.sceneInfo, containerId, extraInfo);
        return;
      }
      SCBSceneSessionManager.getInstance().handleSessionException(exceInfo?.needRemoveSession, this.sceneInfo,
        this.session.persistentId, containerId, extraInfo);
    });
  }

  /**
   * check foreground timeout
   *
   * @param { boolean } needRemoveSession
   * @param { SCBSceneInfo } sceneInfo
   * @param { number } containerId
   * @param { ExecuteCallbackExtraInfo } extraInfo
   */
  private triggerForegroundingTimeout(needRemoveSession: boolean, sceneInfo: SCBSceneInfo,
    containerId?: number, extraInfo?: ExecuteCallbackExtraInfo): void {
    this.sessionData.foregroundingTimeoutTaskId = setTimeout(() => {
      if (!this.isForegroundAndActive) {
        log.showWarn(`foreground timeout handleSessionException persistentId: ${this.session.persistentId}`);
        SCBSceneSessionManager.getInstance().handleSessionException(needRemoveSession, this.sceneInfo,
          this.session.persistentId, containerId, extraInfo);
      }
      this.sessionData.foregroundingTimeoutTaskId = DEFAULT_TASK_ID;
    }, LOW_MEMORY_KILL_DELAY_TIMER);
  }

  /**
   * check if app is start fail when gray app icon enable
   *
   * @param { boolean } startFail
   * @param { string | undefined } bundleName
   * @returns true if app is start fail when gray app icon enable
   */
  private isStartFailWhenGrayAppIcon(startFail: boolean,
    itemInfo: { bundleName: string, appIndex?: number }): boolean {
    let isGrayAppIcon = SCBSceneSessionManager.getInstance().isGrayAppIcon(itemInfo);
    log.showInfo('startFail: ' + startFail + ' isGrayAppIcon: ' + isGrayAppIcon);
    if (startFail && isGrayAppIcon) {
      log.showError(`start fail when gray app icon enable`);
      return true;
    }
    return false;
  }

  /**
   * Constructor
   *
   * @param { sceneSessionManager.SceneSession } session
   * @param { SCBSceneInfo } sceneInfo
   */
  constructor(session: sceneSessionManager.SceneSession, sceneInfo: SCBSceneInfo) {
    this.sceneInfo = sceneInfo;
    SceneSessionInitializer.getInstance().init(this);
    this.sessionData.initSceneData(this.dataMap);
    this.session = session;
    try {
      this.sessionData.lastDpi = display.getDisplayByIdSync(this.sceneInfo.screenId).densityDPI;
    } catch (err) {
      log.showError(`get dpi error: ${err?.message}`);
    }
    if (this.sceneInfo.screenId === INVALID_SCREEN_ID) {
      this.sceneInfo.screenId = SCBSceneSessionManager.getInstance().mainScreenId;
    }
    this.startWindowMode = sceneInfo.windowMode;
    let queryKey = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    this.sessionData.requestOrientation = SCBSceneSessionManager.getInstance().getAbilityOrientation(
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    try {
      this.session.setIsPcAppInPad(this.checkIfPcAppInPad());
    } catch (err) {
      log.showError('setIsPcAppInPad failed, reason: ' + JSON.stringify(err));
    }
    this.defaultRequestOrientation = this.sessionData.requestOrientation;
    this.syncDefaultRequestedOrientation(this.defaultRequestOrientation);
    this.sceneInfo.unclearableSession = SCBSceneSessionManager.getInstance().isUnClearFromRecent(
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    this.preferMultiWindowOrientation = SCBSceneSessionManager.getInstance().getPreferMultiWindowOrientation(queryKey);
    log.showInfo('requestOrientation: ' + this.requestOrientation + ' queryKey: ' + queryKey);
    // todo
    this.sessionDataInner.supportWindowModes = this.getSupportWindowModes();
    this.sessionData.sdkVersion = SCBSceneSessionManager.getInstance().getTargetSDKVersion(queryKey);
    this.isFixedMultiWindowOrientation = (this.preferMultiWindowOrientation === PreferMultiWindowOrientation.LANDSCAPE ||
      this.preferMultiWindowOrientation === PreferMultiWindowOrientation.PORTRAIT);
    this.setStartingWindowExitAnimationFlag();
    this.registerSessionLife();

    this.session.on('bufferAvailableChange', (isBufferAvailable, startWindowInvisible) => {
      if (typeof isBufferAvailable !== 'boolean') {
        Log.showError(TAG, 'invalid isBufferAvailable type: ' + typeof isBufferAvailable);
        return;
      }
      if (typeof startWindowInvisible !== 'boolean') {
        Log.showError(TAG, 'invalid startWindowInvisible type: ' + typeof startWindowInvisible);
        return;
      }
      this.onBufferAvailableChange(isBufferAvailable, startWindowInvisible);
    });

    this.session.on('nextFrameLayoutFinish', () => {
      this.onFrameLayoutFinish();
    });

    this.session.on('updateTransitionAnimation', (type, animation) => {
      this.onUpdateTransitionAnimation(type, animation);
    });

    this.session.on('sessionStateChange', (state) => {
      if (typeof state !== 'number') {
        log.showError('invalid state type: ' + typeof state);
        return;
      }
      this.onSessionStateChange(state);
    });

    this.session.on('sessionEvent', (actionId, param) => {
      this.onSessionEvent(actionId, param);
    });

    this.session.on('layoutFullScreenChange', (status:boolean) => {
      log.showInfo('on IsLayoutFullScreenChange:' + status);
      this.layoutFullScreen = status;
    });

    this.session.on('defaultDensityEnabled', (isEnabled: boolean) => {
      log.showInfo('on IsDefaultDensityEnabled:' + isEnabled);
      this.defaultDensityEnabled = isEnabled;
    });

    this.session.on('backPressed', (needMoveToBackground) => {
      if (SCBKioskModeManager.getInstance().shouldIgnoreBackPress(this.session.persistentId)) {
        log.showInfo('kiosk app ignore back press');
        return;
      }

      const screenName: string =
        SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId)?.session.name;
      if (!scbGestureManager.isGestureEnable()) {
        log.showInfo('on backPressed failed gesture is disabled ');
        return;
      }
      log.showInfo('on backPressed to back session needMoveToBackground ' + needMoveToBackground);
      let extraInfo: ExecuteCallbackExtraInfo = {
        errorReason: 'backClose'
      };
      const container = SCBScenePanelManager.getInstance().getTotalSessionList()
        .findByPersistentId(this.session.persistentId);
      if (needMoveToBackground && (!(this.isInSplit() || container?.getState() === SCBSceneContainerState.SPLIT) ||
        SCBSceneSessionManager.getInstance().isPcOrPcMode())) {
        const isFloatScene: boolean = container && container.isFloat;
        SCBSceneSessionManager.getInstance().minimize(this.sceneInfo.screenId, this.session.persistentId,
          undefined, !isFloatScene, extraInfo);
      } else {
        SCBSceneSessionManager.getInstance().terminate(this.sceneInfo.screenId, this.session.persistentId, undefined, extraInfo);
      }
    });

    this.session.on('sessionFocusableChange', (isFocusable) => {
      this.onSessionFocusableChange(isFocusable);
    });

    this.session.on('sessionTopmostChange', (isTopmost) => {
      this.onSessionTopmostChange(isTopmost);
    });

    this.session.on('raiseMainWindowAboveTarget', (targetId: number) => {
      SCBSceneSessionManager.getInstance().raiseMainWindowAboveTarget(this.session.persistentId, targetId);
    });

    this.session.on('sessionTouchableChange', (isTouchable) => {
      this.onSessionTouchableChange(isTouchable);
    });

    this.session.on('clickModalWindowOutside', () => {
      this.onClickModalWindowOutside();
    });

    this.session.on('sessionShowWhenLockedChange', (isShowWhenLocked) => {
      setTimeout(() => {
        this.onSessionShowWhenLockedChange(isShowWhenLocked);
      }, DELAY_UPDATE_PROPERTY_DURATION);
    });

    this.session.on('click', (requestFocus:boolean = true, isClick:boolean = true) => {
      this.onClick(requestFocus, isClick);
    });

    this.session.on('sessionRectChange', (rect, reason, displayId) => {
      this.onSessionRectChange(rect, reason, displayId);
    });

    this.session.on('sessionDisplayIdChange', (displayId) => {
      if (displayId !== undefined && displayId !== -1) {
        this.onSessionDisplayIdChange(displayId);
      } else {
        log.showWarn(`display id invalid, ${displayId}`);
      }
    });

    this.session.on('systemBarPropertyChange', (properties) => {
      properties.forEach((property) => {
        WinLog.showDebug(WinLogDomain.WMS_IMMS, `on prop change, prop:${JSON.stringify(Object.values(property))}`);
        let systemBarProperty = new SCBSystemBarProperty(
          property.type, property.enable, property.backgroundcolor, property.contentcolor, property.enableAnimation);
        this.systemBarProperty.set(systemBarProperty.type, systemBarProperty);
        let settingFlag = property.settingFlag ?? 0;
        if (systemBarProperty.type === sceneSessionManager.SessionType.TYPE_STATUS_BAR) {
          this.setIsSetStatusBarColor((settingFlag & SCBStatusBarSettingFlag.COLOR_SETTING) ===
            SCBStatusBarSettingFlag.COLOR_SETTING);
          this.setStatusBarEnable((settingFlag & SCBStatusBarSettingFlag.ENABLE_SETTING) ===
            SCBStatusBarSettingFlag.ENABLE_SETTING);
          this.setIsFollowAppColorMode((settingFlag & SCBStatusBarSettingFlag.FOLLOW_SETTING) ===
            SCBStatusBarSettingFlag.FOLLOW_SETTING);
          SCBSceneSessionManager.getInstance().onStatusBarEnableChange(systemBarProperty.enable, this);
        }
        if (systemBarProperty.type === sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR &&
          this.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN &&
          this.isSessionForeground()) {
          WinLog.showInfo(WinLogDomain.WMS_IMMS, `win:${this.session.persistentId},AIbar:${systemBarProperty.enable}`);
          SCBSceneSessionManager.getInstance().updateNavigationBarProperty(systemBarProperty.enable, this);
          SCBSceneSessionManager.getInstance()
            .notifyNavigationPropertyChanged(systemBarProperty, this.sceneInfo.screenId);
        }
        if (systemBarProperty.type === sceneSessionManager.SessionType.TYPE_NAVIGATION_BAR &&
        this.isSessionForeground()) {
          SCBSceneSessionManager.getInstance()
            .notifyNavigationPropertyChanged(systemBarProperty, this.sceneInfo.screenId);
        }
      });
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    });

    this.session.on('needAvoid', (status) => {
      WinLog.showDebug(WinLogDomain.WMS_IMMS, `on needAvoid win:${this.session.persistentId}`);
      this.onNeedAvoid(status);
    });

    this.session.on('pendingSessionToForeground', () => {
      log.showInfo('on pendingSessionToForeground');
      SCBSceneSessionManager.getInstance().requestToTop(this.sceneInfo.screenId, this.session.persistentId,
                                                        SCBWindowRaiseReason.PENDING_SESSION);
    });

    this.session.on('pendingSessionToBackground', (sceneInfo: sceneSessionManager.SceneInfo, shouldBackToCaller: boolean,
      record: Record<string, Object>) => {
      log.showInfo(`on pendingSessionToBackground, shouldBackToCaller: ${shouldBackToCaller}`);
      SCBSceneMissionManager.getInstance().pendingSessionToBackground(sceneInfo, shouldBackToCaller, record);
    });

    this.session.on('pendingSessionToBackgroundForDelegator', (sceneInfo: sceneSessionManager.SceneInfo,
      shouldBackToCaller: boolean) => {
      log.showInfo(`on pendingSessionToBackgroundForDelegator, shouldBackToCaller: ${shouldBackToCaller}`);
      let containerSession = SCBSceneSessionManager.getInstance()
        .getSceneContainerSessionFromScenePanel(this.sceneInfo.persistentId) as SCBSceneContainerSession;
      SCBSceneSessionManager.getInstance().requestSceneContainerBackgroundForDelegator(this.sceneInfo.screenId,
        this.session.persistentId, undefined, shouldBackToCaller);
    });

    this.session.on('sessionRequestedOrientationChange', (requestedOrientation, needAnimation)=> {
      SCBSceneSessionManager.getInstance().notifyContainerSessionChangeReqOrientation(
        this.sceneInfo.screenId, requestedOrientation, this.session.persistentId, needAnimation);
    });

    this.session.on('sessionGetTargetOrientationConfigInfo', (targetOrientation)=> {
      SCBSceneSessionManager.getInstance().getTargetRotationProperty(
        this.sceneInfo.screenId, targetOrientation, this.session.persistentId);
    });

    this.session.on('bindDialogTarget', (specificSession: sceneSessionManager.SceneSession) => {
      log.showInfo(`[SCBDialog] on bindDialogTarget  callbacks: ` +
        `${this.sessionData.createDialogCallback ? 'valid' : this.sessionData.createDialogCallbacks.size}`);
      if (this.sessionData.createDialogCallback) {
        this.sessionData.createDialogCallback(specificSession);
      } else if (this.sessionData.createDialogCallbacks.size !== 0) {
        this.sessionData.createDialogCallbacks.forEach((callback) => {
          if (callback) {
            callback(specificSession);
          }
        });
      } else if (!this.dialogSessionCacheList.includes(specificSession)) {
        log.showInfo('[SCBDialog] create dialog callback is null');
        this.dialogSessionCacheList.push(specificSession);
      } else {
        log.showInfo('[SCBDialog] dialogSessionCacheList already include');
      }
      if (!this.isForegroundInteractive) {
        log.showInfo('[SCBDialog] on bindDialogTarget notifyForegroundInteractiveStatus false,id:' +
          specificSession.persistentId);
        SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(specificSession,
          this.isForegroundInteractive);
      }
    });

    this.session.on('windowDragHotArea', (displayId, windowDragHotAreaType, reason, rect) => {
      log.showInfo('on windowDragHotArea, windowDragHotAreaType: ' + windowDragHotAreaType + ' ,reason: ' + reason +
        ' ,rect: ' + rect);
      this.onWindowDragHotArea(windowDragHotAreaType, reason, rect, displayId);
    });

    this.session.on('updateSessionLabel', (label) => {
      this.onUpdateSessionLabel(label);
    });

    this.session.on('updateSessionIcon', (iconPath) => {
      this.onUpdateSessionIcon(iconPath);
    });

    this.session.on('updateSessionLabelAndIcon', (label, icon) => {
      this.onUpdateSessionLabelAndIcon(label, icon);
    });

    this.session.on('landscapeMultiWindow', (isLandscapeMultiWindow) => {
      log.showDebug(`landscapeMultiWindow, isLandscapeMultiWindow: ${isLandscapeMultiWindow}`);
      if (this.sessionData.landscapeMultiWindowAnimCnt >= MAX_LANDSCAPE_MULTI_WINDOW_ANIM ||
        this.sessionData.prohibitLandscapeMultiWindowAnim) {
        log.showWarn(`the number of landscapeMultiWindow animations exceeds the limit, bundle name:
          ${this.sceneInfo?.bundleName}, cnt: ${this.sessionData.landscapeMultiWindowAnimCnt}`);
        return;
      }
      if (isLandscapeMultiWindow !== this.isLandscapeMultiWindow) {
        this.onIsLandscapeMultiWindowChange(isLandscapeMultiWindow);
      }
    });

    this.session.on('autoStartPiP', (status: boolean, priority: number, width: number, height: number) => {
      this.isAutoStartPiP = status;
      this.pipTypePriority = priority;
      this.pipWidth = width;
      this.pipHeight = height;
    });

    this.session.on('updatePiPTemplateInfo', (info: sceneSessionManager.PipTemplateInfo) => {
      this.onUpdatePiPTemplateInfo(info);
    });

    this.session.on('changeSessionVisibilityWithStatusBar',
      (sceneInfo: sceneSessionManager.SceneInfo, visible: boolean): void => {
        this.onChangeSessionVisibilityWithStatusBar(sceneInfo, visible, true);
      });

    this.session.on('privacyModeChange', (isPrivacyWindow: boolean) => {
      this.onPrivacyModeChange(isPrivacyWindow);
    });

    this.session.on('windowMoving', (displayId: number, pointerX: number, pointerY: number) => {
      this.processWindowMoving(displayId, pointerX, pointerY);
    });

    try {
      this.session.on('sessionLockStateChange', (isLocked: boolean) => {
        log.showInfo(`sessionLockStateChange, isLocked:${isLocked}`);
        this.sceneInfo.isUnclearableInRecent = isLocked;
      });
    } catch (err) {
      log.showError('Fail to register session lock state change callback');
    }

    try {
      this.session.on('updateAppUseControl', (type: ControlType, isNeedControl: boolean,
        isControlRecentOnly: boolean) => {
        this.updateAppUseControl(type, isNeedControl, isControlRecentOnly);
      });
    } catch (err) {
      log.showError('[UseControl]Fail to register update app use control callback');
    }

    this.session.on('animateToTargetProperty', (animationProperty: sceneSessionManager.WindowAnimationProperty,
      animationOptions: sceneSessionManager.WindowAnimationOptions)=> {
      this.sessionData.animationProperty = animationProperty;
      this.sessionData.animationOption = animationOptions;
      log.showInfo(`animateToTargetProperty animation targetScale: ${animationProperty?.targetScale},` +
        `options curve: ${animationOptions?.curve},  duration: ${animationOptions?.duration}, ` +
        `param: ${animationOptions?.param?.toString()}`);
      SCBSceneSessionManager.getInstance().doAnimation(this.sceneInfo.screenId, this.session.persistentId);
    });

    this.useControlList = [...SCBAppUseControlManager.getInstance().getControlType(this.sceneInfo.bundleName,
      this.sceneInfo.appIndex)];
    this.controlTypeToControlRecentMap = new Map(SCBAppUseControlManager.getInstance().getControlTypeToControlRecentMap(
      this.sceneInfo.bundleName, this.sceneInfo.appIndex));
    if (this.useControlList.length > 0) {
      this.initUseControlSession();
    }

    this.registerPCOrPadListeners();
    this.registerFreeWindowModeListeners();
    SCBSceneMissionManager.getInstance().cacheNewSceneSession(this);
  }

  public updateSystemStartAnimationBySceneInfo(sceneInfo: SCBSceneInfo) {
    if (sceneInfo.startAnimationSystemOptions &&
      sceneInfo.startAnimationSystemOptions.type === sceneSessionManager.AnimationType.FADE_IN) {
      let config: sceneSessionManager.WindowAnimationOptions = {
        duration: 300,
        curve: sceneSessionManager.WindowAnimationCurve.CUBIC_BEZIER,
        param: [0.4, 0.0, 0.2, 1.0]
      }
      if (sceneInfo.startAnimationSystemOptions.animationConfig) {
        config = sceneInfo.startAnimationSystemOptions.animationConfig;
      }
      let transitionAnimation: sceneSessionManager.TransitionAnimation = {
        config: config,
        opacity: 1.0
      }
      log.showInfo(`[SCBAnimation] start animation option ${JSON.stringify(config)}`);
      this.sessionData.transitionAnimationConfig.set(sceneSessionManager.WindowTransitionType.START,
        transitionAnimation);
    }
  }

  public clearStartCustomAnimation() {
    log.showDebug('[SCBAnimation] clear start animation');
    this.sessionData.transitionAnimationConfig.delete(sceneSessionManager.WindowTransitionType.START);
  }

  private updateAppUseControl(type: ControlType, isNeedControl: boolean, isControlRecentOnly: boolean): void {
    log.showInfo(`[UseControl]Update app use control, id:${this.session.persistentId} type:${type}, ` +
      `isNeedControl:${isNeedControl}, isControlRecentOnly:${isControlRecentOnly}`);
    let index = this.useControlList.indexOf(type);
    const useControlLengthBeforeUpdate: number = this.useControlList.length;
    if (isNeedControl && index === -1) {
      this.useControlList.push(type);
      this.useControlList.sort();
      this.initUseControlSession();
    } else if (!isNeedControl && index >= 0) {
      this.useControlList.splice(index, 1);
      if (this.useControlList.length === 0) {
        this.destroyUseControlSession();
      }
    }
    if (isNeedControl) {
      this.controlTypeToControlRecentMap.set(type, isControlRecentOnly);
    } else {
      this.controlTypeToControlRecentMap.delete(type);
    }
    this.isShowUseControlCallbackList.forEach((callback) => callback && callback(this.useControlList.length > 0));
    const needUpdateShowState: boolean = this.useControlList.length === 0 || useControlLengthBeforeUpdate === 0;
    if (needUpdateShowState && this.isInUseControl() && SCBSceneSessionManager.getInstance().isPc()) {
      SCBSceneSessionManager.getInstance().closePiP(this);
      this.restorePiPStatus = this.isAutoStartPiP;
      this.isAutoStartPiP = false;
    }
    SCBSceneSessionManager.getInstance().getScenePersistent().setHasPrivacyModeControl(
      this.session.persistentId, this.getControlType() === ControlType.PRIVACY_WINDOW);
  }

  private isInUseControl(): boolean {
    return this.useControlList.length > 0 && this.useControlList?.[0] === ControlType.PARENT_CONTROL;
  }

  private initUseControlSession(): void {
    if (this.useControlSession) {
      return;
    }
    log.showInfo(`[UseControl]initUseControlSession ${this.sceneInfo.bundleName} ` +
      `persistentId:${this.sceneInfo?.persistentId}`);
    const sessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: `SCBSceneUseControl${this.persistentId}`,
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
      sceneType:sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
      isRotatable: true,
      mainWindowPersistentId: this.sceneInfo.persistentId,
      screenId: this.sceneInfo.screenId,
      isAppUseControl: true,
    };
    this.useControlSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(sessionInfo, undefined,
      false, this.sceneInfo.screenId);
    this.useControlSession.setVisibility(true);
    this.useControlSession.setSessionTouchable(true);
  }

  private destroyUseControlSession(): void {
    if (this.useControlSession) {
      log.showInfo(`[UseControl]destroyUseControlSession ${this.sceneInfo.bundleName} ` +
        `persistentId:${this.sceneInfo?.persistentId}`);
      SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.useControlSession);
      this.useControlSession = null;
    }
  }

  /**
   * 判断当前管控是否仅多任务管控
   * @returns 是否仅多任务管控
   */
  public isControlRecentOnly(): boolean {
    return this.controlTypeToControlRecentMap?.get(this.getControlType()) ?? false;
  }

  /**
   * 获取当前管控类型
   * @returns 管控类型
   */
  public getControlType(): ControlType {
    return this.useControlList?.[0];
  }

  private registerPCOrPadListeners(): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!(uiType === SCBConstants.UITYPE_PC || uiType === SCBConstants.UITYPE_PAD)) {
      return;
    }

    this.session.on('windowShadowEnableChange', (isWindowShadowEnable: boolean) => {
      this.onWindowShadowEnableChange(isWindowShadowEnable);
    });

    this.session.on('useImplicitAnimationChange', (useImplicitAnimation: boolean) => {
      log.showInfo(`useImplicitAnimationChange ${useImplicitAnimation}`);
      this.sessionData.useImplicitAnimation = useImplicitAnimation;
    });
  }

  private registerFreeWindowModeListeners(): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!(uiType === SCBConstants.UITYPE_PC)) {
      return;
    }

    this.session.on('mainWindowTopmostChange', (isMainWindowTopmost) => {
      this.onSessionMainWindowTopmostChange(isMainWindowTopmost);
    });

    this.session.on('titleAndDockHoverShowChange', (isTitleHoverShowEnabled: boolean, isDockHoverShowEnabled: boolean) => {
      log.showInfo('on IsTitleAndDockHoverShowChange:' + isTitleHoverShowEnabled + ',' + isDockHoverShowEnabled);
      this.titleHoverShowEnabled = isTitleHoverShowEnabled;
      this.dockHoverShowEnabled = isDockHoverShowEnabled;
      if (this.layoutFullScreen) {
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      }
    });

    this.session.on('restoreMainWindow', () => {
      if (this.isPcAppInPad && this.isActive) {
        log.showWarn(`pcAppInPad is active`);
        return;
      }
      SCBSceneSessionManager.getInstance().onRestoreMainWindow(this.sceneInfo);
    });

    this.session.on('setWindowRectAutoSave', (isWindowRectAutoSave: boolean, isEnableSpecified: boolean) => {
      SCBSceneSessionManager.getInstance().
        notifySCBSceneSetWindowRectAutoSave(this.sceneInfo, isWindowRectAutoSave, isEnableSpecified);
      let key: string = this.sceneInfo.bundleName + this.sceneInfo.moduleName + this.sceneInfo.abilityName;
    });

    this.session.on('mainModalTypeChange', (isModal: boolean) => {
      this.onMainSessionModalTypeChange(isModal);
    });
    this.session.on('setSupportWindowModes', (supportWindowModes: Array<BundleManager.SupportWindowMode>) => {
      this.isChangedSupportWindowMode = true;
      this.sessionDataInner.supportWindowModes = supportWindowModes;
      this.sceneInfo.supportWindowModes = supportWindowModes;
    });

    this.session.on('updateFlag', (flag: string) => {
      let specifiedFlag: string = this.sceneInfo.specifiedFlag ?? '';
      if (specifiedFlag.length > 0 ||
         flag === null || flag === undefined) {
          log.showInfo(`updateFlag is done.`);
          return;
      }
      this.sceneInfo.specifiedFlag = flag;
      let sceneSession:SCBSceneSession | null | undefined = SCBSceneSessionManager.getInstance()
        .getContainerSessionList(this.sceneInfo.screenId)
        .findByPersistentId(this.sceneInfo.persistentId)?.primarySession;
      if (sceneSession) {
        SCBSceneSessionManager.getInstance().notifyInitCasePosCallback(sceneSession);
      }
    });
  }

  private setStartingWindowExitAnimationFlag(): void {
    if (!this.session) {
      return;
    }
    if (!DeviceHelper.isWatch() && (!this.sceneInfo || !this.sceneInfo.isPhoneCall())) {
      return;
    }

    try {
      this.session.setStartingWindowExitAnimationFlag(false);
    } catch (error) {
      log.showWarn(`setStartingWindowExitAnimationFlag exception, code: ${error.code}, message: ${error.message}`);
    }
  }

  /**
   * check if app is pc app and run in pad
   * @returns true if is pc app run in pad
   */
  private checkIfPcAppInPad(): boolean {
    let bundleFlags = BundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
    BundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
    let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    let isPad = uiType === SCBConstants.UITYPE_PAD;

    if (!isPad && PC_IN_PHONE_LIST.includes(this.sceneInfo.bundleName)) {
      this.isPcAppInPad = true;
      return true;
    }
    if (!isPad) {
      return false;
    }
    let isPcApp: boolean = false;
    let bundleInfo: BundleManager.BundleInfo;
    try {
      bundleInfo = BundleManager.getBundleInfoSync(this.sceneInfo.bundleName, bundleFlags);
      if (!bundleInfo) {
        return false;
      }
    } catch (err) {
      log.showInfo(`getBundleInfoForSelf failed: ${err}`);
      return false;
    }
    if (bundleInfo.hapModulesInfo[0].deviceTypes.length === 0) {
      return false;
    }
    let isSystemApp: boolean = false;
    try {
      let applicationInfo = BundleManager.getApplicationInfoSync(this.sceneInfo.bundleName, bundleFlags);
      if (applicationInfo) {
        isSystemApp = applicationInfo.systemApp;
      }
    } catch (error) {
      log.showInfo('isPcAppInPad bundleManager.getApplicationInfo error:', error);
    }
    if (isSystemApp) {
      return false;
    }
    for (let device of bundleInfo.hapModulesInfo[0].deviceTypes) {
      if (device === '2in1') {
        isPcApp = true;
      }
      if (device === 'phone') {
        isPcApp = false;
        break;
      }
    }
    if (PC_APP_WHITE_LIST.includes(this.sceneInfo.bundleName)) {
      isPcApp = true;
    }
    log.showInfo(`isPcAppInPad isPcApp: ` + isPcApp);
    this.isPcAppInPad = isPcApp;
    return isPcApp;
  }

  /**
   * 判断当前界面是否有屏蔽power键权限
   *
   */
  public updateShouldBlockPowerKey(): number {
    // Get the host ability metadata asynchronously
    try {
      log.showInfo(`SCBSceneSession queryAbilityInfoSync start, sceneInfo.bundleName: ${this.session.bundleName}`);
      let abilityInfoList = BundleManager.queryAbilityInfoSync(
        { bundleName: this.sceneInfo.bundleName, abilityName: this.sceneInfo.abilityName },
        BundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_METADATA
      );
      return this.updateBlockPowerPersion(abilityInfoList);
    } catch (err) {
      log.showError(`updateShouldBlockPowerKeyAsync bundleManager.queryAbilityInfo error: ${err?.message}`);
      return BLOCK_POWER_KEY_FAIL;
    }
  }

/**
 * 页面级旋转
 * @param rotation
 * @param width
 * @param height
 */
  public notifyRotationProperty(rotation: number, width: number, height: number): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      log.showInfo(`SCBSceneSession notifyRotationProperty begin, persistentId: ${this.session.persistentId}`);
      this.session.notifyRotationProperty(rotation, width, height);
    } catch (err) {
      log.showError('notifyRotationProperty failed, reason: ' + JSON.stringify(err) + ' persistentId: ' + this.session.persistentId);
    }
  }

  private updateBlockPowerPersion(abilityInfoList: Array<BundleManager.AbilityInfo>): number {
    if (!CheckEmptyUtils.isEmptyArr(abilityInfoList)) {
      log.showInfo(`updateBlockPowerPersion start, abilityInfoList[0]: ${abilityInfoList[0].bundleName}`);
      this.hasBlockPowerKeyPermission = !!abilityInfoList[0].metadata.find((v: BundleManager.Metadata) => {
        log.showInfo(`abilityInfo:${abilityInfoList[0].bundleName} ,meta name:${v.name},value:${v.value}`);
        return v.name === METADATA_BLOCK_POWER_KEY && v.value === 'true';
      }) ? BLOCK_POWER_KEY_TRUE : BLOCK_POWER_KEY_FAIL;
      log.showInfo(`shouldBlockPowerKey = ${this.hasBlockPowerKeyPermission}`);
    }
    return this.hasBlockPowerKeyPermission;
  }

  private screenPropertyChangeCallback: Function = (): void => {
    const lastIsDisplayLand = this.isDisplayLand;
    this.updateDisplayLand();
    if (this.isDisplayLand !== lastIsDisplayLand) {
	    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
  };

  private onIsLandscapeMultiWindowChange(isLandscapeMultiWindow: boolean): void {
    this.isLandscapeMultiWindow = isLandscapeMultiWindow;
    SCBSceneSessionManager.getInstance().transitionFloat(this.sceneInfo, this.session.persistentId);
  }

  private onUpdateSessionLabel(label: string): void {
    log.showInfo(`onUpdateSessionLabel`);
    this.sceneInfo.label = label;
    SCBSceneSessionManager.getInstance().getScenePersistent().setSessionLabel(this.sceneInfo.persistentId, label);
    if (this.sessionData.onUpdateSessionLabelCallback) {
      this.sessionData.onUpdateSessionLabelCallback(label);
    } else {
      this.sessionLabel = label;
      log.showInfo(`onUpdateSessionLabelCallback is null, label: ${this.sessionLabel}`);
    }
  }

  private onUpdateSessionIcon(iconPath: string): void {
    if (this.sessionData.onUpdateSessionIconCallback) {
      this.sessionData.onUpdateSessionIconCallback(iconPath);
    }
  }

  private onUpdateSessionLabelAndIcon(label: string, icon: image.PixelMap): void {
    log.showInfo(`onUpdateSessionLabelAndIcon label: ${label} icon: ${!icon}`);
    this.sceneInfo.label = label;
    SCBSceneSessionManager.getInstance().getScenePersistent().setSessionLabel(this.sceneInfo.persistentId, label);
    if (this.sessionData.onUpdateSessionLabelAndIconCallback) {
      this.sessionData.onUpdateSessionLabelAndIconCallback(label, icon);
    }
  }

  /**
   * register on update session label callback
   *
   * @param { Function } callback
   */
  public registerOnUpdateSessionLabelCallback(callback: Function): void {
    log.showInfo('registerOnUpdateSessionLabelCallback');
    this.sessionData.onUpdateSessionLabelCallback = callback;
    // Used for PC start in background
    if (this.sessionLabel != null && this.sessionLabel.length > 0 && this.sessionData.onUpdateSessionLabelCallback) {
      log.showInfo(`onUpdateSessionLabelCallback, label: ${this.sessionLabel}`);
      this.sessionData.onUpdateSessionLabelCallback(this.sessionLabel);
      this.sessionLabel = '';
    }
  }

  /**
   * register on update session icon callback
   *
   * @param { Function } callback
   */
  public registerOnUpdateSessionIconCallback(callback: Function): void {
    log.showInfo('registerOnUpdateSessionIconCallback');
    this.sessionData.onUpdateSessionIconCallback = callback;
  }

  /**
   * unRegister on update session label callback
   */
  public unRegisterOnUpdateSessionLabelCallback(): void {
    this.sessionData.onUpdateSessionLabelCallback = null;
    Log.showDebug(TAG, 'unRegisterOnUpdateSessionLabelCallback');
  }

  /**
   * set Session Touchable
   *
   * @param touchable
   */
  public setSessionTouchable(touchable: boolean): void {
    try {
      if (this.session) {
        this.session.setTouchable(touchable);
      }
    } catch (err) {
      log.showError('setSessionTouchable failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set UseStartingWindowAboveLocked
   *
   * @param useStartingWindowAboveLocked
   */
  public setUseStartingWindowAboveLocked(useStartingWindowAboveLocked: boolean): void {
    try {
      if (this.session) {
        this.session.setUseStartingWindowAboveLocked(useStartingWindowAboveLocked);
        log.showInfo(`setUseStartingWindowAboveLocked: ${useStartingWindowAboveLocked}`);
      }
    } catch (err) {
      log.showError('setUseStartingWindowAboveLocked failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * unRegister on update session icon callback
   */
  public unRegisterOnUpdateSessionIconCallback(): void {
    this.sessionData.onUpdateSessionIconCallback = null;
    Log.showDebug(TAG, 'unRegisterOnUpdateSessionIconCallback');
  }

  /**
   * register on update session label and icon callback
   *
   * @param { Function } callback
   */
  public registerOnUpdateSessionLabelAndIconCallback(callback: Function): void {
    log.showInfo('registerOnUpdateSessionLabelAndIconCallback');
    this.sessionData.onUpdateSessionLabelAndIconCallback = callback;
  }

  /**
   * unRegister on update session label and icon callback
   */
  public unRegisterOnUpdateSessionLabelAndIconCallback(): void {
    this.sessionData.onUpdateSessionLabelAndIconCallback = null;
    Log.showDebug(TAG, 'unRegisterOnUpdateSessionLabelAndIconCallback');
  }

  private onWindowDragHotArea(windowDragHotAreaType: number, reason: sceneSessionManager.SessionSizeChangeReason,
                              rect: sceneSessionManager.SessionRect, displayId: number): void {
    log.showInfo('onWindowDragHotArea');
    for (let [screenId, callback] of this.windowDragHotAreaCallbackMap.entries()) {
      if (screenId === displayId) {
        callback(windowDragHotAreaType, reason, rect);
      } else {
        callback(WindowDragHotAreaType.HOT_AREA_TYPE_INVALID, reason, rect);
      }
    }
  }

  /**
   * register create sub session callback
   *
   * @param callback
   */
  public registerCreateSubSessionCallback(callback: Function, panelId?: number): void {
    log.warn(`registerCreateSubSessionCallback, id: ${this.session?.persistentId}, on panel: ${panelId}`);
    if (panelId) {
      this.sessionData.createSubSessionCallbacks.set(panelId, callback);
    } else {
      this.sessionData.createSubSessionCallback = callback;
    }
    this.subSessionCacheList.forEach((item) => {
      try {
        log.showInfo('[WMSRecover] RecoverSubSession persistentId = ' + item.persistentId);
        callback(this, item);
      } catch (error) {
        log.showWarn(`[WMSRecover] CreateCachedSubSession error, code: ${error.code}, message: ${error.message}`);
      }
    });
    this.subSessionCacheList.length = 0;
  }

  /**
   * register update PiP default window size type callback
   *
   * @param callback
   */
  public registerUpdatePiPTemplateInfoCallback(callback: Function): void {
    log.showInfo(`registerUpdatePiPTemplateInfoCallback, persistentId: ${this.session?.persistentId}`);
    this.sessionData.updatePiPTemplateInfoCallback = callback;
  }

  /**
   * register create dialog callback
   *
   * @param callback
   */
  public registerCreateDialogCallback(callback: Function, panelId?: number): void {
    log.showInfo('[SCBDialog] registerCreateDialogCallback');
    if (panelId) {
      this.sessionData.createDialogCallbacks.set(panelId, callback);
    } else {
      this.sessionData.createDialogCallback = callback;
    }
    this.dialogSessionCacheList.forEach((item) => {
      try {
        log.showInfo('[SCBDialog] RecoverDialog persistentId = ' + item.persistentId);
        callback(item);
      } catch (error) {
        log.showWarn(`[SCBDialog] CreateDialogSession error, code: ${error.code}, message: ${error.message}`);
      }
    });
    this.dialogSessionCacheList.length = 0;
  }

  /**
   * register session rect Change By Timeout Or HotArea when screens dpi change
   *
   * @param callback
   */
  public registerSessionRectChangeByTimeoutOrHotAreaCallback(callback: Function, screenId?: number): void {
    log.showInfo(`registerSessionIsNeedChangeCallback screenId:${screenId}`);
    let screen = screenId !== undefined ? screenId : SCBSceneSessionManager.getInstance().mainScreenId;
    this.sessionIsNeedChangeCallbackMap.set(screen, callback);
  }

  /**
   * register session title action callback
   *
   * @param callback
   */
  public registerSessionTitleActionCallback(callback: Function, screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showInfo(`registerSessionTitleActionCallback, screenId: ${screenId}, ` +
      `persistentId: ${this.sceneInfo?.persistentId}, bundleName: ${this.sceneInfo?.bundleName}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      let callbackArray: Function[] = this.sessionTitleActionCallbackMap.get(screenId);
      const index = callbackArray.indexOf(callback);
      if (index === -1) {
        callbackArray.push(callback);
      }
      log.showDebug(`registerSessionTitleActionCallback length: ${callbackArray.length}`);
      return;
    }
    let callbackArray: Function[] = [];
    callbackArray.push(callback);
    this.sessionTitleActionCallbackMap.set(screenId, callbackArray);
    log.showDebug(`registerSessionTitleActionCallback length: ${callbackArray.length}`);
    if (this.sessionDataInner.lastEventId !== SCBSessionEventId.EVENT_UNDEFINED && callback) {
      callback(this.sessionDataInner.lastEventId, this);
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_UNDEFINED;
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
  }

  /**
   * unregister session title action callback
   *
   * @param screenId
   */
  public unRegisterSessionTitleActionCallback(callback: Function, screenId?: number): void {
    let screen = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showInfo(`unRegisterSessionTitleActionCallback, screenId: ${screen}, ` +
      `persistentId: ${this.sceneInfo?.persistentId}, bundleName: ${this.sceneInfo?.bundleName}`);
    if (!this.sessionTitleActionCallbackMap.has(screen)) {
      return;
    }
    let callbackArray: Function[] = this.sessionTitleActionCallbackMap.get(screen);
    let index = callbackArray.indexOf(callback);
    if (index !== -1) {
      callbackArray.splice(index, 1);
      log.showDebug(`unRegisterSessionTitleActionCallback length: ${callbackArray.length}, screenId: ${screen}`);
    }
    if (callbackArray.length === 0) {
      this.sessionTitleActionCallbackMap.delete(screenId);
      log.showDebug(`unRegisterSessionTitleActionCallback delete map, screenId: ${screen}`);
    }
  }

  /**
   * register session rect change callback
   *
   * @param callback
   */
  public registerSessionRectChangeCallback(callback: Function, screenId?: number): void {
    let screen = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showInfo(`registerSessionRectChangeCallback screenId:${screen}`);
    this.sessionRectChangeCallbackMap.set(screen, callback);
  }

  /**
   * unregister session rect change callback
   */
  public unregisterSessionRectChangeCallback(screenId?: number): void {
    let screen = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    // unregister session rect change callback
    this.sessionRectChangeCallbackMap.delete(screen);
    log.showDebug(`unregisterSessionRectChangeCallback screenId:${screen}`);
  }

  /**
   * register need avoid callback
   *
   * @param { Function } callback
   */
  public registerNeedAvoidCallback(callback: Function): void {
    this.sessionData.needAvoidCallback = callback;
  }

  /**
   * register callback for updating keyboard offset
   *
   * @param { Function } callback
   */
  public registerKeyboardOffsetCallback(callback: Function): void {
    this.sessionData.keyboardOffsetCallback = callback;
  }

  /**
   * update keyboard offset
   */
  public updateKeyboardOffset(): void {
    if (this.sessionData.keyboardOffsetCallback) {
      this.sessionData.keyboardOffsetCallback();
    }
  }

  /**
   * register session touchable change callback
   *
   * @param callback
   */
  public registerSessionTouchableChangeCallback(callback: Function): void {
    log.showInfo('registerSessionTouchableChangeCallback');
    this.sessionData.sessionTouchableChangeCallback = callback;
    if (this.sessionData.sessionTouchableChangeCallback) {
      this.sessionData.sessionTouchableChangeCallback(this.isTouchable);
    }
  }

  /**
   * register click outside the modal window Callback
   *
   * @param callback
   */
  public registerClickModalWindowOutsideCallback(callback: Function): void {
    log.showInfo('registerClickModalWindowOutsideCallback');
    this.sessionData.clickModalWindowOutsideCallback = callback;
  }

  /**
   * register session show when locked change callback
   *
   * @param { Function } callback
   */
  public registerSessionShowWhenLockedChangeCallback(callback: Function): void {
    log.showInfo('registerSessionShowWhenLockedChangeCallback');
    this.sessionData.sessionShowWhenLockedChangeCallback = callback;
  }

  /**
   * unregister session show when locked change callback
   */
  public unregisterSessionShowWhenLockedChangeCallback(): void {
    log.showInfo('unregisterSessionShowWhenLockedChangeCallback');
    this.sessionData.sessionShowWhenLockedChangeCallback = null;
  }

  /**
   * register session system bar property callback
   *
   * @param callback
   */
  public registerSessionSystemBarPropertyCallback(callback: Function): void {
    log.showInfo('registerSessionSystemBarPropertyCallback');
    if (this.sessionData.systemBarPropertyCallback) {
      SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyCallbacks(this.sessionData.systemBarPropertyCallback);
    }
    this.sessionData.systemBarPropertyCallback = callback;
    if (this.sessionData.systemBarPropertyCallback) {
      SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks(this.sessionData.systemBarPropertyCallback);
    }
  }

  /**
   * register window drag hot area callback
   *
   * @param callback
   */
  public registerWindowDragHotAreaCallback(callback: Function, screenId?: number): void {
    log.showInfo(`registerWindowDragHotAreaCallback screenId:${screenId}`);
    let screen = screenId !== undefined ? screenId : SCBSceneSessionManager.getInstance().mainScreenId;
    this.windowDragHotAreaCallbackMap.set(screen, callback);
  }

  /**
   * on
   *
   * @param { SCBSessionCbType } cbType
   * @param { Function } callback
   */
  public on(cbType: SCBSessionCbType, callback: Function): void {
    this.callbackMap.set(cbType, callback);
  }

  /**
   * set whether is focused
   *
   * @param { Boolean } isFocused
   */
  public setFocused(isFocused: boolean): void {
    log.showDebug(`setFocused, persistentId: ${this.session.persistentId} is setFocused: ${isFocused}!`);
    if (this.sessionFocusedChangeCallback) {
      this.sessionFocusedChangeCallback(isFocused);
    }
    if (this.isFocused === isFocused) {
      return;
    }
    if (isFocused && !this.isFocusable) {
      return;
    }
    this.sessionData.isFocused = isFocused;
    this.setWindowShadowConfig();
    this.setWindowStrokeConfig();
  }

  public registerSessionFocusedChangeCallback(callback: (isFocused: boolean) => void): void {
    this.sessionFocusedChangeCallback = callback;
  }

  public unRegisterSessionFocusedChangeCallback(): void {
    this.sessionFocusedChangeCallback = undefined;
  }
  /**
   * set whether is touchable
   *
   * @param { Boolean } isTouchable
   */
  public setTouchable(isTouchable: boolean): void {
    log.showDebug(`persistentId: ${this.session.persistentId} is setTouchable: ${isTouchable}!`);
    this.isTouchable = isTouchable;
  }

  /**
   * set float corner radius config
   */
  public setFloatCornerRadiusConfig(): void {
    if (this.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      log.showDebug('Set float corner radius, windowMode: ' + this.sceneInfo.windowMode);
      return;
    }
    let floatCornerRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    log.showDebug('Set float corner radius, radius: ' + floatCornerRadius);
    if (floatCornerRadius > 0) {
      this.floatBorderRadius = floatCornerRadius;
    }
  }

  /**
   * set window shadow config
   */
  public setWindowShadowConfig(colorMode?: number): void {
    if (!(this.sceneInfo.windowMode === SCBSceneMode.FLOATING || (this.isInSplit() && this.isSessionMoving))) {
      log.showDebug('Set window shadow, windowMode: ' + this.sceneInfo.windowMode);
      return;
    }

    if (this.isHideShadow) {
      this.shadowConfig.radius = 0;
      this.shadowConfig.offsetX = 0;
      this.shadowConfig.offsetY = 0;
      return;
    }

    const windowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
    if (!windowSceneConfig) {
      log.showError('setWindowShadowConfig windowSceneConfig is undefined');
      return;
    }
    if (colorMode === undefined) {
      colorMode = GlobalContext.getContext()?.config.colorMode as number;
    }
    const darkFocusedRadius = windowSceneConfig.focusedShadowDark.radius;
    if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK && darkFocusedRadius > 0) {
      if (this.isFocused) {
        log.showInfo('Set window shadow dark, focusedRadius: ' + darkFocusedRadius);
        this.shadowConfig.radius = darkFocusedRadius;
        this.shadowConfig.offsetX = windowSceneConfig.focusedShadowDark.offsetX;
        this.shadowConfig.offsetY = windowSceneConfig.focusedShadowDark.offsetY;
        this.shadowConfig.color = windowSceneConfig.focusedShadowDark.color;
      } else {
        let unfocusedRadius = windowSceneConfig.unfocusedShadowDark.radius;
        log.showDebug('Set window shadow dark, unfocusedRadius: ' + unfocusedRadius);
        if (unfocusedRadius > 0) {
          this.shadowConfig.radius = unfocusedRadius;
          this.shadowConfig.offsetX = windowSceneConfig.unfocusedShadowDark.offsetX;
          this.shadowConfig.offsetY = windowSceneConfig.unfocusedShadowDark.offsetY;
          this.shadowConfig.color = windowSceneConfig.unfocusedShadowDark.color;
        }
      }
    } else {
      if (this.isFocused) {
        let focusedRadius = windowSceneConfig.focusedShadow.radius;
        log.showDebug('Set window shadow, focusedRadius: ' + focusedRadius);
        if (focusedRadius > 0) {
          this.shadowConfig.radius = focusedRadius;
          this.shadowConfig.offsetX = windowSceneConfig.focusedShadow.offsetX;
          this.shadowConfig.offsetY = windowSceneConfig.focusedShadow.offsetY;
          this.shadowConfig.color = windowSceneConfig.focusedShadow.color;
        }
      } else {
        let unfocusedRadius = windowSceneConfig.unfocusedShadow.radius;
        log.showDebug('Set window shadow, unfocusedRadius: ' + unfocusedRadius);
        if (unfocusedRadius > 0) {
          this.shadowConfig.radius = unfocusedRadius;
          this.shadowConfig.offsetX = windowSceneConfig.unfocusedShadow.offsetX;
          this.shadowConfig.offsetY = windowSceneConfig.unfocusedShadow.offsetY;
          this.shadowConfig.color = windowSceneConfig.unfocusedShadow.color;
        }
      }
    }
  }

  /**
   * set window stroke config
   */
  public setWindowStrokeConfig(): void {
    if (!(this.sceneInfo.windowMode === SCBSceneMode.FLOATING || (this.isInSplit() && this.isSessionMoving))) {
      log.showDebug('setWindowStrokeConfig, windowMode: ' + this.sceneInfo.windowMode);
      this.resetWindowStrokeConfig();
      return;
    }
    const currentColorMode = AppStorage.get<number>('currColorMode');
    log.showDebug('setWindowStrokeConfig, currColorMode: ' + currentColorMode + ', persistentId:' + this.sceneInfo.persistentId);
    if (currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.strokeConfig.outlineColor = this.isFocused ? '#4F5053' : '#343739';
      this.strokeConfig.outlineWidth = 1;
    } else {
      this.strokeConfig.outlineColor = this.isFocused ? '#66808080' : '#4D808080';
      this.strokeConfig.outlineWidth = 1;
    }
  }

  /**
   * reset window stroke config
   */
  public resetWindowStrokeConfig(): void {
    this.strokeConfig.outlineColor = '#00000000';
    this.strokeConfig.outlineWidth = 0;
  }

  /**
   * reset window effect
   */
  public resetWindowEffect(): void {
      this.floatBorderRadius = 0;
      this.shadowConfig.radius = 0;
  }

  public setExitSplitOnBackground(isExitSplitOnBackground: boolean, callerFuncName: string): void {
    if (!!this.session) {
      try {
        this.session.setExitSplitOnBackground(isExitSplitOnBackground);
      } catch (error) {
        log.showWarn(`${callerFuncName} setExitSplitOnBackground exception: ${error}`);
      }
    }
  }

  private createToSceneInfo(sceneInfo: sceneSessionManager.SceneInfo): SCBSceneInfo {
    let toSceneInfo = new SCBSceneInfo(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName,
      sceneInfo.appIndex);
    toSceneInfo.screenId = sceneInfo.screenId;
    toSceneInfo.isScreenIdNotSpecified = (sceneInfo.screenId === INVALID_SCREEN_ID);
    toSceneInfo.persistentId = sceneInfo.persistentId;
    toSceneInfo.callerPersistentId = sceneInfo.callerPersistentId;
    toSceneInfo.callerBundleName = sceneInfo.callerBundleName;
    toSceneInfo.callerAbilityName = sceneInfo.callerAbilityName;
    toSceneInfo.callState = sceneInfo.callState;
    toSceneInfo.isAtomicService = sceneInfo.isAtomicService;
    toSceneInfo.atomicServiceInfo = sceneInfo.atomicServiceInfo;
    toSceneInfo.isStartupInstallFree = sceneInfo.isStartupInstallFree;
    toSceneInfo.needClearInNotShowRecent = sceneInfo.needClearInNotShowRecent;
    let isAppMultiWindow = SCBSceneSessionManager.getInstance().isAppMultiWindowMode(sceneInfo);
    if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN) {
      toSceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      toSceneInfo.fullScreenStart = true;
    } else if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_FLOATING) {
      toSceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    }
    if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY) {
      toSceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    } else if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY || isAppMultiWindow) {
      toSceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
    }
    let isCalledRightlyByCallerId = sceneInfo.isCalledRightlyByCallerId;
    if (isCalledRightlyByCallerId !== undefined && isCalledRightlyByCallerId !== null) {
      toSceneInfo.isCalledRightlyByCallerId = isCalledRightlyByCallerId;
    }
    toSceneInfo.windowWidth = sceneInfo.windowWidth;
    toSceneInfo.windowHeight = sceneInfo.windowHeight;
    toSceneInfo.windowLeft = sceneInfo.windowLeft;
    toSceneInfo.windowTop = sceneInfo.windowTop;
    toSceneInfo.initWindowLimit(sceneInfo.maxWindowWidth, sceneInfo.minWindowWidth, 
                                sceneInfo.maxWindowHeight, sceneInfo.minWindowHeight);
    toSceneInfo.withAnimation = sceneInfo.withAnimation;
    toSceneInfo.focusedOnShow = sceneInfo.focusedOnShow;
    toSceneInfo.isFromIcon = sceneInfo.isFromIcon;
    toSceneInfo.supportWindowModes = sceneInfo.supportWindowModes;
    toSceneInfo.expectWindowMode = sceneInfo.expectWindowMode;
    toSceneInfo.isStartFromAppDock = sceneInfo.isStartFromAppDock;
    toSceneInfo.dockAppDirection = sceneInfo.dockAppDirection;
    toSceneInfo.isAppFromRecentAppsOrDockApps = sceneInfo.isAppFromRecentAppsOrDockApps;
    toSceneInfo.want = sceneInfo.want;
    toSceneInfo.specifiedFlag = sceneInfo.specifiedFlag;
    toSceneInfo.startAnimationSystemOptions = sceneInfo.startAnimationSystemOptions;
    toSceneInfo.startAnimationOptions = sceneInfo.startAnimationOptions;
    toSceneInfo.requestId = sceneInfo.requestId;
    return toSceneInfo;
  }

  private onPendingSceneSessionActivation(sceneInfo: sceneSessionManager.SceneInfo): CommonResult {
    if (!sceneInfo) {
      log.showError('sceneInfo is null');
      return CommonResult.FAIL;
    }
    let toSceneInfo: SCBSceneInfo = this.createToSceneInfo(sceneInfo);
    log.showInfo(`[SCBMain][id:${this.persistentId}][screenId:${this.screenId}] ` +
      `onPendingSessionActivation to: ${toSceneInfo.toJsonString()}`);
    log.showInfo('onPendingSessionActivation callState: ' + toSceneInfo.callState +
      ' startupVisibility: ' + sceneInfo.processOptions?.startupVisibility +
      ' needClearInNotShowRecent: ' + toSceneInfo.needClearInNotShowRecent + ' ' + toSceneInfo.getWindowLimitString() +
      ' deviceTypes: ' + toSceneInfo.atomicServiceInfo?.deviceTypes +
      ' resizable: ' + toSceneInfo.atomicServiceInfo?.resizable + ' supportWindowMode: ' +
      toSceneInfo.atomicServiceInfo?.supportWindowMode);
    log.showInfo(`[SCBMain]onPendingSceneSessionActivation: supportWindowModes ${JSON.stringify(toSceneInfo.supportWindowModes)}}`);
    SCBSceneMissionManager.getInstance().notifySessionPendingActivation(toSceneInfo, this.sceneInfo);
    const managerInstance = SCBSceneSessionManager.getInstance();
    if (managerInstance.onPendingCastScene(sceneInfo, toSceneInfo)) {
      return CommonResult.SUCCESS;
    }
    if (toSceneInfo.screenId !== managerInstance.mainScreenId &&
      managerInstance.hasVirtualScreenStartSceneFunc(toSceneInfo.screenId)) {
        return managerInstance.startSceneInVirtual(toSceneInfo);
    }
    const fromScreenName: string =
      SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId)?.session.name;
    if ((fromScreenName === 'SubScreen' && DeviceHelper.isSmallFoldProduct())) {
      log.showInfo(`fileManagerMode: ${sceneInfo.fileManagerMode}, extraFormIdentity: ${sceneInfo.extraFormIdentity}`);
      ObjUtil.setNested(toSceneInfo, ['want', 'parameters', FORM_ID_PARAM], sceneInfo.extraFormIdentity ?? '');
      return managerInstance.startSceneFromOther(toSceneInfo);
    }
    if (sceneInfo.callState !== CallToState.UNKNOWN) {
      return managerInstance.startSceneByCall(toSceneInfo, this.sceneInfo);
    } else {
      const isPcOrPcMode = managerInstance.isPcOrPcMode();
      const isHiddenStart = sceneInfo.processOptions?.startupVisibility ===
        sceneSessionManager.StartupVisibility.STARTUP_HIDE;
      if ((isPcOrPcMode || this.isPcAppInPad) && isHiddenStart) {
        toSceneInfo.isHide = true;
        return managerInstance.hiddenStartSceneTransition(toSceneInfo, this.sceneInfo);
      }
      if (this.isPcAppInPad) {
        let focusSession = SCBSceneSessionManager.getInstance().getFocusedSceneSession(this.sceneInfo.screenId);
        let focusSceneSession: SCBSceneSession = focusSession === null ? null : focusSession as SCBSceneSession;
        const checkSameBundleName: boolean = focusSceneSession && focusSceneSession.sceneInfo &&
          focusSceneSession.sceneInfo.bundleName === toSceneInfo.bundleName &&
          this.sceneInfo.bundleName === toSceneInfo.bundleName;
        if (checkSameBundleName) {
          return managerInstance.startSceneTransition(toSceneInfo, focusSceneSession.sceneInfo,
            sceneInfo.isBackTransition);
        }
      }
      return managerInstance.startSceneTransition(toSceneInfo, this.sceneInfo, sceneInfo.isBackTransition);
    }
  }

  private onChangeSessionVisibilityWithStatusBar(sceneInfo: sceneSessionManager.SceneInfo,
                                                 visible: boolean, isFromClient: boolean = true): void {
    let toSceneInfo: SCBSceneInfo = this.createToSceneInfo(sceneInfo);
    SCBSceneMissionManager.getInstance().notifySessionVisibilityChange(toSceneInfo, visible, this.sceneInfo);
    SCBSceneSessionManager.getInstance().changeSessionVisWithStatusBarTransition(toSceneInfo, this.sceneInfo,
      visible, isFromClient);
  }

  private traverseSubListToNotifyForeground(subList: SCBSpecificSceneSessionList): void {
    for (let i = subList.length - 1; i >= 0; --i) {
      let subItem = subList[i];
      if (subItem !== null) {
        let subsubSessionList = subItem.subSessionList;
        if (subsubSessionList !== null) {
          this.traverseSubListToNotifyForeground(subsubSessionList);
        }
        SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(subItem.session, true);
      }
    }
  }

  /**
   * request session Activation ByCall to startAbilityByCall
   *
   * @param isNeedToCall
   * @param isToForeground
   */
  public requestSessionActivationByCall(isNeedToCall: boolean, isToForeground : boolean): void {
    this.setIsActive(isToForeground);
    if (isNeedToCall) {
      let activateRes = SCBSceneSessionManager.getInstance().requestSceneSessionByCall(this.session, this.sceneInfo?.requestId);
      if (isToForeground) {
        this.sessionData.isForegrounding = !this.isForegroundAndActive();
      }
      if (activateRes === SCENE_SESSION_NULL_EXCEPTION) {
        this.sessionDataInner.nativeCacheRefAvailable = false;
        this.sessionData.isForegrounding = false;
        this.checkNativeRefAvailability('activate by call exception.');
      }
    }
  }

  /**
   * request session activation
   *
   * @param isNewActive
   * @param isPersist
   */
  public async requestSessionActivation(isNewActive?: boolean, isPersist?: boolean, reason?: ActiveReason,
    containerRotation?: number, containerLastUsedPosition?: string): Promise<void> {
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.ACTIVE_SCENE);
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD ||
    DeviceHelper.isLargeInFoldProduct() || DeviceHelper.isUltraScreenProduct()) {
    }
    log.showInfo(`[SCBMain]requestSceneSessionActivation: isNewActive: ${isNewActive}, isPersist: ${isPersist}, ` +
      `reason: ${reason}, name: ${this.getName()}, containerRotation: ${containerRotation}`);
    this.sessionData.activeReason = reason ?? ActiveReason.DEFAULT;
    this.setIsActive(true);
    this.lastUsedTimestamp = Date.now();

    if (!this.isNeedSessionActivation(reason)) {
      log.showInfo(`[SCBMain]requestSceneSessionActivation: isNeedSessionActivation false`);
      TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.ACTIVE_SCENE);
      return;
    }
    let activateRes = 0;
    if (isNewActive !== undefined) {
      activateRes = SCBSceneSessionManager.getInstance().requestSceneSessionActivation(this.session, isNewActive,
        this.sessionData.isShowAbility, this.sceneInfo?.requestId);
    } else {
      activateRes = SCBSceneSessionManager.getInstance().requestSceneSessionActivation(this.session, true,
        this.sessionData.isShowAbility, this.sceneInfo?.requestId);
    }
    this.sessionData.isShowAbility = false;
    this.sessionData.isForegrounding = !this.isForegroundAndActive();
    if (activateRes === SCENE_SESSION_NULL_EXCEPTION) {
      this.sessionDataInner.nativeCacheRefAvailable = false;
      this.sessionData.isForegrounding = false;
      this.checkNativeRefAvailability('activate exception');
    }
    this.isForegroundInteractive = true;
    for (let i = this.dialogSessionList.length - 1; i >= 0; --i) {
      if (this.dialogSessionList[i] !== null) {
        SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(this.dialogSessionList[i].session, true);
      }
    }
    this.traverseSubListToNotifyForeground(this.subSessionList);
    this.reportActiveWindowNum();
    if (!sSCBOobeManager.isEnable() && (isPersist === undefined || isPersist)) {
      SCBSceneSessionManager.getInstance().getScenePersistent()
        .modifyPersistentMap(this.session.persistentId & BIT_MASK, this.sceneInfo, containerRotation,
          containerLastUsedPosition, this.lastUsedTimestamp);
      if (this.isBufferAvailable) {
        SCBSceneSessionManager.getInstance().getScenePersistent().setSessionAliveStatus(this.session.persistentId,
          true);
      }
    }
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.ACTIVE_SCENE);
  }

  /**
   * set skip input event on cast plus
   *
   * @param isSkip
   */
  public setSkipEventOnCastPlus(isSkip: boolean): void {
    log.showInfo(`set ${this.getName()} setSkipEventOnCastPlus: ${isSkip}`);
    if (!this.session) {
      log.showError(`${this.getName()} session is null`);
      return;
    }
    try {
      this.session.setSkipEventOnCastPlus(isSkip);
    } catch (err) {
      log.showError('setSkipEventOnCastPlus failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set skip self when show on virtual screen
   *
   * @param isSkip
   */
  public setSkipSelfWhenShowOnVirtualScreen(isSkip: boolean): void {
    log.showInfo(`set ${this.getName()} setSkipSelfWhenShowOnVirtualScreen: ${isSkip}`);
    if (!this.session) {
      log.showError(`${this.getName()} session is null`);
      return;
    }
    try {
      this.session.setSkipSelfWhenShowOnVirtualScreen(isSkip);
    } catch (err) {
      log.showError('setSkipSelfWhenShowOnVirtualScreen failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set skip event and show on virtual screen
   *
   * @param isSkip
   */
  public setSkipEventAndShowOnVirtualScreen(isSkip: boolean): void {
    log.showInfo(`set ${this.getName} setSkipEventAndShowOnVirtualScreen: ${isSkip}`);
    try {
      this.session.setSkipEventOnCastPlus(isSkip);
      this.session.setSkipSelfWhenShowOnVirtualScreen(isSkip);
    } catch (err) {
      log.showError('setSkipEventAndShowOnVirtualScreen failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * whether sessionState is STATE_FOREGROUND and isActive is true
   *
   * @returns if sessionState is STATE_FOREGROUND and isActive is true, will return true
   */
  public isForegroundAndActive(): boolean {
    log.showInfo(`[SCBMain]isForegroundAndActive: sessionState: ${this.sessionData.sessionState}, ` +
      `isActive: ${this.isActive}`);
    return this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND &&
    this.isActive;
  }

  /**
   * isNeed to request SessionActivation
   *
   * @param reason reason is reason of requestActivation
   * @returns if need to request SessionActivation by reason, will return true
   */
  private isNeedSessionActivation(reason: ActiveReason): boolean {
    if (!reason) {
      return true;
    }
    if ((reason === ActiveReason.EXIT_SPLIT) || (reason === ActiveReason.RECOVER) ||
      (reason === ActiveReason.EXIT_MIDSCENE) || (reason === ActiveReason.SWITCH_FREE_WINDOWS_MODE)) {
      return false;
    }
    return true;
  }

  /**
   * update persistent map
   */
  public updatePersistentMap(): void {
    SCBSceneSessionManager.getInstance().getScenePersistent().modifyPersistentMap(this.session.persistentId & BIT_MASK, this.sceneInfo);
  }

  /**
   * request Session Background
   *
   * @param { Boolean } isDelegator
   * @param { Boolean } isToDeskTop
   * @param { Boolean } isSaveSnapshot
   * @returns { Promise<void> }
   */
  public async requestSessionBackground(isDelegator?: boolean, isToDeskTop?: boolean, isSaveSnapshot?: boolean,
    backgroundReason: BackgroundReason = BackgroundReason.DEFAULT): Promise<void> {
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.BACKGROUND_SCENE);
    log.showInfo('[SCBMain]requestSceneSessionBackground: name: ' + this.getName());
    this.setIsActive(false);
    this.sessionData.isForegrounding = false;
    SCBSceneSessionManager.getInstance().requestSceneSessionBackground(this.session, isDelegator, isToDeskTop,
      isSaveSnapshot, backgroundReason);
    this.reportActiveWindowNum();
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.BACKGROUND_SCENE);
  }

  /**
   * request Change UI Ability Visibility By SCB
   *
   * @param visibility
   */
  public requestChangeUIAbilityVisibilityBySCB(visibility: boolean, isFromClient?: boolean, isNewWant?: boolean): void {
    SCBSceneSessionManager.getInstance().requestChangeUIAbilityVisibilityBySCB(this.session,
      visibility, isFromClient, isNewWant);
  }

  private reportActiveWindowNum(): void {
    let curTime = new Date().getTime();
    let timePeriod = 0;
    let startTime = SCBSceneSessionManager.getInstance().getRecordStartTime();
    if (startTime === 0) {
      SCBSceneSessionManager.getInstance().updateRecordStartTime(curTime);
    } else {
      timePeriod = curTime - startTime;
    }
    if (timePeriod > REPORT_INTERVAL) {
      let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
      let activeNum = 0;
      containerSessionList.forEach((item) => {
        if (item.isActive) {
          activeNum++;
        }
      });
      SCBSceneSessionManager.getInstance().updateRecordStartTime(curTime);
      HiSysEventUtil.reportCurrentWindowNum(activeNum);
    }
  }

  public traverseSubListToNotifyForegroundInteractiveStatus(subList: SCBSpecificSceneSessionList,
    interactive: boolean): void {
    if (!subList) {
      return;
    }
    subList.forEach((item)=> {
      this.traverseSubListToNotifyForegroundInteractiveStatus(item.subSessionList, interactive);
      SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(item.session, interactive);
    });
  }

  /**
   * notify Foreground Interactive Status
   *
   * @param { Boolean } interactive
   * @returns { Promise<void> }
   */
  public async notifyForegroundInteractiveStatus(interactive: boolean): Promise<void> {
    if (this.isActive && this.session) {
      this.isForegroundInteractive = interactive;
      SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(this.session, interactive);
      this.traverseSubListToNotifyForegroundInteractiveStatus(this.subSessionList, interactive);

      this.dialogSessionList.forEach((item)=> {
        SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(item.session, interactive);
      });
    }
  }

  /**
   * clear Session Data
   */
  public clearSessionData(): void {
    let queryKey = this.sceneInfo.bundleName + this.sceneInfo.moduleName + this.sceneInfo.abilityName;
    this.sessionData.requestOrientation = SCBSceneSessionManager.getInstance().getAbilityOrientation(
      this.sceneInfo.bundleName, this.sceneInfo.moduleName, this.sceneInfo.abilityName);
    log.showInfo('clearSessionData requestOrientation: ' + this.requestOrientation + ' queryKey: ' + queryKey);
    this.sessionData.currentRotation = 0;
  }

  public clearImmersiveData(): void {
    log.showInfo(`clear immersive session data ${this.session.persistentId}`);
    // 清理沉浸式相关持久化信息
    if (this.systemBarProperty.size > 0) {
      // 应用配置过bar property信息 清空配置
      this.systemBarProperty.clear();
    }

    this.sessionData._isSystemBarPropertyApplied = false;
    this.sessionData.isSetStatusBarColor = false;
    this.sessionData.isSetStatusBarEnable = false;
  }

  /**
   * set whether is clear Session
   *
   * @param isClearSession
   */
  public setIsClearSession(isClearSession: boolean): void {
    this.sceneInfo.isClearSession = isClearSession;
  }

  private initSessionParam(): void {
    this.systemBarProperty.clear();
    this.lastUsedTimestamp = 0;

    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!(uiType === SCBConstants.UITYPE_PHONE || uiType === SCBConstants.UITYPE_PAD)) {
      this.systemBarProperty.set(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
        new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, true, '#00FFFFFF', '#FF000000'));
      WinLog.showInfo(WinLogDomain.WMS_IMMS, 'set init system status bar property');
    }
  }

  /**
   * request Session Destruction
   *
   * @param { Boolean } isDeletePersistentMap
   * @param { Boolean } isSaveSnapshot
   * @param { Boolean } isForceClean
   * @param { Boolean } isUserRequestedExit
   * @returns { Promise<void> }
   */
  public async requestSessionDestruction(isDeletePersistentMap: boolean,
    isSaveSnapshot?: boolean, isForceClean?: boolean, isUserRequestedExit?: boolean): Promise<void> {
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.DESTRUCT_SCENE);
    log.showInfo(`[SCBMain]requestSceneSessionDestruction name: ${this.getName()} ` +
      `isDeletePersistentMap: ${isDeletePersistentMap} isSaveSnapshot: ${isSaveSnapshot} ` +
      `isForceClean: ${isForceClean}`);
    this.setIsActive(false);
    this.sessionData.isForegrounding = false;
    this.initSessionParam();

    // set session operatorType clear if the isClearSession is true
    if (this.sceneInfo.isClearSession) {
      this.session.operatorType = SessionOperatorType.TYPE_CLEAR;
    }
    let destructRes = SCBSceneSessionManager.getInstance().requestSceneSessionDestruction(this.session,
      isDeletePersistentMap, isSaveSnapshot, isForceClean, isUserRequestedExit);
    if (destructRes === SCENE_SESSION_NULL_EXCEPTION || isDeletePersistentMap) {
      this.sessionDataInner.nativeCacheRefAvailable = false;
      this.checkNativeRefAvailability('destruction exception or force delete cache');
    }
    if (isDeletePersistentMap) {
      SCBSceneSessionManager.getInstance().getScenePersistent().deletePersistentMapElement(this.session.persistentId & BIT_MASK);
    } else {
      SCBSceneSessionManager.getInstance().getScenePersistent().setSessionAliveStatus(this.session.persistentId, false);
      SCBSceneSessionManager.getInstance().getScenePersistent().setLastUsedTimestamp(this.session.persistentId, 0);
    }
    SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyCallbacks(this.sessionData.systemBarPropertyCallback);
    this.clearImmersiveData();
    SCBSceneResourceManager.getInstance().clearSceneCache(this.session.persistentId);
    SCBSceneSessionManager.getInstance().clearSessionLabelListenerByPersistentId(this.session.persistentId);
    SCBSceneSessionManager.getInstance().clearSessionIconListenerByPersistentId(String(this.session.persistentId));
    this.destroyUseControlSession();
    TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.DESTRUCT_SCENE);
    SCBSceneMissionManager.getInstance().notifySessionRequestDestruction(this.session.persistentId);
  }

  /**
   * set Size
   *
   * @param width
   * @param height
   */
  public setSize(width: ScbNumber, height: ScbNumber): void {
    this.setSizeNum(width.getPx(), height.getPx());
  }

  /**
   * set Position
   *
   * @param positionX
   * @param positionY
   */
  public setPos(positionX: ScbNumber, positionY: ScbNumber): void {
    this.setPosNum(positionX.getPx(), positionY.getPx());
  }

  /**
   * set Size Number
   *
   * @param {Number} width
   * @param {Number} height
   */
  public setSizeNum(width: number, height: number): void {
    this.width = new ScbNumber(width);
    this.height = new ScbNumber(height);
  }

  /**
   * set Position Number
   *
   * @param { Number } posX
   * @param { Number } posY
   */
  public setPosNum(posX: number, posY: number): void {
    this.positionX = new ScbNumber(posX);
    this.positionY = new ScbNumber(posY);
  }

  /**
   * set Translate
   *
   * @param tranX
   * @param tranY
   */
  public setTran(tranX: number, tranY: number): void {
    this.translateX = tranX;
    this.translateY = tranY;
  }

  /**
   * init Scene State
   */
  public initSceneState(): void {
    this.setTran(0, 0);
    this.setScale(1, 1);
    this.opacity = 1.0;
    this.attractionVal = 0;
  }

  /**
   * set Scale
   *
   * @param { Number } scaleX
   * @param { Number } scaleY
   */
  public setScale(scaleX: number, scaleY: number): void {
    this.scaleX = scaleX;
    this.scaleY = scaleY;
  }

  public setCanSavePreCompatibleScale(enable: boolean): void {
    this.canSavePreCompatibleScale = enable;
  }

  // 适用场景：进入多任务的时候，需要此状态保证同一时刻点击最大化/恢复按钮不重新设置当前窗口的缩放比
  public setIsInRecent(enable: boolean): void {
    this.sessionData.isInRecent = enable;
  }

  // 适用场景：进入多任务的时候，需要此状态保证同一时刻点击最大化/恢复按钮不重新设置当前窗口的缩放比
  public getIsInRecent(): boolean {
    return this.sessionData.isInRecent;
  }

  public setScaleX(scaleX: number): void {
    this.scaleX = scaleX;
  }

  public setScaleY(scaleY: number): void {
    this.scaleY = scaleY;
  }

  /**
   * save Last Rect
   */
  public saveLastRect(): void {
    log.showInfo('saveLastRect windowMode: ' + this.sceneInfo.windowMode + ' id: ' + this.session.persistentId);
    this.lastRect.setRect(this.currRect.left, this.currRect.top, this.currRect.width, this.currRect.height);
  }

  public saveSessionMovingState(state: boolean): void {
    log.showInfo('save session move state: ' + state + ' id: ' + this.session.persistentId);
    this.isSessionMoving = state;
  }

  /**
   * save main session draging state
   */
  public saveSessionDragingState(state: boolean): void {
    log.showInfo('save session draging state: ' + state + ' id: ' + this.session.persistentId);
    this.isSessionDraging = state;
  }

  private doSessionTitleActionCallback(screenId: number, eventId: SCBSessionEventId,
    param?: sceneSessionManager.SessionEventParam): void {
    let callbackArray: Function[] = this.sessionTitleActionCallbackMap.get(screenId);
    if (callbackArray && callbackArray.length > 0) {
      callbackArray.forEach((callback: Function) => {
        if (callback) {
          callback(eventId, param);
        }
      });
    }
  }

  /**
   * maximize
   */
  public maximize(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`maximize, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    this.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_MAXIMIZE);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_MAXIMIZE;
    }
  }

  /**
   * maximize fullscreen
   */
  public maximizeFullScreen(needNotify: boolean): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`maximizeFullScreen, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    this.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    try {
      this.sessionData.isMaximizeFullScreen = true;
      sceneSessionManager.setMaximizeFullScreen(this.session.persistentId, true);
    } catch (err) {
      log.showError(`setMaximizeFullScreen failed, error: ${err?.message}`);
      return;
    }
    if (needNotify) {
      if (this.sessionTitleActionCallbackMap.has(screenId)) {
        this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_MAXIMIZE_FULLSCREEN);
      } else {
        this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_MAXIMIZE_FULLSCREEN;
      }
    }
  }

  /**
   * maximize Floating
   */
  public maximizeFloating(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`maximizeFloating, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    this.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_MAXIMIZE_FLOATING);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_MAXIMIZE_FLOATING;
    }

  }

  /**
   * reset lastEventId to undefined
   */
  public resetLastEventId(): void {
    this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_UNDEFINED;
  }

  /**
   * init Floating Scene On Transfer Session
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { Boolean } needUpdateWindowMode
   */
  public initFloatingSceneOnTransferSession(screenProperty: SCBScreenProperty, needUpdateWindowMode: boolean = true): void {
    this.updateFloatingScale(1.0);
    this.floatBorderRadius = 0;
    this.translateX = 0;
    this.translateY = 0;
    this.positionX = new ScbNumber(0);
    this.positionY = new ScbNumber(0);
    this.visibility = true;
    this.opacity = 1;
    this.scaleX = 1;
    this.scaleY = 1;
    if (needUpdateWindowMode) {
      this.width = new ScbNumber(screenProperty.width);
      this.height = new ScbNumber(screenProperty.height);
      this.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    }
  }

  /**
   * split Primary
   */
  public splitPrimary(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`splitPrimary, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_SPLIT_PRIMARY);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_SPLIT_PRIMARY;
    }
  }

  /**
   * split Secondary
   */
  public splitSecondary(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`splitSecondary, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_SPLIT_SECONDARY);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_SPLIT_SECONDARY;
    }
  }

  /**
   * recover
   */
  public recover(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`recover, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}, isSupportFloatingMode: ${this.isSupportFloatingMode()}, ` +
      `isSupportFullScreenMode: ${this.isSupportFullScreenMode()}`);
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!this.isSupportFloatingMode() && this.isSupportFullScreenMode() &&
        !(uiType === SCBConstants.UITYPE_PC)) {
      this.maximize();
      return;
    }
    this.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_RECOVER);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_RECOVER;
    }
  }

  public splitSwitch(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`splitSwitch, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_SPLIT_SWITCH);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_SPLIT_SWITCH;
    }
  }

  public splitPositionRecover(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`splitPositionRecover, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_SPLIT_POSITION_RECOVER);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_SPLIT_POSITION_RECOVER;
    }
  }

  public splitStateRestoration(): void {
    let screenId = this.sceneInfo.screenId;
    log.showInfo(`splitStateRestoration, screenId: ${screenId}, persistentId: ${this.sceneInfo?.persistentId}, ` +
      `bundleName: ${this.sceneInfo?.bundleName}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      this.doSessionTitleActionCallback(screenId, SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION);
    } else {
      this.sessionDataInner.lastEventId = SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION;
    }
  }

  public onSplitPartnerMoving(): void {
    const callbackArray: Function[] = this.splitPartnerMovingCallbackMap.get(this.sceneInfo.screenId);
    if (!callbackArray || callbackArray.length === 0) {
      return;
    }
    const callback = callbackArray[callbackArray.length - 1];
    if (callback) {
      callback();
    }
  }

  public setStartMovePointerPosition(pointerPosition: SCBWindowMovePointerPosition): void {
    this.startMovePointerPos = pointerPosition;
  }

  /**
   * set ZOrder
   *
   * @param { Number } zOrder
   */
  public setZOrder(zOrder: number): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    if (this.sessionInfo.zOrder !== zOrder) {
      this.sessionInfo.zOrder = zOrder;
      try {
        this.session.setZOrder(zOrder);
      } catch (err) {
        log.showError('setZOrder failed, reason: ' + JSON.stringify(err));
      }
    }
  }

  /**
   * Set whether need sync session rect
   * @param needSync
   */
  public setNeedSyncSessionRect(isNeed: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.setNeedSyncSessionRect(isNeed);
      this.subSessionList.forEach((item) => {
        item.session.setNeedSyncSessionRect(isNeed);
      });
      this.dialogSessionList.forEach((item) => {
        item.session.setNeedSyncSessionRect(isNeed);
      });
    } catch (err) {
      log.showError('setSubSessionNeedSyncSessionRect failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set isTemporarilyShowWhenLocked
   *
   * @param isTemporarilyShowWhenLocked : app pull Temporary flag
   */
  public setTemporarilyShowWhenLocked(isTemporarilyShowWhenLocked: boolean): void {
    let currentValue = this.isTemporarilyShowWhenLocked;
    if (currentValue === isTemporarilyShowWhenLocked) {
      log.showInfo('[WMSMain]isTemporarilyShowWhenLocked is not changed, currentValue:' + currentValue);
      return;
    }
    try {
      this.session.setTemporarilyShowWhenLocked(isTemporarilyShowWhenLocked);
      this.sessionData.isTemporarilyShowWhenLocked = isTemporarilyShowWhenLocked;
    } catch (err) {
      log.showError('[WMSMain]setTemporarilyShowWhenLocked failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set whether Is Closing
   *
   * @param { Boolean } isClosing
   */
  public setIsClosing(isClosing: boolean): void {
    this.sessionData.isClosing = isClosing;
  }

  /**
   * set buffer available callback function
   *
   * @param { Function | null } callback
   */
  public setBufferAvailableCallback(callback: Function): void {
    log.showInfo(`setBufferAvailableCallback id: ${this.session?.persistentId}, ` +
      `isBufferAvailable: ${this.isBufferAvailable}`);
    if (this.isBufferAvailable && !!callback) {
      callback();
    } else {
      this.bufferAvailableCallbackList.push(callback);
    }
  }

  private onCreateSpecificSession(specificSession: sceneSessionManager.SceneSession): void {
    log.showInfo(`onCreateSpecificSession, callbacks: ` +
      `${this.sessionData.createSubSessionCallback ? 'valid' : this.sessionData.createSubSessionCallbacks.size}`);
    specificSession.subWindowAppModalType = specificSession.subWindowModalType;
    if (!this.sessionData.createSubSessionCallback && this.sessionData.createSubSessionCallbacks.size === 0) {
      log.showInfo('[WMSRecover] createSubSessionCallback is null, cache it, persistentId = ' +
        specificSession.persistentId);
      if (!this.subSessionCacheList.includes(specificSession)) {
        this.subSessionCacheList.push(specificSession);
      }
      return;
    }

    if (this.sessionData.createSubSessionCallback) {
      this.sessionData.createSubSessionCallback(this, specificSession);
    } else if (this.sessionData.createSubSessionCallbacks.size !== 0) {
      this.sessionData.createSubSessionCallbacks.forEach((callback, screenId) => {
        if (callback) {
          callback(this, specificSession);
        }
      });
    }
    if (!this.isForegroundInteractive) {
      log.showInfo('[WMSRecover] onCreateSpecificSession notifyForegroundInteractiveStatus false, id:' +
        specificSession.persistentId);
      SCBSceneSessionManager.getInstance().notifyForegroundInteractiveStatus(specificSession,
        this.isForegroundInteractive);
    }
  }

  private onClearSubSession(subSessionId: number): void {
    log.showInfo('onClearSubSession');
    if (this.subSessionCacheList.length > 0) {
      let index = this.subSessionCacheList.findIndex(subSession => subSession.persistentId === subSessionId);
      if (index !== -1) {
        this.subSessionCacheList.splice(index, 1);
      }
    }
  }

  private onUpdatePiPTemplateInfo(info: sceneSessionManager.PipTemplateInfo): void {
    if (this.sessionData.updatePiPTemplateInfoCallback) {
      log.showInfo('onUpdatePiPTemplateInfo');
      this.sessionData.updatePiPTemplateInfoCallback(info);
    } else {
      log.showInfo('updatePiPTemplateInfoCallback is null, id:' + this.session?.persistentId);
    }
  }

  private updateDisplayLand(): void {
    const rotateAngle = SCBScreenSessionManager.getInstance().getScreenRotation(this.sceneInfo.screenId);
    const screenProperty: SCBScreenProperty =
      SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId)?.scbScreenProperty;
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId);
    if (!screenSession || !screenProperty) {
      return;
    }
    let isLand = false;
    isLand = (rotateAngle === RotationConstants.ROTATION_90 || rotateAngle === RotationConstants.ROTATION_270) &&
      !screenSession.isRotateScreenPolicy() && !SCBWindowRotateController.getInstance().isFullScreenRotatePolicy();
    this.setIsDisplayLand(isLand);
  }

  private onUpdateTransitionAnimation(type: sceneSessionManager.WindowTransitionType,
    animation: sceneSessionManager.TransitionAnimation): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    if (typeof this.session.persistentId !== 'number') {
      log.showError('invalid id type: ' + typeof this.session.persistentId);
      return;
    }
    log.showInfo(`onUpdateTransitionAnimation type:${type}, animation:${JSON.stringify(animation)}`);
    this.sessionData.transitionAnimationConfig.set(type, animation);
  }

  private onSessionStateChange(state: sceneSessionManager.SessionState): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    if (typeof this.session.persistentId !== 'number') {
      log.showError('invalid id type: ' + typeof this.session.persistentId);
      return;
    }
    log.showInfo(`onSessionStateChange state:${state}`);
    this.sessionData.sessionState = state;
    if (this.sessionData.sessionStateChangeCallback) {
      this.sessionData.sessionStateChangeCallback(state);
    }

    let mgr = SCBSceneSessionManager.getInstance();
    switch (this.sessionState) {
      case sceneSessionManager.SessionState.STATE_CONNECT:
        if (this.sceneInfo.isAtomicService) {
          this.sceneInfo.isStartupInstallFree = false;
        }
        break;
      case sceneSessionManager.SessionState.STATE_FOREGROUND:
        this.sessionData.isForegrounding = false;
        if (this.sessionData.foregroundingTimeoutTaskId !== DEFAULT_TASK_ID) {
          clearTimeout(this.sessionData.foregroundingTimeoutTaskId);
          this.sessionData.foregroundingTimeoutTaskId = DEFAULT_TASK_ID;
        }
        const screenName: string | undefined =
          SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId)?.session.name;
        if (!screenName) {
          log.showError('invalid screen name');
          return;
        }
        if (this.restorePiPStatus && !this.isInUseControl()) {
          this.isAutoStartPiP = true;
        }
        this.updateDisplayLand();
        SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback);
        if (this.isShowWhenLocked) {
          mgr.reOrderShowWhenLocked(false, undefined, 'Session Foreground');
        }
        WinLog.showInfo(WinLogDomain.WMS_IMMS, `win:${this.session.persistentId} foreground`);
        mgr.updateSystemBarProperty();
        mgr.updateNavigationBarProperty(this.systemBarProperty.
          get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable, this);
        mgr.notifyNavigationPropertyChanged(this.systemBarProperty.get(sceneSessionManager.SessionType.TYPE_NAVIGATION_BAR),
          this.sceneInfo.screenId);
        SCBSceneSessionManager.getInstance().onSceneStateChange(this.sceneInfo, true);
        if (this.foregroundCallback !== undefined && this.foregroundCallback !== null) {
          this.foregroundCallback();
        }
        break;
      case sceneSessionManager.SessionState.STATE_BACKGROUND:
        this.sessionData.isForegrounding = false;
        SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback);
        if (this.isShowWhenLocked) {
          mgr.reOrderShowWhenLocked(false, undefined, 'Session Background');
        }
        WinLog.showInfo(WinLogDomain.WMS_IMMS, `win:${this.session.persistentId} background`);
        mgr.updateSystemBarProperty();
        let topActiveSession = mgr.getContainerSessionList().getTopActiveSession();
        mgr.updateNavigationBarProperty(topActiveSession?.mainSessionActive?.systemBarProperty?.
          get(sceneSessionManager.SessionType.TYPE_NAVIGATION_INDICATOR)?.enable, topActiveSession?.mainSessionActive);
        SCBSceneSessionManager.getInstance().onSceneStateChange(this.sceneInfo, false);
        if (this.isAutoStartPiP) {
          const container = SCBScenePanelManager.getInstance().getTotalSessionList()
            .findByPersistentId(this.session.persistentId);
          if (container && container?.isFloat) {
            log.showInfo('[SCBMain]: sceneSession container is float: no start pip window');
            this.isNeedStartPiP = false;
          }
          SCBSceneSessionManager.getInstance().executeAutoStartPiPCallback(this.session.persistentId);
        }
        break;
      default:
        break;
    }
  }

  private onBufferAvailableChange(isBufferAvailable: boolean, startWindowInvisible: boolean): void {
    log.showInfo(`onBufferAvailableChange, isBufferAvailable: ${isBufferAvailable}, id: ${this.session?.persistentId},\
      bundleName: ${this.session?.bundleName}`);
    this.isBufferAvailable = isBufferAvailable;
    SCBSceneSessionManager.getInstance().getScenePersistent().setSessionAliveStatus(this.session.persistentId,
      isBufferAvailable);

    if (isBufferAvailable) {
      log.showInfo(`bufferAvailableCallbackList length: ${this.bufferAvailableCallbackList.length}`);
      this.bufferAvailableCallbackList.forEach((callback) => {
        if (!!callback) {
          callback();
        }
      });
      this.bufferAvailableCallbackList.length = 0;
    }

    if (!this.sessionData._isSystemBarPropertyApplied) {
      WinLog.showInfo(WinLogDomain.WMS_IMMS, `win:${this.session.persistentId} app prop is applied`);
      this.sessionData._isSystemBarPropertyApplied = true;
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }

    if (startWindowInvisible) {
      log.showInfo('[SCBMain] start window invisible, notify app content loaded.');
      SCBSceneMissionManager.getInstance().notifyApplicationLoadedWhenStartWindowInvisible(this.session.persistentId);
    }
  }

  private onFrameLayoutFinish(): void {
    log.showInfo(`onFrameLayoutFinish`);
    if (!!this.frameLayoutFinishCallback) {
      this.frameLayoutFinishCallback();
      this.frameLayoutFinishCallback = null;
    }
  }

  /**
   * window layout change event
   * @param eventId
   * @param param of SessionEventParam
   */
  public windowLayoutEvent(eventId: SCBSessionEventId, param?: sceneSessionManager.SessionEventParam): void {
    this.onSessionEvent(eventId, param);
  }

  private onSessionEvent(eventId: SCBSessionEventId, param: sceneSessionManager.SessionEventParam): void {
    log.showDebug(`onSessionEvent, eventId: ${eventId}`);
    switch (eventId) {
      case SCBSessionEventId.EVENT_MAXIMIZE:
      case SCBSessionEventId.EVENT_WATERFALL_TO_MAXIMIZE:
        this.sessionData.isMaximizeFullScreen = false;
        SCBSceneSessionManager.getInstance().maximize(this.sceneInfo.screenId, this.session.persistentId);
        break;
      case SCBSessionEventId.EVENT_MAXIMIZE_FULLSCREEN:
        this.sessionData.isMaximizeFullScreen = true;
        SCBSceneSessionManager.getInstance().maximizeFullScreen(this.sceneInfo.screenId, this.session.persistentId);
        break;
      case SCBSessionEventId.EVENT_MAXIMIZE_WITHOUT_ANIMATION:
        this.sessionData.isMaximizeFullScreen = false;
        this.sessionData.needMaxWithoutAnim = true;
        this.lastRect.setRectNum(param.pointerX, param.pointerY, param.sessionWidth, param.sessionHeight);
        this.currRect.setRectNum(param.pointerX, param.pointerY, param.sessionWidth, param.sessionHeight);
        let maxRect: SCBSessionRect = this.getMaxRect(this.sceneInfo.screenId);
        this.currRect.copyFrom(maxRect);
        SCBSceneSessionManager.getInstance().maximize(this.sceneInfo.screenId, this.session.persistentId);
        this.sessionData.needMaxWithoutAnim = false;
        log.showInfo('maximize without anim, lastRect: ' + this.lastRect.printPx() + ', currRect: ' + this.currRect.printPx());
        break;
     case SCBSessionEventId.EVENT_MAXIMIZE_WATERFALL:
        log.showInfo('maximize waterfall, id: ' + this.session.persistentId);
        SCBSceneSessionManager.getInstance().maximize(this.sceneInfo.screenId, this.session.persistentId);
        break;
      case SCBSessionEventId.EVENT_MINIMIZE:
        const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
        SCBSceneSessionManager.getInstance().minimize(this.sceneInfo.screenId, this.session.persistentId,
          undefined, false);
        break;
      case SCBSessionEventId.EVENT_CLOSE:
        SCBSceneSessionManager.getInstance().close(this.sceneInfo.screenId, this.session.persistentId);
        break;
      case SCBSessionEventId.EVENT_RECOVER:
        this.sessionData.isMaximizeFullScreen = false;
        SCBSceneSessionManager.getInstance()
          .processRecover(this.sceneInfo.screenId, this.session.persistentId);
        break;
      case SCBSessionEventId.EVENT_MAXIMIZE_FLOATING:
        if (this.sceneInfo.windowMode === SCBSceneMode.PRIMARY ||
          this.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
          SCBSceneSessionManager.getInstance().maximizeFloating(this.sceneInfo.screenId, this.session.persistentId);
        }
      case SCBSessionEventId.EVENT_START_MOVE:
      case SCBSessionEventId.EVENT_DRAG_START:
      case SCBSessionEventId.EVENT_END_MOVE:
      case SCBSessionEventId.EVENT_DRAG:
        if (this.sessionTitleActionCallbackMap.has(this.sceneInfo.screenId)) {
          this.doSessionTitleActionCallback(this.sceneInfo.screenId, eventId, param);
        } else {
          this.sessionDataInner.lastEventId = eventId;
        }
        break;
      case SCBSessionEventId.EVENT_SPLIT_PRIMARY:
        this.sessionData.isMaximizeFullScreen = false;
        SCBSceneSessionManager.getInstance().splitPrimary(this.sceneInfo.screenId, this.session.persistentId);
        break;
      case SCBSessionEventId.EVENT_SPLIT_SECONDARY:
        this.sessionData.isMaximizeFullScreen = false;
        SCBSceneSessionManager.getInstance().splitSecondary(this.sceneInfo.screenId, this.session.persistentId);
        break;
      default:
        break;
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  private onSessionFocusableChange(isFocusable: boolean): void {
    WinLog.showDebug(WinLogDomain.WMS_FOCUS, `onSessionFocusableChange, state: ${isFocusable}`);
    this.isFocusable = isFocusable;
  }

  private onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, state: ${isTouchable}`);
    if (this.sessionData.sessionTouchableChangeCallback) {
      this.sessionData.sessionTouchableChangeCallback(isTouchable);
    } else {
      this.isTouchable = isTouchable;
    }
  }

  private onClickModalWindowOutside(): void {
    log.showInfo(`onClickModalWindowOutside`);
    if (this.sessionData.clickModalWindowOutsideCallback) {
      this.sessionData.clickModalWindowOutsideCallback();
    }
  }

  private onSessionTopmostChange(isTopmost: boolean): void {
    if (this.isTopmost !== isTopmost) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onSessionTopmostChange, state: ${isTopmost}`);
      this.isTopmost = isTopmost;
      SCBSceneSessionManager.getInstance().requestToTop(this.sceneInfo.screenId, this.session.persistentId,
                                                        SCBWindowRaiseReason.SET_TOPMOST);
    }
  }

  private onSessionMainWindowTopmostChange(isMainWindowTopmost: boolean): void {
    if (this.isMainWindowTopmost !== isMainWindowTopmost) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onSessionMainWindowTopmostChange, state: ${isMainWindowTopmost}`);
      this.isMainWindowTopmost = isMainWindowTopmost;
      SCBSceneSessionManager.getInstance().requestToTop(this.sceneInfo.screenId, this.session.persistentId,
                                                        SCBWindowRaiseReason.SET_TOPMOST);
    }
  }

  private onSessionShowWhenLockedChange(isShowWhenLocked: boolean): void {
    const persistentId = this.session?.persistentId;
    if (this.isShowWhenLocked === isShowWhenLocked) {
      log.showInfo(`onSessionShowWhenLockedChange, status:${isShowWhenLocked} of id:${persistentId} ignored.`);
      return;
    }
    log.showInfo(`onSessionShowWhenLockedChange, status change to: ${isShowWhenLocked} of id:${persistentId}`);
    this.sessionData.isShowWhenLocked = isShowWhenLocked;
    if (SCBSceneSessionManager.getInstance().isScreenLocked() && this.isShowWhenLocked) {
      SCBSceneSessionManager.getInstance().reOrderShowWhenLocked(false, true, 'SessionShowWhenLockedChange');
    } else if (SCBSceneSessionManager.getInstance().isScreenLocked() && !this.isShowWhenLocked) {
      SCBSceneSessionManager.getInstance().reOrderShowRemoveWhenLocked();
    }
    if (this.sessionData.sessionShowWhenLockedChangeCallback) {
      this.sessionData.sessionShowWhenLockedChangeCallback(isShowWhenLocked);
    }
  }

  /**
   * set whether Show Above Keyguard
   *
   * @param { Boolean } isShowAboveKeyguard
   */
  public setShowAboveKeyguard(isShowAboveKeyguard: boolean): void {
    log.showInfo(`show above keyguard: ${isShowAboveKeyguard}`);
    this.sessionData.isShowAboveKeyguard = isShowAboveKeyguard;
  }

  private onClick(requestFocus:boolean = true, isClick = true): void {
    WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, 'on session click, requestFocus: ' + requestFocus);
    SCBSceneSessionManager.getInstance().requestToTop(this.sceneInfo.screenId, this.session.persistentId,
      isClick ? SCBWindowRaiseReason.ON_CLICK : SCBWindowRaiseReason.SHOW_APP_WINDOW);
    if (requestFocus) {
      SCBSceneSessionManager.getInstance().requestFocus(this.session.persistentId, true, FocusChangeReason.MOVE_UP);
    }
  }

  /**
   * get whether should block the PowerKey
   *
   * @returns { boolean }
   */
  public getHasBlockPowerKeyPermission(): number {
    log.showInfo('getShouldBlockPowerKey');
    if (DeviceHelper.isWatch() && this.hasBlockPowerKeyPermission === BLOCK_POWER_KEY_NO_CACHE) {
      return this.updateShouldBlockPowerKey();
    }
    return this.hasBlockPowerKeyPermission;
  }

  /**
   * get whether is Focused
   *
   * @returns { boolean }
   */
  public getFocused(): boolean {
    WinLog.showDebug(WinLogDomain.WMS_FOCUS, 'getFocused');
    return this.isFocused;
  }

  /**
   * get whether is Focusable
   *
   * @returns { boolean }
   */
  public getFocusable(): boolean {
    return this.isFocusable;
  }

  /**
   * set whether is Focusable
   *
   * @param { boolean } isFocusable
   */
  public setFocusable(isFocusable): void {
    this.isFocusable = isFocusable;
  }

  /**
   * get whether is Visibility
   *
   * @returns { boolean }
   */
  public getVisibility(): boolean {
    return this.visibility;
  }

  /**
   * set systemFocusable
   *
   * @param systemFocusable
   */
   public setSystemFocusable(systemFocusable: boolean): void {
    try {
      if (this.session) {
        this.session.setSystemFocusable(systemFocusable);
      }
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_FOCUS, 'setSystemFocusable failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set isMidScene
   *
   * @param isMidScene
   */
  public setIsMidScene(isMidScene: boolean): void {
    try {
      if (this.session) {
        this.session.setIsMidScene(isMidScene);
      }
    } catch (err) {
      log.showError('setIsMidScene failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set whether is Visibility
   *
   * @param visibility
   */
  public setVisibility(visibility: boolean): void {
    this.visibility = visibility;
  }

  /**
   * register session display change callback
   *
   * @param callback
   */
  public registerSessionDisplayChangeCallback(callback: Function): void {
    if (callback) {
      this.sessionDisplayChangeCallbacks.push(callback);
    }
    log.showInfo(`registerSessionDisplayChangeCallback callbacks len:${this.sessionDisplayChangeCallbacks.length}`);
  }

  /**
   * unregister session display change callback
   *
   * @param callback
   */
  public unregisterSessionDisplayChangeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`unregisterSessionDisplayChangeCallback failed. callback is null`);
      return;
    }
    let index: number = this.sessionDisplayChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.sessionDisplayChangeCallbacks.splice(index, 1);
    }
    log.showInfo(`unregisterSessionDisplayChangeCallback callbacks len:${this.sessionDisplayChangeCallbacks.length}`);
  }

  /**
   * exec product callback When session change to another screen
   * @param reason change reason
   * @param sessionChangeInfo session change infomation. Including sessions' persistentId, target screen id etc.
   */
  private sessionDisplayChange(reason: SessionDisplayChangeReason, sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`sessionDisplayChange reason: ${reason}, persistentIds len:${sessionChangeInfo.persistentIds.length}` +
      `, curScreenId:${sessionChangeInfo.curScreenId}, target screenId: ${sessionChangeInfo.targetScreenId}`);
    this.sessionDisplayChangeCallbacks.forEach((callback) => {
      if (callback) {
        callback(reason, sessionChangeInfo);
      }
    })
  }

  /**
   * exec when session position | width | height | displayId change
   * @param rect session rect
   * @param reason session change reason
   * @param displayId target screen displayId. -1: change in current screen.
   */
  private onSessionRectChange(rect: sceneSessionManager.SessionRect,
                              reason: sceneSessionManager.SessionSizeChangeReason,
                              displayId: number): void {
    this.updateSizeChangeReason(reason);
    let sessionRectChangeCallback = this.sessionRectChangeCallbackMap.get(this.sceneInfo.screenId);
    if (sessionRectChangeCallback) {
      WinLog.showDebug(WinLogDomain.WMS_LAYOUT, 'rectChangeCallback exists, id: ' + this.session.persistentId + ', reason: ' + reason +
        ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ + ', ' + rect.height_ + ']' +
        ', target displayId: ' + displayId);
      if (displayId !== INVALID_SCREEN_ID && this.sceneInfo.windowMode !== SCBSceneMode.PRIMARY &&
        this.sceneInfo.windowMode !== SCBSceneMode.SECONDARY && displayId !== this.sceneInfo.screenId) {
        let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
        sessionChangeInfo.persistentIds.push(this.sceneInfo.persistentId);
        sessionChangeInfo.targetScreenId = displayId;
        sessionChangeInfo.curScreenId = this.sceneInfo.screenId;
        let sessionRectChangeInfo = new SessionRectChangeInfo();
        sessionRectChangeInfo.newRect = rect;
        sessionRectChangeInfo.reason = reason;
        sessionChangeInfo.sessionRectChangeMap.set(this.sceneInfo.persistentId, sessionRectChangeInfo);
        SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY,
          sessionChangeInfo);
        this.sessionDisplayChange(SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY, sessionChangeInfo);
        sessionRectChangeCallback = this.sessionRectChangeCallbackMap.get(displayId);
      }
      if (!sessionRectChangeCallback) {
        log.showWarn(`onSessionRectChange sessionRectChangeCallback is null. displayId:${displayId}`);
        return;
      }
      this.subSessionList.forEach((item) => {
        item.notifyParenLayoutChange(rect, reason, displayId);
      });
      sessionRectChangeCallback(rect, reason, displayId);
    } else {
      let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
      let isPcOrPcMode: boolean = uiType === SCBConstants.UITYPE_PC;
      if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
        if (displayId !== INVALID_SCREEN_ID &&
          SCBSceneSessionManager.getInstance().getInNotShowRecentIndex(this.sceneInfo.screenId, this.sceneInfo.persistentId) !== -1) {
          this.sceneInfo.isScreenIdNotSpecified = false;
          let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
          sessionChangeInfo.persistentIds.push(this.sceneInfo.persistentId);
          sessionChangeInfo.targetScreenId = displayId;
          sessionChangeInfo.curScreenId = this.sceneInfo.screenId;
          SCBSceneSessionManager.getInstance().sessionDisplayChange(
            SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY_NOT_SHOW,
            sessionChangeInfo);
        }
        this.setPosNum(rect.posX_, rect.posY_);
        if (isPcOrPcMode) {
          this.currRect.setPosNum(rect.posX_, rect.posY_);
        }
      } else if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
        this.setSizeNum(rect.width_, rect.height_);
        if (isPcOrPcMode) {
          this.currRect.setSizeNum(rect.width_, rect.height_);
        }
        if (this.isPcAppInPad) {
          this.processPcAppResize(rect, reason);
        }
      } else {
        this.setPosNum(rect.posX_, rect.posY_);
        this.setSizeNum(rect.width_, rect.height_);
        if (isPcOrPcMode) {
          this.currRect.setPosNum(rect.posX_, rect.posY_);
          this.currRect.setSizeNum(rect.width_, rect.height_);
        }
      }
      log.showDebug('rectChangeCallback is undefined, id: ' + this.session.persistentId +
        ', reason: ' + reason + ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ +
        ', ' + rect.height_ + ']' + ', positionX:' + this.positionX.getPx() + ', positionY:' + this.positionY.getPx() +
        ', width:' + this.width.getPx() + ', height' + this.height.getPx());
    }
    this.updateSizeChangeReason(reason);
  }

  private onNeedAvoid(status: boolean): void {
    WinLog.showDebug(WinLogDomain.WMS_IMMS, `win:${this.session.persistentId} status:${status}`);
    if (this.sessionData.needAvoidCallback) {
      this.sessionData.needAvoidCallback(status);
    } else {
      this.needAvoid = status;
    }
  }

  /**
   * Processes the change of the width and height of the PC application window.
   * @param { sceneSessionManager.SessionRect } rect
   * @param { sceneSessionManager.SessionSizeChangeReason } reason
   */
  private processPcAppResize(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason): void {
    let containerSession = SCBSceneSessionManager.getInstance()
      .getSceneContainerSessionFromScenePanel(this.sceneInfo.persistentId) as SCBSceneContainerSession;
    if (!containerSession) {
      return;
    }
    const isFloatScene: boolean = containerSession.isFloat;
    if (isFloatScene) {
      let sessionRect = new SCBSessionRect(vp2px(containerSession.needRenderPos.posX),
                                           vp2px(containerSession.needRenderPos.posY),
                                           rect.width_, rect.height_);
      containerSession.floatingParam.setScale(FloatingScenePadLayoutStyle.DEFAULT_PC_HEIGHT_RATIO);
      containerSession.width = new ScbNumber(vp2px(rect.width_));
      containerSession.needRenderClip.setClipWidth(rect.width_);
      containerSession.height = new ScbNumber(vp2px(rect.height_));
      containerSession.needRenderClip.setClipHeight(rect.height_);
      containerSession.updateRectForFloat(sessionRect, reason);
      containerSession.changeState(SCBSceneContainerState.FLOAT);
    } else {
      const screenProperty: SCBScreenProperty =
        SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId)?.scbScreenProperty;
      if (!screenProperty) {
        return;
      }
      let height = screenProperty.height;
      let posY = 0;
      let systemSceneSession = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
      if (systemSceneSession == null) {
        log.showError('Failed to get systemSceneSession of the statusBar');
        return;
      }
      let statusbarHeight = systemSceneSession.currRect.height.getPx();
      posY = Math.floor(statusbarHeight);
      height = screenProperty.height - posY;
      log.showInfo(`processPcAppResize  rect, height: ${height} width: ${screenProperty.width}`);
      this.currRect.setSizeNum(screenProperty.width, height);
      this.pcWidth = rect.width_;
      this.pcHeight = rect.height_;
      this.pcLeft = (screenProperty.width - this.pcWidth ) / 2;
      this.pcTop = (height - this.pcHeight ) / 2;
      containerSession.pcWidth = rect.width_;
      containerSession.pcHeight = rect.height_;
      containerSession.pcTop = (height - this.pcHeight ) / 2;
      containerSession.pcLeft = (screenProperty.width - this.pcWidth ) / 2;
    }
  }

  /**
   * update ts session displayId from native
   */
  public onSessionDisplayIdChange(displayId: number): void {
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    sessionChangeInfo.persistentIds.push(this.sceneInfo.persistentId);
    sessionChangeInfo.targetScreenId = displayId;
    sessionChangeInfo.curScreenId = this.sceneInfo.screenId;
    SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY,
      sessionChangeInfo);
  }

  /**
   * update ts session displayId and C++ session displayId
   */
  public updateDisplayId(screenId: number): void {
    this.session.screenId = screenId;
    this.sceneInfo.screenId = screenId;
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(this.session.persistentId, screenId);
  }

  /**
   * calculate Session Rect After Rotation
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public calcSessionRectAfterRotation(screenProperty: SCBScreenProperty): void {
    let screenWidth = screenProperty.width;
    let screenHeight = screenProperty.height;

    if (this.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      let tmp = this.width.copy();
      this.width = this.height.copy();
      this.height = tmp;
      log.showDebug('calcSessionRectAfterRotation fullscreen, width: ' + this.width.getPx() + ', height: ' +
        this.height.getPx() + ', positionX: ' + this.positionX.getPx() + ', positionY: ' + this.positionY.getPx());
      return;
    }

    if (this.width.getPx() > screenWidth) {
      this.width = new ScbNumber(screenWidth);
    }
    if (this.height.getPx() > screenHeight) {
      this.height = new ScbNumber(screenHeight);
    }

    if (this.positionX.getPx() <= 0) {
      this.positionX = new ScbNumber(0);
    } else if (this.positionX.getPx() + this.width.getPx() > screenWidth) {
      this.positionX = new ScbNumber(screenWidth - this.width.getPx());
    }

    if (this.positionY.getPx() <= 0) {
      this.positionY = new ScbNumber(0);
    } else if (this.positionY.getPx() + this.height.getPx() > screenHeight) {
      this.positionY = new ScbNumber(screenHeight - this.height.getPx());
    }

    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    // window on phone is no need to avoid the status bar
    if (uiType === SCBConstants.UITYPE_PHONE) {
      log.showDebug('calcSessionRectAfterRotation isPhone width: ' + this.width.getPx() + ', height: ' + this.height.getPx() +
        ', positionX: ' + this.positionX.getPx() + ', positionY: ' + this.positionY.getPx());
      return;
    }

    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithSystemType(
      sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if (systemSceneSession == null) {
      log.showError('Failed to get systemSceneSession of the statusBar');
      return;
    }
    let statusbarHeight = systemSceneSession.currRect.height.getPx();

    // floating window on pc can't conver the statusBar
    if (this.positionY.getPx() <= statusbarHeight) {
      this.height = new ScbNumber(this.height.getPx() - (statusbarHeight - this.positionY.getPx()));
      this.positionY = new ScbNumber(statusbarHeight);
    }
    log.showDebug('calcSessionRectAfterRotation width: ' + this.width.getPx() + ', height: ' + this.height.getPx() +
      ', positionX: ' + this.positionX.getPx() + ', positionY: ' + this.positionY.getPx());
  }

  public getTransitionAnimationConfig(transitionType: sceneSessionManager.WindowTransitionType):
    sceneSessionManager.TransitionAnimation | undefined {
    if (this.sessionData.transitionAnimationConfig.has(transitionType)) {
      return this.sessionData.transitionAnimationConfig.get(transitionType);
    } else {
      return undefined;
    }
  }

  /**
   * calculate Session Rect After Active Mode Change
   *
   * @param { SCBScreenProperty } oldScreenProperty
   * @param { SCBScreenProperty } newScreenProperty
   */
  public calcSessionRectAfterActiveModeChange(oldScreenProperty: SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC) {
      log.showDebug('calcSessionRectAfterActiveModeChange width: ' + this.currRect.width.getPx() + ', height: ' + this.currRect.height.getPx() +
        ', positionX: ' + this.currRect.left.getPx() + ', positionY: ' + this.currRect.top.getPx());
    } else {
      this.width = new ScbNumber(this.width.getPx() * newScreenProperty.width / oldScreenProperty.width);
      this.height = new ScbNumber(this.height.getPx() * newScreenProperty.height / oldScreenProperty.height);
      this.positionX = new ScbNumber(this.positionX.getPx() * newScreenProperty.width / oldScreenProperty.width);
      this.positionY = new ScbNumber(this.positionY.getPx() * newScreenProperty.height / oldScreenProperty.height);
      log.showDebug('calcSessionRectAfterActiveModeChange width: ' + this.width.getPx() + ', height: ' + this.height.getPx() +
        ', positionX: ' + this.positionX.getPx() + ', positionY: ' + this.positionY.getPx());
    }
  }

  /**
   * calculate Session Rect After Fold Change
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public calcSessionRectAfterFoldChange(screenProperty: SCBScreenProperty): void {
    let screenWidth = screenProperty.width;
    let screenHeight = screenProperty.height;
    if (this.width.getPx() > screenWidth) {
      this.width = new ScbNumber(screenWidth);
    }
    if (this.height.getPx() > screenHeight) {
      this.height = new ScbNumber(screenHeight);
    }
    if (this.positionX.getPx() <= 0) {
      this.positionX = new ScbNumber(0);
    } else if (this.positionX.getPx() + this.width.getPx() > screenWidth) {
      this.positionX = new ScbNumber(screenWidth - this.width.getPx());
    }

    if (this.positionY.getPx() <= 0) {
      this.positionY = new ScbNumber(0);
    } else if (this.positionY.getPx() + this.height.getPx() > screenHeight) {
      this.positionY = new ScbNumber(screenHeight - this.height.getPx());
    }
    this.sessionData.currentRotation = screenProperty.rotation;
    log.showDebug('calcSessionRectAfterFoldChange width: ' + this.width.getPx() + ', height: ' + this.height.getPx() +
      ', positionX: ' + this.positionX.getPx() + ', positionY: ' + this.positionY.getPx());
  }

  private getSupportWindowModes(): BundleManager.SupportWindowMode[] {
    this.refreshMultiWindowDebugInfo();
    if (this.sceneInfo.supportWindowModes !== null &&
      this.sceneInfo.supportWindowModes !== undefined &&
      this.sceneInfo.supportWindowModes.length !== 0) {
      return this.sceneInfo.supportWindowModes;
    }
    let queryKey = this.sceneInfo.bundleName + this.sceneInfo.moduleName + this.sceneInfo.abilityName;
    let supportModes = SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey);
    log.showDebug(`getSupportWindowModes: bundleName: ${this.sceneInfo.bundleName} supportWindowModes ${JSON.stringify(supportModes)}}`);
    if (supportModes) {
      return supportModes;
    }
    return [];
  }

  /**
   * isOnlySupportFullScreen
   * @returns  { Boolean }
   */
  public isOnlySupportFullScreen(): boolean {
    let supportModes: BundleManager.SupportWindowMode[] = this.getSupportWindowModes();
    return supportModes.length === 1 && supportModes[0] === BundleManager.SupportWindowMode.FULL_SCREEN;
  }

  /**
   * whether is Support Split Mode
   *
   * @returns { Boolean }
   */
  public isSupportSplitMode(checkFixedMultiWindowOrientation: boolean = true): boolean {
    return this.isSupportSplitModeInner(checkFixedMultiWindowOrientation).isSupport;
  }

  /**
   * whether is Support Split Mode with reason
   *
   * @returns { SupportModeResult }
   */
  public isSupportSplitModeWithReason(checkFixedMultiWindowOrientation: boolean = true): SupportModeResult {
    return this.isSupportSplitModeInner(checkFixedMultiWindowOrientation);
  }

  private isSupportSplitModeInner(checkFixedMultiWindowOrientation: boolean = true): SupportModeResult {
    if (this.isKioskModeNotSupportSplit()) {
      return { isSupport: false, reason: SupportModeResultReason.KIOSK_MODE };
    }
    if (this.isDebugModeSupportSplit()) {
      return { isSupport: true, reason: SupportModeResultReason.DEBUG_MULTI_WINDOW };
    }
    if (this.isPcAppOnPadNotSupportSplit()) {
      return { isSupport: false, reason: SupportModeResultReason.PC_IN_PAD };
    }
    if (this.isUltraScreenPcInPhoneNotSupportSplit()) {
      return { isSupport: false, reason: SupportModeResultReason.PC_IN_PHONE };
    }
    let isSupport = this.sessionDataInner.supportWindowModes.includes(BundleManager.SupportWindowMode.SPLIT);
    const isForceSupportOpen = !isSupport &&
      SCBSceneSessionManager.getInstance().isOpenInMultiWindowForceSupportList(this.sceneInfo.bundleName);
    const isInSupportList = !isSupport &&
      SCBSceneSessionManager.getInstance().isInMultiWindowForceSupportList(this.sceneInfo.bundleName);
    if (isForceSupportOpen) {
      log.showInfo(`isSupportSplitMode force support`);
      return { isSupport: true, reason: SupportModeResultReason.FORCE_SUPPORT };
    }
    const isWillSupport = isSupport || isInSupportList;
    if (isWillSupport && DeviceHelper.isUltraScreenProduct() &&
    SCBSplitUtils.isUltraScreenFixedSplitRatioScene(this.sceneInfo)) {
      log.showInfo('isSupportSplitMode three fold product with fixed split radio scene, return false');
      return { isSupport: false, reason: SupportModeResultReason.FIXED_SPLIT_RATIO };
    }
    if (isWillSupport && checkFixedMultiWindowOrientation &&
      SCBSceneUtils.disableSupportSplitWithFixedMultiWindowOrientation(this, isInSupportList)) {
      log.showInfo('isSupportSplitMode folded with fixed multiWindow orientation, return false');
      return { isSupport: false, reason: SupportModeResultReason.FIXED_MULTI_WIN_ORIENTATION };
    }
    if (isForceSupportOpen) {
      return { isSupport: true, reason: SupportModeResultReason.FORCE_SUPPORT };
    }
    log.showInfo(`isSupportSplitMode isSupport: ${isSupport}`);
    return { isSupport: isSupport, reason: SupportModeResultReason.DEFAULT };
  }

  private isKioskModeNotSupportSplit(): boolean {
    if (SCBKioskModeManager.getInstance().isKioskMode()) {
      log.showInfo('[Kiosk] not support split mode in kiosk mode');
      return true;
    }
    return false;
  }

  private isDebugModeSupportSplit(): boolean {
    return this.sessionDataInner.debugMultiWindow;
  }

  private isPcAppOnPadNotSupportSplit(): boolean {
    if (this.isPcAppInPad && !DeviceHelper.is2In1DevicePcType()) {
      return true;
    }
    return false;
  }

  private isUltraScreenPcInPhoneNotSupportSplit(): boolean {
    if (DeviceHelper.isUltraScreenProduct() && PC_IN_PHONE_LIST.includes(this.sceneInfo.bundleName)) {
      log.showInfo(`not support split pc app, bundleName:${this.sceneInfo.bundleName}`);
      return true;
    }
    return false;
  }

  /**
   * whether is Support Floating Mode
   *
   * @returns { Boolean }
   */
  public isSupportFloatingMode(): boolean {
    return this.isSupportFloatingModeInner().isSupport;
  }

  /**
   * whether is Support Floating Mode with reason
   *
   * @returns { SupportModeResult }
   */
  public isSupportFloatingModeWithReason(): SupportModeResult {
    return this.isSupportFloatingModeInner();
  }

  private isSupportFloatingModeInner(): SupportModeResult {
    if (SCBKioskModeManager.getInstance().isKioskMode()) {
      log.showInfo('[Kiosk] not support floating mode in kiosk mode');
      return { isSupport: false, reason: SupportModeResultReason.PC_IN_PHONE };
    }
    if (this.sessionDataInner.debugMultiWindow) {
      log.showInfo('isSupportFloatingMode debugMultiWindow');
      return { isSupport: true, reason: SupportModeResultReason.DEBUG_MULTI_WINDOW };
    }
    if (this.isPcAppInPad && !DeviceHelper.is2In1DevicePcType()) {
      return { isSupport: false, reason: SupportModeResultReason.PC_IN_PAD };
    }
    if (DeviceHelper.isUltraScreenProduct() && PC_IN_PHONE_LIST.includes(this.sceneInfo.bundleName)) {
      log.showInfo(`not support floating pc app,  bundleName:${this.sceneInfo.bundleName}`);
      return { isSupport: false, reason: SupportModeResultReason.PC_IN_PHONE };
    }
    let isSupport = this.sessionDataInner.supportWindowModes.indexOf(BundleManager.SupportWindowMode.FLOATING) > -1;
    if (!isSupport &&
      SCBSceneSessionManager.getInstance().isOpenInMultiWindowForceSupportList(this.sceneInfo.bundleName)) {
      log.showInfo(`isSupportFloatingMode force support`);
      return { isSupport: true, reason: SupportModeResultReason.FORCE_SUPPORT };
    }
    log.showInfo(`isSupportFloatingMode isSupport: ${isSupport}`);
    return { isSupport: isSupport, reason: SupportModeResultReason.DEFAULT };
  }

  /**
   * whether is Support Full Screen Mode
   *
   * @returns { Boolean }
   */
  public isSupportFullScreenMode(): boolean {
    return this.sessionDataInner.supportWindowModes.indexOf(BundleManager.SupportWindowMode.FULL_SCREEN) > -1;
  }

  /**
   * whether is Support MultiWindow Mode
   *
   * @returns { Boolean }
   */
  public isSupportMultiWindowMode(): boolean {
    return this.isSupportFloatingMode() || this.isSupportSplitMode();
  }

  /**
   * get scene name
   *
   * @returns { string }
   */
  public getName(): string {
    return `${this.sceneInfo.getName()}(persistentId: ${this.sceneInfo.persistentId})`;
  }

  /**
   * Set window scene occlusion alpha
   * @param alpha [0, 1.0]
   */
  public setOcclusionAlpha(alpha: number): void {
    log.showInfo(`set setOcclusionAlpha: ${alpha}`);
    this.session?.setSystemSceneOcclusionAlpha(alpha);
  }

  /**
   * reset window scene occlusion alpha
   */
  public resetOcclusionAlpha(): void {
    log.showInfo('reset OcclusionAlpha');
    if (!this.session) {
      log.showError('resetOcclusionAlpha failed, session is null');
      return;
    }
    try {
      this.session.resetOcclusionAlpha();
    } catch (err) {
      log.showError('resetOcclusionAlpha failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * update Rect
   *
   * @param { ScbNumber } left
   * @param { ScbNumber } top
   * @param { ScbNumber } width
   * @param { cbNumber } height
   * @param { sceneSessionManager.SessionSizeChangeReason } reason
   * @param { boolean } currRectLinked
   */
  public updateRect(left: ScbNumber, top: ScbNumber, width: ScbNumber, height: ScbNumber,
    reason?: sceneSessionManager.SessionSizeChangeReason, currRectLinked: boolean = false): void {
    this.setWindowOffset(left.getPx(), top.getPx());
    this.setSubSessionsWindowOffset(left, top);
    this.updateSizeChangeReason(reason);
    if (currRectLinked) {
      this.currRect.setRect(left, top, width, height);
    } else {
      WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'SCBSceneSession.currRect is replaced to new object');
      let newRect = new SCBSessionRect();
      newRect.setRect(left, top, width, height);
      this.currRect = newRect;
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.ROTATION) {
      if (this.isPcAppInPad && this.pcTop !== 0 && this.pcLeft !== 0) {
        let containerSession = SCBSceneSessionManager.getInstance()
          .getSceneContainerSessionFromScenePanel(this.sceneInfo.persistentId) as SCBSceneContainerSession;
        const screenProperty: SCBScreenProperty =
          SCBScreenSessionManager.getInstance().getScreenSession(this.sceneInfo.screenId)?.scbScreenProperty;
        if (!screenProperty) {
          return;
        }
        let height = screenProperty.height;
        let posY = 0;
        let systemSceneSession = SCBSceneSessionManager.getInstance()
          .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
        let statusbarHeight = systemSceneSession.currRect.height.getPx();
        posY = Math.floor(statusbarHeight);
        height = screenProperty.height - posY;
        this.pcLeft = (screenProperty.width - this.pcWidth ) / 2;
        this.pcTop = (height - this.pcHeight ) / 2;
        containerSession.pcTop = (height - this.pcHeight ) / 2;
        containerSession.pcLeft = (screenProperty.width - this.pcWidth ) / 2;
      }
    }
    log.showInfo('updateRect id: ' + this.session?.persistentId + ' reason: ' + reason +
      ', rect: [' + this.currRect.left.getPx() + ', ' + this.currRect.top.getPx() +
      ', ' + this.currRect.width.getPx() + ', ' + this.currRect.height.getPx() + ']' );
  }

  public updateRectWithSubWindow(left: ScbNumber, top: ScbNumber, width: ScbNumber,
    height: ScbNumber, screenProperty: SCBScreenProperty, reason?: sceneSessionManager.SessionSizeChangeReason): void {
    let mainRect = new SCBSessionRect();
    mainRect.copyFrom(this.currRect);
    this.updateRect(left, top, width, height, reason);
    this.updateSubRequestedRect(mainRect);
    this.updateSubSessionRectForOneStepSplit(screenProperty, this.currRect);
  }

  /**
   * need handle window drag to hotArea
   */
  public isNeedHandleWindowDragHotArea(displayId: number): boolean {
    log.showInfo(`isNeedHandleWindowDragHotArea ${displayId}`);
    if (this.sessionIsNeedChangeCallbackMap.get(displayId)) {
      return this.sessionIsNeedChangeCallbackMap.get(displayId)();
    } else {
      return false;
    }
  }

  /**
   * update Size Change Reason
   *
   * @param { sceneSessionManager.SessionSizeChangeReason } reason
   */
  public updateSizeChangeReason(reason: sceneSessionManager.SessionSizeChangeReason): void {
    try {
      if (this.session == null) {
        WinLog.showError(WinLogDomain.WMS_LAYOUT, 'updateSizeChangeReason null session');
        return;
      }
      this.session.updateSizeChangeReason(reason);
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_LAYOUT, 'updateSizeChangeReason failed, with reason ' + JSON.stringify(err));
    }
    WinLog.showInfo(WinLogDomain.WMS_LAYOUT, `name:${this.getName()} updateSizeChangeReason:${reason}`);
  }

  /**
   * update Floating Scale
   *
   * @param { Number } floatingScale
   * @param { Number } needSetScale
   */
  public updateFloatingScale(floatingScale: number, needSetScale: boolean = true): void {
    try {
      if (this.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
        floatingScale = 1.0;
      }
      if (needSetScale) {
        this.session?.setScale(floatingScale, floatingScale, 0, 0);
        this.session?.setFloatingScale(floatingScale);
      }
      this.updateSubSessionsFloatingScale(floatingScale, needSetScale);
    } catch (err) {
      log.showError(`updateFloatingScale error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * set blank
   *
   * @param blank
   */
  public setBlank(isAddBlank: boolean): void {
    try {
      this.session?.setBlank(isAddBlank);
    } catch (err) {
      log.showError(`setBlank error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * set buffer available callback enable
   *
   * @param callback enable
   */
  public setBufferAvailableCallbackEnable(enable: boolean): void {
    try {
      this.session?.setBufferAvailableCallbackEnable(enable);
    } catch (err) {
      log.showError(`setBufferAvailableCallbackEnable error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * remove blank
   */
  public removeBlank(): void {
    try {
      this.session?.removeBlank();
    } catch (err) {
      log.showError(`removeBlank error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * add sanpshot
   */
  public addSnapshot(useFfrt?: boolean, needPersist?: boolean): void {
    try {
      this.session?.addSnapshot(useFfrt, needPersist);
    } catch (err) {
      log.showError(`addSnapshot error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * remove sanpshot
   */
  public removeSnapshot(): void {
    try {
      this.session?.removeSnapshot();
    } catch (err) {
      log.showError(`removeSnapshot error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * set frame layout finish callback
   * @param callback
   */
  public setFrameLayoutFinishCallback(callback: Function): void {
    this.frameLayoutFinishCallback = callback;
  }

  /**
   * unset frame layout finish callback
   */
  public unsetFrameLayoutFinishCallback(): void {
    this.frameLayoutFinishCallback = null;
  }

  /**
   * Set window colorSpace
   * @param colorSpace 0 or 1
   */
  public setColorSpace(colorSpace: number): void {
    log.showInfo(`set setColorSpace: ${colorSpace}`);
    this.session?.setColorSpace(colorSpace);
  }

  /**
   * set dialog and subsession scale
   *
   * @param floatingScale floatingScale
   * @param needSetScale needSetScale
   */
  private updateSubSessionsFloatingScale(floatingScale: number, needSetScale: boolean): void {
    try {
      this.subSessionList.forEach((item) => {
        if (needSetScale) {
          item.session?.setScale(floatingScale, floatingScale, 0, 0);
        }
        item.session?.setFloatingScale(floatingScale);
      });
      this.dialogSessionList.forEach((item) => {
        if (needSetScale) {
          item.session?.setScale(floatingScale, floatingScale, 0, 0);
        }
        item.session?.setFloatingScale(floatingScale);
      });
    } catch (err) {
      log.showError(`updateSubSessionsFloatingScale error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * update scene session rect for the one-step state.
   *
   * @param { SCBScreenProperty } screenProperty screen position
   * @param { Boolean } isUpDownSplit split style
   * @param { Number } moveOffset offset in px
   */
  public updateCurRectForOneStepSplit(screenProperty: SCBScreenProperty,
    isUpDownSplit: boolean, moveOffset: number, reason: sceneSessionManager.SessionSizeChangeReason =
    sceneSessionManager.SessionSizeChangeReason.FULL_TO_SPLIT): void {
    let dividerLen = vp2px(DIVIDER_HEIGHT);
    let width = !isUpDownSplit ? (screenProperty.width - dividerLen) / HALF : screenProperty.width;
    let height = isUpDownSplit ? (screenProperty.height - dividerLen) / HALF : screenProperty.height;

    let left = Math.round(!isUpDownSplit ? screenProperty.left + moveOffset : screenProperty.left);
    let top = Math.round(isUpDownSplit ? screenProperty.top + moveOffset : screenProperty.top);
    let mainRect = new SCBSessionRect();
    mainRect.setRect(this.currRect.left, this.currRect.top, this.currRect.width, this.currRect.height);
    this.updateRect(this.currRect.left, this.currRect.top, this.currRect.width, this.currRect.height, reason, true);
    this.updateSubRequestedRect(mainRect);
    this.updateSubSessionRectForOneStepSplit(screenProperty, new SCBSessionRect(left, top, width, height));
  }

  private updateSubSessionRectForOneStepSplit(screenProperty: SCBScreenProperty, mainRect: SCBSessionRect): void {
    this.subSessionList.forEach((item) => {
      item.updateSubRectForSplit(screenProperty, mainRect, sceneSessionManager.SessionSizeChangeReason.FULL_TO_SPLIT);
    });
    this.dialogSessionList.forEach((item) => {
      item.updateSubRectForSplit(screenProperty, mainRect, sceneSessionManager.SessionSizeChangeReason.FULL_TO_SPLIT);
    });
  }

  /**
   * update Current Rect For MultiWindow To Full
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public updateCurRectForMultiWindowToFull(screenProperty: SCBScreenProperty): void {
    log.showInfo(`updateCurRectForMultiWindowToFull`);
    let mainRect = new SCBSessionRect();
    mainRect.setRect(this.currRect.left, this.currRect.top, this.currRect.width, this.currRect.height);
    this.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top), new ScbNumber(screenProperty.width),
      new ScbNumber(screenProperty.height), sceneSessionManager.SessionSizeChangeReason.SPLIT_TO_FULL);
    this.updateSubRequestedRect(mainRect);
    this.restoreRequestedRectFromMultiWindowToFull(screenProperty);
  }

  /**
   * Indicates whether the subSession is focused.
   *
   * @returns { Boolean } true if subSession focused
   */
  public isSubSessionFocused(): boolean {
    return this.isFocusedOnSpecificSceneSessionList(this.subSessionList);
  }

  /**
   * Indicates whether the dialogSession is focused.
   *
   * @returns { Boolean } true if dialogSession focused
   */
  public isDialogSessionFocused(): boolean {
    return this.isFocusedOnSpecificSceneSessionList(this.dialogSessionList);
  }

  private isFocusedOnSpecificSceneSessionList(specificSceneSessionList: SCBSpecificSceneSessionList): boolean {
    for (let item of specificSceneSessionList) {
      if (item.isFocused) {
        return true;
      }
    }
    return false;
  }

  /**
   * restore app requested rect from MultiWindow to full screen
   */
  private restoreRequestedRectFromMultiWindowToFull(screenProperty: SCBScreenProperty): void {
    let mainRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
      screenProperty.width, screenProperty.height);
    this.subSessionList.forEach((item) => {
      item.onSessionRectChange(item.updateSubRectAlgorithm(mainRect).transfer2SessionRect(),
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
    });

    this.dialogSessionList.forEach((item) => {
      item.onSessionRectChange(item.updateSubRectAlgorithm(mainRect).transfer2SessionRect(),
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
    });
  }

  private updateSubRequestedRect(mainRect: SCBSessionRect): void {
    this.subSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(mainRect)) {
        item.setRequestedRect(this.currRect);
      }
    });

    this.dialogSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(mainRect)) {
        item.setRequestedRect(this.currRect);
      }
    });
  }

  /**
   * set dialog and subsession offset
   * @param left
   * @param top
   */
  public setSubSessionsWindowOffset(left: ScbNumber, top: ScbNumber): void {
    this.subSessionList.forEach((item) => {
      item.setWindowOffset(left.getPx(), top.getPx());
    });
    this.dialogSessionList.forEach((item) => {
      item.setWindowOffset(left.getPx(), top.getPx());
    });
  }

  /**
   * Indicates whether the session is in the specified mode(s).
   *
   * @param { SCBSceneMode[] } mode(s) to be determined
   * @returns { Boolean } true if in the specified mode(s)
   */
  public isInSceneMode(...mode: SCBSceneMode[]): boolean {
    for (let modeKey of mode) {
      if (this.sceneInfo.windowMode === modeKey) {
        return true;
      }
    }
    return false;
  }

  /**
   * Refreshes multi-window debugging information., force app support multi-window mode.
   */
  public refreshMultiWindowDebugInfo(): void {
    try {
      systemParameterEnhance.get(MULTI_WINDOW_DEBUG_PARAM_KEY, 'false').then(value => {
        this.sessionDataInner.debugMultiWindow = value === 'true';
      }).catch(error => {
        log.showError(`get system param fail cause: ${error}.`);
      });
    } catch (error) {
      log.showError(`get system param fail cause: ${error}.`);
    }
  }

  /**
   * Set offset of the window to ensure that multi-mode input events can be correctly distributed.
   *
   * Usually refers to the position of the parent component.
   *
   * Unit: px
   *
   * @param x parent component position x
   * @param y parent component position y
   */
  public setWindowOffset(x: number, y: number): void {
    if (x === this.sessionDataInner.windowOffsetX && y === this.sessionDataInner.windowOffsetY) {
      return;
    }
    try {
      if (!this.session) {
        log.showError('setWindowOffset null session');
        return;
      }
      this.session.setOffset(x, y);
      this.sessionDataInner.windowOffsetX = x;
      this.sessionDataInner.windowOffsetY = y;
    } catch (err) {
      log.showError('setWindowOffset failed, with reason ' + JSON.stringify(err));
    }
  }

  /**
   * register Interactive State Change Callback
   *
   * @param callback
   */
  public registerInteractiveStateChangeCallback(callback: (state: boolean) => void): void {
    this.interactiveStateChangeCallback = callback;
  }

  /**
   * unregister Interactive State Change Callback
   */
  public unregisterInteractiveStateChangeCallback(): void {
    this.interactiveStateChangeCallback = undefined;
  }

  /**
   * notify Interactive State Change
   *
   * @param { Boolean } state
   */
  public notifyInteractiveStateChange(state: boolean): void {
    if (!!this.interactiveStateChangeCallback) {
      this.interactiveStateChangeCallback(state);
    }
  }

  public registerGetOverlaySessionCallback(callback: () => SCBSystemSceneSession[]): void {
    if (CommonUtils.isInvalid(callback) || this.getOverlaySessionCallback.indexOf(callback) !== -1) {
      return;
    }
    this.getOverlaySessionCallback.push(callback);
  }

  public unregisterGetOverlaySessionCallback(callback: () => SCBSystemSceneSession[]): void {
    let index = this.getOverlaySessionCallback.indexOf(callback);
    if (index !== -1) {
      this.getOverlaySessionCallback.splice(index, 1);
    }
  }

  /**
   * register Foreground Callback
   *
   * @param callback
   */
  public registerForegroundCallback(callback: () => void): void {
    this.foregroundCallback = callback;
  }

  /**
   * unregister Foreground Callback
   */
  public unregisterForegroundCallback(): void {
    this.foregroundCallback = undefined;
  }

  /**
   * register Session State Change Callback
   *
   * @param callback
   */
  public registerSessionStateChange(callback: (state: sceneSessionManager.SessionState) => void): void {
    this.sessionData.sessionStateChangeCallback = callback;
  }

  /**
   * unregister Session State Change Callback
   */
  public unregisterSessionStateChange(): void {
    this.sessionData.sessionStateChangeCallback = undefined;
  }

  /**
   * register callback to get use control is show
   *
   * @param callback
   */
  public registerIsShowUseControlCallback(callback: (boolean) => void): void {
    let index = this.isShowUseControlCallbackList.indexOf(callback);
    if (index === -1) {
      this.isShowUseControlCallbackList.push(callback);
    }
  }

  /**
   * unregister callback to get use control is show
   */
  public unregisterIsShowUseControlCallback(callback: (boolean) => void): void {
    let index = this.isShowUseControlCallbackList.indexOf(callback);
    if (index !== -1) {
      this.isShowUseControlCallbackList.splice(index, 1);
    }
  }

  /**
   * register callback to get use control is show
   * @param callback
   */
  public registerIsActiveCallback(callback: (boolean) => void): void {
    let index = this.isActiveCallbackList.indexOf(callback);
    if (index === -1) {
      this.isActiveCallbackList.push(callback);
    }
  }

  /**
   * unregister callback to get use control is show
   * @param callback
   */
  public unregisterIsActiveCallback(callback: (boolean) => void): void {
    let index = this.isActiveCallbackList.indexOf(callback);
    if (index !== -1) {
      this.isActiveCallbackList.splice(index, 1);
    }
  }

  private setIsActive(isActive: boolean): void {
    if (isActive) {
      this.needBackPanelInRecent = false;
    }
    this.sessionData.setIsActive(isActive);
    if (isActive && this.useControlList.length > 0) {
      this.initUseControlSession();
    }
    this.isActiveCallbackList.forEach((callback) => callback && callback(isActive));
  }

  /**
   * register callback to get max rect in B/C side
   * @param callback
   */
  public registerGetMaxRectCallback(screenId: number, callback: () => SCBSessionRect): void {
    if (screenId === INVALID_SCREEN_ID) {
      WinLog.showError(WinLogDomain.WMS_LAYOUT_PC, 'registerGetMaxRectCallback invalid screen id');
      return;
    }
    if (this.getMaxRectCallbacks.has(screenId)) {
      WinLog.showWarn(WinLogDomain.WMS_LAYOUT_PC, 'registerGetMaxRectCallback callback has been registered, screenId: ' + screenId);
    }
    this.getMaxRectCallbacks.set(screenId, callback);
  }

  public unregisterGetMaxRectCallback(screenId: number): void {
    if (!this.getMaxRectCallbacks.has(screenId)) {
      WinLog.showWarn(WinLogDomain.WMS_LAYOUT_PC, 'unregisterGetMaxRectCallback not registered, screenId: ' + screenId);
      return;
    }
    this.getMaxRectCallbacks.delete(screenId);
  }

  private getMaxRect(screenId: number): SCBSessionRect {
    if (!this.getMaxRectCallbacks.has(screenId)) {
      log.showError('getMaxRectCallback not registered');
      return this.currRect.copy();
    }
    let callback = this.getMaxRectCallbacks.get(screenId);
    if (!callback) {
      log.showError('call back is null');
      return this.currRect.copy();
    }
    return callback();
  }

  /**
   * register callback drag window moving
   * @param callback
   * @param screenId
   */
  public registerWindowMovingCallback(callback: (displayId: number, pointerX: number, pointerY: number) => void,
    screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showInfo(`registerWindowMovingCallback screenId: ${screenId}`);
    if (this.windowMovingCallbackMap.has(screenId)) {
      let callbackArray: Function[] = this.windowMovingCallbackMap.get(screenId);
      const index = callbackArray.indexOf(callback);
      if (index === -1) {
        callbackArray.push(callback);
      }
      return;
    }
    let callbackArray: Function[] = [];
    callbackArray.push(callback);
    this.windowMovingCallbackMap.set(screenId, callbackArray);
  }

  /**
   * unregister callback drag window moving
   * @param screenId
   */
  public unregisterWindowMovingCallback(callback: Function, screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showDebug(`unregisterWindowMovingCallback screenId: ${screenId}`);
    if (!this.windowMovingCallbackMap.has(screenId)) {
      return;
    }
    let callbackArray: Function[] = this.windowMovingCallbackMap.get(screenId);
    let index = callbackArray.indexOf(callback);
    if (index !== -1) {
      callbackArray.splice(index, 1);
    }
    if (callbackArray.length === 0) {
      this.windowMovingCallbackMap.delete(screenId);
    }
  }

  /**
   * run the drag window moving callback function
   * @param displayId
   * @param pointerX
   * @param pointerY
   */
  private processWindowMoving(displayId: number, pointerX: number, pointerY: number): void {
    this.currMovePointerPos.setPointerPos(pointerX, pointerY);
    let callbackArray: Function[] = this.windowMovingCallbackMap.get(displayId);
    if (!callbackArray || callbackArray.length === 0) {
      return;
    }
    const callback = callbackArray[callbackArray.length - 1];
    if (callback) {
      callback(displayId, pointerX, pointerY);
    }
  }

  /**
   * register callback notify split-screen partner that drag is moving
   * @param callback
   * @param screenId
   */
  public registerSplitPartnerMovingCallback(callback: () => void, screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showInfo(`registerSplitPartnerMovingCallback screenId: ${screenId}`);
    if (this.splitPartnerMovingCallbackMap.has(screenId)) {
      let callbackArray: Function[] = this.splitPartnerMovingCallbackMap.get(screenId);
      const index = callbackArray.indexOf(callback);
      if (index === -1) {
        callbackArray.push(callback);
      }
      return;
    }
    let callbackArray: Function[] = [];
    callbackArray.push(callback);
    this.splitPartnerMovingCallbackMap.set(screenId, callbackArray);
  }

  /**
   * unregister callback notify split-screen partner that drag is moving
   * @param screenId
   */
  public unregisterSplitPartnerMovingCallback(callback: Function, screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showDebug(`unregisterSplitPartnerMovingCallback screenId: ${screenId}`);
    if (!this.splitPartnerMovingCallbackMap.has(screenId)) {
      return;
    }
    let callbackArray: Function[] = this.splitPartnerMovingCallbackMap.get(screenId);
    let index = callbackArray.indexOf(callback);
    if (index !== -1) {
      callbackArray.splice(index, 1);
    }
    if (callbackArray.length === 0) {
      this.splitPartnerMovingCallbackMap.delete(screenId);
    }
  }

  /**
   * unregister callback of updating PiP default window size type
   *
   * @param callback
   */
  public unregisterUpdatePiPTemplateInfoCallback(): void {
    log.showInfo(`unRegisterUpdatePiPTemplateInfoCallback, persistentId: ${this.session?.persistentId}`);
    this.sessionData.updatePiPTemplateInfoCallback = null;
  }

  public getOverlaySessionList(): SCBSystemSceneSession[] {
    return this.getOverlaySessionCallback.map(value => value()).reduce((pre, cur) => pre.concat(cur), []);
  }

  /**
   * add Ref Count
   */
  public addRefCount(): void {
    this.sessionDataInner.refCount++;
  }

  /**
   * decrease Ref Count
   */
  public decRefCount(): void {
    this.sessionDataInner.refCount--;
  }

  /**
   * get ref count
   */
  public getRefCount(): number {
    return this.sessionDataInner.refCount;
  }

  /**
   * set callback to get session isPrivacyWindow changed
   * @param callback
   */
  public setPrivacyWindowChangedCallback(callback: (boolean) => void): void {
    if (callback) {
      this.onPrivacyWindowChangedCallback = callback;
    }
  }

  /**
   * unRegister All
   */
  public unRegisterAll(panelId?: number): void {
    if (this.getRefCount() !== 0) {
      log.showWarn(`unRegisterAll abort, id: ${this.session?.persistentId}, refCount: ${this.getRefCount()}`);
      return;
    }
    log.showInfo(`unRegisterAll: ${this.session?.persistentId}.`);
    this.sessionRectChangeCallbackMap.clear();
    this.sessionData.createSubSessionCallback = null;
    if (panelId) {
      this.sessionData.createSubSessionCallbacks.delete(panelId);
      this.sessionData.createDialogCallbacks.delete(panelId);
    }
    this.sessionData.createDialogCallback = null;
    this.sessionData.needAvoidCallback = null;
    this.sessionData.keyboardOffsetCallback = null;
    this.sessionData.sessionTouchableChangeCallback = null;
    this.sessionData.sessionShowWhenLockedChangeCallback = null;
    if (this.sessionData.systemBarPropertyCallback) {
      SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyCallbacks(this.sessionData.systemBarPropertyCallback);
    }
    this.sessionData.systemBarPropertyCallback = null;
    this.windowDragHotAreaCallbackMap.clear();
    this.sessionIsNeedChangeCallbackMap.clear();
    this.sessionData.onUpdateSessionLabelCallback = null;
    this.sessionData.onUpdateSessionIconCallback = null;
    this.callbackMap.clear();
    this.interactiveStateChangeCallback = undefined;
    this.isShowUseControlCallbackList = [];
    this.isActiveCallbackList = [];
    this.onPrivacyWindowChangedCallback = undefined;
    this.sessionData.clickModalWindowOutsideCallback = null;
    this.sessionData.updatePiPTemplateInfoCallback = null;
  }

  /**
   * whether is In Split
   *
   * @returns { Boolean }
   */
  public isInSplit(): boolean {
    return this.sceneInfo.windowMode === SCBSceneMode.PRIMARY || this.sceneInfo.windowMode === SCBSceneMode.SECONDARY;
  }

  /**
   * whether is In isInFloat
   *
   * @returns { Boolean }
   */
  public isInFloat(): boolean {
    return this.sceneInfo.windowMode === SCBSceneMode.FLOATING;
  }

  /**
   * Notification that the status bar is being temporarily displayed
   * @param isTemporary
   */
  public notifyDisplayStatusBarTemporarily(isTemporary: boolean): void {
    if (!this.session) {
      log.showError(`this session is null `);
      return;
    }
    try {
      this.session.notifyDisplayStatusBarTemporarily(isTemporary);
    } catch (err) {
      log.showError('notifyDisplayStatusBarTemporarily failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * whether immersive has been set
   * @param enable
   */
  public setStatusBarEnable(enable: boolean): void {
    this.sessionData.isSetStatusBarEnable = enable;
  }

  /**
   * whether status bar content color follow app color mode
   * @param isFollowAppColorMode
   */
  public setIsFollowAppColorMode(isFollowAppColorMode: boolean): void {
    this.sessionData.isFollowAppColorMode = isFollowAppColorMode;
  }

  /**
   * whether StatusBarColor has been set
   * @param isSetStatusBarColor
   */
  public setIsSetStatusBarColor(isSetStatusBarColor: boolean): void {
    this.sessionData.isSetStatusBarColor = isSetStatusBarColor;
  }

  /**
   *  landscape or portrait
   * @param isDisplayLand
   */
  public setIsDisplayLand(isDisplayLand: boolean): void {
    this.sessionData.isDisplayLand = isDisplayLand;
  }

  public isSessionForeground(): boolean {
    return this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND ||
      this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE;
  }

  public isSessionBackground(): boolean {
    return this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_BACKGROUND;
  }

  public checkNativeRefAvailability(reason: string): void {
    log.showInfo('nativeRefAvailability checking with active:%{public}s, refCount:%{public}d, reason:%{public}s.',
      this.isActive, this.getRefCount(), `${reason}`);
    if ((!this.isActive && this.getRefCount() === 0) && !this.sessionDataInner.nativeCacheRefAvailable) {
      log.showWarn('nativeRefAvailability checking with native reference unavailable, need to clear cache.');
    }
  }

  private onPrivacyModeChange(isPrivacyWindow: boolean): void {
    log.showInfo(`onPrivacyModeChange id:${this.sceneInfo.persistentId}, isPrivacyWindow: ${isPrivacyWindow}`);
    this.sessionData.isPrivacyWindow = isPrivacyWindow;
    this.onPrivacyWindowChangedCallback?.(isPrivacyWindow);
  }

  /**
   * set compatible mode enable in pad device
   *
   * @param enable: enable or disable
   */
  public setCompatibleModeEnableInPad(enable: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      const compatibleModeProperty:sceneSessionManager.CompatibleModeProperty = {
        isAdaptToEventMapping: enable,
        disableWindowLimit: true,
        disableDragResize: true,
        disableSplit: true
      };
      this.layoutFullScreen = true;
      this.session.toggleCompatibleMode(true, compatibleModeProperty);
    } catch (err) {
      log.showError('setCompatibleModeEnableInPad failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * sync default requested orientation
   *
   * @param defaultRequestedOrientation: default requested orientation
   */
  public syncDefaultRequestedOrientation(defaultRequestedOrientation: number): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.syncDefaultRequestedOrientation(defaultRequestedOrientation);
    } catch (err) {
      log.showError('syncDefaultRequestedOrientation failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set the last size and position of the window
   *
   * @param posX window position x
   * @param posY window position y
   * @param width window width
   * @param height window height
   */
  public setWindowLastSafeRect(posX: number, posY: number, width: number, height: number): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.setWindowLastSafeRect(posX, posY, width, height);
    } catch (err) {
      log.showError('setWindowLastSafeRect failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * sets whether the window can be moved
   *
   * @param isMovable: movable or immovable
   */
  public setMovable(isMovable: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.setMovable(isMovable);
    } catch (err) {
      log.showError('setMovable failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set whether the window can be zoomed in or out by dragging
   *
   * @param enable: enable or disable
   */
  public setWindowEnableDragBySystem(enable: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.setWindowEnableDragBySystem(enable);
    } catch (err) {
      log.showError('setWindowEnableDragBySystem failed');
    }
  }

  /**
   * sets whether the window is visible
   *
   * @param isVisible: visible or invisible
   */
  public setSplitButtonVisible(isVisible: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.setSplitButtonVisible(isVisible);
    } catch (err) {
      log.showError('setSplitButtonVisible failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set app surface node gravity
   *
   * @param gravity gravity
   */
  public setGravity(gravity: sceneSessionManager.Gravity): void {
    if (!this.session) {
      log.showError('setGravity failed, session is null');
      return;
    }
    try {
      this.session.setFrameGravity(gravity);
    } catch (err) {
      log.showError('setGravity failed, reason: ' + JSON.stringify(err));
    }
  }

  private onMainSessionModalTypeChange(isModal: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onMainSessionModalTypeChange, state: ${isModal}`);
    this.isModal = isModal;
    SCBSceneSessionManager.getInstance().requestToTop(this.sceneInfo.screenId, this.session.persistentId);
  }

  private onWindowShadowEnableChange(isWindowShadowEnable: boolean): void {
    log.showInfo(`onWindowShadowEnableChange, state: ${isWindowShadowEnable}`);
    this.isWindowShadowEnable = isWindowShadowEnable;
    if (this.sessionData.onWindowShadowEnableChangeCallback) {
      this.sessionData.onWindowShadowEnableChangeCallback(this.isWindowShadowEnable);
    }
  }

  /**
   * save snapshot sync
   */
  public saveSnapshotSync(): void {
    if (!this.session) {
      log.showError('saveSnapshotSync failed, session is null');
      return;
    }
    try {
      this.session.saveSnapshotSync();
    } catch (err) {
      log.showError('saveSnapshotSync failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * save snapshot async
   */
  public saveSnapshotAsync(): void {
    if (!this.session) {
      log.showError('saveSnapshotAsync failed, session is null');
      return;
    }
    try {
      this.session.saveSnapshotAsync();
    } catch (err) {
      log.showError('saveSnapshotAsync failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * get session snapshot with freeze.
   * render service will use this snapshot to freeze app draw when secondary param is true and
   * setWindowFreeze with true
   * use this method with setWindowFreeze when you need
   * @param scaleValue scale
   * @param isFreeze
   * @param blurRadius blur radius
   * @returns snapshot
   */
  public setFreezeImmediately(scaleValue: number, isFreeze: boolean, blurRadius: number): image.PixelMap | undefined {
    if (!this.session) {
      log.showError('getSessionSnapshotWithFreeze failed, session is null');
      return undefined;
    }
    try {
      return this.session.setFreezeImmediately(scaleValue, isFreeze, blurRadius);
    } catch (err) {
      log.showError('getSessionSnapshotWithFreeze failed, reason: ' + JSON.stringify(err));
    }
    return undefined;
  }

  /**
   * send event to ACE container modal
   * @param eventName: which is used to distinguish different invoking types
   * @param eventValue: which is used to carry parameters
   */
  public sendContainerModalEvent(eventName: string, eventValue: string): void {
    if (!this.session) {
      log.showError('sendContainerModalEvent failed, session is null');
      return;
    }
    try {
      this.session.sendContainerModalEvent(eventName, eventValue);
    } catch (err) {
      log.showError('sendContainerModalEvent failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * Whether session is unclearable
   *
   * @returns session is unclearable
   */
  public isUnclearable(): boolean {
    log.info(`session ${this.sceneInfo?.unclearableSession} ${this.sceneInfo?.isUnclearableInRecent}`);
    return this.sceneInfo?.unclearableSession || this.sceneInfo?.isUnclearableInRecent;
  }

  /**
   * sets whether the dragEnable attribute of the window by scb is activate or deactivate
   *
   * @param activateDrag: activate or deactivate
   */
  public setActivateDragBySystem(activateDrag: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.activateDragBySystem(activateDrag);
    } catch (err) {
      log.showError('setActivateDragBySystem failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set the UI first switch
   *
   * @param uiFirstSwitch: ui first switch
   */
  public setUIFirstSwitch(uiFirstSwitch: sceneSessionManager.RSUIFirstSwitch): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.setUIFirstSwitch(uiFirstSwitch);
    } catch (err) {
      log.showError('setUIFirstSwitch failed, reason: ' + JSON.stringify(err));
    }
  }

  public registerSubSessionRaiseToTopCallback(callback: Function): void {
    this.sessionData.subSessionRaiseToTopCallback = callback;
  }

  public registerSubSessionRaiseAboveTargetCallback(callback: Function): void {
    this.sessionData.subSessionRaiseAboveTargetCallback = callback;
  }

  public getSubSessionRaiseAboveTargetCallback(): Function | null {
    return this.sessionData.subSessionRaiseAboveTargetCallback;
  }

  public getSubSessionRaiseToTopCallback(): Function | null {
    return this.sessionData.subSessionRaiseToTopCallback;
  }

  public registerSubSessionStateChangeCallback(callback: Function): void {
    this.sessionData.subSessionStateChangeCallback = callback;
  }

  public getSubSessionStateChangeCallback(): Function | null {
    return this.sessionData.subSessionStateChangeCallback;
  }

  public registerSubSessionZLevelChangeCallback(callback: Function): void {
    this.sessionData.subSessionZLevelChangeCallback = callback;
  }

  public getSubSessionZLevelChangeCallback(): Function | null {
    return this.sessionData.subSessionZLevelChangeCallback;
  }

  /**
   * Used to add sidebar blur.
   */
  public addSidebarBlur(): void {
    if (!this.session) {
      log.showError('addSidebarBlur failed, session is null');
      return;
    }
    try {
      this.session.addSidebarBlur();
    } catch (err) {
      log.showError('addSidebarBlur failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * Used to set whether to use the default value for sidebar blur.
   * @param isDefaultSidebarBlur
   * @param isNeedAnimation
   */
  public setSidebarBlur(isDefaultSidebarBlur: boolean, isNeedAnimation: boolean): void {
    if (!this.session) {
      log.showError('setSidebarBlur failed, session is null');
      return;
    }
    try {
      this.session.setSidebarBlur(isDefaultSidebarBlur, isNeedAnimation);
    } catch (err) {
      log.showError('setSidebarBlur failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * Used to set currentRotation of recover.
   * @param currentRotation
   */
  public setCurrentRotation(currentRotation: number): void {
    if (!this.session) {
      log.showError('setCurrentRotation failed, session is null');
      return;
    }
    try {
      this.session.setCurrentRotation(currentRotation);
    } catch (err) {
      log.showError('setCurrentRotation failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * Used to set whether the scene session needs to be border-unoccupied
   *
   * @param borderUnoccupied
   */
  public setBorderUnoccupied(borderUnoccupied: boolean): void {
    if (!this.session) {
      log.showError('setBorderUnoccupied failed, session is null');
      return;
    }
    try {
      this.session.setBorderUnoccupied(borderUnoccupied);
    } catch (err) {
      log.showError('setBorderUnoccupied failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * Used to set whether to use the maximize value for sidebar blur.
   * @param isMaximize
   */
  public setSidebarBlurMaximize(isMaximize: boolean): void {
    if (!this.session) {
      log.showError('setSidebarBlurMaximize failed, session is null');
      return;
    }
    try {
      this.session.setSidebarBlurMaximize(isMaximize);
    } catch (err) {
      log.showError('setSidebarBlurMaximize failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * register update dragHotAreaAnimConfig callback
   *
   * @param callback
   * @param screenId
   */
  public registerUpdateDragHotAreaAnimConfigCallback(callback: Function, screenId?: number): void {
    let screen = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    log.showInfo(`registerUpdateDragHotAreaAnimConfigCallback screenId:${screen}`);
    this.updateDragHotAreaAnimConfigCallbackMap.set(screen, callback);
  }

  /**
   * unregister update dragHotAreaAnimConfig Callback
   *
   * @param screenId
   */
  public unregisterUpdateDragHotAreaAnimConfigCallback(screenId?: number): void {
    let screen = screenId !== undefined ? screenId : this.sceneInfo.screenId;
    this.updateDragHotAreaAnimConfigCallbackMap.delete(screen);
    log.showDebug(`unregisterUpdateDragHotAreaAnimConfigCallback screenId:${screen}`);
  }

  /**
   * update dragHotAreaAnimConfig not in current screen
   *
   * @param isShow
   * @param curScreenId current screenId
   */
  public updateDragHotAreaAnimConfigNotInCurrentScreen(isShow: boolean, curScreenId: number): void {
    this.updateDragHotAreaAnimConfigCallbackMap.forEach((callback, screenId) => {
      if (screenId !== curScreenId) {
        callback(isShow);
      }
    });
  }

  /**
   * Gets the number of animation count
   *
   * @returns { number } animation count
   */
  public getAnimCount(): number {
    log.showDebug(`getAnimCount from session ${this.session.persistentId}, ${this.sessionData.animCount}`);
    return this.sessionData.animCount;
  }

  /**
   * Increase animation count
   */
  public addAnimCount(): void {
    log.showDebug(`addAnimCount ${this.session.persistentId}, ${this.sessionData.animCount}`);
    this.sessionData.animCount++;
  }

  /**
   * Clear Animation Count
   */
  public clearAnimCount(): void {
    log.showDebug(`clearAnimCount ${this.session.persistentId}, ${this.sessionData.animCount}`);
    this.sessionData.animCount = 0;
  }

  /**
   * reset animation property
   */
  public resetAnimationProperty(): void {
    this.sessionData.animationProperty = undefined;
  }

  /**
   * Gets animation property
   *
   * @returns { number } animation property
   */
  public getAnimationProperty(): sceneSessionManager.WindowAnimationProperty | undefined {
    return this.sessionData.animationProperty;
  }

  /**
   * Gets animation option
   *
   * @returns { number } animation option
   */
  public getAnimationOption(): sceneSessionManager.WindowAnimationOptions | undefined {
    return this.sessionData.animationOption;
  }

  /**
   * register on update session isWindowShadowEnable callback
   *
   * @param { Function } callback
   */
  public registerOnWindowShadowEnableChangeCallback(callback: Function): void {
    log.showInfo('registerOnWindowShadowEnableChangeCallback');
    this.sessionData.onWindowShadowEnableChangeCallback = callback;
    this.sessionData.onWindowShadowEnableChangeCallback(this.isWindowShadowEnable);
  }

  /**
   * unregister on update session isWindowShadowEnable callback
   */
  public unRegisterOnWindowShadowEnableChangeCallback(): void {
    log.showDebug(`unRegisterOnWindowShadowEnableChangeCallback`);
    this.sessionData.onWindowShadowEnableChangeCallback = null;
  }

  public isMatchWithoutAbilityName(sceneInfo: SCBSceneInfo): boolean {
    if (sceneInfo.bundleName === this.sceneInfo.bundleName &&
      sceneInfo.moduleName === this.sceneInfo.moduleName &&
      sceneInfo.appIndex === this.sceneInfo.appIndex) {
      return true;
    }
    return false;
  }

  /**
   * Get isFixedMultiWindowOrientation used for check preferMultiWindowOrientation is fixed with LANDSCAPE or PORTRAIT
   * @returns true: isFixedMultiWindowOrientation, otherwise not
   */
  public get isFixedMultiWindowOrientation(): boolean {
    return this.sessionData.isFixedMultiWindowOrientation;
  }

  /**
   * Set isFixedMultiWindowOrientation used for check preferMultiWindowOrientation is fixed with LANDSCAPE or PORTRAIT
   * @param isFixed: boolean
   */
  public set isFixedMultiWindowOrientation(isFixedMultiWindowOrientation: boolean) {
    this.sessionData.isFixedMultiWindowOrientation = isFixedMultiWindowOrientation;
  }
}