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

import { LogDomain, Logger } from '@ohos/basicutils';
import { CardAnimScene } from '../../../common/constants/ImmCardConst';
import { CardAnimBaseChain } from './CardAnimBaseChain';

const TAG = 'CardAnimInterceptChain';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 沉浸大卡生命周期动效拦截检测器
 */
export class CardAnimInterceptChain extends CardAnimBaseChain {
  public checkLifeCycleAnim(): CardAnimScene | undefined {
    // AOD状态，无动效
    if (this.getImmComVm()?.isAod()) {
      log.showInfo(TAG, 'checkLifeCycleAnim aod state.');
      return CardAnimScene.ANIM_NONE;
    }
    // 下游检测
    return super.checkLifeCycleAnim();
  }
}