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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { UIContext } from '@kit.ArkUI';
import screenSessionManager from '@ohos.screenSessionManager';
import { SCBScreenSession } from './SCBScreenSession';
import { SCBScreenProperty } from './SCBScreenSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, ScenePanelState } from '../../scene/session/SCBSceneSessionManager';
import { PowerStatus, RotationConstants } from '@ohos/commonconstants';
import { SettingsConstants } from '@ohos/commonconstants';
import settings from '@ohos.settings';
import { DisplayMgr } from '../../utils/DisplayManager';
import power from '@ohos.power';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import dataShare from '@ohos.data.dataShare';
import display from '@ohos.display';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBWindowRotateController } from '../../scene/manager/SCBWindowRotateController';
import { SCBConstants } from '@ohos/commonconstants';
import { Trace } from '@ohos/basicutils';
import { SCBContainerRotationReason, SCBSceneContainerSession } from '../../TsIndex';
import { SCBSceneOrientation } from '../../scene/session/SCBSceneOrientation';
import { SCBKeyboardPanelManager } from '../../scene/session/SCBKeyboardPanelManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBScreenSM';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const RETRY_INTERVAL_MS: number = 1500; // retry interval
const MAX_RETRY_TIMES: number = 5; // dataShare max retry times
const ROTATION_DELAY_TIME_FROM_EXPANDED: number = 500; // rotation delay time from expanded state
const ROTATION_DELAY_TIME_FROM_FOLDED: number = 800; // rotation delay time from folded state
const UPPER_CALLER_DEPTH: number = 3;
const SCREEN_SCAN_TYPE: number = Number.parseInt(systemParameterEnhance.getSync('const.window.screen.scan_type', '0'));
const UPDATEFOLDMODE_RECORD_TIME_THRESHOLD:number = 150; // updateFoldMode report timeout exception and record threshold
const WAIT_NOTIFY_SCREEN_MASK_APPEAR_MS = 50;

@Observed
export class SCBScreenSessionArray extends Array<SCBScreenSession> {
}

export interface ScreenConnectListener {
  onScreenConnect(screenSession: SCBScreenSession);
  onScreenDisconnect(screenId: number, displayGroupId?: number);
}

export interface ScreenModeChangeListener {
  onScreenModeChange(mainScreenId: number, extendScreenId: number);
}

export class PowerStatusController {
  changePowerStatus(status: PowerStatus): void {}
}

export interface SuperFoldStatusChangeListener {
  onSuperFoldStatusChange(screenId: number, superFoldStatus: screenSessionManager.SuperFoldStatus);
}

export interface ExtendScreenConnectStatusChangeListener {
  onExtendScreenConnectStatusChange(screenId: number,
    extendScreenConnectStatus: screenSessionManager.ExtendScreenConnectStatus);
}

export interface SecondaryReflexionChangeListener {
  onSecondaryReflexionChange(screenId: number, isSecondaryReflexion: boolean);
}

export interface MultiScreenModeChangeListenerList {
  onMultiScreenModeChange(screenModeChangeEvent: screenSessionManager.ScreenModeChangeEvent);
}

export enum SCBPropertyChangeReason {
  UNDEFINED,
  ROTATION,
  CHANGE_MODE,
  FOLD_TO_EXPAND,
  SCREEN_CONNECT,
  SCREEN_DISCONNECT,
  FOLD_SCREEN_CONNECT,
  FOLD_SCREEN_ROTATION,
  EXPAND_TO_FOLD,
  FOLD_LANDSCAPE_START,
  SUPER_FOLD_STATUS_CHANGE,
  PAGE_ROTATION
};

export enum SCBRotateChangeReason {
  UNSPECIFIED,
  ROTATE_BEGIN,
  ROTATE_END,
  ROTATION_UPDATE_PROPERTY_ONLY,
  ROTATION_UPDATE_PROPERTY_ONLY_NOT_NOTIFY,
};

export enum RotateFuncType {
  START_SCENE,
  EXIT_SCENE
}

export enum SCBProductFuncType {
  IS_SCREEN_VERTICAL
};

// same with systemui in feature
class AutoRotateData {
  isOn: boolean = false;
}

export class WrapRotationEntryParam {
  rotateFuncType: RotateFuncType = null;
  reason: SCBContainerRotationReason = null;
  containerSession: SCBSceneContainerSession = null;
  needAnimation: boolean = false;
  isFromRecent: boolean = false;
  fromUser: boolean = false;
}

export class SCBScreenSessionManager {
  private screenSessionList: SCBScreenSessionArray = [];
  private tempScreenSessionList: SCBScreenSession[] = [];
  private screenConnectListener: ScreenConnectListener = null;
  private screenModeChangeListener: ScreenModeChangeListener = null;
  private extendScreenConnectStatusChangeListenerList: Array<ExtendScreenConnectStatusChangeListener> = new Array();
  private multiScreenModeChangeListenerList: Array<MultiScreenModeChangeListenerList> = new Array();
  // screenPropertyChangeCallbacks: screenId, [func, isRotatable, persistentId, isNotifyBeforeScenePanel]
  private screenPropertyChangeCallbacks: Map<number, Array<[Function, boolean, number | null, boolean]>> = new Map();
  private rotationAnimationCallbacks: Map<number, Function[]> = new Map();
  private beforeRotationAnimationCallbacks: Map<number, Function[]> = new Map();
  private screenRotateChangeCallbacks: Map<number, Array<[Function]>> = new Map();// screenId, [func]
  private propertyChangeScenePanelCallback: Map<number, Map<number, Function>> = new Map();// screenId, zIndex, func
  private startFoldToExpandChangeCallback: Map<number, Map<number, Function>> = new Map();
  private beforeScreenPropertyCallBacks: Map<number, Array<[Function]>> = new Map();
  private callbackRegisterMap: Map<Function, string> = new Map();
  private rotationAnimationCallbackRegisterMap: Map<Function, string> = new Map();
  private powerStatusController: PowerStatusController = null;
  private screenRotationLocked: boolean = true; // screenId, screenRotationLocked
  private updateOrientationLock: boolean = true;
  private isRestoreRotation: boolean = false;
  private currentFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  private currentState: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  private hoverTimerId: number = -1;
  private lastRotation: number = RotationConstants.ROTATION_0;
  private screenHalfParam: number = 2;
  private readonly uriShare: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true';
  private readonly dataKey: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' +
    settings.general.ACCELEROMETER_ROTATION_STATUS;
  private dataShareHelper: dataShare.DataShareHelper = null;
  private warpRotateChangeCallbacks: Map<number, Function> = new Map();
  private screenProductCallbacks: Map<number, Map<SCBProductFuncType, Function>> = new Map();// screenId, callbackFuncType, func
  private foldDisplayMode: screenSessionManager.FoldDisplayMode = screenSessionManager.FoldDisplayMode.UNKNOWN;

  /**
   * Get the singleton of the screen session manager.
   */
  static getInstance(): SCBScreenSessionManager {
    if (!globalThis.SCBScreenSessionManagerInstance) {
      globalThis.SCBScreenSessionManagerInstance = new SCBScreenSessionManager();
    }
    return globalThis.SCBScreenSessionManagerInstance;
  }

  private constructor() {
  }

  /**
   * initialize
   */
  public init(): void {
    log.showInfo('Init screen session manager.');
    screenSessionManager.on('screenConnectChange', ({ screenSession, screenConnectChangeType }) => {
      this.onScreenConnectChange(screenSession, screenConnectChangeType);
    });
    this.registerOrientationSettings(MAX_RETRY_TIMES);
  }

  /**
   *  Orientation setting change event
   */
  public onOrientationSettingsChange = (): void => {
    this.screenRotationLocked = this.getOrientationLockByIpc();
    log.showInfo(`dataChange screenRotationLocked change ${this.screenRotationLocked}`);
    let autoRotateStatus = AppStorage.get('AutoRotateModel_AutoRotateStatus') as AutoRotateData;
    // status true mean icon is on, screenRotation is Locked
    if (autoRotateStatus) {
      autoRotateStatus.isOn = this.screenRotationLocked;
    } else {
      log.showError(`dataChange screenRotationLocked ${this.screenRotationLocked} failed since null rotateStatus`);
    }
  };

  private async registerOrientationSettings(leftRetryTimes: number): Promise<void> {
    let systemUIContext = GlobalContext.getContext();
    if (leftRetryTimes <= 0) {
      log.error('no left retry times');
      leftRetryTimes = 1;
    }
    log.showInfo('registerOrientationSettings caller:' + this.getCallerStack() + 'uri:' + this.uriShare + 'queryKey:' +
      this.dataKey);
    try {
      dataShare.createDataShareHelper(systemUIContext, this.uriShare).then((dataShareHelper) => {
        if (dataShareHelper) {
          dataShareHelper.on('dataChange', this.dataKey, this.onOrientationSettingsChange.bind(this));
          this.dataShareHelper = dataShareHelper;
          log.info('init dataShareHelper success!');
        } else {
          log.error('init dataShareHelper failed and dataShareHelper is null!');
        }
      }).catch((error) => {
        log.error('init orientation settings DataShare error:', error);
        setTimeout(this.registerOrientationSettings.bind(this, leftRetryTimes - 1), RETRY_INTERVAL_MS);
      });
    } catch (error) {
      log.error('init orientation settings DataShare catch error:', error);
      setTimeout(this.registerOrientationSettings.bind(this, leftRetryTimes - 1), RETRY_INTERVAL_MS);
    }
  }

  private getOrientationLockByIpc(): boolean {
    let systemUIContext = GlobalContext.getContext();
    log.showInfo('getOrientationLockByIpc systemUIContext, context: ' + typeof(systemUIContext));
    let value:string = null;
    try {
      value = settings.getValueSync(systemUIContext,
        settings.general.ACCELEROMETER_ROTATION_STATUS,
        SettingsConstants.AUTO_ROTATE_OFF);
    } catch (e) {
      log.showError(`getValue:${JSON.stringify(e)}`);
    }
    let ret: boolean = SettingsConstants.AUTO_ROTATE_OFF === value;
    log.showInfo(`getOrientationLockByIpc systemUIContext, value: ${value} ret:${ret}`);
    return ret;
  }

