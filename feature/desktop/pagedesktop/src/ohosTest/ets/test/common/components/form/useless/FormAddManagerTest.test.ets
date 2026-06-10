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
import { FormAddManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormAddManager';

export function FormAddManagerTest() {
  describe('FormAddManagerTest', () => {
    it('FormAddManager_001', 0, () => {
      expect(FormAddManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormAddManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAddManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAddManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormAddManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormAddManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAddManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddManager_002', 0, () => {
      expect(FormAddManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAddManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAddManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAddManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAddManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAddManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAddManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddManager_003', 0, () => {
      expect(FormAddManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAddManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAddManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAddManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAddManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAddManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAddManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddManager_004', 0, () => {
      expect(FormAddManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAddManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAddManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAddManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAddManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAddManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAddManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddManager_005', 0, () => {
      expect(FormAddManager.isNumber("")).assertFalse();
      expect(FormAddManager.isNumber(null)).assertFalse();
      expect(FormAddManager.isNumber(undefined)).assertFalse();
      expect(FormAddManager.isNumber("abc")).assertFalse();
      expect(FormAddManager.isNumber("123")).assertTrue();
    });

    it('FormAddManager_006', 0, () => {
      expect(FormAddManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAddManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAddManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAddManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAddManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAddManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddManager_007', 0, () => {
      expect(FormAddManager.getDefaultId(null) === null).assertTrue();
      expect(FormAddManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAddManager.getDefaultId('') === '').assertTrue();
      expect(FormAddManager.getDefaultId('default') !== '').assertTrue();
      expect(FormAddManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAddManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddManager_008', 0, () => {
      expect(FormAddManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormAddManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAddManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAddManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAddManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAddManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAddManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddManager_009', 0, () => {
      expect(FormAddManager.drawFontWidth() === -1).assertTrue();
      expect(FormAddManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormAddManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormAddManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormAddManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormAddManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormAddManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormAddManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormAddManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormAddManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormAddManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAddManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAddManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddManager_010', 0, () => {
      expect(FormAddManager.drawTextAlign() === -1).assertTrue();
      expect(FormAddManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormAddManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormAddManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormAddManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormAddManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormAddManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormAddManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddManager_011', 0, () => {
      expect(FormAddManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormAddManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAddManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAddManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAddManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAddManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAddManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddManager_012', 0, () => {
      expect(FormAddManager.checkArr([]) === false).assertTrue();
      expect(FormAddManager.checkArr(null) === false).assertTrue();
      expect(FormAddManager.checkArr(undefined) === false).assertTrue();
      expect(FormAddManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAddManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAddManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormAddManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAddManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAddManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAddManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAddManager.getUUID().length > 0).assertTrue();
    })

    it('FormAddManager_013', 0, () => {
      expect(FormAddManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAddManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddManager_014', 0, () => {
      expect(FormAddManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormAddManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAddManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormAddManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAddManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAddManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAddManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormAddManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddManager_015', 0, () => {
      expect(FormAddManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormAddManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAddManager.getArraySum([], null) === -1).assertTrue();
      expect(FormAddManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAddManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAddManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddManager_016', 0, () => {
      expect(FormAddManager.isEmpty(null)).assertTrue();
      expect(FormAddManager.isEmpty(undefined)).assertTrue();
      expect(FormAddManager.isEmpty('')).assertTrue();
      expect(FormAddManager.isEmpty(0)).assertTrue();
      expect(FormAddManager.isEmpty([])).assertTrue();
      expect(FormAddManager.isEmpty(1, null)).assertTrue();
      expect(FormAddManager.isEmpty(1, undefined)).assertTrue();
      expect(FormAddManager.isEmpty(1, true)).assertTrue();
      expect(FormAddManager.isEmpty(1, false)).assertFalse();
    })

    it('FormAddManager_017', 0, () => {
      expect(FormAddManager.equals(null, 'a')).assertFalse();
      expect(FormAddManager.equals(undefined, 'a')).assertFalse();
      expect(FormAddManager.equals('a', null)).assertFalse();
      expect(FormAddManager.equals('a', undefined)).assertFalse();
      expect(FormAddManager.equals('a', 1)).assertFalse();
      expect(FormAddManager.equals(1, 'a')).assertFalse();
      expect(FormAddManager.equals(1, [])).assertFalse();
      expect(FormAddManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAddManager.equals([], m)).assertFalse();
      expect(FormAddManager.equals(m, [])).assertFalse();
      expect(FormAddManager.equals([1,2], [])).assertFalse();
      expect(FormAddManager.equals([], [1, 2])).assertFalse();
      expect(FormAddManager.equals([1], [1, 2])).assertFalse();
      expect(FormAddManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAddManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAddManager.equals(2, 2)).assertTrue();
    })
  });
}