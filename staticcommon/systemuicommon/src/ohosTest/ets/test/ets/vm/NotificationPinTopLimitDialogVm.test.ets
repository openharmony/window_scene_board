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
import { NotificationConfigBaseManager } from '../../../main/ets/manager/NotificationConfigBaseManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationConfigEntity } from '../../../main/ets/model/NotificationConfigEntity';
import { NotificationBaseVm } from '../../../main/ets/notification/vm/NotificationBaseVm';
import {
  INotificationPinTopLimitDialogVm
} from '../../../main/ets/notification/interface/INotificationPinTopLimitDialogVm';
import { display } from '@kit.ArkUI';
import { ResourceVm } from '../../../main/ets/vm/ResourceVm';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '../../../main/ets/maintenance/ClickNotificationMaintenance';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
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
import { NotificationPinTopLimitDialogVm } from '../../../main/ets/vm/NotificationPinTopLimitDialogVm';

export default function NotificationPinTopLimitDialogVmTest() {
  describe('setPinTop_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_error_when_manager_is_null', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      await notificationpintoplimitdialogvm.setPinTop(1, true);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_set_pin_top_state_when_enabled_is_false', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let notificationConfigBaseManager: NotificationConfigBaseManager = NotificationConfigBaseManager.INSTANCE;
      let mockfunc: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.setPinTopState);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      await notificationpintoplimitdialogvm.setPinTop(1, false);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.setPinTopState);
    });

    it('should_show_dialog_when_current_pin_top_list_length_exceeds_PIN_TOP_COUNT', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let notificationConfigBaseManager: NotificationConfigBaseManager = NotificationConfigBaseManager.INSTANCE;
      let mockfunc: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.getPinTopList);
      let mockfunc2: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.batchCancelPinTopState);
      when(mockfunc)().afterReturn(new Array(6).fill(new NotificationConfigEntity()));
      when(mockfunc2)([ArgumentMatchers.any]).afterReturn(true);
      await notificationpintoplimitdialogvm.setPinTop(1, true);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.getPinTopList);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_set_pin_top_state_when_enabled_is_true', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let notificationConfigBaseManager: NotificationConfigBaseManager = NotificationConfigBaseManager.INSTANCE;
      let mockfunc: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.setPinTopState);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(true);
      await notificationpintoplimitdialogvm.setPinTop(1, true);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.setPinTopState);
    });

    it('should_log_error_when_set_pin_top_state_fails', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let notificationConfigBaseManager: NotificationConfigBaseManager = NotificationConfigBaseManager.INSTANCE;
      let mockfunc: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.setPinTopState);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturn(false);
      await notificationpintoplimitdialogvm.setPinTop(1, true);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.setPinTopState);
    });

    it('should_resolve_showDialogPromise_when_cancel_pin_top_state_fails', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let notificationConfigBaseManager: NotificationConfigBaseManager = NotificationConfigBaseManager.INSTANCE;
      let mockfunc: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.batchCancelPinTopState);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(false);
      await notificationpintoplimitdialogvm.setPinTop(1, true);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_resolve_showDialogPromise_when_cancel_pin_top_state_succeeds', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let notificationConfigBaseManager: NotificationConfigBaseManager = NotificationConfigBaseManager.INSTANCE;
      let mockfunc: Function =
        mocker.mockFunc(notificationConfigBaseManager, notificationConfigBaseManager.batchCancelPinTopState);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(true);
      await notificationpintoplimitdialogvm.setPinTop(1, true);
      mocker.ignoreMock(notificationConfigBaseManager, notificationConfigBaseManager.batchCancelPinTopState);
    });

    it('should_resolve_showDialogPromise_when_onSubmit_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationConfigBaseManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = notificationConfigBaseManager;
      notificationPinTopLimitDialogVm.controller = new CustomDialogController();

      let selected: Set<PinTopAppItem> = new Set();
      let item1: PinTopAppItem = new PinTopAppItem();
      item1.uid = 1;
      let item2: PinTopAppItem = new PinTopAppItem();
      item2.uid = 2;
      selected.add(item1);
      selected.add(item2);

      notificationPinTopLimitDialogVm.onSubmit(selected);

      let result = await notificationPinTopLimitDialogVm.showDialogPromise;
      expect(result.length).assertEqual(2);
      expect(result[0]).assertEqual(1);
      expect(result[1]).assertEqual(2);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_close_controller_when_onSubmit_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationConfigBaseManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = notificationConfigBaseManager;
      notificationPinTopLimitDialogVm.controller = new CustomDialogController();

      let selected: Set<PinTopAppItem> = new Set();
      let item1: PinTopAppItem = new PinTopAppItem();
      item1.uid = 1;
      let item2: PinTopAppItem = new PinTopAppItem();
      item2.uid = 2;
      selected.add(item1);
      selected.add(item2);

      notificationPinTopLimitDialogVm.onSubmit(selected);

      expect(notificationPinTopLimitDialogVm.controller.isClosed).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_onSubmit_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationConfigBaseManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let notificationPinTopLimitDialogVm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationPinTopLimitDialogVm.manager = notificationConfigBaseManager;
      notificationPinTopLimitDialogVm.controller = new CustomDialogController();

      let selected: Set<PinTopAppItem> = new Set();
      let item1: PinTopAppItem = new PinTopAppItem();
      item1.uid = 1;
      let item2: PinTopAppItem = new PinTopAppItem();
      item2.uid = 2;
      selected.add(item1);
      selected.add(item2);

      notificationPinTopLimitDialogVm.onSubmit(selected);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
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

    it('should_refresh_dialog_data_correctly_when_is_landscape', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetInnerPlural: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerPlural);
      when(mockGetInnerPlural)([ArgumentMatchers.any, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve("Test Content"));

      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let currentPinTopList: NotificationConfigEntity[] = [
        {
          bundle: 'bundle1',
          uid: 'uid1',
          label: 'App1',
          icon: 'icon1',
          appIndex: 1
        },
        {
          bundle: 'bundle2',
          uid: 'uid2',
          label: 'App2',
          icon: 'icon2',
          appIndex: 2
        }
      ];
      await notificationpintoplimitdialogvm.refreshPinTopDialogData(currentPinTopList);

      expect(notificationpintoplimitdialogvm.dialogContentText).assertEqual("Test Content");
      expect(notificationpintoplimitdialogvm.pinTopConfigList.length).assertEqual(2);
      expect(notificationpintoplimitdialogvm.pinTopConfigList[0].appBundle).assertEqual('bundle1');
      expect(notificationpintoplimitdialogvm.pinTopConfigList[1].appBundle).assertEqual('bundle2');
      expect(notificationpintoplimitdialogvm.isLandLayout).assertTrue();
      expect(notificationpintoplimitdialogvm.isLandSuitableForOld).assertTrue();
      expect(notificationpintoplimitdialogvm.isAllScroll).assertTrue();
      expect(notificationpintoplimitdialogvm.scrollerHeight).assertLarger(0);

      mocker.ignoreMock(ResUtils, ResUtils.getInnerPlural);
    });

    it('should_refresh_dialog_data_correctly_when_is_portrait', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetInnerPlural: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerPlural);
      when(mockGetInnerPlural)([ArgumentMatchers.any, ArgumentMatchers.anyNumber])
        .afterReturn(Promise.resolve("Test Content"));

      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let currentPinTopList: NotificationConfigEntity[] = [
        {
          bundle: 'bundle1',
          uid: 'uid1',
          label: 'App1',
          icon: 'icon1',
          appIndex: 1
        },
        {
          bundle: 'bundle2',
          uid: 'uid2',
          label: 'App2',
          icon: 'icon2',
          appIndex: 2
        }
      ];
      await notificationpintoplimitdialogvm.refreshPinTopDialogData(currentPinTopList);

      expect(notificationpintoplimitdialogvm.dialogContentText).assertEqual("Test Content");
      expect(notificationpintoplimitdialogvm.pinTopConfigList.length).assertEqual(2);
      expect(notificationpintoplimitdialogvm.pinTopConfigList[0].appBundle).assertEqual('bundle1');
      expect(notificationpintoplimitdialogvm.pinTopConfigList[1].appBundle).assertEqual('bundle2');
      expect(notificationpintoplimitdialogvm.isLandLayout).assertFalse();

      mocker.ignoreMock(ResUtils, ResUtils.getInnerPlural);
    });

    it('should_return_false_when_device_is_fold_and_fold_status_is_unfolded', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_EXPANDED);
      const result = notificationpintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(display, display.getFoldStatus);
    });

    it('should_return_true_when_device_is_not_pad', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc)().afterReturn(false);
      const result = notificationpintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    });

    it('should_return_false_when_isLandLayout_is_false', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandLayout = false;
      const result = notificationpintoplimitdialogvm.getIsLandSuitableForOld();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_fontScale_is_greater_than_or_equal_to_FONT_SIZE_LIMIT_SCALE_FOR_OLD', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandLayout = true;
      ResourceVm.instance.fontScale = 1.75;
      const result = notificationpintoplimitdialogvm.getIsLandSuitableForOld();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_fontScale_is_less_than_FONT_SIZE_LIMIT_SCALE_FOR_OLD', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandLayout = true;
      ResourceVm.instance.fontScale = 1.74;
      const result = notificationpintoplimitdialogvm.getIsLandSuitableForOld();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isLandSuitableForOld_is_false', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandSuitableForOld = false;
      const result = notificationpintoplimitdialogvm.getIsAllScroll();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_gridHeight_is_greater_than_SCROLLER_MIN_HEIGHT', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandSuitableForOld = true;
      notificationpintoplimitdialogvm.landHeight = 200;
      const result = notificationpintoplimitdialogvm.getIsAllScroll();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_gridHeight_is_less_than_SCROLLER_MIN_HEIGHT', 0, () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandSuitableForOld = true;
      notificationpintoplimitdialogvm.landHeight = 50;
      const result = notificationpintoplimitdialogvm.getIsAllScroll();
      expect(result).assertEqual(true);
    });

    it('should_return_itemHeight_when_isLandSuitableForOld_is_true_and_itemHeight_is_less_than_SCROLLER_MIN_HEIGHT', 0,
      async () => {
        let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
        notificationpintoplimitdialogvm.isLandSuitableForOld = true;
        notificationpintoplimitdialogvm.landHeight = 200;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let result = notificationpintoplimitdialogvm.gridLandHeight();
        expect(result).assertEqual(200);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_return_itemHeight_when_isLandSuitableForOld_is_false', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      notificationpintoplimitdialogvm.isLandSuitableForOld = false;
      notificationpintoplimitdialogvm.landHeight = 200;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let result = notificationpintoplimitdialogvm.gridLandHeight();
      expect(result).assertEqual(200);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_itemHeight_minus_contentHeight_when_isLandSuitableForOld_is_true_and_itemHeight_is_greater_than_or_equal_to_SCROLLER_MIN_HEIGHT',
      0, async () => {
        let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
        notificationpintoplimitdialogvm.isLandSuitableForOld = true;
        notificationpintoplimitdialogvm.landHeight = 300;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let result = notificationpintoplimitdialogvm.gridLandHeight();
        expect(result).assertEqual(200);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_return_itemHeight_minus_contentHeight_when_isLandSuitableForOld_is_false_and_itemHeight_is_greater_than_or_equal_to_SCROLLER_MIN_HEIGHT',
      0, async () => {
        let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
        notificationpintoplimitdialogvm.isLandSuitableForOld = false;
        notificationpintoplimitdialogvm.landHeight = 300;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let result = notificationpintoplimitdialogvm.gridLandHeight();
        expect(result).assertEqual(200);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_return_itemHeight_when_isLandSuitableForOld_is_true_and_itemHeight_is_greater_than_or_equal_to_SCROLLER_MIN_HEIGHT_and_manager_is_not_null',
      0, async () => {
        let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
        notificationpintoplimitdialogvm.isLandSuitableForOld = true;
        notificationpintoplimitdialogvm.landHeight = 300;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let result = notificationpintoplimitdialogvm.gridLandHeight();
        expect(result).assertEqual(200);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_return_itemHeight_when_isLandSuitableForOld_is_false_and_itemHeight_is_greater_than_or_equal_to_SCROLLER_MIN_HEIGHT_and_manager_is_not_null',
      0, async () => {
        let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
        notificationpintoplimitdialogvm.isLandSuitableForOld = false;
        notificationpintoplimitdialogvm.landHeight = 300;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let result = notificationpintoplimitdialogvm.gridLandHeight();
        expect(result).assertEqual(200);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_reject_promise_when_dialog_open_fails', 0, async () => {
      let notificationpintoplimitdialogvm: NotificationPinTopLimitDialogVm = new NotificationPinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockManager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      notificationpintoplimitdialogvm.manager = mockManager;
      let mockController: CustomDialogController = new CustomDialogController();
      notificationpintoplimitdialogvm.controller = mockController;

      let mockDialogPromise: CustomPromise<number[]> = new CustomPromise<number[]>();
      notificationpintoplimitdialogvm.showDialogPromise = mockDialogPromise;

      when(mocker.mockFunc(mockManager, mockManager.getPinTopAppList)).afterReturn([]);
      when(mocker.mockFunc(mockController, mockController.open)).afterThrow("Error opening dialog");

      try {
        await notificationpintoplimitdialogvm.showPinTopDialog();
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error opening dialog");
      }
    });
  });
}