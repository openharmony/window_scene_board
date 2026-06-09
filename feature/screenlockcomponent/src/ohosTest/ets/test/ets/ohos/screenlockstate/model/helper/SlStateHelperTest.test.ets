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
import { slStateHelper } from '../../../../../../../../main/ets/screenlockstate/model/helper/SlStateHelper'

export default function SlStateHelperTestTest() {
  describe('SlStateHelperTestTest', () => {
    it('SlStateHelperTestTest_001', 0, () => {
      slStateHelper.getSlStaticState();
      slStateHelper.getSlStaticState();
      slStateHelper.getSlBindState();
      slStateHelper.getSlBindState();
      slStateHelper.getSlFormStaticState();
      slStateHelper.getSlFormStaticState();
      slStateHelper.getImmersiveListStaticState();
      slStateHelper.getImmersiveListStaticState();
      slStateHelper.getFingerprintAnimState();
      slStateHelper.getFingerprintAnimState();
      slStateHelper.getFingerprintBindState();
      slStateHelper.getOneMirrorStaticState();
      slStateHelper.getOneMirrorStaticState();
      expect(slStateHelper != null).assertTrue();
    })
    it('SlStateHelperTestTest_002', 0, () => {
      slStateHelper.getImmersiveCardBindState();
      slStateHelper.getImmersiveCardBindState();
      slStateHelper.getImmersiveCapBindState();
      slStateHelper.getImmersiveCapBindState();
      slStateHelper.getImmersiveCapAnimState();
      slStateHelper.getImmersiveCapAnimState();
      slStateHelper.getImmersiveListBindState();
      slStateHelper.getImmersiveListBindState();
      slStateHelper.getImmersiveListAnimState();
      slStateHelper.getImmersiveListAnimState();
      slStateHelper.getImmersiveCardAnimState();
      slStateHelper.getImmersiveCardAnimState();
      slStateHelper.getDofWallpaperAnimState();
      slStateHelper.getDofWallpaperAnimState();
      slStateHelper.getDofWallpaperBindState();
      slStateHelper.getDofWallpaperBindState();
      expect(slStateHelper != null).assertTrue();
    })
  })
}