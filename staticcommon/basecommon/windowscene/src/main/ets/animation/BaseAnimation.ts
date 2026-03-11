/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import AnimMgr from '@ohos.animator';
import type { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { CommonUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';


const TAG = 'BaseAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 动画插值曲线
 */
export class AnimEasing {
  /**
   * 线性插值器
   */
  static readonly EASING_LINEAR: string = 'linear';

  /**
   * 动画首尾降速插值器
   */
  static readonly EASING_EASE: string = 'ease';

  /**
   * 动画起始降速插值器
   */
  static readonly EASING_EASE_IN: string = 'ease-in';

  /**
   * 动画结束降速插值器
   */
  static readonly EASING_EASE_OUT: string = 'ease-out';

  /**
   * 动画首尾降速插值器
   */
  static readonly EASING_EASE_IN_OUT: string = 'ease-in-out';

  /**
   * 动画起始加速结束降速插值器
   */
  static readonly EASING_FAST_OUT_SLOW_IN: string = 'fast-out-slow-in';

  /**
   * 动画起始线性结束降速插值器
   */
  static readonly EASING_LINEAR_OUT_SLOW_IN: string = 'linear-out-slow-in';

  /**
   * 动画起始加速结束线性插值器
   */
  static readonly EASING_FAST_OUT_LINEAR_IN: string = 'fast-out-linear-in';

  /**
   * 阻尼曲线
   */
  static readonly EASING_FRICTION: string = 'friction';

  /**
   * 极限减速曲线
   */
  static readonly EASING_EXTREME_DECELERATION: string = 'extreme-deceleration';

  /**
   * 锐利曲线
   */
  static readonly EASING_SHARP: string = 'sharp';

  /**
   * 节律曲线
   */
  static readonly EASING_RHYTHM: string = 'rhythm';

  /**
   * 平滑曲线
   */
  static readonly EASING_SMOOTH: string = 'smooth';
}

/**
 * 动画结束后状态
 */
export enum AnimFill {
  /**
   * 动画结束后恢复原位
   */
  FILL_NONE = 'none',

  /**
   * 动画结束后到最终值
   * 取消动画会到最终值，不是取消时的值
   */
  FILL_FORWARDS = 'forwards',

  /**
   * 动画结束后恢复到初始值
   */
  FILL_BACKWARDS = 'backwards'
}

/**
 * 动画执行方向
 */
export enum AnimDirection {
  /**
   * 动画正向执行
   */
  DIRECTION_NORMAL = 'normal',

  /**
   * 动画反向执行
   */
  DIRECTION_REVERSE = 'reverse',

  /**
   * 动画正向交替执行
   */
  DIRECTION_ALTERNATE = 'alternate',

  /**
   * 动画反向交替执行
   */
  DIRECTION_ALTERNATE_REVERSE = 'alternate-reverse'
}

/**
 * 动画帧回调类型
 */
export type AnimFrame = (progress: number) => void;

/**
 * 动画普通回调类型
 */
export type AnimCommon = () => void;

/**
 * 基础动画
 *
 * @since 2022-12-02
 */
export class BaseAnimation {
  /**
   * 动画时长
   * 默认100
   */
  duration: number = 100;

  /**
   * 动画插值曲线
   * 默认线性曲线
   */
  easing: string = AnimEasing.EASING_LINEAR;

  /**
   * 动画延时执行，默认不延时
   */
  delay: number = 0;

  /**
   * 动画结束状态
   * 默认最终值
   */
  fill: AnimFill = AnimFill.FILL_FORWARDS;

  /**
   * 动画执行方向
   * 默认正向执行
   */
  direction: AnimDirection = AnimDirection.DIRECTION_NORMAL;

  /**
   * 动画执行次数
   * 默认执行1次
   */
  iterations: number = 1;

  /**
   * 动画开始进度
   * 默认0
   */
  begin: number = 0;

  /**
   * 动画结束进度
   * 默认1
   */
  end: number = 1.0;

  /**
   * 动画帧回调
   */
  onFrame: AnimFrame;

  /**
   * 动画结束回调
   */
  onFinish: AnimCommon;

  /**
   * 动画取消回调
   */
  onCancel: AnimCommon;

  /**
   * 动画重复执行回调
   */
  onRepeat: AnimCommon;

  /**
   * 是否已经绑定onFrame
   */
  private hasBindOnFrame: boolean = false;

  /**
   * 动画结果
   */
  private animResult: AnimatorResult;

  /**
   * 设置自定义贝塞尔插值器
   *
   * @param x1 点1X
   * @param y1 点1Y
   * @param x2 点2X
   * @param y2 点2Y
   */
  setCubicEasing(x1: number, y1: number, x2: number, y2: number): void {
    this.easing = `cubic-bezier(${x1}, ${y1}, ${x2}, ${y2})`;
  }

  /**
   * 创建动画
   */
  createAnim(): void {
    let options = this.createAnimOptions();
    try {
      this.animResult = AnimMgr.create(options);
      this.animResult.onfinish = this.onFinish;
      this.animResult.oncancel = this.onCancel;
      this.animResult.onrepeat = this.onRepeat;
    } catch (error) {
      log.error('AnimMgr create error', error);
    }
  }

  /**
   * onframe回调需要对应component后绑定
   */
  bindOnFrame(): void {
    if (CommonUtils.isInvalid(this.animResult)) {
      return;
    }
    this.animResult.onframe = this.onFrame;
    this.hasBindOnFrame = true;
  }

  /**
   * 更新动画
   * 已创建动画，参数更新后更新动画
   */
  updateAnim(): void {
    this.animResult?.reset(this.createAnimOptions());
  }

  /**
   * 开启动画
   */
  play(): void {
    this.animResult?.play();
    // 如果没有绑定onFrame，则直接结束动画
    if (!this.hasBindOnFrame) {
      this.finish();
    }
  }

  /**
   * 结束动画
   */
  finish(): void {
    this.animResult?.finish();
  }

  /**
   * 暂停动画
   */
  pause(): void {
    this.animResult?.pause();
  }

  /**
   * 取消动画
   */
  cancel(): void {
    this.animResult?.cancel();
  }

  /**
   * 反转执行动画
   */
  reverse(): void {
    this.animResult?.reverse();
  }

  /**
   * 创建动画参数
   *
   * @return 动画参数
   */
  private createAnimOptions(): AnimatorOptions {
    return {
      duration: this.duration,
      easing: this.easing,
      delay: this.delay,
      fill: this.fill,
      direction: this.direction,
      iterations: this.iterations,
      begin: this.begin,
      end: this.end
    };
  }
}

/**
 * 动画建造者
 */
export class AnimBuilder {
  /**
   * 动画时长
   */
  private duration: number;

  /**
   * 动画插值曲线
   */
  private easing: string;

  /**
   * 动画延时执行
   */
  private delay: number;

  /**
   * 动画结束后状态
   */
  private fill: AnimFill;

  /**
   * 动画执行方向
   */
  private direction: AnimDirection;

  /**
   * 动画执行次数
   */
  private iterations: number;

  /**
   * 动画开始进度
   */
  private begin: number;

  /**
   * 动画结束进度
   */
  private end: number;

  /**
   * 动画帧回调
   */
  private onFrame: AnimFrame;

  /**
   * 动画结束回调
   */
  private onFinish: AnimCommon;

  /**
   * 动画取消回调
   */
  private onCancel: AnimCommon;

  /**
   * 动画重复执行回调
   */
  private onRepeat: AnimCommon;

  /**
   * 设置动画时长
   *
   * @param duration 动画时长
   * @return 链式
   */
  fDuration(duration: number): AnimBuilder {
    this.duration = duration;
    return this;
  }

  /**
   * 设置动画插值曲线
   *
   * @param easing 动画插值曲线
   * @return 链式
   */
  fEasing(easing: string): AnimBuilder {
    this.easing = easing;
    return this;
  }

  /**
   * 设置动画延时执行时长
   *
   * @param delay 动画延时时长
   * @return 链式
   */
  fDelay(delay: number): AnimBuilder {
    this.delay = delay;
    return this;
  }

  /**
   * 设置动画结束时状态
   *
   * @param fill 动画结束时状态
   * @return 链式
   */
  fFill(fill: AnimFill): AnimBuilder {
    this.fill = fill;
    return this;
  }

  /**
   * 设置动画执行方向
   *
   * @param direction 动画执行方向
   * @return 链式
   */
  fDirection(direction: AnimDirection): AnimBuilder {
    this.direction = direction;
    return this;
  }

  /**
   * 设置动画执行次数
   *
   * @param iterations 动画执行次数
   * @return 链式
   */
  fIterations(iterations: number): AnimBuilder {
    this.iterations = iterations;
    return this;
  }

  /**
   * 设置动画开始时进度
   *
   * @param begin 动画开始进度
   * @return 链式
   */
  fBegin(begin: number): AnimBuilder {
    this.begin = begin;
    return this;
  }

  /**
   * 设置动画结束时进度
   *
   * @param begin 动画结束进度
   * @return 链式
   */
  fEnd(end: number): AnimBuilder {
    this.end = end;
    return this;
  }

  /**
   * 设置动画帧回调
   *
   * @param onFrame 动画帧回调
   * @return 链式
   */
  fOnFrame(onFrame: AnimFrame): AnimBuilder {
    this.onFrame = onFrame;
    return this;
  }

  /**
   * 设置动画结束回调
   *
   * @param onFrame 动画结束回调
   * @return 链式
   */
  fOnFinish(onFinish: AnimCommon): AnimBuilder {
    this.onFinish = onFinish;
    return this;
  }

  /**
   * 设置动画取消回调
   *
   * @param onFrame 动画取消回调
   * @return 链式
   */
  fOnCancel(onCancel: AnimCommon): AnimBuilder {
    this.onCancel = onCancel;
    return this;
  }

  /**
   * 设置动画重复执行回调
   *
   * @param onFrame 动画重复执行回调
   * @return 链式
   */
  fOnRepeat(onRepeat: AnimCommon): AnimBuilder {
    this.onRepeat = onRepeat;
    return this;
  }

  /**
   * 构建动画
   *
   * @return 动画
   */
  build(): BaseAnimation {
    let anim = new BaseAnimation();
    if (!CommonUtils.isInvalid(this.duration)) {
      anim.duration = this.duration;
    }
    if (!CommonUtils.isInvalid(this.easing)) {
      anim.easing = this.easing;
    }
    if (!CommonUtils.isInvalid(this.delay)) {
      anim.delay = this.delay;
    }
    if (!CommonUtils.isInvalid(this.fill)) {
      anim.fill = this.fill;
    }
    if (!CommonUtils.isInvalid(this.direction)) {
      anim.direction = this.direction;
    }
    if (!CommonUtils.isInvalid(this.iterations)) {
      anim.iterations = this.iterations;
    }
    if (!CommonUtils.isInvalid(this.begin)) {
      anim.begin = this.begin;
    }
    if (!CommonUtils.isInvalid(this.end)) {
      anim.end = this.end;
    }
    if (!CommonUtils.isInvalid(this.onFrame)) {
      anim.onFrame = this.onFrame;
    }
    if (!CommonUtils.isInvalid(this.onFinish)) {
      anim.onFinish = this.onFinish;
    }
    if (!CommonUtils.isInvalid(this.onCancel)) {
      anim.onCancel = this.onCancel;
    }
    if (!CommonUtils.isInvalid(this.onRepeat)) {
      anim.onRepeat = this.onRepeat;
    }
    anim.createAnim();
    return anim;
  }
}