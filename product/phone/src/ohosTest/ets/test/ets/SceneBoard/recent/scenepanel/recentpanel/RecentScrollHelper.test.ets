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
  FSM,
  SCBScenePanelManager,
  SCBScreenProperty
} from '@ohos/windowscene';
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
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import { RecentScrollHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollHelper';
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import { GestureHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';

export default function RecentScrollHelperTest() {
  let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenProp: screenSessionManager.ScreenProperty = {
    rotation: 1,
    bounds: {
      left: 1,
      top: 1,
      width: 1,
      height: 1,
      radius: 1,
    },
    fakeBounds: {
      left: 0,
      top: 0,
      width: 0,
      height: 0,
      radius: 0
    },
    isFakeInUse: false,
    rsId: 0,
  };
  scbScreenProperty.update(screenProp);
  let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
  let recentScrollHelper: RecentScrollHelper = new RecentScrollHelper('RecentScrollFollowing');

  let eventArea: Area = {
    width: 0,
    height: 0,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
  };

  let eventTarget: EventTarget = {
    area: eventArea
  };

  let event: GestureEvent = {
    target: eventTarget,
    timestamp: 0,
    source: 0,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 0,
    repeat: false,
    fingerList: [],
    offsetX: 0,
    offsetY: 0,
    angle: 0,
    speed: 0,
    scale: 0,
    pinchCenterX: 0,
    pinchCenterY: 0,
    velocityX: 0,
    velocityY: 0,
    velocity: 0
  };

  describe('RecentScrollHelperTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('invoke_test01', 0, (): void => {
      (RecentScrollHelper as object)['preTimestamp'] = 0;
      recentScrollHelper.invoke(1, 2);
      expect(recentScrollHelper).not().assertUndefined();

      (RecentScrollHelper as object)['preTimestamp'] = 1;
      recentScrollHelper.invoke(1, 2);
      expect(recentScrollHelper).not().assertUndefined();
    })

    it('doAbnormalTimestamp_test01', 0, (): void => {
      (recentScrollHelper as object)['preTimestamp'] = 5;
      (recentScrollHelper as object)['oneFrameMaxTime'] = 5;
      (recentScrollHelper as object)['doAbnormalTimestamp'](2, 20);
      expect(recentScrollHelper).not().assertUndefined();

      (recentScrollHelper as object)['abnormalTimestamp'] = 5;
      (recentScrollHelper as object)['doAbnormalTimestamp'](2, 20);
      expect(recentScrollHelper).not().assertUndefined();
    })


    it('calcSpeed_test_01', 0, (): void => {
      (recentScrollHelper as object)['calcSpeed'](1, 0);
      expect(recentScrollHelper).not().assertUndefined();

      (recentScrollHelper as object)['calcSpeed'](1, 1);
      expect(recentScrollHelper).not().assertUndefined();
    })
  })
}