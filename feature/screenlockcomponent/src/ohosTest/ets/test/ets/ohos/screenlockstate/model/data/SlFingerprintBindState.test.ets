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

import { describe, it, expect } from '@ohos/hypium'
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlFingerprintBindState } from '../../../../../../../../main/ets/screenlockstate/model/data/SlFingerprintBindState';

export default function SlFingerBindStateTest() {
  describe('SlFingerBindStateTest', () => {
    it('SlFingerBindStateTest_001', 0, () => {
      let fingerBindS: SlFingerprintBindState = new SlFingerprintBindState(SlMainStateType.SL_STATIC_STATE);
      fingerBindS.setEnable(false);
      fingerBindS.setEnable(true);
      fingerBindS.setNtfDisableFingerPrint(false);
      fingerBindS.setNtfDisableFingerPrint(true);
      // 恢复初始值
      fingerBindS.setEnable(false);
      fingerBindS.setNtfDisableFingerPrint(false);
      expect(fingerBindS != null).assertTrue();
    })
    it('SlFingerBindStateTest_002', 0, () => {
      let fingerBindS: SlFingerprintBindState = new SlFingerprintBindState(SlMainStateType.SL_STATIC_STATE);
      fingerBindS.setFingerPositionX(0);
      fingerBindS.setFingerPositionX(1);
      fingerBindS.setFingerPositionY(0);
      fingerBindS.setFingerPositionY(1);
      fingerBindS.setFingerprintRadius(0);
      fingerBindS.setFingerprintRadius(1);
      // 恢复初始值
      fingerBindS.setFingerPositionX(0);
      fingerBindS.setFingerPositionY(0);
      fingerBindS.setFingerprintRadius(0);
      expect(fingerBindS != null).assertTrue();
    })
    it('SlFingerBindStateTest_003', 0, () => {
      let fingerBindS: SlFingerprintBindState = new SlFingerprintBindState(SlMainStateType.SL_STATIC_STATE);
      fingerBindS.setFingerAnimateState(AnimationStatus.Initial);
      fingerBindS.setFingerAnimateState(AnimationStatus.Running);
      // 恢复初始值
      fingerBindS.setFingerAnimateState(AnimationStatus.Initial);
      expect(fingerBindS != null).assertTrue();
    })
  })
}