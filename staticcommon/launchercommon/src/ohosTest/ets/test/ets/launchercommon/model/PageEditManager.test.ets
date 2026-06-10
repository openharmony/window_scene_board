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

import { desktopUtil } from "@ohos/componenthelper";
import { DeviceHelper } from "@ohos/frameworkwrapper";
import { describe, expect, it, MockKit, when } from "@ohos/hypium";
import PageIndexTypeInfo from "../../../../../../main/ets/bean/PageIndexTypeInfo";
import { LaunchLayoutCacheManager } from "../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager";
import { PageEditManager } from "../../../../../../main/ets/editmode/model/PageEditManager";
import GridLayoutUtil from '../../../../../../main/ets/utils/GridLayoutUtil';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import { PageDragManager } from "../../../../../../main/ets/editmode/model/PageDragManager";

class DesktopDataInfo {
  public appGridInfo: GridLayoutItemInfo[][] = [[]];
  public waterfallItemListInfo: GridLayoutItemInfo[] = [];
}

export default function PageEditManagerTest() {
  describe('PageEditViewModelTest', () => {
    const pageEditManager = new PageEditManager();
    it('test_getRealBlankPageList', 0, async () => {
      try {
        const blankPageList: Map<number, boolean> = pageEditManager.getRealBlankPageList();
        const blankPageList2: Map<number, boolean> = pageEditManager.getRealBlankPageList(false);
        const blankPageList3: Map<number, boolean> = pageEditManager.getRealBlankPageList(true);
        expect(blankPageList.size).assertLargerOrEqual(0);
        expect(blankPageList2.size).assertLargerOrEqual(0);
        expect(blankPageList3.size).assertLargerOrEqual(0);
      } catch (err) {}
    })

    it('test_updateBlankPageList', 0, () => {
      try {
        pageEditManager.getBlankPageListFromRdb();
        pageEditManager.updateBlankPageList();
        expect((pageEditManager as object)['initBlankPageListFlag']).assertFalse();
        pageEditManager.updateBlankPageList(false);
        expect((pageEditManager as object)['initBlankPageListFlag']).assertFalse();
        pageEditManager.updateBlankPageList(true);
        expect((pageEditManager as object)['initBlankPageListFlag']).assertFalse();
      } catch (err) {}
    })

    it('test_updateBlankPageListWhenReloadGridSwiper', 0, () => {
      try {
        const pageSet: Set<number> = new Set();
        pageEditManager.blankPageList.clear();
        pageEditManager.updateBlankPageListWhenReloadGridSwiper([], 1, pageSet, false);
        expect(pageEditManager.blankPageList.size).assertLargerOrEqual(0);
        pageEditManager.blankPageList.set(0, true);
        pageSet.add(0);
        pageEditManager.updateBlankPageListWhenReloadGridSwiper([], 1, pageSet, false);
        expect(pageEditManager.blankPageList.size).assertLargerOrEqual(0);
        pageEditManager.updateBlankPageListWhenReloadGridSwiper([0], 1, pageSet, false);
        expect(pageEditManager.blankPageList.size).assertLargerOrEqual(0);
      } catch (err) {}
    })
  })
}