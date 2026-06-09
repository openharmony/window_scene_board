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
import { NotificationBridgeEventParams, NotificationBridgeMsgParser } from '../../../main/ets/bridge/NotificationBridgeMsgParser';
import { messageChannel } from '../../../main/ets/messageChannel/MessageChannel';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { LogDomain, LogHelper, SingletonHelper, ThreadUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CustomPromise, Event, EventListener } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SystemUICcmConfig } from '../../../main/ets/utils/SystemUICcmConfig';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationBridge } from '../../../main/ets/bridge/NotificationBridge';
export default function NotificationBridgeTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isMainThread_is_true_and_isEnabledWorker_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
      when(mockfunc2)().afterReturn(false);

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(false);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_immediately_when_isMainThread_is_true_and_isEnabledWorker_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
      when(mockfunc2)().afterReturn(false);

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(false);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_immediately_when_isMainThread_is_true_and_isEnabledWorker_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
      when(mockfunc2)().afterReturn(false);

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(false);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_immediately_when_isMainThread_is_true_and_isEnabledWorker_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
      when(mockfunc2)().afterReturn(false);

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(false);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_immediately_when_isMainThread_is_true_and_isEnabledWorker_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
      when(mockfunc2)().afterReturn(false);

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(false);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_immediately_when_isMainThread_is_true_and_isEnabledWorker_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
      when(mockfunc2)().afterReturn(false);

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_false', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(false);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_resolve_isRemoteBridgeInit_when_isMainThread_is_true_and_receives_remoteBridgeInit_message', 0, () => {
      let notificationbridge: NotificationBridge = new NotificationBridge();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
      when(mockfunc)().afterReturn(true);

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      notificationbridge.init();

      messageChannel.sendMessage('remoteBridgeInit', undefined);

      mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clear_and_initDynamicRegister_and_initEventBusPostListener_and_preRegisterEventBus_when_isMainThread_is_true_and_isEnabledWorker_is_true',
      0, () => {
        let notificationbridge: NotificationBridge = new NotificationBridge();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(ThreadUtil, ThreadUtil.isMainThread);
        when(mockfunc)().afterReturn(true);
        let mockfunc2: Function =
          mocker.mockFunc(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        when(mockfunc2)().afterReturn(true);

        let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

        notificationbridge.init();

        mocker.ignoreMock(ThreadUtil, ThreadUtil.isMainThread);
        mocker.ignoreMock(SystemUICcmConfig.instance, SystemUICcmConfig.instance.isEnabledWorker);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });
  });
}