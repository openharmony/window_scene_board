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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty,
} from '@ohos/windowscene';
import { AccessibilityManager, ResourceManager } from '@ohos/frameworkwrapper';
import {
  RecentAccessibilityUtils
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentAccessibilityUtils';
import { RecentTitleViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/viewmodel/RecentTitleViewModel';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'RecentAccessibilityUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export default function RecentAccessibilityUtilsTest() {
  describe('RecentAccessibilityUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testMoudle', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let scContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);

    it('RecentAccessibilityUtils_test_textAnnouncedForFocusRecent_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      let resourceManager = ResourceManager.getInstance();
      try {
        let recentText: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
        when(recentText)(ArgumentMatchers.any).afterReturn('test1');
        RecentAccessibilityUtils.textAnnouncedForFocusRecent();
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(resourceManager, resourceManager.getStringByIdSync);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForFocusRecent_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      let resourceManager = ResourceManager.getInstance();
      try {
        let recentText: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
        when(recentText)(ArgumentMatchers.any).afterReturn('test1');
        RecentAccessibilityUtils.textAnnouncedForFocusRecent();
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(resourceManager, resourceManager.getStringByIdSync);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClearApp_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = null;
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      let resourceManager = ResourceManager.getInstance();
      try {
        let recentText: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
        when(recentText)(ArgumentMatchers.any).afterReturn('test1');
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClearApp(scContainerSession);
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClearApp_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = null;
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      let resourceManager = ResourceManager.getInstance();
      try {
        let recentText: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
        when(recentText)(ArgumentMatchers.any).afterReturn('test1');
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClearApp(scContainerSession);
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClearApp_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      let resourceManager = ResourceManager.getInstance();
      try {
        let recentText: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
        when(recentText)(ArgumentMatchers.any).afterReturn('test1');
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClearApp(scContainerSession);
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClearApp_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      let resourceManager = ResourceManager.getInstance();
      try {
        let recentText: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
        when(recentText)(ArgumentMatchers.any).afterReturn('test1');
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClearApp(scContainerSession);
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClickTask_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = null;
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      try {
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClickTask(scContainerSession, () => {});
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClickTask_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = null;
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      try {
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClickTask(scContainerSession, () => {});
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClickTask_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      try {
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClickTask(scContainerSession, () => {});
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('RecentAccessibilityUtils_test_textAnnouncedForClickTask_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let appInfo: AppItemInfo | null = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      try {
        let primaryAppInfo: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getSession);
        when(primaryAppInfo)(ArgumentMatchers.any).afterReturn(appInfo);
        RecentAccessibilityUtils.textAnnouncedForClickTask(scContainerSession, () => {});
        expect(accessibilityManager).not().assertNull();
        mocker.ignoreMock(RecentTitleViewModel, RecentTitleViewModel.getSession);
      } catch (e) {
        expect(false).assertFail();
      }
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('test_textAnnouncedForLockApp_lock', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let accessibilityManager = AccessibilityManager.getInstance();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      RecentAccessibilityUtils.textAnnouncedForLockApp('test', 1);
      mocker.verify('getIsAccessibilityMode', []).once();
      expect(accessibilityManager).not().assertNull();
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('test_textAnnouncedForLockApp_unlock', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let accessibilityManager = AccessibilityManager.getInstance();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      RecentAccessibilityUtils.textAnnouncedForLockApp('test', 0);
      mocker.verify('getIsAccessibilityMode', []).once();
      expect(accessibilityManager).not().assertNull();
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('test_textAnnouncedForLockApp_lock_IsAccessibilityMode', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let accessibilityManager = AccessibilityManager.getInstance();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      RecentAccessibilityUtils.textAnnouncedForLockApp('test', 1);
      mocker.verify('getIsAccessibilityMode', []).once();
      expect(accessibilityManager).not().assertNull();
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('test_textAnnouncedForLockApp_unlock_IsAccessibilityMode', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let accessibilityManager = AccessibilityManager.getInstance();
      let getIsAccessibilityMode: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      RecentAccessibilityUtils.textAnnouncedForLockApp('test', 0);
      mocker.verify('getIsAccessibilityMode', []).once();
      expect(accessibilityManager).not().assertNull();
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })
  })
}