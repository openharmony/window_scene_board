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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { DefaultDesktopLayoutInfo, SettingsModel } from '@ohos/launchercommon';
import { QueryFormDistributions } from '../../../../../../../main/ets/default/service/impl/QueryFormDistributions';

/**
 * QueryFormDistributions测试
 *
 */
export function QueryFormDistributionsTest() {
  describe('QueryFormDistributionsTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testGetLayout', 0, async (done: Function): Promise<void> => {
      const settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();

      await new QueryFormDistributions().getLayout(false);

      const layoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      await new QueryFormDistributions().getLayout(false);

      layoutInfo.layoutDescription;
      await new QueryFormDistributions().getLayout(false);

      layoutInfo.layoutDescription = {
        pageCount: 1,
        row: 6,
        column: 4,
        maxPage: 18,
        maxForm: 80
      };
      await new QueryFormDistributions().getLayout(false);

      mocker.clear(settingsModel);
      mocker.clearAll();
      done();
    });
  });
}