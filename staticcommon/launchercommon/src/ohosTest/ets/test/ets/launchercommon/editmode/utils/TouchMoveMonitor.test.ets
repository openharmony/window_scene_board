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

import {
  describe,
  it,
  expect,
  MockKit,
  when,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll } from '@ohos/hypium'
import { Point, TouchMoveMonitor } from '../../../../../../../main/ets/editmode/utils/TouchMoveMonitor'
import { ToolType, TouchEvent, SourceType } from '@ohos.multimodalInput.touchEvent';
import { Action } from '@kit.InputKit';

export default function TouchMoveMonitorTest() {
  describe('TouchMoveMonitorTest', () => {
    const touchMoveMonitor = new TouchMoveMonitor();
    let touchEvent: TouchEvent = {
      touches: [{
        id: 0,
        pressedTime: 0,
        screenX: 0,
        screenY: 0,
        windowX: 0,
        windowY: 0,
        pressure: 0,
        width: 0,
        height: 0,
        tiltX: 0,
        tiltY: 0,
        toolX: 0,
        toolY: 0,
        toolWidth: 0,
        toolHeight: 0,
        rawX: 0,
        rawY: 0,
        toolType: ToolType.FINGER
      }],
      action: Action.CANCEL,
      id: 0,
      deviceId: 0,
      actionTime: 0,
      screenId: 0,
      windowId: 0,
      touch: {
        id: 0,
        pressedTime: 0,
        screenX: 0,
        screenY: 0,
        windowX: 0,
        windowY: 0,
        pressure: 0,
        width: 0,
        height: 0,
        tiltX: 0,
        tiltY: 0,
        toolX: 0,
        toolY: 0,
        toolWidth: 0,
        toolHeight: 0,
        rawX: 0,
        rawY: 0,
        toolType: ToolType.FINGER
      },
      sourceType: SourceType.TOUCH_SCREEN
    }

    it('test_TouchMoveMonitorTest01', 0, () => {
      expect(touchMoveMonitor.start(()=>{})).assertTrue();
      expect(touchMoveMonitor.start(()=>{})).assertFalse();
      expect(touchMoveMonitor.end()).assertTrue();
      expect(touchMoveMonitor.end()).assertFalse();
    })

    it('test_TouchMoveMonitorTest02', 0, () => {
      const point: Point = touchMoveMonitor['defaultGetTouchPosition'](touchEvent)
      expect(point.x).assertEqual(px2vp(0));
    })

    it('test_TouchMoveMonitorTest03', 0, () => {
      expect(touchMoveMonitor['onMove'](touchEvent)).assertFalse();
    })

    it('test_TouchMoveMonitorTest04', 0, () => {
      touchMoveMonitor['overrideGetTouchPosition']((touchEvent: TouchEvent) => {
        const touch = touchEvent.touches[0];
        return {
          x: touch.windowX + 1,
          y: touch.windowY + 1
        }
      })
      const point1: Point = touchMoveMonitor['getTouchPosition'](touchEvent);
      expect(point1.x).assertEqual(1);

      touchMoveMonitor['reSet']()
      const point2: Point = touchMoveMonitor['getTouchPosition'](touchEvent);
      expect(point2.x).assertEqual(0);
    })
  })
}
