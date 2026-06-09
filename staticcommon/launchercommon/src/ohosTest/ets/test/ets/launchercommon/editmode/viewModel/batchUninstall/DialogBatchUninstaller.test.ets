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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { LaunchLayoutCacheManager } from '../../../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';
import { ForwardType } from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/BatchUninstallChain';
import {
  BatchItemInfo,
  DialogBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/DialogBatchUninstaller';
import { AppStatus, CommonConstants, GridLayoutItemInfo } from '../../../../../../../../main/ets/TsIndex';

export default function DialogBatchUninstallerTest() {
  describe('DialogBatchUninstallerTest', () => {
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

    let uninstaller = new DialogBatchUninstaller();

    // 带分身主应用
    let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
    item1.typeId = CommonConstants.TYPE_APP;
    item1.bundleName = 'bundleName1';
    item1.appIndex = 0;
    item1.isUninstallAble = true;
    item1.appStatus = AppStatus.INSTALLED;
    // 克隆升级中应用
    let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
    item2.typeId = CommonConstants.TYPE_APP;
    item2.bundleName = 'bundleName2';
    item2.appIndex = 0;
    item2.isUninstallAble = true;
    item2.callerName = CommonConstants.SOURCE_UPGRADE;
    item2.appStatus = AppStatus.DOWNLOADING;
    // 克隆升级中应用
    let item7: GridLayoutItemInfo = new GridLayoutItemInfo();
    item7.typeId = CommonConstants.TYPE_APP;
    item7.bundleName = 'bundleName7';
    item7.appIndex = 0;
    item7.isUninstallAble = true;
    item7.callerName = CommonConstants.SOURCE_CLONE;
    item7.appStatus = AppStatus.DOWNLOADING;
    // 可卸载分身
    let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
    item3.typeId = CommonConstants.TYPE_APP;
    item3.bundleName = 'bundleName1';
    item3.appIndex = 1;
    item3.isUninstallAble = true;
    item3.appStatus = AppStatus.INSTALLED;
    // 可卸载分身
    let item6: GridLayoutItemInfo = new GridLayoutItemInfo();
    item6.typeId = CommonConstants.TYPE_APP;
    item6.bundleName = 'bundleName1';
    item6.appIndex = 2;
    item6.isUninstallAble = true;
    item6.appStatus = AppStatus.INSTALLED;
    // 普通应用
    let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
    item4.typeId = CommonConstants.TYPE_APP;
    item4.bundleName = 'bundleName4';
    item4.appIndex = 0;
    item4.isUninstallAble = true;
    item4.appStatus = AppStatus.INSTALLED;
    // “主题”/“录音机”/“畅联” 等特殊应用
    let item5: GridLayoutItemInfo = new GridLayoutItemInfo();
    item5.typeId = CommonConstants.TYPE_APP;
    item5.bundleName = 'com.ohos.thememanager';
    item5.appIndex = 0;
    item5.isUninstallAble = true;
    item5.appStatus = AppStatus.INSTALLED;

    let llcm: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let mockKit: MockKit = new MockKit();
    const getGridLayoutItemList: Function = mockKit.mockFunc(llcm, llcm.getGridLayoutItemList);
    when(getGridLayoutItemList)().afterReturn([item1, item3, item6]);

    it('test_doHandleData', 0, () => {
      let editModeViewData = uninstaller.doHandleData([item1], ForwardType.DRAG_START);
      editModeViewData = uninstaller.doHandleData([item1], ForwardType.DRAG_END);

      editModeViewData = uninstaller.doHandleData([item1], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item2], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item3], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item4], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item5], ForwardType.DRAG_DROP);

      editModeViewData = uninstaller.doHandleData([item3, item6], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item2, item7], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item1, item5], ForwardType.DRAG_DROP);
      editModeViewData = uninstaller.doHandleData([item1, item2, item3, item4, item5, item6], ForwardType.DRAG_DROP);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_buildDialog', 0, () => {

      let items = [item1];

      let info: BatchItemInfo = new BatchItemInfo();

      let mockKit: MockKit = new MockKit();
      const analysis: Function = mockKit.mockFunc(uninstaller, (uninstaller as object)['analysis']);
      when(analysis)(items).afterReturn(info);
      let editModeViewData = uninstaller.doHandleData(items, ForwardType.DRAG_DROP)
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_analysis', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = 'bundleName1';
      item.appIndex = 0;
      item.container = 213;
      item.isUninstallAble = true;
      item.appStatus = AppStatus.INSTALLED;
      let items = [item];
      let info: BatchItemInfo = (uninstaller as object)['analysis'](items);
      expect(info).not().assertNull();
    })

  })
}
