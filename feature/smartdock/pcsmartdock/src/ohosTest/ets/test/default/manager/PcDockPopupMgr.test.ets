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
import { BaseViewController } from '@ohos/frameworkcommon'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { DockItemInfo, RecentBundleMissionInfo } from '@ohos/launchercommon'
import { PcDockPopupMgr } from '../../../../../main/ets/default/manager/PcDockPopupMgr'

export default function PcDockPopupMgrTest() {
  describe('PcDockPopupMgrTest', () => {
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

    it('test_getInstance', 0, test_getInstance);
    it('test_registerViewController', 0, test_registerViewController);
    it('test_unregisterViewController', 0, test_unregisterViewController);
    it('test_registerUpdateCallback', 0, test_registerUpdateCallback);
    it('test_unRegisterUpdateCallback', 0, test_unRegisterUpdateCallback);
    it('test_unRegisterPcDockListener', 0, test_unRegisterPcDockListener);
    it('test_show1', 0, test_show1);
    it('test_show2', 0, test_show2);
    it('test_show3', 0, test_show3);
    it('test_hide', 0, test_hide);
    it('test_updateHoverState1', 0, test_updateHoverState1);
    it('test_updateHoverState2', 0, test_updateHoverState2);
    it('test_getCurShowingItem', 0, test_getCurShowingItem);
    it('test_getCurShowingItemId', 0, test_getCurShowingItemId);
    it('test_getIsShowCloseButton', 0, test_getIsShowCloseButton);
    it('test_isItemPopupShowing', 0, test_isItemPopupShowing);
    it('test_updateCurItemIcon', 0, test_updateCurItemIcon);
    it('test_getCurItemIcon', 0, test_getCurItemIcon);
    it('test_getCurItemNeedRefreshUI', 0, test_getCurItemNeedRefreshUI);
    it('test_setCurItemNeedRefreshUI', 0, test_setCurItemNeedRefreshUI);
    it('test_setCurrItem', 0, test_setCurrItem);
    it('test_getCurrItem', 0, test_getCurrItem);
    it('test_hideOnClickItem', 0, test_hideOnClickItem);
    it('test_isPopupShowing', 0, test_isPopupShowing);
    it('test_setIsShowCloseButton', 0, test_setIsShowCloseButton);
  })
}

function test_getInstance() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    expect(instance instanceof PcDockPopupMgr).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_registerViewController() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let controller: BaseViewController = new BaseViewController('viewType', 1);
    let screenId: number = 1;
    instance.registerViewController(controller, screenId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_unregisterViewController() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    instance.unregisterViewController(screenId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_registerUpdateCallback() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    let callback: Function = () => {};
    instance.registerUpdateCallback(screenId, callback);
  } catch {
    expect(false).assertTrue();
  }
}

function test_unRegisterUpdateCallback() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    instance.unRegisterUpdateCallback(screenId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_unRegisterPcDockListener() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    instance.unRegisterPcDockListener();
  } catch {
    expect(false).assertTrue();
  }
}

function test_show1() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    let item: DockItemInfo = new DockItemInfo();
    let itemId = "1";
    instance.show(screenId, item, itemId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_show2() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    let item: DockItemInfo = new DockItemInfo();
    let itemId = "1";
    item.bundleName = "test_show2";
    let missionInfo = new RecentBundleMissionInfo();
    missionInfo.bundleName = "test_show2";
    let missionInfos: RecentBundleMissionInfo[] = [];
    missionInfos.push(missionInfo);
    AppStorage.setOrCreate('missionInfoList', missionInfos);
    instance.show(screenId, item, itemId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_show3() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    let item: DockItemInfo = new DockItemInfo();
    let itemId = "1";
    item.bundleName = "test_show2";
    instance.show(screenId, item, itemId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_hide() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    instance.hide(screenId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_updateHoverState1() {
  try {
    let instance = PcDockPopupMgr.getInstance();
    let screenId: number = 1;
    let isHover = true;
    const isDockInDragging = false;
    let item: DockItemInfo = new DockItemInfo();
    let itemId = '1';
    item.bundleName = "test_updateHoverState";
    let missionInfo = new RecentBundleMissionInfo();
    missionInfo.bundleName = "test_updateHoverState";
    let missionInfos: RecentBundleMissionInfo[] = [];
    missionInfos.push(missionInfo);
    AppStorage.setOrCreate('missionInfoList', missionInfos);
    instance.updateHoverState(screenId, item, itemId, isDockInDragging, isHover);
  } catch {
    expect(false).assertTrue();
  }
}

function test_updateHoverState2() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    const screenId: number = 1;
    const itemId = '1';
    const isDockInDragging = false;
    const item: DockItemInfo = new DockItemInfo();
    const  isHover = false;
    instance.updateHoverState(screenId, item, itemId, isDockInDragging, isHover);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getCurShowingItem() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    instance.getCurShowingItem();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getCurShowingItemId() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    instance.getCurShowingItemId();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getIsShowCloseButton() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    instance.getIsShowCloseButton();
  } catch {
    expect(false).assertTrue();
  }
}

function test_setIsShowCloseButton() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    instance.setIsShowCloseButton(true);
  } catch {
    expect(false).assertTrue();
  }
}

function test_isItemPopupShowing() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    let item = new DockItemInfo();
    instance.isItemPopupShowing(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_updateCurItemIcon() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    let item = new DockItemInfo();
    item.bundleName = 'test_bundleName';
    item.abilityName = 'test_abilityName';
    item.moduleName = 'test_moduleName';
    instance.updateCurItemIcon(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getCurItemIcon() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    let res: PixelMap | null = instance.getCurItemIcon();
    expect(res).assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getCurItemNeedRefreshUI() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    const screenId = 1;
    instance.getCurItemNeedRefreshUI(screenId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_setCurItemNeedRefreshUI() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    const screenId = 1;
    const value = false;
    instance.setCurItemNeedRefreshUI(screenId, value);
  } catch {
    expect(false).assertTrue();
  }
}

function test_setCurrItem() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    let item = new DockItemInfo();
    instance.setCurrItem(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getCurrItem() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    expect(instance.getCurrItem()).not().assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_hideOnClickItem() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    const screenId = 1;
    let item = new DockItemInfo();
    instance.hideOnClickItem(screenId, item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_isPopupShowing() {
  try {
    const instance = PcDockPopupMgr.getInstance();
    const screenId = 1;
    let item = new DockItemInfo();
    instance.isPopupShowing(screenId, item);
  } catch {
    expect(false).assertTrue();
  }
}