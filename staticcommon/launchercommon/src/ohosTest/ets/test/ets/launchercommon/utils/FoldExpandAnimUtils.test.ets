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
  LayoutViewModel,
  DockItemInfo,
  GridLayoutItemInfo
} from '../../../../../../main/ets/TsIndex';
import { FoldExpandAnimUtils, FoldAnimationConstants } from '../../../../../../../Index';
import { describe, it, expect, Level, beforeAll, MockKit, ArgumentMatchers, when } from '@ohos/hypium';
import { RectInfo } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { ReflectionUtils } from './ReflectionUtils';
import curves from '@ohos.curves';

let screenWidth: number;
let screenHeight: number;
let rectInfo: RectInfo = new RectInfo();
let info1: DockItemInfo;
let info2: DockItemInfo;
let initAll = () => {
  screenWidth = 1000;
  screenHeight = 1000;
  rectInfo.left = 0;
  rectInfo.right = 10;
  rectInfo.top = 0;
  rectInfo.bottom = 0;
  info1 = {
    visible: false,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appName: '',
    appIconId: 0,
    bundleName: '',
    abilityName: '',
    keyName: 'anyKeyName_0'
  };
  info2 = {
    visible: false,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appName: '',
    appIconId: 1,
    bundleName: '',
    abilityName: '',
    keyName: 'anyKeyName_1'
  };
}

export default function FoldExpandAnimUtilsTest() {
  beforeAll(initAll);
  initItemTransXTest();
  initItemTransYTest();
  getFoldExpandDelayTimeTest();
  getMidColOrRowAlphaDelayOffsetTimeTest();
  isMiddleColTest();
  isMiddleRowTest();
  getDockExpandAnimDelayTest();
  getDockFoldAnimDelayTest();
  getFoldExpandAnimScaleTest();
  getIconExpandAnimCurveTest();
  getDockItemExpandAnimCurveTest();
  getIconFoldedAnimCurveTest();
  getSwiperPageColumnsTest();
  getSwiperPageRowsTest();
  getBackPlaneAnimScaleTest();
  getDockColumnTest();
  getIndicatorAnimDelayTest();
  initIndicatorTransXTest();
  initIndicatorTransYTest();
  initIndicatorScaleTest();
  getIndicatorExpandAnimParamTest();
  getIndicatorAlphaAnimParamTest();
  getIndicatorTranslateCurveTest();
  getStatusBarTranslateXTest();
  getStatusBarStartOpacityTest();
  getStatusBarAlphaAnimParamTest();
  getIconOrDockBgAlphaAnimParamTest();
  getDockBgPanelScaleCurveTest();
  getDockBgExpandAnimStartTranslateXTest();
  getDockBgExpandAnimStartScaleSizeTest();
  getRecentBgDelayTest();
}

function initItemTransXTest() {
  describe('initItemTransXTest', (): void => {
    it('initItemTransXTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let tranX: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.TRANS_EDGE * screenWidth,
        FoldAnimationConstants.TRANS_MID * screenWidth, 0);
      expect(FoldExpandAnimUtils.initItemTransX(0, 8, 0, screenWidth, true)).assertEqual(tranX);
    })
    it('initItemTransXTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let tranX: number = -FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.TRANS_EDGE * screenWidth,
        FoldAnimationConstants.TRANS_MID * screenWidth, 0);
      expect(FoldExpandAnimUtils.initItemTransX(7, 8, 0, screenWidth, true)).assertEqual(tranX);
    })
    it('initItemTransXTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let transX: number = -FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.FOLD_TRANS_EDGE * screenWidth,
        FoldAnimationConstants.FOLD_TRANS_MID * screenWidth, 0);
      expect(FoldExpandAnimUtils.initItemTransX(0, 4, 0, screenWidth, false)).assertEqual(transX);
    })
    it('initItemTransXTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initItemTransX(0, 4, 0, screenWidth, true)).assertEqual(0);
    })
    it('initItemTransXTest_05', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let transX: number = 10;
      expect(FoldExpandAnimUtils.initItemTransX(0, 4, transX, screenWidth, false)).assertEqual(transX);
    })
  })
}

