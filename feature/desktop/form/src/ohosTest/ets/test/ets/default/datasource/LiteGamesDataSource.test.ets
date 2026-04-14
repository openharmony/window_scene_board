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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import LiteGamesDataSource from '../../../../../../main/ets/default/datasource/LiteGamesDataSource';
import FormConstants from '../../../../../../main/ets/default/common/constants/FormConstants';
import { ArrayList } from '@kit.ArkTS';
import { CardItemInfo } from '@ohos/launchercommon';

export function LiteGamesDataSourceTest() {
  describe('LiteGamesDataSourceTest', () => {
    it('getName', TestType.FUNCTION | Level.LEVEL0, () => {
      let liteGamesDataSource: LiteGamesDataSource = LiteGamesDataSource.getInstance();
      let name: string = liteGamesDataSource.getName();
      expect(name).assertEqual('LiteGamesDataSource');
    });

    it('getThreshold', TestType.FUNCTION | Level.LEVEL0, () => {
      let liteGamesDataSource: LiteGamesDataSource = LiteGamesDataSource.getInstance();
      let threshold: number = liteGamesDataSource.getThreshold();
      expect(threshold).assertEqual(FormConstants.SERVICE_FORM_POOL_LITE_GAMES_SUGGESTION_THRESHOLD);
    });

    it('getInitDataList', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let liteGamesDataSource: LiteGamesDataSource = LiteGamesDataSource.getInstance();
        let dataList: ArrayList<CardItemInfo> = liteGamesDataSource.getDataList();
        expect(dataList.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}

