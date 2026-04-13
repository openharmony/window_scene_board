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

import { CardAnimScene } from '../../../../common/constants/ImmCardConst';
import { ICardLifeCycleAnimFactory } from '../../../../common/interface/ICardLifeCycleAnimFactory';
import { IImmLifeCycleAnim } from '../../../../common/interface/IImmLifeCycleAnim';
import { CardRemoveAnim } from '../lifecycle/CardRemoveAnim';
import { CardUpdateAnim } from '../lifecycle/CardUpdateAnim';
import { ImmLifeCycleAnimFactory } from './ImmLifeCycleAnimFactory';

/**
 * 沉浸大卡模块生命周期动效工厂
 */
export class CardLifeCycleAnimFactory extends ImmLifeCycleAnimFactory<CardAnimScene>
  implements ICardLifeCycleAnimFactory {
  protected createAnim(animScene: CardAnimScene): IImmLifeCycleAnim | undefined {
    switch (animScene) {
      case CardAnimScene.ANIM_UPDATE:
        return new CardUpdateAnim(this.vmInjector);
      case CardAnimScene.ANIM_DELETE:
        return new CardRemoveAnim(this.vmInjector);
      default:
        return undefined;
    }
  }
}