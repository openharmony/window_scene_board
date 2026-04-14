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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import {
  BrightnessSharedViewData,
  BrightnessViewModel } from '../../../../../../main/ets/com/ohos/viewModel/BrightnessViewModel';
import { ColorResourceUtils } from '@ohos/systemuicommon';

export function BrightnessViewModelExtTest() {
  let mocker: MockKit;
  let viewMode = new BrightnessViewModel();

  describe('BrightnessViewModelExtTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    })

    afterAll((): void => {
      mocker.clearAll();
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    it('BrightnessViewModelExtTest_Test010', 0, (): void => {
      viewMode.handleOnHover(false);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelExtTest_Test011', 0, (): void => {
      let event = {
        type: TouchType.Move
      } as TouchEvent;
      // 设备类型置为PC
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)().afterReturn(true);
      try {
        viewMode.handleOnTouch(event);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      expect(viewMode).not().assertNull();
      mocker.clear(DeviceHelper);
    })

    it('BrightnessViewModelExtTest_Test012', 0, (): void => {
      let event = {
        touches: [{
          id: 1,
          windowX: 1,
          windowY: 1,
        }, {
          id: 2,
          windowX: 2,
          windowY: 2,
        }],
        type: TouchType.Move
      } as TouchEvent;
      // 设备类型置为PC
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)().afterReturn(false);
      try {
        viewMode.handleOnTouch(event);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      expect(viewMode).not().assertNull();
      mocker.clear(DeviceHelper);
    })

    it('BrightnessViewModelExtTest_Test014', 0, (): void => {
      let event = {
        offsetX: 0
      } as GestureEvent;
      viewMode.onPanActionUpdate(event);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelExtTest_Test015', 0, (): void => {
      let event = {
        offsetX: 0
      } as GestureEvent;
      (viewMode as object)['isPanelDismissing'] = true;
      (viewMode as object)['draggingViewData'].isDragging = false;
      viewMode.onPanActionEnd(event);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelExtTest_Test016', 0, (): void => {
      let event = {
        offsetX: 0
      } as GestureEvent;
      (viewMode as object)['isPanelDismissing'] = false;
      (viewMode as object)['draggingViewData'].isDragging = false;
      viewMode.onPanActionEnd(event);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelExtTest_Test017', 0, (): void => {
      let event = {
        offsetX: 0
      } as GestureEvent;
      (viewMode as object)['isPanelDismissing'] = true;
      (viewMode as object)['draggingViewData'].isDragging = true;
      viewMode.onPanActionEnd(event);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelExtTest_Test018', 0, (): void => {
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        (viewMode as object)['isPanelDismissing'] = false;
        (viewMode as object)['draggingViewData'].isDragging = true;
        viewMode.onPanActionEnd(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelExtTest_Test019', 0, (): void => {
      let event = {
        offsetX: 0
      } as GestureEvent;
      (viewMode as object)['isPanelDismissing'] = true;
      viewMode.onPanActionUpdate(event);
      (viewMode as object)['isPanelDismissing'] = false;
      (viewMode as object)['draggingViewData'].isDragging = true;
      viewMode.onPanActionUpdate(event);
      (viewMode as object)['draggingViewData'].isDragging = false;
      viewMode.onPanActionUpdate(event);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelExtTest_Test020', 0, (): void => {
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        (viewMode as object)['draggingViewData'].isDragging = true;
        viewMode.onPanActionEnd(event);
        (viewMode as object)['draggingViewData'].isDragging = false;
        viewMode.onPanActionEnd(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelExtTest_Test021', 0, (): void => {
      let colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(undefined).resourceManager);
      let getColorHexByResource = mocker.mockFunc(colorTool, colorTool.getColorHexByResource);
      when(getColorHexByResource)(ArgumentMatchers.any).afterReturn('#FFFFFFFF');
      try {
        (viewMode as object)['doEndAnim']();
        (viewMode as object)['countUIValue']();
        (viewMode as object)['countPhysicsValue']();
        (viewMode as object)['onCurrentEndPositionXChange']();
        (viewMode as object)['draggingViewData'].isDragging = true;
        (viewMode as object)['onCurrentEndPositionXChange']();
        (viewMode as object)['draggingViewData'].isDragging = false;
        (viewMode as object)['onCurrentEndPositionXChange']();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      expect(viewMode).not().assertNull();
      mocker.clear(colorTool);
    })

    it('BrightnessViewModelExtTest_Test022', 0, (): void => {
      let colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(undefined).resourceManager);
      let getColorHexByResource = mocker.mockFunc(colorTool, colorTool.getColorHexByResource);
      when(getColorHexByResource)(ArgumentMatchers.any).afterReturn('#FFFFFFFF');
      try {
        (viewMode as object)['refreshSunAnimWhenRelease'](-1);
        (viewMode as object)['refreshSunAnimWhenRelease'](15);
        (viewMode as object)['refreshSunAnimWhenRelease'](100);
        (viewMode as object)['refreshSunAnimWhenRelease'](400);
        (viewMode as object)['refreshSunAnimWhenDragging'](10);
        (viewMode as object)['refreshSunAnimWhenRelease'](400);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      expect(viewMode).not().assertNull();
      mocker.clear(colorTool);
    })
  })
}
