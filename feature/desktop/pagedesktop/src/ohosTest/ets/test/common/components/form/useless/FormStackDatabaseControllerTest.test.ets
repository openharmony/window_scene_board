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
import { FormStackDatabaseController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseController';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseController.isNumber("")).assertFalse();
      expect(FormStackDatabaseController.isNumber(null)).assertFalse();
      expect(FormStackDatabaseController.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseController.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseController.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseController.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseController.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseController.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseController.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseController.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseController.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseController.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseController.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseController.isEmpty('')).assertTrue();
      expect(FormStackDatabaseController.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseController.isEmpty([])).assertTrue();
      expect(FormStackDatabaseController.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseController.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseController.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseController.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseController.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseController.equals('a', null)).assertFalse();
      expect(FormStackDatabaseController.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseController.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseController.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseController.equals(1, [])).assertFalse();
      expect(FormStackDatabaseController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseController.equals([], m)).assertFalse();
      expect(FormStackDatabaseController.equals(m, [])).assertFalse();
      expect(FormStackDatabaseController.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseController.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseController.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseController.equals(2, 2)).assertTrue();
    })
  });
}