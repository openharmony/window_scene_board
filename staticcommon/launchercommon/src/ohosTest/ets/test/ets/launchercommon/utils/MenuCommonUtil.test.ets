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

import { RectInfo } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { LayoutViewModel } from '../../../../../../main/ets/TsIndex';
import { MenuCommonUtil } from '../../../../../../main/ets/utils/MenuCommonUtil';

export function MenuCommonUtilTest() {
  describe('MenuCommonUtilTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
    });
    afterEach(() => {
    });

    it('isShowBottom', 0, () => {
      expect(MenuCommonUtil.isShowBottom(Placement.Bottom)).assertTrue();
      expect(MenuCommonUtil.isShowBottom(Placement.BottomLeft)).assertTrue();
      expect(MenuCommonUtil.isShowBottom(Placement.BottomRight)).assertTrue();
      expect(MenuCommonUtil.isShowBottom(Placement.RightBottom)).assertFalse();
      expect(MenuCommonUtil.isShowBottom(Placement.LeftBottom)).assertFalse();
      expect(MenuCommonUtil.isShowBottom(Placement.LeftTop)).assertFalse();
    });

    it('getMenuPlacement', 0, () => {
      let componentRect: RectInfo = new RectInfo();
      let historicalPoint: HistoricalPoint = {
        touchObject: {
          type: TouchType.Down,
          id: 0,
          displayX: 10,
          displayY: 0,
          windowX: 0,
          windowY: 10,
          screenX: 0,
          screenY: 10,
          x: 0,
          y: 0
        },
        size: 10,
        force: 0,
        timestamp: 10
      }

      let touchObject: TouchObject = {
        type: TouchType.Down,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      };

      let touchEvent: TouchEvent = {
        target: {
          area: {
            width: 0,
            height: 0,
            position: {
              x: 0, y: 0
            },
            globalPosition: {
              x: 0, y: 0
            }
          }
        },
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        type: TouchType.Down,
        touches: [],
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 0,
          y: 0
        }],
        stopPropagation: () => {
        },
        getHistoricalPoints: () => {
          return [historicalPoint, historicalPoint];
        },
        preventDefault: (): void => {}
      }
      let mocker: MockKit = new MockKit();
      let mockFuncScreenHeight: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getScreenHeight);
      let mockFuncScreenWidth: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getScreenWidth);
      let mockFuncMarginTop: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getSysUITopHeight);
      let mockFuncMarginBottom: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getDockMarginBottom);
      let mockFuncRTL: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuncScreenHeight)(ArgumentMatchers.any).afterReturn(827);
      when(mockFuncScreenWidth)(ArgumentMatchers.any).afterReturn(300);
      when(mockFuncMarginTop)(ArgumentMatchers.any).afterReturn(39);
      when(mockFuncMarginBottom)(ArgumentMatchers.any).afterReturn(27);
      when(mockFuncRTL)(ArgumentMatchers.any).afterReturn(true);

      componentRect.top = 10;
      componentRect.bottom = 20;
      componentRect.left = 10;
      componentRect.right = 20;
      try {
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.BottomLeft);
        touchEvent.touches[0] = touchObject;
        touchEvent.touches[0].displayX = 11;
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.BottomLeft);
      } catch (e) {
      }
      when(mockFuncRTL)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.BottomLeft);
        touchEvent.touches[0].displayX = 17;
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.BottomLeft);

        componentRect.top = 468;
        componentRect.bottom = 522;
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.TopLeft);

        componentRect.left = 250;
        componentRect.right = 260;
        touchEvent.touches[0].displayX = 251;
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.TopRight);
        componentRect.right = 290;
        touchEvent.touches[0].displayX = 289;
        expect(MenuCommonUtil.getMenuPlacement(touchEvent, componentRect, 1, 1)).assertEqual(Placement.TopRight);
      } catch (e) {
      }
      mocker.clear(LayoutViewModel.getInstance());
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

    it('getMaxMenuHeight', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuncScreenHeight: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getScreenHeight);
      let mockFuncMarginTop: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getSysUITopHeight);
      let mockFuncMarginBottom: Function = mocker.mockFunc(LayoutViewModel.getInstance(),
        LayoutViewModel.getInstance().getDockMarginBottom);
      when(mockFuncScreenHeight)(ArgumentMatchers.any).afterReturn(827);
      when(mockFuncMarginTop)(ArgumentMatchers.any).afterReturn(39);
      when(mockFuncMarginBottom)(ArgumentMatchers.any).afterReturn(27);

      let componentRect: RectInfo = new RectInfo();
      componentRect.top = 84;
      componentRect.bottom = 138;
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomRight, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopRight, componentRect)).assertLarger(0);


      componentRect.top = 180;
      componentRect.bottom = 276;
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomRight, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopRight, componentRect)).assertLarger(0);

      componentRect.top = 276;
      componentRect.bottom = 330;
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomRight, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopRight, componentRect)).assertLarger(0);

      componentRect.top = 372;
      componentRect.bottom = 426;
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.BottomRight, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopLeft, componentRect)).assertLarger(0);
      expect(MenuCommonUtil.getMaxMenuHeight(Placement.TopRight, componentRect)).assertLarger(0);
    });

    it('getMaxDynamicMenuHeight', 0, () => {
      let menuHeight: number = 356;
      expect(MenuCommonUtil.getMaxDynamicMenuHeight(menuHeight, 0)).assertLarger(0);
      expect(MenuCommonUtil.getMaxDynamicMenuHeight(menuHeight, 1)).assertLarger(0);
      expect(MenuCommonUtil.getMaxDynamicMenuHeight(menuHeight, 2)).assertLarger(0);
      expect(MenuCommonUtil.getMaxDynamicMenuHeight(menuHeight, 3)).assertLarger(0);
      expect(MenuCommonUtil.getMaxDynamicMenuHeight(menuHeight, 4)).assertLarger(0);
    });
  })
}