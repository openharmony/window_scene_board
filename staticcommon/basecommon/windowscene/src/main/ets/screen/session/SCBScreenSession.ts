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

import screenSessionManager from '@ohos.screenSessionManager';
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { EvtBus } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBScreenSessionManager, SCBPropertyChangeReason, SCBProductFuncType } from './SCBScreenSessionManager';
import { SCBSceneSessionManager, ScenePanelState, UIEffectZOrderType } from '../../scene/session/SCBSceneSessionManager';
import { SCBWindowRotateController } from '../../scene/manager/SCBWindowRotateController';
import display from '@ohos.display';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { sEventManager } from '@ohos/frameworkwrapper';
import { obtainLocalEvent } from '@ohos/frameworkwrapper';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBFollowDesktopOrientationPolicy } from '../../scene/session/SCBSceneOrientationPolicy';
import { SCBConstants } from '@ohos/commonconstants';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import json from '@ohos.util.json';
import { HashSet } from '@kit.ArkTS';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { SCBRotationController } from '../../rotation/SCBRotationController';
import notificationManager from '@ohos.notificationManager';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@kit.BasicServicesKit';
import { SCBRotationConfig, SCBSceneContainerSession } from '../../TsIndex';
import { SingleStartFrom } from '../../scene/session/SCBSceneContainerSession';
import osAccount from '@ohos.account.osAccount';
import { WinLog, WinLogDomain } from '../../utils/WinLog';
import { promptAction } from '@kit.ArkUI';

const TAG = 'SCBScreenSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const FOLD_MAIN_SCREEN_ID: number = 0;
const FOLD_OUTER_SCREEN_ID: number = 5;
const INVALID_SENSOR_ROTATION: number = -1;
const PLACED_SENSOR_ROTATION: number = -1;
const DEFAULT_RATIO: number = 2;
const DEFAULT_TIME_OUT: number = 1000;
const MODE_CHANGE_TIME_OUT: number = 300;
const DUAL_DISPLAY_FOLD_DEVICE_FLAG = '2';
const SINGLE_DISPLAY_POCKET_FOLD_DEVICE_FLAG = '4';
const BIG_SCREEN_DEVICE_FLAG = '5';
const SECONDARY_DISPLAY_FOLD_DEVICE_FLAG = '6';
const ROTATE_STRATEGY_WINDOW: number = 0;
const ROTATE_STRATEGY_SCREEN: number = 1;
const ROTATE_STRATEGY_VARIABLE: number = 2;
const ROTATE_POLICY: number = Number.parseInt(systemParameterEnhance.getSync('const.window.device.rotate_policy', '0'));
const FLODABLE_ROTATE_POLICY: string = systemParameterEnhance.getSync('const.window.foldabledevice.rotate_policy', '0,0');
const DISPLAY_POWER_EVENT_BEGIN_WAKE_UP = 0;
const DISPLAY_POWER_EVENT_BEGIN_SLEEP = 1;
const DISPLAY_POWER_EVENT_CANCEL_SCREEN_OFF = 7;
const FOLD_SCREEN_FLAG: String = systemParameterEnhance.getSync('const.window.foldscreen.type', '0,0,0,0');
const INVALID_HOVER_STATUS: number = -1;
const TENT_STATUS: number = 0;
const TENT_STATUS_CANCEL: number = 1;
const TENT_STATUS_HOVER: number = 4;
const PHY_ROTATION_OFFSET_ARRAY : string[] = systemParameterEnhance.getSync('const.window.phyrotation.offset', '0').split(';');
const SCREEN_SCAN_TYPE: number = Number.parseInt(systemParameterEnhance.getSync('const.window.screen.scan_type', '0'));
const SINGLE_DISPLAY_FOLDED_STATUS: number = 0;
const SINGLE_DISPLAY_EXPAND_STATUS: number = 1;
const SINGLE_DISPLAY_TENT_STATUS: number = 2;
const SINGLE_DISPLAY_TENT_HOVER_STATUS: number = 3;
const SINGLE_DISPLAY_OUTER_WIDTH: number = 980;
const UPPER_CALLER_DEPTH: number = 3;
const CONFIG_DEFAULT_SCREEN_ROTATION: number =
  Number.parseInt(systemParameterEnhance.getSync('const.window.device.default_screen_rotation', '-1'));
let FIRST_CONNECT: boolean = true;

function isVertical(rotation: number): boolean {
  return rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_180;
}

@Observed
export class SCBScreenProperty {
  left: number = 0;
  top: number = 0;
  width: number = 0;
  height: number = 0;
  radius: number = 0;
  rotation: number = 0;
  screenId: number = 0;
  rsId: number = 0;
  /**
   * 屏幕初始方向
   * @deprecated 正在整改，rotation为0时统一代表竖屏，90代表横屏,pc整改完成后不再需要通过此字段区分
   */
  defaultScreenOrientation: number = 0; // 0 means vertical, 1 means horizontal.
  private _rotationOffset: number = 0; // config param which means rotation offset of the screen
  private _correctingRotation: number = 0; // 校正角度，用于旋转动画校正，将角度值加/减360，让动画可以计算正确的角度
  private _defaultRotation: number = 0; // 默认角度，未指定方向时，屏幕的默认角度
  private translateX: number = 0;
  private translateY: number = 0;

  public get displayRotation(): number {
    const realRotation = (this.rotation + this._rotationOffset) % RotationConstants.ROTATION_360;
    log.showInfo(`rotation${this.rotation}, rotationOffset:${this._rotationOffset}`);
    return realRotation + this._correctingRotation;
  }

  public setRotationOffset(rotationOffset: number): void {
    this._rotationOffset = rotationOffset;
  }

  public setCorrectingRotation(rotation: number): void {
    this._correctingRotation = rotation;
  }

  // 设置期望显示的角度，按照屏幕坐标系计算。
  public setExpectDisplayRotation(rotation: number): void {
    this.rotation = (rotation - this._rotationOffset + RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
  }

  public clearCorrectingRotation(): void {
    this._correctingRotation = 0;
  }

  public getDefaultRotation(): number {
    return this._defaultRotation;
  }

  public setDefaultRotation(rotation: number): void {
    this._defaultRotation = rotation;
  }
  /**
   * Update screen property
   *
   * @param { screenSessionManager.ScreenProperty } screenProperty
   */
  public update(screenProperty: screenSessionManager.ScreenProperty): void {
    this.left = screenProperty.bounds.left;
    this.top = screenProperty.bounds.top;
    this.width = screenProperty.bounds.width;
    this.height = screenProperty.bounds.height;
    this.radius = screenProperty.bounds.radius;
    this.rotation = screenProperty.rotation;
  }

  /**
   * Update fake screen property
   *
   * @param { screenSessionManager.ScreenProperty } screenProperty
   */
  public updateFake(screenProperty: screenSessionManager.ScreenProperty): void {
    this.left = screenProperty.fakeBounds.left;
    this.top = screenProperty.fakeBounds.top;
    this.width = screenProperty.fakeBounds.width;
    this.height = screenProperty.fakeBounds.height;
    this.radius = screenProperty.fakeBounds.radius;
  }

  /**
   * Update the translation
   *
   * @param { Number } transX
   * @param { Number } transY
   */
  public updateTranslate(transX: number, transY: number): void {
    this.translateX = transX;
    this.translateY = transY;
  }

  /**
   * Copy the screen property
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public copy(screenProperty: SCBScreenProperty): void {
    this.left = screenProperty.left;
    this.top = screenProperty.top;
    this.width = screenProperty.width;
    this.height = screenProperty.height;
    this.radius = screenProperty.radius;
    this.rotation = screenProperty.rotation;
    this.screenId = screenProperty.screenId;
    this.translateX = screenProperty.translateX;
    this.translateY = screenProperty.translateY;
    this._rotationOffset = screenProperty._rotationOffset;
    this._defaultRotation = screenProperty._defaultRotation;
    this.rsId = screenProperty.rsId;
  }

  /**
   * Copy the screen bounds property
   *
   * @param { screenSessionManager.RRect } bounds
   */
  public copyBounds(bounds: screenSessionManager.RRect): void {
    this.left = bounds.left;
    this.top = bounds.top;
    this.width = bounds.width;
    this.height = bounds.height;
    this.radius = bounds.radius;
  }

  /**
   * Get X-axis of translation
   *
   * @returns { Number }
   */
  public getTranslateX(): number {
    return this.translateX;
  }

  /**
   * Get Y-axis of translation
   *
   * @returns { Number }
   */
  public getTranslateY(): number {
    return this.translateY;
  }

  /**
   * Get Whether the screen is vertical
   *
   * @returns { Boolean }
   */
  public isScreenVertical(): boolean {
    let productCallBacks: Function = SCBScreenSessionManager.getInstance().getScreenProductCallBackByType(SCBProductFuncType.IS_SCREEN_VERTICAL, this.screenId);
    if (productCallBacks) {
      return productCallBacks();
    }
    if (this.defaultScreenOrientation === 0) {
      return this.rotation === RotationConstants.ROTATION_0 || this.rotation === RotationConstants.ROTATION_180;
    } else {
      return this.rotation === RotationConstants.ROTATION_90 || this.rotation === RotationConstants.ROTATION_270;
    }
  }

  /**
   * initialize
   */
  public init(): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenId);
    if (!screenSession) {
      log.showError('SCBScreenProperty init failed since get screen session null with id: ' + this.screenId);
      this.copy(new SCBScreenProperty());
      return;
    }
    this.copyBounds(screenSession.physicalBounds);
    this.rotation = 0;
    this.translateX = 0;
    this.translateY = 0;
  }

  // get a copy of screen property after rotate, not modify origin screen property
  public getRotatedScreenProperty(targetRotation: number): SCBScreenProperty {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.copy(this);
    if (isVertical(this.rotation) !== isVertical(targetRotation)) {
      const tempWidth = screenProperty.width;
      screenProperty.width = screenProperty.height;
      screenProperty.height = tempWidth;
      let width = screenProperty.width;
      let height = screenProperty.height;
      let transX = screenProperty.getTranslateX();
      let transY = screenProperty.getTranslateY();
      transX -= (width - height) / 2;
      transY += (width - height) / 2;
      screenProperty.updateTranslate(transX, transY);
    }
    screenProperty.rotation = targetRotation;
    log.showWarn('this.rotation: ' + this.rotation + 'getRotatedScreenProperty: ' + JSON.stringify(screenProperty));
    return screenProperty;
  }

  // rotate self to targetRotation, this will update translate
  public rotateTo(targetRotation: number): void {
    let copyScreenProperty = this.getRotatedScreenProperty(targetRotation);
    this.copy(copyScreenProperty);
  }

  // get a copy of this screen property
  public getCopy(): SCBScreenProperty {
    let screenProperty = new SCBScreenProperty();
    screenProperty.copy(this);
    return screenProperty;
  }

  // get a copy bounds equal to screen property size
  public getCopyBounds(): screenSessionManager.RRect {
    return {
      left: this.left,
      top: this.top,
      width: this.width,
      height: this.height,
      radius: this.radius
    };
  }

  // 旋转前准备，将当前角度向前或向后移动一圈，让后面的旋转动效可以得到一个合适的旋转方向
  public prepareCorrectingRotationForRotate(toScreenProperty: SCBScreenProperty): void {
    if (this.displayRotation < toScreenProperty.displayRotation) {
      // 终止角度大于起始角度时，只需要判断相差超过或等于180时，将起始角度+360，让旋转使用小角度旋转
      if (toScreenProperty.displayRotation - this.displayRotation >= RotationConstants.ROTATION_180) {
        this.setCorrectingRotation(RotationConstants.ROTATION_360);
      }
    } else {
      // 终止角度小于起始角度时，如果反向旋转超过或等于180度，需要将起始角度-360，得到一个正向旋转的小角度
      if (this.displayRotation - toScreenProperty.displayRotation > RotationConstants.ROTATION_180) {
        this.setCorrectingRotation(-RotationConstants.ROTATION_360);
      }
    }
  }

  // get string for debug info
  public getLogString(): string {
    let logString: string =
      `screenId: ${this.screenId},width: ${this.width}, height: ${this.height}, rotation:${this.rotation},` +
      `translateX: ${this.translateX}, translateY: ${this.translateY}, rotationOffset${this._rotationOffset}`;
    return logString;
  }
}

