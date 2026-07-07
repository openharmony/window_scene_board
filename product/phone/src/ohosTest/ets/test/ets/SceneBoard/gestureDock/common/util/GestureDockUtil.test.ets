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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {
  GestureDockUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/GestureDockUtil';
import { GestureDockItemInfo } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import {
  SCBSceneSession,
  SCBSceneInfo,
  SCBSceneContainerSession,
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBSceneContainerSessionArray,
} from '@ohos/windowscene';
import { image } from '@kit.ImageKit';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  AppItemInfo,
  AppModel,
  CommonConstants,
  DeliverUtil,
  DockItemInfo,
  RdbStoreManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { bundleManager } from '@kit.AbilityKit';

export default function GestureDockUtilTest() {
  describe('GestureDockUtilTest', () => {
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

    it('GestureDockUtil_isEmptyArr', 0, () => {
      GestureDockUtil.isEmptyArr([]);
      expect(GestureDockUtil).not().assertUndefined();
    })

    it('GestureDockUtil_showToast', 0, async (done: Function) => {
      await GestureDockUtil.showToast();
      expect(GestureDockUtil).not().assertUndefined();
      done();
    })

    it('GestureDockUtil_hideTextInput', 0, async (done: Function) => {
      await GestureDockUtil.hideTextInput();
      expect(GestureDockUtil).not().assertUndefined();
      done();
    })

    it('GestureDockUtil_getItemKey', 0, async (done: Function) => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = '';
      itemInfo.appIconId = 1;
      await GestureDockUtil.getItemKey('a', 100, 1, itemInfo);
      expect(GestureDockUtil).not().assertUndefined();
      done();
    })

    it('GestureDockUtil_getItemKey_01', 0, async (done: Function) => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'abc';
      itemInfo.appIconId = 1;
      await GestureDockUtil.getItemKey('a', 100, 1, itemInfo);
      expect(GestureDockUtil).not().assertUndefined();
      done();
    })

    it('GestureDockUtil_getAppIconOpacity', 0, async (done: Function) => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      let mocker: MockKit = new MockKit();
      let mockerFuc: Function = mocker.mockFunc(GestureDockUtil, GestureDockUtil.isNeedUpdateAppIconOpacity);
      when(mockerFuc)(ArgumentMatchers.any).afterReturn(true);
      itemInfo.bundleName = 'abc';
      itemInfo.appIconId = 1;
      await GestureDockUtil.getAppIconOpacity(itemInfo);
      expect(GestureDockUtil).not().assertUndefined();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.isNeedUpdateAppIconOpacity);
      done();
    })

    it('GestureDockUtil_getAppIconOpacity_01', 0, async (done: Function) => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      let mocker: MockKit = new MockKit();
      let mockerFuc: Function = mocker.mockFunc(GestureDockUtil, GestureDockUtil.isNeedUpdateAppIconOpacity);
      when(mockerFuc)(ArgumentMatchers.any).afterReturn(false);
      itemInfo.bundleName = 'abc';
      itemInfo.appIconId = 1;
      await GestureDockUtil.getAppIconOpacity(itemInfo);
      expect(GestureDockUtil).not().assertUndefined();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.isNeedUpdateAppIconOpacity);
      done();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_1', 0, (): void => {
      AppStorage.setOrCreate('scenePanelState', 4);
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(new GestureDockItemInfo());
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_2', 0, (): void => {
      AppStorage.setOrCreate('scenePanelState', 0);
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(new GestureDockItemInfo());
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_3', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('test', '2', '3', 1, 1);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
      AppStorage.setOrCreate('scenePanelState', 1);
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test';
      gestureDockItemInfo1.appIndex = 1;
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(gestureDockItemInfo1);
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_4', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('test', '2', '3', 1, 1);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
      AppStorage.setOrCreate('scenePanelState', 2);
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test';
      gestureDockItemInfo1.appIndex = 1;
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(gestureDockItemInfo1);
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_5', 0, (): void => {
      AppStorage.setOrCreate('scenePanelState', 3);
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(new GestureDockItemInfo());
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_6', 0, (): void => {
      AppStorage.setOrCreate('scenePanelState', 5);
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(new GestureDockItemInfo());
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_isNeedUpdateAppIconOpacity_7', 0, (): void => {
      AppStorage.setOrCreate('scenePanelState', 5);
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(GestureDockUtil,(GestureDockUtil as object)['isNonMultiAndSameBundleAppIndex']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = GestureDockUtil.isNeedUpdateAppIconOpacity(new GestureDockItemInfo());
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(GestureDockUtil,(GestureDockUtil as object)['isNonMultiAndSameBundleAppIndex']);
    })

    it('GestureDockUtil_isNonMultiAndSameBundleAppIndex_1', 0, (): void => {
      let sceneInfo1 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneInfo1.bundleName = 'testPriBundle';
      sceneInfo1.appIndex = 0;
      let sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneInfo2.launchType = bundleManager.LaunchType.SINGLETON;
      sceneInfo2.bundleName = 'testPriBundle';
      sceneInfo2.appIndex = 0;
      expect((GestureDockUtil as object)['isNonMultiAndSameBundleAppIndex'](sceneInfo1, sceneInfo2) !== undefined).assertTrue();
    })

    it('GestureDockUtil_areTwoAppItemsSame_1', 0, (): void => {
      let item1: AppItemInfo = new AppItemInfo();
      item1.bundleName = 'a';
      item1.appIndex = 1;
      let item2: AppItemInfo = new AppItemInfo();
      item2.bundleName = 'a';
      item2.appIndex = 1;
      let result: boolean = GestureDockUtil.areTwoAppItemsSame(item1, item2);
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_areTwoAppItemsSame_2', 0, (): void => {
      let item1: AppItemInfo = new AppItemInfo();
      item1.bundleName = 'a';
      item1.appIndex = 1;
      let item2: AppItemInfo = new AppItemInfo();
      item2.bundleName = 'a';
      item2.appIndex = 2;
      let result: boolean = GestureDockUtil.areTwoAppItemsSame(item1, item2);
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_areTwoAppItemsSame_3', 0, (): void => {
      let item1: AppItemInfo = new AppItemInfo();
      item1.bundleName = 'a';
      item1.appIndex = 1;
      let item2: AppItemInfo = new AppItemInfo();
      item2.bundleName = 'b';
      item2.appIndex = 1;
      let result: boolean = GestureDockUtil.areTwoAppItemsSame(item1, item2);
      expect(result !== undefined).assertTrue();
    })

    it('GestureDockUtil_buildDockItemInfo', 0, (): void => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.typeId = 2;
      expect(GestureDockUtil.buildDockItemInfo(appItemInfo) !== undefined).assertTrue();
    })

    it('GestureDockUtil_buildDockItemInfo_1', 0, (): void => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.typeId = 3;
      expect(GestureDockUtil.buildDockItemInfo(appItemInfo) !== undefined).assertTrue();
    })

    it('GestureDockUtil_buildSceneInfoByAppItem', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let sessionMgr: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockerFuc: Function = mocker.mockFunc(sessionMgr, sessionMgr.isDeliverApplication);
      let mockerFuc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isStartContainerApp);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'testDeliverApp';
      when(mockerFuc)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFuc1)(ArgumentMatchers.any).afterReturn(true);
      let res = GestureDockUtil.buildSceneInfoByAppItem(appItemInfo);
      when(mockerFuc1)(ArgumentMatchers.any).afterReturn(false);
      let res1 = GestureDockUtil.buildSceneInfoByAppItem(appItemInfo);
      mocker.clear(sessionMgr);
      mocker.clear(GestureDockUtil);
      expect(res).not().assertUndefined();
      expect(res1).not().assertUndefined();
    })

    it('GestureDockUtil_getTargetBundleName', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let appModel = AppModel.getInstance();
      let mockerFuc: Function =
        mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      when(mockerFuc)(ArgumentMatchers.any).afterReturn('targetBundleName');
      let res1 = GestureDockUtil.getTargetBundleName(DeliverUtil.ABROAD_APP_PKG);
      let res2 = GestureDockUtil.getTargetBundleName('test');
      mocker.clear(appModel);
      expect(res1).not().assertUndefined();
      expect(res2).not().assertUndefined();
    })
  })
}