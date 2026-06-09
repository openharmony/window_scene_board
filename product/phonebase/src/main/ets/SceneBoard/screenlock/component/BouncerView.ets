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
import curves from '@ohos.curves';
import display from '@ohos.display';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { AnimateToScheduleUtils, LogDomain, LogHelper, Trace, } from '@ohos/basicutils';
import { AnimationType, themeWallpaperAniMgr } from '@ohos/themeservice';
import { RTLUtil } from '@ohos/componenthelper';
import { ResUtils, SCBSceneSessionManager, SCBScreenProperty, SCBSystemSceneSession, } from '@ohos/windowscene';
import { PasswordManager, PasswordChangeListener } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import {
  DeviceHelper,
  EvtBus,
  HiDfxEventUtil,
  HiSysEventUtil,
  StatusBarContentEvent,
  ViewManagerPolicy,
  ViewType,
  WallpaperData,
  WallpaperManager,
} from '@ohos/frameworkwrapper';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  CommonConstants,
  DisplayUtils,
  FingerprintAcquireCode,
  GlobalStatusCache,
  KeyGuardPage,
  KeyguardStatusService,
  LockUnlockListener,
  PerformanceMonitorUtil,
  PowerUtils,
  ScreenLockUnlockService,
  SlStorageKey,
  StatusCacheConst,
  VerifyDataManager,
  VerifyInfo
} from '@ohos/screenlockcommon';
import { AuthSubType, AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { VerifyTipsUtils } from '@ohos/screenlockcomponent/src/main/ets/tips/utils/VerifyTipsUtils';
import { RtlCalculateUtils } from '@ohos/screenlockcomponent/src/main/ets/utils/RtlCalculateUtils';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import KeyBoardLayoutConstants, {
  DeviceClassification,
  DevicesGrids,
  PassWordLayout,
  PinLayout
} from '@ohos/screenlockcomponent/src/main/ets/common/LayoutConstants';
import {
  InputPwdDefaultPromptViewModel
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/InputPwdDefaultPromptViewModel';
import {
  PromptShowPos,
  ToastPromptViewModel
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/ToastPromptViewModel';
import PasswordConstants from '@ohos/screenlockcomponent/src/main/ets/password/common/PasswordConstants';
import { PasswordLayoutConfig } from '@ohos/screenlockcomponent/src/main/ets/password/common/PasswordLayoutConfig'
import FoldablePSD from '@ohos/screenlockcomponent/src/main/ets/password/view/FoldablePSD';
import {
  BouncerStateType,
  BouncerStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm';
import {
  CoreStateType,
  CoreStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { VerifyResultInfo } from '@ohos/screenlockcomponent/src/main/ets/tips/service/VerifyTipsService';
import { StatusBarType } from '@ohos/systemuicommon';
import { SCBDefaultZIndex } from '../../scenemanager/SCBScreen';
import { BouncerVm } from '../viewmodel/BouncerVm';
import { HiKGReportTimeout, TIMEOUT_PARAMS } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { slStateHelper } from '../model/helper/SlStateHelper';

const TAG = 'BouncerView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const PAD_LANDSCAPE_DEFAULT_ROTATION = 0;
const PAD_LANDSCAPE_REVERSE_ROTATION = 2;
const PAD_PORTRAIT_DEFAULT_ROTATION = 1;
const PAD_PORTRAIT_REVERSE_ROTATION = 3;
const SESSION_EXP_INPUT_FLAG_DEFAULT = 0;
const SESSION_EXP_INPUT_FLAG_YES = 4;

const COMPONENT_ID_SCREEN_LOCK_HOME = TAG + '_Screen_Lock_Home';
const I_CURVE: ICurve = curves.cubicBezierCurve(0.40, 0, 0.40, 1);
const GESTURE_NAVIGATION_ABOVE_INPUT_METHOD_KEYGUARD = 4050;

/**
 * 密码页根组件
 */
@Component
export struct BouncerView {
  private persistentId: number = 0;
  private bouncerVm?: BouncerVm;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();

  @Link screenProp: SCBScreenProperty;
  @State isBouncerVisible: boolean = false;
  @State isPwdCheckVisible: boolean = false;
  @State psdViewScale: number = PasswordConstants.DEFAULT_SCALE_PWD;
  @State psdViewOpacity: number = PasswordConstants.DEFAULT_OPACITY_PWD;
  @State passwordType: string = CommonConstants.PIN_TYPE_NONE;
  @State wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
  @State keyboardPosition: number | undefined = AppStorage.get(SlStorageKey.KEYBOARD_POSITION);
  @State gestureNavigationAboveInputMethodKeyguardZIndex: number = GESTURE_NAVIGATION_ABOVE_INPUT_METHOD_KEYGUARD;
  @State slFoldablePSDAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlFoldablePSDAnimCtrl();

  @StorageProp('folderStatus') @Watch('changePsdTopMargin') folderStatus: number = DeviceState.FOLDED_STATE;
  @StorageProp('isPortrait') @Watch('changePsdTopMargin') isPortrait: boolean = true;
  @StorageProp(SlStorageKey.IS_IN_SPECIAL_Z_INDEX) @Watch('onIsInSpecialZIndex') isInSpecialZIndex: boolean = false;

  @Provide toastPromptViewModel: ToastPromptViewModel = new ToastPromptViewModel();
  @Provide inputPwdDefaultPromptViewModel: InputPwdDefaultPromptViewModel = new InputPwdDefaultPromptViewModel();
  @Provide displayHeight: number = px2vp(this.screenProp.height);
  @Provide displayWidth: number = px2vp(this.screenProp.width);
  @Provide psdLayoutData: PassWordLayout =
    KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_NO_FINGER) as PassWordLayout;
  @Provide deviceGridData: DevicesGrids =
    KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_NO_FINGER) as DevicesGrids;
  @Provide pinLayoutData: PinLayout =
    KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_NO_FINGER) as PinLayout;
  @Provide isDeviceLandscape: boolean = true;
  @Provide passwordLayoutConfig : PasswordLayoutConfig = new PasswordLayoutConfig();
  @Consume @Watch('refreshPasswordLayoutConfig') isSmallFoldOuterScreen: boolean = false;
  @State isResetPassWordVisible: boolean = false;
  @Provide pwdBackEffect: TransitionEffect = TransitionEffect.opacity(0)
    .combine(TransitionEffect.scale({
      x: Constants.MAX_ZOOM_RATIO_PWD,
      y: Constants.MAX_ZOOM_RATIO_PWD
    }))
    .animation({
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, Constants.PSD_STIFFNESS, Constants.PSD_DAMPING)
    })
  private pwdAuthEffect: TransitionEffect = TransitionEffect.opacity(0)
    .combine(TransitionEffect.scale({
      x: PasswordConstants.MIN_ZOOM_RATIO_PWD,
      y: PasswordConstants.MIN_ZOOM_RATIO_PWD
    }))
    .animation({
      curve: curves.interpolatingSpring(0, 0,
        PasswordConstants.PSD_ELEMENT_STIFFNESS, PasswordConstants.PSD_ELEMENT_DAMPING)
    })

  @Provide pwdTransitionEffect: TransitionEffect =
    TransitionEffect.asymmetric(TransitionEffect.IDENTITY, this.pwdAuthEffect);

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start.');
    log.showInfo(`px2vp(this.screenProp.height): ${px2vp(this.screenProp.height)}`);
    AppStorage.setOrCreate<boolean>(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false);
    Trace.start(Trace.CORE_METHOD_SCREEN_LOCK_INIT);
    this.bouncerVm = new BouncerVm(this.persistentId);
    this.bouncerVm.init();
    this.initObserverDisplayState();
    this.initObserverVerifyState();
    this.initObserverBouncerFsm();
    this.initPSDLayoutConfig();
    let info = StatusBarContentEvent.create(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, '#FFFFFF')
    EvtBus.post(StatusBarContentEvent, info);
    RTLUtil.registerRtlChangeCallback(this.updateNumKeyBoardStorage());
    PasswordManager.getInstance().registerObserver(this.passwordChangeListener);
    Trace.end(Trace.CORE_METHOD_SCREEN_LOCK_INIT);
    log.showInfo('aboutToAppear end.');
  }

  private passwordChangeListener: PasswordChangeListener = {
    onDisableChange: (isDisableInput: boolean): void => {
      if (isDisableInput && VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).isStateLocked &&
        !this.isResetPassWordVisible) {
        if (this.bouncerVm?.isNeedShowResetPinView()) {
          this.gotoMainPage(() => {
            this.isResetPassWordVisible = true;
          });
        }
      }
    }
  };

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.bouncerVm?.release();
    this.slObserverProxy.release();
    RTLUtil.unregisterRtlChangeCallback(this.updateNumKeyBoardStorage());
    PasswordManager.getInstance().unRegisterObserver(this.passwordChangeListener);
  }

  private updateNumKeyBoardStorage(): Function {
    return () => {
      AppStorage.setOrCreate('numKeyboard', RtlCalculateUtils.getNumberKeyBoard());
    };
  }

  private initObserverDisplayState(): void {
    this.slObserverProxy.observerDisplayState({
      onOrientationChange: (rotation: number): void => {
        this.onDisplayRotationChanged(rotation);
      },
      onScreenSizeChange: (width: number, height: number): void => {
        this.displayWidth = px2vp(width);
        this.displayHeight = px2vp(height);
      }
    });
  }

  private initPSDLayoutConfig(): void {
    sFontScaleUtil.init();
    if (this.isSmallFoldOuterScreen) {
      this.passwordLayoutConfig.switchToOuterConfig();
    } else {
      this.passwordLayoutConfig.switchToDefaultConfig();
    }
  }

  private initObserverVerifyState(): void {
    this.slObserverProxy.getVerifyInfo(AuthType.PIN, (verifyInfo: VerifyInfo): void => {
      this.passwordType = AuthSubType[verifyInfo.authSubType] ?? CommonConstants.PIN_TYPE_NONE;
      AppStorage.setOrCreate('passwordType', this.passwordType);
      if (this.passwordType === CommonConstants.PIN_TYPE_NONE) {
        // 底层故障恢复无密码后退密码界面
        this.noPwdRecovery();
      }
      this.inputPwdDefaultPromptViewModel.setPinType(this.passwordType);
      this.changePsdTopMargin();
      log.showInfo(`passwordType to ${this.passwordType}`);
    });
    this.slObserverProxy.getVerifyInfo(AuthType.FINGERPRINT, (verifyInfo: VerifyInfo): void => {
      if (!verifyInfo.isSupportUnlock) {
        return;
      }
      if (verifyInfo.isStateLocked) {
        this.inputPwdDefaultPromptViewModel?.changePSDDefaultPrompt(verifyInfo.freezingTime,
          $r('app.string.fp_disable_enter_psd'), () => {
            log.showInfo('changePSDDefaultPrompt success.');
            this.inputPwdDefaultPromptViewModel?.resetDefaultPrompt();
          });
      } else {
        log.showInfo(`restore fingerprint`);
        this.inputPwdDefaultPromptViewModel?.resetDefaultPrompt();
      }
    });
    this.slObserverProxy.getVerifyInfo(AuthType.FACE, (verifyInfo: VerifyInfo): void => {
      log.showInfo(`face isSupportUnlock: ${verifyInfo.isSupportUnlock}.`);
      this.toastPromptViewModel.adjustPsdToastPositionY(verifyInfo.isSupportUnlock ? -48 : 48);
    });
    this.slObserverProxy.observerVerifyTips({
      onVerifyingTips: (authType: AuthType, acquire: number): void => {
        log.showInfo(`onVerifyingTips authType ${authType}, acquire:${acquire}`);
        switch (authType) {
          case AuthType.FINGERPRINT:
            if (acquire === FingerprintAcquireCode.FINGERPRINT_TIP_TOO_FAST) {
              this.toastPromptViewModel?.showToastPrompt(ResUtils.getInnerString($r('app.string.fp_hold_finger')),
                PromptShowPos.PSD);
            }
            break;
          default:
            break;
        }
      },
      onVerifyResultTips: (authType: AuthType, verifyResultInfo: VerifyResultInfo): void => {
        log.showInfo(`onVerifyResultTips authType ${authType}, verifyResultInfo:${verifyResultInfo.toString()}`);
        switch (authType) {
          case AuthType.FINGERPRINT:
            VerifyTipsUtils.getFingerprintPromptFromVerifyResult(verifyResultInfo).then(
              (propStr: string) => {
                this.toastPromptViewModel?.showToastPrompt(propStr, PromptShowPos.PSD);
              });
            if (verifyResultInfo.remainTimes <= 0 && verifyResultInfo.freezingTime > 0) {
              this.inputPwdDefaultPromptViewModel?.changePSDDefaultPrompt(verifyResultInfo.freezingTime,
                $r('app.string.fp_disable_enter_psd'), () => {
                  log.showInfo('changePSDDefaultPrompt success.');
                  this.inputPwdDefaultPromptViewModel?.resetDefaultPrompt();
                });
            }
            break;
          default:
            break;
        }
      }
    });
  }

  private initObserverBouncerFsm(): void {
    this.slObserverProxy.getBouncerFsmState(this.persistentId, (oldState: BouncerStateType,
      newState: BouncerStateType): void => {
      if (!this.isPwdCheckVisible && BouncerStateTypeUtils.isInPwdLockState(newState)) {
        this.isResetPassWordVisible = this.bouncerVm?.isNeedShowResetPinView() ?? false;
      }
      this.isPwdCheckVisible = BouncerStateTypeUtils.isInPwdLockState(newState);
      if (!BouncerStateTypeUtils.isInBouncerState(oldState) && BouncerStateTypeUtils.isInBouncerState(newState)) {
        KeyguardStatusService.switchToPage(KeyGuardPage.PWD_PAGE);
        AppStorage.setOrCreate<boolean>(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false);
        if (KeyguardStatusService.isSpecialMode()) {
          GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_SPECIAL_MODE_BOUNCER_FOCUS_KEY, true);
        }
        this.bouncerVm?.setExpandInputFlag(SESSION_EXP_INPUT_FLAG_YES);
        // 进入密码页
        HiDfxEventUtil.reportSwitchToPassword(this.passwordType, 0);
        this.psdViewScale = PasswordConstants.DEFAULT_SCALE_PWD;
        this.psdViewOpacity = PasswordConstants.DEFAULT_OPACITY_PWD;
        this.isBouncerVisible = true;
        this.keyboardPosition = AppStorage.get(SlStorageKey.KEYBOARD_POSITION);
        this.gestureNavigationAboveInputMethodKeyguardZIndex = GESTURE_NAVIGATION_ABOVE_INPUT_METHOD_KEYGUARD;
        if (DeviceHelper.isPadOr2in1PcType()) {
          log.showInfo('show bouncer, stop dynamic wallpaper');
          themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
            animationType: AnimationType.WALLPAPER_STOP_PAD
          });
        }
        this.changePsdTopMargin();
      } else if (BouncerStateTypeUtils.isInBouncerState(oldState) &&
        !BouncerStateTypeUtils.isInBouncerState(newState)) {
        this.bouncerVm?.setExpandInputFlag(SESSION_EXP_INPUT_FLAG_DEFAULT);
        // 退出密码页
        GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_SPECIAL_MODE_BOUNCER_FOCUS_KEY, false);
        if (this.keyboardPosition !== undefined) {
          AppStorage.delete(SlStorageKey.KEYBOARD_POSITION);
        }
        const currentCoreStateType: CoreStateType =
          ScreenLockFsmProxy.getInstance(this.persistentId).coreFsm.currentStateType;
        if (BouncerStateTypeUtils.isInMainPageState(newState) &&
          !CoreStateTypeUtils.isInFakeAodMainPage(currentCoreStateType)) {
          // 返回主页
          this.pwdTransitionEffect = TransitionEffect.asymmetric(TransitionEffect.IDENTITY, this.pwdAuthEffect);
          this.gotoMainPage();
        } else if (BouncerStateTypeUtils.isInUnLockState(newState)) {
          // 从密码页解锁
          this.goToUnlock();
        } else {
          this.isBouncerVisible = false;
        }
      }
    });
  }

  private gotoMainPage(onFinish?: () => void): void {
    log.showInfo('gotoMainPage');
    AppStorage.setOrCreate<boolean>(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, true);
    animateTo({
      duration: 150,
      delay: PasswordConstants.PSD_BACK_DELAY,
      curve: Curve.Smooth,
      onFinish: onFinish ?? (() => {
        if (!CoreStateTypeUtils.isInBouncePage(this.slObserverProxy.getCoreFsmState(this.persistentId))) {
          this.isBouncerVisible = false;
          this.keyboardPosition = Constants.NO_TOUCH_OR_SCREEN_MIDDLE;
        }
        this.psdViewOpacity = PasswordConstants.DEFAULT_OPACITY_PWD
      })
    }, () => {
      this.psdViewOpacity = PasswordConstants.MIN_OPACITY_PWD;
    })
    animateTo({
      curve: curves.interpolatingSpring(0, 0,
        PasswordConstants.PSD_ELEMENT_STIFFNESS, PasswordConstants.PSD_ELEMENT_DAMPING),
      onFinish: () => {
        this.psdViewScale = PasswordConstants.DEFAULT_SCALE_PWD;
      }
    }, () => {
      this.psdViewScale = PasswordConstants.MIN_ZOOM_RATIO_PWD;
    });
  }

  private goToUnlock(): void {
    log.showInfo('goToUnlock');
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.UNLOCK_START);
    this.pwdTransitionEffect = TransitionEffect.asymmetric(TransitionEffect.IDENTITY, this.pwdAuthEffect);
    PerformanceMonitorUtil.setFrameRateMoStart(osAccount.AuthType.PIN);
    HiKGReportTimeout.getInstance().logTimeout(TIMEOUT_PARAMS.UNLOCK_FROM_BOUNCER_ANI.NAME,
      TIMEOUT_PARAMS.UNLOCK_FROM_BOUNCER_ANI.TIME_OUT);
    // 立即执行密码盘隐藏，响应时延
    animateToImmediately({
      curve: I_CURVE,
      duration: Constants.UNLOCK_ANIMATION_DURATION,
      onFinish: () => {
      }
    }, () => {
      this.isBouncerVisible = false;
    })
    animateTo({
      curve: I_CURVE,
      duration: Constants.UNLOCK_ANIMATION_DURATION,
      onFinish: () => {
        log.showInfo('ExitKeyGuard onAuthSuccess end');
        HiKGReportTimeout.getInstance().rollbackTimeout(TIMEOUT_PARAMS.UNLOCK_FROM_BOUNCER_ANI.NAME);
        PerformanceMonitorUtil.setFrameRateMoEnd(osAccount.AuthType.PIN);
        Trace.end(Trace.CORE_METHOD_EXIT_KEYGUARD);
        HiSysEventUtil.reportExitKeyguard();
        this.pwdTransitionEffect = TransitionEffect.asymmetric(TransitionEffect.IDENTITY, this.pwdBackEffect);
        this.bouncerVm?.hideRootView();
      }
    }, () => {
      AppStorage.setOrCreate('blurRadius', 0);
    })
    this.wallpaperData.wallpaperScale = Constants.DEFAULT_SCALE;

    let preUnlockCallback: LockUnlockListener = {
      onPreUnlock: (): void => {
        ScreenLockUnlockService.getInstance().delayHideRootView();
        this.slObserverProxy.releaseCallback(preUnlockCallback);
      }
    };
    this.slObserverProxy.observerPreUnlock(preUnlockCallback);
  }

  private refreshPasswordLayoutConfig() : void {
    this.changePsdTopMargin();
    sFontScaleUtil.setScreenChangeKeyBoardLayout(this.isSmallFoldOuterScreen);
    if (this.isSmallFoldOuterScreen) {
      this.passwordLayoutConfig.switchToOuterConfig();
    } else {
      this.passwordLayoutConfig.switchToDefaultConfig();
    }
  }

  private onDisplayRotationChanged(rotation: number): void {
    if (rotation === PAD_LANDSCAPE_DEFAULT_ROTATION || rotation === PAD_LANDSCAPE_REVERSE_ROTATION) {
      this.isDeviceLandscape = false;
    } else if (rotation === PAD_PORTRAIT_DEFAULT_ROTATION || rotation === PAD_PORTRAIT_REVERSE_ROTATION) {
      this.isDeviceLandscape = true;
    }
    if (DeviceHelper.isPadOr2in1PcType() ||
      (DeviceHelper.isFoldButNotSmallFoldProduct() && this.folderStatus === DeviceState.EXPAND_STATE)) {
      this.changePsdTopMargin();
    }
  }

  private onIsInSpecialZIndex(): void {
    if (this.isInSpecialZIndex) {
      this.gestureNavigationAboveInputMethodKeyguardZIndex = SCBDefaultZIndex.GESTURE_NAVIGATION;
      ViewManagerPolicy.setZIndex(ViewType.KEYGUARD, SCBDefaultZIndex.SCREEN_LOCK_SPECIAL_BOUNCER);
      log.showInfo(`setWallpaperZindex ${SCBDefaultZIndex.SCREEN_LOCK_SPECIAL_BOUNCER - 1}`);
      ViewManagerPolicy.setZIndex(ViewType.WALLPAPER, SCBDefaultZIndex.SCREEN_LOCK_SPECIAL_BOUNCER - 1);
      SCBSceneSessionManager.getInstance().requestFocus(this.persistentId, true);
    } else {
      this.gestureNavigationAboveInputMethodKeyguardZIndex = GESTURE_NAVIGATION_ABOVE_INPUT_METHOD_KEYGUARD;
    }
  }

  private changePsdTopMargin(): void {
    // 是pad 并且是横屏
    if (DeviceHelper.isPadOr2in1PcType() && this.isDeviceLandscape) {
      this.deviceGridData =
        KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_PAD_LANDSCAPE) as DevicesGrids;
      this.psdLayoutData =
        KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_PAD_LANDSCAPE) as PassWordLayout;
      this.pinLayoutData = KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_PAD_LANDSCAPE) as PinLayout;
      log.showInfo(`changePsdTopMargin pad landscape ${this.psdLayoutData.index}`);
      return;
    }
    // 是pad 并且是竖屏
    if (DeviceHelper.isPadOr2in1PcType() && !this.isDeviceLandscape) {
      this.deviceGridData =
        KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_PAD_PORTRAIT) as DevicesGrids;
      this.psdLayoutData =
        KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_PAD_PORTRAIT) as PassWordLayout;
      this.pinLayoutData = KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_PAD_PORTRAIT) as PinLayout;
      log.showInfo(`changePsdTopMargin pad portrait  ${this.psdLayoutData.index}`);
      return;
    }
    // 超大屏G态
    if (DeviceHelper.isUltraScreenProduct() && DisplayUtils.isUltraScreenGStatus()) {
      if (!this.isDeviceLandscape) {
        this.deviceGridData =
          KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_FOLD_EXPAND) as DevicesGrids;
        this.pinLayoutData = KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_FOLD_EXPAND) as PinLayout;
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_ULTRA_SCREEN_G_PORTRAIT) as PassWordLayout;
      } else {
        this.deviceGridData =
          KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_ULTRA_SCREEN_G_HORIZONTAL) as DevicesGrids;
        this.pinLayoutData =
          KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL) as PinLayout;
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_ULTRA_SCREEN_G_HORIZONTAL) as PassWordLayout;
      }
      log.showInfo(`changePsdTopMargin three fold G state ${this.psdLayoutData.index}`);
      return;
    }
    // 是折叠屏 并且全屏状态
    if (DeviceHelper.isFoldButNotSmallFoldProduct() && this.folderStatus === DeviceState.EXPAND_STATE) {
      this.deviceGridData =
        KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_FOLD_EXPAND) as DevicesGrids;
      if (!this.isDeviceLandscape) {
        this.pinLayoutData = KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_FOLD_EXPAND) as PinLayout;
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_FOLD_EXPAND) as PassWordLayout;
      } else {
        this.pinLayoutData =
          KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL) as PinLayout;
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL) as PassWordLayout;
      }
      log.showInfo(`changePsdTopMargin fold expand  ${this.psdLayoutData.index}`);
      return;
    }
    // 屏下指纹手机
    let fingerprintVerifyInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT);
    if (fingerprintVerifyInfo.hasUnderFingerprint) {
      this.deviceGridData =
        KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_NO_FINGER) as DevicesGrids;
      this.pinLayoutData = KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_NO_FINGER) as PinLayout;
      if (!fingerprintVerifyInfo.isSupportUnlock || fingerprintVerifyInfo.isNeedStrongAuth) {
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_NO_FINGER) as PassWordLayout;
        log.showInfo(`changePsdTopMargin UnderScreenFingerprint fingerPrint not support ${this.psdLayoutData.index}`);
        return;
      }
      if (fingerprintVerifyInfo.hasLowFingerprint) {
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_LOW_FINGER_PRINT_PHONE) as PassWordLayout;
        log.showInfo(`changePsdTopMargin UnderScreenFingerprint low fingerPrint ${this.psdLayoutData.index}`);
        return;
      }
      if (fingerprintVerifyInfo.hasHighFingerprint) {
        this.psdLayoutData =
          KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_HEIGHT_FINGER_PRINT_PHONE) as PassWordLayout;
        log.showInfo(`changePsdTopMargin UnderScreenFingerprint height fingerPrint  ${this.psdLayoutData.index}`);
        return;
      }
    }

    // 大屏幕机折叠态或其他
    this.pinLayoutData = KeyBoardLayoutConstants.PIN_LAYOUT.get(DeviceClassification.PSD_NO_FINGER) as PinLayout;
    this.deviceGridData =
      KeyBoardLayoutConstants.DEVICES_GRIDS.get(DeviceClassification.PSD_NO_FINGER) as DevicesGrids;
    this.psdLayoutData = KeyBoardLayoutConstants.PSD_LAYOUT.get(DeviceClassification.PSD_NO_FINGER) as PassWordLayout;
    log.showInfo(`changePsdTopMargin fold ${this.psdLayoutData.index}`);
    return;
  }

  onEmergencyKeyClick() {
    log.info('go to emergency call');
    PowerUtils.refreshActivity('onEmergencyKeyClick');
    this.bouncerVm?.gotoEmergencyCall();
  }

  private onBack() {
    log.info('go back to lock');
    PowerUtils.refreshActivity('onBack');
    this.bouncerVm?.goBack();
  }

  private noPwdRecovery(): void {
    log.info('noPwdRecovery');
    this.bouncerVm?.noPwdRecovery();
  }

  @Builder
  psdPageBuilder() {
    if (CommonConstants.NO_PIN_MIXED_ARRAY.includes(this.passwordType)) {
      FoldablePSD({
        onBack: () => {
          this.onBack();
        },
        onEmergencyKeyClick: () => {
          this.onEmergencyKeyClick()
        },
        persistentId: this.persistentId,
        offHandNormalizedSpeed: 0,
        passwordType: this.passwordType,
        keyboardPosition: this.keyboardPosition,
        psdViewScale: this.psdViewScale,
        psdViewOpacity: this.psdViewOpacity,
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.isPwdCheckVisible) {
        Stack({ alignContent: Alignment.Bottom }) {
          this.psdPageBuilder()
        }
        .transition(this.pwdTransitionEffect)
        .id(COMPONENT_ID_SCREEN_LOCK_HOME)
      }
    }
    .width('100%')
    .height('100%')
    .visibility(this.isBouncerVisible ? Visibility.Visible : Visibility.Hidden)
    .onKeyEvent((event?: KeyEvent) => {
      if (event?.keyCode == KeyCode.KEYCODE_BACK || event?.keyCode == KeyCode.KEYCODE_ESCAPE) {
        this.bouncerVm?.goBack();
      }
    })
    .id(TAG)
  }
}