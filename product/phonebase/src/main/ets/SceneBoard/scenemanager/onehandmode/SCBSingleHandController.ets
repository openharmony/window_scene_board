/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import display from '@ohos.display';
import sceneSessionManager from '@ohos.sceneSessionManager';
import settings from '@ohos.settings';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { vibratorMgr, EventConstants, CommonConstants } from '@ohos/launchercommon';
import { GlobalContext, DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBScreenSession,
  SCBPropertyChangeReason,
  SCBScreenSessionManager,
  SCBUnlockTransitionController,
  SCBSceneSessionManager,
  SCBSceneContainerSession
} from '@ohos/windowscene';
import { BusinessError } from '@ohos.base';
import hiSysEvent from '@ohos.hiSysEvent';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import {
  RecentCallbackArgsType,
  RecentGestureEventManager
} from '../../recent/common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../recent/common/constants/RecentGestureConstants';
//import { map } from '@kit.MapKit';
import { SCBWindowRotateController } from '@ohos/windowscene/src/main/ets/TsIndex';
import { RotationConstants } from '@ohos/commonconstants';
import {
  CollaborationCallBack,
  CollaborationRegisterManager
} from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/CollaborationRegisterManager';
//import { collaborationServiceManager } from '@kit.ServiceCollaborationKit';


const TAG = 'SCBSingleHandController';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const FULL_SCREEN_ID: number = 0;
const SINGLE_HAND_SCALE: number = 0.75;
const DEFAULT_SCALE: number = 1.0;
const DOMAIN_USER_PROPERTY: string = settings.domainName.USER_PROPERTY;
const DOMAIN_USER_SECURITY: string = settings.domainName.USER_SECURITY;
const SINGLE_HAND_SWITCH: string = 'single_hand_switch';
const SINGLE_HAND_SWITCH_ON: string = 'on';
const SINGLE_HAND_SWITCH_OFF: string = 'off';
const SINGLE_HAND_MODE: string = 'single_hand_mode';
const CONTAINER_ID_OF_BOX: string = 'OneHandModeBox';
const MAGNIFICATION_SWITCH_ON: string = '1';
const MAGNIFICATION_SWITCH_OFF: string = '0';
const MAGNIFICATION_SWITCH: string = 'accessibility_display_magnification_enabled';
const SINGLE_HAND_AVAILABLE_ROTATION: number = 0;
const VDE_SINGLE_HAND_SCALE: number = 0.7;
const VDE_SINGLE_HAND_WIDTH_CHANGE: number = 1;
const VDE_SINGLE_HAND_HEIGHT_CHANGE: number = 1.2439;
const RECENT_GESTURE_EVENT_LIST: RecentGestureEvent[] = [
  RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP,
  RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_HOME,
];
const SNAPSHOT_SESSION_NUM: number = 2;

const COLLABORATION_SERVICE_NAME_LIST: string[] = [
  // 多屏协同
  'DeviceCollaboration',
  'DeviceCollaboration-Dual',
  'DeviceCollaboration-ExtensionScreen',
  // 无线投屏
  'OhosCast-Dual',
  'OhosCast',
  'Miracast',
];

export enum SingleHandMode {
  LEFT = 'left',
  RIGHT = 'right',
  MIDDLE = 'middle',
}

export enum SingleHandExitReason {
  CLICK_EMPTY,
  SCREEN_LOCK,
  FOLD_STATUS_CHANGE,
  SETTINGS_DATA_CHANGE,
  DEVICE_ROTATION,
  MOUSE_EVENTS,
  SINGLE_HAND_SWITCH_OFF,
  MAGNIFICATION_SWITCH_ON,
  COLLABORATION_CONNECTED,
}

interface ExitSingleHandParams {
  PNAMEID: string,
  PVERSIONID: string,
  DURATION: string,
  REASON: SingleHandExitReason,
  MODE_BEFORE_EXIT: SingleHandMode
}

export interface SingleHandStatusChangeCallback {
  onSingleHandEntered: (mode: SingleHandMode) => void;
  onSingleHandExited: () => void;
}

export interface SingleHandConditionFunc {
  isSingleHandAvailableNow: () => boolean;
}

export interface SingleHandAnimationFinishCallBack {
  onEnterSingleHandAnimationFinish: () => void;
  onExitSingleHandAnimationFinish: () => void;
}

export interface SingleHandRect {
  singleHandX: number,
  singleHandY: number,
  singleHandW: number,
  singleHandH: number,
  scale: number
}