function initItemTransYTest() {
  describe('initItemTransYTest', (): void => {
    it('initItemTransYTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initItemTransY(0, screenHeight)).assertEqual(0);
    })
    it('initItemTransYTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let transY: number =
        FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.TRANS_EDGE_FACTOR * screenHeight,
        FoldAnimationConstants.TRANS_MID_FACTOR * screenHeight, 0);
      expect(FoldExpandAnimUtils.initItemTransY(0, screenHeight)).assertEqual(transY);
    })
    it('initItemTransYTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let transY: number =
        -FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.TRANS_EDGE_FACTOR * screenHeight,
          FoldAnimationConstants.TRANS_MID_FACTOR * screenHeight, 0);
      expect(FoldExpandAnimUtils.initItemTransY(5, screenHeight)).assertEqual(transY);
    })
    it('initItemTransYTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.initItemTransY(0, screenHeight)).assertEqual(0);
    })
  })
}

function getFoldExpandDelayTimeTest() {
  describe('getFoldExpandDelayTimeTest', (): void => {
    it('getFoldExpandDelayTimeTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 0);
      expect(FoldExpandAnimUtils.getFoldExpandDelayTime(0, 0, 8, true)).assertEqual(delay);
    })
    it('getFoldExpandDelayTimeTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number =
        FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.DELAY_EDGE, FoldAnimationConstants.DELAY_MID, 0);
      expect(FoldExpandAnimUtils.getFoldExpandDelayTime(0, 0, 4, false)).assertEqual(delay);
    })
    it('getFoldExpandDelayTimeTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 0);
      expect(FoldExpandAnimUtils.getFoldExpandDelayTime(0, 0, 4, true)).assertEqual(delay);
    })
    it('getFoldExpandDelayTimeTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 0);
      expect(FoldExpandAnimUtils.getFoldExpandDelayTime(5, 0, 4, true)).assertEqual(delay);
    })
    it('getFoldExpandDelayTimeTest_05', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let delayFactor: number = FoldAnimationConstants.EXPAND_DELAY;
      let delay: number = (8 - 1) * delayFactor / (8 - 1);
      expect(FoldExpandAnimUtils.getFoldExpandDelayTime(0, 0, 8, true)).assertEqual(delay);
    })
    it('getFoldExpandDelayTimeTest_06', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let delayFactor: number = FoldAnimationConstants.FOLD_DELAY;
      let delay: number = (4 - 1) * delayFactor / (4 - 1);
      expect(FoldExpandAnimUtils.getFoldExpandDelayTime(0, 0, 4, false)).assertEqual(delay);
    })
  })
}

function getMidColOrRowAlphaDelayOffsetTimeTest() {
  describe('getMidColOrRowAlphaDelayOffsetTimeTest', () => {
    it('getMidColOrRowAlphaDelayOffsetTimeTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let offsetTime: number = FoldAnimationConstants.MIDDLE_DELAY;
      expect(FoldExpandAnimUtils.getMidColOrRowAlphaDelayOffsetTime(0, 3)).assertEqual(offsetTime);
    })
    it('getMidColOrRowAlphaDelayOffsetTimeTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getMidColOrRowAlphaDelayOffsetTime(0, 0)).assertEqual(0);
    })
    it('getMidColOrRowAlphaDelayOffsetTimeTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getMidColOrRowAlphaDelayOffsetTime(0, 0)).assertEqual(0);
    })
    it('getMidColOrRowAlphaDelayOffsetTimeTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getMidColOrRowAlphaDelayOffsetTime(0, 0)).assertEqual(0);
    })
  })
}

function isMiddleColTest() {
  describe('isMiddleColTest', (): void => {
    it('isMiddleColTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.isMiddleCol(3, 8)).assertEqual(true);
    })
    it('isMiddleColTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.isMiddleCol(0, 8)).assertEqual(false);
    })
    it('isMiddleColTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.isMiddleCol(2, 6)).assertEqual(false);
    })
    it('isMiddleColTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.isMiddleCol(1, 4)).assertEqual(false);
    })
  })
}

function isMiddleRowTest() {
  describe('isMiddleRowTest', (): void => {
    it('isMiddleRowTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.isMiddleRow(3, 8)).assertEqual(false);
    })
    it('isMiddleRowTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.isMiddleRow(0, 6)).assertEqual(false);
    })
    it('isMiddleRowTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.isMiddleRow(1, 4)).assertEqual(false);
    })
  })
}

