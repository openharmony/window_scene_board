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
import { SingletonHelper, LogDomain, LogHelper, TraceUtil, DomainName } from '@ohos/basicutils';
import { EvtBus, EventManager } from '@ohos/frameworkwrapper';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { DataShareUtils, SettingsConstant } from '../../../main/ets/datasharemanager/DataShareUtils';
import {
  TimeFormatEvent,
  NtfHideContentEvent,
  NtfAutoScreenOnEvent,
  PureShowEvent,
  NotificationIconEvent,
  RealTimeNetworkSpeedEvent,
  BatterySocEvent,
  CellularDataEnableEvent,
  FocusModeSwitchDataEvent,
  SuperHubSwitchDataEvent,
  FaceSwitchEnableEvent,
  FingerprintUnlockSwitchEnableEvent,
  HiddenBannerNtfEnableEvent,
  UnifiedGroupEnableEvent,
  SatelliteModeSwitchEvent,
  SpaceSlidingSwitchEvent,
  GrabScreenCaptureSwitchEvent,
  MultiDeviceCollaborationServiceEnableEvent,
  DistributedModemSwitchEvent,
  SpaceShareSwitchEvent,
  LiveViewHideContentEvent,
  BasicStatementAgreedEvent,
  ForbiddenGestureSwitchEvent,
  BasicStatementAgreedSecureEvent,
  SlNtfStyleChangeEvent,
  VibrateSwitchEvent,
} from '../../../main/ets/datasharemanager/SysUIDataShareEvent';
import DataShare from '@ohos.data.dataShare';
import Context from '@ohos.app.ability.common';
import { DataShareEvent } from '../../../main/ets/datasharemanager/DataShareEvent';
import { LogWithHa } from '../../../main/ets/maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../../../main/ets/maintenance/CommonExceptionCode';
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
import { DataShareManager } from '../../../main/ets/datasharemanager/DataShareManager';

export default function DataShareManagerTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_initialize_DataShareManager_correctly', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_initialize_DataShareManager_correctly_1', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_initialize_DataShareManager_correctly_2', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_initialize_DataShareManager_correctly_3', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_initialize_DataShareManager_correctly_4', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_initialize_DataShareManager_correctly_5', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_initialize_DataShareManager_correctly_6', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_0', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_1', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_2', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_3', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_4', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_5', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_6', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_7', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_8', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_9', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_10', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_11', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_12', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_13', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_14', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_15', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_16', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_17', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_18', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_19', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_20', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_21', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });

    it('should_log_error_when_initEventMap_fails_22', 0, async () => {
      let datasharemanager: DataShareManager = new DataShareManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(datasharemanager, datasharemanager.initEventMap);
      let errorMsg = "Error initializing event map";
      when(mockfunc)(ArgumentMatchers.any).afterThrow(errorMsg);

      let context: Context.ExtensionContext = new Context.ExtensionContext();
      await datasharemanager.init(context);

      expect(datasharemanager.context).assertEqual(context);
      mocker.ignoreMock(datasharemanager, datasharemanager.initEventMap);
    });
  });
}