/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { SCBKeyboardManager, SCBScreenProperty, SCBSceneSessionManager, sSCBOobeManager,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBRotateChangeReason} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { StyleConstants } from '@ohos/launchercommon';
import { curves } from '@kit.ArkUI';
import { LogHelper, LogDomain, CheckEmptyUtils, TraceUtil, DomainName} from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, SettingsUtil, ViewArea, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import settings from '@ohos.settings';
import { AnimationConstants } from '@ohos/commonconstants/Index';
import { FoldSceneKeyboardStateChangeMgr } from '../../common/manager/FoldSceneKeyboardStateChangeMgr';
import { SCBInputMethod } from '../scenemanager/SCBInputMethod';
import LockScreenAnimationController from '../screenlock/common/LockScreenAnimationController';
import { PowerStatus } from '@ohos/commonconstants';
import { FoldKeyboardConstant } from '../../common/constants/FoldKeyboardConstant';
import { DesktopSwitchController } from '../virtualmachine/DesktopSwitchController';
import { CentralPersonalizationViewModel, CentralPersonalizationData } from './ViewModel/CentralPersonalizationViewModel';

const TAG = 'SCBCentralLogoMask';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const LOGO_LIGHT_ICON_PATH: string = 'common/pics/ic_light_logo.svg';
const LOGO_ICON_WIDTH: number = 74;
const LOGO_ICON_HEIGHT: number = 14;
const DEFAULT_TEXT_SIZE: number = 16;
const VIRTUAL_KEYBOARD_BG: string = '#ff343434';
const PHYSICAL_KEYBOARD_BG: string = '#FF000000';
const DEFAULT_ICON_COLOR: string = '#80FFFFFF';
const TRANSPARENCY_COLOR = '#00000000';
const CENTRAL_LOGO_SETTING: string = 'settings_central_logo_icon_color';
const CENTRAL_LOGO_BACKGROUND_SETTING: string = 'settings_central_logo_background_color';
const HOLIDAY_EFFECTS_ANIMATION_DURATION: number = 4000;

enum LogoMaskState {
  NONE,
  SHOW,
  SHOWING,
  HIDE,
  HIDING
}

@Component
export struct SCBCentralLogoMask {
  @Link screenProp: SCBScreenProperty;
  private centralLogoMaskController: BaseViewController =
    new BaseViewController(ViewType.CENTRAL_LOGO_MASK, this.screenProp.screenId);
  persistentId: number = 0;
  private logoMaskHeight: number = 0;
  private centralPersonalizationViewModel: CentralPersonalizationViewModel = new CentralPersonalizationViewModel();
  @StorageLink('dockHeight') dockHeight: number = 0;
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;
  @State bgColor: string = VIRTUAL_KEYBOARD_BG;
  @State iconFillColor: string = '';
  @State personalizationData: CentralPersonalizationData = this.centralPersonalizationViewModel.personalizationData;
  @State textAlpha: Array<number> = [];
  @State textScale: Array<number> = [];
  @State textBlur: Array<number> = [];
  @State holidayEffectsImageState: AnimationStatus = AnimationStatus.Initial;
  private state: LogoMaskState = LogoMaskState.NONE;
  private keyboardStateChangeMgr: FoldSceneKeyboardStateChangeMgr = FoldSceneKeyboardStateChangeMgr.getInstance();
  private bgColorVirtualKeyboard: string = '';
  private iconColorVirtualKeyboard: string = '';
  private dockOpacity: number = 1;
  private translateY: number = 0;
  private containerBgColor: string = TRANSPARENCY_COLOR;
  private isRotating: boolean = false;

  private onPowerStatusChange(): void {}

