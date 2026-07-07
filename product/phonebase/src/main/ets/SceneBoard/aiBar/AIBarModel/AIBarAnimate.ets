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
import { AIBarData } from './AIBarData';
import {
  AiBarStatusFlag,
  AIBarViewData,
  BrightnessSceneType,
  WeakNotifyState
} from './AIBarViewData';
import { SCBAiBarConstants } from '../SCBAiBarConstants';
import { curves } from '@kit.ArkUI';
import { SystemSceneConstants } from '../../gesturenavigation/SystemSceneConstants';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { vibratorMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { animateExStart } from '@ohos/windowscene/Index';
import { AIBarClickBackgroundData } from './AIBarClickBackgroundData';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
import { NavbarWindowManager } from '../../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
import measure from '@ohos.measure';
import { ResUtils } from '@ohos/windowscene';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { AiBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/AiBarVisualEffectManager';

const TAG: string = 'aiBarAnimate';
const TEXT_FONT_SIZE: string = `${ArkUIAdapter.vp2px(SCBAiBarConstants.DRAG_TO_VOICE_FONT_SIZE)}px`;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class AIBarAnimate {
  private aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
  private aiBarClickBackgroundData: AIBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
  private aiBarData: AIBarData = AIBarData.getInstance();
  private navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
  private static mInstance: AIBarAnimate;

  static getInstance(): AIBarAnimate {
    if (AIBarAnimate.mInstance == null) {
      AIBarAnimate.mInstance = new AIBarAnimate();
    }
    return AIBarAnimate.mInstance;
  }

  public checkInitAnimParam(event?: GestureEvent): void {
    if (!this.aiBarViewData.isShowingAiBar || !event) {
      return;
    }
    this.resetAnimParam(event);
  }

  public resetAnimParam(event: GestureEvent): void {
    this.resetAiBarParam();
    this.aiBarData.startOffsetY = event.offsetY;
    this.aiBarData.startOffsetX = event.offsetX;
    log.showInfo(`[${TAG}] resetAnimParam`);
  }

  public resetAiBarParam() {
    // 避免刚上滑触发一次透明度动效
    this.aiBarData.isOpacityHideAnimStarted = false;
    this.aiBarData.isOpacityShowAnimStarted = true;
    this.aiBarViewData.barTranslateParam.barTranslateY = 0;
    this.aiBarViewData.barTranslateParam.barTranslateX = 0;
    this.changeToDefaultAiBar();
    this.aiBarViewData.aiBarBottomMargin = gestureNavBarSettings.getAiBarMarginBottom();
  }

  public processBackEventAnimate(): void {
    log.showInfo('enter processBackEvent');
    this.aiBarClickBackgroundData.aiBarBackgroundOpacity = 1;
    animateTo({
      curve: curves.springMotion(0.468, 1),
    }, () => {
      this.aiBarClickBackgroundData.aiBarBackgroundOpacity = 0;
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
    if (this.aiBarData.isAppHide) {
      this.aiBarData.isAppHide = false;
      return TransitionEffect.IDENTITY;
    }
    if (isSystemBarEnable) {
      return TransitionEffect.OPACITY.animation({ curve: Curve.Linear, duration: 200 });
    }
    return this.AIBarTransitionEffect();
  }

  private AIBarTransitionEffect(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({ curve: curves.springMotion(0.4, 1) })
      .combine(TransitionEffect.translate({ y: 10 })
        .animation({ curve: curves.springMotion(0.4, 1) }));
  }

  public onActionEndAndCancelAnimal() {
    animateTo({
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      duration: 200
    }, () => {
      this.aiBarViewData.barOpacityParam.barOpacity = 1;
    })
  }

  /**
   * 重置导航条参数
   */
  public playBarResetAnim(): void {
    this.aiBarData.isInResetAiBar = true;
    animateTo({
      curve: curves.springMotion(0.3, 1),
      onFinish: () => {
        this.aiBarData.isInResetAiBar = false;
      }
    }, () => {
      this.aiBarViewData.barTranslateParam.barTranslateY = 0;
      this.aiBarViewData.barTranslateParam.barTranslateX = 0;
      this.aiBarViewData.barOpacityParam.barOpacity = SCBAiBarConstants.GESTURE_NAV_AI_BAR_OPACITY;
    });
    log.showInfo(`play bar reset anim`);
  }

  /**
   * 导航条动效
   * @param event 操作事件
   */
  private playBarAnim(event: GestureEvent): void {
    if (this.aiBarData.isInResetAiBar) {
      log.showInfo('isInResetAiBar is true');
      return;
    }
    this.aiBarViewData.barTranslateParam.barTranslateY =
      Math.min((event.offsetY - this.aiBarData.startOffsetY) / SystemSceneConstants.THREE, 0);
    this.aiBarViewData.barTranslateParam.barTranslateX =
      (event.offsetX - this.aiBarData.startOffsetX) / SystemSceneConstants.THREE;

    const hideAnimStarted: boolean =
      this.aiBarData.startOffsetY - event.offsetY >= SystemSceneConstants.OPACITY_ANIM_THRESHOLD_Y ||
        Math.abs(this.aiBarData.startOffsetX - event.offsetX) >= this.aiBarData.opacityAnimThresholdX;
    if (!this.aiBarData.isOpacityHideAnimStarted && hideAnimStarted) {
      this.hideShowAnim(hideAnimStarted, 0);
    } else if (!this.aiBarData.isOpacityShowAnimStarted && !hideAnimStarted) {
      this.hideShowAnim(hideAnimStarted, SCBAiBarConstants.GESTURE_NAV_AI_BAR_OPACITY);
    }
  }

  /**
   * 导航条显示与隐藏
   * @param event 操作事件
   */
  private hideShowAnim(hideAnimStarted: boolean, opacity: number): void {
    this.aiBarData.isOpacityHideAnimStarted = hideAnimStarted;
    this.aiBarData.isOpacityShowAnimStarted = !hideAnimStarted;
    animateTo({
      curve: curves.springMotion(0.3, 1)
    }, () => {
      this.aiBarViewData.barOpacityParam.barOpacity = opacity;
      log.showInfo(`hideShowAnim barOpacity ${this.aiBarViewData.barOpacityParam.barOpacity}`);
    });
  }

  /**
   * 判断并执行导航条跟手动效
   * @param event 操作事件
   * @param aiBarWidth AI导航条宽度
   * @param dragState 拖拽状态
   */
  public checkPlayBarFollowHandAnim(event: GestureEvent): void {
    if (!this.aiBarViewData.isShowingAiBar || !event) {
      return;
    }

    this.playBarAnim(event);
  }
  /**
   * 判断是否完成导航动效
   * @param capsuleWidth 胶囊宽度
   */
  public whetherEndWeakNavigationAnimationImmediate(capsuleWidth: number): void {
    if (this.aiBarViewData.weakNotifyParam.weakNotifyState !== WeakNotifyState.STATIC) {
      log.showInfo(`this weakNotifyState is not STATIC ,Immediate`);
      this.aiBarViewData.weakNotifyParam.weakNotifyDisAppearTime = 0;
    }
  }

  /**
   * 完成导航动效
   * @param capsuleWidth 胶囊宽度
   * @param suggestionData 建议参数
   * @returns
   */
  public endWeakNavigationAnimation(capsuleWidth: number): null {
    this.aiBarViewData.weakNotifyParam.weakNotifyState = WeakNotifyState.DISAPPEAR;
    log.showInfo('weakNotifyState = %{public}d', this.aiBarViewData.weakNotifyParam.weakNotifyState);
    animateTo({
      duration: this.aiBarViewData.weakNotifyParam.weakNotifyDisAppearTime,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        if (this.aiBarViewData.weakNotifyParam.weakNotifyState !== WeakNotifyState.DISAPPEAR) {
          log.showInfo('endWeakNavigationAnimation weakNotifyState is %{public}d',
            this.aiBarViewData.weakNotifyParam.weakNotifyState);
          return;
        }
        this.aiBarViewData.weakNotifyParam.weakNotifyState = WeakNotifyState.STATIC;
        this.aiBarViewData.weakNotifyParam.weakNotifyVisibility = Visibility.None;
        log.showInfo('capsuleWidth = %{public}d, weakNofityPlayPosition restore = %{public}d, weakNotifyState = ' +
          '%{public}d', capsuleWidth, this.aiBarViewData.weakNotifyParam.weakNotifyPlayPosition,
          this.aiBarViewData.weakNotifyParam.weakNotifyState);
        // 新启动一个时间为0的动画将弱提醒动画置于初始位置
        animateTo({
          duration: 0,
          curve: Curve.Linear,
          iterations: 1,
          playMode: PlayMode.Normal,
          expectedFrameRateRange: SCBAiBarConstants.ANIMATE_FRAME_RATE_RANGE,
          onFinish: () => {
            this.aiBarViewData.weakNotifyParam.weakNotifyDisAppearTime = SCBAiBarConstants.APPEAR_DELAY;
          }
        }, () => {
          let startPosition = (-3) * capsuleWidth;
          if (Math.abs(this.aiBarViewData.weakNotifyParam.weakNotifyPlayPosition - startPosition) <
          SCBAiBarConstants.ANIMATION_OFFSET) {
            this.aiBarViewData.weakNotifyParam.weakNotifyPlayPosition =
              startPosition + SCBAiBarConstants.ANIMATION_OFFSET;
          } else {
            this.aiBarViewData.weakNotifyParam.weakNotifyPlayPosition = startPosition;
          }
        })
      },
      expectedFrameRateRange: SCBAiBarConstants.ANIMATE_FRAME_RATE_RANGE,
    }, () => {
      this.aiBarViewData.weakNotifyParam.weakNotifyOpacity = 0;
    })
    return null;
  }

  public changeCapsule(capsuleHeight = this.aiBarViewData.capsuleHeight,
    capsuleWidth = this.aiBarViewData.capsuleWidth) {
    this.aiBarViewData.capsuleHeight = capsuleHeight;
    this.aiBarViewData.capsuleWidth = capsuleWidth;
    this.navbarWindowManager.setResponseRegionHeight(SystemSceneConstants.DEFAULT_HEIGHT).update();
  }

  /**
   * 导航条提亮参数修改动效
   * @param type 场景类型
   */
  public aiBarChangeAnim(type: number): void {
    animateTo({
      curve: Curve.Linear,
      duration: 300
    }, () => {
      switch (type) {
        case BrightnessSceneType.DESKTOP:
          this.aiBarViewData.brightnessOptions =
            this.aiBarData.desktopBrightnessOptions;
          break;
        case BrightnessSceneType.SCREEN_LOCK:
          this.aiBarViewData.brightnessOptions =
            this.aiBarData.screenLockBrightnessOptions;
          break;
        case BrightnessSceneType.AOD:
          this.aiBarViewData.brightnessOptions = SCBAiBarConstants.BRIGHTNESS_OPTIONS_AOD;
          break;
        default:
          log.showInfo(`change type default`);
          break;
      }
    })
  }

  private changeToDefaultAiBarOnFinish(aiBarOpacity: number): void {
    if (aiBarOpacity === 1) {
      log.showInfo(`animate end aiBarOpacity:${aiBarOpacity}`);
      return;
    }
    this.navbarWindowManager.setResponseRegionHeight(SystemSceneConstants.DEFAULT_HEIGHT)
      .setWindowHeight(this.aiBarData.windowHeight)
      .isWindowFullScreen(false, false)
      .update();
    this.aiBarViewData.aiBarOpacity = aiBarOpacity;
  }

  /**
   * 默认态导航条
   */
  public changeToDefaultAiBar(): void {
    log.showInfo('changeToDefaultAiBar');
    this.changeCapsule(SCBAiBarConstants.CAPSULE_HEIGHT_INIT, this.aiBarData.aiBarWidth);
    this.initBarParam();
  }

  private getTextWidth(): number {
    const textWidthPx: number = measure.measureTextSize({
      textContent: ResUtils.getInnerString($r('app.string.drag_to_voice')),
      fontSize: TEXT_FONT_SIZE
    }).width?.valueOf() as number;
    const textWidthVp: number = ArkUIAdapter.px2vp(textWidthPx);
    log.showInfo(`getTextWidth:${textWidthVp}`);
    return textWidthVp + SCBAiBarConstants.DEFAULT_CAPSULE_HEIGHT;
  }

  private initBarParam(): void {
    this.aiBarViewData.aiBarBottomMargin = gestureNavBarSettings.getAiBarMarginBottom();
    this.aiBarViewData.capsuleScale = {
      x: 1,
      y: 1,
      centerX: '50%',
      centerY: '100%'
    };
    this.aiBarViewData.textScale = {
      x: 1,
      y: 1,
      centerX: '50%',
      centerY: '100%'
    };
    this.aiBarViewData.capsuleBlur = 0;
  }
}