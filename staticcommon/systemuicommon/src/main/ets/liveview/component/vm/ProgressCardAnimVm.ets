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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { AnimateParams } from '../../../animation/AnimationBase';
import { LineType, LiveUseScene } from '../../common/LiveConstants';
import { LiveProgressTemplate } from '../../data/template/LiveProgressTemplate';
import { Animator, AnimatorResult } from '@kit.ArkUI';
import { ProgressCardAnimation } from '../anim/ProgressCardAnimation';

const TAG = 'ProgressCardAnimVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface ProgressDot {
  offset: number;
  isInProgress: boolean;
}

export interface ProgressCardAnimView {
  data: LiveProgressTemplate;
  dots: ProgressDot[];
  dotsColors: string[];
  progressWidth: number
  /**
   * 获取指示器偏移量
   */
  getIndicatorLeft(progress?: number): number;
  /**
   * 获取进度点背景色
   */
  getLineBackgroundColor(): string;
  /**
   * 获取进度点进度色
   */
  getLineColor(): string;
  /**
   * 获取当前进度
   */
  getProgress(): number;
}

@Observed
export class ProgressCardAnimVm {
  public static instances: Set<ProgressCardAnimVm> = new Set();

  public static getInstanceByScene(hashCode: string, useScene: LiveUseScene): ProgressCardAnimVm | undefined {
    let instance: ProgressCardAnimVm | undefined;
    for (const item of ProgressCardAnimVm.instances) {
      if (item.hashCode === hashCode && item.useScene === useScene) {
        instance = item;
        break;
      }
    }

    return instance;
  }

  public static getInitialProgress(instance?: ProgressCardAnimVm): number {
    let result = 0;
    if (!instance) {
      return result;
    }

    const progress = instance.view!.getProgress();
    const middleNodeCount = Math.max(0, (instance.view?.data.nodeIcons?.length ?? 0) - 2);
    const interval = 100 / (middleNodeCount + 1);

    while (result < progress) {
      if ((result + interval) >= progress) {
        return result;
      }

      result += interval;
    }

    return result;
  }

  /**
   * 指示器偏移
   */
  public translateX: number = 0;

  /**
   * 指示器不透明度
   */
  public opacity: number = 1;

  /**
   * 进度条宽度
   */
  public lineWidth: string = '0';

  private hashCode?: string;

  private useScene?: LiveUseScene;

  private view?: ProgressCardAnimView;

  /**
   * 进度条动效
   */
  private animation = new ProgressCardAnimation();

  /**
   * 虚线进度条帧动画
   */
  private animator?: AnimatorResult;

  /**
   * 当前进度条正在位移动效中
   */
  public progressTranXAnimPromise?: CustomPromise<void> = undefined;

  init(hashCode: string, useScene: LiveUseScene, view: ProgressCardAnimView): void {
    log.showInfo(`init hash: ${hashCode} useScene: ${useScene}`);
    this.hashCode = hashCode;
    this.useScene = useScene;
    this.view = view;

    ProgressCardAnimVm.instances.add(this);
  }

  public destroy(): void {
    ProgressCardAnimVm.instances.delete(this);
  }

  public reset() {
    this.opacity = 0;
  }

  /**
   * 设置动效
   * @param begin 初始进度
   * @param delay 延迟时间
   */
  public setAnimation(begin: number = 0, delay: number = 0, needPromise: boolean = true): void {
    if (needPromise && this.progressTranXAnimPromise === undefined) {
      this.progressTranXAnimPromise = new CustomPromise<void>();
      this.progressTranXAnimPromise.then(() => {
        this.progressTranXAnimPromise = undefined;
      });
    }
    this.clearAnimation(begin);

    const cmds: AnimateParams[] = [
      {
        duration: 200,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
           this.opacity = 1;
        }
      },
      {
        duration: 667,
        curve: Curve.Friction,
        delay: delay,
        onFinish: () => {
          if (needPromise && this.progressTranXAnimPromise !== undefined) {
            this.progressTranXAnimPromise?.resolve();
          }
        },
        event: () => {
          const translateX = this.view?.getIndicatorLeft() ?? 0;
          this.translateX = translateX;
        }
      }
    ];
    if (this.view?.data.lineType !== LineType.DOTTED_PROGRESS) {
      cmds.push({
        duration: 667,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
          const progress = this.view?.data.progress ?? 0;
          this.lineWidth = Math.min(progress, 100).toString();
        }
      });
    } else {
      this.createAnimator(begin, delay);
    }

    this.animation.addAnimation(cmds);
  }

  /**
   * 重置动效数据
   * @param begin 重置位置
   */
  private clearAnimation(begin: number = 0): void {
    this.animation.clearAnimations();

    if (this.view?.data.lineType === LineType.DOTTED_PROGRESS) {
      this.animator?.finish();
      this.onFrameAnimation(begin);
      this.translateX = this.view!.getIndicatorLeft(begin);
    } else {
      // 打断之前动效，规避连续动效冲突
      animateTo({ duration: 0 }, () => {
        this.lineWidth = begin.toString();
        this.translateX = this.view!.getIndicatorLeft(begin);
      });
    }
  }

  public async startAnimation(): Promise<void> {
    const cmds: Promise<void>[] = [];
    cmds.push(this.animation.startAnimation());

    if (this.view?.data.lineType === LineType.DOTTED_PROGRESS) {
      cmds.push(this.startAnimator());
    }

    await Promise.all(cmds);
  }

  private createAnimator(begin: number, delay: number) {
    this.animator = Animator.create({
      duration: 667,
      delay: delay,
      iterations: 1,
      begin: begin,
      end: this.view!.getProgress(),
      easing: Curve.Friction.toString(),
      fill: 'forwards',
      direction: 'normal'
    });
    this.animator.setExpectedFrameRateRange({
      min: 60,
      max: 120,
      expected: 120
    });
    this.animator.onFrame = (progress: number) => {
      this.onFrameAnimation(progress);
    };
  }

  private onFrameAnimation(progress: number): void {
    const result: string[] = [];
    const offset = progress / 100 * this.view!.progressWidth;
    this.view!.dots.forEach((dot) => {
      if (dot.offset <= offset) {
        result.push(this.view!.getLineColor());
      } else {
        result.push(this.view!.getLineBackgroundColor());
      }
    });
    this.view!.dotsColors = result;
  }

  private startAnimator(): Promise<void> {
    return new Promise<void>((resolve) => {
      this.animator!.onFinish = () => {
        resolve();
      };
      this.animator!.play();
    });
  }
}