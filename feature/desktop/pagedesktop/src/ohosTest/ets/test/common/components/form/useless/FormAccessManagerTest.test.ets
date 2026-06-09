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
import { FormAccessManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormAccessManager';

export function FormAccessManagerTest() {
  describe('FormAccessManagerTest', () => {
    it('FormAccessManager_001', 0, () => {
      expect(FormAccessManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormAccessManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAccessManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAccessManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormAccessManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormAccessManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAccessManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAccessManager_002', 0, () => {
      expect(FormAccessManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAccessManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAccessManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAccessManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAccessManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAccessManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAccessManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAccessManager_003', 0, () => {
      expect(FormAccessManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAccessManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAccessManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAccessManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAccessManager_004', 0, () => {
      expect(FormAccessManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAccessManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAccessManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAccessManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAccessManager_005', 0, () => {
      expect(FormAccessManager.isNumber("")).assertFalse();
      expect(FormAccessManager.isNumber(null)).assertFalse();
      expect(FormAccessManager.isNumber(undefined)).assertFalse();
      expect(FormAccessManager.isNumber("abc")).assertFalse();
      expect(FormAccessManager.isNumber("123")).assertTrue();
    });

    it('FormAccessManager_006', 0, () => {
      expect(FormAccessManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAccessManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAccessManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAccessManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAccessManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAccessManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAccessManager_007', 0, () => {
      expect(FormAccessManager.getDefaultId(null) === null).assertTrue();
      expect(FormAccessManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAccessManager.getDefaultId('') === '').assertTrue();
      expect(FormAccessManager.getDefaultId('default') !== '').assertTrue();
      expect(FormAccessManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAccessManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAccessManager_008', 0, () => {
      expect(FormAccessManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormAccessManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAccessManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAccessManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAccessManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAccessManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAccessManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAccessManager_009', 0, () => {
      expect(FormAccessManager.drawFontWidth() === -1).assertTrue();
      expect(FormAccessManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormAccessManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormAccessManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormAccessManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormAccessManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormAccessManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormAccessManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormAccessManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormAccessManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormAccessManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAccessManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAccessManager_010', 0, () => {
      expect(FormAccessManager.drawTextAlign() === -1).assertTrue();
      expect(FormAccessManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormAccessManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormAccessManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormAccessManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormAccessManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormAccessManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormAccessManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAccessManager_011', 0, () => {
      expect(FormAccessManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAccessManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAccessManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAccessManager_012', 0, () => {
      expect(FormAccessManager.checkArr([]) === false).assertTrue();
      expect(FormAccessManager.checkArr(null) === false).assertTrue();
      expect(FormAccessManager.checkArr(undefined) === false).assertTrue();
      expect(FormAccessManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAccessManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAccessManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormAccessManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAccessManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAccessManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAccessManager.getUUID().length > 0).assertTrue();
    })

    it('FormAccessManager_013', 0, () => {
      expect(FormAccessManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAccessManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAccessManager_014', 0, () => {
      expect(FormAccessManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormAccessManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAccessManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormAccessManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAccessManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAccessManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAccessManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormAccessManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAccessManager_015', 0, () => {
      expect(FormAccessManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormAccessManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([], null) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAccessManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAccessManager_016', 0, () => {
      expect(FormAccessManager.isEmpty(null)).assertTrue();
      expect(FormAccessManager.isEmpty(undefined)).assertTrue();
      expect(FormAccessManager.isEmpty('')).assertTrue();
      expect(FormAccessManager.isEmpty(0)).assertTrue();
      expect(FormAccessManager.isEmpty([])).assertTrue();
      expect(FormAccessManager.isEmpty(1, null)).assertTrue();
      expect(FormAccessManager.isEmpty(1, undefined)).assertTrue();
      expect(FormAccessManager.isEmpty(1, true)).assertTrue();
      expect(FormAccessManager.isEmpty(1, false)).assertFalse();
    })

    it('FormAccessManager_017', 0, () => {
      expect(FormAccessManager.equals(null, 'a')).assertFalse();
      expect(FormAccessManager.equals(undefined, 'a')).assertFalse();
      expect(FormAccessManager.equals('a', null)).assertFalse();
      expect(FormAccessManager.equals('a', undefined)).assertFalse();
      expect(FormAccessManager.equals('a', 1)).assertFalse();
      expect(FormAccessManager.equals(1, 'a')).assertFalse();
      expect(FormAccessManager.equals(1, [])).assertFalse();
      expect(FormAccessManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAccessManager.equals([], m)).assertFalse();
      expect(FormAccessManager.equals(m, [])).assertFalse();
      expect(FormAccessManager.equals([1,2], [])).assertFalse();
      expect(FormAccessManager.equals([], [1, 2])).assertFalse();
      expect(FormAccessManager.equals([1], [1, 2])).assertFalse();
      expect(FormAccessManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAccessManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAccessManager.equals(2, 2)).assertTrue();
    })
  });
}