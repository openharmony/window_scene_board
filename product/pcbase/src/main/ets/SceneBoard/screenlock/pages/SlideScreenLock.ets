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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, HiSysEventUtil, SCBWindowSceneConfig, sSettingsUtil } from '@ohos/frameworkwrapper';
import { StatusBarAnimConstants } from '@ohos/systemuicommon';
import ViewModel from '../vm/SlideScreenLockViewModel';
import { ScreenLockStatus, CommonConstants } from '@ohos/screenlockcommon';
import screenLockService from '../refactor/ScreenLockService';
import { IUserData } from '@ohos/screenlockcommon';
import StyleConfiguration from '../common/StyleConfiguration';
import { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import display from '@ohos.display'
import UserSwitchLoading from './UserSwitchLoading';
import { SCBScreenLockPowerPanel } from '../statusbar/SCBScreenLockPowerPanel';
import { MultiKeyCode } from '@ohos/systemuicommon';
import Curves from '@ohos.curves'
import Constants from '../common/Constants'
import { RemoteLockController } from '../controller/RemoteLockController';
import osAccount from '@ohos.account.osAccount';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { IThemeParam, LockscreenThemeConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import ClockWidget from '../component/clock/ClockWidget';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import UnlockClockAnimParam from '../common/UnlockClockAnimParam';
import ScreenLockModel from '../refactor/ScreenLockModel';
import { OpenCoverAnimationController } from '../common/OpenCoverAnimationController';
import NewAccounts from './NewAccounts';
import accountModel from '../refactor/AccountsModel';
import AccountsViewModel from '../vm/AccountsViewModel';
import { SwitchAccountAnimationParameter } from './SwitchAccountAnimation';
import { faceVerifyService } from '../common/FaceVerifyService';
import { enterpriseSpaceVerifyService } from '../vm/enterprise/EnterpriseMultiSpaceVerifyService';
import StatusBar from '../statusbar/StatusBar';
import ResetPinText from './ResetPinText';
import ScreenLockFoldViewModel, { ScreenLockLayoutChangeCallback } from '../vm/ScreenLockFoldViewModel';
import { performanceMonitor } from '@kit.ArkUI';
import { SpecificScreenLockStateManager } from '../common/SpecificScreenLockStateManager';
import { SlLayoutData } from '../vm/SlLayoutData';
import { SlLayoutViewModel } from '../vm/SlLayoutViewModel';
import { LostModePrompt } from '../component/LostModePrompt';
import { SlLayoutRotateAni } from '../vm/SlLayoutRotateAni';
import ResetPwdBtn from '../component/resetpinbtn/ResetPwdBtn';
import {
  ACTIVE_STATUS_MAP,
  SCBInputMethodList, SCBKeyboardManager, SCBKeyboardSession,
  SCBSceneSessionManager,
  SCBScreenProperty } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'ScreenLock-SlideScreenLock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const TIME_REQUEST_FOCUS: number = 100;
const BACKGROUND_BLUR: number = 103;
const COMPONENT_ID_SCREEN_LOCK_CLOCK = TAG + '_Screen_Lock_Clock';
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

@Component
export default struct SlideScreenLock {
  @Link mViewModel: ViewModel;
  @Prop @Watch('switchAccountAnimation') isSwitchAnimation: boolean;
  @StorageLink('accountSwitch') @Watch('onUserSwitch')
  private accountSwitch: boolean = false;
  @StorageLink('isLock') @Watch('onLock')
  private isLock: boolean = false;
  @State @Watch('requestFocusDelay')
  private isNeedUpdate: boolean = false;
  @StorageLink('isEndScreenOn') @Watch('dealWithEndScreenOn')
  private isEndScreenOn: boolean = false;
  @StorageLink('currentUserItem')
  private userData: IUserData | null = null;
  @State
  private mComponentStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  @State
  private isPowerDialogShowed: boolean = false;
  @Link
  backgroundBlur: number;
  @Link
  isPowerMenuPanelShowed: boolean;
  @Consume('isPwdFocused')
  isPwdFocused: boolean;
  @State
  private gradientRadius: number = this.getGradientRadio();
  @Link remoteLockController: RemoteLockController;
  @Link screenProp: SCBScreenProperty;
  @State keyboardSessionList: SCBInputMethodList = new SCBInputMethodList();
  @State private showInThisScreen: boolean = false;
  @StorageLink('passwordType') passwordType: string | undefined = undefined;
  @State
  screenLockThemeManager: ScreenLockThemeManager = new ScreenLockThemeManager();
  @State
  themeClockParam: IThemeParam | undefined = undefined;
  screenLockModel: ScreenLockModel = new ScreenLockModel();
  @State
  clockAnim: UnlockClockAnimParam = new UnlockClockAnimParam();
  @StorageLink('engineThemeStatic') engineThemeStatic: boolean = true;
  @State
  wallpaperMaskOpacity: number = OpenCoverAnimationController.WALLPAPER_VIEW_MASK_OPACITY_END;
  @State
  wallpaperMaskRadius: number = OpenCoverAnimationController.WALLPAPER_VIEW_MASK_RADIUS_BEGIN;
  @State
  wallpaperMaskScale: number = OpenCoverAnimationController.DEFAULT_SCALE;
  @State
  isWallpaperMaskShow: boolean = false;
  @Consume pwdNeedFocus: boolean;
  @StorageLink('isScreenLockWallpaperBrightOrDark') @Watch('updateClockParam') isBrightWallPaper: boolean = false;
  @Consume focusAfterBoot: boolean;
  @State @Watch('selectedUserIDChanged') selectedUserID: number | undefined = undefined;
  @State
  isCloseClockAnimation:boolean = true;
  @State panelMarginLeft: number | undefined = Constants.PANEL_MARGIN_LEFT;
  @State panelMarginRight: number | undefined = Constants.PANEL_MARGIN_RIGHT;
  @State centerX: string = '0%';
  @StorageLink('systemLanguage') language: string = '';
  @State passwordInitial: string | undefined = '';
  @State slideScreenLockMoveFocus2Pwd: boolean = false;
  @State @Watch('updateClockTopMargin') isResetPwdByRecKeyPageShow: boolean = false;
  @StorageLink('isResetPwdPanelShow') @Watch('updateClockTopMargin') isResetPwdPanelShow: boolean = false;
  @State isPinChangeTextShow: boolean = false;
  @State
  passwordViewBlur: number = LockScreenAnimationController.DEFAULT_BLUR_RADIUS;
  @State
  passwordViewOpacity: number = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
  @State
  passwordViewScale: number = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
  @State
  passwordViewTranslate: number | string = LockScreenAnimationController.DEFAULT_TRANSLATE;
  @State hasRecoveryKey: boolean = false;
  @State forgetPwdMargin: number = ScreenLockFoldViewModel.getInstance().getForgetPwdMarginHeight();
  @State lostModeMarginTop: number = ScreenLockFoldViewModel.getInstance().getLostModeMarginTop();
  @State accountTopMargin: number = 0;
  @State accountTopMarginInTotal: number = 0;
  @State isShowClock: boolean = true;
  @Prop isFingerprintEnable: boolean;
  @State dialogOffset: Offset = { dx: 0, dy: 0 };
  private needFingerprint: () => void = () => {};
  @State slLayoutData: SlLayoutData = new SlLayoutData();
  @State isVirtualKeyboardActive: boolean | undefined = undefined;
  @State keyboardShowHeight: number = 0;
  private slLayoutViewModal: SlLayoutViewModel = new SlLayoutViewModel(this.slLayoutData);
  private slLayoutRotateAni: SlLayoutRotateAni = new SlLayoutRotateAni();

  private sessionStateChangeCallback: Function = (parentId: number, keyboardSessionId: number,
    state: sceneSessionManager.SessionState, screenId: number) => {
    if (screenId !== this.screenProp.screenId) {
      log.showInfo('keyboardId: ' + keyboardSessionId + ', should show in screenId: ' + screenId +
        ', this screen Id: ' + this.screenProp.screenId);
      return;
    }
    const showInThisScreenIndex = this.keyboardSessionList.findIndex(item => {
      return item.screenId === this.screenProp.screenId;
    });
    if (showInThisScreenIndex === -1) {
      this.showInThisScreen = false;
      return;
    }
    const index = this.keyboardSessionList.findIndex(item => {
      return item.session?.persistentId === keyboardSessionId;
    });
    if (index === -1) {
      log.showInfo(`show keyboard failed, keyboard id: ${keyboardSessionId} not found in the list`);
      return;
    }

    this.isVirtualKeyboardActive = ACTIVE_STATUS_MAP.get(state);
    let keyboardSession: SCBKeyboardSession = this.keyboardSessionList[index];
    if (this.isVirtualKeyboardActive === undefined || CommonUtils.isInvalid(keyboardSession) ||
    CommonUtils.isInvalid(keyboardSession.session)) {
      log.showError(`show keyboard failed, state or keyboard is invalid`);
      return;
    }
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      keyboardSession.isActive = this.isVirtualKeyboardActive;
      log.showError('disconnect keyboard');
      return;
    }
    this.showInThisScreen = true;
    log.showInfo(`sessionStateChangeCallback id: ${keyboardSessionId}, isActive: ${this.isVirtualKeyboardActive},
    length: ${this.keyboardSessionList.length}`);
  }

  private createInputMethodCallback: Function = (keyboardSession: SCBKeyboardSession) => {
    if (keyboardSession === undefined || keyboardSession === null) {
      log.showError(`keyboardSession is null, create keyboard Session failed`);
      return;
    }
    const keyboardSessionId = keyboardSession.session?.persistentId;
    const isSystemKeyboard = keyboardSession.session?.isSystemKeyboard;
    const indexInAll = this.keyboardSessionList.findIndex(item => {
      return item.session?.persistentId === keyboardSessionId;
    });
    const systemKeyboardIndexInAll = this.keyboardSessionList.findIndex(item => {
      return item.session?.isSystemKeyboard;
    });
    if (indexInAll === -1) {
      if (systemKeyboardIndexInAll === -1 || keyboardSession.session?.isSystemKeyboard) {
        this.keyboardSessionList.push(keyboardSession);
      } else {
        this.keyboardSessionList.splice(systemKeyboardIndexInAll, 0, keyboardSession);
      }
      SCBSceneSessionManager.getInstance().refreshZOrder();
    } else {
      log.showInfo(`already in list, id: ${keyboardSession.session?.persistentId}, index: ${indexInAll}`);
    }
    log.showInfo(`createInputMethodCallback, keyboardSessionId: ${keyboardSessionId}, isSystemKeyboard:` +
      `${isSystemKeyboard}, indexInAll: ${indexInAll}, systemKeyboardIndexInAll: ${systemKeyboardIndexInAll}`);
  }

  private registerKeyboardListener(): void {
    if (uiType === 'pad') {
      this.keyboardSessionList = SCBKeyboardManager.getInstance().keyboardSessionList;
      SCBKeyboardManager.getInstance().registerCreateKeyboardCallbackForPC(this.createInputMethodCallback);
      SCBKeyboardManager.getInstance().registerKeyboardSessionStateChangeCallbackForPC(this.sessionStateChangeCallback);
    }
  }

  private unRegisterKeyboardListener(): void {
    if (uiType === 'pad') {
      SCBKeyboardManager.getInstance().unRegisterCreateKeyboardCallbackForPC(this.createInputMethodCallback);
      SCBKeyboardManager.getInstance()
        .unRegisterKeyboardSessionStateChangeCallbackForPC(this.sessionStateChangeCallback);
    }
  }

  private selectedUserIDChanged(): void {
    SpecificScreenLockStateManager.resetIsNotifyLockScreen();
    if (!this.isFingerprintEnable) {
      log.showInfo('isFingerprintEnable is false');
      return;
    }
    if (this.selectedUserID === Constants.INVALID_USER_ID) {
      log.showInfo('cancel AuthFp because enter Multi-User view');
      screenLockService.cancelAuthOfFingerprint();
    } else {
      log.showInfo('restart AuthFp because leave Multi-User view');
      this.needFingerprint();
    }
  }

  public getDefaultDisplaySync(): display.Display | undefined {
    try {
      return display.getDefaultDisplaySync();
    } catch (error) {
      log.showError(`getDefaultDisplaySync - msg: ${error?.message}`);
      return undefined;
    }
  }

  updateClockTopMargin() {
    log.showInfo(`updateClockTopMargin isResetPwdByRecKeyPageShow: ${this.isResetPwdByRecKeyPageShow} ` +
      `isResetPwdPanelShow: ${this.isResetPwdPanelShow}`);
    const isChangePwdPageShow = this.isResetPwdByRecKeyPageShow || this.isResetPwdPanelShow
    this.isShowClock = !isChangePwdPageShow;
    ScreenLockFoldViewModel.getInstance().setIsChangePwdPageShow(isChangePwdPageShow);
    const isHorizon = false;
    this.lostModeMarginTop =
      (isHorizon || isChangePwdPageShow) ? Constants.HORIZONTAL_LOST_MODE_MARGIN : Constants.VERTICAL_LOST_MODE_MARGIN;
    const offsetGridNum: number = this.isShowClock ? Constants.OFFSET_UP_1 : Constants.OFFSET_DOWN_2;
    this.slLayoutViewModal.updateAccountTopMargin(offsetGridNum);
    log.showInfo(`updateClockTopMargin accountTopMargin: ${this.slLayoutData.accountTopMargin}`);
  }

  updateClockParam() {
    log.showInfo(`updateClockParam`);
    if (!!this.themeClockParam) {
      this.themeClockParam.color = this.isBrightWallPaper ? '#000000' : '#ffffff';
      log.showInfo(`themeClockParam.textColor:${this.themeClockParam.color}`);
    }
  }

  private onLock(): void {
    if (this.isLock) {
      this.resetParam();
    }
  }

  private resetParam(): void {
    if (AppStorage.get('isLockAnimationStart')) {
      log.showInfo('Unlock animation is not complete');
      return;
    }
    log.showInfo('resetParam');
    this.passwordViewOpacity = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
    this.passwordViewScale = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
    this.passwordViewTranslate = LockScreenAnimationController.DEFAULT_TRANSLATE;
    this.passwordViewBlur = LockScreenAnimationController.DEFAULT_BLUR_RADIUS;
    this.clockAnim.resetParam();
  }

  unlockWithoutPassword() {
    if (this.passwordType === 'NONE') {
      log.showInfo('canUnlockWithoutPassword')
      let isShouldUnlock = sSettingsUtil.getValue(Constants.IS_SHOULD_UNLOCK, 'false') === 'true';
      let isCurrentUser = sSettingsUtil.getValue(Constants.CHECK_USER_ID, '-1') ===
      this.userData?.userId.toString();
      if (isShouldUnlock && isCurrentUser) {
        this.unlock();
      }
    }
    sSettingsUtil.setValue(Constants.IS_SHOULD_UNLOCK, 'false');
  }

  private async unlock(): Promise<void> {
    let selectedUsr: number | undefined = this.selectedUserID;
    log.showInfo(`click screen unlock, selectedUsr:${selectedUsr}`);
    if (!AccountsViewModel.getInstance().isCanUnlock()) {
      log.showInfo(`click screen unlock, can not unlock`);
      return;
    }
    if (this.selectedUserID !== Constants.INVALID_USER_ID && screenLockService.canUnlockWithoutPassword()) {
      if (await this.blockIfEnterpriseSpaceExpired()) {
        log.showInfo(`click screen unlock, but enterprise space expired`);
        return;
      }
      log.showInfo('LockScreenAnimationController doCallbacks');
      log.showInfo(`begin PASSWORD_UNLOCK_ANI`);
      performanceMonitor.begin(HiSysEventUtil.PASSWORD_UNLOCK_ANI, performanceMonitor.ActionType.LAST_DOWN);
      screenLockService.doUnLockAnimation(() => {
        if (!screenLockService.hasAuthType()) {
          AppStorage.setOrCreate(CommonConstants.LOCK_STATUS_KEY, ScreenLockStatus.UNLOCK);
          sSettingsUtil.setValue(Constants.IS_SHOULD_UNLOCK, 'false');
        }
        screenLockService.unlockScreen(false);
        screenLockService.notifyUnlockTransition();
        let currentUser: IUserData | undefined = AppStorage.get('currentUserItem');
        if (currentUser && !currentUser.isLoggedIn) {
          accountModel.onAccountSwitch(currentUser?.userId, () => {
            log.showInfo(`activate user success`);
          });
        }
      });
    }
    log.showInfo(`click screen unlock, canUnlockWithoutPassword(): ${screenLockService.canUnlockWithoutPassword()}`);
  }

  /**
   * SlideScreenLock aboutToAppear
   */
  public aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.screenLockModel.setScreenLockPrivacy(false);
    if (this.language === 'ug-CN' || this.language === 'ug') {
      this.panelMarginLeft = undefined;
      this.panelMarginRight = Constants.PANEL_MARGIN_RIGHT;
      this.centerX = '100%';
    } else {
      this.panelMarginLeft = Constants.PANEL_MARGIN_LEFT;
      this.panelMarginRight = undefined;
      this.centerX = '0%';
    }
    this.switchAccountAnimation();
    this.screenLockThemeManager.registerThemeActiveEvent(this);
    this.registerClockWidgetAnimation();
    this.mViewModel.viewModelInit();
    this.mComponentStyle.initStyle();
    this.backgroundBlur = 0;
    this.registerOpenCoverAnimationCallback();
    AccountsViewModel.getInstance().requestFocus = () => {
      this.requestFocus('switchUser');
    };
    AccountsViewModel.getInstance().passwordPush = '';
    this.dialogOffset = { dx: 0, dy: -px2vp(this.mViewModel.getDialogOffsetYInHalfFold()) };
    const offset: number = Constants.NO_OFFSET;
    this.slLayoutViewModal.initViewModel();
    this.slLayoutViewModal.updateAccountTopMargin(offset);
    this.slLayoutRotateAni.initAni(this.slLayoutData, false);
    AppStorage.setOrCreate('isWallPaperRegion',
      [this.slLayoutData.mainScreenProp?.width, this.slLayoutData.mainScreenProp?.height,
        this.slLayoutData.accountTopMarginInTotal]);
    log.showInfo(`aboutToAppear accountTopMargin: ${this.slLayoutData.accountTopMargin}`);
    ScreenLockFoldViewModel.getInstance().registerScreenLockLayoutChangeCallback(this.screenLockLayoutChangeCallback);
    this.registerKeyboardListener();
  }

  private screenLockLayoutChangeCallback: ScreenLockLayoutChangeCallback = {
    onForgetPwdMarginChange: (margin: number) => {
      log.showInfo(`onForgetPwdMarginChange, ${margin}`);
      this.forgetPwdMargin = margin;
    },
    onAccountTopGridNumChange: (offsetGridNum: number): void => {
      this.slLayoutViewModal.updateAccountTopMargin(offsetGridNum);
      log.showInfo(`onAccountTopMarginChange: gridCount: ${this.slLayoutData.gridRowCnt} ` +
        `offsetGridNum: ${offsetGridNum} ` +
        `accountTopMargin: ${this.slLayoutData.accountTopMargin}`);
      AppStorage.setOrCreate('isWallPaperRegion',
        [this.slLayoutData.mainScreenProp?.width, this.slLayoutData.mainScreenProp?.height,
          this.slLayoutData.accountTopMarginInTotal]);
    },
    onLostModeMarginChange: (margin: number) => {
      log.showInfo(`onLostModeMarginChange, ${margin}`);
      this.lostModeMarginTop = margin;
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

  /**
   * SlideScreenLock aboutToDisappear
   */
  public aboutToDisappear(): void {
    log.showInfo('aboutToDisAppear');
    this.slLayoutViewModal.destroy();
    this.slLayoutRotateAni.destroy();
    this.unregisterOpenCoverAnimationCallback();
    this.screenLockThemeManager.destroyThemeActiveEvent();
    ScreenLockFoldViewModel.getInstance().unregisterScreenLockLayoutChangeCallback(this.screenLockLayoutChangeCallback);
    this.unRegisterKeyboardListener();
  }

  /**
   * SlideScreenLock onPageShow
   */
  public onPageShow(): void {
    log.showInfo('onPageShow')
    this.mViewModel.onPageShow();
    this.isNeedUpdate = !this.isNeedUpdate;
  }

  /**
   * SlideScreenLock onPageHide
   */
  public onPageHide(): void {
    log.showInfo('onPageHide')
    this.mViewModel.onPageHide()
  }

  onThemeActivate(themeParam: LockscreenThemeConfig | undefined): void {
    log.showInfo(`Update screen lock theme params: ${JSON.stringify(themeParam?.clock)}`);
    this.themeClockParam = themeParam?.clock;
    this.updateClockParam();
  }

  private getScreenHeight(): number {
    try {
      return display.getDefaultDisplaySync().height;
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error.message}`);
      return 0;
    }
  }

  private getScreenWidth(): number {
    try {
      return display.getDefaultDisplaySync().width;
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error.message}`);
      return 0;
    }
  }

  private getGradientRadio(): number {
    let width = this.getScreenWidth() / 2;
    let height = this.getScreenHeight() / 2;
    let radio = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2));
    return px2vp(radio);
  }

  private onUserSwitch(): void {
    if (!this.accountSwitch) {
      this.backgroundBlur = 0;
      return;
    }
    this.backgroundBlur = BACKGROUND_BLUR;
    screenLockService.checkFingerprintForCurrentUser();
  }

  private registerClockWidgetAnimation(): void {
    LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.CLOCK_TIME_CALLBACK,
      () => {
        this.clockAnim.updateTimeViewParam();
      });

    LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.DATE_CALLBACK,
      () => {
        this.clockAnim.updateDateViewParam();
      });
  }

  private isDomain(): boolean | undefined {
    return this.userData?.availableAuthTypes?.includes(osAccount.AuthType.DOMAIN);
  }

  private isScreenLockNotVisibility(): boolean {
    return this.isPowerDialogShowed || this.accountSwitch;
  }

  private isClickPwdBlankArea(screenX: number, screenY: number): boolean {
    return (screenX >= 945 + 270 && screenX <= 945 && screenY >= 1203 + 50 && screenY <= 1203);
  }

  private doKeyEvent(keyEvent: KeyEvent) {
    log.showInfo(`doKeyEvent`);
    let inFocuskeyMap: boolean = AccountsViewModel.getInstance().focusKeyNumber.has(keyEvent.keyCode);
    if ((keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
      keyEvent.type === KeyType.Up && this.isPowerMenuPanelShowed) {
      this.isPowerMenuPanelShowed = false;
      focusControl.requestFocus(Constants.KEY_POWER_KEY);
    } else if (this.isPowerMenuPanelShowed === false && this.isInMultiAccountsView() === false && !inFocuskeyMap) {
      if (this.passwordType !== 'NONE') {
        this.requestPwdFocus();
      }
      AccountsViewModel.getInstance().passwordKeyEvent(keyEvent, this.userData?.userId);
      AccountsViewModel.getInstance().updateCapsLockStatus('doKeyEvent');
      this.passwordInitial = AccountsViewModel.getInstance().passwordPush;
      this.passwordInitial = (this.passwordInitial !== null && this.passwordInitial !== undefined) ?
        (AccountsViewModel.getInstance().isCapsLocked ? this.passwordInitial.toUpperCase() :
        this.passwordInitial.toLowerCase()) : '';
    }
  }

  private dealWithEndScreenOn() {
    log.showInfo(`dealWithEndScreenOn ：isEndScreenOn: ${this.isEndScreenOn}`);
    if (!this.isEndScreenOn) {
      this.isPowerMenuPanelShowed = false;
    }
    this.requestFocus('showScreenLock');
  }

  private showPowerDialog(): void {
    log.showInfo('showPowerDialog');
    this.isPowerDialogShowed = true;
    this.backgroundBlur = BACKGROUND_BLUR;
  }

  private cancelPowerDialog(): void {
    log.showInfo('cancelPowerDialog');
    this.isPowerDialogShowed = false;
    this.isPowerMenuPanelShowed = false;
    this.backgroundBlur = 0;
  }

  private requestFocus(reason: string = 'unknown'): void {
    let isSuccess = focusControl.requestFocus('ScreenLock-Accounts_Button_user' + this.userData?.userId)
    log.showInfo(`requestFocus because ${reason}, isSuccess = ${isSuccess}`)
  }

  private requestFocus2Pwd(): void {
    let isSuccess = focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
    log.showInfo(`requestFocus2Pwd, isSuccess = ${isSuccess}`)
  }


  private requestPwdFocus(): void {
    let isSuccess = focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
    this.slideScreenLockMoveFocus2Pwd = isSuccess;
    log.showInfo(`requestPwdFocus isSuccess = ${isSuccess}`)
  }

  private requestFocusDelay(): void {
    setTimeout(() => {this.requestFocus('requestFocusDelay')}, TIME_REQUEST_FOCUS);
  }

  private registerOpenCoverAnimationCallback(): void {
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.TIME_VIEW_ANIMATION, () => {
      this.clockAnim.isOpenCoverAnimation = true;
      this.clockAnim.timeViewOpacity = OpenCoverAnimationController.TIME_VIEW_OPACITY_BEGIN;
      this.clockAnim.timeViewDigitalScale = OpenCoverAnimationController.TIME_VIEW_SCALE_BEGIN;
      this.clockAnim.timeViewDigitalTranslate = OpenCoverAnimationController.TIME_VIEW_TRANSLATE_Y_BEGIN;
      this.clockAnim.extendedBlendModeViewHeight = OpenCoverAnimationController.TIME_DATA_VIEW_EXTENDED_HEIGHT;
    });
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.DATE_VIEW_ANIMATION, () => {
      this.clockAnim.dateViewOpacity = OpenCoverAnimationController.DATE_VIEW_OPACITY_BEGIN;
      this.clockAnim.dateViewScale = OpenCoverAnimationController.DATE_VIEW_SCALE_BEGIN;
      this.clockAnim.dateViewTranslate = OpenCoverAnimationController.DATE_VIEW_TRANSLATE_Y_BEGIN;
    });
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.WALLPAPER_VIEW_MASK_ANIMATION, () => {
      this.isWallpaperMaskShow = true;
      this.wallpaperMaskOpacity = OpenCoverAnimationController.DEFAULT_OPACITY;
      this.wallpaperMaskRadius = OpenCoverAnimationController.WALLPAPER_VIEW_MASK_RADIUS_BEGIN;
      this.wallpaperMaskScale = OpenCoverAnimationController.DEFAULT_SCALE;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.TIME_VIEW_ANIMATION, () => {
      this.clockAnim.timeViewOpacity = OpenCoverAnimationController.DEFAULT_OPACITY;
      this.clockAnim.timeViewDigitalScale = OpenCoverAnimationController.DEFAULT_SCALE;
      this.clockAnim.timeViewDigitalTranslate = OpenCoverAnimationController.DEFAULT_TRANSLATE;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.DATE_VIEW_ANIMATION, () => {
      this.clockAnim.dateViewOpacity = OpenCoverAnimationController.DEFAULT_OPACITY;
      this.clockAnim.dateViewScale = OpenCoverAnimationController.DEFAULT_SCALE;
      this.clockAnim.dateViewTranslate = OpenCoverAnimationController.DEFAULT_TRANSLATE;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.WALLPAPER_VIEW_MASK_ANIMATION, () => {
      this.wallpaperMaskOpacity = OpenCoverAnimationController.WALLPAPER_VIEW_MASK_OPACITY_END;
      this.wallpaperMaskRadius = OpenCoverAnimationController.WALLPAPER_VIEW_MASK_RADIUS_END;
      this.wallpaperMaskScale = OpenCoverAnimationController.WALLPAPER_VIEW_MASK_SCALE_END;
    });
  };

  private unregisterOpenCoverAnimationCallback(): void {
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.TIME_VIEW_ANIMATION);
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.DATE_VIEW_ANIMATION);
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.WALLPAPER_VIEW_MASK_ANIMATION);
  }


  private switchAccountAnimation(): void {
    if (this.isSwitchAnimation) {
      this.isCloseClockAnimation = false;
      this.clockAnim.timeViewScale = SwitchAccountAnimationParameter.timeViewScaleBegin;
      this.clockAnim.timeViewOpacity = SwitchAccountAnimationParameter.timeViewOpacityBegin;
      this.clockAnim.timeViewDigitalTranslate = SwitchAccountAnimationParameter.timeViewTranslateBegin;
      animateTo({
        delay: SwitchAccountAnimationParameter.timeViewTime,
        duration: 200 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Sharp
      }, () => {
        this.clockAnim.timeViewOpacity = SwitchAccountAnimationParameter.timeViewOpacityEnd;
      });
      animateTo({
        delay: SwitchAccountAnimationParameter.timeViewTime,
        duration: 400 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Friction,
        onFinish: () => {
          this.isCloseClockAnimation = true;
        }
      }, () => {
        this.clockAnim.timeViewScale = SwitchAccountAnimationParameter.timeViewScaleEnd;
        this.clockAnim.timeViewDigitalTranslate = SwitchAccountAnimationParameter.timeViewTranslateEnd;
      });
    }
  }

  private isInMultiAccountsView(): boolean {
    return this.selectedUserID === Constants.INVALID_USER_ID;
  }

  private handleFaceVerify(): void {
    if (this.isInMultiAccountsView()) {
      log.showInfo('Facial recognition is not triggered on multi accounts view.');
      return;
    }
    log.showInfo('handleFaceVerify');
    faceVerifyService.retryFaceVerify();
  }

  @Styles
  disabledStyles(): void {
    .scale({
      x: this.clockAnim.timeViewScale,
      y: this.clockAnim.timeViewScale,
      centerX: '50%',
      centerY: '100%',
    })
    .opacity(this.clockAnim.timeViewOpacity)
    .backgroundEffect({ radius: this.clockAnim.timeViewBlur })
    .translate({
      y: this.clockAnim.timeViewDigitalTranslate
    })
  }

  @Builder
  buildClock() {
    if (this.themeClockParam && this.isShowClock) {
      ClockWidget({
        themeClockParam: this.themeClockParam,
        clockAnim: this.clockAnim,
      })
        .id(COMPONENT_ID_SCREEN_LOCK_CLOCK)
        .enabled(this.isCloseClockAnimation)
        .opacity(this.clockAnim.timeViewOpacity)
        .stateStyles({
          disabled: this.disabledStyles,
        })
        .margin({
          top: this.slLayoutData.rotateParam?.clockMarginTop
        })
        .scale({
          x: this.slLayoutData.ratio,
          y: this.slLayoutData.ratio
        })
    }
  }

  /**
   * SlideScreenLock build
   */
  public build(): void {
    Stack({ alignContent: Alignment.Bottom }) {
      LostModePrompt({
        lostModeInfoMarginTop: this.lostModeMarginTop
      })

      StatusBar({
        isPowerMenuPanelShowed: this.isPowerMenuPanelShowed,
        style: this.mComponentStyle,
        isSwitchAnimation: this.isSwitchAnimation
      })

      if (this.accountSwitch) {
        Column() {
        }
        .width('100%')
        .height('100%')
        .radialGradient({
          center: ['50%', '50%'],
          radius: this.gradientRadius,
          colors: [['#40000000', 0], ['#00000000', 1]]
        })

        Column() {
        }
        .width('100%')
        .height('100%')
        .linearGradient({
          direction: GradientDirection.Top,
          colors: [['#40000000', 0], ['#00000000', 0.5]]
        })

        UserSwitchLoading()
      }

      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: this.slLayoutData.flexAlign
      }) {
        this.buildClock()
        if (this.remoteLockController.isRemoteLocked()) {
          Text(this.remoteLockController.getLockedTips())
            .draggable(false)
            .width('100%')
            .fontSize('21vp')
            .maxLines(1)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Regular)
            .fontFamily($r('app.float.pwd_prompt_font_family'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor($r('app.color.text_color'))
            .padding({ left: '8vp', right: '8vp' })
            .height(this.mComponentStyle.accountsHeight)
            .backgroundBlurStyle(BlurStyle.BACKGROUND_THICK, {
              colorMode: ThemeColorMode.DARK,
              adaptiveColor: AdaptiveColor.AVERAGE,
              policy: 1
            })
            .margin({
              top: (this.slLayoutData.gridRowCnt - 5) * Constants.GRID_WIDTH
            })
        } else {
          NewAccounts({
            selectedUserID: this.selectedUserID,
            isSwitchAnimation: this.isSwitchAnimation,
            isResetPwdByRecKeyPageShow: this.isResetPwdByRecKeyPageShow,
            isPinChangeTextShow: this.isPinChangeTextShow,
            passwordViewBlur: this.passwordViewBlur,
            passwordViewOpacity: this.passwordViewOpacity,
            passwordViewScale: this.passwordViewScale,
            passwordViewTranslate: this.passwordViewTranslate,
            slLayoutData: this.slLayoutData,
            hasRecoveryKey: this.hasRecoveryKey,
            passwordInitial: this.passwordInitial,
            isVirtualKeyboardActive: this.isVirtualKeyboardActive,
            slideScreenLockMoveFocus2Pwd: this.slideScreenLockMoveFocus2Pwd,
            unlockWithoutPassword: () => {
              this.unlockWithoutPassword();
            }
            })
            .margin({
              top: this.isVirtualKeyboardActive ? 10 : this.slLayoutData.accountTopMargin
            })
            .scale({
              x: this.slLayoutData.ratio,
              y: this.slLayoutData.ratio
            })
            .translate({
              y: this.slLayoutData.rotateParam?.userTranslateY,
            })
            .height(Constants.GRID_WIDTH * 2)
            .width('100%')
            .backgroundColor('#00000000')
        }
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .width('100%')
      .height('100%')
      .visibility(this.isScreenLockNotVisibility() ? Visibility.None : Visibility.Visible)
      .padding({
        top: $r('app.float.common_margin56'),
        left: $r('app.float.common_padding16'),
        right: $r('app.float.common_padding16'),
        bottom: $r('app.float.common_margin80')
      })

      Column() {
        if (this.isPinChangeTextShow) {
          ResetPinText({
            isPinChangeTextShow: this.isPinChangeTextShow,
            passwordViewBlur: this.passwordViewBlur,
            passwordViewOpacity: this.passwordViewOpacity,
            passwordViewScale: this.passwordViewScale,
            passwordViewTranslate: this.passwordViewTranslate,
          })
        } else {
          ResetPwdBtn()
        }

        Blank()
          .height(this.forgetPwdMargin)
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .visibility((this.isScreenLockNotVisibility() || this.selectedUserID === Constants.INVALID_USER_ID) ?
      Visibility.None : Visibility.Visible)

      if (!DeviceHelper.isEmulator()) {
        SCBScreenLockPowerPanel({
          onDialogShow: () => {this.showPowerDialog()},
          onDialogHide: () => {this.cancelPowerDialog()},
          dialogOffset: this.dialogOffset,
        }).key(Constants.KEY_POWER_MENU)
          .defaultFocus(true)
          .position({
            left: this.panelMarginLeft,
            right: this.panelMarginRight,
            top: Constants.STATUS_BAR_HEIGHT
          })
          .transition(
            TransitionEffect.asymmetric(
              TransitionEffect.scale({ x: StatusBarAnimConstants.SCALE,
                y: StatusBarAnimConstants.SCALE, centerX: this.centerX, centerY: 0
              })
                .animation({ curve: Curves.springMotion(StatusBarAnimConstants.SPRING_MOTION_RESPONSE,
                  StatusBarAnimConstants.SPRING_MOTION_DAMP) })
                .combine(TransitionEffect.OPACITY.animation({
                  duration: StatusBarAnimConstants.INSERT_OPACITY_DURATION, curve: Curve.Friction }))
              ,
              TransitionEffect.scale({ x: StatusBarAnimConstants.SCALE,
                y: StatusBarAnimConstants.SCALE, centerX: this.centerX, centerY: 0 })
                .animation({ curve: Curves.springMotion(StatusBarAnimConstants.SPRING_MOTION_RESPONSE,
                  StatusBarAnimConstants.SPRING_MOTION_DAMP) })
                .combine(TransitionEffect.OPACITY.animation({ duration: StatusBarAnimConstants.DEL_OPACITY_DURATION,
                  curve: Curve.Friction }))
            ))
          .visibility(((this.isLock && this.isPowerMenuPanelShowed && this.backgroundBlur === 0)) ? Visibility.Visible :
          Visibility.Hidden)
      }

      if (this.isWallpaperMaskShow) {
        Stack() {
        }
        .width('100%')
        .height('100%')
        .radialGradient({
          center: [OpenCoverAnimationController.WALLPAPER_VIEW_MASK_CENTER_X,
            OpenCoverAnimationController.WALLPAPER_VIEW_MASK_CENTER_Y],
          radius: OpenCoverAnimationController.WALLPAPER_VIEW_MASK_CENTER_Y,
          colors: [['#DD000000', 0.0], ['#FF000000', this.wallpaperMaskRadius]],
        })
        .opacity(this.wallpaperMaskOpacity)
        .scale({ x: this.wallpaperMaskScale, y: this.wallpaperMaskScale })
        .hitTestBehavior(HitTestMode.Transparent)
        .draggable(false)
        .focusable(false)
      }
    }
    .id(Constants.PC_COMPONENT_SLIDE_SCREEN_LOCK)
    .width('100%')
    .height('100%')
    .onFocus(() => {
      log.showInfo(`slideScreenLock focus`);
    })
    .focusable(this.focusAfterBoot)
    .onKeyEvent((event?: KeyEvent) => {
      if (event) {
        this.doKeyEvent(event);
      }
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down && (this.isDomain || this.passwordType !== 'NONE')) {
        this.handleFaceVerify();
        log.showInfo(`TextInput_onTouch - isPwdVisibleForPC: ${AppStorage.get('isPwdVisibleForPC')}`);
        if (!AppStorage.get('isPwdVisibleForPC')) {
          AppStorage.setOrCreate('isPwdVisibleForPC', true);
        }
        this.unlock();
      }
      if (event.type === TouchType.Down) {
        this.isPowerMenuPanelShowed = false;
        log.showInfo(`isPowerMenuPanelShowed click == ${this.isPowerMenuPanelShowed}`)
      }
    })
  }
}