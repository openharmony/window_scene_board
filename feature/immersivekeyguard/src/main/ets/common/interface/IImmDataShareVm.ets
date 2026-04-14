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

import { ImmDataShareWrap } from './IImmDataShare';

/**
 * 沉浸模块数据分享业务抽象层
 */
export interface IImmDataShareVm {
  /**
   * 移除错误数据
   *
   * @param groupKey 错误数据分组标识
   */
  onDelWrongData?(groupKey: string): void;

  /**
   * 数据刷新回调
   *
   * @param dataShare 数据分享集
   */
  onDataChange(dataShare: ImmDataShareWrap): void;
}

// 数据处理业务集
export class IImmDataShareVmArray extends Array<IImmDataShareVm> {
}