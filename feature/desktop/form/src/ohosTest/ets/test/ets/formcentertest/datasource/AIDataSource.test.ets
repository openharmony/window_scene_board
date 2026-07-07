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
import AIDataSource from '../../../../../../main/ets/default/datasource/AIDataSource';
import FormConstants from '../../../../../../main/ets/default/common/constants/FormConstants';

export function AIDataSourceTest() {
  describe('AIDataSourceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('AIDataSourceTest_getName', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: AIDataSource = AIDataSource.getInstance();
      const rstName: string = dataSource.getName();
      expect(rstName).assertEqual('AIDataSource');
    });

    it('AIDataSourceTest_getThreshold', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: AIDataSource = AIDataSource.getInstance();
      const threshold: number = dataSource.getThreshold();
      expect(threshold).assertEqual(FormConstants.SERVICE_FORM_POOL_AI_SUGGESTION_THRESHOLD);
    });
  })
}