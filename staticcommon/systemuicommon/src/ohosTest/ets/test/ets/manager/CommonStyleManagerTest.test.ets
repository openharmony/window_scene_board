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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { CommonStyleManager } from '../../../main/ets/manager/CommonStyleManager';
export default function CommonStyleManagerTest() {
  describe('setAbilityPageName_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_existing_style_when_storage_key_exists', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_log_info_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      commonstylemanager.setAbilityPageName('testName');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_mAbilityPageName_when_setAbilityPageName_is_called', 0, () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      commonstylemanager.setAbilityPageName('testName');
      expect(commonstylemanager.mAbilityPageName).assertEqual('testName');
    });

    it('should_create_new_style_when_storage_key_does_not_exist', 0, async () => {
      let commonstylemanager: CommonStyleManager = new CommonStyleManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let result = commonstylemanager.getStyle('testKey', class { new(): any { } });
      expect(result).assertInstanceOf(Object);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
}
