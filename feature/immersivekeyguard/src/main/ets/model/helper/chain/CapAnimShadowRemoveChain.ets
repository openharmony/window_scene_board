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

import { CapAnimScene, CapShowType } from '../../../common/constants/ImmCapConst';
import { CapAnimBaseChain } from './CapAnimBaseChain';

/**
 * 胶囊生命周期动效阴影胶囊删除动效检测器
 */
export class CapAnimShadowRemoveChain extends CapAnimBaseChain {
  public checkLifeCycleAnim(): CapAnimScene | undefined {
    // 删除胶囊数据，旧排序为阴影胶囊，且当前只有1条数据，则执行阴影胶囊移除动效
    let removeData = this.getCapCheckList()?.get(CapShowType.CAP_REMOVE);
    if (removeData && removeData.getCapShowType() === CapShowType.CAP_SHADOW &&
      this.getCapList().getValidSize() === 1) {
      return CapAnimScene.ANIM_SHADOW_REMOVE;
    }
    // 下游检测
    return super.checkLifeCycleAnim();
  }
}