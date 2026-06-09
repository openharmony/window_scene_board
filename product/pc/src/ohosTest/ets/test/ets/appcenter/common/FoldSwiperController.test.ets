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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ActionType, FourFingersSwipe } from '@kit.InputKit';
import { ReflectionUtils } from '../../common/utils/ReflectionUtils';
import { FoldSwiperController } from '@ohos/pcbase/src/main/ets/common/FoldSwiperController';

export default function FoldSwiperControllerTest() {
  describe('FoldSwiperControllerTest', () => {
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

    it('test_FoldSwiperControllerTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = FoldSwiperController.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = FoldSwiperController.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_FoldSwiperControllerTest_registerSwitchPageEvent', Level.LEVEL0, (): void => {
      let instance = FoldSwiperController.getInstance();
      instance.registerSwitchPageEvent();
      expect(instance instanceof FoldSwiperController).assertTrue();
    })

    it('test_FoldSwiperControllerTest_canSwipeChange', Level.LEVEL0, (): void => {
      let instance = FoldSwiperController.getInstance();
      ReflectionUtils.setProperty(instance, 'isLock', true);
      instance.canSwipeChange();
      ReflectionUtils.setProperty(instance, 'isLock', false);
      ReflectionUtils.setProperty(instance, 'mPageState', 0);
      instance.canSwipeChange();
      ReflectionUtils.setProperty(instance, 'mPageState', 4);
      instance.canSwipeChange();
      expect(instance instanceof FoldSwiperController).assertTrue();
    })

    it('test_FoldSwiperControllerTest_switchPages', Level.LEVEL0, (): void => {
      let instance = FoldSwiperController.getInstance();
      ReflectionUtils.setProperty(instance, 'isLock', true);
      instance.switchPages(1);
      ReflectionUtils.setProperty(instance, 'isLock', false);
      ReflectionUtils.setProperty(instance, 'mPageState', 4);
      instance.switchPages(0);
      let fingerInfo: FingerInfo = {
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: -1,
        localY: 0,
        displayX: 0,
        displayY: 0
      };

      let event: GestureEvent = {
        repeat: false,
        fingerList: [fingerInfo],
        offsetX: -100,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 1.0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0,
        target: {
          area: {
            width: 0,
            height: 0,
            position: { x: 0, y: 0 },
            globalPosition: { x: 0, y: 0 }
          }
        },
        timestamp: 0,
        source: SourceType.TouchScreen,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Finger
      };
      instance.switchPages(1);
      instance.switchPages(1, event);
      instance.switchPages(4, event);
      expect(instance instanceof FoldSwiperController).assertTrue();
    })

    it('test_FoldSwiperControllerTest_updateMoveState', Level.LEVEL0, (): void => {
      let instance = FoldSwiperController.getInstance();
      let gesture: FourFingersSwipe = {
        x: 0,
        y: 0,
        type: 1
      }
      instance.updateMoveState(gesture);
      gesture.type = 2;
      ReflectionUtils.setProperty(instance, 'startFingerTouch', false);
      instance.updateMoveState(gesture);
      ReflectionUtils.setProperty(instance, 'startFingerTouch', true);
      instance.updateMoveState(gesture);
      gesture.type = 3;
      ReflectionUtils.setProperty(instance, 'startFingerTouch', false);
      instance.updateMoveState(gesture);
      ReflectionUtils.setProperty(instance, 'startFingerTouch', true);
      instance.updateMoveState(gesture);
      gesture.type = 0;
      instance.updateMoveState(gesture);
      gesture.type = 6;
      instance.updateMoveState(gesture);
      expect(instance instanceof FoldSwiperController).assertTrue();
    })

    it('test_FoldSwiperControllerTest_updateFoldState', Level.LEVEL0, (): void => {
      let instance = FoldSwiperController.getInstance();
      instance.updateFoldState(1);
      instance.updateFoldState(2);
      instance.updateFoldState(3);
      instance.updateFoldState(4);
      expect(instance instanceof FoldSwiperController).assertTrue();
    })
  })
}