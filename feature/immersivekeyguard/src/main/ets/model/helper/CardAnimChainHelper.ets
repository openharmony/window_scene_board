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

import { CardAnimScene } from '../../common/constants/ImmCardConst';
import { ICardAnimChainVm } from '../../common/interface/ICardAnimChainVm';
import { CardAnimBaseChain } from './chain/CardAnimBaseChain';
import { CardAnimDeleteChain } from './chain/CardAnimDeleteChain';
import { CardAnimInterceptChain } from './chain/CardAnimInterceptChain';
import { CardAnimUpdateChain } from './chain/CardAnimUpdateChain';
import { ImmAnimChainBaseHelper } from './ImmAnimChainBaseHelper';

/**
 * 沉浸大卡生命周期动效检测链条辅助工具
 */
export class CardAnimChainHelper extends ImmAnimChainBaseHelper<CardAnimScene, CardAnimBaseChain>
  implements ICardAnimChainVm {
  /**
   * 初始化添加动效检测链条
   */
  protected initAddChain(): void {
    // 动效检测器按序添加，检测时按序检测
    this.addAnimChain(new CardAnimInterceptChain(this.vmInjector));
    this.addAnimChain(new CardAnimDeleteChain(this.vmInjector));
    this.addAnimChain(new CardAnimUpdateChain(this.vmInjector));
  }
}