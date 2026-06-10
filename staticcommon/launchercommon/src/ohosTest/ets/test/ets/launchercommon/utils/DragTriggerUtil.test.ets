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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when } from '@ohos/hypium';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DragConstants } from '@ohos/commonconstants';
import { DragControllerParams } from '@ohos/componenthelper/Index';
import { dragTriggerUtil } from '../../../../../../main/ets/utils/DragTriggerUtil';
import { TouchEvent } from 'touchEvent';

export default function DragTriggerUtilTest() {
  describe('DragTriggerUtilTest', (): void => {
    beforeAll((): void => {})
    beforeEach((): void => {})
    afterAll((): void => {})
    afterEach((): void => {})

    it('DragTriggerUtil_executeDragTrigger_test', Level.LEVEL0, (): void => {
      let res: boolean = false;
      GlobalContext.getContext()?.eventHub.on(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT,
        (isPreparing: boolean): void => { res = isPreparing });

      let downPoint: number[] = [1, 1];
      let downEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          windowX: downPoint[0],
          windowY: downPoint[1],
        }]
      } as TouchEvent;
      dragTriggerUtil.initDragParams({} as DragControllerParams);
      dragTriggerUtil.preDragTrigger(downEvent);
      expect(dragTriggerUtil.getPrepareStatus()).assertTrue();
      expect(res).assertTrue();

      let movePoint1: number[] = [1, 1];
      let moveEvent1: TouchEvent = {
        type: TouchType.Move,
        touches: [{
          windowX: movePoint1[0],
          windowY: movePoint1[1],
        }]
      } as TouchEvent;
      dragTriggerUtil.preDragTrigger(moveEvent1);
      expect(dragTriggerUtil.getTriggerStatus()).assertFalse();

      let movePoint2: number[] = [2, 2];
      let moveEvent2: TouchEvent = {
        type: TouchType.Move,
        touches: [{
          windowX: movePoint2[0],
          windowY: movePoint2[1],
        }]
      } as TouchEvent;
      dragTriggerUtil.preDragTrigger(moveEvent2);
      expect(dragTriggerUtil.getTriggerStatus()).assertTrue();
    })

    it('DragTriggerUtil_resetDragTrigger_test', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GlobalContext, GlobalContext.getContext);
      when(mockFunc)().afterReturn(null);

      expect(dragTriggerUtil.getTriggerStatus()).assertTrue();
      let upEvent: TouchEvent = {
        type: TouchType.Up,
        touches: [{
          windowX: 0,
          windowY: 0,
        }]
      } as TouchEvent;
      dragTriggerUtil.preDragTrigger(upEvent);
      expect(dragTriggerUtil.getPrepareStatus()).assertFalse();
      expect(dragTriggerUtil.getTriggerStatus()).assertFalse();

      let downEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          windowX: 0,
          windowY: 0,
        }]
      } as TouchEvent;
      dragTriggerUtil.preDragTrigger(downEvent);
      expect(dragTriggerUtil.getPrepareStatus()).assertTrue();

      let cancelEvent: TouchEvent = {
        type: TouchType.Cancel,
        touches: [{
          windowX: 0,
          windowY: 0,
        }]
      } as TouchEvent;
      dragTriggerUtil.preDragTrigger(cancelEvent);
      expect(dragTriggerUtil.getPrepareStatus()).assertFalse();

      mocker.clear(GlobalContext);
      mocker.clearAll();
    })
  })
}
