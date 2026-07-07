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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { AiBarCloneCallbackManager } from '../../../../../../main/ets/TsIndex';

export default function AiBarCloneCallbackManagerTest() {
  describe('AiBarCloneCallbackManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_AiBarCloneCallbackManager', 0, async (done: Function) => {
      const instance: AiBarCloneCallbackManager = AiBarCloneCallbackManager.getInstance();
      expect(instance).not().assertNull();
      done();
    })

    it('test_isCloneToOpenThreeKey', 0, async () => {
      const instance: AiBarCloneCallbackManager = AiBarCloneCallbackManager.getInstance();
      instance.isCloneToOpenThreeKey = true;
      expect(instance.isCloneToOpenThreeKey).assertTrue();
    });

    it('test_registerSettingsDataRestoreFinishCallbacks', 0, async () => {
      const instance: AiBarCloneCallbackManager = AiBarCloneCallbackManager.getInstance();
      instance.registerSettingsDataRestoreFinishCallbacks('TAG', () => {
      });
      expect(instance instanceof AiBarCloneCallbackManager).assertTrue();
    });

    it('test_unRegisterSettingsDataRestoreFinishCallbacks', 0, async () => {
      const instance: AiBarCloneCallbackManager = AiBarCloneCallbackManager.getInstance();
      instance.unRegisterSettingsDataRestoreFinishCallbacks('TAG');
      expect(instance instanceof AiBarCloneCallbackManager).assertTrue();
    });

    it('test_executeCallback', 0, async () => {
      const instance: AiBarCloneCallbackManager = AiBarCloneCallbackManager.getInstance();
      instance.executeCallback(undefined);
      expect(instance).not().assertNull();
    });
  })
}