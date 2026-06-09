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
import { NotificationConfigBaseManager } from '../../../main/ets/manager/NotificationConfigBaseManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationConfigEntity } from '../../../main/ets/model/NotificationConfigEntity';
import { NotificationBaseVm } from '../../../main/ets/notification/vm/NotificationBaseVm';
import { INotificationPinTopLimitDialogVm } from '../../../main/ets/notification/interface/INotificationPinTopLimitDialogVm';
import { display } from '@kit.ArkUI';
import { ResourceVm } from '../../../main/ets/vm/ResourceVm';
import { ClickNotificationErrorCode, ClickNotificationMaintenance } from '../../../main/ets/maintenance/ClickNotificationMaintenance';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationPinTopLimitDialogVm } from '../../../main/ets/vm/NotificationPinTopLimitDialogVm';
export default function NotificationPinTopLimitDialogVmTest() {
  describe('destroy_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_reset_manager_and_controller_to_undefined', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      notificationpintoplimitdialogvm.manager = mockManager;
      let mockController: CustomDialogController = new CustomDialogController();
      notificationpintoplimitdialogvm.controller = mockController;
      notificationpintoplimitdialogvm.destroy();
      expect(notificationpintoplimitdialogvm.manager).assertUndefined();
      expect(notificationpintoplimitdialogvm.controller).assertUndefined();
    });

    it('onCancel_should_log_info_and_resolve_promise_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationConfigBaseManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = notificationConfigBaseManager;
      notificationPinTopLimitDialogVm.controller = new CustomDialogController();

      await notificationPinTopLimitDialogVm.onCancel();

      expect(mockShowInfo).assertCalledWith("Cancel for select canceled pin top appList");
      expect(notificationPinTopLimitDialogVm.showDialogPromise).assertPromiseIsResolved();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('onCancel_should_resolve_promise_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = new NotificationConfigBaseManager();
      notificationPinTopLimitDialogVm.controller = null;

      await notificationPinTopLimitDialogVm.onCancel();

      expect(mockShowInfo).assertCalledWith("Cancel for select canceled pin top appList");
      expect(notificationPinTopLimitDialogVm.showDialogPromise).assertPromiseIsResolved();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_manager_is_null', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_set_pin_top_state_when_enabled_is_false', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, false);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
    });

    it('should_set_pin_top_state_when_enabled_is_true_and_current_pin_top_count_is_less_than_limit', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT - 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([]);
      when(mockfunc5)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_show_dialog_and_cancel_pin_top_when_current_pin_top_count_exceeds_limit', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT + 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([1, 2, 3, 4, 5]);
      when(mockfunc5)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_log_error_when_show_dialog_returns_empty_list_after_showing_dialog', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      let mockfunc6: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT + 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([]);
      when(mockfunc5)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc6)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });
    it('should_reset_manager_and_controller_to_undefined', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      notificationpintoplimitdialogvm.manager = mockManager;
      let mockController: CustomDialogController = new CustomDialogController();
      notificationpintoplimitdialogvm.controller = mockController;
      notificationpintoplimitdialogvm.destroy();
      expect(notificationpintoplimitdialogvm.manager).assertUndefined();
      expect(notificationpintoplimitdialogvm.controller).assertUndefined();
    });

    it('onCancel_should_log_info_and_resolve_promise_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationConfigBaseManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = notificationConfigBaseManager;
      notificationPinTopLimitDialogVm.controller = new CustomDialogController();

      await notificationPinTopLimitDialogVm.onCancel();

      expect(mockShowInfo).assertCalledWith("Cancel for select canceled pin top appList");
      expect(notificationPinTopLimitDialogVm.showDialogPromise).assertPromiseIsResolved();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('onCancel_should_resolve_promise_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = new NotificationConfigBaseManager();
      notificationPinTopLimitDialogVm.controller = null;

      await notificationPinTopLimitDialogVm.onCancel();

      expect(mockShowInfo).assertCalledWith("Cancel for select canceled pin top appList");
      expect(notificationPinTopLimitDialogVm.showDialogPromise).assertPromiseIsResolved();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_manager_is_null', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_set_pin_top_state_when_enabled_is_false', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, false);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
    });

    it('should_set_pin_top_state_when_enabled_is_true_and_current_pin_top_count_is_less_than_limit', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT - 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([]);
      when(mockfunc5)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_show_dialog_and_cancel_pin_top_when_current_pin_top_count_exceeds_limit', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT + 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([1, 2, 3, 4, 5]);
      when(mockfunc5)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_log_error_when_show_dialog_returns_empty_list_after_showing_dialog', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      let mockfunc6: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT + 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([]);
      when(mockfunc5)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc6)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });
    it('should_reset_manager_and_controller_to_undefined', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      notificationpintoplimitdialogvm.manager = mockManager;
      let mockController: CustomDialogController = new CustomDialogController();
      notificationpintoplimitdialogvm.controller = mockController;
      notificationpintoplimitdialogvm.destroy();
      expect(notificationpintoplimitdialogvm.manager).assertUndefined();
      expect(notificationpintoplimitdialogvm.controller).assertUndefined();
    });

    it('onCancel_should_log_info_and_resolve_promise_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationConfigBaseManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = notificationConfigBaseManager;
      notificationPinTopLimitDialogVm.controller = new CustomDialogController();

      await notificationPinTopLimitDialogVm.onCancel();

      expect(mockShowInfo).assertCalledWith("Cancel for select canceled pin top appList");
      expect(notificationPinTopLimitDialogVm.showDialogPromise).assertPromiseIsResolved();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('onCancel_should_resolve_promise_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = new NotificationConfigBaseManager();
      notificationPinTopLimitDialogVm.controller = null;

      await notificationPinTopLimitDialogVm.onCancel();

      expect(mockShowInfo).assertCalledWith("Cancel for select canceled pin top appList");
      expect(notificationPinTopLimitDialogVm.showDialogPromise).assertPromiseIsResolved();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_manager_is_null', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_set_pin_top_state_when_enabled_is_false', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, false);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
    });

    it('should_set_pin_top_state_when_enabled_is_true_and_current_pin_top_count_is_less_than_limit', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT - 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([]);
      when(mockfunc5)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_show_dialog_and_cancel_pin_top_when_current_pin_top_count_exceeds_limit', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT + 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([1, 2, 3, 4, 5]);
      when(mockfunc5)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_log_error_when_show_dialog_returns_empty_list_after_showing_dialog', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      let mockfunc3: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      let mockfunc4: Function = mocker.mockFunc(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      let mockfunc5: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      let mockfunc6: Function = mocker.mockFunc(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);

      let currentPinTopList: NotificationConfigEntity[] = [];
      for (let i = 0; i < notificationpintoplimitdialogvm.PIN_TOP_COUNT + 1; i++) {
        currentPinTopList.push(new NotificationConfigEntity());
      }
      when(mockfunc)().afterReturn(currentPinTopList);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)().afterReturn([]);
      when(mockfunc5)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc6)([ArgumentMatchers.any]).afterReturn(true);

      await notificationpintoplimitdialogvm.setPinTop(1, true);

      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.setPinTopState);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.refreshPinTopDialogData);
      mocker.ignoreMock(NotificationBaseVm, NotificationBaseVm.showPinTopDialog);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(NotificationConfigBaseManager, NotificationConfigBaseManager.batchCancelPinTopState);
    });
  });
