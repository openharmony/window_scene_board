/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import type { AsyncCallback, Callback } from './@ohos.base';
import ServiceExtensionContext from './application/ServiceExtensionContext';
import type Want from '@ohos.app.ability.Want';
import type { SCBAbilityItemInfo } from '../bean/AbilityItemInfo';
import type { UIContext } from '@ohos.arkui.UIContext';
import type { RectInfo } from '../animation/SCBTransitionController';
import type Image from '@ohos.multimedia.image';
import { FocusChangeReason } from '../common/FocusChangeReason';
import { SnapshotNodeType } from '../../common/SnapshotNodeType';
import type { bundleManager } from '@ohos.bundle.bundleManager';
import type { ControlType, ControlAppInfo } from '../scene/appUseControl/SCBAppUseControlManager';
import { SCBApplicationInfo } from '../../../../../windowscene/src/main/ets/bean/AbilityItemInfo';
import uiEffect from '@ohos.graphics.uiEffect'
import { DEFAULT_REQUEST_ID } from '../../../../../windowscene/src/main/ets/scene/session/SCBSceneInfo'
import { BackgroundReason } from '../common/SCBSceneEnums';
import { CommonResultCode } from '../../../../../windowscene/src/main/ets/scene/utils/SCBSceneUtils';

/**
 * Defines the window animation curve param.
 *
 * @typedef { Array<number> } AnimationCurveParam
 * @syscap SystemCapability.Window.SessionManager
 * @atomicservice
 * @since 20
 */
declare type WindowAnimationCurveParam = Array<number>;

/**
 * Scene session manager.
 *
 * @syscap SystemCapability.Window.SceneSessionManager
 * @systemapi Hide this for inner system use.
 * @since 10
 */
