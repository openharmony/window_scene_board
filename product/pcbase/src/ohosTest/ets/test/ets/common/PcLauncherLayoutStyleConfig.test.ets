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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { SettingsUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { PCUtils } from '../../../../../../../pcbase/src/main/ets/common/utils/PCUtils';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import PcLauncherLayoutStyleConfig from '../../../../../../../pcbase/src/main/ets/common/PcLauncherLayoutStyleConfig';

export default function PcLauncherLayoutStyleConfigTest() {
  describe('PcLauncherLayoutStyleConfigTest', () => {
    let mocker: MockKit;
    let pcLauncherLayoutStyleConfig: PcLauncherLayoutStyleConfig;
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
      pcLauncherLayoutStyleConfig = new PcLauncherLayoutStyleConfig();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })
    it('initStyleTest', 0, () => {
      let mockIsHYM: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHYM);
      when(mockIsHYM)([ArgumentMatchers.any]).afterReturn(true);
      (pcLauncherLayoutStyleConfig as object)['initStyle']();
      let mockIsHAD: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
      when(mockIsHAD)([ArgumentMatchers.any]).afterReturn(true);
      (pcLauncherLayoutStyleConfig as object)['initStyle']();
      (pcLauncherLayoutStyleConfig as object)['initStyle']();
      expect(pcLauncherLayoutStyleConfig instanceof PcLauncherLayoutStyleConfig).assertTrue();
    })


    it('initHADStyleTest', 0, () => {
      let mockReadStatusBarType: Function = mocker.mockFunc(PCUtils, PCUtils.readStatusBarType);
      when(mockReadStatusBarType)([ArgumentMatchers.any]).afterReturn(StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR);
      (pcLauncherLayoutStyleConfig as object)['initHADStyle']();
      expect(pcLauncherLayoutStyleConfig instanceof PcLauncherLayoutStyleConfig).assertTrue();
    })

    it('initSysTopHeightTest', 0, () => {
      let mockReadStatusBarType: Function = mocker.mockFunc(PCUtils, PCUtils.readStatusBarType);
      when(mockReadStatusBarType)([ArgumentMatchers.any]).afterReturn(StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR);
      pcLauncherLayoutStyleConfig.initSysTopHeight();
      expect(pcLauncherLayoutStyleConfig instanceof PcLauncherLayoutStyleConfig).assertTrue();
    })

  })
}