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
import {
  GestureDockEventIdUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/GestureDockEventIdUtil';
import { GestureDockItemInfo } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import {
  GestureDockConstants
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';

export default function GestureDockEventIdUtilTest() {

  describe('GestureDockEventIdUtilTest', () => {
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

    it('GestureDockEventldUtil_getStartSqueezeEventId', 0, () => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'test';
      itemInfo.appIndex = 1;
      GestureDockEventIdUtil.getStartSqueezeEventId(itemInfo);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getDockItemVisibleEventId', 0, () => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'test';
      itemInfo.appIndex = 1;
      GestureDockEventIdUtil.getDockItemVisibleEventId(itemInfo);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getDockItemVisibleEventId_01', 0, () => {
      GestureDockEventIdUtil.getDockItemVisibleEventId(undefined);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getDockItemDropEventId', 0, () => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'test';
      itemInfo.appIndex = 1;
      GestureDockEventIdUtil.getDockItemDropEventId(itemInfo);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getAllAppsGrayEventId', 0, () => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'test';
      itemInfo.appIndex = 1;
      GestureDockEventIdUtil.getAllAppsGrayEventId(itemInfo);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getAllAppsGrayEventIdByString', 0, () => {
      GestureDockEventIdUtil.getAllAppsGrayEventIdByString('test', 1);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getSnapShotItemId', 0, () => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'test';
      itemInfo.appIndex = 1;
      GestureDockEventIdUtil.getSnapShotItemId(itemInfo, 100);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

    it('GestureDockEventldUtil_getResidentLayoutAppTag', 0, () => {
      let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      itemInfo.bundleName = 'test';
      itemInfo.appIndex = 1;
      GestureDockEventIdUtil.getResidentLayoutAppTag(itemInfo);
      expect(GestureDockEventIdUtil).not().assertUndefined();
    })

  })
}