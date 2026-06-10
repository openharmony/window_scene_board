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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import ScreenLockPreferencesUtil from '../../../../../../main/ets/common/ScreenLockPreferencesUtil';
import type { Context } from '@ohos.abilityAccessCtrl';
import dataPreferences from '@ohos.data.preferences';
import type { ValueType } from '@ohos.data.ValuesBucket';



export default function ScreenLockPreferencesUtilTest() {
  let context: Context;
  describe('ScreenLockPreferencesUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_GetPreferencesFromStorage_return', 0, (): void => {

      ScreenLockPreferencesUtil.getPreferencesFromStorage(context);

      let key: string = '';
      let value: dataPreferences.ValueType = 0;
      ScreenLockPreferencesUtil.put(context,key,value);

      let key1: string = 'no';
      let value1: dataPreferences.ValueType = 1;
      ScreenLockPreferencesUtil.put(context,key1,value1);

      let key2: string = '';
      let defValue: ValueType = 1;
      ScreenLockPreferencesUtil.get(context,key2,defValue);

      let key3: string = 'NO';
      let defValue1: ValueType = 1;
      ScreenLockPreferencesUtil.get(context,key3,defValue1);
      expect(defValue).not().assertNull();
    })


  })
}