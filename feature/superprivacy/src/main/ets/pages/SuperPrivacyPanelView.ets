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
/* instrument ignore file */
// import superPrivacyManager from '@ohos.security.superPrivacyManager';
import { BusinessError } from '@kit.BasicServicesKit';
import locationManager from '@ohos.enterprise.locationManager';
import window from '@ohos.window';
import { LogDomain } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { Logger } from '@ohos/basicutils/src/main/ets/utils/Logger';
import { BaseViewController } from '@ohos/frameworkcommon/src/main/ets/manager/view/BaseViewController';
import { ViewCallback } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { PluginPosition, PluginWindowType } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginConstants';
import lottie, { AnimationDirection, AnimationItem } from '@ohos/lottie';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import PrivacyConstant from '../util/PrivacyConstant';
import { superPrivacyCapsuleControl } from '../util/SuperPrivacyCapsuleControl';
import SuperPrivacyUtils from '../util/SuperPrivacyUtils';
import MemoryEnvironmentVariant from '../util/MemoryEnvironmentVariant';
import { superPrivacyCacheManager } from '../util/SuperPrivacyCacheManager';

const TAG = 'SuperPrivacyPanelView';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const SUPER_PRIVACY_PADDLE_PANEL_VIEW_PADDING: Padding = {
  top: 16,
  bottom: 32,
  left: 24,
  right: 24
};
const TOGGLE_WIDTH: number = 37;
const TITLE_MAX_WIDTH: number =
  px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE)) -
  Number(SUPER_PRIVACY_PADDLE_PANEL_VIEW_PADDING.left) -
  Number(SUPER_PRIVACY_PADDLE_PANEL_VIEW_PADDING.right);
const TITLE_MIN_WIDTH: number = TITLE_MAX_WIDTH - TOGGLE_WIDTH - 1;

@Component
export struct SuperPrivacyPanelView {
  @StorageProp('mCurrentUserId') mCurrentUserId: number = 0;
  @State playing: boolean = false;
  @State baseViewController: BaseViewController | undefined = undefined;
  @State windowName: string = PrivacyConstant.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT;
  private closeCapsulePanelTimer: number | null = null;
  private animationPlayingTimer: number | null = null;
  private readToDisappear: boolean = false;
  private loopCompleteCallback: () => void = async () => {
    log.debug(TAG, `animation loopComplete`);
    if (this.closeCapsulePanelTimer !== null) {
      clearTimeout(this.closeCapsulePanelTimer);
      this.closeCapsulePanelTimer = null;
    }
    if (this.superPrivacyStatusBarEnable) {
      this.closeCapsulePanelTimer = setTimeout(() => {
        this.closeCapsulePanelTimer = null;
        this.requestCloseWindow();
      }, PrivacyConstant.OPEN_PANEL_ABOUT_TO_DISAPPEAR_DELAY);
    } else {
      this.closeCapsulePanelTimer = setTimeout(() => {
        this.closeCapsulePanelTimer = null;
        this.readToDisappear = true;
        superPrivacyCapsuleControl.requestStatusBar(false);
      }, PrivacyConstant.CLOSE_PANEL_ABOUT_TO_DISAPPEAR_DELAY);
    }
  }
  /*@State currentSuperPrivacyMode: superPrivacyManager.SuperPrivacyMode =
    superPrivacyManager.SuperPrivacyMode.ALWAYS_ON;*/
  @State currentSuperPrivacyMode: number = 0;
  @State animationDirection: AnimationDirection = 1;
  @State isMicrophoneUnderEdmControl: boolean = SuperPrivacyUtils.isMicrophoneUnderEdmControl();
  @State isCameraUnderEdmControl: boolean = SuperPrivacyUtils.isCameraUnderEdmControl();
  @State isLocationUnderEdmControl: locationManager.LocationPolicy = SuperPrivacyUtils.isLocationUnderEdmControl();
  @State superPrivacyStatusBarEnable: boolean = true;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private viewCallback: ViewCallback = {
    onShow: async (): Promise<void> => {
      this.initParams();
      await this.initRunCount();
    },
    onHide: (): void => {
      this.unInit();
    }
  };
  private superPrivacyCallback: Callback<number> = (mode: ESObject) => {
    log.debug(TAG, `superPrivacyManager superPrivacyMode changed ${mode}`);
    if (this.currentSuperPrivacyMode === mode) {
      return;
    }
    this.currentSuperPrivacyMode = mode;
    if (this.closeCapsulePanelTimer !== null) {
      clearTimeout(this.closeCapsulePanelTimer);
      this.closeCapsulePanelTimer = null;
    }
    /*if (mode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) {
      if (!this.superPrivacyStatusBarEnable) {
        this.animationDirection = 1;
        this.playing = true;
        this.superPrivacyStatusBarEnable = true;
        this.readToDisappear = false;
      }
    } else if (this.superPrivacyStatusBarEnable) {
      this.animationDirection = -1;
      this.playing = true;
      this.superPrivacyStatusBarEnable = false;
    }*/
    this.calculateAnimationPlayingTime();
  }

