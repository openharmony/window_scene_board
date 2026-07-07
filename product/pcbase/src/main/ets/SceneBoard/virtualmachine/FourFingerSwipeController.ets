/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { display, promptAction, screen } from '@kit.ArkUI';
import { systemDateTime, systemParameterEnhance } from '@kit.BasicServicesKit';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { BusinessError } from '@ohos.base';
import Curves from '@ohos.curves';
import image from '@ohos.multimedia.image';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import pointer from '@ohos.multimodalInput.pointer';
import { SourceType, Touch, TouchEvent } from '@ohos.multimodalInput.touchEvent';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenshot from '@ohos.screenshot';
import { AnimateToScheduleUtils, LogDomain, LogHelper, Trace, PixelMapUtil } from '@ohos/basicutils';
import { PowerStatus } from '@ohos/commonconstants';
import {
  settingsDataManager,
  ApsUtils,
  HiDfxEventUtil,
  HiSysEventUtil,
  localEventManager,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import { EventConstants } from '@ohos/launchercommon';
import { multiInputManager, MultiInputViewModel } from '@ohos/multiinput';
import {
  ScreenLockStateListener,
  screenLockStateManager,
  ScreenLockTransitionState,
  SwitchEventData
} from '@ohos/screenlockcommon';
import {
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBSpecificSession,
  SCBSystemSceneSession,
  sSCBOobeManager,
  StartAbilityUtil,
  SessionChangeInfo,
  SessionDisplayChangeReason,
} from '@ohos/windowscene';
import { AccountHelper } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { DesktopSwitchController } from './DesktopSwitchController';
import { SwipeGestureManager, SwipeGestureDirection } from '@ohos/pcmode';
import { FourFingerSwipeConstants } from './FourFingerSwipeConstants';
import { FourFingerSwipeEvent } from './FourFingerSwipeEvent';
// import virtualization from '@ohos.virtService.vmManagerInner';
import screenSessionManager from '@ohos.screenSessionManager';
// import apsManager from '@ohos.graphic.apsManager';
import { common } from '@kit.AbilityKit';
import { MultiSpaceSwitchOneGoCtrl, SwitchEnterpriseMultiSpaceType } from '../../common/EnterpriseMultiSpaceController';
import ctrlAltDelPanelModel from '../ctrlaltdelpanel/model/CtrlAltDelPanelModel';
import { bundleManager } from '@kit.AbilityKit';

const TAG = '[DesktopWorld]FourFingerSwipeController';
const KEYCODE_CTRL_LEFT: number = 2072;
const KEYCODE_CTRL_RIGHT: number = 2073;
const KEYCODE_WIN: number = 2076;
const KEYCODE_DPAD_LEFT: number = 2014;
const KEYCODE_DPAD_RIGHT: number = 2015;
const KEYCODE_E: number = 2021;
const KEYCODE_SHIFT_LEFT: number = 2047;
const DEBOUNCE_THRESHOLD: number = 5;
const DELAY_TIME: number = 650;
const SCALE_MAX: number = 1;
const SCALE_MIDDLE: number = 0.9;
const SCALE_INIT: number = 0.8;
const SCALE_MIN: number = 0.7;
const ROTATE_ANGLE_MAX: number = 25;
const ROTATE_ANGLE_MIN: number = 0;
const OPACITY_MAX: number = 1;
const OPACITY_MIN: number = 0;
const DISTANCE_MIN: number = 1000;
const PLACE_START: number = 0;
const RADIUS_MIN: number = 0;
const RADIUS_MAX: number = 15;
const SENSOR_FLAT: number = -1;
const VM_RUNNING: number = 6;
const MAXIMUM_SCREEN_ID: number = 1000;
const MAIN_SCREEN_ID: number = 0;
const TOUCH_BEGIN: number = 1;
const TOUCH_UPDATE: number = 2;
const TOUCH_END: number = 3;
const TOUCH_CANCEL: number = 3;
const HOPPER_SCREEN_WIDTH: number = 1.3;
const FOURTH_FINGER: number = 4;
const NOTIFY_DELAY: number = 100;
const RECOVER_DELAY: number = 200;
const REPORTING_INTERVAL: number = 10;
const FOUR_FINGER_SWIPE_LEFT: string = 'FOUR_FINGER_SWIPE_LEFT';
const FOUR_FINGER_SWIPE_RIGHT: string = 'FOUR_FINGER_SWIPE_RIGHT';
const FOUR_FINGER_SCREEN_TOUCH_SWIPE_LEFT: string = 'FOUR_FINGER_SCREEN_TOUCH_SWIPE_LEFT';
const FOUR_FINGER_SCREEN_TOUCH_SWIPE_RIGHT: string = 'FOUR_FINGER_SCREEN_TOUCH_SWIPE_RIGHT';
const SYSTEM_WINDOW_SHOW: string = 'SYSTEM_WINDOW_SHOW';
const SCREEN_NUMBER_ONE = 1;
const CTRL_LOGO_LEFT: string = 'CTRL_LOGO_LEFT';
const CTRL_LOGO_RIGHT: string = 'CTRL_LOGO_RIGHT';
const VM_SNAPSHOT_PIXEL_MAP_NAME: string = 'vmSnapshot_Pixel_Map';
const HARMONY_SNAPSHOT_PIXEL_MAP_NAME: string = 'hmSnapshot_Pixel_Map';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const BLUR_MIN: number = 0;
const BLUR_MAX: number = 100;
const FULL_SCREEN_WIDTH: number = 3296;
const FULL_SCREEN_HEIGHT: number = 2472;
const FOLD_SCREEN_WIDTH: number = 2472;
const FOLD_SCREEN_HEIGHT: number = 1608;
const EXFUSION_DISPLAY_BUNDLE_NAME: string = 'com.ohos.exfusiondisplay';
const EXFUSION_DISPLAY_APP_IDENTIFIER: string = '6917573010003628014';
const sessionTypes: number[] = [
  sceneSessionManager.SessionType.TYPE_WALLPAPER,
  sceneSessionManager.SessionType.TYPE_KEYGUARD,
  sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT,
  sceneSessionManager.SessionType.TYPE_DESKTOP,
  sceneSessionManager.SessionType.TYPE_PANEL
];
const VIEW_TYPE: ViewType[] = [
  ViewType.SHORTCUT_KEY_PANEL,
  ViewType.APP_CENTER,
  ViewType.NOTIFICATION_CENTER,
  ViewType.CONTROL_CENTER
];
const FINGER_NUMBER: number[] = [5, 6, 7, 8, 9, 10];
const reportFourFingerSwipeMap: Map<string, string> = new Map([
  [`${SwipeGestureDirection.LEFT}:true`, FOUR_FINGER_SCREEN_TOUCH_SWIPE_LEFT],
  [`${SwipeGestureDirection.LEFT}:false`, FOUR_FINGER_SWIPE_LEFT],
  [`${SwipeGestureDirection.RIGHT}:true`, FOUR_FINGER_SCREEN_TOUCH_SWIPE_RIGHT],
  [`${SwipeGestureDirection.RIGHT}:false`, FOUR_FINGER_SWIPE_RIGHT]
]);

export enum DevicesScreenWitch {
  HOPPER_FULL = 1785,
  HOPPER_FOLD = 1339
}

export enum SnapshotFoldState {
  NONE = 0,
  FOLD = 1,
  EXPAND = 2
}

export enum ToggleMotionType {
  NONE = 0,
  FOLLOW_HAND = 1,
  QUICK_SWIPE = 2,
  ONE_TIME = 3
}

export enum CallKeyboardType {
  // 输入法
  IME = 1,
  // 八指
  GESTURE = 2,
  // 状态栏
  STATUS_BAR = 3,
  // 其他
  OTHER = 4
}

// 输入法获焦方式
export enum ImeFocusType {
  NONE = 0,
  // 鼠标
  MOUSE = 1,
  // 触屏
  TOUCH = 2,
  // 其他
  OTHER = 3
}

const enum OrientationAngle {
  PORTRAIT = 0,
  LANDSCAPE = 90,
  PORTRAIT_INVERTED = 180,
  LANDSCAPE_INVERTED = 270,
}

export const enum VmState {
  NONE = 'NONE',
  NOT_VM = 'NOT_VM',
  VM_DEFAULT = 'VM_DEFAULT',
  VM_HPR_FULL_SCREEN = 'VM_HPR_FULL_SCREEN',
  VM_HPR_FOLDED_PHYSICAL_KEYBOARD = 'VM_HPR_FOLDED_PHYSICAL_KEYBOARD',
  VM_HPR_FOLDED_VIRT_KEYBOARD = 'VM_HPR_FOLDED_VIRT_KEYBOARD',
}

export class FourFingerSwipeController {
  public isLock: boolean = false;
  private locked: boolean = false;
  private direction: SwipeGestureDirection = SwipeGestureDirection.NONE;
  private commonEvent: boolean = false;
  private canSwipeUpdate: boolean = true;
  private preSpeed: number = 0;
  private curSpeed: number = 0;
  private acc: number = 0;
  private memoryRelease: boolean = false;
  private nonFourEvent: boolean = false;
  private startEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private preEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private curEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private stopEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private screenWidth: number = px2vp(SCBScreenSessionManager.getInstance()
    .getMainScreenSession()?.scbScreenProperty.width);
  private screenHeight: number = px2vp(SCBScreenSessionManager.getInstance()
    .getMainScreenSession()?.scbScreenProperty.height);
  private swipeCallbacks: Array<FourFingerMotionCallback | null> = [];
  private motionScreenId: number = 0;
  private swipeCallback: FourFingerMotionCallback | null = null;
  private swipeStateCallback: FourFingerMotionStateCallback | null = null;
  private vmDesktop: boolean = false;
  private screenRotation: number = 0;
  private trigger: boolean = true;
  private disableSnapshot: boolean = false;
  private startFourFingerTouch: boolean = false;
  private originalPosition: Position | null = null;
  public isQXSDevice: boolean = this.isSupportWindowPcModeSwitch();
  private harmonySnapshotScale: number = 1;
  private vmSnapshotScale: number = 0.9;
  private dropSnapshot: boolean = false;
  private canInterrupt: boolean = true;
  private isSwipe: boolean = false;
  private isShow: boolean = false;
  private ended: boolean = false;
  private gettingSnapshot: boolean = false;
  private static instance: FourFingerSwipeController;
  private physicalKeyboard: boolean = false;
  private lastFolded: boolean = false;
  private lastUseVmTime: number = 0;
  private revokeAnimate: boolean = false;
  private isVmSnapshotFoldState: SnapshotFoldState = SnapshotFoldState.NONE;
  private isHarmonySnapshotFoldState: SnapshotFoldState = SnapshotFoldState.NONE;
  private windowWidth: number = 0;
  private windowHeight: number = 0;
  private apsSessionId: string = '';
  private swipeBeginTimeStamp: number = 0;
  private quickMotionFlag: boolean = false;
  private recentVmState: VmState = VmState.NONE;
  private isCurrentUserActive: boolean = false;

  private isSupportWindowPcModeSwitch(): boolean {
    log.showInfo('isSupportWindowPcModeSwitch');
    try {
      return systemParameterEnhance.getSync('const.window.support_window_pcmode_switch', 'false') === 'true';
    } catch (error) {
      log.showError(`Get switch supportWindowPcModeSwitch failed, code: ${error?.code}, msg: ${error?.message}`);
      return false;
    }
  }

  public registerTabletSwitchStateChange(): void {
    try {
      log.showInfo('virtualization.on(tabletSwitchStateChange)');
      // virtualization.on('tabletSwitchStateChange', this.tabletSwitchStateChangeCallback);
    } catch (error) {
      log.showError(`virtualization.on('tabletSwitchStateChange' error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public unregisterTabletSwitchStateChange(): void {
    try {
      log.showInfo('virtualization.off(tabletSwitchStateChange)');
      // virtualization.off('tabletSwitchStateChange', this.tabletSwitchStateChangeCallback);
    } catch (error) {
      log.showError(`virtualization.off('tabletSwitchStateChange' error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  private tabletSwitchStateChangeCallback = (state: number): void => {
    log.showInfo(`tabletSwitchStateChangeState: ${state}`);
  }

  private queryTabletSwitchStatus(): boolean {
    try {
      let time = this.getTime();
      Trace.start('[DesktopWorld]queryTabletSwitchStatus');
      /*let switchStatus = virtualization.queryTabletSwitchStatus();
      Trace.end('[DesktopWorld]queryTabletSwitchStatus');
      log.showInfo(`queryTabletSwitchStatus(): ${switchStatus}, Time-consuming: ${this.getTime() - time}`);
      if (switchStatus !== virtualization.TabletSwitchState.STATE_ON) {
        return true;
      }*/
    } catch (error) {
      log.showError(`virtualization.queryTabletSwitchStatus() error, code: ${error?.code}, msg: ${error?.message}`);
    }
    return false;
  }

  private canSwitch(): boolean {
    Trace.start('[DesktopWorld]canSwitch');
    if (!this.checkHopperSwitch()) {
      return false;
    }
    if (!this.checkCommonSwitch()) {
      return false;
    }
    Trace.end('[DesktopWorld]canSwitch');
    return true;
  }

  private switchToVM(): boolean {
    if (this.getVmDesktop()) {
      log.showWarn(`getVmDesktop is ${this.getVmDesktop()}`);
      return false;
    }
    if (!this.canInterrupt) {
      log.showWarn(`can interrupt ${this.canInterrupt}`);
      return false;
    }
    return true;
  }

  private switchToHarmony(): boolean {
    if (!this.getVmDesktop()) {
      log.showInfo(`getVmDesktop is ${this.getVmDesktop()}`);
      return false;
    }
    if (!this.canInterrupt) {
      log.showInfo(`can interrupt ${this.canInterrupt}`);
      return false;
    }
    return true;
  }

  private checkHopperSwitch(): boolean {
    log.showInfo('not Hopper Devices');
    return true;
  }

  private checkQXSSwitch(): boolean {
    if (!this.isQXSDevice) {
      log.showInfo('not QXS Devices');
      return true;
    }
    if (this.queryTabletSwitchStatus()) {
      log.showWarn('QXS Stent closed state, not support');
      return false;
    }
    return true;
  }

  private checkCommonSwitch(): boolean {
    if (this.isLock) {
      log.showInfo('The current screen is not unlocked');
      return false;
    }
    if (sSCBOobeManager.isOobeActivated()) {
      log.showWarn('oobe stage no four finger swipe');
      return false;
    }
    if (AppStorage.get('powerStatus') !== PowerStatus.RUNNING) {
      log.showWarn('PowerStatus is running');
      return false;
    }
    if (!this.checkMemorySwitch()) {
      log.showInfo('virtualization.SwitchType.SWITCH_NO');
      return false;
    }
    return true;
  }

  private checkUpdateSwitch(): boolean {
    if (!this.canSwipeUpdate) {
      log.showInfo('!this.canSwipeUpdate');
      return false;
    }
    Trace.start('[DesktopWorld]checkUpdateSwitch');
    if ((this.direction === SwipeGestureDirection.LEFT || this.direction === SwipeGestureDirection.RIGHT) &&
    this.commonEvent) {
      this.commonEvent = false;
      if (!this.checkFoldAndOrientation()) {
        log.showInfo(`publish common event swipe direction: ${this.direction}`);
        setTimeout(() => {
          if (this.nonFourEvent) {
            log.showInfo('nonFourEvent');
            this.nonFourEvent = false;
          } else {
            DesktopSwitchController.getInstance().publishCommonEvent();
          }
        }, NOTIFY_DELAY);
        this.canSwipeUpdate = false;
        return false;
      }
      if (!this.checkQXSSwitch()) {
        log.showInfo(`publish common event swipe direction: ${this.direction}`);
        setTimeout(() => {
          if (this.nonFourEvent) {
            log.showInfo('nonFourEvent');
            this.nonFourEvent = false;
          } else {
            this.sendToast();
          }
        }, NOTIFY_DELAY);
        this.canSwipeUpdate = false;
        return false;
      }
    }
    Trace.end('[DesktopWorld]checkUpdateSwitch');
    return true;
  }

  private onSwitchingUser = (switchData: SwitchEventData) => {
    let isCurrentUserActive: boolean = AccountHelper.getInstance().currentLocalId === switchData.toAccountId;
    log.showInfo(`receive user switching, update isCurrentUserActive:${isCurrentUserActive}`);
    this.isCurrentUserActive = isCurrentUserActive;
  }

  public static getInstance(): FourFingerSwipeController {
    if (!FourFingerSwipeController.instance) {
      FourFingerSwipeController.instance = new FourFingerSwipeController();
    }
    return FourFingerSwipeController.instance;
  }

  constructor() {
    this.registerKeyLeftCtrlEvent();
    this.registerKeyRightCtrlEvent();
    this.registerKeyLeftShiftEvent();
    screenLockStateManager.registerScreenLockState(this.screenLockStateListener);
    AccountHelper.getInstance().isForegroundUser((isForegroundUser: boolean): void => {
      log.showInfo(`init AccountHelper, isForegroundUser: ${isForegroundUser}`);
      this.isCurrentUserActive = isForegroundUser;
    });
    AccountHelper.getInstance().registerUserSwitchListener('switching', this.onSwitchingUser);
    SwipeGestureManager.getInstance().registerScreenFourFingersCallback(this.fourFingersTouch);
    SCBSceneSessionManager.getInstance().registerOnFocusedScreenChangeCallback(this.onFocusedScreenChangeCallback);
    SCBSceneSessionManager.getInstance().registerOnFocusedCallback(this.onSessionFocusedChangeCallback);
    MultiInputViewModel.getInstance().registerHosKeyShowCallback(this.hosKeyShowCallback);
    this.windowWidth = FULL_SCREEN_WIDTH;
    this.windowHeight = FULL_SCREEN_HEIGHT;
    this.updateSettingsData(false);
    this.registerScreenDisconnect();
  }

  private registerScreenDisconnect(): void {
    try {
      screen.on('disconnect', this.screenDisconnect);
    } catch (error) {
      log.showError(`screen.on('disconnect', callback) failed. message: ${error?.message}`);
    }
  }

  public unRegisterScreenDisconnect(): void {
    try {
      screen.off('disconnect', this.screenDisconnect);
    } catch (error) {
      log.showError(`screen.on('disconnect', callback) failed. message: ${error?.message}`);
    }
  }

  private screenDisconnect = (id: number) => {
    log.showInfo(`ExtendedScreen disconnect id: ${id}`);
    if (id >= MAXIMUM_SCREEN_ID) {
      log.showInfo('disconnect screenId greater than Maximum screen ID');
      return;
    }
    this.recoverMotionOnMainScreen();
  }

  public recoverMotionOnMainScreen(): void {
    if (this.motionScreenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('motion screen is main screen');
      return;
    }
    this.setMotionScreenId(SCBSceneSessionManager.getInstance().mainScreenId);
    this.swipeCallbacks.find((swipeCallback) => {
      log.showInfo(`switch screen swipeCallback screen id: ${swipeCallback?.getMotionScreenId()}`);
      if (swipeCallback?.getMotionScreenId() === this.motionScreenId) {
        this.swipeCallback = swipeCallback;
        this.vmSnapshot();
        this.harmonyScreenshot();
        this.updateShowPrefabrication(false);
        this.updateScreenSize();
        this.updateWindowSize(vp2px(this.screenWidth), vp2px(this.screenHeight));
      }
    });
  }

  private rotationChangeEntryIgnoringSensor(rotation: number, rotateReasonDescription: string): void {
    log.showInfo(`rotationChangeEntryIgnoringSensor, rotation: ${rotation}, description: ${rotateReasonDescription}`);
    let screenProperty: SCBScreenProperty = SCBScreenSessionManager.getInstance()
      .getMainScreenSession()?.scbScreenProperty;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty?.screenId);
    if (!screenSession) {
      log.showError('Failed getScreenSession!');
      return;
    }
    try {
      screenSession.setEnableSensorRotate(false, rotateReasonDescription);
      this.needScreenRotateLock(false);
      screenSession.rotationChangeEntry(rotation, rotateReasonDescription);
      if (!this.isLock) {
        setTimeout(() => {
          if (DesktopSwitchController.getInstance().hasVmAbility()) {
            this.needScreenRotateLock(true);
          }
          screenSession.setEnableSensorRotate(true, rotateReasonDescription);
        }, 10);
      } else {
        screenSession.setEnableSensorRotate(true, rotateReasonDescription);
      }
    } catch (err) {
      log.showError(`rotationChangeEntryIgnoringSensor failed: ${err?.message}`);
      if (!this.isLock && DesktopSwitchController.getInstance().hasVmAbility()) {
        this.needScreenRotateLock(true);
      }
      screenSession.setEnableSensorRotate(true, rotateReasonDescription);
    }
  }

  private setVirtualKeyboard(isShow: boolean): void {
    log.showInfo(`setVirtualKeyboard show ${isShow}`);
    if (!isShow) {
      try {
        StartAbilityUtil.startServiceExtensionAbility({
          bundleName: 'com.ohos.virtualkeyboard',
          abilityName: 'ServiceExtAbility',
          parameters: {
            callType: VM_RUNNING,
            action: 'off',
          },
        })
      } catch (error) {
        log.showError(`virtual keyboard ability error, code: ${error?.code}, message: ${error?.message}`);
      }
      return;
    }
    setTimeout(() => {
      try {
        StartAbilityUtil.startServiceExtensionAbility({
          bundleName: 'com.ohos.virtualkeyboard',
          abilityName: 'ServiceExtAbility',
          parameters: {
            callType: VM_RUNNING,
            action: 'on',
          },
        })
      } catch (error) {
        log.showError(`start virtual keyboard ability error, code: ${error?.code}, message: ${error?.message}`);
      }
    }, 100);
  }

  private enterVmFoldedPhysicalState(): void {
    log.showInfo('enterVmFoldedPhysicalState');
    if (this.isLock) {
      log.showInfo('screen is lock, enterVmFoldedPhysicalState not execute');
      return;
    }
    if (this.motionScreenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('The screen is not the main display, enterVmFoldedPhysicalState not execute');
      return;
    }
    this.rotationChangeEntryIgnoringSensor(OrientationAngle.PORTRAIT, 'enterVmFoldedPhysicalState');
    this.updateWindowSize(FOLD_SCREEN_WIDTH, FOLD_SCREEN_HEIGHT);
    this.windowWidth = FOLD_SCREEN_WIDTH;
    this.windowHeight = FOLD_SCREEN_HEIGHT;
    this.setMotionRect(FOLD_SCREEN_WIDTH, FOLD_SCREEN_HEIGHT);
    this.setScreenWidth(DevicesScreenWitch.HOPPER_FOLD);
    this.disableInterruptEffect();
    this.reportVmUsingTime();
    this.recentVmState = VmState.VM_HPR_FOLDED_PHYSICAL_KEYBOARD;
  }

  private enterVmFoldedVirtualKeyboardState(skipDisableInterruptEffect: boolean = false): void {
    log.showInfo('enterVmFoldedVirtualKeyboardState');
    if (this.isLock) {
      log.showInfo('screen is lock, enterVmFoldedVirtualKeyboardState not execute');
      return;
    }
    if (this.motionScreenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('The screen is not the main display, enterVmFoldedVirtualKeyboardState not execute');
      return;
    }
    this.rotationChangeEntryIgnoringSensor(OrientationAngle.PORTRAIT, 'enterVmFoldedVirtualKeyboardState');
    this.updateWindowSize(FOLD_SCREEN_WIDTH, FOLD_SCREEN_HEIGHT);
    this.windowWidth = FOLD_SCREEN_WIDTH;
    this.windowHeight = FOLD_SCREEN_HEIGHT;
    this.setMotionRect(FOLD_SCREEN_WIDTH, FOLD_SCREEN_HEIGHT);
    if (!this.isLock) {
      this.setVirtualKeyboard(true);
    }
    this.setScreenWidth(DevicesScreenWitch.HOPPER_FOLD);
    if (!skipDisableInterruptEffect) {
      this.disableInterruptEffect();
    }
    this.reportVmUsingTime();
    this.recentVmState = VmState.VM_HPR_FOLDED_VIRT_KEYBOARD;
  }

  private enterVmFullScreenState(skipDisableInterruptEffect: boolean = false): void {
    log.showInfo('enterVmFullScreenState');
    if (this.isLock) {
      log.showInfo('screen is lock, enterVmFullScreenState not execute');
      return;
    }
    if (this.motionScreenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('The screen is not the main display, enterVmFullScreenState not execute');
      return;
    }
    this.rotationChangeEntryIgnoringSensor(OrientationAngle.LANDSCAPE_INVERTED, 'enterVmFullScreenState');
    this.updateWindowSize(FULL_SCREEN_WIDTH, FULL_SCREEN_HEIGHT);
    this.windowWidth = FULL_SCREEN_WIDTH;
    this.windowHeight = FULL_SCREEN_HEIGHT;
    this.setMotionRect(FULL_SCREEN_WIDTH, FULL_SCREEN_HEIGHT);
    this.setScreenWidth(DevicesScreenWitch.HOPPER_FULL);
    if (!skipDisableInterruptEffect) {
      this.disableInterruptEffect();
    }
    this.reportVmUsingTime();
    this.recentVmState = VmState.VM_HPR_FULL_SCREEN;
  }

  private enterHarmonyFoldedState(skipDisableInterruptEffect: boolean = false): void {
    log.showInfo('enterHarmonyFoldedState');
    if (this.motionScreenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('The screen is not the main display, enterHarmonyFoldedState not execute');
      return;
    }
    this.setScreenWidth(DevicesScreenWitch.HOPPER_FOLD);
    this.updateWindowSize(FOLD_SCREEN_WIDTH, FOLD_SCREEN_HEIGHT);
    this.windowWidth = FOLD_SCREEN_WIDTH;
    this.windowHeight = FOLD_SCREEN_HEIGHT;
    this.setMotionRect(FOLD_SCREEN_WIDTH, FOLD_SCREEN_HEIGHT);
    if (!skipDisableInterruptEffect) {
      this.disableInterruptEffect();
    }
  }

  private enterHarmonyFullScreenState(skipDisableInterruptEffect: boolean = false): void {
    log.showInfo('enterHarmonyFullScreenState');
    if (this.motionScreenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('The screen is not the main display, enterHarmonyFullScreenState not execute');
      return;
    }
    this.setScreenWidth(DevicesScreenWitch.HOPPER_FULL);
    this.updateWindowSize(FULL_SCREEN_WIDTH, FULL_SCREEN_HEIGHT);
    this.windowWidth = FULL_SCREEN_WIDTH;
    this.windowHeight = FULL_SCREEN_HEIGHT;
    this.setMotionRect(FULL_SCREEN_WIDTH, FULL_SCREEN_HEIGHT);
    if (!skipDisableInterruptEffect) {
      this.disableInterruptEffect();
    }
  }

  private disableInterruptEffect(): void {
    log.showInfo('disableInterruptEffect');
    this.canInterrupt = false;
    setTimeout(() => {
      this.canInterrupt = true;
    }, DELAY_TIME);
  }

  private updateWindowSize(width: number, height: number, left: number = 0, top: number = 0): void {
    log.showInfo(`updateWindowSize, width: ${width}, height: ${height}`);
    DesktopSwitchController.getInstance().getVmSceneContainerSession()?.primarySession?.currRect.setRectNum(left, top,
      width, height);
  }

  public getPhysicalKeyboard(): boolean {
    return this.physicalKeyboard;
  }

  private blurringHarmonyAnimation(toggleMotionType: ToggleMotionType): void {
    log.showInfo('blurringHarmonyAnimation');
    this.updateWallpaperIndexToShowDesktop();
    this.updateShowBackground(false);
    animateTo({
      duration: 200,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.updateShowBackground(true);
        this.updateHarmonySnapshotOpacity(OPACITY_MAX);
        switch (toggleMotionType) {
          case ToggleMotionType.FOLLOW_HAND:
            this.backRightMotionFinish();
            break;
          case ToggleMotionType.QUICK_SWIPE:
            this.quickBackRightMotionFinish();
            break;
          case ToggleMotionType.ONE_TIME:
            this.oneTimeRightSwipeMotionFinish();
            break;
          default:
            log.showError('blurringHarmonyAnimation err');
        }
      }
    }, () => {
      this.updateHarmonySnapshotOpacity(OPACITY_MIN);
      this.updateHarmonySnapshotBlurScale(BLUR_MIN);
    })
  }

  private blurringVmAnimation(toggleMotionType: ToggleMotionType): void {
    log.showInfo('blurringVmAnimation');
    this.updateWallpaperIndexToShowDesktop();
    this.setVmDesktop(true);
    this.updateShowBackground(false);
    animateToImmediately({
      duration: 200,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.updateShowBackground(true);
        this.updateVmSnapshotOpacity(OPACITY_MAX);
        switch (toggleMotionType) {
          case ToggleMotionType.FOLLOW_HAND:
            this.backLeftMotionFinish();
            break;
          case ToggleMotionType.QUICK_SWIPE:
            this.quickBackLeftMotionFinish();
            break;
          case ToggleMotionType.ONE_TIME:
            this.oneTimeLeftMotionFinish();
            break;
          default:
            log.showError('blurringVmAnimation err');
        }
      }
    }, () => {
      this.updateVmSnapshotOpacity(OPACITY_MIN);
      this.updateVmSnapshotBlurScale(BLUR_MIN);
    })
  }

  private snapshotBlur(harmonySnapshotBlur: boolean): void {
    log.showInfo(`Harmony snapshot fold state: ${this.isHarmonySnapshotFoldState} ` +
      `Vm snapshot fold state: ${this.isVmSnapshotFoldState} `);
    if (harmonySnapshotBlur) {
      if (this.isHarmonySnapshotFoldState === SnapshotFoldState.FOLD) {
        // Harmony截图半屏 -> 全屏返回Harmony
        this.updateHarmonySnapshotBlurScale(BLUR_MAX);
      } else if (this.isHarmonySnapshotFoldState === SnapshotFoldState.EXPAND) {
        // Harmony截图全屏 -> 半屏返回Harmony
        this.updateHarmonySnapshotBlurScale(BLUR_MAX);
      }
    } else {
      if (this.isVmSnapshotFoldState === SnapshotFoldState.FOLD) {
        // VM截图半屏 -> 全屏返回VM
        this.updateVmSnapshotBlurScale(BLUR_MAX);
      } else if (this.isVmSnapshotFoldState === SnapshotFoldState.EXPAND) {
        // VM截图全屏 -> 半屏返回VM
        this.updateVmSnapshotBlurScale(BLUR_MAX);
      }
    }
  }

  public unregisterOnFocusedScreenChangeCallback(): void {
    log.showInfo('unregister on focused screen change');
    SCBSceneSessionManager.getInstance().unRegisterOnFocusedScreenChangeCallback(this.onFocusedScreenChangeCallback);
  }

  public unregisterOnFocusedCallback(): void {
    log.showInfo('unregister on focused');
    SCBSceneSessionManager.getInstance().unregisterOnFocusedCallback(this.onSessionFocusedChangeCallback);
  }

  public unregisterHosKeyShow(): void {
    log.showInfo('unregister hos key show');
    MultiInputViewModel.getInstance().unregisterHosKeyShowCallback(this.hosKeyShowCallback);
  }

  private hosKeyShowCallback = () => {
    if (this.vmDesktop && this.motionScreenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      log.showInfo('hos key show');
      HiSysEventUtil.reportSwitchingDesktopEvent(SYSTEM_WINDOW_SHOW, this.getTime());
      this.oneTimeRightSwipeMotionSnapshot();
    }
  }

  private onSessionFocusedChangeCallback = (nextFocusedId: number) => {
    log.showInfo(`nextFocusedId: ${nextFocusedId}`);
    if (!this.getHasVm() && this.vmDesktop) {
      log.showDebug('No virtual machines or Not on VM');
      return;
    }
    if (SCBScreenSessionManager.getInstance().getScreenSessionList().length === SCREEN_NUMBER_ONE) {
      log.showInfo(`screen number: ${SCBScreenSessionManager.getInstance().getScreenSessionList().length}`);
      return;
    }
    let nextSession = SCBSceneSessionManager.getInstance().getSessionById(nextFocusedId);
    if (!nextSession) {
      log.showWarn(`get nextSession failed. nextId:${nextFocusedId} `);
      return;
    }
    if (!this.isSCBSystemSceneSession(nextSession)) {
      log.showWarn(`not SCBSystemScene. nextId:${nextFocusedId} `);
      return;
    }
    let showRecent = AppStorage.get('showRecent') as boolean;
    if (showRecent) {
      log.showWarn(`Recent is showing`);
      return;
    }
    if (this.getSystemSceneState() && nextSession.session.screenId === this.motionScreenId) {
      log.showInfo('system scene show');
      HiSysEventUtil.reportSwitchingDesktopEvent(SYSTEM_WINDOW_SHOW, this.getTime());
      this.oneTimeRightSwipeMotionSnapshot();
      return;
    }
    if (this.systemSceneSessionTrustList(nextSession)) {
      return;
    }
    if (nextSession.session.screenId === this.motionScreenId) {
      log.showInfo(`system scene show, session type: ${nextSession.session.type}`);
      HiSysEventUtil.reportSwitchingDesktopEvent(SYSTEM_WINDOW_SHOW, this.getTime());
      this.oneTimeRightSwipeMotionSnapshot();
    }
  }

  private getSystemSceneState(): boolean {
    for (let i = 0; i < VIEW_TYPE.length; i++) {
      log.showInfo('ViewType: ' + VIEW_TYPE[i] + ' isShow: ' + ViewManagerPolicy.isViewShowing(VIEW_TYPE[i]))
      if (ViewManagerPolicy.isViewShowing(VIEW_TYPE[i])) {
        return true;
      }
    }
    return false;
  }

  private systemSceneSessionTrustList(
    nextSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    if (sessionTypes.some(type => nextSession.session.type === type)) {
      log.showWarn(`system scene session trust list, session type: ${nextSession.session.type}`);
      return true;
    }
    return false;
  }

  private isSCBSystemSceneSession(session: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    if (session instanceof SCBSystemSceneSession) {
      return true;
    }
    return false;
  }

  private onFocusedScreenChangeCallback = (fromScreen: number, toScreen: number): void => {
    log.showInfo(`fromScreen:${fromScreen}, toScreen:${toScreen}`);
    if (this.getHasVm() && this.vmDesktop) {
      if (toScreen === SCBSceneSessionManager.getInstance().mainScreenId) {
        log.showInfo('disable combine key');
      } else {
        log.showInfo('enable combine key');
      }
    }
  }

  public unRegisterScreenFourFingersCallback(): void {
    log.showInfo('unRegisterScreenFourFingersCallback');
    SwipeGestureManager.getInstance().unregisterScreenFourFingersCallback(this.fourFingersTouch);
  }

  private fourFingersTouch: inputMonitor.TouchEventReceiver = (touchEvent: TouchEvent): boolean => {
    if (touchEvent.action === TOUCH_BEGIN && FINGER_NUMBER.some(number => touchEvent.touches.length === number)) {
      log.showInfo(`touch event finger number: ${touchEvent.touches.length}`);
      this.nonFourEvent = true;
      setTimeout(() => {
        this.nonFourEvent = false;
      }, RECOVER_DELAY);
    }
    if (touchEvent.touches.length === FOURTH_FINGER) {
      if (!this.canFourFingerTouch(touchEvent)) {
        return false;
      }
      if (touchEvent.action === TOUCH_BEGIN) {
        this.fourFingerTouchBegin(touchEvent);
      } else if (touchEvent.action === TOUCH_UPDATE) {
        this.fourFingerTouchUpdate(touchEvent);
      }
    }
    if (this.startFourFingerTouch) {
      if (touchEvent.action === TOUCH_END || touchEvent.action === TOUCH_CANCEL) {
        this.fourFingerTouchEnd(touchEvent);
        return true;
      }
    }
    return false;
  };

  private fourFingerTouchBegin(touchEvent: TouchEvent): void {
    log.showInfo('four fingers touch begin');
    this.startFourFingerTouch = true;
    this.originalPosition = this.getPointsCenter(touchEvent.touches);
    this.swipeBegin();
  }

  private fourFingerTouchUpdate(touchEvent: TouchEvent): void {
    if (!this.trigger) {
      return;
    }
    this.trigger = false;
    setTimeout(() => {
      this.trigger = true;
    }, REPORTING_INTERVAL);
    let position: Position = this.getPointsCenter(touchEvent.touches);
    log.showDebug('X: ' + position.x + ' Y: ' + position.y);
    if (!this.checkPosition(position)) {
      return;
    }
    let timestamp = Date.now();
    this.swipeUpdate(position.x, position.y, timestamp);
  }

  private fourFingerTouchEnd(touchEvent: TouchEvent): void {
    log.showInfo('four fingers touch end action: ' + touchEvent.action + ' finger number: ' +
    touchEvent.touches.length);
    this.swipeEnd();
    this.startFourFingerTouch = false;
  }

  private checkPosition(position: Position): boolean {
    if (this.originalPosition === null) {
      return false;
    }
    if (Math.abs(this.originalPosition.x - position.x) === Math.abs(this.originalPosition.y - position.y)) {
      return false;
    }
    if (Math.abs(this.originalPosition.x - position.x) <= DEBOUNCE_THRESHOLD) {
      return false;
    }
    return true;
  }

  private canFourFingerTouch(touchEvent: TouchEvent): boolean {
    if (touchEvent.sourceType !== SourceType.TOUCH_SCREEN) {
      log.showWarn(`sourceType: ${touchEvent.sourceType}`);
      return false;
    }
    if (!this.startFourFingersSwipe(touchEvent.action === TOUCH_BEGIN)) {
      return false;
    }
    return true;
  }

  public getPointsCenter(points: Touch[]): Position {
    let sumX = 0;
    let sumY = 0;
    points.forEach(point => {
      sumX += point.screenX;
      sumY += point.screenY;
    });
    sumX = sumX / FOURTH_FINGER;
    sumY = sumY / FOURTH_FINGER;
    return new Position(sumX, sumY);
  }

  public startFourFingersSwipe(isBeginEvent: boolean = false): boolean {
    if (!MultiInputViewModel.getInstance()?.isMultiDeskSwitchEnable()) {
      log.showWarn('four fingers swipe switch desk disable!');
      return false;
    }

    if (ctrlAltDelPanelModel?.checkCtrlAltDelPanelShow?.()) {
      log.showWarn(TAG, 'ctrlAltDel Panel Show');
      return false;
    }

    if (!this.isCurrentUserActive) {
      log.showWarn('current is background, not handle fourFingers event');
      return false;
    }

    if (!this.getHasVm() || !this.getInterrupt()) {
      log.showWarn(`The current animate is not completed, Interrupt: ${this.getInterrupt()}`);
      return false;
    }
    return true;
  }

  public getDirection(): SwipeGestureDirection {
    return this.direction;
  }

  public setCanInterrupt(canInterrupt: boolean): void {
    log.showInfo(`setCanInterrupt: ${canInterrupt} `);
    this.canInterrupt = canInterrupt;
  }

  public swipeBegin(): void {
    log.showInfo('swipeBegin');
    if (!this.canSwitch()) {
      return;
    }
    if (!this.onFourFingerMotionBegin()) {
      log.showInfo('App Center, Task Center, or Split-screen mode prohibit four-finger swipes');
      return;
    }
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    this.ended = false;
    this.reset();
    this.getSnapshot(this.getVmDesktop());
    this.disableSnapshot = true;
    this.isSwipe = true;
    this.swipeBeginTimeStamp = systemDateTime.getTime(false);
  }

  public swipeEnd(): void {
    log.showInfo('swipeEnd');
    let distance = this.getSwipeHorizontalDistance();
    this.reportSwipeGesture(distance);
    this.onFourFingerMotionEnd();
    if (!this.checkFoldAndOrientation() || !this.canSwipeUpdate) {
      this.resetParameter();
      return;
    }
    if (!this.judgmentSwipeEnd()) {
      return;
    }
    this.ended = true;
    this.canInterrupt = false;
    let sMin = this.getMinSwipeDistance();
    this.onFourFingerMotionEnd();
    if (this.isSwipe) {
      if (this.direction === SwipeGestureDirection.LEFT && !this.getVmDesktop()) {
        log.showInfo(`distance is ${distance}, sMin is ${sMin}`);
        // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_MANUAL_TO_AUTO_END);
        if (distance < sMin) {
          DesktopSwitchController.getInstance().onRearAni(false);
          this.revokeAnimate = true;
          this.backRightMotion(distance - DISTANCE_MIN);
        } else {
          this.reportFourFingerSwipe(SwipeGestureDirection.LEFT);
          DesktopSwitchController.getInstance().onRearAni(true);
          this.backLeftMotion(distance);
        }
      } else if (this.direction === SwipeGestureDirection.RIGHT && this.getVmDesktop()) {
        log.showInfo(`-distance is ${-distance}, sMin is ${sMin}`);
        // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_MANUAL_TO_AUTO_END);
        if (-distance < sMin) {
          DesktopSwitchController.getInstance().onRearAni(true);
          this.revokeAnimate = true;
          this.backLeftMotion(distance + DISTANCE_MIN);
        } else {
          this.reportFourFingerSwipe(SwipeGestureDirection.RIGHT);
          DesktopSwitchController.getInstance().onRearAni(false);
          this.backRightMotion(distance);
        }
      } else {
        this.canInterrupt = true;
        if (this.memoryRelease) {
          this.memoryReleaseEnd();
        }
        log.showInfo('swipe direction error');
      }
    } else {
      this.canInterrupt = true;
      if (this.memoryRelease) {
        this.memoryReleaseEnd();
      }
      log.showInfo('prohibit four-finger swipes');
    }

    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    this.reset();
    this.isSwipe = false;
    this.isShow = false;
    this.originalPosition = null;
    this.disableSnapshot = false;
  }

  private SwipeDirection(x: number, y: number, time: number): boolean {
    if (this.startEvent.x === -1 && this.startEvent.y === -1) {
      this.preEvent.set(x, y, time);
      this.startEvent.set(x, y, time);
      return false;
    }
    if (this.direction === SwipeGestureDirection.NONE) {
      log.showInfo(`swipe direction x: ${x} preEvent x: ${this.preEvent.x} Y: ${y} preEvent y: ${this.preEvent.y}`);
      if (Math.abs(y - this.preEvent.y) >= Math.abs(x - this.preEvent.x)) {
        this.direction = y < this.preEvent.y ? SwipeGestureDirection.UP : SwipeGestureDirection.DOWN;
      } else {
        this.direction = x < this.preEvent.x ? SwipeGestureDirection.LEFT : SwipeGestureDirection.RIGHT;
      }
      this.commonEvent = true;
      this.onFourFingerMotionUpdate();
      if ((this.direction === SwipeGestureDirection.LEFT && !this.getVmDesktop()) ||
        (this.direction === SwipeGestureDirection.RIGHT && this.getVmDesktop())) {
        this.setPointerVisible(false);
        performanceMonitor.begin('SWITCH_DESKTOP', performanceMonitor.ActionType.FIRST_MOVE, 'SWITCH_DESKTOP');
      } else {
        log.showInfo('swipe direction error');
        return false;
      }
    }
    if (this.direction === SwipeGestureDirection.UP || this.direction === SwipeGestureDirection.DOWN) {
      log.showInfo('swipe direction is up or down');
      return false;
    }
    if (this.curEvent.x !== -1 && this.curEvent.y !== -1) {
      this.preEvent.clone(this.curEvent);
    }
    this.curEvent.set(x, y, time);
    this.calcSpeedAndAcc();
    return true;
  }

  public swipeUpdate(x: number, y: number, time: number): void {
    if (!this.isSwipe || !this.SwipeDirection(x, y, time)) {
      log.showInfo(`swipe is ${this.isSwipe} or swipe direction error`);
      return;
    }
    if (!this.checkUpdateSwitch()) {
      log.showInfo('checkUpdateSwitch()');
      return;
    }
    if (this.gettingSnapshot) {
      log.showInfo('swipe update getting snapshot');
      return;
    }
    this.followAnimateShow();
  }

  private followAnimateShow(): void {
    ApsUtils.pulseApsSession(this.apsSessionId);
    if (this.direction == SwipeGestureDirection.RIGHT && this.getVmDesktop()) {
      if (!this.isShow) {
        log.showInfo('showView switch desktop right motion');
        // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HAND_GESTURE_START);
        this.snapshotBlur(true);
        this.updateMotionWindowVisible(true);
        Trace.start(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_ANIMATION);
        this.isShow = true;
      }
      this.swipeUpdateRight();
    } else if (this.direction == SwipeGestureDirection.LEFT && !this.getVmDesktop()) {
      if (!this.isShow) {
        log.showInfo('showView switch desktop left motion');
        // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HAND_GESTURE_START);
        this.snapshotBlur(false);
        this.updateMotionWindowVisible(true);
        Trace.start(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_ANIMATION);
        this.isShow = true;
      }
      this.swipeUpdateLeft();
    } else {
      log.showInfo(`swipe direction error direction : ${this.direction} vm desktop: ${this.getVmDesktop()}`);
    }
  }

  private updateMotionWindowVisible(isShow: boolean): void {
    log.showInfo(`updateMotionWindowVisible isShow: ${isShow}, motionScreenId: ${this.motionScreenId}`);
    if (isShow) {
      // this.apsSessionId = ApsUtils.startApsPersistentSession(apsManager.SceneAnimation.SWITCH_DESKTOP);
      ViewManagerPolicy.showView(this.motionScreenId === MAIN_SCREEN_ID ?
        ViewType.DESKTOP_SWITCHER : ViewType.DESKTOP_SWITCHER_EXT_SCREEN);
    } else {
      // ApsUtils.stopApsSession(this.apsSessionId);
      this.apsSessionId = '';
      ViewManagerPolicy.hideView(this.motionScreenId === MAIN_SCREEN_ID ?
        ViewType.DESKTOP_SWITCHER : ViewType.DESKTOP_SWITCHER_EXT_SCREEN);
    }
  }

  private setPointerVisible(isVisible: boolean): void {
    log.showInfo(`setPointerVisible: ${isVisible}`);
    try {
      pointer.setPointerVisibleSync(isVisible);
    } catch (error) {
      log.showError(`pointer.setPointerVisibleSync error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public swipeUpdateLeft(): void {
    let currentDistance = this.getSwipeHorizontalDistance();
    let currentPercent = 0;
    if (currentDistance > 0) {
      currentPercent = Math.abs(currentDistance / FourFingerSwipeConstants.MAX_SLIDE_DISTANCE);
      currentPercent = Math.max(0, Math.min(currentPercent, FourFingerSwipeConstants.MAX_PERCENT));
    }
    let currentTranslateX = this.screenWidth * (1 - currentPercent);
    if (this.harmonySnapshotScale === SCALE_MAX) {
      this.updateVmSnapshotScale(SCALE_MIN);
      animateToImmediately({
        duration: 300,
        curve: Curves.springMotion(),
        iterations: 1,
        playMode: PlayMode.Normal,
      }, () => {
        this.updateHarmonySnapshotScale(SCALE_MIDDLE);
      })
    } else if (this.harmonySnapshotScale <= SCALE_MIDDLE) {
      animateToImmediately({
        curve: Curves.responsiveSpringMotion(),
      }, () => {
        this.updateVmSnapshotScale(SCALE_MIN + 0.2 * currentPercent);
        this.updateVmSnapshotX(currentTranslateX);
        this.updateVmSnapshotRotate(-(1 - currentPercent) * ROTATE_ANGLE_MAX);
        this.updateHarmonySnapshotScale(SCALE_MIDDLE - 0.2 * currentPercent);
        this.updateHarmonySnapshotX(currentTranslateX - this.screenWidth);
        this.updateHarmonySnapshotRotate(currentPercent * ROTATE_ANGLE_MAX);
        this.updateHarmonySnapshotOpacity(OPACITY_MAX - currentPercent);
      })
    }
  }

  public swipeUpdateRight(): void {
    let currentDistance = this.getSwipeHorizontalDistance();
    let currentPercent = 0;
    currentPercent = currentDistance / FourFingerSwipeConstants.MAX_SLIDE_DISTANCE;
    currentPercent = Math.min(currentPercent, 0);
    currentPercent = Math.max(currentPercent, -1);
    let currentTranslateX = -(this.screenWidth) * currentPercent;
    if (this.vmSnapshotScale === SCALE_MAX) {
      this.updateHarmonySnapshotScale(SCALE_MIN);
      animateToImmediately({
        duration: 300,
        curve: Curves.springMotion(),
        iterations: 1,
        playMode: PlayMode.Normal,
      }, () => {
        this.updateVmSnapshotScale(SCALE_MIDDLE);
      })
    } else if (this.vmSnapshotScale <= SCALE_MIDDLE) {
      animateToImmediately({
        curve: Curves.responsiveSpringMotion(),
      }, () => {
        this.updateHarmonySnapshotScale(SCALE_MIN - 0.2 * currentPercent);
        this.updateHarmonySnapshotX(currentTranslateX - this.screenWidth);
        this.updateHarmonySnapshotRotate((1 + currentPercent) * ROTATE_ANGLE_MAX);
        this.updateVmSnapshotScale(SCALE_MIDDLE + 0.2 * currentPercent);
        this.updateVmSnapshotX(currentTranslateX);
        this.updateVmSnapshotRotate(currentPercent * ROTATE_ANGLE_MAX);
        this.updateVmSnapshotOpacity(OPACITY_MAX + currentPercent);
      })
    }
  }

  private judgmentSwipeEnd(): boolean {
    if (this.ended) {
      log.showInfo('swipeEnd ended');
      if (!this.memoryRelease) {
        this.updateMotionWindowVisible(false);
      }
      this.setPointerVisible(true);
      AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
      this.isSwipe = false;
      this.isShow = false;
      this.originalPosition = null;
      this.disableSnapshot = false;
      this.canInterrupt = true;
      return false;
    }
    if (this.gettingSnapshot) {
      log.showInfo('swipeEnd getting snapshot');
      this.dropSnapshot = true;
      this.updateMotionWindowVisible(false);
      this.setPointerVisible(true);
      AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
      this.isSwipe = false;
      this.isShow = false;
      this.originalPosition = null;
      this.disableSnapshot = false;
      if (this.direction === SwipeGestureDirection.RIGHT && this.vmDesktop) {
        this.reportFourFingerSwipe(SwipeGestureDirection.RIGHT);
        // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_MANUAL_TO_AUTO_END);
        this.reset();
        this.initVmDesktop();
        this.quickBackRightMotionSnapshot();
      } else if (this.direction === SwipeGestureDirection.LEFT && !this.vmDesktop) {
        this.reportFourFingerSwipe(SwipeGestureDirection.LEFT);
        // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_MANUAL_TO_AUTO_END);
        this.reset();
        this.initHarmonySnapshotDesktop();
        this.updateSettingsData(true);
        this.quickBackLeftMotionSnapshot();
      } else {
        log.showInfo(`swipe direction error, direction: ${this.direction} vm desktop: ${this.vmDesktop}`);
        if (this.memoryRelease) {
          this.memoryReleaseEnd();
        }
      }
      return false;
    }
    if (this.direction === SwipeGestureDirection.NONE ||
      this.direction === SwipeGestureDirection.UP ||
      this.direction === SwipeGestureDirection.DOWN) {
      log.showInfo('swipeEnd direction is none, up, down');
      this.canInterrupt = true;
      if (this.memoryRelease) {
        this.memoryReleaseEnd();
      }
      AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
      this.reset();
      this.isShow = false;
      this.originalPosition = null;
      this.disableSnapshot = false;
      this.isSwipe = false;
      this.setPointerVisible(true);
      this.updateMotionWindowVisible(false);
      return false;
    }
    log.showInfo('judgment swipe end');
    return true;
  }

  private reportFourFingerSwipe(direction: SwipeGestureDirection): void {
    let reportKey: string = `${direction}:${this.startFourFingerTouch}`;
    let fourFingerSwipeEvent = reportFourFingerSwipeMap.get(reportKey);
    if (fourFingerSwipeEvent) {
      HiSysEventUtil.reportSwitchingDesktopEvent(fourFingerSwipeEvent, this.getTime());
    } else {
      log.showError(`reportFourFingerSwipe, direction Error! reportKey is ${fourFingerSwipeEvent}`);
    }
  }

  private followFingerBackLeftMotion(): boolean {
    if (this.harmonySnapshotScale !== SCALE_MAX) {
      return false;
    }
    log.showInfo('back left motion harmony snapshot scale is max');
    this.canInterrupt = true;
    this.updateMotionWindowVisible(false);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    this.reset();
    this.isShow = false;
    this.originalPosition = null;
    this.disableSnapshot = false;
    this.isSwipe = false;
    this.dropSnapshot = true;
    this.quickBackLeftMotionSnapshot();
    return true;
  }

  private followFingerBackRightMotion(): boolean {
    if (this.vmSnapshotScale !== SCALE_MAX) {
      return false;
    }
    log.showInfo('back right motion vm snapshot scale is max');
    this.canInterrupt = true;
    this.updateMotionWindowVisible(false);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    this.reset();
    this.isSwipe = false;
    this.dropSnapshot = true;
    this.quickBackRightMotionSnapshot();
    return true;
  }

  private backRightMotion(distance: number): void {
    log.showInfo('backRightMotion');
    if (this.followFingerBackRightMotion()) {
      return;
    }
    DesktopSwitchController.getInstance().minimizeVmWindow();
    animateToImmediately({
      finishCallbackType: FinishCallbackType.LOGICALLY,
      duration: 800,
      curve: Curves.springMotion(0.45, 0.8),
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.setVmDesktop(false);
        if (this.isHarmonySnapshotFoldState === SnapshotFoldState.FOLD) {
          this.blurringHarmonyAnimation(ToggleMotionType.FOLLOW_HAND);
        } else if (this.isHarmonySnapshotFoldState === SnapshotFoldState.EXPAND) {
          this.blurringHarmonyAnimation(ToggleMotionType.FOLLOW_HAND);
        } else {
          this.backRightMotionFinish();
        }
      }
    }, () => {
      this.updateVmSnapshotX(this.screenWidth);
      this.updateVmSnapshotRotate(-ROTATE_ANGLE_MAX);
      this.updateVmSnapshotOpacity(OPACITY_MIN);
      this.updateVmSnapshotScale(SCALE_MIN);
      this.updateHarmonySnapshotX(PLACE_START);
      this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MIN);
      this.updateHarmonySnapshotScale(SCALE_MIDDLE);
    })
    animateToImmediately({
      duration: 800,
      curve: Curves.springMotion(0.45, 0.8),
      playMode: PlayMode.Normal,
    }, () => {
      this.updateHarmonySnapshotScale(SCALE_MAX);
      this.updateHarmonySnapshotOpacity(OPACITY_MAX);
    })
  }

  private backRightMotionFinish(): void {
    log.showInfo('backRightMotionFinish');
    localEventManager.sendLocalEvent(EventConstants.EVENT_VM_SWITCH_TO_DESKTOP_CALLBACK);
    this.updateVmSnapshotRadius(RADIUS_MIN);
    this.updateVmSnapshotScale(SCALE_MIN);
    this.updateVmSnapshotOpacity(OPACITY_MAX);
    this.updateSwitching(false);
    this.updateMotionWindowVisible(false);
    if (this.memoryRelease) {
      this.memoryReleaseEnd();
    }
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_FINISH_TO_HM);
    Trace.end(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_ANIMATION);
    performanceMonitor.end('SWITCH_DESKTOP');
    this.setPointerVisible(true);
    this.canInterrupt = true;
    HiSysEventUtil.reportSwitchingDesktopEvent(FOUR_FINGER_SWIPE_RIGHT, this.getTime());
    if (DesktopSwitchController.getInstance().getVmSceneContainerSession()?.isForeground()) {
      log.showError('Vm session is foreground, adjust state as in Vm');
      this.resetVmDesktopState();
    } else {
      this.releaseHarmonySnapshot();
    }
  }

  public quickBackLeftSwipeMotion(): void {
    this.setPointerVisible(false);
    this.updateSwitching(true);
    this.initHarmonySnapshotDesktop();
    this.snapshotBlur(false);
    performanceMonitor.begin('SWITCH_DESKTOP', performanceMonitor.ActionType.FIRST_MOVE, 'SWITCH_DESKTOP');
    Trace.start(Trace.CORE_METHOD_DESKTOP_SWITCH_LEFT);
    this.updateMotionWindowVisible(true);
    this.quickBackLeftSwipeMotionBuild();
    SCBSceneSessionManager.getInstance()
      .startSceneFromRecent(this.motionScreenId,
        DesktopSwitchController
          .getInstance()
          .getVmSceneContainerSession()
        ?.getPersistentId());
    animateToImmediately({
      delay: 150,
      curve: Curves.springMotion(0.45, 0.8),
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.updateVmSnapshotRadius(RADIUS_MIN);
      this.updateVmSnapshotScale(SCALE_MAX);
    })
  }

  public quickBackLeftMotionSnapshot(): void {
    log.showInfo('quick back left motion snapshot');
    if (!this.onFourFingerMotionBegin()) {
      log.showInfo('App Center, Task Center, or Split-screen mode prohibit four-finger swipes');
      this.onFourFingerMotionEnd();
      return;
    }
    if (!this.switchToVM()) {
      return;
    }
    this.canInterrupt = false;
    this.updateSwitching(true);
    this.quickMotionDesktopSnapshot(false);
  }

  public quickBackRightMotionSnapshot(): void {
    log.showInfo('quick back right motion snapshot');
    if (!this.switchToHarmony()) {
      return;
    }
    this.canInterrupt = false;
    this.updateSwitching(true);
    this.quickMotionDesktopSnapshot(true);
  }

  public quickBackRightSwipeMotion(): void {
    this.setPointerVisible(false);
    this.initVmDesktop();
    this.snapshotBlur(true);
    performanceMonitor.begin('SWITCH_DESKTOP', performanceMonitor.ActionType.FIRST_MOVE, 'SWITCH_DESKTOP');
    Trace.start(Trace.CORE_METHOD_DESKTOP_SWITCH_RIGHT);
    this.updateMotionWindowVisible(true);
    this.quickBackRightSwipeMotionBuild();
    DesktopSwitchController.getInstance().minimizeVmWindow();
    animateToImmediately({
      delay: 150,
      curve: Curves.springMotion(0.45, 0.8),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.updateVmSnapshotRadius(RADIUS_MIN);
        this.updateVmSnapshotScale(SCALE_MIN);
      }
    }, () => {
      this.updateHarmonySnapshotRadius(RADIUS_MIN);
      this.updateHarmonySnapshotScale(SCALE_MAX);
    })
  }

  public quickBackLeftSwipeMotionBuild(): void {
    this.updateVmSnapshotScale(SCALE_MIN);
    animateToImmediately({
      curve: Curves.springMotion(),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.updateVmSnapshotRadius(RADIUS_MAX);
      }
    }, () => {
      this.updateHarmonySnapshotScale(SCALE_MIDDLE);
      this.updateHarmonySnapshotRadius(RADIUS_MAX);
    })
    animateToImmediately({
      finishCallbackType: FinishCallbackType.LOGICALLY,
      delay: 150,
      curve: Curves.springMotion(0.45, 0.8),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.setVmDesktop(true);
        if (this.isVmSnapshotFoldState === SnapshotFoldState.FOLD) {
          this.blurringVmAnimation(ToggleMotionType.QUICK_SWIPE);
        } else if (this.isVmSnapshotFoldState === SnapshotFoldState.EXPAND) {
          this.blurringVmAnimation(ToggleMotionType.QUICK_SWIPE);
        } else {
          this.quickBackLeftMotionFinish();
        }
      }
    }, () => {
      this.updateVmSnapshotX(PLACE_START);
      this.updateVmSnapshotRotate(ROTATE_ANGLE_MIN);
      this.updateVmSnapshotScale(SCALE_MIDDLE);
      this.updateHarmonySnapshotX(-this.screenWidth);
      this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MAX);
      this.updateHarmonySnapshotOpacity(OPACITY_MIN);
      this.updateHarmonySnapshotScale(SCALE_MIN);
    })
  }

  public quickBackLeftMotionFinish(): void {
    log.showInfo('quickBackLeftMotionFinish');
    DesktopSwitchController.getInstance().vmTopmost();
    ViewManagerPolicy.hideView(ViewType.APP_CENTER);
    AppStorage.setOrCreate('openAppCenterPageIndex', 0);
    this.updateHarmonySnapshotRadius(RADIUS_MIN);
    this.dropSnapshot = false;
    this.canInterrupt = true;
    this.updateHarmonySnapshotScale(SCALE_MIN);
    this.updateHarmonySnapshotOpacity(OPACITY_MAX);
    if (this.memoryRelease) {
      log.showInfo('Memory release does not exit the dynamic effect');
      this.memoryReleasing();
    } else {
      this.updateSwitching(false);
      this.updateMotionWindowVisible(false);
    }
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_FINISH_TO_VM);
    Trace.end(Trace.CORE_METHOD_DESKTOP_SWITCH_LEFT);
    performanceMonitor.end('SWITCH_DESKTOP');
    this.setPointerVisible(true);
    this.releaseVmSnapshot();
    if (!DesktopSwitchController.getInstance().hasVmAbility()) {
      DesktopSwitchController.getInstance().closeVmAbility();
    }
  }

  public quickBackRightSwipeMotionBuild(): void {
    this.updateHarmonySnapshotScale(SCALE_MIN);
    animateToImmediately({
      curve: Curves.springMotion(),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.updateHarmonySnapshotRadius(RADIUS_MAX);
      }
    }, () => {
      this.updateVmSnapshotScale(SCALE_MIDDLE);
      this.updateVmSnapshotRadius(RADIUS_MAX);
    })
    animateToImmediately({
      finishCallbackType: FinishCallbackType.LOGICALLY,
      delay: 150,
      curve: Curves.springMotion(0.45, 0.8),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.setVmDesktop(false);
        if (this.isHarmonySnapshotFoldState === SnapshotFoldState.FOLD) {
          this.blurringHarmonyAnimation(ToggleMotionType.QUICK_SWIPE);
        } else if (this.isHarmonySnapshotFoldState === SnapshotFoldState.EXPAND) {
          this.blurringHarmonyAnimation(ToggleMotionType.QUICK_SWIPE);
        } else {
          this.quickBackRightMotionFinish();
        }
      }
    }, () => {
      this.updateVmSnapshotX(this.screenWidth);
      this.updateVmSnapshotRotate(-ROTATE_ANGLE_MAX);
      this.updateVmSnapshotOpacity(OPACITY_MIN);
      this.updateVmSnapshotScale(SCALE_MIN);
      this.updateHarmonySnapshotX(PLACE_START);
      this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MIN);
      this.updateHarmonySnapshotScale(SCALE_MIDDLE);
    })
  }

  private quickBackRightMotionFinish(): void {
    log.showInfo('quickBackRightMotionFinish');
    localEventManager.sendLocalEvent(EventConstants.EVENT_VM_SWITCH_TO_DESKTOP_CALLBACK);
    this.updateVmSnapshotRadius(RADIUS_MIN);
    this.updateVmSnapshotScale(SCALE_MIN);
    this.dropSnapshot = false;
    this.canInterrupt = true;
    this.updateVmSnapshotOpacity(OPACITY_MAX);
    this.updateSwitching(false);
    this.updateMotionWindowVisible(false);
    if (this.memoryRelease) {
      this.memoryReleaseEnd();
    }
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_FINISH_TO_HM);
    Trace.end(Trace.CORE_METHOD_DESKTOP_SWITCH_RIGHT);
    performanceMonitor.end('SWITCH_DESKTOP');
    this.setPointerVisible(true);
    if (DesktopSwitchController.getInstance().getVmSceneContainerSession()?.isForeground()) {
      log.showError('Vm session is foreground, adjust state as in Vm');
      this.resetVmDesktopState();
    } else {
      this.releaseHarmonySnapshot();
    }
  }

  private backLeftMotion(distance: number): void {
    log.showInfo('backLeftMotion');
    if (this.followFingerBackLeftMotion()) {
      return;
    }
    SCBSceneSessionManager.getInstance()
      .startSceneFromRecent(this.motionScreenId,
        DesktopSwitchController
          .getInstance()
          .getVmSceneContainerSession()
        ?.getPersistentId());
    animateToImmediately({
      finishCallbackType: FinishCallbackType.LOGICALLY,
      duration: 800,
      curve: Curves.springMotion(0.45, 0.8),
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.setVmDesktop(true);
        if (this.isVmSnapshotFoldState === SnapshotFoldState.FOLD) {
          this.blurringVmAnimation(ToggleMotionType.FOLLOW_HAND);
        } else if (this.isVmSnapshotFoldState === SnapshotFoldState.EXPAND) {
          this.blurringVmAnimation(ToggleMotionType.FOLLOW_HAND);
        } else {
          this.backLeftMotionFinish();
        }
      }
    }, () => {
      this.updateVmSnapshotX(PLACE_START);
      this.updateVmSnapshotRotate(ROTATE_ANGLE_MIN);
      this.updateVmSnapshotScale(SCALE_MIDDLE);
      this.updateHarmonySnapshotX(-this.screenWidth);
      this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MAX);
      this.updateHarmonySnapshotOpacity(OPACITY_MIN);
      this.updateHarmonySnapshotScale(SCALE_MIN);
    })
    animateToImmediately({
      duration: 800,
      curve: Curves.springMotion(0.45, 0.8),
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.updateVmSnapshotScale(SCALE_MAX);
      this.updateVmSnapshotOpacity(OPACITY_MAX);
    })
  }

  private backLeftMotionFinish(): void {
    log.showInfo('backLeftMotionFinish');
    ViewManagerPolicy.hideView(ViewType.APP_CENTER);
    AppStorage.setOrCreate('openAppCenterPageIndex', 0);
    DesktopSwitchController.getInstance().vmTopmost();
    this.updateHarmonySnapshotOpacity(OPACITY_MAX);
    this.canInterrupt = true;
    if (this.memoryRelease) {
      log.showInfo('Memory release does not exit the dynamic effect');
      this.memoryReleasing();
    } else {
      this.updateSwitching(false);
      this.updateMotionWindowVisible(false);
    }
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.HG_FINISH_TO_VM);
    Trace.end(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_ANIMATION);
    performanceMonitor.end('SWITCH_DESKTOP');
    this.setPointerVisible(true);
    this.releaseVmSnapshot();
    HiSysEventUtil.reportSwitchingDesktopEvent(FOUR_FINGER_SWIPE_LEFT, this.getTime());
    if (!DesktopSwitchController.getInstance().hasVmAbility()) {
      DesktopSwitchController.getInstance().closeVmAbility();
    }
  }

  private getTime(): number {
    try {
      let time: number = systemDateTime.getTime(false);
      return time;
    } catch (error) {
      log.showError(`systemDateTime.getTime failed: ${error?.message}`);
      return 0;
    }
  }

  private getRotation(): OrientationAngle {
    log.showInfo('getRotation');
    try {
      let orientation = display.getDefaultDisplaySync().orientation;
      switch (orientation) {
        case display.Orientation.PORTRAIT:
          log.showInfo('device rotation state is portrait');
          return OrientationAngle.PORTRAIT;
        case display.Orientation.LANDSCAPE:
          log.showInfo('device rotation state is landscape');
          return OrientationAngle.LANDSCAPE
        case display.Orientation.PORTRAIT_INVERTED:
          log.showInfo('device rotation state is portrait inverted');
          return OrientationAngle.PORTRAIT_INVERTED
        case display.Orientation.LANDSCAPE_INVERTED:
          log.showInfo('device rotation state is landscape inverted');
          return OrientationAngle.LANDSCAPE_INVERTED
        default:
          log.showWarn('device rotation state is unknown, Default is landscape mode');
          return OrientationAngle.LANDSCAPE_INVERTED
      }
    } catch (error) {
      log.showError(`display getRotation failed: ${error?.message}`);
      return OrientationAngle.LANDSCAPE_INVERTED
    }
  }

  private closeVirtualKeyboardFloatingWindow(): void {
    log.showInfo('closeVirtualKeyboardFloatingWindow');
    if ((this.getRotation() === OrientationAngle.LANDSCAPE ||
      this.getRotation() === OrientationAngle.LANDSCAPE_INVERTED)) {
      this.setVirtualKeyboard(false);
    }
  }

  public oneTimeLeftSwipeMotionSnapshot(): void {
    log.showInfo('oneTimeLeftSwipeMotion, HOSTtoVM');
    if (!this.canSwitch()) {
      return;
    }
    if (!this.switchToVM()) {
      return;
    }
    if (!this.checkQXSSwitch()) {
      this.sendToast();
      return;
    }
    if (!this.checkFoldAndOrientation()) {
      log.showInfo('The VM cannot be switched');
      DesktopSwitchController.getInstance().publishCommonEvent();
      return;
    }
    if (!this.onFourFingerMotionBegin()) {
      this.onFourFingerMotionEnd();
      log.showInfo('left animate start-up does not meet the conditions');
      return;
    }
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    DesktopSwitchController.getInstance().onVmDesktopHide();
    this.canInterrupt = false;
    this.updateSwitching(true);
    this.updateSnapshot(false);
  }

  public startVmMotionSnapshot(): void {
    log.showInfo('start vm motion snapshot');
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    this.onFourFingerMotionEnd();
    if (this.isLock) {
      log.showError('The current screen is not unlocked');
      return;
    }
    if (!this.switchToVM()) {
      return;
    }
    this.closeVirtualKeyboardFloatingWindow();
    viewMgrPolicy.hideView(ViewType.SHORTCUT_KEY_PANEL);
    this.checkMemorySwitch();
    if (DesktopSwitchController.getInstance().getRecentClosed()) {
      log.showInfo('start vm from closed');
      this.startFromClosed();
    } else {
      log.showInfo('resume vm from sleeping');
      this.startFromSleeping();
    }
  }

  private sessionDisplayChange = (reason: SessionDisplayChangeReason, sessionChangeInfo: SessionChangeInfo) => {
    log.showInfo(`sessionDisplayChange reason: ${reason}, persistentIds len:${sessionChangeInfo.persistentIds.length}` +
      `, curScreenId:${sessionChangeInfo.curScreenId}, target screenId: ${sessionChangeInfo.targetScreenId}`);
    this.setMotionScreenId(sessionChangeInfo.targetScreenId);
    this.swipeCallbacks.find((swipeCallback) => {
      log.showInfo(`switch screen swipeCallback screen id: ${swipeCallback?.getMotionScreenId()}`);
      if (swipeCallback?.getMotionScreenId() === this.motionScreenId) {
        this.swipeCallback = swipeCallback;
        this.vmSnapshot();
        this.harmonyScreenshot();
        this.updateShowPrefabrication(false);
        this.updateScreenSize();
        this.updateWindowSize(vp2px(this.screenWidth), vp2px(this.screenHeight));
      }
    });
  }

  private updateScreenSize(): void {
    if (this.motionScreenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      this.setScreenWidth(px2vp(SCBScreenSessionManager.getInstance()
        .getMainScreenSession()?.scbScreenProperty.width));
      this.setScreenHeight(px2vp(SCBScreenSessionManager.getInstance()
        .getMainScreenSession()?.scbScreenProperty.height));
    } else {
      this.setScreenWidth(px2vp(SCBScreenSessionManager.getInstance()
        .getExtendScreenSession()?.scbScreenProperty.width));
      this.setScreenHeight(px2vp(SCBScreenSessionManager.getInstance()
        .getExtendScreenSession()?.scbScreenProperty.height));
    }
  }

  private startFromClosed(): void {
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    this.setMotionScreenId(DesktopSwitchController.getInstance().getVmSceneInfo()?.screenId);
    this.swipeCallbacks.find((swipeCallback) => {
      if (swipeCallback?.getMotionScreenId() === DesktopSwitchController.getInstance().getVmSceneInfo()?.screenId) {
        log.showInfo(`strat vm swipeCallback screen id: ${swipeCallback?.getMotionScreenId()}`);
        this.swipeCallback = swipeCallback;
      }
    });
    FourFingerSwipeController.getInstance().registerTabletSwitchStateChange();
    this.releaseVmSnapshot();
    DesktopSwitchController.getInstance().onVmDesktopHide();
    this.canInterrupt = false;
    this.updateSwitching(true);
    this.updateSnapshot(false);
    DesktopSwitchController.getInstance().setRecentClosed(false);
    DesktopSwitchController
      .getInstance()
      .getVmSceneContainerSession()
    ?.primarySession
    ?.registerSessionDisplayChangeCallback(this.sessionDisplayChange);
  }

  private startFromSleeping(): void {
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    DesktopSwitchController.getInstance().onVmDesktopHide();
    this.canInterrupt = false;
    this.updateSwitching(true);
    this.updateSnapshot(false);
  }

  public oneTimeLeftSwipeMotion(): void {
    log.showInfo('oneTimeLeftSwipeMotion begin');
    this.setPointerVisible(false);
    this.updateSwitching(true);
    this.snapshotBlur(false);
    performanceMonitor.begin('SWITCH_DESKTOP', performanceMonitor.ActionType.FIRST_MOVE, 'SWITCH_DESKTOP');
    Trace.start(Trace.CORE_METHOD_DESKTOP_SWITCH_LEFT);
    this.updateMotionWindowVisible(true);
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.SHORTCUT_TO_VM_START);
    DesktopSwitchController.getInstance().onVmDesktopShow();
    DesktopSwitchController.getInstance().vmTopmost();
    this.initHarmonySnapshotDesktop();
    this.oneTimeLeftSwipeMotionBuild();
    SCBSceneSessionManager.getInstance()
      .startSceneFromRecent(this.motionScreenId,
        DesktopSwitchController
          .getInstance()
          .getVmSceneContainerSession()
        ?.getPersistentId());
    animateToImmediately({
      delay: 150,
      curve: Curves.springMotion(),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.setVmDesktop(true);
        if (this.isVmSnapshotFoldState === SnapshotFoldState.FOLD) {
          this.blurringVmAnimation(ToggleMotionType.ONE_TIME);
        } else if (this.isVmSnapshotFoldState === SnapshotFoldState.EXPAND) {
          this.blurringVmAnimation(ToggleMotionType.ONE_TIME);
        } else {
          this.oneTimeLeftMotionFinish();
        }
      }
    }, () => {
      this.updateVmSnapshotScale(SCALE_MAX);
    })
  }

  public oneTimeLeftMotionFinish(): void {
    log.showInfo('oneTimeLeftMotionFinish');
    DesktopSwitchController.getInstance().vmTopmost();
    ViewManagerPolicy.hideView(ViewType.APP_CENTER);
    AppStorage.setOrCreate('openAppCenterPageIndex', 0);
    this.updateHarmonySnapshotRadius(RADIUS_MIN);
    this.canInterrupt = true;
    this.updateHarmonySnapshotScale(SCALE_MIN);
    this.updateHarmonySnapshotOpacity(OPACITY_MAX);
    if (this.memoryRelease) {
      log.showInfo('Memory release does not exit the dynamic effect');
      this.memoryReleasing();
    } else {
      this.updateSwitching(false);
      this.updateMotionWindowVisible(false);
    }
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.SHORTCUT_TO_VM_END);
    Trace.end(Trace.CORE_METHOD_DESKTOP_SWITCH_LEFT);
    performanceMonitor.end('SWITCH_DESKTOP');
    this.setPointerVisible(true);
    this.releaseVmSnapshot();
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    if (!DesktopSwitchController.getInstance().hasVmAbility()) {
      DesktopSwitchController.getInstance().closeVmAbility();
    }
  }

  public oneTimeRightSwipeMotionSnapshot(fold: boolean = false): void {
    log.showInfo('oneTimeRightSwipeMotion, VMtoHOST');
    if (this.isLock) {
      log.showInfo('The current screen is not unlocked');
      return;
    }
    if (!this.checkFoldAndOrientation() && !this.getVmDesktop()) {
      log.showInfo('The VM cannot be switched');
      DesktopSwitchController.getInstance().publishCommonEvent();
      return;
    }
    if (!this.switchToHarmony()) {
      return;
    }
    let showRecent = AppStorage.get('showRecent') as boolean;
    if (showRecent) {
      this.onFourFingerMotionEnd();
      log.showInfo('right animate start-up does not meet the conditions');
      return;
    }
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    this.canInterrupt = false;
    this.updateSwitching(true);
    this.updateSnapshot(true);
  }

  public oneTimeRightSwipeMotion(): void {
    this.setPointerVisible(false);
    this.snapshotBlur(true);
    performanceMonitor.begin('SWITCH_DESKTOP', performanceMonitor.ActionType.FIRST_MOVE, 'SWITCH_DESKTOP');
    Trace.start(Trace.CORE_METHOD_DESKTOP_SWITCH_RIGHT);
    this.updateMotionWindowVisible(true);
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.SHORTCUT_TO_HM_START);
    this.initVmDesktop();
    this.oneTimeRightSwipeMotionBuild();
    DesktopSwitchController.getInstance().minimizeVmWindow();
    animateToImmediately({
      delay: 150,
      curve: Curves.springMotion(),
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.setVmDesktop(false);
        if (this.isHarmonySnapshotFoldState === SnapshotFoldState.FOLD) {
          this.blurringHarmonyAnimation(ToggleMotionType.ONE_TIME);
        } else if (this.isHarmonySnapshotFoldState === SnapshotFoldState.EXPAND) {
          this.blurringHarmonyAnimation(ToggleMotionType.ONE_TIME);
        } else {
          this.oneTimeRightSwipeMotionFinish();
        }
      }
    }, () => {
      this.updateHarmonySnapshotScale(SCALE_MAX);
    })
  }

  private oneTimeRightSwipeMotionFinish(): void {
    localEventManager.sendLocalEvent(EventConstants.EVENT_VM_SWITCH_TO_DESKTOP_CALLBACK);
    this.updateVmSnapshotRadius(RADIUS_MIN);
    this.updateVmSnapshotScale(SCALE_MIN);
    this.canInterrupt = true;
    this.updateVmSnapshotOpacity(OPACITY_MAX);
    this.updateSwitching(false);
    if (this.memoryRelease) {
      this.memoryReleaseEnd();
      this.startLowMemoryAbility();
    }
    this.updateMotionWindowVisible(false);
    // this.updateVmSwitchAnimationPhase(virtualization.AnimationPhase.SHORTCUT_TO_HM_END);
    Trace.end(Trace.CORE_METHOD_DESKTOP_SWITCH_RIGHT);
    performanceMonitor.end('SWITCH_DESKTOP');
    this.setPointerVisible(true);
    this.releaseHarmonySnapshot();
    if (this.isVmSnapshotFoldState !== SnapshotFoldState.FOLD && this.physicalKeyboard) {
      log.showInfo('Vm to Host, Reason: keyboard mount');
    }
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
  }

  public oneTimeLeftSwipeMotionBuild(): void {
    this.updateVmSnapshotScale(SCALE_MIN);
    animateToImmediately({
      curve: Curve.Friction,
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.updateHarmonySnapshotScale(SCALE_MIDDLE);
      this.updateHarmonySnapshotRadius(RADIUS_MAX);
      this.updateVmSnapshotRadius(RADIUS_MAX);
    })
    animateToImmediately({
      delay: 150,
      curve: Curves.springMotion(),
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.updateVmSnapshotX(PLACE_START);
      this.updateVmSnapshotRotate(ROTATE_ANGLE_MIN);
      this.updateVmSnapshotScale(SCALE_MIDDLE);
      this.updateHarmonySnapshotX(-this.screenWidth);
      this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MAX);
      this.updateHarmonySnapshotOpacity(OPACITY_MIN);
      this.updateHarmonySnapshotScale(SCALE_MIN);
    })
  }

  private getSnapshot(isVm: boolean) {
    log.showInfo('getSnapshot');
    if (this.disableSnapshot) {
      log.showInfo('disable snapshot');
      return;
    }
    Trace.start(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT);
    this.dropSnapshot = false;
    this.gettingSnapshot = true;
    if (isVm) {
      this.getVmSnapshot();
    } else {
      this.getHarmonyScreenshot();
    }
  }

  private async vmSnapshot(): Promise<void> {
    log.showInfo('get vm snapshot');
    let persistentId = DesktopSwitchController.getInstance().getVmPersistentId();
    await sceneSessionManager.getSessionSnapshotPixelMap(persistentId, 1).then((result: image.PixelMap) => {
      log.showInfo('get vm snapshot end');
      if (result) {
        PixelMapUtil.addName(result, VM_SNAPSHOT_PIXEL_MAP_NAME);
        this.updateVmSnapshot(result);
      } else {
        log.showWarn('vm imagePixelMap is null');
      }
    }).catch((err: BusinessError) => {
      log.showWarn('getVmSnapshot failed');
      this.resetOnScreenshotError(err);
    });
  }

  private harmonyScreenshot(): void {
    log.showInfo(`get Harmony screenshot, screenId: ${this.motionScreenId}`);
    let screenshotOptions: screenshot.ScreenshotOptions = {
      'rotation': 0,
      'displayId': this.motionScreenId
    };
    screenshot.save(screenshotOptions, (err: BusinessError, pixelMap) => {
      log.showInfo('get harmony screenshot end');
      if (err) {
        log.showError('get harmony screenshot error');
        this.resetOnScreenshotError(err);
        return;
      }
      PixelMapUtil.addName(pixelMap, HARMONY_SNAPSHOT_PIXEL_MAP_NAME);
      this.updateHarmonySnapshot(pixelMap);
    });
  }

  private async getVmSnapshot(quickMotion: boolean = false): Promise<void> {
    log.showInfo('get vm snapshot');
    if (quickMotion) {
      if (this.gettingSnapshot) {
        log.showInfo('quick motion , still gettingSnapshot, set flag.');
        this.quickMotionFlag = true;
      } else {
        log.showInfo('quick motion, is not gettingSnapshot');
        this.quickBackRightSwipeMotion();
        this.updateSwitching(true);
      }
      return;
    }
    let persistentId = DesktopSwitchController.getInstance().getVmPersistentId();
    await sceneSessionManager.getSessionSnapshotPixelMap(persistentId, 1).then((result: image.PixelMap) => {
      Trace.end(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT);
      log.showInfo('get vm snapshot end');
      if (result) {
        this.gettingSnapshot = false;
        PixelMapUtil.addName(result, VM_SNAPSHOT_PIXEL_MAP_NAME);
        this.updateVmSnapshot(result);
        if (this.quickMotionFlag) {
          this.quickBackRightSwipeMotion();
          this.quickMotionFlag = false;
        }
        if (!this.dropSnapshot) {
          this.initVmDesktop();
        }
        this.updateSwitching(true);
      } else {
        log.showWarn('vm imagePixelMap is null');
      }
    }).catch((err: BusinessError) => {
      log.showWarn('getVmSnapshot failed');
      this.resetOnScreenshotError(err);
    });
  }

  private getHarmonyScreenshot(quickMotion: boolean = false): void {
    log.showInfo(`get Harmony screenshot, screenId: ${this.motionScreenId}`);
    if (quickMotion) {
      if (this.gettingSnapshot) {
        log.showInfo('quick motion, still gettingSnapshot, set flag.');
        this.quickMotionFlag = true;
      } else {
        log.showInfo('quick motion, is not gettingSnapshot');
        this.quickBackLeftSwipeMotion();
        this.updateSwitching(true);
      }
      return;
    }
    let screenshotOptions: screenshot.ScreenshotOptions = {
      'rotation': 0,
      'displayId': this.motionScreenId
    };
    screenshot.save(screenshotOptions, (err: BusinessError, pixelMap) => {
      Trace.end(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT);
      log.showInfo('get harmony screenshot end');
      if (err) {
        log.showError('get harmony screenshot error');
        this.resetOnScreenshotError(err);
        return;
      }
      this.gettingSnapshot = false;
      PixelMapUtil.addName(pixelMap, HARMONY_SNAPSHOT_PIXEL_MAP_NAME);
      this.updateHarmonySnapshot(pixelMap);
      if (this.quickMotionFlag) {
        this.quickBackLeftSwipeMotion();
        this.quickMotionFlag = false;
      }
      if (!this.dropSnapshot) {
        this.initHarmonySnapshotDesktop();
      }
      this.updateSwitching(true);
    })
  }

  public oneTimeRightSwipeMotionBuild(): void {
    this.updateHarmonySnapshotScale(SCALE_MIN);
    animateToImmediately({
      curve: Curve.Friction,
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.updateVmSnapshotScale(SCALE_MIDDLE);
      this.updateVmSnapshotRadius(RADIUS_MAX);
      this.updateHarmonySnapshotRadius(RADIUS_MAX);
    })
    animateToImmediately({
      delay: 150,
      curve: Curves.springMotion(),
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.updateVmSnapshotX(this.screenWidth);
      this.updateVmSnapshotRotate(-ROTATE_ANGLE_MAX);
      this.updateVmSnapshotOpacity(OPACITY_MIN);
      this.updateVmSnapshotScale(SCALE_MIN);
      this.updateHarmonySnapshotX(PLACE_START);
      this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MIN);
      this.updateHarmonySnapshotScale(SCALE_MIDDLE);
    })
  }

  private reportVmUsingTime(): void {
    if (this.lastUseVmTime === 0) {
      log.showInfo('ignore reportVmUsingTime lastUseVmTime 0');
      return;
    }
    if (this.isLock) {
      log.showInfo(`recentVmState is ${this.recentVmState}, but is lock, not to report.`);
      return;
    }
    if (this.recentVmState === VmState.NONE || this.recentVmState === VmState.NOT_VM) {
      log.showInfo(`recentVmState is not VM: ${this.recentVmState}, not to report`);
      return;
    }
    let curTime = this.getTime();
    let duration = curTime - this.lastUseVmTime;
    // 时间数据 结构为[使用时长、终点时刻、起点时刻]
    let timeData: number[] = [duration, curTime, this.lastUseVmTime];
    log.showInfo(`reportVmUsingTime, switchingType: ${this.recentVmState}, duration: ${duration}, ` +
      `curTime: ${curTime}, lastUseVmTime: ${this.lastUseVmTime}`);
    HiSysEventUtil.reportVmUsingTimeEvent(this.recentVmState, timeData);
    this.lastUseVmTime = this.getTime();
  }

  /**
   * 锁屏解锁事件订阅
   */
  private screenLockStateListener: ScreenLockStateListener = {
    onEnterHost: () => {
      log.showInfo('screen lock is Locked');
      if (!this.isQXSDevice) {
        return;
      }
      this.screenLock();
      this.isLock = true;
      this.locked = true;
    },
    onExitKeyguard: () => {
      log.showInfo('screen lock is Unlocked');
      if (!this.isQXSDevice) {
        return;
      }
      this.isLock = false;
      this.screenUnlock();
      this.locked = false;
    },
    onTransitionStart: (state: ScreenLockTransitionState) => {
      log.showInfo('screen lock onTransitionStart');
      if (this.isQXSDevice) {
        return;
      }
      if (state === ScreenLockTransitionState.LOCK) {
        this.screenLock();
        this.isLock = true;
        this.locked = true;
      } else {
        this.isLock = false;
        this.screenUnlock();
        this.locked = false;
      }
    }
  }

  private screenLock(): void {
    log.showInfo('screenLock');
    if (DesktopSwitchController.getInstance().isVmDesktop()) {
      this.reportVmUsingTime();
    }
  }

  private screenUnlock(): void {
    log.showInfo('screenUnlock');
    this.lastUseVmTime = this.getTime();
    if (this.memoryRelease) {
      if (!this.memoryCheck()) {
        this.oneTimeRightSwipeMotionSnapshot();
      } else {
        this.updateMotionWindowVisible(false);
        this.memoryReleaseEnd();
      }
    }
    if (this.isShow) {
      this.undoSwitch();
    }
  }

  public unRegisterScreenLockState(): void {
    log.showInfo('unRegisterScreenLockState');
    screenLockStateManager.unregisterScreenLockState(this.screenLockStateListener);
    AccountHelper.getInstance().unRegisterUserSwitchListener('switching', this.onSwitchingUser);
  }

  private initHarmonySnapshotDesktop(): void {
    log.showInfo('initHarmonySnapshotDesktop');
    this.setVmDesktop(false);

    this.updateHarmonySnapshotX(PLACE_START);
    this.updateHarmonySnapshotScale(SCALE_MAX);
    this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MIN);
    this.updateHarmonySnapshotOpacity(OPACITY_MAX);
    this.updateHarmonySnapshotRadius(RADIUS_MAX);

    this.updateVmSnapshotX(this.screenWidth);
    this.updateVmSnapshotScale(SCALE_INIT);
    this.updateVmSnapshotRotate(-ROTATE_ANGLE_MAX);
    this.updateVmSnapshotOpacity(OPACITY_MAX);
    this.updateVmSnapshotRadius(RADIUS_MAX);
  }

  private initVmDesktop(): void {
    log.showInfo('initVmDesktop');
    this.setVmDesktop(true);

    this.updateHarmonySnapshotX(-this.screenWidth);
    this.updateHarmonySnapshotScale(SCALE_INIT);
    this.updateHarmonySnapshotRotate(ROTATE_ANGLE_MAX);
    this.updateHarmonySnapshotOpacity(OPACITY_MAX);
    this.updateHarmonySnapshotRadius(RADIUS_MAX);

    this.updateVmSnapshotX(PLACE_START);
    this.updateVmSnapshotScale(SCALE_MAX);
    this.updateVmSnapshotRotate(ROTATE_ANGLE_MIN);
    this.updateVmSnapshotOpacity(OPACITY_MAX);
    this.updateVmSnapshotRadius(RADIUS_MAX);
  }

  private quickMotionDesktopSnapshot(isVmDesktop: boolean) {
    log.showInfo('quick motion desktop snapshot');
    if (isVmDesktop) {
      this.getVmSnapshot(true);
    } else {
      this.getHarmonyScreenshot(true);
    }
  }

  private updateSnapshot(isVm: boolean) {
    log.showInfo('updateSnapshot');
    if (this.disableSnapshot) {
      log.showInfo('disable snapshot');
      this.disableSnapshot = false;
      this.isShow = false;
      if (isVm) {
        this.oneTimeRightSwipeMotion();
      } else {
        this.updateSettingsData(true);
        this.oneTimeLeftSwipeMotion();
      }
      return;
    }
    Trace.start(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT);
    if (isVm) {
      this.getVmSnapshotOneTimeEffect();
    } else {
      this.updateHarmonyScreenshot();
    }
  }

  private async getVmSnapshotOneTimeEffect(): Promise<void> {
    log.showInfo('get vm snapshot one time effect');
    let persistentId = DesktopSwitchController.getInstance().getVmPersistentId();
    await sceneSessionManager.getSessionSnapshotPixelMap(persistentId, 1).then((result: image.PixelMap) => {
      Trace.end(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT);
      log.showInfo('get vm snapshot one time effect end');
      if (result) {
        PixelMapUtil.addName(result, VM_SNAPSHOT_PIXEL_MAP_NAME);
        this.updateVmSnapshot(result);
        this.oneTimeRightSwipeMotion();
      } else {
        log.showWarn('vm imagePixelMap is null');
      }
    }).catch((err: BusinessError) => {
      log.showWarn('get vm snapshot one time effect failed');
      this.resetOnScreenshotError(err);
    });
  }

  private updateHarmonyScreenshot() {
    log.showInfo(`update Harmony screenshot, screenId: ${this.motionScreenId}`);
    let screenshotOptions: screenshot.ScreenshotOptions = {
      'rotation': 0,
      'displayId': this.motionScreenId
    };
    screenshot.save(screenshotOptions, (err: BusinessError, pixelMap) => {
      Trace.end(Trace.CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT);
      log.showInfo('update Harmony screenshot end');
      if (err) {
        log.showError('updateSnapshot screenshot save error.');
        this.resetOnScreenshotError(err);
        return;
      }
      PixelMapUtil.addName(pixelMap, HARMONY_SNAPSHOT_PIXEL_MAP_NAME);
      this.updateHarmonySnapshot(pixelMap);
      this.updateSettingsData(true);
      this.oneTimeLeftSwipeMotion();
    })
  }

  private updateSettingsData(enterVm: boolean): void {
    log.showInfo(`updateSettingsData enterVm: ${enterVm}`);
    if (enterVm) {
      settingsDataManager.setValue(null, 'enable_combine_key', 'false');
      return;
    }
    settingsDataManager.setValue(null, 'enable_combine_key', 'true');
  }

  private resetOnScreenshotError(err: BusinessError): void {
    this.gettingSnapshot = false;
    log.showError(`resetOnScreenshotError err=${err?.message}`);
    HiDfxEventUtil.reportGetSnapshotFailed(err?.message, this.getTime());
    this.canInterrupt = true;
    this.updateMotionWindowVisible(false);
    this.setPointerVisible(true);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    this.reset();
    this.isSwipe = false;
    this.isShow = false;
    this.originalPosition = null;
    this.disableSnapshot = false;
    this.dropSnapshot = true;
    this.quickMotionFlag = false;
  }

  private resetParameter(): void {
    log.showInfo('resetParameter');
    this.gettingSnapshot = false;
    this.canInterrupt = true;
    this.updateMotionWindowVisible(false);
    this.setPointerVisible(true);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    this.reset();
    this.isSwipe = false;
    this.isShow = false;
    this.originalPosition = null;
    this.disableSnapshot = false;
    this.dropSnapshot = true;
    this.canSwipeUpdate = true;
    this.quickMotionFlag = false;
  }

  public setSwipeStateCallback(callback: FourFingerMotionStateCallback | null): void {
    this.swipeStateCallback = callback;
  }

  public registerSwipeCallback(callback: FourFingerMotionCallback | null): void {
    if (callback) {
      this.swipeCallbacks.push(callback);
      log.showInfo(`registerSwipeCallback screenId: ${callback.getMotionScreenId()}`)
    }
  }

  public unRegisterSwipeCallback(callback: FourFingerMotionCallback | null): void {
    const index = this.swipeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.swipeCallbacks.splice(index, 1);
      log.showInfo(`unRegisterSwipeCallback screenId: ${callback?.getMotionScreenId()}`)
    }
  }

  public getHasVm(): boolean {
    return DesktopSwitchController.getInstance().hasVmAbility();
  }

  public getInterrupt(): boolean {
    return this.canInterrupt;
  }

  public setVmDesktop(isVm: boolean): void {
    log.showInfo(`setVmDesktop: ${isVm} current: ${this.vmDesktop}`);
    if (this.vmDesktop === isVm) {
      return;
    }
    this.vmDesktop = isVm;
    if (this.vmDesktop) {
      if (!this.getHasVm()) {
        this.vmDesktop = false;
        if (!this.memoryRelease) {
          this.updateSwitching(false);
        }
        this.updateMotionWindowVisible(false);
        this.initHarmonySnapshotDesktop();
      } else {
        this.updateShowPrefabrication(false);
        this.updateSettingsData(true);
        this.lastUseVmTime = systemDateTime.getTime(false);
      }
    } else {
      this.updateSettingsData(false);
      this.reportVmUsingTime();
      this.recentVmState = VmState.NOT_VM;
      AppStorage.setOrCreate('isHandMultiPinch', false);
    }
    DesktopSwitchController.getInstance().setVmDesktop(this.vmDesktop);
  }

  public getVmDesktop(): boolean {
    return this.vmDesktop;
  }

  private fusionDisplayMode(): boolean {
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
    log.showInfo(`fusionDisplayMode, bundleName：${focusedSession?.session?.bundleName}`);
    if (focusedSession?.session?.bundleName === EXFUSION_DISPLAY_BUNDLE_NAME &&
      focusedSession?.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT &&
    this.verifyFusionDisplayApp()) {
      log.showInfo('fusionDisplayMode');
      return true;
    }
    return false;
  }

  private verifyFusionDisplayApp(): boolean {
    try {
      log.showInfo('verifyExfusionDisplayApp');
      let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(EXFUSION_DISPLAY_BUNDLE_NAME,
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO);
      if (bundleInfo?.signatureInfo?.appIdentifier === EXFUSION_DISPLAY_APP_IDENTIFIER) {
        return true;
      }
    } catch (error) {
      log.showError(`get exfusion display identifier failed: ${error?.code} ${error?.message}`);
    }
    return false;
  }

  public checkFoldAndOrientation(): boolean {
    log.showInfo('checkFoldAndOrientation');
    return true;
  }

  private updateRotation(): void {
    let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    log.showInfo('currentSensorRotation: ' + screenSession.currentSensorRotation);
    this.screenRotation = screenSession.currentSensorRotation;
  }

  private updateVmSwitchAnimationPhase(phase: ESObject): void {
    try {
      log.showInfo(`updateVmSwitchAnimationPhase: ${phase}`);
      // virtualization.vmSwitchAnimationPhase(phase);
    } catch (error) {
      log.showError(`virtualization vmSwitchAnimationPhase error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  private hasLowMemoryWindow(): boolean {
    const taskManagerBundleName = 'com.ohos.taskmanager';
    const lowMemoryAbilityName = 'LowMemoryAbility';
    const activeContainerSessionList = SCBSceneSessionManager
      .getInstance()
      .getContainerSessionList()
      .getActiveSessionList();
    const hasLowMemoryWindow = activeContainerSessionList.some(containerSession => {
      const bundleName = containerSession.getBundleName();
      const abilityName = containerSession.primarySession?.sceneInfo?.abilityName;
      return bundleName === taskManagerBundleName && abilityName === lowMemoryAbilityName;
    });
    log.showInfo(`hasLowMemoryWindow: ${hasLowMemoryWindow}`);
    return hasLowMemoryWindow;
  }

  private checkMemorySwitch(): boolean {
    if (this.memoryRelease) {
      log.showInfo('memoryReleasing');
      return false;
    }
    if (this.vmDesktop) {
      log.showInfo('The virtual machine does not check the memory switching mode.');
      return true;
    }
    /*let switchType: virtualization.VmSwitchType = this.memorySwitchType();
    switch (switchType) {
      case virtualization.VmSwitchType.SWITCH_DIRECT:
        log.showInfo('Memory is normal');
        this.updateShowMemoryRelease(false);
        break;
      case virtualization.VmSwitchType.SWITCH_DELAY:
        log.showInfo('Memory is tight');
        this.memoryRelease = true;
        this.updateVmSnapshotBlurScale(20);
        this.updateShowMemoryRelease(true);
        break;
      case virtualization.VmSwitchType.SWITCH_NO:
        log.showInfo('Insufficient memory');
        this.startLowMemoryAbility();
        return false;
      default:
        log.showWarn('Memory is unknown');
    }*/
    return true;
  }

  public memoryReleasing(): void {
    log.showInfo('memoryReleasing');
    this.canInterrupt = false;
    setTimeout(() => {
      this.canInterrupt = true;
      if (this.isLock) {
        log.showInfo('memoryReleasing is lock');
        return;
      }
      if (!this.memoryCheck()) {
        this.oneTimeRightSwipeMotionSnapshot();
      } else {
        this.updateMotionWindowVisible(false);
        this.memoryReleaseEnd();
      }
    }, DesktopSwitchController.getInstance().getVmSwitchTime());
  }

  public memoryCheck(): boolean {
    /*try {
      let time = this.getTime();
      log.showInfo('isEnoughMemory begin');
      let isEnoughMemory: boolean = virtualization.isEnoughMemory();
      log.showInfo('isEnoughMemory end');
      log.showInfo('isEnoughMemory: ' + isEnoughMemory);
      log.showInfo('isEnoughMemory time: ' + (this.getTime() - time));
      return isEnoughMemory;
    } catch (error) {
      log.showError(`virtualization isEnoughMemory error, code: ${error?.code}, msg: ${error?.message}`);
      return true;
    }*/
    return true;
  }

  public memorySwitchType(): ESObject {
    /*try {
      let time = this.getTime();
      let switchType: virtualization.VmSwitchType = virtualization.allowVmSwitchIn();
      log.showInfo('AllowSwitchIn: ' + switchType);
      log.showInfo('AllowSwitchIn time: ' + (this.getTime() - time));
      return switchType;
    } catch (error) {
      log.showError(`virtualization allowSwitchIn error, code: ${error?.code}, msg: ${error?.message}`);
      return virtualization.VmSwitchType.SWITCH_DIRECT;
    }*/
    return {};
  }

  public startLowMemoryAbility(): void {
    log.showInfo('startLowMemoryAbility');
    if (this.hasLowMemoryWindow()) {
      log.showWarn('hasLowMemoryWindow');
      return;
    }
    try {
      let context = getContext(this) as common.UIAbilityContext;
      context.startAbility({
        bundleName: 'com.ohos.taskmanager',
        abilityName: 'LowMemoryVMAbility',
        parameters: {
          reason: 1,
        },
      });
    } catch (error) {
      log.showError(`startAbility error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public memoryReleaseEnd(): void {
    log.showInfo('memoryReleaseEnd');
    this.memoryRelease = false;
    this.updateVmSnapshotBlurScale(0);
    this.updateShowMemoryRelease(false);
  }

  private needScreenRotateLock(isVmDesktop: boolean): void {}

  public closeVmInit(): void {
    log.showInfo('closeVmInit');
    this.revokeAnimate = false;
    this.isVmSnapshotFoldState = SnapshotFoldState.NONE;
    this.isHarmonySnapshotFoldState = SnapshotFoldState.NONE;
    this.updateHarmonySnapshotBlurScale(BLUR_MIN);
    this.updateVmSnapshotBlurScale(BLUR_MIN);
    DesktopSwitchController
      .getInstance()
      .getVmSceneContainerSession()
    ?.primarySession
    ?.unregisterSessionDisplayChangeCallback(this.sessionDisplayChange);
  }

  public getMotionScreenId(): number {
    if (this.swipeCallback) {
      log.showInfo(`swipeCallback ScreenId: ${this.swipeCallback.getMotionScreenId()},` +
        `motionScreenId: ${this.motionScreenId}`);
    } else {
      log.showInfo(`swipeCallback is null, motionScreenId: ${this.motionScreenId}`);
    }
    return this.motionScreenId;
  }

  public setMotionScreenId(screenId: number | undefined): void {
    log.showInfo(`current screenId: ${this.motionScreenId}, target screenId: ${screenId}`);
    if (screenId !== undefined) {
      this.motionScreenId = screenId;
    }
  }

  public updateSwitching(isSwitching: boolean): void {
    log.showInfo(`updateSwitching, swipeCallback updateSwitching: ${isSwitching}`);
    if (this.swipeCallback) {
      this.swipeCallback.updateSwitching(isSwitching);
    }
  }

  public updateShowPrefabrication(show: boolean): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateShowPrefabrication(show);
    }
  }

  public updateShowMemoryRelease(show: boolean): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateShowMemoryRelease(show);
    }
  }

  public updateHarmonySnapshot(harmonySnapshot: image.PixelMap): void {
    if (this.swipeCallback && harmonySnapshot) {
      this.swipeCallback.updateHarmonySnapshot(harmonySnapshot);
    }
  }

  public updateHarmonySnapshotX(harmonySnapshotX: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateHarmonySnapshotX(harmonySnapshotX);
    }
  }

  public updateHarmonySnapshotScale(harmonySnapshotScale: number): void {
    this.harmonySnapshotScale = harmonySnapshotScale;
    if (this.swipeCallback) {
      this.swipeCallback.updateHarmonySnapshotScale(harmonySnapshotScale);
    }
  }

  public updateHarmonySnapshotRotate(harmonySnapshotRotate: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateHarmonySnapshotRotate(harmonySnapshotRotate);
    }
  }

  public updateHarmonySnapshotOpacity(harmonySnapshotOpacity: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateHarmonySnapshotOpacity(harmonySnapshotOpacity);
    }
  }

  public updateHarmonySnapshotRadius(harmonySnapshotRadius: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateHarmonySnapshotRadius(harmonySnapshotRadius);
    }
  }

  public updateHarmonySnapshotBlurScale(harmonySnapshotBlurScale: number): void {
    if (this.swipeCallback) {
      log.showInfo('harmonySnapshotBlurScale: ' + harmonySnapshotBlurScale);
      this.swipeCallback.updateHarmonySnapshotBlurScale(harmonySnapshotBlurScale);
    }
  }

  public updateVmSnapshot(vmSnapshot: image.PixelMap | null): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateVmSnapshot(vmSnapshot);
    }
  }

  public releaseVmSnapshot(): void {
    if (this.swipeCallback) {
      this.swipeCallback.releaseVmSnapshot();
    }
  }

  public releaseHarmonySnapshot(): void {
    if (this.swipeCallback) {
      this.swipeCallback.releaseHarmonySnapshot();
    }
  }

  public updateVmSnapshotX(vmSnapshotX: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateVmSnapshotX(vmSnapshotX);
    }
  }

  public updateVmSnapshotScale(vmSnapshotScale: number): void {
    if (this.swipeCallback) {
      this.vmSnapshotScale = vmSnapshotScale;
      this.swipeCallback.updateVmSnapshotScale(vmSnapshotScale);
    }
  }

  public updateVmSnapshotRotate(vmSnapshotRotate: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateVmSnapshotRotate(vmSnapshotRotate);
    }
  }

  public updateVmSnapshotOpacity(vmSnapshotOpacity: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateVmSnapshotOpacity(vmSnapshotOpacity);
    }
  }

  public updateVmSnapshotRadius(vmSnapshotRadius: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateVmSnapshotRadius(vmSnapshotRadius);
    }
  }

  public updateVmSnapshotBlurScale(vmSnapshotBlurScale: number): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateVmSnapshotBlurScale(vmSnapshotBlurScale);
    }
  }

  public updateWallpaperIndexToShowDesktop(): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateWallpaperIndexToShowDesktop();
    }
  }

  public sendToast(): void {
    if (this.swipeCallback) {
      this.swipeCallback.sendToast();
    }
  }

  public updateShowBackground(showBackground: boolean): void {
    if (this.swipeCallback) {
      this.swipeCallback.updateShowBackground(showBackground);
    }
  }

  public setMotionRect(width: number, height: number): void {
    log.showInfo(`setMotionRect, width: ${width}, height: ${height}`);
    if (this.swipeCallback) {
      this.swipeCallback.setMotionRect(width, height);
    }
  }

  public onFourFingerMotionBegin(): boolean {
    log.showInfo('onFourFingerMotionBegin');
    this.closeVirtualKeyboardFloatingWindow();
    if (this.swipeStateCallback) {
      return this.swipeStateCallback.onFourFingerMotionBegin();
    }
    return false;
  }

  public onFourFingerMotionUpdate(): void {
    if (this.swipeStateCallback) {
      this.swipeStateCallback.onFourFingerMotionUpdate();
    }
  }

  public onFourFingerMotionEnd(): void {
    if (this.swipeStateCallback) {
      this.swipeStateCallback.onFourFingerMotionEnd();
    }
  }

  public calcSpeedAndAcc(): void {
    if (this.curEvent.timestamp === this.preEvent.timestamp) {
      return;
    }
    this.curSpeed = -(this.curEvent.x - this.preEvent.x) / (this.curEvent.timestamp - this.preEvent.timestamp);
    this.acc = Math.abs((this.curSpeed - this.preSpeed) / (this.curEvent.timestamp - this.preEvent.timestamp));
    this.preSpeed = this.curSpeed;
  }

  public reachRecentLimit(): boolean {
    return (this.curSpeed <= 0 && (this.acc > px2vp(FourFingerSwipeConstants.CRITICAL_ACC) ||
      this.curSpeed < px2vp(FourFingerSwipeConstants.CRITICAL_SPEED)));
  }

  public getSwipeHorizontalDistance(): number {
    return -(this.curEvent.x - this.startEvent.x);
  }

  public getMinSwipeDistance(): number {
    return FourFingerSwipeConstants.REBOUND_DISTANCE_DEFAULT;
  }

  public getCriticalSpeed(): number {
    return FourFingerSwipeConstants.CRITICAL_SPEED;
  }

  public setScreenWidth(screenWidth: number): void {
    log.showInfo(`setScreenWidth curScreenWidth: ${this.screenWidth}, tarScreenWidth: ${screenWidth}`);
    this.screenWidth = screenWidth;
  }

  public setScreenHeight(screenHeight: number): void {
    log.showInfo(`setScreenHeight curScreenHeight: ${this.screenHeight}, tarScreenHeight: ${screenHeight}`);
    this.screenHeight = screenHeight;
  }

  public reset(): void {
    log.showInfo('reset');
    this.direction = SwipeGestureDirection.NONE;
    this.commonEvent = false;
    this.curSpeed = 0;
    this.preSpeed = 0;
    this.acc = 0;

    this.startEvent.reset();
    this.preEvent.reset();
    this.curEvent.reset();
    this.stopEvent.reset();
  }

  private leftSwipeOption: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_CTRL_LEFT, KEYCODE_WIN],
    finalKey: KEYCODE_DPAD_LEFT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private rightSwipeOption: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_CTRL_LEFT, KEYCODE_WIN],
    finalKey: KEYCODE_DPAD_RIGHT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private leftSwipeOptionLeftShift: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_SHIFT_LEFT, KEYCODE_WIN],
    finalKey: KEYCODE_E,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private leftSwipeOptionRightCtrl: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_CTRL_RIGHT, KEYCODE_WIN],
    finalKey: KEYCODE_DPAD_LEFT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private rightSwipeOptionRightCtrl: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_CTRL_RIGHT, KEYCODE_WIN],
    finalKey: KEYCODE_DPAD_RIGHT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };



  public registerKeyLeftShiftEvent(): void {
    log.showInfo('register leftShift + LOGO + E');
    try {
      inputConsumer.on('key', this.leftSwipeOptionLeftShift, callback => {
        log.showInfo('leftShift + LOGO + E');
        if (MultiSpaceSwitchOneGoCtrl.get().canHandleSpaceSwitch(SwipeGestureDirection.RIGHT,
          SwitchEnterpriseMultiSpaceType.LOGO_LSHIFT_E)) {
          MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.RIGHT,
            SwitchEnterpriseMultiSpaceType.LOGO_LSHIFT_E);
          return;
        }
      });
    } catch (error) {
      log.showError(`inputConsumer.on() error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public registerKeyLeftCtrlEvent(): void {
    log.showInfo('register leftCtrl + LOGO + ←/→');
    try {
      inputConsumer.on('key', this.leftSwipeOption, callback => {
        log.showInfo('leftCtrl + LOGO + ←');
        if (MultiSpaceSwitchOneGoCtrl.get().canHandleSpaceSwitch(SwipeGestureDirection.RIGHT,
          SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY)) {
          MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.RIGHT,
            SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY);
          return;
        }
        if (DesktopSwitchController.getInstance().hasVmAbility()) {
          if (this.getVmDesktop() && this.canInterrupt) {
            let time: number = systemDateTime.getTime(false);
            HiSysEventUtil.reportSwitchingDesktopEvent(CTRL_LOGO_LEFT, time);
          }
          multiInputManager.winCtrlLogoRightStatus = true;
          this.oneTimeRightSwipeMotionSnapshot();
        }
      });
      inputConsumer.on('key', this.rightSwipeOption, callback => {
        log.showInfo('leftCtrl + LOGO + →');
        if (MultiSpaceSwitchOneGoCtrl.get().canHandleSpaceSwitch(SwipeGestureDirection.LEFT,
          SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY)) {
          MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.LEFT,
            SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY);
          return;
        }
        if (ViewManagerPolicy.isViewShowing(ViewType.DESKTOP_SWITCHER_SPACES)) {
          log.showError('leftCtrl + LOGO + →, try to enter VM But DESKTOP_SWITCHER_SPACES is showing!');
          return;
        }
        if (DesktopSwitchController.getInstance().hasVmAbility()) {
          if (!this.getVmDesktop() && this.canInterrupt) {
            let time: number = systemDateTime.getTime(false);
            HiSysEventUtil.reportSwitchingDesktopEvent(CTRL_LOGO_RIGHT, time);
          }
          multiInputManager.winCtrlLogoRightStatus = true;
          this.oneTimeLeftSwipeMotionSnapshot();
        }
      });
    } catch (error) {
      log.showError(`inputConsumer.on() error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public registerKeyRightCtrlEvent(): void {
    try {
      inputConsumer.on('key', this.leftSwipeOptionRightCtrl, callback => {
        log.showInfo('rightCtrl + LOGO + ←');
        if (MultiSpaceSwitchOneGoCtrl.get().canHandleSpaceSwitch(SwipeGestureDirection.RIGHT,
          SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY)) {
          MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.RIGHT,
            SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY);
          return;
        }
        if (DesktopSwitchController.getInstance().hasVmAbility()) {
          if (this.getVmDesktop() && this.canInterrupt) {
            let time: number = systemDateTime.getTime(false);
            HiSysEventUtil.reportSwitchingDesktopEvent(CTRL_LOGO_LEFT, time);
          }
          multiInputManager.winCtrlLogoRightStatus = true;
          this.oneTimeRightSwipeMotionSnapshot();
        }
      });
      inputConsumer.on('key', this.rightSwipeOptionRightCtrl, callback => {
        log.showInfo('rightCtrl + LOGO + →');
        if (MultiSpaceSwitchOneGoCtrl.get().canHandleSpaceSwitch(SwipeGestureDirection.LEFT,
          SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY)) {
          MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.LEFT,
            SwitchEnterpriseMultiSpaceType.SHORTCUT_KEY);
          return;
        }
        if (ViewManagerPolicy.isViewShowing(ViewType.DESKTOP_SWITCHER_SPACES)) {
          log.showError('rightCtrl + LOGO + →, try to enter VM But DESKTOP_SWITCHER_SPACES is showing!');
          return;
        }
        if (DesktopSwitchController.getInstance().hasVmAbility()) {
          if (!this.getVmDesktop() && this.canInterrupt) {
            let time: number = systemDateTime.getTime(false);
            HiSysEventUtil.reportSwitchingDesktopEvent(CTRL_LOGO_RIGHT, time);
          }
          multiInputManager.winCtrlLogoRightStatus = true;
          this.oneTimeLeftSwipeMotionSnapshot();
        }
      });
    } catch (error) {
      log.showError(`inputConsumer.on() error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  /**
   * 撤销四指切换，重置状态量与事件
   */
  private undoSwitch(): void {
    this.ended = true;
    if (this.vmDesktop) {
      log.showInfo('undoSwitch, still in Vm');
      DesktopSwitchController.getInstance().onRearAni(true);
    } else {
      log.showInfo('undoSwitch, still in Harmony');
      DesktopSwitchController.getInstance().onRearAni(false);
    }
    this.resetParameter();
  }

  public judgmentOnDragAcrossScreen(sessionChangeInfo: SessionChangeInfo): void {
    if (this.vmDesktop && sessionChangeInfo.targetScreenId === this.motionScreenId) {
      log.showInfo('judgmentOnDragAcrossScreen, do switch to Harmony');
      HiSysEventUtil.reportSwitchingDesktopEvent('DRAG_BACK_HARMONY', this.getTime());
      this.oneTimeRightSwipeMotionSnapshot();
    } else {
      log.showDebug(`Not switch, vm is ${this.vmDesktop}, targetScreenId is ${sessionChangeInfo.targetScreenId}`);
    }
  }

  private reportSwipeGesture(distance: number): void {
    let duration = systemDateTime.getTime(false) - this.swipeBeginTimeStamp;
    log.showInfo(`reportSwipeGesture, duration: ${duration}, distance: ${distance}`);
    HiSysEventUtil.reportSwitchDesktopFourFingerSwipe(duration, distance);
  }

  private resetVmDesktopState(): void {
    log.showInfo('resetVmDesktopState');
    this.setVmDesktop(true);
    this.oneTimeLeftMotionFinish();
  }
}

export class Position {
  public x: number;
  public y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}


export interface FourFingerMotionStateCallback {
  /**
   * 四指按下事件
   */
  onFourFingerMotionBegin(): boolean;

  /**
   * 四指移动事件
   */
  onFourFingerMotionUpdate(): void;

  /**
   * 四指松开事件
   */
  onFourFingerMotionEnd(): void;
}

export interface FourFingerMotionCallback {
  /**
   * 获取零级控件所在屏幕
   */
  getMotionScreenId(): number;

  /**
   * 更新harmony桌面截图
   */
  updateHarmonySnapshot(harmonySnapshot: image.PixelMap | null): void;

  /**
   * 更新虚拟机桌面截图
   */
  updateVmSnapshot(vmSnapshot: image.PixelMap | null): void;

  /**
   * 释放虚拟机桌面截图
   */
  releaseVmSnapshot(): void;

  /**
   * 释放鸿蒙桌面截图
   */
  releaseHarmonySnapshot(): void;

  /**
   * 更新切换状态
   */
  updateSwitching(isSwitching: boolean): void;

  /**
   * 更新展示情况
   */
  updateShowPrefabrication(show: boolean): void;

  /**
   * 是否为内存不足场景
   */
  updateShowMemoryRelease(show: boolean): void;

  /**
   * 更新harmony桌面截图位置
   */
  updateHarmonySnapshotX(harmonySnapshotX: number): void;

  /**
   * 更新harmony桌面截图大小
   */
  updateHarmonySnapshotScale(harmonySnapshotScale: number): void;

  /**
   * 更新harmony桌面截图旋转角度
   */
  updateHarmonySnapshotRotate(harmonySnapshotRotate: number): void;

  /**
   * 更新harmony不透明度
   */
  updateHarmonySnapshotOpacity(harmonySnapshotOpacity: number): void;

  /**
   * 更新harmony桌面截图圆角
   */
  updateHarmonySnapshotRadius(harmonySnapshotRadius: number): void;

  /**
   * 更新harmony桌面截图模糊
   */
  updateHarmonySnapshotBlurScale(harmonySnapshotBlurScale: number): void

  /**
   * 更新虚拟机桌面截图位置
   */
  updateVmSnapshotX(vmSnapshotX: number): void;

  /**
   * 更新虚拟机桌面截图大小
   */
  updateVmSnapshotScale(vmSnapshotScale: number): void;

  /**
   * 更新虚拟机桌面截图角度
   */
  updateVmSnapshotRotate(vmSnapshotRotate: number): void;

  /**
   * 更新虚拟机桌面截图不透明度
   */
  updateVmSnapshotOpacity(vmSnapshotOpacity: number): void;

  /**
   * 更新虚拟机桌面截图圆角
   */
  updateVmSnapshotRadius(vmSnapshotRadius: number): void;

  /**
   * 更新虚拟机桌面截图模糊
   */
  updateVmSnapshotBlurScale(vmSnapshotBlurScale: number): void;

  /**
   * 更新虚拟机桌面截图模糊
   */
  updateWallpaperIndexToShowDesktop(): void;

  /**
   * 发送Toast提示
   */
  sendToast(): void;

  /**
   * 更新动效背景
   */
  updateShowBackground(showBackground: boolean): void;

  /**
   * 更新虚拟机动效窗口大小
   */
  setMotionRect(width: number, height: number): void;

}