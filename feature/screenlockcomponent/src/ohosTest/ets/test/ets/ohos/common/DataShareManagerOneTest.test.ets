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
import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';
import { AsyncCallback, Callback } from '@ohos.base';
import { sSettingsUtil } from '@ohos/frameworkwrapper';

export default function DataShareManagerOneTest() {

  describe('DataShareManagerOneTest', (): void => {
    let callback: Callback<void> = () => {
      return false
    };
    let asyncCallback: AsyncCallback<void> = () => {
      return false
    };
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance_return', 0, (): void => {
      let key: string = 'res';
      DataShareManager.getInstance();
      DataShareManager.getInstance().registerDataShareListener(key, callback);
      expect(key).assertEqual('res');
    })

    it('test_registerSecureDataShareListener_return', 0, (): void => {
      let key: string = 'res';
      DataShareManager.getInstance().registerSecureDataShareListener(key, asyncCallback);
      expect(key).assertEqual('res');
    })

    it('test_registerUserSettingsDataShareListener_return', 0, (): void => {
      let key: string = 'res';
      DataShareManager.getInstance().registerUserSettingsDataShareListener(key, callback);
      expect(key).assertEqual('res');
    })

    it('test_unregisterDataShareListener_return', 0, (): void => {
      let key: string = 'res';
      DataShareManager.getInstance().unregisterDataShareListener(key);
      expect(key).assertEqual('res');
    })

    it('test_unregisterSecureDataShareListener_return', 0, (): void => {
      let key: string = 'res';
      DataShareManager.getInstance().unregisterSecureDataShareListener(key);
      expect(key).assertEqual('res');
    })

    it('test_unregisterUserSettingsDataShareListener_return', 0, (): void => {
      let key: string = 'res';
      DataShareManager.getInstance().unregisterUserSettingsDataShareListener(key);
      expect(key).assertEqual('res');
    })

    it('test_getValue_return', 0, (): void => {
      let key: string = 'res1';
      let defaultVal: string = 'res2';
      DataShareManager.getInstance().getValue(key, defaultVal);
      expect(sSettingsUtil.getValue(key, defaultVal)).assertEqual('res2');
    })
  })
}