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
import { SCBScreenProperty, SCBSessionRect } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ArgumentMatchers, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  SCBMultiWindowUtils
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import {
  Constants,
  PipRectUpdateReason
} from '../../../../main/ets/SceneBoard/scenemanager/pip/utils/PictureInPictureConstants';
import { PipRectCalculator,
  ScaleLevel,
  Pivot } from '../../../../main/ets/SceneBoard/scenemanager/pip/utils/PiPUtils';


let rectCalculator: PipRectCalculator = new PipRectCalculator();
let mocker: MockKit = new MockKit();

export function PiPUtilsTest() {
  describe('PiPUtilsTest_001', () => {
    setIsMovingTest_01();
    isMoveOrDragTest_01();
    isExpandedTest_01();
    updatePipRectPivotInfoTest_01();
    getScaleLevelIntTest_01();
    saveScaleLevelTest_01();
    updateQuadrantAndPosTest_01();
    savePipPositionTest_01();
    updatePipRectTest_01();
    getScalePivotTest_01();
    getRectByPivotTest_01();
    isSquareTest_01();
    calcWinRectLandTest_01();
    getWidthByLandScreenWidthTest_01();
    calcWinRectForPadTest_01();
    getRectOnNormalScaleTest_01();
    getRectByScaleTest_01();
    initPipRectInfoTest_01();
    updateRectPositionTest_01();
    calcNewPipRectTest_01();
    fixRectSizeIfNeededTest_01();
    fixRectPositionIfNeededTest_01();
    updatePipRectInnerTest_01();
    judgeObtainOldPosition_01();
    getGridRowWidthTest_01();
    fixRectIfNeededTest_01();
  });
}

function setIsMovingTest_01() {
  it('setIsMovingTest_001', Level.LEVEL0, (): void => {
    rectCalculator.setIsMoving(true);
    expect(rectCalculator.isMoveOrDrag()).assertTrue();
  });
}

function getGridRowWidthTest_01() {
  it('getGridRowWidthTest_001', Level.LEVEL0, (): void => {
    let gridCount: number = 0;
    rectCalculator.getGridRowWidth(1, gridCount, 10);
    gridCount = 10;
    rectCalculator.getGridRowWidth(1, gridCount, 10);
  });
}

function judgeObtainOldPosition_01() {
  it('judgeObtainOldPosition_001', Level.LEVEL0, (): void => {
    let flag = rectCalculator.judgeObtainOldPosition(PipRectUpdateReason.REASON_PIP_EXPAND);
    expect(flag).assertFalse();
    flag = rectCalculator.judgeObtainOldPosition(PipRectUpdateReason.REASON_PIP_FOLD);
    expect(flag).assertFalse();
  });
}

function isExpandedTest_01() {
  it('isExpandedTest_001', Level.LEVEL0, () => {
    let fun_01 : Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
    let reason = PipRectUpdateReason.REASON_PIP_EXPAND;
    when(fun_01)(ArgumentMatchers.any).afterReturn(true);
    expect(rectCalculator.isExpanded(reason)).assertTrue();
    when(fun_01)(ArgumentMatchers.any).afterReturn(false);
    expect(rectCalculator.isExpanded(reason)).assertFalse();
    mocker.clear(fun_01);
  });
}

function updatePipRectPivotInfoTest_01() {
  it('updatePipRectPivotInfoTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 100, 100);
    let res: boolean = true;
    rectCalculator.updatePipRectPivotInfo(rect, 1260, 2720);
    expect(res).assertTrue();
  });
}

function isMoveOrDragTest_01() {
  it('isMoveOrDragTest_001', Level.LEVEL0, () => {
    rectCalculator.setIsMoving(false);
    expect(rectCalculator.isMoveOrDrag()).assertFalse();
  });
}

