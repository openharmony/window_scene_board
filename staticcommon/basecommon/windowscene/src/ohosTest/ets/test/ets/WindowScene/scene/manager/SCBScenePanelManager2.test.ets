/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import SceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSession
} from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { SCBSceneInfo } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import { SCBScreenProperty } from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import {
  SCBPanelParam,
  SCBScenePanelManager } from '../../../../../../../main/ets/scene/manager/SCBScenePanelManager';
import { SCBBackgroundBlurSession, SCBScenePanelSession } from '../../../../../../../main/ets/scene/manager/SCBScenePanelSession';
import { SCBSceneContainerSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { CommonUtils } from '@ohos/basicutils';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import { RecentViewParam } from '../../../../../../../main/ets/recent/RecentViewParam';

function getContainerSession(): SCBSceneContainerSession {
  let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let session = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
  return session;
}

export function SCBScenePanelManagerTwoTest() {
  describe('SCBScenePanelManagerTwoTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('addSceneContainerSessionByIndexTest01', 0, async (done: Function) => {
      let mgr = new SCBScenePanelManager();
      let session = getContainerSession();
      mgr.addSceneContainerSession(session);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(1);

      let sceneInfo = new SCBSceneInfo('addSceneContainerSessionByIndexBundle',
        'addSceneContainerSessionByIndexModule', 'addSceneContainerSessionByIndexAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      mgr.addSceneContainerSessionByIndex(1, session2);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(2);
      done();
    });

    it('removeFloatSceneContainerSessionTest01', 0, async (done: Function) => {
      let manager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      manager.removeFloatSceneContainerSession(session);
      done();
    });

    it('removeFloatContainerSessionByIndexTest02', 0, async (done: Function) => {
      let manager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      manager.addFloatContainerSession(session1);
      manager.addFloatContainerSession(session2);
      manager.removeFloatContainerSessionByIndex(1);
      manager.removeFloatContainerSessionByIndex(1);
      done();
    });

    it('removeFloatContainerSessionTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      scbScenePanelManager.removeFloatContainerSession(null);
      expect(scbScenePanelManager !== undefined).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('raiseSceneToTopTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('raiseSceneToTopBundle', 'raiseSceneToTopModule', 'raiseSceneToTopAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelManager.raiseSceneToTop(session);
      expect(scbScenePanelManager.getSceneContainerSessionList().length).assertEqual(0);
      done();
    });

    it('raiseSceneToTopTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('raiseSceneToTopBundle', 'raiseSceneToTopModule', 'raiseSceneToTopAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSessionList.push(session1);
      scbScenePanelManager['containerSessionList'] = containerSessionList;
      scbScenePanelManager.raiseSceneToTop(session1);
      expect(scbScenePanelManager.getSceneContainerSessionList().length).assertEqual(1);
      done();
    });

    it('raiseSceneToTopTest03', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('raiseSceneToTopBundle', 'raiseSceneToTopModule', 'raiseSceneToTopAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let sceneInfo2 = new SCBSceneInfo('raiseSceneToTop2Bundle', 'raiseSceneToTop2Module', 'raiseSceneToTop2Ability');
      let sceneSession2 = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty());

      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSessionList.push(session1);
      containerSessionList.push(session2);
      scbScenePanelManager['containerSessionList'] = containerSessionList;
      scbScenePanelManager.raiseSceneToTop(session1);
      expect(scbScenePanelManager.getSceneContainerSessionList().length).assertEqual(2);
      done();
    });

    it('raiseFloatingSceneToTopTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelManager.raiseFloatingSceneToTop(session);
      expect(scbScenePanelManager.getSceneContainerSessionList().length).assertEqual(0);
      done();
    });

    it('raiseFloatingSceneToTopTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      scbScenePanelManager.raiseFloatingSceneToTop(session);
      expect(scbScenePanelManager.getSceneContainerSessionList().length).assertEqual(0);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('raiseFloatingSceneToTopTest03', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      session.isFloat = true;
      scbScenePanelManager.raiseFloatingSceneToTop(session);
      expect(scbScenePanelManager.getSceneContainerSessionList().length).assertEqual(0);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('raiseFloatingSceneToTopTest04', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      session.isFloat = true;
      scbScenePanelManager.raiseFloatingSceneToTop(session);
      expect(scbScenePanelManager.getFloatingSessionList().length).assertEqual(0);
      done();
    });

    it('raiseFloatingSceneToTopTest05', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      session1.isFloat = true;
      scbScenePanelManager.addFloatContainerSession(session1);
      scbScenePanelManager.raiseFloatingSceneToTop(session1);
      expect(scbScenePanelManager.getFloatingSessionList().length).assertEqual(1);
      done();
    });

    it('raiseFloatingSceneToTopTest06', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      session1.isFloat = true;

      let sceneInfo2 = new SCBSceneInfo('test2Bundle', 'test2Module', 'test2Ability');
      let sceneSession2 = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty());
      scbScenePanelManager.addFloatContainerSession(session1);
      scbScenePanelManager.addFloatContainerSession(session2);
      scbScenePanelManager.raiseFloatingSceneToTop(session1);
      expect(scbScenePanelManager.getFloatingSessionList().length).assertEqual(2);
      done();
    });

    it('onBlurTransitionActiveTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      scbScenePanelManager.onBlurTransitionActive(2, '#00000000');
      let backgroundBlurSession: SCBBackgroundBlurSession =
        scbScenePanelManager.getBackgroundBlurSession();
      expect(backgroundBlurSession.bgBlurScale).assertEqual(2);
      done();
    });

    it('onBlurTransitionActiveTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      scbScenePanelManager.setForegroundBlurActive(true);
      scbScenePanelManager.onBlurTransitionActive(2, '#00000000');
      let backgroundBlurSession: SCBBackgroundBlurSession =
        scbScenePanelManager.getBackgroundBlurSession();
      expect(backgroundBlurSession.bgBlurScale).assertEqual(0);
      done();
    });

    it('onBlurTransitionFinishTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      ReflectionUtils.setProperty(scbScenePanelManager,
        'blurComponentTransitionCount', 3);
      scbScenePanelManager.onBlurTransitionFinish(1);
      expect(ReflectionUtils.getProperty(scbScenePanelManager,
        'blurComponentTransitionCount')).assertEqual(3);
      done();
    });

    it('onBlurTransitionFinishTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      ReflectionUtils.setProperty(scbScenePanelManager,
        'blurComponentTransitionCount', 2);
      scbScenePanelManager.onBlurTransitionFinish(2);
      expect(ReflectionUtils.getProperty(scbScenePanelManager,
        'blurComponentTransitionCount')).assertEqual(0);
      done();
    });
  });
}