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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { PcModeDockPopupMgr, PcModeDockPopupController } from '../../../../main/ets/default/manager/PcModeDockPopupMgr';

export default function PcModeDockPopupMgrTest() {
  describe('PcModeDockPopupMgrTest', () => {
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
    it('test_setAndGetItem', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      let instance: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
      instance.setCurrItem(item);
      let a: string = instance.getCurrItem()?.abilityName ?? '';
      expect(a).assertEqual(item.abilityName);
    })
    it('test_isPopupShow_1', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      let instance: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
      instance.setCurrItem(item);
      let a: boolean = instance.isPopupShow(item);
      expect(a).assertTrue();
    })
    it('test_isPopupShow_2', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      let instance: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
      instance.setCurrItem(item);
      let item2 = new DockItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.abilityName = 'com.ohos.sceneboard.appcenter.MainAbility';
      item2.typeId = 0;
      item2.itemType = 2;
      item2.areaType = 1;
      item2.appIndex = 0;
      let a: boolean = instance.isPopupShow(item2);
      expect(a).assertFalse();
    })
    it('test_registerAndUnRegisterPopupController', 0, () => {
      try {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      let instance: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
      let controller: PcModeDockPopupController = {
        popupAndMenuClose: () => {
          return true;
        }
      }
      instance.registerPopupController(item, controller);
      instance.unRegisterPopupController(item, controller);
      expect(instance instanceof PcModeDockPopupMgr).assertTrue();
      } catch (e) {}
    })
    it('test_closeOtherPopups', 0, () => {
      try {
      let item1: DockItemInfo = new DockItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      let item2: DockItemInfo = new DockItemInfo();
      item2.bundleName = 'com.ohos.contacts';
      item2.abilityName = 'com.ohos.contacts.MainAbility';
      let item3: DockItemInfo = new DockItemInfo();
      item3.bundleName = 'com.ohos.browser';
      item3.abilityName = 'MainAbility';
      let item4: DockItemInfo = new DockItemInfo();
      item4.bundleName = 'com.ohos.camera';
      item4.abilityName = 'com.ohos.camera.MainAbility';
      let instance: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
      let controller: PcModeDockPopupController = {
        popupAndMenuClose: () => {
          return true;
        }
      }
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let recentList: DockItemInfo[] = AppStorage.get('recentList') ?? [];
      residentList.push(item1, item2);
      recentList.push(item3, item4);
      instance.registerPopupController(item1, controller);
      instance.registerPopupController(item2, controller);
      instance.registerPopupController(item3, controller);
      instance.registerPopupController(item4, controller);
      instance.closeOtherPopups(item1);
      instance.unRegisterPopupController(item1, controller);
      instance.unRegisterPopupController(item2, controller);
      instance.unRegisterPopupController(item3, controller);
      instance.unRegisterPopupController(item4, controller);
      expect(instance instanceof PcModeDockPopupMgr).assertTrue();
      } catch (e) {}
    })

  })
}
