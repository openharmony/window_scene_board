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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { AnimationCurves } from './AnimationCurves';
import { AnimationNames } from './AnimationNames';

const TAG = 'AnimationBase';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface AnimateParams {
  delay?: number;
  duration?: number;
  iterations?: number;
  curve?: Curve | string | ICurve;
  playMode?: PlayMode;
  finishCallbackFast?: boolean;
  onFinish?: () => void;
  event: () => void;
  expectedFrameRateRange?: ExpectedFrameRateRange;
}

// 强制标脏
declare function __updateDirty2Immediately_V2_Change_Observation(): void;

/**
 * 动效框架
 * 支持设置动画、启动动画、停止动画、设置动画生命周期等
 *
 * @since 2024-08-02
 */
export class AnimationBase {
  public static readonly NAMES = AnimationNames;

  public static readonly CURVES = AnimationCurves;

  /**
   * 动画名称
   */
  private name: AnimationNames;
  /**
   * 带参数的动画名称
   */
  private nameWithParams: string;
  /**
   * 是否异步执行动效
   */
  private isNeedSetTimeout: boolean;
  /**
   * 动效合集
   */
  private animationMap: Map<string, AnimateParams[]> = new Map();
  /**
   * 表示动画次数
   */
  private animationId = 0;
  /**
   * 正在执行的动效计数
   */
  private animatingCount = 0;
  /**
   * 强制标脏
   */
  private updateDirty?: boolean;

  constructor(name: AnimationNames, needSetTimeout?: boolean, updateDirty?: boolean) {
    this.name = name;
    this.nameWithParams = this.name;
    this.isNeedSetTimeout = !!needSetTimeout
    this.updateDirty = updateDirty;
  }

  /**
   * 设置动画开始前的初始状态
   * @param callback
   */
  public setInitialState(callback: () => void): void {
    animateToImmediately({ duration: 0 }, callback);
  }

  /**
   * 启动动画
   * @param nameParams 动画名称参数
   */
  public async startAnimation(nameParams?: string, timeout: number = 2000): Promise<void> {
    if (nameParams) {
      this.nameWithParams = `${this.name}[${nameParams}][${this.animationId++}]`;
    } else {
      this.nameWithParams = `${this.name}[${this.animationId++}]`;
    }
    const animateName = this.nameWithParams;

    TraceUtil.startTrace(DomainName.SYS_UI, this.nameWithParams);
    log.showInfo(`Start animation: ${animateName}`);
    this.beforeAnimation();

    let timerId: number | undefined;
    await new Promise<void>((resolve) => {
      if (this.isNeedSetTimeout) {
        setTimeout(() => {
          this.doAnimation(resolve);
        }, 0);
      } else {
        this.doAnimation(resolve);
      }
      timerId = setTimeout(resolve, timeout);
    });

    clearTimeout(timerId);
    this.afterAnimation();
    log.showInfo(`Finish animation: ${animateName}`);
    TraceUtil.endTrace(DomainName.SYS_UI, this.nameWithParams);
  }

  /**
   * 启动动画-同步
   * @param nameParams 动画名称参数
   */
  public startAnimationSync(nameParams?: string): void {
    if (nameParams) {
      this.nameWithParams = `${this.name}[${nameParams}][${this.animationId++}]`;
    } else {
      this.nameWithParams = `${this.name}[${this.animationId++}]`;
    }
    const animateName = this.nameWithParams;

    TraceUtil.startTrace(DomainName.SYS_UI, this.nameWithParams);
    log.showInfo(`Start animation sync: ${animateName}`);
    this.beforeAnimation();
    this.doAnimation(() => {});
    this.afterAnimation();
    log.showInfo(`Finish animation sync: ${animateName}`);
    TraceUtil.endTrace(DomainName.SYS_UI, this.nameWithParams);
  }

  /**
   * 停止动画
   *
   * @param cancelAnimationFunc 停止动画需要做的操作
   */
  public stopAnimation(cancelAnimationFunc: () => void, expectedFrameRateRange?: ExpectedFrameRateRange): void {
    animateTo({ duration: 0, curve: Curve.Linear, expectedFrameRateRange: expectedFrameRateRange }, () => {
      cancelAnimationFunc();
    });
  }

