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
import settings from '@ohos.settings';
import commonEvent from '@ohos.commonEvent';
import {
  SingletonHelper,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { sEventManager, obtainLocalEvent, getCommonEventManager, POLICY } from '@ohos/frameworkwrapper';
import { CommonEventManager } from '@ohos/frameworkwrapper';
import ServiceExtensionContext from '../../../main/ets/manager/application/ServiceExtensionContext';
import { i18n } from '@kit.LocalizationKit';
import commonEventManager from '@ohos.commonEventManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TimeManager } from '../../../main/ets/manager/TimeManager';
export default function TimeManagerTest() {
  describe('formatTime_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
    it('should_release_manager_when_mManager_is_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      timeManager.mManager = undefined;

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });

    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
    it('should_release_manager_when_mManager_is_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      timeManager.mManager = undefined;

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });

    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
    it('should_release_manager_when_mManager_is_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      timeManager.mManager = undefined;

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });

    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
    it('should_release_manager_when_mManager_is_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      timeManager.mManager = undefined;

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });

    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
    it('should_release_manager_when_mManager_is_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      timeManager.mManager = undefined;

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });

    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
    it('should_release_manager_when_mManager_is_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      timeManager.mManager = undefined;

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });

    it('should_return_24h_format_when_mUse24hFormat_is_true', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = true;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 24, date.getMinutes()));
    });

    it('should_return_12h_format_when_mUse24hFormat_is_false_and_hour_is_not_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(date.getHours() % 12 || 12, date.getMinutes()));
    });

    it('should_return_12h_format_with_00_when_mUse24hFormat_is_false_and_hour_is_zero', 0, () => {
      let timemanager: TimeManager = new TimeManager();
      timemanager.mUse24hFormat = false;
      let date: Date = new Date();
      date.setHours(0);
      let result: string = timemanager.formatTime(date);
      expect(result).assertEqual(concatTime(0, date.getMinutes()));
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_time_format_correctly', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      timeManager.refreshTimeFormat();

      expect(timeManager.mUse24hFormat).assertEqual(i18n.System.is24HourClock());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_manager_when_mManager_is_not_undefined', 0, () => {
      let timeManager: TimeManager = new TimeManager();
      let mocker: MockKit = new MockKit();

      timeManager.release();

      expect(timeManager.mManager).assertUndefined();
    });
  });
}
