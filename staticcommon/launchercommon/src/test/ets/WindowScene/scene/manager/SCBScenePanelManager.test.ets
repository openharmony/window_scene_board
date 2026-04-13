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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import SceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene/src/main/ets/TsIndex';

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

    // 测试容器session集合清空数据
    it('clearSceneContainerSessionList', DEFAULT_ATTR, () => {
      let mgr = new SCBScenePanelManager();
      let session = getContainerSession();
      mgr.addSceneContainerSession(session);
      expect(mgr.getSceneContainerSessionList().length).assertEqual(1);
      mgr.clearSceneContainerSessionList();
      expect(mgr.getSceneContainerSessionList().length).assertEqual(0);
    });

    // 测试非多任务显示session集，非null表示正常获取
    it('getNotShowRecentList', DEFAULT_ATTR, () => {
      let mgr = new SCBScenePanelManager();
      expect(mgr.getNotShowRecentList() !== null).assertTrue()
    });

    // 测试容器session集添加item，异常item集合length不增长，正常item集合length增长
    it('addSceneContainerSession', DEFAULT_ATTR, () => {
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
  });
}