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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { slStateHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/model/helper/SlStateHelper';

/**
 * 锁屏状态工具测试用例
 */
export function SlStateHelperTest() {
  describe('SlStateHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getSlStaticState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlStaticState();
      expect(res).not().assertNull();
    });

    it('test_getSlBindState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlBindState();
      expect(res).not().assertNull();
    });

    it('test_getSlListBindState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlListBindState();
      expect(res).not().assertNull();
    });

    it('test_getSlQtStaticState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlQtStaticState();
      expect(res).not().assertNull();
    });

    it('test_getSlQtStaticState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlCapStaticState();
      expect(res).not().assertNull();
    });

    it('test_getSlQtStaticState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlCameraStaticState();
      expect(res).not().assertNull();
    });
    it('test_getSlGreetStaticState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlLockGreetStaticState();
      expect(res).not().assertNull();
    });
    it('test_getSlGreetBindState', Level.LEVEL0, (): void => {
      let res = slStateHelper.getSlLockGreetBindState();
      expect(res).not().assertNull();
    });
  });
}