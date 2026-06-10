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
import { DesktopManager, DesktopParam } from '../../../../../../main/ets/TsIndex';

export default function DesktopManagerTest() {
  describe('DesktopManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getInstance', 0, async (done: Function) => {
      const getInstance: DesktopManager = DesktopManager.getInstance();
      expect(getInstance instanceof DesktopManager).assertTrue();
      done();
    })

    it('test_getDesktopParam', 0, async (done: Function) => {
      const desktopManager: DesktopManager = new DesktopManager();
      const desktopParam: DesktopParam = desktopManager.updateParam().updateExtendParam().getDesktopParam();
      expect(desktopParam instanceof DesktopParam).assertTrue();
      done();
    })

  })
}