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
import { describe, expect, it } from '@ohos/hypium';
import { FormDataUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormDataUtil';

export function FormDataUtilTest() {
  describe('FormDataUtilTest', () => {
    it('FormDataUtil_001', 0, () => {
      expect(FormDataUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormDataUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDataUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDataUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormDataUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormDataUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDataUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDataUtil_002', 0, () => {
      expect(FormDataUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDataUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDataUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDataUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDataUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDataUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDataUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDataUtil_003', 0, () => {
      expect(FormDataUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDataUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDataUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDataUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDataUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDataUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDataUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDataUtil_004', 0, () => {
      expect(FormDataUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDataUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDataUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDataUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDataUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDataUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDataUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDataUtil_005', 0, () => {
      expect(FormDataUtil.isNumber("")).assertFalse();
      expect(FormDataUtil.isNumber(null)).assertFalse();
      expect(FormDataUtil.isNumber(undefined)).assertFalse();
      expect(FormDataUtil.isNumber("abc")).assertFalse();
      expect(FormDataUtil.isNumber("123")).assertTrue();
    });

    it('FormDataUtil_006', 0, () => {
      expect(FormDataUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDataUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDataUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDataUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDataUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDataUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDataUtil_007', 0, () => {
      expect(FormDataUtil.getDefaultId(null) === null).assertTrue();
      expect(FormDataUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDataUtil.getDefaultId('') === '').assertTrue();
      expect(FormDataUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormDataUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDataUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDataUtil_008', 0, () => {
      expect(FormDataUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormDataUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDataUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDataUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDataUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDataUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDataUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDataUtil_009', 0, () => {
      expect(FormDataUtil.drawFontWidth() === -1).assertTrue();
      expect(FormDataUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormDataUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormDataUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormDataUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormDataUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormDataUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormDataUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormDataUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormDataUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormDataUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDataUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDataUtil_010', 0, () => {
      expect(FormDataUtil.drawTextAlign() === -1).assertTrue();
      expect(FormDataUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormDataUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormDataUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormDataUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormDataUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormDataUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormDataUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDataUtil_011', 0, () => {
      expect(FormDataUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDataUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDataUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDataUtil_012', 0, () => {
      expect(FormDataUtil.checkArr([]) === false).assertTrue();
      expect(FormDataUtil.checkArr(null) === false).assertTrue();
      expect(FormDataUtil.checkArr(undefined) === false).assertTrue();
      expect(FormDataUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDataUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDataUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormDataUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDataUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDataUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDataUtil.getUUID().length > 0).assertTrue();
    })

    it('FormDataUtil_013', 0, () => {
      expect(FormDataUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDataUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDataUtil_014', 0, () => {
      expect(FormDataUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormDataUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDataUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormDataUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDataUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDataUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDataUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormDataUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDataUtil_015', 0, () => {
      expect(FormDataUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormDataUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDataUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();

    })
  });
}