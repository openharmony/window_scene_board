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
} from '@ohos/hypium'
import { ScreenLockApi, SystemSwitchUtils, VerifyDataManager } from '../../../../../main/ets/TsIndex'

export default function ScreenLockApiTest() {
  describe('ScreenLockApiTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })

    it('test_getLock', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SystemSwitchUtils, SystemSwitchUtils.isUseNewScreenLock);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let r = SystemSwitchUtils.isUseNewScreenLock();
      ScreenLockApi.getLock();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      ScreenLockApi.getLock();
      r = SystemSwitchUtils.isUseNewScreenLock();
      expect(r).assertEqual(false);
      mocker.clear(SystemSwitchUtils);
      mocker.clearAll();
    })

    it('test_requestUnlock', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SystemSwitchUtils, SystemSwitchUtils.isUseNewScreenLock);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let r = SystemSwitchUtils.isUseNewScreenLock();
      ScreenLockApi.requestUnlock(undefined);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      ScreenLockApi.requestUnlock(undefined, true);
      ScreenLockApi.requestUnlock(undefined, false);
      r = SystemSwitchUtils.isUseNewScreenLock();
      expect(r).assertEqual(false);
      mocker.clear(SystemSwitchUtils);
      mocker.clearAll();
    })

    it('test_unlockWhenNoPsw', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SystemSwitchUtils, SystemSwitchUtils.isUseNewScreenLock);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let r = SystemSwitchUtils.isUseNewScreenLock();
      ScreenLockApi.unlockWhenNoPsw();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      ScreenLockApi.unlockWhenNoPsw();
      r = SystemSwitchUtils.isUseNewScreenLock();
      expect(r).assertEqual(false);
      mocker.clear(SystemSwitchUtils);
      mocker.clearAll();
    })

    it('test_isSimLocked', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SystemSwitchUtils, SystemSwitchUtils.isUseNewScreenLock);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let r = SystemSwitchUtils.isUseNewScreenLock();
      ScreenLockApi.isSimLocked();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      r = SystemSwitchUtils.isUseNewScreenLock();
      ScreenLockApi.isSimLocked();
      expect(r).assertEqual(false);
      mocker.clear(SystemSwitchUtils);
      mocker.clearAll();
    })
  })
}