function getScaleLevelIntTest_01() {
  it('getScaleLevelIntTest_001', Level.LEVEL0, () => {
    rectCalculator.sizeInfo.scaleLevel = 0;
    expect(rectCalculator.getScaleLevelInt()).assertEqual(1);
    rectCalculator.sizeInfo.scaleLevel = 1;
    expect(rectCalculator.getScaleLevelInt()).assertEqual(2);
    rectCalculator.sizeInfo.scaleLevel = 2;
    expect(rectCalculator.getScaleLevelInt()).assertEqual(3);
  });
}

function saveScaleLevelTest_01() {
  it('saveScaleLevelTest_001', Level.LEVEL0, () => {
    rectCalculator.saveScaleLevel();
    expect(AppStorage.get(Constants.KEY_PIP_SCALE)).assertLargerOrEqual(0);
  });
}

function savePipPositionTest_01() {
  it('savePipPositionTest_001', Level.LEVEL0, () => {
    rectCalculator.savePipPositionAndLevel(1, 1);
    expect(AppStorage.get(Constants.KEY_PIP_WINDOW_POS_X)).assertEqual(1);
    expect(AppStorage.get(Constants.KEY_PIP_WINDOW_POS_Y)).assertEqual(1);
  });
}

function updateQuadrantAndPosTest_01() {
  it('updateQuadrantAndPosTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.updateQuadrantAndPos(rect, 100, 100);
    rect = new SCBSessionRect(50, 0, 50, 50);
    rectCalculator.updateQuadrantAndPos(rect, 100, 100);
    rect = new SCBSessionRect(0, 50, 50, 50);
    rectCalculator.updateQuadrantAndPos(rect, 100, 100);
    rect = new SCBSessionRect(0, 50, 50, 60);
    rectCalculator.updateQuadrantAndPos(rect, 100, 100);
    expect(rect).not().assertNull();
  });
}

function updatePipRectTest_01() {
  it('updatePipRectTest_001', Level.LEVEL0, () => {
    let originRect: SCBSessionRect = new SCBSessionRect(0, 0, 800, 600);
    let screenProp: SCBScreenProperty = new SCBScreenProperty();
    let res = rectCalculator.updatePipRect(originRect, PipRectUpdateReason.REASON_PIP_START, screenProp);
    expect(res).not().assertNull();

    res = rectCalculator.updatePipRect(originRect, PipRectUpdateReason.REASON_PIP_SCALE_CHANGE, screenProp);
    expect(res).not().assertNull();

    res = rectCalculator.updatePipRect(originRect, PipRectUpdateReason.REASON_PIP_RATIO_CHANGE, screenProp);
    expect(res).not().assertNull();

    res = rectCalculator.updatePipRect(originRect, PipRectUpdateReason.REASON_ROTATION_CHANGE, screenProp);
    expect(res).not().assertNull();
  });
}

function getRectByPivotTest_01() {
  it('getRectByPivotTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let originRect: SCBSessionRect = new SCBSessionRect(50, 30, 50, 50);
    rectCalculator.sizeInfo.pivot.pivotX = 1;
    rectCalculator.sizeInfo.pivot.pivotY = 1;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rect = new SCBSessionRect(50, 30, 50, 50);
    originRect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rect = new SCBSessionRect(50, 30, 50, 50);
    originRect = new SCBSessionRect(50, 30, 50, 50);
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 2;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 3;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 0;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotX = 2;
    rectCalculator.sizeInfo.pivot.pivotY = 1;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 2;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 3;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 0;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotX = 3;
    rectCalculator.sizeInfo.pivot.pivotY = 1;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 2;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 3;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 0;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotX = 0;
    rectCalculator.sizeInfo.pivot.pivotY = 1;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 2;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 3;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
    rectCalculator.sizeInfo.pivot.pivotY = 0;
    rectCalculator.getRectByPivot(rect, originRect, 100, 100, rectCalculator.sizeInfo.pivot);
  });
}

