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
import { describe, afterEach, beforeEach, it, expect } from "@ohos/hypium";

import screenSessionManager from '@ohos.screenSessionManager';
import { SCBTvCastEventManager } from "../../../../../main/ets/manager/SCBTvCastEventManager";

const SCREEN_NAME_APP_CAST: string = 'HwCast_AppModeDisplay';

export function SCBTvCastEventManagerTest() {
  describe('SCBTvCastEventManagerTest', () => {
    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    it('SCBTvCastEventManagerTest_01', 0, (): void => {
      const screenSession: screenSessionManager.ScreenSession = {
        screenId: 1000,
        name: SCREEN_NAME_APP_CAST
      } as screenSessionManager.ScreenSession;
      const castEventManager = SCBTvCastEventManager.getInstance();
      castEventManager.init(screenSession);
      expect(castEventManager.getScreenName()).assertEqual(SCREEN_NAME_APP_CAST);
      let ret = castEventManager.dispatchAppCastOrientationChange(1001, 0, 0);
      expect(ret).assertFalse();
      ret = castEventManager.dispatchAppCastOrientationChange(1000, 0, 0);
      expect(ret).assertTrue();
      castEventManager.deInit(screenSession);
      expect(castEventManager.getScreenName()).assertUndefined();
    });
  });
}
