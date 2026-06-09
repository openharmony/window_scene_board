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

import audio from '@ohos.multimedia.audio';
import HashMap from '@ohos.util.HashMap';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  Size,
  TestType,
} from '@ohos/hypium';
import { AudioConstants } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/common/Constants';
import { AudioSoundModel } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/model/AudioSoundModel';
import {
  AudioSoundViewModel,
  AudioOutputChangeListener4V,
  audioDevice
} from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/viewmodel/AudioSoundViewModel';

const TAG = 'AudioSoundModelTest';

export default function AudioSoundModelTest() {
  let curDevices: audioDevice[] = [];
  let curViewIndex: number = AudioConstants.DEFAULT_DEVICE_ID;
  let minVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
  let curVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
  let maxVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
  let minTipVolume: number = AudioConstants.DEFAULT_MIN_VOLUME;
  let curTipVolume: number = AudioConstants.DEFAULT_CUR_VOLUME;
  let maxTipVolume: number = AudioConstants.DEFAULT_MAX_VOLUME;
  let model: AudioSoundModel = AudioSoundModel.getInstance();
  let viewModel: AudioSoundViewModel = AudioSoundViewModel.getInstance();
  let audioOutputChangeListener: AudioOutputChangeListener4V = {
    onOutputDevicesChange: (devices: audioDevice[]) => {
      curDevices = devices;
    },
    onCurrentOutputDeviceChange: (viewIndex: number) => {
      curViewIndex = viewIndex;
    },
    onVolumeChange: (min: number, cur: number, max: number) => {
      curVolume = cur;
      maxVolume = max;
      minVolume = min
    },
    onTipVolumeChange: (min: number, cur: number, max: number) => {
      maxTipVolume = cur;
      curTipVolume = max;
      minTipVolume = min
    }
  };

  describe('AudioSoundModelTest', () => {
    beforeAll((): void => {
      viewModel.registerOutputChangeListener(audioOutputChangeListener, TAG);
    });
    beforeEach((): void => {

    });
    afterEach((): void => {

    });
    afterAll((): void => {
      viewModel.unregisterOutputChangeListener(audioOutputChangeListener, TAG);
    });

    it('AudioSoundViewModel_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      (viewModel as object)['registerOutputChangeListener'](undefined, TAG);
      (viewModel as object)['unregisterOutputChangeListener'](undefined, TAG);
      await viewModel.getOutputState(TAG);
      expect(curDevices.length > 0).assertTrue();
      expect(curViewIndex !== 0).assertTrue();
    });

    it('AudioSoundViewModel_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      if (curDevices.length > 0) {
        await viewModel.selectOutputDevice(curDevices[0].viewIndex, TAG);
      }
      await viewModel.selectOutputDevice(-1, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.setOutputVolume(15, TAG);
      await viewModel.setOutputVolume(-1, TAG);
      await viewModel.setOutputVolume(100, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.setTipVolume(15, TAG);
      await viewModel.setTipVolume(-1, TAG);
      await viewModel.setTipVolume(100, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.turnOutputVolume(true, TAG);
      await viewModel.turnOutputVolume(false, TAG);
      await viewModel.turnOutputVolume(true, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.turnTipVolume(true, TAG);
      await viewModel.turnTipVolume(false, TAG);
      await viewModel.turnTipVolume(true, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.setOutputMute(true, TAG);
      await viewModel.setOutputMute(false, TAG);
      await viewModel.setOutputMute(true, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.setTipMute(true, TAG);
      await viewModel.setTipMute(false, TAG);
      await viewModel.setTipMute(true, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let audioDevices : audioDevice[] = [];
      audioDevices.push({
        viewIndex: 1,
        deviceIndex: 1,
        name: '本机扬声器',
        type: audio.DeviceType.SPEAKER,
        address: ''
      });
      audioDevices.push({
        viewIndex: 2,
        deviceIndex: 2,
        name: '有线耳机',
        type: audio.DeviceType.USB_HEADSET,
        address: ''
      });
      audioDevices.push({
        viewIndex: 3,
        deviceIndex: 3,
        name: '蓝牙耳机a2dp',
        type: audio.DeviceType.BLUETOOTH_A2DP,
        address: ''
      });
      audioDevices.push({
        viewIndex: 4,
        deviceIndex: 4,
        name: '蓝牙耳机sco',
        type: audio.DeviceType.BLUETOOTH_SCO,
        address: ''
      });
      audioDevices.push({
        viewIndex: 5,
        deviceIndex: 5,
        name: '本机麦克风',
        type: audio.DeviceType.MIC,
        address: ''
      });
      audioDevices.push({
        viewIndex: 6,
        deviceIndex: 6,
        name: 'DP 设备',
        type: audio.DeviceType.DISPLAY_PORT,
        address: ''
      });
      audioDevices.push({
        viewIndex: 7,
        deviceIndex: 7,
        name: '外置音箱/麦克风',
        type: audio.DeviceType.USB_DEVICE,
        address: ''
      });
      (viewModel as object)['sortAudioDevices'](audioDevices);
      expect(audioDevices.length > 0).assertTrue();
    });

    it('AudioSoundViewModel_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.setOutputVolume(0, TAG);
      await viewModel.turnOutputVolume(false, TAG);
      await viewModel.setOutputVolume(15, TAG);
      await viewModel.turnOutputVolume(true, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await viewModel.setTipVolume(0, TAG);
      await viewModel.turnTipVolume(false, TAG);
      await viewModel.setTipVolume(15, TAG);
      await viewModel.turnTipVolume(true, TAG);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      (viewModel as object)['currentOutputDeviceDataProcessFromModel']([getAudioDeviceDescriptor(-1)]);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, audio.DeviceType.EARPIECE));
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, audio.DeviceType.USB_HEADSET));
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, audio.DeviceType.BLUETOOTH_A2DP));
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, audio.DeviceType.MIC));
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, audio.DeviceType.DISPLAY_PORT));
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, audio.DeviceType.USB_DEVICE));
      (viewModel as object)['getDeviceName'](getAudioDeviceDescriptor(-1, -1));
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundViewModel_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let outputDeviceAddressMap: HashMap<string, number> = new HashMap();
      (viewModel as object)['getDeviceViewIndex'](getAudioDeviceDescriptor(-1, audio.DeviceType.BLUETOOTH_A2DP), outputDeviceAddressMap);
      (viewModel as object)['getDeviceViewIndex'](getAudioDeviceDescriptor(-1, audio.DeviceType.BLUETOOTH_SCO), outputDeviceAddressMap);
      expect(viewModel !== undefined).assertTrue();
    });

    it('AudioSoundModel_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      (model as object)['registerAudioOutputChangeListener'](undefined, TAG);
      (model as object)['unregisterAudioOutputChangeListener'](undefined, TAG);
      await model.initOutputStateFromAudio(TAG);
      expect(curDevices.length > 0).assertTrue();
      expect(curViewIndex !== 0).assertTrue();
    });

    it('AudioSoundModel_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      if (curDevices.length > 0) {
        let res: boolean = await model.selectAudioOutputDevice(curDevices[0].deviceIndex, true, TAG);
        res = res && await model.selectAudioOutputDevice(curDevices[0].deviceIndex, false, TAG);
        expect(res).assertTrue();
      }
      await model.selectAudioOutputDevice(-1, false, TAG);
      expect(model !== undefined).assertTrue();
    });

    it('AudioSoundModel_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await model.setAudioVolume(audio.AudioVolumeType.MEDIA, 8, TAG);
      let res: boolean = true;
      res = res && await model.turnVolume(audio.AudioVolumeType.MEDIA, false, TAG);
      res = res && await model.turnVolume(audio.AudioVolumeType.MEDIA, true, TAG);
      expect(res).assertTrue();
    });

    it('AudioSoundModel_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let res: boolean = true;
      res = res && await model.setAudioMute(audio.AudioVolumeType.MEDIA, true, TAG);
      res = res && await model.setAudioMute(audio.AudioVolumeType.MEDIA, false, TAG);
      expect(res).assertTrue();
    });

    it('AudioSoundModel_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let res: boolean = true;
      res = res && await model.setAudioMute(audio.AudioVolumeType.MEDIA, true, TAG);
      res = res && await model.getMute(audio.AudioVolumeType.MEDIA, TAG);
      expect(res).assertTrue();
    });

    it('AudioSoundModel_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let res1 = await model.getMinVolume(audio.AudioVolumeType.MEDIA, TAG);
      let res2 = await model.getMaxVolume(audio.AudioVolumeType.MEDIA, TAG);
      let res3 = await model.getCurVolume(audio.AudioVolumeType.MEDIA, TAG);
      expect(res1 !== undefined && res2 !== undefined && res3 !== undefined).assertTrue();
    });

    it('AudioSoundModel_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let res = model.isCommunicationNow();
      expect(res !== undefined).assertTrue();
      expect(model !== undefined).assertTrue();
    });

    it('AudioSoundModel_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await model.setAudioVolume(audio.AudioVolumeType.MEDIA, 15, TAG);
      await model.turnVolume(audio.AudioVolumeType.MEDIA, true, TAG);
      await model.setAudioVolume(audio.AudioVolumeType.MEDIA, 0, TAG);
      await model.turnVolume(audio.AudioVolumeType.MEDIA, false, TAG);
      expect(model !== undefined).assertTrue();
    });

    it('AudioSoundModel_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      await model.setAudioVolume(-1, 15, TAG);
      await model.turnVolume(-1, true, TAG);
      await model.setAudioMute(-1, true, TAG);
      await model.getMute(-1, TAG);
      await model.getCurVolume(-1, TAG);
      await model.getMinVolume(-1, TAG);
      await model.getMaxVolume(-1, TAG);
      await model.getCurVolume(-1, TAG);
      expect(model !== undefined).assertTrue();
    });
  });
}

function getAudioDeviceDescriptor(deviceId: number = 1, type: number = audio.DeviceType.SPEAKER,
  deviceName: string = ''): audio.AudioDeviceDescriptor {
  return {
    deviceRole: audio.DeviceRole.OUTPUT_DEVICE,
    deviceType: type,
    id: deviceId,
    name: deviceName,
    address: '',
    sampleRates: [1, 2, 3],
    channelCounts: [1, 2, 3],
    channelMasks: [1, 2, 3],
    networkId: '24:E9:CA:A1:4C:5B',
    interruptGroupId: 0,
    volumeGroupId: 1,
    displayName: '12321'
  };
}