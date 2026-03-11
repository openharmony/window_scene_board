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
import { animationContinueManager, AnimationViewData } from '../../../../../../../../../main/ets/TsIndex';

/**
 * 动效衔接组件的管理类测试套
 */
export function AnimationContinueManagerTest() {
  describe('AnimationContinueManagerTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('test_addData', Level.LEVEL0, (): void => {
      let data: AnimationViewData = new AnimationViewData('');
      animationContinueManager.addData(data);
      expect(animationContinueManager.getData('')).assertEqual(data);
      animationContinueManager.addData(data);
      expect(animationContinueManager.getAllData().length).assertEqual(1);
      animationContinueManager.releaseAll();
    })

    it('test_show', Level.LEVEL0, (): void => {
      let data: AnimationViewData = new AnimationViewData('');
      animationContinueManager.addData(data);
      animationContinueManager.show('1');
      expect(data.isShow).assertFalse();
      animationContinueManager.show('');
      expect(data.isShow).assertTrue();
      animationContinueManager.releaseAll();
    })
  })
}