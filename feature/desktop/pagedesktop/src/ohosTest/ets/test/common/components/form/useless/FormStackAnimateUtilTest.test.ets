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
import { FormStackViewAnimateUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewAnimateUtil';

export function FormStackViewAnimateUtilTest() {
  describe('FormStackViewAnimateUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewAnimateUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewAnimateUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewAnimateUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewAnimateUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewAnimateUtil_002', 0, () => {
      expect(FormStackViewAnimateUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewAnimateUtil_003', 0, () => {
      expect(FormStackViewAnimateUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewAnimateUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewAnimateUtil_004', 0, () => {
      expect(FormStackViewAnimateUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewAnimateUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewAnimateUtil_005', 0, () => {
      expect(FormStackViewAnimateUtil.isNumber("")).assertFalse();
      expect(FormStackViewAnimateUtil.isNumber(null)).assertFalse();
      expect(FormStackViewAnimateUtil.isNumber(undefined)).assertFalse();
      expect(FormStackViewAnimateUtil.isNumber("abc")).assertFalse();
      expect(FormStackViewAnimateUtil.isNumber("123")).assertTrue();
    });

    it('FormStackViewAnimateUtil_006', 0, () => {
      expect(FormStackViewAnimateUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewAnimateUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewAnimateUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewAnimateUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewAnimateUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewAnimateUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewAnimateUtil_007', 0, () => {
      expect(FormStackViewAnimateUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewAnimateUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewAnimateUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackViewAnimateUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewAnimateUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewAnimateUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewAnimateUtil_008', 0, () => {
      expect(FormStackViewAnimateUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewAnimateUtil_009', 0, () => {
      expect(FormStackViewAnimateUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewAnimateUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewAnimateUtil_010', 0, () => {
      expect(FormStackViewAnimateUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewAnimateUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewAnimateUtil_011', 0, () => {
      expect(FormStackViewAnimateUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewAnimateUtil_012', 0, () => {
      expect(FormStackViewAnimateUtil.checkArr([]) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(null) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewAnimateUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewAnimateUtil_013', 0, () => {
      expect(FormStackViewAnimateUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewAnimateUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewAnimateUtil_014', 0, () => {
      expect(FormStackViewAnimateUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewAnimateUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewAnimateUtil_015', 0, () => {
      expect(FormStackViewAnimateUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewAnimateUtil_016', 0, () => {
      expect(FormStackViewAnimateUtil.isEmpty(null)).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty('')).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty(0)).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty([])).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackViewAnimateUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewAnimateUtil_017', 0, () => {
      expect(FormStackViewAnimateUtil.equals(null, 'a')).assertFalse();
      expect(FormStackViewAnimateUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewAnimateUtil.equals('a', null)).assertFalse();
      expect(FormStackViewAnimateUtil.equals('a', undefined)).assertFalse();
      expect(FormStackViewAnimateUtil.equals('a', 1)).assertFalse();
      expect(FormStackViewAnimateUtil.equals(1, 'a')).assertFalse();
      expect(FormStackViewAnimateUtil.equals(1, [])).assertFalse();
      expect(FormStackViewAnimateUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewAnimateUtil.equals([], m)).assertFalse();
      expect(FormStackViewAnimateUtil.equals(m, [])).assertFalse();
      expect(FormStackViewAnimateUtil.equals([1,2], [])).assertFalse();
      expect(FormStackViewAnimateUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackViewAnimateUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewAnimateUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewAnimateUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewAnimateUtil.equals(2, 2)).assertTrue();
    })
  });
}