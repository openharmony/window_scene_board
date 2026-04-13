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

import { ImmersiveBaseAnim } from './ImmersiveBaseAnim';

/**
 * 串行动效
 */
export class ImmersiveSerialAnim extends ImmersiveBaseAnim {
  /**
   * 动效列表
   */
  private anims: ImmersiveBaseAnim[] = [];

  /**
   * 动效长度
   */
  private animLen: number = 0;

  /**
   * 增加基础动效
   */
  addBaseAnim(anim: ImmersiveBaseAnim): ImmersiveSerialAnim {
    this.anims.push(anim);
    anim.setInitFlag(false, false);
    anim.getComponentAnimStates().forEach((state) => this.states.add(state));
    if (this.animLen > 0) {
      this.anims[this.animLen - 1].setNextAnim(anim);
    }
    this.animLen++;
    return this;
  }

  /**
   * 启动动效
   */
  start(onStart?: () => void, onEnd?: () => void) {
    if (this.animLen <= 0) {
      return;
    }
    this.beforeSetStateToStart();
    let onFinish = () => {
      this.setStateAfterAnimEnd();
      onEnd?.();
    };

    this.anims[0].start(onStart, onFinish);
  }

  /**
   * 清除状态
   */
  clearState(): void {
    this.anims.forEach(anim => {
      anim?.clearState();
    });
  }

  /**
   * 获取列表中单个动效
   *
   * @param index 索引值
   */
  getBaseAnim(index: number): ImmersiveBaseAnim | undefined {
    return this.anims[index];
  }

  /**
   * 停止动效
   */
  exit(): void {
    this.anims.forEach(anim => {
      anim?.exit();
    });
  }
}