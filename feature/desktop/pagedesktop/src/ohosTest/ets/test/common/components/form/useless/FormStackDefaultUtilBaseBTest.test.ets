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
import { FormStackDefaultUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDefaultUtil';

export function FormStackDefaultUtilTest() {
  describe('FormStackDefaultUtilTest', () => {
    it('FormStackDefaultUtil_001', 0,() => {
      expect(FormStackDefaultUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDefaultUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDefaultUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDefaultUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDefaultUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDefaultUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDefaultUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDefaultUtil_002', 0, () => {
      expect(FormStackDefaultUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDefaultUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDefaultUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDefaultUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDefaultUtil_003', 0, () => {
      expect(FormStackDefaultUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDefaultUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDefaultUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDefaultUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDefaultUtil_004', 0, () => {
      expect(FormStackDefaultUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDefaultUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDefaultUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDefaultUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDefaultUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDefaultUtil_005', 0, () => {
      expect(FormStackDefaultUtil.isNumber("")).assertFalse();
      expect(FormStackDefaultUtil.isNumber(null)).assertFalse();
      expect(FormStackDefaultUtil.isNumber(undefined)).assertFalse();
      expect(FormStackDefaultUtil.isNumber("abc")).assertFalse();
      expect(FormStackDefaultUtil.isNumber("123")).assertTrue();
    });

    it('FormStackDefaultUtil_006', 0, () => {
      expect(FormStackDefaultUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDefaultUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDefaultUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDefaultUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDefaultUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDefaultUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDefaultUtil_007', 0, () => {
      expect(FormStackDefaultUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackDefaultUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDefaultUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackDefaultUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDefaultUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDefaultUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDefaultUtil_008', 0, () => {
      expect(FormStackDefaultUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDefaultUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDefaultUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDefaultUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDefaultUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDefaultUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDefaultUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDefaultUtil_009', 0, () => {
      expect(FormStackDefaultUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDefaultUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDefaultUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDefaultUtil_010', 0, () => {
      expect(FormStackDefaultUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDefaultUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDefaultUtil_011', 0, () => {
      expect(FormStackDefaultUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDefaultUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDefaultUtil_012', 0, () => {
      expect(FormStackDefaultUtil.checkArr([]) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(null) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDefaultUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDefaultUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackDefaultUtil_013', 0, () => {
      expect(FormStackDefaultUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDefaultUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDefaultUtil_014', 0, () => {
      expect(FormStackDefaultUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDefaultUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDefaultUtil_015', 0, () => {
      expect(FormStackDefaultUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDefaultUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDefaultUtil_016', 0, () => {
      expect(FormStackDefaultUtil.isEmpty(null)).assertTrue();
      expect(FormStackDefaultUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackDefaultUtil.isEmpty('')).assertTrue();
      expect(FormStackDefaultUtil.isEmpty(0)).assertTrue();
      expect(FormStackDefaultUtil.isEmpty([])).assertTrue();
      expect(FormStackDefaultUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackDefaultUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDefaultUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackDefaultUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDefaultUtil_017', 0, () => {
      expect(FormStackDefaultUtil.equals(null, 'a')).assertFalse();
      expect(FormStackDefaultUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackDefaultUtil.equals('a', null)).assertFalse();
      expect(FormStackDefaultUtil.equals('a', undefined)).assertFalse();
      expect(FormStackDefaultUtil.equals('a', 1)).assertFalse();
      expect(FormStackDefaultUtil.equals(1, 'a')).assertFalse();
      expect(FormStackDefaultUtil.equals(1, [])).assertFalse();
      expect(FormStackDefaultUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDefaultUtil.equals([], m)).assertFalse();
      expect(FormStackDefaultUtil.equals(m, [])).assertFalse();
      expect(FormStackDefaultUtil.equals([1,2], [])).assertFalse();
      expect(FormStackDefaultUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackDefaultUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackDefaultUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDefaultUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDefaultUtil.equals(2, 2)).assertTrue();
    })
  });
}