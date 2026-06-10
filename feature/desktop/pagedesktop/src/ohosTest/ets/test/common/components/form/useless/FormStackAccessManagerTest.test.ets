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
import { FormStackAccessManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAccessManager';

export function FormStackAccessManagerTest() {
  describe('FormStackAccessManagerTest', () => {
    it('FormStackAccessManager_001', 0, () => {
      expect(FormStackAccessManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAccessManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAccessManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAccessManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAccessManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAccessManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAccessManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAccessManager_002', 0, () => {
      expect(FormStackAccessManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAccessManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAccessManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAccessManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAccessManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAccessManager_003', 0, () => {
      expect(FormStackAccessManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAccessManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAccessManager_004', 0, () => {
      expect(FormStackAccessManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAccessManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAccessManager_005', 0, () => {
      expect(FormStackAccessManager.isNumber("")).assertFalse();
      expect(FormStackAccessManager.isNumber(null)).assertFalse();
      expect(FormStackAccessManager.isNumber(undefined)).assertFalse();
      expect(FormStackAccessManager.isNumber("abc")).assertFalse();
      expect(FormStackAccessManager.isNumber("123")).assertTrue();
    });

    it('FormStackAccessManager_006', 0, () => {
      expect(FormStackAccessManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAccessManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAccessManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAccessManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAccessManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAccessManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAccessManager_007', 0, () => {
      expect(FormStackAccessManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackAccessManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAccessManager.getDefaultId('') === '').assertTrue();
      expect(FormStackAccessManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAccessManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAccessManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAccessManager_008', 0, () => {
      expect(FormStackAccessManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAccessManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAccessManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAccessManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAccessManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAccessManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAccessManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAccessManager_009', 0, () => {
      expect(FormStackAccessManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAccessManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAccessManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAccessManager_010', 0, () => {
      expect(FormStackAccessManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAccessManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAccessManager_011', 0, () => {
      expect(FormStackAccessManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAccessManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAccessManager_012', 0, () => {
      expect(FormStackAccessManager.checkArr([]) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(null) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAccessManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAccessManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackAccessManager_013', 0, () => {
      expect(FormStackAccessManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAccessManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAccessManager_014', 0, () => {
      expect(FormStackAccessManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAccessManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAccessManager_015', 0, () => {
      expect(FormStackAccessManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAccessManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAccessManager_016', 0, () => {
      expect(FormStackAccessManager.isEmpty(null)).assertTrue();
      expect(FormStackAccessManager.isEmpty(undefined)).assertTrue();
      expect(FormStackAccessManager.isEmpty('')).assertTrue();
      expect(FormStackAccessManager.isEmpty(0)).assertTrue();
      expect(FormStackAccessManager.isEmpty([])).assertTrue();
      expect(FormStackAccessManager.isEmpty(1, null)).assertTrue();
      expect(FormStackAccessManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAccessManager.isEmpty(1, true)).assertTrue();
      expect(FormStackAccessManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAccessManager_017', 0, () => {
      expect(FormStackAccessManager.equals(null, 'a')).assertFalse();
      expect(FormStackAccessManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackAccessManager.equals('a', null)).assertFalse();
      expect(FormStackAccessManager.equals('a', undefined)).assertFalse();
      expect(FormStackAccessManager.equals('a', 1)).assertFalse();
      expect(FormStackAccessManager.equals(1, 'a')).assertFalse();
      expect(FormStackAccessManager.equals(1, [])).assertFalse();
      expect(FormStackAccessManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAccessManager.equals([], m)).assertFalse();
      expect(FormStackAccessManager.equals(m, [])).assertFalse();
      expect(FormStackAccessManager.equals([1,2], [])).assertFalse();
      expect(FormStackAccessManager.equals([], [1, 2])).assertFalse();
      expect(FormStackAccessManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackAccessManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAccessManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAccessManager.equals(2, 2)).assertTrue();
    })
  });
}