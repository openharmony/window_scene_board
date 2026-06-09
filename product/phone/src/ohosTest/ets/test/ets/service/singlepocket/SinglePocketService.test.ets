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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
} from '@ohos/hypium';
import {
  SinglePocketService
} from '@ohos/phonebase/src/main/ets/service/singlepocket/SinglePocketService';
import { CallResult } from '@ohos/phonebase/src/main/ets/service/singlepocket/executor/IExecutor';

/**
 * SinglePocketService DT测试套
 */
export default function SinglePocketServiceTest() {
  describe('SinglePocketServiceTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('SinglePocketService_onCall_return_invalid_method', Level.LEVEL0, async (done: Function) => {
      let singlePocketService: SinglePocketService = new SinglePocketService();
      expect(singlePocketService).not().assertNull();
      done();
    })

    it('SinglePocketService_onCall_return_unknown_method', Level.LEVEL0, async (done: Function) => {
      let singlePocketService: SinglePocketService = new SinglePocketService();
      expect(singlePocketService).not().assertNull();
      let result: string = await singlePocketService.onCall('{"method":"test"}');
      expect(result).assertEqual(CallResult.UNKNOWN_METHOD);
      done();
    })

    it('should_return_FAIL_when_json_is_invalid', 0, async (done: Function) => {
      let singlePocketService = new SinglePocketService();
      const result = await singlePocketService.onCall("invalid_json");
      expect(result).assertEqual(CallResult.FAIL);
      done();
    });

    it('should_return_INVALID_METHOD_when_method_is_undefined', 0, async (done: Function) => {
      let singlePocketService = new SinglePocketService();
      const result = await singlePocketService.onCall(JSON.stringify({
        extra: true
      }));
      expect(result).assertEqual(CallResult.INVALID_METHOD);
      done();
    });

    it('should_return_UNKNOWN_METHOD_when_executor_is_undefined', 0, async (done: Function) => {
      let singlePocketService = new SinglePocketService();
      const result = await singlePocketService.onCall(JSON.stringify({
        method: "unknown_method", extra: true
      }));
      expect(result).assertEqual(CallResult.UNKNOWN_METHOD);
      done();
    });
  })
}