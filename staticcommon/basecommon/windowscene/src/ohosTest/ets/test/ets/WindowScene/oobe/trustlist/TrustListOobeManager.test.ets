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

import { describe, it, expect, } from '@ohos/hypium';
import
  TrustListOobeManager, {
  TrustInfo,
  AddTrustListResult
} from '../../../../../../../main/ets/oobe/trustlist/TrustListOobeManager';

export function TrustListOobeManagerTest() {
  describe('TrustListOobeManagerTest', () => {
    it('addTrustList_NotInitTest', 0, async () => {
      const notInitResult = TrustListOobeManager.addTrustList([]);
      expect(notInitResult === AddTrustListResult.FAILED_OTHER).assertTrue();
    });

    it('addTrustList_NullParamTest', 0, async () => {
      await TrustListOobeManager.initTrustlist(100);
      const nullParamResult = TrustListOobeManager.addTrustList(null);
      expect(nullParamResult === AddTrustListResult.FAILED_INVALID_LIST).assertTrue();
    });

    it('addTrustList_EmptyListParamTest', 0, async () => {
      await TrustListOobeManager.initTrustlist(100);
      const zeroLengthResult = TrustListOobeManager.addTrustList([]);
      expect(zeroLengthResult === AddTrustListResult.FAILED_INVALID_LIST).assertTrue();
    });

    it('addTrustList_ValidParamTest', 0, async () => {
      await TrustListOobeManager.initTrustlist(100);
      const param: TrustInfo[] = [
        {
          bundleName: 'bundleName',
          moduleName: 'moduleName',
          abilityName: 'abilityName',
        },
        {
          bundleName: '',
          moduleName: 'moduleName',
          abilityName: 'abilityName',
        },
        {
          bundleName: 'bundleName',
          moduleName: 'moduleName',
          abilityName: '',
        },
        {
          bundleName: 'bundleName',
          moduleName: '',
          abilityName: 'abilityName',
        },
      ];
      const addResult = TrustListOobeManager.addTrustList(param);
      expect(addResult === AddTrustListResult.SUCCESS).assertTrue();
    });
  });
}
