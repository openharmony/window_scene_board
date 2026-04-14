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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StateType } from '../constants/BaseType';
import { WAnimDefault, WAnimProperty, WAnimScene } from '../constants/WidgetPropertyConst';
import { LimitMap } from '../utils/LimitMap';
import { LimitSet } from '../utils/LimitSet';
import { WidgetPropertyStateV2 } from './WidgetPropertyStateV2';

const TAG = 'WidgetAnimStateV2';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 组件动效状态基类
 */
@ObservedV2
export class WidgetAnimStateV2 extends WidgetPropertyStateV2<WidgetAnimStateV2> {
  // 强制移除动效计时器
  @Trace private readonly removeSceneTimer: LimitMap<string, number> = new LimitMap();
  // 当前动效场景集
  @Trace private readonly animScene: LimitSet<string> = new LimitSet();
  // 动效场景数统计
  @Trace private animCount: number = 0;
  // 当前是否动效中
  @Trace private isAnimating: boolean = false;

  private startForceRemoveTimer(value?: WAnimScene): void {
    // 开启计时，强制移除动效场景
    let isAnimating = value?.isAnimating ?? false;
    let animScene = value?.animScene ?? WAnimDefault.DEFAULT_ANIM_SCENE;
    let isForceRemove = value?.isForceRemove ?? true;
    if (isForceRemove) {
      this.clearSceneTimer(animScene);
      if (!isAnimating) {
        return;
      }
      let timeoutScene: WAnimScene = { isAnimating: false, animScene: value?.animScene, isForceRemove: true };
      let timerId = setTimeout(() => {
        this.setAnimScene(timeoutScene);
        log.showWarn(`startForceRemoveTimer anim timeout: ${animScene}`);
      }, WAnimDefault.TIMER_TIMEOUT);
      this.removeSceneTimer.set(animScene, timerId);
    }
  }

  private clearSceneTimer(scene: string): void {
    let timerId = this.removeSceneTimer.get(scene);
    clearTimeout(timerId);
    this.removeSceneTimer.delete(scene);
  }

  protected getTarInstance(): WidgetAnimStateV2 {
    return this;
  }

  /**
   * 复写BindBaseState，赋值函数初始化
   */
  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(WAnimProperty.ANIM_SCENE, this.setAnimScene);
  }

  /**
   * 复写BindBaseState，取值函数初始化
   */
  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(WAnimProperty.ANIM_SCENE, this.isSceneAnimating);
    this.addGetMethod(WAnimProperty.ANIMATING, this.isWidgetAnimating);
  }

  /**
   * 复写IBaseState，状态类型
   *
   * @returns 状态类型
   */
  public getStateType(): StateType {
    return StateType.ANIM;
  }

  public setAnimScene(value?: WAnimScene): WidgetAnimStateV2 {
    let isAnimating = value?.isAnimating ?? false;
    let animScene = value?.animScene ?? WAnimDefault.DEFAULT_ANIM_SCENE;
    if (isAnimating) {
      if (this.animCount < WAnimDefault.MAX_ANIM_COUNT && !this.animScene.has(animScene)) {
        this.animScene.add(animScene);
        this.animCount++;
      }
    } else {
      if (this.animCount > 0 && this.animScene.delete(animScene)) {
        this.animCount--;
      }
    }

    let result = !this.animScene.isEmpty();
    if (this.isAnimating !== result) {
      this.isAnimating = result;
      this.notifyStateChange(WAnimProperty.ANIMATING);
    }
    // 超时强制移除任务
    this.startForceRemoveTimer(value);
    return this;
  }

  public isSceneAnimating(animScene?: string): boolean {
    if (animScene) {
      return this.animCount > 0 && this.animScene.has(animScene);
    }
    // 无场景，表示全场景动效状态
    return this.isAnimating;
  }

  public isWidgetAnimating(): boolean {
    return this.isAnimating;
  }

  public getSceneValues(): string {
    return this.animScene.castArray().join(',');
  }
}
 