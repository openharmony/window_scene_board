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
import { FormStackViewPushUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewPushUtil';

export function FormStackViewPushUtilTest() {
  describe('FormStackViewPushUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewPushUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewPushUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewPushUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewPushUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewPushUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewPushUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewPushUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewPushUtil_002', 0, () => {
      expect(FormStackViewPushUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewPushUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewPushUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewPushUtil_003', 0, () => {
      expect(FormStackViewPushUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPushUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewPushUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewPushUtil_004', 0, () => {
      expect(FormStackViewPushUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPushUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewPushUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewPushUtil_005', 0, () => {
      expect(FormStackViewPushUtil.isNumber("")).assertFalse();
      expect(FormStackViewPushUtil.isNumber(null)).assertFalse();
      expect(FormStackViewPushUtil.isNumber(undefined)).assertFalse();
      expect(FormStackViewPushUtil.isNumber("abc")).assertFalse();
      expect(FormStackViewPushUtil.isNumber("123")).assertTrue();
    });

    it('FormStackViewPushUtil_006', 0, () => {
      expect(FormStackViewPushUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewPushUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewPushUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewPushUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewPushUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewPushUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewPushUtil_007', 0, () => {
      expect(FormStackViewPushUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewPushUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewPushUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackViewPushUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewPushUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewPushUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewPushUtil_008', 0, () => {
      expect(FormStackViewPushUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewPushUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewPushUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewPushUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewPushUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewPushUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewPushUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewPushUtil_009', 0, () => {
      expect(FormStackViewPushUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewPushUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewPushUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewPushUtil_010', 0, () => {
      expect(FormStackViewPushUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewPushUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewPushUtil_011', 0, () => {
      expect(FormStackViewPushUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewPushUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewPushUtil_012', 0, () => {
      expect(FormStackViewPushUtil.checkArr([]) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(null) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewPushUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewPushUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewPushUtil_013', 0, () => {
      expect(FormStackViewPushUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewPushUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewPushUtil_014', 0, () => {
      expect(FormStackViewPushUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewPushUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewPushUtil_015', 0, () => {
      expect(FormStackViewPushUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewPushUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewPushUtil_016', 0, () => {
      expect(FormStackViewPushUtil.isEmpty(null)).assertTrue();
      expect(FormStackViewPushUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackViewPushUtil.isEmpty('')).assertTrue();
      expect(FormStackViewPushUtil.isEmpty(0)).assertTrue();
      expect(FormStackViewPushUtil.isEmpty([])).assertTrue();
      expect(FormStackViewPushUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackViewPushUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewPushUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackViewPushUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewPushUtil_017', 0, () => {
      expect(FormStackViewPushUtil.equals(null, 'a')).assertFalse();
      expect(FormStackViewPushUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewPushUtil.equals('a', null)).assertFalse();
      expect(FormStackViewPushUtil.equals('a', undefined)).assertFalse();
      expect(FormStackViewPushUtil.equals('a', 1)).assertFalse();
      expect(FormStackViewPushUtil.equals(1, 'a')).assertFalse();
      expect(FormStackViewPushUtil.equals(1, [])).assertFalse();
      expect(FormStackViewPushUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewPushUtil.equals([], m)).assertFalse();
      expect(FormStackViewPushUtil.equals(m, [])).assertFalse();
      expect(FormStackViewPushUtil.equals([1,2], [])).assertFalse();
      expect(FormStackViewPushUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackViewPushUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewPushUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewPushUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewPushUtil.equals(2, 2)).assertTrue();
    })
  });
}