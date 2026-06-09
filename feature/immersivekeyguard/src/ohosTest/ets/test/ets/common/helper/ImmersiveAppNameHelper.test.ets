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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, } from '@ohos/hypium';
import { AppNameCallback, appNameHelper } from '../../../../../../main/ets/common/helper/ImmersiveAppNameHelper';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveAppNameHelperTest() {
  describe('ImmersiveAppNameHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_registerListener', Level.LEVEL0, (): void => {
      let callback: AppNameCallback = {
        onUpdateAppName: (appName?: string): void => {}
      };
      appNameHelper.registerListener("TEST_REGISTER", callback);
      let res = appNameHelper.listeners.get("TEST_REGISTER");
      expect(res === callback).assertTrue();
    });

    it('test_registerListener_invalid_callback', Level.LEVEL0, (): void => {
      appNameHelper.registerListener("TEST_REGISTER_INVALID");
      let res = appNameHelper.listeners.get("TEST_REGISTER_INVALID");
      expect(res === undefined).assertTrue();
    });

    it('test_registerListener_invalid_hashcode', Level.LEVEL0, (): void => {
      appNameHelper.registerListener();
      expect(appNameHelper).not().assertNull();
    });

    it('test_unRegisterListener', Level.LEVEL0, (): void => {
      appNameHelper.unRegisterListener("TEST_REGISTER");
      let res = appNameHelper.listeners.get("TEST_REGISTER");
      expect(res === undefined).assertTrue();
    });

    it('test_unRegisterListener_invalid_hascode', Level.LEVEL0, (): void => {
      appNameHelper.unRegisterListener();
      expect(appNameHelper).not().assertNull();
    });

    it('test_getAppName_invalid', Level.LEVEL0, (): void => {
      let res = appNameHelper.getAppName();
      expect(res === undefined).assertTrue();
    });
  });
}