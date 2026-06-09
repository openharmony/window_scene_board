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
  VOLUME_PANEL_MAX_KEY,
  VOLUME_PANEL_MIN_KEY
} from '../../../../../main/ets/com/ohos/viewmodel/VolumePanelVM';
import Constants from '../../../../../main/ets/com/ohos/common/Constants';
import ViewModel from '../../../../../main/ets/com/ohos/viewmodel/VolumePanelVM';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { LogDomain, LogHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import { DeviceHelper, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { curves } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
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
} from '@ohos/hypium';
import { VolumePanelViewModel } from '../../../../../main/ets/com/ohos/viewmodel/PCVolumePanelViewModel';

export default function VolumePanelModelTest() {
  describe('VolumePanelModel', () => {
    it('should_calculate_sound_range_correctly', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      expect(soundPanelViewModel.getVolumeRange()).assertEqual(50);
    });

    it('should_calculate_ui_sound_correctly', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      expect(soundPanelViewModel.getVolumeUIValue()).assertEqual(15.6);
    });

    it('should_link_maxVolume_and_minVolume_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      expect(soundpanelviewmodel.maxVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.minVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.maxVolume.get()).assertEqual(Constants.DEFAULT_MAX_VOLUME);
      expect(soundpanelviewmodel.minVolume.get()).assertEqual(Constants.DEFAULT_MIN_VOLUME);
    });

    it('should_call_DeviceHelper_isPC_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc)().afterReturn(true);
      soundpanelviewmodel.aboutToAppear(0);
      expect(soundpanelviewmodel.isPc).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_update_sound_on_touch_event', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      soundPanelViewModel.handleOnTouch(new TouchEvent(TouchType.Move, 0, 0, 100, 100));
      expect(soundPanelViewModel.getVolumeUIValue()).assertEqual(100);
    });

    it('should_update_sound_on_pan_action_start', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      soundPanelViewModel.onPanActionStart(new GestureEvent(TouchType.Down, 0, 0, 100, 100));
      expect(soundPanelViewModel.getVolumeUIValue()).assertEqual(100);
    });

    it('should_update_sound_on_pan_action_update', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      soundPanelViewModel.onPanActionStart(new GestureEvent(TouchType.Down, 0, 0, 100, 100));
      soundPanelViewModel.onPanActionUpdate(new GestureEvent(TouchType.Move, 0, 0, 50, 50));
      expect(soundPanelViewModel.getVolumeUIValue()).assertEqual(25);
    });

    it('should_update_sound_on_pan_action_end', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      soundPanelViewModel.onPanActionStart(new GestureEvent(TouchType.Down, 0, 0, 100, 100));
      soundPanelViewModel.onPanActionUpdate(new GestureEvent(TouchType.Move, 0, 0, 50, 50));
      soundPanelViewModel.onPanActionEnd(new GestureEvent(TouchType.Up, 0, 0, 50, 50));
      expect(soundPanelViewModel.getVolumeUIValue()).assertEqual(25);
    });

    it('should_link_maxVolume_and_minVolume_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      expect(soundpanelviewmodel.maxVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.minVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.maxVolume.get()).assertEqual(Constants.DEFAULT_MAX_VOLUME);
      expect(soundpanelviewmodel.minVolume.get()).assertEqual(Constants.DEFAULT_MIN_VOLUME);
    });

    it('should_call_DeviceHelper_isPC_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc)().afterReturn(true);
      soundpanelviewmodel.aboutToAppear(0);
      expect(soundpanelviewmodel.isPc).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_link_maxVolume_and_minVolume_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      expect(soundpanelviewmodel.maxVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.minVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.maxVolume.get()).assertEqual(Constants.DEFAULT_MAX_VOLUME);
      expect(soundpanelviewmodel.minVolume.get()).assertEqual(Constants.DEFAULT_MIN_VOLUME);
    });

    it('should_call_DeviceHelper_isPC_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc)().afterReturn(true);
      soundpanelviewmodel.aboutToAppear(0);
      expect(soundpanelviewmodel.isPc).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_update_sound_on_update_sound_call', 0, () => {
      let soundPanelViewModel = new VolumePanelViewModel();
      let maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, 100);
      let minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, 0);
      soundPanelViewModel.aboutToAppear(50);
      soundPanelViewModel.updateVolume(75);
      expect(soundPanelViewModel.getVolumeUIValue()).assertEqual(75);
    });
    it('should_log_error_when_sound_is_not_changed', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(10);

      mocker.ignoreMock(LogHelper, LogHelper.error);
    });
    it('should_update_mPhysicsValue_and_call_animateTo_when_sound_is_changed', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(20);

      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(20);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_call_animateTo_with_correct_parameters_when_sound_is_changed', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(30);

      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_update_viewData_soundUIValue_when_sound_is_changed', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(40);

      expect(soundpanelviewmodel.viewData.soundUIValue).assertEqual(40);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_update_mPhysicsValue_and_call_animateTo_when_sound_is_changed_on_PC', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(20);

      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(20);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_call_animateTo_with_correct_parameters_when_sound_is_changed_on_PC', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(30);

      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_update_viewData_soundUIValue_when_sound_is_changed_on_PC', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(40);

      expect(soundpanelviewmodel.viewData.soundUIValue).assertEqual(40);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_update_mPhysicsValue_and_call_animateTo_when_sound_is_changed_on_non_PC', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(20);

      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(20);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_call_animateTo_with_correct_parameters_when_sound_is_changed_on_non_PC', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(30);

      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_update_viewData_soundUIValue_when_sound_is_changed_on_non_PC', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(40);

      expect(soundpanelviewmodel.viewData.soundUIValue).assertEqual(40);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_update_mPhysicsValue_and_call_animateTo_when_sound_is_changed_with_RTL', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPc = false;
      soundpanelviewmodel.isRtl = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyFunction).afterReturn(null);

      soundpanelviewmodel.updatePhysicsValue(20);

      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(20);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.animateTo);
    });
    it('should_stopPropagation_when_event_type_is_Move_and_isDragging_is_true_and_stopPropagation_is_true', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation = true;
      soundpanelviewmodel.draggingViewData.isDragging = true;
      soundpanelviewmodel.handleOnTouch(event);
      expect(event.stopPropagation).assertEqual(true);
    });
    it('should_do_nothing_when_event_type_is_Move_and_isDragging_is_false', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation = false;
      soundpanelviewmodel.draggingViewData.isDragging = false;
      soundpanelviewmodel.handleOnTouch(event);
      expect(event.stopPropagation).assertEqual(false);
    });
    it('should_do_nothing_when_event_type_is_Move_and_isDragging_is_true_but_stopPropagation_is_false', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation = false;
      soundpanelviewmodel.draggingViewData.isDragging = true;
      soundpanelviewmodel.handleOnTouch(event);
      expect(event.stopPropagation).assertEqual(false);
    });
    it('should_animate_to_when_event_type_is_Down_and_isDragging_is_true', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      event.touches = [{ x: 50 }];
      soundpanelviewmodel.draggingViewData.isDragging = true;
      soundpanelviewmodel.handleOnTouch(event);
      expect(soundpanelviewmodel.viewData.soundUIValue).assertEqual(50);
    });
    it('should_update_sound_when_event_type_is_Down_and_isDragging_is_true_and_report_event', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      event.touches = [{ x: 50 }];
      soundpanelviewmodel.draggingViewData.isDragging = true;
      soundpanelviewmodel.handleOnTouch(event);
      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(50);
    });
    it('should_return_immediately_when_not_dragging', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.draggingViewData.isDragging = false;
      soundpanelviewmodel.onPanActionEnd(new GestureEvent());
      expect(soundpanelviewmodel.draggingViewData.isDragging).assertEqual(false);
    });

    it('should_return_immediately_when_panel_is_dismissing', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.isPanelDismissing = true;
      soundpanelviewmodel.onPanActionEnd(new GestureEvent());
      expect(soundpanelviewmodel.isPanelDismissing).assertEqual(true);
    });

    it('should_update_sound_when_dragging_and_not_dismissing', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      soundpanelviewmodel.draggingViewData.isDragging = true;
      soundpanelviewmodel.isPanelDismissing = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ViewModel, ViewModel.reportSlideSelectedVolBar);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      let mockfunc2: Function = mocker.mockFunc(ViewModel, ViewModel.updateVolume);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      soundpanelviewmodel.onPanActionEnd(new GestureEvent());
      expect(soundpanelviewmodel.draggingViewData.isDragging).assertEqual(false);
      mocker.ignoreMock(ViewModel, ViewModel.reportSlideSelectedVolBar);
      mocker.ignoreMock(ViewModel, ViewModel.updateVolume);
    });

    it('should_return_sound_when_sound_range_is_zero', 0, () => {
      let soundpanelviewmodel: ViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();

      let result = soundpanelviewmodel.getAccessibilityVolumeValue(10);
      expect(result).assertEqual('10');
    });

    it('should_return_percent_when_sound_range_is_not_zero', 0, () => {
      let soundpanelviewmodel: ViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let result = soundpanelviewmodel.getAccessibilityVolumeValue(50);
      expect(result).assertEqual('50');

    });

    it('should_initialize_VolumePanelViewModel_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(0);
      expect(soundpanelviewmodel.viewData.soundUIValue).assertEqual(0);
    });

    it('should_update_mPhysicsValue_and_viewData_soundUIValue_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mPhysicsValue: number = 5;
      soundpanelviewmodel.aboutToAppear(mPhysicsValue);
      expect(soundpanelviewmodel.mPhysicsValue).assertEqual(mPhysicsValue);
      expect(soundpanelviewmodel.viewData.soundUIValue).assertEqual(mPhysicsValue);
    });

    it('should_link_maxVolume_and_minVolume_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      expect(soundpanelviewmodel.maxVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.minVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.maxVolume.get()).assertEqual(Constants.DEFAULT_MAX_VOLUME);
      expect(soundpanelviewmodel.minVolume.get()).assertEqual(Constants.DEFAULT_MIN_VOLUME);
    });

    it('should_call_DeviceHelper_isPC_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc)().afterReturn(true);
      soundpanelviewmodel.aboutToAppear(0);
      expect(soundpanelviewmodel.isPc).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_call_HiDfxEventUtil_initHiDfxEvent_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.initHiDfxEvent);
      when(mockfunc)().afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.initHiDfxEvent);
    });

    it('should_call_LogHelper_info_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_call_LogDomain_info_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogDomain, LogDomain.info);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(LogDomain, LogDomain.info);
    });

    it('should_link_maxVolume_and_minVolume_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      expect(soundpanelviewmodel.maxVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.minVolume).assertInstanceOf(SubscribedAbstractProperty);
      expect(soundpanelviewmodel.maxVolume.get()).assertEqual(Constants.DEFAULT_MAX_VOLUME);
      expect(soundpanelviewmodel.minVolume.get()).assertEqual(Constants.DEFAULT_MIN_VOLUME);
    });

    it('should_call_DeviceHelper_isPC_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc)().afterReturn(true);
      soundpanelviewmodel.aboutToAppear(0);
      expect(soundpanelviewmodel.isPc).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_call_AnimateToScheduleUtils_init_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AnimateToScheduleUtils, AnimateToScheduleUtils.init);
      when(mockfunc)().afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(AnimateToScheduleUtils, AnimateToScheduleUtils.init);
    });

    it('should_call_curves_init_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(curves, curves.init);
      when(mockfunc)().afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(curves, curves.init);
    });

    it('should_call_RTLUtil_init_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.init);
      when(mockfunc)().afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(RTLUtil, RTLUtil.init);
    });

    it('should_call_DropDownPanelManager_init_correctly', 0, () => {
      let soundpanelviewmodel: VolumePanelViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.init);
      when(mockfunc)().afterReturnNothing();
      soundpanelviewmodel.aboutToAppear(0);
      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.init);
    });

    it('should_return_sound_when_sound_range_is_zero', 0, () => {
      let soundpanelviewmodel: ViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();

      let result = soundpanelviewmodel.getAccessibilityVolumeValue(10);
      expect(result).assertEqual('10');
    });

    it('should_return_percent_when_sound_range_is_not_zero', 0, () => {
      let soundpanelviewmodel: ViewModel = new VolumePanelViewModel();
      let mocker: MockKit = new MockKit();
      let result = soundpanelviewmodel.getAccessibilityVolumeValue(50);
      expect(result).assertEqual('50');

    });
  });
}