/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
export * from './scene/SceneModuleIndex';

export type { SCBExpandController, SCBFoldController } from './animation/SCBTransitionController';

export { SCBRootSceneSession } from './scene/session/SCBRootSceneSession';

export { SCBRecentSessionInfo } from './scene/session/SCBRecentSessionInfo';

export { SCBSceneInfo, SCBSceneMode } from './scene/session/SCBSceneInfo';

export { SCBSceneOrientation } from './scene/session/SCBSceneOrientation';

export { SCBDividerParam, SceneParam } from './scene/session/SCBDividerParam';

export { MidSceneEvents } from './scene/session/MidSceneEvents';

export { MidSceneConfig, MidSceneConfigBase } from './scene/midScene/MidSceneConfig';

export type { RotationPropertyHolder } from './rotation/SCBRotationController';

export { SCBSceneSession,
  SCBSessionCbType,
  SCBSessionEventId,
  SCBSessionShowInScreenIndex,
  SCBSceneMemoryInfo,
  ActiveReason,
  NeedRenderSnapShotAnimConfig,
} from './scene/session/SCBSceneSession';

export { ScbNumber, SCBSessionRect } from './scene/session/SCBSessionRect';

export { SCBSpecificSession, SCBSpecificSessionSource, SCBSubWindowAnchorInfo } from './scene/session/SCBSpecificSession';
export type { SCBSpecificSessionOptions } from './scene/session/SCBSpecificSession';

export { SCBKeyboardSession, SCBKeyboardPanelRects } from './scene/session/SCBKeyboardSession';

export { SCBSceneSessionManager,
  SCBSpecificSceneSessionList,
  SCBDynamicSystemScene,
  SCBDynamicSystemSceneList,
  SCBInputMethodList,
  SCBEventId,
  ACTIVE_STATUS_MAP,
  OccludeKeygaurdScene,
  SpecificPanelZOrder,
  PreferMultiWindowOrientation,
  UserSwitchEventType,
  UIEffectZOrderType,
} from './scene/session/SCBSceneSessionManager';

export type {
  SessionLabelListener,
  ExecuteCallbackExtraInfo,
  VirtualScreenStartSceneFunc,
} from './scene/session/SCBSceneSessionManager';

export { sceneMissionInterceptor } from './scene/utils/SCBSceneMissionInterceptor';

export { SCBTogManager,
  NotifyState,
  StartFrom,
  NotifyPCModeCallback,
  PC_IN_PHONE_LIST
} from './scene/session/SCBTogManager';

export {
  SCBKeyboardManager,
  KeyboardState,
  KeyboardChangeCallback,
  KeyboardAnimationSyncCallback,
  KEYBOARD_STATE_MAP
} from './scene/session/SCBKeyboardManager';


export { SCBScreenProperty } from './screen/session/SCBScreenSession';
export { SCBScreenSession } from './screen/session/SCBScreenSession';

export { SCBScreenSessionManager,
  SCBScreenSessionArray,
  PowerStatusController
} from './screen/session/SCBScreenSessionManager';

export { SCBPropertyChangeReason,
  SCBRotateChangeReason,
} from './screen/session/SCBScreenSessionManager';

export type { ScreenConnectListener } from './screen/session/SCBScreenSessionManager';

export { SCBSceneContainerSession,
  NeedRenderBackgroundAlpha,
  NeedRenderTitleViewAlpha,
  NeedRenderRecentSceneBorderRadius,
  NeedRenderShowRecentTitle,
  NeedRenderRecentDeleteScale,
  NeedRenderRecentDeleteTranslate,
  NeedRenderRecentCoverScale,
  NeedRenderRecentCoverTranslate,
  NeedRenderBackgroundForMinScale,
  NeedRenderRecentMinBackgroundSize,
  NeedRenderRecentMinBackgroundAlpha,
  NeedRenderRecentTitleTranslate,
  NeedRenderRecentTitleWidth,
  NeedRenderZIndex,
  NeedRenderRecentClosingAnimating,
  NeedRenderSplitBackgroundColor,
  NeedRenderRotate,
  NeedRenderClip,
  SCBSceneSessionArray,
  SplitStyle,
  MidSceneMap,
  MidAppIconParamMap,
  NeedRenderDragHotAreaAnimConfig
} from './scene/session/SCBSceneContainerSession';



export { NeedRenderTranslate,
  NeedRenderAlpha,
  NeedRenderBorderRadius,
  NeedRenderBlurRadius,
  NeedRenderPos,
  NeedRenderScale,
  NeedRenderLockIconOpacity,
  NeedRenderLockIconScale,
  NeedRenderLockIconTranslate,
  NeedRenderTitleViewScale,
  NeedRenderVisibility,
  NeedRenderShowInRecent,
  NeedRenderSubSceneShow,
  NeedPreBuild,
  PreBuildStage,
  NeedRenderMotionBlur,
} from './scene/session/SCBSceneContainerSession';

