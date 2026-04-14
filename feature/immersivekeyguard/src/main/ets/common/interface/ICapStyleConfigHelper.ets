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
import { SlCapConfigStateV2 } from '../../model/data/v2/SlCapConfigStateV2';
import { CapStyleSuffix } from '../constants/ImmCapConst';
import { CapShowType } from '../constants/ImmCapConst';

/**
 * 沉浸胶囊模块默认样式配置辅助工具业务
 */
export interface ICapStyleConfigHelper {
  /**
   * 取值胶囊样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式
   */
  getCapRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2;

  /**
   * 取值胶囊默认配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 默认配置
   */
  getCapConfig(bpSplice?: SizeBpSplice): SlCapConfigStateV2;

  /**
   * 取值胶囊条目样式配置
   *
   * @param capType 胶囊类型
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  getCapItemStyle(capType: CapShowType, bpSplice?: SizeBpSplice): WidgetStyleStateV2;

  /**
   * 取值胶囊通用布局样式配置
   *
   * @param capSf 胶囊样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  getCapComViewStyle(capSf: CapStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2 | undefined;
}