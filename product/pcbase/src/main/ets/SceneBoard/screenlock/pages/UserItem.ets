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

import { LogDomain, LogHelper, CheckEmptyUtils, Trace } from '@ohos/basicutils';
import { DeviceHelper, HiDfxEventUtil, HiSysEventUtil, GlobalContext } from '@ohos/frameworkwrapper';
import OsAccount from '@ohos.account.osAccount';
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@ohos.base';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import ViewModel, { MultiKeyCode } from '../vm/AccountsViewModel';
import MixViewModel from '../vm/MixedPSDViewModel';
import { IUserData } from '@ohos/screenlockcommon';
import Constants from '../common/Constants';
import PasswordAndFaceVerify from '../pages/KeyguardPassword';
import osAccount from '@ohos.account.osAccount';
import { StrongAuthConstants, strongAuthManager } from '@ohos/screenlockcommon';
import accountModel, { AuthSubType } from '../refactor/AccountsModel';
import ScreenLockService from '../refactor/ScreenLockService';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import Curves from '@ohos.curves'
import UserIcon from './UserIcon';
import FingerprintViewModel from '../refactor/FingerprintViewModel';
import { OpenCoverAnimationController } from '../common/OpenCoverAnimationController';
import { BootCompletedAnimationController } from '../common/BootCompletedAnimationController';
import AccountsViewModel from '../vm/AccountsViewModel';
import { CommonStyle } from '../style/CommonStyle';
import { UserStyle } from '../style/UserStyle';
import ToastTip from '../component/ToastTip';
import PasswordComplexityViewModel from '../vm/PasswordComplexityViewModel';
import { DomainSlot } from '../component/DomainSlot';
import { PCUtils } from '../../../common/utils/PCUtils';
import { screenLockDataModel } from '../common/ScreenLockDataModel';
import { SwitchAccountAnimationParameter } from './SwitchAccountAnimation';
import {
  TipConfigsIndex, tipPriorityScheduler as tipPrioritySchedulerTask
} from '../common/TipPriority';
import { BaseSceneUnlockTip } from './BaseSceneUnlockTip';
import { FingerPrintVerifyTip } from './FingerPrintVerifyTip';
import { KeyCode } from '@kit.InputKit';
import { CustomizePromptViewModel } from '../vm/CustomizePromptViewModel';
import { SpecialModeViewModel } from '../vm/SpecialModeViewModel';
import { BiometricsDisAbleReason, biometricsVerifyService } from '../common/BiometricsVerifyService';
import { faceVerifyService } from '../common/FaceVerifyService';
import { promptAction } from '@kit.ArkUI';
import { SpecificScreenLockStateManager } from '../common/SpecificScreenLockStateManager';
import { SlLayoutData } from '../vm/SlLayoutData';
import { LengthMetrics } from '@kit.ArkUI';
import { SCBResetPwdManager } from '../common/SCBResetPwdManager';
import { ResetPassword } from './ResetPassword';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'ScreenLock-Accounts';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const RESET_TAG = 'ScreenLock-ResetPassword';
const STRONG_AUTH_PROMPT = 'STRONG_AUTH_PROMPT';
const SINGLE_USER_USER_LENGTH = 1;

const COMPONENT_ID_USER_ICON = TAG + '_Image_userIcon';
const COMPONENT_ID_BUTTON_USER = TAG + '_Button_user';
const COMPONENT_ID_BUTTON_RESET_PIN = TAG + '_Button_reset_pin';
// 双空间下第一个用户为企业用户
const FIRST_USER_ID: number = 100;

