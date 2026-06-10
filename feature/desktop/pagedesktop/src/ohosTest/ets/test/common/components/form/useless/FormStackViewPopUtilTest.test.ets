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
import { FormStackViewPopUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewPopUtil';

export function FormStackViewPopUtilTest() {
  describe('FormStackViewPopUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewPopUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewPopUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewPopUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewPopUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewPopUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewPopUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewPopUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewPopUtil_002', 0, () => {
      expect(FormStackViewPopUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewPopUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewPopUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewPopUtil_003', 0, () => {
      expect(FormStackViewPopUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPopUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewPopUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewPopUtil_004', 0, () => {
      expect(FormStackViewPopUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPopUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewPopUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewPopUtil_005', 0, () => {
      expect(FormStackViewPopUtil.isNumber("")).assertFalse();
      expect(FormStackViewPopUtil.isNumber(null)).assertFalse();
      expect(FormStackViewPopUtil.isNumber(undefined)).assertFalse();
      expect(FormStackViewPopUtil.isNumber("abc")).assertFalse();
      expect(FormStackViewPopUtil.isNumber("123")).assertTrue();
    });

    it('FormStackViewPopUtil_006', 0, () => {
      expect(FormStackViewPopUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewPopUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewPopUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewPopUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewPopUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewPopUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewPopUtil_007', 0, () => {
      expect(FormStackViewPopUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewPopUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewPopUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackViewPopUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewPopUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewPopUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewPopUtil_008', 0, () => {
      expect(FormStackViewPopUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewPopUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewPopUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewPopUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewPopUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewPopUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewPopUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewPopUtil_009', 0, () => {
      expect(FormStackViewPopUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewPopUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewPopUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewPopUtil_010', 0, () => {
      expect(FormStackViewPopUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewPopUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewPopUtil_011', 0, () => {
      expect(FormStackViewPopUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewPopUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewPopUtil_012', 0, () => {
      expect(FormStackViewPopUtil.checkArr([]) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(null) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewPopUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewPopUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewPopUtil_013', 0, () => {
      expect(FormStackViewPopUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewPopUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewPopUtil_014', 0, () => {
      expect(FormStackViewPopUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewPopUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewPopUtil_015', 0, () => {
      expect(FormStackViewPopUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewPopUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewPopUtil_016', 0, () => {
      expect(FormStackViewPopUtil.isEmpty(null)).assertTrue();
      expect(FormStackViewPopUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackViewPopUtil.isEmpty('')).assertTrue();
      expect(FormStackViewPopUtil.isEmpty(0)).assertTrue();
      expect(FormStackViewPopUtil.isEmpty([])).assertTrue();
      expect(FormStackViewPopUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackViewPopUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewPopUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackViewPopUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewPopUtil_017', 0, () => {
      expect(FormStackViewPopUtil.equals(null, 'a')).assertFalse();
      expect(FormStackViewPopUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewPopUtil.equals('a', null)).assertFalse();
      expect(FormStackViewPopUtil.equals('a', undefined)).assertFalse();
      expect(FormStackViewPopUtil.equals('a', 1)).assertFalse();
      expect(FormStackViewPopUtil.equals(1, 'a')).assertFalse();
      expect(FormStackViewPopUtil.equals(1, [])).assertFalse();
      expect(FormStackViewPopUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewPopUtil.equals([], m)).assertFalse();
      expect(FormStackViewPopUtil.equals(m, [])).assertFalse();
      expect(FormStackViewPopUtil.equals([1,2], [])).assertFalse();
      expect(FormStackViewPopUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackViewPopUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewPopUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewPopUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewPopUtil.equals(2, 2)).assertTrue();
    })
  });
}