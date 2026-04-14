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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { describe, it, expect, MockKit, when } from '@ohos/hypium'
import {
  OneMirrorSmallFoldStrategy
} from '../../../../../../../main/ets/onemirror/strategy/OneMirrorSmallFoldStrategy';
import { MirrorScene } from '../../../../../../../main/ets/onemirror/service/OneMirrorService';

export default function OneMirrorSmallFoldStrategyTest() {
  const strategy = new OneMirrorSmallFoldStrategy();

  describe('OneMirrorSmallFoldStrategyTest', () => {
    it('OneMirrorSmallFoldStrategyTest_getName', 0, () => {
      expect(strategy.getName() === 'OneMirrorSmallFoldStrategy').assertTrue();
    })

    it('OneMirrorSmallFoldStrategyTest_needWallpaperAnim', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSubDisplayMode);
      when(mockFun)().afterReturn(true);
      expect(strategy.needWallpaperAnim()).assertFalse();
      when(mockFun)().afterReturn(false);
      expect(strategy.needWallpaperAnim()).assertTrue();
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('OneMirrorSmallFoldStrategyTest_needScreenLockAnim', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSubDisplayMode);
      when(mockFun)().afterReturn(true);
      expect(strategy.needScreenLockAnim(MirrorScene.AOD)).assertFalse();
      when(mockFun)().afterReturn(false);
      expect(strategy.needScreenLockAnim(MirrorScene.AOD)).assertTrue();
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('OneMirrorSmallFoldStrategyTest_hasExtraScreenOffAnim', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSubDisplayMode);
      when(mockFun)().afterReturn(true);
      expect(strategy.hasExtraScreenOffAnim()).assertTrue();
      when(mockFun)().afterReturn(false);
      expect(strategy.hasExtraScreenOffAnim()).assertFalse();
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('OneMirrorSmallFoldStrategyTest_forceIntoAod', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSubDisplayMode);
      when(mockFun)().afterReturn(true);
      expect(strategy.forceIntoAod()).assertTrue();
      when(mockFun)().afterReturn(false);
      expect(strategy.forceIntoAod()).assertFalse();
      mock.clear(DeviceHelper);
      mock.clearAll();
    })
  })
}