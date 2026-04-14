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

import { afterAll, afterEach, beforeAll, beforeEach, describe, it, Level, expect } from '@ohos/hypium';
import { ComponentAnimState, PropertyType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { ImmersiveAnimNode, ImmersiveAnimUnit } from '../../../../../../main/ets/common/anim/ImmersiveAnimUnit';
import { ImmersiveBaseAnim } from '../../../../../../main/ets/common/anim/ImmersiveBaseAnim';

export function ImmersiveBaseAnimTest() {
  describe('ImmersiveBaseAnimTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_startAnim_with_emptyUnit', Level.LEVEL0, () => {
      let baseAnim = new ImmersiveBaseAnim(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW);
      baseAnim.start();
      expect(baseAnim.isRunning()).assertFalse();
    });

    it('test_exitAnim', Level.LEVEL0, () => {
      let baseAnim = new ImmersiveBaseAnim(ImmersiveAnimScene.SCENE_CAPSULE_STACK_SHOW);
      baseAnim.exit();
      expect(baseAnim.isRunning()).assertFalse();
    });

    it('test_processEndCallback', Level.LEVEL0, () => {
      let baseAnim = new ImmersiveBaseAnim(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW);
      let nextAnim = new ImmersiveBaseAnim(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH);
      (baseAnim as object)['processEndCallback']();
      baseAnim.setNextAnim(nextAnim);
      (baseAnim as object)['processEndCallback']();
      expect(baseAnim).not().assertNull();
    });

  });
}