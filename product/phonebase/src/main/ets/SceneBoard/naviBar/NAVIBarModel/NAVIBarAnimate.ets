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
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { GlobalContext, HiSysEventUtil, } from '@ohos/frameworkwrapper';
import { DragEventType, SCBGestureNavBarViewModel } from '../../gesturenavigation/SCBGestureNavBarViewModel';
import { NAVIBarData } from './NAVIBarData';
import {
  NaviBarStatusFlag,
  NAVIBarViewData,
  BrightnessSceneType,
  WeakNotifyState
} from './NAVIBarViewData';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import { curves } from '@kit.ArkUI';
import { SystemSceneConstants } from '../../gesturenavigation/SystemSceneConstants';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { vibratorMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { animateExStart } from '@ohos/windowscene/Index';
import { NAVIBarClickBackgroundData } from './NAVIBarClickBackgroundData';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
import { NavbarWindowManager } from '../../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
import measure from '@ohos.measure';
import { ResUtils } from '@ohos/windowscene';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { NaviBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/NaviBarVisualEffectManager';

const TAG: string = 'naviBarAnimate';
const TEXT_FONT_SIZE: string = `${ArkUIAdapter.vp2px(SCBNaviBarConstants.DRAG_TO_VOICE_FONT_SIZE)}px`;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class NAVIBarAnimate {
  private naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
  private naviBarClickBackgroundData: NAVIBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
  private naviBarData: NAVIBarData = NAVIBarData.getInstance();
  private navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
  private static mInstance: NAVIBarAnimate;

  static getInstance(): NAVIBarAnimate {
    if (NAVIBarAnimate.mInstance == null) {
      NAVIBarAnimate.mInstance = new NAVIBarAnimate();
    }
    return NAVIBarAnimate.mInstance;
  }

  public checkInitAnimParam(event?: GestureEvent): void {
    if (!this.naviBarViewData.isShowingNaviBar || !event) {
      return;
    }
    this.resetAnimParam(event);
  }

  public resetAnimParam(event: GestureEvent): void {
    this.resetNaviBarParam();
    this.naviBarData.startOffsetY = event.offsetY;
    this.naviBarData.startOffsetX = event.offsetX;
    log.showInfo(`[${TAG}] resetAnimParam`);
  }

  public resetNaviBarParam() {
    // 避免刚上滑触发一次透明度动效
    this.naviBarData.isOpacityHideAnimStarted = false;
    this.naviBarData.isOpacityShowAnimStarted = true;
    this.naviBarViewData.barTranslateParam.barTranslateY = 0;
    this.naviBarViewData.barTranslateParam.barTranslateX = 0;
    this.changeToDefaultNaviBar();
    this.naviBarViewData.naviBarBottomMargin = gestureNavBarSettings.getNaviBarMarginBottom();
  }

  public processBackEventAnimate(): void {
    log.showInfo('enter processBackEvent');
    this.naviBarClickBackgroundData.naviBarBackgroundOpacity = 1;
    animateTo({
      curve: curves.springMotion(0.468, 1),
    }, () => {
      this.naviBarClickBackgroundData.naviBarBackgroundOpacity = 0;
    });
  }

  /**
   * 获取过渡动效
   * @param isSystemBarEnable 是否允许导航条唤醒
   * @param hotAreaHeight 热区高度
   * @returns
   */
  public getTransitionEffect(isSystemBarEnable: boolean): TransitionEffect {
    // 应用主动隐藏场景禁用导航条转场动效
    if (this.naviBarData.isAppHide) {
      this.naviBarData.isAppHide = false;
      return TransitionEffect.IDENTITY;
    }
    if (isSystemBarEnable) {
      return TransitionEffect.OPACITY.animation({ curve: Curve.Linear, duration: 200 });
    }
    return this.NAVIBarTransitionEffect();
  }

  private NAVIBarTransitionEffect(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({ curve: curves.springMotion(0.4, 1) })
      .combine(TransitionEffect.translate({ y: 10 })
        .animation({ curve: curves.springMotion(0.4, 1) }));
  }

  public onActionEndAndCancelAnimal() {
    animateTo({
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      duration: 200
    }, () => {
      this.naviBarViewData.barOpacityParam.barOpacity = 1;
    })
  }

  /**
   * 重置导航条参数
   */
  public playBarResetAnim(): void {
    this.naviBarData.isInResetNaviBar = true;
    animateTo({
      curve: curves.springMotion(0.3, 1),
      onFinish: () => {
        this.naviBarData.isInResetNaviBar = false;
      }
    }, () => {
      this.naviBarViewData.barTranslateParam.barTranslateY = 0;
      this.naviBarViewData.barTranslateParam.barTranslateX = 0;
      this.naviBarViewData.barOpacityParam.barOpacity = SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_OPACITY;
    });
    log.showInfo(`play bar reset anim`);
  }

  /**
   * 导航条动效
   * @param event 操作事件
   */
  private playBarAnim(event: GestureEvent): void {
    if (this.naviBarData.isInResetNaviBar) {
      log.showInfo('isInResetNaviBar is true');
      return;
    }
    this.naviBarViewData.barTranslateParam.barTranslateY =
      Math.min((event.offsetY - this.naviBarData.startOffsetY) / SystemSceneConstants.THREE, 0);
    this.naviBarViewData.barTranslateParam.barTranslateX =
      (event.offsetX - this.naviBarData.startOffsetX) / SystemSceneConstants.THREE;

    const hideAnimStarted: boolean =
      this.naviBarData.startOffsetY - event.offsetY >= SystemSceneConstants.OPACITY_ANIM_THRESHOLD_Y ||
        Math.abs(this.naviBarData.startOffsetX - event.offsetX) >= this.naviBarData.opacityAnimThresholdX;
    if (!this.naviBarData.isOpacityHideAnimStarted && hideAnimStarted) {
      this.hideShowAnim(hideAnimStarted, 0);
    } else if (!this.naviBarData.isOpacityShowAnimStarted && !hideAnimStarted) {
      this.hideShowAnim(hideAnimStarted, SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_OPACITY);
    }
  }

  /**
   * 导航条显示与隐藏
   * @param event 操作事件
   */
  private hideShowAnim(hideAnimStarted: boolean, opacity: number): void {
    this.naviBarData.isOpacityHideAnimStarted = hideAnimStarted;
    this.naviBarData.isOpacityShowAnimStarted = !hideAnimStarted;
    animateTo({
      curve: curves.springMotion(0.3, 1)
    }, () => {
      this.naviBarViewData.barOpacityParam.barOpacity = opacity;
      log.showInfo(`hideShowAnim barOpacity ${this.naviBarViewData.barOpacityParam.barOpacity}`);
    });
  }

  /**
   * 判断并执行导航条跟手动效
   * @param event 操作事件
   * @param naviBarWidth AI导航条宽度
   * @param dragState 拖拽状态
   */
  public checkPlayBarFollowHandAnim(event: GestureEvent): void {
    if (!this.naviBarViewData.isShowingNaviBar || !event) {
      return;
    }

    this.playBarAnim(event);
  }
  /**
   * 判断是否完成导航动效
   * @param capsuleWidth 胶囊宽度
   */
  public whetherEndWeakNavigationAnimationImmediate(capsuleWidth: number): void {
    if (this.naviBarViewData.weakNotifyParam.weakNotifyState !== WeakNotifyState.STATIC) {
      log.showInfo(`this weakNotifyState is not STATIC ,Immediate`);
      this.naviBarViewData.weakNotifyParam.weakNotifyDisAppearTime = 0;
    }
  }

  /**
   * 完成导航动效
   * @param capsuleWidth 胶囊宽度
   * @param suggestionData 建议参数
   * @returns
   */
  public endWeakNavigationAnimation(capsuleWidth: number): null {
    this.naviBarViewData.weakNotifyParam.weakNotifyState = WeakNotifyState.DISAPPEAR;
    log.showInfo('weakNotifyState = %{public}d', this.naviBarViewData.weakNotifyParam.weakNotifyState);
    animateTo({
      duration: this.naviBarViewData.weakNotifyParam.weakNotifyDisAppearTime,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        if (this.naviBarViewData.weakNotifyParam.weakNotifyState !== WeakNotifyState.DISAPPEAR) {
          log.showInfo('endWeakNavigationAnimation weakNotifyState is %{public}d',
            this.naviBarViewData.weakNotifyParam.weakNotifyState);
          return;
        }
        this.naviBarViewData.weakNotifyParam.weakNotifyState = WeakNotifyState.STATIC;
        this.naviBarViewData.weakNotifyParam.weakNotifyVisibility = Visibility.None;
        log.showInfo('capsuleWidth = %{public}d, weakNofityPlayPosition restore = %{public}d, weakNotifyState = ' +
          '%{public}d', capsuleWidth, this.naviBarViewData.weakNotifyParam.weakNotifyPlayPosition,
          this.naviBarViewData.weakNotifyParam.weakNotifyState);
        // 新启动一个时间为0的动画将弱提醒动画置于初始位置
        animateTo({
          duration: 0,
          curve: Curve.Linear,
          iterations: 1,
          playMode: PlayMode.Normal,
          expectedFrameRateRange: SCBNaviBarConstants.ANIMATE_FRAME_RATE_RANGE,
          onFinish: () => {
            this.naviBarViewData.weakNotifyParam.weakNotifyDisAppearTime = SCBNaviBarConstants.APPEAR_DELAY;
          }
        }, () => {
          let startPosition = (-3) * capsuleWidth;
          if (Math.abs(this.naviBarViewData.weakNotifyParam.weakNotifyPlayPosition - startPosition) <
          SCBNaviBarConstants.ANIMATION_OFFSET) {
            this.naviBarViewData.weakNotifyParam.weakNotifyPlayPosition =
              startPosition + SCBNaviBarConstants.ANIMATION_OFFSET;
          } else {
            this.naviBarViewData.weakNotifyParam.weakNotifyPlayPosition = startPosition;
          }
        })
      },
      expectedFrameRateRange: SCBNaviBarConstants.ANIMATE_FRAME_RATE_RANGE,
    }, () => {
      this.naviBarViewData.weakNotifyParam.weakNotifyOpacity = 0;
    })
    return null;
  }

  public changeCapsule(capsuleHeight = this.naviBarViewData.capsuleHeight,
    capsuleWidth = this.naviBarViewData.capsuleWidth) {
    this.naviBarViewData.capsuleHeight = capsuleHeight;
    this.naviBarViewData.capsuleWidth = capsuleWidth;
    this.navbarWindowManager.setResponseRegionHeight(SystemSceneConstants.DEFAULT_HEIGHT).update();
  }

  /**
   * 导航条提亮参数修改动效
   * @param type 场景类型
   */
  public naviBarChangeAnim(type: number): void {
    animateTo({
      curve: Curve.Linear,
      duration: 300
    }, () => {
      switch (type) {
        case BrightnessSceneType.DESKTOP:
          this.naviBarViewData.brightnessOptions =
            this.naviBarData.desktopBrightnessOptions;
          break;
        case BrightnessSceneType.SCREEN_LOCK:
          this.naviBarViewData.brightnessOptions =
            this.naviBarData.screenLockBrightnessOptions;
          break;
        case BrightnessSceneType.AOD:
          this.naviBarViewData.brightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_AOD;
          break;
        default:
          log.showInfo(`change type default`);
          break;
      }
    })
  }

  private changeToDefaultNaviBarOnFinish(naviBarOpacity: number): void {
    if (naviBarOpacity === 1) {
      log.showInfo(`animate end naviBarOpacity:${naviBarOpacity}`);
      return;
    }
    this.navbarWindowManager.setResponseRegionHeight(SystemSceneConstants.DEFAULT_HEIGHT)
      .setWindowHeight(this.naviBarData.windowHeight)
      .isWindowFullScreen(false, false)
      .update();
    this.naviBarViewData.naviBarOpacity = naviBarOpacity;
  }

  /**
   * 默认态导航条
   */
  public changeToDefaultNaviBar(): void {
    log.showInfo('changeToDefaultNaviBar');
    this.changeCapsule(SCBNaviBarConstants.CAPSULE_HEIGHT_INIT, this.naviBarData.naviBarWidth);
    this.initBarParam();
  }

  private getTextWidth(): number {
    const textWidthPx: number = measure.measureTextSize({
      textContent: ResUtils.getInnerString($r('app.string.drag_to_voice')),
      fontSize: TEXT_FONT_SIZE
    }).width?.valueOf() as number;
    const textWidthVp: number = ArkUIAdapter.px2vp(textWidthPx);
    log.showInfo(`getTextWidth:${textWidthVp}`);
    return textWidthVp + SCBNaviBarConstants.DEFAULT_CAPSULE_HEIGHT;
  }

  private initBarParam(): void {
    this.naviBarViewData.naviBarBottomMargin = gestureNavBarSettings.getNaviBarMarginBottom();
    this.naviBarViewData.capsuleScale = {
      x: 1,
      y: 1,
      centerX: '50%',
      centerY: '100%'
    };
    this.naviBarViewData.textScale = {
      x: 1,
      y: 1,
      centerX: '50%',
      centerY: '100%'
    };
    this.naviBarViewData.capsuleBlur = 0;
  }
}