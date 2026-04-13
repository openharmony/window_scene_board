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

import { it, describe, expect, MockKit, when } from '@ohos/hypium';
import { DeviceInfoBean } from '../../../main/ets/common/DeviceInfoBean';
import SoundDataShareController from '../../../main/ets/controller/SoundDataShareController';

const DEFAULT = 0;
const DEFAULT_MAC = '11:22:33:AA:BB:FF';
const DEFAULT_DEVICE_INFO = new DeviceInfoBean();

export function SoundDataShareControllerTest() {
  describe('SoundDataShareControllerTest', (): void => {
    it("queryDeviceInfoInvalidMac", DEFAULT, queryDeviceInfoInvalidMac);
    it("queryDeviceInfoActiveMac", DEFAULT, queryDeviceInfoActiveMac);
    it("queryDeviceHasMac", DEFAULT, queryDeviceHasMac);
    it("destroyDeviceInfo", DEFAULT, destroyDeviceInfo);
  })
}

async function queryDeviceInfoInvalidMac(): Promise<void> {
  const deviceInfo: DeviceInfoBean | null = await SoundDataShareController.queryDeviceInfo('');
  expect(deviceInfo).assertNull();
}

async function queryDeviceInfoActiveMac(): Promise<void> {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SoundDataShareController, SoundDataShareController.queryDeviceInfo);
  when(mockFunc)(DEFAULT_MAC).afterReturn(DEFAULT_DEVICE_INFO);
  const deviceInfo: DeviceInfoBean | null = await SoundDataShareController.queryDeviceInfo(DEFAULT_MAC);
  expect(deviceInfo).not().assertNull();
  mocker.clear(SoundDataShareController);
}

async function queryDeviceHasMac(): Promise<void> {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SoundDataShareController, SoundDataShareController.queryDeviceInfo);
  when(mockFunc)(DEFAULT_MAC).afterReturn(DEFAULT_DEVICE_INFO);
  const deviceInfoOne: DeviceInfoBean | null = await SoundDataShareController.queryDeviceInfo(DEFAULT_MAC);
  const deviceInfoTwo: DeviceInfoBean | null = await SoundDataShareController.queryDeviceInfo(DEFAULT_MAC);
  expect(deviceInfoTwo).assertEqual(deviceInfoOne);
  mocker.clear(SoundDataShareController);
}

async function destroyDeviceInfo(): Promise<void> {
  expect(SoundDataShareController.destroy() === undefined).assertTrue();
}
