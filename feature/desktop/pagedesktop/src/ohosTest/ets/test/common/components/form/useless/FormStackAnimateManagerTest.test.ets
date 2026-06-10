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
import { FormStackAnimateManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAnimateManager';

export function FormStackAnimateManagerTest() {
  describe('FormStackAnimateManagerTest', () => {
    it('FormStackAnimateManager_001', 0, () => {
      expect(FormStackAnimateManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAnimateManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAnimateManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAnimateManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAnimateManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAnimateManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAnimateManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAnimateManager_002', 0, () => {
      expect(FormStackAnimateManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAnimateManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAnimateManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAnimateManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAnimateManager_003', 0, () => {
      expect(FormStackAnimateManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAnimateManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAnimateManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAnimateManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAnimateManager_004', 0, () => {
      expect(FormStackAnimateManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAnimateManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAnimateManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAnimateManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAnimateManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAnimateManager_005', 0, () => {
      expect(FormStackAnimateManager.isNumber("")).assertFalse();
      expect(FormStackAnimateManager.isNumber(null)).assertFalse();
      expect(FormStackAnimateManager.isNumber(undefined)).assertFalse();
      expect(FormStackAnimateManager.isNumber("abc")).assertFalse();
      expect(FormStackAnimateManager.isNumber("123")).assertTrue();
    });

    it('FormStackAnimateManager_006', 0, () => {
      expect(FormStackAnimateManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAnimateManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAnimateManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAnimateManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAnimateManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAnimateManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAnimateManager_007', 0, () => {
      expect(FormStackAnimateManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackAnimateManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAnimateManager.getDefaultId('') === '').assertTrue();
      expect(FormStackAnimateManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAnimateManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAnimateManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAnimateManager_008', 0, () => {
      expect(FormStackAnimateManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAnimateManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAnimateManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAnimateManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAnimateManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAnimateManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAnimateManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAnimateManager_009', 0, () => {
      expect(FormStackAnimateManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAnimateManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAnimateManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAnimateManager_010', 0, () => {
      expect(FormStackAnimateManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAnimateManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAnimateManager_011', 0, () => {
      expect(FormStackAnimateManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAnimateManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAnimateManager_012', 0, () => {
      expect(FormStackAnimateManager.checkArr([]) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(null) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAnimateManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAnimateManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackAnimateManager_013', 0, () => {
      expect(FormStackAnimateManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAnimateManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAnimateManager_014', 0, () => {
      expect(FormStackAnimateManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAnimateManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAnimateManager_015', 0, () => {
      expect(FormStackAnimateManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAnimateManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAnimateManager_016', 0, () => {
      expect(FormStackAnimateManager.isEmpty(null)).assertTrue();
      expect(FormStackAnimateManager.isEmpty(undefined)).assertTrue();
      expect(FormStackAnimateManager.isEmpty('')).assertTrue();
      expect(FormStackAnimateManager.isEmpty(0)).assertTrue();
      expect(FormStackAnimateManager.isEmpty([])).assertTrue();
      expect(FormStackAnimateManager.isEmpty(1, null)).assertTrue();
      expect(FormStackAnimateManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAnimateManager.isEmpty(1, true)).assertTrue();
      expect(FormStackAnimateManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAnimateManager_017', 0, () => {
      expect(FormStackAnimateManager.equals(null, 'a')).assertFalse();
      expect(FormStackAnimateManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackAnimateManager.equals('a', null)).assertFalse();
      expect(FormStackAnimateManager.equals('a', undefined)).assertFalse();
      expect(FormStackAnimateManager.equals('a', 1)).assertFalse();
      expect(FormStackAnimateManager.equals(1, 'a')).assertFalse();
      expect(FormStackAnimateManager.equals(1, [])).assertFalse();
      expect(FormStackAnimateManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAnimateManager.equals([], m)).assertFalse();
      expect(FormStackAnimateManager.equals(m, [])).assertFalse();
      expect(FormStackAnimateManager.equals([1,2], [])).assertFalse();
      expect(FormStackAnimateManager.equals([], [1, 2])).assertFalse();
      expect(FormStackAnimateManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackAnimateManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAnimateManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAnimateManager.equals(2, 2)).assertTrue();
    })
  });
}