@Component
export default struct UserItem {
  private accountsStyle: AccountsComponentStyle | null = null;
  @State userImageOpacity: number = SwitchAccountAnimationParameter.userItemViewOpacityBegin;
  @State userImagescale: number = 0.8;
  @Prop @Watch('switchAccountAnimation') isSwitchAnimation: boolean;
  @State private isNeedUpdate: boolean = false;
  @State private isPinAuthing: boolean = false;
  @StorageLink('currentUserItem') private userData: IUserData | undefined = AppStorage.get('currentUserItem');
  @State psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  @StorageLink('passwordType') private passwordType: string = 'NONE';
  @Link @Watch('initAccountVM') userItem: IUserData | undefined;
  @State viewModel: ViewModel = new ViewModel();
  mixViewModel: MixViewModel = new MixViewModel();
  @StorageLink('mCurrentUserId') mCurrentUserId: number = 0;
  @StorageLink('accountSwitch') accountSwitch: boolean = false;
  @Link hasRecoveryKey: boolean;
  @State isIconHover: boolean = false;
  @State upOffset: number = 0;
  @Prop singleUser: boolean = false; // 是否只有一个用户
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @StorageLink('userName') userName: string = accountModel.userName;
  @StorageLink('isPwdVisibleForPC') isPwdVisibleForPC: boolean = true;
  @StorageProp('isEndScreenOn') @Watch('startRecoverPC') isEndScreenOn: boolean = true;
  @StorageLink('isLockAnimationStart') isLockAnimationStart: boolean = false;
  @StorageLink('forgetPinSceneprompt') forgetPinSceneprompt: string = '';
  @StorageLink('isScreenOn') isScreenOn: boolean = ScreenLockService.isScreenOn;
  @StorageLink('isEnterpriseAuthing') isEnterpriseAuthing: boolean = false;
  @StorageLink('isBeginSleepStart') @Watch('onBeginSleepOn') isBeginSleepStart: boolean = false;
  @StorageLink('isPinAvailable') @Watch('onPinAvailableChange') isPinAvailable: boolean = true;
  private defaultPasswordTip: string = '';
  @Link @Watch('onPinChangeText') isPinChangeTextShow: boolean;
  @StorageLink('isResetPwdPanelShow') isResetPwdPanelShow: boolean = false;
  private resetPwdReason: osAccount.AuthType = osAccount.AuthType.PIN;
  @Link isResetPwdByRecKeyPageShow: boolean;
  @State strongAuthPrompt: string = '';
  @Consume isPowerMenuPanelShowed: boolean;
  @State passwordPush: string | undefined = '';
  @Link selectedUserID: number;
  @Link passwordInitial: string;
  @Link slLayoutData: SlLayoutData;
  @Link slideScreenLockMoveFocus2Pwd: boolean;
  // For unlock screen animation
  @State userItemViewBlur: number = LockScreenAnimationController.DEFAULT_BLUR_RADIUS;
  @State userItemViewOpacity: number = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
  @State userItemViewScale: number = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
  @State userItemViewTranslate: number | string = LockScreenAnimationController.DEFAULT_TRANSLATE;
  @Link passwordViewBlur: number;
  @Link passwordViewOpacity: number;
  @Link passwordViewScale: number;
  @Link passwordViewTranslate: number | string;
  @Consume fingerprintViewModel: FingerprintViewModel;
  @State userItemRingOpacity: number = OpenCoverAnimationController.LIGHT_VIEW_OPACITY_BEGIN;
  @Consume customizePromptVM: CustomizePromptViewModel;
  @Consume @Watch('requestFocusForBoot') focusAfterBoot: boolean;
  @State hoverTimer: number = -1;
  @StorageLink('systemLanguage') systemLanguage: string = Constants.SYSTEM_LANGUAGE_CHINESE;
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @State userStyle: UserStyle = UserStyle.getInstance();
  @StorageProp(StrongAuthConstants.STRONG_AUTH_REASON) strongAuthStatus: number =
    StrongAuthConstants.NO_NEED_STRONG_AUTH;
  toastMaskOffset: string = '89.3%';
  toastTextOffset: string = '41.2%';
  @State fingerPrintTipVisible: boolean = false;
  @State isPasswordShow: boolean = false;
  @State baseScreenUnlockTipVisible: boolean = true;
  @State faceVerifyTipVisible: boolean = false;
  @State focusBoxColor: Color | Resource = Color.Transparent;
  @Link haveTryUnlock: boolean;
  @Link isVirtualKeyboardActive: boolean | undefined;
  @StorageProp('isLock') @Watch('onLock') isLock: boolean = true;
  private unlockWithoutPassword: () => void = () => {};
  private isPCMode: boolean = DeviceHelper.is2In1DevicePcType();
  private pageToastController: CustomDialogController = new CustomDialogController({
    builder: ToastTip({
      message: $r('app.string.psd_change_success')
    }),
    customStyle: true,
    autoCancel: false,
    maskRect: {
      x: 0,
      y: this.toastMaskOffset,
      width: '100%',
      height: $r('app.float.height_44')
    },
    // mask设置为透明
    maskColor: Color.Transparent,
    offset: { dx: 0, dy: this.toastTextOffset }
  });

  private onLock(): void {
    if (this.isLock) {
      this.resetParam();
    }
  }

  private resetParam(): void {
    if (AppStorage.get('isLockAnimationStart')) {
      return;
    }
    log.showInfo('resetParam');
    this.userItemViewOpacity = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
    this.userItemViewScale = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
    this.userItemViewTranslate = LockScreenAnimationController.DEFAULT_TRANSLATE;
    this.userItemViewBlur = LockScreenAnimationController.DEFAULT_BLUR_RADIUS;
    setTimeout(() => {
      // 窗口获焦需一帧左右，窗口获焦后，组件才能获焦。
      this.requestFocus('resetParam');
    }, 30)
  }

  private onHoverChanged: Callback<boolean> = (isHover: boolean) => {
    log.showInfo(`hover userHead to selectUser ${isHover}`);
    this.isIconHover = isHover;
    if (this.isEnterpriseAuthing) {
      log.showInfo('enterprise account is authing');
      return;
    }
    if (SpecialModeViewModel.getInstance().specialViewData.lastModeData.isLostMode) {
      log.showInfo('isLostMode not selectMultiUser');
      return;
    }
    let allUserNum: number | undefined = AppStorage.get('createdListLen');
    if (!allUserNum || allUserNum <= 1 || this.isResetPwdPanelShow || this.isResetPwdByRecKeyPageShow) {
      log.showInfo(`allUserLength:${allUserNum}`);
      return;
    }
    if (isHover && this.isScreenOn) {
      this.hoverTimer = setTimeout(() => {
        if (LockScreenAnimationController.getInstance().getUnlockingStatus()) {
          log.showWarn('isUnlocking, icon hover is skipped');
          return;
        }
        this.selectedUserID = Constants.INVALID_USER_ID;
        AccountsViewModel.getInstance().selectedUserId = Constants.INVALID_USER_ID;
        this.hoverTimer = -1;
      }, 700);
    }
    if (!isHover && this.hoverTimer != Constants.INVALID_USER_ID) {
      clearTimeout(this.hoverTimer);
      this.hoverTimer = -1;
    }
  }