  private onScreenConnectChange(session: screenSessionManager.ScreenSession,
    changeType: screenSessionManager.ScreenConnectChangeType): void {
    log.showInfo('On screen connect change, type:' + changeType + ' ' + session.screenId);
    if (changeType === screenSessionManager.ScreenConnectChangeType.CONNECT) {
      let screenSession: SCBScreenSession = new SCBScreenSession(session);
      screenSession.setScreenExtendStatus(session.isExtend);
      let isDevEcoViewer: boolean = screenSession.session.name === 'DevEcoViewer';
      let isCustomScbScreen: boolean = screenSession.session.innerName === 'CustomScbScreen';
      screenSession.setScreenMainStatus(!session.isExtend && !isDevEcoViewer && !isCustomScbScreen);
      if (this.screenConnectListener != null) {
        this.screenConnectListener.onScreenConnect(screenSession);
      } else {
        this.tempScreenSessionList.push(screenSession);
      }
    }

    if (changeType === screenSessionManager.ScreenConnectChangeType.DISCONNECT) {
      if (this.screenConnectListener != null) {
        this.screenConnectListener.onScreenDisconnect(session.screenId, session.displayGroupId);
        session.destroyContent();
      } else {
        const screenSessionIndex = this.tempScreenSessionList.findIndex(item => {
          return item.session.screenId === session.screenId;
        });
        if (screenSessionIndex === -1) {
          log.showError('Failed to remove temp screen session, screen id:' + session.screenId);
          return;
        }
        this.tempScreenSessionList.splice(screenSessionIndex, 1);
      }
    }
  }

  /**
   * Register screen connection listener
   *
   * @param { ScreenConnectListener } listener
   */
  public registerScreenConnectionListener(listener: ScreenConnectListener): void {
    log.showInfo(`registerScreenConnectionListener caller: ` + this.getCallerStack());
    if (this.screenConnectListener != null) {
      log.showError('Failed to register screen connection listener!');
      return;
    }
    this.screenConnectListener = listener;
    for (let session of this.tempScreenSessionList) {
      this.screenConnectListener.onScreenConnect(session);
    }
    this.tempScreenSessionList = null;
  }

  public setScreenMode(mainScreenId: number, extendScreenId: number): void {
    if (this.screenModeChangeListener == null) {
      log.showError('registerScreenModeChangeListener is null');
      return;
    }
    log.showInfo('setScreenMode mainScreenId=' + mainScreenId + '; extendScreenId: ' + extendScreenId);
    this.screenModeChangeListener.onScreenModeChange(mainScreenId, extendScreenId);
  }

  public registerScreenModeChangeListener(listener: ScreenModeChangeListener): void {
    log.showInfo(`registerScreenModeChangeListener caller: ` + this.getCallerStack());
    if (this.screenModeChangeListener != null) {
      log.showError('registerScreenModeChangeListener is null');
      return;
    }
    this.screenModeChangeListener = listener;
  }

  public triggerExtendScreenConnectStatusChange(screenId: number,
      extendScreenConnectStatus: screenSessionManager.ExtendScreenConnectStatus): void {
    if (this.extendScreenConnectStatusChangeListenerList.length <= 0) {
      log.showError('no registed ExtendScreenConnectStatusListener');
      return;
    }
    log.showInfo('triggerExtendScreenConnectStatusChange screenId =' + screenId +
      ', extendScreenConnectStatus =' + extendScreenConnectStatus);
    for (let listener of this.extendScreenConnectStatusChangeListenerList) {
      if (listener == null) {
        log.showError('ExtendScreenConnectStatusListener is null');
        continue;
      }
      listener.onExtendScreenConnectStatusChange(screenId, extendScreenConnectStatus);
    }
  }

  public registerExtendScreenConnectStatusChangeListener(listener: ExtendScreenConnectStatusChangeListener): void {
    if (!listener) {
      log.showError('registerExtendScreenConnectStatusChangeListener failed, input listener null');
      return;
    }
    let index = this.extendScreenConnectStatusChangeListenerList.indexOf(listener);
    if (index === -1) {
      this.extendScreenConnectStatusChangeListenerList.push(listener);
      log.showInfo('registerExtendScreenConnectStatusChangeListener success, caller: ' + this.getCallerStack());
    } else {
      log.showError('registerExtendScreenConnectStatusChangeListener failed, caller: ' + this.getCallerStack() +
        ' already exist');
    }
  }

  public triggerMultiScreenModeChange(screenModeChangeEvent: screenSessionManager.ScreenModeChangeEvent): void {
    if (this.multiScreenModeChangeListenerList.length <= 0) {
      log.showError('no registed MultiScreenModeChangeListener');
      return;
    }
    log.showInfo(`triggerMultiScreenModeChange screenModeChangeEvent= ${screenModeChangeEvent}`);
    for (let listener of this.multiScreenModeChangeListenerList) {
      if (listener === null) {
        log.showError('MultiScreenModeChangeListenerList is null');
        continue;
      }
      listener.onMultiScreenModeChange(screenModeChangeEvent);
    }
    if (screenModeChangeEvent === screenSessionManager.ScreenModeChangeEvent.SCREEN_MODE_CHANGE_EVENT_BEGIN) {
      setTimeout(() => {
        log.showInfo(`triggerMultiScreenModeChange screenModeChangeEvent= notifyScreenMaskAppear begin`);
        screenSessionManager.notifyScreenMaskAppear();
        log.showInfo(`triggerMultiScreenModeChange screenModeChangeEvent= notifyScreenMaskAppear end`);
      }, WAIT_NOTIFY_SCREEN_MASK_APPEAR_MS);
    }
  }

  public registerMultiScreenModeChangeListener(listener: MultiScreenModeChangeListenerList): void {
    if (!listener) {
      log.showError('registerMultiScreenModeChangeListener failed, input listener null');
      return;
    }
    let index = this.multiScreenModeChangeListenerList.indexOf(listener);
    if (index === -1) {
      this.multiScreenModeChangeListenerList.push(listener);
      log.showInfo('registerMultiScreenModeChangeListener success, caller: ' + this.getCallerStack() +
        ', length: ' + this.multiScreenModeChangeListenerList.length);
    } else {
      log.showError('registerMultiScreenModeChangeListener failed, caller: ' + this.getCallerStack() +
        ' already exist');
    }
  }

  public unRegisterMultiScreenModeChangeListener(listener: MultiScreenModeChangeListenerList): void {
    if (!listener) {
      log.showError('unRegisterMultiScreenModeChangeListener failed, input listener null');
      return;
    }
    let index = this.multiScreenModeChangeListenerList.indexOf(listener);
    if (index === -1) {
      log.showWarn('unRegisterMultiScreenModeChangeListener failed, caller: ' + this.getCallerStack() +
        ' not exist');
    } else {
      this.multiScreenModeChangeListenerList.splice(index, 1);
      log.showInfo('unRegisterMultiScreenModeChangeListener success, caller: ' + this.getCallerStack() +
        ', length: ' + this.multiScreenModeChangeListenerList.length);
    }
  }

  /**
   * Set the screen session list reference.
   *
   * @param list List of the screen session
   */
  public setScreenSessionList(list: SCBScreenSessionArray): void {
    this.screenSessionList = list;
  }

  /**
   * Get the screen session list reference.
   *
   * @return reference of the screen session list
   */
  public getScreenSessionList(): SCBScreenSessionArray {
    return this.screenSessionList;
  }

  /**
   * Get default screen session.
   *
   * @return default screen session
   */
  public getMainScreenSession(): SCBScreenSession {
    if (this.screenSessionList.length <= 0) {
      log.showError('Failed to get default screen session!');
      return null;
    }
    for (let i = 0; i < this.screenSessionList.length; ++i) {
      let screenSession = this.screenSessionList[i];
      if (!(screenSession?.session.isExtend)) {
        return screenSession;
      }
    }
    return this.screenSessionList[0];
  }

  /**
   * Get extend screen session.
   *
   * @return default screen session
   */
  public getExtendScreenSession(): SCBScreenSession {
    if (this.screenSessionList.length <= 0) {
      log.showError('Failed to get extend screen session!');
      return null;
    }

    for (let i = 0; i < this.screenSessionList.length; ++i) {
      let screenSession = this.screenSessionList[i];
      if (screenSession?.session.isExtend) {
        return screenSession;
      }
    }
    return this.screenSessionList[0];
  }

  /**
   * Get the screen session by screenId.
   *
   * @return screen session
   */
  public getScreenSession(screenId: number): SCBScreenSession {
    for (let i = 0; i < this.screenSessionList.length; ++i) {
      let screenSession = this.screenSessionList[i];
      if (screenSession?.session.screenId === screenId) {
        return screenSession;
      }
    }

    log.showError('Failed to get screen session:' + screenId);
    return null;
  }

  /**
   * Get home screen property by screenId
   *
   * @param { Number } screenId
   * @returns { SCBScreenProperty }
   */
  public getHomeScreenProperty(screenId: number): SCBScreenProperty {
    let screenSession = this.getScreenSession(screenId);
    let isLocked = this.getScreenOrientationLocked(screenId);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    if (isLocked) {
      screenProperty.copy(screenSession?.scbScreenProperty);
    } else {
      screenProperty.copy(screenSession?.sensorScreenProperty);
    }
    return screenProperty;
  }

   /**
   * Get screen property by screenId
   *
   * @param { Number } screenId
   * @returns { SCBScreenProperty }
   */
   private getScreenProperty(screenId: number): SCBScreenProperty {
    let screenSession = this.getScreenSession(screenId);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    if (screenSession) {
      screenProperty.copy(screenSession.scbScreenProperty);
    } else {
      log.showError(`screen session ${screenId} is null`);
    }
    return screenProperty;
  }

