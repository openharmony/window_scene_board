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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { Pinyin, PinyinOptions } from '../../../../../../main/ets/utils/Pinyin';

const mPinyin: Pinyin = new Pinyin();

export function PinyinTest() {
  describe('PinyinTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('PinyinTest_getCamelChars', 0, (): void => {
      try {
        mPinyin.getCamelChars('1');
      } catch (e) {
        expect(e).assertInstanceOf('Error');
      };
      expect(mPinyin.getCamelChars('abc')).assertEqual('abc');
    })

    it('PinyinTest_getCamelChars_polyphone', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mPinyin, mPinyin.getResult);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['abc']);
      expect(mPinyin.getCamelChars('abc')).assertEqual('');
      mocker.clear(mPinyin);
      mocker.clearAll();
    })

    it('PinyinTest_getChar_polyphone', 0, (): void => {
      const option: PinyinOptions = new PinyinOptions();
      option.checkPolyphone = true;
      let polyPhonePinyin: Pinyin = new Pinyin(option);
      expect(mPinyin.getChar('你好')).assertInstanceOf('String');
      expect(polyPhonePinyin.getChar('你好')).assertInstanceOf('String');
    })

    it('PinyinTest_getFullChars_capitalize', 0, (): void => {
      expect(mPinyin.getFullChars('你好')).assertInstanceOf('String');
      expect(mPinyin.capitalize('')).assertEqual('');
    })

    it('PinyinTest_setOptions', 0, (): void => {
      mPinyin.setOptions(null);
      mPinyin.setOptions({ charCase: 1 } as PinyinOptions);
      expect(mPinyin.getCamelChars('abc')).assertEqual('abc');
      mPinyin.setOptions({ charCase: 2 } as PinyinOptions);
      expect(mPinyin.getCamelChars('abc')).assertEqual('ABC');
    })

    it('PinyinTest_setOptions_polyphone', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mPinyin, mPinyin.getResult);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['abc']);
      mPinyin.setOptions({ charCase: 1 } as PinyinOptions);
      expect(mPinyin.getCamelChars('abc')).assertEqual('abc');
      mPinyin.setOptions({ charCase: 2 } as PinyinOptions);
      expect(mPinyin.getCamelChars('abc')).assertEqual('ABC');
      mocker.clear(mPinyin);
      mocker.clearAll();
    })

    it('PinyinTest_getResult_polyphone', 0, (): void => {
      const option: PinyinOptions = new PinyinOptions();
      option.checkPolyphone = true;
      let polyPhonePinyin: Pinyin = new Pinyin(option);
      expect(polyPhonePinyin.getResult(['a', 'b', 'c'])).assertInstanceOf('Array');
      expect(polyPhonePinyin.getResult(['a', 'ab', 'abc'])).assertInstanceOf('Array');
    })
  })
}