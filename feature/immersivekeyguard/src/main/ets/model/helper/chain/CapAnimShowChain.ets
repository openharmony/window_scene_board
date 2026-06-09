/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { CapAnimScene } from '../../../common/constants/ImmCapConst';
import { CapAnimBaseChain } from './CapAnimBaseChain';

/**
 * 胶囊生命周期动效从无到有出现动效检测器
 */
export class CapAnimShowChain extends CapAnimBaseChain {
  public checkLifeCycleAnim(): CapAnimScene | undefined {
    // 胶囊数据从无到有，执行出现动效
    let oldSize = this.getCapList()?.getOldValidSize() ?? 0;
    let curSize = this.getCapList()?.getValidSize() ?? 0;
    if (oldSize === 0 && curSize > 0) {
      return CapAnimScene.ANIM_SHOW;
    }
    // 下游检测
    return super.checkLifeCycleAnim();
  }
}