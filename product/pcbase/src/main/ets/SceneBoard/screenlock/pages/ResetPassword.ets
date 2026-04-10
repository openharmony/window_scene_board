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

import Curves from '@ohos.curves'
import { BusinessError } from '@ohos.base';
import dataPreferences from '@ohos.data.preferences';
import { strongAuthManager, StrongAuthConstants } from '@ohos/screenlockcommon';
import ScreenLockModel from '../refactor/ScreenLockModel';
import { LogDomain, Logger, CommonUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { PsdComplexityParams, PasswordComplexityUtil } from '../common/PasswordComplexityUtil';
import PasswordComplexityViewModel from '../vm/PasswordComplexityViewModel';
import Constants from '../common/Constants';
import ToastTip from '../component/ToastTip';
import { PcHiSysEventMgr, RECOVERY_KEY_RESET_PWD_RESULT } from '../../../common/manager/PcHiSysEventMgr';
import { GeneralPrompt } from '../component/GeneralPrompt';
import { BiometricsDisAbleReason, biometricsVerifyService } from '../common/BiometricsVerifyService';
import { promptAction } from '@kit.ArkUI';

const TAG = 'ScreenLock-ResetPassword';
const STRONG_AUTH_PROMPT = 'STRONG_AUTH_PROMPT';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const TRANSITION_EFFECT: TransitionEffect =
  TransitionEffect.scale({ x: 0.8, y: 0.8 })
    .combine(TransitionEffect.opacity(0.0))
    .combine(TransitionEffect.translate({ y: 50 }))
    .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
    .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
    .combine(TransitionEffect.translate({ y: 0 }))
    .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
    .combine(TransitionEffect.opacity(1.0))
    .animation({ curve: Curve.Sharp, duration: 350, delay: 100 });

@Component
export struct ResetPassword {
  screenLockModel: ScreenLockModel = new ScreenLockModel();
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @Consume isPowerMenuPanelShowed: boolean;
  @State isConfirmPasswordIconShow: boolean = false;
  @State @Watch('watchIsUpdatePinSuccess') psdcVM: PasswordComplexityViewModel = new PasswordComplexityViewModel();
  @State detailIconMsg: string = '';
  @State isDetailIconMsgShow: boolean = false;
  private toastMessage: ResourceStr = '';
  @StorageLink('isBeginSleepStart') @Watch('onBeginSleepStart') isBeginSleepStart: boolean = false;
  @State lastStepIsHover: boolean = false;
  @State nextStepIsHover: boolean = false;
  private isPinExpire: boolean = false;
  private isNextButtonClicking: boolean = false;
  @State pwdVisibleIcon: Resource = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark')
    : $r('app.media.ic_password_visible');
  @State pwdUnVisibleIcon: Resource = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark')
    : $r('app.media.ic_password_unvisible');
  @State oldPwdVisibleIcon: Resource = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark')
    : $r('app.media.ic_password_visible');
  @State oldPwdUnVisibleIcon: Resource = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark')
    : $r('app.media.ic_password_unvisible');
  private jumpPinAuthFromResetPin?: (isResetSuc: boolean) => void;
  private toastController: CustomDialogController = new CustomDialogController({
    builder: ToastTip({
      message: this.toastMessage
    }),
    customStyle: true,
    autoCancel: false,
    maskRect: {
      x: 0,
      y: '89.3%',
      width: '100%',
      height: $r('app.float.height_44'),
    },
    // mask设置为透明
    maskColor: Color.Transparent,
    offset: { dx: 0, dy: '41.2%' }
  });

  private onBeginSleepStart(): void {
    log.showInfo(TAG, `isBeginSleepStart: ${this.isBeginSleepStart}`);
    if (this.isBeginSleepStart) {
      this.isDetailIconMsgShow = false;
    }
  }

  private getPlaceholderColor(): Resource {
    return this.isBrightOrDark ? (!this.psdcVM.inhibitInput ? $r('app.color.address_not_last_font_color') :
    $r('sys.color.ohos_id_color_text_tertiary')) :
      (!this.psdcVM.inhibitInput ? $r('sys.color.font_on_primary') : $r('sys.color.ohos_id_color_text_tertiary_dark'));
  }

  public requestFocus(reason: string = 'unknown'): void {
    log.showInfo(TAG, `inhibitInput : ${this.psdcVM.inhibitInput}, reason : ${reason}`);
    let isSuccess: boolean = false;
    if (this.isPinExpire) {
      isSuccess = focusControl.requestFocus(Constants.PC_ID_OLD_PASSWORD);
    }
    log.showInfo(TAG, `PSD requestFocus isSuccess : ${isSuccess} reason:${reason}`);
  }

  public watchIsUpdatePinSuccess(): void {
    if (this.psdcVM.inhibitInput) {
      this.oldPwdVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark_disable')
        : $r('app.media.ic_password_visible_disable');
      this.oldPwdUnVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark_disable')
        : $r('app.media.ic_password_unvisible_disable');
    } else {
      this.oldPwdVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark')
        : $r('app.media.ic_password_visible');
      this.oldPwdUnVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark')
        : $r('app.media.ic_password_unvisible');
    }
    log.showInfo(TAG, ' watch this.psdcVM change ');
    // 修改锁屏密码成功后，跳转首页重新验证新密码
    if (this.psdcVM.isUpdatePinSuccess) {
      log.showInfo(TAG, 'watch IsUpdatePinSuccess change, back to auth new password page');
      this.psdcVM.isUpdatePinSuccess = false;
      biometricsVerifyService.popDisableReason(BiometricsDisAbleReason.PASSWORD_EXPIRED);
      this.jumpPinAuthFromResetPin?.(true);
    }
    if (this.psdcVM.isUpdatePinByRecKeySuccess) {
      log.showInfo(TAG, 'watch IsUpdatePinByRecKeySuccess change, back to auth new password page');
      AppStorage.setOrCreate('isForgotPasswordTexthow', false);
      // 禁用指纹和人脸
      strongAuthManager.setAuthReason(StrongAuthConstants.USER_REQUEST);
      biometricsVerifyService.pushDisableReason(BiometricsDisAbleReason.PASSWORD_RESET);
      // 强认证+提示词变为：锁屏密码更改成功，需要输入密码
      let preferences: dataPreferences.Preferences | null = null;
      try {
        preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: TAG });
        let strongAuthPrompt: string = ResUtils.getInnerString($r('app.string.psd_change_success_enter_pin'))
        preferences.putSync(STRONG_AUTH_PROMPT, strongAuthPrompt);
        preferences.flush();
      } catch (err) {
        log.showError(TAG, ` getPreferencesSync error, BusinessError code is ${(err as BusinessError).code}`);
      }
      this.psdcVM.isUpdatePinByRecKeySuccess = false;
      let successResult = RECOVERY_KEY_RESET_PWD_RESULT.USER_PIN_RECOVERY_KEY_RESET_PASSWORD_SUCCESS
      PcHiSysEventMgr.userPinRecoverKeyResetPassword(successResult);
      this.jumpPinAuthFromResetPin?.(true);
    }
  }

  public oldPasswordInputOnblur(): void {
    this.psdcVM.checkOldPasswordInput(() => {
    }, () => {
      log.showInfo(TAG, 'old password on blur requestFocus PC_ID_OLD_PASSWORD');
      focusControl.requestFocus(Constants.PC_ID_OLD_PASSWORD);
    });

    if (typeof this.psdcVM.oldPasswordWarnMsg !== 'string') {
      let oldPasswordWarnMsg = this.psdcVM.oldPasswordWarnMsg as Resource;
      if (oldPasswordWarnMsg.id === $r('app.string.password_cannot_be_empty').id) {
        this.psdcVM.isOldPasswordWarningShow = false;
      }
    }
  }

  public oldPasswordInputSubmit(): void {
    if (!this.psdcVM.isOldPasswordChanged) {
      focusControl.requestFocus(Constants.PC_ID_NEW_PASSWORD);
    }
    this.psdcVM.checkOldPasswordInput(() => {
      focusControl.requestFocus(Constants.PC_ID_NEW_PASSWORD);
    }, () => {
      focusControl.requestFocus(Constants.PC_ID_OLD_PASSWORD);
    });
  }

  private async checkedPassStartToUpdate(): Promise<void> {
    // 顺利通过校验后开始重设密码
    if (!this.isPinExpire) {
      log.showInfo(TAG, 'pin is not expire');
      return;
    }
    if ((this.psdcVM.oldPasswordInput && this.psdcVM.newPasswordInput &&
    this.psdcVM.confirmPasswordInput) && (!this.psdcVM.isOldPasswordWarningShow &&
      !this.psdcVM.isNewPasswordWarningShow && !this.psdcVM.isConfirmPasswordWarningShow)) {
      log.showInfo(TAG, 'start to update password by old password ');
      // 修改锁屏密码
      this.psdcVM.updatePin(() => {
      }, () => {
        this.toastMessage = $r('app.string.psd_change_fail');
        this.showRecoveryKeyFailToast();
      });
    }
  }

  private showRecoveryKeyFailToast(): void {
    try {
      promptAction.showToast({
        message: this.toastMessage,
        duration: 2000,
        showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
      });
    } catch (error) {
      log.showError(TAG, `showRecoveryKeyFailToast error ${error}`);
    }
  }

  private async threeTextInputSubmit(): Promise<void> {
    log.showInfo(TAG, 'click or sumbit, start to update password ');
    // 开始校验三个输入框
    if (this.isPinExpire) {
      this.psdcVM.checkOldPasswordInput();
      if (!this.psdcVM.oldPasswordInput) {
        this.psdcVM.oldPasswordWarnMsg = $r('app.string.password_cannot_be_empty');
        this.psdcVM.isOldPasswordWarningShow = true;
      }
    }
    this.psdcVM.checkNewPasswordInput();
    this.psdcVM.checkConfirmPasswordInput();
    if (!this.psdcVM.newPasswordInput) {
      this.psdcVM.newPasswordWarnMsg = $r('app.string.password_cannot_be_empty');
      this.psdcVM.isNewPasswordWarningShow = true;
    }

    if (!this.psdcVM.confirmPasswordInput) {
      this.psdcVM.confirmPasswordWarnMsg = $r('app.string.password_cannot_be_empty');
      this.psdcVM.isConfirmPasswordWarningShow = true;
    }
    await this.checkedPassStartToUpdate();
  }

  aboutToAppear(): void {
    let psdComplexit: PsdComplexityParams = PasswordComplexityUtil.getPasswordPolicy();
    if (psdComplexit.hasPsdComplexity) {
      this.psdcVM.isDetailIconShow = true;
    }
    this.detailIconMsg = psdComplexit.additionalDescription;
    log.showInfo(TAG, `psdComplexit.hasPsdComplexity: ${psdComplexit.hasPsdComplexity}`);
    this.psdcVM.maxLength = psdComplexit.maxLength;
    this.psdcVM.minLength = psdComplexit.minLength;
    if (this.isPinExpire) {
      this.psdcVM.refreshPrompt();
    }
    this.screenLockModel.setScreenLockPrivacy(true);
  }

  aboutToDisappear(): void {
    this.isDetailIconMsgShow = false;
    this.psdcVM.isDetailIconShow = false;
    this.psdcVM.isOldPasswordWarningShow = false;
    this.toastController.close();
    this.screenLockModel.setScreenLockPrivacy(false);
  }

  @Styles
  baseplateLastNormalStyles() {
    .backgroundColor(this.lastStepIsHover ? (this.isBrightOrDark ? $r('app.color.file_picker_button_bg_color') :
    $r('app.color.screenLock_user_activated_inside_border_color')) : Color.Transparent)
  }

  @Styles
  baseplateNextNormalStyles() {
    .backgroundColor(this.nextStepIsHover ? (this.isBrightOrDark ? $r('app.color.file_picker_button_bg_color') :
    $r('app.color.screenLock_user_activated_inside_border_color')) : Color.Transparent)
  }

  @Styles
  baseplateClickedStyles() {
    .backgroundColor(this.isBrightOrDark ? $r('app.color.sound_slider_track_color') :
    $r('app.color.ohos_id_color_click_effect_dark'))
  }

  @Styles
  baseplatePressedStyles() {
    .backgroundColor(this.isBrightOrDark ? $r('app.color.sound_slider_track_color') :
    $r('app.color.ohos_id_color_click_effect_dark'))
  }

  @Styles
  buttonBorderNormalStyles() {
    .border({
      width: 1,
      color: $r('app.color.control_center_title_icon_transparent_color'),
    })
  }

  @Styles
  buttonBorderFocusedStyles() {
    .border({
      width: 2,
      color: $r('sys.color.ohos_id_color_focused_outline')
    })
  }

  @Builder
  bindPopBuilder() {
    Row() {
      Text(this.detailIconMsg)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('app.float.screenLock_detail_font_size'))
        .lineHeight($r('app.float.screenLock_detail_line_height'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .padding($r('app.float.Control_center_divider_padding_bottom'))
        .maxLines(3)
        .constraintSize({ maxWidth: 212 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
  }

  @Builder
  buildOldTextInput() {
    Stack() {
      TextInput({
        placeholder: ResUtils.getInnerString($r('app.string.enter_old_psd')),
        text: this.psdcVM.oldPasswordInput
      })
        .id(Constants.PC_ID_OLD_PASSWORD)
        .textInputStyle()
        .placeholderColor(this.getPlaceholderColor())
        .fontColor(this.isBrightOrDark ? $r('app.color.font_color') :
        $r('sys.color.ohos_id_color_text_primary_contrary'))
        .passwordIcon({ onIconSrc: this.oldPwdVisibleIcon, offIconSrc: this.oldPwdUnVisibleIcon })
        .caretColor(this.isBrightOrDark ? Color.Black : Color.White)
        .focusable(!this.isPowerMenuPanelShowed && !this.psdcVM.inhibitInput)
        .focusOnTouch(true)
        .onTouch((event) => {
          focusControl.requestFocus(Constants.PC_ID_OLD_PASSWORD);
        })
        .onAppear(() => {
          this.requestFocus('onAppear');
        })
        .onBlur(() => {
          log.showInfo(TAG, 'old password text input on blur');
          this.oldPasswordInputOnblur();
        })
        .onChange((value: string) => {
          this.isDetailIconMsgShow = false;
          this.psdcVM.oldPasswordInput = value;
          this.psdcVM.isOldPasswordChanged = true;
        })
        .onSecurityStateChange(((isShowPassword: boolean) => {
          this.isPowerMenuPanelShowed = false;
        }))
        .enterKeyType(EnterKeyType.Done)
        .onSubmit(enterKeyType => {
          if (enterKeyType === EnterKeyType.Done) {
            this.oldPasswordInputSubmit();
          }
        })
    }
    .height($r('app.float.pwd_row_height'))
    .borderRadius($r('app.float.quickly_setting_border_radius'))
    .width(this.isPinExpire ? $r('app.float.screenLock_row_baseplate_width_318') :
    $r('app.float.screenLock_row_baseplate_width_424'))
  }

  @Builder
  buildNewTextInput() {
    TextInput({
      placeholder: ResUtils.getInnerString($r('app.string.enter_new_psd')),
      text: this.psdcVM.newPasswordInput
    })
      .id(Constants.PC_ID_NEW_PASSWORD)
      .textInputStyle()
      .placeholderColor(this.isBrightOrDark ? $r('app.color.address_not_last_font_color') :
      $r('app.color.screenLock_placeholder_dark_color'))
      .fontColor(this.isBrightOrDark ? $r('app.color.font_color') : $r('sys.color.ohos_id_color_text_primary_contrary'))
      .passwordIcon({ onIconSrc: this.pwdVisibleIcon, offIconSrc: this.pwdUnVisibleIcon })
      .caretColor(this.isBrightOrDark ? Color.Black : Color.White)
      .focusable(!this.isPowerMenuPanelShowed)
      .focusOnTouch(true)
      .onTouch((event) => {
        focusControl.requestFocus(Constants.PC_ID_NEW_PASSWORD);
      })
      .onChange((value: string) => {
        this.isDetailIconMsgShow = false;
        this.psdcVM.newPasswordInput = value;
        this.isDetailIconMsgShow = this.psdcVM.isDetailIconShow ? true : false;
      })
      .onSecurityStateChange(((isShowPassword: boolean) => {
        this.isPowerMenuPanelShowed = false;
      }))
      .onClick(() => {
        log.showInfo(TAG, 'column onClick');
        this.isDetailIconMsgShow = this.psdcVM.isDetailIconShow ? true : false;
      })
      .onFocus(() => {
        log.showInfo(TAG, 'column onFocus');
        this.isDetailIconMsgShow = this.psdcVM.isDetailIconShow ? true : false;
      })
      .onBlur(() => {
        log.showInfo(TAG, 'new password text input on blur')
        this.isDetailIconMsgShow = false;
        setTimeout(() => {
          if (!this.isNextButtonClicking) {
            this.psdcVM.checkNewPasswordInput();
          }
          this.isNextButtonClicking = false;
        }, 50);
      })
      .enterKeyType(EnterKeyType.Done)
      .onSubmit(enterKeyType => {
        if (enterKeyType === EnterKeyType.Done) {
          this.psdcVM.checkNewPasswordInput();
          focusControl.requestFocus(Constants.PC_ID_CONFIRM_PASSWORD);
        }
      })
  }

  @Builder
  buildConfirmTextInput() {
    TextInput({
      placeholder: ResUtils.getInnerString($r('app.string.confirm_new_psd')),
      text: this.psdcVM.confirmPasswordInput
    })
      .id(Constants.PC_ID_CONFIRM_PASSWORD)
      .textInputStyle()
      .placeholderColor(this.isBrightOrDark ? $r('app.color.address_not_last_font_color') :
      $r('app.color.screenLock_placeholder_dark_color'))
      .fontColor(this.isBrightOrDark ? $r('app.color.font_color') : $r('sys.color.ohos_id_color_text_primary_contrary'))
      .passwordIcon({ onIconSrc: this.pwdVisibleIcon, offIconSrc: this.pwdUnVisibleIcon })
      .caretColor(this.isBrightOrDark ? Color.Black : Color.White)
      .focusable(!this.isPowerMenuPanelShowed)
      .focusOnTouch(true)
      .onTouch((event) => {
        focusControl.requestFocus(Constants.PC_ID_CONFIRM_PASSWORD);
      })
      .onBlur(() => {
        log.showInfo(TAG, 'confirm password text input on blur')
        this.psdcVM.checkConfirmPasswordInput();
        if (this.isConfirmPasswordIconShow && !this.psdcVM.confirmPasswordInput) {
          this.psdcVM.isConfirmPasswordWarningShow = true;
          this.isConfirmPasswordIconShow = false;
        }
      })
      .onChange((value: string) => {
        this.isDetailIconMsgShow = false;
        this.psdcVM.confirmPasswordInput = value;
      })
      .onSecurityStateChange(((isShowPassword: boolean) => {
        this.isPowerMenuPanelShowed = false;
      }))
      .enterKeyType(EnterKeyType.Done)
      .onSubmit(enterKeyType => {
        this.isDetailIconMsgShow = false;
        if (enterKeyType === EnterKeyType.Done) {
          this.threeTextInputSubmit();
          this.isConfirmPasswordIconShow = true;
        }
      })
      .height($r('app.float.pwd_row_height'))
      .borderRadius($r('app.float.quickly_setting_border_radius'))
  }

  @Builder
  buildNewTextInputStack() {
    Stack({ alignContent: Alignment.End }) {
      Column() {
        this.buildNewTextInput();
      }
      .bindPopup(this.isDetailIconMsgShow, {
        builder: this.bindPopBuilder(),
        placement: Placement.Right,
        backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
        autoCancel: false,
        radius: $r('app.float.Notification_center_icon_shadow_radius'),
        mask: false,
        offset: {
          x: $r('app.float.screenLock_offset_x_1'),
          y: $r('app.float.screenLock_offset_x_1'),
        },
        onStateChange: (e) => {
          if (!e.isVisible) {
            this.isDetailIconMsgShow = false
          }
        }
      })
    }
    .height($r('app.float.pwd_row_height'))
    .width($r('app.float.screenLock_row_baseplate_width_318'))
    .borderRadius($r('app.float.quickly_setting_border_radius'))
  }

  @Builder
  buildOldTextPrompt() {
    GeneralPrompt({
      prompt: this.psdcVM.prompt ? this.psdcVM.prompt : this.psdcVM.oldPasswordWarnMsg,
      marginTop: $r('app.float.pwd_row_bottom'),
      transitionEffect: TRANSITION_EFFECT,
      visible: this.psdcVM.isOldPasswordWarningShow,
    })
  }

  @Builder
  buildNewTextPrompt() {
    GeneralPrompt({
      prompt: this.psdcVM.newPasswordWarnMsg ? this.psdcVM.newPasswordWarnMsg : '',
      marginTop: $r('app.float.pwd_row_bottom'),
      transitionEffect: TRANSITION_EFFECT,
      visible: this.psdcVM.isNewPasswordWarningShow,
    })
  }

  @Builder
  buildConfirmTextPrompt() {
    GeneralPrompt({
      prompt: this.psdcVM.confirmPasswordWarnMsg ? this.psdcVM.confirmPasswordWarnMsg : '',
      marginTop: $r('app.float.pwd_row_bottom'),
      transitionEffect: TRANSITION_EFFECT,
      visible: this.psdcVM.isConfirmPasswordWarningShow,
    })
  }

  @Builder
  buildTextInputBaseplate() {
    Row()
      .borderRadius($r('app.float.quickly_setting_border_radius'))
      .height($r('app.float.pwd_row_height'))
      .width($r('app.float.screenLock_row_baseplate_width_318'))
      .backgroundColor($r('app.color.screenLock_row_baseplate_background_color'))
      .backgroundEffect({ radius: 50 })
      .saturate(1.8)
  }

  @Builder
  buildButtonBaseplate() {
    Column()
      .width($r('app.float.pwd_row_height'))
      .height($r('app.float.pwd_row_height'))
      .borderRadius($r('app.float.quickly_setting_border_radius'))
      .backgroundColor($r('app.color.screenLock_row_baseplate_background_color'))
      .backgroundEffect({ radius: 50 })
      .saturate(1.8)
  }

  @Builder
  buildLastStep() {
    Stack({ alignContent: Alignment.Center }) {
      this.buildButtonBaseplate();
      Image($r('app.media.ic_public_back_scene'))
        .id(Constants.PC_ID_IMAGE_BACK)
        .draggable(false)
        .matchTextDirection(true)
        .width($r('app.float.screenLock_password_text_height'))
        .height($r('app.float.screenLock_password_text_height'))
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .fillColor(this.isBrightOrDark ? $r('app.color.screenlock_backgroundcolor') : $r('app.color.white'))
        .focusOnTouch(true)
        .focusable(!this.isPowerMenuPanelShowed)
      Column()
        .width($r('app.float.pwd_row_height'))
        .height($r('app.float.pwd_row_height'))
        .backgroundColor(this.isBrightOrDark ? $r('app.color.screenlock_backgroundcolor') : $r('app.color.white'))
        .borderRadius($r('app.float.quickly_setting_border_radius'))
        .stateStyles({
          normal: this.baseplateLastNormalStyles,
          clicked: this.baseplateClickedStyles,
          pressed: this.baseplatePressedStyles,
        })
    }
    .width($r('app.float.pwd_row_height'))
    .height($r('app.float.pwd_row_height'))
    .border({
      width: $r('app.float.screenLock_password_border_width'),
      color: $r('app.color.hovered_outer_border_color'),
    })
    .borderRadius($r('app.float.quickly_setting_border_radius'))
    .stateStyles({
      normal: this.buttonBorderNormalStyles,
      focused: this.buttonBorderFocusedStyles,
    })
    .focusable(!this.isPowerMenuPanelShowed)
    .onHover((isHover: boolean) => {
      this.lastStepIsHover = isHover;
    })
    .onClick(async () => {
      log.showInfo(TAG, `last step is click , will back to auth pin`);
      this.isDetailIconMsgShow = false;
      this.jumpPinAuthFromResetPin?.(false);
    })
  }

  @Builder
  buildNextStep() {
    Stack({ alignContent: Alignment.Center }) {
      this.buildButtonBaseplate();
      Image($r('app.media.ic_public_next_scene'))
        .id(Constants.PC_ID_IMAGE_NEXT)
        .draggable(false)
        .matchTextDirection(true)
        .width($r('app.float.screenLock_password_text_height'))
        .height($r('app.float.screenLock_password_text_height'))
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .fillColor(this.isBrightOrDark ? $r('app.color.screenlock_backgroundcolor') : $r('app.color.white'))
        .focusOnTouch(true)
        .focusable(!this.isPowerMenuPanelShowed)
      Column()
        .width($r('app.float.pwd_row_height'))
        .height($r('app.float.pwd_row_height'))
        .backgroundColor(this.isBrightOrDark ? $r('app.color.screenlock_backgroundcolor') : $r('app.color.white'))
        .borderRadius($r('app.float.quickly_setting_border_radius'))
        .stateStyles({
          normal: this.baseplateNextNormalStyles,
          clicked: this.baseplateClickedStyles,
          pressed: this.baseplatePressedStyles,
        })
    }
    .width($r('app.float.pwd_row_height'))
    .height($r('app.float.pwd_row_height'))
    .border({
      width: $r('app.float.screenLock_password_border_width'),
      color: $r('app.color.hovered_outer_border_color'),
    })
    .borderRadius($r('app.float.quickly_setting_border_radius'))
    .stateStyles({
      normal: this.buttonBorderNormalStyles,
      focused: this.buttonBorderFocusedStyles,
    })
    .focusable(!this.isPowerMenuPanelShowed)
    .onHover((isHover: boolean) => {
      this.nextStepIsHover = isHover;
    })
    .onClick(CommonUtils.debounce(async () => {
      this.toastController.close();
      this.isDetailIconMsgShow = false;
      this.isNextButtonClicking = true;
      this.threeTextInputSubmit();
    }, 1000))
  }

  @Builder
  oldPwdTextInput() {
    Row() {
      Stack() {
        this.buildTextInputBaseplate()
        if (this.isPinExpire) {
          this.buildOldTextInput()
        }
      }
      .pwdInputStyle()
    }
  }

  @Builder
  newPwdTextInput() {
    Row() {
      Stack() {
        this.buildTextInputBaseplate()
        this.buildNewTextInputStack()
      }
      .pwdInputStyle()
    }
    .margin({
      top: $r('app.float.screenLock_password_text_input_height')
    })
  }

  @Builder
  confirmPwdTextInput(textInputBuilder: CustomBuilder) {
    Row() {
      Stack() {
        this.buildTextInputBaseplate()
        this.buildConfirmTextInput()
      }
      .pwdInputStyle()
    }
    .margin({
      top: $r('app.float.screenLock_password_text_input_height')
    })
  }

  build() {
    Column() {
      Column() {
        this.oldPwdTextInput()

        if (this.isPinExpire) {
          this.buildOldTextPrompt()
        }

        this.newPwdTextInput()

        this.buildNewTextPrompt()

        this.confirmPwdTextInput()

        this.buildConfirmTextPrompt()
      }
      .height($r('app.float.screenLock_password_part_height'))

      Row({ space: 16 }) {
        this.buildLastStep()
        this.buildNextStep()
      }
      .alignItems(VerticalAlign.Center)
      .height($r('app.float.screenLock_icon_part_height'))

    }
    .keyboardShortcut(FunctionKey.ESC, [], () => {
      log.showInfo(TAG, 'ESC is clicked  ,will to back auth password page');
      if (!this.isPowerMenuPanelShowed) {
        this.isDetailIconMsgShow = false;
        this.jumpPinAuthFromResetPin?.(false);
      }
    })
  }
}

@Extend(Stack)
function pwdInputStyle() {
  .border({
    width: $r('app.float.screenLock_password_border_width'),
    color: $r('app.color.hovered_outer_border_color'),
  })
  .borderRadius($r('app.float.quickly_setting_border_radius'))
  .height($r('app.float.pwd_row_height'))
  .width($r('app.float.screenLock_row_baseplate_width_318'))
  .transition(TRANSITION_EFFECT)
}

/* 输入框样式 */
@Extend(TextInput)
function textInputStyle() {
  .backgroundColor(Color.Transparent)
  .height($r('app.float.pwd_row_height'))
  .width($r('app.float.screenLock_row_baseplate_width_318'))
  .borderRadius($r('app.float.quickly_setting_border_radius'))
  .type(InputType.Password)
  .placeholderFont({
    family: $r('app.float.pwd_prompt_font_family'),
    weight: FontWeight.Medium,
    size: $r('app.float.screenLock_password_font_size')
  })
  .fontWeight(FontWeight.Bolder)
  .fontSize($r('app.float.screenLock_password_font_size'))
  .fontFamily($r('app.float.pwd_prompt_font_family'))
  .showPasswordIcon(true)
  .padding({
    top: $r('app.float.screenLock_password_padding'),
    bottom: $r('app.float.screenLock_password_padding'),
  })
  .copyOption(CopyOptions.None)
}