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
import { FormModelManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormModelManager';

export function FormModelManagerTest() {
  describe('FormModelManagerTest', () => {
    it('FormModelManager_001', 0, () => {
      expect(FormModelManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormModelManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormModelManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormModelManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormModelManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormModelManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormModelManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormModelManager_002', 0, () => {
      expect(FormModelManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormModelManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormModelManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormModelManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormModelManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormModelManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormModelManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormModelManager_003', 0, () => {
      expect(FormModelManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormModelManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormModelManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormModelManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormModelManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormModelManager_004', 0, () => {
      expect(FormModelManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormModelManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormModelManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormModelManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormModelManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormModelManager_005', 0, () => {
      expect(FormModelManager.isNumber("")).assertFalse();
      expect(FormModelManager.isNumber(null)).assertFalse();
      expect(FormModelManager.isNumber(undefined)).assertFalse();
      expect(FormModelManager.isNumber("abc")).assertFalse();
      expect(FormModelManager.isNumber("123")).assertTrue();
    });

    it('FormModelManager_006', 0, () => {
      expect(FormModelManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormModelManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormModelManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormModelManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormModelManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormModelManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormModelManager_007', 0, () => {
      expect(FormModelManager.getDefaultId(null) === null).assertTrue();
      expect(FormModelManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormModelManager.getDefaultId('') === '').assertTrue();
      expect(FormModelManager.getDefaultId('default') !== '').assertTrue();
      expect(FormModelManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormModelManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormModelManager_008', 0, () => {
      expect(FormModelManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormModelManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormModelManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormModelManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormModelManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormModelManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormModelManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormModelManager_009', 0, () => {
      expect(FormModelManager.drawFontWidth() === -1).assertTrue();
      expect(FormModelManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormModelManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormModelManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormModelManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormModelManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormModelManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormModelManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormModelManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormModelManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormModelManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormModelManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormModelManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormModelManager_010', 0, () => {
      expect(FormModelManager.drawTextAlign() === -1).assertTrue();
      expect(FormModelManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormModelManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormModelManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormModelManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormModelManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormModelManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormModelManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormModelManager_011', 0, () => {
      expect(FormModelManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormModelManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormModelManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormModelManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormModelManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormModelManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormModelManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormModelManager_012', 0, () => {
      expect(FormModelManager.checkArr([]) === false).assertTrue();
      expect(FormModelManager.checkArr(null) === false).assertTrue();
      expect(FormModelManager.checkArr(undefined) === false).assertTrue();
      expect(FormModelManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormModelManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormModelManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormModelManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormModelManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormModelManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormModelManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormModelManager.getUUID().length > 0).assertTrue();
    })

    it('FormModelManager_013', 0, () => {
      expect(FormModelManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormModelManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormModelManager_014', 0, () => {
      expect(FormModelManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormModelManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormModelManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormModelManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormModelManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormModelManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormModelManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormModelManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormModelManager_015', 0, () => {
      expect(FormModelManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormModelManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormModelManager.getArraySum([], null) === -1).assertTrue();
      expect(FormModelManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormModelManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormModelManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormModelManager_016', 0, () => {
      expect(FormModelManager.isEmpty(null)).assertTrue();
      expect(FormModelManager.isEmpty(undefined)).assertTrue();
      expect(FormModelManager.isEmpty('')).assertTrue();
      expect(FormModelManager.isEmpty(0)).assertTrue();
      expect(FormModelManager.isEmpty([])).assertTrue();
      expect(FormModelManager.isEmpty(1, null)).assertTrue();
      expect(FormModelManager.isEmpty(1, undefined)).assertTrue();
      expect(FormModelManager.isEmpty(1, true)).assertTrue();
      expect(FormModelManager.isEmpty(1, false)).assertFalse();
    })

    it('FormModelManager_017', 0, () => {
      expect(FormModelManager.equals(null, 'a')).assertFalse();
      expect(FormModelManager.equals(undefined, 'a')).assertFalse();
      expect(FormModelManager.equals('a', null)).assertFalse();
      expect(FormModelManager.equals('a', undefined)).assertFalse();
      expect(FormModelManager.equals('a', 1)).assertFalse();
      expect(FormModelManager.equals(1, 'a')).assertFalse();
      expect(FormModelManager.equals(1, [])).assertFalse();
      expect(FormModelManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormModelManager.equals([], m)).assertFalse();
      expect(FormModelManager.equals(m, [])).assertFalse();
      expect(FormModelManager.equals([1,2], [])).assertFalse();
      expect(FormModelManager.equals([], [1, 2])).assertFalse();
      expect(FormModelManager.equals([1], [1, 2])).assertFalse();
      expect(FormModelManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormModelManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormModelManager.equals(2, 2)).assertTrue();
    })
  });
}