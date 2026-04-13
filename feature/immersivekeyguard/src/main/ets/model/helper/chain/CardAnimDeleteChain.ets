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

import { CardShowType } from '../../../common/constants/ImmCardConst';
import { CardAnimScene } from '../../../common/constants/ImmCardConst';
import { CardAnimBaseChain } from './CardAnimBaseChain';

/**
 * 沉浸大卡生命周期动效拦截检测器
 */
export class CardAnimDeleteChain extends CardAnimBaseChain {
  public checkLifeCycleAnim(): CardAnimScene | undefined {
    let curData = this.getCardCheckList()?.get(CardShowType.CARD_DELETE);
    let beforeImmState = this.getImmComVm()?.getBeforeImmState();
    let curImmState = this.getImmComVm()?.getImmState();
    // 有删除数据标识并且沉浸态切换胶囊态
    if (curData && beforeImmState?.isImmersive() && curImmState?.isCapsule()) {
      return CardAnimScene.ANIM_DELETE;
    }
    // 下游检测
    return super.checkLifeCycleAnim();
  }
}