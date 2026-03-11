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
import { describe, it, expect, MockKit, when, ArgumentMatchers, beforeAll, Level } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneMissionProcessor } from '../../../../../../../main/ets/scene/framework/missions/SCBSceneMissionProcessor';
import { SCBSceneMissionManager, SceneMissionMgmtStage } from '../../../../../../../main/ets/scene/manager/SCBSceneMissionManager';
import { SCBSceneSessionManager } from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { SCBSceneInfo } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import { ReflectionUtils } from '../session/ReflectionUtils';
import {
  SCBScreenProperty,
  SCBSceneContainerSession,
} from '../../../../../../../../../../../staticcommon/basecommon/windowscene/src/main/ets/TsIndex';
import {
  SCBScreenMissionHandler
} from '../../../../../../../main/ets/scene/framework/missions/SCBScreenMissionHandler';
import { LogDomain, LogHelper } from '@ohos/basicutils';

export function SCBSceneMissionManagerTest() {
  class ProductMissionProcessor extends SCBSceneMissionProcessor {
    public onPendingSessionToStart(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
    }

    public onPendingSessionToBackground(sceneInfo: sceneSessionManager.SceneInfo, shouldBackToCaller: boolean,
      record: Record<string, Object>): void {}
  }

  let mocker: MockKit;
  let productProcessor: ProductMissionProcessor = new ProductMissionProcessor();

  describe('SCBSceneMissionManagerTest', () => {
    beforeAll(() => {
      SCBSceneMissionManager.getInstance().init(SceneMissionMgmtStage.ON_SCB_INIT);
      mocker = new MockKit();
    });

    it('test_processor_whenNotifyAfterRegister_thenProcessorNotified', Level.LEVEL0, async () => {
      let mockFunc: Function = mocker.mockFunc(productProcessor, productProcessor.onPendingSessionToStart);
      SCBSceneMissionManager.getInstance().registerProductMissionProcessor(productProcessor);

      SCBSceneMissionManager.getInstance().notifySessionPendingActivation(null, null);
      mocker.verify('onPendingSessionToStart', [null, null]).atLeast(1);
    });

    it('pendingSessionToBackground', 0, async (done: Function) => {
      let sceneInfo: sceneSessionManager.SceneInfo = {
        bundleName: 'test bundleName',
        moduleName: 'test moduleName',
        abilityName: 'test abilityName',
        appIndex: 0,
        persistentId: 1112
      };
      let record1: Record<string, Object> = {
        'isFloatSceneBackgroundToSideBar': true
      };
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mocker: MockKit = new MockKit();
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockFunc: Function =
        mocker.mockFunc(SCBSceneSessionManager, scbSceneSessionManager.getFloatContainerSessionFromScenePanel);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSession);
      containerSession.isFloat = false;
      let missionManager: SCBSceneMissionManager = SCBSceneMissionManager.getInstance();
      missionManager.registerProductMissionProcessor(productProcessor);
      missionManager.pendingSessionToBackground(sceneInfo, false, record1);
      expect(containerSession.isDisappearing).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, scbSceneSessionManager.getFloatContainerSessionFromScenePanel);
      done();
    });

    it('test_closeSessionWithCondition_whenConditionReturnTure_thenCloseSession', 0, async (done: Function) => {
      let condition = () => { return true; }
      let closeScreenId: number | undefined = undefined;
      let closePersistentId: number | undefined = undefined;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let map: Map<number, SCBSceneSession> = ReflectionUtils.getProperty(SCBSceneMissionManager.getInstance(),
        'globalSceneSessionCache') as Map<number, SCBSceneSession>;
      map.set(100, sceneSession);
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().close);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      when(mockFunc)(ArgumentMatchers.any).afterAction((screenId: number, persistentId: number) => {
        closeScreenId = screenId;
        closePersistentId = persistentId;
      });
      SCBSceneMissionManager.getInstance().closeSessionWithCondition(condition);
      expect(closeScreenId !== undefined).assertTrue();
      expect(closePersistentId !== undefined).assertTrue();
      done();
    });

    it('test_closeSessionWithCondition_whenConditionReturnFalse_thenNotCloseSession', 0, async (done: Function) => {
      let condition = () => { return false; }
      let closeScreenId: number | undefined = undefined;
      let closePersistentId: number | undefined = undefined;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let map: Map<number, SCBSceneSession> = ReflectionUtils.getProperty(SCBSceneMissionManager.getInstance(),
        'globalSceneSessionCache') as Map<number, SCBSceneSession>;
      map.set(100, sceneSession);
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().close);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      when(mockFunc)(ArgumentMatchers.any).afterAction((screenId: number, persistentId: number) => {
        closeScreenId = screenId;
        closePersistentId = persistentId;
      });
      SCBSceneMissionManager.getInstance().closeSessionWithCondition(condition);
      expect(closeScreenId == undefined).assertTrue();
      expect(closePersistentId == undefined).assertTrue();
      done();
    });

    it('test_getTargetScreenTopActiveSceneSession_whenNoMatches_thenReturnNull', 0, async (done: Function) => {
      let screenId: number | undefined = undefined;
      let screenName: string | undefined = undefined;
      let result: ESObject =
        SCBSceneMissionManager.getInstance().getTargetScreenTopActiveSceneSession(screenId, screenName);
      expect(result).assertNull();
      done();
    });

    it('test_getTargetScreenTopActiveSceneSession_whenScreenIdOrScreenNameMatches_thenReturnTopActiveSession', 0,
      async (done: Function) => {
        let screenId: number = 1;
        let screenName: string = 'testScreenName';
        let mocker: MockKit = new MockKit();
        let mockScreenHandler: SCBScreenMissionHandler = new SCBScreenMissionHandler(screenId);
        let result: SCBSceneContainerSession | null =
          SCBSceneMissionManager.getInstance().getTargetScreenTopActiveSceneSession(screenId, screenName);
        expect(result).not().assertNull();
        mocker.ignoreMock(mockScreenHandler, mockScreenHandler.getTopActiveSession);
        done();
      });
  });

  describe('suite_func_transferSceneToTargetScreen', () => {
    beforeAll(() => {
      mocker = new MockKit();
    });

    it('givenInvalidScreen_whenTransfer_thenShowError', Level.LEVEL0, async () => {
      let logger = LogHelper.getLogHelper(LogDomain.WINDOW, '[SCBMission]SCBSceneMissionManager');
      let mockLogShowError = mocker.mockFunc(logger, logger.showError);
      SCBSceneMissionManager.getInstance().transferSceneToTargetScreen(-1, -1);
      mocker.verify('showError', ['no screen to response.']).once();
    });
  });
}