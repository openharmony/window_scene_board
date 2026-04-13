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

import Constants from '../../common/Constants';
import PasswordConstants from '../../password/common/PasswordConstants';
import { ScreenLockPasswordVm } from '../viewmodel/PasswordVm'
import { PasswordManager, PasswordChangeListener } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import { LogDomain, LogHelper, Trace, TraceUtil } from '@ohos/basicutils';
import { DeviceHelper, SystemParamUtils } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import NumKeyBoardViewModel, { AniCallback } from '../../password/viewmodel/NumKeyBoardViewModel';
import curves from '@ohos.curves';
import { DigitalKeyboardItem } from '../../password/common/DigitalKeyboardItem';
import { PassWordLayout } from '../../common/LayoutConstants';
import { KeyGuardMode, SLWallpaperState, TraceTag } from '@ohos/screenlockcommon';
import { SpecialModeManager, SpecialModeViewData } from '../../common/SpecialModeManager';
import { slWallpaperMgr } from '@ohos/screenlockcommon';
import accessibility from '@ohos.accessibility';
import { DynamicFontSize, sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { PasswordLayoutConfig } from '../common/PasswordLayoutConfig';
import { SlObserverProxy } from '../../observer/SlObserverProxy';
import { RtlCalculateUtils } from '../../utils/RtlCalculateUtils';

const TAG = 'NumKeyBoard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const PLUS_SING_INDEX: number = 10;
const PLUS_SING_FONT_WEIGHT: number = 300;
const NUM_KEYBOARD_LETTER_SPACING: number = 1;
const LIGHT_INTENSITY: number = 2;
const HOVER_EXIT = 2;
const PAD_LANDSCAPE_COLUMN_HIGHER_THAN_PORTRAIT: number = 7;

@Component
export default struct NumKeyBoard {
  private passwordVm?: ScreenLockPasswordVm;
  private onKeyBackPress: Function = () => {};
  private onEmergencyKeyClick: Function = () => {};
  @Prop keyBoardHeight: number = 0;
  private unlockCallback: Function = () => {};
  private delPwdIndex: number = RtlCalculateUtils.getDelPwdIndex();
  @Prop keyBoardMargin: Margin = {};
  private backKeyboardItem: DigitalKeyboardItem | null = null;
  private numKeyBoardViewModel: NumKeyBoardViewModel = new NumKeyBoardViewModel();
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();
  @StorageLink('numKeyboard') numKeyboard: DigitalKeyboardItem[] = RtlCalculateUtils.getNumberKeyBoard();
  @StorageLink('hasVoiceCapability') hasVoiceCapability: boolean = true; // Using the capability to judge device type
  @State numKeyPress: boolean[] = [false];
  @State isScreenOn: boolean = this.slObserverProxy.isScreenOn();
  @State lightIntensity: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  @State subLightIntensity: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  @State bloomValue: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  @State isZhLanguage: boolean = true;
  @State deleteRowText: string | Resource = '';
  @State deleteRowValue: number = Constants.GO_BACK;
  @State lightBgColor: ResourceColor[] = [Color.Transparent];
  @State brightnessOptionsNumber:BrightnessOptions[] = [];
  @State brightnessOptionsLetter:BrightnessOptions[] = [];
  offHandNormalizedSpeed: number = 0;
  private isHddProduct: boolean = SystemParamUtils.isHddProduct();
  @Consume psdLayoutData: PassWordLayout;
  @Consume displayHeight: number;
  @Consume passWordWidth: number;
  private isPsdAccessAccessibility: boolean = false;
  @State shouldLetteFocus: boolean = true;
  @Consume isDeviceLandscape: boolean;

  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  /**
   * 锁屏壁纸状态，用于获取壁纸反色
   */
  @State @Watch('onSLWallpaperStateChange') slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @Consume @Watch('onPassWordLayoutConfigChange') passwordLayoutConfig: PasswordLayoutConfig;
  @State specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();

  private animationKeyUp: AniCallback = {
    onAnimationGoing: (index: number) => { this.keyTouchUpAniPara(index); }
  }
  private animationKeyDown: AniCallback = {
    onAnimationPre: (index: number) => { this.keyTouchDownAniPrePara(index); },
    onAnimationGoing: (index: number) => { this.keyTouchDownAniPara(index); }
  }
  private initNumKeyPress: Function = () => {
    this.numKeyPress = new Array(this.numKeyboard.length).fill(false);
  }
  private setNumKeyPressStatus: Function = (item:DigitalKeyboardItem) => {
    this.numKeyPress[item.index] = true;
  }

  private passwordChangeListener: PasswordChangeListener = {
    onPasswordChange: (isAdd: boolean, passwordLength: number): void => {
      // 根据密码位数，更新小键盘的按钮
      if (passwordLength === 0) {
        this.numKeyboard[this.delPwdIndex].row1 =
          this.backKeyboardItem ? this.backKeyboardItem.row1 : $r('app.string.psd_back');
        this.numKeyboard[this.delPwdIndex].value =
          this.backKeyboardItem ? this.backKeyboardItem.value : Constants.GO_BACK;
      } else {
        this.numKeyboard[this.delPwdIndex].row1 = $r('app.string.psd_delete');
        this.numKeyboard[this.delPwdIndex].value = Constants.DEL_PWD;
      }
      this.numKeyboard[this.delPwdIndex].needAnimation = false;
      this.deleteRowText = this.numKeyboard[this.delPwdIndex].row1;
      this.deleteRowValue = this.numKeyboard[this.delPwdIndex].value;

      log.showInfo(`onPasswordChange passwordLength: ${passwordLength}, delPwd: ${JSON.stringify(this.numKeyboard[this.delPwdIndex])}`);
    }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    // 返回键恢复默认
    this.numKeyboard[this.delPwdIndex].row1 = $r('app.string.psd_back');
    this.numKeyboard[this.delPwdIndex].value = Constants.GO_BACK;
    if (this.backKeyboardItem !== null) {
      this.numKeyboard[this.delPwdIndex].row1 = this.backKeyboardItem.row1;
      this.numKeyboard[this.delPwdIndex].value = this.backKeyboardItem.value;
      this.numKeyboard[this.delPwdIndex].index = this.delPwdIndex;
      log.showInfo('use custom back keyboardItem');
    }
    this.deleteRowText = this.numKeyboard[this.delPwdIndex].row1;
    this.deleteRowValue = this.numKeyboard[this.delPwdIndex].value;
    let curLanguage: string = getContext().resourceManager.getConfigurationSync().locale;
    if (curLanguage.startsWith('en')) {
      this.isZhLanguage = false;
    }
    this.brightnessOptionsNumber = new Array(this.numKeyboard.length).fill(this.getBrightnessOptions(false, false));
    this.brightnessOptionsLetter = new Array(this.numKeyboard.length).fill(this.getBrightnessOptions(false, true));
    this.numKeyBoardViewModel.initParam(this.passWordWidth, this.passwordVm, this.passwordLayoutConfig);
    this.numKeyBoardViewModel.initTouchAni(this.animationKeyUp, this.animationKeyDown, this.initNumKeyPress);
    this.numKeyBoardViewModel.numberKeyboard = this.numKeyboard;
    this.numKeyBoardViewModel.initAuthCallback(this.onKeyBackPress, this.onEmergencyKeyClick);
    this.isScreenOn = this.slObserverProxy.isScreenOn(isScreenOn => this.isScreenOn = isScreenOn);
    PasswordManager.getInstance().registerObserver(this.passwordChangeListener);
  }

  aboutToDisappear() {
    this.shouldLetteFocus = true;
    this.numKeyboard[this.delPwdIndex].needAnimation = true;
    this.numKeyBoardViewModel.setCurrentFocusBtnItem(null);
    this.slObserverProxy.release();
    PasswordManager.getInstance().unRegisterObserver(this.passwordChangeListener);
    log.showInfo('aboutToDisappear');
  }

  private onPassWordLayoutConfigChange(): void {
    log.showInfo('onPassWordLayoutConfigChange');
    this.numKeyBoardViewModel.setPasswordLayoutConfig(this.passwordLayoutConfig);
  }

  private onSLWallpaperStateChange(): void {
    log.showDebug(`onSLWallpaperStateChange`);
    this.brightnessOptionsLetter = new Array(this.numKeyboard.length).fill(this.getBrightnessOptions(false, true));
  }

  private keyTouchUpAniPara(index: number): void {
    this.numKeyPress[index] = false;
    this.lightIntensity[index] = 0;
    this.brightnessOptionsNumber[index] = this.getBrightnessOptions(false, false);
    this.brightnessOptionsLetter[index] = this.getBrightnessOptions(false, true);
    this.lightBgColor[index] = Color.Transparent;
    if (DeviceHelper.isPadOr2in1PcType()) {
      this.subLightIntensity[index] = 0;
    }
    this.bloomValue[index] = 0;
  }

  private keyTouchDownAniPara(index: number): void {
    this.numKeyPress[index] = true;
    this.brightnessOptionsNumber[index] = this.getBrightnessOptions(true, false);
    this.brightnessOptionsLetter[index] = this.getBrightnessOptions(true, true);
    this.lightIntensity[index] = LIGHT_INTENSITY;
    if (DeviceHelper.isPadOr2in1PcType()) {
      this.subLightIntensity[index] = 0.6;
    }
    this.bloomValue[index] = this.isHddProduct ? 0 : 72;
  }

  private keyTouchDownAniPrePara(index: number) {
    this.lightBgColor[index] = $r('app.color.numkey_point_light_bg');
    this.bloomValue[index] = this.isHddProduct ? 0 : 20;
  }

  /**
   * 界面组件内转场
   *
   * @param item 键盘输入信息
   */
  private gridItemTransitionSectionsAll(item: DigitalKeyboardItem): TransitionOptions | TransitionEffect {
    return item.needAnimation ?
    TransitionEffect.asymmetric(TransitionEffect.opacity(0)
      .animation({
        duration: Constants.PSD_ENTER_OPACITY_TIME,
        curve: Curve.Smooth,
        delay: item.turnNum * PasswordConstants.DELAY_TIME_PER_ROW
      })
      .combine(TransitionEffect.scale({
        x: Constants.NUM_KEYBOARD_INIT_SCALE,
        y: Constants.NUM_KEYBOARD_INIT_SCALE
      })
        .animation({
          curve: curves.interpolatingSpring(0, 0,
            PasswordConstants.PSD_ELEMENT_STIFFNESS, PasswordConstants.PSD_ELEMENT_DAMPING),
          delay: item.turnNum * PasswordConstants.DELAY_TIME_PER_ROW
        }))
      , TransitionEffect.IDENTITY) : TransitionEffect.IDENTITY
  }

  private getBgColor(item: DigitalKeyboardItem): Resource | string {
    // 应急模式下直接拉起密码盘，底色不跟随壁纸颜色刷新
    if (this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT) {
      if (this.numKeyBoardViewModel.isSpecialKey(item.value)) {
        return $r('app.color.transparent');
      }
      return $r('app.color.numkey_press_bg');
    }
    if (!this.numKeyBoardViewModel.isSpecialKey(item.value)) {
      return BrightnessOptionUtils.brightColor;
    }
    if (this.numKeyPress[item.index]) {
      if (DeviceHelper.isPadOr2in1PcType() &&
        item.value === Constants.EMERGENCY_CALL && !this.hasVoiceCapability) {
        return $r('app.color.transparent');
      } else {
        return this.slWallpaperState.isLightWallpaper ?
          $r('app.color.numkey_press_bg_black') : $r('app.color.numkey_press_bg');
      }
    } else {
      return $r('app.color.transparent');
    }
  }

  private getFontColor(item: DigitalKeyboardItem): ResourceColor | undefined {
    if (this.lightIntensity[item.index] > 0 && !this.numKeyBoardViewModel.isSpecialKey(item.value) ||
      this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT) {
      return $r('app.color.press_point_light_font_color');
    } else {
      return this.slWallpaperState.getWallpaperReverseColor();
    }
  }

  private getTopTextSpread(item: DigitalKeyboardItem): TextOverflow {
    if (!this.numKeyBoardViewModel.isSpecialKey(item.value)) {
      return TextOverflow.None;
    } else if (this.isScroll(item) && this.isScreenOn) {
      return TextOverflow.MARQUEE;
    } else {
      return TextOverflow.Clip;
    }
  }

  private isScroll(item: DigitalKeyboardItem): boolean {
    return item.value === Constants.EMERGENCY_CALL;
  }

  @Builder
  private SubLightForPad(item: DigitalKeyboardItem) {
    Row()
      .width($r('app.float.num_keyboard_grid_item_stack_size'))
      .height($r('app.float.num_keyboard_grid_item_stack_size'))
      .borderRadius($r('app.float.num_keyboard_bg_radius'))
    Row()
      .width($r('app.float.num_keyboard_grid_item_stack_size'))
      .height($r('app.float.num_keyboard_grid_item_stack_size'))
      .borderRadius($r('app.float.num_keyboard_bg_radius'))
  }

  /**
   * 密码按键按钮的上下间隔调整
   *
   * @param itemIndex 按键序号
   */
  private getNumBoardTopMargin(itemIndex: number): Margin | null {
    // 第一行的按钮没有上边距
    if (itemIndex < 3) {
      return null;
    }
    const lineIndex = Math.floor(itemIndex / PasswordConstants.NUM_POSITION_GROUP_ALIGN.size)
    if (!DeviceHelper.isPadOr2in1PcType()) {
      return {top: lineIndex *
        (this.passwordLayoutConfig.layoutConfig.numBoardHeight +
        this.passwordLayoutConfig.layoutConfig.numBoardTopMarginPhone)}
    } else {
      let topMargin: number =
        lineIndex * (PasswordConstants.NUM_KEYBOARD_HEIGHT + PasswordConstants.NUM_KEYBOARD_TOP_MARGIN_PAD);
      if (!this.isDeviceLandscape) {
        topMargin -= (PAD_LANDSCAPE_COLUMN_HIGHER_THAN_PORTRAIT * lineIndex);
      }
      return { top: topMargin };
    }
  }

  /**
   * 密码键盘光影节点
   *
   * @param item 键盘信息
   */
  @Builder
  private Light(item: DigitalKeyboardItem) {
    if (DeviceHelper.isPadOr2in1PcType() && !this.numKeyBoardViewModel.isSpecialKey(item.value)) {
      this.SubLightForPad(item);
    }
    if (!this.numKeyBoardViewModel.isSpecialKey(item.value)) {
      Row()
        .shadow({
          color: $r('app.color.numkey_point_light_bloom_color'),
          radius: this.bloomValue[item.index],
        })
        .width(this.passwordLayoutConfig.layoutConfig.numkeyboardGridItemStackSize)
        .height(this.passwordLayoutConfig.layoutConfig.numkeyboardGridItemStackSize)
        .border({
          radius: this.passwordLayoutConfig.layoutConfig.numKeyboardGridItemBgRadius,
          color: `rgba(255, 255, 255, ${this.lightIntensity[item.index] / LIGHT_INTENSITY * 0.5})`,
          width: this.lightIntensity[item.index] > 0 ? 1 : 0
        })
        .backgroundColor(this.lightBgColor[item.index])
    }
  }

  private getBrightnessOptions(pressed:boolean, letter:boolean) :BrightnessOptions {
    if (letter && !pressed) {
      // 下方字母未按压时提亮接口参数
      return this.slWallpaperState.isLightWallpaper ? PasswordConstants.LETTER_LIGHT_WALLPAPER_BRIGHTNESS_OPTIONS :
      PasswordConstants.LETTER_BRIGHTNESS_OPTIONS
    }
    // 上方数字及字母被按压时提亮接口参数
    return pressed ? PasswordConstants.NUMBER_PRESSED_BRIGHTNESS_OPTIONS : PasswordConstants.NUMBER_BRIGHTNESS_OPTIONS;
  }

  /**
   * 密码键盘底部字母字符
   *
   * @param item 键盘信息
   *
   */
  @Builder
  private LetterText(item: DigitalKeyboardItem) {
    if (item.row2 !== '') {
      Text(item.row2)
        .draggable(false)
        .fontSize(item.index === PLUS_SING_INDEX ?
          this.passwordLayoutConfig.layoutConfig.plusSignFontSize :
          this.passwordLayoutConfig.layoutConfig.letterTextFontSize)
        .minFontScale(sFontScaleUtil.getMinFontSize(this.passwordLayoutConfig.layoutConfig.outerScreenFlag))
        .maxFontScale(sFontScaleUtil.getMaxFontSize(this.passwordLayoutConfig.layoutConfig.outerScreenFlag, false))
        .fontFamily($r('app.float.pwd_prompt_font_family'))
        .fontWeight(item.index === PLUS_SING_INDEX ? PLUS_SING_FONT_WEIGHT : FontWeight.Medium)
        .fontColor(this.getFontColor(item))
        .foregroundBrightness(this.isHddProduct || this.numKeyBoardViewModel.isSpecialKey(item.value) ||
          (this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT) ? undefined :
        this.brightnessOptionsLetter[item.index])
        .letterSpacing(NUM_KEYBOARD_LETTER_SPACING)
        .lineHeight(this.fontScale.letterTextLineHeight)
        .height(this.passwordLayoutConfig.layoutConfig.numKeyboardLetterTextHeight)
        .offset({
          y: item.index === PLUS_SING_INDEX ? this.fontScale.plusSingOffset : this.fontScale.numButtonOEngLetterOffset
        })
        .textAlign(TextAlign.Center)
        .width('100%')
        .focusable(this.shouldLetteFocus)
        .id('numKeyBoard')
        .onAppear(() => {
          let isSuccess = focusControl.requestFocus('numKeyBoard');
          log.showDebug(`numKeyBoard requestFocus isSuccess = ${isSuccess}`);
        })
        .accessibilityLevel('no')
    }
  }
  /**
   * 密码键盘按钮上部数字字符
   *
   * @param item 键盘信息
   */
  @Builder
  private NumberText(item: DigitalKeyboardItem) {
    if (item.value !== Constants.EMERGENCY_CALL || this.hasVoiceCapability) {
      Text(item.index === this.delPwdIndex ? this.deleteRowText : item.row1)
        .draggable(false)
        .fontSize(this.numKeyBoardViewModel.isSpecialKey(item.value) ?
        this.passwordLayoutConfig.layoutConfig.specialFontSize : this.passwordLayoutConfig.layoutConfig.numberFontSize)
        .minFontScale(sFontScaleUtil.getMinFontSize(this.passwordLayoutConfig.layoutConfig.outerScreenFlag))
        .maxFontScale(sFontScaleUtil.getMaxFontSize(this.passwordLayoutConfig.layoutConfig.outerScreenFlag,
          this.numKeyBoardViewModel.isSpecialKey(item.value)))
        .fontFamily($r('app.float.pwd_prompt_font_family'))
        .maxLines(1)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.getFontColor(item))
        .foregroundBrightness(this.isHddProduct || this.numKeyBoardViewModel.isSpecialKey(item.value) ? undefined :
          this.brightnessOptionsNumber[item.index])
        .textAlign(TextAlign.Center)
        .height(this.passwordLayoutConfig.layoutConfig.numKeyboardBgWidthHeight)
        .width('100%')
        .clip(true)
        .offset({
          y: this.numKeyBoardViewModel.isSpecialKey(item.value) ? this.fontScale.numButtonOffsetSpecialKey :
          this.fontScale.numButtonOffset
        })
        .textOverflow({ overflow: this.getTopTextSpread(item) })
        .accessibilityLevel('no')
    } else {
      Blank()
    }
  }

  private getBrightness(item: DigitalKeyboardItem): BrightnessOptions | undefined {
    if (this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT ||
    this.numKeyBoardViewModel.isSpecialKey(item.value)) {
      return;
    }
    return slWallpaperMgr.getSlWallpaperState().isLightWallpaper ? BrightnessOptionUtils.passwordDarkOption :
    BrightnessOptionUtils.passwordLightOption;
  }

  /**
   * 密码键盘按钮
   *
   * @param item 键盘信息
   */
  @Builder
  private numButton(item: DigitalKeyboardItem) {
    Stack(this.numKeyBoardViewModel.isSpecialKey(item.value) ? { alignContent: Alignment.Center } :
      { alignContent: Alignment.Top }) {
      // 键盘发光效果
      if (!this.isHddProduct) {
        this.Light(item)
      }

      // 底部字母字符
      this.LetterText(item)

      // 上部数字字符
      this.NumberText(item)
    }
    .width(this.passwordLayoutConfig.layoutConfig.numkeyboardGridItemStackSize)
    .height(this.passwordLayoutConfig.layoutConfig.numkeyboardGridItemStackSize)
    .alignRules(PasswordConstants.NUM_POSITION_GROUP_ALIGN.get(item.index %
      PasswordConstants.NUM_POSITION_GROUP_ALIGN.size))
    .borderRadius(this.numKeyBoardViewModel.isSpecialKey(item.value) ?
      this.passwordLayoutConfig.layoutConfig.numKeyboardSpecialKeyBgRadius :
      this.passwordLayoutConfig.layoutConfig.numKeyboardGridItemBgRadius)
    .backgroundColor(this.getBgColor(item))
    .backgroundBrightnessInternal(this.getBrightness(item))
    .clip(false)
    .margin(this.getNumBoardTopMargin(item.index))
    .responseRegion({
      x: this.numKeyBoardViewModel.getHotZoneOffset(item),
      y: this.numKeyBoardViewModel.getHotZoneOffset(item),
      width: this.numKeyBoardViewModel.getHotZoneWith(),
      height: this.numKeyBoardViewModel.getHotZoneHeight()
    })
    .transition(
      this.gridItemTransitionSectionsAll(item)
    )
    .gesture(LongPressGesture()
        .onAction(() => {
          if (item.index === RtlCalculateUtils.getDelPwdIndex()) {
            this.passwordVm?.clearPassword();
          }
        })
    )
    .onAccessibilityHover(this.numKeyBoardViewModel.isSpecialKey(item.value) ?
      undefined : (isHover: boolean, event: AccessibilityHoverEvent) => {
      if (!isHover && event.type === HOVER_EXIT && accessibility.isOpenTouchGuideSync()) {
        this.numKeyBoardViewModel.onKeyClickItem(item, this.isPsdAccessAccessibility)
      }
    })
    .onClick(() => {
      if (accessibility.isOpenTouchGuideSync()) {
        this.numKeyBoardViewModel.onKeyClickItem(item, this.isPsdAccessAccessibility);
      }
    })
    .onTouch((event?: TouchEvent) => {
      this.numKeyBoardViewModel.NumKeyOnTouchEvent(item, this.numKeyPress, this.setNumKeyPressStatus, event);
    })
    .accessibilityRole(this.numKeyBoardViewModel.isSpecialKey(item.value) ?
      AccessibilityRoleType.BUTTON : AccessibilityRoleType.ROLE_NONE)
    .accessibilityText(
      this.numKeyBoardViewModel.isSpecialKey(item.value, this.deleteRowValue) ?
      this.numKeyBoardViewModel.specialKey(item.value, this.backKeyboardItem) :
      ResUtils.getInnerString(item.row3)
    )
    .accessibilityDescription(
      this.numKeyBoardViewModel.isSpecialKey(item.value) ?
      ResUtils.getInnerString($r('app.string.widgets_two_click_accessible')) : ' ')
    .focusable(!(DeviceHelper.isPadOr2in1PcType() && item.value === Constants.EMERGENCY_CALL && 
    !this.hasVoiceCapability))
    .onFocus(() => {
      log.showInfo(`onFocus: ${item.index}`);
      this.numKeyBoardViewModel.setCurrentFocusBtnItem(item);
    })
    .onBlur(() => {
      log.showInfo(`onBlur: ${item.index}`);
      this.numKeyBoardViewModel.setCurrentFocusBtnItem(null);
    })
  }

  build() {
    RelativeContainer() {
      ForEach(this.numKeyboard, (item: DigitalKeyboardItem, index: number) => {
        if (!this.numKeyBoardViewModel.isForbiddenEmergencyCallOnPad(item)) {
          this.numButton(item);
        }
      })
    }
    .clip(false)
    .defaultFocus(true)
    .width('100%')
    .direction(Direction.Ltr)
    .height(this.keyBoardHeight)
    .margin(this.keyBoardMargin)
    .onKeyEvent((event?: KeyEvent) => {
      this.numKeyBoardViewModel.NumKeyOnKeyEvent(this.shouldLetteFocus, () => {
        this.shouldLetteFocus = false;
      }, this.unlockCallback, event);
    })
    .transition(
      TransitionEffect.asymmetric(
        TransitionEffect.opacity(0).animation({
          duration: Constants.PSD_ENTER_OPACITY_TIME,
          curve: Curve.Smooth
        }).combine(TransitionEffect.scale({
          x: PasswordConstants.PSD_ZONE_INIT_SCALE,
          y: PasswordConstants.PSD_ZONE_INIT_SCALE,
          centerX: '50%',
          centerY: '0%'
        })
          .animation({
            curve: curves.interpolatingSpring(0, 0,
              PasswordConstants.PSD_ELEMENT_STIFFNESS, PasswordConstants.PSD_ELEMENT_DAMPING),
          }))
        , TransitionEffect.IDENTITY),
      (transitionIn: boolean) => {
        if (transitionIn) {
          Trace.end(TraceTag.SHOW_PSD, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        }
      }
    )
  }
}