declare namespace sceneSessionManager {
  /**
   * The size change reason of session.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  enum SessionSizeChangeReason {
    /**
     * Undefined reason.
     */
    UNDEFINED,
    /**
     * Maximize.
     */
    MAXIMIZE,
    /**
     * Recover.
     */
    RECOVER,
    /**
     * Rotate.
     */
    ROTATION,
    /**
     * Drag.
     */
    DRAG,
    /**
     * Start drag.
     */
    DRAG_START,
    /**
     * End drag.
     */
    DRAG_END,
    /**
     * Resize.
     */
    RESIZE,
    /**
     * Move.
     */
    MOVE,
    /**
     * Hide.
     */
    HIDE,
    /**
     * Transform.
     */
    TRANSFORM,
    /**
     * Show for custom animation.
     */
    CUSTOM_ANIMATION_SHOW,
    /**
     * From fullScreen to split.
     */
    FULL_TO_SPLIT,
    /**
     * From split to fullScreen.
     */
    SPLIT_TO_FULL,
    /**
     * From fullScreen to floating.
     */
    FULL_TO_FLOATING,
    /**
     * From floating to fullScreen.
     */
    FLOATING_TO_FULL,
    /**
     * pip start.
     */
    PIP_START,
     /**
     * pip show.
     */
    PIP_SHOW,
    /**
     * pip auto start.
     */
    PIP_AUTO_START,
    /**
     * pip content size changed.
     */
    PIP_RATIO_CHANGE,
    /**
     * pip restore.
     */
    PIP_RESTORE,
    /**
     * update dpi.
     */
    UPDATE_DPI_SYNC,
    /**
     * drag move.
     */
    DRAG_MOVE,
    /**
     * avoid area change
     */
    AVOID_AREA_CHANGE,
    /**
     * maximize to split
     */
    MAXIMIZE_TO_SPLIT,
    /**
     * split to maximize
     */
    SPLIT_TO_MAXIMIZE,
    /**
     * maximize in implict
     */
    MAXIMIZE_IN_IMPLICT,
    /**
     * page rotation
     */
    PAGE_ROTATION,
    /**
     * split drag start.
     */
    SPLIT_DRAG_START,
    /**
     * split drag.
     */
    SPLIT_DRAG,
    /**
     * split drag end.
     */
    SPLIT_DRAG_END,
    /**
     * resize by limit.
     */
    RESIZE_BY_LIMIT,
    /**
     * recover in implicit
     */
    RECOVER_IN_IMPLICIT,
    /**
     * End.
     */
    END,
  }

  enum RSUIFirstSwitch {
    /**
     * Follow RS rules.
     */
    NONE,
    /**
     * Open app with modal window animation, close uifirst.
     */
    MODAL_WINDOW_CLOSE,
    /**
     * Force close uifirst.
     */
    FORCE_DISABLE,
    /**
     * Force open uifirst.
     */
    FORCE_ENABLE,
    /**
     * Force open uifirst, but for limited.
     */
    FORCE_ENABLE_LIMIT,
    /**
     * Force close uifirst when only in nonfocus window.
     */
    FORCE_DISABLE_NONFOCUS,
  }

  /**
   * The type of session.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  enum SessionType {
    /**
     * Unknown type.
     */
    TYPE_UNDEFINED,
    /**
     * Main App.
     */
    TYPE_APP,
    /**
     * Sub App.
     */
    TYPE_SUB_APP,
    /**
     * System alert.
     */
    TYPE_SYSTEM_ALERT,
    /**
     * Input method.
     */
    TYPE_INPUT_METHOD,
    /**
     * Status bar.
     */
    TYPE_STATUS_BAR,
    /**
     * Panel.
     */
    TYPE_PANEL,
    /**
     * Keyguard.
     */
    TYPE_KEYGUARD,
    /**
     * Volume.
     */
    TYPE_VOLUME_OVERLAY,
    /**
     * Navigation bar.
     */
    TYPE_NAVIGATION_BAR,
    /**
     * Float.
     */
    TYPE_FLOAT,
    /**
     * Wallpaper.
     */
    TYPE_WALLPAPER,
    /**
     * Desktop.
     */
    TYPE_DESKTOP,
    /**
     * Dock.
     */
    TYPE_LAUNCHER_DOCK,
    /**
     * Float camera.
     */
    TYPE_FLOAT_CAMERA,
    /**
     * Dialog.
     */
    TYPE_DIALOG,
    /**
     * Screenshot.
     */
    TYPE_SCREENSHOT,
    /**
     * Toast.
     */
    TYPE_TOAST,
    /**
     * Pointer.
     */
    TYPE_POINTER,
    /**
     * Launcher recent.
     */
    TYPE_LAUNCHER_RECENT,
    /**
     * Scene board.
     */
    TYPE_SCENE_BOARD,
    /**
     * Dragging effect.
     */
    TYPE_DRAGGING_EFFECT,
    /**
     * Input method status bar.
     */
    TYPE_INPUT_METHOD_STATUS_BAR,
    /**
     * Global search.
     */
    TYPE_GLOBAL_SEARCH,
    /**
     * Negative screen.
     */
    TYPE_NEGATIVE_SCREEN,
    /**
     * void interaction.
     */
    TYPE_VOICE_INTERACTION,
    /**
     * System Toast.
     */
    TYPE_SYSTEM_TOAST,
    /**
     * System Float.
     */
    TYPE_SYSTEM_FLOAT,
    /**
     * Picture in picture.
     */
    TYPE_PIP,
    /**
     * side edge bar
     */
    TYPE_SIDE_EDGE_BAR,
    /**
     * Navigation aiBar.
     */
    TYPE_NAVIGATION_INDICATOR,
    /**
     * Handwrite.
     */
    TYPE_HANDWRITE,
    /**
      * Keyboard panel.
     */
    TYPE_KEYBOARD_PANEL,
    /**
     * gesture panel.
     */
    TYPE_SPACED_GESTURE,
    /**
     * formCenter.
     */
    TYPE_FORM_CENTER,
    /**
     * transparent view.
     */
    TYPE_TRANSPARENT_VIEW = 36,
    /**
     * wallet swipe card
     */
    TYPE_WALLET_SWIPE_CARD = 37,
    /**
     * screen control
     */
    TYPE_SCREEN_CONTROL = 38,
    /**
     * float navigation
     */
    TYPE_FLOAT_NAVIGATION = 39,
    /**
     * mutiScreen collaboration
     */
    TYPE_MUTISCREEN_COLLABORATION = 40,
    /**
     * dynamic
     */
    TYPE_DYNAMIC = 41,
    /**
     * magnification
     */
    TYPE_MAGNIFICATION = 42,
    /**
     * magnification menu
     */
    TYPE_MAGNIFICATION_MENU = 43,
    /**
     * selection
     */
    TYPE_SELECTION = 44,
    /**
     * floating ball
     */
    TYPE_FLOATING_BALL = 45,
  }

  /**
   * Type of the sub session modal.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   * @since 12
   */
  enum SubWindowModalType {
    /**
     * Unknown type.
     */
    TYPE_UNDEFINED,
    /**
     * Normal Subwindow Type.
     */
    TYPE_NORMAL,
    /**
     * Dialog window Type.
     */
    TYPE_DIALOG,
    /**
     * Modal Window Type.
     */
    TYPE_WINDOW_MODALITY,
    /**
     * Toast Window Type.
     */
    TYPE_TOAST,
    /**
     * Modal Application Type.
     */
    TYPE_APPLICATION_MODALITY,
    /**
     * Text Menu Window Type.
     */
    TYPE_TEXT_MENU
  }

  /**
   * The ability visibility after the new process startup.
   * This property only takes effect when calling UIAbilityContext.startAbility.
   * The properties processMode and startupVisibility must be set simultaneously.
   *
   * @type { ?contextConstant.StartupVisibility }
   * @syscap SystemCapability.Window.SceneSessionManager
   * @stagemodelonly
   * @since 12
   */
  enum StartupVisibility {
    UNSPECIFIED = -1,
    STARTUP_HIDE = 0,
    STARTUP_SHOW = 1,
    END
  }

  /**
   * The process mode.
   * This property only takes effect when calling UIAbilityContext.startAbility.
   * The properties processMode and startupVisibility must be set simultaneously.
   *
   * @type { ?contextConstant.ProcessMode }
   * @syscap SystemCapability.Window.SceneSessionManager
   * @stagemodelonly
   * @since 12
   */
  enum ProcessMode {
    UNSPECIFIED = 0,
    NEW_PROCESS_ATTACH_TO_PARENT = 1,
    NEW_PROCESS_ATTACH_TO_STATUS_BAR_ITEM = 2,
    END
  }

  /**
   * Enum for control type.
   *
   * @enum { number }.
   * @syscap SystemCapability.Window.SessionManager
   * @since 12
   */
  enum PiPControlType {
    VIDEO_PLAY_PAUSE,
    VIDEO_PREVIOUS,
    VIDEO_NEXT,
    FAST_FORWARD,
    FAST_BACKWARD,
    HANG_UP_BUTTON,
    MICROPHONE_SWITCH,
    CAMERA_SWITCH,
    MUTE_SWITCH,
    END
  }

  /**
   * Enum for control status.
   *
   * @enum { number }.
   * @syscap SystemCapability.Window.SessionManager
   * @since 12
   */
  enum PiPControlStatus {
    PLAY = 1,
    PAUSE = 0,
    OPEN = 1,
    CLOSE = 0,
    ENABLED = -2,
    DISABLED = -3,
  }

  enum FloatingBallTemplate {
    /**
     * Static layout, support icon and title.
     *
     */
    STATIC = 1,

    /**
     * Normal layout, support title and content with different color.
     *
     */
    NORMAL = 2,

    /**
     * Emphatic layout, support title and content with different size.
     *
     */
    EMPHATIC = 3,

    /**
     * Simple layout, support title with 2-lines display.
     *
     */
    SIMPLE = 4,
  }
  /**
   * Enum for gravity.
   *
   * @enum { number }.
   * @syscap SystemCapability.Window.SessionManager
   * @since 13
   */
  enum Gravity {
    CENTER = 0,
    TOP,
    BOTTOM,
    LEFT,
    RIGHT,
    TOP_LEFT,
    TOP_RIGHT,
    BOTTOM_LEFT,
    BOTTOM_RIGHT,
    RESIZE,
    RESIZE_ASPECT,
    RESIZE_ASPECT_TOP_LEFT,
    RESIZE_ASPECT_BOTTOM_RIGHT,
    RESIZE_ASPECT_FILL,
    RESIZE_ASPECT_FILL_TOP_LEFT,
    RESIZE_ASPECT_FILL_BOTTOM_RIGHT,
  }

  /**
   * Enum for app drag resize type..
   *
   * @enum { number }.
   * @syscap SystemCapability.Window.SessionManager
   * @since 13
   */
  enum DragResizeType {
    RESIZE_TYPE_UNDEFINED = 0,
    RESIZE_EACH_FRAME = 1,
    RESIZE_WHEN_DRAG_END = 2,
    RESIZE_SCALE = 3,
  }

  /**
   * The process option
   */
  interface ProcessOptions {
    processMode: ProcessMode,
    startupVisibility: StartupVisibility
  }

  /**
   * The type of windowScene
   */
  enum SceneType {
    DEFAULT = 0,
    WINDOW_SCENE,
    SYSTEM_WINDOW_SCENE,
    TRANSFORM_SCENE,
    PANEL_SCENE,
    INPUT_SCENE,
  }

  /**
   * The view mode of keyboard
   */
  enum KeyboardViewMode {
    NON_IMMERSIVE_MODE = 0,
    IMMERSIVE_MODE,
    LIGHT_IMMERSIVE_MODE,
    DARK_IMMERSIVE_MODE,
    VIEW_MODE_END,
  }

  enum KeyboardFlowLightMode {
    NONE = 0,
    BACKGROUND_FLOW_LIGHT,
    END,
  }

  enum KeyboardGradientMode {
    NONE = 0,
    LINEAR_GRADIENT,
    END,
  }

  interface KeyboardEffectOption {
    viewMode: KeyboardViewMode;
    flowLightMode: KeyboardFlowLightMode;
    gradientMode: KeyboardGradientMode;
    blurHeight: number;
  }

  /**
   * compatible mode property
   */
  interface CompatibleModeProperty {
    isAdaptToImmersive?: boolean;
    isAdaptToEventMapping?: boolean;
    isAdaptToProportionalScale?: boolean;
    isAdaptToBackButton?: boolean;
    isAdaptToDragScale?: boolean;
    disableDragResize?: boolean;
    disableResizeWithDpi?: boolean;
    disableFullScreen?: boolean;
    disableSplit?: boolean;
    disableWindowLimit?: boolean;
    disableDecorFullscreen?: boolean;
    isSupportRotateFullScreen?: boolean;
    isAdaptToSimulationScale?: boolean;
    isAdaptToSubWindow?: boolean;
  }

  /**
   * The information of a scene.
   */
  interface SceneInfo {
    /**
     * The bundle name of the scene.
     */
    bundleName: string;
    /**
     * The module name of the scene.
     */
    moduleName: string;
    /**
     * The ability name of the scene.
     */
    abilityName: string;
    /**
     * The app index of the scene.
     */
    appIndex: number;
    /**
     * Whether the scene is system scene.
     */
    isSystem?: boolean;
    /**
     * The scene persistentId
     */
    persistentId?: number;
    /**
     * caller persistent id
     */
    callerPersistentId?: number;
    /**
     * caller bundle name
     */
    callerBundleName?: string;
    /**
     * caller ability name
     */
    callerAbilityName?: string;
    /**
     * Whether the scene is caller to background.
     */
    callState?: number;
    /**
     * Type of session
     */
    sessionType?: SessionType;

    /**
     * mode of window scene
     */
    windowMode?: number;

    /**
     * the scene is in screen.
     */
    screenId?: number;

    /**
     * is request from persistent recover
     */
    isPersistentRecover?: boolean;

    /**
     * the state of session.
     */
    sessionState?: number;

    /**
     * the orientation of scene.
     */
    requestOrientation?: number;

    /**
     * custom window top
     */
    windowTop?: number;

    /**
     * custom window left
     */
    windowLeft?: number;

    /**
     * custom window width
     */
    windowWidth?: number;

    /**
     * custom window height
     */
    windowHeight?: number;

    /**
     * custom max window width
     */
    maxWindowWidth?: number;

     /**
      * custom min window width
      */
    minWindowWidth?: number;

     /**
      * custom max window height
      */
    maxWindowHeight?: number;

     /**
      * custom min window height
      */
    minWindowHeight?: number;

    /**
     * Input type of windowscene
     */
    windowInputType?: number;

    /**
     * custom window whether start with animations
     */
    withAnimation?: boolean;

    /**
     * custom window whether focused while on start
     */
    focusedOnShow?: boolean;

    isSystemInput?: boolean;
    sceneType? : SceneType;
    isSetPointerAreas?: boolean;
    isRotatable?: boolean;

    /**
     * custom window whether on cast scene
     */
    isCastSession?: boolean;

    /**
     * is called by the scene with callId
     */
    isCalledRightlyByCallerId?: boolean;

    /**
     * start enter immersive fullScreen
     */
    fullScreenStart?: boolean;

    /**
     *  atomic service flag used in install-free scene
     */
    isAtomicService?: boolean;

    /**
     *  whether in install-free mode
     */
    isStartupInstallFree?: boolean;

    fileManagerMode?: string;

    floatingDisplayMode?: number;

    extraFormIdentity?: string;

    /**
     *  whether start ability or back to caller
     */
    isBackTransition?: boolean;

    /**
     * The process option from ability
     */
    processOptions?: ProcessOptions;

    /**
     * The reason of exception
     */
    errorReason?: string;

    /**
     * should skip kill in startup
     */
    shouldSkipKillInStartup?: boolean;

    /**
     * whether to clear in notShowRecent
     */
    needClearInNotShowRecent?: boolean;

    /**
     * whether create new instance
     */
    isNewAppInstance?: boolean;

    /**
     * instance key for multi instance
     */
    appInstanceKey?: string;

    /**
     * whether is start from icon
     */
    isFromIcon?: boolean;

    /**
     * Indicates which window mode is supported
     */
    supportWindowModes?: Array<bundleManager.SupportWindowMode>;

    expectWindowMode?: number;

    isStartFromAppDock?: boolean;

    dockAppDirection?: number;

    isAppFromRecentAppsOrDockApps?: number;

    /**
     * The want of the scene.
     */
    want?: Want;

    /**
     * Indicates whether the ability is hooked
     */
    isAbilityHook?: boolean;

    /**
     * Indicates whether the window is a control window.
     */
    isAppUseControl?: boolean;

    /**
     * Indicates whether the window has privacy mode control.
     */
    hasPrivacyModeControl?: boolean;

    /**
     * The specifiedFlag of the session
     */
    specifiedFlag?: string;

    /**
     * The animation configuration of start system scene animation
     */
    startAnimationSystemOptions?: StartAnimationSystemOptions;

    /**
     * The animation configuration of start scene animation
     */
    startAnimationOptions?: StartAnimationOptions;

    atomicServiceInfo?: AtomicServiceInfo;

    /**
     * The requestId of the scene.
     */
    requestId?: number;

    /**
     * label
     */
    label?: string;
  }

  /**
   * The animation configuration of start system scene animation
   *
   * @interface StartAnimationSystemOptions
   * @syscap SystemCapability.Window.SessionManager
   * @systemapi
   * @since 20
   */
  interface StartAnimationSystemOptions {
    /**
     * The type of window animation
     *
     * @type { AnimationType }
     * @syscap SystemCapability.Window.SessionManager
     * @systemapi
     * @since 20
     */
    type: AnimationType;
    /**
     * The config of start system scene animation
     *
     * @type { ?WindowAnimationOptions }
     * @syscap SystemCapability.Window.SessionManager
     * @systemapi
     * @since 20
     */
    animationConfig?: WindowAnimationOptions;
  }

  /**
   * The animation configuration of start scene animation
   *
   * @interface StartAnimationOptions
   * @syscap SystemCapability.Window.SessionManager
   * @since 20
   */
  interface StartAnimationOptions {
    /**
     * The type of window animation
     *
     * @type { AnimationType }
     * @syscap SystemCapability.Window.SessionManager
     * @since 20
     */
    type: AnimationType;
  }

  /**
   * AtomicServiceInfo
   *
   * @interface AtomicServiceInfo
   * @syscap SystemCapability.Window.SessionManager
   * @since 20
   */
  interface AtomicServiceInfo {
    /**
     * resizable for compatible mode
     */
    resizable: number;

    /**
     * deviceTypes for compatible mode
     */
    deviceTypes: Array<string>;

    /**
     * supportWindowMode for compatible mode
     */
    supportWindowMode: Array<string>;
  }

  /**
   * sub window anchor to parent window
   */
  enum WindowAnchor {
    TOP_START,
    TOP,
    TOP_END,
    START,
    CENTER,
    END,
    BOTTOM_START,
    BOTTOM,
    BOTTOM_END,
  }

  interface WindowAnchorInfo {
    isAnchorEnabled: boolean;
    windowAnchor?: WindowAnchor;
    offsetX?: number;
    offsetY?: number;
  }

  /**
   * exception info.
   */
  interface ExceptionInfo {
    needRemoveSession?: boolean;
    needClearCallerLink?: boolean;
  }

  /**
   * The information of scene recovery
   */
  interface SceneRecoverInfo {
    /**
     * The bundle name of the scene.
     */
    bundleName: string;

    /**
     * The module name of the scene.
     */
    moduleName: string;

    /**
     * The ability name of the scene.
     */
    abilityName: string;

    /**
     * The app index of the scene.
     */
    appIndex: number;

    /**
     * the scene is in screen.
     */
    screenId: number;

    /**
     * mode of window scene
     */
    windowMode: number;

    /**
     * the state of session.
     */
    sessionState: number;

    /**
     * Type of session
     */
    sessionType: SessionType;

    /**
     * the orientation of scene.
     */
    requestOrientation: number;

    /**
     * rect layout before scb crash
     */
    recoverRect: SessionRect;

    /**
     * Is layout full screen
     */
    layoutFullScreen: boolean;

    /**
     * Is main window topmost
     */
    mainWindowTopmost: boolean;

    /**
     * Is full screen waterfall mode
     */
     isFullScreenWaterfallMode: boolean;

    /**
     * currentRotation of scene.
     */
    currentRotation: number;

    /**
     * custom transition animation config of scene.
     */
    transitionAnimationMap: Map<sceneSessionManager.WindowTransitionType, sceneSessionManager.TransitionAnimation>;

    /**
     * System Bar Property Array.
     */
    systemBarProperties: Array<SCBSystemBarPropertyInner>;

    /**
     * Indicates which window mode is supported
     */
    supportWindowModes: Array<bundleManager.SupportWindowMode>;
  }

  enum SessionState {
    /**
     * Session is disconnect.
     */
    STATE_DISCONNECT,
    /**
     * Session is on connect.
     */
    STATE_CONNECT,
    /**
     * Session is on foreground.
     */
    STATE_FOREGROUND,
    /**
     * Session is active.
     */
    STATE_ACTIVE,
    /**
     * Session is inactive.
     */
    STATE_INACTIVE,
    /**
     * Session is background.
     */
    STATE_BACKGROUND,
    /**
     * Session is end.
     */
    STATE_END,
  }

  /**
   * The gravity of keyboard.
   */
  enum KeyboardGravity {
    GRAVITY_FLOAT,
    GRAVITY_BOTTOM,
    GRAVITY_DEFAULT
  }

  interface KeyboardLayoutParams {
    gravity: KeyboardGravity;
    landscapeAvoidHeight: number;
    portraitAvoidHeight: number;
    landscapeKeyboardRect: SessionRect;
    portraitKeyboardRect: SessionRect;
    landscapePanelRect: SessionRect;
    portraitPanelRect: SessionRect;
    displayId: number;
  }

  /**
   * Round rect.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface SessionRect {
    posX_: number;

    posY_: number;

    width_: number;

    height_: number;
  }

  interface SystemBarProperty {
    type: SessionType;

    enable: boolean;

    backgroundcolor: string;

    contentcolor: string;

    enableAnimation: boolean;

    settingFlag: number;
  }

  /**
   * PipTemplateInfo.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface PipTemplateInfo {
    pipTemplateType: number;

    priority: number;

    controlGroup: Array<number>;

    pipControlStatusInfoList: Array<PiPControlStatusInfo>;

    pipControlEnableInfoList: Array<PiPControlEnableInfo>;

    defaultWindowSizeType: number;
  }

  /**
   * Picture-in-picture control status info.
   */
  interface PiPControlStatusInfo {
    controlType: PiPControlType;

    status: PiPControlStatus;
  }

  /**
   * FbTemplateInfo.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  export interface FbTemplateInfo {
    /**
     * The template of floating-ball.
     *
     */
    template: FloatingBallTemplate;

    /**
     * The title of floating-ball.
     *
     */
    title: string;

    /**
     * The content of floating-ball.
     *
     */
    content?: string;

    /**
     * The backgroundColor of floating-ball.
     *
     */
    backgroundColor?: string;

    /**
     * The icon of floating-ball.
     *
     */
    icon?: Image.PixelMap;
  }

  /**
   * Picture-in-picture control enable status info.
   */
  interface PiPControlEnableInfo {

    controlType: PiPControlType;

    enabled: PiPControlStatus;
  }

  /**
   * Parameters carried in the session event
   */
  interface SessionEventParam {
    /**
     * X coordinate of the mouse pointer.
     */
    pointerX: number;

    /**
     * Y coordinate of the mouse pointer.
     */
    pointerY: number;

    /**
     * the current width of resize.
     */
    sessionWidth: number;

    /**
     * the current height of resize.
     */
    sessionHeight: number;

    /**
     * the current drag resize type.
     */
    dragResizeType: number;

    /**
     * the current drag gravity.
     */
    gravity: number;
  }

  /**
   * The session of a scene.
   */
  interface SceneSession {
    /**
     * Persistent identifier of the scene session.
     */
    readonly persistentId: number;

    /**
     * ParentId of the scene session.
     */
    parentId: number;

    /**
     * Type of the scene session.
     */
    readonly type: SessionType;

    /**
     * Type of the scene session creator.
     */
    readonly isAppType: boolean;

    /**
     * Type of the sub session modal.
     */
    subWindowModalType: SubWindowModalType;

    /**
     * Type of the sub session application modal.
     */
    subWindowAppModalType: SubWindowModalType;

    /**
     * The opertion type for the session in native, 1:clear
     * Please see SessionOperatorType for more information
     */
    operatorType: number;

    /**
     * information of pip template, only available in session_type_pip
     */
    pipTemplateInfo: PipTemplateInfo;

    /**
     * information of floating ball template, only available in sessionType FLOATING_BALL
     */
    fbTemplateInfo: FbTemplateInfo;

    /**
     * gravity of keyboard
     */
    keyboardGravity: KeyboardGravity;

    /**
     * isTopmost of the scene session, only for modal subwindow.
     */
    isTopmost: boolean;

    /**
     * zLevel of the scene session, only for subwindow.
     */
    zLevel: number;

    /**
      * zIndex of the specific session, only for DYNAMIC.
      */
    zIndex: number;

    /**
     * isUIExtFirstSubWindow, only for subwindow.
     */
    isUIExtFirstSubWindow?: boolean;

    /**
     * windowHeight is the Height at which the app was launched.
     */
    windowHeight: number;

    /**
     * windowWidth is the Width at which the app was launched.
     */
    windowWidth: number;

    /**
     * windowLeft is the left at which the app was launched.
     */
    windowLeft: string;

    /**
     * windowTop is the top at which the app was launched.
     */
    windowTop: string;

    /**
     * isMaximize is the application enters maximized mode when it starts.
     */
    isMaximize: boolean;

    /**
     * isRightAngle of the scene session, only for main window.
     */
    isRightAngle: boolean;

    /**
     * screenId
     */
    screenId: number;

    /**
     * app instance key
     */
    appInstanceKey: string;

    /**
     * isSystemKeyboard of the scene session, only for keyboard window.
     */
    readonly isSystemKeyboard: boolean;

    /**
     * bundle name of the scene session.
     */
    readonly bundleName: String;

    /**
     * whether show sub window outline.
     */
    subWindowOutlineEnabled: boolean;

    /**
     * window name of the scene session.
     */
    readonly windowName: string;

    /**
     * Register the callback of pending another scene session activation from this scene session.
     * @param type: 'pendingSceneSessionActivation'
     */
    on(type: 'pendingSceneSessionActivation', callback: Callback<SceneInfo>): void;

    /**
     * Register the callback of creating specific session from this scene session.
     * @param type: 'createSpecificSession'
     */
    on(type: 'createSpecificSession', callback: Callback<SceneSession>): void;

    /**
     * Register the callback of set parent session
     * @param type: 'setParentSession'
     */
    on(type: 'setParentSession', callback: Callback<number, number>): void;

    /**
     * Registers the frame layout finish callback.
     * After changing the rect of window, the callback will be triggered once.
     * Currently, only updateRect with multi-window SessionSizeChangeReason is enabled.
     * @param type: 'nextFrameLayoutFinish'
     */
    on(type: 'nextFrameLayoutFinish', callback: Callback<void>): void;

    /**
     * Register the callback of state change of this scene session.
     * @param type: 'sessionStateChange'
     */
    on(type: 'sessionStateChange', callback: Callback<SessionState>): void;

    /**
     * Register the callback of state change for keyboard session.
     * @param type: 'keyboardStateChange'
     */
    on(type: 'keyboardStateChange', callback: Callback<SessionState, KeyboardEffectOption>): void;

    /**
     * Register the callback of keyboard view mode change
     * @param type: 'keyboardEffectOptionChange'
     */
    on(type: 'keyboardEffectOptionChange', callback: Callback<KeyboardEffectOption>): void;

    /**
     * Register the callback of state change of this scene session's bufferAvailable.
     * @param type: 'bufferAvailableChange'
     */
    on(type: 'bufferAvailableChange', callback: Callback<boolean, boolean>): void;

    /**
     * Register the callback of scene session event.
     * @param type: 'sessionEvent'
     * @param callback: 'eventId, eventParam'
     */
    on(type: 'sessionEvent', callback: Callback<number, SessionEventParam>): void;

    /**
     * Register the callback of rect change of this scene session.
     * @param type: 'sessionRectChange'
     */
    on(type: 'sessionRectChange', callback: Callback<number, SessionRect, SessionSizeChangeReason>): void;

    /**
     * Register the callback of displayId change of this scene session.
     * @param type: 'sessionDisplayIdChange'
     */
    on(type: 'sessionDisplayIdChange', callback: Callback<number>): void;

    /**
     * Register the callback of pip control status change of this scene session.
     * @param type: 'sessionPiPControlStatusChange'
     */
    on(type: 'sessionPiPControlStatusChange', callback: Callback<PiPControlType, PiPControlStatus>): void;
    /**
     * @param type
     * @param callback
     * Register the callback of  full screen layout change
     * @param type: 'layoutFullScreenChange'
     */
    on(type: 'layoutFullScreenChange', callback: Callback<boolean>):void;

    /**
     * @param type
     * @param callback
     * Register the callback of default density enabled
     * @param type: 'defaultDensityEnabled'
     */
    on(type: 'defaultDensityEnabled', callback: Callback<boolean>): void;

    /**
     * @param type
     * @param callback
     * Register the callback of  statusbar, title and dock visible change
     * @param type: 'titleAndDockHoverShowChange'
     */
    on(type: 'titleAndDockHoverShowChange', callback: Callback<boolean, boolean>): void;

    /**
     * Register the callback of restore the main window.
     * @param type: 'restoreMainWindow'
     */
    on(type: 'restoreMainWindow', callback: AsyncCallback<void>):void;

    /**
     * Register the callback of session force hide change of this scene session.
     * @param type: 'sessionForceHideChange'
     */
    on(type: 'sessionForceHideChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of raise to top of this scene session.
     * @param type: 'raiseToTop'
     */
    on(type: 'raiseToTop', callback: AsyncCallback<void>): void;

    /**
     * Register the callback of raise to top for point down of this scene session.
     * @param type: 'raiseToTopForPointDown'
     */
    on(type: 'raiseToTopForPointDown', callback: AsyncCallback<void>): void;

    /**
     * Register the callback of raise above target of this scene session.
     * @param type: 'raiseAboveTarget'
     */
    on(type: 'raiseAboveTarget', callback: AsyncCallback<number>): void;

    /**
     * Register the callback of raise main window above target of this scene session.
     * @param type: 'raiseMainWindowAboveTarget'
     */
    on(type: 'raiseMainWindowAboveTarget', callback: Callback<number>): void;

    /**
     * Register the callback of change zLevel of this scene session.
     * @param type: 'zLevelChange'
     * @param callback: 'zLevel'
     */
    on(type: 'zLevelChange', callback: Callback<number>): void;

    /**
     * Register the callback of backPressed.
     * @param type: 'backPressed'
     */
    on(type: 'backPressed', callback: Callback<boolean>): void;

    /**
     * Register the callback of terminate scene session.
     * @param type: 'terminateSession'
     */
    on(type: 'terminateSession', callback: AsyncCallback<void>): void;

    /**
     * Register the callback of terminate scene session.
     * @param type: 'terminateSessionNew'
     * @param callback: 'needRestartCaller, needRemoveSession, isForceClean'
     */
    on(type: 'terminateSessionNew', callback: AsyncCallback<Boolean, Boolean, Boolean>): void;

    /**
     * Register the callback of session exception.
     * @param type: 'sessionException'
     * @param callback: 'info, ExceptionInfo, startFail'
     */
    on(type: 'sessionException', callback: Callback<SceneInfo, ExceptionInfo, boolean>): void;

    /**
     * Register the callback of session update label.
     * @param type: 'updateSessionLabel'
     */
    on(type: 'updateSessionLabel', callback: Callback<string>): void;

    /**
     * Register the callback of session update icon.
     * @param type: 'updateSessionIcon'
     */
    on(type: 'updateSessionIcon', callback: Callback<string>): void;

    /**
     * Register the callback of session update transition animation.
     * @param type: 'updateTransitionAnimation'
     */
    on(type: 'updateTransitionAnimation', callback: Callback<WindowTransitionType, TransitionAnimation>): void;

    /**
     * Register the callback of backPressed.
     * @param type: 'backPressed'
     */
    on(type: 'backPressed', callback: Callback<void>): void;

    /**
     * Register the callback of focusable change of this scene session
     * @param type: 'sessionFocusableChange'
     */
    on(type: 'sessionFocusableChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of subWindow change of this scene session
     * @param type: 'setSCBWindowAnimationConfig'
     */
    on(type: 'needDefaultAnimationFlagChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of touchable change of this scene session
     * @param type: 'sessionTouchableChange'
     */
    on(type: 'sessionTouchableChange', callback: Callback<boolean>): void;

    /**
     * Registers a callback outside of the touch modal window
     * @param type: 'clickModalWindowOutside'
     */
    on(type: 'clickModalWindowOutside', callback: Callback<void>): void;

    /**
     * Register the callback of topmost change of this scene session
     * @param type: 'sessionTopmostChange'
     */
    on(type: 'sessionTopmostChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of main window topmost change of this scene session
     * @param type: 'mainWindowTopmostChange'
     */
    on(type: 'mainWindowTopmostChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of modal type change of this scene session
     * @param type: 'subModalTypeChange'
     */
    on(type: 'subModalTypeChange', callback: Callback<SubWindowModalType>): void;

    /**
     * Register the callback of follow parent rect
     * @param type: 'followParentRect'
     */
    on(type: 'followParentRect', callback: Callback<boolean>): void;

    /**
     * Register the callback of sub window anchor info change
     * @param type: 'windowAnchorInfoChange'
     */
    on(type: 'windowAnchorInfoChange', callback: Callback<WindowAnchorInfo>): void;

    /**
     * Register the callback of remove sub session cache
     * @param type: 'clearSubSession'
     */
    on(type: 'clearSubSession', callback: Callback<number>): void;

    /**
     * Register the callback of main widow modal type change of this scene session
     * @param type: 'mainModalTypeChange'
     */
    on(type: 'mainModalTypeChange', callback: Callback<boolean>): void;

    /**
     * Register the callback for whether the main window shadow is enabled or not
     * @param type: 'windowShadowEnableChange'
     */
    on(type: 'windowShadowEnableChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of showWhenLocked change of this scene session
     * @param type: 'sessionShowWhenLockedChange'
     */
    on(type: 'sessionShowWhenLockedChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of session throw slip animation state change
     */
    on(type: 'throwSlipAnimationStateChange', callback: Callback<boolean, boolean>): void;

    /**
     * Register the callback of session fullscreen waterfall mode change
     */
    on(type: 'fullScreenWaterfallModeChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of click event of this scene session
     * @param type: 'click'
     */
    on(type: 'click', callback: Callback<boolean>): void;

    /**
     * Register the callback of systemBarProperty change of this scene session
     * @param type: 'systemBarPropertyChange'
     */
    on(type: 'systemBarPropertyChange', callback: Callback<Array<SystemBarProperty>>): void;

    /**
     * Register the callback of needAvoid status change of this scene session
     * @param type: 'needAvoid'
     */
    on(type: 'needAvoid', callback: Callback<boolean>): void;

    /**
     * Register the callback of move scene session foreground.
     * @param type: 'moveForeground'
     */
    on(type: 'pendingSessionToForeground', callback: AsyncCallback<void>): void;

    /**
     * Register the callback of move scene session background.
     * @param type: 'moveBackground'
     */
    on(type: 'pendingSessionToBackgroundForDelegator', callback: Callback<SceneInfo, boolean>): void;

    /**
     * Register the callback of pending session to background.
     * @param type: 'pendingSessionToBackground'.
     */
    on(type: 'pendingSessionToBackground', callback: Callback<SceneInfo, boolean, Record<string, Object>>): void;

    /**
     * Register the callback of whether custom animation is playing.
     * @param type: 'isPlaying'
     */
    on(type: 'isCustomAnimationPlaying', callback: Callback<boolean>): void;

    /**
     * Register the callback of whether landscapeMultiWindow.
     * @param type 'isLandscapeMultiWindow'
     * @param callback
     */
    on(type: 'landscapeMultiWindow', callback: Callback<boolean>): void;

    /**
     * Register the callback of whether requested orientation changed.
     * @param type: 'sessionRequestedOrientationChange'
     * @param callback: requested orientation, whether the rotation is page rotation'
     */
    on(type: 'sessionRequestedOrientationChange', callback: Callback<number, boolean>): void;

    on(type: 'sessionGetTargetOrientationConfigInfo', callback: Callback<number>): void;

    /**
     * Register the callback of bindDialogTarget.
     * @param type: 'dialog session'
     */
    on(type: 'bindDialogTarget', callback: Callback<SceneSession>): void;

    /**
     * Register the callback of windowDragHotArea.
     * @param type: 'windowHotAreaType,rect,reason'
     */
    on(type: 'windowDragHotArea', callback: Callback<number, number, SessionSizeChangeReason, SessionRect>): void;

    /**
     * Register the callback of touchOutside.
     * @param type: 'touchOutside'
     */
    on(type: 'touchOutside', callback: Callback<void>): void;

    /**
     * Register the callback of prepare close of this scene session
     * @param type: 'prepareCloseSession'
     */
    on(type: 'prepareClosePiPSession', callback: Callback<void>): void;

    /**
     * Register the callback when ability changes Visibility of a window
     * this will switch the status between foreground and hidden
     * hidden: like background but window will not shown in dock and status bar
     * @param type
     * @param callback
     */
    on(type: 'changeSessionVisibilityWithStatusBar', callback: Callback<sceneSessionManager.SceneInfo, boolean>): void;

    /**
     * Register the callback of context transparent of this scene session
     * @param type: 'contextTransparent'
     */
    on(type: 'contextTransparent', callback: Callback<void>): void;

    /**
     * Register the callback of adjust keyboard layout
     * @param type: 'adjustKeyboardLayout'
     * @param callback
     */
    on(type: 'adjustKeyboardLayout', callback: Callback<sceneSessionManager.KeyboardLayoutParams>): void;

    /**
     * Register the callback of auto start pip status
     * @param type: 'autoStartPiP'
     * @param callback
     */
    on(type: 'autoStartPiP', callback: Callback<boolean, number>): void;

    /**
     * Register the callback of updating PiP default window size from this scene session.
     * @param type: 'updatePiPTemplateInfo'
     */
    on(type: 'updatePiPTemplateInfo', callback: Callback<PipTemplateInfo>): void;

    /**
     * Register the callback of updating floating ball template info from this scene session.
     * @param type: 'updateFbTemplateInfo'
     */
    on(type: 'updateFbTemplateInfo', callback: Callback<FbTemplateInfo>): void;

    /**
     * Register the callback of prepare  remove floating ball template info from this scene session.
     * @param type: 'prepareRemoveFb'
     */
    on(type: 'prepareRemoveFb', callback: Callback<void>): void;

    /**
     * Register the callback of start floating ball Ability
     * @param type: 'startFbAbility'
     */
    on(type: 'restoreFbMainWindow', callback: Callback<Want>): void;

    /**
     * Send floating ball action event
     * @param action
     */
    sendFbActionEvent(action: 'click' | 'close'): void;


    /**
     * Register the callback of update window privacy mode
     * @param type: 'privacyModeChange'
     * @param callback
     */
    on(type: 'privacyModeChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of setting to automatically save the window rect
     * @param type: 'setWindowRectAutoSave'
     * @param callback
     */
    on(type: 'setWindowRectAutoSave', callback: Callback<boolean, boolean>): void;

    /**
     * Register the callback of setting to support window modes
     * @param type: 'setSupportWindowModes'
     * @param callback
     */
    on(type: 'setSupportWindowModes', callback: Callback<Array<bundleManager.SupportWindowMode>>): void;

    /**
     * Register the callback of update app use control
     * @param type: 'updateAppUseControl'
     * @param callback
     */
    on(type: 'updateAppUseControl', callback: Callback<ControlType, boolean, boolean>): void;

    /**
     * Registers the callback of the drag window is moving
     * @param type: 'windowMoving'
     * @param callback: 'displayId, pointerPosX, pointerPosY'
     */
    on(type: 'windowMoving', callback: Callback<number, number, number>): void;

    /**
     * Register the callback of setting corner radius of window
     * @param type: 'setWindowCornerRadius'
     * @param callback
     */
    on(type: 'setWindowCornerRadius', callback: Callback<number>): void;

    /**
     * Register the callback of setting shadows of window
     * @param type: 'setWindowShadows'
     * @param callback: Callback<WindowShadowConfig>
     */
    on(type: 'setWindowShadows', callback: Callback<WindowShadowConfig>): void;

    /**
     * Register the callback of session update label and icon.
     * @param type: 'updateSessionLabelAndIcon'
     */
    on(type: 'updateSessionLabelAndIcon', callback: Callback<string, Image.PixelMap>): void;

    /**
     * Register the callback of session lock state change
     * @param type: 'sessionLockStateChange': session is locked in recent tasks or not
     */
    on(type: 'sessionLockStateChange', callback: Callback<boolean>): void;

    /**
     * Update the specifiedFlag
     * @param type: 'updateFlag': the specifiedFlag of the session
     */
    on(type: 'updateFlag', callback: Callback<string>): void;

    /**
     * Register the callback of use implict animation of this scene session.
     * @param type: 'useImplicitAnimationChange'
     */
    on(type: 'useImplicitAnimationChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of system session to update follow screen change
     * @param type: 'sessionUpdateFollowScreenChange'
     */
    on(type: 'sessionUpdateFollowScreenChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of set sub window source
     * @param type: 'setSubWindowSource'
     */
    on(type: 'setSubWindowSource', callback: Callback<number>): void;

    /**
     * Register the callback of scene session to set animation property and animation options
     * @param type: 'setAnimationPropertyAndOptions'
     */
    on(type: 'animateToTargetProperty', callback: Callback<WindowAnimationProperty, WindowAnimationOptions>): void;
    on(type: 'callingWindowIdChange', callback: Callback<number>):void;
    /**
     * notify rotation property
     * @param rotation: window rotation
     * @param width: window width
     * @param height: window height
     */
    notifyRotationProperty(rotation: number, width: number, height: number): void;

    /**
     * Update native system scene session visibility
     * @param visibility: system scene session visibility or not
     */
    updateNativeVisibility(visibility: boolean): void;

    /**
     * set z order
     * @param zOrder: z order
     */
    setZOrder(zOrder: number): void;

    /**
     * get z order
     * @returns number
     */
    getZOrder(): number;

    /**
     * set native system scene session privacy mode
     * @param { boolean } isPrivacyMode: in private mode if true, or not if false.
     */
    setPrivacyMode(isPrivacyMode: boolean): void;

    /**
     * set the movable attribute of the window
     * @param { boolean } isMovable: if true, it can be moved, or not if false.
     */
    setMovable(isMovable: boolean): void;

    /**
     * set the visible properties of the split-screen button
     * @param { boolean } isVisible: if true, the value is visible, or not if false.
     */
    setSplitButtonVisible(isVisible: boolean): void;

    /**
     * Send events to ACE container modal
     * @param eventName: which is used to distinguish different invoking types.
     * @param eventValue: which is used to carry parameters.
     */
    sendContainerModalEvent(eventName: string, eventValue: string): void;

    /**
     * set skip event on cast plus
     * @param { boolean } isSkip: skip input event on cast plus if true, or not if false.
     */
    setSkipEventOnCastPlus(isSkip: boolean): void;

    /**
     * set native system scene session skip self when show on virtual screen
     * @param { boolean } isSkip: skip self if true, or not if false.
     */
    setSkipSelfWhenShowOnVirtualScreen(isSkip: boolean): void;

    /**
     * set native system scene session background alpha
     * @param { number } alpha: background alpha.
     */
    setSystemSceneOcclusionAlpha(alpha: number): void;

    /**
     * reset native session background alpha
     */
    resetOcclusionAlpha(): void;

    /**
     * set native system scene session force use uiFirst
     * @param { boolean } forceUIFirst: force use uiFirst if true, or not if false.
     */
    setSystemSceneForceUIFirst(forceUIFirst: boolean): void;

    /**
     * set native system scene session force use uiFirst
     * @param { boolean } isForceFlag: force use uiFirst if true, or not if false.
     * @param { boolean } isUifirstEnable: enable uiFirst if true, or not if false.
     */
    markSystemSceneUIFirst(isForceFlag: boolean, isUifirstEnable: boolean): void;

    /**
     * Sets the UI priority switch.
     * @param { RSUIFirstSwitch } uiFirstSwitch: ui first switch.
     */
    setUIFirstSwitch(uiFirstSwitch: RSUIFirstSwitch): void;

    /**
     * Set when the scene is going to show in recent view.
     */
    setShowRecent(showRecent?: boolean): void;

    /**
     * Set when the scene scale change.
     */
    setFloatingScale(scaleValue: number): void;

    /**
     * Set when the scene in mid view
     * @param isMidScene in mid view if true, or not if false.
     */
    setIsMidScene(isMidScene: boolean): void;

    /**
     * Set native focusable
     * @param isFocusable
     */
    setFocusable(isFocusable: boolean): void;

    /**
     * Set native focusable on show
     * @param isFocusableOnShow
     */
    setFocusableOnShow(isFocusableOnShow: boolean): void;

    /**
     * Set native systemFocusable
     * @param systemFocusable
     */
    setSystemFocusable(systemFocusable: boolean): void;

    /**
     * Update scene session size change reason.
     */
    updateSizeChangeReason(reason: SessionSizeChangeReason): void;

    /**
     * Set whether need sync session rect
     * @param needSync
     */
    setNeedSyncSessionRect(needSync: boolean): void;

    /**
     * notify open keyboard sync Transaction
     */
    openKeyboardSyncTransaction(): void;

    /**
     * notify close keyboard sync Transaction
     */
    closeKeyboardSyncTransaction(keyboardBaseInfo: KeyboardBaseInfo,keyboardAnimationRectConfig: KeyboardAnimationRectConfig,callingWindowInfoData: CallingWindowInfoData): void;

    /**
     * notify keyboard animation completed
     */
    notifyKeyboardAnimationCompleted(callingId: number, isShowAnimation: boolean,
      beginPanelRect: SessionRect, endPanelRect: SessionRect): void;

    /**
     * Set when the scene scale change.
     */
    setScale(scaleX: number, scaleY: number, pivotX: number, pivotY: number): void;

    /**
     * Set last rect when maximized.
     */
    setWindowLastSafeRect(posX: number, posY: number, width: number, height: number): void;

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
    setOffset(x: number, y: number): void;

    /**
     * Set the exit split flag when the session state is on background
     */
    setExitSplitOnBackground(isExitSplitOnBackground: boolean): void;

    /**
     * set keep keyboard flag
     */
    setSCBKeepKeyboard(scbKeepKeyboardFlag: boolean): void;

    /**
     * Set native full screen to system scene
     * @param isBlockingFocus: blocking focus request from lower zOrder session
     */
    setSystemSceneBlockingFocus(isBlockingFocus: boolean): void;

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
    setOffset(x: number, y: number): void;

    /**
     * Request hide keyboard.
     */
    requestHideKeyboard(): void;
    setTouchable(touchable: boolean): void;
    setWindowInputType(windowInputType: number): void;
    setExpandInputFlag(expandInputFlag: number):void;
    /**
     * Set use starting window above locked.
     * @param useStartingWindowAboveLocked use starting window or not
     */
    setUseStartingWindowAboveLocked(useStartingWindowAboveLocked: boolean): void;

    setSystemActive(isActive:boolean):void;

    /**
     * set watermark flag
     * @param isWaterMarkAdded
     */
    setWaterMarkFlag(isWaterMarkAdded: boolean): void;

    notifyDisplayStatusBarTemporarily(isTemporary: boolean): void;
    /**
     * Set picture-in-picture action event and status to client.
     *
     * @param action indicates pip action name
     * @param status indicates status associate with action
     */
    setPipActionEvent(action: string, status?: number): void;

    /**
     * Notify pip occluded state change to native.
     *
     * @param occluded indicates if occluded
     */
    notifyPipOcclusionChange(occluded: boolean);

    /**
     * Notify pip active status change to native (floating active vs side edge bar, etc.).
     *
     * @param isActive true when pip is in normal floating active state, false when stowed in side edge bar
     */
    notifyPipActiveStatusChange(isActive: boolean);

    /**
     * Notify pip size change to native.
     *
     * @param width indicates pip width
     * @param height indicates pip height
     * @param scale indicates pip zoom scale
     */
    notifyPipSizeChange(width: number, height: number, scale: number);

    /**
     * Set picture-in-picture control event and status to client.
     *
     * @param action indicates pip control name
     * @param status indicates status associate with action
     */
    setPiPControlEvent(control: PiPControlType, status?: PiPControlStatus): void;

    /**
     * Set temporarily show when locked flag
     *
     * @param isTemporarilyShowWhenLocked if show temporarily when locked
     */
    setTemporarilyShowWhenLocked(isTemporarilyShowWhenLocked: boolean): void;

    /**
     * Set skip draw window
     *
     * @param skip skip or not
     */
    setSkipDraw(skip: boolean): void;

    /**
     * Used to determine whether the pc application support phone
     * @param isSupportPhone pc application support phone or not
     */
    setAppSupportPhoneInPc(isSupportPhone: boolean): void;

    /**
     * close pc app in pad normal
     */
    pcAppInPadNormalClose(): void;

    /**
     * Set blank.
     * @param blank or not
     */
    setBlank(isAddBlank: boolean): void;

    /**
     * Set buffer available callback enable.
     * @param enable or not
     */
    setBufferAvailableCallbackEnable(enable: boolean): void;

    /**
     * Remove blank.
     */
    removeBlank(): void;

    /**
     * Add Snapshot.
     */
    addSnapshot(useFfrt?: boolean, needPersist?: boolean): void;

    /**
     * Remove Snapshot.
     */
    removeSnapshot(): void;

    /**
     * Set the exit animation of starting window enable.
     * @param enable or not
     */
    setStartingWindowExitAnimationFlag(enable: boolean): void;

    /**
     * set exclusivelyHighlighted.
     * @param exclusivelyHighlighted or not
     */
    setExclusivelyHighlighted(exclusivelyHighlighted: boolean): Promise<void>;

    /**
     * Used to sync the default requested orientation of scene
     * @param defaultRequestedOrientation the default requested orientation of scene
     */
    syncDefaultRequestedOrientation(defaultRequestedOrientation: number);

    /**
     * Used to determine whether the application adapts to PC
     * @param enable check pc application
     * @param supportRotation whether or not support Rotation.
     */
    setIsPcAppInPad(enable: boolean);

    /**
     * Used to determine whether the compatible application adapts to PC
     * @param enable check compatible mode pc application.
     */
    setIsPcAppInpadCompatibleMode(enable: boolean): void;

    /**
     * Used to determine whether or not enable the system bar on the PcAppInPad
     * @param enableSystemBar Whether or not enable the system bar.
     */
    setPcAppInpadSpecificSystemBarInvisible(enableSystemBar: boolean): void;

    /**
     * Used to determine whether or not support Horizontal on the PcAppInPad
     * @param isHorizontal whether or not support Horizontal.
     */
    setPcAppInpadOrientationLandscape(isHorizontal: boolean): void;

    /**
     * Used to set unique window dpi
     * @param useUnique is enable set unique window dpi
     * @param densityDpi window dpi
     */
     setUniqueDensityDpiFromSCB(useUnique: boolean, densityDpi: number): Promise<void>;

    /**
     * Set the scene session isPendingToBackgroundState true or not.throw error when failed.
     * @param state The session of the scene which to be background
     */
    setIsPendingToBackgroundState(state: boolean): void;

    /**
     * Set the scene session label.throw error when failed.
     * @param label The scene session label
     */
    setLabel(label: string): void;

    /**
     * Used to determine whether the application can resize by drag or not
     * @param enable or not
     */
    setWindowEnableDragBySystem(enable: boolean);

    /**
     * Set the scene session isActivatedAfterScreenLocked true or not.throw error when failed.
     * @param state The session is request activated after screen lock
     */
    setIsActivatedAfterScreenLocked(state: boolean): void;

    /**
     * Set surface node gravity
     * @param gravity
     */
    setFrameGravity(gravity: Gravity): void;

    /**
     * save snapshot sync
     */
    saveSnapshotSync(): void;

    /**
     * save snapshot async
     */
    saveSnapshotAsync(): void;

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
    setFreezeImmediately(scaleValue: number, isFreeze: boolean, blurRadius: number): Image.PixelMap;

    /**
     * maskSupportEnterWaterfallMode
     * Used to masking the waterfall button scenario.
     */
    maskSupportEnterWaterfallMode(): void;

    /**
     * updateFullScreenWaterfallMode
     * Used to update the waterfall mode.
     * @param isWaterfallMode
     */
    updateFullScreenWaterfallMode(isWaterfallMode: boolean): void;

    /**
     * Activate or deactivate the dragEnable attribute of the window by scb.
     * @param activateDrag: Indicates whether the dragEnable attribute of the window is activated.
     */
    activateDragBySystem(activateDrag: boolean): void;

    /**
     * set colorSpace
     * @param { number } colorSpace: colorSpace num.
     */
    setColorSpace(colorSpace: number): void;

    /**
     * set SetSnapshotSkip
     * @param { boolean } isSkip: isSkip.
     */
    setSnapshotSkip(isSkip: boolean): void;

    /**
     * throw-slip directly with velocity
     * @param fingers
     * @param vx
     * @param vy
     */
    throwSlipDirectly(fingers: number, vx: number, vy: number): void;

    /**
     * Used to add sidebar blur.
     */
    addSidebarBlur(): void;

    /**
     * Used to set whether to use the default value for sidebar blur.
     * @param isDefaultSidebarBlur
     * @param isNeedAnimation
     */
    setSidebarBlur(isDefaultSidebarBlur: boolean, isNeedAnimation: boolean): void;

    /**
     * Used to set whether the scene session needs to be border-unoccupied
     */
    setBorderUnoccupied(borderUnoccupied: boolean): void;

    /**
     * Used to set currentRotation of recover.
     * @param currentRotation
     */
    setCurrentRotation(currentRotation: number): void;

    /**
     * Used to set whether to use the maximize value for sidebar blur.
     * @param isMaximize
     */
    setSidebarBlurMaximize(isMaximize: boolean): void;


    /**
     * Used to set session run with compatible mode.
     * @param toCompatibleMode
     * @param compatibleModeProperty
     */
    toggleCompatibleMode(toCompatibleMode: boolean, compatibleModeProperty?: CompatibleModeProperty): void;

    /**
     * request close the specific session
     */
    requestSpecificSessionClose(): void;

  }

  /**
   * The session of the root scene.
   */
  interface RootSceneSession {
    /**
     * Register the callback of pending another scene session activation from root scene session.
     * @param type: 'pendingSceneSessionActivation'
     */
    on(type: 'pendingSceneSessionActivation', callback: Callback<SceneInfo>): void;

    /**
     * Register the callback of pending another scene sessions activation from root scene session.
     * @param type: 'batchPendingSceneSessionsActivation'
     */
    on(type: 'batchPendingSceneSessionsActivation', callback: Callback<SceneInfo[]>): void;

    /**
     * Load the ui content of the root scene.
     * @param path: Path of the page which the root scene will be loaded
     * @param context: Context of the service extension
     */
    loadContent(path: string, context: ServiceExtensionContext, storage?: LocalStorage): void;
  }

  /**
   * App window shadow config.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface WindowShadowConfig {
    offsetX: number;
    offsetY: number;
    radius: number;
    color: string;
  }

  /**
   * keyboard animation config
   */
  interface KeyboardAnimationConfig {
    curveType: string;
    ctrlX1: number;
    ctrlY1: number;
    ctrlX2: number;
    ctrlY2: number;
    duration: number;
  }

  /**
   * App window animation config.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface WindowAnimationConfig {
    duration: number;
    curveType: string;
    ctrlX1: number;
    ctrlX2: number;
    ctrlY1: number;
    ctrlY2: number;
    scaleX: number;
    scaleY: number;
    rotationX: number;
    rotationY: number;
    rotationZ: number;
    angle: number;
    translateX: number;
    translateY: number;
    opacity: number;
  }

  /**
   * App window SystemUIStatusBarConfig  config.
   *
   * @showInLandscapeMode Whether to show in landscape mode
   * @immersiveStatusBarBgColor Background color of the status bar in immersive state
   * @immersiveStatusBarBgColor Background color of the status bar content in immersive state
   */
  interface SystemUIStatusBarConfig {
    showInLandscapeMode: boolean;
    immersiveStatusBarBgColor: string;
    immersiveStatusBarContentColor: string;
  }

  /**
   * App window StatusBarConfig  config.
   *
   * @showHide Whether to show in landscape mode
   * @contentColor Background color of the status bar in immersive state
   * @backgroundColor Background color of the status bar content in immersive state
   */
  interface StatusBarConfig {
    showHide: boolean;
    contentColor: string;
    backgroundColor: string;
  }

  /**
   * AppWindowSceneConfig.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface AppWindowSceneConfig {
    floatCornerRadius: number;
    uiType: string;
    multiWindowUIType: string;
    backgroundScreenLock: boolean;
    rotationMode: string;
    desktopStatusBarConfig: StatusBarConfig;
    leftRightStatusBarConfig: StatusBarConfig;
    upDownStatusBarConfig: StatusBarConfig;
    focusedShadow: WindowShadowConfig;
    unfocusedShadow: WindowShadowConfig;
    focusedShadowDark: WindowShadowConfig;
    unfocusedShadowDark: WindowShadowConfig;
    keyboardAnimationIn: KeyboardAnimationConfig;
    keyboardAnimationOut: KeyboardAnimationConfig;
    windowAnimation: WindowAnimationConfig;
    systemUIStatusBar: SystemUIStatusBarConfig;
  }

  /**
   * SystemConfig.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface SystemConfig {
    maxMidSceneNum: number;
    maxFloatingWindowSize: number;
  }

  /**
   * WindowLimits.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface WindowLimits {
    maxWidth: number;
    maxHeight: number;
    minWidth: number;
    minHeight: number;
  }

  /**
   * SingleHandCompatibleModeConfig.
   *
   * @enabled Whether to enable the configuration.
   * @singleHandScale Zoom ratio of the logic screen in single-hand compatible mode.
   * @heightChangeRatio Height change ratio of the logic screen before entering the single-hand compatible mode.
   * @widthChangeRatio Width change ratio of the logic screen before entering the single-hand compatible mode.
   */
  interface SingleHandCompatibleModeConfig {
    enabled: boolean;
    singleHandScale: number;
    heightChangeRatio: number;
    widthChangeRatio: number;
  }

  /**
   * RotateAnimationConfig.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface RotateAnimationConfig {
    duration: number;
  }

  /**
   * FreeMultiWindowConfig.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface FreeMultiWindowConfig {
    freeMultiWindowSupport: boolean;
    maxMainFloatingWindowNumber: number;
    defaultWindowMode: number;
  }

  /**
   * AppHookInfo.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface AppHookInfo {
    width: number;
    height: number;
    density: number;
    rotation: number;
    enableHookRotation: boolean;
    displayOrientation: number;
    enableHookDisplayOrientation: boolean;
  }

  /**
   * AppHookWindowInfo.
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface AppHookWindowInfo {
    enableHookWindow: boolean;
    widthHookRatio: number;
  }

  /**
   * Window visibility
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   * @since 12
   */
  enum WindowVisibility {
    /**
     * Window is not covered
     */
    NO_OCCLUSION,
    /**
     * Window is partly covered
     */
    PARTIAL_OCCLUSION,
    /**
     * Window is totally covered
     */
    COMPLETE_OCCLUSION,
    /**
     * End
     */
    END
  }

  /**
   * The visibility information of a window
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   * @since 12
   */
  interface WindowVisibilityInfo {
    /**
     * The id of the window
     */
    windowId: number,
    /**
     * The visibility of the window
     */
    visibility: WindowVisibility,
  }

  /**
   * The single hand screen scale info
   *
   * @syscap SystemCapability.Window.SceneSessionManager
   * @systemapi Hide this for inner system use.
   * @since 12
   */
  interface SingleHandScreenInfo {
    scaleRatio: number;
    scalePivotX: number;
    scalePivotY: number;
    singleHandMode: number;
  }

  /**
   * Rotation change type
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 18
   */
  enum RotationChangeType {
    /**
     * Rotation will begin.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    WINDOW_WILL_ROTATE = 0,
    /**
     * Rotation end.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    WINDOW_DID_ROTATE = 1
  }

  /**
   * Rect type
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 18
   */
  enum RectType {
    /**
     * Relative to screen.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    RELATIVE_TO_SCREEN = 0,
    /**
     * Relative to parent window.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    RELATIVE_TO_PARENT_WINDOW = 1
  }

  /**
   * Describes the window transition type
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 20
   */
  enum WindowTransitionType {
    /**
     * Window transition type destroy
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    DESTROY = 0,

    /**
     * Window transition type start ability
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    START = 1,
  }

  interface WindowAnimationProperty {
    /**
     * target scale of the animation
     *
     * @type { number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    targetScale: number;
  }

  /*
   * UI effect Controller
   *
   * @interface UI Effect Controller
   * @syscap SystemCapability.Window.SessionManager
   * @systemapi Hide this for inner system use.
   * @since 20
   */
  interface UIEffectParam {
    /**
     * Indicates background filter for window.
     *
     * @type { Filter }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    backgroundFilter?: uiEffect.Filter;
    /**
     * Indicates visual effect for window.
     *
     * @type { Filter }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    visualEffect?: uiEffect.VisualEffect;

    /**
     * Indicates brightness of window.
     *
     * @type { number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    brightness?: number;

    /**
     * Indicates opacity of window.
     *
     * @type { number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    opacity?: number;
  }

  /**
   * window animation config
   *
   * @interface WindowAnimationOptions
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 20
   */
  interface WindowAnimationOptions {
    /**
     * curve of the animation
     *
     * @type { WindowAnimationCurve }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    curve: WindowAnimationCurve;

    /**
     * duration of the animation
     *
     * @type { ?number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    duration?: number;

    /**
     * param of animation curve
     *
     * @type { ?WindowAnimationCurveParam }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    param?: WindowAnimationCurveParam;
  }

  /**
   * The animation configuration of window transition
   *
   * @interface TransitionAnimation
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 20
   */
  interface TransitionAnimation {
    /**
     * The config of window animation
     *
     * @type { WindowAnimationOptions }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    config: WindowAnimationOptions;
    /**
     * The opacity of window
     *
     * @type { ?number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    opacity?: number;
  }

  /**
   * Describes the window animation curve
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 20
   */
  enum WindowAnimationCurve {
    /**
     * Animation curve type linear
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    LINEAR = 0,

    /**
     * Animation curve type interpolation spring
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */

    INTERPOLATION_SPRING = 1,
    /**
     * Animation curve type cubic bezier curve
     *
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 20
     */
    CUBIC_BEZIER = 2,
  }

  /**
   * Describes the window animation type
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @since 20
   */
  enum AnimationType {
    /**
     * Window animation type fade in out
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 20
     */
    FADE_IN_OUT = 0,

    /**
     * Window animation type fade in
     *
     * @syscap SystemCapability.Window.SessionManager
     * @systemapi Hide this for inner system use.
     * @since 20
     */
    FADE_IN = 1,

    /**
     * Window animation type see the world
     *
     * @syscap SystemCapability.Window.SessionManager
     * @systemapi Hide this for inner system use.
     * @since 20
     */
    SEE_THE_WORLD = 100,
  }

  /**
   * Rotation change info
   *
   * @interface RotationChangeInfo
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 18
   */
  interface RotationChangeInfo {
    /**
     * Rotation change type.
     *
     * @type { RotationChangeType }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    type: RotationChangeType;
    /**
     * Orientation.
     *
     * @type { Orientation }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    orientation: number;
    /**
     * Display id.
     *
     * @type { number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    displayId: number;
    /**
     * Display rect.
     *
     * @type { Rect }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    displayRect: SessionRect;
  }

  /**
   * Rotation change result
   *
   * @interface RotationChangeResult
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 18
   */
  interface RotationChangeResult {
    /**
     * persistent id.
     *
     * @type { number }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    persistentId: number;

    /**
     * Rect type.
     *
     * @type { RectType }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    rectType: RectType;
    /**
     * Window rect.
     *
     * @type { Rect }
     * @syscap SystemCapability.Window.SessionManager
     * @atomicservice
     * @since 18
     */
    windowRect: SessionRect;
  }

  /**
   * Rect type
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @atomicservice
   * @since 20
   */
  enum SupportFunctionType {
    /**
      * Supports callbacks triggered before the keyboard show/hide animations begin.
      *
      * @syscap SystemCapability.Window.SessionManager
      * @atomicservice
      * @since 20
      */
    ALLOW_KEYBOARD_WILL_ANIMATION_NOTIFICATION = 1 << 0,
  }

  /**
   * Get window scene config.
   * @returns Returns the config value of the window scene.
   */
  function getWindowSceneConfig(): AppWindowSceneConfig;

  /**
   * Get system config.
   * @returns Returns the config value of the system.
   */
  function getSystemConfig(): SystemConfig;

  /**
   * Get window limits.
   * @returns Returns the window limits.
   */
  function getWindowLimits(windowId: number): WindowLimits;

  /**
   * Get rotate animation config.
   * @param config the config of the rotate animation.
   */
  function updateRotateAnimationConfig(config: RotateAnimationConfig): void;

  /**
   * Set system animated scenes
   * @param sceneCode indicates different system animated scenes
   * @param isAngularAnimation indicates irregulars windows in animation
   */
  function setSystemAnimatedScenes(sceneCode: number, isAngularAnimation: boolean): void;

  /**
   * Register the callback of create specific session.
   * @param type: 'createSpecificSession'
   */
  function on(type: 'createSpecificSession', callback: Callback<SceneSession>): void;

  /**
   * Register the callback of create keyboard session.
   * @param type: 'createKeyboardSession'
   */
  function on(type: 'createKeyboardSession', callback: Callback<SceneSession, SceneSession>): void;

  /**
   * Register the callback of set SpecificWindow ZIndex.
   * @param type: 'setSpecificWindowZIndex'
   */
  function on(type: 'setSpecificWindowZIndex', callback: Callback<SceneSession, SceneSession>): void;

  /**
   * Register the callback of recover scene session.
   * @param type: 'recoverSceneSession'
   */
  function on(type: 'recoverSceneSession', callback: Callback<SceneSession, SceneInfo>): void;

  /**
   * Register the callback of outsideDownEvent enabled change
   * @param type: 'outsideDownEvent'
   */
  function on(type: 'outsideDownEvent', callback: Callback<{ x: number, y: number }>): void;

  /**
   * Register the callback of gesture navigation enabled change
   * @param type: 'gestureNavigationEnabledChange'
   */
  function on(type: 'gestureNavigationEnabledChange', callback: Callback<boolean>): void;

  /**
   * Register the callback of status bar enabled change
   * @param type: 'statusBarEnabledChange'
   */
  function on(type: 'statusBarEnabledChange', callback: Callback<boolean>): void;

  /**
   * Register the callback of shift focus
   * @param type: 'statusBarEnabledChange'
   */
  function on(type: 'shiftFocus', callback: Callback<number, number>): void;

  /**
   * Register the callback of show main pip window
   * @param type: 'showMainPipWindow'
   */
  function on(type: 'showPiPMainWindow', callback: Callback<number>): void;

  /**
   * Register the callback of callingWindowIdChange.
   * @param type: 'callingWindowIdChange'
   */
  function on(type: 'callingWindowIdChange', callback: Callback<number>): void;

  /**
   * Register the callback of watchGestureConsumeResult.
   * @param type: 'watchGestureConsumeResult'
   */
  function on(type: 'watchGestureConsumeResult', callback: Callback<number, boolean>): void;

  /**
   * Register the callback of watchFocusActiveChange.
   * @param type: 'watchFocusActiveChange'
   */
  function on(type: 'watchFocusActiveChange', callback: Callback<boolean>): void;

  /**
   * Register the callback of startUIAbilityError.
   * @param type: 'startUIAbilityError'
   */
  function on(type: 'startUIAbilityError', callback: Callback<number>): void;

  /**
   * Register the callback of closeTargetFloatWindow.
   * @param type: 'closeTargetFloatWindow'
   */
  function on(type: 'closeTargetFloatWindow', callback: Callback<string>): void;

  /**
   * Register the callback of abilityManagerCollaboratorRegistered.
   * @param type: 'abilityManagerCollaboratorRegistered'
   */
  function on(type: 'abilityManagerCollaboratorRegistered', callback: Callback<string>): void;

  /**
   * Register the callback of start pip failed of this scene session.
   * @param type: 'startPiPFailed'
   */
  function on(type: 'startPiPFailed', callback: Callback<number>): void;

  /**
   * Register the callback of update app use control
   * @param type: 'updateAppUseControl'
   */
  function on(type: 'updateAppUseControl', callback: Callback<ControlType, number, ControlAppInfo[]>): void;

  /**
   * Register the callback of set foreground window numbers.
   * @param type: 'setForegroundWindowNum'
   */
  function on(type: 'setForegroundWindowNum', callback: Callback<number>): void;

  /**
   * Register the callback of minimize target window List.
   * @param type: 'minimizeByWindowId'
   */
  function on(type: 'minimizeByWindowId', callback: Callback<number[]>): void;

  /**
   * Register the callback of update kiosk app list
   * @param type: 'updateKioskAppList'
   */
  function on(type: 'updateKioskAppList', callback: Callback<string[]>): void;

  /**
   * Register the callback of kiosk mode change
   * @param type: 'kioskModeChange'
   */
  function on(type: 'kioskModeChange', callback: Callback<boolean, number>): void;
  /**
   * Register the callback of set param of top stack.
   * @param type: 'uiEffectSetParams'
   */
  function on(type: 'uiEffectSetParams', callback: Callback<number, UIEffectParam>): void;

  /**
   * definition of UI effect controller animate to function
   */
  interface UIEffectAnimateCallback {
    (id: number, param: UIEffectParam, interruptOption?: WindowAnimationOptions):void;
  }

  /**
   * Register the callback of animate to top stack.
   * @param type: 'uiEffectAnimateTo'
   */
  function on(type: 'uiEffectAnimateTo', callback: UIEffectAnimateCallback): void;

  /**
   * Support follow parent window layout in this device.
   */
  function supportFollowParentWindowLayout(): void;

  /**
   * Support follow relative position to parent window in this device.
   */
  function supportFollowRelativePositionToParent(): void;

  /**
   * @param enable Whether to enable BehindWindowFilter
   * Support set behind window filter enabled.
   */
  function setBehindWindowFilterEnabled(enable: boolean): void;

  /**
   * Support zlevel in this device.
   */
  function supportZLevel(): void;

  /**
   * Support snapshot all SessionStatus.
   */
  function supportSnapshotAllSessionStatus(): void;

  /**
   * Support preload startingWindow.
   */
  function supportPreloadStartingWindow(): void;

  /**
   * Support create float window
   *
   */
  function supportCreateFloatWindow(): void;

  /**
   * Register the callback of scene session destruct.
   * @param type: 'sceneSessionDestruct'.
   */
  function on(type: 'sceneSessionDestruct', callback: Callback<number>): void;

  /**
   * Register the callback of scene session transfer.
   * @param type: 'transferSceneSessionToTargetScreen'.
   */
  function on(type: 'sceneSessionTransferToTargetScreen', callback: Callback<number, number, Record<string, Object>>): void;

  /**
   * Notify session transfer to another screen event
   * @param persistentId
   * @param resultCode
   *   - 0: init
   *   - 1: success
   *   - 2: fail
   * @param fromScreenId
   * @param toScreenId
   */
  function notifySessionTransferToTargetScreenEvent(
    persistentId: number, resultCode: CommonResultCode, fromScreenId: number, toScreenId: number): void;

  /**
   * Get root scene session.
   * @returns Returns the session of the root scene.
   */
  function getRootSceneSession(): RootSceneSession;

  /**
   * Handle user switch event.
   * @param eventType User switch event type
   * @param isUserActive Indicates whether the user is active
   */
  function handleUserSwitch(eventType: number, isUserActive: boolean): void;

  /**
   * Request a scene session.
   * @param info The information of the scene
   * @returns Returns the session of the scene
   */
  function requestSceneSession(info: SceneInfo, want?: Want): SceneSession;

  /**
   * Set the app wheather auto-save the window rect.
   * @param key The information of the bundleName + moduleName + abilityNam + specifiedFlag.
   * @param enabled True means the window rect auto-save is enabled, otherwise means the opposite.
   * @param abilityKey The information of the bundleName + moduleName + abilityNam.
   * @param isSaveBySpecifiedFlag True means the specifiedFlag is enabled, otherwise means the opposite.
   * @returns Returns the session of the scene
   */
  function setIsWindowRectAutoSave(key: string, enabled: boolean,
    abilityKey: string, isSaveBySpecifiedFlag: boolean): void;

  /**
   * Request a scene session.
   * @param info The information of the scene
   */
  function updateSceneSessionWant(info: SceneInfo, want: Want, requestId: number = DEFAULT_REQUEST_ID): void;

  /**
   * Request the scene session activation.throw error when failed.
   * @param sceneSession The session of the scene which to be activated
   */
  function requestSceneSessionActivation(sceneSession: SceneSession, isNewActive: boolean,
                                         isShowAbility: boolean = false, requestId: number = DEFAULT_REQUEST_ID): void;

  /**
   * Request the scene session background.throw error when failed.
   * @param sceneSession The session of the scene which to be background
   * @param isDelegator Is delegator
   * @param isToDesktop Is toDesktop
   * @param isSaveSnapshot Is do save snapshot
   */
  function requestSceneSessionBackground(sceneSession: SceneSession, isDelegator?: boolean,
    isToDesktop?: boolean, isSaveSnapshot?: boolean,
    backgroundReason: BackgroundReason = BackgroundReason.DEFAULT): void;

  /**
   * Request the scene session destruction.throw error when failed.
   * @param sceneSession The session of the scene which to be destroyed
   * @param needRemoveSession The session of the scene need to be removed or not
   * @param isSaveSnapshot Indicates whether to save a snapshot, the default value is false
   * @param isForceClean The session of the scene need to forcibly clean or not, the default value is false
   * @param isUserRequestedExit Indicates whether the exit was requested by the user, the default value is false
   */
  function requestSceneSessionDestruction(sceneSession: SceneSession, needRemoveSession?: boolean,
                                          isSaveSnapshot?: boolean, isForceClean?: boolean,
                                          isUserRequestedExit?: boolean): Promise<void>;

  /**
   * Notify the foreground scene session if interactive.
   * @param sceneSession The session of the scene which to be notified
   * @param interactive The session of the scene is interactive or not
   */
  function notifyForegroundInteractiveStatus(sceneSession: SceneSession, interactive: boolean): Promise<void>;

  /**
   * Check scene session is valid.
   * @param sceneSession The session of the scene which check is valid
   * @returns scene session is valid
   */
  function isSceneSessionValid(sceneSession: SceneSession): boolean;

  /**
   * Init with randerService add
   *
   */
  function InitWithRenderServiceAdded(): void;

  /**
   * Init SceneBoard priority to SceneBoard
   *
   */
  function initScheduleUtils(): void;

  /**
   * Request the scene session activation by call.throw error when failed.
   * @param sceneSession The session of the scene which to be activated
   */
  function requestSceneSessionByCall(sceneSession: SceneSession, requestId: number = DEFAULT_REQUEST_ID): void;

  /**
   * start ability by specified.
   * @param SceneInfo  which to be start
   */
  function startAbilityBySpecified(info: SceneInfo, callback: AsyncCallback<void>): void;

  /**
   * start ability by specified.
   * @param SceneInfo  which to be start
   * @param want
   */
  function startAbilityBySpecified(info: SceneInfo, want?: Want): Promise<void>;

  /**
   * process the scene session back.
   */
  function processBackEvent(): void;

  /**
   * prepareTerminate
   * @param persistentId
   * @returns
   */
  function prepareTerminate(persistentId: number): boolean;

  /**
   * asyncPrepareTerminate
   * @param persistentId
   * @param callback
   */
  function asyncPrepareTerminate(persistentId: number, callback: AsyncCallback<boolean>): void;

  /**
   * initUserInfo
   *
   * @param userId
   * @param fileDir
   */
  function initUserInfo(userId: number, fileDir: string): void;

  /**
   * Get window visibility information of all window
   * @returns the WindowVisibilityInfo array
   */
  function getAllWindowVisibilityInfos(): Promise<Array<WindowVisibilityInfo>>;

  /**
   *
   * @param want
   * @param userId
   * @param callback
   */
  function getAllAbilityInfo(want: Want, userId: number, callback: AsyncCallback<Array<SCBAbilityItemInfo>>): void;

  /**
   *
   * @param want
   * @param userId
   * @returns the abilityItemInfo array
   */
  function getAllAbilityInfo(want: Want, userId: number): Promise<Array<SCBAbilityItemInfo>>;

  /**
   * @param userId
   * @param bundleNames
   * @returns the abilityItemInfo array
   */
  function getBatchAbilityInfos(userId: number, bundleNames: Array<string>): Promise<Array<SCBAbilityItemInfo>>;

  /**
   * Get scb ability item info
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @param userId
   * @returns the abilityItemInfo
   */
  function getAbilityInfo(bundleName: string, moduleName: string, abilityName: string, userId: number): SCBAbilityItemInfo;

  /**
   *
   * @param cmdId
   * @param onOffTag
   * @param msg
   */
  function perfRequestEx(cmdId: number, onOffTag: boolean, msg?: string): void;

  /**
   * update window mode
   * @param persistentId
   * @param windowMode
   */
  function updateWindowMode(persistentId: number, windowMode: number): Promise<void>;

  /**
   * Notify SingleHand Info Change
   * @param scaleX
   * @param scaleY
   * @param singleHandMode
   */
  function notifySingleHandInfoChange(singleHandScreenInfo: SingleHandScreenInfo, originRect: SessionRect,
    singleHandRect: SessionRect): Promise<void>;

  /**
   * Register SingleHand Container Node
   * @param stringId
   */
  function registerSingleHandContainerNode(stringId: string): Promise<void>;

  /**
   * Get single-Hand compatible mode config. Throw error when failed.
   * @returns Returns the config value of the single-Hand compatible mode.
   */
  function getSingleHandCompatibleModeConfig(): SingleHandCompatibleModeConfig;

  /**
   * get uiContext of rootScene
   * @returns the object of uiContent
   */
  function getRootSceneUIContext(): UIContext;

  /**
   * Send touch event to the scene below the gesture navigation bar.
   * @param { TouchEvent } event - The touch event to send.
   * @param { number } zIndex - The Z index of the gesture navigation bar.
   */
  function sendTouchEvent(event: TouchEvent, zIndex: number): void;

  /**
   * preloaded in-lake apps
   * @param bundleName preloaded in-lake app bundleName
   */
  function preloadInLakeApp(bundleName: String): void;

  /**
   * Request focus status
   * Do not use directly, use RequestFocus/RequestUnfocus instead
   * @param persistentId: session id
   * @param isFocused: focus status wanted
   * @param byForeground: if request when foreground, used by system scene
   */
  function requestFocusStatus(persistentId: number, isFocused: boolean, byForeground: boolean, reason?: FocusChangeReason): void;

  /**
   * Request all app session unfocus
   * Do nothing if focused session is not app session
   */
  function requestAllAppSessionUnfocus(): void;

  /**
   * Set screen lock state
   * @param isScreenLocked
   */
  function setScreenLocked(isScreenLocked: boolean): void;

  /**
   * Set user auth passed state
   * @param isUserAuthPassed
   */
  function setUserAuthPassed(isUserAuthPassed: boolean): void;

  /**
   * add window drag hot area
   * @param screenId
   * @param type
   * @param area
   */
  function addWindowDragHotArea(screenId: number, type: number, area: RectInfo): Promise<void>;

  /**
   * update maximize mode
   * @param persistentId
   * @param isMaximize
   */
  function updateMaximizeMode(persistentId: number, isMaximize: boolean): Promise<void>;

  /**
   *
   * @param resType
   * @param value
   * @param payload
   */
  function reportData(resType: number, value: number, payload: Record<string, string>): void;

  /**
   * 同步查询 Rss 数据，如互斥状态查询
   * @param resType rss 类型
   * @param payload 请求查询的信息
   * @return 查询结果
   */
  function getRssData(resType: number, payload: Record<string, string>): Record<string, Object>;

  /**
   * Registers the Rss callback, such as the mutex state callback.
   * When the mutex state is reached, the callback is triggered.
   * @param eventType rss type
   * @param callback
   */
  function registerRssData(eventType: number, callback: Callback<Record<string, string>>): void;

  /**
   * Unregisters Rss callback
   * @param eventType
   * @param callback
   */
  function unregisterRssData(eventType: number, callback: Callback<Record<string, string>>): void;

  /**
   * update Floating title in target position
   * @param persistentId
   * @param isShow
   * @param height
   */
  function updateTitleInTargetPos(persistentId: number, isShow: Boolean, height: number): Promise<void>;

  /**
   * Set status bar default visibility on display
   * @param displayId ID of display
   * @param visible default visibility
   */
  function setStatusBarDefaultVisibilityPerDisplay(displayId: number, visible: boolean): void;

  /**
   * Notify status bar show status
   * @param persistentId ID of the window
   * @param isVisible If the bar is visible
   */
  function notifyStatusBarShowStatus(persistentId: number, isVisible: boolean): void;

  /**
   * Notify if status bar constantly show
   * @param screenId ID of screen
   * @param isVisible If the bar is constantly show
   */
  function notifyStatusBarConstantlyShowStatus(screedId: number, isVisible: boolean): void;

  /**
   * Notify Next status bar show status
   * @param persistentId ID of the window
   * @param isVisible If the bar is visible
   * @param portraitRect portrait window rect
   * @param landspaceRect landspace window rect
   */
  function notifyNextAvoidRectInfo(type: sceneSessionManager.SessionType, screenId: number, portraitRect: RectInfo,
    landspaceRect: RectInfo): void;

  /**
   * Notify AI navigation bar show status
   * @param isVisible If the bar is visible
   * @param barArea The area of the bar
   */
  function notifyAINavigationBarShowStatus(isVisible: boolean, barArea: RectInfo, screenId: number): Promise<void>;

  /**
   * Notify whether session is recovering due to abnormal restart
   * @param isRecovering
   */
  function notifySessionRecoverStatus(isRecovering: boolean, persistentIds?: Array<number>): Promise<void>;

  /**
   * update session display id
   * @param persistentId
   * @param screenId
   */
  function updateSessionDisplayId(persistentId: number, screenId: number): Promise<void>;

  /**
   * notify window stack empty
   * @param persistentId
   */
  function notifyStackEmpty(persistentId: number): Promise<void>;

  /**
   * get Session Snapshot PixelMap
   * @param persistentId
   * @param scaleValue 0.0f - 1.0f
   * @param snapshotNode node for snapshot
   * @param useNewSnapshot default true
   * @returns
   */
  function getSessionSnapshotPixelMap(persistentId: number, scaleValue: number, snapshotNode?: SnapshotNodeType,
    useNewSnapshot?: boolean): Promise<Image.PixelMap>;

  /**
   * get Session Snapshot PixelMap sync
   * @param persistentId window persistent id
   * @param scaleValue 0.0f - 1.0f
   * @param snapshotNode node for snapshot
   * @param useNewSnapshot default true
   * @returns snapshot
   */
  function getSessionSnapshotPixelMapSync(persistentId: number, scaleValue: number, snapshotNode?: SnapshotNodeType,
    useNewSnapshot?: boolean): Image.PixelMap;

  /**
   * interface for scb to call ability start fn
   * @param sceneSession
   */
  function startUIAbilityBySCB(sceneSession: sceneSessionManager.SceneSession): void;

  /**
   * notify ability that a window visibility has changed
   * only used after switching the status between foreground and hidden
   * hidden: like background but window will not shown in dock and status bar
   * @param sceneSession
   * @param visibility
   */
  function changeUIAbilityVisibilityBySCB(sceneSession: sceneSessionManager.SceneSession,
    visibility: boolean, isFromClient?: boolean, isNewWant?: boolean): void;

  /**
   * get custom decor height
   * @param persistentId
   * @returns
   */
  function getCustomDecorHeight(persistentId: number): number;

  /**
   * switch multiWindow mode
   * @param enable if is freeform scene mode or not,true indicate is freeform scene mode
   */
  function switchFreeMultiWindow(enable: boolean): void;

  /**
   * get FreeMultiWindowConfig
   * @returns FreeMultiWindowConfig from window manager config
   */
  function getFreeMultiWindowConfig(): FreeMultiWindowConfig;

  /**
   * check scene ZOrder event
   */
  function checkSceneZOrder(): void;

  /**
   * Notify the enter and leave active of recent task
   * @param enterRecent
   */
  function notifyEnterRecentTask(enterRecent: boolean): void;

  /**
   * Set VMA status, Auto-off after 600 frames
   * @param VMA Switch
   */
  function setVmaCacheStatus(flag: boolean): void;

  /**
   * Notify the hookInfo to window manager and screen manager
   * @param uid
   * @param width hook width
   * @param height hook height
   * @param density hook density
   * @param enable  add hookinfo or delete hookinfo
   * @deprecated use updateAppHookDisplayInfo instead
   */
  function updateDisplayHookInfo(uid: number, width: number, height: number, density: number, enable: boolean);

  /**
   * Notify the hookInfo to window manager and screen manager
   * @param uid
   * @param hookInfo hookInfo
   * @param enable  add hookInfo or delete hookInfo
   */
  function updateAppHookDisplayInfo(uid: number, hookInfo: AppHookInfo, enable: boolean);

  /**
   * Notify the hookWindowInfo to window manager
   * @param bundleName bundle name of app
   * @param hookWindowInfo hookWindowInfo
   */
  function updateAppHookWindowInfo(bundleName: string, hookWindowInfo: AppHookWindowInfo);

  /**
   * Notify the hook orientation change
   * @param persistentId
   */
  function notifyHookOrientationChange(persistentId: number);

  /**
   * set app magic window mode by bundle name
   *
   * @param bundleName app bundle name
   * @param mode magic window mode,
   * @param homePage
   * @param supportSplit
   * @param arkUIOptions
   */
  function setAppForceLandscapeConfig(bundleName: string, mode: number, homePage: string, supportSplit: number,
    arkUIOptions: string): void;

  /*
   * whether scb core enhance is enable
   */
  function isScbCoreEnabled(): boolean;

  /**
   * Sync persistent id list to c++
   */
  function refreshPcZOrder(startZOrder: number, persistentIds: number[]): void;

  /**
   * Get max instance count of target bundleName, return 0 if not support multi instance.
   * @param bundleName
   * @returns max instance count
   */
  function getMaxInstanceCount(bundleName: string): number;

  /**
   * Get current instance count of target bundleName
   * @param bundleName
   * @returns instance count
   */
  function getInstanceCount(bundleName: string): number;

  /**
   * Get last instance key.
   * @param bundleName
   * @returns instance key
   */
  function getLastInstanceKey(bundleName: string): string;

  /**
   * Refresh app info
   * @param bundleName
   */
  function refreshAppInfo(bundleName: string): void;

  /**
   * Get window pid, return -1 if get pid fail.
   * @param window id
   * @returns window pid
   */
  function getWindowPid(windowId: number): number;

  /**
   * Notify the ids of window above lockScreen
   * @param list the ids of window above lockScreen
   */
  function notifyAboveLockScreen(list: number[]): void;

  /**
   * clone window
   * @param from the src window
   * @param to the dest window
   * @param is needOffScreen, default value is true
   */
  function cloneWindow(from: number, to: number, needOffScreen?: boolean): void;

  /**
   * update screen status and display rects
   * @param screenId
   * @param foldStatus
   * @param defaultDisplayRect
   * @param virtualDisplayRect
   * @param foldCreaseRect
   */
  function updatePcFoldScreenStatus(screenId: number, foldStatus: number,
    defaultDisplayRect: RectInfo, virtualDisplayRect: RectInfo, foldCreaseRect: RectInfo): void;

  /**
   * update bottom system keyboard status
   * @param hasSystemKeyboard
   */
  function updateSystemKeyboardStatus(hasSystemKeyboard: boolean): void;

  /**
   * reset arrange rule of the side containing rect
   * @param rect
   */
  function resetPcFoldScreenArrangeRule(rect: RectInfo): void;

  /**
   * to set app drag resize type
   * @param bundleName
   * @param resizeType
   */
  function setAppDragResizeType(bundleName: string, resizeType: DragResizeType): void;

  /**
   * to set status bar avoid height
   * @param height
   */
  function setStatusBarAvoidHeight(screenId: number, height: number): void;

  /**
   * to notify rotation change
   * @param RotationChangeInfo rotation information to notify caller
   * @param isRestrictNotify whether to restrict this notification
   * @returns Array<RotationChangeResult> | void rotation result from caller
   */
  function notifyRotationChange(rotationChangeInfo: RotationChangeInfo,
    isRestrictNotify: boolean = false): Array<RotationChangeResult> | void;

  /**
   * to ensure the corresponding feature works.
   * @param funcType is a bitmask composed of the SupportFunctionType
   */
  function setSupportFunctionType(funcType: SupportFunctionType): void;

  /**
   * to update recent main session list
   * @param recentMainSessionIds the persistentIds of recently used main sessions
   */
  function updateRecentMainSessionList(recentMainSessionIds: number[]): void;

  function setUIEffectControllerAliveInUI(id: number, isAlive: boolean);

  /**
   * setMaximizeFullScreen
   * @param persistentId
   * @param isMaximizeFullScreen
   */
  function setMaximizeFullScreen(persistentId: number, isMaximizeFullScreen: boolean): Promise<void>;

  /**
   * Set picture-in-picture autoStart switch status.
   * @param switchStatus indicates pip autoStart switch status of system setting
   */
  function setPiPSettingSwitchStatus(switchStatus: boolean): void;

  /**
   * set Is Pip Enabled.
   */
  function setIsPipEnabled(enable: boolean):void;
}

export default sceneSessionManager;
