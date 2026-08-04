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
  GridLayoutItemInfo
} from '../../../../../../main/ets/TsIndex';
import { describe, it, expect, Level, beforeAll, MockKit, ArgumentMatchers, when } from '@ohos/hypium';
import { DeviceHelper, ScreenState } from '@ohos/frameworkwrapper';
import { SCBTripleStateChange,
  TripleFoldExpandAnimUtils } from '../../../../../../main/ets/utils/TripleFoldExpandAnimUtils';
import { TripleFoldAnimationConstants } from '../../../../../../main/ets/constants/TripleFoldAnimationConstants';
import { SCBTripleFoldState } from '@ohos/frameworkwrapper';


export default function TripleFoldExpandAnimUtilsTest() {
  getScenePanelSnapshotAlphaCurveTest();
  getScenePanelAlphaCurveTest();
  getScenePanelTransCurveTest();
  getScenePanelAnimFactorTest();
  getDesktopAnimFactorTest();
  getTripleDesktopStateChangeTest();
  calculateGridNumberRemainTest();
  initTripleItemAlphaTest();
  getSwiperPageColumnsTest();
  getTripleStateChangeTest();
  getTraceNameTest();
  initTripleDockBgAnimAlphaTest();
  getTripleDockBgAnimEndAlphaTest();
  initTripleRecentDockItemAnimAlphaTest();
  getIndicatorExpandAnimParamTest();
  initTripleResidentDockItemAnimAlphaTest();
}

function getScenePanelSnapshotAlphaCurveTest() {
  describe('getScenePanelSnapshotAlphaCurveTest', (): void => {
    it('getScenePanelSnapshotAlphaCurveTest_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      expect(TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_M2G).assertEqual(TripleFoldExpandAnimUtils.getScenePanelSnapshotAlphaCurve(stateChange));
    })
    it('getScenePanelSnapshotAlphaCurveTest_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.G_TO_M;
      expect(TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_G2M).assertEqual(TripleFoldExpandAnimUtils.getScenePanelSnapshotAlphaCurve(stateChange));
    })
  })
}

function getScenePanelAlphaCurveTest() {
  describe('getScenePanelAlphaCurveTest', (): void => {
    it('getScenePanelAlphaCurveTest_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      expect(TripleFoldAnimationConstants.ALPHA_CURVES_M2G).assertEqual(TripleFoldExpandAnimUtils.getScenePanelAlphaCurve(stateChange));
    })
    it('getScenePanelAlphaCurveTest_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.G_TO_M;
      expect(TripleFoldAnimationConstants.ALPHA_CURVES_G2M).assertEqual(TripleFoldExpandAnimUtils.getScenePanelAlphaCurve(stateChange));
    })
  })
}

function getScenePanelTransCurveTest() {
  describe('getScenePanelTransCurveTest', (): void => {
    it('getScenePanelTransCurveTest_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      expect(TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_M2G).assertEqual(TripleFoldExpandAnimUtils.getScenePanelTransCurve(stateChange));
    })
    it('getScenePanelTransCurveTest_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.G_TO_M;
      expect(TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_G2M).assertEqual(TripleFoldExpandAnimUtils.getScenePanelTransCurve(stateChange));
    })
  })
}

function getScenePanelAnimFactorTest() {
  describe('getScenePanelAnimFactorTest', (): void => {
    it('getScenePanelAnimFactorTest_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      expect(0.33).assertEqual(TripleFoldExpandAnimUtils.getScenePanelAnimFactor(stateChange));
    })
    it('getScenePanelAnimFactorTest_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.G_TO_M;
      expect(-0.5).assertEqual(TripleFoldExpandAnimUtils.getScenePanelAnimFactor(stateChange));
    })
  })
}

function getDesktopAnimFactorTest() {
  describe('getDesktopAnimFactorTest', (): void => {
    it('getDesktopAnimFactorTest_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      expect(TripleFoldAnimationConstants.ITEM_TRANS_MTG).assertEqual(TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange));
    })
    it('getDesktopAnimFactorTest_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.G_TO_M;
      expect(TripleFoldAnimationConstants.ITEM_TRANS_GTM).assertEqual(TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange));
    })
  })
}

