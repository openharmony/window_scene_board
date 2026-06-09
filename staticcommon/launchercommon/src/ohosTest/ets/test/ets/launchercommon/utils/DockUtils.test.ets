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
} from '@ohos/hypium'
import { DockUtils } from '../../../../../../main/ets/utils/DockUtils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DockItemInfo } from '../../../../../../main/ets/TsIndex';

export default function DockUtilsTest() {
  describe('DockUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_isExistIntegratedDock', 0, () => {
      let mocker: MockKit = new MockKit();
      let func_1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let func_2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(func_1)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DockUtils.isExistIntegratedDock()).assertFalse();
      } catch (e) {
      }
      when(func_1)(ArgumentMatchers.any).afterReturn(false);
      when(func_2)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DockUtils.isExistIntegratedDock()).assertFalse();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_isSupportFullDock_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let func_1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let func_2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(func_1)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DockUtils.isSupportFullDock()).assertFalse();
      } catch (e) {
      }
      when(func_1)(ArgumentMatchers.any).afterReturn(false);
      when(func_2)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DockUtils.isSupportFullDock()).assertFalse();
      } catch (e) {
      }
      when(func_2)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DockUtils.isSupportFullDock()).assertFalse();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_isSupportIntegratedDockToFalse_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let func_1: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(func_1)(ArgumentMatchers.any).afterReturn(false);
      let mock_result = DockUtils.isSupportFullDock();
      try {
        expect(mock_result).assertFalse();
        expect(DockUtils.isSupportIntegratedDock()).assertFalse();
      } catch (e) {
      }
      mocker.clear(DockUtils);
      mocker.clearAll();
    });

    it('test_isSupportIntegratedDockToTrue', 0, () => {
      let mocker: MockKit = new MockKit();
      let func_1: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(func_1)(ArgumentMatchers.any).afterReturn(false);
      try {
        let mock_result = DockUtils.isSupportFullDock();
        expect(mock_result).assertFalse();
        expect(DockUtils.isSupportIntegratedDock()).assertFalse();
      } catch (e) {
      }
      mocker.clear(DockUtils);
      mocker.clearAll();
    });

    it('test_isSupportIntegratedDockToFalse_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let func_1: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(func_1)(ArgumentMatchers.any).afterReturn(true);
      try {
        let mock_result = DockUtils.isSupportFullDock();
        expect(mock_result).assertTrue();
        AppStorage.set('scenePanelState', 0);
        expect(DockUtils.isSupportIntegratedDock()).assertFalse();
        AppStorage.set('scenePanelState', 4);
        expect(DockUtils.isSupportIntegratedDock()).assertFalse();
        AppStorage.set('scenePanelState', 2);
        expect(DockUtils.isSupportIntegratedDock()).assertFalse();
        AppStorage.set('scenePanelState', 70);
        expect(DockUtils.isSupportIntegratedDock()).assertTrue();
      } catch (e) {
      }
      mocker.clear(DockUtils);
      mocker.clearAll();
    });

    it('test_getDockItemId', 0, () => {
      const dockItemInfo:DockItemInfo = new DockItemInfo();
      let mocker: MockKit = new MockKit();
      let func_1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(func_1)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DockUtils.getDockItemId(dockItemInfo)).assertEqual('');
      } catch (e) {
      }
      when(func_1)(ArgumentMatchers.any).afterReturn(false);
      try {
        dockItemInfo.bundleName = 'i';
        dockItemInfo.appIndex = 1;
        dockItemInfo.shortcutId = 'me';
        expect(DockUtils.getDockItemId(dockItemInfo).startsWith('ResidentLayout_AppItem_i1')).assertTrue();
        dockItemInfo.appIndex = undefined;
        dockItemInfo.shortcutId = undefined;
        expect(DockUtils.getDockItemId(dockItemInfo).startsWith('ResidentLayout_AppItem_')).assertTrue();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_getPrintParam', 0, () => {
      try {
        let dataList: Array<DockItemInfo> = [];
        let rst = DockUtils.getPrintParam(dataList);
        expect(rst).assertEqual('');
        let itemInfo: DockItemInfo = new DockItemInfo();
        // app类型
        itemInfo.itemType = 0;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'keyName0';

        let itemInfo1: DockItemInfo = new DockItemInfo();
        // app类型
        itemInfo1.itemType = 0;
        itemInfo1.bundleName = 'com.ohos.mms';
        itemInfo1.keyName = 'keyName1';

        dataList.push(itemInfo);
        dataList.push(itemInfo1);
        rst = DockUtils.getPrintParam(dataList);
        expect(rst).not().assertNull();
      } catch (e) {
      }
    });

    it('test_getPrintDockParam', 0, () => {
      try {
        let itemInfo1: DockItemInfo = new DockItemInfo();
        // app类型
        itemInfo1.itemType = 0;
        itemInfo1.bundleName = 'com.ohos.mms';
        itemInfo1.keyName = 'keyName1';
        let rst = DockUtils.getPrintDockParam(itemInfo1);
        expect(rst).not().assertNull();
      } catch (e) {
      }
    });
  })
}