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
import { IconExtendParam } from '../../../../../../../main/ets/resourcemanager/IconExtendParam';
import IconInfo, { IconPicType } from '../../../../../../../main/ets/resourcemanager/IconInfo';
import { resourceManagerFwk } from '../../../../../../../main/ets/TsIndex';

export function ResourceManagerFwkTest() {
  const bundleName = 'com.ohos.photos';
  const moduleName = 'phone_photos';
  const abilityName = 'com.ohos.photos.MainAbility';

  const comBundleName = 'com.ohos.maps.app';
  const comModuleName = 'entry';
  const comAbilityName = 'EntryAbility';

  describe('ResourceManagerFwkTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('getCombIcon', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      let icon: IconInfo = await resourceManagerFwk.getIconResourceFromFwk(param, bundleName, moduleName, abilityName);
      expect(icon.iconType).assertEqual(IconPicType.ADAPTIVE);
      let icon1: IconInfo = await resourceManagerFwk.getIconResourceFromFwk(param, bundleName, moduleName, undefined);
      expect(icon1.iconType).assertEqual(IconPicType.ADAPTIVE);
      let icon2: IconInfo = await resourceManagerFwk.getIconResourceFromFwk(param,comBundleName, comModuleName, comAbilityName);
      expect(icon2.iconType).assertEqual(IconPicType.NORMAL);
      done();
    });
  });
}