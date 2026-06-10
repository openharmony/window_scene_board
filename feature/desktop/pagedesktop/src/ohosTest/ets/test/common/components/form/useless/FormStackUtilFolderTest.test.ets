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
import { FormStackUtilFolder } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilFolder';

export function FormStackUtilFolderTest() {
  describe('FormStackUtilFolderTest', () => {
    it('FormStackUtilFolder_001', 0, () => {
      expect(FormStackUtilFolder.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilFolder.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilFolder.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilFolder.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilFolder.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilFolder.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilFolder.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilFolder_002', 0, () => {
      expect(FormStackUtilFolder.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilFolder.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilFolder.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilFolder.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilFolder_003', 0, () => {
      expect(FormStackUtilFolder.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilFolder.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilFolder.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilFolder.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilFolder_004', 0, () => {
      expect(FormStackUtilFolder.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilFolder.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilFolder.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilFolder.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilFolder.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilFolder_005', 0, () => {
      expect(FormStackUtilFolder.isNumber("")).assertFalse();
      expect(FormStackUtilFolder.isNumber(null)).assertFalse();
      expect(FormStackUtilFolder.isNumber(undefined)).assertFalse();
      expect(FormStackUtilFolder.isNumber("abc")).assertFalse();
      expect(FormStackUtilFolder.isNumber("123")).assertTrue();
    });

    it('FormStackUtilFolder_006', 0, () => {
      expect(FormStackUtilFolder.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilFolder.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilFolder.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilFolder.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilFolder.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilFolder.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilFolder_007', 0, () => {
      expect(FormStackUtilFolder.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilFolder.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilFolder.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilFolder.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilFolder.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilFolder.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilFolder_008', 0, () => {
      expect(FormStackUtilFolder.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilFolder.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilFolder.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilFolder.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilFolder.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilFolder.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilFolder.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilFolder_009', 0, () => {
      expect(FormStackUtilFolder.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilFolder.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilFolder.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilFolder_010', 0, () => {
      expect(FormStackUtilFolder.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilFolder.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilFolder_011', 0, () => {
      expect(FormStackUtilFolder.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilFolder.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilFolder_012', 0, () => {
      expect(FormStackUtilFolder.checkArr([]) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(null) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilFolder.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilFolder.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilFolder_013', 0, () => {
      expect(FormStackUtilFolder.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilFolder.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilFolder_014', 0, () => {
      expect(FormStackUtilFolder.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilFolder.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilFolder_015', 0, () => {
      expect(FormStackUtilFolder.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilFolder.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilFolder_016', 0, () => {
      expect(FormStackUtilFolder.isEmpty(null)).assertTrue();
      expect(FormStackUtilFolder.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilFolder.isEmpty('')).assertTrue();
      expect(FormStackUtilFolder.isEmpty(0)).assertTrue();
      expect(FormStackUtilFolder.isEmpty([])).assertTrue();
      expect(FormStackUtilFolder.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilFolder.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilFolder.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilFolder.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilFolder_017', 0, () => {
      expect(FormStackUtilFolder.equals(null, 'a')).assertFalse();
      expect(FormStackUtilFolder.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilFolder.equals('a', null)).assertFalse();
      expect(FormStackUtilFolder.equals('a', undefined)).assertFalse();
      expect(FormStackUtilFolder.equals('a', 1)).assertFalse();
      expect(FormStackUtilFolder.equals(1, 'a')).assertFalse();
      expect(FormStackUtilFolder.equals(1, [])).assertFalse();
      expect(FormStackUtilFolder.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilFolder.equals([], m)).assertFalse();
      expect(FormStackUtilFolder.equals(m, [])).assertFalse();
      expect(FormStackUtilFolder.equals([1,2], [])).assertFalse();
      expect(FormStackUtilFolder.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilFolder.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilFolder.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilFolder.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilFolder.equals(2, 2)).assertTrue();
    })
  });
}