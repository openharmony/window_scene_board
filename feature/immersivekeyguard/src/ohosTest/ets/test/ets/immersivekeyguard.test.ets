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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import KeyGuardNtfController from '../../../../main/ets/common/KeyGuardNtfController';
import { KeyGuardNtfFuncType } from '../../../../main/ets/common/KeyGuardNtfController'

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveKeyguardTest() {
  describe('ImmersiveKeyguardTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_register', Level.LEVEL1, (): void => {
      KeyGuardNtfController.register(KeyGuardNtfFuncType.SYNC_ICON_TRANSLATE_Y, () => {});
      expect(KeyGuardNtfController).not().assertNull();
    });

    it('test_invoke', Level.LEVEL1, (): void => {
      KeyGuardNtfController.invoke(KeyGuardNtfFuncType.SYNC_ICON_TRANSLATE_Y, 0);
      expect(KeyGuardNtfController).not().assertNull();
    });
  });
}