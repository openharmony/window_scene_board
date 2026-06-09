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

import { SizeBpSplice } from '@ohos/screenlockcommon';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { SlCardConfigStateV2 } from '../../model/data/v2/SlCardConfigStateV2';
import { CardShowType } from '../constants/ImmCardConst';
import { CardStyleSuffix } from '../constants/ImmCardConst';

/**
 * 沉浸大卡模块默认样式配置辅助工具业务
 */
export interface ICardStyleConfigHelper {
  /**
   * 取值沉浸大卡配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 配置
   */
  getCardConfig(bpSplice?: SizeBpSplice): SlCardConfigStateV2;

  /**
   * 取值沉浸大卡root样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  getCardRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2;

  /**
   * 取值沉浸大卡条目样式配置
   *
   * @param cardType 大卡类型
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  getCardItemStyle(cardType: CardShowType, bpSplice?: SizeBpSplice): WidgetStyleStateV2;

  /**
   * 取值沉浸大卡通用布局样式配置
   *
   * @param cardSf 通用布局样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  getCardComViewStyle(cardSf: CardStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2 | undefined;
}