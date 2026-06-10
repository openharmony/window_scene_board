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

import osAccount from '@ohos.account.osAccount';
import hiSysEvent from '@ohos.hiSysEvent';
import {
  Trace,
  LogDomain,
  LogHelper,
  SingletonHelper,
  CommonUtils,
  ObjUtil
} from '@ohos/basicutils';
import {
  EvtBus,
  ScreenLockEvent,
  OuterHomeCallbackEvent,
  HiSysEventUtil,
  DeviceHelper,
  ReportParams,
  ViewManagerPolicy,
  sSettingsUtil,
  sOutSideWindowMgr,
  ViewType,
  HiDfxEventUtil,
  sEventManager,
  obtainLocalEvent,
  SCBDesktopCacheManager
} from '@ohos/frameworkwrapper';
import { DynamicWallPaperState, themeWallpaperAniMgr } from '@ohos/themeservice';
import {
  SCBTransitionManager,
  DisplayMgr,
  OccludeKeygaurdScene,
  sSCBOobeManager,
  sSCBOtaManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  scbGestureManager,
  AIBarConstants,
  UserSwitchEventType
} from '@ohos/windowscene';
import ScreenLockModel from './ScreenLockModel';
import { SystemParamUtils } from '@ohos/screenlockcommon/src/main/ets/utils/SystemParamUtils';
import accountModel,
{ AuthType,
  AuthSubType,
  AuthTurstLevel,
  IAMAuthResult,
  OsAccountSwitchEventData,
  accountSwitchCallback
} from './AccountsModel';
import commonEvent from '@ohos.commonEvent';
import { KeyguardStatusService } from '@ohos/screenlockcommon/src/main/ets/manager/KeyguardStatusService';
import type { BusinessError, Callback } from '@ohos.base';
import inputDevice from '@ohos.multimodalInput.inputDevice';
import type { IUserData } from '@ohos/screenlockcommon/src/main/ets/bean/IUserData';
import power from '@ohos.power';

import Constants, { CancelAuthPWDReason } from '@ohos/screenlockcommon/src/main/ets/constants/CommonConstants';
import { SensorType,
  FingerprintConstants,
  FingerprintVerifyState,
} from '@ohos/screenlockcommon/src/main/ets/constants/FingerprintConstants';
import { FaceUnlockConstants, FaceUnlockReason, FaceUnlockVerifyState }
  from '@ohos/screenlockcommon/src/main/ets/constants/FaceUnlockConstants';
import type { IAMAuthExtraInfo } from '@ohos/screenlockcommon/src/main/ets/bean/IAMAuthExtraInfo';
import { KeyGuardMode } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';

import display from '@ohos.display';

import { fingerprintReporter, UnlockStage } from '@ohos/screenlockcommon/src/main/ets/manager/FingerprintReporter';
import type { ScreenUnlockEventParams } from '@ohos/frameworkwrapper';
import {
  screenLockInnerStateManager as screenLockStateManager,
  ScreenLockState, ScreenLockTransitionState
} from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';
import commonEventManager from '@ohos.commonEventManager';
import { GlobalStatusCache,
  KeyGuardCacheKey,
  LockEventType,
  LockOperateResult,
  PowerUtils,
  slClockOneShotToDesktopService,
  SlServerHelper,
  StatusCacheConst } from '@ohos/screenlockcommon';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { OneMirrorStaticStateType, SlMainStateType, SlStaticStateType }
  from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import ScreenLockMar from '@ohos.screenLock';
import { privacySpaceManager, AuthState } from './PrivacySpaceManager';
import commonEventMonitor from '@ohos/screenlockcommon/src/main/ets/base/CommonEventMonitor';
import camera from '@ohos.multimedia.camera';
import { strongAuthManager } from '@ohos/screenlockcommon/src/main/ets/manager/StrongAuthManager';
import PerformanceMonitorUtil, { Constants as PerformanceMonitorConstans}
  from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { ScreenLockToDesktopConsts } from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockToDesktopConsts';
import { immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SpecificScreenLockStateManager }
  from '../common/SpecificScreenLockStateManager';
import accountsModelApi from '@ohos/screenlockcommon/src/main/ets/api/AccountsModelApi';
import ScreenlockEventMonitor from './ScreenlockEventMonitor';
import { AcquireResultCode } from '@ohos/screenlockcommon';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { LockUnlockCallback } from '@ohos/screenlockcommon/src/main/ets/services/ScreenLockUnLockService';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import { PasswordManager } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import ScreenLockMediator from './ScreenLockMediator';

const TAG = 'ScreenLock-ScreenLockService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const URI_DIGITALPASSWORD = 'pages/digitalPassword';
const URI_MIXEDPASSWORD = 'pages/mixedPassword';
const URI_CUSTOMPASSWORD = 'pages/customPassword';

// Event type name
const EVENT_END_SCREEN_ON: string = 'endScreenOn';
const EVENT_BEGIN_SCREENOFF: string = 'beginScreenOff';
const EVENT_END_SCREENOFF: string = 'endScreenOff';
const EVENT_UNLOCK_SCREEN: string = 'unlockScreen';
const EVENT_BEGIN_SLEEP: string = 'beginSleep';
const EVENT_END_SLEEP: string = 'endSleep';
const EVENT_CHANGE_USER: string = 'changeUser';
const EVENT_SCREENLOCK_ENABLE: string = 'screenlockEnabled';

const LOCK_SCREEN_RESULT: string = 'lockScreenResult';
const UNLOCK_SCREEN_RESULT: string = 'unlockScreenResult';
const SCREENLOCK_DRAW_DONE: string = 'screenDrawDone';

const CHALLENGE_INT = 0;
const DELAY_TIME = 250;
const BLUR_RADIUS = 1;
const SLIDING_DISTANCE = 200;

const MAIN_USER = 100;
const ALPHABETIC_KEYBOARD = '2';
const FACE_VERIFY_INVOKE_DELAY_WHEN_SERVICE_INIT = 1000;
const RESET_FOLDER_STATUS_CHANGE_STATE_DELAY = 2000;
const SET_FACE_TIME = 100;
const FINGERPRINT_TIP_SINGLE_RESULT: number = 10001;

const INVALID_TIMEOUT_ID = -1;

const USER_HAS_NOCREDENTIAL = '0';

const FACE_TO_DESKTOP_CLOCK_ANIMATION_DELAY = 10;
const NO_TOUCH_OR_SCREEN_MIDDLE: number = 0;
const UNKNOWN_AUTH_TYPE: number = -1;

// 常规用户id
const NORMAL_USER_ID: number = 100;

export { AuthType, AuthSubType };

export enum UnlockResult {
  Success = 0,
  Fail = 1,
  Cancel = 2
}

export enum LockResult {
  Success = 0,
  Fail = 1,
  Cancel = 2
}

let mRouterPath: string = '';

let isLocked = true;

let isEditor = false;

// copy from ./ScreenLockMediator.ets::ScreenLockStatus
enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

export enum ScreenLockFaceUnlockAnimationType {
  SECONDARY_INTERFACE_DISAPPEAR_ANIMATION,
  FIRST_INTERFACE_DISAPPEAR_ANIMATION
}

export class UnlockFlowTimeEntry {
  public startUnlock: number = 0;
  public startAuth: number = 0;
  public endAuth: number = 0;
  public endUnlock: number = 0;
  public authTime: number = 0;
  public unlockTime: number = 0;
}

export enum ScreenUnlockReportType {
  FLING = 'FLING',
  FACIAL = 'FACIAL',
  FINGERPRINT = 'FINGERPRINT',
  PASSWORD = 'PASSWORD'
}

export class LockInfo {
  public lockStatus?: number = ScreenLockEvent.LOCK_STATUS_UNLOCK;
  public isLock?: boolean = false;
}

export class PropertyInfo {
  public authSubType?: AuthSubType = AuthSubType.PIN_NONE;
  public authType?: osAccount.AuthType = osAccount.AuthType.PIN;
  public sensorInfo?: SensorInfo;
}

export class SensorInfoDataJson {
  public sensorType: SensorType = SensorType.NON_SENSOR;
  public udSensorCenterXInThousandth: number = 0;
  public udSensorCenterYInThousandth: number = 0;
  public udSensorRadiusInPx: number = 0;
}

type SensorInfo = SensorInfoDataJson;

const SCREENUNLOCK_EVENT: string = 'SCREENUNLOCK_EVENT';

export const SCREENLOCK_AUTH_TYPE: string = 'ScreenlockAuthType';

/**
 * ScreenLockService Tool
 *
 * @since 2022-06-06
 */
export class ScreenLockService {
  public isOtherElementsFullInScreenLock: boolean = false;
  public isUnlockScreen:boolean = false;
  public isPinSubType: boolean = false;
  public deviceStatus: string = '';
  public screenLockModel: ScreenLockModel = new ScreenLockModel();
  public isPhysicalKeyboardExist: boolean = false;
  public typeFilter: string = '';
  public numberFilter: string = '^[0-9]*$';
  public isScreenOff: boolean = false;
  public psdErrorTimes: number = 0;
  public isPageToPsd: boolean = false;
  public isScreenOffFromBouncer: boolean = false;
  public isPowerIntercept: boolean = false;
  public isAlreadyRegister: boolean = false;
  public isScreenOn: boolean = true;
  public isScreenOffEnd: boolean = false;
  public startUnlock: number = 0;
  public startAuth: number = 0;
  public endAuth: number = 0;
  public endUnlock: number = 0;
  public unlockTime: number = 0;
  public isGotoMetaBall: boolean = false;
  public mCallback: Function | undefined = undefined;
  public mCancelUnlockCallback?: Callback<void> = undefined;
  public faceAuthSuccessByDirectUnlock = false;
  public onUserActivate: Callback<void> = () => {
  };
  public onFaceAuthSuccessAnimation: Callback<ScreenLockFaceUnlockAnimationType> = () => {
  };
  public onFingerprintAcquireInfo: Function = (module: number, acquire: number,
    fingerprintExtraInfo: IAMAuthExtraInfo) => {};
  public onUserSwitchedCallback: Function = (isNeedLockScreen: boolean) => {
  };
  private onUserSwitchingCallback: Function = (): void => {};
  public isNeedUpdate: boolean = false;
  public mEventSubscriber: Record<string, Object> | undefined;
  public startSlidingUnlock: number = 0;
  public endSlidingUnlock: number = 0;
  public slidingUnlockTime: number = 0;
  public keyboardIds: number[] = [];
  public unlockTypeStr: string = '';
  public unlockType: string = '';
  public screenState: string = '';
  public facialMethod: number = -1;
  public pwdUi: string = '';
  public resultRecieved: boolean = false;
  private isCameraMuted: boolean | undefined = undefined;
  private customizeUnlock: Callback<void> = () => {};
  private fingerprintContextId : Uint8Array | null = null;
  private faceAuthContextId : Uint8Array | null = null;
  private pwdContextIds: Uint8Array[] = [];
  private domainContextIds: Uint8Array[] = [];
  private displayWidth : number = 0;
  public displayHeight : number = 0;
  private readonly thousandths : number = 1000;
  private readonly authDelay : number = 1000;
  // Face Unlock
  private isLoadedFaceUnlockEnv: boolean = false;
  private needSlideUnlockAfterFaceRecognized: boolean = true;
  private isFaceRecognitionEnabled: boolean = true;
  private isAodSlideUnlock: boolean = false;
  private isFaceUnlockSettingCheckLimited: boolean = false;
  private unloadFaceEnvTaskId: number = INVALID_TIMEOUT_ID;
  private mIsUnlockRequested: boolean = false;
  private isOffScreenUnlocking: boolean = false;
  private sleepOnScreenLock: boolean = true;
  private appContinuationEnable: boolean = false;
  private screenLockDrawDown: boolean = true;
  private isNeedLockScreen: boolean = true;
  private currentUserIsFromAccount: boolean = false;
  /**
   * 指纹使能时，当底层返回Exception时，间隔1s重试，最多重试3次
   */
  private fingerAuthRemainCount: number = 3;
  // 双指捏合滑动
  private isPinchGestureSlide: boolean = false;
  private isThemeEditorReady: boolean = false;
  private firstLockScreen: boolean = true;
  public firstUnLockScreen: boolean = true;
  // 记录折叠屏折叠状态变化
  private isFolderStatusChange: boolean = false;
  private resetFolderStatusChangeTimeoutId: number = -1;
  private unlockFlowTimeMap: Map<ScreenUnlockReportType, UnlockFlowTimeEntry> = new Map();
  private faceUnlockType: string = FaceUnlockConstants.FACE_UNLOCK_CONFIG_SLIDE_VALUE;

  /**
   * 锁屏状态事件
   */
  private screenLockEvent: ScreenLockEvent = new ScreenLockEvent();

  private isFoldable: boolean = this.isFoldDevice();

  private foldStatus: display.FoldStatus = this.getFoldStatusService();

  private setWallPaperToShowDesktop: Function = () : void => {};

  private setWallPaperToHideDesktop: Function = () : void => {};

  private setExitKeyguardFromBouncer: Function = () : void => {};


