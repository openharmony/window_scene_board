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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { LiveListAnimMgr, LiveListAnimStatus }  from '../../../../../main/ets/anim/LiveListAnimMgr';

export default function LiveListAnimMgrTest() {
  const liveListAnimMgr: LiveListAnimMgr = new LiveListAnimMgr();

  describe('LiveListAnimMgrTest', () => {
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

    it('getLiveListAnimStatus', Level.LEVEL0, (): void => {
      const animStatus: LiveListAnimStatus = liveListAnimMgr.getLiveListAnimStatus();

      expect(animStatus).assertEqual(liveListAnimMgr.animStatus);
    })

    it('setLiveListAnimStatus', Level.LEVEL0, (): void => {
      liveListAnimMgr.setLiveListAnimStatus(LiveListAnimStatus.STATUS_SHOW);

      expect(liveListAnimMgr.animStatus).assertEqual(LiveListAnimStatus.STATUS_SHOW);
    })

    it('getScrollerForComponent', Level.LEVEL0, (): void => {
      const scrollerForComponent: Scroller = liveListAnimMgr.getScrollerForComponent();

      expect((liveListAnimMgr as object)['scrollerForComponent']).assertEqual(scrollerForComponent);
    })

    it('registerAnimStatusChangeCallback', Level.LEVEL0, (): void => {
      const callback = () => {};

      liveListAnimMgr.registerAnimStatusChangeCallback(callback);

      expect((liveListAnimMgr as object)['animStatusChangeCallback']).assertEqual(callback);
    })

    it('getAnimParam', Level.LEVEL0, (): void => {
      const animParam: AnimateParam =  liveListAnimMgr.getAnimParam(0);

      expect(animParam).not().assertUndefined();
    })

    it('getItemCommonAnimState', Level.LEVEL0, (): void => {
      const itemCommonAnimState = liveListAnimMgr.getItemCommonAnimState(0);

      expect((liveListAnimMgr as object)['itemCommonAnimState']?.get(0)).assertEqual(itemCommonAnimState);
    })
  })
}