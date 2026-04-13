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

import { CapAnimScene } from '../../../../common/constants/ImmCapConst';
import { ICapLifeCycleAnimFactory } from '../../../../common/interface/ICapLifeCycleAnimFactory';
import { IImmLifeCycleAnim } from '../../../../common/interface/IImmLifeCycleAnim';
import { CapHideAnim } from '../lifecycle/CapHideAnim';
import { CapRemindAnim } from '../lifecycle/CapRemindAnim';
import { CapRemindExitAnim } from '../lifecycle/CapRemindExitAnim';
import { CapShadowRemoveAnim } from '../lifecycle/CapShadowRemoveAnim';
import { CapShowAnim } from '../lifecycle/CapShowAnim';
import { CapTopAddAnim } from '../lifecycle/CapTopAddAnim';
import { CapTopRemoveAnim } from '../lifecycle/CapTopRemoveAnim';
import { CapTopUpdateAnim } from '../lifecycle/CapTopUpdateAnim';
import { ImmLifeCycleAnimFactory } from './ImmLifeCycleAnimFactory';

/**
 * 沉浸胶囊模块生命周期动效工厂
 */
export class CapLifeCycleAnimFactory extends ImmLifeCycleAnimFactory<CapAnimScene>
  implements ICapLifeCycleAnimFactory {
  protected createAnim(animScene: CapAnimScene): IImmLifeCycleAnim | undefined {
    switch (animScene) {
      case CapAnimScene.ANIM_SHOW:
        return new CapShowAnim(this.vmInjector);
      case CapAnimScene.ANIM_HIDE:
        return new CapHideAnim(this.vmInjector);
      case CapAnimScene.ANIM_TOP_ADD:
        return new CapTopAddAnim(this.vmInjector);
      case CapAnimScene.ANIM_TOP_REMOVE:
        return new CapTopRemoveAnim(this.vmInjector);
      case CapAnimScene.ANIM_TOP_UPDATE:
        return new CapTopUpdateAnim(this.vmInjector);
      case CapAnimScene.ANIM_SHADOW_REMOVE:
        return new CapShadowRemoveAnim(this.vmInjector);
      case CapAnimScene.ANIM_REMIND:
        return new CapRemindAnim(this.vmInjector);
      case CapAnimScene.ANIM_REMIND_EXIT:
        return new CapRemindExitAnim(this.vmInjector);
      default:
        return undefined;
    }
  }
}