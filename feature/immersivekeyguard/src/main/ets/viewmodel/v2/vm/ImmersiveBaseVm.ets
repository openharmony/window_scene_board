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

import { IImmersiveVmInjector } from '../../../common/interface/IImmersiveVmInjector';
import { SlStateHelper } from '../../../model/helper/SlStateHelper';

/**
 * 沉浸模块业务管理器基类
 */
export abstract class ImmersiveBaseVm<T extends IImmersiveVmInjector> {
  /**
   * 业务注入器
   */
  protected readonly vmInjector: T;

  /**
   * 状态辅助工具
   */
  protected readonly stateHelper: SlStateHelper;

  constructor(vmInjector: T) {
    this.vmInjector = vmInjector;
    this.stateHelper = SlStateHelper.getInstance(vmInjector.getStateMgr());
  }
}