function getScalePivotTest_01() {
  it('getScalePivotTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.getScalePivot(rect, 100, 100);
    rect = new SCBSessionRect(30, 50, 50, 50);
    rectCalculator.getScalePivot(rect, 100, 100);
    rect = new SCBSessionRect(25, 50, 50, 50);
    rectCalculator.getScalePivot(rect, 100, 100);

    rect = new SCBSessionRect(50, 30, 50, 50);
    rectCalculator.getScalePivot(rect, 100, 100);
    rect = new SCBSessionRect(50, 20, 50, 50);
    rectCalculator.getScalePivot(rect, 100, 100);
    rect = new SCBSessionRect(50, 25, 50, 50);
    rectCalculator.getScalePivot(rect, 100, 100);
  });
}

function isSquareTest_01() {
  it('isSquareTest_001', Level.LEVEL0, () => {
    rectCalculator.sizeInfo.originWidth = 0;
    rectCalculator.sizeInfo.originHeight = 1;
    expect(rectCalculator.isSquare()).assertFalse();
    rectCalculator.sizeInfo.originWidth = 2;
    rectCalculator.sizeInfo.originHeight = 0;
    expect(rectCalculator.isSquare()).assertFalse();
    rectCalculator.sizeInfo.originWidth = 1;
    rectCalculator.sizeInfo.originHeight = 2;
    expect(rectCalculator.isSquare()).assertFalse();
  });
}

function getWidthByLandScreenWidthTest_01() {
  it('getWidthByLandScreenWidthTest_001', Level.LEVEL0, () => {
    let landScreenWidth: number = 840;
    let occupiedGrid: number = 2;
    rectCalculator.getWidthByLandScreenWidth(landScreenWidth, occupiedGrid);
    landScreenWidth = 600;
    occupiedGrid = 3;
    rectCalculator.getWidthByLandScreenWidth(landScreenWidth, occupiedGrid);
    landScreenWidth = 300;
    occupiedGrid = 1;
    rectCalculator.getWidthByLandScreenWidth(landScreenWidth, occupiedGrid);
  });
}

function calcWinRectLandTest_01() {
  it('calcWinRectLandTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    rect = rectCalculator.calcWinRectLand(100, 100, 0, 100);
    expect(rect.isEmpty()).assertTrue();
    rect = rectCalculator.calcWinRectLand(100, 100, 100, 0);
    expect(rect.isEmpty()).assertTrue();

    rect = rectCalculator.calcWinRectLand(100, 100, 50, 100);
    rectCalculator.sizeInfo.originWidth = 1;
    rectCalculator.sizeInfo.originHeight = 2;
    expect(rect.isEmpty()).assertFalse();

    rect = rectCalculator.calcWinRectLand(100, 100, 100, 50);
    expect(rect.isEmpty()).assertFalse();
  });
}

function calcWinRectForPadTest_01() {
  it('calcWinRectForPadTest_001', Level.LEVEL0, () => {
    let sourceRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let width: number = 0;
    let height: number = 0;
    let scaleLevel = ScaleLevel.SCALE_LEVEL_NORMAL;
    expect(rectCalculator.calcWinRectForPad(width, height, sourceRect, scaleLevel)).assertEqual(sourceRect);
    sourceRect = new SCBSessionRect(0, 0, 0, 100);
    expect(rectCalculator.calcWinRectForPad(width, height, sourceRect, scaleLevel)).assertEqual(sourceRect);
    sourceRect = new SCBSessionRect(200, 200, 0, 0);
    width = 400;
    height = 600;
    let result = rectCalculator.calcWinRectForPad(width, height, sourceRect, scaleLevel);
    expect(result.width.getPx()).assertEqual(0);
    expect(result.height.getPx()).assertEqual(0);
    scaleLevel = ScaleLevel.SCALE_LEVEL_LARGE;
    result = rectCalculator.calcWinRectForPad(width, height, sourceRect, scaleLevel);
    expect(result.width.getPx()).assertEqual(0);
    expect(result.height.getPx()).assertEqual(0);
  });
}

