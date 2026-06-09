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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import {
  FaceUnlockVerifyState,
  AccessibilityUtil,
} from '@ohos/screenlockcommon';
import ScreenLockService, { ScreenLockFaceUnlockAnimationType } from '../refactor/ScreenLockService';
import { ResUtils } from '@ohos/windowscene';
import { InputMethodManager } from '@ohos/launchercommon';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import { osAccount } from '@kit.BasicServicesKit';
import { faceAuthController, FaceAuthController } from '../common/FaceAuthController';
import curves from '@ohos.curves';
import FaceLottieConstants from '@ohos/screenlockcomponent/src/main/ets/common/anim/FaceLottieConstants';
import {
  ScreenLockFaceLottieViewModel
} from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockFaceLottieViewModel';
import lottie from '@ohos/lottie';
import camera from '@ohos.multimedia.camera';
import { AsyncCallback, BusinessError } from '@ohos.base';
import { TipPriorityConstants } from '../common/TipPriority';
import { faceVerifyService } from '../common/FaceVerifyService';
import { CommonStyle } from '../style/CommonStyle';
// import { constant } from '@kit.NearLinkKit';
import Constants from '../common/Constants';
import StyleConfiguration, { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'ScreenLock-FaceVerifyTip';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const BREATH_FRAME: number = 118;
const CAMERA_MUTED_TIMEOUT: number = 3000;
const COMPONENT_ID_USER_ICON = 'ScreenLock-Accounts' + '_Image_userIcon';

@Component
export struct FaceVerifyTip {
  @State faceController: FaceAuthController = faceAuthController;
  @StorageProp('isFaceUnlockSwitchOpen') isFaceUnlockSwitchOpen: boolean = false;
  @StorageProp('faceUnlockVerifyState') @Watch('onFaceUnlockVerifyStateChange') faceUnlockVerifyState: number = 0;
  @State zoomRatio: number = 1.0;
  public onTipChange: (tip: string, showPriority: number | undefined) => void =
    (tip: string, showPriority: number | undefined) => {
    };
  public onCanUnlockWithoutPasswordChange: (canUnlockWithoutPassword: boolean) => void =
    (canUnlockWithoutPassword: boolean) => {
      if (canUnlockWithoutPassword && this.needSlideUnlockAfterFaceRecognized) {
        this.requestFocus('needSlideUnlockAfterFaceRecognized');
        AppStorage.setOrCreate('isPwdVisibleForPC', false);
      }
    };
  private globalShowPriority: number | undefined = undefined;
  @StorageLink('isScreenLockWallpaperBrightOrDark')
  isBrightWallPaper: boolean = true;
  @State needSlideUnlockAfterFaceRecognized: boolean = false;
  @StorageLink('lockStatus') lockStatus: number = 0;
  @StorageLink('isLockAnimationStart')
  isLockAnimationStart: boolean = false;
  private firstUnLockScreen: boolean = ScreenLockService.firstUnLockScreen;
  @Link @Watch('onTipVisibleChange') visible: boolean;
  private isCanvasReady: boolean = false;
  private lastLottieName: string = FaceLottieConstants.PSD_FACE_FAIL;
  private lottieViewModel: ScreenLockFaceLottieViewModel = new ScreenLockFaceLottieViewModel();
  private cameraManager: camera.CameraManager | undefined;
  private onCameraMuteChange: AsyncCallback<boolean> = (err: BusinessError, curMuted: boolean) => {
    if (err) {
      log.showError(`onCameraMuteChange err:, ${err.message}`);
      return;
    }
    log.showInfo(`curMuted：${curMuted}`);
    this.isCameraMuted = curMuted;
  }
  @State @Watch('onIsCameraMutedChange') isCameraMuted: boolean = false;
  @StorageLink('isPinAvailable')
  isPinAvailable: boolean = true;
  @State cameraMutedTip: string = '';
  private cameraMutedCountDownTimerId: number = -1;
  // 只有自动或手动触发过人脸，tip才会显示
  @Link haveTryUnlock: boolean;
  // 记录用户主动尝试行为导致的tip刷新
  @State @Watch('onUserRetryChange') userRetry: boolean = false;
  @StorageLink('mCurrentUserId') mCurrentUserId: number = 0;
  private screenlockStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  private isPCMode: boolean = DeviceHelper.is2In1DevicePcType();

  private requestFocus(reason?: string): void {
    // 人脸识别成功后焦点设置在头像中
    let isSuccess = focusControl.requestFocus(`${COMPONENT_ID_USER_ICON}_${this.mCurrentUserId}`);
    log.showInfo(`requestFocus reason:${reason} isSuccess = ${isSuccess}`);
  }

  @State commonStyle: CommonStyle = CommonStyle.getInstance();

  private onTipVisibleChange(): void {
    if (!this.visible) {
      this.haveTryUnlock = false;
      this.userRetry = false;
    }
  }

  private onIsCameraMutedChange(): void {
    // 当人脸提示语句已经在显示状态时候，摄像头禁用状态变动也视为是用户行为
    if (this.visible) {
      this.haveTryUnlock = true;
      if (this.userRetry !== true) {
        // 由onUserRetryChange去改变tips
        this.userRetry = true;
        return;
      }
    }
    if (this.isCameraMuted) {
      if (this.userRetry) {
        this.cameraMutedTip = ResUtils.getInnerString($r('app.string.camera_muted'));
        this.clearCameraMutedCountDownTimerId();
        this.cameraMutedCountDownTimerId = setTimeout(() => {
          this.clearCameraMutedCountDownTimerId();
          this.cameraMutedTip = '';
          this.userRetry = false;
        }, CAMERA_MUTED_TIMEOUT);
      }
    } else {
      this.clearCameraMutedCountDownTimerId();
      if (this.cameraMutedTip !== '') {
        this.cameraMutedTip = '';
      }
    }
  }

  private onUserRetryChange(): void {
    if (this.isCameraMuted) {
      if (this.userRetry) {
        this.cameraMutedTip = ResUtils.getInnerString($r('app.string.camera_muted'));
        this.clearCameraMutedCountDownTimerId();
        this.cameraMutedCountDownTimerId = setTimeout(() => {
          this.clearCameraMutedCountDownTimerId();
          this.cameraMutedTip = '';
          this.userRetry = false;
        }, CAMERA_MUTED_TIMEOUT);
      }
    } else {
      this.clearCameraMutedCountDownTimerId();
      if (this.cameraMutedTip !== '') {
        this.cameraMutedTip = '';
      }
    }
  }

  private clearCameraMutedCountDownTimerId(): void {
    if (this.cameraMutedCountDownTimerId !== -1) {
      clearTimeout(this.cameraMutedCountDownTimerId);
      this.cameraMutedCountDownTimerId = -1;
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    // 密码框显示隐藏触发的两个FaceVerifyTip之间显示状态共享
    if (this.visible) {
      this.haveTryUnlock = true;
      this.userRetry = true;
    }
    faceVerifyService.setRetryFaceVerifyCallback(() => {
      this.userRetry = true;
      this.haveTryUnlock = true;
    });
    try {
      this.cameraManager = camera?.getCameraManager(getContext());
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`getCameraManager error, code:${errInfo?.code}, message:${errInfo?.message}`);
    }
    this.isCameraMuted = this.cameraManager?.isCameraMuted() || false;
    ScreenLockService.setCameraMuted(this.isCameraMuted);
    this.cameraManager?.on('cameraMute', this.onCameraMuteChange);
    this.needSlideUnlockAfterFaceRecognized = ScreenLockService.queryFaceRecognizeSlideUnlockConf();
    if (!this.isFaceVerifyDisable() && !this.isCameraMuted && !this.isAutoFaceVerifyDisable()) {
      this.haveTryUnlock = true;
      // 电源唤醒会触发自动人脸解锁
    }
    if (this.isFaceVerifySuccess()) {
      this.refreshFaceVerifyTip();
    }
    if (!this.isLockAnimationStart) {
      ScreenLockService.setOnFaceAuthSuccessAnimation((animationType: ScreenLockFaceUnlockAnimationType) => {
        if (animationType === ScreenLockFaceUnlockAnimationType.SECONDARY_INTERFACE_DISAPPEAR_ANIMATION) {
          this.onAuthSuccess(osAccount.AuthType.FACE);
        } else {
          this.noPwdUnlockAnimation(osAccount.AuthType.FACE);
        }
      });
    }
  }

  private onAuthSuccess(authType: osAccount.AuthType): void {
    this.onCanUnlockWithoutPasswordChange(true);
  }

  private retryFaceVerify(): void {
    if (this.isFaceVerifyDisable()) {
      return;
    }
    faceVerifyService.retryFaceVerify();
  }

  private noPwdUnlockAnimation(authType?: osAccount.AuthType): void {
    log.showDebug('noPwdUnlockAnimation');
    InputMethodManager.getInstance().stopInputSession();
    ScreenLockService.doUnLockAnimation(() => {
      ScreenLockService.unlockScreen(false);
      ScreenLockService.notifyUnlockTransition(authType);
    });
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.cameraManager?.off('cameraMute', this.onCameraMuteChange);
    faceVerifyService.setRetryFaceVerifyCallback(undefined);
    this.cameraManager = undefined;
    this.clearCameraMutedCountDownTimerId();
    this.lottieViewModel.destroyPsdLottie();
  }

  private onFaceUnlockVerifyStateChange(): void {
    if (!faceVerifyService.isFaceUnlockSupportedBySystem()) {
      return;
    }

    if (this.isFaceUnlockVerifying() && faceVerifyService.isFaceVerifyEnable()) {
      this.haveTryUnlock = true;
      this.userRetry = true;
    }
    if (this.isFaceUnlockSwitchOpen && this.isFaceVerifyLock()) {
      this.faceController.refreshAuthRetryTip();
      if (AccessibilityUtil.isAccessibilityMode()) {
        this.faceController.refreshDisableFaceAccessibility();
      }
    }
    if (this.isFaceVerifySuccess()) {
      this.onCanUnlockWithoutPasswordChange(true);
    } else {
      this.onCanUnlockWithoutPasswordChange(false);
    }
    if (this.isCanvasReady) {
      this.loadFaceRecognizedAnimation();
    }
  }

  private loadFaceRecognizedAnimation(): void {
    log.showInfo('loadFaceRecognizedAnimation');
    if (this.isFaceUnlockVerifying()) {
      this.playLottie(FaceLottieConstants.PSD_FACE_BREATH);
    } else if (this.isVerifyFailedOrNotRecognized()) {
      this.loadUnlockLottieAnimation(FaceLottieConstants.PSD_FACE_FAIL);
    } else if (this.isFaceVerifySuccess()) {
      this.loadUnlockLottieAnimation(FaceLottieConstants.PSD_FACE_SUCCESS);
    }
  }

  private loadUnlockLottieAnimation(lottieName: string): void {
    log.showInfo('loadUnlockLottieAnimation');
    Trace.start(Trace.CORE_METHOD_PSD_FACE_LOTTIE_DETECTED);
    this.playLottie(FaceLottieConstants.PSD_FACE_DETECTED);
    lottie.destroy(FaceLottieConstants.PSD_FACE_BREATH);
    this.lottieViewModel.loadBreathLottie();
    this.lottieViewModel.animationDetected?.addEventListener('complete', (args: Object): void => {
      Trace.end(Trace.CORE_METHOD_PSD_FACE_LOTTIE_DETECTED);
      this.playLottie(lottieName);
    });
  }

  private playLottie(lottieName: string): void {
    if (this.lastLottieName === FaceLottieConstants.PSD_FACE_BREATH) {
      this.lottieViewModel.animationBreath?.goToAndStop(BREATH_FRAME, true);
      lottie.play(lottieName);
      this.lastLottieName = lottieName;
    } else {
      this.stopLottie(this.lastLottieName);
      lottie.play(lottieName);
      this.lastLottieName = lottieName;
    }
  }

  private stopLottie(lottieName: string): void {
    lottie.stop(lottieName);
  }

  build() {
    Row() {
      if (this.isFaceVerifyDisable() && !this.isPCMode) {

      } else if (!this.isPinAvailable) {
        this.certificateText();
      } else if (!this.haveTryUnlock) {
      } else if (this.isFaceVerifySuccess()) {
        this.faceVerifyBuilder();
      } else if (this.isCameraMuted) {
        this.cameraDisableText();
      } else {
        this.faceVerifyBuilder();
      }
    }
    .id('FaceVerifyTip')
    .focusable(false)
    .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
    .margin({ top: '12vp' })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      log.showDebug('touch faceUnlock tip icon.');
      this.retryFaceVerify();
    })
    .visibility(this.visible ? Visibility.Visible : Visibility.None)
  }

  @Builder
  faceVerifyBuilder() {
    this.faceVerifyCanvas();
    Blank().width(8).visibility(Visibility.Hidden);
    this.faceVerifyText();
  }

  @Builder
  faceVerifyCanvas() {
    Canvas(this.lottieViewModel.psdCanvasRenderingContext)
      .height($r('app.float.face_image_tip_size'))
      .width($r('app.float.face_image_tip_size'))
      .align(Alignment.Center)
      .renderGroup(true)
      .id(`${TAG}_Face_view`)
      .onReady(() => {
        log.showInfo('Canvas onReady.');
        this.isCanvasReady = true;
        this.lottieViewModel.setBreathLoadedChanged((isLoad: boolean) => {
          if (isLoad) {
            this.loadFaceRecognizedAnimation();
          }
        });
        this.lottieViewModel.loadAllPsdLottieAnimation();
      })
      .onAppear(() => {
        log.showInfo('Canvas onAppear.');
        this.startAnimationWhenVerifying();
      })
      .onDisAppear(() => {
        log.showInfo('Canvas onDisAppear.');
        this.isCanvasReady = false;
        this.stopLottie(this.lastLottieName);
        this.lottieViewModel.destroyPsdLottie();
      });
  }

  @Builder
  faceVerifyText() {
    Text(this.refreshFaceVerifyTip())
      .focusable(false)
      .font({
        family: Constants.TOAST_FONT_FAMILY,
        weight: FontWeight.Bold,
        size: this.screenlockStyle.toastTextFontSize
      })
      .fontColor(this.isBrightWallPaper ? $r('app.color.screen_lock_toast_color_lg') :
      $r('app.color.screen_lock_toast_color_dk'))
      .foregroundBrightness(this.isBrightWallPaper ? CommonStyle.toastDarkBrightness :
      CommonStyle.toastLightBrightness)
      .textAlign(TextAlign.Center)
      .maxLines(Constants.TOAST_MAXLINES)
  }

  @Builder
  cameraDisableText() {
    this.faceVerifyText()
  }

  @Builder
  certificateText() {
    this.faceVerifyText()
  }

  private startAnimationWhenVerifying(): void {
    if (this.isFaceUnlockVerifying()) {
      animateTo({
        curve: curves.initCurve(Curve.Sharp),
        duration: 500,
        iterations: 20,
        playMode: PlayMode.Alternate,
        onFinish: () => {
          this.zoomRatio = 1.0;
        }
      }, () => {
        this.zoomRatio = 1.18;
      })
    }
  }

  private isFaceUnlockVerifying(): boolean {
    return this.faceUnlockVerifyState == FaceUnlockVerifyState.VERIFYING;
  }

  private refreshFaceVerifyTip(): string {
    let text: string = '';
    this.globalShowPriority = undefined;
    if (!this.isFaceUnlockSwitchOpen) {
    } else if (!this.haveTryUnlock) {
    } else if (this.isFaceVerifySuccess()) {
      text = this.getFaceVerifyStateTip();
    } else if (this.isCameraMuted) {
      text = this.getCameraDisableTip();
    } else {
      text = this.getFaceVerifyStateTip();
    }
    setTimeout(() => {
      this.userRetry = false;
      this.onTipChange(text, this.globalShowPriority);
    }, 0);
    return text;
  }

  private getFaceVerifyStateTip(): string {
    switch (this.faceUnlockVerifyState) {
      case FaceUnlockVerifyState.READY:
        if (AccessibilityUtil.isAccessibilityMode()) {
          AccessibilityUtil.sendAccessibility('');
        }
        return '';
      case FaceUnlockVerifyState.VERIFYING: // fall-through
        let verifyingTip = ResUtils.getInnerString($r('app.string.face_unlock_verifying'));
        if (AccessibilityUtil.isAccessibilityMode()) {
          AccessibilityUtil.sendAccessibility(verifyingTip);
        }
        return verifyingTip;
      case FaceUnlockVerifyState.EXPIRED:
        let expireTip = ResUtils.getInnerString($r('app.string.psd_has_expired'));
        if (AppStorage.get('isPinAvailable') as boolean === true) {
          expireTip = '';
        }
        if (AccessibilityUtil.isAccessibilityMode()) {
          AccessibilityUtil.sendAccessibility(expireTip);
        }
        return expireTip;
      case FaceUnlockVerifyState.SUCCESS:
        let successTip = '';
        if (this.needSlideUnlockAfterFaceRecognized) {
          successTip = ResUtils.getInnerString($r('app.string.face_unlock_success_to_manual_login_pc'));
        } else {
          successTip = ResUtils.getInnerString($r('app.string.face_unlock_verifying'));
        }
        if (AccessibilityUtil.isAccessibilityMode()) {
          AccessibilityUtil.sendAccessibility(successTip);
        }
        return successTip;
      case FaceUnlockVerifyState.LOCKED:
        return this.getPwdTipWhenFaceLocked();
      case FaceUnlockVerifyState.FAILED: // fall-through
      case FaceUnlockVerifyState.NOT_RECOGNIZED: // fall-through
      default:
        if (AccessibilityUtil.isAccessibilityMode()) {
          AccessibilityUtil.sendAccessibility(ResUtils.getInnerString($r('app.string.face_not_recognized_tip_pc')));
        }
        return ResUtils.getInnerString($r('app.string.face_not_recognized_tip_pc'));
    }
  }

  private getCameraDisableTip(): string {
    return this.cameraMutedTip;
  }

  private getPwdTipWhenFaceLocked(): string {
    if (this.userRetry) {
      this.globalShowPriority = TipPriorityConstants.TIP_PRIORITY_FACE_LOCKED_TIMEOUT_RESHOW;
    } else {
      this.globalShowPriority = TipPriorityConstants.TIP_PRIORITY_FACE_LOCKED_TIMEOUT;
    }
    return this.faceController.authRetryTip;
  }

  private isFaceVerifyLock(): boolean {
    return this.faceUnlockVerifyState === FaceUnlockVerifyState.LOCKED;
  }

  private isFaceVerifySuccess(): boolean {
    return this.faceUnlockVerifyState === FaceUnlockVerifyState.SUCCESS;
  }

  private isFaceVerifyFailed(): boolean {
    return this.faceUnlockVerifyState === FaceUnlockVerifyState.FAILED;
  }

  private isFaceVerifyDisable(): boolean {
    return !this.isFaceUnlockSwitchOpen || this.firstUnLockScreen || !faceVerifyService.isFaceUnlockSupportedBySystem();
  }

  private isAutoFaceVerifyDisable(): boolean {
    return !(AppStorage.get('isPowerInterceptLockScreen') && !this.haveTryUnlock);
  }

  private isVerifyFailedOrNotRecognized(): boolean {
    return this.faceUnlockVerifyState === FaceUnlockVerifyState.FAILED ||
      this.faceUnlockVerifyState === FaceUnlockVerifyState.NOT_RECOGNIZED;
  }
}