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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  ScbServiceRemoteObject
} from '../../../../../../main/ets/common/SCBServiceRemoteObject';
import rpc from '@ohos.rpc';

export default function ScbServiceRemoteObjectTest() {

  describe('ScbServiceRemoteObjectTest', (): void => {
    let mScbServiceRemoteObject: ScbServiceRemoteObject = new ScbServiceRemoteObject();
    let data: rpc.MessageSequence;
    let reply: rpc.MessageSequence;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_onRemoteMessageRequest_return', 0, (): void => {
      let code = 1;
      let data = 'res1';
      let reply = 'res2';
      let option = '';
      let result = mScbServiceRemoteObject.onRemoteMessageRequest(code, data, reply, option);
      expect(result).not().assertNull();
    })

    it('test_onRemoteMessageRequest_return_One', 0, (): void => {
      let code = 2;
      let data = 'res1';
      let reply = 'res2';
      let option = '';
      let result = mScbServiceRemoteObject.onRemoteMessageRequest(code, data, reply, option);
      expect(result).not().assertNull();
    })

    it('test_checkAppPermissions_return_Two', 0, (): void => {
      let result = mScbServiceRemoteObject.checkAppPermissions();
      expect(result).not().assertNull();
    })

    it('test_getWatermarkFromRawData_return_true', 0, (): void => {
      let result = mScbServiceRemoteObject.getWatermarkFromRawData(data, reply);
      expect(result).not().assertNull();
    })
  })
}