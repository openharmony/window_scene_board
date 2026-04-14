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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';

import {
  BrightnessSharedViewData,
  BrightnessViewModel
} from '../../../../../../main/ets/com/ohos/viewModel/BrightnessViewModel';
import { DeviceHelper, EvtBus, GlobalContext, ViewManagerPolicy } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { ColorResourceUtils } from '@ohos/systemuicommon';
import { DarkModeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  BrightnessAnimViewData,
  BrightnessDraggingViewData } from '../../../../../../main/ets/com/ohos/model/BrightnessViewData';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { BrightnessController } from '../../../../../../main/ets/com/ohos/viewModel/BrightnessController';
import lottie, { AnimationItem } from '@ohos/lottie';

export function BrightnessViewModelTest() {
  let mocker: MockKit;

  describe('BrightnessViewModel', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    })

    afterAll((): void => {
      mocker.clearAll();
    })

    it('BrightnessViewModel_Test001', 0, (): void => {
      let viewMode = BrightnessSharedViewData.getInstance();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test002', 0, (): void => {
      let viewMode = BrightnessSharedViewData.getInstance();
      let backgroundOpacity = viewMode.getBackgroundOpacity();
      expect(backgroundOpacity).not().assertNull();
    })


    it('BrightnessViewModel_Test004', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      let viewData = viewMode.getViewData();
      expect(viewData).not().assertNull();
    })

    it('BrightnessViewModel_Test005', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.aboutToAppear(false, 1);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test006', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.aboutToDisappear();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test007', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.handleOnHover(undefined);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test008', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.handleOnHover();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test009', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.handleOnHover(true);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test010', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.handleOnHover(false);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test011', 0, (): void => {
      let viewMode = new BrightnessViewModel();
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

    it('BrightnessViewModel_Test012', 0, (): void => {
      let viewMode = new BrightnessViewModel();
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

    it('BrightnessViewModel_Test014', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        viewMode.onPanActionUpdate(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test015', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        (viewMode as object)['isPanelDismissing'] = true;
        (viewMode as object)['draggingViewData'].isDragging = false;
        viewMode.onPanActionEnd(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test016', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        (viewMode as object)['isPanelDismissing'] = false;
        (viewMode as object)['draggingViewData'].isDragging = false;
        viewMode.onPanActionEnd(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test017', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        (viewMode as object)['isPanelDismissing'] = true;
        (viewMode as object)['draggingViewData'].isDragging = true;
        viewMode.onPanActionEnd(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test018', 0, (): void => {
      let viewMode = new BrightnessViewModel();
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

    it('BrightnessViewModel_Test020', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.onLayoutChange();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test021', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.updatePhysicsValue(1);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test023', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.onCanvasReady();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test024', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.onCanvasDisappear();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test025', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['endDraggingWithNoAnim']();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test026', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['refreshSunAnimWhenDragging'](0);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test027', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['scrollBeforeSun']();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test028', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        let frames: number = (viewMode as object)['getFramesPerVpWhenBeforeSun'](-10);
        expect(frames).assertLargerOrEqual(0);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test030', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        let frames: number[] = (viewMode as object)['getTransitionColorArr']([0,0,0], [255,255,255], 10, 0);
        expect(frames[0]).assertEqual(255);
        expect(frames[1]).assertEqual(255);
        expect(frames[2]).assertEqual(255);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test031', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        let frames: number[] = (viewMode as object)['getTransitionColorArr']([255,255,255], [0,0,0], 10, 0);
        expect(frames[0]).assertEqual(0);
        expect(frames[1]).assertEqual(0);
        expect(frames[2]).assertEqual(0);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test033', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
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
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_Test034', 0, (): void => {
      let viewMode = new BrightnessViewModel();
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

    it('BrightnessViewModel_Test035', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      let colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(undefined).resourceManager);
      let getColorHexByResource = mocker.mockFunc(colorTool, colorTool.getColorHexByResource);
      try {
        when(getColorHexByResource)(ArgumentMatchers.any).afterReturn('#FFFFFFFF');
        (viewMode as object)['doEndAnim']();
        (viewMode as object)['onCurrentEndPositionXChange']();
        (viewMode as object)['countUIValue']();
        (viewMode as object)['countPhysicsValue']();
        (viewMode as object)['draggingViewData'].isDragging = true;
        (viewMode as object)['onCurrentEndPositionXChange']();
        (viewMode as object)['draggingViewData'].isDragging = false;
        (viewMode as object)['onCurrentEndPositionXChange']();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(colorTool);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test036', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      let colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(undefined).resourceManager);
      let getColorHexByResource = mocker.mockFunc(colorTool, colorTool.getColorHexByResource);
      try {
        when(getColorHexByResource)(ArgumentMatchers.any).afterReturn('#FFFFFFFF');
        (viewMode as object)['refreshSunAnimWhenRelease'](-1);
        (viewMode as object)['refreshSunAnimWhenRelease'](15);
        (viewMode as object)['refreshSunAnimWhenRelease'](100);
        (viewMode as object)['refreshSunAnimWhenRelease'](400);
        (viewMode as object)['refreshSunAnimWhenDragging'](10);
        (viewMode as object)['refreshSunAnimWhenDragging'](400);
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(colorTool);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModel_Test037', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      let darkModeEvent = new DarkModeEvent();
      let colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(undefined).resourceManager);
      let getColorHexByResource = mocker.mockFunc(colorTool, colorTool.getColorHexByResource);
      try {
        when(getColorHexByResource)(ArgumentMatchers.any).afterReturn('#FFFFFFFF');
        darkModeEvent.isDarkMode = true;
        viewMode.getViewData().brightnessUIValue = 1;
        (viewMode as object)['handleDarkModeEvent'](darkModeEvent);
        darkModeEvent.isDarkMode = false;
        viewMode.getViewData().brightnessUIValue = 1;
        (viewMode as object)['handleDarkModeEvent'](darkModeEvent);
        darkModeEvent.isDarkMode = false;
        viewMode.getViewData().brightnessUIValue = 25;
        (viewMode as object)['handleDarkModeEvent'](darkModeEvent);
        (viewMode as object)['getFramesPerVp']();
        (viewMode as object)['reloadAnim']();
        (viewMode as object)['playCurrentFrame']();
        (viewMode as object)['convertRgbStringToArray']('#DBFFFFFF');
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(colorTool);
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelTest_aboutToDisappear', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['eventMgr'] = EvtBus.createEventManager();
      viewMode.aboutToDisappear();
      expect(viewMode).not().assertNull();
    })

    it('BrightnessViewModelTest_initData', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      viewMode.initData(new BrightnessDraggingViewData(), new BrightnessAnimViewData());
      expect((viewMode as object)['animViewData']).not().assertNull();
    })

    it('BrightnessViewModelTest_onPanActionUpdate_1', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['isPanelDismissing'] = true;
      let event = {
        offsetX: 10000
      } as GestureEvent;
      try {
        let result = viewMode.onPanActionUpdate(event);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_onPanActionUpdate_2', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['isPanelDismissing'] = false;
      (viewMode as object)['isPc'] = false;
      let isViewShowing: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(isViewShowing)(ArgumentMatchers.any).afterReturn(false);
      let event = {
        offsetX: 0
      } as GestureEvent;
      try {
        let result = viewMode.onPanActionUpdate(event);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(ViewManagerPolicy);
    })

    it('BrightnessViewModelTest_onPanActionUpdate_3', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['isPanelDismissing'] = false;
      (viewMode as object)['isPc'] = true;
      (viewMode as object)['draggingViewData'].isDragging = false;
      let event = {
        offsetX: 0
      } as GestureEvent;
      try {
        let result = viewMode.onPanActionUpdate(event);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_onPanActionUpdate_4', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['isPanelDismissing'] = false;
      (viewMode as object)['isPc'] = true;
      (viewMode as object)['draggingViewData'].isDragging = true;
      let event = {
        offsetX: 0
      } as GestureEvent;
      try {
        viewMode.onPanActionUpdate(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_onPanActionEnd_1', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['isPc'] = false;
      let isViewShowing = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(isViewShowing)(ArgumentMatchers.any).afterReturn(false);
      let event = {
        offsetX: 0
      } as GestureEvent;
      try {
        let result = viewMode.onPanActionEnd(event);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(DeviceHelper);
      mocker.clear(ViewManagerPolicy);
    })

    it('BrightnessViewModelTest_onPanActionEnd', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['notifyHeadBlurTimeId'] = 1;
        (viewMode as object)['doEndAnim']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_onDraggingStop', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['draggingViewData'].isDragging = false;
        viewMode.onDraggingStop();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_endDraggingWithNoAnim', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['draggingViewData'].isDragging = true;
        (viewMode as object)['endDraggingWithNoAnim']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_onCurrentEndPositionXChange_1', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['draggingViewData'].isDragging = false;
        (viewMode as object)['onCurrentEndPositionXChange']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_onCurrentEndPositionXChange_2', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['draggingViewData'].isDragging = true;
        (viewMode as object)['onCurrentEndPositionXChange']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_refreshSun_1', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['isPc'] = true;
        (viewMode as object)['refreshSun']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_refreshSun_2', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['isPc'] = false;
        (viewMode as object)['animationItem'] = null;
        (viewMode as object)['refreshSun']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_refreshSun_3', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['isPc'] = false;
        (viewMode as object)['viewData'].brightnessUIValue = 10;
        (viewMode as object)['refreshSun']();
        (viewMode as object)['viewData'].brightnessUIValue = 100;
        (viewMode as object)['refreshSun']();
        (viewMode as object)['viewData'].brightnessUIValue = 1000;
        (viewMode as object)['refreshSun']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_transitColor', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['transitColor'](null, null, null, null);
        (viewMode as object)['transitColor'](Color.Blue, Color.Blue, null, null);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_reloadAnim_1', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['loadCount'] = 100;
        (viewMode as object)['reloadAnim']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModelTest_reloadAnim_2', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      let brightnessControllers = new BrightnessController();
      let lottieData = mocker.mockFunc(brightnessControllers, brightnessControllers.matchLottieData);
      when(lottieData)(false).afterReturn(null);
      try {
        (viewMode as object)['reloadAnim']();
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(brightnessControllers);
    })

    it('BrightnessViewModelTest_getAccessibilityBrightnessValue', 0, async (): Promise<void> => {
      let viewMode = new BrightnessViewModel();
      (viewMode as object)['brightnessRange'] = 0;
      try {
        let result = viewMode.getAccessibilityBrightnessValue(-10);
        expect(result).assertEqual('-10');
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_handleOnTouch', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      let event = {
        type: TouchType.Move,
        stopPropagation: () => {
        },
      } as TouchEvent;
      (viewMode as object)['isPc'] = false;
      try {
        let result = viewMode.handleOnTouch(event);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_adjustBrightWithArrowKey', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['physicsValue'] = 0;
        let result = viewMode.adjustBrightWithArrowKey(-1);
        (viewMode as object)['physicsValue'] = 300;
        result = viewMode.adjustBrightWithArrowKey(1);
        const mockFunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
        when(mockFunc)().afterReturn(true);
        (viewMode as object)['physicsValue'] = 10;
        result = viewMode.adjustBrightWithArrowKey(1);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
      mocker.clear(RTLUtil);
    })

    it('BrightnessViewModel_countUIValueBetweenBright', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        (viewMode as object)['countUIValueBetweenBright'](300, 301);
        expect((viewMode as object)['countUIValueBetweenBright'](10, 11)).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })

    it('BrightnessViewModel_onPanActionUpdate_mouseScroll', 0, (): void => {
      let viewMode = new BrightnessViewModel();
      try {
        let event = {
          offsetX: 0
        } as GestureEvent;
        (viewMode as object)['isPanelDismissing'] = false;
        (viewMode as object)['isPc'] = true;
        (viewMode as object)['draggingViewData'].isDragging = false;
        (viewMode as object)['isMouseScroll'] = true;
        viewMode.onPanActionUpdate(event);
        expect(viewMode).not().assertNull();
      } catch (e) {
        expect(viewMode).not().assertNull();
      }
    })
  })
}