  initParams(): void {
    SuperPrivacyUtils.edmInit();
    this.playing = false;
    if (this.closeCapsulePanelTimer !== null) {
      clearTimeout(this.closeCapsulePanelTimer);
      this.closeCapsulePanelTimer = null;
    }
    if (this.animationPlayingTimer !== null) {
      clearTimeout(this.animationPlayingTimer);
      this.animationPlayingTimer = null;
    }
    this.readToDisappear = false;
    // this.currentSuperPrivacyMode=superPrivacyManager.SuperPrivacyMode.ALWAYS_ON;
    this.animationDirection = 1;
    this.isMicrophoneUnderEdmControl = SuperPrivacyUtils.isMicrophoneUnderEdmControl();
    this.isCameraUnderEdmControl = SuperPrivacyUtils.isCameraUnderEdmControl();
    this.isLocationUnderEdmControl = SuperPrivacyUtils.isLocationUnderEdmControl();
    this.superPrivacyStatusBarEnable = true;
  }

  async initRunCount() {
    let superPrivacyPaddlePanelAnimalEnable = MemoryEnvironmentVariant.getValue(
      `${PrivacyConstant.SUPER_PRIVACY_PADDLE_PANEL_ANIMATION_ENABLE}${this.mCurrentUserId}`, '');
    MemoryEnvironmentVariant.setValue(
      `${PrivacyConstant.SUPER_PRIVACY_PADDLE_PANEL_ANIMATION_ENABLE}${this.mCurrentUserId}`, 'false');
    if (superPrivacyPaddlePanelAnimalEnable === 'true') {
      this.animationDirection = 1;
      this.playing = true;
      this.superPrivacyStatusBarEnable = true;
    } else {
      // 用户手动点击触发的状态栏二级弹窗默认没有动效
      this.animationDirection = 1;
      this.playing = false;
      this.superPrivacyStatusBarEnable = true;
    }
    await this.initSuperPrivacyMode();
  }

