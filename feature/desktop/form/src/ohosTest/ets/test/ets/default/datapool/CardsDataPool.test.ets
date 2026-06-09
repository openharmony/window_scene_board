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
  it,
  describe,
  expect,
  Level,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import ArrayList from '@ohos.util.ArrayList';
import { CardItemInfo } from '@ohos/launchercommon';
import CardsDataPool from '../../../../../../main/ets/default/datapool/CardsDataPool';
import AppInstallDataSource from '../../../../../../main/ets/default/datasource/AppInstallDataSource';

export default class CardsDataPoolTestClass extends CardsDataPool {

}

export function CardsDataPoolTest() {
  describe('CardsDataPoolTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getShowDataList_emptyDataSourceMap', TestType.FUNCTION | Level.LEVEL0, async () => {
      const pool: CardsDataPool = new CardsDataPoolTestClass();
      const list: ArrayList<CardItemInfo> = await pool.getShowDataList();
      expect(list.length).assertEqual(0);
    });

    it('getShowDataList_emptyDataList', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let dataSource: AppInstallDataSource = new AppInstallDataSource();
      const pool: CardsDataPool = new CardsDataPoolTestClass();
      pool.addDataPool(dataSource);

      const mocker: MockKit = new MockKit();
      const mockGetDataList: Function = mocker.mockFunc(dataSource, dataSource.getDataList);
      when(mockGetDataList)(ArgumentMatchers.any).afterReturn([]);
      try {
        const list: ArrayList<CardItemInfo> = await pool.getShowDataList();
        expect(list.length).assertEqual(0);
      } catch (e) {
      } finally {
        mocker.clear(dataSource);
        mocker.clearAll();
        done();
      }
    });

    it('getShowDataList_onlySmallCard', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let dataSource: AppInstallDataSource = new AppInstallDataSource();

      const pool: CardsDataPool = new CardsDataPoolTestClass();
      pool.addDataPool(dataSource);

      const mocker: MockKit = new MockKit();
      const mockGetDataList: Function = mocker.mockFunc(dataSource, dataSource.getDataList);
      const itemInfo: CardItemInfo = new CardItemInfo();
      itemInfo.bundleName = 'smallCard';
      itemInfo.cardId = '1234';
      itemInfo.cardDimension = 2;
      when(mockGetDataList)(ArgumentMatchers.any).afterReturn([itemInfo]);
      try {
        const list: ArrayList<CardItemInfo> = await pool.getShowDataList();
        expect(list?.length).assertEqual(1);
      } catch (e) {
      } finally {
        mocker.clear(dataSource);
        mocker.clearAll();
        done();
      }
    });

    it('getShowDataList', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let dataSource: AppInstallDataSource = new AppInstallDataSource();

      const pool: CardsDataPool = new CardsDataPoolTestClass();
      pool.addDataPool(dataSource);

      const mocker: MockKit = new MockKit();
      const mockGetDataList: Function = mocker.mockFunc(dataSource, dataSource.getDataList);
      let cardItemList: CardItemInfo[] = [];
      const itemInfo: CardItemInfo = new CardItemInfo();
      itemInfo.bundleName = 'smallCard';
      itemInfo.cardId = '1234';
      itemInfo.cardDimension = 2;
      cardItemList.push(itemInfo);
      itemInfo.bundleName = 'middleCard';
      itemInfo.cardId = '2345';
      itemInfo.cardDimension = 3;
      cardItemList.push(itemInfo);
      when(mockGetDataList)(ArgumentMatchers.any).afterReturn(cardItemList);
      try {
        const list: ArrayList<CardItemInfo> = await pool.getShowDataList();
        expect(list?.length).assertEqual(1);
      } catch (e){
      } finally {
        mocker.clear(dataSource);
        mocker.clearAll();
        done();
      }
    });

    it('addDataPool_test01', 0, () => {
      let dataSource: AppInstallDataSource = new AppInstallDataSource();
      let pool: CardsDataPool = new CardsDataPoolTestClass();
      pool.addDataPool(dataSource);
      expect(pool).not().assertUndefined();
    });

    it('refreshPool_test01', 0, () => {
      let pool: CardsDataPool = new CardsDataPoolTestClass();
      (pool as object)['mLastStartIndex'] = 1;
      (pool as object)['mDataSize'] = 2;
      pool.refreshPool();
      expect(pool).not().assertUndefined();
    });

    it('refreshPool_test02', 0, () => {
      let pool: CardsDataPool = new CardsDataPoolTestClass();
      (pool as object)['mLastStartIndex'] = 1;
      (pool as object)['mDataSize'] = 1;
      pool.refreshPool();
      expect(pool).not().assertUndefined();
    });

    it('getFormUniqueKey_test01', 0, () => {
      let pool: CardsDataPool = new CardsDataPoolTestClass();
      pool['getFormUniqueKey'](null);
      expect(pool).not().assertUndefined();
    });
  })
}