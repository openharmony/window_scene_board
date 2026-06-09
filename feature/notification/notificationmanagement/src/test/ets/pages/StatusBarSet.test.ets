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
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { DeviceHelper, sSettingsUtil } from '@ohos/managementcomponent';
import { HiDfxEventUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/HiDfxEventUtil';
import ConfigData from '../../../main/ets/common/constants';
import StatueBarSwitchComponent from '../../../main/ets/pages/StatueBarSwitchComponent';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { NotificationSysEventUtil } from '../../../main/ets/common/NotificationSysEventUtil';
import display from '@ohos.display';
import HeadComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import Sim from '@ohos.telephony.sim';
import { fontScaleManager, FontScaleState } from '@ohos/managementcomponent';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { StatusBarModel } from '../../../main/ets/model/StatusBarModel';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';
import { ResourceUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ResourceUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../main/ets/pages/StatusBarSetting';
export default function Test() {
  describe('pureShowInit_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isPureShow_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isPureShow_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isPureShow_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isPureShow_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isPureShow_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.pureShowInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });
  });

  describe('showNotificationIconInit_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_true_when_isShowNotificationIcon_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isShowNotificationIcon_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isShowNotificationIcon_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isShowNotificationIcon_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isShowNotificationIcon_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('true');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn('false');

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isShowNotificationIcon_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(null);

      const result = await StatueBarSwitchComponent.showNotificationIconInit();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });
  });
}