function getDockExpandAnimDelayTest() {
  describe('getDockExpandAnimDelayTest', (): void => {
    it('getDockExpandAnimDelayTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 1);
      expect(FoldExpandAnimUtils.getDockExpandAnimDelay(rectInfo, screenWidth, 0, 6)).assertEqual(delay);
    })
    it('getDockExpandAnimDelayTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 3);
      expect(FoldExpandAnimUtils.getDockExpandAnimDelay(rectInfo, screenWidth, 3, 6)).assertEqual(delay);
    })
    it('getDockExpandAnimDelayTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 3);
      expect(FoldExpandAnimUtils.getDockExpandAnimDelay(rectInfo, screenWidth, 2, 6)).assertEqual(delay);
    })
    it('getDockExpandAnimDelayTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 0);
      expect(FoldExpandAnimUtils.getDockExpandAnimDelay(rectInfo, screenWidth, 0, 4)).assertEqual(delay);
    })
    it('getDockExpandAnimDelayTest_05', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let delay: number = (screenWidth - rectInfo.right + (rectInfo.right - rectInfo.left) / 2) / screenWidth *
        FoldAnimationConstants.EXPAND_DELAY;
      expect(FoldExpandAnimUtils.getDockExpandAnimDelay(rectInfo, screenWidth, 2, 6)).assertEqual(delay);
    })
  })
}

function getDockFoldAnimDelayTest() {
  describe('getDockFoldAnimDelayTest', (): void => {
    it('getDockFoldAnimDelayTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 0);
      expect(FoldExpandAnimUtils.getDockFoldAnimDelay(0, 4)).assertEqual(delay);
    })
    it('getDockFoldAnimDelayTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delay: number = FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, 1);
      expect(FoldExpandAnimUtils.getDockFoldAnimDelay(0, 2)).assertEqual(delay);
    })
    it('getDockFoldAnimDelayTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getDockFoldAnimDelay(0, 2)).assertEqual(0);
    })
    it('getDockFoldAnimDelayTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().calculateDesktop);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(4);
      let delay: number = (4 - 1) * FoldAnimationConstants.FOLD_DELAY / (4 - 1);
      expect(FoldExpandAnimUtils.getDockFoldAnimDelay(0, 2)).assertEqual(delay);
      mocker.clear(LayoutViewModel.getInstance());
      mocker.clearAll();
    })
  })
}

function getFoldExpandAnimScaleTest() {
  describe('getFoldExpandAnimScaleTest', (): void => {
    it('getFoldExpandAnimScaleTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
    expect(FoldExpandAnimUtils.getFoldExpandAnimScale()).assertEqual(FoldAnimationConstants.START_SCALE);
    })
    it('getFoldExpandAnimScaleTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getFoldExpandAnimScale()).assertEqual(FoldAnimationConstants.START_SCALE);
    })
    it('getFoldExpandAnimScaleTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getFoldExpandAnimScale()).assertEqual(1);
    })
  })
}

function getIconExpandAnimCurveTest() {
  describe('getIconExpandAnimCurveTest', (): void => {
    it('getIconExpandAnimCurveTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE,
        FoldAnimationConstants.RESPONSE_MID, 0);
      let curve: ICurve = FoldExpandAnimUtils.getIconExpandAnimCurve(0, 0);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getIconExpandAnimCurveTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE,
        FoldAnimationConstants.RESPONSE_MID, 0);
      let curve: ICurve = FoldExpandAnimUtils.getIconExpandAnimCurve(0, 8);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getIconExpandAnimCurveTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE_SMALL_FOLD,
        FoldAnimationConstants.RESPONSE_MID_SMALL_FOLD, 0);
      let curve: ICurve = FoldExpandAnimUtils.getIconExpandAnimCurve(0, 0);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getIconExpandAnimCurveTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE_SMALL_FOLD,
        FoldAnimationConstants.RESPONSE_MID_SMALL_FOLD, 0);
      let curve: ICurve = FoldExpandAnimUtils.getIconExpandAnimCurve(6, 8);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getIconExpandAnimCurveTest_05', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let curve: ICurve = FoldExpandAnimUtils.getIconExpandAnimCurve(0, 8);
      expect(curve).assertEqual(FoldAnimationConstants.TRANSLATE_CURVES);
    })
  })
}

