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
import { beforeEach, describe, expect, it } from '@ohos/hypium';
import { ContextUtil, createPreference, PreferenceApi } from '@ohos/themeservicebase/Index';

export default function PreferenceApiTest() {
  describe('PreferenceApiTest', () => {
    let preferenceApi: PreferenceApi;
    beforeEach(() => {
      preferenceApi = createPreference(ContextUtil.getTsApplicationContext(), `ts_config`);
    })

    it('test001_boolean', 0, async () => {
      await preferenceApi.putBoolean('keyBoolean', true);
      expect(await preferenceApi.has('keyBoolean')).assertTrue();
      expect(await preferenceApi.getBoolean('keyBoolean', false)).assertTrue();
    })

    it('test002_string', 0, async () => {
      await preferenceApi.putString('keyString', 'test001_string_success');
      expect(await preferenceApi.has('keyString')).assertTrue();
      expect(await preferenceApi.getString('keyString', '')).assertEqual('test001_string_success');
    })

    it('test003_Array', 0, async () => {
      let testArray: string[] = ['1', '2', '3', '4'];
      await preferenceApi.put('keyArray', testArray);
      expect(await preferenceApi.has('keyArray')).assertTrue();
      expect(await preferenceApi.get('keyArray')).assertDeepEquals(testArray);
    })

    it('test004_delete', 0, async () => {
      await preferenceApi.putString('key_delete', 'test004_delete');
      expect(await preferenceApi.has('key_delete')).assertTrue();
      await preferenceApi.delete('key_delete');
      expect(await preferenceApi.has('key_delete')).assertFalse();
    })

    it('test005_clear', 0, async () => {
      await preferenceApi.putString('keyString', 'test005_clear');
      expect(await preferenceApi.has('keyString')).assertTrue();
      await preferenceApi.clear();
      expect(await preferenceApi.has('keyString')).assertFalse();
    })
  })
}