  async initSuperPrivacyMode(): Promise<void> {
    try {
      this.currentSuperPrivacyMode = await superPrivacyCacheManager.getSuperPrivacyMode();
      /*if (this.currentSuperPrivacyMode !== superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) {
        // 在超级隐私状态栏二级弹窗不显示场景下，关闭开关，状态栏会重新拉起二级弹窗，并且播放完整消失动效
        this.animationDirection = -1;
        this.playing = true;
        this.superPrivacyStatusBarEnable = false;
      }*/
      superPrivacyCacheManager.on('superPrivacyModeChange', this.superPrivacyCallback);
      this.calculateAnimationPlayingTime();
    } catch (err) {
      log.error(TAG, ` listen superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
  }

  calculateAnimationPlayingTime(): void {
    if (this.animationPlayingTimer !== null) {
      clearTimeout(this.animationPlayingTimer);
      this.animationPlayingTimer = null;
    }
    if (!this.playing) {
      return;
    }
    if (this.isMicrophoneUnderEdmControl && this.isCameraUnderEdmControl &&
      this.isLocationUnderEdmControl !== locationManager.LocationPolicy.DEFAULT_LOCATION_SERVICE) {
      this.loopCompleteCallback();
    } else if (this.animationDirection === 1) {
      this.animationPlayingTimer = setTimeout(() => {
        this.animationPlayingTimer = null;
        this.loopCompleteCallback();
      }, PrivacyConstant.OPEN_ANIMATION_PLAYING_DURATION);
    } else if (this.animationDirection === -1) {
      this.animationPlayingTimer = setTimeout(() => {
        this.animationPlayingTimer = null;
        this.loopCompleteCallback();
      }, PrivacyConstant.CLOSE_ANIMATION_PLAYING_DURATION);
    } else {
      return;
    }
  }

  requestCloseWindow() {
    log.info(TAG, `requestCloseWindow`);
    windowMgr.updateDestroyWindowFlag(this.windowName, true);
    windowMgr.hideWindowWithAnim(this.windowName);
  }

  aboutToAppear(): void {
    log.debug(TAG, `aboutToAppear`);
    this.baseViewController?.registerCallback(this.viewCallback);
  }

  unInit(): void {
    try {
      superPrivacyCacheManager.off('superPrivacyModeChange', this.superPrivacyCallback);
    } catch (err) {
      log.error(TAG, `unlisten superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
    if (this.closeCapsulePanelTimer !== null) {
      clearTimeout(this.closeCapsulePanelTimer);
      this.closeCapsulePanelTimer = null;
    }
    if (this.animationPlayingTimer !== null) {
      clearTimeout(this.animationPlayingTimer);
      this.animationPlayingTimer = null;
    }
    // 退场动画播放到一半用户点击空白处退出了二级弹窗
    if (!this.superPrivacyStatusBarEnable && !this.readToDisappear) {
      superPrivacyCapsuleControl.requestStatusBar(false);
    }
    this.playing = false;
  }
  aboutToDisappear(): void {
    this.unInit();
    this.baseViewController?.unRegisterCallback(this.viewCallback);
    log.debug(TAG, `aboutToDisappear`);
  }

  getMainTitle(): ResourceStr {
    if (this.animationDirection === 1) {
      return $r('app.string.SuperPrivacyPaddlePanelAppearTitle');
    } else {
      return $r('app.string.SuperPrivacyPaddlePanelDisappearTitle');
    }
  }

  getMainText(): ResourceStr {
    if (this.isMicrophoneUnderEdmControl || this.isCameraUnderEdmControl ||
      this.isLocationUnderEdmControl !== locationManager.LocationPolicy.DEFAULT_LOCATION_SERVICE) {
      return $r(`app.string.SuperPrivacyPanelUnderEdmControl${(this.isCameraUnderEdmControl ? (1 << 2) : 0) +
        (this.isMicrophoneUnderEdmControl ? (1 << 1) : 0) +
        (this.isLocationUnderEdmControl !== locationManager.LocationPolicy.DEFAULT_LOCATION_SERVICE ? (1 << 0) : 0)}`);
    } else if (this.animationDirection === 1) {
      if (SuperPrivacyUtils.isPaddleDevice()) {
        return $r('app.string.SuperPrivacyPaddlePanelContent');
      } else {
        return $r('app.string.SuperPrivacySoftPanelContent');
      }
    } else {
      if (SuperPrivacyUtils.isPaddleDevice()) {
        return $r('app.string.SuperPrivacyPaddlePanelOffContent');
      } else {
        return $r('app.string.SuperPrivacySoftPanelOffContent');
      }
    }
  }

  @Builder
  private MainText() {
    Text(this.getMainText())
      .textAlign(TextAlign.Center)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Regular)
      .fontColor(this.colorModeViewData.wifiOnTextColor)
      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
  }

  build() {
    Column() {
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          Text(this.getMainTitle())
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Bold)
            .maxFontSize($r('sys.float.Title_S'))
            .minFontSize('16fp')
            .fontColor(this.colorModeViewData.wifiOnTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              left: 0,
              right: 0
            })
            .width((SuperPrivacyUtils.isSupportSoftProtection() && !SuperPrivacyUtils.isPaddleDevice()) ?
              TITLE_MIN_WIDTH : TITLE_MAX_WIDTH)
          Blank()
            .visibility((SuperPrivacyUtils.isSupportSoftProtection() && !SuperPrivacyUtils.isPaddleDevice()) ?
            Visibility.Visible : Visibility.None)
          Toggle({
            type: ToggleType.Switch,
            // isOn: this.currentSuperPrivacyMode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON
            isOn: false
          })
            .margin({
              left: 0,
              right: 0
            })
            .hoverEffect(HoverEffect.None)
            .visibility((SuperPrivacyUtils.isSupportSoftProtection() && !SuperPrivacyUtils.isPaddleDevice()) ?
            Visibility.Visible : Visibility.None)
            .onChange((isOn: boolean) => {
              try {
                /*if ((this.currentSuperPrivacyMode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) === isOn) {
                  return;
                }
                superPrivacyCacheManager.setSuperPrivacyMode(isOn ? superPrivacyManager.SuperPrivacyMode.ALWAYS_ON :
                superPrivacyManager.SuperPrivacyMode.OFF, superPrivacyManager.Source.OTHER);*/
              } catch (err) {
                log.error(TAG, `setSuperPrivacyMode superPrivacyModeChange error code is ${(err as BusinessError).code}`);
              }
            })
        }
        .width(PrivacyConstant.FULL_WIDTH)
        .height(56 + PrivacyConstant.PANEL_UNIT)

