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
import IncrementDataSource from '../../../../../../main/ets/default/datasource/IncrementDataSource';
import { CardItemInfo, FormListInfoCacheManager } from '@ohos/launchercommon';

export function IncrementDataSourceTest() {
  describe('IncrementDataSourceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('onDataAdd', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: TestDataSource = new TestDataSource();
      const cacheManager: FormListInfoCacheManager = FormListInfoCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      let setCacheFunc: Function = mocker.mockFunc(cacheManager, cacheManager.setCache);
      let called: boolean = false;
      when(setCacheFunc)(ArgumentMatchers.any).afterAction(() => { called = true; });
      let info: CardItemInfo = new CardItemInfo();
      info.bundleName = 'TestDataSource';
      dataSource.onDataAdd(info);
      expect(called).assertEqual(true);
      mocker.clear(cacheManager);
    });

    it('onDataRemove', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: TestDataSource = new TestDataSource();
      const cacheManager: FormListInfoCacheManager = FormListInfoCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      let getCacheFunc: Function = mocker.mockFunc(cacheManager, cacheManager.getCache);
      let cardList: ArrayList<CardItemInfo> = new ArrayList();
      when(getCacheFunc)(ArgumentMatchers.any).afterReturn(cardList);
      let called: boolean = false;
      let setCacheFunc: Function = mocker.mockFunc(cacheManager, cacheManager.setCache);
      when(setCacheFunc)(ArgumentMatchers.any).afterAction(() => { called = true; });
      dataSource.onDataRemove('test');
      expect(called).assertEqual(false);
      mocker.clear(cacheManager);
    });

    it('onDataRemove_1', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: TestDataSource = new TestDataSource();
      const cacheManager: FormListInfoCacheManager = FormListInfoCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      let getCacheFunc: Function = mocker.mockFunc(cacheManager, cacheManager.getCache);
      let cardList: ArrayList<CardItemInfo> = new ArrayList();
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'test';
      cardItem.cardId = '123';
      cardList.add(cardItem);
      when(getCacheFunc)(ArgumentMatchers.any).afterReturn(cardList);
      let called: boolean = false;
      let setCacheFunc: Function = mocker.mockFunc(cacheManager, cacheManager.setCache);
      when(setCacheFunc)(ArgumentMatchers.any).afterAction(() => { called = true; });
      dataSource.onDataRemove('test');
      expect(called).assertEqual(true);
      mocker.clear(cacheManager);
    });
  })
}

class TestDataSource extends IncrementDataSource {
  getName(): string {
    return '';
  }

  getThreshold(): number {
    return 80;
  }

  getCacheKey(): string {
    return 'TestDataSource';
  }
}