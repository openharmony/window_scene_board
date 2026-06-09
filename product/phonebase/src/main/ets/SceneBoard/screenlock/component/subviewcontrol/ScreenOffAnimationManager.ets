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

import { LogDomain, Logger } from '@ohos/basicutils';
import {
  PowerState,
  ScreenOnOffListener,
  ScreenOnOffService,
  CustomScreenOffAnimationManager,
} from '@ohos/screenlockcommon';
import { BaseViewController } from '@ohos/frameworkcommon';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { slStateHelper } from '../../model/helper/SlStateHelper';

const log: Logger = Logger.getLogHelper(LogDomain.KG);
const TAG = 'ScreenOffAnimationManager';
const DEFAULT_TIMEOUT_ID: number = -1;
const TIMEOUT_VALUE: number = 180;
const ANIMATION_TIME: number = 100;

/**
 * SCBSystemTopPanel中ScreenOffAnimationView的Data类
 */
export class ScreenOffAnimationViewData {
  /**
   * 控制ScreenOffAnimationView是否显示
   */
  public isShow: boolean = false;
}

export class ScreenOffAnimationManager implements CustomScreenOffAnimationManager {
  private static sInstance: ScreenOffAnimationManager;
  private isSupportAni: boolean = false;
  private isReady: boolean = true;
  private waitQueue: ((value: void | PromiseLike<void>) => void)[] = [];
  private finishCallBack?: () => void;
  private animationData?: ScreenOffAnimationViewData;
  private viewController?: BaseViewController;
  private timeoutId: number = DEFAULT_TIMEOUT_ID;
  private powerStateChangeListener: ScreenOnOffListener = {
    onEndSleep: () => {
      this.toggleAnimationView(false);
    },

    onBeginWakeUp: () => {
      this.toggleAnimationView(false);
    }
  };

  private constructor() {
    try {
      this.isSupportAni = systemParameterEnhance.getSync('const.display.colorfade_support', 'false') === 'true';
    } catch (e) {
      log.showError(TAG, `Get colorfade support failed code: ${e?.code}, msg: ${e?.message}`);
    }
    log.showInfo(TAG, `isSupportAni:${this.isSupportAni}`);
  }

  /**
   * 获取灭屏动效管理实例
   *
   * @returns 灭屏动效管理实例
   */
  public static getInstance(): ScreenOffAnimationManager {
    if (!ScreenOffAnimationManager.sInstance) {
      ScreenOffAnimationManager.sInstance = new ScreenOffAnimationManager();
    }
    return ScreenOffAnimationManager.sInstance;
  }

  /**
   * 初始化，设置SystemTopPanel界面的ScreenOffAnimationData和ViewController
   *
   * @param animationData SystemTopPanel的灭屏动效数据
   * @param viewController SystemTopPanel的界面控制器
   */
  public init(animationData?: ScreenOffAnimationViewData, viewController?: BaseViewController): void {
    // ScreenOnOffService.getInstance().registerObserver(this.powerStateChangeListener);
    ScreenOnOffService.getInstance().setCustomAnimation(this);
    this.animationData = animationData;
    this.viewController = viewController;
  }

  /**
   * 释放资源
   */
  public release(): void {
    if (!this.isSupportAni) {
      return;
    }
    ScreenOnOffService.getInstance().unRegisterObserver(this.powerStateChangeListener);
    ScreenOnOffService.getInstance().setCustomAnimation(undefined);
    this.animationData = undefined;
    this.viewController = undefined;
  }

  handleBeginSleep(callback: () => void): void {
    if (!this.animationData || !this.viewController || this.viewController.isShowing()) {
      log.showWarn(TAG, 'handleBeginSleep return');
      callback();
      return;
    }
    this.isReady = false;
    this.finishCallBack = () => {
      log.showInfo(TAG, 'handle finishCallBack');
      callback();
      while (this.waitQueue.length > 0) {
        this.waitQueue.shift()?.();
      }
      this.isReady = true;
      log.showInfo(TAG, 'handle finishCallBack end');
    };
    this.timeoutId = setTimeout(() => {
      log.showWarn(TAG, 'animation timeout');
      this.animationFinish();
    }, TIMEOUT_VALUE);
    this.toggleAnimationView(true);
  }

  async handlePowerEventNext(powerState: string): Promise<void> {
    if (powerState !== PowerState.BEGIN_SLEEP && !this.isReady) {
      await this.waitHandleBeginSleep();
    }
    switch (powerState) {
      case PowerState.BEGIN_SLEEP:
        // 黑掉屏幕
        slStateHelper.getSlBindState().setBlankScreen(true);
        break;
      case PowerState.BEGIN_WAKE_UP:
      case PowerState.BEGIN_DISPLAY_ON:
        slStateHelper.getSlBindState().setBlankScreen(false);
        break;
    }
    log.showInfo(TAG, `handlePowerEventNext powerState: ${powerState}；BlankScreen:${slStateHelper.getSlBindState().getBlankScreen()}`);
  }

  private animationFinish(): void {
    log.showWarn(TAG, 'animationFinish');
    if (this.timeoutId !== DEFAULT_TIMEOUT_ID) {
      clearTimeout(this.timeoutId);
      this.timeoutId = DEFAULT_TIMEOUT_ID;
    }
    if (!this.finishCallBack) {
      return;
    }
    this.finishCallBack();
    this.finishCallBack = undefined;
  }

  private toggleAnimationView(isShow: boolean): void {
    if (!this.animationData || !this.viewController) {
      log.showWarn(TAG, 'animationModel or viewController is undefined');
      return;
    }
    if (this.animationData.isShow === isShow) {
      return;
    }
    this.animationData.isShow = isShow;
    if (isShow) {
      this.viewController.show();
      animateToImmediately({
        duration: ANIMATION_TIME,
        curve: Curve.Smooth,
        onFinish: () => this.animationFinish()
      }, () => {
      });
    } else {
      this.viewController.hide();
    }
  }

  private async waitHandleBeginSleep(): Promise<void> {
    return new Promise((resolve) => {
      this.waitQueue.push(resolve);
    });
  }
}
