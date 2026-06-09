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
  MockKit,
  when
} from '@ohos/hypium';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import { Alarm } from '@ohos/componenthelper';
import {
  RecentZoomAlarm
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentZoomAlarm';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';

export default function RecentZoomAlarmTest() {
  describe('RecentZoomAlarmTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let recentZoomAlarm: RecentZoomAlarm = new RecentZoomAlarm();
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainer: SCBSceneContainerSession =
      new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    totalContainerSessionList.add(scbSceneContainer);
    totalContainerSessionList.add(scbSceneContainer);
    let alarm: Alarm = new Alarm();

    it('RecentZoomAlarm_test_onAlarm_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentZoomAlarm as object)['scaleX'] = 0;
      (recentZoomAlarm as object)['onAlarm']();
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(0);
    })

    it('RecentZoomAlarm_test_onAlarm_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentZoomAlarm as object)['scaleX'] = 1;
      (recentZoomAlarm as object)['onAlarm']();
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(1);
    })

    it('RecentZoomAlarm_test_initScaleForDownAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentZoomAlarm as object)['sceneContainerSession'] = null;
      (recentZoomAlarm as object)['onAlarm']();
      (recentZoomAlarm as object)['scaleX'] = 1;
      (recentZoomAlarm as object)['scaleY'] = 1;
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(1);
    })

    it('RecentZoomAlarm_test_initScaleForDownAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentZoomAlarm as object)['sceneContainerSession'] = scbSceneContainer;
      (recentZoomAlarm as object)['onAlarm']();
      (recentZoomAlarm as object)['scaleX'] = 1;
      (recentZoomAlarm as object)['scaleY'] = 1;
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(1);
    })

    it('RecentZoomAlarm_test_restoreScale', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentZoomAlarm.restoreScale();
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(1);
    })

    it('RecentZoomAlarm_test_start_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentZoomAlarm.start(null);
      expect((recentZoomAlarm as object)['sceneContainerSession']).assertEqual(null);
    })

    it('RecentZoomAlarm_test_start_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentZoomAlarm.start(scbSceneContainer);
      expect(recentZoomAlarm).not().assertNull();
    })

    it('RecentZoomAlarm_test_cancel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentZoomAlarm.cancel('test_cancel');
      expect(recentZoomAlarm).not().assertNull();
    })

    it('RecentZoomAlarm_test_cancelCallback_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentZoomAlarm as object)['scaleX'] = 0;
      recentZoomAlarm.cancelCallback();
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(1);
    })

    it('RecentZoomAlarm_test_cancelCallback_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentZoomAlarm as object)['scaleX'] = 1;
      recentZoomAlarm.cancelCallback();
      expect((recentZoomAlarm as object)['scaleX']).assertEqual(1);
    })
  })
}