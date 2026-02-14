/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneInfo,
  SCBSceneSessionManager,
} from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  describe,
  beforeAll,
  it,
  expect,
  Level,
  beforeEach,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import {
  SCBPhoneSceneMissionProcessor
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/missionmanagement/SCBPhoneSceneMissionProcessor';
import { StartInterceptions } from '@ohos/windowscene/src/main/ets/scene/framework/missions/SCBSceneStartInterceptor';

const MOCK_TAG = 'SCBPhoneSceneMissionProcessor';
const mockLog = LogHelper.getLogHelper(LogDomain.WINDOW, MOCK_TAG);
let sceneSession: SCBSceneSession;
let screenProperty: SCBScreenProperty = new SCBScreenProperty();

export default function SCBPhoneSceneMissionProcessorTest() {

  describe('SCBPhoneSceneMissionProcessor_removeSceneSessionAfterDestruct_testSuite', () => {
    let mocker: MockKit;
    let processor: SCBPhoneSceneMissionProcessor = new SCBPhoneSceneMissionProcessor();
    beforeAll(() => {
    });

    beforeEach(() => {
      mocker = new MockKit();
    });

    it('test_whenContainerNotFound_thenSuccess', Level.LEVEL0, () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();
      processor.removeSceneSessionAfterDestruct(-1);
      mocker.verify('showInfo', ['removeSceneSessionAfterDestruct sceneContainerSession or sceneSession is null.'])
        .once();

      mocker.ignoreMock(mockLog, mockLog.showError);
    });

    it('test_whenRemoveFromFullScreen_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 124);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      SCBScenePanelManager.getInstance().getSceneContainerSessionList().add(containerSession);
      let beforeLength:number = SCBScenePanelManager.getInstance().getTotalSessionListIncludeNotShowRecent().length;

      processor.removeSceneSessionAfterDestruct(sceneSession.sceneInfo.persistentId);
      let afterLength:number = SCBScenePanelManager.getInstance().getTotalSessionListIncludeNotShowRecent().length;

      expect(beforeLength - 1).assertEqual(afterLength);
    });

    it('test_onPendingSessionToBackground_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo: sceneSessionManager.SceneInfo = {
        bundleName: 'test bundleName',
        moduleName: 'test moduleName',
        abilityName: 'test abilityName',
        appIndex: 0,
        persistentId: 11
      };
      let record1: Record<string, Object> = {
        'isFloatSceneBackgroundToSideBar': true
      };
      let record2: Record<string, Object> = {
        'isFloatSceneBackgroundToSideBar': false
      };
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let mocker: MockKit = new MockKit();
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockFunc: Function =
        mocker.mockFunc(SCBSceneSessionManager, scbSceneSessionManager.getFloatContainerSessionFromScenePanel);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isFloat = false;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSession);
      processor.onPendingSessionToBackground(sceneInfo, false, record1);
      expect(containerSession.isDisappearing).assertFalse();
      containerSession.isFloat = true;
      processor.onPendingSessionToBackground(sceneInfo, false, record2);
      mocker.ignoreMock(SCBSceneSessionManager, scbSceneSessionManager.getFloatContainerSessionFromScenePanel);
      expect(containerSession.isDisappearing).assertFalse();
    });
  });

  describe('isSceneStartingIntercepted_testSuite', () => {
    let mocker: MockKit;
    let processor: SCBPhoneSceneMissionProcessor = new SCBPhoneSceneMissionProcessor();
    let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();

    beforeAll(() => {
    });

    beforeEach(() => {
      mocker = new MockKit();
    });

    it('atc_should_return_false_when_targetInfo_is_null', 0, () => {
      let mockfunc: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let targetInfo: SCBSceneInfo | null = null;
      let startFrom: StartInterceptions = StartInterceptions.FROM_ICON;
      const result = processor.isSceneStartingIntercepted(targetInfo, startFrom);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('atc_should_return_true_when_startFrom_is_FROM_ICON_and_DeviceHelper_is_Pad_and_isProjectionBundleName_is_true', 0, () => {
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfuncLogHelperShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfuncDeviceHelperIsPad: Function = mocker.mockFunc(deviceHelper, deviceHelper.isPad);
      let mockfuncSceneSessionManagerIsProjectionBundleName: Function = mocker.mockFunc(sceneSessionManager,
        sceneSessionManager.isProjectionBundleName);
      when(mockfuncLogHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfuncDeviceHelperIsPad)().afterReturn(true);
      when(mockfuncSceneSessionManagerIsProjectionBundleName)(ArgumentMatchers.anyString).afterReturn(true);

      let targetInfo: SCBSceneInfo = new SCBSceneInfo("bundleName", "moduleName", "abilityName", 0, 0);
      let startFrom: StartInterceptions = StartInterceptions.FROM_ICON;
      const result = processor.isSceneStartingIntercepted(targetInfo, startFrom);

      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(deviceHelper, deviceHelper.isPad);
      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.isProjectionBundleName);
    });
  });
}