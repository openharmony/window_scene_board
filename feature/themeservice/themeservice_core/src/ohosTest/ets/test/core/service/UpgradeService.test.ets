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
import { describe, expect, it } from '@ohos/hypium';
import { TsLog } from '@ohos/themeservicebase/Index';
import { TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { TsConfig } from '../../../../../main/ets/cache/TsConfig';

const TAG: string = 'UpgradeService.test';

export default function UpgradeServiceTest() {
  describe('UpgradeServiceTest', () => {
    it('test001', 0, async () => {
      const lastVersion: number = await TsConfig.get().getLastVersion();
      await TsConfig.get().setLastVersion(lastVersion + 1);
      await TServiceApi.upgrade().init((from: number, to: number) => {
        TsLog.info(TAG, `doUpgrade recovery ${from} -> ${to}}`);
        return Promise.resolve();
      })
      expect(await TsConfig.get().getLastVersion()).assertEqual(TsConfig.TS_DATA_VER);
    })
  })
}