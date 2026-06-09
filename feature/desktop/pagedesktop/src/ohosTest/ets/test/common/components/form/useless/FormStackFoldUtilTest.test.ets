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
import { FormStackViewFoldUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewFoldUtil';

export function FormStackViewFoldUtilTest() {
  describe('FormStackViewFoldUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewFoldUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewFoldUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewFoldUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewFoldUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewFoldUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewFoldUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewFoldUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewFoldUtil_002', 0, () => {
      expect(FormStackViewFoldUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewFoldUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewFoldUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewFoldUtil_003', 0, () => {
      expect(FormStackViewFoldUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewFoldUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewFoldUtil_004', 0, () => {
      expect(FormStackViewFoldUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewFoldUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewFoldUtil_005', 0, () => {
      expect(FormStackViewFoldUtil.isNumber("")).assertFalse();
      expect(FormStackViewFoldUtil.isNumber(null)).assertFalse();
      expect(FormStackViewFoldUtil.isNumber(undefined)).assertFalse();
      expect(FormStackViewFoldUtil.isNumber("abc")).assertFalse();
      expect(FormStackViewFoldUtil.isNumber("123")).assertTrue();
    });

    it('FormStackViewFoldUtil_006', 0, () => {
      expect(FormStackViewFoldUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewFoldUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewFoldUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewFoldUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewFoldUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewFoldUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewFoldUtil_007', 0, () => {
      expect(FormStackViewFoldUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewFoldUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewFoldUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackViewFoldUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewFoldUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewFoldUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewFoldUtil_008', 0, () => {
      expect(FormStackViewFoldUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewFoldUtil_009', 0, () => {
      expect(FormStackViewFoldUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewFoldUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewFoldUtil_010', 0, () => {
      expect(FormStackViewFoldUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewFoldUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewFoldUtil_011', 0, () => {
      expect(FormStackViewFoldUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewFoldUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewFoldUtil_012', 0, () => {
      expect(FormStackViewFoldUtil.checkArr([]) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(null) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewFoldUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewFoldUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewFoldUtil_013', 0, () => {
      expect(FormStackViewFoldUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewFoldUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewFoldUtil_014', 0, () => {
      expect(FormStackViewFoldUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewFoldUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewFoldUtil_015', 0, () => {
      expect(FormStackViewFoldUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewFoldUtil_016', 0, () => {
      expect(FormStackViewFoldUtil.isEmpty(null)).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty('')).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty(0)).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty([])).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackViewFoldUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewFoldUtil_017', 0, () => {
      expect(FormStackViewFoldUtil.equals(null, 'a')).assertFalse();
      expect(FormStackViewFoldUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewFoldUtil.equals('a', null)).assertFalse();
      expect(FormStackViewFoldUtil.equals('a', undefined)).assertFalse();
      expect(FormStackViewFoldUtil.equals('a', 1)).assertFalse();
      expect(FormStackViewFoldUtil.equals(1, 'a')).assertFalse();
      expect(FormStackViewFoldUtil.equals(1, [])).assertFalse();
      expect(FormStackViewFoldUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewFoldUtil.equals([], m)).assertFalse();
      expect(FormStackViewFoldUtil.equals(m, [])).assertFalse();
      expect(FormStackViewFoldUtil.equals([1,2], [])).assertFalse();
      expect(FormStackViewFoldUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackViewFoldUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewFoldUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewFoldUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewFoldUtil.equals(2, 2)).assertTrue();
    })
  });
}