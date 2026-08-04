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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { LocalHapMigrateInfo } from '../../../../../../main/ets/transformdata/LocalHapMigrateInfo'
import { AppReserveType } from '../../../../../../main/ets/transformdata/TransformAppInfoManager';

export default function LocalHapMigrateInfoTest() {
  describe('LocalHapMigrateInfoTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it("test_localHapMigrateInfo", 0, async(done:Function) => {
      let localHapMigrateInfo1: LocalHapMigrateInfo = new LocalHapMigrateInfo(new Object({
        sourceModule: '123',
        targetModule: '456',
        sourceModules: ['123', '456']
      }));
      let sourceModuleResult = localHapMigrateInfo1.source;
      expect(sourceModuleResult).assertEqual(localHapMigrateInfo1.sourceModule);
      let targetModuleResult = localHapMigrateInfo1.target;
      expect(targetModuleResult).assertEqual(localHapMigrateInfo1.targetModule);
      let sourcesResult = localHapMigrateInfo1.sources;
      expect(sourcesResult).assertEqual(localHapMigrateInfo1.sourceModules);
      expect(localHapMigrateInfo1.isValid()).assertInstanceOf('Boolean');
      let localHapMigrateInfo2: LocalHapMigrateInfo = new LocalHapMigrateInfo(new Object());
      expect(localHapMigrateInfo2.isValid()).assertInstanceOf('Boolean');
      done();
    })

    it('test_constructor', 0, () => {
      const APP_TASTE_FRESH = 1 << 2;
      const APP_IN_APP_LIST = 1 << 3;
      const APP_IN_DELIVER_TONG_LIST = 1 << 4;
      const APP_NOT_IN_LIST = 1 << 5;
      const APP_ENTERPRISE = 1 << 6;
      let localHapMigrateInfo: LocalHapMigrateInfo = new LocalHapMigrateInfo(new Object({ type: APP_TASTE_FRESH }));
      expect(localHapMigrateInfo.type).assertEqual(AppReserveType.TASTE_FRESH);
      localHapMigrateInfo = new LocalHapMigrateInfo(new Object({ type: APP_IN_APP_LIST }));
      expect(localHapMigrateInfo.type).assertEqual(AppReserveType.APP);
      localHapMigrateInfo = new LocalHapMigrateInfo(new Object({ type: APP_IN_DELIVER_TONG_LIST }));
      expect(localHapMigrateInfo.type).assertEqual(AppReserveType.DELIVER_TONG);
      localHapMigrateInfo = new LocalHapMigrateInfo(new Object({ type: APP_NOT_IN_LIST }));
      expect(localHapMigrateInfo.type).assertEqual(AppReserveType.OTHER_DELIVER);
      localHapMigrateInfo = new LocalHapMigrateInfo(new Object({ type: APP_ENTERPRISE }));
      expect(localHapMigrateInfo.type).assertEqual(AppReserveType.ENTERPRISE);
    });
  })
}