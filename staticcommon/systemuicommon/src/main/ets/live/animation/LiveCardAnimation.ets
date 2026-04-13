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
import { AnimationBase } from '../../animation/AnimationBase';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';

export class LiveCardAnimation extends AnimationBase {
  private vmInjector: ILiveVmInjector;

  constructor(vmInjector: ILiveVmInjector) {
    super(AnimationBase.NAMES.LIVE_CARD_LIST_ANIMATION, true);
    this.vmInjector = vmInjector;
  }

  /**
   * 删除卡片动效
   * @returns
   */
  public async removeCard(event: () => void) {
    await this.executeAnimation([
      {
        curve: Curve.Friction,
        duration: 300,
        event: event
      }
    ], 'removeCard');
  }

  /**
   * 按压卡片缩放动效
   */
  public async touch(touchDown: boolean, live: LiveNotification) {
    const itemVm = this.vmInjector.getCardListItemVm(live);
    await this.executeAnimation([
      {
        curve: Curve.Linear,
        duration: 200,
        event: () => {
          itemVm.containerScale = touchDown ? { x: 0.95, y: 0.95 } : { x: 1, y: 1};
        }
      }
    ], `touch ${touchDown ? 'down' : 'up'} card`)
  }
}