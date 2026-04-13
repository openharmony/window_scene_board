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

import { IImmV1StateVm } from '../../../common/interface/IImmV1StateVm';
import { SlCardStaticState } from '../../../model/data/SlCardStaticState';
import { SlCapStaticState } from '../../../model/data/SlCapStaticState';
import { immersiveStateHelper } from '../../../common/helper/ImmersiveStateHelper';
import { SlListStaticState } from '../../../model/data/SlListStaticState';

/**
 * 沉浸模块V1状态管理业务
 */
export class ImmV1StateVm implements IImmV1StateVm {
  // 单例
  private static sInstance?: ImmV1StateVm;

  private constructor() {
  }

  public getCardStaticStV1(): SlCardStaticState {
    return immersiveStateHelper.getImmerseCardStaticState() as SlCardStaticState;
  }

  public getCapStaticStV1(): SlCapStaticState {
    return immersiveStateHelper.getSlCapsuleStaticState() as SlCapStaticState;
  }

  public getListStaticStV1(): SlListStaticState {
    return immersiveStateHelper.getSlListStaticState() as SlListStaticState;
  }

  /**
   * 单例
   *
   * @returns 单例
   */
  public static getInstance(): ImmV1StateVm {
    if (!ImmV1StateVm.sInstance) {
      ImmV1StateVm.sInstance = new ImmV1StateVm();
    }
    return ImmV1StateVm.sInstance;
  }
}