function getDockItemExpandAnimCurveTest() {
  describe('getDockItemExpandAnimCurveTest', (): void => {
    it('getDockItemExpandAnimCurveTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE,
        FoldAnimationConstants.RESPONSE_MID, 0);
      let curve: ICurve = FoldExpandAnimUtils.getDockItemExpandAnimCurve(0, 8);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getDockItemExpandAnimCurveTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE,
        FoldAnimationConstants.RESPONSE_MID, 3);
      let curve: ICurve = FoldExpandAnimUtils.getDockItemExpandAnimCurve(2, 6);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getDockItemExpandAnimCurveTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let response: number = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE_SMALL_FOLD,
        FoldAnimationConstants.RESPONSE_MID_SMALL_FOLD, 0);
      let curve: ICurve = FoldExpandAnimUtils.getDockItemExpandAnimCurve(0, 4);
      expect(curve.interpolate(0)).assertEqual(curves.springMotion(response, 1, 0).interpolate(0));
    })
    it('getDockItemExpandAnimCurveTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let curve: ICurve = FoldExpandAnimUtils.getDockItemExpandAnimCurve(0, 8);
      expect(curve).assertEqual(FoldAnimationConstants.TRANSLATE_CURVES);
    })
  })
}

function getIconFoldedAnimCurveTest() {
  describe('getIconFoldedAnimCurveTest', (): void => {
    it('getIconFoldedAnimCurveTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getIconFoldedAnimCurve()).assertEqual(FoldAnimationConstants.ITEM_FOLD_CURVE);
    })
    it('getIconFoldedAnimCurveTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getIconFoldedAnimCurve()).assertEqual(FoldAnimationConstants.TRANSLATE_CURVES);
    })
  });
}

function getSwiperPageColumnsTest() {
  describe('getSwiperPageColumnsTest', (): void => {
    it('getSwiperPageColumnsTest_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.area = [2, 2];
      expect(FoldExpandAnimUtils.getSwiperPageColumns(item, 0, 4)).assertEqual(1.5);
      expect(FoldExpandAnimUtils.getSwiperPageColumns(item, 1, 4)).assertEqual(5.5);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
    })
    it('getSwiperPageColumnsTest_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.area = [2, 2];
      expect(FoldExpandAnimUtils.getSwiperPageColumns(item, 0, 4)).assertEqual(1.5);
      item.area = [4, 2];
      expect(FoldExpandAnimUtils.getSwiperPageColumns(item, 0, 4)).assertEqual(2.5);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
    })
  })
}

function getSwiperPageRowsTest() {
  describe('getSwiperPageRowsTest', (): void => {
    it('getSwiperPageRowsTest_01', Level.LEVEL0, (): void => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.area = [1, 1];
      expect(FoldExpandAnimUtils.getSwiperPageRows(item)).assertEqual(1);
      item.area = [2, 1];
      expect(FoldExpandAnimUtils.getSwiperPageRows(item)).assertEqual(1);
      item.area = [2, 2];
      expect(FoldExpandAnimUtils.getSwiperPageRows(item)).assertEqual(1.5);
      item.area = [4, 2];
      expect(FoldExpandAnimUtils.getSwiperPageRows(item)).assertEqual(1.5);
      item.area = [4, 4];
      expect(FoldExpandAnimUtils.getSwiperPageRows(item)).assertEqual(2.5);
      item.area = [4, 6];
      expect(FoldExpandAnimUtils.getSwiperPageRows(item)).assertEqual(3.5);
    })
  })
}

function getBackPlaneAnimScaleTest() {
  describe('getBackPlaneAnimScaleTest', (): void => {
    it('getBackPlaneAnimScaleTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let dockWidth: number = 100;
      expect(FoldExpandAnimUtils.getBackPlaneAnimScale(dockWidth)).assertEqual(1);
    })
    it('getBackPlaneAnimScaleTest_02', Level.LEVEL0, (): void => {
      let dockWidth: number = 100;
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let scale: number = (dockWidth - FoldAnimationConstants.INIT_DOCK_BG_WIDTH) /
        FoldAnimationConstants.DIFF_DOCK_BG_WIDTH * FoldAnimationConstants.DIFF_DOCK_BG_SCALE + 2;
      expect(FoldExpandAnimUtils.getBackPlaneAnimScale(dockWidth)).assertEqual(scale);
    })
  })
}

