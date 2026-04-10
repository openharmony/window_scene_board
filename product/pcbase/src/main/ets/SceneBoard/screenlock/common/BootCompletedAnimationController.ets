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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import screenLockService from '../refactor/ScreenLockService';
import { AnimationController, CallbackParameter } from '../../control/animationcontroller/AnimationController';

const TAG = 'ScreenLock-BootCompletedAnimationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class BootCompletedAnimationController {
  public static readonly DEFAULT_DURATION: number = 0;
  public static readonly DEFAULT_TRANSLATE: number = 0;
  public static readonly DEFAULT_SCALE: number = 1.0;
  public static readonly DEFAULT_OPACITY: number = 1.0;
  public static readonly DEFAULT_FUNCTION: () => void = () => {};
  
  public static readonly USER_ITEM_ANIMATION = 'userItemAnimation';
  public static readonly USER_ITEM_OPACITY_BEGIN: number = 0;
  public static readonly USER_ITEM_SCALE_BEGIN: number = 0.6;
  public static readonly USER_ITEM_ANIMATION_DELAY: number = 0;
  public static readonly USER_ITEM_ANIMATION_DURATION: number = 250
  public static readonly USER_ITEM_ANIMATION_CURVE: ICurve | Curve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);

  public static readonly PASSWORD_ITEM_ANIMATION = 'passwordItemAnimation';
  public static readonly PASSWORD_ITEM_ANIMATION_DELAY: number = 30;
  public static readonly PASSWORD_ITEM_OPACITY_BEGIN: number = 0;
  public static readonly PASSWORD_ITEM_SCALE_BEGIN: number = 0.8;
  public static readonly PASSWORD_ITEM_TRANSLATE_Y_BEGIN: number = 50;
  public static readonly PASSWORD_ITEM_ANIMATION_DURATION: number = 220;
  public static readonly PASSWORD_ITEM_ANIMATION_CURVE: ICurve | Curve = curves.interpolatingSpring(0, 1, 200, 22);

  private static readonly ANIMATION_DATA_NOT_GET_EXECUTION_TIME: number = 350;
  private static readonly ANIMATION_FINAL_EXECUTION_TIME: number = 1000;

  public isUserDataPrepared: boolean = false;
  private isAnimationStartForBootCompleted: boolean = false;
  private animationController: AnimationController = new AnimationController();
  private initParamMap: Map<string, () => void> = new Map();
  private animationParamMap: Map<string, CallbackParameter> = new Map();
  private static mInstance: BootCompletedAnimationController;

  public static getInstance(): BootCompletedAnimationController {
    if (!BootCompletedAnimationController.mInstance) {
      BootCompletedAnimationController.mInstance = new BootCompletedAnimationController();
    }
    return BootCompletedAnimationController.mInstance;
  }

  private constructor() {
  }

  private isNeedBootCompletedAnimation(): boolean {
    return screenLockService.firstUnLockScreen;
  }

  public runInitParamCallbacks(): void {
    let callbackCount: number = this.animationParamMap.size;
    if (callbackCount <= 0) {
      log.showWarn('No boot completed init param callback.');
      return;
    }
    log.showInfo('start boot completed init param callback');
    this.initParamMap.forEach((callback: () => void, name: string) => {
      log.showDebug(`start boot completed init param callback: ${name}`);
      if (callback) {
        callback();
      }
    });
  }

  public runAnimationCallbacks(reason?: string): void {
    if (!this.isAnimationStartForBootCompleted) {
      return;
    }
    this.isAnimationStartForBootCompleted = false;
    log.showInfo(`run boot completed animation reason : ${reason}`);
    let callbackCount: number = this.animationParamMap.size;
    if (callbackCount <= 0) {
      log.showWarn('No boot completed animation callback.');
      return;
    }
    log.showInfo('start boot completed animation');
    this.animationParamMap.forEach((callback: CallbackParameter, name: string) => {
      log.showDebug(`start boot completed animation: ${name}`);
      if (callback) {
        this.animationController.runAnimationDirectly(callback);
      }
    })
  }

  public registerInitParamCallback(name: string, initParamCallback: () => void) {
    if (!this.isNeedBootCompletedAnimation()) {
      return;
    }
    if (initParamCallback) {
      log.showInfo(`set ${name} init param`);
      this.initParamMap.set(name, initParamCallback);
    }
  }

  public registerAnimationCallback(name: string, animationCallback: () => void, finishCallback?: () => void): void {
    if (!this.isNeedBootCompletedAnimation()) {
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

  public prepareScreenLockBootCompletedAnimation(): void {
    if (!this.isNeedBootCompletedAnimation()) {
      return;
    }
    this.isAnimationStartForBootCompleted = true;
    this.runInitParamCallbacks();
    this.handleException();
  }

  public runScreenLockBootCompletedAnimation(): void {
    if (this.isUserDataPrepared) {
      this.runAnimationCallbacks('normal');
    } else {
      this.handleDataNotGetAnimation();
    }
  }

  private handleDataNotGetAnimation() {
    setTimeout(() => {
      this.runAnimationCallbacks('slowly');
    }, BootCompletedAnimationController.ANIMATION_DATA_NOT_GET_EXECUTION_TIME);
  }

  private handleException(): void {
    // 异常处理，最终一定要显示。
    setTimeout(() => {
      this.runAnimationCallbacks('exception');
    }, BootCompletedAnimationController.ANIMATION_FINAL_EXECUTION_TIME);
  }

  private getAnimationParam(name: string): CallbackParameter | null {
    let animationParam: CallbackParameter | null = null;
    switch (name) {
      case BootCompletedAnimationController.USER_ITEM_ANIMATION:
        animationParam = new CallbackParameter(
          BootCompletedAnimationController.DEFAULT_FUNCTION,
          BootCompletedAnimationController.USER_ITEM_ANIMATION_CURVE,
          BootCompletedAnimationController.USER_ITEM_ANIMATION_DURATION,
          BootCompletedAnimationController.USER_ITEM_ANIMATION_DELAY);
        break;
      case BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION:
        animationParam = new CallbackParameter(
          BootCompletedAnimationController.DEFAULT_FUNCTION,
          BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION_CURVE,
          BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION_DURATION,
          BootCompletedAnimationController.PASSWORD_ITEM_ANIMATION_DELAY);
        break;
      default:
        animationParam = null;
        break;
    }
    return animationParam;
  }
}