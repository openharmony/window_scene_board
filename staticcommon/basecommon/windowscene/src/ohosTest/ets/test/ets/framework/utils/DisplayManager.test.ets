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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { DisplayMgr, CutoutInfo } from '../../../../../../main/ets/utils/DisplayManager'

export function DisplayManagerTest() {
  describe('DisplayManagerTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('DisplayManagerTest_getCutoutInfo_test', Level.LEVEL0, (): void => {
      let info: CutoutInfo = DisplayMgr.getCutoutInfo();
      expect(Reflect.has(DisplayMgr, 'getCutoutInfo')).assertTrue();
      expect(info.isMidCutout === false).assertInstanceOf('Boolean');
      expect(info.midWidth).assertInstanceOf('Number');
    })
  })
}