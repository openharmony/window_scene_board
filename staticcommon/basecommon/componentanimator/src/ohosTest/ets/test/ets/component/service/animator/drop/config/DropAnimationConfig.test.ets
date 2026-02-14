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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  DropAnimationCancelReason,
  DropAnimationConfig,
  DropAnimationScene,
  DropAnimationDestination,
} from '../../../../../../../../../main/ets/service/animator/drop/config/DropAnimationConfig';

/**
 * 落位动效规则配置测试套
 */
export function DropAnimationConfigTest() {
  describe('DropAnimationConfigTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_getDropAnimationScene', Level.LEVEL0, (): void => {
      expect(DropAnimationConfig.getDropAnimationScene(0)).assertEqual(0);
      expect(DropAnimationConfig.getDropAnimationScene(DropAnimationDestination.DESKTOP))
        .assertEqual(DropAnimationScene.SCENE_DESKTOP);
      expect(DropAnimationConfig.getDropAnimationScene(DropAnimationDestination.DOCK))
        .assertEqual(DropAnimationScene.SCENE_DESKTOP);
      expect(DropAnimationConfig.getDropAnimationScene(DropAnimationDestination.OPEN_FOLDER))
        .assertEqual(DropAnimationScene.SCENE_DESKTOP);
    })

    it('test_canCancel', Level.LEVEL0, (): void => {
      expect(DropAnimationConfig.canCancel(0, 0)).assertFalse();
      expect(DropAnimationConfig.canCancel(DropAnimationDestination.DESKTOP, DropAnimationCancelReason.TOUCH_DESKTOP_ITEM))
        .assertTrue();
    })
  })
}