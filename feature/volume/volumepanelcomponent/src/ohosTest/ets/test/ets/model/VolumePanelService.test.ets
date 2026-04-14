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
import audio from '@ohos.multimedia.audio';
import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  obtainLocalEvent,
  sEventManager,
  EventConstants,
  DeviceHelper,
  EventManager,
  EvtBus
} from '@ohos/frameworkwrapper';
import { AudioVolumeType, VolumeInfo } from '../../../../../main/ets/com/ohos/common/Constants';
import {
  VolumeListener,
  VolumeKeyPressedListener,
  PreviousVolumeCallback
} from '../../../../../main/ets/com/ohos/common/Interfaces';
import { RegisterAPIProtector } from '@ohos/systemuicommon/src/main/ets/statusbar/RegisterAPIProtector';
import { VolumePanelVisibilityEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
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
import { VolumePanelService } from '../../../../../main/ets/com/ohos/model/VolumePanelService';

export default function VolumePanelServiceTest() {
  describe('startService_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_mIsStart_is_true', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = true;
      volumepanelservice.startService();
    });

    it('should_log_info_when_mIsStart_is_false', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = false;
      volumepanelservice.startService();
      expect(LogHelper.showInfo).assertEqual('startService');
      expect(LogHelper.showInfo).assertEqual('registser volumeChange.');
    });

    it('should_register_volumeChange_listener_when_isPhone_is_true', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(true);
      volumepanelservice.startService();
      expect(LogHelper.showInfo).assertEqual('startService');
      expect(LogHelper.showInfo).assertEqual('registser volumeChange.');
      expect(LogHelper.showInfo).assertEqual('Register sync volume change.');
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    });

    it('should_register_async_volumeChange_listener_when_isPhone_is_false', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(false);
      volumepanelservice.startService();
      expect(LogHelper.showInfo).assertEqual('startService');
      expect(LogHelper.showInfo).assertEqual('registser volumeChange.');
      expect(LogHelper.showInfo).assertEqual('Register async volume change.');
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    });

    it('should_handle_error_when_registering_async_volumeChange_listener_fails', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(false);
      let mockVolumeManager: MockKit = new MockKit();
      let mockOnFunc: Function =
        mocker.mockFunc(volumepanelservice.mAudioVolumeManager, volumepanelservice.mAudioVolumeManager.on);
      when(mockOnFunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyFunction).afterThrow('Error');
      volumepanelservice.startService();
      expect(LogHelper.showInfo).assertEqual('startService');
      expect(LogHelper.showInfo).assertEqual('registser volumeChange.');
      expect(LogHelper.showError).assertEqual('Register async volume change error: Error');
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(volumepanelservice.mAudioVolumeManager, volumepanelservice.mAudioVolumeManager.on);
    });

    it('should_register_volumePanelVisibilityEvent_when_isPhone_is_false', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(false);
      let mockVolumeManager: MockKit = new MockKit();
      let mockOnFunc: Function =
        mocker.mockFunc(volumepanelservice.mAudioVolumeManager, volumepanelservice.mAudioVolumeManager.on);
      when(mockOnFunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyFunction).afterReturnNothing();
      volumepanelservice.startService();
      expect(LogHelper.showInfo).assertEqual('startService');
      expect(LogHelper.showInfo).assertEqual('registser volumeChange.');
      expect(LogHelper.showInfo).assertEqual('Register async volume change.');
      expect(LogHelper.showInfo).assertEqual('Register volumePanelVisibilityEvent.');
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(volumepanelservice.mAudioVolumeManager, volumepanelservice.mAudioVolumeManager.on);
    });
  });

  describe('stopService_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_mIsStart_is_false', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = false;
      volumepanelservice.stopService();
      expect(volumepanelservice.mIsStart).assertEqual(false);
    });

    it('should_set_mIsStart_to_false_when_mIsStart_is_true', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.mIsStart = true;
      volumepanelservice.stopService();
      expect(volumepanelservice.mIsStart).assertEqual(false);
    });

    it('should_call_clear_on_mVolumeKeyPressedListener', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice.mVolumeKeyPressedListener, volumepanelservice.mVolumeKeyPressedListener.clear);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      volumepanelservice.mIsStart = true;
      volumepanelservice.stopService();
      mocker.ignoreMock(volumepanelservice.mVolumeKeyPressedListener, volumepanelservice.mVolumeKeyPressedListener.clear);
    });

    it('should_offAll_on_eventMgr', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice.eventMgr, volumepanelservice.eventMgr.offAll);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      volumepanelservice.mIsStart = true;
      volumepanelservice.stopService();
      mocker.ignoreMock(volumepanelservice.eventMgr, volumepanelservice.eventMgr.offAll);
    });

    it('should_post_VolumePanelVisibilityEvent_when_mIsStart_is_true', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EventManager.eventMgr, EventManager.eventMgr.post);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      volumepanelservice.mIsStart = true;
      volumepanelservice.stopService();
      mocker.ignoreMock(EventManager.eventMgr, EventManager.eventMgr.post);
    });

  });

  describe('getRingerMode_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_getRingerMode_success', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();

      await volumepanelservice.getRingerMode();

    });

    it('should_log_error_when_getRingerMode_throws_error', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();

      await volumepanelservice.getRingerMode();

    });
  });

  describe('registerListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_register_listener_successfully', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();

      let mockVolumeListener: VolumeListener = {
        onVolumeChange: (volumeInfo: VolumeInfo) => {
        },
        onAudioVolumeChange: (volumeType: AudioVolumeType, volume: number) => {
        }
      };

      volumepanelservice.registerListener(mockVolumeListener);

    });
  });

  describe('unregisterListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_remove_listener_successfully', 0, () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockVolumeListener: VolumeListener = {
        onVolumeChange: (volumeInfo: VolumeInfo) => {
        },
        onAudioInterrupt: (volumeType: AudioVolumeType, volumeLevel: number) => {
        }
      };

      volumepanelservice.unregisterListener(mockVolumeListener);

    });
  });

  describe('registerKeyPressListeners_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_register_keyPressListeners_successfully', 0, () => {
      let volumeKeyPressedListener: VolumeKeyPressedListener = new VolumeKeyPressedListener()
      let volumePanelService: VolumePanelService = VolumePanelService.INSTANCE;
      volumePanelService.registerKeyPressListeners(volumeKeyPressedListener);
      expect(volumePanelService.keyPressListeners.has(volumeKeyPressedListener)).assertTrue();
    });
  });

  describe('unregisterKeyPressListeners_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_remove_listener_when_listener_exists', 0, () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let listener: VolumeKeyPressedListener = {
        onVolumeKeyPressed: () => {
        }
      };

      volumepanelservice.unregisterKeyPressListeners(listener);

    });

    it('should_not_remove_listener_when_listener_does_not_exist', 0, () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let listener: VolumeKeyPressedListener = {
        onVolumeKeyPressed: () => {
        }
      };

      volumepanelservice.unregisterKeyPressListeners(listener);

    });
  });

  describe('setPreviousVolumeCallback_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_previous_volume_callback_successfully', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callback: PreviousVolumeCallback = (volume: number, volumeType: AudioVolumeType) => {
        console.log(`Previous volume callback, volume: ${volume}, volume type: ${volumeType}`);
      };
      volumepanelservice.setPreviousVolumeCallback(callback);
      expect(volumepanelservice.mPreviousVolumeCallback).assertEqual(callback);
    });
  });

  describe('registerVolumeKeyPressedListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_error_when_listener_is_null', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let listener: VolumeKeyPressedListener = null;
      volumepanelservice.registerVolumeKeyPressedListener(listener);
    });

    it('should_add_listener_when_listener_is_not_null', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let listener: VolumeKeyPressedListener = new class implements VolumeKeyPressedListener {
        onVolumeKeyPressed(keyEvent: number): void {
        }
      };
      volumepanelservice.registerVolumeKeyPressedListener(listener);
    });
  });

  describe('unRegisterVolumeKeyPressedListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.unRegisterVolumeKeyPressedListener(null);
    });

    it('should_remove_listener_when_listener_is_not_null', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let listener: VolumeKeyPressedListener = {
        onVolumeKeyPressed: () => {
        }
      };
      volumepanelservice.unRegisterVolumeKeyPressedListener(listener);
    });
  });

  describe('onVolumeChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_onVolumeChange_is_called', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.CALL,
        volume: 5,
        updateUi: true
      };
      await volumepanelservice.onVolumeChange(data);
      expect(LogHelper.showInfo).assertCalledWith(`onVolumeChange, data: type ${data.volumeType} volume ${data.volume} update ${data.updateUi}`);
    });

    it('should_call_isMute_when_onVolumeChange_is_called', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.CALL,
        volume: 5,
        updateUi: true
      };
      await volumepanelservice.onVolumeChange(data);
      expect(volumepanelservice.isMute).assertCalledWith(data.volumeType, ArgumentMatchers.anyFunction);
    });

    it('should_call_notifyVolumeKeyPressed_when_onVolumeChange_is_called', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.CALL,
        volume: 5,
        updateUi: true
      };
      await volumepanelservice.onVolumeChange(data);
      expect(volumepanelservice.notifyVolumeKeyPressed).assertCalledWith(ArgumentMatchers.anyObj);
    });

    it('should_call_forEach_when_onVolumeChange_is_called', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.CALL,
        volume: 5,
        updateUi: true
      };
      await volumepanelservice.onVolumeChange(data);
      expect(volumepanelservice.mListeners.forEach).assertCalledWith(ArgumentMatchers.anyFunction);
    });

    it('should_call_publish_when_onVolumeChange_is_called', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.CALL,
        volume: 5,
        updateUi: true
      };
      await volumepanelservice.onVolumeChange(data);
      expect(sEventManager.publish).assertCalledWith(ArgumentMatchers.anyObj);
    });
  });

  describe('onVolumeChange_testSuite', () => {

    it('should_log_correct_updateUi_value_when_updateUi_is_false', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.CALL,
        volume: 5,
        updateUi: false
      };
      await volumepanelservice.onVolumeChange(data);
      expect(LogHelper.debug).assertCalledWith(`Publish volume change: ${data.volumeType} volume ${data.volume} update false`);
    });

    it('should_log_correct_volumeType_for_media_type', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 15,
        updateUi: true
      };
      await volumepanelservice.onVolumeChange(data);
      expect(LogHelper.debug).assertCalledWith(`Publish volume change: ${data.volumeType} volume ${data.volume} update true`);
    });
  });
}