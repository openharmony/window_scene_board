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
import { FormDbManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormDbManager';

export function FormDbManagerTest() {
  describe('FormDbManagerTest', () => {
    it('FormDbManager_001', 0, () => {
      expect(FormDbManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormDbManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDbManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDbManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormDbManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormDbManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDbManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDbManager_002', 0, () => {
      expect(FormDbManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDbManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDbManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDbManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDbManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDbManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDbManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDbManager_003', 0, () => {
      expect(FormDbManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDbManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDbManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDbManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDbManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDbManager_004', 0, () => {
      expect(FormDbManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDbManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDbManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDbManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDbManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDbManager_005', 0, () => {
      expect(FormDbManager.isNumber("")).assertFalse();
      expect(FormDbManager.isNumber(null)).assertFalse();
      expect(FormDbManager.isNumber(undefined)).assertFalse();
      expect(FormDbManager.isNumber("abc")).assertFalse();
      expect(FormDbManager.isNumber("123")).assertTrue();
    });

    it('FormDbManager_006', 0, () => {
      expect(FormDbManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDbManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDbManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDbManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDbManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDbManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDbManager_007', 0, () => {
      expect(FormDbManager.getDefaultId(null) === null).assertTrue();
      expect(FormDbManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDbManager.getDefaultId('') === '').assertTrue();
      expect(FormDbManager.getDefaultId('default') !== '').assertTrue();
      expect(FormDbManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDbManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDbManager_008', 0, () => {
      expect(FormDbManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormDbManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDbManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDbManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDbManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDbManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDbManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDbManager_009', 0, () => {
      expect(FormDbManager.drawFontWidth() === -1).assertTrue();
      expect(FormDbManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormDbManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormDbManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormDbManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormDbManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormDbManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormDbManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormDbManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormDbManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormDbManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDbManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDbManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDbManager_010', 0, () => {
      expect(FormDbManager.drawTextAlign() === -1).assertTrue();
      expect(FormDbManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormDbManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormDbManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormDbManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormDbManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormDbManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormDbManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDbManager_011', 0, () => {
      expect(FormDbManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormDbManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDbManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDbManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDbManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDbManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDbManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDbManager_012', 0, () => {
      expect(FormDbManager.checkArr([]) === false).assertTrue();
      expect(FormDbManager.checkArr(null) === false).assertTrue();
      expect(FormDbManager.checkArr(undefined) === false).assertTrue();
      expect(FormDbManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDbManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDbManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormDbManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDbManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDbManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDbManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDbManager.getUUID().length > 0).assertTrue();
    })

    it('FormDbManager_013', 0, () => {
      expect(FormDbManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDbManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDbManager_014', 0, () => {
      expect(FormDbManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormDbManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDbManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormDbManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDbManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDbManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDbManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormDbManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDbManager_015', 0, () => {
      expect(FormDbManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormDbManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDbManager.getArraySum([], null) === -1).assertTrue();
      expect(FormDbManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDbManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDbManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDbManager_016', 0, () => {
      expect(FormDbManager.isEmpty(null)).assertTrue();
      expect(FormDbManager.isEmpty(undefined)).assertTrue();
      expect(FormDbManager.isEmpty('')).assertTrue();
      expect(FormDbManager.isEmpty(0)).assertTrue();
      expect(FormDbManager.isEmpty([])).assertTrue();
      expect(FormDbManager.isEmpty(1, null)).assertTrue();
      expect(FormDbManager.isEmpty(1, undefined)).assertTrue();
      expect(FormDbManager.isEmpty(1, true)).assertTrue();
      expect(FormDbManager.isEmpty(1, false)).assertFalse();
    })

    it('FormDbManager_017', 0, () => {
      expect(FormDbManager.equals(null, 'a')).assertFalse();
      expect(FormDbManager.equals(undefined, 'a')).assertFalse();
      expect(FormDbManager.equals('a', null)).assertFalse();
      expect(FormDbManager.equals('a', undefined)).assertFalse();
      expect(FormDbManager.equals('a', 1)).assertFalse();
      expect(FormDbManager.equals(1, 'a')).assertFalse();
      expect(FormDbManager.equals(1, [])).assertFalse();
      expect(FormDbManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDbManager.equals([], m)).assertFalse();
      expect(FormDbManager.equals(m, [])).assertFalse();
      expect(FormDbManager.equals([1,2], [])).assertFalse();
      expect(FormDbManager.equals([], [1, 2])).assertFalse();
      expect(FormDbManager.equals([1], [1, 2])).assertFalse();
      expect(FormDbManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDbManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDbManager.equals(2, 2)).assertTrue();
    })
  });
}