export interface SingleHandManagerInfo {
  x: number,
  y: number,
  centerX?: string,
  centerY?: string,
}

interface TransformInfo {
  transformX: number,
  transformY: number,
  pivotX: number,
  pivotY: number
}

interface WsRect {
  posX: number;
  posY: number;
  width: number;
  height: number;
}

class SingleHandReportEventUtil {
  private static readonly SINGLE_HAND_UE: string = 'SINGLE_HAND_UE';
  private static readonly PNAMEID: string = 'SCB';
  private static readonly PVERSIONID: string = '1.0';
  private static readonly SINGLE_HAND_EXIT: string = 'SINGLE_HAND_EXIT';

  private static reportEvent(eventName: string, msg: Object): void {
    hiSysEvent.write({
      domain: SingleHandReportEventUtil.SINGLE_HAND_UE,
      name: eventName,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: msg
    }).then((val) => {
      log.showDebug('success');
    }).catch((err: BusinessError) => {
      log.showError('report false ' + err.message);
    })
  }

  static reportExitSingleHandEvent(duration: number, reason: SingleHandExitReason, mode: SingleHandMode): void {
    let eventName: string = SingleHandReportEventUtil.SINGLE_HAND_EXIT;
    let params: ExitSingleHandParams = {
      PNAMEID: SingleHandReportEventUtil.PNAMEID,
      PVERSIONID: SingleHandReportEventUtil.PVERSIONID,
      DURATION: duration.toString(),
      REASON: reason,
      MODE_BEFORE_EXIT: mode
    };
    SingleHandReportEventUtil.reportEvent(eventName, params);
  }
}

