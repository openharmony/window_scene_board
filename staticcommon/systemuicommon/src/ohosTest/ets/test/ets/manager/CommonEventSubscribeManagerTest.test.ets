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
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ThemeActiveEvent } from '../../../main/ets/event/ThemeActiveEvent';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { CommonEventSubscribeManager } from '../../../main/ets/manager/CommonEventSubscribeManager';
export default function CommonEventSubscribeManagerTest() {
  describe('getInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_same_instance', 0, () => {
      let instance1: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      let instance2: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('should_throw_error_when_theme_active_event_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = null;
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });

    it('should_throw_error_when_theme_active_event_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = new ThemeActiveEvent();
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });
    it('should_call_subscribe_on_subscriber', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      await commoneventsubscribemanager.subscribe(event, listener);

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_handle_error_when_getOrCreateSubscriber_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_subscriber_subscribe_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_event_is_ThemeActiveEvent', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new ThemeActiveEvent();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Event is ThemeActiveEvent");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_return_same_instance', 0, () => {
      let instance1: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      let instance2: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('should_throw_error_when_theme_active_event_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = null;
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });

    it('should_throw_error_when_theme_active_event_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = new ThemeActiveEvent();
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });
    it('should_call_subscribe_on_subscriber', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      await commoneventsubscribemanager.subscribe(event, listener);

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_handle_error_when_getOrCreateSubscriber_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_subscriber_subscribe_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_event_is_ThemeActiveEvent', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new ThemeActiveEvent();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Event is ThemeActiveEvent");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_return_same_instance', 0, () => {
      let instance1: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      let instance2: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('should_throw_error_when_theme_active_event_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = null;
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });

    it('should_throw_error_when_theme_active_event_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = new ThemeActiveEvent();
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });
    it('should_call_subscribe_on_subscriber', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      await commoneventsubscribemanager.subscribe(event, listener);

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_handle_error_when_getOrCreateSubscriber_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_subscriber_subscribe_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_event_is_ThemeActiveEvent', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new ThemeActiveEvent();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Event is ThemeActiveEvent");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_return_same_instance', 0, () => {
      let instance1: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      let instance2: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('should_throw_error_when_theme_active_event_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = null;
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });

    it('should_throw_error_when_theme_active_event_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = new ThemeActiveEvent();
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });
    it('should_call_subscribe_on_subscriber', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      await commoneventsubscribemanager.subscribe(event, listener);

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_handle_error_when_getOrCreateSubscriber_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_subscriber_subscribe_throws_error', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new commonEventManager.CommonEventSubscribeInfo();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_log_error_when_event_is_ThemeActiveEvent', 0, async () => {
      let commoneventsubscribemanager: CommonEventSubscribeManager = CommonEventSubscribeManager.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
      let mockSubscriber: any = {
        subscribe: mocker.mockFunc(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber)
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockSubscriber);

      let event: commonEventManager.CommonEventSubscribeInfo = new ThemeActiveEvent();
      let listener: CommonEventListener = new CommonEventListener();
      try {
        await commoneventsubscribemanager.subscribe(event, listener);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Event is ThemeActiveEvent");
      }

      mocker.ignoreMock(commoneventsubscribemanager, commoneventsubscribemanager.getOrCreateSubscriber);
    });

    it('should_return_same_instance', 0, () => {
      let instance1: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      let instance2: CommonEventSubscribeManager = CommonEventSubscribeManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('should_throw_error_when_theme_active_event_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = LogDomain.ENTER;
      let themeActiveEvent: ThemeActiveEvent = null;
      let result: BusinessError = new BusinessError();
      when(mocker.mockFunc(logHelper, logHelper.sendLog))(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(result);
      try {
        InnerEventUtil.sendThemeActiveEvent(themeActiveEvent);
        assertFail("Expected an error to be thrown");
      } catch (error) {
        expect(error).assertEqual(result);
      }
      mocker.ignoreMock(logHelper, logHelper.sendLog);
    });

  });
