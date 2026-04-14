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

import promptAction from '@ohos.promptAction';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AcquireExtraInfo,
  BaseVerifyViewVm,
  ClockOneShortConsts,
  FingerprintAcquireCode,
  PowerUtils,
  ScreenLockVerifyService,
  StrongAuthStateManager,
  StrongAuthReason,
  slClockOneShotToDesktopService,
  SimCardStateManager,
  FaceUnlockReason
} from '@ohos/screenlockcommon';
import { FsmCallback } from '@ohos/screenlockcommon/Index';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import {
  SoEvent,
  SoEventType,
  SoStateType,
  SoStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenOffFsm';
import { CoreEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { VerifyTipsService } from '@ohos/screenlockcomponent/src/main/ets/tips/service/VerifyTipsService';
import { ScreenOnOffMediator } from '@ohos/screenlockcommon';

const TAG = 'ScreenOffVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_REMAIN_TIMES: number = 2;

/**
 * 锁屏熄屏视图模型
 */
export class ScreenOffVm extends BaseVerifyViewVm {
  private readonly _fsmProxy: ScreenLockFsmProxy;

  private readonly _aodStateChangeListener: FsmCallback<SoStateType, SoEvent> = {
    onFsmStateChange: this.handleAodFsmStateChange.bind(this),
  };

  /**
   * 是否已答复预亮屏结果
   */
  private _hasReplyPreBrightResult: boolean = true;

  constructor(persistentId: number) {
    super(persistentId);
    this._fsmProxy = ScreenLockFsmProxy.getInstance(persistentId);
  }

  protected doInit(): void {
    log.showInfo('doInit');
    super.doInit();

    // 注册熄屏状态机状态变更监听
    this._fsmProxy.screenOffFsm.registerObserver(this._aodStateChangeListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    super.doRelease();

    // 注销熄屏状态机状态变更监听
    this._fsmProxy.screenOffFsm.unRegisterObserver(this._aodStateChangeListener);
  }

  private handleAodFsmStateChange(oldState: SoStateType, newState: SoStateType): void {
    log.showInfo(`onFsmStateChange: ${SoStateType[oldState]} --> ${SoStateType[newState]}`);
    this.handleStateChangeInner(oldState, newState);

    this.updateVerifyState(newState);
  }

  private handleStateChangeInner(oldState: SoStateType, newState: SoStateType): void {
    if (!SoStateTypeUtils.isPreBrightState(oldState) && SoStateTypeUtils.isPreBrightState(newState)) {
      // 进入预亮屏态
      log.showInfo(`enter pre bright state. ${SoStateType[oldState]} --> ${SoStateType[newState]}`);
      this._hasReplyPreBrightResult = false;
      return;
    }
    if (SoStateTypeUtils.isPreBrightState(oldState) && !SoStateTypeUtils.isPreBrightState(newState)) {
      // 退出预亮屏态
      log.showInfo(`exit pre bright state. ${SoStateType[oldState]} --> ${SoStateType[newState]}`);
      if (this._hasReplyPreBrightResult) {
        return;
      }

      // 其他场景导致亮屏，先W取消验证，由于熄屏态的状态机优先处理，到其他页面后，会重新判断是否打开
      log.showWarn(`unnormal exit pre bright.`);
      this.wakeupDeviceFromPreBright(newState === SoStateType.SCREEN_ON_STATE ?
        PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON : PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_OFF, true);
    }
  }

  private updateVerifyState(newState: SoStateType): void {
    switch (newState) {
      case SoStateType.NORMAL_SCREEN_OFF_STATE:
      case SoStateType.PRE_BRIGHT_STATE:
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false);
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, true);
        break;
      case SoStateType.PRE_BRIGHT_FACE_AUTH_STATE:
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true,
          FaceUnlockReason.WRONG_FINGER);
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, true);
        break;
      default:
        break;
    }
  }

  protected isNeedHandleVerifyResult(): boolean {
    return CoreStateTypeUtils.isInScreenOff(this._fsmProxy.coreFsm.currentStateType);
  }

  protected onFingerVerifyOtherSuccess(): void {
    if (this.isInPreBrightState()) {
      log.showWarn('receive other success, in pre bright.');
      this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_SUCCESS);
      // 这里无须处理，等到收到账号已切换通知时再处理
    }
  }

  protected onFaceVerifySuccess(): void {
    log.showInfo('receive face verify success, when screen off.');
    this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_FACE_AUTH_SUCCESS);
    if (this.faceVerifyInfo.isDirectUnlock || this.faceVerifyInfo.isDirectUnlockOnce ||
    SoStateTypeUtils.isPreBrightTriggerFaceAuth(this._fsmProxy.screenOffFsm.currentStateType)) {
      if (SoStateTypeUtils.isPreBrightTriggerFaceAuth(this._fsmProxy.screenOffFsm.currentStateType)) {
        promptAction.showToast({
          message: $r('app.string.toast_prompt_face_unlock_success')
        });
      }
      slClockOneShotToDesktopService
        .requestDirectUnlock(ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION);
    } else {
      this._fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_SILENCE);
    }
  }

  protected onFaceVerifyFail(): void {
    log.showInfo('receive face verify fail, when screen off.');
    this._fsmProxy.submitAodEvent(SoEventType.FACE_VERIFY_FAIL);
  }

  protected onFingerprintAcquireTriggerStrongAuth(): void {
    log.showInfo('onFingerprintAcquireTriggerStrongAuth');
    this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON);
    this._fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
  }

  protected onOtherFingerprintAcquireInfo(module: number, acquire: number, extraInfo: AcquireExtraInfo): void {
    log.showInfo(`onOtherFingerprintAcquireInfo, moduleId is ${module}, acquire is ${acquire}`);
    super.onOtherFingerprintAcquireInfo(module, acquire, extraInfo);
    switch (acquire) {
      case FingerprintAcquireCode.FINGERPRINT_TIP_FINGER_DOWN:
        if (!PowerUtils.isActive()) {
          log.showInfo('Begin pre bright.');
          PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT);
          if (this.isInPreBrightState()) {
            this._hasReplyPreBrightResult = false;
          }
        }
        break;
      case FingerprintAcquireCode.FINGERPRINT_TIP_FINGER_UP:
        // 底层概未上报认证结果场景（误触等）,通过UP事件闭环预亮屏流程.
        this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_OFF);
        break;
      case FingerprintAcquireCode.FINGERPRINT_TIP_TOO_FAST:
        this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_OFF);
        break;
      case FingerprintAcquireCode.FINGERPRINT_TIP_TRIGGER_FACE_RECOGNITION:
        log.showInfo('TRIGGER_FACE_RECOGNITION');
        this._fsmProxy.submitAodEvent(SoEventType.TRIGGER_FACE_RECOGNITION);
        break;
      default:
        break;
    }
  }

  protected onOtherFingerprintAcquireSuccess(): void {
    if (this.isInPreBrightState() && !this._hasReplyPreBrightResult) {
      log.showInfo('receive finger verify success, in pre bright.');
      this.handleFingerprintAuthSuccess();
      this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_SUCCESS);
    } else {
      log.showInfo('receive finger verify success, not in pre bright.');
      // 外部依赖，AOD依赖，此处阻止AOD进入
      ScreenOnOffMediator.ableToSendScreenOffNotifyEvent = false;
      // 亮屏后再解锁，防止看不到解锁动效
      this.handleFingerprintAuthSuccess();
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
    }
  }

  protected onOtherFingerprintAcquireFail(): void {
    if (SimCardStateManager.getInstance().isSimLocked()) {
      log.showInfo(`onOtherFingerprintAcquireFail simcard locked.`);
      this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON);
      return;
    }
    log.showInfo('fingerprintVerifyInfo.remainTimes ' + this.fingerprintVerifyInfo.remainTimes);
    if (this.fingerprintVerifyInfo.remainTimes <= MAX_REMAIN_TIMES || this.fingerprintVerifyInfo.isStateLocked) {
      this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON);
      this._fsmProxy.submitCoreEvent(CoreEventType.VERIFY_FAIL);
      VerifyTipsService.getInstance().publishVerifyResultTips(AuthType.FINGERPRINT);
    }
  }

  private handleFingerprintAuthSuccess(): void {
    if (SimCardStateManager.getInstance().isSimLocked()) {
      log.showInfo(`handleFingerprintAuthSuccess simcard locked.`);
      this.wakeupDeviceFromPreBright(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON);
      return;
    }
    let isNeedStrongAuth: boolean = StrongAuthStateManager.getInstance().isNeedStrongAuth();
    log.showInfo(`handleFingerprintAuthSuccess isNeedStrongAuth: ${isNeedStrongAuth}`);
    if (isNeedStrongAuth) {
      this._fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
      return;
    }
    this._fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
  }

  private wakeupDeviceFromPreBright(reason: string, isIgnoreCurrentState: boolean = false): void {
    if (this.isInPreBrightState() || isIgnoreCurrentState) {
      log.showInfo(`wakeupDevice ${reason}`);
      PowerUtils.asyncWakeupDevice(reason);
      this._hasReplyPreBrightResult = true;
    }
  }

  private isInPreBrightState(): boolean {
    return SoStateTypeUtils.isPreBrightState(this._fsmProxy.screenOffFsm.currentStateType);
  }
}