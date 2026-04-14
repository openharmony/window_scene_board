/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import curves from '@ohos.curves';
import componentUtils from '@ohos.arkui.componentUtils';
import display from '@ohos.display';
import inputMethodUtil from './SCBInputMethodUtil';
import keyboardPanelManager from '@ohos.keyboardPanelManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { drawing, common2D } from '@kit.ArkGraphics2D';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { floatingNavigationInfoMgr } from '@ohos/componenthelper';
import { inputMethod } from '@kit.IMEKit';
import { image } from '@kit.ImageKit';
import { RTLUtil } from '@ohos/componenthelper';
import { vibrator } from '@kit.SensorServiceKit';
import {
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName
} from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  PatternAction,
  SCBKeyboardSession,
  SCBKeyboardPanelSession,
  SCBScreenProperty,
  SCBSessionRect,
  SCBKeyboardPanelManager,
  SCBScreenSessionManager,
  KeyboardBarOption,
  KeyboardBarParams,
  KeyboardChangeCallback,
  SCBKeyboardManager
} from '@ohos/windowscene';

const COLOR_MODE_LIGHT: number = 1;
const DIALOG_FOLDABLE_PHONE_EXPAND_LAND_OFFSET: number = 21;
const DIALOG_FOLDABLE_PHONE_EXPAND_OFFSET: number = 24;
const DIALOG_PHONE_FLOAT_OFFSET: number = 8;
const DIALOG_PHONE_LAND_OFFSET: number = 84;
const DIALOG_PHONE_OFFSET: number = 7;
const DIALOG_PHONE_ONE_HAND_OFFSET: number = 7;
const TAG: string = 'SCBIMFKeyboardPanelBar';
const PANEL_DIALOG_OFFSET_X: number = 42;
const PANEL_DIALOG_OFFSET_X_FLOAT: number = 36;
const PANEL_DIALOG_OFFSET_Y: number = 8;
const PANEL_IMAGE_SIZE: number = 24;
const PANEL_FLOAT_IMAGE_SIZE: number = 20;
const PANEL_FLOAT_SCREEN_WIDTH: number = 288;
const PANEL_IAMGE_RADIUS: number = 21;
const SMART_IMAGE_COLOR_DARK: ColorFilter = [-1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0.58, 0];
const SMART_IMAGE_COLOR_LIGHT: ColorFilter = [-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 0.60, 0];
const THREE_PARTY_INPUT_METHOD_PADDING: number = 0;
const TOAST_BOTTOM: number = 20; //toast distance from bottom of the keyboard
const TOAST_FONT_SIZE: number = 14;
const TOAST_BOX_HEIGHT: number = 20; //toast text box height
const TOAST_MAX_FONT_SCALE: number = 1.15;
const TOAST_FONT_SCALE: number = 0.8; //onehand mode font scale
const TOAST_DEFAULT_OFFSET: number = 0;
const FOLDABLE_LEFT_KEY_RESPONSE_REGION_LEFT_OFFSET: string = '-6';
const FOLDABLE_RIGHT_KEY_RESPONSE_REGION_LEFT_OFFSET: string = '-6';
const FOLDABLE_RESPONSE_REGION_UP_OFFSET: string = '0';
const FOLDABLE_RESPONSE_REGION_WIDTH: string = '44';
const FOLDABLE_RESPONSE_REGION_HEIGHT: string = '41';
const EXPAND_RESPONSE_REGION_LEFT_OFFSET: string = '-15';
const EXPAND_RESPONSE_REGION_UP_OFFSET: string = '-6';
const EXPAND_RESPONSE_REGION_WIDTH: string = '171%';
const EXPAND_RESPONSE_REGION_HEIGHT: string = '140%';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const IMAGE_MAX_SCALE: number = 1;
const IMAGE_MIN_SCALE: number = 0.8;
const DEFAULT_DPI: number = 3.125;
const SCENE_TYPE: string = 'keyboardShowScene';
const enum OneHandMode {
    INVALID_VALUE = -1,
    LEFT = 0,
    RIGHT = 1
}

PersistentStorage.persistProp('leftCount', 0);
PersistentStorage.persistProp('rightCount', 0);

