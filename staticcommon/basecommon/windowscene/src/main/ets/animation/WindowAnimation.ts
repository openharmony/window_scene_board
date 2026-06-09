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

import { AnimBuilder } from './BaseAnimation';
import type { BaseAnimation, AnimCommon } from './BaseAnimation';
import { CommonUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';

import type Window from '@ohos.window';

const TAG = 'WindowAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 窗口动画类型
 */
export enum WinAnimType {
  /**
   * 窗口动画类型，show
   */
  TYPE_SHOW = 1,

  /**
   * 窗口动画类型，hide
   */
  TYPE_HIDE = 2
}

/**
 * 窗口动画结束回调
 */
export type WinAnimFinish = (isCancel: boolean) => void;

/**
 * 窗口动画参数
 */
export class WinAnimOptions {
  /**
   * 窗口透明度
   */
  opacity?: number;

  /**
   * 窗口缩放度
   */
  scale?: Window.ScaleOptions;

  /**
   * 窗口旋转角度
   */
  rotate?: Window.RotateOptions;

  /**
   * 窗口位移位置
   */
  translate?: Window.TranslateOptions;
}

/**
 * 动画前后半段类型
 */
enum InnerAnimType {
  /**
   * 窗口前一半动画
   */
  TYPE_FRONT = 1,

  /**
   * 窗口后一半动画
   */
  TYPE_AFTER = 2
}

/**
 * 动画帧数进度回调
 */
type InnerAnimFrame = (innerType: InnerAnimType, progress: number) => void;

/**
 * 窗口动画，show/hide
 */
class WinSubAnim {
  /**
   * 动画整体时长
   */
  private oriDuration: number;

  /**
   * 动画延迟时间
   */
  private delay: number;

  /**
   * 动画曲线
   */
  private easing: string;

  /**
   * 动画中间值占比值
   * (取值： 0~1)
   */
  private midPercent: number;

  /**
   * 锚点X
   */
  private pivotX: number;

  /**
   * 锚点Y
   */
  private pivotY: number;

  /**
   * 动画原始起始值
   */
  private oriBeginOptions: WinAnimOptions;

  /**
   * 动画原始中间值
   */
  private oriMidOptions: WinAnimOptions;

  /**
   * 动画原始结束值
   */
  private oriEndOptions: WinAnimOptions;

  /**
   * 动画集，区分前后半段
   * 前后动画类型 => 动画
   */
  private innerAnims: Map<InnerAnimType, BaseAnimation>;

  /**
   * 动画起始值，区分前后半段
   * 前后动画类型 => 动画参数值
   */
  private innerBeginOptions: Map<InnerAnimType, WinAnimOptions>;

  /**
   * 动画结束值，区分前后半段
   * 前后动画类型 => 动画参数值
   */
  private innerEndOptions: Map<InnerAnimType, WinAnimOptions>;

  /**
   * 动画帧数回调，区分前后半段
   */
  private onFrame: InnerAnimFrame;

  /**
   * 动画结束回调，整体结束后回调
   */
  private onFinish: AnimCommon;

  /**
   * 动画取消回调，整体取消
   */
  private onCancel: AnimCommon;

  /**
   * 动画是否正在执行
   */
  private isRunning: boolean = false;

  /**
   * 构造
   *
   * @param onFrame 动画帧回调
   * @param onFinish 动画结束回调
   * @param onCancel 动画取消回调
   */
  constructor(onFrame: InnerAnimFrame, onFinish: AnimCommon, onCancel: AnimCommon) {
    this.onFrame = onFrame;
    this.onFinish = onFinish;
    this.onCancel = onCancel;
    this.innerAnims = new Map();
    this.innerBeginOptions = new Map();
    this.innerEndOptions = new Map();
  }

  /**
   * 设置动画时长
   *
   * @param duration 动画时长
   */
  setAnimDuration(duration: number): void {
    this.oriDuration = duration;
    this.updateInnerDuration();
  }

  /**
   * 设置动画延迟
   *
   * @param delay 动画时长
   */
  setAnimDelay(delay: number): void {
    this.delay = delay;
    this.updateInnerDelay();
  }

  /**
   * 设置动画曲线
   *
   * @param delay 动画时长
   */
  setEasing(easing: string): void {
    this.easing = easing;
    this.updateInnerErasing();
  }

  /**
   * 更新动画执行延迟(延迟只需要加在前段动画即可)
   */
  private updateInnerDelay(): void {
    // 无时长
    if (CommonUtils.isInvalid(this.delay)) {
      return;
    }
    this.updateDelay(InnerAnimType.TYPE_FRONT, this.delay);
  }

  /**
   * 更新动画曲线
   */
  private updateInnerErasing(): void {
    // 设置动画曲线
    if (CommonUtils.isEmpty(this.easing)) {
      return;
    }
    this.updateEasing(InnerAnimType.TYPE_FRONT, this.easing);
    this.updateEasing(InnerAnimType.TYPE_AFTER, this.easing);
  }

  /**
   * 设置动画初始值
   *
   * @param beginOptions 初始值
   */
  setBeginOptions(beginOptions: WinAnimOptions): void {
    this.oriBeginOptions = beginOptions;
    this.updateInnerOptions();
    this.updateInnerAnim();
    this.updateInnerDuration();
    this.updateInnerErasing();
    this.updateInnerDelay();
    this.updateInnerPivot();
  }

  /**
   * 设置动画结束值
   *
   * @param endOptions 结束值
   */
  setEndOptions(endOptions: WinAnimOptions): void {
    this.oriEndOptions = endOptions;
    this.updateInnerOptions();
    this.updateInnerAnim();
    this.updateInnerDuration();
    this.updateInnerErasing();
    this.updateInnerDelay();
    this.updateInnerPivot();
  }

  /**
   * 设置动画中间值
   *
   * @param endOptions 中间值
   */
  setMidOptions(midOptions: WinAnimOptions, midPercent: number): void {
    this.oriMidOptions = midOptions;
    this.midPercent = midPercent;
    this.updateInnerOptions();
    this.updateInnerAnim();
    this.updateInnerDuration();
    this.updateInnerErasing();
    this.updateInnerDelay();
    this.updateInnerPivot();
  }

  /**
   * 动画起始真实值
   *
   * @param innerType 动画段类型
   */
  getInnerBeginOptions(innerType: InnerAnimType): WinAnimOptions {
    return this.innerBeginOptions.get(innerType);
  }

  /**
   * 动画结束真实值
   *
   * @param innerType 动画段类型
   */
  getInnerEndOptions(innerType: InnerAnimType): WinAnimOptions {
    return this.innerEndOptions.get(innerType);
  }

  /**
   * 更新锚点
   *
   * @param pivotX X锚点
   * @param pivotY Y锚点
   */
  updatePivot(pivotX: number, pivotY: number): void {
    this.pivotX = pivotX;
    this.pivotY = pivotY;
    this.updateInnerPivot();
  }

  /**
   * 开始绑定onFrame
   */
  startBindOnFrame(): void {
    this.innerAnims?.forEach((anim) => {
      anim.bindOnFrame();
    });
  }

  /**
   * 动画是否正在执行
   *
   * @return true执行
   */
  isAnimRunning(): boolean {
    return this.isRunning;
  }

  /**
   * 动画执行前准备
   * 主要设置前段动画时长及起始位置
   *
   * @param begin 起始值
   */
  prepareStartAnim(begin: number): void {
    if (CommonUtils.isInvalid(begin)) {
      begin = 0;
    }
    // 前半段动画总时长
    let frontDuration = CommonUtils.isInvalid(this.midPercent) ? this.oriDuration : this.oriDuration * this.midPercent;
    let frontAnim = this.innerAnims.get(InnerAnimType.TYPE_FRONT);
    if (CommonUtils.isInvalid(frontAnim)) {
      return;
    }
    frontAnim.duration = frontDuration * (1.0 - begin);
    frontAnim.begin = begin;
    frontAnim.updateAnim();
  }

  /**
   * 开始执行动画
   */
  play(): void {
    // 标记开始动画
    this.isRunning = true;
    this.innerAnims.get(InnerAnimType.TYPE_FRONT)?.play();
  }

  /**
   * 取消动画执行
   */
  cancel(): void {
    this.innerAnims?.get(InnerAnimType.TYPE_FRONT)?.cancel();
    this.innerAnims?.get(InnerAnimType.TYPE_AFTER)?.cancel();
  }

  /**
   * 更新动画实例
   */
  private updateInnerAnim(): void {
    // 参数值不齐
    if (CommonUtils.isInvalid(this.oriBeginOptions) || CommonUtils.isInvalid(this.oriEndOptions)) {
      return;
    }
    let frontType = InnerAnimType.TYPE_FRONT;
    let afterType = InnerAnimType.TYPE_AFTER;
    // 无中间值，一段动画
    if (CommonUtils.isInvalid(this.oriMidOptions)) {
      this.innerAnims.delete(afterType);
      this.createAnim(frontType);
      return;
    }
    // 有中间值，两段动画
    this.createAnim(frontType);
    this.createAnim(afterType);
  }

  /**
   * 更新动画参数值
   */
  private updateInnerOptions(): void {
    this.innerBeginOptions.clear();
    this.innerEndOptions.clear();
    // 无始末参数值
    if (CommonUtils.isInvalid(this.oriBeginOptions) || CommonUtils.isInvalid(this.oriEndOptions)) {
      return;
    }
    // 区别有无后半段动画
    if (CommonUtils.isInvalid(this.oriMidOptions)) {
      this.innerBeginOptions.set(InnerAnimType.TYPE_FRONT, this.oriBeginOptions);
      this.innerEndOptions.set(InnerAnimType.TYPE_FRONT, this.oriEndOptions);
    } else {
      this.innerBeginOptions.set(InnerAnimType.TYPE_FRONT, this.oriBeginOptions);
      this.innerBeginOptions.set(InnerAnimType.TYPE_AFTER, this.oriMidOptions);
      this.innerEndOptions.set(InnerAnimType.TYPE_FRONT, this.oriMidOptions);
      this.innerEndOptions.set(InnerAnimType.TYPE_AFTER, this.oriEndOptions);
    }
  }

  /**
   * 更新锚点
   */
  private updateInnerPivot(): void {
    if (CommonUtils.isInvalid(this.pivotX) && CommonUtils.isInvalid(this.pivotY)) {
      return;
    }
    this.updateOptionsPivot(this.oriBeginOptions);
    this.updateOptionsPivot(this.oriMidOptions);
    this.updateOptionsPivot(this.oriEndOptions);
  }

  /**
   * 更新锚点
   *
   * @param options 参数
   */
  private updateOptionsPivot(options: WinAnimOptions): void {
    if (CommonUtils.isInvalid(options)) {
      return;
    }
    if (!CommonUtils.isInvalid(options.rotate)) {
      options.rotate.pivotX = this.pivotX;
      options.rotate.pivotY = this.pivotY;
    }
    if (!CommonUtils.isInvalid(options.scale)) {
      options.scale.pivotX = this.pivotX;
      options.scale.pivotY = this.pivotY;
    }
  }

  /**
   * 更新动画时长
   */
  private updateInnerDuration(): void {
    // 无时长
    if (CommonUtils.isInvalid(this.oriDuration)) {
      return;
    }
    let frontDuration = 0;
    let afterDuration = 0;
    // 无中间值
    if (CommonUtils.isInvalid(this.midPercent) || CommonUtils.equals(this.midPercent, 0)) {
      frontDuration = this.oriDuration;
    } else { // 中间值，切割
      frontDuration = this.oriDuration * this.midPercent;
      afterDuration = this.oriDuration - frontDuration;
    }
    // 设置动画时长
    this.updateDuration(InnerAnimType.TYPE_FRONT, frontDuration);
    this.updateDuration(InnerAnimType.TYPE_AFTER, afterDuration);
  }

  /**
   * 更新动画时长
   *
   * @param innerType 动画段类型
   * @param duration 动画时长
   */
  private updateDuration(innerType: InnerAnimType, duration: number): void {
    if (CommonUtils.isInvalid(duration)) {
      return;
    }
    let frontAnm = this.innerAnims.get(innerType);
    if (!CommonUtils.isInvalid(frontAnm) && !CommonUtils.equals(duration, 0)) {
      frontAnm.duration = duration;
      frontAnm.updateAnim();
    }
  }

  private updateDelay(innerType: InnerAnimType, delay: number): void {
    if (CommonUtils.isInvalid(delay)) {
      return;
    }
    let frontAnm = this.innerAnims.get(innerType);
    if (!CommonUtils.isInvalid(frontAnm) && !CommonUtils.equals(delay, 0)) {
      frontAnm.delay = delay;
      frontAnm.updateAnim();
    }
  }

  private updateEasing(innerType: InnerAnimType, easing: string): void {
    if (CommonUtils.isEmpty(easing)) {
      return;
    }
    let frontAnm = this.innerAnims.get(innerType);
    if (!CommonUtils.isInvalid(frontAnm)) {
      frontAnm.easing = easing;
      frontAnm.updateAnim();
    }
  }

  /**
   * 创建动画实例
   *
   * @param innerType 动画段类型
   */
  private createAnim(innerType: InnerAnimType): void {
    if (!CommonUtils.isInvalid(this.innerAnims.get(innerType))) {
      return;
    }
    let anim = new AnimBuilder()
      .fOnFrame(this.onInnerFrame.bind(this, innerType))
      .fOnCancel(this.onInnerCancel.bind(this, innerType))
      .fOnFinish(this.onInnerFinish.bind(this, innerType))
      .build();
    this.innerAnims.set(innerType, anim);
  }

  /**
   * 某一段动画帧数回调
   *
   * @param innerType 动画段类型
   * @param progress 进度
   */
  private onInnerFrame(innerType: InnerAnimType, progress: number): void {
    if (CommonUtils.isInvalid(this.onFrame)) {
      return;
    }
    this.onFrame(innerType, progress);
  }

  /**
   * 某一段动画取消回调
   *
   * @param innerType 动画段类型
   */
  private onInnerCancel(innerType: InnerAnimType): void {
    this.isRunning = false;
    if (CommonUtils.isInvalid(this.onCancel)) {
      return;
    }
    this.onCancel();
  }

  /**
   * 某一段动画结束回调
   *
   * @param innerType 动画段类型
   */
  private onInnerFinish(innerType: InnerAnimType): void {
    // 前段动画结束时，判断是否开启后段动画
    let afterAnim = this.innerAnims.get(InnerAnimType.TYPE_AFTER);
    if (innerType === InnerAnimType.TYPE_FRONT && !CommonUtils.isInvalid(afterAnim)) {
      afterAnim.play();
      return;
    }
    // 回调动画已结束
    this.isRunning = false;
    if (CommonUtils.isInvalid(this.onFinish)) {
      return;
    }
    this.onFinish();
  }
}

/**
 * 窗口show/hide动画
 *
 * @since 2022-12-04
 */
export class WindowAnimation {
  /**
   * 窗口
   */
  private window: Window.Window;

  /**
   * 当前窗口属性值
   */
  private curAnimOptions: WinAnimOptions;

  /**
   * 取消动画时窗口属性值
   */
  private cancelAnimOptions: WinAnimOptions;

  /**
   * 窗口动画集
   * 窗口动画类型 => 窗口动画
   */
  private subAnims: Map<WinAnimType, WinSubAnim>;

  /**
   * 窗口动画结束回调集
   */
  private animFinish: Map<WinAnimType, Set<WinAnimFinish>>;

  /**
   * 是否为动画打断场景
   */
  private isAnimInterrupt: boolean = false;

  /**
   * 构造
   *
   * @param window 窗口
   */
  constructor(window: Window.Window) {
    this.window = window;
    this.animFinish = new Map();
    this.subAnims = new Map();
    let typeShow = WinAnimType.TYPE_SHOW;
    this.subAnims.set(typeShow, new WinSubAnim(
      this.onFrame.bind(this, typeShow),
      this.onFinish.bind(this, typeShow),
      this.onCancel.bind(this, typeShow)
    ));
    let typeHide = WinAnimType.TYPE_HIDE;
    this.subAnims.set(typeHide, new WinSubAnim(
      this.onFrame.bind(this, typeHide),
      this.onFinish.bind(this, typeHide),
      this.onCancel.bind(this, typeHide)
    ));
  }

  /**
   * 更新窗口
   *
   * @param window 窗口
   */
  updateWindow(window: Window.Window): void {
    this.window = window;
  }

  /**
   * 设置动画时长
   *
   * @param animType 动画类型
   * @param duration 动画时长
   */
  setDuration(animType: WinAnimType, duration: number): WindowAnimation {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return this;
    }
    subAnim.setAnimDuration(duration);
    return this;
  }

  /**
   * 设置动画延迟
   *
   * @param animType 动画类型
   * @param delay 动画时长
   */
  setDelay(animType: WinAnimType, delay: number): WindowAnimation {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return this;
    }
    subAnim.setAnimDelay(delay);
    return this;
  }

  /**
   * 设置动画曲线
   *
   * @param animType 动画类型
   * @param easing 动画曲线
   */
  setEasing(animType: WinAnimType, easing: string): WindowAnimation {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return this;
    }
    subAnim.setEasing(easing);
    return this;
  }

  /**
   * 设置动画开始值
   *
   * @param animType 动画类型
   * @param beginOptions 开始值
   */
  setBeginOptions(animType: WinAnimType, beginOptions: WinAnimOptions): WindowAnimation {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return this;
    }
    subAnim.setBeginOptions(beginOptions);
    return this;
  }

  /**
   * 设置动画结束值
   *
   * @param animType 动画类型
   * @param endOptions 结束值
   */
  setEndOptions(animType: WinAnimType, endOptions: WinAnimOptions): WindowAnimation {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return this;
    }
    subAnim.setEndOptions(endOptions);
    return this;
  }

  /**
   * 设置动画中间值
   *
   * @param animType 动画类型
   * @param midOptions 中间值
   * @param midPercent 中间值占比（取值0~1）
   */
  setMidOptions(animType: WinAnimType, midOptions: WinAnimOptions, midPercent: number): WindowAnimation {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return this;
    }
    subAnim.setMidOptions(midOptions, midPercent);
    return this;
  }

  /**
   * 更新动画锚点
   * 缩放/旋转涉及
   *
   * @param pivotX
   * @param pivotY
   */
  updateAnimPivot(pivotX: number, pivotY: number): void {
    this.subAnims.forEach((subAnim) => {
      subAnim.updatePivot(pivotX, pivotY);
    });
  }

  /**
   * 开始绑定onFrame回调
   */
  startBindOnFrame(): void {
    this.subAnims.forEach((subAnim) => {
      subAnim.startBindOnFrame();
    });
  }

  /**
   * 动画是否正在执行
   *
   * @param animType 动画类型
   */
  isRunning(animType: WinAnimType): boolean {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return false;
    }
    return subAnim.isAnimRunning();
  }

  /**
   * 动画show窗口
   *
   * @param onFinish 动画结束回调
   * @param isInterrupt 是否打断隐藏动画
   */
  showAnim(onFinish: WinAnimFinish, isInterrupt?: boolean): void {
    let typeShow = WinAnimType.TYPE_SHOW;
    // 判断正在show，不做处理
    if (this.isRunning(typeShow)) {
      return;
    }
    // 缓存回调
    this.putAnimFinish(typeShow, onFinish);

    if (isInterrupt) {
      // 取消hide动画，标记动画打断场景
      this.isAnimInterrupt = true;
      this.cancelAnim(WinAnimType.TYPE_HIDE);
      this.isAnimInterrupt = false;
    }

    // 根据是否取消动画来设置动画的起始值
    this.prepareStartAnim(typeShow);
    // 开启动画
    this.startAnim(typeShow);
  }

  /**
   * 动画hide窗口
   *
   * @param onFinish 动画结束回调
   * @parame isInterrupt 是否不打断原有动画
   */
  hideAnim(onFinish: WinAnimFinish, isInterrupt?: boolean): void {
    let typeHide = WinAnimType.TYPE_HIDE;
    // 判断正在hide，不做处理
    if (this.isRunning(typeHide)) {
      return;
    }
    // 缓存回调
    this.putAnimFinish(typeHide, onFinish);
    if (isInterrupt) {
      // 取消show动画，标记动画打断场景
      this.isAnimInterrupt = true;
      this.cancelAnim(WinAnimType.TYPE_SHOW);
      this.isAnimInterrupt = false;
    }
    // 根据是否取消动画来设置动画的起始值
    this.prepareStartAnim(typeHide);
    // 开启动画
    this.startAnim(typeHide);
  }

  /**
   * 取消动画
   *
   * @param animType 动画类型
   */
  cancelAnim(animType: WinAnimType): void {
    if (!this.isRunning(animType)) {
      return;
    }
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return;
    }
    // 记录取消
    this.flagCancelOptions(true);
    subAnim.cancel();
  }

  /**
   * 动画开启前准备工作
   * 根据是否有取消参数进行计算起始参数
   *
   * @param animType 动画类型
   */
  private prepareStartAnim(animType: WinAnimType): void {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return;
    }
    let opacity = this.cancelAnimOptions?.opacity;
    // 没有取消参数，直接采用原始参数
    if (CommonUtils.isInvalid(this.cancelAnimOptions) || CommonUtils.isInvalid(opacity)) {
      subAnim.prepareStartAnim(0);
      return;
    }
    // 有取消参数，以窗口透明度计算进度
    // 取消时hide动画，则show时起始进度为opacity；取消时show动画，则hide时起始进度为(1 - opacity)
    let begin = animType === WinAnimType.TYPE_SHOW ? opacity : (1.0 - opacity);
    subAnim.prepareStartAnim(begin);
  }

  /**
   * 开始执行动画
   *
   * @param animType 动画类型
   */
  private startAnim(animType: WinAnimType): void {
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      this.callbackFinish(animType);
      return;
    }
    // 开启动画，清除取消记录
    this.flagCancelOptions(false);
    subAnim.play();
  }

  /**
   * 动画帧回调
   *
   * @param animType 动画类型
   * @param progress 动画进度
   */
  private onFrame(animType: WinAnimType, innerType: InnerAnimType, progress: number): void {
    // 存在取消场景时，保持取消时状态
    log.showDebug(`progress:${progress} innerType:${innerType} animType:${animType}`);
    if (!CommonUtils.isInvalid(this.cancelAnimOptions)) {
      return;
    }
    let subAnim = this.subAnims.get(animType);
    if (CommonUtils.isInvalid(subAnim)) {
      return;
    }
    let beginOptions = subAnim.getInnerBeginOptions(innerType);
    let endOptions = subAnim.getInnerEndOptions(innerType);

    // 计算窗口透明度
    this.setWindowOpacity(beginOptions, endOptions, progress);
    // 计算窗口缩放
    this.setWindowScale(beginOptions, endOptions, progress);
    // 计算窗口旋转
    this.setWindowRotate(beginOptions, endOptions, progress);
    // 计算窗口位移
    this.setWindowTran(beginOptions, endOptions, progress);
  }

  /**
   * 动画结束回调
   *
   * @param animType 动画类型
   */
  private onFinish(animType: WinAnimType): void {
    // 标记动画已结束
    this.flagAnimFinish(animType);
  }

  /**
   * 动画取消回调
   *
   * @param animType 动画类型
   */
  private onCancel(animType: WinAnimType): void {
    // 标记动画已结束
    this.flagAnimFinish(animType);
  }

  /**
   * 设置窗口透明度
   *
   * @param beginOptions 起始值
   * @param endOptions 结束值
   * @param progress 进度
   */
  private setWindowOpacity(beginOptions: WinAnimOptions, endOptions: WinAnimOptions, progress: number): void {
    // 计算窗口透明度
    let curOpacity = this.calCurrentAttr(beginOptions?.opacity, endOptions?.opacity, progress);
    if (!CommonUtils.isInvalid(curOpacity)) {
      this.getOrCreateCurOptions().opacity = curOpacity;
      if (this.window === null || this.window === undefined) {
        log.showError('setWindowOpacity  window is null or undefined');
        return;
      }
      try {
        this.window?.opacity(curOpacity);
      } catch (err) {
        log.showError('setWindowOpacity', curOpacity, err);
      }
    }
  }

  /**
   * 设置窗口缩放度
   *
   * @param beginOptions 起始值
   * @param endOptions 结束值
   * @param progress 进度
   */
  private setWindowScale(beginOptions: WinAnimOptions, endOptions: WinAnimOptions, progress: number): void {
    let scaleX = this.calCurrentAttr(beginOptions?.scale?.x, endOptions?.scale?.x, progress);
    let scaleY = this.calCurrentAttr(beginOptions?.scale?.y, endOptions?.scale?.y, progress);
    if (!CommonUtils.isInvalid(scaleX) || !CommonUtils.isInvalid(scaleY)) {
      let curScale: Window.ScaleOptions = {
        pivotX: beginOptions?.scale?.pivotX,
        pivotY: beginOptions?.scale?.pivotY,
        x: scaleX,
        y: scaleY
      };
      this.getOrCreateCurOptions().scale = curScale;
      if (this.window === null || this.window === undefined) {
        log.showError('setWindowScale  window is null or undefined');
        return;
      }
      try {
        this.window?.scale(curScale);
      } catch (err) {
        log.showError('setWindowScale', curScale.x, curScale.y, curScale.pivotX, curScale.pivotY, err);
      }
    }
  }

  /**
   * 设置窗口旋转角度
   *
   * @param beginOptions 起始值
   * @param endOptions 结束值
   * @param progress 进度
   */
  private setWindowRotate(beginOptions: WinAnimOptions, endOptions: WinAnimOptions, progress: number): void {
    if (CheckEmptyUtils.isEmpty(beginOptions) || CheckEmptyUtils.isEmpty(endOptions)) {
      return;
    }
    let rotateX = this.calCurrentAttr(beginOptions.rotate?.x, endOptions.rotate?.x, progress);
    let rotateY = this.calCurrentAttr(beginOptions.rotate?.y, endOptions.rotate?.y, progress);
    let rotateZ = this.calCurrentAttr(beginOptions.rotate?.z, endOptions.rotate?.z, progress);
    if (!CommonUtils.isInvalid(rotateX) || !CommonUtils.isInvalid(rotateY) || !CommonUtils.isInvalid(rotateZ)) {
      let curRotate: Window.RotateOptions = {
        pivotX: beginOptions.rotate?.pivotX,
        pivotY: beginOptions.rotate?.pivotY,
        x: rotateX,
        y: rotateY,
        z: rotateZ
      };
      this.getOrCreateCurOptions().rotate = curRotate;
      if (this.window === null || this.window === undefined) {
        log.showError('setWindowRotate  window is null or undefined');
        return;
      }
      try {
        this.window?.rotate(curRotate);
      } catch (err) {
        log.showError('setWindowRotate', curRotate.pivotX, curRotate.pivotY, curRotate.x, curRotate.y, curRotate.z, err);
      }
    }
  }

  /**
   * 设置窗口位移
   *
   * @param beginOptions 起始值
   * @param endOptions 结束值
   * @param progress 进度
   */
  private setWindowTran(beginOptions: WinAnimOptions, endOptions: WinAnimOptions, progress: number): void {
    let tranX = this.calCurrentAttr(beginOptions?.translate?.x, endOptions?.translate?.x, progress);
    let tranY = this.calCurrentAttr(beginOptions?.translate?.y, endOptions?.translate?.y, progress);
    let tranZ = this.calCurrentAttr(beginOptions?.translate?.z, endOptions?.translate?.z, progress);
    if (!CommonUtils.isInvalid(tranX) || !CommonUtils.isInvalid(tranY) || !CommonUtils.isInvalid(tranZ)) {
      let curTran: Window.TranslateOptions = {
        x: tranX,
        y: tranY,
        z: tranZ
      };
      this.getOrCreateCurOptions().translate = curTran;
      log.showDebug(`window translate to tranX:${curTran.x} tranY:${curTran.y} tranZ:${curTran.z}`);
      if (this.window === null || this.window === undefined) {
        log.showError('setWindowTran  window is null or undefined');
        return;
      }
      try {
        this.window?.translate(curTran);
      } catch (err) {
        log.showError('setWindowTran', curTran.x, curTran.y, curTran.z, err);
      }
    }
  }

  /**
   * 计算当前属性值
   *
   * @param begin 开始值
   * @param end 结束值
   * @param progress 当前进度
   * @return 当前属性值
   */
  private calCurrentAttr(begin: number, end: number, progress: number): number {
    // 没有开始或结束值，表示不涉及该属性
    if (CommonUtils.isInvalid(begin) || CommonUtils.isInvalid(end)) {
      return null;
    }
    if (CommonUtils.equals(begin, end)) {
      return begin;
    }
    return begin + ((end - begin) * progress);
  }

  /**
   * 标示动画结束
   *
   * @param animType 动画类型
   */
  private flagAnimFinish(animType: WinAnimType): void {
    log.showInfo('flagAnimFinish: ' + animType);
    // 回调动画已结束
    this.callbackFinish(animType);
  }

  /**
   * 缓存动画结束回调
   *
   * @param animType 动画类型
   * @param onFinish 结束回调
   */
  private putAnimFinish(animType: WinAnimType, onFinish: WinAnimFinish): void {
    let finSet = this.animFinish.get(animType);
    if (CommonUtils.isInvalid(finSet)) {
      finSet = new Set();
      this.animFinish.set(animType, finSet);
    }
    finSet.add(onFinish);
  }

  /**
   * 回调动画结束
   *
   * @param animType 动画类型
   */
  private callbackFinish(animType: WinAnimType): void {
    // 动画打断则判为动画取消，接续新动画，否则为动画结束
    let finSet = this.animFinish.get(animType);
    if (CommonUtils.isInvalid(finSet)) {
      return;
    }
    finSet.forEach((onFinish) => {
      onFinish(this.isAnimInterrupt);
    });
    finSet.clear();
  }

  /**
   * 获取当前窗口属性值
   *
   * @return 当前窗口属性值
   */
  private getOrCreateCurOptions(): WinAnimOptions {
    if (CommonUtils.isInvalid(this.curAnimOptions)) {
      this.curAnimOptions = new WinAnimOptions();
    }
    return this.curAnimOptions;
  }

  /**
   * 标记是否记录取消时的窗口属性
   *
   * @param isRecord true记录
   */
  private flagCancelOptions(isRecord: boolean): void {
    if (isRecord) {
      this.cancelAnimOptions = this.curAnimOptions;
    } else {
      this.cancelAnimOptions = null;
    }
  }
}