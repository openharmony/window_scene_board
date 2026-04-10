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

import { CommonUtils, ObjUtil, Trace, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  GlobalContext,
  ScreenLockEvent,
  DeviceHelper,
  sSettingsUtil,
  EventManager,
  EvtBus
} from '@ohos/frameworkwrapper';
import { ResUtils, OccludeKeygaurdScene, SCBScreenSessionManager } from '@ohos/windowscene';
import { MirrorToEndConst } from '@ohos/screenlockcomponent/src/main/ets/onemirror/constants/MirrorToEndConst';
import data_dataShare from '@ohos.data.dataShare';
import { AsyncCallback, BusinessError, Callback } from '@ohos.base';
import display from '@ohos.display';
import { CommonConstants } from '@ohos/launchercommon';
import { scbStatusBarStatusManager } from '@ohos/systemuicommon';
import {
  PowerUtils,
  GlobalStatusCache,
  StatusCacheConst,
  KeyGuardCacheKey,
  strongAuthManager,
  screenLockStateManager,
  SystemParamUtils,
  slClockOneShotToDesktopService
} from '@ohos/screenlockcommon';
import ScreenLockService, {UnlockResult} from './ScreenLockService';
import { AuthType, IAMAuthResult } from './AccountsModel';
import { IAMAuthExtraInfo } from '@ohos/screenlockcommon';
import {
  PromptShowPos,
  ToastPromptViewModel
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/ToastPromptViewModel';
import { FingerprintConstants, SensorType } from '@ohos/screenlockcommon';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import osAccount from '@ohos.account.osAccount';
import {
  InputPwdDefaultPromptViewModel
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/InputPwdDefaultPromptViewModel';
import { MultimodalInputPowerModule } from '@ohos/screenlockcommon/Index';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import power from '@ohos.power';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import TemporaryPromptViewModel from '@ohos/screenlockcomponent/src/main/ets/fingerprint/TemporaryPromptViewModel';
import promptAction from '@ohos.promptAction';
import { sensorManager } from '@ohos/screenlockcommon/Index';
import FreezingTipUtil from '@ohos/screenlockcomponent/src/main/ets/common/FreezingTipUtil';
import DrawDoneManager from '@ohos/screenlockcommon/src/main/ets/manager/DrawDoneManager';
import LockScreenBase from './LockScreenBase';
import IAodProxy from '@ohos/screenlockcomponent/src/main/ets/onemirror/model/IAodProxy';
import lottie from '@ohos/lottie';
import curves from '@ohos.curves';
import hilog from '@ohos.hilog';
import {
  BasePromptViewModel,
  PromptShowType
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import fs from '@ohos.file.fs';
import { ScreenLockManager } from './ScreenLockManager';
import { FaceUnlockVerifyState, FaceUnlockReason } from '@ohos/screenlockcommon';
import { CancelAuthPWDReason } from '@ohos/screenlockcommon/src/main/ets/constants/CommonConstants';
import { ScreenOnOffMediator } from '@ohos/screenlockcommon';

const TAG = 'ScreenLock-FingerprintViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const MAX_REMAIN_TIMES: number = 2;
// 灭屏下错误超过两次就会亮屏
const MAX_OFFSCREEN_AUTH_FILED_TIMES: number = 2;
const ONE_SECOND_TO_MILLISECOND: number = 1000;
const RETRY_INTERVAL_MS: number = 1500; // retry interval
const MAX_RETRY_TIMES: number = 5; // dataShare max retry times
let fingerprintKeyguardEnableUriVar =
  'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=' +
  FingerprintConstants.KEY_FINGERPRINT_KEYGUARD_ENABLE;

/**
 * Unlock protection key of the device.
 */
const KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK: string = 'key_fp_unlock_protection_for_screen_lock';

/**
 * Default Unlock protection key of the device
 */
const FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK_DEFAULT: string = '0';

let fingerprintUnlockProtectionUriVar =
  'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=' +
    KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK;

enum KeyFingerprintUnlockType {
  TOUCH_UNLOCK = 0,
  PRESS_UNLOCK = 1
};

const WAKE_UP_DELAY_TIME: number = 17;

const FINGERPRINT_TIP_TRIGGER_FACE_RECOGNITION: number = 10006;

const FINGERPRINT_TIP_SINGLE_PRESS_RESULT: number = 10001;

const DEFAULT_USER_ID: number = 100;

const COMPONENT_ID_FINGERPRINT = TAG + '_FingerPrint';

export enum PsdPageShowFingerprintType {
  NONE_FINGERPRINT = 0,
  REAL_FINGERPRINT = 1,
  FAKE_FINGERPRINT = 2
}
;

export enum FingerprintAuthStatus {
  FINGERPRINT_AUTH_START = 0,
  FINGERPRINT_AUTH_SUCCESS = 1,
  FINGERPRINT_AUTH_SUCCESS_WHEN_SCREEN_OFF = 2,
  FINGERPRINT_AUTH_FAIL = 3
}

/**
 * ViewModel
 *
 * @since 2023-9-11
 */
export default class FingerprintViewModel {
  /**
   * 指纹识别是否被暂停
   */
  private isFpSuspend: boolean = false;
  private aodProxy: IAodProxy | null = null;
  private isShowFingerprintView: boolean = false;
  private fingerprintViewBlur: number = 0;
  private hasPressResult: boolean = true;
  private fingerprintViewPrompt: ResourceStr = $r('app.string.press_fingerprint_sensor_area');
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  public mainCanvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings)
  private screenLockDrawDoneManager: DrawDoneManager = new DrawDoneManager(COMPONENT_ID_FINGERPRINT);
  private records: Record<string, object> = {};
  private lottieName: string = 'fingerprint_growth';
  private lottieJsonPath: string = 'SceneBoard/screenlock/lottie/fingerprint_growth.json';
  private fingerprintViewTransitionEffect: TransitionEffect = TransitionEffect.asymmetric(TransitionEffect.scale({
    x: 1.1, y: 1.1
  })
    .animation({
      delay: 200, duration: 400, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    })
    .combine(TransitionEffect.opacity(0).animation({
      delay: 200, duration: 200, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1)
    })), TransitionEffect.scale({
    x: 0.9,
    y: 0.9
  })
    .animation({
      delay: 0, duration: 500, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    })
    .combine(TransitionEffect.opacity(0).animation({
      delay: 0, duration: 250, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1)
    })));
  private pwdPageExitTransitionEffect: TransitionEffect =
    TransitionEffect.asymmetric(TransitionEffect.IDENTITY, TransitionEffect.opacity(0).animation({
      delay: 0, duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1)
    })
      .combine(TransitionEffect.scale({
        x: Constants.MIN_ZOOM_RATIO_PWD,
        y: Constants.MIN_ZOOM_RATIO_PWD
      }).animation({
        delay: 0, duration: 400,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
      })));
  private isFingerprintViewExitAnimationFinish: boolean = true;
  private isNotifyPwrPreBright: boolean = true;
  private mSettingsHelper: data_dataShare.DataShareHelper | null = null;
  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private inputPwdDefaultPromptViewModel: InputPwdDefaultPromptViewModel | null = null;
  private toastPromptViewModel: ToastPromptViewModel | null = null;
  private temporaryPromptViewModel: TemporaryPromptViewModel | null = null;
  protected customizePromptVM: BasePromptViewModel | null = null;
  public isExStartUnlockImmediately: boolean = false;
  public onFingerprintAuthCallback: Callback<FingerprintAuthStatus> = () => {
  };
  private onAuthFinishCallback: Function = (extraJsonInfo: IAMAuthExtraInfo) => {
  };
  /**
   * 锁定状态事件
   *
   * @param event 事件
   */
  private onScreenLockEvent = (event: ScreenLockEvent): void => {
    log.showDebug('ScreenLockEvent');
    if (!this.isPowerFingerprintTouchUnlockEnable() || this.isPowerFingerUnlockByPress()) {
      log.showDebug('is not fold touch unlock, so no need to process screen lock event.');
      return;
    }
    if (event.isSecureAndLocked()) {
      this.multimodalInputPowerModule?.registerPowerKeyDown();
      log.showInfo('registerPowerKeyDown end.');
    } else {
      this.multimodalInputPowerModule?.unRegisterPowerKeyDown();
      log.showInfo('unRegisterPowerKeyDown end.');
    }
  }

  public preBright(): void {
    log.showWarn('pre-bright');
    this.screenLockDrawDoneManager.registerComponentDrawObserver(this.screenLockDrawObserverCallback);
  }

  public setNotifyPwrPreBrightState(isNotifyPwrPreBright: boolean): void {
    this.isNotifyPwrPreBright = isNotifyPwrPreBright;
  }

  public getNotifyPwrPreBrightState(): boolean {
    return this.isNotifyPwrPreBright;
  }

  public screenLockDrawObserverCallback: () => void = (): void => {
    log.showInfo('screenLockDrawObserverCallback draw done.');
    this.screenLockNotifyDrawDone();
  };

  public screenLockNotifyDrawDone(): void {
    if (ScreenLockService.getScreenLockDrawDown()) {
      // 同时收到预亮屏且绘制完成，则通知窗口锁屏绘制完成
      ScreenLockService.notifyDrawDone();
    } else {
      ScreenLockService.setScreenLockDrawDown(true);
    }
  }

  private unlockType: KeyFingerprintUnlockType = KeyFingerprintUnlockType.TOUCH_UNLOCK;
  private isAcquireFromNonInteractive: boolean = false;
  private isAcquireWhenBeginSleep: boolean = false;
  private isPowerBeginFromInteractive: boolean = true;
  private authTime: number = 0;
  private powerUpBlockTimerId: number = -1;
  private readonly powerUpBlockTime: number = 700;
  // ms

  private multimodalInputPowerModule: MultimodalInputPowerModule | null = null;
  private isFingerprintEnable: boolean = false;

  public getIsFingerprintEnable(): boolean {
    return this.isFingerprintEnable;
  }

  private powerKeyDownUpCallback: Callback<inputConsumer.KeyOptions> = (keyOptions: inputConsumer.KeyOptions) => {
    log.showInfo('power key down up default callback, keyOptions');
    if (!this.isPowerFingerprintTouchUnlockEnable() || this.isPowerFingerUnlockByPress()) {
      log.showInfo('current is not fold and touch unlock, so no need process.');
      return;
    }

    if (keyOptions.finalKey === KeyCode.KEYCODE_POWER && keyOptions.isFinalKeyDown) {
      log.showInfo('power key down callback.');
      let currentIsActive: boolean = power.isActive();
      log.showInfo(`power down current active status is ${currentIsActive}.`);
      this.isPowerBeginFromInteractive = currentIsActive;
    }

    if (keyOptions.finalKey === KeyCode.KEYCODE_POWER && !keyOptions.isFinalKeyDown) {
      log.showInfo('power key up callback.');
      this.multimodalInputPowerModule?.unRegisterPowerKeyUp();
      if (this.powerUpBlockTimerId != -1) {
        clearTimeout(this.powerUpBlockTimerId);
        this.powerUpBlockTimerId = -1;
      }
    }
  };
  private offScreenFingerprintFailCnt: number = 0;
  private isLowFingerprintPosition: boolean | undefined = undefined;
  private baseTrans: Array<number> = [];
  private psdPageFingerprintTransitionEffect: TransitionEffect =
    TransitionEffect.asymmetric(TransitionEffect.IDENTITY, TransitionEffect.IDENTITY);

  public resetOffScreenFingerprintFailCnt(): void {
    log.showDebug('resetOffScreenFingerprintFailCnt.');
    this.offScreenFingerprintFailCnt = 0;
  }

  protected doPreBrightAuthFailScreenOff(): void {
    if (this.getNotifyPwrPreBrightState() === true ||
      AppStorage.get<number>('faceUnlockVerifyState') === FaceUnlockVerifyState.VERIFYING) {
      log.showInfo('no need doPreBrightAuthFailScreenOff.');
      return;
    }
    this.setNotifyPwrPreBrightState(true);
    PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_OFF);
    ScreenLockManager.getInstance().setPreBrightStat(false);
  }

  protected computeBaseTrans(biasX: number, biasY: number) {
    let distX = biasX * Constants.PRE_NUMBER_BIAS_X;
    let distY = biasY * Constants.PRE_NUMBER_BIAS_Y;
    let dist: number = Math.sqrt(Math.pow(distX, 2) + Math.pow(distY, 2));
    this.baseTrans.push(dist ? distX / dist * Constants.DIST_PER_TURN : 0);
    this.baseTrans.push(dist ? distY / dist * Constants.DIST_PER_TURN : 0);
    return;
  }

  public getPsdPageFingerprintTransitionEffect(): TransitionEffect {
    return this.psdPageFingerprintTransitionEffect;
  }

  public changePsdPageFingerprintTransitionEffect(offHandNormalizedSpeed: number) {
    log.showInfo('changePsdPageFingerprintTransitionEffect begin.');
    if (this.baseTrans.length !== 2) {
      log.showError('baseTrans length is not two.');
      return;
    }
    this.psdPageFingerprintTransitionEffect =
      TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({
          duration: Constants.PSD_ENTER_OPACITY_TIME,
          delay: 4 * Constants.DELAY_TIME_PER_TURN + Constants.PSD_ENTER_DELAY
        })
        .combine(TransitionEffect.scale({
          x: Constants.NUM_KEYBOARD_INIT_SCALE,
          y: Constants.NUM_KEYBOARD_INIT_SCALE
        })
          .animation({
            curve: curves.interpolatingSpring(offHandNormalizedSpeed, Constants.PSD_MASS, Constants.PSD_STIFFNESS,
              Constants.PSD_DAMPING),
            delay: 4 * Constants.DELAY_TIME_PER_TURN + Constants.PSD_ENTER_DELAY
          })
          .combine(TransitionEffect.translate({
            x: 4 * this.baseTrans[0] * Constants.PSD_TRANS_X_FACTOR,
            y: 4 * this.baseTrans[1] * Constants.PSD_TRANS_Y_FACTOR
          })
            .animation({
              curve: curves.interpolatingSpring(offHandNormalizedSpeed, Constants.PSD_MASS, Constants.PSD_STIFFNESS,
                Constants.PSD_DAMPING),
              delay: 4 * Constants.DELAY_TIME_PER_TURN + Constants.PSD_ENTER_DELAY
            })))
        , TransitionEffect.IDENTITY)
  }

  protected isUnderFingerprintPosLow(): boolean | undefined {
    const coordinateY: number | undefined = AppStorage.get<number>('coordinateYOfFingerprintUdScreenInPx')
    const udSensorRadiusInPx: number | undefined = AppStorage.get<number>('udSensorRadiusInPx')
    if (coordinateY === undefined || udSensorRadiusInPx === undefined || !CommonUtils.isNumber(coordinateY) ||
      !CommonUtils.isNumber(udSensorRadiusInPx) || coordinateY === 0 || udSensorRadiusInPx === 0) {
      log.showError('out of screen fingerprint coordinateY or udSensorRadiusInPx is invalid.');
      return undefined;
    }
    try {
      const displayHeight = px2vp(display.getDefaultDisplaySync().height);
      if (displayHeight > 96 && px2vp(coordinateY + udSensorRadiusInPx) > (displayHeight - 96)) {
        return true;
      }
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error.message}`);
    }
    return false;
  }


  public getPwdPageShowFingerprintType(): PsdPageShowFingerprintType {
    if (ScreenLockService.isOutOfScreenFingerprint()) {
      log.showInfo('out of screen fingerprint no need to show fingerprint in psd page.');
      return PsdPageShowFingerprintType.NONE_FINGERPRINT;
    }

    if (!this.isFingerprintEnable || this.isFpSuspend) {
      log.showInfo('no need to show fingerprint in psd page.');
      return PsdPageShowFingerprintType.NONE_FINGERPRINT;
    }

    if (this.isLowFingerprintPosition === undefined) {
      this.isLowFingerprintPosition = this.isUnderFingerprintPosLow();
    }

    if (this.isLowFingerprintPosition === undefined) {
      log.showInfo('get fingerprint position fail.');
      return PsdPageShowFingerprintType.NONE_FINGERPRINT;
    }

    return this.isLowFingerprintPosition ? PsdPageShowFingerprintType.REAL_FINGERPRINT :
    PsdPageShowFingerprintType.FAKE_FINGERPRINT;
  }

  public getFingerprintViewBlur(): number {
    return this.fingerprintViewBlur;
  }

  public setFingerprintViewBlur(blur: number) {
    this.fingerprintViewBlur = blur;
  }

  public enterFingerprintView(): void {
    log.showInfo('FingerprintViewModel enterFingerprintView.');
    if (!this.isFingerprintViewExitAnimationFinish) {
      log.showError('FingerprintViewModel fingerprint View exit animation not finish.');
      return;
    }

    log.showInfo('FingerprintViewModel disableFaceRecognition.');
    ScreenLockService.disableFaceRecognition();
    AppStorage.setOrCreate('isFingerprintHome', true);
    this.setFingerprintViewBlur(3);
    animateTo({
      delay: 200, duration: 200, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    }, () => {
      this.fingerprintViewBlur = 0;
      this.isShowFingerprintView = true;
    });

    // Hide status bar.
    this.hideStatusBar();
    this.loadFingerprintGrowAnimation();
  }

  protected hideStatusBar() {
    scbStatusBarStatusManager.hideStatusBar();
  }

  public loadFingerprintGrowAnimation(): void {
    log.showInfo(`FingerprintViewModel loadFingerprintGrowAnimation(${this.lottieName}).`);
    let fingerPrintParam: string | undefined = ScreenLockThemeManager.getInstance().getScrenLockHigtFingerThemeParams();
    if (fingerPrintParam) {
      this.getLottieData(fingerPrintParam);
      lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: true,
        name: this.lottieName,
        animationData: this.records.fingerPrint
      })
    } else {
      lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: true,
        name: this.lottieName,
        path: this.lottieJsonPath
      })
    }
  }

  public getLottieData(jsonPath: string): void {
    this.loadLottieData(jsonPath, (value: Object) => {
      this.records.fingerPrint = value;
    })
  }

  protected loadLottieData(jsonPath: string, callback: (value: object) => void): void {
    try {
      let lottieStr: string = fs.readTextSync(jsonPath);
      let lottieData: object = JSON.parse(lottieStr);
      if (callback) {
        callback(lottieData);
      }
    } catch (err) {
      log.showError('context is undefined');
    }
  }

  public destroyFingerprintGrowAnimation(): void {
    log.showInfo('do destroyFingerprintGrowAnimation.');
    lottie.destroy(this.lottieName);
  }

  public exitFingerprintView(isToScreeanLock: boolean = false): void {
    log.showInfo('FingerprintViewModel exitFingerprintView.');
    if (!this.isShowFingerprintView) {
      log.showInfo('FingerprintView is not show.');
      return;
    }

    if (!isToScreeanLock) {
      log.showInfo('exitFingerprintView isFingerprintHome false.');
      AppStorage.setOrCreate('isFingerprintHome', false);
    }

    this.isFingerprintViewExitAnimationFinish = false;
    animateTo({
      delay: 0,
      duration: 500,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        ScreenLockService.disableFaceRecognition();
        this.resetFingerprintViewPrompt();
        this.destroyFingerprintGrowAnimation();
        this.isFingerprintViewExitAnimationFinish = true;
        // Show status bar.
        this.showStatusBar();
        log.showInfo('exit fingerprint view animateTo onFinish.');
      }
    }, () => {
      this.fingerprintViewBlur = 3;
      this.isShowFingerprintView = false;
    });

  }

  protected showStatusBar() {
    scbStatusBarStatusManager.showStatusBar();
  }

  /**
   * 密码界面指纹图标是否显示（高位指纹产品）
   *
   * @returns true: 指纹图标显示
   */
  public isFingerprintViewShow() {
    return this.isShowFingerprintView;
  }

  /**
   * 是否是熄屏按下指纹解锁
   *
   * @returns true: 熄屏指纹解锁
   */
  public isFingerprintAcquireWhenScreenOff() {
    return this.isAcquireFromNonInteractive && !AppStorage.get<boolean>('isScreenOn');
  }

  public exitFingerprintViewWithoutAnimation(isToScreeanLock: boolean = false): void {
    log.showInfo('FingerprintViewModel exitFingerprintViewWithoutAnimation.');
    if (!this.isShowFingerprintView) {
      log.showInfo('FingerprintView is not show.');
      return;
    }
    log.showInfo('FingerprintViewModel enableFaceRecognition.');
    ScreenLockService.enableFaceRecognition();

    if (!isToScreeanLock) {
      log.showInfo('exitFingerprintViewWithoutAnimation isFingerprintHome false.');
      AppStorage.setOrCreate('isFingerprintHome', false);
    }
    this.resetFingerprintViewPrompt();
    this.fingerprintViewBlur = 3;
    this.isShowFingerprintView = false;

    // Show status bar.
    this.showStatusBar();
    log.showError('destroyFingerprintGrowAnimation exitFingerprintViewWithoutAnimation.');
    this.destroyFingerprintGrowAnimation();
    this.isFingerprintViewExitAnimationFinish = true;
  }


  public getFingerprintViewTransitionEffect(): TransitionEffect {
    return this.fingerprintViewTransitionEffect;
  }

  public getPwdPageExitTransitionEffect(): TransitionEffect {
    return this.pwdPageExitTransitionEffect;
  }

  public inFingerprintView(): boolean {
    log.showInfo(`isShowFingerprintView ${this.isShowFingerprintView}`)
    return this.isShowFingerprintView;
  }

  public resetFingerprintViewPrompt(): void {
    this.fingerprintViewPrompt = $r('app.string.press_fingerprint_sensor_area');
  }

  public setFingerprintViewPrompt(prompt: ResourceStr): void {
    this.fingerprintViewPrompt = prompt;
  }

  public getFingerprintViewPrompt(): ResourceStr {
    return this.fingerprintViewPrompt;
  }

  public setAuthFinishCallback(callback: Function): void {
    this.onAuthFinishCallback = callback;
  }

  protected isPowerFingerprintTouchUnlockEnable(): boolean {
    if (!ScreenLockService.isOutOfScreenFingerprint()) {
      log.showDebug('not out of screen finger print, no need to process.');
      return false;
    }

    if (!this.isFingerprintEnable) {
      log.showInfo('finger print is not enable, so , no need to process.');
      return false;
    }

    return true;
  }

  public onIsFingerprintEnableChange(isFingerprintEnable: boolean) {
    log.showWarn('onIsFingerprintEnableChange isFingerprintEnable' +
      `from ${this.isFingerprintEnable} to ${isFingerprintEnable}`);
    this.isFingerprintEnable = isFingerprintEnable;
    if (this.isFingerprintEnable && ScreenLockService.getLock()) {
      if (!this.isPowerFingerprintTouchUnlockEnable() || this.isPowerFingerUnlockByPress()) {
        log.showDebug('onIsFingerPrintEnableChange is not fold touch unlock, so no need to process screen lock event.');
        return;
      }
      log.showInfo('onIsFingerPrintEnableChange registerPowerKeyDown begin.');
      this.multimodalInputPowerModule?.registerPowerKeyDown();
      log.showInfo('onIsFingerPrintEnableChange registerPowerKeyDown end.');
    }
  }

  /**
   * 判断侧边指纹手机指纹解锁方式是否是按压解锁
   *
   * @returns true: 按压解锁, false: 轻触解锁
   */
  protected isPowerFingerUnlockByPress(): boolean {
    return this.unlockType === KeyFingerprintUnlockType.PRESS_UNLOCK;
  }

  public onResultCallback(extraInfo: IAMAuthExtraInfo): void {
    log.showWarn(`FPAuth end. result: ${extraInfo.authResult}`);

    this.hasPressResult = true;
    switch (extraInfo.authResult) {
      case IAMAuthResult.SUCCEED:
        screenLockStateManager.onAuthFPSuccess();
        const currentIsActive: boolean = power.isActive();
        log.showInfo(`onResultCallback currentIsActive: ${currentIsActive}, isAcquireFromNonInteractive: ${this.isAcquireFromNonInteractive}`);
        if (!ScreenLockService.getLock()) {
          log.showInfo('onResultCallback, has been unlocked, return');
          return;
        }

        if (this.isPowerFingerprintTouchUnlockEnable() || this.isPowerFingerUnlockByPress()) {
          const currentTime: number = new Date().getTime();
          log.showInfo(`set auth success time is ${currentTime}.`);
          this.authTime = currentTime;
        }

        this.unlockingAfterAuthFingerSuccess();
        this.onSuccessUnlockCallback();
        break;
      case IAMAuthResult.AUTH_IS_CANCELED:
        if (ScreenLockManager.getInstance().getPreBrightStat()) {
          this.doPreBrightAuthFailScreenOff();
        }
        log.showWarn('FPAuth cancel');
        break;
      case IAMAuthResult.FAIL:
        log.showWarn(`FPAuth fail. remainTimes:
          ${extraInfo.authRemainAttempts}, freezingTime:${extraInfo.lockoutDuration}`);
        break;
      case IAMAuthResult.SYS_SERVICE_EXCEPTION:
      default:
        log.showError(`FPAuth exception: ${extraInfo.authResult}`);
        break;
    }
  }

  protected unlockingAfterAuthFingerSuccess(): void {
    if (AppStorage.get<boolean>('isPwdVisible')) {
      ScreenLockService.cancelAuthOfPassword(CancelAuthPWDReason.FP_UNLOCK);
    }
    let isFpEnable = this.isPowerFingerprintTouchUnlockEnable() || ScreenLockService.isUnderScreenFingerprint();
    let isScreenOff = this.isAcquireFromNonInteractive && !AppStorage.get<boolean>('isEndScreenOn');
    // 指纹解锁成功时, 设置灭屏标记为false, 避免一镜到底模块进入AOD
    ScreenOnOffMediator.ableToSendScreenOffNotifyEvent = false;
    log.showInfo(`AuthFingerSuccess isFpEnable: %{public}s, isScreenOff: %{public}s, isAcquireWhenBeginSleep: %{public}s`,
      isFpEnable, isScreenOff, this.isAcquireWhenBeginSleep);
    if (isFpEnable && (isScreenOff || this.isAcquireWhenBeginSleep)) {
      // 黑屏指纹解锁逻辑
      log.showInfo(`delay unlocking, isAcquireFromNonInteractive: %{public}s, isAcquireWhenBeginSleep: %{public}s.`,
        this.isAcquireFromNonInteractive, this.isAcquireWhenBeginSleep);
      AppStorage.setOrCreate('isFingerprintHome', false);
      ScreenLockService.setIsOffScreenUnlocking(true);
      this.onFingerprintAuthCallback(FingerprintAuthStatus.FINGERPRINT_AUTH_SUCCESS_WHEN_SCREEN_OFF);
      if (DeviceHelper.isPC()) {
        ScreenLockService.setLock(false);
      }
      return;
    }

    let isHideView = !this.isPlayExitAnimation();
    ScreenLockService.notifyEarlyUnlockTransition();
    this.onFingerprintAuthCallback(FingerprintAuthStatus.FINGERPRINT_AUTH_SUCCESS);
    ScreenLockService.unlockingWithoutHide(true, osAccount.AuthType.FINGERPRINT, true, isHideView);
  }

  protected isPlayExitAnimation(): boolean {
    // 侧边指纹 && 全屏覆盖模式 && 亮屏，不播解锁动画
    if (!ScreenLockService.isOutOfScreenFingerprint() || !power.isActive()) {
      return true;
    }
    let occludedState = GlobalStatusCache.getInstance()
      .getStatus(KeyGuardCacheKey.OCCLUDED_STATUS, OccludeKeygaurdScene.NONE) as number;
    let isFullScreenOcclude = (occludedState &= OccludeKeygaurdScene.SPECIAL) != 0;
    return !isFullScreenOcclude;
  }

  protected isNeedBlockPowerUp(): boolean {
    const isRightSeq: boolean =
      this.isAcquireFromNonInteractive && this.isPowerBeginFromInteractive && this.authTime > 0;
    log.showInfo(`isRightSeq(${isRightSeq}), isAcquireFromNonInteractive(${this.isAcquireFromNonInteractive}), isPowerBeginFromInteractive(${this.isPowerBeginFromInteractive}), authTime(${this.authTime}).`);
    return isRightSeq;
  }

  protected onSuccessUnlockCallback(): void {
    log.showWarn('onSuccessUnlockCallback');
    if (this.isPowerFingerprintTouchUnlockEnable()) {
      this.onSuccessForPowerFingerprintTouchUnlock();
    } else if (ScreenLockService.isUnderScreenFingerprint()) {
      this.onSuccessForUnderScreenFingerprint();
    }
  }

  private skipPreBrightSuccess() {
    log.showInfo('isAcquire is active, so no need to process');
    setTimeout(() => {
      log.showInfo('screen lock auth ok, begin to wakeup.');
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
      if (power.isActive()) {
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(MirrorToEndConst.NOTIFY_CANCEL_OFF_SCREEN);
      }
      log.showInfo('screen lock auth ok, end to wakeup.');
    }, WAKE_UP_DELAY_TIME);
  }

  protected onSuccessForUnderScreenFingerprint(): void {
    if (!this.isAcquireFromNonInteractive) {
      this.skipPreBrightSuccess();
      return;
    }

    let currentIsActive: boolean | undefined = power.isActive();
    log.showWarn(`onSuccessForUnderScreenFingerprint, currentIsActive ${currentIsActive}`);
    if (currentIsActive) {
      return;
    }
    this.prepareClockOneShotAnim();
    PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_SUCCESS);
  }

  protected onSuccessForPowerFingerprintTouchUnlock(): void {
    if (!this.isAcquireFromNonInteractive) {
      this.skipPreBrightSuccess();
      return;
    }

    let currentIsActive: boolean = power.isActive();
    log.showWarn(`onSuccessForPowerFingerprintTouchUnlock, currentIsActive ${currentIsActive} ScreenLockService.isScreenOn ${ScreenLockService.isScreenOn}`);
    if (currentIsActive) {
      return;
    }
    this.prepareClockOneShotAnim();
    log.showInfo('onSuccessForPowerFingerprintTouchUnlock, begin to wakeup.');
    if (DeviceHelper.isPC()) {
      log.showInfo(`The PC's screen-on follows its own logic.`)
      return;
    }
    LockScreenBase.onBeginWakeup();
    PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_SUCCESS).then(() => {
      log.showInfo(`onSuccessForPowerFingerprintTouchUnlock, powerUpBlockTimerId is ${this.powerUpBlockTimerId}.`);
      if (this.isNeedBlockPowerUp()) {
        log.showInfo('onSuccessForPowerFingerprintTouchUnlock, begin to block power up event.');
        if (this.powerUpBlockTimerId != -1) {
          log.showInfo('onSuccessForPowerFingerprintTouchUnlock, powerUpBlockTimerId has exist, so clear.');
          clearTimeout(this.powerUpBlockTimerId);
          this.powerUpBlockTimerId = -1;
          this.multimodalInputPowerModule?.unRegisterPowerKeyUp();
        }

        this.multimodalInputPowerModule?.registerPowerKeyUp();
        this.powerUpBlockTimerId = setTimeout(() => {
          log.showInfo('onSuccessForPowerFingerprintTouchUnlock,begin to unregister power key up.');
          this.multimodalInputPowerModule?.unRegisterPowerKeyUp();
        }, this.powerUpBlockTime);
      }
    }).catch((error: BusinessError) => {
      log.error('onSuccessForPowerFingerprintTouchUnlock, wakeup error');
    })
    log.showInfo('onSuccessForPowerFingerprintTouchUnlock, end to wakeup.');
  }

  protected async getFingerprintPrompt(
    remainTimes: number,
    freezingTime: number,
    isPsdFreezing: boolean
  ): Promise<string> {
    log.showInfo(
      `getFingerprintPrompt remainTimes:${remainTimes},
     freezingTime:${freezingTime},
      isPsdFreezing: ${isPsdFreezing}`
    );
    if (freezingTime === FingerprintConstants.INVALID_DURATION) {
      return ResUtils.getInnerString($r('app.string.fp_disable_forever'));
    }
    const sensorType = AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
    let promptText = ResUtils.getInnerString($r('app.string.fp_incorrect_fp_try_again_pc'));
    if (sensorType === SensorType.OUT_OF_SCREEN_SENSOR && !DeviceHelper.isPC()) {
      promptText = ResUtils.getInnerString($r('app.string.out_sensor_fp_dirty_try_again'));
    }
    if (0 < remainTimes && remainTimes <= MAX_REMAIN_TIMES) {
      if (freezingTime <= 0) {
        // set default freezing time
        freezingTime = FingerprintConstants.DEFAULT_FINGERPRINT_DISABLE_MILLI_SECOND;
      }
      let freezingTimeStr = await FreezingTipUtil.getFreezingTimeStr(freezingTime);
      let lockTxt = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked1'), remainTimes);
      promptText =
        ResUtils.getInnerStringNumS($r('app.string.fingerprint_incorrect_will_locked'), lockTxt, freezingTimeStr);
    } else if (0 === remainTimes) {
      if (freezingTime > 0) {
        const promptFreezingTime: number = freezingTime < ONE_SECOND_TO_MILLISECOND ?
          ONE_SECOND_TO_MILLISECOND : freezingTime
        if (isPsdFreezing) {
          promptText = await this.getPromptWhenPsdFreeing(promptFreezingTime);
        } else if (DeviceHelper.isPC()) {
          promptText = await ResUtils.getInnerStringNum($r('app.string.fp_try_again_after_time_pc'),
            await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime));
        } else {
          promptText = await ResUtils.getInnerStringNum($r('app.string.fp_try_again_after_time'),
            await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime));
        }

      }
    }

    log.showInfo('getFingerprintPrompt end');
    return promptText;
  }

  public setIsAcquireWhenBeginSleep(isAcquireWhenBeginSleep: boolean): void {
    this.isAcquireWhenBeginSleep = isAcquireWhenBeginSleep;
  }

  protected async getPromptWhenPsdFreeing(promptFreezingTime: number): Promise<string> {
    const passwordType: string | undefined = AppStorage.get('passwordType');
    if ('PIN_SIX' === passwordType) {
      return await ResUtils.getInnerStringNum($r('app.string.fp_try_again_pin_after_time'),
        await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime));
    }
    return await ResUtils.getInnerStringNum($r('app.string.fp_try_again_psd_after_time'),
      await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime))
  }

  public setDuringBeginSleepToEndSleep(duringBeginSleepToEndSleep: boolean): void {
    this.isAcquireWhenBeginSleep = duringBeginSleepToEndSleep;
  }

  protected fingerprintTipTooFastPrompt() {
    if (this.isShowFingerprintView) {
      this.toastPromptViewModel?.showToastPrompt(ResUtils.getInnerString($r('app.string.fp_hold_finger')),
        PromptShowPos.FINGERPRINT_VIEW);
    } else if (AppStorage.get('isPwdVisible')) {
      this.toastPromptViewModel?.showToastPrompt(ResUtils.getInnerString($r('app.string.fp_hold_finger')),
        PromptShowPos.PSD);
    } else {
      this.temporaryPromptViewModel?.showTemporaryPrompt(ResUtils.getInnerString($r('app.string.fp_hold_finger')));
    }
    this.customizePromptVM?.showPrompt(ResUtils.getInnerString($r('app.string.fp_hold_finger')),
      PromptShowType.TEMPORARY);
    log.showInfo('finger print to show hold finger for a little longer prompt.');
  }

  protected fingerprintTipImageDirtyPrompt() {
    if (!DeviceHelper.isPC()) {
      return;
    }
    let isPCPwdVisible: boolean = AppStorage.get<boolean>('isPwdVisibleForPC') as boolean;
    if (isPCPwdVisible) {
      this.toastPromptViewModel?.showToastPrompt(ResUtils.getInnerString($r('app.string.out_sensor_fp_dirty_try_again')),
        PromptShowPos.PSD);
    } else {
      this.temporaryPromptViewModel?.showTemporaryPrompt(ResUtils.getInnerString($r('app.string.out_sensor_fp_dirty_try_again')));
    }
    this.customizePromptVM?.showPrompt(ResUtils.getInnerString($r('app.string.out_sensor_fp_dirty_try_again')),
      PromptShowType.TEMPORARY);
  }

  public async fingerprintAcquireInfoCallback(moduleId: number, acquire: number,
    extraJsonInfo: IAMAuthExtraInfo): Promise<void> {
    // onAcquire时回调
    log.showInfo(`AuthFp start, moduleId is ${moduleId}, acquire is ${acquire}`);
    try {
      if (acquire === osAccount.FingerprintTips.FINGERPRINT_TIP_FINGER_DOWN) {
        Trace.start(Trace.CORE_METHOD_FINGERPRINT_AUTH);
        log.showWarn('FPAuth start');
        ScreenLockService.refreshUnlockStartTime(osAccount.AuthType.FINGERPRINT);
        ScreenLockService.refreshAuthStartTime(osAccount.AuthType.FINGERPRINT);
        this.onFingerprintDown();
        this.hasPressResult = false;
        if (this.isAcquireFromNonInteractive) {
          this.setNotifyPwrPreBrightState(false);
          // 下发预亮屏事件
          PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT);
          ScreenLockManager.getInstance().setPreBrightStat(true);
        } else {
          SystemParamUtils.setHighFrame(true);
        }
        this.onFingerprintAuthCallback(FingerprintAuthStatus.FINGERPRINT_AUTH_START);
        return;
      }
      if (acquire === FINGERPRINT_TIP_TRIGGER_FACE_RECOGNITION) {
        SystemParamUtils.setHighFrame(false);
        this.onWrongFingerprintTriggerFaceRecognition(acquire);
        return;
      }
      if (acquire === osAccount.FingerprintTips.FINGERPRINT_TIP_TOO_FAST) {
        SystemParamUtils.setHighFrame(false);
        if (ScreenLockManager.getInstance().getPreBrightStat()) {
          log.showInfo('preBrightStat is true');
          this.doPreBrightAuthFailScreenOff();
        }
        this.fingerprintTipTooFastPrompt();
        return;
      }
      if (acquire === osAccount.FingerprintTips.FINGERPRINT_TIP_IMAGER_DIRTY) {
        SystemParamUtils.setHighFrame(false);
        if (ScreenLockManager.getInstance().getPreBrightStat()) {
          this.doPreBrightAuthFailScreenOff();
        }
        this.fingerprintTipImageDirtyPrompt();
        return;
      }
      if (acquire === osAccount.FingerprintTips.FINGERPRINT_TIP_FINGER_UP) {
        SystemParamUtils.setHighFrame(false);
        // 底层概未上报认证结果场景（误触等）,通过UP事件闭环预亮屏流程.
        if (ScreenLockManager.getInstance().getPreBrightStat() && !this.hasPressResult) {
          log.showInfo('No authentication result is returned.');
          this.doPreBrightAuthFailScreenOff();
          return;
        }
      }
      if (strongAuthManager.isNeedStrongAuth()) {
        log.showInfo('Strong Auth: Block fingerprint authentication');
        return;
      }
      this.onFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
    } catch (e) {
      log.showError('fingerprintAcquireInfoCallback fail');
    }
  }

  protected onFingerprintDown() {
    const currentIsActive: boolean = power.isActive();
    log.showInfo(`onAcquireInfo currentIsActive(${currentIsActive})`);
    this.authTime = 0;
    this.isPowerBeginFromInteractive = true;
    this.isAcquireFromNonInteractive = !currentIsActive;
    GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_SCREEN_OFF_FINGERPRINT_UNLOCK_ANI, !currentIsActive);
    this.isAcquireWhenBeginSleep = AppStorage.get<boolean>('isBeginSleepStart') as boolean;
    return;
  }

  protected onWrongFingerprintTriggerFaceRecognition(acquire: number) {
    const currentIsActive: boolean = power.isActive();
    log.showInfo(`wrongFingerprintTriggerFaceRecognition currentIsActive(${currentIsActive})`);
    if (currentIsActive) {
      log.showInfo(`wrongFingerprintTriggerFaceRecognition current is active(${currentIsActive}), so no need trigger face verify.`);
      return;
    }
    ScreenLockService.invokeFaceVerify(FaceUnlockReason.WRONG_FINGER, false, (authResult: number) => {
      log.showInfo(`wrongFingerprintTriggerFaceRecognition current is not active, so face verify success to wake up screen, islock(${ScreenLockService.getLock()}).`);
      if (authResult !== IAMAuthResult.SUCCEED) {
        if (ScreenLockManager.getInstance().getPreBrightStat() &&
          this.offScreenFingerprintFailCnt <= MAX_OFFSCREEN_AUTH_FILED_TIMES) {
          log.showInfo('wrongFingerprintTriggerFaceRecognition, auth failed');
          this.doPreBrightAuthFailScreenOff();
        }
        return;
      }
      setTimeout(() => {
        try {
          let isSlideUnlock = ScreenLockService.queryFaceRecognizeSlideUnlockConf();
          if (!isSlideUnlock) {
            promptAction.showToast({
              message: $r('app.string.toast_prompt_face_unlock_success')
            });
          }
          if (AppStorage.get<boolean>('isEndScreenOn')) {
            log.showInfo('isScreenOn, no need to wakeup again.');
            ScreenLockService.setIsOffScreenUnlocking(false);
            return;
          }
          if (slClockOneShotToDesktopService.isClockAodToDesktopAnimAvailable() && !isSlideUnlock) {
            log.info('updateClockAodToDesktopState true');
            slClockOneShotToDesktopService.updateClockAodToDesktopState(true);
          }
          log.showInfo('wrongFingerprintTriggerFaceRecognition face verify success, begin to wakeup.');
          PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FACE_AUTH_SUCCESS);
          log.showInfo('wrongFingerprintTriggerFaceRecognition face verify success, end to wakeup.');
        } catch (e) {
          log.showError(`wrongFingerprintTriggerFaceRecognition error:${e}`);
        }
      }, ScreenLockService.getLock() ? 0 : WAKE_UP_DELAY_TIME);
    });
  }

  protected async getFreezingTimeByPsd(): Promise<number> {
    return new Promise((resolve) => {
      let authType: AuthType = ScreenLockService.isDomainAuthType() ? AuthType.DOMAIN : AuthType.PIN;
      ScreenLockService.getAuthProperty(authType, async (properties: osAccount.ExecutorProperty) => {
        log.showInfo(`getFreezingTimeByPsd getAuthProperty param: authType ${authType}, properties`);
        if (!properties || properties.remainTimes === undefined || properties.freezingTime === undefined) {
          log.showError(`properties(${properties}) is invalid`);
          resolve(0);
          return;
        }
        if (properties.remainTimes !== 0) {
          log.showInfo(`remainTimes(${properties.remainTimes}) is invalid`);
          resolve(0);
          return;
        }
        if (properties.freezingTime <= 0) {
          log.showInfo(`freezingTime(${properties.freezingTime}) is invalid`);
          resolve(0);
          return;
        }
        log.showInfo(`freezingTime(${properties.freezingTime}) is valid.`);
        resolve(properties.freezingTime);
        return;
      });
    });
  }

  protected async onFingerprintTipsResult(
    moduleId: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo): Promise<void> {
    if (acquire !== FINGERPRINT_TIP_SINGLE_PRESS_RESULT) {
      log.showInfo('not single press result, no need to process.');
      return;
    }

    if (ObjUtil.isInvalid(extraJsonInfo)) {
      log.showError('extraJsonInfo is not exist or invalid.');
      return;
    }

    if (extraJsonInfo.authResult === osAccount.ResultCode.SUCCESS) {
      // success
      log.showInfo('authResult success.');
      this.isExStartUnlockImmediately = false;
      this.hasPressResult = true;
      this.setFingerSuspend(false);
      this.onAuthFinishCallback(extraJsonInfo);
      return;
    }

    if (extraJsonInfo.authResult !== osAccount.ResultCode.FAIL &&
      extraJsonInfo.authResult !== osAccount.ResultCode.LOCKED) {
      log.showInfo(`authResult(${extraJsonInfo.authResult}), no need to process on aquire callback.`);
      this.onAuthFinishCallback(extraJsonInfo);
      return;
    }

    if (extraJsonInfo.authResult === osAccount.ResultCode.FAIL) {
      ScreenLockService.refreshAuthEndTime(osAccount.AuthType.FINGERPRINT);
      ScreenLockService.unlockReport(osAccount.AuthType.FINGERPRINT, UnlockResult.Fail);
      this.offScreenFingerprintFailCnt = this.offScreenFingerprintFailCnt + 1;
      this.onAuthFinishCallback(extraJsonInfo);
    }

    let fpRemainTimes: number = extraJsonInfo.authRemainAttempts;
    let fpFreezingTime: number = extraJsonInfo.lockoutDuration;

    this.updateFingerprintSuspend(fpRemainTimes, fpFreezingTime);

    let psdFreezingTime: number = 0;
    if (fpFreezingTime === FingerprintConstants.INVALID_DURATION) {
      psdFreezingTime = await this.getFreezingTimeByPsd();
    }

    let isPsdFreezing: boolean = false;
    if (psdFreezingTime > 0) {
      fpFreezingTime = psdFreezingTime;
      isPsdFreezing = true;
    }
    const currentIsActive: boolean = power.isActive();
    log.showInfo(`changeFingerprintPrompt currentIsActive(${currentIsActive})`);

    if (!currentIsActive &&
      (this.isPowerFingerprintTouchUnlockEnable() || ScreenLockService.isUnderScreenFingerprint())) {
      this.changeFingerprintPromptForOffScreen(fpRemainTimes, fpFreezingTime, isPsdFreezing);
      return;
    }

    if (this.isShowFingerprintView) {
      return this.changeFingerprintPromptInView(fpRemainTimes, fpFreezingTime, isPsdFreezing);
    }

    this.changeFingerprintPrompt(fpRemainTimes, fpFreezingTime, isPsdFreezing);
  }

  protected async changeFingerprintPromptForOffScreen(
    remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<void> {
    log.showInfo(`changeFingerprintPromptForOffScreen, remainTimes(${remainTimes}), freezingTime(${freezingTime}), isPsdFreezing(${isPsdFreezing}).`);

    let isFingerprintFreeze = remainTimes <= 0 && freezingTime > 0;
    if (ScreenLockManager.getInstance().getPreBrightStat() &&
      this.offScreenFingerprintFailCnt <= MAX_OFFSCREEN_AUTH_FILED_TIMES && !isFingerprintFreeze) {
      this.doPreBrightAuthFailScreenOff();
    }
    const isInverted: boolean = await sensorManager.checkIsInverted();
    if (isInverted) {
      log.showInfo(`changeFingerprintPromptForOffScreen isInverted(${isInverted}).`);
      this.resetOffScreenFingerprintFailCnt();
      return;
    }

    if (this.offScreenFingerprintFailCnt >= 3 || isFingerprintFreeze) {
      log.showInfo(`changeFingerprintPromptForOffScreen begin to wakeup.`);
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON);
      log.showInfo(`changeFingerprintPromptForOffScreen end to wakeup.`);
      const propStr: string = await this.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      this.toastPromptViewModel?.showToastPrompt(propStr, PromptShowPos.PSD);
      this.customizePromptVM?.changePrompt(remainTimes, freezingTime, isPsdFreezing);
      if (DeviceHelper.isPC() && remainTimes === 0) {
        log.showInfo(`begin countdown`);
        this.customizePromptVM?.changePrompt(remainTimes, freezingTime, isPsdFreezing);
      }
      return;
    }
  }

  protected async changeFingerprintPrompt(
    remainTimes: number,
    freezingTime: number,
    isPsdFreezing: boolean): Promise<void> {
    log.showInfo(
      `changeFingerprintPrompt,
       remainTimes(${remainTimes}),
        freezingTime(${freezingTime}),
         isPsdFreezing(${isPsdFreezing}).`
    );
    this.customizePromptVM?.changePrompt(remainTimes, freezingTime, isPsdFreezing);
    const propStr: string = await this.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);

    if (remainTimes <= MAX_REMAIN_TIMES && remainTimes > 0) {
      this.isAcquireWhenBeginSleep = AppStorage.get<boolean>('isBeginSleepStart') as boolean;
      if (this.isAcquireWhenBeginSleep) {
        log.showInfo('device is going to sleep, need wakeup');
        PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(MirrorToEndConst.NOTIFY_CANCEL_OFF_SCREEN);
      }
      this.toastPromptViewModel?.showToastPrompt(propStr, PromptShowPos.PSD);
    } else {
      const isPwdVisible: boolean = DeviceHelper.DEVICE_TYPE ===
      CommonConstants.PC_DEVICE_TYPE ? !!AppStorage.get('isPwdVisibleForPC') : !!AppStorage.get('isPwdVisible');
      if (isPwdVisible) {
        this.toastPromptViewModel?.showToastPrompt(propStr, PromptShowPos.PSD);
      } else {
        this.temporaryPromptViewModel?.showTemporaryPrompt(propStr, freezingTime);
        this.temporaryPromptViewModel?.countdown(
          remainTimes,
          freezingTime,
          isPsdFreezing,
          true,
          (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
            return this.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing)
          });
      }
    }
  }

  protected async changeFingerprintPromptInView(
    remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<void> {
    log.showInfo(`changeFingerprintPrompt, remainTimes(${remainTimes}), freezingTime(${freezingTime}), isPsdFreezing(${isPsdFreezing}).`);
    const propStr: string = await this.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
    log.showInfo(`propStr is ${propStr}`);

    if (remainTimes <= 0 && freezingTime > 0) {
      log.showInfo(`changeFingerprintPrompt, exitFingerprintView, remainTimes(${remainTimes}), freezingTime(${freezingTime}), isPsdFreezing(${isPsdFreezing}).`);
      this.exitFingerprintView();
      this.toastPromptViewModel?.showToastPrompt(propStr, PromptShowPos.PSD);
    } else {
      if (remainTimes > 0) {
        let lockTxt = await ResUtils.getInnerPlural($r('app.plural.fp_fingerprint_not_match'), remainTimes);
        this.setFingerprintViewPrompt(lockTxt);
      }
      this.toastPromptViewModel?.showToastPrompt(propStr, PromptShowPos.FINGERPRINT_VIEW);
    }
  }

  /**
   * 更新指纹识别状态,是否需要暂停
   *
   * @param remainTimes 剩余指纹识别次数
   * @param freezingTime 指纹冻结时间
   */
  public updateFingerprintSuspend(remainTimes: number, freezingTime: number): void {
    log.showInfo(`updateFingerprintSuspend, remainTimes(${remainTimes}), freezingTime(${freezingTime}).`);
    if (remainTimes <= 0 && freezingTime > 0) {
      this.inputPwdDefaultPromptViewModel?.changePSDDefaultPrompt(freezingTime, $r('app.string.fp_disable_enter_psd'),
        () => {
          this.setFingerSuspend(false);
        });
      this.setFingerSuspend(true);
      return;
    }
    if (remainTimes > 0) {
      this.setFingerSuspend(false);
    }
  }

  /**
   * 获取指纹识别状态
   * @returns true:指纹识别被暂停; false:恢复指纹识别
   */
  public isFingerprintSuspend(): boolean {
    log.showDebug(`current fingerprint suspend status is ${this.isFpSuspend}.`);
    return this.isFpSuspend;
  }

  /**
   * 是否暂停指纹识别
   * @param isSuspend true:暂停; false:恢复
   */
  public setFingerSuspend(isSuspend: boolean): void {
    if (isSuspend === this.isFpSuspend) {
      return;
    }
    if (isSuspend && !this.isFingerprintEnable) {
      log.showInfo('setFingerSuspend, finger print is not enable');
      return;
    }
    log.showInfo(`setFingerSuspend, isSuspend: ${isSuspend}`);
    this.isFpSuspend = isSuspend;
    AppStorage.setOrCreate('isFingerprintSuspend', isSuspend);
    if (isSuspend) {
      this.inputPwdDefaultPromptViewModel?.changePSDDefaultPrompt(FingerprintConstants.INVALID_DURATION,
        $r('app.string.fp_disable_enter_psd'));
    } else {
      this.inputPwdDefaultPromptViewModel?.resetDefaultPrompt();
    }
  }

  public checkFingerprintFreezingTime(): void {
    log.showInfo('checkFingerprintFreezingTime');
    ScreenLockService.getAuthProperty(AuthType.FINGERPRINT, (properties: osAccount.ExecutorProperty) => {
      log.showInfo('checkFingerprintFreezingTime getAuthProperty param: properties');
      if (!properties || properties.remainTimes === undefined || properties.freezingTime === undefined) {
        log.showWarn(`checkFingerprintFreezingTime, remainTimes(${properties?.remainTimes}) or freezingTime(${properties?.freezingTime}) is invalid.`);
        return;
      }
      log.showInfo(`checkFingerprintFreezingTime, remainTimes(${properties.remainTimes}) freezingTime(${properties.freezingTime}) .`);
      this.updateFingerprintSuspend(properties.remainTimes, properties.freezingTime);
    });
  }

  /**
   * register FingerprintUnlockSwitch event
   */
  protected async registerFingerprintUnlockSwitchEvent(callback: AsyncCallback<void>,
    leftRetryTimes: number): Promise<void> {
    if (leftRetryTimes <= 0) {
      log.error('no left retry times');
      leftRetryTimes = 1;
    }
    let context = GlobalContext.getContext();
    let mCurUsr: number = await osAccount.getAccountManager().getOsAccountLocalId();
    if (!mCurUsr) {
      mCurUsr = DEFAULT_USER_ID;
    }
    log.showDebug(`FINGERPRINT_KEYGUARD_ENABLE_URI_VAR mCurrentUsr:${mCurUsr}`);
    fingerprintKeyguardEnableUriVar =
      `datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_${mCurUsr}?Proxy=true&key=${FingerprintConstants.KEY_FINGERPRINT_KEYGUARD_ENABLE}`;

    try {
      data_dataShare.createDataShareHelper(context, fingerprintKeyguardEnableUriVar).then((dataHelper) => {
        this.mSettingsHelper = dataHelper;
        try {
          this.mSettingsHelper.on('dataChange', fingerprintKeyguardEnableUriVar, callback);
        } catch (e) {
          log.showInfo('Can not listen fp_keyguard_enable change.');
        }
      });
    } catch (err) {
      log.error('register fingerprint switch settings DataShare catch error:', err);
      setTimeout(this.registerFingerprintUnlockSwitchEvent.bind(this, leftRetryTimes - 1), RETRY_INTERVAL_MS);
    }
  }

  /**
   * register FingerprintUnlockSwitch event
   */
  protected unregisterFingerprintUnlockSwitchEvent(): void {
    try {
      this.mSettingsHelper?.off('dataChange', fingerprintKeyguardEnableUriVar);
    } catch (error) {
      log.showError('unregisterFingerprintUnlockSwitchEvent failed.');
    }
  }

  private updateFingerprintUnlockType: () => void = () => {
    const value: string = sSettingsUtil.getValueBySECURE(KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK,
      FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK_DEFAULT);
    log.showInfo(`handleFingerprintUnlockTypeChange ${KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK} = value(${value})`);
    this.unlockType = (value === '0') ? KeyFingerprintUnlockType.TOUCH_UNLOCK : KeyFingerprintUnlockType.PRESS_UNLOCK;
  };

  /**
   * register UnlockProtection event
   */
  protected registerFingerprintUnlockProtectionEvent(): void {
    let context = GlobalContext.getContext();
    let mCurUsr: number | undefined = AppStorage.get<number>('mCurrentUserId')
    if (!mCurUsr) {
      mCurUsr = DEFAULT_USER_ID;
    }
    log.showInfo(`FINGERPRINT_UNLOCK_PROTECTION_URI_VAR mCurrentUsr:${mCurUsr}`);
    fingerprintUnlockProtectionUriVar =
      `datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_${mCurUsr}?
      Proxy=true&key=${KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK}`;

    data_dataShare.createDataShareHelper(context, fingerprintUnlockProtectionUriVar).then((dataHelper) => {
      this.mSettingsHelper = dataHelper;
      try {
        this.mSettingsHelper.on('dataChange', fingerprintUnlockProtectionUriVar,
          (err: BusinessError<void>, data: void): void => {
            this.updateFingerprintUnlockType();
          });
      } catch (e) {
        log.showInfo(`Can not listen ${KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK} change.`);
      }
    });
  }

  /**
   * register UnlockProtection event
   */
  protected unregisterFingerprintUnlockProtectionEvent(): void {
    try {
      this.mSettingsHelper?.off('dataChange', fingerprintUnlockProtectionUriVar);
    } catch (error) {
      log.showError(`unregisterFingerprintUnlockSwitchEvent ${KEY_FINGERPRINT_UNLOCK_PROTECTION_FOR_SCREEN_LOCK} failed.`);
    }
  }

  public viewModelInit(callback: AsyncCallback<void>, para1: null, para2: null, para3: null): void {
    log.showInfo('FingerprintViewModel ViewModelInit');
    this.registerFingerprintUnlockSwitchEvent(callback, MAX_RETRY_TIMES);
    this.updateFingerprintUnlockType();
    this.registerFingerprintUnlockProtectionEvent();

    this.multimodalInputPowerModule = new MultimodalInputPowerModule(this.powerKeyDownUpCallback);
    this.eventMgr.on(ScreenLockEvent, this.onScreenLockEvent);
    this.computeBaseTrans(0, 4);
    this.changePsdPageFingerprintTransitionEffect(0);
    log.showInfo('FingerprintViewModel ViewModelInit end');
  }

  public initToast(toastPromptViewModel: ToastPromptViewModel) {
    this.toastPromptViewModel = toastPromptViewModel;
  }

  public initCustomPrompt(customizePromptVM: BasePromptViewModel) {
    this.customizePromptVM = customizePromptVM;
    this.customizePromptVM?.setGetPromptCallback((remainTimes: number,
      freezingTime: number,
      isPsdFreezing: boolean): Promise<string> => {
      return this.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
    });
    this.customizePromptVM?.setGetPsdFreezingTimeCallback((): Promise<number> => {
      return this.getFreezingTimeByPsd();
    });
  }

  public setInputViewModel(inputPwdDefaultPromptViewModel: InputPwdDefaultPromptViewModel) {
    this.inputPwdDefaultPromptViewModel = inputPwdDefaultPromptViewModel;
  }

  public setAodProxy(aodProxy: IAodProxy) {
    this.aodProxy = aodProxy;
  }

  public adjustToastPositionY(offset: number): void {
    this.toastPromptViewModel?.adjustPsdToastPositionY(offset);
  }

  public viewModelUnInit(): void {
    log.showInfo('FingerprintViewModel viewModelUnInit');
    this.unregisterFingerprintUnlockSwitchEvent();
    if (!!this.multimodalInputPowerModule) {
      this.multimodalInputPowerModule.unRegisterPowerKeyDown();
      this.multimodalInputPowerModule.unRegisterPowerKeyUp();
      this.multimodalInputPowerModule = null;
    }
    this.unregisterFingerprintUnlockProtectionEvent();
  }

  private prepareClockOneShotAnim() {
    if (slClockOneShotToDesktopService.isClockAodToDesktopAnimAvailable()) {
      slClockOneShotToDesktopService.updateClockAodToDesktopState(true);
    }
  }
}