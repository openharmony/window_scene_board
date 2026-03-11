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
} from '@ohos/hypium';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  ScenePanelState
} from '@ohos/windowscene';
import { Alarm } from '@ohos/componenthelper';
import {
  RecentDockRefreshAlarm
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDockRefreshAlarm';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function RecentDockRefreshAlarmTest() {
  describe('RecentDockRefreshAlarmTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let recentDockRefreshAlarm: RecentDockRefreshAlarm = new RecentDockRefreshAlarm();
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneContainer: SCBSceneContainerSession =
      new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let alarm: Alarm = new Alarm();

    it('RecentDockRefreshAlarm_test_start_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentDockRefreshAlarm.start(scbSceneContainer, ScenePanelState.RECENT);
      expect(recentDockRefreshAlarm).not().assertNull();
    })

    it('RecentDockRefreshAlarm_test_start_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentDockRefreshAlarm.start(scbSceneContainer, ScenePanelState.HOME);
      expect(recentDockRefreshAlarm).not().assertNull();
    })

    it('RecentDockRefreshAlarm_test_onAlarm_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentDockRefreshAlarm.start(scbSceneContainer, ScenePanelState.RECENT);
      recentDockRefreshAlarm.onAlarm();
      expect(recentDockRefreshAlarm).not().assertNull();
    })

    it('RecentDockRefreshAlarm_test_onAlarm_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentDockRefreshAlarm as object)['containerSession'] = null;
      expect(recentDockRefreshAlarm).not().assertNull();
    })
  })
}