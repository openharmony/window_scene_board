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

import { DropAnimationDestination } from '../config/DropAnimationConfig';
import { DropAnimationParam } from '../bean/DropAnimationParam';

/**
 * 落位动效监听器
 */
export interface DropAnimationListener {
  /**
   * 落位动效开始的回调
   */
  onDropAnimationStart?: (target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean) => void;

  /**
   * 落位动效结束的回调
   */
  onDropAnimationEnd?: (target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean,
    isCancel: boolean) => void;
}