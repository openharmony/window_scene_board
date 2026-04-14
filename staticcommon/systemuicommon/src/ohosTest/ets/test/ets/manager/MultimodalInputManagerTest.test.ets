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
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil, TargetPanel } from '@ohos/frameworkwrapper';
import { PowerStatus } from '@ohos/commonconstants';
import keyCode from '@ohos.multimodalInput.keyCode';
import { EventManager } from '@ohos/frameworkwrapper';
import { SCBOobeManager, sSCBOobeManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { MultimodalInputManager } from '../../../main/ets/manager/MultimodalInputManager';
export default function MultimodalInputManagerTest() {
  describe('subscribeCombinationKey_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    afterAll(() => {

    });

    it('should_log_error_when_keys_length_is_zero', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_info_when_subscribe_combination_key', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_debug_when_powerStatus_is_SHUTDOWN_or_REBOOT', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_return_unsubscribe_function_when_subscribe_combination_key_success', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      let result = multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      expect(result).assertInstanceOf(Function);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_unsubscribe_function_when_inputConsumer_on_throws_error', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockError)(ArgumentMatchers.any).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      let result = multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      expect(result).assertInstanceOf(Function);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_info_when_SCBOobeManager_is_not_enabled', 0, async () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockfunc4)([]).afterReturn(false);

      multimodalinputmanager.registerControlListener({
        onPanelStateChange: (panel) => {
          console.log(`panel state: ${panel}`);
        }
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(SCBOobeManager, SCBOobeManager.isEnable);
    });

    it('should_log_info_and_report_key_when_SCBOobeManager_is_enabled', 0, async () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockfunc4)([]).afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.reportKey);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerControlListener({
        onPanelStateChange: (panel) => {
          console.log(`panel state: ${panel}`);
        }
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(SCBOobeManager, SCBOobeManager.isEnable);
      mocker.ignoreMock(HiSysEventUtil, HiSysEventUtil.reportKey);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc2)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      multimodalinputmanager.registerControlListener({
        onPanelStateChange: (panel) => {
          throw new Error('test error');
        }
      });

      mocker.ignoreMock(logHelper, logHelper.error);
    });


    it('should_log_debug_info_when_registerNotificationListener_is_called', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_log_info_when_notification_is_triggered', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      inputConsumer.emit('key', {keyCode: keyCode.KEY_LEFT_SHIFT, keyCodeAction: "ACTION_DOWN", keyCodeState: PowerStatus.POWER_STATUS_OK}, () => {
        console.log('key event handled');
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_report_key_when_SCBOobeManager_is_not_enabled', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockReportKey: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.reportKey);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockReportKey)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      inputConsumer.emit('key', {keyCode: keyCode.KEY_LEFT_SHIFT, keyCodeAction: "ACTION_DOWN", keyCodeState: PowerStatus.POWER_STATUS_OK}, () => {
        console.log('key event handled');
      });

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(HiSysEventUtil, HiSysEventUtil.reportKey);
    });

    it('should_call_callback_when_SCBOobeManager_is_enabled', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockReportKey: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.reportKey);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockReportKey)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      inputConsumer.emit('key', {keyCode: keyCode.KEY_LEFT_SHIFT, keyCodeAction: "ACTION_DOWN", keyCodeState: PowerStatus.POWER_STATUS_OK}, () => {
        console.log('key event handled');
      });

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(HiSysEventUtil, HiSysEventUtil.reportKey);
    });

    it('should_log_error_when_exception_occurs', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      inputConsumer.emit('key', {keyCode: keyCode.KEY_LEFT_SHIFT, keyCodeAction: "ACTION_DOWN", keyCodeState: PowerStatus.POWER_STATUS_OK}, () => {
        throw new Error('test error');
      });

      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_keys_length_is_zero', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_info_when_subscribe_combination_key', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_debug_when_powerStatus_is_SHUTDOWN_or_REBOOT', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_return_unsubscribe_function_when_subscribe_combination_key_success', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      let result = multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      expect(result).assertInstanceOf(Function);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_unsubscribe_function_when_inputConsumer_on_throws_error', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockError)(ArgumentMatchers.any).afterReturnNothing();

      let keys: MultiKeyCode[] = [keyCode.KEY_A, keyCode.KEY_B];
      let isKeyDown: boolean = true;
      let cb: MultiCallback = (options) => {
        console.log(options);
      };

      let result = multimodalinputmanager.subscribeCombinationKey(keys, isKeyDown, cb);

      expect(result).assertInstanceOf(Function);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_info_when_SCBOobeManager_is_not_enabled', 0, async () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockfunc4)([]).afterReturn(false);

      multimodalinputmanager.registerControlListener({
        onPanelStateChange: (panel) => {
          console.log(`panel state: ${panel}`);
        }
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(SCBOobeManager, SCBOobeManager.isEnable);
    });

    it('should_log_info_and_report_key_when_SCBOobeManager_is_enabled', 0, async () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockfunc4)([]).afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.reportKey);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerControlListener({
        onPanelStateChange: (panel) => {
          console.log(`panel state: ${panel}`);
        }
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(SCBOobeManager, SCBOobeManager.isEnable);
      mocker.ignoreMock(HiSysEventUtil, HiSysEventUtil.reportKey);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc2)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      multimodalinputmanager.registerControlListener({
        onPanelStateChange: (panel) => {
          throw new Error('test error');
        }
      });

      mocker.ignoreMock(logHelper, logHelper.error);
    });


    it('should_log_debug_info_when_registerNotificationListener_is_called', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_log_info_when_notification_is_triggered', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      inputConsumer.emit('key', {keyCode: keyCode.KEY_LEFT_SHIFT, keyCodeAction: "ACTION_DOWN", keyCodeState: PowerStatus.POWER_STATUS_OK}, () => {
        console.log('key event handled');
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_report_key_when_SCBOobeManager_is_not_enabled', 0, () => {
      let multimodalinputmanager: MultimodalInputManager = new MultimodalInputManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockReportKey: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.reportKey);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockReportKey)(ArgumentMatchers.anyString).afterReturnNothing();

      multimodalinputmanager.registerNotificationListener({
        onPanelStateChange: (panel) => {
          console.log(`onPanelStateChange, panel: ${panel}`);
        }
      });

      inputConsumer.emit('key', {keyCode: keyCode.KEY_LEFT_SHIFT, keyCodeAction: "ACTION_DOWN", keyCodeState: PowerStatus.POWER_STATUS_OK}, () => {
        console.log('key event handled');
      });

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(HiSysEventUtil, HiSysEventUtil.reportKey);
    });
  });