function getRectByScaleTest_01() {
  it('getRectByScaleTest_001', Level.LEVEL0, () => {
    let sourceRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let scaleLevel = ScaleLevel.SCALE_LEVEL_NORMAL;
    let reason = PipRectUpdateReason.REASON_PIP_START;
    let result = rectCalculator.getRectByScale(100, 100, scaleLevel, sourceRect, reason);
    expect(result).assertEqual(sourceRect);
    sourceRect = new SCBSessionRect(0, 0, 100, 100);
    let fun_01 : Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isSupportLargeScreenMultiWindow);
    when(fun_01)(ArgumentMatchers.any).afterReturn(false);
    sourceRect = new SCBSessionRect(0, 100, 0, 100);
    result = rectCalculator.getRectByScale(100, 100, scaleLevel, sourceRect, reason);
    expect(result).assertEqual(sourceRect);
    sourceRect = new SCBSessionRect(0, 100, 100, 0);
    result = rectCalculator.getRectByScale(100, 100, scaleLevel, sourceRect, reason);
    expect(result).assertEqual(sourceRect);

    sourceRect = new SCBSessionRect(0, 100, 100, 100);
    let rect: SCBSessionRect = sourceRect.copy();
    let fun_02 : Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
    when(fun_02)(ArgumentMatchers.any).afterReturn(true);
    rectCalculator.getRectOnNormalScale(100, 100, sourceRect, rect, reason);
    result = rectCalculator.getRectByScale(100, 100, scaleLevel, sourceRect, reason);
    mocker.clear(fun_01);
    mocker.clear(fun_02);
  });
}

function getRectOnNormalScaleTest_01() {
  it('getRectOnNormalScaleTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 100, 100);
    let sourceRect: SCBSessionRect = new SCBSessionRect(0, 0, 100, 100);
    rectCalculator.sizeInfo.originWidth = 1;
    rectCalculator.sizeInfo.originHeight = 2;
    let reason = PipRectUpdateReason.REASON_PIP_START;
    rectCalculator.getRectOnNormalScale(100, 100, sourceRect, rect, reason);
    sourceRect = new SCBSessionRect(0, 0, 100, 200);
    rectCalculator.getRectOnNormalScale(100, 100, sourceRect, rect, reason);
    sourceRect = new SCBSessionRect(0, 0, 300, 200);
    rectCalculator.getRectOnNormalScale(100, 100, sourceRect, rect, reason);
  });
}

function updateRectPositionTest_01() {
  it('updateRectPositionTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.updateRectPosition(rect, 100, 100);
    rect = new SCBSessionRect(0, 0, 0, 100);
    rectCalculator.quadrantX = 0;
    rectCalculator.updateRectPosition(rect, 100, 100);
    rectCalculator.quadrantX = 1;
    rectCalculator.quadrantY = 0;
    rectCalculator.updateRectPosition(rect, 100, 100);
    rectCalculator.quadrantY = 1;
    rectCalculator.updateRectPosition(rect, 100, 100);
  });
}

function initPipRectInfoTest_01() {
  it('initPipRectInfoTest_001', Level.LEVEL0, () => {
    let requestRct: SCBSessionRect = new SCBSessionRect(0, 0, 0, 100);
    expect(rectCalculator.initPipRectInfo(requestRct)).assertFalse();
    requestRct = new SCBSessionRect(0, 0, 100, 0);
    expect(rectCalculator.initPipRectInfo(requestRct)).assertFalse();
    requestRct = new SCBSessionRect(0, 0, 100, 100);
    expect(rectCalculator.initPipRectInfo(requestRct)).assertTrue();
  });
}

function calcNewPipRectTest_01() {
  it('calcNewPipRectTest_001', Level.LEVEL0, () => {
    let sourceRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 100);
    let reason = PipRectUpdateReason.REASON_PIP_RATIO_CHANGE;
    let isLandscape: boolean = true;
    let rect: SCBSessionRect = rectCalculator.getRectByScale(
      100, 100, ScaleLevel.SCALE_LEVEL_LARGE, sourceRect, reason);
    let result = rectCalculator.calcNewPipRect(100, 100, sourceRect, isLandscape, reason);
    rectCalculator.updateRectPosition(rect, 100, 100);
    expect(result).assertEqual(rect);
    reason = PipRectUpdateReason.REASON_PIP_DESTROY;
    rect = new SCBSessionRect(0, 0, 100, 100);
    rectCalculator.isMoving = false;
    rectCalculator.sizeInfo.pivot.pivotX = Pivot.UNDEFINED;
    rectCalculator.getScalePivot(rect, 100, 100);
    result =  rectCalculator.calcNewPipRect(100, 100, sourceRect, isLandscape, reason);
  });
}

