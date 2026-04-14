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

import { ImmersiveState } from '@ohos/systemuicommon';
import { CardAnimScene } from '../../../common/constants/ImmCardConst';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { ImmCardCheckData } from '../../data/v2/ImmCardCheckData';
import { ImmCardDataArray } from '../../data/v2/ImmCardDataArray';
import { ICardLifeCycleAnimChain } from './ICardLifeCycleAnimChain';
import { ImmAnimBaseChain } from './ImmAnimBaseChain';

/**
 * 沉浸大卡生命周期动效检测链条基类
 */
export class CardAnimBaseChain extends ImmAnimBaseChain<CardAnimScene> implements ICardLifeCycleAnimChain {
  // 链条下游检测器
  protected nextChain?: CardAnimBaseChain;

  /**
   * 添加检测链条
   *
   * @param nextChain 检测链条
   */
  public addNextChain(nextChain: CardAnimBaseChain): void {
    super.addNextChain(nextChain);
  }

  /**
   * 检测沉浸大卡生命周期动效
   *
   * @returns 动效场景
   */
  public checkLifeCycleAnim(): CardAnimScene | undefined {
    return super.checkLifeCycleAnim();
  }

  /**
   * 沉浸大卡UI显示数据
   *
   * @returns 沉浸大卡数据
   */
  protected getCardList(): ImmCardDataArray {
    return this.getCardVm()?.getSlCardData();
  }

  /**
   * 沉浸大卡动效检测数据
   *
   * @returns 沉浸大卡数据
   */
  protected getCardCheckList(): ImmCardCheckData {
    return this.getCardVm()?.getCheckCardData();
  }

  /**
   * 沉浸大卡业务
   *
   * @returns 沉浸大卡业务
   */
  protected getCardVm(): IImmersiveCardVm {
    return this.ntfInjector?.getImmersiveCardVm();
  }
}