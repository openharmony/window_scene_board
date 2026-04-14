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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { CommonConstants, GridLayoutItemInfo, LaunchLayoutCacheManager } from 'launchercommon';
import { CacheManager } from '../../../../main/ets/default/manager/CacheManager';

export default function CacheManagerTest() {
  describe('CacheManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('getAllSameBundleNameAppItem', 0, () => {
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.iconResource = '';
      item.appName = 'appname';
      item.intent = '';
      when(mockFunc)(ArgumentMatchers.any).afterReturn([item]);

      let retArr: GridLayoutItemInfo[] = CacheManager.getInstance().getAllSameBundleNameAppItem('');
      expect(retArr.length).assertEqual(1);
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('getAppFromCache', 0, () => {
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.iconResource = '';
      item.appName = 'appname';
      item.intent = '';
      item.appIndex = CommonConstants.MAIN_APP_INDEX;
      item.typeId = CommonConstants.TYPE_CARD;
      when(mockFunc)(ArgumentMatchers.any).afterReturn([item]);

      let retItem = CacheManager.getInstance().getAppFromCache('');
      expect(retItem).assertUndefined();
      mocker.clear(launchManager);
      mocker.clearAll();
    })
  })
}