export class SCBSingleHandController {
  private constructor() {
    try {
      display.on('foldStatusChange', () => {
        this.exitSingleHand(SingleHandExitReason.FOLD_STATUS_CHANGE);
      });
    } catch (error) {
      log.showError(`registerFoldStatusListener on error:${error}`);
    }
    try {
      inputMonitor.on('mouse', () => {
        this.exitSingleHand(SingleHandExitReason.MOUSE_EVENTS);
      });
    } catch (error) {
      log.showError(`registerMouseEventListener on error:${error}`);
    }
    this.updateSingleHandRectInfo();
    this.updateTransformInfo();
    //CollaborationRegisterManager.getInstance().register(TAG, this.collaborationCallback);
    this.registerSingleHandSwitchObserver();
    this.registerSingleHandModeObserver();
    this.registerMagnificationSwitchObserver();
    this.registerSingleHandConditionFunc(TAG, this.checkDeviceConditionFunc);
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.onLockReceived);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        this.screenRotation = screenProperty.rotation;
        log.showDebug(`screenProperty change, screenId:${screenProperty.screenId}, ` +
                      `rotation:${screenProperty.rotation}`);
        if (reason === SCBPropertyChangeReason.ROTATION) {
          this.exitSingleHand(SingleHandExitReason.DEVICE_ROTATION);
        }
      });
    this.notifySingleHandInfoChange(this.BuildSingleHandScreenInfo(),
      this.BuildOriginRect(), this.BuildSingleHandRect());
    this.notifySingleHandStatusChange(SingleHandMode.MIDDLE);
    this.setSettingsData(SINGLE_HAND_MODE, SingleHandMode.MIDDLE, DOMAIN_USER_PROPERTY);
    this.singleHandSwitch = this.getSettingsData(SINGLE_HAND_SWITCH, SINGLE_HAND_SWITCH_ON, DOMAIN_USER_PROPERTY);
    this.magnificationSwitch = this.getSettingsData(MAGNIFICATION_SWITCH,
      MAGNIFICATION_SWITCH_OFF, DOMAIN_USER_SECURITY);
  }

  private singleHandContainerNodeRegistered: boolean = false;
  private singleHandSwitch: string = SINGLE_HAND_SWITCH_ON;
  private magnificationSwitch: string = MAGNIFICATION_SWITCH_OFF;
  private singleHandMode: SingleHandMode = SingleHandMode.MIDDLE;
  //private collaborationConnectedState: number = collaborationServiceManager.State.IDLE;
  private singleHandScale = SINGLE_HAND_SCALE;
  private isCompatibleMode: boolean = false;
  private screenWidthRatio: number = 1;
  private screenHeightRatio: number = 1;
  private screenRotation: number = SINGLE_HAND_AVAILABLE_ROTATION;
  private enterSingleHandTime: number = 0;
  private singleHandStatusChangeCallbackMap: Map<string, SingleHandStatusChangeCallback> = new Map();
  private singleHandConditionFuncMap: Map<string, SingleHandConditionFunc> = new Map();
  private singleHandAnimationFinishCallBackMap: Map<string, SingleHandAnimationFinishCallBack> = new Map();
  private singleHandScreenWidth = 0;
  private singleHandScreenHeight = 0;
  private originScreenWidth = 0;
  private originScreenHeight = 0;
  private middleSingleHandRect: SingleHandRect = {
    singleHandX: 0,
    singleHandY: 0,
    singleHandH: 0,
    singleHandW: 0,
    scale: 1,
  };
  private leftSingleHandRect: SingleHandRect = {
    singleHandX: 0,
    singleHandY: 0,
    singleHandH: 0,
    singleHandW: 0,
    scale: 1,
  };
  private rightSingleHandRect: SingleHandRect = {
    singleHandX: 0,
    singleHandY: 0,
    singleHandH: 0,
    singleHandW: 0,
    scale: 1,
  };
  private leftTransformInfo: TransformInfo = {
    transformX: 0,
    transformY: 0,
    pivotX: 0,
    pivotY: 0,
  };
  private rightTransformInfo: TransformInfo = {
    transformX: 0,
    transformY: 0,
    pivotX: 0,
    pivotY: 0,
  };
  private checkDeviceConditionFunc: SingleHandConditionFunc = {
    isSingleHandAvailableNow: (): boolean => {
      // ordinary straight plate machine
      if (DeviceHelper.isBarPhone()) {
        return true;
      }
      // Large folding devices are supported only in folding state.
      if (DeviceHelper.isLargeInFoldProduct() && this.isLargeFoldProductAndFolded()) {
        return true;
      }
      // Small folding devices are supported only in the expanded state.
      if (DeviceHelper.isSmallFoldProduct() && DeviceHelper.isFoldExpanded()) {
        return true;
      }
      log.showInfo('Check device condition: not support now');
      return false;
    }
  };
  private onLockReceived: SCBUnlockTransitionController = {
    name: `${TAG}`,
    onLock: (): void => {
      this.exitSingleHand(SingleHandExitReason.SCREEN_LOCK);
    },
    onUnlock: (): void => {}
  };

  // private collaborationCallback: CollaborationCallBack = {
  //   callBack: (result: collaborationServiceManager.ServiceStateInfo) => {
  //     if (COLLABORATION_SERVICE_NAME_LIST.includes(result.serviceName)) {
  //       this.collaborationConnectedState = result.state;
  //       log.showInfo(`collaboration serviceName: ${result.serviceName}, state: ${result.state}`);
  //       this.exitSingleHand(SingleHandExitReason.COLLABORATION_CONNECTED);
  //     }
  //   }
  // };

  /**
   * get display fold status
   *
   * @returns fold status
   */
  private getDisplayFoldStatus(): display.FoldStatus {
    let status: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      status = display.getFoldStatus();
    } catch (error) {
      log.showError('Get fold status err:', error);
    }
    return status;
  }

  /**
   * Is large fold product and folded.
   *
   * @returns boolean
   */
  private isLargeFoldProductAndFolded(): boolean {
    let isLargeFoldProductFolded: boolean = false;
    try {
      isLargeFoldProductFolded = display.isFoldable() &&
        display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED;
    } catch (error) {
      log.showError('isLargeFoldProductFolded -> try error:', error);
    }
    return isLargeFoldProductFolded;
  }

  /**
   * Obtains a single instance of SCBSingleHandController.
   *
   * @returns { SCBSingleHandController } Returns a singleton instance of SCBSingleHandController.
   */
  public static getInstance(): SCBSingleHandController {
    if (!globalThis.SCBSingleHandControllerInstance) {
      log.showInfo('init');
      globalThis.SCBSingleHandControllerInstance = new SCBSingleHandController();
    }
    return globalThis.SCBSingleHandControllerInstance;
  }

  /**
   * Get current single hand status.
   *
   * @returns { SingleHandMode } Returns current single-hand mode.
   */
  public GetCurrentMode(): SingleHandMode {
    return this.singleHandMode;
  }

  /**
   * Get current single hand scale.
   *
   * @returns { number } Returns current single-hand scale.
   */
  public GetCurrentScale(): number {
    if (this.singleHandMode === SingleHandMode.MIDDLE) {
      return DEFAULT_SCALE;
    }
    return this.singleHandScale;
  }

  /**
   * Get current single hand rect and scale.
   *
   * @returns { number } Returns current single-hand rect and scale.
   */
  public GetCurrentSingleHandRect(): SingleHandRect {
    if (this.GetCurrentMode() === SingleHandMode.LEFT) {
      return this.leftSingleHandRect;
    }
    if (this.GetCurrentMode() === SingleHandMode.RIGHT) {
      return this.rightSingleHandRect;
    }
    return this.middleSingleHandRect;
  }

  /**
   * register SingleHandCondition Func
   *
   * @param { string } callingName
   * @param { SingleHandConditionFunc } func
   */
  public registerSingleHandConditionFunc(callingName: string, func: SingleHandConditionFunc): void {
    log.showInfo('registerSingleHandConditionFunc: ' + callingName);
    this.singleHandConditionFuncMap.set(callingName, func);
  }

  /**
   * unregister SingleHandCondition Func
   *
   * @param { string } callingName
   */
  public unregisterSingleHandConditionFunc(callingName: string): void {
    log.showInfo('unregisterSingleHandConditionFunc: ' + callingName);
    this.singleHandConditionFuncMap.delete(callingName);
  }

  /**
   * register singleHandStatusChange Callback
   *
   * @param { string } callingName
   * @param { SingleHandStatusChangeCallback } callback
   */
  public registerSingleHandStatusChangeCallback(callingName: string, callback: SingleHandStatusChangeCallback): void {
    log.showInfo('registerSingleHandStatusChangeCallback: ' + callingName);
    this.singleHandStatusChangeCallbackMap.set(callingName, callback);
  }

  /**
   * unregister singleHandStatusChange Callback
   *
   * @param { string } callingName
   */
  public unregisterSingleHandStatusChangeCallback(callingName: string): void {
    log.showInfo('unregisterSingleHandStatusChangeCallback: ' + callingName);
    this.singleHandStatusChangeCallbackMap.delete(callingName);
  }

  /**
   * register singleHandAnimationFinishCallBack Callback
   *
   * @param { string } callingName
   * @param { SingleHandAnimationFinishCallBack } callback
   */
  public registerSingleHandAnimationFinishCallBack(callingName: string,
    callback: SingleHandAnimationFinishCallBack): void {
    log.showInfo('registerSingleHandAnimationFinishCallBack: ' + callingName);
    this.singleHandAnimationFinishCallBackMap.set(callingName, callback);
  }

  /**
   * unregister singleHandAnimationFinishCallBack Callback
   *
   * @param { string } callingName
   */
  public unregisterSingleHandAnimationFinishCallBack(callingName: string): void {
    log.showInfo('unregisterSingleHandAnimationFinishCallBack: ' + callingName);
    this.singleHandAnimationFinishCallBackMap.delete(callingName);
  }

  /**
   * notify single hand mode Animation Finish
   *
   * @param { boolean } enter or exit single hand mode
   */
  public notifySingleHandModeAnimationFinish(isEnter: boolean): void {
    log.showInfo(`notifySingleHandModeAnimationFinish, isEnter: ${isEnter}`);
    if (isEnter) {
      this.singleHandAnimationFinishCallBackMap.forEach((callback) => {
        callback?.onEnterSingleHandAnimationFinish();
      });
    } else {
      this.singleHandAnimationFinishCallBackMap.forEach((callback) => {
        callback?.onExitSingleHandAnimationFinish();
      });
    }
  }

  private isReadyForOneHandedMode(): boolean {
    if (!this.checkSingeHandSettings()) {
      log.showInfo('SingleHand switch is off');
      return false;
    }

    if (this.checkMagnificationSettings()) {
      log.showInfo('Magnification switch is on');
      return false;
    }

    if (!this.checkScreenRotation()) {
      log.showInfo(`Single-handed mode is available only when the rotation is 0, rotation:${this.screenRotation}`);
      return false;
    }

    if (this.checkCollaborationConnectedState()) {
      log.showInfo('Collaboration is connected');
      return false;
    }

    if (!this.checkSingleHandEnableCondition()) {
      return false;
    }

    return true;
  }

  /**
   * check screen rotation
   */
  private checkScreenRotation(): boolean {
    return this.screenRotation === SINGLE_HAND_AVAILABLE_ROTATION;
  }

  /**
   * check magnification switch
   */
  private checkMagnificationSettings(): boolean {
    return this.magnificationSwitch === MAGNIFICATION_SWITCH_ON;
  }

  /**
   * check collaboration connected state
   */
  private checkCollaborationConnectedState(): boolean {
    return false;
    //return this.collaborationConnectedState === collaborationServiceManager.State.CONNECTED;
  }

  /**
   * check single hand switch
   */
  public checkSingeHandSettings(): boolean {
    return this.singleHandSwitch === SINGLE_HAND_SWITCH_ON;
  }

  private checkSingleHandEnableCondition(): boolean {
    let ret: boolean = true;
    this.singleHandConditionFuncMap.forEach((func, callingName) => {
      if (!func?.isSingleHandAvailableNow()) {
        log.showInfo(`can not enter singlehand, reject by: ${callingName}`);
        ret = false;
      }
    });
    return ret;
  }

  /**
   * enter singlehand mode
   *
   * @param { SingleHandMode } mode
   */
  public enterSingleHand(mode: SingleHandMode): void {
    sceneSessionManager.registerSingleHandContainerNode(CONTAINER_ID_OF_BOX);
    if (this.singleHandMode !== SingleHandMode.MIDDLE) {
      log.showDebug('repeat request: enter');
      return;
    }

    if (!this.isReadyForOneHandedMode()) {
      return;
    }

    TraceUtil.startTrace(DomainName.SCB, 'SCBEnterSingleHand');
    vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    localEventManager.sendLocalEvent(EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL, undefined);
    SCBScreenSessionManager.getInstance().getMainScreenSession()?.setEnableSensorRotate(false, 'SINGLE_HAND_ENTERED');
    if (mode === SingleHandMode.LEFT) {
      this.singleHandMode = SingleHandMode.LEFT;
    } else {
      this.singleHandMode = SingleHandMode.RIGHT;
    }
    this.updateSingleHandRectInfo();
    this.updateTransformInfo();
    let transformInfo: TransformInfo = this.GetCurrentTransformInfo();
    let centerX = '' + (transformInfo.transformX * 100) + '%';
    let centerY = '' + (transformInfo.transformY * 100) + '%';
    let singleHandManagerInfo: SingleHandManagerInfo = {
      x: this.singleHandScale,
      y: this.singleHandScale,
      centerX: centerX,
      centerY: centerY
    };
    globalThis.oneHandModeManagerInstance.switchOneHandMode(true, singleHandManagerInfo, this.BuildOriginRect());
    log.showInfo(`Enter transform: (${transformInfo.transformX}, ${transformInfo.transformY}),` +
      `pivot: (${transformInfo.pivotX}, ${transformInfo.pivotY})`);
    this.setSettingsData(SINGLE_HAND_MODE, this.singleHandMode, DOMAIN_USER_PROPERTY);
    this.notifySingleHandInfoChange(this.BuildSingleHandScreenInfo(), this.BuildOriginRect(),
      this.BuildSingleHandRect());
    this.notifySingleHandStatusChange(mode);
    this.enterSingleHandTime = Date.now();
    this.logPrintRectInto(this.GetCurrentSingleHandRect(), 'Enter single hand')
    log.showInfo(`Enter singlehand: ${mode}`);
    TraceUtil.endTrace(DomainName.SCB, 'SCBEnterSingleHand');
  }

  /**
   * exit singlehand mode
   *
   * @param { SingleHandExitReason } reason
   */
  public exitSingleHand(reason: SingleHandExitReason): void {
    if (this.singleHandMode === SingleHandMode.MIDDLE) {
      log.showDebug('repeat request: exit');
      return;
    }
    TraceUtil.startTrace(DomainName.SCB, 'SCBExitSingleHand');
    SingleHandReportEventUtil.reportExitSingleHandEvent(Date.now() - this.enterSingleHandTime,
      reason, this.singleHandMode);
    let singleHandManagerInfo: SingleHandManagerInfo = {
      x: DEFAULT_SCALE,
      y: DEFAULT_SCALE,
    };
    globalThis.oneHandModeManagerInstance.switchOneHandMode(false, singleHandManagerInfo, this.BuildSingleHandRect(),
      reason);
    this.singleHandMode = SingleHandMode.MIDDLE;
    this.setSettingsData(SINGLE_HAND_MODE, this.singleHandMode, DOMAIN_USER_PROPERTY);
    this.notifySingleHandInfoChange(this.BuildSingleHandScreenInfo(), this.BuildOriginRect(),
      this.BuildSingleHandRect());
    this.notifySingleHandStatusChange(SingleHandMode.MIDDLE);
    SCBScreenSessionManager.getInstance().getMainScreenSession()?.setEnableSensorRotate(true, 'SINGLE_HAND_EXITED');
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession?.sensorScreenProperty.rotation === RotationConstants.ROTATION_90 ||
      screenSession?.sensorScreenProperty.rotation === RotationConstants.ROTATION_270) {
      screenSession?.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'exit single hand mode');
    }
    this.logPrintRectInto(this.GetCurrentSingleHandRect(), 'Exit single hand')
    log.showInfo(`exit singlehand, reason: ${reason}`);
    TraceUtil.endTrace(DomainName.SCB, 'SCBExitSingleHand');
  }

  /**
   * get rdb database value
   *
   * @param { string } key
   * @param { string } defValue
   */
  private getSettingsData(key: string, defValue: string, domainName: string): string {
    let data: string = defValue;
    try {
      data = settings.getValueSync(GlobalContext.getContext(), key, defValue, domainName);
      log.showDebug(`getSettingsData key:${key}, value:${data}`);
    } catch (e) {
      log.showError(`get ${key} value error. use default`);
    }
    return data;
  }

  /**
   * set rdb database value
   *
   * @param { string } key
   * @param { string } value
   */
  private setSettingsData(key: string, value: string, domainName: string): void {
    let result: boolean = false;
    try {
      result = settings.setValueSync(GlobalContext.getContext(), key, value, domainName);
    } catch (e) {
      log.showError(`set ${key} to ${value} error, ${e}`);
    }
    if (!result) {
      log.showWarn(`set ${key} to ${value} failed`);
    }
    log.showDebug(`setSettingsData key:${key}, value:${value}`);
  }

  /**
   * register single hand mode observer
   */
  private registerSingleHandModeObserver(): void {
    let domainName: string = DOMAIN_USER_PROPERTY;
    let result: boolean = false;
    try {
      result = settings.registerKeyObserver(GlobalContext.getContext(), SINGLE_HAND_MODE, domainName, () => {
        let mode: string = this.getSettingsData(SINGLE_HAND_MODE, SingleHandMode.MIDDLE, domainName);
        log.showInfo(`single hand mode change is observered:${mode}`);
        if ((this.singleHandMode !== SingleHandMode.MIDDLE) && (mode === SingleHandMode.MIDDLE)) {
          this.exitSingleHand(SingleHandExitReason.SETTINGS_DATA_CHANGE);
        }
      });
    } catch (e) {
      log.showError(`Register single hand mode observer err, ${e}`);
    }
    if (!result) {
      log.showWarn('Register single hand mode observer failed');
    }
  }

  private logPrintRectInto(rectInfo: SingleHandRect, rectName: string): void {
    log.showInfo(`${rectName} rect: (${rectInfo.singleHandX}, ${rectInfo.singleHandY}, ${rectInfo.singleHandW}, ` +
      `${rectInfo.singleHandH}), scale: ${rectInfo.scale}`);
  }

  /**
   * update single hand rect form screen property
   */
  private updateSingleHandRectInfo(): void {
    let screenProperty = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    /* single hand mode rect init */
    this.middleSingleHandRect.singleHandX = screenProperty.left;
    this.middleSingleHandRect.singleHandY = screenProperty.top;
    this.middleSingleHandRect.singleHandW = screenProperty.width;
    this.middleSingleHandRect.singleHandH = screenProperty.height;
    this.middleSingleHandRect.scale = 1;
    this.logPrintRectInto(this.middleSingleHandRect, 'Middle');
    /* left single hand mode rect */
    this.leftSingleHandRect.singleHandX = 0;
    this.leftSingleHandRect.singleHandY =
      Math.ceil((1 - this.screenHeightRatio * this.singleHandScale) * screenProperty.height);
    this.leftSingleHandRect.singleHandW =
      Math.ceil(screenProperty.width * this.screenWidthRatio * this.singleHandScale);
    this.leftSingleHandRect.singleHandH =
      Math.ceil(screenProperty.height * this.screenHeightRatio * this.singleHandScale);
    this.leftSingleHandRect.scale = this.singleHandScale;
    this.logPrintRectInto(this.leftSingleHandRect, 'Left');
    /* right single hand mode rect */
    this.rightSingleHandRect.singleHandX =
      Math.ceil((1 - this.screenWidthRatio * this.singleHandScale) * screenProperty.width);
    this.rightSingleHandRect.singleHandY = this.leftSingleHandRect.singleHandY;
    this.rightSingleHandRect.singleHandW = this.leftSingleHandRect.singleHandW;
    this.rightSingleHandRect.singleHandH = this.leftSingleHandRect.singleHandH;
    this.rightSingleHandRect.scale = this.singleHandScale;
    this.logPrintRectInto(this.rightSingleHandRect, 'Right');
  }

  /**
   * update single hand transform info
   */
  private updateTransformInfo(): void {
    let screenProperty = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    /* init screen info */
    this.originScreenWidth = screenProperty.width;
    this.originScreenHeight = screenProperty.height;
    this.singleHandScreenWidth = Math.ceil(screenProperty.width * this.screenWidthRatio);
    this.singleHandScreenHeight = Math.ceil(screenProperty.height * this.screenHeightRatio);
    /* left transform info */
    this.leftTransformInfo.transformX = 0;
    this.leftTransformInfo.transformY = (1 - this.screenHeightRatio * this.singleHandScale) /
      (this.screenHeightRatio - this.screenHeightRatio * this.singleHandScale);
    this.leftTransformInfo.pivotX = 0;
    this.leftTransformInfo.pivotY = Math.ceil(this.leftTransformInfo.transformY * this.singleHandScreenHeight);
    /* right transform info */
    this.rightTransformInfo.transformX = (1 - this.screenWidthRatio * this.singleHandScale) /
      (this.screenWidthRatio - this.screenWidthRatio * this.singleHandScale);
    this.rightTransformInfo.transformY = this.leftTransformInfo.transformY;
    this.rightTransformInfo.pivotX = Math.ceil(this.rightTransformInfo.transformX * this.singleHandScreenWidth);
    this.rightTransformInfo.pivotY = this.leftTransformInfo.pivotY;
  }

  /**
   * register single hand switch observer
   */
  private registerSingleHandSwitchObserver(): void {
    let domainName: string = DOMAIN_USER_PROPERTY;
    let result: boolean = false;
    try {
      result = settings.registerKeyObserver(GlobalContext.getContext(), SINGLE_HAND_SWITCH, domainName, () => {
        this.singleHandSwitch = this.getSettingsData(SINGLE_HAND_SWITCH, SINGLE_HAND_SWITCH_ON, domainName);
        log.showInfo(`single hand switch change is observered:${this.singleHandSwitch}`);
        if (this.singleHandSwitch === SINGLE_HAND_SWITCH_OFF) {
          this.exitSingleHand(SingleHandExitReason.SINGLE_HAND_SWITCH_OFF);
        }
      });
    } catch (e) {
      log.showError(`Register single hand switch observer err, ${e}`);
    }
    if (!result) {
      log.showWarn('Register single hand switch observer failed');
    }
  }

  /**
   * register magnification switch observer
   */
  private registerMagnificationSwitchObserver(): void {
    let domainName: string = DOMAIN_USER_SECURITY;
    let result: boolean = false;
    try {
      result = settings.registerKeyObserver(GlobalContext.getContext(), MAGNIFICATION_SWITCH, domainName, () => {
        this.magnificationSwitch = this.getSettingsData(MAGNIFICATION_SWITCH, MAGNIFICATION_SWITCH_OFF, domainName);
        log.showInfo(`magnification switch change is observered:${this.magnificationSwitch}`);
        if (this.magnificationSwitch === MAGNIFICATION_SWITCH_ON) {
          this.exitSingleHand(SingleHandExitReason.MAGNIFICATION_SWITCH_ON);
        }
      });
    } catch (e) {
      log.showError(`Register magnification switch observer err, ${e}`);
    }
    if (!result) {
      log.showWarn('Register magnification switch observer failed');
    }
  }

  private notifySingleHandStatusChange(mode: SingleHandMode): void {
    log.showInfo(`notifySingleHandStatusChange mode: ${mode}`);
    if (mode === SingleHandMode.MIDDLE) {
      this.singleHandStatusChangeCallbackMap.forEach((callback) => {
        callback?.onSingleHandExited();
      });
    } else {
      this.singleHandStatusChangeCallbackMap.forEach((callback) => {
        callback?.onSingleHandEntered(mode);
      });
    }
  }

  private notifySingleHandInfoChange(singleHandScreenInfo: sceneSessionManager.SingleHandScreenInfo,
    originRect: sceneSessionManager.SessionRect, singleHandRect: sceneSessionManager.SessionRect): void {
    sceneSessionManager.notifySingleHandInfoChange(singleHandScreenInfo, originRect, singleHandRect);
  }

  private RegisterSingleHandContainerNode(stringId: string): void {
    if (!this.singleHandContainerNodeRegistered) {
      sceneSessionManager.registerSingleHandContainerNode(stringId);
      this.singleHandContainerNodeRegistered = true;
    }
  }

  private GetCurrentTransformInfo(): TransformInfo {
    if (this.GetCurrentMode() === SingleHandMode.LEFT) {
      return this.leftTransformInfo;
    }
    return this.rightTransformInfo;
  }

  private BuildOriginRect(): sceneSessionManager.SessionRect {
    let rect: sceneSessionManager.SessionRect = {
      posX_: 0,
      posY_: 0,
      width_: this.originScreenWidth,
      height_: this.originScreenHeight
    }
    return rect;
  }

  private BuildSingleHandRect(): sceneSessionManager.SessionRect {
    let rect: sceneSessionManager.SessionRect = {
      posX_: 0,
      posY_: 0,
      width_: 0,
      height_: 0
    }
    if (this.GetCurrentMode() === SingleHandMode.MIDDLE) {
      return this.BuildOriginRect();
    }
    let tempRect: SingleHandRect = this.GetCurrentSingleHandRect();
    rect.posX_ = tempRect.singleHandX;
    rect.posY_ = tempRect.singleHandY;
    rect.width_ = tempRect.singleHandW;
    rect.height_ = tempRect.singleHandH;
    return rect;
  }

  private GetSingleHandStatusModeNum(): number {
    let singHandMode: SingleHandMode = this.GetCurrentMode();
    if (singHandMode === SingleHandMode.LEFT) {
      return 0;
    }
    if (singHandMode === SingleHandMode.RIGHT) {
      return 1;
    }
    return 2;
  }

  private BuildSingleHandScreenInfo(): sceneSessionManager.SingleHandScreenInfo {
    let singleHandScreenInfo: sceneSessionManager.SingleHandScreenInfo = {
      scaleRatio: 0,
      scalePivotX: 0,
      scalePivotY: 0,
      singleHandMode: this.GetSingleHandStatusModeNum()
    };
    singleHandScreenInfo.singleHandMode = this.GetSingleHandStatusModeNum();
    if (this.GetCurrentMode() === SingleHandMode.MIDDLE) {
      singleHandScreenInfo.scaleRatio = Math.ceil(DEFAULT_SCALE * 100);
      singleHandScreenInfo.scalePivotX = this.originScreenWidth;
      singleHandScreenInfo.scalePivotY = this.originScreenHeight;
      return singleHandScreenInfo;
    }
    let transformInfo: TransformInfo = this.GetCurrentTransformInfo();
    singleHandScreenInfo.scaleRatio = Math.ceil(this.singleHandScale * 100);
    singleHandScreenInfo.scalePivotX = Math.ceil(transformInfo.pivotX);
    singleHandScreenInfo.scalePivotY = Math.ceil(transformInfo.pivotY);
    return singleHandScreenInfo;
  }

  /**
   * save snapShot when exitSingelHand
   */
  public saveSnapShotWhenExitSingelHand(): void {
    log.showInfo('saveSnapShotWhenExitSingelHand');
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (containerSessionList.isEmpty()) {
      return;
    }
    let sessionCount = 0;
    for (let i = containerSessionList.length - 1; i >= 0; i--) {
      if (containerSessionList[i].isTopmost() || containerSessionList[i].isFloat) {
          // ignore topmost container session
          continue;
      }
      this.saveSessionSnapShot(containerSessionList[i]);
      sessionCount++;
      if (sessionCount >= SNAPSHOT_SESSION_NUM) {
        log.showInfo(`save snapShot of the top ${SNAPSHOT_SESSION_NUM} session`);
        break;
      }
    }
  }

  private saveSessionSnapShot(curSession: SCBSceneContainerSession): void {
    let primarySession = curSession.primarySession;
    if (primarySession) {
      log.showInfo(`saveSnapshotAsync, primarySession: ${primarySession.session?.persistentId}`);
      primarySession.saveSnapshotAsync();
    }
    let secondarySession = curSession.secondarySession;
    if (secondarySession) {
      log.showInfo(`saveSnapshotAsync, secondarySession: ${secondarySession.session?.persistentId}`);
      secondarySession.saveSnapshotAsync();
    }
  }
}
