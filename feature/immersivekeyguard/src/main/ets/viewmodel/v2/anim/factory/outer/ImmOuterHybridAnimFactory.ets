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

import { ImmComAnimScene } from '../../../../../common/constants/ImmComConst';
import { IImmHybridAnim } from '../../../../../common/interface/IImmHybridAnim';
import { HybridCardToLiveCapAnim } from '../../hybrid/HybridCardToLiveCapAnim';
import { HybridCardToLiveListAnim } from '../../hybrid/HybridCardToLiveListAnim';
import { HybridLiveListToCardAnim } from '../../hybrid/HybridLiveListToCardAnim';
import { ImmHybridAnimFactory } from '../ImmHybridAnimFactory';

/**
 * 沉浸锁屏模块小外屏联合动效工厂
 */
export class ImmOuterHybridAnimFactory extends ImmHybridAnimFactory {
  protected createAnim(animScene: ImmComAnimScene): IImmHybridAnim | undefined {
    switch (animScene) {
      case ImmComAnimScene.ANIM_LIVE_LIST_CARD:
        return new HybridLiveListToCardAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_CARD_LIVE_LIST:
        return new HybridCardToLiveListAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_CARD_LIVE_CAP:
        return new HybridCardToLiveCapAnim(this.vmInjector);
      default:
        return undefined;
    }
  }
}