  private onBeginSleepOn(): void {
    this.hasRecoveryKeyExported();
    if (!this.strongAuthPrompt) {
      this.viewModel.GetPinAuthProperty();
    }
    this.isPinAvailable = true;
    this.isResetPwdPanelShow = false;
    this.isResetPwdByRecKeyPageShow = false;
    this.isPinChangeTextShow = false;
    let isFingerprintAuthOn = this.fingerprintViewModel.getIsFingerprintEnable();
    if (isFingerprintAuthOn) {
      this.customizePromptVM.isShowPrompt = true;
      if (this.isBeginSleepStart) {
        this.customizePromptVM.prompt = '';
      }
      return;
    }
    this.customizePromptVM.isShowPrompt = false;
  }

  onPinAvailableChange() {
    log.showInfo(`onPinAvailableChange, this isPinAvailable value : ${this.isPinAvailable}`);
    if (!this.isPinAvailable) {
      this.isPinChangeTextShow = true;
      biometricsVerifyService.pushDisableReason(BiometricsDisAbleReason.PASSWORD_EXPIRED);
    } else {
      this.isPinChangeTextShow = false;
    }
  }

  onPinChangeText() {
    if (this.isPinChangeTextShow) {
      if (this.customizePromptVM.prompt === ResUtils.getInnerString($r('app.string.psd_has_expired'))) {
        this.resetPwdReason = osAccount.AuthType.FINGERPRINT;
      } else {
        this.resetPwdReason = osAccount.AuthType.PIN;
      }
    }
  }

  requestFocusForBoot() {
    this.requestFocus('requestFocusForBoot');
    this.hasRecoveryKeyExported();
  }