export {
  SCBSceneContainerSessionArray,
  SCBNavBarStyle,
  SCBContainerRotationReason,
  SCBSceneContainerState,
} from './scene/session/SCBSceneContainerSession';

export { SCBSplitParam } from './scene/session/SCBSplitParam';

export { SCBGestureActionId, SCBGestureAction, SCBRecentGestureModel
} from './common/SCBGestureAction';

export type { SCBGestureActionOption } from './common/SCBGestureAction';

export { SCBDeviceScreenConfig } from './config/SCBDeviceScreenConfig';

export { StartAppConfig } from './config/StartAppConfig';

export { SCBTransitionManager, SCBDesktopEventId } from './animation/SCBTransitionManager';

export type { SCBUnlockTransitionController } from './animation/SCBTransitionManager';

export type { SCBTransitionController } from './animation/SCBTransitionController';


export { scbGestureManager, GestureEnableCaller } from './gesturenavigation/SCBGestureManager';

export { GestureNavigationState } from './gesturenavigation/SCBGestureManager';

export { gestureNavigationObserver, NavigationType, SceneCaller, GestureNavigationEvent } from './gesturenavigation/GestureNavigationObserver';

export { SCBGestureRecord } from './common/SCBGestureRecord';

export type { SystemSessionChangeCallback } from './scene/session/SCBSystemSceneSession';

export { SCBSystemSceneSession, SystemBarType } from './scene/session/SCBSystemSceneSession';

export {
  SCBFollowDesktopOrientationPolicy,
  SCBDefaultOrientationPolicy
} from './scene/session/SCBSceneOrientationPolicy';

export { SCBKeyboardPanelSession,
  KEYBOARD_PRIVATE_COMMAND_KEYS,
  PatternAction } from './scene/session/SCBKeyboardPanelSession';

export {
  TOOLBAR_FLOAT_HEIGHT,
  FOLD_EXPAND_TOOLBAR_HEIGHT,
  FOLD_EXPAND_TOOLBAR_LAND_WIDTH,
  FOLD_EXPAND_TOOLBAR_WIDTH,
  PHONE_ONE_HANDED_WIDTH,
  PHONE_TOOLBAR_LANDSCAPE_HEIGHT,
  PHONE_TOOLBAR_PORTRAIT_WIDTH,
  PHONE_TOOLBAR_PORTRAIT_WIDTH_FLOAT,
  PHONE_TOOLBAR_PORTRAIT_HEIGHT,
  PHONE_TOOLBAR_IMAGE_MARGIN,
  PHONE_TOOLBAR_LANDSCAPE_IMAGE_MARGIN,
  FOLD_EXPAND_TOOLBAR_IMAGE_MARGIN,
  TOOLBAR_FLOAT_IMAGE_MARGIN,
  SCBKeyboardPanelManager } from './scene/session/SCBKeyboardPanelManager';

export type { KeyboardBarOption, KeyboardBarParams } from './scene/session/SCBKeyboardPanelManager';

export type { SmartMenuItem, SmartMenu, MenuAction, Parameters } from './scene/session/SCBKeyboardPanelSession';

export { StartAbilityUtil } from './startAbility/StartAbilityUtil';

export type { SystemSessionInfo,
  SystemSessionBackgroundOptions } from './scene/session/SCBSystemSceneSession';

export { SCBScenePanelSession, SCBBackgroundBlurSession } from './scene/manager/SCBScenePanelSession';

export { SCBScenePanelManager } from './scene/manager/SCBScenePanelManager';

export { default as SCBOobeManager } from './oobe/SCBOobeManager';

export { BaseOobeService } from './oobe/service/BaseOobeService';

export { ADMIN_USERID } from './oobe/BaseOobeManager';

export { DisplayMgr, DisplayEvent, DisplayConstants } from './utils/DisplayManager';

export {
  AnimBuilder,
  AnimCommon,
  AnimDirection,
  AnimEasing,
  AnimFill,
  AnimFrame,
  BaseAnimation
} from './animation/BaseAnimation';

export {
  SCBFloatingParam,
  RecentParams,
  CornerArea,
  CornerParam,
  FloatingSceneCommonStyle,
  FloatingSceneOneStepStyle,
  FloatingScenePortraitStyle,
  FloatingSceneExpandStyle,
  FloatSizeState,
  FloatSceneSizeData,
  RecentFloatingAnimParams,
  UserAction,
  FloatingType,
  FloatingScenePadLayoutStyle,
  FloatingRectCache,
  RecordType,
  FloatSceneStartAnimation
} from './scene/session/SCBFloatingParam';


export { default as sSCBOobeManager } from './oobe/SCBOobeManager';

export { OOBE_CHANGE_EVENT } from './oobe/SCBOobeManager';

export { default as SCBRecoverManager } from './scene/manager/SCBRecoverManager';


export { windowMgr } from './windowmanager/WindowManagerProxy';


export { SCBWindowShadowConfig,
  SCBSystemBarProperty,
  WindowDragHotAreaType } from './scene/session/SCBSceneSession';

