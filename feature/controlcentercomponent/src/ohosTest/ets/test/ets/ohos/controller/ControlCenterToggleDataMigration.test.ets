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

import { CommonConstants } from '@ohos/commonconstants';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import sControlCenterToggleDataRestore, {
  ControlCenterToggleDataRestore
}  from '../../../../../../main/ets/com/ohos/controller/ControlCenterToggleDataMigration';

const SETTING_DATA_DB_CLONE_FLAG_DEFAULT_VALUE = '-1';
const SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE = '0';
const SETTING_DATA_DB_CLONE_FLAG_DEFAULT_OPEN_VALUE = '1';

export function ControlCenterToggleDataMigrationTest() {
  let mocker: MockKit;

  describe('ControlCenterToggleDataMigrationTest', (): void => {
    beforeAll(() => {
      mocker = new MockKit();
    })

    afterAll((): void => {
      mocker.clearAll();
    })

    it('getInstanceTest001', 0, (): void => {
      expect(sControlCenterToggleDataRestore !== undefined).assertTrue();
      expect(sControlCenterToggleDataRestore !== null).assertTrue();
      sControlCenterToggleDataRestore.initRestore();
    })

    it('retryRestoreWhenCloneStart001', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['retryCount'] = 5;
      (sControlCenterToggleDataRestore as object)['retryRestoreWhenCloneStart']();
      expect((sControlCenterToggleDataRestore as object)['retryCount'] === 5).assertFalse();
    })

    it('retryRestoreWhenCloneStart002', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['retryCount'] = 0;
      (sControlCenterToggleDataRestore as object)['retryRestoreWhenCloneStart']();
      expect((sControlCenterToggleDataRestore as object)['retryCount'] === 5).assertFalse();
    })

    it('getCloneToggleData001', 0, (): void => {
      let mockedFun1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedFun1)(CommonConstants.KEY_TOGGLE_DATA).afterReturn('test');
      expect((sControlCenterToggleDataRestore as object)['getCloneToggleData']() === 'test').assertFalse();
      when(mockedFun1)(CommonConstants.KEY_TOGGLE_DATA).afterReturn('nfc');
      expect((sControlCenterToggleDataRestore as object)['getCloneToggleData']() === 'nfc').assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('reloadToggleDataSortSingle001', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['retryCount'] = 0;
      let mockedFun1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedFun1)(CommonConstants.KEY_TOGGLE_DATA).afterReturn('test');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSortSingle']();
      when(mockedFun1)(CommonConstants.KEY_TOGGLE_DATA).afterReturn('nfc');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSortSingle']();
      expect((sControlCenterToggleDataRestore as object)['backupToggleList'] === 'nfc').assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('reloadToggleDataSort001', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['retryCount'] = 0;
      let mockedFun1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedFun1)('sysui_qs_tiles').afterReturn('');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      when(mockedFun1)('sysui_qs_tiles').afterReturn('airplane');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      expect((sControlCenterToggleDataRestore as object)['retryCount'] === 0).assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_setBackupToggleDataSort', 0, (): void => {
      sControlCenterToggleDataRestore.setBackupToggleDataSort('');
      sControlCenterToggleDataRestore.setBackupToggleDataSort('string');
      expect((sControlCenterToggleDataRestore as object)['backupToggleList']).assertEqual('string');
    })

    it('ControlCenterToggleDataMigrationTest_initRestore_1', 0, (): void => {
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn(SETTING_DATA_DB_CLONE_FLAG_DEFAULT_VALUE);
      sControlCenterToggleDataRestore.initRestore();
      expect(sControlCenterToggleDataRestore !== null).assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_initRestore_2', 0, (): void => {
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn(SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE);
      (sControlCenterToggleDataRestore as object)['settingsCloning'] = true;
      sControlCenterToggleDataRestore.initRestore();
      expect(sControlCenterToggleDataRestore !== null).assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_reloadToggleDataSort', 0, (): void => {
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn("");
      expect((sControlCenterToggleDataRestore as object)['reloadToggleDataSort']() == null).assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_reloadToggleDataSort', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSortSingle']();
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn('');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      mocker.clear(sSettingsUtil);
      let mocked: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mocked)(ArgumentMatchers.any).afterReturn('wifi, camera');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      mocker.clear(sSettingsUtil);
    })
  })
}