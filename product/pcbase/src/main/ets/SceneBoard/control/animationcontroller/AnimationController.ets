/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import { Log } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { performanceMonitor } from '@kit.ArkUI';

const TAG: string = 'AnimationController';

export class CallbackParameter {
  public callback: () => void;
  public curve?: ICurve | Curve;
  public duration?: number;
  public delay?: number;
  public finish?: () => void;
  public initCallback?: () => void;
  public isPreset: boolean = true;

  constructor(callback: () => void, curve?: ICurve | Curve, duration?: number, delay?: number, finish?: () => void) {
    this.callback = callback;
    if (curve) {
      this.curve = curve;
    }
    if (duration) {
      this.duration = duration;
    }
    if (delay) {
      this.delay = delay;
    }
    if (finish) {
      this.finish = finish;
    }
  }
}

export class AnimationController {

  protected static callbackMap: Map<string, CallbackParameter> = new Map();

  protected isUnlocking: boolean = false;

  public setLocked(): void {
    this.isUnlocking = false;
  }

  public doCallbacks(): void {
    if (this.isUnlocking) {
      return;
    }
    this.isUnlocking = true;
    let callbackCount = AnimationController.callbackMap.size;
    if (callbackCount <= 0) {
      Log.showDebug(TAG, 'There is no callback, skip.');
      return;
    }
    Log.showInfo(TAG, 'begin do animation init action');
    AnimationController.callbackMap.forEach((callback: CallbackParameter, name: string) => {
      callback.initCallback?.();
    })
    Log.showInfo(TAG, 'begin do animation');
    AnimationController.callbackMap.forEach((callback: CallbackParameter, name: string) => {
      Log.showDebug(TAG, 'start do callback ' + name + ', show parameter' +
              ', duration = ' + callback.duration + ', delay = ' + callback.delay);
      this.doAnimation(callback);
    })
    // send all animation to rs immediately
    animateToImmediately({}, () => { });
    performanceMonitor.end(HiSysEventUtil.PASSWORD_UNLOCK_ANI);
  }

  public addCallback(name: string, screenId: number): void {
    let parameter = new CallbackParameter((): void => {});
    parameter.isPreset = false;
    AnimationController.callbackMap.set(name + screenId, parameter);
  }

  public addInitCallback(name: string, callback: () => void): void {
    if (!AnimationController.callbackMap.has(name) || !callback) {
      Log.showDebug(TAG, name + ' is not a legal callback skip.');
      return;
    }

    // Update and register callback
    let callbackParam = AnimationController.callbackMap.get(name);
    if (!callbackParam) {
      Log.showDebug(TAG, name + ' callback param is undefined, skip.');
      return;
    }
    callbackParam.initCallback = callback;
    AnimationController.callbackMap.set(name, callbackParam);
  }

  registerCallback(name: string, callback: () => void, finish?: () => void): void {
    if (!AnimationController.callbackMap.has(name) || !callback) {
      Log.showDebug(TAG, name + ' is not a legal callback skip.');
      return;
    }

    // Update and register callback
    let callbackParam = AnimationController.callbackMap.get(name);
    if (!callbackParam) {
      Log.showDebug(TAG, name + ' callback param is undefined, skip.');
      return;
    }
    callbackParam.callback = callback;
    if (finish) {
      callbackParam.finish = finish;
    }
    AnimationController.callbackMap.set(name, callbackParam);
  }

  // no need unregisterCallback
  unregisterCallback(name: string): void {
    // 系统预置的，不需要unregister，非系统预置的，则删除掉key
    let callbackParam = AnimationController.callbackMap.get(name);
    if (callbackParam && !callbackParam.isPreset) {
      AnimationController.callbackMap.delete(name);
    }
  }

  runAnimationDirectly(callback: CallbackParameter): void {
    this.doAnimation(callback);
  }

  private doAnimation(callback: CallbackParameter): void {
    if (!callback.callback) {
      Log.showDebug(TAG, 'do not have callback, exit directly.');
      return;
    }
    if (!callback.curve) {
      Log.showDebug(TAG, 'do not save curve, do callback directly.');
      callback.callback();
      return;
    }
    animateTo({
      delay: callback.delay,
      curve: callback.curve,
      duration: callback.duration,
      onFinish: callback.finish
    }, callback.callback);
  }
}