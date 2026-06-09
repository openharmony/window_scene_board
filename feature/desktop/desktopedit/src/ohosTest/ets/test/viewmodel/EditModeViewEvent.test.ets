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
import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import { EditModeViewEvent, PinchGestureActionType } from '../../../../main/ets/default/viewmodel/EditModeViewEvent';
import { editModeViewManager } from '../../../../main/ets/default/manager/EditModeViewManager';
import { SystemParamUtils, DeviceHelper } from '@ohos/frameworkwrapper';
import { editModeManager, FormCenterViewManager, MultiSelectManager } from '@ohos/launchercommon';

export function EditModeViewEventTest() {
  describe('EditModeViewEventTest', (): void => {
    const event: GestureEvent = {
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
      velocity: 0,
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown,
      target: {
        area: {
          width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 }
        }
      }
    };

    it('test_getPinchStartDistance', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      expect(editModeViewEvent.getPinchStartDistance()).assertEqual(0);
    })

    it('test_doPinchGestureEvent', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(SystemParamUtils, SystemParamUtils.isHddProduct);
      when(mockFunc1)().afterReturn(true);
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_START) === undefined)
        .assertTrue();
      when(mockFunc1)().afterReturn(false);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc2)().afterReturn(false);
      const mocker3: MockKit = new MockKit();
      const mockFunc3: Function = mocker3.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc3)().afterReturn(false);
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_START) === undefined)
        .assertTrue();
      when(mockFunc2)().afterReturn(true);
      when(mockFunc3)().afterReturn(true);
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_START) === undefined)
        .assertTrue();
      event.fingerList[0] = {
        globalX: 1,
        globalY: 2,
        id: 1,
        localX: 1,
        localY: 2,
        displayX: 1,
        displayY: 2
      };
      event.fingerList[1] = {
        globalX: 1,
        globalY: 2,
        id: 1,
        localX: 1,
        localY: 2,
        displayX: 1,
        displayY: 2
      };
      AppStorage.setOrCreate('isInGridSwiperGesture', true);
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_START) === undefined)
        .assertTrue();
      AppStorage.setOrCreate('isInGridSwiperGesture', false);
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_START) === undefined)
        .assertTrue();
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_UPDATE) === undefined)
        .assertTrue();
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_END) === undefined)
        .assertTrue();

      editModeViewEvent.editSwitchEnable = false;
      expect(editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_END) === undefined)
        .assertTrue();

      mocker1.clear(SystemParamUtils);
      mocker1.clearAll();
      mocker2.clear(DeviceHelper);
      mocker2.clearAll();
      mocker3.clear(DeviceHelper);
      mocker3.clearAll();
      AppStorage.clear();
    })

    it('test_backGestureHandler', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeViewManager, editModeViewManager.isShowUIExtension);
      when(mockFunc)().afterReturn(true);
      expect(editModeViewEvent.backGestureHandler() === undefined).assertTrue();
      when(mockFunc)().afterReturn(false);
      expect(editModeViewEvent.backGestureHandler() === undefined).assertTrue();
      mocker.clear(editModeViewManager);
      mocker.clearAll();
    })

    it('test_resetExitFlagDelay_01', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      (editModeViewEvent as object)['inExitAnimation'] = true
      let res: object = (editModeViewEvent as object)['resetExitFlagDelay']
      expect(res !== null).assertTrue();
    })

    it('test_resetExitFlagDelay_02', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      (editModeViewEvent as object)['inExitAnimation'] = false
      let res: object = (editModeViewEvent as object)['resetExitFlagDelay']
      expect(res !== null).assertTrue();
    })

    it('test_backGestureHandler_01', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      when(mockFunc)().afterReturn(true);
      let res = editModeViewEvent.backGestureHandler()
      expect(res !== null).assertTrue();
      mocker.ignoreMock(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      mocker.clearAll();
    })

    it('test_backGestureHandler_02', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      when(mockFunc)().afterReturn(false);
      let res = editModeViewEvent.backGestureHandler()
      expect(res !== null).assertTrue();
      mocker.ignoreMock(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      mocker.clearAll();
    })

    it('test_backGestureHandler_03', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      (MultiSelectManager.getInstance() as object)['inAnimation'] = false
      let res = editModeViewEvent.backGestureHandler()
      expect(res !== null).assertTrue();
    })

    it('test_backGestureHandler_04', 0, () => {
      const editModeViewEvent = new EditModeViewEvent();
      (MultiSelectManager.getInstance() as object)['inAnimation'] = true
      let res = editModeViewEvent.backGestureHandler()
      expect(res !== null).assertTrue();
    })

    it('test_calTouchDistance', 0, () => {
      const event: TouchEvent = {
        type: TouchType.Down,
        touches: [
          {
            type: TouchType.Down,
            id: 0,
            displayX: 0,
            displayY: 0,
            windowX: 0,
            windowY: 0,
            screenX: 0,
            screenY: 0,
            x: 0,
            y: 0
          }
        ],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 1,
            height: 1,
            position: {
              x: 0,
              y: 0
            },
            globalPosition: {
              x: 0,
              y: 0
            }
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      }
      const editModeViewEvent = new EditModeViewEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(true);
      editModeViewEvent.calTouchDistance(event);
      expect((editModeViewEvent as object)['touchDownX']).assertEqual(0);

      when(mockFunc)().afterReturn(false);
      editModeViewEvent.calTouchDistance(event);
      expect((editModeViewEvent as object)['touchDownX']).assertEqual(0);

      event.type = TouchType.Up;
      editModeViewEvent.calTouchDistance(event);
      expect((editModeViewEvent as object)['touchDownX']).assertEqual(0);

      event.type = TouchType.Move;
      editModeViewEvent.calTouchDistance(event);
      expect((editModeViewEvent as object)['touchDownX']).assertEqual(0);

      mocker.clear(editModeManager);
      mocker.clearAll();
    })
  })
}