function getTripleDesktopStateChangeTest() {
  describe('getTripleDesktopStateChangeTest', (): void => {
    it('getTripleDesktopStateChangeTest_01', Level.LEVEL0, (): void => {
      let curTripleFoldState : ScreenState = ScreenState.G;
      let lastTripleFoldState : ScreenState = ScreenState.M;
      expect(0).assertEqual(TripleFoldExpandAnimUtils.getTripleDesktopStateChange(curTripleFoldState, lastTripleFoldState));
    })
    it('getTripleDesktopStateChangeTest_02', Level.LEVEL0, (): void => {
      let curTripleFoldState : ScreenState = ScreenState.M;
      let lastTripleFoldState : ScreenState = ScreenState.G;
      expect(0).assertEqual(TripleFoldExpandAnimUtils.getTripleDesktopStateChange(curTripleFoldState, lastTripleFoldState));
    })
  })
}

function calculateGridNumberRemainTest() {
  describe('calculateGridNumberRemainTest', (): void => {
    it('calculateGridNumberRemain_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.G_TO_M;
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.area = [3, 2];
      expect(5).assertEqual(TripleFoldExpandAnimUtils.calculateGridNumberRemain(1, stateChange, item));
    })
    it('calculateGridNumberRemain_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.F_TO_G;
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 2;
      item.area = [3, 2];
      expect(1).assertEqual(TripleFoldExpandAnimUtils.calculateGridNumberRemain(2, stateChange, item));
    })
  })
}

function initTripleItemAlphaTest() {
  describe('initTripleItemAlphaTest', (): void => {
    it('initTripleItemAlpha_01', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.F_TO_M;
      expect(0).assertEqual(TripleFoldExpandAnimUtils.initTripleItemAlpha(stateChange, 0));
    })
    it('initTripleItemAlpha_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.F_TO_G;
      expect(0).assertEqual(TripleFoldExpandAnimUtils.initTripleItemAlpha(stateChange, 6));
    })
  })
}

function getSwiperPageColumnsTest() {
  describe('getSwiperPageColumnsTest', (): void => {
    it('initTripleItemAlpha_01', Level.LEVEL0, (): void => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.area = [3, 2];
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_F;
      expect(2).assertEqual(TripleFoldExpandAnimUtils.getSwiperPageColumns(item, 3, 8, stateChange));

    })
    it('getSwiperPageColumns_02', Level.LEVEL0, (): void => {
      let stateChange:SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.area = [3, 2];
      expect(2).assertEqual(TripleFoldExpandAnimUtils.getSwiperPageColumns(item, 2, 8, stateChange));
    })
  })
}

function getTripleStateChangeTest() {
  describe('getTripleStateChangeTest', (): void => {
    it('getTripleStateChangeTest_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let curTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.UNKNOWN;
      let lastTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.UNKNOWN;
      expect(TripleFoldExpandAnimUtils.getTripleStateChange(curTripleFoldState, lastTripleFoldState))
        .assertEqual(SCBTripleStateChange.INVALID);
      mocker.clear(DeviceHelper);
    })
    it('getTripleStateChangeTest_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let curTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.UNKNOWN;
      let lastTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.F;
      expect(TripleFoldExpandAnimUtils.getTripleStateChange(curTripleFoldState, lastTripleFoldState))
        .assertEqual(SCBTripleStateChange.INVALID);
      mocker.clear(DeviceHelper);
    })
    it('getTripleStateChangeTest_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let curTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.F;
      let lastTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.M;
      expect(TripleFoldExpandAnimUtils.getTripleStateChange(curTripleFoldState, lastTripleFoldState))
        .assertEqual(0);
      mocker.clear(DeviceHelper);
    })
    it('getTripleStateChangeTest_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let curTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.F;
      let lastTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.G;
      expect(TripleFoldExpandAnimUtils.getTripleStateChange(curTripleFoldState, lastTripleFoldState))
        .assertEqual(0);
      mocker.clear(DeviceHelper);
    })
    it('getTripleStateChangeTest_05', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let curTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.M;
      let lastTripleFoldState: SCBTripleFoldState = SCBTripleFoldState.G;
      expect(TripleFoldExpandAnimUtils.getTripleStateChange(curTripleFoldState, lastTripleFoldState))
        .assertEqual(0);
      mocker.clear(DeviceHelper);
    })
  })
}

