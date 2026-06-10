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
import { AppStorageUtil, DataProperty } from '../../../../../../main/ets/utils/AppStorageUtil';

export function AppStorageUtilTest() {
  describe('AppStorageUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('setOrCreate_PrintLogFalse', 0, (): void => {
      AppStorageUtil.setPrintLog(false);
      let dataCheck = new DataProperty(true, false);
      expect(DataProperty.toString(dataCheck)).assertInstanceOf('String');
      AppStorageUtil.setOrCreate('key1', true, dataCheck);
      expect(AppStorage.get('key1')).assertTrue();
      expect(dataCheck.dataType).assertUndefined();
    })

    it('setOrCreate_PrintLogTrue', 0, (): void => {
      AppStorageUtil.setPrintLog(true);
      let dataCheck = new DataProperty(true, false);
      AppStorageUtil.setOrCreate('key2', true, dataCheck);
      expect(AppStorage.get('key2')).assertTrue();
      expect(dataCheck.dataType).assertEqual('boolean');
    })

    it('setOrCreate_DataPropertyUndefined', 0, (): void => {
      AppStorageUtil.setPrintLog(true);
      let dataCheck = new DataProperty(true, false);
      AppStorageUtil.setOrCreate('key3', true);
      expect(AppStorage.get('key3')).assertTrue();
      expect(dataCheck.dataType).assertUndefined();
    })

    it('setOrCreate_DataType', 0, (): void => {
      AppStorageUtil.setPrintLog(true);
      let dataCheck = new DataProperty(true, false, 'AppItem');
      AppStorageUtil.setOrCreate('key4', true, dataCheck);
      expect(AppStorage.get('key4')).assertTrue();
      expect(dataCheck.dataType).assertEqual('AppItem');
    })
  })
}