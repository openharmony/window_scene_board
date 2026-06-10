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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { DateTimeI18NUtil } from '@ohos/screenlockwidget/src/main/ets/clock/common/DateTimeI18NUtil';


export default function DateTimeI18NUtilTest() {

  describe('DateTimeI18NUtilTest', (): void => {

    let mocker: MockKit = new MockKit();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it("test_getWeekTitle_chinese", TestConst.TEST_LEVEL, (): void => {
      let weekString: string[] = DateTimeI18NUtil.getWeekTitle('zh-Hans');
      expect(weekString.length === 7).assertEqual(true);
    })

    it("test_getWeekTitle_en", TestConst.TEST_LEVEL, (): void => {
      let weekString: string[] = DateTimeI18NUtil.getWeekTitle('en-Us');
      expect(weekString.length === 7).assertEqual(true);
    })

    it('getDateStr should return formatted date string', TestConst.TEST_LEVEL, () => {
      const date = new Date('2024-06-07');
      const result = DateTimeI18NUtil.getDateStr('en-Latn-US', date);
      expect(result).assertContain('Jun');
      const result2 = DateTimeI18NUtil.getDateStr('zh-Hans', date);
      expect(result2).assertContain('6月');
    });

    it('getBigDateStr should return formatted date string with numeric month and day', TestConst.TEST_LEVEL, () => {
      const date = new Date('2024-06-07');
      const result = DateTimeI18NUtil.getBigDateStr('en-Latn-US', date);
      expect(result).assertEqual('06/07');
    });

    it('getDateWithWeekStr should return formatted date string with weekday', TestConst.TEST_LEVEL, () => {
      const date = new Date('2024-06-07');
      const result = DateTimeI18NUtil.getDateWithWeekStr('en-Latn-US', date);
      expect(result).assertContain('Fri');
    });

    it('DateFormat should return formatted date string', TestConst.TEST_LEVEL, () => {
      const date = new Date('2024-06-07');
      const result = DateTimeI18NUtil.DateFormat(date, {
        month: 'short', day: 'numeric'
      }, 'en-Latn-US');
      expect(result).assertContain('Jun');
    });

  })
}