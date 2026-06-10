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
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FrameListener } from '@ohos/componenthelper';

const TAG: string = 'CustomAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/** 自定义动画 每帧刷新一次 */
export class CustomAnimation {
  private animationList: Map<string, CustomAnimationItem> = new Map();

  /** 开始动效 */
  public doAnimation(): Promise<boolean> {
    log.showInfo('frameAnimation start');
    return new Promise((resolve) => {
      const animationList = Array.from(this.animationList.values());
      let animationPromise: Promise<boolean>[] = animationList.map(item => item.start());
      const frameListenerUniqueId = FrameListener.getInstance().register((curTime: number, nextTime: number) => {
        this.render(nextTime);
      });
      Promise.all(animationPromise).then((resList: boolean[]) => {
        const isCancel = resList.some(x => x);
        resolve(isCancel);
        this.clear();
      }).finally(() => {
        FrameListener.getInstance().unregister(frameListenerUniqueId);
      });
    });
  }

  /**
   * 添加动效项
   * 不支持弹簧曲线
   * @param itemParam
   */
  public setAnimationItem(itemParam: CustomAnimationParam): void {
    const animation: CustomAnimationItem = new CustomAnimationItem(itemParam);
    this.animationList.set(animation.id, animation);
  }

  /** 更新动效 */
  public updateAnimation(updateParams: CustomAnimationUpdateParam[]): void {
    const count = updateParams.length;
    for (let i = 0; i < count; i++) {
      const animation = this.animationList.get(updateParams[i].id);
      if (!animation) {
        return;
      }
      animation.updateTarget(updateParams[i]);
    }
  }

  /** 触发动效刷新 */
  private render(nextTime: number): void {
    this.animationList.forEach(async item => item.render(nextTime));
  }

  /** 清理 */
  public clear(): void {
    this.animationList.forEach(async item => item.cancel());
    this.animationList.clear();
  }

  /** 当前动效列表是否为空 */
  public get isEmpty(): boolean {
    return this.animationList.size === 0;
  }
}

/** 自定义动画子类 */
export class CustomAnimationItem {
  public id: string;
  private startTime: number = 0;
  private animationParam: CustomAnimationParam;
  private status: CustomAnimationStatus = CustomAnimationStatus.INIT;
  private gaps: number[] = [];
  private finishResolve?: (value: boolean | PromiseLike<boolean>) => void;

  constructor(param: CustomAnimationParam) {
    this.id = param.id;
    this.animationParam = param;
  }

  /** 是否正在动效中 */
  public get isAnimation(): boolean {
    return this.status === CustomAnimationStatus.ANIMATION;
  }

  /** 开始动效 动效启动成功返回Promise, 否则返回undefined */
  public start(): Promise<boolean> | undefined {
    if (this.animationParam.begins.length !== this.animationParam.targets.length) {
      return undefined;
    }
    return new Promise((resolve) => {
      this.finishResolve = resolve;
      this.getGapsBetweenBeginAndTarget();
      this.startTime = new Date().getTime();
      this.status = CustomAnimationStatus.ANIMATION;
      this.animationParam.onRender(this.animationParam.begins);
    });
  }

  /** 触发动效刷新 */
  public render(nextTime: number): boolean {
    const cAniTime: number = this.getCurrentAnimationTime();
    if (cAniTime < 0 || !this.isAnimation) {
      return false;
    }
    this.animationParam.onRender(this.getCurrentProgress(cAniTime));
    if (cAniTime >= this.animationParam.duration + this.animationParam.endDelay) {
      this.finish(false);
    }
    return true;
  }

  /** 更新动效参数 */
  public updateTarget(param: CustomAnimationUpdateParam): boolean {
    if (param.id !== this.id) {
      return false;
    }
    if (param.targets && param.targets.length === this.animationParam.targets.length) {
      this.animationParam.targets = param.targets;
    }
    if (param.delay !== undefined) {
      this.animationParam.delay = param.delay;
    }
    if (param.duration !== undefined) {
      this.animationParam.duration = param.duration;
    }
    if (param.curves !== undefined) {
      this.animationParam.curves = param.curves;
    }
    this.getGapsBetweenBeginAndTarget();
    return true;
  }

  /** 打断动效 */
  public cancel(): void {
    if (!this.isAnimation) {
      return;
    }
    this.finish(true);
  }

  /** 动效结束处理流程 */
  private finish(isCancel: boolean): void {
    if (!this.isAnimation) {
      return;
    }
    this.status = CustomAnimationStatus.FINISH;
    if (this.finishResolve) {
      this.finishResolve(isCancel);
      this.finishResolve = undefined;
    }
    this.animationParam.onFinish(isCancel);
  }

  /** 获取实际动效时间 扣除了delay */
  private getCurrentAnimationTime(): number {
    return new Date().getTime() - this.startTime - this.animationParam.delay;
  }

  /** 获取根据时间获取当前插值器进度 */
  private getCurrentProgress(cTime: number): number[] {
    const timeProgress: number = cTime / this.animationParam.duration;
    const valProgress = this.animationParam.curves.interpolate(timeProgress);
    let arr = this.gaps.map((item: number, index: number) => {
      return this.animationParam.begins[index] + item * valProgress;
    });
    return arr;
  }

  /** 获取起点和终点的插值 */
  private getGapsBetweenBeginAndTarget(): void {
    const count: number = this.animationParam.targets.length;
    const gaps: number[] = [];
    for (let i = 0; i < count; i++) {
      gaps.push(this.animationParam.targets[i] - this.animationParam.begins[i]);
    }
    this.gaps = gaps;
  }
}

/** 自定义动画参数 */
export interface CustomAnimationParam {
  /** 唯一Id */
  id: string;

  /** 开始延迟 */
  delay: number;

  /** 动画时长 */
  duration: number;

  /** 延迟结束 */
  endDelay: number;

  /** 曲线插值器 */
  curves: curves.ICurve;

  /** 开始列表 */
  begins: number[];

  /** 目标列表 */
  targets: number[];

  /** 动效渲染回调 */
  onRender: (currentProgress: number[]) => void;

  /** 动效完成回调 */
  onFinish: (isCancel: boolean) => void;
}

/** 自定义动画更新参数 */
export interface CustomAnimationUpdateParam {
  /** 唯一Id */
  id: string;

  /** 开始延迟 */
  delay?: number;

  /** 动画时长 */
  duration?: number;

  /** 延迟结束 */
  endDelay?: number;

  /** 曲线插值器 */
  curves?: curves.ICurve;

  /** 目标列表 */
  targets?: number[];
}

export enum CustomAnimationStatus {
  /** 初始状态 */
  INIT,
  /** 动画中 */
  ANIMATION,
  /** 动画结束 */
  FINISH,
}