  /**
   * 执行动画，适合每次动画参数都不一样的场景
   * @returns
   */
  public async executeAnimation(animations: AnimateParams[], nameParams?: string, timeout?: number): Promise<void> {
    this.clearAnimations();
    if (!animations || animations.length === 0) {
      return;
    }
    this.addAnimation(animations);
    await this.startAnimation(nameParams, timeout);
    if (this.animatingCount === 0) {
      this.clearAnimations();
    }
  }

  /**
   * 执行动画，适合每次动画参数都不一样的场景-同步
   * @returns
   */
  public executeAnimationSync(animations: AnimateParams[], nameParams?: string): void {
    this.clearAnimations();
    if (!animations || animations.length === 0) {
      return;
    }
    this.addAnimation(animations);
    this.startAnimationSync(nameParams);
    if (this.animatingCount === 0) {
      this.clearAnimations();
    }
  }

  /**
   * 清除所有动画
   */
  public clearAnimations(): void {
    this.animationMap.clear();
  }

  /**
   * 动画执行前操作
   */
  protected beforeAnimation(): void {
    this.animatingCount ++;
  }

  /**
   * 动画执行后操作
   */
  protected afterAnimation(): void {
    this.animatingCount --;
  }

  /**
   * 添加动效
   * 如果动效时长、延迟时间等动效参数一致则将动效合并
   *
   * @param animations 动效列表
   */
  protected addAnimation(animations: AnimateParams[]): void {
    animations?.forEach((animation) => {
      if (!animation) {
        return;
      }
      const key = this.getAnimationKey(animation);
      let animateParams = this.animationMap.get(key);
      if (!animateParams) {
        animateParams = [];
      }
      animateParams.push(animation);
      this.animationMap.set(key, animateParams);
    });
  }

  /**
   * 执行动画
   * @returns
   */
  private doAnimation(resolve: () => void): void {
    let animationCount: number = this.animationMap.size;
    if (!animationCount) {
      log.showWarn('No animation to execute');
      resolve();
      return;
    }
    // delay越大的动画越晚创建，规避arkUI底层bug
    Array.from(this.animationMap.values())
      .sort((animationA, animationB) => (animationA[0]?.delay ?? 0) - (animationB[0]?.delay ?? 0))
      .forEach((animations) => {
      if (!animations) {
        return;
      }
      if (this.updateDirty && typeof __updateDirty2Immediately_V2_Change_Observation === 'function') {
        __updateDirty2Immediately_V2_Change_Observation();
      }
      animateTo({
        duration: animations[0]?.duration,
        curve: animations[0]?.curve,
        iterations: animations[0]?.iterations,
        playMode: animations[0]?.playMode,
        delay: animations[0]?.delay,
        finishCallbackType: animations[0]?.finishCallbackFast ? FinishCallbackType.LOGICALLY : undefined,
        expectedFrameRateRange: animations[0]?.expectedFrameRateRange,
        onFinish: () => {
          animationCount--;
          if (animationCount === 0) {
            resolve();
          }
          this.executeFinishFunc(animations);
        },
      }, () => {
        animations.forEach((animation) => {
          animation?.event();
        });
        if (this.updateDirty && typeof __updateDirty2Immediately_V2_Change_Observation === 'function') {
          __updateDirty2Immediately_V2_Change_Observation();
        }
      });
    });
  }

  private executeFinishFunc(animations: AnimateParams[]): void {
    animations.forEach((animation) => {
      if (animation?.onFinish) {
        animation.onFinish();
      }
    });
  }

  private getAnimationKey(animation: AnimateParams): string {
    return animation.delay + '_' + animation.duration + '_' + animation.iterations + '_' +
    this.getAnimationCurveString(animation) + '_' + animation.playMode;
  }

  private getAnimationCurveString(animation: AnimateParams): string {
    if (!animation.curve) {
      return '';
    }
    if (typeof animation.curve === 'string') {
      return animation.curve;
    }
    return animation.curve['__curveString'];
  }
}