function getTraceNameTest() {
  describe('getTraceNameTest', (): void => {
    it('getTraceNameTest_01', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.INVALID;
      expect(TripleFoldExpandAnimUtils.getTraceName(stateChange))
        .assertEqual('invalid');
    })
    it('getTraceNameTest_02', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.F_TO_M;
      expect(TripleFoldExpandAnimUtils.getTraceName(stateChange))
        .assertEqual('F_TO_M');
    })
  })
}

function initTripleDockBgAnimAlphaTest() {
  describe('initTripleDockBgAnimAlphaTest', (): void => {
    it('initTripleDockBgAnimAlphaTest_01', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.F_TO_G;
      expect(TripleFoldExpandAnimUtils.initTripleDockBgAnimAlpha(stateChange))
        .assertEqual(0);
    });
    it('initTripleDockBgAnimAlphaTest_02', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.M_TO_F;
      expect(TripleFoldExpandAnimUtils.initTripleDockBgAnimAlpha(stateChange))
        .assertEqual(1);
    });
  })
}

function getTripleDockBgAnimEndAlphaTest() {
  describe('getTripleDockBgAnimEndAlphaTest', (): void => {
    it('getTripleDockBgAnimEndAlphaTest_01', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.G_TO_F;
      expect(TripleFoldExpandAnimUtils.getTripleDockBgAnimEndAlpha(stateChange))
        .assertEqual(0);
    });
    it('getTripleDockBgAnimEndAlphaTest_02', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.F_TO_M;
      expect(TripleFoldExpandAnimUtils.getTripleDockBgAnimEndAlpha(stateChange))
        .assertEqual(1);
    });
  })
}

function initTripleRecentDockItemAnimAlphaTest() {
  describe('initTripleRecentDockItemAnimAlphaTest', (): void => {
    it('initTripleRecentDockItemAnimAlphaTest_01', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.F_TO_G;
      expect(TripleFoldExpandAnimUtils.initTripleRecentDockItemAnimAlpha(stateChange))
        .assertEqual(0);
    });
    it('initTripleRecentDockItemAnimAlphaTest_02', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.M_TO_F;
      expect(TripleFoldExpandAnimUtils.initTripleRecentDockItemAnimAlpha(stateChange))
        .assertEqual(1);
    });
  })
}

function getIndicatorExpandAnimParamTest() {
  describe("getIndicatorExpandAnimParamTest", (): void => {
    it('getIndicatorExpandAnimParamTest_01', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.F_TO_M;
      let animateParam: AnimateParam = TripleFoldExpandAnimUtils.getIndicatorExpandAnimParam(stateChange);
      expect(animateParam.duration).assertEqual(TripleFoldAnimationConstants.ANIMATION_DURATION);
    });
    it('getIndicatorExpandAnimParamTest_02', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.M_TO_F;
      let animateParam: AnimateParam = TripleFoldExpandAnimUtils.getIndicatorExpandAnimParam(stateChange);
      expect(animateParam.duration).assertEqual(TripleFoldAnimationConstants.ANIMATION_DURATION);
    });
  })
}

function initTripleResidentDockItemAnimAlphaTest() {
  describe("initTripleResidentDockItemAnimAlphaTest", (): void => {
    it('initTripleResidentDockItemAnimAlphaTest_01', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.F_TO_M;
      expect(TripleFoldExpandAnimUtils.initTripleResidentDockItemAnimAlpha(stateChange))
        .assertEqual(0);
    });
    it('initTripleResidentDockItemAnimAlphaTest_02', Level.LEVEL0, (): void => {
      let stateChange: SCBTripleStateChange = SCBTripleStateChange.M_TO_G;
      expect(TripleFoldExpandAnimUtils.initTripleResidentDockItemAnimAlpha(stateChange))
        .assertEqual(1);
    });
  })
}