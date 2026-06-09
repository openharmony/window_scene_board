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
import { afterAll, afterEach, beforeAll, beforeEach, describe, Level, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { SlClockAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/SlClockAnimManager';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';

export function SlClockAnimManagerTest() {
  let mocker: MockKit;
  describe('SlClockAnimManagerTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {
    });

    it('test_startClockAnimScene', Level.LEVEL0, (): void => {
      let manager = new SlClockAnimManager();
      manager.startClockAnimScene();
      manager.startClockAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      expect(manager).not().assertNull();
    });

    it('test_endClockAnimScene', Level.LEVEL0, (): void => {
      let manager = new SlClockAnimManager();
      manager.endClockAnimScene();
      manager.endClockAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      expect(manager).not().assertNull();
    });

    it('test_clearClockAnimState', Level.LEVEL0, (): void => {
      let manager = new SlClockAnimManager();
      manager.clearClockAnimState();
      manager.clearClockAnimState(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      expect(manager).not().assertNull();
    });

    it('test_hasClockTranY', Level.LEVEL0, (): void => {
      let manager = new SlClockAnimManager();
      manager.hasClockTranY();
      expect(manager).not().assertNull();
    });

    it('test_setTouchAnimValue', Level.LEVEL0, (): void => {
      let manager = new SlClockAnimManager();
      manager.setTouchAnimValue(1, 1);
      manager.setTouchAnimValue(1, 1, false);
      expect(manager).not().assertNull();
    });

    it('test_getClockAnimStateUndefiend', Level.LEVEL0, (): void => {
      let manager = new SlClockAnimManager();
      (manager as object)['clockAnimState'] = undefined;
      let mockfunc_1 = mocker.mockFunc(slUiStateMgr, slUiStateMgr.getSlState);
      when(mockfunc_1)(ArgumentMatchers.any).afterReturn(undefined);
      manager.startClockAnimScene();
      manager.startClockAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      manager.endClockAnimScene();
      manager.endClockAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      manager.clearClockAnimState();
      manager.clearClockAnimState(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      manager.hasClockTranY();
      manager.setTouchAnimValue(1, 1);
      manager.setTouchAnimValue(1, 1, false);
      expect(manager).not().assertNull();
      mocker.clear(slUiStateMgr);
    });
  })
}