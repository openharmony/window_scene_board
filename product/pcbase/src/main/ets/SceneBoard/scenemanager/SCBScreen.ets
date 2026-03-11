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

import { SCBScenePanel } from './SCBScenePanel';
import { SCBAppCenterView } from '../systemscene/SCBAppCenterView';
import { ApsUtils } from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SpecificPanelZOrder,
  SCBScreenProperty,
  ResUtils,
  SCBSystemSceneSession,
  SystemBarType,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBScreenSession,
  SCBRotateChangeReason,
} from '@ohos/windowscene';
import { localEventManager, PluginSlot, PluginPosition, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { RotationConstants, WindowConstants } from '@ohos/commonconstants';
import { SystemSceneOptions, SCBSystemScene, SystemSceneBuilderParam } from '@ohos/windowscene/Index';
import { SCBConstants, PowerStatus } from '@ohos/commonconstants';
import { TraceUtil, DomainName, LogDomain, LogHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import { AbstractSCBSceneRegisterManager } from '@ohos/windowscene/Index';
import { SCBSceneRegisterManager } from './SCBSceneRegisterManager';
import { SCBDesktop } from '../systemscene/SCBDesktop';
import { SCBWallpaper } from '../systemscene/SCBWallpaper';
import { SCBStatusBarWrapper } from '../statusbar/SCBStatusBarWrapper';
import { SCBVolumePanel } from '@ohos/default_volumepanel/src/main/ets/pages/SCBVolumePanel';
import { SCBGestureBar } from '../statusbar/SCBGestureBar';
import { SCBSpecificScenePanel } from './SCBSpecificScenePanel';
import { SCBDynamicSpecificScenePanel } from './SCBDynamicSpecificScenePanel';
import { SCBBannerNotification } from '../notificationpanel/SCBBannerNotification';
import { SCBSmartDock } from '../systemscene/SCBSmartDock';
import { SCBSmartDockMask } from '../systemscene/SCBSmartDockMask';
import { SCBBrightnessPanel } from '../brightnesspanel/pages/SCBBrightnessPanel'
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBInputMethod } from './SCBInputMethod';
import { SCBSpecialScenePanel } from './SCBSpecialScenePanel'
import curves from '@ohos.curves';
import { SCBSysDialogDefault, SCBSysDialogUpper } from '@ohos/systemdialog/src/main/ets/pages/SCBSysDialog'
import lazy { CFWKSysDialogDefault, CFWKSysDialogUpper } from '@ohos/collaborationfwkdialog/src/main/ets/pages/CFWKSysDialog';
import { SCBCompanionView } from '../systemscene/SCBCompanionView';
import transactionManager from '@ohos.transactionManager';
import { SCBMicReminder } from '@ohos/multiinput';
import { ShutDownView } from '@ohos/shutdownview';
import { SCBMultiDesktopSwitcher } from '../virtualmachine/SCBMultiDesktopSwitcher';
import { SCBEnterpriseDisallowDialog } from '../systemscene/SCBEnterpriseDisallowDialog';
import { SCBMultiSpaceSwitchView } from '../systemscene/SCBMultiSpaceSwitchView';
import { SCBCtrlAltDelPanel } from '../ctrlaltdelpanel/pages/SCBCtrlAltDelPanel';
import { ForceExtensionComponent } from '../ctrlaltdelpanel/pages/ForceExtensionComponent';
import { SCBExtendScreenDock } from '../extmode/view/SCBExtendScreenDock';
import { SCBScreenMask } from '../screenlock/pages/SCBScreenMask';
import { FixedScrollerComponent } from '@ohos/pcsmartdock/src/main/ets/default/layout/FixedScrollerComponent';
import { SCBCentralLogoMask } from '../systemscene/SCBCentralLogoMask';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBSystemSceneLayout } from '../statusbar/SCBSceneLayout';
import { SCBCloneWallpaper } from '../systemscene/SCBCloneWallpaper';
import { SCBCentralMask } from '../systemscene/SCBCentralMask';
import screenSessionManager from '@ohos.screenSessionManager';
import { SCBScreenLockWifiPanel } from '../screenlock/statusbar/SCBScreenLockWifiPanel';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBDialogView } from '../userspanel/component/LogoutConfirmDialog/SCBDialogView';
import { SCBScreenModeChangeMask } from '../soundpanel/pages/SCBScreenModeChangeMask';
import { SCBPictureInPictureScenePanel } from './pip/SCBPictureInPictureScenePanel';
import { SCBScreenLockStatusBar } from '../screenlock/statusbar/SCBScreenLockStatusBar';
import { SCBInitStage, SCBStageInit } from './SCBStageInit';

