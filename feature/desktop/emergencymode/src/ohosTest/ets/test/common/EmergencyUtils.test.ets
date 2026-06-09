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
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import display from '@ohos.display';
import { CommonConstants } from '../../../../../src/main/ets/common/CommonConstants';
import { CommonStyle } from '../../../../../src/main/ets/common/CommonStyle';
import { DeviceHelper, ScreenState } from '@ohos/frameworkwrapper';
import { EmergencyUtils } from '../../../../main/ets/common/EmergencyUtils';
import { FoldExpandStyle } from '../../../../main/ets/common/FoldExpandStyle';
import { FoldExpandStyleConfig } from '../../../../main/ets/common/styleConfig/FoldExpandStyleConfig';

export default function EmergencyUtilsTest() {
  describe('EmergencyUtilsTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('should return the correct virtual pixel width of the screen', 0, () => {
      const displayData: display.Display = display.getDefaultDisplaySync();
      const width: number = px2vp(displayData.width);
      const height: number = px2vp(displayData.height);
      expect(width).assertEqual(EmergencyUtils.getScreenWidth());
      expect(height).assertEqual(EmergencyUtils.getScreenHeight());
    });

    it('should return correct grid width and gutter for phone', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(EmergencyUtils, EmergencyUtils.getScreenWidth);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1000);
      const result = EmergencyUtils.getGridWidthAndGutter('phone');
      expect(result[0]).assertEqual((1000 - 2 * CommonConstants.GRID_SMALL_MARGIN -
        (CommonConstants.GRID_SMALL_NUMBER - 1) * CommonConstants.GRID_GUTTER) / CommonConstants.GRID_SMALL_NUMBER);
      expect(result[1]).assertEqual(CommonConstants.GRID_GUTTER);
      mocker.clear(EmergencyUtils);
      mocker.clearAll();
    });

    it('should return correct grid width and gutter for fold', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(EmergencyUtils, EmergencyUtils.getScreenWidth);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1000);
      const result = EmergencyUtils.getGridWidthAndGutter('fold');
      expect(result[0]).assertEqual((1000 - 2 * CommonConstants.GRID_BIG_MARGIN -
        (CommonConstants.GRID_MIDDLE_NUMBER - 1) * CommonConstants.GRID_GUTTER) / CommonConstants.GRID_MIDDLE_NUMBER);
      expect(result[1]).assertEqual(CommonConstants.GRID_GUTTER);
      mocker.clear(EmergencyUtils);
      mocker.clearAll();
    });

    it('should return correct grid width and gutter for pad', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(EmergencyUtils, EmergencyUtils.getScreenWidth);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1000);
      const result = EmergencyUtils.getGridWidthAndGutter('pad');
      expect(result[0]).assertEqual((1000 - 2 * CommonConstants.GRID_BIG_MARGIN -
        (CommonConstants.GRID_LARGE_NUMBER - 1) * CommonConstants.GRID_GUTTER) / CommonConstants.GRID_LARGE_NUMBER);
      expect(result[1]).assertEqual(CommonConstants.GRID_GUTTER);
      mocker.clear(EmergencyUtils);
      mocker.clearAll();
    });

    it('should return 0 for grid width and gutter for unknown device', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(EmergencyUtils, EmergencyUtils.getScreenWidth);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1000);
      const result = EmergencyUtils.getGridWidthAndGutter('unknown');
      expect(result[0]).assertEqual(0);
      expect(result[1]).assertEqual(CommonConstants.GRID_GUTTER);
      mocker.clear(EmergencyUtils);
      mocker.clearAll();
    });

    it('test_initGridStyleOfFolded1', 0, () => {
      let style: CommonStyle = new CommonStyle();
      EmergencyUtils.initGridStyleOfFolded(0, 0, style);
      expect(style).assertNull();
    });

    it('test_initGridStyleOfFolded2', 0, () => {
      let style: CommonStyle = new CommonStyle();
      EmergencyUtils.initGridStyleOfFolded(1, 1, style);
      expect(style.appGridWidth).assertLarger(0);
    });

    it('test_initGridStyleOfExpanded1', 0, () => {
      let style: CommonStyle = new CommonStyle();
      EmergencyUtils.initGridStyleOfExpanded(0, 0, style);
      expect(style).assertNull();
    });

    it('test_initGridStyleOfExpanded2', 0, () => {
      let style: CommonStyle = new CommonStyle();
      EmergencyUtils.initGridStyleOfExpanded(1, 1, style);
      expect(style.appGridWidth).assertLarger(0);
    });

    it('test_getUltraScreenGridWidthAndGutter', 0, () => {
      FoldExpandStyleConfig.initEmergencyMap();
      let style: FoldExpandStyle | undefined = FoldExpandStyleConfig.getEmergencyMap().get(ScreenState.F);
      let rst: number[] = [];
      if (style) {
        rst = EmergencyUtils.getUltraScreenGridWidthAndGutter(style);
        expect(rst[0]).assertLarger(0);
      }
      style = FoldExpandStyleConfig.getEmergencyMap().get(ScreenState.M);
      if (style) {
        rst = EmergencyUtils.getUltraScreenGridWidthAndGutter(style);
        expect(rst[0]).assertLarger(0);
      }
      style = FoldExpandStyleConfig.getEmergencyMap().get(ScreenState.G);
      if (style) {
        rst = EmergencyUtils.getUltraScreenGridWidthAndGutter(style);
        expect(rst[0]).assertLarger(0);
      }
    });
  })
}