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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit } from '@ohos/hypium';
import { immersiveKgMgr, ImmersiveType, StateType } from '../../../../../../main/ets/TsIndex';

const DEFAULT: number = 0;

export function ImmersiveKeyguardStateManagerTest() {
  describe('ImmersiveKeyguardStateManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('ImmersiveKeyguardStateManagerTest_unregisterStateChangeListener', DEFAULT, (): void => {
      immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_DARK_MODE, null);
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_getBeforeImmersiveState', DEFAULT, (): void => {
      immersiveKgMgr.getBeforeImmersiveState();
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_setBeforeImmersiveState', DEFAULT, (): void => {
      immersiveKgMgr.setBeforeImmersiveState(ImmersiveType.TYPE_LIST);
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_exitImmersiveState_01', DEFAULT, (): void => {
      immersiveKgMgr.exitImmersiveState(true);
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_exitImmersiveState_02', DEFAULT, (): void => {
      immersiveKgMgr.exitImmersiveState(false);
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_notifyStateChange', DEFAULT, (): void => {
      immersiveKgMgr.notifyStateChange();
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_getFingerprintState', DEFAULT, (): void => {
      immersiveKgMgr.getFingerprintState();
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_setImmersiveType', DEFAULT, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, true);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE, true);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE, true);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_WIDTH_DISPLAY_STATE, true);
      expect(true).assertTrue();
    });

    it('ImmersiveKeyguardStateManagerTest_updateFingerprintEnable', DEFAULT, (): void => {
      immersiveKgMgr.updateFingerprintEnable(true);
      immersiveKgMgr.updateFingerprintEnable(false);
      expect(true).assertTrue();
    });
  })
}