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

import { afterAll, afterEach, beforeAll, beforeEach, describe, it, Level, expect } from '@ohos/hypium';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { ImmersiveSerialAnim } from '../../../../../../main/ets/common/anim/ImmersiveSerialAnim';

export function ImmersiveSerialAnimTest() {
  describe('ImmersiveSerialAnimTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_startAnim_with_emptyUnit', Level.LEVEL0, () => {
      let baseAnim = new ImmersiveSerialAnim(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW);
      baseAnim.start();
      expect(baseAnim.isRunning()).assertFalse();
    });

    it('test_getBaseAnim_undefined', Level.LEVEL0, () => {
      let baseAnim = new ImmersiveSerialAnim(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE);
      expect(baseAnim.getBaseAnim(0)).assertUndefined();
    });
  });
}