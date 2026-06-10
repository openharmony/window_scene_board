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
  expect, MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { SCBSceneInfo } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneInfo'
import { SCBSceneSession } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSession'
import sceneSessionManager from '@ohos.sceneSessionManager'
import { SCBSceneContainerSession,
  SCBSceneContainerSessionArray } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession'
import { SCBScreenProperty } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession'
import {
  RecentLockIconModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentLockIconModel'
import { recentTitleViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/RecentTitleViewModel';
import { common } from '@kit.AbilityKit'
import {
  recentRuntimeInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel'
import { RecentGesture } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentGesture'
import { SCBScenePanelManager } from '@ohos/windowscene/src/main/ets/TsIndex'
import { recentLayoutConfigInstance } from '@ohos/recents'

export default function RecentLockIconModelTest() {
  describe('RecentLockIconModelTest', () => {
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

    it('test_lockIconZoomInAnimate', 0, () => {
      let mocker: MockKit = new MockKit();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      mocker.mockFunc(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
      RecentLockIconModel.lockIconZoomInAnimate(session);
      mocker.verify('setLockIconScale', [1.3]).once();
      mocker.ignoreMock(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
    })

    it('test_lockIconZoomOutAnimate', 0, () => {
      let mocker: MockKit = new MockKit();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      mocker.mockFunc(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
      RecentLockIconModel.lockIconZoomOutAnimate(session);
      mocker.verify('setLockIconScale', [1]).once();
      mocker.ignoreMock(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
    })

    it('test_lockIconAppearAnimate', 0, () => {
      let mocker: MockKit = new MockKit();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      mocker.mockFunc(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(session.needRenderLockIconOpacity, session.needRenderLockIconOpacity.setLockIconOpacity);
      RecentLockIconModel.lockIconAppearAnimate(session);
      mocker.verify('setLockIconScale', [1]).once();
      mocker.verify('setLockIconOpacity', [1]).once();
      mocker.ignoreMock(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(session.needRenderLockIconOpacity, session.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_lockIconDisAppearAnimate', 0, () => {
      let mocker: MockKit = new MockKit();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      mocker.mockFunc(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(session.needRenderLockIconOpacity, session.needRenderLockIconOpacity.setLockIconOpacity);
      RecentLockIconModel.lockIconDisAppearAnimate(session, 'test');
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(session.needRenderLockIconScale, session.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(session.needRenderLockIconOpacity, session.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_lockIconDisAppearAnimate', 0, () => {
      let mocker: MockKit = new MockKit();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let uiContext = sceneSessionManager.getRootSceneUIContext();;
      mocker.mockFunc(session.needRenderLockIconTranslate, session.needRenderLockIconTranslate.setLockIconTranslateX);
      RecentLockIconModel.lockIconPosChangeAnimate(session, uiContext);
      mocker.verify('setLockIconTranslateX', [-2.5]).once();
      mocker.verify('setLockIconTranslateX', [1.25]).once();
      mocker.verify('setLockIconTranslateX', [-0.63]).once();
      mocker.verify('setLockIconTranslateX', [0.31]).once();
      mocker.verify('setLockIconTranslateX', [0]).once();
      mocker.ignoreMock(session.needRenderLockIconTranslate, session.needRenderLockIconTranslate.setLockIconTranslateX);
    })

    it('test_existLockedSessionInSingleTask', 0, () => {
      let mocker: MockKit = new MockKit();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.autoCenterColumn = 2;
      let isExist = RecentLockIconModel.existLockedSessionInSingleTask();
      expect(isExist).assertEqual(false);
    })

    it('test_existLockedSessionInSingleTask_midSession_locked', 0, () => {
      let mocker: MockKit = new MockKit();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.autoCenterColumn = 2;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      let isExist = RecentLockIconModel.existLockedSessionInSingleTask();
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInSingleTask_leftSession_locked', 0, () => {
      let mocker: MockKit = new MockKit();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.autoCenterColumn = 2;
      recentRuntimeInstance.notRemovingSessionList[1].isAppLockedForbidDelete = true;
      let isExist = RecentLockIconModel.existLockedSessionInSingleTask();
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInSingleTask_rightSession_locked', 0, () => {
      let mocker: MockKit = new MockKit();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.autoCenterColumn = 2;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let isExist = RecentLockIconModel.existLockedSessionInSingleTask();
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_left', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[0].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[1].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid1', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid2', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid3', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid4', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid5', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid6', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid7', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid8', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid9', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid10', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_mid11', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[2].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[3].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_right1', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[4].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[5].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_right2', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[4].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[5].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_right3', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[4].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[5].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_right4', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[4].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[5].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_right', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      recentRuntimeInstance.notRemovingSessionList[4].isAppLockedForbidDelete = true;
      recentRuntimeInstance.notRemovingSessionList[5].isAppLockedForbidDelete = true;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_locked_all', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      scbSceneContainerSession.isAppLockedForbidDelete = true;
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 3;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 2;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(true);
    })

    it('test_existLockedSessionInMultiTask_unlocked', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      scbSceneContainerSession.isAppLockedForbidDelete = false;
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray;
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      recentGesture.multiColumnNum = 0;
      recentGesture.middleColumnIndex = 1;
      recentGesture.leftColumnIndex = 2;
      recentGesture.rightColumnIndex = 3;
      let isExist = RecentLockIconModel.existLockedSessionInMultiTask(recentGesture);
      expect(isExist).assertEqual(false);
    })

    it('test_isDelayUnClearableAnimate_single', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      mocker.mockFunc(RecentLockIconModel, RecentLockIconModel.existLockedSessionInSingleTask);
      RecentLockIconModel.isDelayUnClearableAnimate(recentGesture);
      mocker.verify('existLockedSessionInSingleTask', []).once();
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mocker.ignoreMock(RecentLockIconModel, RecentLockIconModel.existLockedSessionInSingleTask);
    })

    it('test_isDelayUnClearableAnimate_multi', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      mocker.mockFunc(RecentLockIconModel, RecentLockIconModel.existLockedSessionInMultiTask);
      RecentLockIconModel.isDelayUnClearableAnimate(recentGesture);
      mocker.verify('existLockedSessionInMultiTask', [recentGesture]).once();
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mocker.ignoreMock(RecentLockIconModel, RecentLockIconModel.existLockedSessionInMultiTask);
    })

    it('test_lockStateChange_false', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, false);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(false);
    })

    it('test_lockStateChange_true', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true1', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true2', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true3', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true4', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true5', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true6', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true7', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true8', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true9', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true10', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_lockStateChange_true11', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_initLockIconStatus_false', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      if (scbSceneContainerSession.primarySession?.sceneInfo) {
        scbSceneContainerSession.primarySession.sceneInfo.isLockedInRecent = false;
      }
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_initLockIconStatus_true', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      if (scbSceneContainerSession.primarySession?.sceneInfo) {
        scbSceneContainerSession.primarySession.sceneInfo.isLockedInRecent = true;
      }
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [1]).once();
      mocker.verify('setLockIconOpacity', [1]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_initLockIconStatus_secondarySession', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      scbSceneContainerSession.secondarySession = session;
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_copy1_isDelayUnClearableAnimate_single', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      mocker.mockFunc(RecentLockIconModel, RecentLockIconModel.existLockedSessionInSingleTask);
      RecentLockIconModel.isDelayUnClearableAnimate(recentGesture);
      mocker.verify('existLockedSessionInSingleTask', []).once();
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mocker.ignoreMock(RecentLockIconModel, RecentLockIconModel.existLockedSessionInSingleTask);
    })

    it('test_copy1_isDelayUnClearableAnimate_multi', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      mocker.mockFunc(RecentLockIconModel, RecentLockIconModel.existLockedSessionInMultiTask);
      RecentLockIconModel.isDelayUnClearableAnimate(recentGesture);
      mocker.verify('existLockedSessionInMultiTask', [recentGesture]).once();
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mocker.ignoreMock(RecentLockIconModel, RecentLockIconModel.existLockedSessionInMultiTask);
    })

    it('test_copy1_lockStateChange_false', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, false);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(false);
    })

    it('test_copy1_lockStateChange_true', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, true);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_copy1_initLockIconStatus_false', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      if (scbSceneContainerSession.primarySession?.sceneInfo) {
        scbSceneContainerSession.primarySession.sceneInfo.isLockedInRecent = false;
      }
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_copy1_initLockIconStatus_true', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      if (scbSceneContainerSession.primarySession?.sceneInfo) {
        scbSceneContainerSession.primarySession.sceneInfo.isLockedInRecent = true;
      }
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [1]).once();
      mocker.verify('setLockIconOpacity', [1]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_copy1_initLockIconStatus_secondarySession', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      scbSceneContainerSession.secondarySession = session;
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_copy2_isDelayUnClearableAnimate_single', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      mocker.mockFunc(RecentLockIconModel, RecentLockIconModel.existLockedSessionInSingleTask);
      RecentLockIconModel.isDelayUnClearableAnimate(recentGesture);
      mocker.verify('existLockedSessionInSingleTask', []).once();
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mocker.ignoreMock(RecentLockIconModel, RecentLockIconModel.existLockedSessionInSingleTask);
    })

    it('test_copy2_isDelayUnClearableAnimate_multi', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
      mocker.mockFunc(RecentLockIconModel, RecentLockIconModel.existLockedSessionInMultiTask);
      RecentLockIconModel.isDelayUnClearableAnimate(recentGesture);
      mocker.verify('existLockedSessionInMultiTask', [recentGesture]).once();
      mocker.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mocker.ignoreMock(RecentLockIconModel, RecentLockIconModel.existLockedSessionInMultiTask);
    })

    it('test_copy2_lockStateChange_false', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      RecentLockIconModel.lockStateChange(scbSceneContainerSession, false);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(false);
    })

    it('test_copy2_lockStateChange_true', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      expect(scbSceneContainerSession.primarySession?.sceneInfo.isLockedInRecent).assertEqual(true);
    })

    it('test_copy2_initLockIconStatus_false', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      if (scbSceneContainerSession.primarySession?.sceneInfo) {
        scbSceneContainerSession.primarySession.sceneInfo.isLockedInRecent = false;
      }
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_copy2_initLockIconStatus_true', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      if (scbSceneContainerSession.primarySession?.sceneInfo) {
        scbSceneContainerSession.primarySession.sceneInfo.isLockedInRecent = true;
      }
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [1]).once();
      mocker.verify('setLockIconOpacity', [1]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })

    it('test_copy2_initLockIconStatus_secondarySession', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      scbSceneContainerSession.secondarySession = session;
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.mockFunc(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
      (recentTitleViewModel as object)['initLockIconStatus'](scbSceneContainerSession);
      mocker.verify('setLockIconScale', [0.5]).once();
      mocker.verify('setLockIconOpacity', [0]).once();
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconScale,
        scbSceneContainerSession.needRenderLockIconScale.setLockIconScale);
      mocker.ignoreMock(scbSceneContainerSession.needRenderLockIconOpacity,
        scbSceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity);
    })
  })
}