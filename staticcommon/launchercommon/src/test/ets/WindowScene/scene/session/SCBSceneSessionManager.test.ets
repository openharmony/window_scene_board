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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { Log } from '@ohos/basicutils';
import {
  SCBEventId,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG: string = 'SCBSceneSessionManagerTest';

export function SCBSceneSessionManagerTest() {
  describe('SCBSceneSessionManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterAll(() => {
    })
    afterEach(() => {
    })
    it('fullToFloatingTest', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('fullToFloatingTestBundle', 'fullToFloatingTestModule', 'fullToFloatingTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      SCBSceneSessionManager.getInstance().on(SCBEventId.FULL_TO_FLOATING, screenId, (session: SCBSceneSession) => {
        Log.showInfo(TAG, 'fullToFloatingTest, FULL_TO_FLOATING callback called!');
      })
      SCBSceneSessionManager.getInstance().fullToFloating(screenId, scbContainerSession);
    })

    it('floatingToFullTest', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('floatingToFullTestBundle', 'floatingToFullTestModule', 'floatingToFullTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance().on(SCBEventId.FULL_TO_FLOATING, screenId, (session: SCBSceneSession) => {
        Log.showInfo(TAG, 'floatingToFullTest, FULL_TO_FLOATING callback called!')
      })
      SCBSceneSessionManager.getInstance().floatingToFull(screenId, scbSceneSession);
    })

    it('floatingDragToFullTest', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('floatingDragToFullTestBundle', 'floatingDragToFullTestModule', 'floatingDragToFullTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance().on(SCBEventId.FLOATING_TO_FULL_BY_DRAG, screenId, (session: SCBSceneSession) => {
        Log.showInfo(TAG, 'floatingDragToFullTest, FLOATING_TO_FULL_BY_DRAG callback called!')
      })
      expect(SCBSceneSessionManager.getInstance().floatingDragToFull(screenId, scbSceneSession)).not().assertFail();
    })

    it('floatingToFullBackgroundTest', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('floatingToFullBackgroundTestBundle', 'floatingToFullBackgroundTestModule', 'floatingToFullBackgroundTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance()
        .on(SCBEventId.FLOATING_TO_FULL_BACKGROUND, screenId, (session: SCBSceneSession) => {
          Log.showInfo(TAG, 'floatingToFullBackgroundTest, FLOATING_TO_FULL_BACKGROUND callback called!')
        })
      SCBSceneSessionManager.getInstance().floatingToFullBackground(screenId, scbSceneSession);
    })

    it('setFloatingScaleTest', 0, () => {
      let floatingScale: number = 0.5;
      sceneSessionManager.setFloatingScale(floatingScale);
    })

    it('moveFloatingToBackgroundIfNeeded', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('floatingToBackgroundTestBundle', 'floatingToBackgroundTestModule', 'floatingToBackgroundTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance().on(SCBEventId.FLOATING_TO_BACKGROUND, screenId, (session: SCBSceneSession) => {
        Log.showInfo(TAG, 'floatingToBackgroundTest, FLOATING_TO_BACKGROUND callback called!')
      })
      expect(SCBSceneSessionManager.getInstance().moveFloatingToBackgroundIfNeeded(screenId, scbSceneSession)).not().assertFail();
    })

    it('getFloFocusedCallBack', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('getFloFocusedCallBack', 'getFloFocusedCallBackTestModule', 'getFloFocusedCallBackTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance().registerrequestFocusCallbacks((): void => {
        Log.showInfo(TAG, 'getFloFocusedCallBackTest, FLOATING_REQUESTFOCUS callback called!')
      });
      expect(SCBSceneSessionManager.getInstance().requestFocus(scbSceneSession.sceneInfo.persistentId, true)).not().assertFail();
    })

    it('sceneOnRecover', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('sceneOnRecover', 'sceneOnRecoverTestModule', 'sceneOnRecoverTestAbility');
      SCBSceneSessionManager.getInstance()
        .on(SCBEventId.SESSION_RECOVER, screenId, () => {
          Log.showInfo(TAG, 'sceneOnRecover, SESSION_RECOVER callback called!');
        })
      SCBSceneSessionManager.getInstance().processRecover(screenId, sceneInfo.persistentId);
    })

    it('minimizeAllFloatingScene', 0, () => {
      let screenId: number = 0;
      SCBSceneSessionManager.getInstance()
        .on(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, screenId, () => {
          Log.showInfo(TAG, 'minimizeAllFloatingScene, MINIMIZE_ALL_FLOATING_SCENE callback called!');
        })
      SCBSceneSessionManager.getInstance().minimizeAllFloatingScene(screenId);
    })

    it('removeFloatingSceneSession', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('removeFloatingSceneSessionTestBundle', 'removeFloatingSceneSessionTestModule', 'removeFloatingSceneSessionTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance()
        .on(SCBEventId.REMOVE_FLOATING_SCENE, screenId, () => {
          Log.showInfo(TAG, 'removeFloatingSceneSession, REMOVE_FLOATING_SCENE callback called!');
        })
      SCBSceneSessionManager.getInstance().removeFloatingSceneSession(screenId, scbSceneSession);
    })

    it('floatingScenePanelRotation', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('floatingScenePanelRotationTestBundle', 'floatingScenePanelRotationTestModule', 'floatingScenePanelRotationTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance()
        .on(SCBEventId.FLOATING_SCENE_PANEL_ROTATION, screenId, () => {
          Log.showInfo(TAG, 'floatingScenePanelRotation, FLOATING_SCENE_PANEL_ROTATION callback called!');
        })
      SCBSceneSessionManager.getInstance().requestFloatingScenePanelRotation(SCBEventId.FLOATING_SCENE_PANEL_ROTATION, scbSceneSession.sceneInfo.screenId);
    })

    it('moveNotificationToFloating', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('floatingToBackgroundTestBundle', 'floatingToBackgroundTestModule', 'floatingToBackgroundTestAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBSceneSessionManager.getInstance().on(SCBEventId.NOTIFICATION_TO_FLOATING, screenId, (session: SCBSceneSession) => {
        Log.showInfo(TAG, 'notificationToFloatingTest, FLOATING_TO_BACKGROUND callback called!')
      })
      expect(SCBSceneSessionManager.getInstance().moveNotificationToFloating(screenId, scbSceneSession)).not().assertFail();
    })

    it('pairSplitFromDock', 0, () => {
      let screenId: number = 0;
      let locationX: number = 0;
      let locationY: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('sceneOnRecover', 'sceneOnRecoverTestModule', 'sceneOnRecoverTestAbility');
      SCBSceneSessionManager.getInstance()
        .on(SCBEventId.PAIR_SPLIT_FROM_DOCK, screenId, () => {
          Log.showInfo(TAG, 'pairSplitFromDock, PAIR_SPLIT_FROM_DOCK callback called!');
        })
      SCBSceneSessionManager.getInstance().pairSplitFromDock(locationX, locationY, sceneInfo);
    })

    it('moveAppDockToFloating', 0, () => {
      let screenId: number = 0;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('appDockToFloatingTestBundle', 'appDockToFloatingTestModule', 'appDockToFloatingTestAbility');
      SCBSceneSessionManager.getInstance().on(SCBEventId.START_FLOAT_FROM_DOCK, screenId, (session: SCBSceneSession) => {
        Log.showInfo(TAG, 'moveAppDockToFloatingTest, START_FLOAT_FROM_DOCK callback called!')
      })
      expect(SCBSceneSessionManager.getInstance().startFloatFromDock(sceneInfo)).not().assertFail();
    })

    it('startSceneFromPiP', 0, () => {
      SCBSceneSessionManager.getInstance().onShow(null);
      SCBSceneSessionManager.getInstance().startSceneFromPiP(10);
      SCBSceneSessionManager.getInstance().onShow((persistentId: number): void => {
        Log.showInfo(TAG, `startSceneFromPiPTest onShow persistentId:${persistentId}`);
      });
      SCBSceneSessionManager.getInstance().startSceneFromPiP(10);
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    })

    it('clearActiveSessionList', 0, () => {
      SCBSceneSessionManager.getInstance().addActiveSessionList(233);
      SCBSceneSessionManager.getInstance().clearActiveSessionList();
      expect(SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty()).assertTrue();
    })
  })
}