  /**
   * The callbacks of register screen property changing
   *
   * @param { Function } callback
   * @param { Number } screenId
   * @param { Boolean } isRotatable
   * @param { Number|null } persistentId
   */
  public registerScreenPropertyChangeCallbacks(callback: Function, screenId?: number,
    isRotatable: boolean = true, persistentId: number | null = null, isNotifyBeforeScenePanel: boolean = false): void {
    let description = `registerScreenPropertyChangeCallbacks caller: ` + this.getCallerStack();
    log.showInfo(description);
    this.recordEventFromScb(description, false);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    if (!this.screenPropertyChangeCallbacks.has(screenId)) {
      this.screenPropertyChangeCallbacks.set(screenId, new Array());
    }
    this.screenPropertyChangeCallbacks.get(screenId).push([callback, isRotatable, persistentId, isNotifyBeforeScenePanel]);
    this.callbackRegisterMap.set(callback, this.getCallerStack());
    log.showInfo(`registerScreenPropertyChangeCallbacks screenId: ${screenId} ${isRotatable} ${persistentId} ${isNotifyBeforeScenePanel}` +
      this.screenPropertyChangeCallbacks.get(screenId)?.length);
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType === SCBConstants.UITYPE_PC) {
      try {
        callback(this.getScreenProperty(screenId), SCBPropertyChangeReason.SCREEN_CONNECT);
        log.showInfo('callback ' + this.getCallerStack());
      } catch (e) {
        log.showError('crash in ' + this.getCallerStack() + 'error message ' + e?.message);
      }
    }
  }

  /**
   * The callbacksWithAnimation of register screen property changing
   *
   * @param { Function } callback
   * @param { Number } screenId
   * @param { Boolean } isRotatable
   * @param { Number|null } persistentId
   */
  public registerRotationAnimationCallbacks(callback: Function): void {
    let description = `registerRotationAnimationCallbacks caller: ` + this.getCallerStack();
    log.showInfo(description);
    this.recordEventFromScb(description, false);
    let screenId = this.getMainScreenSession().session.screenId;
    if (!this.rotationAnimationCallbacks.has(screenId)) {
      this.rotationAnimationCallbacks.set(screenId, []);
    }
    this.rotationAnimationCallbacks.get(screenId).push(callback);
    this.rotationAnimationCallbackRegisterMap.set(callback, this.getCallerStack());
    log.showInfo(`registerRotationAnimationCallbacks screenId: ${screenId} ` +
      this.rotationAnimationCallbacks.get(screenId)?.length);
  }

  /**
   * The callbacks of unregister screen property changing
   *
   * @param { Function } callback
   * @param { Number } screenId
   * @param { Boolean } isRotatable
   * @param { Number|null } persistentId
   */
  public unRegisterScreenPropertyChangeCallbacks(callback: Function, screenId?: number,
    isRotatable: boolean = true, persistentId: number | null = null, isNotifyBeforeScenePanel: boolean = false): void {
    let description = `unRegisterScreenPropertyChangeCallbacks caller: ` + this.getCallerStack() +
      `screenId: ${screenId} ${isRotatable} ${persistentId}`;
    log.showInfo(description);
    this.recordEventFromScb(description, false);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    let callerStack: string = this.getCallerStack();
    this.callbackRegisterMap.delete(callback);
    log.showInfo(`callbackRegisterMap callerStack: ${callerStack}`);
    if (!this.screenPropertyChangeCallbacks.has(screenId)) {
      return;
    }
    let callBackArray = this.screenPropertyChangeCallbacks.get(screenId);
    let index = -1;
    for (let i = 0; i < callBackArray?.length; i++) {
      let item = callBackArray[i];
      if (item[0] === callback && item[1] === isRotatable && item[2] === persistentId &&
          item[3] === isNotifyBeforeScenePanel) {
        index = i;
        break;
      }
    }
    if (index !== -1) {
      let removed = this.screenPropertyChangeCallbacks.get(screenId).splice(index, 1);
      log.showInfo(`unRegisterScreenPropertyChangeCallbacks index:${index} removed:${removed.length}`);
    }
  }

  /**
   * registerBeforeRotationAnimationCallbacks
   *
   * @param { Function } callback
   */
  public registerBeforeRotationAnimationCallbacks(callback: Function, screenId?: number): void {
    if (typeof callback !== 'function') {
      log.showWarn('param callback is not a function');
      return;
    }
    if (!screenId) {
      screenId = this.getMainScreenSession()?.session?.screenId;
    }
    // screenId maybe 0
    if (typeof screenId !== 'number') {
      log.showInfo(`no screenId can not registerBeforeRotationAnimationCallbacks`);
      return;
    }
    if (!this.beforeRotationAnimationCallbacks.has(screenId)) {
      this.beforeRotationAnimationCallbacks.set(screenId, []);
    }
    let hasRegister = this.beforeRotationAnimationCallbacks.get(screenId)?.includes(callback);
    if (hasRegister) {
      log.showInfo(`registerRotationAnimationCallbacks is register`);
      return;
    }
    this.beforeRotationAnimationCallbacks.get(screenId).push(callback);
    log.showInfo(`registerBeforeRotationAnimationCallbacks screenId: ${screenId} ` +
      this.beforeRotationAnimationCallbacks.get(screenId)?.length);
  }

  /**
   * unRegisterBeforeRotationAnimationCallbacks
   *
   * @param { Function } callback
   */
  public unRegisterBeforeRotationAnimationCallbacks(callback: Function, screenId?: number): void {
    if (!screenId) {
      screenId = this.getMainScreenSession()?.session?.screenId;
    }
    if (!this.beforeRotationAnimationCallbacks.has(screenId)) {
      return;
    }
    let callBackArray = this.beforeRotationAnimationCallbacks.get(screenId);
    const index = callBackArray?.findIndex(item => item === callback) ?? -1;
    if (index !== -1) {
      let removed = this.beforeRotationAnimationCallbacks.get(screenId).splice(index, 1);
      log.showInfo(`unRegisterBeforeRotationAnimationCallbacks index:${index} removed:${removed.length}`);
    }
  }

  /**
   * notifyExcuteBeforeRotationAnimationCallbacks
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public notifyExcuteBeforeRotationAnimationCallbacks(screenProperty: SCBScreenProperty): void {
    if (!this.beforeRotationAnimationCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    let callbackArray = this.beforeRotationAnimationCallbacks.get(screenProperty.screenId);
    if (!callbackArray) {
      log.showInfo(`beforeRotationAnimationCallbacks is empty`);
      return;
    }
    for (let callback of callbackArray) {
      if (!callback || typeof callback !== 'function') {
        log.showInfo(`notifyExcuteBeforeRotationAnimationCallbacks is invalid`);
        continue;
      }
      try {
        callback();
      } catch (e) {
        log.showError(`crash in ${e?.message}`);
      }
    }
    log.showInfo(`screenId: ${screenProperty.screenId} notifyExcuteBeforeRotationAnimationCallbacks called`);
  }

  /**
   * The callbacksWithAnimation of unregister screen property changing
   *
   * @param { Function } callback
   * @param { Number } screenId
   * @param { Boolean } isRotatable
   * @param { Number|null } persistentId
   */
  public unRegisterRotationAnimationCallbacks(callback: Function): void {
    let description = `unRegisterRotationAnimationCallbacks caller: ` + this.getCallerStack();
    log.showInfo(description);
    this.recordEventFromScb(description, false);
    let screenId = this.getMainScreenSession().session.screenId;
    let callerStack: string = this.getCallerStack();
    this.rotationAnimationCallbackRegisterMap.delete(callback);
    log.showInfo(`rotationAnimationCallbackRegisterMap callerStack: ${callerStack}`);
    if (!this.rotationAnimationCallbacks.has(screenId)) {
      return;
    }
    let callBackArray = this.rotationAnimationCallbacks.get(screenId);
    let index = -1;
    for (let i = 0; i < callBackArray?.length; i++) {
      let item = callBackArray[i];
      if (item === callback) {
        index = i;
        break;
      }
    }
    if (index !== -1) {
      let removed = this.rotationAnimationCallbacks.get(screenId).splice(index, 1);
      log.showInfo(`unRegisterRotationAnimationCallbacks index:${index} removed:${removed.length}`);
    }
  }

  /**
   * update the system rotation property
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public updateSystemRotation(screenProperty: SCBScreenProperty): void {
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateSystemRotation callback called`);
    // update rect first
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (callbackInfo && callbackInfo[0]) {
        let TraceName: string = 'updateSystemRotation: ' + this.callbackRegisterMap.get(callbackInfo[0]);
        Trace.start(TraceName);
        log.showInfo(TraceName);
        try {
          callbackInfo[0](screenProperty, SCBPropertyChangeReason.ROTATION);
        } catch (e) {
          log.showError(`crash in ${TraceName}`);
        }
        Trace.end(TraceName);
      }
    }
    SCBSceneSessionManager.getInstance().notifySystemSceneToSetRotation(screenProperty);
    let screenSession = this.getScreenSession(screenProperty.screenId);
    DisplayMgr.onScreenPropertyChange(screenSession);
  }

  /**
   * hasSameFunc InRotationAnimationCallbacks
   *
   * @param { func } Function
   * @param { Map<number, Function[] } rotationAnimationCallbacksMap
   * @param { SCBScreenProperty } screenProperty
   * @return { boolean }
   */
  public hasSameFuncInRotationAnimationCallbacks(func: Function, rotationAnimationCallbacksMap: Map<number, Function[]>,
    screenProperty: SCBScreenProperty): boolean {
    if (!rotationAnimationCallbacksMap.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return false;
    }
    for (let callback of rotationAnimationCallbacksMap.get(screenProperty.screenId)) {
      if (func === callback) {
        return true;
      }
    }
    return false;
  }

  /**
   * execute SystemSceneCallbacks
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty: SCBScreenProperty): void {
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateSystemRotation callback called`);
    // update rect first
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0]; // 0 is callback
      if (!screenPropertyCallback || this.hasSameFuncInRotationAnimationCallbacks(screenPropertyCallback,
        this.rotationAnimationCallbacks, screenProperty)) {
        continue;
      }
      if (callbackInfo && screenPropertyCallback) {
        let TraceName: string = 'executeSystemCallback: ' +
          this.rotationAnimationCallbackRegisterMap.get(callbackInfo[0]);
        Trace.start(TraceName);
        log.showInfo(TraceName);
        try {
          screenPropertyCallback(screenProperty, SCBPropertyChangeReason.ROTATION);
        } catch (e) {
          log.showError(`crash in ${TraceName}}, error is ${e?.message}`);
        }
        Trace.end(TraceName);
      }
    }
    let screenSession = this.getScreenSession(screenProperty.screenId);
    DisplayMgr.onScreenPropertyChange(screenSession);
  }

  public updateVisibleSystemRotation(screenProperty: SCBScreenProperty): Array<[Function, boolean, number | null]> {
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> = new Array();
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return inVisibleSystemSceneCallbacks;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateVisibleSystemRotation callback called`);
    SCBSceneSessionManager.getInstance().notifySystemSceneToSetRotation(screenProperty);
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0]; // 0 is callback
      let isRotatable = callbackInfo[1]; // 1 is isRotatable
      let persistentId = callbackInfo[2]; // 2 is persistentId
      let isNotifyBeforeScenePanel = callbackInfo[3]; // 3 is beforeScenePanel
      if (!screenPropertyCallback || isNotifyBeforeScenePanel) {
        continue;
      }
      if (persistentId !== null) {
        let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId);
        if (!systemSceneSession?.getVisibility()) {
          // 0 is callback,1 is isRotatable,2 is persistentId
          inVisibleSystemSceneCallbacks.push([screenPropertyCallback, isRotatable, persistentId]);
          continue;
        }
      }
      let TraceName: string = 'updateVisibleSystemRotation: ' + this.callbackRegisterMap.get(callbackInfo[0]);
      Trace.start(TraceName);
      log.showWarn(TraceName);
      try {
        callbackInfo[0](screenProperty, SCBPropertyChangeReason.ROTATION);
      } catch (e) {
        log.showError(`crash in ${TraceName}, error message ${e?.message}`);
      }
      Trace.end(TraceName);
    }
    let screenSession = this.getScreenSession(screenProperty.screenId);
    DisplayMgr.onScreenPropertyChange(screenSession);
    return inVisibleSystemSceneCallbacks;
  }

  public updateVisibleSystemRotationBeforeScenePanel(screenProperty: SCBScreenProperty): void {
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateVisibleSystemRotationBeforeScenePanel callback called`);
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0]; // 0 is callback
      let isRotatable = callbackInfo[1]; // 1 is isRotatable
      let persistentId = callbackInfo[2]; // 2 is persistentId
      let isNotifyBeforeScenePanel = callbackInfo[3]; // 3 is beforeScenePanel
      if (!screenPropertyCallback || !isNotifyBeforeScenePanel) {
        continue;
      }
      let TraceName: string = 'updateVisibleSystemRotationBeforeScenePanel: ' + this.callbackRegisterMap.get(callbackInfo[0]);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        callbackInfo[0](screenProperty, SCBPropertyChangeReason.ROTATION);
      } catch (e) {
        log.showError(`crash in ${TraceName}, error message ${e}`);
      }
      Trace.end(TraceName);
    }
  }

  public notifyUpdateSystemScenePropertyWithAnimation(screenProperty: SCBScreenProperty): void {
    if (!this.rotationAnimationCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} handleCallbackWithAnimationWhenRotate has no change callback`);
      return;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} handleCallbackWithAnimationWhenRotate callback called`);
    for (let callback of this.rotationAnimationCallbacks.get(screenProperty.screenId)) {
      if (!callback) {
        continue;
      }
      let TraceName: string = 'executeRotationCallbacks: ' + this.callbackRegisterMap.get(callback);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        callback(screenProperty, SCBPropertyChangeReason.ROTATION);
      } catch (e) {
        log.showError(`crash in ${TraceName}, error is ${e?.message}`);
      }
      Trace.end(TraceName);
    }
  }

  /**
   * hasRotationCallbacks
   *
   * @param { SCBScreenProperty } screenProperty
   * @return { boolean }
   */
  public hasRotationCallbacks(screenProperty: SCBScreenProperty): boolean {
    if (!this.rotationAnimationCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} hasRotationCallbacks has no change callback`);
      return false;
    }
    return this.rotationAnimationCallbacks.get(screenProperty.screenId)?.length > 0;
  }

  public async updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]>,
    screenProperty: SCBScreenProperty): Promise<void> {
    await this.updateInVisibleSystemRotationSync(inVisibleSystemSceneCallbacks, screenProperty);
  }
 
  private async updateInVisibleSystemRotationSync(inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]>,
    screenProperty: SCBScreenProperty): Promise<void> {
      log.showInfo(`updateInVisibleSystemRotationSync callbacks size:${inVisibleSystemSceneCallbacks.length}`);
    // update rect first
    for (let callbackInfo of inVisibleSystemSceneCallbacks) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0];
      if (!screenPropertyCallback) {
        continue;
      }
      let TraceName: string = 'updateInVisibleSystemRotationSync: ' + this.callbackRegisterMap.get(callbackInfo[0]);
      Trace.start(TraceName);
      log.showWarn(TraceName);
      try {
        screenPropertyCallback(screenProperty, SCBPropertyChangeReason.ROTATION);
      } catch (e) {
        log.showError(`crash in ${TraceName}`);
      }
      Trace.end(TraceName);
    }
  }

  /**
   * update ScbScreenProperty To Callbacks.
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public updateScreenPropertyToCallbacks(screenProperty: SCBScreenProperty,
                                         reason: SCBPropertyChangeReason): void {
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (callbackInfo && callbackInfo[0]) {
        let TraceName: string = 'updateScreenPropertyToCallbacks: ' + this.callbackRegisterMap.get(callbackInfo[0]);
        Trace.start(TraceName);
        log.showInfo(TraceName);
        try {
          callbackInfo[0](screenProperty, reason);
        } catch (e) {
          log.showError(`crash in ${TraceName}`);
        }
        Trace.end(TraceName);
      }
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateScreenPropertyToCallbacks callback called`);
  }

  /**
   * update system active mode
   *
   * @param { SCBScreenProperty } oldScreenProperty
   * @param { SCBScreenProperty } newScreenProperty
   */
  public updateSystemActiveModeChange(oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    if (!this.screenPropertyChangeCallbacks.has(newScreenProperty.screenId)) {
      log.showError(`screenId: ${newScreenProperty.screenId} has no property change callback`);
      return;
    }
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(newScreenProperty.screenId)) {
      if (callbackInfo && callbackInfo[0]) {
        let TraceName: string = 'updateSystemActiveModeChange: ' + this.callbackRegisterMap.get(callbackInfo[0]);
        Trace.start(TraceName);
        log.showInfo(TraceName);
        try {
          callbackInfo[0](newScreenProperty, SCBPropertyChangeReason.CHANGE_MODE);
        } catch (e) {
          log.showError(`crash in ${TraceName}`);
        }
        Trace.end(TraceName);
      }
    }
    SCBSceneSessionManager.getInstance().notifySystemSceneToActiveModeChange(oldScreenProperty, newScreenProperty);
  }

  /**
   * Update fold mode
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   */
  public updateFoldMode(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateFoldMode callback called`);
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateFoldMode(screenProperty, reason);
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0];
      let isRotatable = callbackInfo[1];
      if (!screenPropertyCallback) {
        continue;
      }
      let TraceName: string = 'updateFoldMode: ' + this.callbackRegisterMap.get(screenPropertyCallback);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      let startTime = new Date().getTime();
      try {
        if (!isRotatable && reason === SCBPropertyChangeReason.EXPAND_TO_FOLD &&
          (screenProperty.rotation === RotationConstants.ROTATION_90 ||
            screenProperty.rotation === RotationConstants.ROTATION_270)) {
          let tmpProperty = new SCBScreenProperty();
          tmpProperty.copy(screenProperty);
          [tmpProperty.width, tmpProperty.height] = [tmpProperty.height, tmpProperty.width];
          screenPropertyCallback(tmpProperty, reason);
        } else {
          screenPropertyCallback(screenProperty, reason);
        }
      } catch (e) {
        log.showError(`crash in ${TraceName}`);
      }
      let endTime = new Date().getTime();
      let description = `updateFoldMode cost ${endTime - startTime}ms ` + this.callbackRegisterMap.get(screenPropertyCallback);
      if (endTime - startTime > UPDATEFOLDMODE_RECORD_TIME_THRESHOLD) {
        log.showWarn(description);
        this.recordEventFromScb(description, true);
      } else {
        log.showInfo(description);
        this.recordEventFromScb(description, false);
      }
      Trace.end(TraceName);
    }
  }

  /**
   * Update system scene fold
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @returns { Array<[Function,boolean,number|null]> }
   */
  public updateSystemSceneFoldChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason): Array<[Function, boolean, number | null]> {
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> = new Array();
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return inVisibleSystemSceneCallbacks;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateSystemSceneFoldChange callback called`);
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateFoldMode(screenProperty, reason);
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0]; // 0 is callback
      let isRotatable = callbackInfo[1]; // 1 is isRotatable
      let persistentId = callbackInfo[2]; // 2 is persistentId
      let isNotifyBeforeScenePanel = callbackInfo[3]; // 3 is beforeScenePanel
      if (!screenPropertyCallback || isNotifyBeforeScenePanel) {
        continue;
      }
      if (persistentId !== null) {
        let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId);
        if (!systemSceneSession?.getVisibility()) {
          inVisibleSystemSceneCallbacks.push(
            [callbackInfo[0], callbackInfo[1], callbackInfo[2]]); // 0 is callback,1 is isRotatable,2 is persistentId
          continue;
        }
      }
      let TraceName: string = 'updateSystemSceneFoldChange: ' + this.callbackRegisterMap.get(screenPropertyCallback);
      Trace.start(TraceName);
      log.showWarn(TraceName);
      try {
        if (!isRotatable && reason === SCBPropertyChangeReason.EXPAND_TO_FOLD &&
          (screenProperty.rotation === RotationConstants.ROTATION_90 ||
            screenProperty.rotation === RotationConstants.ROTATION_270)) {
          let tmpProperty = new SCBScreenProperty();
          tmpProperty.copy(screenProperty);
          [tmpProperty.width, tmpProperty.height] = [tmpProperty.height, tmpProperty.width];
          screenPropertyCallback(tmpProperty, reason);
        } else {
          screenPropertyCallback(screenProperty, reason);
        }
      } catch (e) {
        log.showError(`crash in ${TraceName}, error message ${e?.message}`);
      }
      Trace.end(TraceName);
    }
    return inVisibleSystemSceneCallbacks;
  }

  /**
   * Update system scene fold before scene panel
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @returns void
   */
  public updateSystemSceneFoldChangeBeforeScenePanel(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason): void {
    if (!this.screenPropertyChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} updateSystemSceneFoldChangeBeforeScenePanel callback called`);
    for (let callbackInfo of this.screenPropertyChangeCallbacks.get(screenProperty.screenId)) {
      if (!callbackInfo) {
        continue;
      }
      let screenPropertyCallback = callbackInfo[0]; // 0 is callback
      let isRotatable = callbackInfo[1]; // 1 is isRotatable
      let persistentId = callbackInfo[2]; // 2 is persistentId
      let isNotifyBeforeScenePanel = callbackInfo[3]; // 3 is beforeScenePanel
      if (!screenPropertyCallback || !isNotifyBeforeScenePanel) {
        continue;
      }
      let TraceName: string = 'updateSystemSceneFoldChangeBeforeScenePanel: ' +
        this.callbackRegisterMap.get(screenPropertyCallback);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        if (!isRotatable && reason === SCBPropertyChangeReason.EXPAND_TO_FOLD &&
          (screenProperty.rotation === RotationConstants.ROTATION_90 ||
            screenProperty.rotation === RotationConstants.ROTATION_270)) {
          let tmpProperty = new SCBScreenProperty();
          tmpProperty.copy(screenProperty);
          [tmpProperty.width, tmpProperty.height] = [tmpProperty.height, tmpProperty.width];
          screenPropertyCallback(tmpProperty, reason);
        } else {
          screenPropertyCallback(screenProperty, reason);
        }
      } catch (e) {
        log.showError(`crash in ${TraceName}, error message ${e?.message}`);
      }
      Trace.end(TraceName);
    }
  }

  /**
   * Update invisible system scene fold
   *
   * @param { Array<[Function,boolean,number|null]> } inVisibleSystemSceneCallbacks
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @returns { Promise<void> }
   */
  public async updateInvisibleSystemSceneFoldChange(
    inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]>,
    screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): Promise<void> {
    await this.updateInvisibleSystemSceneFoldChangeSync(inVisibleSystemSceneCallbacks, screenProperty, reason);
  }

  private async updateInvisibleSystemSceneFoldChangeSync(
    inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]>,
    screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): Promise<void> {
    log.showInfo(`updateInvisibleSystemSceneFoldChange callbacks size:${inVisibleSystemSceneCallbacks.length}`);
    for (let callbackInfo of inVisibleSystemSceneCallbacks) {
      if (!callbackInfo) {
        continue;
      }
      // 0 is callback
      let screenPropertyCallback = callbackInfo[0];
      // 1 is isRotatable
      let isRotatable = callbackInfo[1];
      if (!screenPropertyCallback) {
        continue;
      }
      let TraceName: string = 'updateInvisibleSystemSceneFoldChange: ' +
        this.callbackRegisterMap.get(screenPropertyCallback);
      Trace.start(TraceName);
      log.showWarn(TraceName);
      try {
        if (!isRotatable && reason === SCBPropertyChangeReason.EXPAND_TO_FOLD &&
          (screenProperty.rotation === RotationConstants.ROTATION_90 ||
            screenProperty.rotation === RotationConstants.ROTATION_270)) {
          let tmpProperty = new SCBScreenProperty();
          tmpProperty.copy(screenProperty);
          [tmpProperty.width, tmpProperty.height] = [tmpProperty.height, tmpProperty.width];
          screenPropertyCallback(tmpProperty, reason);
        } else {
          screenPropertyCallback(screenProperty, reason);
        }
      } catch (e) {
        log.showError(`crash in ${TraceName}`);
      }
      Trace.end(TraceName);
    }
  }

  /**
   * The callbacks of register screen rotate changing
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public registerScreenRotateChangeCallbacks(callback: Function, screenId?: number): void {
    log.showInfo(`registerScreenRotateChangeCallbacks caller: ` + this.getCallerStack());
    if (screenId === undefined) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    if (!this.screenRotateChangeCallbacks.has(screenId)) {
      this.screenRotateChangeCallbacks.set(screenId, new Array());
    }
    this.screenRotateChangeCallbacks.get(screenId).push([callback]);
    log.showInfo(`registerScreenRotateChangeCallbacks screenId: ${screenId} ` +
      this.screenRotateChangeCallbacks.get(screenId)?.length);
  }
 
  /**
   * The callbacks of unregister screen rotate changing
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public unRegisterScreenRotateChangeCallbacks(callback: Function, screenId?: number): void {
    log.showInfo(`unRegisterScreenRotateChangeCallbacks caller: ` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (screenId === undefined) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    if (!this.screenRotateChangeCallbacks.has(screenId)) {
      return;
    }
    let callBackArray = this.screenRotateChangeCallbacks.get(screenId);
    let index = -1;
    for (let i = 0; i < callBackArray?.length; i++) {
      let item = callBackArray[i];
      if (item[0] === callback) {
        index = i;
        break;
      }
    }
    if (index !== -1) {
      let removed = this.screenRotateChangeCallbacks.get(screenId).splice(index, 1);
      log.showInfo(`unRegisterScreenRotateChangeCallbacks index:${index} removed:${removed.length}`);
    }
  }
 
  /**
   * update ScbScreenProperty To Screen Rotate Callbacks.
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public notifyScreenRotateToCallbacks(screenProperty: SCBScreenProperty,
    reason: SCBRotateChangeReason): void {
    if (!this.screenRotateChangeCallbacks.has(screenProperty.screenId)) {
      log.showError(`[ROATION][notifyScreenRotateToCallbacks] screenId: ${screenProperty.screenId} no callback`);
      return;
    }
    for (let callbackInfo of this.screenRotateChangeCallbacks.get(screenProperty.screenId)) {
      if (callbackInfo && callbackInfo[0]) {
        let TraceName: string = 'notifyScreenRotateToCallbacks: ' + this.callbackRegisterMap.get(callbackInfo[0]);
        Trace.start(TraceName);
        try {
          callbackInfo[0](screenProperty, reason);
        } catch (e) {
          log.showError(`crash in ${TraceName}`);
        }
        Trace.end(TraceName);
      }
    }
    log.showInfo(`[ROATION][notifyScreenRotateToCallbacks] screenId: ${screenProperty.screenId}, reason ${reason}`);
  }

  /**
   * Set the screen orientation is locked
   *
   * @param { Boolean } isLocked
   * @param { Number } screenId
   */
  public setScreenOrientationLocked(isLocked: boolean, screenId?: number): void {
    let traceName: string = 'setScreenOrientationLocked: ' + this.getCallerStack();
    Trace.start(traceName);
    log.showInfo(traceName);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    let screenSession = this.getScreenSession(screenId);
    if (screenSession) {
      screenSession.session?.setScreenRotationLocked(isLocked);
    }
    let systemUIContext = GlobalContext.getContext();
    this.updateOrientationLock = true;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[setScreenOrientationLocked] isLocked: ' + isLocked + ', isFoldablePhoneExpandStatus: ' +
      SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
    try {
      if (isLocked) {
        // auto rotation locked
        try {
          settings.setValueSync(systemUIContext, settings.general.ACCELEROMETER_ROTATION_STATUS,
            SettingsConstants.AUTO_ROTATE_OFF);
        } catch (e) {
          WinLog.showError(WinLogDomain.WMS_ROTATION, `[setScreenOrientationLocked] setValue:${JSON.stringify(e)}`);
        }
        screenSession.recordRotationWhenLockAutoRotation();
        this.resetRotationWhenOrientationLocked(screenSession);
      } else {
        try {
          settings.setValueSync(systemUIContext, settings.general.ACCELEROMETER_ROTATION_STATUS,
            SettingsConstants.AUTO_ROTATE_ON);
        } catch (e) {
          WinLog.showError(WinLogDomain.WMS_ROTATION, `[setScreenOrientationLocked] setValue:${JSON.stringify(e)}`);
        }
        // rotation is triggered when switch is turned on
        if (SCBSceneSessionManager.getInstance().isRotateLockedUnrelatedSessionActive(
          screenSession.scbScreenProperty.screenId)) {
          WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[setScreenOrientationLocked] session not need rotate when unlock.');
          Trace.end(traceName);
          return;
        }
        if (screenSession) {
          screenSession.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'orientation lock change');
        }
      }
    } catch (e) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, `[setScreenOrientationLocked] setValue e: ${JSON.stringify(e)}`);
    }
    Trace.end(traceName);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[setScreenOrientationLocked] caller: ` + this.getCallerStack() + `, isLocked: ${isLocked}`);
  }

  /**
   * Get whether the screen orientation is locked
   *
   * @param { Number } screenId
   * @returns { Boolean }
   */
  public getScreenOrientationLocked(screenId?: number): boolean {
    if (this.updateOrientationLock) {
      let ret: boolean = this.getOrientationLockByIpc();
      log.showInfo(`getScreenOrientationLocked getValue,value:${ret}`);
      this.screenRotationLocked = ret;
      this.updateOrientationLock = false;
      return ret;
    }
    log.showInfo(`screenRotationLocked value:${this.screenRotationLocked}`);
    return this.screenRotationLocked;
  }

  /**
   * Registering the scene panel property Change Event
   *
   * @param { Function } callback
   * @param { Number } type
   * @param { Number } screenId
   */
  public registerPropertyChangeScenePanelCallback(callback: Function, type: number, screenId?: number): void {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    log.showInfo(`screenId: ${screenId} registerPropertyChangeScenePanelCallback caller` + this.getCallerStack());
    if (!this.propertyChangeScenePanelCallback.has(screenId)) {
      this.propertyChangeScenePanelCallback.set(screenId, new Map());
    }
    this.callbackRegisterMap.set(callback, this.getCallerStack());
    this.propertyChangeScenePanelCallback.get(screenId).set(type, callback);
  }

  public unRegisterPropertyChangeScenePanelCallback(callback: Function, type: number, screenId?: number): void {
    log.showInfo(`UnregisterPropertyChangeScenePanelCallback caller` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    let callerStack: string = this.getCallerStack();
    this.callbackRegisterMap.delete(callback);
    log.showInfo(`callbackRegisterMap callerStack: ${callerStack}`);
    if (!this.propertyChangeScenePanelCallback.has(screenId)) {
      return;
    }
    this.propertyChangeScenePanelCallback.get(screenId).delete(type);
  }

  /**
   * Registering start fold to expand Event
   *
   * @param { Function } callback
   * @param { Number } type
   * @param { Number } screenId
   */
  public registerStartFoldToExpandChangeCallback(callback: Function, type: number, screenId?: number): void {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    log.showInfo(`screenId: ${screenId} registerStartFoldToExpandChangeCallback caller` + this.getCallerStack());
    if (!this.startFoldToExpandChangeCallback.has(screenId)) {
      this.startFoldToExpandChangeCallback.set(screenId, new Map());
    }
    this.callbackRegisterMap.set(callback, this.getCallerStack());
    this.startFoldToExpandChangeCallback.get(screenId).set(type, callback);
  }

  /**
   * Unregistering start fold to expand Event
   *
   * @param { Function } callback
   * @param { Number } type
   * @param { Number } screenId
   */
  public UnregisterStartFoldToExpandChangeCallback(callback: Function, type: number, screenId?: number): void {
    log.showInfo(`UnregisterStartFoldToExpandChangeCallback caller` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    let callerStack: string = this.getCallerStack();
    this.callbackRegisterMap.delete(callback);
    log.showInfo(`callbackRegisterMap callerStack: ${callerStack}`);
    if (!this.startFoldToExpandChangeCallback.has(screenId)) {
      return;
    }
    this.startFoldToExpandChangeCallback.get(screenId).delete(type);
  }

  /**
   * Notify the changing of scene panel rotation
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBScreenProperty } scbScreenProperty
   */
  public notifyScenePanelRotationChange(screenProperty: SCBScreenProperty,
                                        scbScreenProperty?: SCBScreenProperty): void {
    if (!this.propertyChangeScenePanelCallback.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    let rotationChangeCallbacks: Map<number, Function> =
      this.propertyChangeScenePanelCallback.get(screenProperty.screenId);
    if (rotationChangeCallbacks.size === 0) {
      log.showError(`screenId: ${screenProperty.screenId} has no rotationChangeCallback callback`);
      return;
    }

    log.showInfo(`screenId: ${screenProperty.screenId} notifyScenePanelRotationChange called`);
    let currScreenProperty = new SCBScreenProperty();
    if (scbScreenProperty) {
      currScreenProperty.copy(scbScreenProperty);
    }
    rotationChangeCallbacks.forEach((value, key)=>{
      let TraceName: string = 'notifyScenePanelRotationChange: ' + this.callbackRegisterMap.get(value);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        value(screenProperty, SCBPropertyChangeReason.ROTATION, currScreenProperty);
      } catch (e) {
        log.showError(`crash in ${TraceName}, error is ${e?.message}`);
      }
      Trace.end(TraceName);
    });
  }

  /**
   * handle Fold Status Change
   *
   * @param foldStatus
   */
  public handleFoldStatusChange(foldStatus: display.FoldStatus): void {
    let hoverTime = ROTATION_DELAY_TIME_FROM_EXPANDED;
    let isFold = this.currentState === display.FoldStatus.FOLD_STATUS_FOLDED;
    if (isFold) {
      hoverTime = ROTATION_DELAY_TIME_FROM_FOLDED;
    }
    if (DeviceHelper.isSmallFoldProduct()) {
      AppStorage.setOrCreate<number>('foldStatusForOuterScreen', isFold ? 0 : 1);
    }
    log.showInfo(`handleFoldStatusChange currentState: ${this.currentState}, nextStatus: ${foldStatus}`);
    this.currentState = foldStatus;
    this.rotationDecoupleWhenHalfFold(foldStatus, hoverTime);
  }

  /**
   * get curFoldStatus of three fold product, used by multi-window
   *
   * @return display.FoldStatus
   */
  public getCurFoldStatus(): display.FoldStatus {
    if (DeviceHelper.isThreeFoldProduct()) {
      let foldStatus: display.FoldStatus = this.currentState;
      if (foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN) {
        try {
          foldStatus = display.getFoldStatus();
        } catch (error) {
          log.error(`getFoldStatus error.code: ${error?.code}, error.message: ${error?.message}`);
        }
      }
      return foldStatus;
    }
    return this.currentState;
  }

  private rotationDecoupleWhenHalfFold(foldStatus: display.FoldStatus, hoverTime: number): void {
    let screenSession = this.getMainScreenSession();
    if (!screenSession) {
      log.showError('this screenSession is null');
      return;
    }
    if (this.hoverTimerId !== -1) {
      clearTimeout(this.hoverTimerId);
    }
    this.hoverTimerId = setTimeout(() => {
      if (foldStatus !== DeviceHelper.getFoldStatus() || foldStatus === this.currentFoldStatus) {
        log.showWarn('this device is expanded to folded or folded to expanded');
        return;
      }
      let scenePanelState: number = AppStorage.get<number>('scenePanelState');
      log.showInfo(`scenePanelState is  ${scenePanelState}`);
      let screenOrientationLocked = this.getScreenOrientationLocked(screenSession.scbScreenProperty.screenId);
      if (foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED && screenOrientationLocked && scenePanelState !== ScenePanelState.HOME) {
        this.currentFoldStatus = foldStatus;
        this.isRestoreRotation = true;
        this.lastRotation = screenSession.rotationWhenLockAutoRotation;
        log.showInfo(`screenSession lastRotation is  ${screenSession.rotationWhenLockAutoRotation}`);
        this.setScreenOrientationLocked(false, screenSession.scbScreenProperty.screenId);
        return;
      }
      if (this.isRestoreRotation) {
        if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
          log.showInfo(`rotationChangeEntry rotation: ${RotationConstants.ROTATION_0}`);
          screenSession.rotationChangeEntry(RotationConstants.ROTATION_0, 'HalfFold rotation change');
        } else {
          log.showInfo(`rotationChangeEntry rotation: ${this.lastRotation}`);
          screenSession.rotationChangeEntry(this.lastRotation, 'HalfFold exit rotation change');
        }
        this.setScreenOrientationLocked(true, screenSession.scbScreenProperty.screenId);
        this.isRestoreRotation = false;
        screenSession.recordRotationWhenExitHalfFold(this.lastRotation);
      }
      this.currentFoldStatus = foldStatus;
    }, hoverTime);
  }

  /**
   * set Is Restore Rotation
   *
   * @param isRestoreRotation
   */
  public setIsRestoreRotation(isRestoreRotation: boolean): void {
    this.isRestoreRotation = isRestoreRotation;
  }

  /**
   * Notify the changing of scene panel active mode
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public notifyScenePanelActiveModeChange(screenProperty: SCBScreenProperty): void {
    if (!this.propertyChangeScenePanelCallback.has(screenProperty.screenId)) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, `[notifyScenePanelActiveModeChange] screenId: ${screenProperty.screenId},` + 
                    ` has no property change callback`);
      return;
    }
    let activeModeChangeCallbacks: Map<number, Function> =
      this.propertyChangeScenePanelCallback.get(screenProperty.screenId);
    if (activeModeChangeCallbacks.size === 0) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, `[notifyScenePanelActiveModeChange] screenId: ${screenProperty.screenId}, ` + 
                    `has no ActiveModeChange callback`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyScenePanelActiveModeChange] notify screenId: ' + screenProperty.screenId + 
                 ' ScenePanelActiveModeChangeCallback ScreenProperty: ' + JSON.stringify(screenProperty));
    activeModeChangeCallbacks.forEach((value, key)=>{
      let TraceName: string = 'notifyScenePanelActiveModeChange: ' + this.callbackRegisterMap.get(value);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        value(screenProperty, SCBPropertyChangeReason.CHANGE_MODE);
      } catch (e) {
        WinLog.showError(WinLogDomain.WMS_ROTATION, `[notifyScenePanelActiveModeChange] crash in ${TraceName}`);
      }
      Trace.end(TraceName);
    });
  }

  /**
   * Notify the changing of scene panel fold
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @param { SCBScreenProperty } currScreenProperty
   */
  public notifyScenePanelFoldChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
                                    currScreenProperty?: SCBScreenProperty): void {
    this.notifyScenePanelPropertyChange(screenProperty, reason, currScreenProperty);
  }

  /**
   * Notify the changing of scene panel
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @param { SCBScreenProperty } currScreenProperty
   */
  public notifyScenePanelPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
                                        currScreenProperty?: SCBScreenProperty): void {
    if (!this.propertyChangeScenePanelCallback.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    let callbacks: Map<number, Function> = this.propertyChangeScenePanelCallback.get(screenProperty.screenId);
    if (callbacks.size === 0) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    log.showInfo(`screenId: ${screenProperty.screenId} notifyScenePanelPropertyChange called`);
    callbacks.forEach((value, key)=>{
      let TraceName: string = 'notifyScenePanelPropertyChange: ' + this.callbackRegisterMap.get(value);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        value(screenProperty, reason, currScreenProperty);
      } catch (e) {
        log.showError(`crash in ${TraceName}`);
      }
      Trace.end(TraceName);
    });
  }

  /**
   * Notify start fold to expand change
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   * @param { SCBScreenProperty } currScreenProperty
   */
  public notifyStartFoldToExpandChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
    currScreenProperty?: SCBScreenProperty): void {
    if (!this.startFoldToExpandChangeCallback.has(screenProperty.screenId)) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    let callbacks: Map<number, Function> = this.startFoldToExpandChangeCallback.get(screenProperty.screenId);
    if (callbacks.size === 0) {
      log.showError(`screenId: ${screenProperty.screenId} has no property change callback`);
      return;
    }
    callbacks.forEach((value, key)=>{
      let TraceName: string = 'notifyStartFoldToExpandChange: ' + this.callbackRegisterMap.get(value);
      Trace.start(TraceName);
      log.showInfo(TraceName);
      try {
        value(screenProperty, reason, currScreenProperty);
      } catch (e) {
        log.showError(`crash in ${TraceName}`);
      }
      Trace.end(TraceName);
    });
  }

  /**
   * Notify before screen property change
   *
   * @param { number } screenId
   * @param { FoldStatus } foldStatus
   */
  public notifyBeforeScreenPropertyChange(screenId: number, foldStatus: display.FoldStatus): void {
    if (!this.beforeScreenPropertyCallBacks.has(screenId)) {
      log.showError(`screenId: ${screenId} has no property change callback`);
      return;
    }
    for (let callbackInfo of this.beforeScreenPropertyCallBacks.get(screenId)) {
      if (callbackInfo && callbackInfo[0]) {
        let TraceName: string = 'notifyBeforeScreenPropertyChange: ' + this.callbackRegisterMap.get(callbackInfo[0]);
        Trace.start(TraceName);
        try {
          callbackInfo[0](foldStatus);
        } catch (e) {
          log.showError(`crash in ${TraceName}`);
        }
        Trace.end(TraceName);
      }
    }
    log.showInfo(`screenId: ${screenId} notifyBeforeScreenPropertyChange called ${foldStatus}`);
  }

   /**
   * register the callback of before screen property change
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
   public registerBeforeScreenPropertyChangeCallbacks(callback: Function, screenId?: number): void {
    log.showInfo(`registerBeforeScreenPropertyChangeCallbacks caller: ` + this.getCallerStack());
    if (screenId === undefined) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    if (!this.beforeScreenPropertyCallBacks.has(screenId)) {
      this.beforeScreenPropertyCallBacks.set(screenId, new Array());
    }
    this.beforeScreenPropertyCallBacks.get(screenId).push([callback]);
    this.callbackRegisterMap.set(callback, this.getCallerStack());
    log.showInfo(`registerBeforeScreenPropertyChangeCallbacks screenId: ${screenId} ` +
      this.beforeScreenPropertyCallBacks.get(screenId)?.length);
  }
 
  /**
   * unregister the callback of before screen property change
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public unRegisterBeforeScreenPropertyChangeCallbacks(callback: Function, screenId?: number): void {
    log.showInfo(`unRegisterBeforeScreenPropertyChangeCallbacks caller: ` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (screenId === undefined) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        return;
      }
    }
    if (!this.beforeScreenPropertyCallBacks.has(screenId)) {
      return;
    }
    let callBackArray = this.beforeScreenPropertyCallBacks.get(screenId);
    let index = -1;
    for (let i = 0; i < callBackArray?.length; i++) {
      let item = callBackArray[i];
      if (item[0] === callback) {
        this.callbackRegisterMap.delete(callback);
        index = i;
        break;
      }
    }
    if (index !== -1) {
      let removed = this.beforeScreenPropertyCallBacks.get(screenId).splice(index, 1);
      log.showInfo(`unRegisterBeforeScreenPropertyChangeCallbacks index:${index} removed:${removed.length}`);
    }
  }

  /**
   * notify cpp
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public updateScreenRotationProperty(screenProperty: SCBScreenProperty,
    notifyType: SCBRotateChangeReason = SCBRotateChangeReason.UNSPECIFIED): void {
    let notifyRotation = screenProperty.displayRotation;
    if (SCREEN_SCAN_TYPE === SCBConstants.SCREEN_SCAN_TYPE_VERTICAL) {
      notifyRotation = (notifyRotation + RotationConstants.ROTATION_90) % RotationConstants.ROTATION_360;
    }
    // C++侧对折叠机展开态做了横竖屏转换，这里需要使用sensor角度下发
    let screenSession = this.getScreenSession(screenProperty.screenId);
    if (screenSession && screenSession.isFoldablePhoneExpandStatus()) {
      notifyRotation = screenProperty.rotation;
    }
    let directionInfo: screenSessionManager.ScreenDirectionInfo = {
      notifyRotation: notifyRotation,
      screenRotation: screenSession?.getScreenComponentRotation(screenProperty.rotation),
      rotation: screenProperty.rotation,
      phyRotation: screenSession?.getPhyRotation(screenProperty.rotation),
    };
    WinLog.showWarn(WinLogDomain.WMS_ROTATION, `[updateScreenRotationProperty] directionInfo: ${this.getDirectionInfoLog(directionInfo)},` +
      ` notifyType:${notifyType}, screenProperty: ${screenProperty.getLogString()} ,caller:` + this.getCallerStack());
    let updateType = screenSessionManager.ScreenPropertyChangeType.UNSPECIFIED;
    if (notifyType === SCBRotateChangeReason.ROTATE_BEGIN) {
      updateType = screenSessionManager.ScreenPropertyChangeType.ROTATION_BEGIN;
    } else if (notifyType === SCBRotateChangeReason.ROTATE_END) {
      updateType = screenSessionManager.ScreenPropertyChangeType.ROTATION_END;
    } else if (notifyType === SCBRotateChangeReason.ROTATION_UPDATE_PROPERTY_ONLY) {
      updateType = screenSessionManager.ScreenPropertyChangeType.ROTATION_UPDATE_PROPERTY_ONLY;
    } else if (notifyType === SCBRotateChangeReason.ROTATION_UPDATE_PROPERTY_ONLY_NOT_NOTIFY) {
      updateType = screenSessionManager.ScreenPropertyChangeType.ROTATION_UPDATE_PROPERTY_ONLY_NOT_NOTIFY;
    }
    SCBKeyboardPanelManager.getInstance().updateScreenPropertyForKeyboardPanel(screenProperty);
    screenSessionManager.updateScreenRotationProperty(screenProperty.screenId,
      {
        left: screenProperty.left,
        top: screenProperty.top,
        width: screenProperty.width,
        height: screenProperty.height,
        radius: screenProperty.radius
      },
      directionInfo, updateType);
  }

  // get string for directionInfo
  public getDirectionInfoLog(directionInfo: screenSessionManager.ScreenDirectionInfo): string {
    let logString: string = `notifyRotation: ${directionInfo.notifyRotation},` +
      `screenComponentRotation: ${directionInfo.screenRotation}, rotation: ${directionInfo.rotation}`;
    return logString;
  }

  /**
   * Get whether the foldable phone is expand
   *
   * @param { Number } screenId
   * @returns { Boolean }
   */
  public isFoldablePhoneExpandStatus(screenId?: number) : boolean {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    let screenSession = this.getScreenSession(screenId);
    if (!screenSession) {
      log.showError('getFoldStatus failed to get screen session with screenId: ' + screenId);
      return false;
    }
    return screenSession.isFoldablePhoneExpandStatus();
  }

  /**
   * Get whether the secondary foldable phone is global full state
   * @param
   * @returns { Boolean }
   */
  public isSecondaryFoldablePhoneExpandStatus(): boolean {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return false;
    }

    let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'isSecondaryFoldablePhoneExpandStatus screenSession is null');
      return false;
    }
    let foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (error) {
      log.error('get fold staus failed', error);
    }
    return foldStatus === 11 || foldStatus === 21 || foldStatus === 13 || foldStatus === 23;
  }

  /**
   * Register callback for shutdown
   */
  public registerShutdownCallback(): void {
    log.showInfo(`registerShutdownCallback caller: ` + this.getCallerStack());
    try {
      screenSessionManager.registerShutdownCallback((reason: string, isReboot: boolean) => {
        if (reason === 'eupdater') {
          log.showInfo(`reason is eupdater, do eupdater`);
          this.unRegisterShutdownCallback();
          power.reboot('eupdater');
          return;
        }
        log.showInfo(`callbackFunc is called, isRebbot:${isReboot}`);
        this.unRegisterShutdownCallback();
        if (this.powerStatusController) {
          this.powerStatusController.changePowerStatus(isReboot ? PowerStatus.REBOOT : PowerStatus.SHUTDOWN);
        } else {
          this.shutdownDirectly(isReboot);
        }
      });
    } catch (error) {
      log.showError(`registerShutdownCallback failed, Error : ${error}`);
    }
  }

  /**
   * Set force close HDR
   *
   * @param { boolean } isForceCloseHdr
   */
  public setForceCloseHdr(isForceCloseHdr: boolean): void {
    let screenId = this.getMainScreenSession()?.session?.screenId ?? 0;
    try {
      screenSessionManager.setForceCloseHdr(screenId, isForceCloseHdr);
      log.showInfo(`setForceCloseHdr, screenId: ${screenId}, isForceCloseHdr: ${isForceCloseHdr}`);
    } catch (error) {
      log.showError(`setForceCloseHdr with screenId ${screenId} failed, Error: ${error}`);
    }
  }

  /**
   * Update the available area
   *
   * @param { Number } screenId
   */
  public updateAvailableArea(screenId?: number): void {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    let screenSession = this.getScreenSession(screenId);
    let availableArea = screenSession.availableArea;
    screenSessionManager.updateAvailableArea(screenId, availableArea);
  }

  /**
   * Unregister callback for shutdown
   */
  public unRegisterShutdownCallback(): void {
    log.showInfo(`unRegisterShutdownCallback caller: ` + this.getCallerStack());
    try {
      screenSessionManager.unRegisterShutdownCallback();
    } catch (error) {
      log.showError(`unRegisterShutdownCallback failed, Error : ${error}`);
    }
  }

  /**
   * Register powerStatusController for shutdown
   */
  public registerPowerStatusController(controller: PowerStatusController): void {
    log.showInfo(`registerPowerStatusController caller: ` + this.getCallerStack());
    if (controller) {
      this.powerStatusController = controller;
    }
  }

  /**
   * Register powerStatusController for shutdown
   */
  public unRegisterPowerStatusController(): void {
    log.showInfo(`unRegisterPowerStatusController caller: ` + this.getCallerStack());
    this.powerStatusController = null;
  }

  public getPowerStatusController(): PowerStatusController {
    return this.powerStatusController;
  }

  private shutdownDirectly(isReboot: boolean): void {
    if (isReboot) {
      log.showWarn('sth wrong with reboot animation, reboot directly.');
      power.reboot('reboot_by_user');
    } else {
      log.showWarn('sth wrong with shutdown animation, shutdown directly.');
      power.shutdown('shutdown_by_user');
    }
  }

  /**
   * Notify screen lock event
   *
   * @param { Number } event
   */
  public notifyScreenLockEvent(event: number): void {
    if (typeof screenSessionManager.notifyScreenLockEvent === 'function') {
      screenSessionManager.notifyScreenLockEvent(event);
    } else {
      log.showWarn('notifyScreenLockEvent does not exist on screenSessionManager');
    }
  }

  /**
   * Get property of physicals screen
   *
   * @param { Number } screenId
   * @returns { SCBScreenProperty }
   */
  public getPhyScreenProperty(screenId: number): SCBScreenProperty {
    let screenProperty = screenSessionManager.getPhyScreenProperty(screenId);
    let scbScreenProperty = new SCBScreenProperty();
    scbScreenProperty.update(screenProperty);
    return scbScreenProperty;
  }

  /**
   * Reset the screen rotation with phone in fold
   *
   * @param { SCBScreenSession } screenSession
   */
  public resetRotationWhenOrientationLocked(screenSession: SCBScreenSession): void {
    let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!screenSession || uiType !== SCBConstants.UITYPE_PHONE) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[resetRotationWhenOrientationLocked] screenSession is null or device is not phone');
      return;
    }
    if (screenSession.isFoldablePhoneExpandStatus()) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[resetRotationWhenOrientationLocked] foldablephone status is expand');
      return;
    }
    let currScreenRotation = screenSession.scbScreenProperty.rotation;
    if (currScreenRotation === RotationConstants.ROTATION_0) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[resetRotationWhenOrientationLocked] currScreenRotation is ROTATION_0');
      return;
    }

    // rotation is triggered when switch is turned on
    if (SCBSceneSessionManager.getInstance().isRotateLockedUnrelatedSessionActive(
      screenSession.scbScreenProperty.screenId)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[resetRotationWhenOrientationLocked] session not need rotate when unlock.`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[resetRotationWhenOrientationLocked] no need rotate to 0.');
  }

  public resetRotationHandleDropDownWindowHideScreenSensor(screenSession: SCBScreenSession): boolean {
    //收起的时候，判断旋转锁定
    if (!SCBScreenSessionManager.getInstance().getScreenOrientationLocked(screenSession.scbScreenProperty.screenId)) {
      log.showInfo(`screen orientation is locked.`);
      return false;
    }
    let uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!screenSession || uiType !== SCBConstants.UITYPE_PHONE) {
      log.showError(TAG, 'resetRotationWhenOrientationLocked screenSession is null or device is not phone');
      return false;
    }
    if (screenSession.isFoldablePhoneExpandStatus()) {
      log.showError(TAG, 'resetRotationWhenOrientationLocked foldablephone status is expand');
      return false;
    }
    let currScreenRotation = screenSession.scbScreenProperty.rotation;
    if (currScreenRotation === RotationConstants.ROTATION_0) {
      log.showInfo(TAG, 'resetRotationWhenOrientationLocked currScreenRotation is ROTATION_0');
      return false;
    }
    // rotation is triggered when switch is turned on
    if (SCBSceneSessionManager.getInstance().isRotateLockedUnrelatedSessionActive(
      screenSession.scbScreenProperty.screenId)) {
      log.showInfo(`active RotateLockedUnrelated session not need rotate when unlock.`);
      return false;
    }
    screenSession.rotationChangeByWindow(RotationConstants.ROTATION_0, 'setScreenOrientationLocked change lazy');
    return true;
  }

  private getSingleFoldDeviceRotate(screenSession: SCBScreenSession): number {
    if (screenSession.isTentStatus) {
      log.showInfo(TAG, 'tent status to lock');
      return RotationConstants.ROTATION_0;
    } else if (screenSession.isCameraStatus) {
      log.showInfo(TAG, 'camera status to lock');
      return RotationConstants.ROTATION_180;
    } else {
      log.showInfo(TAG, 'SingleDisplayPocketFoldDevice foldablephone status is fold');
      return RotationConstants.ROTATION_270;
    }
  }

  /**
   * Notify whether the fold to be expand
   *
   * @param { Boolean } foldToExpand
   */
  public notifyFoldToExpandCompletion(foldToExpand: boolean): void {
    log.showInfo('notifyFoldToExpandCompletion');
    Trace.start('notifyFoldToExpandCompletion');
    screenSessionManager.notifyFoldToExpandCompletion(foldToExpand);
    Trace.end('notifyFoldToExpandCompletion');
  }

  /**
   * Record event to screen event tracker
   *
   * @param { string } description
   * @param { Boolean } needRecordEvent
   */
  private recordEventFromScb(description: string, needRecordEvent: boolean): void {
    log.showInfo('recordEventFromScb');
    screenSessionManager.recordEventFromScb(description, needRecordEvent);
  }

  /**
   * Check whether the screen specified by screenId is vertical
   *
   * @param { number } screenId
   */
  public isScreenVertical(screenId?: number): boolean {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    const screenSession = this.getScreenSession(screenId);
    if (!screenSession) {
      log.showError(`screen session ${screenId} is null`);
      return true;
    }
    return screenSession.scbScreenProperty.isScreenVertical();
  }

  /**
   * Get rotation of screen specified by screenId
   *
   * @param { number } screenId
   */
  public getScreenRotation(screenId?: number): number {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    const screenSession = this.getScreenSession(screenId);
    if (!screenSession) {
      log.showError(`screen session ${screenId} is null`);
      return RotationConstants.ROTATION_0;
    }
    return screenSession.scbScreenProperty.rotation;
  }

  /**
   * Set the delay time of screen off
   *
   * @param { Number } delay
   */
  public setScreenOffDelayTime(delay: number): void {
    if (typeof screenSessionManager.setScreenOffDelayTime === 'function') {
      log.showInfo(`setScreenOffDelayTime, delay = ${delay}`);
      screenSessionManager.setScreenOffDelayTime(delay);
    } else {
      log.showWarn('setScreenOffDelayTime does not exist on screenSessionManager');
    }
  }

  /**
   * Set Camera status and position.
   *
   * @param { Number } cameraStatus
   * @param { Number } cameraPosition
   */
  public setCameraStatus(cameraStatus: number, cameraPosition: number): void {
    if (typeof screenSessionManager.setCameraStatus === 'function') {
      log.showInfo(`setCameraStatus, cameraStatus = ${cameraStatus}, cameraPosition = ${cameraPosition}`);
      screenSessionManager.setCameraStatus(cameraStatus, cameraPosition);
    } else {
      log.showWarn('setCameraStatus does not exist on screenSessionManager');
    }
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

  /**
   * Get UIContext of screen specified by screenId
   *
   * @param { number } screenId
   */
  public getScreenUIContext(screenId?: number): UIContext {
    if (screenId === undefined || screenId === 0) {
      return sceneSessionManager.getRootSceneUIContext();
    }
    let screenSession = this.getScreenSession(screenId);
    if (screenSession) {
      return screenSession.session?.getScreenUIContext();
    } else {
      log.showError(`screen session ${screenId} is null`);
      return null;
    }
  }

  /**
   * The callbacks of register wrap rotation
   *
   * @param { Function } callback
   * @param { Number } screenId
   */
  public registerWrapRotateEntryCallback(callback: Function, screenId?: number): void {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    log.showInfo(`screenId: ${screenId} registerWrapRotateEntryCallback caller` + this.getCallerStack());
    this.callbackRegisterMap.set(callback, this.getCallerStack());
    this.warpRotateChangeCallbacks.set(screenId, callback);
  }

  /**
   * The callbacks of unRegister wrap rotation
   * @param { Number } screenId
   */
  public unRegisterWrapRotateEntryCallback(callback: Function, screenId?: number): void {
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    log.showInfo(`screenId: ${screenId} unRegisterWrapRotateEntryCallback caller` + this.getCallerStack());
    this.callbackRegisterMap.delete(callback);
    this.warpRotateChangeCallbacks.delete(screenId);
  }

  /**
   * notifyWrapRotateEntry
   * @param { number } screenId
   * @param { WrapRotationEntryParam } wrapRotationEntryParam
   */
  public notifyWrapRotateEntry(screenId: number, wrapRotationEntryParam: WrapRotationEntryParam): void {
    if (!this.warpRotateChangeCallbacks.has(screenId)) {
      log.showError(`screenId: ${screenId} has no property change callback`);
      return;
    }
    let rotationChangeCallbacks: Function = this.warpRotateChangeCallbacks.get(screenId);
    if (rotationChangeCallbacks === null || rotationChangeCallbacks === undefined) {
      log.showError(`screenId: ${screenId} has no warpRotateChangeCallbacks callback`);
      return;
    }
    log.showInfo(`screenId: ${screenId}, rotationChangeCallbacks: ${rotationChangeCallbacks}, notifyWrapRotateEntry called`);
    let TraceName: string = 'notifyWrapRotateEntry: ' + this.callbackRegisterMap.get(rotationChangeCallbacks);
    Trace.start(TraceName);
    log.showInfo(TraceName);
    try {
      rotationChangeCallbacks(wrapRotationEntryParam);
    } catch (e) {
      log.showError(`crash in ${TraceName}， e:${e}`);
    }
    Trace.end(TraceName);
  }

  /**
   * The callbacks of register product type
   * @param { Function } callback
   * @param { SCBProductFuncType } type
   * @param { Number } screenId
   */
  public registerScreenProductCallback(callback: Function, type: SCBProductFuncType, screenId?: number): void {
    log.showInfo(`registerScreenProductCallback caller` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    log.showInfo(`screenId: ${screenId} registerScreenProductTypeCallback caller` + this.getCallerStack());
    if (!this.screenProductCallbacks.has(screenId)) {
      this.screenProductCallbacks.set(screenId, new Map());
    }
    this.callbackRegisterMap.set(callback, this.getCallerStack());
    this.screenProductCallbacks.get(screenId).set(type, callback);
  }

  /**
   * The callbacks of unRegister product callback
   * @param { Function } callback
   * @param { SCBProductFuncType } type
   * @param { Number } screenId
   */
  public unRegisterScreenProductCallback(callback: Function, type: SCBProductFuncType, screenId?: number): void {
    log.showInfo(`unRegisterScreenProductCallback caller` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    let callerStack: string = this.getCallerStack();
    this.callbackRegisterMap.delete(callback);
    log.showInfo(`callbackRegisterMap callerStack: ${callerStack}`);
    if (!this.screenProductCallbacks.has(screenId)) {
      return;
    }
    this.screenProductCallbacks.get(screenId).delete(type);
  }

  /**
   * The callbacks of unRegister product callback
   * @param { Number } screenId
   */
  public getScreenProductCallBackByType(type: SCBProductFuncType, screenId?: number): Function {
    log.showDebug(`getScreenProductCallBackByType caller` + this.getCallerStack() + ` screenId: ${screenId}`);
    if (!screenId) {
      if (this.getMainScreenSession()?.session) {
        screenId = this.getMainScreenSession().session.screenId;
      } else {
        screenId = 0;
      }
    }
    if (this.screenProductCallbacks && this.screenProductCallbacks.has(screenId) &&
      this.screenProductCallbacks.get(screenId)?.has(type)) {
      return this.screenProductCallbacks.get(screenId)?.get(type);
    }
    return undefined;
  }

  /**
   * Get whether the single statue phone is global fold state
   * @param
   * @returns { Boolean }
   */
  public isSingleFoldablePhoneFoldStatus(): boolean {
    let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'isSecondaryFoldablePhoneExpandStatus screenSession is null');
      return false;
    }
    return false;
  }

  /**
   * Get whether the single statue phone is global expand state
   * @param null
   * @returns { Boolean }
   */
  public isSingleFoldablePhoneExpandStatus(): boolean {
    let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'isSecondaryFoldablePhoneExpandStatus screenSession is null');
      return false;
    }
    return false;
  }

  /**
   * Set default multi screen mode when switch user
   */
  public setDefaultMultiScreenMode(): void {
    if (SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType === SCBConstants.UITYPE_PC) {
      screenSessionManager.setDefaultMultiScreenModeWhenSwitchUser();
    }
  }

  /**
   * update foldDisplayMode
   */
  public updateFoldDisplayMode(): void {
    this.foldDisplayMode = screenSessionManager.getFoldDisplayMode();
  }

  /**
   * Get the current fold display mode.
   */
  public getFoldDisplayMode(): screenSessionManager.FoldDisplayMode {
    return this.foldDisplayMode;
  }

  /**
   * notify screen and 0-level system scene ready
   * @param screenId screen id
   */
  public notifyScreenConnectCompletion(screenId: number): void {
    screenSessionManager.notifyScreenConnectCompletion(screenId);
  }

  /**
   * 触发旋转
   * @param screenSession
   * @param currentRotation
   * @param locked 是否锁定屏幕，传入true可跳过锁定
   */
  public handleRotationIfNeeded(screenSession: SCBScreenSession, currentRotation?: number, locked?: boolean): void {
    if (!screenSession) {
      return;
    }
    if (!this.resetRotationHandleDropDownWindowHideScreenSensor(screenSession)) {
      log.showInfo('resetRotationHandleDropDownWindowHideScreenSensor end');
      return;
    }
    // 屏幕锁定
    const showLocked = locked ?? this.getScreenOrientationLocked(screenSession.scbScreenProperty.screenId);
    if (showLocked) {
      log.showInfo('screen orientation is locked end');
      return;
    }
    // 旋转角度
    currentRotation == currentRotation ?? screenSession.sensorScreenProperty.rotation;
    const hideSensor = screenSession.sensorScreenProperty.rotation;
    if (hideSensor !== currentRotation ||
      !SCBSceneSessionManager.getInstance().isRotateLockedUnrelatedSessionActive(screenSession.scbScreenProperty.screenId)) {
      log.showInfo('go to rotationChangeEntry');
      screenSession.rotationChangeEntry(hideSensor, 'unlock sysDialog rotation');
    } else {
      log.showInfo('handleRotationIfNeeded skip rotationChangeEntry, sensor/lock policy unchanged');
    }
  }
}