export { INVALID_SCREEN_ID, INVALID_PID } from './scene/session/SCBSceneSessionManager';


export { GestureType, PcKeyType } from './gesturenavigation/SCBGestureManager';

export { SCBScenePanelDebugCommands } from './scene/dump/SCBScenePanelDebugCommands';

export { default as sSCBOtaManager, OTA_OOBE_CHANGE_EVENT } from './oobe/SCBOtaManager';

export type { SCBScreenStateChangeTransitionController } from './animation/SCBTransitionManager';

export { RecentsStyleConstants } from './recent/constants/RecentsStyleConstants';

export type { FSMCallbackArgsType, FSMCallbackType } from './recent/Fsm';

export { FSMEvent, FSMTransition, FSMState, FSM } from './recent/Fsm';


export type { SCBAppExitToFolderController } from './animation/SCBTransitionController';


export { AbilityItemInfo, WindowSize } from './bean/AbilityItemInfo';


export { AppData, AppInFolderInfo, AppExitLocationInfo } from './animation/SCBTransitionController';

export {
  ScenePanelState,
  SessionDisplayChangeReason,
  SessionChangeInfo,
} from './scene/session/SCBSceneSessionManager';

export { OverlayCardInterface, OverlayCardStateInterface } from './bean/OverlayCardData';

export { OverlayCardTransition } from './bean/OverlayCardData';

export { WindowAnimMgr } from './windowmanager/WindowAnimManager';

export { ChainAnimation } from './recent/ChainAnimation';

export { SpringProperty } from './recent/SpringModel';

export { RecentViewParam } from './recent/RecentViewParam';

export { scbEventExclusiveManager } from './gesturenavigation/gestureignore/SCBEventExclusiveManager';

export { EventType, EventExclusiveBitMap } from
  './gesturenavigation/gestureignore/configs/EventExclusiveConfig';

export type { SceneProxyToScreenLock } from './scene/session/SCBSceneInfoFromScreenLock';

export { SCBSceneInfoFromScreenLock,
  IconInfoFromScreenLock, MoveStartingOption } from './scene/session/SCBSceneInfoFromScreenLock';

export { FocusChangeReason } from './common/FocusChangeReason';

export { SCBWindowRaiseReason } from './common/SCBWindowRaiseReason';

export { SCBAppIconParam} from './scene/session/SCBAppIconParam';

export { default as sSampleManager } from './sampleManager/SampleManager';

export { ResUtils } from './utils/ResourceUtils';

export { launcherStatusUtil } from './utils/LauncherStatusUtil';

export { AIBarConstants } from './recent/constants/AIBarConstants';

export { SCBScreenDebugCommands } from './scene/dump/SCBScreenDebugCommands';

export { SCBSpecialScenePanelDebugCommands } from './scene/dump/SCBSpecialScenePanelDebugCommands';

export { SCBSpecificScenePanelDebugCommands } from './scene/dump/SCBSpecificScenePanelDebugCommands';

export { SCBSideEdgeBarOptions,
  SCBSideEdgeBarDisplayState,
  SCBSideManagerConstant } from './scene/session/SCBSideEdgeBarOptions';

export { SideFloatingAnimParams, SCBSideEdgeManagerParam } from './scene/session/SCBSideEdgeManagerParam';

export { MidSceneLifeCycle } from './scene/session/SCBMidSceneParam';

export { OobePreferences } from './oobe/preferences/OobePreferences';

export { getOneStepSplitOffset } from './scene/session/SCBDividerParam';

export { SceneInfoAdapterUtil } from './utils/SceneInfoAdapterUtil';

export { SCBAppUseControlManager, ControlType } from './scene/appUseControl/SCBAppUseControlManager';

export type { ControlAppInfo, ComponentBuilderParam } from './scene/appUseControl/SCBAppUseControlManager';

export { SCBWindowRotateController } from './scene/manager/SCBWindowRotateController';

export { SCBRecentSessionState, SCBRecentSessionHelper } from './scene/session/SCBRecentSessionInfo';

export { SCBSceneUtils } from './scene/utils/SCBSceneUtils';

export { SCBFoldStatePropertyChangeEvent } from './events/SCBFoldStatePropertyChangeEvent';

export { NodeBuildParams } from './animation/NodeBuildParams';

export { PreferenceStore } from './db/PreferenceStore';

export { StartMode } from './scene/common/SCBSceneEnums';

export { SCBSceneResourceManager, SceneResourceType } from './scene/manager/SCBSceneResourceManager';

export { SCBRotationConfig } from './rotation/SCBRotationConfig';

export { SCBExpandGuideParam } from './scene/session/SCBExpandGuideParam';

export { SCBKioskModeManager } from './scene/kiosk/SCBKioskModeManager';

export { ASCFWindowMgr, WindowMode } from './windowmanager/ASCFWindowManager';

export { WinLog, WinLogDomain, WinLogHelper } from './utils/WinLog';