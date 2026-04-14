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
export class CardAnimUpdateChain extends CardAnimBaseChain {
  public checkLifeCycleAnim(): CardAnimScene | undefined {
    let oldUpdateData = this.getCardCheckList()?.get(CardShowType.CARD_UPDATE_OLD);
    let curData = this.getCardList()?.getCardData(CardShowType.CARD_CONTENT);
    let curImmState = this.getImmComVm()?.getImmState();
    let oldGroupKey = oldUpdateData?.getGroupKey();
    let curGroupKey = curData?.getGroupKey();
    // 有被更新的沉浸数据，非播控场景，非uiExtension数据,，当前为沉浸态状态
    if (oldGroupKey !== undefined && oldGroupKey === curGroupKey && !curData?.isMediaCenter() &&
      !curData?.isUiExtensionCard() && curImmState?.isImmersive()) {
      return CardAnimScene.ANIM_UPDATE;
    }
    // 下游检测
    return super.checkLifeCycleAnim();
  }
}