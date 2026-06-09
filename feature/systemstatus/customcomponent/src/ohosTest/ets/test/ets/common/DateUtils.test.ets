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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { DateUtils } from '../../../../../main/ets/common/DateUtils';
import I18n from '@ohos.i18n';

const hour = 60 * 60 * 1000;

export function DateUtilsTest() {
  describe('DateUtilsTest', (): void => {
    it('plusDays', Level.LEVEL0, (): void => {
      const date: Date = new Date();

      expect(DateUtils.plusDays(date, 3)).assertEqual(date.getTime() + 3 * 24 * hour);
    });

    it('minusDays', Level.LEVEL0, (): void => {
      const date: Date = new Date();

      expect(DateUtils.minusDays(date, 3)).assertEqual(date.getTime() - 3 * 24 * hour);
    });

    it('plusHours', Level.LEVEL0, (): void => {
      const date: Date = new Date();

      expect(DateUtils.plusHours(date, 5)).assertEqual(date.getTime() + 5 * hour);
    });

    it('minusHours', Level.LEVEL0, (): void => {
      const date: Date = new Date();

      expect(DateUtils.minusHours(date, 5)).assertEqual(date.getTime() - 5 * hour);
    });

    it('formatLocalDate_01', Level.LEVEL0, (): void => {
      const localeDate = DateUtils.formatLocalDate(new Date('2024-06-20'), DateUtils.STYLE_SHORT);
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeDate === '2024/6/20' : true).assertTrue();
    });

    it('formatLocalDate_02', Level.LEVEL0, (): void => {
      const localeDate = DateUtils.formatLocalDate(new Date('2024-06-20'), DateUtils.STYLE_LONG);
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeDate === '2024年6月20日' : true).assertTrue();
    });

    it('formatDateNoYear', Level.LEVEL0, (): void => {
      const localeDateNoYear = DateUtils.formatDateNoYear(new Date('2024-06-20T08:53:24'));
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeDateNoYear === '6月20日星期四' : true).assertTrue();
    });

    it('getTimeWithoutAmPm_01', Level.LEVEL0, (): void => {
      const timeWithoutAmPm = DateUtils.getTimeWithoutAmPm(DateUtils.formatLocalTime(new Date('2024-06-20T08:53:24')));

      expect(timeWithoutAmPm === '8:53').assertTrue();
    });

    it('getTimeWithoutAmPm_02', Level.LEVEL0, (): void => {
      const timeWithoutAmPm = DateUtils.getTimeWithoutAmPm(DateUtils.formatLocalTime(new Date('2024-06-20T16:53:24')));

      expect(timeWithoutAmPm === '4:53').assertTrue();
    });
  });
}
export function DateUtilsTest2() {
  describe('DateUtilsTest', (): void => {
    it('formatLocalTime_01', Level.LEVEL0, (): void => {
      const localeTime = DateUtils.formatLocalTime(new Date('2024-06-20T16:53:24'), DateUtils.STYLE_SHORT);
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();
      const isHour24 = I18n.System.is24HourClock();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeTime === (isHour24 ? '16:53' : '下午4:53') : true).assertTrue();
    });

    it('formatLocalTime_02', Level.LEVEL0, (): void => {
      const localeTime = DateUtils.formatLocalTime(new Date('2024-06-20T16:53:24'), DateUtils.STYLE_LONG);
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();
      const isHour24 = I18n.System.is24HourClock();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeTime === (isHour24 ? 'GMT+8 16:53:24' : 'GMT+8 下午4:53:24') : true).assertTrue();
    });

    it('formatLocalTime_03', Level.LEVEL0, (): void => {
      const localeTime = DateUtils.formatLocalTime(new Date('2024-06-20T08:53:24'));
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();
      const isHour24 = I18n.System.is24HourClock();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeTime === (isHour24 ? 'GMT+8 16:53:24' : 'GMT+8 下午4:53:24') : true).assertTrue();
    });

    it('formatLocalTime_04', Level.LEVEL0, (): void => {
      const localeTime = DateUtils.formatLocalTime(new Date('2024-06-20T08:53:24'), DateUtils.STYLE_SHORT);
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();
      const isHour24 = I18n.System.is24HourClock();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeTime === (isHour24 ? '8:53' : '上午8:53') : true).assertTrue();
    });

    it('formatLocalTime_05', Level.LEVEL0, (): void => {
      const localeTime = DateUtils.formatLocalTime(new Date('2024-06-20T08:53:24'));
      const locale = I18n.System.getSystemLanguage();
      const timeZone = I18n.getTimeZone()?.getID();
      const isHour24 = I18n.System.is24HourClock();

      const isConditionMatch = locale === 'zh-Hans' && timeZone === 'Asia/Shanghai';

      expect(isConditionMatch ? localeTime === (isHour24 ? '08:53' : '上午8:53') : true).assertTrue();
    });
  });
}