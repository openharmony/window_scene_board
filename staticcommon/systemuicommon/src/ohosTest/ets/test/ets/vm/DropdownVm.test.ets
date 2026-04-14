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
import { LogHelper, LogDomain, ThreadUtil } from '@ohos/basicutils';
import {
  DropDownEvent,
  DropDownPanelManagerWrapper,
  TargetChangeState,
  TargetPanel,
} from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { UIUtils } from '@ohos.arkui.StateManagement';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { DropDownPanelConstants } from '../../../main/ets/manager/DropDownPanelManager';
import { StatusBarType } from '../../../main/ets/plugin/info/StatusBarType';
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
import { DropdownVm } from '../../../main/ets/vm/DropdownVm';

export default function DropdownVmTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_init_success', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      dropdownvm.init();

      expect(mockShowInfo).assertCalledWith('Init end');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_init_throws_exception', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockError)(ArgumentMatchers.any).afterReturnNothing();


      dropdownvm.init();

      expect(mockError).assertCalledWith('Init error:', 'Error');
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_add_watcher_when_init_success', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let dropDownEventProxy = DropDownPanelManagerWrapper.getInstance().dropDownEventProxy;
      let mockAddWatcher: Function = mocker.mockFunc(dropDownEventProxy, dropDownEventProxy.addWatcher);
      when(mockAddWatcher)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      dropdownvm.init();

      expect(mockAddWatcher).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(dropDownEventProxy, dropDownEventProxy.addWatcher);
    });

    it('should_update_statusBarType_when_valid_statusBarType_is_provided', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.updateStatusBarType(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
      expect(dropdownvm.statusBarType).assertEqual(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
    });

    it('should_log_info_when_onPanVertical_is_called_with_invalid_direction', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      dropdownvm.onPanVertical({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({
        offsetX: 0, offsetY: 10
      });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_not_update_dropdownEvent_moveY_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      dropdownvm.onPanVertical({
        offsetX: 0, offsetY: 10
      });
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);
    });

    it('should_call_touchEndCheckAnim_when_onPanVerticalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
    });

    it('should_call_touchEndCheckAnim_and_clearDropDirection_when_onPanVerticalCancel_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalCancel();

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
    });

    it('should_call_onPanActionStart_when_onPanHorizontalStart_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalStart({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
    });

    it('should_call_onPanActionUpdate_when_onPanHorizontalUpdate_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalUpdate({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
    });

    it('should_call_onPanActionEnd_when_onPanHorizontalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalEnd({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
    });

    it('should_call_touchEndCheckAnim_when_touchEndCheckAnim_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.touchEndCheckAnim();

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
    });

    it('should_call_postRequestHideWindow_when_hidePanel_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(null);
      dropdownvm.hidePanel(true);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
    });

    it('should_log_info_when_setIsNeedUpdateMoveY_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.setIsNeedUpdateMoveY(true);

      expect(mockfunc).assertCalledWith("setIsNeedUpdateMoveY: true");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isNeedUpdateMoveY_to_true_when_setIsNeedUpdateMoveY_is_called_with_true', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.setIsNeedUpdateMoveY(true);

      expect(dropdownvm.isNeedUpdateMoveY).assertTrue();
    });

    it('should_set_isNeedUpdateMoveY_to_false_when_setIsNeedUpdateMoveY_is_called_with_false', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.setIsNeedUpdateMoveY(false);

      expect(dropdownvm.isNeedUpdateMoveY).assertFalse();
    });

    it('should_call_setEnableRotate_when_enabled_is_true', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getMainScreenSession);
      let mockScreenSession: SCBScreenSession = new SCBScreenSession();
      when(mockfunc)().afterReturn(mockScreenSession);

      dropdownvm.setRotateEnabled(true);

      mocker.ignoreMock(screenSessionManager, screenSessionManager.getMainScreenSession);
    });

    it('should_call_setEnableRotate_when_enabled_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getMainScreenSession);
      let mockScreenSession: SCBScreenSession = new SCBScreenSession();
      when(mockfunc)().afterReturn(mockScreenSession);

      dropdownvm.setRotateEnabled(false);

      mocker.ignoreMock(screenSessionManager, screenSessionManager.getMainScreenSession);
    });

    it('should_call_updateStartPosition_when_updateStartPosition_is_called', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().updateStartPosition);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);

      dropdownvm.updateStartPosition(100, 200);

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().updateStartPosition);
    });

    it('should_call_updateEndPosition_when_updateEndPosition_is_called', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      dropdownvm.updateEndPosition(100, 200);

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_call_dropDownPanelChangeMain_when_onDropdownChange_is_called', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(dropdownvm, dropdownvm.dropDownPanelChangeMain);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      dropdownvm.onDropdownChange();

      mocker.ignoreMock(dropdownvm, dropdownvm.dropDownPanelChangeMain);
    });

    it('should_return_false_when_dropdownEvent_target_is_NONE', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.dropdownEvent.target = TargetPanel.NONE;
      expect(dropdownvm.isShow).assertEqual(false);
    });

    it('should_return_true_when_dropdownEvent_target_is_not_NONE', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.dropdownEvent.target = TargetPanel.HOME_PAGE;
      expect(dropdownvm.isShow).assertEqual(true);
    });

    it('should_return_true_when_statusBarType_is_TYPE_MAIN_PHONE_DROPDOWN', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.statusBarType = StatusBarType.TYPE_MAIN_PHONE_DROPDOWN;
      expect(dropdownvm.isDropDown).assertTrue();
    });

    it('should_return_false_when_statusBarType_is_not_TYPE_MAIN_PHONE_DROPDOWN', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.statusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
      expect(dropdownvm.isDropDown).assertFalse();
    });

    it('should_return_immediately_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = 10;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);
    });

    it('should_return_immediately_when_getDropDirection_is_not_vertical', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.HORIZONTAL);
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = 10;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
    });

    it('should_update_dropdownEvent_moveY_when_offsetY_is_below_DISTANCE_FOLD_NOTIFICATION_DROPDOWN_and_isPanelDismissing_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc1)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let mockfunc2: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().animDelayToDismiss);
      when(mockfunc3)(ArgumentMatchers.anyNumber).afterReturnNothing();
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN - 1;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().animDelayToDismiss);
    });

    it('should_update_dropdownEvent_moveY_when_offsetY_is_above_0', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = 10;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
    });

    it('should_call_updateSilent_and_showInfo_when_offsetY_is_below_DISTANCE_FOLD_NOTIFICATION_DROPDOWN_and_isPanelDismissing_is_true', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc1)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let mockfunc2: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().updateSilent);
      when(mockfunc3)(ArgumentMatchers.anyObj).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc4)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN - 1;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().updateSilent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearDropDirection_when_offsetY_is_below_0', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let mockfunc2: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().clearDropDirection);
      when(mockfunc2)().afterReturnNothing();
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = -1;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().clearDropDirection);
    });

    it('should_logInfo_when_onPanVerticalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_touchEndCheckAnim_when_onPanVerticalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      let event: GestureEvent = {
        offsetX: 0,
        offsetY: DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN - 1
      };
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_invalid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      let event: GestureEvent = {
        offsetX: 0,
        offsetY: -1
      };
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_call_touchEndCheckAnim_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_log_info_when_init_success_1', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      dropdownvm.init();

      expect(mockShowInfo).assertCalledWith('Init end');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_init_throws_exception_1', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockError)(ArgumentMatchers.any).afterReturnNothing();


      dropdownvm.init();

      expect(mockError).assertCalledWith('Init error:', 'Error');
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_add_watcher_when_init_success_1', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let dropDownEventProxy = DropDownPanelManagerWrapper.getInstance().dropDownEventProxy;
      let mockAddWatcher: Function = mocker.mockFunc(dropDownEventProxy, dropDownEventProxy.addWatcher);
      when(mockAddWatcher)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      dropdownvm.init();

      expect(mockAddWatcher).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(dropDownEventProxy, dropDownEventProxy.addWatcher);
    });

    it('should_update_statusBarType_when_valid_statusBarType_is_provided_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.updateStatusBarType(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
      expect(dropdownvm.statusBarType).assertEqual(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
    });

    it('should_log_info_when_onPanVertical_is_called_with_invalid_direction_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      dropdownvm.onPanVertical({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({
        offsetX: 0, offsetY: 10
      });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_not_update_dropdownEvent_moveY_when_isNeedUpdateMoveY_is_false_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      dropdownvm.onPanVertical({
        offsetX: 0, offsetY: 10
      });
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);
    });

    it('should_call_touchEndCheckAnim_when_onPanVerticalEnd_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
    });

    it('should_call_touchEndCheckAnim_and_clearDropDirection_when_onPanVerticalCancel_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalCancel();

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
    });

    it('should_call_onPanActionStart_when_onPanHorizontalStart_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalStart({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
    });

    it('should_call_onPanActionUpdate_when_onPanHorizontalUpdate_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalUpdate({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
    });

    it('should_call_onPanActionEnd_when_onPanHorizontalEnd_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalEnd({
        offsetX: 0, offsetY: 0
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
    });

    it('should_call_touchEndCheckAnim_when_touchEndCheckAnim_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.touchEndCheckAnim();

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.touchEndCheckAnim);
    });

    it('should_call_postRequestHideWindow_when_hidePanel_is_called_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(null);
      dropdownvm.hidePanel(true);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
    });

    it('should_log_info_when_setIsNeedUpdateMoveY_is_called_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.setIsNeedUpdateMoveY(true);

      expect(mockfunc).assertCalledWith("setIsNeedUpdateMoveY: true");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isNeedUpdateMoveY_to_true_when_setIsNeedUpdateMoveY_is_called_with_true_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.setIsNeedUpdateMoveY(true);

      expect(dropdownvm.isNeedUpdateMoveY).assertTrue();
    });

    it('should_set_isNeedUpdateMoveY_to_false_when_setIsNeedUpdateMoveY_is_called_with_false_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.setIsNeedUpdateMoveY(false);

      expect(dropdownvm.isNeedUpdateMoveY).assertFalse();
    });

    it('should_call_setEnableRotate_when_enabled_is_true_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getMainScreenSession);
      let mockScreenSession: SCBScreenSession = new SCBScreenSession();
      when(mockfunc)().afterReturn(mockScreenSession);

      dropdownvm.setRotateEnabled(true);

      mocker.ignoreMock(screenSessionManager, screenSessionManager.getMainScreenSession);
    });

    it('should_call_setEnableRotate_when_enabled_is_false_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getMainScreenSession);
      let mockScreenSession: SCBScreenSession = new SCBScreenSession();
      when(mockfunc)().afterReturn(mockScreenSession);

      dropdownvm.setRotateEnabled(false);

      mocker.ignoreMock(screenSessionManager, screenSessionManager.getMainScreenSession);
    });

    it('should_call_updateStartPosition_when_updateStartPosition_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().updateStartPosition);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);

      dropdownvm.updateStartPosition(100, 200);

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(),
        DropDownPanelManagerWrapper.getInstance().updateStartPosition);
    });

    it('should_call_updateEndPosition_when_updateEndPosition_is_called_1', 0, async () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      dropdownvm.updateEndPosition(100, 200);

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy,
        DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_call_dropDownPanelChangeMain_when_onDropdownChange_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(dropdownvm, dropdownvm.dropDownPanelChangeMain);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      dropdownvm.onDropdownChange();

      mocker.ignoreMock(dropdownvm, dropdownvm.dropDownPanelChangeMain);
    });

    it('should_return_false_when_dropdownEvent_target_is_NONE_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.dropdownEvent.target = TargetPanel.NONE;
      expect(dropdownvm.isShow).assertEqual(false);
    });

    it('should_return_true_when_dropdownEvent_target_is_not_NONE_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.dropdownEvent.target = TargetPanel.HOME_PAGE;
      expect(dropdownvm.isShow).assertEqual(true);
    });

    it('should_return_true_when_statusBarType_is_TYPE_MAIN_PHONE_DROPDOWN_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.statusBarType = StatusBarType.TYPE_MAIN_PHONE_DROPDOWN;
      expect(dropdownvm.isDropDown).assertTrue();
    });

    it('should_return_false_when_statusBarType_is_not_TYPE_MAIN_PHONE_DROPDOWN_1', 0, () => {
      let dropdownvm: DropdownVm = DropdownVm.INSTANCE;
      dropdownvm.statusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
      expect(dropdownvm.isDropDown).assertFalse();
    });

    it('should_return_immediately_when_isNeedUpdateMoveY_is_false_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = 10;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);
    });

    it('should_return_immediately_when_getDropDirection_is_not_vertical_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.HORIZONTAL);
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = 10;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
    });

    it('should_update_dropdownEvent_moveY_when_offsetY_is_below_DISTANCE_FOLD_NOTIFICATION_DROPDOWN_and_isPanelDismissing_is_false_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc1)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let mockfunc2: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().animDelayToDismiss);
      when(mockfunc3)(ArgumentMatchers.anyNumber).afterReturnNothing();
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN - 1;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().animDelayToDismiss);
    });

    it('should_update_dropdownEvent_moveY_when_offsetY_is_above_0_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = 10;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
    });

    it('should_call_updateSilent_and_showInfo_when_offsetY_is_below_DISTANCE_FOLD_NOTIFICATION_DROPDOWN_and_isPanelDismissing_is_true_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc1)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let mockfunc2: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().updateSilent);
      when(mockfunc3)(ArgumentMatchers.anyObj).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc4)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN - 1;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().isPanelDismissing);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().updateSilent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearDropDirection_when_offsetY_is_below_0_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(TargetChangeState.VERTICAL);
      let mockfunc2: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().clearDropDirection);
      when(mockfunc2)().afterReturnNothing();
      let event: GestureEvent = new GestureEvent();
      event.offsetX = 10;
      event.offsetY = -1;
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().getDropDirection);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().clearDropDirection);
    });

    it('should_logInfo_when_onPanVerticalEnd_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_touchEndCheckAnim_when_onPanVerticalEnd_is_called_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      let event: GestureEvent = {
        offsetX: 0,
        offsetY: DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN - 1
      };
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(event.offsetY);

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_invalid_offsetY_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      let event: GestureEvent = {
        offsetX: 0,
        offsetY: -1
      };
      dropdownvm.onPanVertical(event);
      expect(dropdownvm.dropdownEvent.moveY).assertEqual(0);

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_call_touchEndCheckAnim_when_isNeedUpdateMoveY_is_false_1', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_call_touchEndCheckAnim_when_isNeedUpdateMoveY_is_false_2', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_call_touchEndCheckAnim_when_isNeedUpdateMoveY_is_false_3', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });

    it('should_not_call_touchEndCheckAnim_when_isNeedUpdateMoveY_is_false_4', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      let mocker: MockKit = new MockKit();
      let dropDownPanelManager: DropDownPanelManager = DropDownPanelManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanVerticalEnd();

      mocker.ignoreMock(dropDownPanelManager, dropDownPanelManager.touchEndCheckAnim);
    });
  });
}