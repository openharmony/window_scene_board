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
import { describe, expect, it } from '@ohos/hypium';
import { FormDataUtilBeta } from '../../../../../../../main/ets/default/common/components/form/useless/FormDataUtilBeta';

export function FormDataUtilBetaTest() {
  describe('FormDataUtilTest', () => {
    it('FormDataUtil_001', 0, () => {
      expect(FormDataUtilBeta.getSum("", '1') === -1).assertEqual(true);
      expect(FormDataUtilBeta.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDataUtilBeta.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDataUtilBeta.getSum('1', '') === -1).assertEqual(true);
      expect(FormDataUtilBeta.getSum('1', null) === -1).assertEqual(true);
      expect(FormDataUtilBeta.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDataUtilBeta.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDataUtil_002', 0, () => {
      expect(FormDataUtilBeta.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDataUtilBeta.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDataUtilBeta.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDataUtilBeta.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDataUtil_003', 0, () => {
      expect(FormDataUtilBeta.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDataUtilBeta.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDataUtilBeta.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDataUtilBeta.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDataUtil_004', 0, () => {
      expect(FormDataUtilBeta.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDataUtilBeta.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDataUtilBeta.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDataUtilBeta.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDataUtilBeta.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDataUtil_005', 0, () => {
      expect(FormDataUtilBeta.isNumber("")).assertFalse();
      expect(FormDataUtilBeta.isNumber(null)).assertFalse();
      expect(FormDataUtilBeta.isNumber(undefined)).assertFalse();
      expect(FormDataUtilBeta.isNumber("abc")).assertFalse();
      expect(FormDataUtilBeta.isNumber("123")).assertTrue();
    });

    it('FormDataUtil_006', 0, () => {
      expect(FormDataUtilBeta.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDataUtilBeta.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDataUtilBeta.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDataUtilBeta.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDataUtilBeta.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDataUtilBeta.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDataUtil_007', 0, () => {
      expect(FormDataUtilBeta.getDefaultId(null) === null).assertTrue();
      expect(FormDataUtilBeta.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDataUtilBeta.getDefaultId('') === '').assertTrue();
      expect(FormDataUtilBeta.getDefaultId('default') !== '').assertTrue();
      expect(FormDataUtilBeta.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDataUtilBeta.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDataUtil_008', 0, () => {
      expect(FormDataUtilBeta.getIndexByString("", []) === -1).assertTrue();
      expect(FormDataUtilBeta.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDataUtilBeta.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDataUtilBeta.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDataUtilBeta.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDataUtilBeta.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDataUtilBeta.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDataUtil_009', 0, () => {
      expect(FormDataUtilBeta.drawFontWidth() === -1).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(100) === 1).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(200) === 2).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(300) === 3).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(400) === 4).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(500) === 6).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(600) === 7).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(700) === 8).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(800) === 9).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(900) === 1).assertTrue();
      expect(FormDataUtilBeta.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDataUtilBeta.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDataUtil_010', 0, () => {
      expect(FormDataUtilBeta.drawTextAlign() === -1).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(100) === 0).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(200) === 1).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(300) === 2).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(400) === 3).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(500) === 4).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(600) === 5).assertTrue();
      expect(FormDataUtilBeta.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDataUtil_011', 0, () => {
      expect(FormDataUtilBeta.getStringIndex('', '') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDataUtilBeta.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDataUtil_012', 0, () => {
      expect(FormDataUtilBeta.checkArr([]) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(null) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(undefined) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', '']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', null]) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDataUtilBeta.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDataUtilBeta.getUUID().length > 0).assertTrue();
    })

    it('FormDataUtil_013', 0, () => {
      expect(FormDataUtilBeta.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDataUtilBeta.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDataUtil_014', 0, () => {
      expect(FormDataUtilBeta.getBinaryData(null, '') === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData(2, null) === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData(0, '') === '').assertTrue();
      expect(FormDataUtilBeta.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDataUtil_015', 0, () => {
      expect(FormDataUtilBeta.getArraySum(null, []) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([], null) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDataUtilBeta.getArraySum([1, 1], [1, 1]) === 4).assertTrue();

    })
  });
}