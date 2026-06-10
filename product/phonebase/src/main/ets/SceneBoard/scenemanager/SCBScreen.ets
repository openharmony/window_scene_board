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

import { HashMap } from '@kit.ArkTS';
import { CommonConstants, DesktopModeEnum, DesktopModeManager, StyleConstants } from '@ohos/launchercommon';
import { SCBScenePanel } from './SCBScenePanel';
import { FrameCallback } from '@kit.ArkUI';
import lazy { MidSceneConfig } from '@ohos/windowscene';
import {
  DisplayMgr,
  KeyboardState,
  ResUtils,
  SCBKeyboardManager,
  SCBKeyboardPanelSession,
  SCBKeyboardSession,
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBSceneSessionManager,
  SCBScreenDebugCommands,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBSessionRect,
  SCBSystemSceneSession,
  SCBWindowRotateController,
  SpecificPanelZOrder,
  SystemBarType,
} from '@ohos/windowscene';
import {
  EvtBus,
  GlobalContext,
  localEventManager,
  RotateChangeEvent,
  SCBWindowSceneConfig,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import {
  AnimateToScheduleUtils,
  AppStorageUtil,
  DataProperty,
  LogDomain,
  LogHelper,
  SingleContext,
  Trace
} from '@ohos/basicutils';
import { RotationConstants, SCBConstants, } from '@ohos/commonconstants';
import {
  AbstractSCBSceneRegisterManager,
  SCBSystemScene,
  SystemSceneBuilderParam,
  SystemSceneOptions,
  WindowAnimationUtils
} from '@ohos/windowscene/Index';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSpecificScenePanel } from './SCBSpecificScenePanel';
import { SCBDynamicSpecificScenePanel } from './SCBDynamicSpecificScenePanel';
import { SCBKeyboardPanel } from '../keyboard/SCBKeyboardPanel';
import { FoldExpandAnimUtils } from '@ohos/launchercommon/Index';
import { SCBSpecialScenePanel } from './SCBSpecialScenePanel';
import curves from '@ohos.curves';
import { SCBPictureInPictureScenePanel } from './pip/SCBPictureInPictureScenePanel';
import lazy { SCBFloatingBallPanel } from './floatingball/view/SCBFloatingBallPanel';
import transactionManager from '@ohos.transactionManager';
import { FormClearUtils } from '../../common/FormClearUtils';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import PhoneStage from '../../common/PhoneStage';
import { SCBGestureDockParam } from '../gestureDock/dock/viewmodel/viewdata/GestureDockParam';
import { SCBSceneRegisterManager } from './SCBSceneRegisterManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { FlashlightTips } from '../flashlight/FlashlightTips';
import lazy { FlashlightTipsUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FlashlightTipsUtil';
import lazy { FlashlightTipsConstants } from '@ohos/screenlockcommon/src/main/ets/constants/FlashlightTipsConstants';
import { OneHandModeBox, OneHandModeManager } from './onehandmode/OneHandModeManager';
import { SCBSingleHandController } from './onehandmode/SCBSingleHandController';
import display from '@ohos.display';
import rpc from '@ohos.rpc';
import { BusinessError } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';
import { gestureBackSettings } from '@ohos/gestureback/src/main/ets/common/GestureBackSettings';
import lazy { SCBMicReminder } from '@ohos/multiinput';
import { SCBRotateUtils } from './utils/SCBRotateUtils';
import { DefaultPanelZIndex } from '@ohos/systemuicommon';
import { WinLog, WinLogDomain } from '@ohos/windowscene/src/main/ets/utils/WinLog';

const TAG = 'SCBScreen';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const SCREEN_SCAN_TYPE: number = Number.parseInt(systemParameterEnhance.getSync('const.window.screen.scan_type', '0'));
const FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED: number = 12;

export enum SCBDefaultZIndex {
  BOTTOM = -1,
  WALLPAPER = 1,
  DESKTOP = 2,
  NEGATIVE_SCREEN = 3,
  GLOBAL_SEARCH = 4,
  SYSTEM_SCENE_PANEL = 99,
  SCENE_PANEL = 100,  // app window
  FLOATING_SCENE_PANEL = 900, // floating app window
  SMART_DOCK = 902,
  COMPANION_VIEW = 903,
  PC_MODE_GLOBAL_SEARCH = 904,
  MUTISCREEN_COLLABORATION = 930,
  SPECIFIC_ABOVE_SCENE_PANEL = 950,
  DYNAMIC = 951,
  PIP_SCENE_PANEL = 990, // pip window
  PIP_SCENE_PANEL_OVERLAY = PIP_SCENE_PANEL + 1, // pip window overlay
  FLOATING_BALL = DefaultPanelZIndex.PANEL_FLOATING_BALL,
  INTEGRATED_DOCK = 999,
  SPECIFIC_ABOVE_SYSTEMUI = 1000,  // system app window
  THEME_EDITOR = 1650,
  BANNER = 1700,
  GESTURE_TOP_BAR = 2125,
  SHORTCUT_KEY_PANEL = 1890,
  GESTURE_DOCK = 1900,
  CFWK_DIALOG_DEFAULT = 1901, // Collaboration system window
  SYS_DIALOG_DEFAULT = 1902,
  INPUT_METHOD_BELOW_KEYGUARD = 1903,
  BANNER_LIVE = 1904,
  SHUTDOWN_VIEW = 1905,
  SCREEN_LOCK_WALL_PAPER = 1999,
  SCREEN_LOCK = 2000,
  SCREEN_LOCK_BOUNCER = 2001,
  SCREEN_FORM_CENTER = 2002,
  SPECIAL_SCENE_PANEL = 2100, // app window above keyguard
  WALLET_SWIPE_CARD = 2150, // system app above screenlock, below voice interaction
  SPECIFIC_VOICE_INTERACTION = 2190,
  INPUT_METHOD_SPECIFIC_VOICE_INTERACTION = 2191, // keyboard above keyguard, below GESTURE_NAVIGATION and DROP_DOWN
  SPECIFIC_FLOAT_NAVIGATION = 2195, // float navigation above SPECIFIC_VOICE_INTERACTION, below GESTURE_NAVIGATION
  EXPAND_GUIDE_BOX = 2196,
  GESTURE_NAVIGATION = 2200,
  DROP_DOWN = 2201,
  STATUS_BAR = 2202,
  SPECIFIC_MEDIA_CONTROL_TEMP = 2203, // temp for media control
  FLASHLIGHT_TIPS_AND_EMERGENCY_MODE = 2204, // 扩展新形态小折叠产品产品外屏手电筒提示页及外屏应急模式窗口层级
  SPECIFIC_ABOVE_KEYGUARD = 3000, // system app window above keyguard
  CFWK_DIALOG_UPPER = 3900, // Collaboration system window
  SYS_DIALOG_UPPER = 3901,
  SCREEN_LOCK_SPECIAL_BOUNCER = 3902, // the panel for request unlock by app above keyguard
  INPUT_METHOD_ABOVE_KEYGUARD = 3903,
  SPECIFIC_SCENE_PANEL_VOLUME = 4000, // system app volume overlay window
  VOLUME_PANEL = 4100,
  SIDE_EDGE_MANAGER = 4101,
  GESTURE_BACK = 4102,
  SIDE_EDGE_BAR = 4103,
  SYSTEM_TOAST = 7000,
  SPACED_GESTURE = 7100,
  SPECIFIC_SCREENSHOT = 8000, // system window for SCREENSHOT
  SYSTEM_TOP_PANEL = 9000,//the panel for metaBalls
  SCREEN_CONTROL = 9997,
  TOP = 9999,
  MAGNIFICATION = 10000,
  MAGNIFICATION_MENU = 10001
}

export const ZORDER_TO_DEFAULTZINDEX : Map<SpecificPanelZOrder, SCBDefaultZIndex> =
  new Map<SpecificPanelZOrder, SCBDefaultZIndex>([
    [SpecificPanelZOrder.MUTISCREEN_COLLABORATION, SCBDefaultZIndex.MUTISCREEN_COLLABORATION],
    [SpecificPanelZOrder.ABOVE_SCENE_PANEL, SCBDefaultZIndex.SPECIFIC_ABOVE_SCENE_PANEL],
    [SpecificPanelZOrder.ABOVE_SYSTEMUI, SCBDefaultZIndex.SPECIFIC_ABOVE_SYSTEMUI],
    [SpecificPanelZOrder.MEDIA_CONTROL_TEMP, SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP],
    [SpecificPanelZOrder.VOICE_INTERACTION, SCBDefaultZIndex.SPECIFIC_VOICE_INTERACTION],
    [SpecificPanelZOrder.FLOAT_NAVIGATION, SCBDefaultZIndex.SPECIFIC_FLOAT_NAVIGATION],
    [SpecificPanelZOrder.ABOVE_KEYGUARD, SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD],
    [SpecificPanelZOrder.VOLUME, SCBDefaultZIndex.SPECIFIC_SCENE_PANEL_VOLUME],
    [SpecificPanelZOrder.SYSTEM_TOAST, SCBDefaultZIndex.SYSTEM_TOAST],
    [SpecificPanelZOrder.SCREENSHOT, SCBDefaultZIndex.SPECIFIC_SCREENSHOT],
    [SpecificPanelZOrder.WALLET_SWIPE_CARD, SCBDefaultZIndex.WALLET_SWIPE_CARD],
    [SpecificPanelZOrder.SCREEN_CONTROL, SCBDefaultZIndex.SCREEN_CONTROL],
    [SpecificPanelZOrder.MAGNIFICATION, SCBDefaultZIndex.MAGNIFICATION],
    [SpecificPanelZOrder.MAGNIFICATION_MENU, SCBDefaultZIndex.MAGNIFICATION_MENU],
  ]);

export enum SCBWindowInputType {
  NORMAL = 0,
  TRANSMIT_ALL = 1,
  TRANSMIT_EXCEPT_MOVE = 2,
  ANTI_MISTAKE_TOUCH = 3,
  TRANSMIT_AXIS_MOVE = 4,
  TRANSMIT_MOUSE_MOVE = 5,
  TRANSMIT_LEFT_RIGHT = 6,
  TRANSMIT_BUTTOM = 7,
  MIX_LEFT_RIGHT_ANTI_AXIS_MOVE = 18,
  MIX_BUTTOM_ANTI_AXIS_MOVE = 19,
  SLID_TOUCH_WINDOW = 40,
  TRANSMIT_ANTI_AXIS_MOVE = 50,
  DUALTRIGGER_TOUCH = 60
}

export class RecentFrameCallback extends FrameCallback {
  private callback: Callback<number>;

  constructor(callback: Callback<number>) {
    super();
    this.callback = callback;
  }

  onFrame(frameTimeNanos: number): void {
    log.showInfo('RecentFrameCallback called');
    if (this.callback) {
      this.callback(frameTimeNanos);
    }
  }
}


export enum SCBScreenPowerEventType {
  WAKE_UP = 0,
  SLEEP = 1,
  DISPLAY_ON = 2,
  DISPLAY_OFF = 3,
  DESKTOP_READY = 4,
}

export enum SCBScreenPowerEventStatus {
  BEGIN = 0,
  END = 1,
}

export enum SCBScreenPowerStatusChangeReason {
  POWER_CHANGE_REASON_INIT = 0,
  POWER_CHANGE_REASON_TIMEOUT = 1,
  POWER_CHANGE_REASON_RUNNING_LOCK = 2,
  POWER_CHANGE_REASON_BATTERY = 3,
  POWER_CHANGE_REASON_THERMAL = 4,
  POWER_CHANGE_REASON_WORK = 5,
  POWER_CHANGE_REASON_SYSTEM = 6,
  POWER_CHANGE_REASON_APPLICATION = 10,
  POWER_CHANGE_REASON_SETTINGS = 11,
  POWER_CHANGE_REASON_HARD_KEY = 12,
  POWER_CHANGE_REASON_TOUCH = 13,
  POWER_CHANGE_REASON_CABLE = 14,
  POWER_CHANGE_REASON_SENSOR = 15,
  POWER_CHANGE_REASON_LID = 16,
  POWER_CHANGE_REASON_CAMERA = 17,
  POWER_CHANGE_REASON_ACCESSIBILITY = 18,
  POWER_CHANGE_REASON_RESET = 19,
  POWER_CHANGE_REASON_POWER_KEY = 20,
  POWER_CHANGE_REASON_KEYBOARD = 21,
  POWER_CHANGE_REASON_MOUSE = 22,
  POWER_CHANGE_REASON_DOUBLE_CLICK = 23,
  POWER_CHANGE_REASON_SWITCH = 25,
  POWER_CHANGE_REASON_PRE_BRIGHT = 26,
  POWER_CHANGE_REASON_PRE_BRIGHT_AUTH_SUCCESS = 27,
  POWER_CHANGE_REASON_PRE_BRIGHT_AUTH_FAIL_SCREEN_ON = 28,
  POWER_CHANGE_REASON_PRE_BRIGHT_AUTH_FAIL_SCREEN_OFF = 29,
  POWER_CHANGE_REASON_DISPLAY_SWITCH = 30,
  POWER_CHANGE_REASON_PROXIMITY = 32,
  POWER_CHANGE_REASON_AOD_SLIDING = 40,
  POWER_CHANGE_REASON_PEN = 41,
  POWER_CHANGE_REASON_SHUT_DOWN = 42,
  POWER_CHANGE_REASON_SCREEN_CONNECT = 43,
  POWER_CHANGE_REASON_HIBERNATE = 45,
  POWER_CHANGE_REASON_REMOTE = 100,
  POWER_CHANGE_REASON_UNKNOWN = 1000,
}

export class SCBScreenPowerEvent {
  public eventType: SCBScreenPowerEventType = SCBScreenPowerEventType.WAKE_UP;
  public eventStatus: SCBScreenPowerEventStatus = SCBScreenPowerEventStatus.BEGIN;
  public changeReason: SCBScreenPowerStatusChangeReason = SCBScreenPowerStatusChangeReason.POWER_CHANGE_REASON_UNKNOWN;
}

@Component
export struct SCBScreen {
  @ObjectLink screenSession: SCBScreenSession
  @State scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  @State singleContext?: SingleContext = undefined;
  @State physicalScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  @State keyboardSession: SCBKeyboardSession | undefined = undefined;
  @State keyboardState : KeyboardState = KeyboardState.UNDEFINED;
  @State keyboardPanelSession: SCBKeyboardPanelSession | undefined = undefined;
  private debugCommands = new SCBScreenDebugCommands();
  @State isInEmergencyOrThermalSafeMode: boolean = false;
  @StorageLink('isShowTipForFloating') isShowTipForFloating: boolean = false;
  @StorageLink('isShowTipForSplit') isShowTipForSplit: boolean = false;
  @StorageLink('isNeedShowTipForMid') isNeedShowTipForMid: boolean = false;
  @State gestureDockParam: SCBGestureDockParam = SCBGestureDockParam.getInstance();
  @State desktopModeNum: number = DesktopModeManager.getInstance().getDesktopMode();
  @State isShowFlashlightTips: boolean = false;
  @State scaleX: number = 1;
  @State scaleY: number = 1;
  @State scaleCenterX: string | undefined = '0%';
  @State scaleCenterY: string | undefined = '0%';
  @State radius: number = 0.0;
  @State enableShowOneHandModeBackground: boolean = false;
  @State oneHandModeBoxBorderWidth: number = 0.0;
  @State oneHandModeBoxBorderColor: string = '#00ffffff';
  @State enableScreenSnapshot: boolean = false;
  @State screenSnapshotOpacity: number = 1.0;
  @State screenSnapshotBlur: number = 0;
  @State oneHandModeBoxBlur: number = 0;
  @StorageProp('isCFWKDialogOpen') isCFWKDialogOpen: boolean = false;
  private mStage: PhoneStage = new PhoneStage();
  private scbSceneRegisterManager: AbstractSCBSceneRegisterManager = new SCBSceneRegisterManager();
  private isDialogstatusOpen: boolean = false;
  private isReflexionDialogShow: boolean = false;
  private numberOfKeyValuePairs: number = 3;
  private openDialogFlag: number = 1;
  private closeDialogFlag: number = 3;
  private scbSingleHandController = SCBSingleHandController.getInstance();

  // 用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  // 用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制
  private contextCornerTop: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private contextCornerBottom: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private mScreenWidth: number = 1080;
  private mScreenHeight: number = 1920;
  @State mIsInit: boolean = false;
  padSystemSceneBuilderMap?: HashMap<String, ($$: SystemSceneBuilderParam) => void>;

  private drawRoundCornerTop(x: number, y: number, width: number, height: number, radius: number,
    fillColor?: string | number | CanvasGradient | CanvasPattern, lineDash?: []) {
    log.showInfo("OneHandModeBox drawRoundCornerTop start");
    lineDash = lineDash || [];
    this.contextCornerTop.beginPath();
    this.contextCornerTop.setLineDash(lineDash);

    this.contextCornerTop.moveTo(x, y);
    this.contextCornerTop.lineTo(x, y + radius);
    this.contextCornerTop.arc(x + radius, y + radius, radius, Math.PI, Math.PI * 3 / 2);
    this.contextCornerTop.lineTo(x, y);

    this.contextCornerTop.moveTo(x + width, y);
    this.contextCornerTop.lineTo(x + width - radius, y);
    this.contextCornerTop.arc(x + width - radius, y + radius, radius, Math.PI * 3 / 2, Math.PI * 2);
    this.contextCornerTop.lineTo(x + width, y);

    if (fillColor) {
      this.contextCornerTop.fillStyle = fillColor;
      this.contextCornerTop.fill();
    }
    this.contextCornerTop.closePath();
  }

  private drawRoundCornerBottom(x: number, y: number, width: number, height: number, radius: number,
    fillColor?: string | number | CanvasGradient | CanvasPattern, lineDash?: []) {
    log.showInfo("OneHandModeBox drawRoundCornerBottom start");
    lineDash = lineDash || [];
    this.contextCornerBottom.beginPath();
    this.contextCornerBottom.setLineDash(lineDash);

    this.contextCornerBottom.moveTo(x + width, y + height);
    this.contextCornerBottom.lineTo(x + width, y + height - radius);
    this.contextCornerBottom.arc(x + width - radius, y + height - radius, radius, 0, Math.PI / 2);
    this.contextCornerBottom.lineTo(x + width, y + height);

    this.contextCornerBottom.moveTo(x, y + height);
    this.contextCornerBottom.lineTo(x + radius, y + height);
    this.contextCornerBottom.arc(x + radius, y + height - radius, radius, Math.PI / 2, Math.PI);
    this.contextCornerBottom.lineTo(x, y + height);

    if (fillColor) {
      this.contextCornerBottom.fillStyle = fillColor;
      this.contextCornerBottom.fill();
    }
    this.contextCornerBottom.closePath();
  }

  /**
   * 应用窗口、多任务面板等session状态
   */
  private windowAnimationUtils: WindowAnimationUtils = WindowAnimationUtils.getInstance();
  @Provide screenRotationAnimCnt: number = 0;
  private rotateFinishTimerId: number = -1;
  private transxSecondary: number = 612;
  private transySecondary: number = -612;

  // screen property change
  async onScreenPropertyChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason,
    needNotify: boolean): Promise<void> {
    this.scbScreenProperty.screenId = this.screenSession.session.screenId;
    this.singleContext = { extendScreenId: this.scbScreenProperty.screenId };
    log.showInfo('onScreenPropertyChange current: ' + this.scbScreenProperty.getLogString() + ', screenProperty: ' +
    screenProperty.getLogString() + ' reason: ' + reason);
    switch (reason) {
      case SCBPropertyChangeReason.ROTATION: {
        this.rotateWindow(screenProperty, reason, needNotify);
        return;
      }
      case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION:
        this.rotateScreenWithAnimation(screenProperty, reason);
        break;
      case SCBPropertyChangeReason.FOLD_LANDSCAPE_START:
        this.rotateFoldScreenStart(screenProperty, needNotify);
        break;
      case SCBPropertyChangeReason.CHANGE_MODE: {
        this.rotateChangeMode(screenProperty, reason);
        break;
      }
      case SCBPropertyChangeReason.FOLD_TO_EXPAND: {
        SCBTriFoldManager.getInstance().updateTriFoldStateIfNeeded();
        this.rotateFoldToExpand(screenProperty, reason);
        break;
      }
      case SCBPropertyChangeReason.EXPAND_TO_FOLD: {
        SCBTriFoldManager.getInstance().updateTriFoldStateIfNeeded();
        this.rotateExpandToFold(screenProperty, reason);
        break;
      }
      case SCBPropertyChangeReason.FOLD_SCREEN_CONNECT: {
        this.rotateFoldScreenConnect(screenProperty, reason);
        break;
      }
      case SCBPropertyChangeReason.SCREEN_CONNECT: {
        this.rotateScreenConnect(screenProperty, reason);
        break;
      }
      case SCBPropertyChangeReason.PAGE_ROTATION: {
        this.rotateScreenWithAnimation(screenProperty, reason);
        break;
      }
      default:
        log.showError('unknown reason type:' + reason);
        break;
    }
    DisplayMgr.onScreenPropertyChange(this.screenSession);
  }

  initScreenProperty(): void {
    this.scbScreenProperty.copyBounds(this.screenSession.physicalBounds);
    this.physicalScreenProperty.copyBounds(this.screenSession.physicalBounds);
    log.showInfo('initScreenProperty sensor: ' + JSON.stringify(this.scbScreenProperty))
  }

  private rotateWindow(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason, needNotify: boolean): void {
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.screenId = this.screenSession.session.screenId;
    if (needNotify) {
      // only need rotate scene panel with phone not foldable or not expand
      log.showInfo('rotateWindow screenProperty: ' + tmpProperty.getLogString() + ' reason: ' +
        reason + ', needNotify, screenId: ' + screenProperty.screenId);
      SCBScreenSessionManager.getInstance().notifyScenePanelRotationChange(tmpProperty, this.scbScreenProperty);
      return;
    }
    log.showInfo('rotateWindow screenProperty: ' + tmpProperty.getLogString() + ' reason: ' +
      reason + ', no needNotify');
    this.scbScreenProperty.copy(tmpProperty);
  }

  private rotateChangeMode(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateChangeMode] update SCBScreen ScreenProperty: ' + JSON.stringify(screenProperty) +
      ' reason: ' + reason);
    this.physicalScreenProperty.copyBounds(this.screenSession.physicalBounds);
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.screenId = this.screenSession.session.screenId;
    SCBScreenSessionManager.getInstance().notifyScenePanelActiveModeChange(tmpProperty);
  }

  private rotateFoldToExpand(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateFoldToExpand] update SCBScreen ScreenProperty: ' + JSON.stringify(screenProperty) +
      ' reason: ' + reason);
    performanceMonitor.begin('FOLD_TO_EXPAND', performanceMonitor.ActionType.LAST_UP);
    let animationInterrupt: boolean = this.animationInterruptByFoldToExpand(screenProperty, reason);
    if (!animationInterrupt) {
      this.rotateFoldToExpandInner(screenProperty, reason);
    }

    this.getUIContext().postFrameCallback(new RecentFrameCallback((frameTimeNanos: number) => {
      SCBScreenSessionManager.getInstance().notifyFoldToExpandCompletion(true);
    }))
    performanceMonitor.end('FOLD_TO_EXPAND');
  }

  private animationInterruptByFoldToExpand(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason): boolean {
    if (OneHandModeManager.getInstance().isAnimating) {
      log.showInfo(`interrupt one hand mode exit animation when expand`);
      this.radius = 0;
      this.enableShowOneHandModeBackground = false;
      animateTo({
        duration: 0,
        onFinish: () => {
          this.scaleX = 1;
          this.scaleY = 1;
          OneHandModeManager.getInstance().isAnimating = false;
        }
      }, () => {
        // make the end point a little different from the true end point for animation interrupt
        this.scaleX = 1.0001;
        this.scaleY = 1.0001;
        this.rotateFoldToExpandInner(screenProperty, reason);
      });
      return true;
    }
    return false;
  }

  private rotateFoldToExpandInner(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty);
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.screenId = this.screenSession.session.screenId;
    this.physicalScreenProperty.copy(tmpProperty);
    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this.screenSession)) {
      this.physicalScreenProperty.rotateTo(0);
      let width = this.physicalScreenProperty.width;
      let height = this.physicalScreenProperty.height;
      this.physicalScreenProperty.updateTranslate(-(width - height) / 2, (width - height) / 2);
    } else {
      tmpProperty.rotation = 0;
      tmpProperty.updateTranslate(0, 0);
    }
    this.scbScreenProperty.copy(tmpProperty);
    SCBScreenSessionManager.getInstance().notifyScenePanelFoldChange(tmpProperty, reason);
    SCBScreenSessionManager.getInstance().updateFoldMode(tmpProperty, reason);
  }

  private rotateExpandToFold(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateExpandToFold] update SCBScreen ScreenProperty: ' + JSON.stringify(screenProperty) +
      ' reason: ' + reason);
    performanceMonitor.begin('EXPAND_TO_FOLD', performanceMonitor.ActionType.LAST_UP);

    let tmpProperty = screenProperty.getCopy();
    tmpProperty.screenId = this.screenSession.session.screenId;
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(tmpProperty);
    this.physicalScreenProperty.copy(tmpProperty);
    this.physicalScreenProperty.rotateTo(0);
    this.scbScreenProperty.copy(tmpProperty);
    SCBScreenSessionManager.getInstance().notifyScenePanelFoldChange(tmpProperty, reason);
    SCBScreenSessionManager.getInstance().updateFoldMode(tmpProperty, reason);
    this.getUIContext().postFrameCallback(new RecentFrameCallback((frameTimeNanos: number) => {
      SCBScreenSessionManager.getInstance().notifyFoldToExpandCompletion(false);
    }))
    performanceMonitor.end('EXPAND_TO_FOLD');
  }

  private rotateScreenConnect(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenConnect] update SCBScreen ScreenProperty: ' + screenProperty.getLogString() +
      ' reason: ' + reason);
    let tmpProperty = screenProperty.getCopy();
    tmpProperty.screenId = this.screenSession.session.screenId;
    this.scbScreenProperty.copy(tmpProperty);
    this.physicalScreenProperty.copy(tmpProperty);
    if (this.screenSession.isRotateScreenPolicy()) {
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty);
      this.scbScreenProperty.clearCorrectingRotation();
      this.scbScreenProperty.rotation = 0;
      this.scbScreenProperty.updateTranslate(0, 0);
    } else {
      if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this.screenSession)) {
        SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty);
        if (SCREEN_SCAN_TYPE !== SCBConstants.SCREEN_SCAN_TYPE_VERTICAL) {
          this.physicalScreenProperty.updateTranslate(0, 0);
        }
        this.physicalScreenProperty.rotateTo(0);
      } else {
        this.physicalScreenProperty.clearCorrectingRotation();
        this.physicalScreenProperty.rotation = 0;
        this.physicalScreenProperty.updateTranslate(0, 0);
      }
    }
    if (uiType === SCBConstants.UITYPE_PAD) {
      log.showInfo('notify sensor rotation to PAD after SCREEN_CONNECT');
      SCBScreenSessionManager.getInstance().notifyFoldToExpandCompletion(true);
    }
    log.showInfo('rotateScreenConnect physicalScreenProperty: ' +
    this.physicalScreenProperty.getLogString() + ' reason: ' + reason);
  }

  private rotateFoldScreenConnect(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateFoldScreenConnect] update SCBScreenProperty: ' + JSON.stringify(screenProperty) +
      ' reason: ' + reason);
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.screenId = this.screenSession.session.screenId;
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty);
    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this.screenSession)) {
      tmpProperty.rotation = 0;
      this.physicalScreenProperty.copy(tmpProperty);
      this.scbScreenProperty.copy(tmpProperty);
      let width = this.physicalScreenProperty.width;
      let height = this.physicalScreenProperty.height;
      let transX = -(width - height) / 2;
      let transY = (width - height) / 2;
      this.physicalScreenProperty.updateTranslate(transX, transY);
    } else {
      this.physicalScreenProperty.copy(tmpProperty);
      tmpProperty.rotation = 0;
      tmpProperty.updateTranslate(0, 0);
      this.scbScreenProperty.copy(tmpProperty);
    }
  }

  private rotateFoldScreenStart(screenProperty: SCBScreenProperty, needNotify: boolean = true): void {
    const reason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
    this.rotateScreenNoAnimation(screenProperty, reason, needNotify);
  }

  // 无动效旋转屏幕
  private rotateScreenNoAnimation(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason, needNotify: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenNoAnimation] update SCBScreenProperty: ' + screenProperty.getLogString() +
      ' reason: ' + reason);
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
      SCBRotateChangeReason.ROTATE_BEGIN);
    if (needNotify) {
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty);
    }
    let rotationWindow = SCBWindowRotateController.getInstance()
      .notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN, true);
    this.physicalScreenProperty.copy(screenProperty);
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.screenId = this.screenSession.session.screenId;
    tmpProperty.rotation = 0;
    tmpProperty.updateTranslate(0, 0);
    this.scbScreenProperty.copy(tmpProperty);
    SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    SCBScreenSessionManager.getInstance().notifyScenePanelPropertyChange(tmpProperty, reason);
    SCBScreenSessionManager.getInstance().updateScreenPropertyToCallbacks(tmpProperty, reason);
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateFoldMode(tmpProperty, reason);
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
      SCBRotateChangeReason.ROTATE_END);
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
  }

  // 带动效旋转屏幕
  private rotateScreenWithAnimation(property: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    // cannot change scbScreenProperty immediately, since animation in scene panel need property before rotation
    // change screen property in scene panel uniformly
    let screenProperty = property.getCopy();
    screenProperty.screenId = this.screenSession.session.screenId;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWithAnimation] update ScreenProperty: ' + screenProperty.getLogString() +
      ' reason: ' + reason);
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    this.screenRotationAnimCnt++;
    if (SCBSceneSessionManager.getInstance().hasFullSceneSession(screenProperty.screenId)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWithAnimation] hasFullSceneSession need hide background');
      viewMgrPolicy.hideView(ViewType.DESKTOP);
      viewMgrPolicy.hideView(ViewType.WALLPAPER);
    } else if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' screen lock need hide desktop');
      viewMgrPolicy.hideView(ViewType.DESKTOP);
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_1);
    performanceMonitor.begin('EXPAND_SCREEN_ROTATION_ANI', performanceMonitor.ActionType.LAST_UP);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[rotateScreenWithAnimation] startRotationAnimate,${this.screenRotationAnimCnt}`);
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_START);
    EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
      SCBRotateChangeReason.ROTATE_BEGIN);
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
      SCBRotateChangeReason.ROTATE_BEGIN);
    if (reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      this.handleScreenPageRotationAnimate(screenProperty, reason, rotateEvent);
    } else {
      this.handleFoldScreenAnimate(screenProperty, reason, rotateEvent);
    }
  }

  private handleScreenPageRotationAnimate(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
    rotateEvent: RotateChangeEvent) : void {
    // 屏幕页面级旋转方案，只需要把宽高变化通知到各个组件就可以了
    let rotateDuration: number = 0;
    SCBSceneSessionManager.getInstance().updateRotateAnimationConfig(rotateDuration);
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.rotation = 0;
    tmpProperty.updateTranslate(0, 0);
    let rotationWindow =
      SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> = new Array();
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[handleScreenPageRotationAnimate] startRotationAnimate,${this.screenRotationAnimCnt}`);
    transactionManager.openSyncTransaction(screenProperty.screenId);
    this.physicalScreenProperty.prepareCorrectingRotationForRotate(screenProperty);
    this.keyboardSession?.setKeyboardRotationFlag(true);
    AppStorageUtil.setOrCreate('isScreenProperty', true, new DataProperty(true, false));
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
      sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.setRotateFinishTimer(screenProperty, rotateEvent);
    animateTo({ duration: 0 }, () => {
      let currScreenProperty = this.scbScreenProperty.getCopy();
      this.physicalScreenProperty.copy(screenProperty);
      this.physicalScreenProperty.clearCorrectingRotation();
      this.scbScreenProperty.copy(tmpProperty);
      SCBScreenSessionManager.getInstance().updateSystemSceneFoldChangeBeforeScenePanel(tmpProperty, reason);
      SCBScreenSessionManager.getInstance().notifyScenePanelPropertyChange(tmpProperty, reason, currScreenProperty);
      inVisibleSystemSceneCallbacks = SCBScreenSessionManager.getInstance().updateSystemSceneFoldChange(tmpProperty,
        reason);
      SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    });
    this.rotationAnimationFinished(screenProperty, rotateEvent);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_0);
    SCBScreenSessionManager.getInstance().updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks,
      tmpProperty, reason);
    transactionManager.closeSyncTransaction(screenProperty.screenId);
  }

  private handleFoldScreenAnimate(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
    rotateEvent: RotateChangeEvent) : void {
    // 屏幕旋转方案，只需要把宽高变化通知到各个组件就可以了
    let rotateDuration: number = 600;
    SCBSceneSessionManager.getInstance().updateRotateAnimationConfig(rotateDuration);
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.rotation = 0;
    tmpProperty.updateTranslate(0, 0);
    let rotationWindow =
      SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> = new Array();
    WinLog.showInfo(WinLogDomain.WMS_ROTATION,
      `[handleFoldScreenAnimate] startRotationAnimate,${this.screenRotationAnimCnt}`);
    transactionManager.openSyncTransaction(screenProperty.screenId);
    this.physicalScreenProperty.prepareCorrectingRotationForRotate(screenProperty);
    this.keyboardSession?.setKeyboardRotationFlag(true);
    AppStorageUtil.setOrCreate('isScreenProperty', true, new DataProperty(true, false));
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
      sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.setRotateFinishTimer(screenProperty, rotateEvent);
    animateTo({
      duration : rotateDuration,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        this.rotationAnimationFinished(screenProperty, rotateEvent);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_0);
      }
    }, () => {
      let currScreenProperty = this.scbScreenProperty.getCopy();
      this.physicalScreenProperty.copy(screenProperty);
      this.physicalScreenProperty.clearCorrectingRotation();
      this.scbScreenProperty.copy(tmpProperty);
      SCBScreenSessionManager.getInstance().updateSystemSceneFoldChangeBeforeScenePanel(tmpProperty, reason);
      SCBScreenSessionManager.getInstance().notifyScenePanelPropertyChange(tmpProperty, reason, currScreenProperty);
      inVisibleSystemSceneCallbacks = SCBScreenSessionManager.getInstance().updateSystemSceneFoldChange(tmpProperty,
        reason);
      SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    });
    SCBScreenSessionManager.getInstance().updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks,
      tmpProperty, reason);
    transactionManager.closeSyncTransaction(screenProperty.screenId);
  }

  private setRotateFinishTimer(screenProperty: SCBScreenProperty, rotateEvent: RotateChangeEvent): void {
    if (this.rotateFinishTimerId !== -1) {
      clearTimeout(this.rotateFinishTimerId);
    }
    this.rotateFinishTimerId = setTimeout(() => {
      this.rotationAnimationFinished(screenProperty, rotateEvent, true);
      this.rotateFinishTimerId = -1;
    }, 3000);
  }

  private rotationAnimationFinished(screenProperty: SCBScreenProperty, rotateEvent: RotateChangeEvent,
    isTimeoutCheck: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION,
      `[rotationAnimationFinished] screenRotationAnimCnt:${this.screenRotationAnimCnt}, ` +
        ` isTimeoutCheck:${isTimeoutCheck}`);
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    if (isTimeoutCheck) {
      if (this.screenRotationAnimCnt > 0) {
        this.screenRotationAnimCnt = 1;
      } else {
        return;
      }
    }
    this.screenRotationAnimCnt--;
    if (this.screenRotationAnimCnt < 0) {
      this.screenRotationAnimCnt = 0;
      return;
    }
    this.keyboardSession?.setKeyboardRotationFlag(false);
    AppStorageUtil.setOrCreate('isScreenProperty', false, new DataProperty(true, false));
    if (this.screenRotationAnimCnt === 0) {
      SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
      SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      rotateEvent.rotateStatus = RotateChangeEvent.ROTATE_STATUS_END;
      // for pad midScene
      let topSession = SCBSceneSessionManager.getInstance()
        .getContainerSessionList(screenProperty.screenId)?.getTopActiveSession();
      if (MidSceneConfig.isSupportPadDifference() && !!topSession && topSession?.isMidScene) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationAnimationFinished] midscene not show wallPaper');
      } else {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationAnimationFinished] not midscene show wallPaper');
        viewMgrPolicy.showView(ViewType.WALLPAPER);
      }
      if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' ROTATE_END screen lock need show desktop');
        viewMgrPolicy.showView(ViewType.DESKTOP);
      }
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      performanceMonitor.end('EXPAND_SCREEN_ROTATION_ANI');
    }
  }

  private notifyKeyboardStateChangeForSystemSession(isActive : boolean) {
    let callingSession = this.keyboardSession?.getCallingSession();
    if (!callingSession || !this.keyboardSession) {
      log.showError('[SCBKeyboard] error callingSession or input session');
      return;
    }
    if (!(callingSession instanceof SCBSystemSceneSession)) {
      log.showDebug('[SCBKeyboard] callingSession is not system session');
      return;
    }

    let duration : number = 0;
    let curve : ICurve | Curve = this.windowAnimationUtils.getInputAnimationCurve('enter');
    let keyboardHeight : number | undefined;
    if (!isActive) {
      keyboardHeight = 0;
      curve = this.windowAnimationUtils.getInputAnimationCurve('exit');
      duration = this.windowAnimationUtils.getInputAnimationDuration('exit');
      log.showDebug('[SCBKeyboard] input exit, callingWindowId ' + callingSession?.session.persistentId +
        ', keyboardHeight: ' + keyboardHeight + ', duration' + duration);
    } else {
      keyboardHeight = this.keyboardPanelSession?.getPanelRealHeight();
      curve = this.windowAnimationUtils.getInputAnimationCurve('enter');
      duration = this.windowAnimationUtils.getInputAnimationDuration('enter');
      log.showDebug('[SCBKeyboard] input enter, ' + 'keyboardHeight: ' + keyboardHeight + ', duration' + duration);
    }

    animateTo({
      curve: curve,
      duration: duration
    }, () => {
      (callingSession as SCBSystemSceneSession)?.notifyInputMethodChange(keyboardHeight);
    })
  }

  private updateKeyboardStateInfo(keyboardState: KeyboardState, isActive: boolean, translatePosY: number = 0): void {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      return;
    }
    this.keyboardSession.isActive = isActive;
    this.keyboardState = keyboardState;
    if (!isActive) {
      this.keyboardSession.updateKeyboardEnableShow(false);
    } else {
      this.keyboardSession.translatePosY = translatePosY;
    }
  }

  private keyboardVisibilityChangeWithoutAnimation(callingId: number, panelRect: SCBSessionRect,
    keyboardState: KeyboardState, isActive: boolean): void {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      log.showError('[SCBKeyboardAnimate] keyboardSession is null');
      return;
    }
    this.updateKeyboardStateInfo(keyboardState, isActive);
    if (!this.keyboardSession.isFloatGravity()) {
      this.keyboardSession.notifyKeyboardAnimationCompleted(callingId, isActive, panelRect);
    }
    SCBKeyboardManager.getInstance().closeKeyboardAnimation(false);
  }

  private keyboardVisibilityChangeWithAnimation(callingId: number, panelRect: SCBSessionRect,
    keyboardState: KeyboardState, isActive: boolean) : void {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      log.showError('[SCBKeyboardAnimate] keyboardSession is null');
      return;
    }

    if (this.keyboardSession.animCnt >= 1) {
      // For multiple submissions of animations, directly notify that the previous animation has been completed.
      this.keyboardSession.notifyKeyboardAnimationCompleted(callingId, this.keyboardSession.isShowAnimation,
        panelRect);
    }
    this.keyboardSession.sessionData.animCnt++;
    const translatePosY = this.keyboardSession.getKeyboardPanelTranslateY();
    let keyboardAnimation: string = 'SHOW_INPUT_METHOD_ANIMATION';
    let animationType: string = 'enter';
    if (isActive) {
      this.keyboardSession.sessionData.isShowAnimation = true;
      this.updateKeyboardStateInfo(keyboardState, isActive, translatePosY);
    } else {
      this.keyboardSession.sessionData.isShowAnimation = false;
      keyboardAnimation = 'HIDE_INPUT_METHOD_ANIMATION';
      animationType = 'exit';
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.INPUT_METHOD_ANIMATION, StyleConstants.DEFAULT_1);
    performanceMonitor.begin(keyboardAnimation, performanceMonitor.ActionType.LAST_UP);
    this.getUIContext()?.animateTo({
      duration: this.windowAnimationUtils.getInputAnimationDuration(animationType),
      curve: this.windowAnimationUtils.getInputAnimationCurve(animationType),
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish:() => {
        performanceMonitor.end(keyboardAnimation);
        if (this.keyboardSession instanceof SCBKeyboardSession) {
          this.keyboardSession.sessionData.animCnt--;
          log.showInfo(`[SCBKeyboardAnimate] finished, callingId: ${callingId}, isActive: ${isActive}` +
            `, animCnt: ${this.keyboardSession.animCnt}`);
          if (this.keyboardSession.animCnt <= 0) {
            if (this.keyboardSession.sessionState === sceneSessionManager.SessionState.STATE_BACKGROUND) {
              this.updateKeyboardStateInfo(keyboardState, false);
            }
            this.keyboardSession.sessionData.animCnt = 0;
            this.keyboardSession.notifyKeyboardAnimationCompleted(callingId, isActive, panelRect);
          }
        }
        // ApsUtils.setApsScene(apsManager.SceneAnimation.INPUT_METHOD_ANIMATION, StyleConstants.DEFAULT_0);
      }
    }, () => {
      if (this.keyboardSession instanceof SCBKeyboardSession) {
        this.keyboardSession.translatePosY = isActive ? 0 : translatePosY;
        log.showInfo('[SCBKeyboardAnimate] translate: ' + this.keyboardSession.translatePosY +
          ', keyboardOffset: ' + this.keyboardSession.keyboardOffset + ', isActive: ' + isActive +
          ', animCnt: ' + this.keyboardSession.animCnt);
      }
    });
  }

  private changeKeyboardState(keyboardState: KeyboardState,
    sessionState: sceneSessionManager.SessionState, isActive: boolean) {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      log.showError('[SCBKeyboard] Input session is null, getKeyboardSession');
      this.keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
      if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
        log.showError('[SCBKeyboard] Input session is still null after get from SCBKeyboardManager');
        return;
      }
    }

    if (!(this.keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      this.keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
      if (!(this.keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
        log.showError('[SCBKeyboard] panel session is still null after get from SCBSceneSessionManager');
        return;
      }
    }

    if (sessionState === sceneSessionManager.SessionState.STATE_CONNECT) {
      log.showInfo('[SCBKeyboard] connect keyboard session');
      return;
    }

    this.notifyKeyboardStateChangeForSystemSession(isActive);
    if (sessionState === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      this.keyboardSession.isActive = false;
      this.keyboardSession = undefined;
      this.keyboardState = KeyboardState.UNDEFINED;
      log.showInfo('[SCBKeyboard] disconnect input session');
      return;
    }

    log.showInfo(`[SCBKeyboard] changeKeyboardState, keyboardState: ${this.keyboardState}, isActive: ${isActive}`);
    const callingId = this.keyboardSession.getCallingSessionId();
    const panelRect = this.keyboardSession.getKeyboardPanelRealRect();
    let withAnimation = false;
    // if (!this.keyboardSession.isWindowShowAnimate || this.keyboardSession.isCloseKeyboardAnimation ||
    // this.keyboardSession.isRectAbnormal(isActive, this.scbScreenProperty, panelRect)) {
      log.showInfo('[SCBKeyboard] isShowAnimate: ' + this.keyboardSession.isWindowShowAnimate +
        ', isCloseAnimation: ' + this.keyboardSession.isCloseKeyboardAnimation);
      this.keyboardVisibilityChangeWithoutAnimation(callingId, panelRect, keyboardState, isActive);
    // } else {
    //   if (this.keyboardSession.IsNeedOpenSyncTransaction(this.keyboardSession.isActive, isActive)) {
    //     this.keyboardSession.openKeyboardSyncTransaction();
    //   }
    //   this.keyboardVisibilityChangeWithAnimation(callingId, panelRect, keyboardState, isActive);
    //   withAnimation = true;
    // }
    if (!this.keyboardSession.isFloatGravity()) {
      // notify listener of keyboard animation if need keep synchronous
      SCBKeyboardManager.getInstance().NotifyAnimationSyncCallbacks();
      this.keyboardSession.closeKeyboardSyncTransaction(isActive, withAnimation, false);
    }
  }

  private setZIndexToManager() {
    let zIndices = SCBSceneSessionManager.getInstance().getPanelZIndex();
    zIndices.bottom = SCBDefaultZIndex.BOTTOM;
    zIndices.scenePanel = SCBDefaultZIndex.SCENE_PANEL;
    zIndices.floatingScenePanel = SCBDefaultZIndex.FLOATING_SCENE_PANEL;
    zIndices.mutiScreenCollaboration = SCBDefaultZIndex.MUTISCREEN_COLLABORATION;
    zIndices.specificAboveScenePanel = SCBDefaultZIndex.SPECIFIC_ABOVE_SCENE_PANEL;
    zIndices.pipScenePanel = SCBDefaultZIndex.PIP_SCENE_PANEL;
    zIndices.specificAboveSystemUI = SCBDefaultZIndex.SPECIFIC_ABOVE_SYSTEMUI;
    zIndices.specificMeidaControlTemp = SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP;
    zIndices.specialScenePanel = SCBDefaultZIndex.SPECIAL_SCENE_PANEL;
    zIndices.voiceInteraction = SCBDefaultZIndex.SPECIFIC_VOICE_INTERACTION;
    zIndices.floatNavigation = SCBDefaultZIndex.SPECIFIC_FLOAT_NAVIGATION;
    zIndices.specificAboveKeyguard = SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD;
    zIndices.volume = SCBDefaultZIndex.SPECIFIC_SCENE_PANEL_VOLUME;
    zIndices.systemToast = SCBDefaultZIndex.SYSTEM_TOAST;
    zIndices.screenshot = SCBDefaultZIndex.SPECIFIC_SCREENSHOT;
    zIndices.screenControl = SCBDefaultZIndex.SCREEN_CONTROL;
    zIndices.top = SCBDefaultZIndex.TOP;
    zIndices.walletSwipeCard = SCBDefaultZIndex.WALLET_SWIPE_CARD;
    zIndices.dynamic = SCBDefaultZIndex.DYNAMIC;
    zIndices.magnification = SCBDefaultZIndex.MAGNIFICATION;
    zIndices.magnificationMenu = SCBDefaultZIndex.MAGNIFICATION_MENU;
    SCBSceneSessionManager.getInstance().setPanelLists();
  }

  private getScreenTranslateOptions() : TranslateOptions {
    let option: TranslateOptions = {
      x: 0,
      y: 0
    };
    option.x = this.physicalScreenProperty.getTranslateX() + 'px';
    option.y = this.physicalScreenProperty.getTranslateY() + 'px';
    log.showInfo('getScreenTranslateOptions: ' + JSON.stringify(option))
    return option;
  }

  private getScreenRotateOptions() : RotateOptions {
    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: 0,
      centerX: '50%',
      centerY: '50%'
    };
    option.angle = - this.physicalScreenProperty.displayRotation;
    log.showInfo('getScreenRotateOptions: ' + JSON.stringify(option))
    return option;
  }

  private isSysSceneRotatable(): boolean {
    return this.screenSession.isRotateScreenPolicy() ||
    SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this.screenSession);
  }

  private isScreenVerticalCallback = (): boolean => {
    log.showInfo('isScreenVerticalCallback: start');
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.scbScreenProperty.screenId);
    if (!screenSession) {
      log.showError('exitSceneWithRotationRecover screenSession is null');
      return false;
    }
    let rotation = screenSession.scbScreenProperty.rotation;
    if (this.scbScreenProperty.defaultScreenOrientation === 0) {
      return rotation === RotationConstants.ROTATION_0 ||
        rotation === RotationConstants.ROTATION_180;
    } else {
      return rotation === RotationConstants.ROTATION_90 ||
        rotation === RotationConstants.ROTATION_270;
    }
  };

  public updateScale(x: number, y: number, centerX?: string, centerY?: string): void {
    log.showInfo(`updateScale x: ${x}}, y: ${y}, centerX: ${centerX}, centerY: ${centerY}`);
    this.scaleX = x;
    this.scaleY = y;
    if (centerX) {
      this.scaleCenterX = centerX;
    }
    if (centerY) {
      this.scaleCenterY = centerY;
    }
  }

  public setRadius(radius: number): void {
    log.showInfo(`setRadius radius: ${radius}`);
    this.radius = radius;
  }

  public setEnableShowOneHandModeBackground(enableShow: boolean): void {
    log.showInfo(`setEnableShowOneHandModeBackground enableShow: ${enableShow}`);
    this.enableShowOneHandModeBackground = enableShow;
  }

  public setOneHandModeBoxBorderProperties(borderWidth: number, borderColor: string): void {
    log.showInfo(`setOneHandModeBoxBorderProperties borderWidth: ${borderWidth}, borderColor: ${borderColor}`);
    this.oneHandModeBoxBorderWidth = borderWidth;
    this.oneHandModeBoxBorderColor = borderColor;
  }

  public setEnableScreenSnapshot(enableShow: boolean): void {
    log.showInfo(`setEnableScreenSnapshot enableShow: ${enableShow}`);
    this.enableScreenSnapshot = enableShow;
  }

  public setScreenSnapshotOpacity(opacity: number): void {
    log.showInfo(`setScreenSnapshotOpacity opacity: ${opacity}`);
    this.screenSnapshotOpacity = opacity;
  }

  public setScreenSnapshotBlur(blur: number): void {
    log.showInfo(`setScreenSnapshotBlur blur: ${blur}`);
    this.screenSnapshotBlur = blur;
  }

  public setOneHandModeBoxBlur(blur: number): void {
    log.showInfo(`setOneHandModeBoxBlur blur: ${blur}`);
    this.oneHandModeBoxBlur = blur;
  }

  public syncOneHandModeScreenWidthAndHeightByDisplay(): void {
    let defaultDisplay: display.Display | null = null;
    try {
      defaultDisplay = display.getDefaultDisplaySync();
    } catch (err) {
      log.showError(`getDefaultDisplaySync failed, error: ${err}`);
    }
    if (defaultDisplay != null) {
      this.mScreenWidth = px2vp(defaultDisplay.width);
      this.mScreenHeight = px2vp(defaultDisplay.height);
    }
  }

  private registerNStatusDialog(): void {
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (err) {
      log.showError(TAG, `registerNStatusDialog failed, code is ${err?.code}, message is ${err?.message}`);
    }
    if (foldStatus == FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED) {
      log.showInfo(`registerNStatusDialog, openStatusDialog`);
      this.openStatusDialog(FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED);
    }
    try {
      display.on('foldStatusChange', this.onFoldStateChangeCallback);
    } catch (error) {
      log.showError('registerFoldStatusListener on error');
    }
  }

  remoteProxy: rpc.IRemoteObject = new rpc.RemoteObject('DeadCallBack')
  private onFoldStateChangeCallback = (newFoldStatus: display.FoldStatus) => {
    log.showInfo(`Listening enabled. FoldStatus: ${newFoldStatus}`);
    let TraceName: string = 'onFoldStateChangeCallback: ' + JSON.stringify(newFoldStatus);
    Trace.start(TraceName);
    if (newFoldStatus == FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED) {
      this.openStatusDialog(FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED);
    } else {
      this.closeStatusDialog();
    }
    Trace.end(TraceName);
  };

  private openStatusDialog(type: number = 0): void{
    if (this.isDialogstatusOpen) {
      log.showInfo(`The dialog box already exists`);
      return;
    }
    let want: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'com.ohos.sceneboard.systemdialog'
    }
    let that = this;
    let connectOption: common.ConnectOptions = {
      onConnect(elementName, remote) {
        that.sendMessage(type, remote);
      },
      onDisconnect(elementName) {
        log.showInfo(`DisConnect from System Dialog, elementName: ${elementName.bundleName}`)
      },
      onFailed(code) {
        log.showError(`Connect to System Dialog Failed, code: ${code}`)
      }
    }
    try {
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      const connectionId = context.connectServiceExtensionAbility(want, connectOption);
      log.showInfo(`start connecting. connectionId ${connectionId}`);
    } catch (err) {
      log.showError(`connect to systemDialog failed, code: ${err}`);
    }
  }

  private sendMessage(type: number, remote: rpc.IRemoteObject): void {
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (err) {
      log.showError(TAG, `sendMessage failed, code is ${err?.code}, message is ${err?.message}`);
    }
    if (foldStatus != FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED && type == FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED) {
      return;
    }
    this.remoteProxy = remote;
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    let parameter: Record<string, Object> = {
      "ability.want.params.uiExtensionType": 'sysDialog/common',
      "sysDialogZOrder": 2,
      "disableUpGesture": 1
    }
    data.writeInt(this.numberOfKeyValuePairs);
    data.writeString('bundleName');
    data.writeString("com.ohos.commondialog");
    data.writeString("abilityName");
    log.showInfo(`openStatusDialog type:${type}`);
    if (type == FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED) {
      data.writeString("FoldStatusAbility");
    } else {
      data.writeString("SecondaryReflexionAbility");
    }
    data.writeString("parameters");
    data.writeString(JSON.stringify(parameter));
    this.isDialogstatusOpen = true;
    let TraceName: string = 'sendMessageRequest: open';
    Trace.start(TraceName);
    remote.sendMessageRequest(this.openDialogFlag, data, reply, option).then((ret) => {
      let msg = reply.readInt();
      log.showInfo(`open dialog ret:${ret} msg:${msg}`);
    }).catch((error: BusinessError) => {
      log.showError('open dialog failed');
    }).finally(() => {
      // 释放MessageSequence创建的内存
      data.reclaim();
      reply.reclaim();
    });
    Trace.end(TraceName);
  }

  private closeStatusDialog(): void {
    if (!this.isDialogstatusOpen) {
      log.showInfo(`The dialog box not exists`);
      return;
    }
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    this.isDialogstatusOpen = false;
    let TraceName: string = 'sendMessageRequest: close';
    Trace.start(TraceName);
    this.remoteProxy.sendMessageRequest(this.closeDialogFlag, data, reply, option).then((ret) => {
      let msg = reply.readInt();
      log.showInfo(`close dialog ret:${ret}, msg:${msg}`);
    }).catch((error: BusinessError) => {
      log.showError(`close dialog failed, code: ${error}`);
    }).finally(() => {
      // 释放MessageSequence创建的内存
      data.reclaim();
      reply.reclaim();
    });
    Trace.end(TraceName);
  }

  onScreenPowerStatusChange(displayPowerEvent: number, eventStatus: number, reason: number) {
    log.showInfo(`onScreenPowerStatusChange displayPowerEvent: ${displayPowerEvent}` +
      `, eventStatus: ${eventStatus}, reason: ${reason}`);
    const powerEvent: SCBScreenPowerEvent = {eventType: displayPowerEvent,
      eventStatus: eventStatus, changeReason: reason};
    localEventManager.sendLocalEvent('SCBScreen_ScreenPowerEvent', powerEvent);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.initScreenProperty();
    this.scbSceneRegisterManager.registerSystemSceneBuilder();
    this.screenSession.registerPropertyChange((screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason,
      needNotify: boolean = true) => {
      this.onScreenPropertyChange(screenProperty, reason, needNotify);
    })
    this.screenSession.registerIsInEmergencyOrThermalSafe(() => {
      return this.isInEmergencyOrThermalSafeMode;
    });
    SCBKeyboardManager.getInstance().registerKeyboardActiveChangeCallback(
      (keyboardState: KeyboardState, sessionState: sceneSessionManager.SessionState, isActive: boolean) => {
        this.changeKeyboardState(keyboardState, sessionState, isActive);
      });

    // 监听消息打开手电筒提示页
    GlobalContext.getContext().eventHub.on(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT
      , (isShowFlashlightTips: boolean) => {
        log.showInfo(`show flashlight tips page event.openFlashlight: ${isShowFlashlightTips}`);
        this.isShowFlashlightTips = FlashlightTipsUtil.isOpenFlashlightTips(isShowFlashlightTips);
      });
    this.setZIndexToManager();
    this.keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    this.keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    FormClearUtils.clearInvalidForm(0);
    DesktopModeManager.getInstance().registerModeChangeCallback(TAG,
      (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
        log.showInfo(`Notify preDesktopMode: ${preDesktopMode} change to targetDesktopMode: ${targetDesktopMode}`);
        this.desktopModeNum = targetDesktopMode;
        if (targetDesktopMode === DesktopModeEnum.EMERGENCY_MODE ||
          targetDesktopMode === DesktopModeEnum.THERMAL_SAFE_MODE) {
          this.isInEmergencyOrThermalSafeMode = true;
          ViewManagerPolicy.hideView(ViewType.DESKTOP);
        } else {
          this.isInEmergencyOrThermalSafeMode = false;
          ViewManagerPolicy.showView(ViewType.DESKTOP);
        }
      }
    );
    this.debugCommands.register();
    this.mStage.onCreate();
    SCBTriFoldManager.getInstance().updateTriFoldStateIfNeeded();

    //screen信息缓存到单手模式管理器
    OneHandModeManager.getInstance().screen = this;
    //增加isrotatable字段
    this.screenSession.isRotatable = true;
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);
    GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT);
    this.debugCommands.unregister();
    this.mStage.onDestroy();
    this.scbSceneRegisterManager.unregisterSystemSceneBuilder();
  }

  @Builder flashlightTipsBuilder($$: SystemSceneBuilderParam) {
    FlashlightTips({persistentId: $$.persistentId, screenProp: $$.screenProp});
  }

  @Builder
  micReminderBuilder($$: SystemSceneBuilderParam) {
    SCBMicReminder({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder systemSceneBuilder(contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string,
    sceneZIndex: number,
    options: SystemSceneOptions,
    windowInputType?: number) {
    if (contextBuilder) {
      SCBSystemScene({
        contextBuilder: contextBuilder,
        systemSessionInfo: {
          systemType: systemType,
          sceneName: sceneName,
          sceneZIndex: sceneZIndex,
          isFocusable: options.focusable,
          isBlockingFocus: options.blockingFocus,
          isTouchable: options.touchable,
          privacyMode: options.privacyMode,
          hitTestMode: options.hitTestMode,
          isRotatable: options.rotatable,
          visibility: options.visibility,
          opacity: options.opacity,
          scbKeepKeyboardFlag: options.scbKeepKeyboardFlag,
          responseRegion: options.responseRegion,
          systemBarType: options.systemBarType,
          windowInputType: windowInputType,
          isLandscapeStartRotatable: options.landscapeStartRotatable,
          sceneType: options.sceneType,
          isFollowDeskTop: options.followDeskTop,
          alwaysNeedAnimateWhenRotation: options.alwaysNeedAnimateWhenRotation
        },
        screenProperty: this.scbScreenProperty
      })
    }
  }

  @Builder keyboardBuilder(name: string) {
    SCBKeyboardPanel({
      screenProperty: this.scbScreenProperty,
      keyboardState: this.keyboardState,
      keyboardSession: this.keyboardSession,
      keyboardPanelSession: this.keyboardPanelSession,
      panelRect: this.keyboardPanelSession?.currRect,
      keyboardRect: this.keyboardSession?.currRect,
      name: name
    })
  }

  @Builder SCBSystemComponentBuilder() {
    // screenMattesPanel
    if (FoldExpandAnimUtils.isSupportProduct) {
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBScreenMattesPanel'),
        sceneSessionManager.SessionType.TYPE_PANEL, 'SCBScreenMattesPanel',
        SCBDefaultZIndex.TOP,
        new SystemSceneOptions({
          focusable: false,
          touchable: false,
          hitTestMode: HitTestMode.None,
          rotatable: false,
          landscapeStartRotatable: false,
        }))
    }
    // Wallpaper
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBWallpaper'),
      sceneSessionManager.SessionType.TYPE_WALLPAPER, 'SCBWallpaper',
      SCBDefaultZIndex.WALLPAPER,
      new SystemSceneOptions(
        {
          focusable: false,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: this.isSysSceneRotatable(),
          landscapeStartRotatable: false,
          followDeskTop: true
        }))

    // Desktop
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBDesktop'),
      sceneSessionManager.SessionType.TYPE_DESKTOP, 'SCBDesktop',
      SCBDefaultZIndex.DESKTOP,
      new SystemSceneOptions(
        {
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: this.isSysSceneRotatable(),
          landscapeStartRotatable: false,
          followDeskTop: true
        }))

    if (this.isInEmergencyOrThermalSafeMode) {
      // Emergency mode
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBDesktopEmergency'),
        sceneSessionManager.SessionType.TYPE_DESKTOP, 'SCBDesktopEmergency',
        SCBDefaultZIndex.DESKTOP,
        new SystemSceneOptions(
          {
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: this.isSysSceneRotatable(),
            landscapeStartRotatable: false
          }))
    }

    // Scene panel
    SCBScenePanel({
      screenProperty: $scbScreenProperty,
      keyboardState: $keyboardState,
      keyboardSession: this.keyboardSession,
      keyboardPanelSession: this.keyboardPanelSession,
      name: 'BelowScenePanel',
      physicalScreenProperty: this.physicalScreenProperty
    })

    // shutdownView
    if(this.padSystemSceneBuilderMap && this.padSystemSceneBuilderMap.length !== 0) {
      this.systemSceneBuilder(this.padSystemSceneBuilderMap.get('SCBShutdownView'),
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBshutdownView',
        SCBDefaultZIndex.SHUTDOWN_VIEW,
        new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        })
      )
    }

    // MutiScreen Collaboration zorder
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.MUTISCREEN_COLLABORATION })

    // System Float window zorder ABOVE_SCENE_PANEL
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_SCENE_PANEL })

    // Scene Pip panel
    SCBPictureInPictureScenePanel({screenProperty: this.scbScreenProperty, zorder: SpecificPanelZOrder.PIP_PANEL})

    // Scene Floating ball
    SCBFloatingBallPanel({
      screenProperty: {
        width: this.scbScreenProperty.width,
        height: this.scbScreenProperty.height,
        rotation: this.scbScreenProperty.rotation,
        transX: this.scbScreenProperty.getTranslateX(),
        transY: this.scbScreenProperty.getTranslateY(),
        left: this.scbScreenProperty.left,
        top: this.scbScreenProperty.top
      }
    })

    // system app above systemui zorder
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_SYSTEMUI })

    // dynamic scene
    SCBDynamicSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.DYNAMIC })

    // gesture dock
    if (this.gestureDockParam.isGestureDockShow) {
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBGestureDock'),
        sceneSessionManager.SessionType.TYPE_FLOAT, 'SCBGestureDock',
        SCBDefaultZIndex.GESTURE_DOCK,
        new SystemSceneOptions({
          focusable: false,
          blockingFocus: true,
          touchable: true,
          rotatable: true
        }))
    }

    if (this.isCFWKDialogOpen) {
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('CFWKSysDialogDefault'),
        sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT, 'CFWKSysDialogDefault',
        SCBDefaultZIndex.CFWK_DIALOG_DEFAULT,
        new SystemSceneOptions({
          focusable: true,
          blockingFocus: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))
    }

    // systemDialogDefault
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBSysDialogDefault'),
      sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT, 'SCBSysDialogDefault',
      SCBDefaultZIndex.SYS_DIALOG_DEFAULT,
      new SystemSceneOptions({
        focusable: true,
        blockingFocus: true,
        touchable: true,
        hitTestMode: HitTestMode.Default,
        rotatable: true
      }))

    this.keyboardBuilder('BelowSpecificScene')

    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBBannerNotification'),
      sceneSessionManager.SessionType.TYPE_FLOAT, 'SCBBannerNotification',
      SCBDefaultZIndex.BANNER_LIVE,
      new SystemSceneOptions(
        {
          touchable: true,
          rotatable: true,
          alwaysNeedAnimateWhenRotation: true
        }));

    // screenlock
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBScreenLock'),
      sceneSessionManager.SessionType.TYPE_KEYGUARD, 'SCBScreenLock',
      SCBDefaultZIndex.SCREEN_LOCK,
      new SystemSceneOptions(
        {
          focusable: true,
          blockingFocus: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: this.isSysSceneRotatable(),
          landscapeStartRotatable: false,
          followDeskTop: true
        }))

    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBFormCenter'),
      sceneSessionManager.SessionType.TYPE_FORM_CENTER, 'SCBFormCenter',
      SCBDefaultZIndex.DESKTOP,
      new SystemSceneOptions(
        {
          focusable: true,
          touchable: false,
          rotatable: true
        }))

    // scene above keyguard
    SCBSpecialScenePanel({
      screenProperty: $scbScreenProperty,
      keyboardState: $keyboardState,
      keyboardSession: this.keyboardSession,
      keyboardPanelSession: this.keyboardPanelSession,
      name: 'AboveScenePanel',
      physicalScreenProperty: this.physicalScreenProperty
    })

    // gesture top bar
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBGestureTopBar'),
      sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'SCBGestureTopBar',
      SCBDefaultZIndex.GESTURE_TOP_BAR,
      new SystemSceneOptions(
        {
          touchable: true,
          rotatable: true
        }),
      SCBWindowInputType.TRANSMIT_ALL
    );

    // system app above screenlock zorder, below voice interaction
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.WALLET_SWIPE_CARD })

    // system app for voice interaction
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.VOICE_INTERACTION });

    // float navigation above SPECIFIC_VOICE_INTERACTION, below GESTURE_NAVIGATION
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.FLOAT_NAVIGATION });

    // gesture navigation
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBGestureNavBar'),
      sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'SCBGestureNavBar',
      SCBDefaultZIndex.GESTURE_NAVIGATION,
      new SystemSceneOptions(
        {
          touchable: true,
          rotatable: true
        }),
      SCBWindowInputType.MIX_BUTTOM_ANTI_AXIS_MOVE
    )

    // dropdown panel
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBDropdownPanel'),
      sceneSessionManager.SessionType.TYPE_PANEL, 'SCBDropdownPanel',
      SCBDefaultZIndex.DROP_DOWN,
      new SystemSceneOptions({
        focusable: true,
        blockingFocus: true,
        touchable: true,
        hitTestMode: HitTestMode.Default,
        rotatable: true,
        scbKeepKeyboardFlag: true
      }))

    // status bar
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBStatusBar'),
      sceneSessionManager.SessionType.TYPE_STATUS_BAR, 'SCBStatusBar',
      SCBDefaultZIndex.STATUS_BAR,
      new SystemSceneOptions(
        {
          touchable: true,
          rotatable: true,
          systemBarType: SystemBarType.STATUS_BAR
        }))

    // system app MediaControlTemp zorder
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.MEDIA_CONTROL_TEMP })

    if (this.isShowFlashlightTips) {
      // 手电筒提示页面
      this.systemSceneBuilder(this.flashlightTipsBuilder, sceneSessionManager.SessionType.TYPE_DESKTOP, 'FlashlightTips',
        SCBDefaultZIndex.FLASHLIGHT_TIPS_AND_EMERGENCY_MODE, new SystemSceneOptions(
          { focusable: true, touchable: true, hitTestMode: HitTestMode.Default }));
    }

    // system app above keybuard zorder
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_KEYGUARD })

    // systemDialogUpper
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBSysDialogUpper'),
      sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'SCBSysDialogUpper',
      SCBDefaultZIndex.SYS_DIALOG_UPPER,
      new SystemSceneOptions({
        focusable: true,
        blockingFocus: true,
        touchable: true,
        hitTestMode: HitTestMode.Default,
        rotatable: true }))

    // CFWKsystemDialogUpper
    if (this.isCFWKDialogOpen) {
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('CFWKSysDialogUpper'),
        sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'CFWKSysDialogUpper',
        SCBDefaultZIndex.SYS_DIALOG_UPPER,
        new SystemSceneOptions({
          focusable: true,
          blockingFocus: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))
    }

    this.keyboardBuilder('AboveSpecificScene')

    // system app volume overlay type zorder VOLUME
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.VOLUME })

    // shortcutKeyPanel
    if (uiType === SCBConstants.UITYPE_PAD) {
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBShortcutKeyPanel'),
        sceneSessionManager.SessionType.TYPE_PANEL, 'SCBShortcutKeyPanel',
        SCBDefaultZIndex.SHORTCUT_KEY_PANEL,
        new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // brightness
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBbrightnessPanel'),
        sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'SCBbrightnessPanel',
        SCBDefaultZIndex.VOLUME_PANEL,
        new SystemSceneOptions(
          {
            touchable: true,
            rotatable: true
          }))

      // MicReminder
      this.systemSceneBuilder(this.micReminderBuilder,
        sceneSessionManager.SessionType.TYPE_PANEL,
        'SCBMicReminder',
        SCBDefaultZIndex.SYSTEM_TOAST,
        new SystemSceneOptions({
          focusable: false,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))
    }

    // volume
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBVolumePanel'),
      sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'SCBVolumePanel',
      SCBDefaultZIndex.VOLUME_PANEL,
      new SystemSceneOptions(
        {
          touchable: true,
          rotatable: true
        }))

    // SCBSideEdgeScenePanel
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBSideScenePanel'),
      sceneSessionManager.SessionType.TYPE_SIDE_EDGE_BAR,
      'SCBSideScenePanel', SCBDefaultZIndex.SIDE_EDGE_MANAGER, new SystemSceneOptions(
        {
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

    // gesture back
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBGestureBack'),
      sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, 'SCBGestureBack',
      SCBDefaultZIndex.GESTURE_BACK,
      new SystemSceneOptions(
        {
          touchable: true,
          rotatable: true,
          responseRegion: [
            {
              x: 0,
              y: vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height'))),
              width: vp2px(gestureBackSettings.getBackResponseRegionWidth()),
              height: this.scbScreenProperty.height -
              vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')) +
              StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT)
            },
            {
              x: this.scbScreenProperty.width - vp2px(gestureBackSettings.getBackResponseRegionWidth()),
              y: vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height'))),
              width: vp2px(gestureBackSettings.getBackResponseRegionWidth()),
              height: this.scbScreenProperty.height -
              vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')) +
              StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT)
            }
          ]
        }), SCBWindowInputType.MIX_LEFT_RIGHT_ANTI_AXIS_MOVE)

    // side edge bar
    this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBSideEdgeBar'),
      sceneSessionManager.SessionType.TYPE_SIDE_EDGE_BAR, 'SCBSideEdgeBar',
      SCBDefaultZIndex.SIDE_EDGE_BAR,
      new SystemSceneOptions(
        {
          focusable: false,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

    // system app volume overlay type zorder SYSTEM_TOAST
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SYSTEM_TOAST })

    // system app for screenshot
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SCREENSHOT })

    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SCREEN_CONTROL })

    // magnification
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.MAGNIFICATION })

    // magnificationMenu
    SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.MAGNIFICATION_MENU })
  }

  build() {
    Screen(this.screenSession.session.screenId) {
      if (this.enableShowOneHandModeBackground) {
        this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('OneHandModeBackground'),
          sceneSessionManager.SessionType.TYPE_UNDEFINED,
          'OneHandModeBackground', 1,
          new SystemSceneOptions(
            {
              focusable: false,
              touchable: true,
              hitTestMode: HitTestMode.Default,
              visibility: true,
              rotatable: false
            }),
          SCBWindowInputType.SLID_TOUCH_WINDOW
        )
      }

      OneHandModeBox({ contextBuilder: this.SCBSystemComponentBuilder() })
        .id("OneHandModeBox")
        .clip(true)
        .scale({
          x: this.scaleX,
          y: this.scaleY,
          centerX: this.scaleCenterX,
          centerY: this.scaleCenterY
        })
        .zIndex(2)
        .blur(this.oneHandModeBoxBlur)
      // 仅在单手模式显示，不影响其他场景
      if (this.enableShowOneHandModeBackground) {
        Stack() {
          // corner top
          Canvas(this.contextCornerTop)
            .width(this.mScreenWidth)
            .height(this.mScreenHeight)
            .position({
              top: '0%',
            })
            .id("OneHandModeCanvasTop")
            // onReady会在canvas发生尺寸变化时再次调用，会有再次绘画的过程
            .onReady(() => {
              this.drawRoundCornerTop(0, 0, this.mScreenWidth, this.mScreenHeight, CommonConstants.getDeviceRadius(), Color.Black);
            })

          // corner bottom
          Canvas(this.contextCornerBottom)
            .width(this.mScreenWidth)
            .height(this.mScreenHeight)
            .position({
              bottom: '0%',
            })
            .id("OneHandModeCanvasBottom")
            .onReady(() => {
              this.drawRoundCornerBottom(0, 0, this.mScreenWidth, this.mScreenHeight, CommonConstants.getDeviceRadius(), Color.Black);
            })

          // border
          Stack() {
          }
          .width('100%')
          .height('100%')
          .id("OneHandModeBorder")
          .border({ width: this.oneHandModeBoxBorderWidth, radius: this.radius, color: this.oneHandModeBoxBorderColor })
        }
        .width('100%')
        .height('100%')
        .id("OneHandModeCornerStack")
        .zIndex(3)
        .scale({
          x: this.scaleX,
          y: this.scaleY,
          centerX: this.scaleCenterX,
          centerY: this.scaleCenterY
        })
      }
    }
    .id('SCBScreen')
    .position({ x: this.physicalScreenProperty.left + 'px', y: this.physicalScreenProperty.top + 'px' })
    .width(this.physicalScreenProperty.width + 'px')
    .height(this.physicalScreenProperty.height + 'px')
    // fold phone need rotate screen
    .translate(this.getScreenTranslateOptions())
    .rotate(this.getScreenRotateOptions())
    .border(SCBRotateUtils.getScreenBorderOptions())
    .id(`${TAG}-Temp`)
  }
}
