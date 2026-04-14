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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, when,MockKit} from '@ohos/hypium'
import { CommonUtil } from '../../../../../main/ets/TsIndex'
export default function CommonUtilTest() {
  describe('CommonUtilTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('CommonUtilTest_constrain', 0, () => {
      CommonUtil.constrain(10,20,30);
      CommonUtil.constrain(20,10,12);
      let result = CommonUtil.constrain(20,10,30);
      expect(result).not().assertNull();
    })

    it('CommonUtilTest_removeColorCapacity', 0, () => {
      CommonUtil.removeColorCapacity('#111');
      let result = CommonUtil.removeColorCapacity('');
      CommonUtil.removeColorCapacity('rgba(255,166,255,0.5)');
      CommonUtil.loadImageFromDisk('/test')
      expect(result).not().assertNull();
    })

    it('CommonUtilTest_isAllPropertyEquals', 0, () => {
      CommonUtil.isAllPropertyEquals({a:{c:1}},{a:{c:2}});
      let result = CommonUtil.isAllPropertyEquals({a:{c:1}},{a:{c:1}});
      CommonUtil.isAllPropertyEquals({a:[1,3,5]},{a:[1,2]});
      CommonUtil.isAllPropertyEquals({a:[1,3,5]},{a:[1,3]});
      expect(result).not().assertNull();
    })

    it('CommonUtilTest_uint8ArrayToString', 0, () => {
      let utf8 = new Uint8Array([12,13]);
      CommonUtil.uint8ArrayToString();
      CommonUtil.uint8ArrayToString(new Uint8Array());
      let result = CommonUtil.uint8ArrayToString(utf8);
      expect(result).not().assertNull();
    })
  })
}