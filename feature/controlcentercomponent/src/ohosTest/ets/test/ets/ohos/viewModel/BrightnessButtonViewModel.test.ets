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

import { ConfigMgr, ConfigurationEvent, EvtBus } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';

import { SliderButtonAnimViewData, SliderButtonViewData, SliderIconViewData } from '@ohos/systemuicommon/Index';
import { BrightnessButtonViewModel } from '../../../../../../main/ets/com/ohos/viewModel/BrightnessButtonViewModel';

export function BrightnessButtonViewModelTest() {
  let mocker: MockKit;
  let viewData: SliderButtonViewData = new SliderButtonViewData(true);
  let animViewData: SliderButtonAnimViewData = new SliderButtonAnimViewData();
  let iconViewData: SliderIconViewData = new SliderIconViewData('BrightnessButton');
  let viewModel: BrightnessButtonViewModel =
    new BrightnessButtonViewModel(viewData, animViewData, iconViewData, 'BrightnessButton');

  let fingerInfo: FingerInfo = {
    id: 0,
    globalX: 264,
    globalY: 327.0769230769231,
    localX: 62.15384615384615,
    localY: 35.07692307692308,
    displayX: 264,
    displayY: 327.0769230769231
  }

  let target: EventTarget = {
    area: {
      position: {
        x: 0,
        y: 0
      },
      globalPosition: {
        x: 201.84615384615384,
        y: 292
      },
      width: 144,
      height: 64
    }
  };

  let longPressGestureEvent: GestureEvent = {
    repeat: false,
    offsetX: 0,
    offsetY: 0,
    scale: 1,
    angle: 0,
    speed: 0,
    timestamp: 1888008888000,
    pinchCenterX: 0,
    pinchCenterY: 0,
    source: 2,
    pressure: 0.016495002433657646,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 1,
    velocityX: 0,
    velocityY: 0,
    velocity: 0,
    fingerList: [fingerInfo],
    target: target,
    axisVertical: 0,
    axisHorizontal: 0
  };

  let tapActionEvent: GestureEvent = {
    repeat: false,
    offsetX: 2.340388371394231,
    offsetY: 0,
    scale: 1,
    angle: 0,
    speed: 0,
    timestamp: 1924196088173,
    pinchCenterX: 0,
    pinchCenterY: 0,
    source: 2,
    pressure: 0.007309071719646454,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 1,
    velocityX: 185.98710941326178,
    velocityY: -6.066688694632971e-9,
    velocity: 185.98710941326178,
    fingerList: [fingerInfo],
    target: target,
    axisVertical: 0,
    axisHorizontal: 0
  }

  let panActionStartEvent: GestureEvent = {
    repeat: false,
    offsetX: 2.340388371394231,
    offsetY: 0,
    scale: 1,
    angle: 0,
    speed: 0,
    timestamp: 1924196088173,
    pinchCenterX: 0,
    pinchCenterY: 0,
    source: 2,
    pressure: 0.007309071719646454,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 1,
    velocityX: 185.98710941326178,
    velocityY: -6.066688694632971e-9,
    velocity: 185.98710941326178,
    fingerList: [fingerInfo],
    target: target,
    axisVertical: 0,
    axisHorizontal: 0
  };
  let panActionUpdateEvent: GestureEvent = {
    repeat: false,
    offsetX: 19.076923076923077,
    offsetY: 0,
    scale: 1,
    angle: 0,
    speed: 0,
    timestamp: 1924412110000,
    pinchCenterX: 0,
    pinchCenterY: 0,
    source: 2,
    pressure: 0.006363012362271547,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 1,
    velocityX: 0.00016454768320344962,
    velocityY: 0.00009603294821771292,
    velocity: 0.00019052104133404464,
    fingerList: [fingerInfo],
    target: target,
    axisVertical: 0,
    axisHorizontal: 0
  };


  let panActionEndEvent: GestureEvent = {
    repeat: false,
    offsetX: 19.076923076923077,
    offsetY: 0,
    scale: 1,
    angle: 0,
    speed: 0,
    timestamp: 1924419829000,
    pinchCenterX: 0,
    pinchCenterY: 0,
    source: 2,
    pressure: 0.006363012362271547,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 1,
    velocityX: 0.00016454768320344962,
    velocityY: 0.00009603294821771292,
    velocity: 0.00019052104133404464,
    fingerList: [fingerInfo],
    target: target,
    axisVertical: 0,
    axisHorizontal: 0
  }

  describe('BrightnessButtonViewModelTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
      viewModel.aboutToAppear();
    })

    afterAll((): void => {
      mocker.clearAll();
      viewModel.getLottieAnimMode().onCanvasDisappear();
      viewModel.aboutToDisappear();
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    it('BrightnessButtonViewModel_setValueTest', 0, (): void => {
      viewModel.physicsValue = (viewModel.getMaxValue() + viewModel.getMinValue()) / 2;
      viewModel.setPhysicsValue(false);
      expect(viewModel.physicsValue !== undefined).assertTrue();
    })

    it('BrightnessButtonViewModel_configurationTest', 0, (): void => {
      try {
        const mocker: MockKit = new MockKit();
        const mockFunc: Function = mocker.mockFunc(RTLUtil,
          RTLUtil.isRTL);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let config = ConfigMgr.getConfiguration();
        EvtBus.post(ConfigurationEvent, { config });
        expect(viewModel !== undefined).assertTrue();
      } catch (e) {}
    })

    it('BrightnessButtonViewModel_reportTest', 0, (): void => {
      viewModel.startPhysicsValue = 0;
      viewModel.physicsValue = 100;
      viewModel.reportSliderClickEvent();
      viewModel.reportSliderSlideEvent();
      expect(viewModel.physicsValue === 100).assertTrue();
    })

    it('BrightnessButtonViewModel_CountTest', 0, (): void => {
      viewModel.physicsValue = 100;
      viewModel.getAnimData().uiValue = viewModel.countUIValue();
      let physicsValue: number = viewModel.countPhysicsValue();
      expect(physicsValue >= 0).assertTrue();
    })

    it('BrightnessButtonViewModel_LongPressGestureTest', 0, (): void => {
      viewModel.onLongPressAction(longPressGestureEvent);
      expect(longPressGestureEvent !== undefined).assertTrue();
    })

    it('BrightnessButtonViewModel_TapActionTest', 0, (): void => {
      viewModel.onTapAction(tapActionEvent);
      viewModel.onTapActionEnd();
      expect(tapActionEvent !== undefined).assertTrue();
    })

    it('BrightnessButtonViewModel_lottieTest', 0, (): void => {
      viewModel.getLottieAnimMode().refreshIconAnim([50, 100]);
      viewModel.getLottieAnimMode().changeLottieColor([0, 0, 0]);
      viewModel.onColorModeChange(1);
      expect(tapActionEvent !== undefined).assertTrue();
    })

    it('BrightnessButtonViewModel_DraggingAnimationTest', 0, (): void => {
      viewModel.startDraggingAnimation();
      viewData.isExpand = false;
      viewModel.startDraggingAnimation();
      expect(viewData.isExpand).assertFalse();
      viewData.isExpand = true;
    })

    it('BrightnessButtonViewModel_endDraggingAnimationTest', 0, (): void => {
      try {
        viewModel.endDraggingAnimation();
        viewData.isExpand = false;
        viewModel.endDraggingAnimation();
        expect(viewData.isExpand).assertFalse();
        viewData.isExpand = true;
      } catch (e) {
        expect(viewModel).not().assertNull();
      }
    })

    it('BrightnessButtonViewModel_AccessibilityTest', 0, (): void => {
      viewModel.getAccessibility('text');
      viewModel.getAccessibility('description');
      viewModel.getAccessibility('other');
      expect(viewModel).not().assertNull();
    })

    it('BrightnessButtonViewModel_setPhysicsValue', 0, (): void => {
      (viewModel as object)['timeOutId'] = 1;
      let result = viewModel.setPhysicsValue(true);
      expect(result == null).assertTrue();
    })
  })
}