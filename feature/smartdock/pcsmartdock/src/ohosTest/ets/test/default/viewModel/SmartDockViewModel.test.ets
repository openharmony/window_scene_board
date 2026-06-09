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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { DockItemInfo, MenuInfo, RecentBundleMissionInfo } from '@ohos/launchercommon'
import PcSmartDockViewModel from '../../../../../main/ets/default/viewmodel/SmartDockViewModel'
import call from '@ohos.telephony.call'
import { ArrowType } from '@ohos/smartdock/src/main/ets/default/common/constants/PcModeDockConstants'

export default function SmartDockViewModelTest() {
  describe('SmartDockViewModelTest', () => {
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
    it('test_getInstance1', 0, test_getInstance1);
    it('test_getInstance2', 0, test_getInstance2);
    it('test_initMgr', 0, test_initMgr);
    it('test_unregisterDataChangeCallback', 0, test_unregisterDataChangeCallback);
    it('test_residentOnClick', 0, test_residentOnClick);
    it('test_residentOnClickWithDisplay', 0, test_residentOnClickWithDisplay);
    it('test_getWpsUnreadMessageMenu', 0, test_getWpsUnreadMessageMenu);
    it('test_getWpsUnreadMessageMenu', 0, test_getWpsUnreadMessageMenu);
    it('test_getWpsCloseMenu', 0, test_getWpsCloseMenu);
    it('test_buildMenuInfoList', 0, test_buildMenuInfoList);
    it('test_onDockListChange', 0, test_onDockListChange);
    it('test_getOpenNewWindowMenu', 0, test_getOpenNewWindowMenu);
    it('test_getOpenMenu', 0, test_getOpenMenu);
    it('test_getExitMenu', 0, test_getExitMenu);
    it('test_getFormMenu', 0, test_getFormMenu);
    it('test_onHoverEvent1', 0, test_onHoverEvent1);
    it('test_onHoverEvent2', 0, test_onHoverEvent2);
    it('test_getRefreshSnapshot1', 0, test_getRefreshSnapshot1);
    it('test_getRefreshSnapshot2', 0, test_getRefreshSnapshot2);
    it('test_recentOnClickWithPopup', 0, test_recentOnClickWithPopup);
    it('test_onItemClick', 0, test_onItemClick);
    it('test_onItemClickWithDisplay', 0, test_onItemClickWithDisplay);
    it('test_getIdPrefix', 0, test_getIdPrefix);
    it('test_getArrowId', 0, test_getArrowId);
    it('test_recentOnClick', 0, test_recentOnClick);
    it('test_getDockArrowId', 0, test_getDockArrowId);
  })
}

function test_getInstance1() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    expect(instance instanceof PcSmartDockViewModel).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getInstance2() {
  try {
    PcSmartDockViewModel.getInstance();
    const instance = PcSmartDockViewModel.getInstance();
    expect(instance instanceof PcSmartDockViewModel).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_initMgr() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    instance.initMgr();
  } catch {
    expect(false).assertTrue();
  }
}

function test_unregisterDataChangeCallback() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    instance.unregisterDataChangeCallback();
  } catch {
    expect(false).assertTrue();
  }
}

function test_residentOnClick() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const event: ClickEvent = {} as ClickEvent;
    const item: DockItemInfo = new DockItemInfo();
    const callBack = () => {};
    instance.residentOnClick(event, item, callBack);
  } catch {
    expect(false).assertTrue();
  }
}

function test_residentOnClickWithDisplay() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const event: ClickEvent = {} as ClickEvent;
    const item: DockItemInfo = new DockItemInfo();
    const callBack = () => {};
    const screenId: number = 1;
    instance.residentOnClickWithDisplay(screenId, event, item, callBack);
  } catch {
    expect(false).assertTrue();
  }
}

function test_recentOnClick() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const event: ClickEvent = {} as ClickEvent;
    const item: DockItemInfo = new DockItemInfo();
    const callBack = () => {};
    instance.recentOnClick(event, item, callBack);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getWpsUnreadMessageMenu() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const res = instance.getWpsUnreadMessageMenu(item);
    expect(res instanceof MenuInfo).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getWpsCloseMenu() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const callBack = () => {};
    const res = instance.getWpsCloseMenu(item, callBack);
    expect(res instanceof MenuInfo).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_buildMenuInfoList() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const dockType = 1;
    const screenId: number = 1;
    const callBack = () => {};
    const res: MenuInfo[] = instance.buildMenuInfoList(item, dockType, callBack, screenId);
    expect(res).not().assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_onDockListChange() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    instance.onDockListChange();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getOpenNewWindowMenu() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const screenId: number = 1;
    const res: MenuInfo = instance.getOpenNewWindowMenu(item,screenId);
    expect(res).not().assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getOpenMenu() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const screenId: number = 1;
    const res: MenuInfo = instance.getOpenMenu(item,screenId);
    expect(res).not().assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getExitMenu() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const screenId: number = 1;
    const res: MenuInfo = instance.getExitMenu(item,screenId);
    expect(res).not().assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getFormMenu() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = new DockItemInfo();
    const res: MenuInfo = instance.getFormMenu(item);
    expect(res).not().assertNull();
  } catch {
    expect(false).assertTrue();
  }
}

function test_onHoverEvent1() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: 'com.ohos.sceneboard'
    }
    instance.onHoverEvent(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_onHoverEvent2() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: ''
    }
    instance.onHoverEvent(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getRefreshSnapshot1() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: ''
    }
    instance.getRefreshSnapshot(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getRefreshSnapshot2() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: 'bundleName'
    }
    let missionInfoList: RecentBundleMissionInfo = {
      missionInfoList: [],
      appName: '',
      appIconId: 0,
      bundleName: 'bundleName',
      abilityName: ''
    }
    AppStorage.setOrCreate('missionInfoList', [missionInfoList]);
    instance.getRefreshSnapshot(item, true);
  } catch {
    expect(false).assertTrue();
  }
}

function test_recentOnClickWithPopup() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: ''
    }
    instance.recentOnClickWithPopup(item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_onItemClick() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: ''
    }
    const event: ClickEvent = {} as ClickEvent;
    instance.onItemClick(event, item);
  } catch {
    expect(false).assertTrue();
  }
}

function test_onItemClickWithDisplay() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const item: DockItemInfo = {
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: ''
    }
    const screenId = 1;
    const event: ClickEvent = {} as ClickEvent;
    instance.onItemClickWithDisplay(event, item, screenId);
  } catch {
    expect(false).assertTrue();
  }
}

function test_getIdPrefix() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const res = instance.getIdPrefix(true);
    expect(res).assertEqual('ResidentLayoutForPC');
  } catch {
    expect(false).assertTrue();
  }
}

function test_getArrowId() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const res = instance.getArrowId(ArrowType.RECENT_LEFT);
    expect(res).assertEqual('leftArrowPath');
  } catch {
    expect(false).assertTrue();
  }
}

function test_getDockArrowId() {
  try {
    const instance = PcSmartDockViewModel.getInstance();
    const res = instance.getDockArrowId(true, ArrowType.RECENT_LEFT);
    expect(res).assertEqual('ResidentLayoutForPC_Image_leftArrowPath');
  } catch {
    expect(false).assertTrue();
  }
}
