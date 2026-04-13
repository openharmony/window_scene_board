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
import { ThemeActivationTarget, ThemeOwnershipType } from './TsConstant';

/*
 * 主题使能事件，用于通知各模块主题使能并提供当前生效资源目录
 */
export class TsEvent {
  /**
   * 主题生效范围
   */
  public target: ThemeActivationTarget = 0;
  /**
   * 用户对主题包的拥有权区分，用于区分试用主题还是已购买的主题
   */
  public themeOwnership: ThemeOwnershipType = 0;
  /**
   * 当前资源目录(A/B)
   */
  public activeThemePath: string = '';
}