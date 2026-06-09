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
import { OneMirrorDefaultStrategy } from '../../../../../../../main/ets/onemirror/strategy/OneMirrorDefaultStrategy';
import { MirrorScene } from '../../../../../../../main/ets/onemirror/service/OneMirrorService';

export default function OneMirrorDefaultStrategyTest() {
  const strategy = new OneMirrorDefaultStrategy();

  describe('OneMirrorDefaultStrategyTest', () => {
    it('OneMirrorDefaultStrategyTest_getName', 0, () => {
      expect(strategy.getName() === 'OneMirrorDefaultStrategy').assertTrue();
    })

    it('OneMirrorDefaultStrategyTest_needWallpaperAnim', 0, () => {
      expect(strategy.needWallpaperAnim()).assertTrue();
    })

    it('OneMirrorDefaultStrategyTest_needScreenLockAnim', 0, () => {
      expect(strategy.needScreenLockAnim(MirrorScene.AOD)).assertTrue();
    })

    it('OneMirrorDefaultStrategyTest_hasExtraScreenOffAnim', 0, () => {
      expect(strategy.hasExtraScreenOffAnim()).assertFalse();
    })

    it('OneMirrorDefaultStrategyTest_forceIntoAod', 0, () => {
      expect(strategy.forceIntoAod()).assertFalse();
    })
  })
}
