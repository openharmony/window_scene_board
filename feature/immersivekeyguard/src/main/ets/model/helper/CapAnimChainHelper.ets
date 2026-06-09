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

import { CapAnimScene } from '../../common/constants/ImmCapConst';
import { ICapAnimChainVm } from '../../common/interface/ICapAnimChainVm';
import { CapAnimBaseChain } from './chain/CapAnimBaseChain';
import { CapAnimHideChain } from './chain/CapAnimHideChain';
import { CapAnimInterceptChain } from './chain/CapAnimInterceptChain';
import { CapAnimRemindChain } from './chain/CapAnimRemindChain';
import { CapAnimShadowRemoveChain } from './chain/CapAnimShadowRemoveChain';
import { CapAnimShowChain } from './chain/CapAnimShowChain';
import { CapAnimTopAddChain } from './chain/CapAnimTopAddChain';
import { CapAnimTopRemoveChain } from './chain/CapAnimTopRemoveChain';
import { CapAnimTopUpdateChain } from './chain/CapAnimTopUpdateChain';
import { ImmAnimChainBaseHelper } from './ImmAnimChainBaseHelper';

/**
 * 胶囊生命周期动效检测链条辅助工具
 */
export class CapAnimChainHelper extends ImmAnimChainBaseHelper<CapAnimScene, CapAnimBaseChain>
  implements ICapAnimChainVm {
  /**
   * 初始化添加动效检测链条
   */
  protected initAddChain(): void {
    // 动效检测器按序添加，检测时按序检测
    this.addAnimChain(new CapAnimInterceptChain(this.vmInjector));
    this.addAnimChain(new CapAnimShowChain(this.vmInjector));
    this.addAnimChain(new CapAnimHideChain(this.vmInjector));
    this.addAnimChain(new CapAnimTopAddChain(this.vmInjector));
    this.addAnimChain(new CapAnimTopRemoveChain(this.vmInjector));
    this.addAnimChain(new CapAnimTopUpdateChain(this.vmInjector));
    this.addAnimChain(new CapAnimShadowRemoveChain(this.vmInjector));
    this.addAnimChain(new CapAnimRemindChain(this.vmInjector));
  }
}