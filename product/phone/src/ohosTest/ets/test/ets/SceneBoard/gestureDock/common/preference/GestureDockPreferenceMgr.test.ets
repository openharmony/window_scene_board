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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, Level,
  ArgumentMatchers,
  when} from '@ohos/hypium';
import {
  GestureDockPreferenceMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/preference/GestureDockPreferenceMgr'
import { GestureDockItemInfo } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import { AppItemInfo, AppModel,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  GestureDockModeConfig,
  launcherAbilityManager,
  RdbStoreManager,
  ReceiveEventInfo} from '@ohos/launchercommon/src/main/ets/TsIndex';
import GestureDockViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import {
  GestureDockViewParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam';

export default function GestureDockPreferenceMgrTest() {

  let gestureDockPreferenceMgr: GestureDockPreferenceMgr = GestureDockPreferenceMgr.getInstance();
  let dockPreference: GestureDockPreferenceMgr = GestureDockPreferenceMgr.getInstance();
  let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
  let gestureDockParam: GestureDockViewParam = viewEvent?.gestureDockParam;

  describe('GestureDockPreferenceMgrTest', () => {
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

    it('GestureDockPreferenceMgr_syncPreferencesCache', 0, async (done: Function) => {
      await gestureDockPreferenceMgr.syncPreferencesCache();
      expect(gestureDockPreferenceMgr).not().assertUndefined();
      done();
    })

    it('GestureDockPreferenceMgr_registerAppUpdateListener', 0, async (done: Function) => {
      await gestureDockPreferenceMgr.registerAppUpdateListener();
      expect(gestureDockPreferenceMgr).not().assertUndefined();
      done();
    })

    it('GestureDockPreferenceMgr_registerAppUpdateListener', 0, () => {
      gestureDockPreferenceMgr.unRegisterAppUpdateListener();
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_getRecentDockList_01', 0, async (done: Function) => {
      await gestureDockPreferenceMgr.getRecentDockList();
      expect(gestureDockPreferenceMgr).not().assertUndefined();
      done();
    })

    it('GestureDockPreferenceMgr_getDockApps_01', 0, async (done: Function) => {
      await gestureDockPreferenceMgr.getDockApps();
      expect(gestureDockPreferenceMgr).not().assertUndefined();
      done();
    })

    it('GestureDockPreferenceMgr_updateRecentPreferenceGestureDock_01', 0, () => {
      let dockItemInfoList: GestureDockItemInfo[] = [];
      gestureDockPreferenceMgr.updateRecentPreferenceGestureDock(dockItemInfoList);
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_updateRecentPreferenceGestureDock_02', 0, () => {
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'abc';
      let dockItemInfoList: GestureDockItemInfo[] = [gestureDockItemInfo];
      gestureDockPreferenceMgr.updateRecentPreferenceGestureDock(dockItemInfoList);
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_updateDockAppsPreference_01', 0, () => {
      let dockAppList: GestureDockItemInfo[] = [];
      gestureDockPreferenceMgr.updateDockAppsPreference(dockAppList);
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_updateDockAppsPreference_02', 0, () => {
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'abc';
      gestureDockItemInfo.abilityName = 'a'
      gestureDockItemInfo.moduleName = 'c'
      gestureDockItemInfo.appIndex = 1;
      gestureDockItemInfo.typeId = 12;
      let dockAppList: GestureDockItemInfo[] = [gestureDockItemInfo];
      gestureDockPreferenceMgr.updateDockAppsPreference(dockAppList);
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_buildGestureDockItemInfo_01', 0, () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.typeId = 3;
      (gestureDockPreferenceMgr as object)['buildGestureDockItemInfo'](appInfo);
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_buildGestureDockItemInfo_02', 0, () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.typeId = 2;
      (gestureDockPreferenceMgr as object)['buildGestureDockItemInfo'](appInfo);
      expect(gestureDockPreferenceMgr).not().assertUndefined();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_1', Level.LEVEL0, (): void => {
      expect(dockPreference.addGestureDockRecentPreference('test') === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_2', Level.LEVEL0, (): void => {
      expect(dockPreference.addGestureDockRecentPreference('') === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_4', Level.LEVEL0, (): void => {
      expect(dockPreference.addGestureDockRecentPreference('test', -1) === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_5', Level.LEVEL0, (): void => {
      expect(dockPreference.addGestureDockRecentPreference('', -1) === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_6', Level.LEVEL0, (): void => {
      gestureDockParam.recentApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      gestureDockParam.recentApps[0].bundleName = 'test';
      expect(dockPreference.addGestureDockRecentPreference('test', 0) === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_7', Level.LEVEL0, (): void => {
      gestureDockParam.recentApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      gestureDockParam.recentApps[1].bundleName = 'test';
      expect(dockPreference.addGestureDockRecentPreference('test', 1) === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_8', Level.LEVEL0, (): void => {
      let dockItemInfoList: GestureDockItemInfo[] = [];
      for (let i = 0; i <= 20; i++) {
        dockItemInfoList.push(new GestureDockItemInfo());
      }
      gestureDockParam.recentApps = dockItemInfoList;
      expect(dockPreference.addGestureDockRecentPreference('test', 1) === undefined).assertTrue();
    })

    it('GestureDockPreferenceMgr_addGestureDockRecentPreference_9', Level.LEVEL0, (): void => {
      gestureDockParam.recentApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      gestureDockParam.recentApps[1].bundleName = '';
      expect(dockPreference.addGestureDockRecentPreference('test', 1) === undefined).assertTrue();
    })
  })
}