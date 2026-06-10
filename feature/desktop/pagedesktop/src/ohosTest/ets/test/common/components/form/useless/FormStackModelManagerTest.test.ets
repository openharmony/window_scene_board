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
import { FormStackModelManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackModelManager';

export function FormStackModelManagerTest() {
  describe('FormStackModelManagerTest', () => {
    it('FormStackModelManager_001', 0, () => {
      expect(FormStackModelManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackModelManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackModelManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackModelManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackModelManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackModelManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackModelManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackModelManager_002', 0, () => {
      expect(FormStackModelManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackModelManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackModelManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackModelManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackModelManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackModelManager_003', 0, () => {
      expect(FormStackModelManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackModelManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackModelManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackModelManager_004', 0, () => {
      expect(FormStackModelManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackModelManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackModelManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackModelManager_005', 0, () => {
      expect(FormStackModelManager.isNumber("")).assertFalse();
      expect(FormStackModelManager.isNumber(null)).assertFalse();
      expect(FormStackModelManager.isNumber(undefined)).assertFalse();
      expect(FormStackModelManager.isNumber("abc")).assertFalse();
      expect(FormStackModelManager.isNumber("123")).assertTrue();
    });

    it('FormStackModelManager_006', 0, () => {
      expect(FormStackModelManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackModelManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackModelManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackModelManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackModelManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackModelManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackModelManager_007', 0, () => {
      expect(FormStackModelManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackModelManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackModelManager.getDefaultId('') === '').assertTrue();
      expect(FormStackModelManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackModelManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackModelManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackModelManager_008', 0, () => {
      expect(FormStackModelManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackModelManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackModelManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackModelManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackModelManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackModelManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackModelManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackModelManager_009', 0, () => {
      expect(FormStackModelManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackModelManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackModelManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackModelManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackModelManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackModelManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackModelManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackModelManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackModelManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackModelManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackModelManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackModelManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackModelManager_010', 0, () => {
      expect(FormStackModelManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackModelManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackModelManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackModelManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackModelManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackModelManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackModelManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackModelManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackModelManager_011', 0, () => {
      expect(FormStackModelManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackModelManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackModelManager_012', 0, () => {
      expect(FormStackModelManager.checkArr([]) === false).assertTrue();
      expect(FormStackModelManager.checkArr(null) === false).assertTrue();
      expect(FormStackModelManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackModelManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackModelManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackModelManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackModelManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackModelManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackModelManager_013', 0, () => {
      expect(FormStackModelManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackModelManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackModelManager_014', 0, () => {
      expect(FormStackModelManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackModelManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackModelManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackModelManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackModelManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackModelManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackModelManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackModelManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackModelManager_015', 0, () => {
      expect(FormStackModelManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackModelManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackModelManager_016', 0, () => {
      expect(FormStackModelManager.isEmpty(null)).assertTrue();
      expect(FormStackModelManager.isEmpty(undefined)).assertTrue();
      expect(FormStackModelManager.isEmpty('')).assertTrue();
      expect(FormStackModelManager.isEmpty(0)).assertTrue();
      expect(FormStackModelManager.isEmpty([])).assertTrue();
      expect(FormStackModelManager.isEmpty(1, null)).assertTrue();
      expect(FormStackModelManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackModelManager.isEmpty(1, true)).assertTrue();
      expect(FormStackModelManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackModelManager_017', 0, () => {
      expect(FormStackModelManager.equals(null, 'a')).assertFalse();
      expect(FormStackModelManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackModelManager.equals('a', null)).assertFalse();
      expect(FormStackModelManager.equals('a', undefined)).assertFalse();
      expect(FormStackModelManager.equals('a', 1)).assertFalse();
      expect(FormStackModelManager.equals(1, 'a')).assertFalse();
      expect(FormStackModelManager.equals(1, [])).assertFalse();
      expect(FormStackModelManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackModelManager.equals([], m)).assertFalse();
      expect(FormStackModelManager.equals(m, [])).assertFalse();
      expect(FormStackModelManager.equals([1,2], [])).assertFalse();
      expect(FormStackModelManager.equals([], [1, 2])).assertFalse();
      expect(FormStackModelManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackModelManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackModelManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackModelManager.equals(2, 2)).assertTrue();
    })
  });
}