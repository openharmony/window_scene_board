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
const TOUCH_POSITIONX_DEFAULT = 100;
const TOUCH_POSITIONY_DEFAULT = 500;
const MULTI_TOUCH_POSITION_GAP = 50;

export class MockTouchObject implements TouchObject {
  type: TouchType;
  id: number;
  displayX: number;
  displayY: number;
  windowX: number;
  windowY: number;
  screenX: number;
  screenY: number;
  x: number;
  y: number;

  constructor(type: TouchType, positionX: number, positionY: number) {
    this.type = type;
    this.id = 0;
    this.displayX = positionX;
    this.displayY = positionY;
    this.windowX = positionX;
    this.windowY = positionY;
    this.screenX = positionX;
    this.screenY = positionY;
    this.x = positionX;
    this.y = positionY;
  }
}

export class MockHistoricalPoint implements HistoricalPoint {
  touchObject: MockTouchObject;
  size: number;
  force: number;
  timestamp: number;

  constructor(type: TouchType, positionX: number, positionY: number) {
    this.touchObject = new MockTouchObject(type, positionX, positionY);
    this.size = 0;
    this.force = 0;
    this.timestamp = 0;
  }
}

export class MockPosition implements Position {
  x?: Length = 100;
  y?: Length = 100;
}

export class MockArea implements Area {
  width: Length = 100;
  height: Length = 100;
  position: Position = new MockPosition();
  globalPosition: Position = new MockPosition();
}

export class MockEventTarget implements EventTarget {
  area: Area = new MockArea();
}

export class MockEvent implements TouchEvent {
  type: TouchType;
  touches: TouchObject[];
  changedTouches: TouchObject[];
  stopPropagation: () => void = () => {
  };

  target: EventTarget = new MockEventTarget();
  timestamp: number = 0;
  source: SourceType = SourceType.TouchScreen;
  pressure: number = 0;
  tiltX: number = 0;
  tiltY: number = 0;
  sourceTool: SourceTool = SourceTool.Finger;

  constructor(type: TouchType, isMultiTouch: boolean, positionX?: number, positionY?: number) {
    this.type = type;
    let touchX: number = positionX? positionX : TOUCH_POSITIONX_DEFAULT;
    let touchY: number = positionY? positionY : TOUCH_POSITIONY_DEFAULT;
    let firstTouchObj: MockTouchObject = new MockTouchObject(this.type, touchX, touchY)
    if (isMultiTouch) {
      let secondTouchObj: MockTouchObject
        = new MockTouchObject(this.type, touchY + MULTI_TOUCH_POSITION_GAP, touchY + MULTI_TOUCH_POSITION_GAP);
      this.touches = [firstTouchObj, secondTouchObj];
    } else {
      this.touches = [firstTouchObj];
    }
    this.changedTouches = [firstTouchObj];
  }

  getHistoricalPoints(): HistoricalPoint[] {
    let historicalPoint: MockHistoricalPoint[] = [];
    return historicalPoint;
  }

  preventDefault(): void {    
  };
}

export class MockFingerInfo implements FingerInfo {
  id: number = 0;
  globalX: number;
  globalY: number;
  localX: number;
  localY: number;
  displayX: number;
  displayY: number

  constructor(positionX: number, positionY: number) {
    this.globalX = positionX;
    this.globalY = positionY;
    this.localX = positionX;
    this.localY = positionY;
    this.displayX = positionX;
    this.displayY = positionY
  }
}

export class MockGestureEvent implements GestureEvent {
  repeat: boolean = false;
  fingerList: FingerInfo[];
  offsetX: number = 0;
  offsetY: number = 0;
  angle: number = 0;
  speed: number = 0;
  scale: number = 1;
  pinchCenterX: number;
  pinchCenterY: number;
  velocityX: number = 0;
  velocityY: number = 0;
  velocity: number = 0;
  target: EventTarget = new MockEventTarget();
  timestamp: number = 0;
  source: SourceType = SourceType.TouchScreen;
  pressure: number = 0;
  tiltX: number = 0;
  tiltY: number = 0;
  sourceTool: SourceTool = SourceTool.Finger;

  constructor(fingerFirst: MockFingerInfo, fingerSecond: MockFingerInfo) {
    this.fingerList = [fingerFirst, fingerSecond];
    this.pinchCenterX = (fingerFirst.globalX + fingerSecond.globalX) / 2;
    this.pinchCenterY = (fingerFirst.globalY + fingerSecond.globalY) / 2;
  }
}
