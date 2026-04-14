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

import { SizeBpSplice } from '@ohos/screenlockcommon';
import { SlImmConfigStateV2 } from '../../model/data/v2/SlImmConfigStateV2';
import { ICapStyleConfigHelper } from './ICapStyleConfigHelper';
import { ICardStyleConfigHelper } from './ICardStyleConfigHelper';
import { IListStyleConfigHelper } from './IListStyleConfigHelper';

/**
 * 沉浸模块默认样式配置辅助工具业务
 */
export interface IImmStyleConfigHelper extends IListStyleConfigHelper, ICapStyleConfigHelper, ICardStyleConfigHelper {
  /**
   * 取值沉浸模块配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 配置
   */
  getImmConfig(bpSplice?: SizeBpSplice): SlImmConfigStateV2;
}