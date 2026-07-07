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
  beforeAll,
  beforeEach,
  afterAll,
  afterEach,
  it,
  Level,
  expect,
} from '@ohos/hypium';
import { ThreeFoldStatus } from '@ohos/screenlockcommon';
import { TripleAnimConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/constant/TripleAnimConstants';
import { TripleAnimManagerUtil, TripleStateChange } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/utils/TripleAnimManagerUtil';

let screenWidth: number;

export default function TripleAnimManagerUtilTest() {
  describe('TripleAnimManagerUtilTest', (): void => {
    beforeAll((): void => {
      screenWidth = 900;
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
    getTripleScreenLockStateChangeTest();
    initTripleAnimTransXTest();
    getTripleAnimCurvesTest();
    initTripleClockTransYTest();
  })
}

function getTripleScreenLockStateChangeTest() {
  describe('getTripleScreenLockStateChangeTest', (): void => {
    it('getTripleScreenLockStateChangeTest_01', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.F_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.F_STATUS;
      expect(TripleStateChange.INVALID).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
    it('getTripleScreenLockStateChangeTest_02', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.F_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.M_STATUS;
      expect(TripleStateChange.F_TO_M).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
    it('getTripleScreenLockStateChangeTest_03', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.F_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.G_STATUS;
      expect(TripleStateChange.F_TO_G).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
    it('getTripleScreenLockStateChangeTest_04', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.M_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.F_STATUS;
      expect(TripleStateChange.M_TO_F).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
    it('getTripleScreenLockStateChangeTest_05', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.M_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.G_STATUS;
      expect(TripleStateChange.M_TO_G).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
    it('getTripleScreenLockStateChangeTest_06', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.G_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.F_STATUS;
      expect(TripleStateChange.G_TO_F).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
    it('getTripleScreenLockStateChangeTest_07', Level.LEVEL0, (): void => {
      let oldState: ThreeFoldStatus = ThreeFoldStatus.G_STATUS;
      let newState: ThreeFoldStatus = ThreeFoldStatus.M_STATUS;
      expect(TripleStateChange.G_TO_M).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleScreenLockStateChange(oldState, newState));
    })
  })
}

function initTripleAnimTransXTest() {
  describe('initTripleAnimTransXTest', (): void => {
    it('initTripleAnimTransXTest_01', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.F_TO_M;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(-900).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
    it('initTripleAnimTransXTest_02', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.M_TO_F;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(337.5).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
    it('initTripleAnimTransXTest_03', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.M_TO_G;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(225).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
    it('initTripleAnimTransXTest_04', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.G_TO_M;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(-150).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
    it('initTripleAnimTransXTest_05', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.F_TO_G;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(-900).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
    it('initTripleAnimTransXTest_06', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.G_TO_F;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(300).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
    it('initTripleAnimTransXTest_07', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.INVALID;
      let animScene: string = TripleAnimConstants.LOCK_ICON;
      expect(0).
      assertEqual(TripleAnimManagerUtil.getInstance().initTripleAnimTransX(stateChange, screenWidth, animScene));
    })
  })
}

function getTripleAnimCurvesTest() {
  describe('getTripleAnimCurvesTest', (): void => {
    it('getTripleAnimCurvesTest_01', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.F_TO_M;
      expect(TripleAnimConstants.TRANSLATE_CURVES_DEFAULT).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
    it('getTripleAnimCurvesTest_02', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.M_TO_F;
      expect(TripleAnimConstants.TRANSLATE_CURVES_DEFAULT).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
    it('getTripleAnimCurvesTest_03', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.M_TO_G;
      expect(TripleAnimConstants.TRANSLATE_CURVES_DEFAULT).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
    it('getTripleAnimCurvesTest_04', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.G_TO_M;
      expect(TripleAnimConstants.TRANSLATE_CURVES_DEFAULT).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
    it('getTripleAnimCurvesTest_05', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.F_TO_G;
      expect(TripleAnimConstants.TRANSLATE_CURVES).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
    it('getTripleAnimCurvesTest_06', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.G_TO_F;
      expect(TripleAnimConstants.TRANSLATE_CURVES).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
    it('getTripleAnimCurvesTest_07', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.INVALID;
      expect(TripleAnimConstants.TRANSLATE_CURVES_DEFAULT).
      assertEqual(TripleAnimManagerUtil.getInstance().getTripleAnimCurves(stateChange));
    })
  })
}

function initTripleClockTransYTest() {
  describe('initTripleClockTransYTest', (): void => {
    it('initTripleClockTransYTest_01', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.F_TO_M;
      expect(0).assertEqual(TripleAnimManagerUtil.getInstance().initTripleClockTransY(stateChange));
    })
    it('initTripleClockTransYTest_02', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.M_TO_F;
      expect(0).assertEqual(TripleAnimManagerUtil.getInstance().initTripleClockTransY(stateChange));
    })
    it('initTripleClockTransYTest_03', Level.LEVEL0, (): void => {
      let stateChange: TripleStateChange = TripleStateChange.INVALID;
      expect(0).assertEqual(TripleAnimManagerUtil.getInstance().initTripleClockTransY(stateChange));
    })
  })
}