@Extend(Image)
function smartImage(imageSize: number) {
  .size({
    width: imageSize,
    height: imageSize
  })
  .draggable(false)
  .renderGroup(true)
  .objectFit(ImageFit.Cover)
  .interpolation(ImageInterpolation.Medium)
  .hitTestBehavior(HitTestMode.None)
}

@Component
export struct SCBKeyboardPanelBar {
  @Link dialogType: string;
  @Link dialogOffset: number[];
  @Link isShowDialog: boolean
  @Link screenProperty: SCBScreenProperty;
  @StorageLink('isSmartClicked') isSmartClicked: boolean = false;
  @StorageLink('patternOption') patternOption: number = 0;
  @State imageLeftBtnScale: number = 1;
  @State imageRightBtnScale: number = 1;
  @State isRunLeftClickAnimation: boolean = false;
  @State isRunRightClickAnimation: boolean = false;
  @State isRunAnimation: boolean = false;
  @State isFloat: boolean = false;
  @State isNavigationShow: boolean = false;
  @State isShowToast: boolean = false;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @ObjectLink panelRect: SCBSessionRect;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @StorageLink('leftCount') leftCount: number = 0;
  @StorageLink('rightCount') rightCount: number = 0;
  private touchId: number = -1;
  private isMirrorLanguageType: boolean = false;
  private currentDisplay: display.Display | undefined = undefined;
  private keyboardChangeCallback: KeyboardChangeCallback = {
    onRectChangeChange: (rect: sceneSessionManager.SessionRect,
                         reason: sceneSessionManager.SessionSizeChangeReason) => {
      log.showInfo('onRectChangeChange function not implemented.');
    },

    onSessionTouchableChange: (isTouchable: boolean) => {
      log.showInfo('onSessionTouchableChange function not implemented.');
    },

    onCustomAnimationPlaying: (isPlaying: boolean) => {
      log.showInfo('onCustomAnimationPlaying function not implemented.');
    },

    onForceHide: (hide: boolean) => {
      log.showInfo('onForceHide function not implemented.');
    },

    getZIndex: (): number => {
      return 0;
    },

    onKeyboardGravityChange: (sessionGravity: sceneSessionManager.KeyboardGravity): void => {
      log.showDebug('onKeyboardGravityChange.');
      this.isFloat = (sessionGravity === sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT);
    },

    onVirtualScreenStateChange : (
      screenId: number, persistentId: number, state: sceneSessionManager.SessionState) => {
      log.showDebug('onVirtualScreenStateChange function not implemented.');
    },

    onCallingSessionChange: (callingSessionId: number) => {
      log.showDebug('onCallingSessionChange function not implemented.');
    }
  }
  
  isLand(): boolean {
    return this.keyboardPanelSession?.isLandscape;
  }

  /**
    * Update three key navigation show
    * 
    * @returns {boolean}
    */
  private updateIsNavigationShow(): void {
    let showType = floatingNavigationInfoMgr.getFloatingNavigationInfo().showType;
    if (showType === 0) {
      log.showInfo(`isNavigationShow, showType = ${showType}`);
      this.isNavigationShow = true;
      return;
    }
    this.isNavigationShow = false;
  }

  aboutToAppear(): void {
    this.dismissKeyboardDialog();
    this.isFloat = this.keyboardSession.isFloatGravity();
    this.isMirrorLanguageType = RTLUtil.isRTL();
    this.keyboardPanelSession?.getSmartButton();
    if (this.keyboardSession instanceof SCBKeyboardSession) {
      SCBKeyboardManager.getInstance().registerkeyboardGravityChangeCallbacks(this.keyboardChangeCallback);
    }
    this.updateIsNavigationShow();
    floatingNavigationInfoMgr.registerNavigationInfoObserver(SCENE_TYPE, () => {
      this.updateIsNavigationShow();
    })   
  }

  aboutToDisappear(): void {
    if (this.keyboardSession instanceof SCBKeyboardSession) {
      SCBKeyboardManager.getInstance().unRegisterkeyboardGravityChangeCallbacks(this.keyboardChangeCallback);
    }
    floatingNavigationInfoMgr.unRegisterNavigationInfoObserver(SCENE_TYPE);
  }

