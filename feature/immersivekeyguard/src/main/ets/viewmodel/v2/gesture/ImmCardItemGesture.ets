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

import { ImmersiveTypeScene } from '@ohos/systemuicommon';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { ImmBaseGesture } from './ImmBaseGesture';

/**
 * 沉浸大卡条目手势
 */
@ObservedV2
export class ImmCardItemGesture extends ImmBaseGesture {
  // 沉浸大卡业务
  @Computed get immCardVm(): IImmersiveCardVm | undefined {
    return this.vmInjector?.getImmersiveCardVm();
  }

  // 大卡条目手势
  private cardGesture: GestureGroupHandler = new GestureGroupHandler({
    mode: GestureMode.Exclusive,
    gestures: [
      // 上滑手势
      new PanGestureHandler({ direction: PanDirection.Up })
        .onActionEnd(() => this.immCardVm?.onExitImmState(false, ImmersiveTypeScene.SCENE_CARD_UP_SCROLL)),
      // 下滑手势
      new PanGestureHandler({ direction: PanDirection.Down })
        .onActionEnd(() => this.immCardVm?.onExitImmState(true, ImmersiveTypeScene.SCENE_CARD_DOWN_SCROLL))
    ]
  });

  /**
   * 刷新沉浸大卡手势禁用状态
   *
   * @param isDisable true禁用手势
   */
  public updateGestureDisable(isDisable: boolean): void {
    if (isDisable) {
      this.removeGesture(this.cardGesture);
    } else {
      this.addGesture(this.cardGesture);
    }
  }
}