const TAG = 'SCBScreen';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const GESTURE_BARR_EXSCENE_NAME = 'SCBGestureBar_EX';

export enum SCBDefaultZIndex {
  BOTTOM = -1,
  WALLPAPER = 1,
  DESKTOP = 2,
  CENTRAL_MASK = 3,
  SCENE_PANEL = 100, // app window
  SYSTEM_SCENE_PANEL = 101,
  FLOATING_SCENE_PANEL = 700, // floating app window
  SPECIFIC_ABOVE_SCENE_PANEL = 750,
  DYNAMIC = 751,
  GLOBAL_SEARCH = 797,
  C_SIDE_GUESTURE_BAR = 798,
  BANNER = 799,
  STATUS_BAR = 800,
  SMART_DOCK_MASK = 901,
  APP_CENTER = 900,
  RECENT = 901,
  SMART_DOCK = 902,
  COMPANION_VIEW = 903,
  FOLD_RESIDENT_DOCK = 904,
  FOLD_RECENT_DOCK = 905,
  POPUP_PANEL = 906,
  TYPE_FLOAT = 925,
  INPUT_METHOD_STATUS_BAR = 950,
  PIP_SCENE_PANEL = 990, // pip window
  PIP_SCENE_PANEL_OVERLAY = PIP_SCENE_PANEL + 1, // pip window overlay
  THEME_EDITOR = 999,
  SPECIFIC_ABOVE_SYSTEMUI = 1000, // system app window
  MIC_REMINDER = 1600,
  BRIGHTNESS_PANEL = 1700,
  SPECIFIC_MEDIA_CONTROL_TEMP = 1800, // temp for media control
  SHORTCUT_KEY_PANEL = 1890,
  CFWK_DIALOG_DEFAULT = 1899, // Collaboration system window
  VOLUME_PANEL = 1900,
  SYS_DIALOG_DEFAULT = 1901,
  SHUTDOWN_VIEW = 1902,
  INPUT_METHOD_BELOW_KEYGUARD = 1903,
  TYPE_SELECTION = 1980,
  FORCE_EXIT_COMPONENT = 1989,
  CTRL_ALT_DEL_PANEL = 1990,
  ENTERPRISE_DISALLOW_DIALOG = 1997,
  DESKTOP_SWITCHER = 1998,
  SCREEN_LOCK_WALL_PAPER = 1999,
  SCREEN_LOCK = 2000,
  DESKTOP_SWITCHER_SPACES = 2001,
  SCREEN_FORM_CENTER = 2002,
  CENTRAL_LOGO_MASK = 2003,
  SPECIAL_SCENE_PANEL = 2100, // app window above keyguard
  WALLET_SWIPE_CARD = 2150, // system app above screenlock, below voice interaction
  SPECIFIC_FLOAT_NAVIGATION = 2195, // float navigation above screenlock
  SCREENLOCK_STATUS_BAR = 2202,
  CFWK_DIALOG_UPPER = 2999, // Collaboration system window
  SPECIFIC_ABOVE_KEYGUARD = 3000, // system app window above keyguard
  SYS_DIALOG_UPPER = 3900,
  INPUT_METHOD = 3901,
  SPECIFIC_SCENE_PANEL_VOLUME = 4000, // system app volume overlay window
  GESTURE_NAVIGATION = 4103,
  SYSTEM_TOAST = 7000,
  SPACED_GESTURE = 7100,
  SPECIFIC_SCREENSHOT = 8000, // system window for SCREENSHOT
  SYSTEM_TOP_PANEL = 9000, //the panel for metaBalls
  TOP = 9999
}

