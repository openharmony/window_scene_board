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
import { RecentViewParam } from '../../../../../../../main/ets/recent/RecentViewParam';
import { SCBBackgroundBlurSession, SCBScenePanelSession } from '../../../../../../../main/ets/scene/manager/SCBScenePanelSession';
import { SCBSceneContainerSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { SCBSceneSessionManager } from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { CommonUtils } from '@ohos/basicutils';
import { SCBFloatingParam } from '../../../../../../../main/ets/scene/session/SCBFloatingParam';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const DEFAULT_ATTR = 0;

function getContainerSession(): SCBSceneContainerSession {
  let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let session = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
  return session;
}

/**
 * panel面板状态管理测试
 */
interface GeneratedObjectLiteralInterface_1 {
  panelType: string;
}

export function SCBScenePanelManagerTest() {
  describe('SCBScenePanelManagerTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    // 测试获取容器session集，非null表示正常获取
    it('getSceneContainerSessionList', DEFAULT_ATTR, () => {
      let mgr = new SCBScenePanelManager();
      expect(mgr.getSceneContainerSessionList() !== null).assertTrue()
    });

    // 测试非多任务显示session集，非null表示正常获取
    it('getNotShowRecentList', DEFAULT_ATTR, () => {
      let mgr = new SCBScenePanelManager();
      expect(mgr.getNotShowRecentList() !== null).assertTrue()
    });

    // 测试容器session集添加item，异常item集合length不增长，正常item集合length增长
    it('addSceneContainerSession', 0, () => {
      let mgr = new SCBScenePanelManager();
      mgr.addSceneContainerSession(null);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(0);
      let session = getContainerSession();
      mgr.addSceneContainerSession(session);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(1);
    });

    // 测试容器session移除item
    it('removeSceneContainerSession', DEFAULT_ATTR, () => {
      let mgr = new SCBScenePanelManager();
      let session = getContainerSession();
      mgr.addSceneContainerSession(session);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(1);
      mgr.removeSceneContainerSession(session);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(0);
    });

    it('getInstanceTest01', 0, () => {
      let instance1 = SCBScenePanelManager.getInstance();
      let instance2 = SCBScenePanelManager.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('getInstanceTest02', 0, () => {
      let screenProperty = new SCBScreenProperty();
      screenProperty.init();
      let instance1 = SCBScenePanelManager.getInstance(screenProperty);
      let instance2 = SCBScenePanelManager.getInstance(screenProperty);
      expect(instance1).assertEqual(instance2);
    });

    it('init01', 0, () => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let panelParam: SCBPanelParam = {};
      scbScenePanelManager.init(panelParam);
    });

    it('init02', 0, () => {
      let scbScenePanelManager = new SCBScenePanelManager();
      scbScenePanelManager.init();
    });

    it('getScreenPropertyTest02', 0, async (done: Function) => {
      let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      const result = scbScenePanelManager.getScreenProperty();
      expect(result).not().assertNull();
      done();
    });

    it('getViewParamTest01', 0, async (done: Function) => {
      let scbScenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let screenProperty = new SCBScreenProperty();
      let mockViewParam: RecentViewParam = new RecentViewParam(screenProperty);
      scbScenePanelManager['viewParam'] = mockViewParam;
      const result = scbScenePanelManager.getViewParam();
      expect(result).assertDeepEquals(mockViewParam);
      done();
    });

    it('getPanelSessionTest', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let result = scbScenePanelManager.getPanelSession();
      expect(result).not().assertNull();
      done();
    });

    it('getBackgroundBlurSessionTest', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockBackgroundBlurSession: SCBBackgroundBlurSession = new SCBBackgroundBlurSession();
      scbScenePanelManager['backgroundBlurSession'] = mockBackgroundBlurSession;
      const result = scbScenePanelManager.getBackgroundBlurSession();
      expect(result).assertDeepEquals(mockBackgroundBlurSession);
      done();
    });

    it('getSceneContainerSessionListTest', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      scbScenePanelManager['containerSessionList'] = mockContainerSessionList;
      const result = scbScenePanelManager.getSceneContainerSessionList();
      expect(result).assertDeepEquals(mockContainerSessionList);
      done();
    });

    it('setSceneContainerSessionListForView', DEFAULT_ATTR, () => {
      let mgr = new SCBScenePanelManager();
      let session = getContainerSession();
      mgr.addSceneContainerSession(session);
      mgr.setSceneContainerSessionListForView(mgr.getSceneContainerSessionList());
      expect(mgr).not().assertNull();
    });

    it('getFloatingSessionListTest', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockFloatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      scbScenePanelManager['floatingSessionList'] = mockFloatingSessionList;
      const result = scbScenePanelManager.getFloatingSessionList();
      expect(result).assertDeepEquals(mockFloatingSessionList);
      done();
    });

    it('getNotShowRecentListTest', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockSCBSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      scbScenePanelManager['containerSessionListNotShowRecent'] = mockSCBSceneContainerSessionArray;
      const result = scbScenePanelManager.getNotShowRecentList();
      expect(result).assertDeepEquals(mockSCBSceneContainerSessionArray);
      done();
    });

    it('getTotalSessionListIncludeNotShowRecentTest', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockContainerSessionList =
        mocker.mockFunc(scbScenePanelManager, scbScenePanelManager.getSceneContainerSessionList);
      let mockFloatingSessionList = mocker.mockFunc(scbScenePanelManager, scbScenePanelManager.getFloatingSessionList);
      let mockNotShowRecentList = mocker.mockFunc(scbScenePanelManager, scbScenePanelManager.getNotShowRecentList);
      when(mockContainerSessionList)().afterReturn(new SCBSceneContainerSessionArray());
      when(mockFloatingSessionList)().afterReturn(new SCBSceneContainerSessionArray());
      when(mockNotShowRecentList)().afterReturn(new SCBSceneContainerSessionArray());

      const result = scbScenePanelManager.getTotalSessionListIncludeNotShowRecent();
      expect(result).assertDeepEquals(new SCBSceneContainerSessionArray());
      done();
    });

    it('addFloatContainerSessionTest01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let refreshMock = mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      when(refreshMock)().afterReturn({
        refreshZOrder: () => {
        }
      });
      manager.addFloatContainerSession(session);
      mocker.verify('getInstance', []).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('addFloatContainerSessionTest02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager = new SCBScenePanelManager();
      let refreshMock = mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      when(refreshMock)().afterReturn({
        refreshZOrder: () => {
        }
      });
      manager.addFloatContainerSession(null);
      mocker.verify('getInstance', []).never();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('should_log_info_when_list_is_empty', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      expect(scbScenePanelManager).not().assertNull();
      scbScenePanelManager.addSceneContainerSessionByList(new Array<SCBSceneContainerSession>());
      done();
    });

    it('addSceneContainerSessionByListTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockGetTopActiveSession =
        mocker.mockFunc(scbScenePanelManager, scbScenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      when(mockGetTopActiveSession)().afterReturn(false);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let sessionList: Array<SCBSceneContainerSession> = [];
      sessionList.push(session1);
      sessionList.push(session2);

      scbScenePanelManager.addSceneContainerSessionByList(sessionList);
      mocker.ignoreMock(scbScenePanelManager, scbScenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      done();
    });

    it('addSceneContainerSessionByListTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockGetTopActiveSession =
        mocker.mockFunc(scbScenePanelManager, scbScenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      when(mockGetTopActiveSession)().afterReturn(true);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let sessionList: Array<SCBSceneContainerSession> = [];
      sessionList.push(session1);
      sessionList.push(session2);

      scbScenePanelManager.addSceneContainerSessionByList(sessionList);
      mocker.ignoreMock(scbScenePanelManager, scbScenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      done();
    });

    it('removeSceneContainerSessionTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockCommonUtils = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockCommonUtils)(ArgumentMatchers.any).afterReturn(true);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelManager.removeSceneContainerSession(session);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('removeSceneContainerSessionTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockCommonUtils = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockCommonUtils)(ArgumentMatchers.any).afterReturn(false);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelManager.removeSceneContainerSession(session);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('removeFloatSceneContainerSessionTest01', 0, async (done: Function) => {
      let manager = new SCBScenePanelManager();
      expect(manager != null).assertTrue();
      manager.removeFloatSceneContainerSession(null);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      floatingSessionList.push(session);
      manager['floatingSessionList'] = floatingSessionList;
      manager.removeFloatSceneContainerSession(session);
      done();
    });

    it('removeFloatSceneContainerSessionTest02', 0, async (done: Function) => {
      let manager = new SCBScenePanelManager();
      expect(manager != null).assertTrue();
      manager.removeFloatSceneContainerSession(null);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      manager.removeFloatSceneContainerSession(session);
      done();
    });

    it('removeContainerSessionByIndexTest01', 0, async (done: Function) => {
      let manager = new SCBScenePanelManager();
      expect(manager != null).assertTrue();
      manager.removeFloatSceneContainerSession(null);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSessionList.push(session1);
      containerSessionList.push(session2);
      manager['containerSessionList'] = containerSessionList;
      manager.removeContainerSessionByIndex(1);
      manager.removeContainerSessionByIndex(1);
      done();
    });

    it('removeContainerSessionByIndexTest02', 0, async (done: Function) => {
      let manager = new SCBScenePanelManager();
      expect(manager != null).assertTrue();
      manager.removeFloatSceneContainerSession(null);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      floatingSessionList.push(session1);
      floatingSessionList.push(session2);
      manager['floatingSessionList'] = floatingSessionList;
      manager.removeContainerSessionByIndex(1);
      manager.removeContainerSessionByIndex(1);
      done();
    });

    it('removeFloatContainerSessionTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      scbScenePanelManager.removeFloatContainerSession(session);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('removeFloatContainerSessionTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      floatingSessionList.push(session1);
      floatingSessionList.push(session2);
      scbScenePanelManager['floatingSessionList'] = floatingSessionList;
      scbScenePanelManager.removeFloatContainerSession(session1);
      scbScenePanelManager.removeFloatContainerSession(session1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('removeNotShowRecentSessionTest01', 0, async (done: Function) => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let manager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      expect(manager != null).assertTrue();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      manager.removeNotShowRecentSession(session);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    });

    it('removeNotShowRecentSessionTest02', 0, async (done: Function) => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let manager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      manager.removeNotShowRecentSession(session);
      done();
    });

    it('getActiveFloatContainerListTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(scbScenePanelManager, scbScenePanelManager.getFloatingSessionList);
      when(mockFunc)().afterReturn(new SCBSceneContainerSessionArray());
      const result = scbScenePanelManager.getActiveFloatContainerList(false);
      expect(result.length).assertEqual(0);
      mocker.ignoreMock(scbScenePanelManager, scbScenePanelManager.getFloatingSessionList);
      done();
    });

    it('getActiveFloatContainerListTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let mocker: MockKit = new MockKit();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session4: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      session2.setActivationAtToggleHomeScenario();
      session3.setActivationAtToggleHomeScenario();
      session4.setActivationAtToggleHomeScenario();
      session2.floatingParam = new SCBFloatingParam();
      session3.floatingParam = new SCBFloatingParam();
      session4.floatingParam = new SCBFloatingParam();
      session3.floatingParam.isMinimized = true;
      session4.floatingParam.isMinimized = true;
      session4.floatingParam.isClosed = true;

      scbScenePanelManager.addFloatContainerSession(session1);
      scbScenePanelManager.addFloatContainerSession(session2);
      scbScenePanelManager.addFloatContainerSession(session3);
      scbScenePanelManager.addFloatContainerSession(session4);
      let result = scbScenePanelManager.getActiveFloatContainerList(false);
      result = scbScenePanelManager.getActiveFloatContainerList(true);
      expect(result.length).assertEqual(1);
      done();
    });

    it('should_return_null_when_floatingSessionList_is_empty', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      const result = scbScenePanelManager.getTopActiveSceneSessionArray();
      expect(result).assertNull();
      done();
    });

    it('getTopActiveSceneSessionArrayTest01', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session4: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      session2.setActivationAtToggleHomeScenario();
      session3.setActivationAtToggleHomeScenario();
      session4.setActivationAtToggleHomeScenario();
      session2.floatingParam = new SCBFloatingParam();
      session3.floatingParam = new SCBFloatingParam();
      session4.floatingParam = new SCBFloatingParam();
      session3.floatingParam.isMinimized = true;
      session4.floatingParam.isMinimized = true;
      session4.floatingParam.isClosed = true;

      scbScenePanelManager.addFloatContainerSession(session1);
      scbScenePanelManager.addFloatContainerSession(session2);
      scbScenePanelManager.addFloatContainerSession(session3);
      scbScenePanelManager.addFloatContainerSession(session4);
      let result = scbScenePanelManager.getTopActiveSceneSessionArray();

      expect(result).not().assertNull();
      done();
    });

    it('getTopActiveSceneSessionArrayTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      session2.setActivationAtToggleHomeScenario();
      session3.setActivationAtToggleHomeScenario();
      session1.floatingParam = new SCBFloatingParam();
      session2.floatingParam = new SCBFloatingParam();
      session3.floatingParam = new SCBFloatingParam();
      session2.floatingParam.isMinimized = true;
      session3.floatingParam.isMinimized = true;
      session3.floatingParam.isClosed = true;

      scbScenePanelManager.addFloatContainerSession(session1);
      scbScenePanelManager.addFloatContainerSession(session2);
      scbScenePanelManager.addFloatContainerSession(session3);
      let result = scbScenePanelManager.getTopActiveSceneSessionArray();

      expect(result).assertNull();
      done();
    });

    it('getTopActiveSceneSessionArrayTest02', 0, async (done: Function) => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let session2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      session2.setActivationAtToggleHomeScenario();
      session1.floatingParam = new SCBFloatingParam();
      session2.floatingParam = new SCBFloatingParam();

      scbScenePanelManager.addFloatContainerSession(session1);
      scbScenePanelManager.addFloatContainerSession(session2);
      let result = scbScenePanelManager.getTopActiveSceneSessionArray();

      expect(result).not().assertEqual(null);
      done();
    });

    it('getParentSessionWithScreenIdTest_01', 0, () => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let testParentId = -1;
      let testScreenId = undefined;
      let result = scbScenePanelManager.getParentSessionWithScreenId(testParentId, testScreenId);
      expect(result).assertNull();
    });
    it('getParentSessionWithScreenIdTest_02', 0, () => {
      let scbScenePanelManager = new SCBScenePanelManager();
      let testParentId = 999;
      let testScreenId: number = 999;
      let result = scbScenePanelManager.getParentSessionWithScreenId(testParentId, testScreenId);
      expect(result).assertNull();
    });

  });
}