function getDockColumnTest() {
  describe('getDockColumnTest', (): void => {
    it('getDockColumnTest_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([info1, info2]);
      expect(FoldExpandAnimUtils.getDockColumn(0, true)[0]).assertEqual(0);
      mocker.clear(AppStorage);
      mocker.clearAll();
    })
    it('getDockColumnTest_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([info1, info2]);
      expect(FoldExpandAnimUtils.getDockColumn(0, false)[0]).assertEqual(2);
      mocker.clear(AppStorage);
      mocker.clearAll();
    })
    it('getDockColumnTest_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      expect(FoldExpandAnimUtils.getDockColumn(0, true)[0]).assertEqual(0);
      mocker.clear(AppStorage);
      mocker.clearAll();
    })
  });
}

function getIndicatorAnimDelayTest() {
  describe('getIndicatorAnimDelayTest', (): void => {
    it('getIndicatorAnimDelayTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getIndicatorAnimDelay()).assertEqual(0);
    })
    it('getIndicatorAnimDelayTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delayTime: number =
        FoldExpandAnimUtils.getFoldExpandDelayTime(FoldAnimationConstants.INDICATOR_ROW, 0, 0, true);
      expect(FoldExpandAnimUtils.getIndicatorAnimDelay()).assertEqual(delayTime);
    })
    it('getIndicatorAnimDelayTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getIndicatorAnimDelay()).assertEqual(FoldAnimationConstants.EXPAND_DELAY / 2);
    })
  });
}

function initIndicatorTransXTest() {
  describe('initIndicatorTransXTest', (): void => {
    it('initIndicatorTransXTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initIndicatorTransX(screenWidth)).not().assertNull();
    })
    it('initIndicatorTransXTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initIndicatorTransX(screenWidth)).not().assertNull();
    })
    it('initIndicatorTransXTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let transX: number = FoldAnimationConstants.EXPAND_FACTOR * screenWidth;
      expect(FoldExpandAnimUtils.initIndicatorTransX(screenWidth)).assertEqual(transX);
    })
  });
}

function initIndicatorTransYTest() {
  describe('initIndicatorTransXTest', (): void => {
    it('initIndicatorTransYTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initIndicatorTransY(screenHeight)).assertEqual(0);
    })
    it('initIndicatorTransYTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let transY: number = FoldExpandAnimUtils.initItemTransY(FoldAnimationConstants.INDICATOR_ROW, screenHeight);
      expect(FoldExpandAnimUtils.initIndicatorTransY(screenHeight)).assertEqual(transY);
    })
    it('initIndicatorTransYTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.initIndicatorTransY(screenHeight)).assertEqual(0);
    })
  });
}

function initIndicatorScaleTest() {
  describe('initIndicatorScaleTest', (): void => {
    it('initIndicatorScaleTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initIndicatorScale()).assertEqual(FoldAnimationConstants.START_SCALE);
    })
    it('initIndicatorScaleTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.initIndicatorScale()).assertEqual(FoldAnimationConstants.START_SCALE);
    })
    it('initIndicatorScaleTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.initIndicatorScale()).assertEqual(1);
    })
  });
}

function getIndicatorExpandAnimParamTest() {
  describe('getIndicatorExpandAnimParamTest', (): void => {
    it('getIndicatorExpandAnimParamTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delayTime: number = FoldAnimationConstants.FOLD_DELAY / 2;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIndicatorExpandAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SCALE_CURVE);
    })
    it('getIndicatorExpandAnimParamTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let delayTime: number = FoldAnimationConstants.FOLD_DELAY / 2;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIndicatorExpandAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.TRANSLATE_CURVES);
    })
  });
}

function getIndicatorAlphaAnimParamTest() {
  describe('getIndicatorAlphaAnimParamTest', (): void => {
    it('getIndicatorAlphaAnimParamTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delayTime: number = FoldAnimationConstants.FOLD_DELAY / 2;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIndicatorAlphaAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SHARP_BEZIER_CURVE);
      expect(animateParam.duration).assertEqual(FoldAnimationConstants.INDICATOR_ALPHA_DURATION);
    })
    it('getIndicatorAlphaAnimParamTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let delayTime: number = FoldAnimationConstants.FOLD_DELAY / 2;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIndicatorAlphaAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SHARP_BEZIER_CURVE);
      expect(animateParam.duration).assertEqual(FoldAnimationConstants.ITEM_ALPHA_DURATION);
    })
    it('getIndicatorAlphaAnimParamTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let delayTime: number = FoldAnimationConstants.FOLD_DELAY / 2;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIndicatorAlphaAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.ALPHA_CURVES);
    })
  });
}

