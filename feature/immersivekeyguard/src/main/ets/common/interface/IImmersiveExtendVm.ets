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

import { IBaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2, WidgetCacheState } from '@ohos/screenlockcommon/Index';

/**
 * 沉浸模块扩展业务抽象层
 */
export interface IImmersiveExtendVm {
  /**
   * 静态状态管理器
   *
   * @returns 静态状态管理器
   */
  getSlStaticState(): IBaseState;

  /**
   * UI绑定状态管理器
   *
   * @returns UI绑定状态管理器
   */
  getSlBindState(): IBaseState;

  /**
   * 动效状态管理器
   *
   * @returns 动效状态管理器
   */
  getSlAnimState(): WidgetAnimStateV2;

  /**
   * UI属性样式状态管理器
   *
   * @returns 样式状态管理器
   */
  getSlStyleState(): WidgetStyleStateV2;

  /**
   * 组件其他缓存状态管理器
   *
   * @returns 缓存状态管理器
   */
  getSlCacheState(): WidgetCacheState;
}