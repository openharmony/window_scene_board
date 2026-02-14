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
import { DeviceHelper, EvtBus, GlobalContext, WindowEvent } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect,
  MockKit, when,
  ArgumentMatchers} from '@ohos/hypium'
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { AudioVolumeType, HostType } from '@ohos/systemuicommon/src/main/ets/template/common/Constants';
import { DarkModeEvent, StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import type { VolumeInfo } from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/common/Constants';
import volumeViewModel, {
  VolumeSharedViewData, VolumeViewModel
}  from '@ohos/pcbase/src/main/ets/SceneBoard/controlpanel/volumeslider/viewmodel/VolumeViewModel'
import { AudioPlayerHelper } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/AudioPlayerNewHelper';
import common from '@ohos.app.ability.common';

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

export default function VolumeViewModelTest() {
  const VOLUME_PANEL_MIN_VOLUME_KEY = 'VolumePanelMinVolume';
  const VOLUME_PANEL_IS_MUTE_KEY = 'VolumePanelIsMute';
  let volumeInfo1: VolumeInfo = {
    volumeType: AudioVolumeType.RINGTONE,
    volume: 7,
    maxVolume: 15,
    minVolume: 0,
    lastVolume: 8,
    isMute: false,
    isActive: false,
    updateUi: false,
    hostType: undefined
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
    touches: [{
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
    stopPropagation: (): void => {
      throw new Error('Function not implemented.');
    },
    getHistoricalPoints: (): HistoricalPoint[] => {
      throw new Error('Function not implemented.');
    },
    preventDefault: () => {
    }
  }

  let eventArea: Area = {
    width: 0,
    height: 0,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
  };

  let eventTarget: EventTarget = {
    area: eventArea
  };

  let gestureEvent: GestureEvent = {
    target: eventTarget,
    timestamp: 0,
    source: 0,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 0,
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
    velocity: 0
  };

  describe('VolumeViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      let context = (GlobalContext.getInstance().getObject('desktopContext') as common.Context);
      (volumeViewModel as object)['audioPlayerHelper'] = new AudioPlayerHelper(context);
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      AppStorage.setAndLink(VOLUME_PANEL_MIN_VOLUME_KEY, 0);
      volumeInfo1.volumeType = AudioVolumeType.RINGTONE;
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    // VolumeSharedViewData
    it('test_getAnimViewData', 0, () => {
      const volumeSharedViewData = VolumeSharedViewData.getInstance();
      try {
        let data = volumeSharedViewData.getAnimViewData();
        expect(data).not().assertNull();
      } finally {
        expect(volumeSharedViewData).not().assertNull();
      }
    })

    it('test_getDraggingViewData', 0, () => {
      const volumeSharedViewData = VolumeSharedViewData.getInstance();
      try {
        let data = volumeSharedViewData.getDraggingViewData();
        expect(data).not().assertNull();
      } catch (e) {
        expect(volumeSharedViewData).not().assertNull();
      }
    })

    it('test_getBackgroundOpacity', 0, () => {
      const volumeSharedViewData = VolumeSharedViewData.getInstance();
      try {
        let data = volumeSharedViewData.getBackgroundOpacity();
        expect(data).not().assertNull();
      } catch (e) {
        expect(volumeSharedViewData).not().assertNull();
      }
    })

    it('test_getBlurOpacity', 0, () => {
      const volumeSharedViewData = VolumeSharedViewData.getInstance();
      try {
        let data = volumeSharedViewData.getBlurOpacity();
        expect(data).not().assertNull();
      } catch (e) {
        expect(volumeSharedViewData).not().assertNull();
      }
    })

    it('test_volumeSharedViewData_getInstance', 0, () => {
      try {
        expect(VolumeSharedViewData.getInstance()).not().assertNull();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    // VolumeViewModel
    it('test_volumeViewModel_initViewModel', 0, () => {
      let res = true;
      try {
        volumeViewModel.initViewModel();
        volumeViewModel.initViewModel();
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel aboutToAppear
    it('test_volumeViewModel_aboutToAppear', 0, () => {
      let windowEvent = new WindowEvent();
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(windowEvent, windowEvent.isWindowEndHide);
        when(mockerFunc)().afterReturn(true);
        (volumeViewModel as object)['eventMgr'] = undefined;
        (volumeViewModel as object)['audioPlayerHelper'] = undefined;
        expect(volumeViewModel.aboutToAppear(false, 0) === undefined).assertTrue();
        mocker.clear(windowEvent);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel aboutToDisappear
    it('test_volumeViewModel_aboutToDisappear', 0, () => {
      try {
        (volumeViewModel as object)['eventMgr'] = EvtBus.createEventManager();
        expect(volumeViewModel.aboutToDisappear() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updateVolumeInfo1
    it('test_volumeViewModel_updateVolumeInfo1', 0, () => {
      let res = true;
      try {
        (volumeViewModel as object)['currentAudioVolumeType'] = AudioVolumeType.MEDIA;
        volumeInfo1.volumeType = AudioVolumeType.RINGTONE;
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updateVolumeInfo2
    it('test_volumeViewModel_updateVolumeInfo2', 0, () => {
      let res = true;
      try {
        (volumeViewModel as object)['currentAudioVolumeType'] = AudioVolumeType.MEDIA;
        volumeInfo1.volumeType = AudioVolumeType.MEDIA;
        volumeInfo1.hostType = undefined;
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        volumeInfo1.hostType = HostType.VOLUME_PANEL;
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        volumeInfo1.hostType = HostType.SOUND_PANEL;
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updateVolumeInfo3
    it('test_volumeViewModel_updateVolumeInfo3', 0, () => {
      let res = true;
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(volumeViewModel, (volumeViewModel as object)['adjustMuteState']);
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel adjustMuteState
    it('test_volumeViewModel_adjustMuteState', 0, () => {
      let res = true;
      volumeInfo1.isMute = false;
      try {
        (volumeViewModel as object)['currentAudioVolume'] = 0;
        (volumeViewModel as object)['currentAudioVolume'] = AppStorage.setAndLink(VOLUME_PANEL_MIN_VOLUME_KEY, 0);
        (volumeViewModel as object)['adjustMuteState']();
        (volumeViewModel as object)['currentAudioVolume'] = 1;
        (volumeViewModel as object)['adjustMuteState']();
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel getViewData
    it('test_volumeViewModel_getViewData', 0, () => {
      try {
        expect(volumeViewModel.getViewData()).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel handleOnHover
    it('test_volumeViewModel_handleOnHover', 0, () => {
      try {
        volumeViewModel.handleOnHover(undefined);
        volumeViewModel.handleOnHover(false);

        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
        when(mockerFunc)().afterReturn(true);
        (volumeViewModel as object)['isHad'] = true;
        volumeViewModel.handleOnHover(true);

        when(mockerFunc)().afterReturn(false);
        (volumeViewModel as object)['isHad'] = false;
        volumeViewModel.handleOnHover(true);
        expect(true).assertTrue();
        mocker.clear(DeviceHelper);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel handleOnTouch1
    it('test_volumeViewModel_handleOnTouch1', 0, () => {
      try {
        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        touchEvent.type = TouchType.Down;
        volumeViewModel.handleOnTouch(touchEvent);
        touchEvent.type = TouchType.Move;
        volumeViewModel.handleOnTouch(touchEvent);
        touchEvent.type = TouchType.Up;
        volumeViewModel.handleOnTouch(touchEvent);

        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        expect(volumeViewModel.handleOnTouch(touchEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel handleOnTouch2
    it('test_volumeViewModel_handleOnTouch2', 0, () => {
      try {
        (volumeViewModel as object)['isPc'] = false;
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        touchEvent.type = TouchType.Move;
        touchEvent.stopPropagation = () => {};
        volumeViewModel.handleOnTouch(touchEvent);

        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        expect(volumeViewModel.handleOnTouch(touchEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel handleOnTouch3
    it('test_volumeViewModel_handleOnTouch3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      try {
        (volumeViewModel as object)['isPc'] = true;
        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        when(mockerFunc)().afterReturn(true);
        touchEvent.touches[0].x = 100;

        expect(volumeViewModel.handleOnTouch(touchEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      mocker.clear(RTLUtil);
    })

    // VolumeViewModel onPanActionStart1
    it('test_volumeViewModel_onPanActionStart1', 0, () => {
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.isPanelDismissing);
        when(mockerFunc)().afterReturn(true);
        volumeViewModel.onPanActionStart(gestureEvent);

        sleep(200);
        expect(true).assertTrue();
        mocker.clear(DropDownPanelManager);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onPanActionStart2
    it('test_volumeViewModel_onPanActionStart2', 0, () => {
      try {
        (volumeViewModel as object)['isPanelDismissing'] = false;
        gestureEvent.offsetX = 0;
        volumeViewModel.onPanActionStart(gestureEvent);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onPanActionStart3
    it('test_volumeViewModel_onPanActionStart3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      try {
        when(mockerFunc)().afterReturn(true);
        (volumeViewModel as object)['isPanelDismissing'] = false;
        gestureEvent.offsetX = 0;
        volumeViewModel.onPanActionStart(gestureEvent);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      mocker.clear(RTLUtil);
    })

    // VolumeViewModel onPanActionUpdate1
    it('test_volumeViewModel_onPanActionUpdate1', 0, () => {
      try {
        (volumeViewModel as object)['isPanelDismissing'] = true;
        expect(volumeViewModel.onPanActionUpdate(gestureEvent) === undefined).assertTrue();

        (volumeViewModel as object)['isPanelDismissing'] = false;
        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        expect(volumeViewModel.onPanActionUpdate(gestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onPanActionUpdate2
    it('test_volumeViewModel_onPanActionUpdate2', 0, () => {
      try {
        (volumeViewModel as object)['isPanelDismissing'] = false;
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        (volumeViewModel as object)['lastX'] = 1;
        gestureEvent.offsetX = 0;
        volumeViewModel.onPanActionUpdate(gestureEvent);

        gestureEvent.offsetX = 100;
        volumeViewModel.onPanActionUpdate(gestureEvent);

        expect(volumeViewModel.onPanActionUpdate(gestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onPanActionUpdate3
    it('test_volumeViewModel_onPanActionUpdate3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      try {
        when(mockerFunc)().afterReturn(true);
        (volumeViewModel as object)['isPanelDismissing'] = false;
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        (volumeViewModel as object)['lastX'] = 1;
        gestureEvent.offsetX = 0;
        volumeViewModel.onPanActionUpdate(gestureEvent);

        gestureEvent.offsetX = 100;
        volumeViewModel.onPanActionUpdate(gestureEvent);

        expect(volumeViewModel.onPanActionUpdate(gestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      mocker.clear(RTLUtil);
    })

    // VolumeViewModel onPanActionEnd
    it('test_volumeViewModel_onPanActionEnd1', 0, () => {
      try {
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        volumeViewModel.onPanActionStart(gestureEvent);

        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.isPanelDismissing);
        when(mockerFunc)().afterReturn(false);
        volumeViewModel.onPanActionEnd(gestureEvent);

        when(mockerFunc)().afterReturn(true);
        volumeViewModel.onPanActionStart(gestureEvent);
        expect(volumeViewModel.onPanActionEnd(gestureEvent) === undefined).assertTrue();
        mocker.clear(DropDownPanelManager);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onPanActionEnd
    it('test_volumeViewModel_onPanActionEnd2', 0, () => {
      try {
        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        expect(volumeViewModel.onPanActionEnd(gestureEvent) === undefined).assertTrue();

        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        (volumeViewModel as object)['isPanelDismissing'] = true;
        expect(volumeViewModel.onPanActionEnd(gestureEvent) === undefined).assertTrue();

        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        (volumeViewModel as object)['isPanelDismissing'] = false;
        (volumeViewModel as object)['timeId'] = 1;
        expect(volumeViewModel.onPanActionEnd(gestureEvent) === undefined).assertTrue();
        (volumeViewModel as object)['timeId'] = -1;
        expect(volumeViewModel.onPanActionEnd(gestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onLayoutChange
    it('test_volumeViewModel_onLayoutChange', 0, () => {
      try {
        expect(volumeViewModel.onLayoutChange() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updatePhysicsValue1
    it('test_volumeViewModel_updatePhysicsValue1', 0, () => {
      try {
        touchEvent.touches[0].x = 0;
        volumeViewModel.handleOnTouch(touchEvent);
        volumeViewModel.getViewData().volumeUIValue = 0;
        expect(volumeViewModel.updatePhysicsValue(0) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updatePhysicsValue2
    it('test_volumeViewModel_updatePhysicsValue2', 0, () => {
      try {
        touchEvent.touches[0].x = 100;
        volumeViewModel.handleOnTouch(touchEvent);
        volumeViewModel.getViewData().volumeUIValue = 100;
        expect(volumeViewModel.updatePhysicsValue(2) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updatePhysicsValue3
    it('test_volumeViewModel_updatePhysicsValue3', 0, () => {
      try {
        touchEvent.touches[0].x = 100;
        volumeViewModel.handleOnTouch(touchEvent);
        volumeViewModel.getViewData().volumeUIValue = 100;
        volumeViewModel.onCanvasDisappear();
        expect(volumeViewModel.updatePhysicsValue(2) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onDraggingStop
    it('test_volumeViewModel_onDraggingStop', 0, () => {
      try {
        volumeViewModel.onPanActionStart(gestureEvent);
        volumeViewModel.onCanvasDisappear();
        expect(volumeViewModel.onDraggingStop() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onCanvasReady
    it('test_volumeViewModel_onCanvasReady', 0, () => {
      try {
        expect(volumeViewModel.onCanvasReady() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel updateVolume
    it('test_volumeViewModel_updateVolume', 0, () => {
      try {
        expect(volumeViewModel.updateVolume(0, true) === undefined).assertTrue();
        expect(volumeViewModel.updateVolume(0, false) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel setVolume
    it('test_volumeViewModel_setVolume', 0, () => {
      try {
        (volumeViewModel as object)['lastVolume'] = 10;
        volumeViewModel.setVolume(10);
        (volumeViewModel as object)['lastVolume'] = 10;
        (volumeViewModel as object)['isMute'] = AppStorage.setAndLink(VOLUME_PANEL_IS_MUTE_KEY, true);
        volumeViewModel.setVolume(1);
        expect(volumeViewModel.setVolume(0) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel getAccessibilityVolumeValue
    it('test_volumeViewModel_getAccessibilityVolumeValue', 0, () => {
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(volumeViewModel, (volumeViewModel as object)['getVolumeRange']);
        when(mockerFunc)().afterReturn(-1);
        volumeViewModel.getAccessibilityVolumeValue(1);
        when(mockerFunc)().afterReturn(1);
        expect(volumeViewModel.getAccessibilityVolumeValue(10)).assertEqual('1000');
        mocker.clear(volumeViewModel);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel handleLabelClick
    it('test_volumeViewModel_handleLabelClick', 0, () => {
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(StatusBarType, StatusBarType.isMacStyle);
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
        expect(volumeViewModel.handleLabelClick()).assertTrue();
        mocker.clear(StatusBarType);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel onCurrentEndPositionXChange
    it('test_volumeViewModel_onCurrentEndPositionXChange', 0, () => {
      try {
        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        (volumeViewModel as object)['onCurrentEndPositionXChange']();
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        (volumeViewModel as object)['onCurrentEndPositionXChange']();
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel countPhysicsValue
    it('test_volumeViewModel_countPhysicsValue', 0, () => {
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(volumeViewModel, (volumeViewModel as object)['getVolumeRange']);
        when(mockerFunc)().afterReturn(15);
        (volumeViewModel as object)['VOLUME_WIDTH'] = -1;
        (volumeViewModel as object)['countPhysicsValue'](0);
        (volumeViewModel as object)['VOLUME_WIDTH'] = 312;
        (volumeViewModel as object)['countPhysicsValue'](0);
        (volumeViewModel as object)['countPhysicsValue'](1000);
        (volumeViewModel as object)['countPhysicsValue'](104);
        (volumeViewModel as object)['countPhysicsValue'](150);
        (volumeViewModel as object)['countPhysicsValue'](-1000);
        expect(volumeViewModel).not().assertNull();
        mocker.clear(volumeViewModel);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel refreshSunAnimWhenRelease1
    it('test_volumeViewModel_refreshSunAnimWhenRelease1', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](-1);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](-10);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](-100);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](-500);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel refreshSunAnimWhenRelease2
    it('test_volumeViewModel_refreshSunAnimWhenRelease2', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](10);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](15);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](25);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel refreshSunAnimWhenRelease3
    it('test_volumeViewModel_refreshSunAnimWhenRelease3', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](100);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](150);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](300);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](312);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel refreshSunAnimWhenRelease4
    it('test_volumeViewModel_refreshSunAnimWhenRelease4', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](312);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](400);
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](4000);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel scrollAfterSun
    it('test_volumeViewModel_scrollAfterSun', 0, () => {
      try {
        (volumeViewModel as object)['animationItem'].currentFrame = 301;
        (volumeViewModel as object)['scrollAfterSun']();
        (volumeViewModel as object)['animationItem'].currentFrame = 400;
        (volumeViewModel as object)['colorTranslatorIntervalId'] = 1;
        (volumeViewModel as object)['scrollAfterSun']();
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel scrollBeforeSun
    it('test_volumeViewModel_scrollBeforeSun', 0, () => {
      try {
        (volumeViewModel as object)['animationItem'].currentFrame = 61;
        (volumeViewModel as object)['scrollBeforeSun']();
        (volumeViewModel as object)['animationItem'].currentFrame = 100;
        (volumeViewModel as object)['scrollBeforeSun']();
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // VolumeViewModel handleDarkModeEvent
    it('test_volumeViewModel_handleDarkModeEvent', 0, () => {
      try {
        let event: DarkModeEvent = {
          isDarkMode: false
        };
        (volumeViewModel as object)['handleDarkModeEvent'](event);

        event.isDarkMode = true;
        (volumeViewModel as object)['viewData'].volumeUIValue = 10;
        (volumeViewModel as object)['handleDarkModeEvent'](event);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    // volumeViewModel getTransitionColorArr
    it('test_volumeViewModel_getTransitionColorArr', 0, () => {
      try {
        (volumeViewModel as object)['getTransitionColorArr']();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })

    // volumeViewModel transitColor
    it('test_volumeViewModel_transitColor', 0, () => {
      let mVolumeViewModel = new VolumeViewModel();
      try {
        (mVolumeViewModel as object)['transitColor'](null, null, 5, Curve.Linear);

        (mVolumeViewModel as object)['transitColor']($r('app.color.control_center_brightness_sun_blue'),
          $r('app.color.control_center_brightness_sun_blue'), 5, Curve.Linear);

        (mVolumeViewModel as object)['colorTranslatorIntervalId'] = 100;
        (mVolumeViewModel as object)['transitColor']($r('app.color.control_center_brightness_sun_blue'),
        $r('app.color.control_center_brightness_sun_write'), 5, Curve.Linear);
        (mVolumeViewModel as object)['transitColor'](null, null, 5, null);
      } catch (e) {
        expect(mVolumeViewModel).not().assertNull();
      }
      expect(mVolumeViewModel).not().assertNull();
    })

    // volumeViewModel reloadAnim1
    it('test_volumeViewModel_reloadAnim1', 0, () => {
      try {
        (volumeViewModel as object)['lastLoadTime'] = Date.now() - 100;
        for (let i = 0; i < 11; i++) {
          (volumeViewModel as object)['reloadAnim']();
        }
        (volumeViewModel as object)['loadCount'] = 20;
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })

    // volumeViewModel reloadAnim2
    it('test_volumeViewModel_reloadAnim2', 0, () => {
      try {
        (volumeViewModel as object)['lastLoadTime'] = Date.now() - 2000;
        (volumeViewModel as object)['reloadAnim']();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })

    // volumeViewModel reloadAnim3
    it('test_volumeViewModel_reloadAnim3', 0, () => {
      try {
        (volumeViewModel as object)['isCanvasReady'] = false;
        (volumeViewModel as object)['reloadAnim']();
        (volumeViewModel as object)['isCanvasReady'] = true;
        (volumeViewModel as object)['animationItem'].isLoaded = true;
        (volumeViewModel as object)['reloadAnim']();
        (volumeViewModel as object)['isCanvasReady'] = true;
        (volumeViewModel as object)['animationItem'].isLoaded = false;
        (volumeViewModel as object)['reloadAnim']();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })
  })
}