function fixRectPositionIfNeededTest_01() {
  it('fixRectPositionIfNeededTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.fixRectPositionIfNeeded(rect, 100, 100);
    rect = new SCBSessionRect(0, 0, 0, 100);
    rectCalculator.fixRectPositionIfNeeded(rect, 100, 100);
    rect = new SCBSessionRect(20, 0, 100, 100);
    rectCalculator.fixRectPositionIfNeeded(rect, 100, 100);
    rect = new SCBSessionRect(20, 100, 100, 100);
    rectCalculator.fixRectPositionIfNeeded(rect, 200, 100);
    rect = new SCBSessionRect(200, 100, 100, 100);
    rectCalculator.fixRectPositionIfNeeded(rect, 200, 200);
    rectCalculator.fixRectPositionIfNeeded(rect, 200, 400);
  });
}

function fixRectSizeIfNeededTest_01() {
  it('fixRectSizeIfNeededTest_001', Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let isLandscape: boolean = true;
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 100, isLandscape);
    rect = new SCBSessionRect(0, 0, 0, 100);
    let fun_01 : Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isSupportLargeScreenMultiWindow);
    when(fun_01)(ArgumentMatchers.any).afterReturn(true);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 100, isLandscape);
    when(fun_01)(ArgumentMatchers.any).afterReturn(false);
    let fun_02 : Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
    when(fun_02)(ArgumentMatchers.any).afterReturn(true);
    let fun_03 : Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isFoldableDeviceFolded);
    when(fun_03)(ArgumentMatchers.any).afterReturn(false);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 100, isLandscape);
    when(fun_02)(ArgumentMatchers.any).afterReturn(false);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 100, isLandscape);
    isLandscape = false;
    rect = new SCBSessionRect(0, 0, 100, 100);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 100, isLandscape);
    rect = new SCBSessionRect(0, 0, 100, 25);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 100, isLandscape);
    isLandscape = true;
    rect = new SCBSessionRect(0, 0, 100, 100);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 330, isLandscape);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 450, isLandscape);
    rect = new SCBSessionRect(0, 0, 90, 100);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 450, isLandscape);
    rect = new SCBSessionRect(0, 0, 100, 30);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 450, isLandscape);
    rect = new SCBSessionRect(0, 0, 100, 60);
    rectCalculator.fixRectSizeIfNeeded(rect, 100, 450, isLandscape);
    mocker.clear(fun_01);
    mocker.clear(fun_02);
    mocker.clear(fun_03);
  });
}

function fixRectIfNeededTest_01() {
  it('fixRectIfNeededTest_001', Level.LEVEL0, (): void => {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    rectCalculator.fixRectIfNeeded(rect);
    rect = new SCBSessionRect(0, 0, 100, 100);
    rectCalculator.fixRectIfNeeded(rect);
  });
}

function updatePipRectInnerTest_01() {
  it('updatePipRectInnerTest_001', Level.LEVEL0, () => {
    let reason = PipRectUpdateReason.REASON_PIP_MOVE;
    let screenProp: SCBScreenProperty = new SCBScreenProperty();
    let mockFunc = mocker.mockFunc(rectCalculator, rectCalculator.judgeObtainOldPosition);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    rectCalculator.updatePipRectInner(reason, screenProp);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    rectCalculator.updatePipRectInner(reason, screenProp);
    reason = PipRectUpdateReason.REASON_PIP_RATIO_CHANGE;
    rectCalculator.updatePipRectInner(reason, screenProp);
    mocker.clear(rectCalculator);
  });
}