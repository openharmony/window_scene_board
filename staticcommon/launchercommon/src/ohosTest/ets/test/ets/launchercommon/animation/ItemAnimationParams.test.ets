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
import { RectInfo } from '@ohos/basicutils'
import { ItemUtils } from '@ohos/componenthelper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { ItemAnimationParams } from '../../../../../../../Index'

export default function ItemAnimationParamsTest() {
  describe('ItemAnimationParamsTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_calOuterUnlock_01', 0, () => {
      let residentRect: RectInfo = ItemUtils.getRectById('DOCK_RESIDENT_BG');
      AppStorage.setOrCreate('recentDockList', []);
      let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
      const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
      itemAnimation.calUnlock(screenWidth, screenHeight, residentRect);
      itemAnimation.calOuterUnlock();
      let outerMaxDistance = itemAnimation.distance;
      expect(outerMaxDistance).not().assertNull();
    })

    it('test_isScreenSplit_return', 0, async (done: Function) => {
      const itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const residentRect: RectInfo = ItemUtils.getRectById('DOCK_RESIDENT_BG');
      itemAnimation.screenCenterX = 0;
      itemAnimation.calUnlock(-1, -1, residentRect);
      expect(itemAnimation.screenCenterX === 0).assertTrue();
      done();
    })

    it('test_getDelay', 0, async (done: Function) => {
      const itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const delay: number = itemAnimation.getDelay(100, 200);
      expect(typeof delay === 'number').assertTrue();
      done();
    })

    it('test_getDelayOnLock', 0, async (done: Function) => {
      const itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const delayOnLock: number = itemAnimation.getDelayOnLock(100, 200);
      expect(typeof delayOnLock === 'number').assertTrue();
      done();
    })

    it('test_getDelayOnLockDock', 0, async (done: Function) => {
      const itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const delayOnLockDock: number = itemAnimation.getDelayOnLockDock(100, 200);
      expect(typeof delayOnLockDock === 'number').assertTrue();
      done();
    })

    it('test_calculateItemFoldProperty', 0, async (done: Function) => {
      const itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      itemAnimation.calculateItemFoldProperty(100, 100, 100, 100);
      expect(itemAnimation.itemTranslateX === 0).assertTrue();
      expect(itemAnimation.column === 100).assertTrue();
      itemAnimation.calculateItemFoldProperty(-100, -100, 200, 200);
      expect(itemAnimation.itemTranslateX === 0).assertTrue();
      expect(itemAnimation.column === 100).assertTrue();
      done();
    })

    it('test_calculateStartAppProperty', 0, async (done: Function) => {
      const itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const residentRect: RectInfo = ItemUtils.getRectById('DOCK_RESIDENT_BG');
      itemAnimation.calculateStartAppProperty(-100, -100, residentRect);
      expect(itemAnimation.name).assertEqual('');
      done();
    })

  })
}
