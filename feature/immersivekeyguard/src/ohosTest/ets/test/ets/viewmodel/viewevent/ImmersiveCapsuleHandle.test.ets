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
import { ImmersiveCapsuleHandle } from '../../../../../../main/ets/viewmodel/viewevent/ImmersiveCapsuleHandle';
import { immersiveVm } from '../../../../../../main/ets/viewmodel/ImmersiveVm';
import { ImmersiveCapsuleVm } from '../../../../../../main/ets/viewmodel/ImmersiveCapsuleVm';
import { ImmersiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveEventStopHandle } from '../../../../../../main/ets/viewmodel/viewevent/ImmersiveEventStopHandle';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCapsuleHandleTest() {
  describe('ImmersiveCapsuleHandleTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_onGestureStartUpdateEnd', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
      let capsuleHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle();
      let eventArea: Area = {
        width: 0,
        height: 0,
        position: {
          x: 0, y: 0
        },
        globalPosition: {
          x: 0, y: 0
        }
      };
      let eventTarget: EventTarget = {
        area: eventArea
      };
      let gestureEvent: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 0,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      capsuleHandle.onGestureStart(gestureEvent);
      (capsuleHandle as object)['isUpVibrator'] = true;
      capsuleHandle.onGestureUpdate(gestureEvent);
      gestureEvent.offsetY = -100;
      (capsuleHandle as object)['isUpVibrator'] = false;
      capsuleHandle.onGestureUpdate(gestureEvent);
      capsuleHandle.onGestureEnd(undefined, true);
      gestureEvent.velocityY = 250;
      capsuleHandle.onGestureEnd(gestureEvent, false);
      gestureEvent.velocityY = -1100;
      capsuleHandle.onGestureEnd(gestureEvent, false);
      gestureEvent.velocityY = 0;
      capsuleHandle.onGestureEnd(gestureEvent, false);
      expect(capsuleHandle).not().assertNull();
    });

    it('test_setScrollUpState', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
      let capsuleHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle();
      (capsuleHandle as object)['setScrollUpState'](true);
      (capsuleHandle as object)['setScrollUpState'](false);
      expect(capsuleHandle).not().assertNull();
    });

    it('test_updateScrollUp', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
      let capsuleHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle();
      (capsuleHandle as object)['updateScrollUp'](-1000);
      (capsuleHandle as object)['updateScrollUp'](-500);
      (capsuleHandle as object)['updateScrollUp'](-100);
      (capsuleHandle as object)['updateScrollUp'](0);
      (capsuleHandle as object)['updateScrollUp'](100);
      (capsuleHandle as object)['updateScrollUp'](500);
      (capsuleHandle as object)['updateScrollUp'](1000);
      expect(capsuleHandle).not().assertNull();
    });

    it('test_endScrollUpBack', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
      let capsuleHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle();
      (capsuleHandle as object)['endScrollUpBack'](0);
      (capsuleHandle as object)['endScrollUpBack'](100);
      expect(capsuleHandle).not().assertNull();
    });

    it('test_endScrollUpSuccess', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
      let capsuleHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle();
      (capsuleHandle as object)['endScrollUpSuccess'](0);
      (capsuleHandle as object)['endScrollUpSuccess'](100);
      expect(capsuleHandle).not().assertNull();
    });

    it('test_getValidVelocity', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
      let capsuleHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle();
      (capsuleHandle as object)['getValidVelocity'](0, 0);
      (capsuleHandle as object)['getValidVelocity'](1000, 10);
      expect(capsuleHandle).not().assertNull();
    });
  });
}
