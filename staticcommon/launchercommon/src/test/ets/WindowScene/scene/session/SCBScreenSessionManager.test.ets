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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'
import { SCBScreenSessionArray, SCBScreenSessionManager, SCBScreenProperty } from '@ohos/windowscene';

export function SCBScreenSessionManagerTest() {
  let screenSession = SCBScreenSessionManager.getInstance();
  screenSession.init();

  describe('SCBScreenSessionManagerTest', function () {
    beforeAll(function () {

    })
    beforeEach(function () {

    })
    afterEach(function () {

    })
    afterAll(function () {

    })
    it('SCBScreenSessionManagerTest_assertEqual', TestType.USER | Size.SMALLTEST | Level.LEVEL0, function () {
       let a = 'a';
      expect('a').assertEqual(a);
    })
    it('screenSessionList1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, function () {
      let list: SCBScreenSessionArray = new SCBScreenSessionArray();
      screenSession.setScreenSessionList(list);
      expect(list).assertEqual(screenSession.getScreenSessionList());
    })

    it('screenSessionList2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, function () {
      let list: SCBScreenSessionArray = [];
      screenSession.setScreenSessionList(list);
      expect(list).assertEqual(screenSession.getScreenSessionList());

      screenSession.getScreenSession(0);
      screenSession.getMainScreenSession();
      screenSession.getScreenOrientationLocked(0);

    })

    it('getPhyScreenProperty', TestType.USER | Size.SMALLTEST | Level.LEVEL0, function () {
      let mainScreenId = 0;
      let screenProperty: SCBScreenProperty = screenSession.getPhyScreenProperty(mainScreenId);
      expect(screenProperty).not().assertNull();
    })
  })
}