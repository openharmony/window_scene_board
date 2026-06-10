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

import { CheckEmptyUtils, LogDomain, LogHelper, Observer, Trace, } from '@ohos/basicutils';
import {
  HiSysEventUtil,
  ViewType,
  ViewCallback,
  sEventManager,
  EventConstants,
  sSettingsUtil,
  ViewManagerPolicy,
  DeviceHelper,
  HiDfxEventUtil,
  GlobalContext
} from '@ohos/frameworkwrapper';
import { StrongAuthManager, StrongAuthConstants } from '@ohos/screenlockcommon/src/main/ets/manager/StrongAuthManager';
import {
  OOBE_CHANGE_EVENT,
  FocusChangeReason,
  SCBOobeManager,
  SCBScreenProperty,
  SCBPropertyChangeReason,
  ResUtils,
  SCBScreenSessionManager,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { themeWallpaperAniMgr, DynamicWallPaperState, } from '@ohos/themeservice';
import { BaseViewController } from '@ohos/frameworkcommon';
import SlideScreenLock from './SlideScreenLock'
import { InputMethodManager } from '@ohos/launchercommon';
import LockScreenBase from '../refactor/LockScreenBase';
import DrawDoneManager from '@ohos/screenlockcommon/src/main/ets/manager/DrawDoneManager';
import StyleConfiguration from '../common/StyleConfiguration';
import { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import { RemoteLockController } from '../controller/RemoteLockController';
import {
  CommonConstants,
  IUserData,
  ScreenLockStatus,
  strongAuthManager,
} from '@ohos/screenlockcommon';
import accountModel from '../refactor/AccountsModel';
import ScreenLockService from '../refactor/ScreenLockService';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import FingerprintViewModel from '../refactor/FingerprintViewModel';
import { MonitorManager } from '@ohos/screenlockcomponent/src/main/ets/monitor/MonitorManager';
import ViewModel from '../vm/SlideScreenLockViewModel';
import osAccount from '@ohos.account.osAccount';
import { FingerprintConstants } from '@ohos/screenlockcommon';
import { IAMAuthExtraInfo, PowerUtils, PowerStateManager } from '@ohos/screenlockcommon';
import {
  SCBDefaultZIndex,
  SCBScreenPowerEvent,
  SCBScreenPowerEventType,
  SCBScreenPowerStatusChangeReason
} from '../../scenemanager/SCBScreen';
import { PCUtils } from '../../../common/utils/PCUtils';
import power from '@ohos.power';
import { CustomizePromptViewModel } from '../vm/CustomizePromptViewModel';
import {
  PromptShowType
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';
import { systemParameter } from '@kit.BasicServicesKit';
import Constants from '../common/Constants';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import StyleManager from '../style/StyleManager';
import { accountSwitchCallback, OsAccountSwitchEventData } from '../refactor/AccountsModel';
import AccountsViewModel from '../vm/AccountsViewModel';
import {
  SwitchAccountAnimationMethod,
  SwitchAccountAnimationParameter
} from './SwitchAccountAnimation';
import { biometricsVerifyService } from '../common/BiometricsVerifyService';
import { enterpriseSpaceVerifyService } from '../vm/enterprise/EnterpriseMultiSpaceVerifyService';
import { CustomVoteDevice } from '../vm/CustomVoteDevice';
import { SpecialModeViewData, SpecialModeViewModel } from '../vm/SpecialModeViewModel';
import { PCBasePromptViewModel } from '../vm/PCBasePromptViewModel';
import { PCFingerprintViewModel } from '../vm/PCFingerprintViewModel';
import { fingerprintReporter, UnlockStage } from '@ohos/screenlockcommon/src/main/ets/manager/FingerprintReporter';
import {
  SystemAnimatedScene,
  systemAniSceneCtrl
} from '@ohos/pcmode';
import ResetPwdPage from './ResetPwdPage';
import { SCBResetPwdManager } from '../common/SCBResetPwdManager';
import { ScreenLockManager } from '../refactor/ScreenLockManager';
import { DisplayUtil } from '../util/DisplayUtil';
import { HibernateEvent, EVRNT_NAME_EXIT_HIBERNATE, EVRNT_NAME_ENTER_HIBERNATE } from '@ohos/shutdownview/src/main/ets/utils/HibernateEvent';
import { CommonEventData } from 'commonEvent/commonEventData';
import { tipPriorityScheduler } from '../common/TipPriority';
import { ScreenOnOffMediator } from '@ohos/screenlockcommon';
import { inspector } from '@kit.ArkUI'

const TAG = 'ScreenLock-SCBScreenLock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const COMPONENT_ID_SCREEN_LOCK_HOME = TAG + '_Screen_lock_home';
const NOTIFY_OFF_SCREEN_CLOSE_LCD: number = 3;

@Component
export struct SCBScreenLock {
  @Link screenProp: SCBScreenProperty;
  @State isSwitchAnimation: boolean = false;
  @State switchToId: string = '0';
  @State
  viewController: BaseViewController = new BaseViewController(ViewType.KEYGUARD);
  @StorageLink('passwordType')
  passwordType: string = 'NONE';
  persistentId: number = 0;
  private mComponentStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  @State
  private backgroundBlur: number = 0;
  @Provide
  private isPowerMenuPanelShowed: boolean = false;
  @Provide
  private isPwdFocused: boolean = false;
  private drawDoneManager: DrawDoneManager = new DrawDoneManager(COMPONENT_ID_SCREEN_LOCK_HOME);
  @State
  private remoteLockController: RemoteLockController = new RemoteLockController();
  @Provide
  fingerprintViewModel: FingerprintViewModel = new PCFingerprintViewModel();
  @Provide customizePromptVM: PCBasePromptViewModel = new CustomizePromptViewModel();
  @State @Watch('changeFingerprintEnable')
  isFingerprintEnable: boolean = false;
  @StorageLink('isCurrentUserHasFingerprint') @Watch('updateIsFingerprintEnable')
  private isCurrentUserHasFingerprint: boolean = false;
  @State @Watch('updateIsFingerprintEnable')
  private fingerprintUnlockSwitch: boolean = false;
  @StorageLink('isPinAvailable') @Watch('updateIsNeedFingerprint')
  isPinAvailable: boolean = true;
  @StorageLink('isResetPwdPanelShow')
  isResetPwdPanelShow: boolean = false;
  @State
  viewModel: ViewModel = new ViewModel();
  @StorageLink('isScreenOn') @Watch('dealWithScreenOn')
  screenOn: boolean = ScreenLockService.isScreenOn;
  @StorageLink('engineThemeStatic') engineThemeStatic: boolean = true;
  @Provide pwdNeedFocus: boolean = false;
  @Provide focusAfterBoot: boolean = false;
  @StorageLink('mWallpaperType') @Watch('updateWallpaperMode') slWallpaperDegree: number = 0;
  @State isPersonalSpaceActive: boolean = false;
  @StorageLink('isEndScreenOn') @Watch('startScreenOnAnimation') private isEndScreenOn: boolean = true;
  @StorageLink('isBeginSleepStart') @Watch('startScreenOffAnimation') private isBeginSleepStart: boolean = false;
  private screenLockViewReady: boolean = false;
  @StorageLink('screenPowerEvent') @Watch('onScreenPowerEventChange') powerEvent:
    SCBScreenPowerEvent = new SCBScreenPowerEvent();
  @StorageLink('domainAccountIsExpired') @Watch('onDomainAccountExpired') domainAccountIsExpired: boolean = false;
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  private isRequestFingerprintInSleep: boolean = false;
  @StorageLink('currentUserItem') private userData: IUserData | null = null;
  private foldAngle: number = 0;
  private isInS4: boolean = false;
  private lastFPAuthTime: number = new Date().getTime();
  @State resetPwdPageShow: boolean = false;
  private listener: inspector.ComponentObserver = this.getUIContext().getUIInspector().
    createComponentObserver(COMPONENT_ID_SCREEN_LOCK_HOME);
  // 用于标记启动阶段，锁屏是否可以显示
  @State private isReadyToShow: boolean = false;

  private onLayoutComplete:()=>void=():void=>{
    log.showInfo('onLayoutComplete');
    this.isReadyToShow = true;
    LockScreenBase.VoteReadyToShow();
  }

  private onWallpaperRemoteReady(): void {
    log.showInfo('onWallpaperRemoteReady');
    this.isReadyToShow = true;
    LockScreenBase.VoteReadyToShow(500);
  }

  private onLock(): void {
    if (!this.isLock) {
      SCBSceneSessionManager.getInstance()
        .requestUnfocus(this.persistentId, FocusChangeReason.SCB_SESSION_REQUEST_UNFOCUS);
    } else {
      SCBSceneSessionManager.getInstance().requestFocus(this.persistentId, true, FocusChangeReason.FOREGROUND);
      LockScreenAnimationController.getInstance().setLocked();
    }
  }

  private onScreenPowerEventChange(): void {
    if (this.powerEvent.changeReason === SCBScreenPowerStatusChangeReason.POWER_CHANGE_REASON_HIBERNATE &&
      this.powerEvent.eventType === SCBScreenPowerEventType.SLEEP) {
      log.showInfo('PC is in hibernate');
      AppStorage.setOrCreate('isInHibernate', true);
    } else if (this.powerEvent.eventType === SCBScreenPowerEventType.DISPLAY_ON) {
      if (AppStorage.get('isInHibernate')) {
        log.showInfo('restart fingerprint auth beacuse screenOn from S4');
        ScreenLockService.cancelAuthOfFingerprint();
        this.needFingerprint();
      }
      AppStorage.setOrCreate('isInHibernate', false);
    } else {
    }
  }

  private onDomainAccountExpired(): void {
    // 取消指纹授权
    this.updateIsNeedFingerprint();
  }

  private startScreenOnAnimation(): void {
    if (!this.isEndScreenOn) {
      return;
    }
    if (ScreenLockService.isOobeEnableNoPwd()) {
      return;
    }
    ScreenLockService.setIsOffScreenUnlocking(false);
  }

  private startScreenOffAnimation(): void {
    if (!this.isBeginSleepStart) {
      return;
    }
    if (ScreenLockService.isOobeEnableNoPwd()) {
      return;
    }
    log.showInfo('start screenOffAnimation');
  }

  private viewCallback: ViewCallback = {
    onShow: () => {
      this.onViewShow()
    },
    onHide: () => {
      this.onViewHide()
    }
  };

  private onScreenLockBeginSleep = (): void => {
    if (!this.viewController.isShowing()) {
      ScreenLockService.setScreenLockDrawDown(false);
      this.drawDoneManager.registerComponentDrawObserver(this.screenLockDrawObserverCallback);
    } else {
      ScreenLockService.setScreenLockDrawDown(true);
    }

    if (ScreenOnOffMediator.ableToSendScreenOffNotifyEvent) {
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(NOTIFY_OFF_SCREEN_CLOSE_LCD);
    }
  }

  private screenLockDrawObserverCallback: () => void = (): void => {
    ScreenLockService.notifyDrawDone();
    ScreenLockService.setScreenLockDrawDown(true);
    ScreenLockService.checkFaceKeyGuardWhetherEnable();
  }

  private refreshFingerprintUnlockSwitch: () => void = () => {
    const value: string = sSettingsUtil.getValueBySECURE(FingerprintConstants.KEY_FINGERPRINT_KEYGUARD_ENABLE,
      FingerprintConstants.FINGERPRINT_KEYGUARD_ENABLE_DEFAULT);
    log.showInfo(`handleFingerprintUnlockSwitchChange ${FingerprintConstants.KEY_FINGERPRINT_KEYGUARD_ENABLE} = value(${value})`);
    this.fingerprintUnlockSwitch = (value === FingerprintConstants.SWITCH_ENABLE) ? true : false;
  };

  private isShiftDown: boolean = false;

  notifyDrawDone() {
    if (ScreenLockService.getScreenLockDrawDown()) {
      ScreenLockService.notifyDrawDone();
    }
  }

  private fingerprintAcquireInfoCallback: Function =
    async (moduleId: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo): Promise<void> => {
      if (extraJsonInfo?.authResult === osAccount.ResultCode.FAIL && !strongAuthManager.isNeedStrongAuth()) {
        AppStorage.setOrCreate('isEmojiAuthSuccess', 'AUTH_FAIL');
      }
      this.customizePromptVM?.refreshStartTime();
      const isActive: boolean = this.isEndScreenOn && !this.isBeginSleepStart;
      if (isActive && extraJsonInfo?.authResult === osAccount.ResultCode.FAIL) {
        log.showInfo(`wakeup:${this.isEndScreenOn} ${this.isBeginSleepStart}`);
        power.wakeup('fingerprintAcquireInfoCallback');
      }
      if (await this.blockIfEnterpriseSpaceExpired()) {
        return
      }
      this.fingerprintViewModel.fingerprintAcquireInfoCallback(moduleId, acquire, extraJsonInfo);
    };

  // 灭屏监听回调
   async dealWithScreenOn() {
    this.notifyDrawDone();
     // 灭屏合盖时，需要取消企业账号认证，并返回PIN码认证
     if(!this.screenOn) {
       ScreenLockService.cancelAuthOfDomainMixed();
       AppStorage.setOrCreate('isPinAuthType', true);
     }
    log.showInfo(`dealWithScreenOn screenOn: ${this.screenOn}, isRequestFingerprintInSleep: ${this.isRequestFingerprintInSleep}`);
    // 亮屏的时候不重复下发指纹认证请求
    if (!this.screenOn && !this.isRequestFingerprintInSleep) {
      this.needFingerprint();
    }
    this.isRequestFingerprintInSleep = false;
  }

  public updateWallpaperMode(): void {
    StyleManager.updateWallpaperMode(this.slWallpaperDegree);
    if (!this.screenLockViewReady && this.slWallpaperDegree !== 0) {
      animateToImmediately({}, () => {});
      this.screenLockViewReady = true;
    }
  }

  /*
   sceneBoard项目启动后 定时查询系统启动是否完成  完成后锁屏开始响应事件
   */
  private bootCompletedMonitor(): void {
    log.showInfo(`bootCompletedMonitor`);
    systemParameter.get('bootevent.boot.completed', (err, data) => {
      if (!!err) {
        this.focusAfterBoot = true;
        log.showError(`bootCompletedMonitor error, err:${err.toString()}`);
        return;
      }
      if (!!data) {
        this.focusAfterBoot = true;
        log.showInfo(`boot completed!`);
        return;
      }
      log.showDebug(`boot unfinished!`);
      setTimeout(() => {
        this.bootCompletedMonitor();
      }, 100);
    });
  }

  public initFingerprint(): void {
    ScreenLockService.checkFingerprintForCurrentUser();
    this.fingerprintViewModel.viewModelInit(this.refreshFingerprintUnlockSwitch, null, null, null);
    this.fingerprintViewModel.initCustomPrompt(this.customizePromptVM);
    ScreenLockService.setFingerprintAcquireInfoCallback(this.fingerprintAcquireInfoCallback);
    this.fingerprintViewModel.setAuthFinishCallback(this.authFinishCallback);
    this.refreshFingerprintUnlockSwitch();
    this.needFingerprint();
  }

  private authFinishCallback = (extraJsonInfo: IAMAuthExtraInfo) => {
    ScreenLockService.refreshAuthEndTime(osAccount.AuthType.FINGERPRINT);
    Trace.end(Trace.CORE_METHOD_FINGERPRINT_AUTH);
    log.showInfo('AuthFp recognition finish.');
    if (extraJsonInfo.authResult === osAccount.ResultCode.SUCCESS) {
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.FINGERPRINT, UnlockStage.START_UNLOCK);
    }
    this.fingerprintViewModel.onResultCallback(extraJsonInfo);
  }

  public initWindow(): void {
    log.showInfo(`initWindow`);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        if (this.screenProp.screenId !== screenProperty.screenId) {
          log.showInfo(
            `screenId mismatch detected, updateRect operation skipped. ` +
              `currentScreenId: ${this.screenProp.screenId}, updateScreenId: ${screenProperty.screenId}`)
          return;
        }
        this.viewController.updateRect({
          left: 0,
          top: 0,
          width: px2vp(screenProperty.width),
          height: px2vp(screenProperty.height)
        })
      }, this.screenProp.screenId);
    this.viewController.registerCallback(this.viewCallback);
  }

  public initCustomizeUnlock(): void {
    ScreenLockService.setCustomizeUnlock(() => {
      log.showInfo('start customize unlock');
      if (!AccountsViewModel.getInstance().isCanUnlock()) {
        return;
      }
      let status: number | undefined = AppStorage.get(CommonConstants.LOCK_STATUS_KEY);
      if (status !== ScreenLockStatus.UNLOCK) {
        log.showInfo(`LOCK_STATUS_KEY:${status}`);
        return;
      }
      ScreenLockService.doUnLockAnimation(this.doUnLock);
    });
  }

  private checkAutoUnlockAfterReboot(): void {
    if (accountModel.getForegroundUserId() !== accountModel.getCurrentUserId()) {
      return;
    }
    if (this.passwordType !== 'NONE') {
      return;
    }
    systemParameter.get('persist.edm.auto_unlock_after_reboot', (err, data) => {
      if (!!err) {
        log.showError(`get auto unlock after reboot error, err:${err.toString()}`);
        return;
      }
      if (data === 'true') {
        log.showInfo('checkAutoUnlockAfterReboot');
        setTimeout(() => {
          ScreenLockService.doUnLockAnimation(this.doUnLock);
        }, 2000);
      }
    });
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.listener.on('layout', this.onLayoutComplete);
    GlobalContext.getContext()?.eventHub.on('wallpaperRemoteReady', this.onWallpaperRemoteReady);
    this.tryPlayEnterAnimation();
    MonitorManager.getInstance().initPowerMonitor();
    PowerStateManager.getInstance().init();
    ScreenLockManager.getInstance().init();
    SCBResetPwdManager.getInstance().init();
    this.resetPwdPageShow = SCBResetPwdManager.getInstance().resetPwdPageShow;
    ViewManagerPolicy.registerViewController(ViewType.KEYGUARD, this.viewController);
    this.viewController.updateId(this.persistentId);
    ScreenLockService.setWallPaperToShowDesktopCallback(this.setWallPaperToShowDesktop);
    if (ScreenLockService.isOobeEnableNoPwd()) {
      this.viewController.hide();
      log.showInfo('oobe started, hide screenlock');
    } else {
      this.viewController.show();
      this.setWallPaperToHideDesktop();
    }
    strongAuthManager.setNeedRequestUnlock(false);
    LockScreenBase.initVoteDevice(new CustomVoteDevice());
    LockScreenBase.onCreate();
    this.initWindow();
    this.bootCompletedMonitor();
    sEventManager.subscribe(EventConstants.SCREEN_LOCK_BEGIN_SLEEP, this.onScreenLockBeginSleep);
    this.remoteLockController.registerRemoteLockListener();
    this.initFingerprint();
    accountModel.registerAccountSwitchCallback('switched', this.accountSwitchCallback); // 适配底层修改，用户切换监听方式修复
    this.updateWallpaperMode();
    this.initCustomizeUnlock();
    SpecialModeViewModel.getInstance(new SpecialModeViewData());
    if (SCBOobeManager.isOobeActivated()) {
      setTimeout(this.preHeatingAppCenter, 0);
    }
    sEventManager.subscribe(OOBE_CHANGE_EVENT, (enable: boolean) => {
      if (!enable) {
        sSettingsUtil.setValue(Constants.IS_SHOULD_UNLOCK, 'false');
      }
    });
    if (this.remoteLockController.isRemoteLocked()) {
      this.remoteLockController.setDarkWallpaper();
    }
    LockScreenAnimationController.getInstance()
      .addInitCallback(LockScreenAnimationController.STATUS_CALLBACK, ()=>{
        log.showInfo(`initCallback`)
        systemAniSceneCtrl.enqueue(SystemAnimatedScene.LOCKSCREEN_TO_LAUNCHER);
    })
    this.registerFoldStateChangeListener();
    HibernateEvent.registerHibernateEventCallback(this.hibernateEventCallback);
    this.checkAutoUnlockAfterReboot();
  }

  private hibernateEventCallback: (data: CommonEventData) => void = (data: CommonEventData): void => {
    if (data.event === EVRNT_NAME_ENTER_HIBERNATE) {
      log.showInfo('Enter_Hibernate');
      this.isInS4 = true;
      ScreenLockService.cancelAuthOfFingerprint();
    } else if (data.event === EVRNT_NAME_EXIT_HIBERNATE) {
      log.showInfo('Exit_Hibernate');
      this.isInS4 = false;
      ScreenLockService.cancelAuthOfFingerprint();
      this.needFingerprint();
    } else {
    }
  }

  private tryPlayEnterAnimation() {
    log.showInfo('space switch start enter animation');
    if (!SwitchAccountAnimationMethod.enableAnimation()) {
      log.showInfo('space switch enableAnimation false');
      return;
    }
    this.isSwitchAnimation = true;
    setTimeout(() => {
      log.showInfo('space switch finish enter animation');
      this.isSwitchAnimation = false;
    }, SwitchAccountAnimationParameter.closeAnimation);
  }

  private isFoldAngle(): boolean {
    return this.foldAngle < Constants.FOLDED_ANGEL;
  }

  private onFoldAngleChange: Callback<number[]> = (angles: number[]) => {
    if (!this.isFingerprintEnable) {
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(angles)) {
      log.showWarn('onFoldAngleChange angles is empty');
      return;
    }
    this.foldAngle = angles[0];
    // hopper盒盖取消指纹解锁
    if (this.isFoldAngle() && ScreenLockService.isAuthingByFingerprint()) {
      log.showInfo('onFoldAngleChange cancelAuthOfFingerprint');
      ScreenLockService.cancelAuthOfFingerprint();
    } else if (!this.isFoldAngle() && !ScreenLockService.isAuthingByFingerprint()) {
      log.showInfo('onFoldAngleChange start fingerprint authentication');
      if (this.isInS4) {
        log.showInfo('into S4');
        return;
      }
      this.needFingerprint();
    }
  }

  // 检查用户是否显示在前台
  private isUserInFrontDesk(): boolean {
    const DEFAULT_VALUE = '-1';
    const checkUserId = sSettingsUtil.getValue(Constants.CHECK_USER_ID, DEFAULT_VALUE);
    // 表示只有一个用户，肯定在前台
    if (checkUserId === DEFAULT_VALUE) {
      return true;
    }
    return sSettingsUtil.getValue(Constants.CHECK_USER_ID, '-1') === this.userData?.userId.toString();
  }

  private registerFoldStateChangeListener(): void {}

  private preHeatingAppCenter(): void {
    let preHeatingAppCenter: Object | undefined = AppStorage.get('preHeatingAppCenter');
    if (preHeatingAppCenter === undefined) {
      AppStorage.setOrCreate<boolean>('preHeatingAppCenter', true);
      ViewManagerPolicy.showView(ViewType.APP_CENTER);
    }
  }

  onPageShow() {
    log.showInfo('onPageShow');
  }

  onPageHide() {
    log.showInfo('onPageHide');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisAppear')
    this.listener.off('layout', this.onLayoutComplete);
    GlobalContext.getContext()?.eventHub.off('wallpaperRemoteReady', this.onWallpaperRemoteReady);
    this.viewController.unRegisterCallback(this.viewCallback);
    this.remoteLockController.unregisterRemoteLockListener();
    accountModel.unRegisterAccountSwitchCallback('switched');
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(() => {
      }, this.screenProp.screenId);
    sEventManager.off(OOBE_CHANGE_EVENT, () => {
    });
    HibernateEvent.unregisterHibernateEventCallback();
    PowerStateManager.getInstance().release();
  }

  private accountSwitchCallback: accountSwitchCallback = {
    onSwitched: (data: OsAccountSwitchEventData): void => {
      log.showInfo(`switched updateUsers from:${data.fromAccountId} to:${data.toAccountId}`);
      if (data.toAccountId === accountModel.getCurrentUserId()) {
        let fingerprintContextId = ScreenLockService.getFingerprintContextId();
        log.showInfo(`fingerprintContextId ${fingerprintContextId}`);
        if (!!fingerprintContextId) {
          log.showInfo('process restart cancelAuthOfFingerprint');
          ScreenLockService.cancelAuthOfFingerprint();
        }
        StrongAuthManager.getInstance()
          .setAuthReason(StrongAuthManager.getInstance().getUserStrongAuth(accountModel.getCurrentUserId()));
        this.needFingerprint();
        AccountsViewModel.getInstance().requestFocus();
        AppStorage.setOrCreate('isPwdVisibleForPC', true);
        this.tryPlayEnterAnimation();
      }
      enterpriseSpaceVerifyService.reset();
    }
  }

  private needFingerprint() {
    if (accountModel.getForegroundUserId() !== accountModel.getCurrentUserId()) {
      log.showInfo(`cancel behind user PF Auth`);
      ScreenLockService.cancelAuthOfFingerprint();
      return;
    }
    const fPAuthInterval: number = new Date().getTime() - this.lastFPAuthTime;
    log.showInfo(`fPAuthInterval ${fPAuthInterval}`);
    // 只对时间间隔在2秒内的指纹认证做防重复下发处理，超过2秒，则忽略是否重复，强行下发认证
    if (ScreenLockService.isAuthingByFingerprint() && fPAuthInterval < 2000) {
      log.showInfo(`prevent duplicate FP Auth`);
      return;
    }
    log.showInfo(`isFingerprintEnable: ${this.isFingerprintEnable}, isFingerprintSuspend: ${this.fingerprintViewModel.isFingerprintSuspend()}`);
    if (this.isFingerprintEnable) {
      this.lastFPAuthTime = new Date().getTime();
      ScreenLockService.authUserByFingerprint(async (result: number, extraInfo: osAccount.AuthResult) => {
        if (accountModel.getForegroundUserId() !== accountModel.getCurrentUserId()) {
          log.showInfo('not CurrentUser');
          return;
        }
        if (strongAuthManager.isNeedStrongAuth()) {
          log.showInfo('need strongAuth');
          return;
        }
        // pin码过期，指纹解锁中止。
        if (result === 0 && extraInfo?.pinValidityPeriod === 0) {
          this.customizePromptVM.showPrompt(ResUtils.getInnerString($r('app.string.psd_has_expired')), PromptShowType
            .PERMANENT);
          log.showInfo(`authUserByFingerprint result:${result} pinValidityPeriod: ${extraInfo.pinValidityPeriod}`);
          return;
        }
        if (!AccountsViewModel.getInstance().isCanUnlock(true)) {
          log.showInfo('isCanUnlock');
          return;
        }
        if (result === 0 && await this.blockIfEnterpriseSpaceExpired()) {
          AppStorage.setOrCreate('isPinAuthType', false);
          log.showInfo('blockIfEnterpriseSpaceExpired');
          return
        }

        log.showInfo(`Fingerprint result: ${result}`);
        if (result === 0) {
          if (ScreenLockService.getLock()) {
            log.showInfo('FPUnlock break beacuse lockscreen suddenly');
            this.needFingerprint();
            return;
          }
          InputMethodManager.getInstance().stopInputSession();
          const unLockCallBack = () => {
            AppStorage.setOrCreate('isLockAnimationStart', true);
            ScreenLockService.unlocking(false);
            ScreenLockService.notifyUnlockTransition();
            AppStorage.setOrCreate('isEmojiAuthSuccess', true);
          };
          ScreenLockService.doUnLockAnimation(unLockCallBack);
        }
      });
    } else {
      ScreenLockService.cancelAuthOfFingerprint();
    }
  }

  private async blockIfEnterpriseSpaceExpired(): Promise<boolean> {
    if (enterpriseSpaceVerifyService.isEnabled()) {
      const expired = await enterpriseSpaceVerifyService.isAuthExpired();
      if (expired) {
        log.showWarn('current domain account is authentication expired');
        return true;
      }
    }
    return false;
  }

  private updateIsFingerprintEnable(): void {
    log.showInfo(`isCurrentUserHasFingerprint: ${this.isCurrentUserHasFingerprint}, ${this.fingerprintUnlockSwitch}`);
    if (this.isCurrentUserHasFingerprint && this.fingerprintUnlockSwitch) {
      this.isFingerprintEnable = true;
    } else {
      this.isFingerprintEnable = false;
    }
    this.customizePromptVM.isShowPrompt = this.isFingerprintEnable;
  }

  /**
   * pin码超期重设后，重启指纹校验。
   */
  private updateIsNeedFingerprint(): void {
    // pin码过期，需要关闭指纹验证，避免底层回传旧有数据。
    log.showInfo('to cancelAuthOfFingerprint');
    ScreenLockService.cancelAuthOfFingerprint();
    if (this.isPinAvailable && !this.isResetPwdPanelShow) {
      this.needFingerprint();
    }
  }

  changeFingerprintEnable(): void {
    log.showInfo(`changeFingerprintEnable: ${this.isFingerprintEnable}`)
    strongAuthManager.setFingerprintEnable(this.isFingerprintEnable);
    this.fingerprintViewModel.onIsFingerprintEnableChange(this.isFingerprintEnable);
    if (this.viewController.isShowing()) {
      this.needFingerprint();
    }
  }

  private onViewShow(): void {
    log.showInfo('onShow');
    tipPriorityScheduler.init();
    // 切换用户不下发animateToImmediately
    this.setWallPaperToHideDesktop(accountModel.getCurrentUserId() === accountModel.getForegroundUserId());
    biometricsVerifyService.init();
    this.refreshFingerprintUnlockSwitch();
    if (AppStorage.get('isBeginSleepStart') && !PCUtils.is2D()) {
      log.showInfo('isBeginSleepStart and is not 2D');
    } else {
      AppStorage.setOrCreate('isPwdVisibleForPC', false);
      ScreenLockService.resetPageToPsd();
    }
    ScreenLockService.checkFingerprintForCurrentUser(() => {
      log.showInfo(`onViewShow isCurrentUserHasFingerprint: ${AppStorage.get('isCurrentUserHasFingerprint')}`);
      this.updateIsFingerprintEnable();
      this.isRequestFingerprintInSleep = true;
      // 进入S4取消指纹解锁
      if (AppStorage.get('isInHibernate')) {
        log.showInfo('the power has entered S4,not need fingerprint');
        return;
      }
      this.needFingerprint();
    }, () => {
      ScreenLockService.cancelAuthOfFingerprint();
    });
    DisplayUtil.registerFoldAngleChangeCallback(this.onFoldAngleChange);
  }

  /**
   * 息屏状态下，指纹解锁唤醒屏幕
   */
  private FPWakeUpUnderScreenOff(): void {
    if (this.fingerprintViewModel.isFingerprintAcquireWhenScreenOff()) {
      LockScreenBase.onBeginWakeup();
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_PRE_BRIGHT_SUCCESS).then((value) => {
        log.showInfo('FingerprintTouchUnlock wake up success')
      }).catch(() => {
        log.error('onSuccessForPowerFingerprintTouchUnlock, wakeup error');
      });
    }
  }

  private onViewHide(): void {
    log.showInfo('onHide');
    this.setWallPaperToShowDesktop();
    this.FPWakeUpUnderScreenOff();
    biometricsVerifyService.unInit();
    if (!LockScreenAnimationController.getInstance().isPlayShieldAnimation) {
      this.preHeatingAppCenter();
    }
    ScreenLockService.cancelAuthOfFingerprint();
    DisplayUtil.unregisterFoldAngleChangeCallback(this.onFoldAngleChange);
    this.isPowerMenuPanelShowed = false;
    this.customizePromptVM.refreshVM();
    this.fingerprintViewModel.resetOffScreenFingerprintFailCnt();
  }

  private setWallPaperToShowDesktop: Function = () => {
    // 解锁进桌面时先把复制壁纸图层显示出来，再将桌面壁纸图层Zindex切下去
    AppStorage.setOrCreate('wallpaperZIndex', SCBDefaultZIndex.WALLPAPER);
    log.showInfo('dynamic wall paper setWallPaperToShowDesktop');
  }

  private setWallPaperToHideDesktop: Function = (isNeedImmediately: boolean = false) => {
    AppStorage.setOrCreate('wallpaperZIndex', SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER);
    // send all animation to rs immediately
    if (isNeedImmediately) {
      animateToImmediately({}, () => {
      });
    }
    log.showInfo('dynamic wall paper setWallPaperToHideDesktop');
  }

  private canPwdFocusBySingle(keyCode: number): boolean {
    if (keyCode >= KeyCode.KEYCODE_0 && keyCode <= KeyCode.KEYCODE_9) {
      return true;
    };
    if (keyCode >= KeyCode.KEYCODE_A && keyCode <= KeyCode.KEYCODE_Z) {
      return true;
    };
    if (keyCode === KeyCode.KEYCODE_GRAVE || keyCode === KeyCode.KEYCODE_MINUS ||
      (keyCode >= KeyCode.KEYCODE_LEFT_BRACKET && keyCode <= KeyCode.KEYCODE_SLASH) ||
      keyCode === KeyCode.KEYCODE_COMMA || keyCode === KeyCode.KEYCODE_PERIOD) {
      return true;
    };
    return false;
  }

  private accountClick() {
    if (AppStorage.get('accountSwitch')) {
      log.showWarn('is switching cannot click');
      return;
    }

    if (!AppStorage.get('isScreenOn')) {
      log.showInfo('screen off, stay on screen-lock');
      return;
    }

    log.showInfo('click userPhoto unlock');
    ScreenLockService.refreshUnlockStartTime();
    HiDfxEventUtil.reportButtonEvent(HiSysEventUtil.TOUCH_EVENT);
    if (ScreenLockService.canUnlockWithoutPassword()) {
      log.showInfo('LockScreenAnimationController doCallbacks');
      ScreenLockService.doUnLockAnimation(this.doUnLock);
    } else {
      ScreenLockService.unlockScreen();
    }
  }

  private doUnLock = (): void => {
    ScreenLockService.unlockScreen(false);
    ScreenLockService.notifyUnlockTransition();
    let currentUser: IUserData | undefined = AppStorage.get('currentUserItem');
    if (currentUser && !currentUser.isLoggedIn) {
      accountModel.onAccountSwitch(currentUser?.userId, () => {
        log.showInfo(`activate user success`);
      });
    }
  }

  private onUserIconClickHandle() {
    if (this.isResetPwdPanelShow) {
      return;
    }
    this.accountClick();
  }

  private processKeyEvent(event?: KeyEvent): void {
    if (this.isPowerMenuPanelShowed) {
      log.showInfo('doKeyEvent powerMenuPanel show');
      return;
    }
    let keyCode = event?.keyCode ?? 0;
    if (keyCode === KeyCode.KEYCODE_SHIFT_LEFT || keyCode === KeyCode.KEYCODE_SHIFT_RIGHT) {
      this.isShiftDown = event?.type === KeyType.Down;
    }
    if (event?.type === KeyType.Down) {
      return;
    }
    if (this.isShiftDown) {
      if (keyCode === KeyCode.KEYCODE_EQUALS) {
        // +可获焦
        focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
        return;
      }
      if (keyCode === KeyCode.KEYCODE_GRAVE || keyCode === KeyCode.KEYCODE_BACKSLASH ||
        keyCode === KeyCode.KEYCODE_COMMA || keyCode === KeyCode.KEYCODE_PERIOD) {
        // ~|<>不可获焦
        return;
      }
    } else {
      if (keyCode === KeyCode.KEYCODE_EQUALS) {
        // = 不可获焦
        return;
      }
    }
    if (this.canPwdFocusBySingle(keyCode)) {
      focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
    }
  }

  build() {
    if (this.viewController.isShowing()) {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.remoteLockController.isRemoteLocked()) {
          Column()
          .backgroundColor($r('sys.color.black'))
          .width('100%')
          .height('100%')
          .lightUpEffect(0.8)
        }

        if (this.resetPwdPageShow) {
          ResetPwdPage({ pwdPageShow: this.resetPwdPageShow })
        } else {
          SlideScreenLock({
            isPowerMenuPanelShowed: this.isPowerMenuPanelShowed,
            backgroundBlur: this.backgroundBlur,
            remoteLockController: this.remoteLockController,
            mViewModel: this.viewModel,
            isSwitchAnimation: this.isSwitchAnimation,
            isFingerprintEnable: this.isFingerprintEnable,
            screenProp: this.screenProp,
            needFingerprint: () => {
              this.needFingerprint();
            }
          })
            .hitTestBehavior(HitTestMode.Transparent)
            .onMouse((event?: MouseEvent) => {
              if (event) {
                if (event.action != MouseAction.Move) {
                  return;
                }
                let pos: Position = { x: event.windowX, y: event.windowY };
                AppStorage.setOrCreate('emojiMouseEvent', pos);
              }
            })
            .onTouch((event?: TouchEvent) => {
              if (event) {
                let pos: Position = { x: event.touches[0].screenX, y: event.touches[0].screenY };
                AppStorage.setOrCreate('emojiMouseEvent', pos);
              }
            })
        }

        if (!this.isReadyToShow) {
          Column()
            .backgroundColor(Color.Black)
            .width('100%')
            .height('100%')
            .hitTestBehavior(HitTestMode.Block)
        }
      }.id(COMPONENT_ID_SCREEN_LOCK_HOME)
      .onDrop(() => {
        performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
        // 拦截ArkUI onDrop事件，以防透传到桌面
        log.showInfo('screenLock onDrop start');
      })
      .onFocus(()=>{
        log.showInfo(`${COMPONENT_ID_SCREEN_LOCK_HOME} - onFocus`);
        if (this.passwordType === 'NONE') {
          let isSuccess: boolean = focusControl.requestFocus(`ScreenLock-Accounts_Image_userIcon_${this.userData?.userId}`);
          let selectedUsr: number | undefined = AccountsViewModel.getInstance().selectedUserId;
          log.showInfo(`requestFocus on ScreenLock-Accounts_Image_userIcon: ${isSuccess}, ${selectedUsr}`);
        } else {
          let isSuccess: boolean = focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
          log.showInfo(`requestPwdFocus: ${isSuccess}`);
        }
      })
      .onKeyEvent((event?: KeyEvent) => {
        log.showInfo('onKeyEvent - processKeyEvent');
        this.processKeyEvent(event);
      })
    }
  }
}