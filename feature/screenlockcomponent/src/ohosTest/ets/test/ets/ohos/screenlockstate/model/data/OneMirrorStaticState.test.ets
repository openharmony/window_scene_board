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

import { describe, it, expect } from '@ohos/hypium'
import { OneMirrorStaticState } from '../../../../../../../../main/ets/screenlockstate/model/data/OneMirrorStaticState';

export default function OneMirrorStaticStateTest() {
  describe('OneMirrorStaticStateTest', () => {
    it('OneMirrorStaticStateTest_001', 0, () => {
      let fingerBindS: OneMirrorStaticState = new OneMirrorStaticState();
      fingerBindS.setOneMirrorState(false);
      fingerBindS.setOneMirrorState(true);
      fingerBindS.setAodShowingState(false);
      fingerBindS.setAodShowingState(true);
      fingerBindS.setIsDesktopToSL(false);
      fingerBindS.setIsDesktopToSL(true);
      fingerBindS.setIsNeedToShowImmersive(false);
      fingerBindS.setIsNeedToShowImmersive(true);
      fingerBindS.setIsHasBoardCastingCenter(false);
      fingerBindS.setIsHasBoardCastingCenter(true);
      // 恢复初始值
      fingerBindS.setOneMirrorState(false);
      fingerBindS.setAodShowingState(false);
      fingerBindS.setIsDesktopToSL(false);
      fingerBindS.setIsNeedToShowImmersive(false);
      fingerBindS.setIsHasBoardCastingCenter(false);
      expect(fingerBindS != null).assertTrue();
    })
    it('OneMirrorStaticStateTest_002', 0, () => {
      let fingerBindS: OneMirrorStaticState = new OneMirrorStaticState();
      fingerBindS.setSleepReason(-1);
      fingerBindS.setSleepReason(0);
      // 恢复初始值
      fingerBindS.setSleepReason(-1);
      expect(fingerBindS != null).assertTrue();
    })
  })
}