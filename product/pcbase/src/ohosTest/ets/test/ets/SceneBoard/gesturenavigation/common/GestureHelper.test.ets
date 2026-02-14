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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {GestureHelper} from '../../../../../../../../../pcbase/src/main/ets/SceneBoard/gesturenavigation/common/GestureHelper';

export default function GestureHelperTest() {
  describe('GestureHelperTest', () => {
    let mocker: MockKit;
    let gestureHelper: GestureHelper;
    let gestureEvent:GestureEvent= {
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
      target: {
        area:{
          width: 5,
          height: 10,
          position: {
            x: 20, y: 20
          },
          globalPosition: {
            x: 50, y: 50
          },
        }
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('getAspectRadioTest', 0, () => {
      gestureHelper.speedScalar = 0;
      (gestureHelper as object)['updateStopEvent'](gestureEvent);
      gestureHelper.speedScalar = 1;
      (gestureHelper as object)['updateStopEvent'](gestureEvent);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

    it('calcStopDurationTest', 0, () => {
      (gestureHelper as object)['stopEvent'] = gestureEvent;
      (gestureHelper as object)['calcStopDuration'](gestureEvent);
      (gestureHelper as object)['stopEvent'] = null;;
      (gestureHelper as object)['calcStopDuration'](gestureEvent);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

    it('calcSpeedTest', 0, () => {
      (gestureHelper as object)['preEvent'] = null;
      (gestureHelper as object)['calcSpeed'](gestureEvent);
      (gestureHelper as object)['preEvent'] = gestureEvent;
      (gestureHelper as object)['calcSpeed'](gestureEvent);
      let gestureEventTEST: GestureEvent = gestureEvent
      gestureEventTEST.timestamp = 2;
      (gestureHelper as object)['calcSpeed'](gestureEventTEST);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

    it('calcAccelerationTest', 0, () => {
      (gestureHelper as object)['preEvent'] = null;
      (gestureHelper as object)['calcAcceleration'](gestureEvent);
      (gestureHelper as object)['preEvent'] = gestureEvent;
      (gestureHelper as object)['calcAcceleration'](gestureEvent);
      let gestureEventTEST: GestureEvent = gestureEvent
      gestureEventTEST.timestamp = 2;
      (gestureHelper as object)['calcAcceleration'](gestureEventTEST);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

    it('invokeTest', 0, () => {
      (gestureHelper as object)['preEvent'] = null;
      gestureHelper.invoke(gestureEvent);
      (gestureHelper as object)['preEvent'] = gestureEvent;
      gestureHelper.invoke(gestureEvent);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

    it('updateValidFingerIndexTest', 0, () => {
      let fingerList: FingerInfo[] = [{
        id: 2,
        globalX: 20,
        globalY: 20,
        localX: 50,
        localY: 50,
        displayX: 60.34,
        displayY: 60.34,
      }];
      gestureEvent.fingerList = fingerList;
      gestureHelper.updateValidFingerIndex(gestureEvent);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

    it('getValidFingerPosXTest', 0, () => {
      let fingerList: FingerInfo[] = [{
        id: 2,
        globalX: 20,
        globalY: 20,
        localX: 50,
        localY: 50,
        displayX: 60.34,
        displayY: 60.34,
      },
        {
          id: 3,
          globalX: 30,
          globalY: 30,
          localX: 60,
          localY: 60,
          displayX: 70.34,
          displayY: 80.34,
        }];
      gestureEvent.fingerList = fingerList;
      gestureHelper.validFingerIndex = 1;
      gestureHelper.getValidFingerPosX(gestureEvent);
      gestureEvent.fingerList = [];
      gestureHelper.getValidFingerPosX(gestureEvent);
      expect(gestureHelper instanceof GestureHelper).assertTrue();
    })

  })
}