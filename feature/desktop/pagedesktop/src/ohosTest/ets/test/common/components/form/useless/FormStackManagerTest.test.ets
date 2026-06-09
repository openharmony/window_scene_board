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
import { FormStackManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackManager';

export function FormStackManagerTest() {
  describe('FormStackManagerTest', () => {
    it('FormStackManager_001', 0, () => {
      expect(FormStackManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackManager_002', 0, () => {
      expect(FormStackManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackManager_003', 0, () => {
      expect(FormStackManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackManager_004', 0, () => {
      expect(FormStackManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackManager_005', 0, () => {
      expect(FormStackManager.isNumber("")).assertFalse();
      expect(FormStackManager.isNumber(null)).assertFalse();
      expect(FormStackManager.isNumber(undefined)).assertFalse();
      expect(FormStackManager.isNumber("abc")).assertFalse();
      expect(FormStackManager.isNumber("123")).assertTrue();
    });

    it('FormStackManager_006', 0, () => {
      expect(FormStackManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackManager_007', 0, () => {
      expect(FormStackManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackManager.getDefaultId('') === '').assertTrue();
      expect(FormStackManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackManager_008', 0, () => {
      expect(FormStackManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackManager_009', 0, () => {
      expect(FormStackManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackManager_010', 0, () => {
      expect(FormStackManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackManager_011', 0, () => {
      expect(FormStackManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackManager_012', 0, () => {
      expect(FormStackManager.checkArr([]) === false).assertTrue();
      expect(FormStackManager.checkArr(null) === false).assertTrue();
      expect(FormStackManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackManager_013', 0, () => {
      expect(FormStackManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackManager_014', 0, () => {
      expect(FormStackManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackManager_015', 0, () => {
      expect(FormStackManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackManager_016', 0, () => {
      expect(FormStackManager.isEmpty(null)).assertTrue();
      expect(FormStackManager.isEmpty(undefined)).assertTrue();
      expect(FormStackManager.isEmpty('')).assertTrue();
      expect(FormStackManager.isEmpty(0)).assertTrue();
      expect(FormStackManager.isEmpty([])).assertTrue();
      expect(FormStackManager.isEmpty(1, null)).assertTrue();
      expect(FormStackManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackManager.isEmpty(1, true)).assertTrue();
      expect(FormStackManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackManager_017', 0, () => {
      expect(FormStackManager.equals(null, 'a')).assertFalse();
      expect(FormStackManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackManager.equals('a', null)).assertFalse();
      expect(FormStackManager.equals('a', undefined)).assertFalse();
      expect(FormStackManager.equals('a', 1)).assertFalse();
      expect(FormStackManager.equals(1, 'a')).assertFalse();
      expect(FormStackManager.equals(1, [])).assertFalse();
      expect(FormStackManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackManager.equals([], m)).assertFalse();
      expect(FormStackManager.equals(m, [])).assertFalse();
      expect(FormStackManager.equals([1,2], [])).assertFalse();
      expect(FormStackManager.equals([], [1, 2])).assertFalse();
      expect(FormStackManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackManager.equals(2, 2)).assertTrue();
    })
  });
}