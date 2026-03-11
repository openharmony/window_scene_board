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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, TestType, Size, Level } from '@ohos/hypium';
import {
  RecentStates,
  RecentStateManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/innerstate/RecentStates';
export default function RecentStateManagerTest() {
  describe('RecentInnerStateManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let recentStateManager: RecentStateManager = new RecentStateManager();

    it('RecentInnerStateManager_onInit_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentStateManager.onInit();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_INIT);
      expect(recentStateManager.isInitState()).assertTrue();
    })

    it('RecentInnerStateManager_onEnterFollowing_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isEnterFollowingState()).assertFalse();
      recentStateManager.onEnterFollowing();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_ENTER_FOLLOWING);
    })

    it('RecentInnerStateManager_onEnterFollowing_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentStateManager.onEnterFollowing();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_ENTER_FOLLOWING);
      expect(recentStateManager.isEnterFollowingState()).assertTrue();
    })

    it('RecentInnerStateManager_onInit_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isInitState()).assertFalse();
      recentStateManager.onInit();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_INIT);
    })

    it('RecentInnerStateManager_onEnterAnimating_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isEnterAnimatingState()).assertFalse();
      expect(recentStateManager.isInRecentView()).assertFalse();
      recentStateManager.onEnterAnimating();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_ENTER_ANIMATING);
    })

    it('RecentInnerStateManager_onEnterAnimating_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isEnterAnimatingState()).assertTrue();
      expect(recentStateManager.isInRecentView()).assertTrue();
      recentStateManager.onEnterAnimating();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_ENTER_ANIMATING);
    })

    it('RecentInnerStateManager_onStable_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isStableState()).assertFalse();
      recentStateManager.onStable();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_STABLE);
    })

    it('RecentInnerStateManager_onStable_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isStableState()).assertTrue();
      expect(recentStateManager.isInRecentView()).assertTrue();
      recentStateManager.onStable();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_STABLE);
    })

    it('RecentInnerStateManager_onExitAnimating_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isExitAnimatingState()).assertFalse();
      recentStateManager.onExitAnimating();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_EXIT_ANIMATING);
    })

    it('RecentInnerStateManager_onExitAnimating_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isExitAnimatingState()).assertTrue();
      recentStateManager.onExitAnimating();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_EXIT_ANIMATING);
    })

    it('RecentInnerStateManager_onStartSceneAnimating_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isStartSceneAnimatingState()).assertFalse();
      recentStateManager.onStartSceneAnimating();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_START_SCENE_ANIMATING);
    })

    it('RecentInnerStateManager_onStartSceneAnimating_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentStateManager.isStartSceneAnimatingState()).assertTrue();
      recentStateManager.onStartSceneAnimating();
      expect(recentStateManager.currentState).assertEqual(RecentStates.STATE_START_SCENE_ANIMATING);
    })
  })
}
