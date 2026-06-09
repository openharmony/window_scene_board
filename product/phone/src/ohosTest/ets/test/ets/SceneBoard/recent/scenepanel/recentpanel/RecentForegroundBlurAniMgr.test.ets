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
} from '@ohos/hypium';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  RecentForegroundBlurAniMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentForegroundBlurAniMgr';

export default function RecentForegroundBlurAniMgrTest() {
  describe('RecentForegroundBlurAniMgrTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());

    it('RecentForegroundBlurAniMgr_test_init_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentForegroundBlurAniMgr.getInstance().isForegroundEffectSupport();
      RecentForegroundBlurAniMgr.getInstance().updateFoldExpandStatus(false);
      RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(scbSceneContainer, 20, false);
      expect(scbSceneContainer?.needRenderBlurRadius.blurRadius).assertEqual(20);
      RecentForegroundBlurAniMgr.getInstance().stopForegroundBlurAnimation(scbSceneContainer);
      expect(scbSceneContainer?.needRenderBlurRadius.blurRadius).assertEqual(-1);
    })
  })
}