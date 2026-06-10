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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { RTLUtil } from '@ohos/componenthelper';
import { GestureBackMetaBallModel } from '../../../../../../main/ets/metaball/viewmodel/GestureBackMetaBallModel';
import { GestureBackMetaBallCallBack } from '../../../../../../main/ets/metaball/viewmodel/GestureBackMetaBallCallBack';

export default function GestureBackMetaBallModelTest() {
  describe('GestureBackMetaBallModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.·
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
      offsetY: 1,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

    const gestureBackMetaBallCallBack: GestureBackMetaBallCallBack = {
      onExtrudeBallsBegin: (): void => {
      },
      onExtrudeBallsFinish: (): void => {
      },
      onMoveBackBallsBegin: (): void => {
      },
      onMoveBackBallsFinish: (): void => {
      },
      onHandUpAnimFinish: (): void => {
      }
    }

    it('GestureBackMetaBallModel_initPoint_001', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      expect(gestureBackMetaBallModel.initPoint(gestureEvent, true, 1200, 2600, gestureBackMetaBallCallBack) ===
        undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_initPoint_002', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      expect(gestureBackMetaBallModel.initPoint(gestureEvent, false, 1200, 2600, gestureBackMetaBallCallBack) ===
        undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleActionMove_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      expect(gestureBackMetaBallModel.handleActionMove(null) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleActionMove_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleActionMove_3', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = true;
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleActionMove_4', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 0,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }, {
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = true;
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleActionMove_5', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 0,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }, {
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.initPoint(gestureEvent, true, 1200, 2600, gestureBackMetaBallCallBack);
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = true;
      gestureEvent.timestamp = 200000;
      gestureBackMetaBallModel.handleActionMove(gestureEvent);
      expect(gestureBackMetaBallModel).not().assertUndefined();
    })

    it('GestureBackMetaBallModel_handleActionMove_6', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureBackMetaBallModel, (gestureBackMetaBallModel as object)['isNeedPlayExtrudeAnim']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (gestureBackMetaBallModel as object)['initExtrudeTouchPointX'] = 1;
      (gestureBackMetaBallModel as object)['drawMetaBallProcess'] = 1;
      (gestureBackMetaBallModel as object)['isMoveBackAnimRunning'] = false;
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
      mocker.ignoreMock(gestureBackMetaBallModel, (gestureBackMetaBallModel as object)['isNeedPlayExtrudeAnim']);
    })

    it('GestureBackMetaBallModel_handleUpAnimation_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = true;
      expect(gestureBackMetaBallModel.handleUpAnimation() === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleUpAnimation_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      expect(gestureBackMetaBallModel.handleUpAnimation() === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleUpAnimation_3', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      (gestureBackMetaBallModel as object)['isMoveBackAnimRunning'] = true;
      expect(gestureBackMetaBallModel.handleUpAnimation() === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_handleUpAnimation_4', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      (gestureBackMetaBallModel as object)['isMoveBackAnimRunning'] = false;
      expect(gestureBackMetaBallModel.handleUpAnimation() === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_upAnimFinish_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let gestureBackMetaBallModel1 = (gestureBackMetaBallModel as object);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureBackMetaBallModel,
        gestureBackMetaBallModel1['handUpAnimFinishCallback']);
      let callBack: Function = () => {
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(callBack);
      gestureBackMetaBallModel1['upAnimFinish']();
      expect(gestureBackMetaBallModel).not().assertUndefined();
      mocker.clear(gestureBackMetaBallModel);
    })

    it('GestureBackMetaBallModel_upAnimFinish_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      (gestureBackMetaBallModel as object)['handUpAnimFinishCallback'] = () => {
        1
      };
      expect((gestureBackMetaBallModel as object)['upAnimFinish']() === undefined).assertTrue()
    })

    it('GestureBackMetaBallModel_buildExtrudeAnim_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.handleUpAnimation();
      expect(gestureBackMetaBallModel.initPoint(gestureEvent, true, 1200, 2600,
        gestureBackMetaBallCallBack) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_changeDockImgAnim_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      (gestureBackMetaBallModel as object)['changeDockImgProcess'] = 1;
      expect(gestureBackMetaBallModel.changeDockImgAnim(false, () => {
      }) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_changeDockImgAnim_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      expect(gestureBackMetaBallModel.changeDockImgAnim(true, () => {
      }) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_updatePoint_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [];
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_updatePoint_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.initPoint(gestureEvent, true, 1200, 2600, gestureBackMetaBallCallBack);
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_updatePoint_3', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.initPoint(gestureEvent, false, 1200, 2600, gestureBackMetaBallCallBack);
      expect(gestureBackMetaBallModel.handleActionMove(gestureEvent) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_setCanvasParams_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      let gestureBackMetaBallModel1 = (gestureBackMetaBallModel as object);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureBackMetaBallModel,
        gestureBackMetaBallModel1['isNeedPlayExtrudeAnim']);
      when(mockFunc)().afterReturn(true);
      gestureBackMetaBallModel.initPoint(gestureEvent, true, 1200, 2600, gestureBackMetaBallCallBack);
      gestureBackMetaBallModel.handleActionMove(gestureEvent);
      expect(gestureBackMetaBallModel).not().assertUndefined();
      mocker.clear(gestureBackMetaBallModel);
    })

    it('GestureBackMetaBallModel_setCanvasParams_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      let gestureBackMetaBallModel1 = (gestureBackMetaBallModel as object);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureBackMetaBallModel,
        gestureBackMetaBallModel1['isNeedPlayExtrudeAnim']);
      when(mockFunc)().afterReturn(true);
      gestureBackMetaBallModel.initPoint(gestureEvent, false, 1200, 2600, gestureBackMetaBallCallBack);
      gestureBackMetaBallModel.handleActionMove(gestureEvent);
      expect(gestureBackMetaBallModel).not().assertUndefined();
      mocker.clear(gestureBackMetaBallModel);
    })

    it('GestureBackMetaBallModel_setCanvasParams_3', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.initPoint(gestureEvent, true, 1200, 2600, gestureBackMetaBallCallBack);
      expect(gestureBackMetaBallModel).not().assertUndefined();
    })

    it('GestureBackMetaBallModel_setCanvasParams_4', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureEvent.fingerList = [{
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      }];
      gestureBackMetaBallModel.initPoint(gestureEvent, false, 1200, 2600, gestureBackMetaBallCallBack);
      expect(gestureBackMetaBallModel).not().assertUndefined();
    })

    it('GestureBackMetaBallModel_setCanvasParams_5', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      expect((gestureBackMetaBallModel as object)['setCanvasParams'](true) === undefined).assertTrue()
    })

    it('Circle_drawArrow_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 1;
      expect(gestureBackMetaBallModel.virtualCircle.drawArrow(context) === undefined).assertTrue();
    })

    it('Circle_drawArrow_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 0;
      gestureBackMetaBallModel.virtualCircle.thresholdProcess = 1;
      gestureBackMetaBallModel.virtualCircle.moveProcess = 0;
      expect(gestureBackMetaBallModel.virtualCircle.drawArrow(context) === undefined).assertTrue();
    })

    it('Circle_drawArrow_3', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 0;
      gestureBackMetaBallModel.virtualCircle.thresholdProcess = 1;
      gestureBackMetaBallModel.virtualCircle.moveProcess = 2;
      expect(gestureBackMetaBallModel.virtualCircle.drawArrow(context) === undefined).assertTrue();
    })

    it('Circle_drawArrow_4', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 0;
      gestureBackMetaBallModel.virtualCircle.thresholdProcess = 0;
      expect(gestureBackMetaBallModel.virtualCircle.drawArrow(context) === undefined).assertTrue();
    })

    it('Circle_drawArrow_5', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 0;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(false);
      expect(gestureBackMetaBallModel.virtualCircle.drawArrow(context) === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('Circle_drawDockImg_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 0;
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      expect(gestureBackMetaBallModel.virtualCircle.drawDockImg(context) === undefined).assertTrue();
    })

    it('Circle_drawDockImg_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.virtualCircle.dockImgProcess = 1;
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
      expect(gestureBackMetaBallModel.virtualCircle.drawDockImg(context) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_backAnimation_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = true;
      expect((gestureBackMetaBallModel as object)['backAnimation'](1) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_drawMetaBall_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.virtualCircle.cx = 101;
      (gestureBackMetaBallModel as object)['realCircle'].cx = 1;
      gestureBackMetaBallModel.virtualCircle.radius = 1;
      (gestureBackMetaBallModel as object)['realCircle'].radius = 1;
      (gestureBackMetaBallModel as object)['distanceRatio'] = 1;
      expect((gestureBackMetaBallModel as object)['drawMetaBall'](1, 1, 1, 1, 1, 1) === undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_isNeedPlayExtrudeAnim_1', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      gestureEvent.timestamp = 1;
      (gestureBackMetaBallModel as object)['preEvent'] = gestureEvent;
      expect((gestureBackMetaBallModel as object)['isNeedPlayExtrudeAnim'](gestureEvent, 1) !== undefined).assertTrue();
    })

    // const NS_COUNT_PER_MS: number = 1000000;
    it('GestureBackMetaBallModel_isNeedPlayExtrudeAnim_2', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      gestureEvent.timestamp = 1;
      (gestureBackMetaBallModel as object)['preEvent'] = gestureEvent;
      gestureEvent.timestamp = 2000000;
      (gestureBackMetaBallModel as object)['startTime'] = 0;
      expect((gestureBackMetaBallModel as object)['isNeedPlayExtrudeAnim'](gestureEvent, 1) !== undefined).assertTrue();
    })

    it('GestureBackMetaBallModel_isNeedPlayExtrudeAnim_3', 0, () => {
      let gestureBackMetaBallModel = new GestureBackMetaBallModel();
      gestureBackMetaBallModel.isExtrudeBallsAnimRunning = false;
      gestureEvent.timestamp = 1;
      (gestureBackMetaBallModel as object)['preEvent'] = gestureEvent;
      gestureEvent.timestamp = 2000000;
      (gestureBackMetaBallModel as object)['startTime'] = 1;
      expect((gestureBackMetaBallModel as object)['isNeedPlayExtrudeAnim'](gestureEvent, 1) !== undefined).assertTrue();
    })

  })
}
