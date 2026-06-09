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

import { expect } from '@ohos/hypium';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

export namespace AssertUtils {
  /**
   * 调用样例：
   * await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().factoryReset(),RemoteCode
   * .ERR_ILLEGAL_CALLER);
   * @param actualValue 实际值
   * @param expectValue 预测值
   */
  export async function expectErrorCode(actualValue: () => Promise<Object | undefined | null | void>,
    expectValue: number): Promise<void> {
    let throwExcept: boolean = false;
    try {
      await actualValue();
    } catch (err) {
      throwExcept = true;
      expect(err.code).assertEqual(expectValue);
    }
    expect(throwExcept).assertTrue();
  }

  /**
   * 测试并发调用
   * @param actualValue 实际值
   * @param expectValue 预测值
   */
  export async function expectParallelInvoke(actualValue: () => Promise<Object | undefined | null | void>,
    expectValue: number = RemoteCode.ERR_OVER_FREQUENCY): Promise<void> {
    return expectErrorCode(() => Promise.all([actualValue(), actualValue()]), expectValue);
  }

  /**
   * 测试并发调用Boolean
   * @param actualValue 实际值
   * @param expectValue 预测值
   */
  export async function expectParallelInvokeBoolean(actualValue: () => Promise<boolean>,
    expectValue: boolean = false): Promise<void> {
    let result: [boolean, boolean] = await Promise.all([actualValue(), actualValue()]);
    expect(result[0] && result[1]).assertEqual(expectValue);
  }
}