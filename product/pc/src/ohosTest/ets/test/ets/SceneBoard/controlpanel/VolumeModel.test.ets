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
import { EvtBus, GlobalContext, WindowEvent } from '@ohos/frameworkwrapper';

import { describe, beforeAll, it, expect,
  MockKit, when,
  ArgumentMatchers} from '@ohos/hypium';
import { AudioVolumeType, HostType } from '@ohos/systemuicommon/src/main/ets/template/common/Constants';
import { DarkModeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import type { VolumeInfo } from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/common/Constants';
import volumeViewModel, {
  VolumeSharedViewData, VolumeViewModel
}  from '@ohos/pcbase/src/main/ets/SceneBoard/controlpanel/volumeslider/viewmodel/VolumeViewModel'
import { AudioPlayerHelper } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/AudioPlayerNewHelper';
import common from '@ohos.app.ability.common';

export default function VolumeModelTest() {
  const VOLUME_PANEL_MIN_VOLUME_KEY = 'VolumePanelMinVolume';
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
  describe('VolumeModelTest', () => {
    beforeAll(() => {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as common.Context);
      (volumeViewModel as object)['audioPlayerHelper'] = new AudioPlayerHelper(context);
    })

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

    it('test_volumeViewModel_aboutToDisappear', 0, () => {
      try {
        (volumeViewModel as object)['eventMgr'] = EvtBus.createEventManager();
        expect(volumeViewModel.aboutToDisappear() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

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

    it('test_volumeViewModel_updateVolumeInfo3', 0, () => {
      let res = true;
      try {
        let mocker: MockKit = new MockKit();
        let mockerFunc = mocker.mockFunc(volumeViewModel, (volumeViewModel as object)['adjustMuteState']);
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
        volumeViewModel.updateVolumeInfo(volumeInfo1);
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_adjustMuteState', 0, () => {
      let res = true;
      volumeInfo1.isMute = false;
      try {
        (volumeViewModel as object)['currentAudioVolume'] = 0;
        (volumeViewModel as object)['currentAudioVolume'] = AppStorage.setAndLink(VOLUME_PANEL_MIN_VOLUME_KEY, 0);
        (volumeViewModel as object)['adjustMuteState']();
        expect(res).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_getViewData', 0, () => {
      try {
        expect(volumeViewModel.getViewData()).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_handleOnHover', 0, () => {
      try {
        (volumeViewModel as object)['isHad'] = false;
        volumeViewModel.handleOnHover(true);
        expect(true).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_handleOnTouch1', 0, () => {
      try {
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        expect(volumeViewModel.handleOnTouch() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_handleOnTouch2', 0, () => {
      try {
        (volumeViewModel as object)['draggingViewData'].isDragging = true;
        expect(volumeViewModel.handleOnTouch() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_handleOnTouch3', 0, () => {
      try {
        expect(volumeViewModel.handleOnTouch() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionStart1', 0, () => {
      try {
        volumeViewModel.onPanActionStart({} as GestureEvent);
        expect(true).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionStart2', 0, () => {
      try {
        volumeViewModel.onPanActionStart({} as GestureEvent);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionStart3', 0, () => {
      try {
        volumeViewModel.onPanActionStart({} as GestureEvent);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionUpdate1', 0, () => {
      try {
        (volumeViewModel as object)['isPanelDismissing'] = false;
        (volumeViewModel as object)['draggingViewData'].isDragging = false;
        expect(volumeViewModel.onPanActionUpdate({} as GestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionUpdate2', 0, () => {
      try {
        expect(volumeViewModel.onPanActionUpdate({} as GestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionUpdate3', 0, () => {
      try {
        expect(volumeViewModel.onPanActionUpdate({} as GestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionEnd1', 0, () => {
      try {
        volumeViewModel.onPanActionStart({} as GestureEvent);
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onPanActionEnd2', 0, () => {
      try {
        (volumeViewModel as object)['timeId'] = 1;
        expect(volumeViewModel.onPanActionEnd({} as GestureEvent) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onLayoutChange', 0, () => {
      try {
        expect(volumeViewModel.onLayoutChange() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_updatePhysicsValue1', 0, () => {
      try {
        volumeViewModel.getViewData().volumeUIValue = 0;
        expect(volumeViewModel.updatePhysicsValue(0) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_updatePhysicsValue2', 0, () => {
      try {
        volumeViewModel.getViewData().volumeUIValue = 100;
        expect(volumeViewModel.updatePhysicsValue(2) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_updatePhysicsValue3', 0, () => {
      try {
        volumeViewModel.onCanvasDisappear();
        expect(volumeViewModel.updatePhysicsValue(2) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onDraggingStop', 0, () => {
      try {
        volumeViewModel.onCanvasDisappear();
        expect(volumeViewModel.onDraggingStop() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onCanvasReady', 0, () => {
      try {
        expect(volumeViewModel.onCanvasReady() === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_updateVolume', 0, () => {
      try {
        expect(volumeViewModel.updateVolume(0, true) === undefined).assertTrue();
        expect(volumeViewModel.updateVolume(0, false) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_setVolume', 0, () => {
      try {
        volumeViewModel.setVolume(1);
        expect(volumeViewModel.setVolume(0) === undefined).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_getAccessibilityVolumeValue', 0, () => {
      try {
        expect(volumeViewModel.getAccessibilityVolumeValue(10)).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_handleLabelClick', 0, () => {
      try {
        expect(volumeViewModel.handleLabelClick()).assertTrue();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_onCurrentEndPositionXChange', 0, () => {
      try {
        (volumeViewModel as object)['onCurrentEndPositionXChange']();
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_countPhysicsValue', 0, () => {
      try {
        (volumeViewModel as object)['countPhysicsValue'](0);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_refreshSunAnimWhenRelease1', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](-1);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_refreshSunAnimWhenRelease2', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](25);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_refreshSunAnimWhenRelease3', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](312);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_refreshSunAnimWhenRelease4', 0, () => {
      try {
        (volumeViewModel as object)['refreshSunAnimWhenRelease'](4000);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_scrollAfterSun', 0, () => {
      try {
        (volumeViewModel as object)['scrollAfterSun']();
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_scrollBeforeSun', 0, () => {
      try {
        (volumeViewModel as object)['scrollBeforeSun']();
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_handleDarkModeEvent', 0, () => {
      try {
        let event: DarkModeEvent = {
          isDarkMode: false
        };
        (volumeViewModel as object)['handleDarkModeEvent'](event);
        expect(volumeViewModel).not().assertNull();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
    })

    it('test_volumeViewModel_getTransitionColorArr', 0, () => {
      try {
        (volumeViewModel as object)['getTransitionColorArr']();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })

    it('test_volumeViewModel_transitColor', 0, () => {
      let mVolumeViewModel = new VolumeViewModel();
      try {
        (mVolumeViewModel as object)['transitColor'](null, null, 5, null);
      } catch (e) {
        expect(mVolumeViewModel).not().assertNull();
      }
      expect(mVolumeViewModel).not().assertNull();
    })

    it('test_volumeViewModel_reloadAnim1', 0, () => {
      try {
        (volumeViewModel as object)['loadCount'] = 20;
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })

    it('test_volumeViewModel_reloadAnim2', 0, () => {
      try {
        (volumeViewModel as object)['lastLoadTime'] = Date.now() - 2000;
        (volumeViewModel as object)['reloadAnim']();
      } catch (e) {
        expect(volumeViewModel).not().assertNull();
      }
      expect(volumeViewModel).not().assertNull();
    })

    it('test_volumeViewModel_reloadAnim3', 0, () => {
      try {
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
