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
  SingletonHelper,
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

export function VolumePanelServiceTest() {
  describe('VolumePanelServiceTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('should_set_volume_and_notify_when_uiType_is_not_PC', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockCalcVolumeByDisplayVolume: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.calcVolumeByDisplayVolume);
      when(mockCalcVolumeByDisplayVolume)(ArgumentMatchers.anyNumber).afterReturn(10);

      let mockSetVolume: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setVolume);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyFunction).afterReturnNothing();

      let mockSetMute: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setMute);
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyFunction).afterReturnNothing();

      let mockNotifyVolumeChange: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.notifyVolumeChange);
      when(mockNotifyVolumeChange)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(VolumeWindowController, VolumeWindowController.getInstance().updateVolumeInfo);
      when(mockUpdateVolumeInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;

      volumepanelvm.setVolume(100);

      expect(volumepanelvm.mUpdatingAudioVolume).assertEqual(10);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.calcVolumeByDisplayVolume);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.setVolume);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.setMute);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.notifyVolumeChange);
      mocker.ignoreMock(VolumeWindowController, VolumeWindowController.getInstance().updateVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_mute_and_notify_when_isCurrentMute_is_true', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockCalcVolumeByDisplayVolume: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.calcVolumeByDisplayVolume);
      when(mockCalcVolumeByDisplayVolume)(ArgumentMatchers.anyNumber).afterReturn(10);

      let mockSetVolume: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setVolume);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyFunction).afterReturnNothing();

      let mockSetMute: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setMute);
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyFunction).afterReturnNothing();

      let mockNotifyVolumeChange: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.notifyVolumeChange);
      when(mockNotifyVolumeChange)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVolumeInfo: Function = mocker.mockFunc(VolumeWindowController, VolumeWindowController.getInstance().updateVolumeInfo);
      when(mockUpdateVolumeInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PC;

      AppStorageUtil.setOrCreate(VolumePanelMinVolumeKey, 11);

      volumepanelvm.setVolume(100);

      expect(volumepanelvm.mUpdatingAudioVolume).assertEqual(10);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.calcVolumeByDisplayVolume);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.setVolume);
      mocker.ignoreMock(VolumePanelService, VolumePanelService.setMute);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.notifyVolumeChange);
      mocker.ignoreMock(VolumeWindowController, VolumeWindowController.getInstance().updateVolumeInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_volume_and_notify_when_isCurrentMute_is_false', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockCalcVolumeByDisplayVolume: Function =
        mocker.mockFunc(volumepanelvm, volumepanelvm.calcVolumeByDisplayVolume);
      when(mockCalcVolumeByDisplayVolume)(ArgumentMatchers.anyNumber).afterReturn(10);

      let mockSetVolume: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setVolume);
      when(mockSetVolume)(ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyFunction)
        .afterReturnNothing();

      let mockSetMute: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.setMute);
      when(mockSetMute)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyFunction)
        .afterReturnNothing();

      let mockNotifyVolumeChange: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.notifyVolumeChange);
      when(mockNotifyVolumeChange)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVolumeInfo: Function =
        mocker.mockFunc(VolumeWindowController, VolumeWindowController.getInstance().updateVolumeInfo);
      when(mockUpdateVolumeInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
    });

    it('should_log_info_when_muting_volume', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      await volumepanelvm.mute();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_muting_volume_fails', 0, async () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let audioVolumeManager = volumepanelvm.audioVolumeManager;
      let mockGetVolumeGroupManager: Function = mocker.mockFunc(audioVolumeManager, audioVolumeManager.getVolumeGroupManager);
      when(mockGetVolumeGroupManager)(ArgumentMatchers.anyNumber).afterThrow("Error");

      await volumepanelvm.mute();

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(audioVolumeManager, audioVolumeManager.getVolumeGroupManager);
    });

    it('should_return_error_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.registerVolumeChangedListener(null);
    });

    it('should_add_listener_when_listener_is_not_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let listener: VolumeChangedListener = new VolumeChangedListener();
      volumepanelvm.registerVolumeChangedListener(listener);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.unRegisterVolumeChangedListener(null);
    });

    it('should_remove_listener_when_listener_is_not_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let listener: VolumeChangedListener = new VolumeChangedListener();
      volumepanelvm.unRegisterVolumeChangedListener(listener);
    });

    it('should_not_register_listener_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.registerWindowStateListener(null);
    });

    it('should_register_listener_when_listener_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(VolumeWindowController.getInstance(), VolumeWindowController.getInstance().registerWindowStateListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let listener: VolumeWindowStateListener = new VolumeChangedListener();
      volumepanelvm.registerWindowStateListener(listener);

      mocker.ignoreMock(VolumeWindowController.getInstance(), VolumeWindowController.getInstance().registerWindowStateListener);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.unRegisterWindowStateListener(null);
    });

    it('should_call_VolumeWindowController_unRegisterWindowStateListener_when_listener_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(VolumeWindowController, VolumeWindowController.getInstance().unRegisterWindowStateListener);
      let listener: VolumeWindowStateListener = new class implements VolumeChangedListener, VolumeKeyPressedListener, OutputDeviceListener {
        onVolumeChanged(data: DataProperty): void {
        }
        onKeyPressed(data: number): void {
        }
        onOutputDeviceChange(data: number): void {
        }
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.unRegisterWindowStateListener(listener);
      mocker.ignoreMock(VolumeWindowController, VolumeWindowController.getInstance().unRegisterWindowStateListener);
    });

    it('should_not_register_listener_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.registerVolumeKeyPressedListener(null);
    });

    it('should_register_listener_when_listener_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(VolumePanelService, VolumePanelService.registerVolumeKeyPressedListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let listener: VolumeKeyPressedListener = new VolumeKeyPressedListener();
      volumepanelvm.registerVolumeKeyPressedListener(listener);

      mocker.ignoreMock(VolumePanelService, VolumePanelService.registerVolumeKeyPressedListener);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.unRegisterVolumeKeyPressedListener(null);
    });

    it('should_call_unRegisterVolumeKeyPressedListener_when_listener_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let volumeKeyPressedListener: VolumeKeyPressedListener = new VolumeKeyPressedListener();
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();

      volumepanelvm.unRegisterVolumeKeyPressedListener(volumeKeyPressedListener);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.registerKeyPressedListener(null);
    });

    it('should_register_key_pressed_listener_when_listener_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();

      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let listener: VolumeKeyPressedListener = new VolumeKeyPressedListener();
      volumepanelvm.registerKeyPressedListener(listener);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      volumepanelvm.unRegisterKeyPressedListener(null);
    });

    it('should_call_VolumePanelService_unregisterKeyPressListeners_when_listener_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();

      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let listener: VolumeKeyPressedListener = new VolumeKeyPressedListener();
      volumepanelvm.unRegisterKeyPressedListener(listener);
    });

    it('should_return_volume_channels_when_volumeChannels_is_not_empty', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let isMobileDataAvailable: boolean = true;
      let result: VolumeChannel[] = volumepanelvm.getDialogSupportedVolumeChannels(isMobileDataAvailable);
      expect(result.length).assertEqual(4);
    });

    it('should_return_volume_channels_with_media_channel_when_volumeChannels_is_empty', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let isMobileDataAvailable: boolean = true;
      volumepanelvm.volumeChannels = [];
      let result: VolumeChannel[] = volumepanelvm.getDialogSupportedVolumeChannels(isMobileDataAvailable);
      expect(result.length).assertEqual(4);
      expect(result[0].channelId).assertEqual('media');
      expect(result[0].volumeType).assertEqual(AudioVolumeType.MEDIA);
      expect(result[1].channelId).assertEqual('ring');
      expect(result[1].volumeType).assertEqual(AudioVolumeType.RINGTONE);
      expect(result[2].channelId).assertEqual('alarm');
      expect(result[2].volumeType).assertEqual(AudioVolumeType.ALARM);
      expect(result[3].channelId).assertEqual('call');
      expect(result[3].volumeType).assertEqual(AudioVolumeType.VOICE_CALL);
    });

    it('should_return_volume_channels_without_call_channel_when_isMobileDataAvailable_is_false', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let isMobileDataAvailable: boolean = false;
      let result: VolumeChannel[] = volumepanelvm.getDialogSupportedVolumeChannels(isMobileDataAvailable);
      expect(result.length).assertEqual(3);
      expect(result[0].channelId).assertEqual('media');
      expect(result[0].volumeType).assertEqual(AudioVolumeType.MEDIA);
      expect(result[1].channelId).assertEqual('ring');
      expect(result[1].volumeType).assertEqual(AudioVolumeType.RINGTONE);
      expect(result[2].channelId).assertEqual('alarm');
      expect(result[2].volumeType).assertEqual(AudioVolumeType.ALARM);
    });

    it('should_return_false_when_minVolume_is_greater_than_DEFAULT_MIN_VOLUME', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result = volumepanelvm.isVolumeMute(Constants.DEFAULT_MIN_VOLUME + 1, 100);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_volumeValue_is_less_than_or_equal_to_minVolume', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result = volumepanelvm.isVolumeMute(100, 99);
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_volumeValue_is_less_than_minVolume', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result = volumepanelvm.isVolumeMute(100, 98);
      expect(result).assertEqual(true);
    });

    it('should_set_volume_value_when_volumeInfo_is_not_null_and_not_mute', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockIsVolumeMute: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.isVolumeMute);
      when(mockIsVolumeMute)([ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterReturn(false);

      volumepanelvm.setVolumeValue(AudioVolumeType.MEDIA, 50);

      let volumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.MEDIA);
      expect(volumeInfo.volume).assertEqual(50);
      expect(volumeInfo.isMute).assertEqual(false);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.isVolumeMute);
    });

    it('should_set_volume_value_and_mute_when_volumeInfo_is_not_null_and_is_mute', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();

      let mockIsVolumeMute: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.isVolumeMute);
      when(mockIsVolumeMute)([ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterReturn(true);

      volumepanelvm.setVolumeValue(AudioVolumeType.MEDIA, 50);

      let volumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.MEDIA);
      expect(volumeInfo.volume).assertEqual(50);
      expect(volumeInfo.isMute).assertEqual(true);

      mocker.ignoreMock(volumepanelvm, volumepanelvm.isVolumeMute);
    });

    it('should_do_nothing_when_volumeInfo_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      volumepanelvm.setVolumeValue(AudioVolumeType.MEDIA, 50);

      let volumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.MEDIA);
      expect(volumeInfo).assertNull();
    });

    it('should_set_volume_type_to_active_when_isActive_is_true', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      volumepanelvm.setActiveVolumeType(AudioVolumeType.TYPE_MUSIC, true);
      expect(volumepanelvm.getAudioVolumeInfo(AudioVolumeType.TYPE_MUSIC).isActive).assertEqual(true);
    });

    it('should_set_volume_type_to_inactive_when_isActive_is_false', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      volumepanelvm.setActiveVolumeType(AudioVolumeType.TYPE_MUSIC, false);
      expect(volumepanelvm.getAudioVolumeInfo(AudioVolumeType.TYPE_MUSIC).isActive).assertEqual(false);
    });

    it('should_set_volume_type_to_active_when_isActive_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      volumepanelvm.setActiveVolumeType(AudioVolumeType.TYPE_MUSIC, null);
      expect(volumepanelvm.getAudioVolumeInfo(AudioVolumeType.TYPE_MUSIC).isActive).assertEqual(false);
    });

    it('should_return_false_when_volumeType_is_null', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result = volumepanelvm.isVolumeTypeActive(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_volumeType_is_not_active', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockfunc = mocker.mockFunc(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ isActive: false });

      let result = volumepanelvm.isVolumeTypeActive(AudioVolumeType.TYPE_MUSIC);
      expect(result).assertEqual(false);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
    });

    it('should_return_true_when_volumeType_is_active', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockfunc = mocker.mockFunc(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ isActive: true });
      let result = volumepanelvm.isVolumeTypeActive(AudioVolumeType.TYPE_MUSIC);
      expect(result).assertEqual(true);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.getAudioVolumeInfo);
    });

    it('should_return_correct_volume_info_when_volumeType_is_AudioVolumeType.MEDIA', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result: VolumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.MEDIA);
      expect(result.volumeType).assertEqual(AudioVolumeType.MEDIA);
    });

    it('should_return_correct_volume_info_when_volumeType_is_AudioVolumeType.VOICE', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result: VolumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.VOICE);
      expect(result.volumeType).assertEqual(AudioVolumeType.VOICE);
    });

    it('should_return_correct_volume_info_when_volumeType_is_AudioVolumeType.RINGTONE', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result: VolumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.RINGTONE);
      expect(result.volumeType).assertEqual(AudioVolumeType.RINGTONE);
    });

    it('should_return_correct_volume_info_when_volumeType_is_AudioVolumeType.NOTIFICATION', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result: VolumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.NOTIFICATION);
      expect(result.volumeType).assertEqual(AudioVolumeType.NOTIFICATION);
    });

    it('should_return_correct_volume_info_when_volumeType_is_AudioVolumeType.ALARM', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result: VolumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.ALARM);
      expect(result.volumeType).assertEqual(AudioVolumeType.ALARM);
    });

    it('should_return_correct_volume_info_when_volumeType_is_AudioVolumeType.OTHER', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let result: VolumeInfo = volumepanelvm.getAudioVolumeInfo(AudioVolumeType.OTHER);
      expect(result.volumeType).assertEqual(AudioVolumeType.OTHER);
    });

    it('should_initialize_audio_volume_info_correctly', 0, () => {
      let volumepanelvm: VolumePanelVM = new VolumePanelVM();
      let mocker: MockKit = new MockKit();
      let mockRequestMaxVolume: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.requestMaxVolume);
      let mockUpdateMaxVolume: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateMaxVolume);
      let mockRequestMinVolume: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.requestMinVolume);
      let mockUpdateMinVolume: Function = mocker.mockFunc(volumepanelvm, volumepanelvm.updateMinVolume);

      when(mockRequestMaxVolume)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockUpdateMaxVolume)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockRequestMinVolume)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockUpdateMinVolume)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      volumepanelvm.initAudioVolumeInfo(AudioVolumeType.TYPE_MUSIC);
      expect(volumepanelvm.mVolumeBaseMap[AudioVolumeType.TYPE_MUSIC]).assertDeepEquals({
        maxVolume: Constants.DEFAULT_MAX_VOLUME,
        minVolume: Constants.DEFAULT_MIN_VOLUME
      });
      expect(volumepanelvm.mGlobalVolumeInfoMap?.get(AudioVolumeType.TYPE_MUSIC)).assertDeepEquals({
        volumeType: AudioVolumeType.TYPE_MUSIC,
        volume: Constants.DEFAULT_MAX_VOLUME,
        isMute: false,
        updateUi: false,
        isActive: false,
        hostType: HostType.VOLUME_PANEL,
        maxVolume: Constants.DEFAULT_VOLUME_INVALID,
        minVolume: Constants.DEFAULT_VOLUME_INVALID,
        lastVolume: Constants.DEFAULT_MAX_VOLUME
      });

      mocker.ignoreMock(volumepanelvm, volumepanelvm.requestMaxVolume);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateMaxVolume);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.requestMinVolume);
      mocker.ignoreMock(volumepanelvm, volumepanelvm.updateMinVolume);
    });
  });
}