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

import { IBaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

/**
 * 沉浸模块条目状态辅助工具抽象层
 */
export interface IImmersiveItemStHelper<T extends IBaseState> {
  /**
   * 加入item状态
   *
   * @param itemKey 条目标识
   */
  addItemSt(itemKey?: string): void;

  /**
   * 移除item状态
   *
   * @param itemKey 条目标识
   */
  removeItemSt(itemKey?: string): void;

  /**
   * 取值item状态
   *
   * @param itemKey 条目标识
   * @returns 状态值
   */
  getItemSt(itemKey?: string): T | undefined;
}