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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { ReflectionUtils } from '../session/ReflectionUtils';
import {
  SCBKioskModeManager,
} from '../../../../../../../main/ets/scene/kiosk/SCBKioskModeManager';
import { BusinessError } from '@kit.BasicServicesKit';


export function SCBKioskModeManagerTest() {
  describe('SCBKioskModeManagerTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('initTest', 0, async (done: Function) => {
      let err: BusinessError|undefined = undefined;
      try {
        SCBKioskModeManager.getInstance().init();
      }catch (e) {
        err = e;
      }
      expect(err).assertEqual(undefined);
      done();
    });

    it('isKioskModeTest', 0, async (done: Function) => {
      expect(SCBKioskModeManager.getInstance().isKioskMode()).assertFalse();
      ReflectionUtils.setProperty(SCBKioskModeManager.getInstance(), 'kioskMode', true);
      expect(SCBKioskModeManager.getInstance().isKioskMode()).assertTrue();
      done();
    });

    it('isKioskAppTest', 0, async (done: Function) => {
      let testApp = 'com.test.app';
      expect(SCBKioskModeManager.getInstance().isKioskApp(testApp)).assertFalse();
      ReflectionUtils.setProperty(SCBKioskModeManager.getInstance(), 'kioskApps', [testApp]);
      expect(SCBKioskModeManager.getInstance().isKioskApp(testApp)).assertTrue();
      done();
    });

    it('enterKioskModeAndExitKioskModeTest', 0, async (done: Function) => {
      SCBKioskModeManager.getInstance().enterKioskMode();
      expect(SCBKioskModeManager.getInstance().isKioskMode()).assertTrue();
      SCBKioskModeManager.getInstance().exitKioskMode();
      expect(SCBKioskModeManager.getInstance().isKioskMode()).assertFalse();
      done();
    });

    it('shouldIgnoreBackPressTest', 0, async (done: Function) => {
      let kioskAppPersistentId = 100;
      let noKioskAppPersistentId = 200;
      ReflectionUtils.setProperty(SCBKioskModeManager.getInstance(), 'kioskAppPersistentId', kioskAppPersistentId);
      SCBKioskModeManager.getInstance().enterKioskMode();
      expect(SCBKioskModeManager.getInstance().shouldIgnoreBackPress(kioskAppPersistentId)).assertTrue();
      expect(SCBKioskModeManager.getInstance().shouldIgnoreBackPress(noKioskAppPersistentId)).assertFalse();
      SCBKioskModeManager.getInstance().exitKioskMode();
      expect(SCBKioskModeManager.getInstance().shouldIgnoreBackPress(kioskAppPersistentId)).assertFalse();
      expect(SCBKioskModeManager.getInstance().shouldIgnoreBackPress(noKioskAppPersistentId)).assertFalse();
      done();
    });

    it('getDefaultCallerPersistentIdTest', 0, async (done: Function) => {
      let kioskAppPersistentId = 100;
      ReflectionUtils.setProperty(SCBKioskModeManager.getInstance(), 'kioskAppPersistentId', kioskAppPersistentId);
      expect(SCBKioskModeManager.getInstance().getDefaultCallerPersistentId()).assertEqual(kioskAppPersistentId);
      done();
    });
  });
}