  getImageSize(isSmart: boolean): number {
    if (this.isFloat) {
      let newImageSize = PANEL_FLOAT_IMAGE_SIZE * this.panelRect?.width.getVp() / PANEL_FLOAT_SCREEN_WIDTH;
      return newImageSize > PANEL_FLOAT_IMAGE_SIZE ? PANEL_FLOAT_IMAGE_SIZE : newImageSize;
    }
    return PANEL_IMAGE_SIZE;
  }

  private getImageColor(isSmart: boolean, functionKeyColor: string): ColorFilter | string | Resource {
    if (functionKeyColor !== '') {
      if (isSmart) {
        try {
          return drawing.ColorFilter.createBlendModeColorFilter(drawing.Tool.makeColorFromResourceColor(
            this.keyboardPanelSession?.functionKeyColor), drawing.BlendMode.SRC_IN);
        } catch (err) {
          let error = err as BusinessError;
          log.showError(`getImageColor failed, message: ${error.message}, code: ${error.code}`);
          return !this.isSmartClicked && this.currColorMode === COLOR_MODE_LIGHT ?
            SMART_IMAGE_COLOR_DARK : SMART_IMAGE_COLOR_LIGHT;
        }
      } else {
        return functionKeyColor;
      }
    }
    if (inputMethodUtil.isEnableImmersive(this.keyboardPanelSession?.keyboardViewMode)) {
      return $r('app.color.keyboard_immersive_color');
    }
    return isSmart ? ((!this.isSmartClicked && this.currColorMode === COLOR_MODE_LIGHT) ? 
      SMART_IMAGE_COLOR_DARK : SMART_IMAGE_COLOR_LIGHT) : $r('sys.color.ohos_id_color_secondary');
  }

  private getBackgroundImageColor(): string | Resource {
    if (this.keyboardPanelSession?.functionKeyPressColor !== '') {
      return this.keyboardPanelSession?.functionKeyPressColor;
    }
    return inputMethodUtil.getPressedEffectColor(this.keyboardPanelSession?.keyboardViewMode);
  }

  public isNotExpandOrSamllFold(): boolean {
    return !SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() || DeviceHelper.isSmallFoldProduct();
  }
  
  public isExpandAndNotSmallFold(): boolean {
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() && !DeviceHelper.isSmallFoldProduct();
  }

  getImageHot(): Resource {
    if (this.isFloat) {
      return $r('app.float.keyboard_tool_image_hot_float');
    }
    if (this.isExpandAndNotSmallFold()) {
      return $r('app.float.keyboard_tool_image_hot_expand');
    }
    if (this.isLand() && this.isNotExpandOrSamllFold()) {
      return $r('app.float.keyboard_tool_image_hot_landspace');
    }
    return $r('app.float.keyboard_tool_image_hot');
  }

  getOneHandMode(): OneHandMode {
    if (this.keyboardPanelSession?.toolbarPaddingLeft === this.keyboardPanelSession?.toolbarPaddingRight) {
      return OneHandMode.INVALID_VALUE;
    }
    if (this.keyboardPanelSession?.toolbarPaddingLeft > this.keyboardPanelSession?.toolbarPaddingRight &&
      this.keyboardPanelSession.getPatternOption() === PatternAction.ONE_HAND) {
      return OneHandMode.RIGHT;
    }
    if (this.keyboardPanelSession?.toolbarPaddingLeft < this.keyboardPanelSession?.toolbarPaddingRight &&
      this.keyboardPanelSession.getPatternOption() === PatternAction.ONE_HAND) {
      return OneHandMode.LEFT;
    }
    return OneHandMode.INVALID_VALUE;
  }

