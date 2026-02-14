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
import { AppCenterSceneAnimationController } from '@ohos/appcenter'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'

export default function AppCenterSceneAnimationControllerTest() {
  describe('AppCenterSceneAnimationControllerTest', () => {
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

    it('test_AppCenterSceneAnimationControllerTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = AppCenterSceneAnimationController.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = AppCenterSceneAnimationController.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_AppCenterSceneAnimationControllerTest_enqueue', Level.LEVEL0, (): void => {
      let instance: AppCenterSceneAnimationController = AppCenterSceneAnimationController.getInstance();
      let animatedSceneRecords: Map<number, number> = new Map();
      animatedSceneRecords.set(0, 2);
      (instance as object)['animatedSceneRecords'] = animatedSceneRecords;
      instance.enqueue(0, true);
      instance.enqueue(0, false);
      expect(instance instanceof AppCenterSceneAnimationController).assertTrue();
    })

    it('test_AppCenterSceneAnimationControllerTest_dequeue', Level.LEVEL0, (): void => {
      let instance: AppCenterSceneAnimationController = AppCenterSceneAnimationController.getInstance();
      let animatedSceneRecords: Map<number, number> = new Map();
      animatedSceneRecords.set(0, 2);
      (instance as object)['animatedSceneRecords'] = animatedSceneRecords;
      instance.dequeue(0);
      instance.dequeue(1);
      expect(instance instanceof AppCenterSceneAnimationController).assertTrue();
    })

    it('test_AppCenterSceneAnimationControllerTest_dumpAnimatedSceneRecords', Level.LEVEL0, (): void => {
      let instance: AppCenterSceneAnimationController = AppCenterSceneAnimationController.getInstance();
      let animatedSceneRecords: Map<number, number> = new Map();
      animatedSceneRecords.set(0, 2);
      instance.dumpAnimatedSceneRecords();
      (instance as object)['animatedSceneRecords'] = animatedSceneRecords;
      instance.dumpAnimatedSceneRecords();
      expect(instance instanceof AppCenterSceneAnimationController).assertTrue();
    })
  })
}