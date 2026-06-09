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
import { CommonUtil } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

export default function CommonUtilTest() {

  describe('CommonUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_runWithoutException', 0, (): void => {
      let executeFunc = () => {};
      CommonUtil.runWithoutException('1','1', executeFunc);
      executeFunc = () => {
        throw new Error('这是一个错误')
      };
      CommonUtil.runWithoutException('1','1', executeFunc);
      expect(true).assertTrue();
    })

    it('test_removeColorCapacity', 0, (): void => {
      CommonUtil.removeColorCapacity('');
      CommonUtil.removeColorCapacity('rgba(255,128,64');
      CommonUtil.removeColorCapacity('#ff8040');
      expect(true).assertTrue();
    })

    it('test_loadImageFromDisk', 0, (): void => {
      CommonUtil.loadImageFromDisk('');
      expect(true).assertTrue();
    })

    it('test_isAllPropertyEquals', 0, (): void => {
      interface obj {
        a: number
        b: number
      };
      let objA: obj = {
        a: 1,
        b: 2
      };
      let objB: obj = {
        a: 1,
        b: 2
      };
      CommonUtil.isAllPropertyEquals(objA, objB);
      objA = {} as obj;
      CommonUtil.isAllPropertyEquals(objA, objB);
      objA = {
        a: 1,
        b: 3
      };
      CommonUtil.isAllPropertyEquals(objA, objB);
      expect(true).assertTrue();
    })
  })
}