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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import ArrayList from '@ohos.util.ArrayList';
import { CardItemInfo, FormListInfoCacheManager } from '@ohos/launchercommon';
import BaseDataSource from '../../../../../../main/ets/default/datasource/BaseDataSource';

export function BaseDataSourceTest() {
  describe('BaseDataSourceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getDataList', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: TestDataSource = new TestDataSource();
      let list: ArrayList<CardItemInfo> = dataSource.getDataList();
      expect(list.length).assertEqual(TestDataSource.dataList.length);
      let info: CardItemInfo = new CardItemInfo();
      info.bundleName = typeof TestDataSource;
      TestDataSource.dataList.add(info);
      list = dataSource.getDataList();
      expect(list.length).assertEqual(TestDataSource.dataList.length);
    });
  })
}

class TestDataSource extends BaseDataSource {
  public static readonly TEST_THRESHOLD: number = 1;
  public static dataList: ArrayList<CardItemInfo> = new ArrayList();
  getThreshold(): number {
    return TestDataSource.TEST_THRESHOLD;
  }

  protected getInitDataList(): ArrayList<CardItemInfo> {
    return TestDataSource.dataList;
  }

  getName(): string {
    return (typeof TestDataSource);
  }
}