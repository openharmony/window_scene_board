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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType } from '@ohos/hypium';
import ArrayList from '@ohos.util.ArrayList';
import AppUpdateDataSource from '../../../../../../main/ets/default/datasource/AppUpdateDataSource';
import FormConstants from '../../../../../../main/ets/default/common/constants/FormConstants';

export function AppUpdateDataSourceTest() {
  describe('AppUpdateDataSourceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('AppUpdateDataSourceTest_getThreshold', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: AppUpdateDataSource = AppUpdateDataSource.getInstance();
      const threshold: number = dataSource.getThreshold();
      expect(threshold).assertEqual(FormConstants.SERVICE_FORM_POOL_UPDATE_APP_THRESHOLD);
    });
  })
}