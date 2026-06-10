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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { SCBScreenSessionManager } from '@ohos/windowscene'
import { PowerState, ScreenLockStateManager, ScreenOnOffService, SleepReason, SlServerHelper } from '../../../../../main/ets/TsIndex'


/**
 * 锁屏状态服务测试
 */
export default function ScreenOnOffServiceTest() {
  describe('ScreenOnOffServiceTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('ScreenOnOffServiceTest_powerStateChangeListener_001', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['_powerStateChangeListener'];
      result.onStateChange('test', 1)
      expect(result).not().assertNull();
    })

    it('ScreenOnOffServiceTest_getisScreenOn_002', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService.isScreenOn;
      expect(result).assertTrue();
    })

    it('ScreenOnOffServiceTest_setisScreenOn_003', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let isScreenOn = screenService.isScreenOn;
      screenService['isScreenOn'] = isScreenOn;
      expect(isScreenOn).assertInstanceOf('Boolean');

      screenService['isScreenOn'] = !isScreenOn;
      expect(isScreenOn).assertInstanceOf('Boolean');
    })

    it('ScreenOnOffServiceTest_getisIntoSleep_004', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService.isIntoSleep;
      expect(result).assertFalse();
    })

    it('ScreenOnOffServiceTest_setisIntoSleep_005', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let isIntoSleep = screenService.isIntoSleep;
      screenService['isIntoSleep'] = isIntoSleep;
      expect(isIntoSleep).assertInstanceOf('Boolean');

      screenService['isIntoSleep'] = !isIntoSleep;
      expect(isIntoSleep).assertInstanceOf('Boolean');
    })

    it('ScreenOnOffServiceTest_doInit_006', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['doInit']();
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_doRelease_007', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['doRelease']();
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_handlePowerEvent_008', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['handlePowerEvent'](PowerState.BEGIN_WAKE_UP, 1);
      expect(result == null).assertTrue();

      result = screenService['handlePowerEvent'](PowerState.BEGIN_DISPLAY_ON, 1);
      expect(result == null).assertTrue();

      result = screenService['handlePowerEvent'](PowerState.END_DISPLAY_ON, 1);
      expect(result == null).assertTrue();

      result = screenService['handlePowerEvent'](PowerState.BEGIN_SLEEP, 1);
      expect(result == null).assertTrue();

      result = screenService['handlePowerEvent'](PowerState.END_SLEEP, 1);
      expect(result == null).assertTrue();

      result = screenService['handlePowerEvent'](PowerState.END_DISPLAY_OFF, 1);
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_handleBeginWakeUp_009', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['handleBeginWakeUp'](26);
      expect(result == null).assertTrue();

      result = screenService['handleBeginWakeUp'](40);
      expect(result == null).assertTrue();

      result = screenService['handleBeginWakeUp'](32);
      expect(result == null).assertTrue();

      result = screenService['handleBeginWakeUp'](1);
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_handleNormalBeginWakeUp_010', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['handleNormalBeginWakeUp'](2);
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_rotateFoldFullScreen_011', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpandedButNotSmallFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = screenService['rotateFoldFullScreen']();
      expect(result == null).assertTrue();

      let mockfunc1 = mocker.mockFunc(SCBScreenSessionManager.getInstance(), SCBScreenSessionManager.getInstance().getMainScreenSession);
      when(mockfunc1)(ArgumentMatchers.any).afterThrow('test error');
      try {
        result = screenService['rotateFoldFullScreen']();
      } catch (e) {
        expect(e).assertEqual('test error');
      }

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      result = screenService['rotateFoldFullScreen']();
      expect(result == null).assertTrue();

      mocker.clear(DeviceHelper);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
    })

    it('ScreenOnOffServiceTest_handleBeginDisplayOn_012', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      ScreenLockStateManager.getInstance()['_lockStateInfo'].pageState = 2;
      let result = screenService['handleBeginDisplayOn'](1);
      expect(result == null).assertTrue();

      ScreenLockStateManager.getInstance()['_lockStateInfo'].pageState = 1;
      result = screenService['handleBeginDisplayOn'](1);
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_handleEndDisplayOn_013', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['handleEndDisplayOn'](1);
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_handleBeginSleep_014', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SlServerHelper.getInstance(), SlServerHelper.getInstance().isScreenLockDisabled);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = screenService['handleBeginSleep'](1);
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      result = screenService['handleBeginSleep'](32);
      expect(result == null).assertTrue();

      result = screenService['handleBeginSleep'](1);
      expect(result == null).assertTrue();

      mocker.clear(SlServerHelper.getInstance());
      mocker.clearAll();
    })

    it('ScreenOnOffServiceTest_convertSleepReason_015', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['convertSleepReason'](32);
      expect(result).assertEqual(SleepReason.PROXIMITY);

      result = screenService['convertSleepReason'](1);
      expect(result).assertEqual(SleepReason.OTHER);
    })

    it('ScreenOnOffServiceTest_handleEndDisplayOff_016', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['handleEndDisplayOff'](32);
      expect(result == null).assertTrue();
    })

    it('ScreenOnOffServiceTest_handleEndSleep_017', Level.LEVEL0, () => {
      let screenService = ScreenOnOffService.getInstance();
      let result = screenService['handleEndSleep'](32);
      expect(result == null).assertTrue();
    })
  })
}