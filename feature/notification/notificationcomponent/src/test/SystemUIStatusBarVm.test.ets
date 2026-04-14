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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { SystemUIStatusBarVm } from '../../../main/ets/vm/SystemUIStatusBarVm';
export default function SystemUIStatusBarVmTest() {
  describe('changeShowBlueEnable_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_log_info_when_showBlueChangeEnable_is_different_from_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_showBlueChangeEnable_is_same_as_enable', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      systemuistatusbarvm.showBlueChangeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_call_changeIsShowBlue_when_enable_is_false', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(false);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

    it('should_not_call_changeIsShowBlue_when_enable_is_true', 0, () => {
      let systemuistatusbarvm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
      let mocker: MockKit = new MockKit();
      let mockChangeIsShowBlue: Function = mocker.mockFunc(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
      when(mockChangeIsShowBlue)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      systemuistatusbarvm.changeShowBlueEnable(true);

      mocker.ignoreMock(systemuistatusbarvm, systemuistatusbarvm.changeIsShowBlue);
    });

  });
}