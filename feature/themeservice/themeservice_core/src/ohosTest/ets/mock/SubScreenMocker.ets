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

import { ArgumentMatchers, MockKit, when } from '@ohos/hypium';
import { Singleton } from '@ohos/themeservicebase/Index';
import { DeviceHelper } from '../../../main/ets/util/DeviceHelper';

export class SubScreenMocker {
  private static readonly INSTANCE: Singleton<SubScreenMocker> =
    new Singleton<SubScreenMocker>(() => new SubScreenMocker());

  private readonly mocker: MockKit = new MockKit();

  private constructor() {
  }

  public static getInstance(): SubScreenMocker {
    return SubScreenMocker.INSTANCE.get();
  }

  public mockSubScreen() {
    let isSingleDisplayFoldProductFun: Function =
      this.mocker.mockFunc(DeviceHelper, DeviceHelper.isSingleDisplayFoldProduct);
    when(isSingleDisplayFoldProductFun)(ArgumentMatchers.any).afterReturn(true);
    let isSmallFoldProductFun: Function = this.mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
    when(isSmallFoldProductFun)(ArgumentMatchers.any).afterReturn(true);
  }

  public clear(): void {
    this.mocker.clear(DeviceHelper);
    this.mocker.clearAll();
  }
}