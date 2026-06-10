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

import { SlCardStaticState } from '../../model/data/SlCardStaticState';
import { SlCapStaticState } from '../../model/data/SlCapStaticState';
import { SlListStaticState } from '../../model/data/SlListStaticState';

/**
 * 沉浸模块V1状态管理器抽象层
 */
export interface IImmV1StateVm {
  /**
   * 沉浸大卡静态状态
   *
   * @returns V1状态
   */
  getCardStaticStV1(): SlCardStaticState;

  /**
   * 沉浸胶囊静态状态
   *
   * @returns V1状态
   */
  getCapStaticStV1(): SlCapStaticState;

  /**
   * 沉浸列表静态状态
   *
   * @returns V1状态
   */
  getListStaticStV1(): SlListStaticState;
}