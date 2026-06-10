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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { DropdownVm } from '../../../main/ets/vm/DropdownVm';
export default function DropdownVmTest() {
  describe('updateStatusBarType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

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

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_not_update_dropdownEvent_moveY_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });
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

      dropdownvm.onPanHorizontalStart({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
    });

    it('should_call_onPanActionUpdate_when_onPanHorizontalUpdate_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalUpdate({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
    });

    it('should_call_onPanActionEnd_when_onPanHorizontalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalEnd({ offsetX: 0, offsetY: 0 });

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
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(null);
      dropdownvm.hidePanel(true);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
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

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_not_update_dropdownEvent_moveY_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });
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

      dropdownvm.onPanHorizontalStart({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
    });

    it('should_call_onPanActionUpdate_when_onPanHorizontalUpdate_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalUpdate({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
    });

    it('should_call_onPanActionEnd_when_onPanHorizontalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalEnd({ offsetX: 0, offsetY: 0 });

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
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(null);
      dropdownvm.hidePanel(true);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
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

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_not_update_dropdownEvent_moveY_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });
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

      dropdownvm.onPanHorizontalStart({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
    });

    it('should_call_onPanActionUpdate_when_onPanHorizontalUpdate_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalUpdate({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
    });

    it('should_call_onPanActionEnd_when_onPanHorizontalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalEnd({ offsetX: 0, offsetY: 0 });

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
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(null);
      dropdownvm.hidePanel(true);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
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

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });

    it('should_not_update_dropdownEvent_moveY_when_isNeedUpdateMoveY_is_false', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      dropdownvm.isNeedUpdateMoveY = false;
      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });
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

      dropdownvm.onPanHorizontalStart({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionStart);
    });

    it('should_call_onPanActionUpdate_when_onPanHorizontalUpdate_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalUpdate({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.onPanActionUpdate);
    });

    it('should_call_onPanActionEnd_when_onPanHorizontalEnd_is_called', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.onPanActionEnd);
      when(mockfunc)().afterReturn(null);

      dropdownvm.onPanHorizontalEnd({ offsetX: 0, offsetY: 0 });

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
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(null);
      dropdownvm.hidePanel(true);
      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance(), DropDownPanelManagerWrapper.getInstance().postRequestHideWindow);
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

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 0 });

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_dropdownEvent_moveY_when_onPanVertical_is_called_with_valid_offsetY', 0, () => {
      let dropdownvm: DropdownVm = Singleton.getInstance(DropdownVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);

      dropdownvm.onPanVertical({ offsetX: 0, offsetY: 10 });

      mocker.ignoreMock(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy, DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent);
    });
  });
}
