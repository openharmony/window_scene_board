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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  ArgumentMatchers,
  MockKit
} from '@ohos/hypium';
import {
  QueryAutoAlignStatus,
  SetAutoAlignStatus,
  Response
} from '../../../../../main/ets/default/service/impl/QueryAutoAlignStatus';
import { ShortcutInfo, ShortcutViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex';

export default function QueryAutoAlignStatusTest() {
  describe('QueryAutoAlignStatusTest', () => {
    let queryAutoAlignStatus: QueryAutoAlignStatus;
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      queryAutoAlignStatus = new QueryAutoAlignStatus();
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('QueryAutoAlignStatus_1', 0, async () => {
      const result = await queryAutoAlignStatus.execute();
      expect(result).assertEqual(Response.closeAutoAlign);
    });
  })
  describe('SetAutoAlignStatus', () => {
    let setAutoAlignStatus: SetAutoAlignStatus;
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      setAutoAlignStatus = new SetAutoAlignStatus();
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('SetAutoAlignStatus_1', 0, async () => {
      let extra: ExtraInfo = {
        setAutoAlign: 'true'
      };
      const result = await setAutoAlignStatus.execute(extra);
      expect(result).assertEqual(Response.openAutoAlign);
    });

    it('SetAutoAlignStatus_2', 0, async () => {
      let extra: ExtraInfo = {
        setAutoAlign: 'false'
      };
      const result = await setAutoAlignStatus.execute(extra);
      expect(result).assertEqual(Response.closeAutoAlign);
    });

  });
}

class ExtraInfo {
  /**
   * 开启或者关闭自动对齐
   */
  public setAutoAlign: string = '';
}