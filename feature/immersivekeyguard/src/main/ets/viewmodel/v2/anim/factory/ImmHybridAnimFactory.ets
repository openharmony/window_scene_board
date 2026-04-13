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

import { ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { IImmHybridAnim } from '../../../../common/interface/IImmHybridAnim';
import { IImmHybridAnimFactory } from '../../../../common/interface/IImmHybridAnimFactory';
import { HybridCapCardSwitchAnim } from '../hybrid/HybridCapCardSwitchAnim';
import { HybridCapToCardAnim } from '../hybrid/HybridCapToCardAnim';
import { HybridCapToListAnim } from '../hybrid/HybridCapToListAnim';
import { HybridCardToCapAnim } from '../hybrid/HybridCardToCapAnim';
import { HybridCardToListAnim } from '../hybrid/HybridCardToListAnim';
import { HybridListToCapAnim } from '../hybrid/HybridListToCapAnim';
import { HybridListToCardAnim } from '../hybrid/HybridListToCardAnim';
import { ImmBaseAnimFactory } from './ImmBaseAnimFactory';

/**
 * 沉浸锁屏模块联合动效工厂
 */
export class ImmHybridAnimFactory extends ImmBaseAnimFactory<IImmHybridAnim, ImmComAnimScene>
  implements IImmHybridAnimFactory {
  protected createAnim(animScene: ImmComAnimScene): IImmHybridAnim | undefined {
    switch (animScene) {
      case ImmComAnimScene.ANIM_CAP_CARD:
        return new HybridCapToCardAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_CARD_CAP:
        return new HybridCardToCapAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_LIST_CARD:
        return new HybridListToCardAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_CARD_LIST:
        return new HybridCardToListAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_CAP_LIST_FIX:
        return new HybridCapToListAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_LIST_CAP_FIX:
        return new HybridListToCapAnim(this.vmInjector);
      case ImmComAnimScene.ANIM_CAP_CARD_SWITCH:
        return new HybridCapCardSwitchAnim(this.vmInjector);
      default:
        return undefined;
    }
  }
}