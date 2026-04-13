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

import { TrialContentType } from '@ohos/themeservice_inner_api/Index';
import { PreThemeInfo } from './PreThemeInfo';

/**
 * 试用主题信息
 */
export interface TrialThemeInfo {
  /**
   * 试用资源(主题/字体)ID
   * @type {string}
   * @memberof TrialThemeInfo
   */
  trialThemeId?: string

  /**
   * 试用类型
   * @type {'theme' | 'font'}
   * @memberof TrialThemeInfo
   */
  trialType?: TrialContentType;

  /**
   * 试用结束时间，以时间戳形式表示
   * @type {number}
   * @memberof TrialThemeInfo
   */
  trialEndTime?: number;

  /**
   * 限免到期前提醒时间，以时间戳形式表示
   * @type {number}
   * @memberof TrialThemeInfo
   */
  reminderEndTime?: number;

  /**
   * 使能类型0:试用，1:限免
   * @type {number}
   * @memberof TrialThemeInfo
   */
  activateType?: number;

  /**
   * 前一试用主题的信息
   * @type {PreThemeInfo}
   * @memberof TrialThemeInfo
   */
  preThemeInfo?: PreThemeInfo;
}

