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

import { AbstractInitialAble } from '@ohos/screenlockcommon';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';

/**
 * 抽象事件适配器
 */
export abstract class AbstractEventAdapter extends AbstractInitialAble {
  private _fsmProxy: ScreenLockFsmProxy;

  constructor(fsmProxy: ScreenLockFsmProxy) {
    super();
    this._fsmProxy = fsmProxy;
  }

  protected get fsmProxy(): ScreenLockFsmProxy {
    return this._fsmProxy;
  }
}