export const ZORDER_TO_DEFAULTZINDEX : Map<SpecificPanelZOrder, SCBDefaultZIndex> =
  new Map<SpecificPanelZOrder, SCBDefaultZIndex>([
    [SpecificPanelZOrder.ABOVE_SCENE_PANEL, SCBDefaultZIndex.SPECIFIC_ABOVE_SCENE_PANEL],
    [SpecificPanelZOrder.TYPE_FLOAT, SCBDefaultZIndex.TYPE_FLOAT],
    [SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR, SCBDefaultZIndex.INPUT_METHOD_STATUS_BAR],
    [SpecificPanelZOrder.ABOVE_SYSTEMUI, SCBDefaultZIndex.SPECIFIC_ABOVE_SYSTEMUI],
    [SpecificPanelZOrder.MEDIA_CONTROL_TEMP, SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP],
    [SpecificPanelZOrder.ABOVE_KEYGUARD, SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD],
    [SpecificPanelZOrder.VOLUME, SCBDefaultZIndex.SPECIFIC_SCENE_PANEL_VOLUME],
    [SpecificPanelZOrder.SYSTEM_TOAST, SCBDefaultZIndex.SYSTEM_TOAST],
    [SpecificPanelZOrder.SCREENSHOT, SCBDefaultZIndex.SPECIFIC_SCREENSHOT],
    [SpecificPanelZOrder.WALLET_SWIPE_CARD, SCBDefaultZIndex.WALLET_SWIPE_CARD],
    [SpecificPanelZOrder.FLOAT_NAVIGATION, SCBDefaultZIndex.SPECIFIC_FLOAT_NAVIGATION],
    [SpecificPanelZOrder.TYPE_SELECTION, SCBDefaultZIndex.TYPE_SELECTION],
  ]);

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
  TRANSMIT_PC_GESTURE = 50,
}

export class SCBScreenPowerEvent {
  public eventType: SCBScreenPowerEventType = SCBScreenPowerEventType.WAKE_UP;
  public eventStatus: SCBScreenPowerEventStatus = SCBScreenPowerEventStatus.BEGIN;
  public changeReason: SCBScreenPowerStatusChangeReason = SCBScreenPowerStatusChangeReason.POWER_CHANGE_REASON_UNKNOWN;
}