function getIndicatorTranslateCurveTest() {
  describe('getIndicatorTranslateCurveTest', (): void => {
    it('getIndicatorTranslateCurveTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getIndicatorTranslateCurve()).assertEqual(FoldAnimationConstants.INDICATOR_CURVE);
    })
    it('getIndicatorTranslateCurveTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getIndicatorTranslateCurve()).assertEqual(FoldAnimationConstants.TRANSLATE_CURVES);
    })
  });
}

function getStatusBarTranslateXTest() {
  describe('getStatusBarTranslateXTest', (): void => {
    it('getStatusBarTranslateXTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let factor: number = FoldAnimationConstants.FOLD_FACTOR;
      expect(FoldExpandAnimUtils.getStatusBarTranslateX(factor, screenWidth)).assertEqual(0);
    })
    it('getStatusBarTranslateXTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let factor: number = FoldAnimationConstants.EXPAND_FACTOR;
      expect(FoldExpandAnimUtils.getStatusBarTranslateX(factor, screenWidth)).assertEqual(0);
    })
    it('getStatusBarTranslateXTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let factor: number = FoldAnimationConstants.EXPAND_FACTOR;
      expect(FoldExpandAnimUtils.getStatusBarTranslateX(factor, screenWidth)).assertEqual(0);
    })
    it('getStatusBarTranslateXTest_04', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let factor: number = FoldAnimationConstants.FOLD_FACTOR;
      expect(FoldExpandAnimUtils.getStatusBarTranslateX(factor, screenWidth)).assertEqual(factor * screenWidth);
    })

    it('getStatusBarTranslateXTest_05', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let factor: number = FoldAnimationConstants.EXPAND_FACTOR;
      expect(FoldExpandAnimUtils.getStatusBarTranslateX(factor, screenWidth)).assertEqual(factor * screenWidth);
    })
  });
}

function getStatusBarStartOpacityTest() {
  describe('getStatusBarStartOpacityTest', (): void => {
    it('getStatusBarStartOpacityTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getStatusBarStartOpacity()).assertEqual(1);
    })
    it('getStatusBarStartOpacityTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getStatusBarStartOpacity()).assertEqual(1);
    })
    it('getStatusBarStartOpacityTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getStatusBarStartOpacity()).assertEqual(0);
    })
  });
}

function getStatusBarAlphaAnimParamTest() {
  describe('getStatusBarAlphaAnimParamTest', (): void => {
    it('getStatusBarAlphaAnimParamTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getStatusBarAlphaAnimParam();
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SHARP_BEZIER_CURVE);
      expect(animateParam.duration).assertEqual(FoldAnimationConstants.STATUS_BAR_ALPHA_DURATION);
      expect(animateParam.delay).assertEqual(FoldAnimationConstants.BAR_ALPHA_DELAY);
    })
    it('getStatusBarAlphaAnimParamTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getStatusBarAlphaAnimParam();
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SHARP_BEZIER_CURVE);
      expect(animateParam.duration).assertEqual(FoldAnimationConstants.STATUS_BAR_ALPHA_DURATION);
      expect(animateParam.delay).assertEqual(FoldAnimationConstants.BAR_ALPHA_DELAY);
    })
    it('getStatusBarAlphaAnimParamTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getStatusBarAlphaAnimParam();
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.ALPHA_CURVES);
    })
  });
}

function getIconOrDockBgAlphaAnimParamTest() {
  describe('getIconOrDockBgAlphaAnimParamTest', (): void => {
    it('getIconOrDockBgAlphaAnimParamTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let dockBgDelayFactor: number = (screenWidth - rectInfo.right) / screenWidth;
      let delayTime: number = dockBgDelayFactor * FoldAnimationConstants.EXPAND_DELAY;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SHARP_BEZIER_CURVE);
    })
    it('getIconOrDockBgAlphaAnimParamTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let dockBgDelayFactor: number = (screenWidth - rectInfo.right) / screenWidth;
      let delayTime: number = dockBgDelayFactor * FoldAnimationConstants.EXPAND_DELAY;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.SHARP_BEZIER_CURVE);
    })
    it('getIconOrDockBgAlphaAnimParamTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let dockBgDelayFactor: number = (screenWidth - rectInfo.right) / screenWidth;
      let delayTime: number = dockBgDelayFactor * FoldAnimationConstants.EXPAND_DELAY;
      let animateParam: AnimateParam = FoldExpandAnimUtils.getIconOrDockBgAlphaAnimParam(delayTime);
      expect(animateParam.curve).assertEqual(FoldAnimationConstants.ALPHA_CURVES);
    })
  });
}

