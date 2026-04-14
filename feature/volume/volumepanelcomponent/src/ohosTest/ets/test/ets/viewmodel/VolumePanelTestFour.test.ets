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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { AudioVolumeType, VolumeInfo } from '../../../../../main/ets/com/ohos/common/Constants';
import VolumePanelVM from '../../../../../main/ets/com/ohos/viewmodel/VolumePanelVM';
import {
  AudioManagerHelper,
  LogDomain,
  LogHelper,
  AppStorageUtil,
  DataProperty,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  sEventManager,
  obtainLocalEvent,
  SCBWindowSceneConfig
} from '@ohos/frameworkwrapper';
import { SCBConstants, WindowConstants } from '@ohos/commonconstants';
import audio from '@ohos.multimedia.audio';
import VolumePanelService from '../../../../../main/ets/com/ohos/model/VolumePanelService';

export function VolumePanelVMTest() {
  describe('VolumePanelVMTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getPreviousVolume', Level.LEVEL0, (): void => {
      let info: VolumeInfo = VolumePanelVM.getPreviousVolume(AudioVolumeType.VOICE_CALL);
      expect(info == undefined).assertTrue();
    });

    it('should_return_immediately_when_mIsStart_is_true', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.mIsStart = true;
      volumepanelvm.initViewModel();
    });

    it('should_initialize_correctly_when_mIsStart_is_false', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.mIsStart = false;
      let mocker: MockKit = new MockKit();

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateVolumeInfo);
      when(mockUpdateVolumeInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockRegisterListener: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.registerListener);
      when(mockRegisterListener)(ArgumentMatchers.any).afterReturnNothing();

      let mockGetInitVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getInitVolumeInfo);
      when(mockGetInitVolumeInfo)().afterReturnNothing();

      let mockStartService: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.startService);
      when(mockStartService)().afterReturnNothing();

      let mockSubscribe: Function = mocker.mockFunc(sEventManager, sEventManager.subscribe);
      when(mockSubscribe)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockSetPreviousVolumeCallback: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setPreviousVolumeCallback);
      when(mockSetPreviousVolumeCallback)(ArgumentMatchers.any).afterReturnNothing();

      volumepanelvm.initViewModel();

      expect(volumepanelvm.mIsStart).assertTrue();
      expect(volumepanelvm.mIsDevicePhone).assertTrue();

      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.registerListener);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.getInitVolumeInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.startService);
      mocker.ignoreMock(sEventManager, sEventManager.subscribe);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.setPreviousVolumeCallback);
    });

    it('should_handle_ringModeEvent_correctly', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.mIsStart = false;
      let mocker: MockKit = new MockKit();

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateVolumeInfo);
      when(mockUpdateVolumeInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockRegisterListener: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.registerListener);
      when(mockRegisterListener)(ArgumentMatchers.any).afterReturnNothing();

      let mockGetInitVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getInitVolumeInfo);
      when(mockGetInitVolumeInfo)().afterReturnNothing();

      let mockStartService: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.startService);
      when(mockStartService)().afterReturnNothing();

      let mockSubscribe: Function = mocker.mockFunc(sEventManager, sEventManager.subscribe);
      when(mockSubscribe)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockSetPreviousVolumeCallback: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setPreviousVolumeCallback);
      when(mockSetPreviousVolumeCallback)(ArgumentMatchers.any).afterReturnNothing();

      let mockOnRingerModeChanged: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.onRingerModeChanged);
      when(mockOnRingerModeChanged)(ArgumentMatchers.any).afterReturnNothing();

      volumepanelvm.initViewModel();

      let audioInfo = {
        volumeInfo: {
          volume: 1,
          updateUi: true,
          ringerMode: 1
        }
      };
      sEventManager.subscribe(SCBConstants.AUDIO_RING_MODE_EVENT, (audioInfo) => {
        volumepanelvm.updateVolumeInfo({
          ...audioInfo.volumeInfo,
          updateUi: true
        });
        volumepanelvm.onRingerModeChanged(audioInfo?.ringerMode);
      });

      expect(volumepanelvm.mIsStart).assertTrue();
      expect(volumepanelvm.mIsDevicePhone).assertTrue();

      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.registerListener);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.getInitVolumeInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.startService);
      mocker.ignoreMock(sEventManager, sEventManager.subscribe);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.setPreviousVolumeCallback);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.onRingerModeChanged);
    });

    it('should_set_activeVolumeType_to_MEDIA_when_activeVolumeType_is_undefined', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockGetActiveVolumeType: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getActiveVolumeType);
      when(mockGetActiveVolumeType)([ArgumentMatchers.any, ArgumentMatchers.any]).afterAction((volumeTypes: number[], callback: Function) => {
        callback(AudioVolumeType.MEDIA);
      });

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateVolumeInfo);
      when(mockUpdateVolumeInfo)([ArgumentMatchers.any]).afterReturnNothing();

      let mockGetVolumeInfo: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.getVolumeInfo);
      when(mockGetVolumeInfo)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      volumepanelvm.getInitVolumeInfo();

      expect(volumepanelvm.getActiveVolumeType()).assertEqual(AudioVolumeType.MEDIA);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.getActiveVolumeType);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateVolumeInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.getVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_updateUi_to_true_when_updateUi_is_undefined', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockGetActiveVolumeType: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getActiveVolumeType);
      when(mockGetActiveVolumeType)([ArgumentMatchers.any, ArgumentMatchers.any]).afterAction((volumeTypes: number[], callback: Function) => {
        callback(AudioVolumeType.MEDIA);
      });

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateVolumeInfo);
      when(mockUpdateVolumeInfo)([ArgumentMatchers.any]).afterReturnNothing();

      let mockGetVolumeInfo: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.getVolumeInfo);
      when(mockGetVolumeInfo)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      volumepanelvm.getInitVolumeInfo();

      expect(volumepanelvm.updateVolumeInfo).assertCalledWith({
        ...VolumeInfo,
        updateUi: true,
      });

      mocker.ignoreMock(volumepanelvm, volumepanelvm.getActiveVolumeType);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateVolumeInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.getVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_updateUi_to_false_when_updateUi_is_defined', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockGetActiveVolumeType: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getActiveVolumeType);
      when(mockGetActiveVolumeType)([ArgumentMatchers.any, ArgumentMatchers.any]).afterAction((volumeTypes: number[], callback: Function) => {
        callback(AudioVolumeType.MEDIA);
      });

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateVolumeInfo);
      when(mockUpdateVolumeInfo)([ArgumentMatchers.any]).afterReturnNothing();

      let mockGetVolumeInfo: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.getVolumeInfo);
      when(mockGetVolumeInfo)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      volumepanelvm.getInitVolumeInfo(false);

      expect(volumepanelvm.updateVolumeInfo).assertCalledWith({
        ...VolumeInfo,
        updateUi: false,
      });

      mocker.ignoreMock(volumepanelvm, volumepanelvm.getActiveVolumeType);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateVolumeInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.getVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_callback_with_undefined_when_volumeTypes_is_empty', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let callback: Function = (result: AudioVolumeType | undefined) => {
        expect(result).assertUndefined();
      };
      volumepanelvm.getActiveVolumeType([], callback);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_callback_with_volumeType_when_data_is_true', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsActive: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.isActive);
      when(mockIsActive)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyFunction).afterAction((volumeType: number, callback: Function) => {
        callback(volumeType, true);
      });

      let callback: Function = (result: AudioVolumeType | undefined) => {
        expect(result).assertEqual(AudioVolumeType.AUDIO_VOLUME_TYPE_MEDIA);
      };
      volumepanelvm.getActiveVolumeType([1], callback);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.isActive);
    });

    it('should_call_callback_with_volumeType_when_data_is_false_and_volumeTypes_has_more_elements', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsActive: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.isActive);
      when(mockIsActive)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyFunction).afterAction((volumeType: number, callback: Function) => {
        callback(volumeType, false);
      });

      let callback: Function = (result: AudioVolumeType | undefined) => {
        expect(result).assertEqual(AudioVolumeType.AUDIO_VOLUME_TYPE_MEDIA);
      };
      volumepanelvm.getActiveVolumeType([1, 2], callback);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.isActive);
    });

    it('should_call_callback_with_undefined_when_data_is_false_and_volumeTypes_has_no_more_elements', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsActive: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.isActive);
      when(mockIsActive)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyFunction).afterAction((volumeType: number, callback: Function) => {
        callback(volumeType, false);
      });

      let callback: Function = (result: AudioVolumeType | undefined) => {
        expect(result).assertUndefined();
      };
      volumepanelvm.getActiveVolumeType([1], callback);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.isActive);
    });

    it('should_update_max_volume_when_volumeType_is_MASTER', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.MASTER, 10);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.MASTER].maxVolume).assertEqual(10);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_max_volume_when_volumeType_is_MEDIA', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.MEDIA, 5);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.MEDIA].maxVolume).assertEqual(5);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_max_volume_when_volumeType_is_VOICE', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.VOICE, 7);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.VOICE].maxVolume).assertEqual(7);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_max_volume_when_volumeType_is_SYSTEM', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.SYSTEM, 8);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.SYSTEM].maxVolume).assertEqual(8);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_max_volume_when_volumeType_is_VOICE_AND_MEDIA', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.VOICE_AND_MEDIA, 9);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.VOICE_AND_MEDIA].maxVolume).assertEqual(9);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_max_volume_when_volumeType_is_Alarm_AND_MEDIA', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.Alarm_AND_MEDIA, 6);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.Alarm_AND_MEDIA].maxVolume).assertEqual(6);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_max_volume_when_volumeType_is_Alarm', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      volumepanelvm.updateMaxVolume(AudioVolumeType.Alarm, 4);

      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.Alarm].maxVolume).assertEqual(4);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_update_volume_when_volumeInfo_is_not_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
      let mockVolumeInfo: VolumeInfo = {
        volume: 0.5,
        maxVolume: 1.0,
        minVolume: 0.0,
        stepVolume: 0.1,
        volumeChannel: VolumeChannel.MASTER
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(mockVolumeInfo);

      volumepanelvm.updateVolumeWhenTouchToZero(AudioVolumeType.MASTER, 0.3);
      expect(mockVolumeInfo.volume).assertEqual(0.3);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
    });
    it('should_not_update_volume_when_volumeInfo_is_null', 0, () => {

      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      volumepanelvm.updateVolumeWhenTouchToZero(AudioVolumeType.MASTER, 0.3);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
    });

    it('should_return_previous_volume_when_volumeType_is_MEDIA', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let audioManager = AudioManagerHelper.getAudioManager();

      let audioVolumeManager = audioManager.getVolumeManager();

      let audioRoutingManager = audioManager.getRoutingManager();

      let rendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
        rendererFlags: 0
      };

      let logHelper = LogHelper.createLogHelper(LogDomain.UI_VOLUME_PANEL, 'VolumePanelVM');

      volumepanelvm.audioManager = audioManager;
      volumepanelvm.audioVolumeManager = audioVolumeManager;
      volumepanelvm.audioRoutingManager = audioRoutingManager;
      volumepanelvm.rendererInfo = rendererInfo;
      volumepanelvm.logHelper = logHelper;

      let result = volumepanelvm.getPreviousVolume(AudioVolumeType.MEDIA);
      expect(result.type).assertEqual(VolumeChannel.MEDIA);
    });

    it('should_return_previous_volume_when_volumeType_is_RINGTONE', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let audioManager = AudioManagerHelper.getAudioManager();

      let audioVolumeManager = audioManager.getVolumeManager();

      let audioRoutingManager = audioManager.getRoutingManager();

      let rendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
        rendererFlags: 0
      };

      let logHelper = LogHelper.createLogHelper(LogDomain.UI_VOLUME_PANEL, 'VolumePanelVM');

      volumepanelvm.audioManager = audioManager;
      volumepanelvm.audioVolumeManager = audioVolumeManager;
      volumepanelvm.audioRoutingManager = audioRoutingManager;
      volumepanelvm.rendererInfo = rendererInfo;
      volumepanelvm.logHelper = logHelper;

      let result = volumepanelvm.getPreviousVolume(AudioVolumeType.RINGTONE);
      expect(result.type).assertEqual(VolumeChannel.RINGTONE);
    });

    it('should_return_previous_volume_when_volumeType_is_UNKNOWN', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let audioManager = AudioManagerHelper.getAudioManager();
      let audioVolumeManager = audioManager.getVolumeManager();
      let audioRoutingManager = audioManager.getRoutingManager();
    });
  });
}
