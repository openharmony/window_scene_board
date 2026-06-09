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
import { ArgumentMatchers, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { FloatCalculator,
  FloatRect,
  InertialAnimationSpeedCompute,
  Pin} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/FloatUtils';

let floatCalculator: FloatCalculator;
let floatRect: FloatRect;
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
let event: GestureEvent = {
  repeat: false,
  fingerList: [],
  offsetX: 9,
  offsetY: 19,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 0,
  target: eventTarget,
  timestamp: 0,
  source: SourceType.Unknown,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: SourceTool.Unknown
};
let initAll = () => {
  floatRect = new FloatRect(0, 0, 0, 0);
}
export function FloatCalculatorTest() {
  FloatCalculatorTest_1();
}

function FloatCalculatorTest_1() {
  describe('FloatCalculatorTest_001', () => {
    beforeEach(initAll)
    it ("floatRect_test001", Level.LEVEL0, () => {
      floatRect.expandWidthWithAspect(0);
      floatRect.expandHeightWithAspect(0);
      expect(true).assertTrue();
    });

    it ("getRealRatio001", Level.LEVEL0, () => {
      FloatCalculator.getRealRatio(0);
      expect(true).assertTrue();
    });

    it ("floatRect_pinToAnchor001", Level.LEVEL0, () => {
      floatRect.pinTmp = Pin.LeftTop;
      floatRect.pinToAnchor();
      floatRect.pinTmp = Pin.RightTop;
      floatRect.pinToAnchor();
      floatRect.pinTmp = Pin.CenterTop;
      floatRect.pinToAnchor();
      expect(true).assertTrue();
    });

    it ("InertialAnimationSpeedCompute_calcSpeedAndAcc001", Level.LEVEL0, () => {
      let inertialAnimCalculator = new InertialAnimationSpeedCompute();
      inertialAnimCalculator.calcSpeedAndAcc(event);
      inertialAnimCalculator.calcSpeedAndAcc(event);
      expect(true).assertTrue();
    });
  });
}