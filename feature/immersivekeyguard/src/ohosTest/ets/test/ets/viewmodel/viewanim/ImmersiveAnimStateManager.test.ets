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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, Level, when, } from '@ohos/hypium';
import { ImmersiveAnimStateManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimStateManager';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { CommonUtils, ArrayUtils } from '@ohos/basicutils';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveAnimStateManagerTest() {
  describe('ImmersiveAnimStateManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_addAnimSceneFinish', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimStateManager();
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc_1)().afterReturn(true);
      let callback = (): void => {
      };
      let scene = ImmersiveAnimScene.SCENE_CARD_TO_LIST;
      manager.addAnimSceneFinish(scene, {onAnimFinish: callback});
      expect(res).assertTrue();
    });

    it('test_removeAnimSceneFinish', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimStateManager();
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockfunc_1)().afterReturn(true);
      let callback = (): void => {
      };
      let scene = ImmersiveAnimScene.SCENE_CARD_TO_LIST;
      manager.removeAnimSceneFinish(scene, {onAnimFinish: callback});
      expect(res).assertTrue();
    });

    it('test_hasAnimSceneFinish', Level.LEVEL1, (): void => {
      let scene = ImmersiveAnimScene.SCENE_CARD_TO_LIST;
      let manager = new ImmersiveAnimStateManager();
      let res = manager.hasAnimSceneFinish(scene);
      expect(res).not().assertNull();
    });

    it('test_exeAnimSceneFinish', Level.LEVEL1, (): void => {
      let res = true;
      let scene = ImmersiveAnimScene.SCENE_CARD_TO_LIST;
      let manager = new ImmersiveAnimStateManager();
      manager.exeAnimSceneFinish(scene);
      expect(res).assertTrue();
    });
  });
}