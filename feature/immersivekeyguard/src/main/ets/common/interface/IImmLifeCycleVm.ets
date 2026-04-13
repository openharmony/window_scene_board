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

/**
 * 沉浸模块生命周期业务抽象层
 */
export interface IImmLifeCycleVm {
  /**
   * 初始化
   */
  init(): void;

  /**
   * 资源回收
   */
  destroy(): void;
}

// 生命周期业务集
export class IImmLifeCycleVmArray extends Array<IImmLifeCycleVm> {
}