        Blank().height(24 + PrivacyConstant.PANEL_UNIT)
        Stack() {
          Row({ space: 32 + PrivacyConstant.PANEL_UNIT }) {
            if (this.isCameraUnderEdmControl || !this.playing) {
              Image($r('app.media.ic_super_privacy_discam'))
                .width(48 + PrivacyConstant.PANEL_UNIT)
                .height(48 + PrivacyConstant.PANEL_UNIT)
                .draggable(false)
            } else {
              MainLottie({
                animationName: PrivacyConstant.ANIMATION_CAMERA_NAME,
                animationDirection: this.animationDirection,
                playing: this.playing,
              })
            }
            if (this.isMicrophoneUnderEdmControl || !this.playing) {
              Image($r('app.media.ic_super_privacy_dismic'))
                .width(48 + PrivacyConstant.PANEL_UNIT)
                .height(48 + PrivacyConstant.PANEL_UNIT)
                .draggable(false)
            } else {
              MainLottie({
                animationName: PrivacyConstant.ANIMATION_MICROPHONE_NAME,
                animationDirection: this.animationDirection,
                playing: this.playing,
              })
            }
            if (this.isLocationUnderEdmControl === locationManager.LocationPolicy.FORCE_OPEN_LOCATION_SERVICE) {
              Image($r('app.media.ic_super_privacy_loc'))
                .width(48 + PrivacyConstant.PANEL_UNIT)
                .height(48 + PrivacyConstant.PANEL_UNIT)
                .draggable(false)
            } else if (this.isLocationUnderEdmControl === locationManager.LocationPolicy.DISALLOW_LOCATION_SERVICE ||
              !this.playing) {
              Image($r('app.media.ic_super_privacy_disloc'))
                .width(48 + PrivacyConstant.PANEL_UNIT)
                .height(48 + PrivacyConstant.PANEL_UNIT)
                .draggable(false)
            } else if (this.isLocationUnderEdmControl === locationManager.LocationPolicy.DEFAULT_LOCATION_SERVICE) {
              MainLottie({
                animationName: PrivacyConstant.ANIMATION_LOCATION_NAME,
                animationDirection: this.animationDirection,
                playing: this.playing,
              })
            }
          }
        }

        Blank().height(16 + PrivacyConstant.PANEL_UNIT)
        this.MainText()
      }
      .padding({
        bottom: 0 + PrivacyConstant.PANEL_UNIT,
        left: SUPER_PRIVACY_PADDLE_PANEL_VIEW_PADDING.left + PrivacyConstant.PANEL_UNIT,
        right: SUPER_PRIVACY_PADDLE_PANEL_VIEW_PADDING.right + PrivacyConstant.PANEL_UNIT,
      })
      .justifyContent(FlexAlign.Center)
      .onAreaChange((oldArea: Area, newArea: Area) => {
        log.debug(TAG, `oldArea: ${Number(oldArea.height)}, newArea：${Number(newArea.height)}`);
        // 更新弹窗高度
        if (newArea.height !== 0) {
          let position = windowMgr.getWindowPosition(this.windowName);
          let updateRect: window.Rect = {
            top: position.top,
            left: position.left,
            width: position.width,
            height: vp2px(Number(newArea.height) + Number(SUPER_PRIVACY_PADDLE_PANEL_VIEW_PADDING.bottom))
          };
          if (Math.abs(position.height - updateRect.height) >= 1) {
            EvtBus.post(WindowPositionChangeEvent, {
              windowName: this.windowName,
              position: PluginPosition.POSITION_RIGHT, area: updateRect
            });
          }
        }
      })
    }
    .width('100%')
    .height('100%')
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
  }
}

