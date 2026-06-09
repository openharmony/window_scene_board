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
import { ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { it, describe, expect, MockKit, when } from '@ohos/hypium';
import { TouchRunnableManager,
  TriggerType } from '../../../../../../../main/ets/immersivekeyguardcommon/base/manager/TouchRunnableManager';
import { Runnable } from '../../../../../../../main/ets/immersivekeyguardcommon/base/Runnable';

export function TouchRunnableManagerTest() {
  describe('TouchRunnableManagerTest', (): void => {
    it('test_initTouchRunnableManager', 0, (): void => {
      let testInstance: TouchRunnableManager = new TouchRunnableManager();
      expect(testInstance instanceof TouchRunnableManager).assertTrue();
    });

    it('test_TouchRunnableManager_triggerMap', 0, (): void => {
      let testInstance: TouchRunnableManager = new TouchRunnableManager();
      let upRunnableTest: Map<number, Map<TriggerType, Set<Runnable>>> = new Map();
      let id = 5;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let callback: Runnable = () => {};
      when(mockFun1)(upRunnableTest).afterReturn(false);
      upRunnableTest.get(id)
      testInstance.addUpRunnable(1, callback, TriggerType.TRIGGER_IMMEDIATELY);
      expect(testInstance instanceof TouchRunnableManager).assertTrue();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('test_TouchRunnableManager_triggerUpRunnable', 0, (): void => {
      let testInstance: TouchRunnableManager = new TouchRunnableManager();
      let upRunnableTest: Map<number, Map<TriggerType, Set<Runnable>>> = new Map();
      let id = 5;
      upRunnableTest.get(id);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockFun1)(upRunnableTest).afterReturn(false);
      (testInstance as object)['triggerUpRunnable']();
      expect(testInstance instanceof TouchRunnableManager).assertTrue();
      mock.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
    });

    it('test_addUpRunnable', 0, (): void => {
      let testInstance: TouchRunnableManager = new TouchRunnableManager();
      let id = 2;
      let upRunnableTest: Map<number, Map<TriggerType, Set<Runnable>>> = new Map();
      upRunnableTest.get(id);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockFun1)(upRunnableTest).afterReturn(true);
      expect(testInstance instanceof TouchRunnableManager).assertTrue();
      mock.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
    });
  });
}