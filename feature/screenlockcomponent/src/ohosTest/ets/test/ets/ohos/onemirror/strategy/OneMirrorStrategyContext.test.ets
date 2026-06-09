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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { describe, it, expect, MockKit, when } from '@ohos/hypium'
import {
  OneMirrorSmallFoldStrategy
} from '../../../../../../../main/ets/onemirror/strategy/OneMirrorSmallFoldStrategy';
import { OneMirrorStrategyContext } from '../../../../../../../main/ets/onemirror/strategy/OneMirrorStrategyContext';

export default function OneMirrorStrategyContextTest() {
  describe('OneMirrorStrategyContext', () => {
    it('OneMirrorStrategyContextTest_getInstance', 0, () => {
      const instance1 = OneMirrorStrategyContext.getInstance();
      const instance2 = OneMirrorStrategyContext.getInstance();
      expect(instance1 === instance2).assertTrue();
    })

    it('OneMirrorDefaultStrategyTest_init_getStrategy', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockFun)().afterReturn(false);
      OneMirrorStrategyContext.getInstance().init();
      when(mockFun)().afterReturn(true);
      OneMirrorStrategyContext.getInstance().init();
      const strategy = OneMirrorStrategyContext.getInstance().getStrategy();
      expect(strategy instanceof OneMirrorSmallFoldStrategy).assertTrue();
      mock.clear(DeviceHelper);
      mock.clearAll();
    })
  })
}
