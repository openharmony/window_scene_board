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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';

export default function NtfCloseVMTest() {
  describe('updatePosition_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined01', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined01', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined02', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined02', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined03', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined03', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined04', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined04', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined05', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined05', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined06', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined06', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined07', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined07', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined08', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined08', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined09', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined09', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined10', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined10', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined11', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined11', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let area: Area = {
        width: 0,
        height: 0,
        position: {},
        globalPosition: {}
      };
      let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
      ntfclosevm.updatePosition(ntfEntry, area);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.warn);
    });
  });
}