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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
SCBSceneContainerSession,
SCBSceneContainerSessionArray,
SCBSceneInfo,
SCBScenePanelManager,
SCBSceneSession,
SCBScreenProperty,
SCBScreenSessionManager
} from '@ohos/windowscene';
import { RecentStartScene } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentStartScene';
import { RecentStartSceneCallback } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentCallbacks';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import {
  recentRuntimeInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';
import { recentLayoutConfigInstance } from '@ohos/recents';

export default function RecentStartSceneTest() {
  describe('RecentStartSceneTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let screenProperty = new SCBScreenProperty();
    screenProperty.width = 100;
    screenProperty.height = 100;
    screenProperty.left = 0;
    screenProperty.top = 0;
    screenProperty.radius = 20;
    screenProperty.rotation = 0;
    screenProperty.screenId = 0;
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(screenProperty);
    let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let recentStartScene: RecentStartScene = new RecentStartScene(scenePanelManager);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));

    it('RecentStartScene_prepareEnterAppFromRecent_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 1;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 1;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_prepareEnterAppFromRecent_test_05_copy20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2]?.needRenderShowInRecent?.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = totalContainerSessionList.length;
      recentRuntimeInstance.autoCenterColumn = 2;
      let mocker: MockKit = new MockKit();
      let getRelativeColumn: Function =
        mocker.mockFunc(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      when(getRelativeColumn)(ArgumentMatchers.any).afterReturn(0);
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      expect(recentStartScene.prepareEnterAppFromRecent(totalContainerSessionList[1], 0)).assertEqual(1);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentRuntimeInstance, recentRuntimeInstance.getRelativeColumn);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('RecentStartScene_playStartSceneAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentStartSceneFinishCallback: RecentStartSceneCallback = {
        onFinish: (containerSession: SCBSceneContainerSession, animationNum: number) => {}
      }
      let mocker: MockKit = new MockKit();
      let getScreenProperty: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      when(getScreenProperty)(ArgumentMatchers.any).afterReturn(screenProperty);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentStartScene.playStartSceneAnimation(0, 0, scbSceneContainer, recentStartSceneFinishCallback);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      expect(recentStartScene).not().assertNull();
    })

    it('RecentStartScene_playStartSceneAnimation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentStartSceneFinishCallback: RecentStartSceneCallback = {
        onFinish: (containerSession: SCBSceneContainerSession, animationNum: number) => {}
      }
      let mocker: MockKit = new MockKit();
      let getScreenProperty: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      when(getScreenProperty)(ArgumentMatchers.any).afterReturn(screenProperty);
      let isNeedMultiRowLayout: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentStartScene.playStartSceneAnimation(1, 0, scbSceneContainer, recentStartSceneFinishCallback);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      expect(recentStartScene).not().assertNull();
    })

    it('RecentStartScene_createStartSceneAnimationInMultiRow_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentStartScene as object)['isNewStyle'] = true;
      (recentStartScene as object)['createStartSceneAnimationInMultiRow']();
      expect(recentStartScene).not().assertNull();
    })

    it('RecentStartScene_createStartSceneAnimationInMultiRow_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentStartScene as object)['isNewStyle'] = false;
      (recentStartScene as object)['createStartSceneAnimationInMultiRow']();
      expect(recentStartScene).not().assertNull();
    })

    it('RecentStartScene_createStartSceneAnimationInSingleRow_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentStartScene as object)['isNewStyle'] = false;
      (recentStartScene as object)['createStartSceneAnimationInSingleRow']();
      expect(recentStartScene).not().assertNull();
    })

    it('RecentStartScene_createStartSceneAnimationInSingleRow_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentStartScene as object)['isNewStyle'] = false;
      (recentStartScene as object)['createStartSceneAnimationInSingleRow']();
      expect(recentStartScene).not().assertNull();
    })

    it('adjustSessionParamForStartSceneAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenProperty: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
      when(getScreenProperty)(ArgumentMatchers.any).afterReturn(-1);
      (recentStartScene as object)['adjustSessionParamForStartSceneAnimation'](scbSceneContainer, 1, 0);
      expect(recentStartScene).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
    })

    it('adjustSessionParamForStartSceneAnimation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenProperty: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
      when(getScreenProperty)(ArgumentMatchers.any).afterReturn(0);
      (recentStartScene as object)['adjustSessionParamForStartSceneAnimation'](scbSceneContainer, 1, 0);
      expect(recentStartScene).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
    })

    it('adjustSessionParamForStartSceneAnimation_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenProperty: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
      when(getScreenProperty)(ArgumentMatchers.any).afterReturn(2);
      (recentStartScene as object)['adjustSessionParamForStartSceneAnimation'](scbSceneContainer, 1, 0);
      expect(recentStartScene).not().assertNull();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
    })

    it('startSceneAnimationEventInSingleRow_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      totalContainerSessionList[0].needRenderShowInRecent.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1].needRenderShowInRecent.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[2].needRenderShowInRecent.setShowInRecentWithDfx(true, 'RecentStartSceneTest', 'test');
      totalContainerSessionList[1].isFloatView = true;
      let mocker: MockKit = new MockKit();
      let getSceneContainerSessionListForView: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      (recentStartScene as object)['startSceneAnimationEventInSingleRow'](1);
      expect(recentStartScene).not().assertUndefined();
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startSceneAnimationEventInMultiRow_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getSceneContainerSessionList: Function =
        mocker.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
      when(getSceneContainerSessionList)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      (recentStartScene as object)['startSceneAnimationEventInMultiRow'](1);
      expect(recentStartScene).not().assertUndefined();
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList);
    })
  })
}