function getDockBgPanelScaleCurveTest() {
  describe('getDockBgPanelScaleCurveTest', (): void => {
    it('getDockBgPanelScaleCurveTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getDockBgPanelScaleCurve()).assertEqual(FoldAnimationConstants.SCALE_CURVE);
    })
    it('getDockBgPanelScaleCurveTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getDockBgPanelScaleCurve()).assertEqual(FoldAnimationConstants.SCALE_CURVES);
    })
    it('getDockBgPanelScaleCurveTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getDockBgPanelScaleCurve()).assertEqual(FoldAnimationConstants.SCALE_CURVES);
    })
  })
}

function getDockBgExpandAnimStartTranslateXTest() {
  describe('getDockBgExpandAnimStartTranslateXTest', (): void => {
    it('getDockBgExpandAnimStartTranslateXTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getDockBgExpandAnimStartTranslateX(screenWidth)).assertEqual(0);
    })
    it('getDockBgExpandAnimStartTranslateXTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let translateX: number = screenWidth * FoldAnimationConstants.EXPAND_FACTOR;
      expect(FoldExpandAnimUtils.getDockBgExpandAnimStartTranslateX(screenWidth)).assertEqual(translateX);
    })
    it('getDockBgExpandAnimStartTranslateXTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let translateX: number = screenWidth * FoldAnimationConstants.EXPAND_FACTOR;
      expect(FoldExpandAnimUtils.getDockBgExpandAnimStartTranslateX(screenWidth)).assertEqual(translateX);
    })
  })
}

function getDockBgExpandAnimStartScaleSizeTest() {
  describe('getDockBgExpandAnimStartScaleSizeTest', (): void => {
    it('getDockBgExpandAnimStartScaleSizeTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getDockBgExpandAnimStartScaleSize())
        .assertEqual(FoldAnimationConstants.BACKPLANE_SCALE);
    })
    it('getDockBgExpandAnimStartScaleSizeTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      expect(FoldExpandAnimUtils.getDockBgExpandAnimStartScaleSize()).assertEqual(1);
    })
    it('getDockBgExpandAnimStartScaleSizeTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      expect(FoldExpandAnimUtils.getDockBgExpandAnimStartScaleSize()).assertEqual(1);
    })
  })
}

function getRecentBgDelayTest() {
  describe('getRecentBgDelayTest', (): void => {
    it('getRecentBgDelayTest_01', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', true);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = true;
      let dockBgDelayFactor: number = (screenWidth - rectInfo.right) / screenWidth;
      expect(FoldExpandAnimUtils.getRecentBgDelay(dockBgDelayFactor))
        .assertEqual(FoldAnimationConstants.DELAY_EDGE);
    })
    it('getRecentBgDelayTest_02', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', true);
      FoldExpandAnimUtils.isSupportProduct = true;
      let dockBgDelayFactor: number = (screenWidth - rectInfo.right) / screenWidth;
      let delayTime: number = dockBgDelayFactor * FoldAnimationConstants.EXPAND_DELAY;
      expect(FoldExpandAnimUtils.getRecentBgDelay(dockBgDelayFactor)).assertEqual(delayTime);
    })
    it('getRecentBgDelayTest_03', Level.LEVEL0, (): void => {
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isLargeFoldProduct', false);
      ReflectionUtils.setProperty(FoldExpandAnimUtils, 'isSmallFoldProduct', false);
      FoldExpandAnimUtils.isSupportProduct = false;
      let dockBgDelayFactor: number = (screenWidth - rectInfo.right) / screenWidth;
      let delayTime: number = dockBgDelayFactor * FoldAnimationConstants.EXPAND_DELAY;
      expect(FoldExpandAnimUtils.getRecentBgDelay(dockBgDelayFactor)).assertEqual(delayTime);
    })
  })
}