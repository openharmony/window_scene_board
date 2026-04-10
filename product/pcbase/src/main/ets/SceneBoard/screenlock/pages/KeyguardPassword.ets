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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { HiSysEventUtil, HiDfxEventUtil, ResourceManager, EvtBus, WallpaperChangeEvent,
  WallpaperManager,
  WallpaperType,
  SCBWindowSceneConfig,
  DeviceHelper,
  GlobalContext} from '@ohos/frameworkwrapper';
import {
  IUserData,
  StrongAuthConstants,
} from '@ohos/screenlockcommon';
import ScreenLockModel from '../refactor/ScreenLockModel';
import { AuthSubType } from '../refactor/AccountsModel';
import ScreenLockService from '../refactor/ScreenLockService';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import ViewModel, { ModelType } from '../vm/MixedPSDViewModel';
import { BusinessError, Callback } from '@ohos.base';
import Curves from '@ohos.curves'
import FingerprintViewModel from '../refactor/FingerprintViewModel';
import { ResUtils } from '@ohos/windowscene';
import AccountsViewModel from '../vm/AccountsViewModel';
import { image } from '@kit.ImageKit';
import effectKit from '@ohos.effectKit';
import PasswordComplexityViewModel from '../vm/PasswordComplexityViewModel';
import LocalConstants from '../common/Constants';
import { UserStyle } from '../style/UserStyle';
import { BaseSceneUnlockTip } from './BaseSceneUnlockTip';
import { GeneralPrompt } from '../component/GeneralPrompt';
import { FingerPrintVerifyTip } from './FingerPrintVerifyTip';
import { PasswordVerifyTip } from './PasswordVerifyTip';
import { TipConfigsIndex, tipPriorityScheduler as tipPrioritySchedulerTask } from '../common/TipPriority';
import {
  enterpriseSpaceVerifyService,
  MixedPwdAuthViewModelWithEnterpriseAuth
} from '../vm/enterprise/EnterpriseMultiSpaceVerifyService';
import { PCBasePromptViewModel } from '../vm/PCBasePromptViewModel';
import { PCMixedPSDViewModel } from '../vm/PCMixedPSDViewModel';
import { SpecificScreenLockStateManager } from '../common/SpecificScreenLockStateManager';
import inputDevice from '@ohos.multimodalInput.inputDevice';
import { SlLayoutData } from '../vm/SlLayoutData';
import StyleConfiguration, { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import { FaceVerifyTip } from './FaceVerifyTip';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { KeyCode } from '@kit.InputKit';
import { osAccount } from '@kit.BasicServicesKit';
import { SCBKeyboardManager } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'ScreenLock-PasswordAndFaceVerify';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const TIME_REQUEST_TEXT_INPUT_FOCUS: number = 100;
const TEXTINPUT_PADDING_LEFT: number = 16;
const TEXTINPUT_PADDING_RIGHT: number = 8;
const TEXTINPUT_PADDING_TOP: number = 4;
const TEXTINPUT_PADDING_BOTTOM: number = 4;
const PC_COMPONENT_ID_PASSWORD: string = 'screenLock_pc_TextInput_password';
const virtualKeyboardUp: number = 2;
const virtualKeyboardDown: number = 5;

/**
 * Password TextInput
 */
const PWD_WIDTH: number = 242;

const PWD_HEIGHT: number = 42;

const PWD_TO_USERITEM: number = 127;


@Component
export default struct PasswordAndFaceVerify {
  private screenlockStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  isKeyboard: boolean = ScreenLockService.isPhysicalKeyboardExist;
  screenLockModel: ScreenLockModel = new ScreenLockModel();
  private isPCMode: boolean = DeviceHelper.is2In1DevicePcType();

  private effect: TransitionEffect =
  TransitionEffect.scale({ x: 0.8, y: 0.8 })
    .combine(TransitionEffect.opacity(0.0))
    .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
    .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
    .combine(TransitionEffect.opacity(1.0))
    .animation({ curve: Curve.Sharp, duration: 350, delay: 100 });
  private unLockScreenCallback: Callback<void> = () => {
  };

  @Prop @Watch('updateComponent')
  isNeedUpdate: boolean = false;
  // mViewModel的属性变更会触发PasswordVerifyTip密码提示刷新，需要暂时由passwordText临时保存密码，减少不必要刷新
  @State passwordText: string = '';
  @State @Watch('focusOnStatusChange')
  mViewModel: PCMixedPSDViewModel = enterpriseSpaceVerifyService.isEnabled() ?
    new MixedPwdAuthViewModelWithEnterpriseAuth() : new PCMixedPSDViewModel();
  @StorageLink('typeFilter')
  typeFilter: string = ScreenLockService.typeFilter;
  @StorageLink('isPhysicalKeyboardExist') @Watch('onKeyboardChange')
  isPhysicalKeyboardExist: boolean = this.isKeyboard;
  @StorageLink('isScreenOff') @Watch('updateComponent')
  isScreenOff: boolean = ScreenLockService.isScreenOff;
  @StorageLink('createdListLen')
  createdListLen: number = 0;
  @StorageLink('isForgotPasswordTexthow')
  isForgotPasswordEntryShow: boolean = false;
  @StorageLink('isPinAuthType') @Watch('onChangeAuthType')
  isPinType: boolean = true;
  @StorageLink('forgetPinSceneprompt')
  forgetPinSceneprompt: string = '';
  @Prop
  isAuthMenuShow: boolean = false;
  @Prop
  isDomainEnable: boolean = false;
  @Link
  isPinAuthing: boolean;
  @StorageLink('isEnterpriseAuthing') @Watch('enterpriseAuthing')
  isEnterpriseAuthing: boolean = false;
  @State
  iconOpacity: number = 0.05;
  @Link
  psdcVM: PasswordComplexityViewModel;
  @Link passwordInitial: string;
  @Link slideScreenLockMoveFocus2Pwd: boolean;
  @StorageLink('isPinAvailable')
  isPinAvailable: boolean = true;
  private defaultPasswordTip: string = '';
  @Consume('isPwdFocused')
  isPwdFocused: boolean;
  @StorageLink('currentUserItem')
  userData: IUserData | null = null;
  @StorageLink('isScreenLockWallpaperBrightOrDark') @Watch('OnBrightOrDarkChange')
  isBrightOrDark: boolean = true;
  isFocused: boolean = true;
  @Link slLayoutData: SlLayoutData;

  private bpBackdropBlur: number = 50;
  private bpSaturate: number = 1.8;

  /**
   * listen bright screen
   */
  @StorageProp('isEndScreenOn') @Watch('updateComponent')
  isEndScreenOn: boolean = true;
  @StorageLink('passwordType')
  passwordType : string = 'NONE';
  @Consume
  isPowerMenuPanelShowed: boolean;
  @Link
  passwordPush: string;
  @StorageLink('isLockAnimationStart')
  isLockAnimationStart: boolean = false;
  @Consume
  fingerprintViewModel: FingerprintViewModel;
  @Consume customizePromptVM: PCBasePromptViewModel;
  @Consume pwdNeedFocus: boolean;
  @Consume @Watch('requestFocusForBoot') focusAfterBoot: boolean;
  @Link accountVM: AccountsViewModel;
  @State arrowIsHover: boolean = false;
  @State arrowShadow: image.PixelMap | null = null;
  @State userStyle: UserStyle = UserStyle.getInstance();
  @StorageLink('systemLanguage') language: string = '';
  @State isUyghurMode: boolean = false;
  @StorageProp(StrongAuthConstants.STRONG_AUTH_REASON) strongAuthStatus: number =
    StrongAuthConstants.NO_NEED_STRONG_AUTH;
  @Link isPasswordShow: boolean;
  @StorageProp('faceUnlockVerifyState') faceUnlockVerifyState: number = 0;
  @StorageProp('isFaceUnlockSwitchOpen') isFaceUnlockSwitchOpen: boolean = false;
  @State @Watch('InhibitInputChange') isInhibitInput: boolean = false;
  @Link fingerPrintTipVisible: boolean;
  @State passwordTipVisible: boolean = false;
  @Link faceVerifyTipVisible: boolean;
  @Link baseScreenUnlockTipVisible: boolean;
  @Link haveTryUnlock: boolean;
  @State canUnlockWithoutPassword: boolean = false;
  @State pwdVisibleIcon: Resource = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark')
    : $r('app.media.ic_password_visible');
  @State pwdUnVisibleIcon: Resource = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark')
    : $r('app.media.ic_password_unvisible');
  @StorageLink('domainAccountIsExpired') @Watch('onDomainAccountExpired') domainAccountIsExpired: boolean = false;
  @State textFrameBgColor: Resource | string = '';
  @State textInputBgColor: Resource | string = '';
  @State arrowIconBgColor: Resource | string = '';
  @State wallpaperRegion: number[] | undefined = AppStorage.get('isWallPaperRegion');
  private textFrameColorPicker: effectKit.ColorPicker | undefined = undefined;
  private isvirtualKeyboardDown: boolean = false;

  private onDomainAccountExpired(): void {
    log.showInfo(`onDomainAccountExpired, expired=${this.domainAccountIsExpired}`);
    if (this.customizePromptVM) {
      this.customizePromptVM.isShowPrompt = !this.domainAccountIsExpired;
    }
  }

  requestFocusForBoot() {
    this.accountVM.updateCapsLockStatus('requestFocusForBoot');
    this.requestFocus('requestFocusForBoot');
  }

  onChangeAuthType() {
    log.showInfo('onChangeAuthType');
    this.mViewModel.clearPassword();
    if (this.customizePromptVM.isShowPrompt) {
      this.customizePromptVM.checkFreezingTime();
    }
    this.mViewModel.checkFreezingTime(() => {
    }, () => {
      this.requestFocus('onChangeAuthType');
    });
  }

  //virtual  keyboard call back
  private registerVirtualKeyboardChangeCallback(): void {
    SCBKeyboardManager.getInstance().registerKeyboardSessionStateChangeCallbackForPC(this.keyboardStateChangeCallback);
  }

  private unRegisterVirtualKeyboardChangeCallback(): void {
    SCBKeyboardManager.getInstance().unRegisterKeyboardSessionStateChangeCallbackForPC(
      this.keyboardStateChangeCallback);
  }

  private keyboardStateChangeCallback = (parentId:number, persistentId:number,
    sessionState:sceneSessionManager.SessionState, mainScreenId:number) => {
    this.notifyVirtualKeyboardStateChange();
  }

  notifyVirtualKeyboardStateChange(): void {
    try {
      let systemKeyboardSession = SCBKeyboardManager.getInstance().getSystemKeyboardSession();
      if (!systemKeyboardSession) {
        return;
      }
      let systemKeyboardState = systemKeyboardSession.sessionState;
      log.showInfo(`keyboardState is ${systemKeyboardState}`);
      if (systemKeyboardState === virtualKeyboardUp) {
        this.isvirtualKeyboardDown = false;
      }
      if (systemKeyboardState === virtualKeyboardDown) {
        this.isvirtualKeyboardDown = true;
      }

    } catch (error) {
      log.error(`display getFoldStatus error ${error}`);
    }
  }

  onKeyboardChange(): void {
    log.showInfo(`onKeyboardChange: isPhysicalKeyboardExist = ${this.isPhysicalKeyboardExist}`);
    if (this.isPhysicalKeyboardExist) {
      setTimeout(() => {this.requestFocus('onKeyboardChange')}, TIME_REQUEST_TEXT_INPUT_FOCUS);
    } else {
      if (!this.isvirtualKeyboardDown) {
        this.mViewModel.clearPassword();
      } else {
        this.isvirtualKeyboardDown = false;
      }
    }
  }

  // 企业账号认证时，隐藏提示信息
  private enterpriseAuthing(): void {
    this.passwordTipVisible = !this.isEnterpriseAuthing;
    this.baseScreenUnlockTipVisible = !this.isEnterpriseAuthing;
  }

  updateComponent(): void {
    log.showInfo(`updateComponent: isPhysicalKeyboardExist = ${this.isPhysicalKeyboardExist}`);
    this.mViewModel.clearPassword();
    this.mViewModel.checkFreezingTime(() => {
      log.showInfo('onClick callback is called');
    });
    this.requestFocus('updateComponent');
    this.forgetPinSceneprompt = '';
    this.isPinAuthing = false;
    this.isEnterpriseAuthing = false;
  }

  getAuthSubType(): AuthSubType {
    return (ScreenLockService.isDomainAuthType()) ? AuthSubType.DOMAIN_MIXED : AuthSubType.PIN_MIXED;
  }

  private OnBrightOrDarkChange(): void {
    this.pwdVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark')
      : $r('app.media.ic_password_visible');
    this.pwdUnVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark')
      : $r('app.media.ic_password_unvisible');
  }

  /**
   * 点击键盘弹出密码框时，设置点击的第一个密码值
   */
  private setFirstPassword(): void {
    log.showInfo('setFirstPassword');
    if (this.passwordInitial === '' || !this.passwordInitial) {
      if (this.passwordPush !== undefined && this.passwordPush !== null && this.passwordPush !== '') {
        log.showInfo('The first password is not from slideScreenLock');
        this.mViewModel.passwordMixArr.push(this.passwordPush);
        this.passwordPush = '';
      }
    } else {
      this.slideScreenLockMoveFocus2Pwd = true;
    }
  }

  private async colorPickerforTextFrameBG(): Promise<Resource> {
    log.showInfo(`colorPickerforTextFrameBG - screenWidth: ${this.slLayoutData.vScreenSize.vScreenWidth}, ` +
      `screenHeight: ${this.slLayoutData.vScreenSize.vScreenHeight}`);
    let wallpaper: image.PixelMap =
      await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.SCEENLOCK, TAG);
    this.wallpaperRegion = AppStorage.get('isWallPaperRegion');
    let leftSide: number =
      ((this.slLayoutData.vScreenSize.vScreenWidth - PWD_WIDTH) / 2) / this.slLayoutData.vScreenSize.vScreenWidth;
    let rightSide: number = leftSide + PWD_WIDTH / this.slLayoutData.vScreenSize.vScreenWidth;
    let topSide: number =
      (this.slLayoutData.accountTopMargin + PWD_TO_USERITEM) / this.slLayoutData.vScreenSize.vScreenHeight;
    let bottomSide: number =
      (this.slLayoutData.accountTopMargin + PWD_TO_USERITEM + PWD_HEIGHT) / this.slLayoutData.vScreenSize.vScreenHeight;
    let textFrameRegion: number[] = [leftSide, topSide, rightSide, bottomSide];
    this.textFrameColorPicker = await effectKit.createColorPicker(wallpaper, textFrameRegion);
    return this.textFrameBgColor =
      this.accountVM.handleWallpaperAvgColor(this.textFrameColorPicker.getAverageColor(), 'textFrameBgColor');
  }

  private textFrameColorCapture(): Resource {
    this.colorPickerforTextFrameBG().then((colorCode) => {
      log.showInfo(`textFrameColorCapture: ${colorCode}`);
      return colorCode;
    })
    return $r('app.color.screenLock_row_baseplate_background_color');
  }

  aboutToAppear() {
    this.mViewModel.clearPassword();
    log.showInfo(`this.language ${this.language}`);
    this.isUyghurMode = (this.language === 'ug-CN' || this.language === 'ug');
    this.setFirstPassword();
    this.accountVM.updateCapsLockStatus('aboutToAppear');
    ScreenLockService.setUserActivateCallback(() => {
      this.mViewModel.checkFreezingTime(() => {
        log.showInfo('aboutToAppear -> onClick callback is called');
      });
    })
    if (this.defaultPasswordTip) {
      this.mViewModel.setPromptByUserBehavior(this.defaultPasswordTip);
    }
    this.mViewModel.checkFreezingTime(() => {
      log.showInfo('aboutToAppear -> onClick callback is called');
    });
    this.mViewModel.switchToPwdPageReport();
    this.initEffectKitCache();
    this.colorPickerforTextFrameBG();
    this.screenLockModel.setScreenLockPrivacy(true);
    this.passwordTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.PASSWORD_TIP_INDEX).visible;
    enterpriseSpaceVerifyService.reset();
    SpecificScreenLockStateManager.setIsAuthResponded(true, osAccount.AuthType.PIN);
    this.registerVirtualKeyboardChangeCallback();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.isEnterpriseAuthing = false;
    this.isPinType = true;
    tipPrioritySchedulerTask.onShowPriorityChange('', undefined, TipConfigsIndex.PASSWORD_TIP_INDEX);
    this.fingerPrintTipVisible =
      tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
    this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
    this.baseScreenUnlockTipVisible =
      tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
    this.mViewModel.clearTimeOutTask();
    this.passwordPush = '';
    this.passwordInitial = '';
    // 密码框消失后，清除emoji状态
    this.mViewModel.clearPassword();
    AppStorage.setOrCreate('isEmojiHasContent', 0);
    this.arrowShadow?.release();
    this.screenLockModel.setScreenLockPrivacy(false);
    this.isPasswordShow = false;
    enterpriseSpaceVerifyService.reset();
    this.unRegisterVirtualKeyboardChangeCallback();
  }

  private requestFocus(reason: string = 'unknown'): void {
    this.accountVM.updateCapsLockStatus('requestFocus');
    let isSuccess = focusControl.requestFocus(PC_COMPONENT_ID_PASSWORD);
    log.showInfo(`PSD requestFocus isSuccess = ${isSuccess} reason:${reason}`);
  }

  private InhibitInputChange(): void {
    if (!this.isInhibitInput) {
      this.forgetPinSceneprompt = '';
    }
  }
  private focusOnStatusChange(): void {
    this.isInhibitInput = this.mViewModel.inhibitInput;
    if (this.mViewModel.inhibitInput) {
      this.pwdVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark_disable')
        : $r('app.media.ic_password_visible_disable');
      this.pwdUnVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark_disable')
        : $r('app.media.ic_password_unvisible_disable');
    } else {
      this.pwdVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_visible_dark')
        : $r('app.media.ic_password_visible');
      this.pwdUnVisibleIcon = this.isBrightOrDark ? $r('app.media.ic_password_unvisible_dark')
        : $r('app.media.ic_password_unvisible');
    }
    if (this.mViewModel.inhibitInput || !this.pwdNeedFocus) {
      log.showDebug(`inhibitInput:${this.mViewModel.inhibitInput} pwdNeedFocus:${this.pwdNeedFocus}`);
      return;
    }
    this.requestFocus('focusOnStatusChange');
    if (this.isEndScreenOn) {
      this.pwdNeedFocus = false;
    }
  }

  private getPlaceholderColor(): Resource {
    return this.isBrightOrDark ?
      (!this.mViewModel.inhibitInput && this.isPinAvailable ? $r('app.color.address_not_last_font_color') :
      $r('sys.color.ohos_id_color_text_tertiary')) :
      (!this.mViewModel.inhibitInput && this.isPinAvailable ? $r('app.color.screenLock_placeholder_dark_color') :
      $r('sys.color.ohos_id_color_text_tertiary_dark'));
  }

  private async initEffectKitCache(): Promise<void> {
    if (!!this.arrowShadow) {
      log.showInfo('ic_shift_toggle had cache');
      return;
    }
    let imageSource: image.ImageSource | null = null;
    let sourcePixelMap: image.PixelMap | null = null;
    let effectPixelMap: image.PixelMap | null = null;
    try {
      const buffer: Uint8Array = await getContext().resourceManager.getMediaByName('adaptive_appcenter_foreground');
      imageSource = image.createImageSource(buffer.buffer as ArrayBuffer);
      if (!imageSource) {
        log.showWarn(`imageSource is not null`);
        return;
      }
      sourcePixelMap = await imageSource.createPixelMap();
      imageSource?.release();
      if (!sourcePixelMap) {
        log.showWarn(`sourcePixelMap is null`);
        return;
      }
      effectPixelMap = await effectKit.createEffect(sourcePixelMap).blur(30).getEffectPixelMap();
      sourcePixelMap?.release();
      if (!effectPixelMap) {
        log.showWarn(`effectPixelMap is null`);
        return;
      }
      this.arrowShadow = await effectPixelMap.createAlphaPixelmap();
      effectPixelMap?.release();
    } catch (error) {
      imageSource?.release();
      sourcePixelMap?.release();
      effectPixelMap?.release();
      log.showError(`createPixelMap error = ${JSON.stringify(error)}`);
    }
  }

  onFingerprintTipChange: (tip: string, showPriority: number | undefined) => void =
    async (tip: string, showPriority: number | undefined) => {
      log.showDebug(`onFingerprintTipChange ${tip} ${showPriority}`);
      tipPrioritySchedulerTask.onShowPriorityChange(tip, showPriority, TipConfigsIndex.FINGER_PRINT_TIP_INDEX)
      this.fingerPrintTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
      this.passwordTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.PASSWORD_TIP_INDEX).visible;
      this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
      this.baseScreenUnlockTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
    }
  onPasswordTipChange: (tip: string, showPriority: number | undefined) => void =
    async (tip: string, showPriority: number | undefined) => {
      log.showDebug(`onPasswordTipChange ${tip} ${showPriority}`);
      tipPrioritySchedulerTask.onShowPriorityChange(tip, showPriority, TipConfigsIndex.PASSWORD_TIP_INDEX)
      this.fingerPrintTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
      this.passwordTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.PASSWORD_TIP_INDEX).visible;
      this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
      this.baseScreenUnlockTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
    }
  onFaceVerifyTipChange: (tip: string, showPriority: number | undefined) => void =
    async (tip: string, showPriority: number | undefined) => {
      log.showDebug(`onFaceVerifyTipChange ${tip} ${showPriority}`);
      tipPrioritySchedulerTask.onShowPriorityChange(tip, showPriority, TipConfigsIndex.FACE_TIP_INDEX)
      this.fingerPrintTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FINGER_PRINT_TIP_INDEX).visible;
      this.passwordTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.PASSWORD_TIP_INDEX).visible;
      this.faceVerifyTipVisible = tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.FACE_TIP_INDEX).visible;
      this.baseScreenUnlockTipVisible =
        tipPrioritySchedulerTask.getTipConfig(TipConfigsIndex.BASE_TIP_INDEX).visible;
    }

  @Builder
  buildArrowIcon() {
    Stack() {
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width($r('app.float.pwd_row_height'))
          .height($r('app.float.pwd_row_height'))
          .borderRadius($r('app.float.quickly_setting_border_radius'))
          .backgroundColor(this.textFrameColorCapture())
          .opacity(0.2)
        Column()
          .width($r('app.float.pwd_row_height'))
          .height($r('app.float.pwd_row_height'))
          .borderRadius($r('app.float.quickly_setting_border_radius'))
          .backgroundEffect({ radius: this.bpBackdropBlur,
            color: '#4DE6E6E6'})
          .border({
            width: '1px',
            color: $r('app.color.screen_lock_text_frame_outline'),
            radius: $r('app.float.quickly_setting_border_radius')
          })
          .outline({
            width: '1px',
            color: $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark'),
            radius: $r('app.float.quickly_setting_border_radius')
          })
        SymbolGlyph($r('sys.symbol.arrow_right'))
          .id(Constants.COMPONENT_ID_BACK)
          .draggable(false)
          .width($r('app.float.screenLock_password_text_input_arrow_size'))
          .height($r('app.float.screenLock_password_text_input_arrow_size'))
          .fontColor(this.isBrightOrDark ? [$r('app.color.address_not_last_font_color')] :
            [$r('app.color.screenLock_placeholder_dark_color')])
          .focusOnTouch(true)
          .focusable(!this.isPowerMenuPanelShowed)
          .fontSize('20vp')

      }
      .width($r('app.float.pwd_row_height'))
      .height($r('app.float.pwd_row_height'))
      .borderRadius($r('app.float.quickly_setting_border_radius'))
      .stateStyles({
        normal: this.enterArrowNormalStyles,
        pressed: this.arrowPressStyles,
        clicked: this.arrowClickedStyles,
        focused: this.enterArrowFocusStyles
      })
      .shadow({ radius: $r('app.float.screenLock_textInput_frame_shadow_radius'),
         color: $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark'), offsetY: 2 })
      .onHover((isHover: boolean) => {
        this.arrowIsHover = isHover;
      })
      .focusable(!this.isPowerMenuPanelShowed)
      .visibility(this.mViewModel.passwordMixArr?.length > 0 ? Visibility.Visible : Visibility.Hidden)
      .transition(this.effect)
      .onClick(() => {
        log.showInfo('onClick');
        if (!SpecificScreenLockStateManager.getIsAuthResponded()) {
          log.showInfo('The authentication has been blocked because the last request is not responded.');
          return;
        }
        HiDfxEventUtil.reportButtonEvent(HiSysEventUtil.TOUCH_EVENT);
        this.isPinAuthing = true;
        ScreenLockService.isDomainAuthType() && (this.isEnterpriseAuthing = true);
        this.mViewModel?.onAuthPassword(this.getAuthSubType(), (result: number) => {
          this.customizePromptVM.isShowPrompt = false;
          if (!this.isPinAvailable && result === 0) {
            this.mViewModel.clearPassword();
            this.mViewModel.prompt = ResUtils.getInnerString($r('app.string.psd_has_expired'));
            return;
          }
          this.isPinAvailable = true;
          this.isEnterpriseAuthing = false;
          AppStorage.setOrCreate('isEmojiAuthSuccess', 'AUTH_FAIL');
          log.showInfo('onClick callback prompt:%{public}s inhibitInput:%{public}s',
            this.mViewModel.prompt, this.mViewModel.inhibitInput);
          if (this.mViewModel.inhibitInput) {
            this.pwdNeedFocus = true;
          }
          this.forgetPinSceneprompt = this.mViewModel.prompt as string;
        }, this.unLockScreenCallback);
      })
    }
    .transition(
      TransitionEffect.scale({ x: 0.8, y: 0.8 })
        .combine(TransitionEffect.opacity(0.0))
        .combine(TransitionEffect.translate({ y: 50 }))
        .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
        .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
        .combine(TransitionEffect.translate({ y: 0 }))
        .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
        .combine(TransitionEffect.opacity(1.0))
        .animation({ curve: Curve.Sharp, duration: 350, delay: 100 }))
  }

  @Styles pressedStyles(): void {
    .backgroundColor($r('app.color.transparent'))
  }

  @Styles focusStyles():void {
    .backgroundColor(this.isBrightOrDark ? $r('app.color.pwd_enter_icon_bright_color_pc') : $r('app.color.pwd_enter_icon_dark_color_pc'))
  }

  @Styles arrowNormalStyles():void {
    .backgroundColor(this.arrowIsHover ? (this.isBrightOrDark ? '#0d000000' : '#1affffff') : '#00000000')
    .border({
      width: 2,
      radius: 16,
      color: '#00ffffff'
    })
  }

  @Styles arrowPressStyles():void {
    .backgroundColor(this.isBrightOrDark ? '#1a000000' : '#26ffffff')
  }

  @Styles arrowClickedStyles():void {
    .backgroundColor(this.isBrightOrDark ? $r('app.color.screenLock_user_activated_outside_border_color') : $r('app.color.ohos_id_color_click_effect_dark'))
  }

  @Styles arrowFocusStyles():void {
    .border({
      width: 2,
      radius: 16,
      color: $r('sys.color.ohos_id_color_focused_outline')
    })
  }

  @Styles enterArrowNormalStyles():void {
    .backgroundColor(this.arrowIsHover ? (this.isBrightOrDark ? $r('app.color.live_card_extend_button_light_bg') : $r('app.color.screenLock_user_activated_inside_border_color')) : $r('app.color.grid_crad_background'))
    .border({
      width: 1,
      color: $r('app.color.control_center_panel_inner_border_color')
    })
  }

  @Styles enterArrowFocusStyles():void {
    .border({
      width: 2,
      color: $r('sys.color.ohos_id_color_focused_outline')
    })
  }

  private getFirstText(reason: string): void {
    log.showInfo(`${reason}: getFirstText`);
    this.accountVM.updateCapsLockStatus('getFirstText');
    if (this.passwordInitial !== '' && this.passwordInitial !== undefined && this.slideScreenLockMoveFocus2Pwd === true) {
      this.passwordInitial = this.accountVM.isCapsLocked ? this.passwordInitial.toUpperCase() :
      this.passwordInitial.toLowerCase();
      this.slideScreenLockMoveFocus2Pwd = false;
      this.mViewModel.onInputChange(this.mViewModel.passwordMixArr.join('') + this.passwordInitial, this.getAuthSubType());
      AccountsViewModel.getInstance().passwordPush = '';
    }
    this.passwordInitial = '';
  }

  build() {
    Column() {

      Row() {
        Stack({ alignContent: Alignment.Center }) {
        }
        .borderRadius($r('app.float.pwd_contacts_group_borderradius'))
        .focusable(false)
        .width($r('app.float.pwd_row_height'))
        Stack() {
          Column()
            .height($r('app.float.pwd_row_height'))
            .width(this.screenlockStyle.pwdTextInputWidth)
            .borderRadius($r('app.float.pwd_contacts_group_borderradius'))
            .backgroundColor(this.textFrameColorCapture())
            .opacity(0.2)
          Stack({ alignContent: Alignment.End }) {
            TextInput({
              placeholder: this.isPinType ? $r('app.string.enter_screenLock_password') : $r('app.string.enter_domain_password'),
              text: this.mViewModel.passwordMixArr.join('')
            }).draggable(false)
              .passwordIcon({ onIconSrc: this.pwdVisibleIcon, offIconSrc: this.pwdUnVisibleIcon })
              .id(PC_COMPONENT_ID_PASSWORD)
              .textAlign(TextAlign.Start)
              .type(InputType.Password)
              .height($r('app.float.pwd_row_height'))
              .width(this.screenlockStyle.pwdTextInputWidth)
              .maxLength(Constants.PASSWORD_MAX_LEN)
              .backgroundEffect({
                radius: 50,
                color:'#4DE6E6E6',
                saturation: 1.8
              })
              .focusable(!this.isPowerMenuPanelShowed && this.isEndScreenOn &&
                !this.mViewModel.inhibitInput && this.isPinAvailable)
              .focusOnTouch(true)
              .placeholderColor(this.getPlaceholderColor())
              .placeholderFont({
                family: $r('app.float.pwd_prompt_font_family'),
                weight: FontWeight.Medium,
                size: 18
              })
              .border({
                width: '1px',
                color: $r('app.color.screen_lock_text_frame_outline'),
                radius: $r('app.float.pwd_contacts_group_borderradius')
              })
              .outline({
                width: '1px',
                color: $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark'),
                radius: $r('app.float.pwd_contacts_group_borderradius')
              })
              .borderRadius($r('app.float.pwd_contacts_group_borderradius'))
              .caretColor(this.isBrightOrDark ? Color.Black : Color.White)
              .fontSize($r('sys.float.Body_L'))
              .fontFamily($r('app.float.pwd_prompt_font_family'))
              .enterKeyType(EnterKeyType.Done)
              .copyOption(CopyOptions.None)
              .fontWeight(FontWeight.Medium)
              .align(Alignment.Center)
              .fontColor(this.isBrightOrDark ? '#E6000000' : $r('app.color.text_color'))
              .showPasswordIcon(true)
              .onFocus(()=>{
                this.getFirstText('onFocus');
              })
              .onChange((value: string) => {
                log.showInfo(`text changed`);
                if (value != undefined) {
                  AppStorage.setOrCreate('isEmojiHasContent', value.length);
                }
                this.mViewModel.onInputChange(value, this.getAuthSubType())
              })
              .inputFilter('[^ ]', (filterStr) => {
                log.showInfo('filterStr:%{public}s', filterStr);
              })
              .onSubmit((enterKey: EnterKeyType) => {
                log.showInfo('enterKey');
                if (this.passwordInitial !== '' || this.passwordInitial !== undefined ) {
                  log.showInfo('clear the first pswd');
                  this.passwordInitial = '';
                }
                if (!SpecificScreenLockStateManager.getIsAuthResponded()) {
                  log.showInfo('The authentication has been blocked because the last request is not responded.');
                  return;
                }
                HiDfxEventUtil.reportStartUnlockEvent();
                if (this.mViewModel.passwordMixArr.length === 0) {
                  setTimeout(() => {
                    this.requestFocus('onSubmit');
                    this.mViewModel.prompt = ResUtils.getInnerString($r('app.string.auth_enter_with_null'));
                    this.customizePromptVM.isShowPrompt = false;
                  }, 100)
                  return;
                }
                this.isPinAuthing = true;
                ScreenLockService.isDomainAuthType() && (this.isEnterpriseAuthing = true);
                this.mViewModel.onAuthPassword(this.getAuthSubType(), (result: number) => {
                  this.customizePromptVM.isShowPrompt = false;
                  if (!this.isPinAvailable && result === 0) {
                    this.mViewModel.clearPassword();
                    this.mViewModel.prompt = ResUtils.getInnerString($r('app.string.psd_has_expired'));
                    return;
                  }
                  this.isPinAvailable = true;
                  this.isEnterpriseAuthing = false;
                  AppStorage.setOrCreate('isEmojiAuthSuccess', 'AUTH_FAIL');
                  log.showInfo('onSubmit callback prompt:%{public}s inhibitInput:%{public}s',
                    this.mViewModel.prompt, this.mViewModel.inhibitInput);
                  this.requestFocus('onAuthPassword');
                  if (this.mViewModel.inhibitInput) {
                    this.pwdNeedFocus = true;
                  }
                  this.forgetPinSceneprompt = this.mViewModel.prompt as string;
                }, this.unLockScreenCallback);
              })
              .onAppear(() => {
                this.requestFocus('onAppear');
                this.isPasswordShow = true;
              })
              .onAreaChange((oldArea, newArea) => {
                // Record the location of the password input box
                log.showInfo('pwd newArea position');
              })
              .padding({
                left: this.isUyghurMode ? TEXTINPUT_PADDING_RIGHT : TEXTINPUT_PADDING_LEFT,
                right: this.isUyghurMode ? TEXTINPUT_PADDING_LEFT : TEXTINPUT_PADDING_RIGHT,
                top: TEXTINPUT_PADDING_TOP,
                bottom: TEXTINPUT_PADDING_BOTTOM,
              })
          }
          .height($r('app.float.pwd_row_height'))
          .width(this.screenlockStyle.pwdTextInputWidth)
          .borderRadius($r('app.float.pwd_contacts_group_borderradius'))
          .onFocus(() => {
            this.accountVM.updateCapsLockStatus('onFocus');
            AppStorage.setOrCreate('isEmojiOnFocus', true);
          })
          .onBlur(() => {
            AppStorage.setOrCreate('isEmojiOnFocus', false);
          })
          .onKeyEvent((event: KeyEvent) => {
            if (event.keyCode === KeyCode.KEYCODE_CAPS_LOCK) {
              this.accountVM.updateCapsLockStatus('onKeyEvent');
            }
          })
          .shadow({ radius: $r('app.float.screenLock_textInput_frame_shadow_radius'),
            color: $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark'), offsetY: 2 })
        }
        .margin({
          right: $r('app.float.screenLock_user_item_margin_top'),
          left: $r('app.float.screenLock_user_item_margin_top'),
        })
        .borderRadius($r('app.float.pwd_contacts_group_borderradius'))
        .height($r('app.float.pwd_row_height'))
        .width(this.screenlockStyle.pwdTextInputWidth)
        .transition(
          TransitionEffect.scale({ x: 0.8, y: 0.8 })
            .combine(TransitionEffect.opacity(0.0))
            .combine(TransitionEffect.translate({ y: 50 }))
            .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
            .animation({ curve: Curves.interpolatingSpring(0, 1, 200, 22), duration: 350, delay: 100 })
            .combine(TransitionEffect.translate({ y: 0 }))
            .animation({ curve: Curves.interpolatingSpring(0, 1, 200, 22), duration: 350, delay: 100 })
            .combine(TransitionEffect.opacity(1.0))
            .animation({ curve: Curves.interpolatingSpring(0, 1, 200, 22), duration: 350, delay: 100 }))
        this.buildArrowIcon();
      }
      .margin({ bottom: 4 })
      .visibility(this.isEnterpriseAuthing ? Visibility.None : Visibility.Visible)

      // 企业账号登录Loading动画
      if (this.isEnterpriseAuthing) {
        LoadingProgress()
          .id('enterprise_auth_loading')
          .color(Color.White)
          .height($r('app.float.pwd_row_height'))
          .height($r('app.float.pwd_row_height'))
          .border({
            width: '1px',
            color: $r('app.color.screen_lock_text_frame_outline'),
            radius: $r('app.float.pwd_contacts_group_borderradius')
          })
          .outline({
            width: '1px',
            color: $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark'),
            radius: $r('app.float.pwd_contacts_group_borderradius')
          })
          .borderRadius($r('app.float.pwd_contacts_group_borderradius'))
          .backgroundEffect({
            radius: 50,
            color:'#4DE6E6E6',
            saturation: 1.8
          })
      }

      if (this.isPCMode) {
        FaceVerifyTip({
          onTipChange: this.onFaceVerifyTipChange.bind(this),
          visible: this.faceVerifyTipVisible,
          haveTryUnlock: this.haveTryUnlock
        })
      }
      FingerPrintVerifyTip({
        onTipChange: this.onFingerprintTipChange.bind(this),
        visible: this.fingerPrintTipVisible
      })
      PasswordVerifyTip({
        onTipChange: this.onPasswordTipChange.bind(this),
        visible: this.passwordTipVisible,
        viewModel: this.mViewModel
      })
      BaseSceneUnlockTip({ visible: this.baseScreenUnlockTipVisible })
      Row() {
        Stack() {
          Row() {}
          .height(8)
          Image(this.arrowShadow).draggable(false)
            .width(16)
            .height(16)
            .objectFit(ImageFit.Contain)
            .opacity(0.3)
            .margin({
              top: 1
            })
            .visibility(this.isBrightOrDark ? Visibility.None : Visibility.Visible)

          SymbolGlyph($r('sys.symbol.arrowshape_up_frame_fill'))
            .draggable(false)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor([this.isBrightOrDark ? '#66000000' : '#f2ffffff'])
            .margin({top: 0});
        }
        .margin({
          bottom: 1,
        })

        Blank(4)

        GeneralPrompt({ marginTop: 0, prompt: ResUtils.getInnerString($r('app.string.upper_shift_prompt')) })
      }.key(LocalConstants.KEY_SHIFT_TOGGLE)
      .margin({ top: 8 })
      .alignItems(VerticalAlign.Top)
      .visibility(this.accountVM.isCapsLocked ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
  }
}

@Component
struct SwitchMenu {
  private txt: string | Resource | null = null;
  private isPinType: boolean = true;
  private viewModel: ViewModel | null = null;
  @Prop
  isSelected: boolean = false;
  @State
  bgColor: string = '#00000000';
  @StorageLink('isPwdVisibleForPC')
  isPwdVisibleForPC: boolean = true;
  @StorageLink('isScreenLockWallpaperBrightOrDark')
  isBrightOrDark: boolean = true;
  @Consume
  isPowerMenuPanelShowed: boolean;
  private isFocusable: boolean = true;

  @Styles
  pressedStyles() {
    .backgroundColor(this.isBrightOrDark ? '#1A000000' : '#1AFFFFFF')
  }

  build() {
    Button({ type: ButtonType.Capsule, stateEffect: false }) {
      Column() {
        Text(this.txt).draggable(false)
          .fontSize($r('app.float.keyboard_psd_switch_menu_font_size'))
          .fontWeight(this.isSelected ? FontWeight.Bold : FontWeight.Regular)
          .fontFamily($r('app.float.pwd_prompt_font_family'))
          .fontColor(this.isBrightOrDark ? '#E6000000' : $r('app.color.text_color'))
          .textAlign(TextAlign.Center)
          .opacity(this.isSelected ? 1 : 0.6)
          .focusable(!this.isPowerMenuPanelShowed && this.isFocusable)
          .textOverflow({ overflow: TextOverflow.None })
          .textShadow({
            offsetY: this.isBrightOrDark ? 0 : 1,
            color: this.isBrightOrDark ? '#00000000' : '#cc000000',
            radius: this.isBrightOrDark ? 0 : 2
          })
          .id(`${TAG}_Text_switchMenu`)
      }
      .height('32vp')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.transparent'))
    }
    .focusable(!this.isPowerMenuPanelShowed && this.isFocusable)
    .visibility(this.isPwdVisibleForPC ? Visibility.Visible : Visibility.Hidden)
    .transition(
      TransitionEffect.scale({ x: 0.8, y: 0.8 })
        .combine(TransitionEffect.opacity(0.0))
        .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
        .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
        .combine(TransitionEffect.opacity(1.0))
        .animation({ curve: Curve.Sharp, duration: 350, delay: 100 }))
    .id(`${TAG}_Button_switchMenu`)
    .padding({ right: '8vp', left: '8vp'})
    .onClick(() => {
      AppStorage.setOrCreate<boolean>('isPinAuthType', this.isPinType);
    })
    .onKeyEvent((event?: KeyEvent) => {
      if (event) {
        this.viewModel?.handleKeyEvent(event, this.isPinType ? ModelType.PIN_AUTH_TYPE : ModelType.DOMAIN_AUTH_TYPE);
      }
    })
    .backgroundColor(this.bgColor)
    .onHover((isHover?: boolean) => {
      if (isHover) {
        this.bgColor = this.isBrightOrDark ? '#0D000000' : '#0dffffff'
      } else {
        this.bgColor = '#00000000'
      }
    })
    .stateStyles({
      pressed: this.pressedStyles
    })
  }
}