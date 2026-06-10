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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,ArgumentMatchers } from '@ohos/hypium'
import { AccountHelper, PowerUtils, ScreenOnOffService, SwitchEventData, UserSwitchService } from '../../../../../main/ets/TsIndex'


/**
 * 锁屏状态服务测试
 */
export default function UserSwitchServiceTest() {
  describe('UserSwitchServiceTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('UserSwitchServiceTest_getisCurrentUserActive_001', Level.LEVEL0, () => {
      let userSwitch = UserSwitchService.getInstance();
      let result = userSwitch.isCurrentUserActive;
      expect(result).assertTrue();
    })

    it('UserSwitchServiceTest_setisCurrentUserActive_002', Level.LEVEL0, () => {
      let userSwitch = UserSwitchService.getInstance();
      let isCurrentUserActive = userSwitch.isCurrentUserActive;
      userSwitch['isCurrentUserActive'] = isCurrentUserActive;
      expect(isCurrentUserActive).assertInstanceOf('Boolean');

      userSwitch['isCurrentUserActive'] = !isCurrentUserActive;
      expect(isCurrentUserActive).assertInstanceOf('Boolean');
    })

    it('UserSwitchServiceTest_doInit_003', Level.LEVEL0, () => {
      let userSwitch = UserSwitchService.getInstance();
      let result = userSwitch['doInit']();
      expect(result == null).assertTrue();
    })

    it('UserSwitchServiceTest_doRelease_004', Level.LEVEL0, () => {
      let userSwitch = UserSwitchService.getInstance();
      let result = userSwitch['doRelease']();
      expect(result == null).assertTrue();
    })

    it('UserSwitchServiceTest_handleSwitchingEvent_005', Level.LEVEL0, () => {
      let userSwitch = UserSwitchService.getInstance();
      let result = userSwitch['handleSwitchingEvent'](null);
      expect(result == null).assertTrue();

      let switchData: SwitchEventData = {
        fromAccountId: 12345678,
        toAccountId: 12345678
      };
      result = userSwitch['handleSwitchingEvent'](switchData);
      expect(result == null).assertTrue();

      switchData.toAccountId = AccountHelper.getInstance().currentLocalId;
      result = userSwitch['handleSwitchingEvent'](switchData);
      expect(result == null).assertTrue();

      let screenService = ScreenOnOffService.getInstance();
      screenService['isIntoSleep'] = true;
      switchData.toAccountId = AccountHelper.getInstance().currentLocalId + 1;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(PowerUtils, PowerUtils.isActive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      result = userSwitch['handleSwitchingEvent'](switchData);
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      result = userSwitch['handleSwitchingEvent'](switchData);
      expect(result == null).assertTrue();

      mocker.clear(PowerUtils);
      mocker.clearAll();
    })

    it('UserSwitchServiceTest_handleSwitchedEvent_005', Level.LEVEL0, () => {
      let userSwitch = UserSwitchService.getInstance();
      let switchData: SwitchEventData = {
        fromAccountId: 12345678,
        toAccountId: 12345678
      };
      let result = userSwitch['handleSwitchedEvent'](null);
      expect(result == null).assertTrue();

      result = userSwitch['handleSwitchedEvent'](switchData);
      expect(result == null).assertTrue();

      switchData.toAccountId = switchData.toAccountId + 1;
      result = userSwitch['handleSwitchedEvent'](switchData);
      expect(result == null).assertTrue();
    })

  })
}