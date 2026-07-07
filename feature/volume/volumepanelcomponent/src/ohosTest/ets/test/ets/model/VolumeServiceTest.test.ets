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
  Level,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
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
import { VolumePanelService } from '../../../../../main/ets/com/ohos/model/VolumePanelService';


export function VolumePanelServiceTest() {
  describe('VolumePanelServiceTest', (done:Function): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getVolumeInfo', Level.LEVEL0, (): void => {
      VolumePanelService.getVolumeInfo(AudioVolumeType.VOICE_CALL, (volumeInfo: VolumeInfo) => {
        expect(volumeInfo !== undefined).assertTrue();
      });
    });

    it('should_log_info_when_getRingerMode_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let audioVolumeManager: audio.AudioVolumeManager = audio.getVolumeManager();
      let audioStreamManager: audio.AudioStreamManager = audio.getStreamManager();
      let volumePanelService: VolumePanelService = new VolumePanelService();
      volumePanelService.mAudioVolumeManager = audioVolumeManager;
      volumePanelService.mAudioStreamManager = audioStreamManager;

      let mockPublish: Function = mocker.mockFunc(sEventManager, sEventManager.publish);
      when(mockPublish)(ArgumentMatchers.any).afterReturn(true);

      await volumePanelService.getRingerMode();
      butto

      expect(mockShowInfo).assertCalledWith('get ringerMode 0');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(sEventManager, sEventManager.publish);
    });

    it('should_log_error_when_getRingerMode_throws_error', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let audioVolumeManager: audio.AudioVolumeManager = audio.getVolumeManager();
      let audioStreamManager: audio.AudioStreamManager = audio.getStreamManager();
      let volumePanelService: VolumePanelService = new VolumePanelService();
      volumePanelService.mAudioVolumeManager = audioVolumeManager;
      volumePanelService.mAudioStreamManager = audioStreamManager;

      await volumePanelService.getRingerMode();

      expect(mockError).assertCalledWith('getRingerMode error Error: get ringer mode failed');
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('onVolumeChange_success', 0, async () => {
      let data: audio.VolumeEvent = {
        volumeType: 'MEDIA',
        volume: 10,
        updateUi: true,
        volumeGroupId: 1,
        networkId: '123456'
      };
      let result = await onVolumeChange(data);
      expect(result).assertUndefined();
    })

    it('isMute_success', 0, () => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('getVolumeInfo_success_VOICE_CALL', 0, () => {
      let callback = (volumeInfo: VolumeInfo) => {
        expect(volumeInfo.volumeType).assertEqual(AudioVolumeType.VOICE_CALL);
        expect(volumeInfo.volume).assertLarger(0);
        expect(volumeInfo.isMute).assertFalse();
        expect(volumeInfo.updateUi).assertFalse();
        expect(volumeInfo.isActive).assertFalse();
        expect(volumeInfo.maxVolume).assertEqual(Constants.DEFAULT_VOLUME_INVALID);
        expect(volumeInfo.minVolume).assertEqual(Constants.DEFAULT_VOLUME_INVALID);
        expect(volumeInfo.lastVolume).assertEqual(volumeInfo.volume);
      };
      getVolumeInfo(AudioVolumeType.VOICE_CALL, callback);
    })

    it('isActive_success_VOICE_CALL', 0, (done) => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('isActive_success_RINGTONE', 0, (done) => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('isActive_success_VOICE_ASSISTANT', 0, (done) => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('isActive_success_ULTRASONIC', 0, (done) => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('isActive_success_ALL', 0, (done) => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('getVolume_success', 0, (done) => {
      let a = 100;
      let b = 0.1;
      expect(a).assertClose(99, b);
      done();
    })

    it('should_call_callback_when_no_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();

      let mockFormatAudioVolumeTypeToInterface: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockFormatAudioVolumeTypeToInterface)(ArgumentMatchers.any).afterReturn(1);



      let callbackCalled: boolean = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
      };

      volumepanelservice.getMaxVolume(AudioVolumeType.MEDIA, callback);

      expect(callbackCalled).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_not_call_callback_when_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();

      let mockFormatAudioVolumeTypeToInterface: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockFormatAudioVolumeTypeToInterface)(ArgumentMatchers.any).afterReturn(1);



      let callbackCalled: boolean = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
      };

      volumepanelservice.getMaxVolume(AudioVolumeType.MEDIA, callback);

      expect(callbackCalled).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_call_callback_when_no_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();

      let mockFormatAudioVolumeTypeToInterface: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockFormatAudioVolumeTypeToInterface)(ArgumentMatchers.any).afterReturn(1);



      let callbackCalled: boolean = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
      };

      volumepanelservice.getMinVolume(AudioVolumeType.MEDIA, callback);

      expect(callbackCalled).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_not_call_callback_when_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();

      let mockFormatAudioVolumeTypeToInterface: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockFormatAudioVolumeTypeToInterface)(ArgumentMatchers.any).afterReturn(1);



      let callbackCalled: boolean = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
      };

      volumepanelservice.getMinVolume(AudioVolumeType.MEDIA, callback);

      expect(callbackCalled).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_call_setVolume_when_volume_is_defined_and_mute_is_undefined', 0, async () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, 0.5, undefined);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setMute_when_volume_is_undefined_and_mute_is_defined', 0, async () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, undefined, true);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setVolume_and_setMute_when_both_volume_and_mute_are_defined', 0, async () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, 0.5, true);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setVolume_and_setMute_with_callback_when_both_volume_and_mute_are_defined', 0, async () => {
      let volumepanelservice: VolumePanelService = VolumePanelService.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let callback: () => void = () => {
        LogHelper.showInfo('callback');
      };

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, 0.5, true, callback);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_when_setVolume_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 50);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_interface_call_queue_when_setVolume_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.addInterfaceCallQueue);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();

      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 50);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.addInterfaceCallQueue);
    });

    it('should_call_callback_when_callback_is_provided', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      let callback: () => void = () => {
        log.showInfo("callback called");
      };
      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 50, callback);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_call_callback_when_callback_is_not_provided', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 50);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_format_audio_volume_type_to_interface_when_setVolume_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(1);

      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 50);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_log_info_when_setMute_is_called', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelservice.setMute(AudioVolumeType.MEDIA, true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_callback_when_callback_is_provided', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let callbackCalled: boolean = false;
      volumepanelservice.setMute(AudioVolumeType.MEDIA, true, () => {
        callbackCalled = true;
      });

      expect(callbackCalled).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_callback_when_callback_is_not_provided', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let callbackCalled: boolean = false;
      volumepanelservice.setMute(AudioVolumeType.MEDIA, true);

      expect(callbackCalled).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_callback_throws_error', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let callbackCalled: boolean = false;
      let errorCallback: () => void = () => {
        callbackCalled = true;
        throw new Error('Test error');
      };
      volumepanelservice.setMute(AudioVolumeType.MEDIA, true, errorCallback);

      expect(callbackCalled).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_volume_when_setMute_is_called_with_callback', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let callbackCalled: boolean = false;
      volumepanelservice.setMute(AudioVolumeType.MEDIA, true, () => {
        callbackCalled = true;
      });
      expect(callbackCalled).assertTrue();
      expect(audio.getAudioManager().isMute()).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_set_volume_when_setMute_is_called_without_callback', 0, () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelservice.setMute(AudioVolumeType.MEDIA, true);
      expect(audio.getAudioManager().isMute()).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_and_notify_volume_key_pressed_when_updateUi_is_true', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockFormatAudioVolumeTypeFromInterface: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeFromInterface);
      when(mockFormatAudioVolumeTypeFromInterface)(ArgumentMatchers.any).afterReturn(1);

      let mockIsMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.isMute);
      when(mockIsMute)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturnNothing();

      let mockPublish: Function = mocker.mockFunc(EventManager, EventManager.publish);
      when(mockPublish)(ArgumentMatchers.any).afterReturn(true);

      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 10,
        updateUi: true
      };

      await volumepanelservice.onVolumeChange(data);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeFromInterface);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.isMute);
      mocker.ignoreMock(EventManager, EventManager.publish);
    });
    it('should_log_info_and_notify_volume_key_pressed_when_updateUi_is_false', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockFormatAudioVolumeTypeFromInterface: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeFromInterface);
      when(mockFormatAudioVolumeTypeFromInterface)(ArgumentMatchers.any).afterReturn(1);

      let mockIsMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.isMute);
      when(mockIsMute)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturnNothing();

      let mockPublish: Function = mocker.mockFunc(EventManager, EventManager.publish);
      when(mockPublish)(ArgumentMatchers.any).afterReturn(true);

      let data: audio.VolumeEvent = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 10,
        updateUi: false
      };

      await volumepanelservice.onVolumeChange(data);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeFromInterface);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.isMute);
      mocker.ignoreMock(EventManager, EventManager.publish);
    });

    it('should_log_info_when_isMute_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      volumepanelservice.isMute(AudioVolumeType.MEDIA, (volumeType, data) => {
        expect(data).assertEqual(true);
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_interface_call_queue_when_isMute_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.addInterfaceCallQueue);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.isMute(AudioVolumeType.MEDIA, (volumeType, data) => {
        expect(data).assertEqual(true);
      });

      mocker.ignoreMock(volumepanelservice, volumepanelservice.addInterfaceCallQueue);
    });

    it('should_call_callback_when_isMute_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      volumepanelservice.isMute(AudioVolumeType.MEDIA, (volumeType, data) => {
        expect(data).assertEqual(true);
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_format_audio_volume_type_to_interface_when_isMute_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(1);

      volumepanelservice.isMute(AudioVolumeType.MEDIA, (volumeType, data) => {
        expect(data).assertEqual(true);
      });

      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_handle_error_when_callback_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = VolumePanelService.getInstance();
      volumepanelservice.isMute(AudioVolumeType.MEDIA, null);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_getVolume_and_isMute_when_callback_is_provided', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mockGetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.getVolume);
      let mockIsMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.isMute);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetVolume)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(10);
      when(mockIsMute)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(false);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let callback: (volumeInfo: VolumeInfo) => void = (volumeInfo: VolumeInfo) => {
        expect(volumeInfo.volume).assertEqual(10);
        expect(volumeInfo.isMute).assertEqual(false);
        expect(volumeInfo.volumeType).assertEqual(AudioVolumeType.MEDIA);
      };

      volumepanelservice.getVolumeInfo(AudioVolumeType.MEDIA, callback);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.getVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.isMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_getVolume_and_isMute_when_callback_is_not_provided', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mockGetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.getVolume);
      let mockIsMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.isMute);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetVolume)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(10);
      when(mockIsMute)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(false);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.getVolumeInfo(AudioVolumeType.MEDIA);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.getVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.isMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_when_isActive_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        expect(volumeType).assertEqual(AudioVolumeType.MEDIA);
        expect(data).assertDeepEquals(new VolumeInfo(1, 1));
      };
      volumepanelservice.isActive(AudioVolumeType.MEDIA, callback);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callback_when_isActive_is_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        expect(volumeType).assertEqual(AudioVolumeType.MEDIA);
        expect(data).assertDeepEquals(new VolumeInfo(1, 1));
      };

      let mockfunc2: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);

      volumepanelservice.isActive(AudioVolumeType.MEDIA, callback);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_not_call_callback_when_isActive_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        assertFail('Callback should not be called');
      };

      let mockfunc2: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);

      volumepanelservice.isActive(AudioVolumeType.MEDIA, callback);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
    });

    it('should_log_info_when_getVolume_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      volumepanelservice.getVolume(AudioVolumeType.MEDIA, (volumeType, data) => {
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_interface_call_queue_when_getVolume_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mockfunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.addInterfaceCallQueue);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();

      volumepanelservice.getVolume(AudioVolumeType.MEDIA, (volumeType, data) => {
      });

      mocker.ignoreMock(volumepanelservice, volumepanelservice.addInterfaceCallQueue);
    });

    it('should_call_callback_when_err_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callbackCalled = false;
      volumepanelservice.getVolume(AudioVolumeType.MEDIA, (volumeType, data) => {
        callbackCalled = true;
      });

      expect(callbackCalled).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callback_when_err_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callbackCalled = false;
      volumepanelservice.getVolume(AudioVolumeType.MEDIA, (volumeType, data) => {
        callbackCalled = true;
      });

      expect(callbackCalled).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callback_when_no_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mockFormatFunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockFormatFunc)(ArgumentMatchers.any).afterReturn(1);

      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();



      let callbackCalled = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
        expect(data.volume).assertEqual(10);
      };

      volumepanelservice.getMaxVolume(AudioVolumeType.MEDIA, callback);

      expect(callbackCalled).assertTrue();
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_callback_when_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mockFormatFunc: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      when(mockFormatFunc)(ArgumentMatchers.any).afterReturn(1);

      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();



      let callbackCalled = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
      };

      volumepanelservice.getMaxVolume(AudioVolumeType.MEDIA, callback);

      expect(callbackCalled).assertFalse();
      mocker.ignoreMock(volumepanelservice, volumepanelservice.formatAudioVolumeTypeToInterface);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_callback_when_no_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockFormatFunc: Function = mocker.mockFunc(VolumePanelService.prototype, VolumePanelService.prototype.formatAudioVolumeTypeToInterface);
      when(mockFormatFunc)(ArgumentMatchers.any).afterReturn(1);

      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callbackCalled = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
        expect(volumeType).assertEqual(AudioVolumeType.MEDIA);
        expect(data).assertDeepEquals({ minVolume: 10 });
      };
      volumepanelservice.getMinVolume(AudioVolumeType.MEDIA, callback);
      expect(callbackCalled).assertTrue();

      mocker.ignoreMock(VolumePanelService.prototype, VolumePanelService.prototype.formatAudioVolumeTypeToInterface);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_callback_when_error_occurs', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockFormatFunc: Function = mocker.mockFunc(VolumePanelService.prototype, VolumePanelService.prototype.formatAudioVolumeTypeToInterface);
      when(mockFormatFunc)(ArgumentMatchers.any).afterReturn(1);

      let mockShowInfoFunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfoFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let callbackCalled = false;
      let callback: Function = (volumeType: AudioVolumeType, data: VolumeInfo) => {
        callbackCalled = true;
      };
      volumepanelservice.getMinVolume(AudioVolumeType.MEDIA, callback);
      expect(callbackCalled).assertFalse();

      mocker.ignoreMock(VolumePanelService.prototype, VolumePanelService.prototype.formatAudioVolumeTypeToInterface);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setVolume_and_setMute_when_volume_and_mute_are_defined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();

      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, 50, true);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setVolume_when_volume_is_defined_and_mute_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();

      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, 50, undefined);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setMute_when_volume_is_undefined_and_mute_is_defined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();

      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, undefined, true);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setVolume_and_setMute_when_callback_is_provided', 0, async () => {
      let mocker: MockKit = new MockKit();
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mockSetVolume: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setVolume);
      let mockSetMute: Function = mocker.mockFunc(volumepanelservice, volumepanelservice.setMute);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let callback: () => void = () => {
        LogHelper.showInfo('callback');
      };
      volumepanelservice.setVolumeAndMute(AudioVolumeType.MEDIA, 50, true, callback);

      mocker.ignoreMock(volumepanelservice, volumepanelservice.setVolume);
      mocker.ignoreMock(volumepanelservice, volumepanelservice.setMute);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_volume_when_volumeType_is_not_null_and_volume_is_valid', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 0.5);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_volume_when_volumeType_is_not_null_and_volume_is_invalid', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      volumepanelservice.setVolume(AudioVolumeType.MEDIA, -0.5);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_volume_when_volumeType_is_null_and_volume_is_valid', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      volumepanelservice.setVolume(null, 0.5);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_volume_when_volumeType_is_null_and_volume_is_invalid', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      volumepanelservice.setVolume(null, -0.5);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_callback_when_callback_is_provided', 0, async () => {
      let volumepanelservice: VolumePanelService = new VolumePanelService();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let callbackCalled: boolean = false;
      volumepanelservice.setVolume(AudioVolumeType.MEDIA, 0.5, () => {
        callbackCalled = true;
      });
      expect(callbackCalled).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
}