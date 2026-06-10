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

import { describe, it, expect, beforeEach} from '@ohos/hypium';
import {
  BaseOobeService
} from '../../../../../../../main/ets/oobe/service/BaseOobeService';

export function BaseOobeServiceTest() {
  describe('BaseOobeServiceTest', () => {
    let service: BaseOobeService;
    beforeEach(() => {
      service = new BaseOobeService();
    });

    it('onCreateTest', 0, (): void => {
      expect(service.onCreate(null) === undefined).assertTrue();
    });

    it('onRequestTest', 0, (): void => {
      expect(service.onRequest(null, 100) === undefined).assertTrue();
    });

    it('onConnect_NullParamTest', 0, async (): Promise<void> => {
      const stub = service.onConnect(null);
      expect(typeof stub === 'object').assertTrue();
    });

    it('onConnect_ValidParamTest', 0, async (): Promise<void> => {
      let want: Want = {
        abilityName: 'abilityName',
        bundleName: 'bundleName',
      };
      const stub = await service.onConnect(want);
      expect(typeof stub === 'object').assertTrue();
    });

    it('onDisconnectTest', 0, async (): Promise<void> => {
      expect(await service.onDisconnect(null) === undefined).assertTrue();
    })

    it('onDestroyTest', 0, (): void => {
      expect(service.onDestroy() === undefined).assertTrue();
    })
  });
}
