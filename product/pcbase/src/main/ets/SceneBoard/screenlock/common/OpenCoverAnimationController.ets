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

import curves from '@ohos.curves';
import display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager, DeviceHelper } from '@ohos/frameworkwrapper';
import { ReceiveEventInfo } from '@ohos/launchercommon';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import {
  SCBScreenPowerEventType,
  SCBScreenPowerEventStatus,
  SCBScreenPowerStatusChangeReason,
  SCBScreenPowerEvent
} from '../../scenemanager/SCBScreen';
import { AnimationController, CallbackParameter } from '../../control/animationcontroller/AnimationController';

const TAG = 'ScreenLock-OpenCoverAnimationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class OpenCoverAnimationController {
  public static readonly DEFAULT_DURATION: number = 0;
  public static readonly DEFAULT_TRANSLATE: number = 0;
  public static readonly DEFAULT_SCALE: number = 1.0;
  public static readonly DEFAULT_OPACITY: number = 1.0;
  public static readonly DEFAULT_FUNCTION: () => void = () => {};
  public static readonly DEFAULT_CURVE: ICurve | Curve = curves.interpolatingSpring(0, 1, 68, 12);

  // 此延迟用于抵消“收到屏幕亮起消息”和“屏幕真正亮起”之间的时间，否则屏幕亮起时，开盖动画已经执行结束了。
  // 此延迟在不同类型机器上数值不同，需要分别适配
  public static readonly SCREEN_ON_DELAY: number = OpenCoverAnimationController.getDisplayOnDelayTime();

  public static readonly STATUS_VIEW_ANIMATION = 'statusViewAnimation';
  public static readonly STATUS_VIEW_OPACITY_BEGIN: number = 0;
  public static readonly STATUS_VIEW_SCALE_BEGIN: number = 0.96;
  public static readonly STATUS_VIEW_TRANSLATE_Y_BEGIN: number = 50;
  public static readonly STATUS_VIEW_ANIMATION_DELAY: number = 0 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly STATUS_VIEW_ANIMATION_DURATION: number = 1050; // 1050 - 0

  public static readonly TIME_VIEW_ANIMATION = 'timeViewAnimation';
  public static readonly TIME_VIEW_OPACITY_BEGIN: number = 0;
  public static readonly TIME_VIEW_SCALE_BEGIN: number = 0.96;
  public static readonly TIME_VIEW_TRANSLATE_Y_BEGIN: number = 150;
  public static readonly TIME_VIEW_ANIMATION_DELAY: number = 150 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly TIME_VIEW_ANIMATION_DURATION: number = 1050; // 1100 - 50

  public static readonly DATE_VIEW_ANIMATION = 'dateViewAnimation';
  public static readonly DATE_VIEW_OPACITY_BEGIN: number = 0;
  public static readonly DATE_VIEW_SCALE_BEGIN: number = 0.86;
  public static readonly DATE_VIEW_TRANSLATE_Y_BEGIN: number = 110;
  public static readonly DATE_VIEW_ANIMATION_DELAY: number = 200 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly DATE_VIEW_ANIMATION_DURATION: number = 1050; // 1150 - 100
  public static readonly TIME_DATA_VIEW_ORIGIN_HEIGHT: number = 135;
  public static readonly TIME_DATA_VIEW_EXTENDED_HEIGHT: number = 2 *
    OpenCoverAnimationController.DATE_VIEW_TRANSLATE_Y_BEGIN;

  public static readonly USER_VIEW_ANIMATION = 'userViewAnimation';
  public static readonly USER_ITEM_VIEW_OPACITY_BEGIN: number = 0;
  public static readonly USER_ITEM_VIEW_SCALE_BEGIN: number = 0.8;
  public static readonly USER_ITEM_VIEW_TRANSLATE_Y_BEGIN: number = 90;
  public static readonly USER_ITEM_VIEW_ANIMATION_DELAY: number = 300 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly USER_ITEM_VIEW_ANIMATION_DURATION: number = 850; // 1150 - 300

  public static readonly LIGHT_VIEW_ANIMATION = 'lightViewAnimation';
  public static readonly LIGHT_VIEW_ANIMATION_DELAY: number = 300 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly LIGHT_VIEW_ANIMATION_DURATION: number = 400;
  public static readonly LIGHT_VIEW_ANIMATION_CURVE: ICurve | Curve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
  public static readonly LIGHT_VIEW_ANIMATION_FINISH = 'lightViewAnimationFinish';
  public static readonly LIGHT_VIEW_OPACITY_BEGIN: number = 0;
  public static readonly LIGHT_VIEW_OPACITY_END: number = 1;
  public static readonly LIGHT_VIEW_SHADOW_RADIUS: number = 15;
  public static readonly LIGHT_VIEW_COLOR: Color | string = Color.White;
  public static readonly LIGHT_VIEW_ANIMATION_CURVE_FINISH: ICurve | Curve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
  public static readonly LIGHT_VIEW_ANIMATION_DELAY_FINISH: number =
    OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_DELAY +
    OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_DURATION;
  public static readonly LIGHT_VIEW_ANIMATION_DURATION_FINISH: number = 550;

  public static readonly PASSWORD_VIEW_ANIMATION = 'passwordViewAnimation';
  public static readonly PASSWORD_VIEW_OPACITY_BEGIN: number = 0;
  public static readonly PASSWORD_VIEW_SCALE_BEGIN: number = 0.75;
  public static readonly PASSWORD_VIEW_TRANSLATE_Y_BEGIN: number = 80;
  public static readonly PASSWORD_VIEW_ANIMATION_DELAY: number = 350 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly PASSWORD_VIEW_ANIMATION_DURATION: number = 850; // 1200 - 350


  public static readonly WALLPAPER_VIEW_MASK_ANIMATION = 'wallPaperViewMaskAnimation';
  public static readonly WALLPAPER_VIEW_MASK_OPACITY_END: number = 0;
  public static readonly WALLPAPER_VIEW_MASK_SCALE_END: number = 1.2;
  public static readonly WALLPAPER_VIEW_MASK_CENTER_X: number = 0.5 * px2vp(this.getScreenWidth());
  public static readonly WALLPAPER_VIEW_MASK_CENTER_Y: number = px2vp(this.getScreenHeight()) + 100;
  public static readonly WALLPAPER_VIEW_MASK_RADIUS_BEGIN: number = 0;
  public static readonly WALLPAPER_VIEW_MASK_RADIUS_END: number = 1;
  public static readonly WALLPAPER_VIEW_MASK_TRANSLATE_Y_END: number = -0.5 *
    px2vp(this.getScreenHeight());
  public static readonly WALLPAPER_VIEW_TRANSLATE_BEGIN: number = 15;
  public static readonly WALLPAPER_VIEW_ANIMATION = 'wallPaperViewAnimation';
  public static readonly WALLPAPER_VIEW_ANIMATION_DELAY: number = 0 + OpenCoverAnimationController.SCREEN_ON_DELAY;
  public static readonly WALLPAPER_VIEW_ANIMATION_DURATION: number = 950; // 950 - 0
  public static readonly WALLPAPER_VIEW_ANIMATION_CURVE: ICurve | Curve = curves.cubicBezierCurve(0.4, 0, 0.4, 1);

  private static readonly ANIMATION_FINAL_EXECUTION_TIME: number = 1000;
  private static readonly SCREEN_POWER_EVENT_NAME: string = 'SCBScreen_ScreenPowerEvent';

  private static instance: OpenCoverAnimationController;

  public wallpaperMarkResource: Resource = $r('app.media.ic_lock_wallpaper_mask');
  private isDisplayOnForOpeningCover: boolean = false;
  private animationController: AnimationController = new AnimationController();
  private initParamMap: Map<string, () => void> = new Map();
  private animationParamMap: Map<string, CallbackParameter> = new Map();

  public static getScreenHeight(): number {
    try {
      return display.getDefaultDisplaySync().height;
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error.message}`);
      return 0;
    }
  }

  public static getScreenWidth(): number {
    try {
      return display.getDefaultDisplaySync().width;
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error.message}`);
      return 0;
    }
  }

  public static getDisplayOnDelayTime(): number {
    let defaultDelayTime: number = 0;
    try {
      let displayOnDelayTime: string =
        systemParameterEnhance.getSync('const.pcsceneboard.pc_display_on_delay_time', defaultDelayTime.toString());
      log.showInfo(`Get pc_display_on_delay_time is ${displayOnDelayTime}`);
      return Number.parseInt(displayOnDelayTime);
    } catch (e) {
      log.showError('Get pc_display_on_delay_time failed');
      return defaultDelayTime;
    }
  }

  public static getInstance(): OpenCoverAnimationController {
    if (!OpenCoverAnimationController.instance) {
      OpenCoverAnimationController.instance = new OpenCoverAnimationController();
    }
    return OpenCoverAnimationController.instance;
  }

  public static isKLV(): boolean {
    return DeviceHelper.PRODUCT_MODEL.includes('HYM-W5821');
  }

  private constructor() {
    localEventManager.registerEventListener(this.handlePowerEventListener,
      [OpenCoverAnimationController.SCREEN_POWER_EVENT_NAME]);
  }

  private handlePowerEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, powerEvent: SCBScreenPowerEvent) => {
      if (event !== OpenCoverAnimationController.SCREEN_POWER_EVENT_NAME) {
        return;
      }
      this.handlePowerEvents(powerEvent);
    }
  }

  private handlePowerEvents(powerEvent: SCBScreenPowerEvent): void {
    if (!this.isEnableOpenCoverAnimation()) {
      return;
    }
    if (this.isBeginOpenCover(powerEvent)) {
      log.showInfo('init openCoverAnimation');
      this.isDisplayOnForOpeningCover = true;
      this.runInitParamCallbacks();
      this.handleException();
    } else if (this.isEndOpenCover(powerEvent)) {
      log.showInfo('start openCoverAnimation');
      this.isDisplayOnForOpeningCover = false;
      this.runAnimationCallbacks()
    } else {
    }
  }

  public runInitParamCallbacks(): void {
    let callbackCount = this.animationParamMap.size;
    if (callbackCount <= 0) {
      log.showWarn('No open cover init param callback.');
      return;
    }
    log.showInfo('start open cover init param callback');
    this.initParamMap.forEach((callback: () => void, name: string) => {
      log.showDebug(`start open cover init param callback: ${name}`);
      if (callback) {
        callback();
      }
    });
  }

  public runAnimationCallbacks(): void {
    let callbackCount = this.animationParamMap.size;
    if (callbackCount <= 0) {
      log.showWarn('No open cover animation callback.');
      return;
    }
    log.showInfo('start open cover animation');
    this.animationParamMap.forEach((callback: CallbackParameter, name: string) => {
      log.showDebug(`start open cover animation: ${name}`);
      if (callback) {
        this.animationController.runAnimationDirectly(callback);
      }
    })
  }

  public isEnableOpenCoverAnimation(): boolean {
    return true;
  }

  public registerInitParamCallback(name: string, initParamCallback: () => void) {
    if (!this.isEnableOpenCoverAnimation()) {
      return;
    }
    if (initParamCallback) {
      log.showInfo(`set ${name} init param`);
      this.initParamMap.set(name, initParamCallback);
    }
  }

  public registerAnimationCallback(name: string, animationCallback: () => void, finishCallback?: () => void): void {
    if (!this.isEnableOpenCoverAnimation()) {
      return;
    }
    let animationParam: CallbackParameter | null = this.getAnimationParam(name);
    if (!animationParam) {
      log.showError(name + ' animationParam is undefined, skip.');
      return;
    }
    if (animationCallback) {
      animationParam.callback = animationCallback;
    }
    if (finishCallback) {
      animationParam.finish = finishCallback;
    }
    log.showInfo(`set ${name} animation param`);
    this.animationParamMap.set(name, animationParam);
  }

  public unregisterCallback(name: string): void {
    this.initParamMap.delete(name);
    this.animationParamMap.delete(name);
  }

  private isBeginOpenCover(powerEvent: SCBScreenPowerEvent): boolean {
    if (powerEvent.eventType === SCBScreenPowerEventType.DISPLAY_OFF) {
      this.isDisplayOnForOpeningCover = false;
      return false;
    }
    return powerEvent.eventType === SCBScreenPowerEventType.WAKE_UP &&
      powerEvent.eventStatus === SCBScreenPowerEventStatus.BEGIN &&
      powerEvent.changeReason === SCBScreenPowerStatusChangeReason.POWER_CHANGE_REASON_SWITCH;
  }

  private isEndOpenCover(powerEvent: SCBScreenPowerEvent): boolean {
    // 开盖亮屏状态已准备，则真正亮屏时，不管亮屏原因是什么，都必须执行动画，否则会导致屏幕被黑色遮住和锁屏元素不显示。
    return this.isDisplayOnForOpeningCover &&
      powerEvent.eventType === SCBScreenPowerEventType.DISPLAY_ON &&
      powerEvent.eventStatus === SCBScreenPowerEventStatus.END;
  }

  private handleException(): void {
    // 执行了开盖准备过程，必须执行开盖动画。若正常流程下未执行开盖动画，则一段时间后强制执行。
    setTimeout(() => {
      if (this.isDisplayOnForOpeningCover) {
        log.showWarn('open cover animation exception');
        this.isDisplayOnForOpeningCover = false;
        this.runAnimationCallbacks();
      }
    }, OpenCoverAnimationController.ANIMATION_FINAL_EXECUTION_TIME);
  }

  private getAnimationParam(name: string): CallbackParameter | null {
    let animationParam: CallbackParameter | null = null;
    switch (name) {
      case OpenCoverAnimationController.DATE_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.DEFAULT_CURVE,
          OpenCoverAnimationController.DATE_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.DATE_VIEW_ANIMATION_DELAY);
        break;
      case OpenCoverAnimationController.TIME_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.DEFAULT_CURVE,
          OpenCoverAnimationController.TIME_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.TIME_VIEW_ANIMATION_DELAY);
        break;
      case OpenCoverAnimationController.WALLPAPER_VIEW_MASK_ANIMATION:
      case OpenCoverAnimationController.WALLPAPER_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.WALLPAPER_VIEW_ANIMATION_CURVE,
          OpenCoverAnimationController.WALLPAPER_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.WALLPAPER_VIEW_ANIMATION_DELAY);
        break;
      case OpenCoverAnimationController.STATUS_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.DEFAULT_CURVE,
          OpenCoverAnimationController.STATUS_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.STATUS_VIEW_ANIMATION_DELAY);
        break;
      default:
        animationParam = this.getAnimationParamOthers(name);
        break;
    }
    return animationParam;
  }

  private getAnimationParamOthers(name: string): CallbackParameter | null {
    let animationParam: CallbackParameter | null = null;
    switch (name) {
      case OpenCoverAnimationController.LIGHT_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_CURVE,
          OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_DELAY);
        break;
      case OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_FINISH:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_CURVE_FINISH,
          OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_DURATION_FINISH,
          OpenCoverAnimationController.LIGHT_VIEW_ANIMATION_DELAY_FINISH);
        break;
      case OpenCoverAnimationController.USER_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.DEFAULT_CURVE,
          OpenCoverAnimationController.USER_ITEM_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.USER_ITEM_VIEW_ANIMATION_DELAY);
        break;
      case OpenCoverAnimationController.PASSWORD_VIEW_ANIMATION:
        animationParam = new CallbackParameter(
          OpenCoverAnimationController.DEFAULT_FUNCTION, OpenCoverAnimationController.DEFAULT_CURVE,
          OpenCoverAnimationController.PASSWORD_VIEW_ANIMATION_DURATION,
          OpenCoverAnimationController.PASSWORD_VIEW_ANIMATION_DELAY);
        break;
      default:
        animationParam = null;
        break;
    }
    return animationParam;
  }

  destroy(): void {
    localEventManager.unregisterEventListener(this.handlePowerEventListener)
  }
}