@Component
export struct SCBScreen {
  @State screenSession:SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
  @State scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  @State physicalScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  @State userSwitch: boolean = false;
  private stageInitHandler: SCBStageInit = new SCBStageInit((nextStage: SCBInitStage) => {
    this.initStage = nextStage;
  });
  @State initStage: SCBInitStage = this.stageInitHandler.currentStage;
  @StorageProp('isCFWKDialogOpen') isCFWKDialogOpen: boolean = false;
  rotationAnimCnt: number = 0;
  private statusBarPluginNameArray: string[] = [];
  private statusBarPluginSessionList: SCBSystemSceneSession[] = new Array(
    PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_LEFT)!.length +
    PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_LEFT)!.length +
    PluginSlot.STATUS_BAR_PC_CAPSULE_DEFAULT_ORDER.length);
  private scbSceneRegisterManager: AbstractSCBSceneRegisterManager = SCBSceneRegisterManager.getInstance();
  // Used for shutdown animation
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;

  onPowerStatusChange(): void {
    if (this.powerStatus === PowerStatus.RUNNING) {
      log.showDebug('this.PowerStatus is ' + this.powerStatus + ', no animation return');
      this.userSwitch = false;
    } else {
      log.showDebug('this.PowerStatus is ' + this.powerStatus + ', do shut down animation.');
      this.userSwitch = true;
    }
    this.screenSession.setTouchEnabled(!this.userSwitch);
  }

  // screen property change
  onScreenPropertyChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason) {
    log.showInfo('Update scbScreenProperty: ' + JSON.stringify(screenProperty) + ' reason: ' + reason +
      ' currentRotation: ' + this.scbScreenProperty.rotation);
    if (screenProperty.width == 0 || screenProperty.height == 0) {
      log.showError('invalid width: ' + this.scbScreenProperty.width + 'invalid height: ' + this.scbScreenProperty.height);
      return;
    }
    AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(0);
    this.rotationAnimCnt++;
    if (reason === SCBPropertyChangeReason.ROTATION) {
      transactionManager.openSyncTransaction();
      animateTo({
        duration: 0,
        onFinish: () => {
          this.rotationAnimCnt--;
          if (this.rotationAnimCnt === 0) {
            AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(1);
          }
        }
      }, () => {
        this.scbScreenProperty.copy(screenProperty);
        this.physicalScreenProperty.copy(screenProperty);
        log.showInfo(' Update scbScreenProperty ' + JSON.stringify(this.scbScreenProperty));
        this.scbScreenProperty.screenId = this.screenSession.session.screenId;
        SCBScreenSessionManager.getInstance().updateScreenRotationProperty(this.scbScreenProperty);
        SCBScreenSessionManager.getInstance().updateSystemRotation(this.scbScreenProperty);
        SCBScreenSessionManager.getInstance().notifyScenePanelRotationChange(this.scbScreenProperty);
      });
      transactionManager.closeSyncTransaction();
    } else if (reason === SCBPropertyChangeReason.CHANGE_MODE) {
      let newScreenProperty = new SCBScreenProperty();
      newScreenProperty.copy(screenProperty);
      newScreenProperty.screenId = this.screenSession.session.screenId;
      this.physicalScreenProperty.copy(screenProperty);
      SCBScreenSessionManager.getInstance().notifyScenePanelActiveModeChange(newScreenProperty);
    } else {
      this.scbScreenProperty.copy(screenProperty);
      this.physicalScreenProperty.copy(screenProperty);
      this.scbScreenProperty.screenId = this.screenSession.session.screenId;
      SCBScreenSessionManager.getInstance().updateScreenPropertyToCallbacks(this.scbScreenProperty,
        reason);
    }
  }

  onScreenPowerStatusChange(displayPowerEvent: number, eventStatus: number, reason: number) {
    log.showInfo(`onScreenPowerStatusChange displayPowerEvent: ${displayPowerEvent}` +
      `, eventStatus: ${eventStatus}, reason: ${reason}`);
    const powerEvent: SCBScreenPowerEvent = {eventType: displayPowerEvent,
      eventStatus: eventStatus, changeReason: reason};
    localEventManager.sendLocalEvent('SCBScreen_ScreenPowerEvent', powerEvent);
    AppStorage.setOrCreate('screenPowerEvent', powerEvent);
  }

  initScreenProperty() {
    this.scbScreenProperty.screenId = this.screenSession.session.screenId;
    this.scbScreenProperty.copyBounds(this.screenSession.physicalBounds);
    this.physicalScreenProperty.copyBounds(this.screenSession.physicalBounds);
    this.screenSession.defaultScreenOrientation = 1;
    this.scbScreenProperty.defaultScreenOrientation = 1;
    this.physicalScreenProperty.defaultScreenOrientation = 1;
    this.statusBarPluginNameArray = PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_LEFT)!.concat(
      PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_RIGHT)!,
      PluginSlot.STATUS_BAR_PC_CAPSULE_DEFAULT_ORDER);
  }

  private updateBeforeRotate(screenProperty: SCBScreenProperty): void {
    if (this.scbScreenProperty.rotation === RotationConstants.ROTATION_0 &&
      screenProperty.rotation === RotationConstants.ROTATION_270) {
      this.scbScreenProperty.rotation = RotationConstants.ROTATION_360;
    } else if (this.scbScreenProperty.rotation === RotationConstants.ROTATION_270 &&
      screenProperty.rotation === RotationConstants.ROTATION_0) {
      this.scbScreenProperty.rotation = -RotationConstants.ROTATION_90;
    }
  }

  private getScreenProperty(): SCBScreenProperty {
    log.showInfo('scbScreenProperty: ' + this.scbScreenProperty.getLogString());
    return this.scbScreenProperty;
  }

  private getScreenDisplayRotation(): number {
    return this.getScreenProperty().rotation;
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

  private setZIndexToManager() {
    let zIndices = SCBSceneSessionManager.getInstance().getPanelZIndex();
    zIndices.bottom = SCBDefaultZIndex.BOTTOM;
    zIndices.scenePanel = SCBDefaultZIndex.SCENE_PANEL;
    zIndices.floatingScenePanel = SCBDefaultZIndex.FLOATING_SCENE_PANEL;
    zIndices.specificAboveScenePanel = SCBDefaultZIndex.SPECIFIC_ABOVE_SCENE_PANEL;
    zIndices.typeFloat = SCBDefaultZIndex.TYPE_FLOAT;
    zIndices.inputMethodStatusBar = SCBDefaultZIndex.INPUT_METHOD_STATUS_BAR;
    zIndices.specificAboveSystemUI = SCBDefaultZIndex.SPECIFIC_ABOVE_SYSTEMUI;
    zIndices.specificMeidaControlTemp = SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP;
    zIndices.specialScenePanel = SCBDefaultZIndex.SPECIAL_SCENE_PANEL;
    zIndices.specificAboveKeyguard = SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD;
    zIndices.volume = SCBDefaultZIndex.SPECIFIC_SCENE_PANEL_VOLUME;
    zIndices.systemToast = SCBDefaultZIndex.SYSTEM_TOAST;
    zIndices.screenshot = SCBDefaultZIndex.SPECIFIC_SCREENSHOT;
    zIndices.top = SCBDefaultZIndex.TOP;
    zIndices.walletSwipeCard = SCBDefaultZIndex.WALLET_SWIPE_CARD;
    zIndices.floatNavigation = SCBDefaultZIndex.SPECIFIC_FLOAT_NAVIGATION;
    zIndices.dynamic = SCBDefaultZIndex.DYNAMIC;
    zIndices.typeSelection = SCBDefaultZIndex.TYPE_SELECTION;
    SCBSceneSessionManager.getInstance().setPanelLists(this.scbScreenProperty.screenId);
  }


  @Builder
  wallpaperBuilder($$: SystemSceneBuilderParam) {
    SCBWallpaper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  cloneWallpaperBuilder($$: SystemSceneBuilderParam) {
    SCBCloneWallpaper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  desktopBuilder($$: SystemSceneBuilderParam) {
    SCBDesktop({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  bannerBuilder($$: SystemSceneBuilderParam) {
    SCBBannerNotification({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  appCenterBuilder($$: SystemSceneBuilderParam) {
    SCBAppCenterView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  shutdownViewBuilder($$: SystemSceneBuilderParam) {
    ShutDownView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  SCBDialogViewBuilder($$: SystemSceneBuilderParam) {
    SCBDialogView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  smartDockBuilder($$: SystemSceneBuilderParam) {
    SCBSmartDock({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  extSmartDockBuilder($$: SystemSceneBuilderParam) {
    SCBExtendScreenDock({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  smartDockMaskBuilder($$: SystemSceneBuilderParam) {
    SCBSmartDockMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  centralLogoMaskBuilder($$: SystemSceneBuilderParam) {
    SCBCentralLogoMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  centralMaskBuilder($$: SystemSceneBuilderParam) {
    SCBCentralMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  companionViewBuilder($$: SystemSceneBuilderParam) {
    SCBCompanionView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  brightnessPanelBuilder($$: SystemSceneBuilderParam) {
    SCBBrightnessPanel({ persistentId: $$.persistentId })
  }

  @Builder
  volumePanelBuilder($$: SystemSceneBuilderParam) {
    SCBVolumePanel({ persistentId: $$.persistentId })
  }

  @Builder
  micReminderBuilder($$: SystemSceneBuilderParam) {
    SCBMicReminder({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  taskManagerPanelBuilder($$: SystemSceneBuilderParam) {
    ForceExtensionComponent({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  ctrlAltDelPanelBuilder($$: SystemSceneBuilderParam) {
    SCBCtrlAltDelPanel({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  SCBScreenMaskBuilder($$: SystemSceneBuilderParam) {
    SCBScreenMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  SCBScreenModeChangeMaskBuilder($$: SystemSceneBuilderParam) {
    SCBScreenModeChangeMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  sysDialogDefaultBuilder($$: SystemSceneBuilderParam) {
    SCBSysDialogDefault({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  cfwkDialogDefaultBuilder($$: SystemSceneBuilderParam) {
    CFWKSysDialogDefault({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  sysDialogUpperBuilder($$: SystemSceneBuilderParam) {
    SCBSysDialogUpper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  cfwkDialogUpperBuilder($$: SystemSceneBuilderParam) {
    CFWKSysDialogUpper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  desktopSwitcherBuilder($$: SystemSceneBuilderParam) {
    SCBMultiDesktopSwitcher({persistentId: $$.persistentId, screenProp: $$.screenProp})
  }

  // SCBEnterpriseDisallow
  @Builder
  enterpriseDisallowDialogBuilder($$: SystemSceneBuilderParam) {
    SCBEnterpriseDisallowDialog({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  spaceDesktopSwitchViewBuilder($$: SystemSceneBuilderParam) {
    SCBMultiSpaceSwitchView({persistentId: $$.persistentId, screenProp: $$.screenProp})
  }

  @Builder
  gestureBarBuilder($$: SystemSceneBuilderParam) {
    SCBGestureBar({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  volumeAndBrightnessSystemSceneBuilder(
    contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string, sceneZIndex: number,
    options: SystemSceneOptions
  ) {
    SCBSystemScene({ contextBuilder: contextBuilder,
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
        scbKeepKeyboardFlag: options.scbKeepKeyboardFlag,
        systemBarType: options.systemBarType,
        sceneType: options.sceneType,
        borderRadius: ResUtils.getNumber($r('app.float.brightness_panel_radius')),
        backdropBlur: WindowConstants.BLUR_RADIUS,
        shadow: {
          radius: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_RADIUS,
          color: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_COLOR,
          offsetX: WindowConstants.SHADOW_OFFSET_X,
          offsetY: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_OFFSET_Y
        },
        enableActiveModeChange: options.enableActiveModeChange
      },
      screenProperty: this.scbScreenProperty,
    })
  }

  @Builder
  systemSceneBuilder(
    contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string, sceneZIndex: number,
    options: SystemSceneOptions,
    windowInputType?: number
  ) {
    SCBSystemScene({ contextBuilder: contextBuilder,
      systemSessionInfo: {
        systemType: systemType,
        sceneName: sceneName,
        sceneZIndex: sceneZIndex,
        isFocusable: sceneName === GESTURE_BARR_EXSCENE_NAME ? false : options.focusable,
        isBlockingFocus: options.blockingFocus,
        isTouchable: options.touchable,
        privacyMode: options.privacyMode,
        hitTestMode: options.hitTestMode,
        isRotatable: options.rotatable,
        visibility: options.visibility,
        scbKeepKeyboardFlag: options.scbKeepKeyboardFlag,
        systemBarType: options.systemBarType,
        windowInputType: windowInputType,
        sceneType: options.sceneType,
        enableActiveModeChange: options.enableActiveModeChange
      },
      screenProperty: this.scbScreenProperty,
    })
  }

  @Builder
  popupBuilder($$: SystemSceneBuilderParam) {
    FixedScrollerComponent({ persistentId: $$.persistentId, screenProp: $$.screenProp})
  }

  @Builder
  screenLockStatusBarBuilder($$: SystemSceneBuilderParam) {
    SCBScreenLockStatusBar({
      persistentId: $$.persistentId,
      screenProp: $$.screenProp,
    })
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.initScreenProperty();
    this.scbSceneRegisterManager.registerSystemSceneBuilder();
    this.screenSession.registerPropertyChange((screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason,
      needNotify: boolean = true) => {
      this.onScreenPropertyChange(screenProperty, reason);
    })
    this.screenSession.registerScreenPowerStatusChange((displayPowerEvent: number,
      eventStatus: number,
      reason: number) => {
      this.onScreenPowerStatusChange(displayPowerEvent, eventStatus, reason);
    })
    SCBSceneSessionManager.getInstance().registerGetPluginSessionListCallback(() => {
      return this.statusBarPluginSessionList;
    });

    this.setZIndexToManager();
    this.stageInitHandler.start('SCBScreen aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo(`${this.screenSession.session.screenId} aboutToDisappear`);
    this.scbSceneRegisterManager.unregisterSystemSceneBuilder();
  }

  build() {
    Screen(this.screenSession.session.screenId) {
      // Wallpaper
      this.systemSceneBuilder(this.wallpaperBuilder, sceneSessionManager.SessionType.TYPE_WALLPAPER, 'SCBWallpaper',
        SCBDefaultZIndex.WALLPAPER, new SystemSceneOptions(
          {
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))

      // Desktop
      this.systemSceneBuilder(this.desktopBuilder, sceneSessionManager.SessionType.TYPE_DESKTOP, 'SCBDesktop',
        SCBDefaultZIndex.DESKTOP, new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // Scene
      SCBScenePanel({ screenProperty: $scbScreenProperty })

      // System Float window zorder ABOVE_SCENE_PANEL
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_SCENE_PANEL })

      // dynamic scene
      SCBDynamicSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.DYNAMIC })

      if (SCBStageInit.STAGE1(this.initStage)) {
        this.systemSceneBuilder(this.bannerBuilder, sceneSessionManager.SessionType.TYPE_FLOAT, 'SCBBannerNotification',
          SCBDefaultZIndex.BANNER, new SystemSceneOptions({
            touchable: true,
            rotatable: true,
            enableActiveModeChange: false
          }))
      }

      // status bar
      if (SCBStageInit.STAGE1(this.initStage)) {
        SCBStatusBarWrapper({ screenProp: this.scbScreenProperty })
      }

      // app center
      if (SCBStageInit.STAGE2(this.initStage)) {
        this.systemSceneBuilder(this.appCenterBuilder,
          sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
          'SCBAppCenterView',
          SCBDefaultZIndex.APP_CENTER,
          new SystemSceneOptions({
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))
      }

      this.systemSceneBuilder(this.smartDockMaskBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBSmartDockMask',
        SCBDefaultZIndex.SMART_DOCK_MASK,
        new SystemSceneOptions({
          touchable: true,
          hitTestMode: HitTestMode.Transparent,
          enableActiveModeChange: false
        }))

      this.systemSceneBuilder(this.smartDockBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBSmartDock',
        SCBDefaultZIndex.SMART_DOCK,
        new SystemSceneOptions({
          touchable: true,
          hitTestMode: HitTestMode.Default,
          enableActiveModeChange: false
        }))

      this.systemSceneBuilder(this.companionViewBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBCompanionView',
        SCBDefaultZIndex.COMPANION_VIEW,
        new SystemSceneOptions({ touchable: true, visibility: true }))

      this.volumeAndBrightnessSystemSceneBuilder(this.popupBuilder,
        sceneSessionManager.SessionType.TYPE_PANEL,
        'SCBPopupPanel',
        SCBDefaultZIndex.POPUP_PANEL,
        new SystemSceneOptions({
          touchable: true,
          rotatable: false
        }))

      // TYPE_FLOAT
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.TYPE_FLOAT })

      // system app input method status bar zorder
      SCBSpecificScenePanel({
        screenProperty: $scbScreenProperty,
        zorder: SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR
      })

      // Scene Pip panel
      SCBPictureInPictureScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.PIP_PANEL })

      // system app specific above systemui zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_SYSTEMUI })

      // MicReminder
      if (SCBStageInit.STAGE2(this.initStage)) {
        this.systemSceneBuilder(this.micReminderBuilder,
          sceneSessionManager.SessionType.TYPE_PANEL,
          'SCBMicReminder',
          SCBDefaultZIndex.MIC_REMINDER,
          new SystemSceneOptions({
            focusable: false,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))
      }

      if (SCBStageInit.STAGE2(this.initStage)) {
        this.volumeAndBrightnessSystemSceneBuilder(this.brightnessPanelBuilder,
          sceneSessionManager.SessionType.TYPE_PANEL,
          'SCBBrightnessPanel',
          SCBDefaultZIndex.BRIGHTNESS_PANEL,
          new SystemSceneOptions({ touchable: true }))
      }

      // system app MediaControlTemp zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.MEDIA_CONTROL_TEMP })

      if (SCBStageInit.STAGE2(this.initStage)) {
        this.volumeAndBrightnessSystemSceneBuilder(this.volumePanelBuilder,
          sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY,
          'SCBVolumePanel',
          SCBDefaultZIndex.VOLUME_PANEL,
          new SystemSceneOptions({ touchable: true }))
      }

      // systemDialogDefault
      this.systemSceneBuilder(this.sysDialogDefaultBuilder,
        sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT,
        'SCBSysDialogDefault',
        SCBDefaultZIndex.SYS_DIALOG_DEFAULT,
        new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      if (SCBStageInit.STAGE2(this.initStage) && this.isCFWKDialogOpen) {
        this.systemSceneBuilder(this.cfwkDialogDefaultBuilder,
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

      // shutdownView
      if (SCBStageInit.STAGE2(this.initStage)) {
        this.systemSceneBuilder(
          this.shutdownViewBuilder,
          sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
          'SCBshutdownView',
          SCBDefaultZIndex.SHUTDOWN_VIEW,
          new SystemSceneOptions({
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))
      }

      this.systemSceneBuilder(
        this.SCBDialogViewBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBDialogView',
        SCBDefaultZIndex.SHUTDOWN_VIEW,
        new SystemSceneOptions({ focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true })
      )

      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.TYPE_SELECTION })

      // ForceExtensionComponent
      if (SCBStageInit.STAGE2(this.initStage)) {
        this.systemSceneBuilder(this.taskManagerPanelBuilder,
          sceneSessionManager.SessionType.TYPE_PANEL,
          'ForceExtensionComponent',
          SCBDefaultZIndex.FORCE_EXIT_COMPONENT,
          new SystemSceneOptions({
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))
      }

      // ctrlAltDelPanel
      if (SCBStageInit.STAGE2(this.initStage)) {
        this.systemSceneBuilder(this.ctrlAltDelPanelBuilder,
          sceneSessionManager.SessionType.TYPE_PANEL,
          'SCBCtrlAltDelPanel',
          SCBDefaultZIndex.CTRL_ALT_DEL_PANEL,
          new SystemSceneOptions({
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))
      }

      // enterpriseDisallowed
      this.systemSceneBuilder(this.enterpriseDisallowDialogBuilder,
        sceneSessionManager.SessionType.TYPE_FLOAT,
        'SCBEnterpriseDisallowDialog',
        SCBDefaultZIndex.ENTERPRISE_DISALLOW_DIALOG,
        new SystemSceneOptions({ focusable: true, touchable: true}));

      // multiDesktop
      this.systemSceneBuilder(this.desktopSwitcherBuilder,
        sceneSessionManager.SessionType.TYPE_UNDEFINED,
        'SCBDesktopSwitcher',
        SCBDefaultZIndex.DESKTOP_SWITCHER,
        new SystemSceneOptions({ focusable: false, touchable: false, rotatable: true }));

      if (SCBStageInit.STAGE2(this.initStage)) {
        this.systemSceneBuilder(this.cloneWallpaperBuilder, sceneSessionManager.SessionType.TYPE_WALLPAPER,
          'SCBCloneWallpaper',
          SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER, new SystemSceneOptions(
            {
              focusable: false,
              touchable: false,
              hitTestMode: HitTestMode.None,
              rotatable: true
            }))
      }

      // screenlock
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBScreenLock'),
        sceneSessionManager.SessionType.TYPE_KEYGUARD,
        'SCBScreenLock',
        SCBDefaultZIndex.SCREEN_LOCK,
        new SystemSceneOptions({
          focusable: true,
          blockingFocus: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // screenlock wifi panel
      SCBScreenLockWifiPanel({ screenProp: $scbScreenProperty })

      // multiDesktop
      this.systemSceneBuilder(this.spaceDesktopSwitchViewBuilder,
        sceneSessionManager.SessionType.TYPE_UNDEFINED,
        'SCBSpacesDesktopSwitcher',
        SCBDefaultZIndex.DESKTOP_SWITCHER_SPACES,
        new SystemSceneOptions({ focusable: false, touchable: false, rotatable: true }));

      // form center
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBFormCenter'),
        sceneSessionManager.SessionType.TYPE_FORM_CENTER, 'SCBFormCenter',
        SCBDefaultZIndex.SCREEN_FORM_CENTER,
        new SystemSceneOptions(
          {
            touchable: false,
            rotatable: true
          }))

      SCBSpecialScenePanel({ screenProperty: $scbScreenProperty });

      // system app above screenlock zorder, below voice interaction
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.WALLET_SWIPE_CARD })

      // float navigation above screenlock zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.FLOAT_NAVIGATION });

      // system app above keybuard zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_KEYGUARD })

      // systemDialogUpper
      this.systemSceneBuilder(this.sysDialogUpperBuilder,
        sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT,
        'SCBSysDialogUpper',
        SCBDefaultZIndex.SYS_DIALOG_UPPER,
        new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // CFWKsystemDialogUpper
      if (SCBStageInit.STAGE2(this.initStage) && this.isCFWKDialogOpen) {
        this.systemSceneBuilder(this.cfwkDialogUpperBuilder,
          sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT, 'CFWKSysDialogUpper',
          SCBDefaultZIndex.CFWK_DIALOG_UPPER,
          new SystemSceneOptions({
            focusable: true,
            blockingFocus: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))
      }

      //input method
      SCBInputMethod({ screenProperty: $scbScreenProperty });

      // system app volume overlay type zorder VOLUME
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.VOLUME })

      // system barrier free overlay type zorder SYSTEM_TOAST
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SYSTEM_TOAST })

      // system app for screenshot
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SCREENSHOT })

      // 拓展屏模式切换蒙层
      this.systemSceneBuilder(this.SCBScreenModeChangeMaskBuilder,
        sceneSessionManager.SessionType.TYPE_KEYGUARD,
        'SCBScreenModeChangeMask',
        SCBDefaultZIndex.TOP,
        new SystemSceneOptions({
          focusable: false,
          blockingFocus: false,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: false
        }))
    }
    .id('SCBScreen')
    .position({ x: this.getScreenProperty().left + 'px', y: this.getScreenProperty().top + 'px' })
    .width(this.getScreenProperty().width + 'px')
    .height(this.getScreenProperty().height + 'px')
    .translate(this.getScreenTranslateOptions())
    .rotate({
      x: 0,
      y: 0,
      z: 1,
      angle: -this.getScreenDisplayRotation(),
      centerX: '50%',
      centerY: '50%'
    })
    .enabled(!this.userSwitch)
  }
}
