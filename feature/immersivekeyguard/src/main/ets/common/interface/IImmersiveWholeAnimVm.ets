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

import { AnimEvent } from '@ohos/screenlockcommon/Index';
import { HybridAnimParam } from '../constants/ImmComConst';
import { IImmersiveAnimBaseVm } from './IImmersiveAnimBaseVm';

/**
 * 沉浸模块整体动效业务管理抽象层
 */
export interface IImmersiveWholeAnimVm extends IImmersiveAnimBaseVm {
  /**
   * 开启列表过渡胶囊跟手回退动效
   *
   * @param vel 跟手速度
   */
  startList2CapTouchBackAnim(vel?: number): void

  /**
   * 开启胶囊过渡列表跟手回退动效
   *
   * @param vel 跟手速度
   */
  startCap2ListTouchBackAnim(vel?: number): void;

  /**
   * 开启联合动效
   *
   * @param param 动效参数
   */
  startHybridAnim(param: HybridAnimParam): void;
}