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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import FormRemoteUtils from '@ohos/screenlockwidget/src/main/ets/form/remote/FormRemoteUtils';
import { rpc } from '@kit.IPCKit';

export default function FormRemoteUtilsTest() {

  describe('FormRemoteUtilsTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('FormRemoteUtils_WriteStringInSegments_001', Level.LEVEL0, () => {
      let data: rpc.MessageSequence = new rpc.MessageSequence();
      let msg: string = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-RqTG4rhDiQEeeNv4DYoOOh-Z-WjFB2N3-g&s';
      let result = FormRemoteUtils.writeStringInSegments(data, msg);
      expect(result).not().assertNull();
    })

    it('FormRemoteUtils_WriteStringInSegments_002', Level.LEVEL0, () => {
      let data: rpc.MessageSequence = new rpc.MessageSequence();
      let msg: string = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNT4adJ0TUafFcE_yz44GUWgLI1ByPewPBYg&s';
      let result = FormRemoteUtils.writeStringInSegments(data, msg);
      expect(result).assertTrue();
    })

    it('FormRemoteUtils_WriteStringInSegments_003', Level.LEVEL0, () => {
      let data: rpc.MessageSequence = new rpc.MessageSequence();
      let msg: string = '';
      let result = FormRemoteUtils.writeStringInSegments(data, msg);
      expect(result).assertTrue();
    })

    it('FormRemoteUtils_getRemoteString_001', Level.LEVEL0, () => {
      let data: rpc.MessageSequence = new rpc.MessageSequence();
      let result = FormRemoteUtils.getRemoteString(data);
      expect(result).not().assertNull();
    })
  })
}