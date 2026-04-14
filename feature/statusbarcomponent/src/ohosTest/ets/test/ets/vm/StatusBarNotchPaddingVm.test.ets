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
import { ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { StatusBarNotchPaddingVm } from '../../../../../main/ets/vm/StatusBarNotchPaddingVm';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DeviceInfoVm } from '@ohos/systemuicommon/src/main/ets/vm/DeviceInfoVm';
import { MockStatusBarVmInjector } from '../common/MockStatusBarVnInjector';

export default function StatusBarNotchPaddingVmTest() {
  describe('StatusBarNotchPaddingVmTest', () => {
    let injector = new MockStatusBarVmInjector();
    let paddingVm = new StatusBarNotchPaddingVm(injector);
    let mock = new MockKit();

    beforeEach(() => {
      injector = new MockStatusBarVmInjector();
      paddingVm = new StatusBarNotchPaddingVm(injector);
      mock = new MockKit();
    });

    it('test_calcStatusBarPadding_01', 0, () => {
      const func = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      paddingVm.calcStatusBarPadding();
      expect(injector != null).assertTrue();
    });

    it('test_calcStatusBarPadding_02', 0, () => {
      const func = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(func)(ArgumentMatchers.any).afterReturn(false);
      Reflect.set(paddingVm, 'statusBarLeftPadding', 0);

      paddingVm.calcStatusBarPadding();
      expect(injector != null).assertTrue();
    });

    it('test_calcStatusBarPadding_03', 0, () => {
      const func = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(func)(ArgumentMatchers.any).afterReturn(false);
      Reflect.set(paddingVm, 'statusBarLeftPadding', 0);

      const deviceInfoVm = DeviceInfoVm.instance;
      const func2 = mock.mockFunc(deviceInfoVm, deviceInfoVm.getDeviceRadius);
      when(func2)().afterReturn(-1);
      paddingVm.calcStatusBarPadding();
      expect(injector != null).assertTrue();

      when(func2)().afterReturn(undefined);
      paddingVm.calcStatusBarPadding();
      expect(injector != null).assertTrue();

      mock.ignoreMock(deviceInfoVm, deviceInfoVm.getDeviceRadius);
    });

    it('test_calcStatusBarPadding_04', 0, () => {
      const func = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(func)(ArgumentMatchers.any).afterReturn(false);
      Reflect.set(paddingVm, 'statusBarLeftPadding', 0);

      Reflect.set(paddingVm, 'MIN_PADDING', 9999999);
      paddingVm.calcStatusBarPadding();
      expect(injector != null).assertTrue();
    });

  });
}