  getkeyboardBarParamsObject(): KeyboardBarOption | undefined {
    let keyboardBarObject: KeyboardBarParams = SCBKeyboardPanelManager.getInstance().keyboardBarParams;
    if (keyboardBarObject === null || keyboardBarObject === undefined) {
      return undefined;
    }
    if (!this.isNavigationShow) {
      if (this.getOneHandMode() === OneHandMode.LEFT) {
        return keyboardBarObject.leftOneHand;
      }
      if (this.getOneHandMode() === OneHandMode.RIGHT) {
        return keyboardBarObject.rightOneHand;
      }
    }

    if (this.isFloat) {
      return keyboardBarObject.float;
    }
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      return keyboardBarObject.expand;
    }
    return keyboardBarObject.unexpand;
  }

  getVpWithDPI(defaultValue: number): number {
    if (this.currentDisplay === undefined) {
      this.currentDisplay = SCBKeyboardPanelManager.getInstance().getDefaultDisplaySync();
    }
    if (this.currentDisplay === undefined || this.currentDisplay == null) {
        log.showWarn('currentDisplay is null');
        return defaultValue;
    }
    return defaultValue * (this.currentDisplay.densityPixels / DEFAULT_DPI);
  }

  getPanelPadding(isNavigationShow: boolean): Padding {
    if (isNavigationShow) {
      return { left:this.getVpWithDPI(THREE_PARTY_INPUT_METHOD_PADDING),
        right: this.getVpWithDPI(THREE_PARTY_INPUT_METHOD_PADDING) };
    }
    if (this.isMirrorLanguageType) {
      return { left:this.getVpWithDPI(this.keyboardPanelSession?.toolbarPaddingRight),
        right: this.getVpWithDPI(this.keyboardPanelSession?.toolbarPaddingLeft) };
    }
    return { left:this.getVpWithDPI(this.keyboardPanelSession?.toolbarPaddingLeft),
      right: this.getVpWithDPI(this.keyboardPanelSession?.toolbarPaddingRight) };
  }

  getResponseRegion(isSmart: boolean): Rectangle {
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      return { x: EXPAND_RESPONSE_REGION_LEFT_OFFSET, y: EXPAND_RESPONSE_REGION_UP_OFFSET, 
      width: EXPAND_RESPONSE_REGION_WIDTH, height: EXPAND_RESPONSE_REGION_HEIGHT };
    } else {
      return (isSmart ? {
        x: FOLDABLE_RIGHT_KEY_RESPONSE_REGION_LEFT_OFFSET, 
        y: FOLDABLE_RESPONSE_REGION_UP_OFFSET,
        width: FOLDABLE_RESPONSE_REGION_WIDTH,
        height: FOLDABLE_RESPONSE_REGION_HEIGHT } : { 
        x: FOLDABLE_LEFT_KEY_RESPONSE_REGION_LEFT_OFFSET,
        y: FOLDABLE_RESPONSE_REGION_UP_OFFSET,
        width: FOLDABLE_RESPONSE_REGION_WIDTH,
        height: FOLDABLE_RESPONSE_REGION_HEIGHT
      });
    }
  }

  isPhoneLand(): boolean {
    return SCBKeyboardPanelManager.getInstance().isPhoneLand();
  }

  private getAccessibilityText(isSmart: boolean): string {
    let res = getContext(this).resourceManager;
    return res.getStringByNameSync(isSmart ? 'keyboard_panel_smart_access_text' : 'keyboard_panel_world_access_text');
  }

  @Builder
  ImageBtn(name: string, isSmart: boolean) {
    Column() {
      if (isSmart) {
        Image(this.getRightIcon())
          .smartImage(this.getImageSize(isSmart))
          .colorFilter(this.getImageColor(isSmart, this.keyboardPanelSession?.functionKeyColor))
          .renderFit(RenderFit.TOP_LEFT)
          .scale({x: this.imageRightBtnScale, y: this.imageRightBtnScale})
          .animation({ duration: 200, curve: curves.interpolatingSpring(0, 1, 288, 24) })
          .advancedBlendMode(inputMethodUtil.getImageImmersiveMode(this.keyboardPanelSession?.keyboardViewMode))
      } else {
        Image($r('app.media.ic_keyboard_panel_worldclock'))
          .smartImage(this.getImageSize(isSmart))
          .fillColor(this.getImageColor(isSmart, this.keyboardPanelSession?.functionKeyColor))
          .renderFit(RenderFit.RESIZE_FILL)
          .scale({x: this.imageLeftBtnScale, y: this.imageLeftBtnScale})
          .animation({ duration: 200, curve: curves.interpolatingSpring(0, 1, 288, 24) })
          .advancedBlendMode(inputMethodUtil.getImageImmersiveMode(this.keyboardPanelSession?.keyboardViewMode))
      }
    }
    .justifyContent(FlexAlign.Center)
    .size({ width: this.getImageHot(), height: this.getImageHot() })
    .scale(isSmart ? { x: this.imageRightBtnScale, y: this.imageRightBtnScale }
      : { x: this.imageLeftBtnScale, y: this.imageLeftBtnScale })
    .borderRadius(PANEL_IAMGE_RADIUS)
    .draggable(false)
    .responseRegion(this.getResponseRegion(isSmart))
    .id(name)
    .accessibilityGroup(true)
    .accessibilityText(this.getAccessibilityText(isSmart))
    .backgroundColor( this.isShowBackgroundColor(isSmart) ? this.getBackgroundImageColor() :
      $r('app.color.keyboard_panel_button_color'))
    .animation({ duration: 200, curve: curves.interpolatingSpring(0, 1, 288, 24) })
    .onTouch((event) => {
      if (event.type === TouchType.Down) {
        if (this.isRunAnimation) {
          return;
        }
        if (isSmart) {
          this.isRunRightClickAnimation = true;
        } else {
          this.isRunLeftClickAnimation = true;
        }
        this.isRunAnimation = true;
        this.changeImageBtnScale(isSmart, IMAGE_MIN_SCALE);
      }
      if (event.type === TouchType.Up) {
        log.showInfo(`[SCBKeyboard] short press, isSmart:${isSmart}`);
        if (this.isRunRightClickAnimation || this.isRunLeftClickAnimation) {
          this.isRunRightClickAnimation = false;
          this.isRunLeftClickAnimation = false;
          setTimeout(() => {
            this.isRunAnimation = false;
          }, 200);
          this.changeImageBtnScale(isSmart, IMAGE_MAX_SCALE);
        }
        if (!(event.touches && event.touches.length > 0 && event.touches[0])) {
          return;
        }
        if (event.touches[0].id === this.touchId || this.isShowToast) {
          this.touchId = -1;
          return;
        }
        this.showToast(isSmart, true);
      }
    })   
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture({ fingers: 1, repeat: false })
          .onAction((event: GestureEvent) => {
            log.showInfo(`[SCBKeyboard] long press, isSmart:${isSmart}`);
            if (!(event && event.fingerList && event.fingerList.length > 0 && event.fingerList[0])) {
              return;
            }
            this.touchId = event.fingerList[0].id as number;
            this.isRunRightClickAnimation = false;
            this.isRunLeftClickAnimation = false;
            this.isRunAnimation = false;
            this.changeImageBtnScale(isSmart, IMAGE_MAX_SCALE);
            this.buttonLongClick(isSmart);
            this.showToast(isSmart, false);
          })
      )
    )
  }

  /**
    * Keyboard left and right key prompt message whether to display calculate.
    * 
    */
  private showToast(isSmart: boolean, isShortPress: boolean): void {
    if (this.isPhoneLand()) {
      return;
    }
    let count = isSmart ? this.rightCount : this.leftCount;
    const maxShortPressCount: number = 2;
    const maxLongPressCount: number = 5;
    if (count > maxShortPressCount && count !== maxLongPressCount ) {
      return;
    }
    if (isSmart) {
      this.rightCount = isShortPress ? this.rightCount + 1 : maxLongPressCount;
    } else {
      this.leftCount = isShortPress ? this.leftCount + 1 : maxLongPressCount;
    }
    
    if (isShortPress) {
      this.isShowToast = true;
      if (this.isShowToast) {
        setTimeout(() => {
          this.isShowToast = false;
        }, 2000);
      }
    }
  }

  isShowBackgroundColor(isSmart: boolean): boolean {
    if (((this.isShowDialog && this.dialogType === 'left') || this.isRunLeftClickAnimation) && !isSmart) {
      return true;
    }
    if (((this.isShowDialog && this.dialogType === 'right') || this.isRunRightClickAnimation) && isSmart) {
      return true;
    }
    return false;
  }

  changeImageBtnScale(isSmart: boolean, scaleNumber: number): void {
    if (isSmart) {
      this.imageRightBtnScale = scaleNumber;
    } else {
      this.imageLeftBtnScale = scaleNumber;
    }
  }

  getBarPadding(isSmart: boolean): number {
    if (this.isLand()) {
      return this.getVpWithDPI(isSmart ? this.getkeyboardBarParamsObject()?.landscapeRightElevateDistance as number :
        this.getkeyboardBarParamsObject()?.landscapeLeftElevateDistance as number);
    }
    return this.getVpWithDPI(isSmart ? this.getkeyboardBarParamsObject()?.portraitRightElevateDistance as number :
      this.getkeyboardBarParamsObject()?.portraitLeftElevateDistance as number);
  }

  getElevatHeight(): number {
    if (this.isLand()) {
      return this.getkeyboardBarParamsObject()?.landscapeElevateHeight as number;
    }
    return this.getkeyboardBarParamsObject()?.portraitElevateHeight as number;
  }

  getPanelBarShowHeight(): number {
    if (this.isPhoneLand()) {
      return px2vp(this.keyboardPanelSession?.getPanelRealHeight());
    }
    return this.keyboardPanelSession?.hotAreaBottom;
  }

  @Builder
  ImageBtnToast() {
    if (this.isShowToast) {
      Text($r('app.string.keyborad_click_prompt'))
      .hitTestBehavior(HitTestMode.None)
      .width('100%')
      .layoutWeight(1)
      .height(TOAST_BOX_HEIGHT)
      .fontSize(this.getToastFontSize())
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .textAlign(TextAlign.Center)
      .maxFontScale(TOAST_MAX_FONT_SCALE)
      .margin({ bottom: TOAST_BOTTOM })
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Row() {
        Column() {
          this.ImageBtn('keyboardLeftButton', false);
        }
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Start)
        .padding(this.isMirrorLanguageType ? { right: this.getBarPadding(false), bottom: this.getElevatHeight() } :
          { left: this.getBarPadding(false), bottom: this.getElevatHeight() })
        this.ImageBtnToast()
        Column() {
          this.ImageBtn('keyboardRightButton', true);
        }
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.End)
        .padding(this.isMirrorLanguageType ? { left: this.getBarPadding(true), bottom: this.getElevatHeight() } :
          { right: this.getBarPadding(true), bottom: this.getElevatHeight() })
      }
      .alignItems(VerticalAlign.Bottom)
      .width(this.panelRect.width.getPxStr())
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(this.getPanelPadding(this.isNavigationShow))
      .height('100%')
      .visibility(inputMethodUtil.isBarHidden() ? Visibility.Hidden : Visibility.Visible)
    }
    .width(this.panelRect.width.getPxStr())
    .height('100%')
    .zIndex(2)
    .id('inputMethodPanel')
  }

  private getToastFontSize(): number {
    if (this.keyboardPanelSession?.toolbarPaddingRight > 0 || this.keyboardPanelSession?.toolbarPaddingLeft > 0) {
      return TOAST_FONT_SIZE * TOAST_FONT_SCALE;
    }
    return TOAST_FONT_SIZE;
  }

  getRightIcon(): string | image.PixelMap | Resource {
    log.showInfo(`[SCBKeyboard] getRightIcon this.isSmartClicked = ${this.isSmartClicked}`);
    if (this.isSmartClicked && this.keyboardPanelSession?.rightSelectedIcon) {
      return this.keyboardPanelSession?.rightSelectedIcon;
    }
    if (this.keyboardPanelSession?.rightIcon) {
      return this.keyboardPanelSession?.rightIcon;
    }
    if (this.keyboardPanelSession?.smartButtonInfo?.smartButton) {
      return $r('app.media.ic_keyboard_panel_smart');
    }
    return '';
  }

  getDialogOffsetPadding(): number {
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() && this.isLand()) {
      return DIALOG_FOLDABLE_PHONE_EXPAND_LAND_OFFSET;
    }
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      return DIALOG_FOLDABLE_PHONE_EXPAND_OFFSET;
    }
    if (this.isLand()) {
      return DIALOG_PHONE_LAND_OFFSET;
    }
    return DIALOG_PHONE_OFFSET;
  }
 
  getDialogPaddingLeftX(): number {
    if (this.keyboardPanelSession?.toolbarPaddingLeft > 0) {
      return this.keyboardPanelSession?.toolbarPaddingLeft + DIALOG_PHONE_ONE_HAND_OFFSET;
    }
    return this.getDialogOffsetPadding();
  }
 
  getDialogPaddingRightX(): number {
    if (this.keyboardPanelSession?.toolbarPaddingRight > 0) {
      return this.keyboardPanelSession?.toolbarPaddingRight + DIALOG_PHONE_ONE_HAND_OFFSET;
    }
    return this.getDialogOffsetPadding();
  }

  getDialogPadding(isSmart: boolean): number {
    if (this.isFloat) {
      if ((this.isMirrorLanguageType && isSmart) || (!isSmart && !this.isMirrorLanguageType)) {
        return this.keyboardSession?.currRect?.left.getVp() + DIALOG_PHONE_FLOAT_OFFSET;
      }
      let defaultDisplay = SCBKeyboardPanelManager.getInstance().getDefaultDisplaySync();
      if (defaultDisplay === null || defaultDisplay === undefined) {
        log.showError('defaultDisplay is null');
        return DIALOG_PHONE_FLOAT_OFFSET;
      }
      return px2vp(defaultDisplay?.width - this.keyboardSession?.currRect?.left.getPx() -
        this.keyboardSession?.currRect?.width.getPx()) + DIALOG_PHONE_FLOAT_OFFSET;
    }
    if (isSmart) {
      return this.getDialogPaddingRightX();
    }
    return this.getDialogPaddingLeftX();
  }

  buttonLongClick = async (isSmart: boolean) => {
    let defaultDisplay = SCBKeyboardPanelManager.getInstance().getDefaultDisplaySync();
    if (defaultDisplay === null || defaultDisplay === undefined) {
      log.showError('defaultDisplay is null');
      return;
    }
    if (isSmart) {
      let offset = componentUtils.getRectangleById('keyboardRightButton')?.screenOffset;
      this.dialogType = 'right';
      this.dialogOffset = [this.getDialogPadding(isSmart),
        px2vp(defaultDisplay?.height - offset?.y) + PANEL_DIALOG_OFFSET_Y];
    } else {
      let offset = componentUtils.getRectangleById('keyboardLeftButton')?.screenOffset;
      this.dialogType = 'left';
      this.dialogOffset = [this.getDialogPadding(isSmart),
        px2vp(defaultDisplay?.height - offset?.y) + PANEL_DIALOG_OFFSET_Y];
    }
    this.startHwVibration();
    SCBKeyboardPanelManager.getInstance().setPanelDialogVisibility(true);
    await inputMethodUtil.refreshInputMethodList();
    this.isShowDialog = true;
  }

  /**
   * 特效振动
   */
  private startHwVibration(): void {
    try {
      let effectId: string = 'haptic.long_press_light';
      vibrator.isSupportEffect(effectId).then((state: boolean) => {
        log.showInfo(`[SCBKeyboard] the query result is ${state}`);
        if (state) {
          this.startHwVibratePermission(effectId);
        }
      }, (error: BusinessError) => {
        log.showError(`Failed to query effect. Code: ${error.code}, message: ${error.message}`)
      })
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      log.showError(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`)
    }
  }

  private startHwVibratePermission(effectId: string) {
    try {
      vibrator.startVibration({
        type: 'preset',
        effectId: effectId,
        count: 1
      }, {
        usage: 'unknown'
      }).then(() => {
        log.showInfo(`[SCBKeyboard] Succeed in starting vibration`);
      }, (error: BusinessError) => {
        log.showError(`switchSmartType failed, message: ${error.message}, code: ${error.code}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`startCustomVibration An unexpected error occurred . Code: ${(err as BusinessError).code}, message: ${(err as BusinessError).message}`);
    }
  }

  dismissKeyboardDialog(): void {
    this.isShowDialog = false;
    SCBKeyboardPanelManager.getInstance().setPanelDialogVisibility(false);
  }
}