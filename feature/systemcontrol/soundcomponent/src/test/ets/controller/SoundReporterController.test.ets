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
import { it, describe, expect, MockKit, when } from '@ohos/hypium';
import { DeviceInfoBean } from '../../../main/ets/common/DeviceInfoBean';
import SoundDataShareController from '../../../main/ets/controller/SoundDataShareController';
import SoundReporterController from '../../../main/ets/controller/SoundReporterController';

const DEFAULT = 0;
const DEFAULT_MAC = '11:22:33:AA:BB:FF';
const DEFAULT_VALUE = 1;
const DEFAULT_OUTPUT_DEVICE: audio.AudioDeviceDescriptor = {
  address: DEFAULT_MAC,
  deviceType: 8,
  name: 'BluetoothDevice',
  deviceRole: audio.DeviceRole.OUTPUT_DEVICE,
  id: 0,
  sampleRates: [],
  channelCounts: [],
  channelMasks: [],
  networkId: '',
  interruptGroupId: 0,
  volumeGroupId: 0,
  displayName: ''
};

export function SoundReporterControllerTest() {
  describe('SoundReporterControllerTest', (): void => {
    it("clickVoiceButtonReport", DEFAULT, clickVoiceButtonReport);
    it("clickDeviceTitleReport", DEFAULT, clickDeviceTitleReport);
    it("clickNoiseReport", DEFAULT, clickNoiseReport);
    it("clickSpatialReport", DEFAULT, clickSpatialReport);
    it("changeVoicePageVolumeReport", DEFAULT, changeVoicePageVolumeReport);
    it("clickSceneBoardReportMenu", DEFAULT, clickSceneBoardReportMenu);
    it("clickSceneBoardReportDevice", DEFAULT, clickSceneBoardReportDevice);
    it("clickSceneBoardReportNoise", DEFAULT, clickSceneBoardReportNoise);
    it("clickSceneBoardReportSpatial", DEFAULT, clickSceneBoardReportSpatial);
  })
}

function clickVoiceButtonReport(): void {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SoundDataShareController, SoundDataShareController.queryDeviceInfo);
  when(mockFunc)(DEFAULT_MAC).afterReturn(new DeviceInfoBean());
  expect(SoundReporterController.clickVoiceButtonReport(DEFAULT_OUTPUT_DEVICE) === undefined).assertTrue();
  mocker.clear(SoundDataShareController);
}

function clickDeviceTitleReport(): void {
  expect(SoundReporterController.clickDeviceTitleReport(DEFAULT_OUTPUT_DEVICE) === undefined).assertTrue();
}

function clickNoiseReport(): void {
  expect(SoundReporterController.clickNoiseReport(DEFAULT_OUTPUT_DEVICE) === undefined).assertTrue();
}

function clickSpatialReport(): void {
  expect(SoundReporterController.clickSpatialReport(DEFAULT_OUTPUT_DEVICE) === undefined).assertTrue();
}

function changeVoicePageVolumeReport(): void {
  expect(SoundReporterController.changeVoicePageVolumeReport(DEFAULT_OUTPUT_DEVICE.deviceType, DEFAULT_MAC,
    DEFAULT_VALUE) === undefined).assertTrue();
}

function clickSceneBoardReportMenu(): void {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SoundDataShareController, SoundDataShareController.queryDeviceInfo);
  when(mockFunc)(DEFAULT_MAC).afterReturn(new DeviceInfoBean());
  expect(SoundReporterController.clickPcSoundMenuReport(DEFAULT_MAC) === undefined).assertTrue();
  mocker.clear(SoundDataShareController);
}

function clickSceneBoardReportDevice(): void {
  expect(SoundReporterController.changePcSoundDeviceReport(DEFAULT_MAC) === undefined).assertTrue();
}

function clickSceneBoardReportNoise(): void {
  expect(SoundReporterController.clickPcSoundNoiseReport(DEFAULT_MAC, DEFAULT_VALUE) === undefined).assertTrue();
}

function clickSceneBoardReportSpatial(): void {
  expect(SoundReporterController.clickPcSoundSpatialReport(DEFAULT_MAC, DEFAULT_VALUE) === undefined).assertTrue();
}