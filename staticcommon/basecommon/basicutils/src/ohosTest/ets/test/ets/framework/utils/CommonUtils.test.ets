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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { CommonUtils,Rect } from '../../../../../../main/ets/utils/CommonUtils';
import { Equality } from '../../../../../../main/ets/utils/Equality';

const testRect1:Rect = {
  left:0,
  top:0,
  width:0,
  height:0
}
const testRect2:Rect = {
  left:1,
  top:1,
  width:1,
  height:1
}

export function CommonUtilTest() {
  describe('CommonUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('CommonUtilTest_isInvalid', 0, (): void => {
      expect(CommonUtils.isInvalid(null)).assertTrue();
      expect(CommonUtils.isInvalid('test')).assertFalse();
    })
    it('CommonUtilTest_isEmpty', 0, (): void => {
      expect(CommonUtils.isEmpty('')).assertTrue();
      expect(CommonUtils.isEmpty(' ')).assertTrue();
      expect(CommonUtils.isEmpty('test')).assertFalse();
    })
    it('CommonUtilTest_isNumber', 0, (): void => {
      expect(CommonUtils.isNumber(0)).assertTrue();
      expect(CommonUtils.isNumber('test')).assertFalse();
    })
    it('CommonUtilTest_isNumber_instanceof_Number', 0, (): void => {
      let num:Number = new Number(0);
      expect(CommonUtils.isNumber(num)).assertTrue();
    })
    it('CommonUtilTest_isBoolean', 0, (): void => {
      expect(CommonUtils.isBoolean(true)).assertTrue();
      expect(CommonUtils.isBoolean('test')).assertFalse();
    })
    it('CommonUtilTest_isBoolean_instanceof_Boolean', 0, (): void => {
      let bool: Boolean = new Boolean(true);
      expect(CommonUtils.isBoolean(bool)).assertTrue();
    })
    it('CommonUtilTest_isString', 0, (): void => {
      expect(CommonUtils.isString('test')).assertTrue();
      expect(CommonUtils.isString(0)).assertFalse();
    })
    it('CommonUtilTest_isBoolean_instanceof_String', 0, (): void => {
      let str: String = new String('test');
      expect(CommonUtils.isString(str)).assertTrue();
    })
    it('splicePx', 0, (): void => {
      expect(CommonUtils.splicePx(1)).assertEqual('1px')
    })
    it('spliceVp', 0, (): void => {
      expect(CommonUtils.spliceVp(1)).assertEqual('1vp')
    })
    it('CommonUtilTest_equals', 0, (): void => {
      let obj:Equality = {
        equals:(param: Object):boolean => true
      };
      let other:Equality = {
        equals:(param: Object):boolean => false
      };
      let mocker:MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CommonUtils, CommonUtils.isTypeEquality);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(CommonUtils.equals(obj,other)).assertInstanceOf('Boolean');
      mocker.clear(CommonUtils);
      mocker.clearAll();
    })
    it('CommonUtilTest_isTypeEquality', 0, (): void => {
      expect(CommonUtils.isTypeEquality(null)).assertFalse();
    })
    it('CommonUtilTest_isInvalidRect', 0, (): void => {
      expect(CommonUtils.isInvalidRect(testRect1)).assertInstanceOf('Boolean');
    })
    it('CommonUtilTest_equalsRect', 0, (): void => {
      expect(CommonUtils.equalsRect(testRect1,null)).assertTrue();
      expect(CommonUtils.equalsRect(testRect1,testRect2)).assertFalse();
    })
  })
}