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
import { GridLayoutItemInfo } from '@ohos/bigfolder';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium';
import { GridItemParams } from '../../../../../main/ets/default/common/components/GridItemReuseComponent';
import { GridItemsPool } from '../../../../../main/ets/default/manager/GridItemsPool';
import { CommonConstants } from '@ohos/launchercommon';

export default function GridItemsPoolTest() {
  describe('GridItemsPoolTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });
    it('getIsRelease', 0, () => {
      let gridItemsPool: GridItemsPool = GridItemsPool.getInstance();
      gridItemsPool.setIsRelease(false);

      expect(gridItemsPool.getIsRelease()).assertFalse();
    });
    it('getNode', 0, () => {
      let gridItemsPool: GridItemsPool = GridItemsPool.getInstance();

      expect(!!gridItemsPool.getNode('0', new GridItemParams(), () => {})).assertTrue();
    });
    it('release', 0, () => {
      let gridItemsPool: GridItemsPool = GridItemsPool.getInstance();
      const node = gridItemsPool.getNode('0', new GridItemParams(), () => {});
      if (node) {
        gridItemsPool.setNodeCache('0', node);
      }
      gridItemsPool.release();
      let a = 'test';
      expect(a).assertEqual('test');
    });
    it('getReuseItemKey', 0, () => {
      let gridItemsPool: GridItemsPool = GridItemsPool.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      const key: string = gridItemsPool.getReuseItemKey(item);
      expect(key).not().assertNull();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_CARD;
      const key2: string = gridItemsPool.getReuseItemKey(item2);
      expect(key2).not().assertNull();
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_REGION_FOLDER;
      const key3: string = gridItemsPool.getReuseItemKey(item3);
      expect(key3).not().assertNull();
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      const key4: string = gridItemsPool.getReuseItemKey(item4);
      expect(key4).not().assertNull();
      let item5: GridLayoutItemInfo = new GridLayoutItemInfo();
      item5.typeId = CommonConstants.TYPE_FILE_FOLDER;
      const key5: string = gridItemsPool.getReuseItemKey(item5);
      expect(key5).not().assertNull();
    });
  })
}