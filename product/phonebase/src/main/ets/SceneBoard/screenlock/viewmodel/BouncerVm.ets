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

import context from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  GlobalContext,
  HiDfxEventUtil,
  OuterHomeCallbackEvent,
} from '@ohos/frameworkwrapper';
import { OccludeKeygaurdScene, SCBSceneContainerSession, SCBSceneSessionManager, SCBSystemSceneSession } from '@ohos/windowscene';
import {
  AcquireExtraInfo,
  AcquireResultCode,
  BaseVerifyViewVm,
  CacheValue,
  FaceUnlockConstants,
  FaceUnlockReason,
  FingerprintAcquireCode,
  GlobalStatusCache,
  KeyGuardCacheKey,
  KeyGuardPage,
  KeyguardStatusService,
  LockEventType,
  LockOperateResult,
  OccludedStateManager,
  screenLockInnerStateManager,
  ScreenLockUnlockService,
  ScreenLockVerifyService,
  SlServerHelper,
  VerifyDataManager,
  VerifyInfo,
  VerifyState
} from '@ohos/screenlockcommon';
import { FsmCallback } from '@ohos/screenlockcommon/Index';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { GestureNaviUtil } from '@ohos/screenlockcomponent/src/main/ets/utils/GestureNaviUtil';
import { CoreEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import {
  BouncerEvent,
  BouncerEventType,
  BouncerStateType,
  BouncerStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { VerifyTipsService } from '@ohos/screenlockcomponent/src/main/ets/tips/service/VerifyTipsService';
import { scbStatusBarStatusManager } from '@ohos/systemuicommon';

const TAG = 'BouncerVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const CODE_SHOW_SIMPIN_STATE: number = 2;
const BACK_TO_MAIN_PAGE_DELAY_MILLIS = 100; // 返回主页时延
const START_EMERGENCY_FINISH_DELAY = 1000;
const START_EMERGENCY_AGAIN_DELAY = 150;

/**
 * 密码页视图模型
 */
export class BouncerVm extends BaseVerifyViewVm {
  private readonly _fsmProxy: ScreenLockFsmProxy;
  private readonly OCCLUDED_STATE_ITEM = [OccludeKeygaurdScene.NONE, 
    OccludeKeygaurdScene.SPECIFIC_TYPE_VOICE_INTERACTION, OccludeKeygaurdScene.SYSTEM_DIALOG_UNOCCLUDE];

  private readonly _bouncerStateChangeListener: FsmCallback<BouncerStateType, BouncerEvent> = {
    onFsmStateChange: (oldState: BouncerStateType, newState: BouncerStateType): void => {
      log.showInfo(`onFsmStateChange: ${BouncerStateType[oldState]} --> ${BouncerStateType[newState]}`);
      this.handleBouncerFsmStateChange(oldState, newState);
      log.showInfo('onFsmStateChange end');
    }
  };

  private readonly _occludedStateChangeListener = (occludedState?: CacheValue): void => {
    if (!CoreStateTypeUtils.isInNormalBounce(this._fsmProxy.coreFsm.currentStateType)) {
      return;
    }
    // 收到覆盖模式回调时，退出密码界面（排除充电动效场景, 防误触弹窗场景）
    log.showInfo(`KeyguardOccludedChange change to ${occludedState}`);
    if (typeof occludedState !== 'number' || this.OCCLUDED_STATE_ITEM.includes(occludedState)
      || OccludedStateManager.getInstance().isMetaBallOccluded) {
      return;
    }

    // 密码页其他被遮挡场景，需要退回到主页。occluded回调太快，此时立即退出bouncer会导致闪屏，延时100ms
    if (this._backToMainPageTimeoutId !== 0) {
      clearTimeout(this._backToMainPageTimeoutId);
    }
    this._backToMainPageTimeoutId = setTimeout(() => {
      this._backToMainPageTimeoutId = 0;
      if (CoreStateTypeUtils.isInNormalBounce(this._fsmProxy.coreFsm.currentStateType)) {
        log.showInfo('bouncer page occluded. back to main page.');
        this._fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      }
    }, BACK_TO_MAIN_PAGE_DELAY_MILLIS);
  };

  // 解锁类型
  private _backToMainPageTimeoutId: number = 0;
  private _unlockTimeoutId: number = 0;

  // 覆盖模式拉起紧急呼叫
  private isStartingEmergency: boolean = false;
  private fullSceneEndCallback: Function = (bundleName: string, abilityName: string) => {
    if (bundleName !== Constants.EMERGENCY_CALL_BUNDLE_NAME || abilityName !== Constants.EMERGENCY_CALL_ABILITY_NAME) {
      return;
    }
    this.startEmergencyFinish(false);
  };

  constructor(persistentId: number) {
    super(persistentId);
    this._fsmProxy = ScreenLockFsmProxy.getInstance(persistentId);
  }

  /**
   * 初始化
   */
  protected doInit(): void {
    log.showInfo('doInit');
    super.doInit();
    this._fsmProxy.bouncerFsm.registerObserver(this._bouncerStateChangeListener);
    GlobalStatusCache.getInstance().subscribe(KeyGuardCacheKey.OCCLUDED_STATUS, this._occludedStateChangeListener);
    SCBSceneSessionManager.getInstance().registerFullSceneEndCallback(this.fullSceneEndCallback);
  }

  /**
   * 释放
   */
  protected doRelease(): void {
    log.showInfo('doRelease');
    super.doRelease();
    this._fsmProxy.bouncerFsm.unRegisterObserver(this._bouncerStateChangeListener);
    GlobalStatusCache.getInstance().unsubscribe(KeyGuardCacheKey.OCCLUDED_STATUS, this._occludedStateChangeListener);
    SCBSceneSessionManager.getInstance().unRegisterFullSceneEndCallback();
    if (this._backToMainPageTimeoutId !== 0) {
      clearTimeout(this._backToMainPageTimeoutId);
      this._backToMainPageTimeoutId = 0;
    }
    if (this._unlockTimeoutId !== 0) {
      clearTimeout(this._unlockTimeoutId);
      this._unlockTimeoutId = 0;
    }
  }

  /**
   * 执行返回
   */
  public goBack(): void {
    log.showInfo('goBack');
    if (!BouncerStateTypeUtils.isInBouncerState(this._fsmProxy.bouncerFsm.currentStateType)) {
      log.showInfo('goBack failed, is not in bouncer view.');
      return;
    }
    this.exitBouncerPage();
  }

  /**
   * 故障恢复
   */
  public noPwdRecovery(): void {
    log.showInfo('noPwdRecovery');
    let stateType: BouncerStateType = this._fsmProxy.bouncerFsm.currentStateType;
    if (BouncerStateTypeUtils.isInBouncerState(stateType) && !BouncerStateTypeUtils.isInSimLockState(stateType)) {
      this.exitBouncerPage();
    }
  }

  /**
   * 跳转紧急呼叫
   */
  public gotoEmergencyCall(): void {
    KeyguardStatusService.switchToPage(KeyGuardPage.EMERGENCY_PAGE);
    let isOcclude = GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.OCCLUDED_STATUS,
      OccludeKeygaurdScene.NONE) !== OccludeKeygaurdScene.NONE;
    let isEmergencyTop = this.isEmergencyTop();
    if (isOcclude && !isEmergencyTop) {
      this.isStartingEmergency = true;
      // 避免fullSceneEndCallback不回调
      setTimeout(() => this.startEmergencyFinish(true), START_EMERGENCY_FINISH_DELAY);
    }
    log.showInfo(`Click emergencyCall Button ${isOcclude} isEmergencyTop ${isEmergencyTop}.`);
    const want: Want = {
      bundleName: Constants.EMERGENCY_CALL_BUNDLE_NAME,
      abilityName: Constants.EMERGENCY_CALL_ABILITY_NAME
    };
    try {
      (GlobalContext.getInstance().getObject('desktopContext') as context.UIAbilityContext)?.startAbility(want)
        .then(() => {
          log.showInfo('gotoEmergencyCall startAbility Success.');
        }).catch((error: BusinessError) => {
        log.showInfo(`gotoEmergencyCall startAbility failed. code ${error.code}`);
      });
    } catch (error) {
      log.showError(`gotoEmergencyCall failed. code ${error.code}`);
    }

    if (isOcclude && isEmergencyTop) {
      // 紧急呼叫重复拉起，闪添加页面
      setTimeout(() => this.goBack(), START_EMERGENCY_AGAIN_DELAY);
    }
  }

  /**
   * 成功解锁
   */
  public onPasswordVerifySuccess(): void {
    log.showInfo('onScreenLockAppStarted');
    this._fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
  }

  /**
   * 验证失败
   */
  public onPasswordVerifyFail(): void {
    log.showInfo('onAuthFail');
    SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.Fail);
    if (VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).isStateLocked) {
      VerifyDataManager.getInstance().updateVerifyData();
    }
  }

  /**
   * 禁用或恢复自动刷新亮屏时间
   *
   * @param expandInputFlag 0：默认值 1：禁用
   */
  public setExpandInputFlag(expandInputFlag: number): void {
    log.showInfo(`setExpandInputFlag flag: ${expandInputFlag}`);
    try {
      const systemSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithId(this.persistentId);
      systemSceneSession?.session?.setExpandInputFlag(expandInputFlag);
    } catch (err) {
      log.showError(`setExpandInputFlag failed. reason ${err.message}`);
    }
  }

  /**
   * 触发高指纹校验
   */
  public enterHighFingerprintCheck(): void {
    log.showInfo('enterHighFingerprintCheck');
    this._fsmProxy.submitBouncerEvent(BouncerEventType.ENTER_HIGH_FINGERPRINT_CHECK);
  }

  /**
   * 取消高指纹验证
   */
  public cancelHighFingerprintCheck(): void {
    log.showInfo('cancelHighFingerprintCheck');
    this._fsmProxy.submitBouncerEvent(BouncerEventType.CANCEL_HIGH_FINGERPRINT_CHECK);
  }

  /**
   * 取消高指纹验证结束时回调
   */
  public cancelHighFingerprintFinish(): void {
    log.showInfo('cancelHighFingerprintFinish');
    scbStatusBarStatusManager.showStatusBar();
  }

  /**
   * 隐藏根页
   */
  public hideRootView(): void {
    log.showInfo('hideRootView');
    ScreenLockUnlockService.getInstance().hideRootView();
  }

  /**
   * 向OuterHome发送SIM卡PIN码是否应该显示
   * @param shouldShowSIMCard 是否应该显示SIM卡PIN码界面
   */
  public sendPinSavingEnabledToOuterHome(shouldShowSIMCard: boolean): void {
    if (!DeviceHelper.isSmallFoldProduct()) {
      return;
    }
    const eventData = JSON.stringify({ shouldShowSIMCard: shouldShowSIMCard });
    let outerHomeCallbackEvent = new OuterHomeCallbackEvent(CODE_SHOW_SIMPIN_STATE, eventData);
    EvtBus.post(OuterHomeCallbackEvent, outerHomeCallbackEvent);
  }

  protected isNeedHandleVerifyResult(): boolean {
    return CoreStateTypeUtils.isInBouncePage(this._fsmProxy.coreFsm.currentStateType);
  }

  protected onFaceVerifySuccess(): void {
    log.showInfo('face verify success.');
    // 验证通过触发状态机运转
    this._fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_SILENCE);
    // 密码页人脸解锁场景800m后解锁，确保人脸动画播放完毕再解锁
    this._unlockTimeoutId = setTimeout(() => {
      if (CoreStateTypeUtils.isInBouncePage(this._fsmProxy.coreFsm.currentStateType)) {
        this._fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
      }
    }, FaceUnlockConstants.FACE_UNLOCK_ANIMATOR_DURATION);
  }

  protected onFaceVerifyFail(): void {
    if (this.faceVerifyInfo.verifyState === VerifyState.NORMAL) {
      // 状态正常，可通过setOperateOpenState触发重新验证
      log.showInfo('face verify failed, and verifyState normal.');
    }
    VerifyTipsService.getInstance().publishVerifyResultTips(AuthType.FACE);
  }

  protected onOtherFingerprintAcquireSuccess(): void {
    // 验证通过触发状态机运转
    if (!this.fingerprintVerifyInfo.isNeedStrongAuth) {
      log.showInfo('fingerprint verify success.');
      this._fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
    } else {
      log.showInfo('fingerprint verify success, but need strong auth.');
    }
  }

  protected onFingerVerifyFail(): void {
    if (this.fingerprintVerifyInfo.verifyState === VerifyState.NORMAL) {
      // 状态正常，可通过setOperateOpenState触发重新验证
      log.showInfo('fingerprint verify failed, and verifyState normal.');
    }
  }

  private exitBouncerPage(): void {
    KeyguardStatusService.switchToPage(KeyGuardPage.HOME_PAGE);
    SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.Cancel);
    this._fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
    HiDfxEventUtil.reportPasswordBackEvent();
  }

  /**
   *  是否需要显示重置密码入口
   */
  public isNeedShowResetPinView(): boolean {
    const isPinFreezing: boolean = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).freezingTime > 0;
    if (!isPinFreezing) {
      return false;
    }
    VerifyDataManager.getInstance().updateOldPassWordValidatePeriod();
    return VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).oldPinValidatePeriod > 0;
  }

  private handleBouncerFsmStateChange(oldState: BouncerStateType, newState: BouncerStateType): void {
    // 修改验证状态
    if (oldState === newState) {
      return;
    }
    screenLockInnerStateManager.isUnlock2Editor =
      CoreStateTypeUtils.isBounceToEditState(this._fsmProxy.coreFsm.currentStateType);
    this.updateVerifyState(newState);
    if (!BouncerStateTypeUtils.isInSimLockState(oldState) && BouncerStateTypeUtils.isInSimLockState(newState)) {
      this.onEnterSimCheckState();
    }
    if (BouncerStateTypeUtils.isInSimLockState(oldState) && !BouncerStateTypeUtils.isInSimLockState(newState)) {
      this.onExitSimCheckState();
    }
    if (!BouncerStateTypeUtils.isInPwdLockState(oldState) && BouncerStateTypeUtils.isInPwdLockState(newState)) {
      GestureNaviUtil.setGestureNavigationEnableState(false, true);
      this.exitDropdownOccluded();
    }
    if (BouncerStateTypeUtils.isInPwdLockState(oldState) && !BouncerStateTypeUtils.isInPwdLockState(newState)) {
      ScreenLockVerifyService.getInstance().cancelVerify();
    }
  }

  private onEnterSimCheckState(): void {
    // 刷新导航条使能情况，SIM卡校验页面不使能home
    GestureNaviUtil.setGestureNavigationEnableState(false, false);
    // SIM卡状态禁止控制中心
    log.showInfo('disable control center.');
    AppStorage.setOrCreate('enableControllerCenter', false);
  }

  private onExitSimCheckState(): void {
    log.showInfo('recorver control center.');
    AppStorage.setOrCreate('enableControllerCenter', true);
  }

  private updateVerifyState(newState: BouncerStateType): void {
    switch (newState) {
      case BouncerStateType.PWD_CHECK_STATE:
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true, FaceUnlockReason.BOUNCER_SHOW);
        let verifyInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT);

        if (verifyInfo && verifyInfo.sensorInfo && (!verifyInfo.isNeedStrongAuth || DeviceHelper.isSmallFoldProduct())) {
          // 非强制认证场景下，低指纹场景或者屏外指纹开启，高指纹场景关闭

          ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT,
            verifyInfo.sensorInfo.isLowFingerprint() || verifyInfo.sensorInfo.isOuterFingerprint());
        } else {
          ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, false);
        }
        break;
      case BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE:
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false);
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, true);
        break;
      case BouncerStateType.SIM_CHECK_STATE:
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false);
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, false);
        break;
      default:
        break;
    }
  }

  protected onOtherFingerprintAcquireInfo(module: number, acquire: number, extraInfo: AcquireExtraInfo): void {
    super.onOtherFingerprintAcquireInfo(module, acquire, extraInfo);
    switch (acquire) {
      case FingerprintAcquireCode.FINGERPRINT_TIP_TOO_FAST:
        log.showInfo('receive FINGERPRINT_TIP_TOO_FAST');
        VerifyTipsService.getInstance().publishVerifyingTips(AuthType.FINGERPRINT, acquire);
        break;
      case FingerprintAcquireCode.FINGERPRINT_TIP_SINGLE_PRESS_RESULT:
        log.showInfo('receive FINGERPRINT_TIP_SINGLE_PRESS_RESULT');
        if (extraInfo && (extraInfo.authResult === AcquireResultCode.FAIL ||
          extraInfo.authResult === AcquireResultCode.LOCKED)) {
          VerifyTipsService.getInstance().publishVerifyResultTips(AuthType.FINGERPRINT);
        }
      default:
        break;
    }
  }

  private startEmergencyFinish(isTimeOut: boolean): void {
    if (this.isStartingEmergency) {
      this.isStartingEmergency = false;
      log.showInfo(`startEmergencyFinish adjustZIndexToNormal isTimeOut:${isTimeOut}`);
      this.goBack();
    }
  }

  private isEmergencyTop(): boolean {
    let keyName = Constants.EMERGENCY_CALL_BUNDLE_NAME + Constants.EMERGENCY_CALL_ABILITY_NAME +
      Constants.EMERGENCY_CALL_MODULE_NAME;
    let sessionList = SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().getActiveSessionList();
    if (sessionList === undefined || sessionList === null || sessionList.length === 0) {
      log.showInfo(`checkKeyNameIsInCurPanel sessionList is null`);
      return false;
    }
    let isTarget = false;
    for (let session of sessionList) {
      if (this.isTargetAbility(keyName, session)) {
        isTarget = true;
        break;
      }
    }
    return isTarget;
  }

  private isTargetAbility(keyName: string, session?: SCBSceneContainerSession):boolean {
    let primary = session?.primarySession?.sceneInfo;
    return primary !== undefined && keyName === `${primary.bundleName}${primary.abilityName}${primary.moduleName}`;
  }

  private exitDropdownOccluded(): void {
    // 进密码页面退出控制中心覆盖模式
    if (OccludedStateManager.getInstance().isDropdownOccluded) {
      OccludedStateManager.getInstance().isDropdownOccluded = false;
    }
  }
}