@Component
struct MainLottie {
  private settingsAnimation: RenderingContextSettings = new RenderingContextSettings(true);
  private contextOpenAnimation: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settingsAnimation);
  private contextCloseAnimation: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settingsAnimation);
  loopCompleteCallback: () => void = async () => {
  };
  @Link @Watch('changeAnimationDirection') animationDirection: AnimationDirection;
  @Link @Watch('changePlaying') playing: boolean;
  @State animationName: string = '';
  private lottieOpenAnimation: AnimationItem | undefined;
  private lottieCloseAnimation: AnimationItem | undefined;
  private isCanvasReady: boolean = false;

  private getAnimationPath(animationDirection: number): string {
    if (this.animationName === PrivacyConstant.ANIMATION_CAMERA_NAME) {
      return animationDirection === 1 ?
      PrivacyConstant.OPEN_CAMERA_PANEL_ANIMATION_NAME :
      PrivacyConstant.CLOSE_CAMERA_PANEL_ANIMATION_NAME;
    } else if (this.animationName === PrivacyConstant.ANIMATION_LOCATION_NAME) {
      return animationDirection === 1 ?
      PrivacyConstant.OPEN_LOCATION_PANEL_ANIMATION_NAME :
      PrivacyConstant.CLOSE_LOCATION_PANEL_ANIMATION_NAME;
    } else if (this.animationName === PrivacyConstant.ANIMATION_MICROPHONE_NAME) {
      return animationDirection === 1 ?
      PrivacyConstant.OPEN_MICROPHONE_PANEL_ANIMATION_NAME :
      PrivacyConstant.CLOSE_MICROPHONE_PANEL_ANIMATION_NAME;
    }
    return '';
  }

  private changePlaying(): void {
    if (!this.isCanvasReady) {
      return;
    }
    log.debug(TAG, `changePlaying ${this.playing}`);
    if (this.playing) {
      lottie.play(`${this.animationName}${this.animationDirection}`);
    } else {
      lottie.pause(`${this.animationName}${this.animationDirection}`);
    }
  }

  private changeAnimationDirection(): void {
    if (!this.isCanvasReady) {
      return;
    }
    lottie.stop(`${this.animationName}${-1}`);
    lottie.stop(`${this.animationName}${1}`);
    if (this.playing) {
      lottie.play(`${this.animationName}${this.animationDirection}`);
    }
  }

  loadAnimation() {
    if (!this.lottieCloseAnimation) {
      let path = this.getAnimationPath(1);
      this.lottieOpenAnimation = lottie.loadAnimation({
        container: this.contextOpenAnimation,
        renderer: 'canvas',
        contentMode: 'Fill',
        loop: false,
        autoplay: false,
        name: `${this.animationName}${1}`,
        path: path,
        autoSkip: false
      });
      this.lottieOpenAnimation.addEventListener('complete', this.loopCompleteCallback);
    }
    if (!this.lottieCloseAnimation) {
      let path = this.getAnimationPath(-1);
      this.lottieCloseAnimation = lottie.loadAnimation({
        container: this.contextCloseAnimation,
        renderer: 'canvas',
        contentMode: 'Fill',
        loop: false,
        autoplay: false,
        name: `${this.animationName}${-1}`,
        path: path,
        autoSkip: false
      });
      this.lottieCloseAnimation.addEventListener('complete', this.loopCompleteCallback);
    }
  }

  unloadAnimation() {
    lottie.stop(`${this.animationName}${-1}`);
    lottie.stop(`${this.animationName}${1}`);
    this.lottieOpenAnimation?.removeEventListener('complete');
    this.lottieCloseAnimation?.removeEventListener('complete');
    this.lottieOpenAnimation?.destroy();
    this.lottieCloseAnimation?.destroy();
    this.lottieOpenAnimation = undefined;
    this.lottieCloseAnimation = undefined;
  }

  build() {
    Stack() {
      Canvas(this.contextOpenAnimation)
        .width(48 + PrivacyConstant.PANEL_UNIT)
        .height(48 + PrivacyConstant.PANEL_UNIT)
        .renderGroup(true)
        .onReady(() => {
          this.isCanvasReady = true;
          this.loadAnimation();
          if (this.playing) {
            lottie.play(`${this.animationName}${this.animationDirection}`);
          }
        })
        .onDisAppear(() => {
          this.isCanvasReady = false;
          this.unloadAnimation();
        })
        .visibility(this.animationDirection === 1 ? Visibility.Visible : Visibility.Hidden)
      Canvas(this.contextCloseAnimation)
        .width(48 + PrivacyConstant.PANEL_UNIT)
        .height(48 + PrivacyConstant.PANEL_UNIT)
        .renderGroup(true)
        .visibility(this.animationDirection === -1 ? Visibility.Visible : Visibility.Hidden)
    }
    .width(48 + PrivacyConstant.PANEL_UNIT)
    .height(48 + PrivacyConstant.PANEL_UNIT)
  }
}