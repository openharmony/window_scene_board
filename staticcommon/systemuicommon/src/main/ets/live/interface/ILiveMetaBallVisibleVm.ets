/*
 *
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

 /*
 * 融球可见性控制VM，当前通过上下树控制
 * 1. 无实况时不显示融球
 * 2. 无孔时不显示融球（折叠屏展开，横屏）
 * 3. 锁屏时不显示融球
 */

import { CustomPromise } from '@ohos/frameworkwrapper';

export interface ILiveMetaBallVisibleVm {

  /**
   * 融球出现promise，需等融球出现后才触发显隐动效，否则不生效
   */
  appearPromise?: CustomPromise<void>;

  /**
   * 当前融球是否显示
   *
   * @returns 当前融球显示状态
   */
  isMetaBallShow(): boolean;

  /**
   * 设置融球显示状态
   *
   * @param state 调用融球的状态，根据数组长度判断是否显示
   */
  setMetaBallShowState(state: boolean[]): void;
}