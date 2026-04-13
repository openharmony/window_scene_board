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

import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { ImmBaseGesture } from './ImmBaseGesture';

/**
 * 沉浸大卡实况卡片手势
 */
@ObservedV2
export class ImmCardLiveCardGesture extends ImmBaseGesture {
  // 沉浸大卡业务
  @Computed get immCardVm(): IImmersiveCardVm | undefined {
    return this.vmInjector?.getImmersiveCardVm();
  }

  // 大卡实况卡片手势
  private liveGesture: GestureGroupHandler = new GestureGroupHandler({
    mode: GestureMode.Exclusive,
    gestures: [
      // 下滑手势
      new PanGestureHandler({ direction: PanDirection.Down })
        .onActionEnd(() => this.immCardVm?.onLiveCardDownEvent?.())
    ]
  });

  /**
   * 刷新沉浸大卡实况卡片手势启用状态
   *
   * @param isDisable true启用手势
   */
  public updateGestureEnable(isEnable: boolean): void {
    if (isEnable) {
      this.addGesture(this.liveGesture);
    } else {
      this.removeGesture(this.liveGesture);
    }
  }
}