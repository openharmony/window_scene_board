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
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { SlListConfigStateV2 } from '../../model/data/v2/SlListConfigStateV2';
import { ListStyleSuffix } from '../constants/ImmListConst';

/**
 * 沉浸列表模块默认样式配置辅助工具业务
 */
export interface IListStyleConfigHelper {
  /**
   * 取值列表样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式
   */
  getListRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2;

  /**
   * 取值列表默认配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 默认配置
   */
  getListConfig(bpSplice?: SizeBpSplice): SlListConfigStateV2;

  /**
   * 取值列表条目样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式
   */
  getListItemStyle(listSf: ListStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2;
}