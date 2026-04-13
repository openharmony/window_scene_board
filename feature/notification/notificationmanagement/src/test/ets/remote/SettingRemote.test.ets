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
import ctx from '@ohos.app.ability.common';
import {
  LogDomain,
  LogHelper,
  NotificationIpc
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common, Want } from '@kit.AbilityKit';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { SettingRemote } from '../../../main/ets/remote/SettingRemote';
export default function SettingRemoteTest() {
  describe('send_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_error_when_connect_service_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          throw new BusinessError('connect service error');
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_warn_when_send_message_request_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: -1, errCode: 'error code'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_info_when_send_message_request_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_promise', 0, async () => {
      SettingRemote.remotePromise = null;

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_object', 0, async () => {
      SettingRemote.remotePromise = Promise.resolve(null);

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_error_when_connect_service_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          throw new BusinessError('connect service error');
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_warn_when_send_message_request_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: -1, errCode: 'error code'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_info_when_send_message_request_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_promise', 0, async () => {
      SettingRemote.remotePromise = null;

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_object', 0, async () => {
      SettingRemote.remotePromise = Promise.resolve(null);

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_error_when_connect_service_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          throw new BusinessError('connect service error');
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_warn_when_send_message_request_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: -1, errCode: 'error code'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_info_when_send_message_request_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_promise', 0, async () => {
      SettingRemote.remotePromise = null;

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_object', 0, async () => {
      SettingRemote.remotePromise = Promise.resolve(null);

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_error_when_connect_service_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          throw new BusinessError('connect service error');
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_warn_when_send_message_request_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: -1, errCode: 'error code'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_log_info_when_send_message_request_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_promise', 0, async () => {
      SettingRemote.remotePromise = null;

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_object', 0, async () => {
      SettingRemote.remotePromise = Promise.resolve(null);

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_handle_null_remote_promise', 0, async () => {
      SettingRemote.remotePromise = null;

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let rpcMock: rpc.IRemoteObject = {
        sendMessageRequest: async () => {
          return {
            code: 0, errCode: 'success'
          };
        }
      };

      let mockConnectService: Function = mocker.mockFunc(SettingRemote, SettingRemote.connect);
      when(mockConnectService)().afterReturn(rpcMock);

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
      mocker.ignoreMock(SettingRemote, SettingRemote.connect);
    });

    it('should_handle_null_remote_object', 0, async () => {
      SettingRemote.remotePromise = Promise.resolve(null);

      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockLogShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      await SettingRemote.send(1, 'test');

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });
  });
}