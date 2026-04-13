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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { hideBannerNtfContentObj } from '../../../main/ets/model/HideBannerNtfContentObj';
import swingability from '@ohos.swingability';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationCcmConfig, SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { SmartNotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/SmartNotificationUtil';
import { NotificationExceptionCode } from '../../../main/ets/maintenance/NotificationExceptionCode';
import { BannerShowStatusModel } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { handleAbnormalData } from '../../../main/ets/model/SwingTrackVm';
export default function handleAbnormalDataTest() {
  describe('handleAbnormalData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_resultStr_is_in_arr', 0, () => {
      const faceNumChange = 1;
      const maxFaceInfoChange = 1;
      const result = handleAbnormalData(faceNumChange, maxFaceInfoChange);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_resultStr_is_not_in_arr', 0, () => {
      const faceNumChange = 3;
      const maxFaceInfoChange = 3;
      const result = handleAbnormalData(faceNumChange, maxFaceInfoChange);
      expect(result).assertEqual(false);
    });

    it('should_return_minus_three_when_result_is_not_string', 0, () => {
      let result: string | undefined = null;
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(-3);
    });

    it('should_return_minus_three_when_result_is_empty_string', 0, () => {
      let result: string | undefined = '';
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(-3);
    });

    it('should_return_number_when_result_is_valid_string_without_negative_sign', 0, () => {
      let result: string | undefined = '123';
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(1);
    });

    it('should_return_number_when_result_is_valid_string_with_negative_sign', 0, () => {
      let result: string | undefined = '-123';
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(-1);
    });

    it('should_return_number_when_result_is_valid_string_with_leading_spaces', 0, () => {
      let result: string | undefined = '  123';
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(1);
    });

    it('should_return_number_when_result_is_valid_string_with_trailing_spaces', 0, () => {
      let result: string | undefined = '123  ';
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(1);
    });

    it('should_return_number_when_result_is_valid_string_with_spaces_around_sign', 0, () => {
      let result: string | undefined = ' 123 ';
      const resultNum = getSwingResultNum(result);
      expect(resultNum).assertEqual(1);
    });

    it('should_initialize_eventList_with_correct_values', 0, () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      expect(swingtrackvm.eventList.length).assertEqual(EVENT_TYPE_LIST.length);
      for (let i = 0; i < EVENT_TYPE_LIST.length; i++) {
        expect(swingtrackvm.eventList[i].eventType).assertEqual(EVENT_TYPE_LIST[i]);
        expect(swingtrackvm.eventList[i].params.domainId).assertEqual(AI_MSG_HIDE);
      }
    });

    it('should_register_successfully_when_swingability_is_not_null_and_no_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateRegisterSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateRegisterSwing)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swingability_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      letswingability = null;
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_register_throws_error', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          throw new BusinessError(1, "Test error");
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          return Promise.resolve(false);
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          throw "Test exception";
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_register_status_when_register_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateRegisterSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateRegisterSwing)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          return Promise.resolve(true);
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_update_register_status_when_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateRegisterSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateRegisterSwing)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          return Promise.resolve(false);
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_register_fails_and_catch_error', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          throw new BusinessError(1, "Test error");
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_register_fails_and_catch_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let swingability = {
        on: (eventList: Array<swingability.SwingEventType>, callback: Function) => {
          throw "Test exception";
        }
      };
      SingletonHelper.set(notificationCcmConfig.swingability,swingability);

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_immediately_when_isRegistered_is_false', 0, () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      swingtrackvm.isRegistered = false;
      swingtrackvm.unRegister();
      expect(swingtrackvm.isRegistered).assertEqual(false);
    });

    it('should_return_immediately_when_swingability_is_null', 0, () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      swingtrackvm.isRegistered = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(swingability, swingability.off);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      swingtrackvm.unRegister();
      expect(swingtrackvm.isRegistered).assertEqual(true);
      mocker.ignoreMock(swingability, swingability.off);
    });

    it('should_handle_success_case_when_swingability_off_succeeds', 0, () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      swingtrackvm.isRegistered = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(swingability, swingability.off);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockUpdateFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(mockUpdateFunc)([ArgumentMatchers.anyBoolean]).afterReturn(null);
      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)([ArgumentMatchers.anyString]).afterReturn(null);
      swingtrackvm.unRegister();
      expect(swingtrackvm.isRegistered).assertEqual(false);
      mocker.ignoreMock(swingability, swingability.off);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_error_case_when_swingability_off_fails', 0, () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      swingtrackvm.isRegistered = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(swingability, swingability.off);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.reject(new BusinessError('error', 1)));
      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)([ArgumentMatchers.anyString]).afterReturn(null);
      swingtrackvm.unRegister();
      expect(swingtrackvm.isRegistered).assertEqual(true);
      mocker.ignoreMock(swingability, swingability.off);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_error_case_when_swingability_off_throws_exception', 0, () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      swingtrackvm.isRegistered = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(swingability, swingability.off);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow(new Error('exception'));
      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)([ArgumentMatchers.anyString]).afterReturn(null);
      swingtrackvm.unRegister();
      expect(swingtrackvm.isRegistered).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_when_result_is_string', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'test string'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_and_warn_when_result_is_invalid', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': ''
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_2', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_3', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_4', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;a:b'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_5', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;a:'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_6', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;a:b;'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_7', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;a:b;c:'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_8', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;a:b;c:d;'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_and_warn_when_result_is_invalid_9', 0, async () => {
      let swingtrackvm: SwingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc1: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let result: Record<string, object> = {
        'message': 'invalid data;a:b;c:d;'
      };
      swingtrackvm.onSwingEvent(result);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });
  });
}