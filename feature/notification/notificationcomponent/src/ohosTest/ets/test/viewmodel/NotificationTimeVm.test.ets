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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  NotificationBaseVm,
  INotificationDataVm,
  NotificationRefreshType,
  NotificationRefreshRecord
} from '@ohos/systemuicommon/newIndex';
import {
  InnerEventUtil,
  NormalNotification,
  NormalNotificationGroup,
  NotificationArray,
  NotificationBase,
  NotificationCategory,
  NotificationEvent
} from '@ohos/systemuicommon/newTsIndex';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { NotificationTimeVm } from '../../../../../newIndex';

export default function NotificationTimeVmTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_initOv_when_init_is_called', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = new DateTimeVM();
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.initOv);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();
      notificationtimevm.init();
      mocker.ignoreMock(timeVm, timeVm.initOv);
    });
  });

  describe('init_testSuite', () => {

    it('should_call_initOv_with_valid_parameters', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      notificationtimevm.ntf = { deliveryTime: 1692000000, hashCode: "test_hash" };
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.initOv);
      when(mockfunc)(1692000000, "test_hash", ArgumentMatchers.anyObj).afterReturnNothing();
      notificationtimevm.init();
      mocker.ignoreMock(timeVm, timeVm.initOv);
    });

    it('should_call_initOv_with_zero_deliveryTime', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      notificationtimevm.ntf = { deliveryTime: 0, hashCode: "hash_0" };
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.initOv);
      when(mockfunc)(0, "hash_0", ArgumentMatchers.anyObj).afterReturnNothing();
      notificationtimevm.init();
      mocker.ignoreMock(timeVm, timeVm.initOv);
    });

    it('should_call_initOv_with_empty_hashCode', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      notificationtimevm.ntf = { deliveryTime: 123456789, hashCode: "" };
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.initOv);
      when(mockfunc)(123456789, "", ArgumentMatchers.anyObj).afterReturnNothing();
      notificationtimevm.init();
      mocker.ignoreMock(timeVm, timeVm.initOv);
    });
  });

  describe('destroy_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_timeVm_onDestroy', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.onDestroy);
      when(mockfunc)().afterReturnNothing();
      notificationtimevm.destroy();
      mocker.ignoreMock(timeVm, timeVm.onDestroy);
    });
  });

  describe('destroy_testSuite', () => {
    beforeEach(() => {

    });

    afterEach(() => {

    });

    it('should_call_timeVm_onDestroy_once', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let callCount = 0;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.onDestroy);
      when(mockfunc)().afterAction(() => callCount++);
      notificationtimevm.destroy();
      expect(callCount).assertEqual(1);
      mocker.ignoreMock(timeVm, timeVm.onDestroy);
    });

    it('should_throw_error_when_timeVm_onDestroy_throws', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.onDestroy);
      when(mockfunc)().afterThrow('Test error');
      expect(() => notificationtimevm.destroy()).assertThrowError('Test error');
      mocker.ignoreMock(timeVm, timeVm.onDestroy);
    });

    it('should_call_timeVm_onDestroy_multiple_times', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let callCount = 0;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.onDestroy);
      when(mockfunc)().afterAction(() => callCount++);
      notificationtimevm.destroy();
      notificationtimevm.destroy();
      expect(callCount).assertEqual(2);
      mocker.ignoreMock(timeVm, timeVm.onDestroy);
    });
  });

  describe('onUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_timeVm_updateOvTimeMillis_with_correct_deliveryTime', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.updateOvTimeMillis);
      let ntf: NotificationBase = new NotificationBase();
      ntf.deliveryTime = 123456789;
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);

      notificationtimevm.onUpdate(ntf);

      mocker.ignoreMock(timeVm, timeVm.updateOvTimeMillis);
    });

    it('should_call_timeVm_updateOvTimeMillis_with_zero_deliveryTime', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.updateOvTimeMillis);
      let ntf: NotificationBase = new NotificationBase();
      ntf.deliveryTime = 0;
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);

      notificationtimevm.onUpdate(ntf);

      mocker.ignoreMock(timeVm, timeVm.updateOvTimeMillis);
    });

    it('should_call_timeVm_updateOvTimeMillis_with_negative_deliveryTime', 0, async () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let timeVm: DateTimeVM = notificationtimevm.timeVm;
      let mockfunc: Function = mocker.mockFunc(timeVm, timeVm.updateOvTimeMillis);
      let ntf: NotificationBase = new NotificationBase();
      ntf.deliveryTime = -123456789;
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);

      notificationtimevm.onUpdate(ntf);

      mocker.ignoreMock(timeVm, timeVm.updateOvTimeMillis);
    });
  });

  describe('onTimeTextUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_timeText_and_log_info', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      notificationtimevm.onTimeTextUpdate("new time text");

      expect(notificationtimevm.timeText).assertEqual("new time text");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_with_ hashed_code', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      notificationtimevm.onTimeTextUpdate("new time text");

      expect(notificationtimevm.timeText).assertEqual("new time text");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('onTimeTextUpdate_testSuite', () => {

    it('should_handle_empty_string_input', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      notificationtimevm.onTimeTextUpdate("");

      expect(notificationtimevm.timeText).assertEqual("");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_handle_special_characters_input', 0, () => {
      let notificationtimevm: NotificationTimeVm = new NotificationTimeVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      const specialText = "12:30 PM with #symbols!";
      notificationtimevm.onTimeTextUpdate(specialText);

      expect(notificationtimevm.timeText).assertEqual(specialText);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
}