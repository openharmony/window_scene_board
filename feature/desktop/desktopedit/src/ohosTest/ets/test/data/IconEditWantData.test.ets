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
import Want from '@ohos.app.ability.Want';
import { IconEditWantData } from '../../../../main/ets/default/data/IconEditWantData';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';

export function IconEditWantDataTest() {
  describe('IconEditWantDataTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getExtensionWant', 0, () => {
      const iconEditWantData = new IconEditWantData();
      expect(iconEditWantData.getExtensionWant()).assertUndefined();
    })

    it('test_setExtensionWant', 0, () => {
      const iconEditWantData = new IconEditWantData();
      const extensionWant: Want = {
        bundleName: 'com.ohos.sceneboard',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      };
      expect(iconEditWantData.setExtensionWant(extensionWant) === undefined).assertTrue();
    })
  })
}