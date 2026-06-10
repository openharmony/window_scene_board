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

import { describe, it, expect, beforeEach } from '@ohos/hypium';
import {
  AddOobeTrustList,
} from '../../../../../../../../main/ets/oobe/service/impl/AddOobeTrustList';
import {
  TrustInfo,
  AddTrustListResult
} from '../../../../../../../../main/ets/oobe/trustlist/TrustListOobeManager';

export function AddOobeTrustListTest() {
  describe('AddOobeTrustListTest', () => {
    let executor: AddOobeTrustList;
    beforeEach(() => {
      executor = new AddOobeTrustList();
    });

    it('isTrustInfoList_NullParamTest', 0, () => {
      const result = executor['isTrustInfoList'](null);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NonObjectParamTest', 0, () => {
      const result = executor['isTrustInfoList']('not object');
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_InvalidArrayParamTest', 0, () => {
      const result = executor['isTrustInfoList']([1, 2, 3]);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NoBundleNameParamTest', 0, () => {
      interface NoBundleName {
        moduleName: string,
        abilityName: string,
      }

      const noBundleNameParam: NoBundleName[] = [
        { moduleName: 'mod1', abilityName: 'ability1' },
        { moduleName: 'mod2', abilityName: 'ability2' }
      ];
      const result = executor['isTrustInfoList'](noBundleNameParam);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NonStringBundleParamTest', 0, () => {
      interface NonStringBundleName {
        bundleName: number,
        moduleName: string,
        abilityName: string,
      }

      const nonStringBundleNameParam: NonStringBundleName[] = [
        { bundleName: 123, moduleName: 'mod1', abilityName: 'ability1' },
      ];
      const result = executor['isTrustInfoList'](nonStringBundleNameParam);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NoModuleNameParamTest', 0, () => {
      // 输入无moduleName, 验证返回false
      interface NoModuleName {
        bundleName: string,
        abilityName: string,
      }

      const noModuleNameParam: NoModuleName[] = [
        { bundleName: 'bundle1', abilityName: 'ability1' },
      ];
      const result = executor['isTrustInfoList'](noModuleNameParam);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NonStringModuleNameParamTest', 0, () => {
      interface NonStringModuleName {
        bundleName: string,
        moduleName: number,
        abilityName: string,
      }

      const nonStringModuleNameParam: NonStringModuleName[] = [
        { bundleName: 'bundle1', moduleName: 123, abilityName: 'ability1' },
      ]
      const result = executor['isTrustInfoList'](nonStringModuleNameParam);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NoAbilityNameParamTest', 0, () => {
      interface NoAbilityName {
        bundleName: string,
        moduleName: string,
      }

      const noAbilityNameParam: NoAbilityName[] = [
        { bundleName: 'bundle1', moduleName: 'mod1' },
      ]
      const result = executor['isTrustInfoList'](noAbilityNameParam);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_NonStringAbilityNameParamTest', 0, () => {
      interface NonStringAbilityName {
        bundleName: string,
        moduleName: string,
        abilityName: number
      }

      const nonStringAbilityNameParam: NonStringAbilityName[] = [
        { bundleName: 'bundle1', moduleName: 'mod1', abilityName: 123 },
      ]
      const result = executor['isTrustInfoList'](nonStringAbilityNameParam);
      expect(result).assertEqual(false);
    });

    it('isTrustInfoList_EmptyListParamTest', 0, () => {
      const result = executor['isTrustInfoList']([]);
      expect(result).assertEqual(true);
    });

    it('isTrustInfoList_ValidParamTest', 0, () => {
      const param: TrustInfo[] = [
        { bundleName: 'bundle1', moduleName: 'mod1', abilityName: 'ability1' },
        { bundleName: 'bundle2', moduleName: 'mod2', abilityName: 'ability2' }
      ];
      const result = executor['isTrustInfoList'](param);
      expect(result).assertEqual(true);
    });

    it('checkAuthTest', 0, async () => {
      const result = await executor['checkAuth']();
      expect(result).assertFalse();
    });

    it('executeTest', 0, async () => {
      const result = await executor.execute();
      expect(result === JSON.stringify(AddTrustListResult.FAILED_INVALID_CALLER)).assertTrue();
    });
  });
}
