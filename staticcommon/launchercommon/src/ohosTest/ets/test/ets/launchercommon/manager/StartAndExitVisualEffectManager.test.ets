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

import power from '@ohos.power';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { StartAndExitVisualEffectManager } from '../../../../../../main/ets/TsIndex';

const TAG = 'StartAndExitVisualEffectManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function StartAndExitVisualEffectManagerTest() {
  describe('StartAndExitVisualEffectManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('is_start_exit_blur_disable', 0, (): void => {
      let result: boolean = StartAndExitVisualEffectManager.getInstance().isStartExitBlurDisable();
      let isStartExitBlurDisable: boolean =
        SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE);
      expect(result).assertEqual(isStartExitBlurDisable);
    })

    it('is_motion_blur_disable', 0, (): void => {
      let result: boolean = StartAndExitVisualEffectManager.getInstance().isMotionBlurDisable();
      let isMotionBlurDisable: boolean =
        SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.MOTION_BLUR_DISABLE);
      expect(result).assertEqual(isMotionBlurDisable);
    })

    it('is_power_save_mode', 0, (): void => {
      let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
      try {
        curPowerMode = power.getPowerMode();
      } catch (err) {
        log.showError(`Get device power mode failed , err: ${err?.code}, errMessage: ${err?.message}`);
      }
      let result: boolean = StartAndExitVisualEffectManager.getInstance().isPowerSaveMode();
      let isPowerSaveMode: boolean = curPowerMode === power.DevicePowerMode.MODE_POWER_SAVE ||
        curPowerMode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE;
      expect(result).assertEqual(isPowerSaveMode);
    })
  })
}
