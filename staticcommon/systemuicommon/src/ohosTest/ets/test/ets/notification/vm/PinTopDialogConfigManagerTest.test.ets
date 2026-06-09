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
import { NtfPinTopLimitDialogConfig } from '../../../../main/ets/notification/vm/NtfPinTopLimitDialogConfig';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PinTopDialogConfigManager } from '../../../../main/ets/notification/vm/PinTopDialogConfigManager';
export default function PinTopDialogConfigManagerTest() {
  describe('getInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      let topLimitDialogConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      when(mockfunc2)().afterReturn(topLimitDialogConfig);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
    it('should_log_info_when_setConfig_is_called', 0, () => {
      let config: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      pintopdialogconfigmanager.setConfig(config);
      expect(pintopdialogconfigmanager.config).assertEqual(config);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_config_when_called', 0, () => {
      let pintopdialogconfigmanager: PinTopDialogConfigManager = PinTopDialogConfigManager.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockConfig: NtfPinTopLimitDialogConfig = new NtfPinTopLimitDialogConfig();

      const result = pintopdialogconfigmanager.getConfig();
      expect(result).assertDeepEquals(mockConfig);

    });

    it('should_return_same_instance', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_new_instance_when_top_limit_dialog_config_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(null);
      let instance1 = PinTopDialogConfigManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(instance1, instance1.getTopLimitDialogConfig);
      when(mockfunc2)().afterReturn(null);
      let instance2 = PinTopDialogConfigManager.getInstance();
      expect(instance1).not.assertEqual(instance2);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(instance1, instance1.getTopLimitDialogConfig);
    });
  });
}