  private foldStatusChangeCallback: Callback<display.FoldStatus> = (newFoldStatus: display.FoldStatus): void => {
    this.foldStatus = newFoldStatus;
    let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE); // 刷新折叠展开状态
    slStaticState?.setSlState(SlStaticStateType.FOLD_EXPAND_STATE, this.foldStatus);
    const isFoldFullDisplay: boolean = this.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
    if (AppStorage.get<boolean>('isFoldFullDisplay') !== isFoldFullDisplay) {
      log.showInfo(`isFoldFullDisplay = ${isFoldFullDisplay}`);
      AppStorage.setOrCreate('isFoldFullDisplay', isFoldFullDisplay);
      this.recordFolderStatusChange();
    }
    this.faceUnlockHandlerOnFoldStatusChange(newFoldStatus);
  };

  /**
   * 获取折叠状态
   *
   * @returns FoldStatus
   */
  private getFoldStatusService(): display.FoldStatus {
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_FOLDED;
    try {
      foldStatus = display.getFoldStatus();
    } catch (error) {
      log.showError(`getFoldStatus code: ${error?.code}, msg: ${error?.message}`);
    }
    return foldStatus;
  }

  /**
   * 获取当前设备是否为折叠屏
   *
   * @returns
   */
  private isFoldDevice(): boolean {
    let foldDevice: boolean = false;
    try {
      foldDevice = display.isFoldable();
    } catch (error) {
      log.showError(`isFoldDevice code: ${error?.code}, msg: ${error?.message}`);
    }
    return foldDevice;
  }

  private onEnterHostCallback: Function = () => {
    if (strongAuthManager.isNeedStrongAuth() &&
    strongAuthManager.hasFingerprint()) {
      this.authUserByFingerprint(() => {});
    }
  }

  private onEnterBouncerCallback: Function = () => {
    if (strongAuthManager.isNeedStrongAuth()) {
      this.cancelAuthOfFingerprint();
    }
  }

  private isScreenLockDisabled: Function = () => {
    return ScreenlockEventMonitor.getDisabledScreenlockFlag();
  }

  private handleAccountSwitch: accountSwitchCallback = {
    onSwitched: (data: OsAccountSwitchEventData): void => {
      const mCurrentId = accountModel.getCurrentUserId();
      const foregroundId = data.toAccountId;
      log.showInfo(`handleAccountSwitch`);
      if (this.commonEventCallback) {
        this.commonEventCallback(mCurrentId === foregroundId);
        ScreenlockEventMonitor.monitorEvent();
        log.showInfo(`handleAccountSwitch getLock ${screenLockService.getLock()}`);
        if (screenLockService.getLock()) {
          screenLockService.notifyLockScreenResult(LockResult.Success);
        } else {
          screenLockService.notifyUnlockScreenResult(UnlockResult.Success);
        }
      } else {
        log.showError('handleAccountSwitch commonEventCallback undefined');
      }
    }
  };
  private commonEventCallback: Function | undefined
  private registerObserverCallback: Function = (callback: Function): void => {
    this.commonEventCallback = callback;
    accountModel.registerAccountSwitchCallback('commonEvent', this.handleAccountSwitch);
  }
  private unRegisterObserverCallback: Function = (): void => {
    accountModel.unRegisterAccountSwitchCallback('commonEvent');
    this.commonEventCallback = undefined;
  }

  private getLockCallback: Function = (): boolean => {
    return this.getLock();
  }

  private getCurrentUserIdCallback: Function = (): number => {
    return accountModel.getCurrentUserId();
  }

  private updateCurrentUserIdCallback: Function = async (): Promise<number> => {
    let user: number = NORMAL_USER_ID;
    await accountModel.updateCurrentUserId(() => {
      user = accountModel.getCurrentUserId();
    });
    if (!CommonUtils.isNumber(user)) {
      log.showWarn('userId is invaild, use NORMAL_USER_ID instead');
      user = NORMAL_USER_ID;
    }
    return user;
  }

  private requestUnlockCallback: Function = (callback?: LockUnlockCallback, withDelay: boolean = false,
    cancelCallback?: Callback<void>): void => {
    if (cancelCallback) {
      screenLockService.requestUnlockWithDelayForControl(callback?.success, 0, cancelCallback);
    } else if (withDelay) {
      screenLockService.requestUnlockWithDelay(callback?.success, 0);
    } else {
      screenLockService.requestUnlock(callback?.success);
    }
  }

  private unlockWhenNoPswCallback: Function = (): void => {
    this.unlockWhenNoPsw();
  }

  private notifyUnlockTransitionCallback: Function = (): void => {
    this.notifyUnlockTransition();
  }

  private isScreenLockShowCallback: Function = (): boolean => {
    return screenLockStateManager.currentState !== ScreenLockState.EXIT_KEYGUARD;
  }

  private isDeviceLockedCallback: Function = (): boolean => {
    return !this.canUnlockWithoutPassword();
  }

  public getCameraMuted(): boolean | undefined {
    if (ObjUtil.isInvalid(this.isCameraMuted)) {
      try {
        this.isCameraMuted = camera?.getCameraManager(getContext()).isCameraMuted();
      } catch (e) {
        log.showError('CameraManager in Error');
      }
    }
    return this.isCameraMuted;
  }

  public setCameraMuted(isMuted: boolean): void {
    this.isCameraMuted = isMuted;
  }

  public setCustomizeUnlock(callback: Callback<void>): void {
    this.customizeUnlock = callback;
  }

  public setThemeEditorReady(isThemeEditorReady: boolean): void {
    log.showInfo(`isThemeEditorReady = ${isThemeEditorReady}`);
    this.isThemeEditorReady = isThemeEditorReady;
  }

  public setFolderStatusChange(isFolderStatusChange: boolean): void {
    this.isFolderStatusChange = isFolderStatusChange;
  }

  public getThemeEditorReady(): boolean {
    return this.isThemeEditorReady;
  }

  public setPinchGestureSlide(isPinchGestureSlide: boolean): void {
    log.showInfo(`isPinchGestureSlide = ${isPinchGestureSlide}`);
    this.isPinchGestureSlide = isPinchGestureSlide;
  }

  public getPinchGestureSlide(): boolean {
    return this.isPinchGestureSlide;
  }

  public getIsOffScreenUnlocking(): boolean {
    return this.isOffScreenUnlocking;
  }

  public setIsOffScreenUnlocking(isOffScreenUnlocking: boolean): void {
    this.isOffScreenUnlocking = isOffScreenUnlocking;
  }

  public getSleepOnScreenLock(): boolean {
    return this.sleepOnScreenLock;
  }

  public getScreenLockDrawDown(): boolean {
    return this.screenLockDrawDown;
  }

  public setSleepOnScreenLock(isSleepOnScreenLock: boolean): void {
    if (!isLocked && isSleepOnScreenLock && !this.sleepOnScreenLock) {
      log.showWarn('setSleepOnScreenLock error.');
      return;
    }
    this.sleepOnScreenLock = isSleepOnScreenLock;
  }

  public setScreenLockDrawDown(isScreenLockDrawDown: boolean): void {
    this.screenLockDrawDown = isScreenLockDrawDown;
  }

  public setWallPaperToShowDesktopCallback(callback: Function): void {
    this.setWallPaperToShowDesktop = callback;
  }

  public setWallPaperToHideDesktopCallback(callback: Function): void {
    this.setWallPaperToHideDesktop = callback;
  }

  public setExitKeyguardFromBouncerCallback(callback: Function): void {
    this.setExitKeyguardFromBouncer = callback;
  }

  public isFoldableDevice(): boolean {
    return this.isFoldable;
  }

  public getFoldStatus(): display.FoldStatus {
    return this.foldStatus;
  }

  public getFoldDisplayMode(): display.FoldDisplayMode {
    return this.foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED ?
      display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN : display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
  }

  public notifyExitKeyguardFromBouncer(): void {
    this.setExitKeyguardFromBouncer();
  }

  /**
   * init
   */
  init(): void {
    log.showInfo('init');
    Trace.start(Trace.CORE_METHOD_LOCK_SERVICE_INIT);
    ScreenLockApi.initCallback(this.getLockCallback, this.requestUnlockCallback, this.unlockWhenNoPswCallback,
      this.notifyUnlockTransitionCallback, this.isScreenLockShowCallback, this.isDeviceLockedCallback);
    screenLockStateManager.initInnerStateCallback(this.onEnterHostCallback, this.onEnterBouncerCallback,
      this.isScreenLockDisabled);
    accountsModelApi.initAccountsModelCallback(this.getCurrentUserIdCallback, this.updateCurrentUserIdCallback);
    DisplayMgr.getCurrentDisplay().then((dis) => {
      this.displayWidth = dis.width;
      this.displayHeight = dis.height;
    });
    // 注册锁屏状态事件生产者
    EvtBus.produceOn(ScreenLockEvent, this.onProduceScreenLockEvent.bind(this));
    accountModel.modelInit();
    this.monitorEvents();
    this.initCredentialUpdatedSubscriber();
    this.watchInputDevice();
    this.getFingerprintSensorInfo();
    this.checkFaceKeyGuardWhetherEnable(true, FaceUnlockReason.THREAD_START,
      FACE_VERIFY_INVOKE_DELAY_WHEN_SERVICE_INIT);
    this.initUnlockFlowTimeMap();
    Trace.end(Trace.CORE_METHOD_LOCK_SERVICE_INIT);
  }

  public updateAllUsers(): void {
    accountModel.updateAllUsers((type: osAccount.AuthType) => {
      this.checkPinAuthProperty(type, () => {
        let isActive = power.isActive() && !AppStorage.get('isBeginSleepStart');
        if (accountModel.getCurrentUserId() === privacySpaceManager.privateUser && !this.lockByAuthState() &&
          isActive) {
          // 密码冷切，亮屏则直接解锁进隐私空间
          this.unlocking();
        }
      });
    });
  }

  public monitorDisplayModeChange(): void {
    log.showInfo(`The device is flodable: ${this.isFoldable}`);
    // LEM产品的isFoldable状态为false,但是实际为折叠屏.故增加!DeviceHelper.isSmallFoldProduct()的判断.
    if (!this.isFoldable && !DeviceHelper.isSmallFoldProduct()) {
      return;
    }
    AppStorage.setOrCreate('isFoldFullDisplay', this.getFoldDisplayMode() ===
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL);
    // 折叠设备状态初始化
    let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    slStaticState?.setSlState(SlStaticStateType.FOLDABLE_STATE, this.isFoldable);
    slStaticState?.setSlState(SlStaticStateType.FOLD_EXPAND_STATE, this.foldStatus);
    try {
      display.on('foldStatusChange', this.foldStatusChangeCallback);
    } catch (error) {
      log.error('monitorDisplayModeChange on error', error);
    }
  }

  protected recordFolderStatusChange(): void {
    this.setFolderStatusChange(true);

    if (this.resetFolderStatusChangeTimeoutId !== -1) {
      clearTimeout(this.resetFolderStatusChangeTimeoutId);
    }

    this.resetFolderStatusChangeTimeoutId = setTimeout(() => {
      this.setFolderStatusChange(false);
    }, RESET_FOLDER_STATUS_CHANGE_STATE_DELAY);
  }


  protected faceUnlockHandlerOnFoldStatusChange(newFoldStatus: display.FoldStatus): void {
    if (!AppStorage.get('isScreenOn')) {
      log.showInfo('the screen is off, no need to invoke faceUnlock verify.');
      return;
    }

    if (newFoldStatus === display.FoldStatus.FOLD_STATUS_FOLDED ||
      newFoldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      setTimeout(() => {
        this.invokeFaceVerify(FaceUnlockReason.FOLD_CHANGED);
      }, Constants.MILLISECOND_TO_HALF_SECOND);
    }
  }

  setUserActivateCallback(callback: Callback<void>): void {
    this.onUserActivate = callback;
  }

  setOnFaceAuthSuccessAnimation(callback: Callback<ScreenLockFaceUnlockAnimationType>): void {
    this.onFaceAuthSuccessAnimation = callback;
  }

  async watchInputDevice(): Promise<void> {
    log.showInfo('The device watchInputDevice');
    this.isPhysicalKeyboardExist = false;
    AppStorage.setOrCreate('isPhysicalKeyboardExist', this.isPhysicalKeyboardExist);
    let ids: number[] = [];
    try {
      ids = await inputDevice.getDeviceIds();
    } catch (err) {
      log.showError('DeviceIds is null');
    }
    log.showInfo('The device watchInputDevice && ids');
    for (let id of ids) {
      this.checkKeyboardDevice(true, id);
    }
  }

  public checkKeyboardDevice(isAddDevice: boolean, deviceId: number): void {
    if (!isAddDevice) {
      this.keyboardIds = this.keyboardIds.filter(id => id !== deviceId);
      this.changePhysicalKeyboardExist();
      return;
    }
    try {
      inputDevice.getKeyboardType(deviceId, (err, keyboardType) => {
        log.showDebug('The device, keyboardType');
        if (JSON.stringify(keyboardType) === ALPHABETIC_KEYBOARD) {
          this.keyboardIds.push(deviceId);
        }
        this.changePhysicalKeyboardExist();
      });
    } catch (error) {
      log.error('checkKeyboardDevice getKeyboardType error');
    }
  }

  protected changePhysicalKeyboardExist(): void {
    let isContainKeyboard: boolean = this.keyboardIds.length !== 0;
    if (isContainKeyboard !== this.isPhysicalKeyboardExist) {
      this.isPhysicalKeyboardExist = isContainKeyboard;
      log.showInfo('changePhysicalKeyboardExist isContainKeyboard');
      AppStorage.setOrCreate('isPhysicalKeyboardExist', isContainKeyboard);
    }
  }

  public getScreenIsActive(): void {
    const screenIsActive: boolean = power.isActive();
    if (this.isScreenOn !== screenIsActive) {
      ScreenLockMediator.setScreenOn(screenIsActive);
      ScreenLockMediator.setScreenOnEnd(screenIsActive);
    }
  }

  /**
   * register event
   */
  monitorEvents(): void {
    accountModel.registerUserSwitchListener('switching', (switchEventData: OsAccountSwitchEventData) => {
      log.showInfo('UserSwitch switching');
      // notify wms to handle user switching event first (to freeze multimodal etc.)
      SCBSceneSessionManager.getInstance()
        .handleUserSwitchEvent(UserSwitchEventType.SWITCHING, switchEventData.toAccountId);
      let currentUser: IUserData | undefined = AppStorage.get<IUserData>(Constants.CURRENT_USER_KEY);
      HiDfxEventUtil.reportUserSwitchEvent(currentUser?.type);
      this.cancelAuthOfFaceUnlock();
      if (accountModel.getCurrentUserId() !== switchEventData.toAccountId) {
        this.currentUserIsFromAccount = true;
        this.handleFromAccountWhenSwitching();
        return;
      }
      slClockOneShotToDesktopService.updateUserSwitching(true);

      if (switchEventData.toAccountId === accountModel.getCurrentUserId()) {
        AppStorage.setOrCreate('accountSwitch', false);
      }
      if (!this.lockByAuthState()) {
        this.onUserSwitchingCallback();
      }
      this.handleUserSwitching();
      this.getScreenIsActive();
      this.resetFaceRecognitionState();
      AppStorage.setOrCreate('userSwitch', true);
    });

    accountModel.registerUserSwitchListener('switched', this.handleUserSwitched);

    accountModel.accountEventListener(() => {});

    commonEventMonitor.initCallback(this.registerObserverCallback, this.unRegisterObserverCallback);
    commonEventMonitor.init();
    log.showInfo('registered events end');
  }

  protected handleFromAccountWhenSwitching(): void {
    if (AppStorage.get('isPwdVisible')) {
      AppStorage.setOrCreate('isPwdVisible', false);
      this.screenLockModel.setScreenLockPrivacy(false);
    }
    let isAcquireWhenBeginSleep = AppStorage.get<boolean>('isBeginSleepStart') as boolean;
    log.showInfo(`UserSwitching, fromAccount beginSleepState is ${isAcquireWhenBeginSleep}`);
    if (isAcquireWhenBeginSleep) {
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.MSG_NOTIFY_CANCEL_OFF_SCREEN);
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
    }
    if (!power.isActive()) {
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
    }
    // 对前台用户的指纹进行cancel
    let fingerprintVerifyState: number = AppStorage.get<number>('fingerprintVerifyState') as number;
    log.showInfo(`fingerprintVerifyState is ${fingerprintVerifyState}`);
    if (fingerprintVerifyState !== FingerprintVerifyState.VERIFYING) {
      this.cancelAuthOfFingerprint();
      AppStorage.setOrCreate('fingerprintVerifyState', FingerprintVerifyState.NOT_READY);
    }
    if (AppStorage.get('lockStatus') === ScreenLockStatus.UNLOCK) {
      this.setScreenLockEvent({
        isLock: true
      });
      if (this.hasAuthType()) {
        this.deviceLockedState(accountModel.getCurrentUserId());
      }
      this.asyncNotifyLockScreenSuccess();
      this.publishByUser('common.event.LOCK_SCREEN', accountModel.getCurrentUserId());
    }
  }

  protected handleUserSwitching(): void {
    this.isNeedLockScreen = this.lockByAuthState();
    log.showInfo(`handleUserSwitching isNeedLockScreen: ${this.isNeedLockScreen} isLocked ${isLocked}`);
    if (this.isNeedLockScreen) {
      this.lockScreen(() => {
        AppStorage.setOrCreate('lockStatus', ScreenLockStatus.LOCKING);
        screenLockStateManager.onEnterHost(true);
      }, !isLocked);
    } else {
      this.refreshUnlockStartTime(osAccount.AuthType.FINGERPRINT);
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.FINGERPRINT, UnlockStage.START_UNLOCK);
    }
  }

  private handleUserSwitched = (switchEventData: OsAccountSwitchEventData): void => {
    log.showInfo(`UserSwitch end. switch user:${switchEventData.fromAccountId} curUser:${switchEventData.toAccountId}`);
    if (switchEventData.toAccountId !== accountModel.getCurrentUserId()) {
      this.currentUserIsFromAccount = false;
      log.showInfo(`handleUserSwitched isLocked ${isLocked}`);
      if (DeviceHelper.isPC()) {
        log.showInfo(`on switched lock screen`);
        this.lockScreen(() => {
          AppStorage.setOrCreate('isLock', true);
          log.showInfo(`on switched lock screen success`);
        }, !isLocked);
      }
      return;
    }
    this.onUserSwitchedCallback(this.isNeedLockScreen);
    accountModel.updateAllUsers((type: osAccount.AuthType) => {
      this.checkPinAuthProperty(type, () => {
        if (this.isNeedLockScreen) {
          this.setLockStatus(ScreenLockStatus.LOCKING, ScreenLockEvent.LOCK_STATUS_SECURE);
        }
        this.isNeedLockScreen = true;
      });
      this.onUserActivate();
    });
    AppStorage.setOrCreate('userSwitch', false);
    slClockOneShotToDesktopService.updateUserSwitching(false);
    this.checkFaceKeyGuardWhetherEnable(true, FaceUnlockReason.USER_SWITCHED);

    // notify wms to handle user switched event
    SCBSceneSessionManager.getInstance()
      .handleUserSwitchEvent(UserSwitchEventType.SWITCHED, switchEventData.toAccountId);
  };

  /**
   * 设置解锁类型
   *
   * @param authType 解锁类型
   */
  setScreenLockAuthState(authType: osAccount.AuthType | null = null, toAccountId: number,
    isCurrentUserId: boolean = false): void {
    let authStateType: number = AuthState.UNAUTH;
    if (authType === AuthType.PIN) {
      authStateType = isCurrentUserId ? AuthState.AUTHED_BY_CREDENTIAL : AuthState.PRE_AUTHED_BY_CREDENTIAL;
    } else if (authType === AuthType.FINGERPRINT) {
      authStateType = isCurrentUserId ? AuthState.AUTHED_BY_FINGERPRINT : AuthState.PRE_AUTHED_BY_FINGERPRINT;
    } else if (authType === AuthType.FACE) {
      authStateType = isCurrentUserId ? AuthState.AUTHED_BY_FACE : AuthState.PRE_AUTHED_BY_FACE;
    }
    log.showInfo(`setScreenLockAuthState, authType: ${authType},authStateType: ${authStateType}`);
    let uint8Array: Uint8Array = new Uint8Array([toAccountId]);
    try {
      ScreenLockMar.setScreenLockAuthState(authStateType, toAccountId, uint8Array);
    } catch (err) {
      log.showError(`setScreenLockAuthState failed, err: ${err.code}`);
    }
  }

  /**
   * 锁头状态修改和文件加密
   *
   * @param userId 用户ID
   */
  deviceLockedState(userId: number): void {
    let authState: number = AuthState.UNAUTH;
    try {
      authState = ScreenLockMar.getScreenLockAuthState(userId);
    } catch (err) {
      log.showError(`deviceLockedState getScreenLockAuthState failed, err: ${err.code}`);
      this.setScreenLockAuthState(null, userId);
      accountModel.fileEncryption();
      return;
    }

    log.showInfo(`deviceLockedState getScreenLockAuthState: ${authState}`);
    if (this.firstUnLockScreen && authState === AuthState.UNAUTH) {
      // kill foundation后加密
      accountModel.fileEncryption();
    }
    if (authState !== AuthState.UNAUTH) {
      this.setScreenLockAuthState(null, userId);
      accountModel.fileEncryption();
    }
  }

  /**
   * 重置面部解锁状态
   *
   * @param userId 用户ID
   */
  resetFaceAuthState(userId: number): void {
    let isFaceUnlockNeedSlide: boolean | undefined = AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_NEED_SLIDE);
    if (!isFaceUnlockNeedSlide) {
      log.showInfo(`isFaceUnlockNeedSlide is ${isFaceUnlockNeedSlide}`);
      return;
    }

    let authState: number = AuthState.UNAUTH;
    if (ObjUtil.isInvalid(userId)) {
      userId = accountModel.getCurrentUserId();
    }
    try {
      authState = ScreenLockMar.getScreenLockAuthState(userId);
    } catch (err) {
      log.showError(`getScreenLockAuthState failed, err: ${err.code}`);
    }
    if (authState === AuthState.AUTHED_BY_FACE) {
      log.showInfo('resetFaceAuthState');
      this.setScreenLockAuthState(null, userId);
    }
  }

  /**
   * 根据解锁类型判断是否需要锁屏
   *
   * @returns 密码解锁或非首次指纹解锁返回false
   */
  public lockByAuthState(toAccountId?: number): boolean {
    let authState: number = AuthState.UNAUTH;
    if (ObjUtil.isInvalid(toAccountId)) {
      toAccountId = accountModel.getCurrentUserId();
    }
    try {
      authState = ScreenLockMar.getScreenLockAuthState(toAccountId);
    } catch (err) {
      log.showError(`getScreenLockAuthState failed, err: ${err.code}`);
    }
    log.showInfo(`lockByAuthState, authState: ${authState}`);
    if (authState === AuthState.UNAUTH) {
      return true;
    }
    if (authState === AuthState.PRE_AUTHED_BY_CREDENTIAL) {
      return false;
    }
    if (authState === AuthState.PRE_AUTHED_BY_FINGERPRINT || authState === AuthState.PRE_AUTHED_BY_FACE) {
      return this.firstUnLockScreen || strongAuthManager.isNeedStrongAuth();
    }
    return true;
  }

  protected doIfNoNeedScreenLock(): boolean {
    let isSimLocked: boolean | undefined = AppStorage.get<boolean>('screenSimLocked');
    if (this.isOobeEnableNoPwd() && !isSimLocked) {
      log.showInfo('oobe is enable not lockScreen');
      return true;
    }

    // the demo sample does not need to be locked.
    try {
      if (ScreenLockMar.isScreenLockDisabled(accountModel.getCurrentUserId())) {
        log.showInfo('noneedScreenlock.');
        return true;
      }
    } catch (err) {
      log.showInfo('isScreenLockDisabled failed');
    }
    return false;
  }

  public hasAuthType(): boolean {
    return GlobalStatusCache.getInstance().getStatus(Constants.SETTING_HAS_PASSWORD_KEY, false) as boolean;
  }

  public isAuthTypeInit(): boolean {
    return GlobalStatusCache.getInstance().hasStatus(Constants.SETTING_HAS_PASSWORD_KEY);
  }

  // 判断是否oobe场景且没有密码
  public isOobeEnableNoPwd(): boolean {
    return sSCBOobeManager.isEnable() && !this.hasAuthType();
  }

  /**
   * 通知WMS锁屏状态
   */
  notifyEarlyUnlockTransition() : void {
    log.showWarn('notifyEarlyUnlockTransition');
    SCBSceneSessionManager.getInstance().notifyWMSIsLockReceived(false);
  };

  /**
   * lock Screen
   *
   * @param callback callback
   */
  lockScreen(callback: Callback<void>, isPlayWallpaperAnimation: boolean = false): void {
    Trace.start(Trace.CORE_METHOD_LOCK_HIDE);
    if (this.doIfNoNeedScreenLock()) {
      this.sleepOnScreenLock = false;
      this.screenLockDrawDown = false;
      return;
    }

    log.showWarn('IntoKeyGuard start');
    // 加锁时检查指纹type，避免锁屏界面不显示指纹logo
    const sensorType: string | undefined = AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
    if (!sensorType) {
      this.getFingerprintSensorInfo();
    }
    this.notifyKeyboardPsdScreenOff();
    this.watchInputDevice();
    this.isPowerIntercept = false;
    SCBSceneSessionManager.getInstance().handleSceneWhenPreLock();
    // lock the screen
    this.screenLockModel.showScreenLockWindow(() => {
      log.showInfo('IntoKeyGuard end');
      Trace.end(Trace.CORE_METHOD_LOCK_HIDE);
      HiSysEventUtil.reportShowKeyguard();
      isLocked = true;
      callback();
      this.setScreenLockEvent({
        isLock: true
      });
      this.asyncNotifyLockScreenSuccess();
      this.setLockStatus(ScreenLockStatus.LOCKING, ScreenLockEvent.LOCK_STATUS_SECURE);
      this.publishByUser('common.event.LOCK_SCREEN', accountModel.getCurrentUserId());
      this.notifyLockTransition();
      if (this.hasAuthType()) {
        SCBSceneSessionManager.getInstance().setUserAuthPassed(false);
      }
      this.faceAuthSuccessByDirectUnlock = false;
      this.isOffScreenUnlocking = false;
      this.resetFaceRecognitionState();
      if (!strongAuthManager.hasSetPasswd()) {
        PerformanceMonitorUtil.reportScreenLockCommonEvent(PerformanceMonitorConstans.SCREEN_LOCK_INTO_SLIDE);
      }
    });
    this.mCallback = undefined;
    this.mCancelUnlockCallback = undefined;
    // startOobeForOta after first lockScreen
    if (this.firstLockScreen) {
      log.showInfo('first lockScreen startOobeForOta');
      sSCBOtaManager.startOobeForOta();
      sSCBOobeManager.startOobeAfterScreenLockReady();
      this.firstLockScreen = false;
    }
    // 检查人脸环境
    this.checkFaceKeyGuardWhetherEnable();
    // 重置壁纸引擎状态
    if (isPlayWallpaperAnimation) {
      this.resetWallpaperState();
    }
  }

  protected resetWallpaperState(): void {
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: DynamicWallPaperState.DESKTOP,
      tarState: DynamicWallPaperState.SCREENLOCK,
      isOffScreenSupportAod: false,
      onFinish: () => {
        log.showInfo('wallpaperLockAnimation finish');
      },
      isPlayingAnimation: true,
    });
  }

  isDomainAuthType(): boolean {
    let currentUser: IUserData | undefined = AppStorage.get<IUserData>(Constants.CURRENT_USER_KEY);
    let isPinAuthType: boolean | undefined = AppStorage.get<boolean>(Constants.IS_PIN_AUTH_TYPE_KEY);
    let isDomain: boolean | undefined =
      currentUser?.availableAuthTypes?.includes(osAccount.AuthType.DOMAIN) && !isPinAuthType;
    return isDomain ? isDomain : false;
  }

  onUserSwitch(userId: number): void {
    accountModel.onUserSwitch(userId);
  }

  unlockWhenNoPsw(): void {
    let status: number | undefined = AppStorage.get(Constants.LOCK_STATUS_KEY);
    if (status === ScreenLockStatus.UNLOCK && this.isScreenOn) {
      this.unlockScreen();
    }
  }

  notifyKeyboardPsdScreenOff(): void {
    this.isScreenOff = !this.isScreenOff;
    AppStorage.setOrCreate(Constants.SCREEN_OFF_KEY, this.isScreenOff);
  }

  /**
   * 返回是否人脸被禁用（双中心下拉，覆盖模式，相机禁用场景）
   *
   * @returns true: 相机可用
   */
  public isFaceRecognitionEnable(): boolean {
    return this.isFaceRecognitionEnabled;
  }

  public enableFaceRecognition(): void {
    this.isFaceRecognitionEnabled = true;
  }

  public disableFaceRecognition(): void {
    this.isFaceRecognitionEnabled = false;
  }

  protected setPinType(isSubType: boolean, passwordType: string, path: string, filter: string): void {
    log.showInfo(`AuthSubType ${passwordType}`);
    this.isPinSubType = isSubType;
    AppStorage.setOrCreate(Constants.PASSWORD_TYPE_KEY, passwordType);
    mRouterPath = path;
    AppStorage.setOrCreate(Constants.TYPE_FILTER_KEY, filter);
  }

  public setLockStatus(lockStatus: ScreenLockStatus, status: number): void {
    if (!this.hasAuthType() && this.isAuthTypeInit()) {
      lockStatus = ScreenLockStatus.UNLOCK;
      status = ScreenLockEvent.LOCK_STATUS_UNLOCK;
      log.showInfo(`setLockStatus no authType lockStatus = ${lockStatus}`);
      if (!this.firstLockScreen || sSCBOobeManager.isEnable()) {
        // 屏蔽首次上锁未获取到密码场景、OOBE无密码deviceLocked状态不正确场景
        log.showInfo('no pwd, setScreenLockAuthState PIN');
        this.setScreenLockAuthState(AuthType.PIN, accountModel.getCurrentUserId(), true);
      }
    }
    AppStorage.setOrCreate(Constants.LOCK_STATUS_KEY, lockStatus);
    // 更新为密码锁状态
    if (lockStatus === ScreenLockStatus.LOCKING) {
      this.deviceLockedState(accountModel.getCurrentUserId());
    }
    this.setScreenLockEvent({
      lockStatus: status
    });
  }

  /**
   * check Pin Auth
   *
   * @param callback callback
   */
  protected async checkPinAuthProperty(authType: osAccount.AuthType, callback?: Callback<void>): Promise<void> {
    accountModel.getAuthProperty(AuthType.PIN, (properties: PropertyInfo) => {
      log.showInfo('checkPinAuthProperty：AUTH_SUB_TYPE');
      this.setSettingHasPassword(properties);
      switch (properties.authSubType) {
        case AuthSubType.PIN_SIX:
          this.setPinType(true, Constants.PIN_TYPE_SIX, URI_DIGITALPASSWORD, this.numberFilter);
          this.unlockTypeStr = Constants.PIN_TYPE_SIX;
          break;
        case AuthSubType.PIN_MIXED:
          this.setPinType(false, Constants.PIN_TYPE_MIX, URI_MIXEDPASSWORD, '');
          this.unlockTypeStr = Constants.PIN_TYPE_MIX;
          break;
        case AuthSubType.PIN_NUMBER:
          this.setPinType(true, Constants.PIN_TYPE_NUMBER, URI_CUSTOMPASSWORD, this.numberFilter);
          this.unlockTypeStr = Constants.PIN_TYPE_NUMBER;
          break;
        case AuthSubType.PIN_FOUR:
          this.setPinType(true, Constants.PIN_TYPE_FOUR, URI_DIGITALPASSWORD, this.numberFilter);
          this.unlockTypeStr = Constants.PIN_TYPE_FOUR;
          break;
        case AuthSubType.PIN_PATTERN:
          this.setPinType(true, Constants.PIN_TYPE_PATTERN, URI_CUSTOMPASSWORD, this.numberFilter);
          this.unlockTypeStr = Constants.PIN_TYPE_PATTERN;
          break;
        case AuthSubType.PIN_NONE:
          if (authType === AuthType.DOMAIN) {
            this.setDomainAuth();
          } else {
            AppStorage.setOrCreate(Constants.IS_PIN_AUTH_TYPE_KEY, true);
            SCBSceneSessionManager.getInstance().setUserAuthPassed(true);
            this.setPinType(false, Constants.PIN_TYPE_NONE, '', '');
          }
          break;
        default:
          if (authType === AuthType.DOMAIN) {
            this.setDomainAuth();
          } else {
            AppStorage.setOrCreate(Constants.IS_PIN_AUTH_TYPE_KEY, true);
            this.setPinType(true, Constants.PIN_TYPE_SIX, URI_DIGITALPASSWORD, this.numberFilter);
            this.unlockTypeStr = Constants.PIN_TYPE_SIX;
          }
          break;
      }
      if (callback !== undefined) {
        callback();
      }
    });
  }

  protected setDomainAuth(): void {
    this.setPinType(false, Constants.PIN_TYPE_NONE, URI_MIXEDPASSWORD, '');
    AppStorage.setOrCreate(Constants.IS_PIN_AUTH_TYPE_KEY, false);
  }

  public async checkHasPasswordProperty(): Promise<void> {
    return new Promise((resolve) => {
      accountModel.updateAllUsers((type: osAccount.AuthType) => {
        this.checkPinAuthProperty(type, () => {
          log.showInfo('checkPinAuth Finish');
          resolve();
        });
      });
    });
  }

  protected setSettingHasPassword(properties: PropertyInfo): void {
    const hasPassword: number[] = [AuthSubType.PIN_SIX, AuthSubType.PIN_MIXED, AuthSubType.PIN_NUMBER,
      AuthSubType.PIN_FOUR, AuthSubType.PIN_PATTERN];
    GlobalStatusCache.getInstance().setStatus(Constants.SETTING_HAS_PASSWORD_KEY,
      hasPassword.includes(properties.authSubType ?? AuthSubType.PIN_NONE) || this.isDomainAuthType());
  }

  /**
   * is unlock without password
   *
   * @returns true: no pwd
   */
  public isUnlockWithoutPwd(): boolean {
    return AppStorage.get('lockStatus') === ScreenLockStatus.UNLOCK &&
      !AppStorage.get<IUserData>('currentUserItem')?.availableAuthTypes?.includes(osAccount.AuthType.DOMAIN);
  }

  public revertToHost(preState: ScreenLockState): void {
    this.setLock(true);
    this.publishByUser('common.event.LOCK_SCREEN', accountModel.getCurrentUserId());
    this.notifyLockTransition();
    this.setWallPaperToHideDesktop();
  }

  protected asyncNotifyLockScreenSuccess(): void {
    let status: number | undefined = AppStorage.get(Constants.LOCK_STATUS_KEY);
    if (status === ScreenLockStatus.LOCKING) {
      log.showInfo('no need notifyLockScreenResult');
      return;
    }
    let currentUser: number = accountModel.getCurrentUserId();
    if (this.lockByAuthState(currentUser)) {
      this.notifyLockScreenResult(LockResult.Success);
    }
  }

  private isEditor(preState: ScreenLockState): boolean {
    return [
      ScreenLockState.THEME_EDITOR,
      ScreenLockState.THEME_EDITOR_FULL,
      ScreenLockState.THEME_EDITOR_FULL_CLOCK,
      ScreenLockState.THEME_EDITOR_FULL_FORM,
      ScreenLockState.THEME_EDITOR_FORM_DETAIL
    ].includes(preState);
  }

  public showKeyGuardWithoutLockStatusChange(): void {
    Trace.start(Trace.CORE_METHOD_LOCK_HIDE);
    log.showInfo('IntoKeyGuard start');
    this.screenLockModel.showScreenLockWindow(() => {
      Trace.end(Trace.CORE_METHOD_LOCK_HIDE);
      HiSysEventUtil.reportShowKeyguard();
      this.setLock(true);
      this.notifyLockScreenResult(LockResult.Success);
      this.publishByUser('common.event.LOCK_SCREEN', accountModel.getCurrentUserId());
      this.setWallPaperToHideDesktop();
    });
  }

  public showThemeEditorOnPinchGesture(): void {
    log.showInfo('isPinchGesture, start to show themeEditor');
    ViewManagerPolicy.showView('SCBThemeEditor');
  }

  public hideThemeEditor(): void {
    log.showInfo('hide themeEditor');
    ViewManagerPolicy.hideView('SCBThemeEditor');
  }

  /**
   * unlock Screen
   */
  unlockScreen(isHideView: boolean = true): void {
    let isSimLocked: boolean | undefined= AppStorage.get<boolean>('screenSimLocked');
    log.showInfo(`isSimLocked = ${isSimLocked}`);
    if (this.isOobeEnableNoPwd() || isSimLocked) {
      log.showInfo('oobe is enable unlock the screen');
      this.unlocking(isHideView);
      return;
    }
    let status: number | undefined = AppStorage.get(Constants.LOCK_STATUS_KEY);
    log.showInfo(`unlockScreen, unlocking lockStatus  this.isPageToPsd:${this.isPageToPsd}`);
    let currentUser: IUserData | undefined = AppStorage.get<IUserData>(Constants.CURRENT_USER_KEY);
    if (status === 0) {
      return;
    }
    if (status === ScreenLockStatus.UNLOCK) {
      log.showInfo('unlock the screen');
      this.unlocking(isHideView);
    } else {
      if (!this.isPageToPsd) {
        log.showInfo(`!this.isPageToPsd: ${!this.isPageToPsd}`);
        this.isPageToPsd = true;
        this.screenLockModel.setScreenLockPrivacy(true);
        AppStorage.setOrCreate('isPwdVisibleForPC', true);
        AppStorage.setOrCreate(Constants.START_SLIDING_UNLOCK_KEY, new Date().getTime());
        log.showInfo(`touch up unlock -> ${AppStorage.get('passwordType')}`);
      }
    }
  }

  canUnlockWithoutPassword(): boolean {
    let status: number | undefined = AppStorage.get(Constants.LOCK_STATUS_KEY);
    return status === ScreenLockStatus.UNLOCK;
  }

  /**
   * unlocking screen
   * hide scene after animation finish
   */
  unlockingWithoutHide(isPlayWallpaperAnimation: boolean = true, authType ?: osAccount.AuthType,
                       notifyUnlock: boolean = true, isHideView: boolean = false): void {
    // 双指捏合触发的解锁，统一不播放壁纸动画
    if (this.isPinchGestureSlide) {
      isPlayWallpaperAnimation = false;
      notifyUnlock = false;
    }
    this.unlocking(isHideView, notifyUnlock, isPlayWallpaperAnimation, authType);
  }

  /**
   * unlocking Screen
   *
   * @param isHideView: hideView or not
   * @param isPlayWallpaperAnimation: is play wallpaper animation
   * @param
   */
  unlocking(isHideView: boolean = true, notifyUnlock: boolean = true, isPlayWallpaperAnimation: boolean = true,
    authType?: osAccount.AuthType): void {
    let isSimLocked: boolean | undefined = AppStorage.get<boolean>('screenSimLocked');
    log.showWarn(`unlocking isHideView: ${isHideView} ,isPlayWallpaperAnimation: ${isPlayWallpaperAnimation}, ` +
      `authType: ${authType}, isSimLocked:${isSimLocked}`);
    if (!sSCBOobeManager.isEnable() && isSimLocked) {
      log.showInfo('sim locked,not on oobe,not allow to unlock');
      return;
    }
    // set the lockStatus to 'Unlock'
    AppStorage.setOrCreate(Constants.LOCK_STATUS_KEY, ScreenLockStatus.UNLOCK);
    if (!this.hasAuthType) {
      this.setScreenLockAuthState(AuthType.PIN, accountModel.getCurrentUserId(), true);
    }
    if (DeviceHelper.DEVICE_TYPE !== 'phone') {
      this.backPage();
    }
    this.setScreenLockEvent({
      lockStatus: ScreenLockEvent.LOCK_STATUS_UNLOCK
    });
    // unlock the screen
    if (this.hasAuthType()) {
      SCBSceneSessionManager.getInstance().setUserAuthPassed(true);
    }
    this.hiddenScreenLockWindow(isHideView, notifyUnlock, isPlayWallpaperAnimation, authType);
    strongAuthManager.resetReason();
  }

  protected hiddenScreenLockWindow(isHideView: boolean, notifyUnlock: boolean, isPlayWallpaperAnimation: boolean,
    authType?: osAccount.AuthType): void {
    this.screenLockModel.hiddenScreenLockWindow(() => {
      Trace.end(Trace.CORE_METHOD_UNLOCK_HIDE);
      HiSysEventUtil.reportHideKeyguard();
      if (this.firstUnLockScreen) {
        log.showInfo(`first unLock screen`);
        this.firstUnLockScreen = false;
        // 隐私空间第一次解锁，需要设置解锁类型
        if (accountModel.getCurrentUserId() === privacySpaceManager.privateUser) {
          this.setScreenLockAuthState(null, accountModel.getCurrentUserId());
        }
      }
      log.showInfo('HideScreenLock end');
      this.screenLockModel.setScreenLockPrivacy(false);
      this.resetPageToPsd();

      if (isHideView) {
        this.notifyEarlyUnlockTransition();
      }
      // 更新为已解锁状态
      this.setScreenLockEvent({
        isLock: false
      });
      isLocked = false;
      if (notifyUnlock) {
        // notify the base service that the unlock is completed
        this.notifyUnlockScreenResult(UnlockResult.Success);
      }
      if (isHideView) {
        this.notifyUnlockTransition(authType, isPlayWallpaperAnimation);
      }
      this.publishByUser('common.event.UNLOCK_SCREEN', accountModel.getCurrentUserId());
      this.mCancelUnlockCallback = undefined;
      log.showInfo(`mCallback is null: ${this.mCallback == null}`);
      if (this.mCallback !== undefined) {
        this.mCallback();
        this.mCallback = undefined;
      }
    }, isHideView);
  }

  notifyLockTransition(): void {
    slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.setSlState(SlStaticStateType.SL_HOST_STATE, true);
    screenLockStateManager.onTransitionStart(ScreenLockTransitionState.LOCK);
    SCBTransitionManager.getInstance().notifyLockTransition();
    // 锁屏时需要保障桌面图标退场动效，故SL_LOCK_STATE变量变化放在notifyLockTransition之后
    if (!slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.getSlState(OneMirrorStaticStateType.IS_NEED_SHOW_IMMERSIVE) || !immersiveKgMgr.getDefaultImmersiveSwitch()) {
      slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.setSlState(SlStaticStateType.SL_LOCK_STATE, true);
    } else {
      log.showInfo('need to show immersive card, do not play the desktop exit effect.');
    }
  }

  notifyUnlockTransition(authSuccessType?: osAccount.AuthType, isPlayWallpaperAnimation: boolean = true): void {
    log.showWarn('notifyUnlockTransition start');
    this.sleepOnScreenLock = false;
    this.screenLockDrawDown = false;
    slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.setSlState(SlStaticStateType.SL_LOCK_STATE, false)
      .setSlState(SlStaticStateType.SL_HOST_STATE, false);
    screenLockStateManager.onTransitionStart(ScreenLockTransitionState.UNLOCK);
    SCBTransitionManager.getInstance().notifyUnlockStartScene();
    SCBTransitionManager.getInstance().notifyUnlockAnimation();
    SCBTransitionManager.getInstance().notifyUnlockTransition();
    this.setWallPaperToShowDesktop();

    if (isPlayWallpaperAnimation) {
      log.showInfo('wallpaperUnlockAnimation start');
      if (authSuccessType === osAccount.AuthType.FACE && !this.needSlideUnlockAfterFaceRecognized) {
        this.faceAuthSuccessByDirectUnlock = true;
      }
    }

    this.unlockReport(authSuccessType, UnlockResult.Success);
    fingerprintReporter.kgUnlockReport(authSuccessType, UnlockStage.END_UNLOCK);
  }

  reqPlayWallpaperAnimationFromDesktopToScreenlock(): void {
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: DynamicWallPaperState.DESKTOP,
      tarState: DynamicWallPaperState.SCREENLOCK,
      isOffScreenSupportAod: false,
      onFinish: () => {
        log.showInfo('wallpaperUnlockAnimation finish');
      },
      isPlayingAnimation: false,
    });
  }

  notifySpaceAniFinished(): void {
    SCBTransitionManager.getInstance().notifyUnlockSpaceAniFinished();
  }

  notifyBeginScreenOnTransition(): void {
    SCBTransitionManager.getInstance().notifyBeginScreenOnTransition();
  }

  notifyEndScreenOnTransition(): void {
    SCBTransitionManager.getInstance().notifyEndScreenOnTransition();
  }

  notifyScreenOffTransition(): void {
    SCBTransitionManager.getInstance().notifyScreenOffTransition();
  }

  /**
   * 判断解锁后的界面是否是桌面
   *
   * @returns true: 解锁后的界面是桌面
   */
  isUnlockToHome(): boolean {
    let scenePanelState: number = AppStorage.get<number>('scenePanelState') as number;
    let showGlobalSearch: boolean = sOutSideWindowMgr.isShowGlobalSearch();
    let showNegativeScreen: boolean = ViewManagerPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN);
    let activeSessionListIsEmpty: boolean = SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty();
    // 锁屏状态下窗口会将scenePanelState置为0,如果当前为应用页面，会将应用id写入集合，解锁时取出id并将集合清空，同时需要判断全搜和负一屏
    let isUnlockToOnHome: boolean = scenePanelState === 0 && activeSessionListIsEmpty &&
      !showGlobalSearch && !showNegativeScreen;
    return isUnlockToOnHome;
  }

  /**
   * request Unlock
   */
  requestUnlock(callback: Function | undefined, keyboardPosition: number = NO_TOUCH_OR_SCREEN_MIDDLE): void {
    let isRemoteLocked: boolean | undefined = AppStorage.get<boolean>('remoteLocked');
    if (isRemoteLocked) {
      log.showWarn(`remoteLocked=${isRemoteLocked}, unlocking by invoking request is not supported.`);
      return;
    }

    let isSimLocked: boolean | undefined = AppStorage.get<boolean>('screenSimLocked');
    if (isSimLocked) {
      log.showWarn(`isSimLocked=${isSimLocked}, unlocking by invoking request is not supported.`);
      return;
    }
    if (this.customizeUnlock) {
      log.showInfo('go to customizeUnlock');
      this.mCallback = callback;
      this.customizeUnlock();
      return;
    }
    this.requestUnlockWithDelay(callback, DELAY_TIME, keyboardPosition);
  }

  requestUnlockWithDelayForControl(callback: Function | undefined, delay: number,
    cancelCallback: Callback<void>): void {
    this.mCancelUnlockCallback = cancelCallback;
    this.requestUnlockWithDelay(callback, delay);
  }

  requestUnlockWithDelay(callback: Function | undefined, delay: number,
    keyboardPosition: number = NO_TOUCH_OR_SCREEN_MIDDLE): void {
    log.showInfo('requestUnlock');
    let status: number | undefined = AppStorage.get('lockStatus');
    this.mCallback = callback;
    if (status === ScreenLockStatus.UNLOCK) {
      this.unlocking();
    } else {
      this.mIsUnlockRequested = true;
      this.isPageToPsd = true;
      this.screenLockModel.setScreenLockPrivacy(true);
      AppStorage.setOrCreate('isHomeVisible', false);
      AppStorage.setOrCreate('accountsVisible', false);
      AppStorage.setOrCreate('zoomRatio', Constants.maxZoomRatio);
      AppStorage.setOrCreate('wallPaperScale', Constants.minWallpaperScale);
      AppStorage.setOrCreate('accountOffset', Constants.maxAccountOffset);
      AppStorage.setOrCreate('viewOpacity', Constants.maxViewOpacity);
      AppStorage.setOrCreate('clockViewOpacity', Constants.maxViewOpacity);
      AppStorage.setOrCreate('accountsOpacity', Constants.maxViewOpacity);
      AppStorage.setOrCreate('slideRatio', Constants.maxSlideRatio);
      if (delay === 0) {
        AppStorage.setOrCreate('isPwdVisible', true);
        AppStorage.setOrCreate('isPwdVisibleForPC', true);
      } else {
        // 设置延时显示密码界面
        setTimeout(() => {
          AppStorage.setOrCreate('isPwdVisible', true);
          AppStorage.setOrCreate('isPwdVisibleForPC', true);
        }, delay);
      }
      AppStorage.setOrCreate('slidingDistance', SLIDING_DISTANCE);
      AppStorage.setOrCreate('touchStatus', true);
      screenLockStateManager.onEnterBouncer(keyboardPosition);
    }
  }

  /**
   * notify Screen Result
   *
   * @param result result
   */
  notifyUnlockScreenResult(result: UnlockResult): void {
    this.screenLockModel.sendScreenLockEvent(UNLOCK_SCREEN_RESULT, result, (error: BusinessError,
      data: string | number) => {
      log.showInfo('notifyUnlockScreenResult');
      SpecificScreenLockStateManager.resetIsNotifyLockScreen();
    });
    log.showInfo(`notifyUnlockresult: ${result}, ${this.resultRecieved}`);
    if (result === UnlockResult.Success && !this.resultRecieved) {
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT,
        LockOperateResult.EarlySuccess);
      this.isUnlockScreen = true;
      this.resultRecieved = true;
    } else if (result === UnlockResult.Success && this.resultRecieved) {
      this.isUnlockScreen = true;
    }
  }

  notifyLockScreenResult(result: LockResult): void {
    this.screenLockModel.sendScreenLockEvent(LOCK_SCREEN_RESULT, result,
      (error: BusinessError, data: string | number) => {
      log.showInfo('notifyLockScreenResult');
      SpecificScreenLockStateManager.setIsNotifyLockScreen(true);
    });
  }

  protected publishByUser(eventName: string, activeAccountId: number): void {
    log.showDebug(`publishByUser event name: ${eventName}`);
    commonEvent.publish(eventName, {
      parameters: {
        userId: activeAccountId
      }
    }, (error, value) => {
      if (error.code) {
        log.showError('Operation failed. ');
      } else {
        log.showDebug('publish common event success.');
      }
    });
  }

  onPageShow(): void {
    log.showInfo('onPageShow');
    accountModel.setPageShow(true);
  }

  onPageHide(): void {
    log.showInfo('onPageHide');
    accountModel.setPageShow(false);
  }

  resetPageToPsd(): void {
    this.isPageToPsd = false;
  }

  /**
   * notify Draw Done
   *
   * @param error error
   * @param result result
   */
  notifyDrawDone(): void {
    // notify the base service that the screen is loaded
    this.screenLockModel.sendScreenLockEvent(SCREENLOCK_DRAW_DONE, 0,
      (error: BusinessError, result: string | number) => {
      log.showInfo('notifyDrawDone');
    });
  }

  /**
   * Record the unlock start time for event SCREENUNLOCK_EVENT
   */
  refreshUnlockStartTime(authType?: osAccount.AuthType): void {
    log.showInfo('unlock start');
    const screenUnlockType: ScreenUnlockReportType = this.convertAuthTypeToReportUnlockType(authType);
    let unlockFlowTimeEntry: UnlockFlowTimeEntry | undefined = this.unlockFlowTimeMap.get(screenUnlockType);
    if (ObjUtil.isInvalid(unlockFlowTimeEntry)) {
      log.showWarn(`screen unlock type(${screenUnlockType}), can not get unlock flow time entry.`);
      return;
    }
    unlockFlowTimeEntry = this.unlockFlowTimeMap.get(screenUnlockType) as UnlockFlowTimeEntry;
    unlockFlowTimeEntry.startUnlock = new Date().getTime();
    log.showInfo(`refreshUnlockStartTime, authType: ${authType}, startUnlock: ${unlockFlowTimeEntry.startUnlock}`);
  }

  /**
   * Record the auth start time for event SCREENUNLOCK_EVENT
   */
  refreshAuthStartTime(authType?: osAccount.AuthType): void {
    log.showInfo('refreshAuthStartTime');
    const screenUnlockType: ScreenUnlockReportType = this.convertAuthTypeToReportUnlockType(authType);
    let unlockFlowTimeEntry: UnlockFlowTimeEntry | undefined = this.unlockFlowTimeMap.get(screenUnlockType);
    if (ObjUtil.isInvalid(unlockFlowTimeEntry)) {
      log.showWarn(`screen unlock type(${screenUnlockType}), can not get unlock flow time entry.`);
      return;
    }
    unlockFlowTimeEntry = this.unlockFlowTimeMap.get(screenUnlockType) as UnlockFlowTimeEntry;
    unlockFlowTimeEntry.startAuth = new Date().getTime();
    log.showInfo(`refreshAuthStartTime, authType: ${authType}, startAuth: ${unlockFlowTimeEntry.startAuth}`);
  }

  /**
   * Record the auth end time for event SCREENUNLOCK_EVENT
   */
  refreshAuthEndTime(authType?: osAccount.AuthType): void {
    const screenUnlockType: ScreenUnlockReportType = this.convertAuthTypeToReportUnlockType(authType);
    let unlockFlowTimeEntry: UnlockFlowTimeEntry | undefined = this.unlockFlowTimeMap.get(screenUnlockType);
    if (ObjUtil.isInvalid(unlockFlowTimeEntry)) {
      log.showWarn(`screen unlock type(${screenUnlockType}), can not get unlock flow time entry.`);
      return;
    }
    unlockFlowTimeEntry = this.unlockFlowTimeMap.get(screenUnlockType) as UnlockFlowTimeEntry;
    unlockFlowTimeEntry.endAuth = new Date().getTime();
    log.showInfo(`refreshAuthEndTime, authType: ${authType}, endTime: ${unlockFlowTimeEntry.endAuth}`);
  }

  private authSubTypeDomainMixed(password: string, callback: Function): void {
    // 域账号认证
    accountModel.registerDomainPWDInputer(password).then(async () => {
      log.showInfo('registerDomainPWDInputer success');
      let domainContextId: Uint8Array = await accountModel.authUser(CHALLENGE_INT, AuthType.DOMAIN, AuthTurstLevel.ATL3,
        (result: number, extraInfo: string) => {
        log.showInfo(`authUser callback: ${result} extraInfo`);
        accountModel.unregisterDomainInputer();
        this.printPsdErrorTimes(result);
        this.refreshAuthEndTime(osAccount.AuthType.PIN);
        fingerprintReporter.kgUnlockReport(osAccount.AuthType.PIN, UnlockStage.START_UNLOCK);
        callback(result, extraInfo);
      });
      this.domainContextIds.push(domainContextId);
    }).catch((err: BusinessError) => {
      log.showInfo('registerDomainPWDInputer fails error');
    });
  }

  private authSubTypeNoDomainMixed(password: string, callback: Function): Promise<void> {
    return accountModel.registerPWDInputer(password).then(async () => {
      log.showInfo('registerPWDInputer success');
      let authPsdEnd: boolean = false;
      let authTurstLevel = AuthTurstLevel.ATL3;
      let pwdContextId: Uint8Array =
        await accountModel.authUser(CHALLENGE_INT, AuthType.PIN, authTurstLevel,
          (result: IAMAuthResult, extraInfo: osAccount.AuthResult) => {
          log.showInfo(`authUser callback: ${result} extraInfo and ${JSON.stringify(extraInfo)}`);
          if (result === IAMAuthResult.AUTH_IS_CANCELED) {
            // 收到取消的结果，锁屏不做处理：抢占机制可能在密码输入过程中收到取消resultCode
            log.showWarn('Authentication is canceled');
            return;
          }
          this.cancelAuthOfPassword('onResult');
          accountModel.inputData = null;
          if (authPsdEnd && extraInfo?.pinValidityPeriod === 0) {
            callback(result, extraInfo);
            return;
          }
          let isAccountSwitch: boolean = AppStorage.get<boolean>('accountSwitch') as boolean;
          if (isAccountSwitch || (extraInfo?.accountId !== undefined &&
          accountModel.isUserIdValid(extraInfo?.accountId) &&
            extraInfo.accountId !== accountModel.getCurrentUserId())) {
            log.showInfo('Ignore the result because user is switching or authUserId is not currentUserId.');
            return;
          }
          if (authPsdEnd) {
            log.showInfo('Ignore the result because the authentication is successful.');
            return;
          }
          if (extraInfo?.accountId && !accountModel.isUserIdValid(extraInfo?.accountId)) {
            result = 1;
            log.showInfo(`authPIN result userId ${extraInfo?.accountId} is inValid.`);
          }
          accountModel.unregisterInputer();
          this.printPsdErrorTimes(result);
          this.refreshAuthEndTime(osAccount.AuthType.PIN);
          fingerprintReporter.kgUnlockReport(osAccount.AuthType.PIN, UnlockStage.START_UNLOCK);
          callback(result, extraInfo);
        }, async (module: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo) => {
          log.showInfo(`authUser authUser onAcquireInfo. module is ${module}, acquire is ${acquire}.`);
          PasswordManager.getInstance().isHardwareError = acquire === 1 &&
            extraJsonInfo.authResult === AcquireResultCode.HARDWARE_ERROR;
          if (acquire === 1 && extraJsonInfo.authResult === AcquireResultCode.SUCCESS) {
            authPsdEnd = true;
            accountModel.unregisterInputer();
            this.printPsdErrorTimes(0);
            this.refreshAuthEndTime(osAccount.AuthType.PIN);
            fingerprintReporter.kgUnlockReport(osAccount.AuthType.PIN, UnlockStage.START_UNLOCK);
            screenLockStateManager.onAuthFPSuccess();
            callback(0, extraJsonInfo);
          } else if (PasswordManager.getInstance().isHardwareError) {
            callback(AcquireResultCode.HARDWARE_ERROR, extraJsonInfo);
          }
        });
      this.pwdContextIds.push(pwdContextId);
    }).catch((err: BusinessError) => {
      log.showInfo('registerPWDInputer fails error');
    });
  }

  /**
   * auth User pwd
   *
   * @param authSubType authSubType
   * @param passwordData passwordData
   * @param callback callback
   */
  authUser(authSubType: AuthSubType, passwordData: number[] | string, callback: Function): void {
    if (authSubType === AuthSubType.DOMAIN_MIXED) {
      accountModel.unregisterDomainInputer();
    } else {
      accountModel.unregisterInputer();
    }
    // 记录认证开始时间
    this.refreshAuthStartTime(osAccount.AuthType.PIN);
    let password: string = '';
    if (typeof passwordData === 'string') {
      password = passwordData;
    } else {
      password = passwordData.join('');
    }
    log.showWarn(`PsdAuth start: ${authSubType}`);
    if (authSubType === AuthSubType.PIN_SIX) {
      this.authSubTypeNoDomainMixed('', callback);
    } else if (authSubType === AuthSubType.DOMAIN_MIXED) {
      this.authSubTypeDomainMixed(password, callback);
    } else {
      this.authSubTypeNoDomainMixed(password, callback);
    }
  }

  /**
   * check faceUnlock Setting and then invoke
   *
   * @param andThenInvoke andThenInvoke
   * @param delay delay
   */
  public checkFaceKeyGuardWhetherEnable(andThenInvoke: boolean = false, reason: string = FaceUnlockReason.UNKNOWN,
    delay: number = 0): void {
    log.showInfo('check faceUnlock Setting.');
    if (!this.isFaceRecognitionEnabled) {
      log.showInfo('faceUnlock is disabled.');
      return;
    }
    if (this.isFaceUnlockSettingCheckLimited) {
      log.showInfo('is faceUnlock Setting check limited.');
      return;
    }
    if (accountModel.getCurrentUserId() !== accountModel.getForegroundUserId()) {
      log.showInfo('checkFaceEnable, currentUserId is not foreground UserId.');
      return;
    }
    this.isFaceUnlockSettingCheckLimited = true;
    // 限制1秒内不允许再次触发
    setTimeout(() => {
      this.isFaceUnlockSettingCheckLimited = false;
    }, Constants.MILLISECOND_TO_SECOND);
    Trace.start(Trace.CORE_METHOD_CHECK_FACE_UNLOCK_SETTING);
    const faceKeyGuardEnableConf: string =
    sSettingsUtil.getValueBySECURE(FaceUnlockConstants.KEY_FACE_KEYGUARD_ENABLE,
      FaceUnlockConstants.FACE_CONFIG_DEFAULT_VALUE);
    const isFaceUnlockSwitchOpen = (faceKeyGuardEnableConf === FaceUnlockConstants.FACE_SWITCH_ENABLE);
    log.showInfo(`the faceUnlock switch open is (${isFaceUnlockSwitchOpen})`);
    if (!isFaceUnlockSwitchOpen) {
      AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN, false);
      return;
    }

    // Check whether user has face auth info.
    this.checkFaceAuthInfoOfCurrentUser(() => {
      // 检查人脸识别算法的锁定状态
      this.checkFaceAlgLockState();
      // 加载人脸识别算法
      this.loadFaceUnlockEnv();
      // 查询人脸识别成功后是上滑解锁还是直接解锁
      this.queryFaceRecognizeSlideUnlockConf();
    });

    Trace.end(Trace.CORE_METHOD_CHECK_FACE_UNLOCK_SETTING);
    // 若是设备重启，首次启动必须使用PIN解锁，人脸识别的开关肯定为关闭
    // 若是线程重启，需要重新检查人脸识别的状态，需延迟启动人脸识别
    // 若是切换用户，需要直接启动人脸
    if (andThenInvoke) {
      log.showInfo('check faceUnlock Setting with invoke face verify.');
      setTimeout(() => { this.invokeFaceVerify(reason); }, delay);
    }
  }

  /**
   * 设置扩展新形态小折叠到外屏应用接续使能
   */
  public setAppSwitchContinuation(enable: boolean): void {
    log.showInfo(`setAppSwitchContinuation enable is ${enable}`);
    this.appContinuationEnable = enable;
  }

  /**
   * 获取扩展新形态小折叠到外屏应用接续使能
   *
   * @returns enable true: 折叠后进入应用， false: 折叠后进入锁屏
   */
  public getAppSwitchContinuation(): boolean {
    return this.appContinuationEnable;
  }


  /**
   * 检查人脸识别算法锁定状态
   *
   * @returns void
   */
  public async checkFaceAlgLockState(): Promise<void> {
    let faceUnlockFreezingTime: number = 0;
    // 人脸识别禁用、PIN码解锁禁用，都会导致人脸禁用；
    await accountModel.getAuthProperty(AuthType.FACE, (properties: osAccount.ExecutorProperty) => {
      log.showInfo('The faceUnlock property');
      if (properties?.remainTimes === 0 && properties?.freezingTime && properties?.freezingTime > 0) {
        faceUnlockFreezingTime = properties?.freezingTime;
        // 若人脸算法处于锁定状态，需确保锁屏应用的人脸状态为锁定
        this.setFaceRecognitionState(FaceUnlockVerifyState.LOCKED);
      }
    });

    // 若人脸的freezingTime均为0，但是锁屏应用的人脸识别为锁定状态，则将人脸置为ready.
    if (faceUnlockFreezingTime === 0 &&
      AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE) === FaceUnlockVerifyState.LOCKED) {
      AppStorage.setOrCreate(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.READY);
    }
  }

  /**
   * 启动人脸识别
   */
  public invokeFaceVerify(reason: string = FaceUnlockReason.UNKNOWN, invokeWhenScreenOn: boolean = true,
    onSuccess: Callback<number> = (): void => {}): boolean {
    if (!this.checkFaceRecognitionState()) {
      return false;
    }

    log.showWarn(`FaceAuth start, reason: ${reason}`);

    Trace.start(Trace.CORE_METHOD_INVOKE_FACE_UNLOCK);
    this.setFaceRecognitionState(FaceUnlockVerifyState.VERIFYING);
    this.authUserByFace(invokeWhenScreenOn, onSuccess);
    return true;
  }

  /**
   * 是否AOD上滑解锁，用于人脸解锁成功后直接进入桌面
   */
  public setAodSlideUnlock(isAodSlide: boolean): void {
    this.isAodSlideUnlock = isAodSlide;
  }

  /**
   * AOD上滑解锁
   */
  public onAodSlideUnlock(): void {
    let isSimLocked: boolean | undefined = AppStorage.get<boolean>('screenSimLocked');
    log.showInfo(`onAodSlideUnlock requestUnlock isSimLocked: ${isSimLocked}`);
    let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
    let isFaceAvailable = this.checkFaceRecognitionState();
    if (status === ScreenLockStatus.UNLOCK && !isSimLocked) {
      if (slClockOneShotToDesktopService.isClockAodToDesktopAnimAvailable()) {
        // 如果是无密码 && AOD滑动解锁, 且满足时钟一镜到底动效, 提前设置动效标记位
        log.showInfo('clock start mirror to end when sliding on aod');
        slClockOneShotToDesktopService.updateClockAodToDesktopState(true);
      }
      this.isOffScreenUnlocking = true;
    } else if (isFaceAvailable) {
      this.isAodSlideUnlock = true;
    } else {
      this.isAodSlideUnlock = false;
      this.requestUnlock((): void => {
      });
    }
  }

  /**
   * 检查人脸识别状态
   *
   * @returns true: 人脸识别开启且状态正常
   */
  public checkFaceRecognitionState(): boolean {
    const conditions: Record<string, Function> = {
      'faceUnlockSwitchOff': () =>!AppStorage.get(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN),
      'specialMode': () => KeyguardStatusService.isSpecialMode() ||
      KeyguardStatusService.isMode(KeyGuardMode.QUICK_TOOLS),
      'coverMode': () => KeyguardStatusService.isCoverMode(),
      'faceRecognitionDisabled': () =>!this.isFaceRecognitionEnabled,
      'offScreenUnlocking': () => this.isOffScreenUnlocking,
      'lockStatusUnlocked': () => AppStorage.get('lockStatus') !== ScreenLockStatus.LOCKING,
      'isNotificationWakeUp': () => AppStorage.has('isNotificationWakeUp'),
      'strongAuthNeeded': () => strongAuthManager.isNeedStrongAuth(),
      'isBeginSleepStart': () => ((this.isFoldable && DeviceHelper.isLargeInFoldProduct()) ||
        DeviceHelper.isSmallFoldProduct()) && AppStorage.get<boolean>('isBeginSleepStart'),
      'faceUnlockVerifyingOrLocked': (): boolean => {
        let faceUnlockVerifyState: FaceUnlockVerifyState | undefined =
          AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE);
        return faceUnlockVerifyState === FaceUnlockVerifyState.VERIFYING ||
          faceUnlockVerifyState === FaceUnlockVerifyState.LOCKED;
      },
      'currentUserIdNotForeground': () => accountModel.getCurrentUserId() !== accountModel.getForegroundUserId()
    };

    for (let key of Object.keys(conditions)) {
      if (Object(conditions)[key]()) {
        log.showWarn(`invokeFaceVerify failed: ${key}`);
        return false;
      }
    }

    return true;
  }

  /**
   * Enable face authentication for the current user.
   *
   */
  public async authUserByFace(invokeWhenScreenOn: boolean, onSuccess: Callback<number> = (): void => {
    }): Promise<void> {
    this.refreshUnlockStartTime(osAccount.AuthType.FACE);
    this.refreshAuthStartTime(osAccount.AuthType.FACE);
    let authFaceEnd: boolean = false;
    let faceAuthId =
      await accountModel.authUser(CHALLENGE_INT, AuthType.FACE, AuthTurstLevel.ATL3,
        (result: number, extraInfo: osAccount.AuthResult) => {
        log.showWarn(`FaceAuth end. result: ${result}, pinValidityPeriod: ${extraInfo?.pinValidityPeriod}`);
        log.showInfo(`onresult current=${faceAuthId} contextId=${this.faceAuthContextId}`);
        if (this.faceAuthContextId !== faceAuthId) {
          log.showInfo(`onresult not the same id,no need handle auth result`);
          this.setFaceRecognitionState(FaceUnlockVerifyState.READY);
          return;
        }
        if (authFaceEnd) {
          log.showInfo('Ignore the result because the faceAuth is successful.');
          return;
        }
        this.handleFaceAuthResult(faceAuthId, invokeWhenScreenOn, result, extraInfo, onSuccess);
      }, async (module: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo) => {
        log.showDebug(`faceUnlock authUser onAcquireInfo. module is ${module}, acquire is ${acquire}.`);
        if (this.faceAuthContextId !== faceAuthId) {
          log.showInfo(`onAcquireInfo not the same id,no need handle auth result`);
          this.setFaceRecognitionState(FaceUnlockVerifyState.READY);
          return;
        }
        if (acquire === FaceUnlockConstants.FACE_AUTH_TIP_AUTH_SUCCESS) {
          authFaceEnd = true;
          this.handleFaceAuthResult(faceAuthId, invokeWhenScreenOn, IAMAuthResult.SUCCEED, undefined,
            onSuccess);
          this.sendFaceUnlockEvent();
        }
      });
    this.faceAuthContextId = faceAuthId;
  }

  /**
   *  加载人脸识别算法
   */
  public loadFaceUnlockEnv(): void {
    if (this.isLoadedFaceUnlockEnv) {
      return;
    }
    accountModel.loadFaceUnlockEnv(() => {
      log.showInfo('load faceUnlock property success.');
      this.isLoadedFaceUnlockEnv = true;
    });
  }

  /**
   *  卸载人脸识别算法
   */
  public unLoadFaceUnlockEnv(): void {
    if (!this.isLoadedFaceUnlockEnv) {
      log.showInfo('faceUnlockEnv has been unloaded, no need to unload again.');
      return;
    }
    if (this.unloadFaceEnvTaskId !== INVALID_TIMEOUT_ID) {
      clearTimeout(this.unloadFaceEnvTaskId);
    }
    this.unloadFaceEnvTaskId = setTimeout(() => {
      // 若已卸载或者此时锁定状态不是解锁状态,直接返回
      if (!this.isLoadedFaceUnlockEnv) {
        log.showInfo('faceUnlockEnv has been unloaded, no need to unload again.');
        return;
      }
      if (AppStorage.get('lockStatus') !== ScreenLockStatus.UNLOCK) {
        log.showInfo('lockStatus is locked, no need to unload.');
        return;
      }
      accountModel.unLoadFaceUnlockEnv(() => {
        log.showInfo('unload faceUnlock property success.');
        this.isLoadedFaceUnlockEnv = false;
      });
    }, FaceUnlockConstants.FACE_ALG_UNLOAD_DELAY);
  }

  public setFingerprintAcquireInfoCallback(callback: Function): void {
    this.onFingerprintAcquireInfo = callback;
  }

  public setUserSwitchedCallback(callback: Function): void {
    this.onUserSwitchedCallback = callback;
  }

  public setUserSwitchingCallback(callback: Function): void {
    this.onUserSwitchingCallback = callback;
  }

  public initCredentialUpdatedSubscriber(): void {
    commonEventMonitor.registerCredentialSubscriber(this.handleSubscriberCallback);
  }

  public destroyCredentialUpdatedSubscriber(): void {
    commonEventMonitor.unRegisterCredentialSubscriber();
  }

  // 处理指纹人脸信息变化事件回调
  private handleSubscriberCallback = (eventData: commonEventManager.CommonEventData): void => {
    if (accountModel.getCurrentUserId().toString() !== eventData?.parameters?.userId) {
      log.showInfo('is not currentUserId');
      return;
    }
    log.showInfo(`parameters.authType：${eventData?.parameters.authType}, parameters: ${eventData?.parameters.credentialCount}`);
    this.updateCipherInfo(eventData?.parameters?.authType, eventData?.parameters.credentialCount);
    this.checkHasPasswordProperty();
  };

  private updateCipherInfo(authType: string, credentialCount: string): void {
    switch (authType) {
      case AuthType.PIN.toString():
        GlobalStatusCache.getInstance().setStatus(Constants.SETTING_HAS_PASSWORD_KEY,
          credentialCount !== USER_HAS_NOCREDENTIAL);
        if (credentialCount === USER_HAS_NOCREDENTIAL) {
          AppStorage.setOrCreate(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT, false);
          AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN, false);
          strongAuthManager.resetReason();
        }
        break;
      case AuthType.FINGERPRINT.toString():
        AppStorage.setOrCreate(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT,
          credentialCount !== USER_HAS_NOCREDENTIAL);
        break;
      case AuthType.FACE.toString():
        AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN,
          credentialCount !== USER_HAS_NOCREDENTIAL);
        break;
      default:
        log.showInfo('Invalid authType');
    }
  }

  public isAuthingByFingerprint(): boolean {
    return this.fingerprintContextId != null;
  }

  /**
   * Enable fingerprint authentication for the current user.
   *
   */
  public async authUserByFingerprint(onResultCallback: (result: number, extraInfo: osAccount.AuthResult) => void):
    Promise<void> {
    log.showWarn('authUserByFingerprint');
    if (this.currentUserIsFromAccount) {
      // 切换过程中，前台用户不能注册指纹
      log.showInfo('authFingerprint, currentUserId is fromUserId.');
      return;
    }
    let fingerprintContextId = await accountModel.authUser(CHALLENGE_INT, AuthType.FINGERPRINT, AuthTurstLevel.ATL3,
      (result: number, extraInfo: osAccount.AuthResult) => {
      log.showInfo('AuthFp end. result, extraInfo');
      SystemParamUtils.setHighFrame(false);
      onResultCallback?.(result, extraInfo);
      switch (result) {
        case IAMAuthResult.SUCCEED:
          this.fingerAuthRemainCount = 3;
          this.fingerprintContextId = null;
          this.setScreenLockAuthState(AuthType.FINGERPRINT, accountModel.getCurrentUserId(), true);
          AppStorage.setOrCreate('fingerprintVerifyState', FingerprintVerifyState.NOT_READY);
          break;
        case IAMAuthResult.AUTH_IS_CANCELED:
          log.showInfo(`AuthFp IAMAuth is canceled, is same context id:
          ${fingerprintContextId === this.fingerprintContextId}`);
          this.fingerprintContextId =
            fingerprintContextId === this.fingerprintContextId ? null : this.fingerprintContextId;
          break;
        case IAMAuthResult.SYS_SERVICE_EXCEPTION:
          setTimeout(() => {
            if (isLocked && this.fingerAuthRemainCount > 0) {
              this.fingerAuthRemainCount--;
              log.showInfo('authUser again when fingerprint has exception!');
              this.authUserByFingerprint(onResultCallback);
            } else {
              this.fingerAuthRemainCount = 3;
            }
          }, this.authDelay);
        default:
          break;
      }
    }, async (module: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo) => {
      try {
        this.onFingerprintAcquireInfo(module, acquire, extraJsonInfo);
        if (acquire === FINGERPRINT_TIP_SINGLE_RESULT && extraJsonInfo.authResult !== osAccount.ResultCode.CANCELED) {
          if (strongAuthManager.isNeedStrongAuth()) {
            let isBackAnimPlaying = GlobalStatusCache.getInstance()
              .getStatus(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false);
            // 密码界面正在执行退出动效，延迟重新解锁
            setTimeout(() => strongAuthManager.strongAuthRequestUnlock(), isBackAnimPlaying ? 100 : 0);
          }
        }
      } catch (e) {
        log.showError('onFingerprintAcquireInfo fail, exception');
      }
    });
    this.fingerprintContextId = fingerprintContextId;
    log.showDebug(`authUserByFingerprint, fingerprintContextId is null or undefined,
    the authContextId is ${this.fingerprintContextId}`);
  }

  protected authResultSucceedDeal(invokeWhenScreenOn: boolean, pinValidityPeriod: number): void {
    if (AppStorage.get<boolean>('isPwdVisible')) {
      this.cancelAuthOfPassword(CancelAuthPWDReason.FACE_UNLOCK);
    }
    if (pinValidityPeriod === 0) {
      AppStorage.setOrCreate('isPinAvailable', false);
      this.setFaceRecognitionState(FaceUnlockVerifyState.EXPIRED);
      return;
    }
    this.setScreenLockAuthState(AuthType.FACE, accountModel.getCurrentUserId(), true);
    screenLockStateManager.onAuthFPSuccess();
    this.setFaceRecognitionState(FaceUnlockVerifyState.SUCCESS);
    this.unLockingAfterPassFaceAuth(invokeWhenScreenOn);
  }

  protected handleFaceAuthResult(authId: Uint8Array, invokeWhenScreenOn: boolean,
    result: number,
    extraInfo?: osAccount.AuthResult,
    onSuccess?: Callback<number>): void {
    const currentFaceUnlockVerifyState: FaceUnlockVerifyState | undefined  =
      AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE);
    if (FaceUnlockVerifyState.LOCKED === currentFaceUnlockVerifyState) {
      log.showWarn('faceUnlock has been Locked.');
      return;
    }
    if (FaceUnlockVerifyState.SUCCESS === currentFaceUnlockVerifyState) {
      log.showWarn('faceUnlock has unlocked successfully.');
      return;
    }
    this.refreshAuthEndTime(osAccount.AuthType.FACE);
    if (result !== IAMAuthResult.SUCCEED && result !== IAMAuthResult.AUTH_IS_CANCELED) {
      this.unlockReport(osAccount.AuthType.FACE, UnlockResult.Fail);
    }
    switch (result) {
      case IAMAuthResult.SUCCEED:
        this.authResultSucceedDeal(invokeWhenScreenOn, extraInfo?.pinValidityPeriod ? extraInfo?.pinValidityPeriod : 0);
        break;
      case IAMAuthResult.INCORRECT_CREDENTIAL:
        log.showWarn(`FaceAuth fail. remainTimes: ${extraInfo?.remainTimes},
        freezingTime: ${extraInfo?.freezingTime}}`);
        this.setFaceRecognitionState((extraInfo?.remainTimes === 0 && extraInfo?.freezingTime &&
          extraInfo?.freezingTime > 0) ? FaceUnlockVerifyState.LOCKED : FaceUnlockVerifyState.FAILED);
        break;
      case IAMAuthResult.AUTH_TIMEOUT:
        log.showWarn('FaceAuth timeout');
        this.setFaceRecognitionState(FaceUnlockVerifyState.NOT_RECOGNIZED);
        break;
      case IAMAuthResult.AUTH_LOCKED:
        log.showWarn('FaceAuth locked');
        this.setFaceRecognitionState(FaceUnlockVerifyState.LOCKED);
        break;
      case IAMAuthResult.AUTH_IS_CANCELED:
        log.showWarn('FaceAuth cancel');
        this.onAuthFaceCancel(authId);
        break;
      case IAMAuthResult.CREDENTIAL_NOT_ENROLLED:
        log.showWarn('FaceAuth not enrolled');
        this.setFaceRecognitionState(FaceUnlockVerifyState.NOT_RECOGNIZED);
        AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN, false);
        break;
      default:
        log.showError(`FaceAuth exception: ${result}`);
        this.setFaceRecognitionState(FaceUnlockVerifyState.NOT_RECOGNIZED);
        break;
    }
    if (!!onSuccess) {
      onSuccess(result);
    }
    this.isAodSlideUnlock = false;
    Trace.end(Trace.CORE_METHOD_INVOKE_FACE_UNLOCK);
  }

  protected onAuthFaceCancel(authId: Uint8Array): void {
    if (this.faceAuthContextId === authId) {
      this.faceAuthContextId = null;
    }
    this.setFaceRecognitionState(FaceUnlockVerifyState.READY);
    // 添加触发延时，避免人脸锁头的呼吸动效冲突
    setTimeout(() => {
      this.tryToReInvokeFaceAuthAfterCancel();
    }, SET_FACE_TIME);
  }

  protected tryToReInvokeFaceAuthAfterCancel(): void {
    if (!this.isFolderStatusChange) {
      return;
    }
    log.showInfo('Try to invoke faceUnlock when folderStatusChange.');
    // 若是折叠屏折叠状态变化导致的人脸取消，需要重新进行一次人脸识别
    this.setFolderStatusChange(false);
    if (!AppStorage.get('isScreenOn')) {
      log.showInfo('the screen is off, no need to invoke faceUnlock verify.');
      return;
    }
    screenLockService.invokeFaceVerify(FaceUnlockReason.FOLD_CHANGED);
  }

  /**
   * 设置人脸识别的状态
   *
   * @param newState 新的state
   */
  public setFaceRecognitionState(newState: number): void {
    if (AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE) === FaceUnlockVerifyState.LOCKED) {
      log.showInfo('faceUnlock has been locked. no need to change state.');
      return;
    }
    log.showInfo(`set faceUnlock state to ${newState}`);
    AppStorage.setOrCreate(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, newState);
  }

  protected unLockingAfterPassFaceAuth(invokeWhenScreenOn: boolean): void {
    if (this.noNeedToUnlockingAgain(invokeWhenScreenOn)) {
      return;
    }
    fingerprintReporter.kgUnlockReport(osAccount.AuthType.FACE, UnlockStage.START_UNLOCK);
    // 若在锁屏首页
    if (AppStorage.get('isHomeVisible')) {
      // 锁屏首页，需要滑动解锁（AOD上滑解锁场景，直接解锁）
      if (this.needSlideUnlockAfterFaceRecognized && !this.isAodSlideUnlock) {
        this.unlockingWithoutHideOnKeyGuardHome(invokeWhenScreenOn);
        // 600ms后检查是否滑动到了密码输入页面
        setTimeout(() => {
          if (AppStorage.get('isPwdVisible')) {
            log.showInfo('Slide into pwd after face unlock');
            this.faceUnlockingOnPwdVisible();
          }
        }, FaceUnlockConstants.FACE_UNLOCK_ANIMATOR_DURATION);
        return;
      }
      // 不需要滑动解锁，则直接解锁，解锁后触发锁屏时钟解锁到桌面的一镜到底动效
      this.faceUnlockingWithClockOneShotAnimation(
        ScreenLockFaceUnlockAnimationType.FIRST_INTERFACE_DISAPPEAR_ANIMATION, invokeWhenScreenOn);
      return;
    }

    // 非锁屏首页，600ms后解锁，确保人脸解锁的动画播放完毕
    setTimeout(() => {
      // 若系统未处于锁定状态
      if (AppStorage.get('lockStatus') !== ScreenLockStatus.LOCKING) {
        log.showInfo('lockStatus has been unlocked, no need to unlocking again.');
        return;
      }
      // 切换到后台或用户切换过程中, 人脸解锁不做处理
      if (accountModel.getCurrentUserId() !== accountModel.getForegroundUserId() ||
        AppStorage.get('accountSwitch') === true) {
        log.showInfo('faceUnlockAnimate, currentUserId is not foreground UserId.');
        return;
      }
      // 人脸动画播放结束后返回了锁屏首页
      if (AppStorage.get<boolean>('isHomeVisible')) {
        this.unlockingWithoutHideOnKeyGuardHome();
        return;
      }
      this.faceUnlockingOnPwdVisible();
    }, FaceUnlockConstants.FACE_UNLOCK_ANIMATOR_DURATION);
  }

  protected unlockingWithoutHideOnKeyGuardHome(invokeWhenScreenOn: boolean = true): void {
    if (invokeWhenScreenOn && (!AppStorage.get<boolean>('isScreenOn') ||
      AppStorage.get<boolean>('isBeginSleepStart') === true)) {
      log.showInfo('The screen is off, no need to unlocking again.');
      this.setFaceRecognitionState(FaceUnlockVerifyState.READY);
      return;
    }
    this.setScreenLockAuthState(AuthType.FACE, accountModel.getCurrentUserId(), true);
    this.unlockingWithoutHide(false, osAccount.AuthType.FACE, false);
    if (this.isUnderScreenFingerprint()) {
      AppStorage.setOrCreate('isFingerprintHome', false);
    }
    this.setLock(true);
    fingerprintReporter.kgUnlockReport(osAccount.AuthType.FACE, UnlockStage.END_UNLOCK);
  }

  protected noNeedToUnlockingAgain(invokeWhenScreenOn: boolean): boolean {
    if (invokeWhenScreenOn && !AppStorage.get<boolean>('isScreenOn')) {
      log.showInfo('The screen is off, no need to unlocking again.');
      this.setFaceRecognitionState(FaceUnlockVerifyState.READY);
      return true;
    }
    if (AppStorage.get('lockStatus') !== ScreenLockStatus.LOCKING) {
      log.showInfo('lockStatus has been unlocked, no need to unlocking again.');
      return true;
    }
    return false;
  }

  protected faceUnlockingOnPwdVisible(): void {
    if (!AppStorage.get<boolean>('isScreenOn')) {
      log.showInfo('The screen is off, no need to unlocking again.');
      this.setFaceRecognitionState(FaceUnlockVerifyState.READY);
      return;
    }
    this.faceUnlockingWithAnimation(ScreenLockFaceUnlockAnimationType.SECONDARY_INTERFACE_DISAPPEAR_ANIMATION);
  }

  public isFaceUnlockSuccess(): boolean {
    return AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE) === FaceUnlockVerifyState.SUCCESS;
  }

  protected faceUnlockingWithAnimation(animationType: ScreenLockFaceUnlockAnimationType,
    invokeWhenScreenOn: boolean = true): void {
    log.showWarn('faceUnlockingWithAnimation ExitKeyGuard from face start');
    if (invokeWhenScreenOn || AppStorage.get<boolean>('isScreenOn')) {
      let isHideView = !this.isPlayExitAnimation();
      this.notifyEarlyUnlockTransition();
      this.onFaceAuthSuccessAnimation(animationType);
      this.unlockingWithoutHide(true, osAccount.AuthType.FACE, true, isHideView);
      return;
    }
  }

  private isPlayExitAnimation(): boolean {
    let occludedState = GlobalStatusCache.getInstance()
      .getStatus(KeyGuardCacheKey.OCCLUDED_STATUS, OccludeKeygaurdScene.NONE) as number;
    let isFullScreenOcclude = (occludedState &= OccludeKeygaurdScene.SPECIAL) !== 0;
    log.showInfo(`isPlayExitAnimation, ${isFullScreenOcclude}, ${occludedState}`);
    return !isFullScreenOcclude;
  }

  protected faceUnlockingWithClockOneShotAnimation(animationType: ScreenLockFaceUnlockAnimationType,
    invokeWhenScreenOn: boolean = true): void {
    log.showWarn('faceUnlockingWithClockOneShotAnimation ExitKeyGuard from face start');
    if (invokeWhenScreenOn || AppStorage.get<boolean>('isScreenOn')) {
      let isHideView = !this.isPlayExitAnimation();
      if (slClockOneShotToDesktopService.isClockOneShotAnimAvailable()) {
        this.notifyEarlyUnlockTransition();
        slClockOneShotToDesktopService.noPwdUnlockJustAnimation(osAccount.AuthType.FACE);
        this.unlockingWithoutHide(true, osAccount.AuthType.FACE, true, isHideView);
        setTimeout(() => {
          log.showInfo('publish FACE_TO_DESKTOP_CLOCK_ANIMATION for oneshot');
          sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION, false));
        }, FACE_TO_DESKTOP_CLOCK_ANIMATION_DELAY);
      } else {
        this.notifyEarlyUnlockTransition();
        this.onFaceAuthSuccessAnimation(animationType);
        this.unlockingWithoutHide(true, osAccount.AuthType.FACE, true, isHideView);
      }
      return;
    }
    this.isAodSlideUnlock = false;
    this.isOffScreenUnlocking = true;
  }

  public getFingerprintContextId(): Uint8Array {
    if (this.fingerprintContextId) {
      return this.fingerprintContextId;
    } else {
      log.showError(`fingerprintContextId is null`);
      return new Uint8Array(0);
    }
  }

  public cancelAuthOfFingerprint(): void {
    log.showInfo('cancelAuthOfFingerprint');
    if (!!this.fingerprintContextId) {
      log.showInfo(`cancelAuthOfFingerprint, the authContextId is ${this.fingerprintContextId}`);
      accountModel.cancelAuth('FP', this.fingerprintContextId, () => {
        log.showInfo('cancelAuthOfFingerprint success');
        this.fingerprintContextId = null;
      });
    } else {
      log.showInfo(`cancelAuthOfFingerprint, fingerprint is canceled or auth success,
      the authContextId is ${this.fingerprintContextId}`);
    }
  }

  /**
   * 密码解锁取消认证
   */
  public cancelAuthOfPassword(reason: string = FaceUnlockReason.UNKNOWN): void {
    log.showInfo(`cancelAuthOfPassword. reason: ${reason}`);
    if (this.pwdContextIds.length === 0) {
      log.showInfo('No pwdContextIds to cancel');
    }
    for (let id of this.pwdContextIds) {
      accountModel.cancelAuth('PWD', id, () => {
        log.showInfo('cancelAuthOfPassword success');
      });
    }
    this.pwdContextIds = [];
    accountModel.inputData = null;
    accountModel.cleanPassword();
  }

  /**
   * 取消域账号认证
   */
  public cancelAuthOfDomainMixed(): void {
    if (this.domainContextIds.length === 0) {
      log.showInfo('No domainContextIds to cancel');
      return;
    }
    log.showInfo(`cancelAuthOfDomainMixed.`);
    for (let id of this.domainContextIds) {
      accountModel.cancelAuth('Domain', id, () => {
        log.showInfo('cancelAuthOfDomainMixed success');
      });
    }
    this.domainContextIds = [];
    accountModel.inputData = null;
    accountModel.cleanPassword();
  }

  public resetFaceRecognitionState(): void {
    log.showInfo('reset faceUnlock state');
    let faceUnlockVerifyState: FaceUnlockVerifyState | undefined =
      AppStorage.get(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE);
    // 若是已人脸识别成功，则将状态重置
    if (faceUnlockVerifyState === FaceUnlockVerifyState.SUCCESS) {
      this.faceAuthContextId = null;
      AppStorage.setOrCreate(FaceUnlockConstants.FACE_UNLOCK_VERIFY_STATE, FaceUnlockVerifyState.READY);
      return;
    }
    if (!AppStorage.get(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN)) {
      return;
    }
    // 若人脸识别不是正在识别中（包括已禁用），则证明结果已返回，不需要取消；
    if (faceUnlockVerifyState !== FaceUnlockVerifyState.VERIFYING) {
      return;
    }
    this.cancelAuthOfFaceUnlock();
  }

  public cancelAuthOfFaceUnlock(): void {
    log.showInfo('cancelAuth of faceUnlock');
    if (!this.faceAuthContextId) {
      return;
    }
    accountModel.cancelAuth('FACE', this.faceAuthContextId, () => {
      log.showInfo('cancel faceUnlock verify successfully');
    });
    this.faceAuthContextId = null;
  }

  /**
   * check face authentication for current user
   *
   * @param callback callback
   */
  protected checkFaceAuthInfoOfCurrentUser(callback: Callback<void>): void {
    let isFaceUnlockSwitchOpen: boolean | undefined = AppStorage.get(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN);
    log.showInfo(`isFaceUnlockSwitchOpen is ${isFaceUnlockSwitchOpen}`);
    if (isFaceUnlockSwitchOpen) {
      callback();
      return;
    }
    log.showInfo('check faceUnlock auth info of current user begin');
    accountModel.getAuthInfo(osAccount.AuthType.FACE, (enrolledCredInfo: osAccount.EnrolledCredInfo[]) => {
      try {
        let enrolledCredInfoObj = enrolledCredInfo[0];
        log.showDebug('the enrolledCredInfoObj');
        if (!!enrolledCredInfoObj?.credentialId && enrolledCredInfoObj?.authType === AuthType.FACE) {
          log.showInfo('current user has faceUnlock auth info');
          AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN, true);
          callback();
        } else {
          log.showError('The faceUnlock switch is open, but current user has no auth info');
          AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN, false);
        }
      } catch (error) {
        log.showError('check faceUnlock auth info of current user error');
        AppStorage.setOrCreate(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN, false);
      }
    });
  }

  public queryFaceRecognizeSlideUnlockConf(): boolean {
    const faceRecognizeSlideUnlockConf: string =
      sSettingsUtil.getValueBySECURE(FaceUnlockConstants.FACE_RECOGNIZE_SLIDE_UNLOCK,
        this.faceUnlockType);
    this.needSlideUnlockAfterFaceRecognized = (faceRecognizeSlideUnlockConf === FaceUnlockConstants.FACE_SWITCH_ENABLE);
    log.showInfo(`the slide unlock switch after faceUnlock is (${this.needSlideUnlockAfterFaceRecognized})`);
    AppStorage.setOrCreate(FaceUnlockConstants.FACE_UNLOCK_NEED_SLIDE, this.needSlideUnlockAfterFaceRecognized);
    this.facialMethod = Number(faceRecognizeSlideUnlockConf);
    return this.needSlideUnlockAfterFaceRecognized;
  }

  public setFaceUnlockType(faceUnlockType: string): void {
    this.faceUnlockType = faceUnlockType;
  }

  /**
   * check fingerprint for current user
   */
  public checkFingerprintForCurrentUser(successCallback: Callback<void> = (): void => { },
    errorCallback?: (error: Error) => void): void {
    log.showDebug('checkFingerprintForCurrentUser begin');
    let isCurrentUserHasFingerprint: boolean | undefined =
      AppStorage.get(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT);
    log.showInfo(`isCurrentUserHasFingerprint is ${isCurrentUserHasFingerprint}`);
    if (isCurrentUserHasFingerprint) {
      successCallback();
      return;
    }
    accountModel.getAuthInfo(AuthType.FINGERPRINT, (enrolledCredInfo: osAccount.EnrolledCredInfo[]) => {
      try {
        let enrolledCredInfoObj = enrolledCredInfo[0];
        log.showDebug('the enrolledCredInfoObj');
        if (!!enrolledCredInfoObj?.credentialId && enrolledCredInfoObj?.authType === AuthType.FINGERPRINT) {
          log.showDebug('current user has fingerprint');
          AppStorage.setOrCreate(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT, true);
        } else {
          log.showDebug('current user has no fingerprint');
          AppStorage.setOrCreate(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT, false);
        }
        successCallback();
      } catch (error) {
        log.showError('checkFingerprintForCurrentUser error');
        errorCallback?.(error);
      }
    }, errorCallback);
  }

  /**
   * get fingerprint sensor info
   */
  public async getFingerprintSensorInfo(): Promise<void> {
    log.showInfo('getFingerprintSensorInfo begin.');
    return new Promise<void>((resolve, reject) => {
      accountModel.getSensorProperty((properties: osAccount.ExecutorProperty) => {
        try {
          let sensorInfo: SensorInfo = JSON.parse(properties?.sensorInfo ?? '');
          let sensorType = sensorInfo?.sensorType;
          AppStorage.setOrCreate(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, sensorType);
          if (sensorInfo && !!sensorType && (sensorType === SensorType.UNDER_SCREEN_SENSOR ||
            sensorType === SensorType.BOTH_SENSOR)) {
            let coordinateX : number = (sensorInfo.udSensorCenterXInThousandth /
            this.thousandths) * this.displayWidth - sensorInfo.udSensorRadiusInPx;
            let coordinateY : number = (sensorInfo.udSensorCenterYInThousandth /
            this.thousandths) * this.displayHeight - sensorInfo.udSensorRadiusInPx;
            log.showInfo('getFingerprintSensorInfo udSensorCenterX: %{public}d, udSensorCenterY: %{public}d, ' +
              'udSensorRadiusInPx: %{public}d, coordinateX: %{public}d, coordinateY: %{public}d',
              sensorInfo.udSensorCenterXInThousandth, sensorInfo.udSensorCenterYInThousandth,
              sensorInfo.udSensorRadiusInPx, coordinateX, coordinateY);
            AppStorage.setOrCreate(FingerprintConstants.COORDINATE_X_OF_FINGERPRINT_UD_SCREEN_IN_PX, coordinateX);
            AppStorage.setOrCreate(FingerprintConstants.COORDINATE_Y_OF_FINGERPRINT_UD_SCREEN_IN_PX, coordinateY);
            AppStorage.setOrCreate(FingerprintConstants.FINGERPRINT_UD_SENSOR_RADIUS_IN_PX_KEY,
              sensorInfo.udSensorRadiusInPx);
          } else {
            log.showInfo('There is no sensor under screen.');
          }
        } catch (error) {
          log.showError('getFingerprintSensorInfo, error');
          AppStorage.setOrCreate(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, '');
        }
        resolve();
      }, reject);
    });
  }

  /**
   * is out of screen finger print
   */
  public isOutOfScreenFingerprint(): boolean {
    const fingerprintSensorType: string | undefined =
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
    log.showInfo(`isOutOfScreenFingerprint, fingerprintSensorType is ${fingerprintSensorType}`);
    if (!!fingerprintSensorType && (fingerprintSensorType === SensorType.OUT_OF_SCREEN_SENSOR)) {
      return true;
    }
    return false;
  }

  /**
   * is under screen finger print
   */
  public isUnderScreenFingerprint(): boolean {
    const fingerprintSensorType: string | undefined =
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
    log.showDebug(`isUnderScreenFingerprint, fingerprintSensorType is ${fingerprintSensorType}`);
    if (fingerprintSensorType === SensorType.UNDER_SCREEN_SENSOR) {
      return true;
    }
    return false;
  }

  /**
   * set lock status
   *
   * @param isLock islock
   */
  setLock(isLock: boolean): void {
    isLocked = isLock;
  }

  /**
   * get lock status
   *
   * @returns isLock or not
   */
  getLock(): boolean {
    return isLocked;
  }

  /**
   *  get editor state
   *
   * @returns
   * @returns
   */
  getEditorState(): boolean {
    return isEditor;
  }

  /**
   *  set editor state
   *
   * @returns
   * @returns
   */
  setEditorState(edited: boolean): void {
    isEditor = edited;
  }

  /**
   * go Back
   *
   * @param isNeedRefresh is need refresh view
   */
  goBack(isNeedRefresh: boolean = true): void {
    log.showInfo('begin to do goBack');
    if (!GlobalStatusCache.getInstance().getStatus(StatusCacheConst.SIM_CARD_LOCKED_KEY, false)) {
      this.screenLockModel.setScreenLockPrivacy(false);
    }
    if (isNeedRefresh) {
      if (DeviceHelper.DEVICE_TYPE === 'phone') {
        this.screenLockModel.showScreenLockWindow(() => {
        });
      } else {
        AppStorage.setOrCreate('isPwdVisibleForPC', false);
      }
    }
    this.resetPageToPsd();
    // 通知锁屏服务，取消解锁
    this.notifyUnlockScreenResult(UnlockResult.Cancel);
    // 密码输入页按返回键
    if (this.mCallback !== undefined) {
      this.mCallback = undefined;
    }
    // 从密码页面退出取消注册
    this.cancelAuthOfPassword(CancelAuthPWDReason.EXIT_BOUNCER);
    this.mCancelUnlockCallback?.();
    this.mCancelUnlockCallback = undefined;
    this.unlockReport(undefined, UnlockResult.Cancel);
    accountModel.unregisterInputer();
  }

  /**
   * destroy
   */
  destroy(): void {
    try {
      display.off('foldStatusChange', this.foldStatusChangeCallback);
    } catch (err) {
      log.showError(`unInit err:${err?.code} message:${err?.message}`);
    }
    this.screenLockModel.eventCancelListener(EVENT_END_SCREEN_ON);
    this.screenLockModel.eventCancelListener(EVENT_BEGIN_SLEEP);
    this.screenLockModel.eventCancelListener(EVENT_UNLOCK_SCREEN);
    accountModel.unRegisterAccountEventListener();
    accountModel.unRegisterUserSwitchListener('switching');
    accountModel.unRegisterUserSwitchListener('switched');
    accountModel.modelFinish();
    commonEventMonitor.destroy();
    commonEventMonitor.clearCallback();
    ScreenLockApi.clearCallback();
    screenLockStateManager.clearInnerStateCallback();
    accountsModelApi.clearAccountsModelCallback();
  }

  /**
   * get Auth Property
   * @param authType authType
   * @param callback callback
   */
  getAuthProperty(authType: osAccount.AuthType, callback: Function): void {
    log.showDebug(`getAuthProperty param: authType ${authType}`);
    accountModel.getAuthProperty(authType, (properties: PropertyInfo) => {
      callback(properties);
    });
  }

  /**
   * go to Psd page When PhysicalKeyboard Not Exist
   */
  goPsdWhenPhysicalKeyboardNotExist(): void {
    log.showInfo(`goPsdWhenPhysicalKeyboardNotExist : ${this.isPhysicalKeyboardExist}`);
    if (!this.isPhysicalKeyboardExist) {
      this.unlockScreen();
    }
  }

  printPsdErrorTimes(result: number): void {
    if (result === 0) {
      this.psdErrorTimes = 0;
    } else {
      ++ this.psdErrorTimes;
    }
    log.showInfo(`authUser psdErrorTimes = ${this.psdErrorTimes}`);
  }

  backPage(): void {
    log.showInfo(`backPage isPageToPsd= ${this.isPageToPsd}`);
    let status: number | undefined = AppStorage.get(Constants.LOCK_STATUS_KEY);
    if (this.isPageToPsd && status !== ScreenLockStatus.UNLOCK) {
      this.goBack();
    }
  }

  /**
   * 锁屏状态事件生产者
   *
   * @return 锁屏状态事件
   */
  protected onProduceScreenLockEvent(): ScreenLockEvent {
    return this.screenLockEvent;
  }

  /**
   * 设置当前锁屏状态
   *
   * @param lock 锁屏参数
   */
  protected setScreenLockEvent(lock: LockInfo): void {
    if (CommonUtils.isInvalid(lock)) {
      return;
    }
    let isNeedPost = false;
    // 更新密码锁状态
    if (!CommonUtils.isInvalid(lock.lockStatus) && this.screenLockEvent.lockStatus !== lock.lockStatus) {
      this.screenLockEvent.lockStatus = lock.lockStatus ? lock.lockStatus : 0;
      isNeedPost = true;
    }
    // 更新锁屏窗口显示状态
    if (!CommonUtils.isInvalid(lock.isLock) && this.screenLockEvent.isLockScreen !== lock.isLock) {
      this.screenLockEvent.isLockScreen = lock.isLock ? lock.isLock : false;
      isNeedPost = true;
    }
    // 发送事件
    if (isNeedPost) {
      EvtBus.post(ScreenLockEvent, this.screenLockEvent);
    }
  }

  protected initUnlockFlowTimeMap(): void {
    this.unlockFlowTimeMap.set(ScreenUnlockReportType.FLING, new UnlockFlowTimeEntry());
    this.unlockFlowTimeMap.set(ScreenUnlockReportType.FACIAL, new UnlockFlowTimeEntry());
    this.unlockFlowTimeMap.set(ScreenUnlockReportType.FINGERPRINT, new UnlockFlowTimeEntry());
    this.unlockFlowTimeMap.set(ScreenUnlockReportType.PASSWORD, new UnlockFlowTimeEntry());
  }

  protected convertAuthTypeToReportUnlockType(authType: osAccount.AuthType | undefined): ScreenUnlockReportType {
    if (!authType) {
      return ScreenUnlockReportType.FLING;
    }

    switch (authType) {
      case osAccount.AuthType.PIN:
        return ScreenUnlockReportType.PASSWORD;
      case osAccount.AuthType.FACE:
        return ScreenUnlockReportType.FACIAL;
      case osAccount.AuthType.FINGERPRINT:
        return ScreenUnlockReportType.FINGERPRINT;
      case osAccount.AuthType.DOMAIN:
        return ScreenUnlockReportType.PASSWORD;
      default:
        return ScreenUnlockReportType.FLING;
    }
  }

  /**
   * 上报解锁事件
   *
   * @param unlockSuccess 是否解锁成功
   * @param verifyTime 密码验证耗时
   * @param ReportParams.PROCESS_NAME 应用版本
   * @param e2eTime 解锁耗时
   * @param ReportParams.PACKAGE_NAME, 应用包名
   * @param type 解锁类型
   * @param facialMethod 人脸解锁类型
   * @param screenState 指纹解锁时屏幕状态
   * @param pwdUi 指纹/人脸解锁时是否显示密码界面
   * @param screen_type 屏幕类型, 1为其他屏（默认值）， 2为新形态小外屏（新增）
   */
  protected reportScreenUnlockEvent(
    unlockSuccess: boolean,
    verifyTime: number,
    e2eTime: number,
    type: string,
    facialMethod: number,
    screenState: string,
    pwdUi: string
  ): void {
    let params: ScreenUnlockEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      VERIFYSUCESS: unlockSuccess,
      VERIFY_COSTTIME: verifyTime,
      E2E_LATENCY: e2eTime,
      TYPE: type,
      FACIALMETHOD: facialMethod,
      SCREENSTATE: screenState,
      PWDUI: pwdUi,
      SWITCHMODE: accountModel.getSwitchMode(),
    };

    HiSysEventUtil.reportEvent(SCREENUNLOCK_EVENT, params, hiSysEvent.EventType.BEHAVIOR, 'SCREENLOCK_UE');
  }

  /**
   * 解锁事件打点
   *
   * @param unlockResult 解锁结果
   */
  unlockReport(authType: osAccount.AuthType | undefined, unlockResult: UnlockResult): void {
    const screenUnlockType: ScreenUnlockReportType = this.convertAuthTypeToReportUnlockType(authType);
    let unlockFlowTimeEntry: UnlockFlowTimeEntry | undefined = this.unlockFlowTimeMap.get(screenUnlockType);
    const conditions: Record<string, Function> = {
      'objUtilInvalid': () => ObjUtil.isInvalid(unlockFlowTimeEntry),
      'commonUtilsInvalid': () => CommonUtils.isInvalid(unlockResult),
      'unlockResultInvalid': () => (unlockResult === UnlockResult.Cancel),
    };
    for (let key of Object.keys(conditions)) {
      if (Object(conditions)[key]()) {
        log.showInfo(`unlockReport failed: ${key}`);
        return;
      }
    }
    const currentIsActive: boolean = power.isActive();
    this.screenState = '';
    this.pwdUi = '';
    if (screenUnlockType === 'FINGERPRINT') {
      this.screenState = currentIsActive ? 'on' : 'off';
    }
    this.unlockType = screenUnlockType === 'PASSWORD' ? this.unlockTypeStr : screenUnlockType;
    //密码可见性
    let isInBouncer: boolean | undefined = AppStorage.get('isPwdVisible');
    if (screenUnlockType === 'FINGERPRINT' || screenUnlockType === 'FACIAL') {
      this.pwdUi = isInBouncer ? 'IN_PWDUI' : 'NO_PWDUI';
    }
    unlockFlowTimeEntry = this.unlockFlowTimeMap.get(screenUnlockType) as UnlockFlowTimeEntry;
    unlockFlowTimeEntry.endUnlock = new Date().getTime();
    unlockFlowTimeEntry.authTime = unlockFlowTimeEntry.endAuth - unlockFlowTimeEntry.startAuth;
    unlockFlowTimeEntry.unlockTime = unlockFlowTimeEntry.endUnlock - unlockFlowTimeEntry.startUnlock;
    this.reportScreenUnlockEvent(
      unlockResult === UnlockResult.Success,
      unlockFlowTimeEntry.authTime,
      unlockFlowTimeEntry.unlockTime,
      this.unlockType,
      this.facialMethod,
      this.screenState,
      this.pwdUi,
    );
    if (screenUnlockType === ScreenUnlockReportType.FLING) {
      log.showInfo(`unlock type(${screenUnlockType}), so do report no pwd unlock `);
      HiDfxEventUtil.reportNoPwdUnlock();
    }
  }

  isUnlockRequsted(): boolean {
    return this.mIsUnlockRequested;
  }

  resetUnlockRequsted(): void {
    this.mIsUnlockRequested = false;
  }

  protected sendFaceUnlockEvent(): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'LAUNCHER_APP',
      name: 'FACE_UNLOCK',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: {
        'TYPE': 0,
        'RESULT': 10,
        'DURATION': 0,
        'REASON': 'FACE_UNLOCK',
      }
    };
    hiSysEvent.write(sysEventInfo,
      (err, value) => {
        if (err) {
          log.showError(`FaceUnlockApplication hiSysEvent write error: ${err.code}`);
        } else {
          log.showDebug(`FaceUnlockApplication hiSysEvent write success: ${value}`);
        }
      });
  }

  public doUnLockAnimation(unLockCallback: Function): void {
    LockScreenAnimationController.getInstance().doCallbacks();
    unLockCallback();
  }
}

let screenLockService = SingletonHelper.getInstance(ScreenLockService, TAG);

export default screenLockService as ScreenLockService;