  initAccountVM(): void {
    if (this.userItem && !AccountsViewModel.getInstance().selectedUserId) {
      AccountsViewModel.getInstance().selectedUserId = this.userItem?.userId;
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    try {
      let preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: RESET_TAG });
      this.strongAuthPrompt = preferences.getSync(STRONG_AUTH_PROMPT, '') as string;
      screenLockDataModel.setPromptValue(this.strongAuthPrompt);
      if (!CheckEmptyUtils.checkStrIsEmpty(this.strongAuthPrompt)) {
        SCBResetPwdManager.getInstance().setResetPwdEntry(false, 'useritem');
      }
      this.switchAccountAnimation();
      this.registerOpenCoverAnimationCallback();
      this.registerBootCompletedAnimationCallback();
      this.viewModel.updateCapsLockStatus('aboutToAppear');
      if (!this.strongAuthPrompt) {
        this.viewModel.GetPinAuthProperty();
      }
      this.fingerPrintTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
      this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
      this.baseScreenUnlockTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
      this.hasRecoveryKeyExported();
    } catch (error) {
      log.error(TAG, `aboutToAppear init error: ${error}`);
    }
  }

  async hasRecoveryKeyExported(): Promise<void> {
    try {
      log.showInfo('hasRecoveryKey hasRecoveryKeyExported');
      let userIDM: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      let arrCredInfos: osAccount.EnrolledCredInfo[] = await userIDM.getAuthInfo(OsAccount.AuthType.RECOVERY_KEY);
      let recoverKeyCredInfoObj: osAccount.EnrolledCredInfo = arrCredInfos[0];
      log.showInfo(`hasRecoveryKey recoverKeyCredInfoObj?.authType:${recoverKeyCredInfoObj?.authType}`);
      if (recoverKeyCredInfoObj?.credentialId && recoverKeyCredInfoObj?.authType === OsAccount.AuthType.RECOVERY_KEY) {
        this.hasRecoveryKey = true;
      } else {
        this.hasRecoveryKey = false;
      }
    } catch (error) {
      log.showError(`hasRecoveryKey check error: ${error}`);
    }
    log.showInfo(`hasRecoveryKey: ${this.hasRecoveryKey}`);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.unregisterOpenCoverAnimationCallback();
    this.unregisterBootCompletedAnimationCallback();
    this.pageToastController.close();
    if (!this.strongAuthPrompt) {
      this.viewModel.GetPinAuthProperty();
    }
    this.customizePromptVM.clearPrompt();
    this.unlockWithoutPassword = (): void => {};
   }

  private showPrompts(): boolean {
    log.showInfo(`getIsFingerprintEnable: ${this.fingerprintViewModel.getIsFingerprintEnable()}`)
    return this.singleUser && this.fingerprintViewModel.getIsFingerprintEnable()
  }

  private requestFocus(reason?: string): void {
    let isSuccess = focusControl.requestFocus(`${COMPONENT_ID_USER_ICON}_${this.userItem?.userId}`);
    log.showInfo(`requestFocus reason:${reason}, isSuccess = ${isSuccess}`);
  }

  private registerHideAnimation() {
    LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.USER_ITEM_CALLBACK,
      () => {
        this.userItemViewOpacity = LockScreenAnimationController.OPACITY_RATIO;
        this.userItemViewScale = LockScreenAnimationController.USER_ITEM_SCALE_RATIO;
        this.userItemViewTranslate = LockScreenAnimationController.USER_ITEM_TRANSLATE;
        this.userItemViewBlur = LockScreenAnimationController.BLUR_RADIUS;
      });
    LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.PASSWORD_CALLBACK,
      () => {
        this.passwordViewOpacity = LockScreenAnimationController.OPACITY_RATIO;
        this.passwordViewScale = LockScreenAnimationController.PASSWORD_SCALE_RATIO;
        this.passwordViewTranslate = LockScreenAnimationController.PASSWORD_TRANSLATE;
        this.passwordViewBlur = LockScreenAnimationController.BLUR_RADIUS;
      });
  }

  private isBuildIcon(): boolean {
    // 提前buildIcon中的Emoji头像会导致屏幕显示时emoji的表情异常，故需要在合适的时机buildEmoji
    log.showInfo(`buildIcon: ${this.isScreenOn}`);
    return this.isScreenOn;
  }

  private startRecoverPC(): void {
    log.showInfo(`isEndScreenOn = ${this.isEndScreenOn}`);
    if (this.passwordType === 'NONE') {
      let isSuccess: boolean = focusControl.requestFocus(`ScreenLock-Accounts_Image_userIcon_${this.userData?.userId}`);
      let selectedUsr: number | undefined = AccountsViewModel.getInstance().selectedUserId;
      log.showInfo(`requestFocus on ScreenLock-Accounts_Image_userIcon: ${isSuccess}, ${selectedUsr}`);
    } else {
      AppStorage.setOrCreate('isPwdVisibleForPC', true);
    }
  }

  isSelected() {
    return this.userItem?.userId === this.mCurrentUserId;
  }

  private isMultiUserAndSelected(): boolean {
    return this.isSelected() && !this.singleUser;
  }

  getAuthType(): AuthSubType {
    return (ScreenLockService.isDomainAuthType()) ? AuthSubType.DOMAIN_MIXED : AuthSubType.PIN_MIXED;
  }

  private isAuthMenuShow(): boolean | undefined {
    return this.userData?.isDomain && this.passwordType !== 'NONE';
  }

  private userItemOffset(): Position {
    if (this.isAuthMenuShow()) {
      return this.isResetPwdPanelShow || this.isResetPwdByRecKeyPageShow ? {
        y: $r('app.float.screenLock_user_layout_reset_pin_offset_y')
      } :
        { y: $r('app.float.screenLock_user_layout_nodomain_pin_offset_y') };
    }
    return this.isResetPwdPanelShow || this.isResetPwdByRecKeyPageShow ? {
      y: $r('app.float.screenLock_user_layout_reset_pin_offset_y')
    } :
      { y: $r('app.float.screenLock_user_layout_nodomain_pin_offset_y') };
  }

  private isDomain(): boolean | undefined {
    return this.userData?.availableAuthTypes?.includes(osAccount.AuthType.DOMAIN);
  }

  private registerOpenCoverAnimationCallback(): void {
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.USER_VIEW_ANIMATION, () => {
      this.userItemViewOpacity = OpenCoverAnimationController.USER_ITEM_VIEW_OPACITY_BEGIN;
      this.userItemViewScale = OpenCoverAnimationController.USER_ITEM_VIEW_SCALE_BEGIN;
      this.userItemViewTranslate = OpenCoverAnimationController.USER_ITEM_VIEW_TRANSLATE_Y_BEGIN;
    });
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.LIGHT_VIEW_ANIMATION, () => {
      this.userItemRingOpacity = OpenCoverAnimationController.LIGHT_VIEW_OPACITY_BEGIN;
    });
    OpenCoverAnimationController.getInstance().registerInitParamCallback(
      OpenCoverAnimationController.PASSWORD_VIEW_ANIMATION, () => {
      this.passwordViewOpacity = OpenCoverAnimationController.PASSWORD_VIEW_OPACITY_BEGIN;
      this.passwordViewScale = OpenCoverAnimationController.PASSWORD_VIEW_SCALE_BEGIN;
      this.passwordViewTranslate = OpenCoverAnimationController.PASSWORD_VIEW_TRANSLATE_Y_BEGIN;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.USER_VIEW_ANIMATION, () => {
      this.userItemViewOpacity = OpenCoverAnimationController.DEFAULT_OPACITY;
      this.userItemViewScale = OpenCoverAnimationController.DEFAULT_SCALE;
      this.userItemViewTranslate = OpenCoverAnimationController.DEFAULT_TRANSLATE;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.LIGHT_VIEW_ANIMATION, () => {
      this.userItemRingOpacity = OpenCoverAnimationController.LIGHT_VIEW_OPACITY_END;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_FINISH, () => {
      this.userItemRingOpacity = OpenCoverAnimationController.LIGHT_VIEW_OPACITY_BEGIN;
    });
    OpenCoverAnimationController.getInstance().registerAnimationCallback(
      OpenCoverAnimationController.PASSWORD_VIEW_ANIMATION, () => {
      this.passwordViewOpacity = OpenCoverAnimationController.DEFAULT_OPACITY;
      this.passwordViewScale = OpenCoverAnimationController.DEFAULT_SCALE;
      this.passwordViewTranslate = OpenCoverAnimationController.DEFAULT_TRANSLATE;
    });
  };

  private unregisterOpenCoverAnimationCallback(): void {
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.USER_VIEW_ANIMATION);
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.LIGHT_VIEW_ANIMATION);
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_FINISH);
    OpenCoverAnimationController.getInstance().unregisterCallback(
      OpenCoverAnimationController.PASSWORD_VIEW_ANIMATION);
  }

  private registerBootCompletedAnimationCallback(): void {
    BootCompletedAnimationController.getInstance().registerInitParamCallback(
      BootCompletedAnimationController.USER_ITEM_ANIMATION, () => {
      this.userItemViewOpacity = BootCompletedAnimationController.USER_ITEM_OPACITY_BEGIN;
      this.userItemViewScale = BootCompletedAnimationController.USER_ITEM_SCALE_BEGIN;
    });
    BootCompletedAnimationController.getInstance().registerInitParamCallback(
      BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION, () => {
      this.passwordViewOpacity = BootCompletedAnimationController.PASSWORD_ITEM_OPACITY_BEGIN;
      this.passwordViewScale = BootCompletedAnimationController.PASSWORD_ITEM_SCALE_BEGIN;
      this.passwordViewTranslate = BootCompletedAnimationController.PASSWORD_ITEM_TRANSLATE_Y_BEGIN;
    });
    BootCompletedAnimationController.getInstance().registerAnimationCallback(
      BootCompletedAnimationController.USER_ITEM_ANIMATION, () => {
      this.userItemViewOpacity = BootCompletedAnimationController.DEFAULT_OPACITY;
      this.userItemViewScale = BootCompletedAnimationController.DEFAULT_SCALE;
    });
    BootCompletedAnimationController.getInstance().registerAnimationCallback(
      BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION, () => {
      this.passwordViewOpacity = BootCompletedAnimationController.DEFAULT_OPACITY;
      this.passwordViewScale = BootCompletedAnimationController.DEFAULT_SCALE;
      this.passwordViewTranslate = BootCompletedAnimationController.DEFAULT_TRANSLATE;
    });
    BootCompletedAnimationController.getInstance().prepareScreenLockBootCompletedAnimation();
  };

  private unregisterBootCompletedAnimationCallback(): void {
    BootCompletedAnimationController.getInstance().unregisterCallback(
      BootCompletedAnimationController.USER_ITEM_ANIMATION);
    BootCompletedAnimationController.getInstance().unregisterCallback(
      BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION);
  }

  private userIconEffect(): void {
    if (!this.isPwdVisibleForPC) {
      return;
    }
    animateTo({ curve: Curves.interpolatingSpring(0, 1, 200, 22), duration: 270, delay: 100 }, () => {
      this.upOffset = -10;
    });
    animateToImmediately({ curve: Curves.interpolatingSpring(0, 1, 200, 22), duration: 200, delay: 370 }, () => {
      this.upOffset = 0;
    });
  }

  private unLockCallback = (): void => {
    ScreenLockService.unlocking(false);
    ScreenLockService.notifyUnlockTransition(osAccount.AuthType.PIN);
    strongAuthManager.resetReason();
    AppStorage.setOrCreate('isEmojiAuthSuccess', true);
    let preferences: dataPreferences.Preferences | null = null;
    try {
      preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: RESET_TAG });
      preferences.putSync(STRONG_AUTH_PROMPT, '');
      preferences.flush(() => {
      });
    } catch (err) {
      log.showError(` getPreferencesSync error, BusinessError code is ${(err as BusinessError).code}`);
    }
  }

  private accountClick() {
    if (this.accountSwitch) {
      log.showWarn('is switching cannot click');
      return;
    }

    if (!this.isScreenOn) {
      log.showInfo('screen off, stay on screen-lock');
      return;
    }

    log.showInfo('click userPhoto unlock');
    ScreenLockService.refreshUnlockStartTime();
    HiDfxEventUtil.reportButtonEvent(HiSysEventUtil.TOUCH_EVENT);
    if (ScreenLockService.canUnlockWithoutPassword()) {
      log.showInfo('LockScreenAnimationController doCallbacks');
      ScreenLockService.doUnLockAnimation(() => {
        ScreenLockService.unlockScreen(false);
        ScreenLockService.notifyUnlockTransition();
        let currentUser: IUserData | undefined = AppStorage.get('currentUserItem');
        if (currentUser && !currentUser.isLoggedIn) {
          accountModel.onAccountSwitch(currentUser?.userId, () => {
            log.showInfo(`activate user success`);
          })
        }
      });
    } else {
      ScreenLockService.unlockScreen();
    }
  }

  private showRecoveryKeySuccessToast(): void {
    try {
      promptAction.showToast({
        message: $r('app.string.psd_change_success'),
        duration: 2000,
        showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
      });
    } catch (error) {
      log.showError(`showRecoveryKeySuccessToast error ${error}`);
    }
  }

  private jumpPinAuthFromResetPin(isResetSuc: boolean): void {
    this.isResetPwdPanelShow = false;
    let isFingerprintAuthOn = this.fingerprintViewModel.getIsFingerprintEnable();
    log.showInfo(`jumpPinAuthFromResetPin isFingerprintAuthOn: ${isFingerprintAuthOn}`);
    if (isResetSuc) {
      this.showRecoveryKeySuccessToast();
      this.isPinAvailable = true;
      if (this.resetPwdReason === osAccount.AuthType.FINGERPRINT) {
        this.customizePromptVM.setPromptByUserBehavior('');
      } else {
        this.defaultPasswordTip = '';
      }
      return;
    }
    focusControl.requestFocus(COMPONENT_ID_BUTTON_RESET_PIN);
    this.isPinAvailable = false;
    if (this.resetPwdReason === osAccount.AuthType.FINGERPRINT) {
      this.customizePromptVM.setPromptByUserBehavior(ResUtils.getInnerString($r('app.string.psd_has_expired')));
    } else {
      this.defaultPasswordTip = ResUtils.getInnerString($r('app.string.psd_has_expired'));
    }
  }

  private switchAccountAnimation(): void {
    log.showInfo(`Star Animation`);
    if (this.isSwitchAnimation) {
      Trace.start('SWITCHACCOUNTANIMATION_SCB2');
      this.userItemViewOpacity = SwitchAccountAnimationParameter.userItemViewOpacityBegin;
      this.userImagescale = SwitchAccountAnimationParameter.userImagescaleBegin;
      this.passwordViewOpacity = SwitchAccountAnimationParameter.passwordViewOpacityBegin;

      animateTo({
        delay: SwitchAccountAnimationParameter.delay,
        duration: 300 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Sharp
      }, () => {
        this.userItemViewOpacity = SwitchAccountAnimationParameter.userImageOpacityEnd;
      })
      animateTo({
        delay: SwitchAccountAnimationParameter.delay,
        duration: 300 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Friction
      }, () => {
        this.userImagescale = SwitchAccountAnimationParameter.userImagescaleEnd;
      })
      animateTo({
        delay: SwitchAccountAnimationParameter.passwordViewTime,
        duration: 200 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Sharp
      },
        () => {
          this.passwordViewOpacity = SwitchAccountAnimationParameter.passwordViewOpacityEnd;
        })

    }
  }

  private getIconFocusable(): boolean {
    if (this.isPowerMenuPanelShowed || this.isResetPwdPanelShow || this.isResetPwdByRecKeyPageShow) {
      return false;
    }
    if (this.isPasswordShow && this.isEndScreenOn) {
      return false;
    }
    return true;
  }

  private onUserIconClickHandle() {
    if (this.isResetPwdPanelShow) {
      return;
    }
    log.showInfo('onUserIconClickHandle');
    this.accountClick();
  }

  private handleFaceVerify(): void {
    log.showInfo('handleFaceVerify');
    faceVerifyService.retryFaceVerify();
  }

  private unlockWithoutPW(): void {
    if (SpecificScreenLockStateManager.getIsNotifyLockScreen()) {
      this.unlockWithoutPassword();
    } else {
      setTimeout(() => {
        this.unlockWithoutPassword();
      }, 100)
    }
  }

  // 节流函数
  private lastExecTime: number = 0; // 上次执行时间戳

  private throttle(func: () => void, delay: number = 200) {
    const now: number = Date.now();
    // 只有当距离上次执行时间超过间隔时才执行
    if (now - this.lastExecTime >= delay) {
      func();
      this.lastExecTime = now; // 更新最后执行时间
    }
  }

  @Builder
  singleUserIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Stack()
        .opacity(this.userItemRingOpacity)
        .backgroundColor($r('app.color.transparent'))
        .width(this.accountsStyle?.userIconWidth)
        .height(this.accountsStyle?.userIconHeight)
        .borderRadius(this.accountsStyle?.userIconRadius)
        .shadow({
          radius: OpenCoverAnimationController.LIGHT_VIEW_SHADOW_RADIUS,
          color: OpenCoverAnimationController.LIGHT_VIEW_COLOR
        })
        .focusable(false)
      if (this.isBuildIcon() && !this.isPCMode) {
        UserIcon({
          currentUserId: this.userItem?.userId,
          accountsStyle: this.accountsStyle
        })
      }
    }
    .id(`${COMPONENT_ID_USER_ICON}_${this.userItem?.userId}`)
    .defaultFocus(!this.isPCMode)
    .onAppear(() => {
      this.requestFocus('onAppear');
      this.registerHideAnimation();
    })
    .onFocus(() => {
      log.showInfo(`automatically unlock without password when the user is switched`);
      this.unlockWithoutPW();
    })
    .width(this.accountsStyle?.userIconWidth)
    .height(this.accountsStyle?.userIconHeight)
    .border({
      width: this.isPCMode ? '0px' : '0px',
      color: $r('app.color.screen_lock_text_frame_outline'),
      radius: this.accountsStyle?.userIconWidth
    })
    .focusBox({
      strokeWidth: this.isPCMode ? LengthMetrics.vp(0) : LengthMetrics.vp(2)
    })
    .scale({
      x: this.userImagescale,
      y: this.userImagescale,
      z: this.userImagescale,
      centerX: '50%',
      centerY: '50%'
    })
    .onClick((event: ClickEvent) => {
      let userLength: number | undefined = AppStorage.get('createdListLen');
      log.showInfo(`ClickEvent:${userLength} ${this.isResetPwdPanelShow}`);
      if (event.source === Constants.SOURCE_TYPE_KEYBOARD || userLength === SINGLE_USER_USER_LENGTH) {
        this.throttle((): void => this.onUserIconClickHandle(), 200);
      }
    })
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
      this.isPowerMenuPanelShowed = false;
      if (this.isEnterpriseAuthing) {
        log.showInfo('enterprise account is authing');
        return;
      }
      if (SpecialModeViewModel.getInstance().specialViewData.lastModeData.isLostMode) {
        log.showInfo('isLostMode not selectMultiUser');
        return;
      }
      let allUserNum: number | undefined = AppStorage.get('createdListLen');
      if (!allUserNum || allUserNum <= 1 || this.isResetPwdPanelShow || this.isResetPwdByRecKeyPageShow) {
        log.showInfo(`allUserLength:${allUserNum}`);
        return;
      }
      if (this.isScreenOn) {
        log.showInfo(`isScreenOn: ${this.isScreenOn}`);
        if (this.hoverTimer != Constants.INVALID_USER_ID) {
          clearTimeout(this.hoverTimer);
        }
        this.hoverTimer = setTimeout(() => {
          if (LockScreenAnimationController.getInstance().getUnlockingStatus()) {
            log.showWarn('isUnlocking, icon touch is skipped');
            return;
          }
          this.selectedUserID = Constants.INVALID_USER_ID;
          AccountsViewModel.getInstance().selectedUserId = Constants.INVALID_USER_ID;
          this.hoverTimer = -1;
        }, 20);
      }

    })
    .backgroundColor(this.isIconHover ? $r('sys.color.ohos_id_color_hover') : '#00000000')
    .margin({ top: 2 })
    .onHover(this.onHoverChanged)
    .backgroundEffect({ radius: this.userItemViewBlur })
    .opacity(this.userItemViewOpacity)
    .scale({
      x: this.userItemViewScale,
      y: this.userItemViewScale
    })
    .translate({
      y: this.userItemViewTranslate
    })
    .focusable(this.getIconFocusable())
    .onFocus(() => {
      log.showInfo(`singleUserIcon - onFocus: ${this.getIconFocusable()}`);
    })
    .onKeyEvent((event: KeyEvent) => {
      log.showInfo('singleUserIcon - onKeyEvent');
      if (event.type === KeyType.Down &&
        (this.passwordType === 'NONE' || !AppStorage.get('isPwdVisible')) &&
        (this.viewModel.passwordNumber.has(event.keyCode) || event.keyCode === KeyCode.KEYCODE_ENTER ||
          event.keyCode === KeyCode.KEYCODE_SPACE || event.keyCode === KeyCode.KEYCODE_DPAD_DOWN ||
          event.keyCode === KeyCode.KEYCODE_DPAD_UP || event.keyCode === KeyCode.KEYCODE_DPAD_LEFT ||
          event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT || event.keyCode === KeyCode.KEYCODE_NUMPAD_ENTER)) {
        this.onUserIconClickHandle();
      }
    })
  }

  @Builder
  singleUserName() {
    Row() {
      if (PCUtils.getIsEnterSpaceEnabled() && this.userItem?.userId == FIRST_USER_ID) {
        this.enterpriseSpaceIcon()
      }
      if (!this.isPCMode) {
        // this.accountName()
      }
      if (!PCUtils.getIsEnterSpaceEnabled() && this.userItem?.isDomain) {
        DomainSlot({
          textMarginLeft: this.userStyle.domainSlotTextMarginLeft,
          iconMarginLeft: this.userStyle.domainSlotIconMarginLeft,
          marginBottom: this.userStyle.domainSlotMarginBottom
        })
      }
    }
    .height(this.userStyle.userNameHeight)
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.Center)
    .margin({
      top: this.accountsStyle?.userNameTopMargin
    })
    .backgroundEffect({ radius: this.userItemViewBlur })
    .opacity(this.userItemViewOpacity)
    .scale({
      x: this.userItemViewScale,
      y: this.userItemViewScale
    })
    .translate({
      y: this.userItemViewTranslate
    })
  }

  @Builder
  enterpriseSpaceIcon() {
    Image($r('app.media.ic_Enterprise'))
      .id('enterpriseIcon')
      .size({ width: 20, height: 20 })
      .align(Alignment.Bottom)
      .clip(false)
      .margin({
        bottom: $r('app.float.common_margin9'),
        right: $r('app.float.common_margin5')
      })
  }

  @Builder
  accountName() {
    Text(this.userItem?.userName)
      .draggable(false)
      .id('row1')
      .constraintSize({ maxWidth: 226 })
      .fontSize(this.isPCMode ? '18vp' : '22vp')
      .wordBreak(WordBreak.BREAK_ALL)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .maxLines(1)
      .textAlign(TextAlign.End)
      .align(Alignment.Bottom)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS-Sans-Digit,HarmonyOS-Sans')
      .fontColor(this.isBrightOrDark ? $r('app.color.user_name_bright_text_color') : $r('app.color.text_color'))
      .textShadow(this.isBrightOrDark ? undefined : this.accountsStyle?.userNameShadows)
      .opacity($r('app.float.screenLock_user_layout_hover_opacity'))
      .clip(false)
      .margin({ bottom: this.userStyle.userNameMarginBottom })
  }

  @Builder
  resetPinPswBuilder() {
    Column() {
      ResetPassword({
        isPinExpire: true,
        jumpPinAuthFromResetPin: (isResetSuc: boolean) => this.jumpPinAuthFromResetPin(isResetSuc),
      })
    }.width('100%')
    .onTouch(event => {
      event.stopPropagation();
      this.isPowerMenuPanelShowed = false;
    })
    .margin({ top: $r('app.float.screenLock_reset_psw_margin') })
  }

  @Builder
  keyguardPassword() {
    Column() {
      PasswordAndFaceVerify({
        isNeedUpdate: this.isNeedUpdate,
        isPinAuthing: this.isPinAuthing,
        isAuthMenuShow: this.isAuthMenuShow(),
        isDomainEnable: this.isDomain(),
        passwordPush: this.passwordPush,
        accountVM: this.viewModel,
        psdcVM: this.psdcVM,
        isPasswordShow: this.isPasswordShow,
        defaultPasswordTip: this.defaultPasswordTip,
        fingerPrintTipVisible: this.fingerPrintTipVisible,
        faceVerifyTipVisible: this.faceVerifyTipVisible,
        baseScreenUnlockTipVisible: this.baseScreenUnlockTipVisible,
        haveTryUnlock: this.haveTryUnlock,
        passwordInitial: this.passwordInitial,
        slLayoutData: this.slLayoutData,
        slideScreenLockMoveFocus2Pwd: this.slideScreenLockMoveFocus2Pwd,
        unLockScreenCallback: () => {
          ScreenLockService.doUnLockAnimation(this.unLockCallback);
        }
      })
    }
    .margin({ top: '8vp' })
    .backgroundEffect({ radius: this.passwordViewBlur })
    .opacity(this.passwordViewOpacity)
    .scale({
      x: this.passwordViewScale,
      y: this.passwordViewScale
    })
    .translate({ y: this.passwordViewTranslate })
    .onAppear(() => {
      this.userIconEffect();
    })
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
      this.isPowerMenuPanelShowed = false;
    })
  }

  @Builder
  tipGroup() {
    Column() {
      FingerPrintVerifyTip({
        onTipChange: this.onFingerprintTipChange.bind(this),
        visible: this.fingerPrintTipVisible
      })
      BaseSceneUnlockTip({ visible: this.baseScreenUnlockTipVisible })
    }
    .backgroundEffect({ radius: this.passwordViewBlur })
    .opacity(this.passwordViewOpacity)
    .scale({
      x: this.passwordViewScale,
      y: this.passwordViewScale
    })
    .translate({ y: this.passwordViewTranslate })
  }

  onFingerprintTipChange: (tip: string, showPriority: number | undefined) => void =
    async (tip: string, showPriority: number | undefined) => {
      log.showDebug(`onFingerprintTipChange ${tip} ${showPriority}`);
      tipPrioritySchedulerTask.onShowPriorityChange(tip, showPriority, TipConfigsIndex.FINGER_PRINT_TIP_INDEX);
      this.fingerPrintTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
      this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
      this.baseScreenUnlockTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
    }
  onFaceVerifyTipChange: (tip: string, showPriority: number | undefined) => void =
    async (tip: string, showPriority: number | undefined) => {
      log.showDebug(`onFaceVerifyTipChange ${tip} ${showPriority}`);
      tipPrioritySchedulerTask.onShowPriorityChange(tip, showPriority, TipConfigsIndex.FACE_TIP_INDEX);
      this.fingerPrintTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
      this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
      this.baseScreenUnlockTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
    }

  build() {
    Column() {
      if (this.isVirtualKeyboardActive !== true) {
        this.singleUserIcon()

        this.singleUserName()
      }
      if (this.isResetPwdPanelShow) {
        this.resetPinPswBuilder()
      } else if (this.needShowKeyguardPassword()) {
        this.keyguardPassword()
      } else {
        this.tipGroup()
      }
    }
    .alignItems(this.isPCMode ? HorizontalAlign.End : HorizontalAlign.Center)
    .translate(!ScreenLockService.canUnlockWithoutPassword() ? { y: this.upOffset } : { y: 0 })
    .justifyContent(FlexAlign.Start)
    .id(COMPONENT_ID_BUTTON_USER + this.userItem?.userId)
    .backgroundColor($r('app.color.transparent'))
    .height(this.isResetPwdPanelShow || this.isResetPwdPanelShow ?
      $r('app.float.screenLock_user_layout_reset_pin_height') : $r('app.float.screenLock_user_layout_pin_height'))
    .width(this.singleUser ? $r('app.float.screenLock_user_layout_width') : this.accountsStyle?.userItemWidth)
    // 以后空格行为只能通过onKeyPreIme监听，不建议使用onKeyEvent和onclick
    .onKeyPreIme((event: KeyEvent) => {
      if (event.type !== KeyType.Down) {
        return false;
      }
      // 有密码框时，人脸识别只响应space键；无密码框时，人脸识别需要响应space和enter键
      if (AppStorage.get('isPwdVisibleForPC')) {
        if (event.keyCode === KeyCode.KEYCODE_SPACE) {
          this.handleFaceVerify();
        }
      } else {
        if (event.keyCode === KeyCode.KEYCODE_SPACE || event.keyCode === KeyCode.KEYCODE_ENTER) {
          this.handleFaceVerify();
        }
      }
      return false;
    })
    .onKeyEvent((event?: KeyEvent) => {
      if (!AppStorage.get('isPwdVisibleForPC') && !!event?.keyText &&
      this.viewModel.passwordNumber.has(event.keyCode)) {
        log.showInfo('passwordKeyEvent done');
        this.viewModel.passwordKeyEvent(event, this.userItem?.userId);
        this.passwordPush = this.viewModel.passwordPush;
        if (event.type === KeyType.Down) {
          this.handleFaceVerify();
        }
      }
    })
    .onAppear(() => {
      BootCompletedAnimationController.getInstance().runScreenLockBootCompletedAnimation();
    })
    .offset(this.userItemOffset())
  }

  private needShowKeyguardPassword(): boolean {
    const isEnterpriseSpaceEnabled: boolean = PCUtils.getIsEnterSpaceEnabled();
    const personalSpaceUID = 101;
    const isPersonalSpace = isEnterpriseSpaceEnabled && this.userData?.userId === personalSpaceUID;
    // it版本双空间场景下，快速切换，本地账号存在AuthType.DOMAIN，导致误认为需要强制密码
    const isDomain = !isPersonalSpace && this.isDomain();
    log.showInfo(`needShowKeyguardPassword, isLockAnimationStart:${this.isLockAnimationStart},
    isPwdVisibleForPC:${this.isPwdVisibleForPC}, isPersonalSpace:${isPersonalSpace}, isDomain:${this.isDomain()}`);
    return (this.isLockAnimationStart || this.isPwdVisibleForPC) && (isDomain || this.passwordType !== 'NONE');
  }
}