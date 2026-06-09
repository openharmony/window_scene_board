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
import { FormStackDeleteUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDeleteUtil';

export function FormStackDeleteUtilTest() {
  describe('FormStackDeleteUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackDeleteUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDeleteUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDeleteUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDeleteUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDeleteUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDeleteUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDeleteUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDeleteUtil_002', 0, () => {
      expect(FormStackDeleteUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDeleteUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDeleteUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDeleteUtil_003', 0, () => {
      expect(FormStackDeleteUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDeleteUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDeleteUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDeleteUtil_004', 0, () => {
      expect(FormStackDeleteUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDeleteUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDeleteUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDeleteUtil_005', 0, () => {
      expect(FormStackDeleteUtil.isNumber("")).assertFalse();
      expect(FormStackDeleteUtil.isNumber(null)).assertFalse();
      expect(FormStackDeleteUtil.isNumber(undefined)).assertFalse();
      expect(FormStackDeleteUtil.isNumber("abc")).assertFalse();
      expect(FormStackDeleteUtil.isNumber("123")).assertTrue();
    });

    it('FormStackDeleteUtil_006', 0, () => {
      expect(FormStackDeleteUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDeleteUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDeleteUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDeleteUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDeleteUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDeleteUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDeleteUtil_007', 0, () => {
      expect(FormStackDeleteUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackDeleteUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDeleteUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackDeleteUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDeleteUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDeleteUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDeleteUtil_008', 0, () => {
      expect(FormStackDeleteUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDeleteUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDeleteUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDeleteUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDeleteUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDeleteUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDeleteUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDeleteUtil_009', 0, () => {
      expect(FormStackDeleteUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDeleteUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDeleteUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDeleteUtil_010', 0, () => {
      expect(FormStackDeleteUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDeleteUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDeleteUtil_011', 0, () => {
      expect(FormStackDeleteUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDeleteUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDeleteUtil_012', 0, () => {
      expect(FormStackDeleteUtil.checkArr([]) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(null) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDeleteUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDeleteUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackDeleteUtil_013', 0, () => {
      expect(FormStackDeleteUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDeleteUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDeleteUtil_014', 0, () => {
      expect(FormStackDeleteUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDeleteUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDeleteUtil_015', 0, () => {
      expect(FormStackDeleteUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDeleteUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDeleteUtil_016', 0, () => {
      expect(FormStackDeleteUtil.isEmpty(null)).assertTrue();
      expect(FormStackDeleteUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackDeleteUtil.isEmpty('')).assertTrue();
      expect(FormStackDeleteUtil.isEmpty(0)).assertTrue();
      expect(FormStackDeleteUtil.isEmpty([])).assertTrue();
      expect(FormStackDeleteUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackDeleteUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDeleteUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackDeleteUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDeleteUtil_017', 0, () => {
      expect(FormStackDeleteUtil.equals(null, 'a')).assertFalse();
      expect(FormStackDeleteUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackDeleteUtil.equals('a', null)).assertFalse();
      expect(FormStackDeleteUtil.equals('a', undefined)).assertFalse();
      expect(FormStackDeleteUtil.equals('a', 1)).assertFalse();
      expect(FormStackDeleteUtil.equals(1, 'a')).assertFalse();
      expect(FormStackDeleteUtil.equals(1, [])).assertFalse();
      expect(FormStackDeleteUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDeleteUtil.equals([], m)).assertFalse();
      expect(FormStackDeleteUtil.equals(m, [])).assertFalse();
      expect(FormStackDeleteUtil.equals([1,2], [])).assertFalse();
      expect(FormStackDeleteUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackDeleteUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackDeleteUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDeleteUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDeleteUtil.equals(2, 2)).assertTrue();
    })
  });
}