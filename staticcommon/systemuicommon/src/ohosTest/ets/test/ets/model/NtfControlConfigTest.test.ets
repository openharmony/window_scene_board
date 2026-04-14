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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { NtfControlConfig } from '../../../../../main/ets/model/NtfControlFlags'

/**
 * NtfControlConfig测试类
 */
export default function NtfControlConfigTest() {
  describe('NtfControlConfigTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_isMainTopCampaignNtf', 0, () => {
      // 用增上半区置顶 2^25 + 2^16
      let flags: number = 33619968;
      let controlConfig: NtfControlConfig = new NtfControlConfig(flags);
      const isMainTopCampaignNtf: boolean = controlConfig.isMainTopCampaignNtf();
      expect(isMainTopCampaignNtf).assertTrue();
    });

    it('isMoreTopCampaignNtf', 0, () => {
      // 用增下半区置顶 2^25 + 2^16 + 2^18
      let flags: number = 33882112;
      let controlConfig: NtfControlConfig = new NtfControlConfig(flags);
      const isMoreTopCampaignNtf: boolean = controlConfig.isMoreTopCampaignNtf();
      expect(isMoreTopCampaignNtf).assertTrue();
    });
  })
}