  aboutToAppear(): void {
    viewMgrPolicy.registerViewController(ViewType.CENTRAL_LOGO_MASK, this.centralLogoMaskController);
    this.centralLogoMaskController.updateId(this.persistentId);
    // logo只在竖屏磁吸态出现, 横屏启动也按照最长边计算logo高度
    this.logoMaskHeight = Math.floor(this.getUIContext()?.px2vp(Math.max(this.screenProp.height,
      this.screenProp.width) / 2));
    this.updateDockArea(this.screenProp);
    this.setOpacity(0);
    this.setTranslateY(this.logoMaskHeight);
    this.centralLogoMaskController.hide();
    this.state = LogoMaskState.HIDE;
    this.keyboardStateChangeMgr.init();
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.screenRotateChange,
      this.screenProp.screenId);
    this.registerColorSettingListener();
    this.centralPersonalizationViewModel.doInit(this.doTextAnimation);
  }

  private isVirtualKeyboardState(): boolean {
    return false;
  }

  private registerColorSettingListener() {
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), CENTRAL_LOGO_SETTING, settings.domainName.USER_SECURITY,
        () => {
          this.iconColorVirtualKeyboard = SettingsUtil.getSecureValue(CENTRAL_LOGO_SETTING, '');
          if (this.centralLogoMaskController.isShowing() && this.iconFillColor !== this.iconColorVirtualKeyboard &&
            this.isVirtualKeyboardState()) {
            this.iconFillColor = this.iconColorVirtualKeyboard;
          }
        })
      settings.registerKeyObserver(GlobalContext.getContext(), CENTRAL_LOGO_BACKGROUND_SETTING,
        settings.domainName.USER_SECURITY, () => {
          this.bgColorVirtualKeyboard = SettingsUtil.getSecureValue(CENTRAL_LOGO_BACKGROUND_SETTING,
            VIRTUAL_KEYBOARD_BG);
          if (this.centralLogoMaskController.isShowing() && this.bgColor !== this.bgColorVirtualKeyboard &&
            this.isVirtualKeyboardState()) {
            this.bgColor = this.bgColorVirtualKeyboard;
          }
        })
    } catch (err) {
      log.error('registerColorSettingCallback', err)
    }
  }

  private unregisterColorSettingListener() {
    try {
      settings.unregisterKeyObserver(GlobalContext.getContext(), CENTRAL_LOGO_SETTING,
        settings.domainName.USER_SECURITY);
      settings.unregisterKeyObserver(GlobalContext.getContext(), CENTRAL_LOGO_BACKGROUND_SETTING,
        settings.domainName.USER_SECURITY);
    } catch (e) {
      log.showWarn('unregisterColorSettingCallback fail');
    }
  }

  private onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.isNoNeedRotateAnimate(screenProperty)) {
      return;
    }
    if (this.isNeedUpdateDockArea(screenProperty)) {
        this.updateDockArea(screenProperty);
    }
  }

  private setOpacity(opacity: number) {
    log.showInfo(`setOpacity from:${this.dockOpacity} to:${opacity}`);
    if (this.dockOpacity === opacity) {
      return;
    }
    this.dockOpacity = opacity;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setOpacity(opacity);
  }

  private setBackgroundColor(color: string) {
    log.showInfo(`setBackgroundColor from:${this.containerBgColor} to:${color}`);
    if (this.containerBgColor === color) {
      return;
    }
    this.containerBgColor = color;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setBackgroundColor(color);
  }

  private setTranslateY(dy: number) {
    log.showInfo(`setTranslateY from:${this.translateY} to:${dy}`);
    if (this.translateY === dy) {
      return;
    }
    this.translateY = dy;
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setTranslate(0, dy, 0);
  }

  private updateDockArea(screenProperty: SCBScreenProperty): void {
    const logoHeightPx: number = Math.floor(this.getUIContext()?.vp2px(this.logoMaskHeight));
    log.showInfo(`logoHeightPx: ${logoHeightPx}`);
    const newVpRect: ViewArea = {
      left: 0,
      top: this.getUIContext()?.px2vp(screenProperty.height) - this.logoMaskHeight,
      width: this.getUIContext()?.px2vp(screenProperty.width),
      height: this.logoMaskHeight
    };
    const newVpRectPx: ViewArea = {
      left: 0,
      top: screenProperty.height - logoHeightPx,
      width: screenProperty.width,
      height: logoHeightPx
    };
    this.centralLogoMaskController.updateArea(newVpRect);
    this.centralLogoMaskController.updateRectInPx(newVpRectPx);
  }

  aboutToDisappear(): void {
    viewMgrPolicy.unregisterViewController(ViewType.CENTRAL_LOGO_MASK);
    this.keyboardStateChangeMgr.destroy();
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.screenRotateChange,
      this.screenProp.screenId);
    this.unregisterColorSettingListener();
    this.centralPersonalizationViewModel.deInit();
  }

  /**
   * 虚拟机横展-> 竖屏跟随虚拟键盘一帧切, 不做动效
   * @returns
   */
  private isNoNeedRotateAnimate(screenProperty: SCBScreenProperty): boolean {
    return DesktopSwitchController.getInstance().isVmDesktop() && screenProperty.width < screenProperty.height;
  }

  private isNeedUpdateDockArea(screenProperty: SCBScreenProperty): boolean {
    if (screenProperty === undefined || screenProperty === null) {
      log.showError(`isNeedUpdateDockArea, screenProperty is null`);
      return false;
    }
    const isKeyboardShowing = SCBKeyboardManager.getInstance().getSystemKeyboardSession()?.isKeyboardShowing();
    const isVirtualKeyboardInFloat = SCBKeyboardManager.getInstance().getSystemKeyboardSession()?.isFloatGravity();
    log.showInfo(`[SCBKeyboard]isNeedUpdateDockArea, state: ${this.state}, isKeyboardShowing: ${isKeyboardShowing},
      screenProperty.width: ${screenProperty.width}, screenProperty.height: ${screenProperty.height},
      isVirtualKeyboardInFloat: ${isVirtualKeyboardInFloat}`);
    // 当Logo显示、虚拟键盘显示、虚拟键盘是贴底态、竖屏切横屏的情况，logo不需要做旋转动效
    if (this.state === LogoMaskState.SHOW && isKeyboardShowing && !isVirtualKeyboardInFloat &&
      (screenProperty.width > screenProperty.height)) {
        return false;
    }
    return true;
  }

  private screenRotateChange = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void => {
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      if (this.isNoNeedRotateAnimate(screenProperty) && this.isNeedUpdateDockArea(screenProperty)) {
        this.updateDockArea(screenProperty);
      }
      // 竖屏折叠虚拟键盘->横展旋转时将透明置为0, 优化旋转动效结束时logo动效
      if (this.state === LogoMaskState.HIDING && this.bgColor !== PHYSICAL_KEYBOARD_BG &&
        screenProperty.width > screenProperty.height) {
        this.setOpacity(0);
      }
      this.isRotating = true;
    } else if (reason === SCBRotateChangeReason.ROTATE_END) {
      this.isRotating = false;
    }
  }

  private leaveKeyboardAnimateCb = () => {
    this.state = LogoMaskState.HIDING;
    this.setTranslateY(this.logoMaskHeight)
  }

  private leaveKeyboardAnimateFinishCb = () => {
    log.showInfo(`leaveKeyboardAnimateFinishCb state: ${this.state}`);
    if (this.state === LogoMaskState.HIDING) {
      this.setOpacity(0);
      this.setBackgroundColor(TRANSPARENCY_COLOR);
      this.centralLogoMaskController.hide();
      this.state = LogoMaskState.HIDE;
    }
  }

  private doTextAnimation = (isReplaceAnimation: boolean): void => {
    log.showInfo(`doAnimation, isReplaceAnimation is ${isReplaceAnimation}-${this.personalizationData.customerText.length}`);
    TraceUtil.startTrace(DomainName.HOME, 'doTextAnimation');
    for (let i = 0; i < this.personalizationData.customerText.length; i++) {
      this.textAlpha[i] = 0;
      this.textScale[i] = 0.5;
      this.textBlur[i] = 10;
    }
    for (let i = 0; i < this.personalizationData.customerText.length; i++) {
      animateTo({
        duration: 400,
        curve: Curve.Sharp,
        delay: i * 30
      }, () => {
        this.textAlpha[i] = 1;
      });
      animateTo({
        duration: 500,
        curve: Curve.Sharp,
        delay: i * 30
      }, () => {
        this.textBlur[i] = 0;
      });
      animateTo({
        duration: 600,
        curve: curves.cubicBezierCurve(0.2, 0.0, 0.2, 1),
        delay: i * 30,
        onFinish: () => {
          if (i === this.personalizationData.customerText.length - 1) {
            TraceUtil.endTrace(DomainName.HOME, 'doTextAnimation');
          }
        }
      }, () => {
        this.textScale[i] = 1;
      })
    }
    if (isReplaceAnimation) {
      // 替换动效
      this.personalizationData.oldCustomerTextOpacity = 1;
      animateToImmediately({
        duration: 300,
        curve: Curve.Sharp,
        delay: 100,
        onFinish: () => {
          this.personalizationData.doReplaceAnimate = false;
          this.personalizationData.oldCustomerText = [];
        }
      }, () => {
        this.personalizationData.oldCustomerTextOpacity = 0;
      });
    }
  }

  private getTextSize(): number {
    return DEFAULT_TEXT_SIZE;
  }

  private isShowHolidayEffects(): boolean {
    return this.personalizationData.enableHolidayEffects && this.personalizationData.isPlayHolidayEffects &&
      !this.personalizationData.isPreviewInHolidayEffectsState && this.personalizationData.isInVirtualKeyboard;
  }

  @Builder
  customerTextBuilder() {
    List() {
      ForEach(this.personalizationData.customerText, (item: string, index: number) => {
        ListItem() {
          Text(item)
            .fontSize(this.getTextSize())
            .minFontScale(StyleConstants.DEFAULT_1)
            .maxFontScale(StyleConstants.DEFAULT_1)
            .fontColor(this.iconFillColor === '' ? DEFAULT_ICON_COLOR : this.iconFillColor)
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Normal, { enableVariableFontWeight: true })
            .textAlign(TextAlign.Center)
        }
        .opacity(this.textAlpha[index])
        .scale({
          x: this.textScale[index],
          y: this.textScale[index],
          centerX: '50%',
          centerY: '50%'
        })
        .blur(this.textBlur[index])
      }, (item: string, index: number) => item + index)
    }
    .direction(Direction.Ltr)
    .transition(
      TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Sharp }),
        TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Sharp }),
      ))
    .height('100%')
    .listDirection(Axis.Horizontal)
    .alignListItem(ListItemAlign.Start)
  }

  @Builder
  customerOldTextBuilder() {
    List() {
      ForEach(this.personalizationData.oldCustomerText, (item: string, index: number) => {
        ListItem() {
          Text(item)
            .fontSize(this.getTextSize())
            .minFontScale(StyleConstants.DEFAULT_1)
            .maxFontScale(StyleConstants.DEFAULT_1)
            .fontColor(this.iconFillColor === '' ? DEFAULT_ICON_COLOR : this.iconFillColor)
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Normal, { enableVariableFontWeight: true })
            .textAlign(TextAlign.Center)
        }
      }, (item: string, index: number) => item + index)
    }
    .direction(Direction.Ltr)
    .opacity(this.personalizationData.oldCustomerTextOpacity)
    .height('100%')
    .listDirection(Axis.Horizontal)
    .alignListItem(ListItemAlign.Start)
  }

  @Builder
  defaultLogoBuilder() {
    Image(LOGO_LIGHT_ICON_PATH)
      .objectFit(ImageFit.Contain)
      .width(LOGO_ICON_WIDTH)
      .height(LOGO_ICON_HEIGHT)
      .fillColor(this.iconFillColor === '' ? DEFAULT_ICON_COLOR : this.iconFillColor)
      .draggable(false)
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({ duration: 300, delay: 150, curve: Curve.Sharp }),
          TransitionEffect.OPACITY.animation({ duration: 150, curve: Curve.Sharp }),
        ))
  }

  build() {
    Row() {
      if (this.isShowHolidayEffects()) {
        ImageAnimator()
          .images(this.centralPersonalizationViewModel.getImages())
          .draggable(false)
          .state(this.holidayEffectsImageState)
          .monitorInvisibleArea(true)
          .width('100%')
          .height('100%')
          .duration(HOLIDAY_EFFECTS_ANIMATION_DURATION)
          .onAppear(() => {
            if (this.holidayEffectsImageState === AnimationStatus.Initial ||
              this.holidayEffectsImageState === AnimationStatus.Stopped) {
              this.holidayEffectsImageState = AnimationStatus.Running;
            }
          })
          .onDisAppear(() => {
            this.holidayEffectsImageState = AnimationStatus.Initial;
          })
          .onFinish(() => {
            this.holidayEffectsImageState = AnimationStatus.Stopped;
          })
          .transition(
            TransitionEffect.asymmetric(
              TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Sharp }),
              TransitionEffect.OPACITY.animation({ duration: 150, curve: Curve.Sharp }),
            ))
      } else {
        Stack() {
          if (this.personalizationData.customerText.length !== 0) {
            this.customerTextBuilder()
          }
          if (this.personalizationData.doReplaceAnimate) {
            this.customerOldTextBuilder()
          }
          if (this.personalizationData.customerText.length === 0) {
            this.defaultLogoBuilder()
          }
        }
        .width('100%')
        .alignContent(Alignment.Top)
        .margin({ top: StyleConstants.DEFAULT_7 })
      }
    }
    .id('SCBCentralLogoMask')
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(0)
    .backgroundColor(this.bgColor)
    .backdropBlur((this.bgColor === PHYSICAL_KEYBOARD_BG || this.isShowHolidayEffects()) ? 0 : 300)
  }
}