class InnerData {
  _enableRotateExclusive: boolean = true;
  _enableRotate: boolean = true; // 是否允许旋转，某些模式下不允许旋转，如Pc模式
  _enableSensorRotate: boolean = true;
}

/**
 * Session of a screen.
 */
@Observed
export class SCBScreenSession {
  public session: screenSessionManager.ScreenSession;
  public rotationController: SCBRotationController = new SCBRotationController();
  /**
   * 屏幕初始方向
   * @deprecated 正在整改，rotation为0时统一代表竖屏，90代表横屏,pc整改完成后不再需要通过此字段区分
   */
  defaultScreenOrientation: number = 0; // 0 means vertical, 1 means horizontal.
  scbScreenProperty: SCBScreenProperty = new SCBScreenProperty(); // current virtual screen property
  sensorScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  scbFakeScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  currentSensorRotation: number = 0;
  private _isExpandStatus: boolean = false;
  private _rotationWhenLockAutoRotation: number = -1;
  private isScreenOrientationChange: boolean = false;
  public isRotatable: boolean = false;

  public get isExpandStatus(): boolean {
    return this._isExpandStatus;
  }

  private _isPhoneFolding: boolean = false;

  public get isPhoneFolding(): boolean {
    return this._isPhoneFolding;
  }

  private _isTentStatus: boolean = false;

  public get isTentStatus(): boolean {
    return this._isTentStatus;
  }

  private _isTentHoverStatus: boolean = false;

  public get isTentHoverStatus(): boolean {
    return this._isTentHoverStatus;
  }

  private _isCameraStatus: boolean = false;

  public get isCameraStatus(): boolean {
    return this._isCameraStatus;
  }

  //for single dispaly pocket
  public get currentPocketStatus(): number {
    if (this._isExpandStatus) {
      return SINGLE_DISPLAY_EXPAND_STATUS;
    }
    if (this.isTentHoverStatus) {
      return SINGLE_DISPLAY_TENT_HOVER_STATUS;
    } else if (this._isTentStatus) {
      return SINGLE_DISPLAY_TENT_STATUS;
    } else {
      return SINGLE_DISPLAY_FOLDED_STATUS;
    }
  }

  private _currentHoverStatus: number = -1;

  private _skipRotation?: number | undefined;

  public get skipRotation(): number | undefined {
    return this._skipRotation;
  }

  private _isScreenOff: boolean = false;

  public get isScreenOff(): boolean {
    return this._isScreenOff;
  }

  private _isExtendScreen: boolean = false;

  public get isExtendScreen(): boolean {
    return this._isExtendScreen;
  }

  public setScreenExtendStatus(status: boolean) : void {
    this._isExtendScreen = status;
  }

  private _isMainScreen: boolean = false;

  public get isMainScreen(): boolean {
    return this._isMainScreen;
  }

  public setScreenMainStatus(status: boolean) : void {
    this._isMainScreen = status;
  }

  private _isFakeInUse: boolean = false;

  public get isFakeInUse(): boolean {
    return this._isFakeInUse;
  }

  public setScreenFakeInUse(isFakeInUse: boolean) : void {
    this._isFakeInUse = isFakeInUse;
  }

  public get rotationWhenLockAutoRotation(): number {
    if (this._rotationWhenLockAutoRotation === -1) {
      this._rotationWhenLockAutoRotation = this.getScreenDefaultRotation();
    }
    return this._rotationWhenLockAutoRotation;
  }

  private _disableRotateReasonSet: HashSet<string> = new HashSet(); //存放禁止旋转的原因，做条件互斥
  private innerData: InnerData = new InnerData(); // 非UI绑定数据
  private _isFoldOuterScreen: boolean = false;
  private _isFoldMainScreen: boolean = false;
  private _isInStartSceneFromRecent: boolean = false;
  private _pendingSensorRotationFromRecent: number = 0;
  private _lastSensorRotationBeforeRecent: number = 0;

  public set lastSensorRotationBeforeRecent(lastSensorRotationBeforeRecent: number) {
    this._lastSensorRotationBeforeRecent = lastSensorRotationBeforeRecent;
  }

  public get lastSensorRotationBeforeRecent(): number {
    return this._lastSensorRotationBeforeRecent;
  }

  public set isInStartSceneFromRecent(isInStartSceneFromRecent: boolean) {
    this._isInStartSceneFromRecent = isInStartSceneFromRecent;
  }

  public get isInStartSceneFromRecent(): boolean {
    return this._isInStartSceneFromRecent;
  }

  public set pendingSensorRotationFromRecent(pendingSensorRotationFromRecent: number) {
    this._pendingSensorRotationFromRecent = pendingSensorRotationFromRecent;
  }

  public get pendingSensorRotationFromRecent(): number {
    return this._pendingSensorRotationFromRecent;
  }

  // Unit: px
  public bounds: screenSessionManager.RRect = {
    left: 0,
    top: 0,
    width: 0,
    height: 0,
    radius: 0
  };
  public physicalBounds: screenSessionManager.RRect = {
    left: 0,
    top: 0,
    width: 0,
    height: 0,
    radius: 0
  };
  public fakeBounds: screenSessionManager.RRect = {
    left: 0,
    top: 0,
    width: 0,
    height: 0,
    radius: 0
  };
  public availableArea: screenSessionManager.DMRect = {
    posX: 0,
    posY: 0,
    height: 0,
    width: 0
  };
  onPropertyChange: Function;
  onPowerStatusChange: Function;
  isInEmergencyOrThermalSafe: Function;

  /**
   * Constructor.
   * @param session Session of the screen
   */
  constructor(session: screenSessionManager.ScreenSession) {
    this.session = session;
    this.scbScreenProperty.screenId = this.session.screenId;
    this.sensorScreenProperty.screenId = this.session.screenId;
    this.handleFoldStatus();
    this.session.on('connect', (screenProperty: screenSessionManager.ScreenProperty) => {
      this.onScreenConnect(screenProperty);
    });
    this.session.on('disconnect', () => {
      this.onScreenDisconnect();
    });
    this.session.on('propertyChange', (screenProperty: screenSessionManager.ScreenProperty,
      reason: screenSessionManager.ScreenPropertyChangeReason) => {
      let changeReason: SCBPropertyChangeReason = this.getSCBPropertyChangeReason(reason);
      let beforeProperty = new SCBScreenProperty();
      beforeProperty.update(screenProperty);
      this.handleScreenPropertyChange(screenProperty, changeReason);
      this.scbScreenProperty.rsId = screenProperty.rsId;
      log.showInfo('propertyChange screenId: ' + this.session.screenId + ' reason:' + reason +
        ' changeReason:' + changeReason + ' screenProperty: ' + JSON.stringify(beforeProperty) +
        ' -> ' + JSON.stringify(screenProperty));  
    });
    this.registerPowerStatusChangeCallback();
    this.registerSensorRotationChangeCallback();
    this.session.on('screenOrientationChange', (screenOrientation: number) => {
      this.handleScreenOrientationChange(screenOrientation);
    });
    this.session.on('screenRotationLockedChange', (isLocked: boolean) => {
      SCBScreenSessionManager.getInstance().setScreenOrientationLocked(isLocked);
      log.showInfo('screenRotationLockedChange callback');
    });

    this.session.on('screenExtendChange', (mainScreenId: number, extendScreenId: number) => {
      log.showInfo(`screenExtendChange mainScreenId: ${mainScreenId} extendScreenId: ${extendScreenId}`);
      SCBScreenSessionManager.getInstance().setScreenMode(mainScreenId, extendScreenId);
    });

    this.session.on('extendScreenConnectStatusChange', (screenId: number,
        extendScreenConnectStatus: screenSessionManager.ExtendScreenConnectStatus) => {
      log.showInfo(`extendScreenConnectStatusChange screenId: ${screenId}` +
        `, extendScreenConnectStatus: ${extendScreenConnectStatus}`);
      this.handleExtendScreenConnectStatusChange(screenId, extendScreenConnectStatus);
    });

    this.session.on('screenCaptureNotify', (mainId: number, clientUid: number, client: string) => {
      log.showInfo(`screenCaptureNotify mainId: ${mainId} clientUid: ${clientUid} client: ${client}`);
      if (DeviceHelper.isPC() || DeviceHelper.isPad() || DeviceHelper.isPhone()) {
        this.sendScreenCaptureNotify(clientUid, client);
      }
    });
    this.session.on('screenModeChange', (screenModeChangeEvent: screenSessionManager.ScreenModeChangeEvent) => {
      log.showInfo(`screenModeChange screenModeChangeEvent: ${screenModeChangeEvent}`);
      this.handleScreenModeChange(screenModeChangeEvent);
    });

    try {
      display.on('foldStatusChange', (foldStatus: display.FoldStatus) => {
        SCBScreenSessionManager.getInstance().handleFoldStatusChange(foldStatus);
        log.showInfo(`handleFoldStatusChange callback foldStatus:${foldStatus}`);
      });
    } catch (error) {
      log.error('foldStatusChange on error', error);
    }
    EvtBus.on(ScreenOnOffEvent, this.handleScreenOnOffEvent);
  }

