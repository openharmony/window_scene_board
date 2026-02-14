/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers} from '@ohos/hypium'
import {
  MultiRecentPosition,
  MultiRecentPositionArray,
  RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RecentsStyleConstants, SCBScreenProperty } from '@ohos/windowscene';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { recentDisplayManager } from '@ohos/recents/src/main/ets/TsIndex';
import { gestureHelperInstance } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';

export default function RecentLayoutManagerTest() {
  describe('RecentLayoutManagerTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll((): void => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach((): void => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach((): void => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll((): void => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    let recentLayoutConfig = recentLayoutConfigInstance;
    // 获取可见卡片数量。
    it('getMaxVisibleSessionCount_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      expect(RecentLayoutManager.getMaxVisibleSessionCount(false)).assertEqual(RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getMaxVisibleSessionCount_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      expect(RecentLayoutManager.getMaxVisibleSessionCount(true)).assertEqual(RecentsStyleConstants.RECENT_VIEW_COUNT);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getMaxVisibleSessionCount_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      expect(RecentLayoutManager.getMaxVisibleSessionCount(false)).assertEqual(RecentsStyleConstants.RECENT_VIEW_COUNT_FROM_HOME);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    // 获得当前index在多任务列表中的列数。
    it('getTopMargin_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      let isScreenVertical: Function = mocker.mockFunc(screenProperty, screenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      expect(RecentLayoutManager.getTopMargin(screenProperty)).assertNaN();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(screenProperty, screenProperty.isScreenVertical);
    })

    it('getTopMargin_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      let isScreenVertical: Function = mocker.mockFunc(screenProperty, screenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      expect(RecentLayoutManager.getTopMargin(screenProperty)).assertNaN();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(screenProperty, screenProperty.isScreenVertical);
    })

    it('getBottomMargin_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      expect(RecentLayoutManager.getBottomMargin(screenProperty)).assertInstanceOf('Number');
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getBottomMargin_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let isScreenVertical: Function = mocker.mockFunc(screenProperty, screenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      screenProperty.height = 0;
      expect(RecentLayoutManager.getBottomMargin(screenProperty)).assertInstanceOf('Number');
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(screenProperty, screenProperty.isScreenVertical);
    })

    it('getBottomMargin_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let isScreenVertical: Function = mocker.mockFunc(screenProperty, screenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(false);
      screenProperty.height = 0;
      expect(RecentLayoutManager.getBottomMargin(screenProperty)).assertInstanceOf('Number');
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(screenProperty, screenProperty.isScreenVertical);
    })

    it('getHeightSpace_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      expect(RecentLayoutManager.getHeightSpace(screenProperty)).assertInstanceOf('Number');
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getHeightSpace_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      expect(RecentLayoutManager.getHeightSpace(screenProperty)).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getWidthSpace_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      expect(RecentLayoutManager.getWidthSpace()).assertEqual(StyleConstants.RECENT_MARGIN_SPACING_MULTI);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getWidthSpace_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      expect(RecentLayoutManager.getWidthSpace()).assertEqual(StyleConstants.RECENT_MARGIN);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    // 获取多任务列表对应的行列信息
    it('getMultiPositions_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentLayoutManager.getMultiPositions(1)[0].getRowIndex()).assertEqual(0);
    })

    it('getMultiPositions_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentLayoutManager.getMultiPositions(3)[1].getRowIndex()).assertEqual(1);
    })

    it('getMultiPositions_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentLayoutManager.getMultiPositions(1)[0].getRowIndex()).assertEqual(0);
    })

    it('getPositionX_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      expect(RecentLayoutManager.getPositionX(0, 0, 0, screenProperty)).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getPositionX_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.height = 0;
      RecentLayoutManager.getPositionX(0, 0, 1, screenProperty)
      expect(true).assertEqual(true);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getColumnInMultiRow_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentLayoutManager.getColumnInMultiRow(0, 2)).assertEqual(1);
    })

    it('getColumnInMultiRow_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentLayoutManager.getColumnInMultiRow(0, 3)).assertEqual(0);
    })

    it('getColumnInMultiRow_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentLayoutManager.getColumnInMultiRow(0, 4)).assertEqual(0);
    })

    it('getScale_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let isScreenVertical: Function = mocker.mockFunc(screenProperty, screenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      screenProperty.height = 0;
      expect(RecentLayoutManager.getScale(screenProperty)).assertInstanceOf('Number');
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(screenProperty, screenProperty.isScreenVertical);
    })

    it('getScale_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let isScreenVertical: Function = mocker.mockFunc(screenProperty, screenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      screenProperty.height = 0;
      expect(RecentLayoutManager.getScale(screenProperty)).assertInstanceOf('Number');
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mocker.ignoreMock(screenProperty, screenProperty.isScreenVertical);
    })

    it('getRealBottomMargin_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      (recentDisplayManager as object)['_realRotateAngle'] = RotationConstants.ROTATION_180;
      RecentLayoutManager.getRealBottomMargin(screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mock.clearAll();
    });

    it('getRealBottomMargin_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      (recentDisplayManager as object)['_realRotateAngle'] = RotationConstants.ROTATION_180;
      RecentLayoutManager.getRealBottomMargin(screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mock.clearAll();
    });

    it('getBottomMargin_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      let mockFun1: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFun)().afterReturn(true);
      when(mockFun1)().afterReturn(true);
      RecentLayoutManager.getBottomMargin(screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mock.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mock.clearAll();
    });

    it('getHeightSpace_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      let mockFun1: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockFun2: Function = mock.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(mockFun)().afterReturn(true);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      RecentLayoutManager.getHeightSpace(screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mock.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mock.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
      mock.clearAll();
    });

    it('getColumnInMultiRow_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      RecentLayoutManager.getColumnInMultiRow(-1, 2);
      expect(screenProperty).not().assertUndefined();
    });

    it('getMultiRowTranslateY_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let multiRecentPositionArray: MultiRecentPositionArray = new MultiRecentPositionArray();
      RecentLayoutManager.getMultiRowTranslateY(0, 1, multiRecentPositionArray, screenProperty);
      expect(screenProperty).not().assertUndefined();
    });

    it('getMultiRowTranslateY_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let multiRecentPositionArray: MultiRecentPositionArray = new MultiRecentPositionArray();
      let multiRecentPosition: MultiRecentPosition = new MultiRecentPosition(1, 2);
      (multiRecentPosition as object)['rowIndex'] = 0;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(multiRecentPosition, multiRecentPosition.getRowIndex);
      when(mockFun)().afterReturn(0);
      RecentLayoutManager.getMultiRowTranslateY(2, 1, multiRecentPositionArray, screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(multiRecentPosition, multiRecentPosition.getRowIndex);
      mock.clearAll();
    });

    it('getMultiRowTranslateY_test03', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let multiRecentPositionArray: MultiRecentPositionArray = new MultiRecentPositionArray();
      let multiRecentPosition: MultiRecentPosition = new MultiRecentPosition(1, 2);
      (multiRecentPosition as object)['rowIndex'] = 1;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(multiRecentPosition, multiRecentPosition.getRowIndex);
      when(mockFun)().afterReturn(0);
      RecentLayoutManager.getMultiRowTranslateY(2, 1, multiRecentPositionArray, screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(multiRecentPosition, multiRecentPosition.getRowIndex);
      mock.clearAll();
    });

    it('getPadBottomRatio_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(mockFun)().afterReturn(true);
      RecentLayoutManager.getPadBottomRatio();
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
      mock.clearAll();
    });

    it('getPadBottomRatio_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(mockFun)().afterReturn(false);
      RecentLayoutManager.getPadBottomRatio();
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
      mock.clearAll();
    });

    it('getFoldBottomRatio_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(mockFun)().afterReturn(false);
      RecentLayoutManager.getFoldBottomRatio();
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
      mock.clearAll();
    });

    it('getPhoneBottomRatio_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentDisplayManager, recentDisplayManager.isScreenVertical);
      when(mockFun)().afterReturn(false);
      RecentLayoutManager.getPhoneBottomRatio();
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentDisplayManager, recentDisplayManager.isScreenVertical);
      mock.clearAll();
    });

    it('getPositionX_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      RecentLayoutManager.getPositionX(1, 2, 3, screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mock.clearAll();
    });

    it('getPositionX_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      RecentLayoutManager.getPositionX(5, 2, 3, screenProperty);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      mock.clearAll();
    });

    it('getSessionContainerRelativePos_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      RecentLayoutManager.getSessionContainerRelativePos(-1);
      expect(screenProperty).not().assertUndefined();
    });

    it('getSessionContainerRelativePos_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      RecentLayoutManager.getSessionContainerRelativePos(0);
      expect(screenProperty).not().assertUndefined();
    });

    it('getSessionContainerRelativePos_test03', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      RecentLayoutManager.getSessionContainerRelativePos(-100);
      expect(screenProperty).not().assertUndefined();
    });

    it('getTranslateXByScaleAndTouchPosX_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      (RecentLayoutManager as object)['getTranslateXByScaleAndTouchPosX']();
      expect(screenProperty).not().assertUndefined();
    });

    it('getTranslateXByScaleAndTouchPosX_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy03', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy04', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy05', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy06', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy07', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy08', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy09', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy10', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy11', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy12', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy13', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy14', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy15', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy16', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy17', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy18', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy19', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy20', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy21', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test02_copy22', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(3);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getTranslateXByScaleAndTouchPosX_test03', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let gestureEvent: GestureEvent = {
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
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
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
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      when(mockFun)(ArgumentMatchers.any).afterReturn(-1);
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, 1, 2);
      expect(screenProperty).not().assertUndefined();
      mock.ignoreMock(gestureHelperInstance, gestureHelperInstance.getValidFingerPosX);
      mock.clearAll();
    });

    it('getFollowingTranslateYForApp_test01', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      RecentLayoutManager.getFollowingTranslateYForApp(1, 3, 3);
      expect(screenProperty).not().assertUndefined();
    });

    it('getFollowingTranslateYForApp_test02', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      RecentLayoutManager.getFollowingTranslateYForApp(3, 2, 3);
      expect(screenProperty).not().assertUndefined();
    });

    it('getAppNameMaxWidth_test_001', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 4;
      screenProperty.height = 4;
      RecentLayoutManager.getAppNameMaxWidth(screenProperty, true);
      expect(screenProperty).not().assertUndefined();
    })

    it('getAppNameMaxWidth_test_002', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 4;
      screenProperty.height = 4;
      RecentLayoutManager.getAppNameMaxWidth(screenProperty, false);
      expect(screenProperty).not().assertUndefined();
    })

    it('getAppNameMaxWidth_test_001', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 4;
      screenProperty.height = 4;
      RecentLayoutManager.getAppNameMaxWidth(screenProperty, true);
      expect(screenProperty).not().assertUndefined();
    })

    it('getAppNameMaxWidth_test_002', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 4;
      screenProperty.height = 4;
      RecentLayoutManager.getAppNameMaxWidth(screenProperty, false);
      expect(screenProperty).not().assertUndefined();
    })

    it('getTitleMargin_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 4;
      screenProperty.height = 4;
      expect(RecentLayoutManager.getTitleMargin()).not().assertUndefined();
    })
  })
}