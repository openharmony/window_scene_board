/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import LunarCalendar from '@ohos/systemuiutils/src/main/ets/calendar/LunarCalendar';


const DEFAULT = 0;

export function LunarCalendarTest() {
  describe('LunarTermsInfoTest', (): void => {
    it('test_initLunarCalendar', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      expect(lunarCalendar instanceof LunarCalendar).assertTrue();
    });
    it('test_init', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      lunarCalendar.init(2024, 6, 5);
      expect(lunarCalendar instanceof LunarCalendar).assertTrue();
    });
    it('getLunarLeapMonth', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      let month: number = lunarCalendar.getLunarLeapMonth(0);
      expect(month).assertEqual(0);
    });
    it('test_isFirstDayOfMonth', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      (lunarCalendar as object)['mLunarDay'] = 1;
      let month = lunarCalendar.isFirstDayOfMonth();
      expect(month).assertTrue();
      (lunarCalendar as object)['mLunarDay'] = 2;
      month = lunarCalendar.isFirstDayOfMonth();
      expect(month).assertFalse();
    });
    it('test_isFirstDayOfMonth_01', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      (lunarCalendar as object)['mLunarDay'] = 2;
      let month = lunarCalendar.isFirstDayOfMonth();
      expect(month).assertFalse();
    });
    it('test_isNewYear', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      (lunarCalendar as object)['mLunarMonth'] = 1;
      (lunarCalendar as object)['mLunarDay'] = 1;
      let month = lunarCalendar.isNewYear();
      expect(month).assertTrue();
    });
    it('test_isNewYear_01', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      (lunarCalendar as object)['mLunarMonth'] = 2;
      (lunarCalendar as object)['mLunarDay'] = 1;
      let month = lunarCalendar.isNewYear();
      expect(month).assertFalse();
    });

  })
}
export function LunarCalendarTest_two() {
  describe('LunarTermsInfoTest_two', (): void => {
    it('test_getChineseMonth', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      let month = lunarCalendar.getChineseMonth(true);
      expect(month).assertInstanceOf('String');
    });
    it('test_getChineseDay', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      let month = lunarCalendar.getChineseDay();
      expect(month).assertInstanceOf('String');
    });
    it('test_getChineseDayInfo', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      let month = lunarCalendar.getChineseDayInfo(true);
      expect(month).assertInstanceOf('String');
    });
    it('test_getChineseYearReal', DEFAULT, (): void => {
      let lunarCalendar: LunarCalendar = new LunarCalendar();
      let month = lunarCalendar.getChineseYearReal();
      expect(month).assertInstanceOf('String');
    });
  });
}