  /**
   * setSessionIsNull
  : void  */
  public setSessionIsNull() : void {
    log.showInfo(`setSessionIsNull`);
    this.session = null;
  }

  /**
   * setSessionRegisterOff
  : void  */
  public setSessionRegisterOff() : void {
    try {
      display.off('foldStatusChange');
    } catch (error) {
      log.error('foldStatusChange on error', error);
    }
    EvtBus.off(ScreenOnOffEvent, this.handleScreenOnOffEvent);
  }

  private handleScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    this._isScreenOff = event.isScreenOff();
    log.showInfo(`isScreenOff： ${this._isScreenOff}`);
  };



  private registerPowerStatusChangeCallback(): void {
    this.session.on('powerStatusChange', (displayPowerEvent: screenSessionManager.DisplayPowerEvent,
      eventStatus: screenSessionManager.EventStatus, reason: screenSessionManager.PowerStateChangeReason) => {
      if ((displayPowerEvent === DISPLAY_POWER_EVENT_BEGIN_WAKE_UP ||
        displayPowerEvent === DISPLAY_POWER_EVENT_CANCEL_SCREEN_OFF) && !this.getEnableSensorRotate()) {
        this.setEnableSensorRotate(true, 'wakeup');
      }
      if (displayPowerEvent === DISPLAY_POWER_EVENT_BEGIN_SLEEP && this.getEnableSensorRotate()) {
        this.setEnableSensorRotate(false, 'beginSleep');
      }
      log.showInfo(`powerStatusChange displayPowerEvent: ${displayPowerEvent}, eventStatus: ${eventStatus},` +
        ` reason: ${reason}`);
      this.handlePowerStatusChange(displayPowerEvent, eventStatus, reason);
      this.publishPowerEvent(displayPowerEvent, eventStatus, reason);
    });
  }

  private registerSensorRotationChangeCallback(): void {
    this.session.on('sensorRotationChange', (sensorRotation: number) => {
      let traceName = `[ROTATION] SCBScreenSession sensorRotationChange`;
      Trace.start(traceName);
      let oldSensorRotation: number = this.currentSensorRotation;
      this.currentSensorRotation = sensorRotation;
      if (sensorRotation === INVALID_SENSOR_ROTATION) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[registerSensorRotationChangeCallback] sensorRotation is invalid.');
        Trace.end(traceName);
        return;
      }
      this.notifySensorRotationToSub(sensorRotation);
      if (this.sensorScreenProperty.rotation === sensorRotation &&
        oldSensorRotation !== PLACED_SENSOR_ROTATION) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[registerSensorRotationChangeCallback] sensorRotation not change.');
        Trace.end(traceName);
        return;
      }
      if (this.isInStartSceneFromRecent) {
        this._pendingSensorRotationFromRecent = sensorRotation;
        this._lastSensorRotationBeforeRecent = this.sensorScreenProperty.rotation;
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[registerSensorRotationChangeCallback] cache sensorChange pendingSensorRotation: ' +
          sensorRotation + ' lastSensorRotation: ' + this.sensorScreenProperty.rotation);
        Trace.end(traceName);
        return;
      }
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[registerSensorRotationChangeCallback] sensorRotationChange: ${sensorRotation}, ` +
        `lastSensorRotation: ${this.sensorScreenProperty.rotation}`);
      this.handleSensorRotationChange(sensorRotation);
      Trace.end(traceName);
    });
  }

  private registerHoverStatusCallback(): void {
    this.session.on('hoverStatusChange', (hoverStatus: number, needRotate: boolean) => {
      log.showInfo(`registerHoverStatusCallback hoverStatus:${hoverStatus} needRotate:${needRotate}`);
      if (hoverStatus === INVALID_HOVER_STATUS) {
        log.showInfo(`registerHoverStatusCallback hoverStatus:${hoverStatus} is invalid`);
        return;
      }
      return;
    });
  }

  private handleHoverStatusRotationChange(hoverStatus: number, needRotate: boolean) : void {
    const isScreenOrientationLocked =
      SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.scbScreenProperty.screenId);
    log.showInfo(`hoverStatus:${hoverStatus}, isTentHoverStatus:${this._isTentHoverStatus}, ` +
      `isTentStatus:${this._isTentStatus}, isScreenOrientationLocked:${isScreenOrientationLocked}` +
      `needRotate:${needRotate}`);
    switch (hoverStatus) {
      // sensor transfer tent status
      case TENT_STATUS:
        this._isTentStatus = true;
        this._isTentHoverStatus = false;
        this._currentHoverStatus = TENT_STATUS;
        if (needRotate) {
          SCBWindowRotateController.getInstance().windowRotateEntry(RotationConstants.ROTATION_0, 'tent change rotation',
            true, true);
        }
        break;
      case TENT_STATUS_HOVER:
        this._isTentStatus = false;
        this._isTentHoverStatus = true;
        this._currentHoverStatus = TENT_STATUS_HOVER;
        if (needRotate) {
          SCBWindowRotateController.getInstance().windowRotateEntry(RotationConstants.ROTATION_180, 'hover change rotation',
            true, true);
        }
        break;
      case TENT_STATUS_CANCEL:
        this._isTentStatus = false;
        this._isTentHoverStatus = false;
        this._currentHoverStatus = TENT_STATUS_CANCEL;
        if (needRotate) {
            SCBWindowRotateController.getInstance().windowRotateEntry(RotationConstants.ROTATION_270, 'tent cancel, into lock',
              true, true);
        }
        log.showInfo(`tent status is cancel`);
        break;
      default :
        break;
    }
  }

  private registerCameraStatus(): void {
    let baseContext = GlobalContext.getContext();
    let cameraManager = camera.getCameraManager(baseContext);

    cameraManager.on('cameraStatus', (err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo) => {
      SCBScreenSessionManager.getInstance().setCameraStatus(<number>cameraStatusInfo.status,
        <number>cameraStatusInfo.camera.cameraPosition);
    });
  }

  private handleScreenPropertyChange(screenProperty: screenSessionManager.ScreenProperty,
    changeReason: SCBPropertyChangeReason): void {
    let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PHONE && changeReason === SCBPropertyChangeReason.ROTATION) {
      log.showError('phone propertyChange should not change because rotation.');
      return;
    }
    SCBScreenSessionManager.getInstance().updateFoldDisplayMode();
    let propertyAfter: SCBScreenProperty = new SCBScreenProperty();
    propertyAfter.update(screenProperty);
    if (changeReason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this._isExpandStatus = true;
      SCBScreenSessionManager.getInstance().notifyStartFoldToExpandChange(propertyAfter, changeReason);
      this.foldToExpandPropertyChange(screenProperty);
    } else if (changeReason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this._isExpandStatus = false;
      SCBScreenSessionManager.getInstance().notifyStartFoldToExpandChange(propertyAfter, changeReason);
      this.expandToFoldPropertyChange(screenProperty);
    } else {
      let reason: string = screenProperty.propertyChangeReason;
      let isFoldable = false;
      try {
        isFoldable = display.isFoldable();
      } catch (error) {
        log.error('Failed to retrieve foldable status', error);
      }
      if (changeReason === SCBPropertyChangeReason.CHANGE_MODE && reason === 'active mode change' &&
        isFoldable) {
        this.phoneActiveModeChange(screenProperty);
        return;
      }
      log.showInfo('handleScreenPropertyChange screenProperty=' + JSON.stringify(screenProperty));
      this.updatePhysicalProperty(screenProperty, changeReason);
    }
  }

  public getScreenPropertyLog(screenProperty: SCBScreenProperty): string {
    let logString: string = `left: ${screenProperty.left},top: ${screenProperty.top}, width: ${screenProperty.width},` +
      `height: ${screenProperty.height}, rotation: ${screenProperty.rotation}`;
    return logString;
  }
  private foldToExpandPropertyChange(screenProperty: screenSessionManager.ScreenProperty): void {
    this.handleHoverStatusRotationChange(TENT_STATUS_CANCEL, false);
    this.setFollowDesktopPolicy();
    screenProperty.rotation = this.calculateFoldablePhoneRotation(screenProperty.rotation);

    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
      if (this.isVertical(screenProperty.rotation)) {
        [screenProperty.bounds.width, screenProperty.bounds.height] =
          [screenProperty.bounds.height, screenProperty.bounds.width];
        this.updateDefaultRatioTranslate(screenProperty, this.scbScreenProperty);
      } else {
        this.scbScreenProperty.updateTranslate(0, 0);
      }
    } else if (this.isVertical(screenProperty.rotation)) {
      [screenProperty.bounds.width, screenProperty.bounds.height] =
        [screenProperty.bounds.height, screenProperty.bounds.width];
      this.scbScreenProperty.updateTranslate(0, 0);
    } else {
      this.updateDefaultRatioTranslate(screenProperty, this.scbScreenProperty);
    }
    this.updatePhysicalProperty(screenProperty, SCBPropertyChangeReason.FOLD_TO_EXPAND);
    this.sensorScreenProperty.copy(this.calculateScreenPropertyWithRotation(this.sensorScreenProperty.rotation));
    log.showInfo('handleScreenPropertyChange sensorProperty: ' + this.getScreenPropertyLog(this.sensorScreenProperty));
    if (SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.scbScreenProperty.screenId) &&
      this.scbScreenProperty.rotation === RotationConstants.ROTATION_0) {
      this.recordRotationWhenLockAutoRotation();
    }
    // need rotate to sensor rotation after expand
    setTimeout(() => {
      if (this.currentSensorRotation === INVALID_SENSOR_ROTATION) {
        let foldScreenRotation = this.scbScreenProperty.rotation;
        this.coverPhoneSensorRotation(foldScreenRotation);
        log.showInfo(`currentSensorRotation is invalid sensor rotation, foldScreenRotation: ${foldScreenRotation}`);
      } else {
        log.showInfo('rotationChangeEntry sensorProperty: ' +
        this.getScreenPropertyLog(this.sensorScreenProperty) + 'currentSensorRotation:' + this.currentSensorRotation);
        this.rotationChangeEntry(this.sensorScreenProperty.rotation, 'foldToExpand rotation change');
      }
    }, DEFAULT_TIME_OUT);
  }

  private singleDisplayPocketFoldToExpand(screenProperty: screenSessionManager.ScreenProperty): void {
    this.setFollowDesktopPolicy();
    let topSession = SCBSceneSessionManager.getInstance().getTopActiveContainerSession();
    let screenOrientationLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
    log.showInfo('singleDisplayPocketFoldToExpand: topSession = ' + topSession?.getBundleName() +
      ' screenOrientationLocked = ' + screenOrientationLocked);
    if (screenOrientationLocked && topSession && SCBSceneSessionManager.getInstance().isExpectedState(
      this.scbScreenProperty.screenId, ScenePanelState.FULLSCENE)) {
      let targetRotationWithScreenLocked = topSession.getTargetRotationWithScreenLocked(this.sensorScreenProperty);
      if (targetRotationWithScreenLocked !== RotationConstants.ROTATION_INVALIDED) {
        screenProperty.rotation = targetRotationWithScreenLocked;
      } else {
        screenProperty.rotation =
          SCBSceneSessionManager.getInstance().getPhoneTargetRotation(this.sensorScreenProperty.rotation,
            screenProperty.rotation, this.scbScreenProperty.screenId, true)[1];
      }
    } else {
      screenProperty.rotation =
        SCBSceneSessionManager.getInstance().getPhoneTargetRotation(this.sensorScreenProperty.rotation,
          screenProperty.rotation, this.scbScreenProperty.screenId, true)[1];
    }
    SCBSceneSessionManager.getInstance().setScreenLockWithFoldPersistentId(-1);
    log.showInfo('sensor rotation:' + this.sensorScreenProperty.rotation + 'targetRotation:' + screenProperty.rotation);
    this.physicalBounds = {
      left: screenProperty.bounds.left,
      top: screenProperty.bounds.top,
      width: screenProperty.bounds.width,
      height: screenProperty.bounds.height,
      radius: screenProperty.bounds.radius
    };
    let propertyAfter: SCBScreenProperty = new SCBScreenProperty();
    if (!this.isVertical(screenProperty.rotation)) {
      [screenProperty.bounds.width, screenProperty.bounds.height] =
        [screenProperty.bounds.height, screenProperty.bounds.width];
      this.updateDefaultRatioTranslate(screenProperty, propertyAfter);
    } else {
      propertyAfter.updateTranslate(0, 0);
    }
    propertyAfter.update(screenProperty);
    this.updateVirtualProperty(propertyAfter, SCBPropertyChangeReason.FOLD_TO_EXPAND, true);
    this.sensorScreenProperty.copy(this.calculateScreenPropertyWithRotation(this.sensorScreenProperty.rotation));
    setTimeout(() => {
      log.showInfo('handleScreenPropertyChange sensorProperty: ' +
      this.getScreenPropertyLog(this.sensorScreenProperty) + ' currentSensorRotation:' + this.currentSensorRotation);
      // need fix rotation when fold complete at the level
      if (this.currentSensorRotation === INVALID_SENSOR_ROTATION) {
        let expandScreenRotation = this.scbScreenProperty.rotation;
        this.coverPhoneSensorRotation(expandScreenRotation);
      }
    }, DEFAULT_TIME_OUT);
  }

  private expandToFoldPropertyChange(screenProperty: screenSessionManager.ScreenProperty): void {
    this._isPhoneFolding = true;
    this.setFollowDesktopPolicy();
    this.updateScreenPropertyRotationIfNeeded(screenProperty);
    this.physicalBounds = {
      left: screenProperty.bounds.left,
      top: screenProperty.bounds.top,
      width: screenProperty.bounds.width,
      height: screenProperty.bounds.height,
      radius: screenProperty.bounds.radius
    };
    let propertyAfter: SCBScreenProperty = new SCBScreenProperty();
    if (!this.isVertical(screenProperty.rotation)) {
      [screenProperty.bounds.width, screenProperty.bounds.height] =
        [screenProperty.bounds.height, screenProperty.bounds.width];
      this.updateDefaultRatioTranslate(screenProperty, propertyAfter);
    } else {
      propertyAfter.updateTranslate(0, 0);
    }
    propertyAfter.update(screenProperty);
    this.updateVirtualProperty(propertyAfter, SCBPropertyChangeReason.EXPAND_TO_FOLD, true);
    this.sensorScreenProperty.copy(this.calculateScreenPropertyWithRotation(this.sensorScreenProperty.rotation));
    setTimeout(() => {
      log.showInfo('handleScreenPropertyChange sensorProperty: ' +
      this.getScreenPropertyLog(this.sensorScreenProperty) + ' currentSensorRotation:' + this.currentSensorRotation);
      // need fix rotation when fold complete at the level
      if (this.currentSensorRotation === INVALID_SENSOR_ROTATION) {
        this.coverPhoneSensorRotation(propertyAfter.rotation);
      }
    }, DEFAULT_TIME_OUT);
    this._isPhoneFolding = false;
  }

  private isFixedRotationByConfig(): boolean {
    return SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn() &&
      // 如果配置的是合法的角度值则返回true, 固定到该角度
      SCBRotationConfig.getInstance().getDeviceFixedRotation(this) !== RotationConstants.ROTATION_INVALIDED;
  }

  private getFoldActiveSession(): SCBSceneContainerSession {
    let topSession = SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession();
    if (topSession) {
      return topSession;
    }
    let activeList = SCBSceneSessionManager.getInstance().getActiveSessionList();
    if (!activeList || activeList.length === 0) {
      log.showInfo('getFoldActiveSession activeList is null');
      return null;
    }
    let lastActiveId = activeList[activeList.length - 1];
    let activeSession = SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(lastActiveId);
    if (activeSession) {
      log.showInfo('getFoldActiveSession bundleName = ' + activeSession.getBundleName() + ' currentRotation = ' + activeSession.currentRotation +
        ' orientation = ' + activeSession.requestOrientation);
      return activeSession;
    }
    log.showInfo('getFoldActiveSession activeSession is null');
    return null;
  }

  private phoneActiveModeChange(screenProperty: screenSessionManager.ScreenProperty): void {
    let propertyAfter: SCBScreenProperty = new SCBScreenProperty();
    propertyAfter.update(screenProperty);
    if (this._isExpandStatus) {
      log.showInfo(`expandStatus active mode change.`);
      let rotation = this.resumeFoldablePhoneRotation(propertyAfter.rotation);
      propertyAfter = this.scbScreenProperty.getRotatedScreenProperty(rotation);
      this.physicalBounds = this.scbScreenProperty.getCopyBounds();
      setTimeout(() => {
        this.updateVirtualProperty(propertyAfter, SCBPropertyChangeReason.FOLD_SCREEN_ROTATION, true);
      }, MODE_CHANGE_TIME_OUT);
    } else {
      log.showInfo(`foldStatus active mode change.`);
      let sensorProperty = this.calculateScreenPropertyWithRotation(screenProperty.rotation);
      this.updateVirtualProperty(sensorProperty, SCBPropertyChangeReason.ROTATION, true);
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(sensorProperty);
    }
  }

  private handleExtendScreenConnectStatusChange(screenId: number,
      extendScreenConnectStatus: screenSessionManager.ExtendScreenConnectStatus): void {
    SCBScreenSessionManager.getInstance().triggerExtendScreenConnectStatusChange(screenId, extendScreenConnectStatus);
  }

  private handleScreenModeChange(screenModeChangeEvent: screenSessionManager.ScreenModeChangeEvent): void {
    SCBScreenSessionManager.getInstance().triggerMultiScreenModeChange(screenModeChangeEvent);
  }

  private setFollowDesktopPolicy(): void {
    if (this.isRotateScreenPolicy() || SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this)) {
      SCBFollowDesktopOrientationPolicy.getInstance().setRotationPolicy(
        true, true, true, true);
    } else {
      SCBFollowDesktopOrientationPolicy.getInstance().setRotationPolicy(
        false, true, false, false);
    }
  }

  public setTouchEnabled(isEnabled: boolean): void {
    if (this.session) {
      log.showInfo('setTouchEnabled isEnabled:' + JSON.stringify(isEnabled));
      this.session.setTouchEnabled(isEnabled);
    }
  }

  private updateScreenPropertyRotationIfNeeded(screenProperty: screenSessionManager.ScreenProperty): void {
    const topSession = SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession();
    if (topSession && topSession.isSplit) {
      if (screenProperty.rotation === RotationConstants.ROTATION_180 || topSession.isOneStepSplit()) {
        // split not support 180
        screenProperty.rotation = RotationConstants.ROTATION_0;
      }
      return;
    }
    // fix if not need rotate
    if (!SCBSceneSessionManager.getInstance().getPhoneTargetRotation(screenProperty.rotation,
      RotationConstants.ROTATION_0, this.scbScreenProperty.screenId)[0]) {
      screenProperty.rotation = RotationConstants.ROTATION_0;
      return;
    }
  }

  private handlePowerStatusChange(displayPowerEvent: number, eventStatus: number, reason: number): void {
    this.onPowerStatusChange && this.onPowerStatusChange(displayPowerEvent, eventStatus, reason);
  }

  private handleFoldStatus(): void {
    // @ts-ignore
    let foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (error) {
      log.error('constructor failed', error);
    }
    // @ts-ignore
    if (foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN ||
      // @ts-ignore
      foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this._isExpandStatus = false;
    } else {
      this._isExpandStatus = true;
    }
  }

  private publishPowerEvent(displayPowerEvent: screenSessionManager.DisplayPowerEvent, eventStatus:
    screenSessionManager.EventStatus, reason: screenSessionManager.PowerStateChangeReason): void {
    sEventManager.publish(obtainLocalEvent('powerStatusChange', {
      displayPowerEvent: displayPowerEvent,
      eventStatus: eventStatus,
      reason: reason
    }));
  }

  /**
   * handleCacheSensorRotationChange
   *
   */
  public handleCacheSensorRotationChange(): void {
    this._isInStartSceneFromRecent = false;
    let lastSensorRotationBeforeRecent = this._lastSensorRotationBeforeRecent;
    let pendingSensorRotationFromRecent = this._pendingSensorRotationFromRecent;
    if (pendingSensorRotationFromRecent !== lastSensorRotationBeforeRecent) {
      this.handleSensorRotationChange(pendingSensorRotationFromRecent);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[handleCacheSensorRotationChange] need excute sensorChange pendingSensorRotation: ' +
        pendingSensorRotationFromRecent + ' lastSensorRotation: ' + lastSensorRotationBeforeRecent);
    }
    this._pendingSensorRotationFromRecent = 0;
    this._lastSensorRotationBeforeRecent = 0;
  }

  /**
   * Handle sensor rotation changes.This interface will be gradually deprecated and should not be called directly.
   *
   * @param { Number } sensorRotation
   */
  private handleSensorRotationChange(sensorRotation: number): void {
    WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[handleSensorRotationChange] sensorRotation: ' + sensorRotation);
    this.updateSensorProperty(sensorRotation);
    if ((!this.getEnableSensorRotate()) || (!this.getEnableRotate()) || !(this.isEnableRotatoinExclusive())) {
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[handleSensorRotationChange] sensor rotate is disabled return.');
      return;
    }
    this.rotationChangeEntry(sensorRotation, 'sensor rotation change');
  }

  private getRotatePolicy(): number {
    if (ROTATE_POLICY !== ROTATE_STRATEGY_VARIABLE) {
      return ROTATE_POLICY;
    }
    let foldablePolicyArr: string[] = FLODABLE_ROTATE_POLICY.toString().split(',');
    if (this.isExpandStatus) {
      return Number.parseInt(foldablePolicyArr[1]); // 索引1代表展开态旋转策略
    }
    return Number.parseInt(foldablePolicyArr[0]); // 索引0代表折叠态旋转策略
  }

  /**
   * sensor rotation changes entry.
   *
   * @param sensorRotation
   * @param rotateReasonDescription.This parameter describes the reason for calling the interface and cannot be empty.
   */
  public rotationChangeEntry(sensorRotation: number, rotateReasonDescription: string,
    isScreenOrientationChange: boolean = false): void {
    let traceName: string = 'rotationChangeEntry: ' + this.getCallerStack();
    Trace.start(traceName);
    this.isScreenOrientationChange = isScreenOrientationChange;
    let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC) {
      log.showInfo('is PC, no need rotate');
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeEntry] sensorRotation: ' + sensorRotation +
      ' reason:' + rotateReasonDescription);
    let rotatePolicy = this.getRotatePolicy();
    if (rotatePolicy === ROTATE_STRATEGY_WINDOW) {
      this.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
    } else {
      this.rotationChangeByScreen(sensorRotation, rotateReasonDescription);
    }
    Trace.end(traceName);
  }

  // 屏幕旋转入口。供窗口内部使用,禁止其他业务调用,外部业务使用rotationChangeEntry
  public rotationChangeByScreen(sensorRotation: number, rotateReasonDescription: string,
                                needAnimation: boolean = true, isForce: boolean = false,
                                needNotify: boolean = true, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[rotationChangeByScreen] sensorRotation: ${sensorRotation}, ` +
                 `rotateReasonDescription:${rotateReasonDescription} ` +
                 `isPageRotation:${isPageRotation}`);
    // 屏幕旋转入口
    if (this.isSuspendRotate(rotateReasonDescription)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeByScreen] rotationChangeByScreen rotate is disabled return.');
      return;
    }
    if (isForce) {
      this.forceRotate(sensorRotation, rotateReasonDescription, needAnimation, needNotify, isPageRotation);
      return;
    }
    let curScreenRotation = this.scbScreenProperty.rotation;
    if (sensorRotation === curScreenRotation) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeByScreen] no need rotate with same rotation: ' + sensorRotation);
      return;
    }
    let needRotate = SCBSceneSessionManager.getInstance().isScreenNeedRotate(sensorRotation, curScreenRotation,
        this.scbScreenProperty.screenId);
    if (!needRotate) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeByScreen] screen no need rotate return');
      return;
    }
    this.rotateScreenToRotation(sensorRotation, needAnimation, needNotify, rotateReasonDescription, isPageRotation);
    return;
  }

  private forceRotate(sensorRotation: number, rotateReasonDescription: string,
    needAnimation: boolean = true, needNotify: boolean = true, isPageRotation: boolean = false): void {
    if (this.isFixedRotation(rotateReasonDescription)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[forceRotate] fixed rotation no need rotate');
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[forceRotate] force rotate');
    this.rotateScreenToRotation(sensorRotation, needAnimation, needNotify, rotateReasonDescription, isPageRotation);
  }

  private isFixedRotation(rotateReasonDescription: string): boolean {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      if (SCBRotationConfig.getInstance().getDeviceFixedRotation(this) !== -1 &&
        !this.getForceRotationlist(rotateReasonDescription)) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[isFixedRotation] single display pocket folded no need rotate');
        return true;
      }
      return false;
    }
    return false;
  }

  // force rotate screen to specific rotation for pc mode
  public forceRotateForPcMode(sensorRotation: number, rotateReasonDescription: string): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[forceRotateForPcMode] curRotation: ${this.scbScreenProperty.rotation}, ` +
                 `toRotation: ${sensorRotation}, rotateReasonDescription: ${rotateReasonDescription}`);
    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
      SCBWindowRotateController.getInstance().windowRotateEntry(sensorRotation,
        rotateReasonDescription, true, true, true, true);
      return;
    }
    this.rotateScreenToRotation(sensorRotation, true, true, rotateReasonDescription);
  }

  public rotationChangeByWindow(sensorRotation: number, rotateReasonDescription: string): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeByWindow] window rotation');

    if (this._isFoldOuterScreen) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeByWindow] foldouter screen rotation');
      this.sensorRotationChangeWithSub(sensorRotation);
      return;
    }
    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationChangeByWindow] screen rotation to window rotation');
      SCBWindowRotateController.getInstance().windowRotateEntry(sensorRotation, rotateReasonDescription);
      return;
    }
    this.sensorRotationChange(sensorRotation, rotateReasonDescription);
  }

  // 屏幕旋转方案，将屏幕旋转到指定角度
  private rotateScreenToRotation(rotation: number, needAnimation: boolean = true, needNotify: boolean = true,
    rotateReasonDescription: string, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenToRotation] rotate screen to: ' + rotation + ',rotateReasonDescription: ' +
      rotateReasonDescription + ',needAnimation: ' + needAnimation + ',isPageRotation: ' + isPageRotation);
    AppStorage.setOrCreate('screenRotation', rotation);
    if (rotateReasonDescription === 'sensor rotation change') {
      let bundleName = SCBSceneSessionManager.getInstance().getContainerSessionList(this.scbScreenProperty.screenId)
        .getTopActiveSession()?.primarySession?.sceneInfo.bundleName;
      HiSysEventUtil.reportRotationChange(bundleName, this.scbScreenProperty.rotation, rotation,
        HiSysEventUtil.ROTATION_TYPE_SENSOR);
    }
    let propertyAfter = this.scbScreenProperty.getRotatedScreenProperty(rotation);
    this.physicalBounds = this.scbScreenProperty.getCopyBounds();
    let reason = needAnimation ? SCBPropertyChangeReason.FOLD_SCREEN_ROTATION : SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
    if (isPageRotation) {
      reason = SCBPropertyChangeReason.PAGE_ROTATION;
    }
    this.updateVirtualProperty(propertyAfter, reason, needNotify);
  }

  private getRotationReasonIsTrustlist(rotateReasonDescription: string): boolean {
    return (rotateReasonDescription === 'scenePanelStartScene') ||
      (rotateReasonDescription === 'singlePocketScreenLock') ||
      (rotateReasonDescription === 'scenePanelExitScene') ||
      (rotateReasonDescription === 'screenRotateLandscapeStart') ||
      (rotateReasonDescription === 'tent change rotation') ||
      (rotateReasonDescription === 'tent cancel, into lock') ||
      (rotateReasonDescription === 'fold state manager force rotate') ||
      (rotateReasonDescription === 'extend screen connect force rotate to 270') ||
      (rotateReasonDescription === 'hover change rotation');
  }

  private getForceRotationlist(rotateReasonDescription: string): boolean {
    return (rotateReasonDescription === 'tent change rotation') ||
      (rotateReasonDescription === 'camera change rotation') ||
      (rotateReasonDescription === 'tent cancel, into lock') ||
      (rotateReasonDescription === 'tent cancel, into camera') ||
      (rotateReasonDescription === 'camera cancel, into tent') ||
      (rotateReasonDescription === 'camera cancel, into lock') ||
      (rotateReasonDescription === 'hover change rotation');
  }

  public isSuspendRotate(rotateReasonDescription: string): boolean {
    return (!this.getEnableRotate()) && (!this.getRotationReasonIsTrustlist(rotateReasonDescription));
  }

  // 更新跟随sensor的屏幕属性
  private updateSensorProperty(sensorRotation: number): void {
    let propertyAfter = this.scbScreenProperty.getRotatedScreenProperty(sensorRotation);
    this.sensorScreenProperty.copy(propertyAfter);
  }

  private handleScreenOrientationChange(screenOrientation: number): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC) {
      return;
    }
    this.rotationChangeEntry(screenOrientation, 'screen orientation change', true);
  }

  private async sendScreenCaptureNotify(appUid: number, bundleName: string): Promise<void> {
    if (!appUid || !bundleName) {
      log.showError('get appUid or bundleName error');
      return;
    }
    let userId = await osAccount.getAccountManager().getOsAccountLocalIdFromUid(appUid);
    let title: string = '';
    let content: string = '';
    let appName: string = this.getAppNameFromBMS(bundleName) ?? bundleName;
    log.showInfo(`appName: ${appName}, userId: ${userId}`);
    try {
      let resourceManager = GlobalContext.getContext().resourceManager;
      title = resourceManager.getStringByNameSync('screen_capture_notification_title');
      content = resourceManager.getStringByNameSync('screen_capture_notification_content', appName);
    } catch (err) {
      log.showError('publishScreenCaptureNtf failed.', err);
      return;
    }
    if (DeviceHelper.isPhone()) {
      this.showScreenCaptureWarn(content);
    } else if (DeviceHelper.isPC() || DeviceHelper.isPad()) {
      this.sendScreenCaptureMessageToNotification(appUid, userId, title, content);
    }
  }

  private sendScreenCaptureMessageToNotification(appUid: number, userId: number, title: string, content: string): void {
    let screenCaptureNtfRequest: notificationManager.NotificationRequest = {
      id: appUid,
      creatorUserId: userId,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: content
        }
      },
    };
    try {
      notificationManager.publish(screenCaptureNtfRequest, (err) => {
        if (err) {
          log.showError('publishScreenCaptureNtf failed.', err);
          return;
        }
        log.showInfo(`publishScreenCaptureNtf success`);
      });
    } catch (err) {
      log.showError('publishScreenCaptureNtf failed.', err);
    }
  }

  private showScreenCaptureWarn(content: string): void {
    if (!content) {
      log.showError('content is invalid');
      return;
    }
    SCBSceneSessionManager.getInstance().triggerScreenCaptureWarnAnimate();
    try {
      promptAction.showToast({
        message: content,
        showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST
      });
    } catch (err) {
      log.showError('showScreenCaptureToast failed.', err);
    }
  }

  private getAppNameFromBMS(bundleName: string): string {
    let bundleFlags = bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL;
    let appName: string = '';
    try {
      let resourceInfo = bundleResourceManager.getBundleResourceInfo(bundleName, bundleFlags);
      appName = resourceInfo?.label;
    } catch (errData) {
      log.showError('getAppNameFromBMS error ', errData, `bundleName: ${bundleName}`);
    }
    return appName;
  }

  private notifySensorRotationToSub(sensorRotation: number): void {
    if (!this._isFoldMainScreen) {
      return;
    }
    if (display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN) {
      log.showInfo('current screen is inner, no need response outter screen sensor rotation.');
      return;
    }
    let foldOuterScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(FOLD_OUTER_SCREEN_ID);
    if (foldOuterScreenSession) {
      foldOuterScreenSession.handleSensorRotationChange(sensorRotation);
    } else {
      log.showError('notifySensorRotationToSub fail, foldOuterScreenSession is null');
    }
  }

  private sensorRotationChangeWithSub(sensorRotation: number): void {
    if (this.session.screenId !== FOLD_OUTER_SCREEN_ID) {
      return;
    }
    let sensorProperty = this.calculateScreenPropertyWithRotation(sensorRotation);
    this.updateVirtualProperty(sensorProperty, SCBPropertyChangeReason.ROTATION, true);
    this.sensorScreenProperty.copy(sensorProperty);
    log.showInfo('sensorRotationChangeWithSub sensorRotation: ' + sensorRotation);
  }

  /**
   * Register the property change event
   *
   * @param { Function } func
   */
  public registerPropertyChange(func: Function): void {
    log.showInfo('registerPropertyChange:' + func + ', property:' + JSON.stringify(this.scbScreenProperty));
    this.onPropertyChange = func;
    this.onPropertyChange && this.onPropertyChange(this.scbScreenProperty,
      this._isExpandStatus ? SCBPropertyChangeReason.FOLD_SCREEN_CONNECT :
      SCBPropertyChangeReason.SCREEN_CONNECT);
  }

  /**
   * 注册是否处于应急或热安全模式
   * @param func
   */
  public registerIsInEmergencyOrThermalSafe(func: Function): void {
    this.isInEmergencyOrThermalSafe = func;
  }

  // 判断是否使用屏幕旋转方案
  public isRotateScreenPolicy(): boolean {
    return this.getRotatePolicy() === ROTATE_STRATEGY_SCREEN;
  }

  // 判断是否使用窗口旋转方案
  public isRotateWindowPolicy(): boolean {
    return this.getRotatePolicy() === ROTATE_STRATEGY_WINDOW;
  }

  /**
   * register the screen power status change event
   *
   * @param { Function } func
   */
  public registerScreenPowerStatusChange(func: Function): void {
    log.showInfo('registerPowerStatusChange ');
    this.onPowerStatusChange = func;
  }

  /**
   * Update the physical property
   *
   * @param { screenSessionManager.ScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   */
  public updatePhysicalProperty(screenProperty: screenSessionManager.ScreenProperty,
    reason: SCBPropertyChangeReason): void {
    this.scbScreenProperty.setRotationOffset(this.getScreenDefaultRotationOffset());
    this.scbScreenProperty.setDefaultRotation(this.getScreenDefaultRotation());
    this.scbScreenProperty.rsId = screenProperty.rsId;
    const expectRotation = screenProperty.rotation;
    this.scbScreenProperty.update(screenProperty); // not update translate
    this.bounds = this.scbScreenProperty.getCopyBounds();
    this.physicalBounds = this.scbScreenProperty.getCopyBounds();
    this.scbScreenProperty.setExpectDisplayRotation(expectRotation);
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let fixedRotation: number = SCBRotationConfig.getInstance().getDeviceFixedRotation(this);
      if (fixedRotation !== -1) {
        this.scbScreenProperty.rotation = fixedRotation;
        log.showInfo(`SingleDisplayPocketFold fixedRotation: ${fixedRotation}`);
      }
    }
    log.showInfo('updatePhysicalProperty: ' + JSON.stringify(this.scbScreenProperty) +
      ' rotation: ' + this.scbScreenProperty.rotation + ' reason: ' + reason +
      ' isExpandStatus: ' + this._isExpandStatus);
    if (this.onPropertyChange) {
      log.showInfo('onPropertyChange is defined and call back.');
      this.onPropertyChange(this.scbScreenProperty, reason, true);
    } else {
      log.showError('onPropertyChange is undefined.');
    }
  }

  /**
   * update Virtual Property
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @param { Boolean } needNotify
   */
  public updateVirtualProperty(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason,
    needNotify: boolean): void {
    this.bounds = {
      left: screenProperty.left,
      top: screenProperty.top,
      width: screenProperty.width,
      height: screenProperty.height,
      radius: screenProperty.radius
    };
    this.scbScreenProperty.copy(screenProperty); // fix
    log.showInfo('updateVirtualProperty [' + this.bounds.left + ', ' + this.bounds.top + ', ' +
    this.bounds.width + ', ' + this.bounds.height + '] rotation: ' + this.scbScreenProperty.rotation +
      ' needNotify: ' + needNotify + ' reason: ' + reason);
    this.onPropertyChange && this.onPropertyChange(this.scbScreenProperty, reason, needNotify);
  }

  /**
   * update scbScreenProperty by rotation
   *
   * @param { number } rotation
   */
  public updateScbScreenPropertyByRotation(rotation: number): void {
    let propertyAfter = this.scbScreenProperty.getRotatedScreenProperty(rotation);
    this.bounds = {
      left: propertyAfter.left,
      top: propertyAfter.top,
      width: propertyAfter.width,
      height: propertyAfter.height,
      radius: propertyAfter.radius
    };
    this.scbScreenProperty.copy(propertyAfter);
    log.showInfo('updateScbScreenPropertyByRotation :' + JSON.stringify(this.scbScreenProperty) +
      ' rotation: ' + rotation);
  }

  // 屏幕连接
  private onScreenConnect(screenProperty: screenSessionManager.ScreenProperty): void {
    log.showInfo('On screen connection. screenProperty: ' + JSON.stringify(screenProperty) +
      ' isExpandStatus:' + this.isExpandStatus);
    this.setFollowDesktopPolicy();
    // 平板竖扫屏需要特殊处理
    this.adjustScreenScanVertical(screenProperty);
    // HPR 横屏启动，横屏启动的时候设置偏移、只有主屏走进来
    let width = screenProperty.bounds.width;
    let height = screenProperty.bounds.height;
    // 大屏幕机展开态connect会上报竖屏(sensor0°)，其他上报扫描方向为0°时的宽高
    if (this.isExpandStatus) {
      let currentRotation = screenProperty.rotation;
      screenProperty.rotation = this.calculateFoldablePhoneRotation(currentRotation);
      // 非整屏旋转时，计算偏移
      if (!SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this)) {
        this.updateDefaultRatioTranslate(screenProperty, this.scbScreenProperty);
      }
    }
    let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy(this)) {
      if (uiType === SCBConstants.UITYPE_PAD &&
        (this.getScreenDefaultRotationOffset() === RotationConstants.ROTATION_90 ||
          this.getScreenDefaultRotationOffset() === RotationConstants.ROTATION_270 ||
          SCREEN_SCAN_TYPE === SCBConstants.SCREEN_SCAN_TYPE_VERTICAL)) {
        this.updateDefaultRatioTranslate(screenProperty, this.scbScreenProperty);
      } else {
        this.scbScreenProperty.updateTranslate(0, 0);
      }
    }
    this.updatePhysicalProperty(screenProperty, SCBPropertyChangeReason.SCREEN_CONNECT);
    this.sensorScreenProperty.copy(this.scbScreenProperty);
    this.scbFakeScreenProperty.updateFake(screenProperty);
  }

  private adjustScreenScanVertical(screenProperty: screenSessionManager.ScreenProperty): void {
    if (SCREEN_SCAN_TYPE === SCBConstants.SCREEN_SCAN_TYPE_VERTICAL) {
      // 隐私空间功能会二次进入，不需要替换宽高
      if (screenProperty.bounds.width < screenProperty.bounds.height) {
        let tmp = screenProperty.bounds.width;
        screenProperty.bounds.width = screenProperty.bounds.height;
        screenProperty.bounds.height = tmp;
      }
      screenProperty.rotation = RotationConstants.ROTATION_270;
      if (this.isRotateScreenPolicy()) {
        this.updateDefaultRatioTranslate(screenProperty, this.scbScreenProperty);
      }
    }
  }

  private updateDefaultRatioTranslate(screenProperty: screenSessionManager.ScreenProperty,
    needUpdateScreenProperty: SCBScreenProperty): void {
    let transX = -(screenProperty.bounds.width - screenProperty.bounds.height) / DEFAULT_RATIO;
    let transY = (screenProperty.bounds.width - screenProperty.bounds.height) / DEFAULT_RATIO;
    needUpdateScreenProperty.updateTranslate(transX, transY);
  }

  private onScreenDisconnect(): void {
    log.showInfo('On screen disconnection.');
  }

  private getPhysicalRotationOffset(): number {
    let offset: number = Number.parseInt(PHY_ROTATION_OFFSET_ARRAY[0]);
    if (PHY_ROTATION_OFFSET_ARRAY.length > 1 && this.isExpandStatus) {
      offset = Number.parseInt(PHY_ROTATION_OFFSET_ARRAY[1]);
    }
    log.showInfo('getPhysicalRotationOffset :' + offset + ' isExpandStatus: ' + this.isExpandStatus);
    return offset;
  }

  // 根据旋转策略、相对sensor的自然角度, 获取屏幕控件的角度
  public getScreenComponentRotation(rotation: number): number {
    let screenComponentRotation: number = 0;
    if (this.isRotateScreenPolicy()) {
      screenComponentRotation = (rotation + this.getPhysicalRotationOffset()) % RotationConstants.ROTATION_360;
    } else {
      // 窗口旋转屏幕控件不转,固定在充电口朝下方向
      screenComponentRotation = this.getPhysicalRotationOffset();
    }
    log.showInfo('getScreenComponentRotation :' + screenComponentRotation + ' rotatePolicy: ' + this.getRotatePolicy());
    return screenComponentRotation;
  }

  // 根据offset和相对sensor的自然角度, 获取物理角度
  public getPhyRotation(rotation: number): number {
    let phyRotation: number = 0;
    phyRotation = (rotation + this.getPhysicalRotationOffset()) % RotationConstants.ROTATION_360;
    log.showInfo('getPhyRotation :' + phyRotation);
    return phyRotation;
  }

  // 获取屏幕默认角度偏移
  public getScreenDefaultRotationOffset(): number {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PAD) {
      return this.getPhysicalRotationOffset(); // 平板物理屏幕安装方向与sensor方向偏差
    }
    if (uiType === SCBConstants.UITYPE_PHONE && this.isExpandStatus) {
      return this.getPhysicalRotationOffset();
    }
    return 0;
  }

  // 获取屏幕默认展示角度
  public getScreenDefaultRotation(): number {
    let valid_rotation_array: Array<number> = [0, 90, 180, 270];
    if (CONFIG_DEFAULT_SCREEN_ROTATION !== -1 && valid_rotation_array.includes(CONFIG_DEFAULT_SCREEN_ROTATION)) {
      return CONFIG_DEFAULT_SCREEN_ROTATION;
    }
    // Pad默认角度为270°，手机为0°
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PAD) {
      return 270;
    }
    return 0;
  }

  /**
   * Get whether the rotation is vertical
   *
   * @param { Number } rotation
   * @returns { Boolean }
   */
  public isVertical(rotation: number): boolean {
    if (this.defaultScreenOrientation === 0) {
      return rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_180 ||
        rotation === RotationConstants.ROTATION_360;
    } else {
      return rotation === RotationConstants.ROTATION_90 || rotation === RotationConstants.ROTATION_270;
    }
  }

  private calculateScreenPropertyWithRotation(rotationAfter: number): SCBScreenProperty {
    let propertyAfter: SCBScreenProperty = new SCBScreenProperty();
    propertyAfter.copy(this.scbScreenProperty);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[calculateScreenPropertyWithRotation] before rotation: ' + JSON.stringify(propertyAfter));
    if (this.isVertical(this.scbScreenProperty.rotation) !== this.isVertical(rotationAfter)) { //// need fix
      [propertyAfter.width, propertyAfter.height] = [propertyAfter.height, propertyAfter.width];
      let width = propertyAfter.width;
      let height = propertyAfter.height;
      let half = 2;
      let transX = propertyAfter.getTranslateX();
      let transY = propertyAfter.getTranslateY();
      if (rotationAfter === RotationConstants.ROTATION_90 ||
        rotationAfter === RotationConstants.ROTATION_270) {
        transX -= (width - height) / half;
        transY += (width - height) / half;
      } else {
        transX += (height - width) / half;
        transY -= (height - width) / half;
      }
      propertyAfter.updateTranslate(transX, transY);
    }
    propertyAfter.rotation = rotationAfter;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[calculateScreenPropertyWithRotation]after rotation: ' + JSON.stringify(propertyAfter));
    return propertyAfter;
  }

  /**
   * The function of after sensor rotation change
   *
   * @param { Number } sensorRotation
   * @param { string } rotateReasonDescription
   */
  private sensorRotationChange(sensorRotation: number, rotateReasonDescription: string = ''): void {
    if (this.isSuspendRotate(rotateReasonDescription)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[sensorRotationChange] rotate is disabled return.');
      return;
    }
    if (SCBSceneSessionManager.getInstance().skipSensorRotationChange(rotateReasonDescription)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[sensorRotationChange] skip sensor rotation change.');
      return;
    }
    let needRotate = SCBSceneSessionManager.getInstance().isScreenNeedRotate(sensorRotation, this.scbScreenProperty.rotation,
      this.scbScreenProperty.screenId);
    if (needRotate) {
      SCBWindowRotateController.getInstance().notifyBeforeWindowRotateChange();
      let sensorProperty = this.calculateScreenPropertyWithRotation(sensorRotation);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[sensorRotationChange] needRotate to rotation: ' + JSON.stringify(sensorProperty));
      let bundleName = SCBSceneSessionManager.getInstance().getContainerSessionList(this.scbScreenProperty.screenId)
        .getTopActiveSession()?.primarySession?.sceneInfo.bundleName;
      HiSysEventUtil.reportRotationChange(bundleName, this.scbScreenProperty.rotation, sensorRotation,
        rotateReasonDescription === 'sensor rotation change' ? HiSysEventUtil.ROTATION_TYPE_SENSOR :
          rotateReasonDescription);
      this.updateVirtualProperty(sensorProperty, SCBPropertyChangeReason.ROTATION, true);
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[sensorRotationChange] sensorProperty: ' + JSON.stringify(this.sensorScreenProperty) +
      ' sensorRotation: ' + sensorRotation + ' needRotate: ' + needRotate);
  }

  /**
   * Get the real rotation
   *
   * @param { Number } screenRotation
   * @returns { Number }
   */
  public getRealRotation(screenRotation: number): number {
    if (this.isRotateScreenPolicy()) {
      return this.scbScreenProperty.rotation;
    }
    return screenRotation;
  }

  /**
   * Get foldable phone with expand/half-expand status
   *
   * @returns { Boolean }
   */
  public isFoldablePhoneExpandStatus(): boolean {
    if (DeviceHelper.isPC()) {
      // 折叠PC不应当作手机
      log.showInfo(TAG, 'folder pc is not phone');
      return false;
    }

    return this._isExpandStatus;
  }

  /**
   * Get foldable phone folding status
   *
   * @returns { Boolean }
   */
  public isPhoneFoldingStatus(): boolean {
    return this._isPhoneFolding;
  }

  /**
   * Calculate the foldable phone rotation
   *
   * @param { Number } rotation
   * @returns { Number }
   */
  public calculateFoldablePhoneRotation(rotation: number): number {
    if (rotation % RotationConstants.ROTATION_90 !== 0) {
      return RotationConstants.ROTATION_90;
    }
    rotation = (rotation + this.getPhysicalRotationOffset()) % RotationConstants.ROTATION_360;
    return rotation;
  }

  /**
   * Resume the foldable phone rotation
   *
   * @param { Number } rotation
   * @returns { Number }
   */
  public resumeFoldablePhoneRotation(rotation: number): number {
    if (rotation === RotationConstants.ROTATION_90) {
      return RotationConstants.ROTATION_0;
    } else if (rotation === RotationConstants.ROTATION_180) {
      return RotationConstants.ROTATION_90;
    } else if (rotation === RotationConstants.ROTATION_270) {
      return RotationConstants.ROTATION_180;
    } else {
      return RotationConstants.ROTATION_270;
    }
  }

  /**
   * Cover the phone sensor rotation
   *
   * @param { Number } rotation
   */
  public coverPhoneSensorRotation(rotation: number): void {
    this.sensorScreenProperty.copy(this.calculateScreenPropertyWithRotation(rotation));
    log.showInfo('coverPhoneSensorRotation sensorProperty: ' + JSON.stringify(this.sensorScreenProperty));
  }

  private getSCBPropertyChangeReason(reason: screenSessionManager.ScreenPropertyChangeReason): SCBPropertyChangeReason {
    if (reason === screenSessionManager.ScreenPropertyChangeReason.ROTATION) {
      return SCBPropertyChangeReason.ROTATION;
    } else if (reason === screenSessionManager.ScreenPropertyChangeReason.CHANGE_MODE) {
      return SCBPropertyChangeReason.CHANGE_MODE;
    } else if (reason === screenSessionManager.ScreenPropertyChangeReason.FOLD_SCREEN_EXPAND) {
      return SCBPropertyChangeReason.FOLD_TO_EXPAND;
    } else if (reason === screenSessionManager.ScreenPropertyChangeReason.SCREEN_CONNECT) {
      return SCBPropertyChangeReason.SCREEN_CONNECT;
    } else if (reason === screenSessionManager.ScreenPropertyChangeReason.SCREEN_DISCONNECT) {
      return SCBPropertyChangeReason.SCREEN_DISCONNECT;
    } else if (reason === screenSessionManager.ScreenPropertyChangeReason.FOLD_SCREEN_FOLDING) {
      return SCBPropertyChangeReason.EXPAND_TO_FOLD;
    } else if (reason === screenSessionManager.ScreenPropertyChangeReason.BIG_SCREEN_STATUS_CHANGE) {
      return SCBPropertyChangeReason.BIG_SCREEN_STATUS_CHANGE;
    } else {
      return SCBPropertyChangeReason.UNDEFINED;
    }
  }

  /**
   * Refresh available area
   *
   * @param { Number } statusBarHeight
   * @param { Number } dockBarHeight
   * @param { boolean } isForceUpdate
   */
  public refreshAvailableArea(statusBarHeight: number, dockBarHeight: number, isForceUpdate: boolean = false): void {
    let posX = 0;
    let posY = statusBarHeight;
    let width = this.scbScreenProperty.width;
    let height = this.scbScreenProperty.height - statusBarHeight - dockBarHeight;
    if (posX !== this.availableArea.posX || posY !== this.availableArea.posX ||
      width !== this.availableArea.width || height !== this.availableArea.height || isForceUpdate) {
      this.availableArea = {
        posX: posX,
        posY: posY,
        width: width,
        height: height
      };
      log.showInfo(TAG, 'updateAvailableArea rect[' + posX + ',' + posY + ',' + width + ',' + height + ']' );
      SCBScreenSessionManager.getInstance().updateAvailableArea(this.scbScreenProperty.screenId);
    }
  }

  /**
   * Set skip rotation
   *
   * @param { Number } rotation
   */
  public setSkipRotation(rotation: number): void {
    this._skipRotation = rotation;
  }

  /**
   * Get _enableRotate
   *
   * @return _enableRotate
   */
  public getEnableRotate(): boolean {
    return this.innerData._enableRotate;
  }

  /**
   * Set is enable rotate through a voting mechanism
   *
   * @param { Boolean } enableRotate. For the same caller, enableRotate false and true should be used in pairs.
   * @param { string } reasonType. Description of caller.It should be the same whether enableRotate is true or false.
   */
  public setEnableRotate(enableRotate: boolean, reasonType: string): void {
    let traceName: string = 'setEnableRotate: ' + this.getCallerStack();
    Trace.start(traceName);
    log.showInfo(traceName);
    if (!enableRotate) {
      this._disableRotateReasonSet.add(reasonType);
      this.innerData._enableRotate = false;
      log.showWarn(`disable rotate successful, disable reason:${reasonType}`);
      Trace.end(traceName);
      return;
    }
    // 取消禁用旋转时，如果有其他禁用条件，需要等所有禁用条件都满足了，才能放开旋转
    this._disableRotateReasonSet.remove(reasonType);
    if (this._disableRotateReasonSet.isEmpty()) {
      this.innerData._enableRotate = true;
      log.showWarn(`enable rotate successful, enable reason:${reasonType}`);
      Trace.end(traceName);
      return;
    }
    let allReason = '';
    this._disableRotateReasonSet.forEach((reason) => {
      allReason += reason + ',';
    });
    Trace.end(traceName);
    log.showWarn(`enable rotate fail, enable reason:${reasonType}, rotate is disabled by other reason:${allReason}`);
  }

  /**
   * Get _enableSensorRotate
   *
   * @Return _enableSensorRotate
   */
  public getEnableSensorRotate(): boolean {
    return this.innerData._enableSensorRotate;
  }

  /**
   * Set is enable sensor rotate
   *
   * @param { Boolean } enableRotate
   */
  public setEnableSensorRotate(enableRotate: boolean, enableDescription: string): void {
    this.innerData._enableSensorRotate = enableRotate;
    WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[setEnableSensorRotate] set sensor rotate enable, ` + 
                 `_enableSensorRotate:${this.innerData._enableSensorRotate}, Description:${enableDescription}`);
  }

  public recordRotationWhenLockAutoRotation(): void {
    this._rotationWhenLockAutoRotation = this.scbScreenProperty.rotation;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[recordRotationWhenLockAutoRotation] record rotation when locked, `+ 
                 `_rotationWhenLockAutoRotation:${this._rotationWhenLockAutoRotation}`);
  }

  public recordRotationWhenExitHalfFold(rotationWhenLockAutoRotation: number): void {
    this._rotationWhenLockAutoRotation = rotationWhenLockAutoRotation;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[recordRotationWhenExitHalfFold] record rotation Force when exit halfFold, ` + 
                 `_rotationWhenLockAutoRotation:${this._rotationWhenLockAutoRotation}`);
  }

  /**
   * Calling the sensor rotation change function when it is needed
   *
   * @param { Number } rotation
   */
  public doSkippedRotationIfNeed(rotation: number): void {
    if (this._skipRotation !== undefined && this._skipRotation !== rotation) {
      log.showInfo('do skipped rotation: ${rotation}');
      this.sensorRotationChange(this._skipRotation);
    }
    this._skipRotation = undefined;
  }

  public static isPlacedRotateFriendlyDevice(): boolean {
    return DeviceHelper.isPad() || (DeviceHelper.isLargeInFoldProduct() && DeviceHelper.isFoldExpanded());
  }

  /**
   * In scenarios other than set screen orientation, it is used to indicate the horizontal placement state.
   *
   * @return { boolean } isPlacedRotateFriendlyDevicePlaced
   */
  public isPlacedRotateFriendlyDevicePlaced(): boolean {
    // 当前除水平放置外sensor都不会上报-1，因此可以用该值表示水平放置状态
    return this.currentSensorRotation === PLACED_SENSOR_ROTATION &&
      SCBScreenSession.isPlacedRotateFriendlyDevice() &&
      !this.isScreenOrientationChange;
  }

  public getTargetScreenRotationWhenAppExit(): number {
    let targetScreenRotation = this.sensorScreenProperty.rotation;
    if (SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.scbScreenProperty.screenId)) {
      targetScreenRotation = this.rotationWhenLockAutoRotation;
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getTargetScreenRotationWhenAppExit] ScreenOrientationLocked, targetScreenRotation: ' +
        targetScreenRotation);
    } else {
      if (this.isPlacedRotateFriendlyDevicePlaced()) {
        targetScreenRotation = this.scbScreenProperty.rotation;
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getTargetScreenRotationWhenAppExit] the device is placed, targetScreenRotation: ' +
          targetScreenRotation);
      }
    }
    if (this.isInEmergencyOrThermalSafe && this.isInEmergencyOrThermalSafe()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getTargetScreenRotationWhenAppExit] emergency or thermalSafe, default rotation');
      targetScreenRotation = this.getScreenDefaultRotation();
    }
    if (this.getFixedRotation() !== -1) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getTargetScreenRotationWhenAppExit] not placed.');
      targetScreenRotation = this.getFixedRotation();
    }
    return targetScreenRotation;
  }

  private getFixedRotation(): number {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let fixedRotation: number = SCBRotationConfig.getInstance().getDeviceFixedRotation(this);
      if (fixedRotation !== -1) {
        return fixedRotation;
      }
    }
    return -1;
  }

  /**
   * isEnableRotatoinExclusive
   * @returns
   */
  public isEnableRotatoinExclusive(): boolean {
    return this.innerData._enableRotateExclusive;
  }

  /**
   * Set is enable sensor rotate
   *
   * @param { Boolean } enableRotate
   */
  public setRotatoinExclusive(enableRotateExclusive: boolean, enableDescription: string): void {
    this.innerData._enableRotateExclusive = enableRotateExclusive;
    WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[setRotatoinExclusive] set sensor rotate exclusive:${this.innerData._enableRotateExclusive}, ` + 
                `Description:${enableDescription}`);
  }

  /**
   * get upper-level caller stack
   */
  public getCallerStack(): string {
    const stack: string = new Error().stack || '';
    const stackLines: string[] = stack.split('\n');
    if (stackLines.length <= UPPER_CALLER_DEPTH) {
      return 'UNKNOWN';
    }
    let stackLinesIndex = UPPER_CALLER_DEPTH;
    while (stackLinesIndex < stackLines.length) {
      const line: string = stackLines[stackLinesIndex].trim();
      // only key call stack information is reserved.
      const callerFun: string = line.substring(0, line.indexOf('(') + 1);
      const callerFile: string = line.substring(line.lastIndexOf('/') + 1);
      if (callerFile !== 'undefined') {
        return callerFun + callerFile;
      }
      stackLinesIndex++;
    }
    log.showError(`getCallerStack: get stack failed`);
    return 'UNKNOWN';
  }
}
