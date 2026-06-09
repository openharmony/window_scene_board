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
import { FormStackViewAnimateAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewAnimateAdapter';

export function FormStackViewAnimateAdapterTest() {
  describe('FormStackViewAnimateAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewAnimateAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewAnimateAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewAnimateAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewAnimateAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewAnimateAdapter_002', 0, () => {
      expect(FormStackViewAnimateAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewAnimateAdapter_003', 0, () => {
      expect(FormStackViewAnimateAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewAnimateAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewAnimateAdapter_004', 0, () => {
      expect(FormStackViewAnimateAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewAnimateAdapter_005', 0, () => {
      expect(FormStackViewAnimateAdapter.isNumber("")).assertFalse();
      expect(FormStackViewAnimateAdapter.isNumber(null)).assertFalse();
      expect(FormStackViewAnimateAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackViewAnimateAdapter.isNumber("abc")).assertFalse();
      expect(FormStackViewAnimateAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackViewAnimateAdapter_006', 0, () => {
      expect(FormStackViewAnimateAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewAnimateAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewAnimateAdapter_007', 0, () => {
      expect(FormStackViewAnimateAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewAnimateAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewAnimateAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewAnimateAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewAnimateAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewAnimateAdapter_008', 0, () => {
      expect(FormStackViewAnimateAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewAnimateAdapter_009', 0, () => {
      expect(FormStackViewAnimateAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewAnimateAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewAnimateAdapter_010', 0, () => {
      expect(FormStackViewAnimateAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewAnimateAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewAnimateAdapter_011', 0, () => {
      expect(FormStackViewAnimateAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewAnimateAdapter_012', 0, () => {
      expect(FormStackViewAnimateAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewAnimateAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewAnimateAdapter_013', 0, () => {
      expect(FormStackViewAnimateAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewAnimateAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewAnimateAdapter_014', 0, () => {
      expect(FormStackViewAnimateAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewAnimateAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewAnimateAdapter_015', 0, () => {
      expect(FormStackViewAnimateAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewAnimateAdapter_016', 0, () => {
      expect(FormStackViewAnimateAdapter.isEmpty(null)).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty('')).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty(0)).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty([])).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackViewAnimateAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewAnimateAdapter_017', 0, () => {
      expect(FormStackViewAnimateAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackViewAnimateAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewAnimateAdapter.equals('a', null)).assertFalse();
      expect(FormStackViewAnimateAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackViewAnimateAdapter.equals('a', 1)).assertFalse();
      expect(FormStackViewAnimateAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackViewAnimateAdapter.equals(1, [])).assertFalse();
      expect(FormStackViewAnimateAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewAnimateAdapter.equals([], m)).assertFalse();
      expect(FormStackViewAnimateAdapter.equals(m, [])).assertFalse();
      expect(FormStackViewAnimateAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackViewAnimateAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackViewAnimateAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewAnimateAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewAnimateAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewAnimateAdapter.equals(2, 2)).assertTrue();
    })
  });
}