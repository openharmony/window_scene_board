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
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
  SCBSceneInfo,
  SCBScreenProperty} from '@ohos/windowscene';

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, TestType, Size, Level } from '@ohos/hypium';
import { RecentPanelController } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentPanelController';
import {
  RecentPanelSession
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentPanelSession';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function RecentPanelControllerTest() {
  describe('RecentPanelControllerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
    let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let sessionList = new SCBSceneContainerSessionArray();
    let session = new RecentPanelSession(sessionList);
    let recentPanelController = new RecentPanelController(session);

    it('removePendingSessionIfNeedTest_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentPanelController.removePendingSessionIfNeed();
      expect(recentPanelController).not().assertNull();
    })

    it('removePendingSessionIfNeedTest_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentPanelController2 = new RecentPanelController(session);
      sceneContainerSession.sessionData.pendingRemove = true;
      recentPanelController2.scenePanelSessionList.push(sceneContainerSession);
      recentPanelController2.removePendingSessionIfNeed();
      expect(recentPanelController).not().assertNull();
    })

    it('removePendingSessionIfNeedTest_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentPanelController3 = new RecentPanelController(session);
      sceneContainerSession.sessionData.pendingRemove = false;
      recentPanelController3.scenePanelSessionList.push(sceneContainerSession);
      recentPanelController3.removePendingSessionIfNeed();
      expect(recentPanelController).not().assertNull();
    })
  })
}