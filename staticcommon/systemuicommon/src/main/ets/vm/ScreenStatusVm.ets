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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { Singleton } from '../utils/Singleton';

const log = LogHelper.getLogHelper(LogDomain.CC, 'ScreenStatusVm');

@ThreadSync.VmDecorator
@ObservedV2
export class ScreenStatusVm {
  @Singleton.decorate() static get instance() { return new ScreenStatusVm(); }

  /**
   * 锁屏状态
   */
  @Trace public lockStatus: number = 0;

  /**
   * 获取是否使用重构后的锁屏逻辑
   */
  @Trace public isUseNewScreenLock: boolean | undefined = true;

  /**
   * 是否横屏
   */
  @Trace public isLandscape: boolean = false;

  /**
   * 小折叠状态栏
   */
  @Trace public foldStatusForOuterScreen: number = 0;

  /**
   * 小折叠状态栏
   */
  @Trace public autoRotateStatus: boolean = false;

  constructor() { }
}